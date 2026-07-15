# C170 — unconditional uniqueness of q=11

**Date**: 2026-07-14
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: **REPORTED**. The unconditional theorem, Git-tracked checker, manuscript
synchronization, exact replay, characteristic-two audit, and PDF build all passed.

## Target theorem

Let `q` be a prime power. If a six-arc `A` in `PG(2,q)` has

`U(A)=C(F_q)`

for some nonsingular conic `C`, then `q=11`; at `q=11`, the rigidity theorem further identifies `A`
with the Clebsch hexagon up to `PGL(3,11)`.

This statement is unconditional: it assumes neither an icosahedral stabilizer nor rationality of an
`A5` construction.

## Finite reduction

The existing secant-capacity lemma gives `q<=14`. Indeed, `U(A)=C(F_q)` implies both that `A` is
disjoint from `C` and that every point off `A union C` lies on a secant, so the lemma applies without
an extra hypothesis. The prime powers in the remaining range are

`2,3,4,5,7,8,9,11,13`.

For each field, every six-arc contains a projective four-frame. Sending it to
`e1,e2,e3,(1,1,1)` and sweeping the remaining two legal points meets every projective class. The
enumeration is over distinct frame-normalized representatives, not equivalence classes; the theorem
needs coverage, not class multiplicities.

The durable checker must report the exact `|U|` histogram at every field size and test equality with
the full rational point set of a nonsingular conic, not merely quadratic containment. The known
diagnostic rows to reproduce are:

| q | normalized representatives | `|U|` histogram |
|---:|---:|---|
| 7 | 70 | `{0:40,2:30}` |
| 8 | 195 | `{0:45,4:150}` |
| 9 | 441 | `{0:6,4:15,6:120,7:120,8:180}` |
| 11 | 1548 | `{12:6,16:30,18:150,19:300,20:630,21:360,22:72}` |
| 13 | 4015 | `{36:85,38:210,39:480,40:1080,41:1800,42:360}` |

The rows at `q=2,3,4,5`, the extension-conic matches, and the characteristic-two nonsingularity
checks are part of the durable run rather than assumptions.

## Exhaustive result

The durable checker is
`papers/clebsch-hexagon-code/check_small_q_uniqueness.py` (SHA-256
`cbe028cec3795edb8e2985c4f5aba6fb268260e6ea5183122cb1d040abb2ec01`). It uses exact field
arithmetic, literal asserted addition/multiplication/inverse tables for `F4`, `F8`, and `F9`, and
an exhaustive four-frame-normalized enumeration. Its conic test searches every projective
quadratic form in the evaluation kernel, requires equality with the full rational zero locus, and
tests nonsingularity through the formal-gradient radical. Per-field sanity cases certify
`XZ-Y^2` as a nonsingular `(q+1)`-point conic and `XY`/`X^2` as singular; this explicitly exercises
the characteristic-two branch at `q=2,4,8`.

Exact replay:

```text
q=2 normalized_representatives=0 U_histogram={} nonsingular_conic_matches=0
q=3 normalized_representatives=0 U_histogram={} nonsingular_conic_matches=0
q=4 normalized_representatives=1 U_histogram={0: 1} nonsingular_conic_matches=0
q=5 normalized_representatives=3 U_histogram={0: 3} nonsingular_conic_matches=0
q=7 normalized_representatives=70 U_histogram={0: 40, 2: 30} nonsingular_conic_matches=0
q=8 normalized_representatives=195 U_histogram={0: 45, 4: 150} nonsingular_conic_matches=0
q=9 normalized_representatives=441 U_histogram={0: 6, 4: 15, 6: 120, 7: 120, 8: 180} nonsingular_conic_matches=0
q=11 normalized_representatives=1548 U_histogram={12: 6, 16: 30, 18: 150, 19: 300, 20: 630, 21: 360, 22: 72} nonsingular_conic_matches=6
q=13 normalized_representatives=4015 U_histogram={36: 85, 38: 210, 39: 480, 40: 1080, 41: 1800, 42: 360} nonsingular_conic_matches=0
prime_powers_checked=[2, 3, 4, 5, 7, 8, 9, 11, 13]
extension_field_tables_asserted=[4, 8, 9]
conic_nonsingularity_sanity_fields=[2, 3, 4, 5, 7, 8, 9, 11, 13]
characteristic_two_conic_sanity_fields=[2, 4, 8]
unique_matching_field=11
total_normalized_conic_matches=6
all assertions passed
```

The six matches are normalized representatives, not six projective classes. The q=11 rigidity
census puts them in the single Clebsch orbit.

## Consequences for C166

The manuscript's conditional `A5` theorem is replaced by the unconditional
statement above. The current Dickson-filter/q=9 subgroup-conjugacy proof becomes non-load-bearing
and has been removed; the unsupported assertion that the q=9 `A5` is unique up to conjugacy is no
longer a paper claim.

This is stronger and cleaner than merely aligning the opening prose with the old conditional result:
the counting lemma supplies a finite range and the tracked frame sweep closes every class in it.

## Validation

- `python3 check_small_q_uniqueness.py`: passed in about 2.8 seconds with the exact output above.
- `git ls-files --error-unmatch papers/clebsch-hexagon-code/check_small_q_uniqueness.py`: passed.
- Independent reduction audit: the `q<=14` implication, prime-power list, and four-frame coverage
  passed. It requested the explicit nonsingular-conic wording and characteristic-two sanity cases;
  both landed before report.
- Tectonic manuscript build: passed after the theorem replacement; no theorem or citation warning.

The remaining conceptual question is not whether the result is true but whether there is a
classification-free explanation for why only `q=11` survives the finite residue. That is a
follow-on question, not a missing proof in this paper.
