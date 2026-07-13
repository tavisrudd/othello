import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR4_0000_003_0 : ExtensionRow := { move := 228, child := 2, matrix := ![1,6,7,1,0,14,1,0,1], witnesses := [{ source := 0, target := 55, scalar := 7 },{ source := 1, target := 17, scalar := 6 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 15 },{ source := 228, target := 0, scalar := 2 }] }
theorem rowR4_0000_003_0_valid : (rowR4_0000_003_0).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_1 : ExtensionRow := { move := 229, child := 1, matrix := ![0,2,2,0,4,0,10,10,0], witnesses := [{ source := 0, target := 17, scalar := 2 },{ source := 1, target := 54, scalar := 2 },{ source := 17, target := 0, scalar := 10 },{ source := 34, target := 1, scalar := 4 },{ source := 229, target := 34, scalar := 1 }] }
theorem rowR4_0000_003_1_valid : (rowR4_0000_003_1).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_2 : ExtensionRow := { move := 230, child := 2, matrix := ![0,7,1,15,14,1,0,1,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 55, scalar := 7 },{ source := 17, target := 1, scalar := 15 },{ source := 34, target := 17, scalar := 6 },{ source := 230, target := 0, scalar := 8 }] }
theorem rowR4_0000_003_2_valid : (rowR4_0000_003_2).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_3 : ExtensionRow := { move := 231, child := 2, matrix := ![1,0,1,2,3,1,6,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 1, scalar := 3 },{ source := 17, target := 55, scalar := 1 },{ source := 34, target := 0, scalar := 7 },{ source := 231, target := 17, scalar := 7 }] }
theorem rowR4_0000_003_3_valid : (rowR4_0000_003_3).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_4 : ExtensionRow := { move := 232, child := 2, matrix := ![0,0,6,0,12,12,7,0,7], witnesses := [{ source := 0, target := 55, scalar := 6 },{ source := 1, target := 1, scalar := 12 },{ source := 17, target := 0, scalar := 7 },{ source := 34, target := 17, scalar := 6 },{ source := 232, target := 34, scalar := 1 }] }
theorem rowR4_0000_003_4_valid : (rowR4_0000_003_4).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_5 : ExtensionRow := { move := 233, child := 2, matrix := ![0,0,1,3,0,2,0,7,6], witnesses := [{ source := 0, target := 55, scalar := 1 },{ source := 1, target := 0, scalar := 7 },{ source := 17, target := 1, scalar := 3 },{ source := 34, target := 34, scalar := 1 },{ source := 233, target := 17, scalar := 8 }] }
theorem rowR4_0000_003_5_valid : (rowR4_0000_003_5).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_6 : ExtensionRow := { move := 234, child := 0, matrix := ![0,15,14,14,0,15,0,0,1], witnesses := [{ source := 0, target := 52, scalar := 14 },{ source := 1, target := 17, scalar := 15 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 34, scalar := 1 },{ source := 234, target := 0, scalar := 9 }] }
theorem rowR4_0000_003_6_valid : (rowR4_0000_003_6).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_7 : ExtensionRow := { move := 235, child := 2, matrix := ![8,1,9,0,1,1,0,1,3], witnesses := [{ source := 0, target := 55, scalar := 9 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 17, scalar := 8 },{ source := 34, target := 0, scalar := 2 },{ source := 235, target := 1, scalar := 7 }] }
theorem rowR4_0000_003_7_valid : (rowR4_0000_003_7).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_8 : ExtensionRow := { move := 236, child := 1, matrix := ![0,1,1,1,1,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 236, target := 54, scalar := 6 }] }
theorem rowR4_0000_003_8_valid : (rowR4_0000_003_8).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_9 : ExtensionRow := { move := 237, child := 1, matrix := ![1,0,10,1,4,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 10 },{ source := 1, target := 1, scalar := 4 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 54, scalar := 11 },{ source := 237, target := 0, scalar := 1 }] }
theorem rowR4_0000_003_9_valid : (rowR4_0000_003_9).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_10 : ExtensionRow := { move := 239, child := 1, matrix := ![9,0,8,1,0,0,11,10,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 0, scalar := 10 },{ source := 17, target := 54, scalar := 9 },{ source := 34, target := 34, scalar := 1 },{ source := 239, target := 1, scalar := 1 }] }
theorem rowR4_0000_003_10_valid : (rowR4_0000_003_10).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_11 : ExtensionRow := { move := 240, child := 2, matrix := ![1,0,1,0,0,1,0,1,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 240, target := 55, scalar := 14 }] }
theorem rowR4_0000_003_11_valid : (rowR4_0000_003_11).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_12 : ExtensionRow := { move := 243, child := 2, matrix := ![0,0,9,1,0,0,0,3,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 0, scalar := 3 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 55, scalar := 9 },{ source := 243, target := 34, scalar := 1 }] }
theorem rowR4_0000_003_12_valid : (rowR4_0000_003_12).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_13 : ExtensionRow := { move := 244, child := 0, matrix := ![9,0,9,1,0,0,8,8,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 0, scalar := 8 },{ source := 17, target := 52, scalar := 9 },{ source := 34, target := 1, scalar := 1 },{ source := 244, target := 34, scalar := 1 }] }
theorem rowR4_0000_003_13_valid : (rowR4_0000_003_13).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_14 : ExtensionRow := { move := 245, child := 2, matrix := ![1,9,8,1,1,0,1,3,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 55, scalar := 9 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 2 },{ source := 245, target := 1, scalar := 15 }] }
theorem rowR4_0000_003_14_valid : (rowR4_0000_003_14).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_15 : ExtensionRow := { move := 246, child := 2, matrix := ![8,8,0,0,3,0,0,5,5], witnesses := [{ source := 0, target := 0, scalar := 5 },{ source := 1, target := 55, scalar := 8 },{ source := 17, target := 17, scalar := 8 },{ source := 34, target := 1, scalar := 3 },{ source := 246, target := 34, scalar := 1 }] }
theorem rowR4_0000_003_15_valid : (rowR4_0000_003_15).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_16 : ExtensionRow := { move := 247, child := 2, matrix := ![1,0,0,1,3,0,1,0,7], witnesses := [{ source := 0, target := 0, scalar := 7 },{ source := 1, target := 1, scalar := 3 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 55, scalar := 1 },{ source := 247, target := 17, scalar := 1 }] }
theorem rowR4_0000_003_16_valid : (rowR4_0000_003_16).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_17 : ExtensionRow := { move := 248, child := 2, matrix := ![0,0,1,0,1,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 248, target := 55, scalar := 7 }] }
theorem rowR4_0000_003_17_valid : (rowR4_0000_003_17).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_18 : ExtensionRow := { move := 249, child := 2, matrix := ![9,8,0,1,0,0,3,0,2], witnesses := [{ source := 0, target := 0, scalar := 2 },{ source := 1, target := 17, scalar := 8 },{ source := 17, target := 55, scalar := 9 },{ source := 34, target := 34, scalar := 1 },{ source := 249, target := 1, scalar := 1 }] }
theorem rowR4_0000_003_18_valid : (rowR4_0000_003_18).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_19 : ExtensionRow := { move := 250, child := 0, matrix := ![0,1,15,14,1,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 52, scalar := 14 },{ source := 250, target := 0, scalar := 14 }] }
theorem rowR4_0000_003_19_valid : (rowR4_0000_003_19).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_20 : ExtensionRow := { move := 251, child := 2, matrix := ![7,1,6,14,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 55, scalar := 7 },{ source := 34, target := 1, scalar := 15 },{ source := 251, target := 0, scalar := 15 }] }
theorem rowR4_0000_003_20_valid : (rowR4_0000_003_20).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_21 : ExtensionRow := { move := 252, child := 0, matrix := ![0,9,8,0,1,0,9,8,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 52, scalar := 9 },{ source := 17, target := 0, scalar := 9 },{ source := 34, target := 34, scalar := 1 },{ source := 252, target := 1, scalar := 14 }] }
theorem rowR4_0000_003_21_valid : (rowR4_0000_003_21).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_22 : ExtensionRow := { move := 253, child := 2, matrix := ![0,1,0,1,1,0,0,1,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 253, target := 55, scalar := 14 }] }
theorem rowR4_0000_003_22_valid : (rowR4_0000_003_22).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_23 : ExtensionRow := { move := 254, child := 1, matrix := ![9,8,0,1,0,0,11,0,10], witnesses := [{ source := 0, target := 0, scalar := 10 },{ source := 1, target := 17, scalar := 8 },{ source := 17, target := 54, scalar := 9 },{ source := 34, target := 34, scalar := 1 },{ source := 254, target := 1, scalar := 1 }] }
theorem rowR4_0000_003_23_valid : (rowR4_0000_003_23).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_24 : ExtensionRow := { move := 256, child := 0, matrix := ![1,0,1,1,1,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 256, target := 52, scalar := 14 }] }
theorem rowR4_0000_003_24_valid : (rowR4_0000_003_24).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_25 : ExtensionRow := { move := 259, child := 0, matrix := ![0,0,9,1,0,0,0,8,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 0, scalar := 8 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 52, scalar := 9 },{ source := 259, target := 34, scalar := 1 }] }
theorem rowR4_0000_003_25_valid : (rowR4_0000_003_25).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_26 : ExtensionRow := { move := 260, child := 2, matrix := ![9,0,9,1,0,0,3,3,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 0, scalar := 3 },{ source := 17, target := 55, scalar := 9 },{ source := 34, target := 1, scalar := 1 },{ source := 260, target := 34, scalar := 1 }] }
theorem rowR4_0000_003_26_valid : (rowR4_0000_003_26).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_27 : ExtensionRow := { move := 261, child := 2, matrix := ![0,8,0,3,3,0,0,5,5], witnesses := [{ source := 0, target := 0, scalar := 5 },{ source := 1, target := 55, scalar := 8 },{ source := 17, target := 1, scalar := 3 },{ source := 34, target := 17, scalar := 8 },{ source := 261, target := 34, scalar := 1 }] }
theorem rowR4_0000_003_27_valid : (rowR4_0000_003_27).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_28 : ExtensionRow := { move := 262, child := 2, matrix := ![0,9,8,0,1,0,2,3,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 55, scalar := 9 },{ source := 17, target := 0, scalar := 2 },{ source := 34, target := 34, scalar := 1 },{ source := 262, target := 1, scalar := 15 }] }
theorem rowR4_0000_003_28_valid : (rowR4_0000_003_28).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_29 : ExtensionRow := { move := 263, child := 2, matrix := ![1,0,1,1,1,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 263, target := 55, scalar := 7 }] }
theorem rowR4_0000_003_29_valid : (rowR4_0000_003_29).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_30 : ExtensionRow := { move := 264, child := 2, matrix := ![1,0,0,2,3,0,6,0,7], witnesses := [{ source := 0, target := 0, scalar := 7 },{ source := 1, target := 1, scalar := 3 },{ source := 17, target := 55, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 264, target := 17, scalar := 1 }] }
theorem rowR4_0000_003_30_valid : (rowR4_0000_003_30).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_31 : ExtensionRow := { move := 265, child := 0, matrix := ![14,1,15,15,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 1, scalar := 14 },{ source := 265, target := 0, scalar := 14 }] }
theorem rowR4_0000_003_31_valid : (rowR4_0000_003_31).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_32 : ExtensionRow := { move := 266, child := 2, matrix := ![1,8,0,1,0,0,1,0,2], witnesses := [{ source := 0, target := 0, scalar := 2 },{ source := 1, target := 17, scalar := 8 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 55, scalar := 9 },{ source := 266, target := 1, scalar := 1 }] }
theorem rowR4_0000_003_32_valid : (rowR4_0000_003_32).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_33 : ExtensionRow := { move := 267, child := 0, matrix := ![1,9,8,1,1,0,1,8,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 52, scalar := 9 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 9 },{ source := 267, target := 1, scalar := 14 }] }
theorem rowR4_0000_003_33_valid : (rowR4_0000_003_33).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_34 : ExtensionRow := { move := 268, child := 2, matrix := ![0,1,6,15,1,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 15 },{ source := 34, target := 55, scalar := 7 },{ source := 268, target := 0, scalar := 15 }] }
theorem rowR4_0000_003_34_valid : (rowR4_0000_003_34).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_35 : ExtensionRow := { move := 269, child := 1, matrix := ![1,8,0,1,0,0,1,0,10], witnesses := [{ source := 0, target := 0, scalar := 10 },{ source := 1, target := 17, scalar := 8 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 54, scalar := 9 },{ source := 269, target := 1, scalar := 1 }] }
theorem rowR4_0000_003_35_valid : (rowR4_0000_003_35).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_36 : ExtensionRow := { move := 270, child := 2, matrix := ![1,1,0,0,1,0,0,1,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 270, target := 55, scalar := 14 }] }
theorem rowR4_0000_003_36_valid : (rowR4_0000_003_36).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_003_37 : ExtensionRow := { move := 271, child := 0, matrix := ![0,0,1,0,1,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 271, target := 52, scalar := 14 }] }
theorem rowR4_0000_003_37_valid : (rowR4_0000_003_37).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowsR4_0000_003 : List ExtensionRow := [rowR4_0000_003_0,rowR4_0000_003_1,rowR4_0000_003_2,rowR4_0000_003_3,rowR4_0000_003_4,rowR4_0000_003_5,rowR4_0000_003_6,rowR4_0000_003_7,rowR4_0000_003_8,rowR4_0000_003_9,rowR4_0000_003_10,rowR4_0000_003_11,rowR4_0000_003_12,rowR4_0000_003_13,rowR4_0000_003_14,rowR4_0000_003_15,rowR4_0000_003_16,rowR4_0000_003_17,rowR4_0000_003_18,rowR4_0000_003_19,rowR4_0000_003_20,rowR4_0000_003_21,rowR4_0000_003_22,rowR4_0000_003_23,rowR4_0000_003_24,rowR4_0000_003_25,rowR4_0000_003_26,rowR4_0000_003_27,rowR4_0000_003_28,rowR4_0000_003_29,rowR4_0000_003_30,rowR4_0000_003_31,rowR4_0000_003_32,rowR4_0000_003_33,rowR4_0000_003_34,rowR4_0000_003_35,rowR4_0000_003_36,rowR4_0000_003_37]

