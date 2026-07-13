import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR6_0016_000_0 : ExtensionRow := { move := 67, child := 1, matrix := ![1,0,0,1,1,0,1,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 67, scalar := 1 },{ source := 67, target := 52, scalar := 1 },{ source := 108, target := 91, scalar := 1 }] }
theorem rowR6_0016_000_0_valid : (rowR6_0016_000_0).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_1 : ExtensionRow := { move := 70, child := 16, matrix := ![7,3,14,14,0,3,9,0,7], witnesses := [{ source := 0, target := 106, scalar := 14 },{ source := 1, target := 17, scalar := 3 },{ source := 17, target := 52, scalar := 7 },{ source := 34, target := 69, scalar := 10 },{ source := 52, target := 1, scalar := 11 },{ source := 70, target := 34, scalar := 1 },{ source := 108, target := 0, scalar := 13 }] }
theorem rowR6_0016_000_1_valid : (rowR6_0016_000_1).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_2 : ExtensionRow := { move := 72, child := 146, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 72, target := 72, scalar := 1 },{ source := 108, target := 108, scalar := 1 }] }
theorem rowR6_0016_000_2_valid : (rowR6_0016_000_2).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_3 : ExtensionRow := { move := 74, child := 203, matrix := ![0,7,1,8,14,1,0,9,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 52, scalar := 7 },{ source := 17, target := 1, scalar := 8 },{ source := 34, target := 126, scalar := 6 },{ source := 52, target := 73, scalar := 13 },{ source := 74, target := 0, scalar := 1 },{ source := 108, target := 17, scalar := 3 }] }
theorem rowR6_0016_000_3_valid : (rowR6_0016_000_3).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_4 : ExtensionRow := { move := 75, child := 255, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 75, scalar := 1 },{ source := 108, target := 108, scalar := 1 }] }
theorem rowR6_0016_000_4_valid : (rowR6_0016_000_4).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_5 : ExtensionRow := { move := 78, child := 78, matrix := ![0,14,15,0,3,2,2,7,4], witnesses := [{ source := 0, target := 71, scalar := 15 },{ source := 1, target := 106, scalar := 14 },{ source := 17, target := 0, scalar := 2 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 17, scalar := 13 },{ source := 78, target := 52, scalar := 6 },{ source := 108, target := 1, scalar := 10 }] }
theorem rowR6_0016_000_5_valid : (rowR6_0016_000_5).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_6 : ExtensionRow := { move := 79, child := 61, matrix := ![9,7,0,1,0,0,8,0,11], witnesses := [{ source := 0, target := 0, scalar := 11 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 52, scalar := 9 },{ source := 34, target := 70, scalar := 14 },{ source := 52, target := 120, scalar := 7 },{ source := 79, target := 1, scalar := 1 },{ source := 108, target := 34, scalar := 1 }] }
theorem rowR6_0016_000_6_valid : (rowR6_0016_000_6).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_7 : ExtensionRow := { move := 80, child := 301, matrix := ![0,3,3,0,11,0,13,13,0], witnesses := [{ source := 0, target := 17, scalar := 3 },{ source := 1, target := 155, scalar := 3 },{ source := 17, target := 0, scalar := 13 },{ source := 34, target := 1, scalar := 11 },{ source := 52, target := 78, scalar := 3 },{ source := 80, target := 52, scalar := 7 },{ source := 108, target := 34, scalar := 1 }] }
theorem rowR6_0016_000_7_valid : (rowR6_0016_000_7).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_8 : ExtensionRow := { move := 86, child := 52, matrix := ![15,14,0,0,1,0,0,3,2], witnesses := [{ source := 0, target := 0, scalar := 2 },{ source := 1, target := 70, scalar := 14 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 1, scalar := 2 },{ source := 86, target := 52, scalar := 2 },{ source := 108, target := 89, scalar := 12 }] }
theorem rowR6_0016_000_8_valid : (rowR6_0016_000_8).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_9 : ExtensionRow := { move := 89, child := 83, matrix := ![2,1,0,4,1,0,6,1,13], witnesses := [{ source := 0, target := 0, scalar := 13 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 2 },{ source := 34, target := 71, scalar := 3 },{ source := 52, target := 1, scalar := 6 },{ source := 89, target := 17, scalar := 6 },{ source := 108, target := 126, scalar := 7 }] }
theorem rowR6_0016_000_9_valid : (rowR6_0016_000_9).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_10 : ExtensionRow := { move := 90, child := 194, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 90, target := 72, scalar := 13 },{ source := 108, target := 269, scalar := 14 }] }
theorem rowR6_0016_000_10_valid : (rowR6_0016_000_10).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_11 : ExtensionRow := { move := 91, child := 150, matrix := ![1,10,2,1,9,0,1,11,0], witnesses := [{ source := 0, target := 17, scalar := 2 },{ source := 1, target := 126, scalar := 10 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 72, scalar := 9 },{ source := 52, target := 0, scalar := 4 },{ source := 91, target := 52, scalar := 8 },{ source := 108, target := 1, scalar := 10 }] }
theorem rowR6_0016_000_11_valid : (rowR6_0016_000_11).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_12 : ExtensionRow := { move := 93, child := 385, matrix := ![0,8,1,0,3,1,6,11,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 52, scalar := 8 },{ source := 17, target := 0, scalar := 6 },{ source := 34, target := 92, scalar := 9 },{ source := 52, target := 1, scalar := 5 },{ source := 93, target := 17, scalar := 10 },{ source := 108, target := 190, scalar := 5 }] }
theorem rowR6_0016_000_12_valid : (rowR6_0016_000_12).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_13 : ExtensionRow := { move := 94, child := 391, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 94, target := 94, scalar := 1 },{ source := 108, target := 108, scalar := 1 }] }
theorem rowR6_0016_000_13_valid : (rowR6_0016_000_13).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_14 : ExtensionRow := { move := 96, child := 126, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 96, target := 71, scalar := 11 },{ source := 108, target := 239, scalar := 14 }] }
theorem rowR6_0016_000_14_valid : (rowR6_0016_000_14).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_15 : ExtensionRow := { move := 115, child := 151, matrix := ![3,7,1,0,14,1,0,9,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 52, scalar := 7 },{ source := 17, target := 17, scalar := 3 },{ source := 34, target := 72, scalar := 5 },{ source := 52, target := 135, scalar := 14 },{ source := 108, target := 1, scalar := 8 },{ source := 115, target := 0, scalar := 1 }] }
theorem rowR6_0016_000_15_valid : (rowR6_0016_000_15).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_16 : ExtensionRow := { move := 120, child := 418, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 108, target := 108, scalar := 1 },{ source := 120, target := 120, scalar := 1 }] }
theorem rowR6_0016_000_16_valid : (rowR6_0016_000_16).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_17 : ExtensionRow := { move := 121, child := 419, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 108, target := 108, scalar := 1 },{ source := 121, target := 121, scalar := 1 }] }
theorem rowR6_0016_000_17_valid : (rowR6_0016_000_17).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_18 : ExtensionRow := { move := 122, child := 222, matrix := ![0,6,12,0,7,0,3,14,0], witnesses := [{ source := 0, target := 17, scalar := 12 },{ source := 1, target := 125, scalar := 6 },{ source := 17, target := 0, scalar := 3 },{ source := 34, target := 52, scalar := 10 },{ source := 52, target := 74, scalar := 11 },{ source := 108, target := 1, scalar := 8 },{ source := 122, target := 34, scalar := 1 }] }
theorem rowR6_0016_000_18_valid : (rowR6_0016_000_18).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_19 : ExtensionRow := { move := 125, child := 334, matrix := ![4,1,5,7,1,10,14,1,15], witnesses := [{ source := 0, target := 52, scalar := 5 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 107, scalar := 4 },{ source := 34, target := 1, scalar := 12 },{ source := 52, target := 80, scalar := 9 },{ source := 108, target := 0, scalar := 8 },{ source := 125, target := 17, scalar := 11 }] }
theorem rowR6_0016_000_19_valid : (rowR6_0016_000_19).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_20 : ExtensionRow := { move := 126, child := 349, matrix := ![15,14,1,0,1,1,0,5,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 80, scalar := 14 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 0, scalar := 4 },{ source := 52, target := 248, scalar := 3 },{ source := 108, target := 52, scalar := 7 },{ source := 126, target := 1, scalar := 11 }] }
theorem rowR6_0016_000_20_valid : (rowR6_0016_000_20).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_21 : ExtensionRow := { move := 127, child := 389, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 108, target := 269, scalar := 14 },{ source := 127, target := 92, scalar := 8 }] }
theorem rowR6_0016_000_21_valid : (rowR6_0016_000_21).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_22 : ExtensionRow := { move := 128, child := 186, matrix := ![12,1,11,3,1,14,15,1,4], witnesses := [{ source := 0, target := 72, scalar := 11 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 237, scalar := 12 },{ source := 34, target := 52, scalar := 6 },{ source := 52, target := 0, scalar := 1 },{ source := 108, target := 1, scalar := 14 },{ source := 128, target := 17, scalar := 9 }] }
theorem rowR6_0016_000_22_valid : (rowR6_0016_000_22).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_23 : ExtensionRow := { move := 131, child := 104, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 108, target := 181, scalar := 1 },{ source := 131, target := 71, scalar := 1 }] }
theorem rowR6_0016_000_23_valid : (rowR6_0016_000_23).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_24 : ExtensionRow := { move := 133, child := 145, matrix := ![0,1,15,0,1,2,12,1,11], witnesses := [{ source := 0, target := 72, scalar := 15 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 12 },{ source := 34, target := 107, scalar := 14 },{ source := 52, target := 1, scalar := 4 },{ source := 108, target := 17, scalar := 6 },{ source := 133, target := 52, scalar := 14 }] }
theorem rowR6_0016_000_24_valid : (rowR6_0016_000_24).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_25 : ExtensionRow := { move := 135, child := 282, matrix := ![0,9,1,0,8,1,9,5,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 75, scalar := 9 },{ source := 17, target := 0, scalar := 9 },{ source := 34, target := 248, scalar := 8 },{ source := 52, target := 17, scalar := 2 },{ source := 108, target := 1, scalar := 5 },{ source := 135, target := 52, scalar := 12 }] }
theorem rowR6_0016_000_25_valid : (rowR6_0016_000_25).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_26 : ExtensionRow := { move := 137, child := 367, matrix := ![0,5,1,0,9,1,5,8,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 216, scalar := 5 },{ source := 17, target := 0, scalar := 5 },{ source := 34, target := 52, scalar := 4 },{ source := 52, target := 91, scalar := 9 },{ source := 108, target := 17, scalar := 9 },{ source := 137, target := 1, scalar := 2 }] }
theorem rowR6_0016_000_26_valid : (rowR6_0016_000_26).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_27 : ExtensionRow := { move := 138, child := 228, matrix := ![6,12,10,5,11,0,7,7,0], witnesses := [{ source := 0, target := 17, scalar := 10 },{ source := 1, target := 52, scalar := 12 },{ source := 17, target := 151, scalar := 6 },{ source := 34, target := 1, scalar := 14 },{ source := 52, target := 0, scalar := 9 },{ source := 108, target := 74, scalar := 13 },{ source := 138, target := 34, scalar := 1 }] }
theorem rowR6_0016_000_27_valid : (rowR6_0016_000_27).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_28 : ExtensionRow := { move := 141, child := 418, matrix := ![0,5,5,15,13,2,0,8,1], witnesses := [{ source := 0, target := 108, scalar := 5 },{ source := 1, target := 120, scalar := 5 },{ source := 17, target := 1, scalar := 15 },{ source := 34, target := 0, scalar := 9 },{ source := 52, target := 17, scalar := 5 },{ source := 108, target := 52, scalar := 3 },{ source := 141, target := 34, scalar := 1 }] }
theorem rowR6_0016_000_28_valid : (rowR6_0016_000_28).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_29 : ExtensionRow := { move := 144, child := 416, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 108, target := 239, scalar := 14 },{ source := 144, target := 107, scalar := 8 }] }
theorem rowR6_0016_000_29_valid : (rowR6_0016_000_29).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_30 : ExtensionRow := { move := 147, child := 234, matrix := ![1,13,12,1,0,1,1,0,5], witnesses := [{ source := 0, target := 181, scalar := 12 },{ source := 1, target := 17, scalar := 13 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 4 },{ source := 52, target := 74, scalar := 15 },{ source := 108, target := 1, scalar := 10 },{ source := 147, target := 52, scalar := 8 }] }
theorem rowR6_0016_000_30_valid : (rowR6_0016_000_30).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_31 : ExtensionRow := { move := 150, child := 180, matrix := ![0,3,2,0,7,6,4,11,14], witnesses := [{ source := 0, target := 72, scalar := 2 },{ source := 1, target := 217, scalar := 3 },{ source := 17, target := 0, scalar := 4 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 1, scalar := 4 },{ source := 108, target := 52, scalar := 10 },{ source := 150, target := 17, scalar := 1 }] }
theorem rowR6_0016_000_31_valid : (rowR6_0016_000_31).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_32 : ExtensionRow := { move := 151, child := 420, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 108, target := 108, scalar := 1 },{ source := 151, target := 151, scalar := 1 }] }
theorem rowR6_0016_000_32_valid : (rowR6_0016_000_32).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_33 : ExtensionRow := { move := 154, child := 46, matrix := ![4,15,10,12,13,0,3,2,0], witnesses := [{ source := 0, target := 17, scalar := 10 },{ source := 1, target := 52, scalar := 15 },{ source := 17, target := 69, scalar := 4 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 214, scalar := 4 },{ source := 108, target := 0, scalar := 9 },{ source := 154, target := 1, scalar := 14 }] }
theorem rowR6_0016_000_33_valid : (rowR6_0016_000_33).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_34 : ExtensionRow := { move := 155, child := 322, matrix := ![15,6,1,10,0,1,3,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 6 },{ source := 17, target := 268, scalar := 15 },{ source := 34, target := 78, scalar := 8 },{ source := 52, target := 1, scalar := 9 },{ source := 108, target := 52, scalar := 9 },{ source := 155, target := 0, scalar := 9 }] }
theorem rowR6_0016_000_34_valid : (rowR6_0016_000_34).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_35 : ExtensionRow := { move := 159, child := 412, matrix := ![10,1,6,8,1,0,5,1,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 186, scalar := 10 },{ source := 34, target := 52, scalar := 13 },{ source := 52, target := 107, scalar := 2 },{ source := 108, target := 1, scalar := 13 },{ source := 159, target := 0, scalar := 13 }] }
theorem rowR6_0016_000_35_valid : (rowR6_0016_000_35).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_36 : ExtensionRow := { move := 166, child := 77, matrix := ![3,0,1,5,0,1,10,13,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 0, scalar := 13 },{ source := 17, target := 71, scalar := 3 },{ source := 34, target := 52, scalar := 2 },{ source := 52, target := 1, scalar := 6 },{ source := 108, target := 104, scalar := 8 },{ source := 166, target := 17, scalar := 6 }] }
theorem rowR6_0016_000_36_valid : (rowR6_0016_000_36).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_37 : ExtensionRow := { move := 168, child := 316, matrix := ![0,0,6,0,6,12,2,0,10], witnesses := [{ source := 0, target := 52, scalar := 6 },{ source := 1, target := 1, scalar := 6 },{ source := 17, target := 0, scalar := 2 },{ source := 34, target := 78, scalar := 6 },{ source := 52, target := 233, scalar := 10 },{ source := 108, target := 17, scalar := 15 },{ source := 168, target := 34, scalar := 1 }] }
theorem rowR6_0016_000_37_valid : (rowR6_0016_000_37).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_38 : ExtensionRow := { move := 169, child := 396, matrix := ![5,10,15,10,5,0,15,15,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 169, scalar := 10 },{ source := 17, target := 52, scalar := 5 },{ source := 34, target := 1, scalar := 15 },{ source := 52, target := 0, scalar := 2 },{ source := 108, target := 94, scalar := 2 },{ source := 169, target := 34, scalar := 1 }] }
theorem rowR6_0016_000_38_valid : (rowR6_0016_000_38).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_39 : ExtensionRow := { move := 171, child := 82, matrix := ![5,10,0,13,13,0,14,9,7], witnesses := [{ source := 0, target := 0, scalar := 7 },{ source := 1, target := 71, scalar := 10 },{ source := 17, target := 121, scalar := 5 },{ source := 34, target := 17, scalar := 15 },{ source := 52, target := 52, scalar := 2 },{ source := 108, target := 34, scalar := 1 },{ source := 171, target := 1, scalar := 2 }] }
theorem rowR6_0016_000_39_valid : (rowR6_0016_000_39).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_40 : ExtensionRow := { move := 173, child := 387, matrix := ![1,0,0,13,13,0,12,0,12], witnesses := [{ source := 0, target := 0, scalar := 12 },{ source := 1, target := 1, scalar := 13 },{ source := 17, target := 237, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 92, scalar := 1 },{ source := 108, target := 34, scalar := 1 },{ source := 173, target := 52, scalar := 1 }] }
theorem rowR6_0016_000_40_valid : (rowR6_0016_000_40).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_41 : ExtensionRow := { move := 175, child := 64, matrix := ![15,15,0,0,2,0,0,6,6], witnesses := [{ source := 0, target := 0, scalar := 6 },{ source := 1, target := 70, scalar := 15 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 1, scalar := 2 },{ source := 52, target := 52, scalar := 2 },{ source := 108, target := 133, scalar := 9 },{ source := 175, target := 34, scalar := 1 }] }
theorem rowR6_0016_000_41_valid : (rowR6_0016_000_41).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_42 : ExtensionRow := { move := 176, child := 205, matrix := ![14,15,0,12,13,0,5,2,6], witnesses := [{ source := 0, target := 0, scalar := 6 },{ source := 1, target := 52, scalar := 15 },{ source := 17, target := 144, scalar := 14 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 73, scalar := 3 },{ source := 108, target := 17, scalar := 8 },{ source := 176, target := 1, scalar := 3 }] }
theorem rowR6_0016_000_42_valid : (rowR6_0016_000_42).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_43 : ExtensionRow := { move := 181, child := 421, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 108, target := 108, scalar := 1 },{ source := 181, target := 181, scalar := 1 }] }
theorem rowR6_0016_000_43_valid : (rowR6_0016_000_43).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_44 : ExtensionRow := { move := 183, child := 249, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 108, target := 239, scalar := 14 },{ source := 183, target := 74, scalar := 12 }] }
theorem rowR6_0016_000_44_valid : (rowR6_0016_000_44).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_45 : ExtensionRow := { move := 184, child := 348, matrix := ![2,0,10,4,0,13,6,9,12], witnesses := [{ source := 0, target := 80, scalar := 10 },{ source := 1, target := 0, scalar := 9 },{ source := 17, target := 52, scalar := 2 },{ source := 34, target := 243, scalar := 8 },{ source := 52, target := 17, scalar := 15 },{ source := 108, target := 1, scalar := 2 },{ source := 184, target := 34, scalar := 1 }] }
theorem rowR6_0016_000_45_valid : (rowR6_0016_000_45).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_46 : ExtensionRow := { move := 186, child := 109, matrix := ![10,11,1,0,5,10,0,14,14], witnesses := [{ source := 0, target := 191, scalar := 1 },{ source := 1, target := 52, scalar := 11 },{ source := 17, target := 17, scalar := 10 },{ source := 34, target := 1, scalar := 15 },{ source := 52, target := 71, scalar := 12 },{ source := 108, target := 0, scalar := 11 },{ source := 186, target := 34, scalar := 1 }] }
theorem rowR6_0016_000_46_valid : (rowR6_0016_000_46).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowR6_0016_000_47 : ExtensionRow := { move := 189, child := 35, matrix := ![4,10,1,12,0,1,3,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 10 },{ source := 17, target := 69, scalar := 4 },{ source := 34, target := 52, scalar := 15 },{ source := 52, target := 1, scalar := 15 },{ source := 108, target := 159, scalar := 11 },{ source := 189, target := 0, scalar := 15 }] }
theorem rowR6_0016_000_47_valid : (rowR6_0016_000_47).ValidFor level7 {0,1,17,34,52,108} := by decide

