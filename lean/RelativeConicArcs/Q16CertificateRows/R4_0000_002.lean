import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR4_0000_002_0 : ExtensionRow := { move := 168, child := 2, matrix := ![1,0,0,0,2,0,0,0,6], witnesses := [{ source := 0, target := 0, scalar := 6 },{ source := 1, target := 1, scalar := 2 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 55, scalar := 1 },{ source := 168, target := 34, scalar := 1 }] }
theorem rowR4_0000_002_0_valid : (rowR4_0000_002_0).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_1 : ExtensionRow := { move := 169, child := 0, matrix := ![1,0,1,1,0,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 169, target := 52, scalar := 9 }] }
theorem rowR4_0000_002_1_valid : (rowR4_0000_002_1).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_2 : ExtensionRow := { move := 171, child := 2, matrix := ![0,14,14,15,15,0,0,2,0], witnesses := [{ source := 0, target := 17, scalar := 14 },{ source := 1, target := 55, scalar := 14 },{ source := 17, target := 1, scalar := 15 },{ source := 34, target := 0, scalar := 2 },{ source := 171, target := 34, scalar := 1 }] }
theorem rowR4_0000_002_2_valid : (rowR4_0000_002_2).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_3 : ExtensionRow := { move := 172, child := 1, matrix := ![0,1,0,1,0,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 172, target := 54, scalar := 9 }] }
theorem rowR4_0000_002_3_valid : (rowR4_0000_002_3).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_4 : ExtensionRow := { move := 173, child := 2, matrix := ![1,1,0,1,2,0,1,6,7], witnesses := [{ source := 0, target := 0, scalar := 7 },{ source := 1, target := 55, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 3 },{ source := 173, target := 17, scalar := 8 }] }
theorem rowR4_0000_002_4_valid : (rowR4_0000_002_4).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_5 : ExtensionRow := { move := 174, child := 0, matrix := ![0,14,15,14,15,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 52, scalar := 14 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 34, scalar := 1 },{ source := 174, target := 0, scalar := 9 }] }
theorem rowR4_0000_002_5_valid : (rowR4_0000_002_5).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_6 : ExtensionRow := { move := 175, child := 0, matrix := ![0,1,8,0,1,0,9,1,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 9 },{ source := 34, target := 52, scalar := 9 },{ source := 175, target := 1, scalar := 9 }] }
theorem rowR4_0000_002_6_valid : (rowR4_0000_002_6).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_7 : ExtensionRow := { move := 176, child := 2, matrix := ![1,0,8,1,0,0,1,2,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 0, scalar := 2 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 55, scalar := 9 },{ source := 176, target := 1, scalar := 1 }] }
theorem rowR4_0000_002_7_valid : (rowR4_0000_002_7).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_8 : ExtensionRow := { move := 179, child := 2, matrix := ![1,0,9,1,0,1,1,2,3], witnesses := [{ source := 0, target := 55, scalar := 9 },{ source := 1, target := 0, scalar := 2 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 8 },{ source := 179, target := 1, scalar := 3 }] }
theorem rowR4_0000_002_8_valid : (rowR4_0000_002_8).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_9 : ExtensionRow := { move := 180, child := 2, matrix := ![0,0,1,3,0,1,0,7,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 0, scalar := 7 },{ source := 17, target := 1, scalar := 3 },{ source := 34, target := 55, scalar := 1 },{ source := 180, target := 17, scalar := 3 }] }
theorem rowR4_0000_002_9_valid : (rowR4_0000_002_9).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_10 : ExtensionRow := { move := 181, child := 1, matrix := ![11,0,11,5,5,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 1, scalar := 5 },{ source := 17, target := 54, scalar := 11 },{ source := 34, target := 0, scalar := 1 },{ source := 181, target := 34, scalar := 1 }] }
theorem rowR4_0000_002_10_valid : (rowR4_0000_002_10).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_11 : ExtensionRow := { move := 182, child := 2, matrix := ![0,1,1,0,1,2,7,1,6], witnesses := [{ source := 0, target := 55, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 7 },{ source := 34, target := 1, scalar := 3 },{ source := 182, target := 17, scalar := 15 }] }
theorem rowR4_0000_002_11_valid : (rowR4_0000_002_11).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_12 : ExtensionRow := { move := 183, child := 2, matrix := ![0,0,1,0,1,1,1,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 183, target := 55, scalar := 6 }] }
theorem rowR4_0000_002_12_valid : (rowR4_0000_002_12).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_13 : ExtensionRow := { move := 184, child := 2, matrix := ![6,0,7,0,15,14,0,0,1], witnesses := [{ source := 0, target := 55, scalar := 7 },{ source := 1, target := 1, scalar := 15 },{ source := 17, target := 17, scalar := 6 },{ source := 34, target := 34, scalar := 1 },{ source := 184, target := 0, scalar := 7 }] }
theorem rowR4_0000_002_13_valid : (rowR4_0000_002_13).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_14 : ExtensionRow := { move := 185, child := 1, matrix := ![1,0,1,1,0,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 185, target := 54, scalar := 9 }] }
theorem rowR4_0000_002_14_valid : (rowR4_0000_002_14).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_15 : ExtensionRow := { move := 186, child := 2, matrix := ![0,14,14,15,0,15,0,0,2], witnesses := [{ source := 0, target := 55, scalar := 14 },{ source := 1, target := 17, scalar := 14 },{ source := 17, target := 1, scalar := 15 },{ source := 34, target := 0, scalar := 2 },{ source := 186, target := 34, scalar := 1 }] }
theorem rowR4_0000_002_15_valid : (rowR4_0000_002_15).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_16 : ExtensionRow := { move := 188, child := 1, matrix := ![0,11,10,4,5,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 10 },{ source := 1, target := 54, scalar := 11 },{ source := 17, target := 1, scalar := 4 },{ source := 34, target := 34, scalar := 1 },{ source := 188, target := 0, scalar := 10 }] }
theorem rowR4_0000_002_16_valid : (rowR4_0000_002_16).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_17 : ExtensionRow := { move := 189, child := 1, matrix := ![0,1,8,0,1,0,10,1,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 10 },{ source := 34, target := 54, scalar := 9 },{ source := 189, target := 1, scalar := 10 }] }
theorem rowR4_0000_002_17_valid : (rowR4_0000_002_17).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_18 : ExtensionRow := { move := 190, child := 2, matrix := ![8,9,1,0,1,1,0,3,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 55, scalar := 9 },{ source := 17, target := 17, scalar := 8 },{ source := 34, target := 0, scalar := 2 },{ source := 190, target := 1, scalar := 7 }] }
theorem rowR4_0000_002_18_valid : (rowR4_0000_002_18).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_19 : ExtensionRow := { move := 191, child := 2, matrix := ![7,6,1,14,0,1,1,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 6 },{ source := 17, target := 55, scalar := 7 },{ source := 34, target := 1, scalar := 15 },{ source := 191, target := 0, scalar := 15 }] }
theorem rowR4_0000_002_19_valid : (rowR4_0000_002_19).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_20 : ExtensionRow := { move := 192, child := 0, matrix := ![1,8,9,1,0,1,1,0,8], witnesses := [{ source := 0, target := 52, scalar := 9 },{ source := 1, target := 17, scalar := 8 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 9 },{ source := 192, target := 1, scalar := 14 }] }
theorem rowR4_0000_002_20_valid : (rowR4_0000_002_20).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_21 : ExtensionRow := { move := 195, child := 2, matrix := ![1,0,1,2,0,1,6,7,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 0, scalar := 7 },{ source := 17, target := 55, scalar := 1 },{ source := 34, target := 1, scalar := 3 },{ source := 195, target := 17, scalar := 3 }] }
theorem rowR4_0000_002_21_valid : (rowR4_0000_002_21).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_22 : ExtensionRow := { move := 196, child := 2, matrix := ![8,0,9,0,0,1,0,2,3], witnesses := [{ source := 0, target := 55, scalar := 9 },{ source := 1, target := 0, scalar := 2 },{ source := 17, target := 17, scalar := 8 },{ source := 34, target := 34, scalar := 1 },{ source := 196, target := 1, scalar := 3 }] }
theorem rowR4_0000_002_22_valid : (rowR4_0000_002_22).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_23 : ExtensionRow := { move := 197, child := 2, matrix := ![0,1,1,3,1,2,0,1,6], witnesses := [{ source := 0, target := 55, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 3 },{ source := 34, target := 0, scalar := 7 },{ source := 197, target := 17, scalar := 15 }] }
theorem rowR4_0000_002_23_valid : (rowR4_0000_002_23).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_24 : ExtensionRow := { move := 198, child := 1, matrix := ![0,0,11,0,5,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 1, scalar := 5 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 54, scalar := 11 },{ source := 198, target := 34, scalar := 1 }] }
theorem rowR4_0000_002_24_valid : (rowR4_0000_002_24).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_25 : ExtensionRow := { move := 199, child := 2, matrix := ![1,0,7,1,15,14,1,0,1], witnesses := [{ source := 0, target := 55, scalar := 7 },{ source := 1, target := 1, scalar := 15 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 6 },{ source := 199, target := 0, scalar := 7 }] }
theorem rowR4_0000_002_25_valid : (rowR4_0000_002_25).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_26 : ExtensionRow := { move := 200, child := 2, matrix := ![1,0,1,0,1,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 200, target := 55, scalar := 6 }] }
theorem rowR4_0000_002_26_valid : (rowR4_0000_002_26).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_27 : ExtensionRow := { move := 201, child := 2, matrix := ![0,14,14,0,0,15,2,0,2], witnesses := [{ source := 0, target := 55, scalar := 14 },{ source := 1, target := 17, scalar := 14 },{ source := 17, target := 0, scalar := 2 },{ source := 34, target := 1, scalar := 15 },{ source := 201, target := 34, scalar := 1 }] }
theorem rowR4_0000_002_27_valid : (rowR4_0000_002_27).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_28 : ExtensionRow := { move := 202, child := 1, matrix := ![0,0,1,1,0,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 202, target := 54, scalar := 9 }] }
theorem rowR4_0000_002_28_valid : (rowR4_0000_002_28).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_29 : ExtensionRow := { move := 203, child := 1, matrix := ![1,11,10,1,5,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 10 },{ source := 1, target := 54, scalar := 11 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 4 },{ source := 203, target := 0, scalar := 10 }] }
theorem rowR4_0000_002_29_valid : (rowR4_0000_002_29).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_30 : ExtensionRow := { move := 205, child := 2, matrix := ![0,9,1,0,1,1,2,3,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 55, scalar := 9 },{ source := 17, target := 0, scalar := 2 },{ source := 34, target := 17, scalar := 8 },{ source := 205, target := 1, scalar := 7 }] }
theorem rowR4_0000_002_30_valid : (rowR4_0000_002_30).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_31 : ExtensionRow := { move := 206, child := 1, matrix := ![9,1,8,1,1,0,11,1,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 54, scalar := 9 },{ source := 34, target := 0, scalar := 10 },{ source := 206, target := 1, scalar := 10 }] }
theorem rowR4_0000_002_31_valid : (rowR4_0000_002_31).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_32 : ExtensionRow := { move := 207, child := 0, matrix := ![0,8,9,0,0,1,9,0,8], witnesses := [{ source := 0, target := 52, scalar := 9 },{ source := 1, target := 17, scalar := 8 },{ source := 17, target := 0, scalar := 9 },{ source := 34, target := 34, scalar := 1 },{ source := 207, target := 1, scalar := 14 }] }
theorem rowR4_0000_002_32_valid : (rowR4_0000_002_32).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_33 : ExtensionRow := { move := 208, child := 2, matrix := ![0,6,1,15,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 6 },{ source := 17, target := 1, scalar := 15 },{ source := 34, target := 55, scalar := 7 },{ source := 208, target := 0, scalar := 15 }] }
theorem rowR4_0000_002_33_valid : (rowR4_0000_002_33).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_34 : ExtensionRow := { move := 211, child := 2, matrix := ![0,6,7,15,0,14,0,0,1], witnesses := [{ source := 0, target := 55, scalar := 7 },{ source := 1, target := 17, scalar := 6 },{ source := 17, target := 1, scalar := 15 },{ source := 34, target := 34, scalar := 1 },{ source := 211, target := 0, scalar := 2 }] }
theorem rowR4_0000_002_34_valid : (rowR4_0000_002_34).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_35 : ExtensionRow := { move := 212, child := 2, matrix := ![9,8,1,1,0,1,3,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 8 },{ source := 17, target := 55, scalar := 9 },{ source := 34, target := 0, scalar := 2 },{ source := 212, target := 1, scalar := 2 }] }
theorem rowR4_0000_002_35_valid : (rowR4_0000_002_35).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_36 : ExtensionRow := { move := 213, child := 2, matrix := ![6,7,1,0,14,1,0,1,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 55, scalar := 7 },{ source := 17, target := 17, scalar := 6 },{ source := 34, target := 1, scalar := 15 },{ source := 213, target := 0, scalar := 8 }] }
theorem rowR4_0000_002_36_valid : (rowR4_0000_002_36).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_37 : ExtensionRow := { move := 214, child := 1, matrix := ![0,2,2,4,4,0,0,10,0], witnesses := [{ source := 0, target := 17, scalar := 2 },{ source := 1, target := 54, scalar := 2 },{ source := 17, target := 1, scalar := 4 },{ source := 34, target := 0, scalar := 10 },{ source := 214, target := 34, scalar := 1 }] }
theorem rowR4_0000_002_37_valid : (rowR4_0000_002_37).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_38 : ExtensionRow := { move := 215, child := 2, matrix := ![6,0,6,0,12,12,0,0,7], witnesses := [{ source := 0, target := 55, scalar := 6 },{ source := 1, target := 1, scalar := 12 },{ source := 17, target := 17, scalar := 6 },{ source := 34, target := 0, scalar := 7 },{ source := 215, target := 34, scalar := 1 }] }
theorem rowR4_0000_002_38_valid : (rowR4_0000_002_38).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_39 : ExtensionRow := { move := 216, child := 2, matrix := ![0,0,1,0,3,1,7,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 1, scalar := 3 },{ source := 17, target := 0, scalar := 7 },{ source := 34, target := 55, scalar := 1 },{ source := 216, target := 17, scalar := 7 }] }
theorem rowR4_0000_002_39_valid : (rowR4_0000_002_39).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_40 : ExtensionRow := { move := 217, child := 0, matrix := ![1,15,14,1,0,15,1,0,1], witnesses := [{ source := 0, target := 52, scalar := 14 },{ source := 1, target := 17, scalar := 15 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 14 },{ source := 217, target := 0, scalar := 9 }] }
theorem rowR4_0000_002_40_valid : (rowR4_0000_002_40).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_41 : ExtensionRow := { move := 218, child := 2, matrix := ![1,0,1,1,0,2,1,7,6], witnesses := [{ source := 0, target := 55, scalar := 1 },{ source := 1, target := 0, scalar := 7 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 3 },{ source := 218, target := 17, scalar := 8 }] }
theorem rowR4_0000_002_41_valid : (rowR4_0000_002_41).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_42 : ExtensionRow := { move := 219, child := 1, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 219, target := 54, scalar := 6 }] }
theorem rowR4_0000_002_42_valid : (rowR4_0000_002_42).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_43 : ExtensionRow := { move := 220, child := 2, matrix := ![0,1,9,0,1,1,2,1,3], witnesses := [{ source := 0, target := 55, scalar := 9 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 2 },{ source := 34, target := 17, scalar := 8 },{ source := 220, target := 1, scalar := 7 }] }
theorem rowR4_0000_002_43_valid : (rowR4_0000_002_43).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_44 : ExtensionRow := { move := 222, child := 1, matrix := ![11,0,10,5,4,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 10 },{ source := 1, target := 1, scalar := 4 },{ source := 17, target := 54, scalar := 11 },{ source := 34, target := 34, scalar := 1 },{ source := 222, target := 0, scalar := 1 }] }
theorem rowR4_0000_002_44_valid : (rowR4_0000_002_44).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_45 : ExtensionRow := { move := 223, child := 2, matrix := ![0,0,1,1,0,1,0,1,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 223, target := 55, scalar := 14 }] }
theorem rowR4_0000_002_45_valid : (rowR4_0000_002_45).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_46 : ExtensionRow := { move := 224, child := 1, matrix := ![1,0,8,1,0,0,1,10,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 0, scalar := 10 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 54, scalar := 9 },{ source := 224, target := 1, scalar := 1 }] }
theorem rowR4_0000_002_46_valid : (rowR4_0000_002_46).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowR4_0000_002_47 : ExtensionRow := { move := 227, child := 2, matrix := ![0,8,1,0,0,1,2,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 8 },{ source := 17, target := 0, scalar := 2 },{ source := 34, target := 55, scalar := 9 },{ source := 227, target := 1, scalar := 2 }] }
theorem rowR4_0000_002_47_valid : (rowR4_0000_002_47).ValidFor level5 {0,1,17,34} := by decide

