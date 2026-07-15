# C187 — General k-arc conic-filling preflight

**Date**: 2026-07-15
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: **IN PROGRESS — FINITE SEARCH HARDENED AND REPLAYED.** The `k=4,5,7` arithmetic is
proved below and the surviving `q=11,13` seven-arc searches now have one tracked fail-closed
checker. The `(4,5)` literature positioning and Lean formalization remain.

## Exact identity through seven points

Let `n_i` count off-arc points on exactly `i` chords. For `k<=7`, at most three pairwise disjoint
chords can concur, and double-counting disjoint chord pairs gives

`n_2 + 3n_3 = 3 * binom(k,4)`.

Together with the first secant moment, this yields the following cases.

- For `k=4`, `|U|=(q-2)(q-3)`. Conic size forces `q=5` (besides the non-field value `q=1`), and
  the standard frame in `PG(2,5)` has uncovered locus the nonsingular invariant conic
  `X^2+Y^2+Z^2+XY+XZ+YZ=0`.
- For `k=5`, `|U|=q^2-9q+21`; conic size would require `q^2-10q+20=0`, which has no integral root.
- The `k=6` case is the paper's Clebsch theorem.

For a seven-arc, no point lies on more than three chords. Writing `n_j` for the number of off-arc
points on exactly `j` chords, the 105 pairs of disjoint chords give `n_2+3n_3=105`; the first
secant moment then yields

`|U| = q^2 - 20q + 120 - n_3`.

If `U` is a conic, then

`n_3=q^2-21q+119`, `n_2=105-3n_3`, and `n_1=3(q^2-14q+42)`.

The correct concurrence bound is `n_3<=35`, because each triple point consumes three of the 105
disjoint chord pairs. Nonnegativity of `n_2` leaves `q in {7,8,9,11,13}`, and nonnegativity of
`n_1` removes `7,8,9`. Thus only `q=11,13` survive, with forced spectra `(27,78,9)` and
`(87,60,15)` respectively.

## Hardened finite leaves

Tracked checker:
[`papers/clebsch-hexagon-code/check_small_k_conic_filling.py`](../papers/clebsch-hexagon-code/check_small_k_conic_filling.py),
SHA-256 `2aa2187ce53867ea3e3f823463e71c42f9537594f4603a7091edbf063bf1b67c`.
It is a standard-library consolidation of the verbatim provenance artifacts
`notes/source-artifacts/2026-07-15-fable-clebsch/q2_step1.py` and `q2_step2.py`; it does not import
or trust either source at runtime.

Direct replay on 2026-07-15:

```text
q=5 frame: uncovered=6 displayed_quadratic_points=6 quadratic_nonsingular=PASS exact_set_equality=PASS
q=11: six_reps=1548 histogram={12: 6, 16: 30, 18: 150, 19: 300, 20: 630, 21: 360, 22: 72} raw_six_extension_pairs=30696 distinct_seven_arcs=10232 multiplicities={3: 10232}
q=11: size_q_plus_one=140 quadratic_nullities={0: 140} quadratic_containment_hits=0 nonsingular_conic_hits=0
q=13: six_reps=4015 histogram={36: 85, 38: 210, 39: 480, 40: 1080, 41: 1800, 42: 360} raw_six_extension_pairs=161880 distinct_seven_arcs=53960 multiplicities={3: 53960}
q=13: size_q_plus_one=1680 quadratic_nullities={0: 1680} quadratic_containment_hits=0 nonsingular_conic_hits=0
SMALL_K_CONIC_FILLING_PASS
```

The checker asserts, rather than merely prints:

- the standard frame in `PG(2,5)` has uncovered set exactly
  `Z(X^2+Y^2+Z^2+XY+XZ+YZ)`, and the symmetric matrix of this quadratic is nonsingular;
- the `q=11,13` frame-normalized six-arc counts and complete `|U|` histograms are exactly those
  displayed above;
- extending every six-arc by every point of its uncovered locus produces respectively `30696`
  and `161880` raw `(six-arc, extension-point)` pairs;
- every resulting seven-set is an arc, the distinct-set counts are `10232` and `53960`, and every
  distinct seven-set occurs exactly three times before deduplication;
- among the distinct seven-arcs, respectively `140` and `1680` have `|U|=q+1`, but every associated
  `(q+1) x 6` quadratic-evaluation matrix has rank six, hence there are zero quadratic-containment
  hits; and
- the normally empty hit branch computes the full quadratic kernel and tests the determinant of
  the associated symmetric matrix before using the word *conic*. A singular quadratic containment
  would be reported separately and would not count as a conic.

### Artifact boundary

The finite checker proves only its explicit prime-field leaves: the displayed `q=5` frame and the
complete frame-normalized enumerations at `q=11,13`. Frame normalization covers every seven-arc
because every seven-arc contains an ordered four-frame, while the raw multiplicity-three assertion
audits the overlap created by deleting one of the three non-frame points.

The checker does **not** prove the universal `k=4,5,7` identities, the concurrence bound, or the
reduction to `q=11,13`. Those are the algebraic double-counting arguments in the preceding section;
the old random `k=7` samples are provenance only and are not evidence used by the result.

## Exit gate

- **done:** replay and harden the attached `k=4,5,7` finite checker;
- formalize the general first/second chord-moment identity and all three specializations;
- literature-check the `PG(2,5)` quadrilateral/invariant-conic sibling before claiming novelty;
- **done:** exhaust the normalized searches at `q=11,13` and audit their raw/deduplicated counts;
  and
- make an explicit paper-versus-follow-on decision before any large census run.
