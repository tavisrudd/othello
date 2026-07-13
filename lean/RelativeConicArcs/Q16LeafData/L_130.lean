import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_130_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,174}, reject := .fullRank { members := ![0,1,17,34,52,70,91,174], points := ![101,103,117,122,127,144], inverse := ![10,13,9,2,2,15,5,2,0,2,12,9,0,0,5,11,14,0,14,9,7,3,11,8,1,1,12,12,0,0,7,7,15,12,3,0] } }
theorem leafL_130_0_valid : (leafL_130_0).reject.ValidFor (leafL_130_0).leaf := by decide

noncomputable def leafL_130_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,175}, reject := .fullRank { members := ![0,1,17,34,52,70,91,175], points := ![101,104,108,120,141,151], inverse := ![4,8,15,15,4,9,9,13,14,12,1,7,9,6,15,0,0,0,4,7,2,10,15,4,5,10,6,4,3,14,14,8,10,10,14,8] } }
theorem leafL_130_1_valid : (leafL_130_1).reject.ValidFor (leafL_130_1).leaf := by decide

noncomputable def leafL_130_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,176}, reject := .fullRank { members := ![0,1,17,34,52,70,91,176], points := ![101,104,108,120,125,140], inverse := ![13,7,13,7,14,15,14,4,13,9,7,9,9,6,15,0,0,0,0,15,8,15,0,8,11,10,1,15,15,0,6,8,14,3,3,0] } }
theorem leafL_130_2_valid : (leafL_130_2).reject.ValidFor (leafL_130_2).leaf := by decide

noncomputable def leafL_130_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,185}, reject := .fullRank { members := ![0,1,17,34,52,70,91,185], points := ![104,110,117,120,125,140], inverse := ![5,2,14,12,11,15,12,11,15,12,13,9,0,0,5,3,6,0,6,1,11,7,3,8,11,11,11,7,12,0,4,4,3,2,1,0] } }
theorem leafL_130_3_valid : (leafL_130_3).reject.ValidFor (leafL_130_3).leaf := by decide

noncomputable def leafL_130_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,186}, reject := .fullRank { members := ![0,1,17,34,52,70,91,186], points := ![101,103,104,125,127,137], inverse := ![12,15,4,4,13,15,0,11,12,1,15,9,7,9,14,0,0,0,9,10,4,15,0,8,15,0,15,8,8,0,7,7,0,7,7,0] } }
theorem leafL_130_4_valid : (leafL_130_4).reject.ValidFor (leafL_130_4).leaf := by decide

noncomputable def leafL_130_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,188}, reject := .fullRank { members := ![0,1,17,34,52,70,91,188], points := ![103,104,110,117,122,137], inverse := ![0,13,10,8,1,15,2,3,6,13,3,9,5,12,9,0,0,0,15,11,3,11,4,8,15,12,3,12,12,0,9,11,2,13,13,0] } }
theorem leafL_130_5_valid : (leafL_130_5).reject.ValidFor (leafL_130_5).leaf := by decide

noncomputable def leafL_130_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,191}, reject := .fullRank { members := ![0,1,17,34,52,70,91,191], points := ![101,108,109,117,122,137], inverse := ![7,6,6,8,1,15,6,9,8,13,3,9,1,5,4,0,0,0,15,1,9,11,4,8,10,8,2,12,12,0,6,15,9,13,13,0] } }
theorem leafL_130_6_valid : (leafL_130_6).reject.ValidFor (leafL_130_6).leaf := by decide

noncomputable def leafL_130_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,195}, reject := .fullRank { members := ![0,1,17,34,52,70,91,195], points := ![104,108,109,125,127,137], inverse := ![13,9,3,4,13,15,14,1,8,1,15,9,4,9,13,0,0,0,14,2,11,15,0,8,6,8,14,8,8,0,12,10,6,7,7,0] } }
theorem leafL_130_7_valid : (leafL_130_7).reject.ValidFor (leafL_130_7).leaf := by decide

noncomputable def leavesL_130 : List RejectedLeaf := [leafL_130_0,leafL_130_1,leafL_130_2,leafL_130_3,leafL_130_4,leafL_130_5,leafL_130_6,leafL_130_7]

theorem leavesL_130_valid : LeafListValid leavesL_130 := by
  intro x hx
  simp only [leavesL_130, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_130_0_valid
  · exact leafL_130_1_valid
  · exact leafL_130_2_valid
  · exact leafL_130_3_valid
  · exact leafL_130_4_valid
  · exact leafL_130_5_valid
  · exact leafL_130_6_valid
  · exact leafL_130_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
