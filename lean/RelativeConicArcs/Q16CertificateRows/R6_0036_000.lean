import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR6_0036_000_0 : ExtensionRow := { move := 69, child := 50, matrix := ![1,15,4,1,13,12,1,2,3], witnesses := [{ source := 0, target := 69, scalar := 4 },{ source := 1, target := 52, scalar := 15 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 10 },{ source := 52, target := 1, scalar := 15 },{ source := 69, target := 0, scalar := 11 },{ source := 271, target := 246, scalar := 6 }] }
theorem rowR6_0036_000_0_valid : (rowR6_0036_000_0).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_1 : ExtensionRow := { move := 71, child := 137, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 71, target := 71, scalar := 1 },{ source := 271, target := 271, scalar := 1 }] }
theorem rowR6_0036_000_1_valid : (rowR6_0036_000_1).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_2 : ExtensionRow := { move := 72, child := 196, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 72, target := 72, scalar := 1 },{ source := 271, target := 271, scalar := 1 }] }
theorem rowR6_0036_000_2_valid : (rowR6_0036_000_2).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_3 : ExtensionRow := { move := 74, child := 196, matrix := ![0,0,1,1,0,1,0,1,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 271, scalar := 3 },{ source := 74, target := 72, scalar := 9 },{ source := 271, target := 52, scalar := 14 }] }
theorem rowR6_0036_000_3_valid : (rowR6_0036_000_3).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_4 : ExtensionRow := { move := 75, child := 196, matrix := ![1,9,0,1,1,1,1,8,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 52, scalar := 9 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 271, scalar := 8 },{ source := 52, target := 0, scalar := 2 },{ source := 75, target := 72, scalar := 9 },{ source := 271, target := 17, scalar := 15 }] }
theorem rowR6_0036_000_4_valid : (rowR6_0036_000_4).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_5 : ExtensionRow := { move := 78, child := 137, matrix := ![4,9,13,9,0,9,13,0,4], witnesses := [{ source := 0, target := 52, scalar := 13 },{ source := 1, target := 17, scalar := 9 },{ source := 17, target := 271, scalar := 4 },{ source := 34, target := 0, scalar := 9 },{ source := 52, target := 34, scalar := 1 },{ source := 78, target := 71, scalar := 2 },{ source := 271, target := 1, scalar := 14 }] }
theorem rowR6_0036_000_5_valid : (rowR6_0036_000_5).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_6 : ExtensionRow := { move := 80, child := 137, matrix := ![1,8,0,1,1,1,1,9,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 271, scalar := 8 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 52, scalar := 9 },{ source := 52, target := 17, scalar := 2 },{ source := 80, target := 71, scalar := 10 },{ source := 271, target := 0, scalar := 15 }] }
theorem rowR6_0036_000_6_valid : (rowR6_0036_000_6).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_7 : ExtensionRow := { move := 89, child := 50, matrix := ![14,0,5,15,7,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 5 },{ source := 1, target := 1, scalar := 7 },{ source := 17, target := 52, scalar := 14 },{ source := 34, target := 246, scalar := 11 },{ source := 52, target := 34, scalar := 1 },{ source := 89, target := 0, scalar := 1 },{ source := 271, target := 69, scalar := 13 }] }
theorem rowR6_0036_000_7_valid : (rowR6_0036_000_7).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_8 : ExtensionRow := { move := 90, child := 196, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 90, target := 72, scalar := 13 },{ source := 271, target := 271, scalar := 1 }] }
theorem rowR6_0036_000_8_valid : (rowR6_0036_000_8).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_9 : ExtensionRow := { move := 91, child := 375, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 91, target := 91, scalar := 1 },{ source := 271, target := 271, scalar := 1 }] }
theorem rowR6_0036_000_9_valid : (rowR6_0036_000_9).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_10 : ExtensionRow := { move := 93, child := 196, matrix := ![4,9,13,9,0,9,13,0,4], witnesses := [{ source := 0, target := 52, scalar := 13 },{ source := 1, target := 17, scalar := 9 },{ source := 17, target := 271, scalar := 4 },{ source := 34, target := 0, scalar := 9 },{ source := 52, target := 34, scalar := 1 },{ source := 93, target := 72, scalar := 5 },{ source := 271, target := 1, scalar := 14 }] }
theorem rowR6_0036_000_10_valid : (rowR6_0036_000_10).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_11 : ExtensionRow := { move := 94, child := 50, matrix := ![4,15,1,12,13,1,3,2,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 52, scalar := 15 },{ source := 17, target := 69, scalar := 4 },{ source := 34, target := 17, scalar := 10 },{ source := 52, target := 246, scalar := 10 },{ source := 94, target := 0, scalar := 6 },{ source := 271, target := 1, scalar := 5 }] }
theorem rowR6_0036_000_11_valid : (rowR6_0036_000_11).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_12 : ExtensionRow := { move := 96, child := 137, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 96, target := 71, scalar := 11 },{ source := 271, target := 271, scalar := 1 }] }
theorem rowR6_0036_000_12_valid : (rowR6_0036_000_12).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_13 : ExtensionRow := { move := 99, child := 50, matrix := ![10,4,15,0,12,13,0,3,2], witnesses := [{ source := 0, target := 52, scalar := 15 },{ source := 1, target := 69, scalar := 4 },{ source := 17, target := 17, scalar := 10 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 1, scalar := 15 },{ source := 99, target := 0, scalar := 11 },{ source := 271, target := 246, scalar := 6 }] }
theorem rowR6_0036_000_13_valid : (rowR6_0036_000_13).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_14 : ExtensionRow := { move := 103, child := 137, matrix := ![13,0,4,9,0,9,4,9,13], witnesses := [{ source := 0, target := 271, scalar := 4 },{ source := 1, target := 0, scalar := 9 },{ source := 17, target := 52, scalar := 13 },{ source := 34, target := 17, scalar := 9 },{ source := 52, target := 34, scalar := 1 },{ source := 103, target := 71, scalar := 6 },{ source := 271, target := 1, scalar := 14 }] }
theorem rowR6_0036_000_14_valid : (rowR6_0036_000_14).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_15 : ExtensionRow := { move := 104, child := 196, matrix := ![9,1,8,1,1,1,8,1,9], witnesses := [{ source := 0, target := 271, scalar := 8 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 9 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 0, scalar := 2 },{ source := 104, target := 72, scalar := 1 },{ source := 271, target := 17, scalar := 15 }] }
theorem rowR6_0036_000_15_valid : (rowR6_0036_000_15).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_16 : ExtensionRow := { move := 107, child := 50, matrix := ![5,1,0,3,1,14,2,1,0], witnesses := [{ source := 0, target := 1, scalar := 14 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 246, scalar := 5 },{ source := 34, target := 69, scalar := 4 },{ source := 52, target := 17, scalar := 7 },{ source := 107, target := 0, scalar := 7 },{ source := 271, target := 52, scalar := 10 }] }
theorem rowR6_0036_000_16_valid : (rowR6_0036_000_16).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_17 : ExtensionRow := { move := 109, child := 375, matrix := ![0,0,1,0,1,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 271, scalar := 3 },{ source := 109, target := 91, scalar := 12 },{ source := 271, target := 52, scalar := 14 }] }
theorem rowR6_0036_000_17_valid : (rowR6_0036_000_17).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_18 : ExtensionRow := { move := 110, child := 137, matrix := ![0,12,8,0,8,0,8,4,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 271, scalar := 12 },{ source := 17, target := 0, scalar := 8 },{ source := 34, target := 52, scalar := 4 },{ source := 52, target := 1, scalar := 3 },{ source := 110, target := 71, scalar := 11 },{ source := 271, target := 34, scalar := 1 }] }
theorem rowR6_0036_000_18_valid : (rowR6_0036_000_18).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_19 : ExtensionRow := { move := 112, child := 50, matrix := ![0,14,11,7,15,8,0,1,1], witnesses := [{ source := 0, target := 246, scalar := 11 },{ source := 1, target := 52, scalar := 14 },{ source := 17, target := 1, scalar := 7 },{ source := 34, target := 17, scalar := 5 },{ source := 52, target := 34, scalar := 1 },{ source := 112, target := 0, scalar := 10 },{ source := 271, target := 69, scalar := 13 }] }
theorem rowR6_0036_000_19_valid : (rowR6_0036_000_19).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_20 : ExtensionRow := { move := 115, child := 196, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 115, target := 72, scalar := 1 },{ source := 271, target := 271, scalar := 1 }] }
theorem rowR6_0036_000_20_valid : (rowR6_0036_000_20).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_21 : ExtensionRow := { move := 117, child := 196, matrix := ![0,8,1,1,1,1,0,9,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 271, scalar := 8 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 52, scalar := 9 },{ source := 52, target := 0, scalar := 2 },{ source := 117, target := 72, scalar := 1 },{ source := 271, target := 17, scalar := 15 }] }
theorem rowR6_0036_000_21_valid : (rowR6_0036_000_21).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_22 : ExtensionRow := { move := 121, child := 137, matrix := ![1,1,0,1,0,1,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 271, scalar := 3 },{ source := 121, target := 71, scalar := 7 },{ source := 271, target := 52, scalar := 14 }] }
theorem rowR6_0036_000_22_valid : (rowR6_0036_000_22).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_23 : ExtensionRow := { move := 122, child := 137, matrix := ![8,4,0,0,8,0,0,12,8], witnesses := [{ source := 0, target := 0, scalar := 8 },{ source := 1, target := 52, scalar := 4 },{ source := 17, target := 17, scalar := 8 },{ source := 34, target := 271, scalar := 12 },{ source := 52, target := 1, scalar := 3 },{ source := 122, target := 71, scalar := 3 },{ source := 271, target := 34, scalar := 1 }] }
theorem rowR6_0036_000_23_valid : (rowR6_0036_000_23).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_24 : ExtensionRow := { move := 124, child := 196, matrix := ![8,4,0,0,8,0,0,12,8], witnesses := [{ source := 0, target := 0, scalar := 8 },{ source := 1, target := 52, scalar := 4 },{ source := 17, target := 17, scalar := 8 },{ source := 34, target := 271, scalar := 12 },{ source := 52, target := 1, scalar := 3 },{ source := 124, target := 72, scalar := 3 },{ source := 271, target := 34, scalar := 1 }] }
theorem rowR6_0036_000_24_valid : (rowR6_0036_000_24).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_25 : ExtensionRow := { move := 125, child := 137, matrix := ![8,1,9,1,1,1,9,1,8], witnesses := [{ source := 0, target := 52, scalar := 9 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 271, scalar := 8 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 17, scalar := 2 },{ source := 125, target := 71, scalar := 8 },{ source := 271, target := 0, scalar := 15 }] }
theorem rowR6_0036_000_25_valid : (rowR6_0036_000_25).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_26 : ExtensionRow := { move := 126, child := 50, matrix := ![1,0,4,1,14,12,1,0,3], witnesses := [{ source := 0, target := 69, scalar := 4 },{ source := 1, target := 1, scalar := 14 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 246, scalar := 5 },{ source := 52, target := 52, scalar := 13 },{ source := 126, target := 0, scalar := 5 },{ source := 271, target := 17, scalar := 12 }] }
theorem rowR6_0036_000_26_valid : (rowR6_0036_000_26).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_27 : ExtensionRow := { move := 131, child := 137, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 131, target := 71, scalar := 1 },{ source := 271, target := 271, scalar := 1 }] }
theorem rowR6_0036_000_27_valid : (rowR6_0036_000_27).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_28 : ExtensionRow := { move := 133, child := 137, matrix := ![9,4,0,0,9,0,0,13,9], witnesses := [{ source := 0, target := 0, scalar := 9 },{ source := 1, target := 271, scalar := 4 },{ source := 17, target := 17, scalar := 9 },{ source := 34, target := 52, scalar := 13 },{ source := 52, target := 34, scalar := 1 },{ source := 133, target := 71, scalar := 6 },{ source := 271, target := 1, scalar := 14 }] }
theorem rowR6_0036_000_28_valid : (rowR6_0036_000_28).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_29 : ExtensionRow := { move := 137, child := 196, matrix := ![9,4,0,0,9,0,0,13,9], witnesses := [{ source := 0, target := 0, scalar := 9 },{ source := 1, target := 271, scalar := 4 },{ source := 17, target := 17, scalar := 9 },{ source := 34, target := 52, scalar := 13 },{ source := 52, target := 34, scalar := 1 },{ source := 137, target := 72, scalar := 6 },{ source := 271, target := 1, scalar := 14 }] }
theorem rowR6_0036_000_29_valid : (rowR6_0036_000_29).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_30 : ExtensionRow := { move := 138, child := 137, matrix := ![8,0,9,1,1,1,9,0,8], witnesses := [{ source := 0, target := 52, scalar := 9 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 271, scalar := 8 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 0, scalar := 2 },{ source := 138, target := 71, scalar := 5 },{ source := 271, target := 17, scalar := 15 }] }
theorem rowR6_0036_000_30_valid : (rowR6_0036_000_30).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_31 : ExtensionRow := { move := 140, child := 196, matrix := ![1,1,0,1,0,1,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 271, scalar := 3 },{ source := 140, target := 72, scalar := 6 },{ source := 271, target := 52, scalar := 14 }] }
theorem rowR6_0036_000_31_valid : (rowR6_0036_000_31).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_32 : ExtensionRow := { move := 141, child := 196, matrix := ![0,9,1,1,1,1,0,8,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 52, scalar := 9 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 271, scalar := 8 },{ source := 52, target := 17, scalar := 2 },{ source := 141, target := 72, scalar := 6 },{ source := 271, target := 0, scalar := 15 }] }
theorem rowR6_0036_000_32_valid : (rowR6_0036_000_32).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_33 : ExtensionRow := { move := 144, child := 50, matrix := ![1,5,4,1,3,12,1,2,3], witnesses := [{ source := 0, target := 69, scalar := 4 },{ source := 1, target := 246, scalar := 5 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 1, scalar := 14 },{ source := 52, target := 17, scalar := 7 },{ source := 144, target := 0, scalar := 13 },{ source := 271, target := 52, scalar := 10 }] }
theorem rowR6_0036_000_33_valid : (rowR6_0036_000_33).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_34 : ExtensionRow := { move := 147, child := 196, matrix := ![1,1,0,0,1,0,0,1,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 271, scalar := 3 },{ source := 147, target := 72, scalar := 9 },{ source := 271, target := 52, scalar := 14 }] }
theorem rowR6_0036_000_34_valid : (rowR6_0036_000_34).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_35 : ExtensionRow := { move := 150, child := 196, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 150, target := 72, scalar := 13 },{ source := 271, target := 271, scalar := 1 }] }
theorem rowR6_0036_000_35_valid : (rowR6_0036_000_35).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_36 : ExtensionRow := { move := 151, child := 137, matrix := ![1,9,0,1,1,1,1,8,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 52, scalar := 9 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 271, scalar := 8 },{ source := 52, target := 0, scalar := 2 },{ source := 151, target := 71, scalar := 5 },{ source := 271, target := 17, scalar := 15 }] }
theorem rowR6_0036_000_36_valid : (rowR6_0036_000_36).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_37 : ExtensionRow := { move := 152, child := 137, matrix := ![12,0,4,8,0,8,4,8,12], witnesses := [{ source := 0, target := 52, scalar := 4 },{ source := 1, target := 0, scalar := 8 },{ source := 17, target := 271, scalar := 12 },{ source := 34, target := 17, scalar := 8 },{ source := 52, target := 1, scalar := 3 },{ source := 152, target := 71, scalar := 3 },{ source := 271, target := 34, scalar := 1 }] }
theorem rowR6_0036_000_37_valid : (rowR6_0036_000_37).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_38 : ExtensionRow := { move := 155, child := 50, matrix := ![1,10,4,1,0,12,1,0,3], witnesses := [{ source := 0, target := 69, scalar := 4 },{ source := 1, target := 17, scalar := 10 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 52, scalar := 15 },{ source := 52, target := 246, scalar := 10 },{ source := 155, target := 0, scalar := 12 },{ source := 271, target := 1, scalar := 5 }] }
theorem rowR6_0036_000_38_valid : (rowR6_0036_000_38).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_39 : ExtensionRow := { move := 156, child := 137, matrix := ![1,1,0,0,1,0,0,1,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 271, scalar := 3 },{ source := 156, target := 71, scalar := 9 },{ source := 271, target := 52, scalar := 14 }] }
theorem rowR6_0036_000_39_valid : (rowR6_0036_000_39).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_40 : ExtensionRow := { move := 158, child := 196, matrix := ![1,8,0,1,1,1,1,9,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 271, scalar := 8 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 52, scalar := 9 },{ source := 52, target := 17, scalar := 2 },{ source := 158, target := 72, scalar := 13 },{ source := 271, target := 0, scalar := 15 }] }
theorem rowR6_0036_000_40_valid : (rowR6_0036_000_40).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_41 : ExtensionRow := { move := 166, child := 50, matrix := ![11,5,0,8,0,7,1,0,0], witnesses := [{ source := 0, target := 1, scalar := 7 },{ source := 1, target := 17, scalar := 5 },{ source := 17, target := 246, scalar := 11 },{ source := 34, target := 52, scalar := 14 },{ source := 52, target := 34, scalar := 1 },{ source := 166, target := 0, scalar := 1 },{ source := 271, target := 69, scalar := 13 }] }
theorem rowR6_0036_000_41_valid : (rowR6_0036_000_41).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_42 : ExtensionRow := { move := 167, child := 196, matrix := ![13,0,4,9,0,9,4,9,13], witnesses := [{ source := 0, target := 271, scalar := 4 },{ source := 1, target := 0, scalar := 9 },{ source := 17, target := 52, scalar := 13 },{ source := 34, target := 17, scalar := 9 },{ source := 52, target := 34, scalar := 1 },{ source := 167, target := 72, scalar := 6 },{ source := 271, target := 1, scalar := 14 }] }
theorem rowR6_0036_000_42_valid : (rowR6_0036_000_42).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_43 : ExtensionRow := { move := 168, child := 137, matrix := ![0,0,1,0,1,0,1,0,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 271, scalar := 3 },{ source := 168, target := 71, scalar := 7 },{ source := 271, target := 52, scalar := 14 }] }
theorem rowR6_0036_000_43_valid : (rowR6_0036_000_43).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_44 : ExtensionRow := { move := 171, child := 137, matrix := ![9,1,8,1,1,1,8,1,9], witnesses := [{ source := 0, target := 271, scalar := 8 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 9 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 0, scalar := 2 },{ source := 171, target := 71, scalar := 15 },{ source := 271, target := 17, scalar := 15 }] }
theorem rowR6_0036_000_44_valid : (rowR6_0036_000_44).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_45 : ExtensionRow := { move := 172, child := 375, matrix := ![0,12,8,0,8,0,8,4,0], witnesses := [{ source := 0, target := 17, scalar := 8 },{ source := 1, target := 271, scalar := 12 },{ source := 17, target := 0, scalar := 8 },{ source := 34, target := 52, scalar := 4 },{ source := 52, target := 1, scalar := 3 },{ source := 172, target := 91, scalar := 1 },{ source := 271, target := 34, scalar := 1 }] }
theorem rowR6_0036_000_45_valid : (rowR6_0036_000_45).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_46 : ExtensionRow := { move := 173, child := 50, matrix := ![0,1,5,14,1,3,0,1,2], witnesses := [{ source := 0, target := 246, scalar := 5 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 14 },{ source := 34, target := 69, scalar := 4 },{ source := 52, target := 52, scalar := 13 },{ source := 173, target := 0, scalar := 2 },{ source := 271, target := 17, scalar := 12 }] }
theorem rowR6_0036_000_46_valid : (rowR6_0036_000_46).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowR6_0036_000_47 : ExtensionRow := { move := 176, child := 50, matrix := ![15,0,1,0,9,2,0,0,3], witnesses := [{ source := 0, target := 52, scalar := 1 },{ source := 1, target := 1, scalar := 9 },{ source := 17, target := 17, scalar := 15 },{ source := 34, target := 246, scalar := 14 },{ source := 52, target := 69, scalar := 12 },{ source := 176, target := 0, scalar := 2 },{ source := 271, target := 34, scalar := 1 }] }
theorem rowR6_0036_000_47_valid : (rowR6_0036_000_47).ValidFor level7 {0,1,17,34,52,271} := by decide

