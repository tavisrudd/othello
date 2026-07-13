import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_016_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,135}, reject := .fullRank { members := ![0,1,17,34,52,69,89,135], points := ![99,106,110,115,122,155], inverse := ![5,4,13,9,7,3,13,9,9,15,14,12,14,12,2,0,0,0,12,14,8,10,7,7,2,7,5,15,15,0,3,3,0,3,3,0] } }
theorem leafL_016_0_valid : (leafL_016_0).reject.ValidFor (leafL_016_0).leaf := by decide

noncomputable def leafL_016_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,139}, reject := .fullRank { members := ![0,1,17,34,52,69,89,139], points := ![106,112,115,122,124,150], inverse := ![4,8,3,6,11,3,4,9,5,11,15,12,0,0,10,11,1,0,4,14,3,9,7,7,14,14,8,10,2,0,12,12,11,1,10,0] } }
theorem leafL_016_1_valid : (leafL_016_1).reject.ValidFor (leafL_016_1).leaf := by decide

noncomputable def leafL_016_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,141}, reject := .fullRank { members := ![0,1,17,34,52,69,89,141], points := ![99,104,106,124,126,150], inverse := ![10,9,15,1,15,3,15,0,2,13,12,12,1,14,15,0,0,0,6,4,8,7,10,7,5,5,0,9,9,0,9,6,15,12,12,0] } }
theorem leafL_016_2_valid : (leafL_016_2).reject.ValidFor (leafL_016_2).leaf := by decide

noncomputable def leafL_016_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,150}, reject := .fullRank { members := ![0,1,17,34,52,69,89,150], points := ![99,115,122,124,131,139], inverse := ![7,3,12,6,7,8,7,14,0,0,9,0,0,10,11,1,0,0,7,12,5,6,5,13,0,2,3,1,4,4,0,8,11,3,15,15] } }
theorem leafL_016_3_valid : (leafL_016_3).reject.ValidFor (leafL_016_3).leaf := by decide

noncomputable def leafL_016_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,151}, reject := .fullRank { members := ![0,1,17,34,52,69,89,151], points := ![99,112,115,122,127,141], inverse := ![8,15,1,9,1,15,2,5,4,9,3,9,0,0,4,13,9,0,1,6,7,15,7,8,8,8,0,10,10,0,13,13,11,10,1,0] } }
theorem leafL_016_4_valid : (leafL_016_4).reject.ValidFor (leafL_016_4).leaf := by decide

noncomputable def leafL_016_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,154}, reject := .fullRank { members := ![0,1,17,34,52,69,89,154], points := ![104,112,124,127,131,139], inverse := ![5,2,6,15,2,13,6,1,10,4,9,0,13,13,10,10,4,4,1,6,14,1,12,4,14,14,15,15,5,5,14,14,0,0,14,14] } }
theorem leafL_016_5_valid : (leafL_016_5).reject.ValidFor (leafL_016_5).leaf := by decide

noncomputable def leafL_016_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,155}, reject := .fullRank { members := ![0,1,17,34,52,69,89,155], points := ![104,110,115,126,128,135], inverse := ![10,13,10,6,5,15,5,2,0,10,4,9,0,0,6,4,2,0,14,9,4,15,4,8,11,11,6,12,10,0,4,4,3,5,6,0] } }
theorem leafL_016_6_valid : (leafL_016_6).reject.ValidFor (leafL_016_6).leaf := by decide

noncomputable def leafL_016_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,156}, reject := .fullRank { members := ![0,1,17,34,52,69,89,156], points := ![99,104,106,115,127,131], inverse := ![0,0,7,0,9,15,7,0,0,14,0,9,1,14,15,0,0,0,10,8,5,3,12,8,8,15,7,13,13,0,15,4,11,6,6,0] } }
theorem leafL_016_7_valid : (leafL_016_7).reject.ValidFor (leafL_016_7).leaf := by decide

noncomputable def leavesL_016 : List RejectedLeaf := [leafL_016_0,leafL_016_1,leafL_016_2,leafL_016_3,leafL_016_4,leafL_016_5,leafL_016_6,leafL_016_7]

theorem leavesL_016_valid : LeafListValid leavesL_016 := by
  intro x hx
  simp only [leavesL_016, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_016_0_valid
  · exact leafL_016_1_valid
  · exact leafL_016_2_valid
  · exact leafL_016_3_valid
  · exact leafL_016_4_valid
  · exact leafL_016_5_valid
  · exact leafL_016_6_valid
  · exact leafL_016_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
