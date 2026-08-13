# C907 cyclotomic rank-six admission for an endpoint `J_3`

**Lane:** `clebsch`

**Status:** theorem-grade conditional strengthening of the rank-preserving
carrier screen.  When the strict Rees filtration is compatible with the
integral primitive-sixth action, each nonzero grade has even rank.  Hence a
three-step endpoint block requires `nu_6>=6`; every center with `nu_6<=4` is
automatically harmless for the `m=2` Krull--Schmidt telescope.

## Cyclotomic grade lemma

Put `A=Z[1/6]` and let `V_6(Z)` be the whole primitive-sixth lattice of a
smooth projective threefold.  Its formal-monodromy endomorphism `T` satisfies

\[
 \Phi_6(T)=T^2-T+1=0
 \tag{1}
\]

on the primitive-sixth primary sector.  Suppose the enriched realization has
a finite strict `N`-adic/Rees-shift filtration

\[
 0=F_{a-1}\subset F_a\subset\cdots\subset F_b=V_6(Z)
 \tag{2}
\]

by saturated `T`-stable `A`-sublattices, and that `N` commutes with `T` and
raises the Rees grade.  Let `G_i=F_i/F_{i-1}`.  Every torsion-free nonzero
`G_i` is a module over

\[
 A[T]/(T^2-T+1)=A[\zeta_6].
 \tag{3}
\]

After tensoring with `Q`, the polynomial `Phi_6` is irreducible of degree two.
Therefore

\[
 G_i\ne0\quad\Longrightarrow\quad
 \operatorname{rank}_A G_i\ge2,
 \qquad
 \operatorname{rank}_A G_i\equiv0\pmod2.
 \tag{4}
\]

This is only the rational cyclotomic degree count; it does not require the
grades to be free as `A[zeta_6]`-modules or use Poincare self-duality.

## Rank-six theorem

Assume that a Tate shift of the endpoint `J_ell` occupies `ell` consecutive
nonzero grades of (2), and that every relevant Tate-shifted primitive packet
is included in the faithful identification with `V_6(Z)`.  Rank additivity
and (4) give

\[
 2\ell\le
 \sum_i\operatorname{rank}_A G_i
 =\operatorname{rank}_A V_6(Z)=\nu_6(Z).
 \tag{5}
\]

In particular,

\[
 \boxed{J_3\text{ in a threefold center}\quad\Longrightarrow\quad
        \nu_6(Z)\ge6.}
 \tag{6}
\]

Equivalently, every center with `nu_6<=4` is excluded from carrying the
endpoint indecomposable.  The bound is sharp at the level of ranks: the
endpoint `X x P^2` has three Tate grades, each containing the conjugate
primitive-sixth pair, and hence total primitive-sixth rank six.

The theorem is stronger than the earlier deliberately weak inequality
`ell<=nu_6`.  Its added hypothesis is exactly what licenses the improvement:
the strict filtration and every grade are stable under the same integral
cyclotomic action.  An arbitrary filtration, or an enrichment which records
only one complex eigenspace and forgets its conjugate, is outside its scope.

## Birational saturation

The framed multiplicity `nu_6` is birationally invariant for smooth
projective threefolds: weak factorization uses point and curve centers, whose
primitive-sixth support is zero.  Consequently the rank-six exclusion is
constant on every smooth birational class.  Conditional on the strict
cyclotomic realization, no member of a smooth birational class with one
representative satisfying `nu_6<=4` can carry the endpoint `J_3`.

This birationally saturates all landed `nu_6<=2` families—including the
prime-Fano, stated weighted-CI, smooth Fano cyclic-cover, `V_5`, and cubic
pencil classes—and would also discharge any future class with exact
`nu_6=4` without a sectorial multiplication calculation.

It is not a universal carrier theorem.  Arbitrary non-nef threefolds can have
larger primitive-sixth rank, and the strict cyclotomic Rees realization itself
is still the analytic/categorical input missing from the formal QDM.

## EJ/TT and mystery ledger

- **EJ:** count cyclotomic pairs per Rees grade.  The endpoint threat consumes
  three grades and therefore six formal dimensions.
- **TT:** the factor of two comes from `T`-stability of every strict grade,
  not from an unproved self-dual splitting or from categorical faithfulness
  alone.
- **Settled:** under the strict all-packet cyclotomic realization, the exact
  admission threshold `J_3 => nu_6>=6` and its smooth-birational saturation.
- **Open:** construct that realization and exclude `J_3` in the remaining
  birational classes with `nu_6>=6` (or without a computed finite rank).
