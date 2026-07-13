import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0385_001_0 : ExtensionRow := { move := 269, child := 2342, matrix := ![0,1,14,0,1,12,6,1,5], witnesses := [{ source := 0, target := 144, scalar := 14 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 6 },{ source := 34, target := 52, scalar := 15 },{ source := 52, target := 73, scalar := 3 },{ source := 92, target := 110, scalar := 12 },{ source := 190, target := 1, scalar := 9 },{ source := 269, target := 17, scalar := 11 }] }
theorem rowR7_0385_001_0_valid : (rowR7_0385_001_0).ValidFor level8 {0,1,17,34,52,92,190} := by decide

noncomputable def rowsR7_0385_001 : List ExtensionRow := [rowR7_0385_001_0]

theorem rowsR7_0385_001_valid : RowListValid level8 {0,1,17,34,52,92,190} rowsR7_0385_001 := by
  intro r hr
  simp only [rowsR7_0385_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0385_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
