import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_313_0 : RejectedLeaf := { leaf := {0,1,17,34,52,75,126,141}, reject := .fullRank { members := ![0,1,17,34,52,75,126,141], points := ![95,104,108,147,149,167], inverse := ![11,3,5,2,3,13,15,15,14,7,12,5,12,3,15,8,4,12,14,0,0,2,9,5,8,11,3,7,15,8,4,15,11,6,2,4] } }
theorem leafL_313_0_valid : (leafL_313_0).reject.ValidFor (leafL_313_0).leaf := by decide

noncomputable def leafL_313_1 : RejectedLeaf := { leaf := {0,1,17,34,52,75,126,173}, reject := .fullRank { members := ![0,1,17,34,52,75,126,173], points := ![96,104,108,112,131,135], inverse := ![9,2,7,11,0,6,14,13,9,13,11,12,0,12,11,7,0,0,15,13,3,6,1,6,0,5,1,4,6,6,0,0,15,15,15,15] } }
theorem leafL_313_1_valid : (leafL_313_1).reject.ValidFor (leafL_313_1).leaf := by decide

noncomputable def leafL_313_2 : RejectedLeaf := { leaf := {0,1,17,34,52,75,126,182}, reject := .fullRank { members := ![0,1,17,34,52,75,126,182], points := ![93,95,103,104,135,141], inverse := ![7,14,8,6,7,1,10,4,0,9,5,2,4,4,12,12,5,5,10,5,14,6,7,0,6,6,0,0,3,3,5,5,6,6,15,15] } }
theorem leafL_313_2_valid : (leafL_313_2).reject.ValidFor (leafL_313_2).leaf := by decide

noncomputable def leafL_313_3 : RejectedLeaf := { leaf := {0,1,17,34,52,75,126,195}, reject := .fullRank { members := ![0,1,17,34,52,75,126,195], points := ![103,104,108,135,140,154], inverse := ![15,13,11,7,10,5,5,15,8,6,2,6,4,10,14,0,0,0,15,13,15,9,8,12,15,11,4,10,10,0,2,0,2,2,2,0] } }
theorem leafL_313_3_valid : (leafL_313_3).reject.ValidFor (leafL_313_3).leaf := by decide

noncomputable def leafL_313_4 : RejectedLeaf := { leaf := {0,1,17,34,52,75,126,201}, reject := .fullRank { members := ![0,1,17,34,52,75,126,201], points := ![90,103,104,112,131,133], inverse := ![9,10,13,9,15,9,14,0,2,11,8,15,0,2,15,13,0,0,15,3,0,11,13,10,0,0,12,12,4,4,0,14,5,11,10,10] } }
theorem leafL_313_4_valid : (leafL_313_4).reject.ValidFor (leafL_313_4).leaf := by decide

noncomputable def leafL_313_5 : RejectedLeaf := { leaf := {0,1,17,34,52,75,126,248}, reject := .fullRank { members := ![0,1,17,34,52,75,126,248], points := ![90,93,95,131,133,147], inverse := ![9,12,13,9,10,10,3,10,15,9,0,15,15,12,3,0,0,0,12,4,12,13,11,2,2,1,3,5,5,0,7,4,3,12,12,0] } }
theorem leafL_313_5_valid : (leafL_313_5).reject.ValidFor (leafL_313_5).leaf := by decide

noncomputable def leafL_313_6 : RejectedLeaf := { leaf := {0,1,17,34,52,75,127,135}, reject := .fullRank { members := ![0,1,17,34,52,75,127,135], points := ![83,104,108,109,156,166], inverse := ![14,5,8,14,4,8,13,12,1,14,9,7,0,4,9,13,0,0,4,3,9,0,1,15,7,15,12,4,7,7,4,0,0,4,4,4] } }
theorem leafL_313_6_valid : (leafL_313_6).reject.ValidFor (leafL_313_6).leaf := by decide

noncomputable def leafL_313_7 : RejectedLeaf := { leaf := {0,1,17,34,52,75,127,182}, reject := .fullRank { members := ![0,1,17,34,52,75,127,182], points := ![93,94,103,104,135,138], inverse := ![1,8,5,11,6,0,12,2,15,6,4,3,6,6,5,5,11,11,13,2,2,10,1,6,3,3,1,1,11,11,1,1,1,1,0,0] } }
theorem leafL_313_7_valid : (leafL_313_7).reject.ValidFor (leafL_313_7).leaf := by decide

noncomputable def leavesL_313 : List RejectedLeaf := [leafL_313_0,leafL_313_1,leafL_313_2,leafL_313_3,leafL_313_4,leafL_313_5,leafL_313_6,leafL_313_7]

theorem leavesL_313_valid : LeafListValid leavesL_313 := by
  intro x hx
  simp only [leavesL_313, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_313_0_valid
  · exact leafL_313_1_valid
  · exact leafL_313_2_valid
  · exact leafL_313_3_valid
  · exact leafL_313_4_valid
  · exact leafL_313_5_valid
  · exact leafL_313_6_valid
  · exact leafL_313_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
