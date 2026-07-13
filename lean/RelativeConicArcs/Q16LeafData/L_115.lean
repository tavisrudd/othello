import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_115_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,172,183}, reject := .fullRank { members := ![0,1,17,34,52,69,172,183], points := ![86,91,93,106,110,122], inverse := ![0,5,10,1,9,6,1,14,6,14,0,7,3,13,14,0,0,0,0,6,14,0,15,7,1,2,3,1,1,0,6,14,8,13,13,0] } }
theorem leafL_115_0_valid : (leafL_115_0).reject.ValidFor (leafL_115_0).leaf := by decide

noncomputable def leafL_115_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,172,186}, reject := .fullRank { members := ![0,1,17,34,52,69,172,186], points := ![86,91,96,103,107,115], inverse := ![7,8,0,14,6,6,13,10,14,5,11,7,10,7,13,0,0,0,9,1,0,13,2,7,3,7,4,14,14,0,5,1,4,10,10,0] } }
theorem leafL_115_1_valid : (leafL_115_1).reject.ValidFor (leafL_115_1).leaf := by decide

noncomputable def leafL_115_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,172,195}, reject := .fullRank { members := ![0,1,17,34,52,69,172,195], points := ![91,93,94,103,104,128], inverse := ![7,13,5,5,13,6,14,13,10,9,7,7,1,7,6,0,0,0,12,14,10,14,1,7,1,2,3,4,4,0,0,1,1,1,1,0] } }
theorem leafL_115_2_valid : (leafL_115_2).reject.ValidFor (leafL_115_2).leaf := by decide

noncomputable def leafL_115_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,172,222}, reject := .fullRank { members := ![0,1,17,34,52,69,172,222], points := ![95,96,104,106,107,115], inverse := ![13,2,1,7,14,6,15,6,5,3,8,7,0,0,12,1,13,0,0,8,5,5,15,7,5,5,6,4,2,0,1,1,11,12,7,0] } }
theorem leafL_115_3_valid : (leafL_115_3).reject.ValidFor (leafL_115_3).leaf := by decide

noncomputable def leafL_115_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,172,240}, reject := .fullRank { members := ![0,1,17,34,52,69,172,240], points := ![86,94,95,106,110,115], inverse := ![13,13,15,15,7,6,13,0,4,12,2,7,6,5,3,0,0,0,0,9,1,2,13,7,14,10,4,1,1,0,1,6,7,13,13,0] } }
theorem leafL_115_4_valid : (leafL_115_4).reject.ValidFor (leafL_115_4).leaf := by decide

noncomputable def leafL_115_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,172,246}, reject := .fullRank { members := ![0,1,17,34,52,69,172,246], points := ![91,94,95,104,110,115], inverse := ![3,11,7,6,14,6,5,14,2,9,7,7,8,2,10,0,0,0,4,8,4,10,5,7,8,1,9,5,5,0,4,15,11,12,12,0] } }
theorem leafL_115_5_valid : (leafL_115_5).reject.ValidFor (leafL_115_5).leaf := by decide

noncomputable def leafL_115_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,172,249}, reject := .fullRank { members := ![0,1,17,34,52,69,172,249], points := ![86,94,95,103,104,115], inverse := ![8,3,4,6,14,6,5,12,0,3,13,7,6,5,3,0,0,0,10,6,4,4,11,7,15,2,13,4,4,0,12,4,8,1,1,0] } }
theorem leafL_115_6_valid : (leafL_115_6).reject.ValidFor (leafL_115_6).leaf := by decide

noncomputable def leafL_115_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,173,186}, reject := .fullRank { members := ![0,1,17,34,52,69,173,186], points := ![86,96,103,107,112,115], inverse := ![3,12,6,12,2,6,8,1,15,10,11,7,0,0,7,2,5,0,0,8,12,14,13,7,9,9,9,12,5,0,12,12,11,6,13,0] } }
theorem leafL_115_7_valid : (leafL_115_7).reject.ValidFor (leafL_115_7).leaf := by decide

noncomputable def leavesL_115 : List RejectedLeaf := [leafL_115_0,leafL_115_1,leafL_115_2,leafL_115_3,leafL_115_4,leafL_115_5,leafL_115_6,leafL_115_7]

theorem leavesL_115_valid : LeafListValid leavesL_115 := by
  intro x hx
  simp only [leavesL_115, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_115_0_valid
  · exact leafL_115_1_valid
  · exact leafL_115_2_valid
  · exact leafL_115_3_valid
  · exact leafL_115_4_valid
  · exact leafL_115_5_valid
  · exact leafL_115_6_valid
  · exact leafL_115_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
