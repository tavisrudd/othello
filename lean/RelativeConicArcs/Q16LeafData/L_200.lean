import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_200_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,128,237}, reject := .fullRank { members := ![0,1,17,34,52,71,128,237], points := ![94,104,131,138,139,147], inverse := ![6,11,6,15,9,12,5,1,12,4,14,2,0,0,6,3,5,0,15,8,13,8,2,0,5,3,1,1,2,4,13,10,15,9,10,11] } }
theorem leafL_200_0_valid : (leafL_200_0).reject.ValidFor (leafL_200_0).leaf := by decide

noncomputable def leafL_200_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,128,239}, reject := .fullRank { members := ![0,1,17,34,52,71,128,239], points := ![93,94,99,104,131,140], inverse := ![8,1,11,5,10,12,13,3,4,13,15,8,9,9,10,10,9,9,15,0,11,3,0,7,4,4,13,13,1,1,3,3,5,5,2,2] } }
theorem leafL_200_1_valid : (leafL_200_1).reject.ValidFor (leafL_200_1).leaf := by decide

noncomputable def leafL_200_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,128,243}, reject := .fullRank { members := ![0,1,17,34,52,71,128,243], points := ![93,94,101,104,138,140], inverse := ![0,9,10,4,9,15,6,8,0,9,1,6,5,5,11,11,12,12,2,13,1,9,14,9,14,14,1,1,6,6,11,11,11,11,11,11] } }
theorem leafL_200_2_valid : (leafL_200_2).reject.ValidFor (leafL_200_2).leaf := by decide

noncomputable def leafL_200_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,128,259}, reject := .fullRank { members := ![0,1,17,34,52,71,128,259], points := ![94,110,139,150,154,166], inverse := ![8,3,2,15,12,11,8,2,13,12,15,4,1,3,15,10,5,2,14,4,13,11,15,3,13,6,8,10,3,10,15,15,0,15,0,15] } }
theorem leafL_200_3_valid : (leafL_200_3).reject.ValidFor (leafL_200_3).leaf := by decide

noncomputable def leafL_200_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,128,267}, reject := .fullRank { members := ![0,1,17,34,52,71,128,267], points := ![93,94,101,104,147,150], inverse := ![0,6,6,13,4,8,9,3,3,7,15,1,1,1,3,3,11,11,8,3,8,13,2,12,12,12,5,5,12,12,3,3,8,8,5,5] } }
theorem leafL_200_4_valid : (leafL_200_4).reject.ValidFor (leafL_200_4).leaf := by decide

noncomputable def leafL_200_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,131,154}, reject := .fullRank { members := ![0,1,17,34,52,71,131,154], points := ![96,126,128,172,174,185], inverse := ![0,10,12,14,3,10,3,6,14,1,9,3,11,15,2,14,6,14,5,12,7,8,13,11,1,4,8,11,5,3,15,0,8,15,10,2] } }
theorem leafL_200_5_valid : (leafL_200_5).reject.ValidFor (leafL_200_5).leaf := by decide

noncomputable def leafL_200_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,131,156}, reject := .fullRank { members := ![0,1,17,34,52,71,131,156], points := ![94,96,101,109,110,121], inverse := ![11,4,15,6,1,6,5,12,2,2,14,7,0,0,13,15,2,0,11,3,3,6,10,7,11,11,10,1,11,0,9,9,4,3,7,0] } }
theorem leafL_200_6_valid : (leafL_200_6).reject.ValidFor (leafL_200_6).leaf := by decide

noncomputable def leafL_200_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,131,169}, reject := .fullRank { members := ![0,1,17,34,52,71,131,169], points := ![92,94,96,159,182,191], inverse := ![6,3,2,3,7,2,7,1,11,5,0,8,5,10,15,0,0,0,5,14,2,3,5,15,7,1,6,0,9,9,14,7,9,0,15,15] } }
theorem leafL_200_7_valid : (leafL_200_7).reject.ValidFor (leafL_200_7).leaf := by decide

noncomputable def leavesL_200 : List RejectedLeaf := [leafL_200_0,leafL_200_1,leafL_200_2,leafL_200_3,leafL_200_4,leafL_200_5,leafL_200_6,leafL_200_7]

theorem leavesL_200_valid : LeafListValid leavesL_200 := by
  intro x hx
  simp only [leavesL_200, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_200_0_valid
  · exact leafL_200_1_valid
  · exact leafL_200_2_valid
  · exact leafL_200_3_valid
  · exact leafL_200_4_valid
  · exact leafL_200_5_valid
  · exact leafL_200_6_valid
  · exact leafL_200_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
