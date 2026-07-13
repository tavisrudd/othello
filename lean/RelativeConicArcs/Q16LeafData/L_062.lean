import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_062_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,195}, reject := .fullRank { members := ![0,1,17,34,52,69,104,195], points := ![86,91,94,126,127,137], inverse := ![4,13,14,14,0,8,12,12,7,1,8,14,1,5,4,0,0,0,2,4,1,14,6,15,15,12,3,15,15,0,2,9,11,7,7,0] } }
theorem leafL_062_0_valid : (leafL_062_0).reject.ValidFor (leafL_062_0).leaf := by decide

noncomputable def leafL_062_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,198}, reject := .fullRank { members := ![0,1,17,34,52,69,104,198], points := ![90,91,92,127,137,138], inverse := ![4,4,7,14,7,15,13,1,11,9,12,2,7,14,9,0,0,0,10,4,9,8,0,15,7,2,5,0,13,13,0,14,14,0,14,14] } }
theorem leafL_062_1_valid : (leafL_062_1).reject.ValidFor (leafL_062_1).leaf := by decide

noncomputable def leafL_062_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,201}, reject := .fullRank { members := ![0,1,17,34,52,69,104,201], points := ![91,92,126,127,138,139], inverse := ![7,0,11,5,7,15,0,7,8,1,11,5,9,9,9,9,14,14,14,9,13,5,8,7,8,8,4,4,3,3,0,0,14,14,14,14] } }
theorem leafL_062_2_valid : (leafL_062_2).reject.ValidFor (leafL_062_2).leaf := by decide

noncomputable def leafL_062_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,205}, reject := .fullRank { members := ![0,1,17,34,52,69,104,205], points := ![86,89,91,126,127,138], inverse := ![6,11,10,10,4,8,1,3,5,6,15,14,6,2,4,0,0,0,13,8,2,0,8,15,0,8,8,15,15,0,3,12,15,7,7,0] } }
theorem leafL_062_3_valid : (leafL_062_3).reject.ValidFor (leafL_062_3).leaf := by decide

noncomputable def leafL_062_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,211}, reject := .fullRank { members := ![0,1,17,34,52,69,104,211], points := ![86,91,92,126,127,137], inverse := ![12,6,13,14,0,8,8,0,15,1,8,14,11,8,3,0,0,0,9,10,4,14,6,15,1,13,12,15,15,0,11,1,10,7,7,0] } }
theorem leafL_062_4_valid : (leafL_062_4).reject.ValidFor (leafL_062_4).leaf := by decide

noncomputable def leafL_062_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,222}, reject := .fullRank { members := ![0,1,17,34,52,69,104,222], points := ![89,90,115,137,139,156], inverse := ![13,7,1,11,6,7,1,0,10,13,2,4,2,15,15,0,5,7,7,8,12,7,5,1,6,10,6,15,13,8,12,1,15,7,2,7] } }
theorem leafL_062_5_valid : (leafL_062_5).reject.ValidFor (leafL_062_5).leaf := by decide

noncomputable def leafL_062_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,223}, reject := .fullRank { members := ![0,1,17,34,52,69,104,223], points := ![86,90,94,126,137,138], inverse := ![12,15,4,14,8,0,15,13,5,9,13,3,12,11,7,0,0,0,8,8,7,8,3,12,10,4,14,0,13,13,7,4,3,0,14,14] } }
theorem leafL_062_6_valid : (leafL_062_6).reject.ValidFor (leafL_062_6).leaf := by decide

noncomputable def leafL_062_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,104,230}, reject := .fullRank { members := ![0,1,17,34,52,69,104,230], points := ![89,90,92,115,127,138], inverse := ![5,13,15,11,5,8,15,6,14,8,1,14,14,9,7,0,0,0,4,14,13,0,8,15,10,7,13,7,7,0,12,7,11,5,5,0] } }
theorem leafL_062_7_valid : (leafL_062_7).reject.ValidFor (leafL_062_7).leaf := by decide

noncomputable def leavesL_062 : List RejectedLeaf := [leafL_062_0,leafL_062_1,leafL_062_2,leafL_062_3,leafL_062_4,leafL_062_5,leafL_062_6,leafL_062_7]

theorem leavesL_062_valid : LeafListValid leavesL_062 := by
  intro x hx
  simp only [leavesL_062, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_062_0_valid
  · exact leafL_062_1_valid
  · exact leafL_062_2_valid
  · exact leafL_062_3_valid
  · exact leafL_062_4_valid
  · exact leafL_062_5_valid
  · exact leafL_062_6_valid
  · exact leafL_062_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
