import RelativeConicArcs.PassantCodeQ13.Reconstruction
import Mathlib.Tactic

/-!
# Structural mechanisms for the q=13 passant code

This module contains the theorem-shaped, computation-independent parts of the structural proof:
the theta inequality, the global weight-ten moment compression, pair-neighborhood reconstruction,
the pencil-conic discriminant identity, and the irreducible-cubic operator reduction.  Concrete
q=13 matrices and orbit tables belong to the paper-owned certificate package.
-/

namespace RelativeConicArcs.PassantCodeQ13

open Finset

/-- The neighborhood of a vertex in one weighted pair-concurrence color. -/
def pairNeighborhood (minimumSupports : Finset (Finset InternalPoint))
    (color : ℕ) (point : InternalPoint) : Finset InternalPoint :=
  Finset.univ.filter fun other =>
    other ≠ point ∧
      ConicPassantCode.pairConcurrence minimumSupports point other = color

/-- The row family selected directly by one pair-concurrence color. -/
def pairRecoveredRows (minimumSupports : Finset (Finset InternalPoint))
    (color : ℕ) : Finset (Finset InternalPoint) :=
  Finset.univ.image (pairNeighborhood minimumSupports color)

/-- The polar neighborhood of one internal point, expressed without choosing a normalized dual
representative for its polar line. -/
def polarRow (point : InternalPoint) : Finset InternalPoint :=
  Finset.univ.filter fun other => polarValue point.1 other.1 = 0

/-- The complete internal--internal polarity block, indexed by its point rows. -/
def polarRowFamily : Finset (Finset InternalPoint) :=
  Finset.univ.image polarRow

/-- Exact interface for pair-only reconstruction.  The concrete certificate identifies color eight
with the polar rows, separates the fused color-six relations by a pair-derived walk count, and
records that unary degrees are constant. -/
structure PairOnlyReconstructionCertificate
    (minimumSupports : Finset (Finset InternalPoint)) where
  colorEightRows : pairRecoveredRows minimumSupports 8 = polarRowFamily
  unaryDegree : ℕ
  unaryConstant : ∀ point : InternalPoint,
    (minimumSupports.filter fun support => point ∈ support).card = unaryDegree
  fusedColorSplit : ∀ first second : InternalPoint,
    first ≠ second →
    ConicPassantCode.pairConcurrence minimumSupports first second = 6 →
    (Finset.univ.filter fun middle =>
      ConicPassantCode.pairConcurrence minimumSupports first middle = 7 ∧
      ConicPassantCode.pairConcurrence minimumSupports middle second = 7).card = 2 ∨
    (Finset.univ.filter fun middle =>
      ConicPassantCode.pairConcurrence minimumSupports first middle = 7 ∧
      ConicPassantCode.pairConcurrence minimumSupports middle second = 7).card = 4

/-- A pair-only certificate recovers the internal--internal polarity rows directly. -/
theorem pairRecoveredRows_eq_polarRows
    {minimumSupports : Finset (Finset InternalPoint)}
    (certificate : PairOnlyReconstructionCertificate minimumSupports) :
    pairRecoveredRows minimumSupports 8 = polarRowFamily :=
  certificate.colorEightRows

/-- Unary incidence degrees carry no distinguishing information in a pair-only certificate. -/
theorem unaryDegrees_are_constant
    {minimumSupports : Finset (Finset InternalPoint)}
    (certificate : PairOnlyReconstructionCertificate minimumSupports)
    (first second : InternalPoint) :
    (minimumSupports.filter fun support => first ∈ support).card =
      (minimumSupports.filter fun support => second ∈ support).card := by
  rw [certificate.unaryConstant first, certificate.unaryConstant second]

