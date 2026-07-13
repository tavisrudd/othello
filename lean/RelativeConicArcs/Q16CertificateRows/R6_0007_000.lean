import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR6_0007_000_0 : ExtensionRow := { move := 83, child := 67, matrix := ![11,11,0,14,0,14,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 14 },{ source := 1, target := 17, scalar := 11 },{ source := 17, target := 70, scalar := 11 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 14 },{ source := 75, target := 140, scalar := 5 },{ source := 83, target := 34, scalar := 1 }] }
theorem rowR6_0007_000_0_valid : (rowR6_0007_000_0).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_1 : ExtensionRow := { move := 86, child := 54, matrix := ![14,15,1,1,0,1,3,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 15 },{ source := 17, target := 70, scalar := 14 },{ source := 34, target := 0, scalar := 2 },{ source := 52, target := 1, scalar := 2 },{ source := 75, target := 91, scalar := 6 },{ source := 86, target := 52, scalar := 2 }] }
theorem rowR6_0007_000_1_valid : (rowR6_0007_000_1).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_2 : ExtensionRow := { move := 90, child := 11, matrix := ![0,9,0,0,2,3,15,7,0], witnesses := [{ source := 0, target := 1, scalar := 3 },{ source := 1, target := 95, scalar := 9 },{ source := 17, target := 0, scalar := 15 },{ source := 34, target := 52, scalar := 9 },{ source := 52, target := 34, scalar := 1 },{ source := 75, target := 69, scalar := 8 },{ source := 90, target := 17, scalar := 2 }] }
theorem rowR6_0007_000_2_valid : (rowR6_0007_000_2).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_3 : ExtensionRow := { move := 93, child := 164, matrix := ![1,0,14,1,4,7,1,0,10], witnesses := [{ source := 0, target := 174, scalar := 14 },{ source := 1, target := 1, scalar := 4 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 72, scalar := 15 },{ source := 52, target := 0, scalar := 12 },{ source := 75, target := 52, scalar := 7 },{ source := 93, target := 17, scalar := 5 }] }
theorem rowR6_0007_000_3_valid : (rowR6_0007_000_3).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_4 : ExtensionRow := { move := 94, child := 253, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 75, scalar := 1 },{ source := 94, target := 94, scalar := 1 }] }
theorem rowR6_0007_000_4_valid : (rowR6_0007_000_4).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_5 : ExtensionRow := { move := 95, child := 149, matrix := ![14,7,0,1,0,0,12,0,4], witnesses := [{ source := 0, target := 0, scalar := 4 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 72, scalar := 14 },{ source := 34, target := 52, scalar := 9 },{ source := 52, target := 1, scalar := 1 },{ source := 75, target := 125, scalar := 7 },{ source := 95, target := 34, scalar := 1 }] }
theorem rowR6_0007_000_5_valid : (rowR6_0007_000_5).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_6 : ExtensionRow := { move := 96, child := 77, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 104, scalar := 9 },{ source := 96, target := 71, scalar := 11 }] }
theorem rowR6_0007_000_6_valid : (rowR6_0007_000_6).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_7 : ExtensionRow := { move := 99, child := 43, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 195, scalar := 1 },{ source := 99, target := 69, scalar := 1 }] }
theorem rowR6_0007_000_7_valid : (rowR6_0007_000_7).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_8 : ExtensionRow := { move := 103, child := 83, matrix := ![9,7,0,1,0,0,8,0,10], witnesses := [{ source := 0, target := 0, scalar := 10 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 52, scalar := 9 },{ source := 34, target := 71, scalar := 14 },{ source := 52, target := 126, scalar := 7 },{ source := 75, target := 1, scalar := 1 },{ source := 103, target := 34, scalar := 1 }] }
theorem rowR6_0007_000_8_valid : (rowR6_0007_000_8).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_9 : ExtensionRow := { move := 104, child := 254, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 104, scalar := 9 },{ source := 104, target := 75, scalar := 2 }] }
theorem rowR6_0007_000_9_valid : (rowR6_0007_000_9).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_10 : ExtensionRow := { move := 108, child := 255, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 75, scalar := 1 },{ source := 108, target := 108, scalar := 1 }] }
theorem rowR6_0007_000_10_valid : (rowR6_0007_000_10).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_11 : ExtensionRow := { move := 109, child := 135, matrix := ![1,13,9,1,0,14,1,0,12], witnesses := [{ source := 0, target := 268, scalar := 9 },{ source := 1, target := 17, scalar := 13 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 71, scalar := 5 },{ source := 52, target := 0, scalar := 6 },{ source := 75, target := 1, scalar := 7 },{ source := 109, target := 52, scalar := 11 }] }
theorem rowR6_0007_000_11_valid : (rowR6_0007_000_11).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_12 : ExtensionRow := { move := 112, child := 81, matrix := ![1,2,3,1,4,5,1,6,10], witnesses := [{ source := 0, target := 71, scalar := 3 },{ source := 1, target := 52, scalar := 2 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 13 },{ source := 52, target := 1, scalar := 6 },{ source := 75, target := 120, scalar := 10 },{ source := 112, target := 17, scalar := 9 }] }
theorem rowR6_0007_000_12_valid : (rowR6_0007_000_12).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_13 : ExtensionRow := { move := 115, child := 62, matrix := ![2,8,10,12,11,7,11,14,13], witnesses := [{ source := 0, target := 52, scalar := 10 },{ source := 1, target := 70, scalar := 8 },{ source := 17, target := 125, scalar := 2 },{ source := 34, target := 0, scalar := 8 },{ source := 52, target := 17, scalar := 12 },{ source := 75, target := 34, scalar := 1 },{ source := 115, target := 1, scalar := 13 }] }
theorem rowR6_0007_000_13_valid : (rowR6_0007_000_13).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_14 : ExtensionRow := { move := 117, child := 256, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 117, scalar := 9 },{ source := 117, target := 75, scalar := 2 }] }
theorem rowR6_0007_000_14_valid : (rowR6_0007_000_14).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_15 : ExtensionRow := { move := 121, child := 195, matrix := ![0,7,6,0,11,10,5,5,1], witnesses := [{ source := 0, target := 72, scalar := 6 },{ source := 1, target := 270, scalar := 7 },{ source := 17, target := 0, scalar := 5 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 4 },{ source := 75, target := 1, scalar := 6 },{ source := 121, target := 17, scalar := 4 }] }
theorem rowR6_0007_000_15_valid : (rowR6_0007_000_15).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_16 : ExtensionRow := { move := 122, child := 238, matrix := ![8,0,9,11,6,12,4,0,5], witnesses := [{ source := 0, target := 203, scalar := 9 },{ source := 1, target := 1, scalar := 6 },{ source := 17, target := 74, scalar := 8 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 0, scalar := 11 },{ source := 75, target := 17, scalar := 13 },{ source := 122, target := 52, scalar := 5 }] }
theorem rowR6_0007_000_16_valid : (rowR6_0007_000_16).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_17 : ExtensionRow := { move := 124, child := 225, matrix := ![0,1,0,6,1,0,0,1,13], witnesses := [{ source := 0, target := 0, scalar := 13 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 6 },{ source := 34, target := 141, scalar := 1 },{ source := 52, target := 52, scalar := 2 },{ source := 75, target := 74, scalar := 3 },{ source := 124, target := 17, scalar := 6 }] }
theorem rowR6_0007_000_17_valid : (rowR6_0007_000_17).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_18 : ExtensionRow := { move := 125, child := 10, matrix := ![4,1,2,8,1,6,12,1,8], witnesses := [{ source := 0, target := 69, scalar := 2 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 4 },{ source := 34, target := 94, scalar := 7 },{ source := 52, target := 0, scalar := 5 },{ source := 75, target := 1, scalar := 2 },{ source := 125, target := 17, scalar := 9 }] }
theorem rowR6_0007_000_18_valid : (rowR6_0007_000_18).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_19 : ExtensionRow := { move := 126, child := 257, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 75, scalar := 1 },{ source := 126, target := 126, scalar := 1 }] }
theorem rowR6_0007_000_19_valid : (rowR6_0007_000_19).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_20 : ExtensionRow := { move := 127, child := 258, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 75, scalar := 1 },{ source := 127, target := 127, scalar := 1 }] }
theorem rowR6_0007_000_20_valid : (rowR6_0007_000_20).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_21 : ExtensionRow := { move := 128, child := 186, matrix := ![7,0,2,9,0,9,6,13,11], witnesses := [{ source := 0, target := 237, scalar := 2 },{ source := 1, target := 0, scalar := 13 },{ source := 17, target := 72, scalar := 7 },{ source := 34, target := 17, scalar := 5 },{ source := 52, target := 34, scalar := 1 },{ source := 75, target := 1, scalar := 12 },{ source := 128, target := 52, scalar := 10 }] }
theorem rowR6_0007_000_21_valid : (rowR6_0007_000_21).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_22 : ExtensionRow := { move := 131, child := 17, matrix := ![14,14,0,3,1,0,6,13,11], witnesses := [{ source := 0, target := 0, scalar := 11 },{ source := 1, target := 69, scalar := 14 },{ source := 17, target := 107, scalar := 14 },{ source := 34, target := 1, scalar := 2 },{ source := 52, target := 34, scalar := 1 },{ source := 75, target := 17, scalar := 15 },{ source := 131, target := 52, scalar := 2 }] }
theorem rowR6_0007_000_22_valid : (rowR6_0007_000_22).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_23 : ExtensionRow := { move := 133, child := 153, matrix := ![1,3,2,1,5,4,1,9,6], witnesses := [{ source := 0, target := 52, scalar := 2 },{ source := 1, target := 72, scalar := 3 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 14 },{ source := 52, target := 139, scalar := 1 },{ source := 75, target := 17, scalar := 3 },{ source := 133, target := 1, scalar := 10 }] }
theorem rowR6_0007_000_23_valid : (rowR6_0007_000_23).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_24 : ExtensionRow := { move := 135, child := 259, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 75, scalar := 1 },{ source := 135, target := 135, scalar := 1 }] }
theorem rowR6_0007_000_24_valid : (rowR6_0007_000_24).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_25 : ExtensionRow := { move := 138, child := 116, matrix := ![9,0,1,6,4,1,10,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 1, scalar := 4 },{ source := 17, target := 216, scalar := 9 },{ source := 34, target := 52, scalar := 8 },{ source := 52, target := 71, scalar := 10 },{ source := 75, target := 17, scalar := 3 },{ source := 138, target := 0, scalar := 3 }] }
theorem rowR6_0007_000_25_valid : (rowR6_0007_000_25).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_26 : ExtensionRow := { move := 140, child := 219, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 117, scalar := 9 },{ source := 140, target := 74, scalar := 12 }] }
theorem rowR6_0007_000_26_valid : (rowR6_0007_000_26).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_27 : ExtensionRow := { move := 141, child := 260, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 75, scalar := 1 },{ source := 141, target := 141, scalar := 1 }] }
theorem rowR6_0007_000_27_valid : (rowR6_0007_000_27).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_28 : ExtensionRow := { move := 143, child := 261, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 75, scalar := 1 },{ source := 143, target := 143, scalar := 1 }] }
theorem rowR6_0007_000_28_valid : (rowR6_0007_000_28).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_29 : ExtensionRow := { move := 147, child := 237, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 195, scalar := 1 },{ source := 147, target := 74, scalar := 1 }] }
theorem rowR6_0007_000_29_valid : (rowR6_0007_000_29).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_30 : ExtensionRow := { move := 149, child := 152, matrix := ![3,6,5,0,10,10,0,1,15], witnesses := [{ source := 0, target := 52, scalar := 5 },{ source := 1, target := 72, scalar := 6 },{ source := 17, target := 17, scalar := 3 },{ source := 34, target := 0, scalar := 14 },{ source := 52, target := 1, scalar := 10 },{ source := 75, target := 138, scalar := 13 },{ source := 149, target := 34, scalar := 1 }] }
theorem rowR6_0007_000_30_valid : (rowR6_0007_000_30).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_31 : ExtensionRow := { move := 154, child := 262, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 75, scalar := 1 },{ source := 154, target := 154, scalar := 1 }] }
theorem rowR6_0007_000_31_valid : (rowR6_0007_000_31).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_32 : ExtensionRow := { move := 156, child := 231, matrix := ![6,15,8,3,2,0,15,14,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 74, scalar := 15 },{ source := 17, target := 172, scalar := 6 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 1, scalar := 7 },{ source := 75, target := 52, scalar := 11 },{ source := 156, target := 0, scalar := 6 }] }
theorem rowR6_0007_000_32_valid : (rowR6_0007_000_32).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_33 : ExtensionRow := { move := 158, child := 263, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 75, scalar := 1 },{ source := 158, target := 158, scalar := 1 }] }
theorem rowR6_0007_000_33_valid : (rowR6_0007_000_33).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_34 : ExtensionRow := { move := 159, child := 264, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 75, scalar := 1 },{ source := 159, target := 159, scalar := 1 }] }
theorem rowR6_0007_000_34_valid : (rowR6_0007_000_34).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_35 : ExtensionRow := { move := 163, child := 205, matrix := ![14,0,14,15,15,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 14 },{ source := 1, target := 1, scalar := 15 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 73, scalar := 15 },{ source := 75, target := 144, scalar := 8 },{ source := 163, target := 34, scalar := 1 }] }
theorem rowR6_0007_000_35_valid : (rowR6_0007_000_35).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_36 : ExtensionRow := { move := 166, child := 123, matrix := ![3,0,1,5,0,1,10,13,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 0, scalar := 13 },{ source := 17, target := 71, scalar := 3 },{ source := 34, target := 52, scalar := 2 },{ source := 52, target := 1, scalar := 6 },{ source := 75, target := 233, scalar := 9 },{ source := 166, target := 17, scalar := 6 }] }
theorem rowR6_0007_000_36_valid : (rowR6_0007_000_36).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_37 : ExtensionRow := { move := 167, child := 265, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 75, scalar := 1 },{ source := 167, target := 167, scalar := 1 }] }
theorem rowR6_0007_000_37_valid : (rowR6_0007_000_37).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_38 : ExtensionRow := { move := 168, child := 266, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 75, scalar := 1 },{ source := 168, target := 168, scalar := 1 }] }
theorem rowR6_0007_000_38_valid : (rowR6_0007_000_38).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_39 : ExtensionRow := { move := 169, child := 162, matrix := ![0,1,14,0,1,15,1,1,1], witnesses := [{ source := 0, target := 52, scalar := 14 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 169, scalar := 15 },{ source := 52, target := 17, scalar := 3 },{ source := 75, target := 72, scalar := 5 },{ source := 169, target := 1, scalar := 8 }] }
theorem rowR6_0007_000_39_valid : (rowR6_0007_000_39).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_40 : ExtensionRow := { move := 173, child := 267, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 75, scalar := 1 },{ source := 173, target := 173, scalar := 1 }] }
theorem rowR6_0007_000_40_valid : (rowR6_0007_000_40).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_41 : ExtensionRow := { move := 174, child := 268, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 75, scalar := 1 },{ source := 174, target := 174, scalar := 1 }] }
theorem rowR6_0007_000_41_valid : (rowR6_0007_000_41).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_42 : ExtensionRow := { move := 175, child := 60, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 117, scalar := 9 },{ source := 175, target := 70, scalar := 7 }] }
theorem rowR6_0007_000_42_valid : (rowR6_0007_000_42).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_43 : ExtensionRow := { move := 181, child := 269, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 75, scalar := 1 },{ source := 181, target := 181, scalar := 1 }] }
theorem rowR6_0007_000_43_valid : (rowR6_0007_000_43).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_44 : ExtensionRow := { move := 182, child := 270, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 75, scalar := 1 },{ source := 182, target := 182, scalar := 1 }] }
theorem rowR6_0007_000_44_valid : (rowR6_0007_000_44).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_45 : ExtensionRow := { move := 183, child := 215, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 104, scalar := 9 },{ source := 183, target := 74, scalar := 12 }] }
theorem rowR6_0007_000_45_valid : (rowR6_0007_000_45).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_46 : ExtensionRow := { move := 185, child := 80, matrix := ![15,0,5,2,0,2,4,8,12], witnesses := [{ source := 0, target := 110, scalar := 5 },{ source := 1, target := 0, scalar := 8 },{ source := 17, target := 71, scalar := 15 },{ source := 34, target := 17, scalar := 10 },{ source := 52, target := 1, scalar := 4 },{ source := 75, target := 52, scalar := 11 },{ source := 185, target := 34, scalar := 1 }] }
theorem rowR6_0007_000_46_valid : (rowR6_0007_000_46).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowR6_0007_000_47 : ExtensionRow := { move := 188, child := 145, matrix := ![10,3,8,4,5,0,8,9,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 72, scalar := 3 },{ source := 17, target := 107, scalar := 10 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 7 },{ source := 75, target := 1, scalar := 11 },{ source := 188, target := 0, scalar := 13 }] }
theorem rowR6_0007_000_47_valid : (rowR6_0007_000_47).ValidFor level7 {0,1,17,34,52,75} := by decide

