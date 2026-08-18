import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.RankTwoResidueRigidity
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.SeparatedSpectralPairing

/-!
# Order-by-order equations for a horizontal sesquilinear pairing

An `F`-bundle in the loop coordinate `u` carries a connection whose matrix has a
simple pole,

  `A(u) = u⁻¹ * residue + regular 0 + u * regular 1 + u ^ 2 * regular 2 + ⋯`,

and the pairing used in the atomic argument is the `u`-sesquilinear form
`ψ(s,t) = (s(u), t(-u))`, whose matrix is a formal power series
`P(u) = pairing 0 + u * pairing 1 + ⋯`.  Horizontality of `ψ` in the loop
direction is the formal identity

  `u ∂_u P(u) + A(u)ᵀ * P(u) + P(u) * A(-u) = 0`,

and in a base direction `δ` it is `δ P(u) + B(u)ᵀ * P(u) + P(u) * B(-u) = 0` for
the connection matrix `B` in that direction.  Substituting `-u` in the right
factor makes the residue enter there with the opposite sign and multiplies the
regular coefficient of order `m` by `(-1) ^ m`.

This module represents such an identity coefficientwise.  Two factors are
allowed to differ, so that the same coefficients describe both the pairing of a
factor with itself and the off-diagonal pairing between two factors of a local
splitting: `leftResidue` and `leftRegular` are the connection data of the left
factor, `rightResidue` and `rightRegular` those of the right factor, `pairing`
is the coefficient family of the pairing between them, and `derivative` is the
coefficientwise image of the pairing under the derivation of the chosen
direction — `order • pairing order` for `u ∂_u`, and `δ (pairing order)` for a
base direction.  The coefficient at index `0` is the coefficient of `u⁻¹`, and
the coefficient at index `order + 1` is the coefficient of `u ^ order`.

Three consequences are proved.  Vanishing of the `u⁻¹` coefficient says exactly
that the residue is self-adjoint for the leading pairing coefficient, and
vanishing of the constant coefficient is the four-term relation between the
regular connection coefficient, the first two pairing coefficients, and the
residue.  Together with the rank-two rigidity algebra they give, for an even
rank-two factor with square-zero residue, that the regular coefficient carries
the nilpotent line into itself.  Separately, each coefficient equation is a
Sylvester equation for one pairing coefficient with a remainder built from
strictly earlier coefficients, so for two factors whose residues have distinct
scalar parts and nilpotent remainders the whole off-diagonal pairing vanishes.
Finally, a pairing that is constant in a frame where the connection has a
self-adjoint residue and an anti-self-adjoint regular part is horizontal; this
is the matrix substitution behind horizontality of the Poincare pairing for the
quantum connection, where the residue is a quantum multiplication operator,
self-adjoint by the Frobenius property, and the regular part is the grading
operator, anti-self-adjoint because Poincare duality pairs complementary
degrees.

Lean constructs no `F`-bundle, connection, quantum product, or Poincare
pairing, and proves neither the Frobenius property nor the degree-pairing
property; the corresponding self-adjointness and anti-self-adjointness
statements are hypotheses about matrices.  The coefficient families are
arbitrary; no convergence, no analytic structure, and no relation to
cohomological degrees is represented.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open Matrix

variable {R : Type*} [CommRing R] {leftRank rightRank : ℕ}

/-- The coefficient of `u ^ (index - 1)` in the horizontality expression
`D P(u) + A(u)ᵀ * P(u) + P(u) * A(-u)` for a connection with a simple pole, a
direction whose derivation acts on the pairing coefficients by `derivative`, and
possibly different connection data on the two sides of the pairing.  At index
`0` this is the coefficient of `u⁻¹`, where only the two residue terms
contribute; at index `order + 1` it is the coefficient of `u ^ order`. -/
def pairingHorizontalityCoefficient
    (leftResidue : Matrix (Fin leftRank) (Fin leftRank) R)
    (leftRegular : ℕ → Matrix (Fin leftRank) (Fin leftRank) R)
    (rightResidue : Matrix (Fin rightRank) (Fin rightRank) R)
    (rightRegular : ℕ → Matrix (Fin rightRank) (Fin rightRank) R)
    (pairing derivative : ℕ → Matrix (Fin leftRank) (Fin rightRank) R) :
    ℕ → Matrix (Fin leftRank) (Fin rightRank) R
  | 0 => leftResidueᵀ * pairing 0 - pairing 0 * rightResidue
  | order + 1 =>
      derivative order
        + (leftResidueᵀ * pairing (order + 1) - pairing (order + 1) * rightResidue)
        + ∑ index ∈ Finset.range (order + 1),
            ((leftRegular index)ᵀ * pairing (order - index)
              + (-1 : R) ^ (order - index) •
                  (pairing index * rightRegular (order - index)))

