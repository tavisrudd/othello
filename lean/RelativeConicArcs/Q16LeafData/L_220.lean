import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_220_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,168,181}, reject := .fullRank { members := ![0,1,17,34,52,71,168,181], points := ![96,109,124,144,147,150], inverse := ![14,8,15,7,6,9,2,10,13,15,11,1,13,6,10,2,3,0,5,0,9,1,3,14,6,2,0,13,12,5,2,2,2,2,2,2] } }
theorem leafL_220_0_valid : (leafL_220_0).reject.ValidFor (leafL_220_0).leaf := by decide

noncomputable def leafL_220_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,168,182}, reject := .fullRank { members := ![0,1,17,34,52,71,168,182], points := ![91,92,93,101,106,121], inverse := ![3,8,4,13,5,6,14,0,7,13,3,7,7,6,1,0,0,0,5,10,7,15,0,7,10,14,4,3,3,0,3,15,12,4,4,0] } }
theorem leafL_220_1_valid : (leafL_220_1).reject.ValidFor (leafL_220_1).leaf := by decide

noncomputable def leafL_220_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,168,185}, reject := .fullRank { members := ![0,1,17,34,52,71,168,185], points := ![91,93,96,106,109,124], inverse := ![1,10,4,4,12,6,7,6,8,13,3,7,4,12,8,0,0,0,10,7,5,0,15,7,6,9,15,10,10,0,11,0,11,11,11,0] } }
theorem leafL_220_2_valid : (leafL_220_2).reject.ValidFor (leafL_220_2).leaf := by decide

noncomputable def leafL_220_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,168,207}, reject := .fullRank { members := ![0,1,17,34,52,71,168,207], points := ![91,92,109,110,121,124], inverse := ![14,1,5,13,3,5,9,0,12,2,12,11,8,8,1,1,7,7,10,2,0,15,11,12,13,13,5,5,7,7,1,1,1,1,0,0] } }
theorem leafL_220_3_valid : (leafL_220_3).reject.ValidFor (leafL_220_3).leaf := by decide

noncomputable def leafL_220_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,168,218}, reject := .fullRank { members := ![0,1,17,34,52,71,168,218], points := ![91,96,101,109,121,124], inverse := ![8,7,2,10,15,9,0,9,15,1,5,2,9,9,2,2,9,9,14,6,6,9,8,15,3,3,1,1,2,2,4,4,6,6,15,15] } }
theorem leafL_220_4_valid : (leafL_220_4).reject.ValidFor (leafL_220_4).leaf := by decide

noncomputable def leafL_220_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,168,240}, reject := .fullRank { members := ![0,1,17,34,52,71,168,240], points := ![90,101,106,110,122,124], inverse := ![15,15,15,8,2,4,9,0,14,0,7,0,0,8,1,9,0,0,8,8,11,12,13,10,0,9,7,14,8,8,0,3,8,11,7,7] } }
theorem leafL_220_5_valid : (leafL_220_5).reject.ValidFor (leafL_220_5).leaf := by decide

noncomputable def leafL_220_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,168,243}, reject := .fullRank { members := ![0,1,17,34,52,71,168,243], points := ![93,106,121,124,133,138], inverse := ![10,13,0,3,10,15,13,10,14,13,10,14,2,2,7,5,15,13,7,0,14,6,14,1,2,2,11,9,4,6,15,15,2,13,1,14] } }
theorem leafL_220_6_valid : (leafL_220_6).reject.ValidFor (leafL_220_6).leaf := by decide

noncomputable def leafL_220_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,168,253}, reject := .fullRank { members := ![0,1,17,34,52,71,168,253], points := ![90,110,121,122,124,133], inverse := ![6,1,10,1,4,9,13,10,10,2,11,4,0,0,14,9,7,0,9,14,5,8,11,1,6,6,4,1,3,6,1,1,4,10,15,1] } }
theorem leafL_220_7_valid : (leafL_220_7).reject.ValidFor (leafL_220_7).leaf := by decide

noncomputable def leavesL_220 : List RejectedLeaf := [leafL_220_0,leafL_220_1,leafL_220_2,leafL_220_3,leafL_220_4,leafL_220_5,leafL_220_6,leafL_220_7]

theorem leavesL_220_valid : LeafListValid leavesL_220 := by
  intro x hx
  simp only [leavesL_220, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_220_0_valid
  · exact leafL_220_1_valid
  · exact leafL_220_2_valid
  · exact leafL_220_3_valid
  · exact leafL_220_4_valid
  · exact leafL_220_5_valid
  · exact leafL_220_6_valid
  · exact leafL_220_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
