import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0320_001_0 : ExtensionRow := { move := 251, child := 2315, matrix := ![13,5,8,14,6,3,7,12,11], witnesses := [{ source := 0, target := 52, scalar := 8 },{ source := 1, target := 270, scalar := 5 },{ source := 17, target := 240, scalar := 13 },{ source := 34, target := 1, scalar := 11 },{ source := 52, target := 72, scalar := 12 },{ source := 78, target := 0, scalar := 6 },{ source := 251, target := 34, scalar := 1 },{ source := 263, target := 17, scalar := 14 }] }
theorem rowR7_0320_001_0_valid : (rowR7_0320_001_0).ValidFor level8 {0,1,17,34,52,78,263} := by decide

noncomputable def rowR7_0320_001_1 : ExtensionRow := { move := 253, child := 1463, matrix := ![4,9,13,12,5,12,11,4,15], witnesses := [{ source := 0, target := 106, scalar := 13 },{ source := 1, target := 185, scalar := 9 },{ source := 17, target := 71, scalar := 4 },{ source := 34, target := 1, scalar := 5 },{ source := 52, target := 34, scalar := 1 },{ source := 78, target := 17, scalar := 2 },{ source := 253, target := 0, scalar := 14 },{ source := 263, target := 52, scalar := 2 }] }
theorem rowR7_0320_001_1_valid : (rowR7_0320_001_1).ValidFor level8 {0,1,17,34,52,78,263} := by decide

noncomputable def rowsR7_0320_001 : List ExtensionRow := [rowR7_0320_001_0,rowR7_0320_001_1]

theorem rowsR7_0320_001_valid : RowListValid level8 {0,1,17,34,52,78,263} rowsR7_0320_001 := by
  intro r hr
  simp only [rowsR7_0320_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl
  · exact rowR7_0320_001_0_valid
  · exact rowR7_0320_001_1_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
