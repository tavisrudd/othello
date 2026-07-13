import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR6_0029_000_0 : ExtensionRow := { move := 67, child := 3, matrix := ![1,1,1,3,0,1,2,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 67, scalar := 1 },{ source := 34, target := 52, scalar := 1 },{ source := 52, target := 0, scalar := 1 },{ source := 67, target := 1, scalar := 1 },{ source := 159, target := 159, scalar := 7 }] }
theorem rowR6_0029_000_0_valid : (rowR6_0029_000_0).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_1 : ExtensionRow := { move := 69, child := 35, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 69, target := 69, scalar := 1 },{ source := 159, target := 159, scalar := 1 }] }
theorem rowR6_0029_000_1_valid : (rowR6_0029_000_1).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_2 : ExtensionRow := { move := 70, child := 59, matrix := ![1,0,11,1,15,14,1,0,1], witnesses := [{ source := 0, target := 70, scalar := 11 },{ source := 1, target := 1, scalar := 15 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 10 },{ source := 52, target := 52, scalar := 15 },{ source := 70, target := 0, scalar := 4 },{ source := 159, target := 110, scalar := 9 }] }
theorem rowR6_0029_000_2_valid : (rowR6_0029_000_2).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_3 : ExtensionRow := { move := 71, child := 95, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 71, target := 71, scalar := 1 },{ source := 159, target := 159, scalar := 1 }] }
theorem rowR6_0029_000_3_valid : (rowR6_0029_000_3).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_4 : ExtensionRow := { move := 72, child := 160, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 72, target := 72, scalar := 1 },{ source := 159, target := 159, scalar := 1 }] }
theorem rowR6_0029_000_4_valid : (rowR6_0029_000_4).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_5 : ExtensionRow := { move := 74, child := 230, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 74, target := 74, scalar := 1 },{ source := 159, target := 159, scalar := 1 }] }
theorem rowR6_0029_000_5_valid : (rowR6_0029_000_5).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_6 : ExtensionRow := { move := 75, child := 264, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 75, scalar := 1 },{ source := 159, target := 159, scalar := 1 }] }
theorem rowR6_0029_000_6_valid : (rowR6_0029_000_6).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_7 : ExtensionRow := { move := 78, child := 240, matrix := ![0,11,9,14,5,0,0,14,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 52, scalar := 11 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 216, scalar := 2 },{ source := 52, target := 74, scalar := 13 },{ source := 78, target := 34, scalar := 1 },{ source := 159, target := 0, scalar := 9 }] }
theorem rowR6_0029_000_7_valid : (rowR6_0029_000_7).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_8 : ExtensionRow := { move := 83, child := 54, matrix := ![11,11,0,14,0,14,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 14 },{ source := 1, target := 17, scalar := 11 },{ source := 17, target := 70, scalar := 11 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 14 },{ source := 83, target := 34, scalar := 1 },{ source := 159, target := 91, scalar := 12 }] }
theorem rowR6_0029_000_8_valid : (rowR6_0029_000_8).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_9 : ExtensionRow := { move := 86, child := 63, matrix := ![0,1,15,0,1,0,2,1,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 2 },{ source := 34, target := 70, scalar := 14 },{ source := 52, target := 1, scalar := 2 },{ source := 86, target := 52, scalar := 2 },{ source := 159, target := 127, scalar := 13 }] }
theorem rowR6_0029_000_9_valid : (rowR6_0029_000_9).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_10 : ExtensionRow := { move := 89, child := 133, matrix := ![2,1,0,4,1,0,6,1,13], witnesses := [{ source := 0, target := 0, scalar := 13 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 2 },{ source := 34, target := 71, scalar := 3 },{ source := 52, target := 1, scalar := 6 },{ source := 89, target := 17, scalar := 6 },{ source := 159, target := 262, scalar := 10 }] }
theorem rowR6_0029_000_10_valid : (rowR6_0029_000_10).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_11 : ExtensionRow := { move := 91, child := 362, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 91, target := 91, scalar := 1 },{ source := 159, target := 159, scalar := 1 }] }
theorem rowR6_0029_000_11_valid : (rowR6_0029_000_11).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_12 : ExtensionRow := { move := 92, child := 378, matrix := ![10,11,0,3,5,7,15,14,0], witnesses := [{ source := 0, target := 1, scalar := 7 },{ source := 1, target := 52, scalar := 11 },{ source := 17, target := 137, scalar := 10 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 17, scalar := 15 },{ source := 92, target := 0, scalar := 2 },{ source := 159, target := 92, scalar := 13 }] }
theorem rowR6_0029_000_12_valid : (rowR6_0029_000_12).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_13 : ExtensionRow := { move := 93, child := 210, matrix := ![11,12,0,5,7,8,14,10,0], witnesses := [{ source := 0, target := 1, scalar := 8 },{ source := 1, target := 73, scalar := 12 },{ source := 17, target := 52, scalar := 11 },{ source := 34, target := 172, scalar := 7 },{ source := 52, target := 0, scalar := 9 },{ source := 93, target := 17, scalar := 14 },{ source := 159, target := 34, scalar := 1 }] }
theorem rowR6_0029_000_13_valid : (rowR6_0029_000_13).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_14 : ExtensionRow := { move := 96, child := 112, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 96, target := 71, scalar := 11 },{ source := 159, target := 205, scalar := 6 }] }
theorem rowR6_0029_000_14_valid : (rowR6_0029_000_14).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_15 : ExtensionRow := { move := 101, child := 353, matrix := ![11,0,6,1,0,0,13,6,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 0, scalar := 6 },{ source := 17, target := 109, scalar := 11 },{ source := 34, target := 91, scalar := 13 },{ source := 52, target := 34, scalar := 1 },{ source := 101, target := 1, scalar := 1 },{ source := 159, target := 52, scalar := 9 }] }
theorem rowR6_0029_000_15_valid : (rowR6_0029_000_15).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_16 : ExtensionRow := { move := 103, child := 171, matrix := ![2,9,10,0,12,13,0,2,3], witnesses := [{ source := 0, target := 72, scalar := 10 },{ source := 1, target := 197, scalar := 9 },{ source := 17, target := 17, scalar := 2 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 14 },{ source := 103, target := 1, scalar := 1 },{ source := 159, target := 0, scalar := 2 }] }
theorem rowR6_0029_000_16_valid : (rowR6_0029_000_16).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_17 : ExtensionRow := { move := 104, child := 210, matrix := ![1,8,4,1,3,2,1,11,10], witnesses := [{ source := 0, target := 172, scalar := 4 },{ source := 1, target := 52, scalar := 8 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 13 },{ source := 52, target := 73, scalar := 14 },{ source := 104, target := 0, scalar := 3 },{ source := 159, target := 1, scalar := 5 }] }
theorem rowR6_0029_000_17_valid : (rowR6_0029_000_17).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_18 : ExtensionRow := { move := 106, child := 145, matrix := ![0,5,6,0,10,10,14,15,1], witnesses := [{ source := 0, target := 72, scalar := 6 },{ source := 1, target := 52, scalar := 5 },{ source := 17, target := 0, scalar := 14 },{ source := 34, target := 17, scalar := 3 },{ source := 52, target := 1, scalar := 10 },{ source := 106, target := 34, scalar := 1 },{ source := 159, target := 107, scalar := 12 }] }
theorem rowR6_0029_000_18_valid : (rowR6_0029_000_18).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_19 : ExtensionRow := { move := 108, child := 412, matrix := ![10,1,6,8,1,0,5,1,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 186, scalar := 10 },{ source := 34, target := 52, scalar := 13 },{ source := 52, target := 107, scalar := 2 },{ source := 108, target := 1, scalar := 13 },{ source := 159, target := 0, scalar := 13 }] }
theorem rowR6_0029_000_19_valid : (rowR6_0029_000_19).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_20 : ExtensionRow := { move := 109, child := 394, matrix := ![14,12,3,13,10,6,10,14,5], witnesses := [{ source := 0, target := 52, scalar := 3 },{ source := 1, target := 151, scalar := 12 },{ source := 17, target := 94, scalar := 14 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 0, scalar := 10 },{ source := 109, target := 1, scalar := 7 },{ source := 159, target := 17, scalar := 5 }] }
theorem rowR6_0029_000_20_valid : (rowR6_0029_000_20).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_21 : ExtensionRow := { move := 110, child := 431, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 110, target := 110, scalar := 1 },{ source := 159, target := 159, scalar := 1 }] }
theorem rowR6_0029_000_21_valid : (rowR6_0029_000_21).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_22 : ExtensionRow := { move := 112, child := 127, matrix := ![1,2,3,1,4,5,1,6,10], witnesses := [{ source := 0, target := 71, scalar := 3 },{ source := 1, target := 52, scalar := 2 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 13 },{ source := 52, target := 1, scalar := 6 },{ source := 112, target := 17, scalar := 9 },{ source := 159, target := 240, scalar := 3 }] }
theorem rowR6_0029_000_22_valid : (rowR6_0029_000_22).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_23 : ExtensionRow := { move := 115, child := 133, matrix := ![14,0,14,5,10,15,3,0,1], witnesses := [{ source := 0, target := 52, scalar := 14 },{ source := 1, target := 1, scalar := 10 },{ source := 17, target := 262, scalar := 14 },{ source := 34, target := 0, scalar := 2 },{ source := 52, target := 17, scalar := 15 },{ source := 115, target := 34, scalar := 1 },{ source := 159, target := 71, scalar := 5 }] }
theorem rowR6_0029_000_23_valid : (rowR6_0029_000_23).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_24 : ExtensionRow := { move := 120, child := 435, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 120, target := 120, scalar := 1 },{ source := 159, target := 159, scalar := 1 }] }
theorem rowR6_0029_000_24_valid : (rowR6_0029_000_24).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_25 : ExtensionRow := { move := 121, child := 437, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 121, target := 121, scalar := 1 },{ source := 159, target := 159, scalar := 1 }] }
theorem rowR6_0029_000_25_valid : (rowR6_0029_000_25).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_26 : ExtensionRow := { move := 122, child := 317, matrix := ![14,0,15,0,4,5,0,0,1], witnesses := [{ source := 0, target := 249, scalar := 15 },{ source := 1, target := 1, scalar := 4 },{ source := 17, target := 17, scalar := 14 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 78, scalar := 12 },{ source := 122, target := 0, scalar := 9 },{ source := 159, target := 52, scalar := 11 }] }
theorem rowR6_0029_000_26_valid : (rowR6_0029_000_26).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_27 : ExtensionRow := { move := 124, child := 159, matrix := ![14,0,1,1,0,1,12,13,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 0, scalar := 13 },{ source := 17, target := 72, scalar := 14 },{ source := 34, target := 17, scalar := 15 },{ source := 52, target := 156, scalar := 13 },{ source := 124, target := 52, scalar := 5 },{ source := 159, target := 1, scalar := 15 }] }
theorem rowR6_0029_000_27_valid : (rowR6_0029_000_27).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_28 : ExtensionRow := { move := 125, child := 299, matrix := ![6,8,13,10,12,0,8,13,0], witnesses := [{ source := 0, target := 17, scalar := 13 },{ source := 1, target := 152, scalar := 8 },{ source := 17, target := 78, scalar := 6 },{ source := 34, target := 52, scalar := 3 },{ source := 52, target := 34, scalar := 1 },{ source := 125, target := 1, scalar := 4 },{ source := 159, target := 0, scalar := 10 }] }
theorem rowR6_0029_000_28_valid : (rowR6_0029_000_28).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_29 : ExtensionRow := { move := 131, child := 15, matrix := ![0,1,0,0,5,4,6,7,0], witnesses := [{ source := 0, target := 1, scalar := 4 },{ source := 1, target := 104, scalar := 1 },{ source := 17, target := 0, scalar := 6 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 69, scalar := 2 },{ source := 131, target := 17, scalar := 7 },{ source := 159, target := 52, scalar := 8 }] }
theorem rowR6_0029_000_29_valid : (rowR6_0029_000_29).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_30 : ExtensionRow := { move := 133, child := 182, matrix := ![3,1,14,5,1,4,9,1,8], witnesses := [{ source := 0, target := 220, scalar := 14 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 72, scalar := 3 },{ source := 34, target := 17, scalar := 12 },{ source := 52, target := 1, scalar := 11 },{ source := 133, target := 52, scalar := 9 },{ source := 159, target := 0, scalar := 8 }] }
theorem rowR6_0029_000_30_valid : (rowR6_0029_000_30).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_31 : ExtensionRow := { move := 135, child := 165, matrix := ![0,15,4,0,0,14,15,0,11], witnesses := [{ source := 0, target := 183, scalar := 4 },{ source := 1, target := 17, scalar := 15 },{ source := 17, target := 0, scalar := 15 },{ source := 34, target := 72, scalar := 11 },{ source := 52, target := 34, scalar := 1 },{ source := 135, target := 1, scalar := 2 },{ source := 159, target := 52, scalar := 12 }] }
theorem rowR6_0029_000_31_valid : (rowR6_0029_000_31).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_32 : ExtensionRow := { move := 139, child := 110, matrix := ![0,7,7,0,4,9,14,15,1], witnesses := [{ source := 0, target := 71, scalar := 7 },{ source := 1, target := 197, scalar := 7 },{ source := 17, target := 0, scalar := 14 },{ source := 34, target := 1, scalar := 13 },{ source := 52, target := 17, scalar := 7 },{ source := 139, target := 52, scalar := 5 },{ source := 159, target := 34, scalar := 1 }] }
theorem rowR6_0029_000_32_valid : (rowR6_0029_000_32).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_33 : ExtensionRow := { move := 140, child := 247, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 140, target := 74, scalar := 12 },{ source := 159, target := 235, scalar := 6 }] }
theorem rowR6_0029_000_33_valid : (rowR6_0029_000_33).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_34 : ExtensionRow := { move := 144, child := 413, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 144, target := 107, scalar := 8 },{ source := 159, target := 205, scalar := 6 }] }
theorem rowR6_0029_000_34_valid : (rowR6_0029_000_34).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_35 : ExtensionRow := { move := 163, child := 161, matrix := ![1,1,0,9,1,8,2,1,0], witnesses := [{ source := 0, target := 1, scalar := 8 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 163, scalar := 1 },{ source := 34, target := 0, scalar := 3 },{ source := 52, target := 17, scalar := 3 },{ source := 159, target := 72, scalar := 9 },{ source := 163, target := 52, scalar := 8 }] }
theorem rowR6_0029_000_35_valid : (rowR6_0029_000_35).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_36 : ExtensionRow := { move := 166, child := 108, matrix := ![3,0,1,5,0,1,10,13,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 0, scalar := 13 },{ source := 17, target := 71, scalar := 3 },{ source := 34, target := 52, scalar := 2 },{ source := 52, target := 1, scalar := 6 },{ source := 159, target := 188, scalar := 13 },{ source := 166, target := 17, scalar := 6 }] }
theorem rowR6_0029_000_36_valid : (rowR6_0029_000_36).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_37 : ExtensionRow := { move := 167, child := 376, matrix := ![1,9,0,1,2,0,1,12,6], witnesses := [{ source := 0, target := 0, scalar := 6 },{ source := 1, target := 92, scalar := 9 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 52, scalar := 8 },{ source := 52, target := 1, scalar := 5 },{ source := 159, target := 109, scalar := 5 },{ source := 167, target := 17, scalar := 12 }] }
theorem rowR6_0029_000_37_valid : (rowR6_0029_000_37).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_38 : ExtensionRow := { move := 168, child := 146, matrix := ![1,0,0,1,2,0,1,0,6], witnesses := [{ source := 0, target := 0, scalar := 6 },{ source := 1, target := 1, scalar := 2 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 72, scalar := 1 },{ source := 52, target := 108, scalar := 1 },{ source := 159, target := 52, scalar := 1 },{ source := 168, target := 17, scalar := 1 }] }
theorem rowR6_0029_000_38_valid : (rowR6_0029_000_38).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_39 : ExtensionRow := { move := 169, child := 31, matrix := ![1,15,0,1,13,5,1,2,0], witnesses := [{ source := 0, target := 1, scalar := 5 },{ source := 1, target := 52, scalar := 15 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 150, scalar := 14 },{ source := 52, target := 69, scalar := 12 },{ source := 159, target := 0, scalar := 2 },{ source := 169, target := 17, scalar := 15 }] }
theorem rowR6_0029_000_39_valid : (rowR6_0029_000_39).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_40 : ExtensionRow := { move := 171, child := 324, matrix := ![1,0,12,1,8,9,1,0,1], witnesses := [{ source := 0, target := 107, scalar := 12 },{ source := 1, target := 1, scalar := 8 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 13 },{ source := 52, target := 79, scalar := 6 },{ source := 159, target := 52, scalar := 5 },{ source := 171, target := 0, scalar := 11 }] }
theorem rowR6_0029_000_40_valid : (rowR6_0029_000_40).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_41 : ExtensionRow := { move := 173, child := 89, matrix := ![1,0,0,8,0,8,2,2,0], witnesses := [{ source := 0, target := 1, scalar := 8 },{ source := 1, target := 0, scalar := 2 },{ source := 17, target := 147, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 71, scalar := 1 },{ source := 159, target := 34, scalar := 1 },{ source := 173, target := 52, scalar := 1 }] }
theorem rowR6_0029_000_41_valid : (rowR6_0029_000_41).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_42 : ExtensionRow := { move := 176, child := 360, matrix := ![0,11,10,1,7,7,0,12,13], witnesses := [{ source := 0, target := 52, scalar := 10 },{ source := 1, target := 154, scalar := 11 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 91, scalar := 8 },{ source := 159, target := 17, scalar := 1 },{ source := 176, target := 0, scalar := 1 }] }
theorem rowR6_0029_000_42_valid : (rowR6_0029_000_42).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_43 : ExtensionRow := { move := 182, child := 346, matrix := ![0,1,15,6,1,13,0,1,2], witnesses := [{ source := 0, target := 52, scalar := 15 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 6 },{ source := 34, target := 230, scalar := 14 },{ source := 52, target := 0, scalar := 4 },{ source := 159, target := 80, scalar := 13 },{ source := 182, target := 17, scalar := 12 }] }
theorem rowR6_0029_000_43_valid : (rowR6_0029_000_43).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_44 : ExtensionRow := { move := 183, child := 239, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 159, target := 205, scalar := 6 },{ source := 183, target := 74, scalar := 12 }] }
theorem rowR6_0029_000_44_valid : (rowR6_0029_000_44).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_45 : ExtensionRow := { move := 186, child := 243, matrix := ![0,0,3,3,0,6,0,13,5], witnesses := [{ source := 0, target := 52, scalar := 3 },{ source := 1, target := 0, scalar := 13 },{ source := 17, target := 1, scalar := 3 },{ source := 34, target := 74, scalar := 3 },{ source := 52, target := 224, scalar := 5 },{ source := 159, target := 34, scalar := 1 },{ source := 186, target := 17, scalar := 8 }] }
theorem rowR6_0029_000_45_valid : (rowR6_0029_000_45).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_46 : ExtensionRow := { move := 188, child := 342, matrix := ![1,0,3,1,0,5,1,5,2], witnesses := [{ source := 0, target := 80, scalar := 3 },{ source := 1, target := 0, scalar := 5 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 52, scalar := 2 },{ source := 52, target := 191, scalar := 4 },{ source := 159, target := 1, scalar := 2 },{ source := 188, target := 17, scalar := 15 }] }
theorem rowR6_0029_000_46_valid : (rowR6_0029_000_46).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowR6_0029_000_47 : ExtensionRow := { move := 189, child := 14, matrix := ![4,10,1,12,0,1,3,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 10 },{ source := 17, target := 69, scalar := 4 },{ source := 34, target := 52, scalar := 15 },{ source := 52, target := 1, scalar := 15 },{ source := 159, target := 103, scalar := 5 },{ source := 189, target := 0, scalar := 15 }] }
theorem rowR6_0029_000_47_valid : (rowR6_0029_000_47).ValidFor level7 {0,1,17,34,52,159} := by decide

