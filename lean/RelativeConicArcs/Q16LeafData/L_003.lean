import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_003_0 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,202}, reject := .fullRank { members := ![0,1,17,34,52,67,89,202], points := ![108,110,127,139,141,151], inverse := ![12,15,15,10,14,9,2,2,3,13,5,11,12,1,2,15,7,7,14,12,1,4,1,6,13,5,12,0,5,1,10,10,0,10,10,0] } }
theorem leafL_003_0_valid : (leafL_003_0).reject.ValidFor (leafL_003_0).leaf := by decide

noncomputable def leafL_003_1 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,205}, reject := .fullRank { members := ![0,1,17,34,52,67,89,205], points := ![106,124,126,127,138,155], inverse := ![12,0,0,14,0,3,7,7,13,4,9,0,0,4,12,8,0,0,3,13,11,15,3,9,5,11,2,7,13,6,8,6,4,14,5,1] } }
theorem leafL_003_1_valid : (leafL_003_1).reject.ValidFor (leafL_003_1).leaf := by decide

noncomputable def leafL_003_2 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,208}, reject := .fullRank { members := ![0,1,17,34,52,67,89,208], points := ![106,108,124,126,138,149], inverse := ![11,15,8,10,5,2,9,5,2,11,6,3,15,10,14,0,13,6,8,12,7,3,2,2,4,7,2,9,10,2,0,12,6,12,14,8] } }
theorem leafL_003_2_valid : (leafL_003_2).reject.ValidFor (leafL_003_2).leaf := by decide

noncomputable def leafL_003_3 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,213}, reject := .fullRank { members := ![0,1,17,34,52,67,89,213], points := ![108,110,126,127,128,138], inverse := ![12,11,6,7,8,15,11,12,9,3,4,9,0,0,7,14,9,0,13,10,15,14,14,8,14,14,11,6,13,0,12,12,2,10,8,0] } }
theorem leafL_003_3_valid : (leafL_003_3).reject.ValidFor (leafL_003_3).leaf := by decide

noncomputable def leafL_003_4 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,214}, reject := .fullRank { members := ![0,1,17,34,52,67,89,214], points := ![106,108,128,138,139,141], inverse := ![8,15,9,14,14,15,14,9,14,15,12,10,0,0,0,8,12,4,9,14,15,12,2,6,5,5,0,12,14,2,13,13,0,3,1,2] } }
theorem leafL_003_4_valid : (leafL_003_4).reject.ValidFor (leafL_003_4).leaf := by decide

noncomputable def leafL_003_5 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,218}, reject := .fullRank { members := ![0,1,17,34,52,67,89,218], points := ![108,110,112,124,127,141], inverse := ![9,0,14,15,6,15,10,10,7,3,13,9,5,10,15,0,0,0,15,2,10,12,3,8,1,3,2,14,14,0,9,6,15,8,8,0] } }
theorem leafL_003_5_valid : (leafL_003_5).reject.ValidFor (leafL_003_5).leaf := by decide

noncomputable def leafL_003_6 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,224}, reject := .fullRank { members := ![0,1,17,34,52,67,89,224], points := ![108,110,124,141,149,151], inverse := ![12,1,6,6,14,2,9,3,12,1,4,3,2,8,15,9,6,10,10,15,12,4,11,6,0,5,14,13,9,15,9,4,2,8,8,15] } }
theorem leafL_003_6_valid : (leafL_003_6).reject.ValidFor (leafL_003_6).leaf := by decide

noncomputable def leafL_003_7 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,229}, reject := .fullRank { members := ![0,1,17,34,52,67,89,229], points := ![106,110,124,128,151,155], inverse := ![0,12,15,1,7,4,2,15,1,0,1,13,4,4,3,3,12,12,14,4,3,14,6,1,10,10,8,8,5,5,10,10,10,10,0,0] } }
theorem leafL_003_7_valid : (leafL_003_7).reject.ValidFor (leafL_003_7).leaf := by decide

noncomputable def leavesL_003 : List RejectedLeaf := [leafL_003_0,leafL_003_1,leafL_003_2,leafL_003_3,leafL_003_4,leafL_003_5,leafL_003_6,leafL_003_7]

theorem leavesL_003_valid : LeafListValid leavesL_003 := by
  intro x hx
  simp only [leavesL_003, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_003_0_valid
  · exact leafL_003_1_valid
  · exact leafL_003_2_valid
  · exact leafL_003_3_valid
  · exact leafL_003_4_valid
  · exact leafL_003_5_valid
  · exact leafL_003_6_valid
  · exact leafL_003_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
