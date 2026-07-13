import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR6_0014_000_0 : ExtensionRow := { move := 70, child := 4, matrix := ![8,9,0,0,1,0,0,8,9], witnesses := [{ source := 0, target := 0, scalar := 9 },{ source := 1, target := 52, scalar := 9 },{ source := 17, target := 17, scalar := 8 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 86, scalar := 9 },{ source := 70, target := 1, scalar := 3 },{ source := 101, target := 69, scalar := 3 }] }
theorem rowR6_0014_000_0_valid : (rowR6_0014_000_0).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_1 : ExtensionRow := { move := 71, child := 76, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 71, target := 71, scalar := 1 },{ source := 101, target := 101, scalar := 1 }] }
theorem rowR6_0014_000_1_valid : (rowR6_0014_000_1).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_2 : ExtensionRow := { move := 72, child := 143, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 72, target := 72, scalar := 1 },{ source := 101, target := 101, scalar := 1 }] }
theorem rowR6_0014_000_2_valid : (rowR6_0014_000_2).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_3 : ExtensionRow := { move := 73, child := 197, matrix := ![0,0,14,1,0,0,0,9,0], witnesses := [{ source := 0, target := 17, scalar := 14 },{ source := 1, target := 0, scalar := 9 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 73, scalar := 14 },{ source := 52, target := 34, scalar := 1 },{ source := 73, target := 52, scalar := 9 },{ source := 101, target := 91, scalar := 13 }] }
theorem rowR6_0014_000_3_valid : (rowR6_0014_000_3).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_4 : ExtensionRow := { move := 74, child := 214, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 74, target := 74, scalar := 1 },{ source := 101, target := 101, scalar := 1 }] }
theorem rowR6_0014_000_4_valid : (rowR6_0014_000_4).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_5 : ExtensionRow := { move := 79, child := 215, matrix := ![5,11,14,0,1,1,0,4,7], witnesses := [{ source := 0, target := 74, scalar := 14 },{ source := 1, target := 104, scalar := 11 },{ source := 17, target := 17, scalar := 5 },{ source := 34, target := 0, scalar := 3 },{ source := 52, target := 34, scalar := 1 },{ source := 79, target := 1, scalar := 13 },{ source := 101, target := 52, scalar := 9 }] }
theorem rowR6_0014_000_5_valid : (rowR6_0014_000_5).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_6 : ExtensionRow := { move := 80, child := 219, matrix := ![1,13,14,1,8,15,1,1,1], witnesses := [{ source := 0, target := 52, scalar := 14 },{ source := 1, target := 117, scalar := 13 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 74, scalar := 2 },{ source := 52, target := 17, scalar := 9 },{ source := 80, target := 0, scalar := 13 },{ source := 101, target := 1, scalar := 6 }] }
theorem rowR6_0014_000_6_valid : (rowR6_0014_000_6).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_7 : ExtensionRow := { move := 83, child := 4, matrix := ![12,13,0,0,4,5,0,1,0], witnesses := [{ source := 0, target := 1, scalar := 5 },{ source := 1, target := 69, scalar := 13 },{ source := 17, target := 17, scalar := 12 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 86, scalar := 5 },{ source := 83, target := 52, scalar := 13 },{ source := 101, target := 0, scalar := 5 }] }
theorem rowR6_0014_000_7_valid : (rowR6_0014_000_7).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_8 : ExtensionRow := { move := 90, child := 143, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 90, target := 72, scalar := 13 },{ source := 101, target := 101, scalar := 1 }] }
theorem rowR6_0014_000_8_valid : (rowR6_0014_000_8).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_9 : ExtensionRow := { move := 91, child := 352, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 91, target := 91, scalar := 1 },{ source := 101, target := 101, scalar := 1 }] }
theorem rowR6_0014_000_9_valid : (rowR6_0014_000_9).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_10 : ExtensionRow := { move := 92, child := 20, matrix := ![12,8,4,11,0,11,7,0,8], witnesses := [{ source := 0, target := 115, scalar := 4 },{ source := 1, target := 17, scalar := 8 },{ source := 17, target := 52, scalar := 12 },{ source := 34, target := 0, scalar := 15 },{ source := 52, target := 69, scalar := 3 },{ source := 92, target := 1, scalar := 2 },{ source := 101, target := 34, scalar := 1 }] }
theorem rowR6_0014_000_10_valid : (rowR6_0014_000_10).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_11 : ExtensionRow := { move := 93, child := 26, matrix := ![0,1,14,0,1,12,12,1,15], witnesses := [{ source := 0, target := 131, scalar := 14 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 12 },{ source := 34, target := 52, scalar := 15 },{ source := 52, target := 69, scalar := 3 },{ source := 93, target := 1, scalar := 11 },{ source := 101, target := 17, scalar := 8 }] }
theorem rowR6_0014_000_11_valid : (rowR6_0014_000_11).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_12 : ExtensionRow := { move := 94, child := 390, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 94, target := 94, scalar := 1 },{ source := 101, target := 101, scalar := 1 }] }
theorem rowR6_0014_000_12_valid : (rowR6_0014_000_12).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_13 : ExtensionRow := { move := 96, child := 76, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 96, target := 71, scalar := 11 },{ source := 101, target := 101, scalar := 1 }] }
theorem rowR6_0014_000_13_valid : (rowR6_0014_000_13).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_14 : ExtensionRow := { move := 115, child := 143, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 101, target := 101, scalar := 1 },{ source := 115, target := 72, scalar := 1 }] }
theorem rowR6_0014_000_14_valid : (rowR6_0014_000_14).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_15 : ExtensionRow := { move := 121, child := 403, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 101, target := 101, scalar := 1 },{ source := 121, target := 121, scalar := 1 }] }
theorem rowR6_0014_000_15_valid : (rowR6_0014_000_15).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_16 : ExtensionRow := { move := 124, child := 404, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 101, target := 101, scalar := 1 },{ source := 124, target := 124, scalar := 1 }] }
theorem rowR6_0014_000_16_valid : (rowR6_0014_000_16).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_17 : ExtensionRow := { move := 125, child := 219, matrix := ![13,1,2,8,1,6,1,1,1], witnesses := [{ source := 0, target := 74, scalar := 2 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 117, scalar := 13 },{ source := 34, target := 52, scalar := 14 },{ source := 52, target := 17, scalar := 9 },{ source := 101, target := 1, scalar := 6 },{ source := 125, target := 0, scalar := 11 }] }
theorem rowR6_0014_000_17_valid : (rowR6_0014_000_17).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_18 : ExtensionRow := { move := 126, child := 128, matrix := ![12,7,1,4,0,3,11,0,6], witnesses := [{ source := 0, target := 71, scalar := 1 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 243, scalar := 12 },{ source := 34, target := 52, scalar := 10 },{ source := 52, target := 34, scalar := 1 },{ source := 101, target := 1, scalar := 8 },{ source := 126, target := 0, scalar := 3 }] }
theorem rowR6_0014_000_18_valid : (rowR6_0014_000_18).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_19 : ExtensionRow := { move := 127, child := 20, matrix := ![4,0,12,11,0,11,8,15,7], witnesses := [{ source := 0, target := 52, scalar := 12 },{ source := 1, target := 0, scalar := 15 },{ source := 17, target := 115, scalar := 4 },{ source := 34, target := 17, scalar := 8 },{ source := 52, target := 69, scalar := 3 },{ source := 101, target := 34, scalar := 1 },{ source := 127, target := 1, scalar := 3 }] }
theorem rowR6_0014_000_19_valid : (rowR6_0014_000_19).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_20 : ExtensionRow := { move := 128, child := 195, matrix := ![1,7,0,1,14,11,1,9,0], witnesses := [{ source := 0, target := 1, scalar := 11 },{ source := 1, target := 52, scalar := 7 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 270, scalar := 6 },{ source := 52, target := 17, scalar := 15 },{ source := 101, target := 72, scalar := 9 },{ source := 128, target := 0, scalar := 2 }] }
theorem rowR6_0014_000_20_valid : (rowR6_0014_000_20).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_21 : ExtensionRow := { move := 131, child := 76, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 101, target := 101, scalar := 1 },{ source := 131, target := 71, scalar := 1 }] }
theorem rowR6_0014_000_21_valid : (rowR6_0014_000_21).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_22 : ExtensionRow := { move := 137, child := 26, matrix := ![1,0,15,1,0,13,1,12,2], witnesses := [{ source := 0, target := 52, scalar := 15 },{ source := 1, target := 0, scalar := 12 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 131, scalar := 14 },{ source := 52, target := 69, scalar := 3 },{ source := 101, target := 17, scalar := 8 },{ source := 137, target := 1, scalar := 3 }] }
theorem rowR6_0014_000_22_valid : (rowR6_0014_000_22).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_23 : ExtensionRow := { move := 138, child := 99, matrix := ![4,11,0,2,5,7,14,14,0], witnesses := [{ source := 0, target := 1, scalar := 7 },{ source := 1, target := 52, scalar := 11 },{ source := 17, target := 171, scalar := 4 },{ source := 34, target := 17, scalar := 15 },{ source := 52, target := 34, scalar := 1 },{ source := 101, target := 71, scalar := 5 },{ source := 138, target := 0, scalar := 2 }] }
theorem rowR6_0014_000_23_valid : (rowR6_0014_000_23).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_24 : ExtensionRow := { move := 139, child := 155, matrix := ![14,1,6,15,1,10,1,1,1], witnesses := [{ source := 0, target := 72, scalar := 6 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 147, scalar := 9 },{ source := 52, target := 17, scalar := 6 },{ source := 101, target := 1, scalar := 4 },{ source := 139, target := 0, scalar := 12 }] }
theorem rowR6_0014_000_24_valid : (rowR6_0014_000_24).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_25 : ExtensionRow := { move := 140, child := 214, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 101, target := 101, scalar := 1 },{ source := 140, target := 74, scalar := 12 }] }
theorem rowR6_0014_000_25_valid : (rowR6_0014_000_25).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_26 : ExtensionRow := { move := 141, child := 405, matrix := ![0,15,8,0,6,0,11,9,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 101, scalar := 15 },{ source := 17, target := 0, scalar := 11 },{ source := 34, target := 141, scalar := 7 },{ source := 52, target := 52, scalar := 6 },{ source := 101, target := 1, scalar := 13 },{ source := 141, target := 34, scalar := 1 }] }
theorem rowR6_0014_000_26_valid : (rowR6_0014_000_26).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_27 : ExtensionRow := { move := 143, child := 406, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 101, target := 101, scalar := 1 },{ source := 143, target := 143, scalar := 1 }] }
theorem rowR6_0014_000_27_valid : (rowR6_0014_000_27).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_28 : ExtensionRow := { move := 147, child := 214, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 101, target := 101, scalar := 1 },{ source := 147, target := 74, scalar := 1 }] }
theorem rowR6_0014_000_28_valid : (rowR6_0014_000_28).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_29 : ExtensionRow := { move := 150, child := 143, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 101, target := 101, scalar := 1 },{ source := 150, target := 72, scalar := 13 }] }
theorem rowR6_0014_000_29_valid : (rowR6_0014_000_29).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_30 : ExtensionRow := { move := 151, child := 99, matrix := ![15,0,11,0,7,5,0,0,14], witnesses := [{ source := 0, target := 52, scalar := 11 },{ source := 1, target := 1, scalar := 7 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 171, scalar := 4 },{ source := 52, target := 34, scalar := 1 },{ source := 101, target := 71, scalar := 5 },{ source := 151, target := 0, scalar := 2 }] }
theorem rowR6_0014_000_30_valid : (rowR6_0014_000_30).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_31 : ExtensionRow := { move := 155, child := 390, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 101, target := 101, scalar := 1 },{ source := 155, target := 94, scalar := 2 }] }
theorem rowR6_0014_000_31_valid : (rowR6_0014_000_31).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_32 : ExtensionRow := { move := 156, child := 403, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 101, target := 101, scalar := 1 },{ source := 156, target := 121, scalar := 3 }] }
theorem rowR6_0014_000_32_valid : (rowR6_0014_000_32).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_33 : ExtensionRow := { move := 158, child := 405, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 101, target := 101, scalar := 1 },{ source := 158, target := 141, scalar := 5 }] }
theorem rowR6_0014_000_33_valid : (rowR6_0014_000_33).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_34 : ExtensionRow := { move := 159, child := 353, matrix := ![11,0,6,1,0,0,13,6,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 0, scalar := 6 },{ source := 17, target := 109, scalar := 11 },{ source := 34, target := 91, scalar := 13 },{ source := 52, target := 34, scalar := 1 },{ source := 101, target := 1, scalar := 1 },{ source := 159, target := 52, scalar := 9 }] }
theorem rowR6_0014_000_34_valid : (rowR6_0014_000_34).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_35 : ExtensionRow := { move := 163, child := 197, matrix := ![14,14,0,1,0,0,9,0,9], witnesses := [{ source := 0, target := 0, scalar := 9 },{ source := 1, target := 17, scalar := 14 },{ source := 17, target := 73, scalar := 14 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 34, scalar := 1 },{ source := 101, target := 91, scalar := 13 },{ source := 163, target := 52, scalar := 9 }] }
theorem rowR6_0014_000_35_valid : (rowR6_0014_000_35).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_36 : ExtensionRow := { move := 167, child := 26, matrix := ![14,15,0,12,13,0,15,2,12], witnesses := [{ source := 0, target := 0, scalar := 12 },{ source := 1, target := 52, scalar := 15 },{ source := 17, target := 131, scalar := 14 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 69, scalar := 3 },{ source := 101, target := 17, scalar := 8 },{ source := 167, target := 1, scalar := 3 }] }
theorem rowR6_0014_000_36_valid : (rowR6_0014_000_36).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_37 : ExtensionRow := { move := 168, child := 403, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 101, target := 101, scalar := 1 },{ source := 168, target := 121, scalar := 1 }] }
theorem rowR6_0014_000_37_valid : (rowR6_0014_000_37).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_38 : ExtensionRow := { move := 171, child := 99, matrix := ![0,15,4,7,0,2,0,0,14], witnesses := [{ source := 0, target := 171, scalar := 4 },{ source := 1, target := 17, scalar := 15 },{ source := 17, target := 1, scalar := 7 },{ source := 34, target := 52, scalar := 11 },{ source := 52, target := 34, scalar := 1 },{ source := 101, target := 71, scalar := 5 },{ source := 171, target := 0, scalar := 6 }] }
theorem rowR6_0014_000_38_valid : (rowR6_0014_000_38).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_39 : ExtensionRow := { move := 173, child := 128, matrix := ![7,12,10,0,4,7,0,11,13], witnesses := [{ source := 0, target := 52, scalar := 10 },{ source := 1, target := 243, scalar := 12 },{ source := 17, target := 17, scalar := 7 },{ source := 34, target := 71, scalar := 1 },{ source := 52, target := 34, scalar := 1 },{ source := 101, target := 1, scalar := 8 },{ source := 173, target := 0, scalar := 15 }] }
theorem rowR6_0014_000_39_valid : (rowR6_0014_000_39).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_40 : ExtensionRow := { move := 174, child := 215, matrix := ![11,5,0,1,0,0,4,0,3], witnesses := [{ source := 0, target := 0, scalar := 3 },{ source := 1, target := 17, scalar := 5 },{ source := 17, target := 104, scalar := 11 },{ source := 34, target := 74, scalar := 14 },{ source := 52, target := 34, scalar := 1 },{ source := 101, target := 52, scalar := 9 },{ source := 174, target := 1, scalar := 1 }] }
theorem rowR6_0014_000_40_valid : (rowR6_0014_000_40).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_41 : ExtensionRow := { move := 175, child := 4, matrix := ![0,1,8,0,1,0,9,1,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 9 },{ source := 34, target := 52, scalar := 9 },{ source := 52, target := 86, scalar := 9 },{ source := 101, target := 69, scalar := 3 },{ source := 175, target := 1, scalar := 9 }] }
theorem rowR6_0014_000_41_valid : (rowR6_0014_000_41).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_42 : ExtensionRow := { move := 176, child := 391, matrix := ![5,1,0,2,1,0,1,1,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 108, scalar := 5 },{ source := 34, target := 94, scalar := 4 },{ source := 52, target := 17, scalar := 7 },{ source := 101, target := 1, scalar := 7 },{ source := 176, target := 52, scalar := 12 }] }
theorem rowR6_0014_000_42_valid : (rowR6_0014_000_42).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_43 : ExtensionRow := { move := 182, child := 20, matrix := ![0,4,8,0,11,0,15,8,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 115, scalar := 4 },{ source := 17, target := 0, scalar := 15 },{ source := 34, target := 52, scalar := 12 },{ source := 52, target := 69, scalar := 3 },{ source := 101, target := 34, scalar := 1 },{ source := 182, target := 1, scalar := 2 }] }
theorem rowR6_0014_000_43_valid : (rowR6_0014_000_43).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_44 : ExtensionRow := { move := 183, child := 214, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 101, target := 101, scalar := 1 },{ source := 183, target := 74, scalar := 12 }] }
theorem rowR6_0014_000_44_valid : (rowR6_0014_000_44).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_45 : ExtensionRow := { move := 184, child := 404, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 101, target := 101, scalar := 1 },{ source := 184, target := 124, scalar := 1 }] }
theorem rowR6_0014_000_45_valid : (rowR6_0014_000_45).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_46 : ExtensionRow := { move := 186, child := 403, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 101, target := 101, scalar := 1 },{ source := 186, target := 121, scalar := 3 }] }
theorem rowR6_0014_000_46_valid : (rowR6_0014_000_46).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowR6_0014_000_47 : ExtensionRow := { move := 190, child := 391, matrix := ![0,4,5,0,3,2,1,1,1], witnesses := [{ source := 0, target := 108, scalar := 5 },{ source := 1, target := 94, scalar := 4 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 17, scalar := 7 },{ source := 101, target := 1, scalar := 7 },{ source := 190, target := 52, scalar := 2 }] }
theorem rowR6_0014_000_47_valid : (rowR6_0014_000_47).ValidFor level7 {0,1,17,34,52,101} := by decide

