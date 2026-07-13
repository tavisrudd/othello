import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_153_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,127,147}, reject := .fullRank { members := ![0,1,17,34,52,70,127,147], points := ![90,91,101,108,110,133], inverse := ![0,9,1,5,10,6,8,6,3,8,2,7,0,0,3,13,14,0,14,1,6,9,7,7,3,3,12,14,2,0,14,14,15,11,4,0] } }
theorem leafL_153_0_valid : (leafL_153_0).reject.ValidFor (leafL_153_0).leaf := by decide

noncomputable def leafL_153_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,127,152}, reject := .fullRank { members := ![0,1,17,34,52,70,127,152], points := ![83,90,107,110,137,141], inverse := ![6,15,3,13,7,1,4,10,8,1,14,9,12,12,12,12,7,7,14,1,1,9,13,10,6,6,15,15,12,12,10,10,9,9,2,2] } }
theorem leafL_153_1_valid : (leafL_153_1).reject.ValidFor (leafL_153_1).leaf := by decide

noncomputable def leafL_153_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,127,171}, reject := .fullRank { members := ![0,1,17,34,52,70,127,171], points := ![90,94,108,109,133,141], inverse := ![14,7,1,15,10,12,9,7,9,0,4,3,1,1,7,7,13,13,5,10,9,1,13,10,4,4,6,6,2,2,14,14,15,15,4,4] } }
theorem leafL_153_2_valid : (leafL_153_2).reject.ValidFor (leafL_153_2).leaf := by decide

noncomputable def leafL_153_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,127,186}, reject := .fullRank { members := ![0,1,17,34,52,70,127,186], points := ![91,101,104,133,135,137], inverse := ![9,15,1,2,15,11,14,5,12,5,9,11,0,0,0,5,8,13,15,12,4,8,3,12,0,6,6,2,0,2,0,7,7,6,9,15] } }
theorem leafL_153_3_valid : (leafL_153_3).reject.ValidFor (leafL_153_3).leaf := by decide

noncomputable def leafL_153_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,127,195}, reject := .fullRank { members := ![0,1,17,34,52,70,127,195], points := ![89,91,94,104,108,133], inverse := ![2,0,11,9,7,6,3,5,8,6,15,7,12,3,15,0,0,0,11,15,11,4,12,7,3,9,10,14,14,0,13,8,5,10,10,0] } }
theorem leafL_153_4_valid : (leafL_153_4).reject.ValidFor (leafL_153_4).leaf := by decide

noncomputable def leafL_153_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,127,202}, reject := .fullRank { members := ![0,1,17,34,52,70,127,202], points := ![94,101,104,107,135,141], inverse := ![9,15,8,9,0,6,14,12,13,8,2,5,0,1,13,12,0,0,15,4,9,5,10,13,0,9,1,8,13,13,0,10,9,3,6,6] } }
theorem leafL_153_5_valid : (leafL_153_5).reject.ValidFor (leafL_153_5).leaf := by decide

noncomputable def leafL_153_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,127,237}, reject := .fullRank { members := ![0,1,17,34,52,70,127,237], points := ![83,91,94,104,107,140], inverse := ![2,4,15,3,13,6,4,15,5,2,11,7,1,4,5,0,0,0,12,1,2,12,4,7,9,15,6,3,3,0,10,8,2,4,4,0] } }
theorem leafL_153_6_valid : (leafL_153_6).reject.ValidFor (leafL_153_6).leaf := by decide

noncomputable def leafL_153_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,127,240}, reject := .fullRank { members := ![0,1,17,34,52,70,127,240], points := ![89,90,94,101,104,137], inverse := ![12,3,6,1,15,6,4,1,11,11,2,7,11,13,6,0,0,0,4,15,4,7,15,7,9,10,3,13,13,0,4,8,12,14,14,0] } }
theorem leafL_153_7_valid : (leafL_153_7).reject.ValidFor (leafL_153_7).leaf := by decide

noncomputable def leavesL_153 : List RejectedLeaf := [leafL_153_0,leafL_153_1,leafL_153_2,leafL_153_3,leafL_153_4,leafL_153_5,leafL_153_6,leafL_153_7]

theorem leavesL_153_valid : LeafListValid leavesL_153 := by
  intro x hx
  simp only [leavesL_153, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_153_0_valid
  · exact leafL_153_1_valid
  · exact leafL_153_2_valid
  · exact leafL_153_3_valid
  · exact leafL_153_4_valid
  · exact leafL_153_5_valid
  · exact leafL_153_6_valid
  · exact leafL_153_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
