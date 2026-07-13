import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0106_001_0 : ExtensionRow := { move := 268, child := 1550, matrix := ![14,0,11,1,0,0,2,1,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 71, scalar := 14 },{ source := 34, target := 207, scalar := 5 },{ source := 52, target := 1, scalar := 1 },{ source := 71, target := 34, scalar := 1 },{ source := 185, target := 52, scalar := 9 },{ source := 268, target := 121, scalar := 7 }] }
theorem rowR7_0106_001_0_valid : (rowR7_0106_001_0).ValidFor level8 {0,1,17,34,52,71,185} := by decide

noncomputable def rowsR7_0106_001 : List ExtensionRow := [rowR7_0106_001_0]

theorem rowsR7_0106_001_valid : RowListValid level8 {0,1,17,34,52,71,185} rowsR7_0106_001 := by
  intro r hr
  simp only [rowsR7_0106_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0106_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
