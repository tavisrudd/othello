import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR6_0017_000_0 : ExtensionRow := { move := 67, child := 2, matrix := ![1,1,1,3,1,0,2,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 67, scalar := 1 },{ source := 34, target := 52, scalar := 1 },{ source := 52, target := 1, scalar := 1 },{ source := 67, target := 0, scalar := 1 },{ source := 109, target := 92, scalar := 8 }] }
theorem rowR6_0017_000_0_valid : (rowR6_0017_000_0).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_1 : ExtensionRow := { move := 70, child := 19, matrix := ![6,1,13,10,1,12,11,1,7], witnesses := [{ source := 0, target := 112, scalar := 13 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 69, scalar := 6 },{ source := 34, target := 52, scalar := 10 },{ source := 52, target := 1, scalar := 15 },{ source := 70, target := 17, scalar := 9 },{ source := 109, target := 0, scalar := 12 }] }
theorem rowR6_0017_000_1_valid : (rowR6_0017_000_1).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_2 : ExtensionRow := { move := 71, child := 79, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 71, target := 71, scalar := 1 },{ source := 109, target := 109, scalar := 1 }] }
theorem rowR6_0017_000_2_valid : (rowR6_0017_000_2).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_3 : ExtensionRow := { move := 73, child := 65, matrix := ![3,1,0,5,1,0,15,1,8], witnesses := [{ source := 0, target := 0, scalar := 8 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 70, scalar := 3 },{ source := 34, target := 52, scalar := 2 },{ source := 52, target := 135, scalar := 1 },{ source := 73, target := 1, scalar := 6 },{ source := 109, target := 17, scalar := 6 }] }
theorem rowR6_0017_000_3_valid : (rowR6_0017_000_3).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_4 : ExtensionRow := { move := 74, child := 217, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 74, target := 74, scalar := 1 },{ source := 109, target := 109, scalar := 1 }] }
theorem rowR6_0017_000_4_valid : (rowR6_0017_000_4).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_5 : ExtensionRow := { move := 75, child := 135, matrix := ![1,13,9,1,0,14,1,0,12], witnesses := [{ source := 0, target := 268, scalar := 9 },{ source := 1, target := 17, scalar := 13 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 71, scalar := 5 },{ source := 52, target := 0, scalar := 6 },{ source := 75, target := 1, scalar := 7 },{ source := 109, target := 52, scalar := 11 }] }
theorem rowR6_0017_000_5_valid : (rowR6_0017_000_5).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_6 : ExtensionRow := { move := 78, child := 291, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 78, target := 78, scalar := 1 },{ source := 109, target := 109, scalar := 1 }] }
theorem rowR6_0017_000_6_valid : (rowR6_0017_000_6).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_7 : ExtensionRow := { move := 80, child := 327, matrix := ![3,10,9,9,7,0,13,13,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 52, scalar := 10 },{ source := 17, target := 139, scalar := 3 },{ source := 34, target := 1, scalar := 14 },{ source := 52, target := 79, scalar := 12 },{ source := 80, target := 0, scalar := 9 },{ source := 109, target := 34, scalar := 1 }] }
theorem rowR6_0017_000_7_valid : (rowR6_0017_000_7).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_8 : ExtensionRow := { move := 86, child := 56, matrix := ![15,14,0,0,1,0,0,3,2], witnesses := [{ source := 0, target := 0, scalar := 2 },{ source := 1, target := 70, scalar := 14 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 1, scalar := 2 },{ source := 86, target := 52, scalar := 2 },{ source := 109, target := 95, scalar := 12 }] }
theorem rowR6_0017_000_8_valid : (rowR6_0017_000_8).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_9 : ExtensionRow := { move := 90, child := 166, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 90, target := 72, scalar := 13 },{ source := 109, target := 185, scalar := 9 }] }
theorem rowR6_0017_000_9_valid : (rowR6_0017_000_9).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_10 : ExtensionRow := { move := 91, child := 353, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 91, target := 91, scalar := 1 },{ source := 109, target := 109, scalar := 1 }] }
theorem rowR6_0017_000_10_valid : (rowR6_0017_000_10).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_11 : ExtensionRow := { move := 92, child := 376, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 92, target := 92, scalar := 1 },{ source := 109, target := 109, scalar := 1 }] }
theorem rowR6_0017_000_11_valid : (rowR6_0017_000_11).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_12 : ExtensionRow := { move := 94, child := 86, matrix := ![11,4,1,14,15,1,15,14,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 139, scalar := 4 },{ source := 17, target := 71, scalar := 11 },{ source := 34, target := 17, scalar := 14 },{ source := 52, target := 0, scalar := 3 },{ source := 94, target := 52, scalar := 5 },{ source := 109, target := 1, scalar := 4 }] }
theorem rowR6_0017_000_12_valid : (rowR6_0017_000_12).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_13 : ExtensionRow := { move := 95, child := 153, matrix := ![14,7,0,1,0,0,12,0,4], witnesses := [{ source := 0, target := 0, scalar := 4 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 72, scalar := 14 },{ source := 34, target := 52, scalar := 9 },{ source := 52, target := 1, scalar := 1 },{ source := 95, target := 34, scalar := 1 },{ source := 109, target := 139, scalar := 6 }] }
theorem rowR6_0017_000_13_valid : (rowR6_0017_000_13).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_14 : ExtensionRow := { move := 96, child := 100, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 96, target := 71, scalar := 11 },{ source := 109, target := 172, scalar := 9 }] }
theorem rowR6_0017_000_14_valid : (rowR6_0017_000_14).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_15 : ExtensionRow := { move := 115, child := 184, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 109, target := 229, scalar := 1 },{ source := 115, target := 72, scalar := 1 }] }
theorem rowR6_0017_000_15_valid : (rowR6_0017_000_15).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_16 : ExtensionRow := { move := 117, child := 80, matrix := ![10,7,13,4,0,4,11,0,8], witnesses := [{ source := 0, target := 71, scalar := 13 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 110, scalar := 10 },{ source := 34, target := 0, scalar := 3 },{ source := 52, target := 1, scalar := 8 },{ source := 109, target := 34, scalar := 1 },{ source := 117, target := 52, scalar := 10 }] }
theorem rowR6_0017_000_16_valid : (rowR6_0017_000_16).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_17 : ExtensionRow := { move := 120, child := 298, matrix := ![5,11,14,14,14,0,13,6,0], witnesses := [{ source := 0, target := 17, scalar := 14 },{ source := 1, target := 78, scalar := 11 },{ source := 17, target := 151, scalar := 5 },{ source := 34, target := 0, scalar := 11 },{ source := 52, target := 34, scalar := 1 },{ source := 109, target := 1, scalar := 13 },{ source := 120, target := 52, scalar := 6 }] }
theorem rowR6_0017_000_17_valid : (rowR6_0017_000_17).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_18 : ExtensionRow := { move := 122, child := 425, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 109, target := 109, scalar := 1 },{ source := 122, target := 122, scalar := 1 }] }
theorem rowR6_0017_000_18_valid : (rowR6_0017_000_18).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_19 : ExtensionRow := { move := 124, child := 410, matrix := ![0,0,1,0,4,1,11,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 1, scalar := 4 },{ source := 17, target := 0, scalar := 11 },{ source := 34, target := 107, scalar := 1 },{ source := 52, target := 154, scalar := 3 },{ source := 109, target := 52, scalar := 12 },{ source := 124, target := 17, scalar := 11 }] }
theorem rowR6_0017_000_19_valid : (rowR6_0017_000_19).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_20 : ExtensionRow := { move := 127, child := 384, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 109, target := 185, scalar := 9 },{ source := 127, target := 92, scalar := 8 }] }
theorem rowR6_0017_000_20_valid : (rowR6_0017_000_20).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_21 : ExtensionRow := { move := 128, child := 349, matrix := ![0,8,1,5,3,1,0,11,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 52, scalar := 8 },{ source := 17, target := 1, scalar := 5 },{ source := 34, target := 248, scalar := 9 },{ source := 52, target := 0, scalar := 6 },{ source := 109, target := 80, scalar := 2 },{ source := 128, target := 17, scalar := 10 }] }
theorem rowR6_0017_000_21_valid : (rowR6_0017_000_21).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_22 : ExtensionRow := { move := 131, child := 81, matrix := ![2,10,9,6,7,0,12,13,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 52, scalar := 10 },{ source := 17, target := 71, scalar := 2 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 120, scalar := 13 },{ source := 109, target := 1, scalar := 14 },{ source := 131, target := 0, scalar := 9 }] }
theorem rowR6_0017_000_22_valid : (rowR6_0017_000_22).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_23 : ExtensionRow := { move := 135, child := 410, matrix := ![10,9,0,0,11,0,0,5,13], witnesses := [{ source := 0, target := 0, scalar := 13 },{ source := 1, target := 107, scalar := 9 },{ source := 17, target := 17, scalar := 10 },{ source := 34, target := 154, scalar := 3 },{ source := 52, target := 52, scalar := 11 },{ source := 109, target := 34, scalar := 1 },{ source := 135, target := 1, scalar := 4 }] }
theorem rowR6_0017_000_23_valid : (rowR6_0017_000_23).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_24 : ExtensionRow := { move := 137, child := 357, matrix := ![0,0,1,5,0,4,0,11,10], witnesses := [{ source := 0, target := 91, scalar := 1 },{ source := 1, target := 0, scalar := 11 },{ source := 17, target := 1, scalar := 5 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 138, scalar := 3 },{ source := 109, target := 17, scalar := 12 },{ source := 137, target := 52, scalar := 8 }] }
theorem rowR6_0017_000_24_valid : (rowR6_0017_000_24).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_25 : ExtensionRow := { move := 138, child := 108, matrix := ![10,3,4,7,0,12,13,0,11], witnesses := [{ source := 0, target := 71, scalar := 4 },{ source := 1, target := 17, scalar := 3 },{ source := 17, target := 52, scalar := 10 },{ source := 34, target := 188, scalar := 13 },{ source := 52, target := 0, scalar := 3 },{ source := 109, target := 1, scalar := 8 },{ source := 138, target := 34, scalar := 1 }] }
theorem rowR6_0017_000_25_valid : (rowR6_0017_000_25).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_26 : ExtensionRow := { move := 139, child := 228, matrix := ![0,14,15,0,1,0,6,7,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 74, scalar := 14 },{ source := 17, target := 0, scalar := 6 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 151, scalar := 13 },{ source := 109, target := 52, scalar := 11 },{ source := 139, target := 1, scalar := 7 }] }
theorem rowR6_0017_000_26_valid : (rowR6_0017_000_26).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_27 : ExtensionRow := { move := 140, child := 218, matrix := ![0,4,3,14,0,6,0,0,5], witnesses := [{ source := 0, target := 52, scalar := 3 },{ source := 1, target := 17, scalar := 4 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 110, scalar := 7 },{ source := 52, target := 74, scalar := 13 },{ source := 109, target := 0, scalar := 9 },{ source := 140, target := 34, scalar := 1 }] }
theorem rowR6_0017_000_27_valid : (rowR6_0017_000_27).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_28 : ExtensionRow := { move := 143, child := 423, matrix := ![5,1,0,2,1,3,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 3 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 108, scalar := 5 },{ source := 34, target := 17, scalar := 4 },{ source := 52, target := 235, scalar := 7 },{ source := 109, target := 0, scalar := 4 },{ source := 143, target := 52, scalar := 2 }] }
theorem rowR6_0017_000_28_valid : (rowR6_0017_000_28).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_29 : ExtensionRow := { move := 144, child := 245, matrix := ![10,9,0,7,8,15,13,13,0], witnesses := [{ source := 0, target := 1, scalar := 15 },{ source := 1, target := 74, scalar := 9 },{ source := 17, target := 52, scalar := 10 },{ source := 34, target := 17, scalar := 3 },{ source := 52, target := 232, scalar := 11 },{ source := 109, target := 34, scalar := 1 },{ source := 144, target := 0, scalar := 8 }] }
theorem rowR6_0017_000_29_valid : (rowR6_0017_000_29).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_30 : ExtensionRow := { move := 149, child := 185, matrix := ![3,6,5,0,10,10,0,1,15], witnesses := [{ source := 0, target := 52, scalar := 5 },{ source := 1, target := 72, scalar := 6 },{ source := 17, target := 17, scalar := 3 },{ source := 34, target := 0, scalar := 14 },{ source := 52, target := 1, scalar := 10 },{ source := 109, target := 233, scalar := 7 },{ source := 149, target := 34, scalar := 1 }] }
theorem rowR6_0017_000_30_valid : (rowR6_0017_000_30).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_31 : ExtensionRow := { move := 150, child := 163, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 109, target := 172, scalar := 9 },{ source := 150, target := 72, scalar := 13 }] }
theorem rowR6_0017_000_31_valid : (rowR6_0017_000_31).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_32 : ExtensionRow := { move := 152, child := 332, matrix := ![13,5,12,9,0,5,4,0,13], witnesses := [{ source := 0, target := 92, scalar := 12 },{ source := 1, target := 17, scalar := 5 },{ source := 17, target := 52, scalar := 13 },{ source := 34, target := 80, scalar := 4 },{ source := 52, target := 1, scalar := 6 },{ source := 109, target := 0, scalar := 7 },{ source := 152, target := 34, scalar := 1 }] }
theorem rowR6_0017_000_32_valid : (rowR6_0017_000_32).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_33 : ExtensionRow := { move := 154, child := 424, matrix := ![0,0,1,0,1,1,1,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 256, scalar := 3 },{ source := 109, target := 108, scalar := 12 },{ source := 154, target := 52, scalar := 9 }] }
theorem rowR6_0017_000_33_valid : (rowR6_0017_000_33).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_34 : ExtensionRow := { move := 155, child := 243, matrix := ![13,11,1,4,5,1,15,14,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 52, scalar := 11 },{ source := 17, target := 74, scalar := 13 },{ source := 34, target := 17, scalar := 7 },{ source := 52, target := 224, scalar := 11 },{ source := 109, target := 1, scalar := 10 },{ source := 155, target := 0, scalar := 12 }] }
theorem rowR6_0017_000_34_valid : (rowR6_0017_000_34).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_35 : ExtensionRow := { move := 156, child := 368, matrix := ![12,13,0,5,0,4,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 4 },{ source := 1, target := 17, scalar := 13 },{ source := 17, target := 91, scalar := 12 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 220, scalar := 5 },{ source := 109, target := 0, scalar := 1 },{ source := 156, target := 52, scalar := 14 }] }
theorem rowR6_0017_000_35_valid : (rowR6_0017_000_35).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_36 : ExtensionRow := { move := 159, child := 394, matrix := ![14,12,3,13,10,6,10,14,5], witnesses := [{ source := 0, target := 52, scalar := 3 },{ source := 1, target := 151, scalar := 12 },{ source := 17, target := 94, scalar := 14 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 0, scalar := 10 },{ source := 109, target := 1, scalar := 7 },{ source := 159, target := 17, scalar := 5 }] }
theorem rowR6_0017_000_36_valid : (rowR6_0017_000_36).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_37 : ExtensionRow := { move := 163, child := 192, matrix := ![8,0,9,1,0,0,15,14,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 0, scalar := 14 },{ source := 17, target := 267, scalar := 8 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 1, scalar := 1 },{ source := 109, target := 72, scalar := 14 },{ source := 163, target := 52, scalar := 9 }] }
theorem rowR6_0017_000_37_valid : (rowR6_0017_000_37).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_38 : ExtensionRow := { move := 166, child := 75, matrix := ![9,1,0,2,1,0,14,1,4], witnesses := [{ source := 0, target := 0, scalar := 4 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 96, scalar := 9 },{ source := 34, target := 52, scalar := 8 },{ source := 52, target := 17, scalar := 11 },{ source := 109, target := 71, scalar := 12 },{ source := 166, target := 1, scalar := 11 }] }
theorem rowR6_0017_000_38_valid : (rowR6_0017_000_38).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_39 : ExtensionRow := { move := 167, child := 105, matrix := ![15,0,11,0,0,14,0,8,15], witnesses := [{ source := 0, target := 71, scalar := 11 },{ source := 1, target := 0, scalar := 8 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 182, scalar := 4 },{ source := 52, target := 34, scalar := 1 },{ source := 109, target := 52, scalar := 2 },{ source := 167, target := 1, scalar := 2 }] }
theorem rowR6_0017_000_39_valid : (rowR6_0017_000_39).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_40 : ExtensionRow := { move := 168, child := 350, matrix := ![9,0,5,0,7,15,0,0,6], witnesses := [{ source := 0, target := 80, scalar := 5 },{ source := 1, target := 1, scalar := 7 },{ source := 17, target := 17, scalar := 9 },{ source := 34, target := 266, scalar := 12 },{ source := 52, target := 52, scalar := 6 },{ source := 109, target := 0, scalar := 14 },{ source := 168, target := 34, scalar := 1 }] }
theorem rowR6_0017_000_40_valid : (rowR6_0017_000_40).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_41 : ExtensionRow := { move := 171, child := 359, matrix := ![14,1,2,0,1,4,0,1,6], witnesses := [{ source := 0, target := 52, scalar := 2 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 17, scalar := 14 },{ source := 34, target := 144, scalar := 13 },{ source := 52, target := 91, scalar := 10 },{ source := 109, target := 0, scalar := 11 },{ source := 171, target := 1, scalar := 7 }] }
theorem rowR6_0017_000_41_valid : (rowR6_0017_000_41).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_42 : ExtensionRow := { move := 172, child := 256, matrix := ![5,11,14,15,15,0,4,10,0], witnesses := [{ source := 0, target := 17, scalar := 14 },{ source := 1, target := 117, scalar := 11 },{ source := 17, target := 75, scalar := 5 },{ source := 34, target := 0, scalar := 14 },{ source := 52, target := 52, scalar := 1 },{ source := 109, target := 1, scalar := 9 },{ source := 172, target := 34, scalar := 1 }] }
theorem rowR6_0017_000_42_valid : (rowR6_0017_000_42).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_43 : ExtensionRow := { move := 174, child := 325, matrix := ![1,1,0,1,2,0,1,3,2], witnesses := [{ source := 0, target := 0, scalar := 2 },{ source := 1, target := 52, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 3 },{ source := 52, target := 79, scalar := 3 },{ source := 109, target := 125, scalar := 4 },{ source := 174, target := 17, scalar := 8 }] }
theorem rowR6_0017_000_43_valid : (rowR6_0017_000_43).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_44 : ExtensionRow := { move := 175, child := 65, matrix := ![15,15,0,0,2,0,0,6,6], witnesses := [{ source := 0, target := 0, scalar := 6 },{ source := 1, target := 70, scalar := 15 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 1, scalar := 2 },{ source := 52, target := 52, scalar := 2 },{ source := 109, target := 135, scalar := 9 },{ source := 175, target := 34, scalar := 1 }] }
theorem rowR6_0017_000_44_valid : (rowR6_0017_000_44).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_45 : ExtensionRow := { move := 181, child := 422, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 109, target := 229, scalar := 1 },{ source := 181, target := 108, scalar := 1 }] }
theorem rowR6_0017_000_45_valid : (rowR6_0017_000_45).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_46 : ExtensionRow := { move := 183, child := 231, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 109, target := 172, scalar := 9 },{ source := 183, target := 74, scalar := 12 }] }
theorem rowR6_0017_000_46_valid : (rowR6_0017_000_46).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowR6_0017_000_47 : ExtensionRow := { move := 184, child := 280, matrix := ![11,6,12,14,12,3,2,10,9], witnesses := [{ source := 0, target := 230, scalar := 12 },{ source := 1, target := 52, scalar := 6 },{ source := 17, target := 75, scalar := 11 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 0, scalar := 13 },{ source := 109, target := 17, scalar := 9 },{ source := 184, target := 1, scalar := 6 }] }
theorem rowR6_0017_000_47_valid : (rowR6_0017_000_47).ValidFor level7 {0,1,17,34,52,109} := by decide

