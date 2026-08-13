# C907 \(S_6\) endpoint-module gate for the nodal cubic-surface pencil

**Lane:** clebsch

**Verdict:** the current primitive-sixth QDM data do not define an actual
\(S_6=W(A_5)\) action on the strict endpoint Rees grades.  They nevertheless
give a stronger conditional conclusion for the specific root-marked
cubic-surface Lefschetz pencil: any strict, rank-preserving Rees refinement
of its primitive-sixth solution module has total rank two, so it cannot carry
a length-three string at all.  Under that necessary refinement hypothesis,

\[
 \operatorname{Hom}_{S_6}
 \bigl(A_5,\operatorname{Hom}(G_0,G_2)\bigr)=0. \tag{1}
\]

Thus the stationary second composite is vacuous for this cubic calibration.
The remaining gap is not an uncomputed \(S_6\) character.  It is the absent
strict relative Stokes/Gamma realization that would identify the
root-marked primitive direct image with a rank-preserving Rees refinement of
the QDM.  Without it, the \(S_6\) endpoint modules are not defined by the
available sources.

## 1. What is actually known for the pencil

Let \(X\) be a smooth cubic threefold, let \(\Gamma\) be the base of a
Lefschetz hyperplane pencil, and put

\[
 f:\widetilde X=\operatorname{Bl}_{\Gamma}X\longrightarrow\mathbf P^1.
 \tag{2}
\]

The framed blow-up comparison is an isomorphism of unmarked formal QDMs,
and the curve summand has empty primitive-sixth support.  The current C907
formal calculation therefore gives

\[
 \nu_6(\widetilde X)=\nu_6(X)=2. \tag{3}
\]

This is exact, not merely a lower bound: the cubic has one primitive-sixth
pair, and the weighted-complete-intersection upper bound is two.  Over a
splitting field for \(\Phi_6\), the primitive-sixth formal solution space
\(\mathscr V_6(\widetilde X)\) has one line for each of the two distinct
roots.  In particular,

\[
 \operatorname{rank}\mathscr V_6(\widetilde X)=2. \tag{4}
\]

Equation (3) is a statement about the small even QDM of the total threefold.
It does not arise from the stationary lattice
\(M=\delta^\perp\cap E_6=A_5\) of one nodal surface fibre.  The latter is a
root-marked summand of \(R^2f_*\); current C907 sources construct no functor
from that primitive direct image, or from its \(S_6\) marking symmetry, to a
Stokes/Rees refinement of \(\mathscr V_6(\widetilde X)\).

## 2. The rank theorem

Suppose a proposed strict cubic Rees realization of (2) has a finite
filtration on the primitive-sixth solution lattice, with associated grades
\(G_i\), and becomes \(\mathscr V_6(\widetilde X)\) after forgetting the
filtration.  Then

\[
 \sum_i\operatorname{rank}G_i=2. \tag{5}
\]

A length-three Rees string has three nonzero consecutive grades.  It is
therefore impossible under (5).  Equivalently, its second positive composite
is zero before any Picard--Lefschetz or stationary-lattice projection is
considered.

For the endpoint test of the preceding \(A_5\) report, if both \(G_0\) and
\(G_2\) are nonzero subquotients of this rank-two filtration, they each have
rank one and

\[
 \operatorname{rank}\operatorname{Hom}(G_0,G_2)=1. \tag{6}
\]

After tensoring with \(\mathbf Q\), the \(S_6\) standard reflection module
\(M_{\mathbf Q}\) is irreducible of dimension five.  Hence it cannot map to
the one-dimensional module in (6), proving (1).  The integral statement
follows because the strict endpoint lattices and \(M\) are torsion-free, so
an integral equivariant map would remain nonzero after rationalization.

This rank proof is the only honest computation presently available.  It
proves no universal statement about an arbitrary cubic-surface fibration:
one with a larger primitive-sixth QDM packet would not satisfy (4).

## 3. Plausible actions and the exact non-result

If a future root-marked construction makes the \(S_6\) action commute with
framed formal monodromy, it preserves the two distinct lines of
\(\mathscr V_6\).  Each line must then have a rank-one character of \(S_6\).
Since

\[
 S_6^{\rm ab}\cong\mathbf Z/2,
\]

the only possibilities are the trivial and sign characters.  For any pair
\(\chi_0,\chi_2\in\{\mathbf1,\operatorname{sgn}\}\),

\[
 \operatorname{Hom}(G_0,G_2)
 =\chi_0^{-1}\chi_2\in\{\mathbf1,\operatorname{sgn}\},
\]

and consequently

\[
 \operatorname{Hom}_{S_6}
 (M,\chi_0^{-1}\chi_2)=0. \tag{7}
\]

So even this unresolved linearization choice cannot revive the stationary
second composite in a rank-preserving refinement of the cubic pencil.

But no current source specifies either character.  The \(S_6\) action changes
the auxiliary marking of the nodal cubic surface; it is not an automorphism
of the unmarked QDM used to define \(\nu_6\).  The framed blow-up isomorphism
also has no asserted compatibility with equisingular marking transport.
Thus calling either character the *actual* action would be unjustified.

More seriously, a putative relative Rees object might introduce endpoint
modules not known to be subquotients of \(\mathscr V_6\).  In that case (5)
is unavailable and the current data place no \(S_6\) constraint on
\(\operatorname{Hom}(G_0,G_2)\).  The explicit equivariant map

\[
 \operatorname{Sym}^2(A_5)\longrightarrow A_5
\]

from the preceding report shows that a standard \(A_5\) channel can then
support a nonzero stationary square.  This is why the rank-preserving
comparison, not a guessed marking character, is the load-bearing condition.

## 4. Exact next strict test

To promote the conditional rank theorem to the carrier programme, a strict
relative construction need only certify all of the following:

1. its primitive-sixth Rees lattice for (2) forgets faithfully to the
   framed QDM primary space \(\mathscr V_6(\widetilde X)\);
2. the root-marked equisingular action is a linearization of that same
   lattice and commutes with formal monodromy; and
3. its local second composite is the stationary tensor considered in the
   \(A_5\) test.

Then (5) already excludes a \(J_3\) string, while (7) independently kills
the proposed stationary \(A_5\) coefficient.  If item 1 fails, the proposed
object is not yet a Rees refinement of the current QDM invariant, and its
endpoint modules must be supplied as genuinely new analytic data before an
\(S_6\) calculation has a defined target.

## EJ/TT and mystery ledger

- **EJ:** the exact cubic Lefschetz-pencil calibration is already below the
  corrected Silver rank threshold; it cannot be the sought length-three
  counterexample.
- **TT:** distinguish a root-marked fibre local system from the unmarked
  QDM of the total threefold.  The former has \(A_5\) symmetry, but no
  established functor carries it to the latter's Rees grades.
- **Settled:** conditional on the necessary rank-preserving realization,
  every possible \(S_6\) endpoint action gives the zero Hom group in (1).
- **Open:** construct that realization, or find a different del Pezzo
  fibration with a primitive-sixth packet of rank at least three and an
  identified \(S_6\) action.