noncomputable def rowsR6_0007_000 : List ExtensionRow := [rowR6_0007_000_0,rowR6_0007_000_1,rowR6_0007_000_2,rowR6_0007_000_3,rowR6_0007_000_4,rowR6_0007_000_5,rowR6_0007_000_6,rowR6_0007_000_7,rowR6_0007_000_8,rowR6_0007_000_9,rowR6_0007_000_10,rowR6_0007_000_11,rowR6_0007_000_12,rowR6_0007_000_13,rowR6_0007_000_14,rowR6_0007_000_15,rowR6_0007_000_16,rowR6_0007_000_17,rowR6_0007_000_18,rowR6_0007_000_19,rowR6_0007_000_20,rowR6_0007_000_21,rowR6_0007_000_22,rowR6_0007_000_23,rowR6_0007_000_24,rowR6_0007_000_25,rowR6_0007_000_26,rowR6_0007_000_27,rowR6_0007_000_28,rowR6_0007_000_29,rowR6_0007_000_30,rowR6_0007_000_31,rowR6_0007_000_32,rowR6_0007_000_33,rowR6_0007_000_34,rowR6_0007_000_35,rowR6_0007_000_36,rowR6_0007_000_37,rowR6_0007_000_38,rowR6_0007_000_39,rowR6_0007_000_40,rowR6_0007_000_41,rowR6_0007_000_42,rowR6_0007_000_43,rowR6_0007_000_44,rowR6_0007_000_45,rowR6_0007_000_46,rowR6_0007_000_47]

