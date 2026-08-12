# C907 low-dimensional stable-birational compression

**Lane:** `clebsch`

**Status:** theorem-level consequence of the closed v1 blow-up formula. It
removes two prime-Fano rows without another quantum differential-equation
calculation and gives a second one-step-stably-irrational family. No
manuscript, PDF, mirror, or Lean edit.

## 1. Birational invariance through dimension four

Let `nu_6(Y)` be the framed primitive-sixth-root multiplicity of the numerical
small quantum connection defined in the C907 v1 theorem.

> **Proposition.** If `Y` and `Y'` are birational smooth projective complex
> varieties of the same dimension at most four, then
>
> \[
> \nu_6(Y)=\nu_6(Y').
> \tag{1}
> \]

Indeed, weak factorization uses nontrivial blow-ups with smooth centers of
codimension at least two. In dimension at most four every center has dimension
at most two. The v1 coefficientwise center theorem gives

\[
 \nu_6(C;\chi)=0
\]

for every point, curve, or surface center and every strictly admissible
specialization occurring in the blow-up comparison. Thus the ambient integer
is unchanged at every step. This is exactly the stepwise argument already used
for `X x P^1`; no common Novikov field or atomwise descent is needed.

Consequently every rational smooth projective variety of dimension at most
four has `nu_6=0`.

## 2. One-step stable-birational invariance for threefolds

Let `Y,Z` be smooth projective threefolds and `E,F` rank-two vector bundles.
If

\[
 \mathbf P_Y(E)\dashrightarrow\mathbf P_Z(F)
\]

is birational, then (1) in dimension four and the projective-bundle formula
give

\[
 2\nu_6(Y)=\nu_6(\mathbf P_Y(E))
 =\nu_6(\mathbf P_Z(F))=2\nu_6(Z),
\]

hence

\[
 \nu_6(Y)=\nu_6(Z).
 \tag{2}
\]

Equivalently, `nu_6` is invariant under one-step stable birationality of
smooth projective threefolds. Projectivizations are generically trivial, so
the displayed hypothesis also gives

\[
 Y\times\mathbf P^1\dashrightarrow Z\times\mathbf P^1.
 \tag{3}
\]

## 3. The genus-eight prime Fano leaf

Kuznetsov proves that for every smooth prime Fano threefold `V_14` of genus
eight, the projectivization of its exceptional rank-two bundle becomes, after
a natural flop, the projectivization of a charge-two instanton bundle on a
smooth cubic threefold `X`. Therefore (2) gives

\[
 \nu_6(V_{14})=\nu_6(X),
 \tag{4}
\]

so `V_14` carries the same single primitive-sixth pair as the cubic. More
directly, (3) and the C907 v1 theorem give

\[
 \boxed{V_{14}\times\mathbf P^1\text{ is irrational}.}
 \tag{5}
\]

This holds for every smooth `V_14`, not only a special member. It is a second
one-step-stably-irrational Fano family and a sharp noncubic regression for the
future threefold carrier bound: primitive-sixth support can occur, but only as
one packet.

The word "single" uses two closed inputs: v1 gives the cubic lower bound two,
and the weighted-CI theorem gives the upper bound two. Thus
`nu_6(V_14)=nu_6(X)=2`.

## 4. The genus-twelve prime Fano leaf

The C682 source audit records Kuznetsov--Prokhorov--Shramov, Theorem 5.2.2:
double projection from a line on any smooth prime Fano threefold `V_22` of
genus twelve is a Sarkisov link to `V_5`. Hence

\[
 \nu_6(V_{22})=\nu_6(V_5)=0.
 \tag{6}
\]

The published conic-centered link `V_22 dashrightarrow Q^3` gives an
independent zero-support route. Thus genus twelve is removed from the direct
prime-Fano quantum-operator scan. The exact `V_5` operator remains useful as
an analytic calibration, but is not needed merely to exclude the
genus-twelve carrier.

## 5. Enriched implication and boundary

Once C907's strict Stokes/Rees/Gamma blow-up theorem is proved, the same proof
upgrades formally:

> if the enriched cubic packet of every point and curve is zero, then the
> enriched cubic packet is a birational invariant of smooth projective
> threefolds.

This would make every rational threefold center harmless before any MMP
classification. It would also reduce the carrier theorem to stable
birational classes rather than presentations or quantum-period rows.

The upgrade is conditional because the present theorem transports only the
closed integer `nu_6`, not Rees length, Stokes order, Gamma marking, or the
operation frame. In particular:

- (4) does not by itself prove `ell_(1/6)(V_14)=1`;
- (6) is a formal-support exclusion, not a universal non-Fano carrier theorem;
- the width-three Reid pagoda in the `V_22 dashrightarrow V_5` link does not
  create a cubic packet. It is therefore a composition stress test, not a
  model of cubic Rees length.

## 6. Sources and read depth

- C907 v1 blow-up formula and low-dimensional center vanishing:
  `2026-08-11-c907-v1-framed-fractional-support.md`, Sections 3--5.
- Alexander Kuznetsov, *Derived categories of cubic and V14 threefolds*,
  arXiv:`math/0303037`; the primary abstract states the rank-two
  projectivization/flop correspondence for an arbitrary smooth `V_14`.
  A theorem-locus reread is required before manuscript promotion, but the
  abstract statement is already sufficient for (2)--(5).
- Kuznetsov--Prokhorov--Shramov, arXiv:`1605.02010`, Theorem 5.2.2; cached
  source and theorem-locus audit are recorded in
  `2026-07-26-c682-hitchin-structural-question.md`, Sections 17--18.
- Kuznetsov--Prokhorov, arXiv:`1711.08504`, Theorem 2.2, for the independent
  conic link to `Q^3`; source locus is recorded in the same C682 report.

## Mystery ledger

- **Closed:** `nu_6` is birationally invariant in dimensions at most four.
- **Closed:** `nu_6` is invariant under one-step stable birationality of
  smooth projective threefolds.
- **Closed:** genus twelve has `nu_6=0` by the landed Sarkisov links.
- **Closed modulo a full theorem-locus reread before publication:** every
  smooth genus-eight `V_14` has the same `nu_6` as the cubic and remains
  irrational after multiplication by `P^1`.
- **Open:** operation-framed enriched birational invariance and the universal
  threefold length bound.
