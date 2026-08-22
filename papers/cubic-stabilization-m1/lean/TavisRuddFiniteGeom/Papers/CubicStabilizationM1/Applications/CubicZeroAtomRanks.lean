import Mathlib.Tactic
import Mathlib.Topology.LocallyConstant.Basic

/-!
# The parity ranks of the zero packet of a smooth cubic threefold

The manuscript computes the two ranks of the generalized eigenbundle of the zero
eigenvalue of Euler multiplication at the small hyperplane point of a smooth
cubic threefold, and separates the branch carrying them from the two rank-one
branches.  This module proves the arithmetic and the separation argument behind
that computation.

The even rank is two, from the block reduction of the small even connection.
The odd rank is the third Betti number, which the manuscript obtains from the
total Chern class: adjunction for a cubic hypersurface in projective four-space
gives the total Chern class as the quotient of the fifth power of `1 + P` by
`1 + 3 * P`, where `P` is the hyperplane class of the threefold and `P ^ 4 = 0`;
carrying out that division gives `1 + 2 * P + 4 * P ^ 2 - 2 * P ^ 3`.  The degree
of the hyperplane class cubed is three, so the top Chern number is `-6`, and with
the Lefschetz Betti numbers the alternating sum gives the third Betti number ten.

That the whole odd cohomology sits in the zero packet is a degree count: Euler
multiplication moves a class of cohomological degree three in Novikov degree `d`
to cohomological degree `5 - 4 * d`, and the cohomology of the threefold vanishes
in that degree for every nonnegative `d`, because it vanishes in degrees one and
five and in negative degrees.

The separation of branches is the statement that a locally constant rank function
takes the same value at two points of one connected component: two points of a
fibre carrying different ranks lie in different components, so the branch of rank
twelve is a component containing neither rank-one branch.

Lean constructs no cohomology, no quantum product, no Chern class, and no
spectral cover.  The Chern computation appears as an identity in a commutative
ring where the fourth power of the distinguished element vanishes, the Betti
count as an identity between integers, and the branch separation as a statement
about a locally constant function on a topological space.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Applications

section ChernClass

variable {A : Type*} [CommRing A]

/-- The total Chern class of a smooth cubic threefold.  In a commutative ring
where the fourth power of `P` vanishes, which is the truncation of the cohomology
of a threefold, the class `1 + 2 * P + 4 * P ^ 2 - 2 * P ^ 3` is the quotient of
the fifth power of `1 + P` by `1 + 3 * P`, the adjunction expression for a cubic
hypersurface in projective four-space.  Its component in degree three is
`-2 * P ^ 3`. -/
theorem cubicThreefold_totalChernClass (P : A) (vanishing : P ^ 4 = 0) :
    (1 + 3 * P) * (1 + 2 * P + 4 * P ^ 2 - 2 * P ^ 3) = (1 + P) ^ 5 := by
  linear_combination (-11 - P) * vanishing

/-- The adjunction factor is a unit in the truncated ring, with the displayed
inverse, because the hyperplane class is nilpotent of exponent four. -/
theorem cubicThreefold_adjunctionFactor_isUnit (P : A) (vanishing : P ^ 4 = 0) :
    (1 + 3 * P) * (1 - 3 * P + 9 * P ^ 2 - 27 * P ^ 3) = 1 := by
  linear_combination (-81 : A) * vanishing

/-- The total Chern class of a smooth cubic threefold is the only solution of the
adjunction equation.  Since the factor `1 + 3 * P` is a unit, any class whose
product with it is the fifth power of `1 + P` equals
`1 + 2 * P + 4 * P ^ 2 - 2 * P ^ 3`, so the third Chern class is `-2 * P ^ 3`
rather than merely consistent with that value. -/
theorem cubicThreefold_totalChernClass_unique (P chernClass : A) (vanishing : P ^ 4 = 0)
    (adjunction : (1 + 3 * P) * chernClass = (1 + P) ^ 5) :
    chernClass = 1 + 2 * P + 4 * P ^ 2 - 2 * P ^ 3 := by
  have inverse := cubicThreefold_adjunctionFactor_isUnit P vanishing
  have expanded : (1 - 3 * P + 9 * P ^ 2 - 27 * P ^ 3) * ((1 + 3 * P) * chernClass) =
      (1 - 3 * P + 9 * P ^ 2 - 27 * P ^ 3) * (1 + P) ^ 5 := by rw [adjunction]
  calc chernClass = ((1 + 3 * P) * (1 - 3 * P + 9 * P ^ 2 - 27 * P ^ 3)) * chernClass := by
        rw [inverse, one_mul]
    _ = (1 - 3 * P + 9 * P ^ 2 - 27 * P ^ 3) * ((1 + 3 * P) * chernClass) := by ring
    _ = (1 - 3 * P + 9 * P ^ 2 - 27 * P ^ 3) * (1 + P) ^ 5 := expanded
    _ = 1 + 2 * P + 4 * P ^ 2 - 2 * P ^ 3 := by linear_combination (-70 - 194 * P - 228 * P ^ 2 - 126 * P ^ 3 - 27 * P ^ 4) * vanishing

end ChernClass

section BettiNumbers

