import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0290_001_0 : ExtensionRow := { move := 264, child := 2169, matrix := ![1,4,5,7,12,4,14,15,1], witnesses := [{ source := 0, target := 188, scalar := 5 },{ source := 1, target := 72, scalar := 4 },{ source := 17, target := 143, scalar := 1 },{ source := 34, target := 1, scalar := 15 },{ source := 52, target := 17, scalar := 6 },{ source := 78, target := 34, scalar := 1 },{ source := 103, target := 52, scalar := 11 },{ source := 264, target := 0, scalar := 3 }] }
theorem rowR7_0290_001_0_valid : (rowR7_0290_001_0).ValidFor level8 {0,1,17,34,52,78,103} := by decide

noncomputable def rowR7_0290_001_1 : ExtensionRow := { move := 268, child := 54, matrix := ![0,13,13,11,4,15,0,9,6], witnesses := [{ source := 0, target := 172, scalar := 13 },{ source := 1, target := 67, scalar := 13 },{ source := 17, target := 1, scalar := 11 },{ source := 34, target := 0, scalar := 15 },{ source := 52, target := 91, scalar := 13 },{ source := 78, target := 17, scalar := 10 },{ source := 103, target := 52, scalar := 4 },{ source := 268, target := 34, scalar := 1 }] }
theorem rowR7_0290_001_1_valid : (rowR7_0290_001_1).ValidFor level8 {0,1,17,34,52,78,103} := by decide

noncomputable def rowR7_0290_001_2 : ExtensionRow := { move := 271, child := 1770, matrix := ![4,9,13,9,0,9,13,0,4], witnesses := [{ source := 0, target := 52, scalar := 13 },{ source := 1, target := 17, scalar := 9 },{ source := 17, target := 271, scalar := 4 },{ source := 34, target := 0, scalar := 9 },{ source := 52, target := 34, scalar := 1 },{ source := 78, target := 71, scalar := 2 },{ source := 103, target := 168, scalar := 7 },{ source := 271, target := 1, scalar := 14 }] }
theorem rowR7_0290_001_2_valid : (rowR7_0290_001_2).ValidFor level8 {0,1,17,34,52,78,103} := by decide

noncomputable def rowsR7_0290_001 : List ExtensionRow := [rowR7_0290_001_0,rowR7_0290_001_1,rowR7_0290_001_2]

theorem rowsR7_0290_001_valid : RowListValid level8 {0,1,17,34,52,78,103} rowsR7_0290_001 := by
  intro r hr
  simp only [rowsR7_0290_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl
  · exact rowR7_0290_001_0_valid
  · exact rowR7_0290_001_1_valid
  · exact rowR7_0290_001_2_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
