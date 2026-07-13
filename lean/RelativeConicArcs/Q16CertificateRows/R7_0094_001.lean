import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0094_001_0 : ExtensionRow := { move := 265, child := 990, matrix := ![1,13,12,1,0,4,1,0,1], witnesses := [{ source := 0, target := 251, scalar := 12 },{ source := 1, target := 17, scalar := 13 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 5 },{ source := 52, target := 52, scalar := 15 },{ source := 71, target := 89, scalar := 11 },{ source := 158, target := 0, scalar := 12 },{ source := 265, target := 70, scalar := 12 }] }
theorem rowR7_0094_001_0_valid : (rowR7_0094_001_0).ValidFor level8 {0,1,17,34,52,71,158} := by decide

noncomputable def rowR7_0094_001_1 : ExtensionRow := { move := 269, child := 1743, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 71, target := 71, scalar := 1 },{ source := 158, target := 158, scalar := 1 },{ source := 269, target := 269, scalar := 1 }] }
theorem rowR7_0094_001_1_valid : (rowR7_0094_001_1).ValidFor level8 {0,1,17,34,52,71,158} := by decide

noncomputable def rowR7_0094_001_2 : ExtensionRow := { move := 271, child := 1738, matrix := ![14,12,3,1,11,11,2,7,4], witnesses := [{ source := 0, target := 158, scalar := 3 },{ source := 1, target := 52, scalar := 12 },{ source := 17, target := 71, scalar := 14 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 1, scalar := 10 },{ source := 71, target := 17, scalar := 3 },{ source := 158, target := 0, scalar := 14 },{ source := 271, target := 172, scalar := 7 }] }
theorem rowR7_0094_001_2_valid : (rowR7_0094_001_2).ValidFor level8 {0,1,17,34,52,71,158} := by decide

noncomputable def rowsR7_0094_001 : List ExtensionRow := [rowR7_0094_001_0,rowR7_0094_001_1,rowR7_0094_001_2]

theorem rowsR7_0094_001_valid : RowListValid level8 {0,1,17,34,52,71,158} rowsR7_0094_001 := by
  intro r hr
  simp only [rowsR7_0094_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl
  · exact rowR7_0094_001_0_valid
  · exact rowR7_0094_001_1_valid
  · exact rowR7_0094_001_2_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
