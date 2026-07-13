import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_179_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,159}, reject := .fullRank { members := ![0,1,17,34,52,71,104,159], points := ![83,92,121,139,169,176], inverse := ![5,15,6,10,4,3,1,7,15,6,11,4,9,1,5,12,9,8,2,5,8,15,13,13,0,12,14,10,14,6,7,5,12,3,4,9] } }
theorem leafL_179_0_valid : (leafL_179_0).reject.ValidFor (leafL_179_0).leaf := by decide

noncomputable def leafL_179_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,169}, reject := .fullRank { members := ![0,1,17,34,52,71,104,169], points := ![91,94,128,139,140,155], inverse := ![5,11,3,3,1,14,6,0,0,9,0,15,6,14,4,6,11,1,2,11,15,1,2,5,10,11,9,9,14,15,14,13,8,2,11,2] } }
theorem leafL_179_1_valid : (leafL_179_1).reject.ValidFor (leafL_179_1).leaf := by decide

noncomputable def leafL_179_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,173}, reject := .fullRank { members := ![0,1,17,34,52,71,104,173], points := ![83,92,94,126,139,140], inverse := ![6,6,7,14,11,3,1,11,13,9,2,12,3,14,13,0,0,0,7,7,7,8,14,1,5,3,6,0,13,13,7,8,15,0,14,14] } }
theorem leafL_179_2_valid : (leafL_179_2).reject.ValidFor (leafL_179_2).leaf := by decide

noncomputable def leafL_179_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,176}, reject := .fullRank { members := ![0,1,17,34,52,71,104,176], points := ![83,90,91,126,140,156], inverse := ![0,3,8,8,10,8,14,5,13,0,9,15,6,3,5,0,0,0,3,12,15,2,9,11,11,8,12,14,11,10,13,4,14,10,6,11] } }
theorem leafL_179_3_valid : (leafL_179_3).reject.ValidFor (leafL_179_3).leaf := by decide

noncomputable def leafL_179_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,182}, reject := .fullRank { members := ![0,1,17,34,52,71,104,182], points := ![91,92,94,121,126,140], inverse := ![4,0,3,4,10,8,13,15,5,14,7,14,6,7,1,0,0,0,5,8,10,12,4,15,0,9,9,5,5,0,5,7,2,12,12,0] } }
theorem leafL_179_4_valid : (leafL_179_4).reject.ValidFor (leafL_179_4).leaf := by decide

noncomputable def leafL_179_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,186}, reject := .fullRank { members := ![0,1,17,34,52,71,104,186], points := ![91,121,140,141,155,156], inverse := ![6,7,12,3,13,2,5,8,5,5,6,11,1,9,5,2,7,8,7,8,10,5,4,4,15,14,8,3,6,12,5,11,7,15,0,6] } }
theorem leafL_179_5_valid : (leafL_179_5).reject.ValidFor (leafL_179_5).leaf := by decide

noncomputable def leafL_179_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,188}, reject := .fullRank { members := ![0,1,17,34,52,71,104,188], points := ![83,90,91,128,141,158], inverse := ![8,9,14,10,5,1,13,13,8,7,5,10,6,3,5,0,0,0,13,1,0,4,11,3,10,7,10,10,6,11,0,3,6,11,8,6] } }
theorem leafL_179_6_valid : (leafL_179_6).reject.ValidFor (leafL_179_6).leaf := by decide

noncomputable def leafL_179_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,197}, reject := .fullRank { members := ![0,1,17,34,52,71,104,197], points := ![90,92,94,126,128,139], inverse := ![15,14,6,2,12,8,13,6,12,12,5,14,15,10,5,0,0,0,7,2,2,12,4,15,5,15,10,1,1,0,13,13,0,13,13,0] } }
theorem leafL_179_7_valid : (leafL_179_7).reject.ValidFor (leafL_179_7).leaf := by decide

noncomputable def leavesL_179 : List RejectedLeaf := [leafL_179_0,leafL_179_1,leafL_179_2,leafL_179_3,leafL_179_4,leafL_179_5,leafL_179_6,leafL_179_7]

theorem leavesL_179_valid : LeafListValid leavesL_179 := by
  intro x hx
  simp only [leavesL_179, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_179_0_valid
  · exact leafL_179_1_valid
  · exact leafL_179_2_valid
  · exact leafL_179_3_valid
  · exact leafL_179_4_valid
  · exact leafL_179_5_valid
  · exact leafL_179_6_valid
  · exact leafL_179_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
