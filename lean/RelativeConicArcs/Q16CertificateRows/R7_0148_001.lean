import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0148_001_0 : ExtensionRow := { move := 268, child := 436, matrix := ![0,9,3,0,1,12,4,8,2], witnesses := [{ source := 0, target := 96, scalar := 3 },{ source := 1, target := 52, scalar := 9 },{ source := 17, target := 0, scalar := 4 },{ source := 34, target := 69, scalar := 10 },{ source := 52, target := 222, scalar := 4 },{ source := 72, target := 34, scalar := 1 },{ source := 122, target := 17, scalar := 11 },{ source := 268, target := 1, scalar := 2 }] }
theorem rowR7_0148_001_0_valid : (rowR7_0148_001_0).ValidFor level8 {0,1,17,34,52,72,122} := by decide

noncomputable def rowR7_0148_001_1 : ExtensionRow := { move := 271, child := 236, matrix := ![10,13,4,0,4,8,0,1,12], witnesses := [{ source := 0, target := 52, scalar := 4 },{ source := 1, target := 69, scalar := 13 },{ source := 17, target := 17, scalar := 10 },{ source := 34, target := 91, scalar := 3 },{ source := 52, target := 207, scalar := 15 },{ source := 72, target := 34, scalar := 1 },{ source := 122, target := 1, scalar := 15 },{ source := 271, target := 0, scalar := 11 }] }
theorem rowR7_0148_001_1_valid : (rowR7_0148_001_1).ValidFor level8 {0,1,17,34,52,72,122} := by decide

noncomputable def rowsR7_0148_001 : List ExtensionRow := [rowR7_0148_001_0,rowR7_0148_001_1]

theorem rowsR7_0148_001_valid : RowListValid level8 {0,1,17,34,52,72,122} rowsR7_0148_001 := by
  intro r hr
  simp only [rowsR7_0148_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl
  · exact rowR7_0148_001_0_valid
  · exact rowR7_0148_001_1_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
