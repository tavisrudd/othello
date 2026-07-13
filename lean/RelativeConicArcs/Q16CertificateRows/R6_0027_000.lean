import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR6_0027_000_0 : ExtensionRow := { move := 67, child := 1, matrix := ![1,1,1,0,3,2,0,2,3], witnesses := [{ source := 0, target := 52, scalar := 1 },{ source := 1, target := 67, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 0, scalar := 1 },{ source := 67, target := 1, scalar := 1 },{ source := 143, target := 91, scalar := 8 }] }
theorem rowR6_0027_000_0_valid : (rowR6_0027_000_0).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_1 : ExtensionRow := { move := 72, child := 154, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 72, target := 72, scalar := 1 },{ source := 143, target := 143, scalar := 1 }] }
theorem rowR6_0027_000_1_valid : (rowR6_0027_000_1).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_2 : ExtensionRow := { move := 73, child := 197, matrix := ![0,14,0,0,0,15,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 15 },{ source := 1, target := 17, scalar := 14 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 52, scalar := 14 },{ source := 52, target := 73, scalar := 15 },{ source := 73, target := 34, scalar := 1 },{ source := 143, target := 91, scalar := 12 }] }
theorem rowR6_0027_000_2_valid : (rowR6_0027_000_2).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_3 : ExtensionRow := { move := 74, child := 220, matrix := ![5,1,12,15,1,11,11,1,7], witnesses := [{ source := 0, target := 52, scalar := 12 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 74, scalar := 5 },{ source := 34, target := 120, scalar := 8 },{ source := 52, target := 1, scalar := 3 },{ source := 74, target := 0, scalar := 2 },{ source := 143, target := 17, scalar := 6 }] }
theorem rowR6_0027_000_3_valid : (rowR6_0027_000_3).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_4 : ExtensionRow := { move := 75, child := 261, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 75, target := 75, scalar := 1 },{ source := 143, target := 143, scalar := 1 }] }
theorem rowR6_0027_000_4_valid : (rowR6_0027_000_4).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_5 : ExtensionRow := { move := 78, child := 99, matrix := ![11,4,15,0,2,2,0,14,4], witnesses := [{ source := 0, target := 71, scalar := 15 },{ source := 1, target := 171, scalar := 4 },{ source := 17, target := 17, scalar := 11 },{ source := 34, target := 0, scalar := 10 },{ source := 52, target := 52, scalar := 1 },{ source := 78, target := 1, scalar := 15 },{ source := 143, target := 34, scalar := 1 }] }
theorem rowR6_0027_000_5_valid : (rowR6_0027_000_5).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_6 : ExtensionRow := { move := 80, child := 221, matrix := ![1,0,0,3,0,3,9,9,0], witnesses := [{ source := 0, target := 1, scalar := 3 },{ source := 1, target := 0, scalar := 9 },{ source := 17, target := 74, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 121, scalar := 1 },{ source := 80, target := 34, scalar := 1 },{ source := 143, target := 52, scalar := 1 }] }
theorem rowR6_0027_000_6_valid : (rowR6_0027_000_6).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_7 : ExtensionRow := { move := 83, child := 58, matrix := ![0,1,0,0,1,2,4,1,0], witnesses := [{ source := 0, target := 1, scalar := 2 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 4 },{ source := 34, target := 70, scalar := 1 },{ source := 52, target := 52, scalar := 2 },{ source := 83, target := 17, scalar := 4 },{ source := 143, target := 107, scalar := 7 }] }
theorem rowR6_0027_000_7_valid : (rowR6_0027_000_7).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_8 : ExtensionRow := { move := 86, child := 62, matrix := ![14,15,1,1,0,1,3,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 15 },{ source := 17, target := 70, scalar := 14 },{ source := 34, target := 0, scalar := 2 },{ source := 52, target := 1, scalar := 2 },{ source := 86, target := 52, scalar := 2 },{ source := 143, target := 125, scalar := 11 }] }
theorem rowR6_0027_000_8_valid : (rowR6_0027_000_8).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_9 : ExtensionRow := { move := 90, child := 91, matrix := ![12,12,1,10,11,1,6,7,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 52, scalar := 12 },{ source := 17, target := 154, scalar := 12 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 71, scalar := 4 },{ source := 90, target := 1, scalar := 9 },{ source := 143, target := 0, scalar := 14 }] }
theorem rowR6_0027_000_9_valid : (rowR6_0027_000_9).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_10 : ExtensionRow := { move := 91, child := 358, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 91, target := 91, scalar := 1 },{ source := 143, target := 143, scalar := 1 }] }
theorem rowR6_0027_000_10_valid : (rowR6_0027_000_10).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_11 : ExtensionRow := { move := 92, child := 117, matrix := ![1,0,0,12,14,0,8,0,11], witnesses := [{ source := 0, target := 0, scalar := 11 },{ source := 1, target := 1, scalar := 14 },{ source := 17, target := 217, scalar := 1 },{ source := 34, target := 52, scalar := 1 },{ source := 52, target := 71, scalar := 1 },{ source := 92, target := 34, scalar := 1 },{ source := 143, target := 17, scalar := 1 }] }
theorem rowR6_0027_000_11_valid : (rowR6_0027_000_11).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_12 : ExtensionRow := { move := 93, child := 300, matrix := ![8,2,10,11,4,15,2,6,5], witnesses := [{ source := 0, target := 154, scalar := 10 },{ source := 1, target := 52, scalar := 2 },{ source := 17, target := 78, scalar := 8 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 34, scalar := 1 },{ source := 93, target := 17, scalar := 1 },{ source := 143, target := 1, scalar := 1 }] }
theorem rowR6_0027_000_12_valid : (rowR6_0027_000_12).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_13 : ExtensionRow := { move := 94, child := 393, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 94, target := 94, scalar := 1 },{ source := 143, target := 143, scalar := 1 }] }
theorem rowR6_0027_000_13_valid : (rowR6_0027_000_13).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_14 : ExtensionRow := { move := 96, child := 127, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 96, target := 71, scalar := 11 },{ source := 143, target := 240, scalar := 9 }] }
theorem rowR6_0027_000_14_valid : (rowR6_0027_000_14).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_15 : ExtensionRow := { move := 101, child := 406, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 101, target := 101, scalar := 1 },{ source := 143, target := 143, scalar := 1 }] }
theorem rowR6_0027_000_15_valid : (rowR6_0027_000_15).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_16 : ExtensionRow := { move := 103, child := 281, matrix := ![5,0,15,0,0,7,0,7,10], witnesses := [{ source := 0, target := 240, scalar := 15 },{ source := 1, target := 0, scalar := 7 },{ source := 17, target := 17, scalar := 5 },{ source := 34, target := 52, scalar := 10 },{ source := 52, target := 75, scalar := 7 },{ source := 103, target := 34, scalar := 1 },{ source := 143, target := 1, scalar := 12 }] }
theorem rowR6_0027_000_16_valid : (rowR6_0027_000_16).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_17 : ExtensionRow := { move := 104, child := 281, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 104, target := 75, scalar := 2 },{ source := 143, target := 240, scalar := 9 }] }
theorem rowR6_0027_000_17_valid : (rowR6_0027_000_17).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_18 : ExtensionRow := { move := 106, child := 164, matrix := ![0,5,6,0,10,10,14,15,1], witnesses := [{ source := 0, target := 72, scalar := 6 },{ source := 1, target := 52, scalar := 5 },{ source := 17, target := 0, scalar := 14 },{ source := 34, target := 17, scalar := 3 },{ source := 52, target := 1, scalar := 10 },{ source := 106, target := 34, scalar := 1 },{ source := 143, target := 174, scalar := 10 }] }
theorem rowR6_0027_000_18_valid : (rowR6_0027_000_18).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_19 : ExtensionRow := { move := 109, child := 423, matrix := ![5,1,0,2,1,3,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 3 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 108, scalar := 5 },{ source := 34, target := 17, scalar := 4 },{ source := 52, target := 235, scalar := 7 },{ source := 109, target := 0, scalar := 4 },{ source := 143, target := 52, scalar := 2 }] }
theorem rowR6_0027_000_19_valid : (rowR6_0027_000_19).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_20 : ExtensionRow := { move := 110, child := 430, matrix := ![7,10,12,6,7,0,12,13,0], witnesses := [{ source := 0, target := 17, scalar := 12 },{ source := 1, target := 52, scalar := 10 },{ source := 17, target := 143, scalar := 7 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 110, scalar := 7 },{ source := 110, target := 1, scalar := 14 },{ source := 143, target := 0, scalar := 9 }] }
theorem rowR6_0027_000_20_valid : (rowR6_0027_000_20).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_21 : ExtensionRow := { move := 112, child := 71, matrix := ![1,2,3,1,4,5,1,6,10], witnesses := [{ source := 0, target := 71, scalar := 3 },{ source := 1, target := 52, scalar := 2 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 13 },{ source := 52, target := 1, scalar := 6 },{ source := 112, target := 17, scalar := 9 },{ source := 143, target := 91, scalar := 14 }] }
theorem rowR6_0027_000_21_valid : (rowR6_0027_000_21).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_22 : ExtensionRow := { move := 115, child := 191, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 115, target := 72, scalar := 1 },{ source := 143, target := 263, scalar := 1 }] }
theorem rowR6_0027_000_22_valid : (rowR6_0027_000_22).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_23 : ExtensionRow := { move := 117, child := 77, matrix := ![6,1,0,0,3,11,0,6,0], witnesses := [{ source := 0, target := 1, scalar := 11 },{ source := 1, target := 71, scalar := 1 },{ source := 17, target := 17, scalar := 6 },{ source := 34, target := 104, scalar := 7 },{ source := 52, target := 52, scalar := 4 },{ source := 117, target := 0, scalar := 7 },{ source := 143, target := 34, scalar := 1 }] }
theorem rowR6_0027_000_23_valid : (rowR6_0027_000_23).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_24 : ExtensionRow := { move := 120, child := 417, matrix := ![10,4,15,6,7,0,15,14,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 107, scalar := 4 },{ source := 17, target := 249, scalar := 10 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 1, scalar := 8 },{ source := 120, target := 52, scalar := 10 },{ source := 143, target := 0, scalar := 3 }] }
theorem rowR6_0027_000_24_valid : (rowR6_0027_000_24).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_25 : ExtensionRow := { move := 122, child := 433, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 122, target := 110, scalar := 15 },{ source := 143, target := 253, scalar := 9 }] }
theorem rowR6_0027_000_25_valid : (rowR6_0027_000_25).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_26 : ExtensionRow := { move := 124, child := 422, matrix := ![8,9,1,14,15,1,7,2,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 229, scalar := 9 },{ source := 17, target := 108, scalar := 8 },{ source := 34, target := 0, scalar := 4 },{ source := 52, target := 17, scalar := 10 },{ source := 124, target := 1, scalar := 1 },{ source := 143, target := 52, scalar := 12 }] }
theorem rowR6_0027_000_26_valid : (rowR6_0027_000_26).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_27 : ExtensionRow := { move := 126, child := 255, matrix := ![1,0,14,1,0,3,1,5,8], witnesses := [{ source := 0, target := 108, scalar := 14 },{ source := 1, target := 0, scalar := 5 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 75, scalar := 15 },{ source := 52, target := 1, scalar := 4 },{ source := 126, target := 52, scalar := 11 },{ source := 143, target := 17, scalar := 10 }] }
theorem rowR6_0027_000_27_valid : (rowR6_0027_000_27).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_28 : ExtensionRow := { move := 128, child := 443, matrix := ![7,1,0,6,6,0,1,13,12], witnesses := [{ source := 0, target := 0, scalar := 12 },{ source := 1, target := 126, scalar := 1 },{ source := 17, target := 135, scalar := 7 },{ source := 34, target := 17, scalar := 6 },{ source := 52, target := 52, scalar := 5 },{ source := 128, target := 34, scalar := 1 },{ source := 143, target := 1, scalar := 7 }] }
theorem rowR6_0027_000_28_valid : (rowR6_0027_000_28).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_29 : ExtensionRow := { move := 147, child := 153, matrix := ![0,12,6,8,2,10,0,1,1], witnesses := [{ source := 0, target := 72, scalar := 6 },{ source := 1, target := 139, scalar := 12 },{ source := 17, target := 1, scalar := 8 },{ source := 34, target := 17, scalar := 10 },{ source := 52, target := 34, scalar := 1 },{ source := 143, target := 0, scalar := 9 },{ source := 147, target := 52, scalar := 6 }] }
theorem rowR6_0027_000_29_valid : (rowR6_0027_000_29).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_30 : ExtensionRow := { move := 149, child := 20, matrix := ![1,2,3,1,12,6,1,4,5], witnesses := [{ source := 0, target := 52, scalar := 3 },{ source := 1, target := 115, scalar := 2 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 11 },{ source := 52, target := 0, scalar := 6 },{ source := 143, target := 69, scalar := 14 },{ source := 149, target := 17, scalar := 14 }] }
theorem rowR6_0027_000_30_valid : (rowR6_0027_000_30).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_31 : ExtensionRow := { move := 150, child := 187, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 143, target := 240, scalar := 9 },{ source := 150, target := 72, scalar := 13 }] }
theorem rowR6_0027_000_31_valid : (rowR6_0027_000_31).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_32 : ExtensionRow := { move := 151, child := 270, matrix := ![3,3,13,13,0,4,15,0,11], witnesses := [{ source := 0, target := 75, scalar := 13 },{ source := 1, target := 17, scalar := 3 },{ source := 17, target := 182, scalar := 3 },{ source := 34, target := 52, scalar := 13 },{ source := 52, target := 34, scalar := 1 },{ source := 143, target := 0, scalar := 7 },{ source := 151, target := 1, scalar := 6 }] }
theorem rowR6_0027_000_32_valid : (rowR6_0027_000_32).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_33 : ExtensionRow := { move := 152, child := 428, matrix := ![1,0,0,5,11,0,12,0,4], witnesses := [{ source := 0, target := 0, scalar := 4 },{ source := 1, target := 1, scalar := 11 },{ source := 17, target := 109, scalar := 1 },{ source := 34, target := 249, scalar := 1 },{ source := 52, target := 17, scalar := 1 },{ source := 143, target := 34, scalar := 1 },{ source := 152, target := 52, scalar := 1 }] }
theorem rowR6_0027_000_33_valid : (rowR6_0027_000_33).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_34 : ExtensionRow := { move := 154, child := 251, matrix := ![0,0,1,1,0,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 256, scalar := 3 },{ source := 143, target := 74, scalar := 14 },{ source := 154, target := 52, scalar := 9 }] }
theorem rowR6_0027_000_34_valid : (rowR6_0027_000_34).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_35 : ExtensionRow := { move := 156, child := 427, matrix := ![2,2,0,0,15,0,0,14,14], witnesses := [{ source := 0, target := 0, scalar := 14 },{ source := 1, target := 248, scalar := 2 },{ source := 17, target := 17, scalar := 2 },{ source := 34, target := 1, scalar := 15 },{ source := 52, target := 109, scalar := 6 },{ source := 143, target := 52, scalar := 12 },{ source := 156, target := 34, scalar := 1 }] }
theorem rowR6_0027_000_35_valid : (rowR6_0027_000_35).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_36 : ExtensionRow := { move := 163, child := 209, matrix := ![14,14,0,1,0,0,9,0,9], witnesses := [{ source := 0, target := 0, scalar := 9 },{ source := 1, target := 17, scalar := 14 },{ source := 17, target := 73, scalar := 14 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 34, scalar := 1 },{ source := 143, target := 168, scalar := 2 },{ source := 163, target := 52, scalar := 9 }] }
theorem rowR6_0027_000_36_valid : (rowR6_0027_000_36).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_37 : ExtensionRow := { move := 166, child := 104, matrix := ![3,0,1,5,0,1,10,13,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 0, scalar := 13 },{ source := 17, target := 71, scalar := 3 },{ source := 34, target := 52, scalar := 2 },{ source := 52, target := 1, scalar := 6 },{ source := 143, target := 181, scalar := 13 },{ source := 166, target := 17, scalar := 6 }] }
theorem rowR6_0027_000_37_valid : (rowR6_0027_000_37).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_38 : ExtensionRow := { move := 168, child := 438, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 143, target := 263, scalar := 1 },{ source := 168, target := 121, scalar := 1 }] }
theorem rowR6_0027_000_38_valid : (rowR6_0027_000_38).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_39 : ExtensionRow := { move := 169, child := 162, matrix := ![0,1,0,0,1,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 169, scalar := 2 },{ source := 143, target := 72, scalar := 7 },{ source := 169, target := 52, scalar := 9 }] }
theorem rowR6_0027_000_39_valid : (rowR6_0027_000_39).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_40 : ExtensionRow := { move := 171, child := 346, matrix := ![8,3,0,11,0,13,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 13 },{ source := 1, target := 17, scalar := 3 },{ source := 17, target := 80, scalar := 8 },{ source := 34, target := 230, scalar := 11 },{ source := 52, target := 52, scalar := 14 },{ source := 143, target := 34, scalar := 1 },{ source := 171, target := 0, scalar := 1 }] }
theorem rowR6_0027_000_40_valid : (rowR6_0027_000_40).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_41 : ExtensionRow := { move := 172, child := 185, matrix := ![11,0,1,5,15,1,14,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 1, scalar := 15 },{ source := 17, target := 52, scalar := 11 },{ source := 34, target := 233, scalar := 10 },{ source := 52, target := 72, scalar := 8 },{ source := 143, target := 17, scalar := 5 },{ source := 172, target := 0, scalar := 5 }] }
theorem rowR6_0027_000_41_valid : (rowR6_0027_000_41).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_42 : ExtensionRow := { move := 174, child := 327, matrix := ![0,1,0,0,3,2,15,14,0], witnesses := [{ source := 0, target := 1, scalar := 2 },{ source := 1, target := 79, scalar := 1 },{ source := 17, target := 0, scalar := 15 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 17, scalar := 2 },{ source := 143, target := 139, scalar := 7 },{ source := 174, target := 52, scalar := 9 }] }
theorem rowR6_0027_000_42_valid : (rowR6_0027_000_42).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_43 : ExtensionRow := { move := 176, child := 79, matrix := ![1,0,0,0,0,3,0,6,0], witnesses := [{ source := 0, target := 1, scalar := 3 },{ source := 1, target := 0, scalar := 6 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 71, scalar := 1 },{ source := 52, target := 109, scalar := 1 },{ source := 143, target := 34, scalar := 1 },{ source := 176, target := 52, scalar := 1 }] }
theorem rowR6_0027_000_43_valid : (rowR6_0027_000_43).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_44 : ExtensionRow := { move := 181, child := 233, matrix := ![1,12,0,1,7,9,1,6,0], witnesses := [{ source := 0, target := 1, scalar := 9 },{ source := 1, target := 74, scalar := 12 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 176, scalar := 13 },{ source := 52, target := 52, scalar := 10 },{ source := 143, target := 17, scalar := 3 },{ source := 181, target := 0, scalar := 8 }] }
theorem rowR6_0027_000_44_valid : (rowR6_0027_000_44).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_45 : ExtensionRow := { move := 182, child := 257, matrix := ![0,2,2,0,6,0,7,7,0], witnesses := [{ source := 0, target := 17, scalar := 2 },{ source := 1, target := 75, scalar := 2 },{ source := 17, target := 0, scalar := 7 },{ source := 34, target := 1, scalar := 6 },{ source := 52, target := 126, scalar := 2 },{ source := 143, target := 34, scalar := 1 },{ source := 182, target := 52, scalar := 13 }] }
theorem rowR6_0027_000_45_valid : (rowR6_0027_000_45).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_46 : ExtensionRow := { move := 186, child := 420, matrix := ![0,1,0,0,1,9,7,1,0], witnesses := [{ source := 0, target := 1, scalar := 9 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 7 },{ source := 34, target := 151, scalar := 1 },{ source := 52, target := 108, scalar := 2 },{ source := 143, target := 17, scalar := 7 },{ source := 186, target := 52, scalar := 10 }] }
theorem rowR6_0027_000_46_valid : (rowR6_0027_000_46).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowR6_0027_000_47 : ExtensionRow := { move := 188, child := 401, matrix := ![1,0,0,1,0,5,1,12,0], witnesses := [{ source := 0, target := 1, scalar := 5 },{ source := 1, target := 0, scalar := 12 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 94, scalar := 1 },{ source := 52, target := 251, scalar := 1 },{ source := 143, target := 52, scalar := 1 },{ source := 188, target := 17, scalar := 1 }] }
theorem rowR6_0027_000_47_valid : (rowR6_0027_000_47).ValidFor level7 {0,1,17,34,52,143} := by decide

