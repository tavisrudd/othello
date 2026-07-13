import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_109_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,154,246}, reject := .fullRank { members := ![0,1,17,34,52,69,154,246], points := ![89,91,96,99,104,124], inverse := ![12,2,1,0,8,6,0,5,12,10,4,7,3,12,15,0,0,0,6,13,3,14,1,7,15,8,7,10,10,0,0,11,11,11,11,0] } }
theorem leafL_109_0_valid : (leafL_109_0).reject.ValidFor (leafL_109_0).leaf := by decide

noncomputable def leafL_109_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,154,247}, reject := .fullRank { members := ![0,1,17,34,52,69,154,247], points := ![91,92,93,99,104,124], inverse := ![11,13,9,0,8,6,14,5,2,10,4,7,7,6,1,0,0,0,7,1,14,14,1,7,11,9,2,10,10,0,14,10,4,11,11,0] } }
theorem leafL_109_1_valid : (leafL_109_1).reject.ValidFor (leafL_109_1).leaf := by decide

noncomputable def leafL_109_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,154,249}, reject := .fullRank { members := ![0,1,17,34,52,69,154,249], points := ![103,104,112,144,163,172], inverse := ![0,4,0,7,2,0,9,7,11,8,2,15,2,15,13,0,0,0,10,14,7,10,15,6,11,14,5,0,8,8,7,0,7,0,7,7] } }
theorem leafL_109_2_valid : (leafL_109_2).reject.ValidFor (leafL_109_2).leaf := by decide

noncomputable def leafL_109_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,154,259}, reject := .fullRank { members := ![0,1,17,34,52,69,154,259], points := ![91,92,96,124,127,137], inverse := ![1,2,4,11,5,8,3,15,11,14,7,14,11,13,6,0,0,0,11,4,8,11,3,15,15,12,3,5,5,0,12,0,12,12,12,0] } }
theorem leafL_109_3_valid : (leafL_109_3).reject.ValidFor (leafL_109_3).leaf := by decide

noncomputable def leafL_109_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,154,269}, reject := .fullRank { members := ![0,1,17,34,52,69,154,269], points := ![89,92,103,112,124,131], inverse := ![7,0,12,12,14,8,1,11,7,10,4,3,3,6,1,4,5,5,12,8,9,10,11,12,7,11,5,9,12,12,3,7,8,12,4,4] } }
theorem leafL_109_4_valid : (leafL_109_4).reject.ValidFor (leafL_109_4).leaf := by decide

noncomputable def leafL_109_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,154,270}, reject := .fullRank { members := ![0,1,17,34,52,69,154,270], points := ![91,96,99,104,124,128], inverse := ![10,5,7,15,7,1,5,12,10,4,7,0,14,14,5,5,13,13,9,1,4,11,14,9,2,2,8,8,12,12,11,11,11,11,0,0] } }
theorem leafL_109_5_valid : (leafL_109_5).reject.ValidFor (leafL_109_5).leaf := by decide

noncomputable def leafL_109_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,159,163}, reject := .fullRank { members := ![0,1,17,34,52,69,159,163], points := ![86,91,93,122,139,186], inverse := ![4,6,12,11,5,1,3,1,10,5,0,13,3,13,14,0,0,0,9,11,3,1,12,12,3,2,6,3,10,14,15,14,4,4,11,10] } }
theorem leafL_109_6_valid : (leafL_109_6).reject.ValidFor (leafL_109_6).leaf := by decide

noncomputable def leafL_109_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,159,166}, reject := .fullRank { members := ![0,1,17,34,52,69,159,166], points := ![89,93,96,104,106,120], inverse := ![11,10,14,10,2,6,15,5,3,14,0,7,8,10,2,0,0,0,12,7,3,6,9,7,3,4,7,12,12,0,2,5,7,3,3,0] } }
theorem leafL_109_7_valid : (leafL_109_7).reject.ValidFor (leafL_109_7).leaf := by decide

noncomputable def leavesL_109 : List RejectedLeaf := [leafL_109_0,leafL_109_1,leafL_109_2,leafL_109_3,leafL_109_4,leafL_109_5,leafL_109_6,leafL_109_7]

theorem leavesL_109_valid : LeafListValid leavesL_109 := by
  intro x hx
  simp only [leavesL_109, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_109_0_valid
  · exact leafL_109_1_valid
  · exact leafL_109_2_valid
  · exact leafL_109_3_valid
  · exact leafL_109_4_valid
  · exact leafL_109_5_valid
  · exact leafL_109_6_valid
  · exact leafL_109_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
