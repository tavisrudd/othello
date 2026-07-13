import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR6_0026_000_0 : ExtensionRow := { move := 67, child := 0, matrix := ![1,0,0,3,1,0,2,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 67, scalar := 1 },{ source := 34, target := 52, scalar := 1 },{ source := 52, target := 34, scalar := 1 },{ source := 67, target := 17, scalar := 1 },{ source := 139, target := 89, scalar := 1 }] }
theorem rowR6_0026_000_0_valid : (rowR6_0026_000_0).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_1 : ExtensionRow := { move := 69, child := 29, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 69, target := 69, scalar := 1 },{ source := 139, target := 139, scalar := 1 }] }
theorem rowR6_0026_000_1_valid : (rowR6_0026_000_1).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_2 : ExtensionRow := { move := 70, child := 52, matrix := ![1,0,11,1,15,14,1,0,1], witnesses := [{ source := 0, target := 70, scalar := 11 },{ source := 1, target := 1, scalar := 15 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 10 },{ source := 52, target := 52, scalar := 15 },{ source := 70, target := 0, scalar := 4 },{ source := 139, target := 89, scalar := 3 }] }
theorem rowR6_0026_000_2_valid : (rowR6_0026_000_2).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_3 : ExtensionRow := { move := 71, child := 86, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 71, target := 71, scalar := 1 },{ source := 139, target := 139, scalar := 1 }] }
theorem rowR6_0026_000_3_valid : (rowR6_0026_000_3).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_4 : ExtensionRow := { move := 72, child := 153, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 72, target := 72, scalar := 1 },{ source := 139, target := 139, scalar := 1 }] }
theorem rowR6_0026_000_4_valid : (rowR6_0026_000_4).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_5 : ExtensionRow := { move := 78, child := 296, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 78, target := 78, scalar := 1 },{ source := 139, target := 139, scalar := 1 }] }
theorem rowR6_0026_000_5_valid : (rowR6_0026_000_5).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_6 : ExtensionRow := { move := 79, child := 327, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 79, target := 79, scalar := 1 },{ source := 139, target := 139, scalar := 1 }] }
theorem rowR6_0026_000_6_valid : (rowR6_0026_000_6).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_7 : ExtensionRow := { move := 86, child := 64, matrix := ![14,15,1,1,0,1,3,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 15 },{ source := 17, target := 70, scalar := 14 },{ source := 34, target := 0, scalar := 2 },{ source := 52, target := 1, scalar := 2 },{ source := 86, target := 52, scalar := 2 },{ source := 139, target := 133, scalar := 15 }] }
theorem rowR6_0026_000_7_valid : (rowR6_0026_000_7).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_8 : ExtensionRow := { move := 89, child := 128, matrix := ![2,1,0,4,1,0,6,1,13], witnesses := [{ source := 0, target := 0, scalar := 13 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 2 },{ source := 34, target := 71, scalar := 3 },{ source := 52, target := 1, scalar := 6 },{ source := 89, target := 17, scalar := 6 },{ source := 139, target := 243, scalar := 5 }] }
theorem rowR6_0026_000_8_valid : (rowR6_0026_000_8).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_9 : ExtensionRow := { move := 90, child := 193, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 90, target := 72, scalar := 13 },{ source := 139, target := 268, scalar := 13 }] }
theorem rowR6_0026_000_9_valid : (rowR6_0026_000_9).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_10 : ExtensionRow := { move := 92, child := 111, matrix := ![10,12,6,7,7,0,13,14,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 71, scalar := 12 },{ source := 17, target := 52, scalar := 10 },{ source := 34, target := 0, scalar := 3 },{ source := 52, target := 203, scalar := 11 },{ source := 92, target := 1, scalar := 8 },{ source := 139, target := 34, scalar := 1 }] }
theorem rowR6_0026_000_10_valid : (rowR6_0026_000_10).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_11 : ExtensionRow := { move := 93, child := 383, matrix := ![0,10,12,14,7,0,0,13,0], witnesses := [{ source := 0, target := 17, scalar := 12 },{ source := 1, target := 52, scalar := 10 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 182, scalar := 6 },{ source := 52, target := 0, scalar := 9 },{ source := 93, target := 34, scalar := 1 },{ source := 139, target := 92, scalar := 2 }] }
theorem rowR6_0026_000_11_valid : (rowR6_0026_000_11).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_12 : ExtensionRow := { move := 95, child := 195, matrix := ![14,7,0,1,0,0,12,0,4], witnesses := [{ source := 0, target := 0, scalar := 4 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 72, scalar := 14 },{ source := 34, target := 52, scalar := 9 },{ source := 52, target := 1, scalar := 1 },{ source := 95, target := 34, scalar := 1 },{ source := 139, target := 270, scalar := 8 }] }
theorem rowR6_0026_000_12_valid : (rowR6_0026_000_12).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_13 : ExtensionRow := { move := 96, child := 109, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 96, target := 71, scalar := 11 },{ source := 139, target := 191, scalar := 13 }] }
theorem rowR6_0026_000_13_valid : (rowR6_0026_000_13).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_14 : ExtensionRow := { move := 101, child := 155, matrix := ![14,1,6,15,1,10,1,1,1], witnesses := [{ source := 0, target := 72, scalar := 6 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 147, scalar := 9 },{ source := 52, target := 17, scalar := 6 },{ source := 101, target := 1, scalar := 4 },{ source := 139, target := 0, scalar := 12 }] }
theorem rowR6_0026_000_14_valid : (rowR6_0026_000_14).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_15 : ExtensionRow := { move := 103, child := 322, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 103, target := 78, scalar := 3 },{ source := 139, target := 268, scalar := 13 }] }
theorem rowR6_0026_000_15_valid : (rowR6_0026_000_15).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_16 : ExtensionRow := { move := 104, child := 271, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 104, target := 75, scalar := 2 },{ source := 139, target := 191, scalar := 13 }] }
theorem rowR6_0026_000_16_valid : (rowR6_0026_000_16).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_17 : ExtensionRow := { move := 106, child := 178, matrix := ![0,5,6,0,10,10,14,15,1], witnesses := [{ source := 0, target := 72, scalar := 6 },{ source := 1, target := 52, scalar := 5 },{ source := 17, target := 0, scalar := 14 },{ source := 34, target := 17, scalar := 3 },{ source := 52, target := 1, scalar := 10 },{ source := 106, target := 34, scalar := 1 },{ source := 139, target := 208, scalar := 1 }] }
theorem rowR6_0026_000_17_valid : (rowR6_0026_000_17).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_18 : ExtensionRow := { move := 109, child := 228, matrix := ![0,14,15,0,1,0,6,7,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 74, scalar := 14 },{ source := 17, target := 0, scalar := 6 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 151, scalar := 13 },{ source := 109, target := 52, scalar := 11 },{ source := 139, target := 1, scalar := 7 }] }
theorem rowR6_0026_000_18_valid : (rowR6_0026_000_18).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_19 : ExtensionRow := { move := 110, child := 276, matrix := ![0,6,1,9,10,1,0,9,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 75, scalar := 6 },{ source := 17, target := 1, scalar := 9 },{ source := 34, target := 214, scalar := 7 },{ source := 52, target := 52, scalar := 15 },{ source := 110, target := 0, scalar := 6 },{ source := 139, target := 17, scalar := 11 }] }
theorem rowR6_0026_000_19_valid : (rowR6_0026_000_19).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_20 : ExtensionRow := { move := 112, child := 76, matrix := ![1,2,3,1,4,5,1,6,10], witnesses := [{ source := 0, target := 71, scalar := 3 },{ source := 1, target := 52, scalar := 2 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 13 },{ source := 52, target := 1, scalar := 6 },{ source := 112, target := 17, scalar := 9 },{ source := 139, target := 101, scalar := 2 }] }
theorem rowR6_0026_000_20_valid : (rowR6_0026_000_20).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_21 : ExtensionRow := { move := 115, child := 173, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 115, target := 72, scalar := 1 },{ source := 139, target := 199, scalar := 1 }] }
theorem rowR6_0026_000_21_valid : (rowR6_0026_000_21).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_22 : ExtensionRow := { move := 117, child := 288, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 117, target := 75, scalar := 2 },{ source := 139, target := 268, scalar := 13 }] }
theorem rowR6_0026_000_22_valid : (rowR6_0026_000_22).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_23 : ExtensionRow := { move := 120, child := 434, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 120, target := 120, scalar := 1 },{ source := 139, target := 139, scalar := 1 }] }
theorem rowR6_0026_000_23_valid : (rowR6_0026_000_23).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_24 : ExtensionRow := { move := 121, child := 291, matrix := ![15,0,5,2,0,2,7,14,9], witnesses := [{ source := 0, target := 109, scalar := 5 },{ source := 1, target := 0, scalar := 14 },{ source := 17, target := 78, scalar := 15 },{ source := 34, target := 17, scalar := 10 },{ source := 52, target := 1, scalar := 4 },{ source := 121, target := 34, scalar := 1 },{ source := 139, target := 52, scalar := 11 }] }
theorem rowR6_0026_000_24_valid : (rowR6_0026_000_24).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_25 : ExtensionRow := { move := 122, child := 336, matrix := ![9,2,10,8,0,9,14,0,15], witnesses := [{ source := 0, target := 121, scalar := 10 },{ source := 1, target := 17, scalar := 2 },{ source := 17, target := 80, scalar := 9 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 0, scalar := 12 },{ source := 122, target := 1, scalar := 5 },{ source := 139, target := 52, scalar := 15 }] }
theorem rowR6_0026_000_25_valid : (rowR6_0026_000_25).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_26 : ExtensionRow := { move := 124, child := 380, matrix := ![1,0,5,1,7,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 5 },{ source := 1, target := 1, scalar := 7 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 158, scalar := 4 },{ source := 52, target := 52, scalar := 14 },{ source := 124, target := 0, scalar := 1 },{ source := 139, target := 92, scalar := 5 }] }
theorem rowR6_0026_000_26_valid : (rowR6_0026_000_26).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_27 : ExtensionRow := { move := 125, child := 342, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 125, target := 80, scalar := 10 },{ source := 139, target := 191, scalar := 13 }] }
theorem rowR6_0026_000_27_valid : (rowR6_0026_000_27).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_28 : ExtensionRow := { move := 126, child := 202, matrix := ![6,15,8,7,13,11,15,2,12], witnesses := [{ source := 0, target := 73, scalar := 8 },{ source := 1, target := 52, scalar := 15 },{ source := 17, target := 124, scalar := 6 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 0, scalar := 12 },{ source := 126, target := 1, scalar := 9 },{ source := 139, target := 17, scalar := 2 }] }
theorem rowR6_0026_000_28_valid : (rowR6_0026_000_28).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_29 : ExtensionRow := { move := 128, child := 84, matrix := ![0,10,12,0,7,0,9,13,0], witnesses := [{ source := 0, target := 17, scalar := 12 },{ source := 1, target := 52, scalar := 10 },{ source := 17, target := 0, scalar := 9 },{ source := 34, target := 128, scalar := 6 },{ source := 52, target := 1, scalar := 14 },{ source := 128, target := 34, scalar := 1 },{ source := 139, target := 71, scalar := 2 }] }
theorem rowR6_0026_000_29_valid : (rowR6_0026_000_29).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_30 : ExtensionRow := { move := 150, child := 170, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 139, target := 191, scalar := 13 },{ source := 150, target := 72, scalar := 13 }] }
theorem rowR6_0026_000_30_valid : (rowR6_0026_000_30).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_31 : ExtensionRow := { move := 151, child := 242, matrix := ![0,1,1,15,12,3,0,13,9], witnesses := [{ source := 0, target := 74, scalar := 1 },{ source := 1, target := 222, scalar := 1 },{ source := 17, target := 1, scalar := 15 },{ source := 34, target := 0, scalar := 4 },{ source := 52, target := 34, scalar := 1 },{ source := 139, target := 17, scalar := 13 },{ source := 151, target := 52, scalar := 14 }] }
theorem rowR6_0026_000_31_valid : (rowR6_0026_000_31).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_32 : ExtensionRow := { move := 152, child := 393, matrix := ![0,4,7,13,15,14,0,13,9], witnesses := [{ source := 0, target := 52, scalar := 7 },{ source := 1, target := 143, scalar := 4 },{ source := 17, target := 1, scalar := 13 },{ source := 34, target := 94, scalar := 3 },{ source := 52, target := 34, scalar := 1 },{ source := 139, target := 17, scalar := 12 },{ source := 152, target := 0, scalar := 8 }] }
theorem rowR6_0026_000_32_valid : (rowR6_0026_000_32).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_33 : ExtensionRow := { move := 154, child := 318, matrix := ![0,0,1,0,1,1,1,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 256, scalar := 3 },{ source := 139, target := 78, scalar := 10 },{ source := 154, target := 52, scalar := 9 }] }
theorem rowR6_0026_000_33_valid : (rowR6_0026_000_33).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_34 : ExtensionRow := { move := 156, child := 87, matrix := ![3,14,4,9,1,8,14,2,12], witnesses := [{ source := 0, target := 52, scalar := 4 },{ source := 1, target := 71, scalar := 14 },{ source := 17, target := 140, scalar := 3 },{ source := 34, target := 17, scalar := 9 },{ source := 52, target := 0, scalar := 13 },{ source := 139, target := 34, scalar := 1 },{ source := 156, target := 1, scalar := 6 }] }
theorem rowR6_0026_000_34_valid : (rowR6_0026_000_34).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_35 : ExtensionRow := { move := 158, child := 21, matrix := ![2,1,0,6,1,13,8,1,0], witnesses := [{ source := 0, target := 1, scalar := 13 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 69, scalar := 2 },{ source := 34, target := 120, scalar := 3 },{ source := 52, target := 0, scalar := 10 },{ source := 139, target := 52, scalar := 5 },{ source := 158, target := 17, scalar := 10 }] }
theorem rowR6_0026_000_35_valid : (rowR6_0026_000_35).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_36 : ExtensionRow := { move := 159, child := 110, matrix := ![0,7,7,0,4,9,14,15,1], witnesses := [{ source := 0, target := 71, scalar := 7 },{ source := 1, target := 197, scalar := 7 },{ source := 17, target := 0, scalar := 14 },{ source := 34, target := 1, scalar := 13 },{ source := 52, target := 17, scalar := 7 },{ source := 139, target := 52, scalar := 5 },{ source := 159, target := 34, scalar := 1 }] }
theorem rowR6_0026_000_36_valid : (rowR6_0026_000_36).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_37 : ExtensionRow := { move := 163, child := 208, matrix := ![14,14,0,1,0,0,9,0,9], witnesses := [{ source := 0, target := 0, scalar := 9 },{ source := 1, target := 17, scalar := 14 },{ source := 17, target := 73, scalar := 14 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 34, scalar := 1 },{ source := 139, target := 167, scalar := 2 },{ source := 163, target := 52, scalar := 9 }] }
theorem rowR6_0026_000_37_valid : (rowR6_0026_000_37).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_38 : ExtensionRow := { move := 166, child := 124, matrix := ![3,0,1,5,0,1,10,13,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 0, scalar := 13 },{ source := 17, target := 71, scalar := 3 },{ source := 34, target := 52, scalar := 2 },{ source := 52, target := 1, scalar := 6 },{ source := 139, target := 235, scalar := 9 },{ source := 166, target := 17, scalar := 6 }] }
theorem rowR6_0026_000_38_valid : (rowR6_0026_000_38).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_39 : ExtensionRow := { move := 167, child := 258, matrix := ![0,8,15,11,5,0,0,9,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 127, scalar := 8 },{ source := 17, target := 1, scalar := 11 },{ source := 34, target := 52, scalar := 7 },{ source := 52, target := 34, scalar := 1 },{ source := 139, target := 75, scalar := 1 },{ source := 167, target := 0, scalar := 13 }] }
theorem rowR6_0026_000_39_valid : (rowR6_0026_000_39).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_40 : ExtensionRow := { move := 169, child := 31, matrix := ![5,0,9,14,6,8,2,0,2], witnesses := [{ source := 0, target := 69, scalar := 9 },{ source := 1, target := 1, scalar := 6 },{ source := 17, target := 150, scalar := 5 },{ source := 34, target := 17, scalar := 12 },{ source := 52, target := 52, scalar := 13 },{ source := 139, target := 0, scalar := 5 },{ source := 169, target := 34, scalar := 1 }] }
theorem rowR6_0026_000_40_valid : (rowR6_0026_000_40).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_41 : ExtensionRow := { move := 172, child := 338, matrix := ![10,5,0,15,15,0,3,6,5], witnesses := [{ source := 0, target := 0, scalar := 5 },{ source := 1, target := 80, scalar := 5 },{ source := 17, target := 152, scalar := 10 },{ source := 34, target := 17, scalar := 15 },{ source := 52, target := 1, scalar := 2 },{ source := 139, target := 52, scalar := 2 },{ source := 172, target := 34, scalar := 1 }] }
theorem rowR6_0026_000_41_valid : (rowR6_0026_000_41).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_42 : ExtensionRow := { move := 173, child := 320, matrix := ![15,12,3,13,8,5,2,14,4], witnesses := [{ source := 0, target := 78, scalar := 3 },{ source := 1, target := 263, scalar := 12 },{ source := 17, target := 52, scalar := 15 },{ source := 34, target := 0, scalar := 8 },{ source := 52, target := 34, scalar := 1 },{ source := 139, target := 1, scalar := 4 },{ source := 173, target := 17, scalar := 14 }] }
theorem rowR6_0026_000_42_valid : (rowR6_0026_000_42).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_43 : ExtensionRow := { move := 176, child := 185, matrix := ![15,0,1,0,0,1,0,13,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 0, scalar := 13 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 72, scalar := 14 },{ source := 52, target := 233, scalar := 12 },{ source := 139, target := 52, scalar := 5 },{ source := 176, target := 1, scalar := 15 }] }
theorem rowR6_0026_000_43_valid : (rowR6_0026_000_43).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_44 : ExtensionRow := { move := 181, child := 149, matrix := ![1,6,0,1,10,11,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 11 },{ source := 1, target := 72, scalar := 6 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 7 },{ source := 52, target := 125, scalar := 13 },{ source := 139, target := 0, scalar := 6 },{ source := 181, target := 52, scalar := 8 }] }
theorem rowR6_0026_000_44_valid : (rowR6_0026_000_44).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_45 : ExtensionRow := { move := 183, child := 236, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 139, target := 191, scalar := 13 },{ source := 183, target := 74, scalar := 12 }] }
theorem rowR6_0026_000_45_valid : (rowR6_0026_000_45).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_46 : ExtensionRow := { move := 184, child := 361, matrix := ![4,5,0,6,0,7,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 7 },{ source := 1, target := 17, scalar := 5 },{ source := 17, target := 158, scalar := 4 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 14 },{ source := 139, target := 91, scalar := 12 },{ source := 184, target := 0, scalar := 1 }] }
theorem rowR6_0026_000_46_valid : (rowR6_0026_000_46).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowR6_0026_000_47 : ExtensionRow := { move := 185, child := 379, matrix := ![1,5,6,1,14,11,1,8,15], witnesses := [{ source := 0, target := 92, scalar := 6 },{ source := 1, target := 152, scalar := 5 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 52, scalar := 2 },{ source := 52, target := 17, scalar := 1 },{ source := 139, target := 1, scalar := 15 },{ source := 185, target := 0, scalar := 15 }] }
theorem rowR6_0026_000_47_valid : (rowR6_0026_000_47).ValidFor level7 {0,1,17,34,52,139} := by decide

