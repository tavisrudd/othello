import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_044_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,217}, reject := .fullRank { members := ![0,1,17,34,52,69,94,217], points := ![99,104,107,120,122,131], inverse := ![6,5,4,13,4,15,6,6,7,11,5,9,3,10,9,0,0,0,3,2,6,7,8,8,11,7,12,5,5,0,3,7,4,1,1,0] } }
theorem leafL_044_0_valid : (leafL_044_0).reject.ValidFor (leafL_044_0).leaf := by decide

noncomputable def leafL_044_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,218}, reject := .fullRank { members := ![0,1,17,34,52,69,94,218], points := ![104,112,120,128,131,150], inverse := ![8,1,14,14,13,5,8,0,12,3,13,10,12,7,0,7,15,3,13,8,1,13,4,13,7,0,2,15,1,11,5,5,5,5,0,0] } }
theorem leafL_044_1_valid : (leafL_044_1).reject.ValidFor (leafL_044_1).leaf := by decide

noncomputable def leafL_044_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,220}, reject := .fullRank { members := ![0,1,17,34,52,69,94,220], points := ![103,112,120,127,128,135], inverse := ![12,11,15,6,0,15,7,0,14,14,14,9,0,0,13,2,15,0,3,4,11,11,15,8,4,4,9,7,14,0,15,15,15,15,0,0] } }
theorem leafL_044_2_valid : (leafL_044_2).reject.ValidFor (leafL_044_2).leaf := by decide

noncomputable def leafL_044_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,223}, reject := .fullRank { members := ![0,1,17,34,52,69,94,223], points := ![99,103,104,128,135,144], inverse := ![6,12,13,9,6,9,4,10,9,14,0,9,6,13,11,0,0,0,7,11,11,15,15,7,7,2,5,0,5,5,11,8,3,0,1,1] } }
theorem leafL_044_3_valid : (leafL_044_3).reject.ValidFor (leafL_044_3).leaf := by decide

noncomputable def leafL_044_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,240}, reject := .fullRank { members := ![0,1,17,34,52,69,94,240], points := ![99,104,122,127,131,150], inverse := ![6,11,4,2,6,12,15,14,6,13,14,4,10,4,3,10,2,5,12,13,12,6,15,4,8,9,15,7,6,15,4,1,0,14,13,6] } }
theorem leafL_044_4_valid : (leafL_044_4).reject.ValidFor (leafL_044_4).leaf := by decide

noncomputable def leafL_044_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,246}, reject := .fullRank { members := ![0,1,17,34,52,69,94,246], points := ![99,120,122,127,131,144], inverse := ![7,11,11,9,10,5,7,9,3,4,9,0,0,6,10,12,0,0,7,0,9,6,0,8,0,2,7,5,11,11,0,9,14,7,4,4] } }
theorem leafL_044_5_valid : (leafL_044_5).reject.ValidFor (leafL_044_5).leaf := by decide

noncomputable def leafL_044_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,248}, reject := .fullRank { members := ![0,1,17,34,52,69,94,248], points := ![99,106,131,135,144,151], inverse := ![8,1,8,4,1,5,12,14,1,13,8,6,0,0,1,9,8,0,7,10,9,10,2,12,4,4,14,2,12,0,11,11,1,8,9,0] } }
theorem leafL_044_6_valid : (leafL_044_6).reject.ValidFor (leafL_044_6).leaf := by decide

noncomputable def leafL_044_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,249}, reject := .fullRank { members := ![0,1,17,34,52,69,94,249], points := ![103,104,107,120,122,131], inverse := ![7,10,10,13,4,15,7,9,9,11,5,9,10,4,14,0,0,0,10,12,1,7,8,8,15,14,1,5,5,0,10,9,3,1,1,0] } }
theorem leafL_044_7_valid : (leafL_044_7).reject.ValidFor (leafL_044_7).leaf := by decide

noncomputable def leavesL_044 : List RejectedLeaf := [leafL_044_0,leafL_044_1,leafL_044_2,leafL_044_3,leafL_044_4,leafL_044_5,leafL_044_6,leafL_044_7]

theorem leavesL_044_valid : LeafListValid leavesL_044 := by
  intro x hx
  simp only [leavesL_044, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_044_0_valid
  · exact leafL_044_1_valid
  · exact leafL_044_2_valid
  · exact leafL_044_3_valid
  · exact leafL_044_4_valid
  · exact leafL_044_5_valid
  · exact leafL_044_6_valid
  · exact leafL_044_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
