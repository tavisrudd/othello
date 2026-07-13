import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR6_0030_000_0 : ExtensionRow := { move := 69, child := 31, matrix := ![1,15,4,1,13,12,1,2,3], witnesses := [{ source := 0, target := 69, scalar := 4 },{ source := 1, target := 52, scalar := 15 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 10 },{ source := 52, target := 1, scalar := 15 },{ source := 69, target := 0, scalar := 11 },{ source := 169, target := 150, scalar := 9 }] }
theorem rowR6_0030_000_0_valid : (rowR6_0030_000_0).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_1 : ExtensionRow := { move := 71, child := 98, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 71, target := 71, scalar := 1 },{ source := 169, target := 169, scalar := 1 }] }
theorem rowR6_0030_000_1_valid : (rowR6_0030_000_1).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_2 : ExtensionRow := { move := 72, child := 162, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 72, target := 72, scalar := 1 },{ source := 169, target := 169, scalar := 1 }] }
theorem rowR6_0030_000_2_valid : (rowR6_0030_000_2).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_3 : ExtensionRow := { move := 74, child := 162, matrix := ![11,5,0,5,11,14,14,14,0], witnesses := [{ source := 0, target := 1, scalar := 14 },{ source := 1, target := 169, scalar := 5 },{ source := 17, target := 52, scalar := 11 },{ source := 34, target := 17, scalar := 14 },{ source := 52, target := 34, scalar := 1 },{ source := 74, target := 72, scalar := 4 },{ source := 169, target := 0, scalar := 9 }] }
theorem rowR6_0030_000_3_valid : (rowR6_0030_000_3).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_4 : ExtensionRow := { move := 75, child := 162, matrix := ![0,1,14,0,1,15,1,1,1], witnesses := [{ source := 0, target := 52, scalar := 14 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 169, scalar := 15 },{ source := 52, target := 17, scalar := 3 },{ source := 75, target := 72, scalar := 5 },{ source := 169, target := 1, scalar := 8 }] }
theorem rowR6_0030_000_4_valid : (rowR6_0030_000_4).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_5 : ExtensionRow := { move := 78, child := 98, matrix := ![10,5,0,5,10,15,15,15,0], witnesses := [{ source := 0, target := 1, scalar := 15 },{ source := 1, target := 52, scalar := 5 },{ source := 17, target := 169, scalar := 10 },{ source := 34, target := 17, scalar := 15 },{ source := 52, target := 0, scalar := 2 },{ source := 78, target := 71, scalar := 5 },{ source := 169, target := 34, scalar := 1 }] }
theorem rowR6_0030_000_5_valid : (rowR6_0030_000_5).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_6 : ExtensionRow := { move := 80, child := 98, matrix := ![1,0,1,1,0,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 169, scalar := 2 },{ source := 80, target := 71, scalar := 14 },{ source := 169, target := 52, scalar := 9 }] }
theorem rowR6_0030_000_6_valid : (rowR6_0030_000_6).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_7 : ExtensionRow := { move := 90, child := 162, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 90, target := 72, scalar := 13 },{ source := 169, target := 169, scalar := 1 }] }
theorem rowR6_0030_000_7_valid : (rowR6_0030_000_7).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_8 : ExtensionRow := { move := 91, child := 31, matrix := ![1,15,10,1,13,0,1,2,0], witnesses := [{ source := 0, target := 17, scalar := 10 },{ source := 1, target := 52, scalar := 15 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 69, scalar := 4 },{ source := 52, target := 150, scalar := 1 },{ source := 91, target := 0, scalar := 9 },{ source := 169, target := 1, scalar := 14 }] }
theorem rowR6_0030_000_8_valid : (rowR6_0030_000_8).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_9 : ExtensionRow := { move := 92, child := 98, matrix := ![0,1,14,0,1,15,1,1,1], witnesses := [{ source := 0, target := 52, scalar := 14 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 169, scalar := 15 },{ source := 52, target := 17, scalar := 3 },{ source := 92, target := 71, scalar := 12 },{ source := 169, target := 1, scalar := 8 }] }
theorem rowR6_0030_000_9_valid : (rowR6_0030_000_9).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_10 : ExtensionRow := { move := 94, child := 396, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 94, target := 94, scalar := 1 },{ source := 169, target := 169, scalar := 1 }] }
theorem rowR6_0030_000_10_valid : (rowR6_0030_000_10).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_11 : ExtensionRow := { move := 95, child := 31, matrix := ![14,0,1,9,5,1,3,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 1, scalar := 5 },{ source := 17, target := 150, scalar := 14 },{ source := 34, target := 52, scalar := 15 },{ source := 52, target := 17, scalar := 13 },{ source := 95, target := 0, scalar := 13 },{ source := 169, target := 69, scalar := 6 }] }
theorem rowR6_0030_000_11_valid : (rowR6_0030_000_11).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_12 : ExtensionRow := { move := 96, child := 98, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 96, target := 71, scalar := 11 },{ source := 169, target := 169, scalar := 1 }] }
theorem rowR6_0030_000_12_valid : (rowR6_0030_000_12).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_13 : ExtensionRow := { move := 99, child := 31, matrix := ![10,4,15,0,12,13,0,3,2], witnesses := [{ source := 0, target := 52, scalar := 15 },{ source := 1, target := 69, scalar := 4 },{ source := 17, target := 17, scalar := 10 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 1, scalar := 15 },{ source := 99, target := 0, scalar := 11 },{ source := 169, target := 150, scalar := 9 }] }
theorem rowR6_0030_000_13_valid : (rowR6_0030_000_13).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_14 : ExtensionRow := { move := 103, child := 98, matrix := ![0,15,10,15,0,5,0,0,15], witnesses := [{ source := 0, target := 169, scalar := 10 },{ source := 1, target := 17, scalar := 15 },{ source := 17, target := 1, scalar := 15 },{ source := 34, target := 52, scalar := 5 },{ source := 52, target := 0, scalar := 2 },{ source := 103, target := 71, scalar := 15 },{ source := 169, target := 34, scalar := 1 }] }
theorem rowR6_0030_000_14_valid : (rowR6_0030_000_14).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_15 : ExtensionRow := { move := 104, child := 162, matrix := ![1,0,15,1,0,14,1,1,1], witnesses := [{ source := 0, target := 169, scalar := 15 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 52, scalar := 14 },{ source := 52, target := 17, scalar := 3 },{ source := 104, target := 72, scalar := 10 },{ source := 169, target := 1, scalar := 8 }] }
theorem rowR6_0030_000_15_valid : (rowR6_0030_000_15).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_16 : ExtensionRow := { move := 106, child := 31, matrix := ![1,15,14,1,13,9,1,2,3], witnesses := [{ source := 0, target := 150, scalar := 14 },{ source := 1, target := 52, scalar := 15 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 5 },{ source := 52, target := 17, scalar := 13 },{ source := 106, target := 0, scalar := 3 },{ source := 169, target := 69, scalar := 6 }] }
theorem rowR6_0030_000_16_valid : (rowR6_0030_000_16).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_17 : ExtensionRow := { move := 107, child := 162, matrix := ![14,15,1,15,14,1,1,1,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 169, scalar := 15 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 1, scalar := 3 },{ source := 107, target := 72, scalar := 2 },{ source := 169, target := 17, scalar := 8 }] }
theorem rowR6_0030_000_17_valid : (rowR6_0030_000_17).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_18 : ExtensionRow := { move := 108, child := 396, matrix := ![5,10,15,10,5,0,15,15,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 169, scalar := 10 },{ source := 17, target := 52, scalar := 5 },{ source := 34, target := 1, scalar := 15 },{ source := 52, target := 0, scalar := 2 },{ source := 108, target := 94, scalar := 2 },{ source := 169, target := 34, scalar := 1 }] }
theorem rowR6_0030_000_18_valid : (rowR6_0030_000_18).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_19 : ExtensionRow := { move := 110, child := 31, matrix := ![13,6,0,4,0,3,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 3 },{ source := 1, target := 17, scalar := 6 },{ source := 17, target := 69, scalar := 13 },{ source := 34, target := 150, scalar := 11 },{ source := 52, target := 34, scalar := 1 },{ source := 110, target := 0, scalar := 1 },{ source := 169, target := 52, scalar := 14 }] }
theorem rowR6_0030_000_19_valid : (rowR6_0030_000_19).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_20 : ExtensionRow := { move := 115, child := 162, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 115, target := 72, scalar := 1 },{ source := 169, target := 169, scalar := 1 }] }
theorem rowR6_0030_000_20_valid : (rowR6_0030_000_20).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_21 : ExtensionRow := { move := 117, child := 162, matrix := ![14,15,0,15,14,0,1,1,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 169, scalar := 15 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 17, scalar := 3 },{ source := 117, target := 72, scalar := 10 },{ source := 169, target := 1, scalar := 8 }] }
theorem rowR6_0030_000_21_valid : (rowR6_0030_000_21).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_22 : ExtensionRow := { move := 122, child := 31, matrix := ![0,11,13,3,7,4,0,1,1], witnesses := [{ source := 0, target := 69, scalar := 13 },{ source := 1, target := 150, scalar := 11 },{ source := 17, target := 1, scalar := 3 },{ source := 34, target := 17, scalar := 6 },{ source := 52, target := 34, scalar := 1 },{ source := 122, target := 0, scalar := 15 },{ source := 169, target := 52, scalar := 14 }] }
theorem rowR6_0030_000_22_valid : (rowR6_0030_000_22).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_23 : ExtensionRow := { move := 124, child := 98, matrix := ![5,11,14,11,5,0,14,14,0], witnesses := [{ source := 0, target := 17, scalar := 14 },{ source := 1, target := 52, scalar := 11 },{ source := 17, target := 169, scalar := 5 },{ source := 34, target := 1, scalar := 14 },{ source := 52, target := 34, scalar := 1 },{ source := 124, target := 71, scalar := 2 },{ source := 169, target := 0, scalar := 9 }] }
theorem rowR6_0030_000_23_valid : (rowR6_0030_000_23).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_24 : ExtensionRow := { move := 125, child := 98, matrix := ![0,1,0,0,1,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 169, scalar := 2 },{ source := 125, target := 71, scalar := 6 },{ source := 169, target := 52, scalar := 9 }] }
theorem rowR6_0030_000_24_valid : (rowR6_0030_000_24).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_25 : ExtensionRow := { move := 127, child := 98, matrix := ![14,15,0,15,14,0,1,1,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 169, scalar := 15 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 17, scalar := 3 },{ source := 127, target := 71, scalar := 10 },{ source := 169, target := 1, scalar := 8 }] }
theorem rowR6_0030_000_25_valid : (rowR6_0030_000_25).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_26 : ExtensionRow := { move := 128, child := 162, matrix := ![15,0,5,0,15,10,0,0,15], witnesses := [{ source := 0, target := 52, scalar := 5 },{ source := 1, target := 1, scalar := 15 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 169, scalar := 10 },{ source := 52, target := 0, scalar := 2 },{ source := 128, target := 72, scalar := 9 },{ source := 169, target := 34, scalar := 1 }] }
theorem rowR6_0030_000_26_valid : (rowR6_0030_000_26).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_27 : ExtensionRow := { move := 131, child := 98, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 131, target := 71, scalar := 1 },{ source := 169, target := 169, scalar := 1 }] }
theorem rowR6_0030_000_27_valid : (rowR6_0030_000_27).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_28 : ExtensionRow := { move := 133, child := 98, matrix := ![5,10,15,10,5,0,15,15,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 169, scalar := 10 },{ source := 17, target := 52, scalar := 5 },{ source := 34, target := 1, scalar := 15 },{ source := 52, target := 0, scalar := 2 },{ source := 133, target := 71, scalar := 15 },{ source := 169, target := 34, scalar := 1 }] }
theorem rowR6_0030_000_28_valid : (rowR6_0030_000_28).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_29 : ExtensionRow := { move := 139, child := 31, matrix := ![5,0,9,14,6,8,2,0,2], witnesses := [{ source := 0, target := 69, scalar := 9 },{ source := 1, target := 1, scalar := 6 },{ source := 17, target := 150, scalar := 5 },{ source := 34, target := 17, scalar := 12 },{ source := 52, target := 52, scalar := 13 },{ source := 139, target := 0, scalar := 5 },{ source := 169, target := 34, scalar := 1 }] }
theorem rowR6_0030_000_29_valid : (rowR6_0030_000_29).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_30 : ExtensionRow := { move := 140, child := 162, matrix := ![0,14,11,14,0,5,0,0,14], witnesses := [{ source := 0, target := 52, scalar := 11 },{ source := 1, target := 17, scalar := 14 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 169, scalar := 5 },{ source := 52, target := 34, scalar := 1 },{ source := 140, target := 72, scalar := 5 },{ source := 169, target := 0, scalar := 9 }] }
theorem rowR6_0030_000_30_valid : (rowR6_0030_000_30).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_31 : ExtensionRow := { move := 141, child := 98, matrix := ![15,14,0,14,15,0,1,1,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 52, scalar := 14 },{ source := 17, target := 169, scalar := 15 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 1, scalar := 3 },{ source := 141, target := 71, scalar := 3 },{ source := 169, target := 17, scalar := 8 }] }
theorem rowR6_0030_000_31_valid : (rowR6_0030_000_31).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_32 : ExtensionRow := { move := 143, child := 162, matrix := ![0,1,0,0,1,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 169, scalar := 2 },{ source := 143, target := 72, scalar := 7 },{ source := 169, target := 52, scalar := 9 }] }
theorem rowR6_0030_000_32_valid : (rowR6_0030_000_32).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_33 : ExtensionRow := { move := 144, child := 162, matrix := ![15,14,0,14,15,0,1,1,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 52, scalar := 14 },{ source := 17, target := 169, scalar := 15 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 1, scalar := 3 },{ source := 144, target := 72, scalar := 3 },{ source := 169, target := 17, scalar := 8 }] }
theorem rowR6_0030_000_33_valid : (rowR6_0030_000_33).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_34 : ExtensionRow := { move := 147, child := 162, matrix := ![14,0,5,0,14,11,0,0,14], witnesses := [{ source := 0, target := 169, scalar := 5 },{ source := 1, target := 1, scalar := 14 },{ source := 17, target := 17, scalar := 14 },{ source := 34, target := 52, scalar := 11 },{ source := 52, target := 34, scalar := 1 },{ source := 147, target := 72, scalar := 4 },{ source := 169, target := 0, scalar := 9 }] }
theorem rowR6_0030_000_34_valid : (rowR6_0030_000_34).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_35 : ExtensionRow := { move := 149, child := 31, matrix := ![0,14,15,5,9,13,0,3,2], witnesses := [{ source := 0, target := 52, scalar := 15 },{ source := 1, target := 150, scalar := 14 },{ source := 17, target := 1, scalar := 5 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 17, scalar := 13 },{ source := 149, target := 0, scalar := 3 },{ source := 169, target := 69, scalar := 6 }] }
theorem rowR6_0030_000_35_valid : (rowR6_0030_000_35).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_36 : ExtensionRow := { move := 150, child := 162, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 150, target := 72, scalar := 13 },{ source := 169, target := 169, scalar := 1 }] }
theorem rowR6_0030_000_36_valid : (rowR6_0030_000_36).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_37 : ExtensionRow := { move := 152, child := 31, matrix := ![6,13,11,0,4,7,0,1,1], witnesses := [{ source := 0, target := 150, scalar := 11 },{ source := 1, target := 69, scalar := 13 },{ source := 17, target := 17, scalar := 6 },{ source := 34, target := 1, scalar := 3 },{ source := 52, target := 34, scalar := 1 },{ source := 152, target := 0, scalar := 15 },{ source := 169, target := 52, scalar := 14 }] }
theorem rowR6_0030_000_37_valid : (rowR6_0030_000_37).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_38 : ExtensionRow := { move := 155, child := 396, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 155, target := 94, scalar := 2 },{ source := 169, target := 169, scalar := 1 }] }
theorem rowR6_0030_000_38_valid : (rowR6_0030_000_38).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_39 : ExtensionRow := { move := 158, child := 98, matrix := ![0,1,15,0,1,14,1,1,1], witnesses := [{ source := 0, target := 169, scalar := 15 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 52, scalar := 14 },{ source := 52, target := 1, scalar := 3 },{ source := 158, target := 71, scalar := 15 },{ source := 169, target := 17, scalar := 8 }] }
theorem rowR6_0030_000_39_valid : (rowR6_0030_000_39).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_40 : ExtensionRow := { move := 159, child := 31, matrix := ![1,15,0,1,13,5,1,2,0], witnesses := [{ source := 0, target := 1, scalar := 5 },{ source := 1, target := 52, scalar := 15 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 150, scalar := 14 },{ source := 52, target := 69, scalar := 12 },{ source := 159, target := 0, scalar := 2 },{ source := 169, target := 17, scalar := 15 }] }
theorem rowR6_0030_000_40_valid : (rowR6_0030_000_40).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_41 : ExtensionRow := { move := 181, child := 396, matrix := ![0,15,10,15,0,5,0,0,15], witnesses := [{ source := 0, target := 169, scalar := 10 },{ source := 1, target := 17, scalar := 15 },{ source := 17, target := 1, scalar := 15 },{ source := 34, target := 52, scalar := 5 },{ source := 52, target := 0, scalar := 2 },{ source := 169, target := 34, scalar := 1 },{ source := 181, target := 94, scalar := 2 }] }
theorem rowR6_0030_000_41_valid : (rowR6_0030_000_41).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_42 : ExtensionRow := { move := 182, child := 98, matrix := ![15,14,1,14,15,1,1,1,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 52, scalar := 14 },{ source := 17, target := 169, scalar := 15 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 17, scalar := 3 },{ source := 169, target := 1, scalar := 8 },{ source := 182, target := 71, scalar := 12 }] }
theorem rowR6_0030_000_42_valid : (rowR6_0030_000_42).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_43 : ExtensionRow := { move := 183, child := 162, matrix := ![5,11,14,11,5,0,14,14,0], witnesses := [{ source := 0, target := 17, scalar := 14 },{ source := 1, target := 52, scalar := 11 },{ source := 17, target := 169, scalar := 5 },{ source := 34, target := 1, scalar := 14 },{ source := 52, target := 34, scalar := 1 },{ source := 169, target := 0, scalar := 9 },{ source := 183, target := 72, scalar := 5 }] }
theorem rowR6_0030_000_43_valid : (rowR6_0030_000_43).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_44 : ExtensionRow := { move := 184, child := 98, matrix := ![0,14,11,14,0,5,0,0,14], witnesses := [{ source := 0, target := 52, scalar := 11 },{ source := 1, target := 17, scalar := 14 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 169, scalar := 5 },{ source := 52, target := 34, scalar := 1 },{ source := 169, target := 0, scalar := 9 },{ source := 184, target := 71, scalar := 2 }] }
theorem rowR6_0030_000_44_valid : (rowR6_0030_000_44).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_45 : ExtensionRow := { move := 189, child := 31, matrix := ![4,10,1,12,0,1,3,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 10 },{ source := 17, target := 69, scalar := 4 },{ source := 34, target := 52, scalar := 15 },{ source := 52, target := 1, scalar := 15 },{ source := 169, target := 150, scalar := 9 },{ source := 189, target := 0, scalar := 15 }] }
theorem rowR6_0030_000_45_valid : (rowR6_0030_000_45).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_46 : ExtensionRow := { move := 191, child := 31, matrix := ![0,5,12,6,14,0,0,2,0], witnesses := [{ source := 0, target := 17, scalar := 12 },{ source := 1, target := 150, scalar := 5 },{ source := 17, target := 1, scalar := 6 },{ source := 34, target := 69, scalar := 9 },{ source := 52, target := 52, scalar := 13 },{ source := 169, target := 34, scalar := 1 },{ source := 191, target := 0, scalar := 7 }] }
theorem rowR6_0030_000_46_valid : (rowR6_0030_000_46).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowR6_0030_000_47 : ExtensionRow := { move := 195, child := 162, matrix := ![15,14,1,14,15,1,1,1,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 52, scalar := 14 },{ source := 17, target := 169, scalar := 15 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 17, scalar := 3 },{ source := 169, target := 1, scalar := 8 },{ source := 195, target := 72, scalar := 5 }] }
theorem rowR6_0030_000_47_valid : (rowR6_0030_000_47).ValidFor level7 {0,1,17,34,52,169} := by decide

