import RelativeConicArcs.SmallOddRelativeConicWitnessQ19Basic
import RelativeConicArcs.SmallOddRelativeConicWitnessQ19CoverageA
import RelativeConicArcs.SmallOddRelativeConicWitnessQ19CoverageB
import RelativeConicArcs.SmallOddRelativeConicWitnessQ19CoverageC
import RelativeConicArcs.SmallOddRelativeConicWitnessQ19CoverageD
import RelativeConicArcs.SmallOddRelativeConicWitnessQ19CoverageE
import RelativeConicArcs.SmallOddRelativeConicWitnessQ19CoverageTail

/-!
# Order-nineteen relative-conic witness

The bounded coverage modules partition all normalized projective coordinates.  Their kernel-reduced
statements combine with the raw arc and conic-avoidance checks to prove ordinary completeness and
the relative-conic upper bound.  No exhaustive lower-bound classification is imported.
-/

namespace RelativeConicArcs.SmallOddRelativeConicWitnesses

open Certificate Conic SmallOddRelativeConicWitnessData

private instance : Fact (Nat.Prime 19) := ⟨by decide⟩
noncomputable local instance : Fintype (Conic.Point (ZMod 19)) := Fintype.ofFinite _
noncomputable local instance : DecidableEq (Conic.Point (ZMod 19)) := Classical.decEq _

/-- Every projective point outside the order-nineteen witness lies on one of its secants. -/
theorem q19_ordinaryCoverage : RawOrdinaryCoverage q19Witness := by
  refine ⟨?_, q19_ordinary_second, q19_ordinary_final⟩
  intro y
  fin_cases y
  · exact q19_ordinary_y0
  · exact q19_ordinary_y1
  · exact q19_ordinary_y2
  · exact q19_ordinary_y3
  · exact q19_ordinary_y4
  · exact q19_ordinary_y5
  · exact q19_ordinary_y6
  · exact q19_ordinary_y7
  · exact q19_ordinary_y8
  · exact q19_ordinary_y9
  · exact q19_ordinary_y10
  · exact q19_ordinary_y11
  · exact q19_ordinary_y12
  · exact q19_ordinary_y13
  · exact q19_ordinary_y14
  · exact q19_ordinary_y15
  · exact q19_ordinary_y16
  · exact q19_ordinary_y17
  · exact q19_ordinary_y18

/-- Every point of the standard conic lies on a secant of the order-nineteen witness. -/
theorem q19_rawCoverage : RawCoverage q19Witness := by
  rcases q19_ordinaryCoverage with ⟨haffine, hsecond, hfinal⟩
  exact ⟨fun y z => Or.inr (haffine y z),
    fun z => Or.inr (hsecond z), Or.inr hfinal⟩

/-- The rules-only relative-conic checker accepts the order-nineteen witness. -/
theorem q19_check : check q19Witness = true := by
  simp [check, q19_rawDisjoint, q19_rawArc, q19_rawCoverage]

/-- The order-nineteen witness is complete outside the standard conic and is ordinarily complete. -/
theorem q19_complete :
    CompleteOutside (L := Conic.Point (ZMod 19)) (pointSet q19Witness) ∅ :=
  check_sound_empty q19_check q19_ordinaryCoverage

/-- The least size of an arc complete outside a conic over `ZMod 19` is at most ten. -/
theorem rhoC_ZMod19_le_ten : rhoC (K := ZMod 19) ≤ 10 := by
  simpa [q19Witness] using rhoC_le_length_of_check q19_check

end RelativeConicArcs.SmallOddRelativeConicWitnesses
