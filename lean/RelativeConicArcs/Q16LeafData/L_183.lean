import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_183_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,106,197}, reject := .fullRank { members := ![0,1,17,34,52,71,106,197], points := ![93,121,126,139,140,144], inverse := ![7,13,3,11,1,2,7,12,5,1,1,14,0,0,0,11,13,6,7,10,2,10,11,14,0,4,4,14,12,2,0,11,11,11,0,11] } }
theorem leafL_183_0_valid : (leafL_183_0).reject.ValidFor (leafL_183_0).leaf := by decide

noncomputable def leafL_183_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,106,203}, reject := .fullRank { members := ![0,1,17,34,52,71,106,203], points := ![96,126,133,140,147,156], inverse := ![0,4,8,6,2,9,13,12,2,15,4,8,13,15,12,9,9,14,10,7,12,6,14,9,5,11,8,0,3,5,12,6,5,7,8,0] } }
theorem leafL_183_1_valid : (leafL_183_1).reject.ValidFor (leafL_183_1).leaf := by decide

noncomputable def leafL_183_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,106,205}, reject := .fullRank { members := ![0,1,17,34,52,71,106,205], points := ![91,94,96,126,147,150], inverse := ![6,7,3,5,4,2,7,1,3,8,12,1,15,3,12,0,0,0,1,4,6,10,4,13,15,13,2,0,2,2,9,9,0,0,9,9] } }
theorem leafL_183_2_valid : (leafL_183_2).reject.ValidFor (leafL_183_2).leaf := by decide

noncomputable def leafL_183_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,106,208}, reject := .fullRank { members := ![0,1,17,34,52,71,106,208], points := ![94,121,124,126,133,156], inverse := ![9,7,3,13,4,5,6,13,8,5,9,15,0,8,12,4,0,0,13,6,8,3,12,12,7,6,0,12,6,11,6,9,10,0,1,4] } }
theorem leafL_183_3_valid : (leafL_183_3).reject.ValidFor (leafL_183_3).leaf := by decide

noncomputable def leafL_183_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,106,216}, reject := .fullRank { members := ![0,1,17,34,52,71,106,216], points := ![91,96,126,140,144,150], inverse := ![14,11,15,11,13,13,7,7,3,3,11,11,10,1,12,9,13,3,12,3,12,2,0,1,2,5,10,10,12,11,14,6,4,13,0,1] } }
theorem leafL_183_4_valid : (leafL_183_4).reject.ValidFor (leafL_183_4).leaf := by decide

noncomputable def leafL_183_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,106,222}, reject := .fullRank { members := ![0,1,17,34,52,71,106,222], points := ![93,96,121,124,140,144], inverse := ![2,5,4,10,2,10,14,9,14,7,9,7,1,1,3,3,8,8,10,13,10,2,8,7,2,2,10,10,11,11,7,7,7,7,0,0] } }
theorem leafL_183_5_valid : (leafL_183_5).reject.ValidFor (leafL_183_5).leaf := by decide

noncomputable def leafL_183_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,106,233}, reject := .fullRank { members := ![0,1,17,34,52,71,106,233], points := ![91,93,94,126,139,144], inverse := ![7,5,5,14,6,14,11,4,8,9,3,13,1,7,6,0,0,0,11,14,2,8,4,11,0,12,12,0,6,6,13,11,6,0,8,8] } }
theorem leafL_183_6_valid : (leafL_183_6).reject.ValidFor (leafL_183_6).leaf := by decide

noncomputable def leafL_183_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,106,240}, reject := .fullRank { members := ![0,1,17,34,52,71,106,240], points := ![124,133,140,150,158,159], inverse := ![4,2,12,12,6,1,3,0,8,7,3,15,0,0,0,6,5,3,2,13,4,11,5,5,0,10,10,14,3,13,0,12,12,9,13,4] } }
theorem leafL_183_7_valid : (leafL_183_7).reject.ValidFor (leafL_183_7).leaf := by decide

noncomputable def leavesL_183 : List RejectedLeaf := [leafL_183_0,leafL_183_1,leafL_183_2,leafL_183_3,leafL_183_4,leafL_183_5,leafL_183_6,leafL_183_7]

theorem leavesL_183_valid : LeafListValid leavesL_183 := by
  intro x hx
  simp only [leavesL_183, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_183_0_valid
  · exact leafL_183_1_valid
  · exact leafL_183_2_valid
  · exact leafL_183_3_valid
  · exact leafL_183_4_valid
  · exact leafL_183_5_valid
  · exact leafL_183_6_valid
  · exact leafL_183_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