noncomputable def rowsR6_0030_000 : List ExtensionRow := [rowR6_0030_000_0,rowR6_0030_000_1,rowR6_0030_000_2,rowR6_0030_000_3,rowR6_0030_000_4,rowR6_0030_000_5,rowR6_0030_000_6,rowR6_0030_000_7,rowR6_0030_000_8,rowR6_0030_000_9,rowR6_0030_000_10,rowR6_0030_000_11,rowR6_0030_000_12,rowR6_0030_000_13,rowR6_0030_000_14,rowR6_0030_000_15,rowR6_0030_000_16,rowR6_0030_000_17,rowR6_0030_000_18,rowR6_0030_000_19,rowR6_0030_000_20,rowR6_0030_000_21,rowR6_0030_000_22,rowR6_0030_000_23,rowR6_0030_000_24,rowR6_0030_000_25,rowR6_0030_000_26,rowR6_0030_000_27,rowR6_0030_000_28,rowR6_0030_000_29,rowR6_0030_000_30,rowR6_0030_000_31,rowR6_0030_000_32,rowR6_0030_000_33,rowR6_0030_000_34,rowR6_0030_000_35,rowR6_0030_000_36,rowR6_0030_000_37,rowR6_0030_000_38,rowR6_0030_000_39,rowR6_0030_000_40,rowR6_0030_000_41,rowR6_0030_000_42,rowR6_0030_000_43,rowR6_0030_000_44,rowR6_0030_000_45,rowR6_0030_000_46,rowR6_0030_000_47]

