import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_081_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,217}, reject := .fullRank { members := ![0,1,17,34,52,69,115,217], points := ![91,93,95,104,107,135], inverse := ![10,10,9,9,7,6,15,0,1,11,2,7,5,10,15,0,0,0,7,4,12,5,13,7,1,9,8,3,3,0,6,5,3,4,4,0] } }
theorem leafL_081_0_valid : (leafL_081_0).reject.ValidFor (leafL_081_0).leaf := by decide

noncomputable def leafL_081_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,222}, reject := .fullRank { members := ![0,1,17,34,52,69,115,222], points := ![89,90,93,104,107,138], inverse := ![6,9,6,12,2,6,15,2,3,6,15,7,13,11,6,0,0,0,3,14,2,8,0,7,4,15,11,3,3,0,2,12,14,4,4,0] } }
theorem leafL_081_1_valid : (leafL_081_1).reject.ValidFor (leafL_081_1).leaf := by decide

noncomputable def leafL_081_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,230}, reject := .fullRank { members := ![0,1,17,34,52,69,115,230], points := ![89,90,91,104,107,138], inverse := ![2,12,7,12,2,6,13,9,10,6,15,7,9,14,7,0,0,0,14,13,12,8,0,7,7,8,15,3,3,0,7,5,2,4,4,0] } }
theorem leafL_081_2_valid : (leafL_081_2).reject.ValidFor (leafL_081_2).leaf := by decide

noncomputable def leafL_081_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,232}, reject := .fullRank { members := ![0,1,17,34,52,69,115,232], points := ![89,95,107,110,135,138], inverse := ![15,6,6,8,7,1,12,2,6,15,8,15,4,4,1,1,10,10,8,7,12,4,15,8,0,0,9,9,7,7,3,3,7,7,10,10] } }
theorem leafL_081_3_valid : (leafL_081_3).reject.ValidFor (leafL_081_3).leaf := by decide

noncomputable def leafL_081_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,240}, reject := .fullRank { members := ![0,1,17,34,52,69,115,240], points := ![95,104,106,110,150,155], inverse := ![6,1,8,2,4,8,10,15,0,11,2,12,0,7,4,3,0,0,11,4,3,2,0,14,0,0,8,8,13,13,0,3,15,12,6,6] } }
theorem leafL_081_4_valid : (leafL_081_4).reject.ValidFor (leafL_081_4).leaf := by decide

noncomputable def leafL_081_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,246}, reject := .fullRank { members := ![0,1,17,34,52,69,115,246], points := ![89,91,95,104,110,139], inverse := ![6,13,2,11,5,6,2,13,1,1,8,7,10,15,5,0,0,0,15,5,5,2,10,7,5,2,7,5,5,0,6,8,14,12,12,0] } }
theorem leafL_081_5_valid : (leafL_081_5).reject.ValidFor (leafL_081_5).leaf := by decide

noncomputable def leafL_081_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,248}, reject := .fullRank { members := ![0,1,17,34,52,69,115,248], points := ![89,90,91,106,110,135], inverse := ![6,12,3,4,10,6,9,3,4,3,10,7,9,14,7,0,0,0,12,3,0,13,5,7,6,7,1,1,1,0,10,2,8,13,13,0] } }
theorem leafL_081_6_valid : (leafL_081_6).reject.ValidFor (leafL_081_6).leaf := by decide

noncomputable def leafL_081_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,256}, reject := .fullRank { members := ![0,1,17,34,52,69,115,256], points := ![90,95,104,106,138,150], inverse := ![10,8,2,4,7,2,14,0,0,9,7,0,2,6,15,2,7,14,5,11,15,9,2,10,7,0,10,6,8,3,7,5,13,2,10,7] } }
theorem leafL_081_7_valid : (leafL_081_7).reject.ValidFor (leafL_081_7).leaf := by decide

noncomputable def leavesL_081 : List RejectedLeaf := [leafL_081_0,leafL_081_1,leafL_081_2,leafL_081_3,leafL_081_4,leafL_081_5,leafL_081_6,leafL_081_7]

theorem leavesL_081_valid : LeafListValid leavesL_081 := by
  intro x hx
  simp only [leavesL_081, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_081_0_valid
  · exact leafL_081_1_valid
  · exact leafL_081_2_valid
  · exact leafL_081_3_valid
  · exact leafL_081_4_valid
  · exact leafL_081_5_valid
  · exact leafL_081_6_valid
  · exact leafL_081_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
