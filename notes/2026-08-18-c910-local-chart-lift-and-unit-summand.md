# C910 — the local chart's depth-one self-adjoint lift and its unimodular summand

**Task:** C910 (`cubic-threefolds`) — Lean companion for
`papers/cubic-stabilization-m1/`.
**Date:** 2026-08-18.  **Authority commits:** `73db2f51b`, `1ae082209`.
**Predecessor:** the claim-map review
`2026-08-18-c910-cycle-side-and-absent-rows-review.md`, which recorded that two
clauses of `lem:six-axis-local-chart` had neither a terminal nor a fragment.

Those two clauses are now covered: that the principal quotient is trivial on the
unimodular summand, and that the residue slope has a depth-preserving integral
lift self-adjoint for the dual coefficient form.  The pass also proves the
lemma's opening decomposition as an actual change of basis rather than a list of
pairing values.  The row remains a fragment, because the geometric kernel and its
slope are still absent from the package.

## What the manuscript needs, and what is now proved

### The depth-one lifting construction

The manuscript states, in running text between statements, that for a unimodular
lattice `U` with symmetric Gram matrix `B`, every endomorphism of `U/pU`
self-adjoint for the reduced dual form `B⁻¹` lifts to an endomorphism of `U`
satisfying `TᵀB⁻¹ = B⁻¹T`, and that the construction divides by nothing.  The
Lean proof follows that argument exactly, in
`GraphLattices/DepthOneSelfAdjointLift.lean`.

A two-sided inverse of a symmetric matrix is symmetric, so the adjointness defect
`TᵀB⁻¹ - B⁻¹T` is skew for the transpose.  Choosing any matrix reducing to the
given residue endomorphism, its defect vanishes modulo `p`, hence equals `p D`;
cancelling `p` shows `D` skew, and cancelling `2` shows `D` has zero diagonal.
Fixing a linear order on the coordinates and taking `C` to be the strictly lower
triangular part of `D` gives `Cᵀ - C = -D` — the step that replaces halving —
and `T + p·(B C)` has the same reduction modulo `p` and vanishing defect.  The
reduction is stated with the quotient `R ⧸ (p)` and the entrywise reduction of
matrices along it, so the terminal really is a lifting statement about
endomorphisms of `U/pU`, not a divisibility rearrangement.

Two further statements record how the construction meets an orthogonal
decomposition: a block-diagonal matrix is self-adjoint for a block-diagonal
inverse Gram matrix as soon as each block is, so lifts built separately on
orthogonal summands assemble and the depth decomposition is preserved; and a
scalar matrix is self-adjoint for every inverse Gram matrix, which is the
manuscript's "extend each lift by a scalar on `U₀`".

The coefficient ring enters in exactly two places, and only through cancellation:
`p` and `2` are required to be nonzero in a domain.  Nothing is inverted, which
is the precise content of the manuscript's claim that no division by two occurs.

### The unimodular summand carries no discriminant

Multiplication by the coefficient matrix is the map to the dual lattice in the
same coordinates, and the quotient by its image is the discriminant group.  Three
general lemmas in `GraphLattices/SixAxisDiscriminantSupport.lean` do the work for
any reduction `L G R = M` by an invertible `L`.  If `M` carries some vector to a
coordinate vector, the corresponding reduced basis vector `L⁻¹ e_i` already lies
in the image of `G`; consequently every vector is congruent modulo that image to
a combination of the remaining reduced basis vectors; and if `M` carries some
vector onto a fixed multiple of an arbitrary vector, that multiple annihilates
the quotient.

The lemma's summand is realized twice.

In the chart itself, over any coefficient ring in which five has an inverse — the
two-adic and three-adic cases the manuscript uses — the chart change of basis is
the identity plus the elementary matrix adding `1/5` times the first coordinate
to each other coordinate.  That elementary matrix squares to zero, so the change
of basis is invertible with the obvious inverse; its first column is the first
coordinate vector and its other columns are the displayed complement vectors; and
it carries `6I₅-J₅` to the block matrix whose unit line has value five and whose
complementary block is `(6/5)(5I₄-J₄)`.  This is the manuscript's
`(Z_p⁵,G) ≃ U₀ ⊥ pU₁` as a congruence, not merely as the previously formalized
list of pairing values.  The first chart dual vector is then in the image of the
form, and every vector is congruent modulo that image to a combination of the four
chart dual vectors orthogonal to it.