noncomputable def rowsR6_0026_000 : List ExtensionRow := [rowR6_0026_000_0,rowR6_0026_000_1,rowR6_0026_000_2,rowR6_0026_000_3,rowR6_0026_000_4,rowR6_0026_000_5,rowR6_0026_000_6,rowR6_0026_000_7,rowR6_0026_000_8,rowR6_0026_000_9,rowR6_0026_000_10,rowR6_0026_000_11,rowR6_0026_000_12,rowR6_0026_000_13,rowR6_0026_000_14,rowR6_0026_000_15,rowR6_0026_000_16,rowR6_0026_000_17,rowR6_0026_000_18,rowR6_0026_000_19,rowR6_0026_000_20,rowR6_0026_000_21,rowR6_0026_000_22,rowR6_0026_000_23,rowR6_0026_000_24,rowR6_0026_000_25,rowR6_0026_000_26,rowR6_0026_000_27,rowR6_0026_000_28,rowR6_0026_000_29,rowR6_0026_000_30,rowR6_0026_000_31,rowR6_0026_000_32,rowR6_0026_000_33,rowR6_0026_000_34,rowR6_0026_000_35,rowR6_0026_000_36,rowR6_0026_000_37,rowR6_0026_000_38,rowR6_0026_000_39,rowR6_0026_000_40,rowR6_0026_000_41,rowR6_0026_000_42,rowR6_0026_000_43,rowR6_0026_000_44,rowR6_0026_000_45,rowR6_0026_000_46,rowR6_0026_000_47]