theorem rowsR6_0030_000_valid : RowListValid level7 {0,1,17,34,52,169} rowsR6_0030_000 := by
  intro r hr
  simp only [rowsR6_0030_000, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR6_0030_000_0_valid
  · exact rowR6_0030_000_1_valid
  · exact rowR6_0030_000_2_valid
  · exact rowR6_0030_000_3_valid
  · exact rowR6_0030_000_4_valid
  · exact rowR6_0030_000_5_valid
  · exact rowR6_0030_000_6_valid
  · exact rowR6_0030_000_7_valid
  · exact rowR6_0030_000_8_valid
  · exact rowR6_0030_000_9_valid
  · exact rowR6_0030_000_10_valid
  · exact rowR6_0030_000_11_valid
  · exact rowR6_0030_000_12_valid
  · exact rowR6_0030_000_13_valid
  · exact rowR6_0030_000_14_valid
  · exact rowR6_0030_000_15_valid
  · exact rowR6_0030_000_16_valid
  · exact rowR6_0030_000_17_valid
  · exact rowR6_0030_000_18_valid
  · exact rowR6_0030_000_19_valid
  · exact rowR6_0030_000_20_valid
  · exact rowR6_0030_000_21_valid
  · exact rowR6_0030_000_22_valid
  · exact rowR6_0030_000_23_valid
  · exact rowR6_0030_000_24_valid
  · exact rowR6_0030_000_25_valid
  · exact rowR6_0030_000_26_valid
  · exact rowR6_0030_000_27_valid
  · exact rowR6_0030_000_28_valid
  · exact rowR6_0030_000_29_valid
  · exact rowR6_0030_000_30_valid
  · exact rowR6_0030_000_31_valid
  · exact rowR6_0030_000_32_valid
  · exact rowR6_0030_000_33_valid
  · exact rowR6_0030_000_34_valid
  · exact rowR6_0030_000_35_valid
  · exact rowR6_0030_000_36_valid
  · exact rowR6_0030_000_37_valid
  · exact rowR6_0030_000_38_valid
  · exact rowR6_0030_000_39_valid
  · exact rowR6_0030_000_40_valid
  · exact rowR6_0030_000_41_valid
  · exact rowR6_0030_000_42_valid
  · exact rowR6_0030_000_43_valid
  · exact rowR6_0030_000_44_valid
  · exact rowR6_0030_000_45_valid
  · exact rowR6_0030_000_46_valid
  · exact rowR6_0030_000_47_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
