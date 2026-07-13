import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_201_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,131,174}, reject := .fullRank { members := ![0,1,17,34,52,71,131,174], points := ![92,101,109,120,121,154], inverse := ![0,1,13,5,11,3,5,8,8,9,1,13,7,0,1,4,6,4,5,2,5,14,10,6,7,13,12,15,13,4,2,5,9,12,7,5] } }
theorem leafL_201_0_valid : (leafL_201_0).reject.ValidFor (leafL_201_0).leaf := by decide

noncomputable def leafL_201_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,131,176}, reject := .fullRank { members := ![0,1,17,34,52,71,131,176], points := ![90,92,94,101,110,120], inverse := ![0,15,0,0,8,6,2,5,14,12,2,7,15,10,5,0,0,0,9,3,2,5,10,7,10,4,14,8,8,0,10,11,1,2,2,0] } }
theorem leafL_201_1_valid : (leafL_201_1).reject.ValidFor (leafL_201_1).leaf := by decide

noncomputable def leafL_201_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,131,188}, reject := .fullRank { members := ![0,1,17,34,52,71,131,188], points := ![90,94,96,110,128,150], inverse := ![6,6,6,11,0,12,9,9,13,5,2,10,5,15,10,0,0,0,8,6,10,1,8,13,9,5,7,15,13,9,4,13,15,7,14,15] } }
theorem leafL_201_2_valid : (leafL_201_2).reject.ValidFor (leafL_201_2).leaf := by decide

noncomputable def leafL_201_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,131,191}, reject := .fullRank { members := ![0,1,17,34,52,71,131,191], points := ![90,92,101,110,121,126], inverse := ![13,2,15,7,8,14,13,4,11,5,15,8,4,4,2,2,12,12,0,8,11,4,12,11,13,13,11,11,10,10,3,3,7,7,13,13] } }
theorem leafL_201_3_valid : (leafL_201_3).reject.ValidFor (leafL_201_3).leaf := by decide

noncomputable def leafL_201_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,131,205}, reject := .fullRank { members := ![0,1,17,34,52,71,131,205], points := ![90,94,96,101,120,126], inverse := ![4,2,9,8,13,11,1,5,13,14,1,6,5,15,10,0,0,0,7,2,13,15,10,13,5,7,2,0,11,11,7,4,3,0,6,6] } }
theorem leafL_201_4_valid : (leafL_201_4).reject.ValidFor (leafL_201_4).leaf := by decide

noncomputable def leafL_201_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,131,222}, reject := .fullRank { members := ![0,1,17,34,52,71,131,222], points := ![90,92,96,109,121,150], inverse := ![14,5,4,8,6,0,14,3,2,9,9,15,10,15,5,0,0,0,9,12,6,0,10,9,1,7,12,9,1,2,7,4,8,15,13,9] } }
theorem leafL_201_5_valid : (leafL_201_5).reject.ValidFor (leafL_201_5).leaf := by decide

noncomputable def leafL_201_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,131,237}, reject := .fullRank { members := ![0,1,17,34,52,71,131,237], points := ![90,92,94,110,121,128], inverse := ![4,6,13,8,13,11,2,13,6,14,2,5,15,10,5,0,0,0,8,10,10,15,6,1,9,7,14,0,12,12,14,15,1,0,3,3] } }
theorem leafL_201_6_valid : (leafL_201_6).reject.ValidFor (leafL_201_6).leaf := by decide

noncomputable def leafL_201_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,131,239}, reject := .fullRank { members := ![0,1,17,34,52,71,131,239], points := ![90,92,94,128,150,154], inverse := ![12,4,10,5,7,1,15,9,3,8,15,2,15,10,5,0,0,0,11,0,8,10,12,5,0,11,11,0,6,6,1,12,13,0,8,8] } }
theorem leafL_201_7_valid : (leafL_201_7).reject.ValidFor (leafL_201_7).leaf := by decide

noncomputable def leavesL_201 : List RejectedLeaf := [leafL_201_0,leafL_201_1,leafL_201_2,leafL_201_3,leafL_201_4,leafL_201_5,leafL_201_6,leafL_201_7]

theorem leavesL_201_valid : LeafListValid leavesL_201 := by
  intro x hx
  simp only [leavesL_201, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_201_0_valid
  · exact leafL_201_1_valid
  · exact leafL_201_2_valid
  · exact leafL_201_3_valid
  · exact leafL_201_4_valid
  · exact leafL_201_5_valid
  · exact leafL_201_6_valid
  · exact leafL_201_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
