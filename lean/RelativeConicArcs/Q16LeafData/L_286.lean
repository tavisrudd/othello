import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_286_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,201,270}, reject := .fullRank { members := ![0,1,17,34,52,72,201,270], points := ![83,96,101,112,128,139], inverse := ![6,13,0,12,2,4,0,9,0,14,7,0,4,8,14,2,12,12,10,7,11,1,2,5,12,2,5,11,14,14,15,1,7,9,14,14] } }
theorem leafL_286_0_valid : (leafL_286_0).reject.ValidFor (leafL_286_0).leaf := by decide

noncomputable def leafL_286_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,202,220}, reject := .fullRank { members := ![0,1,17,34,52,72,202,220], points := ![94,99,101,103,117,139], inverse := ![5,9,14,5,12,10,12,14,15,10,2,5,0,5,10,15,0,0,8,4,5,14,7,0,8,3,8,3,8,8,7,12,15,4,7,7] } }
theorem leafL_286_1_valid : (leafL_286_1).reject.ValidFor (leafL_286_1).leaf := by decide

noncomputable def leafL_286_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,203,217}, reject := .fullRank { members := ![0,1,17,34,52,72,203,217], points := ![93,96,99,108,125,126], inverse := ![7,8,10,2,9,15,3,10,5,11,13,10,11,11,10,10,11,11,0,8,11,4,11,12,5,5,3,3,6,6,12,12,10,10,2,2] } }
theorem leafL_286_2_valid : (leafL_286_2).reject.ValidFor (leafL_286_2).leaf := by decide

noncomputable def leafL_286_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,203,220}, reject := .fullRank { members := ![0,1,17,34,52,72,203,220], points := ![90,96,99,112,141,147], inverse := ![7,14,3,13,6,0,3,12,15,8,2,10,14,4,5,3,4,8,9,10,9,5,14,1,12,13,10,4,5,10,15,13,5,10,10,7] } }
theorem leafL_286_3_valid : (leafL_286_3).reject.ValidFor (leafL_286_3).leaf := by decide

noncomputable def leafL_286_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,207,220}, reject := .fullRank { members := ![0,1,17,34,52,72,207,220], points := ![91,94,99,103,115,128], inverse := ![9,6,9,1,13,11,6,15,5,11,0,7,8,8,5,5,14,14,3,11,5,10,12,11,10,10,0,0,8,8,13,13,2,2,1,1] } }
theorem leafL_286_4_valid : (leafL_286_4).reject.ValidFor (leafL_286_4).leaf := by decide

noncomputable def leafL_286_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,207,222}, reject := .fullRank { members := ![0,1,17,34,52,72,207,222], points := ![90,99,107,108,115,124], inverse := ![15,0,2,10,8,14,9,11,3,6,15,8,0,13,15,2,0,0,8,13,5,7,1,6,0,11,14,5,6,6,0,15,0,15,15,15] } }
theorem leafL_286_5_valid : (leafL_286_5).reject.ValidFor (leafL_286_5).leaf := by decide

noncomputable def leafL_286_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,207,233}, reject := .fullRank { members := ![0,1,17,34,52,72,207,233], points := ![91,94,99,101,107,115], inverse := ![0,15,3,2,9,6,2,11,2,13,1,7,0,0,11,9,2,0,10,2,3,11,7,7,13,13,1,7,6,0,6,6,12,14,2,0] } }
theorem leafL_286_6_valid : (leafL_286_6).reject.ValidFor (leafL_286_6).leaf := by decide

noncomputable def leafL_286_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,207,240}, reject := .fullRank { members := ![0,1,17,34,52,72,207,240], points := ![90,94,101,103,115,122], inverse := ![3,12,3,11,1,7,10,3,15,1,7,0,13,13,14,14,3,3,5,13,1,14,11,12,11,11,7,7,2,2,5,5,11,11,10,10] } }
theorem leafL_286_7_valid : (leafL_286_7).reject.ValidFor (leafL_286_7).leaf := by decide

noncomputable def leavesL_286 : List RejectedLeaf := [leafL_286_0,leafL_286_1,leafL_286_2,leafL_286_3,leafL_286_4,leafL_286_5,leafL_286_6,leafL_286_7]

theorem leavesL_286_valid : LeafListValid leavesL_286 := by
  intro x hx
  simp only [leavesL_286, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_286_0_valid
  · exact leafL_286_1_valid
  · exact leafL_286_2_valid
  · exact leafL_286_3_valid
  · exact leafL_286_4_valid
  · exact leafL_286_5_valid
  · exact leafL_286_6_valid
  · exact leafL_286_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
