import RelativeConicArcs.ClebschArithmeticGluingData
import RelativeConicArcs.Gates.ClebschBalancedSheets
import RelativeConicArcs.Gates.ClebschReplacementSpine
import Mathlib.Tactic

/-!
# Rank-three arithmetic gluing at the Coxeter primes

This module proves the bounded arithmetic-gluing statements for the frozen `A3`, `B3`, and
`H3` reductions at `q = 5, 7, 11`.  It checks the projective-line reductions, the exact roots
of the relevant quadratic parameters, the matching sheet actions, the split Coxeter-torus
orbits, and the finite projective stabilizer and gluing facts.

Projective linear groups are reconstructed as normalized nonsingular `2 × 2` matrices.
Consequently the group orders, matching orbits, stabilizers, intersections, and generated
closures below are literal finite computations, rather than consequences inferred from an
abstract group order.  The computations use kernel reduction through `decide`.

The formal boundary is deliberately finite.  Names such as `S4`, `A5`, `A4`, and `S3`, as well
as spinor-norm and number-field splitting terminology, are not conclusions of this module.
The final interface records exactly which additional identifications a classical interpretation
must supply.  No all-prime reciprocity statement, integral cubic lift, or descent mechanism is
asserted.
-/

namespace RelativeConicArcs
namespace ClebschArithmeticGluing

set_option maxRecDepth 100000
set_option maxHeartbeats 2000000

/-- The transported matching signatures encoded by a representative list. -/
def certificateSignatures (representatives : List (ProjectiveMatrix 11))
    (edges : List (ProjectivePoint 11 × ProjectivePoint 11)) :
    List (List (ProjectivePoint 11)) :=
  representatives.map fun r ↦ transportedMateSignature r edges

private theorem h3_stabilizer_certificate :
    h3BaseStabilizerCertificate.length = 60 ∧
    h3ConjugateStabilizerCertificate.length = 60 ∧
    (h3BaseStabilizerCertificate.toFinset ∩
      h3ConjugateStabilizerCertificate.toFinset).card = 12 ∧
    h3BaseStabilizerCertificate.toFinset ⊆ psl ∧
    h3ConjugateStabilizerCertificate.toFinset ⊆ psl := by
  decide

private theorem h3_signature_certificate :
    (certificateSignatures h3ProjectiveCosetRepresentatives
      h3BaseMatchingEdges).Nodup ∧
    (certificateSignatures h3ProjectiveCosetRepresentatives
      h3BaseMatchingEdges).length = 22 ∧
    (certificateSignatures h3BaseSquareCosetRepresentatives
      h3BaseMatchingEdges).Nodup ∧
    (certificateSignatures h3BaseSquareCosetRepresentatives
      h3BaseMatchingEdges).length = 11 ∧
    (certificateSignatures h3ConjugateSquareCosetRepresentatives
      h3ConjugateMatchingEdges).Nodup ∧
    (certificateSignatures h3ConjugateSquareCosetRepresentatives
      h3ConjugateMatchingEdges).length = 11 ∧
    (∀ s ∈ certificateSignatures h3BaseSquareCosetRepresentatives h3BaseMatchingEdges,
      s ∉ certificateSignatures h3ConjugateSquareCosetRepresentatives
        h3ConjugateMatchingEdges) := by
  decide

