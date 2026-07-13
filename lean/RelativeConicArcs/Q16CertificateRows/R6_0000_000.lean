import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def rowR6_0000_000_0 : ExtensionRow := { move := 89, child := 0, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 67, target := 67, scalar := 1 },{ source := 89, target := 89, scalar := 1 }] }
theorem rowR6_0000_000_0_valid : (rowR6_0000_000_0).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_1 : ExtensionRow := { move := 91, child := 1, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 67, target := 67, scalar := 1 },{ source := 91, target := 91, scalar := 1 }] }
theorem rowR6_0000_000_1_valid : (rowR6_0000_000_1).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_2 : ExtensionRow := { move := 92, child := 2, matrix := ![1,0,0,0,1,0,0,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 67, target := 67, scalar := 1 },{ source := 92, target := 92, scalar := 1 }] }
theorem rowR6_0000_000_2_valid : (rowR6_0000_000_2).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_3 : ExtensionRow := { move := 93, child := 1, matrix := ![0,1,1,1,3,2,0,2,3], witnesses := [{ source := 0, target := 52, scalar := 1 },{ source := 1, target := 67, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 34, scalar := 1 },{ source := 67, target := 17, scalar := 1 },{ source := 93, target := 91, scalar := 8 }] }
theorem rowR6_0000_000_3_valid : (rowR6_0000_000_3).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_4 : ExtensionRow := { move := 94, child := 2, matrix := ![1,1,1,2,1,0,3,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 52, scalar := 1 },{ source := 34, target := 67, scalar := 1 },{ source := 52, target := 0, scalar := 1 },{ source := 67, target := 1, scalar := 1 },{ source := 94, target := 92, scalar := 8 }] }
theorem rowR6_0000_000_4_valid : (rowR6_0000_000_4).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_5 : ExtensionRow := { move := 95, child := 0, matrix := ![0,1,1,0,0,1,1,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 67, scalar := 1 },{ source := 67, target := 52, scalar := 1 },{ source := 95, target := 89, scalar := 10 }] }
theorem rowR6_0000_000_5_valid : (rowR6_0000_000_5).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_6 : ExtensionRow := { move := 106, child := 0, matrix := ![1,0,0,1,1,0,1,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 67, scalar := 1 },{ source := 67, target := 52, scalar := 1 },{ source := 106, target := 89, scalar := 1 }] }
theorem rowR6_0000_000_6_valid : (rowR6_0000_000_6).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_7 : ExtensionRow := { move := 107, child := 2, matrix := ![1,0,0,1,1,0,1,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 67, scalar := 1 },{ source := 67, target := 52, scalar := 1 },{ source := 107, target := 92, scalar := 1 }] }
theorem rowR6_0000_000_7_valid : (rowR6_0000_000_7).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_8 : ExtensionRow := { move := 108, child := 1, matrix := ![1,0,0,1,1,0,1,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 67, scalar := 1 },{ source := 67, target := 52, scalar := 1 },{ source := 108, target := 91, scalar := 1 }] }
theorem rowR6_0000_000_8_valid : (rowR6_0000_000_8).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_9 : ExtensionRow := { move := 109, child := 2, matrix := ![1,1,1,3,1,0,2,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 67, scalar := 1 },{ source := 34, target := 52, scalar := 1 },{ source := 52, target := 1, scalar := 1 },{ source := 67, target := 0, scalar := 1 },{ source := 109, target := 92, scalar := 8 }] }
theorem rowR6_0000_000_9_valid : (rowR6_0000_000_9).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_10 : ExtensionRow := { move := 110, child := 1, matrix := ![0,1,1,0,3,2,1,2,3], witnesses := [{ source := 0, target := 52, scalar := 1 },{ source := 1, target := 67, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 17, scalar := 1 },{ source := 67, target := 34, scalar := 1 },{ source := 110, target := 91, scalar := 8 }] }
theorem rowR6_0000_000_10_valid : (rowR6_0000_000_10).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_11 : ExtensionRow := { move := 112, child := 0, matrix := ![0,1,1,1,0,1,0,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 67, target := 67, scalar := 1 },{ source := 112, target := 89, scalar := 10 }] }
theorem rowR6_0000_000_11_valid : (rowR6_0000_000_11).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_12 : ExtensionRow := { move := 121, child := 2, matrix := ![1,0,0,2,1,0,3,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 52, scalar := 1 },{ source := 34, target := 67, scalar := 1 },{ source := 52, target := 17, scalar := 1 },{ source := 67, target := 34, scalar := 1 },{ source := 121, target := 92, scalar := 1 }] }
theorem rowR6_0000_000_12_valid : (rowR6_0000_000_12).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_13 : ExtensionRow := { move := 122, child := 1, matrix := ![1,0,0,2,1,0,3,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 52, scalar := 1 },{ source := 34, target := 67, scalar := 1 },{ source := 52, target := 17, scalar := 1 },{ source := 67, target := 34, scalar := 1 },{ source := 122, target := 91, scalar := 1 }] }
theorem rowR6_0000_000_13_valid : (rowR6_0000_000_13).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_14 : ExtensionRow := { move := 124, child := 0, matrix := ![1,0,0,2,1,0,3,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 52, scalar := 1 },{ source := 34, target := 67, scalar := 1 },{ source := 52, target := 17, scalar := 1 },{ source := 67, target := 34, scalar := 1 },{ source := 124, target := 89, scalar := 1 }] }
theorem rowR6_0000_000_14_valid : (rowR6_0000_000_14).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_15 : ExtensionRow := { move := 126, child := 0, matrix := ![1,1,1,3,0,1,2,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 67, scalar := 1 },{ source := 34, target := 52, scalar := 1 },{ source := 52, target := 0, scalar := 1 },{ source := 67, target := 1, scalar := 1 },{ source := 126, target := 89, scalar := 10 }] }
theorem rowR6_0000_000_15_valid : (rowR6_0000_000_15).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_16 : ExtensionRow := { move := 127, child := 2, matrix := ![0,1,1,0,1,0,1,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 67, target := 67, scalar := 1 },{ source := 127, target := 92, scalar := 8 }] }
theorem rowR6_0000_000_16_valid : (rowR6_0000_000_16).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_17 : ExtensionRow := { move := 128, child := 1, matrix := ![1,1,1,1,3,2,1,2,3], witnesses := [{ source := 0, target := 52, scalar := 1 },{ source := 1, target := 67, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 1, scalar := 1 },{ source := 67, target := 0, scalar := 1 },{ source := 128, target := 91, scalar := 8 }] }
theorem rowR6_0000_000_17_valid : (rowR6_0000_000_17).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_18 : ExtensionRow := { move := 137, child := 1, matrix := ![1,0,0,3,1,0,2,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 67, scalar := 1 },{ source := 34, target := 52, scalar := 1 },{ source := 52, target := 34, scalar := 1 },{ source := 67, target := 17, scalar := 1 },{ source := 137, target := 91, scalar := 1 }] }
theorem rowR6_0000_000_18_valid : (rowR6_0000_000_18).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_19 : ExtensionRow := { move := 138, child := 2, matrix := ![1,0,0,3,1,0,2,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 67, scalar := 1 },{ source := 34, target := 52, scalar := 1 },{ source := 52, target := 34, scalar := 1 },{ source := 67, target := 17, scalar := 1 },{ source := 138, target := 92, scalar := 1 }] }
theorem rowR6_0000_000_19_valid : (rowR6_0000_000_19).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_20 : ExtensionRow := { move := 139, child := 0, matrix := ![1,0,0,3,1,0,2,0,1], witnesses := [{ source := 0, target := 0, scalar := 1 },{ source := 1, target := 1, scalar := 1 },{ source := 17, target := 67, scalar := 1 },{ source := 34, target := 52, scalar := 1 },{ source := 52, target := 34, scalar := 1 },{ source := 67, target := 17, scalar := 1 },{ source := 139, target := 89, scalar := 1 }] }
theorem rowR6_0000_000_20_valid : (rowR6_0000_000_20).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_21 : ExtensionRow := { move := 141, child := 0, matrix := ![1,1,1,2,0,1,3,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 52, scalar := 1 },{ source := 34, target := 67, scalar := 1 },{ source := 52, target := 1, scalar := 1 },{ source := 67, target := 0, scalar := 1 },{ source := 141, target := 89, scalar := 10 }] }
theorem rowR6_0000_000_21_valid : (rowR6_0000_000_21).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_22 : ExtensionRow := { move := 143, child := 1, matrix := ![1,1,1,0,3,2,0,2,3], witnesses := [{ source := 0, target := 52, scalar := 1 },{ source := 1, target := 67, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 0, scalar := 1 },{ source := 67, target := 1, scalar := 1 },{ source := 143, target := 91, scalar := 8 }] }
theorem rowR6_0000_000_22_valid : (rowR6_0000_000_22).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_23 : ExtensionRow := { move := 144, child := 2, matrix := ![0,1,1,1,1,0,0,1,0], witnesses := [{ source := 0, target := 17, scalar := 1 },{ source := 1, target := 34, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 67, scalar := 1 },{ source := 67, target := 52, scalar := 1 },{ source := 144, target := 92, scalar := 8 }] }
theorem rowR6_0000_000_23_valid : (rowR6_0000_000_23).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_24 : ExtensionRow := { move := 149, child := 0, matrix := ![1,0,0,0,0,1,0,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 67, scalar := 1 },{ source := 67, target := 52, scalar := 1 },{ source := 149, target := 89, scalar := 1 }] }
theorem rowR6_0000_000_24_valid : (rowR6_0000_000_24).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_25 : ExtensionRow := { move := 151, child := 2, matrix := ![1,0,0,2,0,1,3,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 52, scalar := 1 },{ source := 34, target := 67, scalar := 1 },{ source := 52, target := 34, scalar := 1 },{ source := 67, target := 17, scalar := 1 },{ source := 151, target := 92, scalar := 1 }] }
theorem rowR6_0000_000_25_valid : (rowR6_0000_000_25).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_26 : ExtensionRow := { move := 152, child := 1, matrix := ![1,0,0,3,0,1,2,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 67, scalar := 1 },{ source := 34, target := 52, scalar := 1 },{ source := 52, target := 17, scalar := 1 },{ source := 67, target := 34, scalar := 1 },{ source := 152, target := 91, scalar := 1 }] }
theorem rowR6_0000_000_26_valid : (rowR6_0000_000_26).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_27 : ExtensionRow := { move := 155, child := 2, matrix := ![1,1,1,0,3,2,0,2,3], witnesses := [{ source := 0, target := 52, scalar := 1 },{ source := 1, target := 67, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 0, scalar := 1 },{ source := 67, target := 1, scalar := 1 },{ source := 155, target := 92, scalar := 3 }] }
theorem rowR6_0000_000_27_valid : (rowR6_0000_000_27).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_28 : ExtensionRow := { move := 156, child := 2, matrix := ![0,1,1,1,2,3,0,3,2], witnesses := [{ source := 0, target := 67, scalar := 1 },{ source := 1, target := 52, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 17, scalar := 1 },{ source := 67, target := 34, scalar := 1 },{ source := 156, target := 92, scalar := 3 }] }
theorem rowR6_0000_000_28_valid : (rowR6_0000_000_28).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_29 : ExtensionRow := { move := 158, child := 0, matrix := ![1,1,1,1,3,2,1,2,3], witnesses := [{ source := 0, target := 52, scalar := 1 },{ source := 1, target := 67, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 1, scalar := 1 },{ source := 67, target := 0, scalar := 1 },{ source := 158, target := 89, scalar := 4 }] }
theorem rowR6_0000_000_29_valid : (rowR6_0000_000_29).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_30 : ExtensionRow := { move := 159, child := 3, matrix := ![1,1,1,3,0,1,2,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 67, scalar := 1 },{ source := 34, target := 52, scalar := 1 },{ source := 52, target := 0, scalar := 1 },{ source := 67, target := 1, scalar := 1 },{ source := 159, target := 159, scalar := 7 }] }
theorem rowR6_0000_000_30_valid : (rowR6_0000_000_30).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_31 : ExtensionRow := { move := 166, child := 0, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 67, target := 67, scalar := 1 },{ source := 166, target := 89, scalar := 1 }] }
theorem rowR6_0000_000_31_valid : (rowR6_0000_000_31).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_32 : ExtensionRow := { move := 167, child := 1, matrix := ![1,0,0,2,0,1,3,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 52, scalar := 1 },{ source := 34, target := 67, scalar := 1 },{ source := 52, target := 34, scalar := 1 },{ source := 67, target := 17, scalar := 1 },{ source := 167, target := 91, scalar := 1 }] }
theorem rowR6_0000_000_32_valid : (rowR6_0000_000_32).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_33 : ExtensionRow := { move := 168, child := 2, matrix := ![1,0,0,3,0,1,2,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 67, scalar := 1 },{ source := 34, target := 52, scalar := 1 },{ source := 52, target := 17, scalar := 1 },{ source := 67, target := 34, scalar := 1 },{ source := 168, target := 92, scalar := 1 }] }
theorem rowR6_0000_000_33_valid : (rowR6_0000_000_33).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_34 : ExtensionRow := { move := 171, child := 2, matrix := ![0,1,1,0,2,3,1,3,2], witnesses := [{ source := 0, target := 67, scalar := 1 },{ source := 1, target := 52, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 34, scalar := 1 },{ source := 67, target := 17, scalar := 1 },{ source := 171, target := 92, scalar := 3 }] }
theorem rowR6_0000_000_34_valid : (rowR6_0000_000_34).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_35 : ExtensionRow := { move := 172, child := 2, matrix := ![1,1,1,1,3,2,1,2,3], witnesses := [{ source := 0, target := 52, scalar := 1 },{ source := 1, target := 67, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 1, scalar := 1 },{ source := 67, target := 0, scalar := 1 },{ source := 172, target := 92, scalar := 3 }] }
theorem rowR6_0000_000_35_valid : (rowR6_0000_000_35).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_36 : ExtensionRow := { move := 173, child := 0, matrix := ![1,1,1,0,3,2,0,2,3], witnesses := [{ source := 0, target := 52, scalar := 1 },{ source := 1, target := 67, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 0, scalar := 1 },{ source := 67, target := 1, scalar := 1 },{ source := 173, target := 89, scalar := 4 }] }
theorem rowR6_0000_000_36_valid : (rowR6_0000_000_36).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_37 : ExtensionRow := { move := 176, child := 3, matrix := ![1,1,1,2,0,1,3,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 52, scalar := 1 },{ source := 34, target := 67, scalar := 1 },{ source := 52, target := 1, scalar := 1 },{ source := 67, target := 0, scalar := 1 },{ source := 176, target := 159, scalar := 7 }] }
theorem rowR6_0000_000_37_valid : (rowR6_0000_000_37).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_38 : ExtensionRow := { move := 181, child := 1, matrix := ![1,0,0,0,0,1,0,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 67, scalar := 1 },{ source := 67, target := 52, scalar := 1 },{ source := 181, target := 91, scalar := 1 }] }
theorem rowR6_0000_000_38_valid : (rowR6_0000_000_38).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_39 : ExtensionRow := { move := 182, child := 2, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 67, target := 67, scalar := 1 },{ source := 182, target := 92, scalar := 1 }] }
theorem rowR6_0000_000_39_valid : (rowR6_0000_000_39).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_40 : ExtensionRow := { move := 184, child := 0, matrix := ![1,0,0,3,0,1,2,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 67, scalar := 1 },{ source := 34, target := 52, scalar := 1 },{ source := 52, target := 17, scalar := 1 },{ source := 67, target := 34, scalar := 1 },{ source := 184, target := 89, scalar := 1 }] }
theorem rowR6_0000_000_40_valid : (rowR6_0000_000_40).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_41 : ExtensionRow := { move := 185, child := 2, matrix := ![1,1,1,0,2,3,0,3,2], witnesses := [{ source := 0, target := 67, scalar := 1 },{ source := 1, target := 52, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 1, scalar := 1 },{ source := 67, target := 0, scalar := 1 },{ source := 185, target := 92, scalar := 3 }] }
theorem rowR6_0000_000_41_valid : (rowR6_0000_000_41).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_42 : ExtensionRow := { move := 186, child := 2, matrix := ![0,1,1,0,3,2,1,2,3], witnesses := [{ source := 0, target := 52, scalar := 1 },{ source := 1, target := 67, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 17, scalar := 1 },{ source := 67, target := 34, scalar := 1 },{ source := 186, target := 92, scalar := 3 }] }
theorem rowR6_0000_000_42_valid : (rowR6_0000_000_42).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_43 : ExtensionRow := { move := 190, child := 3, matrix := ![0,1,1,0,0,1,1,0,1], witnesses := [{ source := 0, target := 34, scalar := 1 },{ source := 1, target := 17, scalar := 1 },{ source := 17, target := 0, scalar := 1 },{ source := 34, target := 1, scalar := 1 },{ source := 52, target := 67, scalar := 1 },{ source := 67, target := 52, scalar := 1 },{ source := 190, target := 159, scalar := 7 }] }
theorem rowR6_0000_000_43_valid : (rowR6_0000_000_43).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_44 : ExtensionRow := { move := 191, child := 0, matrix := ![0,1,1,1,3,2,0,2,3], witnesses := [{ source := 0, target := 52, scalar := 1 },{ source := 1, target := 67, scalar := 1 },{ source := 17, target := 1, scalar := 1 },{ source := 34, target := 0, scalar := 1 },{ source := 52, target := 34, scalar := 1 },{ source := 67, target := 17, scalar := 1 },{ source := 191, target := 89, scalar := 4 }] }
theorem rowR6_0000_000_44_valid : (rowR6_0000_000_44).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_45 : ExtensionRow := { move := 197, child := 2, matrix := ![1,0,0,0,0,1,0,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 17, scalar := 1 },{ source := 34, target := 34, scalar := 1 },{ source := 52, target := 67, scalar := 1 },{ source := 67, target := 52, scalar := 1 },{ source := 197, target := 92, scalar := 1 }] }
theorem rowR6_0000_000_45_valid : (rowR6_0000_000_45).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_46 : ExtensionRow := { move := 198, child := 1, matrix := ![1,0,0,1,0,1,1,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 34, scalar := 1 },{ source := 34, target := 17, scalar := 1 },{ source := 52, target := 52, scalar := 1 },{ source := 67, target := 67, scalar := 1 },{ source := 198, target := 91, scalar := 1 }] }
theorem rowR6_0000_000_46_valid : (rowR6_0000_000_46).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowR6_0000_000_47 : ExtensionRow := { move := 199, child := 0, matrix := ![1,0,0,2,0,1,3,1,0], witnesses := [{ source := 0, target := 1, scalar := 1 },{ source := 1, target := 0, scalar := 1 },{ source := 17, target := 52, scalar := 1 },{ source := 34, target := 67, scalar := 1 },{ source := 52, target := 34, scalar := 1 },{ source := 67, target := 17, scalar := 1 },{ source := 199, target := 89, scalar := 1 }] }
theorem rowR6_0000_000_47_valid : (rowR6_0000_000_47).ValidFor level7 {0,1,17,34,52,67} := by decide

