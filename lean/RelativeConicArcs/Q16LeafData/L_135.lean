import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_135_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,237}, reject := .fullRank { members := ![0,1,17,34,52,70,94,237], points := ![103,104,107,127,133,144], inverse := ![9,9,7,9,8,7,2,3,6,14,11,2,10,4,14,0,0,0,0,6,1,15,6,14,7,6,1,0,1,1,13,14,3,0,11,11] } }
theorem leafL_135_0_valid : (leafL_135_0).reject.ValidFor (leafL_135_0).leaf := by decide

noncomputable def leafL_135_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,239}, reject := .fullRank { members := ![0,1,17,34,52,70,94,239], points := ![103,107,122,125,133,140], inverse := ![12,11,6,15,6,9,11,12,9,7,2,11,11,11,12,12,6,6,6,1,11,4,11,3,13,13,11,11,11,11,2,2,10,10,1,1] } }
theorem leafL_135_1_valid : (leafL_135_1).reject.ValidFor (leafL_135_1).leaf := by decide

noncomputable def leafL_135_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,240}, reject := .fullRank { members := ![0,1,17,34,52,70,94,240], points := ![101,103,104,124,125,137], inverse := ![8,3,12,3,10,15,2,13,8,8,6,9,7,9,14,0,0,0,9,10,4,0,15,8,4,14,10,10,10,0,14,15,1,2,2,0] } }
theorem leafL_135_2_valid : (leafL_135_2).reject.ValidFor (leafL_135_2).leaf := by decide

noncomputable def leafL_135_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,243}, reject := .fullRank { members := ![0,1,17,34,52,70,94,243], points := ![101,103,104,122,124,133], inverse := ![4,13,14,1,8,15,5,6,4,11,5,9,7,9,14,0,0,0,12,3,8,10,5,8,15,0,15,8,8,0,7,7,0,7,7,0] } }
theorem leafL_135_3_valid : (leafL_135_3).reject.ValidFor (leafL_135_3).leaf := by decide

noncomputable def leafL_135_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,248}, reject := .fullRank { members := ![0,1,17,34,52,70,94,248], points := ![101,107,125,133,135,137], inverse := ![0,7,9,13,9,11,3,4,14,6,7,8,0,0,0,5,8,13,9,14,15,5,8,5,13,13,0,3,7,4,8,8,0,0,8,8] } }
theorem leafL_135_4_valid : (leafL_135_4).reject.ValidFor (leafL_135_4).leaf := by decide

noncomputable def leafL_135_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,249}, reject := .fullRank { members := ![0,1,17,34,52,70,94,249], points := ![103,104,107,122,135,140], inverse := ![7,13,13,9,4,11,15,4,12,14,4,13,10,4,14,0,0,0,4,4,7,15,13,5,11,15,4,0,10,10,0,2,2,0,2,2] } }
theorem leafL_135_5_valid : (leafL_135_5).reject.ValidFor (leafL_135_5).leaf := by decide

noncomputable def leafL_135_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,251}, reject := .fullRank { members := ![0,1,17,34,52,70,94,251], points := ![101,104,124,125,133,135], inverse := ![11,12,13,4,14,1,6,1,4,10,2,11,3,3,9,9,14,14,12,11,9,6,3,11,13,13,4,4,5,5,15,15,13,13,10,10] } }
theorem leafL_135_6_valid : (leafL_135_6).reject.ValidFor (leafL_135_6).leaf := by decide

noncomputable def leafL_135_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,256}, reject := .fullRank { members := ![0,1,17,34,52,70,94,256], points := ![108,109,122,127,133,140], inverse := ![8,15,9,0,8,7,15,8,9,7,6,15,13,13,9,9,1,1,1,6,4,11,12,4,9,9,0,0,7,7,2,2,2,2,0,0] } }
theorem leafL_135_7_valid : (leafL_135_7).reject.ValidFor (leafL_135_7).leaf := by decide

noncomputable def leavesL_135 : List RejectedLeaf := [leafL_135_0,leafL_135_1,leafL_135_2,leafL_135_3,leafL_135_4,leafL_135_5,leafL_135_6,leafL_135_7]

theorem leavesL_135_valid : LeafListValid leavesL_135 := by
  intro x hx
  simp only [leavesL_135, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_135_0_valid
  · exact leafL_135_1_valid
  · exact leafL_135_2_valid
  · exact leafL_135_3_valid
  · exact leafL_135_4_valid
  · exact leafL_135_5_valid
  · exact leafL_135_6_valid
  · exact leafL_135_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
