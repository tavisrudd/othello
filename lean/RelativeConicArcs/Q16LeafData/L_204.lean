import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_204_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,140,186}, reject := .fullRank { members := ![0,1,17,34,52,71,140,186], points := ![93,96,99,104,127,128], inverse := ![9,6,0,8,11,13,2,11,6,8,2,5,3,3,15,15,3,3,13,5,6,9,8,15,8,8,11,11,11,11,4,4,15,15,10,10] } }
theorem leafL_204_0_valid : (leafL_204_0).reject.ValidFor (leafL_204_0).leaf := by decide

noncomputable def leafL_204_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,140,197}, reject := .fullRank { members := ![0,1,17,34,52,71,140,197], points := ![94,99,104,106,122,126], inverse := ![15,3,3,8,1,7,9,11,12,9,0,7,0,1,14,15,0,0,8,13,15,13,11,12,0,3,7,4,4,4,0,6,3,5,10,10] } }
theorem leafL_204_1_valid : (leafL_204_1).reject.ValidFor (leafL_204_1).leaf := by decide

noncomputable def leafL_204_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,140,203}, reject := .fullRank { members := ![0,1,17,34,52,71,140,203], points := ![93,96,99,106,122,126], inverse := ![8,7,1,9,8,14,6,15,3,13,2,5,13,13,11,11,14,14,12,4,4,11,5,2,15,15,6,6,3,3,12,12,2,2,9,9] } }
theorem leafL_204_2_valid : (leafL_204_2).reject.ValidFor (leafL_204_2).leaf := by decide

noncomputable def leafL_204_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,140,207}, reject := .fullRank { members := ![0,1,17,34,52,71,140,207], points := ![94,99,109,120,122,126], inverse := ![15,3,11,4,11,9,9,1,15,8,7,8,0,0,0,7,4,3,8,15,0,14,3,10,0,6,6,9,8,1,0,1,1,1,1,0] } }
theorem leafL_204_3_valid : (leafL_204_3).reject.ValidFor (leafL_204_3).leaf := by decide

noncomputable def leafL_204_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,140,213}, reject := .fullRank { members := ![0,1,17,34,52,71,140,213], points := ![93,99,127,128,147,150], inverse := ![10,5,3,12,1,0,5,0,11,3,4,9,3,10,2,5,9,7,5,7,14,10,8,14,11,15,8,5,13,4,13,8,4,7,15,9] } }
theorem leafL_204_4_valid : (leafL_204_4).reject.ValidFor (leafL_204_4).leaf := by decide

noncomputable def leafL_204_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,140,216}, reject := .fullRank { members := ![0,1,17,34,52,71,140,216], points := ![96,99,106,109,122,126], inverse := ![15,10,0,2,10,12,9,9,15,8,10,13,0,15,1,14,0,0,8,3,15,3,6,1,0,4,3,7,4,4,0,5,6,3,10,10] } }
theorem leafL_204_5_valid : (leafL_204_5).reject.ValidFor (leafL_204_5).leaf := by decide

noncomputable def leafL_204_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,140,218}, reject := .fullRank { members := ![0,1,17,34,52,71,140,218], points := ![94,96,104,120,127,128], inverse := ![4,11,8,2,8,12,2,11,14,13,15,5,0,0,0,13,2,15,3,11,15,4,1,2,8,8,0,1,10,11,13,13,0,2,10,8] } }
theorem leafL_204_6_valid : (leafL_204_6).reject.ValidFor (leafL_204_6).leaf := by decide

noncomputable def leafL_204_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,140,223}, reject := .fullRank { members := ![0,1,17,34,52,71,140,223], points := ![93,96,99,104,106,126], inverse := ![14,1,3,8,3,6,14,7,10,2,6,7,0,0,1,14,15,0,11,3,8,5,2,7,3,3,2,3,1,0,14,14,13,9,4,0] } }
theorem leafL_204_7_valid : (leafL_204_7).reject.ValidFor (leafL_204_7).leaf := by decide

noncomputable def leavesL_204 : List RejectedLeaf := [leafL_204_0,leafL_204_1,leafL_204_2,leafL_204_3,leafL_204_4,leafL_204_5,leafL_204_6,leafL_204_7]

theorem leavesL_204_valid : LeafListValid leavesL_204 := by
  intro x hx
  simp only [leavesL_204, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_204_0_valid
  · exact leafL_204_1_valid
  · exact leafL_204_2_valid
  · exact leafL_204_3_valid
  · exact leafL_204_4_valid
  · exact leafL_204_5_valid
  · exact leafL_204_6_valid
  · exact leafL_204_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
