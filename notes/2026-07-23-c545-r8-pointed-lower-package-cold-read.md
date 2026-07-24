# C545 R8 pointed lower-package cold read

Date: 2026-07-23

## Result

The printed proposition `prop:r8-lp61` closes the full pointed lower
package `LP(6,1)`.  Together with the already proved contained-component
proposition `prop:r8-contained`, this makes the redundancy-eight
classification unconditional for every prime power `q >= 43`.  No statement
is made about additional deep orbits below 43.

## Acceptance audit

The cold read checked the release-checklist criterion stratum by stratum.

1. The two Hankel rows and their kernel pencil define the bottom
   off-diagonal equation.  The `3 x 3` Hankel determinant cuts out the
   rank-two/gcd-two carrier, while adjoining the homogeneous evaluation row
   gives the exact-gcd-one incidence, including infinity.
2. Outside characteristics two and three, the cyclic carrier is the printed
   degree-four projected Veronese surface and contains no line.  In
   characteristic three the wild carrier is the degree-four cone and its
   rulings fail the consecutive-row overlap.  In characteristic two the
   carrier is the printed plane and its unique contained polar-line component
   is the declared nucleus.
3. The inseparable cases add no hidden stratum.  Degree-three Frobenius
   factorization is impossible in larger characteristic; in characteristic
   three it gives the wild-cone vertex; in characteristic two, after gcd
   cancellation, homogenization restores a common linear factor and routes
   the point to the exact-gcd-one boundary.
4. A separable gcd-zero cubic cover has geometric monodromy `S3` or `C3`.
   Removing the cyclic carrier leaves `S3`, whose transitive action on
   ordered distinct root pairs makes the `(2,2)` identity twist
   geometrically integral of genus at most one.
5. The deletion degree is `4 + 8 + 3*6 = 30`: diagonal, off-diagonal
   different, and three marker fibers.  Thus
   `q + 1 - 2*sqrt(q) > 30` at every prime power `q >= 43`.
6. On the recursive marker line the rank, cyclic/wild, ramification,
   fixed-marker, and marker-diagonal degrees total at most
   `3 + 4 + 6 + 2 + 2 + 2 = 19`.  On the outer marker line the corresponding
   total is `3 + 1 + 8 + 2 + 1 = 15`.
7. The exact-gcd-one strata are handled directly.  The ordered-pair bad
   equations have the printed bidegrees; their union has at most
   `14(q+1)` or `12(q+1)` rational pairs, strictly below the available-pair
   counts in the stated range.  Multiplication by the successive marker
   factors then gives the required split squarefree lift.
8. The degree-zero, degree-one, and degree-at-least-two gcd cases, together
   with the `S3/C3` dichotomy, exhaust the recursive strata.  The geometric
   integrality argument does not rely on the finite certificate.

The manuscript abstract, summary theorem, boundary section, theorem map,
claim ledger, adversarial audit, second-draft plan, and operative release
checklist now use the same unconditional R8 boundary.

## Validation

- `make -C papers/beyond4_prs check`: pass; 32-page PDF, no warning class
  accepted by the Makefile.
- Certificate R8 generator check: pass.
- Certificate R8 independent replay: pass.
- Exact source scans find no conditional R8 theorem and no stale abstract
  lower-package condition.
- Abstract mechanical count after the correction: 195 words.

Certificate R8 checks the nucleus arithmetic and numerical budgets.  It does
not substitute for the printed integrality, gcd, or monodromy proof.

## Extra-juice and Tao closeout

The parameter-choice estimates are not threshold-setting: `15` and `19` are
already below `q+1` for `q >= 19`.  The entire `q >= 43` boundary comes from
the genus-one deletion inequality with degree 30.  This isolates the only
route to a better R8 field threshold: reduce the actual deletion divisor or
analyze its rational intersections, rather than sharpening the polar-line
avoidance count.

The useful conceptual compression is the degree-three monodromy dichotomy.
Once gcd and inseparability are separated, the only transitive geometric
groups are `S3` and `C3`; the cyclic carrier is explicit, and the complement
has the required integral ordered-pair cover.  No additional recursive
monodromy type is missing.

## Mystery ledger

- **Settled:** whether a hidden inseparable stratum survives in
  `LP(6,1)`.  It routes to the wild vertex in characteristic three and to
  the gcd-one boundary in characteristic two.
- **Settled:** whether an unprinted parameter bound raises the field
  threshold.  It does not; the budgets 15 and 19 have ample slack at 43.
- **Open but outside the theorem:** whether the deletion divisor can be
  sharpened enough to classify additional fields below 43.  The current
  theorem deliberately makes no bounded-field completion claim; this is not
  a C545 release blocker.

