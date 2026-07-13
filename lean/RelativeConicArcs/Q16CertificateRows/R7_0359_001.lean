import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0359_001_0 : ExtensionRow := { move := 268, child := 1069, matrix := ![0,0,12,5,0,5,0,3,3], witnesses := [{ source := 0, target := 94, scalar := 12 },{ source := 1, target := 0, scalar := 3 },{ source := 17, target := 1, scalar := 5 },{ source := 34, target := 17, scalar := 12 },{ source := 52, target := 171, scalar := 7 },{ source := 91, target := 34, scalar := 1 },{ source := 144, target := 52, scalar := 8 },{ source := 268, target := 70, scalar := 13 }] }
theorem rowR7_0359_001_0_valid : (rowR7_0359_001_0).ValidFor level8 {0,1,17,34,52,91,144} := by decide

noncomputable def rowR7_0359_001_1 : ExtensionRow := { move := 269, child := 2412, matrix := ![0,0,8,4,0,14,0,8,10], witnesses := [{ source := 0, target := 109, scalar := 8 },{ source := 1, target := 0, scalar := 8 },{ source := 17, target := 1, scalar := 4 },{ source := 34, target := 222, scalar := 8 },{ source := 52, target := 52, scalar := 11 },{ source := 91, target := 74, scalar := 15 },{ source := 144, target := 34, scalar := 1 },{ source := 269, target := 17, scalar := 10 }] }
theorem rowR7_0359_001_1_valid : (rowR7_0359_001_1).ValidFor level8 {0,1,17,34,52,91,144} := by decide

noncomputable def rowR7_0359_001_2 : ExtensionRow := { move := 271, child := 872, matrix := ![1,5,4,1,3,12,1,2,3], witnesses := [{ source := 0, target := 69, scalar := 4 },{ source := 1, target := 246, scalar := 5 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 14 },{ source := 52, target := 17, scalar := 7 },{ source := 91, target := 154, scalar := 8 },{ source := 144, target := 0, scalar := 13 },{ source := 271, target := 52, scalar := 10 }] }
theorem rowR7_0359_001_2_valid : (rowR7_0359_001_2).ValidFor level8 {0,1,17,34,52,91,144} := by decide

noncomputable def rowsR7_0359_001 : List ExtensionRow := [rowR7_0359_001_0,rowR7_0359_001_1,rowR7_0359_001_2]

theorem rowsR7_0359_001_valid : RowListValid level8 {0,1,17,34,52,91,144} rowsR7_0359_001 := by
  intro r hr
  simp only [rowsR7_0359_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl
  · exact rowR7_0359_001_0_valid
  · exact rowR7_0359_001_1_valid
  · exact rowR7_0359_001_2_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
