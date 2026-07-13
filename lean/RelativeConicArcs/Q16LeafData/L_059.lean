import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_059_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,236}, reject := .fullRank { members := ![0,1,17,34,52,69,103,236], points := ![86,93,126,131,152,154], inverse := ![1,2,12,7,1,8,12,4,7,5,10,0,8,6,7,12,15,10,15,5,7,10,9,14,3,0,8,9,7,5,12,13,9,7,15,0] } }
theorem leafL_059_0_valid : (leafL_059_0).reject.ValidFor (leafL_059_0).leaf := by decide

noncomputable def leafL_059_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,249}, reject := .fullRank { members := ![0,1,17,34,52,69,103,249], points := ![94,95,126,131,154,156], inverse := ![12,4,0,3,5,15,15,14,10,15,0,4,3,12,14,11,15,5,2,10,6,4,15,5,1,6,10,6,0,11,11,7,6,2,9,1] } }
theorem leafL_059_1_valid : (leafL_059_1).reject.ValidFor (leafL_059_1).leaf := by decide

noncomputable def leafL_059_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,254}, reject := .fullRank { members := ![0,1,17,34,52,69,103,254], points := ![93,95,96,128,131,139], inverse := ![8,3,12,14,14,6,15,2,10,9,2,12,7,9,14,0,0,0,9,13,3,8,2,13,12,11,7,0,7,7,6,4,2,0,5,5] } }
theorem leafL_059_2_valid : (leafL_059_2).reject.ValidFor (leafL_059_2).leaf := by decide

noncomputable def leafL_059_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,256}, reject := .fullRank { members := ![0,1,17,34,52,69,103,256], points := ![93,95,126,127,137,150], inverse := ![5,4,10,7,9,4,9,0,4,10,2,5,0,3,2,10,9,2,11,10,10,1,14,4,8,8,15,15,0,0,13,5,6,2,13,1] } }
theorem leafL_059_3_valid : (leafL_059_3).reject.ValidFor (leafL_059_3).leaf := by decide

noncomputable def leafL_059_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,262}, reject := .fullRank { members := ![0,1,17,34,52,69,103,262], points := ![91,95,96,124,126,156], inverse := ![11,7,14,13,8,6,5,5,5,8,0,13,6,13,11,0,0,0,15,6,10,8,2,9,4,4,0,14,14,0,9,2,11,10,10,0] } }
theorem leafL_059_4_valid : (leafL_059_4).reject.ValidFor (leafL_059_4).leaf := by decide

noncomputable def leafL_059_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,265}, reject := .fullRank { members := ![0,1,17,34,52,69,103,265], points := ![93,94,95,124,128,139], inverse := ![12,7,12,1,15,8,0,5,2,6,15,14,9,14,7,0,0,0,15,12,4,6,14,15,15,11,4,9,9,0,5,1,4,15,15,0] } }
theorem leafL_059_5_valid : (leafL_059_5).reject.ValidFor (leafL_059_5).leaf := by decide

noncomputable def leafL_059_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,268}, reject := .fullRank { members := ![0,1,17,34,52,69,103,268], points := ![91,93,95,127,128,131], inverse := ![10,5,8,14,0,8,8,2,13,15,6,14,5,10,15,0,0,0,8,11,4,3,11,15,7,6,1,2,2,0,14,2,12,9,9,0] } }
theorem leafL_059_6_valid : (leafL_059_6).reject.ValidFor (leafL_059_6).leaf := by decide

noncomputable def leafL_059_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,271}, reject := .fullRank { members := ![0,1,17,34,52,69,103,271], points := ![91,94,96,126,137,150], inverse := ![3,1,5,14,8,0,8,11,9,6,11,7,15,3,12,0,0,0,4,2,0,1,8,15,4,14,1,12,4,3,15,13,4,3,1,4] } }
theorem leafL_059_7_valid : (leafL_059_7).reject.ValidFor (leafL_059_7).leaf := by decide

noncomputable def leavesL_059 : List RejectedLeaf := [leafL_059_0,leafL_059_1,leafL_059_2,leafL_059_3,leafL_059_4,leafL_059_5,leafL_059_6,leafL_059_7]

theorem leavesL_059_valid : LeafListValid leavesL_059 := by
  intro x hx
  simp only [leavesL_059, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_059_0_valid
  · exact leafL_059_1_valid
  · exact leafL_059_2_valid
  · exact leafL_059_3_valid
  · exact leafL_059_4_valid
  · exact leafL_059_5_valid
  · exact leafL_059_6_valid
  · exact leafL_059_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
