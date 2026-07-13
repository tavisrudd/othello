import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_299_0 : RejectedLeaf := { leaf := {0,1,17,34,52,74,94,233}, reject := .fullRank { members := ![0,1,17,34,52,74,94,233], points := ![101,107,108,124,128,131], inverse := ![2,3,6,15,6,15,2,7,2,11,5,9,11,3,8,0,0,0,14,0,9,2,13,8,8,3,11,4,4,0,14,11,5,10,10,0] } }
theorem leafL_299_0_valid : (leafL_299_0).reject.ValidFor (leafL_299_0).leaf := by decide

noncomputable def leafL_299_1 : RejectedLeaf := { leaf := {0,1,17,34,52,74,94,237}, reject := .fullRank { members := ![0,1,17,34,52,74,94,237], points := ![104,107,124,131,133,144], inverse := ![7,0,9,0,0,15,15,8,14,10,11,8,0,0,0,15,8,7,10,13,15,1,8,1,14,14,0,13,2,15,2,2,0,2,0,2] } }
theorem leafL_299_1_valid : (leafL_299_1).reject.ValidFor (leafL_299_1).leaf := by decide

noncomputable def leafL_299_2 : RejectedLeaf := { leaf := {0,1,17,34,52,74,101,125}, reject := .fullRank { members := ![0,1,17,34,52,74,101,125], points := ![92,131,137,151,155,159], inverse := ![8,10,9,14,6,2,6,10,3,11,13,9,0,0,0,12,11,7,4,3,5,7,0,5,0,15,15,0,14,14,0,10,10,6,14,8] } }
theorem leafL_299_2_valid : (leafL_299_2).reject.ValidFor (leafL_299_2).leaf := by decide

noncomputable def leafL_299_3 : RejectedLeaf := { leaf := {0,1,17,34,52,74,101,140}, reject := .fullRank { members := ![0,1,17,34,52,74,101,140], points := ![93,94,128,147,151,155], inverse := ![14,12,5,3,13,8,10,15,8,4,8,1,0,0,0,7,11,12,10,9,10,8,2,3,15,15,0,4,15,11,10,10,0,4,1,5] } }
theorem leafL_299_3_valid : (leafL_299_3).reject.ValidFor (leafL_299_3).leaf := by decide

noncomputable def leafL_299_4 : RejectedLeaf := { leaf := {0,1,17,34,52,74,101,141}, reject := .fullRank { members := ![0,1,17,34,52,74,101,141], points := ![83,147,151,163,167,175], inverse := ![13,10,13,2,6,15,14,10,0,4,0,0,0,0,0,11,7,12,14,2,9,12,9,0,0,15,15,8,13,5,0,13,13,13,13,0] } }
theorem leafL_299_4_valid : (leafL_299_4).reject.ValidFor (leafL_299_4).leaf := by decide

noncomputable def leafL_299_5 : RejectedLeaf := { leaf := {0,1,17,34,52,74,101,159}, reject := .fullRank { members := ![0,1,17,34,52,74,101,159], points := ![83,92,93,115,121,131], inverse := ![8,10,5,11,5,8,7,0,0,9,0,14,6,12,10,0,0,0,15,5,13,4,12,15,2,14,12,11,11,0,4,11,15,6,6,0] } }
theorem leafL_299_5_valid : (leafL_299_5).reject.ValidFor (leafL_299_5).leaf := by decide

noncomputable def leafL_299_6 : RejectedLeaf := { leaf := {0,1,17,34,52,74,101,220}, reject := .fullRank { members := ![0,1,17,34,52,74,101,220], points := ![94,115,121,128,137,141], inverse := ![7,14,0,0,0,8,7,13,4,0,10,4,0,5,14,11,0,0,7,12,8,12,9,6,0,12,11,7,8,8,0,15,7,8,13,13] } }
theorem leafL_299_6_valid : (leafL_299_6).reject.ValidFor (leafL_299_6).leaf := by decide

noncomputable def leafL_299_7 : RejectedLeaf := { leaf := {0,1,17,34,52,74,101,232}, reject := .fullRank { members := ![0,1,17,34,52,74,101,232], points := ![83,92,93,128,137,141], inverse := ![2,2,7,14,3,11,13,10,0,9,13,3,6,12,10,0,0,0,10,9,4,8,5,10,10,9,3,0,14,14,6,14,8,0,10,10] } }
theorem leafL_299_7_valid : (leafL_299_7).reject.ValidFor (leafL_299_7).leaf := by decide

noncomputable def leavesL_299 : List RejectedLeaf := [leafL_299_0,leafL_299_1,leafL_299_2,leafL_299_3,leafL_299_4,leafL_299_5,leafL_299_6,leafL_299_7]

theorem leavesL_299_valid : LeafListValid leavesL_299 := by
  intro x hx
  simp only [leavesL_299, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_299_0_valid
  · exact leafL_299_1_valid
  · exact leafL_299_2_valid
  · exact leafL_299_3_valid
  · exact leafL_299_4_valid
  · exact leafL_299_5_valid
  · exact leafL_299_6_valid
  · exact leafL_299_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
