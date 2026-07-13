import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_034_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,198}, reject := .fullRank { members := ![0,1,17,34,52,69,92,198], points := ![104,126,127,131,135,137], inverse := ![7,8,1,5,2,8,7,12,2,4,0,13,0,0,0,3,4,7,7,7,8,6,2,12,0,12,12,14,0,14,0,14,14,4,2,6] } }
theorem leafL_034_0_valid : (leafL_034_0).reject.ValidFor (leafL_034_0).leaf := by decide

noncomputable def leafL_034_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,201}, reject := .fullRank { members := ![0,1,17,34,52,69,92,201], points := ![99,104,122,126,138,139], inverse := ![3,4,10,3,13,2,9,14,4,10,14,7,3,3,14,14,15,15,4,3,12,3,4,12,15,15,6,6,4,4,9,9,1,1,5,5] } }
theorem leafL_034_1_valid : (leafL_034_1).reject.ValidFor (leafL_034_1).leaf := by decide

noncomputable def leafL_034_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,203}, reject := .fullRank { members := ![0,1,17,34,52,69,92,203], points := ![99,122,126,127,131,137], inverse := ![7,0,9,0,0,15,7,4,8,2,9,0,0,8,10,2,0,0,7,0,6,9,3,11,0,0,12,12,14,14,0,4,11,15,12,12] } }
theorem leafL_034_2_valid : (leafL_034_2).reject.ValidFor (leafL_034_2).leaf := by decide

noncomputable def leafL_034_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,207}, reject := .fullRank { members := ![0,1,17,34,52,69,92,207], points := ![99,122,131,135,141,152], inverse := ![8,8,10,8,9,10,14,10,10,12,12,14,0,0,4,3,7,0,9,6,2,5,13,5,12,10,15,7,6,8,14,9,6,7,3,5] } }
theorem leafL_034_3_valid : (leafL_034_3).reject.ValidFor (leafL_034_3).leaf := by decide

noncomputable def leafL_034_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,211}, reject := .fullRank { members := ![0,1,17,34,52,69,92,211], points := ![104,122,126,127,137,138], inverse := ![7,0,8,1,4,11,7,12,3,1,7,14,0,8,10,2,0,0,7,5,14,4,14,6,0,1,0,1,6,6,0,3,9,10,1,1] } }
theorem leafL_034_4_valid : (leafL_034_4).reject.ValidFor (leafL_034_4).leaf := by decide

noncomputable def leafL_034_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,214}, reject := .fullRank { members := ![0,1,17,34,52,69,92,214], points := ![99,107,122,127,135,137], inverse := ![12,11,7,14,8,7,6,1,1,15,1,8,4,4,14,14,13,13,14,9,12,3,3,11,3,3,12,12,11,11,2,2,1,1,12,12] } }
theorem leafL_034_5_valid : (leafL_034_5).reject.ValidFor (leafL_034_5).leaf := by decide

noncomputable def leafL_034_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,240}, reject := .fullRank { members := ![0,1,17,34,52,69,92,240], points := ![99,104,122,127,131,137], inverse := ![12,11,9,0,7,8,9,14,12,2,0,9,4,4,2,2,6,6,10,13,6,9,1,9,9,9,12,12,10,10,1,1,15,15,4,4] } }
theorem leafL_034_6_valid : (leafL_034_6).reject.ValidFor (leafL_034_6).leaf := by decide

noncomputable def leafL_034_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,247}, reject := .fullRank { members := ![0,1,17,34,52,69,92,247], points := ![99,104,107,127,137,139], inverse := ![4,9,10,9,9,6,6,14,15,14,1,8,3,10,9,0,0,0,6,1,0,15,9,1,1,8,9,0,12,12,1,4,5,0,13,13] } }
theorem leafL_034_7_valid : (leafL_034_7).reject.ValidFor (leafL_034_7).leaf := by decide

noncomputable def leavesL_034 : List RejectedLeaf := [leafL_034_0,leafL_034_1,leafL_034_2,leafL_034_3,leafL_034_4,leafL_034_5,leafL_034_6,leafL_034_7]

theorem leavesL_034_valid : LeafListValid leavesL_034 := by
  intro x hx
  simp only [leavesL_034, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_034_0_valid
  · exact leafL_034_1_valid
  · exact leafL_034_2_valid
  · exact leafL_034_3_valid
  · exact leafL_034_4_valid
  · exact leafL_034_5_valid
  · exact leafL_034_6_valid
  · exact leafL_034_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
