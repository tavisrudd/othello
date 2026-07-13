import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_095_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,131,150}, reject := .fullRank { members := ![0,1,17,34,52,69,131,150], points := ![89,94,95,103,107,126], inverse := ![12,0,3,1,9,6,1,11,3,1,15,7,4,8,12,0,0,0,13,11,14,9,6,7,14,12,2,14,14,0,9,15,6,10,10,0] } }
theorem leafL_095_0_valid : (leafL_095_0).reject.ValidFor (leafL_095_0).leaf := by decide

noncomputable def leafL_095_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,131,151}, reject := .fullRank { members := ![0,1,17,34,52,69,131,151], points := ![92,94,95,107,112,120], inverse := ![13,6,4,14,6,6,3,15,5,12,2,7,4,12,8,0,0,0,8,10,10,15,0,7,6,9,15,10,10,0,11,0,11,11,11,0] } }
theorem leafL_095_1_valid : (leafL_095_1).reject.ValidFor (leafL_095_1).leaf := by decide

noncomputable def leafL_095_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,131,169}, reject := .fullRank { members := ![0,1,17,34,52,69,131,169], points := ![92,94,95,103,107,159], inverse := ![8,10,4,3,8,12,10,13,13,13,9,14,4,12,8,0,0,0,6,1,12,5,0,14,14,2,12,14,14,0,9,6,15,10,10,0] } }
theorem leafL_095_2_valid : (leafL_095_2).reject.ValidFor (leafL_095_2).leaf := by decide

noncomputable def leafL_095_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,131,173}, reject := .fullRank { members := ![0,1,17,34,52,69,131,173], points := ![89,92,94,103,107,126], inverse := ![15,3,3,1,9,6,2,3,8,1,15,7,8,12,4,0,0,0,3,14,5,9,6,7,12,2,14,14,14,0,15,6,9,10,10,0] } }
theorem leafL_095_3_valid : (leafL_095_3).reject.ValidFor (leafL_095_3).leaf := by decide

noncomputable def leafL_095_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,131,183}, reject := .fullRank { members := ![0,1,17,34,52,69,131,183], points := ![89,95,107,110,120,126], inverse := ![14,1,3,11,5,3,4,13,12,2,12,11,8,8,7,7,7,7,11,3,10,5,2,5,11,11,5,5,14,14,15,15,1,1,7,7] } }
theorem leafL_095_4_valid : (leafL_095_4).reject.ValidFor (leafL_095_4).leaf := by decide

noncomputable def leafL_095_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,131,198}, reject := .fullRank { members := ![0,1,17,34,52,69,131,198], points := ![92,95,110,112,120,126], inverse := ![15,0,8,0,6,0,4,13,11,5,9,14,14,14,1,1,12,12,9,1,10,5,1,6,7,7,8,8,1,1,7,7,14,14,2,2] } }
theorem leafL_095_5_valid : (leafL_095_5).reject.ValidFor (leafL_095_5).leaf := by decide

noncomputable def leafL_095_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,131,203}, reject := .fullRank { members := ![0,1,17,34,52,69,131,203], points := ![89,92,95,103,110,128], inverse := ![1,3,13,4,12,6,15,6,0,6,8,7,12,8,4,0,0,0,15,14,9,10,5,7,10,13,7,7,7,0,4,2,6,5,5,0] } }
theorem leafL_095_6_valid : (leafL_095_6).reject.ValidFor (leafL_095_6).leaf := by decide

noncomputable def leafL_095_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,131,207}, reject := .fullRank { members := ![0,1,17,34,52,69,131,207], points := ![89,92,94,103,110,120], inverse := ![0,15,0,0,8,6,1,0,8,13,3,7,8,12,4,0,0,0,8,1,1,1,14,7,13,10,7,7,7,0,2,4,6,5,5,0] } }
theorem leafL_095_7_valid : (leafL_095_7).reject.ValidFor (leafL_095_7).leaf := by decide

noncomputable def leavesL_095 : List RejectedLeaf := [leafL_095_0,leafL_095_1,leafL_095_2,leafL_095_3,leafL_095_4,leafL_095_5,leafL_095_6,leafL_095_7]

theorem leavesL_095_valid : LeafListValid leavesL_095 := by
  intro x hx
  simp only [leavesL_095, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_095_0_valid
  · exact leafL_095_1_valid
  · exact leafL_095_2_valid
  · exact leafL_095_3_valid
  · exact leafL_095_4_valid
  · exact leafL_095_5_valid
  · exact leafL_095_6_valid
  · exact leafL_095_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
