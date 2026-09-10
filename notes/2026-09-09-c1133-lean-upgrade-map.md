# C1133 — Lean additions for the m=1 upgrade

**Date:** 2026-09-09. **Disposition:** implementation map with guarded completion checkpoint.
The mathematical scope is [the acceptance map](2026-09-09-c1133-acceptance-map.md); the literature
and exact sharpness/moduli companion imports remain open. The initial map
performed no implementation; the checkpoint below records the subsequent
authorized Lean work. No manuscript promotion, export or outreach followed.

## Implementation checkpoint

The guarded public checkpoint is **371 terminals, 133 machinery terminals,
245 sources**. The aggregate build and actual axiom comparison pass. All
new terminals use only `propext`, `Classical.choice`, and `Quot.sound`.
The core algebra and conditional A–D assemblies are implemented. Exact
fully qualified declarations, validation runs and limitations are in
`2026-09-09-c1133-lean-completion-progress.md`.

- L1–L3: actual canonical adapted lattices and regular comparison transport;
  all seventeen matrix polynomials and cyclic bases; nine full rank-two
  gauge/residue certificates; four rank-three splittings; full super-primary
  projectors, pairings, odd allocation, persistence and exact selectors.
- L4: actual completed exponential ring maps, grading-derived polynomial bulk
  layers, an equivalent graded source subring and faithful unital center ring
  homomorphisms, fixed-locus coordinate equivalences,
  faithful localizations and independent occurrence determinant separation.
- L5: point/curve/surface block nullity is derived before factorization;
  normalized counting endpoint connections feed the nine/eight rationality
  deduction through actual endpoint and projective-line ledger realizations.
- L6: full equivariant image objects, formal idempotent conjugacy, actual
  semisimple objects and categorical doubled cancellation, whole-object
  occurrence conservation, fixed-weight periodization and rational morphism
  descent. Actual rational Hodge projector objects and rational inverse
  matrices give whole-object conservation through complex comparison and
  rational Hom scalar-extension fullness, without separate rational descent
  of splitting branches. Endpoint ranks may be specified independently.
  Transport through a supplied category equivalence is also available.
- L7: source-restricted reconstruction has a very general source and arbitrary
  smooth target; arithmetic finiteness ranges over all model extensions of
  bounded degree and counts geometric classes through finite kernels and
  polarization fibers. The reconstruction and isogeny inputs receive actual
  rational Hodge isomorphisms in the strengthened application interfaces.

**Boundary:** this is not a complete construction of geometric quantum or
Hodge theory in Lean. Varieties, geometric block/comparison realizations,
Hodge categories and their semisimplicity, rational controls, classification,
Torelli and arithmetic source theorems remain explicit inputs. The actual
graded coefficient-family source is now equivalent to a proved subring, with
an injective unital ring map. The universal residue manuscript proposition
still has fragment coverage beyond its checked matrix reductions. No existing
manuscript claim was promoted by the conditional A–D assemblies: coverage
remains 13 absent, 27 fragment, 26 conditional deduction, 1 complete.

L8 remains optional. Full literature closure and manuscript/hierarchy review
remain open under C1133. The baseline below is frozen pre-implementation
evidence, not the current coverage count.

## Recommendation

Extend the existing package in `papers/cubic-stabilization-m1/lean/`.
Start with exact rank-two lattice transport and the universal residue reduction,
then certify the seventeen matrices and implement the two numerical selectors.
Build the Hodge-valued branch on that common infrastructure. Keep the corrected
rank-three residue and uniform odd-dimensional cubic formula optional.

The main classification uses two independent detectors: a rank-two exact-residue
lattice count for degrees 1,2,3 and genera 6,8, and the odd contribution of
whole even-rank-three factors for genera 2,3,4,5. The latter does **not** require
the optional rank-three modified-residue theorem.

A second essential distinction: the existing exponent-class marker vanishes
when the difference is an integer. The upgrade must detect discriminant 1
(degree 2 and genus 6), so it cannot be implemented by adding table entries to
that marker. Exact canonical residues, including resonant ones, are necessary.

