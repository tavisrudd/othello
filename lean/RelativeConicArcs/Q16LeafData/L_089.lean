import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_089_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,223}, reject := .fullRank { members := ![0,1,17,34,52,69,126,223], points := ![86,90,93,103,104,135], inverse := ![1,11,3,5,11,6,15,7,6,9,0,7,7,2,5,0,0,0,9,4,2,14,6,7,1,13,12,4,4,0,15,3,12,1,1,0] } }
theorem leafL_089_0_valid : (leafL_089_0).reject.ValidFor (leafL_089_0).leaf := by decide

noncomputable def leafL_089_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,232}, reject := .fullRank { members := ![0,1,17,34,52,69,126,232], points := ![89,92,95,112,135,139], inverse := ![13,12,8,14,8,14,6,12,4,9,15,8,12,8,4,0,0,0,14,7,6,8,11,12,1,2,3,0,11,11,2,5,7,0,6,6] } }
theorem leafL_089_1_valid : (leafL_089_1).reject.ValidFor (leafL_089_1).leaf := by decide

noncomputable def leafL_089_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,236}, reject := .fullRank { members := ![0,1,17,34,52,69,126,236], points := ![86,89,90,103,112,131], inverse := ![3,1,11,4,10,6,2,3,15,13,4,7,14,4,10,0,0,0,2,10,7,0,8,7,12,10,6,8,8,0,9,7,14,2,2,0] } }
theorem leafL_089_2_valid : (leafL_089_2).reject.ValidFor (leafL_089_2).leaf := by decide

noncomputable def leafL_089_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,246}, reject := .fullRank { members := ![0,1,17,34,52,69,126,246], points := ![89,95,104,131,138,139], inverse := ![11,2,14,15,4,13,6,8,9,5,8,10,0,0,0,6,3,5,14,1,8,4,5,6,2,2,0,9,7,14,12,12,0,10,14,4] } }
theorem leafL_089_3_valid : (leafL_089_3).reject.ValidFor (leafL_089_3).leaf := by decide

noncomputable def leafL_089_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,247}, reject := .fullRank { members := ![0,1,17,34,52,69,126,247], points := ![86,93,96,104,106,139], inverse := ![6,2,13,2,12,6,7,0,9,11,2,7,11,15,4,0,0,0,2,8,5,3,11,7,5,14,11,12,12,0,6,9,15,3,3,0] } }
theorem leafL_089_4_valid : (leafL_089_4).reject.ValidFor (leafL_089_4).leaf := by decide

noncomputable def leafL_089_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,249}, reject := .fullRank { members := ![0,1,17,34,52,69,126,249], points := ![86,90,92,103,112,131], inverse := ![7,12,2,4,10,6,14,6,6,13,4,7,13,5,8,0,0,0,12,4,7,0,8,7,2,5,7,8,8,0,6,8,14,2,2,0] } }
theorem leafL_089_5_valid : (leafL_089_5).reject.ValidFor (leafL_089_5).leaf := by decide

noncomputable def leafL_089_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,256}, reject := .fullRank { members := ![0,1,17,34,52,69,126,256], points := ![90,92,93,103,104,138], inverse := ![3,4,14,9,7,6,3,14,3,7,14,7,12,3,15,0,0,0,12,7,4,0,8,7,15,10,5,4,4,0,14,12,2,1,1,0] } }
theorem leafL_089_6_valid : (leafL_089_6).reject.ValidFor (leafL_089_6).leaf := by decide

noncomputable def leafL_089_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,262}, reject := .fullRank { members := ![0,1,17,34,52,69,126,262], points := ![90,95,96,103,106,135], inverse := ![11,15,13,9,7,6,13,15,12,9,0,7,1,6,7,0,0,0,11,7,3,13,5,7,12,11,7,6,6,0,14,3,13,8,8,0] } }
theorem leafL_089_7_valid : (leafL_089_7).reject.ValidFor (leafL_089_7).leaf := by decide

noncomputable def leavesL_089 : List RejectedLeaf := [leafL_089_0,leafL_089_1,leafL_089_2,leafL_089_3,leafL_089_4,leafL_089_5,leafL_089_6,leafL_089_7]

theorem leavesL_089_valid : LeafListValid leavesL_089 := by
  intro x hx
  simp only [leavesL_089, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_089_0_valid
  · exact leafL_089_1_valid
  · exact leafL_089_2_valid
  · exact leafL_089_3_valid
  · exact leafL_089_4_valid
  · exact leafL_089_5_valid
  · exact leafL_089_6_valid
  · exact leafL_089_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
