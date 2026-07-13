import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_041_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,103}, reject := .fullRank { members := ![0,1,17,34,52,69,94,103], points := ![127,128,131,150,152,156], inverse := ![4,0,14,5,15,1,4,7,8,10,8,9,0,0,0,8,5,13,15,13,9,13,0,6,11,11,0,15,12,3,3,3,0,6,10,12] } }
theorem leafL_041_0_valid : (leafL_041_0).reject.ValidFor (leafL_041_0).leaf := by decide

noncomputable def leafL_041_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,104}, reject := .fullRank { members := ![0,1,17,34,52,69,94,104], points := ![127,156,166,169,172,182], inverse := ![5,12,12,1,4,1,9,11,11,15,5,3,0,0,12,13,1,0,7,7,3,5,12,10,8,6,0,8,10,12,3,12,14,4,14,11] } }
theorem leafL_041_1_valid : (leafL_041_1).reject.ValidFor (leafL_041_1).leaf := by decide

noncomputable def leafL_041_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,106}, reject := .fullRank { members := ![0,1,17,34,52,69,94,106], points := ![120,135,144,152,156,166], inverse := ![15,4,1,6,6,11,11,5,5,12,15,8,15,6,9,3,12,15,3,4,12,11,1,1,6,6,0,4,2,6,5,1,4,14,11,5] } }
theorem leafL_041_2_valid : (leafL_041_2).reject.ValidFor (leafL_041_2).leaf := by decide

noncomputable def leafL_041_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,107}, reject := .fullRank { members := ![0,1,17,34,52,69,94,107], points := ![120,122,127,131,144,150], inverse := ![6,6,4,10,4,11,4,14,9,9,1,11,6,10,12,0,0,0,13,4,11,0,9,11,2,7,5,11,11,0,9,14,7,4,4,0] } }
theorem leafL_041_3_valid : (leafL_041_3).reject.ValidFor (leafL_041_3).leaf := by decide

noncomputable def leafL_041_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,112}, reject := .fullRank { members := ![0,1,17,34,52,69,94,112], points := ![120,131,135,152,163,166], inverse := ![9,10,9,6,10,7,10,13,12,2,6,15,8,2,10,8,10,2,9,6,4,0,14,5,10,9,3,10,2,8,14,14,0,14,14,0] } }
theorem leafL_041_4_valid : (leafL_041_4).reject.ValidFor (leafL_041_4).leaf := by decide

noncomputable def leafL_041_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,120}, reject := .fullRank { members := ![0,1,17,34,52,69,94,120], points := ![99,106,107,144,151,166], inverse := ![13,10,14,13,5,0,12,1,2,14,3,2,6,3,5,0,0,0,9,11,3,5,14,10,8,10,1,1,9,11,5,11,0,11,12,9] } }
theorem leafL_041_5_valid : (leafL_041_5).reject.ValidFor (leafL_041_5).leaf := by decide

noncomputable def leafL_041_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,122}, reject := .fullRank { members := ![0,1,17,34,52,69,94,122], points := ![99,107,135,150,152,163], inverse := ![6,4,5,3,2,7,3,1,4,3,5,0,5,7,15,10,4,3,10,6,15,15,4,8,5,0,3,8,0,14,10,5,5,4,15,1] } }
theorem leafL_041_6_valid : (leafL_041_6).reject.ValidFor (leafL_041_6).leaf := by decide

noncomputable def leafL_041_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,128}, reject := .fullRank { members := ![0,1,17,34,52,69,94,128], points := ![99,103,131,150,151,156], inverse := ![10,3,13,1,10,14,2,0,4,12,15,5,0,0,0,1,13,12,15,2,1,15,10,9,8,8,0,14,5,11,1,1,0,2,10,8] } }
theorem leafL_041_7_valid : (leafL_041_7).reject.ValidFor (leafL_041_7).leaf := by decide

noncomputable def leavesL_041 : List RejectedLeaf := [leafL_041_0,leafL_041_1,leafL_041_2,leafL_041_3,leafL_041_4,leafL_041_5,leafL_041_6,leafL_041_7]

theorem leavesL_041_valid : LeafListValid leavesL_041 := by
  intro x hx
  simp only [leavesL_041, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_041_0_valid
  · exact leafL_041_1_valid
  · exact leafL_041_2_valid
  · exact leafL_041_3_valid
  · exact leafL_041_4_valid
  · exact leafL_041_5_valid
  · exact leafL_041_6_valid
  · exact leafL_041_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
