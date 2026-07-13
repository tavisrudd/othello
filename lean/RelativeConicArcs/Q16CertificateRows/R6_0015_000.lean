import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR6_0015_000_0 : ExtensionRow := { move := 67, child := 2, matrix := ![1,0,0,1,1,0,1,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 67, scalar := 1 },{ source := 67, target := 52, scalar := 1 },{ source := 107, target := 92, scalar := 1 }] }
theorem rowR6_0015_000_0_valid : (rowR6_0015_000_0).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_1 : ExtensionRow := { move := 69, child := 17, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 69, target := 69, scalar := 1 },{ source := 107, target := 107, scalar := 1 }] }
theorem rowR6_0015_000_1_valid : (rowR6_0015_000_1).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_2 : ExtensionRow := { move := 70, child := 58, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 70, target := 70, scalar := 1 },{ source := 107, target := 107, scalar := 1 }] }
theorem rowR6_0015_000_2_valid : (rowR6_0015_000_2).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_3 : ExtensionRow := { move := 72, child := 145, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 72, target := 72, scalar := 1 },{ source := 107, target := 107, scalar := 1 }] }
theorem rowR6_0015_000_3_valid : (rowR6_0015_000_3).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_4 : ExtensionRow := { move := 73, child := 148, matrix := ![0,8,8,0,11,0,13,13,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 72, scalar := 8 },{ source := 17, target := 0, scalar := 13 },{ source := 34, target := 1, scalar := 11 },{ source := 52, target := 122, scalar := 8 },{ source := 73, target := 52, scalar := 7 },{ source := 107, target := 34, scalar := 1 }] }
theorem rowR6_0015_000_4_valid : (rowR6_0015_000_4).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_5 : ExtensionRow := { move := 74, child := 216, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 74, target := 74, scalar := 1 },{ source := 107, target := 107, scalar := 1 }] }
theorem rowR6_0015_000_5_valid : (rowR6_0015_000_5).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_6 : ExtensionRow := { move := 79, child := 324, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 79, target := 79, scalar := 1 },{ source := 107, target := 107, scalar := 1 }] }
theorem rowR6_0015_000_6_valid : (rowR6_0015_000_6).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_7 : ExtensionRow := { move := 80, child := 334, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 80, target := 80, scalar := 1 },{ source := 107, target := 107, scalar := 1 }] }
theorem rowR6_0015_000_7_valid : (rowR6_0015_000_7).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_8 : ExtensionRow := { move := 83, child := 16, matrix := ![13,10,6,12,13,0,15,14,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 69, scalar := 10 },{ source := 17, target := 106, scalar := 13 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 1, scalar := 5 },{ source := 83, target := 52, scalar := 15 },{ source := 107, target := 0, scalar := 12 }] }
theorem rowR6_0015_000_8_valid : (rowR6_0015_000_8).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_9 : ExtensionRow := { move := 86, child := 57, matrix := ![15,14,0,0,1,0,0,3,2], witnesses := [{ source := 0, target := 0, scalar := 2 },{ source := 1, target := 70, scalar := 14 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 1, scalar := 2 },{ source := 86, target := 52, scalar := 2 },{ source := 107, target := 96, scalar := 12 }] }
theorem rowR6_0015_000_9_valid : (rowR6_0015_000_9).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_10 : ExtensionRow := { move := 92, child := 296, matrix := ![15,7,0,13,6,0,2,3,3], witnesses := [{ source := 0, target := 0, scalar := 3 },{ source := 1, target := 139, scalar := 7 },{ source := 17, target := 52, scalar := 15 },{ source := 34, target := 78, scalar := 8 },{ source := 52, target := 34, scalar := 1 },{ source := 92, target := 1, scalar := 6 },{ source := 107, target := 17, scalar := 7 }] }
theorem rowR6_0015_000_10_valid : (rowR6_0015_000_10).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_11 : ExtensionRow := { move := 94, child := 354, matrix := ![1,10,9,1,14,11,1,8,15], witnesses := [{ source := 0, target := 110, scalar := 9 },{ source := 1, target := 91, scalar := 10 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 52, scalar := 2 },{ source := 52, target := 17, scalar := 14 },{ source := 94, target := 1, scalar := 10 },{ source := 107, target := 0, scalar := 3 }] }
theorem rowR6_0015_000_11_valid : (rowR6_0015_000_11).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_12 : ExtensionRow := { move := 95, child := 154, matrix := ![14,7,0,1,0,0,12,0,4], witnesses := [{ source := 0, target := 0, scalar := 4 },{ source := 1, target := 17, scalar := 7 },{ source := 17, target := 72, scalar := 14 },{ source := 34, target := 52, scalar := 9 },{ source := 52, target := 1, scalar := 1 },{ source := 95, target := 34, scalar := 1 },{ source := 107, target := 143, scalar := 6 }] }
theorem rowR6_0015_000_12_valid : (rowR6_0015_000_12).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_13 : ExtensionRow := { move := 96, child := 88, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 96, target := 71, scalar := 11 },{ source := 107, target := 144, scalar := 15 }] }
theorem rowR6_0015_000_13_valid : (rowR6_0015_000_13).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_14 : ExtensionRow := { move := 115, child := 171, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 107, target := 197, scalar := 1 },{ source := 115, target := 72, scalar := 1 }] }
theorem rowR6_0015_000_14_valid : (rowR6_0015_000_14).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_15 : ExtensionRow := { move := 117, child := 241, matrix := ![9,5,1,6,0,2,12,0,3], witnesses := [{ source := 0, target := 52, scalar := 1 },{ source := 1, target := 17, scalar := 5 },{ source := 17, target := 220, scalar := 9 },{ source := 34, target := 74, scalar := 13 },{ source := 52, target := 0, scalar := 9 },{ source := 107, target := 34, scalar := 1 },{ source := 117, target := 1, scalar := 14 }] }
theorem rowR6_0015_000_15_valid : (rowR6_0015_000_15).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_16 : ExtensionRow := { move := 120, child := 407, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 107, target := 107, scalar := 1 },{ source := 120, target := 120, scalar := 1 }] }
theorem rowR6_0015_000_16_valid : (rowR6_0015_000_16).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_17 : ExtensionRow := { move := 121, child := 408, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 107, target := 107, scalar := 1 },{ source := 121, target := 121, scalar := 1 }] }
theorem rowR6_0015_000_17_valid : (rowR6_0015_000_17).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_18 : ExtensionRow := { move := 122, child := 371, matrix := ![0,15,10,11,5,14,0,8,8], witnesses := [{ source := 0, target := 91, scalar := 10 },{ source := 1, target := 253, scalar := 15 },{ source := 17, target := 1, scalar := 11 },{ source := 34, target := 17, scalar := 5 },{ source := 52, target := 0, scalar := 8 },{ source := 107, target := 52, scalar := 14 },{ source := 122, target := 34, scalar := 1 }] }
theorem rowR6_0015_000_18_valid : (rowR6_0015_000_18).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_19 : ExtensionRow := { move := 124, child := 131, matrix := ![0,12,6,0,7,0,3,14,0], witnesses := [{ source := 0, target := 17, scalar := 6 },{ source := 1, target := 71, scalar := 12 },{ source := 17, target := 0, scalar := 3 },{ source := 34, target := 52, scalar := 10 },{ source := 52, target := 253, scalar := 1 },{ source := 107, target := 1, scalar := 8 },{ source := 124, target := 34, scalar := 1 }] }
theorem rowR6_0015_000_19_valid : (rowR6_0015_000_19).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_20 : ExtensionRow := { move := 126, child := 307, matrix := ![15,11,4,3,14,0,6,6,0], witnesses := [{ source := 0, target := 17, scalar := 4 },{ source := 1, target := 78, scalar := 11 },{ source := 17, target := 198, scalar := 15 },{ source := 34, target := 1, scalar := 13 },{ source := 52, target := 52, scalar := 6 },{ source := 107, target := 0, scalar := 11 },{ source := 126, target := 34, scalar := 1 }] }
theorem rowR6_0015_000_20_valid : (rowR6_0015_000_20).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_21 : ExtensionRow := { move := 127, child := 208, matrix := ![0,8,15,0,0,14,13,0,4], witnesses := [{ source := 0, target := 167, scalar := 15 },{ source := 1, target := 17, scalar := 8 },{ source := 17, target := 0, scalar := 13 },{ source := 34, target := 52, scalar := 7 },{ source := 52, target := 34, scalar := 1 },{ source := 107, target := 73, scalar := 2 },{ source := 127, target := 1, scalar := 11 }] }
theorem rowR6_0015_000_21_valid : (rowR6_0015_000_21).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_22 : ExtensionRow := { move := 131, child := 110, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 107, target := 197, scalar := 1 },{ source := 131, target := 71, scalar := 1 }] }
theorem rowR6_0015_000_22_valid : (rowR6_0015_000_22).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_23 : ExtensionRow := { move := 133, child := 297, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 107, target := 144, scalar := 15 },{ source := 133, target := 78, scalar := 3 }] }
theorem rowR6_0015_000_23_valid : (rowR6_0015_000_23).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_24 : ExtensionRow := { move := 137, child := 332, matrix := ![8,0,9,3,0,2,11,6,12], witnesses := [{ source := 0, target := 92, scalar := 9 },{ source := 1, target := 0, scalar := 6 },{ source := 17, target := 52, scalar := 8 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 1, scalar := 5 },{ source := 107, target := 80, scalar := 13 },{ source := 137, target := 17, scalar := 12 }] }
theorem rowR6_0015_000_24_valid : (rowR6_0015_000_24).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_25 : ExtensionRow := { move := 138, child := 409, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 107, target := 107, scalar := 1 },{ source := 138, target := 138, scalar := 1 }] }
theorem rowR6_0015_000_25_valid : (rowR6_0015_000_25).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_26 : ExtensionRow := { move := 140, child := 250, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 107, target := 247, scalar := 15 },{ source := 140, target := 74, scalar := 12 }] }
theorem rowR6_0015_000_26_valid : (rowR6_0015_000_26).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_27 : ExtensionRow := { move := 144, child := 129, matrix := ![0,3,4,0,0,12,3,0,11], witnesses := [{ source := 0, target := 71, scalar := 4 },{ source := 1, target := 17, scalar := 3 },{ source := 17, target := 0, scalar := 3 },{ source := 34, target := 246, scalar := 7 },{ source := 52, target := 52, scalar := 10 },{ source := 107, target := 34, scalar := 1 },{ source := 144, target := 1, scalar := 8 }] }
theorem rowR6_0015_000_27_valid : (rowR6_0015_000_27).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_28 : ExtensionRow := { move := 149, child := 191, matrix := ![3,6,5,0,10,10,0,1,15], witnesses := [{ source := 0, target := 52, scalar := 5 },{ source := 1, target := 72, scalar := 6 },{ source := 17, target := 17, scalar := 3 },{ source := 34, target := 0, scalar := 14 },{ source := 52, target := 1, scalar := 10 },{ source := 107, target := 263, scalar := 10 },{ source := 149, target := 34, scalar := 1 }] }
theorem rowR6_0015_000_28_valid : (rowR6_0015_000_28).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_29 : ExtensionRow := { move := 150, child := 48, matrix := ![0,12,6,14,7,14,0,5,8], witnesses := [{ source := 0, target := 222, scalar := 6 },{ source := 1, target := 69, scalar := 12 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 52, scalar := 10 },{ source := 52, target := 34, scalar := 1 },{ source := 107, target := 0, scalar := 13 },{ source := 150, target := 17, scalar := 7 }] }
theorem rowR6_0015_000_29_valid : (rowR6_0015_000_29).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_30 : ExtensionRow := { move := 151, child := 82, matrix := ![11,12,7,15,7,14,7,14,9], witnesses := [{ source := 0, target := 52, scalar := 7 },{ source := 1, target := 71, scalar := 12 },{ source := 17, target := 121, scalar := 11 },{ source := 34, target := 1, scalar := 6 },{ source := 52, target := 17, scalar := 9 },{ source := 107, target := 34, scalar := 1 },{ source := 151, target := 0, scalar := 13 }] }
theorem rowR6_0015_000_30_valid : (rowR6_0015_000_30).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_31 : ExtensionRow := { move := 152, child := 395, matrix := ![2,1,0,3,1,14,5,1,0], witnesses := [{ source := 0, target := 1, scalar := 14 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 156, scalar := 2 },{ source := 34, target := 94, scalar := 3 },{ source := 52, target := 0, scalar := 7 },{ source := 107, target := 17, scalar := 7 },{ source := 152, target := 52, scalar := 10 }] }
theorem rowR6_0015_000_31_valid : (rowR6_0015_000_31).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_32 : ExtensionRow := { move := 154, child := 410, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 107, target := 107, scalar := 1 },{ source := 154, target := 154, scalar := 1 }] }
theorem rowR6_0015_000_32_valid : (rowR6_0015_000_32).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_33 : ExtensionRow := { move := 156, child := 411, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 107, target := 107, scalar := 1 },{ source := 156, target := 156, scalar := 1 }] }
theorem rowR6_0015_000_33_valid : (rowR6_0015_000_33).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_34 : ExtensionRow := { move := 158, child := 35, matrix := ![1,7,6,1,13,12,1,12,10], witnesses := [{ source := 0, target := 52, scalar := 6 },{ source := 1, target := 159, scalar := 7 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 7 },{ source := 52, target := 69, scalar := 5 },{ source := 107, target := 1, scalar := 12 },{ source := 158, target := 17, scalar := 4 }] }
theorem rowR6_0015_000_34_valid : (rowR6_0015_000_34).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_35 : ExtensionRow := { move := 163, child := 58, matrix := ![11,5,0,1,0,0,2,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 17, scalar := 5 },{ source := 17, target := 107, scalar := 11 },{ source := 34, target := 70, scalar := 14 },{ source := 52, target := 34, scalar := 1 },{ source := 107, target := 52, scalar := 9 },{ source := 163, target := 1, scalar := 1 }] }
theorem rowR6_0015_000_35_valid : (rowR6_0015_000_35).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_36 : ExtensionRow := { move := 166, child := 12, matrix := ![9,1,0,2,1,0,14,1,4], witnesses := [{ source := 0, target := 0, scalar := 4 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 96, scalar := 9 },{ source := 34, target := 52, scalar := 8 },{ source := 52, target := 17, scalar := 11 },{ source := 107, target := 69, scalar := 12 },{ source := 166, target := 1, scalar := 11 }] }
theorem rowR6_0015_000_36_valid : (rowR6_0015_000_36).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_37 : ExtensionRow := { move := 167, child := 387, matrix := ![1,9,0,1,2,0,1,12,6], witnesses := [{ source := 0, target := 0, scalar := 6 },{ source := 1, target := 92, scalar := 9 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 52, scalar := 8 },{ source := 52, target := 1, scalar := 5 },{ source := 107, target := 237, scalar := 10 },{ source := 167, target := 17, scalar := 12 }] }
theorem rowR6_0015_000_37_valid : (rowR6_0015_000_37).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_38 : ExtensionRow := { move := 168, child := 124, matrix := ![9,7,12,0,14,7,0,9,14], witnesses := [{ source := 0, target := 71, scalar := 12 },{ source := 1, target := 52, scalar := 7 },{ source := 17, target := 17, scalar := 9 },{ source := 34, target := 235, scalar := 2 },{ source := 52, target := 1, scalar := 6 },{ source := 107, target := 0, scalar := 13 },{ source := 168, target := 34, scalar := 1 }] }
theorem rowR6_0015_000_38_valid : (rowR6_0015_000_38).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_39 : ExtensionRow := { move := 169, child := 162, matrix := ![14,15,1,15,14,1,1,1,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 169, scalar := 15 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 1, scalar := 3 },{ source := 107, target := 72, scalar := 2 },{ source := 169, target := 17, scalar := 8 }] }
theorem rowR6_0015_000_39_valid : (rowR6_0015_000_39).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_40 : ExtensionRow := { move := 172, child := 245, matrix := ![13,5,8,4,10,0,15,15,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 52, scalar := 5 },{ source := 17, target := 74, scalar := 13 },{ source := 34, target := 1, scalar := 14 },{ source := 52, target := 232, scalar := 12 },{ source := 107, target := 0, scalar := 9 },{ source := 172, target := 34, scalar := 1 }] }
theorem rowR6_0015_000_40_valid : (rowR6_0015_000_40).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_41 : ExtensionRow := { move := 173, child := 220, matrix := ![5,10,0,13,13,0,8,5,13], witnesses := [{ source := 0, target := 0, scalar := 13 },{ source := 1, target := 74, scalar := 10 },{ source := 17, target := 120, scalar := 5 },{ source := 34, target := 17, scalar := 15 },{ source := 52, target := 52, scalar := 2 },{ source := 107, target := 34, scalar := 1 },{ source := 173, target := 1, scalar := 2 }] }
theorem rowR6_0015_000_41_valid : (rowR6_0015_000_41).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_42 : ExtensionRow := { move := 175, child := 66, matrix := ![15,15,0,0,2,0,0,6,6], witnesses := [{ source := 0, target := 0, scalar := 6 },{ source := 1, target := 70, scalar := 15 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 1, scalar := 2 },{ source := 52, target := 52, scalar := 2 },{ source := 107, target := 137, scalar := 9 },{ source := 175, target := 34, scalar := 1 }] }
theorem rowR6_0015_000_42_valid : (rowR6_0015_000_42).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_43 : ExtensionRow := { move := 176, child := 369, matrix := ![1,0,0,13,13,0,5,0,5], witnesses := [{ source := 0, target := 0, scalar := 5 },{ source := 1, target := 1, scalar := 13 },{ source := 17, target := 230, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 91, scalar := 1 },{ source := 107, target := 34, scalar := 1 },{ source := 176, target := 52, scalar := 1 }] }
theorem rowR6_0015_000_43_valid : (rowR6_0015_000_43).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_44 : ExtensionRow := { move := 181, child := 362, matrix := ![7,14,9,13,13,0,12,6,0], witnesses := [{ source := 0, target := 17, scalar := 9 },{ source := 1, target := 91, scalar := 14 },{ source := 17, target := 159, scalar := 7 },{ source := 34, target := 0, scalar := 10 },{ source := 52, target := 1, scalar := 4 },{ source := 107, target := 34, scalar := 1 },{ source := 181, target := 52, scalar := 3 }] }
theorem rowR6_0015_000_44_valid : (rowR6_0015_000_44).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_45 : ExtensionRow := { move := 182, child := 21, matrix := ![14,8,0,15,0,8,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 8 },{ source := 1, target := 17, scalar := 8 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 120, scalar := 6 },{ source := 52, target := 69, scalar := 13 },{ source := 107, target := 0, scalar := 1 },{ source := 182, target := 34, scalar := 1 }] }
theorem rowR6_0015_000_45_valid : (rowR6_0015_000_45).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_46 : ExtensionRow := { move := 183, child := 226, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 107, target := 144, scalar := 15 },{ source := 183, target := 74, scalar := 12 }] }
theorem rowR6_0015_000_46_valid : (rowR6_0015_000_46).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowR6_0015_000_47 : ExtensionRow := { move := 186, child := 412, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 107, target := 107, scalar := 1 },{ source := 186, target := 186, scalar := 1 }] }
theorem rowR6_0015_000_47_valid : (rowR6_0015_000_47).ValidFor level7 {0,1,17,34,52,107} := by decide