noncomputable def rowsR6_0000_000 : List ExtensionRow := [rowR6_0000_000_0,rowR6_0000_000_1,rowR6_0000_000_2,rowR6_0000_000_3,rowR6_0000_000_4,rowR6_0000_000_5,rowR6_0000_000_6,rowR6_0000_000_7,rowR6_0000_000_8,rowR6_0000_000_9,rowR6_0000_000_10,rowR6_0000_000_11,rowR6_0000_000_12,rowR6_0000_000_13,rowR6_0000_000_14,rowR6_0000_000_15,rowR6_0000_000_16,rowR6_0000_000_17,rowR6_0000_000_18,rowR6_0000_000_19,rowR6_0000_000_20,rowR6_0000_000_21,rowR6_0000_000_22,rowR6_0000_000_23,rowR6_0000_000_24,rowR6_0000_000_25,rowR6_0000_000_26,rowR6_0000_000_27,rowR6_0000_000_28,rowR6_0000_000_29,rowR6_0000_000_30,rowR6_0000_000_31,rowR6_0000_000_32,rowR6_0000_000_33,rowR6_0000_000_34,rowR6_0000_000_35,rowR6_0000_000_36,rowR6_0000_000_37,rowR6_0000_000_38,rowR6_0000_000_39,rowR6_0000_000_40,rowR6_0000_000_41,rowR6_0000_000_42,rowR6_0000_000_43,rowR6_0000_000_44,rowR6_0000_000_45,rowR6_0000_000_46,rowR6_0000_000_47]

