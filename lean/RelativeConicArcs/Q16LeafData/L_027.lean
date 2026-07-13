import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_027_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,122}, reject := .fullRank { members := ![0,1,17,34,52,69,91,122], points := ![110,112,135,137,150,151], inverse := ![1,8,8,5,6,3,1,3,14,10,3,5,14,14,4,4,15,15,11,6,7,6,9,5,0,0,7,7,10,10,15,15,3,3,4,4] } }
theorem leafL_027_0_valid : (leafL_027_0).reject.ValidFor (leafL_027_0).leaf := by decide

noncomputable def leafL_027_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,135}, reject := .fullRank { members := ![0,1,17,34,52,69,91,135], points := ![99,106,110,122,150,159], inverse := ![3,1,14,14,15,12,8,0,5,1,10,6,14,12,2,0,0,0,1,4,15,13,7,0,5,0,5,0,8,8,7,7,0,0,7,7] } }
theorem leafL_027_1_valid : (leafL_027_1).reject.ValidFor (leafL_027_1).leaf := by decide

noncomputable def leafL_027_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,137}, reject := .fullRank { members := ![0,1,17,34,52,69,91,137], points := ![103,104,110,122,150,154], inverse := ![10,5,3,14,8,11,3,8,6,1,0,12,5,12,9,0,0,0,8,13,15,13,7,0,1,3,2,0,3,3,1,8,9,0,14,14] } }
theorem leafL_027_2_valid : (leafL_027_2).reject.ValidFor (leafL_027_2).leaf := by decide

noncomputable def leafL_027_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,138}, reject := .fullRank { members := ![0,1,17,34,52,69,91,138], points := ![99,104,115,150,172,174], inverse := ![9,4,0,10,14,8,12,9,8,8,0,5,2,12,11,7,14,12,12,10,9,1,1,15,0,7,12,10,8,9,11,1,6,5,9,0] } }
theorem leafL_027_3_valid : (leafL_027_3).reject.ValidFor (leafL_027_3).leaf := by decide

noncomputable def leafL_027_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,144}, reject := .fullRank { members := ![0,1,17,34,52,69,91,144], points := ![99,110,120,150,154,159], inverse := ![0,12,14,3,0,0,7,10,1,12,15,15,0,0,0,4,9,13,13,7,13,2,0,5,5,5,0,8,0,8,6,6,0,11,8,3] } }
theorem leafL_027_4_valid : (leafL_027_4).reject.ValidFor (leafL_027_4).leaf := by decide

noncomputable def leafL_027_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,150}, reject := .fullRank { members := ![0,1,17,34,52,69,91,150], points := ![99,115,122,135,137,138], inverse := ![7,10,3,6,11,2,7,14,0,11,15,13,0,0,0,11,3,8,7,5,10,10,9,11,0,8,8,5,0,5,0,5,5,2,12,14] } }
theorem leafL_027_5_valid : (leafL_027_5).reject.ValidFor (leafL_027_5).leaf := by decide

noncomputable def leafL_027_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,151}, reject := .fullRank { members := ![0,1,17,34,52,69,91,151], points := ![99,112,115,120,122,172], inverse := ![10,0,4,2,10,7,10,12,0,3,10,15,0,0,1,14,15,0,10,14,12,8,2,2,8,8,8,12,4,0,13,13,1,15,14,0] } }
theorem leafL_027_6_valid : (leafL_027_6).reject.ValidFor (leafL_027_6).leaf := by decide

noncomputable def leafL_027_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,154}, reject := .fullRank { members := ![0,1,17,34,52,69,91,154], points := ![99,103,112,137,144,163], inverse := ![6,15,13,0,7,2,2,10,13,12,4,13,1,9,8,0,0,0,15,4,8,9,3,9,1,14,15,15,15,0,7,11,12,3,3,0] } }
theorem leafL_027_7_valid : (leafL_027_7).reject.ValidFor (leafL_027_7).leaf := by decide

noncomputable def leavesL_027 : List RejectedLeaf := [leafL_027_0,leafL_027_1,leafL_027_2,leafL_027_3,leafL_027_4,leafL_027_5,leafL_027_6,leafL_027_7]

theorem leavesL_027_valid : LeafListValid leavesL_027 := by
  intro x hx
  simp only [leavesL_027, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_027_0_valid
  · exact leafL_027_1_valid
  · exact leafL_027_2_valid
  · exact leafL_027_3_valid
  · exact leafL_027_4_valid
  · exact leafL_027_5_valid
  · exact leafL_027_6_valid
  · exact leafL_027_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
