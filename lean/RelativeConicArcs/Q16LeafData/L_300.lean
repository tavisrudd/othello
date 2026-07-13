import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_300_0 : RejectedLeaf := { leaf := {0,1,17,34,52,74,101,259}, reject := .fullRank { members := ![0,1,17,34,52,74,101,259], points := ![92,94,121,125,128,137], inverse := ![9,14,12,10,8,8,13,10,14,2,5,14,0,0,8,10,2,0,2,5,2,12,6,15,9,9,10,14,4,0,10,10,7,5,2,0] } }
theorem leafL_300_0_valid : (leafL_300_0).reject.ValidFor (leafL_300_0).leaf := by decide

noncomputable def leafL_300_1 : RejectedLeaf := { leaf := {0,1,17,34,52,74,104,121}, reject := .fullRank { members := ![0,1,17,34,52,74,104,121], points := ![86,159,166,167,190,195], inverse := ![0,8,8,14,12,3,6,4,2,4,4,0,5,5,1,10,12,7,8,10,15,14,15,12,10,2,6,11,3,6,10,9,5,3,8,13] } }
theorem leafL_300_1_valid : (leafL_300_1).reject.ValidFor (leafL_300_1).leaf := by decide

noncomputable def leafL_300_2 : RejectedLeaf := { leaf := {0,1,17,34,52,74,104,147}, reject := .fullRank { members := ![0,1,17,34,52,74,104,147], points := ![86,89,117,128,137,140], inverse := ![8,15,8,6,6,14,10,13,7,14,13,3,10,10,3,3,3,3,12,11,0,8,4,11,6,6,9,9,3,3,15,15,14,14,5,5] } }
theorem leafL_300_2_valid : (leafL_300_2).reject.ValidFor (leafL_300_2).leaf := by decide

noncomputable def leafL_300_3 : RejectedLeaf := { leaf := {0,1,17,34,52,74,104,155}, reject := .fullRank { members := ![0,1,17,34,52,74,104,155], points := ![89,94,95,115,137,140], inverse := ![4,15,12,14,10,2,13,6,12,9,12,2,4,8,12,0,0,0,10,13,0,8,14,1,12,15,3,0,10,10,0,11,11,0,11,11] } }
theorem leafL_300_3_valid : (leafL_300_3).reject.ValidFor (leafL_300_3).leaf := by decide

noncomputable def leafL_300_4 : RejectedLeaf := { leaf := {0,1,17,34,52,74,104,182}, reject := .fullRank { members := ![0,1,17,34,52,74,104,182], points := ![95,117,128,137,140,143], inverse := ![7,10,4,1,10,3,7,11,2,9,14,9,0,0,0,12,8,4,7,13,5,5,14,4,0,8,8,6,11,13,0,5,5,4,2,6] } }
theorem leafL_300_4_valid : (leafL_300_4).reject.ValidFor (leafL_300_4).leaf := by decide

noncomputable def leafL_300_5 : RejectedLeaf := { leaf := {0,1,17,34,52,74,104,195}, reject := .fullRank { members := ![0,1,17,34,52,74,104,195], points := ![86,94,117,121,128,137], inverse := ![2,5,0,4,10,8,1,6,8,8,9,14,0,0,4,9,13,0,8,15,10,15,13,15,2,2,7,7,0,0,14,14,13,4,9,0] } }
theorem leafL_300_5_valid : (leafL_300_5).reject.ValidFor (leafL_300_5).leaf := by decide

noncomputable def leafL_300_6 : RejectedLeaf := { leaf := {0,1,17,34,52,74,104,233}, reject := .fullRank { members := ![0,1,17,34,52,74,104,233], points := ![86,95,115,117,128,143], inverse := ![5,2,6,11,3,8,0,7,6,5,10,14,0,0,15,8,7,0,8,15,10,7,5,15,15,15,3,13,14,0,11,11,0,11,11,0] } }
theorem leafL_300_6_valid : (leafL_300_6).reject.ValidFor (leafL_300_6).leaf := by decide

noncomputable def leafL_300_7 : RejectedLeaf := { leaf := {0,1,17,34,52,74,107,117}, reject := .fullRank { members := ![0,1,17,34,52,74,107,117], points := ![83,86,92,137,166,167], inverse := ![14,13,8,2,15,7,0,12,1,1,13,1,12,10,6,0,0,0,9,10,9,13,6,1,1,14,15,0,1,1,12,6,10,0,13,13] } }
theorem leafL_300_7_valid : (leafL_300_7).reject.ValidFor (leafL_300_7).leaf := by decide

noncomputable def leavesL_300 : List RejectedLeaf := [leafL_300_0,leafL_300_1,leafL_300_2,leafL_300_3,leafL_300_4,leafL_300_5,leafL_300_6,leafL_300_7]

theorem leavesL_300_valid : LeafListValid leavesL_300 := by
  intro x hx
  simp only [leavesL_300, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_300_0_valid
  · exact leafL_300_1_valid
  · exact leafL_300_2_valid
  · exact leafL_300_3_valid
  · exact leafL_300_4_valid
  · exact leafL_300_5_valid
  · exact leafL_300_6_valid
  · exact leafL_300_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
