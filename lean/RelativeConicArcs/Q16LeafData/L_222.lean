import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_222_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,169,269}, reject := .fullRank { members := ![0,1,17,34,52,71,169,269], points := ![91,94,104,124,128,131], inverse := ![5,7,5,4,15,13,8,9,6,2,13,8,14,2,12,10,6,12,10,4,9,0,1,6,4,8,12,3,15,12,10,0,10,0,10,10] } }
theorem leafL_222_0_valid : (leafL_222_0).reject.ValidFor (leafL_222_0).leaf := by decide

noncomputable def leafL_222_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,171,182}, reject := .fullRank { members := ![0,1,17,34,52,71,171,182], points := ![92,101,106,126,127,128], inverse := ![15,11,3,13,12,7,9,9,7,2,11,14,0,0,0,7,14,9,8,7,8,4,15,12,0,8,8,3,5,6,0,13,13,15,3,12] } }
theorem leafL_222_1_valid : (leafL_222_1).reject.ValidFor (leafL_222_1).leaf := by decide

noncomputable def leafL_222_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,171,186}, reject := .fullRank { members := ![0,1,17,34,52,71,171,186], points := ![101,124,127,128,141,159], inverse := ![13,15,6,15,6,12,3,9,3,2,2,9,0,6,11,13,0,0,15,13,7,9,13,1,6,14,14,5,7,4,1,13,15,10,6,15] } }
theorem leafL_222_2_valid : (leafL_222_2).reject.ValidFor (leafL_222_2).leaf := by decide

noncomputable def leafL_222_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,171,191}, reject := .fullRank { members := ![0,1,17,34,52,71,171,191], points := ![90,92,101,120,128,133], inverse := ![4,2,1,3,12,9,3,6,2,14,5,12,15,13,2,6,4,2,12,8,3,3,8,12,14,4,10,0,10,10,11,1,10,3,9,10] } }
theorem leafL_222_3_valid : (leafL_222_3).reject.ValidFor (leafL_222_3).leaf := by decide

noncomputable def leafL_222_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,171,213}, reject := .fullRank { members := ![0,1,17,34,52,71,171,213], points := ![83,92,126,127,128,138], inverse := ![12,11,12,8,10,8,15,8,7,13,3,14,0,0,7,14,9,0,6,1,14,7,1,15,6,6,3,4,7,0,1,1,15,4,11,0] } }
theorem leafL_222_4_valid : (leafL_222_4).reject.ValidFor (leafL_222_4).leaf := by decide

noncomputable def leafL_222_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,171,216}, reject := .fullRank { members := ![0,1,17,34,52,71,171,216], points := ![90,106,109,124,126,128], inverse := ![15,3,11,7,0,1,9,14,0,7,7,7,0,0,0,5,10,15,8,11,4,10,4,9,0,5,5,9,9,0,0,8,8,9,6,15] } }
theorem leafL_222_5_valid : (leafL_222_5).reject.ValidFor (leafL_222_5).leaf := by decide

noncomputable def leafL_222_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,171,217}, reject := .fullRank { members := ![0,1,17,34,52,71,171,217], points := ![83,101,109,120,124,141], inverse := ![15,7,15,4,2,0,11,15,3,10,15,2,10,9,3,10,0,10,8,12,3,4,3,0,14,15,1,3,13,14,11,10,1,13,6,11] } }
theorem leafL_222_6_valid : (leafL_222_6).reject.ValidFor (leafL_222_6).leaf := by decide

noncomputable def leafL_222_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,171,218}, reject := .fullRank { members := ![0,1,17,34,52,71,171,218], points := ![83,101,109,120,124,127], inverse := ![15,7,15,4,2,0,9,3,13,12,10,1,0,0,0,7,2,5,8,12,3,4,3,0,0,13,13,2,5,7,0,5,5,3,15,12] } }
theorem leafL_222_7_valid : (leafL_222_7).reject.ValidFor (leafL_222_7).leaf := by decide

noncomputable def leavesL_222 : List RejectedLeaf := [leafL_222_0,leafL_222_1,leafL_222_2,leafL_222_3,leafL_222_4,leafL_222_5,leafL_222_6,leafL_222_7]

theorem leavesL_222_valid : LeafListValid leavesL_222 := by
  intro x hx
  simp only [leavesL_222, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_222_0_valid
  · exact leafL_222_1_valid
  · exact leafL_222_2_valid
  · exact leafL_222_3_valid
  · exact leafL_222_4_valid
  · exact leafL_222_5_valid
  · exact leafL_222_6_valid
  · exact leafL_222_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
