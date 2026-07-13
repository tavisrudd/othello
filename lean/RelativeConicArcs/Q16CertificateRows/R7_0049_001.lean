import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0049_001_0 : ExtensionRow := { move := 268, child := 946, matrix := ![1,15,4,1,13,12,1,2,3], witnesses := [{ source := 0, target := 69, scalar := 4 },{ source := 1, target := 52, scalar := 15 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 10 },{ source := 52, target := 1, scalar := 15 },{ source := 69, target := 0, scalar := 11 },{ source := 240, target := 240, scalar := 15 },{ source := 268, target := 195, scalar := 1 }] }
theorem rowR7_0049_001_0_valid : (rowR7_0049_001_0).ValidFor level8 {0,1,17,34,52,69,240} := by decide

noncomputable def rowR7_0049_001_1 : ExtensionRow := { move := 269, child := 884, matrix := ![1,15,4,1,13,12,1,2,3], witnesses := [{ source := 0, target := 69, scalar := 4 },{ source := 1, target := 52, scalar := 15 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 10 },{ source := 52, target := 1, scalar := 15 },{ source := 69, target := 0, scalar := 11 },{ source := 240, target := 240, scalar := 15 },{ source := 269, target := 159, scalar := 14 }] }
theorem rowR7_0049_001_1_valid : (rowR7_0049_001_1).ValidFor level8 {0,1,17,34,52,69,240} := by decide

noncomputable def rowR7_0049_001_2 : ExtensionRow := { move := 270, child := 913, matrix := ![1,15,4,1,13,12,1,2,3], witnesses := [{ source := 0, target := 69, scalar := 4 },{ source := 1, target := 52, scalar := 15 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 10 },{ source := 52, target := 1, scalar := 15 },{ source := 69, target := 0, scalar := 11 },{ source := 240, target := 240, scalar := 15 },{ source := 270, target := 171, scalar := 10 }] }
theorem rowR7_0049_001_2_valid : (rowR7_0049_001_2).ValidFor level8 {0,1,17,34,52,69,240} := by decide

noncomputable def rowsR7_0049_001 : List ExtensionRow := [rowR7_0049_001_0,rowR7_0049_001_1,rowR7_0049_001_2]

theorem rowsR7_0049_001_valid : RowListValid level8 {0,1,17,34,52,69,240} rowsR7_0049_001 := by
  intro r hr
  simp only [rowsR7_0049_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl
  · exact rowR7_0049_001_0_valid
  · exact rowR7_0049_001_1_valid
  · exact rowR7_0049_001_2_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
