import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0218_001_0 : ExtensionRow := { move := 271, child := 1738, matrix := ![11,2,9,7,1,8,6,5,3], witnesses := [{ source := 0, target := 71, scalar := 9 },{ source := 1, target := 172, scalar := 2 },{ source := 17, target := 158, scalar := 11 },{ source := 34, target := 1, scalar := 14 },{ source := 52, target := 52, scalar := 7 },{ source := 74, target := 0, scalar := 1 },{ source := 110, target := 17, scalar := 14 },{ source := 271, target := 34, scalar := 1 }] }
theorem rowR7_0218_001_0_valid : (rowR7_0218_001_0).ValidFor level8 {0,1,17,34,52,74,110} := by decide

noncomputable def rowsR7_0218_001 : List ExtensionRow := [rowR7_0218_001_0]

theorem rowsR7_0218_001_valid : RowListValid level8 {0,1,17,34,52,74,110} rowsR7_0218_001 := by
  intro r hr
  simp only [rowsR7_0218_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0218_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
