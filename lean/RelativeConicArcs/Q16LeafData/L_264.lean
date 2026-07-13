import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_264_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,122,229}, reject := .fullRank { members := ![0,1,17,34,52,72,122,229], points := ![94,108,135,137,143,147], inverse := ![3,8,4,10,12,8,7,14,5,5,12,5,0,0,2,9,11,0,12,9,5,7,10,13,3,1,12,13,14,13,10,6,0,3,7,8] } }
theorem leafL_264_0_valid : (leafL_264_0).reject.ValidFor (leafL_264_0).leaf := by decide

noncomputable def leafL_264_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,122,237}, reject := .fullRank { members := ![0,1,17,34,52,72,122,237], points := ![83,96,107,144,147,149], inverse := ![13,9,4,10,11,0,13,10,14,12,2,7,14,3,10,12,6,13,11,2,10,10,12,5,10,6,4,9,1,0,1,8,7,11,15,10] } }
theorem leafL_264_1_valid : (leafL_264_1).reject.ValidFor (leafL_264_1).leaf := by decide

noncomputable def leafL_264_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,122,240}, reject := .fullRank { members := ![0,1,17,34,52,72,122,240], points := ![92,94,137,143,150,151], inverse := ![15,7,13,14,2,8,8,14,2,11,15,0,7,7,3,3,8,8,0,4,13,11,12,14,3,3,15,15,5,5,12,12,12,12,0,0] } }
theorem leafL_264_2_valid : (leafL_264_2).reject.ValidFor (leafL_264_2).leaf := by decide

noncomputable def leafL_264_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,122,249}, reject := .fullRank { members := ![0,1,17,34,52,72,122,249], points := ![83,92,107,112,143,144], inverse := ![7,14,0,14,7,1,11,5,7,14,9,14,6,6,9,9,8,8,13,2,9,1,13,10,4,4,12,12,10,10,12,12,13,13,10,10] } }
theorem leafL_264_3_valid : (leafL_264_3).reject.ValidFor (leafL_264_3).leaf := by decide

noncomputable def leafL_264_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,122,251}, reject := .fullRank { members := ![0,1,17,34,52,72,122,251], points := ![83,92,96,135,137,149], inverse := ![1,7,14,10,9,10,5,4,7,10,3,15,8,9,1,0,0,0,12,1,9,5,3,2,1,13,12,4,4,0,5,9,12,1,1,0] } }
theorem leafL_264_4_valid : (leafL_264_4).reject.ValidFor (leafL_264_4).leaf := by decide

noncomputable def leafL_264_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,122,263}, reject := .fullRank { members := ![0,1,17,34,52,72,122,263], points := ![92,94,96,107,108,139], inverse := ![4,6,11,0,14,6,11,13,8,9,0,7,5,10,15,0,0,0,9,7,1,2,10,7,3,13,14,4,4,0,15,4,11,1,1,0] } }
theorem leafL_264_5_valid : (leafL_264_5).reject.ValidFor (leafL_264_5).leaf := by decide

noncomputable def leafL_264_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,125,138}, reject := .fullRank { members := ![0,1,17,34,52,72,125,138], points := ![91,92,99,103,108,147], inverse := ![9,15,1,1,11,12,5,15,3,14,9,14,0,0,9,1,8,0,14,5,12,9,0,14,5,5,2,7,5,0,1,1,6,8,14,0] } }
theorem leafL_264_6_valid : (leafL_264_6).reject.ValidFor (leafL_264_6).leaf := by decide

noncomputable def leafL_264_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,125,147}, reject := .fullRank { members := ![0,1,17,34,52,72,125,147], points := ![91,92,103,137,138,166], inverse := ![1,10,0,7,5,8,10,9,12,8,6,1,0,9,10,6,7,2,5,15,0,0,13,7,12,5,10,11,10,2,14,14,0,14,14,0] } }
theorem leafL_264_7_valid : (leafL_264_7).reject.ValidFor (leafL_264_7).leaf := by decide

noncomputable def leavesL_264 : List RejectedLeaf := [leafL_264_0,leafL_264_1,leafL_264_2,leafL_264_3,leafL_264_4,leafL_264_5,leafL_264_6,leafL_264_7]

theorem leavesL_264_valid : LeafListValid leavesL_264 := by
  intro x hx
  simp only [leavesL_264, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_264_0_valid
  · exact leafL_264_1_valid
  · exact leafL_264_2_valid
  · exact leafL_264_3_valid
  · exact leafL_264_4_valid
  · exact leafL_264_5_valid
  · exact leafL_264_6_valid
  · exact leafL_264_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
