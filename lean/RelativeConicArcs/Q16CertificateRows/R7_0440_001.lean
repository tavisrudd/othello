import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0440_001_0 : ExtensionRow := { move := 259, child := 1200, matrix := ![1,12,6,1,7,0,1,9,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 70, scalar := 12 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 239, scalar := 11 },{ source := 52, target := 1, scalar := 15 },{ source := 124, target := 0, scalar := 2 },{ source := 208, target := 120, scalar := 8 },{ source := 259, target := 52, scalar := 5 }] }
theorem rowR7_0440_001_0_valid : (rowR7_0440_001_0).ValidFor level8 {0,1,17,34,52,124,208} := by decide

noncomputable def rowR7_0440_001_1 : ExtensionRow := { move := 264, child := 18, matrix := ![1,0,0,4,0,13,8,4,0], witnesses := [{ source := 0, target := 1, scalar := 13 },{ source := 1, target := 0, scalar := 4 },{ source := 17, target := 89, scalar := 1 },{ source := 34, target := 173, scalar := 1 },{ source := 52, target := 17, scalar := 1 },{ source := 124, target := 52, scalar := 1 },{ source := 208, target := 67, scalar := 1 },{ source := 264, target := 34, scalar := 1 }] }
theorem rowR7_0440_001_1_valid : (rowR7_0440_001_1).ValidFor level8 {0,1,17,34,52,124,208} := by decide

noncomputable def rowR7_0440_001_2 : ExtensionRow := { move := 265, child := 1257, matrix := ![4,0,6,6,13,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 1, scalar := 13 },{ source := 17, target := 158, scalar := 4 },{ source := 34, target := 218, scalar := 2 },{ source := 52, target := 52, scalar := 14 },{ source := 124, target := 70, scalar := 11 },{ source := 208, target := 0, scalar := 1 },{ source := 265, target := 34, scalar := 1 }] }
theorem rowR7_0440_001_2_valid : (rowR7_0440_001_2).ValidFor level8 {0,1,17,34,52,124,208} := by decide

noncomputable def rowR7_0440_001_3 : ExtensionRow := { move := 270, child := 670, matrix := ![7,14,9,4,2,0,12,12,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 120, scalar := 14 },{ source := 17, target := 207, scalar := 7 },{ source := 34, target := 1, scalar := 6 },{ source := 52, target := 0, scalar := 7 },{ source := 124, target := 69, scalar := 9 },{ source := 208, target := 34, scalar := 1 },{ source := 270, target := 52, scalar := 13 }] }
theorem rowR7_0440_001_3_valid : (rowR7_0440_001_3).ValidFor level8 {0,1,17,34,52,124,208} := by decide

noncomputable def rowR7_0440_001_4 : ExtensionRow := { move := 271, child := 2253, matrix := ![0,12,8,0,8,0,8,4,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 271, scalar := 12 },{ source := 17, target := 0, scalar := 8 },{ source := 34, target := 52, scalar := 4 },{ source := 52, target := 1, scalar := 3 },{ source := 124, target := 183, scalar := 9 },{ source := 208, target := 72, scalar := 12 },{ source := 271, target := 34, scalar := 1 }] }
theorem rowR7_0440_001_4_valid : (rowR7_0440_001_4).ValidFor level8 {0,1,17,34,52,124,208} := by decide

noncomputable def rowsR7_0440_001 : List ExtensionRow := [rowR7_0440_001_0,rowR7_0440_001_1,rowR7_0440_001_2,rowR7_0440_001_3,rowR7_0440_001_4]

theorem rowsR7_0440_001_valid : RowListValid level8 {0,1,17,34,52,124,208} rowsR7_0440_001 := by
  intro r hr
  simp only [rowsR7_0440_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl
  · exact rowR7_0440_001_0_valid
  · exact rowR7_0440_001_1_valid
  · exact rowR7_0440_001_2_valid
  · exact rowR7_0440_001_3_valid
  · exact rowR7_0440_001_4_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
