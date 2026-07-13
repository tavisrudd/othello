import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_013_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,163}, reject := .fullRank { members := ![0,1,17,34,52,69,86,163], points := ![110,126,139,141,159,186], inverse := ![9,3,4,7,10,2,13,8,13,1,7,14,1,14,2,11,2,4,0,5,14,3,3,11,10,2,7,8,0,7,14,0,14,0,14,14] } }
theorem leafL_013_0_valid : (leafL_013_0).reject.ValidFor (leafL_013_0).leaf := by decide

noncomputable def leafL_013_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,171}, reject := .fullRank { members := ![0,1,17,34,52,69,86,171], points := ![99,103,124,126,128,138], inverse := ![11,12,6,0,15,15,6,1,5,11,0,9,0,0,5,10,15,0,3,4,1,10,4,8,9,9,3,14,13,0,10,10,10,0,10,0] } }
theorem leafL_013_1_valid : (leafL_013_1).reject.ValidFor (leafL_013_1).leaf := by decide

noncomputable def leafL_013_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,172}, reject := .fullRank { members := ![0,1,17,34,52,69,86,172], points := ![103,104,107,128,138,139], inverse := ![3,12,8,9,3,12,13,10,0,14,8,1,10,4,14,0,0,0,4,12,15,15,0,8,4,9,13,0,8,8,3,13,14,0,7,7] } }
theorem leafL_013_2_valid : (leafL_013_2).reject.ValidFor (leafL_013_2).leaf := by decide

noncomputable def leafL_013_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,173}, reject := .fullRank { members := ![0,1,17,34,52,69,86,173], points := ![103,107,124,126,138,186], inverse := ![13,2,8,6,3,3,4,7,9,13,15,8,6,13,14,7,7,5,8,2,8,1,10,9,1,10,7,14,7,5,1,14,14,13,1,13] } }
theorem leafL_013_3_valid : (leafL_013_3).reject.ValidFor (leafL_013_3).leaf := by decide

noncomputable def leafL_013_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,183}, reject := .fullRank { members := ![0,1,17,34,52,69,86,183], points := ![107,110,124,126,138,152], inverse := ![3,0,14,1,4,9,1,1,9,10,8,11,2,10,9,5,5,1,13,12,14,4,15,4,4,2,11,14,7,4,13,4,11,15,3,14] } }
theorem leafL_013_4_valid : (leafL_013_4).reject.ValidFor (leafL_013_4).leaf := by decide

noncomputable def leafL_013_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,186}, reject := .fullRank { members := ![0,1,17,34,52,69,86,186], points := ![103,107,159,163,171,172], inverse := ![7,10,10,2,1,5,11,5,4,13,11,12,0,0,0,13,15,2,2,12,5,10,2,3,4,4,0,14,3,13,8,8,0,6,9,15] } }
theorem leafL_013_5_valid : (leafL_013_5).reject.ValidFor (leafL_013_5).leaf := by decide

noncomputable def leafL_013_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,195}, reject := .fullRank { members := ![0,1,17,34,52,69,86,195], points := ![103,104,107,126,128,139], inverse := ![0,15,8,3,10,15,5,2,0,8,6,9,10,4,14,0,0,0,4,12,15,0,15,8,12,1,13,8,8,0,4,10,14,7,7,0] } }
theorem leafL_013_6_valid : (leafL_013_6).reject.ValidFor (leafL_013_6).leaf := by decide

noncomputable def leafL_013_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,201}, reject := .fullRank { members := ![0,1,17,34,52,69,86,201], points := ![99,103,110,124,126,138], inverse := ![9,0,14,3,10,15,6,1,0,5,11,9,2,12,14,0,0,0,15,10,2,12,3,8,13,2,15,9,9,0,7,2,5,12,12,0] } }
theorem leafL_013_7_valid : (leafL_013_7).reject.ValidFor (leafL_013_7).leaf := by decide

noncomputable def leavesL_013 : List RejectedLeaf := [leafL_013_0,leafL_013_1,leafL_013_2,leafL_013_3,leafL_013_4,leafL_013_5,leafL_013_6,leafL_013_7]

theorem leavesL_013_valid : LeafListValid leavesL_013 := by
  intro x hx
  simp only [leavesL_013, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_013_0_valid
  · exact leafL_013_1_valid
  · exact leafL_013_2_valid
  · exact leafL_013_3_valid
  · exact leafL_013_4_valid
  · exact leafL_013_5_valid
  · exact leafL_013_6_valid
  · exact leafL_013_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