noncomputable def rowsR6_0016_000 : List ExtensionRow := [rowR6_0016_000_0,rowR6_0016_000_1,rowR6_0016_000_2,rowR6_0016_000_3,rowR6_0016_000_4,rowR6_0016_000_5,rowR6_0016_000_6,rowR6_0016_000_7,rowR6_0016_000_8,rowR6_0016_000_9,rowR6_0016_000_10,rowR6_0016_000_11,rowR6_0016_000_12,rowR6_0016_000_13,rowR6_0016_000_14,rowR6_0016_000_15,rowR6_0016_000_16,rowR6_0016_000_17,rowR6_0016_000_18,rowR6_0016_000_19,rowR6_0016_000_20,rowR6_0016_000_21,rowR6_0016_000_22,rowR6_0016_000_23,rowR6_0016_000_24,rowR6_0016_000_25,rowR6_0016_000_26,rowR6_0016_000_27,rowR6_0016_000_28,rowR6_0016_000_29,rowR6_0016_000_30,rowR6_0016_000_31,rowR6_0016_000_32,rowR6_0016_000_33,rowR6_0016_000_34,rowR6_0016_000_35,rowR6_0016_000_36,rowR6_0016_000_37,rowR6_0016_000_38,rowR6_0016_000_39,rowR6_0016_000_40,rowR6_0016_000_41,rowR6_0016_000_42,rowR6_0016_000_43,rowR6_0016_000_44,rowR6_0016_000_45,rowR6_0016_000_46,rowR6_0016_000_47]

