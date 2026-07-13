import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_101_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,139,152}, reject := .fullRank { members := ![0,1,17,34,52,69,139,152], points := ![86,90,92,103,106,122], inverse := ![12,1,2,3,11,6,0,9,0,0,14,7,13,5,8,0,0,0,7,3,12,4,11,7,4,4,0,6,6,0,14,5,11,8,8,0] } }
theorem leafL_101_0_valid : (leafL_101_0).reject.ValidFor (leafL_101_0).leaf := by decide

noncomputable def leafL_101_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,139,154}, reject := .fullRank { members := ![0,1,17,34,52,69,139,154], points := ![89,92,93,103,104,124], inverse := ![12,4,7,0,8,6,10,11,8,4,10,7,10,2,8,0,0,0,11,14,13,3,12,7,1,6,7,4,4,0,9,10,3,1,1,0] } }
theorem leafL_101_1_valid : (leafL_101_1).reject.ValidFor (leafL_101_1).leaf := by decide

noncomputable def leafL_101_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,139,159}, reject := .fullRank { members := ![0,1,17,34,52,69,139,159], points := ![86,89,93,104,106,115], inverse := ![1,8,6,2,10,6,2,8,3,11,5,7,8,1,9,0,0,0,2,11,1,3,12,7,15,6,9,12,12,0,15,7,8,3,3,0] } }
theorem leafL_101_2_valid : (leafL_101_2).reject.ValidFor (leafL_101_2).leaf := by decide

noncomputable def leafL_101_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,139,166}, reject := .fullRank { members := ![0,1,17,34,52,69,139,166], points := ![89,90,96,104,106,120], inverse := ![5,7,13,10,2,6,8,10,11,14,0,7,6,7,1,0,0,0,3,14,5,6,9,7,0,8,8,12,12,0,5,10,15,3,3,0] } }
theorem leafL_101_3_valid : (leafL_101_3).reject.ValidFor (leafL_101_3).leaf := by decide

noncomputable def leafL_101_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,139,169}, reject := .fullRank { members := ![0,1,17,34,52,69,139,169], points := ![90,92,95,104,106,122], inverse := ![10,14,11,6,14,6,9,0,0,0,14,7,3,12,15,0,0,0,15,3,4,8,7,7,2,9,11,12,12,0,14,6,8,3,3,0] } }
theorem leafL_101_4_valid : (leafL_101_4).reject.ValidFor (leafL_101_4).leaf := by decide

noncomputable def leafL_101_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,139,172}, reject := .fullRank { members := ![0,1,17,34,52,69,139,172], points := ![86,93,95,103,104,115], inverse := ![12,14,13,6,14,6,6,13,2,3,13,7,10,1,11,0,0,0,2,15,5,4,11,7,6,5,3,4,4,0,13,10,7,1,1,0] } }
theorem leafL_101_5_valid : (leafL_101_5).reject.ValidFor (leafL_101_5).leaf := by decide

noncomputable def leafL_101_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,139,183}, reject := .fullRank { members := ![0,1,17,34,52,69,139,183], points := ![89,90,93,106,120,122], inverse := ![14,14,15,8,3,5,0,9,0,14,0,7,13,11,6,0,0,0,8,1,1,15,4,3,0,14,14,0,6,6,3,1,2,0,8,8] } }
theorem leafL_101_6_valid : (leafL_101_6).reject.ValidFor (leafL_101_6).leaf := by decide

noncomputable def leafL_101_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,139,195}, reject := .fullRank { members := ![0,1,17,34,52,69,139,195], points := ![86,93,103,106,126,128], inverse := ![12,3,8,0,14,8,15,6,5,11,1,6,7,7,10,10,3,3,7,15,9,6,12,11,4,4,1,1,6,6,3,3,1,1,10,10] } }
theorem leafL_101_7_valid : (leafL_101_7).reject.ValidFor (leafL_101_7).leaf := by decide

noncomputable def leavesL_101 : List RejectedLeaf := [leafL_101_0,leafL_101_1,leafL_101_2,leafL_101_3,leafL_101_4,leafL_101_5,leafL_101_6,leafL_101_7]

theorem leavesL_101_valid : LeafListValid leavesL_101 := by
  intro x hx
  simp only [leavesL_101, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_101_0_valid
  · exact leafL_101_1_valid
  · exact leafL_101_2_valid
  · exact leafL_101_3_valid
  · exact leafL_101_4_valid
  · exact leafL_101_5_valid
  · exact leafL_101_6_valid
  · exact leafL_101_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
