import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_014_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,207}, reject := .fullRank { members := ![0,1,17,34,52,69,86,207], points := ![103,110,128,139,163,171], inverse := ![14,6,2,1,6,12,10,1,12,15,10,2,5,1,15,2,1,8,9,11,7,3,12,10,10,5,11,14,14,4,8,9,7,9,1,14] } }
theorem leafL_014_0_valid : (leafL_014_0).reject.ValidFor (leafL_014_0).leaf := by decide

noncomputable def leafL_014_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,217}, reject := .fullRank { members := ![0,1,17,34,52,69,86,217], points := ![104,107,126,138,159,183], inverse := ![13,9,7,4,0,6,15,5,6,3,3,12,4,6,15,1,4,8,5,15,12,11,2,15,4,9,1,6,8,2,11,1,15,9,12,0] } }
theorem leafL_014_1_valid : (leafL_014_1).reject.ValidFor (leafL_014_1).leaf := by decide

noncomputable def leafL_014_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,240}, reject := .fullRank { members := ![0,1,17,34,52,69,86,240], points := ![104,110,151,159,171,172], inverse := ![12,1,5,15,8,14,8,6,9,13,14,4,5,5,6,6,1,1,8,6,12,9,5,14,9,9,0,0,4,4,11,11,12,12,8,8] } }
theorem leafL_014_2_valid : (leafL_014_2).reject.ValidFor (leafL_014_2).leaf := by decide

noncomputable def leafL_014_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,86,247}, reject := .fullRank { members := ![0,1,17,34,52,69,86,247], points := ![104,107,110,126,128,139], inverse := ![15,8,0,3,10,15,11,11,7,8,6,9,5,11,14,0,0,0,9,13,3,0,15,8,14,11,5,8,8,0,15,12,3,7,7,0] } }
theorem leafL_014_3_valid : (leafL_014_3).reject.ValidFor (leafL_014_3).leaf := by decide

noncomputable def leafL_014_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,99}, reject := .fullRank { members := ![0,1,17,34,52,69,89,99], points := ![122,124,135,141,150,151], inverse := ![11,15,1,15,11,0,9,10,5,13,11,0,5,5,9,9,5,5,15,13,11,2,1,10,2,2,4,4,8,8,7,7,8,8,14,14] } }
theorem leafL_014_4_valid : (leafL_014_4).reject.ValidFor (leafL_014_4).leaf := by decide

noncomputable def leafL_014_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,104}, reject := .fullRank { members := ![0,1,17,34,52,69,89,104], points := ![115,126,127,141,154,155], inverse := ![4,0,0,14,11,0,0,2,1,8,5,14,15,9,6,0,0,0,13,0,15,9,9,2,2,0,2,0,6,6,0,1,1,0,1,1] } }
theorem leafL_014_5_valid : (leafL_014_5).reject.ValidFor (leafL_014_5).leaf := by decide

noncomputable def leafL_014_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,106}, reject := .fullRank { members := ![0,1,17,34,52,69,89,106], points := ![115,124,126,135,139,156], inverse := ![0,11,15,10,4,11,6,12,9,15,7,11,3,14,13,0,0,0,4,12,10,7,14,11,2,3,1,9,9,0,13,1,12,10,10,0] } }
theorem leafL_014_6_valid : (leafL_014_6).reject.ValidFor (leafL_014_6).leaf := by decide

noncomputable def leafL_014_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,110}, reject := .fullRank { members := ![0,1,17,34,52,69,89,110], points := ![122,127,128,131,135,155], inverse := ![0,4,0,14,0,11,6,8,13,11,3,11,1,6,7,0,0,0,15,4,9,3,10,11,12,9,5,8,8,0,5,12,9,13,13,0] } }
theorem leafL_014_7_valid : (leafL_014_7).reject.ValidFor (leafL_014_7).leaf := by decide

noncomputable def leavesL_014 : List RejectedLeaf := [leafL_014_0,leafL_014_1,leafL_014_2,leafL_014_3,leafL_014_4,leafL_014_5,leafL_014_6,leafL_014_7]

theorem leavesL_014_valid : LeafListValid leavesL_014 := by
  intro x hx
  simp only [leavesL_014, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_014_0_valid
  · exact leafL_014_1_valid
  · exact leafL_014_2_valid
  · exact leafL_014_3_valid
  · exact leafL_014_4_valid
  · exact leafL_014_5_valid
  · exact leafL_014_6_valid
  · exact leafL_014_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
