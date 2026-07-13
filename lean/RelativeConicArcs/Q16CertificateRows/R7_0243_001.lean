import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0243_001_0 : ExtensionRow := { move := 267, child := 2321, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 74, target := 140, scalar := 10 },{ source := 224, target := 91, scalar := 3 },{ source := 267, target := 73, scalar := 5 }] }
theorem rowR7_0243_001_0_valid : (rowR7_0243_001_0).ValidFor level8 {0,1,17,34,52,74,224} := by decide

noncomputable def rowR7_0243_001_1 : ExtensionRow := { move := 270, child := 881, matrix := ![2,1,0,7,0,12,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 12 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 186, scalar := 2 },{ source := 34, target := 159, scalar := 3 },{ source := 52, target := 0, scalar := 1 },{ source := 74, target := 34, scalar := 1 },{ source := 224, target := 52, scalar := 14 },{ source := 270, target := 69, scalar := 13 }] }
theorem rowR7_0243_001_1_valid : (rowR7_0243_001_1).ValidFor level8 {0,1,17,34,52,74,224} := by decide

noncomputable def rowR7_0243_001_2 : ExtensionRow := { move := 271, child := 2236, matrix := ![0,0,1,1,0,1,0,1,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 271, scalar := 3 },{ source := 74, target := 72, scalar := 9 },{ source := 224, target := 172, scalar := 15 },{ source := 271, target := 52, scalar := 14 }] }
theorem rowR7_0243_001_2_valid : (rowR7_0243_001_2).ValidFor level8 {0,1,17,34,52,74,224} := by decide

noncomputable def rowsR7_0243_001 : List ExtensionRow := [rowR7_0243_001_0,rowR7_0243_001_1,rowR7_0243_001_2]

theorem rowsR7_0243_001_valid : RowListValid level8 {0,1,17,34,52,74,224} rowsR7_0243_001 := by
  intro r hr
  simp only [rowsR7_0243_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl
  · exact rowR7_0243_001_0_valid
  · exact rowR7_0243_001_1_valid
  · exact rowR7_0243_001_2_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