theorem rowsR6_0000_000_valid : RowListValid level7 {0,1,17,34,52,67} rowsR6_0000_000 := by
  intro r hr
  simp only [rowsR6_0000_000, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact rowR6_0000_000_0_valid
  · exact rowR6_0000_000_1_valid
  · exact rowR6_0000_000_2_valid
  · exact rowR6_0000_000_3_valid
  · exact rowR6_0000_000_4_valid
  · exact rowR6_0000_000_5_valid
  · exact rowR6_0000_000_6_valid
  · exact rowR6_0000_000_7_valid
  · exact rowR6_0000_000_8_valid
  · exact rowR6_0000_000_9_valid
  · exact rowR6_0000_000_10_valid
  · exact rowR6_0000_000_11_valid
  · exact rowR6_0000_000_12_valid
  · exact rowR6_0000_000_13_valid
  · exact rowR6_0000_000_14_valid
  · exact rowR6_0000_000_15_valid
  · exact rowR6_0000_000_16_valid
  · exact rowR6_0000_000_17_valid
  · exact rowR6_0000_000_18_valid
  · exact rowR6_0000_000_19_valid
  · exact rowR6_0000_000_20_valid
  · exact rowR6_0000_000_21_valid
  · exact rowR6_0000_000_22_valid
  · exact rowR6_0000_000_23_valid
  · exact rowR6_0000_000_24_valid
  · exact rowR6_0000_000_25_valid
  · exact rowR6_0000_000_26_valid
  · exact rowR6_0000_000_27_valid
  · exact rowR6_0000_000_28_valid
  · exact rowR6_0000_000_29_valid
  · exact rowR6_0000_000_30_valid
  · exact rowR6_0000_000_31_valid
  · exact rowR6_0000_000_32_valid
  · exact rowR6_0000_000_33_valid
  · exact rowR6_0000_000_34_valid
  · exact rowR6_0000_000_35_valid
  · exact rowR6_0000_000_36_valid
  · exact rowR6_0000_000_37_valid
  · exact rowR6_0000_000_38_valid
  · exact rowR6_0000_000_39_valid
  · exact rowR6_0000_000_40_valid
  · exact rowR6_0000_000_41_valid
  · exact rowR6_0000_000_42_valid
  · exact rowR6_0000_000_43_valid
  · exact rowR6_0000_000_44_valid
  · exact rowR6_0000_000_45_valid
  · exact rowR6_0000_000_46_valid
  · exact rowR6_0000_000_47_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