noncomputable def rowsR6_0029_000 : List ExtensionRow := [rowR6_0029_000_0,rowR6_0029_000_1,rowR6_0029_000_2,rowR6_0029_000_3,rowR6_0029_000_4,rowR6_0029_000_5,rowR6_0029_000_6,rowR6_0029_000_7,rowR6_0029_000_8,rowR6_0029_000_9,rowR6_0029_000_10,rowR6_0029_000_11,rowR6_0029_000_12,rowR6_0029_000_13,rowR6_0029_000_14,rowR6_0029_000_15,rowR6_0029_000_16,rowR6_0029_000_17,rowR6_0029_000_18,rowR6_0029_000_19,rowR6_0029_000_20,rowR6_0029_000_21,rowR6_0029_000_22,rowR6_0029_000_23,rowR6_0029_000_24,rowR6_0029_000_25,rowR6_0029_000_26,rowR6_0029_000_27,rowR6_0029_000_28,rowR6_0029_000_29,rowR6_0029_000_30,rowR6_0029_000_31,rowR6_0029_000_32,rowR6_0029_000_33,rowR6_0029_000_34,rowR6_0029_000_35,rowR6_0029_000_36,rowR6_0029_000_37,rowR6_0029_000_38,rowR6_0029_000_39,rowR6_0029_000_40,rowR6_0029_000_41,rowR6_0029_000_42,rowR6_0029_000_43,rowR6_0029_000_44,rowR6_0029_000_45,rowR6_0029_000_46,rowR6_0029_000_47]

