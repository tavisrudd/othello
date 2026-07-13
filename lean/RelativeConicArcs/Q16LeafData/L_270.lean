import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_270_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,139,185}, reject := .fullRank { members := ![0,1,17,34,52,72,139,185], points := ![93,96,103,125,126,150], inverse := ![15,15,12,9,7,3,2,2,13,10,11,12,7,11,14,8,7,13,13,11,13,2,1,8,7,5,12,15,4,5,0,12,14,1,14,13] } }
theorem leafL_270_0_valid : (leafL_270_0).reject.ValidFor (leafL_270_0).leaf := by decide

noncomputable def leafL_270_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,139,197}, reject := .fullRank { members := ![0,1,17,34,52,72,139,197], points := ![93,115,122,128,151,156], inverse := ![2,1,11,15,0,6,5,8,10,10,7,10,0,7,8,15,0,0,3,0,3,9,1,8,0,15,2,13,14,14,0,12,0,12,12,12] } }
theorem leafL_270_1_valid : (leafL_270_1).reject.ValidFor (leafL_270_1).leaf := by decide

noncomputable def leafL_270_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,139,199}, reject := .fullRank { members := ![0,1,17,34,52,72,139,199], points := ![96,101,112,115,122,125], inverse := ![15,12,4,10,8,4,9,0,14,2,15,10,0,0,0,15,1,14,8,2,13,0,13,10,0,10,10,12,4,8,0,3,3,3,3,0] } }
theorem leafL_270_2_valid : (leafL_270_2).reject.ValidFor (leafL_270_2).leaf := by decide

noncomputable def leafL_270_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,139,213}, reject := .fullRank { members := ![0,1,17,34,52,72,139,213], points := ![93,103,112,124,125,126], inverse := ![15,0,8,6,6,6,9,2,12,10,14,3,0,0,0,1,6,7,8,12,3,1,5,3,0,4,4,2,15,13,0,15,15,9,13,4] } }
theorem leafL_270_3_valid : (leafL_270_3).reject.ValidFor (leafL_270_3).leaf := by decide

noncomputable def leafL_270_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,139,222}, reject := .fullRank { members := ![0,1,17,34,52,72,139,222], points := ![90,96,112,124,125,150], inverse := ![12,4,9,10,14,4,3,7,6,4,0,6,8,7,4,10,2,3,6,6,10,0,13,7,15,6,3,2,4,12,14,0,2,6,2,8] } }
theorem leafL_270_4_valid : (leafL_270_4).reject.ValidFor (leafL_270_4).leaf := by decide

noncomputable def leafL_270_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,139,233}, reject := .fullRank { members := ![0,1,17,34,52,72,139,233], points := ![93,96,101,115,124,128], inverse := ![5,10,8,11,13,0,4,13,14,11,9,5,0,0,0,8,9,1,3,11,15,15,13,5,1,1,0,2,6,4,7,7,0,15,10,5] } }
theorem leafL_270_5_valid : (leafL_270_5).reject.ValidFor (leafL_270_5).leaf := by decide

noncomputable def leafL_270_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,139,243}, reject := .fullRank { members := ![0,1,17,34,52,72,139,243], points := ![90,93,101,112,124,125], inverse := ![5,10,12,4,5,3,2,11,12,2,7,0,13,13,14,14,11,11,8,0,15,0,4,3,3,3,14,14,7,7,1,1,14,14,8,8] } }
theorem leafL_270_6_valid : (leafL_270_6).reject.ValidFor (leafL_270_6).leaf := by decide

noncomputable def leafL_270_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,139,268}, reject := .fullRank { members := ![0,1,17,34,52,72,139,268], points := ![90,93,101,103,112,122], inverse := ![6,9,9,5,4,6,9,0,6,9,1,7,0,0,11,1,10,0,4,12,3,6,10,7,1,1,0,8,8,0,11,11,13,14,3,0] } }
theorem leafL_270_7_valid : (leafL_270_7).reject.ValidFor (leafL_270_7).leaf := by decide

noncomputable def leavesL_270 : List RejectedLeaf := [leafL_270_0,leafL_270_1,leafL_270_2,leafL_270_3,leafL_270_4,leafL_270_5,leafL_270_6,leafL_270_7]

theorem leavesL_270_valid : LeafListValid leavesL_270 := by
  intro x hx
  simp only [leavesL_270, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_270_0_valid
  · exact leafL_270_1_valid
  · exact leafL_270_2_valid
  · exact leafL_270_3_valid
  · exact leafL_270_4_valid
  · exact leafL_270_5_valid
  · exact leafL_270_6_valid
  · exact leafL_270_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
