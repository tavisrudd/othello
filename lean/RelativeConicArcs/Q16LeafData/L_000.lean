import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_000_0 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,106}, reject := .fullRank { members := ![0,1,17,34,52,67,89,106], points := ![124,126,139,141,156,190], inverse := ![4,11,13,10,10,3,1,12,9,9,8,5,8,5,5,3,12,7,9,0,3,3,10,3,3,11,12,11,14,1,7,7,7,7,0,0] } }
theorem leafL_000_0_valid : (leafL_000_0).reject.ValidFor (leafL_000_0).leaf := by decide

noncomputable def leafL_000_1 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,108}, reject := .fullRank { members := ![0,1,17,34,52,67,89,108], points := ![126,128,138,151,155,166], inverse := ![10,14,14,2,9,0,8,2,1,8,10,9,12,7,11,3,8,11,4,10,5,1,6,12,9,3,10,4,14,10,4,15,11,14,5,11] } }
theorem leafL_000_1_valid : (leafL_000_1).reject.ValidFor (leafL_000_1).leaf := by decide

noncomputable def leafL_000_2 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,110}, reject := .fullRank { members := ![0,1,17,34,52,67,89,110], points := ![127,128,139,141,151,155], inverse := ![15,11,6,8,3,8,1,2,14,6,5,14,15,15,12,12,10,10,7,5,9,0,11,0,7,7,1,1,0,0,10,10,5,5,3,3] } }
theorem leafL_000_2_valid : (leafL_000_2).reject.ValidFor (leafL_000_2).leaf := by decide

noncomputable def leafL_000_3 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,112}, reject := .fullRank { members := ![0,1,17,34,52,67,89,112], points := ![124,126,139,141,151,166], inverse := ![14,12,15,7,13,6,8,6,5,0,6,13,2,13,7,8,15,15,3,7,1,14,13,6,10,14,0,4,4,4,7,7,7,7,0,0] } }
theorem leafL_000_3_valid : (leafL_000_3).reject.ValidFor (leafL_000_3).leaf := by decide

noncomputable def leafL_000_4 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,124}, reject := .fullRank { members := ![0,1,17,34,52,67,89,124], points := ![106,112,139,141,155,173], inverse := ![12,4,8,11,2,8,9,9,1,10,8,3,14,6,7,14,13,12,6,6,15,4,9,2,1,4,5,6,8,14,10,10,10,10,0,0] } }
theorem leafL_000_4_valid : (leafL_000_4).reject.ValidFor (leafL_000_4).leaf := by decide

noncomputable def leafL_000_5 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,126}, reject := .fullRank { members := ![0,1,17,34,52,67,89,126], points := ![106,108,112,138,139,149], inverse := ![0,9,0,0,13,5,15,13,0,10,14,6,10,15,5,0,0,0,0,1,12,4,5,12,0,11,11,8,8,0,8,3,11,7,7,0] } }
theorem leafL_000_5_valid : (leafL_000_5).reject.ValidFor (leafL_000_5).leaf := by decide

noncomputable def leafL_000_6 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,127}, reject := .fullRank { members := ![0,1,17,34,52,67,89,127], points := ![110,138,141,151,156,171], inverse := ![14,13,12,9,10,13,11,5,6,0,12,4,3,4,5,4,13,11,15,7,9,12,14,3,9,2,5,14,4,4,7,2,14,3,5,13] } }
theorem leafL_000_6_valid : (leafL_000_6).reject.ValidFor (leafL_000_6).leaf := by decide

noncomputable def leafL_000_7 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,128}, reject := .fullRank { members := ![0,1,17,34,52,67,89,128], points := ![108,110,139,149,151,155], inverse := ![9,0,13,5,0,0,12,14,4,9,3,12,0,0,0,8,5,13,4,9,1,11,9,14,1,1,0,14,1,15,15,15,0,9,13,4] } }
theorem leafL_000_7_valid : (leafL_000_7).reject.ValidFor (leafL_000_7).leaf := by decide

noncomputable def leavesL_000 : List RejectedLeaf := [leafL_000_0,leafL_000_1,leafL_000_2,leafL_000_3,leafL_000_4,leafL_000_5,leafL_000_6,leafL_000_7]

theorem leavesL_000_valid : LeafListValid leavesL_000 := by
  intro x hx
  simp only [leavesL_000, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_000_0_valid
  · exact leafL_000_1_valid
  · exact leafL_000_2_valid
  · exact leafL_000_3_valid
  · exact leafL_000_4_valid
  · exact leafL_000_5_valid
  · exact leafL_000_6_valid
  · exact leafL_000_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
