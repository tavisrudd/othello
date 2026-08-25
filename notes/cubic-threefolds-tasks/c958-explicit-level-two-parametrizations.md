# C958 -- explicit level-two parametrizations

**Lane:** cubic-threefolds

**Status:** active; C956's accepted quotient and rationality statements are
frozen inputs

## Current state

The generic split Cox orbit section is explicit and certified over `Q(a,b)`:
three tangent hyperplanes, four signed minors, and all sixteen Laurent
correction factors.  The formulas and replay are in
`notes/2026-08-24-c958-generic-split-parametrization.md` and its adjacent
`.py`, `.json`, and `.sha256` bundle.  The certificate deliberately stops
before inverse tangent elimination.

The first genuine gate is descent.  Tschinkel--Zhang's fibration coordinate
`a` is not the split blow-up modulus `a`; their type computation supplies the
Galois action but not an explicit change to the marked Cox basis.  Begin with
type `I_1`: realize the permuted conic-fibre components over the cubic and
quadratic étale algebras, use trace coordinates to derive the `C2 x S3`-
equivariant descended Cox representation, and express a rational
tangent/orbit-test pair in it.  Descend the four block evaluations and their
Plücker coordinates before expanding the full hyperplanes.

The finite permutation part of this descent is now exact.  After an explicit
`W(D5)` conjugation, the twelve selected Cox coordinates form the regular
type-`I_1` Galois set, while the four boundary coordinates and the four
quotient blocks are both `G/C3`.  Thus the scalar-normalized affine Cox module
has the prospective descended form `L + L^C3`.  The remaining gate is to
construct the scalar normalization and trace coordinates over the generic
function field, not to identify the Galois permutations.  Report and replay:
`notes/2026-08-24-c958-type-i1-descent-action.md` and its adjacent bundle.

The divisor-level change of marking is explicit as well.  Solving the five
singular-fibre component conditions produces exactly sixteen line sections,
indexed by the odd subsets, over the degree-twelve field
`K(r,d,v)`.  Exact substitution checks the cubic equation and the full
`C2 x S3` action on every coefficient.  After contraction of the distinguished
line these are the marked exceptional curves `Ei,Lij,Q`.  The next step is to
contract the five singleton curves, or equivalently normalize their Cox
sections at a rational torsor point.  Report and replay:
`notes/2026-08-24-c958-type-i1-exceptional-sections.md` and its adjacent bundle.

The entire splitting field has now been rationalized as `Q(a,z)`.  The base
parameter `beta` is a coprime degree-twelve invariant of an explicit
order-twelve Möbius group isomorphic to `C2 x S3`; the radical generators and
all sixteen exceptional sections are compact rational functions of `a,z`.
This cuts the total line-formula size by more than half.  The preferred next
step is therefore the six-line quadric interpolation giving the split
blowdown to the marked plane, followed by invariant descent.  Report and
replay: `notes/2026-08-24-c958-type-i1-rational-splitting-cover.md` and its
adjacent bundle.

The split blowdown is explicit.  Three unique quadrics through a common
reducible twisted cubic and the three coordinate twisted cubics give the
marked plane map.  After normalization the six contracted lines map to the
four standard points together with `[1:A^2:B^2]` and `[1:A:B]`.  Hence the
actual change to the C956 split Cox moduli is
`(a_Cox,b_Cox)=(A^2,B^2)`.  The next algebraic step is the inverse
anticanonical cubic map through these six points; the remaining arithmetic
step is invariant descent under the explicit Möbius group.  Report and
replay: `notes/2026-08-24-c958-type-i1-split-blowdown.md` and its adjacent
bundle.

The inverse split map is complete as well.  The cubics through the six plane
points form a four-dimensional anticanonical system; the six exceptional
tangent lines determine its alignment with the given cubic by a rank-fifteen
linear system.  Exact substitution proves that the four cubics land on the
surface and that the quadratic blowdown after the cubic map is the identity.
Birationality of the proved blowdown gives the opposite composite.  Thus only
ground-field descent with the two stabilizing variables remains for type
`I_1`.  Report and replay:
`notes/2026-08-24-c958-type-i1-split-inverse.md` and its adjacent bundle.

The residual rank-two factor is now identified integrally: it is the norm-one
torus of `E=K[rho]/(rho^3-3a^2rho-beta)`.  The independent quadratic
generator acts trivially.  Its cocharacter lattice is the `A2` augmentation
lattice, not the index-three dual quotient lattice, so naive projectivization
does not give the required chart.  The exact norm cubic and a symmetric
Cayley model are retained.  Next derive the explicit ground-field rational
parametrization of this norm-one surface, then couple it to the equivariant
torsor trivialization.  Report and replay:
`notes/2026-08-25-c958-type-i1-residual-norm-torus.md` and its adjacent bundle.

