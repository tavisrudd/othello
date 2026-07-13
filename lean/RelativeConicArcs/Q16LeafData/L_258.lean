import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_258_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,103,240}, reject := .fullRank { members := ![0,1,17,34,52,72,103,240], points := ![94,124,125,143,150,169], inverse := ![10,15,7,4,14,9,6,1,8,0,6,9,4,14,0,3,5,12,3,2,8,0,9,0,13,15,13,8,10,13,14,8,4,7,14,11] } }
theorem leafL_258_0_valid : (leafL_258_0).reject.ValidFor (leafL_258_0).leaf := by decide

noncomputable def leafL_258_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,103,249}, reject := .fullRank { members := ![0,1,17,34,52,72,103,249], points := ![83,93,126,143,150,159], inverse := ![4,3,14,8,9,9,15,10,8,0,7,10,12,7,12,4,13,14,3,3,2,9,8,3,1,7,3,1,13,9,8,2,5,3,5,9] } }
theorem leafL_258_1_valid : (leafL_258_1).reject.ValidFor (leafL_258_1).leaf := by decide

noncomputable def leafL_258_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,103,251}, reject := .fullRank { members := ![0,1,17,34,52,72,103,251], points := ![83,93,94,124,125,138], inverse := ![5,1,3,12,2,8,14,10,3,15,6,14,11,3,8,0,0,0,11,1,13,10,2,15,6,7,1,12,12,0,14,12,2,3,3,0] } }
theorem leafL_258_2_valid : (leafL_258_2).reject.ValidFor (leafL_258_2).leaf := by decide

noncomputable def leafL_258_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,103,254}, reject := .fullRank { members := ![0,1,17,34,52,72,103,254], points := ![83,91,93,125,138,147], inverse := ![7,6,4,15,6,13,8,2,6,5,10,3,2,11,9,0,0,0,10,15,1,0,6,2,11,0,9,1,14,13,5,2,14,13,10,14] } }
theorem leafL_258_3_valid : (leafL_258_3).reject.ValidFor (leafL_258_3).leaf := by decide

noncomputable def leafL_258_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,103,268}, reject := .fullRank { members := ![0,1,17,34,52,72,103,268], points := ![83,91,93,125,126,139], inverse := ![1,14,8,11,5,8,1,11,13,10,3,14,2,11,9,0,0,0,0,15,8,8,0,15,3,14,13,2,2,0,7,8,15,9,9,0] } }
theorem leafL_258_4_valid : (leafL_258_4).reject.ValidFor (leafL_258_4).leaf := by decide

noncomputable def leafL_258_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,107,122}, reject := .fullRank { members := ![0,1,17,34,52,72,107,122], points := ![83,94,144,149,150,156], inverse := ![4,12,3,13,7,0,10,12,9,5,2,8,0,0,0,8,3,11,6,2,6,8,15,5,1,1,0,8,2,10,15,15,0,15,0,15] } }
theorem leafL_258_5_valid : (leafL_258_5).reject.ValidFor (leafL_258_5).leaf := by decide

noncomputable def leafL_258_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,107,138}, reject := .fullRank { members := ![0,1,17,34,52,72,107,138], points := ![92,115,126,163,166,172], inverse := ![6,1,9,0,3,12,2,7,3,15,1,8,0,0,0,12,10,6,13,8,9,5,7,14,0,6,6,1,7,6,0,12,12,10,4,14] } }
theorem leafL_258_6_valid : (leafL_258_6).reject.ValidFor (leafL_258_6).leaf := by decide

noncomputable def leafL_258_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,107,156}, reject := .fullRank { members := ![0,1,17,34,52,72,107,156], points := ![83,115,117,122,137,144], inverse := ![7,9,14,9,2,10,7,5,1,13,9,7,0,8,15,7,0,0,7,14,1,7,13,2,0,6,6,0,7,7,0,15,8,7,6,6] } }
theorem leafL_258_7_valid : (leafL_258_7).reject.ValidFor (leafL_258_7).leaf := by decide

noncomputable def leavesL_258 : List RejectedLeaf := [leafL_258_0,leafL_258_1,leafL_258_2,leafL_258_3,leafL_258_4,leafL_258_5,leafL_258_6,leafL_258_7]

theorem leavesL_258_valid : LeafListValid leavesL_258 := by
  intro x hx
  simp only [leavesL_258, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_258_0_valid
  · exact leafL_258_1_valid
  · exact leafL_258_2_valid
  · exact leafL_258_3_valid
  · exact leafL_258_4_valid
  · exact leafL_258_5_valid
  · exact leafL_258_6_valid
  · exact leafL_258_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
