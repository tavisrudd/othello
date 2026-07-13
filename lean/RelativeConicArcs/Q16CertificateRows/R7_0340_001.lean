import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0340_001_0 : ExtensionRow := { move := 259, child := 912, matrix := ![13,1,1,0,2,1,0,3,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 52, scalar := 1 },{ source := 17, target := 17, scalar := 13 },{ source := 34, target := 217, scalar := 13 },{ source := 52, target := 69, scalar := 12 },{ source := 80, target := 171, scalar := 1 },{ source := 184, target := 0, scalar := 10 },{ source := 259, target := 1, scalar := 15 }] }
theorem rowR7_0340_001_0_valid : (rowR7_0340_001_0).ValidFor level8 {0,1,17,34,52,80,184} := by decide

noncomputable def rowR7_0340_001_1 : ExtensionRow := { move := 262, child := 2193, matrix := ![9,0,7,1,0,0,8,4,0], witnesses := [{ source := 0, target := 17, scalar := 7 },{ source := 1, target := 0, scalar := 4 },{ source := 17, target := 52, scalar := 9 },{ source := 34, target := 72, scalar := 14 },{ source := 52, target := 1, scalar := 1 },{ source := 80, target := 163, scalar := 2 },{ source := 184, target := 150, scalar := 15 },{ source := 262, target := 34, scalar := 1 }] }
theorem rowR7_0340_001_1_valid : (rowR7_0340_001_1).ValidFor level8 {0,1,17,34,52,80,184} := by decide

noncomputable def rowR7_0340_001_2 : ExtensionRow := { move := 266, child := 2188, matrix := ![8,8,1,10,11,1,12,13,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 72, scalar := 8 },{ source := 17, target := 217, scalar := 8 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 149, scalar := 8 },{ source := 80, target := 52, scalar := 12 },{ source := 184, target := 1, scalar := 15 },{ source := 266, target := 0, scalar := 2 }] }
theorem rowR7_0340_001_2_valid : (rowR7_0340_001_2).ValidFor level8 {0,1,17,34,52,80,184} := by decide

noncomputable def rowR7_0340_001_3 : ExtensionRow := { move := 267, child := 268, matrix := ![9,15,7,8,9,0,2,3,0], witnesses := [{ source := 0, target := 17, scalar := 7 },{ source := 1, target := 92, scalar := 15 },{ source := 17, target := 69, scalar := 9 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 13 },{ source := 80, target := 0, scalar := 7 },{ source := 184, target := 182, scalar := 3 },{ source := 267, target := 1, scalar := 6 }] }
theorem rowR7_0340_001_3_valid : (rowR7_0340_001_3).ValidFor level8 {0,1,17,34,52,80,184} := by decide

noncomputable def rowR7_0340_001_4 : ExtensionRow := { move := 271, child := 12, matrix := ![0,3,6,7,11,12,0,10,10], witnesses := [{ source := 0, target := 52, scalar := 6 },{ source := 1, target := 151, scalar := 3 },{ source := 17, target := 1, scalar := 7 },{ source := 34, target := 17, scalar := 5 },{ source := 52, target := 89, scalar := 12 },{ source := 80, target := 34, scalar := 1 },{ source := 184, target := 67, scalar := 12 },{ source := 271, target := 0, scalar := 10 }] }
theorem rowR7_0340_001_4_valid : (rowR7_0340_001_4).ValidFor level8 {0,1,17,34,52,80,184} := by decide

noncomputable def rowsR7_0340_001 : List ExtensionRow := [rowR7_0340_001_0,rowR7_0340_001_1,rowR7_0340_001_2,rowR7_0340_001_3,rowR7_0340_001_4]

theorem rowsR7_0340_001_valid : RowListValid level8 {0,1,17,34,52,80,184} rowsR7_0340_001 := by
  intro r hr
  simp only [rowsR7_0340_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl
  · exact rowR7_0340_001_0_valid
  · exact rowR7_0340_001_1_valid
  · exact rowR7_0340_001_2_valid
  · exact rowR7_0340_001_3_valid
  · exact rowR7_0340_001_4_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
