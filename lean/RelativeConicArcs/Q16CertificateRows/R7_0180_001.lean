import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0180_001_0 : ExtensionRow := { move := 270, child := 1580, matrix := ![13,0,8,7,11,3,6,0,11], witnesses := [{ source := 0, target := 52, scalar := 8 },{ source := 1, target := 1, scalar := 11 },{ source := 17, target := 268, scalar := 13 },{ source := 34, target := 71, scalar := 5 },{ source := 52, target := 126, scalar := 6 },{ source := 72, target := 0, scalar := 2 },{ source := 217, target := 34, scalar := 1 },{ source := 270, target := 17, scalar := 15 }] }
theorem rowR7_0180_001_0_valid : (rowR7_0180_001_0).ValidFor level8 {0,1,17,34,52,72,217} := by decide

noncomputable def rowsR7_0180_001 : List ExtensionRow := [rowR7_0180_001_0]

theorem rowsR7_0180_001_valid : RowListValid level8 {0,1,17,34,52,72,217} rowsR7_0180_001 := by
  intro r hr
  simp only [rowsR7_0180_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0180_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
