import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_108_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,154,172}, reject := .fullRank { members := ![0,1,17,34,52,69,154,172], points := ![91,93,96,103,104,128], inverse := ![9,10,12,5,13,6,1,3,11,9,7,7,4,12,8,0,0,0,3,0,11,14,1,7,10,14,4,4,4,0,8,5,13,1,1,0] } }
theorem leafL_108_0_valid : (leafL_108_0).reject.ValidFor (leafL_108_0).leaf := by decide

noncomputable def leafL_108_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,154,173}, reject := .fullRank { members := ![0,1,17,34,52,69,154,173], points := ![89,92,96,103,104,124], inverse := ![11,3,7,0,8,6,2,3,8,4,10,7,2,10,8,0,0,0,6,3,13,3,12,7,6,1,7,4,4,0,10,9,3,1,1,0] } }
theorem leafL_108_1_valid : (leafL_108_1).reject.ValidFor (leafL_108_1).leaf := by decide

noncomputable def leafL_108_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,154,195}, reject := .fullRank { members := ![0,1,17,34,52,69,154,195], points := ![89,91,93,103,104,127], inverse := ![3,14,2,9,1,6,14,2,5,7,9,7,15,10,5,0,0,0,14,0,6,0,15,7,14,13,3,4,4,0,11,4,15,1,1,0] } }
theorem leafL_108_2_valid : (leafL_108_2).reject.ValidFor (leafL_108_2).leaf := by decide

noncomputable def leafL_108_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,154,198}, reject := .fullRank { members := ![0,1,17,34,52,69,154,198], points := ![91,92,99,104,112,124], inverse := ![1,14,5,0,13,6,0,9,13,2,1,7,0,0,10,3,9,0,11,3,8,0,7,7,5,5,13,12,1,0,1,1,5,7,2,0] } }
theorem leafL_108_3_valid : (leafL_108_3).reject.ValidFor (leafL_108_3).leaf := by decide

noncomputable def leafL_108_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,154,211}, reject := .fullRank { members := ![0,1,17,34,52,69,154,211], points := ![91,92,103,104,112,127], inverse := ![5,10,10,0,2,6,11,2,9,2,5,7,0,0,2,15,13,0,0,8,8,6,1,7,5,5,6,11,13,0,1,1,1,1,0,0] } }
theorem leafL_108_4_valid : (leafL_108_4).reject.ValidFor (leafL_108_4).leaf := by decide

noncomputable def leafL_108_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,154,217}, reject := .fullRank { members := ![0,1,17,34,52,69,154,217], points := ![93,96,99,124,131,144], inverse := ![13,4,14,0,4,2,3,5,1,8,13,2,8,5,13,13,3,14,13,13,7,15,6,14,0,15,15,15,9,6,12,10,6,6,3,5] } }
theorem leafL_108_5_valid : (leafL_108_5).reject.ValidFor (leafL_108_5).leaf := by decide

noncomputable def leafL_108_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,154,232}, reject := .fullRank { members := ![0,1,17,34,52,69,154,232], points := ![89,92,96,112,127,128], inverse := ![13,5,7,8,13,11,0,0,9,14,0,7,2,10,8,0,0,0,6,7,9,15,14,9,15,2,13,0,2,2,5,13,8,0,9,9] } }
theorem leafL_108_6_valid : (leafL_108_6).reject.ValidFor (leafL_108_6).leaf := by decide

noncomputable def leafL_108_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,154,240}, reject := .fullRank { members := ![0,1,17,34,52,69,154,240], points := ![92,99,104,124,127,137], inverse := ![4,12,15,4,9,11,14,11,2,8,8,7,10,9,3,14,4,10,6,2,3,13,4,14,4,14,10,13,9,4,0,8,8,8,8,0] } }
theorem leafL_108_7_valid : (leafL_108_7).reject.ValidFor (leafL_108_7).leaf := by decide

noncomputable def leavesL_108 : List RejectedLeaf := [leafL_108_0,leafL_108_1,leafL_108_2,leafL_108_3,leafL_108_4,leafL_108_5,leafL_108_6,leafL_108_7]

theorem leavesL_108_valid : LeafListValid leavesL_108 := by
  intro x hx
  simp only [leavesL_108, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_108_0_valid
  · exact leafL_108_1_valid
  · exact leafL_108_2_valid
  · exact leafL_108_3_valid
  · exact leafL_108_4_valid
  · exact leafL_108_5_valid
  · exact leafL_108_6_valid
  · exact leafL_108_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
