import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0404_001_0 : ExtensionRow := { move := 270, child := 10, matrix := ![3,5,7,6,8,15,5,9,13], witnesses := [{ source := 0, target := 89, scalar := 7 },{ source := 1, target := 141, scalar := 5 },{ source := 17, target := 52, scalar := 3 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 1, scalar := 7 },{ source := 101, target := 67, scalar := 14 },{ source := 124, target := 17, scalar := 10 },{ source := 270, target := 0, scalar := 5 }] }
theorem rowR7_0404_001_0_valid : (rowR7_0404_001_0).ValidFor level8 {0,1,17,34,52,101,124} := by decide

noncomputable def rowsR7_0404_001 : List ExtensionRow := [rowR7_0404_001_0]

theorem rowsR7_0404_001_valid : RowListValid level8 {0,1,17,34,52,101,124} rowsR7_0404_001 := by
  intro r hr
  simp only [rowsR7_0404_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0404_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
