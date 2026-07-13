import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR6_0023_000_0 : ExtensionRow := { move := 67, child := 1, matrix := ![1,1,1,1,3,2,1,2,3], witnesses := [{ source := 0, target := 52, scalar := 1 },{ source := 1, target := 67, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 1, scalar := 1 },{ source := 67, target := 0, scalar := 1 },{ source := 128, target := 91, scalar := 8 }] }
theorem rowR6_0023_000_0_valid : (rowR6_0023_000_0).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_1 : ExtensionRow := { move := 69, child := 25, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 69, target := 69, scalar := 1 },{ source := 128, target := 128, scalar := 1 }] }
theorem rowR6_0023_000_1_valid : (rowR6_0023_000_1).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_2 : ExtensionRow := { move := 71, child := 84, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 71, target := 71, scalar := 1 },{ source := 128, target := 128, scalar := 1 }] }
theorem rowR6_0023_000_2_valid : (rowR6_0023_000_2).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_3 : ExtensionRow := { move := 72, child := 56, matrix := ![0,9,0,3,1,0,0,8,15], witnesses := [{ source := 0, target := 0, scalar := 15 },{ source := 1, target := 52, scalar := 9 },{ source := 17, target := 1, scalar := 3 },{ source := 34, target := 95, scalar := 9 },{ source := 52, target := 34, scalar := 1 },{ source := 72, target := 17, scalar := 8 },{ source := 128, target := 70, scalar := 3 }] }
theorem rowR6_0023_000_3_valid : (rowR6_0023_000_3).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_4 : ExtensionRow := { move := 73, child := 172, matrix := ![3,0,3,5,0,6,9,12,5], witnesses := [{ source := 0, target := 52, scalar := 3 },{ source := 1, target := 0, scalar := 12 },{ source := 17, target := 72, scalar := 3 },{ source := 34, target := 1, scalar := 3 },{ source := 52, target := 198, scalar := 6 },{ source := 73, target := 17, scalar := 8 },{ source := 128, target := 34, scalar := 1 }] }
theorem rowR6_0023_000_4_valid : (rowR6_0023_000_4).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_5 : ExtensionRow := { move := 74, child := 223, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 74, target := 74, scalar := 1 },{ source := 128, target := 128, scalar := 1 }] }
theorem rowR6_0023_000_5_valid : (rowR6_0023_000_5).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_6 : ExtensionRow := { move := 75, child := 186, matrix := ![7,0,2,9,0,9,6,13,11], witnesses := [{ source := 0, target := 237, scalar := 2 },{ source := 1, target := 0, scalar := 13 },{ source := 17, target := 72, scalar := 7 },{ source := 34, target := 17, scalar := 5 },{ source := 52, target := 34, scalar := 1 },{ source := 75, target := 1, scalar := 12 },{ source := 128, target := 52, scalar := 10 }] }
theorem rowR6_0023_000_6_valid : (rowR6_0023_000_6).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_7 : ExtensionRow := { move := 78, child := 173, matrix := ![14,0,9,15,11,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 1, scalar := 11 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 199, scalar := 7 },{ source := 52, target := 72, scalar := 6 },{ source := 78, target := 34, scalar := 1 },{ source := 128, target := 0, scalar := 1 }] }
theorem rowR6_0023_000_7_valid : (rowR6_0023_000_7).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_8 : ExtensionRow := { move := 83, child := 56, matrix := ![0,1,0,0,1,2,4,1,0], witnesses := [{ source := 0, target := 1, scalar := 2 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 4 },{ source := 34, target := 70, scalar := 1 },{ source := 52, target := 52, scalar := 2 },{ source := 83, target := 17, scalar := 4 },{ source := 128, target := 95, scalar := 6 }] }
theorem rowR6_0023_000_8_valid : (rowR6_0023_000_8).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_9 : ExtensionRow := { move := 86, child := 68, matrix := ![14,15,1,1,0,1,3,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 15 },{ source := 17, target := 70, scalar := 14 },{ source := 34, target := 0, scalar := 2 },{ source := 52, target := 1, scalar := 2 },{ source := 86, target := 52, scalar := 2 },{ source := 128, target := 158, scalar := 5 }] }
theorem rowR6_0023_000_9_valid : (rowR6_0023_000_9).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_10 : ExtensionRow := { move := 89, child := 96, matrix := ![2,1,0,4,1,0,6,1,13], witnesses := [{ source := 0, target := 0, scalar := 13 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 2 },{ source := 34, target := 71, scalar := 3 },{ source := 52, target := 1, scalar := 6 },{ source := 89, target := 17, scalar := 6 },{ source := 128, target := 166, scalar := 4 }] }
theorem rowR6_0023_000_10_valid : (rowR6_0023_000_10).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_11 : ExtensionRow := { move := 93, child := 63, matrix := ![15,7,0,0,14,11,0,9,0], witnesses := [{ source := 0, target := 1, scalar := 11 },{ source := 1, target := 52, scalar := 7 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 127, scalar := 8 },{ source := 52, target := 34, scalar := 1 },{ source := 93, target := 0, scalar := 2 },{ source := 128, target := 70, scalar := 14 }] }
theorem rowR6_0023_000_11_valid : (rowR6_0023_000_11).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_12 : ExtensionRow := { move := 94, child := 389, matrix := ![0,0,1,0,14,1,13,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 1, scalar := 14 },{ source := 17, target := 0, scalar := 13 },{ source := 34, target := 269, scalar := 1 },{ source := 52, target := 92, scalar := 3 },{ source := 94, target := 17, scalar := 13 },{ source := 128, target := 52, scalar := 15 }] }
theorem rowR6_0023_000_12_valid : (rowR6_0023_000_12).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_13 : ExtensionRow := { move := 95, child := 160, matrix := ![14,7,0,1,0,0,12,0,4], witnesses := [{ source := 0, target := 0, scalar := 4 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 72, scalar := 14 },{ source := 34, target := 52, scalar := 9 },{ source := 52, target := 1, scalar := 1 },{ source := 95, target := 34, scalar := 1 },{ source := 128, target := 159, scalar := 15 }] }
theorem rowR6_0023_000_13_valid : (rowR6_0023_000_13).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_14 : ExtensionRow := { move := 99, child := 44, matrix := ![15,10,5,13,13,0,2,14,0], witnesses := [{ source := 0, target := 17, scalar := 5 },{ source := 1, target := 69, scalar := 10 },{ source := 17, target := 52, scalar := 15 },{ source := 34, target := 0, scalar := 12 },{ source := 52, target := 201, scalar := 7 },{ source := 99, target := 34, scalar := 1 },{ source := 128, target := 1, scalar := 5 }] }
theorem rowR6_0023_000_14_valid : (rowR6_0023_000_14).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_15 : ExtensionRow := { move := 101, child := 195, matrix := ![1,7,0,1,14,11,1,9,0], witnesses := [{ source := 0, target := 1, scalar := 11 },{ source := 1, target := 52, scalar := 7 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 270, scalar := 6 },{ source := 52, target := 17, scalar := 15 },{ source := 101, target := 72, scalar := 9 },{ source := 128, target := 0, scalar := 2 }] }
theorem rowR6_0023_000_15_valid : (rowR6_0023_000_15).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_16 : ExtensionRow := { move := 103, child := 226, matrix := ![9,1,8,10,1,11,14,1,4], witnesses := [{ source := 0, target := 74, scalar := 8 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 144, scalar := 9 },{ source := 34, target := 0, scalar := 11 },{ source := 52, target := 1, scalar := 6 },{ source := 103, target := 17, scalar := 9 },{ source := 128, target := 52, scalar := 14 }] }
theorem rowR6_0023_000_16_valid : (rowR6_0023_000_16).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_17 : ExtensionRow := { move := 104, child := 278, matrix := ![9,8,1,6,11,1,14,15,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 75, scalar := 8 },{ source := 17, target := 224, scalar := 9 },{ source := 34, target := 1, scalar := 12 },{ source := 52, target := 17, scalar := 9 },{ source := 104, target := 0, scalar := 15 },{ source := 128, target := 52, scalar := 3 }] }
theorem rowR6_0023_000_17_valid : (rowR6_0023_000_17).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_18 : ExtensionRow := { move := 108, child := 186, matrix := ![12,1,11,3,1,14,15,1,4], witnesses := [{ source := 0, target := 72, scalar := 11 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 237, scalar := 12 },{ source := 34, target := 52, scalar := 6 },{ source := 52, target := 0, scalar := 1 },{ source := 108, target := 1, scalar := 14 },{ source := 128, target := 17, scalar := 9 }] }
theorem rowR6_0023_000_18_valid : (rowR6_0023_000_18).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_19 : ExtensionRow := { move := 109, child := 349, matrix := ![0,8,1,5,3,1,0,11,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 52, scalar := 8 },{ source := 17, target := 1, scalar := 5 },{ source := 34, target := 248, scalar := 9 },{ source := 52, target := 0, scalar := 6 },{ source := 109, target := 80, scalar := 2 },{ source := 128, target := 17, scalar := 10 }] }
theorem rowR6_0023_000_19_valid : (rowR6_0023_000_19).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_20 : ExtensionRow := { move := 110, child := 429, matrix := ![0,10,12,0,7,0,9,13,0], witnesses := [{ source := 0, target := 17, scalar := 12 },{ source := 1, target := 52, scalar := 10 },{ source := 17, target := 0, scalar := 9 },{ source := 34, target := 128, scalar := 6 },{ source := 52, target := 1, scalar := 14 },{ source := 110, target := 110, scalar := 7 },{ source := 128, target := 34, scalar := 1 }] }
theorem rowR6_0023_000_20_valid : (rowR6_0023_000_20).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_21 : ExtensionRow := { move := 131, child := 96, matrix := ![0,0,14,0,8,15,2,0,1], witnesses := [{ source := 0, target := 52, scalar := 14 },{ source := 1, target := 1, scalar := 8 },{ source := 17, target := 0, scalar := 2 },{ source := 34, target := 166, scalar := 14 },{ source := 52, target := 34, scalar := 1 },{ source := 128, target := 71, scalar := 5 },{ source := 131, target := 17, scalar := 15 }] }
theorem rowR6_0023_000_21_valid : (rowR6_0023_000_21).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_22 : ExtensionRow := { move := 135, child := 370, matrix := ![0,8,1,5,3,1,0,11,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 52, scalar := 8 },{ source := 17, target := 1, scalar := 5 },{ source := 34, target := 248, scalar := 9 },{ source := 52, target := 0, scalar := 6 },{ source := 128, target := 17, scalar := 10 },{ source := 135, target := 91, scalar := 11 }] }
theorem rowR6_0023_000_22_valid : (rowR6_0023_000_22).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_23 : ExtensionRow := { move := 137, child := 356, matrix := ![7,15,8,14,0,5,9,0,9], witnesses := [{ source := 0, target := 127, scalar := 8 },{ source := 1, target := 17, scalar := 15 },{ source := 17, target := 52, scalar := 7 },{ source := 34, target := 1, scalar := 11 },{ source := 52, target := 34, scalar := 1 },{ source := 128, target := 91, scalar := 2 },{ source := 137, target := 0, scalar := 13 }] }
theorem rowR6_0023_000_23_valid : (rowR6_0023_000_23).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_24 : ExtensionRow := { move := 138, child := 445, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 128, target := 128, scalar := 1 },{ source := 138, target := 138, scalar := 1 }] }
theorem rowR6_0023_000_24_valid : (rowR6_0023_000_24).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_25 : ExtensionRow := { move := 139, child := 84, matrix := ![0,10,12,0,7,0,9,13,0], witnesses := [{ source := 0, target := 17, scalar := 12 },{ source := 1, target := 52, scalar := 10 },{ source := 17, target := 0, scalar := 9 },{ source := 34, target := 128, scalar := 6 },{ source := 52, target := 1, scalar := 14 },{ source := 128, target := 34, scalar := 1 },{ source := 139, target := 71, scalar := 2 }] }
theorem rowR6_0023_000_25_valid : (rowR6_0023_000_25).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_26 : ExtensionRow := { move := 140, child := 201, matrix := ![1,1,13,0,1,8,0,1,5], witnesses := [{ source := 0, target := 120, scalar := 13 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 52, scalar := 13 },{ source := 52, target := 73, scalar := 7 },{ source := 128, target := 1, scalar := 7 },{ source := 140, target := 0, scalar := 6 }] }
theorem rowR6_0023_000_26_valid : (rowR6_0023_000_26).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_27 : ExtensionRow := { move := 143, child := 443, matrix := ![7,1,0,6,6,0,1,13,12], witnesses := [{ source := 0, target := 0, scalar := 12 },{ source := 1, target := 126, scalar := 1 },{ source := 17, target := 135, scalar := 7 },{ source := 34, target := 17, scalar := 6 },{ source := 52, target := 52, scalar := 5 },{ source := 128, target := 34, scalar := 1 },{ source := 143, target := 1, scalar := 7 }] }
theorem rowR6_0023_000_27_valid : (rowR6_0023_000_27).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_28 : ExtensionRow := { move := 147, child := 125, matrix := ![8,1,9,2,2,0,10,3,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 52, scalar := 1 },{ source := 17, target := 237, scalar := 8 },{ source := 34, target := 0, scalar := 9 },{ source := 52, target := 71, scalar := 2 },{ source := 128, target := 1, scalar := 14 },{ source := 147, target := 34, scalar := 1 }] }
theorem rowR6_0023_000_28_valid : (rowR6_0023_000_28).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_29 : ExtensionRow := { move := 149, child := 173, matrix := ![3,6,5,0,10,10,0,1,15], witnesses := [{ source := 0, target := 52, scalar := 5 },{ source := 1, target := 72, scalar := 6 },{ source := 17, target := 17, scalar := 3 },{ source := 34, target := 0, scalar := 14 },{ source := 52, target := 1, scalar := 10 },{ source := 128, target := 199, scalar := 2 },{ source := 149, target := 34, scalar := 1 }] }
theorem rowR6_0023_000_29_valid : (rowR6_0023_000_29).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_30 : ExtensionRow := { move := 150, child := 195, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 128, target := 270, scalar := 9 },{ source := 150, target := 72, scalar := 13 }] }
theorem rowR6_0023_000_30_valid : (rowR6_0023_000_30).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_31 : ExtensionRow := { move := 151, child := 38, matrix := ![15,0,11,0,7,5,0,0,14], witnesses := [{ source := 0, target := 52, scalar := 11 },{ source := 1, target := 1, scalar := 7 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 171, scalar := 4 },{ source := 52, target := 34, scalar := 1 },{ source := 128, target := 69, scalar := 12 },{ source := 151, target := 0, scalar := 2 }] }
theorem rowR6_0023_000_31_valid : (rowR6_0023_000_31).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_32 : ExtensionRow := { move := 154, child := 93, matrix := ![1,0,14,1,1,1,1,0,2], witnesses := [{ source := 0, target := 71, scalar := 14 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 156, scalar := 15 },{ source := 52, target := 0, scalar := 7 },{ source := 128, target := 52, scalar := 4 },{ source := 154, target := 17, scalar := 6 }] }
theorem rowR6_0023_000_32_valid : (rowR6_0023_000_32).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_33 : ExtensionRow := { move := 155, child := 160, matrix := ![0,0,12,0,13,7,6,0,2], witnesses := [{ source := 0, target := 72, scalar := 12 },{ source := 1, target := 1, scalar := 13 },{ source := 17, target := 0, scalar := 6 },{ source := 34, target := 159, scalar := 12 },{ source := 52, target := 17, scalar := 7 },{ source := 128, target := 52, scalar := 8 },{ source := 155, target := 34, scalar := 1 }] }
theorem rowR6_0023_000_33_valid : (rowR6_0023_000_33).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_34 : ExtensionRow := { move := 156, child := 235, matrix := ![1,15,14,1,12,1,1,6,7], witnesses := [{ source := 0, target := 74, scalar := 14 },{ source := 1, target := 182, scalar := 15 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 12 },{ source := 52, target := 52, scalar := 13 },{ source := 128, target := 0, scalar := 13 },{ source := 156, target := 17, scalar := 8 }] }
theorem rowR6_0023_000_34_valid : (rowR6_0023_000_34).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_35 : ExtensionRow := { move := 158, child := 282, matrix := ![0,8,1,5,3,1,0,11,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 52, scalar := 8 },{ source := 17, target := 1, scalar := 5 },{ source := 34, target := 248, scalar := 9 },{ source := 52, target := 0, scalar := 6 },{ source := 128, target := 17, scalar := 10 },{ source := 158, target := 75, scalar := 1 }] }
theorem rowR6_0023_000_35_valid : (rowR6_0023_000_35).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_36 : ExtensionRow := { move := 166, child := 93, matrix := ![3,0,1,5,0,1,10,13,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 0, scalar := 13 },{ source := 17, target := 71, scalar := 3 },{ source := 34, target := 52, scalar := 2 },{ source := 52, target := 1, scalar := 6 },{ source := 128, target := 156, scalar := 12 },{ source := 166, target := 17, scalar := 6 }] }
theorem rowR6_0023_000_36_valid : (rowR6_0023_000_36).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_37 : ExtensionRow := { move := 167, child := 389, matrix := ![1,9,0,1,2,0,1,12,6], witnesses := [{ source := 0, target := 0, scalar := 6 },{ source := 1, target := 92, scalar := 9 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 52, scalar := 8 },{ source := 52, target := 1, scalar := 5 },{ source := 128, target := 269, scalar := 2 },{ source := 167, target := 17, scalar := 12 }] }
theorem rowR6_0023_000_37_valid : (rowR6_0023_000_37).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_38 : ExtensionRow := { move := 168, child := 315, matrix := ![1,10,11,1,0,6,1,0,1], witnesses := [{ source := 0, target := 230, scalar := 11 },{ source := 1, target := 17, scalar := 10 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 7 },{ source := 52, target := 78, scalar := 8 },{ source := 128, target := 52, scalar := 11 },{ source := 168, target := 0, scalar := 6 }] }
theorem rowR6_0023_000_38_valid : (rowR6_0023_000_38).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_39 : ExtensionRow := { move := 169, child := 162, matrix := ![15,0,5,0,15,10,0,0,15], witnesses := [{ source := 0, target := 52, scalar := 5 },{ source := 1, target := 1, scalar := 15 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 169, scalar := 10 },{ source := 52, target := 0, scalar := 2 },{ source := 128, target := 72, scalar := 9 },{ source := 169, target := 34, scalar := 1 }] }
theorem rowR6_0023_000_39_valid : (rowR6_0023_000_39).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_40 : ExtensionRow := { move := 171, child := 446, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 128, target := 128, scalar := 1 },{ source := 171, target := 171, scalar := 1 }] }
theorem rowR6_0023_000_40_valid : (rowR6_0023_000_40).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_41 : ExtensionRow := { move := 172, child := 154, matrix := ![8,1,9,11,1,10,13,1,7], witnesses := [{ source := 0, target := 143, scalar := 9 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 72, scalar := 8 },{ source := 34, target := 0, scalar := 11 },{ source := 52, target := 52, scalar := 2 },{ source := 128, target := 1, scalar := 1 },{ source := 172, target := 17, scalar := 13 }] }
theorem rowR6_0023_000_41_valid : (rowR6_0023_000_41).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_42 : ExtensionRow := { move := 175, child := 55, matrix := ![11,10,1,14,0,1,1,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 10 },{ source := 17, target := 70, scalar := 11 },{ source := 34, target := 1, scalar := 15 },{ source := 52, target := 52, scalar := 15 },{ source := 128, target := 94, scalar := 13 },{ source := 175, target := 0, scalar := 15 }] }
theorem rowR6_0023_000_42_valid : (rowR6_0023_000_42).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_43 : ExtensionRow := { move := 182, child := 1, matrix := ![5,0,1,10,8,1,15,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 1, scalar := 8 },{ source := 17, target := 52, scalar := 5 },{ source := 34, target := 91, scalar := 4 },{ source := 52, target := 67, scalar := 6 },{ source := 128, target := 17, scalar := 10 },{ source := 182, target := 0, scalar := 10 }] }
theorem rowR6_0023_000_43_valid : (rowR6_0023_000_43).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_44 : ExtensionRow := { move := 183, child := 55, matrix := ![1,11,9,1,5,8,1,14,11], witnesses := [{ source := 0, target := 70, scalar := 9 },{ source := 1, target := 52, scalar := 11 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 94, scalar := 3 },{ source := 52, target := 17, scalar := 12 },{ source := 128, target := 1, scalar := 13 },{ source := 183, target := 0, scalar := 8 }] }
theorem rowR6_0023_000_44_valid : (rowR6_0023_000_44).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_45 : ExtensionRow := { move := 184, child := 201, matrix := ![2,5,7,12,15,0,14,14,0], witnesses := [{ source := 0, target := 17, scalar := 7 },{ source := 1, target := 73, scalar := 5 },{ source := 17, target := 120, scalar := 2 },{ source := 34, target := 1, scalar := 3 },{ source := 52, target := 34, scalar := 1 },{ source := 128, target := 52, scalar := 4 },{ source := 184, target := 0, scalar := 8 }] }
theorem rowR6_0023_000_45_valid : (rowR6_0023_000_45).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_46 : ExtensionRow := { move := 186, child := 226, matrix := ![12,0,10,7,8,3,6,0,12], witnesses := [{ source := 0, target := 144, scalar := 10 },{ source := 1, target := 1, scalar := 8 },{ source := 17, target := 74, scalar := 12 },{ source := 34, target := 52, scalar := 6 },{ source := 52, target := 34, scalar := 1 },{ source := 128, target := 0, scalar := 14 },{ source := 186, target := 17, scalar := 9 }] }
theorem rowR6_0023_000_46_valid : (rowR6_0023_000_46).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowR6_0023_000_47 : ExtensionRow := { move := 188, child := 120, matrix := ![8,13,0,0,9,0,0,4,7], witnesses := [{ source := 0, target := 0, scalar := 7 },{ source := 1, target := 52, scalar := 13 },{ source := 17, target := 17, scalar := 8 },{ source := 34, target := 223, scalar := 5 },{ source := 52, target := 34, scalar := 1 },{ source := 128, target := 1, scalar := 3 },{ source := 188, target := 71, scalar := 3 }] }
theorem rowR6_0023_000_47_valid : (rowR6_0023_000_47).ValidFor level7 {0,1,17,34,52,128} := by decide

