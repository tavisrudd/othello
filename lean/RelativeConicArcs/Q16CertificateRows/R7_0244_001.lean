import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0244_001_0 : ExtensionRow := { move := 262, child := 2318, matrix := ![9,0,7,1,0,0,8,4,0], witnesses := [{ source := 0, target := 17, scalar := 7 },{ source := 1, target := 0, scalar := 4 },{ source := 17, target := 52, scalar := 9 },{ source := 34, target := 72, scalar := 14 },{ source := 52, target := 1, scalar := 1 },{ source := 74, target := 254, scalar := 3 },{ source := 231, target := 271, scalar := 8 },{ source := 262, target := 34, scalar := 1 }] }
theorem rowR7_0244_001_0_valid : (rowR7_0244_001_0).ValidFor level8 {0,1,17,34,52,74,231} := by decide

noncomputable def rowR7_0244_001_1 : ExtensionRow := { move := 264, child := 2143, matrix := ![7,0,6,9,9,1,6,0,7], witnesses := [{ source := 0, target := 135, scalar := 6 },{ source := 1, target := 1, scalar := 9 },{ source := 17, target := 72, scalar := 7 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 186, scalar := 13 },{ source := 74, target := 52, scalar := 4 },{ source := 231, target := 0, scalar := 7 },{ source := 264, target := 17, scalar := 6 }] }
theorem rowR7_0244_001_1_valid : (rowR7_0244_001_1).ValidFor level8 {0,1,17,34,52,74,231} := by decide

noncomputable def rowR7_0244_001_2 : ExtensionRow := { move := 267, child := 2353, matrix := ![14,14,0,0,1,1,0,9,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 73, scalar := 14 },{ source := 17, target := 17, scalar := 14 },{ source := 34, target := 0, scalar := 9 },{ source := 52, target := 34, scalar := 1 },{ source := 74, target := 269, scalar := 15 },{ source := 231, target := 120, scalar := 4 },{ source := 267, target := 52, scalar := 11 }] }
theorem rowR7_0244_001_2_valid : (rowR7_0244_001_2).ValidFor level8 {0,1,17,34,52,74,231} := by decide

noncomputable def rowR7_0244_001_3 : ExtensionRow := { move := 270, child := 1071, matrix := ![14,0,13,15,0,15,1,6,7], witnesses := [{ source := 0, target := 176, scalar := 13 },{ source := 1, target := 0, scalar := 6 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 17, scalar := 3 },{ source := 52, target := 70, scalar := 10 },{ source := 74, target := 34, scalar := 1 },{ source := 231, target := 94, scalar := 6 },{ source := 270, target := 1, scalar := 8 }] }
theorem rowR7_0244_001_3_valid : (rowR7_0244_001_3).ValidFor level8 {0,1,17,34,52,74,231} := by decide

noncomputable def rowR7_0244_001_4 : ExtensionRow := { move := 271, child := 378, matrix := ![8,0,8,3,0,6,11,2,9], witnesses := [{ source := 0, target := 95, scalar := 8 },{ source := 1, target := 0, scalar := 2 },{ source := 17, target := 52, scalar := 8 },{ source := 34, target := 1, scalar := 5 },{ source := 52, target := 141, scalar := 3 },{ source := 74, target := 17, scalar := 12 },{ source := 231, target := 69, scalar := 13 },{ source := 271, target := 34, scalar := 1 }] }
theorem rowR7_0244_001_4_valid : (rowR7_0244_001_4).ValidFor level8 {0,1,17,34,52,74,231} := by decide

noncomputable def rowsR7_0244_001 : List ExtensionRow := [rowR7_0244_001_0,rowR7_0244_001_1,rowR7_0244_001_2,rowR7_0244_001_3,rowR7_0244_001_4]

theorem rowsR7_0244_001_valid : RowListValid level8 {0,1,17,34,52,74,231} rowsR7_0244_001 := by
  intro r hr
  simp only [rowsR7_0244_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl
  · exact rowR7_0244_001_0_valid
  · exact rowR7_0244_001_1_valid
  · exact rowR7_0244_001_2_valid
  · exact rowR7_0244_001_3_valid
  · exact rowR7_0244_001_4_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
