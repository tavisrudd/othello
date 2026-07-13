import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0368_001_0 : ExtensionRow := { move := 271, child := 773, matrix := ![0,15,14,9,0,11,0,0,3], witnesses := [{ source := 0, target := 246, scalar := 14 },{ source := 1, target := 17, scalar := 15 },{ source := 17, target := 1, scalar := 9 },{ source := 34, target := 52, scalar := 1 },{ source := 52, target := 69, scalar := 12 },{ source := 91, target := 131, scalar := 15 },{ source := 220, target := 0, scalar := 14 },{ source := 271, target := 34, scalar := 1 }] }
theorem rowR7_0368_001_0_valid : (rowR7_0368_001_0).ValidFor level8 {0,1,17,34,52,91,220} := by decide

noncomputable def rowsR7_0368_001 : List ExtensionRow := [rowR7_0368_001_0]

theorem rowsR7_0368_001_valid : RowListValid level8 {0,1,17,34,52,91,220} rowsR7_0368_001 := by
  intro r hr
  simp only [rowsR7_0368_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0368_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