## Inspected baseline and reusable declarations

The source-only checker passed on 2026-09-09:
186 sources, 319 public terminals, 67 manuscript claims, 83 machinery terminals,
22 imported-source records, 5 evidence records. Coverage is 14 absent,
26 fragment, 26 conditional deductions, 1 complete. These counts cover all
three current manuscripts; they are not counts for the proposed upgrade.
This is source correspondence, not a fresh kernel replay.

The adjacent [baseline](2026-09-09-c1133-lean-baseline.json) records exact source hashes and selected
fully qualified declarations. Every declaration below exists in that snapshot.

- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.effectiveBlockLedger_fold_unique`
  already works for **any additive commutative monoid**, not only natural counts.
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.occurrenceIndexedMarker_eq_of_birational`
  already works in arbitrary ambient dimension with that same general target.
  Its factorization provider and low-dimensional nullity remain supplied.
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.genericSpectralConnection_normalizedSplitting`
  constructs a normalized splitting from separated matrix data and recurrences;
  it does not construct a quantum connection or derive its geometric premises.
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.atomicRankTwo_residueDiscriminant_frozen_by_horizontality_and_flatness`
  derives nilpotent-line preservation, base regularity and discriminant rigidity
  from actual coefficientwise matrix identities.
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.atomicRankTwo_residueDiscriminant_constant_over_formal_germ`
  supplies formal constancy once a centered adapted block exists.
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.rankTwo_commutant_of_unit_offDiagonal`
  does not assume nilpotence; it is reusable for cluster persistence.
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.rankTwoCluster_nilpotent_persists_on_formal_germ`
  already gives the rank-two persistence algebra from compressed flatness data.
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.atomicResidueDiscriminant_invariant_under_frame_change`
  proves invariance under **supplied conjugation**. It does not show that an
  original-lattice comparison induces such conjugation on the modified lattice.
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.cubicSmallEven_blockReduction`
  and `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.cubicZeroBlock_modifiedResidue_indicialPolynomial`
  provide the existing cubic reduction, not the general seventeen-family one.
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.hodgeFixedSubalgebra_closed_under_eulerMultiplication`
  is fixed-vector algebra. It does **not** provide the upgrade's fixed-base
  theorem with the entire even/odd cohomology fiber retained.

Current claim rows `lem:constant-residue-spectrum`,
`prop:intrinsic-spectrum-formulas`, `prop:universal-rank-two-residue`, and
`thm:index-two-classification` are absent. The new all-seventeen classification,
Hodge conservation and downstream applications have no current claim rows.
The existing rank-two cluster algebra is reusable despite the absent coverage
of a geometric cluster-persistence assertion; these are different claims.

## Concrete work packages

Module names in this section are **proposed**, not existing declarations.
Paths are relative to
`lean/TavisRuddFiniteGeom/Papers/CubicStabilizationM1/` inside the paper package.

### L1 — canonical rank-two lattice and comparison transport

Proposed `Quantum/RankTwoCanonicalLattice.lean`.
Represent the original free power-series lattice, its leading nilpotent line,
and the modified lattice as the preimage of that line under reduction modulo z.
Show the adapted-coordinate description and compute its residue. Given a regular
horizontal comparison and a regular inverse, derive preservation of the leading
line, preservation of the modification, invertibility of the induced comparison,
and conjugacy of the modified residues. Track the first jet: the induced
residue comparison is not obtained by blindly using the original constant gauge.
Prove compatibility with injective coefficient extension and scalar recentering.

**Done when:** the existing discriminant-invariance terminal is reached from
original regular comparison data, without assuming modified-residue conjugacy
or invariance of a block weight. Include discriminant-one/resonant cases with
no nonresonance hypothesis. This closes the main missing algebra behind F3/G6.

### L2 — universal residue reduction and seventeen exact certificates

