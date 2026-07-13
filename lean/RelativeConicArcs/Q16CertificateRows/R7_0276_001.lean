import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0276_001_0 : ExtensionRow := { move := 271, child := 787, matrix := ![9,9,0,12,10,0,11,3,8], witnesses := [{ source := 0, target := 0, scalar := 8 },{ source := 1, target := 135, scalar := 9 },{ source := 17, target := 198, scalar := 9 },{ source := 34, target := 1, scalar := 6 },{ source := 52, target := 69, scalar := 8 },{ source := 75, target := 34, scalar := 1 },{ source := 214, target := 52, scalar := 15 },{ source := 271, target := 17, scalar := 7 }] }
theorem rowR7_0276_001_0_valid : (rowR7_0276_001_0).ValidFor level8 {0,1,17,34,52,75,214} := by decide

noncomputable def rowsR7_0276_001 : List ExtensionRow := [rowR7_0276_001_0]

theorem rowsR7_0276_001_valid : RowListValid level8 {0,1,17,34,52,75,214} rowsR7_0276_001 := by
  intro r hr
  simp only [rowsR7_0276_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0276_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
