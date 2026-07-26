import RelativeConicArcs.C637WitnessQ19Basic
import RelativeConicArcs.C637WitnessQ19CoverageA
import RelativeConicArcs.C637WitnessQ19CoverageB
import RelativeConicArcs.C637WitnessQ19CoverageC
import RelativeConicArcs.C637WitnessQ19CoverageD
import RelativeConicArcs.C637WitnessQ19CoverageE
import RelativeConicArcs.C637WitnessQ19CoverageTail

namespace RelativeConicArcs.C637Witnesses

open Certificate Conic C637WitnessData

private instance : Fact (Nat.Prime 19) := ⟨by decide⟩
noncomputable local instance : Fintype (Conic.Point (ZMod 19)) := Fintype.ofFinite _
noncomputable local instance : DecidableEq (Conic.Point (ZMod 19)) := Classical.decEq _

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

theorem q19_rawCoverage : RawCoverage q19Witness := by
  rcases q19_ordinaryCoverage with ⟨haffine, hsecond, hfinal⟩
  exact ⟨fun y z => Or.inr (haffine y z),
    fun z => Or.inr (hsecond z), Or.inr hfinal⟩

theorem q19_check : check q19Witness = true := by
  simp [check, q19_rawDisjoint, q19_rawArc, q19_rawCoverage]

theorem q19_complete :
    CompleteOutside (L := Conic.Point (ZMod 19)) (pointSet q19Witness) ∅ :=
  check_sound_empty q19_check q19_ordinaryCoverage

theorem rhoC_ZMod19_le_ten : rhoC (K := ZMod 19) ≤ 10 := by
  simpa [q19Witness] using rhoC_le_length_of_check q19_check

end RelativeConicArcs.C637Witnesses
