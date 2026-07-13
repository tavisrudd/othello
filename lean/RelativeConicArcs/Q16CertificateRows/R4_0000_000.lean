import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR4_0000_000_0 : ExtensionRow := { move := 52, child := 0, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 }] }
theorem rowR4_0000_000_0_valid : (rowR4_0000_000_0).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_1 : ExtensionRow := { move := 53, child := 0, matrix := ![0,7,7,14,14,0,0,9,0], witnesses := [{ source := 0, target := 17, scalar := 7 },{ source := 1, target := 52, scalar := 7 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 0, scalar := 9 },{ source := 53, target := 34, scalar := 1 }] }
theorem rowR4_0000_000_1_valid : (rowR4_0000_000_1).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_2 : ExtensionRow := { move := 54, child := 1, matrix := ![0,9,0,1,0,0,0,0,11], witnesses := [{ source := 0, target := 0, scalar := 11 },{ source := 1, target := 17, scalar := 9 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 54, scalar := 9 },{ source := 54, target := 34, scalar := 1 }] }
theorem rowR4_0000_000_2_valid : (rowR4_0000_000_2).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_3 : ExtensionRow := { move := 55, child := 2, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 55, target := 55, scalar := 1 }] }
theorem rowR4_0000_000_3_valid : (rowR4_0000_000_3).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_4 : ExtensionRow := { move := 56, child := 2, matrix := ![7,0,7,14,14,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 7 },{ source := 1, target := 1, scalar := 14 },{ source := 17, target := 55, scalar := 7 },{ source := 34, target := 0, scalar := 1 },{ source := 56, target := 34, scalar := 1 }] }
theorem rowR4_0000_000_4_valid : (rowR4_0000_000_4).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_5 : ExtensionRow := { move := 57, child := 2, matrix := ![1,0,1,1,0,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 57, target := 55, scalar := 9 }] }
theorem rowR4_0000_000_5_valid : (rowR4_0000_000_5).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_6 : ExtensionRow := { move := 58, child := 0, matrix := ![14,0,15,15,14,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 1, scalar := 14 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 34, scalar := 1 },{ source := 58, target := 0, scalar := 1 }] }
theorem rowR4_0000_000_6_valid : (rowR4_0000_000_6).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_7 : ExtensionRow := { move := 59, child := 2, matrix := ![1,9,0,1,1,0,1,3,2], witnesses := [{ source := 0, target := 0, scalar := 2 },{ source := 1, target := 55, scalar := 9 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 8 },{ source := 59, target := 1, scalar := 3 }] }
theorem rowR4_0000_000_7_valid : (rowR4_0000_000_7).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_8 : ExtensionRow := { move := 60, child := 2, matrix := ![1,1,0,2,1,0,6,1,7], witnesses := [{ source := 0, target := 0, scalar := 7 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 55, scalar := 1 },{ source := 34, target := 1, scalar := 3 },{ source := 60, target := 17, scalar := 3 }] }
theorem rowR4_0000_000_8_valid : (rowR4_0000_000_8).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_9 : ExtensionRow := { move := 61, child := 2, matrix := ![0,7,6,15,14,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 55, scalar := 7 },{ source := 17, target := 1, scalar := 15 },{ source := 34, target := 34, scalar := 1 },{ source := 61, target := 0, scalar := 2 }] }
theorem rowR4_0000_000_9_valid : (rowR4_0000_000_9).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_10 : ExtensionRow := { move := 62, child := 2, matrix := ![0,1,8,0,1,0,2,1,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 2 },{ source := 34, target := 55, scalar := 9 },{ source := 62, target := 1, scalar := 2 }] }
theorem rowR4_0000_000_10_valid : (rowR4_0000_000_10).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_11 : ExtensionRow := { move := 63, child := 2, matrix := ![0,9,0,1,0,0,0,0,3], witnesses := [{ source := 0, target := 0, scalar := 3 },{ source := 1, target := 17, scalar := 9 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 55, scalar := 9 },{ source := 63, target := 34, scalar := 1 }] }
theorem rowR4_0000_000_11_valid : (rowR4_0000_000_11).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_12 : ExtensionRow := { move := 64, child := 0, matrix := ![1,0,8,1,0,0,1,9,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 0, scalar := 9 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 52, scalar := 9 },{ source := 64, target := 1, scalar := 1 }] }
theorem rowR4_0000_000_12_valid : (rowR4_0000_000_12).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_13 : ExtensionRow := { move := 67, child := 0, matrix := ![0,1,1,1,1,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 67, target := 52, scalar := 1 }] }
theorem rowR4_0000_000_13_valid : (rowR4_0000_000_13).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_14 : ExtensionRow := { move := 69, child := 1, matrix := ![9,9,0,1,0,0,11,0,11], witnesses := [{ source := 0, target := 0, scalar := 11 },{ source := 1, target := 17, scalar := 9 },{ source := 17, target := 54, scalar := 9 },{ source := 34, target := 1, scalar := 1 },{ source := 69, target := 34, scalar := 1 }] }
theorem rowR4_0000_000_14_valid : (rowR4_0000_000_14).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_15 : ExtensionRow := { move := 70, child := 0, matrix := ![0,7,7,0,14,0,9,9,0], witnesses := [{ source := 0, target := 17, scalar := 7 },{ source := 1, target := 52, scalar := 7 },{ source := 17, target := 0, scalar := 9 },{ source := 34, target := 1, scalar := 14 },{ source := 70, target := 34, scalar := 1 }] }
theorem rowR4_0000_000_15_valid : (rowR4_0000_000_15).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_16 : ExtensionRow := { move := 71, child := 2, matrix := ![0,0,7,0,14,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 7 },{ source := 1, target := 1, scalar := 14 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 55, scalar := 7 },{ source := 71, target := 34, scalar := 1 }] }
theorem rowR4_0000_000_16_valid : (rowR4_0000_000_16).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_17 : ExtensionRow := { move := 72, child := 2, matrix := ![1,0,0,1,1,0,1,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 72, target := 55, scalar := 1 }] }
theorem rowR4_0000_000_17_valid : (rowR4_0000_000_17).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_18 : ExtensionRow := { move := 73, child := 0, matrix := ![1,0,15,1,14,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 1, scalar := 14 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 52, scalar := 14 },{ source := 73, target := 0, scalar := 1 }] }
theorem rowR4_0000_000_18_valid : (rowR4_0000_000_18).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_19 : ExtensionRow := { move := 74, child := 2, matrix := ![0,0,1,1,0,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 74, target := 55, scalar := 9 }] }
theorem rowR4_0000_000_19_valid : (rowR4_0000_000_19).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_20 : ExtensionRow := { move := 75, child := 2, matrix := ![0,1,0,3,1,0,0,1,7], witnesses := [{ source := 0, target := 0, scalar := 7 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 3 },{ source := 34, target := 55, scalar := 1 },{ source := 75, target := 17, scalar := 3 }] }
theorem rowR4_0000_000_20_valid : (rowR4_0000_000_20).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_21 : ExtensionRow := { move := 76, child := 2, matrix := ![8,9,0,0,1,0,0,3,2], witnesses := [{ source := 0, target := 0, scalar := 2 },{ source := 1, target := 55, scalar := 9 },{ source := 17, target := 17, scalar := 8 },{ source := 34, target := 34, scalar := 1 },{ source := 76, target := 1, scalar := 3 }] }
theorem rowR4_0000_000_21_valid : (rowR4_0000_000_21).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_22 : ExtensionRow := { move := 77, child := 2, matrix := ![9,1,8,1,1,0,3,1,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 55, scalar := 9 },{ source := 34, target := 0, scalar := 2 },{ source := 77, target := 1, scalar := 2 }] }
theorem rowR4_0000_000_22_valid : (rowR4_0000_000_22).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_23 : ExtensionRow := { move := 78, child := 2, matrix := ![1,7,6,1,14,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 55, scalar := 7 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 15 },{ source := 78, target := 0, scalar := 2 }] }
theorem rowR4_0000_000_23_valid : (rowR4_0000_000_23).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_24 : ExtensionRow := { move := 79, child := 0, matrix := ![9,0,8,1,0,0,8,9,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 0, scalar := 9 },{ source := 17, target := 52, scalar := 9 },{ source := 34, target := 34, scalar := 1 },{ source := 79, target := 1, scalar := 1 }] }
theorem rowR4_0000_000_24_valid : (rowR4_0000_000_24).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_25 : ExtensionRow := { move := 80, child := 2, matrix := ![9,9,0,1,0,0,3,0,3], witnesses := [{ source := 0, target := 0, scalar := 3 },{ source := 1, target := 17, scalar := 9 },{ source := 17, target := 55, scalar := 9 },{ source := 34, target := 1, scalar := 1 },{ source := 80, target := 34, scalar := 1 }] }
theorem rowR4_0000_000_25_valid : (rowR4_0000_000_25).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_26 : ExtensionRow := { move := 83, child := 0, matrix := ![0,7,7,14,0,14,0,0,9], witnesses := [{ source := 0, target := 52, scalar := 7 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 0, scalar := 9 },{ source := 83, target := 34, scalar := 1 }] }
theorem rowR4_0000_000_26_valid : (rowR4_0000_000_26).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_27 : ExtensionRow := { move := 84, child := 1, matrix := ![9,0,9,1,0,0,11,11,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 0, scalar := 11 },{ source := 17, target := 54, scalar := 9 },{ source := 34, target := 1, scalar := 1 },{ source := 84, target := 34, scalar := 1 }] }
theorem rowR4_0000_000_27_valid : (rowR4_0000_000_27).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_28 : ExtensionRow := { move := 86, child := 1, matrix := ![0,1,10,4,1,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 10 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 4 },{ source := 34, target := 54, scalar := 11 },{ source := 86, target := 0, scalar := 4 }] }
theorem rowR4_0000_000_28_valid : (rowR4_0000_000_28).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_29 : ExtensionRow := { move := 87, child := 2, matrix := ![0,0,1,0,3,2,7,0,6], witnesses := [{ source := 0, target := 55, scalar := 1 },{ source := 1, target := 1, scalar := 3 },{ source := 17, target := 0, scalar := 7 },{ source := 34, target := 34, scalar := 1 },{ source := 87, target := 17, scalar := 6 }] }
theorem rowR4_0000_000_29_valid : (rowR4_0000_000_29).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_30 : ExtensionRow := { move := 88, child := 2, matrix := ![7,0,1,14,15,1,1,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 1, scalar := 15 },{ source := 17, target := 55, scalar := 7 },{ source := 34, target := 17, scalar := 6 },{ source := 88, target := 0, scalar := 6 }] }
theorem rowR4_0000_000_30_valid : (rowR4_0000_000_30).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_31 : ExtensionRow := { move := 89, child := 2, matrix := ![8,0,1,0,0,1,0,2,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 0, scalar := 2 },{ source := 17, target := 17, scalar := 8 },{ source := 34, target := 55, scalar := 9 },{ source := 89, target := 1, scalar := 8 }] }
theorem rowR4_0000_000_31_valid : (rowR4_0000_000_31).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_32 : ExtensionRow := { move := 90, child := 2, matrix := ![0,1,1,0,0,1,1,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 90, target := 55, scalar := 13 }] }
theorem rowR4_0000_000_32_valid : (rowR4_0000_000_32).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_33 : ExtensionRow := { move := 91, child := 1, matrix := ![1,0,1,1,1,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 91, target := 54, scalar := 11 }] }
theorem rowR4_0000_000_33_valid : (rowR4_0000_000_33).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_34 : ExtensionRow := { move := 92, child := 2, matrix := ![0,1,1,3,2,1,0,6,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 55, scalar := 1 },{ source := 17, target := 1, scalar := 3 },{ source := 34, target := 0, scalar := 7 },{ source := 92, target := 17, scalar := 15 }] }
theorem rowR4_0000_000_34_valid : (rowR4_0000_000_34).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_35 : ExtensionRow := { move := 93, child := 2, matrix := ![6,1,7,0,1,14,0,1,1], witnesses := [{ source := 0, target := 55, scalar := 7 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 17, scalar := 6 },{ source := 34, target := 1, scalar := 15 },{ source := 93, target := 0, scalar := 8 }] }
theorem rowR4_0000_000_35_valid : (rowR4_0000_000_35).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_36 : ExtensionRow := { move := 94, child := 1, matrix := ![0,9,8,0,1,0,10,11,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 54, scalar := 9 },{ source := 17, target := 0, scalar := 10 },{ source := 34, target := 34, scalar := 1 },{ source := 94, target := 1, scalar := 4 }] }
theorem rowR4_0000_000_36_valid : (rowR4_0000_000_36).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_37 : ExtensionRow := { move := 95, child := 2, matrix := ![1,8,9,1,0,1,1,0,3], witnesses := [{ source := 0, target := 55, scalar := 9 },{ source := 1, target := 17, scalar := 8 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 2 },{ source := 95, target := 1, scalar := 15 }] }
theorem rowR4_0000_000_37_valid : (rowR4_0000_000_37).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_38 : ExtensionRow := { move := 96, child := 2, matrix := ![0,0,8,3,0,3,0,5,5], witnesses := [{ source := 0, target := 55, scalar := 8 },{ source := 1, target := 0, scalar := 5 },{ source := 17, target := 1, scalar := 3 },{ source := 34, target := 17, scalar := 8 },{ source := 96, target := 34, scalar := 1 }] }
theorem rowR4_0000_000_38_valid : (rowR4_0000_000_38).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_39 : ExtensionRow := { move := 99, child := 1, matrix := ![0,0,9,1,0,0,0,11,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 0, scalar := 11 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 54, scalar := 9 },{ source := 99, target := 34, scalar := 1 }] }
theorem rowR4_0000_000_39_valid : (rowR4_0000_000_39).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_40 : ExtensionRow := { move := 100, child := 0, matrix := ![0,7,7,0,0,14,9,0,9], witnesses := [{ source := 0, target := 52, scalar := 7 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 0, scalar := 9 },{ source := 34, target := 1, scalar := 14 },{ source := 100, target := 34, scalar := 1 }] }
theorem rowR4_0000_000_40_valid : (rowR4_0000_000_40).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_41 : ExtensionRow := { move := 101, child := 1, matrix := ![11,1,10,5,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 10 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 54, scalar := 11 },{ source := 34, target := 1, scalar := 4 },{ source := 101, target := 0, scalar := 4 }] }
theorem rowR4_0000_000_41_valid : (rowR4_0000_000_41).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_42 : ExtensionRow := { move := 103, child := 2, matrix := ![6,0,1,0,15,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 1, scalar := 15 },{ source := 17, target := 17, scalar := 6 },{ source := 34, target := 55, scalar := 7 },{ source := 103, target := 0, scalar := 6 }] }
theorem rowR4_0000_000_42_valid : (rowR4_0000_000_42).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_43 : ExtensionRow := { move := 104, child := 2, matrix := ![1,0,1,1,3,2,1,0,6], witnesses := [{ source := 0, target := 55, scalar := 1 },{ source := 1, target := 1, scalar := 3 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 7 },{ source := 104, target := 17, scalar := 6 }] }
theorem rowR4_0000_000_43_valid : (rowR4_0000_000_43).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_44 : ExtensionRow := { move := 105, child := 2, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 105, target := 55, scalar := 13 }] }
theorem rowR4_0000_000_44_valid : (rowR4_0000_000_44).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_45 : ExtensionRow := { move := 106, child := 2, matrix := ![9,0,1,1,0,1,3,2,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 0, scalar := 2 },{ source := 17, target := 55, scalar := 9 },{ source := 34, target := 17, scalar := 8 },{ source := 106, target := 1, scalar := 8 }] }
theorem rowR4_0000_000_45_valid : (rowR4_0000_000_45).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_46 : ExtensionRow := { move := 107, child := 2, matrix := ![0,1,1,0,2,1,7,6,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 55, scalar := 1 },{ source := 17, target := 0, scalar := 7 },{ source := 34, target := 1, scalar := 3 },{ source := 107, target := 17, scalar := 15 }] }
theorem rowR4_0000_000_46_valid : (rowR4_0000_000_46).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_000_47 : ExtensionRow := { move := 108, child := 1, matrix := ![0,0,1,0,1,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 108, target := 54, scalar := 11 }] }
theorem rowR4_0000_000_47_valid : (rowR4_0000_000_47).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowsR4_0000_000 : List ExtensionRow := [rowR4_0000_000_0,rowR4_0000_000_1,rowR4_0000_000_2,rowR4_0000_000_3,rowR4_0000_000_4,rowR4_0000_000_5,rowR4_0000_000_6,rowR4_0000_000_7,rowR4_0000_000_8,rowR4_0000_000_9,rowR4_0000_000_10,rowR4_0000_000_11,rowR4_0000_000_12,rowR4_0000_000_13,rowR4_0000_000_14,rowR4_0000_000_15,rowR4_0000_000_16,rowR4_0000_000_17,rowR4_0000_000_18,rowR4_0000_000_19,rowR4_0000_000_20,rowR4_0000_000_21,rowR4_0000_000_22,rowR4_0000_000_23,rowR4_0000_000_24,rowR4_0000_000_25,rowR4_0000_000_26,rowR4_0000_000_27,rowR4_0000_000_28,rowR4_0000_000_29,rowR4_0000_000_30,rowR4_0000_000_31,rowR4_0000_000_32,rowR4_0000_000_33,rowR4_0000_000_34,rowR4_0000_000_35,rowR4_0000_000_36,rowR4_0000_000_37,rowR4_0000_000_38,rowR4_0000_000_39,rowR4_0000_000_40,rowR4_0000_000_41,rowR4_0000_000_42,rowR4_0000_000_43,rowR4_0000_000_44,rowR4_0000_000_45,rowR4_0000_000_46,rowR4_0000_000_47]

