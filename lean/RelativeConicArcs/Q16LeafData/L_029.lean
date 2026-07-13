import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_029_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,195}, reject := .fullRank { members := ![0,1,17,34,52,69,91,195], points := ![104,106,135,137,144,151], inverse := ![9,0,0,0,13,5,4,6,12,11,3,6,0,0,6,10,12,0,12,1,5,6,2,12,13,13,12,8,4,0,8,8,8,8,0,0] } }
theorem leafL_029_0_valid : (leafL_029_0).reject.ValidFor (leafL_029_0).leaf := by decide

noncomputable def leafL_029_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,198}, reject := .fullRank { members := ![0,1,17,34,52,69,91,198], points := ![99,104,106,120,135,137], inverse := ![0,2,5,9,1,14,14,12,5,14,1,8,1,14,15,0,0,0,1,4,2,15,14,6,14,6,8,0,14,14,0,8,8,0,8,8] } }
theorem leafL_029_1_valid : (leafL_029_1).reject.ValidFor (leafL_029_1).leaf := by decide

noncomputable def leafL_029_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,201}, reject := .fullRank { members := ![0,1,17,34,52,69,91,201], points := ![99,103,104,120,122,138], inverse := ![8,3,12,11,2,15,5,14,12,0,14,9,6,13,11,0,0,0,10,15,2,9,6,8,10,6,12,5,5,0,13,2,15,1,1,0] } }
theorem leafL_029_2_valid : (leafL_029_2).reject.ValidFor (leafL_029_2).leaf := by decide

noncomputable def leafL_029_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,205}, reject := .fullRank { members := ![0,1,17,34,52,69,91,205], points := ![104,106,120,122,135,138], inverse := ![9,14,12,5,15,0,0,7,0,14,0,9,1,1,2,2,8,8,9,14,9,6,0,8,8,8,10,10,9,9,1,1,1,1,0,0] } }
theorem leafL_029_3_valid : (leafL_029_3).reject.ValidFor (leafL_029_3).leaf := by decide

noncomputable def leafL_029_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,207}, reject := .fullRank { members := ![0,1,17,34,52,69,91,207], points := ![99,103,110,115,120,135], inverse := ![11,1,13,14,7,15,9,4,10,8,6,9,2,12,14,0,0,0,12,3,8,6,9,8,7,11,12,14,14,0,5,14,11,8,8,0] } }
theorem leafL_029_4_valid : (leafL_029_4).reject.ValidFor (leafL_029_4).leaf := by decide

noncomputable def leafL_029_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,208}, reject := .fullRank { members := ![0,1,17,34,52,69,91,208], points := ![103,106,115,135,138,151], inverse := ![15,13,7,11,9,6,2,0,0,4,0,6,15,7,12,12,9,1,6,11,0,10,11,12,5,4,8,15,9,15,4,4,0,4,4,0] } }
theorem leafL_029_5_valid : (leafL_029_5).reject.ValidFor (leafL_029_5).leaf := by decide

noncomputable def leafL_029_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,217}, reject := .fullRank { members := ![0,1,17,34,52,69,91,217], points := ![99,115,120,122,135,138], inverse := ![7,2,9,2,1,14,7,11,3,6,10,3,0,1,14,15,0,0,7,2,12,1,14,6,0,8,0,8,5,5,0,1,13,12,8,8] } }
theorem leafL_029_6_valid : (leafL_029_6).reject.ValidFor (leafL_029_6).leaf := by decide

noncomputable def leafL_029_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,220}, reject := .fullRank { members := ![0,1,17,34,52,69,91,220], points := ![103,106,110,115,135,138], inverse := ![9,0,14,9,5,10,4,13,14,14,10,3,14,2,12,0,0,0,10,2,15,15,5,13,10,2,8,0,7,7,4,4,0,0,4,4] } }
theorem leafL_029_7_valid : (leafL_029_7).reject.ValidFor (leafL_029_7).leaf := by decide

noncomputable def leavesL_029 : List RejectedLeaf := [leafL_029_0,leafL_029_1,leafL_029_2,leafL_029_3,leafL_029_4,leafL_029_5,leafL_029_6,leafL_029_7]

theorem leavesL_029_valid : LeafListValid leavesL_029 := by
  intro x hx
  simp only [leavesL_029, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_029_0_valid
  · exact leafL_029_1_valid
  · exact leafL_029_2_valid
  · exact leafL_029_3_valid
  · exact leafL_029_4_valid
  · exact leafL_029_5_valid
  · exact leafL_029_6_valid
  · exact leafL_029_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
