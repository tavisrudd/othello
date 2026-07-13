import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_113_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,166,211}, reject := .fullRank { members := ![0,1,17,34,52,69,166,211], points := ![94,104,110,112,120,127], inverse := ![15,14,8,14,15,9,9,14,3,3,1,6,0,8,6,14,0,0,8,13,11,9,6,1,0,10,15,5,6,6,0,12,2,14,15,15] } }
theorem leafL_113_0_valid : (leafL_113_0).reject.ValidFor (leafL_113_0).leaf := by decide

noncomputable def leafL_113_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,166,217}, reject := .fullRank { members := ![0,1,17,34,52,69,166,217], points := ![93,96,99,104,120,135], inverse := ![7,8,3,11,6,0,9,15,5,4,8,15,5,13,9,1,8,8,1,3,2,7,13,10,13,1,14,2,12,12,3,6,8,13,5,5] } }
theorem leafL_113_1_valid : (leafL_113_1).reject.ValidFor (leafL_113_1).leaf := by decide

noncomputable def leafL_113_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,166,222}, reject := .fullRank { members := ![0,1,17,34,52,69,166,222], points := ![89,90,93,99,106,137], inverse := ![1,7,15,14,0,6,2,1,13,11,2,7,13,11,6,0,0,0,7,8,0,0,8,7,2,6,4,7,7,0,10,3,9,5,5,0] } }
theorem leafL_113_2_valid : (leafL_113_2).reject.ValidFor (leafL_113_2).leaf := by decide

noncomputable def leafL_113_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,166,240}, reject := .fullRank { members := ![0,1,17,34,52,69,166,240], points := ![90,94,99,104,106,127], inverse := ![13,2,12,4,0,6,2,11,11,15,10,7,0,0,1,14,15,0,12,4,14,4,5,7,12,12,10,10,0,0,13,13,10,5,15,0] } }
theorem leafL_113_3_valid : (leafL_113_3).reject.ValidFor (leafL_113_3).leaf := by decide

noncomputable def leafL_113_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,166,249}, reject := .fullRank { members := ![0,1,17,34,52,69,166,249], points := ![90,94,104,120,135,151], inverse := ![1,2,0,12,7,9,3,14,12,6,3,4,5,8,15,14,1,13,3,14,14,4,14,9,5,8,13,13,13,0,7,4,1,0,15,13] } }
theorem leafL_113_4_valid : (leafL_113_4).reject.ValidFor (leafL_113_4).leaf := by decide

noncomputable def leafL_113_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,166,259}, reject := .fullRank { members := ![0,1,17,34,52,69,166,259], points := ![90,96,106,110,120,127], inverse := ![1,14,11,3,12,10,12,5,11,5,11,12,11,11,11,11,10,10,12,4,14,1,1,6,0,0,9,9,6,6,2,2,8,8,7,7] } }
theorem leafL_113_5_valid : (leafL_113_5).reject.ValidFor (leafL_113_5).leaf := by decide

noncomputable def leafL_113_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,171,186}, reject := .fullRank { members := ![0,1,17,34,52,69,171,186], points := ![86,89,99,115,124,127], inverse := ![14,1,8,12,1,11,7,14,14,10,14,3,0,0,0,7,5,2,13,5,15,14,4,13,12,12,0,12,6,10,2,2,0,15,11,4] } }
theorem leafL_113_6_valid : (leafL_113_6).reject.ValidFor (leafL_113_6).leaf := by decide

noncomputable def leafL_113_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,171,207}, reject := .fullRank { members := ![0,1,17,34,52,69,171,207], points := ![86,89,90,99,103,115], inverse := ![3,14,2,10,2,6,14,8,15,14,0,7,14,4,10,0,0,0,7,7,8,6,9,7,2,14,12,1,1,0,3,6,5,13,13,0] } }
theorem leafL_113_7_valid : (leafL_113_7).reject.ValidFor (leafL_113_7).leaf := by decide

noncomputable def leavesL_113 : List RejectedLeaf := [leafL_113_0,leafL_113_1,leafL_113_2,leafL_113_3,leafL_113_4,leafL_113_5,leafL_113_6,leafL_113_7]

theorem leavesL_113_valid : LeafListValid leavesL_113 := by
  intro x hx
  simp only [leavesL_113, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_113_0_valid
  · exact leafL_113_1_valid
  · exact leafL_113_2_valid
  · exact leafL_113_3_valid
  · exact leafL_113_4_valid
  · exact leafL_113_5_valid
  · exact leafL_113_6_valid
  · exact leafL_113_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
