import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_241_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,218,269}, reject := .fullRank { members := ![0,1,17,34,52,71,218,269], points := ![91,94,96,104,110,120], inverse := ![2,8,5,0,8,6,5,3,15,14,0,7,15,3,12,0,0,0,8,11,11,13,2,7,9,7,14,5,5,0,1,2,3,12,12,0] } }
theorem leafL_241_0_valid : (leafL_241_0).reject.ValidFor (leafL_241_0).leaf := by decide

noncomputable def leafL_241_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,218,271}, reject := .fullRank { members := ![0,1,17,34,52,71,218,271], points := ![91,96,104,109,110,124], inverse := ![7,8,10,7,5,6,5,12,6,11,3,7,0,0,9,5,12,0,6,14,8,0,7,7,1,1,3,9,10,0,11,11,2,6,4,0] } }
theorem leafL_241_1_valid : (leafL_241_1).reject.ValidFor (leafL_241_1).leaf := by decide

noncomputable def leafL_241_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,222,232}, reject := .fullRank { members := ![0,1,17,34,52,71,222,232], points := ![92,93,106,150,156,159], inverse := ![10,12,11,9,12,9,11,1,4,2,12,0,0,0,0,15,14,1,11,0,5,2,13,1,4,4,0,1,1,0,9,9,0,11,14,5] } }
theorem leafL_241_2_valid : (leafL_241_2).reject.ValidFor (leafL_241_2).leaf := by decide

noncomputable def leafL_241_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,222,243}, reject := .fullRank { members := ![0,1,17,34,52,71,222,243], points := ![90,93,106,121,140,144], inverse := ![15,7,15,1,13,10,8,10,5,12,5,14,3,5,6,6,4,2,4,6,5,13,15,5,6,3,5,5,8,13,9,11,2,2,7,5] } }
theorem leafL_241_3_valid : (leafL_241_3).reject.ValidFor (leafL_241_3).leaf := by decide

noncomputable def leafL_241_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,222,262}, reject := .fullRank { members := ![0,1,17,34,52,71,222,262], points := ![83,92,96,99,106,124], inverse := ![13,8,10,11,3,6,9,14,14,6,8,7,8,9,1,0,0,0,10,8,10,13,2,7,2,3,1,7,7,0,1,3,2,5,5,0] } }
theorem leafL_241_4_valid : (leafL_241_4).reject.ValidFor (leafL_241_4).leaf := by decide

noncomputable def leafL_241_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,222,268}, reject := .fullRank { members := ![0,1,17,34,52,71,222,268], points := ![90,93,131,139,144,181], inverse := ![8,11,15,10,15,8,7,6,0,15,2,12,0,0,9,3,10,0,3,14,3,9,0,7,13,13,11,9,2,0,8,8,0,8,8,0] } }
theorem leafL_241_5_valid : (leafL_241_5).reject.ValidFor (leafL_241_5).leaf := by decide

noncomputable def leafL_241_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,223,237}, reject := .fullRank { members := ![0,1,17,34,52,71,223,237], points := ![83,90,96,104,106,121], inverse := ![1,13,3,1,9,6,11,2,0,1,15,7,7,8,15,0,0,0,4,15,3,9,6,7,0,8,8,12,12,0,13,11,6,3,3,0] } }
theorem leafL_241_6_valid : (leafL_241_6).reject.ValidFor (leafL_241_6).leaf := by decide

noncomputable def leafL_241_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,223,240}, reject := .fullRank { members := ![0,1,17,34,52,71,223,240], points := ![90,94,99,101,106,122], inverse := ![9,6,9,13,12,6,9,0,0,0,14,7,0,0,8,15,7,0,7,15,2,5,8,7,12,12,5,7,2,0,13,13,4,10,14,0] } }
theorem leafL_241_7_valid : (leafL_241_7).reject.ValidFor (leafL_241_7).leaf := by decide

noncomputable def leavesL_241 : List RejectedLeaf := [leafL_241_0,leafL_241_1,leafL_241_2,leafL_241_3,leafL_241_4,leafL_241_5,leafL_241_6,leafL_241_7]

theorem leavesL_241_valid : LeafListValid leavesL_241 := by
  intro x hx
  simp only [leavesL_241, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_241_0_valid
  · exact leafL_241_1_valid
  · exact leafL_241_2_valid
  · exact leafL_241_3_valid
  · exact leafL_241_4_valid
  · exact leafL_241_5_valid
  · exact leafL_241_6_valid
  · exact leafL_241_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