/-- The horizontality coefficients of the loop direction `u ∂_u`, whose
derivation multiplies the coefficient of `u ^ order` by `order`. -/
def loopPairingHorizontalityCoefficient
    (leftResidue : Matrix (Fin leftRank) (Fin leftRank) R)
    (leftRegular : ℕ → Matrix (Fin leftRank) (Fin leftRank) R)
    (rightResidue : Matrix (Fin rightRank) (Fin rightRank) R)
    (rightRegular : ℕ → Matrix (Fin rightRank) (Fin rightRank) R)
    (pairing : ℕ → Matrix (Fin leftRank) (Fin rightRank) R) :
    ℕ → Matrix (Fin leftRank) (Fin rightRank) R :=
  pairingHorizontalityCoefficient leftResidue leftRegular rightResidue rightRegular
    pairing fun order => (order : R) • pairing order

section Coefficients

variable {leftResidue : Matrix (Fin leftRank) (Fin leftRank) R}
  {leftRegular : ℕ → Matrix (Fin leftRank) (Fin leftRank) R}
  {rightResidue : Matrix (Fin rightRank) (Fin rightRank) R}
  {rightRegular : ℕ → Matrix (Fin rightRank) (Fin rightRank) R}
  {pairing derivative : ℕ → Matrix (Fin leftRank) (Fin rightRank) R}

/-- The `u⁻¹` coefficient of horizontality, written out. -/
theorem pairingHorizontalityCoefficient_zero :
    pairingHorizontalityCoefficient leftResidue leftRegular rightResidue rightRegular
        pairing derivative 0 =
      leftResidueᵀ * pairing 0 - pairing 0 * rightResidue := rfl

/-- The `u ^ order` coefficient of horizontality, written out. -/
theorem pairingHorizontalityCoefficient_succ (order : ℕ) :
    pairingHorizontalityCoefficient leftResidue leftRegular rightResidue rightRegular
        pairing derivative (order + 1) =
      derivative order
        + (leftResidueᵀ * pairing (order + 1) - pairing (order + 1) * rightResidue)
        + ∑ index ∈ Finset.range (order + 1),
            ((leftRegular index)ᵀ * pairing (order - index)
              + (-1 : R) ^ (order - index) •
                  (pairing index * rightRegular (order - index))) := rfl

/-- The `u⁻¹` coefficient of loop horizontality, written out. -/
theorem loopPairingHorizontalityCoefficient_zero :
    loopPairingHorizontalityCoefficient leftResidue leftRegular rightResidue rightRegular
        pairing 0 =
      leftResidueᵀ * pairing 0 - pairing 0 * rightResidue := rfl

/-- The `u ^ order` coefficient of loop horizontality, written out. -/
theorem loopPairingHorizontalityCoefficient_succ (order : ℕ) :
    loopPairingHorizontalityCoefficient leftResidue leftRegular rightResidue rightRegular
        pairing (order + 1) =
      (order : R) • pairing order
        + (leftResidueᵀ * pairing (order + 1) - pairing (order + 1) * rightResidue)
        + ∑ index ∈ Finset.range (order + 1),
            ((leftRegular index)ᵀ * pairing (order - index)
              + (-1 : R) ^ (order - index) •
                  (pairing index * rightRegular (order - index))) := rfl

/-- Vanishing of the `u⁻¹` coefficient of horizontality says exactly that the
residue is self-adjoint for the leading pairing coefficient. -/
theorem leadingResidue_selfAdjoint_of_horizontality
    (leading : pairingHorizontalityCoefficient leftResidue leftRegular rightResidue
      rightRegular pairing derivative 0 = 0) :
    leftResidueᵀ * pairing 0 = pairing 0 * rightResidue :=
  sub_eq_zero.mp (by rwa [pairingHorizontalityCoefficient_zero] at leading)