noncomputable def rowsR6_0023_000 : List ExtensionRow := [rowR6_0023_000_0,rowR6_0023_000_1,rowR6_0023_000_2,rowR6_0023_000_3,rowR6_0023_000_4,rowR6_0023_000_5,rowR6_0023_000_6,rowR6_0023_000_7,rowR6_0023_000_8,rowR6_0023_000_9,rowR6_0023_000_10,rowR6_0023_000_11,rowR6_0023_000_12,rowR6_0023_000_13,rowR6_0023_000_14,rowR6_0023_000_15,rowR6_0023_000_16,rowR6_0023_000_17,rowR6_0023_000_18,rowR6_0023_000_19,rowR6_0023_000_20,rowR6_0023_000_21,rowR6_0023_000_22,rowR6_0023_000_23,rowR6_0023_000_24,rowR6_0023_000_25,rowR6_0023_000_26,rowR6_0023_000_27,rowR6_0023_000_28,rowR6_0023_000_29,rowR6_0023_000_30,rowR6_0023_000_31,rowR6_0023_000_32,rowR6_0023_000_33,rowR6_0023_000_34,rowR6_0023_000_35,rowR6_0023_000_36,rowR6_0023_000_37,rowR6_0023_000_38,rowR6_0023_000_39,rowR6_0023_000_40,rowR6_0023_000_41,rowR6_0023_000_42,rowR6_0023_000_43,rowR6_0023_000_44,rowR6_0023_000_45,rowR6_0023_000_46,rowR6_0023_000_47]

