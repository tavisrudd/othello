import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0369_001_0 : ExtensionRow := { move := 259, child := 2266, matrix := ![0,11,1,0,14,2,14,4,3], witnesses := [{ source := 0, target := 52, scalar := 1 },{ source := 1, target := 72, scalar := 11 },{ source := 17, target := 0, scalar := 14 },{ source := 34, target := 263, scalar := 10 },{ source := 52, target := 186, scalar := 6 },{ source := 91, target := 1, scalar := 10 },{ source := 230, target := 17, scalar := 3 },{ source := 259, target := 34, scalar := 1 }] }
theorem rowR7_0369_001_0_valid : (rowR7_0369_001_0).ValidFor level8 {0,1,17,34,52,91,230} := by decide

noncomputable def rowR7_0369_001_1 : ExtensionRow := { move := 264, child := 906, matrix := ![10,5,15,7,15,8,13,7,7], witnesses := [{ source := 0, target := 222, scalar := 15 },{ source := 1, target := 69, scalar := 5 },{ source := 17, target := 52, scalar := 10 },{ source := 34, target := 0, scalar := 13 },{ source := 52, target := 166, scalar := 2 },{ source := 91, target := 34, scalar := 1 },{ source := 230, target := 1, scalar := 14 },{ source := 264, target := 17, scalar := 7 }] }
theorem rowR7_0369_001_1_valid : (rowR7_0369_001_1).ValidFor level8 {0,1,17,34,52,91,230} := by decide

noncomputable def rowR7_0369_001_2 : ExtensionRow := { move := 266, child := 488, matrix := ![0,15,15,0,1,13,7,5,2], witnesses := [{ source := 0, target := 52, scalar := 15 },{ source := 1, target := 159, scalar := 15 },{ source := 17, target := 0, scalar := 7 },{ source := 34, target := 1, scalar := 12 },{ source := 52, target := 104, scalar := 15 },{ source := 91, target := 69, scalar := 5 },{ source := 230, target := 34, scalar := 1 },{ source := 266, target := 17, scalar := 4 }] }
theorem rowR7_0369_001_2_valid : (rowR7_0369_001_2).ValidFor level8 {0,1,17,34,52,91,230} := by decide

noncomputable def rowR7_0369_001_3 : ExtensionRow := { move := 270, child := 2618, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 91, target := 91, scalar := 1 },{ source := 230, target := 230, scalar := 1 },{ source := 270, target := 270, scalar := 1 }] }
theorem rowR7_0369_001_3_valid : (rowR7_0369_001_3).ValidFor level8 {0,1,17,34,52,91,230} := by decide

noncomputable def rowR7_0369_001_4 : ExtensionRow := { move := 271, child := 2236, matrix := ![0,13,9,0,9,0,9,4,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 52, scalar := 13 },{ source := 17, target := 0, scalar := 9 },{ source := 34, target := 271, scalar := 4 },{ source := 52, target := 34, scalar := 1 },{ source := 91, target := 172, scalar := 4 },{ source := 230, target := 72, scalar := 5 },{ source := 271, target := 1, scalar := 14 }] }
theorem rowR7_0369_001_4_valid : (rowR7_0369_001_4).ValidFor level8 {0,1,17,34,52,91,230} := by decide

noncomputable def rowsR7_0369_001 : List ExtensionRow := [rowR7_0369_001_0,rowR7_0369_001_1,rowR7_0369_001_2,rowR7_0369_001_3,rowR7_0369_001_4]

theorem rowsR7_0369_001_valid : RowListValid level8 {0,1,17,34,52,91,230} rowsR7_0369_001 := by
  intro r hr
  simp only [rowsR7_0369_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl
  · exact rowR7_0369_001_0_valid
  · exact rowR7_0369_001_1_valid
  · exact rowR7_0369_001_2_valid
  · exact rowR7_0369_001_3_valid
  · exact rowR7_0369_001_4_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
