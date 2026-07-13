import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_074_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,218}, reject := .fullRank { members := ![0,1,17,34,52,69,110,218], points := ![89,128,131,152,155,156], inverse := ![14,3,2,14,3,3,14,4,4,11,13,8,0,0,0,14,4,10,12,4,11,8,2,9,2,1,14,12,11,10,13,15,5,13,5,15] } }
theorem leafL_074_0_valid : (leafL_074_0).reject.ValidFor (leafL_074_0).leaf := by decide

noncomputable def leafL_074_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,220}, reject := .fullRank { members := ![0,1,17,34,52,69,110,220], points := ![86,90,91,115,127,137], inverse := ![8,13,2,10,4,8,2,1,4,13,4,14,15,6,9,0,0,0,2,12,9,10,2,15,5,3,6,7,7,0,5,5,0,5,5,0] } }
theorem leafL_074_1_valid : (leafL_074_1).reject.ValidFor (leafL_074_1).leaf := by decide

noncomputable def leafL_074_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,232}, reject := .fullRank { members := ![0,1,17,34,52,69,110,232], points := ![86,89,115,122,127,137], inverse := ![10,13,4,11,1,8,0,7,12,14,11,14,0,0,4,13,9,0,3,4,10,0,2,15,12,12,14,7,9,0,2,2,7,15,8,0] } }
theorem leafL_074_2_valid : (leafL_074_2).reject.ValidFor (leafL_074_2).leaf := by decide

noncomputable def leafL_074_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,236}, reject := .fullRank { members := ![0,1,17,34,52,69,110,236], points := ![86,89,93,115,128,131], inverse := ![1,4,2,13,3,8,8,2,13,9,0,14,8,1,9,0,0,0,12,6,13,12,4,15,14,1,15,8,8,0,2,2,0,2,2,0] } }
theorem leafL_074_3_valid : (leafL_074_3).reject.ValidFor (leafL_074_3).leaf := by decide

noncomputable def leafL_074_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,240}, reject := .fullRank { members := ![0,1,17,34,52,69,110,240], points := ![86,90,115,127,131,137], inverse := ![7,0,0,14,8,0,15,8,10,3,3,13,8,8,11,11,2,2,5,2,1,9,2,13,7,7,10,10,11,11,5,5,5,5,0,0] } }
theorem leafL_074_4_valid : (leafL_074_4).reject.ValidFor (leafL_074_4).leaf := by decide

noncomputable def leafL_074_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,246}, reject := .fullRank { members := ![0,1,17,34,52,69,110,246], points := ![89,91,115,122,127,141], inverse := ![3,4,15,14,15,8,9,14,4,11,6,14,0,0,4,13,9,0,10,13,11,5,6,15,8,8,6,14,8,0,13,13,10,5,15,0] } }
theorem leafL_074_5_valid : (leafL_074_5).reject.ValidFor (leafL_074_5).leaf := by decide

noncomputable def leafL_074_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,247}, reject := .fullRank { members := ![0,1,17,34,52,69,110,247], points := ![86,91,115,128,137,141], inverse := ![14,9,9,7,8,0,8,15,6,15,0,14,9,9,4,4,7,7,2,5,0,8,5,10,7,7,2,2,4,4,13,13,6,6,7,7] } }
theorem leafL_074_6_valid : (leafL_074_6).reject.ValidFor (leafL_074_6).leaf := by decide

noncomputable def leafL_074_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,248}, reject := .fullRank { members := ![0,1,17,34,52,69,110,248], points := ![86,89,91,115,128,131], inverse := ![12,8,3,13,3,8,15,10,2,9,0,14,6,2,4,0,0,0,11,14,2,12,4,15,4,5,1,8,8,0,2,2,0,2,2,0] } }
theorem leafL_074_7_valid : (leafL_074_7).reject.ValidFor (leafL_074_7).leaf := by decide

noncomputable def leavesL_074 : List RejectedLeaf := [leafL_074_0,leafL_074_1,leafL_074_2,leafL_074_3,leafL_074_4,leafL_074_5,leafL_074_6,leafL_074_7]

theorem leavesL_074_valid : LeafListValid leavesL_074 := by
  intro x hx
  simp only [leavesL_074, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_074_0_valid
  · exact leafL_074_1_valid
  · exact leafL_074_2_valid
  · exact leafL_074_3_valid
  · exact leafL_074_4_valid
  · exact leafL_074_5_valid
  · exact leafL_074_6_valid
  · exact leafL_074_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