theorem rowsR6_0023_000_valid : RowListValid level7 {0,1,17,34,52,128} rowsR6_0023_000 := by
  intro r hr
  simp only [rowsR6_0023_000, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR6_0023_000_0_valid
  · exact rowR6_0023_000_1_valid
  · exact rowR6_0023_000_2_valid
  · exact rowR6_0023_000_3_valid
  · exact rowR6_0023_000_4_valid
  · exact rowR6_0023_000_5_valid
  · exact rowR6_0023_000_6_valid
  · exact rowR6_0023_000_7_valid
  · exact rowR6_0023_000_8_valid
  · exact rowR6_0023_000_9_valid
  · exact rowR6_0023_000_10_valid
  · exact rowR6_0023_000_11_valid
  · exact rowR6_0023_000_12_valid
  · exact rowR6_0023_000_13_valid
  · exact rowR6_0023_000_14_valid
  · exact rowR6_0023_000_15_valid
  · exact rowR6_0023_000_16_valid
  · exact rowR6_0023_000_17_valid
  · exact rowR6_0023_000_18_valid
  · exact rowR6_0023_000_19_valid
  · exact rowR6_0023_000_20_valid
  · exact rowR6_0023_000_21_valid
  · exact rowR6_0023_000_22_valid
  · exact rowR6_0023_000_23_valid
  · exact rowR6_0023_000_24_valid
  · exact rowR6_0023_000_25_valid
  · exact rowR6_0023_000_26_valid
  · exact rowR6_0023_000_27_valid
  · exact rowR6_0023_000_28_valid
  · exact rowR6_0023_000_29_valid
  · exact rowR6_0023_000_30_valid
  · exact rowR6_0023_000_31_valid
  · exact rowR6_0023_000_32_valid
  · exact rowR6_0023_000_33_valid
  · exact rowR6_0023_000_34_valid
  · exact rowR6_0023_000_35_valid
  · exact rowR6_0023_000_36_valid
  · exact rowR6_0023_000_37_valid
  · exact rowR6_0023_000_38_valid
  · exact rowR6_0023_000_39_valid
  · exact rowR6_0023_000_40_valid
  · exact rowR6_0023_000_41_valid
  · exact rowR6_0023_000_42_valid
  · exact rowR6_0023_000_43_valid
  · exact rowR6_0023_000_44_valid
  · exact rowR6_0023_000_45_valid
  · exact rowR6_0023_000_46_valid
  · exact rowR6_0023_000_47_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
