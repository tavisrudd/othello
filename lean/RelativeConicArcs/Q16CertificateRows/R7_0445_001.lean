import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0445_001_0 : ExtensionRow := { move := 270, child := 2630, matrix := ![4,11,0,2,5,7,14,14,0], witnesses := [{ source := 0, target := 1, scalar := 7 },{ source := 1, target := 52, scalar := 11 },{ source := 17, target := 171, scalar := 4 },{ source := 34, target := 17, scalar := 15 },{ source := 52, target := 34, scalar := 1 },{ source := 128, target := 138, scalar := 11 },{ source := 138, target := 0, scalar := 2 },{ source := 270, target := 128, scalar := 7 }] }
theorem rowR7_0445_001_0_valid : (rowR7_0445_001_0).ValidFor level8 {0,1,17,34,52,128,138} := by decide

noncomputable def rowsR7_0445_001 : List ExtensionRow := [rowR7_0445_001_0]

theorem rowsR7_0445_001_valid : RowListValid level8 {0,1,17,34,52,128,138} rowsR7_0445_001 := by
  intro r hr
  simp only [rowsR7_0445_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0445_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
