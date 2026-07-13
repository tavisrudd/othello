import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_147_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,117,137}, reject := .fullRank { members := ![0,1,17,34,52,70,117,137], points := ![83,91,109,110,147,154], inverse := ![2,4,2,9,14,2,5,15,12,8,9,7,4,4,13,13,1,1,10,1,0,5,13,3,8,8,15,15,10,10,13,13,14,14,9,9] } }
theorem leafL_147_0_valid : (leafL_147_0).reject.ValidFor (leafL_147_0).leaf := by decide

noncomputable def leafL_147_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,117,147}, reject := .fullRank { members := ![0,1,17,34,52,70,117,147], points := ![91,96,104,110,137,141], inverse := ![15,6,14,0,11,13,6,8,7,14,8,15,3,3,12,12,10,10,13,2,2,10,13,10,6,6,10,10,1,1,9,9,4,4,12,12] } }
theorem leafL_147_1_valid : (leafL_147_1).reject.ValidFor (leafL_147_1).leaf := by decide

noncomputable def leafL_147_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,117,158}, reject := .fullRank { members := ![0,1,17,34,52,70,117,158], points := ![83,91,131,139,172,176], inverse := ![0,11,10,8,6,14,15,2,9,8,3,15,13,13,1,1,11,11,6,12,12,1,5,2,10,10,15,15,7,7,5,5,5,5,0,0] } }
theorem leafL_147_2_valid : (leafL_147_2).reject.ValidFor (leafL_147_2).leaf := by decide

noncomputable def leafL_147_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,117,171}, reject := .fullRank { members := ![0,1,17,34,52,70,117,171], points := ![83,137,141,151,185,188], inverse := ![13,2,0,13,4,7,0,15,9,4,7,5,1,4,15,4,5,11,1,15,8,5,6,5,15,3,0,9,3,6,15,8,11,9,11,14] } }
theorem leafL_147_3_valid : (leafL_147_3).reject.ValidFor (leafL_147_3).leaf := by decide

noncomputable def leafL_147_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,117,174}, reject := .fullRank { members := ![0,1,17,34,52,70,117,174], points := ![89,91,131,135,137,147], inverse := ![10,2,10,7,14,10,11,13,5,3,15,15,0,0,3,4,7,0,13,9,5,6,5,2,6,6,3,0,3,0,7,7,12,2,14,0] } }
theorem leafL_147_4_valid : (leafL_147_4).reject.ValidFor (leafL_147_4).leaf := by decide

noncomputable def leafL_147_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,117,185}, reject := .fullRank { members := ![0,1,17,34,52,70,117,185], points := ![83,91,109,110,131,135], inverse := ![5,12,13,3,6,0,6,8,4,13,15,8,14,14,4,4,14,14,7,8,10,2,2,5,0,0,10,10,6,6,8,8,3,3,7,7] } }
theorem leafL_147_5_valid : (leafL_147_5).reject.ValidFor (leafL_147_5).leaf := by decide

noncomputable def leafL_147_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,117,188}, reject := .fullRank { members := ![0,1,17,34,52,70,117,188], points := ![83,89,91,104,110,131], inverse := ![0,7,14,3,13,6,5,10,1,4,13,7,8,6,14,0,0,0,10,6,3,7,15,7,6,0,6,5,5,0,12,12,0,12,12,0] } }
theorem leafL_147_6_valid : (leafL_147_6).reject.ValidFor (leafL_147_6).leaf := by decide

noncomputable def leafL_147_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,117,202}, reject := .fullRank { members := ![0,1,17,34,52,70,117,202], points := ![96,109,110,131,135,139], inverse := ![9,3,13,2,11,15,14,1,8,6,11,10,0,0,0,7,11,12,15,13,5,4,0,3,0,10,10,6,6,0,0,9,9,11,6,13] } }
theorem leafL_147_7_valid : (leafL_147_7).reject.ValidFor (leafL_147_7).leaf := by decide

noncomputable def leavesL_147 : List RejectedLeaf := [leafL_147_0,leafL_147_1,leafL_147_2,leafL_147_3,leafL_147_4,leafL_147_5,leafL_147_6,leafL_147_7]

theorem leavesL_147_valid : LeafListValid leavesL_147 := by
  intro x hx
  simp only [leavesL_147, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_147_0_valid
  · exact leafL_147_1_valid
  · exact leafL_147_2_valid
  · exact leafL_147_3_valid
  · exact leafL_147_4_valid
  · exact leafL_147_5_valid
  · exact leafL_147_6_valid
  · exact leafL_147_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
