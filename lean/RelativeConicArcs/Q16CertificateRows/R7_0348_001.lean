import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0348_001_0 : ExtensionRow := { move := 268, child := 859, matrix := ![5,0,2,9,0,4,2,2,6], witnesses := [{ source := 0, target := 52, scalar := 2 },{ source := 1, target := 0, scalar := 2 },{ source := 17, target := 214, scalar := 5 },{ source := 34, target := 152, scalar := 7 },{ source := 52, target := 69, scalar := 3 },{ source := 80, target := 17, scalar := 8 },{ source := 243, target := 34, scalar := 1 },{ source := 268, target := 1, scalar := 3 }] }
theorem rowR7_0348_001_0_valid : (rowR7_0348_001_0).ValidFor level8 {0,1,17,34,52,80,243} := by decide

noncomputable def rowR7_0348_001_1 : ExtensionRow := { move := 269, child := 1433, matrix := ![14,0,14,7,0,3,9,5,12], witnesses := [{ source := 0, target := 104, scalar := 14 },{ source := 1, target := 0, scalar := 5 },{ source := 17, target := 169, scalar := 14 },{ source := 34, target := 1, scalar := 4 },{ source := 52, target := 71, scalar := 15 },{ source := 80, target := 52, scalar := 11 },{ source := 243, target := 34, scalar := 1 },{ source := 269, target := 17, scalar := 10 }] }
theorem rowR7_0348_001_1_valid : (rowR7_0348_001_1).ValidFor level8 {0,1,17,34,52,80,243} := by decide

noncomputable def rowR7_0348_001_2 : ExtensionRow := { move := 271, child := 132, matrix := ![5,6,3,0,12,11,0,10,10], witnesses := [{ source := 0, target := 151, scalar := 3 },{ source := 1, target := 52, scalar := 6 },{ source := 17, target := 17, scalar := 5 },{ source := 34, target := 1, scalar := 7 },{ source := 52, target := 89, scalar := 12 },{ source := 80, target := 69, scalar := 13 },{ source := 243, target := 34, scalar := 1 },{ source := 271, target := 0, scalar := 10 }] }
theorem rowR7_0348_001_2_valid : (rowR7_0348_001_2).ValidFor level8 {0,1,17,34,52,80,243} := by decide

noncomputable def rowsR7_0348_001 : List ExtensionRow := [rowR7_0348_001_0,rowR7_0348_001_1,rowR7_0348_001_2]

theorem rowsR7_0348_001_valid : RowListValid level8 {0,1,17,34,52,80,243} rowsR7_0348_001 := by
  intro r hr
  simp only [rowsR7_0348_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl
  · exact rowR7_0348_001_0_valid
  · exact rowR7_0348_001_1_valid
  · exact rowR7_0348_001_2_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
