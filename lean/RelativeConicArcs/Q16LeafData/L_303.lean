import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_303_0 : RejectedLeaf := { leaf := {0,1,17,34,52,74,121,141}, reject := .fullRank { members := ![0,1,17,34,52,74,121,141], points := ![83,86,108,112,151,152], inverse := ![15,9,10,1,9,5,4,14,2,6,6,8,8,8,3,3,1,1,13,6,13,8,15,1,10,10,15,15,11,11,13,13,8,8,3,3] } }
theorem leafL_303_0_valid : (leafL_303_0).reject.ValidFor (leafL_303_0).leaf := by decide

noncomputable def leafL_303_1 : RejectedLeaf := { leaf := {0,1,17,34,52,74,121,144}, reject := .fullRank { members := ![0,1,17,34,52,74,121,144], points := ![83,86,93,107,108,150], inverse := ![4,11,9,15,4,12,3,8,1,13,9,14,10,12,6,0,0,0,1,14,4,6,3,14,12,2,14,4,4,0,15,8,7,1,1,0] } }
theorem leafL_303_1_valid : (leafL_303_1).reject.ValidFor (leafL_303_1).leaf := by decide

noncomputable def leafL_303_2 : RejectedLeaf := { leaf := {0,1,17,34,52,74,121,159}, reject := .fullRank { members := ![0,1,17,34,52,74,121,159], points := ![83,86,92,101,104,133], inverse := ![5,6,10,15,1,6,9,11,12,9,0,7,12,10,6,0,0,0,13,3,1,5,13,7,8,3,11,13,13,0,3,8,11,14,14,0] } }
theorem leafL_303_2_valid : (leafL_303_2).reject.ValidFor (leafL_303_2).leaf := by decide

noncomputable def leafL_303_3 : RejectedLeaf := { leaf := {0,1,17,34,52,74,121,203}, reject := .fullRank { members := ![0,1,17,34,52,74,121,203], points := ![83,93,108,112,131,133], inverse := ![11,2,3,13,2,4,11,5,1,8,10,13,15,15,10,10,4,4,13,2,9,1,12,11,15,15,1,1,0,0,15,15,5,5,14,14] } }
theorem leafL_303_3_valid : (leafL_303_3).reject.ValidFor (leafL_303_3).leaf := by decide

noncomputable def leafL_303_4 : RejectedLeaf := { leaf := {0,1,17,34,52,74,121,235}, reject := .fullRank { members := ![0,1,17,34,52,74,121,235], points := ![83,86,93,104,108,144], inverse := ![7,4,10,14,0,6,5,4,15,7,14,7,10,12,6,0,0,0,14,12,13,5,13,7,6,14,8,14,14,0,4,11,15,10,10,0] } }
theorem leafL_303_4_valid : (leafL_303_4).reject.ValidFor (leafL_303_4).leaf := by decide

noncomputable def leafL_303_5 : RejectedLeaf := { leaf := {0,1,17,34,52,74,121,237}, reject := .fullRank { members := ![0,1,17,34,52,74,121,237], points := ![92,104,107,112,131,133], inverse := ![9,14,15,15,5,3,14,7,3,13,4,3,0,9,10,3,0,0,15,15,9,14,6,1,0,12,0,12,4,4,0,4,3,7,10,10] } }
theorem leafL_303_5_valid : (leafL_303_5).reject.ValidFor (leafL_303_5).leaf := by decide

noncomputable def leafL_303_6 : RejectedLeaf := { leaf := {0,1,17,34,52,74,125,159}, reject := .fullRank { members := ![0,1,17,34,52,74,125,159], points := ![86,92,101,108,110,131], inverse := ![9,0,8,10,12,6,9,7,3,1,11,7,0,0,3,13,14,0,7,8,10,1,3,7,15,15,11,13,6,0,3,3,11,5,14,0] } }
theorem leafL_303_6_valid : (leafL_303_6).reject.ValidFor (leafL_303_6).leaf := by decide

noncomputable def leafL_303_7 : RejectedLeaf := { leaf := {0,1,17,34,52,74,125,181}, reject := .fullRank { members := ![0,1,17,34,52,74,125,181], points := ![86,94,103,108,110,144], inverse := ![11,2,11,11,14,6,10,4,13,6,2,7,0,0,7,15,8,0,13,2,14,15,9,7,6,6,8,9,1,0,15,15,12,2,14,0] } }
theorem leafL_303_7_valid : (leafL_303_7).reject.ValidFor (leafL_303_7).leaf := by decide

noncomputable def leavesL_303 : List RejectedLeaf := [leafL_303_0,leafL_303_1,leafL_303_2,leafL_303_3,leafL_303_4,leafL_303_5,leafL_303_6,leafL_303_7]

theorem leavesL_303_valid : LeafListValid leavesL_303 := by
  intro x hx
  simp only [leavesL_303, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_303_0_valid
  · exact leafL_303_1_valid
  · exact leafL_303_2_valid
  · exact leafL_303_3_valid
  · exact leafL_303_4_valid
  · exact leafL_303_5_valid
  · exact leafL_303_6_valid
  · exact leafL_303_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
