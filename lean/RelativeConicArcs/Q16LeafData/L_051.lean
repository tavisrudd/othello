import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_051_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,103}, reject := .fullRank { members := ![0,1,17,34,52,69,96,103], points := ![126,131,137,139,156,159], inverse := ![4,0,14,0,0,11,3,9,13,12,8,3,0,8,6,14,0,0,2,12,1,4,13,6,0,13,7,10,6,6,0,2,12,14,7,7] } }
theorem leafL_051_0_valid : (leafL_051_0).reject.ValidFor (leafL_051_0).leaf := by decide

noncomputable def leafL_051_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,106}, reject := .fullRank { members := ![0,1,17,34,52,69,96,106], points := ![120,126,139,141,156,159], inverse := ![7,3,8,6,9,2,5,6,3,11,7,12,14,14,9,9,1,1,11,9,3,10,3,8,15,15,3,3,4,4,8,8,1,1,12,12] } }
theorem leafL_051_1_valid : (leafL_051_1).reject.ValidFor (leafL_051_1).leaf := by decide

noncomputable def leafL_051_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,107}, reject := .fullRank { members := ![0,1,17,34,52,69,96,107], points := ![120,122,127,131,137,156], inverse := ![8,1,13,4,10,11,6,14,11,13,5,11,6,10,12,0,0,0,13,2,13,7,14,11,4,13,9,14,14,0,8,13,5,12,12,0] } }
theorem leafL_051_2_valid : (leafL_051_2).reject.ValidFor (leafL_051_2).leaf := by decide

noncomputable def leafL_051_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,120}, reject := .fullRank { members := ![0,1,17,34,52,69,96,120], points := ![99,106,107,131,137,151], inverse := ![3,13,7,9,4,5,12,14,0,3,7,6,6,3,5,0,0,0,1,9,5,3,2,12,4,4,0,13,13,0,8,3,11,6,6,0] } }
theorem leafL_051_3_valid : (leafL_051_3).reject.ValidFor (leafL_051_3).leaf := by decide

noncomputable def leafL_051_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,127}, reject := .fullRank { members := ![0,1,17,34,52,69,96,127], points := ![107,137,151,156,163,166], inverse := ![12,14,1,12,0,14,4,6,12,11,2,7,15,5,1,10,10,11,2,4,3,4,11,10,13,10,0,5,2,0,12,4,14,12,14,4] } }
theorem leafL_051_4_valid : (leafL_051_4).reject.ValidFor (leafL_051_4).leaf := by decide

noncomputable def leafL_051_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,131}, reject := .fullRank { members := ![0,1,17,34,52,69,96,131], points := ![103,107,120,126,151,154], inverse := ![10,6,1,15,12,15,4,9,0,1,14,2,11,11,12,12,10,10,15,5,4,9,15,8,8,8,9,9,9,9,3,3,15,15,7,7] } }
theorem leafL_051_5_valid : (leafL_051_5).reject.ValidFor (leafL_051_5).leaf := by decide

noncomputable def leafL_051_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,137}, reject := .fullRank { members := ![0,1,17,34,52,69,96,137], points := ![103,107,120,122,127,154], inverse := ![9,5,1,8,7,3,14,3,3,4,6,12,0,0,6,10,12,0,8,2,10,1,6,7,7,7,12,13,1,0,6,6,5,13,8,0] } }
theorem leafL_051_6_valid : (leafL_051_6).reject.ValidFor (leafL_051_6).leaf := by decide

noncomputable def leafL_051_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,139}, reject := .fullRank { members := ![0,1,17,34,52,69,96,139], points := ![103,106,120,126,154,156], inverse := ![4,8,7,9,4,7,10,7,12,13,1,13,14,14,2,2,1,1,15,5,2,15,1,6,3,3,7,7,0,0,8,8,2,2,3,3] } }
theorem leafL_051_7_valid : (leafL_051_7).reject.ValidFor (leafL_051_7).leaf := by decide

noncomputable def leavesL_051 : List RejectedLeaf := [leafL_051_0,leafL_051_1,leafL_051_2,leafL_051_3,leafL_051_4,leafL_051_5,leafL_051_6,leafL_051_7]

theorem leavesL_051_valid : LeafListValid leavesL_051 := by
  intro x hx
  simp only [leavesL_051, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_051_0_valid
  · exact leafL_051_1_valid
  · exact leafL_051_2_valid
  · exact leafL_051_3_valid
  · exact leafL_051_4_valid
  · exact leafL_051_5_valid
  · exact leafL_051_6_valid
  · exact leafL_051_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
