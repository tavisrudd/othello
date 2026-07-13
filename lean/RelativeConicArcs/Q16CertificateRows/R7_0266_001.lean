import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0266_001_0 : ExtensionRow := { move := 268, child := 1640, matrix := ![1,15,4,2,0,15,3,0,10], witnesses := [{ source := 0, target := 140, scalar := 4 },{ source := 1, target := 17, scalar := 15 },{ source := 17, target := 52, scalar := 1 },{ source := 34, target := 71, scalar := 10 },{ source := 52, target := 0, scalar := 14 },{ source := 75, target := 235, scalar := 13 },{ source := 168, target := 1, scalar := 9 },{ source := 268, target := 34, scalar := 1 }] }
theorem rowR7_0266_001_0_valid : (rowR7_0266_001_0).ValidFor level8 {0,1,17,34,52,75,168} := by decide

noncomputable def rowR7_0266_001_1 : ExtensionRow := { move := 271, child := 12, matrix := ![0,3,3,0,6,12,14,5,11], witnesses := [{ source := 0, target := 89, scalar := 3 },{ source := 1, target := 52, scalar := 3 },{ source := 17, target := 0, scalar := 14 },{ source := 34, target := 1, scalar := 10 },{ source := 52, target := 151, scalar := 3 },{ source := 75, target := 67, scalar := 8 },{ source := 168, target := 34, scalar := 1 },{ source := 271, target := 17, scalar := 3 }] }
theorem rowR7_0266_001_1_valid : (rowR7_0266_001_1).ValidFor level8 {0,1,17,34,52,75,168} := by decide

noncomputable def rowsR7_0266_001 : List ExtensionRow := [rowR7_0266_001_0,rowR7_0266_001_1]

theorem rowsR7_0266_001_valid : RowListValid level8 {0,1,17,34,52,75,168} rowsR7_0266_001 := by
  intro r hr
  simp only [rowsR7_0266_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl
  · exact rowR7_0266_001_0_valid
  · exact rowR7_0266_001_1_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
