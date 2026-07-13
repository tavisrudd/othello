import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR6_0020_000_0 : ExtensionRow := { move := 67, child := 2, matrix := ![1,0,0,2,1,0,3,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 52, scalar := 1 },{ source := 34, target := 67, scalar := 1 },{ source := 52, target := 17, scalar := 1 },{ source := 67, target := 34, scalar := 1 },{ source := 121, target := 92, scalar := 1 }] }
theorem rowR6_0020_000_0_valid : (rowR6_0020_000_0).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_1 : ExtensionRow := { move := 71, child := 82, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 71, target := 71, scalar := 1 },{ source := 121, target := 121, scalar := 1 }] }
theorem rowR6_0020_000_1_valid : (rowR6_0020_000_1).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_2 : ExtensionRow := { move := 74, child := 221, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 74, target := 74, scalar := 1 },{ source := 121, target := 121, scalar := 1 }] }
theorem rowR6_0020_000_2_valid : (rowR6_0020_000_2).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_3 : ExtensionRow := { move := 75, child := 195, matrix := ![0,7,6,0,11,10,5,5,1], witnesses := [{ source := 0, target := 72, scalar := 6 },{ source := 1, target := 270, scalar := 7 },{ source := 17, target := 0, scalar := 5 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 4 },{ source := 75, target := 1, scalar := 6 },{ source := 121, target := 17, scalar := 4 }] }
theorem rowR6_0020_000_3_valid : (rowR6_0020_000_3).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_4 : ExtensionRow := { move := 78, child := 293, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 78, target := 78, scalar := 1 },{ source := 121, target := 121, scalar := 1 }] }
theorem rowR6_0020_000_4_valid : (rowR6_0020_000_4).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_5 : ExtensionRow := { move := 79, child := 215, matrix := ![0,14,0,2,1,0,0,7,11], witnesses := [{ source := 0, target := 0, scalar := 11 },{ source := 1, target := 74, scalar := 14 },{ source := 17, target := 1, scalar := 2 },{ source := 34, target := 104, scalar := 14 },{ source := 52, target := 17, scalar := 15 },{ source := 79, target := 34, scalar := 1 },{ source := 121, target := 52, scalar := 2 }] }
theorem rowR6_0020_000_5_valid : (rowR6_0020_000_5).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_6 : ExtensionRow := { move := 80, child := 336, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 80, target := 80, scalar := 1 },{ source := 121, target := 121, scalar := 1 }] }
theorem rowR6_0020_000_6_valid : (rowR6_0020_000_6).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_7 : ExtensionRow := { move := 83, child := 59, matrix := ![11,11,0,14,0,14,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 14 },{ source := 1, target := 17, scalar := 11 },{ source := 17, target := 70, scalar := 11 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 14 },{ source := 83, target := 34, scalar := 1 },{ source := 121, target := 110, scalar := 4 }] }
theorem rowR6_0020_000_7_valid : (rowR6_0020_000_7).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_8 : ExtensionRow := { move := 86, child := 67, matrix := ![0,1,15,0,1,0,2,1,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 2 },{ source := 34, target := 70, scalar := 14 },{ source := 52, target := 1, scalar := 2 },{ source := 86, target := 52, scalar := 2 },{ source := 121, target := 140, scalar := 7 }] }
theorem rowR6_0020_000_8_valid : (rowR6_0020_000_8).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_9 : ExtensionRow := { move := 90, child := 167, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 90, target := 72, scalar := 13 },{ source := 121, target := 186, scalar := 14 }] }
theorem rowR6_0020_000_9_valid : (rowR6_0020_000_9).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_10 : ExtensionRow := { move := 91, child := 355, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 91, target := 91, scalar := 1 },{ source := 121, target := 121, scalar := 1 }] }
theorem rowR6_0020_000_10_valid : (rowR6_0020_000_10).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_11 : ExtensionRow := { move := 92, child := 284, matrix := ![0,3,12,0,6,4,1,5,8], witnesses := [{ source := 0, target := 256, scalar := 12 },{ source := 1, target := 52, scalar := 3 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 75, scalar := 15 },{ source := 52, target := 17, scalar := 1 },{ source := 92, target := 34, scalar := 1 },{ source := 121, target := 1, scalar := 1 }] }
theorem rowR6_0020_000_11_valid : (rowR6_0020_000_11).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_12 : ExtensionRow := { move := 93, child := 177, matrix := ![1,0,0,2,9,0,3,0,13], witnesses := [{ source := 0, target := 0, scalar := 13 },{ source := 1, target := 1, scalar := 9 },{ source := 17, target := 52, scalar := 1 },{ source := 34, target := 207, scalar := 1 },{ source := 52, target := 72, scalar := 1 },{ source := 93, target := 17, scalar := 1 },{ source := 121, target := 34, scalar := 1 }] }
theorem rowR6_0020_000_12_valid : (rowR6_0020_000_12).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_13 : ExtensionRow := { move := 94, child := 392, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 94, target := 94, scalar := 1 },{ source := 121, target := 121, scalar := 1 }] }
theorem rowR6_0020_000_13_valid : (rowR6_0020_000_13).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_14 : ExtensionRow := { move := 96, child := 93, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 96, target := 71, scalar := 11 },{ source := 121, target := 156, scalar := 14 }] }
theorem rowR6_0020_000_14_valid : (rowR6_0020_000_14).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_15 : ExtensionRow := { move := 101, child := 403, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 101, target := 101, scalar := 1 },{ source := 121, target := 121, scalar := 1 }] }
theorem rowR6_0020_000_15_valid : (rowR6_0020_000_15).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_16 : ExtensionRow := { move := 103, child := 231, matrix := ![4,5,1,2,0,2,10,0,3], witnesses := [{ source := 0, target := 52, scalar := 1 },{ source := 1, target := 17, scalar := 5 },{ source := 17, target := 172, scalar := 4 },{ source := 34, target := 0, scalar := 9 },{ source := 52, target := 74, scalar := 13 },{ source := 103, target := 1, scalar := 14 },{ source := 121, target := 34, scalar := 1 }] }
theorem rowR6_0020_000_16_valid : (rowR6_0020_000_16).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_17 : ExtensionRow := { move := 104, child := 231, matrix := ![15,6,1,2,3,1,14,15,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 172, scalar := 6 },{ source := 17, target := 74, scalar := 15 },{ source := 34, target := 17, scalar := 8 },{ source := 52, target := 1, scalar := 7 },{ source := 104, target := 52, scalar := 5 },{ source := 121, target := 0, scalar := 2 }] }
theorem rowR6_0020_000_17_valid : (rowR6_0020_000_17).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_18 : ExtensionRow := { move := 106, child := 142, matrix := ![0,5,6,0,10,10,14,15,1], witnesses := [{ source := 0, target := 72, scalar := 6 },{ source := 1, target := 52, scalar := 5 },{ source := 17, target := 0, scalar := 14 },{ source := 34, target := 17, scalar := 3 },{ source := 52, target := 1, scalar := 10 },{ source := 106, target := 34, scalar := 1 },{ source := 121, target := 94, scalar := 8 }] }
theorem rowR6_0020_000_18_valid : (rowR6_0020_000_18).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_19 : ExtensionRow := { move := 107, child := 408, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 107, target := 107, scalar := 1 },{ source := 121, target := 121, scalar := 1 }] }
theorem rowR6_0020_000_19_valid : (rowR6_0020_000_19).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_20 : ExtensionRow := { move := 108, child := 419, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 108, target := 108, scalar := 1 },{ source := 121, target := 121, scalar := 1 }] }
theorem rowR6_0020_000_20_valid : (rowR6_0020_000_20).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_21 : ExtensionRow := { move := 112, child := 134, matrix := ![1,2,3,1,4,5,1,6,10], witnesses := [{ source := 0, target := 71, scalar := 3 },{ source := 1, target := 52, scalar := 2 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 13 },{ source := 52, target := 1, scalar := 6 },{ source := 112, target := 17, scalar := 9 },{ source := 121, target := 267, scalar := 6 }] }
theorem rowR6_0020_000_21_valid : (rowR6_0020_000_21).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_22 : ExtensionRow := { move := 131, child := 97, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 121, target := 168, scalar := 1 },{ source := 131, target := 71, scalar := 1 }] }
theorem rowR6_0020_000_22_valid : (rowR6_0020_000_22).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_23 : ExtensionRow := { move := 133, child := 144, matrix := ![6,7,0,13,9,5,7,6,0], witnesses := [{ source := 0, target := 1, scalar := 5 },{ source := 1, target := 72, scalar := 7 },{ source := 17, target := 103, scalar := 6 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 8 },{ source := 121, target := 17, scalar := 7 },{ source := 133, target := 0, scalar := 6 }] }
theorem rowR6_0020_000_23_valid : (rowR6_0020_000_23).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_24 : ExtensionRow := { move := 135, child := 431, matrix := ![15,6,1,0,13,1,0,8,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 110, scalar := 6 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 159, scalar := 8 },{ source := 52, target := 1, scalar := 10 },{ source := 121, target := 0, scalar := 13 },{ source := 135, target := 52, scalar := 8 }] }
theorem rowR6_0020_000_24_valid : (rowR6_0020_000_24).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_25 : ExtensionRow := { move := 138, child := 434, matrix := ![1,8,9,0,3,3,0,11,10], witnesses := [{ source := 0, target := 120, scalar := 9 },{ source := 1, target := 52, scalar := 8 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 139, scalar := 10 },{ source := 121, target := 1, scalar := 1 },{ source := 138, target := 34, scalar := 1 }] }
theorem rowR6_0020_000_25_valid : (rowR6_0020_000_25).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_26 : ExtensionRow := { move := 139, child := 291, matrix := ![15,0,5,2,0,2,7,14,9], witnesses := [{ source := 0, target := 109, scalar := 5 },{ source := 1, target := 0, scalar := 14 },{ source := 17, target := 78, scalar := 15 },{ source := 34, target := 17, scalar := 10 },{ source := 52, target := 1, scalar := 4 },{ source := 121, target := 34, scalar := 1 },{ source := 139, target := 52, scalar := 11 }] }
theorem rowR6_0020_000_26_valid : (rowR6_0020_000_26).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_27 : ExtensionRow := { move := 141, child := 422, matrix := ![0,14,1,5,3,1,0,8,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 108, scalar := 14 },{ source := 17, target := 1, scalar := 5 },{ source := 34, target := 229, scalar := 15 },{ source := 52, target := 17, scalar := 12 },{ source := 121, target := 52, scalar := 10 },{ source := 141, target := 0, scalar := 1 }] }
theorem rowR6_0020_000_27_valid : (rowR6_0020_000_27).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_28 : ExtensionRow := { move := 144, child := 411, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 121, target := 156, scalar := 14 },{ source := 144, target := 107, scalar := 8 }] }
theorem rowR6_0020_000_28_valid : (rowR6_0020_000_28).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_29 : ExtensionRow := { move := 149, child := 188, matrix := ![3,6,5,0,10,10,0,1,15], witnesses := [{ source := 0, target := 52, scalar := 5 },{ source := 1, target := 72, scalar := 6 },{ source := 17, target := 17, scalar := 3 },{ source := 34, target := 0, scalar := 14 },{ source := 52, target := 1, scalar := 10 },{ source := 121, target := 243, scalar := 10 },{ source := 149, target := 34, scalar := 1 }] }
theorem rowR6_0020_000_29_valid : (rowR6_0020_000_29).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_30 : ExtensionRow := { move := 150, child := 159, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 121, target := 156, scalar := 14 },{ source := 150, target := 72, scalar := 13 }] }
theorem rowR6_0020_000_30_valid : (rowR6_0020_000_30).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_31 : ExtensionRow := { move := 151, child := 242, matrix := ![6,0,1,14,1,1,8,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 222, scalar := 6 },{ source := 34, target := 52, scalar := 7 },{ source := 52, target := 74, scalar := 5 },{ source := 121, target := 17, scalar := 14 },{ source := 151, target := 0, scalar := 14 }] }
theorem rowR6_0020_000_31_valid : (rowR6_0020_000_31).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_32 : ExtensionRow := { move := 152, child := 237, matrix := ![12,0,8,7,0,7,6,5,3], witnesses := [{ source := 0, target := 195, scalar := 8 },{ source := 1, target := 0, scalar := 5 },{ source := 17, target := 74, scalar := 12 },{ source := 34, target := 17, scalar := 4 },{ source := 52, target := 52, scalar := 7 },{ source := 121, target := 1, scalar := 10 },{ source := 152, target := 34, scalar := 1 }] }
theorem rowR6_0020_000_32_valid : (rowR6_0020_000_32).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_33 : ExtensionRow := { move := 156, child := 175, matrix := ![5,1,12,1,1,11,11,1,7], witnesses := [{ source := 0, target := 52, scalar := 12 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 202, scalar := 5 },{ source := 34, target := 72, scalar := 8 },{ source := 52, target := 1, scalar := 13 },{ source := 121, target := 17, scalar := 9 },{ source := 156, target := 0, scalar := 7 }] }
theorem rowR6_0020_000_33_valid : (rowR6_0020_000_33).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_34 : ExtensionRow := { move := 158, child := 436, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 121, target := 121, scalar := 1 },{ source := 158, target := 158, scalar := 1 }] }
theorem rowR6_0020_000_34_valid : (rowR6_0020_000_34).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_35 : ExtensionRow := { move := 159, child := 437, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 121, target := 121, scalar := 1 },{ source := 159, target := 159, scalar := 1 }] }
theorem rowR6_0020_000_35_valid : (rowR6_0020_000_35).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_36 : ExtensionRow := { move := 163, child := 209, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 121, target := 168, scalar := 1 },{ source := 163, target := 73, scalar := 1 }] }
theorem rowR6_0020_000_36_valid : (rowR6_0020_000_36).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_37 : ExtensionRow := { move := 166, child := 114, matrix := ![3,0,1,5,0,1,10,13,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 0, scalar := 13 },{ source := 17, target := 71, scalar := 3 },{ source := 34, target := 52, scalar := 2 },{ source := 52, target := 1, scalar := 6 },{ source := 121, target := 213, scalar := 11 },{ source := 166, target := 17, scalar := 6 }] }
theorem rowR6_0020_000_37_valid : (rowR6_0020_000_37).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_38 : ExtensionRow := { move := 167, child := 139, matrix := ![7,14,9,9,13,0,6,6,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 91, scalar := 14 },{ source := 17, target := 72, scalar := 7 },{ source := 34, target := 1, scalar := 4 },{ source := 52, target := 0, scalar := 10 },{ source := 121, target := 34, scalar := 1 },{ source := 167, target := 52, scalar := 3 }] }
theorem rowR6_0020_000_38_valid : (rowR6_0020_000_38).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_39 : ExtensionRow := { move := 168, child := 94, matrix := ![14,0,5,0,0,14,0,3,12], witnesses := [{ source := 0, target := 158, scalar := 5 },{ source := 1, target := 0, scalar := 3 },{ source := 17, target := 17, scalar := 14 },{ source := 34, target := 71, scalar := 11 },{ source := 52, target := 34, scalar := 1 },{ source := 121, target := 1, scalar := 9 },{ source := 168, target := 52, scalar := 6 }] }
theorem rowR6_0020_000_39_valid : (rowR6_0020_000_39).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_40 : ExtensionRow := { move := 172, child := 368, matrix := ![13,12,1,0,5,1,0,1,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 91, scalar := 12 },{ source := 17, target := 17, scalar := 13 },{ source := 34, target := 1, scalar := 4 },{ source := 52, target := 220, scalar := 5 },{ source := 121, target := 52, scalar := 11 },{ source := 172, target := 0, scalar := 2 }] }
theorem rowR6_0020_000_40_valid : (rowR6_0020_000_40).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_41 : ExtensionRow := { move := 174, child := 164, matrix := ![0,9,1,0,1,1,9,8,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 52, scalar := 9 },{ source := 17, target := 0, scalar := 9 },{ source := 34, target := 17, scalar := 8 },{ source := 52, target := 174, scalar := 2 },{ source := 121, target := 72, scalar := 11 },{ source := 174, target := 1, scalar := 4 }] }
theorem rowR6_0020_000_41_valid : (rowR6_0020_000_41).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_42 : ExtensionRow := { move := 175, child := 66, matrix := ![1,0,1,1,0,3,1,4,5], witnesses := [{ source := 0, target := 70, scalar := 1 },{ source := 1, target := 0, scalar := 4 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 2 },{ source := 52, target := 52, scalar := 2 },{ source := 121, target := 137, scalar := 9 },{ source := 175, target := 17, scalar := 15 }] }
theorem rowR6_0020_000_42_valid : (rowR6_0020_000_42).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_43 : ExtensionRow := { move := 181, child := 316, matrix := ![6,6,0,10,12,6,8,10,0], witnesses := [{ source := 0, target := 1, scalar := 6 },{ source := 1, target := 52, scalar := 6 },{ source := 17, target := 78, scalar := 6 },{ source := 34, target := 0, scalar := 2 },{ source := 52, target := 233, scalar := 10 },{ source := 121, target := 34, scalar := 1 },{ source := 181, target := 17, scalar := 15 }] }
theorem rowR6_0020_000_43_valid : (rowR6_0020_000_43).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_44 : ExtensionRow := { move := 182, child := 381, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 121, target := 168, scalar := 1 },{ source := 182, target := 92, scalar := 1 }] }
theorem rowR6_0020_000_44_valid : (rowR6_0020_000_44).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_45 : ExtensionRow := { move := 184, child := 29, matrix := ![10,4,15,3,0,2,8,0,9], witnesses := [{ source := 0, target := 69, scalar := 15 },{ source := 1, target := 17, scalar := 4 },{ source := 17, target := 139, scalar := 10 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 1, scalar := 5 },{ source := 121, target := 0, scalar := 12 },{ source := 184, target := 52, scalar := 15 }] }
theorem rowR6_0020_000_45_valid : (rowR6_0020_000_45).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_46 : ExtensionRow := { move := 186, child := 330, matrix := ![8,10,0,11,7,3,9,13,0], witnesses := [{ source := 0, target := 1, scalar := 3 },{ source := 1, target := 52, scalar := 10 },{ source := 17, target := 79, scalar := 8 },{ source := 34, target := 243, scalar := 2 },{ source := 52, target := 17, scalar := 15 },{ source := 121, target := 34, scalar := 1 },{ source := 186, target := 0, scalar := 2 }] }
theorem rowR6_0020_000_46_valid : (rowR6_0020_000_46).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowR6_0020_000_47 : ExtensionRow := { move := 189, child := 42, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 121, target := 186, scalar := 14 },{ source := 189, target := 69, scalar := 6 }] }
theorem rowR6_0020_000_47_valid : (rowR6_0020_000_47).ValidFor level7 {0,1,17,34,52,121} := by decide

