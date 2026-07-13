import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0153_001_0 : ExtensionRow := { move := 270, child := 1053, matrix := ![3,6,5,4,11,15,7,9,2], witnesses := [{ source := 0, target := 70, scalar := 5 },{ source := 1, target := 91, scalar := 6 },{ source := 17, target := 237, scalar := 3 },{ source := 34, target := 0, scalar := 12 },{ source := 52, target := 1, scalar := 3 },{ source := 72, target := 34, scalar := 1 },{ source := 139, target := 52, scalar := 6 },{ source := 270, target := 17, scalar := 11 }] }
theorem rowR7_0153_001_0_valid : (rowR7_0153_001_0).ValidFor level8 {0,1,17,34,52,72,139} := by decide

noncomputable def rowsR7_0153_001 : List ExtensionRow := [rowR7_0153_001_0]

theorem rowsR7_0153_001_valid : RowListValid level8 {0,1,17,34,52,72,139} rowsR7_0153_001 := by
  intro r hr
  simp only [rowsR7_0153_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0153_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
