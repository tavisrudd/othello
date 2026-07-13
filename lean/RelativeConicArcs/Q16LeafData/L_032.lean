import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_032_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,137}, reject := .fullRank { members := ![0,1,17,34,52,69,92,137], points := ![104,127,154,173,174,190], inverse := ![1,7,0,14,2,11,2,6,10,3,14,3,10,7,1,5,1,8,10,12,3,3,14,8,1,11,14,8,2,14,5,11,13,11,4,12] } }
theorem leafL_032_0_valid : (leafL_032_0).reject.ValidFor (leafL_032_0).leaf := by decide

noncomputable def leafL_032_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,138}, reject := .fullRank { members := ![0,1,17,34,52,69,92,138], points := ![99,104,107,126,127,151], inverse := ![13,4,5,1,15,3,12,2,3,9,8,12,3,10,9,0,0,0,14,14,10,0,13,7,7,9,14,1,1,0,14,15,1,11,11,0] } }
theorem leafL_032_1_valid : (leafL_032_1).reject.ValidFor (leafL_032_1).leaf := by decide

noncomputable def leafL_032_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,139}, reject := .fullRank { members := ![0,1,17,34,52,69,92,139], points := ![104,122,126,152,154,169], inverse := ![11,13,15,8,1,1,10,15,2,2,4,1,6,15,13,12,15,7,2,14,10,12,15,5,14,14,5,2,5,2,8,3,10,6,2,5] } }
theorem leafL_032_2_valid : (leafL_032_2).reject.ValidFor (leafL_032_2).leaf := by decide

noncomputable def leafL_032_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,141}, reject := .fullRank { members := ![0,1,17,34,52,69,92,141], points := ![99,126,151,152,175,184], inverse := ![5,4,4,11,13,2,9,4,8,0,9,12,5,8,1,0,11,7,4,14,1,7,0,12,7,5,10,2,14,4,13,7,12,2,6,2] } }
theorem leafL_032_3_valid : (leafL_032_3).reject.ValidFor (leafL_032_3).leaf := by decide

noncomputable def leafL_032_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,151}, reject := .fullRank { members := ![0,1,17,34,52,69,92,151], points := ![99,107,122,131,138,141], inverse := ![8,15,9,4,4,15,14,9,14,8,5,4,0,0,0,15,1,14,9,14,15,13,12,9,12,12,0,5,7,2,14,14,0,10,3,9] } }
theorem leafL_032_4_valid : (leafL_032_4).reject.ValidFor (leafL_032_4).leaf := by decide

noncomputable def leafL_032_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,152}, reject := .fullRank { members := ![0,1,17,34,52,69,92,152], points := ![99,126,127,131,135,138], inverse := ![7,9,0,9,11,13,7,13,3,15,1,7,0,0,0,12,2,14,7,6,9,9,4,5,0,12,12,3,12,15,0,14,14,15,3,12] } }
theorem leafL_032_5_valid : (leafL_032_5).reject.ValidFor (leafL_032_5).leaf := by decide

noncomputable def leafL_032_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,154}, reject := .fullRank { members := ![0,1,17,34,52,69,92,154], points := ![99,104,127,137,139,173], inverse := ![6,11,10,13,7,12,5,13,5,7,0,10,15,6,10,11,6,14,6,1,15,9,1,0,13,4,10,7,10,14,0,5,8,15,4,6] } }
theorem leafL_032_6_valid : (leafL_032_6).reject.ValidFor (leafL_032_6).leaf := by decide

noncomputable def leafL_032_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,155}, reject := .fullRank { members := ![0,1,17,34,52,69,92,155], points := ![104,126,138,169,174,175], inverse := ![5,7,14,1,2,14,12,10,5,9,0,10,0,0,0,4,8,12,12,11,4,0,12,15,8,13,4,3,13,15,3,9,8,13,3,12] } }
theorem leafL_032_7_valid : (leafL_032_7).reject.ValidFor (leafL_032_7).leaf := by decide

noncomputable def leavesL_032 : List RejectedLeaf := [leafL_032_0,leafL_032_1,leafL_032_2,leafL_032_3,leafL_032_4,leafL_032_5,leafL_032_6,leafL_032_7]

theorem leavesL_032_valid : LeafListValid leavesL_032 := by
  intro x hx
  simp only [leavesL_032, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_032_0_valid
  · exact leafL_032_1_valid
  · exact leafL_032_2_valid
  · exact leafL_032_3_valid
  · exact leafL_032_4_valid
  · exact leafL_032_5_valid
  · exact leafL_032_6_valid
  · exact leafL_032_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