theorem rowsR6_0029_000_valid : RowListValid level7 {0,1,17,34,52,159} rowsR6_0029_000 := by
  intro r hr
  simp only [rowsR6_0029_000, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR6_0029_000_0_valid
  · exact rowR6_0029_000_1_valid
  · exact rowR6_0029_000_2_valid
  · exact rowR6_0029_000_3_valid
  · exact rowR6_0029_000_4_valid
  · exact rowR6_0029_000_5_valid
  · exact rowR6_0029_000_6_valid
  · exact rowR6_0029_000_7_valid
  · exact rowR6_0029_000_8_valid
  · exact rowR6_0029_000_9_valid
  · exact rowR6_0029_000_10_valid
  · exact rowR6_0029_000_11_valid
  · exact rowR6_0029_000_12_valid
  · exact rowR6_0029_000_13_valid
  · exact rowR6_0029_000_14_valid
  · exact rowR6_0029_000_15_valid
  · exact rowR6_0029_000_16_valid
  · exact rowR6_0029_000_17_valid
  · exact rowR6_0029_000_18_valid
  · exact rowR6_0029_000_19_valid
  · exact rowR6_0029_000_20_valid
  · exact rowR6_0029_000_21_valid
  · exact rowR6_0029_000_22_valid
  · exact rowR6_0029_000_23_valid
  · exact rowR6_0029_000_24_valid
  · exact rowR6_0029_000_25_valid
  · exact rowR6_0029_000_26_valid
  · exact rowR6_0029_000_27_valid
  · exact rowR6_0029_000_28_valid
  · exact rowR6_0029_000_29_valid
  · exact rowR6_0029_000_30_valid
  · exact rowR6_0029_000_31_valid
  · exact rowR6_0029_000_32_valid
  · exact rowR6_0029_000_33_valid
  · exact rowR6_0029_000_34_valid
  · exact rowR6_0029_000_35_valid
  · exact rowR6_0029_000_36_valid
  · exact rowR6_0029_000_37_valid
  · exact rowR6_0029_000_38_valid
  · exact rowR6_0029_000_39_valid
  · exact rowR6_0029_000_40_valid
  · exact rowR6_0029_000_41_valid
  · exact rowR6_0029_000_42_valid
  · exact rowR6_0029_000_43_valid
  · exact rowR6_0029_000_44_valid
  · exact rowR6_0029_000_45_valid
  · exact rowR6_0029_000_46_valid
  · exact rowR6_0029_000_47_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
