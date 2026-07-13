import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_010_0 : RejectedLeaf := { leaf := {0,1,17,34,52,67,92,185}, reject := .fullRank { members := ![0,1,17,34,52,67,92,185], points := ![109,112,127,138,139,155], inverse := ![2,3,12,4,12,4,12,11,14,15,6,0,7,13,15,13,4,12,11,0,5,9,15,8,15,2,2,12,4,7,7,7,0,7,7,0] } }
theorem leafL_010_0_valid : (leafL_010_0).reject.ValidFor (leafL_010_0).leaf := by decide

noncomputable def leafL_010_1 : RejectedLeaf := { leaf := {0,1,17,34,52,67,92,190}, reject := .fullRank { members := ![0,1,17,34,52,67,92,190], points := ![109,121,122,137,139,141], inverse := ![7,9,0,6,8,1,7,3,13,8,1,0,0,0,0,15,10,5,7,10,5,14,7,1,0,7,7,0,1,1,0,1,1,11,4,15] } }
theorem leafL_010_1_valid : (leafL_010_1).reject.ValidFor (leafL_010_1).leaf := by decide

noncomputable def leafL_010_2 : RejectedLeaf := { leaf := {0,1,17,34,52,67,92,197}, reject := .fullRank { members := ![0,1,17,34,52,67,92,197], points := ![109,121,138,139,141,151], inverse := ![7,9,14,5,4,0,3,8,14,0,12,9,0,0,8,12,4,0,8,14,11,15,8,10,9,4,9,11,1,14,3,11,14,12,8,2] } }
theorem leafL_010_2_valid : (leafL_010_2).reject.ValidFor (leafL_010_2).leaf := by decide

noncomputable def leafL_010_3 : RejectedLeaf := { leaf := {0,1,17,34,52,67,92,201}, reject := .fullRank { members := ![0,1,17,34,52,67,92,201], points := ![112,122,138,139,149,155], inverse := ![12,14,7,7,14,13,15,2,5,9,2,3,8,12,3,6,7,6,7,15,10,2,9,9,2,3,0,12,1,12,3,11,15,5,5,7] } }
theorem leafL_010_3_valid : (leafL_010_3).reject.ValidFor (leafL_010_3).leaf := by decide

noncomputable def leafL_010_4 : RejectedLeaf := { leaf := {0,1,17,34,52,67,92,249}, reject := .fullRank { members := ![0,1,17,34,52,67,92,249], points := ![107,112,122,141,151,158], inverse := ![11,12,9,15,6,6,8,9,11,14,14,10,9,12,14,13,5,3,6,0,7,14,0,15,2,9,7,15,3,0,5,9,10,14,11,3] } }
theorem leafL_010_4_valid : (leafL_010_4).reject.ValidFor (leafL_010_4).leaf := by decide

noncomputable def leafL_010_5 : RejectedLeaf := { leaf := {0,1,17,34,52,67,92,264}, reject := .fullRank { members := ![0,1,17,34,52,67,92,264], points := ![122,127,138,139,151,155], inverse := ![8,12,2,12,7,12,5,6,15,7,9,2,15,15,4,4,3,3,10,8,1,8,15,4,9,9,7,7,7,7,15,15,13,13,12,12] } }
theorem leafL_010_5_valid : (leafL_010_5).reject.ValidFor (leafL_010_5).leaf := by decide

noncomputable def leafL_010_6 : RejectedLeaf := { leaf := {0,1,17,34,52,67,92,266}, reject := .fullRank { members := ![0,1,17,34,52,67,92,266], points := ![107,109,137,141,149,159], inverse := ![5,12,8,5,3,6,1,3,3,7,14,8,12,12,7,7,12,12,12,1,12,13,0,12,4,4,15,15,7,7,6,6,8,8,12,12] } }
theorem leafL_010_6_valid : (leafL_010_6).reject.ValidFor (leafL_010_6).leaf := by decide

noncomputable def leafL_010_7 : RejectedLeaf := { leaf := {0,1,17,34,52,67,159,176}, reject := .fullRank { members := ![0,1,17,34,52,67,159,176], points := ![91,93,108,110,124,182], inverse := ![12,4,0,4,8,5,6,3,6,12,12,3,9,6,10,15,13,7,14,1,0,3,9,5,11,15,6,11,8,1,7,7,7,7,0,0] } }
theorem leafL_010_7_valid : (leafL_010_7).reject.ValidFor (leafL_010_7).leaf := by decide

noncomputable def leavesL_010 : List RejectedLeaf := [leafL_010_0,leafL_010_1,leafL_010_2,leafL_010_3,leafL_010_4,leafL_010_5,leafL_010_6,leafL_010_7]

theorem leavesL_010_valid : LeafListValid leavesL_010 := by
  intro x hx
  simp only [leavesL_010, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_010_0_valid
  · exact leafL_010_1_valid
  · exact leafL_010_2_valid
  · exact leafL_010_3_valid
  · exact leafL_010_4_valid
  · exact leafL_010_5_valid
  · exact leafL_010_6_valid
  · exact leafL_010_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
