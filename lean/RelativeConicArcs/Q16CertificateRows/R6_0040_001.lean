import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR6_0040_001_0 : ExtensionRow := { move := 199, child := 181, matrix := ![7,0,6,0,11,10,0,0,1], witnesses := [{ source := 0, target := 72, scalar := 6 },{ source := 1, target := 1, scalar := 11 },{ source := 17, target := 17, scalar := 7 },{ source := 34, target := 34, scalar := 1 },{ source := 54, target := 218, scalar := 10 },{ source := 108, target := 52, scalar := 8 },{ source := 199, target := 0, scalar := 6 }] }
theorem rowR6_0040_001_0_valid : (rowR6_0040_001_0).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_1 : ExtensionRow := { move := 200, child := 7, matrix := ![0,1,0,0,1,2,5,1,0], witnesses := [{ source := 0, target := 1, scalar := 2 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 5 },{ source := 34, target := 69, scalar := 1 },{ source := 54, target := 91, scalar := 2 },{ source := 108, target := 17, scalar := 5 },{ source := 200, target := 52, scalar := 11 }] }
theorem rowR6_0040_001_1_valid : (rowR6_0040_001_1).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_2 : ExtensionRow := { move := 201, child := 86, matrix := ![1,10,2,1,7,6,1,13,12], witnesses := [{ source := 0, target := 71, scalar := 2 },{ source := 1, target := 52, scalar := 10 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 9 },{ source := 54, target := 139, scalar := 12 },{ source := 108, target := 1, scalar := 6 },{ source := 201, target := 0, scalar := 13 }] }
theorem rowR6_0040_001_2_valid : (rowR6_0040_001_2).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_3 : ExtensionRow := { move := 206, child := 86, matrix := ![5,0,7,10,10,6,15,0,3], witnesses := [{ source := 0, target := 139, scalar := 7 },{ source := 1, target := 1, scalar := 10 },{ source := 17, target := 52, scalar := 5 },{ source := 34, target := 71, scalar := 2 },{ source := 54, target := 17, scalar := 13 },{ source := 108, target := 34, scalar := 1 },{ source := 206, target := 0, scalar := 11 }] }
theorem rowR6_0040_001_3_valid : (rowR6_0040_001_3).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_4 : ExtensionRow := { move := 207, child := 181, matrix := ![1,14,8,1,0,3,1,0,11], witnesses := [{ source := 0, target := 52, scalar := 8 },{ source := 1, target := 17, scalar := 14 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 218, scalar := 7 },{ source := 54, target := 1, scalar := 14 },{ source := 108, target := 72, scalar := 5 },{ source := 207, target := 0, scalar := 9 }] }
theorem rowR6_0040_001_4_valid : (rowR6_0040_001_4).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_5 : ExtensionRow := { move := 208, child := 181, matrix := ![2,12,1,11,7,1,1,2,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 72, scalar := 12 },{ source := 17, target := 218, scalar := 2 },{ source := 34, target := 52, scalar := 15 },{ source := 54, target := 17, scalar := 12 },{ source := 108, target := 1, scalar := 8 },{ source := 208, target := 0, scalar := 11 }] }
theorem rowR6_0040_001_5_valid : (rowR6_0040_001_5).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_6 : ExtensionRow := { move := 211, child := 181, matrix := ![11,1,10,14,1,1,4,1,5], witnesses := [{ source := 0, target := 218, scalar := 10 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 72, scalar := 11 },{ source := 34, target := 1, scalar := 14 },{ source := 54, target := 52, scalar := 13 },{ source := 108, target := 17, scalar := 12 },{ source := 211, target := 0, scalar := 2 }] }
theorem rowR6_0040_001_6_valid : (rowR6_0040_001_6).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_7 : ExtensionRow := { move := 212, child := 430, matrix := ![0,14,3,6,3,0,0,10,0], witnesses := [{ source := 0, target := 17, scalar := 3 },{ source := 1, target := 110, scalar := 14 },{ source := 17, target := 1, scalar := 6 },{ source := 34, target := 143, scalar := 13 },{ source := 54, target := 0, scalar := 7 },{ source := 108, target := 52, scalar := 13 },{ source := 212, target := 34, scalar := 1 }] }
theorem rowR6_0040_001_7_valid : (rowR6_0040_001_7).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_8 : ExtensionRow := { move := 213, child := 7, matrix := ![9,1,9,2,1,0,5,1,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 91, scalar := 9 },{ source := 34, target := 69, scalar := 1 },{ source := 54, target := 0, scalar := 7 },{ source := 108, target := 1, scalar := 7 },{ source := 213, target := 52, scalar := 7 }] }
theorem rowR6_0040_001_8_valid : (rowR6_0040_001_8).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_9 : ExtensionRow := { move := 217, child := 181, matrix := ![11,2,0,13,4,1,12,6,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 52, scalar := 2 },{ source := 17, target := 218, scalar := 11 },{ source := 34, target := 72, scalar := 9 },{ source := 54, target := 17, scalar := 15 },{ source := 108, target := 34, scalar := 1 },{ source := 217, target := 0, scalar := 2 }] }
theorem rowR6_0040_001_9_valid : (rowR6_0040_001_9).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_10 : ExtensionRow := { move := 218, child := 86, matrix := ![5,4,0,10,15,4,15,14,0], witnesses := [{ source := 0, target := 1, scalar := 4 },{ source := 1, target := 139, scalar := 4 },{ source := 17, target := 52, scalar := 5 },{ source := 34, target := 34, scalar := 1 },{ source := 54, target := 17, scalar := 13 },{ source := 108, target := 71, scalar := 2 },{ source := 218, target := 0, scalar := 11 }] }
theorem rowR6_0040_001_10_valid : (rowR6_0040_001_10).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_11 : ExtensionRow := { move := 223, child := 7, matrix := ![12,13,1,0,1,1,0,11,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 91, scalar := 13 },{ source := 17, target := 17, scalar := 12 },{ source := 34, target := 0, scalar := 10 },{ source := 54, target := 1, scalar := 7 },{ source := 108, target := 69, scalar := 11 },{ source := 223, target := 52, scalar := 1 }] }
theorem rowR6_0040_001_11_valid : (rowR6_0040_001_11).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_12 : ExtensionRow := { move := 228, child := 7, matrix := ![0,0,1,5,0,1,0,11,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 0, scalar := 11 },{ source := 17, target := 1, scalar := 5 },{ source := 34, target := 91, scalar := 1 },{ source := 54, target := 17, scalar := 5 },{ source := 108, target := 69, scalar := 11 },{ source := 228, target := 52, scalar := 3 }] }
theorem rowR6_0040_001_12_valid : (rowR6_0040_001_12).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_13 : ExtensionRow := { move := 229, child := 181, matrix := ![10,0,11,7,11,13,13,0,12], witnesses := [{ source := 0, target := 218, scalar := 11 },{ source := 1, target := 1, scalar := 11 },{ source := 17, target := 52, scalar := 10 },{ source := 34, target := 34, scalar := 1 },{ source := 54, target := 72, scalar := 11 },{ source := 108, target := 17, scalar := 3 },{ source := 229, target := 0, scalar := 8 }] }
theorem rowR6_0040_001_13_valid : (rowR6_0040_001_13).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_14 : ExtensionRow := { move := 232, child := 430, matrix := ![0,11,1,0,4,0,3,8,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 143, scalar := 11 },{ source := 17, target := 0, scalar := 3 },{ source := 34, target := 110, scalar := 10 },{ source := 54, target := 1, scalar := 8 },{ source := 108, target := 52, scalar := 10 },{ source := 232, target := 34, scalar := 1 }] }
theorem rowR6_0040_001_14_valid : (rowR6_0040_001_14).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_15 : ExtensionRow := { move := 234, child := 181, matrix := ![7,15,0,0,2,1,0,11,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 72, scalar := 15 },{ source := 17, target := 17, scalar := 7 },{ source := 34, target := 52, scalar := 8 },{ source := 54, target := 218, scalar := 10 },{ source := 108, target := 34, scalar := 1 },{ source := 234, target := 0, scalar := 6 }] }
theorem rowR6_0040_001_15_valid : (rowR6_0040_001_15).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_16 : ExtensionRow := { move := 235, child := 86, matrix := ![13,1,0,0,1,3,0,1,0], witnesses := [{ source := 0, target := 1, scalar := 3 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 17, scalar := 13 },{ source := 34, target := 139, scalar := 12 },{ source := 54, target := 52, scalar := 15 },{ source := 108, target := 71, scalar := 8 },{ source := 235, target := 0, scalar := 13 }] }
theorem rowR6_0040_001_16_valid : (rowR6_0040_001_16).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_17 : ExtensionRow := { move := 239, child := 7, matrix := ![0,14,15,0,1,0,12,13,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 69, scalar := 14 },{ source := 17, target := 0, scalar := 12 },{ source := 34, target := 34, scalar := 1 },{ source := 54, target := 91, scalar := 9 },{ source := 108, target := 1, scalar := 5 },{ source := 239, target := 52, scalar := 15 }] }
theorem rowR6_0040_001_17_valid : (rowR6_0040_001_17).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_18 : ExtensionRow := { move := 244, child := 181, matrix := ![8,14,1,3,0,1,11,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 14 },{ source := 17, target := 52, scalar := 8 },{ source := 34, target := 218, scalar := 7 },{ source := 54, target := 72, scalar := 2 },{ source := 108, target := 1, scalar := 8 },{ source := 244, target := 0, scalar := 8 }] }
theorem rowR6_0040_001_18_valid : (rowR6_0040_001_18).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_19 : ExtensionRow := { move := 245, child := 181, matrix := ![1,5,9,1,9,8,1,11,10], witnesses := [{ source := 0, target := 72, scalar := 9 },{ source := 1, target := 218, scalar := 5 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 13 },{ source := 54, target := 1, scalar := 14 },{ source := 108, target := 52, scalar := 15 },{ source := 245, target := 0, scalar := 7 }] }
theorem rowR6_0040_001_19_valid : (rowR6_0040_001_19).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_20 : ExtensionRow := { move := 250, child := 86, matrix := ![1,5,4,1,15,8,1,13,12], witnesses := [{ source := 0, target := 52, scalar := 4 },{ source := 1, target := 71, scalar := 5 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 6 },{ source := 54, target := 139, scalar := 12 },{ source := 108, target := 17, scalar := 9 },{ source := 250, target := 0, scalar := 13 }] }
theorem rowR6_0040_001_20_valid : (rowR6_0040_001_20).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_21 : ExtensionRow := { move := 251, child := 7, matrix := ![14,14,0,1,13,12,13,6,0], witnesses := [{ source := 0, target := 1, scalar := 12 },{ source := 1, target := 91, scalar := 14 },{ source := 17, target := 69, scalar := 14 },{ source := 34, target := 0, scalar := 11 },{ source := 54, target := 34, scalar := 1 },{ source := 108, target := 17, scalar := 13 },{ source := 251, target := 52, scalar := 5 }] }
theorem rowR6_0040_001_21_valid : (rowR6_0040_001_21).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_22 : ExtensionRow := { move := 253, child := 86, matrix := ![11,8,7,14,0,6,15,0,3], witnesses := [{ source := 0, target := 139, scalar := 7 },{ source := 1, target := 17, scalar := 8 },{ source := 17, target := 71, scalar := 11 },{ source := 34, target := 52, scalar := 4 },{ source := 54, target := 1, scalar := 3 },{ source := 108, target := 34, scalar := 1 },{ source := 253, target := 0, scalar := 8 }] }
theorem rowR6_0040_001_22_valid : (rowR6_0040_001_22).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_23 : ExtensionRow := { move := 254, child := 181, matrix := ![11,0,10,13,11,7,12,0,13], witnesses := [{ source := 0, target := 52, scalar := 10 },{ source := 1, target := 1, scalar := 11 },{ source := 17, target := 218, scalar := 11 },{ source := 34, target := 34, scalar := 1 },{ source := 54, target := 17, scalar := 15 },{ source := 108, target := 72, scalar := 9 },{ source := 254, target := 0, scalar := 2 }] }
theorem rowR6_0040_001_23_valid : (rowR6_0040_001_23).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_24 : ExtensionRow := { move := 256, child := 86, matrix := ![14,4,11,0,15,14,0,14,15], witnesses := [{ source := 0, target := 71, scalar := 11 },{ source := 1, target := 139, scalar := 4 },{ source := 17, target := 17, scalar := 14 },{ source := 34, target := 34, scalar := 1 },{ source := 54, target := 52, scalar := 7 },{ source := 108, target := 1, scalar := 14 },{ source := 256, target := 0, scalar := 1 }] }
theorem rowR6_0040_001_24_valid : (rowR6_0040_001_24).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_25 : ExtensionRow := { move := 259, child := 86, matrix := ![4,5,1,8,15,1,12,13,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 71, scalar := 5 },{ source := 17, target := 52, scalar := 4 },{ source := 34, target := 1, scalar := 6 },{ source := 54, target := 17, scalar := 11 },{ source := 108, target := 139, scalar := 13 },{ source := 259, target := 0, scalar := 9 }] }
theorem rowR6_0040_001_25_valid : (rowR6_0040_001_25).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_26 : ExtensionRow := { move := 261, child := 7, matrix := ![1,13,12,1,0,5,1,0,1], witnesses := [{ source := 0, target := 91, scalar := 12 },{ source := 1, target := 17, scalar := 13 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 4 },{ source := 54, target := 69, scalar := 1 },{ source := 108, target := 0, scalar := 10 },{ source := 261, target := 52, scalar := 3 }] }
theorem rowR6_0040_001_26_valid : (rowR6_0040_001_26).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_27 : ExtensionRow := { move := 263, child := 7, matrix := ![0,1,0,2,1,0,0,1,5], witnesses := [{ source := 0, target := 0, scalar := 5 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 2 },{ source := 34, target := 69, scalar := 1 },{ source := 54, target := 17, scalar := 2 },{ source := 108, target := 91, scalar := 5 },{ source := 263, target := 52, scalar := 15 }] }
theorem rowR6_0040_001_27_valid : (rowR6_0040_001_27).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_28 : ExtensionRow := { move := 264, child := 86, matrix := ![1,0,6,1,8,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 1, scalar := 8 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 71, scalar := 7 },{ source := 54, target := 139, scalar := 12 },{ source := 108, target := 52, scalar := 14 },{ source := 264, target := 0, scalar := 1 }] }
theorem rowR6_0040_001_28_valid : (rowR6_0040_001_28).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_29 : ExtensionRow := { move := 265, child := 181, matrix := ![14,1,15,15,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 1, scalar := 14 },{ source := 54, target := 72, scalar := 10 },{ source := 108, target := 218, scalar := 8 },{ source := 265, target := 0, scalar := 14 }] }
theorem rowR6_0040_001_29_valid : (rowR6_0040_001_29).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_30 : ExtensionRow := { move := 267, child := 7, matrix := ![15,0,3,0,0,5,0,13,12], witnesses := [{ source := 0, target := 69, scalar := 3 },{ source := 1, target := 0, scalar := 13 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 91, scalar := 12 },{ source := 54, target := 1, scalar := 2 },{ source := 108, target := 34, scalar := 1 },{ source := 267, target := 52, scalar := 2 }] }
theorem rowR6_0040_001_30_valid : (rowR6_0040_001_30).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_001_31 : ExtensionRow := { move := 270, child := 430, matrix := ![0,14,3,6,0,15,0,0,4], witnesses := [{ source := 0, target := 110, scalar := 3 },{ source := 1, target := 17, scalar := 14 },{ source := 17, target := 1, scalar := 6 },{ source := 34, target := 52, scalar := 13 },{ source := 54, target := 0, scalar := 7 },{ source := 108, target := 143, scalar := 13 },{ source := 270, target := 34, scalar := 1 }] }
theorem rowR6_0040_001_31_valid : (rowR6_0040_001_31).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowsR6_0040_001 : List ExtensionRow := [rowR6_0040_001_0,rowR6_0040_001_1,rowR6_0040_001_2,rowR6_0040_001_3,rowR6_0040_001_4,rowR6_0040_001_5,rowR6_0040_001_6,rowR6_0040_001_7,rowR6_0040_001_8,rowR6_0040_001_9,rowR6_0040_001_10,rowR6_0040_001_11,rowR6_0040_001_12,rowR6_0040_001_13,rowR6_0040_001_14,rowR6_0040_001_15,rowR6_0040_001_16,rowR6_0040_001_17,rowR6_0040_001_18,rowR6_0040_001_19,rowR6_0040_001_20,rowR6_0040_001_21,rowR6_0040_001_22,rowR6_0040_001_23,rowR6_0040_001_24,rowR6_0040_001_25,rowR6_0040_001_26,rowR6_0040_001_27,rowR6_0040_001_28,rowR6_0040_001_29,rowR6_0040_001_30,rowR6_0040_001_31]