Proposed `Quantum/UniversalRankTwoResidue.lean` and
`Applications/PicardRankOneFanoMatrices.lean`.
First formalize the displayed generic four-dimensional block reduction:
polynomial spectral projector, complementary block, normalized off-diagonal
Sylvester correction, its contribution to the first jet, and the modified
residue formula. Supply invertibility/nonzero hypotheses for every denominator.
Then define all seventeen rational matrices, their normalized gradings, and
unit cyclic bases. Prove characteristic polynomials and cyclic determinants;
use the proved reduction for all nine rank-two certificates, including the
four rational controls. Obtain 16/9, 1, 4/9 and 0 exactly. Separately verify
3+1 primary ranks for genera 2–5 and the remaining rational controls.

**Done when:** Lean computes each invariant from the matrix and connection
coefficients, rather than accepting a precomputed discriminant as a field of
an input record. Table exhaustion is a finite proof over seventeen constructors.
The connection's identification with each geometric quantum product remains a
separate source theorem, as do the classification, Hodge numbers, deformation
bridges and all-member rational controls. A cyclic matrix certificate alone
must not be reported as a proof of any of those geometric facts.

Use the two existing rational replays as independent expected-output evidence;
do not replace proof with `native_decide`, `eval`, or an execution axiom.

### L3 — whole super-primary factors and the new selectors

Proposed `Quantum/SuperPrimarySelectors.lean`.
Use an associative graded algebra over a characteristic-zero field, parity,
even unit, supercommutativity, and a nondegenerate Frobenius pairing. Prove that
an even Euler polynomial identity transfers from its action on the even part
to the whole algebra by evaluating at the unit. Construct primary idempotents
and their full even/odd ideals; prove orthogonality and pairing restriction.
For an even-rank-one factor, prove odd products vanish via `(ab)^2=0`, and
then that its odd part is zero. Obtain even odd-dimension from its alternating
nondegenerate pairing. Derive odd allocation for the 2+1+1 and 3+1 tables.
Reuse the existing rank-two persistence result and add the rank-three
cyclic-centralizer/trace-ideal argument from the transport audit: compressed
flatness preserves the ideal of centered characteristic coefficients, and
lowest-degree induction forces its initially zero generators to remain zero.
This preserves the repeated 3+1 endpoint block on the formal bulk germ.
Prove the finite-rank algebra and identify the required compression identities;
merely entering a 3+1 decomposition in the endpoint table is insufficient.

Define the exact-residue rank-two selector and the rank-three odd selector,
using **full even ranks**. Preserve all occurrence multiplicities. Supply an
exact-spectrum target (finitely supported integer counts, or its positive
submonoid) and its augmentation, rather than reusing the modulo-integer marker.
Use L1 to prove comparison invariance of the new weights; instantiate the
existing universal fold. Keep the full-even-base and Hodge-fixed-base numerical
versions separate until the Tate endpoint identification is supplied.

**Done when:** degree 2 and genus 6 are detected, genera 2–5 are detected without
rank-three residue theory, and neither a count nor a Hodge weight is defined
by taking invariant vectors in the fiber. This implements P1/G1/G3/G4/G5.

### L4 — faithful fixed-base maps and separated occurrences

Proposed `Quantum/HodgeFixedBaseTransport.lean` and
`Quantum/OccurrenceSpectralSeparation.lean`.
Develop the graded completed monoid algebra with curve/divisor characters,
negative-degree bulk coordinates and polynomial occurrence units used in
`fixed-base-proof.md`. Prove coefficient finiteness in bounded ample degree,
injectivity of independent polynomial translations, and independence of the
exponential divisor characters (Vandermonde in each finite coefficient layer).
Pass to the specified completion and localizations only with their actual
injectivity hypotheses. Prove restriction of an equivariant coordinate
isomorphism **and its inverse** to fixed loci. Prove nonzero resultants after
independent occurrence shifts and faithful scalar extension.

**Done when:** the concrete center maps, not arbitrary quotients of injections,
are proved faithful on the specified fixed bases. The current fixed-subalgebra
lemma is not sufficient. This is likely the largest coefficient-ring development;
a narrower finite-layer lemma should be labelled a fragment until the passage
to the actual completion is proved. F0/F2/H1 require explicit bookkeeping here.

