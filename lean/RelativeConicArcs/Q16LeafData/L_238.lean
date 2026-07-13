import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_238_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,205,268}, reject := .fullRank { members := ![0,1,17,34,52,71,205,268], points := ![90,101,104,122,126,127], inverse := ![15,9,1,9,1,14,9,8,6,2,9,12,0,0,0,8,10,2,8,15,0,13,13,7,0,15,15,11,12,7,0,11,11,0,11,11] } }
theorem leafL_238_0_valid : (leafL_238_0).reject.ValidFor (leafL_238_0).leaf := by decide

noncomputable def leafL_238_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,208,214}, reject := .fullRank { members := ![0,1,17,34,52,71,208,214], points := ![90,94,109,133,147,155], inverse := ![13,8,10,15,10,11,3,6,1,6,0,2,14,8,2,13,12,5,4,3,1,9,9,6,7,7,0,0,5,5,5,3,2,13,0,9] } }
theorem leafL_238_1_valid : (leafL_238_1).reject.ValidFor (leafL_238_1).leaf := by decide

noncomputable def leafL_238_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,208,218}, reject := .fullRank { members := ![0,1,17,34,52,71,208,218], points := ![83,94,109,121,124,133], inverse := ![5,2,0,10,4,8,9,4,10,4,7,4,11,5,14,9,7,14,4,8,11,6,5,4,1,12,13,13,0,13,11,9,2,4,6,2] } }
theorem leafL_238_2_valid : (leafL_238_2).reject.ValidFor (leafL_238_2).leaf := by decide

noncomputable def leafL_238_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,208,232}, reject := .fullRank { members := ![0,1,17,34,52,71,208,232], points := ![83,94,106,126,133,138], inverse := ![12,14,5,11,12,1,9,1,15,6,12,13,4,5,1,1,2,3,1,12,10,2,11,14,1,7,6,6,13,11,0,15,15,15,0,15] } }
theorem leafL_238_3_valid : (leafL_238_3).reject.ValidFor (leafL_238_3).leaf := by decide

noncomputable def leafL_238_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,208,237}, reject := .fullRank { members := ![0,1,17,34,52,71,208,237], points := ![83,90,94,106,121,124], inverse := ![13,8,10,8,10,12,11,13,15,14,11,12,14,12,2,0,0,0,8,11,11,15,1,6,6,5,3,0,15,15,6,14,8,0,7,7] } }
theorem leafL_238_4_valid : (leafL_238_4).reject.ValidFor (leafL_238_4).leaf := by decide

noncomputable def leafL_238_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,208,267}, reject := .fullRank { members := ![0,1,17,34,52,71,208,267], points := ![94,106,121,133,141,147], inverse := ![10,7,12,10,6,12,4,11,6,0,8,1,9,1,5,6,10,1,9,8,3,4,2,4,11,7,1,10,15,8,4,4,4,0,4,0] } }
theorem leafL_238_5_valid : (leafL_238_5).reject.ValidFor (leafL_238_5).leaf := by decide

noncomputable def leafL_238_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,213,239}, reject := .fullRank { members := ![0,1,17,34,52,71,213,239], points := ![91,93,99,104,126,128], inverse := ![8,7,2,10,7,1,0,9,7,9,13,10,13,13,11,11,13,13,5,13,0,15,10,13,3,3,8,8,11,11,3,3,5,5,4,4] } }
theorem leafL_238_6_valid : (leafL_238_6).reject.ValidFor (leafL_238_6).leaf := by decide

noncomputable def leafL_238_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,213,240}, reject := .fullRank { members := ![0,1,17,34,52,71,213,240], points := ![99,104,110,124,127,131], inverse := ![8,4,11,0,9,15,9,9,7,10,4,9,7,13,10,0,0,0,11,2,14,4,11,8,13,9,4,14,14,0,8,8,0,8,8,0] } }
theorem leafL_238_7_valid : (leafL_238_7).reject.ValidFor (leafL_238_7).leaf := by decide

noncomputable def leavesL_238 : List RejectedLeaf := [leafL_238_0,leafL_238_1,leafL_238_2,leafL_238_3,leafL_238_4,leafL_238_5,leafL_238_6,leafL_238_7]

theorem leavesL_238_valid : LeafListValid leavesL_238 := by
  intro x hx
  simp only [leavesL_238, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_238_0_valid
  · exact leafL_238_1_valid
  · exact leafL_238_2_valid
  · exact leafL_238_3_valid
  · exact leafL_238_4_valid
  · exact leafL_238_5_valid
  · exact leafL_238_6_valid
  · exact leafL_238_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
