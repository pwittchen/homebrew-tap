---
name: update-formulae
description: Update the formulae and casks in this Homebrew tap to the latest released versions of their projects (currently jrs and kayet). Use when the user asks to update, bump, or sync formulae or casks, or after a new jrs or kayet release.
argument-hint: "[formula] [version]"
---

# Update formulae to the latest releases

Arguments (optional): a formula name to limit the update to, and a version to
pin instead of the latest release. With no arguments, update every formula.

Work from the repo root. Put downloads in the session scratchpad, one fresh
directory per formula.

## 1. Find what's outdated

For each formula in `Formula/`:

1. Current version: parse it from the `url` lines (`/releases/download/v<X.Y.Z>/`).
2. Latest version:
   ```sh
   gh release view -R pwittchen/<repo> --json tagName -q .tagName   # e.g. v0.14.7
   ```
   Skip drafts/prereleases (`gh release view` without a tag already returns the
   latest non-prerelease).
3. If they match, report "already up to date" and move on.

Formula → repo mapping:

| Formula | Repo |
| --- | --- |
| `jrs` | `pwittchen/jrs` |
| `kayet` (cask) | `pwittchen/kayet` |

For the `kayet` cask run `scripts/update-formulae.sh kayet [version]`: it
rewrites `version` and both `sha256`s of `Casks/kayet.rb` from the release's
asset digests and commits. Sections 2–3 below are about jrs.

## 2. Get the generated formula (jrs)

`Formula/jrs.rb` must be the exact output of the jrs release's
`packaging/manifests.sh`; never hand-edit versions or checksums.

**Preferred — the release run's `package-manifests` artifact:**

```sh
run=$(gh run list -R pwittchen/jrs -w Rust -b v<VERSION> -e push -L 1 \
        --json databaseId,conclusion -q '.[0] | select(.conclusion=="success") | .databaseId')
gh run download "$run" -R pwittchen/jrs -n package-manifests -D "$dir"
cp "$dir/homebrew/jrs.rb" Formula/jrs.rb
```

**Fallback — the artifact expired or the run is missing:** regenerate it with
the script and checksums from that exact tag (same result as CI):

```sh
gh release download v<VERSION> -R pwittchen/jrs -p SHA256SUMS -D "$dir"
gh api "repos/pwittchen/jrs/contents/packaging/manifests.sh?ref=v<VERSION>" \
   -H "Accept: application/vnd.github.raw" > "$scripts/manifests.sh"
sh "$scripts/manifests.sh" <VERSION> "$dir/SHA256SUMS" "$dir/out"
cp "$dir/out/homebrew/jrs.rb" Formula/jrs.rb
```

Keep `manifests.sh` outside the download directory. Read it before running it;
it should only write files under its out-dir. If neither path works, stop and
tell the user — don't build the formula by hand.

## 3. Verify

- `git diff Formula/` — expect version bumps in the URLs and new `sha256`s; call
  out any other change (deps, caveats, install block) to the user.
- Every `url` points at `v<VERSION>`, and each `sha256` matches the release's
  `SHA256SUMS` for that asset.
- `brew style Formula/<name>.rb` if `brew` is available. Optionally
  `brew audit --formula --strict` / `brew install --build-from-source` on request
  only — they're slower and touch the local Homebrew install.

## 4. Commit

- Update `README.md` only if a formula was added/removed or its description
  changed.
- One commit per formula, message `<formula> <version>` (e.g. `jrs 0.14.7`).
- Don't push unless the user asks.

Finish with a short summary: each formula, old → new version, and anything
skipped or unusual.
