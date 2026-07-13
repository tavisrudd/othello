import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0281_001_0 : ExtensionRow := { move := 270, child := 2121, matrix := ![0,1,2,0,1,7,12,1,8], witnesses := [{ source := 0, target := 181, scalar := 2 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 12 },{ source := 34, target := 52, scalar := 3 },{ source := 52, target := 125, scalar := 4 },{ source := 75, target := 17, scalar := 4 },{ source := 240, target := 1, scalar := 6 },{ source := 270, target := 72, scalar := 6 }] }
theorem rowR7_0281_001_0_valid : (rowR7_0281_001_0).ValidFor level8 {0,1,17,34,52,75,240} := by decide

noncomputable def rowsR7_0281_001 : List ExtensionRow := [rowR7_0281_001_0]

theorem rowsR7_0281_001_valid : RowListValid level8 {0,1,17,34,52,75,240} rowsR7_0281_001 := by
  intro r hr
  simp only [rowsR7_0281_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0281_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