noncomputable def rowsR6_0017_000 : List ExtensionRow := [rowR6_0017_000_0,rowR6_0017_000_1,rowR6_0017_000_2,rowR6_0017_000_3,rowR6_0017_000_4,rowR6_0017_000_5,rowR6_0017_000_6,rowR6_0017_000_7,rowR6_0017_000_8,rowR6_0017_000_9,rowR6_0017_000_10,rowR6_0017_000_11,rowR6_0017_000_12,rowR6_0017_000_13,rowR6_0017_000_14,rowR6_0017_000_15,rowR6_0017_000_16,rowR6_0017_000_17,rowR6_0017_000_18,rowR6_0017_000_19,rowR6_0017_000_20,rowR6_0017_000_21,rowR6_0017_000_22,rowR6_0017_000_23,rowR6_0017_000_24,rowR6_0017_000_25,rowR6_0017_000_26,rowR6_0017_000_27,rowR6_0017_000_28,rowR6_0017_000_29,rowR6_0017_000_30,rowR6_0017_000_31,rowR6_0017_000_32,rowR6_0017_000_33,rowR6_0017_000_34,rowR6_0017_000_35,rowR6_0017_000_36,rowR6_0017_000_37,rowR6_0017_000_38,rowR6_0017_000_39,rowR6_0017_000_40,rowR6_0017_000_41,rowR6_0017_000_42,rowR6_0017_000_43,rowR6_0017_000_44,rowR6_0017_000_45,rowR6_0017_000_46,rowR6_0017_000_47]

