#!/usr/bin/env bash
# Self-test for cache-gc.sh against a throwaway cache root. Never touches the
# real cache. Exit 0 means every guard behaved.
set -euo pipefail

script_dir=$(cd "$(dirname "$0")" && pwd)
gc="$script_dir/cache-gc.sh"
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT

fail() { echo "FAIL: $*" >&2; exit 1; }
root="$tmp/cache"
mkdir -p "$root/target/x" "$root/bin" "$root/old-unreferenced/deep" "$root/young-unreferenced/deep" \
         "$root/old-referenced" "$root/old-deepwrite/deep"
printf 'x' >"$root/old-unreferenced/deep/f"
printf 'x' >"$root/young-unreferenced/deep/f"
printf 'x' >"$root/old-referenced/f"
printf 'x' >"$root/old-deepwrite/deep/f"
printf 'retained\told-referenced\n' >"$root/bin/MANIFEST.tsv"
old="2020-01-01 00:00:00"
touch -d "$old" "$root/old-unreferenced" "$root/old-unreferenced/deep" "$root/old-unreferenced/deep/f"
touch -d "$old" "$root/old-referenced" "$root/old-referenced/f"
# top-level old, but a file deep inside was written just now: must count as young
touch -d "$old" "$root/old-deepwrite" "$root/old-deepwrite/deep"

# 1. no marker -> refuse, nothing deleted
if ERGODIS_CACHE_ROOT="$root" "$gc" --apply >/dev/null 2>&1; then fail "ran without marker"; fi
[[ -d $root/old-unreferenced ]] || fail "deleted without marker"
touch "$root/.ergodis-cache"

# 2. dangerous roots refuse even with a marker
for bad in / "$HOME" /tmp; do
  if ERGODIS_CACHE_ROOT="$bad" "$gc" >/dev/null 2>&1; then fail "accepted root $bad"; fi
done

# 3. dry run deletes nothing and classifies correctly
out=$(ERGODIS_CACHE_ROOT="$root" "$gc")
grep -q 'old-unreferenced .*UNREFERENCED' <<<"$out" || fail "old-unreferenced not flagged"
grep -q 'young-unreferenced .*KEPT' <<<"$out" || fail "young-unreferenced not kept"
grep -q 'old-deepwrite .*KEPT' <<<"$out" || fail "deep write not treated as young"
grep -q 'old-referenced .*MANIFEST.tsv' <<<"$out" || fail "manifest reference not found"
grep -q ' target ' <<<"$out" && fail "target listed as candidate"
[[ -d $root/old-unreferenced ]] || fail "dry run deleted"

# 4. apply removes exactly the one entry and logs it
ERGODIS_CACHE_ROOT="$root" "$gc" --apply >/dev/null
[[ ! -e $root/old-unreferenced ]] || fail "apply did not remove old-unreferenced"
for keep in target bin young-unreferenced old-referenced old-deepwrite .ergodis-cache; do
  [[ -e $root/$keep ]] || fail "apply removed protected/kept entry $keep"
done
grep -q $'\told-unreferenced$' "$root/gc.log" || fail "removal not logged"

# 5. min-age 0 removes the young one too, but never target/bin
ERGODIS_CACHE_ROOT="$root" "$gc" --apply --min-age-days 0 >/dev/null
[[ ! -e $root/young-unreferenced ]] || fail "min-age 0 kept young entry"
[[ -d $root/target/x && -d $root/bin ]] || fail "protected dir removed"

# 6. bad argument values refuse
if ERGODIS_CACHE_ROOT="$root" "$gc" --min-age-days abc >/dev/null 2>&1; then fail "accepted non-integer age"; fi

echo "cache-gc self-test: ok"