noncomputable def rowsR6_0015_000 : List ExtensionRow := [rowR6_0015_000_0,rowR6_0015_000_1,rowR6_0015_000_2,rowR6_0015_000_3,rowR6_0015_000_4,rowR6_0015_000_5,rowR6_0015_000_6,rowR6_0015_000_7,rowR6_0015_000_8,rowR6_0015_000_9,rowR6_0015_000_10,rowR6_0015_000_11,rowR6_0015_000_12,rowR6_0015_000_13,rowR6_0015_000_14,rowR6_0015_000_15,rowR6_0015_000_16,rowR6_0015_000_17,rowR6_0015_000_18,rowR6_0015_000_19,rowR6_0015_000_20,rowR6_0015_000_21,rowR6_0015_000_22,rowR6_0015_000_23,rowR6_0015_000_24,rowR6_0015_000_25,rowR6_0015_000_26,rowR6_0015_000_27,rowR6_0015_000_28,rowR6_0015_000_29,rowR6_0015_000_30,rowR6_0015_000_31,rowR6_0015_000_32,rowR6_0015_000_33,rowR6_0015_000_34,rowR6_0015_000_35,rowR6_0015_000_36,rowR6_0015_000_37,rowR6_0015_000_38,rowR6_0015_000_39,rowR6_0015_000_40,rowR6_0015_000_41,rowR6_0015_000_42,rowR6_0015_000_43,rowR6_0015_000_44,rowR6_0015_000_45,rowR6_0015_000_46,rowR6_0015_000_47]