The geometric identification of those rings with the QDM bases, and the actual
blowup/projective-bundle comparisons, remain imported. A uniqueness-implies-
equivariance lemma for normalized factorization is useful algebra, but its
application still needs the geometric action and the full-fiber input data.

### L5 — vanishing and main numerical classification A

Proposed `Applications/SurfaceSelectorVanishing.lean` and
`Applications/PicardRankOneFanoOneStabilization.lean`.
Formalize strict degree increase implying nilpotence; the rank bounds
`b2+2≥3`; the linear-algebra contradiction between a nonzero isotropic class
and a one-dimensional positive intersection form; and curve residue zero.
Compose the nef, ruled and point-blowup cases using the imported surface
classification and virtual-dimension/quantum-product statements. Prove this
vanishing before using ambient birational descent, avoiding circularity.

Instantiate the existing occurrence-indexed theorem in dimensions 3 and 4,
then the product doubling formula. Combine L2/L3 with classification exhaustion
and rational controls to obtain the all-seventeen rationality equivalence.
Keep the precise positive selector distinct from the seven numerical signatures:
these signatures do not recover all nine family labels.

**Done when:** nine positive cases and eight rational controls feed one terminal,
with no input consisting of the desired irrationality of those nine families.
Varieties, weak factorization, quantum comparisons and their geometric
identifications remain exposed imports; an abstract finite-table deduction is
not complete formalization of geometric A.

### L6 — Hodge-valued safe sum and conservation B

Proposed `Quantum/HodgePrimaryLedger.lean` and
`Applications/HodgeConservation.lean`.
Start with an actual finite-dimensional rational representation model (or an
explicit semisimple category), equivariant idempotents and their image objects.
Prove representation constancy under the allowed equivariant deformations,
base-extension compatibility, and invariance of the **unlabelled safe sum**
under permutations of splitting branches. Do not require rational descent of
each separately labelled scalar factor. Construct the weight in the additive
monoid of isomorphism classes and reuse the existing fold/descent theorem.

Prove cancellation of doubled objects via finite simple multiplicities in a
semisimple model; cancellation of a common summand alone does not prove
`V⊕V≅W⊕W ⇒ V≅W`. At Fano endpoints identify the selected object with the full
H³, and obtain B from the projective-line comparison. Polarizable rational
Hodge structures, their semisimplicity and the geometric projector realization
must be constructed or exposed as precisely scoped imports. A finite multiset
model alone is a fragment of the Hodge theorem.

**Done when:** the target is an isomorphism of rational Hodge objects, not just
an equality of dimensions; no integral lattice, polarization, or principally
polarized Jacobian isomorphism is silently inferred. This is H2/G8.

### L7 — exact downstream C and D

Proposed `Applications/GenericCancellation.lean` and
`Applications/ArithmeticPartnerFiniteness.lean`.
For C compose B with Voisin's exact premise: very-general source and arbitrary
smooth target in the same cubic or quartic family. Do not replace it with
all-source or special-pencil Torelli.
For D formalize the finiteness chain: bounded degree of geometric isogenies
from a fixed abelian variety gives a finite kernel set in one finite torsion
group; finite quotient types plus finitely many polarization orbits of the
specified degree give finite principally polarized types; cubic Torelli gives
finite geometric cubic classes. Prove the finite-image/fiber bookkeeping;
expose Achter, corrected Orr, fixed-degree polarization finiteness and Torelli
as distinct premises. Bound [L:K], not the field of definition of the isogeny.

**Done when:** the conclusion counts geometric isomorphism classes, allowing
all extensions of the prescribed degree, without counting twists or claiming
an effective numerical bound. C and D depend on B, not on each other.

### L8 — optional algebra after the core

- Corrected rank-three canonical lattice: prove the pairing trace constraints,
  gauge `I−z a E31`, lower-entry vanishing in the first comparison jet,
  preservation under `diag(1,z,z²)`, and the scalar evolution `∂f=αf` that
  forces the pole to vanish. Reuse formal logarithmic-vanishing machinery.
  Include the audited counterexample to uncorrected triangularity as an exact
  algebraic regression. This is independent of L5's rank-three **odd count**.
