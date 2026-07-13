import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_043_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,169}, reject := .fullRank { members := ![0,1,17,34,52,69,94,169], points := ![99,103,104,122,127,131], inverse := ![5,14,12,0,9,15,14,11,2,11,5,9,6,13,11,0,0,0,13,11,1,1,14,8,15,4,11,10,10,0,12,7,11,2,2,0] } }
theorem leafL_043_0_valid : (leafL_043_0).reject.ValidFor (leafL_043_0).leaf := by decide

noncomputable def leafL_043_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,171}, reject := .fullRank { members := ![0,1,17,34,52,69,94,171], points := ![103,106,120,127,128,151], inverse := ![6,10,2,14,2,3,13,0,1,1,1,12,0,0,13,2,15,0,9,3,10,2,5,7,3,3,10,12,6,0,9,9,6,11,13,0] } }
theorem leafL_043_1_valid : (leafL_043_1).reject.ValidFor (leafL_043_1).leaf := by decide

noncomputable def leafL_043_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,172}, reject := .fullRank { members := ![0,1,17,34,52,69,94,172], points := ![104,106,107,120,122,135], inverse := ![9,14,0,12,5,15,10,7,10,15,1,9,12,1,13,0,0,0,4,14,13,11,4,8,2,8,10,5,5,0,1,1,0,1,1,0] } }
theorem leafL_043_2_valid : (leafL_043_2).reject.ValidFor (leafL_043_2).leaf := by decide

noncomputable def leafL_043_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,195}, reject := .fullRank { members := ![0,1,17,34,52,69,94,195], points := ![103,104,106,127,135,144], inverse := ![1,2,4,9,14,1,13,3,9,14,1,8,8,3,11,0,0,0,4,11,8,15,13,5,15,0,15,0,5,5,15,5,10,0,1,1] } }
theorem leafL_043_3_valid : (leafL_043_3).reject.ValidFor (leafL_043_3).leaf := by decide

noncomputable def leafL_043_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,205}, reject := .fullRank { members := ![0,1,17,34,52,69,94,205], points := ![104,106,107,120,122,131], inverse := ![9,2,12,13,4,15,10,2,15,11,5,9,12,1,13,0,0,0,4,1,2,7,8,8,2,8,10,5,5,0,1,1,0,1,1,0] } }
theorem leafL_043_4_valid : (leafL_043_4).reject.ValidFor (leafL_043_4).leaf := by decide

noncomputable def leafL_043_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,207}, reject := .fullRank { members := ![0,1,17,34,52,69,94,207], points := ![99,120,122,128,131,135], inverse := ![7,0,7,14,12,3,7,4,2,8,9,0,0,2,9,11,0,0,7,0,8,7,1,9,0,7,3,4,8,8,0,4,6,2,13,13] } }
theorem leafL_043_5_valid : (leafL_043_5).reject.ValidFor (leafL_043_5).leaf := by decide

noncomputable def leafL_043_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,211}, reject := .fullRank { members := ![0,1,17,34,52,69,94,211], points := ![103,112,120,122,127,151], inverse := ![7,11,14,11,11,3,13,0,6,15,8,12,0,0,6,10,12,0,14,4,12,7,6,7,4,4,5,5,0,0,15,15,15,0,15,0] } }
theorem leafL_043_6_valid : (leafL_043_6).reject.ValidFor (leafL_043_6).leaf := by decide

noncomputable def leafL_043_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,214}, reject := .fullRank { members := ![0,1,17,34,52,69,94,214], points := ![99,103,106,120,122,135], inverse := ![2,3,6,12,5,15,9,13,3,15,1,9,12,2,14,0,0,0,10,7,10,11,4,8,15,8,7,5,5,0,4,6,2,1,1,0] } }
theorem leafL_043_7_valid : (leafL_043_7).reject.ValidFor (leafL_043_7).leaf := by decide

noncomputable def leavesL_043 : List RejectedLeaf := [leafL_043_0,leafL_043_1,leafL_043_2,leafL_043_3,leafL_043_4,leafL_043_5,leafL_043_6,leafL_043_7]

theorem leavesL_043_valid : LeafListValid leavesL_043 := by
  intro x hx
  simp only [leavesL_043, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_043_0_valid
  · exact leafL_043_1_valid
  · exact leafL_043_2_valid
  · exact leafL_043_3_valid
  · exact leafL_043_4_valid
  · exact leafL_043_5_valid
  · exact leafL_043_6_valid
  · exact leafL_043_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