theorem rowsR6_0007_000_valid : RowListValid level7 {0,1,17,34,52,75} rowsR6_0007_000 := by
  intro r hr
  simp only [rowsR6_0007_000, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR6_0007_000_0_valid
  · exact rowR6_0007_000_1_valid
  · exact rowR6_0007_000_2_valid
  · exact rowR6_0007_000_3_valid
  · exact rowR6_0007_000_4_valid
  · exact rowR6_0007_000_5_valid
  · exact rowR6_0007_000_6_valid
  · exact rowR6_0007_000_7_valid
  · exact rowR6_0007_000_8_valid
  · exact rowR6_0007_000_9_valid
  · exact rowR6_0007_000_10_valid
  · exact rowR6_0007_000_11_valid
  · exact rowR6_0007_000_12_valid
  · exact rowR6_0007_000_13_valid
  · exact rowR6_0007_000_14_valid
  · exact rowR6_0007_000_15_valid
  · exact rowR6_0007_000_16_valid
  · exact rowR6_0007_000_17_valid
  · exact rowR6_0007_000_18_valid
  · exact rowR6_0007_000_19_valid
  · exact rowR6_0007_000_20_valid
  · exact rowR6_0007_000_21_valid
  · exact rowR6_0007_000_22_valid
  · exact rowR6_0007_000_23_valid
  · exact rowR6_0007_000_24_valid
  · exact rowR6_0007_000_25_valid
  · exact rowR6_0007_000_26_valid
  · exact rowR6_0007_000_27_valid
  · exact rowR6_0007_000_28_valid
  · exact rowR6_0007_000_29_valid
  · exact rowR6_0007_000_30_valid
  · exact rowR6_0007_000_31_valid
  · exact rowR6_0007_000_32_valid
  · exact rowR6_0007_000_33_valid
  · exact rowR6_0007_000_34_valid
  · exact rowR6_0007_000_35_valid
  · exact rowR6_0007_000_36_valid
  · exact rowR6_0007_000_37_valid
  · exact rowR6_0007_000_38_valid
  · exact rowR6_0007_000_39_valid
  · exact rowR6_0007_000_40_valid
  · exact rowR6_0007_000_41_valid
  · exact rowR6_0007_000_42_valid
  · exact rowR6_0007_000_43_valid
  · exact rowR6_0007_000_44_valid
  · exact rowR6_0007_000_45_valid
  · exact rowR6_0007_000_46_valid
  · exact rowR6_0007_000_47_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
