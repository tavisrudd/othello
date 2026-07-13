import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_106_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,150,269}, reject := .fullRank { members := ![0,1,17,34,52,69,150,269], points := ![89,90,91,103,107,124], inverse := ![2,6,11,7,15,6,12,15,10,6,8,7,9,14,7,0,0,0,10,13,15,14,1,7,5,5,0,14,14,0,14,11,5,10,10,0] } }
theorem leafL_106_0_valid : (leafL_106_0).reject.ValidFor (leafL_106_0).leaf := by decide

noncomputable def leafL_106_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,150,271}, reject := .fullRank { members := ![0,1,17,34,52,69,150,271], points := ![89,91,103,107,115,122], inverse := ![4,11,9,1,3,5,1,8,11,5,13,10,13,13,6,6,8,8,12,4,4,11,8,15,12,12,10,10,1,1,3,3,8,8,9,9] } }
theorem leafL_106_1_valid : (leafL_106_1).reject.ValidFor (leafL_106_1).leaf := by decide

noncomputable def leafL_106_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,151,195}, reject := .fullRank { members := ![0,1,17,34,52,69,151,195], points := ![89,91,93,107,127,128], inverse := ![4,3,8,8,10,12,4,0,13,14,8,15,15,10,5,0,0,0,5,6,11,15,13,10,1,6,7,0,2,2,12,2,14,0,9,9] } }
theorem leafL_106_2_valid : (leafL_106_2).reject.ValidFor (leafL_106_2).leaf := by decide

noncomputable def leafL_106_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,151,201}, reject := .fullRank { members := ![0,1,17,34,52,69,151,201], points := ![86,91,96,99,112,120], inverse := ![2,8,5,12,4,6,8,9,8,2,12,7,10,7,13,0,0,0,2,13,7,11,4,7,13,8,5,3,3,0,15,6,9,4,4,0] } }
theorem leafL_106_3_valid : (leafL_106_3).reject.ValidFor (leafL_106_3).leaf := by decide

noncomputable def leafL_106_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,151,211}, reject := .fullRank { members := ![0,1,17,34,52,69,151,211], points := ![86,92,94,112,120,122], inverse := ![0,11,4,8,13,11,11,1,3,14,3,4,2,9,11,0,0,0,9,10,11,15,2,5,10,2,8,0,6,6,8,8,0,0,8,8] } }
theorem leafL_106_4_valid : (leafL_106_4).reject.ValidFor (leafL_106_4).leaf := by decide

noncomputable def leafL_106_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,152,166}, reject := .fullRank { members := ![0,1,17,34,52,69,152,166], points := ![90,94,99,106,110,127], inverse := ![13,2,4,7,11,6,2,11,6,12,4,7,0,0,14,12,2,0,12,4,6,2,11,7,12,12,13,4,9,0,13,13,0,13,13,0] } }
theorem leafL_106_5_valid : (leafL_106_5).reject.ValidFor (leafL_106_5).leaf := by decide

noncomputable def leafL_106_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,152,171}, reject := .fullRank { members := ![0,1,17,34,52,69,152,171], points := ![86,90,94,99,103,124], inverse := ![1,14,0,2,10,6,7,10,4,11,5,7,12,11,7,0,0,0,0,10,2,3,12,7,5,6,3,1,1,0,0,13,13,13,13,0] } }
theorem leafL_106_6_valid : (leafL_106_6).reject.ValidFor (leafL_106_6).leaf := by decide

noncomputable def leafL_106_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,152,183}, reject := .fullRank { members := ![0,1,17,34,52,69,152,183], points := ![86,90,93,106,107,122], inverse := ![3,1,13,7,15,6,0,9,0,14,0,7,7,2,5,0,0,0,9,2,3,8,7,7,12,14,2,13,13,0,1,7,6,14,14,0] } }
theorem leafL_106_7_valid : (leafL_106_7).reject.ValidFor (leafL_106_7).leaf := by decide

noncomputable def leavesL_106 : List RejectedLeaf := [leafL_106_0,leafL_106_1,leafL_106_2,leafL_106_3,leafL_106_4,leafL_106_5,leafL_106_6,leafL_106_7]

theorem leavesL_106_valid : LeafListValid leavesL_106 := by
  intro x hx
  simp only [leavesL_106, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_106_0_valid
  · exact leafL_106_1_valid
  · exact leafL_106_2_valid
  · exact leafL_106_3_valid
  · exact leafL_106_4_valid
  · exact leafL_106_5_valid
  · exact leafL_106_6_valid
  · exact leafL_106_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
