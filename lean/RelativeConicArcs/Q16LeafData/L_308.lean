import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_308_0 : RejectedLeaf := { leaf := {0,1,17,34,52,74,181,233}, reject := .fullRank { members := ![0,1,17,34,52,74,181,233], points := ![86,94,95,108,109,124], inverse := ![2,15,2,1,9,6,4,14,3,14,0,7,6,5,3,0,0,0,5,13,0,0,15,7,0,3,3,11,11,0,11,9,2,6,6,0] } }
theorem leafL_308_0_valid : (leafL_308_0).reject.ValidFor (leafL_308_0).leaf := by decide

noncomputable def leafL_308_1 : RejectedLeaf := { leaf := {0,1,17,34,52,74,182,203}, reject := .fullRank { members := ![0,1,17,34,52,74,182,203], points := ![92,93,95,110,115,125], inverse := ![11,10,14,8,2,4,2,1,10,14,9,14,15,3,12,0,0,0,1,9,0,15,11,12,14,0,14,0,6,6,4,7,3,0,8,8] } }
theorem leafL_308_1_valid : (leafL_308_1).reject.ValidFor (leafL_308_1).leaf := by decide

noncomputable def leafL_308_2 : RejectedLeaf := { leaf := {0,1,17,34,52,74,182,233}, reject := .fullRank { members := ![0,1,17,34,52,74,182,233], points := ![95,104,107,112,115,117], inverse := ![15,12,6,2,13,11,9,5,0,11,9,14,0,9,10,3,0,0,8,0,10,5,13,10,0,0,5,5,9,9,0,9,2,11,12,12] } }
theorem leafL_308_2_valid : (leafL_308_2).reject.ValidFor (leafL_308_2).leaf := by decide

noncomputable def leafL_308_3 : RejectedLeaf := { leaf := {0,1,17,34,52,74,182,237}, reject := .fullRank { members := ![0,1,17,34,52,74,182,237], points := ![92,95,107,112,117,124], inverse := ![9,6,10,2,6,0,8,1,9,7,11,12,4,4,9,9,10,10,3,11,8,7,5,2,6,6,1,1,4,4,11,11,11,11,0,0] } }
theorem leafL_308_3_valid : (leafL_308_3).reject.ValidFor (leafL_308_3).leaf := by decide

noncomputable def leafL_308_4 : RejectedLeaf := { leaf := {0,1,17,34,52,74,191,195}, reject := .fullRank { members := ![0,1,17,34,52,74,191,195], points := ![89,92,94,109,112,117], inverse := ![1,2,12,13,5,6,7,8,6,9,7,7,8,12,4,0,0,0,14,9,15,12,3,7,8,4,12,13,13,0,14,14,0,14,14,0] } }
theorem leafL_308_4_valid : (leafL_308_4).reject.ValidFor (leafL_308_4).leaf := by decide

noncomputable def leafL_308_5 : RejectedLeaf := { leaf := {0,1,17,34,52,74,191,216}, reject := .fullRank { members := ![0,1,17,34,52,74,191,216], points := ![92,101,103,109,117,121], inverse := ![15,8,5,5,14,8,9,10,7,3,5,2,0,14,6,8,0,0,8,10,15,10,10,13,0,0,11,11,13,13,0,15,8,7,6,6] } }
theorem leafL_308_5_valid : (leafL_308_5).reject.ValidFor (leafL_308_5).leaf := by decide

noncomputable def leafL_308_6 : RejectedLeaf := { leaf := {0,1,17,34,52,74,191,259}, reject := .fullRank { members := ![0,1,17,34,52,74,191,259], points := ![92,94,101,110,117,120], inverse := ![15,0,0,8,0,6,9,0,4,10,15,8,14,14,9,9,5,5,0,8,7,8,7,0,13,13,6,6,6,6,2,2,12,12,6,6] } }
theorem leafL_308_6_valid : (leafL_308_6).reject.ValidFor (leafL_308_6).leaf := by decide

noncomputable def leafL_308_7 : RejectedLeaf := { leaf := {0,1,17,34,52,74,195,216}, reject := .fullRank { members := ![0,1,17,34,52,74,195,216], points := ![89,92,103,109,117,121], inverse := ![14,1,2,10,8,14,4,13,5,11,11,12,3,3,14,14,13,13,4,12,13,2,4,3,0,0,11,11,13,13,6,6,11,11,15,15] } }
theorem leafL_308_7_valid : (leafL_308_7).reject.ValidFor (leafL_308_7).leaf := by decide

noncomputable def leavesL_308 : List RejectedLeaf := [leafL_308_0,leafL_308_1,leafL_308_2,leafL_308_3,leafL_308_4,leafL_308_5,leafL_308_6,leafL_308_7]

theorem leavesL_308_valid : LeafListValid leavesL_308 := by
  intro x hx
  simp only [leavesL_308, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_308_0_valid
  · exact leafL_308_1_valid
  · exact leafL_308_2_valid
  · exact leafL_308_3_valid
  · exact leafL_308_4_valid
  · exact leafL_308_5_valid
  · exact leafL_308_6_valid
  · exact leafL_308_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
