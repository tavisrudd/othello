import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0383_001_0 : ExtensionRow := { move := 266, child := 2196, matrix := ![3,0,15,6,0,12,5,10,1], witnesses := [{ source := 0, target := 185, scalar := 15 },{ source := 1, target := 0, scalar := 10 },{ source := 17, target := 52, scalar := 3 },{ source := 34, target := 151, scalar := 12 },{ source := 52, target := 34, scalar := 1 },{ source := 92, target := 1, scalar := 11 },{ source := 182, target := 72, scalar := 5 },{ source := 266, target := 17, scalar := 13 }] }
theorem rowR7_0383_001_0_valid : (rowR7_0383_001_0).ValidFor level8 {0,1,17,34,52,92,182} := by decide

noncomputable def rowR7_0383_001_1 : ExtensionRow := { move := 267, child := 1621, matrix := ![14,0,8,1,0,0,2,11,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 0, scalar := 11 },{ source := 17, target := 71, scalar := 14 },{ source := 34, target := 139, scalar := 6 },{ source := 52, target := 197, scalar := 5 },{ source := 92, target := 52, scalar := 9 },{ source := 182, target := 1, scalar := 1 },{ source := 267, target := 34, scalar := 1 }] }
theorem rowR7_0383_001_1_valid : (rowR7_0383_001_1).ValidFor level8 {0,1,17,34,52,92,182} := by decide

noncomputable def rowR7_0383_001_2 : ExtensionRow := { move := 269, child := 1850, matrix := ![6,7,1,0,9,1,0,1,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 71, scalar := 7 },{ source := 17, target := 17, scalar := 6 },{ source := 34, target := 1, scalar := 8 },{ source := 52, target := 182, scalar := 11 },{ source := 92, target := 239, scalar := 2 },{ source := 182, target := 0, scalar := 15 },{ source := 269, target := 52, scalar := 1 }] }
theorem rowR7_0383_001_2_valid : (rowR7_0383_001_2).ValidFor level8 {0,1,17,34,52,92,182} := by decide

noncomputable def rowsR7_0383_001 : List ExtensionRow := [rowR7_0383_001_0,rowR7_0383_001_1,rowR7_0383_001_2]

theorem rowsR7_0383_001_valid : RowListValid level8 {0,1,17,34,52,92,182} rowsR7_0383_001 := by
  intro r hr
  simp only [rowsR7_0383_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl
  · exact rowR7_0383_001_0_valid
  · exact rowR7_0383_001_1_valid
  · exact rowR7_0383_001_2_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
