import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_309_0 : RejectedLeaf := { leaf := {0,1,17,34,52,74,195,222}, reject := .fullRank { members := ![0,1,17,34,52,74,195,222], points := ![93,104,107,108,121,125], inverse := ![15,1,10,3,5,3,9,11,1,4,0,7,0,14,4,10,0,0,8,9,9,15,1,6,0,11,15,4,4,4,0,1,2,3,10,10] } }
theorem leafL_309_0_valid : (leafL_309_0).reject.ValidFor (leafL_309_0).leaf := by decide

noncomputable def leafL_309_1 : RejectedLeaf := { leaf := {0,1,17,34,52,74,203,216}, reject := .fullRank { members := ![0,1,17,34,52,74,203,216], points := ![83,89,95,103,109,125], inverse := ![9,14,8,9,1,6,4,15,2,0,14,7,1,2,3,0,0,0,3,13,6,15,0,7,3,14,13,5,5,0,12,12,0,12,12,0] } }
theorem leafL_309_1_valid : (leafL_309_1).reject.ValidFor (leafL_309_1).leaf := by decide

noncomputable def leafL_309_2 : RejectedLeaf := { leaf := {0,1,17,34,52,74,203,233}, reject := .fullRank { members := ![0,1,17,34,52,74,203,233], points := ![93,95,108,109,112,115], inverse := ![1,14,9,9,8,6,3,10,6,14,6,7,0,0,8,2,10,0,4,12,12,0,3,7,11,11,5,1,4,0,9,9,8,12,4,0] } }
theorem leafL_309_2_valid : (leafL_309_2).reject.ValidFor (leafL_309_2).leaf := by decide

noncomputable def leafL_309_3 : RejectedLeaf := { leaf := {0,1,17,34,52,74,205,220}, reject := .fullRank { members := ![0,1,17,34,52,74,205,220], points := ![86,94,101,112,120,128], inverse := ![10,5,0,8,7,1,9,0,13,3,2,5,14,14,3,3,11,11,13,5,4,11,3,4,11,11,11,11,10,10,14,14,0,0,14,14] } }
theorem leafL_309_3_valid : (leafL_309_3).reject.ValidFor (leafL_309_3).leaf := by decide

noncomputable def leafL_309_4 : RejectedLeaf := { leaf := {0,1,17,34,52,74,205,232}, reject := .fullRank { members := ![0,1,17,34,52,74,205,232], points := ![94,101,107,128,133,137], inverse := ![3,1,5,10,7,11,4,5,6,10,10,7,10,8,2,10,5,15,6,3,2,9,14,0,2,10,8,2,3,1,10,0,10,10,0,10] } }
theorem leafL_309_4_valid : (leafL_309_4).reject.ValidFor (leafL_309_4).leaf := by decide

noncomputable def leafL_309_5 : RejectedLeaf := { leaf := {0,1,17,34,52,74,205,247}, reject := .fullRank { members := ![0,1,17,34,52,74,205,247], points := ![86,104,112,120,124,128], inverse := ![15,6,14,4,0,2,9,4,10,3,2,6,0,0,0,12,11,7,8,10,5,3,6,2,0,13,13,8,7,15,0,5,5,5,0,5] } }
theorem leafL_309_5_valid : (leafL_309_5).reject.ValidFor (leafL_309_5).leaf := by decide

noncomputable def leafL_309_6 : RejectedLeaf := { leaf := {0,1,17,34,52,74,216,256}, reject := .fullRank { members := ![0,1,17,34,52,74,216,256], points := ![83,92,95,109,110,117], inverse := ![1,4,10,7,15,6,4,0,13,7,9,7,7,5,2,0,0,0,0,9,1,10,5,7,1,12,13,4,4,0,15,12,3,1,1,0] } }
theorem leafL_309_6_valid : (leafL_309_6).reject.ValidFor (leafL_309_6).leaf := by decide

noncomputable def leafL_309_7 : RejectedLeaf := { leaf := {0,1,17,34,52,74,220,232}, reject := .fullRank { members := ![0,1,17,34,52,74,220,232], points := ![86,94,101,115,128,133], inverse := ![1,9,15,12,13,7,9,1,15,9,15,1,12,11,7,3,4,7,13,13,7,4,11,8,9,7,14,14,0,14,3,7,4,12,8,4] } }
theorem leafL_309_7_valid : (leafL_309_7).reject.ValidFor (leafL_309_7).leaf := by decide

noncomputable def leavesL_309 : List RejectedLeaf := [leafL_309_0,leafL_309_1,leafL_309_2,leafL_309_3,leafL_309_4,leafL_309_5,leafL_309_6,leafL_309_7]

theorem leavesL_309_valid : LeafListValid leavesL_309 := by
  intro x hx
  simp only [leavesL_309, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_309_0_valid
  · exact leafL_309_1_valid
  · exact leafL_309_2_valid
  · exact leafL_309_3_valid
  · exact leafL_309_4_valid
  · exact leafL_309_5_valid
  · exact leafL_309_6_valid
  · exact leafL_309_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
