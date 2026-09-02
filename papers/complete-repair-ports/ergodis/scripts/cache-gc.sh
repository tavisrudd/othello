#!/usr/bin/env bash
# Report, and optionally delete, top-level entries of the Ergodis cache root
# that no committed evidence, docs, note, or retained-binary manifest names.
#
# Safety properties:
#   * The cache root must carry a `.ergodis-cache` marker file, must not be
#     `/`, `$HOME`, or a parent of this repository, and every deletion target
#     is re-checked to be a direct child of that root. A wrong
#     ERGODIS_CACHE_ROOT therefore deletes nothing.
#   * The shared target/ and bin/ directories and the marker are never
#     candidates: target/ is the one build directory per crate and bin/ holds
#     retained A/B baselines.
#   * An entry is "referenced" when its exact name occurs in any file under the
#     evidence, docs, or notes trees, or in bin/MANIFEST.tsv. Referenced entries
#     are never deleted.
#   * Age is the newest modification time anywhere inside the entry, not the
#     top-level mtime, so a build tree that is being written deep inside counts
#     as young. Entries younger than --min-age-days (default 2) are kept.
#   * Dry run is the default. --apply deletes one exact path at a time, never a
#     glob, under a lock, and appends every removal to <root>/gc.log.
#
# usage: cache-gc.sh [--apply] [--min-age-days N]
set -euo pipefail

script_dir=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=lib.sh
. "$script_dir/lib.sh"

core_root=$(cd "$script_dir/.." && pwd)
repo_root=$(cd "$core_root/../../.." && pwd)

apply=0
min_age_days=2
while (( $# )); do
  case $1 in
    --apply) apply=1 ;;
    --min-age-days)
      min_age_days=${2:?--min-age-days needs a value}
      [[ $min_age_days =~ ^[0-9]+$ ]] || { echo "cache-gc.sh: --min-age-days must be a non-negative integer" >&2; exit 2; }
      shift
      ;;
    --help|-h)
      echo "usage: cache-gc.sh [--apply] [--min-age-days N]" >&2
      echo "  default: dry run, printing a table of cache entries and their references" >&2
      echo "  --apply: rm -rf each UNREFERENCED entry, one exact named path at a time" >&2
      echo "  --min-age-days N: keep unreferenced entries whose newest file is younger than N days (default 2)" >&2
      exit 0
      ;;
    *) echo "cache-gc.sh: unknown argument: $1" >&2; exit 2 ;;
  esac
  shift
done

# --- cache-root guard -------------------------------------------------------
cache_root=$(ergodis_cache_root)
if [[ ! -d $cache_root ]]; then
  echo "cache-gc.sh: no cache root at $cache_root" >&2
  exit 0
fi
cache_root=$(cd "$cache_root" && pwd -P)
case $cache_root in
  /|"$HOME"|/home|/tmp|/usr|/var|/etc|/nix|/root)
    echo "cache-gc.sh: refusing to operate on $cache_root" >&2; exit 3 ;;
esac
case "$repo_root/" in
  "$cache_root"/*)
    echo "cache-gc.sh: refusing: cache root $cache_root contains the repository" >&2; exit 3 ;;
esac
if [[ ! -f $cache_root/.ergodis-cache ]]; then
  echo "cache-gc.sh: refusing: $cache_root has no .ergodis-cache marker file" >&2
  echo "  create it with: touch $cache_root/.ergodis-cache" >&2
  exit 3
fi

# --- reference corpus ------------------------------------------------------
ref_dirs=()
for dir in "$core_root/evidence" "$repo_root/ergodis-private/evidence" \
           "$repo_root/ergodis-private/docs" "$repo_root/notes"; do
  [[ -d $dir ]] && ref_dirs+=("$dir")
done
ref_files=()
[[ -f $cache_root/bin/MANIFEST.tsv ]] && ref_files+=("$cache_root/bin/MANIFEST.tsv")

references_of() {
  # Print up to three basenames of files that mention the exact entry name.
  local name=$1
  {
    if (( ${#ref_dirs[@]} )); then
      grep -r -l -F -I --exclude-dir=.git --exclude-dir=target -- "$name" "${ref_dirs[@]}" 2>/dev/null || true
    fi
    if (( ${#ref_files[@]} )); then
      grep -l -F -- "$name" "${ref_files[@]}" 2>/dev/null || true
    fi
  } | head -n 3 | xargs -r -n1 basename | paste -sd, -
}

newest_mtime() {
  # Newest modification time (epoch seconds) of anything inside the entry.
  local entry=$1 t
  t=$(find "$entry" -printf '%T@\n' 2>/dev/null | sort -n | tail -n 1)
  printf '%d\n' "${t%.*}"
}

printf '%10s  %8s  %-44s  %s\n' SIZE AGE NAME REFERENCED-BY
printf '%10s  %8s  %-44s  %s\n' ---- --- ---- -------------

unreferenced=()
now=$(date +%s)
scanned=0

while IFS= read -r -d '' entry; do
  name=$(basename "$entry")
  case $name in
    target|bin|.ergodis-cache|gc.log|.gc.lock) continue ;;
  esac
  case $name in
    *[$'\n\r']*) echo "cache-gc.sh: skipping entry with control characters in its name" >&2; continue ;;
  esac
  scanned=$((scanned + 1))

  size=$(du -sh "$entry" 2>/dev/null | cut -f1)
  mtime=$(newest_mtime "$entry")
  age_days=$(( (now - mtime) / 86400 ))

  refs=$(references_of "$name")
  if [[ -z $refs ]]; then
    if (( age_days < min_age_days )); then
      refs="KEPT (younger than ${min_age_days}d)"
    else
      refs=UNREFERENCED
      unreferenced+=("$entry")
    fi
  fi

  printf '%10s  %6dd  %-44s  %s\n' "$size" "$age_days" "$name" "$refs"
done < <(find "$cache_root" -mindepth 1 -maxdepth 1 -print0 | sort -z)

echo
echo "scanned: $scanned   unreferenced and old enough: ${#unreferenced[@]}"

if (( apply == 0 )); then
  echo "dry run; re-run with --apply to delete the UNREFERENCED entries"
  exit 0
fi

# --- apply ------------------------------------------------------------------
exec 9>"$cache_root/.gc.lock"
if ! flock -n 9; then
  echo "cache-gc.sh: another cache-gc.sh --apply holds $cache_root/.gc.lock" >&2
  exit 4
fi

stamp=$(date -u +%FT%TZ)
for entry in "${unreferenced[@]}"; do
  # Re-verify: an absolute direct child of the cache root, no traversal, still present.
  parent=$(dirname "$entry")
  name=$(basename "$entry")
  if [[ $parent != "$cache_root" || $name == . || $name == .. || $name == */* ]]; then
    echo "cache-gc.sh: refusing to remove unexpected path $entry" >&2
    exit 5
  fi
  case $name in
    target|bin|.ergodis-cache|gc.log|.gc.lock)
      echo "cache-gc.sh: refusing to remove protected entry $name" >&2; exit 5 ;;
  esac
  [[ -e $entry || -L $entry ]] || continue
  echo "removing $entry"
  printf '%s\t%s\n' "$stamp" "$name" >>"$cache_root/gc.log"
  rm -rf -- "$entry"
done
