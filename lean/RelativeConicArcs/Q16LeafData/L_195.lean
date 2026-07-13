import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_195_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,126,139}, reject := .fullRank { members := ![0,1,17,34,52,71,126,139], points := ![90,92,104,106,150,154], inverse := ![1,7,0,11,3,15,10,0,0,4,0,14,15,15,7,7,10,10,2,9,9,12,9,7,0,0,10,10,3,3,1,1,1,1,1,1] } }
theorem leafL_195_0_valid : (leafL_195_0).reject.ValidFor (leafL_195_0).leaf := by decide

noncomputable def leafL_195_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,126,147}, reject := .fullRank { members := ![0,1,17,34,52,71,126,147], points := ![92,96,101,106,140,141], inverse := ![9,0,1,15,5,3,13,3,10,3,0,7,11,11,9,9,13,13,1,14,1,9,13,10,3,3,0,0,8,8,1,1,9,9,15,15] } }
theorem leafL_195_1_valid : (leafL_195_1).reject.ValidFor (leafL_195_1).leaf := by decide

noncomputable def leafL_195_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,126,173}, reject := .fullRank { members := ![0,1,17,34,52,71,126,173], points := ![92,96,101,104,106,138], inverse := ![2,11,10,8,12,6,9,7,1,4,12,7,0,0,13,1,12,0,14,1,14,5,3,7,12,12,11,6,13,0,13,13,11,9,2,0] } }
theorem leafL_195_2_valid : (leafL_195_2).reject.ValidFor (leafL_195_2).leaf := by decide

noncomputable def leafL_195_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,126,176}, reject := .fullRank { members := ![0,1,17,34,52,71,126,176], points := ![90,101,104,131,138,139], inverse := ![9,11,5,10,7,11,14,12,5,13,8,2,0,0,0,6,3,5,15,13,5,4,15,12,0,6,6,10,13,7,0,7,7,0,7,7] } }
theorem leafL_195_3_valid : (leafL_195_3).reject.ValidFor (leafL_195_3).leaf := by decide

noncomputable def leafL_195_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,126,191}, reject := .fullRank { members := ![0,1,17,34,52,71,126,191], points := ![90,92,101,131,138,141], inverse := ![12,5,14,12,0,10,11,5,9,13,4,14,0,0,0,15,1,14,10,5,8,0,0,7,6,6,0,11,1,10,7,7,0,8,4,12] } }
theorem leafL_195_4_valid : (leafL_195_4).reject.ValidFor (leafL_195_4).leaf := by decide

noncomputable def leafL_195_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,126,197}, reject := .fullRank { members := ![0,1,17,34,52,71,126,197], points := ![92,104,106,138,139,140], inverse := ![9,4,10,6,5,5,14,3,10,2,4,1,0,0,0,7,14,9,15,2,10,11,9,5,0,13,13,5,1,4,0,8,8,12,2,14] } }
theorem leafL_195_5_valid : (leafL_195_5).reject.ValidFor (leafL_195_5).leaf := by decide

noncomputable def leafL_195_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,126,203}, reject := .fullRank { members := ![0,1,17,34,52,71,126,203], points := ![90,96,106,140,141,147], inverse := ![6,8,2,6,8,3,1,1,2,2,6,6,5,14,8,12,13,2,14,11,14,1,2,8,3,10,7,5,14,5,15,7,9,6,8,15] } }
theorem leafL_195_6_valid : (leafL_195_6).reject.ValidFor (leafL_195_6).leaf := by decide

noncomputable def leafL_195_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,126,207}, reject := .fullRank { members := ![0,1,17,34,52,71,126,207], points := ![90,92,101,139,140,141], inverse := ![12,5,14,14,7,15,11,5,9,4,7,4,0,0,0,7,6,1,10,5,8,0,0,7,6,6,0,12,10,6,7,7,0,9,8,1] } }
theorem leafL_195_7_valid : (leafL_195_7).reject.ValidFor (leafL_195_7).leaf := by decide

noncomputable def leavesL_195 : List RejectedLeaf := [leafL_195_0,leafL_195_1,leafL_195_2,leafL_195_3,leafL_195_4,leafL_195_5,leafL_195_6,leafL_195_7]

theorem leavesL_195_valid : LeafListValid leavesL_195 := by
  intro x hx
  simp only [leavesL_195, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_195_0_valid
  · exact leafL_195_1_valid
  · exact leafL_195_2_valid
  · exact leafL_195_3_valid
  · exact leafL_195_4_valid
  · exact leafL_195_5_valid
  · exact leafL_195_6_valid
  · exact leafL_195_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
