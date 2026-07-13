import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_167_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,154}, reject := .fullRank { members := ![0,1,17,34,52,71,93,154], points := ![99,127,128,139,144,166], inverse := ![10,15,3,7,7,7,7,10,4,3,10,0,5,12,4,12,7,6,12,3,8,6,2,3,4,6,9,14,12,9,7,4,2,14,4,11] } }
theorem leafL_167_0_valid : (leafL_167_0).reject.ValidFor (leafL_167_0).leaf := by decide

noncomputable def leafL_167_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,158}, reject := .fullRank { members := ![0,1,17,34,52,71,93,158], points := ![99,101,106,120,121,139], inverse := ![0,13,10,10,3,15,0,2,5,1,15,9,8,15,7,0,0,0,14,15,6,7,8,8,7,11,12,11,11,0,1,7,6,9,9,0] } }
theorem leafL_167_1_valid : (leafL_167_1).reject.ValidFor (leafL_167_1).leaf := by decide

noncomputable def leafL_167_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,159}, reject := .fullRank { members := ![0,1,17,34,52,71,93,159], points := ![106,110,120,121,124,139], inverse := ![13,10,1,9,1,15,8,15,6,0,8,9,0,0,15,9,6,0,0,7,4,4,15,8,9,9,7,14,9,0,10,10,8,13,5,0] } }
theorem leafL_167_2_valid : (leafL_167_2).reject.ValidFor (leafL_167_2).leaf := by decide

noncomputable def leafL_167_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,166}, reject := .fullRank { members := ![0,1,17,34,52,71,93,166], points := ![99,106,110,120,128,140], inverse := ![11,5,9,8,1,15,14,1,8,7,9,9,14,12,2,0,0,0,11,11,7,15,0,8,1,14,15,2,2,0,13,15,2,5,5,0] } }
theorem leafL_167_3_valid : (leafL_167_3).reject.ValidFor (leafL_167_3).leaf := by decide

noncomputable def leafL_167_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,168}, reject := .fullRank { members := ![0,1,17,34,52,71,93,168], points := ![101,106,110,121,144,150], inverse := ![6,11,5,8,11,10,4,4,6,6,15,15,8,1,9,0,0,0,3,5,7,10,15,4,13,11,11,2,8,7,9,5,10,5,7,4] } }
theorem leafL_167_4_valid : (leafL_167_4).reject.ValidFor (leafL_167_4).leaf := by decide

noncomputable def leafL_167_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,172}, reject := .fullRank { members := ![0,1,17,34,52,71,93,172], points := ![106,110,120,121,128,154], inverse := ![1,13,6,4,12,3,13,0,6,10,13,12,0,0,1,5,4,0,15,5,1,1,13,7,9,9,1,15,14,0,10,10,1,7,6,0] } }
theorem leafL_167_5_valid : (leafL_167_5).reject.ValidFor (leafL_167_5).leaf := by decide

noncomputable def leafL_167_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,174}, reject := .fullRank { members := ![0,1,17,34,52,71,93,174], points := ![99,101,106,120,121,140], inverse := ![1,0,6,5,12,15,4,3,0,8,6,9,8,15,7,0,0,0,2,12,9,15,0,8,7,11,12,11,11,0,1,7,6,9,9,0] } }
theorem leafL_167_6_valid : (leafL_167_6).reject.ValidFor (leafL_167_6).leaf := by decide

noncomputable def leafL_167_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,186}, reject := .fullRank { members := ![0,1,17,34,52,71,93,186], points := ![99,101,121,124,127,140], inverse := ![12,11,13,6,2,15,4,3,15,4,5,9,0,0,12,8,4,0,9,14,2,5,8,8,14,14,7,5,2,0,12,12,12,0,12,0] } }
theorem leafL_167_7_valid : (leafL_167_7).reject.ValidFor (leafL_167_7).leaf := by decide

noncomputable def leavesL_167 : List RejectedLeaf := [leafL_167_0,leafL_167_1,leafL_167_2,leafL_167_3,leafL_167_4,leafL_167_5,leafL_167_6,leafL_167_7]

theorem leavesL_167_valid : LeafListValid leavesL_167 := by
  intro x hx
  simp only [leavesL_167, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_167_0_valid
  · exact leafL_167_1_valid
  · exact leafL_167_2_valid
  · exact leafL_167_3_valid
  · exact leafL_167_4_valid
  · exact leafL_167_5_valid
  · exact leafL_167_6_valid
  · exact leafL_167_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
