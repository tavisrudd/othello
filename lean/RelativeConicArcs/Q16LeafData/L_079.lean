import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_079_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,135}, reject := .fullRank { members := ![0,1,17,34,52,69,115,135], points := ![89,90,106,110,150,155], inverse := ![1,7,3,8,4,8,10,0,5,1,1,15,8,8,10,10,5,5,4,15,9,12,0,14,0,0,8,8,13,13,15,15,9,9,2,2] } }
theorem leafL_079_0_valid : (leafL_079_0).reject.ValidFor (leafL_079_0).leaf := by decide

noncomputable def leafL_079_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,138}, reject := .fullRank { members := ![0,1,17,34,52,69,115,138], points := ![91,95,104,107,150,151], inverse := ![15,9,12,7,13,1,13,7,11,15,10,4,14,14,5,5,14,14,4,15,7,2,9,7,14,14,14,14,2,2,10,10,15,15,7,7] } }
theorem leafL_079_1_valid : (leafL_079_1).reject.ValidFor (leafL_079_1).leaf := by decide

noncomputable def leafL_079_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,139}, reject := .fullRank { members := ![0,1,17,34,52,69,115,139], points := ![89,90,93,104,150,159], inverse := ![4,4,6,11,4,8,13,14,9,4,8,6,13,11,6,0,0,0,2,5,12,5,7,9,10,11,1,0,3,3,8,13,5,0,4,4] } }
theorem leafL_079_2_valid : (leafL_079_2).reject.ValidFor (leafL_079_2).leaf := by decide

noncomputable def leafL_079_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,150}, reject := .fullRank { members := ![0,1,17,34,52,69,115,150], points := ![89,90,91,135,138,171], inverse := ![3,12,4,2,0,8,10,12,11,11,10,12,9,14,7,0,0,0,12,10,12,3,14,7,0,4,4,2,2,0,2,6,4,9,9,0] } }
theorem leafL_079_3_valid : (leafL_079_3).reject.ValidFor (leafL_079_3).leaf := by decide

noncomputable def leafL_079_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,155}, reject := .fullRank { members := ![0,1,17,34,52,69,115,155], points := ![89,90,93,104,110,135], inverse := ![5,3,15,7,9,6,2,8,4,15,6,7,13,11,6,0,0,0,6,11,2,12,4,7,3,12,15,5,5,0,7,8,15,12,12,0] } }
theorem leafL_079_4_valid : (leafL_079_4).reject.ValidFor (leafL_079_4).leaf := by decide

noncomputable def leafL_079_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,159}, reject := .fullRank { members := ![0,1,17,34,52,69,115,159], points := ![89,91,104,106,110,135], inverse := ![12,5,6,11,3,6,2,12,8,4,5,7,0,0,7,4,3,0,7,8,8,10,10,7,11,11,10,3,9,0,9,9,1,6,7,0] } }
theorem leafL_079_5_valid : (leafL_079_5).reject.ValidFor (leafL_079_5).leaf := by decide

noncomputable def leafL_079_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,171}, reject := .fullRank { members := ![0,1,17,34,52,69,115,171], points := ![89,106,138,150,156,182], inverse := ![10,13,11,15,0,2,9,8,2,15,1,13,4,15,5,12,0,2,1,1,6,6,2,2,13,11,13,9,3,1,0,5,5,5,0,5] } }
theorem leafL_079_6_valid : (leafL_079_6).reject.ValidFor (leafL_079_6).leaf := by decide

noncomputable def leafL_079_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,172}, reject := .fullRank { members := ![0,1,17,34,52,69,115,172], points := ![93,95,104,106,107,138], inverse := ![9,0,1,11,4,6,6,8,6,0,15,7,0,0,12,1,13,0,1,14,10,7,5,7,11,11,14,11,5,0,9,9,12,15,3,0] } }
theorem leafL_079_7_valid : (leafL_079_7).reject.ValidFor (leafL_079_7).leaf := by decide

noncomputable def leavesL_079 : List RejectedLeaf := [leafL_079_0,leafL_079_1,leafL_079_2,leafL_079_3,leafL_079_4,leafL_079_5,leafL_079_6,leafL_079_7]

theorem leavesL_079_valid : LeafListValid leavesL_079 := by
  intro x hx
  simp only [leavesL_079, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_079_0_valid
  · exact leafL_079_1_valid
  · exact leafL_079_2_valid
  · exact leafL_079_3_valid
  · exact leafL_079_4_valid
  · exact leafL_079_5_valid
  · exact leafL_079_6_valid
  · exact leafL_079_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
