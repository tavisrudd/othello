import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_211_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,150,216}, reject := .fullRank { members := ![0,1,17,34,52,71,150,216], points := ![83,90,91,101,106,122], inverse := ![9,10,12,8,0,6,0,9,0,0,14,7,6,3,5,0,0,0,1,6,15,2,13,7,2,2,0,3,3,0,2,15,13,4,4,0] } }
theorem leafL_211_0_valid : (leafL_211_0).reject.ValidFor (leafL_211_0).leaf := by decide

noncomputable def leafL_211_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,150,222}, reject := .fullRank { members := ![0,1,17,34,52,71,150,222], points := ![83,90,93,106,121,124], inverse := ![8,4,3,8,10,12,5,7,11,14,11,12,15,1,14,0,0,0,4,8,4,15,1,6,14,7,9,0,15,15,2,15,13,0,7,7] } }
theorem leafL_211_1_valid : (leafL_211_1).reject.ValidFor (leafL_211_1).leaf := by decide

noncomputable def leafL_211_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,150,237}, reject := .fullRank { members := ![0,1,17,34,52,71,150,237], points := ![83,90,106,121,122,124], inverse := ![14,1,8,9,11,4,0,9,14,0,7,0,0,0,0,14,9,7,12,4,15,5,6,4,15,15,0,6,4,2,11,11,0,10,2,8] } }
theorem leafL_211_2_valid : (leafL_211_2).reject.ValidFor (leafL_211_2).leaf := by decide

noncomputable def leafL_211_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,150,253}, reject := .fullRank { members := ![0,1,17,34,52,71,150,253], points := ![83,90,121,122,124,131], inverse := ![10,13,12,2,0,8,7,0,2,12,7,14,0,0,14,9,7,0,2,5,1,3,10,15,15,15,6,4,2,0,11,11,10,2,8,0] } }
theorem leafL_211_3_valid : (leafL_211_3).reject.ValidFor (leafL_211_3).leaf := by decide

noncomputable def leafL_211_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,150,269}, reject := .fullRank { members := ![0,1,17,34,52,71,150,269], points := ![90,91,124,126,128,131], inverse := ![8,15,9,6,1,8,10,13,9,15,15,14,0,0,5,10,15,0,4,3,4,0,12,15,1,1,5,11,14,0,7,7,11,8,3,0] } }
theorem leafL_211_4_valid : (leafL_211_4).reject.ValidFor (leafL_211_4).leaf := by decide

noncomputable def leafL_211_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,154,166}, reject := .fullRank { members := ![0,1,17,34,52,71,154,166], points := ![83,93,96,99,109,128], inverse := ![12,3,0,6,14,6,3,13,7,3,13,7,12,1,13,0,0,0,4,11,7,4,11,7,11,1,10,12,12,0,3,3,0,3,3,0] } }
theorem leafL_211_5_valid : (leafL_211_5).reject.ValidFor (leafL_211_5).leaf := by decide

noncomputable def leafL_211_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,154,172}, reject := .fullRank { members := ![0,1,17,34,52,71,154,172], points := ![91,93,104,128,131,185], inverse := ![3,8,12,2,4,0,4,9,7,5,6,9,12,14,11,14,6,1,13,14,10,4,2,15,7,5,1,12,9,6,10,0,10,10,10,0] } }
theorem leafL_211_6_valid : (leafL_211_6).reject.ValidFor (leafL_211_6).leaf := by decide

noncomputable def leafL_211_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,154,173}, reject := .fullRank { members := ![0,1,17,34,52,71,154,173], points := ![83,92,96,104,126,127], inverse := ![6,0,9,8,10,12,2,14,5,14,6,1,8,9,1,0,0,0,6,10,4,15,0,7,15,1,14,0,15,15,15,10,5,0,7,7] } }
theorem leafL_211_7_valid : (leafL_211_7).reject.ValidFor (leafL_211_7).leaf := by decide

noncomputable def leavesL_211 : List RejectedLeaf := [leafL_211_0,leafL_211_1,leafL_211_2,leafL_211_3,leafL_211_4,leafL_211_5,leafL_211_6,leafL_211_7]

theorem leavesL_211_valid : LeafListValid leavesL_211 := by
  intro x hx
  simp only [leavesL_211, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_211_0_valid
  · exact leafL_211_1_valid
  · exact leafL_211_2_valid
  · exact leafL_211_3_valid
  · exact leafL_211_4_valid
  · exact leafL_211_5_valid
  · exact leafL_211_6_valid
  · exact leafL_211_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