- Uniform odd-cubic residue: prove the projector/Sylvester formulas for every
  odd n≥3 and δ=(n−1)²/9, including the exceptional n=3 quantum relation.
  A list of small-n calculations is not the uniform theorem.
- Additive Grothendieck extension: use Bittner's supplied presentation, verify
  the blowup relation, and prove annihilation of the entire ideal (L−1) by
  checking its multiples on additive generators. Do not assume multiplicativity
  of the selector. Formalize the infinite independent coordinate section.
- Countability/coarse-moduli, potential reduction, motive separation, cone
  consequences and odd-excess filters can have separate downstream deduction
  terminals, retaining their precise imports. The sharpness/moduli pencil
  formulas and special-pencil isogeny theorem need owning-source version checks
  before being offered as established inputs. They are not the bundled six-axis
  or framed-monodromy companion merely because those also concern cubics.

## Dependency order and stopping points

1. **First implementation slice:** L1 and the generic part of L2. This gives a
   substantial exact-lattice result, removes the resonance obstruction to reuse,
   and can be reviewed without formalizing Hodge theory or the Fano classification.
2. **Main numerical slice:** finish L2; implement L3 and the needed L4 algebra;
   assemble L5 with its explicit geometric imports. A does not wait for B–D.
3. **Hodge slice:** complete L4 and L6, reusing L3/L5's operation/vanishing
   infrastructure. C and D follow as independent L7 applications.
4. **Optional slice:** L8 only for results retained after manuscript review.

The core needs rank-three cluster persistence in L3, but not the optional
rank-three residue construction. Rank-two persistence already exists; the
rank-three cyclic/trace argument still needs formalization. A fully general
arbitrary-rank theorem is optional if the two required ranks are proved.
Keep preservation of a repeated primary block distinct from construction and
functoriality of its rank-three logarithmic residue.

## Formal claim and verification contract

For every addition, write the mathematical statement before the theorem type.
Its record must distinguish proved algebra, supplied geometric constructions,
and imported theorems; no desired conclusion may be renamed as a premise.
The lane's ban on assumed substitutes for proofs means a conditional interface
cannot discharge the missing geometric assertion. It may report exactly its
proved deduction, with conditional or fragment status according to the actual
objects and conclusion. New algebraic lemmas can be complete at their own scope;
that does not promote the parent geometric claim to complete.

When integrating, update in one coherent change the manuscript's `\coverage`,
`\lean`, `\uses`, `\imports`, and any justified `\evidence` annotations;
`lean/verification/claims.json`; `verification/imported-sources.json` and
`verification/evidence.json`; the public Main interface; axiom-audit declarations
and `lean/verification/expected_axioms.txt`; claim/terminal digests; dependency
outputs; and both verification summaries. Computational support must not
silently become a proof premise. Existing claim labels whose scope changes
require revised descriptions, limitations and digests.

Use only the guarded Lean tooling under `lean/scripts/`, selecting the bundled
package explicitly with the supported absolute `--root`. For a module review,
`lean/scripts/guarded-lean --root /home/tavis/src/othello/papers/cubic-stabilization-m1/lean MODULE.lean`
is the wrapper route, not a manual Lean/Lake call. Follow the Lean guide's
build queue for dependencies. Capture a fresh guarded axiom audit after changes;
compare it through the package checker. No `sorry`, project axiom,
`native_decide`, or compiled-evaluation axiom is acceptable.

Source-only correspondence was checked for this planning checkpoint; no build
was needed. Implementation will additionally require the targeted guarded
kernel checks, axiom comparison, relevant deterministic evidence replay and
paper gates. Standalone synchronization remains a later authorized operation.

## Open boundary

The core algebra and conditional assemblies are implemented at the boundary above. The complete literature
audit remains unfinished, and no new priority or novelty conclusion follows
from this formal plan. Companion source verification and author hierarchy
review retain the order specified by the task card.
