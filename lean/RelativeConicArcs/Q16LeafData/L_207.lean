import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_207_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,144,216}, reject := .fullRank { members := ![0,1,17,34,52,71,144,216], points := ![83,90,91,106,109,122], inverse := ![3,15,3,13,5,6,0,9,0,14,0,7,6,3,5,0,0,0,10,10,8,3,12,7,5,8,13,10,10,0,7,4,3,11,11,0] } }
theorem leafL_207_0_valid : (leafL_207_0).reject.ValidFor (leafL_207_0).leaf := by decide

noncomputable def leafL_207_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,144,217}, reject := .fullRank { members := ![0,1,17,34,52,71,144,217], points := ![83,91,110,122,147,154], inverse := ![6,7,10,2,5,13,14,5,2,12,6,3,13,6,15,13,2,11,10,1,5,0,13,3,5,9,14,15,2,15,2,4,7,14,13,2] } }
theorem leafL_207_1_valid : (leafL_207_1).reject.ValidFor (leafL_207_1).leaf := by decide

noncomputable def leafL_207_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,144,222}, reject := .fullRank { members := ![0,1,17,34,52,71,144,222], points := ![90,93,106,109,121,156], inverse := ![12,2,3,13,10,11,1,1,14,3,1,12,6,2,12,7,5,10,12,13,3,15,1,12,12,11,3,2,2,4,11,11,11,11,0,0] } }
theorem leafL_207_2_valid : (leafL_207_2).reject.ValidFor (leafL_207_2).leaf := by decide

noncomputable def leafL_207_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,144,223}, reject := .fullRank { members := ![0,1,17,34,52,71,144,223], points := ![83,90,93,106,121,122], inverse := ![13,10,8,8,1,7,0,9,0,14,0,7,15,1,14,0,0,0,15,15,8,15,13,10,7,3,4,0,2,2,13,14,3,0,9,9] } }
theorem leafL_207_3_valid : (leafL_207_3).reject.ValidFor (leafL_207_3).leaf := by decide

noncomputable def leafL_207_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,144,232}, reject := .fullRank { members := ![0,1,17,34,52,71,144,232], points := ![93,106,110,126,127,147], inverse := ![8,1,8,13,9,4,6,13,7,12,3,3,9,15,12,15,9,12,2,13,11,13,11,2,15,14,10,6,14,3,6,2,5,3,13,15] } }
theorem leafL_207_4_valid : (leafL_207_4).reject.ValidFor (leafL_207_4).leaf := by decide

noncomputable def leafL_207_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,144,235}, reject := .fullRank { members := ![0,1,17,34,52,71,144,235], points := ![83,90,93,110,120,121], inverse := ![6,12,5,8,6,0,7,1,15,14,12,11,15,1,14,0,0,0,6,1,15,15,13,10,13,12,1,0,3,3,6,9,15,0,4,4] } }
theorem leafL_207_5_valid : (leafL_207_5).reject.ValidFor (leafL_207_5).leaf := by decide

noncomputable def leafL_207_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,144,237}, reject := .fullRank { members := ![0,1,17,34,52,71,144,237], points := ![83,90,91,106,110,122], inverse := ![15,9,9,1,9,6,0,9,0,14,0,7,6,3,5,0,0,0,9,2,3,0,15,7,14,4,10,1,1,0,1,7,6,13,13,0] } }
theorem leafL_207_6_valid : (leafL_207_6).reject.ValidFor (leafL_207_6).leaf := by decide

noncomputable def leafL_207_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,144,243}, reject := .fullRank { members := ![0,1,17,34,52,71,144,243], points := ![90,93,106,121,127,154], inverse := ![10,7,4,15,2,5,10,0,4,0,0,14,9,0,3,7,1,12,15,6,9,10,1,11,6,14,5,7,13,7,8,12,11,7,2,10] } }
theorem leafL_207_7_valid : (leafL_207_7).reject.ValidFor (leafL_207_7).leaf := by decide

noncomputable def leavesL_207 : List RejectedLeaf := [leafL_207_0,leafL_207_1,leafL_207_2,leafL_207_3,leafL_207_4,leafL_207_5,leafL_207_6,leafL_207_7]

theorem leavesL_207_valid : LeafListValid leavesL_207 := by
  intro x hx
  simp only [leavesL_207, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_207_0_valid
  · exact leafL_207_1_valid
  · exact leafL_207_2_valid
  · exact leafL_207_3_valid
  · exact leafL_207_4_valid
  · exact leafL_207_5_valid
  · exact leafL_207_6_valid
  · exact leafL_207_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
