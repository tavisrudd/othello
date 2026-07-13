import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_060_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,126}, reject := .fullRank { members := ![0,1,17,34,52,69,104,126], points := ![86,89,90,138,139,155], inverse := ![15,2,5,8,11,10,12,5,15,0,9,15,14,4,10,0,0,0,12,5,13,2,4,2,9,10,3,10,10,0,5,7,2,11,11,0] } }
theorem leafL_060_0_valid : (leafL_060_0).reject.ValidFor (leafL_060_0).leaf := by decide

noncomputable def leafL_060_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,127}, reject := .fullRank { members := ![0,1,17,34,52,69,104,127], points := ![89,90,92,137,154,156], inverse := ![7,8,7,3,2,8,9,1,14,9,1,14,14,9,7,0,0,0,6,13,15,6,13,15,15,15,0,0,7,7,0,5,5,0,5,5] } }
theorem leafL_060_1_valid : (leafL_060_1).reject.ValidFor (leafL_060_1).leaf := by decide

noncomputable def leafL_060_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,137}, reject := .fullRank { members := ![0,1,17,34,52,69,104,137], points := ![91,92,127,154,156,166], inverse := ![15,13,5,3,5,0,15,6,12,13,10,2,3,12,5,13,12,11,0,8,2,10,4,4,15,15,0,7,7,0,14,9,12,11,6,6] } }
theorem leafL_060_2_valid : (leafL_060_2).reject.ValidFor (leafL_060_2).leaf := by decide

noncomputable def leafL_060_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,138}, reject := .fullRank { members := ![0,1,17,34,52,69,104,138], points := ![86,91,92,115,126,155], inverse := ![5,12,11,1,4,6,5,6,6,2,10,13,11,8,3,0,0,0,7,10,14,5,15,9,8,10,2,3,3,0,4,4,0,4,4,0] } }
theorem leafL_060_3_valid : (leafL_060_3).reject.ValidFor (leafL_060_3).leaf := by decide

noncomputable def leafL_060_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,139}, reject := .fullRank { members := ![0,1,17,34,52,69,104,139], points := ![86,90,92,115,126,154], inverse := ![12,4,10,5,0,6,7,3,1,5,13,13,13,5,8,0,0,0,8,1,10,11,1,9,6,9,15,3,3,0,7,11,12,4,4,0] } }
theorem leafL_060_4_valid : (leafL_060_4).reject.ValidFor (leafL_060_4).leaf := by decide

noncomputable def leafL_060_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,141}, reject := .fullRank { members := ![0,1,17,34,52,69,104,141], points := ![86,89,126,156,166,172], inverse := ![15,1,1,12,14,12,13,13,11,3,3,11,8,9,14,8,5,2,1,12,1,0,2,14,4,12,9,12,11,6,9,5,4,10,5,7] } }
theorem leafL_060_5_valid : (leafL_060_5).reject.ValidFor (leafL_060_5).leaf := by decide

noncomputable def leafL_060_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,154}, reject := .fullRank { members := ![0,1,17,34,52,69,104,154], points := ![89,92,127,137,139,172], inverse := ![7,9,13,1,13,14,11,2,11,4,3,5,8,5,8,10,8,7,3,10,10,10,12,5,13,7,9,9,6,12,2,8,9,1,14,12] } }
theorem leafL_060_6_valid : (leafL_060_6).reject.ValidFor (leafL_060_6).leaf := by decide

noncomputable def leafL_060_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,155}, reject := .fullRank { members := ![0,1,17,34,52,69,104,155], points := ![89,90,92,115,126,138], inverse := ![12,9,2,10,4,8,3,12,8,3,10,14,14,9,7,0,0,0,14,1,8,7,15,15,8,4,12,3,3,0,5,3,6,4,4,0] } }
theorem leafL_060_7_valid : (leafL_060_7).reject.ValidFor (leafL_060_7).leaf := by decide

noncomputable def leavesL_060 : List RejectedLeaf := [leafL_060_0,leafL_060_1,leafL_060_2,leafL_060_3,leafL_060_4,leafL_060_5,leafL_060_6,leafL_060_7]

theorem leavesL_060_valid : LeafListValid leavesL_060 := by
  intro x hx
  simp only [leavesL_060, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_060_0_valid
  · exact leafL_060_1_valid
  · exact leafL_060_2_valid
  · exact leafL_060_3_valid
  · exact leafL_060_4_valid
  · exact leafL_060_5_valid
  · exact leafL_060_6_valid
  · exact leafL_060_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