noncomputable def rowsR6_0014_000 : List ExtensionRow := [rowR6_0014_000_0,rowR6_0014_000_1,rowR6_0014_000_2,rowR6_0014_000_3,rowR6_0014_000_4,rowR6_0014_000_5,rowR6_0014_000_6,rowR6_0014_000_7,rowR6_0014_000_8,rowR6_0014_000_9,rowR6_0014_000_10,rowR6_0014_000_11,rowR6_0014_000_12,rowR6_0014_000_13,rowR6_0014_000_14,rowR6_0014_000_15,rowR6_0014_000_16,rowR6_0014_000_17,rowR6_0014_000_18,rowR6_0014_000_19,rowR6_0014_000_20,rowR6_0014_000_21,rowR6_0014_000_22,rowR6_0014_000_23,rowR6_0014_000_24,rowR6_0014_000_25,rowR6_0014_000_26,rowR6_0014_000_27,rowR6_0014_000_28,rowR6_0014_000_29,rowR6_0014_000_30,rowR6_0014_000_31,rowR6_0014_000_32,rowR6_0014_000_33,rowR6_0014_000_34,rowR6_0014_000_35,rowR6_0014_000_36,rowR6_0014_000_37,rowR6_0014_000_38,rowR6_0014_000_39,rowR6_0014_000_40,rowR6_0014_000_41,rowR6_0014_000_42,rowR6_0014_000_43,rowR6_0014_000_44,rowR6_0014_000_45,rowR6_0014_000_46,rowR6_0014_000_47]

