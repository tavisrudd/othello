import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_301_0 : RejectedLeaf := { leaf := {0,1,17,34,52,74,107,120}, reject := .fullRank { members := ![0,1,17,34,52,74,107,120], points := ![83,94,95,131,133,149], inverse := ![9,4,5,7,4,10,7,8,9,0,9,15,15,9,6,0,0,0,3,13,10,5,3,2,10,10,0,5,5,0,2,3,1,12,12,0] } }
theorem leafL_301_0_valid : (leafL_301_0).reject.ValidFor (leafL_301_0).leaf := by decide

noncomputable def leafL_301_1 : RejectedLeaf := { leaf := {0,1,17,34,52,74,107,231}, reject := .fullRank { members := ![0,1,17,34,52,74,107,231], points := ![86,92,94,117,120,131], inverse := ![1,8,14,12,2,8,6,12,13,8,1,14,2,9,11,0,0,0,5,15,13,5,13,15,11,15,4,15,15,0,5,6,3,7,7,0] } }
theorem leafL_301_1_valid : (leafL_301_1).reject.ValidFor (leafL_301_1).leaf := by decide

noncomputable def leafL_301_2 : RejectedLeaf := { leaf := {0,1,17,34,52,74,109,140}, reject := .fullRank { members := ![0,1,17,34,52,74,109,140], points := ![86,94,128,149,155,163], inverse := ![9,8,4,13,0,9,4,3,7,3,13,14,7,2,3,10,4,8,0,0,11,15,13,9,9,13,13,9,15,15,6,13,8,8,15,4] } }
theorem leafL_301_2_valid : (leafL_301_2).reject.ValidFor (leafL_301_2).leaf := by decide

noncomputable def leafL_301_3 : RejectedLeaf := { leaf := {0,1,17,34,52,74,109,155}, reject := .fullRank { members := ![0,1,17,34,52,74,109,155], points := ![92,94,95,117,124,137], inverse := ![2,0,5,3,13,8,9,6,8,12,5,14,4,12,8,0,0,0,1,0,6,1,9,15,6,11,13,3,3,0,11,9,2,4,4,0] } }
theorem leafL_301_3_valid : (leafL_301_3).reject.ValidFor (leafL_301_3).leaf := by decide

noncomputable def leafL_301_4 : RejectedLeaf := { leaf := {0,1,17,34,52,74,109,222}, reject := .fullRank { members := ![0,1,17,34,52,74,109,222], points := ![92,115,124,140,143,149], inverse := ![15,15,5,7,2,1,7,0,9,14,0,0,6,15,12,5,4,4,15,2,14,10,8,1,1,5,12,7,0,15,14,10,13,2,14,5] } }
theorem leafL_301_4_valid : (leafL_301_4).reject.ValidFor (leafL_301_4).leaf := by decide

noncomputable def leafL_301_5 : RejectedLeaf := { leaf := {0,1,17,34,52,74,109,232}, reject := .fullRank { members := ![0,1,17,34,52,74,109,232], points := ![86,92,94,115,128,137], inverse := ![9,6,8,9,7,8,6,5,4,14,7,14,2,9,11,0,0,0,7,7,7,2,10,15,6,1,7,8,8,0,11,12,7,2,2,0] } }
theorem leafL_301_5_valid : (leafL_301_5).reject.ValidFor (leafL_301_5).leaf := by decide

noncomputable def leafL_301_6 : RejectedLeaf := { leaf := {0,1,17,34,52,74,110,125}, reject := .fullRank { members := ![0,1,17,34,52,74,110,125], points := ![86,137,144,151,159,163], inverse := ![0,0,10,15,0,4,3,2,8,11,9,11,10,13,11,1,8,5,0,13,6,6,15,2,0,14,14,7,7,0,10,8,14,0,9,5] } }
theorem leafL_301_6_valid : (leafL_301_6).reject.ValidFor (leafL_301_6).leaf := by decide

noncomputable def leafL_301_7 : RejectedLeaf := { leaf := {0,1,17,34,52,74,110,181}, reject := .fullRank { members := ![0,1,17,34,52,74,110,181], points := ![86,89,125,141,143,144], inverse := ![0,7,14,0,8,0,9,14,9,2,7,11,0,0,0,7,9,14,10,13,8,11,8,12,5,5,0,12,10,6,13,13,0,15,12,3] } }
theorem leafL_301_7_valid : (leafL_301_7).reject.ValidFor (leafL_301_7).leaf := by decide

noncomputable def leavesL_301 : List RejectedLeaf := [leafL_301_0,leafL_301_1,leafL_301_2,leafL_301_3,leafL_301_4,leafL_301_5,leafL_301_6,leafL_301_7]

theorem leavesL_301_valid : LeafListValid leavesL_301 := by
  intro x hx
  simp only [leavesL_301, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_301_0_valid
  · exact leafL_301_1_valid
  · exact leafL_301_2_valid
  · exact leafL_301_3_valid
  · exact leafL_301_4_valid
  · exact leafL_301_5_valid
  · exact leafL_301_6_valid
  · exact leafL_301_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