theorem rowsR6_0016_000_valid : RowListValid level7 {0,1,17,34,52,108} rowsR6_0016_000 := by
  intro r hr
  simp only [rowsR6_0016_000, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR6_0016_000_0_valid
  · exact rowR6_0016_000_1_valid
  · exact rowR6_0016_000_2_valid
  · exact rowR6_0016_000_3_valid
  · exact rowR6_0016_000_4_valid
  · exact rowR6_0016_000_5_valid
  · exact rowR6_0016_000_6_valid
  · exact rowR6_0016_000_7_valid
  · exact rowR6_0016_000_8_valid
  · exact rowR6_0016_000_9_valid
  · exact rowR6_0016_000_10_valid
  · exact rowR6_0016_000_11_valid
  · exact rowR6_0016_000_12_valid
  · exact rowR6_0016_000_13_valid
  · exact rowR6_0016_000_14_valid
  · exact rowR6_0016_000_15_valid
  · exact rowR6_0016_000_16_valid
  · exact rowR6_0016_000_17_valid
  · exact rowR6_0016_000_18_valid
  · exact rowR6_0016_000_19_valid
  · exact rowR6_0016_000_20_valid
  · exact rowR6_0016_000_21_valid
  · exact rowR6_0016_000_22_valid
  · exact rowR6_0016_000_23_valid
  · exact rowR6_0016_000_24_valid
  · exact rowR6_0016_000_25_valid
  · exact rowR6_0016_000_26_valid
  · exact rowR6_0016_000_27_valid
  · exact rowR6_0016_000_28_valid
  · exact rowR6_0016_000_29_valid
  · exact rowR6_0016_000_30_valid
  · exact rowR6_0016_000_31_valid
  · exact rowR6_0016_000_32_valid
  · exact rowR6_0016_000_33_valid
  · exact rowR6_0016_000_34_valid
  · exact rowR6_0016_000_35_valid
  · exact rowR6_0016_000_36_valid
  · exact rowR6_0016_000_37_valid
  · exact rowR6_0016_000_38_valid
  · exact rowR6_0016_000_39_valid
  · exact rowR6_0016_000_40_valid
  · exact rowR6_0016_000_41_valid
  · exact rowR6_0016_000_42_valid
  · exact rowR6_0016_000_43_valid
  · exact rowR6_0016_000_44_valid
  · exact rowR6_0016_000_45_valid
  · exact rowR6_0016_000_46_valid
  · exact rowR6_0016_000_47_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
