import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0133_001_0 : ExtensionRow := { move := 253, child := 637, matrix := ![3,0,1,6,11,1,5,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 1, scalar := 11 },{ source := 17, target := 52, scalar := 3 },{ source := 34, target := 115, scalar := 2 },{ source := 52, target := 0, scalar := 6 },{ source := 71, target := 159, scalar := 5 },{ source := 253, target := 69, scalar := 15 },{ source := 262, target := 17, scalar := 6 }] }
theorem rowR7_0133_001_0_valid : (rowR7_0133_001_0).ValidFor level8 {0,1,17,34,52,71,262} := by decide

noncomputable def rowsR7_0133_001 : List ExtensionRow := [rowR7_0133_001_0]

theorem rowsR7_0133_001_valid : RowListValid level8 {0,1,17,34,52,71,262} rowsR7_0133_001 := by
  intro r hr
  simp only [rowsR7_0133_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0133_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