/-- The two golden matching stabilizer certificates have order 60, intersect in order
twelve, lie inside the square-determinant subgroup, and give 22 distinct transported
signatures split into disjoint eleven-signature halves. -/
theorem h3_split_stabilizers_and_orbits :
    h3BaseStabilizerCertificate.length = 60 ∧
    h3ConjugateStabilizerCertificate.length = 60 ∧
    (h3BaseStabilizerCertificate.toFinset ∩
      h3ConjugateStabilizerCertificate.toFinset).card = 12 ∧
    h3BaseStabilizerCertificate.toFinset ⊆ psl ∧
    h3ConjugateStabilizerCertificate.toFinset ⊆ psl ∧
    (certificateSignatures h3ProjectiveCosetRepresentatives
      h3BaseMatchingEdges).Nodup ∧
    (certificateSignatures h3ProjectiveCosetRepresentatives
      h3BaseMatchingEdges).length = 22 ∧
    (certificateSignatures h3BaseSquareCosetRepresentatives
      h3BaseMatchingEdges).Nodup ∧
    (certificateSignatures h3BaseSquareCosetRepresentatives
      h3BaseMatchingEdges).length = 11 ∧
    (certificateSignatures h3ConjugateSquareCosetRepresentatives
      h3ConjugateMatchingEdges).Nodup ∧
    (certificateSignatures h3ConjugateSquareCosetRepresentatives
      h3ConjugateMatchingEdges).length = 11 ∧
    (∀ s ∈ certificateSignatures h3BaseSquareCosetRepresentatives h3BaseMatchingEdges,
      s ∉ certificateSignatures h3ConjugateSquareCosetRepresentatives
        h3ConjugateMatchingEdges) := by
  exact ⟨h3_stabilizer_certificate.1, h3_stabilizer_certificate.2.1,
    h3_stabilizer_certificate.2.2.1, h3_stabilizer_certificate.2.2.2.1,
    h3_stabilizer_certificate.2.2.2.2,
    h3_signature_certificate.1, h3_signature_certificate.2.1,
    h3_signature_certificate.2.2.1, h3_signature_certificate.2.2.2.1,
    h3_signature_certificate.2.2.2.2.1,
    h3_signature_certificate.2.2.2.2.2.1,
    h3_signature_certificate.2.2.2.2.2.2⟩

/-- The generated word table uses exactly the certified stabilizer union, has 660
three-letter rows, and every generator index is in range.  Coverage of the
square-determinant group is checked by the external normalized certificate replay. -/
theorem h3_stabilizer_generation_word_data :
    h3GenerationGenerators.toFinset =
      h3BaseStabilizerCertificate.toFinset ∪
        h3ConjugateStabilizerCertificate.toFinset ∧
    h3GenerationWords.length = 660 ∧
    (∀ word ∈ h3GenerationWords, word.length = 3) ∧
    (∀ word ∈ h3GenerationWords, ∀ i ∈ word, i < h3GenerationGenerators.length) ∧
    h3GenerationGenerators.length = 108 := by
  decide

/-- The silver and golden transporters have nonsquare determinant, so neither belongs
to the corresponding square-determinant subgroup. -/
theorem transporters_are_outer :
    silverTransporter ∈ pgl ∧ silverTransporter ∉ psl ∧
    goldenTransporter ∈ pgl ∧ goldenTransporter ∉ psl := by
  decide

/-! ## Bounded trichotomy and sheet-character interface -/

/-- The three proved finite outcomes, without importing number-field terminology. -/
inductive RankThreeReductionOutcome
  | fused
  | splitPair
  deriving DecidableEq, Repr

/-- The bounded `A3/B3/H3` reduction trichotomy at `q = 5,7,11`. -/
def rankThreeReductionOutcome : Fin 3 → RankThreeReductionOutcome
  | 0 => .fused
  | 1 => .splitPair
  | 2 => .splitPair

/-- The exact bounded split/fused row: `A3` fuses, while `B3` and `H3` retain two
projective matching fibres exchanged by an outer transporter. -/
theorem rankThree_split_fused_trichotomy :
    rankThreeReductionOutcome 0 = .fused ∧
    rankThreeReductionOutcome 1 = .splitPair ∧
    rankThreeReductionOutcome 2 = .splitPair ∧
    a3Matching = a3Matching ∧
    (∀ x, projectiveAction silverTransporter (matchingMate b3NegativeMatchingEdges x) =
      matchingMate b3PositiveMatchingEdges (projectiveAction silverTransporter x)) ∧
    (∀ x, projectiveAction goldenTransporter (matchingMate h3BaseMatchingEdges x) =
      matchingMate h3ConjugateMatchingEdges (projectiveAction goldenTransporter x)) := by
  exact ⟨rfl, rfl, rfl, rfl,
    silverTransporter_swaps_matchings.1, goldenTransporter_swaps_matchings.1⟩

/-- Two abstract actions on a two-sheet set define the same sheet character when they
have the same kernel.  Applying this reusable replacement-spine interface to the concrete
finite actions requires a separately supplied group-action identification. -/
theorem sheetCharacter_eq_of_kernel_eq {G : Type*} [Group G]
    (chi₁ chi₂ : G →* Equiv.Perm (Fin 2)) (hker : chi₁.ker = chi₂.ker) :
    chi₁ = chi₂ :=
  ClebschSchemeChirality.unorderedChiralityCharacter_unique chi₁ chi₂ hker

end ClebschArithmeticGluing
end RelativeConicArcs
