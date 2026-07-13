import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_251_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,92,269}, reject := .fullRank { members := ![0,1,17,34,52,72,92,269], points := ![107,112,135,138,143,149], inverse := ![5,12,1,3,15,5,1,3,9,9,4,6,0,0,1,5,4,0,10,7,13,9,5,12,2,2,0,15,15,0,12,12,1,6,7,0] } }
theorem leafL_251_0_valid : (leafL_251_0).reject.ValidFor (leafL_251_0).leaf := by decide

noncomputable def leafL_251_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,93,103}, reject := .fullRank { members := ![0,1,17,34,52,72,93,103], points := ![126,139,150,159,163,174], inverse := ![4,14,2,9,15,15,0,11,13,5,4,7,14,14,2,12,12,2,6,13,9,6,7,3,10,10,2,8,15,5,13,13,13,0,13,0] } }
theorem leafL_251_1_valid : (leafL_251_1).reject.ValidFor (leafL_251_1).leaf := by decide

noncomputable def leafL_251_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,93,108}, reject := .fullRank { members := ![0,1,17,34,52,72,93,108], points := ![128,137,150,151,166,175], inverse := ![1,11,13,3,12,9,11,0,9,10,14,6,6,6,10,12,11,13,9,2,13,13,5,14,4,4,11,15,13,9,5,5,1,4,2,7] } }
theorem leafL_251_2_valid : (leafL_251_2).reject.ValidFor (leafL_251_2).leaf := by decide

noncomputable def leafL_251_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,93,139}, reject := .fullRank { members := ![0,1,17,34,52,72,93,139], points := ![101,103,115,124,126,150], inverse := ![15,3,3,15,2,3,2,15,4,7,2,12,0,0,3,14,13,0,7,13,1,12,0,7,1,1,1,2,3,0,7,7,4,6,2,0] } }
theorem leafL_251_3_valid : (leafL_251_3).reject.ValidFor (leafL_251_3).leaf := by decide

noncomputable def leafL_251_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,93,159}, reject := .fullRank { members := ![0,1,17,34,52,72,93,159], points := ![101,103,124,139,144,163], inverse := ![0,0,15,0,5,11,4,14,11,5,3,7,7,9,12,0,7,5,3,11,4,2,4,10,4,6,14,9,8,13,14,8,1,12,15,4] } }
theorem leafL_251_4_valid : (leafL_251_4).reject.ValidFor (leafL_251_4).leaf := by decide

noncomputable def leafL_251_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,93,174}, reject := .fullRank { members := ![0,1,17,34,52,72,93,174], points := ![99,101,103,124,137,144], inverse := ![11,15,3,9,0,15,0,11,12,14,12,5,5,10,15,0,0,0,2,9,12,15,9,1,15,8,7,0,15,15,1,15,14,0,3,3] } }
theorem leafL_251_5_valid : (leafL_251_5).reject.ValidFor (leafL_251_5).leaf := by decide

noncomputable def leafL_251_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,93,202}, reject := .fullRank { members := ![0,1,17,34,52,72,93,202], points := ![101,103,108,117,124,139], inverse := ![9,13,3,6,15,15,2,14,11,9,7,9,4,2,6,0,0,0,10,1,12,4,11,8,10,13,7,11,11,0,9,0,9,9,9,0] } }
theorem leafL_251_6_valid : (leafL_251_6).reject.ValidFor (leafL_251_6).leaf := by decide

noncomputable def leafL_251_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,93,239}, reject := .fullRank { members := ![0,1,17,34,52,72,93,239], points := ![103,108,115,126,128,137], inverse := ![14,9,2,4,15,15,2,5,2,11,7,9,0,0,6,4,2,0,0,7,5,7,13,8,8,8,4,1,5,0,13,13,13,0,13,0] } }
theorem leafL_251_7_valid : (leafL_251_7).reject.ValidFor (leafL_251_7).leaf := by decide

noncomputable def leavesL_251 : List RejectedLeaf := [leafL_251_0,leafL_251_1,leafL_251_2,leafL_251_3,leafL_251_4,leafL_251_5,leafL_251_6,leafL_251_7]

theorem leavesL_251_valid : LeafListValid leavesL_251 := by
  intro x hx
  simp only [leavesL_251, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_251_0_valid
  · exact leafL_251_1_valid
  · exact leafL_251_2_valid
  · exact leafL_251_3_valid
  · exact leafL_251_4_valid
  · exact leafL_251_5_valid
  · exact leafL_251_6_valid
  · exact leafL_251_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
