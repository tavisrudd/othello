import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0237_001_0 : ExtensionRow := { move := 262, child := 565, matrix := ![11,0,5,1,0,0,2,15,0], witnesses := [{ source := 0, target := 17, scalar := 5 },{ source := 1, target := 0, scalar := 15 },{ source := 17, target := 107, scalar := 11 },{ source := 34, target := 69, scalar := 14 },{ source := 52, target := 232, scalar := 4 },{ source := 74, target := 1, scalar := 1 },{ source := 195, target := 34, scalar := 1 },{ source := 262, target := 52, scalar := 9 }] }
theorem rowR7_0237_001_0_valid : (rowR7_0237_001_0).ValidFor level8 {0,1,17,34,52,74,195} := by decide

noncomputable def rowR7_0237_001_1 : ExtensionRow := { move := 263, child := 2160, matrix := ![10,6,12,0,10,2,0,1,1], witnesses := [{ source := 0, target := 139, scalar := 12 },{ source := 1, target := 72, scalar := 6 },{ source := 17, target := 17, scalar := 10 },{ source := 34, target := 1, scalar := 8 },{ source := 52, target := 34, scalar := 1 },{ source := 74, target := 52, scalar := 6 },{ source := 195, target := 185, scalar := 14 },{ source := 263, target := 0, scalar := 9 }] }
theorem rowR7_0237_001_1_valid : (rowR7_0237_001_1).ValidFor level8 {0,1,17,34,52,74,195} := by decide

noncomputable def rowR7_0237_001_2 : ExtensionRow := { move := 264, child := 435, matrix := ![5,3,1,15,12,1,7,2,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 96, scalar := 3 },{ source := 17, target := 69, scalar := 5 },{ source := 34, target := 220, scalar := 7 },{ source := 52, target := 1, scalar := 7 },{ source := 74, target := 52, scalar := 9 },{ source := 195, target := 17, scalar := 9 },{ source := 264, target := 0, scalar := 13 }] }
theorem rowR7_0237_001_2_valid : (rowR7_0237_001_2).ValidFor level8 {0,1,17,34,52,74,195} := by decide

noncomputable def rowsR7_0237_001 : List ExtensionRow := [rowR7_0237_001_0,rowR7_0237_001_1,rowR7_0237_001_2]

theorem rowsR7_0237_001_valid : RowListValid level8 {0,1,17,34,52,74,195} rowsR7_0237_001 := by
  intro r hr
  simp only [rowsR7_0237_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl
  · exact rowR7_0237_001_0_valid
  · exact rowR7_0237_001_1_valid
  · exact rowR7_0237_001_2_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