Over the integers the same conclusion follows from the package's existing Smith
reduction `L (6I₅-J₅) R = diag(1,6,6,6,6)`: the constant vector, which is the
reduced basis vector of the unimodular coordinate and has value five under the
form, lies in the image; every integral vector is congruent modulo the image to a
combination of the four other reduced basis vectors, whose Smith entries have
exact depth one at two and at three; and six annihilates the quotient.  At either
prime dividing six the primary part is therefore supported on the four depth-one
coordinates, which is what the manuscript uses to place the primary isogeny
kernel on `U₁/pU₁`.

## Coverage

`lem:six-axis-local-chart` gains four reviewer terminals and remains a fragment.
The snapshot is 50 claims and 46 machinery rows over 224 terminals: 10 absent, 21
fragmentary, 18 conditional, 1 complete.  Two modules are new,
`GraphLattices/DepthOneSelfAdjointLift.lean` and
`GraphLattices/SixAxisDiscriminantSupport.lean`; the chart change of basis and
the congruence live in `GraphLattices/SixAxisLocalChart.lean` beside the pairing
calculations they extend.

## Gates

All green at `1ae082209`.  Each new or changed module was elaborated singly, both
library targets were built through the guarded queue, and `make check` and the
axiom-log check pass over 117 sources and 224 terminals.  Each new terminal
reports `propext, Classical.choice, Quot.sound`.  The manuscript changed only in
the terminal list of the annotation on this lemma; the tracked PDF rebuilds
byte-identically at 49 pages.

## Scope

The geometry remains outside Lean.  There is no elliptic scheme, polarization,
isogeny, or geometric principal kernel, so the lifting terminal is about matrices
and does not identify the residue endomorphism with the slope of an actual
kernel, and the discriminant terminals do not identify the quotient by the image
of the form with an isogeny kernel.  Surjectivity of `Sp₂(Z₃)` onto `Sp₂(F₃)`,
which the manuscript uses to lift a complementary symplectic ruling at three, is
not formalized.  The passage from these data to the marked finite-étale graph
presentation consumed by `thm:all-degree-graph-saturation` is likewise not
formalized; that presentation is what the lemma feeds, and it needs the geometric
identification, not more of this algebra.

## Mystery ledger

- Settled by this pass: the manuscript's unimodularity hypothesis on `U` is used
  only through invertibility of its Gram matrix.  The lift therefore holds on any
  orthogonal summand whose Gram matrix is invertible over the coefficient ring,
  slightly more than the statement claims, and the depth-one hypothesis plays no
  role in the construction — it enters only when the summand is used.
- Settled by this pass: no `p`-adic lattice theory is needed for the triviality
  of the principal quotient on `U₀`.  A single coordinate that a reduction makes
  unimodular gives it, and the same three lemmas cover both the chart congruence
  and the integral Smith reduction.
- Open, and small: the two realized unimodular summands are different lines that
  both have value five — the constant vector over the integers, the first chart
  vector after inverting five.  The value is a unit at two and three either way,
  so the discriminant conclusion is the same, but the form's determinant `6⁴`
  does not force the value five, and nothing in the package explains why both
  natural choices land on it.  Evidence gap: no invariant-theoretic statement
  about which values a unimodular rank-one orthogonal summand of this form can
  take.  Owner: none allocated; it changes no manuscript claim.
- Open: the Smith form says the discriminant group is exactly `(Z/6)⁴`, and Lean
  proves only the two halves the manuscript uses — that six annihilates it and
  that it is carried by four coordinates.  Evidence gap: no terminal computes the
  quotient itself.  Owner: a successor only if a later statement needs the exact
  group.

## Next

The remaining absent rows are the Section 5 framed-monodromy statements
(`prop:ranktwo-framed-germ`, `lem:simple-euler-block`, `cor:cubic-formal-germ`,
`prop:projective-product-nu`, `lem:exact-low-degree-shifts`) and the separation
corollaries (`cor:voisin-separation`, `cor:fermat-separation`,
`cor:coprime-separation`, `prop:A5-nonseparated`).  The framed-germ rows remain
the cheapest genuine coverage, since the rank-two rigidity algebra and the
formal-germ calculus they need are already in the package.

## Export status

Exported.  The standalone paper repository
`~/src/math-papers/cubic-stabilization-m1` was synchronized from authority
`1ae082209` with a zero-finding coupling audit, and its own `make check`, pinned
Lean build, and axiom-log replay agree with the authority over 224 reviewer
terminals.
