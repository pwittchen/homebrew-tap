# CLAUDE.md

Homebrew tap for [pwittchen](https://github.com/pwittchen)'s projects, installed
as `brew install pwittchen/tap/<formula>` or
`brew install --cask pwittchen/tap/<cask>`.

## Layout

- `Formula/<name>.rb` — one formula per CLI project.
- `Casks/<name>.rb` — one cask per macOS app.
- `README.md` — install lines plus tables of formulae and casks; keep it in sync
  when one is added or removed.

## Formulae

| Formula | Source repo | Where the formula comes from |
| --- | --- | --- |
| `jrs` | [pwittchen/jrs](https://github.com/pwittchen/jrs) | Generated per release by `packaging/manifests.sh` in the jrs repo |

### jrs

`Formula/jrs.rb` is **generated, not hand-written**. Each `v*` tag in
pwittchen/jrs runs the `release` job of `.github/workflows/rust.yml` (workflow
name "Rust"), which calls
`packaging/manifests.sh <version> SHA256SUMS <out-dir>` and uploads the result
as the `package-manifests` artifact (`homebrew/jrs.rb` inside it). Copy that
file over `Formula/jrs.rb` verbatim.

- Don't edit `Formula/jrs.rb` by hand. If the formula itself needs to change
  (deps, caveats, install steps), change `packaging/manifests.sh` in the jrs
  repo; the next release carries it here.
- Release assets are prebuilt binaries for macOS/Linux × arm/intel; the
  checksums come from the release's `SHA256SUMS`.
- The jrs repo is usually checked out next to this one at `../jrs`.

## Casks

| Cask | Source repo | Where the cask comes from |
| --- | --- | --- |
| `kayet` | [pwittchen/kayet](https://github.com/pwittchen/kayet) | Hand-written; `update-formulae.sh` bumps `version` and `sha256` |

### kayet

`Casks/kayet.rb` installs the signed, notarized `.dmg` of a release
(`kayet-macos-{aarch64,x86_64}.dmg`), plus the `kayet` command. Unlike jrs it is
edited here. A bump only touches `version` and the two `sha256`s, taken from the
`digest` GitHub records for each release asset (there is no `SHA256SUMS`).

- kayet updates itself in place, hence `auto_updates true`: `brew upgrade` skips
  it unless `--greedy` is given, so a stale `version` here breaks nothing.
- `zap` must never trash `~/.kayet` as a whole: the default workspace, with the
  user's notes, is `~/.kayet/workspace`.

## Updating formulae

`scripts/update-formulae.sh [name] [version]` does it without Claude: finds the
latest release (or the pinned version), fetches the generated formula (artifact,
else rerunning that tag's `manifests.sh`), checks every url/sha256 against the
release's `SHA256SUMS` (for the kayet cask: rewrites `version` and `sha256` from
the release's asset digests), runs `brew style`, and commits `<name> <version>`
(no push). The **Update formulae** workflow
(`.github/workflows/update-formulae.yml`, `workflow_dispatch`) runs it and
pushes to master; start it by hand for jrs, while each kayet release starts it
from its `release.yml` (`HOMEBREW_TAP_TOKEN` secret in pwittchen/kayet). In CI the repo-scoped token usually can't download
another repo's artifacts, so it takes the regenerate path — same output.

Or use the `/update-formulae` skill (`.claude/skills/update-formulae`). It finds
the latest release of each project, fetches the generated formula, verifies it,
and commits one commit per formula.

## Conventions

- **NEVER `git push`.** Commit locally only; the user pushes themselves.

- Commit message for a version bump: `<formula> <version>` (e.g. `jrs 0.14.6`),
  no `v` prefix.
- Check a formula with `brew style Formula/<name>.rb` and, when possible,
  `brew audit --formula --strict pwittchen/tap/<name>`; a cask with
  `brew style Casks/<name>.rb` and `brew audit --cask --strict pwittchen/tap/<name>`.
