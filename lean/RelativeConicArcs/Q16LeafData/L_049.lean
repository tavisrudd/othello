import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_049_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,217}, reject := .fullRank { members := ![0,1,17,34,52,69,95,217], points := ![99,115,120,124,138,141], inverse := ![7,7,5,11,12,3,7,9,8,15,4,13,0,5,2,7,0,0,7,3,14,2,9,1,0,6,14,8,15,15,0,11,11,0,11,11] } }
theorem leafL_049_0_valid : (leafL_049_0).reject.ValidFor (leafL_049_0).leaf := by decide

noncomputable def leafL_049_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,218}, reject := .fullRank { members := ![0,1,17,34,52,69,95,218], points := ![112,120,131,139,150,151], inverse := ![13,6,5,3,5,9,8,15,6,11,10,0,12,10,7,9,3,11,9,6,5,15,13,8,4,6,4,15,11,2,2,3,7,11,0,13] } }
theorem leafL_049_1_valid : (leafL_049_1).reject.ValidFor (leafL_049_1).leaf := by decide

noncomputable def leafL_049_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,220}, reject := .fullRank { members := ![0,1,17,34,52,69,95,220], points := ![103,106,112,120,137,138], inverse := ![12,13,6,9,1,14,3,8,12,14,7,14,3,13,14,0,0,0,9,3,13,15,3,11,6,10,12,0,11,11,13,1,12,0,9,9] } }
theorem leafL_049_2_valid : (leafL_049_2).reject.ValidFor (leafL_049_2).leaf := by decide

noncomputable def leafL_049_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,222}, reject := .fullRank { members := ![0,1,17,34,52,69,95,222], points := ![99,106,107,115,124,131], inverse := ![8,3,12,5,12,15,7,0,0,14,0,9,6,3,5,0,0,0,9,2,12,2,13,8,2,14,12,6,6,0,7,1,6,15,15,0] } }
theorem leafL_049_3_valid : (leafL_049_3).reject.ValidFor (leafL_049_3).leaf := by decide

noncomputable def leafL_049_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,232}, reject := .fullRank { members := ![0,1,17,34,52,69,95,232], points := ![107,115,126,137,138,139], inverse := ![7,4,13,15,13,13,7,10,4,5,6,10,0,0,0,9,14,7,7,8,7,3,4,15,0,13,13,9,12,5,0,8,8,6,10,12] } }
theorem leafL_049_4_valid : (leafL_049_4).reject.ValidFor (leafL_049_4).leaf := by decide

noncomputable def leafL_049_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,235}, reject := .fullRank { members := ![0,1,17,34,52,69,95,235], points := ![112,120,124,131,137,138], inverse := ![7,5,12,14,8,9,7,11,5,12,14,11,0,0,0,9,12,5,7,9,6,12,7,3,0,3,3,2,3,1,0,10,10,15,2,13] } }
theorem leafL_049_5_valid : (leafL_049_5).reject.ValidFor (leafL_049_5).leaf := by decide

noncomputable def leafL_049_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,240}, reject := .fullRank { members := ![0,1,17,34,52,69,95,240], points := ![99,106,115,124,131,141], inverse := ![9,14,0,9,6,9,7,0,14,0,9,0,2,2,7,7,2,2,8,15,7,8,1,9,3,3,3,3,9,9,14,14,4,4,13,13] } }
theorem leafL_049_6_valid : (leafL_049_6).reject.ValidFor (leafL_049_6).leaf := by decide

noncomputable def leafL_049_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,246}, reject := .fullRank { members := ![0,1,17,34,52,69,95,246], points := ![99,115,124,126,131,138], inverse := ![7,7,4,10,6,9,7,14,0,0,9,0,0,3,14,13,0,0,7,7,9,1,2,10,0,1,13,12,13,13,0,4,13,9,5,5] } }
theorem leafL_049_7_valid : (leafL_049_7).reject.ValidFor (leafL_049_7).leaf := by decide

noncomputable def leavesL_049 : List RejectedLeaf := [leafL_049_0,leafL_049_1,leafL_049_2,leafL_049_3,leafL_049_4,leafL_049_5,leafL_049_6,leafL_049_7]

theorem leavesL_049_valid : LeafListValid leavesL_049 := by
  intro x hx
  simp only [leavesL_049, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_049_0_valid
  · exact leafL_049_1_valid
  · exact leafL_049_2_valid
  · exact leafL_049_3_valid
  · exact leafL_049_4_valid
  · exact leafL_049_5_valid
  · exact leafL_049_6_valid
  · exact leafL_049_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
