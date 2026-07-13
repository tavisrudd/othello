import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_067_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,254}, reject := .fullRank { members := ![0,1,17,34,52,69,106,254], points := ![89,96,120,135,139,152], inverse := ![1,7,7,7,8,15,11,2,14,5,7,5,12,1,15,1,4,7,5,12,15,15,12,5,2,15,15,10,15,7,8,10,1,14,0,13] } }
theorem leafL_067_0_valid : (leafL_067_0).reject.ValidFor (leafL_067_0).leaf := by decide

noncomputable def leafL_067_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,256}, reject := .fullRank { members := ![0,1,17,34,52,69,106,256], points := ![94,95,115,141,156,159], inverse := ![7,0,14,8,0,0,8,2,6,11,0,7,11,0,12,4,12,15,12,3,12,2,13,12,14,5,12,4,4,7,10,6,6,2,4,12] } }
theorem leafL_067_1_valid : (leafL_067_1).reject.ValidFor (leafL_067_1).leaf := by decide

noncomputable def leafL_067_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,259}, reject := .fullRank { members := ![0,1,17,34,52,69,106,259], points := ![91,94,96,120,124,139], inverse := ![9,7,9,5,11,8,13,2,8,5,12,14,15,3,12,0,0,0,8,8,7,11,3,15,7,12,11,7,7,0,11,4,15,5,5,0] } }
theorem leafL_067_2_valid : (leafL_067_2).reject.ValidFor (leafL_067_2).leaf := by decide

noncomputable def leafL_067_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,262}, reject := .fullRank { members := ![0,1,17,34,52,69,106,262], points := ![91,95,96,120,126,135], inverse := ![15,6,14,5,11,8,10,14,3,15,6,14,6,13,11,0,0,0,7,1,1,5,13,15,11,2,9,11,11,0,14,10,4,6,6,0] } }
theorem leafL_067_3_valid : (leafL_067_3).reject.ValidFor (leafL_067_3).leaf := by decide

noncomputable def leafL_067_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,268}, reject := .fullRank { members := ![0,1,17,34,52,69,106,268], points := ![89,91,95,115,139,144], inverse := ![4,9,10,14,9,1,1,1,7,9,2,12,10,15,5,0,0,0,10,1,12,8,7,8,5,13,8,0,6,6,6,15,9,0,8,8] } }
theorem leafL_067_4_valid : (leafL_067_4).reject.ValidFor (leafL_067_4).leaf := by decide

noncomputable def leafL_067_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,115}, reject := .fullRank { members := ![0,1,17,34,52,69,107,115], points := ![95,138,151,156,172,182], inverse := ![15,9,9,15,4,5,7,11,10,10,6,10,15,2,6,10,12,13,11,14,4,14,13,2,3,10,7,12,5,7,9,2,3,2,4,14] } }
theorem leafL_067_5_valid : (leafL_067_5).reject.ValidFor (leafL_067_5).leaf := by decide

noncomputable def leafL_067_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,120}, reject := .fullRank { members := ![0,1,17,34,52,69,107,120], points := ![94,95,96,131,137,151], inverse := ![15,7,0,6,5,10,15,14,7,2,11,15,7,14,9,0,0,0,12,11,3,0,6,2,6,0,6,3,3,0,13,7,10,4,4,0] } }
theorem leafL_067_6_valid : (leafL_067_6).reject.ValidFor (leafL_067_6).leaf := by decide

noncomputable def leafL_067_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,124}, reject := .fullRank { members := ![0,1,17,34,52,69,107,124], points := ![86,95,150,152,169,173], inverse := ![2,15,9,14,12,7,1,15,8,2,12,8,13,13,4,4,10,10,8,6,10,1,8,13,5,5,2,2,1,1,8,8,2,2,4,4] } }
theorem leafL_067_7_valid : (leafL_067_7).reject.ValidFor (leafL_067_7).leaf := by decide

noncomputable def leavesL_067 : List RejectedLeaf := [leafL_067_0,leafL_067_1,leafL_067_2,leafL_067_3,leafL_067_4,leafL_067_5,leafL_067_6,leafL_067_7]

theorem leavesL_067_valid : LeafListValid leavesL_067 := by
  intro x hx
  simp only [leavesL_067, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_067_0_valid
  · exact leafL_067_1_valid
  · exact leafL_067_2_valid
  · exact leafL_067_3_valid
  · exact leafL_067_4_valid
  · exact leafL_067_5_valid
  · exact leafL_067_6_valid
  · exact leafL_067_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