noncomputable def rowsR4_0000_002 : List ExtensionRow := [rowR4_0000_002_0,rowR4_0000_002_1,rowR4_0000_002_2,rowR4_0000_002_3,rowR4_0000_002_4,rowR4_0000_002_5,rowR4_0000_002_6,rowR4_0000_002_7,rowR4_0000_002_8,rowR4_0000_002_9,rowR4_0000_002_10,rowR4_0000_002_11,rowR4_0000_002_12,rowR4_0000_002_13,rowR4_0000_002_14,rowR4_0000_002_15,rowR4_0000_002_16,rowR4_0000_002_17,rowR4_0000_002_18,rowR4_0000_002_19,rowR4_0000_002_20,rowR4_0000_002_21,rowR4_0000_002_22,rowR4_0000_002_23,rowR4_0000_002_24,rowR4_0000_002_25,rowR4_0000_002_26,rowR4_0000_002_27,rowR4_0000_002_28,rowR4_0000_002_29,rowR4_0000_002_30,rowR4_0000_002_31,rowR4_0000_002_32,rowR4_0000_002_33,rowR4_0000_002_34,rowR4_0000_002_35,rowR4_0000_002_36,rowR4_0000_002_37,rowR4_0000_002_38,rowR4_0000_002_39,rowR4_0000_002_40,rowR4_0000_002_41,rowR4_0000_002_42,rowR4_0000_002_43,rowR4_0000_002_44,rowR4_0000_002_45,rowR4_0000_002_46,rowR4_0000_002_47]

