import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_148_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,117,205}, reject := .fullRank { members := ![0,1,17,34,52,70,117,205], points := ![91,96,135,147,167,172], inverse := ![15,6,13,12,15,6,15,5,13,1,9,15,8,3,8,15,6,10,1,3,4,5,15,12,12,4,9,5,14,10,15,0,5,4,4,10] } }
theorem leafL_148_0_valid : (leafL_148_0).reject.ValidFor (leafL_148_0).leaf := by decide

noncomputable def leafL_148_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,117,211}, reject := .fullRank { members := ![0,1,17,34,52,70,117,211], points := ![91,104,109,137,151,154], inverse := ![15,9,5,11,14,7,9,10,15,15,13,14,7,13,1,8,9,10,0,8,5,1,15,3,15,12,9,6,15,3,9,3,4,11,14,11] } }
theorem leafL_148_1_valid : (leafL_148_1).reject.ValidFor (leafL_148_1).leaf := by decide

noncomputable def leafL_148_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,117,220}, reject := .fullRank { members := ![0,1,17,34,52,70,117,220], points := ![91,110,135,137,139,147], inverse := ![1,7,2,3,9,15,9,5,3,2,14,3,0,0,13,8,5,0,12,9,4,15,3,13,7,12,11,11,8,3,1,14,12,6,15,10] } }
theorem leafL_148_2_valid : (leafL_148_2).reject.ValidFor (leafL_148_2).leaf := by decide

noncomputable def leafL_148_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,117,237}, reject := .fullRank { members := ![0,1,17,34,52,70,117,237], points := ![83,91,96,104,110,131], inverse := ![6,6,9,3,13,6,6,5,13,4,13,7,9,3,10,0,0,0,11,14,10,7,15,7,6,6,0,5,5,0,14,9,7,12,12,0] } }
theorem leafL_148_3_valid : (leafL_148_3).reject.ValidFor (leafL_148_3).leaf := by decide

noncomputable def leafL_148_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,117,239}, reject := .fullRank { members := ![0,1,17,34,52,70,117,239], points := ![83,91,131,135,139,151], inverse := ![9,1,3,14,14,10,5,3,5,15,3,15,0,0,7,11,12,0,11,15,11,2,15,2,8,8,10,7,13,0,5,5,5,0,5,0] } }
theorem leafL_148_4_valid : (leafL_148_4).reject.ValidFor (leafL_148_4).leaf := by decide

noncomputable def leafL_148_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,117,240}, reject := .fullRank { members := ![0,1,17,34,52,70,117,240], points := ![89,109,131,137,141,151], inverse := ![10,15,14,9,14,13,13,8,13,0,5,13,0,0,7,3,4,0,12,9,13,1,4,13,15,5,3,2,7,12,4,13,14,10,3,14] } }
theorem leafL_148_5_valid : (leafL_148_5).reject.ValidFor (leafL_148_5).leaf := by decide

noncomputable def leafL_148_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,117,269}, reject := .fullRank { members := ![0,1,17,34,52,70,117,269], points := ![89,91,96,104,110,135], inverse := ![6,11,4,7,9,6,1,0,15,15,6,7,3,12,15,0,0,0,9,5,3,12,4,7,7,14,9,5,5,0,2,3,1,12,12,0] } }
theorem leafL_148_6_valid : (leafL_148_6).reject.ValidFor (leafL_148_6).leaf := by decide

noncomputable def leafL_148_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,117,270}, reject := .fullRank { members := ![0,1,17,34,52,70,117,270], points := ![83,91,96,109,131,135], inverse := ![10,13,14,14,11,13,10,2,6,9,4,3,9,3,10,0,0,0,13,7,5,8,5,2,4,6,2,0,14,14,7,9,14,0,10,10] } }
theorem leafL_148_7_valid : (leafL_148_7).reject.ValidFor (leafL_148_7).leaf := by decide

noncomputable def leavesL_148 : List RejectedLeaf := [leafL_148_0,leafL_148_1,leafL_148_2,leafL_148_3,leafL_148_4,leafL_148_5,leafL_148_6,leafL_148_7]

theorem leavesL_148_valid : LeafListValid leavesL_148 := by
  intro x hx
  simp only [leavesL_148, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_148_0_valid
  · exact leafL_148_1_valid
  · exact leafL_148_2_valid
  · exact leafL_148_3_valid
  · exact leafL_148_4_valid
  · exact leafL_148_5_valid
  · exact leafL_148_6_valid
  · exact leafL_148_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
