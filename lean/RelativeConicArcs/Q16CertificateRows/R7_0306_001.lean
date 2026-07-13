import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0306_001_0 : ExtensionRow := { move := 265, child := 1221, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 78, target := 133, scalar := 14 },{ source := 182, target := 127, scalar := 15 },{ source := 265, target := 70, scalar := 7 }] }
theorem rowR7_0306_001_0_valid : (rowR7_0306_001_0).ValidFor level8 {0,1,17,34,52,78,182} := by decide

noncomputable def rowR7_0306_001_1 : ExtensionRow := { move := 268, child := 2260, matrix := ![2,3,0,4,5,0,6,9,14], witnesses := [{ source := 0, target := 0, scalar := 14 },{ source := 1, target := 72, scalar := 3 },{ source := 17, target := 52, scalar := 2 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 185, scalar := 4 },{ source := 78, target := 268, scalar := 7 },{ source := 182, target := 17, scalar := 15 },{ source := 268, target := 1, scalar := 2 }] }
theorem rowR7_0306_001_1_valid : (rowR7_0306_001_1).ValidFor level8 {0,1,17,34,52,78,182} := by decide

noncomputable def rowsR7_0306_001 : List ExtensionRow := [rowR7_0306_001_0,rowR7_0306_001_1]

theorem rowsR7_0306_001_valid : RowListValid level8 {0,1,17,34,52,78,182} rowsR7_0306_001 := by
  intro r hr
  simp only [rowsR7_0306_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl
  · exact rowR7_0306_001_0_valid
  · exact rowR7_0306_001_1_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
