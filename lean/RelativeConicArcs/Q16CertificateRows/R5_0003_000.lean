import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR5_0003_000_0 : ExtensionRow := { move := 52, child := 19, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 120, target := 120, scalar := 1 }] }
theorem rowR5_0003_000_0_valid : (rowR5_0003_000_0).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_1 : ExtensionRow := { move := 53, child := 21, matrix := ![15,14,0,0,15,14,0,1,0], witnesses := [{ source := 0, target := 1, scalar := 14 },{ source := 1, target := 52, scalar := 14 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 34, scalar := 1 },{ source := 53, target := 0, scalar := 2 },{ source := 120, target := 124, scalar := 13 }] }
theorem rowR5_0003_000_1_valid : (rowR5_0003_000_1).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_2 : ExtensionRow := { move := 54, child := 21, matrix := ![8,1,2,5,1,4,7,1,6], witnesses := [{ source := 0, target := 52, scalar := 2 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 124, scalar := 8 },{ source := 34, target := 17, scalar := 11 },{ source := 54, target := 0, scalar := 8 },{ source := 120, target := 1, scalar := 12 }] }
theorem rowR5_0003_000_2_valid : (rowR5_0003_000_2).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_3 : ExtensionRow := { move := 55, child := 42, matrix := ![0,8,9,15,14,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 112, scalar := 8 },{ source := 17, target := 1, scalar := 15 },{ source := 34, target := 34, scalar := 1 },{ source := 55, target := 0, scalar := 2 },{ source := 120, target := 54, scalar := 15 }] }
theorem rowR5_0003_000_3_valid : (rowR5_0003_000_3).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_4 : ExtensionRow := { move := 58, child := 21, matrix := ![14,0,15,15,14,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 1, scalar := 14 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 34, scalar := 1 },{ source := 58, target := 0, scalar := 1 },{ source := 120, target := 124, scalar := 5 }] }
theorem rowR5_0003_000_4_valid : (rowR5_0003_000_4).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_5 : ExtensionRow := { move := 59, child := 21, matrix := ![4,0,5,0,12,13,0,0,1], witnesses := [{ source := 0, target := 124, scalar := 5 },{ source := 1, target := 1, scalar := 12 },{ source := 17, target := 17, scalar := 4 },{ source := 34, target := 34, scalar := 1 },{ source := 59, target := 0, scalar := 10 },{ source := 120, target := 52, scalar := 12 }] }
theorem rowR5_0003_000_5_valid : (rowR5_0003_000_5).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_6 : ExtensionRow := { move := 60, child := 24, matrix := ![1,0,6,1,7,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 1, scalar := 7 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 135, scalar := 7 },{ source := 60, target := 52, scalar := 14 },{ source := 120, target := 0, scalar := 1 }] }
theorem rowR5_0003_000_6_valid : (rowR5_0003_000_6).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_7 : ExtensionRow := { move := 62, child := 58, matrix := ![0,1,8,0,1,0,2,1,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 2 },{ source := 34, target := 55, scalar := 9 },{ source := 62, target := 1, scalar := 2 },{ source := 120, target := 232, scalar := 11 }] }
theorem rowR5_0003_000_7_valid : (rowR5_0003_000_7).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_8 : ExtensionRow := { move := 63, child := 39, matrix := ![12,15,3,9,13,0,6,6,0], witnesses := [{ source := 0, target := 17, scalar := 3 },{ source := 1, target := 54, scalar := 15 },{ source := 17, target := 106, scalar := 12 },{ source := 34, target := 1, scalar := 4 },{ source := 63, target := 0, scalar := 10 },{ source := 120, target := 34, scalar := 1 }] }
theorem rowR5_0003_000_8_valid : (rowR5_0003_000_8).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_9 : ExtensionRow := { move := 64, child := 21, matrix := ![15,0,1,0,14,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 1, scalar := 14 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 52, scalar := 14 },{ source := 64, target := 0, scalar := 15 },{ source := 120, target := 124, scalar := 8 }] }
theorem rowR5_0003_000_9_valid : (rowR5_0003_000_9).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_10 : ExtensionRow := { move := 67, child := 24, matrix := ![0,1,1,1,1,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 67, target := 52, scalar := 1 },{ source := 120, target := 135, scalar := 1 }] }
theorem rowR5_0003_000_10_valid : (rowR5_0003_000_10).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_11 : ExtensionRow := { move := 69, child := 21, matrix := ![1,13,12,1,8,11,1,6,7], witnesses := [{ source := 0, target := 52, scalar := 12 },{ source := 1, target := 124, scalar := 13 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 2 },{ source := 69, target := 0, scalar := 4 },{ source := 120, target := 17, scalar := 11 }] }
theorem rowR5_0003_000_11_valid : (rowR5_0003_000_11).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_12 : ExtensionRow := { move := 70, child := 21, matrix := ![0,12,4,14,11,0,0,7,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 52, scalar := 12 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 124, scalar := 8 },{ source := 70, target := 0, scalar := 9 },{ source := 120, target := 34, scalar := 1 }] }
theorem rowR5_0003_000_12_valid : (rowR5_0003_000_12).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_13 : ExtensionRow := { move := 71, child := 39, matrix := ![4,12,9,8,9,0,7,6,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 106, scalar := 12 },{ source := 17, target := 54, scalar := 4 },{ source := 34, target := 34, scalar := 1 },{ source := 71, target := 0, scalar := 13 },{ source := 120, target := 1, scalar := 11 }] }
theorem rowR5_0003_000_13_valid : (rowR5_0003_000_13).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_14 : ExtensionRow := { move := 73, child := 21, matrix := ![0,15,13,12,0,8,0,0,6], witnesses := [{ source := 0, target := 124, scalar := 13 },{ source := 1, target := 17, scalar := 15 },{ source := 17, target := 1, scalar := 12 },{ source := 34, target := 52, scalar := 2 },{ source := 73, target := 0, scalar := 5 },{ source := 120, target := 34, scalar := 1 }] }
theorem rowR5_0003_000_14_valid : (rowR5_0003_000_14).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_15 : ExtensionRow := { move := 74, child := 42, matrix := ![8,0,3,14,11,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 3 },{ source := 1, target := 1, scalar := 11 },{ source := 17, target := 112, scalar := 8 },{ source := 34, target := 54, scalar := 11 },{ source := 74, target := 0, scalar := 1 },{ source := 120, target := 34, scalar := 1 }] }
theorem rowR5_0003_000_15_valid : (rowR5_0003_000_15).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_16 : ExtensionRow := { move := 76, child := 58, matrix := ![1,0,5,1,0,0,1,14,0], witnesses := [{ source := 0, target := 17, scalar := 5 },{ source := 1, target := 0, scalar := 14 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 232, scalar := 4 },{ source := 76, target := 1, scalar := 1 },{ source := 120, target := 55, scalar := 9 }] }
theorem rowR5_0003_000_16_valid : (rowR5_0003_000_16).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_17 : ExtensionRow := { move := 77, child := 21, matrix := ![0,4,1,12,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 4 },{ source := 17, target := 1, scalar := 12 },{ source := 34, target := 124, scalar := 5 },{ source := 77, target := 0, scalar := 12 },{ source := 120, target := 52, scalar := 12 }] }
theorem rowR5_0003_000_17_valid : (rowR5_0003_000_17).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_18 : ExtensionRow := { move := 78, child := 19, matrix := ![1,0,6,1,0,0,1,7,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 0, scalar := 7 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 120, scalar := 7 },{ source := 78, target := 52, scalar := 9 },{ source := 120, target := 1, scalar := 1 }] }
theorem rowR5_0003_000_18_valid : (rowR5_0003_000_18).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_19 : ExtensionRow := { move := 79, child := 21, matrix := ![14,11,0,15,0,2,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 2 },{ source := 1, target := 17, scalar := 11 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 124, scalar := 5 },{ source := 79, target := 0, scalar := 1 },{ source := 120, target := 34, scalar := 1 }] }
theorem rowR5_0003_000_19_valid : (rowR5_0003_000_19).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_20 : ExtensionRow := { move := 83, child := 21, matrix := ![8,4,12,5,0,11,7,0,7], witnesses := [{ source := 0, target := 52, scalar := 12 },{ source := 1, target := 17, scalar := 4 },{ source := 17, target := 124, scalar := 8 },{ source := 34, target := 1, scalar := 14 },{ source := 83, target := 0, scalar := 9 },{ source := 120, target := 34, scalar := 1 }] }
theorem rowR5_0003_000_20_valid : (rowR5_0003_000_20).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_21 : ExtensionRow := { move := 84, child := 21, matrix := ![11,2,1,0,4,1,0,6,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 52, scalar := 2 },{ source := 17, target := 17, scalar := 11 },{ source := 34, target := 124, scalar := 8 },{ source := 84, target := 0, scalar := 8 },{ source := 120, target := 1, scalar := 12 }] }
theorem rowR5_0003_000_21_valid : (rowR5_0003_000_21).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_22 : ExtensionRow := { move := 86, child := 42, matrix := ![0,1,10,4,1,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 10 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 4 },{ source := 34, target := 54, scalar := 11 },{ source := 86, target := 0, scalar := 4 },{ source := 120, target := 112, scalar := 5 }] }
theorem rowR5_0003_000_22_valid : (rowR5_0003_000_22).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_23 : ExtensionRow := { move := 87, child := 24, matrix := ![1,6,7,1,1,0,1,7,0], witnesses := [{ source := 0, target := 17, scalar := 7 },{ source := 1, target := 135, scalar := 6 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 6 },{ source := 87, target := 52, scalar := 11 },{ source := 120, target := 1, scalar := 7 }] }
theorem rowR5_0003_000_23_valid : (rowR5_0003_000_23).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_24 : ExtensionRow := { move := 89, child := 58, matrix := ![0,10,5,0,7,0,2,9,0], witnesses := [{ source := 0, target := 17, scalar := 5 },{ source := 1, target := 55, scalar := 10 },{ source := 17, target := 0, scalar := 2 },{ source := 34, target := 232, scalar := 15 },{ source := 89, target := 1, scalar := 15 },{ source := 120, target := 34, scalar := 1 }] }
theorem rowR5_0003_000_24_valid : (rowR5_0003_000_24).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_25 : ExtensionRow := { move := 91, child := 21, matrix := ![11,1,8,0,1,5,0,1,7], witnesses := [{ source := 0, target := 124, scalar := 8 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 17, scalar := 11 },{ source := 34, target := 52, scalar := 2 },{ source := 91, target := 0, scalar := 7 },{ source := 120, target := 1, scalar := 14 }] }
theorem rowR5_0003_000_25_valid : (rowR5_0003_000_25).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_26 : ExtensionRow := { move := 93, child := 19, matrix := ![0,0,6,0,7,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 1, scalar := 7 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 120, scalar := 6 },{ source := 93, target := 52, scalar := 14 },{ source := 120, target := 34, scalar := 1 }] }
theorem rowR5_0003_000_26_valid : (rowR5_0003_000_26).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_27 : ExtensionRow := { move := 94, child := 21, matrix := ![2,1,11,4,1,0,6,1,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 2 },{ source := 34, target := 124, scalar := 8 },{ source := 94, target := 0, scalar := 2 },{ source := 120, target := 1, scalar := 2 }] }
theorem rowR5_0003_000_27_valid : (rowR5_0003_000_27).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_28 : ExtensionRow := { move := 95, child := 21, matrix := ![4,1,0,0,1,12,0,1,0], witnesses := [{ source := 0, target := 1, scalar := 12 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 17, scalar := 4 },{ source := 34, target := 124, scalar := 5 },{ source := 95, target := 0, scalar := 4 },{ source := 120, target := 52, scalar := 2 }] }
theorem rowR5_0003_000_28_valid : (rowR5_0003_000_28).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_29 : ExtensionRow := { move := 96, child := 39, matrix := ![2,0,3,10,11,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 3 },{ source := 1, target := 1, scalar := 11 },{ source := 17, target := 106, scalar := 2 },{ source := 34, target := 34, scalar := 1 },{ source := 96, target := 0, scalar := 1 },{ source := 120, target := 54, scalar := 11 }] }
theorem rowR5_0003_000_29_valid : (rowR5_0003_000_29).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_30 : ExtensionRow := { move := 99, child := 21, matrix := ![0,12,13,2,11,8,0,7,6], witnesses := [{ source := 0, target := 124, scalar := 13 },{ source := 1, target := 52, scalar := 12 },{ source := 17, target := 1, scalar := 2 },{ source := 34, target := 34, scalar := 1 },{ source := 99, target := 0, scalar := 4 },{ source := 120, target := 17, scalar := 11 }] }
theorem rowR5_0003_000_30_valid : (rowR5_0003_000_30).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_31 : ExtensionRow := { move := 100, child := 21, matrix := ![1,0,14,1,14,15,1,0,1], witnesses := [{ source := 0, target := 52, scalar := 14 },{ source := 1, target := 1, scalar := 14 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 15 },{ source := 100, target := 0, scalar := 2 },{ source := 120, target := 124, scalar := 13 }] }
theorem rowR5_0003_000_31_valid : (rowR5_0003_000_31).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_32 : ExtensionRow := { move := 101, child := 39, matrix := ![11,1,10,5,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 10 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 54, scalar := 11 },{ source := 34, target := 1, scalar := 4 },{ source := 101, target := 0, scalar := 4 },{ source := 120, target := 106, scalar := 14 }] }
theorem rowR5_0003_000_32_valid : (rowR5_0003_000_32).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_33 : ExtensionRow := { move := 103, child := 19, matrix := ![1,6,7,1,7,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 7 },{ source := 1, target := 120, scalar := 6 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 6 },{ source := 103, target := 52, scalar := 13 },{ source := 120, target := 0, scalar := 7 }] }
theorem rowR5_0003_000_33_valid : (rowR5_0003_000_33).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_34 : ExtensionRow := { move := 105, child := 42, matrix := ![13,15,3,12,13,0,7,6,0], witnesses := [{ source := 0, target := 17, scalar := 3 },{ source := 1, target := 54, scalar := 15 },{ source := 17, target := 112, scalar := 13 },{ source := 34, target := 34, scalar := 1 },{ source := 105, target := 0, scalar := 10 },{ source := 120, target := 1, scalar := 4 }] }
theorem rowR5_0003_000_34_valid : (rowR5_0003_000_34).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_35 : ExtensionRow := { move := 106, child := 21, matrix := ![0,5,4,12,13,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 124, scalar := 5 },{ source := 17, target := 1, scalar := 12 },{ source := 34, target := 34, scalar := 1 },{ source := 106, target := 0, scalar := 5 },{ source := 120, target := 52, scalar := 2 }] }
theorem rowR5_0003_000_35_valid : (rowR5_0003_000_35).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_36 : ExtensionRow := { move := 107, child := 24, matrix := ![0,0,6,1,0,0,0,7,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 0, scalar := 7 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 135, scalar := 6 },{ source := 107, target := 52, scalar := 9 },{ source := 120, target := 34, scalar := 1 }] }
theorem rowR5_0003_000_36_valid : (rowR5_0003_000_36).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_37 : ExtensionRow := { move := 108, child := 21, matrix := ![12,13,0,11,8,2,7,6,0], witnesses := [{ source := 0, target := 1, scalar := 2 },{ source := 1, target := 124, scalar := 13 },{ source := 17, target := 52, scalar := 12 },{ source := 34, target := 34, scalar := 1 },{ source := 108, target := 0, scalar := 10 },{ source := 120, target := 17, scalar := 4 }] }
theorem rowR5_0003_000_37_valid : (rowR5_0003_000_37).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_38 : ExtensionRow := { move := 109, child := 21, matrix := ![0,13,1,2,8,1,0,6,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 124, scalar := 13 },{ source := 17, target := 1, scalar := 2 },{ source := 34, target := 52, scalar := 12 },{ source := 109, target := 0, scalar := 1 },{ source := 120, target := 17, scalar := 15 }] }
theorem rowR5_0003_000_38_valid : (rowR5_0003_000_38).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_39 : ExtensionRow := { move := 112, child := 58, matrix := ![1,15,13,1,7,0,1,11,0], witnesses := [{ source := 0, target := 17, scalar := 13 },{ source := 1, target := 232, scalar := 15 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 55, scalar := 3 },{ source := 112, target := 1, scalar := 9 },{ source := 120, target := 0, scalar := 14 }] }
theorem rowR5_0003_000_39_valid : (rowR5_0003_000_39).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_40 : ExtensionRow := { move := 131, child := 39, matrix := ![1,9,12,1,0,9,1,0,6], witnesses := [{ source := 0, target := 106, scalar := 12 },{ source := 1, target := 17, scalar := 9 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 54, scalar := 4 },{ source := 120, target := 1, scalar := 11 },{ source := 131, target := 0, scalar := 13 }] }
theorem rowR5_0003_000_40_valid : (rowR5_0003_000_40).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_41 : ExtensionRow := { move := 132, child := 42, matrix := ![1,9,8,1,0,14,1,0,1], witnesses := [{ source := 0, target := 112, scalar := 8 },{ source := 1, target := 17, scalar := 9 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 15 },{ source := 120, target := 54, scalar := 15 },{ source := 132, target := 0, scalar := 2 }] }
theorem rowR5_0003_000_41_valid : (rowR5_0003_000_41).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_42 : ExtensionRow := { move := 133, child := 19, matrix := ![0,7,6,6,0,7,0,0,1], witnesses := [{ source := 0, target := 120, scalar := 6 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 1, scalar := 6 },{ source := 34, target := 34, scalar := 1 },{ source := 120, target := 0, scalar := 7 },{ source := 133, target := 52, scalar := 13 }] }
theorem rowR5_0003_000_42_valid : (rowR5_0003_000_42).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_43 : ExtensionRow := { move := 134, child := 24, matrix := ![0,7,6,0,0,1,6,0,7], witnesses := [{ source := 0, target := 135, scalar := 6 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 0, scalar := 6 },{ source := 34, target := 34, scalar := 1 },{ source := 120, target := 1, scalar := 7 },{ source := 134, target := 52, scalar := 11 }] }
theorem rowR5_0003_000_43_valid : (rowR5_0003_000_43).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_44 : ExtensionRow := { move := 135, child := 60, matrix := ![0,0,1,0,1,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 120, target := 135, scalar := 7 },{ source := 135, target := 120, scalar := 6 }] }
theorem rowR5_0003_000_44_valid : (rowR5_0003_000_44).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_45 : ExtensionRow := { move := 137, child := 19, matrix := ![1,6,7,1,0,1,1,0,6], witnesses := [{ source := 0, target := 120, scalar := 7 },{ source := 1, target := 17, scalar := 6 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 7 },{ source := 120, target := 1, scalar := 6 },{ source := 137, target := 52, scalar := 13 }] }
theorem rowR5_0003_000_45_valid : (rowR5_0003_000_45).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_46 : ExtensionRow := { move := 138, child := 39, matrix := ![4,10,14,8,0,3,7,0,7], witnesses := [{ source := 0, target := 106, scalar := 14 },{ source := 1, target := 17, scalar := 10 },{ source := 17, target := 54, scalar := 4 },{ source := 34, target := 1, scalar := 11 },{ source := 120, target := 34, scalar := 1 },{ source := 138, target := 0, scalar := 13 }] }
theorem rowR5_0003_000_46_valid : (rowR5_0003_000_46).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowR5_0003_000_47 : ExtensionRow := { move := 139, child := 19, matrix := ![0,1,1,0,0,6,7,0,7], witnesses := [{ source := 0, target := 120, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 0, scalar := 7 },{ source := 34, target := 1, scalar := 6 },{ source := 120, target := 34, scalar := 1 },{ source := 139, target := 52, scalar := 13 }] }
theorem rowR5_0003_000_47_valid : (rowR5_0003_000_47).ValidFor level6 {0,1,17,34,120} := by decide

