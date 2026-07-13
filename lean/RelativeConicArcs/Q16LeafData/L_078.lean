import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_078_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,230}, reject := .fullRank { members := ![0,1,17,34,52,69,112,230], points := ![89,90,91,120,122,131], inverse := ![12,0,11,7,9,8,14,15,6,7,14,14,9,14,7,0,0,0,8,5,10,10,2,15,5,7,2,6,6,0,14,2,12,8,8,0] } }
theorem leafL_078_0_valid : (leafL_078_0).reject.ValidFor (leafL_078_0).leaf := by decide

noncomputable def leafL_078_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,232}, reject := .fullRank { members := ![0,1,17,34,52,69,112,232], points := ![89,94,122,126,135,139], inverse := ![9,14,6,8,0,8,3,4,9,0,10,4,12,12,2,2,10,10,13,10,11,3,11,4,12,12,7,7,3,3,10,10,14,14,5,5] } }
theorem leafL_078_1_valid : (leafL_078_1).reject.ValidFor (leafL_078_1).leaf := by decide

noncomputable def leafL_078_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,249}, reject := .fullRank { members := ![0,1,17,34,52,69,112,249], points := ![90,94,95,120,122,131], inverse := ![0,13,10,7,9,8,6,1,0,7,14,14,8,10,2,0,0,0,12,14,5,10,2,15,15,9,6,6,6,0,1,11,10,8,8,0] } }
theorem leafL_078_2_valid : (leafL_078_2).reject.ValidFor (leafL_078_2).leaf := by decide

noncomputable def leafL_078_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,265}, reject := .fullRank { members := ![0,1,17,34,52,69,112,265], points := ![90,95,120,124,135,139], inverse := ![9,14,7,9,13,5,10,13,6,15,2,12,13,13,12,12,8,8,4,3,7,15,8,7,3,3,12,12,3,3,0,0,10,10,10,10] } }
theorem leafL_078_3_valid : (leafL_078_3).reject.ValidFor (leafL_078_3).leaf := by decide

noncomputable def leafL_078_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,268}, reject := .fullRank { members := ![0,1,17,34,52,69,112,268], points := ![89,90,95,120,122,131], inverse := ![9,1,15,7,9,8,2,2,7,7,14,14,7,6,1,0,0,0,15,1,9,10,2,15,1,13,12,6,6,0,5,11,14,8,8,0] } }
theorem leafL_078_4_valid : (leafL_078_4).reject.ValidFor (leafL_078_4).leaf := by decide

noncomputable def leafL_078_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,269}, reject := .fullRank { members := ![0,1,17,34,52,69,112,269], points := ![90,91,94,120,124,131], inverse := ![12,5,14,13,3,8,2,10,15,11,2,14,10,2,8,0,0,0,2,12,9,4,12,15,7,14,9,7,7,0,1,8,9,5,5,0] } }
theorem leafL_078_5_valid : (leafL_078_5).reject.ValidFor (leafL_078_5).leaf := by decide

noncomputable def leafL_078_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,270}, reject := .fullRank { members := ![0,1,17,34,52,69,112,270], points := ![91,95,122,124,131,135], inverse := ![1,6,8,6,8,0,6,1,11,2,3,13,3,3,10,10,6,6,6,1,7,15,11,4,15,15,14,14,5,5,10,10,0,0,10,10] } }
theorem leafL_078_6_valid : (leafL_078_6).reject.ValidFor (leafL_078_6).leaf := by decide

noncomputable def leafL_078_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,271}, reject := .fullRank { members := ![0,1,17,34,52,69,112,271], points := ![89,91,94,122,124,141], inverse := ![5,12,14,10,4,8,9,14,0,5,12,14,12,3,15,0,0,0,0,6,1,12,4,15,3,14,13,1,1,0,13,13,0,13,13,0] } }
theorem leafL_078_7_valid : (leafL_078_7).reject.ValidFor (leafL_078_7).leaf := by decide

noncomputable def leavesL_078 : List RejectedLeaf := [leafL_078_0,leafL_078_1,leafL_078_2,leafL_078_3,leafL_078_4,leafL_078_5,leafL_078_6,leafL_078_7]

theorem leavesL_078_valid : LeafListValid leavesL_078 := by
  intro x hx
  simp only [leavesL_078, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_078_0_valid
  · exact leafL_078_1_valid
  · exact leafL_078_2_valid
  · exact leafL_078_3_valid
  · exact leafL_078_4_valid
  · exact leafL_078_5_valid
  · exact leafL_078_6_valid
  · exact leafL_078_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
