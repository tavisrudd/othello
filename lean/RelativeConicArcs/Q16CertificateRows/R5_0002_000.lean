import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR5_0002_000_0 : ExtensionRow := { move := 67, child := 4, matrix := ![1,0,0,1,1,0,1,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 55, target := 72, scalar := 1 },{ source := 67, target := 52, scalar := 1 }] }
theorem rowR5_0002_000_0_valid : (rowR5_0002_000_0).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_1 : ExtensionRow := { move := 69, child := 7, matrix := ![1,0,0,2,1,0,3,0,9], witnesses := [{ source := 0, target := 0, scalar := 9 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 52, scalar := 1 },{ source := 34, target := 75, scalar := 1 },{ source := 55, target := 17, scalar := 1 },{ source := 69, target := 34, scalar := 1 }] }
theorem rowR5_0002_000_1_valid : (rowR5_0002_000_1).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_2 : ExtensionRow := { move := 72, child := 19, matrix := ![1,13,13,0,8,9,0,5,4], witnesses := [{ source := 0, target := 52, scalar := 13 },{ source := 1, target := 120, scalar := 13 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 55, target := 0, scalar := 1 },{ source := 72, target := 1, scalar := 1 }] }
theorem rowR5_0002_000_2_valid : (rowR5_0002_000_2).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_3 : ExtensionRow := { move := 73, child := 20, matrix := ![0,14,0,0,0,15,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 15 },{ source := 1, target := 17, scalar := 14 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 52, scalar := 14 },{ source := 55, target := 121, scalar := 15 },{ source := 73, target := 34, scalar := 1 }] }
theorem rowR5_0002_000_3_valid : (rowR5_0002_000_3).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_4 : ExtensionRow := { move := 74, child := 15, matrix := ![5,0,8,10,4,14,15,0,15], witnesses := [{ source := 0, target := 107, scalar := 8 },{ source := 1, target := 1, scalar := 4 },{ source := 17, target := 52, scalar := 5 },{ source := 34, target := 17, scalar := 13 },{ source := 55, target := 0, scalar := 11 },{ source := 74, target := 34, scalar := 1 }] }
theorem rowR5_0002_000_4_valid : (rowR5_0002_000_4).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_5 : ExtensionRow := { move := 76, child := 50, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 55, target := 55, scalar := 1 },{ source := 76, target := 76, scalar := 1 }] }
theorem rowR5_0002_000_5_valid : (rowR5_0002_000_5).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_6 : ExtensionRow := { move := 77, child := 10, matrix := ![1,0,0,3,1,0,15,0,12], witnesses := [{ source := 0, target := 0, scalar := 12 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 80, scalar := 1 },{ source := 34, target := 52, scalar := 1 },{ source := 55, target := 34, scalar := 1 },{ source := 77, target := 17, scalar := 1 }] }
theorem rowR5_0002_000_6_valid : (rowR5_0002_000_6).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_7 : ExtensionRow := { move := 78, child := 22, matrix := ![1,0,1,6,0,1,13,12,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 0, scalar := 12 },{ source := 17, target := 126, scalar := 1 },{ source := 34, target := 1, scalar := 7 },{ source := 55, target := 17, scalar := 7 },{ source := 78, target := 52, scalar := 12 }] }
theorem rowR5_0002_000_7_valid : (rowR5_0002_000_7).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_8 : ExtensionRow := { move := 79, child := 12, matrix := ![14,0,1,15,14,1,1,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 1, scalar := 14 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 17, scalar := 15 },{ source := 55, target := 92, scalar := 8 },{ source := 79, target := 0, scalar := 15 }] }
theorem rowR5_0002_000_8_valid : (rowR5_0002_000_8).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_9 : ExtensionRow := { move := 80, child := 23, matrix := ![1,3,6,1,6,7,1,5,4], witnesses := [{ source := 0, target := 128, scalar := 6 },{ source := 1, target := 52, scalar := 3 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 4 },{ source := 55, target := 1, scalar := 12 },{ source := 80, target := 0, scalar := 7 }] }
theorem rowR5_0002_000_9_valid : (rowR5_0002_000_9).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_10 : ExtensionRow := { move := 83, child := 32, matrix := ![0,7,7,14,0,14,0,0,9], witnesses := [{ source := 0, target := 52, scalar := 7 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 0, scalar := 9 },{ source := 55, target := 188, scalar := 15 },{ source := 83, target := 34, scalar := 1 }] }
theorem rowR5_0002_000_10_valid : (rowR5_0002_000_10).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_11 : ExtensionRow := { move := 84, child := 6, matrix := ![2,1,0,4,1,0,6,1,15], witnesses := [{ source := 0, target := 0, scalar := 15 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 2 },{ source := 34, target := 74, scalar := 3 },{ source := 55, target := 1, scalar := 6 },{ source := 84, target := 17, scalar := 6 }] }
theorem rowR5_0002_000_11_valid : (rowR5_0002_000_11).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_12 : ExtensionRow := { move := 86, child := 26, matrix := ![1,3,6,1,9,0,1,13,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 139, scalar := 3 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 52, scalar := 4 },{ source := 55, target := 0, scalar := 8 },{ source := 86, target := 1, scalar := 3 }] }
theorem rowR5_0002_000_12_valid : (rowR5_0002_000_12).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_13 : ExtensionRow := { move := 88, child := 50, matrix := ![15,14,0,0,1,0,0,8,9], witnesses := [{ source := 0, target := 0, scalar := 9 },{ source := 1, target := 76, scalar := 14 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 34, scalar := 1 },{ source := 55, target := 1, scalar := 2 },{ source := 88, target := 55, scalar := 2 }] }
theorem rowR5_0002_000_13_valid : (rowR5_0002_000_13).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_14 : ExtensionRow := { move := 90, child := 31, matrix := ![15,7,0,14,14,0,10,9,3], witnesses := [{ source := 0, target := 0, scalar := 3 },{ source := 1, target := 52, scalar := 7 },{ source := 17, target := 176, scalar := 15 },{ source := 34, target := 17, scalar := 8 },{ source := 55, target := 34, scalar := 1 },{ source := 90, target := 1, scalar := 3 }] }
theorem rowR5_0002_000_14_valid : (rowR5_0002_000_14).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_15 : ExtensionRow := { move := 91, child := 20, matrix := ![1,0,0,1,0,7,1,9,0], witnesses := [{ source := 0, target := 1, scalar := 7 },{ source := 1, target := 0, scalar := 9 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 121, scalar := 1 },{ source := 55, target := 17, scalar := 1 },{ source := 91, target := 52, scalar := 1 }] }
theorem rowR5_0002_000_15_valid : (rowR5_0002_000_15).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_16 : ExtensionRow := { move := 92, child := 16, matrix := ![0,10,6,14,7,0,0,13,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 52, scalar := 10 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 108, scalar := 12 },{ source := 55, target := 0, scalar := 9 },{ source := 92, target := 34, scalar := 1 }] }
theorem rowR5_0002_000_16_valid : (rowR5_0002_000_16).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_17 : ExtensionRow := { move := 94, child := 1, matrix := ![14,7,0,1,0,0,13,0,5], witnesses := [{ source := 0, target := 0, scalar := 5 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 69, scalar := 14 },{ source := 34, target := 52, scalar := 9 },{ source := 55, target := 1, scalar := 1 },{ source := 94, target := 34, scalar := 1 }] }
theorem rowR5_0002_000_17_valid : (rowR5_0002_000_17).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_18 : ExtensionRow := { move := 95, child := 17, matrix := ![15,13,1,13,12,1,2,3,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 109, scalar := 13 },{ source := 17, target := 52, scalar := 15 },{ source := 34, target := 17, scalar := 3 },{ source := 55, target := 0, scalar := 2 },{ source := 95, target := 1, scalar := 6 }] }
theorem rowR5_0002_000_18_valid : (rowR5_0002_000_18).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_19 : ExtensionRow := { move := 96, child := 12, matrix := ![13,12,1,1,0,1,6,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 12 },{ source := 17, target := 92, scalar := 13 },{ source := 34, target := 0, scalar := 7 },{ source := 55, target := 1, scalar := 7 },{ source := 96, target := 52, scalar := 7 }] }
theorem rowR5_0002_000_19_valid : (rowR5_0002_000_19).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_20 : ExtensionRow := { move := 99, child := 22, matrix := ![1,0,7,1,8,14,1,0,9], witnesses := [{ source := 0, target := 52, scalar := 7 },{ source := 1, target := 1, scalar := 8 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 126, scalar := 6 },{ source := 55, target := 0, scalar := 2 },{ source := 99, target := 17, scalar := 15 }] }
theorem rowR5_0002_000_20_valid : (rowR5_0002_000_20).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_21 : ExtensionRow := { move := 100, child := 10, matrix := ![0,7,7,0,0,14,9,0,9], witnesses := [{ source := 0, target := 52, scalar := 7 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 0, scalar := 9 },{ source := 34, target := 1, scalar := 14 },{ source := 55, target := 80, scalar := 15 },{ source := 100, target := 34, scalar := 1 }] }
theorem rowR5_0002_000_21_valid : (rowR5_0002_000_21).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_22 : ExtensionRow := { move := 104, child := 50, matrix := ![1,3,2,1,5,4,1,14,12], witnesses := [{ source := 0, target := 55, scalar := 2 },{ source := 1, target := 76, scalar := 3 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 3 },{ source := 55, target := 17, scalar := 11 },{ source := 104, target := 1, scalar := 12 }] }
theorem rowR5_0002_000_22_valid : (rowR5_0002_000_22).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_23 : ExtensionRow := { move := 105, child := 43, matrix := ![1,1,9,2,1,0,5,1,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 54, scalar := 1 },{ source := 34, target := 121, scalar := 9 },{ source := 55, target := 0, scalar := 7 },{ source := 105, target := 1, scalar := 7 }] }
theorem rowR5_0002_000_23_valid : (rowR5_0002_000_23).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_24 : ExtensionRow := { move := 106, child := 44, matrix := ![0,10,10,0,9,7,1,5,4], witnesses := [{ source := 0, target := 54, scalar := 10 },{ source := 1, target := 122, scalar := 10 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 14 },{ source := 55, target := 17, scalar := 14 },{ source := 106, target := 34, scalar := 1 }] }
theorem rowR5_0002_000_24_valid : (rowR5_0002_000_24).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_25 : ExtensionRow := { move := 107, child := 11, matrix := ![0,13,13,0,1,9,15,11,4], witnesses := [{ source := 0, target := 52, scalar := 13 },{ source := 1, target := 91, scalar := 13 },{ source := 17, target := 0, scalar := 15 },{ source := 34, target := 1, scalar := 8 },{ source := 55, target := 34, scalar := 1 },{ source := 107, target := 17, scalar := 7 }] }
theorem rowR5_0002_000_25_valid : (rowR5_0002_000_25).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_26 : ExtensionRow := { move := 108, child := 20, matrix := ![4,1,5,11,1,10,6,1,15], witnesses := [{ source := 0, target := 52, scalar := 5 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 121, scalar := 4 },{ source := 34, target := 0, scalar := 8 },{ source := 55, target := 17, scalar := 11 },{ source := 108, target := 1, scalar := 12 }] }
theorem rowR5_0002_000_26_valid : (rowR5_0002_000_26).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_27 : ExtensionRow := { move := 109, child := 45, matrix := ![1,1,0,2,1,3,5,1,0], witnesses := [{ source := 0, target := 1, scalar := 3 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 54, scalar := 1 },{ source := 34, target := 0, scalar := 4 },{ source := 55, target := 125, scalar := 3 },{ source := 109, target := 17, scalar := 4 }] }
theorem rowR5_0002_000_27_valid : (rowR5_0002_000_27).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_28 : ExtensionRow := { move := 110, child := 46, matrix := ![0,0,4,0,11,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 1, scalar := 11 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 126, scalar := 4 },{ source := 55, target := 54, scalar := 11 },{ source := 110, target := 34, scalar := 1 }] }
theorem rowR5_0002_000_28_valid : (rowR5_0002_000_28).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_29 : ExtensionRow := { move := 111, child := 6, matrix := ![0,0,3,0,5,5,8,0,8], witnesses := [{ source := 0, target := 74, scalar := 3 },{ source := 1, target := 1, scalar := 5 },{ source := 17, target := 0, scalar := 8 },{ source := 34, target := 17, scalar := 3 },{ source := 55, target := 52, scalar := 10 },{ source := 111, target := 34, scalar := 1 }] }
theorem rowR5_0002_000_29_valid : (rowR5_0002_000_29).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_30 : ExtensionRow := { move := 115, child := 35, matrix := ![9,0,13,1,0,0,8,13,0], witnesses := [{ source := 0, target := 17, scalar := 13 },{ source := 1, target := 0, scalar := 13 },{ source := 17, target := 52, scalar := 9 },{ source := 34, target := 237, scalar := 4 },{ source := 55, target := 34, scalar := 1 },{ source := 115, target := 1, scalar := 1 }] }
theorem rowR5_0002_000_30_valid : (rowR5_0002_000_30).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_31 : ExtensionRow := { move := 117, child := 16, matrix := ![11,1,10,5,1,4,14,1,2], witnesses := [{ source := 0, target := 108, scalar := 10 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 11 },{ source := 34, target := 0, scalar := 13 },{ source := 55, target := 1, scalar := 12 },{ source := 117, target := 17, scalar := 3 }] }
theorem rowR5_0002_000_31_valid : (rowR5_0002_000_31).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_32 : ExtensionRow := { move := 118, child := 27, matrix := ![0,1,0,6,1,0,0,1,15], witnesses := [{ source := 0, target := 0, scalar := 15 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 6 },{ source := 34, target := 143, scalar := 1 },{ source := 55, target := 52, scalar := 2 },{ source := 118, target := 17, scalar := 6 }] }
theorem rowR5_0002_000_32_valid : (rowR5_0002_000_32).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_33 : ExtensionRow := { move := 120, child := 42, matrix := ![0,8,9,15,14,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 112, scalar := 8 },{ source := 17, target := 1, scalar := 15 },{ source := 34, target := 34, scalar := 1 },{ source := 55, target := 0, scalar := 2 },{ source := 120, target := 54, scalar := 15 }] }
theorem rowR5_0002_000_33_valid : (rowR5_0002_000_33).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_34 : ExtensionRow := { move := 121, child := 51, matrix := ![1,10,1,6,0,1,8,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 10 },{ source := 17, target := 121, scalar := 1 },{ source := 34, target := 55, scalar := 10 },{ source := 55, target := 0, scalar := 14 },{ source := 121, target := 1, scalar := 14 }] }
theorem rowR5_0002_000_34_valid : (rowR5_0002_000_34).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_35 : ExtensionRow := { move := 122, child := 26, matrix := ![0,1,14,0,1,12,5,1,6], witnesses := [{ source := 0, target := 139, scalar := 14 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 5 },{ source := 34, target := 52, scalar := 15 },{ source := 55, target := 1, scalar := 12 },{ source := 122, target := 17, scalar := 1 }] }
theorem rowR5_0002_000_35_valid : (rowR5_0002_000_35).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_36 : ExtensionRow := { move := 124, child := 27, matrix := ![10,12,7,7,0,6,13,0,12], witnesses := [{ source := 0, target := 143, scalar := 7 },{ source := 1, target := 17, scalar := 12 },{ source := 17, target := 52, scalar := 10 },{ source := 34, target := 34, scalar := 1 },{ source := 55, target := 0, scalar := 3 },{ source := 124, target := 1, scalar := 8 }] }
theorem rowR5_0002_000_36_valid : (rowR5_0002_000_36).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_37 : ExtensionRow := { move := 125, child := 25, matrix := ![1,0,0,0,0,7,0,9,0], witnesses := [{ source := 0, target := 1, scalar := 7 },{ source := 1, target := 0, scalar := 9 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 138, scalar := 1 },{ source := 55, target := 34, scalar := 1 },{ source := 125, target := 52, scalar := 1 }] }
theorem rowR5_0002_000_37_valid : (rowR5_0002_000_37).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_38 : ExtensionRow := { move := 126, child := 9, matrix := ![0,10,6,0,7,0,9,13,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 52, scalar := 10 },{ source := 17, target := 0, scalar := 9 },{ source := 34, target := 79, scalar := 12 },{ source := 55, target := 1, scalar := 14 },{ source := 126, target := 34, scalar := 1 }] }
theorem rowR5_0002_000_38_valid : (rowR5_0002_000_38).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_39 : ExtensionRow := { move := 127, child := 52, matrix := ![1,1,9,2,1,0,6,1,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 55, scalar := 1 },{ source := 34, target := 127, scalar := 9 },{ source := 55, target := 0, scalar := 4 },{ source := 127, target := 1, scalar := 4 }] }
theorem rowR5_0002_000_39_valid : (rowR5_0002_000_39).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_40 : ExtensionRow := { move := 128, child := 48, matrix := ![11,15,1,0,11,1,0,3,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 140, scalar := 15 },{ source := 17, target := 17, scalar := 11 },{ source := 34, target := 54, scalar := 5 },{ source := 55, target := 1, scalar := 3 },{ source := 128, target := 0, scalar := 5 }] }
theorem rowR5_0002_000_40_valid : (rowR5_0002_000_40).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_41 : ExtensionRow := { move := 131, child := 53, matrix := ![1,10,1,2,0,1,6,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 10 },{ source := 17, target := 55, scalar := 1 },{ source := 34, target := 131, scalar := 10 },{ source := 55, target := 1, scalar := 4 },{ source := 131, target := 0, scalar := 4 }] }
theorem rowR5_0002_000_41_valid : (rowR5_0002_000_41).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_42 : ExtensionRow := { move := 132, child := 54, matrix := ![11,12,7,4,11,0,14,14,0], witnesses := [{ source := 0, target := 17, scalar := 7 },{ source := 1, target := 55, scalar := 12 },{ source := 17, target := 132, scalar := 11 },{ source := 34, target := 1, scalar := 15 },{ source := 55, target := 34, scalar := 1 },{ source := 132, target := 0, scalar := 2 }] }
theorem rowR5_0002_000_42_valid : (rowR5_0002_000_42).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_43 : ExtensionRow := { move := 133, child := 15, matrix := ![1,4,10,1,0,7,1,0,13], witnesses := [{ source := 0, target := 52, scalar := 10 },{ source := 1, target := 17, scalar := 4 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 107, scalar := 15 },{ source := 55, target := 0, scalar := 9 },{ source := 133, target := 1, scalar := 14 }] }
theorem rowR5_0002_000_43_valid : (rowR5_0002_000_43).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_44 : ExtensionRow := { move := 134, child := 11, matrix := ![0,1,4,8,1,3,0,1,14], witnesses := [{ source := 0, target := 91, scalar := 4 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 8 },{ source := 34, target := 52, scalar := 5 },{ source := 55, target := 17, scalar := 9 },{ source := 134, target := 0, scalar := 4 }] }
theorem rowR5_0002_000_44_valid : (rowR5_0002_000_44).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_45 : ExtensionRow := { move := 137, child := 15, matrix := ![11,1,10,1,1,0,2,1,0], witnesses := [{ source := 0, target := 17, scalar := 10 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 107, scalar := 11 },{ source := 34, target := 0, scalar := 3 },{ source := 55, target := 1, scalar := 3 },{ source := 137, target := 52, scalar := 3 }] }
theorem rowR5_0002_000_45_valid : (rowR5_0002_000_45).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_46 : ExtensionRow := { move := 139, child := 22, matrix := ![7,7,0,1,0,0,5,0,5], witnesses := [{ source := 0, target := 0, scalar := 5 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 126, scalar := 7 },{ source := 34, target := 1, scalar := 1 },{ source := 55, target := 52, scalar := 9 },{ source := 139, target := 34, scalar := 1 }] }
theorem rowR5_0002_000_46_valid : (rowR5_0002_000_46).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowR5_0002_000_47 : ExtensionRow := { move := 140, child := 17, matrix := ![10,0,4,4,11,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 1, scalar := 11 },{ source := 17, target := 109, scalar := 10 },{ source := 34, target := 52, scalar := 14 },{ source := 55, target := 34, scalar := 1 },{ source := 140, target := 0, scalar := 1 }] }
theorem rowR5_0002_000_47_valid : (rowR5_0002_000_47).ValidFor level6 {0,1,17,34,55} := by decide

