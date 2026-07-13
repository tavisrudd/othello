import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_213_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,154,240}, reject := .fullRank { members := ![0,1,17,34,52,71,154,240], points := ![99,104,109,127,131,133], inverse := ![7,7,7,9,15,0,11,13,1,14,8,1,14,1,15,0,0,0,6,1,0,15,13,5,10,9,3,0,4,4,5,4,1,0,10,10] } }
theorem leafL_213_0_valid : (leafL_213_0).reject.ValidFor (leafL_213_0).leaf := by decide

noncomputable def leafL_213_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,154,243}, reject := .fullRank { members := ![0,1,17,34,52,71,154,243], points := ![104,127,128,133,144,166], inverse := ![12,6,11,3,0,3,10,12,7,0,6,7,13,5,0,7,8,7,9,10,9,4,11,5,2,9,7,0,1,13,11,5,1,6,10,3] } }
theorem leafL_213_1_valid : (leafL_213_1).reject.ValidFor (leafL_213_1).leaf := by decide

noncomputable def leafL_213_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,154,245}, reject := .fullRank { members := ![0,1,17,34,52,71,154,245], points := ![91,93,96,99,104,139], inverse := ![15,7,1,10,4,6,10,12,8,3,10,7,4,12,8,0,0,0,1,7,9,7,15,7,6,9,15,10,10,0,11,0,11,11,11,0] } }
theorem leafL_213_2_valid : (leafL_213_2).reject.ValidFor (leafL_213_2).leaf := by decide

noncomputable def leafL_213_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,154,248}, reject := .fullRank { members := ![0,1,17,34,52,71,154,248], points := ![91,92,93,99,109,128], inverse := ![14,7,6,6,14,6,4,10,7,3,13,7,7,6,1,0,0,0,5,3,14,4,11,7,8,0,8,12,12,0,10,5,15,3,3,0] } }
theorem leafL_213_3_valid : (leafL_213_3).reject.ValidFor (leafL_213_3).leaf := by decide

noncomputable def leafL_213_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,154,249}, reject := .fullRank { members := ![0,1,17,34,52,71,154,249], points := ![83,93,104,126,144,166], inverse := ![14,11,5,10,0,11,6,6,7,14,9,0,2,5,14,13,10,14,8,8,1,14,11,4,9,10,7,12,1,9,12,11,3,8,5,9] } }
theorem leafL_213_4_valid : (leafL_213_4).reject.ValidFor (leafL_213_4).leaf := by decide

noncomputable def leafL_213_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,154,267}, reject := .fullRank { members := ![0,1,17,34,52,71,154,267], points := ![92,93,104,127,133,144], inverse := ![6,3,2,12,3,9,12,10,1,8,14,1,8,3,11,11,6,13,14,12,5,13,11,1,8,2,10,10,7,13,4,14,10,10,8,2] } }
theorem leafL_213_5_valid : (leafL_213_5).reject.ValidFor (leafL_213_5).leaf := by decide

noncomputable def leafL_213_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,154,268}, reject := .fullRank { members := ![0,1,17,34,52,71,154,268], points := ![91,93,104,109,127,128], inverse := ![5,10,9,1,7,1,8,1,13,3,10,13,8,8,13,13,3,3,1,9,0,15,15,8,5,5,2,2,9,9,5,5,11,11,4,4] } }
theorem leafL_213_6_valid : (leafL_213_6).reject.ValidFor (leafL_213_6).leaf := by decide

noncomputable def leafL_213_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,155,168}, reject := .fullRank { members := ![0,1,17,34,52,71,155,168], points := ![92,96,109,110,124,144], inverse := ![15,10,7,5,12,10,6,10,6,13,2,5,2,13,12,3,15,15,1,12,11,1,2,5,10,8,3,1,2,2,7,1,8,14,6,6] } }
theorem leafL_213_7_valid : (leafL_213_7).reject.ValidFor (leafL_213_7).leaf := by decide

noncomputable def leavesL_213 : List RejectedLeaf := [leafL_213_0,leafL_213_1,leafL_213_2,leafL_213_3,leafL_213_4,leafL_213_5,leafL_213_6,leafL_213_7]

theorem leavesL_213_valid : LeafListValid leavesL_213 := by
  intro x hx
  simp only [leavesL_213, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_213_0_valid
  · exact leafL_213_1_valid
  · exact leafL_213_2_valid
  · exact leafL_213_3_valid
  · exact leafL_213_4_valid
  · exact leafL_213_5_valid
  · exact leafL_213_6_valid
  · exact leafL_213_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
