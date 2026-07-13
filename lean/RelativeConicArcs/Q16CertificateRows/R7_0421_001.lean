import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0421_001_0 : ExtensionRow := { move := 270, child := 2465, matrix := ![2,3,0,4,5,0,6,8,15], witnesses := [{ source := 0, target := 0, scalar := 15 },{ source := 1, target := 74, scalar := 3 },{ source := 17, target := 52, scalar := 2 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 182, scalar := 4 },{ source := 108, target := 203, scalar := 13 },{ source := 181, target := 17, scalar := 15 },{ source := 270, target := 1, scalar := 2 }] }
theorem rowR7_0421_001_0_valid : (rowR7_0421_001_0).ValidFor level8 {0,1,17,34,52,108,181} := by decide

noncomputable def rowsR7_0421_001 : List ExtensionRow := [rowR7_0421_001_0]

theorem rowsR7_0421_001_valid : RowListValid level8 {0,1,17,34,52,108,181} rowsR7_0421_001 := by
  intro r hr
  simp only [rowsR7_0421_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0421_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
