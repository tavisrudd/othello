import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0154_001_0 : ExtensionRow := { move := 263, child := 1010, matrix := ![3,6,5,12,0,4,8,0,8], witnesses := [{ source := 0, target := 184, scalar := 5 },{ source := 1, target := 17, scalar := 6 },{ source := 17, target := 90, scalar := 3 },{ source := 34, target := 1, scalar := 8 },{ source := 52, target := 0, scalar := 3 },{ source := 72, target := 70, scalar := 1 },{ source := 143, target := 34, scalar := 1 },{ source := 263, target := 52, scalar := 10 }] }
theorem rowR7_0154_001_0_valid : (rowR7_0154_001_0).ValidFor level8 {0,1,17,34,52,72,143} := by decide

noncomputable def rowR7_0154_001_1 : ExtensionRow := { move := 267, child := 1590, matrix := ![10,11,1,5,15,1,2,3,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 128, scalar := 11 },{ source := 17, target := 172, scalar := 10 },{ source := 34, target := 1, scalar := 11 },{ source := 52, target := 52, scalar := 12 },{ source := 72, target := 17, scalar := 3 },{ source := 143, target := 0, scalar := 5 },{ source := 267, target := 71, scalar := 3 }] }
theorem rowR7_0154_001_1_valid : (rowR7_0154_001_1).ValidFor level8 {0,1,17,34,52,72,143} := by decide

noncomputable def rowR7_0154_001_2 : ExtensionRow := { move := 269, child := 2175, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 72, target := 72, scalar := 1 },{ source := 143, target := 143, scalar := 1 },{ source := 269, target := 269, scalar := 1 }] }
theorem rowR7_0154_001_2_valid : (rowR7_0154_001_2).ValidFor level8 {0,1,17,34,52,72,143} := by decide

noncomputable def rowsR7_0154_001 : List ExtensionRow := [rowR7_0154_001_0,rowR7_0154_001_1,rowR7_0154_001_2]

theorem rowsR7_0154_001_valid : RowListValid level8 {0,1,17,34,52,72,143} rowsR7_0154_001 := by
  intro r hr
  simp only [rowsR7_0154_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl
  · exact rowR7_0154_001_0_valid
  · exact rowR7_0154_001_1_valid
  · exact rowR7_0154_001_2_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
