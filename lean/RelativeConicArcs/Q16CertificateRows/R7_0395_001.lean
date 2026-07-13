import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0395_001_0 : ExtensionRow := { move := 267, child := 2366, matrix := ![14,14,0,0,1,1,0,9,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 73, scalar := 14 },{ source := 17, target := 17, scalar := 14 },{ source := 34, target := 0, scalar := 9 },{ source := 52, target := 34, scalar := 1 },{ source := 94, target := 144, scalar := 3 },{ source := 156, target := 188, scalar := 7 },{ source := 267, target := 52, scalar := 11 }] }
theorem rowR7_0395_001_0_valid : (rowR7_0395_001_0).ValidFor level8 {0,1,17,34,52,94,156} := by decide

noncomputable def rowR7_0395_001_1 : ExtensionRow := { move := 269, child := 2558, matrix := ![8,4,0,1,11,13,5,6,0], witnesses := [{ source := 0, target := 1, scalar := 13 },{ source := 1, target := 121, scalar := 4 },{ source := 17, target := 263, scalar := 8 },{ source := 34, target := 78, scalar := 12 },{ source := 52, target := 0, scalar := 9 },{ source := 94, target := 52, scalar := 11 },{ source := 156, target := 17, scalar := 14 },{ source := 269, target := 34, scalar := 1 }] }
theorem rowR7_0395_001_1_valid : (rowR7_0395_001_1).ValidFor level8 {0,1,17,34,52,94,156} := by decide

noncomputable def rowR7_0395_001_2 : ExtensionRow := { move := 271, child := 961, matrix := ![0,0,1,0,1,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 271, scalar := 3 },{ source := 94, target := 69, scalar := 13 },{ source := 156, target := 246, scalar := 11 },{ source := 271, target := 52, scalar := 14 }] }
theorem rowR7_0395_001_2_valid : (rowR7_0395_001_2).ValidFor level8 {0,1,17,34,52,94,156} := by decide

noncomputable def rowsR7_0395_001 : List ExtensionRow := [rowR7_0395_001_0,rowR7_0395_001_1,rowR7_0395_001_2]

theorem rowsR7_0395_001_valid : RowListValid level8 {0,1,17,34,52,94,156} rowsR7_0395_001 := by
  intro r hr
  simp only [rowsR7_0395_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl
  · exact rowR7_0395_001_0_valid
  · exact rowR7_0395_001_1_valid
  · exact rowR7_0395_001_2_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
