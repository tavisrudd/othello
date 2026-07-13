import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0354_001_0 : ExtensionRow := { move := 262, child := 192, matrix := ![9,4,0,1,0,0,8,0,7], witnesses := [{ source := 0, target := 0, scalar := 7 },{ source := 1, target := 17, scalar := 4 },{ source := 17, target := 52, scalar := 9 },{ source := 34, target := 90, scalar := 13 },{ source := 52, target := 34, scalar := 1 },{ source := 91, target := 222, scalar := 10 },{ source := 110, target := 69, scalar := 14 },{ source := 262, target := 1, scalar := 1 }] }
theorem rowR7_0354_001_0_valid : (rowR7_0354_001_0).ValidFor level8 {0,1,17,34,52,91,110} := by decide

noncomputable def rowR7_0354_001_1 : ExtensionRow := { move := 264, child := 2023, matrix := ![6,11,15,12,10,6,10,6,12], witnesses := [{ source := 0, target := 107, scalar := 15 },{ source := 1, target := 94, scalar := 11 },{ source := 17, target := 52, scalar := 6 },{ source := 34, target := 17, scalar := 2 },{ source := 52, target := 34, scalar := 1 },{ source := 91, target := 1, scalar := 11 },{ source := 110, target := 0, scalar := 4 },{ source := 264, target := 72, scalar := 14 }] }
theorem rowR7_0354_001_1_valid : (rowR7_0354_001_1).ValidFor level8 {0,1,17,34,52,91,110} := by decide

noncomputable def rowR7_0354_001_2 : ExtensionRow := { move := 266, child := 163, matrix := ![1,6,10,1,11,13,1,5,14], witnesses := [{ source := 0, target := 69, scalar := 10 },{ source := 1, target := 89, scalar := 6 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 271, scalar := 13 },{ source := 52, target := 0, scalar := 10 },{ source := 91, target := 17, scalar := 2 },{ source := 110, target := 52, scalar := 7 },{ source := 266, target := 1, scalar := 13 }] }
theorem rowR7_0354_001_2_valid : (rowR7_0354_001_2).ValidFor level8 {0,1,17,34,52,91,110} := by decide

noncomputable def rowR7_0354_001_3 : ExtensionRow := { move := 268, child := 892, matrix := ![14,12,13,6,11,15,7,7,9], witnesses := [{ source := 0, target := 163, scalar := 13 },{ source := 1, target := 52, scalar := 12 },{ source := 17, target := 186, scalar := 14 },{ source := 34, target := 69, scalar := 15 },{ source := 52, target := 34, scalar := 1 },{ source := 91, target := 0, scalar := 13 },{ source := 110, target := 17, scalar := 9 },{ source := 268, target := 1, scalar := 6 }] }
theorem rowR7_0354_001_3_valid : (rowR7_0354_001_3).ValidFor level8 {0,1,17,34,52,91,110} := by decide

noncomputable def rowR7_0354_001_4 : ExtensionRow := { move := 269, child := 1402, matrix := ![3,0,7,11,10,9,13,0,1], witnesses := [{ source := 0, target := 71, scalar := 7 },{ source := 1, target := 1, scalar := 10 },{ source := 17, target := 155, scalar := 3 },{ source := 34, target := 52, scalar := 4 },{ source := 52, target := 101, scalar := 10 },{ source := 91, target := 0, scalar := 7 },{ source := 110, target := 17, scalar := 6 },{ source := 269, target := 34, scalar := 1 }] }
theorem rowR7_0354_001_4_valid : (rowR7_0354_001_4).ValidFor level8 {0,1,17,34,52,91,110} := by decide

noncomputable def rowsR7_0354_001 : List ExtensionRow := [rowR7_0354_001_0,rowR7_0354_001_1,rowR7_0354_001_2,rowR7_0354_001_3,rowR7_0354_001_4]

theorem rowsR7_0354_001_valid : RowListValid level8 {0,1,17,34,52,91,110} rowsR7_0354_001 := by
  intro r hr
  simp only [rowsR7_0354_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl
  · exact rowR7_0354_001_0_valid
  · exact rowR7_0354_001_1_valid
  · exact rowR7_0354_001_2_valid
  · exact rowR7_0354_001_3_valid
  · exact rowR7_0354_001_4_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
