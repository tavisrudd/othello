import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_056_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,124}, reject := .fullRank { members := ![0,1,17,34,52,69,103,124], points := ![86,95,139,150,152,154], inverse := ![4,12,3,12,12,10,1,7,9,4,9,2,0,0,0,5,8,13,1,5,6,7,7,2,6,6,0,14,13,3,4,4,0,7,11,12] } }
theorem leafL_056_0_valid : (leafL_056_0).reject.ValidFor (leafL_056_0).leaf := by decide

noncomputable def leafL_056_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,126}, reject := .fullRank { members := ![0,1,17,34,52,69,103,126], points := ![86,93,96,131,139,150], inverse := ![0,2,10,5,6,10,11,8,5,5,12,15,11,15,4,0,0,0,15,14,5,11,13,2,1,2,3,7,7,0,7,10,13,5,5,0] } }
theorem leafL_056_1_valid : (leafL_056_1).reject.ValidFor (leafL_056_1).leaf := by decide

noncomputable def leafL_056_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,127}, reject := .fullRank { members := ![0,1,17,34,52,69,103,127], points := ![93,94,137,152,156,169], inverse := ![13,0,0,0,7,11,6,9,14,3,15,13,2,7,3,14,3,11,3,14,1,1,0,13,10,11,14,14,8,9,15,14,14,0,6,9] } }
theorem leafL_056_2_valid : (leafL_056_2).reject.ValidFor (leafL_056_2).leaf := by decide

noncomputable def leafL_056_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,128}, reject := .fullRank { members := ![0,1,17,34,52,69,103,128], points := ![86,93,94,131,139,150], inverse := ![15,4,3,5,6,10,5,11,8,5,12,15,13,2,15,0,0,0,1,13,8,11,13,2,10,3,9,7,7,0,5,0,5,5,5,0] } }
theorem leafL_056_3_valid : (leafL_056_3).reject.ValidFor (leafL_056_3).leaf := by decide

noncomputable def leafL_056_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,137}, reject := .fullRank { members := ![0,1,17,34,52,69,103,137], points := ![91,93,95,127,150,152], inverse := ![4,3,5,5,4,2,15,13,7,8,14,3,5,10,15,0,0,0,13,10,4,10,12,5,10,9,3,0,7,7,0,5,5,0,5,5] } }
theorem leafL_056_4_valid : (leafL_056_4).reject.ValidFor (leafL_056_4).leaf := by decide

noncomputable def leafL_056_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,139}, reject := .fullRank { members := ![0,1,17,34,52,69,103,139], points := ![86,93,95,124,126,150], inverse := ![9,3,8,15,10,6,11,4,10,2,10,13,10,1,11,0,0,0,15,3,15,15,5,9,8,2,10,14,14,0,7,15,8,10,10,0] } }
theorem leafL_056_5_valid : (leafL_056_5).reject.ValidFor (leafL_056_5).leaf := by decide

noncomputable def leafL_056_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,150}, reject := .fullRank { members := ![0,1,17,34,52,69,103,150], points := ![94,95,124,126,128,131], inverse := ![13,10,8,4,2,8,15,8,8,13,12,14,0,0,5,10,15,0,1,6,5,2,15,15,1,1,5,11,14,0,7,7,11,8,3,0] } }
theorem leafL_056_6_valid : (leafL_056_6).reject.ValidFor (leafL_056_6).leaf := by decide

noncomputable def leafL_056_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,152}, reject := .fullRank { members := ![0,1,17,34,52,69,103,152], points := ![86,93,94,124,126,131], inverse := ![11,10,6,7,9,8,7,6,6,12,5,14,13,2,15,0,0,0,8,6,9,0,8,15,7,14,9,14,14,0,11,14,5,10,10,0] } }
theorem leafL_056_7_valid : (leafL_056_7).reject.ValidFor (leafL_056_7).leaf := by decide

noncomputable def leavesL_056 : List RejectedLeaf := [leafL_056_0,leafL_056_1,leafL_056_2,leafL_056_3,leafL_056_4,leafL_056_5,leafL_056_6,leafL_056_7]

theorem leavesL_056_valid : LeafListValid leavesL_056 := by
  intro x hx
  simp only [leavesL_056, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_056_0_valid
  · exact leafL_056_1_valid
  · exact leafL_056_2_valid
  · exact leafL_056_3_valid
  · exact leafL_056_4_valid
  · exact leafL_056_5_valid
  · exact leafL_056_6_valid
  · exact leafL_056_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
