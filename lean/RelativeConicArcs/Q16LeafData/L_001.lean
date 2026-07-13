import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_001_0 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,138}, reject := .fullRank { members := ![0,1,17,34,52,67,89,138], points := ![108,126,127,151,155,166], inverse := ![6,11,3,8,14,9,5,8,0,6,14,5,11,14,6,9,5,15,2,4,0,2,1,5,3,13,12,6,14,10,5,14,13,12,7,13] } }
theorem leafL_001_0_valid : (leafL_001_0).reject.ValidFor (leafL_001_0).leaf := by decide

noncomputable def leafL_001_1 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,139}, reject := .fullRank { members := ![0,1,17,34,52,67,89,139], points := ![106,110,112,124,126,151], inverse := ![14,4,6,14,0,3,2,8,7,4,5,12,5,15,10,0,0,0,5,5,10,15,2,7,3,4,7,9,9,0,12,0,12,12,12,0] } }
theorem leafL_001_1_valid : (leafL_001_1).reject.ValidFor (leafL_001_1).leaf := by decide

noncomputable def leafL_001_2 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,141}, reject := .fullRank { members := ![0,1,17,34,52,67,89,141], points := ![106,110,112,124,126,149], inverse := ![4,7,15,4,10,3,12,4,5,10,11,12,5,15,10,0,0,0,4,2,12,14,3,7,3,4,7,9,9,0,12,0,12,12,12,0] } }
theorem leafL_001_2_valid : (leafL_001_2).reject.ValidFor (leafL_001_2).leaf := by decide

noncomputable def leafL_001_3 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,149}, reject := .fullRank { members := ![0,1,17,34,52,67,89,149], points := ![126,128,141,171,173,176], inverse := ![10,5,5,9,4,6,12,4,3,10,6,7,0,0,0,4,12,8,1,8,2,8,6,5,2,2,0,15,1,14,4,4,0,6,3,5] } }
theorem leafL_001_3_valid : (leafL_001_3).reject.ValidFor (leafL_001_3).leaf := by decide

noncomputable def leafL_001_4 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,151}, reject := .fullRank { members := ![0,1,17,34,52,67,89,151], points := ![108,110,112,127,128,138], inverse := ![4,8,11,11,2,15,4,1,2,2,12,9,5,10,15,0,0,0,10,4,9,3,12,8,8,2,10,3,3,0,5,13,8,14,14,0] } }
theorem leafL_001_4_valid : (leafL_001_4).reject.ValidFor (leafL_001_4).leaf := by decide

noncomputable def leafL_001_5 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,155}, reject := .fullRank { members := ![0,1,17,34,52,67,89,155], points := ![108,110,124,126,128,138], inverse := ![12,11,11,9,11,15,11,12,2,5,9,9,0,0,5,10,15,0,13,10,5,2,8,8,14,14,4,0,4,0,12,12,12,12,0,0] } }
theorem leafL_001_5_valid : (leafL_001_5).reject.ValidFor (leafL_001_5).leaf := by decide

noncomputable def leafL_001_6 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,156}, reject := .fullRank { members := ![0,1,17,34,52,67,89,156], points := ![106,127,128,139,166,171], inverse := ![7,0,9,15,12,12,12,7,13,5,6,5,5,2,10,11,11,13,6,9,1,1,2,13,10,0,3,5,11,7,11,9,13,12,0,3] } }
theorem leafL_001_6_valid : (leafL_001_6).reject.ValidFor (leafL_001_6).leaf := by decide

noncomputable def leafL_001_7 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,166}, reject := .fullRank { members := ![0,1,17,34,52,67,89,166], points := ![108,110,112,126,127,138], inverse := ![3,6,2,15,6,15,5,3,1,4,10,9,5,10,15,0,0,0,11,6,10,4,11,8,5,11,14,1,1,0,3,1,2,11,11,0] } }
theorem leafL_001_7_valid : (leafL_001_7).reject.ValidFor (leafL_001_7).leaf := by decide

noncomputable def leavesL_001 : List RejectedLeaf := [leafL_001_0,leafL_001_1,leafL_001_2,leafL_001_3,leafL_001_4,leafL_001_5,leafL_001_6,leafL_001_7]

theorem leavesL_001_valid : LeafListValid leavesL_001 := by
  intro x hx
  simp only [leavesL_001, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_001_0_valid
  · exact leafL_001_1_valid
  · exact leafL_001_2_valid
  · exact leafL_001_3_valid
  · exact leafL_001_4_valid
  · exact leafL_001_5_valid
  · exact leafL_001_6_valid
  · exact leafL_001_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