noncomputable def rowsR6_0020_000 : List ExtensionRow := [rowR6_0020_000_0,rowR6_0020_000_1,rowR6_0020_000_2,rowR6_0020_000_3,rowR6_0020_000_4,rowR6_0020_000_5,rowR6_0020_000_6,rowR6_0020_000_7,rowR6_0020_000_8,rowR6_0020_000_9,rowR6_0020_000_10,rowR6_0020_000_11,rowR6_0020_000_12,rowR6_0020_000_13,rowR6_0020_000_14,rowR6_0020_000_15,rowR6_0020_000_16,rowR6_0020_000_17,rowR6_0020_000_18,rowR6_0020_000_19,rowR6_0020_000_20,rowR6_0020_000_21,rowR6_0020_000_22,rowR6_0020_000_23,rowR6_0020_000_24,rowR6_0020_000_25,rowR6_0020_000_26,rowR6_0020_000_27,rowR6_0020_000_28,rowR6_0020_000_29,rowR6_0020_000_30,rowR6_0020_000_31,rowR6_0020_000_32,rowR6_0020_000_33,rowR6_0020_000_34,rowR6_0020_000_35,rowR6_0020_000_36,rowR6_0020_000_37,rowR6_0020_000_38,rowR6_0020_000_39,rowR6_0020_000_40,rowR6_0020_000_41,rowR6_0020_000_42,rowR6_0020_000_43,rowR6_0020_000_44,rowR6_0020_000_45,rowR6_0020_000_46,rowR6_0020_000_47]

