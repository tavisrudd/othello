import RelativeConicArcs.ClebschTorsorRosettaData
import RelativeConicArcs.Gates.ClebschReplacementSpine
import RelativeConicArcs.Gates.ClebschArithmeticGluing
import RelativeConicArcs.Gates.ClebschWittHadamard
import Mathlib.LinearAlgebra.FiniteDimensional.Basic
import Mathlib.Tactic

/-!
# Orientation dictionaries for the Clebsch close

This module separates formal deduction from externally certified identification.

`FreeC2Torsor` presents a freely transitive involution.  The binary and golden
carriers are the actual root sets of `x²=2` in `F₇` and `x²-x-1` in `F₁₁`.
Certificates then express four mechanisms: an outer involution on a fixed-child
model, equality of nontrivial two-point actions through a common character,
equivariant q=11 design/Fourier/Hadamard readouts, and golden conjugation descending
to the split roots.

Lean proves the finite root calculations and every consequence of those certificate
interfaces.  The fixed-child indexing, concrete character actions, readout maps, and
characteristic-zero descent remain exact external inputs.  No absolute
Galois-cohomology classification, all-prime theorem, integral cubic lift, or
embedding into the degree-twelve design group is asserted.
-/

namespace RelativeConicArcs
namespace ClebschTorsorRosetta

/-- A free `C₂` torsor presented by a fixed-point-free, transitive involution. -/
structure FreeC2Torsor (X : Type*) [Fintype X] [DecidableEq X] where
  swap : Equiv.Perm X
  swap_involutive : ∀ x, swap (swap x) = x
  swap_fixedPointFree : ∀ x, swap x ≠ x
  swap_transitive : ∀ x y, y = x ∨ y = swap x
  card_eq_two : Fintype.card X = 2

/-- An equivariant equivalence of presented free `C₂` torsors. -/
structure TorsorEquiv {X Y : Type*} [Fintype X] [DecidableEq X]
    [Fintype Y] [DecidableEq Y] (source : FreeC2Torsor X)
    (target : FreeC2Torsor Y) where
  toEquiv : X ≃ Y
  map_swap : ∀ x, toEquiv (source.swap x) = target.swap (toEquiv x)

/-- The standard determinant-sign torsor. -/
def orientationTorsor : FreeC2Torsor Orientation where
  swap := orientationSwap
  swap_involutive := by decide
  swap_fixedPointFree := by decide
  swap_transitive := by decide
  card_eq_two := by decide

/-- The binary split-root carrier is a free two-point torsor under root negation. -/
def binaryRootTorsor : FreeC2Torsor BinaryRoot where
  swap := binaryRootSwap
  swap_involutive := by intro x; simp [binaryRootSwap]
  swap_fixedPointFree := by decide +revert
  swap_transitive := by decide +revert
  card_eq_two := Fintype.card_congr binaryRootToOrientation

/-- The golden split-root carrier is a free two-point torsor under golden conjugation. -/
def goldenRootTorsor : FreeC2Torsor GoldenRoot where
  swap := goldenRootSwap
  swap_involutive := by intro x; simp [goldenRootSwap]
  swap_fixedPointFree := by decide +revert
  swap_transitive := by decide +revert
  card_eq_two := Fintype.card_congr goldenRootToOrientation

/-- The binary root labelling is an equivariant torsor equivalence. -/
def binaryRootTorsorEquiv : TorsorEquiv binaryRootTorsor orientationTorsor where
  toEquiv := binaryRootToOrientation
  map_swap := by decide +revert

/-- The golden root labelling is an equivariant torsor equivalence. -/
def goldenRootTorsorEquiv : TorsorEquiv goldenRootTorsor orientationTorsor where
  toEquiv := goldenRootToOrientation
  map_swap := by decide +revert

/-- The split-root carriers contain exactly `3,4` at seven and `8,4` at eleven. -/
theorem splitRoot_values :
    (Finset.univ.image fun x : BinaryRoot => x.1) = {3, 4} ∧
    (Finset.univ.image fun x : GoldenRoot => x.1) = {8, 4} := by
  decide

/-- A free two-point torsor has no invariant point. -/
theorem no_invariant_point {X : Type*} [Fintype X] [DecidableEq X]
    (torsor : FreeC2Torsor X) : ¬ ∃ x, torsor.swap x = x := by
  rintro ⟨x, hx⟩
  exact torsor.swap_fixedPointFree x hx

