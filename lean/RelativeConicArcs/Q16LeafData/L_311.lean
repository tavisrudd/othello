import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_311_0 : RejectedLeaf := { leaf := {0,1,17,34,52,74,237,259}, reject := .fullRank { members := ![0,1,17,34,52,74,237,259], points := ![92,94,95,104,107,117], inverse := ![0,8,7,14,6,6,7,10,4,10,4,7,4,12,8,0,0,0,5,7,10,4,11,7,13,7,10,3,3,0,13,10,7,4,4,0] } }
theorem leafL_311_0_valid : (leafL_311_0).reject.ValidFor (leafL_311_0).leaf := by decide

noncomputable def leafL_311_1 : RejectedLeaf := { leaf := {0,1,17,34,52,74,239,256}, reject := .fullRank { members := ![0,1,17,34,52,74,239,256], points := ![83,92,93,108,117,133], inverse := ![15,5,6,11,5,3,1,10,12,0,9,14,6,12,10,0,0,0,1,12,12,6,14,9,1,2,5,6,6,6,0,8,0,8,8,8] } }
theorem leafL_311_1_valid : (leafL_311_1).reject.ValidFor (leafL_311_1).leaf := by decide

noncomputable def leafL_311_2 : RejectedLeaf := { leaf := {0,1,17,34,52,74,239,259}, reject := .fullRank { members := ![0,1,17,34,52,74,239,259], points := ![86,92,104,117,120,125], inverse := ![3,12,8,4,8,10,10,3,14,9,0,14,0,0,0,5,3,6,0,8,15,15,6,14,5,5,0,7,6,1,8,8,0,1,5,4] } }
theorem leafL_311_2_valid : (leafL_311_2).reject.ValidFor (leafL_311_2).leaf := by decide

noncomputable def leafL_311_3 : RejectedLeaf := { leaf := {0,1,17,34,52,75,94,108}, reject := .fullRank { members := ![0,1,17,34,52,75,94,108], points := ![121,122,125,131,133,169], inverse := ![13,1,3,2,7,11,12,14,10,6,5,11,13,11,6,0,0,0,6,11,4,9,11,11,7,7,0,1,1,0,4,5,1,7,7,0] } }
theorem leafL_311_3_valid : (leafL_311_3).reject.ValidFor (leafL_311_3).leaf := by decide

noncomputable def leafL_311_4 : RejectedLeaf := { leaf := {0,1,17,34,52,75,94,167}, reject := .fullRank { members := ![0,1,17,34,52,75,94,167], points := ![99,112,121,122,133,140], inverse := ![4,3,10,3,9,6,14,9,5,11,1,8,3,3,8,8,10,10,15,8,5,10,0,8,5,5,12,12,8,8,1,1,8,8,14,14] } }
theorem leafL_311_4_valid : (leafL_311_4).reject.ValidFor (leafL_311_4).leaf := by decide

noncomputable def leafL_311_5 : RejectedLeaf := { leaf := {0,1,17,34,52,75,94,173}, reject := .fullRank { members := ![0,1,17,34,52,75,94,173], points := ![103,104,108,124,127,131], inverse := ![10,4,9,0,9,15,11,1,13,10,4,9,4,10,14,0,0,0,13,2,8,4,11,8,3,9,10,14,14,0,15,5,10,8,8,0] } }
theorem leafL_311_5_valid : (leafL_311_5).reject.ValidFor (leafL_311_5).leaf := by decide

noncomputable def leafL_311_6 : RejectedLeaf := { leaf := {0,1,17,34,52,75,104,135}, reject := .fullRank { members := ![0,1,17,34,52,75,104,135], points := ![90,94,115,117,126,159], inverse := ![5,7,3,4,2,6,7,2,15,2,5,13,0,0,13,14,3,0,9,10,8,5,7,9,4,4,14,14,0,0,15,15,7,4,3,0] } }
theorem leafL_311_6_valid : (leafL_311_6).reject.ValidFor (leafL_311_6).leaf := by decide

noncomputable def leafL_311_7 : RejectedLeaf := { leaf := {0,1,17,34,52,75,104,154}, reject := .fullRank { members := ![0,1,17,34,52,75,104,154], points := ![117,126,127,166,173,182], inverse := ![9,10,5,9,4,10,9,2,4,9,0,6,11,15,4,0,0,0,7,9,12,9,15,4,4,6,2,10,10,0,3,3,0,3,3,0] } }
theorem leafL_311_7_valid : (leafL_311_7).reject.ValidFor (leafL_311_7).leaf := by decide

noncomputable def leavesL_311 : List RejectedLeaf := [leafL_311_0,leafL_311_1,leafL_311_2,leafL_311_3,leafL_311_4,leafL_311_5,leafL_311_6,leafL_311_7]

theorem leavesL_311_valid : LeafListValid leavesL_311 := by
  intro x hx
  simp only [leavesL_311, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_311_0_valid
  · exact leafL_311_1_valid
  · exact leafL_311_2_valid
  · exact leafL_311_3_valid
  · exact leafL_311_4_valid
  · exact leafL_311_5_valid
  · exact leafL_311_6_valid
  · exact leafL_311_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
