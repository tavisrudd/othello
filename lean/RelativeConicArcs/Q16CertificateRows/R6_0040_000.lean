import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR6_0040_000_0 : ExtensionRow := { move := 67, child := 7, matrix := ![1,0,0,1,1,0,1,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 54, target := 69, scalar := 1 },{ source := 67, target := 52, scalar := 1 },{ source := 108, target := 91, scalar := 1 }] }
theorem rowR6_0040_000_0_valid : (rowR6_0040_000_0).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_1 : ExtensionRow := { move := 71, child := 7, matrix := ![0,3,3,0,0,5,12,0,12], witnesses := [{ source := 0, target := 69, scalar := 3 },{ source := 1, target := 17, scalar := 3 },{ source := 17, target := 0, scalar := 12 },{ source := 34, target := 1, scalar := 5 },{ source := 54, target := 91, scalar := 9 },{ source := 71, target := 52, scalar := 15 },{ source := 108, target := 34, scalar := 1 }] }
theorem rowR6_0040_000_1_valid : (rowR6_0040_000_1).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_2 : ExtensionRow := { move := 74, child := 181, matrix := ![1,7,3,1,14,0,1,9,0], witnesses := [{ source := 0, target := 17, scalar := 3 },{ source := 1, target := 52, scalar := 7 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 72, scalar := 5 },{ source := 54, target := 1, scalar := 14 },{ source := 74, target := 0, scalar := 9 },{ source := 108, target := 218, scalar := 7 }] }
theorem rowR6_0040_000_2_valid : (rowR6_0040_000_2).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_3 : ExtensionRow := { move := 75, child := 430, matrix := ![5,0,5,0,2,2,0,0,12], witnesses := [{ source := 0, target := 110, scalar := 5 },{ source := 1, target := 1, scalar := 2 },{ source := 17, target := 17, scalar := 5 },{ source := 34, target := 0, scalar := 12 },{ source := 54, target := 52, scalar := 7 },{ source := 75, target := 34, scalar := 1 },{ source := 108, target := 143, scalar := 4 }] }
theorem rowR6_0040_000_3_valid : (rowR6_0040_000_3).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_4 : ExtensionRow := { move := 77, child := 86, matrix := ![0,1,13,3,1,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 13 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 3 },{ source := 34, target := 139, scalar := 12 },{ source := 54, target := 71, scalar := 14 },{ source := 77, target := 0, scalar := 3 },{ source := 108, target := 52, scalar := 3 }] }
theorem rowR6_0040_000_4_valid : (rowR6_0040_000_4).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_5 : ExtensionRow := { move := 78, child := 7, matrix := ![9,1,9,0,1,2,0,1,5], witnesses := [{ source := 0, target := 91, scalar := 9 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 17, scalar := 9 },{ source := 34, target := 69, scalar := 1 },{ source := 54, target := 1, scalar := 8 },{ source := 78, target := 52, scalar := 5 },{ source := 108, target := 0, scalar := 4 }] }
theorem rowR6_0040_000_5_valid : (rowR6_0040_000_5).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_6 : ExtensionRow := { move := 80, child := 86, matrix := ![2,10,1,6,7,1,12,13,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 52, scalar := 10 },{ source := 17, target := 71, scalar := 2 },{ source := 34, target := 17, scalar := 9 },{ source := 54, target := 1, scalar := 13 },{ source := 80, target := 0, scalar := 7 },{ source := 108, target := 139, scalar := 13 }] }
theorem rowR6_0040_000_6_valid : (rowR6_0040_000_6).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_7 : ExtensionRow := { move := 84, child := 7, matrix := ![15,14,0,0,1,0,0,13,12], witnesses := [{ source := 0, target := 0, scalar := 12 },{ source := 1, target := 69, scalar := 14 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 34, scalar := 1 },{ source := 54, target := 1, scalar := 2 },{ source := 84, target := 52, scalar := 2 },{ source := 108, target := 91, scalar := 12 }] }
theorem rowR6_0040_000_7_valid : (rowR6_0040_000_7).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_8 : ExtensionRow := { move := 87, child := 86, matrix := ![6,0,1,0,8,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 1, scalar := 8 },{ source := 17, target := 17, scalar := 6 },{ source := 34, target := 71, scalar := 7 },{ source := 54, target := 52, scalar := 3 },{ source := 87, target := 0, scalar := 6 },{ source := 108, target := 139, scalar := 13 }] }
theorem rowR6_0040_000_8_valid : (rowR6_0040_000_8).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_9 : ExtensionRow := { move := 88, child := 181, matrix := ![6,0,7,10,11,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 7 },{ source := 1, target := 1, scalar := 11 },{ source := 17, target := 72, scalar := 6 },{ source := 34, target := 34, scalar := 1 },{ source := 54, target := 52, scalar := 14 },{ source := 88, target := 0, scalar := 1 },{ source := 108, target := 218, scalar := 2 }] }
theorem rowR6_0040_000_9_valid : (rowR6_0040_000_9).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_10 : ExtensionRow := { move := 89, child := 7, matrix := ![14,0,3,1,13,12,13,0,13], witnesses := [{ source := 0, target := 91, scalar := 3 },{ source := 1, target := 1, scalar := 13 },{ source := 17, target := 69, scalar := 14 },{ source := 34, target := 17, scalar := 13 },{ source := 54, target := 34, scalar := 1 },{ source := 89, target := 52, scalar := 5 },{ source := 108, target := 0, scalar := 11 }] }
theorem rowR6_0040_000_10_valid : (rowR6_0040_000_10).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_11 : ExtensionRow := { move := 93, child := 7, matrix := ![0,3,3,9,12,5,0,13,12], witnesses := [{ source := 0, target := 69, scalar := 3 },{ source := 1, target := 91, scalar := 3 },{ source := 17, target := 1, scalar := 9 },{ source := 34, target := 0, scalar := 1 },{ source := 54, target := 17, scalar := 9 },{ source := 93, target := 52, scalar := 11 },{ source := 108, target := 34, scalar := 1 }] }
theorem rowR6_0040_000_11_valid : (rowR6_0040_000_11).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_12 : ExtensionRow := { move := 95, child := 430, matrix := ![5,1,0,0,5,10,0,13,0], witnesses := [{ source := 0, target := 1, scalar := 10 },{ source := 1, target := 110, scalar := 1 },{ source := 17, target := 17, scalar := 5 },{ source := 34, target := 143, scalar := 4 },{ source := 54, target := 52, scalar := 7 },{ source := 95, target := 34, scalar := 1 },{ source := 108, target := 0, scalar := 12 }] }
theorem rowR6_0040_000_12_valid : (rowR6_0040_000_12).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_13 : ExtensionRow := { move := 96, child := 86, matrix := ![4,12,8,15,7,0,14,14,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 71, scalar := 12 },{ source := 17, target := 139, scalar := 4 },{ source := 34, target := 1, scalar := 8 },{ source := 54, target := 34, scalar := 1 },{ source := 96, target := 0, scalar := 3 },{ source := 108, target := 52, scalar := 10 }] }
theorem rowR6_0040_000_13_valid : (rowR6_0040_000_13).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_14 : ExtensionRow := { move := 115, child := 181, matrix := ![3,7,1,0,14,1,0,9,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 52, scalar := 7 },{ source := 17, target := 17, scalar := 3 },{ source := 34, target := 72, scalar := 5 },{ source := 54, target := 218, scalar := 8 },{ source := 108, target := 1, scalar := 8 },{ source := 115, target := 0, scalar := 1 }] }
theorem rowR6_0040_000_14_valid : (rowR6_0040_000_14).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_15 : ExtensionRow := { move := 120, child := 181, matrix := ![0,12,2,11,15,4,0,6,6], witnesses := [{ source := 0, target := 52, scalar := 2 },{ source := 1, target := 218, scalar := 12 },{ source := 17, target := 1, scalar := 11 },{ source := 34, target := 17, scalar := 14 },{ source := 54, target := 34, scalar := 1 },{ source := 108, target := 72, scalar := 12 },{ source := 120, target := 0, scalar := 6 }] }
theorem rowR6_0040_000_15_valid : (rowR6_0040_000_15).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_16 : ExtensionRow := { move := 121, child := 86, matrix := ![14,9,7,0,8,6,0,3,3], witnesses := [{ source := 0, target := 139, scalar := 7 },{ source := 1, target := 71, scalar := 9 },{ source := 17, target := 17, scalar := 14 },{ source := 34, target := 1, scalar := 14 },{ source := 54, target := 52, scalar := 7 },{ source := 108, target := 34, scalar := 1 },{ source := 121, target := 0, scalar := 1 }] }
theorem rowR6_0040_000_16_valid : (rowR6_0040_000_16).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_17 : ExtensionRow := { move := 122, child := 181, matrix := ![10,1,11,1,1,14,5,1,4], witnesses := [{ source := 0, target := 72, scalar := 11 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 218, scalar := 10 },{ source := 34, target := 1, scalar := 14 },{ source := 54, target := 17, scalar := 9 },{ source := 108, target := 52, scalar := 6 },{ source := 122, target := 0, scalar := 1 }] }
theorem rowR6_0040_000_17_valid : (rowR6_0040_000_17).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_18 : ExtensionRow := { move := 123, child := 86, matrix := ![4,7,9,15,0,8,14,0,3], witnesses := [{ source := 0, target := 71, scalar := 9 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 139, scalar := 4 },{ source := 34, target := 52, scalar := 10 },{ source := 54, target := 34, scalar := 1 },{ source := 108, target := 1, scalar := 8 },{ source := 123, target := 0, scalar := 3 }] }
theorem rowR6_0040_000_18_valid : (rowR6_0040_000_18).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_19 : ExtensionRow := { move := 125, child := 7, matrix := ![15,14,0,9,1,9,12,13,0], witnesses := [{ source := 0, target := 1, scalar := 9 },{ source := 1, target := 69, scalar := 14 },{ source := 17, target := 91, scalar := 15 },{ source := 34, target := 34, scalar := 1 },{ source := 54, target := 0, scalar := 5 },{ source := 108, target := 17, scalar := 12 },{ source := 125, target := 52, scalar := 13 }] }
theorem rowR6_0040_000_19_valid : (rowR6_0040_000_19).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_20 : ExtensionRow := { move := 127, child := 86, matrix := ![10,1,7,13,1,14,9,1,9], witnesses := [{ source := 0, target := 52, scalar := 7 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 71, scalar := 10 },{ source := 34, target := 139, scalar := 12 },{ source := 54, target := 1, scalar := 12 },{ source := 108, target := 17, scalar := 11 },{ source := 127, target := 0, scalar := 8 }] }
theorem rowR6_0040_000_20_valid : (rowR6_0040_000_20).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_21 : ExtensionRow := { move := 131, child := 86, matrix := ![4,11,0,15,5,10,14,14,0], witnesses := [{ source := 0, target := 1, scalar := 10 },{ source := 1, target := 52, scalar := 11 },{ source := 17, target := 139, scalar := 4 },{ source := 34, target := 17, scalar := 15 },{ source := 54, target := 34, scalar := 1 },{ source := 108, target := 71, scalar := 5 },{ source := 131, target := 0, scalar := 2 }] }
theorem rowR6_0040_000_21_valid : (rowR6_0040_000_21).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_22 : ExtensionRow := { move := 132, child := 7, matrix := ![1,13,12,1,1,0,1,11,0], witnesses := [{ source := 0, target := 17, scalar := 12 },{ source := 1, target := 91, scalar := 13 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 10 },{ source := 54, target := 69, scalar := 1 },{ source := 108, target := 1, scalar := 4 },{ source := 132, target := 52, scalar := 3 }] }
theorem rowR6_0040_000_22_valid : (rowR6_0040_000_22).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_23 : ExtensionRow := { move := 135, child := 181, matrix := ![10,9,0,7,6,1,13,13,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 218, scalar := 9 },{ source := 17, target := 52, scalar := 10 },{ source := 34, target := 17, scalar := 3 },{ source := 54, target := 72, scalar := 11 },{ source := 108, target := 34, scalar := 1 },{ source := 135, target := 0, scalar := 8 }] }
theorem rowR6_0040_000_23_valid : (rowR6_0040_000_23).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_24 : ExtensionRow := { move := 137, child := 181, matrix := ![1,12,2,1,7,11,1,2,1], witnesses := [{ source := 0, target := 218, scalar := 2 },{ source := 1, target := 72, scalar := 12 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 52, scalar := 15 },{ source := 54, target := 1, scalar := 14 },{ source := 108, target := 17, scalar := 13 },{ source := 137, target := 0, scalar := 7 }] }
theorem rowR6_0040_000_24_valid : (rowR6_0040_000_24).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_25 : ExtensionRow := { move := 141, child := 430, matrix := ![4,0,4,7,7,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 1, scalar := 7 },{ source := 17, target := 110, scalar := 4 },{ source := 34, target := 0, scalar := 1 },{ source := 54, target := 143, scalar := 3 },{ source := 108, target := 52, scalar := 14 },{ source := 141, target := 34, scalar := 1 }] }
theorem rowR6_0040_000_25_valid : (rowR6_0040_000_25).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_26 : ExtensionRow := { move := 142, child := 7, matrix := ![12,13,1,5,0,1,1,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 13 },{ source := 17, target := 91, scalar := 12 },{ source := 34, target := 1, scalar := 4 },{ source := 54, target := 0, scalar := 4 },{ source := 108, target := 69, scalar := 11 },{ source := 142, target := 52, scalar := 4 }] }
theorem rowR6_0040_000_26_valid : (rowR6_0040_000_26).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_27 : ExtensionRow := { move := 148, child := 86, matrix := ![1,15,0,1,0,14,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 14 },{ source := 1, target := 17, scalar := 15 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 52, scalar := 14 },{ source := 54, target := 139, scalar := 12 },{ source := 108, target := 71, scalar := 7 },{ source := 148, target := 0, scalar := 1 }] }
theorem rowR6_0040_000_27_valid : (rowR6_0040_000_27).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_28 : ExtensionRow := { move := 151, child := 430, matrix := ![6,0,6,1,0,0,2,2,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 0, scalar := 2 },{ source := 17, target := 143, scalar := 6 },{ source := 34, target := 1, scalar := 1 },{ source := 54, target := 110, scalar := 11 },{ source := 108, target := 52, scalar := 9 },{ source := 151, target := 34, scalar := 1 }] }
theorem rowR6_0040_000_28_valid : (rowR6_0040_000_28).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_29 : ExtensionRow := { move := 154, child := 7, matrix := ![0,0,1,0,1,1,1,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 54, target := 91, scalar := 5 },{ source := 108, target := 69, scalar := 11 },{ source := 154, target := 52, scalar := 9 }] }
theorem rowR6_0040_000_29_valid : (rowR6_0040_000_29).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_30 : ExtensionRow := { move := 155, child := 181, matrix := ![6,4,0,10,0,1,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 17, scalar := 4 },{ source := 17, target := 72, scalar := 6 },{ source := 34, target := 218, scalar := 2 },{ source := 54, target := 52, scalar := 14 },{ source := 108, target := 34, scalar := 1 },{ source := 155, target := 0, scalar := 1 }] }
theorem rowR6_0040_000_30_valid : (rowR6_0040_000_30).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_31 : ExtensionRow := { move := 157, child := 7, matrix := ![14,0,3,1,0,0,13,6,0], witnesses := [{ source := 0, target := 17, scalar := 3 },{ source := 1, target := 0, scalar := 6 },{ source := 17, target := 69, scalar := 14 },{ source := 34, target := 91, scalar := 13 },{ source := 54, target := 34, scalar := 1 },{ source := 108, target := 1, scalar := 1 },{ source := 157, target := 52, scalar := 9 }] }
theorem rowR6_0040_000_31_valid : (rowR6_0040_000_31).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_32 : ExtensionRow := { move := 160, child := 181, matrix := ![0,5,9,11,10,6,0,15,13], witnesses := [{ source := 0, target := 218, scalar := 9 },{ source := 1, target := 52, scalar := 5 },{ source := 17, target := 1, scalar := 11 },{ source := 34, target := 72, scalar := 12 },{ source := 54, target := 34, scalar := 1 },{ source := 108, target := 17, scalar := 14 },{ source := 160, target := 0, scalar := 6 }] }
theorem rowR6_0040_000_32_valid : (rowR6_0040_000_32).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_33 : ExtensionRow := { move := 163, child := 181, matrix := ![0,3,4,11,5,0,0,9,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 72, scalar := 3 },{ source := 17, target := 1, scalar := 11 },{ source := 34, target := 52, scalar := 7 },{ source := 54, target := 34, scalar := 1 },{ source := 108, target := 218, scalar := 5 },{ source := 163, target := 0, scalar := 13 }] }
theorem rowR6_0040_000_33_valid : (rowR6_0040_000_33).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_34 : ExtensionRow := { move := 165, child := 430, matrix := ![4,10,0,7,0,8,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 8 },{ source := 1, target := 17, scalar := 10 },{ source := 17, target := 110, scalar := 4 },{ source := 34, target := 52, scalar := 14 },{ source := 54, target := 143, scalar := 3 },{ source := 108, target := 0, scalar := 1 },{ source := 165, target := 34, scalar := 1 }] }
theorem rowR6_0040_000_34_valid : (rowR6_0040_000_34).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_35 : ExtensionRow := { move := 168, child := 7, matrix := ![14,14,0,1,0,0,13,0,13], witnesses := [{ source := 0, target := 0, scalar := 13 },{ source := 1, target := 17, scalar := 14 },{ source := 17, target := 69, scalar := 14 },{ source := 34, target := 1, scalar := 1 },{ source := 54, target := 34, scalar := 1 },{ source := 108, target := 91, scalar := 13 },{ source := 168, target := 52, scalar := 9 }] }
theorem rowR6_0040_000_35_valid : (rowR6_0040_000_35).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_36 : ExtensionRow := { move := 169, child := 86, matrix := ![11,4,14,14,15,0,15,14,0], witnesses := [{ source := 0, target := 17, scalar := 14 },{ source := 1, target := 139, scalar := 4 },{ source := 17, target := 71, scalar := 11 },{ source := 34, target := 34, scalar := 1 },{ source := 54, target := 1, scalar := 3 },{ source := 108, target := 52, scalar := 4 },{ source := 169, target := 0, scalar := 8 }] }
theorem rowR6_0040_000_36_valid : (rowR6_0040_000_36).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_37 : ExtensionRow := { move := 171, child := 7, matrix := ![0,14,15,9,1,9,0,13,12], witnesses := [{ source := 0, target := 91, scalar := 15 },{ source := 1, target := 69, scalar := 14 },{ source := 17, target := 1, scalar := 9 },{ source := 34, target := 34, scalar := 1 },{ source := 54, target := 17, scalar := 9 },{ source := 108, target := 0, scalar := 1 },{ source := 171, target := 52, scalar := 11 }] }
theorem rowR6_0040_000_37_valid : (rowR6_0040_000_37).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_38 : ExtensionRow := { move := 175, child := 86, matrix := ![0,15,1,14,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 15 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 52, scalar := 14 },{ source := 54, target := 71, scalar := 8 },{ source := 108, target := 139, scalar := 13 },{ source := 175, target := 0, scalar := 14 }] }
theorem rowR6_0040_000_38_valid : (rowR6_0040_000_38).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_39 : ExtensionRow := { move := 176, child := 7, matrix := ![15,0,3,9,12,5,12,0,12], witnesses := [{ source := 0, target := 69, scalar := 3 },{ source := 1, target := 1, scalar := 12 },{ source := 17, target := 91, scalar := 15 },{ source := 34, target := 17, scalar := 12 },{ source := 54, target := 0, scalar := 5 },{ source := 108, target := 34, scalar := 1 },{ source := 176, target := 52, scalar := 13 }] }
theorem rowR6_0040_000_39_valid : (rowR6_0040_000_39).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_40 : ExtensionRow := { move := 180, child := 86, matrix := ![7,1,10,14,1,13,9,1,9], witnesses := [{ source := 0, target := 71, scalar := 10 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 7 },{ source := 34, target := 139, scalar := 12 },{ source := 54, target := 17, scalar := 1 },{ source := 108, target := 1, scalar := 13 },{ source := 180, target := 0, scalar := 11 }] }
theorem rowR6_0040_000_40_valid : (rowR6_0040_000_40).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_41 : ExtensionRow := { move := 181, child := 86, matrix := ![4,0,1,15,2,2,14,0,3], witnesses := [{ source := 0, target := 52, scalar := 1 },{ source := 1, target := 1, scalar := 2 },{ source := 17, target := 139, scalar := 4 },{ source := 34, target := 71, scalar := 5 },{ source := 54, target := 34, scalar := 1 },{ source := 108, target := 17, scalar := 15 },{ source := 181, target := 0, scalar := 2 }] }
theorem rowR6_0040_000_41_valid : (rowR6_0040_000_41).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_42 : ExtensionRow := { move := 186, child := 86, matrix := ![0,1,7,4,2,6,0,3,3], witnesses := [{ source := 0, target := 139, scalar := 7 },{ source := 1, target := 52, scalar := 1 },{ source := 17, target := 1, scalar := 4 },{ source := 34, target := 17, scalar := 6 },{ source := 54, target := 71, scalar := 10 },{ source := 108, target := 34, scalar := 1 },{ source := 186, target := 0, scalar := 5 }] }
theorem rowR6_0040_000_42_valid : (rowR6_0040_000_42).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_43 : ExtensionRow := { move := 189, child := 181, matrix := ![0,10,15,11,0,2,0,0,11], witnesses := [{ source := 0, target := 72, scalar := 15 },{ source := 1, target := 17, scalar := 10 },{ source := 17, target := 1, scalar := 11 },{ source := 34, target := 218, scalar := 5 },{ source := 54, target := 34, scalar := 1 },{ source := 108, target := 52, scalar := 7 },{ source := 189, target := 0, scalar := 13 }] }
theorem rowR6_0040_000_43_valid : (rowR6_0040_000_43).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_44 : ExtensionRow := { move := 190, child := 181, matrix := ![9,5,1,8,9,1,10,11,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 218, scalar := 5 },{ source := 17, target := 72, scalar := 9 },{ source := 34, target := 17, scalar := 13 },{ source := 54, target := 52, scalar := 6 },{ source := 108, target := 1, scalar := 8 },{ source := 190, target := 0, scalar := 5 }] }
theorem rowR6_0040_000_44_valid : (rowR6_0040_000_44).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_45 : ExtensionRow := { move := 191, child := 7, matrix := ![1,0,0,1,0,5,1,11,0], witnesses := [{ source := 0, target := 1, scalar := 5 },{ source := 1, target := 0, scalar := 11 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 91, scalar := 1 },{ source := 54, target := 69, scalar := 1 },{ source := 108, target := 17, scalar := 1 },{ source := 191, target := 52, scalar := 1 }] }
theorem rowR6_0040_000_45_valid : (rowR6_0040_000_45).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_46 : ExtensionRow := { move := 192, child := 181, matrix := ![15,1,14,0,1,15,0,1,1], witnesses := [{ source := 0, target := 52, scalar := 14 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 1, scalar := 14 },{ source := 54, target := 218, scalar := 14 },{ source := 108, target := 72, scalar := 2 },{ source := 192, target := 0, scalar := 5 }] }
theorem rowR6_0040_000_46_valid : (rowR6_0040_000_46).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowR6_0040_000_47 : ExtensionRow := { move := 195, child := 86, matrix := ![0,4,5,4,15,10,0,14,15], witnesses := [{ source := 0, target := 52, scalar := 5 },{ source := 1, target := 139, scalar := 4 },{ source := 17, target := 1, scalar := 4 },{ source := 34, target := 34, scalar := 1 },{ source := 54, target := 71, scalar := 10 },{ source := 108, target := 17, scalar := 6 },{ source := 195, target := 0, scalar := 5 }] }
theorem rowR6_0040_000_47_valid : (rowR6_0040_000_47).ValidFor level7 {0,1,17,34,54,108} := by decide

