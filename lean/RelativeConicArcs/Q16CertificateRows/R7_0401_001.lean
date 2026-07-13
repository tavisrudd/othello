import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0401_001_0 : ExtensionRow := { move := 269, child := 2519, matrix := ![0,1,12,4,1,2,0,1,15], witnesses := [{ source := 0, target := 141, scalar := 12 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 4 },{ source := 34, target := 270, scalar := 13 },{ source := 52, target := 17, scalar := 5 },{ source := 94, target := 75, scalar := 7 },{ source := 251, target := 52, scalar := 15 },{ source := 269, target := 0, scalar := 7 }] }
theorem rowR7_0401_001_0_valid : (rowR7_0401_001_0).ValidFor level8 {0,1,17,34,52,94,251} := by decide

noncomputable def rowR7_0401_001_1 : ExtensionRow := { move := 271, child := 326, matrix := ![0,0,1,0,1,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 271, scalar := 3 },{ source := 94, target := 69, scalar := 13 },{ source := 251, target := 93, scalar := 10 },{ source := 271, target := 52, scalar := 14 }] }
theorem rowR7_0401_001_1_valid : (rowR7_0401_001_1).ValidFor level8 {0,1,17,34,52,94,251} := by decide

noncomputable def rowsR7_0401_001 : List ExtensionRow := [rowR7_0401_001_0,rowR7_0401_001_1]

theorem rowsR7_0401_001_valid : RowListValid level8 {0,1,17,34,52,94,251} rowsR7_0401_001 := by
  intro r hr
  simp only [rowsR7_0401_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl
  · exact rowR7_0401_001_0_valid
  · exact rowR7_0401_001_1_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
