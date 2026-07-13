import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_004_0 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,231}, reject := .fullRank { members := ![0,1,17,34,52,67,89,231], points := ![106,108,126,138,141,155], inverse := ![12,8,2,15,10,2,6,5,8,8,10,9,11,4,1,15,11,10,11,2,6,10,0,5,10,14,6,13,6,9,15,3,10,0,14,8] } }
theorem leafL_004_0_valid : (leafL_004_0).reject.ValidFor (leafL_004_0).leaf := by decide

noncomputable def leafL_004_1 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,240}, reject := .fullRank { members := ![0,1,17,34,52,67,89,240], points := ![110,124,127,141,151,155], inverse := ![5,6,12,3,2,15,7,0,14,9,15,15,15,9,8,4,12,6,14,3,8,11,9,7,0,9,9,0,8,8,1,10,2,6,7,8] } }
theorem leafL_004_1_valid : (leafL_004_1).reject.ValidFor (leafL_004_1).leaf := by decide

noncomputable def leafL_004_2 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,245}, reject := .fullRank { members := ![0,1,17,34,52,67,89,245], points := ![108,112,124,138,166,171], inverse := ![3,1,1,4,8,14,9,2,12,15,2,10,3,5,1,3,14,10,0,13,12,13,6,10,13,15,14,1,13,0,13,1,2,6,0,8] } }
theorem leafL_004_2_valid : (leafL_004_2).reject.ValidFor (leafL_004_2).leaf := by decide

noncomputable def leafL_004_3 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,248}, reject := .fullRank { members := ![0,1,17,34,52,67,89,248], points := ![106,110,126,128,138,166], inverse := ![11,9,8,9,4,6,10,1,0,12,15,8,7,15,15,2,4,1,12,8,5,3,0,2,5,12,13,7,13,14,4,7,10,3,8,2] } }
theorem leafL_004_3_valid : (leafL_004_3).reject.ValidFor (leafL_004_3).leaf := by decide

noncomputable def leafL_004_4 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,253}, reject := .fullRank { members := ![0,1,17,34,52,67,89,253], points := ![108,112,124,126,138,151], inverse := ![10,7,2,4,6,12,6,10,8,1,6,3,1,0,12,4,6,15,5,15,15,2,0,7,11,9,2,1,12,13,5,10,4,5,4,10] } }
theorem leafL_004_4_valid : (leafL_004_4).reject.ValidFor (leafL_004_4).leaf := by decide

noncomputable def leafL_004_5 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,263}, reject := .fullRank { members := ![0,1,17,34,52,67,89,263], points := ![106,110,112,128,138,139], inverse := ![15,4,12,9,3,12,6,10,11,14,8,1,5,15,10,0,0,0,9,15,1,15,0,8,11,11,0,0,8,8,11,3,8,0,7,7] } }
theorem leafL_004_5_valid : (leafL_004_5).reject.ValidFor (leafL_004_5).leaf := by decide

noncomputable def leafL_004_6 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,264}, reject := .fullRank { members := ![0,1,17,34,52,67,89,264], points := ![108,110,124,126,127,138], inverse := ![12,11,12,8,13,15,11,12,6,14,6,9,0,0,4,12,8,0,13,10,9,12,10,8,14,14,2,7,5,0,12,12,12,12,0,0] } }
theorem leafL_004_6_valid : (leafL_004_6).reject.ValidFor (leafL_004_6).leaf := by decide

noncomputable def leafL_004_7 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,266}, reject := .fullRank { members := ![0,1,17,34,52,67,89,266], points := ![126,128,141,149,155,156], inverse := ![9,13,14,0,5,14,11,8,8,8,5,6,0,0,0,11,3,8,9,11,9,10,15,14,12,12,0,3,8,11,8,8,0,1,12,13] } }
theorem leafL_004_7_valid : (leafL_004_7).reject.ValidFor (leafL_004_7).leaf := by decide

noncomputable def leavesL_004 : List RejectedLeaf := [leafL_004_0,leafL_004_1,leafL_004_2,leafL_004_3,leafL_004_4,leafL_004_5,leafL_004_6,leafL_004_7]

theorem leavesL_004_valid : LeafListValid leavesL_004 := by
  intro x hx
  simp only [leavesL_004, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_004_0_valid
  · exact leafL_004_1_valid
  · exact leafL_004_2_valid
  · exact leafL_004_3_valid
  · exact leafL_004_4_valid
  · exact leafL_004_5_valid
  · exact leafL_004_6_valid
  · exact leafL_004_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
