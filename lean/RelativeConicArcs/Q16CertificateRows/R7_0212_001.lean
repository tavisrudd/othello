import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0212_001_0 : ExtensionRow := { move := 264, child := 1993, matrix := ![0,1,4,7,15,8,0,12,12], witnesses := [{ source := 0, target := 52, scalar := 4 },{ source := 1, target := 269, scalar := 1 },{ source := 17, target := 1, scalar := 7 },{ source := 34, target := 17, scalar := 5 },{ source := 52, target := 72, scalar := 14 },{ source := 74, target := 34, scalar := 1 },{ source := 93, target := 91, scalar := 1 },{ source := 264, target := 0, scalar := 10 }] }
theorem rowR7_0212_001_0_valid : (rowR7_0212_001_0).ValidFor level8 {0,1,17,34,52,74,93} := by decide

noncomputable def rowR7_0212_001_1 : ExtensionRow := { move := 270, child := 1061, matrix := ![11,1,3,5,1,12,14,1,4], witnesses := [{ source := 0, target := 94, scalar := 3 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 11 },{ source := 34, target := 70, scalar := 9 },{ source := 52, target := 17, scalar := 12 },{ source := 74, target := 0, scalar := 15 },{ source := 93, target := 107, scalar := 8 },{ source := 270, target := 1, scalar := 9 }] }
theorem rowR7_0212_001_1_valid : (rowR7_0212_001_1).ValidFor level8 {0,1,17,34,52,74,93} := by decide

noncomputable def rowR7_0212_001_2 : ExtensionRow := { move := 271, child := 677, matrix := ![0,4,11,0,12,8,15,3,7], witnesses := [{ source := 0, target := 249, scalar := 11 },{ source := 1, target := 69, scalar := 4 },{ source := 17, target := 0, scalar := 15 },{ source := 34, target := 120, scalar := 15 },{ source := 52, target := 17, scalar := 6 },{ source := 74, target := 1, scalar := 3 },{ source := 93, target := 52, scalar := 14 },{ source := 271, target := 34, scalar := 1 }] }
theorem rowR7_0212_001_2_valid : (rowR7_0212_001_2).ValidFor level8 {0,1,17,34,52,74,93} := by decide

noncomputable def rowsR7_0212_001 : List ExtensionRow := [rowR7_0212_001_0,rowR7_0212_001_1,rowR7_0212_001_2]

theorem rowsR7_0212_001_valid : RowListValid level8 {0,1,17,34,52,74,93} rowsR7_0212_001 := by
  intro r hr
  simp only [rowsR7_0212_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl
  · exact rowR7_0212_001_0_valid
  · exact rowR7_0212_001_1_valid
  · exact rowR7_0212_001_2_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
