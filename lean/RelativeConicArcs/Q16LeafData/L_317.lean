import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_317_0 : RejectedLeaf := { leaf := {0,1,17,34,52,75,174,181}, reject := .fullRank { members := ![0,1,17,34,52,75,174,181], points := ![86,95,109,115,121,124], inverse := ![4,11,8,8,11,5,5,12,14,5,10,8,0,0,0,11,4,15,2,10,15,15,11,3,15,15,0,7,9,14,11,11,0,10,4,14] } }
theorem leafL_317_0_valid : (leafL_317_0).reject.ValidFor (leafL_317_0).leaf := by decide

noncomputable def leafL_317_1 : RejectedLeaf := { leaf := {0,1,17,34,52,75,174,191}, reject := .fullRank { members := ![0,1,17,34,52,75,174,191], points := ![86,99,109,121,122,138], inverse := ![4,11,8,11,6,11,12,14,5,5,7,5,14,13,3,13,3,14,4,1,2,4,15,12,4,5,1,0,4,4,3,13,14,2,1,3] } }
theorem leafL_317_1_valid : (leafL_317_1).reject.ValidFor (leafL_317_1).leaf := by decide

noncomputable def leafL_317_2 : RejectedLeaf := { leaf := {0,1,17,34,52,75,181,230}, reject := .fullRank { members := ![0,1,17,34,52,75,181,230], points := ![90,94,112,115,121,124], inverse := ![7,8,8,2,12,8,13,4,14,6,4,5,0,0,0,11,4,15,14,6,15,6,15,14,4,4,0,2,1,3,15,15,0,2,9,11] } }
theorem leafL_317_2_valid : (leafL_317_2).reject.ValidFor (leafL_317_2).leaf := by decide

noncomputable def leafL_317_3 : RejectedLeaf := { leaf := {0,1,17,34,52,75,197,216}, reject := .fullRank { members := ![0,1,17,34,52,75,197,216], points := ![86,90,95,109,115,122], inverse := ![11,10,14,8,13,11,5,0,12,14,14,9,4,9,13,0,0,0,6,9,7,15,3,4,5,12,9,0,10,10,11,0,11,0,11,11] } }
theorem leafL_317_3_valid : (leafL_317_3).reject.ValidFor (leafL_317_3).leaf := by decide

noncomputable def leafL_317_4 : RejectedLeaf := { leaf := {0,1,17,34,52,75,197,240}, reject := .fullRank { members := ![0,1,17,34,52,75,197,240], points := ![86,90,95,99,103,115], inverse := ![11,15,11,10,2,6,9,9,9,14,0,7,4,9,13,0,0,0,3,7,12,6,9,7,10,1,11,1,1,0,12,14,2,13,13,0] } }
theorem leafL_317_4_valid : (leafL_317_4).reject.ValidFor (leafL_317_4).leaf := by decide

noncomputable def leafL_317_5 : RejectedLeaf := { leaf := {0,1,17,34,52,75,201,248}, reject := .fullRank { members := ![0,1,17,34,52,75,201,248], points := ![86,90,124,126,131,133], inverse := ![2,5,10,4,15,7,6,1,9,0,8,6,1,1,6,6,4,4,8,15,14,6,10,5,6,6,1,1,10,10,0,0,7,7,7,7] } }
theorem leafL_317_5_valid : (leafL_317_5).reject.ValidFor (leafL_317_5).leaf := by decide

noncomputable def leafL_317_6 : RejectedLeaf := { leaf := {0,1,17,34,52,75,202,240}, reject := .fullRank { members := ![0,1,17,34,52,75,202,240], points := ![94,95,99,109,121,124], inverse := ![4,11,12,4,9,15,9,0,1,15,14,9,2,2,12,12,15,15,0,8,10,5,1,6,7,7,7,7,13,13,7,7,0,0,7,7] } }
theorem leafL_317_6_valid : (leafL_317_6).reject.ValidFor (leafL_317_6).leaf := by decide

noncomputable def leafL_317_7 : RejectedLeaf := { leaf := {0,1,17,34,52,75,214,268}, reject := .fullRank { members := ![0,1,17,34,52,75,214,268], points := ![93,103,112,115,122,125], inverse := ![15,0,8,14,13,5,9,2,12,12,10,1,0,0,0,15,1,14,8,12,3,13,8,2,0,4,4,5,0,5,0,15,15,9,12,5] } }
theorem leafL_317_7_valid : (leafL_317_7).reject.ValidFor (leafL_317_7).leaf := by decide

noncomputable def leavesL_317 : List RejectedLeaf := [leafL_317_0,leafL_317_1,leafL_317_2,leafL_317_3,leafL_317_4,leafL_317_5,leafL_317_6,leafL_317_7]

theorem leavesL_317_valid : LeafListValid leavesL_317 := by
  intro x hx
  simp only [leavesL_317, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_317_0_valid
  · exact leafL_317_1_valid
  · exact leafL_317_2_valid
  · exact leafL_317_3_valid
  · exact leafL_317_4_valid
  · exact leafL_317_5_valid
  · exact leafL_317_6_valid
  · exact leafL_317_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
