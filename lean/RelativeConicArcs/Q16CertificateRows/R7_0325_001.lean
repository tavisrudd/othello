import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0325_001_0 : ExtensionRow := { move := 268, child := 2522, matrix := ![1,9,0,1,8,0,1,5,8], witnesses := [{ source := 0, target := 0, scalar := 8 },{ source := 1, target := 75, scalar := 9 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 249, scalar := 8 },{ source := 52, target := 1, scalar := 2 },{ source := 79, target := 143, scalar := 9 },{ source := 125, target := 52, scalar := 2 },{ source := 268, target := 17, scalar := 15 }] }
theorem rowR7_0325_001_0_valid : (rowR7_0325_001_0).ValidFor level8 {0,1,17,34,52,79,125} := by decide

noncomputable def rowsR7_0325_001 : List ExtensionRow := [rowR7_0325_001_0]

theorem rowsR7_0325_001_valid : RowListValid level8 {0,1,17,34,52,79,125} rowsR7_0325_001 := by
  intro r hr
  simp only [rowsR7_0325_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0325_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
