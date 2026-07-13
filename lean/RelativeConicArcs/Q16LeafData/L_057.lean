import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_057_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,154}, reject := .fullRank { members := ![0,1,17,34,52,69,103,154], points := ![91,93,124,128,131,137], inverse := ![9,14,8,6,4,12,11,12,11,2,0,14,15,15,3,3,10,10,11,12,12,4,10,5,4,4,15,15,7,7,5,5,12,12,10,10] } }
theorem leafL_057_0_valid : (leafL_057_0).reject.ValidFor (leafL_057_0).leaf := by decide

noncomputable def leafL_057_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,159}, reject := .fullRank { members := ![0,1,17,34,52,69,103,159], points := ![86,91,93,124,131,173], inverse := ![13,11,15,12,1,5,0,15,14,14,11,4,3,13,14,0,0,0,10,8,4,14,7,15,12,10,3,13,14,6,8,12,8,14,10,8] } }
theorem leafL_057_1_valid : (leafL_057_1).reject.ValidFor (leafL_057_1).leaf := by decide

noncomputable def leafL_057_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,169}, reject := .fullRank { members := ![0,1,17,34,52,69,103,169], points := ![91,94,95,124,127,131], inverse := ![5,1,3,0,14,8,9,0,14,15,6,14,8,2,10,0,0,0,9,14,0,9,1,15,1,12,13,5,5,0,11,1,10,12,12,0] } }
theorem leafL_057_2_valid : (leafL_057_2).reject.ValidFor (leafL_057_2).leaf := by decide

noncomputable def leafL_057_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,171}, reject := .fullRank { members := ![0,1,17,34,52,69,103,171], points := ![86,94,124,126,127,137], inverse := ![2,5,11,0,5,8,1,6,1,2,10,14,0,0,4,12,8,0,8,15,14,15,9,15,2,2,1,12,13,0,14,14,5,8,13,0] } }
theorem leafL_057_3_valid : (leafL_057_3).reject.ValidFor (leafL_057_3).leaf := by decide

noncomputable def leafL_057_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,173}, reject := .fullRank { members := ![0,1,17,34,52,69,103,173], points := ![86,94,96,124,127,131], inverse := ![7,0,0,0,14,8,14,8,1,15,6,14,8,14,6,0,0,0,6,15,14,9,1,15,10,12,6,5,5,0,15,11,4,12,12,0] } }
theorem leafL_057_4_valid : (leafL_057_4).reject.ValidFor (leafL_057_4).leaf := by decide

noncomputable def leafL_057_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,182}, reject := .fullRank { members := ![0,1,17,34,52,69,103,182], points := ![93,95,96,124,126,131], inverse := ![4,15,12,7,9,8,12,2,9,12,5,14,7,9,14,0,0,0,6,14,15,0,8,15,11,13,6,14,14,0,3,12,15,10,10,0] } }
theorem leafL_057_5_valid : (leafL_057_5).reject.ValidFor (leafL_057_5).leaf := by decide

noncomputable def leafL_057_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,186}, reject := .fullRank { members := ![0,1,17,34,52,69,103,186], points := ![86,91,93,124,127,131], inverse := ![7,0,0,0,14,8,8,13,2,15,6,14,3,13,14,0,0,0,7,6,6,9,1,15,0,9,9,5,5,0,11,8,3,12,12,0] } }
theorem leafL_057_6_valid : (leafL_057_6).reject.ValidFor (leafL_057_6).leaf := by decide

noncomputable def leafL_057_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,190}, reject := .fullRank { members := ![0,1,17,34,52,69,103,190], points := ![86,96,127,139,150,154], inverse := ![14,14,4,14,10,1,9,12,8,0,4,9,1,6,10,6,7,12,2,5,8,15,5,5,0,13,15,5,11,12,8,2,5,3,2,14] } }
theorem leafL_057_7_valid : (leafL_057_7).reject.ValidFor (leafL_057_7).leaf := by decide

noncomputable def leavesL_057 : List RejectedLeaf := [leafL_057_0,leafL_057_1,leafL_057_2,leafL_057_3,leafL_057_4,leafL_057_5,leafL_057_6,leafL_057_7]

theorem leavesL_057_valid : LeafListValid leavesL_057 := by
  intro x hx
  simp only [leavesL_057, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_057_0_valid
  · exact leafL_057_1_valid
  · exact leafL_057_2_valid
  · exact leafL_057_3_valid
  · exact leafL_057_4_valid
  · exact leafL_057_5_valid
  · exact leafL_057_6_valid
  · exact leafL_057_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
