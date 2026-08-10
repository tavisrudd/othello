# C756 q=71, k=14 all-passant closure

**Date:** 2026-08-10

**Scope:** exact thirteen-line all-passant dual-star search over
\(\mathbf F_{71}\)

**Status:** the q=71 all-internal branch is closed; only its mixed branch
remains open

## Verdict

If a conic-filling 14-arc over \(\mathbf F_{71}\) has no external point, then
deleting any arc point gives thirteen passant polar lines whose 78 pairwise
nodes are internal and distinct.  The exact anisotropic norm-torus search
visits all 36 central-inversion seed representatives.  Eighteen
representatives are present in the normalized graph.  Across 22,579,655
recursion states there is no thirteen-line geometric star.

Therefore

\[
 \boxed{\text{The all-internal q=71, k=14 branch is impossible.}}
\]

No divided-coefficient test is needed.  This does not close q=71: the mixed
external-deletion branch remains open.  The complete k=14 frontier remains
q=71,73, but q=71 now has only one live point-type branch.

## Certificate and replay

Generator:
`notes/2026-08-09-c756-q59-k13-star-search.py`.

Certificate:
`notes/2026-08-10-c756-q71-k14-all-passant.json`.

Exact replay from repository root:

```bash
mkdir -p /tmp/persistent/tavis/c756-q71-k14-all-passant
seq 0 35 | xargs -P6 -I{} env PYTHONDONTWRITEBYTECODE=1 python3 notes/2026-08-09-c756-q59-k13-star-search.py --q 71 --target-size 13 --mode all-passant --seed-s {} --output /tmp/persistent/tavis/c756-q71-k14-all-passant/c756-q71-passant-seed-{}.json
PYTHONDONTWRITEBYTECODE=1 python3 notes/2026-08-09-c756-q59-k13-star-search.py --q 71 --target-size 13 --aggregate-mode all-passant --shard-directory /tmp/persistent/tavis/c756-q71-k14-all-passant --check notes/2026-08-10-c756-q71-k14-all-passant.json
```

The generator pins both underlying geometry programs by SHA-256 and fails on
schema, field, target-size, character-convention, or shard drift.  The search
is deterministic and uses exact integer arithmetic reduced modulo 71.  Its
trusted boundary is the Python implementation, CPython arithmetic, and the
dual-star reduction.  It is not a Lean-kernel proof.

As an independent normalization audit, present seed 6 and its central inverse
65 were rerun.  After discarding search-order artifacts, every mathematical
field agrees, including the identical 1,378,722-state search count and zero
leaf count.

## EJ + TT closeout

**EJ.**  The q=71 all-passant row closes at raw geometry in about 2.3% of the
states required by the q=67 mixed closure.  The planned stronger window
\(E_8,\ldots,E_{22}=0\) is unnecessary for this branch and remains fully
available for the mixed search.

**TT.**  The sharp change from 92 q=67 all-passant stars to zero at q=71 is
structurally suggestive because both fields have \(\chi(-1)=-1\).  The
anisotropic direction quotients have cyclic orders 34 and 36, respectively.
A useful human question is whether the q=67 stars depend on the order-17
cyclotomic component, while the order-36 case admits a spectral or subgroup
blocking argument.  This is more targeted than seeking a uniform Paley clique
bound across both fields.

## Mystery ledger

| feature | status | exact gap / owning next gate |
|---|---|---|
| q=71 all-passant thirteen-line geometry | settled computationally | no star in 22,579,655 recursion states |
| disappearance of the 92 q=67 residual stars at q=71 | exact but unexplained | test a norm-torus Fourier or cyclotomic explanation only if reusable |
| q=71 mixed branch | open | complete the normalized mixed shards and test \(E_8\) at every leaf |
| q=71 fixed-field k=14 layer | open | owned entirely by the mixed branch |
| q=73 k=14 layer | open | remains behind the q=71 mixed feasibility gate |

## SHA-256 and byte counts

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-09-c756-q59-k13-star-search.py` | 30,888 | `f5d0d53cf687bd44fda0f8e89584930983eac4d22905807d22901e4ee105c3d6` |
| `notes/2026-08-10-c756-q71-k14-all-passant.json` | 11,422 | `9cee1f6f1c36fae39e9fb7c704bbf73ff47e9077f4d2b62de02d644bdaa91cb3` |
