import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_140_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,96,152}, reject := .fullRank { members := ![0,1,17,34,52,70,96,152], points := ![107,122,126,131,137,139], inverse := ![7,15,6,12,8,11,7,3,13,13,1,5,0,0,0,8,6,14,7,13,2,13,4,1,0,5,5,11,9,2,0,13,13,5,14,11] } }
theorem leafL_140_0_valid : (leafL_140_0).reject.ValidFor (leafL_140_0).leaf := by decide

noncomputable def leafL_140_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,96,159}, reject := .fullRank { members := ![0,1,17,34,52,70,96,159], points := ![101,108,109,115,120,139], inverse := ![2,13,8,5,12,15,14,5,12,2,12,9,1,5,4,0,0,0,0,1,6,11,4,8,1,9,8,14,14,0,15,4,11,8,8,0] } }
theorem leafL_140_1_valid : (leafL_140_1).reject.ValidFor (leafL_140_1).leaf := by decide

noncomputable def leafL_140_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,96,172}, reject := .fullRank { members := ![0,1,17,34,52,70,96,172], points := ![107,117,120,131,141,147], inverse := ![0,7,3,9,7,11,13,14,15,10,10,12,14,6,15,9,11,5,0,9,11,15,6,11,8,3,15,6,3,1,10,6,9,12,5,12] } }
theorem leafL_140_2_valid : (leafL_140_2).reject.ValidFor (leafL_140_2).leaf := by decide

noncomputable def leafL_140_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,96,184}, reject := .fullRank { members := ![0,1,17,34,52,70,96,184], points := ![108,109,122,126,131,139], inverse := ![12,11,7,14,8,7,3,4,7,9,3,10,8,8,15,15,9,9,15,8,8,7,11,3,15,15,9,9,1,1,10,10,5,5,9,9] } }
theorem leafL_140_3_valid : (leafL_140_3).reject.ValidFor (leafL_140_3).leaf := by decide

noncomputable def leafL_140_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,96,188}, reject := .fullRank { members := ![0,1,17,34,52,70,96,188], points := ![107,115,122,126,131,152], inverse := ![4,11,0,9,5,2,15,5,7,0,12,1,0,14,12,2,0,0,11,1,0,4,6,8,12,2,1,9,14,8,2,11,10,2,12,13] } }
theorem leafL_140_4_valid : (leafL_140_4).reject.ValidFor (leafL_140_4).leaf := by decide

noncomputable def leafL_140_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,96,191}, reject := .fullRank { members := ![0,1,17,34,52,70,96,191], points := ![101,108,115,117,126,137], inverse := ![15,8,15,7,1,15,4,3,13,8,11,9,0,0,13,14,3,0,0,7,6,5,12,8,3,3,12,5,9,0,9,9,9,0,9,0] } }
theorem leafL_140_5_valid : (leafL_140_5).reject.ValidFor (leafL_140_5).leaf := by decide

noncomputable def leafL_140_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,96,202}, reject := .fullRank { members := ![0,1,17,34,52,70,96,202], points := ![101,108,109,117,120,131], inverse := ![8,11,4,10,3,15,12,7,12,1,15,9,1,5,4,0,0,0,8,4,11,7,8,8,11,13,6,1,1,0,13,14,3,11,11,0] } }
theorem leafL_140_6_valid : (leafL_140_6).reject.ValidFor (leafL_140_6).leaf := by decide

noncomputable def leafL_140_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,96,205}, reject := .fullRank { members := ![0,1,17,34,52,70,96,205], points := ![107,117,120,122,131,151], inverse := ![8,6,2,12,11,10,9,7,6,6,11,5,0,13,1,12,0,0,14,4,7,8,11,14,9,11,12,3,3,14,10,7,7,15,9,12] } }
theorem leafL_140_7_valid : (leafL_140_7).reject.ValidFor (leafL_140_7).leaf := by decide

noncomputable def leavesL_140 : List RejectedLeaf := [leafL_140_0,leafL_140_1,leafL_140_2,leafL_140_3,leafL_140_4,leafL_140_5,leafL_140_6,leafL_140_7]

theorem leavesL_140_valid : LeafListValid leavesL_140 := by
  intro x hx
  simp only [leavesL_140, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_140_0_valid
  · exact leafL_140_1_valid
  · exact leafL_140_2_valid
  · exact leafL_140_3_valid
  · exact leafL_140_4_valid
  · exact leafL_140_5_valid
  · exact leafL_140_6_valid
  · exact leafL_140_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
