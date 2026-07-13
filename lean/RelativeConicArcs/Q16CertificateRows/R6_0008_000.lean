import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR6_0008_000_0 : ExtensionRow := { move := 83, child := 62, matrix := ![0,1,0,0,1,2,4,1,0], witnesses := [{ source := 0, target := 1, scalar := 2 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 4 },{ source := 34, target := 70, scalar := 1 },{ source := 52, target := 52, scalar := 2 },{ source := 78, target := 125, scalar := 3 },{ source := 83, target := 17, scalar := 4 }] }
theorem rowR6_0008_000_0_valid : (rowR6_0008_000_0).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_1 : ExtensionRow := { move := 86, child := 55, matrix := ![0,1,15,0,1,0,2,1,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 2 },{ source := 34, target := 70, scalar := 14 },{ source := 52, target := 1, scalar := 2 },{ source := 78, target := 94, scalar := 4 },{ source := 86, target := 52, scalar := 2 }] }
theorem rowR6_0008_000_1_valid : (rowR6_0008_000_1).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_2 : ExtensionRow := { move := 89, child := 87, matrix := ![2,1,0,4,1,0,6,1,13], witnesses := [{ source := 0, target := 0, scalar := 13 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 2 },{ source := 34, target := 71, scalar := 3 },{ source := 52, target := 1, scalar := 6 },{ source := 78, target := 140, scalar := 1 },{ source := 89, target := 17, scalar := 6 }] }
theorem rowR6_0008_000_2_valid : (rowR6_0008_000_2).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_3 : ExtensionRow := { move := 90, child := 144, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 78, target := 103, scalar := 14 },{ source := 90, target := 72, scalar := 13 }] }
theorem rowR6_0008_000_3_valid : (rowR6_0008_000_3).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_4 : ExtensionRow := { move := 91, child := 289, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 78, target := 78, scalar := 1 },{ source := 91, target := 91, scalar := 1 }] }
theorem rowR6_0008_000_4_valid : (rowR6_0008_000_4).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_5 : ExtensionRow := { move := 92, child := 134, matrix := ![2,0,15,6,12,10,12,0,12], witnesses := [{ source := 0, target := 267, scalar := 15 },{ source := 1, target := 1, scalar := 12 },{ source := 17, target := 71, scalar := 2 },{ source := 34, target := 17, scalar := 13 },{ source := 52, target := 0, scalar := 11 },{ source := 78, target := 52, scalar := 5 },{ source := 92, target := 34, scalar := 1 }] }
theorem rowR6_0008_000_5_valid : (rowR6_0008_000_5).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_6 : ExtensionRow := { move := 96, child := 5, matrix := ![11,11,0,5,10,15,14,7,0], witnesses := [{ source := 0, target := 1, scalar := 15 },{ source := 1, target := 89, scalar := 11 },{ source := 17, target := 52, scalar := 11 },{ source := 34, target := 0, scalar := 9 },{ source := 52, target := 17, scalar := 14 },{ source := 78, target := 69, scalar := 5 },{ source := 96, target := 34, scalar := 1 }] }
theorem rowR6_0008_000_6_valid : (rowR6_0008_000_6).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_7 : ExtensionRow := { move := 99, child := 40, matrix := ![10,4,15,0,12,13,0,3,2], witnesses := [{ source := 0, target := 52, scalar := 15 },{ source := 1, target := 69, scalar := 4 },{ source := 17, target := 17, scalar := 10 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 1, scalar := 15 },{ source := 78, target := 173, scalar := 1 },{ source := 99, target := 0, scalar := 11 }] }
theorem rowR6_0008_000_7_valid : (rowR6_0008_000_7).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_8 : ExtensionRow := { move := 103, child := 290, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 78, target := 103, scalar := 14 },{ source := 103, target := 78, scalar := 3 }] }
theorem rowR6_0008_000_8_valid : (rowR6_0008_000_8).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_9 : ExtensionRow := { move := 104, child := 153, matrix := ![3,1,0,5,1,0,9,1,14], witnesses := [{ source := 0, target := 0, scalar := 14 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 72, scalar := 3 },{ source := 34, target := 52, scalar := 2 },{ source := 52, target := 139, scalar := 1 },{ source := 78, target := 1, scalar := 6 },{ source := 104, target := 17, scalar := 6 }] }
theorem rowR6_0008_000_9_valid : (rowR6_0008_000_9).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_10 : ExtensionRow := { move := 106, child := 151, matrix := ![0,5,6,0,10,10,14,15,1], witnesses := [{ source := 0, target := 72, scalar := 6 },{ source := 1, target := 52, scalar := 5 },{ source := 17, target := 0, scalar := 14 },{ source := 34, target := 17, scalar := 3 },{ source := 52, target := 1, scalar := 10 },{ source := 78, target := 135, scalar := 7 },{ source := 106, target := 34, scalar := 1 }] }
theorem rowR6_0008_000_10_valid : (rowR6_0008_000_10).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_11 : ExtensionRow := { move := 108, child := 78, matrix := ![0,14,15,0,3,2,2,7,4], witnesses := [{ source := 0, target := 71, scalar := 15 },{ source := 1, target := 106, scalar := 14 },{ source := 17, target := 0, scalar := 2 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 17, scalar := 13 },{ source := 78, target := 52, scalar := 6 },{ source := 108, target := 1, scalar := 10 }] }
theorem rowR6_0008_000_11_valid : (rowR6_0008_000_11).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_12 : ExtensionRow := { move := 109, child := 291, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 78, target := 78, scalar := 1 },{ source := 109, target := 109, scalar := 1 }] }
theorem rowR6_0008_000_12_valid : (rowR6_0008_000_12).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_13 : ExtensionRow := { move := 115, child := 18, matrix := ![0,14,0,2,1,0,0,13,7], witnesses := [{ source := 0, target := 0, scalar := 7 },{ source := 1, target := 69, scalar := 14 },{ source := 17, target := 1, scalar := 2 },{ source := 34, target := 110, scalar := 14 },{ source := 52, target := 17, scalar := 15 },{ source := 78, target := 34, scalar := 1 },{ source := 115, target := 52, scalar := 2 }] }
theorem rowR6_0008_000_13_valid : (rowR6_0008_000_13).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_14 : ExtensionRow := { move := 117, child := 83, matrix := ![0,1,8,0,3,3,13,6,11], witnesses := [{ source := 0, target := 52, scalar := 8 },{ source := 1, target := 71, scalar := 1 },{ source := 17, target := 0, scalar := 13 },{ source := 34, target := 17, scalar := 9 },{ source := 52, target := 126, scalar := 9 },{ source := 78, target := 34, scalar := 1 },{ source := 117, target := 1, scalar := 6 }] }
theorem rowR6_0008_000_14_valid : (rowR6_0008_000_14).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_15 : ExtensionRow := { move := 120, child := 292, matrix := ![0,7,0,1,0,0,0,0,6], witnesses := [{ source := 0, target := 0, scalar := 6 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 120, scalar := 7 },{ source := 52, target := 78, scalar := 14 },{ source := 78, target := 52, scalar := 9 },{ source := 120, target := 34, scalar := 1 }] }
theorem rowR6_0008_000_15_valid : (rowR6_0008_000_15).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_16 : ExtensionRow := { move := 121, child := 293, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 78, target := 78, scalar := 1 },{ source := 121, target := 121, scalar := 1 }] }
theorem rowR6_0008_000_16_valid : (rowR6_0008_000_16).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_17 : ExtensionRow := { move := 124, child := 260, matrix := ![0,1,0,6,1,0,0,1,13], witnesses := [{ source := 0, target := 0, scalar := 13 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 6 },{ source := 34, target := 141, scalar := 1 },{ source := 52, target := 52, scalar := 2 },{ source := 78, target := 75, scalar := 3 },{ source := 124, target := 17, scalar := 6 }] }
theorem rowR6_0008_000_17_valid : (rowR6_0008_000_17).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_18 : ExtensionRow := { move := 125, child := 214, matrix := ![7,1,3,8,1,6,15,1,5], witnesses := [{ source := 0, target := 52, scalar := 3 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 101, scalar := 7 },{ source := 34, target := 74, scalar := 5 },{ source := 52, target := 0, scalar := 2 },{ source := 78, target := 1, scalar := 3 },{ source := 125, target := 17, scalar := 6 }] }
theorem rowR6_0008_000_18_valid : (rowR6_0008_000_18).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_19 : ExtensionRow := { move := 128, child := 173, matrix := ![14,0,9,15,11,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 1, scalar := 11 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 199, scalar := 7 },{ source := 52, target := 72, scalar := 6 },{ source := 78, target := 34, scalar := 1 },{ source := 128, target := 0, scalar := 1 }] }
theorem rowR6_0008_000_19_valid : (rowR6_0008_000_19).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_20 : ExtensionRow := { move := 131, child := 67, matrix := ![0,8,15,0,11,13,8,14,2], witnesses := [{ source := 0, target := 52, scalar := 15 },{ source := 1, target := 70, scalar := 8 },{ source := 17, target := 0, scalar := 8 },{ source := 34, target := 140, scalar := 7 },{ source := 52, target := 34, scalar := 1 },{ source := 78, target := 17, scalar := 12 },{ source := 131, target := 1, scalar := 13 }] }
theorem rowR6_0008_000_20_valid : (rowR6_0008_000_20).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_21 : ExtensionRow := { move := 133, child := 294, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 78, target := 133, scalar := 14 },{ source := 133, target := 78, scalar := 3 }] }
theorem rowR6_0008_000_21_valid : (rowR6_0008_000_21).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_22 : ExtensionRow := { move := 137, child := 295, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 78, target := 78, scalar := 1 },{ source := 137, target := 137, scalar := 1 }] }
theorem rowR6_0008_000_22_valid : (rowR6_0008_000_22).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_23 : ExtensionRow := { move := 138, child := 108, matrix := ![1,0,4,1,0,14,1,6,10], witnesses := [{ source := 0, target := 188, scalar := 4 },{ source := 1, target := 0, scalar := 6 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 71, scalar := 5 },{ source := 52, target := 17, scalar := 13 },{ source := 78, target := 1, scalar := 11 },{ source := 138, target := 52, scalar := 3 }] }
theorem rowR6_0008_000_23_valid : (rowR6_0008_000_23).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_24 : ExtensionRow := { move := 139, child := 296, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 78, target := 78, scalar := 1 },{ source := 139, target := 139, scalar := 1 }] }
theorem rowR6_0008_000_24_valid : (rowR6_0008_000_24).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_25 : ExtensionRow := { move := 140, child := 7, matrix := ![9,3,5,2,0,15,5,0,7], witnesses := [{ source := 0, target := 69, scalar := 5 },{ source := 1, target := 17, scalar := 3 },{ source := 17, target := 91, scalar := 9 },{ source := 34, target := 52, scalar := 15 },{ source := 52, target := 0, scalar := 12 },{ source := 78, target := 1, scalar := 5 },{ source := 140, target := 34, scalar := 1 }] }
theorem rowR6_0008_000_25_valid : (rowR6_0008_000_25).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_26 : ExtensionRow := { move := 141, child := 225, matrix := ![1,7,6,1,6,10,1,2,3], witnesses := [{ source := 0, target := 74, scalar := 6 },{ source := 1, target := 141, scalar := 7 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 13 },{ source := 52, target := 17, scalar := 5 },{ source := 78, target := 0, scalar := 3 },{ source := 141, target := 52, scalar := 9 }] }
theorem rowR6_0008_000_26_valid : (rowR6_0008_000_26).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_27 : ExtensionRow := { move := 143, child := 99, matrix := ![11,4,15,0,2,2,0,14,4], witnesses := [{ source := 0, target := 71, scalar := 15 },{ source := 1, target := 171, scalar := 4 },{ source := 17, target := 17, scalar := 11 },{ source := 34, target := 0, scalar := 10 },{ source := 52, target := 52, scalar := 1 },{ source := 78, target := 1, scalar := 15 },{ source := 143, target := 34, scalar := 1 }] }
theorem rowR6_0008_000_27_valid : (rowR6_0008_000_27).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_28 : ExtensionRow := { move := 144, child := 297, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 78, target := 78, scalar := 1 },{ source := 144, target := 144, scalar := 1 }] }
theorem rowR6_0008_000_28_valid : (rowR6_0008_000_28).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_29 : ExtensionRow := { move := 149, child := 192, matrix := ![3,6,5,0,10,10,0,1,15], witnesses := [{ source := 0, target := 52, scalar := 5 },{ source := 1, target := 72, scalar := 6 },{ source := 17, target := 17, scalar := 3 },{ source := 34, target := 0, scalar := 14 },{ source := 52, target := 1, scalar := 10 },{ source := 78, target := 267, scalar := 5 },{ source := 149, target := 34, scalar := 1 }] }
theorem rowR6_0008_000_29_valid : (rowR6_0008_000_29).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_30 : ExtensionRow := { move := 151, child := 298, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 78, target := 78, scalar := 1 },{ source := 151, target := 151, scalar := 1 }] }
theorem rowR6_0008_000_30_valid : (rowR6_0008_000_30).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_31 : ExtensionRow := { move := 152, child := 299, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 78, target := 78, scalar := 1 },{ source := 152, target := 152, scalar := 1 }] }
theorem rowR6_0008_000_31_valid : (rowR6_0008_000_31).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_32 : ExtensionRow := { move := 154, child := 300, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 78, target := 78, scalar := 1 },{ source := 154, target := 154, scalar := 1 }] }
theorem rowR6_0008_000_32_valid : (rowR6_0008_000_32).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_33 : ExtensionRow := { move := 155, child := 301, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 78, target := 78, scalar := 1 },{ source := 155, target := 155, scalar := 1 }] }
theorem rowR6_0008_000_33_valid : (rowR6_0008_000_33).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_34 : ExtensionRow := { move := 156, child := 144, matrix := ![7,6,1,9,13,1,6,7,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 103, scalar := 6 },{ source := 17, target := 72, scalar := 7 },{ source := 34, target := 1, scalar := 5 },{ source := 52, target := 52, scalar := 8 },{ source := 78, target := 0, scalar := 2 },{ source := 156, target := 17, scalar := 9 }] }
theorem rowR6_0008_000_34_valid : (rowR6_0008_000_34).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_35 : ExtensionRow := { move := 159, child := 240, matrix := ![0,11,9,14,5,0,0,14,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 52, scalar := 11 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 216, scalar := 2 },{ source := 52, target := 74, scalar := 13 },{ source := 78, target := 34, scalar := 1 },{ source := 159, target := 0, scalar := 9 }] }
theorem rowR6_0008_000_35_valid : (rowR6_0008_000_35).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_36 : ExtensionRow := { move := 163, child := 177, matrix := ![3,0,1,14,15,1,1,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 1, scalar := 15 },{ source := 17, target := 207, scalar := 3 },{ source := 34, target := 17, scalar := 2 },{ source := 52, target := 0, scalar := 2 },{ source := 78, target := 72, scalar := 14 },{ source := 163, target := 52, scalar := 1 }] }
theorem rowR6_0008_000_36_valid : (rowR6_0008_000_36).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_37 : ExtensionRow := { move := 167, child := 302, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 78, target := 78, scalar := 1 },{ source := 167, target := 167, scalar := 1 }] }
theorem rowR6_0008_000_37_valid : (rowR6_0008_000_37).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_38 : ExtensionRow := { move := 168, child := 303, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 78, target := 78, scalar := 1 },{ source := 168, target := 168, scalar := 1 }] }
theorem rowR6_0008_000_38_valid : (rowR6_0008_000_38).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_39 : ExtensionRow := { move := 169, child := 98, matrix := ![10,5,0,5,10,15,15,15,0], witnesses := [{ source := 0, target := 1, scalar := 15 },{ source := 1, target := 52, scalar := 5 },{ source := 17, target := 169, scalar := 10 },{ source := 34, target := 17, scalar := 15 },{ source := 52, target := 0, scalar := 2 },{ source := 78, target := 71, scalar := 5 },{ source := 169, target := 34, scalar := 1 }] }
theorem rowR6_0008_000_39_valid : (rowR6_0008_000_39).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_40 : ExtensionRow := { move := 171, child := 269, matrix := ![9,10,3,8,0,6,5,0,5], witnesses := [{ source := 0, target := 52, scalar := 3 },{ source := 1, target := 17, scalar := 10 },{ source := 17, target := 75, scalar := 9 },{ source := 34, target := 1, scalar := 14 },{ source := 52, target := 181, scalar := 11 },{ source := 78, target := 0, scalar := 9 },{ source := 171, target := 34, scalar := 1 }] }
theorem rowR6_0008_000_40_valid : (rowR6_0008_000_40).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_41 : ExtensionRow := { move := 173, child := 230, matrix := ![1,15,12,1,2,0,1,14,0], witnesses := [{ source := 0, target := 17, scalar := 12 },{ source := 1, target := 74, scalar := 15 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 159, scalar := 2 },{ source := 52, target := 52, scalar := 11 },{ source := 78, target := 1, scalar := 7 },{ source := 173, target := 0, scalar := 6 }] }
theorem rowR6_0008_000_41_valid : (rowR6_0008_000_41).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_42 : ExtensionRow := { move := 175, child := 54, matrix := ![1,0,1,1,0,3,1,4,5], witnesses := [{ source := 0, target := 70, scalar := 1 },{ source := 1, target := 0, scalar := 4 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 2 },{ source := 52, target := 52, scalar := 2 },{ source := 78, target := 91, scalar := 12 },{ source := 175, target := 17, scalar := 15 }] }
theorem rowR6_0008_000_42_valid : (rowR6_0008_000_42).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_43 : ExtensionRow := { move := 176, child := 304, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 78, target := 78, scalar := 1 },{ source := 176, target := 176, scalar := 1 }] }
theorem rowR6_0008_000_43_valid : (rowR6_0008_000_43).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_44 : ExtensionRow := { move := 181, child := 305, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 78, target := 78, scalar := 1 },{ source := 181, target := 181, scalar := 1 }] }
theorem rowR6_0008_000_44_valid : (rowR6_0008_000_44).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_45 : ExtensionRow := { move := 182, child := 306, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 78, target := 78, scalar := 1 },{ source := 182, target := 182, scalar := 1 }] }
theorem rowR6_0008_000_45_valid : (rowR6_0008_000_45).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_46 : ExtensionRow := { move := 183, child := 188, matrix := ![5,1,11,3,1,0,10,1,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 243, scalar := 5 },{ source := 34, target := 72, scalar := 15 },{ source := 52, target := 52, scalar := 9 },{ source := 78, target := 0, scalar := 9 },{ source := 183, target := 1, scalar := 9 }] }
theorem rowR6_0008_000_46_valid : (rowR6_0008_000_46).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowR6_0008_000_47 : ExtensionRow := { move := 184, child := 165, matrix := ![2,1,0,7,2,0,12,3,6], witnesses := [{ source := 0, target := 0, scalar := 6 },{ source := 1, target := 52, scalar := 1 },{ source := 17, target := 183, scalar := 2 },{ source := 34, target := 72, scalar := 3 },{ source := 52, target := 1, scalar := 3 },{ source := 78, target := 34, scalar := 1 },{ source := 184, target := 17, scalar := 8 }] }
theorem rowR6_0008_000_47_valid : (rowR6_0008_000_47).ValidFor level7 {0,1,17,34,52,78} := by decide