noncomputable def rowsR6_0036_000 : List ExtensionRow := [rowR6_0036_000_0,rowR6_0036_000_1,rowR6_0036_000_2,rowR6_0036_000_3,rowR6_0036_000_4,rowR6_0036_000_5,rowR6_0036_000_6,rowR6_0036_000_7,rowR6_0036_000_8,rowR6_0036_000_9,rowR6_0036_000_10,rowR6_0036_000_11,rowR6_0036_000_12,rowR6_0036_000_13,rowR6_0036_000_14,rowR6_0036_000_15,rowR6_0036_000_16,rowR6_0036_000_17,rowR6_0036_000_18,rowR6_0036_000_19,rowR6_0036_000_20,rowR6_0036_000_21,rowR6_0036_000_22,rowR6_0036_000_23,rowR6_0036_000_24,rowR6_0036_000_25,rowR6_0036_000_26,rowR6_0036_000_27,rowR6_0036_000_28,rowR6_0036_000_29,rowR6_0036_000_30,rowR6_0036_000_31,rowR6_0036_000_32,rowR6_0036_000_33,rowR6_0036_000_34,rowR6_0036_000_35,rowR6_0036_000_36,rowR6_0036_000_37,rowR6_0036_000_38,rowR6_0036_000_39,rowR6_0036_000_40,rowR6_0036_000_41,rowR6_0036_000_42,rowR6_0036_000_43,rowR6_0036_000_44,rowR6_0036_000_45,rowR6_0036_000_46,rowR6_0036_000_47]

