import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_240_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,216,267}, reject := .fullRank { members := ![0,1,17,34,52,71,216,267], points := ![101,106,122,127,133,141], inverse := ![15,8,2,11,8,7,3,4,11,5,11,2,9,9,8,8,13,13,2,5,10,5,10,2,8,8,10,10,0,0,14,14,7,7,8,8] } }
theorem leafL_240_0_valid : (leafL_240_0).reject.ValidFor (leafL_240_0).leaf := by decide

noncomputable def leafL_240_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,216,268}, reject := .fullRank { members := ![0,1,17,34,52,71,216,268], points := ![90,91,101,109,110,126], inverse := ![12,3,9,12,13,6,6,15,10,5,1,7,0,0,13,15,2,0,0,8,2,12,1,7,3,3,6,7,1,0,14,14,9,12,5,0] } }
theorem leafL_240_1_valid : (leafL_240_1).reject.ValidFor (leafL_240_1).leaf := by decide

noncomputable def leafL_240_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,217,237}, reject := .fullRank { members := ![0,1,17,34,52,71,217,237], points := ![83,91,94,104,110,122], inverse := ![4,15,4,5,13,6,12,9,12,3,13,7,1,4,5,0,0,0,2,12,6,0,15,7,6,6,0,5,5,0,13,7,10,12,12,0] } }
theorem leafL_240_2_valid : (leafL_240_2).reject.ValidFor (leafL_240_2).leaf := by decide

noncomputable def leafL_240_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,217,240}, reject := .fullRank { members := ![0,1,17,34,52,71,217,240], points := ![94,101,104,109,120,122], inverse := ![15,10,3,1,2,4,9,4,14,4,2,5,0,5,3,6,0,0,8,7,14,6,15,8,0,7,6,1,5,5,0,15,6,9,1,1] } }
theorem leafL_240_3_valid : (leafL_240_3).reject.ValidFor (leafL_240_3).leaf := by decide

noncomputable def leafL_240_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,217,262}, reject := .fullRank { members := ![0,1,17,34,52,71,217,262], points := ![83,91,96,99,109,120], inverse := ![4,7,12,11,3,6,14,8,15,11,5,7,9,3,10,0,0,0,4,2,14,12,3,7,14,3,13,12,12,0,12,5,9,3,3,0] } }
theorem leafL_240_4_valid : (leafL_240_4).reject.ValidFor (leafL_240_4).leaf := by decide

noncomputable def leafL_240_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,218,235}, reject := .fullRank { members := ![0,1,17,34,52,71,218,235], points := ![96,101,110,120,121,124], inverse := ![15,15,7,14,10,2,9,13,3,1,1,7,0,0,0,15,9,6,8,3,12,14,11,2,0,4,4,9,3,10,0,15,15,4,8,12] } }
theorem leafL_240_5_valid : (leafL_240_5).reject.ValidFor (leafL_240_5).leaf := by decide

noncomputable def leafL_240_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,218,239}, reject := .fullRank { members := ![0,1,17,34,52,71,218,239], points := ![91,94,104,128,133,139], inverse := ![7,0,0,14,8,0,13,2,8,1,8,14,9,15,6,6,1,7,5,3,1,9,2,12,10,15,5,5,12,9,8,9,1,1,6,7] } }
theorem leafL_240_6_valid : (leafL_240_6).reject.ValidFor (leafL_240_6).leaf := by decide

noncomputable def leafL_240_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,218,249}, reject := .fullRank { members := ![0,1,17,34,52,71,218,249], points := ![83,104,109,120,140,141], inverse := ![0,8,15,9,1,14,5,13,15,11,14,2,14,15,1,14,0,14,1,1,7,14,8,1,2,0,2,2,15,13,2,15,13,2,3,1] } }
theorem leafL_240_7_valid : (leafL_240_7).reject.ValidFor (leafL_240_7).leaf := by decide

noncomputable def leavesL_240 : List RejectedLeaf := [leafL_240_0,leafL_240_1,leafL_240_2,leafL_240_3,leafL_240_4,leafL_240_5,leafL_240_6,leafL_240_7]

theorem leavesL_240_valid : LeafListValid leavesL_240 := by
  intro x hx
  simp only [leavesL_240, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_240_0_valid
  · exact leafL_240_1_valid
  · exact leafL_240_2_valid
  · exact leafL_240_3_valid
  · exact leafL_240_4_valid
  · exact leafL_240_5_valid
  · exact leafL_240_6_valid
  · exact leafL_240_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