noncomputable def rowsR5_0003_000 : List ExtensionRow := [rowR5_0003_000_0,rowR5_0003_000_1,rowR5_0003_000_2,rowR5_0003_000_3,rowR5_0003_000_4,rowR5_0003_000_5,rowR5_0003_000_6,rowR5_0003_000_7,rowR5_0003_000_8,rowR5_0003_000_9,rowR5_0003_000_10,rowR5_0003_000_11,rowR5_0003_000_12,rowR5_0003_000_13,rowR5_0003_000_14,rowR5_0003_000_15,rowR5_0003_000_16,rowR5_0003_000_17,rowR5_0003_000_18,rowR5_0003_000_19,rowR5_0003_000_20,rowR5_0003_000_21,rowR5_0003_000_22,rowR5_0003_000_23,rowR5_0003_000_24,rowR5_0003_000_25,rowR5_0003_000_26,rowR5_0003_000_27,rowR5_0003_000_28,rowR5_0003_000_29,rowR5_0003_000_30,rowR5_0003_000_31,rowR5_0003_000_32,rowR5_0003_000_33,rowR5_0003_000_34,rowR5_0003_000_35,rowR5_0003_000_36,rowR5_0003_000_37,rowR5_0003_000_38,rowR5_0003_000_39,rowR5_0003_000_40,rowR5_0003_000_41,rowR5_0003_000_42,rowR5_0003_000_43,rowR5_0003_000_44,rowR5_0003_000_45,rowR5_0003_000_46,rowR5_0003_000_47]

