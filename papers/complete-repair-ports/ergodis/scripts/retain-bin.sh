#!/usr/bin/env bash
# Build a binary into its crate's shared target directory and retain a hashed
# copy as an A/B baseline. Retained executables are the only sanctioned way to
# keep a control for an interleaved A/B; never keep a whole target directory.
#
# usage: retain-bin.sh <crate-dir> <bin> [--example] [--profile P] [--features F]
set -euo pipefail

script_dir=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=lib.sh
. "$script_dir/lib.sh"

usage() {
  cat >&2 <<'USAGE'
usage: retain-bin.sh <crate-dir> <bin> [--example] [--profile PROFILE] [--features FEATURES]

Builds <bin> from <crate-dir> into the crate's shared target directory, then
copies it to $ERGODIS_CACHE_ROOT/bin/<bin>-<git-short-sha>[-<profile>][-<features>]
with a .sha256 sidecar, and appends a row to that directory's MANIFEST.tsv.

Idempotent: an existing retained copy with the same hash is reported and the
script exits 0; an existing copy with a different hash is refused.
USAGE
}

if [[ ${1:-} == --help || ${1:-} == -h ]]; then
  usage
  exit 0
fi
if (( $# < 2 )); then
  usage
  exit 2
fi

crate_dir=$1
bin=$2
shift 2

profile=release
features=
kind=bin

while (( $# )); do
  case $1 in
    --profile) profile=${2:?--profile needs a value}; shift 2 ;;
    --features) features=${2:?--features needs a value}; shift 2 ;;
    --example) kind=example; shift ;;
    --help|-h) usage; exit 0 ;;
    *) echo "retain-bin.sh: unknown argument: $1" >&2; usage; exit 2 ;;
  esac
done

if [[ ! -d $crate_dir ]]; then
  echo "retain-bin.sh: no such crate directory: $crate_dir" >&2
  exit 2
fi
crate_dir=$(cd "$crate_dir" && pwd)

cache_root=$(ergodis_cache_root)
bin_dir="$cache_root/bin"
manifest="$bin_dir/MANIFEST.tsv"
mkdir -p "$bin_dir"

build_args=(build "--$kind" "$bin")
case $profile in
  dev|debug) ;;
  release) build_args+=(--release) ;;
  *) build_args+=(--profile "$profile") ;;
esac
[[ -n $features ]] && build_args+=(--features "$features")

( cd "$crate_dir" && cargo "${build_args[@]}" )

if [[ $kind == example ]]; then
  built="$(dirname "$(ergodis_bin "$crate_dir" "$profile" "$bin")")/examples/$bin"
else
  built=$(ergodis_bin "$crate_dir" "$profile" "$bin")
fi
if [[ ! -x $built ]]; then
  echo "retain-bin.sh: expected executable not found: $built" >&2
  exit 1
fi

rev=$(git -C "$crate_dir" rev-parse --short HEAD)
# Repo-wide, not crate-scoped: a build depends on every path the crate's
# dependency graph reaches, so a clean crate directory is not a clean baseline.
if [[ -n $(git -C "$crate_dir" status --porcelain) ]]; then
  dirty=dirty
else
  dirty=clean
fi
rustc_version=$(rustc --version)

name="$bin-$rev"
[[ $profile != release ]] && name="$name-$profile"
if [[ -n $features ]]; then
  name="$name-${features//[^A-Za-z0-9._-]/_}"
fi
retained="$bin_dir/$name"

hash=$(sha256sum "$built" | cut -d' ' -f1)

if [[ -e $retained ]]; then
  existing=$(sha256sum "$retained" | cut -d' ' -f1)
  if [[ $existing == "$hash" ]]; then
    echo "retain-bin.sh: already retained with the same hash: $retained"
    exit 0
  fi
  echo "retain-bin.sh: refusing to overwrite $retained" >&2
  echo "  retained sha256 $existing" >&2
  echo "  rebuilt  sha256 $hash" >&2
  echo "  the same git rev produced a different executable; retain under a distinct name" >&2
  exit 1
fi

cp -p "$built" "$retained"
printf '%s  %s\n' "$hash" "$name" > "$retained.sha256"

if [[ ! -s $manifest ]]; then
  printf 'timestamp\tpath\tsha256\tgit_rev\tdirty\trustc\tprofile\tfeatures\n' > "$manifest"
fi
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  "$(date -Iseconds)" "$retained" "$hash" "$rev" "$dirty" \
  "$rustc_version" "$profile" "${features:--}" >> "$manifest"

echo "retained $retained"
echo "sha256   $hash"