/-- Vanishing of the constant coefficient of horizontality, for a direction whose
derivation annihilates the leading pairing coefficient, is the four-term relation
between the regular connection coefficients, the first two pairing coefficients,
and the residues. -/
theorem constantOrder_relation_of_horizontality
    (derivativeLeading : derivative 0 = 0)
    (constant : pairingHorizontalityCoefficient leftResidue leftRegular rightResidue
      rightRegular pairing derivative 1 = 0) :
    (leftRegular 0)ᵀ * pairing 0 + pairing 0 * rightRegular 0
        + leftResidueᵀ * pairing 1 - pairing 1 * rightResidue = 0 := by
  rw [pairingHorizontalityCoefficient_succ, derivativeLeading, Finset.sum_range_one] at constant
  simp only [Nat.sub_self, pow_zero, one_smul, zero_add] at constant
  calc (leftRegular 0)ᵀ * pairing 0 + pairing 0 * rightRegular 0
        + leftResidueᵀ * pairing 1 - pairing 1 * rightResidue
      = leftResidueᵀ * pairing 1 - pairing 1 * rightResidue
        + ((leftRegular 0)ᵀ * pairing 0 + pairing 0 * rightRegular 0) := by abel
    _ = 0 := constant

/-- Vanishing of the constant coefficient of loop horizontality is the same
four-term relation: the loop derivation multiplies the leading pairing
coefficient by zero. -/
theorem constantOrder_relation_of_loopHorizontality
    (constant : loopPairingHorizontalityCoefficient leftResidue leftRegular rightResidue
      rightRegular pairing 1 = 0) :
    (leftRegular 0)ᵀ * pairing 0 + pairing 0 * rightRegular 0
        + leftResidueᵀ * pairing 1 - pairing 1 * rightResidue = 0 :=
  constantOrder_relation_of_horizontality (by simp) constant

end Coefficients

section SylvesterSystem

variable {leftResidue : Matrix (Fin leftRank) (Fin leftRank) R}
  {leftRegular : ℕ → Matrix (Fin leftRank) (Fin leftRank) R}
  {rightResidue : Matrix (Fin rightRank) (Fin rightRank) R}
  {rightRegular : ℕ → Matrix (Fin rightRank) (Fin rightRank) R}
  {pairing derivative : ℕ → Matrix (Fin leftRank) (Fin rightRank) R}

/-- The remainder of the horizontality coefficient at one order after the two
terms containing the pairing coefficient of that order are removed.  It involves
only strictly earlier pairing coefficients, and it vanishes at the leading
order. -/
def pairingSylvesterRemainder
    (leftRegular : ℕ → Matrix (Fin leftRank) (Fin leftRank) R)
    (rightRegular : ℕ → Matrix (Fin rightRank) (Fin rightRank) R)
    (pairing derivative : ℕ → Matrix (Fin leftRank) (Fin rightRank) R) :
    ℕ → Matrix (Fin leftRank) (Fin rightRank) R
  | 0 => 0
  | order + 1 =>
      -(derivative order
        + ∑ index ∈ Finset.range (order + 1),
            ((leftRegular index)ᵀ * pairing (order - index)
              + (-1 : R) ^ (order - index) •
                  (pairing index * rightRegular (order - index))))

/-- Horizontality is, order by order, a Sylvester equation for one pairing
coefficient whose remainder involves only strictly earlier coefficients. -/
theorem pairing_sylvester_system_of_horizontality
    (horizontal : ∀ order, pairingHorizontalityCoefficient leftResidue leftRegular
      rightResidue rightRegular pairing derivative order = 0) (order : ℕ) :
    leftResidueᵀ * pairing order - pairing order * rightResidue =
      pairingSylvesterRemainder leftRegular rightRegular pairing derivative order := by
  cases order with
  | zero =>
      have leading := horizontal 0
      rw [pairingHorizontalityCoefficient_zero] at leading
      simpa [pairingSylvesterRemainder] using leading
  | succ order =>
      have equation := horizontal (order + 1)
      rw [pairingHorizontalityCoefficient_succ] at equation
      rw [pairingSylvesterRemainder, eq_neg_iff_add_eq_zero]
      calc leftResidueᵀ * pairing (order + 1) - pairing (order + 1) * rightResidue
            + (derivative order
              + ∑ index ∈ Finset.range (order + 1),
                  ((leftRegular index)ᵀ * pairing (order - index)
                    + (-1 : R) ^ (order - index) •
                        (pairing index * rightRegular (order - index))))
          = derivative order
            + (leftResidueᵀ * pairing (order + 1) - pairing (order + 1) * rightResidue)
            + ∑ index ∈ Finset.range (order + 1),
                ((leftRegular index)ᵀ * pairing (order - index)
                  + (-1 : R) ^ (order - index) •
                      (pairing index * rightRegular (order - index))) := by abel
        _ = 0 := equation