theorem rowsR4_0000_003_valid : RowListValid level5 {0,1,17,34} rowsR4_0000_003 := by
  intro r hr
  simp only [rowsR4_0000_003, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR4_0000_003_0_valid
  · exact rowR4_0000_003_1_valid
  · exact rowR4_0000_003_2_valid
  · exact rowR4_0000_003_3_valid
  · exact rowR4_0000_003_4_valid
  · exact rowR4_0000_003_5_valid
  · exact rowR4_0000_003_6_valid
  · exact rowR4_0000_003_7_valid
  · exact rowR4_0000_003_8_valid
  · exact rowR4_0000_003_9_valid
  · exact rowR4_0000_003_10_valid
  · exact rowR4_0000_003_11_valid
  · exact rowR4_0000_003_12_valid
  · exact rowR4_0000_003_13_valid
  · exact rowR4_0000_003_14_valid
  · exact rowR4_0000_003_15_valid
  · exact rowR4_0000_003_16_valid
  · exact rowR4_0000_003_17_valid
  · exact rowR4_0000_003_18_valid
  · exact rowR4_0000_003_19_valid
  · exact rowR4_0000_003_20_valid
  · exact rowR4_0000_003_21_valid
  · exact rowR4_0000_003_22_valid
  · exact rowR4_0000_003_23_valid
  · exact rowR4_0000_003_24_valid
  · exact rowR4_0000_003_25_valid
  · exact rowR4_0000_003_26_valid
  · exact rowR4_0000_003_27_valid
  · exact rowR4_0000_003_28_valid
  · exact rowR4_0000_003_29_valid
  · exact rowR4_0000_003_30_valid
  · exact rowR4_0000_003_31_valid
  · exact rowR4_0000_003_32_valid
  · exact rowR4_0000_003_33_valid
  · exact rowR4_0000_003_34_valid
  · exact rowR4_0000_003_35_valid
  · exact rowR4_0000_003_36_valid
  · exact rowR4_0000_003_37_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