theorem rowsR6_0020_000_valid : RowListValid level7 {0,1,17,34,52,121} rowsR6_0020_000 := by
  intro r hr
  simp only [rowsR6_0020_000, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR6_0020_000_0_valid
  · exact rowR6_0020_000_1_valid
  · exact rowR6_0020_000_2_valid
  · exact rowR6_0020_000_3_valid
  · exact rowR6_0020_000_4_valid
  · exact rowR6_0020_000_5_valid
  · exact rowR6_0020_000_6_valid
  · exact rowR6_0020_000_7_valid
  · exact rowR6_0020_000_8_valid
  · exact rowR6_0020_000_9_valid
  · exact rowR6_0020_000_10_valid
  · exact rowR6_0020_000_11_valid
  · exact rowR6_0020_000_12_valid
  · exact rowR6_0020_000_13_valid
  · exact rowR6_0020_000_14_valid
  · exact rowR6_0020_000_15_valid
  · exact rowR6_0020_000_16_valid
  · exact rowR6_0020_000_17_valid
  · exact rowR6_0020_000_18_valid
  · exact rowR6_0020_000_19_valid
  · exact rowR6_0020_000_20_valid
  · exact rowR6_0020_000_21_valid
  · exact rowR6_0020_000_22_valid
  · exact rowR6_0020_000_23_valid
  · exact rowR6_0020_000_24_valid
  · exact rowR6_0020_000_25_valid
  · exact rowR6_0020_000_26_valid
  · exact rowR6_0020_000_27_valid
  · exact rowR6_0020_000_28_valid
  · exact rowR6_0020_000_29_valid
  · exact rowR6_0020_000_30_valid
  · exact rowR6_0020_000_31_valid
  · exact rowR6_0020_000_32_valid
  · exact rowR6_0020_000_33_valid
  · exact rowR6_0020_000_34_valid
  · exact rowR6_0020_000_35_valid
  · exact rowR6_0020_000_36_valid
  · exact rowR6_0020_000_37_valid
  · exact rowR6_0020_000_38_valid
  · exact rowR6_0020_000_39_valid
  · exact rowR6_0020_000_40_valid
  · exact rowR6_0020_000_41_valid
  · exact rowR6_0020_000_42_valid
  · exact rowR6_0020_000_43_valid
  · exact rowR6_0020_000_44_valid
  · exact rowR6_0020_000_45_valid
  · exact rowR6_0020_000_46_valid
  · exact rowR6_0020_000_47_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
