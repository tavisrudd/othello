import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR6_0060_001_0 : ExtensionRow := { move := 212, child := 439, matrix := ![0,1,4,12,1,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 12 },{ source := 34, target := 124, scalar := 5 },{ source := 120, target := 141, scalar := 9 },{ source := 135, target := 52, scalar := 12 },{ source := 212, target := 0, scalar := 12 }] }
theorem rowR6_0060_001_0_valid : (rowR6_0060_001_0).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_001_1 : ExtensionRow := { move := 214, child := 439, matrix := ![1,9,4,1,10,0,1,6,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 141, scalar := 9 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 52, scalar := 12 },{ source := 120, target := 124, scalar := 13 },{ source := 135, target := 1, scalar := 2 },{ source := 214, target := 0, scalar := 15 }] }
theorem rowR6_0060_001_1_valid : (rowR6_0060_001_1).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_001_2 : ExtensionRow := { move := 217, child := 439, matrix := ![1,15,14,1,0,15,1,0,1], witnesses := [{ source := 0, target := 52, scalar := 14 },{ source := 1, target := 17, scalar := 15 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 14 },{ source := 120, target := 141, scalar := 9 },{ source := 135, target := 124, scalar := 8 },{ source := 217, target := 0, scalar := 9 }] }
theorem rowR6_0060_001_2_valid : (rowR6_0060_001_2).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_001_3 : ExtensionRow := { move := 219, child := 439, matrix := ![14,0,4,15,12,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 1, scalar := 12 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 141, scalar := 10 },{ source := 120, target := 34, scalar := 1 },{ source := 135, target := 124, scalar := 5 },{ source := 219, target := 0, scalar := 1 }] }
theorem rowR6_0060_001_3_valid : (rowR6_0060_001_3).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_001_4 : ExtensionRow := { move := 220, child := 439, matrix := ![3,8,11,9,5,0,7,7,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 124, scalar := 8 },{ source := 17, target := 141, scalar := 3 },{ source := 34, target := 1, scalar := 12 },{ source := 120, target := 52, scalar := 2 },{ source := 135, target := 34, scalar := 1 },{ source := 220, target := 0, scalar := 5 }] }
theorem rowR6_0060_001_4_valid : (rowR6_0060_001_4).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_001_5 : ExtensionRow := { move := 224, child := 439, matrix := ![8,2,11,5,4,0,7,6,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 52, scalar := 2 },{ source := 17, target := 124, scalar := 8 },{ source := 34, target := 34, scalar := 1 },{ source := 120, target := 1, scalar := 14 },{ source := 135, target := 141, scalar := 9 },{ source := 224, target := 0, scalar := 9 }] }
theorem rowR6_0060_001_5_valid : (rowR6_0060_001_5).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_001_6 : ExtensionRow := { move := 227, child := 439, matrix := ![5,1,4,13,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 124, scalar := 5 },{ source := 34, target := 1, scalar := 12 },{ source := 120, target := 52, scalar := 12 },{ source := 135, target := 141, scalar := 9 },{ source := 227, target := 0, scalar := 12 }] }
theorem rowR6_0060_001_6_valid : (rowR6_0060_001_6).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_001_7 : ExtensionRow := { move := 229, child := 439, matrix := ![12,9,4,11,10,0,7,6,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 141, scalar := 9 },{ source := 17, target := 52, scalar := 12 },{ source := 34, target := 34, scalar := 1 },{ source := 120, target := 1, scalar := 2 },{ source := 135, target := 124, scalar := 13 },{ source := 229, target := 0, scalar := 15 }] }
theorem rowR6_0060_001_7_valid : (rowR6_0060_001_7).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_001_8 : ExtensionRow := { move := 234, child := 439, matrix := ![0,15,14,14,0,15,0,0,1], witnesses := [{ source := 0, target := 52, scalar := 14 },{ source := 1, target := 17, scalar := 15 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 34, scalar := 1 },{ source := 120, target := 124, scalar := 8 },{ source := 135, target := 141, scalar := 9 },{ source := 234, target := 0, scalar := 9 }] }
theorem rowR6_0060_001_8_valid : (rowR6_0060_001_8).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_001_9 : ExtensionRow := { move := 235, child := 439, matrix := ![0,8,11,12,5,0,0,7,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 124, scalar := 8 },{ source := 17, target := 1, scalar := 12 },{ source := 34, target := 141, scalar := 3 },{ source := 120, target := 34, scalar := 1 },{ source := 135, target := 52, scalar := 2 },{ source := 235, target := 0, scalar := 5 }] }
theorem rowR6_0060_001_9_valid : (rowR6_0060_001_9).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_001_10 : ExtensionRow := { move := 236, child := 439, matrix := ![10,0,4,3,12,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 1, scalar := 12 },{ source := 17, target := 141, scalar := 10 },{ source := 34, target := 52, scalar := 14 },{ source := 120, target := 124, scalar := 5 },{ source := 135, target := 34, scalar := 1 },{ source := 236, target := 0, scalar := 1 }] }
theorem rowR6_0060_001_10_valid : (rowR6_0060_001_10).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_001_11 : ExtensionRow := { move := 239, child := 439, matrix := ![1,2,11,1,4,0,1,6,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 52, scalar := 2 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 124, scalar := 8 },{ source := 120, target := 141, scalar := 9 },{ source := 135, target := 1, scalar := 14 },{ source := 239, target := 0, scalar := 9 }] }
theorem rowR6_0060_001_11_valid : (rowR6_0060_001_11).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_001_12 : ExtensionRow := { move := 244, child := 439, matrix := ![14,0,11,15,2,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 1, scalar := 2 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 124, scalar := 5 },{ source := 120, target := 141, scalar := 10 },{ source := 135, target := 34, scalar := 1 },{ source := 244, target := 0, scalar := 1 }] }
theorem rowR6_0060_001_12_valid : (rowR6_0060_001_12).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_001_13 : ExtensionRow := { move := 245, child := 439, matrix := ![3,13,15,9,8,0,7,6,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 124, scalar := 13 },{ source := 17, target := 141, scalar := 3 },{ source := 34, target := 34, scalar := 1 },{ source := 120, target := 1, scalar := 12 },{ source := 135, target := 52, scalar := 2 },{ source := 245, target := 0, scalar := 5 }] }
theorem rowR6_0060_001_13_valid : (rowR6_0060_001_13).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_001_14 : ExtensionRow := { move := 249, child := 439, matrix := ![1,10,11,1,3,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 141, scalar := 10 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 2 },{ source := 120, target := 52, scalar := 12 },{ source := 135, target := 124, scalar := 13 },{ source := 249, target := 0, scalar := 15 }] }
theorem rowR6_0060_001_14_valid : (rowR6_0060_001_14).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_001_15 : ExtensionRow := { move := 250, child := 439, matrix := ![0,1,15,14,1,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 52, scalar := 14 },{ source := 120, target := 124, scalar := 13 },{ source := 135, target := 141, scalar := 3 },{ source := 250, target := 0, scalar := 14 }] }
theorem rowR6_0060_001_15_valid : (rowR6_0060_001_15).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_001_16 : ExtensionRow := { move := 252, child := 439, matrix := ![8,14,15,5,15,0,7,1,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 52, scalar := 14 },{ source := 17, target := 124, scalar := 8 },{ source := 34, target := 141, scalar := 9 },{ source := 120, target := 34, scalar := 1 },{ source := 135, target := 1, scalar := 14 },{ source := 252, target := 0, scalar := 9 }] }
theorem rowR6_0060_001_16_valid : (rowR6_0060_001_16).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_001_17 : ExtensionRow := { move := 254, child := 439, matrix := ![1,11,2,1,0,4,1,0,6], witnesses := [{ source := 0, target := 52, scalar := 2 },{ source := 1, target := 17, scalar := 11 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 124, scalar := 8 },{ source := 120, target := 1, scalar := 14 },{ source := 135, target := 141, scalar := 9 },{ source := 254, target := 0, scalar := 9 }] }
theorem rowR6_0060_001_17_valid : (rowR6_0060_001_17).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_001_18 : ExtensionRow := { move := 259, child := 439, matrix := ![5,0,11,13,2,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 1, scalar := 2 },{ source := 17, target := 124, scalar := 5 },{ source := 34, target := 52, scalar := 14 },{ source := 120, target := 34, scalar := 1 },{ source := 135, target := 141, scalar := 10 },{ source := 259, target := 0, scalar := 1 }] }
theorem rowR6_0060_001_18_valid : (rowR6_0060_001_18).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_001_19 : ExtensionRow := { move := 262, child := 439, matrix := ![1,13,15,1,8,0,1,6,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 124, scalar := 13 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 141, scalar := 3 },{ source := 120, target := 52, scalar := 2 },{ source := 135, target := 1, scalar := 12 },{ source := 262, target := 0, scalar := 5 }] }
theorem rowR6_0060_001_19_valid : (rowR6_0060_001_19).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_001_20 : ExtensionRow := { move := 265, child := 439, matrix := ![14,1,15,15,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 1, scalar := 14 },{ source := 120, target := 141, scalar := 3 },{ source := 135, target := 124, scalar := 13 },{ source := 265, target := 0, scalar := 14 }] }
theorem rowR6_0060_001_20_valid : (rowR6_0060_001_20).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_001_21 : ExtensionRow := { move := 266, child := 439, matrix := ![0,10,11,2,3,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 141, scalar := 10 },{ source := 17, target := 1, scalar := 2 },{ source := 34, target := 34, scalar := 1 },{ source := 120, target := 124, scalar := 13 },{ source := 135, target := 52, scalar := 12 },{ source := 266, target := 0, scalar := 15 }] }
theorem rowR6_0060_001_21_valid : (rowR6_0060_001_21).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_001_22 : ExtensionRow := { move := 267, child := 439, matrix := ![9,14,15,10,15,0,6,1,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 52, scalar := 14 },{ source := 17, target := 141, scalar := 9 },{ source := 34, target := 124, scalar := 8 },{ source := 120, target := 1, scalar := 14 },{ source := 135, target := 34, scalar := 1 },{ source := 267, target := 0, scalar := 9 }] }
theorem rowR6_0060_001_22_valid : (rowR6_0060_001_22).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_001_23 : ExtensionRow := { move := 269, child := 439, matrix := ![8,11,2,5,0,4,7,0,6], witnesses := [{ source := 0, target := 52, scalar := 2 },{ source := 1, target := 17, scalar := 11 },{ source := 17, target := 124, scalar := 8 },{ source := 34, target := 34, scalar := 1 },{ source := 120, target := 141, scalar := 9 },{ source := 135, target := 1, scalar := 14 },{ source := 269, target := 0, scalar := 9 }] }
theorem rowR6_0060_001_23_valid : (rowR6_0060_001_23).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowsR6_0060_001 : List ExtensionRow := [rowR6_0060_001_0,rowR6_0060_001_1,rowR6_0060_001_2,rowR6_0060_001_3,rowR6_0060_001_4,rowR6_0060_001_5,rowR6_0060_001_6,rowR6_0060_001_7,rowR6_0060_001_8,rowR6_0060_001_9,rowR6_0060_001_10,rowR6_0060_001_11,rowR6_0060_001_12,rowR6_0060_001_13,rowR6_0060_001_14,rowR6_0060_001_15,rowR6_0060_001_16,rowR6_0060_001_17,rowR6_0060_001_18,rowR6_0060_001_19,rowR6_0060_001_20,rowR6_0060_001_21,rowR6_0060_001_22,rowR6_0060_001_23]

