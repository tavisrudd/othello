import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR7_0382_001_0 : ExtensionRow := { move := 269, child := 2450, matrix := ![6,0,2,0,11,3,0,0,12], witnesses := [{ source := 0, target := 151, scalar := 2 },{ source := 1, target := 1, scalar := 11 },{ source := 17, target := 17, scalar := 6 },{ source := 34, target := 52, scalar := 4 },{ source := 52, target := 0, scalar := 7 },{ source := 92, target := 235, scalar := 3 },{ source := 171, target := 34, scalar := 1 },{ source := 269, target := 74, scalar := 13 }] }
theorem rowR7_0382_001_0_valid : (rowR7_0382_001_0).ValidFor level8 {0,1,17,34,52,92,171} := by decide

noncomputable def rowsR7_0382_001 : List ExtensionRow := [rowR7_0382_001_0]

theorem rowsR7_0382_001_valid : RowListValid level8 {0,1,17,34,52,92,171} rowsR7_0382_001 := by
  intro r hr
  simp only [rowsR7_0382_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl
  · exact rowR7_0382_001_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