/-- One orientation bit suffices: relative to a chosen point, every target is that
point or its swapped partner. -/
theorem point_or_swapped_point {X : Type*} [Fintype X] [DecidableEq X]
    (torsor : FreeC2Torsor X) (x y : X) : y = x ∨ y = torsor.swap x :=
  torsor.swap_transitive x y

/-- External fixed-child evidence: an actual parent carrier is indexed by the
22-parent model, and its geometric outer operation is the paired-parent involution. -/
structure FixedChildCertificate (Parent : Type*) [Fintype Parent] [DecidableEq Parent] where
  parentIndex : Parent ≃ FixedChildParentIndex
  outer : Equiv.Perm Parent
  outer_index : ∀ p, parentIndex (outer p) = pairedParentSwap (parentIndex p)

/-- The two-valued fixed-child quotient induced by a certified parent indexing. -/
def fixedChildQuotient {Parent : Type*} [Fintype Parent] [DecidableEq Parent]
    (certificate : FixedChildCertificate Parent) (p : Parent) : Orientation :=
  fixedChildSheet (certificate.parentIndex p)

/-- The fibre over one quotient value is transported exactly to the corresponding
eleven-index fibre of the finite fixed-child model. -/
def fixedChildFiberEquiv {Parent : Type*} [Fintype Parent] [DecidableEq Parent]
    (certificate : FixedChildCertificate Parent) (s : Orientation) :
    {p : Parent // fixedChildQuotient certificate p = s} ≃
      {i : FixedChildParentIndex // fixedChildSheet i = s} where
  toFun p := ⟨certificate.parentIndex p.1, p.2⟩
  invFun i := ⟨certificate.parentIndex.symm i.1, by
    simpa [fixedChildQuotient] using i.2⟩
  left_inv := by intro p; ext; simp
  right_inv := by intro i; ext; simp

/-- The finite paired-parent operation exchanges the two eleven-element quotient fibres. -/
theorem pairedParentSwap_exchanges_sheets (i : FixedChildParentIndex) :
    fixedChildSheet (pairedParentSwap i) = orientationSwap (fixedChildSheet i) := by
  fin_cases i <;> decide

/-- The fixed-child quotient has 22 indexed parents, both quotient values occur, and
the certified outer operation induces the nontrivial orientation swap. -/
theorem fixedChildQuotient_is_t11 {Parent : Type*} [Fintype Parent] [DecidableEq Parent]
    (certificate : FixedChildCertificate Parent) :
    Fintype.card Parent = 22 ∧
    (∀ s, Fintype.card {p : Parent // fixedChildQuotient certificate p = s} = 11) ∧
    Function.Surjective (fixedChildQuotient certificate) ∧
    ∀ p, fixedChildQuotient certificate (certificate.outer p) =
      orientationSwap (fixedChildQuotient certificate p) := by
  refine ⟨Fintype.card_congr certificate.parentIndex, ?_, ?_, ?_⟩
  · intro s
    calc
      Fintype.card {p : Parent // fixedChildQuotient certificate p = s} =
          Fintype.card {i : FixedChildParentIndex // fixedChildSheet i = s} :=
        Fintype.card_congr (fixedChildFiberEquiv certificate s)
      _ = 11 := by fin_cases s <;> decide
  · intro s
    fin_cases s
    · exact ⟨certificate.parentIndex.symm 0, by
        simp [fixedChildQuotient, fixedChildSheet]⟩
    · exact ⟨certificate.parentIndex.symm 11, by
        simp [fixedChildQuotient, fixedChildSheet]⟩
  · intro p
    simp only [fixedChildQuotient, certificate.outer_index]
    exact pairedParentSwap_exchanges_sheets (certificate.parentIndex p)

/-- External character evidence for the determinant sign, Čech obstruction, and
selector readout.  The subgroup field is the exact common kernel; its classical name
is supplied separately rather than inferred from its cardinality. -/
structure SignCharacterCertificate (G : Type*) [Group G] where
  inner : Subgroup G
  determinantSign : G →* Equiv.Perm Orientation
  cechReadout : G →* Equiv.Perm Orientation
  selectorReadout : G →* Equiv.Perm Orientation
  determinant_kernel : determinantSign.ker = inner
  cech_kernel : cechReadout.ker = inner
  selector_kernel : selectorReadout.ker = inner

/-- The three certified actions are one sign character and have the supplied common kernel. -/
theorem one_sign_character_three_readouts {G : Type*} [Group G]
    (certificate : SignCharacterCertificate G) :
    certificate.cechReadout = certificate.determinantSign ∧
    certificate.selectorReadout = certificate.determinantSign ∧
    certificate.determinantSign.ker = certificate.inner := by
  have hcech : certificate.cechReadout.ker = certificate.determinantSign.ker :=
    certificate.cech_kernel.trans certificate.determinant_kernel.symm
  have hselector : certificate.selectorReadout.ker = certificate.determinantSign.ker :=
    certificate.selector_kernel.trans certificate.determinant_kernel.symm
  exact ⟨ClebschArithmeticGluing.sheetCharacter_eq_of_kernel_eq
      certificate.cechReadout certificate.determinantSign hcech,
    ClebschArithmeticGluing.sheetCharacter_eq_of_kernel_eq
      certificate.selectorReadout certificate.determinantSign hselector,
    certificate.determinant_kernel⟩

/-- The bounded rank-three orientation models: the characteristic-five polynomial has
no rational root and its geometric pair is one Frobenius orbit, whereas the roots at
seven and eleven are explicit free torsors equivariantly identified with orientation. -/
theorem rankThree_split_inert_orientation :
    (¬ ∃ x : ZMod 5, x * x = 2) ∧
    inertClosedOrbits.card = 1 ∧
    (∀ x : InertGeometricLabel, inertFrobenius x ≠ x) ∧
    Nonempty (TorsorEquiv binaryRootTorsor orientationTorsor) ∧
    Nonempty (TorsorEquiv goldenRootTorsor orientationTorsor) := by
  exact ⟨ClebschArithmeticGluing.a3_two_has_no_root, by decide, by decide,
    ⟨binaryRootTorsorEquiv⟩, ⟨goldenRootTorsorEquiv⟩⟩

/-- External q=11 evidence connecting the actual design, Fourier, and Hadamard
readout carriers to the determinant-sign torsor.  In the Hadamard field,
`hadamardSwap` is specifically the row/column operation certified by the finite
degree-twelve replay, not an arbitrary involution. -/
structure Q11OuterReadoutCertificate
    (Design Fourier Hadamard : Type*) where
  designSwap : Equiv.Perm Design
  fourierSwap : Equiv.Perm Fourier
  hadamardSwap : Equiv.Perm Hadamard
  designToSign : Design ≃ Orientation
  fourierToSign : Fourier ≃ Orientation
  hadamardToSign : Hadamard ≃ Orientation
  design_equivariant : ∀ x, designToSign (designSwap x) =
    orientationSwap (designToSign x)
  fourier_equivariant : ∀ x, fourierToSign (fourierSwap x) =
    orientationSwap (fourierToSign x)
  hadamard_equivariant : ∀ x, hadamardToSign (hadamardSwap x) =
    orientationSwap (hadamardToSign x)

/-- The three certified q=11 readouts induce the same determinant-sign swap. -/
theorem q11_outer_readouts_agree
    {Design Fourier Hadamard : Type*}
    (certificate : Q11OuterReadoutCertificate Design Fourier Hadamard) :
    (∀ x, certificate.designToSign (certificate.designSwap x) =
      orientationSwap (certificate.designToSign x)) ∧
    (∀ x, certificate.fourierToSign (certificate.fourierSwap x) =
      orientationSwap (certificate.fourierToSign x)) ∧
    (∀ x, certificate.hadamardToSign (certificate.hadamardSwap x) =
      orientationSwap (certificate.hadamardToSign x)) :=
  ⟨certificate.design_equivariant, certificate.fourier_equivariant,
    certificate.hadamard_equivariant⟩

/-- Exact finite forced-outer boundary: the row/column assignment has the full
finite graph certificate and no inner conjugating witness in the checked closure. -/
theorem q11_hadamard_hinge_is_forced_outer :
    ClebschWittHadamard.rowColumnAssignmentChecks ∧
      ClebschWittHadamard.rowColumnNonInnerCheck :=
  ⟨ClebschWittHadamard.row_column_assignment_finite_graph_certificate,
    ClebschWittHadamard.row_column_hinge_has_no_inner_witness⟩

/-- External characteristic-zero evidence.  The field is generated over `ℚ` by a
root `φ` of `φ²-φ-1`, has degree two, carries the conjugation `φ ↦ 1-φ`, and its
two reductions at eleven are explicitly identified with the actual golden roots. -/
structure GoldenCharacteristicZeroCertificate
    (K : Type*) [Field K] [Algebra ℚ K] [FiniteDimensional ℚ K] where
  phi : K
  phi_polynomial : phi * phi - phi - 1 = 0
  adjoin_phi : Algebra.adjoin ℚ ({phi} : Set K) = ⊤
  degree_two : Module.finrank ℚ K = 2
  conjugation : K ≃ₐ[ℚ] K
  conjugation_phi : conjugation phi = 1 - phi
  reductions : Orientation ≃ GoldenRoot
  reductions_equivariant : ∀ s,
    reductions (orientationSwap s) = goldenRootSwap (reductions s)

/-- The certified characteristic-zero golden conjugation reduces to the two roots
`8,4` at eleven and to their nontrivial finite swap. -/
theorem golden_characteristic_zero_reduction_dictionary
    {K : Type*} [Field K] [Algebra ℚ K] [FiniteDimensional ℚ K]
    (certificate : GoldenCharacteristicZeroCertificate K) :
    certificate.phi * certificate.phi - certificate.phi - 1 = 0 ∧
    Algebra.adjoin ℚ ({certificate.phi} : Set K) = ⊤ ∧
    Module.finrank ℚ K = 2 ∧
    certificate.conjugation certificate.phi = 1 - certificate.phi ∧
    (∀ s, certificate.reductions (orientationSwap s) =
      goldenRootSwap (certificate.reductions s)) :=
  ⟨certificate.phi_polynomial, certificate.adjoin_phi, certificate.degree_two,
    certificate.conjugation_phi, certificate.reductions_equivariant⟩

/-- Paper-facing assembly from the four exact semantic certificates and the finite
rank-three/row-column terminals.  Every semantic bridge appears as an explicit input
to the theorem rather than being manufactured by retagging a two-element carrier. -/
theorem torsor_rosetta_closing_theorem
    {Parent G Design Fourier Hadamard K : Type*}
    [Fintype Parent] [DecidableEq Parent] [Group G]
    [Field K] [Algebra ℚ K] [FiniteDimensional ℚ K]
    (fixedChild : FixedChildCertificate Parent)
    (characters : SignCharacterCertificate G)
    (outerReadouts : Q11OuterReadoutCertificate Design Fourier Hadamard)
    (golden : GoldenCharacteristicZeroCertificate K) :
    (Fintype.card Parent = 22 ∧
      (∀ s, Fintype.card {p : Parent // fixedChildQuotient fixedChild p = s} = 11) ∧
      Function.Surjective (fixedChildQuotient fixedChild) ∧
      ∀ p, fixedChildQuotient fixedChild (fixedChild.outer p) =
        orientationSwap (fixedChildQuotient fixedChild p)) ∧
    (characters.cechReadout = characters.determinantSign ∧
      characters.selectorReadout = characters.determinantSign ∧
      characters.determinantSign.ker = characters.inner) ∧
    ((¬ ∃ x : ZMod 5, x * x = 2) ∧
      inertClosedOrbits.card = 1 ∧
      (∀ x : InertGeometricLabel, inertFrobenius x ≠ x) ∧
      Nonempty (TorsorEquiv binaryRootTorsor orientationTorsor) ∧
      Nonempty (TorsorEquiv goldenRootTorsor orientationTorsor)) ∧
    ((∀ x, outerReadouts.designToSign (outerReadouts.designSwap x) =
        orientationSwap (outerReadouts.designToSign x)) ∧
      (∀ x, outerReadouts.fourierToSign (outerReadouts.fourierSwap x) =
        orientationSwap (outerReadouts.fourierToSign x)) ∧
      (∀ x, outerReadouts.hadamardToSign (outerReadouts.hadamardSwap x) =
        orientationSwap (outerReadouts.hadamardToSign x))) ∧
    (ClebschWittHadamard.rowColumnAssignmentChecks ∧
      ClebschWittHadamard.rowColumnNonInnerCheck) ∧
    (golden.phi * golden.phi - golden.phi - 1 = 0 ∧
      Algebra.adjoin ℚ ({golden.phi} : Set K) = ⊤ ∧
      Module.finrank ℚ K = 2 ∧
      golden.conjugation golden.phi = 1 - golden.phi ∧
      ∀ s, golden.reductions (orientationSwap s) =
        goldenRootSwap (golden.reductions s)) := by
  exact ⟨fixedChildQuotient_is_t11 fixedChild,
    one_sign_character_three_readouts characters,
    rankThree_split_inert_orientation,
    q11_outer_readouts_agree outerReadouts,
    q11_hadamard_hinge_is_forced_outer,
    golden_characteristic_zero_reduction_dictionary golden⟩

end ClebschTorsorRosetta
end RelativeConicArcs