The norm-one torus is now parametrized explicitly over `Q(a,beta)`.  A
Cremona transformation sends its norm cubic to a quadric with the rational
point `[-3a^2:0:1:3a^2]`; projection from that point and the formulas
`(Z,h)=(x+x^-1+1-Tr(x),N(x-1))`, `x=1+h/Z` give compact forward and inverse
maps.  Both composites are exact symbolic identities.  The conjugate-ratio
attempt is also diagnosed: it uses an index-three character sublattice and
therefore has degree three.  The only remaining type-`I_1` descent gate is
the equivariant universal-torsor translation coupling this chart to the
already explicit surface maps.  Report and replay:
`notes/2026-08-25-c958-type-i1-norm-torus-parametrization.md` and its adjacent
bundle.

The projective Cox scalar ambiguity is now normalized as well.  Exact
composition of the split inverse with each conjugate blowdown gives the three
marked-plane Cremona actions.  Pullback through the C956 marking identifies
the quotient characters as `E1-E3,E2-E3`.  Normalizing the Cox lift above the
ground point represented by `[1:0:0:1]` makes every defining relation of
`C2 x S3` have trivial residual defect, and leaves a compact explicit
rank-two cocycle.  The remaining type-`I_1` gate is now precisely the generic
Hilbert--90 coboundary for that cocycle.  Report and replay:
`notes/2026-08-25-c958-type-i1-cox-descent-cocycle.md` and its adjacent
bundle.

A Cox-monomial coboundary has been ruled out exactly.  With the correct dual
action convention, the divisor equations have a one-dimensional rational
solution space, but the `E1,E2` exponents have an unavoidable half-integral
parity defect; the direct convention is inconsistent.  This rules out only
Laurent monomials in the sixteen standard Cox forms, not general rational
coboundaries.  The next constructive route is therefore the full
stable-permutation resolution `Pic(Sbar) + P5 = P11`, followed by orbitwise
Hilbert--90 coordinates.  Report and replay:
`notes/2026-08-25-c958-type-i1-coboundary-divisor-test.md` and its adjacent
bundle.

The general rational coboundary is now constructed as a straight-line
program.  Ground-lift normalization makes the Cox descent strict; comparison
with the affine generic Cox section produces a genuine rank-six Picard-torus
cocycle.  Tschinkel--Zhang's unimodular rank-eleven permutation basis has
type-`I1` orbits of sizes `6,4,1`; three orbitwise Hilbert--90 sums and the
integral inverse basis give the six-coordinate coboundary.  An exact rational
specialization proves all chosen sums nonzero.  Thus the generic
universal-torsor splitting gate is closed.  Next compose this SLP with the
norm-torus chart and the certified tangent quotient, then verify the forward
and inverse cubic-product maps.  Report and replay:
`notes/2026-08-25-c958-type-i1-full-coboundary.md` and its adjacent bundle.

The coboundary is now coupled to the norm-torus chart.  In split coordinates
the forward recipe is `q_D=f_D h_D^-1 r1^a_D r2^b_D`; dualizing the lattice
change gives `(r1,r2)=(t3,1/t1)`.  Three degree-`H`, residual-weight-zero Cox
monomials recover the marked-plane point, and two corrected exceptional
ratios recover `(r1,r2)`, so both composites of
`S x P2 <-> Z/T3` are certified on a dense open.  The only remaining
type-`I1` geometric map is an explicit ground-field tangent quotient
`Z/T3 <-> P4`, after which the cubic function-field composition is routine.
Report and replay: `notes/2026-08-25-c958-type-i1-torsor-coupling.md` and its
adjacent bundle.

The ground-coordinate infrastructure for the tangent quotient is now exact.
The strict twelve-element semilinear Cox descent has an explicit invertible
orbit-trace basis; a bounded closeout reduces its seed from `z^11` to `z`.
In the split chart `E3=1`, the three tangent-section equations are linear in
the marked-plane coordinates, so Cramer's rule recovers `(z1,z2,z3)` from
`(E1,E2,E4,E5)`.  A primary SymPy replay and independent stdlib determinant
checker agree.  The remaining type-`I1` gate is now the four-parameter inverse
from five ground tangent coordinates to the exceptional parameters, not Cox
descent or plane-coordinate elimination.  Report and replay:
`notes/2026-08-25-c958-type-i1-tangent-quotient.md` and its adjacent bundle.

