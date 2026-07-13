import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0092_001_0 : ExtensionRow := { move := 271, child := 439, matrix := ![1,10,4,1,0,12,1,0,3], witnesses := [{ source := 0, target := 69, scalar := 4 },{ source := 1, target := 17, scalar := 10 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 52, scalar := 15 },{ source := 52, target := 246, scalar := 10 },{ source := 71, target := 96, scalar := 7 },{ source := 155, target := 0, scalar := 12 },{ source := 271, target := 1, scalar := 5 }] }
theorem rowR7_0092_001_0_valid : (rowR7_0092_001_0).ValidFor level8 {0,1,17,34,52,71,155} := by decide

noncomputable def rowsR7_0092_001 : List ExtensionRow := [rowR7_0092_001_0]

theorem rowsR7_0092_001_valid : RowListValid level8 {0,1,17,34,52,71,155} rowsR7_0092_001 := by
  intro r hr
  simp only [rowsR7_0092_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0092_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
