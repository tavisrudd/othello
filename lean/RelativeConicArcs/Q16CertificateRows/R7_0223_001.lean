import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0223_001_0 : ExtensionRow := { move := 270, child := 1065, matrix := ![11,1,3,5,1,12,14,1,4], witnesses := [{ source := 0, target := 94, scalar := 3 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 11 },{ source := 34, target := 70, scalar := 9 },{ source := 52, target := 17, scalar := 12 },{ source := 74, target := 0, scalar := 15 },{ source := 128, target := 137, scalar := 15 },{ source := 270, target := 1, scalar := 9 }] }
theorem rowR7_0223_001_0_valid : (rowR7_0223_001_0).ValidFor level8 {0,1,17,34,52,74,128} := by decide

noncomputable def rowsR7_0223_001 : List ExtensionRow := [rowR7_0223_001_0]

theorem rowsR7_0223_001_valid : RowListValid level8 {0,1,17,34,52,74,128} rowsR7_0223_001 := by
  intro r hr
  simp only [rowsR7_0223_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0223_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
