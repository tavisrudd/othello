import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0332_001_0 : ExtensionRow := { move := 266, child := 1309, matrix := ![0,0,2,0,14,8,11,0,7], witnesses := [{ source := 0, target := 91, scalar := 2 },{ source := 1, target := 1, scalar := 14 },{ source := 17, target := 0, scalar := 11 },{ source := 34, target := 71, scalar := 2 },{ source := 52, target := 271, scalar := 6 },{ source := 80, target := 17, scalar := 13 },{ source := 92, target := 52, scalar := 5 },{ source := 266, target := 34, scalar := 1 }] }
theorem rowR7_0332_001_0_valid : (rowR7_0332_001_0).ValidFor level8 {0,1,17,34,52,80,92} := by decide

noncomputable def rowR7_0332_001_1 : ExtensionRow := { move := 267, child := 274, matrix := ![9,15,7,8,9,0,2,3,0], witnesses := [{ source := 0, target := 17, scalar := 7 },{ source := 1, target := 92, scalar := 15 },{ source := 17, target := 69, scalar := 9 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 13 },{ source := 80, target := 0, scalar := 7 },{ source := 92, target := 203, scalar := 4 },{ source := 267, target := 1, scalar := 6 }] }
theorem rowR7_0332_001_1_valid : (rowR7_0332_001_1).ValidFor level8 {0,1,17,34,52,80,92} := by decide

noncomputable def rowR7_0332_001_2 : ExtensionRow := { move := 269, child := 2112, matrix := ![0,5,8,0,10,2,6,15,6], witnesses := [{ source := 0, target := 229, scalar := 8 },{ source := 1, target := 52, scalar := 5 },{ source := 17, target := 0, scalar := 6 },{ source := 34, target := 122, scalar := 13 },{ source := 52, target := 34, scalar := 1 },{ source := 80, target := 17, scalar := 14 },{ source := 92, target := 1, scalar := 11 },{ source := 269, target := 72, scalar := 12 }] }
theorem rowR7_0332_001_2_valid : (rowR7_0332_001_2).ValidFor level8 {0,1,17,34,52,80,92} := by decide

noncomputable def rowsR7_0332_001 : List ExtensionRow := [rowR7_0332_001_0,rowR7_0332_001_1,rowR7_0332_001_2]

theorem rowsR7_0332_001_valid : RowListValid level8 {0,1,17,34,52,80,92} rowsR7_0332_001 := by
  intro r hr
  simp only [rowsR7_0332_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl
  · exact rowR7_0332_001_0_valid
  · exact rowR7_0332_001_1_valid
  · exact rowR7_0332_001_2_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
