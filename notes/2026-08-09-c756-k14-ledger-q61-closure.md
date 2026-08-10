# C756 \(k=14\) ledger and \(q=61\) closure

**Date:** 2026-08-09

**Scope:** exact field/window ledger for \(k=14\), plus the one-line
extension gate at \(q=61\)

**Status:** \(q=61\) closed; the fixed-size frontier is exactly
\(q=67,71,73\)

## Verdict

A deleted point of a hypothetical conic-filling \(14\)-arc gives thirteen
dual lines and \(\binom{13}{2}=78\) internal pairwise nodes.  The direction
bound gives \(q\le76\).  The saturated values \(q=25,27\), every even field,
and every odd field through 43 are already closed.  Exact twelve-line geometry
at \(q=47,49,53,59\) has no leaf in either deleted-point branch, hence cannot
extend to thirteen lines.

At \(q=61\), the all-passant branch likewise has no twelve-line leaf.  The
mixed branch has the 96 exact leaves from the global \(k=13\) closure.  A
full compatibility scan against all 1,830 line vertices shows that none of
those leaves admits one further line while retaining internal pairwise nodes
and no triple concurrency.  Therefore

\[
 \boxed{\text{No conic-filling }14\text{-arc exists over }\mathbf F_{61}.}
\]

The complete remaining \(k=14\) frontier is

\[
 \boxed{q=67,71,73.}
\]

## Exact coefficient ledger

Write

\[
 \delta=78-q,
 \qquad
 h_{\rm ext}=\frac{q-1}{2}-13,
 \qquad
 h_{\rm int}=\frac{q+1}{2}-13.
\]

The simultaneous projection window is
\(E_{\delta+1},\ldots,E_{h(P)-1}=0\).  Thus:

| \(q\) | \(\delta\) | external deletion | internal deletion | state |
|---:|---:|---|---|---|
| 47,49,53,59 | — | — | — | no twelve-line substar |
| 61 | 17 | none | none | no thirteen-line star |
| 67 | 11 | \(E_{12},\ldots,E_{19}=0\) | \(E_{12},\ldots,E_{20}=0\) | open |
| 71 | 7 | \(E_8,\ldots,E_{21}=0\) | \(E_8,\ldots,E_{22}=0\) | open |
| 73 | 5 | \(E_6,\ldots,E_{22}=0\) | \(E_6,\ldots,E_{23}=0\) | open |

The node-character convention remains \(\chi(-1)\): negative at 67 and 71,
positive at 73.  No \(k=13\) coefficient window may be copied into this table.

## Certificate and replay

Certificate:
`notes/2026-08-09-c756-q61-k14-extension.json`.

It pins the complete q=61 mixed-root certificate by SHA-256, selects exactly
the eleven seed representatives carrying the 96 leaves, replays those seed
trees, and deduplicates every compatible thirteenth-line extension.  Result:

| quantity | value |
|---|---:|
| source leaves | 96 |
| source seed representatives | 11 |
| replayed search nodes | 121,631,794 |
| compatible thirteen-line stars | 0 |

Exact replay:

```sh
C756_EXT=/tmp/persistent/tavis/c756-q61-k14-extension-replay
mkdir -p "$C756_EXT"
printf '%s\n' 1 3 4 5 11 15 18 21 23 28 29 | \
  xargs -P5 -I{} env PYTHONDONTWRITEBYTECODE=1 \
  python3 notes/2026-08-09-c756-q59-k13-star-search.py \
  --q 61 --mode mixed --seed-s {} --extend-one \
  --output "$C756_EXT/c756-q61-mixed-seed-{}.json"
python3 notes/2026-08-09-c756-q59-k13-star-search.py \
  --q 61 \
  --aggregate-extensions-from notes/2026-08-09-c756-q61-k13-mixed.json \
  --shard-directory "$C756_EXT" \
  --check notes/2026-08-09-c756-q61-k14-extension.json
```

Hashes:

```text
3421f660be97ecd99db766476a5cce61f1d228620bd7f0c8a3be0c07a8d59bd8  notes/2026-08-09-c756-q59-k13-star-search.py
0fa8a47e48ddcfdb65630feb3ec64297f5d0c5a58ad9d8fcff7720eab4d8eda3  notes/2026-08-09-c756-q61-k13-mixed.json
cda5a20472f410ba0f78bd3f461ea71cca4e5c00029c1d80bfb0fc98740a3e55  notes/2026-08-09-c756-q61-k14-extension.json
```

## Evidence boundary

The extension scan is exact over the certified 96-root list and checks every
line vertex, but it is not a second independent enumeration of the roots.
The monotonic exclusions at \(q=47,49,53,59\) use only absence of a
twelve-line substar.  Nothing here closes \(q=67,71,73\).

## EJ + TT closeout

**EJ.**  The 96 rigid \(3+9\) stars are all maximal, so their unexplained
type profile does not propagate even one step.  This is stronger and cheaper
than testing the \(k=14\) covering equations, whose q=61 window is empty.

**TT.**  The fixed-size problem should now be attacked in increasing carrier
strength rather than field order alone: q=67 has the weakest live geometry but
already an eight-equation window; q=73 starts at \(E_6\).  The q=67 shard is
the correct next feasibility gate.

## Mystery ledger

| feature | status | exact gap / next gate |
|---|---|---|
| maximality of all 96 q=61 stars | settled computationally | no thirteenth line exists |
| common \(3+9\) type of those stars | still unexplained | no longer propagates to \(k=14\); symbolic explanation is optional |
| q=61 coefficient window | settled as empty | geometry alone closes the field |
| complete \(k=14\) field frontier | settled | exactly q=67,71,73 |
| q=67 | open | shard thirteen-line mixed/all-passant geometry and test \(E_{12}\) first |
