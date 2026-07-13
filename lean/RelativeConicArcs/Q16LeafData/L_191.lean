import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_191_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,120,185}, reject := .fullRank { members := ![0,1,17,34,52,71,120,185], points := ![91,96,109,131,133,138], inverse := ![4,13,14,15,1,8,11,5,9,15,10,2,0,0,0,8,15,7,15,0,8,5,1,3,13,13,0,13,10,7,8,8,0,4,3,7] } }
theorem leafL_191_0_valid : (leafL_191_0).reject.ValidFor (leafL_191_0).leaf := by decide

noncomputable def leafL_191_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,120,191}, reject := .fullRank { members := ![0,1,17,34,52,71,120,191], points := ![91,99,133,138,155,158], inverse := ![10,15,10,3,8,5,15,7,9,11,1,11,1,14,13,8,15,5,14,6,12,14,10,0,6,2,13,0,12,5,15,5,1,7,15,3] } }
theorem leafL_191_1_valid : (leafL_191_1).reject.ValidFor (leafL_191_1).leaf := by decide

noncomputable def leafL_191_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,120,197}, reject := .fullRank { members := ![0,1,17,34,52,71,120,197], points := ![94,99,109,138,139,144], inverse := ![9,15,1,15,8,1,14,8,1,11,11,7,0,0,0,12,8,4,15,9,1,4,2,1,0,13,13,2,4,6,0,8,8,15,6,9] } }
theorem leafL_191_2_valid : (leafL_191_2).reject.ValidFor (leafL_191_2).leaf := by decide

noncomputable def leafL_191_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,120,205}, reject := .fullRank { members := ![0,1,17,34,52,71,120,205], points := ![91,94,96,99,131,133], inverse := ![1,9,1,14,12,10,8,2,4,9,7,0,15,3,12,0,0,0,13,2,0,8,12,11,2,3,1,0,5,5,7,3,4,0,12,12] } }
theorem leafL_191_3_valid : (leafL_191_3).reject.ValidFor (leafL_191_3).leaf := by decide

noncomputable def leafL_191_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,120,218}, reject := .fullRank { members := ![0,1,17,34,52,71,120,218], points := ![91,94,109,133,139,140], inverse := ![7,14,14,5,4,7,2,12,9,1,9,15,0,0,0,11,3,8,15,0,8,7,9,9,14,14,0,3,15,12,2,2,0,5,8,13] } }
theorem leafL_191_4_valid : (leafL_191_4).reject.ValidFor (leafL_191_4).leaf := by decide

noncomputable def leafL_191_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,120,235}, reject := .fullRank { members := ![0,1,17,34,52,71,120,235], points := ![96,99,131,144,159,172], inverse := ![0,13,0,0,10,6,2,1,0,10,3,10,0,1,5,11,7,8,14,7,13,1,13,8,8,12,6,11,7,14,5,6,2,3,12,14] } }
theorem leafL_191_5_valid : (leafL_191_5).reject.ValidFor (leafL_191_5).leaf := by decide

noncomputable def leafL_191_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,120,240}, reject := .fullRank { members := ![0,1,17,34,52,71,120,240], points := ![94,99,109,131,133,140], inverse := ![9,15,1,10,6,10,14,8,1,12,13,6,0,0,0,14,13,3,15,9,1,12,12,7,0,13,13,3,11,8,0,8,8,7,11,12] } }
theorem leafL_191_6_valid : (leafL_191_6).reject.ValidFor (leafL_191_6).leaf := by decide

noncomputable def leafL_191_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,120,245}, reject := .fullRank { members := ![0,1,17,34,52,71,120,245], points := ![91,93,94,99,138,139], inverse := ![13,0,4,14,4,2,5,13,6,9,10,13,1,7,6,0,0,0,13,0,2,8,15,8,8,1,9,0,10,10,15,5,10,0,11,11] } }
theorem leafL_191_7_valid : (leafL_191_7).reject.ValidFor (leafL_191_7).leaf := by decide

noncomputable def leavesL_191 : List RejectedLeaf := [leafL_191_0,leafL_191_1,leafL_191_2,leafL_191_3,leafL_191_4,leafL_191_5,leafL_191_6,leafL_191_7]

theorem leavesL_191_valid : LeafListValid leavesL_191 := by
  intro x hx
  simp only [leavesL_191, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_191_0_valid
  · exact leafL_191_1_valid
  · exact leafL_191_2_valid
  · exact leafL_191_3_valid
  · exact leafL_191_4_valid
  · exact leafL_191_5_valid
  · exact leafL_191_6_valid
  · exact leafL_191_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
