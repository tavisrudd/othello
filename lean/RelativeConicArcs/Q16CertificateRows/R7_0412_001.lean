import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0412_001_0 : ExtensionRow := { move := 271, child := 932, matrix := ![5,1,0,3,1,14,2,1,0], witnesses := [{ source := 0, target := 1, scalar := 14 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 246, scalar := 5 },{ source := 34, target := 69, scalar := 4 },{ source := 52, target := 17, scalar := 7 },{ source := 107, target := 0, scalar := 7 },{ source := 186, target := 173, scalar := 15 },{ source := 271, target := 52, scalar := 10 }] }
theorem rowR7_0412_001_0_valid : (rowR7_0412_001_0).ValidFor level8 {0,1,17,34,52,107,186} := by decide

noncomputable def rowsR7_0412_001 : List ExtensionRow := [rowR7_0412_001_0]

theorem rowsR7_0412_001_valid : RowListValid level8 {0,1,17,34,52,107,186} rowsR7_0412_001 := by
  intro r hr
  simp only [rowsR7_0412_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0412_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
