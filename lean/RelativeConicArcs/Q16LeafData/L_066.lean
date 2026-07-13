import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_066_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,205}, reject := .fullRank { members := ![0,1,17,34,52,69,106,205], points := ![89,91,94,120,126,135], inverse := ![10,9,4,5,11,8,6,3,2,15,6,14,12,3,15,0,0,0,14,11,2,5,13,15,4,11,15,11,11,0,8,1,9,6,6,0] } }
theorem leafL_066_0_valid : (leafL_066_0).reject.ValidFor (leafL_066_0).leaf := by decide

noncomputable def leafL_066_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,208}, reject := .fullRank { members := ![0,1,17,34,52,69,106,208], points := ![89,91,95,115,126,135], inverse := ![14,12,5,6,8,8,9,10,4,10,3,14,10,15,5,0,0,0,7,7,7,6,14,15,10,11,1,3,3,0,1,7,6,4,4,0] } }
theorem leafL_066_1_valid : (leafL_066_1).reject.ValidFor (leafL_066_1).leaf := by decide

noncomputable def leafL_066_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,214}, reject := .fullRank { members := ![0,1,17,34,52,69,106,214], points := ![89,94,96,115,135,139], inverse := ![9,2,12,14,4,12,9,14,0,9,5,11,15,12,3,0,0,0,11,7,11,8,6,9,1,12,13,0,11,11,3,10,9,0,6,6] } }
theorem leafL_066_2_valid : (leafL_066_2).reject.ValidFor (leafL_066_2).leaf := by decide

noncomputable def leafL_066_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,220}, reject := .fullRank { members := ![0,1,17,34,52,69,106,220], points := ![91,95,96,115,120,135], inverse := ![7,8,8,5,11,8,8,4,11,12,5,14,6,13,11,0,0,0,13,5,15,9,1,15,3,12,15,5,5,0,12,0,12,12,12,0] } }
theorem leafL_066_3_valid : (leafL_066_3).reject.ValidFor (leafL_066_3).leaf := by decide

noncomputable def leafL_066_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,222}, reject := .fullRank { members := ![0,1,17,34,52,69,106,222], points := ![89,95,96,124,144,166], inverse := ![9,8,6,14,8,0,2,7,13,13,15,10,1,7,6,0,0,0,11,8,13,11,11,14,9,0,6,4,1,10,2,8,13,1,13,11] } }
theorem leafL_066_4_valid : (leafL_066_4).reject.ValidFor (leafL_066_4).leaf := by decide

noncomputable def leafL_066_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,230}, reject := .fullRank { members := ![0,1,17,34,52,69,106,230], points := ![89,91,120,141,144,159], inverse := ![7,8,10,7,2,1,15,3,5,7,13,3,5,8,15,0,5,7,8,2,7,10,0,7,0,7,10,10,12,11,4,14,5,11,8,12] } }
theorem leafL_066_5_valid : (leafL_066_5).reject.ValidFor (leafL_066_5).leaf := by decide

noncomputable def leafL_066_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,236}, reject := .fullRank { members := ![0,1,17,34,52,69,106,236], points := ![89,115,120,135,144,159], inverse := ![5,15,0,9,15,13,13,6,10,15,2,12,5,7,12,2,10,6,9,1,14,5,6,5,1,0,9,9,14,15,9,9,4,9,3,14] } }
theorem leafL_066_6_valid : (leafL_066_6).reject.ValidFor (leafL_066_6).leaf := by decide

noncomputable def leafL_066_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,247}, reject := .fullRank { members := ![0,1,17,34,52,69,106,247], points := ![91,115,120,124,139,141], inverse := ![7,13,7,4,2,10,7,6,8,7,14,0,0,5,2,7,0,0,7,4,0,12,12,3,0,2,9,11,1,1,0,4,13,9,7,7] } }
theorem leafL_066_7_valid : (leafL_066_7).reject.ValidFor (leafL_066_7).leaf := by decide

noncomputable def leavesL_066 : List RejectedLeaf := [leafL_066_0,leafL_066_1,leafL_066_2,leafL_066_3,leafL_066_4,leafL_066_5,leafL_066_6,leafL_066_7]

theorem leavesL_066_valid : LeafListValid leavesL_066 := by
  intro x hx
  simp only [leavesL_066, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_066_0_valid
  · exact leafL_066_1_valid
  · exact leafL_066_2_valid
  · exact leafL_066_3_valid
  · exact leafL_066_4_valid
  · exact leafL_066_5_valid
  · exact leafL_066_6_valid
  · exact leafL_066_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