/-- The numerical heart of the exact theta certificate: a positive quadratic form with value
`10 c (5-c)` on a nonempty clique forces clique size at most five. -/
theorem cliqueSize_le_five_of_theta_inequality (cliqueSize : ℕ)
    (nonempty : 0 < cliqueSize)
    (positive : 0 ≤ (10 : ℤ) * cliqueSize * (5 - cliqueSize)) :
    cliqueSize ≤ 5 := by
  have nonemptyInt : (0 : ℤ) < cliqueSize := by exact_mod_cast nonempty
  nlinarith

/-- The global weight-ten moment leaves precisely the two stated shapes once the secant graph is
known to have six or ten cycle vertices.  `higher` collects the nonnegative contribution
`n₆ + 2 n₈ + ...`; the coefficient twelve is all that is needed to force it to vanish. -/
theorem weightTenMoment_two_shapes (cycleVertices fourLines higher : ℕ)
    (cycleShape : cycleVertices = 6 ∨ cycleVertices = 10)
    (moment : 4 * fourLines + 12 * higher + cycleVertices = 10) :
    (cycleVertices = 6 ∧ fourLines = 1 ∧ higher = 0) ∨
      (cycleVertices = 10 ∧ fourLines = 0 ∧ higher = 0) := by
  omega

/-- Algebraic identity behind the punctured pencil-conic parity argument. -/
theorem pencilConic_doubleRoot_discriminant {K : Type*} [CommRing K]
    (A B C r : K) (doubleRoot : 4 * A * C = r * B ^ 2) :
    B ^ 2 - 4 * A * C = B ^ 2 * (1 - r) := by
  rw [doubleRoot]
  ring

/-- Cancelling the invertible `B+1` factor in the quartic relation produces the hidden irreducible
cubic.  This is the ring-theoretic step used before adjoining the concrete `F₈` operator field. -/
theorem hiddenCubic_of_quartic {R : Type*} [CommRing R] (B inverse : R)
    (characteristicTwo : (2 : R) = 0)
    (leftInverse : inverse * (B + 1) = 1)
    (quartic : 1 + B + B ^ 2 + B ^ 4 = 0) :
    B ^ 3 + B ^ 2 + 1 = 0 := by
  have factorization :
      (B + 1) * (B ^ 3 + B ^ 2 + 1) = 1 + B + B ^ 2 + B ^ 4 := by
    calc
      (B + 1) * (B ^ 3 + B ^ 2 + 1) =
          1 + B + B ^ 2 + B ^ 4 + 2 * B ^ 3 := by ring
      _ = 1 + B + B ^ 2 + B ^ 4 := by rw [characteristicTwo, zero_mul, add_zero]
  have productZero : (B + 1) * (B ^ 3 + B ^ 2 + 1) = 0 := by
    rw [factorization, quartic]
  calc
    B ^ 3 + B ^ 2 + 1 = (inverse * (B + 1)) * (B ^ 3 + B ^ 2 + 1) := by
      rw [leftInverse, one_mul]
    _ = inverse * ((B + 1) * (B ^ 3 + B ^ 2 + 1)) := by rw [mul_assoc]
    _ = 0 := by rw [productZero, mul_zero]

/-- Abstract output interface for the group-theoretic recovery of the marked plane. -/
structure RecoveredConicPlane where
  Point : Type
  Line : Type
  pointFintype : Fintype Point
  lineFintype : Fintype Line
  incident : Line → Point → Prop
  conic : Finset Point
  polarity : Point ≃ Line
  pointCount : Fintype.card Point = 183
  lineCount : Fintype.card Line = 183
  conicCount : conic.card = 14
  uniqueLine : ∀ first second : Point, first ≠ second →
    ∃! line : Line, incident line first ∧ incident line second
  uniquePoint : ∀ first second : Line, first ≠ second →
    ∃! point : Point, incident first point ∧ incident second point
  polarityIncidence : ∀ point other : Point,
    incident (polarity point) other ↔ incident (polarity other) point

attribute [instance] RecoveredConicPlane.pointFintype RecoveredConicPlane.lineFintype

end RelativeConicArcs.PassantCodeQ13
