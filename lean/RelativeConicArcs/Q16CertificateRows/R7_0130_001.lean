import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0130_001_0 : ExtensionRow := { move := 271, child := 771, matrix := ![4,9,13,15,1,0,8,8,0], witnesses := [{ source := 0, target := 17, scalar := 13 },{ source := 1, target := 52, scalar := 9 },{ source := 17, target := 131, scalar := 4 },{ source := 34, target := 1, scalar := 14 },{ source := 52, target := 236, scalar := 1 },{ source := 71, target := 69, scalar := 4 },{ source := 249, target := 34, scalar := 1 },{ source := 271, target := 0, scalar := 9 }] }
theorem rowR7_0130_001_0_valid : (rowR7_0130_001_0).ValidFor level8 {0,1,17,34,52,71,249} := by decide

noncomputable def rowsR7_0130_001 : List ExtensionRow := [rowR7_0130_001_0]

theorem rowsR7_0130_001_valid : RowListValid level8 {0,1,17,34,52,71,249} rowsR7_0130_001 := by
  intro r hr
  simp only [rowsR7_0130_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0130_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
