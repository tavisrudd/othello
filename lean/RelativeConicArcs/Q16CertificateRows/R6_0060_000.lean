import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR6_0060_000_0 : ExtensionRow := { move := 53, child := 439, matrix := ![8,12,4,5,11,0,7,7,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 52, scalar := 12 },{ source := 17, target := 124, scalar := 8 },{ source := 34, target := 1, scalar := 14 },{ source := 53, target := 0, scalar := 9 },{ source := 120, target := 141, scalar := 9 },{ source := 135, target := 34, scalar := 1 }] }
theorem rowR6_0060_000_0_valid : (rowR6_0060_000_0).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_1 : ExtensionRow := { move := 54, child := 439, matrix := ![1,4,12,1,0,11,1,0,7], witnesses := [{ source := 0, target := 52, scalar := 12 },{ source := 1, target := 17, scalar := 4 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 141, scalar := 9 },{ source := 54, target := 0, scalar := 9 },{ source := 120, target := 124, scalar := 8 },{ source := 135, target := 1, scalar := 14 }] }
theorem rowR6_0060_000_1_valid : (rowR6_0060_000_1).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_2 : ExtensionRow := { move := 58, child := 439, matrix := ![14,0,15,15,14,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 1, scalar := 14 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 34, scalar := 1 },{ source := 58, target := 0, scalar := 1 },{ source := 120, target := 124, scalar := 5 },{ source := 135, target := 141, scalar := 10 }] }
theorem rowR6_0060_000_2_valid : (rowR6_0060_000_2).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_3 : ExtensionRow := { move := 59, child := 439, matrix := ![0,1,11,2,1,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 2 },{ source := 34, target := 141, scalar := 10 },{ source := 59, target := 0, scalar := 2 },{ source := 120, target := 52, scalar := 2 },{ source := 135, target := 124, scalar := 8 }] }
theorem rowR6_0060_000_3_valid : (rowR6_0060_000_3).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_4 : ExtensionRow := { move := 62, child := 439, matrix := ![1,3,15,1,9,0,1,7,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 141, scalar := 3 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 124, scalar := 13 },{ source := 62, target := 0, scalar := 15 },{ source := 120, target := 1, scalar := 2 },{ source := 135, target := 52, scalar := 12 }] }
theorem rowR6_0060_000_4_valid : (rowR6_0060_000_4).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_5 : ExtensionRow := { move := 64, child := 439, matrix := ![3,5,4,9,13,0,7,1,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 124, scalar := 5 },{ source := 17, target := 141, scalar := 3 },{ source := 34, target := 52, scalar := 2 },{ source := 64, target := 0, scalar := 5 },{ source := 120, target := 34, scalar := 1 },{ source := 135, target := 1, scalar := 12 }] }
theorem rowR6_0060_000_5_valid : (rowR6_0060_000_5).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_6 : ExtensionRow := { move := 69, child := 439, matrix := ![9,4,12,10,0,11,6,0,7], witnesses := [{ source := 0, target := 52, scalar := 12 },{ source := 1, target := 17, scalar := 4 },{ source := 17, target := 141, scalar := 9 },{ source := 34, target := 34, scalar := 1 },{ source := 69, target := 0, scalar := 9 },{ source := 120, target := 1, scalar := 14 },{ source := 135, target := 124, scalar := 8 }] }
theorem rowR6_0060_000_6_valid : (rowR6_0060_000_6).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_7 : ExtensionRow := { move := 70, child := 439, matrix := ![0,12,4,14,11,0,0,7,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 52, scalar := 12 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 124, scalar := 8 },{ source := 70, target := 0, scalar := 9 },{ source := 120, target := 34, scalar := 1 },{ source := 135, target := 141, scalar := 9 }] }
theorem rowR6_0060_000_7_valid : (rowR6_0060_000_7).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_8 : ExtensionRow := { move := 73, child := 439, matrix := ![1,0,15,1,14,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 1, scalar := 14 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 52, scalar := 14 },{ source := 73, target := 0, scalar := 1 },{ source := 120, target := 141, scalar := 10 },{ source := 135, target := 124, scalar := 5 }] }
theorem rowR6_0060_000_8_valid : (rowR6_0060_000_8).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_9 : ExtensionRow := { move := 76, child := 439, matrix := ![10,1,11,3,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 141, scalar := 10 },{ source := 34, target := 1, scalar := 2 },{ source := 76, target := 0, scalar := 2 },{ source := 120, target := 124, scalar := 8 },{ source := 135, target := 52, scalar := 2 }] }
theorem rowR6_0060_000_9_valid : (rowR6_0060_000_9).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_10 : ExtensionRow := { move := 77, child := 439, matrix := ![13,3,15,8,9,0,6,7,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 141, scalar := 3 },{ source := 17, target := 124, scalar := 13 },{ source := 34, target := 34, scalar := 1 },{ source := 77, target := 0, scalar := 15 },{ source := 120, target := 52, scalar := 12 },{ source := 135, target := 1, scalar := 2 }] }
theorem rowR6_0060_000_10_valid : (rowR6_0060_000_10).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_11 : ExtensionRow := { move := 79, child := 439, matrix := ![2,5,4,4,13,0,6,1,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 124, scalar := 5 },{ source := 17, target := 52, scalar := 2 },{ source := 34, target := 141, scalar := 3 },{ source := 79, target := 0, scalar := 5 },{ source := 120, target := 1, scalar := 12 },{ source := 135, target := 34, scalar := 1 }] }
theorem rowR6_0060_000_11_valid : (rowR6_0060_000_11).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_12 : ExtensionRow := { move := 83, child := 439, matrix := ![8,4,12,5,0,11,7,0,7], witnesses := [{ source := 0, target := 52, scalar := 12 },{ source := 1, target := 17, scalar := 4 },{ source := 17, target := 124, scalar := 8 },{ source := 34, target := 1, scalar := 14 },{ source := 83, target := 0, scalar := 9 },{ source := 120, target := 34, scalar := 1 },{ source := 135, target := 141, scalar := 9 }] }
theorem rowR6_0060_000_12_valid : (rowR6_0060_000_12).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_13 : ExtensionRow := { move := 84, child := 439, matrix := ![9,12,4,10,11,0,6,7,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 52, scalar := 12 },{ source := 17, target := 141, scalar := 9 },{ source := 34, target := 34, scalar := 1 },{ source := 84, target := 0, scalar := 9 },{ source := 120, target := 124, scalar := 8 },{ source := 135, target := 1, scalar := 14 }] }
theorem rowR6_0060_000_13_valid : (rowR6_0060_000_13).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_14 : ExtensionRow := { move := 89, child := 439, matrix := ![1,5,4,1,13,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 124, scalar := 5 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 12 },{ source := 89, target := 0, scalar := 5 },{ source := 120, target := 141, scalar := 3 },{ source := 135, target := 52, scalar := 2 }] }
theorem rowR6_0060_000_14_valid : (rowR6_0060_000_14).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_15 : ExtensionRow := { move := 91, child := 439, matrix := ![0,3,15,2,9,0,0,7,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 141, scalar := 3 },{ source := 17, target := 1, scalar := 2 },{ source := 34, target := 52, scalar := 12 },{ source := 91, target := 0, scalar := 15 },{ source := 120, target := 34, scalar := 1 },{ source := 135, target := 124, scalar := 13 }] }
theorem rowR6_0060_000_15_valid : (rowR6_0060_000_15).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_16 : ExtensionRow := { move := 94, child := 439, matrix := ![2,1,11,4,1,0,6,1,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 2 },{ source := 34, target := 124, scalar := 8 },{ source := 94, target := 0, scalar := 2 },{ source := 120, target := 1, scalar := 2 },{ source := 135, target := 141, scalar := 10 }] }
theorem rowR6_0060_000_16_valid : (rowR6_0060_000_16).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_17 : ExtensionRow := { move := 95, child := 439, matrix := ![5,0,15,13,14,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 1, scalar := 14 },{ source := 17, target := 124, scalar := 5 },{ source := 34, target := 141, scalar := 10 },{ source := 95, target := 0, scalar := 1 },{ source := 120, target := 52, scalar := 14 },{ source := 135, target := 34, scalar := 1 }] }
theorem rowR6_0060_000_17_valid : (rowR6_0060_000_17).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_18 : ExtensionRow := { move := 99, child := 439, matrix := ![1,12,4,1,11,0,1,7,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 52, scalar := 12 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 141, scalar := 9 },{ source := 99, target := 0, scalar := 9 },{ source := 120, target := 1, scalar := 14 },{ source := 135, target := 124, scalar := 8 }] }
theorem rowR6_0060_000_18_valid : (rowR6_0060_000_18).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_19 : ExtensionRow := { move := 100, child := 439, matrix := ![0,4,12,14,0,11,0,0,7], witnesses := [{ source := 0, target := 52, scalar := 12 },{ source := 1, target := 17, scalar := 4 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 124, scalar := 8 },{ source := 100, target := 0, scalar := 9 },{ source := 120, target := 141, scalar := 9 },{ source := 135, target := 34, scalar := 1 }] }
theorem rowR6_0060_000_19_valid : (rowR6_0060_000_19).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_20 : ExtensionRow := { move := 106, child := 439, matrix := ![0,5,4,12,13,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 124, scalar := 5 },{ source := 17, target := 1, scalar := 12 },{ source := 34, target := 34, scalar := 1 },{ source := 106, target := 0, scalar := 5 },{ source := 120, target := 52, scalar := 2 },{ source := 135, target := 141, scalar := 3 }] }
theorem rowR6_0060_000_20_valid : (rowR6_0060_000_20).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_21 : ExtensionRow := { move := 108, child := 439, matrix := ![12,3,15,11,9,0,7,7,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 141, scalar := 3 },{ source := 17, target := 52, scalar := 12 },{ source := 34, target := 1, scalar := 2 },{ source := 108, target := 0, scalar := 15 },{ source := 120, target := 124, scalar := 13 },{ source := 135, target := 34, scalar := 1 }] }
theorem rowR6_0060_000_21_valid : (rowR6_0060_000_21).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_22 : ExtensionRow := { move := 109, child := 439, matrix := ![8,1,11,5,1,0,7,1,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 124, scalar := 8 },{ source := 34, target := 52, scalar := 2 },{ source := 109, target := 0, scalar := 2 },{ source := 120, target := 141, scalar := 10 },{ source := 135, target := 1, scalar := 2 }] }
theorem rowR6_0060_000_22_valid : (rowR6_0060_000_22).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_23 : ExtensionRow := { move := 112, child := 439, matrix := ![10,0,15,3,14,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 1, scalar := 14 },{ source := 17, target := 141, scalar := 10 },{ source := 34, target := 124, scalar := 5 },{ source := 112, target := 0, scalar := 1 },{ source := 120, target := 34, scalar := 1 },{ source := 135, target := 52, scalar := 14 }] }
theorem rowR6_0060_000_23_valid : (rowR6_0060_000_23).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_24 : ExtensionRow := { move := 148, child := 439, matrix := ![0,13,15,12,8,0,0,6,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 124, scalar := 13 },{ source := 17, target := 1, scalar := 12 },{ source := 34, target := 52, scalar := 2 },{ source := 120, target := 141, scalar := 3 },{ source := 135, target := 34, scalar := 1 },{ source := 148, target := 0, scalar := 5 }] }
theorem rowR6_0060_000_24_valid : (rowR6_0060_000_24).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_25 : ExtensionRow := { move := 149, child := 439, matrix := ![10,0,11,3,2,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 1, scalar := 2 },{ source := 17, target := 141, scalar := 10 },{ source := 34, target := 34, scalar := 1 },{ source := 120, target := 52, scalar := 14 },{ source := 135, target := 124, scalar := 5 },{ source := 149, target := 0, scalar := 1 }] }
theorem rowR6_0060_000_25_valid : (rowR6_0060_000_25).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_26 : ExtensionRow := { move := 155, child := 439, matrix := ![0,11,2,14,0,4,0,0,6], witnesses := [{ source := 0, target := 52, scalar := 2 },{ source := 1, target := 17, scalar := 11 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 141, scalar := 9 },{ source := 120, target := 34, scalar := 1 },{ source := 135, target := 124, scalar := 8 },{ source := 155, target := 0, scalar := 9 }] }
theorem rowR6_0060_000_26_valid : (rowR6_0060_000_26).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_27 : ExtensionRow := { move := 157, child := 439, matrix := ![1,14,15,1,15,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 52, scalar := 14 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 14 },{ source := 120, target := 124, scalar := 8 },{ source := 135, target := 141, scalar := 9 },{ source := 157, target := 0, scalar := 9 }] }
theorem rowR6_0060_000_27_valid : (rowR6_0060_000_27).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_28 : ExtensionRow := { move := 159, child := 439, matrix := ![13,1,15,8,1,0,6,1,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 124, scalar := 13 },{ source := 34, target := 141, scalar := 3 },{ source := 120, target := 1, scalar := 14 },{ source := 135, target := 52, scalar := 14 },{ source := 159, target := 0, scalar := 14 }] }
theorem rowR6_0060_000_28_valid : (rowR6_0060_000_28).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_29 : ExtensionRow := { move := 160, child := 439, matrix := ![12,10,11,11,3,0,7,1,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 141, scalar := 10 },{ source := 17, target := 52, scalar := 12 },{ source := 34, target := 124, scalar := 13 },{ source := 120, target := 34, scalar := 1 },{ source := 135, target := 1, scalar := 2 },{ source := 160, target := 0, scalar := 15 }] }
theorem rowR6_0060_000_29_valid : (rowR6_0060_000_29).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_30 : ExtensionRow := { move := 163, child := 439, matrix := ![2,13,15,4,8,0,6,6,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 124, scalar := 13 },{ source := 17, target := 52, scalar := 2 },{ source := 34, target := 1, scalar := 12 },{ source := 120, target := 34, scalar := 1 },{ source := 135, target := 141, scalar := 3 },{ source := 163, target := 0, scalar := 5 }] }
theorem rowR6_0060_000_30_valid : (rowR6_0060_000_30).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_31 : ExtensionRow := { move := 166, child := 439, matrix := ![1,0,11,1,2,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 1, scalar := 2 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 141, scalar := 10 },{ source := 120, target := 124, scalar := 5 },{ source := 135, target := 52, scalar := 14 },{ source := 166, target := 0, scalar := 1 }] }
theorem rowR6_0060_000_31_valid : (rowR6_0060_000_31).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_32 : ExtensionRow := { move := 172, child := 439, matrix := ![9,11,2,10,0,4,6,0,6], witnesses := [{ source := 0, target := 52, scalar := 2 },{ source := 1, target := 17, scalar := 11 },{ source := 17, target := 141, scalar := 9 },{ source := 34, target := 1, scalar := 14 },{ source := 120, target := 124, scalar := 8 },{ source := 135, target := 34, scalar := 1 },{ source := 172, target := 0, scalar := 9 }] }
theorem rowR6_0060_000_32_valid : (rowR6_0060_000_32).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_33 : ExtensionRow := { move := 174, child := 439, matrix := ![0,14,15,14,15,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 52, scalar := 14 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 34, scalar := 1 },{ source := 120, target := 141, scalar := 9 },{ source := 135, target := 124, scalar := 8 },{ source := 174, target := 0, scalar := 9 }] }
theorem rowR6_0060_000_33_valid : (rowR6_0060_000_33).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_34 : ExtensionRow := { move := 175, child := 439, matrix := ![13,10,11,8,3,0,6,1,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 141, scalar := 10 },{ source := 17, target := 124, scalar := 13 },{ source := 34, target := 52, scalar := 12 },{ source := 120, target := 1, scalar := 2 },{ source := 135, target := 34, scalar := 1 },{ source := 175, target := 0, scalar := 15 }] }
theorem rowR6_0060_000_34_valid : (rowR6_0060_000_34).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_35 : ExtensionRow := { move := 176, child := 439, matrix := ![3,1,15,9,1,0,7,1,0], witnesses := [{ source := 0, target := 17, scalar := 15 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 141, scalar := 3 },{ source := 34, target := 124, scalar := 13 },{ source := 120, target := 52, scalar := 14 },{ source := 135, target := 1, scalar := 14 },{ source := 176, target := 0, scalar := 14 }] }
theorem rowR6_0060_000_35_valid : (rowR6_0060_000_35).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_36 : ExtensionRow := { move := 179, child := 439, matrix := ![13,9,4,8,10,0,6,6,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 141, scalar := 9 },{ source := 17, target := 124, scalar := 13 },{ source := 34, target := 1, scalar := 2 },{ source := 120, target := 34, scalar := 1 },{ source := 135, target := 52, scalar := 12 },{ source := 179, target := 0, scalar := 15 }] }
theorem rowR6_0060_000_36_valid : (rowR6_0060_000_36).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_37 : ExtensionRow := { move := 181, child := 439, matrix := ![9,1,4,10,1,0,6,1,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 141, scalar := 9 },{ source := 34, target := 52, scalar := 12 },{ source := 120, target := 1, scalar := 12 },{ source := 135, target := 124, scalar := 5 },{ source := 181, target := 0, scalar := 12 }] }
theorem rowR6_0060_000_37_valid : (rowR6_0060_000_37).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_38 : ExtensionRow := { move := 185, child := 439, matrix := ![0,2,11,14,4,0,0,6,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 52, scalar := 2 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 141, scalar := 9 },{ source := 120, target := 124, scalar := 8 },{ source := 135, target := 34, scalar := 1 },{ source := 185, target := 0, scalar := 9 }] }
theorem rowR6_0060_000_38_valid : (rowR6_0060_000_38).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_39 : ExtensionRow := { move := 189, child := 439, matrix := ![2,8,11,4,5,0,6,7,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 124, scalar := 8 },{ source := 17, target := 52, scalar := 2 },{ source := 34, target := 34, scalar := 1 },{ source := 120, target := 141, scalar := 3 },{ source := 135, target := 1, scalar := 12 },{ source := 189, target := 0, scalar := 5 }] }
theorem rowR6_0060_000_39_valid : (rowR6_0060_000_39).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_40 : ExtensionRow := { move := 190, child := 439, matrix := ![1,0,4,1,12,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 1, scalar := 12 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 124, scalar := 5 },{ source := 120, target := 52, scalar := 14 },{ source := 135, target := 141, scalar := 10 },{ source := 190, target := 0, scalar := 1 }] }
theorem rowR6_0060_000_40_valid : (rowR6_0060_000_40).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_41 : ExtensionRow := { move := 192, child := 439, matrix := ![9,15,14,10,0,15,6,0,1], witnesses := [{ source := 0, target := 52, scalar := 14 },{ source := 1, target := 17, scalar := 15 },{ source := 17, target := 141, scalar := 9 },{ source := 34, target := 124, scalar := 8 },{ source := 120, target := 34, scalar := 1 },{ source := 135, target := 1, scalar := 14 },{ source := 192, target := 0, scalar := 9 }] }
theorem rowR6_0060_000_41_valid : (rowR6_0060_000_41).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_42 : ExtensionRow := { move := 196, child := 439, matrix := ![0,9,4,2,10,0,0,6,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 141, scalar := 9 },{ source := 17, target := 1, scalar := 2 },{ source := 34, target := 124, scalar := 13 },{ source := 120, target := 52, scalar := 12 },{ source := 135, target := 34, scalar := 1 },{ source := 196, target := 0, scalar := 15 }] }
theorem rowR6_0060_000_42_valid : (rowR6_0060_000_42).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_43 : ExtensionRow := { move := 198, child := 439, matrix := ![12,1,4,11,1,0,7,1,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 12 },{ source := 34, target := 141, scalar := 9 },{ source := 120, target := 124, scalar := 5 },{ source := 135, target := 1, scalar := 12 },{ source := 198, target := 0, scalar := 12 }] }
theorem rowR6_0060_000_43_valid : (rowR6_0060_000_43).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_44 : ExtensionRow := { move := 202, child := 439, matrix := ![9,2,11,10,4,0,6,6,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 52, scalar := 2 },{ source := 17, target := 141, scalar := 9 },{ source := 34, target := 1, scalar := 14 },{ source := 120, target := 34, scalar := 1 },{ source := 135, target := 124, scalar := 8 },{ source := 202, target := 0, scalar := 9 }] }
theorem rowR6_0060_000_44_valid : (rowR6_0060_000_44).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_45 : ExtensionRow := { move := 205, child := 439, matrix := ![5,0,4,13,12,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 1, scalar := 12 },{ source := 17, target := 124, scalar := 5 },{ source := 34, target := 34, scalar := 1 },{ source := 120, target := 141, scalar := 10 },{ source := 135, target := 52, scalar := 14 },{ source := 205, target := 0, scalar := 1 }] }
theorem rowR6_0060_000_45_valid : (rowR6_0060_000_45).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_46 : ExtensionRow := { move := 206, child := 439, matrix := ![1,8,11,1,5,0,1,7,0], witnesses := [{ source := 0, target := 17, scalar := 11 },{ source := 1, target := 124, scalar := 8 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 52, scalar := 2 },{ source := 120, target := 1, scalar := 12 },{ source := 135, target := 141, scalar := 3 },{ source := 206, target := 0, scalar := 5 }] }
theorem rowR6_0060_000_46_valid : (rowR6_0060_000_46).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowR6_0060_000_47 : ExtensionRow := { move := 207, child := 439, matrix := ![8,15,14,5,0,15,7,0,1], witnesses := [{ source := 0, target := 52, scalar := 14 },{ source := 1, target := 17, scalar := 15 },{ source := 17, target := 124, scalar := 8 },{ source := 34, target := 141, scalar := 9 },{ source := 120, target := 1, scalar := 14 },{ source := 135, target := 34, scalar := 1 },{ source := 207, target := 0, scalar := 9 }] }
theorem rowR6_0060_000_47_valid : (rowR6_0060_000_47).ValidFor level7 {0,1,17,34,120,135} := by decide

