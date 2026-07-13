import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0139_001_0 : ExtensionRow := { move := 268, child := 1992, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 72, target := 72, scalar := 1 },{ source := 91, target := 91, scalar := 1 },{ source := 268, target := 268, scalar := 1 }] }
theorem rowR7_0139_001_0_valid : (rowR7_0139_001_0).ValidFor level8 {0,1,17,34,52,72,91} := by decide

noncomputable def rowR7_0139_001_1 : ExtensionRow := { move := 269, child := 1993, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 72, target := 72, scalar := 1 },{ source := 91, target := 91, scalar := 1 },{ source := 269, target := 269, scalar := 1 }] }
theorem rowR7_0139_001_1_valid : (rowR7_0139_001_1).ValidFor level8 {0,1,17,34,52,72,91} := by decide

noncomputable def rowR7_0139_001_2 : ExtensionRow := { move := 271, child := 1513, matrix := ![14,7,0,8,8,8,6,5,0], witnesses := [{ source := 0, target := 1, scalar := 8 },{ source := 1, target := 110, scalar := 7 },{ source := 17, target := 203, scalar := 14 },{ source := 34, target := 71, scalar := 9 },{ source := 52, target := 0, scalar := 12 },{ source := 72, target := 52, scalar := 7 },{ source := 91, target := 34, scalar := 1 },{ source := 271, target := 17, scalar := 5 }] }
theorem rowR7_0139_001_2_valid : (rowR7_0139_001_2).ValidFor level8 {0,1,17,34,52,72,91} := by decide

noncomputable def rowsR7_0139_001 : List ExtensionRow := [rowR7_0139_001_0,rowR7_0139_001_1,rowR7_0139_001_2]

theorem rowsR7_0139_001_valid : RowListValid level8 {0,1,17,34,52,72,91} rowsR7_0139_001 := by
  intro r hr
  simp only [rowsR7_0139_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl
  · exact rowR7_0139_001_0_valid
  · exact rowR7_0139_001_1_valid
  · exact rowR7_0139_001_2_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
