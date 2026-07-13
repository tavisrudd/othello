import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_182_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,106,150}, reject := .fullRank { members := ![0,1,17,34,52,71,106,150], points := ![91,121,124,126,139,140], inverse := ![7,13,9,10,1,9,7,15,2,4,14,0,0,8,12,4,0,0,7,9,2,3,5,10,0,13,4,9,6,6,0,13,5,8,1,1] } }
theorem leafL_182_0_valid : (leafL_182_0).reject.ValidFor (leafL_182_0).leaf := by decide

noncomputable def leafL_182_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,106,156}, reject := .fullRank { members := ![0,1,17,34,52,71,106,156], points := ![94,96,121,133,144,166], inverse := ![6,1,14,6,14,0,1,11,1,13,1,7,1,14,4,2,3,10,3,3,9,3,1,11,11,12,1,5,8,11,0,11,15,13,10,3] } }
theorem leafL_182_1_valid : (leafL_182_1).reject.ValidFor (leafL_182_1).leaf := by decide

noncomputable def leafL_182_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,106,171}, reject := .fullRank { members := ![0,1,17,34,52,71,106,171], points := ![124,133,147,156,159,182], inverse := ![11,13,15,8,10,10,9,10,4,9,2,12,0,0,7,5,2,0,7,8,11,1,3,6,1,11,10,10,5,15,15,3,13,2,9,10] } }
theorem leafL_182_2_valid : (leafL_182_2).reject.ValidFor (leafL_182_2).leaf := by decide

noncomputable def leafL_182_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,106,172}, reject := .fullRank { members := ![0,1,17,34,52,71,106,172], points := ![91,93,94,121,133,147], inverse := ![6,10,14,5,0,6,9,15,10,5,10,3,1,7,6,0,0,0,14,3,12,11,14,4,10,5,7,4,13,1,6,4,0,1,14,13] } }
theorem leafL_182_3_valid : (leafL_182_3).reject.ValidFor (leafL_182_3).leaf := by decide

noncomputable def leafL_182_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,106,173}, reject := .fullRank { members := ![0,1,17,34,52,71,106,173], points := ![96,124,126,139,140,144], inverse := ![7,15,1,3,6,13,7,7,14,10,1,5,0,0,0,11,13,6,7,2,10,11,10,14,0,6,6,2,3,1,0,7,7,5,4,1] } }
theorem leafL_182_4_valid : (leafL_182_4).reject.ValidFor (leafL_182_4).leaf := by decide

noncomputable def leafL_182_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,106,174}, reject := .fullRank { members := ![0,1,17,34,52,71,106,174], points := ![91,93,124,140,144,147], inverse := ![10,4,3,13,15,14,6,12,6,1,10,7,6,3,11,11,3,6,1,4,9,12,13,13,6,0,3,13,12,4,8,14,3,9,8,4] } }
theorem leafL_182_5_valid : (leafL_182_5).reject.ValidFor (leafL_182_5).leaf := by decide

noncomputable def leafL_182_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,106,182}, reject := .fullRank { members := ![0,1,17,34,52,71,106,182], points := ![91,93,94,121,126,140], inverse := ![4,0,3,4,10,8,2,15,10,14,7,14,1,7,6,0,0,0,13,8,2,12,4,15,9,9,0,5,5,0,2,7,5,12,12,0] } }
theorem leafL_182_6_valid : (leafL_182_6).reject.ValidFor (leafL_182_6).leaf := by decide

noncomputable def leafL_182_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,106,185}, reject := .fullRank { members := ![0,1,17,34,52,71,106,185], points := ![91,93,96,124,126,133], inverse := ![5,6,4,11,5,8,4,1,2,5,12,14,4,12,8,0,0,0,7,11,11,1,9,15,2,7,5,14,14,0,10,10,0,10,10,0] } }
theorem leafL_182_7_valid : (leafL_182_7).reject.ValidFor (leafL_182_7).leaf := by decide

noncomputable def leavesL_182 : List RejectedLeaf := [leafL_182_0,leafL_182_1,leafL_182_2,leafL_182_3,leafL_182_4,leafL_182_5,leafL_182_6,leafL_182_7]

theorem leavesL_182_valid : LeafListValid leavesL_182 := by
  intro x hx
  simp only [leavesL_182, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_182_0_valid
  · exact leafL_182_1_valid
  · exact leafL_182_2_valid
  · exact leafL_182_3_valid
  · exact leafL_182_4_valid
  · exact leafL_182_5_valid
  · exact leafL_182_6_valid
  · exact leafL_182_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
