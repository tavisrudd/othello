import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_287_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,208,218}, reject := .fullRank { members := ![0,1,17,34,52,72,208,218], points := ![83,91,108,117,124,141], inverse := ![0,10,13,4,7,5,5,4,6,3,12,8,10,12,6,12,10,6,0,15,8,4,4,7,11,12,7,13,10,7,6,15,9,5,12,9] } }
theorem leafL_287_0_valid : (leafL_287_0).reject.ValidFor (leafL_287_0).leaf := by decide

noncomputable def leafL_287_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,208,237}, reject := .fullRank { members := ![0,1,17,34,52,72,208,237], points := ![83,90,91,103,107,124], inverse := ![11,7,3,7,15,6,15,9,15,6,8,7,6,3,5,0,0,0,1,8,1,14,1,7,9,14,7,14,14,0,4,12,8,10,10,0] } }
theorem leafL_287_1_valid : (leafL_287_1).reject.ValidFor (leafL_287_1).leaf := by decide

noncomputable def leafL_287_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,208,239}, reject := .fullRank { members := ![0,1,17,34,52,72,208,239], points := ![83,90,94,103,107,117], inverse := ![0,15,0,8,0,6,8,3,2,2,12,7,14,12,2,0,0,0,10,3,1,10,5,7,15,7,8,14,14,0,9,7,14,10,10,0] } }
theorem leafL_287_2_valid : (leafL_287_2).reject.ValidFor (leafL_287_2).leaf := by decide

noncomputable def leafL_287_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,208,263}, reject := .fullRank { members := ![0,1,17,34,52,72,208,263], points := ![90,94,101,108,117,141], inverse := ![7,6,1,7,8,14,1,14,9,1,1,6,2,8,9,3,10,10,5,15,5,8,5,2,3,5,1,7,6,6,8,10,4,6,2,2] } }
theorem leafL_287_3_valid : (leafL_287_3).reject.ValidFor (leafL_287_3).leaf := by decide

noncomputable def leafL_287_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,208,267}, reject := .fullRank { members := ![0,1,17,34,52,72,208,267], points := ![94,101,135,137,141,147], inverse := ![13,3,10,15,4,14,4,15,12,14,1,8,0,0,7,4,3,0,7,1,1,0,8,15,6,2,5,5,13,9,7,12,9,15,14,3] } }
theorem leafL_287_4_valid : (leafL_287_4).reject.ValidFor (leafL_287_4).leaf := by decide

noncomputable def leafL_287_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,213,268}, reject := .fullRank { members := ![0,1,17,34,52,72,213,268], points := ![83,93,103,107,122,125], inverse := ![11,4,12,4,8,14,12,5,2,12,6,1,14,14,13,13,7,7,4,12,3,12,8,15,13,13,6,6,1,1,12,12,3,3,14,14] } }
theorem leafL_287_5_valid : (leafL_287_5).reject.ValidFor (leafL_287_5).leaf := by decide

noncomputable def leafL_287_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,218,233}, reject := .fullRank { members := ![0,1,17,34,52,72,218,233], points := ![91,96,112,117,124,128], inverse := ![5,10,8,14,12,4,0,9,14,0,0,7,0,0,0,14,2,12,8,0,15,11,5,9,14,14,0,12,7,11,12,12,0,7,14,9] } }
theorem leafL_287_6_valid : (leafL_287_6).reject.ValidFor (leafL_287_6).leaf := by decide

noncomputable def leafL_287_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,218,251}, reject := .fullRank { members := ![0,1,17,34,52,72,218,251], points := ![83,96,112,124,128,141], inverse := ![13,10,0,11,5,8,0,9,14,0,7,0,11,15,4,11,15,4,9,14,0,14,6,15,1,4,5,4,1,5,4,5,1,9,8,1] } }
theorem leafL_287_7_valid : (leafL_287_7).reject.ValidFor (leafL_287_7).leaf := by decide

noncomputable def leavesL_287 : List RejectedLeaf := [leafL_287_0,leafL_287_1,leafL_287_2,leafL_287_3,leafL_287_4,leafL_287_5,leafL_287_6,leafL_287_7]

theorem leavesL_287_valid : LeafListValid leavesL_287 := by
  intro x hx
  simp only [leavesL_287, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_287_0_valid
  · exact leafL_287_1_valid
  · exact leafL_287_2_valid
  · exact leafL_287_3_valid
  · exact leafL_287_4_valid
  · exact leafL_287_5_valid
  · exact leafL_287_6_valid
  · exact leafL_287_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