noncomputable def rowsR5_0002_000 : List ExtensionRow := [rowR5_0002_000_0,rowR5_0002_000_1,rowR5_0002_000_2,rowR5_0002_000_3,rowR5_0002_000_4,rowR5_0002_000_5,rowR5_0002_000_6,rowR5_0002_000_7,rowR5_0002_000_8,rowR5_0002_000_9,rowR5_0002_000_10,rowR5_0002_000_11,rowR5_0002_000_12,rowR5_0002_000_13,rowR5_0002_000_14,rowR5_0002_000_15,rowR5_0002_000_16,rowR5_0002_000_17,rowR5_0002_000_18,rowR5_0002_000_19,rowR5_0002_000_20,rowR5_0002_000_21,rowR5_0002_000_22,rowR5_0002_000_23,rowR5_0002_000_24,rowR5_0002_000_25,rowR5_0002_000_26,rowR5_0002_000_27,rowR5_0002_000_28,rowR5_0002_000_29,rowR5_0002_000_30,rowR5_0002_000_31,rowR5_0002_000_32,rowR5_0002_000_33,rowR5_0002_000_34,rowR5_0002_000_35,rowR5_0002_000_36,rowR5_0002_000_37,rowR5_0002_000_38,rowR5_0002_000_39,rowR5_0002_000_40,rowR5_0002_000_41,rowR5_0002_000_42,rowR5_0002_000_43,rowR5_0002_000_44,rowR5_0002_000_45,rowR5_0002_000_46,rowR5_0002_000_47]

