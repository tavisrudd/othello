# C907 coniveau square-zero carrier theorem

**Lane:** `clebsch`

**Status:** theorem-grade abstract mechanism for the two Mori-fibre carrier
branches.  A strict support-lowering Rees operator on a base of dimension at
most two has square zero after point-supported primitive packets are excised.
The nodal Clifford and stationary `A_5` examples do not refute this theorem;
they identify exactly the two strictness maps that still have to be proved.

## Filtered support setting

Let `K=Q(zeta_6)` and let `M` be a finite-dimensional `K`-vector space
equipped with a finite decreasing support filtration

\[
 M=F^0M\supset F^1M\supset\cdots\supset F^{d+1}M=0,
 \qquad d\le2.
 \tag{1}
\]

Equivalently one may work in an exact or stable category, provided the
successive quotients below are genuine exact quotients/cofibres and zero
cofibre is conservative.  Think of `F^c` as the part supported in codimension
at least `c` on the base of a Mori fibration.  Let `N:M->M` satisfy the
**strict coniveau condition**

\[
 N(F^cM)\subset F^{c+1}M.
 \tag{2}
\]

Assume moreover that the codimension-two primitive-sixth quotient is absent:

\[
 \operatorname{gr}^2_FM=0.
 \tag{3}
\]

For a surface base, (3) says that the strict value-localized realization of a
point-supported sector factors through the primitive-sixth packet of a smooth
point, which is zero.  For a curve base, `F^2=0` already for dimensional
reasons.

## Square-zero theorem

Under (1)--(3),

\[
 \boxed{N^2=0.}
 \tag{4}
\]

Indeed, for every `c`,

\[
 N^2(F^cM)\subset F^{c+2}M.
 \tag{5}
\]

If `d=1`, all targets in (5) vanish.  If `d=2`, the only possible target is
`F^2M`.  Equation (3) and `F^3=0` give `F^2M=0`, hence (4).

More generally, it is enough that the image of `N^2:M->F^2M` factor through
an exact point-supported primitive-sixth realization functor which vanishes;
literal equality `F^2M=0` is a convenient formulation, not a necessary one.

Provided the packet is a finite-dimensional nilpotent `K[N]`-module and
`J_3` is measured by this same operator `N`, (4) says every Jordan
indecomposable has length at most two.  Thus the theorem supplies the exact
universal center input needed by the conditional Silver theorem whenever the
MMP carrier is realized over a curve or surface with strict coniveau.

## Conic bundles over surfaces

For a conic bundle, the geometric primitive direct image lives on the
discriminant double cover.  The needed strict realization would make the
first Rees arrow branch-supported; a product of two distinct branch arrows
could then land at a discriminant intersection point.  The local even
Clifford algebra at a double-line node calibrates precisely this possibility:

\[
 i^2=j^2=0,qquad ij\ne0.
 \tag{6}
\]

Formula (6) calibrates a possible codimension-two support product.  It is not
the square of a single Rees operator—every element of the radical has square
zero—and becomes relevant to (4) only under a strict bridge identifying it
with the successive composite `N_1N_0`.  The landed clean primitive-sheaf
calculation gives zero stalk and costalk at the node after inverting six.
Therefore the exact remaining conic input is:

> identify the strict value-localized image of `ij` with the
> point-supported clean primitive object.

For standard smooth-total-space conic local forms, combine this
support-local factorization with the independently checked
smooth-discriminant and rank-two-cross square-zero models.  Under the three
strict comparison hypotheses—factorization through `P_pi`, support-local
multiplication, and Gamma/Rees compatibility—(3) then holds and the packet is
`J_3`-free.  Raw Clifford Loewy length is irrelevant because it precedes this
excision.  Arbitrary terminal conic bundles without the standard local-form
and strict comparison hypotheses remain outside the theorem.

## Del Pezzo fibrations over curves

For a del Pezzo fibration over a curve, strict coniveau already forces
`N^2=0`: there is no codimension-two support on the base.  The nodal
cubic-surface model has a stationary `A_5` summand at a discriminant point
and permits a nonzero square landing back in that same summand.  This is not a
counterexample to the theorem.  It shows that monodromy support alone does
not imply (2): the second arrow may remain in codimension one instead of
raising support again.

A factorization through `F^2=0` would force zero stationary projection.
Conversely, vanishing of that projection is sufficient only under clean-root
targeting, support-local multiplication, no horizontal escape sector, and an
exhaustive decomposition of the local primitive targets.  Under those
hypotheses the exact remaining del Pezzo input is:

> prove that the strict second Rees composite has zero stationary-primitive
> projection; the other target channels are then absent, so the composite
> factors through nonexistent codimension-two support on the base curve.

Without them, zero stationary projection is merely the smallest missing local
test, not strict coniveau: the composite could escape to a different
horizontal sector.

Conditional on equisingular `S_6` descent and the actual endpoint-module
identification, the landed calculation reduces this locally to

\[
 \operatorname{Hom}_{S_6}
 (A_5,\operatorname{Hom}(G_0,G_2)),
 \tag{7}
\]

and kills it when the endpoint grades are marking-trivial.  Equation (7) is
the finite representation test for strict coniveau at an `A_1` cubic fibre.

## Conditional Mori-fibre carrier theorem

Suppose the minimal cyclotomic Jordan packet is defined for smooth
threefolds and admits, for every conic-bundle or del-Pezzo-fibration Mori
model, a presentation-independent support filtration satisfying:

1. `N` raises base codimension strictly as in (2);
2. point-supported primitive-sixth images vanish after value-localized clean
   excision; and
3. the construction survives the terminal-model/resolution comparison.

Then every such Mori-fibre threefold has no `J_3`.  Together with the
admission theorem for the already computed `nu_6<6` Fano leaves, under the
strict all-shifts cyclotomic realization, and empty **formal** primitive-sixth
support on smooth `K`-nef models, this reduces the universal carrier
theorem—conditional also on faithful realization of that formal emptiness—to:

- rank-six-or-larger `rho=1` Fano models not already classified;
- terminal resolution/flip transport for Fano and Mori-fibre models;
- terminal minimal-model transport and enriched emptiness on the `K`-nef
  branch; and
- verification of the two local strictness statements above.

This is a conditional structural theorem, not a claim that MMP currently
constructs the filtration.  The explicit rank-six `rho=2` countermodel shows
why base coniveau, rather than cohomological rank, is the indispensable new
input.

## EJ/TT and mystery ledger

- **EJ:** both Mori-fibre branches ask for the same theorem: `N` must raise
  base support twice.  On a curve the second target is absent; on a surface
  it is a point packet and must be excised.
- **TT:** finite discriminant support is not strict coniveau.  A stationary
  summand can absorb a second arrow without moving to deeper support.
- **Settled:** the abstract square-zero mechanism and the exact translation
  of the Clifford-node and stationary-`A_5` regressions into its two local
  hypotheses.
- **Open:** construct the presentation-independent coniveau filtration,
  prove support-local factorization at conic nodes and stationary projection
  zero for del Pezzo nodes, and transport it through terminal resolution.