/-- The remainder at one order vanishes once every strictly earlier pairing
coefficient vanishes, provided the direction's derivation annihilates a
vanishing coefficient. -/
theorem pairingSylvesterRemainder_eq_zero_of_earlier
    (derivativeVanishing : ∀ order, pairing order = 0 → derivative order = 0)
    (order : ℕ) (earlier : ∀ smaller, smaller < order → pairing smaller = 0) :
    pairingSylvesterRemainder leftRegular rightRegular pairing derivative order = 0 := by
  cases order with
  | zero => rfl
  | succ order =>
      have leading : pairing order = 0 := earlier order (Nat.lt_succ_self order)
      have summands : ∀ index ∈ Finset.range (order + 1),
          (leftRegular index)ᵀ * pairing (order - index)
            + (-1 : R) ^ (order - index) •
                (pairing index * rightRegular (order - index)) = 0 := by
        intro index member
        have bound : index ≤ order := Nat.lt_succ_iff.mp (Finset.mem_range.mp member)
        have first : pairing (order - index) = 0 :=
          earlier (order - index) (Nat.lt_succ_of_le (Nat.sub_le order index))
        have second : pairing index = 0 :=
          earlier index (Nat.lt_succ_of_le bound)
        rw [first, second]
        simp
      rw [pairingSylvesterRemainder, derivativeVanishing order leading,
        Finset.sum_eq_zero summands]
      simp

end SylvesterSystem

/-- The whole pairing between two spectral factors whose residues have distinct
scalar parts vanishes.  The residues are `leftResidue` and `rightResidue`, each
a scalar multiple of the identity plus a nilpotent matrix, with distinct
scalars; `pairing` is the coefficient family of the pairing between the two
factors; and the hypothesis is that every horizontality coefficient vanishes.
The leading order is a Sylvester equation with an invertible operator, and each
later order is the same equation with a remainder built from strictly earlier
coefficients, so the conclusion follows by induction on the order.  This is the
block diagonality used to restrict a horizontal pairing to a single spectral
factor. -/
theorem offDiagonalPairing_eq_zero_of_horizontality {K : Type*} [Field K]
    {leftResidue : Matrix (Fin leftRank) (Fin leftRank) K}
    {leftRegular : ℕ → Matrix (Fin leftRank) (Fin leftRank) K}
    {rightResidue : Matrix (Fin rightRank) (Fin rightRank) K}
    {rightRegular : ℕ → Matrix (Fin rightRank) (Fin rightRank) K}
    {pairing derivative : ℕ → Matrix (Fin leftRank) (Fin rightRank) K}
    {leftEigenvalue rightEigenvalue : K}
    (separated : leftEigenvalue ≠ rightEigenvalue)
    (leftNilpotent : IsNilpotent (leftResidue - leftEigenvalue • 1))
    (rightNilpotent : IsNilpotent (rightResidue - rightEigenvalue • 1))
    (derivativeVanishing : ∀ order, pairing order = 0 → derivative order = 0)
    (horizontal : ∀ order, pairingHorizontalityCoefficient leftResidue leftRegular
      rightResidue rightRegular pairing derivative order = 0) :
    ∀ order, pairing order = 0 :=
  offDiagonalCoefficients_eq_zero separated leftNilpotent rightNilpotent pairing
    (pairingSylvesterRemainder leftRegular rightRegular pairing derivative)
    (pairing_sylvester_system_of_horizontality horizontal)
    (fun order earlier =>
      pairingSylvesterRemainder_eq_zero_of_earlier derivativeVanishing order earlier)

/-- The regular coefficient of an even rank-two atomic factor preserves the
nilpotent line, directly from horizontality of the pairing in the loop
direction.  The residue of the centered connection is the square-zero matrix
`residue`, the pairing coefficients are `pairing`, and the regular connection
coefficients are `regular`.  Vanishing of the first two loop-horizontality
coefficients supplies self-adjointness of the residue for the invertible leading
pairing coefficient and the four-term constant relation, which are the two
inputs of the rank-two rigidity argument; its conclusion is that the residue,
the regular coefficient, and the residue again have vanishing product. -/
theorem regularCoefficient_preserves_nilpotentLine_of_loopHorizontality
    {K : Type*} [Field K] {residue : Matrix (Fin 2) (Fin 2) K}
    {regular pairing : ℕ → Matrix (Fin 2) (Fin 2) K}
    (twoNeZero : (2 : K) ≠ 0)
    (squareZero : residue * residue = 0) (nonzero : residue ≠ 0)
    (nondegenerate : (pairing 0).det ≠ 0)
    (leading : loopPairingHorizontalityCoefficient residue regular residue regular pairing 0 = 0)
    (constant : loopPairingHorizontalityCoefficient residue regular residue regular pairing 1 = 0) :
    residue * regular 0 * residue = 0 := by
  have selfAdjoint : residueᵀ * pairing 0 = pairing 0 * residue :=
    leadingResidue_selfAdjoint_of_horizontality leading
  have constantCoefficient :
      (regular 0)ᵀ * pairing 0 + pairing 0 * regular 0
        + residueᵀ * pairing 1 - pairing 1 * residue = 0 :=
    constantOrder_relation_of_loopHorizontality constant
  exact regularCoefficient_preserves_nilpotentLine twoNeZero squareZero nonzero
    nondegenerate selfAdjoint constantCoefficient

