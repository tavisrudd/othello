import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_256_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,101,267}, reject := .fullRank { members := ![0,1,17,34,52,72,101,267], points := ![92,93,115,128,137,143], inverse := ![13,10,5,11,6,14,0,7,6,15,11,5,5,5,10,10,9,9,7,0,1,9,5,10,10,10,8,8,0,0,1,1,6,6,11,11] } }
theorem leafL_256_0_valid : (leafL_256_0).reject.ValidFor (leafL_256_0).leaf := by decide

noncomputable def leafL_256_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,101,268}, reject := .fullRank { members := ![0,1,17,34,52,72,101,268], points := ![83,90,91,126,137,139], inverse := ![10,6,11,14,8,0,12,4,15,9,6,8,6,3,5,0,0,0,0,4,3,8,9,6,2,5,7,0,15,15,2,10,8,0,7,7] } }
theorem leafL_256_1_valid : (leafL_256_1).reject.ValidFor (leafL_256_1).leaf := by decide

noncomputable def leafL_256_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,101,270}, reject := .fullRank { members := ![0,1,17,34,52,72,101,270], points := ![93,96,124,128,138,139], inverse := ![5,2,15,1,12,4,12,11,15,6,10,4,15,15,8,8,13,13,8,15,13,5,4,11,6,6,11,11,14,14,11,11,0,0,11,11] } }
theorem leafL_256_2_valid : (leafL_256_2).reject.ValidFor (leafL_256_2).leaf := by decide

noncomputable def leafL_256_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,103,125}, reject := .fullRank { members := ![0,1,17,34,52,72,103,125], points := ![91,138,147,149,172,181], inverse := ![4,10,15,7,5,2,15,13,6,5,10,11,7,4,5,10,0,12,15,10,0,10,9,6,5,13,1,15,15,9,9,4,3,15,10,11] } }
theorem leafL_256_3_valid : (leafL_256_3).reject.ValidFor (leafL_256_3).leaf := by decide

noncomputable def leafL_256_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,103,126}, reject := .fullRank { members := ![0,1,17,34,52,72,103,126], points := ![93,96,138,139,143,150], inverse := ![2,10,8,7,12,10,7,1,10,7,4,15,0,0,2,10,8,0,10,14,8,13,3,2,4,4,12,7,11,0,11,11,11,11,0,0] } }
theorem leafL_256_4_valid : (leafL_256_4).reject.ValidFor (leafL_256_4).leaf := by decide

noncomputable def leafL_256_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,103,139}, reject := .fullRank { members := ![0,1,17,34,52,72,103,139], points := ![93,96,124,126,150,163], inverse := ![5,12,14,3,1,4,8,7,6,8,2,3,8,11,15,14,11,9,5,8,12,13,0,12,5,13,0,9,12,13,0,14,9,2,9,12] } }
theorem leafL_256_5_valid : (leafL_256_5).reject.ValidFor (leafL_256_5).leaf := by decide

noncomputable def leafL_256_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,103,149}, reject := .fullRank { members := ![0,1,17,34,52,72,103,149], points := ![91,94,125,163,169,185], inverse := ![3,9,7,1,10,7,0,4,10,6,2,10,3,11,10,6,15,11,12,12,2,1,7,4,9,2,13,13,5,14,8,0,10,3,10,11] } }
theorem leafL_256_6_valid : (leafL_256_6).reject.ValidFor (leafL_256_6).leaf := by decide

noncomputable def leafL_256_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,103,163}, reject := .fullRank { members := ![0,1,17,34,52,72,103,163], points := ![91,93,96,126,139,143], inverse := ![5,5,7,14,12,4,2,13,8,9,13,3,4,12,8,0,0,0,12,10,1,8,2,13,11,10,1,0,14,14,5,4,1,0,10,10] } }
theorem leafL_256_7_valid : (leafL_256_7).reject.ValidFor (leafL_256_7).leaf := by decide

noncomputable def leavesL_256 : List RejectedLeaf := [leafL_256_0,leafL_256_1,leafL_256_2,leafL_256_3,leafL_256_4,leafL_256_5,leafL_256_6,leafL_256_7]

theorem leavesL_256_valid : LeafListValid leavesL_256 := by
  intro x hx
  simp only [leavesL_256, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_256_0_valid
  · exact leafL_256_1_valid
  · exact leafL_256_2_valid
  · exact leafL_256_3_valid
  · exact leafL_256_4_valid
  · exact leafL_256_5_valid
  · exact leafL_256_6_valid
  · exact leafL_256_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
