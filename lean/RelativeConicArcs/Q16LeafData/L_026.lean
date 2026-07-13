import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_026_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,99}, reject := .fullRank { members := ![0,1,17,34,52,69,91,99], points := ![120,135,138,144,150,151], inverse := ![4,9,1,6,11,0,3,3,15,4,8,3,0,3,13,14,0,0,2,12,11,14,2,9,0,13,9,4,10,10,0,1,7,6,9,9] } }
theorem leafL_026_0_valid : (leafL_026_0).reject.ValidFor (leafL_026_0).leaf := by decide

noncomputable def leafL_026_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,103}, reject := .fullRank { members := ![0,1,17,34,52,69,91,103], points := ![137,154,159,169,172,174], inverse := ![10,0,15,0,4,0,11,13,5,13,9,7,0,0,0,8,12,4,11,15,6,5,0,7,0,3,3,1,5,4,0,6,6,8,11,3] } }
theorem leafL_026_1_valid : (leafL_026_1).reject.ValidFor (leafL_026_1).leaf := by decide

noncomputable def leafL_026_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,104}, reject := .fullRank { members := ![0,1,17,34,52,69,91,104], points := ![115,137,138,159,169,172], inverse := ![0,10,0,15,0,4,15,12,8,7,15,3,1,12,13,1,15,14,0,5,14,9,8,10,0,8,8,0,7,7,6,13,11,6,5,3] } }
theorem leafL_026_2_valid : (leafL_026_2).reject.ValidFor (leafL_026_2).leaf := by decide

noncomputable def leafL_026_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,106}, reject := .fullRank { members := ![0,1,17,34,52,69,91,106], points := ![115,120,135,159,169,172], inverse := ![0,12,6,3,1,9,8,11,8,11,6,6,7,1,6,6,1,7,8,9,10,8,12,15,7,2,5,5,11,14,15,2,13,13,12,1] } }
theorem leafL_026_3_valid : (leafL_026_3).reject.ValidFor (leafL_026_3).leaf := by decide

noncomputable def leafL_026_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,110}, reject := .fullRank { members := ![0,1,17,34,52,69,91,110], points := ![115,122,135,137,144,159], inverse := ![15,11,12,9,11,11,11,8,10,8,10,11,0,0,6,10,12,0,0,2,10,12,15,11,8,8,13,3,14,0,5,5,14,7,9,0] } }
theorem leafL_026_4_valid : (leafL_026_4).reject.ValidFor (leafL_026_4).leaf := by decide

noncomputable def leafL_026_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,112}, reject := .fullRank { members := ![0,1,17,34,52,69,91,112], points := ![120,122,135,151,154,163], inverse := ![14,0,4,4,5,10,1,6,12,10,5,4,10,8,2,9,11,2,10,6,7,14,11,14,0,8,8,13,5,8,8,14,6,3,5,6] } }
theorem leafL_026_5_valid : (leafL_026_5).reject.ValidFor (leafL_026_5).leaf := by decide

noncomputable def leafL_026_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,115}, reject := .fullRank { members := ![0,1,17,34,52,69,91,115], points := ![104,106,110,138,150,151], inverse := ![14,5,2,13,4,1,8,5,15,4,13,11,7,4,3,0,0,0,15,7,5,1,6,10,14,0,14,0,12,12,11,8,3,0,13,13] } }
theorem leafL_026_6_valid : (leafL_026_6).reject.ValidFor (leafL_026_6).leaf := by decide

noncomputable def leafL_026_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,120}, reject := .fullRank { members := ![0,1,17,34,52,69,91,120], points := ![99,106,112,144,151,159], inverse := ![5,13,1,13,5,0,9,11,0,4,4,2,7,8,15,0,0,0,7,2,8,1,6,10,3,14,13,0,11,11,5,13,8,0,9,9] } }
theorem leafL_026_7_valid : (leafL_026_7).reject.ValidFor (leafL_026_7).leaf := by decide

noncomputable def leavesL_026 : List RejectedLeaf := [leafL_026_0,leafL_026_1,leafL_026_2,leafL_026_3,leafL_026_4,leafL_026_5,leafL_026_6,leafL_026_7]

theorem leavesL_026_valid : LeafListValid leavesL_026 := by
  intro x hx
  simp only [leavesL_026, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_026_0_valid
  · exact leafL_026_1_valid
  · exact leafL_026_2_valid
  · exact leafL_026_3_valid
  · exact leafL_026_4_valid
  · exact leafL_026_5_valid
  · exact leafL_026_6_valid
  · exact leafL_026_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