section ConstantPairing

variable {rank : ℕ} {residue grading pairingValue : Matrix (Fin rank) (Fin rank) R}
  {regular pairing derivative : ℕ → Matrix (Fin rank) (Fin rank) R}

/-- A pairing that is constant in the chosen frame is horizontal for a connection
whose residue is self-adjoint and whose regular part is the anti-self-adjoint
matrix `grading` in degree zero and vanishes in every higher degree, along any
direction whose derivation annihilates the constant pairing.  This is the matrix
substitution behind horizontality of the Poincare pairing for the quantum
connection: the residue is a quantum multiplication operator, self-adjoint by
the Frobenius property of quantum multiplication, and the regular part is the
grading operator, anti-self-adjoint because Poincare duality pairs complementary
degrees.  A base direction of that connection has no regular part at all, which
is the case `grading = 0`. -/
theorem constantPairing_horizontality_of_selfAdjoint
    (regularLeading : regular 0 = grading) (regularHigher : ∀ order, regular (order + 1) = 0)
    (pairingLeading : pairing 0 = pairingValue)
    (pairingHigher : ∀ order, pairing (order + 1) = 0)
    (derivativeVanishing : ∀ order, derivative order = 0)
    (selfAdjointResidue : residueᵀ * pairingValue = pairingValue * residue)
    (antiSelfAdjointGrading : gradingᵀ * pairingValue = -(pairingValue * grading)) (order : ℕ) :
    pairingHorizontalityCoefficient residue regular residue regular pairing derivative order
      = 0 := by
  cases order with
  | zero =>
      rw [pairingHorizontalityCoefficient_zero, pairingLeading, selfAdjointResidue, sub_self]
  | succ order =>
      rw [pairingHorizontalityCoefficient_succ, derivativeVanishing]
      cases order with
      | zero =>
          rw [Finset.sum_range_one]
          simp only [Nat.sub_self, pow_zero, one_smul, zero_add, pairingHigher, regularLeading,
            pairingLeading, Matrix.mul_zero, Matrix.zero_mul, sub_zero]
          rw [antiSelfAdjointGrading, neg_add_cancel]
      | succ order =>
          have summands : ∀ index ∈ Finset.range (order + 1 + 1),
              (regular index)ᵀ * pairing (order + 1 - index)
                + (-1 : R) ^ (order + 1 - index) •
                    (pairing index * regular (order + 1 - index)) = 0 := by
            intro index member
            have bound : index ≤ order + 1 := Nat.lt_succ_iff.mp (Finset.mem_range.mp member)
            cases index with
            | zero =>
                have first : pairing (order + 1 - 0) = 0 := by
                  simpa using pairingHigher order
                have second : regular (order + 1 - 0) = 0 := by
                  simpa using regularHigher order
                rw [first, second]
                simp
            | succ index =>
                have first : regular (index + 1) = 0 := regularHigher index
                have second : pairing (index + 1) = 0 := pairingHigher index
                rw [first, second]
                simp
          rw [Finset.sum_eq_zero summands, pairingHigher]
          simp

/-- The loop direction of the preceding statement: a constant pairing is
horizontal for `u ∂_u`, because that derivation multiplies the coefficient of
`u ^ order` by `order` and every coefficient beyond the leading one vanishes. -/
theorem constantPairing_loopHorizontality_of_selfAdjoint
    (regularLeading : regular 0 = grading) (regularHigher : ∀ order, regular (order + 1) = 0)
    (pairingLeading : pairing 0 = pairingValue)
    (pairingHigher : ∀ order, pairing (order + 1) = 0)
    (selfAdjointResidue : residueᵀ * pairingValue = pairingValue * residue)
    (antiSelfAdjointGrading : gradingᵀ * pairingValue = -(pairingValue * grading)) (order : ℕ) :
    loopPairingHorizontalityCoefficient residue regular residue regular pairing order = 0 := by
  refine constantPairing_horizontality_of_selfAdjoint regularLeading regularHigher
    pairingLeading pairingHigher ?_ selfAdjointResidue antiSelfAdjointGrading order
  intro step
  cases step with
  | zero => simp
  | succ step => rw [pairingHigher]; simp

end ConstantPairing

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
