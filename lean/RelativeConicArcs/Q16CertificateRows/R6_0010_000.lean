import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR6_0010_000_0 : ExtensionRow := { move := 83, child := 60, matrix := ![10,11,0,0,14,15,0,1,0], witnesses := [{ source := 0, target := 1, scalar := 15 },{ source := 1, target := 70, scalar := 11 },{ source := 17, target := 17, scalar := 10 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 15 },{ source := 80, target := 117, scalar := 4 },{ source := 83, target := 0, scalar := 4 }] }
theorem rowR6_0010_000_0_valid : (rowR6_0010_000_0).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_1 : ExtensionRow := { move := 86, child := 16, matrix := ![14,1,2,15,1,10,1,1,1], witnesses := [{ source := 0, target := 106, scalar := 2 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 69, scalar := 13 },{ source := 52, target := 17, scalar := 10 },{ source := 80, target := 0, scalar := 13 },{ source := 86, target := 1, scalar := 15 }] }
theorem rowR6_0010_000_1_valid : (rowR6_0010_000_1).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_2 : ExtensionRow := { move := 89, child := 85, matrix := ![14,7,0,15,0,5,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 5 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 131, scalar := 9 },{ source := 52, target := 0, scalar := 1 },{ source := 80, target := 71, scalar := 7 },{ source := 89, target := 34, scalar := 1 }] }
theorem rowR6_0010_000_2_valid : (rowR6_0010_000_2).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_3 : ExtensionRow := { move := 91, child := 331, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 80, target := 80, scalar := 1 },{ source := 91, target := 91, scalar := 1 }] }
theorem rowR6_0010_000_3_valid : (rowR6_0010_000_3).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_4 : ExtensionRow := { move := 92, child := 332, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 80, target := 80, scalar := 1 },{ source := 92, target := 92, scalar := 1 }] }
theorem rowR6_0010_000_4_valid : (rowR6_0010_000_4).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_5 : ExtensionRow := { move := 93, child := 333, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 80, target := 80, scalar := 1 },{ source := 93, target := 93, scalar := 1 }] }
theorem rowR6_0010_000_5_valid : (rowR6_0010_000_5).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_6 : ExtensionRow := { move := 95, child := 150, matrix := ![14,7,0,1,0,0,12,0,4], witnesses := [{ source := 0, target := 0, scalar := 4 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 72, scalar := 14 },{ source := 34, target := 52, scalar := 9 },{ source := 52, target := 1, scalar := 1 },{ source := 80, target := 126, scalar := 7 },{ source := 95, target := 34, scalar := 1 }] }
theorem rowR6_0010_000_6_valid : (rowR6_0010_000_6).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_7 : ExtensionRow := { move := 101, child := 219, matrix := ![1,13,14,1,8,15,1,1,1], witnesses := [{ source := 0, target := 52, scalar := 14 },{ source := 1, target := 117, scalar := 13 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 74, scalar := 2 },{ source := 52, target := 17, scalar := 9 },{ source := 80, target := 0, scalar := 13 },{ source := 101, target := 1, scalar := 6 }] }
theorem rowR6_0010_000_7_valid : (rowR6_0010_000_7).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_8 : ExtensionRow := { move := 103, child := 197, matrix := ![1,11,0,1,5,9,1,14,0], witnesses := [{ source := 0, target := 1, scalar := 9 },{ source := 1, target := 52, scalar := 11 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 73, scalar := 10 },{ source := 52, target := 91, scalar := 4 },{ source := 80, target := 17, scalar := 15 },{ source := 103, target := 0, scalar := 2 }] }
theorem rowR6_0010_000_8_valid : (rowR6_0010_000_8).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_9 : ExtensionRow := { move := 104, child := 10, matrix := ![1,4,7,1,8,15,1,12,5], witnesses := [{ source := 0, target := 94, scalar := 7 },{ source := 1, target := 52, scalar := 4 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 69, scalar := 2 },{ source := 52, target := 0, scalar := 5 },{ source := 80, target := 17, scalar := 6 },{ source := 104, target := 1, scalar := 4 }] }
theorem rowR6_0010_000_9_valid : (rowR6_0010_000_9).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_10 : ExtensionRow := { move := 106, child := 135, matrix := ![14,0,15,1,10,10,2,0,3], witnesses := [{ source := 0, target := 268, scalar := 15 },{ source := 1, target := 1, scalar := 10 },{ source := 17, target := 71, scalar := 14 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 12 },{ source := 80, target := 17, scalar := 4 },{ source := 106, target := 0, scalar := 10 }] }
theorem rowR6_0010_000_10_valid : (rowR6_0010_000_10).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_11 : ExtensionRow := { move := 107, child := 334, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 80, target := 80, scalar := 1 },{ source := 107, target := 107, scalar := 1 }] }
theorem rowR6_0010_000_11_valid : (rowR6_0010_000_11).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_12 : ExtensionRow := { move := 108, child := 301, matrix := ![0,3,3,0,11,0,13,13,0], witnesses := [{ source := 0, target := 17, scalar := 3 },{ source := 1, target := 155, scalar := 3 },{ source := 17, target := 0, scalar := 13 },{ source := 34, target := 1, scalar := 11 },{ source := 52, target := 78, scalar := 3 },{ source := 80, target := 52, scalar := 7 },{ source := 108, target := 34, scalar := 1 }] }
theorem rowR6_0010_000_12_valid : (rowR6_0010_000_12).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_13 : ExtensionRow := { move := 109, child := 327, matrix := ![3,10,9,9,7,0,13,13,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 52, scalar := 10 },{ source := 17, target := 139, scalar := 3 },{ source := 34, target := 1, scalar := 14 },{ source := 52, target := 79, scalar := 12 },{ source := 80, target := 0, scalar := 9 },{ source := 109, target := 34, scalar := 1 }] }
theorem rowR6_0010_000_13_valid : (rowR6_0010_000_13).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_14 : ExtensionRow := { move := 110, child := 335, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 80, target := 80, scalar := 1 },{ source := 110, target := 110, scalar := 1 }] }
theorem rowR6_0010_000_14_valid : (rowR6_0010_000_14).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_15 : ExtensionRow := { move := 115, child := 188, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 80, target := 243, scalar := 1 },{ source := 115, target := 72, scalar := 1 }] }
theorem rowR6_0010_000_15_valid : (rowR6_0010_000_15).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_16 : ExtensionRow := { move := 117, child := 89, matrix := ![1,3,6,1,11,10,1,6,7], witnesses := [{ source := 0, target := 71, scalar := 6 },{ source := 1, target := 147, scalar := 3 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 4 },{ source := 52, target := 52, scalar := 13 },{ source := 80, target := 1, scalar := 3 },{ source := 117, target := 0, scalar := 9 }] }
theorem rowR6_0010_000_16_valid : (rowR6_0010_000_16).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_17 : ExtensionRow := { move := 121, child := 336, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 80, target := 80, scalar := 1 },{ source := 121, target := 121, scalar := 1 }] }
theorem rowR6_0010_000_17_valid : (rowR6_0010_000_17).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_18 : ExtensionRow := { move := 122, child := 274, matrix := ![15,11,0,0,5,9,0,14,0], witnesses := [{ source := 0, target := 1, scalar := 9 },{ source := 1, target := 52, scalar := 11 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 75, scalar := 4 },{ source := 52, target := 201, scalar := 10 },{ source := 80, target := 34, scalar := 1 },{ source := 122, target := 0, scalar := 2 }] }
theorem rowR6_0010_000_18_valid : (rowR6_0010_000_18).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_19 : ExtensionRow := { move := 124, child := 225, matrix := ![7,0,13,6,5,4,2,0,15], witnesses := [{ source := 0, target := 74, scalar := 13 },{ source := 1, target := 1, scalar := 5 },{ source := 17, target := 141, scalar := 7 },{ source := 34, target := 52, scalar := 10 },{ source := 52, target := 17, scalar := 3 },{ source := 80, target := 0, scalar := 8 },{ source := 124, target := 34, scalar := 1 }] }
theorem rowR6_0010_000_19_valid : (rowR6_0010_000_19).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_20 : ExtensionRow := { move := 125, child := 337, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 80, target := 125, scalar := 12 },{ source := 125, target := 80, scalar := 10 }] }
theorem rowR6_0010_000_20_valid : (rowR6_0010_000_20).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_21 : ExtensionRow := { move := 127, child := 26, matrix := ![0,9,0,0,10,2,3,1,0], witnesses := [{ source := 0, target := 1, scalar := 2 },{ source := 1, target := 131, scalar := 9 },{ source := 17, target := 0, scalar := 3 },{ source := 34, target := 69, scalar := 9 },{ source := 52, target := 34, scalar := 1 },{ source := 80, target := 17, scalar := 8 },{ source := 127, target := 52, scalar := 3 }] }
theorem rowR6_0010_000_21_valid : (rowR6_0010_000_21).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_22 : ExtensionRow := { move := 131, child := 128, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 80, target := 243, scalar := 1 },{ source := 131, target := 71, scalar := 1 }] }
theorem rowR6_0010_000_22_valid : (rowR6_0010_000_22).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_23 : ExtensionRow := { move := 133, child := 214, matrix := ![1,7,5,1,8,15,1,15,11], witnesses := [{ source := 0, target := 74, scalar := 5 },{ source := 1, target := 101, scalar := 7 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 52, scalar := 3 },{ source := 52, target := 0, scalar := 2 },{ source := 80, target := 17, scalar := 14 },{ source := 133, target := 1, scalar := 5 }] }
theorem rowR6_0010_000_23_valid : (rowR6_0010_000_23).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_24 : ExtensionRow := { move := 135, child := 336, matrix := ![0,2,13,4,4,4,0,6,7], witnesses := [{ source := 0, target := 80, scalar := 13 },{ source := 1, target := 52, scalar := 2 },{ source := 17, target := 1, scalar := 4 },{ source := 34, target := 121, scalar := 15 },{ source := 52, target := 0, scalar := 5 },{ source := 80, target := 34, scalar := 1 },{ source := 135, target := 17, scalar := 6 }] }
theorem rowR6_0010_000_24_valid : (rowR6_0010_000_24).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_25 : ExtensionRow := { move := 138, child := 239, matrix := ![14,8,6,0,7,12,0,10,10], witnesses := [{ source := 0, target := 52, scalar := 6 },{ source := 1, target := 205, scalar := 8 },{ source := 17, target := 17, scalar := 14 },{ source := 34, target := 1, scalar := 11 },{ source := 52, target := 74, scalar := 7 },{ source := 80, target := 34, scalar := 1 },{ source := 138, target := 0, scalar := 6 }] }
theorem rowR6_0010_000_25_valid : (rowR6_0010_000_25).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_26 : ExtensionRow := { move := 140, child := 245, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 80, target := 232, scalar := 12 },{ source := 140, target := 74, scalar := 12 }] }
theorem rowR6_0010_000_26_valid : (rowR6_0010_000_26).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_27 : ExtensionRow := { move := 141, child := 22, matrix := ![7,7,0,1,0,0,4,0,4], witnesses := [{ source := 0, target := 0, scalar := 4 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 124, scalar := 7 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 9 },{ source := 80, target := 69, scalar := 14 },{ source := 141, target := 34, scalar := 1 }] }
theorem rowR6_0010_000_27_valid : (rowR6_0010_000_27).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_28 : ExtensionRow := { move := 143, child := 221, matrix := ![1,0,0,3,0,3,9,9,0], witnesses := [{ source := 0, target := 1, scalar := 3 },{ source := 1, target := 0, scalar := 9 },{ source := 17, target := 74, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 121, scalar := 1 },{ source := 80, target := 34, scalar := 1 },{ source := 143, target := 52, scalar := 1 }] }
theorem rowR6_0010_000_28_valid : (rowR6_0010_000_28).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_29 : ExtensionRow := { move := 149, child := 156, matrix := ![3,6,5,0,10,10,0,1,15], witnesses := [{ source := 0, target := 52, scalar := 5 },{ source := 1, target := 72, scalar := 6 },{ source := 17, target := 17, scalar := 3 },{ source := 34, target := 0, scalar := 14 },{ source := 52, target := 1, scalar := 10 },{ source := 80, target := 149, scalar := 15 },{ source := 149, target := 34, scalar := 1 }] }
theorem rowR6_0010_000_29_valid : (rowR6_0010_000_29).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_30 : ExtensionRow := { move := 150, child := 149, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 80, target := 125, scalar := 12 },{ source := 150, target := 72, scalar := 13 }] }
theorem rowR6_0010_000_30_valid : (rowR6_0010_000_30).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_31 : ExtensionRow := { move := 151, child := 168, matrix := ![2,1,3,7,1,6,5,1,5], witnesses := [{ source := 0, target := 52, scalar := 3 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 188, scalar := 2 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 72, scalar := 5 },{ source := 80, target := 17, scalar := 3 },{ source := 151, target := 1, scalar := 8 }] }
theorem rowR6_0010_000_31_valid : (rowR6_0010_000_31).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_32 : ExtensionRow := { move := 152, child := 338, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 80, target := 80, scalar := 1 },{ source := 152, target := 152, scalar := 1 }] }
theorem rowR6_0010_000_32_valid : (rowR6_0010_000_32).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_33 : ExtensionRow := { move := 154, child := 339, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 80, target := 80, scalar := 1 },{ source := 154, target := 154, scalar := 1 }] }
theorem rowR6_0010_000_33_valid : (rowR6_0010_000_33).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_34 : ExtensionRow := { move := 155, child := 43, matrix := ![0,15,0,2,2,0,0,9,9], witnesses := [{ source := 0, target := 0, scalar := 9 },{ source := 1, target := 69, scalar := 15 },{ source := 17, target := 1, scalar := 2 },{ source := 34, target := 17, scalar := 15 },{ source := 52, target := 195, scalar := 13 },{ source := 80, target := 52, scalar := 2 },{ source := 155, target := 34, scalar := 1 }] }
theorem rowR6_0010_000_34_valid : (rowR6_0010_000_34).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_35 : ExtensionRow := { move := 158, child := 27, matrix := ![11,4,1,14,15,1,10,11,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 135, scalar := 4 },{ source := 17, target := 69, scalar := 11 },{ source := 34, target := 17, scalar := 14 },{ source := 52, target := 0, scalar := 12 },{ source := 80, target := 52, scalar := 8 },{ source := 158, target := 1, scalar := 2 }] }
theorem rowR6_0010_000_35_valid : (rowR6_0010_000_35).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_36 : ExtensionRow := { move := 163, child := 207, matrix := ![14,14,0,1,0,0,9,0,9], witnesses := [{ source := 0, target := 0, scalar := 9 },{ source := 1, target := 17, scalar := 14 },{ source := 17, target := 73, scalar := 14 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 34, scalar := 1 },{ source := 80, target := 158, scalar := 15 },{ source := 163, target := 52, scalar := 9 }] }
theorem rowR6_0010_000_36_valid : (rowR6_0010_000_36).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_37 : ExtensionRow := { move := 166, child := 92, matrix := ![3,0,1,5,0,1,10,13,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 0, scalar := 13 },{ source := 17, target := 71, scalar := 3 },{ source := 34, target := 52, scalar := 2 },{ source := 52, target := 1, scalar := 6 },{ source := 80, target := 155, scalar := 12 },{ source := 166, target := 17, scalar := 6 }] }
theorem rowR6_0010_000_37_valid : (rowR6_0010_000_37).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_38 : ExtensionRow := { move := 167, child := 100, matrix := ![1,13,12,1,15,11,1,6,7], witnesses := [{ source := 0, target := 52, scalar := 12 },{ source := 1, target := 172, scalar := 13 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 5 },{ source := 52, target := 71, scalar := 15 },{ source := 80, target := 17, scalar := 13 },{ source := 167, target := 0, scalar := 3 }] }
theorem rowR6_0010_000_38_valid : (rowR6_0010_000_38).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_39 : ExtensionRow := { move := 168, child := 83, matrix := ![0,9,8,12,8,5,0,3,2], witnesses := [{ source := 0, target := 126, scalar := 8 },{ source := 1, target := 71, scalar := 9 },{ source := 17, target := 1, scalar := 12 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 17, scalar := 10 },{ source := 80, target := 52, scalar := 9 },{ source := 168, target := 0, scalar := 6 }] }
theorem rowR6_0010_000_39_valid : (rowR6_0010_000_39).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_40 : ExtensionRow := { move := 169, child := 98, matrix := ![1,0,1,1,0,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 169, scalar := 2 },{ source := 80, target := 71, scalar := 14 },{ source := 169, target := 52, scalar := 9 }] }
theorem rowR6_0010_000_40_valid : (rowR6_0010_000_40).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_41 : ExtensionRow := { move := 171, child := 54, matrix := ![4,12,11,12,0,10,7,0,2], witnesses := [{ source := 0, target := 91, scalar := 11 },{ source := 1, target := 17, scalar := 12 },{ source := 17, target := 70, scalar := 4 },{ source := 34, target := 52, scalar := 3 },{ source := 52, target := 34, scalar := 1 },{ source := 80, target := 0, scalar := 10 },{ source := 171, target := 1, scalar := 4 }] }
theorem rowR6_0010_000_41_valid : (rowR6_0010_000_41).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_42 : ExtensionRow := { move := 174, child := 325, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 80, target := 125, scalar := 12 },{ source := 174, target := 79, scalar := 4 }] }
theorem rowR6_0010_000_42_valid : (rowR6_0010_000_42).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_43 : ExtensionRow := { move := 183, child := 222, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 80, target := 125, scalar := 12 },{ source := 183, target := 74, scalar := 12 }] }
theorem rowR6_0010_000_43_valid : (rowR6_0010_000_43).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_44 : ExtensionRow := { move := 184, child := 340, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 80, target := 80, scalar := 1 },{ source := 184, target := 184, scalar := 1 }] }
theorem rowR6_0010_000_44_valid : (rowR6_0010_000_44).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_45 : ExtensionRow := { move := 185, child := 309, matrix := ![3,0,3,5,0,6,4,1,5], witnesses := [{ source := 0, target := 52, scalar := 3 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 78, scalar := 3 },{ source := 34, target := 1, scalar := 3 },{ source := 52, target := 203, scalar := 6 },{ source := 80, target := 34, scalar := 1 },{ source := 185, target := 17, scalar := 8 }] }
theorem rowR6_0010_000_45_valid : (rowR6_0010_000_45).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_46 : ExtensionRow := { move := 188, child := 341, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 80, target := 80, scalar := 1 },{ source := 188, target := 188, scalar := 1 }] }
theorem rowR6_0010_000_46_valid : (rowR6_0010_000_46).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowR6_0010_000_47 : ExtensionRow := { move := 189, child := 36, matrix := ![4,10,1,12,0,1,3,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 10 },{ source := 17, target := 69, scalar := 4 },{ source := 34, target := 52, scalar := 15 },{ source := 52, target := 1, scalar := 15 },{ source := 80, target := 163, scalar := 6 },{ source := 189, target := 0, scalar := 15 }] }
theorem rowR6_0010_000_47_valid : (rowR6_0010_000_47).ValidFor level7 {0,1,17,34,52,80} := by decide

