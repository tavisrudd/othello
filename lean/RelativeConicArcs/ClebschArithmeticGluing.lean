import RelativeConicArcs.ClebschArithmeticGluingData
import RelativeConicArcs.Gates.ClebschBalancedSheets
import RelativeConicArcs.ClebschSchemeChirality
import Mathlib.Tactic

/-!
# Rank-three arithmetic gluing at the Coxeter primes

This module proves the bounded arithmetic-gluing statements for the frozen `A3`, `B3`, and
`H3` reductions at `q = 5, 7, 11`.  It checks the projective-line reductions, the exact roots
of the relevant quadratic parameters, the matching sheet actions, the split Coxeter-torus
orbits, and the finite projective stabilizer and gluing facts.

Projective linear groups are reconstructed as normalized nonsingular `2 × 2` matrices.
Consequently the small-field group orders, matching orbits, and stabilizers below are literal
finite computations, rather than consequences inferred from an abstract group order.  For the
larger characteristic-eleven data, this module kernel-checks the literal table invariants stated
below; semantic stabilizer, coset, and word-replay completeness remains the responsibility of the
tracked certificate generator and its independent replay.

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

/-- Literal checks on the two golden certificate tables: their sizes and intersection,
square-determinant membership, and the distinct transported signatures supplied by the
representative tables.  This theorem deliberately does not call the tables complete stabilizers
or coset transversals. -/
theorem h3_certificate_literal_checks :
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

/-! ## Bounded trichotomy and sheet-character interfaces -/

/-- The exact bounded split/fused row: `A3` fuses, while `B3` and `H3` retain two
projective matching fibres exchanged by an outer transporter. -/
theorem rankThree_split_fused_trichotomy :
    (¬ ∃ x : ZMod 5, x * x = 2) ∧
    matchingFromReduction (a3VertexReductions 0) a3AntipodalIndexPairs = a3Matching ∧
    matchingFromReduction (a3VertexReductions 1) a3AntipodalIndexPairs = a3Matching ∧
    (Finset.univ.filter fun x : ZMod 7 ↦ x * x = 2) = {3, 4} ∧
    matchingFromReduction (b3VertexReductions 0) b3AntipodalIndexPairs =
      b3NegativeMatching ∧
    matchingFromReduction (b3VertexReductions 1) b3AntipodalIndexPairs =
      b3PositiveMatching ∧
    b3NegativeMatching ≠ b3PositiveMatching ∧
    (∀ x, projectiveAction silverTransporter (matchingMate b3NegativeMatchingEdges x) =
      matchingMate b3PositiveMatchingEdges (projectiveAction silverTransporter x)) ∧
    (Finset.univ.filter fun x : ZMod 11 ↦ x * x - x - 1 = 0) = {8, 4} ∧
    h3BaseMatching ≠ h3ConjugateMatching ∧
    (∀ x, projectiveAction goldenTransporter (matchingMate h3BaseMatchingEdges x) =
      matchingMate h3ConjugateMatchingEdges (projectiveAction goldenTransporter x)) ∧
    silverTransporter ∉ psl ∧ goldenTransporter ∉ psl := by
  exact ⟨a3_two_has_no_root, a3_matching_is_fused.1, a3_matching_is_fused.2,
    b3_two_roots, b3_reductions_induce_split_matchings.1,
    b3_reductions_induce_split_matchings.2.1,
    b3_reductions_induce_split_matchings.2.2,
    silverTransporter_swaps_matchings.1, h3_golden_roots, by decide,
    goldenTransporter_swaps_matchings.1, transporters_are_outer.2.1,
    transporters_are_outer.2.2.2⟩

/-- Re-export the balanced-sheet relative-invariant stabilizer theorem used by subsequent
concrete identifications.  This bounded arithmetic module supplies no such identification. -/
theorem stabilizer_eq_character_kernel {G W K : Type*} [Group G] [Field K]
    [AddCommGroup W] [Module K W]
    (action : G → W →ₗ[K] W) (haction : ∀ g h, action (g * h) = (action g).comp (action h))
    (hone : action 1 = LinearEquiv.refl K W) (chi : G →* Kˣ) (mu : W) (hmu : mu ≠ 0)
    (htwo : (2 : K) ≠ 0) (hrelative : ∀ g, action g mu = chi g • mu)
    (hpm : ∀ g, chi g = 1 ∨ chi g = -1) :
    {g | action g mu = mu} = ↑(MonoidHom.ker chi) :=
  ClebschBalancedSheets.stabilizer_eq_ker_of_relative_invariant
    action haction hone chi mu hmu htwo hrelative hpm

/-- Two abstract actions on a two-sheet set define the same sheet character when they
have the same kernel.  Applying this reusable equal-kernel interface to the concrete finite
actions requires a separately supplied group-action identification. -/
theorem sheetCharacter_eq_of_kernel_eq {G : Type*} [Group G]
    (chi₁ chi₂ : G →* Equiv.Perm (Fin 2)) (hker : chi₁.ker = chi₂.ker) :
    chi₁ = chi₂ :=
  ClebschSchemeChirality.unorderedChiralityCharacter_unique chi₁ chi₂ hker

end ClebschArithmeticGluing
end RelativeConicArcs
