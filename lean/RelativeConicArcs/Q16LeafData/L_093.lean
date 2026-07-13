import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_093_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,127,259}, reject := .fullRank { members := ![0,1,17,34,52,69,127,259], points := ![90,94,96,107,110,137], inverse := ![0,2,11,13,3,6,9,14,9,15,6,7,5,15,10,0,0,0,0,8,7,7,15,7,2,13,15,11,11,0,2,15,13,6,6,0] } }
theorem leafL_093_0_valid : (leafL_093_0).reject.ValidFor (leafL_093_0).leaf := by decide

noncomputable def leafL_093_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,127,262}, reject := .fullRank { members := ![0,1,17,34,52,69,127,262], points := ![90,92,96,103,107,135], inverse := ![4,6,11,12,2,6,4,3,9,9,0,7,10,15,5,0,0,0,12,8,11,1,9,7,7,1,6,14,14,0,15,12,3,10,10,0] } }
theorem leafL_093_1_valid : (leafL_093_1).reject.ValidFor (leafL_093_1).leaf := by decide

noncomputable def leafL_093_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,127,268}, reject := .fullRank { members := ![0,1,17,34,52,69,127,268], points := ![89,93,103,104,110,137], inverse := ![3,10,4,8,2,6,14,0,15,10,12,7,0,0,5,12,9,0,13,2,9,1,0,7,12,12,11,3,8,0,13,13,3,8,11,0] } }
theorem leafL_093_2_valid : (leafL_093_2).reject.ValidFor (leafL_093_2).leaf := by decide

noncomputable def leafL_093_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,128,131}, reject := .fullRank { members := ![0,1,17,34,52,69,128,131], points := ![89,94,103,110,151,154], inverse := ![6,0,7,12,8,4,9,3,5,1,13,3,10,10,8,8,11,11,7,12,6,3,15,1,14,14,11,11,7,7,13,13,12,12,8,8] } }
theorem leafL_093_3_valid : (leafL_093_3).reject.ValidFor (leafL_093_3).leaf := by decide

noncomputable def leafL_093_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,128,150}, reject := .fullRank { members := ![0,1,17,34,52,69,128,150], points := ![89,94,99,103,137,138], inverse := ![9,0,1,15,1,7,10,4,11,2,13,10,13,13,11,11,6,6,6,9,11,3,15,8,12,12,10,10,6,6,6,6,6,6,6,6] } }
theorem leafL_093_4_valid : (leafL_093_4).reject.ValidFor (leafL_093_4).leaf := by decide

noncomputable def leafL_093_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,128,151}, reject := .fullRank { members := ![0,1,17,34,52,69,128,151], points := ![86,89,94,99,131,138], inverse := ![14,13,10,14,13,11,2,15,3,9,7,0,9,10,3,0,0,0,15,10,10,8,1,6,14,1,15,0,12,12,12,10,6,0,3,3] } }
theorem leafL_093_5_valid : (leafL_093_5).reject.ValidFor (leafL_093_5).leaf := by decide

noncomputable def leafL_093_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,128,166}, reject := .fullRank { members := ![0,1,17,34,52,69,128,166], points := ![89,93,94,99,137,138], inverse := ![6,8,7,14,6,0,8,11,13,9,4,3,6,13,11,0,0,0,5,7,13,8,11,12,6,1,7,0,13,13,0,14,14,0,14,14] } }
theorem leafL_093_6_valid : (leafL_093_6).reject.ValidFor (leafL_093_6).leaf := by decide

noncomputable def leafL_093_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,128,171}, reject := .fullRank { members := ![0,1,17,34,52,69,128,171], points := ![86,89,94,99,103,137], inverse := ![3,8,2,14,0,6,8,3,5,5,12,7,9,10,3,0,0,0,15,3,3,13,5,7,9,11,2,1,1,0,9,1,8,13,13,0] } }
theorem leafL_093_7_valid : (leafL_093_7).reject.ValidFor (leafL_093_7).leaf := by decide

noncomputable def leavesL_093 : List RejectedLeaf := [leafL_093_0,leafL_093_1,leafL_093_2,leafL_093_3,leafL_093_4,leafL_093_5,leafL_093_6,leafL_093_7]

theorem leavesL_093_valid : LeafListValid leavesL_093 := by
  intro x hx
  simp only [leavesL_093, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_093_0_valid
  · exact leafL_093_1_valid
  · exact leafL_093_2_valid
  · exact leafL_093_3_valid
  · exact leafL_093_4_valid
  · exact leafL_093_5_valid
  · exact leafL_093_6_valid
  · exact leafL_093_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