noncomputable def rowsR6_0060_000 : List ExtensionRow := [rowR6_0060_000_0,rowR6_0060_000_1,rowR6_0060_000_2,rowR6_0060_000_3,rowR6_0060_000_4,rowR6_0060_000_5,rowR6_0060_000_6,rowR6_0060_000_7,rowR6_0060_000_8,rowR6_0060_000_9,rowR6_0060_000_10,rowR6_0060_000_11,rowR6_0060_000_12,rowR6_0060_000_13,rowR6_0060_000_14,rowR6_0060_000_15,rowR6_0060_000_16,rowR6_0060_000_17,rowR6_0060_000_18,rowR6_0060_000_19,rowR6_0060_000_20,rowR6_0060_000_21,rowR6_0060_000_22,rowR6_0060_000_23,rowR6_0060_000_24,rowR6_0060_000_25,rowR6_0060_000_26,rowR6_0060_000_27,rowR6_0060_000_28,rowR6_0060_000_29,rowR6_0060_000_30,rowR6_0060_000_31,rowR6_0060_000_32,rowR6_0060_000_33,rowR6_0060_000_34,rowR6_0060_000_35,rowR6_0060_000_36,rowR6_0060_000_37,rowR6_0060_000_38,rowR6_0060_000_39,rowR6_0060_000_40,rowR6_0060_000_41,rowR6_0060_000_42,rowR6_0060_000_43,rowR6_0060_000_44,rowR6_0060_000_45,rowR6_0060_000_46,rowR6_0060_000_47]