noncomputable def rowsR6_0040_000 : List ExtensionRow := [rowR6_0040_000_0,rowR6_0040_000_1,rowR6_0040_000_2,rowR6_0040_000_3,rowR6_0040_000_4,rowR6_0040_000_5,rowR6_0040_000_6,rowR6_0040_000_7,rowR6_0040_000_8,rowR6_0040_000_9,rowR6_0040_000_10,rowR6_0040_000_11,rowR6_0040_000_12,rowR6_0040_000_13,rowR6_0040_000_14,rowR6_0040_000_15,rowR6_0040_000_16,rowR6_0040_000_17,rowR6_0040_000_18,rowR6_0040_000_19,rowR6_0040_000_20,rowR6_0040_000_21,rowR6_0040_000_22,rowR6_0040_000_23,rowR6_0040_000_24,rowR6_0040_000_25,rowR6_0040_000_26,rowR6_0040_000_27,rowR6_0040_000_28,rowR6_0040_000_29,rowR6_0040_000_30,rowR6_0040_000_31,rowR6_0040_000_32,rowR6_0040_000_33,rowR6_0040_000_34,rowR6_0040_000_35,rowR6_0040_000_36,rowR6_0040_000_37,rowR6_0040_000_38,rowR6_0040_000_39,rowR6_0040_000_40,rowR6_0040_000_41,rowR6_0040_000_42,rowR6_0040_000_43,rowR6_0040_000_44,rowR6_0040_000_45,rowR6_0040_000_46,rowR6_0040_000_47]

