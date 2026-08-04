import RelativeConicArcs.Gates.AMELUDefinitions
import RelativeConicArcs.Gates.AMELUDictionary
import RelativeConicArcs.Gates.AMELUStabilizerDictionary
import RelativeConicArcs.AMELU.DiagonalIsoduality
import RelativeConicArcs.AMELU.EncoderTransversal
import RelativeConicArcs.AMELU.SyndromeGeometry
import RelativeConicArcs.Gates.AMELUPencilClassification
import RelativeConicArcs.AMELU.LUPencilClassification
import RelativeConicArcs.Gates.AMELUExtensionFieldPencil
import RelativeConicArcs.Gates.AMELUMarginalMoment
import RelativeConicArcs.Gates.AMELULogicalPhaseFourCopy
import RelativeConicArcs.Gates.AMELUTransportDivisor
import RelativeConicArcs.Gates.AMELUPartyExtensionSplitting

/-!
# Import gate for diagonal isoduality and transversal Clifford groups of MDS--CSS codes

This import-only module is the semantic root of the formal companion to the
manuscript on diagonal isoduality and transversal Clifford groups of MDS--CSS
codes.  Its transitive closure is the exact body of Lean material that this
manuscript cites; nothing outside that closure may be described as checked for
it.

## Objects

Throughout, `𝔽` is a finite field of order `q`, a code `C ⊆ 𝔽^(2m)` is linear
of dimension `m` and minimum distance `m+1`, and `Cᗮ` is its dual under the
standard bilinear pairing.  The equal-phase state of `C` is the uniform
superposition of its words in the computational basis of `(𝔽^q)^(⊗2m)`; its
Pauli stabilizer label group is `L_C = C × Cᗮ` inside the symplectic Pauli-label
space, with the `X(a)Z(b)` Weyl convention and the finite-field trace phase
fixed once in the shared conventions module.  Local operations act factorwise,
projective statements are taken modulo scalars, and party permutations act by
relabelling tensor factors.  At `2m = 6` the code is presented by an ordered
six-arc in the projective plane over `𝔽`.

`C` is *diagonally isodual* when a diagonal matrix carries `C` to `Cᗮ`; such a
matrix is a *diagonal duality multiplier*, and the space it spans is the
*multiplier space*.  The *fixed-party projective transversal group* of the
associated one-logical-qudit code is the group of projective logical actions
implemented by product unitaries that fix every party setwise.

## Contents of the closure

The closure carries, unconditionally:

* the dictionary between ordered six-arcs, exact `[6,3,4]` codes, equal-phase
  CSS states, and the absolutely maximally entangled property, together with
  the equivalence `IsAME (equalPhaseState C) ↔ IsMDSCode634 C`;
* the stabilizer dictionary: the tensor Weyl action of `L_C`, the Lagrangian
  property of the CSS label space, the exact support criterion, minimality of
  the computational support, and the realization of every linear character on a
  Pauli-label subspace by symplectic pairing with an ambient label, which is the
  linear-algebraic content of the Pauli phase correction;
* the multiplier line and nullity test: a nonzero diagonal duality multiplier
  has full support, the multiplier space has dimension at most one, isoduality
  holds exactly when that dimension is one, and the witness is unique up to a
  unit scalar;
* the coset and syndrome geometry of translated equal-phase states: distinct
  cosets give orthogonal states, `Z`-type labels read the translation character,
  and every syndrome has exactly one minimum-weight representative supported on
  a given three-party set;
* the algebraic pencil quotient `z` and its four-branch `y` reduction;
* the Frobenius-sector divisors of the twisted pencil, the Gale pairing
  multiplier and its vanishing criterion, sector disjointness, and the
  equivariance of the pencil coordinates under a field automorphism;
* the marginal-moment algebra with its exhaustive six-party graph counts;
* the split-torus Weyl block relations underlying the logical phase;
* the cycle-polynomial factorizations of the transport divisor and their
  reduction to `(z-2)(9z-4)`, including the characteristic-seven merger; and
* the abstract consequences of a realized party-permutation extension: its
  normalized factor set, the change-of-section law, the equivalence between
  trivializability and splitting, and the order of the split middle group.

The following terminals are *hypothesis-explicit interfaces*.  Each takes a
structure whose fields state geometric, propagation, orbit-recognition, or
finite-certificate inputs that are not proved in this closure, and derives its
conclusion from those fields.  Importing this gate therefore does not turn any
such field into an axiom or into a theorem of the closure:

* the exact fixed-party affine special-linear or split-torus carrier and its
  diagonal-isodual and nullity dichotomies, including the generalized
  Reed--Solomon case and the order `7²·|SL₂(7)| = 16464` instance;
* the projective, monomial, and local-Clifford classification of the admitted
  non-GRS pencil and its local-unitary consequence;
* the marginal-moment separator, the fixed-party logical-phase kernel, and the
  four-copy separator at `q = 13`; and
* the transport determinant, rank, and orbit-geometry bridges.

## Computational method and trust boundary

Three finite six-party graph cardinalities in the marginal-moment material —
the triple, star, and perfect-matching counts — are discharged by exhaustive
native evaluation, which exposes declaration-local implementation axioms of the
pinned toolchain.  The rank-four multiplicity identity and the marginal-moment
separator are proved from the star count and therefore inherit its evaluation
axiom.  Every other terminal listed above is checked by kernel reduction and
depends on no more than propositional extensionality, choice, and quotient
soundness.  The axiom audit module accompanying this gate prints the exact
dependencies of every terminal this manuscript cites.  Certificate data
for the finite separators, transport orbits, and party-splitting complements
lives in the manuscript's evidence package rather than in Lean: the interfaces
above name those numbers as hypotheses, and Lean checks only the deductions
made from them.

## Import boundary with the companion rigidity paper

The companion paper on local-unitary rigidity for stabilizer AME states owns
the arbitrary-additive rigidity theorem, the transversal Clifford no-go, the
Pauli phase-correction lemma, and the minimum-support atlas.  This manuscript
cites those results and does not reprove them.  Two of them are visible inside
this closure because the present proofs invoke them directly: the length-generic
equal-phase rigidity implication used by the pencil corollary, and the encoder
conversion theorems used by the no-go corollary.  Their formal ownership
remains with the companion development; this gate imports them and adds nothing
to them.

Deliberately outside this closure are the companion paper's quantitative
rounding and cleaning estimates, partial-Weyl recognition, two-uniform
discreteness and stability, the robust symplectic atlas, and the arbitrary-additive
stabilizer supported-label and holonomy-centralizer developments.  None of
those is used by any statement of this manuscript.
-/
