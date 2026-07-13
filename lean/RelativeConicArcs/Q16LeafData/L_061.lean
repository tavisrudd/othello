import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_061_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,159}, reject := .fullRank { members := ![0,1,17,34,52,69,104,159], points := ![89,91,115,139,166,169], inverse := ![13,5,10,9,10,0,6,2,3,5,12,14,2,5,1,13,2,9,7,13,0,13,0,7,1,1,0,0,12,12,3,9,9,15,2,14] } }
theorem leafL_061_0_valid : (leafL_061_0).reject.ValidFor (leafL_061_0).leaf := by decide

noncomputable def leafL_061_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,166}, reject := .fullRank { members := ![0,1,17,34,52,69,104,166], points := ![89,90,94,137,139,155], inverse := ![6,13,3,12,15,10,14,9,1,0,9,15,11,13,6,0,0,0,1,3,6,3,5,2,13,0,13,15,15,0,5,3,6,7,7,0] } }
theorem leafL_061_1_valid : (leafL_061_1).reject.ValidFor (leafL_061_1).leaf := by decide

noncomputable def leafL_061_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,169}, reject := .fullRank { members := ![0,1,17,34,52,69,104,169], points := ![90,91,94,127,139,155], inverse := ![7,14,11,5,0,6,0,6,0,0,9,15,10,2,8,0,0,0,12,15,12,12,2,1,10,9,2,9,7,15,15,13,15,15,5,7] } }
theorem leafL_061_2_valid : (leafL_061_2).reject.ValidFor (leafL_061_2).leaf := by decide

noncomputable def leafL_061_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,173}, reject := .fullRank { members := ![0,1,17,34,52,69,104,173], points := ![89,92,94,115,126,137], inverse := ![13,11,1,0,14,8,4,11,8,7,14,14,8,12,4,0,0,0,1,10,12,15,7,15,13,11,6,3,3,0,2,9,11,4,4,0] } }
theorem leafL_061_3_valid : (leafL_061_3).reject.ValidFor (leafL_061_3).leaf := by decide

noncomputable def leafL_061_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,175}, reject := .fullRank { members := ![0,1,17,34,52,69,104,175], points := ![89,91,92,126,138,141], inverse := ![11,12,0,14,15,7,3,4,0,9,8,6,7,9,14,0,0,0,0,11,12,8,1,14,0,12,12,0,6,6,5,1,4,0,8,8] } }
theorem leafL_061_4_valid : (leafL_061_4).reject.ValidFor (leafL_061_4).leaf := by decide

noncomputable def leafL_061_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,182}, reject := .fullRank { members := ![0,1,17,34,52,69,104,182], points := ![92,94,126,137,138,154], inverse := ![4,13,9,2,6,5,10,6,5,11,1,3,8,10,1,9,7,13,15,11,0,7,1,2,9,15,3,5,4,4,6,13,12,8,12,3] } }
theorem leafL_061_5_valid : (leafL_061_5).reject.ValidFor (leafL_061_5).leaf := by decide

noncomputable def leafL_061_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,189}, reject := .fullRank { members := ![0,1,17,34,52,69,104,189], points := ![86,92,115,139,154,159], inverse := ![11,12,14,8,14,14,2,2,3,8,2,9,15,6,13,10,10,4,3,4,8,15,9,9,12,1,15,5,7,0,11,0,12,4,13,14] } }
theorem leafL_061_6_valid : (leafL_061_6).reject.ValidFor (leafL_061_6).leaf := by decide

noncomputable def leafL_061_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,190}, reject := .fullRank { members := ![0,1,17,34,52,69,104,190], points := ![86,90,92,115,127,137], inverse := ![0,1,6,10,4,8,1,10,12,13,4,14,13,5,8,0,0,0,0,15,8,10,2,15,14,4,10,7,7,0,5,5,0,5,5,0] } }
theorem leafL_061_7_valid : (leafL_061_7).reject.ValidFor (leafL_061_7).leaf := by decide

noncomputable def leavesL_061 : List RejectedLeaf := [leafL_061_0,leafL_061_1,leafL_061_2,leafL_061_3,leafL_061_4,leafL_061_5,leafL_061_6,leafL_061_7]

theorem leavesL_061_valid : LeafListValid leavesL_061 := by
  intro x hx
  simp only [leavesL_061, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_061_0_valid
  · exact leafL_061_1_valid
  · exact leafL_061_2_valid
  · exact leafL_061_3_valid
  · exact leafL_061_4_valid
  · exact leafL_061_5_valid
  · exact leafL_061_6_valid
  · exact leafL_061_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