/-- The third Betti number of a smooth cubic threefold is ten.  The hypotheses
are the Lefschetz Betti numbers in the remaining degrees, the top Chern number as
the coefficient `-2` of the third Chern class against the degree three of the
hyperplane class cubed, and the equality of the alternating sum of the Betti
numbers with that top Chern number. -/
theorem cubicThreefold_bettiThree_eq_ten (betti : ℕ → ℤ) (topChernNumber : ℤ)
    (degreeZero : betti 0 = 1) (degreeOne : betti 1 = 0) (degreeTwo : betti 2 = 1)
    (degreeFour : betti 4 = 1) (degreeFive : betti 5 = 0) (degreeSix : betti 6 = 1)
    (chernNumber : topChernNumber = -2 * 3)
    (eulerCharacteristic :
      betti 0 - betti 1 + betti 2 - betti 3 + betti 4 - betti 5 + betti 6 = topChernNumber) :
    betti 3 = 10 := by
  omega

/-- Euler multiplication annihilates the degree-three cohomology of a smooth
cubic threefold.  A class of cohomological degree three in Novikov degree `d` is
sent to cohomological degree `5 - 4 * d`, and the cohomology vanishes there for
every nonnegative `d`: the value is five when `d` is zero, one when `d` is one,
and negative afterwards. -/
theorem cubicThreefold_eulerShift_target_vanishes (betti : ℤ → ℕ)
    (belowZero : ∀ degree : ℤ, degree < 0 → betti degree = 0)
    (degreeOne : betti 1 = 0) (degreeFive : betti 5 = 0) (novikovDegree : ℕ) :
    betti (5 - 4 * (novikovDegree : ℤ)) = 0 := by
  have trichotomy : (5 : ℤ) - 4 * (novikovDegree : ℤ) = 5 ∨
      (5 : ℤ) - 4 * (novikovDegree : ℤ) = 1 ∨ (5 : ℤ) - 4 * (novikovDegree : ℤ) < 0 := by
    match novikovDegree with
    | 0 => left; norm_num
    | 1 => right; left; norm_num
    | (step + 2) =>
      right; right
      push_cast
      omega
  rcases trichotomy with value | value | value
  · rw [value]; exact degreeFive
  · rw [value]; exact degreeOne
  · exact belowZero _ value

end BettiNumbers

section BranchSeparation

variable {Cover : Type*} [TopologicalSpace Cover]

/-- Two points of one connected component of the spectral cover carry the same
generalized eigenbundle rank, so a point whose rank differs from that of a given
point lies outside its connected component.  The rank of the generalized
eigenbundle is locally constant on the unramified locus, which is the hypothesis
here. -/
theorem branch_not_mem_connectedComponent_of_rank_ne {rank : Cover → ℕ}
    (locallyConstant : IsLocallyConstant rank) {branch other : Cover}
    (distinct : rank branch ≠ rank other) :
    other ∉ connectedComponent branch := fun member =>
  distinct
    (locallyConstant.apply_eq_of_isPreconnected isPreconnected_connectedComponent
      mem_connectedComponent member)

/-- The branch of the fibre carrying the zero packet lies in a connected
component containing neither of the two rank-one branches.  The ranks are the
data of the manuscript's fibre over the small hyperplane point: twelve on the
zero branch and one on each nonzero branch. -/
theorem cubicZeroPacket_component_excludes_rankOne_branches {rank : Cover → ℕ}
    (locallyConstant : IsLocallyConstant rank) {zeroBranch positiveBranch negativeBranch : Cover}
    (zeroRank : rank zeroBranch = 12) (positiveRank : rank positiveBranch = 1)
    (negativeRank : rank negativeBranch = 1) :
    positiveBranch ∉ connectedComponent zeroBranch ∧
      negativeBranch ∉ connectedComponent zeroBranch := by
  constructor
  · exact branch_not_mem_connectedComponent_of_rank_ne locallyConstant
      (by rw [zeroRank, positiveRank]; decide)
  · exact branch_not_mem_connectedComponent_of_rank_ne locallyConstant
      (by rw [zeroRank, negativeRank]; decide)

end BranchSeparation

section ParityRanks

/-- The parity ranks of the zero packet of a smooth cubic threefold are two and
ten, and its total rank is twelve.  The even rank is the rank of the zero
generalized eigenspace of the small even Euler multiplication, which the block
reduction computes; the odd rank is the third Betti number, since the whole
degree-three cohomology lies in the zero packet. -/
theorem cubicZeroPacket_parityRanks (betti : ℕ → ℤ) (topChernNumber : ℤ)
    (evenRank oddRank : ℕ)
    (degreeZero : betti 0 = 1) (degreeOne : betti 1 = 0) (degreeTwo : betti 2 = 1)
    (degreeFour : betti 4 = 1) (degreeFive : betti 5 = 0) (degreeSix : betti 6 = 1)
    (chernNumber : topChernNumber = -2 * 3)
    (eulerCharacteristic :
      betti 0 - betti 1 + betti 2 - betti 3 + betti 4 - betti 5 + betti 6 = topChernNumber)
    (evenBlock : evenRank = 2) (oddPart : (oddRank : ℤ) = betti 3) :
    evenRank = 2 ∧ oddRank = 10 ∧ evenRank + oddRank = 12 := by
  have bettiThree := cubicThreefold_bettiThree_eq_ten betti topChernNumber degreeZero degreeOne
    degreeTwo degreeFour degreeFive degreeSix chernNumber eulerCharacteristic
  refine ⟨evenBlock, ?_, ?_⟩ <;> omega

end ParityRanks

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
