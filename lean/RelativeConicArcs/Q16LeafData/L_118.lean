import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_118_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,195,214}, reject := .fullRank { members := ![0,1,17,34,52,69,195,214], points := ![89,93,103,106,107,127], inverse := ![10,5,12,13,9,6,13,4,2,2,14,7,0,0,15,9,6,0,14,6,8,10,13,7,12,12,3,1,2,0,13,13,11,4,15,0] } }
theorem leafL_118_0_valid : (leafL_118_0).reject.ValidFor (leafL_118_0).leaf := by decide

noncomputable def leafL_118_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,195,217}, reject := .fullRank { members := ![0,1,17,34,52,69,195,217], points := ![86,91,94,104,107,135], inverse := ![15,0,6,9,7,6,12,12,14,11,2,7,1,5,4,0,0,0,4,10,1,5,13,7,9,6,15,3,3,0,10,2,8,4,4,0] } }
theorem leafL_118_1_valid : (leafL_118_1).reject.ValidFor (leafL_118_1).leaf := by decide

noncomputable def leafL_118_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,195,240}, reject := .fullRank { members := ![0,1,17,34,52,69,195,240], points := ![86,94,104,106,137,141], inverse := ![1,8,13,3,1,7,6,8,7,14,3,4,5,5,8,8,5,5,12,3,10,2,14,9,9,9,7,7,15,15,2,2,6,6,13,13] } }
theorem leafL_118_2_valid : (leafL_118_2).reject.ValidFor (leafL_118_2).leaf := by decide

noncomputable def leafL_118_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,195,256}, reject := .fullRank { members := ![0,1,17,34,52,69,195,256], points := ![93,94,103,104,106,126], inverse := ![12,3,14,6,0,6,0,9,7,10,3,7,0,0,8,3,11,0,13,5,3,10,6,7,5,5,12,7,11,0,1,1,1,1,0,0] } }
theorem leafL_118_3_valid : (leafL_118_3).reject.ValidFor (leafL_118_3).leaf := by decide

noncomputable def leafL_118_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,195,262}, reject := .fullRank { members := ![0,1,17,34,52,69,195,262], points := ![91,103,106,107,126,128], inverse := ![15,7,3,12,0,6,9,7,15,6,4,3,0,15,9,6,0,0,8,3,14,2,7,0,0,0,15,15,8,8,0,5,12,9,7,7] } }
theorem leafL_118_4_valid : (leafL_118_4).reject.ValidFor (leafL_118_4).leaf := by decide

noncomputable def leafL_118_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,195,268}, reject := .fullRank { members := ![0,1,17,34,52,69,195,268], points := ![86,91,93,103,106,127], inverse := ![15,0,0,0,8,6,1,13,5,10,4,7,3,13,14,0,0,0,7,6,9,14,1,7,12,9,5,6,6,0,8,8,0,8,8,0] } }
theorem leafL_118_5_valid : (leafL_118_5).reject.ValidFor (leafL_118_5).leaf := by decide

noncomputable def leafL_118_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,195,271}, reject := .fullRank { members := ![0,1,17,34,52,69,195,271], points := ![89,91,93,103,104,126], inverse := ![14,12,13,14,6,6,6,14,1,6,8,7,15,10,5,0,0,0,6,12,2,1,14,7,14,13,3,4,4,0,11,4,15,1,1,0] } }
theorem leafL_118_6_valid : (leafL_118_6).reject.ValidFor (leafL_118_6).leaf := by decide

noncomputable def leafL_118_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,207,214}, reject := .fullRank { members := ![0,1,17,34,52,69,207,214], points := ![89,92,94,99,103,115], inverse := ![9,4,2,10,2,6,13,14,10,14,0,7,8,12,4,0,0,0,2,10,0,6,9,7,9,12,5,1,1,0,3,12,15,13,13,0] } }
theorem leafL_118_7_valid : (leafL_118_7).reject.ValidFor (leafL_118_7).leaf := by decide

noncomputable def leavesL_118 : List RejectedLeaf := [leafL_118_0,leafL_118_1,leafL_118_2,leafL_118_3,leafL_118_4,leafL_118_5,leafL_118_6,leafL_118_7]

theorem leavesL_118_valid : LeafListValid leavesL_118 := by
  intro x hx
  simp only [leavesL_118, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_118_0_valid
  · exact leafL_118_1_valid
  · exact leafL_118_2_valid
  · exact leafL_118_3_valid
  · exact leafL_118_4_valid
  · exact leafL_118_5_valid
  · exact leafL_118_6_valid
  · exact leafL_118_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
