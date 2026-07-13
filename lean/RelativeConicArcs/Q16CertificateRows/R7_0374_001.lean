import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0374_001_0 : ExtensionRow := { move := 247, child := 1648, matrix := ![10,11,0,15,14,0,6,15,8], witnesses := [{ source := 0, target := 0, scalar := 8 },{ source := 1, target := 71, scalar := 11 },{ source := 17, target := 159, scalar := 10 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 17, scalar := 15 },{ source := 91, target := 1, scalar := 2 },{ source := 247, target := 52, scalar := 2 },{ source := 270, target := 144, scalar := 9 }] }
theorem rowR7_0374_001_0_valid : (rowR7_0374_001_0).ValidFor level8 {0,1,17,34,52,91,270} := by decide

noncomputable def rowR7_0374_001_1 : ExtensionRow := { move := 248, child := 793, matrix := ![9,1,8,7,1,3,10,1,11], witnesses := [{ source := 0, target := 52, scalar := 8 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 248, scalar := 9 },{ source := 34, target := 1, scalar := 5 },{ source := 52, target := 0, scalar := 6 },{ source := 91, target := 135, scalar := 2 },{ source := 248, target := 17, scalar := 10 },{ source := 270, target := 69, scalar := 4 }] }
theorem rowR7_0374_001_1_valid : (rowR7_0374_001_1).ValidFor level8 {0,1,17,34,52,91,270} := by decide

noncomputable def rowR7_0374_001_2 : ExtensionRow := { move := 253, child := 2485, matrix := ![0,15,10,10,2,11,0,14,3], witnesses := [{ source := 0, target := 232, scalar := 10 },{ source := 1, target := 74, scalar := 15 },{ source := 17, target := 1, scalar := 10 },{ source := 34, target := 247, scalar := 5 },{ source := 52, target := 0, scalar := 10 },{ source := 91, target := 17, scalar := 1 },{ source := 253, target := 52, scalar := 4 },{ source := 270, target := 34, scalar := 1 }] }
theorem rowR7_0374_001_2_valid : (rowR7_0374_001_2).ValidFor level8 {0,1,17,34,52,91,270} := by decide

noncomputable def rowsR7_0374_001 : List ExtensionRow := [rowR7_0374_001_0,rowR7_0374_001_1,rowR7_0374_001_2]

theorem rowsR7_0374_001_valid : RowListValid level8 {0,1,17,34,52,91,270} rowsR7_0374_001 := by
  intro r hr
  simp only [rowsR7_0374_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl
  · exact rowR7_0374_001_0_valid
  · exact rowR7_0374_001_1_valid
  · exact rowR7_0374_001_2_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
