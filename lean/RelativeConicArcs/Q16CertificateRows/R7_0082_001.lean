import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0082_001_0 : ExtensionRow := { move := 266, child := 429, matrix := ![9,3,5,0,6,4,0,5,12], witnesses := [{ source := 0, target := 190, scalar := 5 },{ source := 1, target := 52, scalar := 3 },{ source := 17, target := 17, scalar := 9 },{ source := 34, target := 69, scalar := 15 },{ source := 52, target := 0, scalar := 13 },{ source := 71, target := 34, scalar := 1 },{ source := 121, target := 96, scalar := 13 },{ source := 266, target := 1, scalar := 6 }] }
theorem rowR7_0082_001_0_valid : (rowR7_0082_001_0).ValidFor level8 {0,1,17,34,52,71,121} := by decide

noncomputable def rowR7_0082_001_1 : ExtensionRow := { move := 267, child := 1558, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 71, target := 71, scalar := 1 },{ source := 121, target := 121, scalar := 1 },{ source := 267, target := 267, scalar := 1 }] }
theorem rowR7_0082_001_1_valid : (rowR7_0082_001_1).ValidFor level8 {0,1,17,34,52,71,121} := by decide

noncomputable def rowR7_0082_001_2 : ExtensionRow := { move := 271, child := 1559, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 71, target := 71, scalar := 1 },{ source := 121, target := 121, scalar := 1 },{ source := 271, target := 271, scalar := 1 }] }
theorem rowR7_0082_001_2_valid : (rowR7_0082_001_2).ValidFor level8 {0,1,17,34,52,71,121} := by decide

noncomputable def rowsR7_0082_001 : List ExtensionRow := [rowR7_0082_001_0,rowR7_0082_001_1,rowR7_0082_001_2]

theorem rowsR7_0082_001_valid : RowListValid level8 {0,1,17,34,52,71,121} rowsR7_0082_001 := by
  intro r hr
  simp only [rowsR7_0082_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl
  · exact rowR7_0082_001_0_valid
  · exact rowR7_0082_001_1_valid
  · exact rowR7_0082_001_2_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
