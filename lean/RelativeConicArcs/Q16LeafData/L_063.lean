import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_063_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,240}, reject := .fullRank { members := ![0,1,17,34,52,69,104,240], points := ![86,90,92,115,127,137], inverse := ![0,1,6,10,4,8,1,10,12,13,4,14,13,5,8,0,0,0,0,15,8,10,2,15,14,4,10,7,7,0,5,5,0,5,5,0] } }
theorem leafL_063_0_valid : (leafL_063_0).reject.ValidFor (leafL_063_0).leaf := by decide

noncomputable def leafL_063_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,247}, reject := .fullRank { members := ![0,1,17,34,52,69,104,247], points := ![86,91,92,115,126,137], inverse := ![12,6,13,0,14,8,14,2,11,7,14,14,11,8,3,0,0,0,2,2,7,15,7,15,8,10,2,3,3,0,4,4,0,4,4,0] } }
theorem leafL_063_1_valid : (leafL_063_1).reject.ValidFor (leafL_063_1).leaf := by decide

noncomputable def leafL_063_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,249}, reject := .fullRank { members := ![0,1,17,34,52,69,104,249], points := ![86,90,92,115,141,155], inverse := ![1,14,8,14,8,0,5,7,6,1,7,2,13,5,8,0,0,0,14,9,12,14,13,8,2,9,12,10,6,11,6,11,8,11,8,6] } }
theorem leafL_063_2_valid : (leafL_063_2).reject.ValidFor (leafL_063_2).leaf := by decide

noncomputable def leafL_063_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,256}, reject := .fullRank { members := ![0,1,17,34,52,69,104,256], points := ![92,94,115,126,127,138], inverse := ![6,1,2,2,14,8,11,12,2,14,5,14,0,0,15,9,6,0,14,9,0,0,8,15,9,9,8,9,1,0,10,10,3,11,8,0] } }
theorem leafL_063_3_valid : (leafL_063_3).reject.ValidFor (leafL_063_3).leaf := by decide

noncomputable def leafL_063_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,268}, reject := .fullRank { members := ![0,1,17,34,52,69,104,268], points := ![86,90,91,115,127,137], inverse := ![8,13,2,10,4,8,2,1,4,13,4,14,15,6,9,0,0,0,2,12,9,10,2,15,5,3,6,7,7,0,5,5,0,5,5,0] } }
theorem leafL_063_4_valid : (leafL_063_4).reject.ValidFor (leafL_063_4).leaf := by decide

noncomputable def leafL_063_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,270}, reject := .fullRank { members := ![0,1,17,34,52,69,104,270], points := ![86,91,127,137,138,139], inverse := ![7,0,14,15,14,9,1,6,9,3,8,5,0,0,0,9,14,7,6,1,8,2,2,15,10,10,0,6,14,8,9,9,0,2,6,4] } }
theorem leafL_063_5_valid : (leafL_063_5).reject.ValidFor (leafL_063_5).leaf := by decide

noncomputable def leafL_063_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,271}, reject := .fullRank { members := ![0,1,17,34,52,69,104,271], points := ![89,91,94,115,137,138], inverse := ![3,4,0,14,14,6,10,4,9,9,8,6,12,3,15,0,0,0,4,10,9,8,12,3,8,12,4,0,13,13,11,4,15,0,14,14] } }
theorem leafL_063_6_valid : (leafL_063_6).reject.ValidFor (leafL_063_6).leaf := by decide

noncomputable def leafL_063_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,115}, reject := .fullRank { members := ![0,1,17,34,52,69,106,115], points := ![89,91,95,135,159,171], inverse := ![10,9,8,2,0,8,2,12,4,13,1,6,10,15,5,0,0,0,12,0,9,8,4,9,12,12,4,13,11,2,9,2,10,14,6,9] } }
theorem leafL_063_7_valid : (leafL_063_7).reject.ValidFor (leafL_063_7).leaf := by decide

noncomputable def leavesL_063 : List RejectedLeaf := [leafL_063_0,leafL_063_1,leafL_063_2,leafL_063_3,leafL_063_4,leafL_063_5,leafL_063_6,leafL_063_7]

theorem leavesL_063_valid : LeafListValid leavesL_063 := by
  intro x hx
  simp only [leavesL_063, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_063_0_valid
  · exact leafL_063_1_valid
  · exact leafL_063_2_valid
  · exact leafL_063_3_valid
  · exact leafL_063_4_valid
  · exact leafL_063_5_valid
  · exact leafL_063_6_valid
  · exact leafL_063_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
