import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_246_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,90,163}, reject := .fullRank { members := ![0,1,17,34,52,72,90,163], points := ![112,135,137,139,149,150], inverse := ![9,8,7,2,3,6,2,11,5,10,9,15,0,13,8,5,0,0,13,0,2,3,0,12,0,8,3,11,13,13,0,6,3,5,8,8] } }
theorem leafL_246_0_valid : (leafL_246_0).reject.ValidFor (leafL_246_0).leaf := by decide

noncomputable def leafL_246_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,90,169}, reject := .fullRank { members := ![0,1,17,34,52,72,90,169], points := ![115,124,125,139,143,149], inverse := ![11,6,9,14,0,11,7,1,5,7,15,11,6,12,10,0,0,0,8,2,8,13,4,11,8,2,10,8,8,0,10,1,11,13,13,0] } }
theorem leafL_246_1_valid : (leafL_246_1).reject.ValidFor (leafL_246_1).leaf := by decide

noncomputable def leafL_246_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,90,172}, reject := .fullRank { members := ![0,1,17,34,52,72,90,172], points := ![115,125,135,139,151,190], inverse := ![7,6,3,12,9,6,12,7,4,11,5,1,8,0,12,11,14,1,8,1,7,7,10,3,10,9,2,12,15,2,0,3,1,15,15,2] } }
theorem leafL_246_2_valid : (leafL_246_2).reject.ValidFor (leafL_246_2).leaf := by decide

noncomputable def leafL_246_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,90,198}, reject := .fullRank { members := ![0,1,17,34,52,72,90,198], points := ![99,101,115,137,149,151], inverse := ![13,5,8,11,8,2,10,2,15,13,13,7,15,8,13,1,11,0,10,14,4,2,15,13,15,5,15,9,6,10,13,4,4,3,12,2] } }
theorem leafL_246_3_valid : (leafL_246_3).reject.ValidFor (leafL_246_3).leaf := by decide

noncomputable def leafL_246_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,90,220}, reject := .fullRank { members := ![0,1,17,34,52,72,90,220], points := ![99,112,115,135,137,139], inverse := ![8,15,9,13,10,8,7,0,14,10,11,8,0,0,0,13,8,5,3,4,15,10,6,4,14,14,0,10,5,15,2,2,0,10,4,14] } }
theorem leafL_246_4_valid : (leafL_246_4).reject.ValidFor (leafL_246_4).leaf := by decide

noncomputable def leafL_246_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,90,222}, reject := .fullRank { members := ![0,1,17,34,52,72,90,222], points := ![99,112,115,124,125,137], inverse := ![7,0,10,4,7,15,11,12,8,11,13,9,0,0,6,12,10,0,9,14,11,5,1,8,8,8,0,10,10,0,13,13,7,12,11,0] } }
theorem leafL_246_5_valid : (leafL_246_5).reject.ValidFor (leafL_246_5).leaf := by decide

noncomputable def leafL_246_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,90,237}, reject := .fullRank { members := ![0,1,17,34,52,72,90,237], points := ![112,115,124,149,150,151], inverse := ![12,15,1,2,0,1,13,8,9,4,11,3,0,0,0,9,14,7,10,6,11,1,6,0,0,5,5,9,8,1,0,6,6,15,11,4] } }
theorem leafL_246_6_valid : (leafL_246_6).reject.ValidFor (leafL_246_6).leaf := by decide

noncomputable def leafL_246_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,90,271}, reject := .fullRank { members := ![0,1,17,34,52,72,90,271], points := ![99,112,115,124,125,137], inverse := ![7,0,10,4,7,15,11,12,8,11,13,9,0,0,6,12,10,0,9,14,11,5,1,8,8,8,0,10,10,0,13,13,7,12,11,0] } }
theorem leafL_246_7_valid : (leafL_246_7).reject.ValidFor (leafL_246_7).leaf := by decide

noncomputable def leavesL_246 : List RejectedLeaf := [leafL_246_0,leafL_246_1,leafL_246_2,leafL_246_3,leafL_246_4,leafL_246_5,leafL_246_6,leafL_246_7]

theorem leavesL_246_valid : LeafListValid leavesL_246 := by
  intro x hx
  simp only [leavesL_246, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_246_0_valid
  · exact leafL_246_1_valid
  · exact leafL_246_2_valid
  · exact leafL_246_3_valid
  · exact leafL_246_4_valid
  · exact leafL_246_5_valid
  · exact leafL_246_6_valid
  · exact leafL_246_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
