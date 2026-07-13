import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_149_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,120,137}, reject := .fullRank { members := ![0,1,17,34,52,70,120,137], points := ![83,95,96,103,107,167], inverse := ![7,13,0,5,2,12,1,15,10,10,0,14,14,10,4,0,0,0,5,1,1,2,9,14,0,5,5,14,14,0,10,10,0,10,10,0] } }
theorem leafL_149_0_valid : (leafL_149_0).reject.ValidFor (leafL_149_0).leaf := by decide

noncomputable def leafL_149_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,120,140}, reject := .fullRank { members := ![0,1,17,34,52,70,120,140], points := ![89,91,96,107,147,151], inverse := ![14,6,14,11,15,3,10,4,4,4,1,15,3,12,15,0,0,0,1,8,2,5,3,13,14,14,0,0,10,10,13,3,14,0,11,11] } }
theorem leafL_149_1_valid : (leafL_149_1).reject.ValidFor (leafL_149_1).leaf := by decide

noncomputable def leafL_149_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,120,147}, reject := .fullRank { members := ![0,1,17,34,52,70,120,147], points := ![95,96,103,108,133,140], inverse := ![1,8,2,12,8,14,8,6,13,4,7,0,4,4,11,11,3,3,9,6,5,13,10,13,6,6,9,9,12,12,4,4,9,9,7,7] } }
theorem leafL_149_2_valid : (leafL_149_2).reject.ValidFor (leafL_149_2).leaf := by decide

noncomputable def leafL_149_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,120,171}, reject := .fullRank { members := ![0,1,17,34,52,70,120,171], points := ![83,103,108,109,133,137], inverse := ![9,7,4,13,1,7,14,0,1,8,13,10,0,5,11,14,0,0,15,9,8,9,7,0,0,3,1,2,2,2,0,9,14,7,5,5] } }
theorem leafL_149_3_valid : (leafL_149_3).reject.ValidFor (leafL_149_3).leaf := by decide

noncomputable def leafL_149_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,120,174}, reject := .fullRank { members := ![0,1,17,34,52,70,120,174], points := ![89,95,103,144,151,189], inverse := ![14,7,15,7,1,1,11,0,11,4,5,1,0,11,3,10,9,11,3,8,15,10,4,10,1,9,13,10,11,4,8,13,5,4,2,6] } }
theorem leafL_149_4_valid : (leafL_149_4).reject.ValidFor (leafL_149_4).leaf := by decide

noncomputable def leafL_149_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,120,175}, reject := .fullRank { members := ![0,1,17,34,52,70,120,175], points := ![83,89,91,107,109,141], inverse := ![1,1,9,8,6,6,12,4,6,0,9,7,8,6,14,0,0,0,5,3,9,2,10,7,8,13,5,15,15,0,6,2,4,7,7,0] } }
theorem leafL_149_5_valid : (leafL_149_5).reject.ValidFor (leafL_149_5).leaf := by decide

noncomputable def leafL_149_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,120,185}, reject := .fullRank { members := ![0,1,17,34,52,70,120,185], points := ![83,91,109,133,139,144], inverse := ![8,1,14,14,11,3,13,3,9,8,8,7,0,0,0,15,14,1,0,15,8,10,3,14,8,8,0,4,4,0,5,5,0,12,14,2] } }
theorem leafL_149_6_valid : (leafL_149_6).reject.ValidFor (leafL_149_6).leaf := by decide

noncomputable def leafL_149_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,120,220}, reject := .fullRank { members := ![0,1,17,34,52,70,120,220], points := ![95,133,139,141,158,159], inverse := ![8,12,13,2,6,12,6,8,5,4,0,15,0,2,9,11,0,0,4,15,15,6,7,5,0,7,7,0,10,10,0,15,10,5,9,9] } }
theorem leafL_149_7_valid : (leafL_149_7).reject.ValidFor (leafL_149_7).leaf := by decide

noncomputable def leavesL_149 : List RejectedLeaf := [leafL_149_0,leafL_149_1,leafL_149_2,leafL_149_3,leafL_149_4,leafL_149_5,leafL_149_6,leafL_149_7]

theorem leavesL_149_valid : LeafListValid leavesL_149 := by
  intro x hx
  simp only [leavesL_149, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_149_0_valid
  · exact leafL_149_1_valid
  · exact leafL_149_2_valid
  · exact leafL_149_3_valid
  · exact leafL_149_4_valid
  · exact leafL_149_5_valid
  · exact leafL_149_6_valid
  · exact leafL_149_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
