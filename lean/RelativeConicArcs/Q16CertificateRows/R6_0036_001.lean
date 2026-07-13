import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR6_0036_001_0 : ExtensionRow := { move := 183, child := 196, matrix := ![0,0,1,0,1,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 271, scalar := 3 },{ source := 183, target := 72, scalar := 6 },{ source := 271, target := 52, scalar := 14 }] }
theorem rowR6_0036_001_0_valid : (rowR6_0036_001_0).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_1 : ExtensionRow := { move := 184, child := 196, matrix := ![12,0,4,8,0,8,4,8,12], witnesses := [{ source := 0, target := 52, scalar := 4 },{ source := 1, target := 0, scalar := 8 },{ source := 17, target := 271, scalar := 12 },{ source := 34, target := 17, scalar := 8 },{ source := 52, target := 1, scalar := 3 },{ source := 184, target := 72, scalar := 3 },{ source := 271, target := 34, scalar := 1 }] }
theorem rowR6_0036_001_1_valid : (rowR6_0036_001_1).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_2 : ExtensionRow := { move := 185, child := 375, matrix := ![4,8,12,8,0,8,12,0,4], witnesses := [{ source := 0, target := 271, scalar := 12 },{ source := 1, target := 17, scalar := 8 },{ source := 17, target := 52, scalar := 4 },{ source := 34, target := 0, scalar := 8 },{ source := 52, target := 1, scalar := 3 },{ source := 185, target := 91, scalar := 1 },{ source := 271, target := 34, scalar := 1 }] }
theorem rowR6_0036_001_2_valid : (rowR6_0036_001_2).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_3 : ExtensionRow := { move := 186, child := 137, matrix := ![0,0,1,1,0,1,0,1,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 271, scalar := 3 },{ source := 186, target := 71, scalar := 9 },{ source := 271, target := 52, scalar := 14 }] }
theorem rowR6_0036_001_3_valid : (rowR6_0036_001_3).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_4 : ExtensionRow := { move := 189, child := 50, matrix := ![4,10,1,12,0,1,3,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 10 },{ source := 17, target := 69, scalar := 4 },{ source := 34, target := 52, scalar := 15 },{ source := 52, target := 1, scalar := 15 },{ source := 189, target := 0, scalar := 15 },{ source := 271, target := 246, scalar := 6 }] }
theorem rowR6_0036_001_4_valid : (rowR6_0036_001_4).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_5 : ExtensionRow := { move := 190, child := 50, matrix := ![1,14,15,2,11,0,3,3,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 246, scalar := 14 },{ source := 17, target := 52, scalar := 1 },{ source := 34, target := 1, scalar := 9 },{ source := 52, target := 69, scalar := 12 },{ source := 190, target := 0, scalar := 14 },{ source := 271, target := 34, scalar := 1 }] }
theorem rowR6_0036_001_5_valid : (rowR6_0036_001_5).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_6 : ExtensionRow := { move := 195, child := 196, matrix := ![8,0,9,1,1,1,9,0,8], witnesses := [{ source := 0, target := 52, scalar := 9 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 271, scalar := 8 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 0, scalar := 2 },{ source := 195, target := 72, scalar := 9 },{ source := 271, target := 17, scalar := 15 }] }
theorem rowR6_0036_001_6_valid : (rowR6_0036_001_6).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_7 : ExtensionRow := { move := 197, child := 50, matrix := ![4,0,1,12,14,1,3,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 1, scalar := 14 },{ source := 17, target := 69, scalar := 4 },{ source := 34, target := 246, scalar := 5 },{ source := 52, target := 17, scalar := 7 },{ source := 197, target := 0, scalar := 7 },{ source := 271, target := 52, scalar := 10 }] }
theorem rowR6_0036_001_7_valid : (rowR6_0036_001_7).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_8 : ExtensionRow := { move := 198, child := 375, matrix := ![9,4,0,0,9,0,0,13,9], witnesses := [{ source := 0, target := 0, scalar := 9 },{ source := 1, target := 271, scalar := 4 },{ source := 17, target := 17, scalar := 9 },{ source := 34, target := 52, scalar := 13 },{ source := 52, target := 34, scalar := 1 },{ source := 198, target := 91, scalar := 3 },{ source := 271, target := 1, scalar := 14 }] }
theorem rowR6_0036_001_8_valid : (rowR6_0036_001_8).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_9 : ExtensionRow := { move := 201, child := 137, matrix := ![0,8,1,1,1,1,0,9,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 271, scalar := 8 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 52, scalar := 9 },{ source := 52, target := 0, scalar := 2 },{ source := 201, target := 71, scalar := 15 },{ source := 271, target := 17, scalar := 15 }] }
theorem rowR6_0036_001_9_valid : (rowR6_0036_001_9).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_10 : ExtensionRow := { move := 202, child := 50, matrix := ![15,4,10,13,12,0,2,3,0], witnesses := [{ source := 0, target := 17, scalar := 10 },{ source := 1, target := 69, scalar := 4 },{ source := 17, target := 52, scalar := 15 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 246, scalar := 10 },{ source := 202, target := 0, scalar := 12 },{ source := 271, target := 1, scalar := 5 }] }
theorem rowR6_0036_001_10_valid : (rowR6_0036_001_10).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_11 : ExtensionRow := { move := 208, child := 196, matrix := ![0,12,8,0,8,0,8,4,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 271, scalar := 12 },{ source := 17, target := 0, scalar := 8 },{ source := 34, target := 52, scalar := 4 },{ source := 52, target := 1, scalar := 3 },{ source := 208, target := 72, scalar := 12 },{ source := 271, target := 34, scalar := 1 }] }
theorem rowR6_0036_001_11_valid : (rowR6_0036_001_11).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_12 : ExtensionRow := { move := 211, child := 137, matrix := ![0,13,9,0,9,0,9,4,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 52, scalar := 13 },{ source := 17, target := 0, scalar := 9 },{ source := 34, target := 271, scalar := 4 },{ source := 52, target := 34, scalar := 1 },{ source := 211, target := 71, scalar := 2 },{ source := 271, target := 1, scalar := 14 }] }
theorem rowR6_0036_001_12_valid : (rowR6_0036_001_12).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_13 : ExtensionRow := { move := 213, child := 137, matrix := ![4,8,12,8,0,8,12,0,4], witnesses := [{ source := 0, target := 271, scalar := 12 },{ source := 1, target := 17, scalar := 8 },{ source := 17, target := 52, scalar := 4 },{ source := 34, target := 0, scalar := 8 },{ source := 52, target := 1, scalar := 3 },{ source := 213, target := 71, scalar := 11 },{ source := 271, target := 34, scalar := 1 }] }
theorem rowR6_0036_001_13_valid : (rowR6_0036_001_13).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_14 : ExtensionRow := { move := 214, child := 50, matrix := ![10,1,15,0,1,13,0,1,2], witnesses := [{ source := 0, target := 52, scalar := 15 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 17, scalar := 10 },{ source := 34, target := 69, scalar := 4 },{ source := 52, target := 246, scalar := 10 },{ source := 214, target := 0, scalar := 6 },{ source := 271, target := 1, scalar := 5 }] }
theorem rowR6_0036_001_14_valid : (rowR6_0036_001_14).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_15 : ExtensionRow := { move := 216, child := 50, matrix := ![5,4,0,3,12,14,2,3,0], witnesses := [{ source := 0, target := 1, scalar := 14 },{ source := 1, target := 69, scalar := 4 },{ source := 17, target := 246, scalar := 5 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 13 },{ source := 216, target := 0, scalar := 5 },{ source := 271, target := 17, scalar := 12 }] }
theorem rowR6_0036_001_15_valid : (rowR6_0036_001_15).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_16 : ExtensionRow := { move := 218, child := 196, matrix := ![9,0,8,1,1,1,8,0,9], witnesses := [{ source := 0, target := 271, scalar := 8 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 52, scalar := 9 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 17, scalar := 2 },{ source := 218, target := 72, scalar := 13 },{ source := 271, target := 0, scalar := 15 }] }
theorem rowR6_0036_001_16_valid : (rowR6_0036_001_16).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_17 : ExtensionRow := { move := 220, child := 50, matrix := ![0,15,14,9,0,11,0,0,3], witnesses := [{ source := 0, target := 246, scalar := 14 },{ source := 1, target := 17, scalar := 15 },{ source := 17, target := 1, scalar := 9 },{ source := 34, target := 52, scalar := 1 },{ source := 52, target := 69, scalar := 12 },{ source := 220, target := 0, scalar := 14 },{ source := 271, target := 34, scalar := 1 }] }
theorem rowR6_0036_001_17_valid : (rowR6_0036_001_17).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_18 : ExtensionRow := { move := 224, child := 375, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 224, target := 91, scalar := 3 },{ source := 271, target := 271, scalar := 1 }] }
theorem rowR6_0036_001_18_valid : (rowR6_0036_001_18).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_19 : ExtensionRow := { move := 229, child := 375, matrix := ![1,1,0,1,0,1,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 271, scalar := 3 },{ source := 229, target := 91, scalar := 12 },{ source := 271, target := 52, scalar := 14 }] }
theorem rowR6_0036_001_19_valid : (rowR6_0036_001_19).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_20 : ExtensionRow := { move := 230, child := 196, matrix := ![0,13,9,0,9,0,9,4,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 52, scalar := 13 },{ source := 17, target := 0, scalar := 9 },{ source := 34, target := 271, scalar := 4 },{ source := 52, target := 34, scalar := 1 },{ source := 230, target := 72, scalar := 5 },{ source := 271, target := 1, scalar := 14 }] }
theorem rowR6_0036_001_20_valid : (rowR6_0036_001_20).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_21 : ExtensionRow := { move := 231, child := 196, matrix := ![8,1,9,1,1,1,9,1,8], witnesses := [{ source := 0, target := 52, scalar := 9 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 271, scalar := 8 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 17, scalar := 2 },{ source := 231, target := 72, scalar := 6 },{ source := 271, target := 0, scalar := 15 }] }
theorem rowR6_0036_001_21_valid : (rowR6_0036_001_21).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_22 : ExtensionRow := { move := 232, child := 137, matrix := ![0,9,1,1,1,1,0,8,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 52, scalar := 9 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 271, scalar := 8 },{ source := 52, target := 17, scalar := 2 },{ source := 232, target := 71, scalar := 8 },{ source := 271, target := 0, scalar := 15 }] }
theorem rowR6_0036_001_22_valid : (rowR6_0036_001_22).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_23 : ExtensionRow := { move := 233, child := 50, matrix := ![4,5,1,12,3,1,3,2,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 246, scalar := 5 },{ source := 17, target := 69, scalar := 4 },{ source := 34, target := 1, scalar := 14 },{ source := 52, target := 52, scalar := 13 },{ source := 233, target := 0, scalar := 2 },{ source := 271, target := 17, scalar := 12 }] }
theorem rowR6_0036_001_23_valid : (rowR6_0036_001_23).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_24 : ExtensionRow := { move := 236, child := 50, matrix := ![15,1,10,13,1,0,2,1,0], witnesses := [{ source := 0, target := 17, scalar := 10 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 15 },{ source := 34, target := 69, scalar := 4 },{ source := 52, target := 1, scalar := 15 },{ source := 236, target := 0, scalar := 15 },{ source := 271, target := 246, scalar := 6 }] }
theorem rowR6_0036_001_24_valid : (rowR6_0036_001_24).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_25 : ExtensionRow := { move := 243, child := 137, matrix := ![9,0,8,1,1,1,8,0,9], witnesses := [{ source := 0, target := 271, scalar := 8 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 52, scalar := 9 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 17, scalar := 2 },{ source := 243, target := 71, scalar := 10 },{ source := 271, target := 0, scalar := 15 }] }
theorem rowR6_0036_001_25_valid : (rowR6_0036_001_25).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_26 : ExtensionRow := { move := 245, child := 50, matrix := ![5,11,14,0,8,15,0,1,1], witnesses := [{ source := 0, target := 52, scalar := 14 },{ source := 1, target := 246, scalar := 11 },{ source := 17, target := 17, scalar := 5 },{ source := 34, target := 1, scalar := 7 },{ source := 52, target := 34, scalar := 1 },{ source := 245, target := 0, scalar := 10 },{ source := 271, target := 69, scalar := 13 }] }
theorem rowR6_0036_001_26_valid : (rowR6_0036_001_26).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_27 : ExtensionRow := { move := 246, child := 137, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 246, target := 71, scalar := 11 },{ source := 271, target := 271, scalar := 1 }] }
theorem rowR6_0036_001_27_valid : (rowR6_0036_001_27).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_28 : ExtensionRow := { move := 247, child := 50, matrix := ![0,4,5,14,12,3,0,3,2], witnesses := [{ source := 0, target := 246, scalar := 5 },{ source := 1, target := 69, scalar := 4 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 17, scalar := 7 },{ source := 247, target := 0, scalar := 13 },{ source := 271, target := 52, scalar := 10 }] }
theorem rowR6_0036_001_28_valid : (rowR6_0036_001_28).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_29 : ExtensionRow := { move := 249, child := 50, matrix := ![14,1,0,11,2,9,3,3,0], witnesses := [{ source := 0, target := 1, scalar := 9 },{ source := 1, target := 52, scalar := 1 },{ source := 17, target := 246, scalar := 14 },{ source := 34, target := 17, scalar := 15 },{ source := 52, target := 69, scalar := 12 },{ source := 249, target := 0, scalar := 2 },{ source := 271, target := 34, scalar := 1 }] }
theorem rowR6_0036_001_29_valid : (rowR6_0036_001_29).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_30 : ExtensionRow := { move := 251, child := 196, matrix := ![4,8,12,8,0,8,12,0,4], witnesses := [{ source := 0, target := 271, scalar := 12 },{ source := 1, target := 17, scalar := 8 },{ source := 17, target := 52, scalar := 4 },{ source := 34, target := 0, scalar := 8 },{ source := 52, target := 1, scalar := 3 },{ source := 251, target := 72, scalar := 12 },{ source := 271, target := 34, scalar := 1 }] }
theorem rowR6_0036_001_30_valid : (rowR6_0036_001_30).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_001_31 : ExtensionRow := { move := 254, child := 375, matrix := ![0,13,9,0,9,0,9,4,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 52, scalar := 13 },{ source := 17, target := 0, scalar := 9 },{ source := 34, target := 271, scalar := 4 },{ source := 52, target := 34, scalar := 1 },{ source := 254, target := 91, scalar := 5 },{ source := 271, target := 1, scalar := 14 }] }
theorem rowR6_0036_001_31_valid : (rowR6_0036_001_31).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowsR6_0036_001 : List ExtensionRow := [rowR6_0036_001_0,rowR6_0036_001_1,rowR6_0036_001_2,rowR6_0036_001_3,rowR6_0036_001_4,rowR6_0036_001_5,rowR6_0036_001_6,rowR6_0036_001_7,rowR6_0036_001_8,rowR6_0036_001_9,rowR6_0036_001_10,rowR6_0036_001_11,rowR6_0036_001_12,rowR6_0036_001_13,rowR6_0036_001_14,rowR6_0036_001_15,rowR6_0036_001_16,rowR6_0036_001_17,rowR6_0036_001_18,rowR6_0036_001_19,rowR6_0036_001_20,rowR6_0036_001_21,rowR6_0036_001_22,rowR6_0036_001_23,rowR6_0036_001_24,rowR6_0036_001_25,rowR6_0036_001_26,rowR6_0036_001_27,rowR6_0036_001_28,rowR6_0036_001_29,rowR6_0036_001_30,rowR6_0036_001_31]

