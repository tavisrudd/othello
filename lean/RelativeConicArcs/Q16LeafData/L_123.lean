import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_123_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,208}, reject := .fullRank { members := ![0,1,17,34,52,70,89,208], points := ![103,115,117,126,135,140], inverse := ![7,0,9,0,0,15,7,4,2,8,9,0,0,13,14,3,0,0,7,14,0,1,3,11,0,9,1,8,11,11,0,1,15,14,4,4] } }
theorem leafL_123_0_valid : (leafL_123_0).reject.ValidFor (leafL_123_0).leaf := by decide

noncomputable def leafL_123_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,222}, reject := .fullRank { members := ![0,1,17,34,52,70,89,222], points := ![104,115,127,139,140,149], inverse := ![6,7,6,8,1,15,7,3,13,6,15,0,6,13,8,6,1,4,15,11,8,5,8,1,11,2,5,13,2,3,8,4,8,9,12,1] } }
theorem leafL_123_1_valid : (leafL_123_1).reject.ValidFor (leafL_123_1).leaf := by decide

noncomputable def leafL_123_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,231}, reject := .fullRank { members := ![0,1,17,34,52,70,89,231], points := ![108,115,117,122,141,159], inverse := ![10,10,8,9,7,7,1,15,1,5,14,4,0,8,15,7,0,0,5,14,0,2,4,13,2,6,11,14,12,13,14,15,13,11,2,5] } }
theorem leafL_123_2_valid : (leafL_123_2).reject.ValidFor (leafL_123_2).leaf := by decide

noncomputable def leafL_123_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,240}, reject := .fullRank { members := ![0,1,17,34,52,70,89,240], points := ![104,115,117,127,131,140], inverse := ![7,7,6,8,1,14,7,12,10,8,12,5,0,3,2,1,0,0,7,7,13,5,9,1,0,0,2,2,12,12,0,5,10,15,2,2] } }
theorem leafL_123_3_valid : (leafL_123_3).reject.ValidFor (leafL_123_3).leaf := by decide

noncomputable def leafL_123_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,243}, reject := .fullRank { members := ![0,1,17,34,52,70,89,243], points := ![103,104,117,122,127,135], inverse := ![11,12,5,9,5,15,7,0,3,11,6,9,0,0,5,11,14,0,5,2,15,4,4,8,2,2,1,3,2,0,14,14,10,7,13,0] } }
theorem leafL_123_4_valid : (leafL_123_4).reject.ValidFor (leafL_123_4).leaf := by decide

noncomputable def leafL_123_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,245}, reject := .fullRank { members := ![0,1,17,34,52,70,89,245], points := ![103,108,110,120,122,140], inverse := ![9,13,3,2,11,15,13,6,12,2,12,9,7,15,8,0,0,0,11,0,12,15,0,8,5,9,12,5,5,0,10,2,8,1,1,0] } }
theorem leafL_123_5_valid : (leafL_123_5).reject.ValidFor (leafL_123_5).leaf := by decide

noncomputable def leafL_123_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,251}, reject := .fullRank { members := ![0,1,17,34,52,70,89,251], points := ![104,110,115,122,131,140], inverse := ![5,2,6,15,0,15,3,4,7,9,14,7,14,14,9,9,7,7,14,9,14,1,4,12,12,12,2,2,10,10,15,15,4,4,12,12] } }
theorem leafL_123_6_valid : (leafL_123_6).reject.ValidFor (leafL_123_6).leaf := by decide

noncomputable def leafL_123_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,263}, reject := .fullRank { members := ![0,1,17,34,52,70,89,263], points := ![104,115,117,120,139,141], inverse := ![7,13,6,2,14,1,7,12,7,5,2,11,0,4,12,8,0,0,7,1,15,1,0,8,0,13,8,5,1,1,0,7,7,0,7,7] } }
theorem leafL_123_7_valid : (leafL_123_7).reject.ValidFor (leafL_123_7).leaf := by decide

noncomputable def leavesL_123 : List RejectedLeaf := [leafL_123_0,leafL_123_1,leafL_123_2,leafL_123_3,leafL_123_4,leafL_123_5,leafL_123_6,leafL_123_7]

theorem leavesL_123_valid : LeafListValid leavesL_123 := by
  intro x hx
  simp only [leavesL_123, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_123_0_valid
  · exact leafL_123_1_valid
  · exact leafL_123_2_valid
  · exact leafL_123_3_valid
  · exact leafL_123_4_valid
  · exact leafL_123_5_valid
  · exact leafL_123_6_valid
  · exact leafL_123_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
