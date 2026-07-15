# C165 — Clebsch one-point perturbation gap

**Date**: 2026-07-14
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: **REPORTED**. Durable checker, manuscript synchronization, tracking gate, PDF build, and
independent post-edit review all passed.

## Correct claim boundary

Let `A` be the displayed Clebsch six-arc and `C` its fixed standard conic. Define the
**one-point-replacement graph** on embedded six-arcs of `PG(2,11)` by joining `B` to `B'` when their
unordered point sets have symmetric difference two. Equivalently, one vertex of the arc is deleted
and one new projective point is inserted, with the result still a six-arc.

For a neighbor `B` of `A`, define the fixed-conic discrepancy

`d_C(B)=|U(B) triangle C(F_11)|`.

The finite theorem to preserve is exactly:

- each of the six deleted vertices admits 42 legal replacement points;
- the resulting 252 neighbor arcs are distinct;
- `d_C` has histogram `{18:30,19:60,20:90,22:42,24:30}`;
- the number of fixed-conic points remaining in `U(B)` has histogram `{4:60,6:132,7:60}`;
- no neighbor has `U(B)` contained in any conic, including a degenerate conic.

Thus every adjacent vertex has fixed-conic discrepancy at least 18. This is a local theorem in the
specified graph, not a global distance statement about all embedded or projective classes.

## Why the old global gloss is false

The conic-preserving projectivity

`g:(X,Y,Z) -> (4X,2Y,Z)`

sends `A` to the distinct six-arc

`{(0,1,2),(1,2,10),(1,4,4),(1,5,0),(1,6,10),(1,10,3)}`.

Because `g` preserves `XZ=Y^2`, equivariance gives `U(gA)=C(F_11)`, and direct recomputation agrees.
Hence the fixed-conic discrepancy is zero for a distinct embedded six-arc outside the
one-point-replacement neighborhood. The sentence “the nearest other six-arc is at distance 18” must
not return.

This does not weaken either finite count `252`: the perturbation count is genuinely `6*42`, while
the unrelated set of all six-subsets of the twelve-point conic has size `binom(12,6)=924`. The `252`
seen in the rigidity sweep counts only concyclic frame-normalized representatives.

## Durable artifact contract

`papers/clebsch-hexagon-code/check_perturbation_gap.py` must be standard-library-only and certify
every bullet above plus the explicit global counterexample. Its final line is
`all assertions passed`; C165 is not reported until the file passes `git ls-files --error-unmatch`,
the output is recorded here, and the manuscript names the checker.

C171 separately owns the stronger PGL-invariant distance to the nearest conic and the eight
`A5`-orbits on the 252 moves. Those upgrades may replace the fixed-conic framing later, but C165 does
not depend on them.

## Validation

Command:

`cd papers/clebsch-hexagon-code && python3 check_perturbation_gap.py`

Output:

```text
scope=local_one_point_replacement_graph
projective_points=133
standard_conic_points=12
legal_replacements_per_deleted_vertex=[42, 42, 42, 42, 42, 42]
distinct_neighboring_six_arcs=252
fixed_conic_symmetric_difference_histogram={18: 30, 19: 60, 20: 90, 22: 42, 24: 30}
surviving_fixed_conic_points_histogram={4: 60, 6: 132, 7: 60}
neighbors_on_any_conic=0
global_counterexample_projectivity=diag(4,2,1)
global_counterexample_fixed_conic_distance=0
global_gloss_counterexample=True
all assertions passed
```

- `git ls-files --error-unmatch papers/clebsch-hexagon-code/check_perturbation_gap.py`: passed; the
  new checker is explicitly staged for tracking.
- `git diff --check`: passed for the checker, manuscript, report, discovery log, queue, and handoff.
- `nix shell nixpkgs#tectonic -c tectonic clebsch_hexagon_code.tex --outdir
  /tmp/clebsch-build --keep-logs`: succeeded after its internal reruns, with no warnings.
- Independent post-edit review found the graph definition, counts, histograms, conic-rank test, and
  explicit global counterexample mutually consistent, with no remaining local/global overclaim.