noncomputable def rowsR6_0008_000 : List ExtensionRow := [rowR6_0008_000_0,rowR6_0008_000_1,rowR6_0008_000_2,rowR6_0008_000_3,rowR6_0008_000_4,rowR6_0008_000_5,rowR6_0008_000_6,rowR6_0008_000_7,rowR6_0008_000_8,rowR6_0008_000_9,rowR6_0008_000_10,rowR6_0008_000_11,rowR6_0008_000_12,rowR6_0008_000_13,rowR6_0008_000_14,rowR6_0008_000_15,rowR6_0008_000_16,rowR6_0008_000_17,rowR6_0008_000_18,rowR6_0008_000_19,rowR6_0008_000_20,rowR6_0008_000_21,rowR6_0008_000_22,rowR6_0008_000_23,rowR6_0008_000_24,rowR6_0008_000_25,rowR6_0008_000_26,rowR6_0008_000_27,rowR6_0008_000_28,rowR6_0008_000_29,rowR6_0008_000_30,rowR6_0008_000_31,rowR6_0008_000_32,rowR6_0008_000_33,rowR6_0008_000_34,rowR6_0008_000_35,rowR6_0008_000_36,rowR6_0008_000_37,rowR6_0008_000_38,rowR6_0008_000_39,rowR6_0008_000_40,rowR6_0008_000_41,rowR6_0008_000_42,rowR6_0008_000_43,rowR6_0008_000_44,rowR6_0008_000_45,rowR6_0008_000_46,rowR6_0008_000_47]

