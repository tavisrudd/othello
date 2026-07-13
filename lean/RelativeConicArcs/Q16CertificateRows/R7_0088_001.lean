import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0088_001_0 : ExtensionRow := { move := 268, child := 1667, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 71, target := 71, scalar := 1 },{ source := 144, target := 144, scalar := 1 },{ source := 268, target := 268, scalar := 1 }] }
theorem rowR7_0088_001_0_valid : (rowR7_0088_001_0).ValidFor level8 {0,1,17,34,52,71,144} := by decide

noncomputable def rowR7_0088_001_1 : ExtensionRow := { move := 269, child := 1038, matrix := ![5,11,0,7,7,0,4,8,12], witnesses := [{ source := 0, target := 0, scalar := 12 },{ source := 1, target := 159, scalar := 11 },{ source := 17, target := 91, scalar := 5 },{ source := 34, target := 17, scalar := 14 },{ source := 52, target := 1, scalar := 9 },{ source := 71, target := 70, scalar := 11 },{ source := 144, target := 34, scalar := 1 },{ source := 269, target := 52, scalar := 6 }] }
theorem rowR7_0088_001_1_valid : (rowR7_0088_001_1).ValidFor level8 {0,1,17,34,52,71,144} := by decide

noncomputable def rowsR7_0088_001 : List ExtensionRow := [rowR7_0088_001_0,rowR7_0088_001_1]

theorem rowsR7_0088_001_valid : RowListValid level8 {0,1,17,34,52,71,144} rowsR7_0088_001 := by
  intro r hr
  simp only [rowsR7_0088_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl
  · exact rowR7_0088_001_0_valid
  · exact rowR7_0088_001_1_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