theorem rowsR5_0002_000_valid : RowListValid level6 {0,1,17,34,55} rowsR5_0002_000 := by
  intro r hr
  simp only [rowsR5_0002_000, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR5_0002_000_0_valid
  · exact rowR5_0002_000_1_valid
  · exact rowR5_0002_000_2_valid
  · exact rowR5_0002_000_3_valid
  · exact rowR5_0002_000_4_valid
  · exact rowR5_0002_000_5_valid
  · exact rowR5_0002_000_6_valid
  · exact rowR5_0002_000_7_valid
  · exact rowR5_0002_000_8_valid
  · exact rowR5_0002_000_9_valid
  · exact rowR5_0002_000_10_valid
  · exact rowR5_0002_000_11_valid
  · exact rowR5_0002_000_12_valid
  · exact rowR5_0002_000_13_valid
  · exact rowR5_0002_000_14_valid
  · exact rowR5_0002_000_15_valid
  · exact rowR5_0002_000_16_valid
  · exact rowR5_0002_000_17_valid
  · exact rowR5_0002_000_18_valid
  · exact rowR5_0002_000_19_valid
  · exact rowR5_0002_000_20_valid
  · exact rowR5_0002_000_21_valid
  · exact rowR5_0002_000_22_valid
  · exact rowR5_0002_000_23_valid
  · exact rowR5_0002_000_24_valid
  · exact rowR5_0002_000_25_valid
  · exact rowR5_0002_000_26_valid
  · exact rowR5_0002_000_27_valid
  · exact rowR5_0002_000_28_valid
  · exact rowR5_0002_000_29_valid
  · exact rowR5_0002_000_30_valid
  · exact rowR5_0002_000_31_valid
  · exact rowR5_0002_000_32_valid
  · exact rowR5_0002_000_33_valid
  · exact rowR5_0002_000_34_valid
  · exact rowR5_0002_000_35_valid
  · exact rowR5_0002_000_36_valid
  · exact rowR5_0002_000_37_valid
  · exact rowR5_0002_000_38_valid
  · exact rowR5_0002_000_39_valid
  · exact rowR5_0002_000_40_valid
  · exact rowR5_0002_000_41_valid
  · exact rowR5_0002_000_42_valid
  · exact rowR5_0002_000_43_valid
  · exact rowR5_0002_000_44_valid
  · exact rowR5_0002_000_45_valid
  · exact rowR5_0002_000_46_valid
  · exact rowR5_0002_000_47_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