theorem rowsR6_0036_000_valid : RowListValid level7 {0,1,17,34,52,271} rowsR6_0036_000 := by
  intro r hr
  simp only [rowsR6_0036_000, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR6_0036_000_0_valid
  · exact rowR6_0036_000_1_valid
  · exact rowR6_0036_000_2_valid
  · exact rowR6_0036_000_3_valid
  · exact rowR6_0036_000_4_valid
  · exact rowR6_0036_000_5_valid
  · exact rowR6_0036_000_6_valid
  · exact rowR6_0036_000_7_valid
  · exact rowR6_0036_000_8_valid
  · exact rowR6_0036_000_9_valid
  · exact rowR6_0036_000_10_valid
  · exact rowR6_0036_000_11_valid
  · exact rowR6_0036_000_12_valid
  · exact rowR6_0036_000_13_valid
  · exact rowR6_0036_000_14_valid
  · exact rowR6_0036_000_15_valid
  · exact rowR6_0036_000_16_valid
  · exact rowR6_0036_000_17_valid
  · exact rowR6_0036_000_18_valid
  · exact rowR6_0036_000_19_valid
  · exact rowR6_0036_000_20_valid
  · exact rowR6_0036_000_21_valid
  · exact rowR6_0036_000_22_valid
  · exact rowR6_0036_000_23_valid
  · exact rowR6_0036_000_24_valid
  · exact rowR6_0036_000_25_valid
  · exact rowR6_0036_000_26_valid
  · exact rowR6_0036_000_27_valid
  · exact rowR6_0036_000_28_valid
  · exact rowR6_0036_000_29_valid
  · exact rowR6_0036_000_30_valid
  · exact rowR6_0036_000_31_valid
  · exact rowR6_0036_000_32_valid
  · exact rowR6_0036_000_33_valid
  · exact rowR6_0036_000_34_valid
  · exact rowR6_0036_000_35_valid
  · exact rowR6_0036_000_36_valid
  · exact rowR6_0036_000_37_valid
  · exact rowR6_0036_000_38_valid
  · exact rowR6_0036_000_39_valid
  · exact rowR6_0036_000_40_valid
  · exact rowR6_0036_000_41_valid
  · exact rowR6_0036_000_42_valid
  · exact rowR6_0036_000_43_valid
  · exact rowR6_0036_000_44_valid
  · exact rowR6_0036_000_45_valid
  · exact rowR6_0036_000_46_valid
  · exact rowR6_0036_000_47_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
