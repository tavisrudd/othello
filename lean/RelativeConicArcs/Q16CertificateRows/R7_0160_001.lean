import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0160_001_0 : ExtensionRow := { move := 270, child := 1586, matrix := ![14,0,2,15,5,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 2 },{ source := 1, target := 1, scalar := 5 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 155, scalar := 12 },{ source := 52, target := 128, scalar := 8 },{ source := 72, target := 0, scalar := 1 },{ source := 159, target := 34, scalar := 1 },{ source := 270, target := 71, scalar := 7 }] }
theorem rowR7_0160_001_0_valid : (rowR7_0160_001_0).ValidFor level8 {0,1,17,34,52,72,159} := by decide

noncomputable def rowsR7_0160_001 : List ExtensionRow := [rowR7_0160_001_0]

theorem rowsR7_0160_001_valid : RowListValid level8 {0,1,17,34,52,72,159} rowsR7_0160_001 := by
  intro r hr
  simp only [rowsR7_0160_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0160_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
