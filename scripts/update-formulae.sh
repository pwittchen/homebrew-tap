#!/usr/bin/env bash
# Updates the formulae and casks in this tap to the latest releases of their
# projects and commits each bump as `<name> <version>`; pushing is left to the
# caller.
#
#   scripts/update-formulae.sh [name] [version]
#
# With no arguments everything in Formula/ and Casks/ is updated. A version
# (X.Y.Z) pins that release instead of the latest one. Needs `gh` (authenticated,
# or GH_TOKEN set); runs `brew style` when brew is available.

set -euo pipefail

cd "$(dirname "$0")/.."

# The source repo of a formula.
repo_of() {
    case "$1" in
        jrs) echo pwittchen/jrs ;;
        kayet) echo pwittchen/kayet ;;
        *) echo "error: no source repo known for '$1'" >&2; exit 1 ;;
    esac
}

# The file of a formula or cask.
file_of() {
    if [ -f "Casks/$1.rb" ]; then echo "Casks/$1.rb"; else echo "Formula/$1.rb"; fi
}

# The version a formula's url lines or a cask's version line point at.
current_version() {
    sed -n -e 's|.*/releases/download/v\([0-9][^/]*\)/.*|\1|p' \
        -e 's|^ *version "\(.*\)"$|\1|p' "$1" | sort -u
}

# Writes the generated formula of jrs <version> to <dest>, from the release
# run's package-manifests artifact, or else by rerunning that tag's
# packaging/manifests.sh on the release's SHA256SUMS (what the run does).
fetch_jrs() {
    local version="$1" sums="$2" dest="$3" work run
    work="$(mktemp -d)"

    run="$(gh run list -R pwittchen/jrs -w Rust -b "v$version" -e push -L 1 \
        --json databaseId,conclusion \
        -q '.[0] | select(.conclusion=="success") | .databaseId' 2>/dev/null || true)"
    if [ -n "$run" ] &&
        gh run download "$run" -R pwittchen/jrs -n package-manifests -D "$work/artifact" 2>/dev/null &&
        [ -f "$work/artifact/homebrew/jrs.rb" ]; then
        echo "jrs: using the package-manifests artifact of run $run"
        cp "$work/artifact/homebrew/jrs.rb" "$dest"
    else
        echo "jrs: artifact unavailable, regenerating with manifests.sh from v$version"
        mkdir -p "$work/scripts"
        gh api "repos/pwittchen/jrs/contents/packaging/manifests.sh?ref=v$version" \
            -H "Accept: application/vnd.github.raw" > "$work/scripts/manifests.sh"
        sh "$work/scripts/manifests.sh" "$version" "$sums" "$work/out"
        cp "$work/out/homebrew/jrs.rb" "$dest"
    fi
    rm -rf "$work"
}

# Rewrites the version and checksums of Casks/kayet.rb for <version>, from the
# digests GitHub records for the release's .dmg assets.
update_kayet() {
    local version="$1" file="$2" arm intel
    digest() {
        gh release view "v$version" -R pwittchen/kayet --json assets \
            -q ".assets[] | select(.name == \"kayet-macos-$1.dmg\") | .digest" |
            sed -n 's/^sha256:\([0-9a-f]\{64\}\)$/\1/p'
    }
    arm="$(digest aarch64)"
    intel="$(digest x86_64)"
    if [ -z "$arm" ] || [ -z "$intel" ]; then
        echo "error: v$version has no sha256 digest for both .dmg assets" >&2; exit 1
    fi
    sed -e "s/^\( *version \)\".*\"$/\1\"$version\"/" \
        -e "s/^\( *sha256 arm: *\)\"[0-9a-f]*\"/\1\"$arm\"/" \
        -e "s/^\( *intel: *\)\"[0-9a-f]*\"/\1\"$intel\"/" \
        "$file" > "$file.new"
    mv "$file.new" "$file"
}

# Fails unless every url in <formula> points at v<version> and its sha256
# is the one <sums> lists for that asset.
verify() {
    local file="$1" version="$2" sums="$3"
    awk -v version="$version" -v sums="$sums" '
        BEGIN {
            while ((getline line < sums) > 0) {
                split(line, f, /[ \t]+/); n = f[2]; sub(/^\*/, "", n); sum[n] = f[1]
            }
        }
        /^ *url "/ {
            url = $2; gsub(/"/, "", url); urls++
            if (url !~ "/releases/download/v" version "/") { print "error: " url " is not v" version; bad = 1 }
            asset = url; sub(/.*\//, "", asset); next
        }
        /^ *sha256 "/ {
            s = $2; gsub(/"/, "", s)
            if (asset == "" || sum[asset] != s) { print "error: sha256 of " asset " does not match SHA256SUMS"; bad = 1 }
            asset = ""
        }
        END {
            if (urls == 0) { print "error: no url in formula"; bad = 1 }
            exit bad
        }' "$file" >&2
}

update() {
    local formula="$1" pinned="${2:-}" file repo current latest work
    file="$(file_of "$formula")"
    [ -f "$file" ] || { echo "error: $file not found" >&2; exit 1; }
    repo="$(repo_of "$formula")"
    current="$(current_version "$file")"

    if [ -n "$pinned" ]; then
        latest="${pinned#v}"
    else
        latest="$(gh release view -R "$repo" --json tagName -q .tagName)"
        latest="${latest#v}"
    fi
    if ! [[ "$latest" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "error: '$latest' is not a version (X.Y.Z)" >&2; exit 1
    fi
    if [ "$current" = "$latest" ]; then
        echo "$formula: already up to date ($current)"
        return
    fi

    case "$formula" in
        jrs)
            work="$(mktemp -d)"
            gh release download "v$latest" -R "$repo" -p SHA256SUMS -D "$work"
            fetch_jrs "$latest" "$work/SHA256SUMS" "$file"
            verify "$file" "$latest" "$work/SHA256SUMS"
            rm -rf "$work"
            ;;
        kayet) update_kayet "$latest" "$file" ;;
    esac

    if command -v brew >/dev/null; then
        brew style "$file"
    fi

    echo "$formula: $current -> $latest"
    git diff --stat -- "$file"
    git add -- "$file"
    git commit -q -m "$formula $latest"
}

if [ $# -gt 0 ] && [ "$1" != all ]; then
    update "$1" "${2:-}"
else
    [ $# -lt 2 ] || [ -z "$2" ] || { echo "error: a version needs a name" >&2; exit 2; }
    for f in Formula/*.rb Casks/*.rb; do
        update "$(basename "$f" .rb)"
    done
fi
