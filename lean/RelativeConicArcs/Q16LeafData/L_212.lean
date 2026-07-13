import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_212_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,154,191}, reject := .fullRank { members := ![0,1,17,34,52,71,154,191], points := ![91,92,126,131,133,166], inverse := ![13,3,13,5,9,14,9,8,14,8,3,4,15,6,3,6,2,14,4,10,11,9,2,14,5,7,12,14,13,13,6,0,7,2,7,4] } }
theorem leafL_212_0_valid : (leafL_212_0).reject.ValidFor (leafL_212_0).leaf := by decide

noncomputable def leafL_212_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,154,197}, reject := .fullRank { members := ![0,1,17,34,52,71,154,197], points := ![83,92,93,104,109,126], inverse := ![14,5,4,11,3,6,13,10,14,3,13,7,6,12,10,0,0,0,9,12,13,10,5,7,12,6,10,7,7,0,14,9,7,5,5,0] } }
theorem leafL_212_1_valid : (leafL_212_1).reject.ValidFor (leafL_212_1).leaf := by decide

noncomputable def leafL_212_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,154,207}, reject := .fullRank { members := ![0,1,17,34,52,71,154,207], points := ![83,91,92,99,109,128], inverse := ![8,11,12,6,14,6,5,9,5,3,13,7,13,15,2,0,0,0,10,12,14,4,11,7,2,4,6,12,12,0,7,11,12,3,3,0] } }
theorem leafL_212_2_valid : (leafL_212_2).reject.ValidFor (leafL_212_2).leaf := by decide

noncomputable def leafL_212_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,154,208}, reject := .fullRank { members := ![0,1,17,34,52,71,154,208], points := ![109,126,166,173,174,185], inverse := ![1,7,5,3,10,11,13,2,1,4,1,11,0,0,13,2,15,0,13,15,11,1,1,9,7,7,5,0,2,7,14,14,3,6,11,14] } }
theorem leafL_212_3_valid : (leafL_212_3).reject.ValidFor (leafL_212_3).leaf := by decide

noncomputable def leafL_212_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,154,216}, reject := .fullRank { members := ![0,1,17,34,52,71,154,216], points := ![83,91,96,109,126,127], inverse := ![13,9,11,8,12,10,12,9,12,14,11,12,9,3,10,0,0,0,3,12,7,15,9,14,13,6,11,0,15,15,8,9,1,0,7,7] } }
theorem leafL_212_4_valid : (leafL_212_4).reject.ValidFor (leafL_212_4).leaf := by decide

noncomputable def leafL_212_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,154,224}, reject := .fullRank { members := ![0,1,17,34,52,71,154,224], points := ![91,92,93,99,104,126], inverse := ![6,11,2,8,0,6,6,2,13,15,1,7,7,6,1,0,0,0,15,6,1,11,4,7,11,9,2,10,10,0,14,10,4,11,11,0] } }
theorem leafL_212_5_valid : (leafL_212_5).reject.ValidFor (leafL_212_5).leaf := by decide

noncomputable def leafL_212_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,154,232}, reject := .fullRank { members := ![0,1,17,34,52,71,154,232], points := ![83,92,93,126,127,133], inverse := ![2,2,7,11,5,8,14,7,14,3,10,14,6,12,10,0,0,0,6,8,9,10,2,15,4,2,6,15,15,0,12,8,4,7,7,0] } }
theorem leafL_212_6_valid : (leafL_212_6).reject.ValidFor (leafL_212_6).leaf := by decide

noncomputable def leafL_212_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,154,233}, reject := .fullRank { members := ![0,1,17,34,52,71,154,233], points := ![91,93,96,99,104,126], inverse := ![10,3,6,8,0,6,7,7,9,15,1,7,4,12,8,0,0,0,12,12,8,11,4,7,6,9,15,10,10,0,11,0,11,11,11,0] } }
theorem leafL_212_7_valid : (leafL_212_7).reject.ValidFor (leafL_212_7).leaf := by decide

noncomputable def leavesL_212 : List RejectedLeaf := [leafL_212_0,leafL_212_1,leafL_212_2,leafL_212_3,leafL_212_4,leafL_212_5,leafL_212_6,leafL_212_7]

theorem leavesL_212_valid : LeafListValid leavesL_212 := by
  intro x hx
  simp only [leavesL_212, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_212_0_valid
  · exact leafL_212_1_valid
  · exact leafL_212_2_valid
  · exact leafL_212_3_valid
  · exact leafL_212_4_valid
  · exact leafL_212_5_valid
  · exact leafL_212_6_valid
  · exact leafL_212_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
