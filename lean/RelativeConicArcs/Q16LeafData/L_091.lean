import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_091_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,127,166}, reject := .fullRank { members := ![0,1,17,34,52,69,127,166], points := ![89,90,93,110,135,137], inverse := ![10,10,9,14,5,3,11,10,15,9,11,12,13,11,6,0,0,0,3,12,0,8,6,1,4,3,7,0,4,4,2,15,13,0,1,1] } }
theorem leafL_091_0_valid : (leafL_091_0).reject.ValidFor (leafL_091_0).leaf := by decide

noncomputable def leafL_091_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,127,171}, reject := .fullRank { members := ![0,1,17,34,52,69,127,171], points := ![89,90,94,103,138,144], inverse := ![1,5,13,14,4,2,6,12,4,9,3,4,11,13,6,0,0,0,2,6,11,8,13,10,6,13,11,0,5,5,3,13,14,0,12,12] } }
theorem leafL_091_1_valid : (leafL_091_1).reject.ValidFor (leafL_091_1).leaf := by decide

noncomputable def leafL_091_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,127,173}, reject := .fullRank { members := ![0,1,17,34,52,69,127,173], points := ![92,94,96,103,104,135], inverse := ![15,13,11,5,11,6,7,4,13,9,0,7,5,10,15,0,0,0,10,3,6,14,6,7,3,13,14,4,4,0,15,4,11,1,1,0] } }
theorem leafL_091_2_valid : (leafL_091_2).reject.ValidFor (leafL_091_2).leaf := by decide

noncomputable def leafL_091_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,127,183}, reject := .fullRank { members := ![0,1,17,34,52,69,127,183], points := ![89,90,93,107,110,137], inverse := ![11,15,13,13,3,6,2,1,13,15,6,7,13,11,6,0,0,0,12,10,9,7,15,7,14,7,9,11,11,0,9,14,7,6,6,0] } }
theorem leafL_091_3_valid : (leafL_091_3).reject.ValidFor (leafL_091_3).leaf := by decide

noncomputable def leafL_091_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,127,186}, reject := .fullRank { members := ![0,1,17,34,52,69,127,186], points := ![93,96,103,107,137,144], inverse := ![10,3,11,5,14,8,13,3,11,2,12,11,11,11,5,5,1,1,3,12,6,14,13,10,1,1,10,10,10,10,13,13,12,12,15,15] } }
theorem leafL_091_4_valid : (leafL_091_4).reject.ValidFor (leafL_091_4).leaf := by decide

noncomputable def leafL_091_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,127,195}, reject := .fullRank { members := ![0,1,17,34,52,69,127,195], points := ![89,93,94,103,104,135], inverse := ![0,1,8,5,11,6,4,15,5,9,0,7,6,13,11,0,0,0,8,11,12,14,6,7,6,8,14,4,4,0,0,1,1,1,1,0] } }
theorem leafL_091_5_valid : (leafL_091_5).reject.ValidFor (leafL_091_5).leaf := by decide

noncomputable def leafL_091_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,127,198}, reject := .fullRank { members := ![0,1,17,34,52,69,127,198], points := ![92,93,104,110,135,137], inverse := ![2,11,14,0,3,5,0,14,6,15,2,5,5,5,15,15,12,12,0,15,4,12,8,15,0,0,1,1,14,14,10,10,11,11,3,3] } }
theorem leafL_091_6_valid : (leafL_091_6).reject.ValidFor (leafL_091_6).leaf := by decide

noncomputable def leafL_091_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,127,201}, reject := .fullRank { members := ![0,1,17,34,52,69,127,201], points := ![96,103,104,110,138,144], inverse := ![9,0,7,9,9,15,14,14,6,1,0,7,0,5,12,9,0,0,15,6,11,5,12,11,0,8,3,11,4,4,0,13,8,5,10,10] } }
theorem leafL_091_7_valid : (leafL_091_7).reject.ValidFor (leafL_091_7).leaf := by decide

noncomputable def leavesL_091 : List RejectedLeaf := [leafL_091_0,leafL_091_1,leafL_091_2,leafL_091_3,leafL_091_4,leafL_091_5,leafL_091_6,leafL_091_7]

theorem leavesL_091_valid : LeafListValid leavesL_091 := by
  intro x hx
  simp only [leavesL_091, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_091_0_valid
  · exact leafL_091_1_valid
  · exact leafL_091_2_valid
  · exact leafL_091_3_valid
  · exact leafL_091_4_valid
  · exact leafL_091_5_valid
  · exact leafL_091_6_valid
  · exact leafL_091_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
