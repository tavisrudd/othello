import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_012_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,126}, reject := .fullRank { members := ![0,1,17,34,52,69,86,126], points := ![103,104,139,141,152,163], inverse := ![13,2,4,11,4,5,13,4,13,1,2,7,12,13,3,13,7,8,3,11,8,10,4,14,3,6,11,8,8,14,8,2,7,1,3,15] } }
theorem leafL_012_0_valid : (leafL_012_0).reject.ValidFor (leafL_012_0).leaf := by decide

noncomputable def leafL_012_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,128}, reject := .fullRank { members := ![0,1,17,34,52,69,86,128], points := ![99,103,110,138,151,171], inverse := ![15,3,10,8,14,1,10,8,5,7,14,14,2,12,14,0,0,0,9,15,10,15,11,8,6,12,8,15,14,3,14,10,1,3,8,14] } }
theorem leafL_012_1_valid : (leafL_012_1).reject.ValidFor (leafL_012_1).leaf := by decide

noncomputable def leafL_012_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,138}, reject := .fullRank { members := ![0,1,17,34,52,69,86,138], points := ![99,104,107,128,151,152], inverse := ![11,14,9,14,0,3,2,9,6,1,10,6,3,10,9,0,0,0,2,13,5,13,4,3,2,7,5,0,7,7,15,7,8,0,4,4] } }
theorem leafL_012_2_valid : (leafL_012_2).reject.ValidFor (leafL_012_2).leaf := by decide

noncomputable def leafL_012_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,139}, reject := .fullRank { members := ![0,1,17,34,52,69,86,139], points := ![103,104,124,126,152,159], inverse := ![11,7,13,3,7,4,1,12,12,13,6,10,1,1,15,15,10,10,3,9,12,1,11,12,10,10,8,8,15,15,2,2,4,4,1,1] } }
theorem leafL_012_3_valid : (leafL_012_3).reject.ValidFor (leafL_012_3).leaf := by decide

noncomputable def leafL_012_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,141}, reject := .fullRank { members := ![0,1,17,34,52,69,86,141], points := ![104,110,126,151,163,171], inverse := ![13,0,0,10,6,0,2,3,5,10,14,0,15,3,4,6,10,4,13,9,6,0,6,4,4,15,8,12,14,1,10,8,15,1,15,3] } }
theorem leafL_012_4_valid : (leafL_012_4).reject.ValidFor (leafL_012_4).leaf := by decide

noncomputable def leafL_012_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,151}, reject := .fullRank { members := ![0,1,17,34,52,69,86,151], points := ![99,107,128,138,141,171], inverse := ![6,12,12,15,15,7,10,8,6,8,10,6,15,2,5,4,11,7,15,13,7,14,13,6,9,3,3,4,1,12,4,3,6,5,15,11] } }
theorem leafL_012_5_valid : (leafL_012_5).reject.ValidFor (leafL_012_5).leaf := by decide

noncomputable def leafL_012_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,152}, reject := .fullRank { members := ![0,1,17,34,52,69,86,152], points := ![103,107,110,126,138,139], inverse := ![14,10,3,9,10,5,13,7,13,14,6,15,4,9,13,0,0,0,6,0,1,15,15,7,1,6,7,0,8,8,8,2,10,0,7,7] } }
theorem leafL_012_6_valid : (leafL_012_6).reject.ValidFor (leafL_012_6).leaf := by decide

noncomputable def leafL_012_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,159}, reject := .fullRank { members := ![0,1,17,34,52,69,86,159], points := ![103,110,124,139,163,186], inverse := ![7,6,2,4,5,3,5,13,6,10,13,9,14,13,5,9,13,2,7,0,0,4,8,11,7,14,12,4,0,1,2,6,6,7,15,10] } }
theorem leafL_012_7_valid : (leafL_012_7).reject.ValidFor (leafL_012_7).leaf := by decide

noncomputable def leavesL_012 : List RejectedLeaf := [leafL_012_0,leafL_012_1,leafL_012_2,leafL_012_3,leafL_012_4,leafL_012_5,leafL_012_6,leafL_012_7]

theorem leavesL_012_valid : LeafListValid leavesL_012 := by
  intro x hx
  simp only [leavesL_012, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_012_0_valid
  · exact leafL_012_1_valid
  · exact leafL_012_2_valid
  · exact leafL_012_3_valid
  · exact leafL_012_4_valid
  · exact leafL_012_5_valid
  · exact leafL_012_6_valid
  · exact leafL_012_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