theorem rowsR5_0003_000_valid : RowListValid level6 {0,1,17,34,120} rowsR5_0003_000 := by
  intro r hr
  simp only [rowsR5_0003_000, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR5_0003_000_0_valid
  · exact rowR5_0003_000_1_valid
  · exact rowR5_0003_000_2_valid
  · exact rowR5_0003_000_3_valid
  · exact rowR5_0003_000_4_valid
  · exact rowR5_0003_000_5_valid
  · exact rowR5_0003_000_6_valid
  · exact rowR5_0003_000_7_valid
  · exact rowR5_0003_000_8_valid
  · exact rowR5_0003_000_9_valid
  · exact rowR5_0003_000_10_valid
  · exact rowR5_0003_000_11_valid
  · exact rowR5_0003_000_12_valid
  · exact rowR5_0003_000_13_valid
  · exact rowR5_0003_000_14_valid
  · exact rowR5_0003_000_15_valid
  · exact rowR5_0003_000_16_valid
  · exact rowR5_0003_000_17_valid
  · exact rowR5_0003_000_18_valid
  · exact rowR5_0003_000_19_valid
  · exact rowR5_0003_000_20_valid
  · exact rowR5_0003_000_21_valid
  · exact rowR5_0003_000_22_valid
  · exact rowR5_0003_000_23_valid
  · exact rowR5_0003_000_24_valid
  · exact rowR5_0003_000_25_valid
  · exact rowR5_0003_000_26_valid
  · exact rowR5_0003_000_27_valid
  · exact rowR5_0003_000_28_valid
  · exact rowR5_0003_000_29_valid
  · exact rowR5_0003_000_30_valid
  · exact rowR5_0003_000_31_valid
  · exact rowR5_0003_000_32_valid
  · exact rowR5_0003_000_33_valid
  · exact rowR5_0003_000_34_valid
  · exact rowR5_0003_000_35_valid
  · exact rowR5_0003_000_36_valid
  · exact rowR5_0003_000_37_valid
  · exact rowR5_0003_000_38_valid
  · exact rowR5_0003_000_39_valid
  · exact rowR5_0003_000_40_valid
  · exact rowR5_0003_000_41_valid
  · exact rowR5_0003_000_42_valid
  · exact rowR5_0003_000_43_valid
  · exact rowR5_0003_000_44_valid
  · exact rowR5_0003_000_45_valid
  · exact rowR5_0003_000_46_valid
  · exact rowR5_0003_000_47_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
