import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0211_001_0 : ExtensionRow := { move := 264, child := 449, matrix := ![12,0,9,9,0,3,14,14,15], witnesses := [{ source := 0, target := 126, scalar := 9 },{ source := 1, target := 0, scalar := 14 },{ source := 17, target := 103, scalar := 12 },{ source := 34, target := 52, scalar := 5 },{ source := 52, target := 69, scalar := 4 },{ source := 74, target := 34, scalar := 1 },{ source := 92, target := 1, scalar := 7 },{ source := 264, target := 17, scalar := 6 }] }
theorem rowR7_0211_001_0_valid : (rowR7_0211_001_0).ValidFor level8 {0,1,17,34,52,74,92} := by decide

noncomputable def rowR7_0211_001_1 : ExtensionRow := { move := 267, child := 1446, matrix := ![1,12,6,1,3,12,1,4,10], witnesses := [{ source := 0, target := 52, scalar := 6 },{ source := 1, target := 239, scalar := 12 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 71, scalar := 11 },{ source := 52, target := 0, scalar := 4 },{ source := 74, target := 104, scalar := 5 },{ source := 92, target := 17, scalar := 11 },{ source := 267, target := 1, scalar := 2 }] }
theorem rowR7_0211_001_1_valid : (rowR7_0211_001_1).ValidFor level8 {0,1,17,34,52,74,92} := by decide

noncomputable def rowsR7_0211_001 : List ExtensionRow := [rowR7_0211_001_0,rowR7_0211_001_1]

theorem rowsR7_0211_001_valid : RowListValid level8 {0,1,17,34,52,74,92} rowsR7_0211_001 := by
  intro r hr
  simp only [rowsR7_0211_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl
  · exact rowR7_0211_001_0_valid
  · exact rowR7_0211_001_1_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
