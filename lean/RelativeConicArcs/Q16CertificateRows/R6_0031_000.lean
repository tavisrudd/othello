import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR6_0031_000_0 : ExtensionRow := { move := 67, child := 3, matrix := ![1,1,1,2,0,1,3,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 52, scalar := 1 },{ source := 34, target := 67, scalar := 1 },{ source := 52, target := 1, scalar := 1 },{ source := 67, target := 0, scalar := 1 },{ source := 176, target := 159, scalar := 7 }] }
theorem rowR6_0031_000_0_valid : (rowR6_0031_000_0).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_1 : ExtensionRow := { move := 70, child := 55, matrix := ![1,0,1,3,2,1,5,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 1, scalar := 2 },{ source := 17, target := 70, scalar := 1 },{ source := 34, target := 0, scalar := 4 },{ source := 52, target := 52, scalar := 2 },{ source := 70, target := 17, scalar := 4 },{ source := 176, target := 94, scalar := 14 }] }
theorem rowR6_0031_000_1_valid : (rowR6_0031_000_1).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_2 : ExtensionRow := { move := 71, child := 103, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 71, target := 71, scalar := 1 },{ source := 176, target := 176, scalar := 1 }] }
theorem rowR6_0031_000_2_valid : (rowR6_0031_000_2).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_3 : ExtensionRow := { move := 72, child := 14, matrix := ![0,0,6,0,13,13,7,0,7], witnesses := [{ source := 0, target := 103, scalar := 6 },{ source := 1, target := 1, scalar := 13 },{ source := 17, target := 0, scalar := 7 },{ source := 34, target := 17, scalar := 6 },{ source := 52, target := 69, scalar := 10 },{ source := 72, target := 34, scalar := 1 },{ source := 176, target := 52, scalar := 4 }] }
theorem rowR6_0031_000_3_valid : (rowR6_0031_000_3).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_4 : ExtensionRow := { move := 73, child := 208, matrix := ![0,14,0,0,0,15,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 15 },{ source := 1, target := 17, scalar := 14 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 52, scalar := 14 },{ source := 52, target := 73, scalar := 15 },{ source := 73, target := 34, scalar := 1 },{ source := 176, target := 167, scalar := 7 }] }
theorem rowR6_0031_000_4_valid : (rowR6_0031_000_4).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_5 : ExtensionRow := { move := 74, child := 233, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 74, target := 74, scalar := 1 },{ source := 176, target := 176, scalar := 1 }] }
theorem rowR6_0031_000_5_valid : (rowR6_0031_000_5).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_6 : ExtensionRow := { move := 78, child := 304, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 78, target := 78, scalar := 1 },{ source := 176, target := 176, scalar := 1 }] }
theorem rowR6_0031_000_6_valid : (rowR6_0031_000_6).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_7 : ExtensionRow := { move := 79, child := 132, matrix := ![9,0,9,14,14,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 1, scalar := 14 },{ source := 17, target := 259, scalar := 9 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 34, scalar := 1 },{ source := 79, target := 52, scalar := 14 },{ source := 176, target := 71, scalar := 7 }] }
theorem rowR6_0031_000_7_valid : (rowR6_0031_000_7).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_8 : ExtensionRow := { move := 83, child := 58, matrix := ![10,11,0,0,14,15,0,1,0], witnesses := [{ source := 0, target := 1, scalar := 15 },{ source := 1, target := 70, scalar := 11 },{ source := 17, target := 17, scalar := 10 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 15 },{ source := 83, target := 0, scalar := 4 },{ source := 176, target := 107, scalar := 6 }] }
theorem rowR6_0031_000_8_valid : (rowR6_0031_000_8).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_9 : ExtensionRow := { move := 86, child := 66, matrix := ![0,1,15,0,1,0,2,1,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 2 },{ source := 34, target := 70, scalar := 14 },{ source := 52, target := 1, scalar := 2 },{ source := 86, target := 52, scalar := 2 },{ source := 176, target := 137, scalar := 3 }] }
theorem rowR6_0031_000_9_valid : (rowR6_0031_000_9).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_10 : ExtensionRow := { move := 89, child := 120, matrix := ![2,1,0,4,1,0,6,1,13], witnesses := [{ source := 0, target := 0, scalar := 13 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 2 },{ source := 34, target := 71, scalar := 3 },{ source := 52, target := 1, scalar := 6 },{ source := 89, target := 17, scalar := 6 },{ source := 176, target := 223, scalar := 11 }] }
theorem rowR6_0031_000_10_valid : (rowR6_0031_000_10).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_11 : ExtensionRow := { move := 90, child := 169, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 90, target := 72, scalar := 13 },{ source := 176, target := 190, scalar := 6 }] }
theorem rowR6_0031_000_11_valid : (rowR6_0031_000_11).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_12 : ExtensionRow := { move := 91, child := 364, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 91, target := 91, scalar := 1 },{ source := 176, target := 176, scalar := 1 }] }
theorem rowR6_0031_000_12_valid : (rowR6_0031_000_12).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_13 : ExtensionRow := { move := 92, child := 323, matrix := ![6,12,10,11,11,0,14,7,0], witnesses := [{ source := 0, target := 17, scalar := 10 },{ source := 1, target := 52, scalar := 12 },{ source := 17, target := 93, scalar := 6 },{ source := 34, target := 0, scalar := 9 },{ source := 52, target := 1, scalar := 14 },{ source := 92, target := 34, scalar := 1 },{ source := 176, target := 79, scalar := 12 }] }
theorem rowR6_0031_000_13_valid : (rowR6_0031_000_13).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_14 : ExtensionRow := { move := 93, child := 235, matrix := ![0,10,12,14,7,0,0,13,0], witnesses := [{ source := 0, target := 17, scalar := 12 },{ source := 1, target := 52, scalar := 10 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 182, scalar := 6 },{ source := 52, target := 0, scalar := 9 },{ source := 93, target := 34, scalar := 1 },{ source := 176, target := 74, scalar := 13 }] }
theorem rowR6_0031_000_14_valid : (rowR6_0031_000_14).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_15 : ExtensionRow := { move := 94, child := 373, matrix := ![1,14,5,2,5,7,3,7,4], witnesses := [{ source := 0, target := 91, scalar := 5 },{ source := 1, target := 266, scalar := 14 },{ source := 17, target := 52, scalar := 1 },{ source := 34, target := 17, scalar := 10 },{ source := 52, target := 34, scalar := 1 },{ source := 94, target := 0, scalar := 13 },{ source := 176, target := 1, scalar := 2 }] }
theorem rowR6_0031_000_15_valid : (rowR6_0031_000_15).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_16 : ExtensionRow := { move := 95, child := 186, matrix := ![14,7,0,1,0,0,12,0,4], witnesses := [{ source := 0, target := 0, scalar := 4 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 72, scalar := 14 },{ source := 34, target := 52, scalar := 9 },{ source := 52, target := 1, scalar := 1 },{ source := 95, target := 34, scalar := 1 },{ source := 176, target := 237, scalar := 4 }] }
theorem rowR6_0031_000_16_valid : (rowR6_0031_000_16).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_17 : ExtensionRow := { move := 99, child := 39, matrix := ![10,4,15,0,12,13,0,3,2], witnesses := [{ source := 0, target := 52, scalar := 15 },{ source := 1, target := 69, scalar := 4 },{ source := 17, target := 17, scalar := 10 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 1, scalar := 15 },{ source := 99, target := 0, scalar := 11 },{ source := 176, target := 172, scalar := 2 }] }
theorem rowR6_0031_000_17_valid : (rowR6_0031_000_17).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_18 : ExtensionRow := { move := 101, child := 391, matrix := ![5,1,0,2,1,0,1,1,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 108, scalar := 5 },{ source := 34, target := 94, scalar := 4 },{ source := 52, target := 17, scalar := 7 },{ source := 101, target := 1, scalar := 7 },{ source := 176, target := 52, scalar := 12 }] }
theorem rowR6_0031_000_18_valid : (rowR6_0031_000_18).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_19 : ExtensionRow := { move := 104, child := 112, matrix := ![11,6,12,14,15,0,15,14,0], witnesses := [{ source := 0, target := 17, scalar := 12 },{ source := 1, target := 205, scalar := 6 },{ source := 17, target := 71, scalar := 11 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 1, scalar := 3 },{ source := 104, target := 52, scalar := 4 },{ source := 176, target := 0, scalar := 8 }] }
theorem rowR6_0031_000_19_valid : (rowR6_0031_000_19).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_20 : ExtensionRow := { move := 107, child := 369, matrix := ![1,0,0,13,13,0,5,0,5], witnesses := [{ source := 0, target := 0, scalar := 5 },{ source := 1, target := 1, scalar := 13 },{ source := 17, target := 230, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 91, scalar := 1 },{ source := 107, target := 34, scalar := 1 },{ source := 176, target := 52, scalar := 1 }] }
theorem rowR6_0031_000_20_valid : (rowR6_0031_000_20).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_21 : ExtensionRow := { move := 108, child := 205, matrix := ![14,15,0,12,13,0,5,2,6], witnesses := [{ source := 0, target := 0, scalar := 6 },{ source := 1, target := 52, scalar := 15 },{ source := 17, target := 144, scalar := 14 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 73, scalar := 3 },{ source := 108, target := 17, scalar := 8 },{ source := 176, target := 1, scalar := 3 }] }
theorem rowR6_0031_000_21_valid : (rowR6_0031_000_21).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_22 : ExtensionRow := { move := 110, child := 204, matrix := ![0,1,7,13,1,6,0,1,4], witnesses := [{ source := 0, target := 140, scalar := 7 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 13 },{ source := 34, target := 73, scalar := 6 },{ source := 52, target := 52, scalar := 11 },{ source := 110, target := 0, scalar := 4 },{ source := 176, target := 17, scalar := 2 }] }
theorem rowR6_0031_000_22_valid : (rowR6_0031_000_22).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_23 : ExtensionRow := { move := 115, child := 156, matrix := ![14,1,4,9,1,8,13,1,12], witnesses := [{ source := 0, target := 52, scalar := 4 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 149, scalar := 14 },{ source := 34, target := 17, scalar := 11 },{ source := 52, target := 0, scalar := 8 },{ source := 115, target := 1, scalar := 12 },{ source := 176, target := 72, scalar := 14 }] }
theorem rowR6_0031_000_23_valid : (rowR6_0031_000_23).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_24 : ExtensionRow := { move := 117, child := 114, matrix := ![1,4,11,1,12,13,1,11,10], witnesses := [{ source := 0, target := 213, scalar := 11 },{ source := 1, target := 71, scalar := 4 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 14 },{ source := 52, target := 52, scalar := 7 },{ source := 117, target := 1, scalar := 14 },{ source := 176, target := 0, scalar := 1 }] }
theorem rowR6_0031_000_24_valid : (rowR6_0031_000_24).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_25 : ExtensionRow := { move := 120, child := 122, matrix := ![0,6,1,0,8,1,1,1,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 232, scalar := 6 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 71, scalar := 7 },{ source := 52, target := 17, scalar := 15 },{ source := 120, target := 1, scalar := 2 },{ source := 176, target := 52, scalar := 12 }] }
theorem rowR6_0031_000_25_valid : (rowR6_0031_000_25).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_26 : ExtensionRow := { move := 124, child := 358, matrix := ![5,8,0,10,6,12,15,15,0], witnesses := [{ source := 0, target := 1, scalar := 12 },{ source := 1, target := 91, scalar := 8 },{ source := 17, target := 52, scalar := 5 },{ source := 34, target := 17, scalar := 13 },{ source := 52, target := 143, scalar := 6 },{ source := 124, target := 0, scalar := 11 },{ source := 176, target := 34, scalar := 1 }] }
theorem rowR6_0031_000_26_valid : (rowR6_0031_000_26).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_27 : ExtensionRow := { move := 125, child := 223, matrix := ![2,9,1,0,8,1,0,13,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 74, scalar := 9 },{ source := 17, target := 17, scalar := 2 },{ source := 34, target := 128, scalar := 10 },{ source := 52, target := 0, scalar := 10 },{ source := 125, target := 52, scalar := 13 },{ source := 176, target := 1, scalar := 11 }] }
theorem rowR6_0031_000_27_valid : (rowR6_0031_000_27).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_28 : ExtensionRow := { move := 126, child := 444, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 126, target := 126, scalar := 1 },{ source := 176, target := 176, scalar := 1 }] }
theorem rowR6_0031_000_28_valid : (rowR6_0031_000_28).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_29 : ExtensionRow := { move := 127, child := 385, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 127, target := 92, scalar := 8 },{ source := 176, target := 190, scalar := 6 }] }
theorem rowR6_0031_000_29_valid : (rowR6_0031_000_29).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_30 : ExtensionRow := { move := 131, child := 130, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 131, target := 71, scalar := 1 },{ source := 176, target := 249, scalar := 1 }] }
theorem rowR6_0031_000_30_valid : (rowR6_0031_000_30).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_31 : ExtensionRow := { move := 133, child := 313, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 133, target := 78, scalar := 3 },{ source := 176, target := 220, scalar := 6 }] }
theorem rowR6_0031_000_31_valid : (rowR6_0031_000_31).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_32 : ExtensionRow := { move := 135, child := 444, matrix := ![4,11,0,11,5,0,1,14,5], witnesses := [{ source := 0, target := 0, scalar := 5 },{ source := 1, target := 52, scalar := 11 },{ source := 17, target := 126, scalar := 4 },{ source := 34, target := 176, scalar := 15 },{ source := 52, target := 34, scalar := 1 },{ source := 135, target := 1, scalar := 3 },{ source := 176, target := 17, scalar := 8 }] }
theorem rowR6_0031_000_32_valid : (rowR6_0031_000_32).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_33 : ExtensionRow := { move := 138, child := 420, matrix := ![6,12,10,5,11,0,7,7,0], witnesses := [{ source := 0, target := 17, scalar := 10 },{ source := 1, target := 52, scalar := 12 },{ source := 17, target := 151, scalar := 6 },{ source := 34, target := 1, scalar := 14 },{ source := 52, target := 0, scalar := 9 },{ source := 138, target := 34, scalar := 1 },{ source := 176, target := 108, scalar := 12 }] }
theorem rowR6_0031_000_33_valid : (rowR6_0031_000_33).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_34 : ExtensionRow := { move := 139, child := 185, matrix := ![15,0,1,0,0,1,0,13,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 0, scalar := 13 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 72, scalar := 14 },{ source := 52, target := 233, scalar := 12 },{ source := 139, target := 52, scalar := 5 },{ source := 176, target := 1, scalar := 15 }] }
theorem rowR6_0031_000_34_valid : (rowR6_0031_000_34).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_35 : ExtensionRow := { move := 140, child := 34, matrix := ![10,1,11,15,1,14,5,1,10], witnesses := [{ source := 0, target := 69, scalar := 11 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 154, scalar := 10 },{ source := 34, target := 0, scalar := 14 },{ source := 52, target := 52, scalar := 6 },{ source := 140, target := 17, scalar := 4 },{ source := 176, target := 1, scalar := 3 }] }
theorem rowR6_0031_000_35_valid : (rowR6_0031_000_35).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_36 : ExtensionRow := { move := 143, child := 79, matrix := ![1,0,0,0,0,3,0,6,0], witnesses := [{ source := 0, target := 1, scalar := 3 },{ source := 1, target := 0, scalar := 6 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 71, scalar := 1 },{ source := 52, target := 109, scalar := 1 },{ source := 143, target := 34, scalar := 1 },{ source := 176, target := 52, scalar := 1 }] }
theorem rowR6_0031_000_36_valid : (rowR6_0031_000_36).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_37 : ExtensionRow := { move := 149, child := 167, matrix := ![3,6,5,0,10,10,0,1,15], witnesses := [{ source := 0, target := 52, scalar := 5 },{ source := 1, target := 72, scalar := 6 },{ source := 17, target := 17, scalar := 3 },{ source := 34, target := 0, scalar := 14 },{ source := 52, target := 1, scalar := 10 },{ source := 149, target := 34, scalar := 1 },{ source := 176, target := 186, scalar := 6 }] }
theorem rowR6_0031_000_37_valid : (rowR6_0031_000_37).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_38 : ExtensionRow := { move := 150, child := 182, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 150, target := 72, scalar := 13 },{ source := 176, target := 220, scalar := 6 }] }
theorem rowR6_0031_000_38_valid : (rowR6_0031_000_38).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_39 : ExtensionRow := { move := 152, child := 432, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 152, target := 110, scalar := 15 },{ source := 176, target := 220, scalar := 6 }] }
theorem rowR6_0031_000_39_valid : (rowR6_0031_000_39).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_40 : ExtensionRow := { move := 154, child := 163, matrix := ![5,14,11,15,15,0,8,1,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 52, scalar := 14 },{ source := 17, target := 72, scalar := 5 },{ source := 34, target := 0, scalar := 9 },{ source := 52, target := 172, scalar := 4 },{ source := 154, target := 1, scalar := 14 },{ source := 176, target := 34, scalar := 1 }] }
theorem rowR6_0031_000_40_valid : (rowR6_0031_000_40).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_41 : ExtensionRow := { move := 156, child := 331, matrix := ![0,9,2,8,2,4,0,5,6], witnesses := [{ source := 0, target := 52, scalar := 2 },{ source := 1, target := 91, scalar := 9 },{ source := 17, target := 1, scalar := 8 },{ source := 34, target := 80, scalar := 11 },{ source := 52, target := 17, scalar := 7 },{ source := 156, target := 34, scalar := 1 },{ source := 176, target := 0, scalar := 15 }] }
theorem rowR6_0031_000_41_valid : (rowR6_0031_000_41).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_42 : ExtensionRow := { move := 158, child := 216, matrix := ![1,0,0,1,2,0,1,0,8], witnesses := [{ source := 0, target := 0, scalar := 8 },{ source := 1, target := 1, scalar := 2 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 74, scalar := 1 },{ source := 52, target := 107, scalar := 1 },{ source := 158, target := 52, scalar := 1 },{ source := 176, target := 17, scalar := 1 }] }
theorem rowR6_0031_000_42_valid : (rowR6_0031_000_42).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_43 : ExtensionRow := { move := 159, child := 360, matrix := ![0,11,10,1,7,7,0,12,13], witnesses := [{ source := 0, target := 52, scalar := 10 },{ source := 1, target := 154, scalar := 11 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 91, scalar := 8 },{ source := 159, target := 17, scalar := 1 },{ source := 176, target := 0, scalar := 1 }] }
theorem rowR6_0031_000_43_valid : (rowR6_0031_000_43).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_44 : ExtensionRow := { move := 181, child := 370, matrix := ![15,9,11,9,1,8,12,8,4], witnesses := [{ source := 0, target := 248, scalar := 11 },{ source := 1, target := 52, scalar := 9 },{ source := 17, target := 91, scalar := 15 },{ source := 34, target := 17, scalar := 13 },{ source := 52, target := 0, scalar := 3 },{ source := 176, target := 34, scalar := 1 },{ source := 181, target := 1, scalar := 5 }] }
theorem rowR6_0031_000_44_valid : (rowR6_0031_000_44).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_45 : ExtensionRow := { move := 182, child := 313, matrix := ![1,9,10,1,6,7,1,12,13], witnesses := [{ source := 0, target := 52, scalar := 10 },{ source := 1, target := 220, scalar := 9 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 2 },{ source := 52, target := 78, scalar := 13 },{ source := 176, target := 1, scalar := 9 },{ source := 182, target := 0, scalar := 12 }] }
theorem rowR6_0031_000_45_valid : (rowR6_0031_000_45).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_46 : ExtensionRow := { move := 183, child := 241, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 176, target := 220, scalar := 6 },{ source := 183, target := 74, scalar := 12 }] }
theorem rowR6_0031_000_46_valid : (rowR6_0031_000_46).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowR6_0031_000_47 : ExtensionRow := { move := 185, child := 419, matrix := ![5,5,0,2,0,2,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 2 },{ source := 1, target := 17, scalar := 5 },{ source := 17, target := 108, scalar := 5 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 121, scalar := 15 },{ source := 176, target := 52, scalar := 14 },{ source := 185, target := 34, scalar := 1 }] }
theorem rowR6_0031_000_47_valid : (rowR6_0031_000_47).ValidFor level7 {0,1,17,34,52,176} := by decide

