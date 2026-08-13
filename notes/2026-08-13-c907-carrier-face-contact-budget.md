# C907 — carrier-face contact budget

Date: 2026-08-13

Status: exact necessary condition and negative AKMW coverage audit.  A
`P6`-faithful K-positive carrier face cannot pass through an arbitrary smooth
blowup center.  Faciality forces it to contain strict transforms of every
effective carrier curve which meets the center, and the canonical divisor
formula subtracts `(codim-1)` for each unit of contact.  AKMW places no bound
on this contact budget, so its smooth toroidal peaks are not automatically
covered by the K-positive carrier-face theorem.

## 1. One-center lemma

Let `p:Y=Bl_Z X -> X` be the blowup of a smooth center of codimension `c>=2`,
with exceptional fibre class `e`.  Let `beta` be an effective numerical curve
class on `X` which has a representative avoiding `Z`.  Suppose another
effective curve `C` of class `beta`, not contained in `Z`, has contact multiplicity

\[
 m=\operatorname{mult}_Z C>0.
\]

Write `p^!beta` for the numerical class of a representative avoiding `Z` and
`Ctilde` for the strict transform.  Then

\[
 [\widetilde C]=p^!\beta-me,
 \qquad
 p^!\beta=[\widetilde C]+me,                         \tag{1}
\]

and

\[
 c_1(Y)[\widetilde C]
 =c_1(X)\beta-(c-1)m.                               \tag{2}
\]

Now let `G` be a face of `NE(Y)` which contains the exceptional ray and a
nonzero effective lift of the ray `R_{>=0} beta`.  Adding an effective
multiple of `e` shows that `p^!beta in G`.  Equation (1) and the defining
property of a face then force `[Ctilde] in G`.  Consequently strict
`c_1`-positivity on `G\{0}` requires

\[
 \boxed{c_1(X)\beta>(c-1)m}                         \tag{3}
\]

for every such carrier curve.

This argument is numerical and is unchanged after saturating the retained
Novikov monoid.  Choosing a different lift of `beta` cannot evade it: once
the exceptional ray and one effective lift lie in `G`, so does `p^!beta`,
and faciality recovers every effective summand in (1).

## 2. Several and nested centers

The intrinsic form uses divisorial discrepancies.  Let a smooth iterated
blowup `f:Y->X` have

\[
 K_Y=f^*K_X+\sum_i a_iE_i,
\]

where every `a_i>0`, including the transformed discrepancies produced by
nested centers.  If a carrier curve has contact order
`m_i=E_i.[Ctilde]>=0`, then

\[
 c_1(Y)[\widetilde C]
 =c_1(X)\beta-\sum_i a_i m_i.                       \tag{4}
\]

The numerical total transform of an avoiding representative is the
strict-transform class plus an effective one-cycle supported over the
exceptional locus.  Hence a face containing the carrier lift and the full
relative effective cone supporting that exceptional cycle also contains the
strict transform, and strict positivity requires

\[
 c_1(X)\beta>\sum_i a_i m_i.                       \tag{5}
\]

This formulation is independent of the order used for a nested
building-set blowup.  Reordering changes the exceptional basis and contact
coordinates, but not the relative canonical divisor or its intersection
with the final strict transform.

For disjoint smooth centers `Z_i` of codimensions `c_i`, the discrepancies
are simply `a_i=c_i-1`.  Thus (4)--(5) become

For disjoint smooth centers `Z_i` of codimensions `c_i`, let `e_i` denote the
exceptional rays and let `m_i` be the contact multiplicities of a carrier
curve.  On the common blowup,

\[
 c_1(Y)[\widetilde C]
 =c_1(X)\beta-\sum_i(c_i-1)m_i,                     \tag{6}
\]

Any face containing the carrier lift and all `e_i` contains the strict
transform.  Hence the necessary budget is

\[
 c_1(X)\beta>\sum_i(c_i-1)m_i.                     \tag{7}
\]

Thus “commuting blowups” is not by itself a positive class.  Disjointness of
the centers does not prevent one carrier curve from meeting several of them.

## 3. Cubic and Gold regressions

