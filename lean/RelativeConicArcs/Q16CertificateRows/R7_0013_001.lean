import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0013_001_0 : ExtensionRow := { move := 267, child := 248, matrix := ![8,9,0,0,11,10,0,1,0], witnesses := [{ source := 0, target := 1, scalar := 10 },{ source := 1, target := 99, scalar := 9 },{ source := 17, target := 17, scalar := 8 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 69, scalar := 9 },{ source := 69, target := 0, scalar := 3 },{ source := 99, target := 52, scalar := 3 },{ source := 267, target := 92, scalar := 6 }] }
theorem rowR7_0013_001_0_valid : (rowR7_0013_001_0).ValidFor level8 {0,1,17,34,52,69,99} := by decide

noncomputable def rowR7_0013_001_1 : ExtensionRow := { move := 270, child := 447, matrix := ![15,0,14,0,0,1,0,12,13], witnesses := [{ source := 0, target := 69, scalar := 14 },{ source := 1, target := 0, scalar := 12 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 99, scalar := 14 },{ source := 69, target := 52, scalar := 2 },{ source := 99, target := 1, scalar := 2 },{ source := 270, target := 128, scalar := 5 }] }
theorem rowR7_0013_001_1_valid : (rowR7_0013_001_1).ValidFor level8 {0,1,17,34,52,69,99} := by decide

noncomputable def rowR7_0013_001_2 : ExtensionRow := { move := 271, child := 407, matrix := ![12,8,5,0,3,2,0,11,10], witnesses := [{ source := 0, target := 99, scalar := 5 },{ source := 1, target := 52, scalar := 8 },{ source := 17, target := 17, scalar := 12 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 0, scalar := 8 },{ source := 69, target := 1, scalar := 13 },{ source := 99, target := 69, scalar := 8 },{ source := 271, target := 96, scalar := 14 }] }
theorem rowR7_0013_001_2_valid : (rowR7_0013_001_2).ValidFor level8 {0,1,17,34,52,69,99} := by decide

noncomputable def rowsR7_0013_001 : List ExtensionRow := [rowR7_0013_001_0,rowR7_0013_001_1,rowR7_0013_001_2]

theorem rowsR7_0013_001_valid : RowListValid level8 {0,1,17,34,52,69,99} rowsR7_0013_001 := by
  intro r hr
  simp only [rowsR7_0013_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl
  · exact rowR7_0013_001_0_valid
  · exact rowR7_0013_001_1_valid
  · exact rowR7_0013_001_2_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
