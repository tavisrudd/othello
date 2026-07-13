import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_098_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,135,173}, reject := .fullRank { members := ![0,1,17,34,52,69,135,173], points := ![89,92,94,106,115,122], inverse := ![3,12,0,8,5,3,6,11,4,14,0,7,8,12,4,0,0,0,3,15,4,15,12,11,1,1,0,0,10,10,1,2,3,0,11,11] } }
theorem leafL_098_0_valid : (leafL_098_0).reject.ValidFor (leafL_098_0).leaf := by decide

noncomputable def leafL_098_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,135,182}, reject := .fullRank { members := ![0,1,17,34,52,69,135,182], points := ![92,94,99,106,112,115], inverse := ![0,15,13,15,10,6,12,5,8,13,11,7,0,0,7,8,15,0,9,1,5,10,0,7,8,8,1,10,11,0,7,7,0,7,7,0] } }
theorem leafL_098_1_valid : (leafL_098_1).reject.ValidFor (leafL_098_1).leaf := by decide

noncomputable def leafL_098_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,135,195}, reject := .fullRank { members := ![0,1,17,34,52,69,135,195], points := ![89,91,94,126,127,150], inverse := ![4,15,9,8,13,6,10,9,6,12,4,13,12,3,15,0,0,0,1,13,15,7,13,9,8,8,0,15,15,0,11,5,14,7,7,0] } }
theorem leafL_098_2_valid : (leafL_098_2).reject.ValidFor (leafL_098_2).leaf := by decide

noncomputable def leafL_098_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,135,198}, reject := .fullRank { members := ![0,1,17,34,52,69,135,198], points := ![90,91,92,99,106,126], inverse := ![14,7,6,8,0,6,12,8,13,12,2,7,7,14,9,0,0,0,5,2,15,7,8,7,11,0,11,7,7,0,3,7,4,5,5,0] } }
theorem leafL_098_3_valid : (leafL_098_3).reject.ValidFor (leafL_098_3).leaf := by decide

noncomputable def leafL_098_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,135,207}, reject := .fullRank { members := ![0,1,17,34,52,69,135,207], points := ![89,90,91,99,110,115], inverse := ![8,9,14,4,12,6,5,11,7,14,0,7,9,14,7,0,0,0,3,9,2,12,3,7,3,1,2,6,6,0,6,10,12,8,8,0] } }
theorem leafL_098_4_valid : (leafL_098_4).reject.ValidFor (leafL_098_4).leaf := by decide

noncomputable def leafL_098_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,135,214}, reject := .fullRank { members := ![0,1,17,34,52,69,135,214], points := ![89,92,94,99,106,115], inverse := ![1,8,6,6,14,6,13,14,10,14,0,7,8,12,4,0,0,0,0,9,1,5,10,7,13,10,7,7,7,0,2,4,6,5,5,0] } }
theorem leafL_098_5_valid : (leafL_098_5).reject.ValidFor (leafL_098_5).leaf := by decide

noncomputable def leafL_098_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,135,217}, reject := .fullRank { members := ![0,1,17,34,52,69,135,217], points := ![91,94,99,115,122,124], inverse := ![14,1,8,1,7,0,2,11,14,2,12,9,0,0,0,10,11,1,0,8,15,12,15,4,10,10,0,11,7,12,3,3,0,2,4,6] } }
theorem leafL_098_6_valid : (leafL_098_6).reject.ValidFor (leafL_098_6).leaf := by decide

noncomputable def leafL_098_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,135,232}, reject := .fullRank { members := ![0,1,17,34,52,69,135,232], points := ![89,92,94,112,115,122], inverse := ![6,14,7,8,4,2,4,1,12,14,5,2,8,12,4,0,0,0,7,8,7,15,6,1,1,1,0,0,10,10,1,2,3,0,11,11] } }
theorem leafL_098_7_valid : (leafL_098_7).reject.ValidFor (leafL_098_7).leaf := by decide

noncomputable def leavesL_098 : List RejectedLeaf := [leafL_098_0,leafL_098_1,leafL_098_2,leafL_098_3,leafL_098_4,leafL_098_5,leafL_098_6,leafL_098_7]

theorem leavesL_098_valid : LeafListValid leavesL_098 := by
  intro x hx
  simp only [leavesL_098, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_098_0_valid
  · exact leafL_098_1_valid
  · exact leafL_098_2_valid
  · exact leafL_098_3_valid
  · exact leafL_098_4_valid
  · exact leafL_098_5_valid
  · exact leafL_098_6_valid
  · exact leafL_098_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
