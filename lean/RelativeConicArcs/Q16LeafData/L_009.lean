import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_009_0 : RejectedLeaf := { leaf := {0,1,17,34,52,67,92,109}, reject := .fullRank { members := ![0,1,17,34,52,67,92,109], points := ![122,127,137,138,139,149], inverse := ![6,2,5,6,13,11,8,11,9,9,8,11,0,0,9,14,7,0,10,8,8,0,1,11,1,1,6,6,0,0,6,6,2,3,1,0] } }
theorem leafL_009_0_valid : (leafL_009_0).reject.ValidFor (leafL_009_0).leaf := by decide

noncomputable def leafL_009_1 : RejectedLeaf := { leaf := {0,1,17,34,52,67,92,121}, reject := .fullRank { members := ![0,1,17,34,52,67,92,121], points := ![107,112,138,141,149,151], inverse := ![14,7,2,15,13,8,0,2,13,9,8,14,5,5,10,10,3,3,10,7,2,3,12,0,0,0,13,13,15,15,12,12,12,12,0,0] } }
theorem leafL_009_1_valid : (leafL_009_1).reject.ValidFor (leafL_009_1).leaf := by decide

noncomputable def leafL_009_2 : RejectedLeaf := { leaf := {0,1,17,34,52,67,92,127}, reject := .fullRank { members := ![0,1,17,34,52,67,92,127], points := ![109,137,138,141,152,158], inverse := ![9,12,2,3,14,11,2,7,3,0,14,8,0,13,11,6,0,0,13,13,9,5,14,2,0,9,8,1,3,3,0,13,12,1,10,10] } }
theorem leafL_009_2_valid : (leafL_009_2).reject.ValidFor (leafL_009_2).leaf := by decide

noncomputable def leafL_009_3 : RejectedLeaf := { leaf := {0,1,17,34,52,67,92,138}, reject := .fullRank { members := ![0,1,17,34,52,67,92,138], points := ![107,109,121,127,151,152], inverse := ![12,0,11,5,12,15,14,3,3,2,7,11,11,11,10,10,6,6,2,8,4,9,10,13,1,1,0,0,7,7,12,12,12,12,0,0] } }
theorem leafL_009_3_valid : (leafL_009_3).reject.ValidFor (leafL_009_3).leaf := by decide

noncomputable def leafL_009_4 : RejectedLeaf := { leaf := {0,1,17,34,52,67,92,151}, reject := .fullRank { members := ![0,1,17,34,52,67,92,151], points := ![107,112,121,122,138,139], inverse := ![7,0,11,2,7,8,12,11,3,13,1,8,12,12,1,1,9,9,0,7,11,4,14,6,3,3,10,10,13,13,11,11,3,3,15,15] } }
theorem leafL_009_4_valid : (leafL_009_4).reject.ValidFor (leafL_009_4).leaf := by decide

noncomputable def leafL_009_5 : RejectedLeaf := { leaf := {0,1,17,34,52,67,92,155}, reject := .fullRank { members := ![0,1,17,34,52,67,92,155], points := ![109,112,137,138,168,184], inverse := ![3,7,8,15,2,0,10,13,5,10,4,12,7,9,2,4,10,2,13,8,11,8,1,7,7,5,7,0,9,12,0,14,11,13,10,2] } }
theorem leafL_009_5_valid : (leafL_009_5).reject.ValidFor (leafL_009_5).leaf := by decide

noncomputable def leafL_009_6 : RejectedLeaf := { leaf := {0,1,17,34,52,67,92,159}, reject := .fullRank { members := ![0,1,17,34,52,67,92,159], points := ![109,121,139,167,173,182], inverse := ![2,13,5,12,5,2,1,8,9,14,8,6,6,4,7,14,3,8,9,4,12,4,3,6,15,13,7,10,14,1,12,6,8,0,13,15] } }
theorem leafL_009_6_valid : (leafL_009_6).reject.ValidFor (leafL_009_6).leaf := by decide

noncomputable def leafL_009_7 : RejectedLeaf := { leaf := {0,1,17,34,52,67,92,182}, reject := .fullRank { members := ![0,1,17,34,52,67,92,182], points := ![112,121,127,138,141,151], inverse := ![1,3,15,0,8,4,3,11,3,13,15,9,8,14,2,7,2,1,2,2,3,11,14,6,10,2,13,13,4,12,11,6,1,2,13,3] } }
theorem leafL_009_7_valid : (leafL_009_7).reject.ValidFor (leafL_009_7).leaf := by decide

noncomputable def leavesL_009 : List RejectedLeaf := [leafL_009_0,leafL_009_1,leafL_009_2,leafL_009_3,leafL_009_4,leafL_009_5,leafL_009_6,leafL_009_7]

theorem leavesL_009_valid : LeafListValid leavesL_009 := by
  intro x hx
  simp only [leavesL_009, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_009_0_valid
  · exact leafL_009_1_valid
  · exact leafL_009_2_valid
  · exact leafL_009_3_valid
  · exact leafL_009_4_valid
  · exact leafL_009_5_valid
  · exact leafL_009_6_valid
  · exact leafL_009_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
