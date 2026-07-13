import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0254_001_0 : ExtensionRow := { move := 268, child := 2421, matrix := ![6,0,7,8,0,9,9,2,10], witnesses := [{ source := 0, target := 74, scalar := 7 },{ source := 1, target := 0, scalar := 2 },{ source := 17, target := 235, scalar := 6 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 17, scalar := 15 },{ source := 75, target := 117, scalar := 5 },{ source := 104, target := 1, scalar := 2 },{ source := 268, target := 52, scalar := 2 }] }
theorem rowR7_0254_001_0_valid : (rowR7_0254_001_0).ValidFor level8 {0,1,17,34,52,75,104} := by decide

noncomputable def rowR7_0254_001_1 : ExtensionRow := { move := 270, child := 1084, matrix := ![1,8,0,1,11,8,1,14,0], witnesses := [{ source := 0, target := 1, scalar := 8 },{ source := 1, target := 70, scalar := 8 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 94, scalar := 9 },{ source := 52, target := 248, scalar := 2 },{ source := 75, target := 17, scalar := 10 },{ source := 104, target := 52, scalar := 15 },{ source := 270, target := 0, scalar := 4 }] }
theorem rowR7_0254_001_1_valid : (rowR7_0254_001_1).ValidFor level8 {0,1,17,34,52,75,104} := by decide

noncomputable def rowR7_0254_001_2 : ExtensionRow := { move := 271, child := 1123, matrix := ![1,1,11,3,1,0,5,1,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 70, scalar := 1 },{ source := 34, target := 184, scalar := 11 },{ source := 52, target := 96, scalar := 13 },{ source := 75, target := 0, scalar := 6 },{ source := 104, target := 1, scalar := 6 },{ source := 271, target := 52, scalar := 6 }] }
theorem rowR7_0254_001_2_valid : (rowR7_0254_001_2).ValidFor level8 {0,1,17,34,52,75,104} := by decide

noncomputable def rowsR7_0254_001 : List ExtensionRow := [rowR7_0254_001_0,rowR7_0254_001_1,rowR7_0254_001_2]

theorem rowsR7_0254_001_valid : RowListValid level8 {0,1,17,34,52,75,104} rowsR7_0254_001 := by
  intro r hr
  simp only [rowsR7_0254_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl
  · exact rowR7_0254_001_0_valid
  · exact rowR7_0254_001_1_valid
  · exact rowR7_0254_001_2_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
