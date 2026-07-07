# Arc-census cross-check against odd grid-maximal caps (2026-07-07)

Post-Fable Track-C4 check: compare our odd maximal grid caps with the complete-arc spectra
where the data overlaps.

## Bottom line

No mismatch found, but the agenda wording needs one important downgrade:

> Grid-maximal caps are projective arcs through the two fixed direction points, complete
> relative to affine points. They are not automatically complete projective arcs.

So the published complete-arc spectra give an immediate **size-spectrum sanity gate**, not a
raw count equality. A grid cap of affine size `m` maps to a projective arc of size `k = m + 2`.
If that projective arc is truly complete, `k` must occur in the published spectrum. If `k` is
absent, the likely explanation is an addable third point at infinity, not necessarily a solver
bug.

For a count comparison, we still need two filters:

1. **Infinity-point completeness filter.** For a grid cap `A`, after adding the two fixed
   directions, every other direction at infinity must be blocked by an affine secant of `A`.
   Equivalently, the slopes of pairs of affine points in `A` must cover all non-fixed directions.
2. **Projective orbit recanon.** Our counts are grid-stabilizer orbits of affine sets. Literature
   counts are full projective or semilinear projective orbits of complete arcs. One projective
   orbit can split into several grid orbits depending on the inequivalent choices of the two
   direction points in the arc.

## Overlap actually available now

The direct overlap is `q=17` and `q=19`: our solver has odd grid-maximal-cap counts, and the
accessible FMMP scan gives the complete-arc size spectra for those planes. O1/C4 also gives
future gates for `q=23,25,27,29`.

| q | our odd grid-maximal data | published projective complete-arc spectrum | odd affine sizes allowed after projective-complete filter | check |
|---:|---|---|---|---|
| 17 | `143854` grid classes, min affine size `9` | `{10,11,12,13,14,18}` | `9,11` | min size maps to `k=11`, which exists |
| 19 | `692595` grid classes, min affine size `9` | `{10,11,12,13,14,20}` | `9,11` | min size maps to `k=11`, which exists |
| 23 | no full grid odd-maximal count yet | `{10,12,13,14,15,16,17,24}` | `11,13,15` | future q=23 gate |
| 25 | no full spectrum; known `t=12`, `N_12=606`, no `k=19,20` | partial | affine size `17` cannot be projectively complete | partial future gate |
| 27 | no grid data | `{12,13,14,15,16,17,18,19,22,28}` | `11,13,15,17` | future gate |
| 29 | no grid data | `{13,14,15,16,17,18,19,20,21,24,30}` | `11,13,15,17,19` | future gate |

Interpretation of the `q=17/19` rows: the smallest odd grid-maximal caps pass the literature
size gate. If any odd grid-maximal classes at these q have affine size `13` or larger, then they
cannot be complete projective arcs under the FMMP spectra; they should be classified as
affine-relative complete unless the projective-completeness filter says otherwise, in which case
that would be a real contradiction to the spectrum.

## Count-comparison caution

The published projective counts visible in the FMMP scan/Penttila-Royle remarks are not directly
comparable to our grid-class counts:

- `q=17`: projective counts include `2644` complete 11-arcs and `8` complete 13-arcs (plus
  even-size rows), while our `143854` number counts all odd grid-maximal classes under the grid
  group, including any projectively incomplete affine-relative caps.
- `q=19`: projective counts include `9541` complete 11-arcs and `2232` complete 13-arcs, while
  our `692595` number is again a grid-stabilizer count before the infinity-point and projective
  orbit filters.

Large discrepancies here are expected; they are not evidence of a bug.

## Recommended next check

Add a non-invasive census mode, preferably in a private copy while the live `esc q=19` run is
active:

```text
for each maximal grid cap A:
  if |A| is odd:
    record affine size m
    record whether pairwise slopes(A) cover all non-fixed directions
    if projectively complete:
      canonicalize A plus the two direction points under full PGL/PGammaL
```

Then compare:

- **size gate:** every projectively complete odd row must have `m + 2` in the spectrum above;
- **count gate:** projective-canonical counts should be compared only after full projective
  recanon, not from grid-class counts.

This is the clean way to turn Track-C4 into a real bug/new-observation detector.
