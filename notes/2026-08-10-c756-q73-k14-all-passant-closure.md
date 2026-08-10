# C756 q=73, k=14 all-passant closure

**Date:** 2026-08-10

**Scope:** exact thirteen-line all-passant dual-star search over
\(\mathbf F_{73}\)

**Status:** the q=73 all-internal branch is closed; only its mixed branch
remains open

## Verdict

If a conic-filling 14-arc over \(\mathbf F_{73}\) has no external point, then
deleting any arc point gives thirteen passant polar lines whose 78 pairwise
nodes are internal and distinct.  The exact anisotropic norm-torus search
visits all 37 central-inversion seed representatives.  Across 38,310,405
recursion states there is no thirteen-line geometric star.

Therefore

\[
 \boxed{\text{The all-internal q=73, k=14 branch is impossible.}}
\]

No divided-coefficient test is needed.  This does not yet close q=73: its
mixed external-deletion branch remains the sole open fixed-size branch.

## Certificate and replay

Generator:
`notes/2026-08-09-c756-q59-k13-star-search.py`.

Certificate:
`notes/2026-08-10-c756-q73-k14-all-passant.json`.

Exact replay from repository root:

```bash
mkdir -p /tmp/persistent/tavis/c756-q73-k14-all-passant
seq 0 36 | xargs -P6 -I{} env PYTHONDONTWRITEBYTECODE=1 python3 notes/2026-08-09-c756-q59-k13-star-search.py --q 73 --target-size 13 --mode all-passant --seed-s {} --output /tmp/persistent/tavis/c756-q73-k14-all-passant/c756-q73-passant-seed-{}.json
PYTHONDONTWRITEBYTECODE=1 python3 notes/2026-08-09-c756-q59-k13-star-search.py --q 73 --target-size 13 --aggregate-mode all-passant --shard-directory /tmp/persistent/tavis/c756-q73-k14-all-passant --check notes/2026-08-10-c756-q73-k14-all-passant.json
```

The generator pins both underlying geometry programs by SHA-256 and rejects
schema, field, target-size, character-convention, shard, or certificate drift.
The search is deterministic and uses exact integer arithmetic reduced modulo
73.  Its trusted boundary is the Python implementation, CPython arithmetic,
and the dual-star reduction.  It is not a Lean-kernel proof, and no separately
implemented exhaustive enumerator is claimed.  Formula-level checks recompute
every pairwise node and reject every repeated node and triple concurrency.

## EJ + TT closeout

**EJ.**  This branch closes at raw geometry in only 38,310,405 states, so the
strong q=73 window \(E_6,\ldots,E_{22}=0\) remains entirely available for the
mixed branch.  No certificate bulk from residual stars is needed.

**TT.**  The all-passant disappearance at q=71 persists at q=73 even though
the internal-node character changes with \(\chi(-1)\).  A uniform explanation
should therefore be sought in the norm-torus direction order or the
no-three-concurrent condition, not in the sign of \(-1\).  That extraction is
lower priority than closing the live mixed census.

## Mystery ledger

| feature | status | exact gap / owning next gate |
|---|---|---|
| q=73 all-passant thirteen-line geometry | settled computationally | no star in 38,310,405 recursion states |
| consecutive all-passant disappearance at q=71,73 | exact but unexplained | seek a norm-torus/no-concurrency proof only if reusable |
| q=73 mixed branch | open | complete all 37 normalized shards and test \(E_6\) at every leaf |
| q=73 fixed-field k=14 layer | open | owned entirely by the mixed branch |

## SHA-256 and byte counts

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-09-c756-q59-k13-star-search.py` | 30,888 | `f5d0d53cf687bd44fda0f8e89584930983eac4d22905807d22901e4ee105c3d6` |
| `notes/2026-08-10-c756-q73-k14-all-passant.json` | 11,545 | `6d9a81145e98e96fea713a9f41bae4fff8fe746ddfedc8e7195683455a8af4ff` |
