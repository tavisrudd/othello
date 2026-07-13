import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_080_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,173}, reject := .fullRank { members := ![0,1,17,34,52,69,115,173], points := ![89,95,104,106,135,138], inverse := ![1,8,2,12,15,9,0,14,13,4,5,2,7,7,11,11,4,4,5,10,11,3,9,14,8,8,12,12,0,0,10,10,4,4,6,6] } }
theorem leafL_080_0_valid : (leafL_080_0).reject.ValidFor (leafL_080_0).leaf := by decide

noncomputable def leafL_080_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,182}, reject := .fullRank { members := ![0,1,17,34,52,69,115,182], points := ![93,95,106,107,110,135], inverse := ![13,4,6,5,13,6,13,3,8,9,8,7,0,0,10,2,8,0,10,5,4,12,0,7,11,11,4,1,5,0,9,9,4,12,8,0] } }
theorem leafL_080_1_valid : (leafL_080_1).reject.ValidFor (leafL_080_1).leaf := by decide

noncomputable def leafL_080_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,186}, reject := .fullRank { members := ![0,1,17,34,52,69,115,186], points := ![89,91,93,107,155,156], inverse := ![0,4,2,11,10,6,0,10,0,4,14,0,15,10,5,0,0,0,7,13,1,5,6,8,12,3,15,0,14,14,2,14,12,0,10,10] } }
theorem leafL_080_2_valid : (leafL_080_2).reject.ValidFor (leafL_080_2).leaf := by decide

noncomputable def leafL_080_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,189}, reject := .fullRank { members := ![0,1,17,34,52,69,115,189], points := ![104,106,107,135,138,150], inverse := ![0,6,15,3,14,5,15,6,11,14,10,6,12,1,13,0,0,0,10,12,11,13,12,12,4,8,12,7,7,0,14,1,15,4,4,0] } }
theorem leafL_080_3_valid : (leafL_080_3).reject.ValidFor (leafL_080_3).leaf := by decide

noncomputable def leafL_080_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,203}, reject := .fullRank { members := ![0,1,17,34,52,69,115,203], points := ![89,90,110,156,172,173], inverse := ![3,15,1,6,7,13,8,11,13,7,14,7,10,5,15,15,5,10,7,10,3,8,13,11,0,3,3,3,11,8,6,5,3,3,10,9] } }
theorem leafL_080_4_valid : (leafL_080_4).reject.ValidFor (leafL_080_4).leaf := by decide

noncomputable def leafL_080_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,207}, reject := .fullRank { members := ![0,1,17,34,52,69,115,207], points := ![90,91,135,139,155,172], inverse := ![1,14,13,2,11,10,0,6,0,9,15,0,11,13,11,9,7,3,8,7,3,13,13,12,14,5,1,9,15,12,10,7,7,13,8,15] } }
theorem leafL_080_5_valid : (leafL_080_5).reject.ValidFor (leafL_080_5).leaf := by decide

noncomputable def leafL_080_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,208}, reject := .fullRank { members := ![0,1,17,34,52,69,115,208], points := ![89,90,91,106,107,135], inverse := ![0,8,1,5,11,6,15,7,6,2,11,7,9,14,7,0,0,0,15,1,1,4,12,7,8,2,10,13,13,0,0,14,14,14,14,0] } }
theorem leafL_080_6_valid : (leafL_080_6).reject.ValidFor (leafL_080_6).leaf := by decide

noncomputable def leafL_080_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,214}, reject := .fullRank { members := ![0,1,17,34,52,69,115,214], points := ![89,93,106,107,135,138], inverse := ![11,2,4,10,14,8,0,14,1,8,12,11,13,13,9,9,4,4,4,11,9,1,5,2,10,10,1,1,10,10,8,8,4,4,15,15] } }
theorem leafL_080_7_valid : (leafL_080_7).reject.ValidFor (leafL_080_7).leaf := by decide

noncomputable def leavesL_080 : List RejectedLeaf := [leafL_080_0,leafL_080_1,leafL_080_2,leafL_080_3,leafL_080_4,leafL_080_5,leafL_080_6,leafL_080_7]

theorem leavesL_080_valid : LeafListValid leavesL_080 := by
  intro x hx
  simp only [leavesL_080, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_080_0_valid
  · exact leafL_080_1_valid
  · exact leafL_080_2_valid
  · exact leafL_080_3_valid
  · exact leafL_080_4_valid
  · exact leafL_080_5_valid
  · exact leafL_080_6_valid
  · exact leafL_080_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