theorem rowsR4_0000_002_valid : RowListValid level5 {0,1,17,34} rowsR4_0000_002 := by
  intro r hr
  simp only [rowsR4_0000_002, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR4_0000_002_0_valid
  · exact rowR4_0000_002_1_valid
  · exact rowR4_0000_002_2_valid
  · exact rowR4_0000_002_3_valid
  · exact rowR4_0000_002_4_valid
  · exact rowR4_0000_002_5_valid
  · exact rowR4_0000_002_6_valid
  · exact rowR4_0000_002_7_valid
  · exact rowR4_0000_002_8_valid
  · exact rowR4_0000_002_9_valid
  · exact rowR4_0000_002_10_valid
  · exact rowR4_0000_002_11_valid
  · exact rowR4_0000_002_12_valid
  · exact rowR4_0000_002_13_valid
  · exact rowR4_0000_002_14_valid
  · exact rowR4_0000_002_15_valid
  · exact rowR4_0000_002_16_valid
  · exact rowR4_0000_002_17_valid
  · exact rowR4_0000_002_18_valid
  · exact rowR4_0000_002_19_valid
  · exact rowR4_0000_002_20_valid
  · exact rowR4_0000_002_21_valid
  · exact rowR4_0000_002_22_valid
  · exact rowR4_0000_002_23_valid
  · exact rowR4_0000_002_24_valid
  · exact rowR4_0000_002_25_valid
  · exact rowR4_0000_002_26_valid
  · exact rowR4_0000_002_27_valid
  · exact rowR4_0000_002_28_valid
  · exact rowR4_0000_002_29_valid
  · exact rowR4_0000_002_30_valid
  · exact rowR4_0000_002_31_valid
  · exact rowR4_0000_002_32_valid
  · exact rowR4_0000_002_33_valid
  · exact rowR4_0000_002_34_valid
  · exact rowR4_0000_002_35_valid
  · exact rowR4_0000_002_36_valid
  · exact rowR4_0000_002_37_valid
  · exact rowR4_0000_002_38_valid
  · exact rowR4_0000_002_39_valid
  · exact rowR4_0000_002_40_valid
  · exact rowR4_0000_002_41_valid
  · exact rowR4_0000_002_42_valid
  · exact rowR4_0000_002_43_valid
  · exact rowR4_0000_002_44_valid
  · exact rowR4_0000_002_45_valid
  · exact rowR4_0000_002_46_valid
  · exact rowR4_0000_002_47_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