theorem rowsR6_0040_000_valid : RowListValid level7 {0,1,17,34,54,108} rowsR6_0040_000 := by
  intro r hr
  simp only [rowsR6_0040_000, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR6_0040_000_0_valid
  · exact rowR6_0040_000_1_valid
  · exact rowR6_0040_000_2_valid
  · exact rowR6_0040_000_3_valid
  · exact rowR6_0040_000_4_valid
  · exact rowR6_0040_000_5_valid
  · exact rowR6_0040_000_6_valid
  · exact rowR6_0040_000_7_valid
  · exact rowR6_0040_000_8_valid
  · exact rowR6_0040_000_9_valid
  · exact rowR6_0040_000_10_valid
  · exact rowR6_0040_000_11_valid
  · exact rowR6_0040_000_12_valid
  · exact rowR6_0040_000_13_valid
  · exact rowR6_0040_000_14_valid
  · exact rowR6_0040_000_15_valid
  · exact rowR6_0040_000_16_valid
  · exact rowR6_0040_000_17_valid
  · exact rowR6_0040_000_18_valid
  · exact rowR6_0040_000_19_valid
  · exact rowR6_0040_000_20_valid
  · exact rowR6_0040_000_21_valid
  · exact rowR6_0040_000_22_valid
  · exact rowR6_0040_000_23_valid
  · exact rowR6_0040_000_24_valid
  · exact rowR6_0040_000_25_valid
  · exact rowR6_0040_000_26_valid
  · exact rowR6_0040_000_27_valid
  · exact rowR6_0040_000_28_valid
  · exact rowR6_0040_000_29_valid
  · exact rowR6_0040_000_30_valid
  · exact rowR6_0040_000_31_valid
  · exact rowR6_0040_000_32_valid
  · exact rowR6_0040_000_33_valid
  · exact rowR6_0040_000_34_valid
  · exact rowR6_0040_000_35_valid
  · exact rowR6_0040_000_36_valid
  · exact rowR6_0040_000_37_valid
  · exact rowR6_0040_000_38_valid
  · exact rowR6_0040_000_39_valid
  · exact rowR6_0040_000_40_valid
  · exact rowR6_0040_000_41_valid
  · exact rowR6_0040_000_42_valid
  · exact rowR6_0040_000_43_valid
  · exact rowR6_0040_000_44_valid
  · exact rowR6_0040_000_45_valid
  · exact rowR6_0040_000_46_valid
  · exact rowR6_0040_000_47_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
