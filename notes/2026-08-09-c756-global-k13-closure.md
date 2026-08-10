# C756 global \(k=13\) closure

**Date:** 2026-08-09

**Scope:** the two remaining fields \(q=59,61\), for both the
external-deletion mixed star and the all-internal/all-passant star

**Status:** complete negative classification of the \(k=13\) layer

## Verdict

There is no conic-filling \(13\)-arc over any finite field.  The earlier
ledger reduced the layer to \(q=59,61\).  The exact searches here close both:

\[
 \boxed{\text{No conic-filling }13\text{-arc exists over any finite field.}}
\]

At \(q=59\), geometry alone is decisive.  Neither point type admits a
twelve-line deleted-point star:

| deleted-point branch | normalized seeds present | search nodes | geometric stars |
|---|---:|---:|---:|
| external / mixed secant--passant | 30 | 187,764,531 | 0 |
| internal / all-passant | 15 | 3,042,991 | 0 |

At \(q=61\), the internal/all-passant branch again has no geometry.  The
mixed branch has exactly 96 normalized geometric leaves, but all 96 fail the
first forced equation \(E_6=0\):

| deleted-point branch | normalized seeds present | search nodes | geometric stars | survive forced window |
|---|---:|---:|---:|---:|
| external / mixed secant--passant | 31 | 328,466,430 | 96 | 0 |
| internal / all-passant | 15 | 3,851,217 | 0 | 0 |

Every one of the 96 mixed leaves has exactly three secants and nine passants.
Independently of \(E_6\), none has even one complete center among the missing
directions.  Thus the coefficient obstruction and the projection-completeness
obstruction agree leaf by leaf.

## Exact model and normalization

The mixed branch uses the split model \(UV=2W^2\).  The distinguished line
\(W=0\) is a secant, and its internal directions have character
\(\chi(-1)\): \(-1\) at \(q=59\) and \(+1\) at \(q=61\).  The all-passant
branch uses the anisotropic norm model from the prior C756 certificates with
the same internal-node character.  In both models an edge means internal
intersection and the search excludes triple concurrency.

Every star can be rotated to contain direction zero.  Central inversion sends
the normalized offset \(s\) to \(-s\), preserves the conic, node character and
concurrency, negates every centered node, and hence scales \(E_j\) by
\((-1)^j\) while preserving projection completeness.  Therefore offsets
\(0,\ldots,(q-1)/2\) are an exact set of seed representatives.  As a direct
implementation check, the omitted counterparts agree byte-for-byte on all
search statistics:

- \(q=59\): seeds \(1\) and \(58\) each have 6,730,464 search nodes and no leaf;
- \(q=61\): seeds \(1\) and \(60\) each have 11,530,254 search nodes, eight
  leaves, all of type \(3+9\), and all first fail at \(E_6\).

For a leaf, the program constructs all 66 affine pairwise nodes, translates
their centroid to zero, and computes the dense binary elementary forms by the
factor recurrence

\[
 \prod_{X=(x,y)}(1+t(xU+yV)).
\]

It checks \(E_8,\ldots,E_{16}\) at \(q=59\), and
\(E_6,\ldots,E_{17}\) at \(q=61\), exactly as required for an external
deleted point.  The all-passant branch uses the one-term-longer internal
windows.  Projection supports are computed independently from the same node
coordinates.

## Reproducibility bundle

- `notes/2026-08-09-c756-q59-k13-star-search.py`
- `notes/2026-08-09-c756-q59-k13-mixed.json`
- `notes/2026-08-09-c756-q59-k13-all-passant.json`
- `notes/2026-08-09-c756-q61-k13-mixed.json`
- `notes/2026-08-09-c756-q61-k13-all-passant.json`

The script pins the two prior geometry engines by SHA-256 and bounds each
pair-concurrency cache at 200,000 entries.  Measured mixed-worker RSS was
about 80--100 MB; no Lean or Lake process was active during the runs.

Exact replay, with the shard directory chosen explicitly:

```sh
C756_SHARDS=/tmp/persistent/tavis/c756-k13-replay
mkdir -p "$C756_SHARDS"
for q in 59 61; do
  for mode in mixed all-passant; do
    prefix=mixed
    if [ "$mode" = all-passant ]; then prefix=passant; fi
    seq 0 $(((q - 1) / 2)) | xargs -P4 -I{} env PYTHONDONTWRITEBYTECODE=1 \
      python3 notes/2026-08-09-c756-q59-k13-star-search.py \
      --q "$q" --mode "$mode" --seed-s {} \
      --output "$C756_SHARDS/c756-q${q}-${prefix}-seed-{}.json"
  done
done
for q in 59 61; do
  for mode in mixed all-passant; do
    suffix=mixed
    if [ "$mode" = all-passant ]; then suffix=all-passant; fi
    python3 notes/2026-08-09-c756-q59-k13-star-search.py \
      --q "$q" --aggregate-mode "$mode" \
      --shard-directory "$C756_SHARDS" \
      --check "notes/2026-08-09-c756-q${q}-k13-${suffix}.json"
  done
done
```

Bundle hashes:

```text
3421f660be97ecd99db766476a5cce61f1d228620bd7f0c8a3be0c07a8d59bd8  notes/2026-08-09-c756-q59-k13-star-search.py
a145813f5dbf3c1dc7bd57c57e80c4ed673ba4fe83b2ee16dc51a425c0da8128  notes/2026-08-09-c756-q59-k13-mixed.json
244240f38ea7a7a9ad01d032a69625db8b8070eec9d51a8df94b62c899c2b245  notes/2026-08-09-c756-q59-k13-all-passant.json
0fa8a47e48ddcfdb65630feb3ec64297f5d0c5a58ad9d8fcff7720eab4d8eda3  notes/2026-08-09-c756-q61-k13-mixed.json
ab2bf90676dae9844d5dab63119ebd060eede0628384c97f87473a668b606339  notes/2026-08-09-c756-q61-k13-all-passant.json
```

## Evidence boundary

The enumeration is exact and restartable by normalized seed.  It reuses two
previously audited coordinate engines and adds a common line-equation
concurrency checker.  The inversion-pair replay is an independent invariant
check, not a second exhaustive enumerator.  The conclusion is only the fixed
size \(k=13\) layer; it does not propagate to \(k\ge14\).

## EJ + TT closeout

**EJ.**  The q=61 field does not die at raw geometry: its 96 leaves are a
genuine residual layer.  The planned characteristic-safe coefficient is
exactly sharp enough—every leaf fails already at \(E_6\)—and the separate
complete-center test gives a second negative reading without any covariance
classification.

**TT.**  The useful next question is not another k=13 carrier.  The entire
fixed-size layer is closed.  The 96 rigid \(3+9\) leaves instead form the
smallest exact input for the \(k=14,q=61\) extension gate, while the
saturated-internal global nonblocking theorem remains the all-k structural
priority.

## Mystery ledger

| feature | status | exact gap / owning next gate |
|---|---|---|
| q=59 disappearance before covariance | settled computationally | no twelve-line mixed or all-passant geometry |
| q=61 residual leaf count 96 | exact but unexplained | structural orbit explanation remains open inside C756 |
| uniform q=61 type \(3\) secants + \(9\) passants | exact but unexplained | test whether character double counting forces it before any promotion |
| q=61 first failure always at \(E_6\) | exact but unexplained | identify a symbolic nonvanishing formula only if it helps the \(k=14\) gate |
| global \(k=13\) layer | settled negative | no genuine mystery remains at this fixed size |
| all-k theorem | open | saturated-internal nonblocking and \(k\ge14\) nonsaturated branches remain |