theorem rowsR6_0017_000_valid : RowListValid level7 {0,1,17,34,52,109} rowsR6_0017_000 := by
  intro r hr
  simp only [rowsR6_0017_000, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR6_0017_000_0_valid
  · exact rowR6_0017_000_1_valid
  · exact rowR6_0017_000_2_valid
  · exact rowR6_0017_000_3_valid
  · exact rowR6_0017_000_4_valid
  · exact rowR6_0017_000_5_valid
  · exact rowR6_0017_000_6_valid
  · exact rowR6_0017_000_7_valid
  · exact rowR6_0017_000_8_valid
  · exact rowR6_0017_000_9_valid
  · exact rowR6_0017_000_10_valid
  · exact rowR6_0017_000_11_valid
  · exact rowR6_0017_000_12_valid
  · exact rowR6_0017_000_13_valid
  · exact rowR6_0017_000_14_valid
  · exact rowR6_0017_000_15_valid
  · exact rowR6_0017_000_16_valid
  · exact rowR6_0017_000_17_valid
  · exact rowR6_0017_000_18_valid
  · exact rowR6_0017_000_19_valid
  · exact rowR6_0017_000_20_valid
  · exact rowR6_0017_000_21_valid
  · exact rowR6_0017_000_22_valid
  · exact rowR6_0017_000_23_valid
  · exact rowR6_0017_000_24_valid
  · exact rowR6_0017_000_25_valid
  · exact rowR6_0017_000_26_valid
  · exact rowR6_0017_000_27_valid
  · exact rowR6_0017_000_28_valid
  · exact rowR6_0017_000_29_valid
  · exact rowR6_0017_000_30_valid
  · exact rowR6_0017_000_31_valid
  · exact rowR6_0017_000_32_valid
  · exact rowR6_0017_000_33_valid
  · exact rowR6_0017_000_34_valid
  · exact rowR6_0017_000_35_valid
  · exact rowR6_0017_000_36_valid
  · exact rowR6_0017_000_37_valid
  · exact rowR6_0017_000_38_valid
  · exact rowR6_0017_000_39_valid
  · exact rowR6_0017_000_40_valid
  · exact rowR6_0017_000_41_valid
  · exact rowR6_0017_000_42_valid
  · exact rowR6_0017_000_43_valid
  · exact rowR6_0017_000_44_valid
  · exact rowR6_0017_000_45_valid
  · exact rowR6_0017_000_46_valid
  · exact rowR6_0017_000_47_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
