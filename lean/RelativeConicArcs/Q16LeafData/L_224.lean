import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_224_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,172,182}, reject := .fullRank { members := ![0,1,17,34,52,71,172,182], points := ![91,93,104,106,110,128], inverse := ![15,0,11,2,1,6,13,4,3,9,4,7,0,0,7,4,3,0,15,7,15,10,10,7,8,8,12,12,0,0,7,7,14,5,11,0] } }
theorem leafL_224_0_valid : (leafL_224_0).reject.ValidFor (leafL_224_0).leaf := by decide

noncomputable def leafL_224_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,172,186}, reject := .fullRank { members := ![0,1,17,34,52,71,172,186], points := ![91,104,121,128,131,133], inverse := ![7,0,0,14,0,8,0,7,3,13,13,4,10,10,6,12,13,7,5,2,4,14,13,0,10,10,7,13,12,6,10,10,0,10,10,0] } }
theorem leafL_224_1_valid : (leafL_224_1).reject.ValidFor (leafL_224_1).leaf := by decide

noncomputable def leafL_224_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,172,203}, reject := .fullRank { members := ![0,1,17,34,52,71,172,203], points := ![83,90,93,106,128,131], inverse := ![2,5,14,14,0,6,15,4,3,15,6,1,15,1,14,0,0,0,1,9,12,3,11,12,15,4,9,2,2,2,15,11,13,9,9,9] } }
theorem leafL_224_2_valid : (leafL_224_2).reject.ValidFor (leafL_224_2).leaf := by decide

noncomputable def leafL_224_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,172,223}, reject := .fullRank { members := ![0,1,17,34,52,71,172,223], points := ![83,90,93,106,121,138], inverse := ![13,13,8,15,1,7,0,14,0,9,0,7,15,1,14,0,0,0,15,5,8,5,13,10,7,1,4,2,2,2,13,7,3,9,9,9] } }
theorem leafL_224_3_valid : (leafL_224_3).reject.ValidFor (leafL_224_3).leaf := by decide

noncomputable def leafL_224_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,172,224}, reject := .fullRank { members := ![0,1,17,34,52,71,172,224], points := ![91,93,104,121,133,147], inverse := ![11,6,14,2,9,9,7,12,10,0,5,4,10,6,6,3,5,12,11,1,12,13,4,15,5,3,7,14,0,15,6,4,0,1,14,13] } }
theorem leafL_224_4_valid : (leafL_224_4).reject.ValidFor (leafL_224_4).leaf := by decide

noncomputable def leafL_224_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,172,235}, reject := .fullRank { members := ![0,1,17,34,52,71,172,235], points := ![83,90,93,110,120,121], inverse := ![6,12,5,8,6,0,7,1,15,14,12,11,15,1,14,0,0,0,6,1,15,15,13,10,13,12,1,0,3,3,6,9,15,0,4,4] } }
theorem leafL_224_5_valid : (leafL_224_5).reject.ValidFor (leafL_224_5).leaf := by decide

noncomputable def leafL_224_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,172,259}, reject := .fullRank { members := ![0,1,17,34,52,71,172,259], points := ![90,94,104,106,110,121], inverse := ![2,13,14,10,12,6,6,15,13,2,1,7,0,0,7,4,3,0,8,0,13,12,14,7,12,12,15,2,13,0,13,13,0,13,13,0] } }
theorem leafL_224_6_valid : (leafL_224_6).reject.ValidFor (leafL_224_6).leaf := by decide

noncomputable def leafL_224_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,172,269}, reject := .fullRank { members := ![0,1,17,34,52,71,172,269], points := ![83,90,91,104,110,120], inverse := ![8,1,6,0,8,6,13,10,14,14,0,7,6,3,5,0,0,0,13,12,9,13,2,7,6,0,6,5,5,0,3,6,5,12,12,0] } }
theorem leafL_224_7_valid : (leafL_224_7).reject.ValidFor (leafL_224_7).leaf := by decide

noncomputable def leavesL_224 : List RejectedLeaf := [leafL_224_0,leafL_224_1,leafL_224_2,leafL_224_3,leafL_224_4,leafL_224_5,leafL_224_6,leafL_224_7]

theorem leavesL_224_valid : LeafListValid leavesL_224 := by
  intro x hx
  simp only [leavesL_224, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_224_0_valid
  · exact leafL_224_1_valid
  · exact leafL_224_2_valid
  · exact leafL_224_3_valid
  · exact leafL_224_4_valid
  · exact leafL_224_5_valid
  · exact leafL_224_6_valid
  · exact leafL_224_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
