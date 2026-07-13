import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR6_0000_001_0 : ExtensionRow := { move := 201, child := 2, matrix := ![0,1,1,1,3,2,0,2,3], witnesses := [{ source := 0, target := 52, scalar := 1 },{ source := 1, target := 67, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 34, scalar := 1 },{ source := 67, target := 17, scalar := 1 },{ source := 201, target := 92, scalar := 3 }] }
theorem rowR6_0000_001_0_valid : (rowR6_0000_001_0).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_1 : ExtensionRow := { move := 202, child := 2, matrix := ![1,1,1,1,2,3,1,3,2], witnesses := [{ source := 0, target := 67, scalar := 1 },{ source := 1, target := 52, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 0, scalar := 1 },{ source := 67, target := 1, scalar := 1 },{ source := 202, target := 92, scalar := 3 }] }
theorem rowR6_0000_001_1_valid : (rowR6_0000_001_1).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_2 : ExtensionRow := { move := 205, child := 3, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 67, target := 67, scalar := 1 },{ source := 205, target := 159, scalar := 7 }] }
theorem rowR6_0000_001_2_valid : (rowR6_0000_001_2).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_3 : ExtensionRow := { move := 208, child := 0, matrix := ![0,1,1,0,3,2,1,2,3], witnesses := [{ source := 0, target := 52, scalar := 1 },{ source := 1, target := 67, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 17, scalar := 1 },{ source := 67, target := 34, scalar := 1 },{ source := 208, target := 89, scalar := 4 }] }
theorem rowR6_0000_001_3_valid : (rowR6_0000_001_3).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_4 : ExtensionRow := { move := 213, child := 1, matrix := ![0,1,1,1,2,3,0,3,2], witnesses := [{ source := 0, target := 67, scalar := 1 },{ source := 1, target := 52, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 17, scalar := 1 },{ source := 67, target := 34, scalar := 1 },{ source := 213, target := 91, scalar := 8 }] }
theorem rowR6_0000_001_4_valid : (rowR6_0000_001_4).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_5 : ExtensionRow := { move := 214, child := 2, matrix := ![1,1,1,3,0,1,2,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 67, scalar := 1 },{ source := 34, target := 52, scalar := 1 },{ source := 52, target := 0, scalar := 1 },{ source := 67, target := 1, scalar := 1 },{ source := 214, target := 92, scalar := 8 }] }
theorem rowR6_0000_001_5_valid : (rowR6_0000_001_5).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_6 : ExtensionRow := { move := 216, child := 0, matrix := ![1,1,1,2,1,0,3,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 1 },{ source := 34, target := 67, scalar := 1 },{ source := 52, target := 0, scalar := 1 },{ source := 67, target := 1, scalar := 1 },{ source := 216, target := 89, scalar := 10 }] }
theorem rowR6_0000_001_6_valid : (rowR6_0000_001_6).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_7 : ExtensionRow := { move := 218, child := 0, matrix := ![1,1,1,0,2,3,0,3,2], witnesses := [{ source := 0, target := 67, scalar := 1 },{ source := 1, target := 52, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 1, scalar := 1 },{ source := 67, target := 0, scalar := 1 },{ source := 218, target := 89, scalar := 4 }] }
theorem rowR6_0000_001_7_valid : (rowR6_0000_001_7).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_8 : ExtensionRow := { move := 220, child := 3, matrix := ![0,1,1,1,1,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 67, scalar := 1 },{ source := 67, target := 52, scalar := 1 },{ source := 220, target := 159, scalar := 7 }] }
theorem rowR6_0000_001_8_valid : (rowR6_0000_001_8).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_9 : ExtensionRow := { move := 223, child := 1, matrix := ![1,1,1,2,0,1,3,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 52, scalar := 1 },{ source := 34, target := 67, scalar := 1 },{ source := 52, target := 1, scalar := 1 },{ source := 67, target := 0, scalar := 1 },{ source := 223, target := 91, scalar := 3 }] }
theorem rowR6_0000_001_9_valid : (rowR6_0000_001_9).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_10 : ExtensionRow := { move := 224, child := 1, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 67, target := 67, scalar := 1 },{ source := 224, target := 91, scalar := 3 }] }
theorem rowR6_0000_001_10_valid : (rowR6_0000_001_10).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_11 : ExtensionRow := { move := 229, child := 2, matrix := ![1,1,1,2,0,1,3,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 52, scalar := 1 },{ source := 34, target := 67, scalar := 1 },{ source := 52, target := 1, scalar := 1 },{ source := 67, target := 0, scalar := 1 },{ source := 229, target := 92, scalar := 8 }] }
theorem rowR6_0000_001_11_valid : (rowR6_0000_001_11).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_12 : ExtensionRow := { move := 230, child := 1, matrix := ![0,1,1,0,2,3,1,3,2], witnesses := [{ source := 0, target := 67, scalar := 1 },{ source := 1, target := 52, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 34, scalar := 1 },{ source := 67, target := 17, scalar := 1 },{ source := 230, target := 91, scalar := 8 }] }
theorem rowR6_0000_001_12_valid : (rowR6_0000_001_12).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_13 : ExtensionRow := { move := 231, child := 0, matrix := ![1,1,1,3,1,0,2,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 67, scalar := 1 },{ source := 34, target := 52, scalar := 1 },{ source := 52, target := 1, scalar := 1 },{ source := 67, target := 0, scalar := 1 },{ source := 231, target := 89, scalar := 10 }] }
theorem rowR6_0000_001_13_valid : (rowR6_0000_001_13).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_14 : ExtensionRow := { move := 233, child := 0, matrix := ![1,1,1,1,2,3,1,3,2], witnesses := [{ source := 0, target := 67, scalar := 1 },{ source := 1, target := 52, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 0, scalar := 1 },{ source := 67, target := 1, scalar := 1 },{ source := 233, target := 89, scalar := 4 }] }
theorem rowR6_0000_001_14_valid : (rowR6_0000_001_14).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_15 : ExtensionRow := { move := 235, child := 3, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 67, target := 67, scalar := 1 },{ source := 235, target := 159, scalar := 7 }] }
theorem rowR6_0000_001_15_valid : (rowR6_0000_001_15).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_16 : ExtensionRow := { move := 239, child := 1, matrix := ![0,1,1,1,1,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 67, scalar := 1 },{ source := 67, target := 52, scalar := 1 },{ source := 239, target := 91, scalar := 3 }] }
theorem rowR6_0000_001_16_valid : (rowR6_0000_001_16).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_17 : ExtensionRow := { move := 240, child := 1, matrix := ![1,1,1,3,0,1,2,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 67, scalar := 1 },{ source := 34, target := 52, scalar := 1 },{ source := 52, target := 0, scalar := 1 },{ source := 67, target := 1, scalar := 1 },{ source := 240, target := 91, scalar := 3 }] }
theorem rowR6_0000_001_17_valid : (rowR6_0000_001_17).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_18 : ExtensionRow := { move := 245, child := 0, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 67, target := 67, scalar := 1 },{ source := 245, target := 89, scalar := 10 }] }
theorem rowR6_0000_001_18_valid : (rowR6_0000_001_18).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_19 : ExtensionRow := { move := 247, child := 2, matrix := ![0,1,1,0,0,1,1,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 67, scalar := 1 },{ source := 67, target := 52, scalar := 1 },{ source := 247, target := 92, scalar := 8 }] }
theorem rowR6_0000_001_19_valid : (rowR6_0000_001_19).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_20 : ExtensionRow := { move := 248, child := 1, matrix := ![1,1,1,0,2,3,0,3,2], witnesses := [{ source := 0, target := 67, scalar := 1 },{ source := 1, target := 52, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 1, scalar := 1 },{ source := 67, target := 0, scalar := 1 },{ source := 248, target := 91, scalar := 8 }] }
theorem rowR6_0000_001_20_valid : (rowR6_0000_001_20).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_21 : ExtensionRow := { move := 249, child := 3, matrix := ![1,1,1,3,1,0,2,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 67, scalar := 1 },{ source := 34, target := 52, scalar := 1 },{ source := 52, target := 1, scalar := 1 },{ source := 67, target := 0, scalar := 1 },{ source := 249, target := 159, scalar := 7 }] }
theorem rowR6_0000_001_21_valid : (rowR6_0000_001_21).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_22 : ExtensionRow := { move := 251, child := 0, matrix := ![0,1,1,1,2,3,0,3,2], witnesses := [{ source := 0, target := 67, scalar := 1 },{ source := 1, target := 52, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 17, scalar := 1 },{ source := 67, target := 34, scalar := 1 },{ source := 251, target := 89, scalar := 4 }] }
theorem rowR6_0000_001_22_valid : (rowR6_0000_001_22).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_23 : ExtensionRow := { move := 253, child := 1, matrix := ![1,1,1,2,1,0,3,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 1 },{ source := 34, target := 67, scalar := 1 },{ source := 52, target := 0, scalar := 1 },{ source := 67, target := 1, scalar := 1 },{ source := 253, target := 91, scalar := 3 }] }
theorem rowR6_0000_001_23_valid : (rowR6_0000_001_23).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_24 : ExtensionRow := { move := 254, child := 1, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 67, target := 67, scalar := 1 },{ source := 254, target := 91, scalar := 3 }] }
theorem rowR6_0000_001_24_valid : (rowR6_0000_001_24).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_25 : ExtensionRow := { move := 262, child := 0, matrix := ![0,1,1,1,1,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 67, scalar := 1 },{ source := 67, target := 52, scalar := 1 },{ source := 262, target := 89, scalar := 10 }] }
theorem rowR6_0000_001_25_valid : (rowR6_0000_001_25).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_26 : ExtensionRow := { move := 263, child := 1, matrix := ![1,1,1,1,2,3,1,3,2], witnesses := [{ source := 0, target := 67, scalar := 1 },{ source := 1, target := 52, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 0, scalar := 1 },{ source := 67, target := 1, scalar := 1 },{ source := 263, target := 91, scalar := 8 }] }
theorem rowR6_0000_001_26_valid : (rowR6_0000_001_26).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_27 : ExtensionRow := { move := 264, child := 2, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 67, target := 67, scalar := 1 },{ source := 264, target := 92, scalar := 8 }] }
theorem rowR6_0000_001_27_valid : (rowR6_0000_001_27).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_28 : ExtensionRow := { move := 266, child := 3, matrix := ![1,1,1,2,1,0,3,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 1 },{ source := 34, target := 67, scalar := 1 },{ source := 52, target := 0, scalar := 1 },{ source := 67, target := 1, scalar := 1 },{ source := 266, target := 159, scalar := 7 }] }
theorem rowR6_0000_001_28_valid : (rowR6_0000_001_28).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_29 : ExtensionRow := { move := 268, child := 0, matrix := ![0,1,1,0,2,3,1,3,2], witnesses := [{ source := 0, target := 67, scalar := 1 },{ source := 1, target := 52, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 34, scalar := 1 },{ source := 67, target := 17, scalar := 1 },{ source := 268, target := 89, scalar := 4 }] }
theorem rowR6_0000_001_29_valid : (rowR6_0000_001_29).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_30 : ExtensionRow := { move := 269, child := 1, matrix := ![0,1,1,0,0,1,1,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 67, scalar := 1 },{ source := 67, target := 52, scalar := 1 },{ source := 269, target := 91, scalar := 3 }] }
theorem rowR6_0000_001_30_valid : (rowR6_0000_001_30).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_001_31 : ExtensionRow := { move := 270, child := 1, matrix := ![1,1,1,3,1,0,2,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 67, scalar := 1 },{ source := 34, target := 52, scalar := 1 },{ source := 52, target := 1, scalar := 1 },{ source := 67, target := 0, scalar := 1 },{ source := 270, target := 91, scalar := 3 }] }
theorem rowR6_0000_001_31_valid : (rowR6_0000_001_31).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowsR6_0000_001 : List ExtensionRow := [rowR6_0000_001_0,rowR6_0000_001_1,rowR6_0000_001_2,rowR6_0000_001_3,rowR6_0000_001_4,rowR6_0000_001_5,rowR6_0000_001_6,rowR6_0000_001_7,rowR6_0000_001_8,rowR6_0000_001_9,rowR6_0000_001_10,rowR6_0000_001_11,rowR6_0000_001_12,rowR6_0000_001_13,rowR6_0000_001_14,rowR6_0000_001_15,rowR6_0000_001_16,rowR6_0000_001_17,rowR6_0000_001_18,rowR6_0000_001_19,rowR6_0000_001_20,rowR6_0000_001_21,rowR6_0000_001_22,rowR6_0000_001_23,rowR6_0000_001_24,rowR6_0000_001_25,rowR6_0000_001_26,rowR6_0000_001_27,rowR6_0000_001_28,rowR6_0000_001_29,rowR6_0000_001_30,rowR6_0000_001_31]

