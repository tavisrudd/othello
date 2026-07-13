import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0278_001_0 : ExtensionRow := { move := 266, child := 1359, matrix := ![14,2,6,13,0,10,10,0,7], witnesses := [{ source := 0, target := 71, scalar := 6 },{ source := 1, target := 17, scalar := 2 },{ source := 17, target := 94, scalar := 14 },{ source := 34, target := 52, scalar := 10 },{ source := 52, target := 0, scalar := 3 },{ source := 75, target := 106, scalar := 1 },{ source := 224, target := 34, scalar := 1 },{ source := 266, target := 1, scalar := 8 }] }
theorem rowR7_0278_001_0_valid : (rowR7_0278_001_0).ValidFor level8 {0,1,17,34,52,75,224} := by decide

noncomputable def rowR7_0278_001_1 : ExtensionRow := { move := 270, child := 2121, matrix := ![4,10,6,11,8,0,5,14,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 181, scalar := 10 },{ source := 17, target := 125, scalar := 4 },{ source := 34, target := 52, scalar := 8 },{ source := 52, target := 72, scalar := 9 },{ source := 75, target := 0, scalar := 4 },{ source := 224, target := 34, scalar := 1 },{ source := 270, target := 1, scalar := 10 }] }
theorem rowR7_0278_001_1_valid : (rowR7_0278_001_1).ValidFor level8 {0,1,17,34,52,75,224} := by decide

noncomputable def rowsR7_0278_001 : List ExtensionRow := [rowR7_0278_001_0,rowR7_0278_001_1]

theorem rowsR7_0278_001_valid : RowListValid level8 {0,1,17,34,52,75,224} rowsR7_0278_001 := by
  intro r hr
  simp only [rowsR7_0278_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl
  · exact rowR7_0278_001_0_valid
  · exact rowR7_0278_001_1_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
