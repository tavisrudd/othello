import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0025_001_0 : ExtensionRow := { move := 270, child := 757, matrix := ![6,0,5,12,4,13,10,0,6], witnesses := [{ source := 0, target := 128, scalar := 5 },{ source := 1, target := 1, scalar := 4 },{ source := 17, target := 52, scalar := 6 },{ source := 34, target := 69, scalar := 3 },{ source := 52, target := 17, scalar := 9 },{ source := 69, target := 34, scalar := 1 },{ source := 128, target := 0, scalar := 14 },{ source := 270, target := 236, scalar := 10 }] }
theorem rowR7_0025_001_0_valid : (rowR7_0025_001_0).ValidFor level8 {0,1,17,34,52,69,128} := by decide

noncomputable def rowsR7_0025_001 : List ExtensionRow := [rowR7_0025_001_0]

theorem rowsR7_0025_001_valid : RowListValid level8 {0,1,17,34,52,69,128} rowsR7_0025_001 := by
  intro r hr
  simp only [rowsR7_0025_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0025_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
