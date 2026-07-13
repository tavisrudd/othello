import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_262_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,115,190}, reject := .fullRank { members := ![0,1,17,34,52,72,115,190], points := ![96,101,107,135,139,150], inverse := ![7,8,13,12,9,6,2,13,0,12,2,1,5,12,15,12,14,4,0,7,10,14,15,12,1,0,14,15,10,10,5,4,7,9,11,4] } }
theorem leafL_262_0_valid : (leafL_262_0).reject.ValidFor (leafL_262_0).leaf := by decide

noncomputable def leafL_262_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,115,203}, reject := .fullRank { members := ![0,1,17,34,52,72,115,203], points := ![90,93,96,108,143,150], inverse := ![0,13,1,13,4,4,13,10,10,8,8,13,4,8,12,0,0,0,9,15,9,8,7,0,9,15,15,7,11,5,12,11,8,5,6,12] } }
theorem leafL_262_1_valid : (leafL_262_1).reject.ValidFor (leafL_262_1).leaf := by decide

noncomputable def leafL_262_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,115,207}, reject := .fullRank { members := ![0,1,17,34,52,72,115,207], points := ![90,91,101,107,108,135], inverse := ![8,1,6,5,13,6,13,3,11,12,14,7,0,0,11,3,8,0,11,4,15,14,9,7,3,3,9,10,3,0,14,14,5,7,2,0] } }
theorem leafL_262_2_valid : (leafL_262_2).reject.ValidFor (leafL_262_2).leaf := by decide

noncomputable def leafL_262_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,115,237}, reject := .fullRank { members := ![0,1,17,34,52,72,115,237], points := ![90,91,96,107,138,150], inverse := ![15,11,1,10,15,1,4,15,3,11,10,9,12,8,4,0,0,0,3,0,4,1,9,15,1,6,4,1,15,13,2,4,2,13,7,14] } }
theorem leafL_262_3_valid : (leafL_262_3).reject.ValidFor (leafL_262_3).leaf := by decide

noncomputable def leafL_262_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,122,143}, reject := .fullRank { members := ![0,1,17,34,52,72,122,143], points := ![83,92,94,112,147,151], inverse := ![8,6,8,11,4,8,13,0,7,4,5,11,3,14,13,0,0,0,8,13,14,5,6,8,8,12,4,0,10,10,9,15,6,0,11,11] } }
theorem leafL_262_4_valid : (leafL_262_4).reject.ValidFor (leafL_262_4).leaf := by decide

noncomputable def leafL_262_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,122,147}, reject := .fullRank { members := ![0,1,17,34,52,72,122,147], points := ![92,96,112,137,143,172], inverse := ![4,3,2,15,6,13,3,10,15,2,11,15,9,15,1,15,3,11,10,11,4,6,14,13,12,4,13,2,1,6,4,0,15,6,14,3] } }
theorem leafL_262_5_valid : (leafL_262_5).reject.ValidFor (leafL_262_5).leaf := by decide

noncomputable def leafL_262_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,122,150}, reject := .fullRank { members := ![0,1,17,34,52,72,122,150], points := ![83,94,107,108,135,139], inverse := ![9,0,0,14,0,6,5,11,6,15,4,3,8,8,8,8,5,5,0,15,10,2,5,2,13,13,7,7,10,10,1,1,8,8,3,3] } }
theorem leafL_262_6_valid : (leafL_262_6).reject.ValidFor (leafL_262_6).leaf := by decide

noncomputable def leafL_262_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,122,151}, reject := .fullRank { members := ![0,1,17,34,52,72,122,151], points := ![92,108,139,143,172,173], inverse := ![15,15,4,14,5,14,4,10,0,0,14,0,12,2,13,6,5,0,9,9,7,12,9,2,15,11,1,12,10,3,9,10,8,9,8,10] } }
theorem leafL_262_7_valid : (leafL_262_7).reject.ValidFor (leafL_262_7).leaf := by decide

noncomputable def leavesL_262 : List RejectedLeaf := [leafL_262_0,leafL_262_1,leafL_262_2,leafL_262_3,leafL_262_4,leafL_262_5,leafL_262_6,leafL_262_7]

theorem leavesL_262_valid : LeafListValid leavesL_262 := by
  intro x hx
  simp only [leavesL_262, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_262_0_valid
  · exact leafL_262_1_valid
  · exact leafL_262_2_valid
  · exact leafL_262_3_valid
  · exact leafL_262_4_valid
  · exact leafL_262_5_valid
  · exact leafL_262_6_valid
  · exact leafL_262_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