noncomputable def rowsR6_0010_000 : List ExtensionRow := [rowR6_0010_000_0,rowR6_0010_000_1,rowR6_0010_000_2,rowR6_0010_000_3,rowR6_0010_000_4,rowR6_0010_000_5,rowR6_0010_000_6,rowR6_0010_000_7,rowR6_0010_000_8,rowR6_0010_000_9,rowR6_0010_000_10,rowR6_0010_000_11,rowR6_0010_000_12,rowR6_0010_000_13,rowR6_0010_000_14,rowR6_0010_000_15,rowR6_0010_000_16,rowR6_0010_000_17,rowR6_0010_000_18,rowR6_0010_000_19,rowR6_0010_000_20,rowR6_0010_000_21,rowR6_0010_000_22,rowR6_0010_000_23,rowR6_0010_000_24,rowR6_0010_000_25,rowR6_0010_000_26,rowR6_0010_000_27,rowR6_0010_000_28,rowR6_0010_000_29,rowR6_0010_000_30,rowR6_0010_000_31,rowR6_0010_000_32,rowR6_0010_000_33,rowR6_0010_000_34,rowR6_0010_000_35,rowR6_0010_000_36,rowR6_0010_000_37,rowR6_0010_000_38,rowR6_0010_000_39,rowR6_0010_000_40,rowR6_0010_000_41,rowR6_0010_000_42,rowR6_0010_000_43,rowR6_0010_000_44,rowR6_0010_000_45,rowR6_0010_000_46,rowR6_0010_000_47]

