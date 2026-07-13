import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0157_001_0 : ExtensionRow := { move := 267, child := 2193, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 72, target := 150, scalar := 4 },{ source := 150, target := 72, scalar := 13 },{ source := 267, target := 163, scalar := 5 }] }
theorem rowR7_0157_001_0_valid : (rowR7_0157_001_0).ValidFor level8 {0,1,17,34,52,72,150} := by decide

noncomputable def rowR7_0157_001_1 : ExtensionRow := { move := 268, child := 1808, matrix := ![1,14,7,1,11,10,1,3,2], witnesses := [{ source := 0, target := 173, scalar := 7 },{ source := 1, target := 246, scalar := 14 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 8 },{ source := 52, target := 71, scalar := 7 },{ source := 72, target := 52, scalar := 6 },{ source := 150, target := 1, scalar := 2 },{ source := 268, target := 0, scalar := 6 }] }
theorem rowR7_0157_001_1_valid : (rowR7_0157_001_1).ValidFor level8 {0,1,17,34,52,72,150} := by decide

noncomputable def rowR7_0157_001_2 : ExtensionRow := { move := 269, child := 2143, matrix := ![1,5,3,1,15,0,1,8,0], witnesses := [{ source := 0, target := 17, scalar := 3 },{ source := 1, target := 72, scalar := 5 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 52, scalar := 7 },{ source := 52, target := 135, scalar := 14 },{ source := 72, target := 186, scalar := 7 },{ source := 150, target := 0, scalar := 13 },{ source := 269, target := 1, scalar := 11 }] }
theorem rowR7_0157_001_2_valid : (rowR7_0157_001_2).ValidFor level8 {0,1,17,34,52,72,150} := by decide

noncomputable def rowR7_0157_001_3 : ExtensionRow := { move := 270, child := 106, matrix := ![4,11,14,3,5,7,7,14,8], witnesses := [{ source := 0, target := 172, scalar := 14 },{ source := 1, target := 52, scalar := 11 },{ source := 17, target := 86, scalar := 4 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 0, scalar := 3 },{ source := 72, target := 69, scalar := 6 },{ source := 150, target := 1, scalar := 5 },{ source := 270, target := 17, scalar := 13 }] }
theorem rowR7_0157_001_3_valid : (rowR7_0157_001_3).ValidFor level8 {0,1,17,34,52,72,150} := by decide

noncomputable def rowR7_0157_001_4 : ExtensionRow := { move := 271, child := 2195, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 72, target := 150, scalar := 4 },{ source := 150, target := 72, scalar := 13 },{ source := 271, target := 271, scalar := 1 }] }
theorem rowR7_0157_001_4_valid : (rowR7_0157_001_4).ValidFor level8 {0,1,17,34,52,72,150} := by decide

noncomputable def rowsR7_0157_001 : List ExtensionRow := [rowR7_0157_001_0,rowR7_0157_001_1,rowR7_0157_001_2,rowR7_0157_001_3,rowR7_0157_001_4]

theorem rowsR7_0157_001_valid : RowListValid level8 {0,1,17,34,52,72,150} rowsR7_0157_001 := by
  intro r hr
  simp only [rowsR7_0157_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl
  · exact rowR7_0157_001_0_valid
  · exact rowR7_0157_001_1_valid
  · exact rowR7_0157_001_2_valid
  · exact rowR7_0157_001_3_valid
  · exact rowR7_0157_001_4_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
