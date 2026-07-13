import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_110_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,159,173}, reject := .fullRank { members := ![0,1,17,34,52,69,159,173], points := ![89,96,103,106,115,122], inverse := ![4,11,3,11,0,6,8,1,14,0,1,6,15,15,11,11,14,14,1,9,15,0,14,9,2,2,13,13,14,14,7,7,15,15,9,9] } }
theorem leafL_110_0_valid : (leafL_110_0).reject.ValidFor (leafL_110_0).leaf := by decide

noncomputable def leafL_110_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,159,186}, reject := .fullRank { members := ![0,1,17,34,52,69,159,186], points := ![86,89,91,103,115,124], inverse := ![3,0,12,8,8,14,13,9,13,14,10,13,6,2,4,0,0,0,4,0,12,15,12,11,1,6,7,0,4,4,14,6,8,0,1,1] } }
theorem leafL_110_1_valid : (leafL_110_1).reject.ValidFor (leafL_110_1).leaf := by decide

noncomputable def leafL_110_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,159,214}, reject := .fullRank { members := ![0,1,17,34,52,69,159,214], points := ![89,93,96,106,115,120], inverse := ![8,14,9,8,14,8,3,6,12,14,13,10,8,10,2,0,0,0,13,10,15,15,11,12,1,13,12,0,5,5,11,10,1,0,12,12] } }
theorem leafL_110_2_valid : (leafL_110_2).reject.ValidFor (leafL_110_2).leaf := by decide

noncomputable def leafL_110_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,159,232}, reject := .fullRank { members := ![0,1,17,34,52,69,159,232], points := ![86,89,96,115,122,139], inverse := ![10,8,5,13,3,8,6,6,7,14,7,14,5,11,14,0,0,0,12,14,5,3,11,15,9,7,14,10,10,0,13,12,1,11,11,0] } }
theorem leafL_110_3_valid : (leafL_110_3).reject.ValidFor (leafL_110_3).leaf := by decide

noncomputable def leafL_110_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,159,240}, reject := .fullRank { members := ![0,1,17,34,52,69,159,240], points := ![86,104,106,110,115,122], inverse := ![15,2,13,7,5,3,9,13,9,10,10,13,0,7,4,3,0,0,8,0,9,6,5,2,0,1,2,3,15,15,0,8,13,5,3,3] } }
theorem leafL_110_4_valid : (leafL_110_4).reject.ValidFor (leafL_110_4).leaf := by decide

noncomputable def leafL_110_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,159,249}, reject := .fullRank { members := ![0,1,17,34,52,69,159,249], points := ![86,103,104,115,120,122], inverse := ![15,9,1,7,15,14,9,15,1,6,4,5,0,0,0,1,14,15,8,14,1,2,12,9,0,2,2,3,4,7,0,14,14,5,2,7] } }
theorem leafL_110_5_valid : (leafL_110_5).reject.ValidFor (leafL_110_5).leaf := by decide

noncomputable def leafL_110_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,159,256}, reject := .fullRank { members := ![0,1,17,34,52,69,159,256], points := ![103,104,106,122,163,182], inverse := ![3,6,7,4,15,8,8,4,14,13,11,4,8,3,11,0,0,0,3,9,14,6,2,0,6,6,1,1,1,1,3,10,2,11,11,11] } }
theorem leafL_110_6_valid : (leafL_110_6).reject.ValidFor (leafL_110_6).leaf := by decide

noncomputable def leafL_110_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,159,259}, reject := .fullRank { members := ![0,1,17,34,52,69,159,259], points := ![86,96,106,110,120,124], inverse := ![10,5,7,15,0,6,3,10,2,12,4,3,14,14,1,1,7,7,12,4,5,10,14,9,5,5,6,6,6,6,7,7,3,3,12,12] } }
theorem leafL_110_7_valid : (leafL_110_7).reject.ValidFor (leafL_110_7).leaf := by decide

noncomputable def leavesL_110 : List RejectedLeaf := [leafL_110_0,leafL_110_1,leafL_110_2,leafL_110_3,leafL_110_4,leafL_110_5,leafL_110_6,leafL_110_7]

theorem leavesL_110_valid : LeafListValid leavesL_110 := by
  intro x hx
  simp only [leavesL_110, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_110_0_valid
  · exact leafL_110_1_valid
  · exact leafL_110_2_valid
  · exact leafL_110_3_valid
  · exact leafL_110_4_valid
  · exact leafL_110_5_valid
  · exact leafL_110_6_valid
  · exact leafL_110_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
