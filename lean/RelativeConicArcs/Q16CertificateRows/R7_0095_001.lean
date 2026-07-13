import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0095_001_0 : ExtensionRow := { move := 269, child := 1706, matrix := ![2,7,4,15,14,0,8,9,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 52, scalar := 7 },{ source := 17, target := 245, scalar := 2 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 0, scalar := 9 },{ source := 71, target := 1, scalar := 14 },{ source := 159, target := 71, scalar := 2 },{ source := 269, target := 154, scalar := 12 }] }
theorem rowR7_0095_001_0_valid : (rowR7_0095_001_0).ValidFor level8 {0,1,17,34,52,71,159} := by decide

noncomputable def rowsR7_0095_001 : List ExtensionRow := [rowR7_0095_001_0]

theorem rowsR7_0095_001_valid : RowListValid level8 {0,1,17,34,52,71,159} rowsR7_0095_001 := by
  intro r hr
  simp only [rowsR7_0095_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0095_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
