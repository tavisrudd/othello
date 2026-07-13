import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_316_0 : RejectedLeaf := { leaf := {0,1,17,34,52,75,159,249}, reject := .fullRank { members := ![0,1,17,34,52,75,159,249], points := ![86,103,104,109,122,125], inverse := ![15,6,8,6,13,11,9,8,14,8,2,5,0,12,5,9,0,0,8,8,10,13,12,11,0,1,14,15,14,14,0,13,2,15,8,8] } }
theorem leafL_316_0_valid : (leafL_316_0).reject.ValidFor (leafL_316_0).leaf := by decide

noncomputable def leafL_316_1 : RejectedLeaf := { leaf := {0,1,17,34,52,75,167,191}, reject := .fullRank { members := ![0,1,17,34,52,75,167,191], points := ![94,99,109,115,122,126], inverse := ![15,3,11,8,12,2,9,1,15,3,9,13,0,0,0,14,12,2,8,15,0,15,0,8,0,6,6,1,3,2,0,1,1,2,4,6] } }
theorem leafL_316_1_valid : (leafL_316_1).reject.ValidFor (leafL_316_1).leaf := by decide

noncomputable def leafL_316_2 : RejectedLeaf := { leaf := {0,1,17,34,52,75,167,197}, reject := .fullRank { members := ![0,1,17,34,52,75,167,197], points := ![90,93,94,99,109,115], inverse := ![6,11,2,3,11,6,15,7,1,14,0,7,6,11,13,0,0,0,10,13,15,9,6,7,5,2,7,12,12,0,4,2,6,3,3,0] } }
theorem leafL_316_2_valid : (leafL_316_2).reject.ValidFor (leafL_316_2).leaf := by decide

noncomputable def leafL_316_3 : RejectedLeaf := { leaf := {0,1,17,34,52,75,167,214}, reject := .fullRank { members := ![0,1,17,34,52,75,167,214], points := ![83,90,112,115,117,122], inverse := ![13,2,8,6,7,7,15,6,14,1,14,8,0,0,0,8,15,7,1,9,15,14,15,6,15,15,0,13,3,14,11,11,0,11,0,11] } }
theorem leafL_316_3_valid : (leafL_316_3).reject.ValidFor (leafL_316_3).leaf := by decide

noncomputable def leafL_316_4 : RejectedLeaf := { leaf := {0,1,17,34,52,75,167,229}, reject := .fullRank { members := ![0,1,17,34,52,75,167,229], points := ![83,95,104,122,126,140], inverse := ![0,2,5,5,14,13,3,5,1,4,12,15,6,15,9,0,9,9,5,0,2,15,5,13,9,7,14,9,7,14,14,12,2,15,13,2] } }
theorem leafL_316_4_valid : (leafL_316_4).reject.ValidFor (leafL_316_4).leaf := by decide

noncomputable def leafL_316_5 : RejectedLeaf := { leaf := {0,1,17,34,52,75,167,270}, reject := .fullRank { members := ![0,1,17,34,52,75,167,270], points := ![83,93,95,99,104,117], inverse := ![5,1,11,7,15,6,2,7,12,11,5,7,13,8,5,0,0,0,9,15,14,15,0,7,14,9,7,10,10,0,5,4,1,11,11,0] } }
theorem leafL_316_5_valid : (leafL_316_5).reject.ValidFor (leafL_316_5).leaf := by decide

noncomputable def leafL_316_6 : RejectedLeaf := { leaf := {0,1,17,34,52,75,168,266}, reject := .fullRank { members := ![0,1,17,34,52,75,168,266], points := ![86,93,95,103,109,117], inverse := ![10,13,8,8,0,6,12,4,1,6,8,7,10,1,11,0,0,0,4,9,5,9,6,7,14,15,1,5,5,0,15,1,14,12,12,0] } }
theorem leafL_316_6_valid : (leafL_316_6).reject.ValidFor (leafL_316_6).leaf := by decide

noncomputable def leafL_316_7 : RejectedLeaf := { leaf := {0,1,17,34,52,75,173,264}, reject := .fullRank { members := ![0,1,17,34,52,75,173,264], points := ![83,96,103,108,117,126], inverse := ![14,1,15,7,3,5,9,0,15,1,5,2,3,3,2,2,9,9,6,14,1,14,4,3,3,3,10,10,15,15,4,4,4,4,0,0] } }
theorem leafL_316_7_valid : (leafL_316_7).reject.ValidFor (leafL_316_7).leaf := by decide

noncomputable def leavesL_316 : List RejectedLeaf := [leafL_316_0,leafL_316_1,leafL_316_2,leafL_316_3,leafL_316_4,leafL_316_5,leafL_316_6,leafL_316_7]

theorem leavesL_316_valid : LeafListValid leavesL_316 := by
  intro x hx
  simp only [leavesL_316, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_316_0_valid
  · exact leafL_316_1_valid
  · exact leafL_316_2_valid
  · exact leafL_316_3_valid
  · exact leafL_316_4_valid
  · exact leafL_316_5_valid
  · exact leafL_316_6_valid
  · exact leafL_316_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
