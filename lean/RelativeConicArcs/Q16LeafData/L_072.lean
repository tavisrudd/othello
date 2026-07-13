import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_072_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,131}, reject := .fullRank { members := ![0,1,17,34,52,69,110,131], points := ![89,128,156,159,169,175], inverse := ![9,13,10,11,15,11,15,14,10,8,12,15,15,5,4,5,1,10,0,11,6,4,1,8,5,3,1,15,3,11,2,15,7,4,4,10] } }
theorem leafL_072_0_valid : (leafL_072_0).reject.ValidFor (leafL_072_0).leaf := by decide

noncomputable def leafL_072_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,135}, reject := .fullRank { members := ![0,1,17,34,52,69,110,135], points := ![89,90,91,115,122,152], inverse := ![7,11,14,12,9,6,14,1,10,11,3,13,9,14,7,0,0,0,14,14,3,9,3,9,0,1,1,10,10,0,2,10,8,11,11,0] } }
theorem leafL_072_1_valid : (leafL_072_1).reject.ValidFor (leafL_072_1).leaf := by decide

noncomputable def leafL_072_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,137}, reject := .fullRank { members := ![0,1,17,34,52,69,110,137], points := ![90,91,93,122,127,152], inverse := ![2,1,1,13,8,6,0,7,2,11,3,13,8,12,4,0,0,0,11,8,0,4,14,9,6,12,10,12,12,0,4,12,8,3,3,0] } }
theorem leafL_072_2_valid : (leafL_072_2).reject.ValidFor (leafL_072_2).leaf := by decide

noncomputable def leafL_072_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,141}, reject := .fullRank { members := ![0,1,17,34,52,69,110,141], points := ![86,89,152,156,163,166], inverse := ![4,9,0,7,7,12,10,4,2,8,14,10,14,14,2,2,6,6,1,15,15,4,1,4,8,8,0,0,10,10,8,8,15,15,9,9] } }
theorem leafL_072_3_valid : (leafL_072_3).reject.ValidFor (leafL_072_3).leaf := by decide

noncomputable def leafL_072_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,152}, reject := .fullRank { members := ![0,1,17,34,52,69,110,152], points := ![86,90,93,122,127,135], inverse := ![5,5,7,13,3,8,4,11,8,11,2,14,7,2,5,0,0,0,2,11,14,4,12,15,7,12,11,12,12,0,7,14,9,3,3,0] } }
theorem leafL_072_4_valid : (leafL_072_4).reject.ValidFor (leafL_072_4).leaf := by decide

noncomputable def leafL_072_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,155}, reject := .fullRank { members := ![0,1,17,34,52,69,110,155], points := ![89,90,93,115,135,144], inverse := ![14,2,11,14,5,13,4,3,0,9,7,9,13,11,6,0,0,0,11,12,0,8,3,12,8,2,10,0,9,9,1,2,3,0,15,15] } }
theorem leafL_072_5_valid : (leafL_072_5).reject.ValidFor (leafL_072_5).leaf := by decide

noncomputable def leafL_072_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,159}, reject := .fullRank { members := ![0,1,17,34,52,69,110,159], points := ![86,89,91,115,122,131], inverse := ![3,13,9,9,7,8,15,10,2,9,0,14,6,2,4,0,0,0,12,2,9,13,5,15,10,14,4,10,10,0,8,4,12,11,11,0] } }
theorem leafL_072_6_valid : (leafL_072_6).reject.ValidFor (leafL_072_6).leaf := by decide

noncomputable def leafL_072_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,163}, reject := .fullRank { members := ![0,1,17,34,52,69,110,163], points := ![86,90,91,122,127,137], inverse := ![11,2,14,6,8,8,7,3,3,10,3,14,15,6,9,0,0,0,1,3,5,6,14,15,3,14,13,12,12,0,13,11,6,3,3,0] } }
theorem leafL_072_7_valid : (leafL_072_7).reject.ValidFor (leafL_072_7).leaf := by decide

noncomputable def leavesL_072 : List RejectedLeaf := [leafL_072_0,leafL_072_1,leafL_072_2,leafL_072_3,leafL_072_4,leafL_072_5,leafL_072_6,leafL_072_7]

theorem leavesL_072_valid : LeafListValid leavesL_072 := by
  intro x hx
  simp only [leavesL_072, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_072_0_valid
  · exact leafL_072_1_valid
  · exact leafL_072_2_valid
  · exact leafL_072_3_valid
  · exact leafL_072_4_valid
  · exact leafL_072_5_valid
  · exact leafL_072_6_valid
  · exact leafL_072_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
