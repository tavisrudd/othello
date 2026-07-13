import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0005_001_0 : ExtensionRow := { move := 271, child := 163, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 69, target := 69, scalar := 1 },{ source := 89, target := 89, scalar := 1 },{ source := 271, target := 271, scalar := 1 }] }
theorem rowR7_0005_001_0_valid : (rowR7_0005_001_0).ValidFor level8 {0,1,17,34,52,69,89} := by decide

noncomputable def rowsR7_0005_001 : List ExtensionRow := [rowR7_0005_001_0]

theorem rowsR7_0005_001_valid : RowListValid level8 {0,1,17,34,52,69,89} rowsR7_0005_001 := by
  intro r hr
  simp only [rowsR7_0005_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0005_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
