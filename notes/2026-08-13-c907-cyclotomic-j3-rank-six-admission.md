# C907 cyclotomic rank-six admission for an endpoint `J_3`

**Lane:** `clebsch`

**Status:** theorem-grade conditional strengthening of the rank-preserving
carrier screen.  When the strict Rees filtration is compatible with the
integral primitive-sixth action, each nonzero grade has even rank.  Hence a
three-step endpoint block requires `nu_6>=6`; every center with `nu_6<=4` is
automatically harmless for the `m=2` Krull--Schmidt telescope.

## Cyclotomic grade lemma

Put `A=Z[1/6]` and let `V_6(Z)` be a finite free lattice whose rational span
is the whole **generalized** primitive-sixth primary formal solution space of
a smooth projective threefold.  Its formal-monodromy endomorphism `T`
satisfies

\[
 \Phi_6(T)^m=(T^2-T+1)^m=0
 \tag{1}
\]

for some `m`; no semisimplicity is assumed.  Suppose the enriched realization
has a finite strict `N`-adic/Rees-shift filtration

\[
 0=F_{a-1}\subset F_a\subset\cdots\subset F_b=V_6(Z)
 \tag{2}
\]

by saturated `T`-stable `A`-sublattices.  Let `G_i=F_i/F_{i-1}`.  After
tensoring with `Q`, every `G_i` is a `T`-stable subquotient of the generalized
`Phi_6`-primary space.  Its characteristic polynomial is therefore
`Phi_6^e` for some `e`.  Since `Phi_6` is irreducible of degree two over `Q`,

\[
 G_i\ne0\quad\Longrightarrow\quad
 \operatorname{rank}_A G_i\ge2,
 \qquad
 \operatorname{rank}_A G_i\equiv0\pmod2.
 \tag{3}
\]

This is only the rational cyclotomic degree count; it does not require
semisimplicity, an `A[zeta_6]`-module structure, or Poincare self-duality.

## Rank-six theorem

For every categorical Tate shift allowed in the weak-factorization sum,
assume the strict realization identifies its whole underlying generalized
primitive-sixth packet with `V_6(Z)`, preserves the framed `T` action and the
`Phi_6` primary sector, and makes a `J_ell` occupy `ell` consecutive
rank-positive grades (equivalently, its exact-grade `gr N` arrows are nonzero
through those slots).  Rank additivity and (3) give

\[
 2\ell\le
 \sum_i\operatorname{rank}_A G_i
 =\operatorname{rank}_A V_6(Z)=\nu_6(Z).
 \tag{4}
\]

In particular,

\[
 \boxed{J_3\text{ in a threefold center}\quad\Longrightarrow\quad
        \nu_6(Z)\ge6.}
 \tag{5}
\]

Equivalently, every center with `nu_6<=4` is excluded from carrying the
endpoint indecomposable.  The bound is numerically sharp in the proposed
endpoint calibration: the landed product calculation gives
`nu_6(X x P^2)=6`, and its proposed strict cyclotomic realization has three
Tate grades containing one conjugate primitive-sixth pair each.  Existence of
that strict endpoint realization remains part of the definition/analytic
gate.

The theorem is stronger than the earlier deliberately weak inequality
`ell<=nu_6`.  Its added hypothesis is exactly what licenses the improvement:
the strict filtration and every grade are stable under the same integral
cyclotomic action.  An arbitrary filtration, or an enrichment which records
only one complex eigenspace and forgets its conjugate, is outside its scope.

## Birational saturation

The framed multiplicity `nu_6` is birationally invariant for smooth
projective threefolds: weak factorization uses point and curve centers, whose
primitive-sixth support is zero.  Consequently the **numerical admission
screen** is constant on every smooth birational class.  If the strict
all-shifts cyclotomic realization is available separately for every model,
no member of a class with one representative satisfying `nu_6<=4` can carry
the endpoint `J_3`.  This does not assert birational invariance of the
enriched filtration itself.

Numerically this birationally saturates all landed `nu_6<=2`
families—including the prime-Fano, stated weighted-CI, smooth Fano
cyclic-cover, `V_5`, and cubic pencil classes—and would also discharge any
future class with exact `nu_6=4` without a sectorial multiplication
calculation, conditional on the same realization for every relevant
categorical shift.

It is not a universal carrier theorem.  Arbitrary non-nef threefolds can have
larger primitive-sixth rank, and the strict cyclotomic Rees realization itself
is still the analytic/categorical input missing from the formal QDM.

## EJ/TT and mystery ledger

- **EJ:** count cyclotomic pairs per Rees grade.  The endpoint threat consumes
  three grades and therefore six formal dimensions.
- **TT:** the factor of two comes from `T`-stability of every strict grade,
  not from an unproved self-dual splitting or from categorical faithfulness
  alone.
- **Settled:** under the strict all-shifts cyclotomic realization, the exact
  admission threshold `J_3 => nu_6>=6` and the smooth-birational saturation
  of its numerical screen.
- **Open:** construct that realization and exclude `J_3` in the remaining
  birational classes with `nu_6>=6` (or without a computed finite rank).