theorem rowsR6_0026_000_valid : RowListValid level7 {0,1,17,34,52,139} rowsR6_0026_000 := by
  intro r hr
  simp only [rowsR6_0026_000, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR6_0026_000_0_valid
  · exact rowR6_0026_000_1_valid
  · exact rowR6_0026_000_2_valid
  · exact rowR6_0026_000_3_valid
  · exact rowR6_0026_000_4_valid
  · exact rowR6_0026_000_5_valid
  · exact rowR6_0026_000_6_valid
  · exact rowR6_0026_000_7_valid
  · exact rowR6_0026_000_8_valid
  · exact rowR6_0026_000_9_valid
  · exact rowR6_0026_000_10_valid
  · exact rowR6_0026_000_11_valid
  · exact rowR6_0026_000_12_valid
  · exact rowR6_0026_000_13_valid
  · exact rowR6_0026_000_14_valid
  · exact rowR6_0026_000_15_valid
  · exact rowR6_0026_000_16_valid
  · exact rowR6_0026_000_17_valid
  · exact rowR6_0026_000_18_valid
  · exact rowR6_0026_000_19_valid
  · exact rowR6_0026_000_20_valid
  · exact rowR6_0026_000_21_valid
  · exact rowR6_0026_000_22_valid
  · exact rowR6_0026_000_23_valid
  · exact rowR6_0026_000_24_valid
  · exact rowR6_0026_000_25_valid
  · exact rowR6_0026_000_26_valid
  · exact rowR6_0026_000_27_valid
  · exact rowR6_0026_000_28_valid
  · exact rowR6_0026_000_29_valid
  · exact rowR6_0026_000_30_valid
  · exact rowR6_0026_000_31_valid
  · exact rowR6_0026_000_32_valid
  · exact rowR6_0026_000_33_valid
  · exact rowR6_0026_000_34_valid
  · exact rowR6_0026_000_35_valid
  · exact rowR6_0026_000_36_valid
  · exact rowR6_0026_000_37_valid
  · exact rowR6_0026_000_38_valid
  · exact rowR6_0026_000_39_valid
  · exact rowR6_0026_000_40_valid
  · exact rowR6_0026_000_41_valid
  · exact rowR6_0026_000_42_valid
  · exact rowR6_0026_000_43_valid
  · exact rowR6_0026_000_44_valid
  · exact rowR6_0026_000_45_valid
  · exact rowR6_0026_000_46_valid
  · exact rowR6_0026_000_47_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
