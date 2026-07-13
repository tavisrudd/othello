import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_002_0 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,167}, reject := .fullRank { members := ![0,1,17,34,52,67,89,167], points := ![126,128,139,181,190,191], inverse := ![8,5,2,6,14,6,2,8,4,2,6,10,0,0,0,11,15,4,13,6,5,2,15,3,4,4,0,9,4,13,5,5,0,2,10,8] } }
theorem leafL_002_0_valid : (leafL_002_0).reject.ValidFor (leafL_002_0).leaf := by decide

noncomputable def leafL_002_1 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,171}, reject := .fullRank { members := ![0,1,17,34,52,67,89,171], points := ![106,112,126,127,128,138], inverse := ![0,7,3,13,7,15,7,0,12,9,11,9,0,0,7,14,9,0,1,6,10,4,1,8,14,14,11,6,13,0,12,12,2,10,8,0] } }
theorem leafL_002_1_valid : (leafL_002_1).reject.ValidFor (leafL_002_1).leaf := by decide

noncomputable def leafL_002_2 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,173}, reject := .fullRank { members := ![0,1,17,34,52,67,89,173], points := ![110,112,124,126,138,139], inverse := ![2,5,14,7,11,4,15,8,1,15,5,12,11,11,3,3,5,5,1,6,1,14,12,4,9,9,8,8,3,3,1,1,8,8,12,12] } }
theorem leafL_002_2_valid : (leafL_002_2).reject.ValidFor (leafL_002_2).leaf := by decide

noncomputable def leafL_002_3 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,176}, reject := .fullRank { members := ![0,1,17,34,52,67,89,176], points := ![108,110,124,127,138,156], inverse := ![3,6,8,2,3,13,13,0,1,0,0,12,1,2,2,9,10,2,12,8,15,11,2,2,13,8,8,6,13,6,13,14,10,1,10,2] } }
theorem leafL_002_3_valid : (leafL_002_3).reject.ValidFor (leafL_002_3).leaf := by decide

noncomputable def leafL_002_4 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,181}, reject := .fullRank { members := ![0,1,17,34,52,67,89,181], points := ![108,110,127,138,139,141], inverse := ![11,12,9,11,15,11,10,13,14,1,15,7,0,0,0,8,12,4,12,11,15,13,13,8,3,3,0,5,10,15,10,10,0,0,10,10] } }
theorem leafL_002_4_valid : (leafL_002_4).reject.ValidFor (leafL_002_4).leaf := by decide

noncomputable def leafL_002_5 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,186}, reject := .fullRank { members := ![0,1,17,34,52,67,89,186], points := ![124,128,141,149,155,156], inverse := ![13,9,14,15,15,11,12,15,8,14,1,4,0,0,0,11,3,8,13,15,9,5,5,11,6,6,0,0,10,10,4,4,0,3,1,2] } }
theorem leafL_002_5_valid : (leafL_002_5).reject.ValidFor (leafL_002_5).leaf := by decide

noncomputable def leafL_002_6 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,190}, reject := .fullRank { members := ![0,1,17,34,52,67,89,190], points := ![106,128,141,151,155,167], inverse := ![13,0,0,0,10,6,11,15,12,2,1,11,15,10,15,12,13,11,5,7,15,6,0,11,2,3,12,9,4,0,12,13,9,8,7,7] } }
theorem leafL_002_6_valid : (leafL_002_6).reject.ValidFor (leafL_002_6).leaf := by decide

noncomputable def leafL_002_7 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,197}, reject := .fullRank { members := ![0,1,17,34,52,67,89,197], points := ![108,110,126,138,139,141], inverse := ![4,3,9,2,9,4,0,7,14,15,11,13,0,0,0,8,12,4,11,12,15,2,5,15,3,3,0,5,10,15,10,10,0,0,10,10] } }
theorem leafL_002_7_valid : (leafL_002_7).reject.ValidFor (leafL_002_7).leaf := by decide

noncomputable def leavesL_002 : List RejectedLeaf := [leafL_002_0,leafL_002_1,leafL_002_2,leafL_002_3,leafL_002_4,leafL_002_5,leafL_002_6,leafL_002_7]

theorem leavesL_002_valid : LeafListValid leavesL_002 := by
  intro x hx
  simp only [leavesL_002, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_002_0_valid
  · exact leafL_002_1_valid
  · exact leafL_002_2_valid
  · exact leafL_002_3_valid
  · exact leafL_002_4_valid
  · exact leafL_002_5_valid
  · exact leafL_002_6_valid
  · exact leafL_002_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