theorem rowsR6_0015_000_valid : RowListValid level7 {0,1,17,34,52,107} rowsR6_0015_000 := by
  intro r hr
  simp only [rowsR6_0015_000, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR6_0015_000_0_valid
  · exact rowR6_0015_000_1_valid
  · exact rowR6_0015_000_2_valid
  · exact rowR6_0015_000_3_valid
  · exact rowR6_0015_000_4_valid
  · exact rowR6_0015_000_5_valid
  · exact rowR6_0015_000_6_valid
  · exact rowR6_0015_000_7_valid
  · exact rowR6_0015_000_8_valid
  · exact rowR6_0015_000_9_valid
  · exact rowR6_0015_000_10_valid
  · exact rowR6_0015_000_11_valid
  · exact rowR6_0015_000_12_valid
  · exact rowR6_0015_000_13_valid
  · exact rowR6_0015_000_14_valid
  · exact rowR6_0015_000_15_valid
  · exact rowR6_0015_000_16_valid
  · exact rowR6_0015_000_17_valid
  · exact rowR6_0015_000_18_valid
  · exact rowR6_0015_000_19_valid
  · exact rowR6_0015_000_20_valid
  · exact rowR6_0015_000_21_valid
  · exact rowR6_0015_000_22_valid
  · exact rowR6_0015_000_23_valid
  · exact rowR6_0015_000_24_valid
  · exact rowR6_0015_000_25_valid
  · exact rowR6_0015_000_26_valid
  · exact rowR6_0015_000_27_valid
  · exact rowR6_0015_000_28_valid
  · exact rowR6_0015_000_29_valid
  · exact rowR6_0015_000_30_valid
  · exact rowR6_0015_000_31_valid
  · exact rowR6_0015_000_32_valid
  · exact rowR6_0015_000_33_valid
  · exact rowR6_0015_000_34_valid
  · exact rowR6_0015_000_35_valid
  · exact rowR6_0015_000_36_valid
  · exact rowR6_0015_000_37_valid
  · exact rowR6_0015_000_38_valid
  · exact rowR6_0015_000_39_valid
  · exact rowR6_0015_000_40_valid
  · exact rowR6_0015_000_41_valid
  · exact rowR6_0015_000_42_valid
  · exact rowR6_0015_000_43_valid
  · exact rowR6_0015_000_44_valid
  · exact rowR6_0015_000_45_valid
  · exact rowR6_0015_000_46_valid
  · exact rowR6_0015_000_47_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
