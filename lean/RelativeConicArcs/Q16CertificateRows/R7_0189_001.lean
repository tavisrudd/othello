import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0189_001_0 : ExtensionRow := { move := 266, child := 1283, matrix := ![0,5,4,3,14,12,0,10,11], witnesses := [{ source := 0, target := 71, scalar := 4 },{ source := 1, target := 147, scalar := 5 },{ source := 17, target := 1, scalar := 3 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 91, scalar := 6 },{ source := 72, target := 0, scalar := 9 },{ source := 251, target := 52, scalar := 13 },{ source := 266, target := 17, scalar := 4 }] }
theorem rowR7_0189_001_0_valid : (rowR7_0189_001_0).ValidFor level8 {0,1,17,34,52,72,251} := by decide

noncomputable def rowR7_0189_001_1 : ExtensionRow := { move := 269, child := 1433, matrix := ![13,1,7,9,1,9,4,1,1], witnesses := [{ source := 0, target := 71, scalar := 7 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 13 },{ source := 34, target := 104, scalar := 11 },{ source := 52, target := 169, scalar := 6 },{ source := 72, target := 17, scalar := 8 },{ source := 251, target := 1, scalar := 2 },{ source := 269, target := 0, scalar := 7 }] }
theorem rowR7_0189_001_1_valid : (rowR7_0189_001_1).ValidFor level8 {0,1,17,34,52,72,251} := by decide

noncomputable def rowR7_0189_001_2 : ExtensionRow := { move := 271, child := 648, matrix := ![0,13,13,0,4,8,8,1,9], witnesses := [{ source := 0, target := 115, scalar := 13 },{ source := 1, target := 69, scalar := 13 },{ source := 17, target := 0, scalar := 8 },{ source := 34, target := 1, scalar := 12 },{ source := 52, target := 217, scalar := 13 },{ source := 72, target := 34, scalar := 1 },{ source := 251, target := 52, scalar := 1 },{ source := 271, target := 17, scalar := 13 }] }
theorem rowR7_0189_001_2_valid : (rowR7_0189_001_2).ValidFor level8 {0,1,17,34,52,72,251} := by decide

noncomputable def rowsR7_0189_001 : List ExtensionRow := [rowR7_0189_001_0,rowR7_0189_001_1,rowR7_0189_001_2]

theorem rowsR7_0189_001_valid : RowListValid level8 {0,1,17,34,52,72,251} rowsR7_0189_001 := by
  intro r hr
  simp only [rowsR7_0189_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl
  · exact rowR7_0189_001_0_valid
  · exact rowR7_0189_001_1_valid
  · exact rowR7_0189_001_2_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
