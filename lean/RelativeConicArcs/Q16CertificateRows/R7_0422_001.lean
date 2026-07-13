import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0422_001_0 : ExtensionRow := { move := 263, child := 2418, matrix := ![15,10,1,5,4,1,10,11,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 110, scalar := 10 },{ source := 17, target := 256, scalar := 15 },{ source := 34, target := 17, scalar := 4 },{ source := 52, target := 74, scalar := 11 },{ source := 108, target := 1, scalar := 9 },{ source := 229, target := 0, scalar := 8 },{ source := 263, target := 52, scalar := 5 }] }
theorem rowR7_0422_001_0_valid : (rowR7_0422_001_0).ValidFor level8 {0,1,17,34,52,108,229} := by decide

noncomputable def rowR7_0422_001_1 : ExtensionRow := { move := 264, child := 38, matrix := ![0,11,10,10,5,14,0,14,15], witnesses := [{ source := 0, target := 89, scalar := 10 },{ source := 1, target := 52, scalar := 11 },{ source := 17, target := 1, scalar := 10 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 264, scalar := 8 },{ source := 108, target := 17, scalar := 3 },{ source := 229, target := 67, scalar := 8 },{ source := 264, target := 0, scalar := 14 }] }
theorem rowR7_0422_001_1_valid : (rowR7_0422_001_1).ValidFor level8 {0,1,17,34,52,108,229} := by decide

noncomputable def rowR7_0422_001_2 : ExtensionRow := { move := 265, child := 698, matrix := ![0,13,7,9,5,1,0,11,5], witnesses := [{ source := 0, target := 126, scalar := 7 },{ source := 1, target := 139, scalar := 13 },{ source := 17, target := 1, scalar := 9 },{ source := 34, target := 69, scalar := 10 },{ source := 52, target := 0, scalar := 10 },{ source := 108, target := 17, scalar := 8 },{ source := 229, target := 34, scalar := 1 },{ source := 265, target := 52, scalar := 10 }] }
theorem rowR7_0422_001_2_valid : (rowR7_0422_001_2).ValidFor level8 {0,1,17,34,52,108,229} := by decide

noncomputable def rowR7_0422_001_3 : ExtensionRow := { move := 267, child := 2360, matrix := ![0,8,0,3,3,0,0,11,11], witnesses := [{ source := 0, target := 0, scalar := 11 },{ source := 1, target := 52, scalar := 8 },{ source := 17, target := 1, scalar := 3 },{ source := 34, target := 17, scalar := 8 },{ source := 52, target := 73, scalar := 3 },{ source := 108, target := 140, scalar := 14 },{ source := 229, target := 183, scalar := 2 },{ source := 267, target := 34, scalar := 1 }] }
theorem rowR7_0422_001_3_valid : (rowR7_0422_001_3).ValidFor level8 {0,1,17,34,52,108,229} := by decide

noncomputable def rowsR7_0422_001 : List ExtensionRow := [rowR7_0422_001_0,rowR7_0422_001_1,rowR7_0422_001_2,rowR7_0422_001_3]

theorem rowsR7_0422_001_valid : RowListValid level8 {0,1,17,34,52,108,229} rowsR7_0422_001 := by
  intro r hr
  simp only [rowsR7_0422_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl
  · exact rowR7_0422_001_0_valid
  · exact rowR7_0422_001_1_valid
  · exact rowR7_0422_001_2_valid
  · exact rowR7_0422_001_3_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
