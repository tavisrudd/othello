import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR4_0000_001_0 : ExtensionRow := { move := 109, child := 1, matrix := ![1,9,8,1,1,0,1,11,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 54, scalar := 9 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 10 },{ source := 109, target := 1, scalar := 4 }] }
theorem rowR4_0000_001_0_valid : (rowR4_0000_001_0).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_1 : ExtensionRow := { move := 110, child := 2, matrix := ![0,1,7,15,1,14,0,1,1], witnesses := [{ source := 0, target := 55, scalar := 7 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 15 },{ source := 34, target := 17, scalar := 6 },{ source := 110, target := 0, scalar := 8 }] }
theorem rowR4_0000_001_1_valid : (rowR4_0000_001_1).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_2 : ExtensionRow := { move := 111, child := 2, matrix := ![8,0,8,0,0,3,0,5,5], witnesses := [{ source := 0, target := 55, scalar := 8 },{ source := 1, target := 0, scalar := 5 },{ source := 17, target := 17, scalar := 8 },{ source := 34, target := 1, scalar := 3 },{ source := 111, target := 34, scalar := 1 }] }
theorem rowR4_0000_001_2_valid : (rowR4_0000_001_2).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_3 : ExtensionRow := { move := 112, child := 2, matrix := ![0,8,9,0,0,1,2,0,3], witnesses := [{ source := 0, target := 55, scalar := 9 },{ source := 1, target := 17, scalar := 8 },{ source := 17, target := 0, scalar := 2 },{ source := 34, target := 34, scalar := 1 },{ source := 112, target := 1, scalar := 15 }] }
theorem rowR4_0000_001_3_valid : (rowR4_0000_001_3).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_4 : ExtensionRow := { move := 115, child := 2, matrix := ![1,0,0,0,0,1,0,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 115, target := 55, scalar := 1 }] }
theorem rowR4_0000_001_4_valid : (rowR4_0000_001_4).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_5 : ExtensionRow := { move := 116, child := 2, matrix := ![0,7,0,0,0,14,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 14 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 55, scalar := 7 },{ source := 116, target := 34, scalar := 1 }] }
theorem rowR4_0000_001_5_valid : (rowR4_0000_001_5).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_6 : ExtensionRow := { move := 117, child := 2, matrix := ![0,1,0,0,2,3,7,6,0], witnesses := [{ source := 0, target := 1, scalar := 3 },{ source := 1, target := 55, scalar := 1 },{ source := 17, target := 0, scalar := 7 },{ source := 34, target := 34, scalar := 1 },{ source := 117, target := 17, scalar := 6 }] }
theorem rowR4_0000_001_6_valid : (rowR4_0000_001_6).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_7 : ExtensionRow := { move := 118, child := 2, matrix := ![6,1,0,0,1,15,0,1,0], witnesses := [{ source := 0, target := 1, scalar := 15 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 17, scalar := 6 },{ source := 34, target := 55, scalar := 7 },{ source := 118, target := 0, scalar := 6 }] }
theorem rowR4_0000_001_7_valid : (rowR4_0000_001_7).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_8 : ExtensionRow := { move := 120, child := 3, matrix := ![0,0,6,0,7,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 1, scalar := 7 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 120, scalar := 6 },{ source := 120, target := 34, scalar := 1 }] }
theorem rowR4_0000_001_8_valid : (rowR4_0000_001_8).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_9 : ExtensionRow := { move := 121, child := 2, matrix := ![1,0,0,2,0,2,6,6,0], witnesses := [{ source := 0, target := 1, scalar := 2 },{ source := 1, target := 0, scalar := 6 },{ source := 17, target := 55, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 121, target := 34, scalar := 1 }] }
theorem rowR4_0000_001_9_valid : (rowR4_0000_001_9).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_10 : ExtensionRow := { move := 122, child := 2, matrix := ![7,6,0,14,0,15,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 15 },{ source := 1, target := 17, scalar := 6 },{ source := 17, target := 55, scalar := 7 },{ source := 34, target := 34, scalar := 1 },{ source := 122, target := 0, scalar := 1 }] }
theorem rowR4_0000_001_10_valid : (rowR4_0000_001_10).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_11 : ExtensionRow := { move := 123, child := 2, matrix := ![0,1,0,0,1,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 123, target := 55, scalar := 6 }] }
theorem rowR4_0000_001_11_valid : (rowR4_0000_001_11).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_12 : ExtensionRow := { move := 124, child := 2, matrix := ![1,7,0,1,14,15,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 15 },{ source := 1, target := 55, scalar := 7 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 6 },{ source := 124, target := 0, scalar := 7 }] }
theorem rowR4_0000_001_12_valid : (rowR4_0000_001_12).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_13 : ExtensionRow := { move := 125, child := 2, matrix := ![6,6,0,0,12,12,0,7,0], witnesses := [{ source := 0, target := 1, scalar := 12 },{ source := 1, target := 55, scalar := 6 },{ source := 17, target := 17, scalar := 6 },{ source := 34, target := 0, scalar := 7 },{ source := 125, target := 34, scalar := 1 }] }
theorem rowR4_0000_001_13_valid : (rowR4_0000_001_13).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_14 : ExtensionRow := { move := 126, child := 2, matrix := ![1,1,0,2,1,3,6,1,0], witnesses := [{ source := 0, target := 1, scalar := 3 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 55, scalar := 1 },{ source := 34, target := 0, scalar := 7 },{ source := 126, target := 17, scalar := 7 }] }
theorem rowR4_0000_001_14_valid : (rowR4_0000_001_14).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_15 : ExtensionRow := { move := 127, child := 2, matrix := ![1,0,0,1,0,3,1,7,0], witnesses := [{ source := 0, target := 1, scalar := 3 },{ source := 1, target := 0, scalar := 7 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 55, scalar := 1 },{ source := 127, target := 17, scalar := 1 }] }
theorem rowR4_0000_001_15_valid : (rowR4_0000_001_15).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_16 : ExtensionRow := { move := 128, child := 2, matrix := ![1,1,0,1,0,1,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 128, target := 55, scalar := 7 }] }
theorem rowR4_0000_001_16_valid : (rowR4_0000_001_16).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_17 : ExtensionRow := { move := 131, child := 2, matrix := ![7,7,0,14,0,14,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 14 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 55, scalar := 7 },{ source := 34, target := 0, scalar := 1 },{ source := 131, target := 34, scalar := 1 }] }
theorem rowR4_0000_001_17_valid : (rowR4_0000_001_17).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_18 : ExtensionRow := { move := 132, child := 2, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 132, target := 55, scalar := 1 }] }
theorem rowR4_0000_001_18_valid : (rowR4_0000_001_18).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_19 : ExtensionRow := { move := 133, child := 2, matrix := ![7,1,0,14,1,15,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 15 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 55, scalar := 7 },{ source := 34, target := 17, scalar := 6 },{ source := 133, target := 0, scalar := 6 }] }
theorem rowR4_0000_001_19_valid : (rowR4_0000_001_19).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_20 : ExtensionRow := { move := 134, child := 2, matrix := ![1,1,0,1,2,3,1,6,0], witnesses := [{ source := 0, target := 1, scalar := 3 },{ source := 1, target := 55, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 7 },{ source := 134, target := 17, scalar := 6 }] }
theorem rowR4_0000_001_20_valid : (rowR4_0000_001_20).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_21 : ExtensionRow := { move := 135, child := 3, matrix := ![0,0,1,0,1,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 135, target := 120, scalar := 6 }] }
theorem rowR4_0000_001_21_valid : (rowR4_0000_001_21).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_22 : ExtensionRow := { move := 137, child := 2, matrix := ![1,6,0,1,0,15,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 15 },{ source := 1, target := 17, scalar := 6 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 55, scalar := 7 },{ source := 137, target := 0, scalar := 1 }] }
theorem rowR4_0000_001_22_valid : (rowR4_0000_001_22).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_23 : ExtensionRow := { move := 138, child := 2, matrix := ![1,0,0,0,0,2,0,6,0], witnesses := [{ source := 0, target := 1, scalar := 2 },{ source := 1, target := 0, scalar := 6 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 55, scalar := 1 },{ source := 138, target := 34, scalar := 1 }] }
theorem rowR4_0000_001_23_valid : (rowR4_0000_001_23).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_24 : ExtensionRow := { move := 139, child := 2, matrix := ![6,7,0,0,14,15,0,1,0], witnesses := [{ source := 0, target := 1, scalar := 15 },{ source := 1, target := 55, scalar := 7 },{ source := 17, target := 17, scalar := 6 },{ source := 34, target := 34, scalar := 1 },{ source := 139, target := 0, scalar := 7 }] }
theorem rowR4_0000_001_24_valid : (rowR4_0000_001_24).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_25 : ExtensionRow := { move := 140, child := 2, matrix := ![1,1,0,0,1,1,0,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 140, target := 55, scalar := 6 }] }
theorem rowR4_0000_001_25_valid : (rowR4_0000_001_25).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_26 : ExtensionRow := { move := 141, child := 2, matrix := ![0,1,0,0,1,3,7,1,0], witnesses := [{ source := 0, target := 1, scalar := 3 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 7 },{ source := 34, target := 55, scalar := 1 },{ source := 141, target := 17, scalar := 7 }] }
theorem rowR4_0000_001_26_valid : (rowR4_0000_001_26).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_27 : ExtensionRow := { move := 142, child := 2, matrix := ![0,6,0,0,12,12,7,7,0], witnesses := [{ source := 0, target := 1, scalar := 12 },{ source := 1, target := 55, scalar := 6 },{ source := 17, target := 0, scalar := 7 },{ source := 34, target := 17, scalar := 6 },{ source := 142, target := 34, scalar := 1 }] }
theorem rowR4_0000_001_27_valid : (rowR4_0000_001_27).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_28 : ExtensionRow := { move := 143, child := 2, matrix := ![0,1,0,0,0,1,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 143, target := 55, scalar := 7 }] }
theorem rowR4_0000_001_28_valid : (rowR4_0000_001_28).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_29 : ExtensionRow := { move := 144, child := 2, matrix := ![1,0,0,2,0,3,6,7,0], witnesses := [{ source := 0, target := 1, scalar := 3 },{ source := 1, target := 0, scalar := 7 },{ source := 17, target := 55, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 144, target := 17, scalar := 1 }] }
theorem rowR4_0000_001_29_valid : (rowR4_0000_001_29).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_30 : ExtensionRow := { move := 147, child := 2, matrix := ![1,1,0,1,0,0,1,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 147, target := 55, scalar := 9 }] }
theorem rowR4_0000_001_30_valid : (rowR4_0000_001_30).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_31 : ExtensionRow := { move := 148, child := 0, matrix := ![0,0,14,0,15,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 14 },{ source := 1, target := 1, scalar := 15 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 52, scalar := 14 },{ source := 148, target := 34, scalar := 1 }] }
theorem rowR4_0000_001_31_valid : (rowR4_0000_001_31).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_32 : ExtensionRow := { move := 149, child := 2, matrix := ![8,1,0,0,1,0,0,1,2], witnesses := [{ source := 0, target := 0, scalar := 2 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 17, scalar := 8 },{ source := 34, target := 55, scalar := 9 },{ source := 149, target := 1, scalar := 8 }] }
theorem rowR4_0000_001_32_valid : (rowR4_0000_001_32).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_33 : ExtensionRow := { move := 150, child := 2, matrix := ![0,1,1,1,1,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 150, target := 55, scalar := 13 }] }
theorem rowR4_0000_001_33_valid : (rowR4_0000_001_33).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_34 : ExtensionRow := { move := 151, child := 2, matrix := ![1,0,0,2,2,0,6,0,6], witnesses := [{ source := 0, target := 0, scalar := 6 },{ source := 1, target := 1, scalar := 2 },{ source := 17, target := 55, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 151, target := 34, scalar := 1 }] }
theorem rowR4_0000_001_34_valid : (rowR4_0000_001_34).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_35 : ExtensionRow := { move := 152, child := 2, matrix := ![1,0,6,1,15,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 1, scalar := 15 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 55, scalar := 7 },{ source := 152, target := 0, scalar := 1 }] }
theorem rowR4_0000_001_35_valid : (rowR4_0000_001_35).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_36 : ExtensionRow := { move := 154, child := 0, matrix := ![0,0,1,1,0,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 154, target := 52, scalar := 9 }] }
theorem rowR4_0000_001_36_valid : (rowR4_0000_001_36).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_37 : ExtensionRow := { move := 155, child := 1, matrix := ![1,1,0,1,0,0,1,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 155, target := 54, scalar := 9 }] }
theorem rowR4_0000_001_37_valid : (rowR4_0000_001_37).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_38 : ExtensionRow := { move := 156, child := 2, matrix := ![0,14,14,0,15,0,2,2,0], witnesses := [{ source := 0, target := 17, scalar := 14 },{ source := 1, target := 55, scalar := 14 },{ source := 17, target := 0, scalar := 2 },{ source := 34, target := 1, scalar := 15 },{ source := 156, target := 34, scalar := 1 }] }
theorem rowR4_0000_001_38_valid : (rowR4_0000_001_38).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_39 : ExtensionRow := { move := 157, child := 0, matrix := ![1,14,15,1,15,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 52, scalar := 14 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 14 },{ source := 157, target := 0, scalar := 9 }] }
theorem rowR4_0000_001_39_valid : (rowR4_0000_001_39).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_40 : ExtensionRow := { move := 158, child := 2, matrix := ![0,1,0,3,2,0,0,6,7], witnesses := [{ source := 0, target := 0, scalar := 7 },{ source := 1, target := 55, scalar := 1 },{ source := 17, target := 1, scalar := 3 },{ source := 34, target := 34, scalar := 1 },{ source := 158, target := 17, scalar := 8 }] }
theorem rowR4_0000_001_40_valid : (rowR4_0000_001_40).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_41 : ExtensionRow := { move := 159, child := 2, matrix := ![9,0,8,1,0,0,3,2,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 0, scalar := 2 },{ source := 17, target := 55, scalar := 9 },{ source := 34, target := 34, scalar := 1 },{ source := 159, target := 1, scalar := 1 }] }
theorem rowR4_0000_001_41_valid : (rowR4_0000_001_41).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_42 : ExtensionRow := { move := 160, child := 0, matrix := ![9,1,8,1,1,0,8,1,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 9 },{ source := 34, target := 0, scalar := 9 },{ source := 160, target := 1, scalar := 9 }] }
theorem rowR4_0000_001_42_valid : (rowR4_0000_001_42).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_43 : ExtensionRow := { move := 163, child := 0, matrix := ![14,0,14,15,15,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 14 },{ source := 1, target := 1, scalar := 15 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 0, scalar := 1 },{ source := 163, target := 34, scalar := 1 }] }
theorem rowR4_0000_001_43_valid : (rowR4_0000_001_43).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_44 : ExtensionRow := { move := 164, child := 2, matrix := ![0,1,0,1,0,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 164, target := 55, scalar := 9 }] }
theorem rowR4_0000_001_44_valid : (rowR4_0000_001_44).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_45 : ExtensionRow := { move := 165, child := 2, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 165, target := 55, scalar := 13 }] }
theorem rowR4_0000_001_45_valid : (rowR4_0000_001_45).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_46 : ExtensionRow := { move := 166, child := 2, matrix := ![9,1,0,1,1,0,3,1,2], witnesses := [{ source := 0, target := 0, scalar := 2 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 55, scalar := 9 },{ source := 34, target := 17, scalar := 8 },{ source := 166, target := 1, scalar := 8 }] }
theorem rowR4_0000_001_46_valid : (rowR4_0000_001_46).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_001_47 : ExtensionRow := { move := 167, child := 2, matrix := ![7,0,6,14,15,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 1, scalar := 15 },{ source := 17, target := 55, scalar := 7 },{ source := 34, target := 34, scalar := 1 },{ source := 167, target := 0, scalar := 1 }] }
theorem rowR4_0000_001_47_valid : (rowR4_0000_001_47).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowsR4_0000_001 : List ExtensionRow := [rowR4_0000_001_0,rowR4_0000_001_1,rowR4_0000_001_2,rowR4_0000_001_3,rowR4_0000_001_4,rowR4_0000_001_5,rowR4_0000_001_6,rowR4_0000_001_7,rowR4_0000_001_8,rowR4_0000_001_9,rowR4_0000_001_10,rowR4_0000_001_11,rowR4_0000_001_12,rowR4_0000_001_13,rowR4_0000_001_14,rowR4_0000_001_15,rowR4_0000_001_16,rowR4_0000_001_17,rowR4_0000_001_18,rowR4_0000_001_19,rowR4_0000_001_20,rowR4_0000_001_21,rowR4_0000_001_22,rowR4_0000_001_23,rowR4_0000_001_24,rowR4_0000_001_25,rowR4_0000_001_26,rowR4_0000_001_27,rowR4_0000_001_28,rowR4_0000_001_29,rowR4_0000_001_30,rowR4_0000_001_31,rowR4_0000_001_32,rowR4_0000_001_33,rowR4_0000_001_34,rowR4_0000_001_35,rowR4_0000_001_36,rowR4_0000_001_37,rowR4_0000_001_38,rowR4_0000_001_39,rowR4_0000_001_40,rowR4_0000_001_41,rowR4_0000_001_42,rowR4_0000_001_43,rowR4_0000_001_44,rowR4_0000_001_45,rowR4_0000_001_46,rowR4_0000_001_47]

