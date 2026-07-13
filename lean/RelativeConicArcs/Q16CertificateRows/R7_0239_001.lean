import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0239_001_0 : ExtensionRow := { move := 267, child := 2088, matrix := ![15,14,1,2,3,1,11,8,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 108, scalar := 14 },{ source := 17, target := 72, scalar := 15 },{ source := 34, target := 0, scalar := 2 },{ source := 52, target := 217, scalar := 3 },{ source := 74, target := 52, scalar := 7 },{ source := 205, target := 17, scalar := 11 },{ source := 267, target := 1, scalar := 10 }] }
theorem rowR7_0239_001_0_valid : (rowR7_0239_001_0).ValidFor level8 {0,1,17,34,52,74,205} := by decide

noncomputable def rowsR7_0239_001 : List ExtensionRow := [rowR7_0239_001_0]

theorem rowsR7_0239_001_valid : RowListValid level8 {0,1,17,34,52,74,205} rowsR7_0239_001 := by
  intro r hr
  simp only [rowsR7_0239_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0239_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