theorem rowsR6_0040_001_valid : RowListValid level7 {0,1,17,34,54,108} rowsR6_0040_001 := by
  intro r hr
  simp only [rowsR6_0040_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR6_0040_001_0_valid
  · exact rowR6_0040_001_1_valid
  · exact rowR6_0040_001_2_valid
  · exact rowR6_0040_001_3_valid
  · exact rowR6_0040_001_4_valid
  · exact rowR6_0040_001_5_valid
  · exact rowR6_0040_001_6_valid
  · exact rowR6_0040_001_7_valid
  · exact rowR6_0040_001_8_valid
  · exact rowR6_0040_001_9_valid
  · exact rowR6_0040_001_10_valid
  · exact rowR6_0040_001_11_valid
  · exact rowR6_0040_001_12_valid
  · exact rowR6_0040_001_13_valid
  · exact rowR6_0040_001_14_valid
  · exact rowR6_0040_001_15_valid
  · exact rowR6_0040_001_16_valid
  · exact rowR6_0040_001_17_valid
  · exact rowR6_0040_001_18_valid
  · exact rowR6_0040_001_19_valid
  · exact rowR6_0040_001_20_valid
  · exact rowR6_0040_001_21_valid
  · exact rowR6_0040_001_22_valid
  · exact rowR6_0040_001_23_valid
  · exact rowR6_0040_001_24_valid
  · exact rowR6_0040_001_25_valid
  · exact rowR6_0040_001_26_valid
  · exact rowR6_0040_001_27_valid
  · exact rowR6_0040_001_28_valid
  · exact rowR6_0040_001_29_valid
  · exact rowR6_0040_001_30_valid
  · exact rowR6_0040_001_31_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
