import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0269_001_0 : ExtensionRow := { move := 268, child := 604, matrix := ![2,9,1,6,11,1,8,15,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 110, scalar := 9 },{ source := 17, target := 69, scalar := 2 },{ source := 34, target := 271, scalar := 10 },{ source := 52, target := 0, scalar := 6 },{ source := 75, target := 1, scalar := 2 },{ source := 181, target := 17, scalar := 3 },{ source := 268, target := 52, scalar := 7 }] }
theorem rowR7_0269_001_0_valid : (rowR7_0269_001_0).ValidFor level8 {0,1,17,34,52,75,181} := by decide

noncomputable def rowR7_0269_001_1 : ExtensionRow := { move := 270, child := 1516, matrix := ![9,4,0,8,7,12,3,1,0], witnesses := [{ source := 0, target := 1, scalar := 12 },{ source := 1, target := 110, scalar := 4 },{ source := 17, target := 71, scalar := 9 },{ source := 34, target := 217, scalar := 13 },{ source := 52, target := 34, scalar := 1 },{ source := 75, target := 17, scalar := 5 },{ source := 181, target := 52, scalar := 7 },{ source := 270, target := 0, scalar := 12 }] }
theorem rowR7_0269_001_1_valid : (rowR7_0269_001_1).ValidFor level8 {0,1,17,34,52,75,181} := by decide

noncomputable def rowsR7_0269_001 : List ExtensionRow := [rowR7_0269_001_0,rowR7_0269_001_1]

theorem rowsR7_0269_001_valid : RowListValid level8 {0,1,17,34,52,75,181} rowsR7_0269_001 := by
  intro r hr
  simp only [rowsR7_0269_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl
  · exact rowR7_0269_001_0_valid
  · exact rowR7_0269_001_1_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
