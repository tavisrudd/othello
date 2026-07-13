import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_141_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,96,222}, reject := .fullRank { members := ![0,1,17,34,52,70,96,222], points := ![107,109,115,117,131,137], inverse := ![15,8,12,5,13,2,8,15,9,7,3,10,1,1,2,2,1,1,3,4,3,12,2,10,8,8,5,5,6,6,12,12,12,12,0,0] } }
theorem leafL_141_0_valid : (leafL_141_0).reject.ValidFor (leafL_141_0).leaf := by decide

noncomputable def leafL_141_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,96,237}, reject := .fullRank { members := ![0,1,17,34,52,70,96,237], points := ![107,115,117,122,131,139], inverse := ![7,8,5,4,14,1,7,9,1,6,0,9,0,8,15,7,0,0,7,7,5,13,12,4,0,0,15,15,4,4,0,14,2,12,15,15] } }
theorem leafL_141_1_valid : (leafL_141_1).reject.ValidFor (leafL_141_1).leaf := by decide

noncomputable def leafL_141_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,96,243}, reject := .fullRank { members := ![0,1,17,34,52,70,96,243], points := ![101,107,117,137,140,152], inverse := ![0,5,10,14,13,13,1,4,13,5,0,13,8,1,4,10,9,14,15,3,8,5,2,3,1,5,6,7,12,9,9,7,9,11,9,5] } }
theorem leafL_141_2_valid : (leafL_141_2).reject.ValidFor (leafL_141_2).leaf := by decide

noncomputable def leafL_141_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,96,245}, reject := .fullRank { members := ![0,1,17,34,52,70,96,245], points := ![108,120,122,137,139,147], inverse := ![4,2,0,2,7,2,7,2,12,13,4,0,10,8,7,12,5,12,3,4,13,1,2,9,0,9,9,3,3,0,1,9,1,6,0,15] } }
theorem leafL_141_3_valid : (leafL_141_3).reject.ValidFor (leafL_141_3).leaf := by decide

noncomputable def leafL_141_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,96,247}, reject := .fullRank { members := ![0,1,17,34,52,70,96,247], points := ![107,115,120,126,131,137], inverse := ![7,10,9,10,5,10,7,4,9,3,12,5,0,7,13,10,0,0,7,5,2,8,6,14,0,3,9,10,14,14,0,0,12,12,12,12] } }
theorem leafL_141_4_valid : (leafL_141_4).reject.ValidFor (leafL_141_4).leaf := by decide

noncomputable def leafL_141_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,96,263}, reject := .fullRank { members := ![0,1,17,34,52,70,96,263], points := ![107,108,109,115,117,139], inverse := ![3,14,10,3,10,15,1,1,7,4,10,9,7,6,1,0,0,0,10,2,15,9,6,8,15,7,8,9,9,0,12,0,12,12,12,0] } }
theorem leafL_141_5_valid : (leafL_141_5).reject.ValidFor (leafL_141_5).leaf := by decide

noncomputable def leafL_141_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,96,264}, reject := .fullRank { members := ![0,1,17,34,52,70,96,264], points := ![108,117,122,131,140,151], inverse := ![4,13,15,3,6,2,14,10,0,12,6,14,6,7,2,15,8,4,15,14,13,2,15,1,7,14,3,8,9,11,11,11,12,11,4,3] } }
theorem leafL_141_6_valid : (leafL_141_6).reject.ValidFor (leafL_141_6).leaf := by decide

noncomputable def leafL_141_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,96,269}, reject := .fullRank { members := ![0,1,17,34,52,70,96,269], points := ![107,108,117,126,140,147], inverse := ![0,1,14,2,8,4,11,15,14,11,3,2,10,6,14,4,14,8,12,2,8,3,11,14,10,11,0,8,6,15,11,13,8,13,7,4] } }
theorem leafL_141_7_valid : (leafL_141_7).reject.ValidFor (leafL_141_7).leaf := by decide

noncomputable def leavesL_141 : List RejectedLeaf := [leafL_141_0,leafL_141_1,leafL_141_2,leafL_141_3,leafL_141_4,leafL_141_5,leafL_141_6,leafL_141_7]

theorem leavesL_141_valid : LeafListValid leavesL_141 := by
  intro x hx
  simp only [leavesL_141, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_141_0_valid
  · exact leafL_141_1_valid
  · exact leafL_141_2_valid
  · exact leafL_141_3_valid
  · exact leafL_141_4_valid
  · exact leafL_141_5_valid
  · exact leafL_141_6_valid
  · exact leafL_141_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
