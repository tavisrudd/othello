import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0280_001_0 : ExtensionRow := { move := 270, child := 2470, matrix := ![2,9,1,7,8,15,15,13,2], witnesses := [{ source := 0, target := 259, scalar := 1 },{ source := 1, target := 74, scalar := 9 },{ source := 17, target := 191, scalar := 2 },{ source := 34, target := 17, scalar := 10 },{ source := 52, target := 1, scalar := 6 },{ source := 75, target := 0, scalar := 12 },{ source := 230, target := 52, scalar := 8 },{ source := 270, target := 34, scalar := 1 }] }
theorem rowR7_0280_001_0_valid : (rowR7_0280_001_0).ValidFor level8 {0,1,17,34,52,75,230} := by decide

noncomputable def rowR7_0280_001_1 : ExtensionRow := { move := 271, child := 2195, matrix := ![0,13,9,0,9,0,9,4,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 52, scalar := 13 },{ source := 17, target := 0, scalar := 9 },{ source := 34, target := 271, scalar := 4 },{ source := 52, target := 34, scalar := 1 },{ source := 75, target := 150, scalar := 1 },{ source := 230, target := 72, scalar := 5 },{ source := 271, target := 1, scalar := 14 }] }
theorem rowR7_0280_001_1_valid : (rowR7_0280_001_1).ValidFor level8 {0,1,17,34,52,75,230} := by decide

noncomputable def rowsR7_0280_001 : List ExtensionRow := [rowR7_0280_001_0,rowR7_0280_001_1]

theorem rowsR7_0280_001_valid : RowListValid level8 {0,1,17,34,52,75,230} rowsR7_0280_001 := by
  intro r hr
  simp only [rowsR7_0280_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl
  · exact rowR7_0280_001_0_valid
  · exact rowR7_0280_001_1_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
