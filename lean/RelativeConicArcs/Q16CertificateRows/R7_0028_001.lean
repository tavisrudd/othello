import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0028_001_0 : ExtensionRow := { move := 271, child := 771, matrix := ![0,6,6,0,12,8,5,10,15], witnesses := [{ source := 0, target := 236, scalar := 6 },{ source := 1, target := 52, scalar := 6 },{ source := 17, target := 0, scalar := 5 },{ source := 34, target := 1, scalar := 4 },{ source := 52, target := 17, scalar := 6 },{ source := 69, target := 34, scalar := 1 },{ source := 138, target := 69, scalar := 2 },{ source := 271, target := 131, scalar := 6 }] }
theorem rowR7_0028_001_0_valid : (rowR7_0028_001_0).ValidFor level8 {0,1,17,34,52,69,138} := by decide

noncomputable def rowsR7_0028_001 : List ExtensionRow := [rowR7_0028_001_0]

theorem rowsR7_0028_001_valid : RowListValid level8 {0,1,17,34,52,69,138} rowsR7_0028_001 := by
  intro r hr
  simp only [rowsR7_0028_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0028_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
