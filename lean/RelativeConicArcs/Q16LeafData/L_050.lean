import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_050_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,248}, reject := .fullRank { members := ![0,1,17,34,52,69,95,248], points := ![99,106,124,131,137,138], inverse := ![9,14,9,3,10,6,3,4,14,2,4,15,0,0,0,9,12,5,10,13,15,8,8,8,4,4,0,13,13,0,11,11,0,11,0,11] } }
theorem leafL_050_0_valid : (leafL_050_0).reject.ValidFor (leafL_050_0).leaf := by decide

noncomputable def leafL_050_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,249}, reject := .fullRank { members := ![0,1,17,34,52,69,95,249], points := ![103,107,112,115,120,131], inverse := ![0,11,12,6,15,15,12,14,5,14,0,9,7,2,5,0,0,0,12,13,6,12,3,8,8,15,7,14,14,0,0,8,8,8,8,0] } }
theorem leafL_050_1_valid : (leafL_050_1).reject.ValidFor (leafL_050_1).leaf := by decide

noncomputable def leafL_050_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,254}, reject := .fullRank { members := ![0,1,17,34,52,69,95,254], points := ![103,107,120,131,138,139], inverse := ![9,14,9,11,13,9,4,3,14,0,5,12,0,0,0,6,3,5,12,11,15,7,3,12,8,8,0,4,10,14,5,5,0,2,6,4] } }
theorem leafL_050_2_valid : (leafL_050_2).reject.ValidFor (leafL_050_2).leaf := by decide

noncomputable def leafL_050_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,256}, reject := .fullRank { members := ![0,1,17,34,52,69,95,256], points := ![103,106,115,126,137,141], inverse := ![8,15,15,6,8,7,6,1,14,0,5,12,11,11,5,5,12,12,8,15,3,12,1,9,0,0,13,13,8,8,9,9,9,9,0,0] } }
theorem leafL_050_3_valid : (leafL_050_3).reject.ValidFor (leafL_050_3).leaf := by decide

noncomputable def leafL_050_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,262}, reject := .fullRank { members := ![0,1,17,34,52,69,95,262], points := ![99,103,106,120,124,137], inverse := ![4,9,10,13,4,15,7,11,11,10,4,9,12,2,14,0,0,0,6,8,9,2,13,8,1,4,5,13,13,0,12,11,7,6,6,0] } }
theorem leafL_050_4_valid : (leafL_050_4).reject.ValidFor (leafL_050_4).leaf := by decide

noncomputable def leafL_050_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,265}, reject := .fullRank { members := ![0,1,17,34,52,69,95,265], points := ![103,107,112,115,124,138], inverse := ![15,8,0,1,8,15,0,11,12,13,3,9,7,2,5,0,0,0,6,1,0,7,8,8,14,1,15,6,6,0,15,0,15,15,15,0] } }
theorem leafL_050_5_valid : (leafL_050_5).reject.ValidFor (leafL_050_5).leaf := by decide

noncomputable def leafL_050_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,270}, reject := .fullRank { members := ![0,1,17,34,52,69,95,270], points := ![99,112,124,131,137,138], inverse := ![1,6,9,8,3,4,9,14,14,15,2,4,0,0,0,9,12,5,12,11,15,2,10,0,14,14,0,0,11,11,2,2,0,3,7,4] } }
theorem leafL_050_6_valid : (leafL_050_6).reject.ValidFor (leafL_050_6).leaf := by decide

noncomputable def leafL_050_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,99}, reject := .fullRank { members := ![0,1,17,34,52,69,96,99], points := ![120,122,141,151,154,156], inverse := ![13,9,14,11,8,8,2,1,8,11,1,1,0,0,0,6,4,2,4,6,9,1,7,13,14,14,0,4,12,8,5,5,0,1,7,6] } }
theorem leafL_050_7_valid : (leafL_050_7).reject.ValidFor (leafL_050_7).leaf := by decide

noncomputable def leavesL_050 : List RejectedLeaf := [leafL_050_0,leafL_050_1,leafL_050_2,leafL_050_3,leafL_050_4,leafL_050_5,leafL_050_6,leafL_050_7]

theorem leavesL_050_valid : LeafListValid leavesL_050 := by
  intro x hx
  simp only [leavesL_050, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_050_0_valid
  · exact leafL_050_1_valid
  · exact leafL_050_2_valid
  · exact leafL_050_3_valid
  · exact leafL_050_4_valid
  · exact leafL_050_5_valid
  · exact leafL_050_6_valid
  · exact leafL_050_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
