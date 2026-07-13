import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_134_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,185}, reject := .fullRank { members := ![0,1,17,34,52,70,94,185], points := ![104,109,124,125,133,135], inverse := ![12,11,15,6,3,12,1,6,13,3,12,5,3,3,4,4,9,9,11,12,8,7,12,4,13,13,15,15,6,6,15,15,1,1,2,2] } }
theorem leafL_134_0_valid : (leafL_134_0).reject.ValidFor (leafL_134_0).leaf := by decide

noncomputable def leafL_134_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,188}, reject := .fullRank { members := ![0,1,17,34,52,70,94,188], points := ![103,107,122,125,133,137], inverse := ![6,1,3,10,4,11,15,8,11,5,8,1,10,10,5,5,13,13,15,8,6,9,7,15,9,9,9,9,1,1,5,5,0,0,5,5] } }
theorem leafL_134_1_valid : (leafL_134_1).reject.ValidFor (leafL_134_1).leaf := by decide

noncomputable def leafL_134_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,195}, reject := .fullRank { members := ![0,1,17,34,52,70,94,195], points := ![103,104,108,125,127,133], inverse := ![8,10,5,13,4,15,10,0,13,3,13,9,4,10,14,0,0,0,13,15,5,9,6,8,1,12,13,8,8,0,10,4,14,7,7,0] } }
theorem leafL_134_2_valid : (leafL_134_2).reject.ValidFor (leafL_134_2).leaf := by decide

noncomputable def leafL_134_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,205}, reject := .fullRank { members := ![0,1,17,34,52,70,94,205], points := ![101,107,122,124,133,151], inverse := ![11,4,15,10,10,1,13,14,12,4,2,9,8,6,3,10,2,5,15,1,1,10,11,14,2,5,0,13,1,11,7,10,11,9,8,7] } }
theorem leafL_134_3_valid : (leafL_134_3).reject.ValidFor (leafL_134_3).leaf := by decide

noncomputable def leafL_134_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,211}, reject := .fullRank { members := ![0,1,17,34,52,70,94,211], points := ![103,108,109,124,125,137], inverse := ![2,15,10,3,10,15,13,11,1,8,6,9,5,11,14,0,0,0,4,5,6,0,15,8,8,8,0,10,10,0,0,2,2,2,2,0] } }
theorem leafL_134_4_valid : (leafL_134_4).reject.ValidFor (leafL_134_4).leaf := by decide

noncomputable def leafL_134_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,218}, reject := .fullRank { members := ![0,1,17,34,52,70,94,218], points := ![104,108,124,127,133,151], inverse := ![12,0,14,0,0,3,14,4,4,8,1,7,15,12,13,6,10,2,7,8,4,7,13,1,14,2,15,5,14,8,13,4,13,9,3,14] } }
theorem leafL_134_5_valid : (leafL_134_5).reject.ValidFor (leafL_134_5).leaf := by decide

noncomputable def leafL_134_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,220}, reject := .fullRank { members := ![0,1,17,34,52,70,94,220], points := ![101,133,135,137,152,167], inverse := ![7,6,4,4,9,9,8,5,0,7,5,15,0,5,8,13,0,0,12,3,6,10,11,8,13,3,7,14,5,2,8,0,8,1,13,12] } }
theorem leafL_134_6_valid : (leafL_134_6).reject.ValidFor (leafL_134_6).leaf := by decide

noncomputable def leafL_134_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,223}, reject := .fullRank { members := ![0,1,17,34,52,70,94,223], points := ![103,104,107,125,135,137], inverse := ![9,11,5,9,12,3,1,1,7,14,6,15,10,4,14,0,0,0,15,9,1,15,0,8,13,2,15,0,14,14,15,4,11,0,8,8] } }
theorem leafL_134_7_valid : (leafL_134_7).reject.ValidFor (leafL_134_7).leaf := by decide

noncomputable def leavesL_134 : List RejectedLeaf := [leafL_134_0,leafL_134_1,leafL_134_2,leafL_134_3,leafL_134_4,leafL_134_5,leafL_134_6,leafL_134_7]

theorem leavesL_134_valid : LeafListValid leavesL_134 := by
  intro x hx
  simp only [leavesL_134, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_134_0_valid
  · exact leafL_134_1_valid
  · exact leafL_134_2_valid
  · exact leafL_134_3_valid
  · exact leafL_134_4_valid
  · exact leafL_134_5_valid
  · exact leafL_134_6_valid
  · exact leafL_134_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