noncomputable def rowsR6_0031_000 : List ExtensionRow := [rowR6_0031_000_0,rowR6_0031_000_1,rowR6_0031_000_2,rowR6_0031_000_3,rowR6_0031_000_4,rowR6_0031_000_5,rowR6_0031_000_6,rowR6_0031_000_7,rowR6_0031_000_8,rowR6_0031_000_9,rowR6_0031_000_10,rowR6_0031_000_11,rowR6_0031_000_12,rowR6_0031_000_13,rowR6_0031_000_14,rowR6_0031_000_15,rowR6_0031_000_16,rowR6_0031_000_17,rowR6_0031_000_18,rowR6_0031_000_19,rowR6_0031_000_20,rowR6_0031_000_21,rowR6_0031_000_22,rowR6_0031_000_23,rowR6_0031_000_24,rowR6_0031_000_25,rowR6_0031_000_26,rowR6_0031_000_27,rowR6_0031_000_28,rowR6_0031_000_29,rowR6_0031_000_30,rowR6_0031_000_31,rowR6_0031_000_32,rowR6_0031_000_33,rowR6_0031_000_34,rowR6_0031_000_35,rowR6_0031_000_36,rowR6_0031_000_37,rowR6_0031_000_38,rowR6_0031_000_39,rowR6_0031_000_40,rowR6_0031_000_41,rowR6_0031_000_42,rowR6_0031_000_43,rowR6_0031_000_44,rowR6_0031_000_45,rowR6_0031_000_46,rowR6_0031_000_47]

