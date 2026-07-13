import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0111_001_0 : ExtensionRow := { move := 265, child := 1012, matrix := ![0,0,15,2,0,2,0,6,6], witnesses := [{ source := 0, target := 70, scalar := 15 },{ source := 1, target := 0, scalar := 6 },{ source := 17, target := 1, scalar := 2 },{ source := 34, target := 17, scalar := 15 },{ source := 52, target := 52, scalar := 2 },{ source := 71, target := 191, scalar := 4 },{ source := 203, target := 90, scalar := 12 },{ source := 265, target := 34, scalar := 1 }] }
theorem rowR7_0111_001_0_valid : (rowR7_0111_001_0).ValidFor level8 {0,1,17,34,52,71,203} := by decide

noncomputable def rowsR7_0111_001 : List ExtensionRow := [rowR7_0111_001_0]

theorem rowsR7_0111_001_valid : RowListValid level8 {0,1,17,34,52,71,203} rowsR7_0111_001 := by
  intro r hr
  simp only [rowsR7_0111_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0111_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
