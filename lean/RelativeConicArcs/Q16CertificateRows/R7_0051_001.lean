import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0051_001_0 : ExtensionRow := { move := 265, child := 425, matrix := ![1,3,2,1,0,1,1,0,15], witnesses := [{ source := 0, target := 175, scalar := 2 },{ source := 1, target := 17, scalar := 3 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 14 },{ source := 52, target := 52, scalar := 1 },{ source := 69, target := 96, scalar := 12 },{ source := 247, target := 69, scalar := 12 },{ source := 265, target := 1, scalar := 9 }] }
theorem rowR7_0051_001_0_valid : (rowR7_0051_001_0).ValidFor level8 {0,1,17,34,52,69,247} := by decide

noncomputable def rowR7_0051_001_1 : ExtensionRow := { move := 267, child := 279, matrix := ![1,15,4,1,13,12,1,2,3], witnesses := [{ source := 0, target := 69, scalar := 4 },{ source := 1, target := 52, scalar := 15 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 10 },{ source := 52, target := 1, scalar := 15 },{ source := 69, target := 0, scalar := 11 },{ source := 247, target := 247, scalar := 15 },{ source := 267, target := 92, scalar := 5 }] }
theorem rowR7_0051_001_1_valid : (rowR7_0051_001_1).ValidFor level8 {0,1,17,34,52,69,247} := by decide

noncomputable def rowR7_0051_001_2 : ExtensionRow := { move := 270, child := 914, matrix := ![1,15,4,1,13,12,1,2,3], witnesses := [{ source := 0, target := 69, scalar := 4 },{ source := 1, target := 52, scalar := 15 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 10 },{ source := 52, target := 1, scalar := 15 },{ source := 69, target := 0, scalar := 11 },{ source := 247, target := 247, scalar := 15 },{ source := 270, target := 171, scalar := 10 }] }
theorem rowR7_0051_001_2_valid : (rowR7_0051_001_2).ValidFor level8 {0,1,17,34,52,69,247} := by decide

noncomputable def rowsR7_0051_001 : List ExtensionRow := [rowR7_0051_001_0,rowR7_0051_001_1,rowR7_0051_001_2]

theorem rowsR7_0051_001_valid : RowListValid level8 {0,1,17,34,52,69,247} rowsR7_0051_001 := by
  intro r hr
  simp only [rowsR7_0051_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl
  · exact rowR7_0051_001_0_valid
  · exact rowR7_0051_001_1_valid
  · exact rowR7_0051_001_2_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
