#!/usr/bin/env bash
# Report, and optionally delete, top-level entries of the Ergodis cache root
# that no committed evidence file names.
#
# The shared target/ and bin/ directories are never candidates: target/ is the
# one build directory per crate and bin/ holds retained A/B baselines.
#
# usage: cache-gc.sh [--apply]
set -euo pipefail

script_dir=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=lib.sh
. "$script_dir/lib.sh"

core_root=$(cd "$script_dir/.." && pwd)
repo_root=$(cd "$core_root/../../.." && pwd)

evidence_files=()
for dir in "$core_root/evidence" "$repo_root/ergodis-private/evidence"; do
  [[ -d $dir ]] || continue
  while IFS= read -r f; do
    evidence_files+=("$f")
  done < <(find "$dir" -type f -name '*.json' | sort)
done

apply=0
case ${1:-} in
  --apply) apply=1 ;;
  --help|-h)
    echo "usage: cache-gc.sh [--apply]" >&2
    echo "  default: dry run, printing a table of cache entries and their references" >&2
    echo "  --apply: rm -rf each UNREFERENCED entry, one exact named path at a time" >&2
    exit 0
    ;;
  "") ;;
  *) echo "cache-gc.sh: unknown argument: $1" >&2; exit 2 ;;
esac

cache_root=$(ergodis_cache_root)
if [[ ! -d $cache_root ]]; then
  echo "cache-gc.sh: no cache root at $cache_root" >&2
  exit 0
fi

printf '%10s  %8s  %-44s  %s\n' SIZE AGE NAME REFERENCED-BY
printf '%10s  %8s  %-44s  %s\n' ---- --- ---- -------------

unreferenced=()
now=$(date +%s)

while IFS= read -r entry; do
  name=$(basename "$entry")
  case $name in
    target|bin) continue ;;
  esac

  size=$(du -sh "$entry" 2>/dev/null | cut -f1)
  mtime=$(stat -c %Y "$entry")
  age_days=$(( (now - mtime) / 86400 ))

  refs=
  if (( ${#evidence_files[@]} )); then
    refs=$( { grep -l -F -- "$name" "${evidence_files[@]}" 2>/dev/null || true; } \
            | head -n 3 | xargs -r -n1 basename | paste -sd, - )
  fi

  if [[ -z $refs ]]; then
    refs=UNREFERENCED
    unreferenced+=("$entry")
  fi

  printf '%10s  %6dd  %-44s  %s\n' "$size" "$age_days" "$name" "$refs"
done < <(find "$cache_root" -mindepth 1 -maxdepth 1 | sort)

echo
echo "unreferenced entries: ${#unreferenced[@]}"

if (( apply == 0 )); then
  echo "dry run; re-run with --apply to delete the UNREFERENCED entries"
  exit 0
fi

for entry in "${unreferenced[@]}"; do
  echo "removing $entry"
  rm -rf -- "$entry"
done
