import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_267_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,126,202}, reject := .fullRank { members := ![0,1,17,34,52,72,126,202], points := ![93,101,103,135,139,141], inverse := ![9,10,4,0,5,3,14,11,2,14,1,8,0,0,0,1,3,2,15,13,5,10,12,1,0,5,5,8,15,7,0,13,13,2,12,14] } }
theorem leafL_267_0_valid : (leafL_267_0).reject.ValidFor (leafL_267_0).leaf := by decide

noncomputable def leafL_267_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,126,203}, reject := .fullRank { members := ![0,1,17,34,52,72,126,203], points := ![92,93,96,141,143,149], inverse := ![8,13,13,6,5,10,1,8,15,11,2,15,8,2,10,0,0,0,5,0,1,2,4,2,9,11,2,15,15,0,9,4,13,7,7,0] } }
theorem leafL_267_1_valid : (leafL_267_1).reject.ValidFor (leafL_267_1).leaf := by decide

noncomputable def leafL_267_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,126,207}, reject := .fullRank { members := ![0,1,17,34,52,72,126,207], points := ![101,103,135,141,149,163], inverse := ![14,7,10,7,5,0,13,12,1,4,15,11,12,1,12,6,5,2,12,1,1,0,12,0,12,0,4,0,2,10,8,9,3,13,7,8] } }
theorem leafL_267_2_valid : (leafL_267_2).reject.ValidFor (leafL_267_2).leaf := by decide

noncomputable def leafL_267_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,126,268}, reject := .fullRank { members := ![0,1,17,34,52,72,126,268], points := ![93,101,103,112,139,141], inverse := ![9,10,4,0,5,3,14,3,12,6,0,7,0,11,1,10,0,0,15,15,15,8,1,6,0,2,13,15,4,4,0,8,15,7,10,10] } }
theorem leafL_267_3_valid : (leafL_267_3).reject.ValidFor (leafL_267_3).leaf := by decide

noncomputable def leafL_267_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,135,149}, reject := .fullRank { members := ![0,1,17,34,52,72,135,149], points := ![90,91,92,99,122,125], inverse := ![10,15,10,8,15,9,11,8,10,14,13,10,7,14,9,0,0,0,11,0,3,15,6,1,10,4,14,0,5,5,14,6,8,0,12,12] } }
theorem leafL_267_4_valid : (leafL_267_4).reject.ValidFor (leafL_267_4).leaf := by decide

noncomputable def leafL_267_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,135,156}, reject := .fullRank { members := ![0,1,17,34,52,72,135,156], points := ![115,122,128,166,174,181], inverse := ![2,8,12,1,12,10,10,13,8,7,14,6,7,8,15,0,0,0,5,11,12,6,0,4,8,1,9,6,6,0,10,9,3,1,1,0] } }
theorem leafL_267_5_valid : (leafL_267_5).reject.ValidFor (leafL_267_5).leaf := by decide

noncomputable def leafL_267_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,135,172}, reject := .fullRank { members := ![0,1,17,34,52,72,135,172], points := ![90,94,117,122,125,190], inverse := ![1,5,5,10,12,6,0,8,10,2,13,13,0,0,9,10,3,0,7,13,8,0,11,9,4,4,3,12,15,0,15,15,13,9,4,0] } }
theorem leafL_267_6_valid : (leafL_267_6).reject.ValidFor (leafL_267_6).leaf := by decide

noncomputable def leafL_267_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,135,186}, reject := .fullRank { members := ![0,1,17,34,52,72,135,186], points := ![91,99,108,115,117,125], inverse := ![15,13,5,0,12,10,9,15,1,10,11,6,0,0,0,9,11,2,8,1,14,13,7,13,0,4,4,5,0,5,0,15,15,7,13,10] } }
theorem leafL_267_7_valid : (leafL_267_7).reject.ValidFor (leafL_267_7).leaf := by decide

noncomputable def leavesL_267 : List RejectedLeaf := [leafL_267_0,leafL_267_1,leafL_267_2,leafL_267_3,leafL_267_4,leafL_267_5,leafL_267_6,leafL_267_7]

theorem leavesL_267_valid : LeafListValid leavesL_267 := by
  intro x hx
  simp only [leavesL_267, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_267_0_valid
  · exact leafL_267_1_valid
  · exact leafL_267_2_valid
  · exact leafL_267_3_valid
  · exact leafL_267_4_valid
  · exact leafL_267_5_valid
  · exact leafL_267_6_valid
  · exact leafL_267_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
