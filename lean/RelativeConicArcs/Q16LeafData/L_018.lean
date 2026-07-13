import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_018_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,190}, reject := .fullRank { members := ![0,1,17,34,52,69,89,190], points := ![106,115,122,127,135,141], inverse := ![7,15,5,3,9,6,7,12,10,8,13,4,0,4,13,9,0,0,7,14,7,6,2,10,0,9,6,15,14,14,0,1,8,9,12,12] } }
theorem leafL_018_0_valid : (leafL_018_0).reject.ValidFor (leafL_018_0).leaf := by decide

noncomputable def leafL_018_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,195}, reject := .fullRank { members := ![0,1,17,34,52,69,89,195], points := ![106,126,127,128,135,141], inverse := ![7,6,5,10,9,6,7,5,8,3,13,4,0,7,14,9,0,0,7,1,15,1,2,10,0,12,12,0,14,14,0,4,9,13,12,12] } }
theorem leafL_018_1_valid : (leafL_018_1).reject.ValidFor (leafL_018_1).leaf := by decide

noncomputable def leafL_018_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,203}, reject := .fullRank { members := ![0,1,17,34,52,69,89,203], points := ![99,110,112,115,122,131], inverse := ![13,14,4,4,13,15,7,0,0,14,0,9,6,4,2,0,0,0,5,3,1,9,6,8,9,15,6,15,15,0,1,8,9,3,3,0] } }
theorem leafL_018_2_valid : (leafL_018_2).reject.ValidFor (leafL_018_2).leaf := by decide

noncomputable def leafL_018_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,205}, reject := .fullRank { members := ![0,1,17,34,52,69,89,205], points := ![104,106,112,122,124,135], inverse := ![3,5,1,11,2,15,0,3,4,5,11,9,2,9,11,0,0,0,13,3,9,11,4,8,7,11,12,8,8,0,9,3,10,7,7,0] } }
theorem leafL_018_3_valid : (leafL_018_3).reject.ValidFor (leafL_018_3).leaf := by decide

noncomputable def leafL_018_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,207}, reject := .fullRank { members := ![0,1,17,34,52,69,89,207], points := ![99,122,124,128,131,135], inverse := ![7,7,0,14,12,3,7,4,13,7,9,0,0,10,15,5,0,0,7,8,0,7,1,9,0,14,12,2,8,8,0,0,13,13,13,13] } }
theorem leafL_018_4_valid : (leafL_018_4).reject.ValidFor (leafL_018_4).leaf := by decide

noncomputable def leafL_018_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,208}, reject := .fullRank { members := ![0,1,17,34,52,69,89,208], points := ![106,115,126,135,151,154], inverse := ![2,15,8,2,8,14,2,8,8,4,12,10,8,4,8,5,15,14,13,14,14,1,15,3,1,14,6,6,5,10,0,11,11,0,11,11] } }
theorem leafL_018_5_valid : (leafL_018_5).reject.ValidFor (leafL_018_5).leaf := by decide

noncomputable def leafL_018_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,214}, reject := .fullRank { members := ![0,1,17,34,52,69,89,214], points := ![99,106,115,122,127,135], inverse := ![8,15,14,9,14,15,1,6,3,2,15,9,0,0,4,13,9,0,11,12,13,0,2,8,10,10,5,9,12,0,3,3,3,3,0,0] } }
theorem leafL_018_6_valid : (leafL_018_6).reject.ValidFor (leafL_018_6).leaf := by decide

noncomputable def leafL_018_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,218}, reject := .fullRank { members := ![0,1,17,34,52,69,89,218], points := ![110,112,124,128,131,150], inverse := ![5,4,15,3,8,4,6,14,11,4,13,10,10,15,0,14,13,6,10,3,2,4,10,5,14,0,4,13,2,5,0,10,10,5,9,12] } }
theorem leafL_018_7_valid : (leafL_018_7).reject.ValidFor (leafL_018_7).leaf := by decide

noncomputable def leavesL_018 : List RejectedLeaf := [leafL_018_0,leafL_018_1,leafL_018_2,leafL_018_3,leafL_018_4,leafL_018_5,leafL_018_6,leafL_018_7]

theorem leavesL_018_valid : LeafListValid leavesL_018 := by
  intro x hx
  simp only [leavesL_018, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_018_0_valid
  · exact leafL_018_1_valid
  · exact leafL_018_2_valid
  · exact leafL_018_3_valid
  · exact leafL_018_4_valid
  · exact leafL_018_5_valid
  · exact leafL_018_6_valid
  · exact leafL_018_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
