import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR6_0021_000_0 : ExtensionRow := { move := 67, child := 0, matrix := ![1,0,0,2,1,0,3,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 52, scalar := 1 },{ source := 34, target := 67, scalar := 1 },{ source := 52, target := 17, scalar := 1 },{ source := 67, target := 34, scalar := 1 },{ source := 124, target := 89, scalar := 1 }] }
theorem rowR6_0021_000_0_valid : (rowR6_0021_000_0).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_1 : ExtensionRow := { move := 69, child := 22, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 69, target := 69, scalar := 1 },{ source := 124, target := 124, scalar := 1 }] }
theorem rowR6_0021_000_1_valid : (rowR6_0021_000_1).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_2 : ExtensionRow := { move := 70, child := 4, matrix := ![14,0,3,15,11,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 3 },{ source := 1, target := 1, scalar := 11 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 69, scalar := 13 },{ source := 52, target := 86, scalar := 11 },{ source := 70, target := 34, scalar := 1 },{ source := 124, target := 0, scalar := 1 }] }
theorem rowR6_0021_000_2_valid : (rowR6_0021_000_2).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_3 : ExtensionRow := { move := 71, child := 45, matrix := ![5,7,2,0,4,4,0,12,6], witnesses := [{ source := 0, target := 52, scalar := 2 },{ source := 1, target := 207, scalar := 7 },{ source := 17, target := 17, scalar := 5 },{ source := 34, target := 0, scalar := 10 },{ source := 52, target := 69, scalar := 13 },{ source := 71, target := 1, scalar := 7 },{ source := 124, target := 34, scalar := 1 }] }
theorem rowR6_0021_000_3_valid : (rowR6_0021_000_3).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_4 : ExtensionRow := { move := 72, child := 0, matrix := ![11,4,1,0,12,1,0,8,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 67, scalar := 4 },{ source := 17, target := 17, scalar := 11 },{ source := 34, target := 89, scalar := 14 },{ source := 52, target := 1, scalar := 8 },{ source := 72, target := 0, scalar := 12 },{ source := 124, target := 52, scalar := 11 }] }
theorem rowR6_0021_000_4_valid : (rowR6_0021_000_4).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_5 : ExtensionRow := { move := 73, child := 202, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 73, target := 73, scalar := 1 },{ source := 124, target := 124, scalar := 1 }] }
theorem rowR6_0021_000_5_valid : (rowR6_0021_000_5).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_6 : ExtensionRow := { move := 74, child := 30, matrix := ![15,3,7,13,0,9,2,0,15], witnesses := [{ source := 0, target := 69, scalar := 7 },{ source := 1, target := 17, scalar := 3 },{ source := 17, target := 52, scalar := 15 },{ source := 34, target := 141, scalar := 11 },{ source := 52, target := 1, scalar := 5 },{ source := 74, target := 0, scalar := 12 },{ source := 124, target := 34, scalar := 1 }] }
theorem rowR6_0021_000_6_valid : (rowR6_0021_000_6).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_7 : ExtensionRow := { move := 75, child := 225, matrix := ![0,1,0,6,1,0,0,1,13], witnesses := [{ source := 0, target := 0, scalar := 13 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 6 },{ source := 34, target := 141, scalar := 1 },{ source := 52, target := 52, scalar := 2 },{ source := 75, target := 74, scalar := 3 },{ source := 124, target := 17, scalar := 6 }] }
theorem rowR6_0021_000_7_valid : (rowR6_0021_000_7).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_8 : ExtensionRow := { move := 78, child := 260, matrix := ![0,1,0,6,1,0,0,1,13], witnesses := [{ source := 0, target := 0, scalar := 13 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 6 },{ source := 34, target := 141, scalar := 1 },{ source := 52, target := 52, scalar := 2 },{ source := 78, target := 75, scalar := 3 },{ source := 124, target := 17, scalar := 6 }] }
theorem rowR6_0021_000_8_valid : (rowR6_0021_000_8).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_9 : ExtensionRow := { move := 79, child := 47, matrix := ![15,14,0,8,0,9,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 9 },{ source := 1, target := 17, scalar := 14 },{ source := 17, target := 217, scalar := 15 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 0, scalar := 1 },{ source := 79, target := 52, scalar := 14 },{ source := 124, target := 69, scalar := 13 }] }
theorem rowR6_0021_000_9_valid : (rowR6_0021_000_9).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_10 : ExtensionRow := { move := 80, child := 225, matrix := ![7,0,13,6,5,4,2,0,15], witnesses := [{ source := 0, target := 74, scalar := 13 },{ source := 1, target := 1, scalar := 5 },{ source := 17, target := 141, scalar := 7 },{ source := 34, target := 52, scalar := 10 },{ source := 52, target := 17, scalar := 3 },{ source := 80, target := 0, scalar := 8 },{ source := 124, target := 34, scalar := 1 }] }
theorem rowR6_0021_000_10_valid : (rowR6_0021_000_10).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_11 : ExtensionRow := { move := 83, child := 68, matrix := ![1,0,5,1,7,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 5 },{ source := 1, target := 1, scalar := 7 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 158, scalar := 4 },{ source := 52, target := 52, scalar := 14 },{ source := 83, target := 70, scalar := 11 },{ source := 124, target := 0, scalar := 1 }] }
theorem rowR6_0021_000_11_valid : (rowR6_0021_000_11).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_12 : ExtensionRow := { move := 86, child := 65, matrix := ![1,0,14,1,0,1,1,2,3], witnesses := [{ source := 0, target := 70, scalar := 14 },{ source := 1, target := 0, scalar := 2 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 15 },{ source := 52, target := 1, scalar := 2 },{ source := 86, target := 52, scalar := 2 },{ source := 124, target := 135, scalar := 9 }] }
theorem rowR6_0021_000_12_valid : (rowR6_0021_000_12).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_13 : ExtensionRow := { move := 89, child := 98, matrix := ![2,1,0,4,1,0,6,1,13], witnesses := [{ source := 0, target := 0, scalar := 13 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 2 },{ source := 34, target := 71, scalar := 3 },{ source := 52, target := 1, scalar := 6 },{ source := 89, target := 17, scalar := 6 },{ source := 124, target := 169, scalar := 4 }] }
theorem rowR6_0021_000_13_valid : (rowR6_0021_000_13).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_14 : ExtensionRow := { move := 90, child := 178, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 90, target := 72, scalar := 13 },{ source := 124, target := 208, scalar := 13 }] }
theorem rowR6_0021_000_14_valid : (rowR6_0021_000_14).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_15 : ExtensionRow := { move := 93, child := 72, matrix := ![0,8,1,0,3,1,6,11,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 52, scalar := 8 },{ source := 17, target := 0, scalar := 6 },{ source := 34, target := 92, scalar := 9 },{ source := 52, target := 1, scalar := 5 },{ source := 93, target := 17, scalar := 10 },{ source := 124, target := 71, scalar := 14 }] }
theorem rowR6_0021_000_15_valid : (rowR6_0021_000_15).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_16 : ExtensionRow := { move := 94, child := 248, matrix := ![1,14,15,1,1,0,1,7,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 74, scalar := 14 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 6 },{ source := 52, target := 237, scalar := 12 },{ source := 94, target := 52, scalar := 11 },{ source := 124, target := 1, scalar := 7 }] }
theorem rowR6_0021_000_16_valid : (rowR6_0021_000_16).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_17 : ExtensionRow := { move := 95, child := 157, matrix := ![14,7,0,1,0,0,12,0,4], witnesses := [{ source := 0, target := 0, scalar := 4 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 72, scalar := 14 },{ source := 34, target := 52, scalar := 9 },{ source := 52, target := 1, scalar := 1 },{ source := 95, target := 34, scalar := 1 },{ source := 124, target := 150, scalar := 15 }] }
theorem rowR6_0021_000_17_valid : (rowR6_0021_000_17).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_18 : ExtensionRow := { move := 99, child := 11, matrix := ![10,4,15,0,12,13,0,3,2], witnesses := [{ source := 0, target := 52, scalar := 15 },{ source := 1, target := 69, scalar := 4 },{ source := 17, target := 17, scalar := 10 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 1, scalar := 15 },{ source := 99, target := 0, scalar := 11 },{ source := 124, target := 95, scalar := 2 }] }
theorem rowR6_0021_000_18_valid : (rowR6_0021_000_18).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_19 : ExtensionRow := { move := 101, child := 404, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 101, target := 101, scalar := 1 },{ source := 124, target := 124, scalar := 1 }] }
theorem rowR6_0021_000_19_valid : (rowR6_0021_000_19).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_20 : ExtensionRow := { move := 103, child := 35, matrix := ![0,15,1,0,1,1,4,5,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 159, scalar := 15 },{ source := 17, target := 0, scalar := 4 },{ source := 34, target := 17, scalar := 14 },{ source := 52, target := 69, scalar := 14 },{ source := 103, target := 1, scalar := 3 },{ source := 124, target := 52, scalar := 15 }] }
theorem rowR6_0021_000_20_valid : (rowR6_0021_000_20).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_21 : ExtensionRow := { move := 106, child := 181, matrix := ![0,5,6,0,10,10,14,15,1], witnesses := [{ source := 0, target := 72, scalar := 6 },{ source := 1, target := 52, scalar := 5 },{ source := 17, target := 0, scalar := 14 },{ source := 34, target := 17, scalar := 3 },{ source := 52, target := 1, scalar := 10 },{ source := 106, target := 34, scalar := 1 },{ source := 124, target := 218, scalar := 2 }] }
theorem rowR6_0021_000_21_valid : (rowR6_0021_000_21).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_22 : ExtensionRow := { move := 107, child := 131, matrix := ![0,12,6,0,7,0,3,14,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 71, scalar := 12 },{ source := 17, target := 0, scalar := 3 },{ source := 34, target := 52, scalar := 10 },{ source := 52, target := 253, scalar := 1 },{ source := 107, target := 1, scalar := 8 },{ source := 124, target := 34, scalar := 1 }] }
theorem rowR6_0021_000_22_valid : (rowR6_0021_000_22).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_23 : ExtensionRow := { move := 109, child := 410, matrix := ![0,0,1,0,4,1,11,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 1, scalar := 4 },{ source := 17, target := 0, scalar := 11 },{ source := 34, target := 107, scalar := 1 },{ source := 52, target := 154, scalar := 3 },{ source := 109, target := 52, scalar := 12 },{ source := 124, target := 17, scalar := 11 }] }
theorem rowR6_0021_000_23_valid : (rowR6_0021_000_23).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_24 : ExtensionRow := { move := 112, child := 94, matrix := ![1,0,5,1,7,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 5 },{ source := 1, target := 1, scalar := 7 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 158, scalar := 4 },{ source := 52, target := 52, scalar := 14 },{ source := 112, target := 71, scalar := 7 },{ source := 124, target := 0, scalar := 1 }] }
theorem rowR6_0021_000_24_valid : (rowR6_0021_000_24).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_25 : ExtensionRow := { move := 133, child := 263, matrix := ![0,11,3,1,7,5,0,6,13], witnesses := [{ source := 0, target := 75, scalar := 3 },{ source := 1, target := 158, scalar := 11 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 52, scalar := 8 },{ source := 52, target := 0, scalar := 8 },{ source := 124, target := 34, scalar := 1 },{ source := 133, target := 17, scalar := 8 }] }
theorem rowR6_0021_000_25_valid : (rowR6_0021_000_25).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_26 : ExtensionRow := { move := 135, child := 263, matrix := ![1,0,5,1,7,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 5 },{ source := 1, target := 1, scalar := 7 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 158, scalar := 4 },{ source := 52, target := 52, scalar := 14 },{ source := 124, target := 0, scalar := 1 },{ source := 135, target := 75, scalar := 12 }] }
theorem rowR6_0021_000_26_valid : (rowR6_0021_000_26).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_27 : ExtensionRow := { move := 137, child := 380, matrix := ![8,0,9,3,0,2,11,6,12], witnesses := [{ source := 0, target := 92, scalar := 9 },{ source := 1, target := 0, scalar := 6 },{ source := 17, target := 52, scalar := 8 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 1, scalar := 5 },{ source := 124, target := 158, scalar := 4 },{ source := 137, target := 17, scalar := 12 }] }
theorem rowR6_0021_000_27_valid : (rowR6_0021_000_27).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_28 : ExtensionRow := { move := 139, child := 380, matrix := ![1,0,5,1,7,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 5 },{ source := 1, target := 1, scalar := 7 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 158, scalar := 4 },{ source := 52, target := 52, scalar := 14 },{ source := 124, target := 0, scalar := 1 },{ source := 139, target := 92, scalar := 5 }] }
theorem rowR6_0021_000_28_valid : (rowR6_0021_000_28).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_29 : ExtensionRow := { move := 141, child := 439, matrix := ![7,7,0,1,0,0,4,0,4], witnesses := [{ source := 0, target := 0, scalar := 4 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 124, scalar := 7 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 9 },{ source := 124, target := 141, scalar := 6 },{ source := 141, target := 34, scalar := 1 }] }
theorem rowR6_0021_000_29_valid : (rowR6_0021_000_29).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_30 : ExtensionRow := { move := 143, child := 422, matrix := ![8,9,1,14,15,1,7,2,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 229, scalar := 9 },{ source := 17, target := 108, scalar := 8 },{ source := 34, target := 0, scalar := 4 },{ source := 52, target := 17, scalar := 10 },{ source := 124, target := 1, scalar := 1 },{ source := 143, target := 52, scalar := 12 }] }
theorem rowR6_0021_000_30_valid : (rowR6_0021_000_30).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_31 : ExtensionRow := { move := 147, child := 113, matrix := ![2,0,15,4,0,2,6,5,4], witnesses := [{ source := 0, target := 71, scalar := 15 },{ source := 1, target := 0, scalar := 5 },{ source := 17, target := 52, scalar := 2 },{ source := 34, target := 208, scalar := 13 },{ source := 52, target := 1, scalar := 2 },{ source := 124, target := 34, scalar := 1 },{ source := 147, target := 17, scalar := 15 }] }
theorem rowR6_0021_000_31_valid : (rowR6_0021_000_31).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_32 : ExtensionRow := { move := 150, child := 189, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 124, target := 251, scalar := 13 },{ source := 150, target := 72, scalar := 13 }] }
theorem rowR6_0021_000_32_valid : (rowR6_0021_000_32).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_33 : ExtensionRow := { move := 152, child := 39, matrix := ![14,15,1,7,2,1,8,9,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 69, scalar := 15 },{ source := 17, target := 172, scalar := 14 },{ source := 34, target := 1, scalar := 4 },{ source := 52, target := 0, scalar := 10 },{ source := 124, target := 17, scalar := 1 },{ source := 152, target := 52, scalar := 8 }] }
theorem rowR6_0021_000_33_valid : (rowR6_0021_000_33).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_34 : ExtensionRow := { move := 154, child := 418, matrix := ![13,0,12,8,0,9,5,9,13], witnesses := [{ source := 0, target := 108, scalar := 12 },{ source := 1, target := 0, scalar := 9 },{ source := 17, target := 120, scalar := 13 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 17, scalar := 10 },{ source := 124, target := 1, scalar := 4 },{ source := 154, target := 52, scalar := 11 }] }
theorem rowR6_0021_000_34_valid : (rowR6_0021_000_34).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_35 : ExtensionRow := { move := 155, child := 5, matrix := ![11,1,7,14,1,14,10,1,9], witnesses := [{ source := 0, target := 52, scalar := 7 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 69, scalar := 11 },{ source := 34, target := 89, scalar := 13 },{ source := 52, target := 1, scalar := 13 },{ source := 124, target := 17, scalar := 9 },{ source := 155, target := 0, scalar := 7 }] }
theorem rowR6_0021_000_35_valid : (rowR6_0021_000_35).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_36 : ExtensionRow := { move := 158, child := 405, matrix := ![4,7,2,7,6,0,3,2,0], witnesses := [{ source := 0, target := 17, scalar := 2 },{ source := 1, target := 141, scalar := 7 },{ source := 17, target := 101, scalar := 4 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 12 },{ source := 124, target := 0, scalar := 15 },{ source := 158, target := 1, scalar := 2 }] }
theorem rowR6_0021_000_36_valid : (rowR6_0021_000_36).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_37 : ExtensionRow := { move := 159, child := 159, matrix := ![14,0,1,1,0,1,12,13,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 0, scalar := 13 },{ source := 17, target := 72, scalar := 14 },{ source := 34, target := 17, scalar := 15 },{ source := 52, target := 156, scalar := 13 },{ source := 124, target := 52, scalar := 5 },{ source := 159, target := 1, scalar := 15 }] }
theorem rowR6_0021_000_37_valid : (rowR6_0021_000_37).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_38 : ExtensionRow := { move := 168, child := 29, matrix := ![1,15,4,1,2,0,1,9,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 69, scalar := 15 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 139, scalar := 10 },{ source := 52, target := 1, scalar := 5 },{ source := 124, target := 52, scalar := 15 },{ source := 168, target := 0, scalar := 12 }] }
theorem rowR6_0021_000_38_valid : (rowR6_0021_000_38).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_39 : ExtensionRow := { move := 169, child := 98, matrix := ![5,11,14,11,5,0,14,14,0], witnesses := [{ source := 0, target := 17, scalar := 14 },{ source := 1, target := 52, scalar := 11 },{ source := 17, target := 169, scalar := 5 },{ source := 34, target := 1, scalar := 14 },{ source := 52, target := 34, scalar := 1 },{ source := 124, target := 71, scalar := 2 },{ source := 169, target := 0, scalar := 9 }] }
theorem rowR6_0021_000_39_valid : (rowR6_0021_000_39).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_40 : ExtensionRow := { move := 171, child := 227, matrix := ![11,5,0,14,14,0,12,10,6], witnesses := [{ source := 0, target := 0, scalar := 6 },{ source := 1, target := 147, scalar := 5 },{ source := 17, target := 74, scalar := 11 },{ source := 34, target := 17, scalar := 14 },{ source := 52, target := 34, scalar := 1 },{ source := 124, target := 52, scalar := 6 },{ source := 171, target := 1, scalar := 9 }] }
theorem rowR6_0021_000_40_valid : (rowR6_0021_000_40).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_41 : ExtensionRow := { move := 173, child := 27, matrix := ![14,15,1,0,11,3,0,4,4], witnesses := [{ source := 0, target := 69, scalar := 1 },{ source := 1, target := 135, scalar := 15 },{ source := 17, target := 17, scalar := 14 },{ source := 34, target := 1, scalar := 8 },{ source := 52, target := 0, scalar := 4 },{ source := 124, target := 34, scalar := 1 },{ source := 173, target := 52, scalar := 12 }] }
theorem rowR6_0021_000_41_valid : (rowR6_0021_000_41).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_42 : ExtensionRow := { move := 174, child := 252, matrix := ![15,15,0,0,13,13,0,2,0], witnesses := [{ source := 0, target := 1, scalar := 13 },{ source := 1, target := 52, scalar := 15 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 0, scalar := 2 },{ source := 52, target := 259, scalar := 2 },{ source := 124, target := 74, scalar := 11 },{ source := 174, target := 34, scalar := 1 }] }
theorem rowR6_0021_000_42_valid : (rowR6_0021_000_42).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_43 : ExtensionRow := { move := 175, child := 68, matrix := ![9,14,1,8,9,1,11,10,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 158, scalar := 14 },{ source := 17, target := 70, scalar := 9 },{ source := 34, target := 17, scalar := 6 },{ source := 52, target := 52, scalar := 5 },{ source := 124, target := 0, scalar := 9 },{ source := 175, target := 1, scalar := 11 }] }
theorem rowR6_0021_000_43_valid : (rowR6_0021_000_43).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_44 : ExtensionRow := { move := 176, child := 358, matrix := ![5,8,0,10,6,12,15,15,0], witnesses := [{ source := 0, target := 1, scalar := 12 },{ source := 1, target := 91, scalar := 8 },{ source := 17, target := 52, scalar := 5 },{ source := 34, target := 17, scalar := 13 },{ source := 52, target := 143, scalar := 6 },{ source := 124, target := 0, scalar := 11 },{ source := 176, target := 34, scalar := 1 }] }
theorem rowR6_0021_000_44_valid : (rowR6_0021_000_44).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_45 : ExtensionRow := { move := 181, child := 348, matrix := ![8,10,0,9,13,0,3,12,9], witnesses := [{ source := 0, target := 0, scalar := 9 },{ source := 1, target := 80, scalar := 10 },{ source := 17, target := 243, scalar := 8 },{ source := 34, target := 52, scalar := 2 },{ source := 52, target := 17, scalar := 15 },{ source := 124, target := 34, scalar := 1 },{ source := 181, target := 1, scalar := 2 }] }
theorem rowR6_0021_000_45_valid : (rowR6_0021_000_45).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_46 : ExtensionRow := { move := 182, child := 196, matrix := ![12,6,1,11,4,1,7,2,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 271, scalar := 6 },{ source := 17, target := 52, scalar := 12 },{ source := 34, target := 72, scalar := 11 },{ source := 52, target := 17, scalar := 3 },{ source := 124, target := 1, scalar := 11 },{ source := 182, target := 0, scalar := 5 }] }
theorem rowR6_0021_000_46_valid : (rowR6_0021_000_46).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowR6_0021_000_47 : ExtensionRow := { move := 183, child := 21, matrix := ![10,1,9,9,1,8,3,1,2], witnesses := [{ source := 0, target := 69, scalar := 9 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 120, scalar := 10 },{ source := 34, target := 17, scalar := 2 },{ source := 52, target := 0, scalar := 7 },{ source := 124, target := 1, scalar := 8 },{ source := 183, target := 52, scalar := 3 }] }
theorem rowR6_0021_000_47_valid : (rowR6_0021_000_47).ValidFor level7 {0,1,17,34,52,124} := by decide

