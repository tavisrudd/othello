import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_190_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,110,253}, reject := .fullRank { members := ![0,1,17,34,52,71,110,253], points := ![83,122,127,131,133,144], inverse := ![7,9,7,2,8,2,7,7,14,4,1,11,0,0,0,15,8,7,7,5,13,1,14,0,0,1,1,14,9,7,0,6,6,8,15,7] } }
theorem leafL_190_0_valid : (leafL_190_0).reject.ValidFor (leafL_190_0).leaf := by decide

noncomputable def leafL_190_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,120,139}, reject := .fullRank { members := ![0,1,17,34,52,71,120,139], points := ![93,159,166,176,185,189], inverse := ![0,11,2,7,13,2,15,15,8,1,11,2,8,14,15,13,12,8,4,15,11,5,10,15,5,2,10,6,11,0,7,8,7,2,7,13] } }
theorem leafL_190_1_valid : (leafL_190_1).reject.ValidFor (leafL_190_1).leaf := by decide

noncomputable def leafL_190_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,120,144}, reject := .fullRank { members := ![0,1,17,34,52,71,120,144], points := ![91,93,147,155,158,174], inverse := ![3,14,9,11,5,11,12,2,12,5,3,4,0,0,1,4,5,0,8,6,7,0,12,5,11,11,8,4,12,0,3,3,10,7,13,0] } }
theorem leafL_190_2_valid : (leafL_190_2).reject.ValidFor (leafL_190_2).leaf := by decide

noncomputable def leafL_190_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,120,147}, reject := .fullRank { members := ![0,1,17,34,52,71,120,147], points := ![96,133,140,144,171,172], inverse := ![11,10,4,12,8,0,13,15,4,10,5,9,0,14,2,12,0,0,10,4,2,11,13,10,0,5,15,10,9,9,0,5,9,12,3,3] } }
theorem leafL_190_3_valid : (leafL_190_3).reject.ValidFor (leafL_190_3).leaf := by decide

noncomputable def leafL_190_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,120,158}, reject := .fullRank { members := ![0,1,17,34,52,71,120,158], points := ![91,93,99,138,140,144], inverse := ![2,11,14,0,13,11,4,10,9,1,4,2,0,0,0,10,15,5,3,12,8,15,10,2,2,2,0,12,4,8,12,12,0,12,0,12] } }
theorem leafL_190_4_valid : (leafL_190_4).reject.ValidFor (leafL_190_4).leaf := by decide

noncomputable def leafL_190_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,120,166}, reject := .fullRank { members := ![0,1,17,34,52,71,120,166], points := ![93,94,96,109,139,140], inverse := ![5,4,8,14,2,4,2,10,6,9,6,1,14,9,7,0,0,0,7,14,6,8,2,5,2,5,7,0,13,13,14,14,0,0,14,14] } }
theorem leafL_190_5_valid : (leafL_190_5).reject.ValidFor (leafL_190_5).leaf := by decide

noncomputable def leafL_190_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,120,172}, reject := .fullRank { members := ![0,1,17,34,52,71,120,172], points := ![91,93,94,131,133,147], inverse := ![2,4,14,9,10,10,13,1,10,9,0,15,1,7,6,0,0,0,12,4,12,13,11,2,4,3,7,5,5,0,12,12,0,12,12,0] } }
theorem leafL_190_6_valid : (leafL_190_6).reject.ValidFor (leafL_190_6).leaf := by decide

noncomputable def leafL_190_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,120,174}, reject := .fullRank { members := ![0,1,17,34,52,71,120,174], points := ![93,99,109,131,138,140], inverse := ![9,3,13,11,0,13,14,0,9,11,5,9,0,0,0,10,11,1,15,10,2,13,14,4,0,13,13,13,2,15,0,8,8,9,2,11] } }
theorem leafL_190_7_valid : (leafL_190_7).reject.ValidFor (leafL_190_7).leaf := by decide

noncomputable def leavesL_190 : List RejectedLeaf := [leafL_190_0,leafL_190_1,leafL_190_2,leafL_190_3,leafL_190_4,leafL_190_5,leafL_190_6,leafL_190_7]

theorem leavesL_190_valid : LeafListValid leavesL_190 := by
  intro x hx
  simp only [leavesL_190, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_190_0_valid
  · exact leafL_190_1_valid
  · exact leafL_190_2_valid
  · exact leafL_190_3_valid
  · exact leafL_190_4_valid
  · exact leafL_190_5_valid
  · exact leafL_190_6_valid
  · exact leafL_190_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