noncomputable def rowsR6_0027_000 : List ExtensionRow := [rowR6_0027_000_0,rowR6_0027_000_1,rowR6_0027_000_2,rowR6_0027_000_3,rowR6_0027_000_4,rowR6_0027_000_5,rowR6_0027_000_6,rowR6_0027_000_7,rowR6_0027_000_8,rowR6_0027_000_9,rowR6_0027_000_10,rowR6_0027_000_11,rowR6_0027_000_12,rowR6_0027_000_13,rowR6_0027_000_14,rowR6_0027_000_15,rowR6_0027_000_16,rowR6_0027_000_17,rowR6_0027_000_18,rowR6_0027_000_19,rowR6_0027_000_20,rowR6_0027_000_21,rowR6_0027_000_22,rowR6_0027_000_23,rowR6_0027_000_24,rowR6_0027_000_25,rowR6_0027_000_26,rowR6_0027_000_27,rowR6_0027_000_28,rowR6_0027_000_29,rowR6_0027_000_30,rowR6_0027_000_31,rowR6_0027_000_32,rowR6_0027_000_33,rowR6_0027_000_34,rowR6_0027_000_35,rowR6_0027_000_36,rowR6_0027_000_37,rowR6_0027_000_38,rowR6_0027_000_39,rowR6_0027_000_40,rowR6_0027_000_41,rowR6_0027_000_42,rowR6_0027_000_43,rowR6_0027_000_44,rowR6_0027_000_45,rowR6_0027_000_46,rowR6_0027_000_47]