For a line class `h` on a smooth cubic threefold,

\[
 c_1(X)h=2.
\]

Therefore a transverse unit contact has the following budget:

| center codimension | strict-transform anticanonical degree |
|---:|---:|
| `2` | `1` |
| `3` | `0` |
| `4` | `-1` |
| `5` | `-2` |

The codimension-three equality is exactly the point-centered Geiser
regression: for `Bl_p X`, each line through `p` has class `h-e` and
`c_1(h-e)=0`.  After product with `P^2`, the center `p x P^2` still has
codimension three and the same K-trivial families remain.  This proves that
the Geiser peak cannot be absorbed into the K-positive carrier theorem; its
separate ordinary-flop/Gamma intertwiner is genuinely necessary.

For a point center in the Gold fivefold `X x P^2`, codimension is five.  A
cubic line through its `X` coordinate and base point has degree `-2` after
strict transform.  A base line through the point has initial anticanonical
degree three and becomes degree `-1`.  Hence neither endpoint carrier ray can
belong to a strictly positive face with that exceptional ray.

Codimension two is the only automatic-looking single-contact case for the
cubic line: one unit of contact leaves degree one.  Even there, tangency of
multiplicity two, or simultaneous contact with another center, reaches zero.
The exact condition is (3), not a codimension slogan.

## 4. Consequence for AKMW coverage

AKMW's regular subdivision theorem says that an elementary smooth piece is a
toroidal blowup followed by a toroidal blowdown between nonsingular models.
It supplies smooth centers and projectivity.  It does not constrain:

- the anticanonical degrees of horizontal packet-carrying curves;
- their contact multiplicities with the inserted centers;
- simultaneous contact with centers from adjacent subdivisions;
- the oriented nonturning path required by the sectorial receiver.

Therefore AKMW does not imply the contact inequalities (3), (5), or (7), and hence
does not imply `P6`-faithful K-positive carrier-face coverage.  This is an
exact source-level failure, not merely an unverified expectation.

Nor can one choose the carrier lift to avoid all centers numerically.  The
existence of an avoiding representative gives `p^!beta`, while the existence
of a meeting representative gives the decomposition (1); a face containing
the former must contain the latter.

The remaining peak portfolio splits naturally:

1. **positive-contact peaks**, satisfying (3)/(5) and the oriented path:
   handled by the carrier-face theorem;
2. **zero-contact-budget peaks**, such as Geiser: candidates for ordinary
   split-flop or crepant Gamma/FM intertwiners;
3. **negative-contact-budget peaks**: require a discrepant Sarkisov/VGIT
   peak theorem, not a convergence refinement of the carrier method.

General Gold contains no theorem yet eliminating class 3.

The first class-3 regression is nevertheless positive.  For a general point
of `X x P^2`, the six cubic lines through its `X` coordinate become
`P^1`'s with normal `O(-1)^4` after the point blowup.  They undergo a split
`(1,3)` standard flip to six `P^3`'s with normal `O(-1)^2`.  The finite
disconnected-wall extension of Gu--Yu--Yu closes its rank Boolean; see
`2026-08-13-c907-disconnected-standard-wall-and-point-flip.md`.

## EJ / TT / AA

- **EJ:** the first obstruction is the integer `(c-1)m`, not a Stokes
  matrix.  It predicts exactly where the analytic carrier theorem can exist.
- **TT:** a movable carrier class avoiding the center does not save
  positivity; faciality also sees every effective representative which meets
  the center.
- **AA:** classify the negative-budget elementary Sarkisov links in
  dimension five.  The smallest target is a point or codimension-four center
  hit by the cubic line carrier; another Artin-receiver refinement cannot
  change equation (2).

## Source boundary

- The blowup canonical-divisor formula and strict-transform identity give
  (1)--(7) directly.
- AKMW, arXiv:math/9904135, Theorem 2.7.1 states the smooth toroidal
  blowup/down factorization but no contact or anticanonical inequality;
  cached SHA-256
  `55bbc2c58f29d4b9dbe965035f80f3844f6968eaf98076ac625132ac3b3977a5`.
