import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0432_001_0 : ExtensionRow := { move := 271, child := 850, matrix := ![7,7,7,13,9,4,1,15,14], witnesses := [{ source := 0, target := 195, scalar := 7 },{ source := 1, target := 69, scalar := 7 },{ source := 17, target := 151, scalar := 7 },{ source := 34, target := 17, scalar := 7 },{ source := 52, target := 0, scalar := 13 },{ source := 110, target := 52, scalar := 10 },{ source := 220, target := 34, scalar := 1 },{ source := 271, target := 1, scalar := 14 }] }
theorem rowR7_0432_001_0_valid : (rowR7_0432_001_0).ValidFor level8 {0,1,17,34,52,110,220} := by decide

noncomputable def rowsR7_0432_001 : List ExtensionRow := [rowR7_0432_001_0]

theorem rowsR7_0432_001_valid : RowListValid level8 {0,1,17,34,52,110,220} rowsR7_0432_001 := by
  intro r hr
  simp only [rowsR7_0432_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0432_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