noncomputable def rowsR6_0021_000 : List ExtensionRow := [rowR6_0021_000_0,rowR6_0021_000_1,rowR6_0021_000_2,rowR6_0021_000_3,rowR6_0021_000_4,rowR6_0021_000_5,rowR6_0021_000_6,rowR6_0021_000_7,rowR6_0021_000_8,rowR6_0021_000_9,rowR6_0021_000_10,rowR6_0021_000_11,rowR6_0021_000_12,rowR6_0021_000_13,rowR6_0021_000_14,rowR6_0021_000_15,rowR6_0021_000_16,rowR6_0021_000_17,rowR6_0021_000_18,rowR6_0021_000_19,rowR6_0021_000_20,rowR6_0021_000_21,rowR6_0021_000_22,rowR6_0021_000_23,rowR6_0021_000_24,rowR6_0021_000_25,rowR6_0021_000_26,rowR6_0021_000_27,rowR6_0021_000_28,rowR6_0021_000_29,rowR6_0021_000_30,rowR6_0021_000_31,rowR6_0021_000_32,rowR6_0021_000_33,rowR6_0021_000_34,rowR6_0021_000_35,rowR6_0021_000_36,rowR6_0021_000_37,rowR6_0021_000_38,rowR6_0021_000_39,rowR6_0021_000_40,rowR6_0021_000_41,rowR6_0021_000_42,rowR6_0021_000_43,rowR6_0021_000_44,rowR6_0021_000_45,rowR6_0021_000_46,rowR6_0021_000_47]