theorem rowsR6_0036_001_valid : RowListValid level7 {0,1,17,34,52,271} rowsR6_0036_001 := by
  intro r hr
  simp only [rowsR6_0036_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR6_0036_001_0_valid
  · exact rowR6_0036_001_1_valid
  · exact rowR6_0036_001_2_valid
  · exact rowR6_0036_001_3_valid
  · exact rowR6_0036_001_4_valid
  · exact rowR6_0036_001_5_valid
  · exact rowR6_0036_001_6_valid
  · exact rowR6_0036_001_7_valid
  · exact rowR6_0036_001_8_valid
  · exact rowR6_0036_001_9_valid
  · exact rowR6_0036_001_10_valid
  · exact rowR6_0036_001_11_valid
  · exact rowR6_0036_001_12_valid
  · exact rowR6_0036_001_13_valid
  · exact rowR6_0036_001_14_valid
  · exact rowR6_0036_001_15_valid
  · exact rowR6_0036_001_16_valid
  · exact rowR6_0036_001_17_valid
  · exact rowR6_0036_001_18_valid
  · exact rowR6_0036_001_19_valid
  · exact rowR6_0036_001_20_valid
  · exact rowR6_0036_001_21_valid
  · exact rowR6_0036_001_22_valid
  · exact rowR6_0036_001_23_valid
  · exact rowR6_0036_001_24_valid
  · exact rowR6_0036_001_25_valid
  · exact rowR6_0036_001_26_valid
  · exact rowR6_0036_001_27_valid
  · exact rowR6_0036_001_28_valid
  · exact rowR6_0036_001_29_valid
  · exact rowR6_0036_001_30_valid
  · exact rowR6_0036_001_31_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
