import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0179_001_0 : ExtensionRow := { move := 266, child := 1721, matrix := ![0,14,0,0,15,10,2,1,0], witnesses := [{ source := 0, target := 1, scalar := 10 },{ source := 1, target := 52, scalar := 14 },{ source := 17, target := 0, scalar := 2 },{ source := 34, target := 262, scalar := 14 },{ source := 52, target := 17, scalar := 15 },{ source := 72, target := 34, scalar := 1 },{ source := 213, target := 155, scalar := 4 },{ source := 266, target := 71, scalar := 5 }] }
theorem rowR7_0179_001_0_valid : (rowR7_0179_001_0).ValidFor level8 {0,1,17,34,52,72,213} := by decide

noncomputable def rowR7_0179_001_1 : ExtensionRow := { move := 268, child := 2301, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 72, target := 72, scalar := 1 },{ source := 213, target := 213, scalar := 1 },{ source := 268, target := 268, scalar := 1 }] }
theorem rowR7_0179_001_1_valid : (rowR7_0179_001_1).ValidFor level8 {0,1,17,34,52,72,213} := by decide

noncomputable def rowR7_0179_001_2 : ExtensionRow := { move := 271, child := 12, matrix := ![13,7,10,0,15,15,0,13,9], witnesses := [{ source := 0, target := 151, scalar := 10 },{ source := 1, target := 89, scalar := 7 },{ source := 17, target := 17, scalar := 13 },{ source := 34, target := 0, scalar := 4 },{ source := 52, target := 52, scalar := 14 },{ source := 72, target := 67, scalar := 7 },{ source := 213, target := 34, scalar := 1 },{ source := 271, target := 1, scalar := 15 }] }
theorem rowR7_0179_001_2_valid : (rowR7_0179_001_2).ValidFor level8 {0,1,17,34,52,72,213} := by decide

noncomputable def rowsR7_0179_001 : List ExtensionRow := [rowR7_0179_001_0,rowR7_0179_001_1,rowR7_0179_001_2]

theorem rowsR7_0179_001_valid : RowListValid level8 {0,1,17,34,52,72,213} rowsR7_0179_001 := by
  intro r hr
  simp only [rowsR7_0179_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl
  · exact rowR7_0179_001_0_valid
  · exact rowR7_0179_001_1_valid
  · exact rowR7_0179_001_2_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
