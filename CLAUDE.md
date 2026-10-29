# CLAUDE.md

Homebrew tap for [pwittchen](https://github.com/pwittchen)'s projects, installed
as `brew install pwittchen/tap/<formula>`.

## Layout

- `Formula/<name>.rb` — one formula per project.
- `README.md` — install line plus a table of formulae; keep it in sync when a
  formula is added or removed.

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

## Updating formulae

`scripts/update-formulae.sh [formula] [version]` does it without Claude: finds
the latest release (or the pinned version), fetches the generated formula
(artifact, else rerunning that tag's `manifests.sh`), checks every url/sha256
against the release's `SHA256SUMS`, runs `brew style`, and commits
`<formula> <version>` (no push). The **Update formulae** workflow
(`.github/workflows/update-formulae.yml`, manual `workflow_dispatch`) runs it
and pushes to master. In CI the repo-scoped token usually can't download
another repo's artifacts, so it takes the regenerate path — same output.

Or use the `/update-formulae` skill (`.claude/skills/update-formulae`). It finds
the latest release of each project, fetches the generated formula, verifies it,
and commits one commit per formula.

## Conventions

- Commit message for a version bump: `<formula> <version>` (e.g. `jrs 0.14.6`),
  no `v` prefix.
- Check a formula with `brew style Formula/<name>.rb` and, when possible,
  `brew audit --formula --strict pwittchen/tap/<name>`.