theorem rowsR6_0060_001_valid : RowListValid level7 {0,1,17,34,120,135} rowsR6_0060_001 := by
  intro r hr
  simp only [rowsR6_0060_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR6_0060_001_0_valid
  · exact rowR6_0060_001_1_valid
  · exact rowR6_0060_001_2_valid
  · exact rowR6_0060_001_3_valid
  · exact rowR6_0060_001_4_valid
  · exact rowR6_0060_001_5_valid
  · exact rowR6_0060_001_6_valid
  · exact rowR6_0060_001_7_valid
  · exact rowR6_0060_001_8_valid
  · exact rowR6_0060_001_9_valid
  · exact rowR6_0060_001_10_valid
  · exact rowR6_0060_001_11_valid
  · exact rowR6_0060_001_12_valid
  · exact rowR6_0060_001_13_valid
  · exact rowR6_0060_001_14_valid
  · exact rowR6_0060_001_15_valid
  · exact rowR6_0060_001_16_valid
  · exact rowR6_0060_001_17_valid
  · exact rowR6_0060_001_18_valid
  · exact rowR6_0060_001_19_valid
  · exact rowR6_0060_001_20_valid
  · exact rowR6_0060_001_21_valid
  · exact rowR6_0060_001_22_valid
  · exact rowR6_0060_001_23_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
