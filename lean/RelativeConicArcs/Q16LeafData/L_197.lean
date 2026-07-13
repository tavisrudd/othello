import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_197_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,126,248}, reject := .fullRank { members := ![0,1,17,34,52,71,126,248], points := ![92,96,101,106,131,138], inverse := ![9,0,1,15,2,4,5,11,13,4,1,6,3,3,14,14,13,13,1,14,1,9,12,11,6,6,1,1,8,8,5,5,3,3,15,15] } }
theorem leafL_197_0_valid : (leafL_197_0).reject.ValidFor (leafL_197_0).leaf := by decide

noncomputable def leafL_197_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,126,249}, reject := .fullRank { members := ![0,1,17,34,52,71,126,249], points := ![90,92,101,106,131,141], inverse := ![12,5,14,0,12,10,7,9,6,15,3,4,3,3,7,7,5,5,10,5,8,0,0,7,5,5,7,7,1,1,11,11,15,15,6,6] } }
theorem leafL_197_1_valid : (leafL_197_1).reject.ValidFor (leafL_197_1).leaf := by decide

noncomputable def leafL_197_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,126,253}, reject := .fullRank { members := ![0,1,17,34,52,71,126,253], points := ![90,104,138,144,150,154], inverse := ![10,15,11,2,0,13,6,0,9,0,0,15,1,14,13,8,6,12,10,11,3,6,12,8,13,10,12,0,3,8,15,5,10,12,11,7] } }
theorem leafL_197_2_valid : (leafL_197_2).reject.ValidFor (leafL_197_2).leaf := by decide

noncomputable def leafL_197_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,126,259}, reject := .fullRank { members := ![0,1,17,34,52,71,126,259], points := ![90,92,96,104,139,144], inverse := ![4,14,3,14,0,6,15,14,15,9,6,1,10,15,5,0,0,0,6,11,2,8,11,12,5,13,8,0,6,6,6,15,9,0,8,8] } }
theorem leafL_197_3_valid : (leafL_197_3).reject.ValidFor (leafL_197_3).leaf := by decide

noncomputable def leafL_197_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,126,268}, reject := .fullRank { members := ![0,1,17,34,52,71,126,268], points := ![90,101,104,131,139,144], inverse := ![9,11,5,2,5,1,14,12,5,3,1,5,0,0,0,9,3,10,15,13,5,2,1,4,0,6,6,6,14,8,0,7,7,8,9,1] } }
theorem leafL_197_4_valid : (leafL_197_4).reject.ValidFor (leafL_197_4).leaf := by decide

noncomputable def leafL_197_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,128,131}, reject := .fullRank { members := ![0,1,17,34,52,71,128,131], points := ![94,101,109,110,154,172], inverse := ![6,13,7,1,12,0,3,7,6,12,7,9,0,13,15,2,0,0,0,4,10,0,5,11,14,4,12,6,14,14,8,12,5,1,8,8] } }
theorem leafL_197_5_valid : (leafL_197_5).reject.ValidFor (leafL_197_5).leaf := by decide

noncomputable def leafL_197_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,128,140}, reject := .fullRank { members := ![0,1,17,34,52,71,128,140], points := ![93,94,99,104,109,150], inverse := ![7,1,13,5,3,12,15,5,6,0,2,14,0,0,14,1,15,0,2,9,8,8,5,14,5,5,5,8,13,0,1,1,6,15,9,0] } }
theorem leafL_197_6_valid : (leafL_197_6).reject.ValidFor (leafL_197_6).leaf := by decide

noncomputable def leafL_197_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,128,147}, reject := .fullRank { members := ![0,1,17,34,52,71,128,147], points := ![101,110,169,171,172,182], inverse := ![14,8,0,15,4,12,2,13,2,4,0,9,0,0,7,9,14,0,14,12,14,8,2,6,10,10,11,10,1,0,7,7,11,4,15,0] } }
theorem leafL_197_7_valid : (leafL_197_7).reject.ValidFor (leafL_197_7).leaf := by decide

noncomputable def leavesL_197 : List RejectedLeaf := [leafL_197_0,leafL_197_1,leafL_197_2,leafL_197_3,leafL_197_4,leafL_197_5,leafL_197_6,leafL_197_7]

theorem leavesL_197_valid : LeafListValid leavesL_197 := by
  intro x hx
  simp only [leavesL_197, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_197_0_valid
  · exact leafL_197_1_valid
  · exact leafL_197_2_valid
  · exact leafL_197_3_valid
  · exact leafL_197_4_valid
  · exact leafL_197_5_valid
  · exact leafL_197_6_valid
  · exact leafL_197_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
