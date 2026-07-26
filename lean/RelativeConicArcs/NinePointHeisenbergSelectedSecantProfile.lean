import RelativeConicArcs.NinePointHeisenbergSelectedSecantY0To4
import RelativeConicArcs.NinePointHeisenbergSelectedSecantY5To9
import RelativeConicArcs.NinePointHeisenbergSelectedSecantY10To14
import RelativeConicArcs.NinePointHeisenbergSelectedSecantY15To18AndInfinity

/-!
# Selected-orbit secant multiplicities

Four coordinate-block kernel theorems cover all 381 projective points.  Their counts are added
symbolically here, so the global histogram requires no repeated finite reduction.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergSelectedSecantProfile

open NinePointHeisenbergIncidence

private theorem countOn_append (left right points : List NinePointHeisenbergPair.V) (n : Nat) :
    offSetSecantMultiplicityCountOn (left ++ right) points n =
      offSetSecantMultiplicityCountOn left points n +
        offSetSecantMultiplicityCountOn right points n := by
  simp [offSetSecantMultiplicityCountOn]

private theorem countByBlocks (points : List NinePointHeisenbergPair.V) (n : Nat) :
    offSetSecantMultiplicityCount points n =
      offSetSecantMultiplicityCountOn canonicalPointsY0To4 points n +
        offSetSecantMultiplicityCountOn canonicalPointsY5To9 points n +
        offSetSecantMultiplicityCountOn canonicalPointsY10To14 points n +
        offSetSecantMultiplicityCountOn canonicalPointsY15To18AndInfinity points n := by
  change
    offSetSecantMultiplicityCountOn
      (canonicalPointsY0To4 ++ canonicalPointsY5To9 ++ canonicalPointsY10To14 ++
        canonicalPointsY15To18AndInfinity) points n = _
  rw [countOn_append, countOn_append, countOn_append]

/-- Chord multiplicities away from the selected set. -/
theorem selected_secant_multiplicity_profile :
    offSetSecantMultiplicityCount NinePointHeisenbergPair.selected 0 = 9 ∧
    offSetSecantMultiplicityCount NinePointHeisenbergPair.selected 1 = 162 ∧
    offSetSecantMultiplicityCount NinePointHeisenbergPair.selected 2 = 126 ∧
    offSetSecantMultiplicityCount NinePointHeisenbergPair.selected 3 = 66 ∧
    offSetSecantMultiplicityCount NinePointHeisenbergPair.selected 4 = 9 := by
  rcases NinePointHeisenbergSelectedSecantY0To4.secant_multiplicity_profile with
    ⟨h00, h01, h02, h03, h04⟩
  rcases NinePointHeisenbergSelectedSecantY5To9.secant_multiplicity_profile with
    ⟨h10, h11, h12, h13, h14⟩
  rcases NinePointHeisenbergSelectedSecantY10To14.secant_multiplicity_profile with
    ⟨h20, h21, h22, h23, h24⟩
  rcases NinePointHeisenbergSelectedSecantY15To18AndInfinity.secant_multiplicity_profile with
    ⟨h30, h31, h32, h33, h34⟩
  simp only [countByBlocks,
    h00, h01, h02, h03, h04, h10, h11, h12, h13, h14,
    h20, h21, h22, h23, h24, h30, h31, h32, h33, h34]
  simp

end NinePointHeisenbergSelectedSecantProfile
end RelativeConicArcs
