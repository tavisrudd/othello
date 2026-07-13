import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_045_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,256}, reject := .fullRank { members := ![0,1,17,34,52,69,94,256], points := ![99,104,106,122,127,150], inverse := ![8,6,2,1,15,3,11,13,11,15,14,12,1,14,15,0,0,0,4,11,5,13,0,7,6,4,2,10,10,0,7,13,10,2,2,0] } }
theorem leafL_045_0_valid : (leafL_045_0).reject.ValidFor (leafL_045_0).leaf := by decide

noncomputable def leafL_045_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,259}, reject := .fullRank { members := ![0,1,17,34,52,69,94,259], points := ![106,107,120,127,144,150], inverse := ![12,6,8,3,7,7,2,0,10,10,4,6,2,6,4,2,11,9,10,13,7,8,8,0,0,13,11,9,8,7,7,12,4,3,15,3] } }
theorem leafL_045_1_valid : (leafL_045_1).reject.ValidFor (leafL_045_1).leaf := by decide

noncomputable def leafL_045_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,265}, reject := .fullRank { members := ![0,1,17,34,52,69,94,265], points := ![103,107,120,128,135,144], inverse := ![3,4,4,13,12,3,13,10,6,8,15,6,9,9,8,8,7,7,3,4,13,2,9,1,7,7,2,2,0,0,9,9,7,7,5,5] } }
theorem leafL_045_2_valid : (leafL_045_2).reject.ValidFor (leafL_045_2).leaf := by decide

noncomputable def leafL_045_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,269}, reject := .fullRank { members := ![0,1,17,34,52,69,94,269], points := ![103,104,107,128,135,144], inverse := ![11,2,14,9,6,9,1,3,5,14,0,9,10,4,14,0,0,0,10,15,2,15,15,7,3,1,2,0,5,5,7,10,13,0,1,1] } }
theorem leafL_045_3_valid : (leafL_045_3).reject.ValidFor (leafL_045_3).leaf := by decide

noncomputable def leafL_045_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,271}, reject := .fullRank { members := ![0,1,17,34,52,69,94,271], points := ![103,104,107,122,151,152], inverse := ![0,3,15,14,11,8,14,0,3,1,4,8,10,4,14,0,0,0,5,11,4,13,14,9,12,2,14,0,7,7,4,4,0,0,4,4] } }
theorem leafL_045_4_valid : (leafL_045_4).reject.ValidFor (leafL_045_4).leaf := by decide

noncomputable def leafL_045_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,99}, reject := .fullRank { members := ![0,1,17,34,52,69,95,99], points := ![120,124,141,144,150,151], inverse := ![0,4,0,14,0,11,2,1,6,14,14,5,15,15,13,13,4,4,8,10,0,9,11,0,2,2,0,0,6,6,0,0,9,9,9,9] } }
theorem leafL_045_5_valid : (leafL_045_5).reject.ValidFor (leafL_045_5).leaf := by decide

noncomputable def leafL_045_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,103}, reject := .fullRank { members := ![0,1,17,34,52,69,95,103], points := ![124,131,137,139,150,156], inverse := ![4,11,2,7,10,1,3,7,11,4,0,11,0,8,6,14,0,0,2,15,14,8,9,2,0,8,0,8,4,4,0,15,13,2,11,11] } }
theorem leafL_045_6_valid : (leafL_045_6).reject.ValidFor (leafL_045_6).leaf := by decide

noncomputable def leafL_045_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,106}, reject := .fullRank { members := ![0,1,17,34,52,69,95,106], points := ![115,120,124,139,141,156], inverse := ![7,6,5,9,7,11,12,9,6,5,13,11,5,2,7,0,0,0,14,1,13,7,14,11,2,9,11,1,1,0,4,13,9,7,7,0] } }
theorem leafL_045_7_valid : (leafL_045_7).reject.ValidFor (leafL_045_7).leaf := by decide

noncomputable def leavesL_045 : List RejectedLeaf := [leafL_045_0,leafL_045_1,leafL_045_2,leafL_045_3,leafL_045_4,leafL_045_5,leafL_045_6,leafL_045_7]

theorem leavesL_045_valid : LeafListValid leavesL_045 := by
  intro x hx
  simp only [leavesL_045, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_045_0_valid
  · exact leafL_045_1_valid
  · exact leafL_045_2_valid
  · exact leafL_045_3_valid
  · exact leafL_045_4_valid
  · exact leafL_045_5_valid
  · exact leafL_045_6_valid
  · exact leafL_045_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