theorem rowsR6_0010_000_valid : RowListValid level7 {0,1,17,34,52,80} rowsR6_0010_000 := by
  intro r hr
  simp only [rowsR6_0010_000, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR6_0010_000_0_valid
  · exact rowR6_0010_000_1_valid
  · exact rowR6_0010_000_2_valid
  · exact rowR6_0010_000_3_valid
  · exact rowR6_0010_000_4_valid
  · exact rowR6_0010_000_5_valid
  · exact rowR6_0010_000_6_valid
  · exact rowR6_0010_000_7_valid
  · exact rowR6_0010_000_8_valid
  · exact rowR6_0010_000_9_valid
  · exact rowR6_0010_000_10_valid
  · exact rowR6_0010_000_11_valid
  · exact rowR6_0010_000_12_valid
  · exact rowR6_0010_000_13_valid
  · exact rowR6_0010_000_14_valid
  · exact rowR6_0010_000_15_valid
  · exact rowR6_0010_000_16_valid
  · exact rowR6_0010_000_17_valid
  · exact rowR6_0010_000_18_valid
  · exact rowR6_0010_000_19_valid
  · exact rowR6_0010_000_20_valid
  · exact rowR6_0010_000_21_valid
  · exact rowR6_0010_000_22_valid
  · exact rowR6_0010_000_23_valid
  · exact rowR6_0010_000_24_valid
  · exact rowR6_0010_000_25_valid
  · exact rowR6_0010_000_26_valid
  · exact rowR6_0010_000_27_valid
  · exact rowR6_0010_000_28_valid
  · exact rowR6_0010_000_29_valid
  · exact rowR6_0010_000_30_valid
  · exact rowR6_0010_000_31_valid
  · exact rowR6_0010_000_32_valid
  · exact rowR6_0010_000_33_valid
  · exact rowR6_0010_000_34_valid
  · exact rowR6_0010_000_35_valid
  · exact rowR6_0010_000_36_valid
  · exact rowR6_0010_000_37_valid
  · exact rowR6_0010_000_38_valid
  · exact rowR6_0010_000_39_valid
  · exact rowR6_0010_000_40_valid
  · exact rowR6_0010_000_41_valid
  · exact rowR6_0010_000_42_valid
  · exact rowR6_0010_000_43_valid
  · exact rowR6_0010_000_44_valid
  · exact rowR6_0010_000_45_valid
  · exact rowR6_0010_000_46_valid
  · exact rowR6_0010_000_47_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
