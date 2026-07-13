import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_052_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,141}, reject := .fullRank { members := ![0,1,17,34,52,69,96,141], points := ![99,106,120,151,156,172], inverse := ![0,15,15,13,6,10,5,0,8,4,12,5,5,11,11,12,11,2,10,8,4,12,15,5,9,15,2,14,13,7,6,14,9,14,10,5] } }
theorem leafL_052_0_valid : (leafL_052_0).reject.ValidFor (leafL_052_0).leaf := by decide

noncomputable def leafL_052_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,151}, reject := .fullRank { members := ![0,1,17,34,52,69,96,151], points := ![99,120,122,127,131,141], inverse := ![7,10,8,11,8,7,7,9,3,4,9,0,0,6,10,12,0,0,7,7,0,8,14,6,0,11,15,4,10,10,0,3,3,0,3,3] } }
theorem leafL_052_1_valid : (leafL_052_1).reject.ValidFor (leafL_052_1).leaf := by decide

noncomputable def leafL_052_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,154}, reject := .fullRank { members := ![0,1,17,34,52,69,96,154], points := ![99,131,137,139,163,172], inverse := ![4,0,7,0,0,2,5,8,0,0,13,0,0,8,6,14,0,0,3,11,7,6,5,12,0,9,6,15,1,1,0,9,10,3,6,6] } }
theorem leafL_052_2_valid : (leafL_052_2).reject.ValidFor (leafL_052_2).leaf := by decide

noncomputable def leafL_052_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,156}, reject := .fullRank { members := ![0,1,17,34,52,69,96,156], points := ![99,103,106,127,131,137], inverse := ![0,0,7,9,15,0,11,1,13,14,7,14,12,2,14,0,0,0,5,0,2,15,11,3,4,0,4,0,13,13,13,1,12,0,6,6] } }
theorem leafL_052_3_valid : (leafL_052_3).reject.ValidFor (leafL_052_3).leaf := by decide

noncomputable def leafL_052_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,159}, reject := .fullRank { members := ![0,1,17,34,52,69,96,159], points := ![103,106,120,122,139,163], inverse := ![0,11,10,1,9,8,1,7,7,14,0,15,2,7,7,15,11,6,0,12,6,13,4,3,8,1,7,13,13,14,6,5,13,4,8,2] } }
theorem leafL_052_4_valid : (leafL_052_4).reject.ValidFor (leafL_052_4).leaf := by decide

noncomputable def leafL_052_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,163}, reject := .fullRank { members := ![0,1,17,34,52,69,96,163], points := ![107,122,127,137,139,154], inverse := ![15,7,2,4,14,1,6,7,1,14,1,15,13,7,5,10,2,7,4,8,12,4,6,2,11,2,5,11,4,3,12,14,4,13,3,8] } }
theorem leafL_052_5_valid : (leafL_052_5).reject.ValidFor (leafL_052_5).leaf := by decide

noncomputable def leafL_052_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,166}, reject := .fullRank { members := ![0,1,17,34,52,69,96,166], points := ![99,106,120,127,137,139], inverse := ![14,9,6,15,5,10,5,2,15,1,12,5,4,4,14,14,15,15,9,14,1,14,11,3,11,11,12,12,7,7,10,10,10,10,10,10] } }
theorem leafL_052_6_valid : (leafL_052_6).reject.ValidFor (leafL_052_6).leaf := by decide

noncomputable def leafL_052_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,172}, reject := .fullRank { members := ![0,1,17,34,52,69,96,172], points := ![103,106,107,120,141,151], inverse := ![8,6,13,15,4,9,15,5,0,12,1,7,15,9,6,0,0,0,14,11,4,10,15,4,0,11,2,4,3,14,5,6,15,10,14,8] } }
theorem leafL_052_7_valid : (leafL_052_7).reject.ValidFor (leafL_052_7).leaf := by decide

noncomputable def leavesL_052 : List RejectedLeaf := [leafL_052_0,leafL_052_1,leafL_052_2,leafL_052_3,leafL_052_4,leafL_052_5,leafL_052_6,leafL_052_7]

theorem leavesL_052_valid : LeafListValid leavesL_052 := by
  intro x hx
  simp only [leavesL_052, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_052_0_valid
  · exact leafL_052_1_valid
  · exact leafL_052_2_valid
  · exact leafL_052_3_valid
  · exact leafL_052_4_valid
  · exact leafL_052_5_valid
  · exact leafL_052_6_valid
  · exact leafL_052_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
