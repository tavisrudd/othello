import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_125_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,135}, reject := .fullRank { members := ![0,1,17,34,52,70,90,135], points := ![108,110,124,125,126,149], inverse := ![12,0,3,1,12,3,11,6,14,11,4,12,0,0,1,6,7,0,13,7,2,14,1,7,14,14,15,7,8,0,12,12,12,0,12,0] } }
theorem leafL_125_0_valid : (leafL_125_0).reject.ValidFor (leafL_125_0).leaf := by decide

noncomputable def leafL_125_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,144}, reject := .fullRank { members := ![0,1,17,34,52,70,90,144], points := ![109,110,125,127,149,167], inverse := ![14,2,5,11,3,0,15,13,4,0,2,4,0,2,3,12,1,12,8,11,7,13,10,3,2,10,4,13,4,5,14,12,4,11,1,12] } }
theorem leafL_125_1_valid : (leafL_125_1).reject.ValidFor (leafL_125_1).leaf := by decide

noncomputable def leafL_125_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,147}, reject := .fullRank { members := ![0,1,17,34,52,70,90,147], points := ![101,110,125,127,133,167], inverse := ![2,11,3,6,8,5,8,7,11,8,13,1,3,4,7,1,10,11,9,12,11,10,9,13,13,11,14,15,3,4,4,9,10,15,15,7] } }
theorem leafL_125_2_valid : (leafL_125_2).reject.ValidFor (leafL_125_2).leaf := by decide

noncomputable def leafL_125_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,149}, reject := .fullRank { members := ![0,1,17,34,52,70,90,149], points := ![109,126,127,135,144,168], inverse := ![1,12,4,10,6,4,7,5,11,3,10,0,4,7,8,15,13,9,10,2,8,11,12,7,14,15,3,0,7,5,14,13,1,14,9,5] } }
theorem leafL_125_3_valid : (leafL_125_3).reject.ValidFor (leafL_125_3).leaf := by decide

noncomputable def leafL_125_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,152}, reject := .fullRank { members := ![0,1,17,34,52,70,90,152], points := ![110,115,124,125,131,135], inverse := ![7,6,2,13,6,9,7,9,3,4,3,10,0,6,12,10,0,0,7,15,1,1,11,3,0,8,2,10,8,8,0,10,1,11,13,13] } }
theorem leafL_125_4_valid : (leafL_125_4).reject.ValidFor (leafL_125_4).leaf := by decide

noncomputable def leafL_125_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,167}, reject := .fullRank { members := ![0,1,17,34,52,70,90,167], points := ![109,115,125,133,144,152], inverse := ![14,5,8,0,12,14,10,8,4,3,2,7,11,15,8,11,4,3,15,2,1,0,13,1,14,11,2,3,1,5,1,5,13,4,2,15] } }
theorem leafL_125_5_valid : (leafL_125_5).reject.ValidFor (leafL_125_5).leaf := by decide

noncomputable def leafL_125_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,168}, reject := .fullRank { members := ![0,1,17,34,52,70,90,168], points := ![108,109,110,124,126,131], inverse := ![8,10,5,13,4,15,3,1,5,8,6,9,1,6,7,0,0,0,6,3,2,8,7,8,8,7,15,9,9,0,12,0,12,12,12,0] } }
theorem leafL_125_6_valid : (leafL_125_6).reject.ValidFor (leafL_125_6).leaf := by decide

noncomputable def leafL_125_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,171}, reject := .fullRank { members := ![0,1,17,34,52,70,90,171], points := ![101,108,109,125,126,133], inverse := ![7,5,5,1,8,15,10,12,1,7,9,9,1,5,4,0,0,0,6,13,12,3,12,8,13,0,13,3,3,0,2,8,10,14,14,0] } }
theorem leafL_125_7_valid : (leafL_125_7).reject.ValidFor (leafL_125_7).leaf := by decide

noncomputable def leavesL_125 : List RejectedLeaf := [leafL_125_0,leafL_125_1,leafL_125_2,leafL_125_3,leafL_125_4,leafL_125_5,leafL_125_6,leafL_125_7]

theorem leavesL_125_valid : LeafListValid leavesL_125 := by
  intro x hx
  simp only [leavesL_125, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_125_0_valid
  · exact leafL_125_1_valid
  · exact leafL_125_2_valid
  · exact leafL_125_3_valid
  · exact leafL_125_4_valid
  · exact leafL_125_5_valid
  · exact leafL_125_6_valid
  · exact leafL_125_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
