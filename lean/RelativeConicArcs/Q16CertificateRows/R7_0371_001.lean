import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0371_001_0 : ExtensionRow := { move := 264, child := 909, matrix := ![9,0,5,0,0,6,0,3,10], witnesses := [{ source := 0, target := 259, scalar := 5 },{ source := 1, target := 0, scalar := 3 },{ source := 17, target := 17, scalar := 9 },{ source := 34, target := 166, scalar := 12 },{ source := 52, target := 69, scalar := 6 },{ source := 91, target := 52, scalar := 13 },{ source := 253, target := 1, scalar := 14 },{ source := 264, target := 34, scalar := 1 }] }
theorem rowR7_0371_001_0_valid : (rowR7_0371_001_0).ValidFor level8 {0,1,17,34,52,91,253} := by decide

noncomputable def rowR7_0371_001_1 : ExtensionRow := { move := 266, child := 1768, matrix := ![0,10,11,0,13,12,12,9,4], witnesses := [{ source := 0, target := 168, scalar := 11 },{ source := 1, target := 71, scalar := 10 },{ source := 17, target := 0, scalar := 12 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 259, scalar := 9 },{ source := 91, target := 17, scalar := 12 },{ source := 253, target := 52, scalar := 11 },{ source := 266, target := 1, scalar := 1 }] }
theorem rowR7_0371_001_1_valid : (rowR7_0371_001_1).ValidFor level8 {0,1,17,34,52,91,253} := by decide

noncomputable def rowR7_0371_001_2 : ExtensionRow := { move := 270, child := 2485, matrix := ![0,15,10,10,2,11,0,14,3], witnesses := [{ source := 0, target := 232, scalar := 10 },{ source := 1, target := 74, scalar := 15 },{ source := 17, target := 1, scalar := 10 },{ source := 34, target := 247, scalar := 5 },{ source := 52, target := 0, scalar := 10 },{ source := 91, target := 17, scalar := 1 },{ source := 253, target := 52, scalar := 4 },{ source := 270, target := 34, scalar := 1 }] }
theorem rowR7_0371_001_2_valid : (rowR7_0371_001_2).ValidFor level8 {0,1,17,34,52,91,253} := by decide

noncomputable def rowsR7_0371_001 : List ExtensionRow := [rowR7_0371_001_0,rowR7_0371_001_1,rowR7_0371_001_2]

theorem rowsR7_0371_001_valid : RowListValid level8 {0,1,17,34,52,91,253} rowsR7_0371_001 := by
  intro r hr
  simp only [rowsR7_0371_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl
  · exact rowR7_0371_001_0_valid
  · exact rowR7_0371_001_1_valid
  · exact rowR7_0371_001_2_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
