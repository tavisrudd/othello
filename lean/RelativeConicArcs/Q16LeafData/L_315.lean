import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_315_0 : RejectedLeaf := { leaf := {0,1,17,34,52,75,143,174}, reject := .fullRank { members := ![0,1,17,34,52,75,143,174], points := ![86,93,112,115,117,122], inverse := ![0,15,8,5,10,9,3,10,14,6,13,12,0,0,0,8,15,7,10,2,15,6,0,1,6,6,0,8,7,15,1,1,0,3,15,12] } }
theorem leafL_315_0_valid : (leafL_315_0).reject.ValidFor (leafL_315_0).leaf := by decide

noncomputable def leafL_315_1 : RejectedLeaf := { leaf := {0,1,17,34,52,75,143,197}, reject := .fullRank { members := ![0,1,17,34,52,75,143,197], points := ![90,93,103,115,122,126], inverse := ![15,0,8,13,1,10,1,8,14,5,9,11,0,0,0,14,12,2,13,5,15,0,5,2,14,14,0,12,11,7,12,12,0,7,9,14] } }
theorem leafL_315_1_valid : (leafL_315_1).reject.ValidFor (leafL_315_1).leaf := by decide

noncomputable def leafL_315_2 : RejectedLeaf := { leaf := {0,1,17,34,52,75,143,249}, reject := .fullRank { members := ![0,1,17,34,52,75,143,249], points := ![83,86,93,103,104,122], inverse := ![13,14,12,11,3,6,6,1,14,11,5,7,10,12,6,0,0,0,9,0,1,12,3,7,12,2,14,4,4,0,15,8,7,1,1,0] } }
theorem leafL_315_2_valid : (leafL_315_2).reject.ValidFor (leafL_315_2).leaf := by decide

noncomputable def leafL_315_3 : RejectedLeaf := { leaf := {0,1,17,34,52,75,154,173}, reject := .fullRank { members := ![0,1,17,34,52,75,154,173], points := ![83,96,103,104,108,117], inverse := ![3,12,6,8,6,6,5,12,4,14,4,7,0,0,4,10,14,0,12,4,6,9,0,7,7,7,2,11,9,0,4,4,4,0,4,0] } }
theorem leafL_315_3_valid : (leafL_315_3).reject.ValidFor (leafL_315_3).leaf := by decide

noncomputable def leafL_315_4 : RejectedLeaf := { leaf := {0,1,17,34,52,75,154,191}, reject := .fullRank { members := ![0,1,17,34,52,75,154,191], points := ![96,103,108,109,126,131], inverse := ![7,0,12,12,14,8,1,2,12,8,15,8,0,5,11,14,0,0,1,7,3,2,14,9,14,12,11,9,14,14,8,10,12,14,8,8] } }
theorem leafL_315_4_valid : (leafL_315_4).reject.ValidFor (leafL_315_4).leaf := by decide

noncomputable def leafL_315_5 : RejectedLeaf := { leaf := {0,1,17,34,52,75,154,195}, reject := .fullRank { members := ![0,1,17,34,52,75,154,195], points := ![93,103,104,112,117,126], inverse := ![15,15,5,2,2,4,9,12,11,9,14,9,0,2,15,13,0,0,8,11,12,8,6,1,0,5,14,11,6,6,0,15,0,15,15,15] } }
theorem leafL_315_5_valid : (leafL_315_5).reject.ValidFor (leafL_315_5).leaf := by decide

noncomputable def leafL_315_6 : RejectedLeaf := { leaf := {0,1,17,34,52,75,154,197}, reject := .fullRank { members := ![0,1,17,34,52,75,154,197], points := ![93,103,108,109,126,143], inverse := ![5,1,8,11,12,10,10,13,3,3,4,3,0,5,11,14,0,0,5,10,15,7,10,13,13,7,7,13,13,13,6,3,1,4,6,6] } }
theorem leafL_315_6_valid : (leafL_315_6).reject.ValidFor (leafL_315_6).leaf := by decide

noncomputable def leafL_315_7 : RejectedLeaf := { leaf := {0,1,17,34,52,75,154,216}, reject := .fullRank { members := ![0,1,17,34,52,75,154,216], points := ![83,96,109,117,124,126], inverse := ![7,8,8,14,3,11,6,15,14,2,1,4,0,0,0,3,13,14,1,9,15,3,10,14,12,12,0,11,12,7,2,2,0,7,9,14] } }
theorem leafL_315_7_valid : (leafL_315_7).reject.ValidFor (leafL_315_7).leaf := by decide

noncomputable def leavesL_315 : List RejectedLeaf := [leafL_315_0,leafL_315_1,leafL_315_2,leafL_315_3,leafL_315_4,leafL_315_5,leafL_315_6,leafL_315_7]

theorem leavesL_315_valid : LeafListValid leavesL_315 := by
  intro x hx
  simp only [leavesL_315, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_315_0_valid
  · exact leafL_315_1_valid
  · exact leafL_315_2_valid
  · exact leafL_315_3_valid
  · exact leafL_315_4_valid
  · exact leafL_315_5_valid
  · exact leafL_315_6_valid
  · exact leafL_315_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