theorem rowsR6_0060_000_valid : RowListValid level7 {0,1,17,34,120,135} rowsR6_0060_000 := by
  intro r hr
  simp only [rowsR6_0060_000, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR6_0060_000_0_valid
  · exact rowR6_0060_000_1_valid
  · exact rowR6_0060_000_2_valid
  · exact rowR6_0060_000_3_valid
  · exact rowR6_0060_000_4_valid
  · exact rowR6_0060_000_5_valid
  · exact rowR6_0060_000_6_valid
  · exact rowR6_0060_000_7_valid
  · exact rowR6_0060_000_8_valid
  · exact rowR6_0060_000_9_valid
  · exact rowR6_0060_000_10_valid
  · exact rowR6_0060_000_11_valid
  · exact rowR6_0060_000_12_valid
  · exact rowR6_0060_000_13_valid
  · exact rowR6_0060_000_14_valid
  · exact rowR6_0060_000_15_valid
  · exact rowR6_0060_000_16_valid
  · exact rowR6_0060_000_17_valid
  · exact rowR6_0060_000_18_valid
  · exact rowR6_0060_000_19_valid
  · exact rowR6_0060_000_20_valid
  · exact rowR6_0060_000_21_valid
  · exact rowR6_0060_000_22_valid
  · exact rowR6_0060_000_23_valid
  · exact rowR6_0060_000_24_valid
  · exact rowR6_0060_000_25_valid
  · exact rowR6_0060_000_26_valid
  · exact rowR6_0060_000_27_valid
  · exact rowR6_0060_000_28_valid
  · exact rowR6_0060_000_29_valid
  · exact rowR6_0060_000_30_valid
  · exact rowR6_0060_000_31_valid
  · exact rowR6_0060_000_32_valid
  · exact rowR6_0060_000_33_valid
  · exact rowR6_0060_000_34_valid
  · exact rowR6_0060_000_35_valid
  · exact rowR6_0060_000_36_valid
  · exact rowR6_0060_000_37_valid
  · exact rowR6_0060_000_38_valid
  · exact rowR6_0060_000_39_valid
  · exact rowR6_0060_000_40_valid
  · exact rowR6_0060_000_41_valid
  · exact rowR6_0060_000_42_valid
  · exact rowR6_0060_000_43_valid
  · exact rowR6_0060_000_44_valid
  · exact rowR6_0060_000_45_valid
  · exact rowR6_0060_000_46_valid
  · exact rowR6_0060_000_47_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
