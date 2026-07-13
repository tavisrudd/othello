import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_011_0 : RejectedLeaf := { leaf := {0,1,17,34,52,67,159,190}, reject := .fullRank { members := ![0,1,17,34,52,67,159,190], points := ![92,106,121,139,171,173], inverse := ![12,12,3,9,13,6,2,4,11,2,11,4,6,15,12,11,5,11,6,4,1,5,11,13,4,7,13,12,10,8,6,6,6,6,0,0] } }
theorem leafL_011_0_valid : (leafL_011_0).reject.ValidFor (leafL_011_0).leaf := by decide

noncomputable def leafL_011_1 : RejectedLeaf := { leaf := {0,1,17,34,52,67,159,205}, reject := .forcedHit { members := ![0,1,17,34,52,67,159,205], points := ![176,190,220,235,249,176], coeffs := ![7,6,1,7,6,0], hit := 159 } }
theorem leafL_011_1_valid : (leafL_011_1).reject.ValidFor (leafL_011_1).leaf := by decide

noncomputable def leafL_011_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,99}, reject := .forcedHit { members := ![0,1,17,34,52,69,86,99], points := ![128,138,151,171,189,128], coeffs := ![4,13,15,2,4,0], hit := 0 } }
theorem leafL_011_2_valid : (leafL_011_2).reject.ValidFor (leafL_011_2).leaf := by decide

noncomputable def leafL_011_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,103}, reject := .fullRank { members := ![0,1,17,34,52,69,86,103], points := ![124,126,128,139,152,159], inverse := ![2,15,9,14,4,15,0,14,13,8,7,12,5,10,15,0,0,0,3,12,13,9,14,5,0,12,12,0,7,7,3,14,13,0,6,6] } }
theorem leafL_011_3_valid : (leafL_011_3).reject.ValidFor (leafL_011_3).leaf := by decide

noncomputable def leafL_011_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,104}, reject := .fullRank { members := ![0,1,17,34,52,69,86,104], points := ![126,138,139,141,172,189], inverse := ![15,9,2,14,11,0,7,1,4,10,3,11,0,8,12,4,0,0,2,1,1,0,6,4,9,2,9,14,6,10,3,1,0,12,7,9] } }
theorem leafL_011_4_valid : (leafL_011_4).reject.ValidFor (leafL_011_4).leaf := by decide

noncomputable def leafL_011_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,107}, reject := .fullRank { members := ![0,1,17,34,52,69,86,107], points := ![124,138,151,152,172,173], inverse := ![15,5,10,10,4,15,12,7,14,10,2,13,4,4,12,8,2,6,9,2,6,6,7,12,3,3,12,15,13,14,11,11,15,4,10,1] } }
theorem leafL_011_5_valid : (leafL_011_5).reject.ValidFor (leafL_011_5).leaf := by decide

noncomputable def leafL_011_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,110}, reject := .fullRank { members := ![0,1,17,34,52,69,86,110], points := ![128,141,152,159,163,172], inverse := ![11,1,5,1,7,8,15,4,6,1,9,5,13,13,0,13,3,14,0,11,9,0,4,6,15,15,1,14,11,4,0,0,2,2,2,2] } }
theorem leafL_011_6_valid : (leafL_011_6).reject.ValidFor (leafL_011_6).leaf := by decide

noncomputable def leafL_011_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,124}, reject := .fullRank { members := ![0,1,17,34,52,69,86,124], points := ![103,107,139,159,171,173], inverse := ![2,10,3,2,2,10,0,5,8,0,13,0,10,0,6,3,10,5,3,12,14,2,8,11,3,4,12,6,8,5,7,8,5,11,12,13] } }
theorem leafL_011_7_valid : (leafL_011_7).reject.ValidFor (leafL_011_7).leaf := by decide

noncomputable def leavesL_011 : List RejectedLeaf := [leafL_011_0,leafL_011_1,leafL_011_2,leafL_011_3,leafL_011_4,leafL_011_5,leafL_011_6,leafL_011_7]

theorem leavesL_011_valid : LeafListValid leavesL_011 := by
  intro x hx
  simp only [leavesL_011, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_011_0_valid
  · exact leafL_011_1_valid
  · exact leafL_011_2_valid
  · exact leafL_011_3_valid
  · exact leafL_011_4_valid
  · exact leafL_011_5_valid
  · exact leafL_011_6_valid
  · exact leafL_011_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
