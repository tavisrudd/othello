import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_087_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,131}, reject := .fullRank { members := ![0,1,17,34,52,69,126,131], points := ![89,92,95,103,150,152], inverse := ![8,10,4,11,7,11,14,6,2,4,7,9,12,8,4,0,0,0,4,1,14,5,10,4,6,7,1,0,7,7,7,9,14,0,5,5] } }
theorem leafL_087_0_valid : (leafL_087_0).reject.ValidFor (leafL_087_0).leaf := by decide

noncomputable def leafL_087_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,135}, reject := .fullRank { members := ![0,1,17,34,52,69,126,135], points := ![90,92,106,112,152,155], inverse := ![6,0,2,9,1,13,3,9,12,8,7,9,8,8,11,11,5,5,12,7,2,7,13,3,3,3,4,4,5,5,15,15,13,13,7,7] } }
theorem leafL_087_1_valid : (leafL_087_1).reject.ValidFor (leafL_087_1).leaf := by decide

noncomputable def leafL_087_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,139}, reject := .fullRank { members := ![0,1,17,34,52,69,126,139], points := ![86,89,90,103,104,150], inverse := ![15,4,13,2,9,12,2,10,2,8,12,14,14,4,10,0,0,0,1,4,14,15,10,14,14,1,15,4,4,0,0,1,1,1,1,0] } }
theorem leafL_087_2_valid : (leafL_087_2).reject.ValidFor (leafL_087_2).leaf := by decide

noncomputable def leafL_087_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,152}, reject := .fullRank { members := ![0,1,17,34,52,69,126,152], points := ![86,90,92,103,112,131], inverse := ![7,12,2,4,10,6,14,6,6,13,4,7,13,5,8,0,0,0,12,4,7,0,8,7,2,5,7,8,8,0,6,8,14,2,2,0] } }
theorem leafL_087_3_valid : (leafL_087_3).reject.ValidFor (leafL_087_3).leaf := by decide

noncomputable def leafL_087_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,163}, reject := .fullRank { members := ![0,1,17,34,52,69,126,163], points := ![86,90,93,112,135,139], inverse := ![2,11,0,14,8,14,14,15,15,9,15,8,7,2,5,0,0,0,9,2,4,8,11,12,3,10,9,0,11,11,6,6,0,0,6,6] } }
theorem leafL_087_4_valid : (leafL_087_4).reject.ValidFor (leafL_087_4).leaf := by decide

noncomputable def leafL_087_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,171}, reject := .fullRank { members := ![0,1,17,34,52,69,126,171], points := ![86,89,90,103,138,141], inverse := ![15,8,14,14,11,13,14,1,1,9,14,9,14,4,10,0,0,0,4,13,6,8,11,12,0,12,12,0,6,6,10,15,5,0,8,8] } }
theorem leafL_087_5_valid : (leafL_087_5).reject.ValidFor (leafL_087_5).leaf := by decide

noncomputable def leafL_087_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,173}, reject := .fullRank { members := ![0,1,17,34,52,69,126,173], points := ![86,89,92,104,106,131], inverse := ![9,0,0,0,14,6,1,7,8,7,14,7,12,13,1,0,0,0,2,1,12,15,7,7,11,10,1,12,12,0,3,0,3,3,3,0] } }
theorem leafL_087_6_valid : (leafL_087_6).reject.ValidFor (leafL_087_6).leaf := by decide

noncomputable def leafL_087_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,182}, reject := .fullRank { members := ![0,1,17,34,52,69,126,182], points := ![92,93,95,103,104,135], inverse := ![3,3,9,5,11,6,6,2,10,9,0,7,15,3,12,0,0,0,0,10,5,14,6,7,5,10,15,4,4,0,2,12,14,1,1,0] } }
theorem leafL_087_7_valid : (leafL_087_7).reject.ValidFor (leafL_087_7).leaf := by decide

noncomputable def leavesL_087 : List RejectedLeaf := [leafL_087_0,leafL_087_1,leafL_087_2,leafL_087_3,leafL_087_4,leafL_087_5,leafL_087_6,leafL_087_7]

theorem leavesL_087_valid : LeafListValid leavesL_087 := by
  intro x hx
  simp only [leavesL_087, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_087_0_valid
  · exact leafL_087_1_valid
  · exact leafL_087_2_valid
  · exact leafL_087_3_valid
  · exact leafL_087_4_valid
  · exact leafL_087_5_valid
  · exact leafL_087_6_valid
  · exact leafL_087_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
