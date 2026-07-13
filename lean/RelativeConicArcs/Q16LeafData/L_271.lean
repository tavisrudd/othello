import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_271_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,143,169}, reject := .fullRank { members := ![0,1,17,34,52,72,143,169], points := ![90,92,94,103,115,124], inverse := ![12,2,1,8,8,14,9,12,12,14,10,13,15,10,5,0,0,0,0,15,7,15,12,11,3,11,8,0,4,4,5,12,9,0,1,1] } }
theorem leafL_271_0_valid : (leafL_271_0).reject.ValidFor (leafL_271_0).leaf := by decide

noncomputable def leafL_271_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,143,188}, reject := .fullRank { members := ![0,1,17,34,52,72,143,188], points := ![83,90,91,103,112,115], inverse := ![2,9,4,7,15,6,11,1,3,7,9,7,6,3,5,0,0,0,13,4,1,10,5,7,8,7,15,8,8,0,9,3,10,2,2,0] } }
theorem leafL_271_1_valid : (leafL_271_1).reject.ValidFor (leafL_271_1).leaf := by decide

noncomputable def leafL_271_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,143,197}, reject := .fullRank { members := ![0,1,17,34,52,72,143,197], points := ![83,92,94,103,115,122], inverse := ![12,7,4,8,14,8,8,5,4,14,1,6,3,14,13,0,0,0,14,7,1,15,14,9,2,12,14,0,10,10,2,15,13,0,11,11] } }
theorem leafL_271_2_valid : (leafL_271_2).reject.ValidFor (leafL_271_2).leaf := by decide

noncomputable def leafL_271_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,143,203}, reject := .fullRank { members := ![0,1,17,34,52,72,143,203], points := ![83,90,92,112,115,122], inverse := ![6,4,13,8,4,2,10,10,9,14,5,2,10,11,1,0,0,0,11,2,1,15,6,1,13,6,11,0,10,10,11,11,0,0,11,11] } }
theorem leafL_271_3_valid : (leafL_271_3).reject.ValidFor (leafL_271_3).leaf := by decide

noncomputable def leafL_271_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,143,213}, reject := .fullRank { members := ![0,1,17,34,52,72,143,213], points := ![91,92,96,112,122,124], inverse := ![10,8,13,8,3,5,10,1,2,14,14,9,11,13,6,0,0,0,15,2,5,15,9,14,7,6,1,0,1,1,14,11,5,0,13,13] } }
theorem leafL_271_4_valid : (leafL_271_4).reject.ValidFor (leafL_271_4).leaf := by decide

noncomputable def leafL_271_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,143,218}, reject := .fullRank { members := ![0,1,17,34,52,72,143,218], points := ![83,91,96,112,117,124], inverse := ![7,4,12,8,5,3,8,5,4,14,1,6,9,3,10,0,0,0,11,7,4,15,8,15,1,8,9,0,3,3,11,3,8,0,4,4] } }
theorem leafL_271_5_valid : (leafL_271_5).reject.ValidFor (leafL_271_5).leaf := by decide

noncomputable def leafL_271_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,143,240}, reject := .fullRank { members := ![0,1,17,34,52,72,143,240], points := ![92,94,101,103,117,122], inverse := ![13,2,14,6,11,13,3,10,2,12,2,5,7,7,14,14,13,13,3,11,11,4,12,11,0,0,1,1,12,12,8,8,4,4,1,1] } }
theorem leafL_271_6_valid : (leafL_271_6).reject.ValidFor (leafL_271_6).leaf := by decide

noncomputable def leafL_271_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,143,269}, reject := .fullRank { members := ![0,1,17,34,52,72,143,269], points := ![83,92,94,103,112,115], inverse := ![12,13,14,7,15,6,8,11,10,7,9,7,3,14,13,0,0,0,14,1,7,10,5,7,2,13,15,8,8,0,2,2,0,2,2,0] } }
theorem leafL_271_7_valid : (leafL_271_7).reject.ValidFor (leafL_271_7).leaf := by decide

noncomputable def leavesL_271 : List RejectedLeaf := [leafL_271_0,leafL_271_1,leafL_271_2,leafL_271_3,leafL_271_4,leafL_271_5,leafL_271_6,leafL_271_7]

theorem leavesL_271_valid : LeafListValid leavesL_271 := by
  intro x hx
  simp only [leavesL_271, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_271_0_valid
  · exact leafL_271_1_valid
  · exact leafL_271_2_valid
  · exact leafL_271_3_valid
  · exact leafL_271_4_valid
  · exact leafL_271_5_valid
  · exact leafL_271_6_valid
  · exact leafL_271_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
