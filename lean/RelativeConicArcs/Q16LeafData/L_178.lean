import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_178_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,126}, reject := .fullRank { members := ![0,1,17,34,52,71,104,126], points := ![90,92,139,141,154,173], inverse := ![15,9,12,4,8,7,14,7,15,3,11,14,11,9,14,1,12,1,7,6,11,14,15,11,8,14,4,6,7,3,1,8,6,1,3,13] } }
theorem leafL_178_0_valid : (leafL_178_0).reject.ValidFor (leafL_178_0).leaf := by decide

noncomputable def leafL_178_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,128}, reject := .fullRank { members := ![0,1,17,34,52,71,104,128], points := ![83,94,139,140,154,155], inverse := ![1,9,5,6,11,1,1,7,15,6,9,6,14,14,4,4,14,14,5,1,12,10,1,3,9,9,10,10,3,3,1,1,4,4,8,8] } }
theorem leafL_178_1_valid : (leafL_178_1).reject.ValidFor (leafL_178_1).leaf := by decide

noncomputable def leafL_178_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,139}, reject := .fullRank { members := ![0,1,17,34,52,71,104,139], points := ![90,92,121,126,128,154], inverse := ![6,4,7,5,7,6,5,0,11,9,10,13,0,0,15,12,3,0,12,15,13,9,14,9,8,8,13,10,7,0,13,13,0,13,13,0] } }
theorem leafL_178_2_valid : (leafL_178_2).reject.ValidFor (leafL_178_2).leaf := by decide

noncomputable def leafL_178_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,140}, reject := .fullRank { members := ![0,1,17,34,52,71,104,140], points := ![94,128,155,158,169,173], inverse := ![1,4,2,15,9,0,9,12,10,13,11,9,1,14,9,1,9,14,8,2,11,5,1,5,12,4,5,15,4,6,3,1,14,5,5,12] } }
theorem leafL_178_3_valid : (leafL_178_3).reject.ValidFor (leafL_178_3).leaf := by decide

noncomputable def leafL_178_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,154}, reject := .fullRank { members := ![0,1,17,34,52,71,104,154], points := ![83,92,126,128,139,172], inverse := ![1,2,12,9,14,9,2,13,3,15,2,1,11,8,13,7,11,2,4,3,12,4,15,0,11,12,2,3,13,11,12,11,14,15,13,11] } }
theorem leafL_178_4_valid : (leafL_178_4).reject.ValidFor (leafL_178_4).leaf := by decide

noncomputable def leafL_178_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,155}, reject := .fullRank { members := ![0,1,17,34,52,71,104,155], points := ![83,90,92,128,140,169], inverse := ![8,15,13,6,10,7,9,4,4,11,7,5,10,11,1,0,0,0,13,9,0,2,4,2,15,4,5,2,9,5,2,2,10,9,15,12] } }
theorem leafL_178_5_valid : (leafL_178_5).reject.ValidFor (leafL_178_5).leaf := by decide

noncomputable def leafL_178_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,156}, reject := .fullRank { members := ![0,1,17,34,52,71,104,156], points := ![94,139,141,176,185,186], inverse := ![4,9,4,7,4,11,11,8,15,10,14,8,9,8,1,9,15,6,12,7,12,1,3,5,15,14,1,15,8,7,14,14,0,14,14,0] } }
theorem leafL_178_6_valid : (leafL_178_6).reject.ValidFor (leafL_178_6).leaf := by decide

noncomputable def leafL_178_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,158}, reject := .fullRank { members := ![0,1,17,34,52,71,104,158], points := ![83,91,92,121,128,139], inverse := ![12,12,7,11,5,8,12,1,10,15,6,14,13,15,2,0,0,0,9,15,1,15,7,15,14,4,10,12,12,0,4,11,15,3,3,0] } }
theorem leafL_178_7_valid : (leafL_178_7).reject.ValidFor (leafL_178_7).leaf := by decide

noncomputable def leavesL_178 : List RejectedLeaf := [leafL_178_0,leafL_178_1,leafL_178_2,leafL_178_3,leafL_178_4,leafL_178_5,leafL_178_6,leafL_178_7]

theorem leavesL_178_valid : LeafListValid leavesL_178 := by
  intro x hx
  simp only [leavesL_178, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_178_0_valid
  · exact leafL_178_1_valid
  · exact leafL_178_2_valid
  · exact leafL_178_3_valid
  · exact leafL_178_4_valid
  · exact leafL_178_5_valid
  · exact leafL_178_6_valid
  · exact leafL_178_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
