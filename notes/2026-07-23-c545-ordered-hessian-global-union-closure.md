# C545 ordered-Hessian global-union closure

Date: 2026-07-23

## Result

Gate P6 is closed.  The manuscript now proves the reduced
root-compatible pullback and uses a genuine single polynomial for effective
base selection.  The earlier degree-four global-union claim has been
withdrawn; the valid theorem is

`q >= min((n-4)(n+11)/2+1, 9(n-4))`

with the unchanged deletion budget `3n-4`.

This is an intentional weakening of the base-selection constant, not a
weakening of the contained-carrier classification.

## Pullback proof

The Veronese surface `Sigma` is defined by the prime ideal of `2 x 2`
minors of the printed symmetric Pluecker matrix.  At the generic point of a
root-compatible pullback component, these minors say that every iterated
contraction pencil has a common quadratic.

- In the ordinary case, the characteristic-free rank-nullity proposition
  puts the syndrome in the persistent catalecticant rank-two carrier.
- When a contraction coefficient vanishes in the ground characteristic,
  Lucas' theorem gives exactly the contraction-kernel nucleus flags.
- Both families visibly make the Veronese minors vanish.

Equality over every algebraically closed extension therefore identifies the
reduced pullback with the persistent/Lucas union.

For the complementary ruling, the first and last equations give two
overlapping consecutive square-product identities.  Unique factorization
forces each nonzero consecutive triple of contraction forms to be
proportional, and overlap propagates this across all five forms.  The line
then has rank at most one, so no nontrivial rank-two component survives.

Line intersections with the twisted cubic are exactly common vertical
factors of the divided Hessian.  Removing them commutes with base change;
they are not components of the reduced moving incidence.

## Honest global polynomial

Outside the contained union, choose:

- one nonzero pulled-back equation `A` of `Sigma`;
- one nonzero pulled-back equation `B` of the complementary ruling.

Each has individual selected-root degree at most four.  The product `AB` is
nonzero, vanishes on the entire reduced bad union, and has individual degree
at most eight.  This directly repairs the logical error in treating
component equations as though one degree-four equation vanished on their
union.

For `m=n-4`, adjoining the Vandermonde gives total degree

`8m + binom(m,2) = m(m+15)/2`.

Alternatively, disjoint nine-element interpolation blocks handle degree
eight in each variable.  These are exactly the two terms in the corrected
threshold.

## Validation

- Certificate Hessian generator check: pass.
- Independent Hessian replay: pass.
- C525 checksum manifest: all five rows pass after the report correction.
- Warning-gated manuscript build: pass, 35-page PDF.
- Claim ledger, theorem map, adversarial audit, second-draft plan, and C545
  checklist all use the degree-eight polynomial and revised threshold.
- The effective corollary is no longer conditional.

The certificate checks the universal Pluecker and factorization algebra.  It
does not replace the printed root-compatible rank-nullity/Lucas argument.

## Extra-juice and Tao closeout

The correction isolates precisely where the factor of two enters.  Each
component separately has a degree-four pullback equation, but avoiding a
union needs an equation in the intersection of the component ideals.  The
product construction supplies that equation at degree eight with no generic
position assumption.

At points outside the linear span of the complementary ruling, a linear
ruling equation can reduce the local product degree to six.  That does not
give a uniform theorem because a point may lie in the ruling's linear span
while missing only its quadratic equation.  The uniform degree-eight bound
is therefore the clean proof-complete statement; a sharper constant would
require a genuine low-degree separator in the intersection ideal, not
another union-bound slogan.

Vertical factors are cheaper than previously feared: they need not enter
the global product at all.  Their scheme-theoretic meaning lets the reduced
incidence remove them before integrality is tested.

## Mystery ledger

- **Settled:** whether the Veronese pullback contains an unclassified
  root-compatible component.  Its reduced support is exactly the
  persistent/Lucas union.
- **Settled:** whether the complementary ruling contributes a rank-two
  carrier.  Consecutive unique factorization forces rank at most one.
- **Settled:** whether one degree-four generator controls the union.  It
  does not; the valid product has degree eight and the theorem now says so.
- **Open but nonblocking:** the intersection ideal may contain a uniform
  separator of Pluecker degree three, which would improve the numerical
  bound.  No such separator is used or claimed, and threshold sharpening
  remains separately owned by C533.

