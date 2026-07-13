import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_124_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,264}, reject := .fullRank { members := ![0,1,17,34,52,70,89,264], points := ![103,108,110,122,127,135], inverse := ![14,0,9,2,11,15,11,5,9,3,13,9,7,15,8,0,0,0,2,9,12,10,5,8,8,8,0,10,10,0,12,9,5,2,2,0] } }
theorem leafL_124_0_valid : (leafL_124_0).reject.ValidFor (leafL_124_0).leaf := by decide

noncomputable def leafL_124_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,266}, reject := .fullRank { members := ![0,1,17,34,52,70,89,266], points := ![103,117,120,126,131,135], inverse := ![7,5,14,2,5,10,7,1,12,3,0,9,0,15,4,11,0,0,7,15,13,13,8,0,0,1,4,5,8,8,0,5,1,4,13,13] } }
theorem leafL_124_1_valid : (leafL_124_1).reject.ValidFor (leafL_124_1).leaf := by decide

noncomputable def leafL_124_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,267}, reject := .fullRank { members := ![0,1,17,34,52,70,89,267], points := ![104,115,120,122,131,135], inverse := ![7,6,1,14,10,5,7,11,6,3,15,6,0,1,14,15,0,0,7,13,12,14,7,15,0,7,5,2,8,8,0,10,5,15,13,13] } }
theorem leafL_124_2_valid : (leafL_124_2).reject.ValidFor (leafL_124_2).leaf := by decide

noncomputable def leafL_124_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,269}, reject := .fullRank { members := ![0,1,17,34,52,70,89,269], points := ![103,104,108,115,117,135], inverse := ![0,5,2,4,13,15,5,5,7,11,5,9,4,10,14,0,0,0,12,14,5,11,4,8,4,13,9,9,9,0,11,15,4,12,12,0] } }
theorem leafL_124_3_valid : (leafL_124_3).reject.ValidFor (leafL_124_3).leaf := by decide

noncomputable def leafL_124_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,110}, reject := .fullRank { members := ![0,1,17,34,52,70,90,110], points := ![115,125,127,131,135,147], inverse := ![14,14,4,13,3,11,3,0,0,8,0,11,13,8,5,0,0,0,1,11,8,0,9,11,12,4,8,8,8,0,8,12,4,13,13,0] } }
theorem leafL_124_4_valid : (leafL_124_4).reject.ValidFor (leafL_124_4).leaf := by decide

noncomputable def leafL_124_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,125}, reject := .fullRank { members := ![0,1,17,34,52,70,90,125], points := ![101,110,131,135,139,147], inverse := ![1,8,5,5,13,5,9,11,9,7,10,6,0,0,7,11,12,0,12,1,14,0,15,12,7,7,13,5,8,0,1,1,4,12,8,0] } }
theorem leafL_124_5_valid : (leafL_124_5).reject.ValidFor (leafL_124_5).leaf := by decide

noncomputable def leafL_124_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,126}, reject := .fullRank { members := ![0,1,17,34,52,70,90,126], points := ![131,133,135,149,152,168], inverse := ![0,4,14,3,12,4,3,10,2,0,8,3,5,10,15,0,0,0,15,14,10,10,3,2,6,10,12,10,10,0,14,11,5,9,9,0] } }
theorem leafL_124_6_valid : (leafL_124_6).reject.ValidFor (leafL_124_6).leaf := by decide

noncomputable def leafL_124_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,127}, reject := .fullRank { members := ![0,1,17,34,52,70,90,127], points := ![101,108,109,135,144,147], inverse := ![14,3,4,5,8,5,10,0,8,2,6,6,1,5,4,0,0,0,10,11,12,11,10,12,15,15,0,5,5,0,7,11,12,1,1,0] } }
theorem leafL_124_7_valid : (leafL_124_7).reject.ValidFor (leafL_124_7).leaf := by decide

noncomputable def leavesL_124 : List RejectedLeaf := [leafL_124_0,leafL_124_1,leafL_124_2,leafL_124_3,leafL_124_4,leafL_124_5,leafL_124_6,leafL_124_7]

theorem leavesL_124_valid : LeafListValid leavesL_124 := by
  intro x hx
  simp only [leavesL_124, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_124_0_valid
  · exact leafL_124_1_valid
  · exact leafL_124_2_valid
  · exact leafL_124_3_valid
  · exact leafL_124_4_valid
  · exact leafL_124_5_valid
  · exact leafL_124_6_valid
  · exact leafL_124_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
