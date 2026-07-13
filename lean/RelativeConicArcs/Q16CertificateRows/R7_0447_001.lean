import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0447_001_0 : ExtensionRow := { move := 264, child := 1296, matrix := ![14,0,2,8,0,8,4,3,7], witnesses := [{ source := 0, target := 91, scalar := 2 },{ source := 1, target := 0, scalar := 3 },{ source := 17, target := 205, scalar := 14 },{ source := 34, target := 17, scalar := 12 },{ source := 52, target := 52, scalar := 8 },{ source := 143, target := 34, scalar := 1 },{ source := 249, target := 71, scalar := 13 },{ source := 264, target := 1, scalar := 5 }] }
theorem rowR7_0447_001_0_valid : (rowR7_0447_001_0).ValidFor level8 {0,1,17,34,52,143,249} := by decide

noncomputable def rowsR7_0447_001 : List ExtensionRow := [rowR7_0447_001_0]

theorem rowsR7_0447_001_valid : RowListValid level8 {0,1,17,34,52,143,249} rowsR7_0447_001 := by
  intro r hr
  simp only [rowsR7_0447_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0447_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
