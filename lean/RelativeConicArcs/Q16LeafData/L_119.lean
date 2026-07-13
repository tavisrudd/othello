import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_119_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,207,222}, reject := .fullRank { members := ![0,1,17,34,52,69,207,222], points := ![89,90,99,115,124,131], inverse := ![6,6,7,1,8,15,0,0,7,14,0,9,12,5,9,9,0,9,11,15,3,9,2,12,8,9,1,5,4,1,12,14,2,3,1,2] } }
theorem leafL_119_0_valid : (leafL_119_0).reject.ValidFor (leafL_119_0).leaf := by decide

noncomputable def leafL_119_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,207,240}, reject := .fullRank { members := ![0,1,17,34,52,69,207,240], points := ![90,92,94,110,115,122], inverse := ![12,7,4,8,10,12,12,8,13,14,6,1,15,10,5,0,0,0,7,0,15,15,0,7,10,5,15,0,10,10,10,6,12,0,11,11] } }
theorem leafL_119_1_valid : (leafL_119_1).reject.ValidFor (leafL_119_1).leaf := by decide

noncomputable def leafL_119_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,207,247}, reject := .fullRank { members := ![0,1,17,34,52,69,207,247], points := ![91,92,110,115,120,128], inverse := ![0,15,8,0,6,0,3,10,14,12,7,12,0,0,0,10,3,9,10,2,15,0,15,8,3,3,0,0,13,13,9,9,0,11,10,1] } }
theorem leafL_119_2_valid : (leafL_119_2).reject.ValidFor (leafL_119_2).leaf := by decide

noncomputable def leafL_119_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,214,256}, reject := .fullRank { members := ![0,1,17,34,52,69,214,256], points := ![93,94,99,103,106,115], inverse := ![0,15,14,13,11,6,14,7,3,5,8,7,0,0,12,2,14,0,3,11,3,1,13,7,5,5,15,13,2,0,1,1,4,7,3,0] } }
theorem leafL_119_3_valid : (leafL_119_3).reject.ValidFor (leafL_119_3).leaf := by decide

noncomputable def leafL_119_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,217,247}, reject := .fullRank { members := ![0,1,17,34,52,69,217,247], points := ![91,93,96,104,107,115], inverse := ![13,14,12,3,11,6,13,1,5,2,12,7,4,12,8,0,0,0,7,9,6,12,3,7,13,7,10,3,3,0,13,10,7,4,4,0] } }
theorem leafL_119_4_valid : (leafL_119_4).reject.ValidFor (leafL_119_4).leaf := by decide

noncomputable def leafL_119_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,222,240}, reject := .fullRank { members := ![0,1,17,34,52,69,222,240], points := ![90,99,104,106,115,124], inverse := ![15,10,5,7,8,14,9,8,9,15,15,8,0,1,14,15,0,0,8,14,2,3,1,6,0,7,10,13,6,6,0,12,5,9,15,15] } }
theorem leafL_119_5_valid : (leafL_119_5).reject.ValidFor (leafL_119_5).leaf := by decide

noncomputable def leafL_119_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,222,247}, reject := .fullRank { members := ![0,1,17,34,52,69,222,247], points := ![93,96,99,104,106,115], inverse := ![10,5,4,15,3,6,5,12,11,3,6,7,0,0,1,14,15,0,0,8,9,4,2,7,3,3,2,3,1,0,14,14,13,9,4,0] } }
theorem leafL_119_6_valid : (leafL_119_6).reject.ValidFor (leafL_119_6).leaf := by decide

noncomputable def leafL_119_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,222,262}, reject := .fullRank { members := ![0,1,17,34,52,69,222,262], points := ![95,96,99,106,107,124], inverse := ![8,7,8,11,11,6,2,11,13,4,7,7,0,0,6,3,5,0,13,5,13,2,0,7,5,5,3,5,6,0,1,1,12,8,4,0] } }
theorem leafL_119_7_valid : (leafL_119_7).reject.ValidFor (leafL_119_7).leaf := by decide

noncomputable def leavesL_119 : List RejectedLeaf := [leafL_119_0,leafL_119_1,leafL_119_2,leafL_119_3,leafL_119_4,leafL_119_5,leafL_119_6,leafL_119_7]

theorem leavesL_119_valid : LeafListValid leavesL_119 := by
  intro x hx
  simp only [leavesL_119, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_119_0_valid
  · exact leafL_119_1_valid
  · exact leafL_119_2_valid
  · exact leafL_119_3_valid
  · exact leafL_119_4_valid
  · exact leafL_119_5_valid
  · exact leafL_119_6_valid
  · exact leafL_119_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