At the cold specialization `(a,b)=(2,3)`, tangent `z=(1,3,7)`, the remaining
four-parameter map now has an exact common-denominator quintic inverse
candidate.  Complete modular searches rule out degrees one through four and
give a unique relation in degree five; exact rational lifting yields sparse
integer formulas, and an independent stdlib checker verifies both composites
at two hundred fresh points over a second prime.  Thirty exact rational
holdouts per coordinate pass as well.  A sparse arbitrary-precision Rust
checker additionally clears all rational row, Cramer, and Cox denominators and
proves the entire forward-then-inverse polynomial identity coefficientwise
over `Z`; the nonzero cleared denominator has `124666` terms.  Thus the
characteristic-zero rational inverse is certified at this specialization.
The next exact gate is reconstruction and sparse verification over `Q(a,b)`,
followed by ground specialization.  Report and replay:
`notes/2026-08-25-c958-specialized-quintic-tangent-inverse.md` and its adjacent
bundle.

A second cold specialization `(a,b)=(3,5)` is now proved over `Z` by the same
parameterized Rust checker, with identical quintic supports.  Generic modular
reconstruction is also sharply bounded: all 482 coefficient functions have
stable supports and validated one-variable degree bounds, and seven-prime CRT
resolves 39456 of 39492 dense scalar coefficients.  The remaining 36 exceed
the current `~7e20` uniqueness bound.  No uniform characteristic-zero formula
is claimed until those coefficients, fresh-prime holdouts, and the generic
denominator-cleared identity pass.  Report and replay:
`notes/2026-08-25-c958-generic-reconstruction-frontier.md` and its adjacent
scripts/hash manifest.

## Goal

Turn the constructive existence proof in C956 into explicit, independently
checkable forward and inverse birational maps for
`X_1 x P2` and `X_3 x P2` over `Q`.

## Stable inputs

- C956 report:
  `notes/2026-08-24-c956-exact-level-two-cubic-manuscript.md`
- theorem and proof:
  `papers/cubic-stabilization-irrationality/cubic_stabilization_irrationality.tex`
- exact tangent certificate:
  `papers/cubic-stabilization-irrationality/verification/slice-cover-certificate.json`
- replay checker:
  `papers/cubic-stabilization-irrationality/verification/check_slice_cover.py`

Load the C956 report and the quotient/tangent/function-field sections, not the
C925 research history.

## Deliverables

1. Choose rational tangent-section witnesses for the type-`I_1` and
   type-`I_3` generic quartic-del-Pezzo fibres used by the two cubic families.
2. Compute the signed-minor orbit correction and inverse tangent projection
   over the corresponding function fields.
3. Compose these maps with the contraction of the distinguished line and the
   cubic fibration to obtain forward and inverse maps for `X_j x P2`.
4. State the dense opens, denominators, and exceptional loci on which both
   compositions are identities.
5. Produce a compact exact certificate and an independent replay. Record
   coefficient growth and formula size; do not claim a complexity bound
   unless a uniform theorem is proved.
6. Decide whether compact formulas strengthen the main paper, an ancillary
   machine-readable artifact is preferable, or the expanded maps are too
   large to improve reviewability.

## Acceptance gate

- Both maps are defined over `Q`, not merely over a splitting field.
- The certificate checks every defining equation after substitution and both
  composites on explicit localized coordinate rings.
- Descent is invariant under common character translation and does not
  reintroduce the nonsaturated `mu_2` cover.
- Function-field variable counts agree with the dimensions involved.
- A human derivation explains the maps independently of the replay.
- Any manuscript change passes the full C956 authority and standalone gates.

## Completed first action

Read `../AGENTS.md` in a dedicated command, route with
`go C958 cubic-threefolds`, read this card and the C956 report, then extract
the exact formulas in Theorem 2.1 and Proposition 3.2 before choosing the
type-`I_1` witness. Do not begin from the superseded intermediate bounds.

## Queued successor

C963 consumes the accepted type-`I_1` and type-`I_3` ground-field maps after
this task closes. It packages them as a proof-producing stable-rationality
workbench with exact straight-line programs, localized inverse certificates,
exceptional-locus data, measured complexity profiles, and a certified account
of the one-extra-variable cancellation geometry. C963 must not begin by
replacing or weakening any C958 acceptance gate.