theorem rowsR4_0000_000_valid : RowListValid level5 {0,1,17,34} rowsR4_0000_000 := by
  intro r hr
  simp only [rowsR4_0000_000, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR4_0000_000_0_valid
  · exact rowR4_0000_000_1_valid
  · exact rowR4_0000_000_2_valid
  · exact rowR4_0000_000_3_valid
  · exact rowR4_0000_000_4_valid
  · exact rowR4_0000_000_5_valid
  · exact rowR4_0000_000_6_valid
  · exact rowR4_0000_000_7_valid
  · exact rowR4_0000_000_8_valid
  · exact rowR4_0000_000_9_valid
  · exact rowR4_0000_000_10_valid
  · exact rowR4_0000_000_11_valid
  · exact rowR4_0000_000_12_valid
  · exact rowR4_0000_000_13_valid
  · exact rowR4_0000_000_14_valid
  · exact rowR4_0000_000_15_valid
  · exact rowR4_0000_000_16_valid
  · exact rowR4_0000_000_17_valid
  · exact rowR4_0000_000_18_valid
  · exact rowR4_0000_000_19_valid
  · exact rowR4_0000_000_20_valid
  · exact rowR4_0000_000_21_valid
  · exact rowR4_0000_000_22_valid
  · exact rowR4_0000_000_23_valid
  · exact rowR4_0000_000_24_valid
  · exact rowR4_0000_000_25_valid
  · exact rowR4_0000_000_26_valid
  · exact rowR4_0000_000_27_valid
  · exact rowR4_0000_000_28_valid
  · exact rowR4_0000_000_29_valid
  · exact rowR4_0000_000_30_valid
  · exact rowR4_0000_000_31_valid
  · exact rowR4_0000_000_32_valid
  · exact rowR4_0000_000_33_valid
  · exact rowR4_0000_000_34_valid
  · exact rowR4_0000_000_35_valid
  · exact rowR4_0000_000_36_valid
  · exact rowR4_0000_000_37_valid
  · exact rowR4_0000_000_38_valid
  · exact rowR4_0000_000_39_valid
  · exact rowR4_0000_000_40_valid
  · exact rowR4_0000_000_41_valid
  · exact rowR4_0000_000_42_valid
  · exact rowR4_0000_000_43_valid
  · exact rowR4_0000_000_44_valid
  · exact rowR4_0000_000_45_valid
  · exact rowR4_0000_000_46_valid
  · exact rowR4_0000_000_47_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