theorem rowsR6_0014_000_valid : RowListValid level7 {0,1,17,34,52,101} rowsR6_0014_000 := by
  intro r hr
  simp only [rowsR6_0014_000, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR6_0014_000_0_valid
  · exact rowR6_0014_000_1_valid
  · exact rowR6_0014_000_2_valid
  · exact rowR6_0014_000_3_valid
  · exact rowR6_0014_000_4_valid
  · exact rowR6_0014_000_5_valid
  · exact rowR6_0014_000_6_valid
  · exact rowR6_0014_000_7_valid
  · exact rowR6_0014_000_8_valid
  · exact rowR6_0014_000_9_valid
  · exact rowR6_0014_000_10_valid
  · exact rowR6_0014_000_11_valid
  · exact rowR6_0014_000_12_valid
  · exact rowR6_0014_000_13_valid
  · exact rowR6_0014_000_14_valid
  · exact rowR6_0014_000_15_valid
  · exact rowR6_0014_000_16_valid
  · exact rowR6_0014_000_17_valid
  · exact rowR6_0014_000_18_valid
  · exact rowR6_0014_000_19_valid
  · exact rowR6_0014_000_20_valid
  · exact rowR6_0014_000_21_valid
  · exact rowR6_0014_000_22_valid
  · exact rowR6_0014_000_23_valid
  · exact rowR6_0014_000_24_valid
  · exact rowR6_0014_000_25_valid
  · exact rowR6_0014_000_26_valid
  · exact rowR6_0014_000_27_valid
  · exact rowR6_0014_000_28_valid
  · exact rowR6_0014_000_29_valid
  · exact rowR6_0014_000_30_valid
  · exact rowR6_0014_000_31_valid
  · exact rowR6_0014_000_32_valid
  · exact rowR6_0014_000_33_valid
  · exact rowR6_0014_000_34_valid
  · exact rowR6_0014_000_35_valid
  · exact rowR6_0014_000_36_valid
  · exact rowR6_0014_000_37_valid
  · exact rowR6_0014_000_38_valid
  · exact rowR6_0014_000_39_valid
  · exact rowR6_0014_000_40_valid
  · exact rowR6_0014_000_41_valid
  · exact rowR6_0014_000_42_valid
  · exact rowR6_0014_000_43_valid
  · exact rowR6_0014_000_44_valid
  · exact rowR6_0014_000_45_valid
  · exact rowR6_0014_000_46_valid
  · exact rowR6_0014_000_47_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