theorem rowsR6_0021_000_valid : RowListValid level7 {0,1,17,34,52,124} rowsR6_0021_000 := by
  intro r hr
  simp only [rowsR6_0021_000, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR6_0021_000_0_valid
  · exact rowR6_0021_000_1_valid
  · exact rowR6_0021_000_2_valid
  · exact rowR6_0021_000_3_valid
  · exact rowR6_0021_000_4_valid
  · exact rowR6_0021_000_5_valid
  · exact rowR6_0021_000_6_valid
  · exact rowR6_0021_000_7_valid
  · exact rowR6_0021_000_8_valid
  · exact rowR6_0021_000_9_valid
  · exact rowR6_0021_000_10_valid
  · exact rowR6_0021_000_11_valid
  · exact rowR6_0021_000_12_valid
  · exact rowR6_0021_000_13_valid
  · exact rowR6_0021_000_14_valid
  · exact rowR6_0021_000_15_valid
  · exact rowR6_0021_000_16_valid
  · exact rowR6_0021_000_17_valid
  · exact rowR6_0021_000_18_valid
  · exact rowR6_0021_000_19_valid
  · exact rowR6_0021_000_20_valid
  · exact rowR6_0021_000_21_valid
  · exact rowR6_0021_000_22_valid
  · exact rowR6_0021_000_23_valid
  · exact rowR6_0021_000_24_valid
  · exact rowR6_0021_000_25_valid
  · exact rowR6_0021_000_26_valid
  · exact rowR6_0021_000_27_valid
  · exact rowR6_0021_000_28_valid
  · exact rowR6_0021_000_29_valid
  · exact rowR6_0021_000_30_valid
  · exact rowR6_0021_000_31_valid
  · exact rowR6_0021_000_32_valid
  · exact rowR6_0021_000_33_valid
  · exact rowR6_0021_000_34_valid
  · exact rowR6_0021_000_35_valid
  · exact rowR6_0021_000_36_valid
  · exact rowR6_0021_000_37_valid
  · exact rowR6_0021_000_38_valid
  · exact rowR6_0021_000_39_valid
  · exact rowR6_0021_000_40_valid
  · exact rowR6_0021_000_41_valid
  · exact rowR6_0021_000_42_valid
  · exact rowR6_0021_000_43_valid
  · exact rowR6_0021_000_44_valid
  · exact rowR6_0021_000_45_valid
  · exact rowR6_0021_000_46_valid
  · exact rowR6_0021_000_47_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
