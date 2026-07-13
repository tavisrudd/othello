import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_199_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,128,188}, reject := .fullRank { members := ![0,1,17,34,52,71,128,188], points := ![83,94,104,110,131,138], inverse := ![0,9,13,3,12,10,12,2,15,6,1,6,15,15,8,8,2,2,6,9,6,14,10,13,15,15,9,9,3,3,14,14,2,2,10,10] } }
theorem leafL_199_0_valid : (leafL_199_0).reject.ValidFor (leafL_199_0).leaf := by decide

noncomputable def leafL_199_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,128,203}, reject := .fullRank { members := ![0,1,17,34,52,71,128,203], points := ![83,93,99,109,110,131], inverse := ![4,13,12,5,7,6,14,0,9,0,0,7,0,0,11,3,8,0,9,6,14,6,0,7,15,15,4,13,9,0,3,3,3,3,0,0] } }
theorem leafL_199_1_valid : (leafL_199_1).reject.ValidFor (leafL_199_1).leaf := by decide

noncomputable def leafL_199_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,128,207}, reject := .fullRank { members := ![0,1,17,34,52,71,128,207], points := ![83,94,99,101,109,139], inverse := ![9,0,4,15,5,6,10,4,12,11,14,7,0,0,9,11,2,0,8,7,10,14,12,7,14,14,0,9,9,0,8,8,10,11,1,0] } }
theorem leafL_199_2_valid : (leafL_199_2).reject.ValidFor (leafL_199_2).leaf := by decide

noncomputable def leafL_199_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,128,213}, reject := .fullRank { members := ![0,1,17,34,52,71,128,213], points := ![83,93,99,104,110,138], inverse := ![0,9,7,5,12,6,5,11,7,6,8,7,0,0,7,13,10,0,2,13,11,15,12,7,15,15,5,11,14,0,3,3,15,13,2,0] } }
theorem leafL_199_3_valid : (leafL_199_3).reject.ValidFor (leafL_199_3).leaf := by decide

noncomputable def leafL_199_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,128,214}, reject := .fullRank { members := ![0,1,17,34,52,71,128,214], points := ![93,99,101,131,138,139], inverse := ![9,13,3,12,0,10,14,15,6,5,5,7,0,0,0,6,3,5,15,3,11,14,11,2,0,3,3,1,1,0,0,10,10,15,9,6] } }
theorem leafL_199_4_valid : (leafL_199_4).reject.ValidFor (leafL_199_4).leaf := by decide

noncomputable def leafL_199_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,128,218}, reject := .fullRank { members := ![0,1,17,34,52,71,128,218], points := ![83,94,101,104,109,139], inverse := ![9,0,6,11,3,6,10,4,3,14,4,7,0,0,5,3,6,0,8,7,2,9,3,7,14,14,9,0,9,0,8,8,7,9,14,0] } }
theorem leafL_199_5_valid : (leafL_199_5).reject.ValidFor (leafL_199_5).leaf := by decide

noncomputable def leafL_199_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,128,232}, reject := .fullRank { members := ![0,1,17,34,52,71,128,232], points := ![83,93,94,101,110,138], inverse := ![14,12,11,13,3,6,1,2,13,4,13,7,11,3,8,0,0,0,4,9,2,13,5,7,4,12,8,8,8,0,7,10,13,2,2,0] } }
theorem leafL_199_6_valid : (leafL_199_6).reject.ValidFor (leafL_199_6).leaf := by decide

noncomputable def leafL_199_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,128,233}, reject := .fullRank { members := ![0,1,17,34,52,71,128,233], points := ![94,99,104,109,138,139], inverse := ![9,5,13,6,12,10,14,11,5,7,2,5,0,14,1,15,0,0,15,3,13,6,7,0,0,4,8,12,8,8,0,13,15,2,7,7] } }
theorem leafL_199_7_valid : (leafL_199_7).reject.ValidFor (leafL_199_7).leaf := by decide

noncomputable def leavesL_199 : List RejectedLeaf := [leafL_199_0,leafL_199_1,leafL_199_2,leafL_199_3,leafL_199_4,leafL_199_5,leafL_199_6,leafL_199_7]

theorem leavesL_199_valid : LeafListValid leavesL_199 := by
  intro x hx
  simp only [leavesL_199, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_199_0_valid
  · exact leafL_199_1_valid
  · exact leafL_199_2_valid
  · exact leafL_199_3_valid
  · exact leafL_199_4_valid
  · exact leafL_199_5_valid
  · exact leafL_199_6_valid
  · exact leafL_199_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
