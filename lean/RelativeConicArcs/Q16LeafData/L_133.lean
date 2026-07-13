import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_133_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,135}, reject := .fullRank { members := ![0,1,17,34,52,70,94,135], points := ![104,108,109,122,124,185], inverse := ![1,3,15,11,0,7,5,10,6,5,3,15,4,9,13,0,0,0,2,1,5,11,15,2,6,8,14,8,8,0,12,10,6,7,7,0] } }
theorem leafL_133_0_valid : (leafL_133_0).reject.ValidFor (leafL_133_0).leaf := by decide

noncomputable def leafL_133_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,137}, reject := .fullRank { members := ![0,1,17,34,52,70,94,137], points := ![101,103,107,122,125,152], inverse := ![11,4,3,11,5,3,5,11,3,9,8,12,8,5,13,0,0,0,1,5,14,2,15,7,6,0,6,14,14,0,13,14,3,8,8,0] } }
theorem leafL_133_1_valid : (leafL_133_1).reject.ValidFor (leafL_133_1).leaf := by decide

noncomputable def leafL_133_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,140}, reject := .fullRank { members := ![0,1,17,34,52,70,94,140], points := ![101,104,107,127,167,176], inverse := ![10,10,10,12,7,0,13,4,15,9,13,2,1,13,12,0,0,0,0,7,3,6,8,10,14,13,3,0,8,8,14,4,10,0,7,7] } }
theorem leafL_133_2_valid : (leafL_133_2).reject.ValidFor (leafL_133_2).leaf := by decide

noncomputable def leafL_133_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,144}, reject := .fullRank { members := ![0,1,17,34,52,70,94,144], points := ![108,109,122,125,127,167], inverse := ![11,1,1,10,7,7,3,5,15,14,8,15,0,0,15,12,3,0,14,10,9,15,0,2,12,12,1,2,3,0,2,2,2,0,2,0] } }
theorem leafL_133_3_valid : (leafL_133_3).reject.ValidFor (leafL_133_3).leaf := by decide

noncomputable def leafL_133_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,152}, reject := .fullRank { members := ![0,1,17,34,52,70,94,152], points := ![103,107,122,124,125,137], inverse := ![11,12,11,5,7,15,6,1,8,10,12,9,0,0,12,3,15,0,3,4,8,2,5,8,7,7,11,12,7,0,6,6,10,9,3,0] } }
theorem leafL_133_4_valid : (leafL_133_4).reject.ValidFor (leafL_133_4).leaf := by decide

noncomputable def leafL_133_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,171}, reject := .fullRank { members := ![0,1,17,34,52,70,94,171], points := ![101,103,108,125,127,133], inverse := ![4,14,13,13,4,15,0,10,13,3,13,9,4,2,6,0,0,0,6,8,9,9,6,8,9,5,12,8,8,0,7,7,0,7,7,0] } }
theorem leafL_133_5_valid : (leafL_133_5).reject.ValidFor (leafL_133_5).leaf := by decide

noncomputable def leafL_133_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,172}, reject := .fullRank { members := ![0,1,17,34,52,70,94,172], points := ![104,107,109,122,125,133], inverse := ![15,1,9,7,14,15,8,3,12,12,2,9,7,15,8,0,0,0,9,2,12,13,2,8,9,12,5,14,14,0,7,3,4,8,8,0] } }
theorem leafL_133_6_valid : (leafL_133_6).reject.ValidFor (leafL_133_6).leaf := by decide

noncomputable def leafL_133_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,176}, reject := .fullRank { members := ![0,1,17,34,52,70,94,176], points := ![101,104,107,124,125,133], inverse := ![13,13,7,5,12,15,9,10,4,3,13,9,1,13,12,0,0,0,3,0,4,14,1,8,0,8,8,10,10,0,6,5,3,2,2,0] } }
theorem leafL_133_7_valid : (leafL_133_7).reject.ValidFor (leafL_133_7).leaf := by decide

noncomputable def leavesL_133 : List RejectedLeaf := [leafL_133_0,leafL_133_1,leafL_133_2,leafL_133_3,leafL_133_4,leafL_133_5,leafL_133_6,leafL_133_7]

theorem leavesL_133_valid : LeafListValid leavesL_133 := by
  intro x hx
  simp only [leavesL_133, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_133_0_valid
  · exact leafL_133_1_valid
  · exact leafL_133_2_valid
  · exact leafL_133_3_valid
  · exact leafL_133_4_valid
  · exact leafL_133_5_valid
  · exact leafL_133_6_valid
  · exact leafL_133_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