theorem rowsR6_0031_000_valid : RowListValid level7 {0,1,17,34,52,176} rowsR6_0031_000 := by
  intro r hr
  simp only [rowsR6_0031_000, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR6_0031_000_0_valid
  · exact rowR6_0031_000_1_valid
  · exact rowR6_0031_000_2_valid
  · exact rowR6_0031_000_3_valid
  · exact rowR6_0031_000_4_valid
  · exact rowR6_0031_000_5_valid
  · exact rowR6_0031_000_6_valid
  · exact rowR6_0031_000_7_valid
  · exact rowR6_0031_000_8_valid
  · exact rowR6_0031_000_9_valid
  · exact rowR6_0031_000_10_valid
  · exact rowR6_0031_000_11_valid
  · exact rowR6_0031_000_12_valid
  · exact rowR6_0031_000_13_valid
  · exact rowR6_0031_000_14_valid
  · exact rowR6_0031_000_15_valid
  · exact rowR6_0031_000_16_valid
  · exact rowR6_0031_000_17_valid
  · exact rowR6_0031_000_18_valid
  · exact rowR6_0031_000_19_valid
  · exact rowR6_0031_000_20_valid
  · exact rowR6_0031_000_21_valid
  · exact rowR6_0031_000_22_valid
  · exact rowR6_0031_000_23_valid
  · exact rowR6_0031_000_24_valid
  · exact rowR6_0031_000_25_valid
  · exact rowR6_0031_000_26_valid
  · exact rowR6_0031_000_27_valid
  · exact rowR6_0031_000_28_valid
  · exact rowR6_0031_000_29_valid
  · exact rowR6_0031_000_30_valid
  · exact rowR6_0031_000_31_valid
  · exact rowR6_0031_000_32_valid
  · exact rowR6_0031_000_33_valid
  · exact rowR6_0031_000_34_valid
  · exact rowR6_0031_000_35_valid
  · exact rowR6_0031_000_36_valid
  · exact rowR6_0031_000_37_valid
  · exact rowR6_0031_000_38_valid
  · exact rowR6_0031_000_39_valid
  · exact rowR6_0031_000_40_valid
  · exact rowR6_0031_000_41_valid
  · exact rowR6_0031_000_42_valid
  · exact rowR6_0031_000_43_valid
  · exact rowR6_0031_000_44_valid
  · exact rowR6_0031_000_45_valid
  · exact rowR6_0031_000_46_valid
  · exact rowR6_0031_000_47_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
