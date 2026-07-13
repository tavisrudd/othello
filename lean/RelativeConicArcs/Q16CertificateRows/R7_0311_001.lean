import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0311_001_0 : ExtensionRow := { move := 267, child := 1574, matrix := ![4,0,5,8,6,15,12,0,13], witnesses := [{ source := 0, target := 71, scalar := 5 },{ source := 1, target := 1, scalar := 6 },{ source := 17, target := 52, scalar := 4 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 239, scalar := 11 },{ source := 78, target := 126, scalar := 8 },{ source := 214, target := 17, scalar := 6 },{ source := 267, target := 0, scalar := 7 }] }
theorem rowR7_0311_001_0_valid : (rowR7_0311_001_0).ValidFor level8 {0,1,17,34,52,78,214} := by decide

noncomputable def rowR7_0311_001_1 : ExtensionRow := { move := 268, child := 2518, matrix := ![9,9,0,12,10,0,13,6,11], witnesses := [{ source := 0, target := 0, scalar := 11 },{ source := 1, target := 141, scalar := 9 },{ source := 17, target := 202, scalar := 9 },{ source := 34, target := 1, scalar := 6 },{ source := 52, target := 75, scalar := 8 },{ source := 78, target := 34, scalar := 1 },{ source := 214, target := 52, scalar := 15 },{ source := 268, target := 17, scalar := 7 }] }
theorem rowR7_0311_001_1_valid : (rowR7_0311_001_1).ValidFor level8 {0,1,17,34,52,78,214} := by decide

noncomputable def rowR7_0311_001_2 : ExtensionRow := { move := 271, child := 357, matrix := ![10,1,15,0,1,13,0,1,2], witnesses := [{ source := 0, target := 52, scalar := 15 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 17, scalar := 10 },{ source := 34, target := 69, scalar := 4 },{ source := 52, target := 246, scalar := 10 },{ source := 78, target := 94, scalar := 14 },{ source := 214, target := 0, scalar := 6 },{ source := 271, target := 1, scalar := 5 }] }
theorem rowR7_0311_001_2_valid : (rowR7_0311_001_2).ValidFor level8 {0,1,17,34,52,78,214} := by decide

noncomputable def rowsR7_0311_001 : List ExtensionRow := [rowR7_0311_001_0,rowR7_0311_001_1,rowR7_0311_001_2]

theorem rowsR7_0311_001_valid : RowListValid level8 {0,1,17,34,52,78,214} rowsR7_0311_001 := by
  intro r hr
  simp only [rowsR7_0311_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl
  · exact rowR7_0311_001_0_valid
  · exact rowR7_0311_001_1_valid
  · exact rowR7_0311_001_2_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