theorem rowsR4_0000_001_valid : RowListValid level5 {0,1,17,34} rowsR4_0000_001 := by
  intro r hr
  simp only [rowsR4_0000_001, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR4_0000_001_0_valid
  · exact rowR4_0000_001_1_valid
  · exact rowR4_0000_001_2_valid
  · exact rowR4_0000_001_3_valid
  · exact rowR4_0000_001_4_valid
  · exact rowR4_0000_001_5_valid
  · exact rowR4_0000_001_6_valid
  · exact rowR4_0000_001_7_valid
  · exact rowR4_0000_001_8_valid
  · exact rowR4_0000_001_9_valid
  · exact rowR4_0000_001_10_valid
  · exact rowR4_0000_001_11_valid
  · exact rowR4_0000_001_12_valid
  · exact rowR4_0000_001_13_valid
  · exact rowR4_0000_001_14_valid
  · exact rowR4_0000_001_15_valid
  · exact rowR4_0000_001_16_valid
  · exact rowR4_0000_001_17_valid
  · exact rowR4_0000_001_18_valid
  · exact rowR4_0000_001_19_valid
  · exact rowR4_0000_001_20_valid
  · exact rowR4_0000_001_21_valid
  · exact rowR4_0000_001_22_valid
  · exact rowR4_0000_001_23_valid
  · exact rowR4_0000_001_24_valid
  · exact rowR4_0000_001_25_valid
  · exact rowR4_0000_001_26_valid
  · exact rowR4_0000_001_27_valid
  · exact rowR4_0000_001_28_valid
  · exact rowR4_0000_001_29_valid
  · exact rowR4_0000_001_30_valid
  · exact rowR4_0000_001_31_valid
  · exact rowR4_0000_001_32_valid
  · exact rowR4_0000_001_33_valid
  · exact rowR4_0000_001_34_valid
  · exact rowR4_0000_001_35_valid
  · exact rowR4_0000_001_36_valid
  · exact rowR4_0000_001_37_valid
  · exact rowR4_0000_001_38_valid
  · exact rowR4_0000_001_39_valid
  · exact rowR4_0000_001_40_valid
  · exact rowR4_0000_001_41_valid
  · exact rowR4_0000_001_42_valid
  · exact rowR4_0000_001_43_valid
  · exact rowR4_0000_001_44_valid
  · exact rowR4_0000_001_45_valid
  · exact rowR4_0000_001_46_valid
  · exact rowR4_0000_001_47_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
