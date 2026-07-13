import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_254_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,94,199}, reject := .fullRank { members := ![0,1,17,34,52,72,94,199], points := ![99,108,112,122,124,137], inverse := ![13,6,12,8,1,15,7,4,4,9,7,9,8,9,1,0,0,0,7,11,11,12,3,8,9,14,7,8,8,0,3,11,8,7,7,0] } }
theorem leafL_254_0_valid : (leafL_254_0).reject.ValidFor (leafL_254_0).leaf := by decide

noncomputable def leafL_254_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,94,229}, reject := .fullRank { members := ![0,1,17,34,52,72,94,229], points := ![108,122,124,135,137,150], inverse := ![1,8,4,1,9,4,2,15,15,5,1,6,11,14,9,7,8,3,14,4,15,4,15,14,13,14,12,8,0,7,13,13,15,1,9,7] } }
theorem leafL_254_1_valid : (leafL_254_1).reject.ValidFor (leafL_254_1).leaf := by decide

noncomputable def leafL_254_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,94,237}, reject := .fullRank { members := ![0,1,17,34,52,72,94,237], points := ![103,107,124,128,144,150], inverse := ![15,15,12,8,14,11,13,9,4,1,3,2,9,13,1,7,11,9,14,7,6,0,10,5,13,2,3,2,4,10,11,9,3,0,12,13] } }
theorem leafL_254_2_valid : (leafL_254_2).reject.ValidFor (leafL_254_2).leaf := by decide

noncomputable def leafL_254_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,94,239}, reject := .fullRank { members := ![0,1,17,34,52,72,94,239], points := ![103,107,112,128,135,137], inverse := ![12,2,9,9,11,4,8,10,5,14,13,4,7,2,5,0,0,0,6,6,7,15,5,13,2,9,11,0,14,14,2,7,5,0,8,8] } }
theorem leafL_254_3_valid : (leafL_254_3).reject.ValidFor (leafL_254_3).leaf := by decide

noncomputable def leafL_254_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,101,115}, reject := .fullRank { members := ![0,1,17,34,52,72,101,115], points := ![90,91,93,138,139,150], inverse := ![6,0,14,11,8,10,5,7,4,11,2,15,8,12,4,0,0,0,13,5,12,12,10,2,15,3,12,10,10,0,11,11,0,11,11,0] } }
theorem leafL_254_4_valid : (leafL_254_4).reject.ValidFor (leafL_254_4).leaf := by decide

noncomputable def leafL_254_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,101,139}, reject := .fullRank { members := ![0,1,17,34,52,72,101,139], points := ![90,93,96,115,124,150], inverse := ![11,12,5,1,4,6,6,1,2,1,9,13,4,8,12,0,0,0,5,8,14,9,3,9,3,7,4,4,4,0,7,9,14,1,1,0] } }
theorem leafL_254_5_valid : (leafL_254_5).reject.ValidFor (leafL_254_5).leaf := by decide

noncomputable def leafL_254_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,101,150}, reject := .fullRank { members := ![0,1,17,34,52,72,101,150], points := ![83,90,91,115,124,137], inverse := ![2,2,7,4,10,8,6,8,9,3,10,14,6,3,5,0,0,0,12,0,11,13,5,15,11,13,6,4,4,0,13,8,5,1,1,0] } }
theorem leafL_254_6_valid : (leafL_254_6).reject.ValidFor (leafL_254_6).leaf := by decide

noncomputable def leafL_254_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,101,159}, reject := .fullRank { members := ![0,1,17,34,52,72,101,159], points := ![83,92,93,115,124,139], inverse := ![4,6,5,1,15,8,13,15,5,1,8,14,6,12,10,0,0,0,2,15,10,9,1,15,5,0,5,4,4,0,1,1,0,1,1,0] } }
theorem leafL_254_7_valid : (leafL_254_7).reject.ValidFor (leafL_254_7).leaf := by decide

noncomputable def leavesL_254 : List RejectedLeaf := [leafL_254_0,leafL_254_1,leafL_254_2,leafL_254_3,leafL_254_4,leafL_254_5,leafL_254_6,leafL_254_7]

theorem leavesL_254_valid : LeafListValid leavesL_254 := by
  intro x hx
  simp only [leavesL_254, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_254_0_valid
  · exact leafL_254_1_valid
  · exact leafL_254_2_valid
  · exact leafL_254_3_valid
  · exact leafL_254_4_valid
  · exact leafL_254_5_valid
  · exact leafL_254_6_valid
  · exact leafL_254_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
