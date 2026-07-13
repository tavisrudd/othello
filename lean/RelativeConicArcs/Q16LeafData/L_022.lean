import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_022_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,150}, reject := .fullRank { members := ![0,1,17,34,52,69,90,150], points := ![99,115,126,135,137,144], inverse := ![7,0,9,0,15,0,7,14,0,14,5,2,0,0,0,6,10,12,7,12,3,11,14,13,0,13,13,9,15,6,0,8,8,5,9,12] } }
theorem leafL_022_0_valid : (leafL_022_0).reject.ValidFor (leafL_022_0).leaf := by decide

noncomputable def leafL_022_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,151}, reject := .fullRank { members := ![0,1,17,34,52,69,90,151], points := ![99,112,127,166,198,205], inverse := ![13,14,0,5,11,12,7,15,1,2,9,2,14,2,13,5,13,9,0,5,13,6,10,4,0,5,1,7,12,15,8,7,3,9,5,0] } }
theorem leafL_022_1_valid : (leafL_022_1).reject.ValidFor (leafL_022_1).leaf := by decide

noncomputable def leafL_022_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,152}, reject := .fullRank { members := ![0,1,17,34,52,69,90,152], points := ![99,110,124,126,127,135], inverse := ![12,11,10,6,5,15,6,1,9,15,8,9,0,0,4,12,8,0,5,2,12,6,5,8,3,3,6,11,13,0,9,9,3,14,13,0] } }
theorem leafL_022_2_valid : (leafL_022_2).reject.ValidFor (leafL_022_2).leaf := by decide

noncomputable def leafL_022_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,155}, reject := .fullRank { members := ![0,1,17,34,52,69,90,155], points := ![104,110,112,115,126,135], inverse := ![13,2,8,5,12,15,6,14,15,12,2,9,8,6,14,0,0,0,13,5,15,8,7,8,5,6,3,11,11,0,15,14,1,9,9,0] } }
theorem leafL_022_3_valid : (leafL_022_3).reject.ValidFor (leafL_022_3).leaf := by decide

noncomputable def leafL_022_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,163}, reject := .fullRank { members := ![0,1,17,34,52,69,90,163], points := ![110,112,126,135,137,139], inverse := ![11,12,9,8,10,13,7,0,14,1,3,11,0,0,0,13,8,5,9,14,15,3,11,0,5,5,0,9,15,6,13,13,0,0,13,13] } }
theorem leafL_022_4_valid : (leafL_022_4).reject.ValidFor (leafL_022_4).leaf := by decide

noncomputable def leafL_022_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,166}, reject := .fullRank { members := ![0,1,17,34,52,69,90,166], points := ![99,104,110,127,137,139], inverse := ![11,15,3,9,9,6,7,11,11,14,1,8,7,13,10,0,0,0,6,1,0,15,9,1,5,15,10,0,12,12,15,7,8,0,13,13] } }
theorem leafL_022_5_valid : (leafL_022_5).reject.ValidFor (leafL_022_5).leaf := by decide

noncomputable def leafL_022_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,169}, reject := .fullRank { members := ![0,1,17,34,52,69,90,169], points := ![99,104,124,127,139,150], inverse := ![5,2,3,10,15,0,5,15,4,8,1,7,13,7,15,0,9,12,11,15,8,12,2,2,9,13,8,14,11,9,8,8,8,8,0,0] } }
theorem leafL_022_6_valid : (leafL_022_6).reject.ValidFor (leafL_022_6).leaf := by decide

noncomputable def leafL_022_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,171}, reject := .fullRank { members := ![0,1,17,34,52,69,90,171], points := ![99,124,126,127,137,144], inverse := ![7,0,9,0,15,0,7,7,4,13,4,13,0,4,12,8,0,0,7,13,2,0,0,8,0,6,6,0,7,7,0,3,11,8,6,6] } }
theorem leafL_022_7_valid : (leafL_022_7).reject.ValidFor (leafL_022_7).leaf := by decide

noncomputable def leavesL_022 : List RejectedLeaf := [leafL_022_0,leafL_022_1,leafL_022_2,leafL_022_3,leafL_022_4,leafL_022_5,leafL_022_6,leafL_022_7]

theorem leavesL_022_valid : LeafListValid leavesL_022 := by
  intro x hx
  simp only [leavesL_022, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_022_0_valid
  · exact leafL_022_1_valid
  · exact leafL_022_2_valid
  · exact leafL_022_3_valid
  · exact leafL_022_4_valid
  · exact leafL_022_5_valid
  · exact leafL_022_6_valid
  · exact leafL_022_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
