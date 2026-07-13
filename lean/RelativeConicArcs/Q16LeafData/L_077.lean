import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_077_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,173}, reject := .fullRank { members := ![0,1,17,34,52,69,112,173], points := ![89,94,95,122,126,131], inverse := ![4,5,6,13,3,8,7,1,1,10,3,14,4,8,12,0,0,0,4,9,10,0,8,15,1,3,2,9,9,0,14,8,6,15,15,0] } }
theorem leafL_077_0_valid : (leafL_077_0).reject.ValidFor (leafL_077_0).leaf := by decide

noncomputable def leafL_077_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,182}, reject := .fullRank { members := ![0,1,17,34,52,69,112,182], points := ![94,95,122,124,135,151], inverse := ![9,4,5,14,11,12,1,3,13,15,6,6,2,6,13,15,15,9,8,9,11,0,14,4,3,7,12,14,15,9,6,4,2,3,14,13] } }
theorem leafL_077_1_valid : (leafL_077_1).reject.ValidFor (leafL_077_1).leaf := by decide

noncomputable def leafL_077_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,189}, reject := .fullRank { members := ![0,1,17,34,52,69,112,189], points := ![95,120,122,131,135,151], inverse := ![11,8,0,15,5,8,14,3,7,13,9,14,7,11,1,15,9,11,15,4,8,1,3,1,6,13,14,3,2,4,3,1,9,1,8,2] } }
theorem leafL_077_2_valid : (leafL_077_2).reject.ValidFor (leafL_077_2).leaf := by decide

noncomputable def leafL_077_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,198}, reject := .fullRank { members := ![0,1,17,34,52,69,112,198], points := ![90,91,95,120,126,131], inverse := ![0,1,6,12,2,8,0,9,14,4,13,14,2,10,8,0,0,0,3,11,15,0,8,15,5,6,3,11,11,0,14,12,2,6,6,0] } }
theorem leafL_077_3_valid : (leafL_077_3).reject.ValidFor (leafL_077_3).leaf := by decide

noncomputable def leafL_077_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,203}, reject := .fullRank { members := ![0,1,17,34,52,69,112,203], points := ![89,90,95,122,141,152], inverse := ![15,9,9,10,5,1,7,7,12,5,10,3,7,6,1,0,0,0,0,4,11,12,2,1,15,12,1,1,14,13,15,6,0,13,10,14] } }
theorem leafL_077_4_valid : (leafL_077_4).reject.ValidFor (leafL_077_4).leaf := by decide

noncomputable def leafL_077_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,211}, reject := .fullRank { members := ![0,1,17,34,52,69,112,211], points := ![91,94,95,122,124,139], inverse := ![12,12,7,13,3,8,11,3,15,13,4,14,8,2,10,0,0,0,14,12,5,15,7,15,8,3,11,1,1,0,4,6,2,13,13,0] } }
theorem leafL_077_5_valid : (leafL_077_5).reject.ValidFor (leafL_077_5).leaf := by decide

noncomputable def leafL_077_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,218}, reject := .fullRank { members := ![0,1,17,34,52,69,112,218], points := ![89,94,95,120,124,131], inverse := ![13,4,14,13,3,8,4,7,4,11,2,14,4,8,12,0,0,0,7,15,15,4,12,15,13,8,5,7,7,0,13,14,3,5,5,0] } }
theorem leafL_077_6_valid : (leafL_077_6).reject.ValidFor (leafL_077_6).leaf := by decide

noncomputable def leafL_077_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,223}, reject := .fullRank { members := ![0,1,17,34,52,69,112,223], points := ![90,126,135,139,141,154], inverse := ![13,11,10,3,2,12,6,0,14,5,2,15,0,0,1,3,2,0,9,15,3,4,4,5,10,5,10,7,14,12,9,13,14,9,13,14] } }
theorem leafL_077_7_valid : (leafL_077_7).reject.ValidFor (leafL_077_7).leaf := by decide

noncomputable def leavesL_077 : List RejectedLeaf := [leafL_077_0,leafL_077_1,leafL_077_2,leafL_077_3,leafL_077_4,leafL_077_5,leafL_077_6,leafL_077_7]

theorem leavesL_077_valid : LeafListValid leavesL_077 := by
  intro x hx
  simp only [leavesL_077, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_077_0_valid
  · exact leafL_077_1_valid
  · exact leafL_077_2_valid
  · exact leafL_077_3_valid
  · exact leafL_077_4_valid
  · exact leafL_077_5_valid
  · exact leafL_077_6_valid
  · exact leafL_077_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