theorem rowsR6_0027_000_valid : RowListValid level7 {0,1,17,34,52,143} rowsR6_0027_000 := by
  intro r hr
  simp only [rowsR6_0027_000, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR6_0027_000_0_valid
  · exact rowR6_0027_000_1_valid
  · exact rowR6_0027_000_2_valid
  · exact rowR6_0027_000_3_valid
  · exact rowR6_0027_000_4_valid
  · exact rowR6_0027_000_5_valid
  · exact rowR6_0027_000_6_valid
  · exact rowR6_0027_000_7_valid
  · exact rowR6_0027_000_8_valid
  · exact rowR6_0027_000_9_valid
  · exact rowR6_0027_000_10_valid
  · exact rowR6_0027_000_11_valid
  · exact rowR6_0027_000_12_valid
  · exact rowR6_0027_000_13_valid
  · exact rowR6_0027_000_14_valid
  · exact rowR6_0027_000_15_valid
  · exact rowR6_0027_000_16_valid
  · exact rowR6_0027_000_17_valid
  · exact rowR6_0027_000_18_valid
  · exact rowR6_0027_000_19_valid
  · exact rowR6_0027_000_20_valid
  · exact rowR6_0027_000_21_valid
  · exact rowR6_0027_000_22_valid
  · exact rowR6_0027_000_23_valid
  · exact rowR6_0027_000_24_valid
  · exact rowR6_0027_000_25_valid
  · exact rowR6_0027_000_26_valid
  · exact rowR6_0027_000_27_valid
  · exact rowR6_0027_000_28_valid
  · exact rowR6_0027_000_29_valid
  · exact rowR6_0027_000_30_valid
  · exact rowR6_0027_000_31_valid
  · exact rowR6_0027_000_32_valid
  · exact rowR6_0027_000_33_valid
  · exact rowR6_0027_000_34_valid
  · exact rowR6_0027_000_35_valid
  · exact rowR6_0027_000_36_valid
  · exact rowR6_0027_000_37_valid
  · exact rowR6_0027_000_38_valid
  · exact rowR6_0027_000_39_valid
  · exact rowR6_0027_000_40_valid
  · exact rowR6_0027_000_41_valid
  · exact rowR6_0027_000_42_valid
  · exact rowR6_0027_000_43_valid
  · exact rowR6_0027_000_44_valid
  · exact rowR6_0027_000_45_valid
  · exact rowR6_0027_000_46_valid
  · exact rowR6_0027_000_47_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
