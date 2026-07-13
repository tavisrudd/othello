import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_075_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,259}, reject := .fullRank { members := ![0,1,17,34,52,69,110,259], points := ![90,91,127,137,144,152], inverse := ![10,10,4,6,8,11,9,15,0,11,2,15,11,9,1,1,15,13,12,1,13,14,2,12,1,5,2,10,5,9,13,4,13,15,5,14] } }
theorem leafL_075_0_valid : (leafL_075_0).reject.ValidFor (leafL_075_0).leaf := by decide

noncomputable def leafL_075_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,265}, reject := .fullRank { members := ![0,1,17,34,52,69,110,265], points := ![90,93,115,122,128,135], inverse := ![12,11,15,2,3,8,14,9,8,11,10,14,0,0,7,8,15,0,0,7,12,15,11,15,14,14,9,5,12,0,12,12,13,6,11,0] } }
theorem leafL_075_1_valid : (leafL_075_1).reject.ValidFor (leafL_075_1).leaf := by decide

noncomputable def leafL_075_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,268}, reject := .fullRank { members := ![0,1,17,34,52,69,110,268], points := ![86,89,90,115,122,137], inverse := ![5,5,7,12,2,8,3,0,4,11,2,14,14,4,10,0,0,0,14,7,14,9,1,15,2,8,10,10,10,0,3,14,13,11,11,0] } }
theorem leafL_075_2_valid : (leafL_075_2).reject.ValidFor (leafL_075_2).leaf := by decide

noncomputable def leafL_075_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,269}, reject := .fullRank { members := ![0,1,17,34,52,69,110,269], points := ![86,89,90,128,131,144], inverse := ![0,9,14,14,15,7,12,14,5,9,0,14,14,4,10,0,0,0,11,9,5,8,7,8,15,4,11,0,1,1,13,13,0,0,13,13] } }
theorem leafL_075_3_valid : (leafL_075_3).reject.ValidFor (leafL_075_3).leaf := by decide

noncomputable def leafL_075_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,271}, reject := .fullRank { members := ![0,1,17,34,52,69,110,271], points := ![89,93,115,122,137,141], inverse := ![4,3,7,9,2,10,1,6,8,1,2,12,15,15,14,14,13,13,2,5,11,3,7,8,10,10,13,13,15,15,10,10,0,0,10,10] } }
theorem leafL_075_4_valid : (leafL_075_4).reject.ValidFor (leafL_075_4).leaf := by decide

noncomputable def leafL_075_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,120}, reject := .fullRank { members := ![0,1,17,34,52,69,112,120], points := ![91,94,95,131,139,151], inverse := ![12,12,8,10,9,10,15,4,13,4,13,15,8,2,10,0,0,0,13,3,10,8,14,2,14,14,0,7,7,0,12,8,4,5,5,0] } }
theorem leafL_075_5_valid : (leafL_075_5).reject.ValidFor (leafL_075_5).leaf := by decide

noncomputable def leafL_075_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,124}, reject := .fullRank { members := ![0,1,17,34,52,69,112,124], points := ![89,90,95,139,141,152], inverse := ![14,11,13,4,7,10,14,6,14,2,11,15,7,6,1,0,0,0,15,9,2,9,15,2,3,7,4,5,5,0,12,0,12,12,12,0] } }
theorem leafL_075_6_valid : (leafL_075_6).reject.ValidFor (leafL_075_6).leaf := by decide

noncomputable def leafL_075_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,126}, reject := .fullRank { members := ![0,1,17,34,52,69,112,126], points := ![89,90,95,135,139,152], inverse := ![13,2,7,10,9,10,12,8,2,12,5,15,7,6,1,0,0,0,3,11,12,14,8,2,7,8,15,11,11,0,13,7,10,6,6,0] } }
theorem leafL_075_7_valid : (leafL_075_7).reject.ValidFor (leafL_075_7).leaf := by decide

noncomputable def leavesL_075 : List RejectedLeaf := [leafL_075_0,leafL_075_1,leafL_075_2,leafL_075_3,leafL_075_4,leafL_075_5,leafL_075_6,leafL_075_7]

theorem leavesL_075_valid : LeafListValid leavesL_075 := by
  intro x hx
  simp only [leavesL_075, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_075_0_valid
  · exact leafL_075_1_valid
  · exact leafL_075_2_valid
  · exact leafL_075_3_valid
  · exact leafL_075_4_valid
  · exact leafL_075_5_valid
  · exact leafL_075_6_valid
  · exact leafL_075_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