theorem rowsR6_0008_000_valid : RowListValid level7 {0,1,17,34,52,78} rowsR6_0008_000 := by
  intro r hr
  simp only [rowsR6_0008_000, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR6_0008_000_0_valid
  · exact rowR6_0008_000_1_valid
  · exact rowR6_0008_000_2_valid
  · exact rowR6_0008_000_3_valid
  · exact rowR6_0008_000_4_valid
  · exact rowR6_0008_000_5_valid
  · exact rowR6_0008_000_6_valid
  · exact rowR6_0008_000_7_valid
  · exact rowR6_0008_000_8_valid
  · exact rowR6_0008_000_9_valid
  · exact rowR6_0008_000_10_valid
  · exact rowR6_0008_000_11_valid
  · exact rowR6_0008_000_12_valid
  · exact rowR6_0008_000_13_valid
  · exact rowR6_0008_000_14_valid
  · exact rowR6_0008_000_15_valid
  · exact rowR6_0008_000_16_valid
  · exact rowR6_0008_000_17_valid
  · exact rowR6_0008_000_18_valid
  · exact rowR6_0008_000_19_valid
  · exact rowR6_0008_000_20_valid
  · exact rowR6_0008_000_21_valid
  · exact rowR6_0008_000_22_valid
  · exact rowR6_0008_000_23_valid
  · exact rowR6_0008_000_24_valid
  · exact rowR6_0008_000_25_valid
  · exact rowR6_0008_000_26_valid
  · exact rowR6_0008_000_27_valid
  · exact rowR6_0008_000_28_valid
  · exact rowR6_0008_000_29_valid
  · exact rowR6_0008_000_30_valid
  · exact rowR6_0008_000_31_valid
  · exact rowR6_0008_000_32_valid
  · exact rowR6_0008_000_33_valid
  · exact rowR6_0008_000_34_valid
  · exact rowR6_0008_000_35_valid
  · exact rowR6_0008_000_36_valid
  · exact rowR6_0008_000_37_valid
  · exact rowR6_0008_000_38_valid
  · exact rowR6_0008_000_39_valid
  · exact rowR6_0008_000_40_valid
  · exact rowR6_0008_000_41_valid
  · exact rowR6_0008_000_42_valid
  · exact rowR6_0008_000_43_valid
  · exact rowR6_0008_000_44_valid
  · exact rowR6_0008_000_45_valid
  · exact rowR6_0008_000_46_valid
  · exact rowR6_0008_000_47_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
