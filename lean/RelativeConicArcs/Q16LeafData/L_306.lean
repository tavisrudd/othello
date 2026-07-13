import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_306_0 : RejectedLeaf := { leaf := {0,1,17,34,52,74,147,222}, reject := .fullRank { members := ![0,1,17,34,52,74,147,222], points := ![92,108,124,137,143,167], inverse := ![15,6,10,11,12,5,9,14,7,0,0,0,8,8,8,12,4,0,5,0,4,6,10,13,7,4,14,12,3,2,12,6,15,13,4,12] } }
theorem leafL_306_0_valid : (leafL_306_0).reject.ValidFor (leafL_306_0).leaf := by decide

noncomputable def leafL_306_1 : RejectedLeaf := { leaf := {0,1,17,34,52,74,151,172}, reject := .fullRank { members := ![0,1,17,34,52,74,151,172], points := ![93,95,107,110,115,120], inverse := ![5,10,5,13,10,12,13,4,4,10,6,1,6,6,5,5,10,10,14,6,10,5,10,13,6,6,9,9,4,4,4,4,4,4,4,4] } }
theorem leafL_306_1_valid : (leafL_306_1).reject.ValidFor (leafL_306_1).leaf := by decide

noncomputable def leafL_306_2 : RejectedLeaf := { leaf := {0,1,17,34,52,74,151,235}, reject := .fullRank { members := ![0,1,17,34,52,74,151,235], points := ![93,95,108,110,112,120], inverse := ![3,12,5,2,15,6,15,6,15,0,1,7,0,0,5,10,15,0,8,0,0,3,12,7,11,11,10,5,15,0,9,9,0,9,9,0] } }
theorem leafL_306_2_valid : (leafL_306_2).reject.ValidFor (leafL_306_2).leaf := by decide

noncomputable def leafL_306_3 : RejectedLeaf := { leaf := {0,1,17,34,52,74,155,172}, reject := .fullRank { members := ![0,1,17,34,52,74,155,172], points := ![93,95,109,115,120,125], inverse := ![5,10,8,9,9,6,9,0,14,0,0,7,0,0,0,14,1,15,11,3,15,1,14,8,8,8,0,1,9,8,13,13,0,10,6,12] } }
theorem leafL_306_3_valid : (leafL_306_3).reject.ValidFor (leafL_306_3).leaf := by decide

noncomputable def leafL_306_4 : RejectedLeaf := { leaf := {0,1,17,34,52,74,155,181}, reject := .fullRank { members := ![0,1,17,34,52,74,155,181], points := ![94,95,108,109,120,124], inverse := ![14,1,10,2,7,1,12,5,11,5,14,9,6,6,14,14,9,9,6,14,9,6,4,3,3,3,11,11,0,0,5,5,11,11,2,2] } }
theorem leafL_306_4_valid : (leafL_306_4).reject.ValidFor (leafL_306_4).leaf := by decide

noncomputable def leafL_306_5 : RejectedLeaf := { leaf := {0,1,17,34,52,74,155,216}, reject := .fullRank { members := ![0,1,17,34,52,74,155,216], points := ![89,92,101,109,117,124], inverse := ![10,5,10,2,6,0,3,10,12,2,11,12,2,2,9,9,3,3,15,7,5,10,13,10,2,2,4,4,8,8,11,11,3,3,14,14] } }
theorem leafL_306_5_valid : (leafL_306_5).reject.ValidFor (leafL_306_5).leaf := by decide

noncomputable def leafL_306_6 : RejectedLeaf := { leaf := {0,1,17,34,52,74,155,231}, reject := .fullRank { members := ![0,1,17,34,52,74,155,231], points := ![89,92,93,104,108,115], inverse := ![10,6,3,1,9,6,7,5,11,3,13,7,10,2,8,0,0,0,2,10,0,1,14,7,11,4,15,14,14,0,2,3,1,10,10,0] } }
theorem leafL_306_6_valid : (leafL_306_6).reject.ValidFor (leafL_306_6).leaf := by decide

noncomputable def leafL_306_7 : RejectedLeaf := { leaf := {0,1,17,34,52,74,155,256}, reject := .fullRank { members := ![0,1,17,34,52,74,155,256], points := ![92,93,95,104,108,115], inverse := ![11,8,12,1,9,6,12,14,11,3,13,7,15,3,12,0,0,0,12,9,13,1,14,7,10,9,3,14,14,0,5,8,13,10,10,0] } }
theorem leafL_306_7_valid : (leafL_306_7).reject.ValidFor (leafL_306_7).leaf := by decide

noncomputable def leavesL_306 : List RejectedLeaf := [leafL_306_0,leafL_306_1,leafL_306_2,leafL_306_3,leafL_306_4,leafL_306_5,leafL_306_6,leafL_306_7]

theorem leavesL_306_valid : LeafListValid leavesL_306 := by
  intro x hx
  simp only [leavesL_306, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_306_0_valid
  · exact leafL_306_1_valid
  · exact leafL_306_2_valid
  · exact leafL_306_3_valid
  · exact leafL_306_4_valid
  · exact leafL_306_5_valid
  · exact leafL_306_6_valid
  · exact leafL_306_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
