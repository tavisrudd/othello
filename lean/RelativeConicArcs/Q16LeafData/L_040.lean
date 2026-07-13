import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_040_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,236}, reject := .fullRank { members := ![0,1,17,34,52,69,93,236], points := ![103,110,115,120,126,137], inverse := ![1,6,3,11,1,15,14,9,4,1,11,9,0,0,7,13,10,0,5,2,15,9,9,8,10,10,13,5,8,0,3,3,12,14,2,0] } }
theorem leafL_040_0_valid : (leafL_040_0).reject.ValidFor (leafL_040_0).leaf := by decide

noncomputable def leafL_040_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,247}, reject := .fullRank { members := ![0,1,17,34,52,69,93,247], points := ![99,115,120,124,137,139], inverse := ![7,12,4,1,15,0,7,13,15,12,2,11,0,5,2,7,0,0,7,12,8,11,7,15,0,3,12,15,3,3,0,3,5,6,9,9] } }
theorem leafL_040_1_valid : (leafL_040_1).reject.ValidFor (leafL_040_1).leaf := by decide

noncomputable def leafL_040_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,248}, reject := .fullRank { members := ![0,1,17,34,52,69,93,248], points := ![99,110,115,124,128,144], inverse := ![11,12,1,7,15,15,9,14,15,5,4,9,0,0,8,9,1,0,7,0,7,0,8,8,3,3,8,13,5,0,9,9,12,14,2,0] } }
theorem leafL_040_2_valid : (leafL_040_2).reject.ValidFor (leafL_040_2).leaf := by decide

noncomputable def leafL_040_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,256}, reject := .fullRank { members := ![0,1,17,34,52,69,93,256], points := ![99,103,126,127,137,152], inverse := ![7,0,9,0,15,0,0,6,5,3,15,15,15,10,4,10,13,6,4,10,15,4,11,14,14,2,0,10,14,8,2,11,14,10,3,14] } }
theorem leafL_040_3_valid : (leafL_040_3).reject.ValidFor (leafL_040_3).leaf := by decide

noncomputable def leafL_040_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,265}, reject := .fullRank { members := ![0,1,17,34,52,69,93,265], points := ![103,110,120,124,128,139], inverse := ![5,2,10,15,12,15,13,10,3,2,15,9,0,0,12,11,7,0,0,7,15,13,13,8,10,10,6,8,14,0,3,3,9,11,2,0] } }
theorem leafL_040_4_valid : (leafL_040_4).reject.ValidFor (leafL_040_4).leaf := by decide

noncomputable def leafL_040_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,268}, reject := .fullRank { members := ![0,1,17,34,52,69,93,268], points := ![103,110,115,120,127,137], inverse := ![1,6,10,1,2,15,14,9,8,3,5,9,0,0,2,5,7,0,5,2,2,12,1,8,10,10,9,10,3,0,3,3,13,9,4,0] } }
theorem leafL_040_5_valid : (leafL_040_5).reject.ValidFor (leafL_040_5).leaf := by decide

noncomputable def leafL_040_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,271}, reject := .fullRank { members := ![0,1,17,34,52,69,93,271], points := ![99,110,115,126,137,144], inverse := ![7,0,0,9,15,0,3,4,6,8,1,8,14,14,15,15,4,4,10,13,5,10,3,11,6,6,1,1,9,9,9,9,9,9,0,0] } }
theorem leafL_040_6_valid : (leafL_040_6).reject.ValidFor (leafL_040_6).leaf := by decide

noncomputable def leafL_040_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,99}, reject := .fullRank { members := ![0,1,17,34,52,69,94,99], points := ![120,122,128,135,151,152], inverse := ![14,15,5,14,2,9,2,4,5,8,11,0,2,9,11,0,0,0,11,2,11,9,1,10,10,15,5,0,10,10,1,4,5,0,3,3] } }
theorem leafL_040_7_valid : (leafL_040_7).reject.ValidFor (leafL_040_7).leaf := by decide

noncomputable def leavesL_040 : List RejectedLeaf := [leafL_040_0,leafL_040_1,leafL_040_2,leafL_040_3,leafL_040_4,leafL_040_5,leafL_040_6,leafL_040_7]

theorem leavesL_040_valid : LeafListValid leavesL_040 := by
  intro x hx
  simp only [leavesL_040, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_040_0_valid
  · exact leafL_040_1_valid
  · exact leafL_040_2_valid
  · exact leafL_040_3_valid
  · exact leafL_040_4_valid
  · exact leafL_040_5_valid
  · exact leafL_040_6_valid
  · exact leafL_040_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