theorem rowsR6_0000_001_valid : RowListValid level7 {0,1,17,34,52,67} rowsR6_0000_001 := by
  intro r hr
  simp only [rowsR6_0000_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR6_0000_001_0_valid
  · exact rowR6_0000_001_1_valid
  · exact rowR6_0000_001_2_valid
  · exact rowR6_0000_001_3_valid
  · exact rowR6_0000_001_4_valid
  · exact rowR6_0000_001_5_valid
  · exact rowR6_0000_001_6_valid
  · exact rowR6_0000_001_7_valid
  · exact rowR6_0000_001_8_valid
  · exact rowR6_0000_001_9_valid
  · exact rowR6_0000_001_10_valid
  · exact rowR6_0000_001_11_valid
  · exact rowR6_0000_001_12_valid
  · exact rowR6_0000_001_13_valid
  · exact rowR6_0000_001_14_valid
  · exact rowR6_0000_001_15_valid
  · exact rowR6_0000_001_16_valid
  · exact rowR6_0000_001_17_valid
  · exact rowR6_0000_001_18_valid
  · exact rowR6_0000_001_19_valid
  · exact rowR6_0000_001_20_valid
  · exact rowR6_0000_001_21_valid
  · exact rowR6_0000_001_22_valid
  · exact rowR6_0000_001_23_valid
  · exact rowR6_0000_001_24_valid
  · exact rowR6_0000_001_25_valid
  · exact rowR6_0000_001_26_valid
  · exact rowR6_0000_001_27_valid
  · exact rowR6_0000_001_28_valid
  · exact rowR6_0000_001_29_valid
  · exact rowR6_0000_001_30_valid
  · exact rowR6_0000_001_31_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
