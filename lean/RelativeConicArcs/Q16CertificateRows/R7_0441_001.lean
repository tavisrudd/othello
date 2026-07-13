import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0441_001_0 : ExtensionRow := { move := 262, child := 378, matrix := ![13,1,5,1,1,8,10,1,9], witnesses := [{ source := 0, target := 141, scalar := 5 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 95, scalar := 13 },{ source := 34, target := 69, scalar := 9 },{ source := 52, target := 1, scalar := 8 },{ source := 124, target := 17, scalar := 10 },{ source := 231, target := 52, scalar := 13 },{ source := 262, target := 0, scalar := 14 }] }
theorem rowR7_0441_001_0_valid : (rowR7_0441_001_0).ValidFor level8 {0,1,17,34,52,124,231} := by decide

noncomputable def rowR7_0441_001_1 : ExtensionRow := { move := 264, child := 1906, matrix := ![11,0,1,0,0,1,0,4,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 0, scalar := 4 },{ source := 17, target := 17, scalar := 11 },{ source := 34, target := 218, scalar := 10 },{ source := 52, target := 52, scalar := 8 },{ source := 124, target := 1, scalar := 11 },{ source := 231, target := 208, scalar := 13 },{ source := 264, target := 71, scalar := 12 }] }
theorem rowR7_0441_001_1_valid : (rowR7_0441_001_1).ValidFor level8 {0,1,17,34,52,124,231} := by decide

noncomputable def rowR7_0441_001_2 : ExtensionRow := { move := 265, child := 105, matrix := ![1,0,5,1,9,10,1,0,15], witnesses := [{ source := 0, target := 52, scalar := 5 },{ source := 1, target := 1, scalar := 9 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 171, scalar := 4 },{ source := 52, target := 86, scalar := 14 },{ source := 124, target := 0, scalar := 2 },{ source := 231, target := 69, scalar := 12 },{ source := 265, target := 17, scalar := 15 }] }
theorem rowR7_0441_001_2_valid : (rowR7_0441_001_2).ValidFor level8 {0,1,17,34,52,124,231} := by decide

noncomputable def rowR7_0441_001_3 : ExtensionRow := { move := 269, child := 2097, matrix := ![0,6,13,11,0,4,0,0,5], witnesses := [{ source := 0, target := 72, scalar := 13 },{ source := 1, target := 17, scalar := 6 },{ source := 17, target := 1, scalar := 11 },{ source := 34, target := 115, scalar := 11 },{ source := 52, target := 203, scalar := 8 },{ source := 124, target := 34, scalar := 1 },{ source := 231, target := 0, scalar := 13 },{ source := 269, target := 52, scalar := 7 }] }
theorem rowR7_0441_001_3_valid : (rowR7_0441_001_3).ValidFor level8 {0,1,17,34,52,124,231} := by decide

noncomputable def rowR7_0441_001_4 : ExtensionRow := { move := 271, child := 378, matrix := ![1,1,1,7,4,1,12,14,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 95, scalar := 1 },{ source := 17, target := 141, scalar := 1 },{ source := 34, target := 52, scalar := 1 },{ source := 52, target := 1, scalar := 12 },{ source := 124, target := 69, scalar := 12 },{ source := 231, target := 17, scalar := 10 },{ source := 271, target := 0, scalar := 7 }] }
theorem rowR7_0441_001_4_valid : (rowR7_0441_001_4).ValidFor level8 {0,1,17,34,52,124,231} := by decide

noncomputable def rowsR7_0441_001 : List ExtensionRow := [rowR7_0441_001_0,rowR7_0441_001_1,rowR7_0441_001_2,rowR7_0441_001_3,rowR7_0441_001_4]

theorem rowsR7_0441_001_valid : RowListValid level8 {0,1,17,34,52,124,231} rowsR7_0441_001 := by
  intro r hr
  simp only [rowsR7_0441_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl
  · exact rowR7_0441_001_0_valid
  · exact rowR7_0441_001_1_valid
  · exact rowR7_0441_001_2_valid
  · exact rowR7_0441_001_3_valid
  · exact rowR7_0441_001_4_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
