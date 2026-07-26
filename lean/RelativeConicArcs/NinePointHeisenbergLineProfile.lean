import RelativeConicArcs.NinePointHeisenbergCompleteLineProfile
import RelativeConicArcs.NinePointHeisenbergSelectedSecantProfile
import RelativeConicArcs.NinePointHeisenbergUncoveredSecantProfile

/-!
# Line and secant profiles of a nine-point Heisenberg pair

The three imported kernel theorems cover all 381 projective lines and the chord multiplicity
histograms outside each explicit nine-point set.  This module exposes their combined interface
without repeating a finite reduction.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergLineProfile

open NinePointHeisenbergIncidence

/-- The seven occurring line types and their multiplicities account for all 381 lines. -/
theorem complete_line_type_profile :
    lineTypeCount 0 0 = 147 ∧
    lineTypeCount 0 1 = 81 ∧
    lineTypeCount 0 2 = 9 ∧
    lineTypeCount 1 0 = 54 ∧
    lineTypeCount 1 1 = 27 ∧
    lineTypeCount 1 2 = 27 ∧
    lineTypeCount 2 0 = 36 ∧
    canonicalPoints.all (fun line =>
      lineType line = (0, 0) || lineType line = (0, 1) ||
      lineType line = (0, 2) || lineType line = (1, 0) ||
      lineType line = (1, 1) || lineType line = (1, 2) ||
      lineType line = (2, 0)) = true :=
  NinePointHeisenbergCompleteLineProfile.complete_line_type_profile

/-- Chord multiplicities away from the selected set. -/
theorem selected_secant_multiplicity_profile :
    offSetSecantMultiplicityCount NinePointHeisenbergPair.selected 0 = 9 ∧
    offSetSecantMultiplicityCount NinePointHeisenbergPair.selected 1 = 162 ∧
    offSetSecantMultiplicityCount NinePointHeisenbergPair.selected 2 = 126 ∧
    offSetSecantMultiplicityCount NinePointHeisenbergPair.selected 3 = 66 ∧
    offSetSecantMultiplicityCount NinePointHeisenbergPair.selected 4 = 9 :=
  NinePointHeisenbergSelectedSecantProfile.selected_secant_multiplicity_profile

/-- Chord multiplicities away from the uncovered set. -/
theorem uncovered_secant_multiplicity_profile :
    offSetSecantMultiplicityCount NinePointHeisenbergPair.uncovered 0 = 18 ∧
    offSetSecantMultiplicityCount NinePointHeisenbergPair.uncovered 1 = 126 ∧
    offSetSecantMultiplicityCount NinePointHeisenbergPair.uncovered 2 = 180 ∧
    offSetSecantMultiplicityCount NinePointHeisenbergPair.uncovered 3 = 30 ∧
    offSetSecantMultiplicityCount NinePointHeisenbergPair.uncovered 4 = 18 :=
  NinePointHeisenbergUncoveredSecantProfile.uncovered_secant_multiplicity_profile

end NinePointHeisenbergLineProfile
end RelativeConicArcs
