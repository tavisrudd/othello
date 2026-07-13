import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0129_001_0 : ExtensionRow := { move := 239, child := 707, matrix := ![1,5,4,1,15,10,1,7,6], witnesses := [{ source := 0, target := 201, scalar := 4 },{ source := 1, target := 69, scalar := 5 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 4 },{ source := 52, target := 126, scalar := 7 },{ source := 71, target := 52, scalar := 5 },{ source := 239, target := 0, scalar := 6 },{ source := 246, target := 17, scalar := 5 }] }
theorem rowR7_0129_001_0_valid : (rowR7_0129_001_0).ValidFor level8 {0,1,17,34,52,71,246} := by decide

noncomputable def rowR7_0129_001_1 : ExtensionRow := { move := 259, child := 1819, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 71, target := 246, scalar := 5 },{ source := 246, target := 71, scalar := 11 },{ source := 259, target := 174, scalar := 13 }] }
theorem rowR7_0129_001_1_valid : (rowR7_0129_001_1).ValidFor level8 {0,1,17,34,52,71,246} := by decide

noncomputable def rowR7_0129_001_2 : ExtensionRow := { move := 265, child := 622, matrix := ![1,13,9,1,0,11,1,0,14], witnesses := [{ source := 0, target := 112, scalar := 9 },{ source := 1, target := 17, scalar := 13 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 52, scalar := 5 },{ source := 52, target := 1, scalar := 15 },{ source := 71, target := 218, scalar := 6 },{ source := 246, target := 0, scalar := 2 },{ source := 265, target := 69, scalar := 2 }] }
theorem rowR7_0129_001_2_valid : (rowR7_0129_001_2).ValidFor level8 {0,1,17,34,52,71,246} := by decide

noncomputable def rowR7_0129_001_3 : ExtensionRow := { move := 268, child := 1626, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 71, target := 246, scalar := 5 },{ source := 246, target := 71, scalar := 11 },{ source := 268, target := 139, scalar := 4 }] }
theorem rowR7_0129_001_3_valid : (rowR7_0129_001_3).ValidFor level8 {0,1,17,34,52,71,246} := by decide

noncomputable def rowR7_0129_001_4 : ExtensionRow := { move := 271, child := 1960, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 71, target := 246, scalar := 5 },{ source := 246, target := 71, scalar := 11 },{ source := 271, target := 271, scalar := 1 }] }
theorem rowR7_0129_001_4_valid : (rowR7_0129_001_4).ValidFor level8 {0,1,17,34,52,71,246} := by decide

noncomputable def rowsR7_0129_001 : List ExtensionRow := [rowR7_0129_001_0,rowR7_0129_001_1,rowR7_0129_001_2,rowR7_0129_001_3,rowR7_0129_001_4]

theorem rowsR7_0129_001_valid : RowListValid level8 {0,1,17,34,52,71,246} rowsR7_0129_001 := by
  intro r hr
  simp only [rowsR7_0129_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl
  · exact rowR7_0129_001_0_valid
  · exact rowR7_0129_001_1_valid
  · exact rowR7_0129_001_2_valid
  · exact rowR7_0129_001_3_valid
  · exact rowR7_0129_001_4_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
