import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0175_001_0 : ExtensionRow := { move := 270, child := 576, matrix := ![15,0,13,2,0,12,9,3,14], witnesses := [{ source := 0, target := 110, scalar := 13 },{ source := 1, target := 0, scalar := 3 },{ source := 17, target := 69, scalar := 15 },{ source := 34, target := 131, scalar := 2 },{ source := 52, target := 52, scalar := 11 },{ source := 72, target := 17, scalar := 10 },{ source := 202, target := 1, scalar := 4 },{ source := 270, target := 34, scalar := 1 }] }
theorem rowR7_0175_001_0_valid : (rowR7_0175_001_0).ValidFor level8 {0,1,17,34,52,72,202} := by decide

noncomputable def rowsR7_0175_001 : List ExtensionRow := [rowR7_0175_001_0]

theorem rowsR7_0175_001_valid : RowListValid level8 {0,1,17,34,52,72,202} rowsR7_0175_001 := by
  intro r hr
  simp only [rowsR7_0175_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0175_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
