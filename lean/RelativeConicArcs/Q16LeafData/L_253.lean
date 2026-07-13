import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_253_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,94,122}, reject := .fullRank { members := ![0,1,17,34,52,72,94,122], points := ![107,108,135,137,143,149], inverse := ![0,9,4,6,15,5,13,15,15,11,0,6,0,0,2,9,11,0,5,8,6,5,2,12,10,10,10,15,5,0,9,9,7,15,8,0] } }
theorem leafL_253_0_valid : (leafL_253_0).reject.ValidFor (leafL_253_0).leaf := by decide

noncomputable def leafL_253_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,94,135}, reject := .fullRank { members := ![0,1,17,34,52,72,94,135], points := ![99,108,122,128,149,150], inverse := ![4,8,2,12,9,10,12,1,11,10,9,5,12,12,4,4,13,13,14,4,0,13,10,13,9,9,3,3,6,6,6,6,11,11,12,12] } }
theorem leafL_253_1_valid : (leafL_253_1).reject.ValidFor (leafL_253_1).leaf := by decide

noncomputable def leafL_253_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,94,151}, reject := .fullRank { members := ![0,1,17,34,52,72,94,151], points := ![99,108,128,143,166,172], inverse := ![4,7,6,13,1,8,11,12,14,9,13,13,11,5,12,7,3,6,1,2,0,10,4,13,5,7,14,1,6,11,9,8,7,9,8,7] } }
theorem leafL_253_2_valid : (leafL_253_2).reject.ValidFor (leafL_253_2).leaf := by decide

noncomputable def leafL_253_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,94,169}, reject := .fullRank { members := ![0,1,17,34,52,72,94,169], points := ![103,108,124,128,143,144], inverse := ![5,2,14,7,1,14,12,11,6,8,7,14,15,15,10,10,9,9,8,15,8,7,11,3,14,14,0,0,11,11,6,6,9,9,10,10] } }
theorem leafL_253_3_valid : (leafL_253_3).reject.ValidFor (leafL_253_3).leaf := by decide

noncomputable def leafL_253_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,94,172}, reject := .fullRank { members := ![0,1,17,34,52,72,94,172], points := ![107,122,128,135,151,185], inverse := ![7,14,5,10,10,13,15,0,7,13,3,6,15,13,9,5,8,6,10,11,12,2,3,12,4,4,3,0,12,15,0,4,6,5,10,13] } }
theorem leafL_253_4_valid : (leafL_253_4).reject.ValidFor (leafL_253_4).leaf := by decide

noncomputable def leafL_253_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,94,185}, reject := .fullRank { members := ![0,1,17,34,52,72,94,185], points := ![103,149,151,172,176,197], inverse := ![10,15,0,6,8,10,15,1,8,14,1,9,10,10,1,7,3,5,0,13,2,4,12,7,3,14,10,4,11,8,9,0,15,12,7,13] } }
theorem leafL_253_5_valid : (leafL_253_5).reject.ValidFor (leafL_253_5).leaf := by decide

noncomputable def leafL_253_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,94,188}, reject := .fullRank { members := ![0,1,17,34,52,72,94,188], points := ![103,107,112,122,128,137], inverse := ![3,6,2,7,14,15,0,15,8,2,12,9,7,2,5,0,0,0,11,14,2,14,1,8,0,5,5,9,9,0,7,10,13,12,12,0] } }
theorem leafL_253_6_valid : (leafL_253_6).reject.ValidFor (leafL_253_6).leaf := by decide

noncomputable def leafL_253_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,94,197}, reject := .fullRank { members := ![0,1,17,34,52,72,94,197], points := ![99,103,107,122,128,137], inverse := ![8,10,5,7,14,15,6,2,3,2,12,9,7,11,12,0,0,0,8,2,13,14,1,8,7,12,11,9,9,0,1,9,8,12,12,0] } }
theorem leafL_253_7_valid : (leafL_253_7).reject.ValidFor (leafL_253_7).leaf := by decide

noncomputable def leavesL_253 : List RejectedLeaf := [leafL_253_0,leafL_253_1,leafL_253_2,leafL_253_3,leafL_253_4,leafL_253_5,leafL_253_6,leafL_253_7]

theorem leavesL_253_valid : LeafListValid leavesL_253 := by
  intro x hx
  simp only [leavesL_253, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_253_0_valid
  · exact leafL_253_1_valid
  · exact leafL_253_2_valid
  · exact leafL_253_3_valid
  · exact leafL_253_4_valid
  · exact leafL_253_5_valid
  · exact leafL_253_6_valid
  · exact leafL_253_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
