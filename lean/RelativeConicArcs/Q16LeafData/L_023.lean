import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_023_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,183}, reject := .fullRank { members := ![0,1,17,34,52,69,90,183], points := ![110,124,127,137,139,152], inverse := ![13,0,6,10,12,12,15,2,0,2,14,1,4,13,11,10,1,9,0,15,13,4,13,11,3,5,14,13,7,2,15,14,15,10,14,10] } }
theorem leafL_023_0_valid : (leafL_023_0).reject.ValidFor (leafL_023_0).leaf := by decide

noncomputable def leafL_023_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,184}, reject := .fullRank { members := ![0,1,17,34,52,69,90,184], points := ![99,110,112,115,126,135], inverse := ![1,12,10,5,12,15,11,6,10,12,2,9,6,4,2,0,0,0,1,11,13,8,7,8,7,10,13,11,11,0,9,9,0,9,9,0] } }
theorem leafL_023_1_valid : (leafL_023_1).reject.ValidFor (leafL_023_1).leaf := by decide

noncomputable def leafL_023_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,190}, reject := .fullRank { members := ![0,1,17,34,52,69,90,190], points := ![104,127,135,137,139,150], inverse := ![15,5,9,8,11,1,11,4,4,9,10,8,0,0,13,8,5,0,0,2,13,4,0,11,12,10,7,14,7,8,14,9,2,11,11,5] } }
theorem leafL_023_2_valid : (leafL_023_2).reject.ValidFor (leafL_023_2).leaf := by decide

noncomputable def leafL_023_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,198}, reject := .fullRank { members := ![0,1,17,34,52,69,90,198], points := ![99,104,110,124,126,135], inverse := ![13,8,2,1,8,15,1,13,11,13,3,9,7,13,10,0,0,0,4,8,11,7,8,8,5,5,0,9,9,0,15,5,10,12,12,0] } }
theorem leafL_023_3_valid : (leafL_023_3).reject.ValidFor (leafL_023_3).leaf := by decide

noncomputable def leafL_023_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,203}, reject := .fullRank { members := ![0,1,17,34,52,69,90,203], points := ![110,112,115,126,127,137], inverse := ![11,12,4,10,7,15,3,4,11,5,0,9,0,0,15,9,6,0,14,9,2,2,15,8,1,1,15,8,7,0,7,7,5,12,9,0] } }
theorem leafL_023_4_valid : (leafL_023_4).reject.ValidFor (leafL_023_4).leaf := by decide

noncomputable def leafL_023_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,205}, reject := .fullRank { members := ![0,1,17,34,52,69,90,205], points := ![112,124,126,127,135,150], inverse := ![14,10,2,5,12,14,15,6,1,5,12,1,0,4,12,8,0,0,8,8,11,13,12,10,7,13,8,8,1,11,6,7,7,5,7,4] } }
theorem leafL_023_5_valid : (leafL_023_5).reject.ValidFor (leafL_023_5).leaf := by decide

noncomputable def leafL_023_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,207}, reject := .fullRank { members := ![0,1,17,34,52,69,90,207], points := ![99,110,115,124,135,139], inverse := ![12,11,10,3,15,0,2,5,5,11,6,15,3,3,8,8,9,9,5,2,10,5,8,0,12,12,8,8,11,11,15,15,12,12,1,1] } }
theorem leafL_023_6_valid : (leafL_023_6).reject.ValidFor (leafL_023_6).leaf := by decide

noncomputable def leafL_023_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,220}, reject := .fullRank { members := ![0,1,17,34,52,69,90,220], points := ![110,112,115,127,135,137], inverse := ![7,0,11,2,1,14,5,2,5,11,9,0,14,14,11,11,6,6,3,4,1,14,11,3,0,0,3,3,10,10,15,15,15,15,15,15] } }
theorem leafL_023_7_valid : (leafL_023_7).reject.ValidFor (leafL_023_7).leaf := by decide

noncomputable def leavesL_023 : List RejectedLeaf := [leafL_023_0,leafL_023_1,leafL_023_2,leafL_023_3,leafL_023_4,leafL_023_5,leafL_023_6,leafL_023_7]

theorem leavesL_023_valid : LeafListValid leavesL_023 := by
  intro x hx
  simp only [leavesL_023, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_023_0_valid
  · exact leafL_023_1_valid
  · exact leafL_023_2_valid
  · exact leafL_023_3_valid
  · exact leafL_023_4_valid
  · exact leafL_023_5_valid
  · exact leafL_023_6_valid
  · exact leafL_023_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
