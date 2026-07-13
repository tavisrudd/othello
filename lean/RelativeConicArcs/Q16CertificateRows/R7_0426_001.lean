import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0426_001_0 : ExtensionRow := { move := 271, child := 2535, matrix := ![12,13,0,8,15,6,2,3,0], witnesses := [{ source := 0, target := 1, scalar := 6 },{ source := 1, target := 173, scalar := 13 },{ source := 17, target := 264, scalar := 12 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 75, scalar := 5 },{ source := 109, target := 0, scalar := 13 },{ source := 229, target := 52, scalar := 2 },{ source := 271, target := 17, scalar := 11 }] }
theorem rowR7_0426_001_0_valid : (rowR7_0426_001_0).ValidFor level8 {0,1,17,34,52,109,229} := by decide

noncomputable def rowsR7_0426_001 : List ExtensionRow := [rowR7_0426_001_0]

theorem rowsR7_0426_001_valid : RowListValid level8 {0,1,17,34,52,109,229} rowsR7_0426_001 := by
  intro r hr
  simp only [rowsR7_0426_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0426_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
