import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_186_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,109,203}, reject := .fullRank { members := ![0,1,17,34,52,71,109,203], points := ![90,127,128,131,150,156], inverse := ![13,2,9,11,10,6,3,10,1,1,2,11,10,2,7,3,13,1,0,15,13,9,13,6,11,2,14,4,3,0,7,7,13,6,12,7] } }
theorem leafL_186_0_valid : (leafL_186_0).reject.ValidFor (leafL_186_0).leaf := by decide

noncomputable def leafL_186_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,109,207}, reject := .fullRank { members := ![0,1,17,34,52,71,109,207], points := ![90,92,94,120,124,140], inverse := ![13,12,6,4,10,8,0,7,0,0,9,14,15,10,5,0,0,0,15,15,7,1,9,15,15,3,12,7,7,0,6,14,8,5,5,0] } }
theorem leafL_186_1_valid : (leafL_186_1).reject.ValidFor (leafL_186_1).leaf := by decide

noncomputable def leafL_186_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,109,217}, reject := .fullRank { members := ![0,1,17,34,52,71,109,217], points := ![91,94,124,131,138,154], inverse := ![11,6,11,11,0,12,8,0,7,2,7,10,9,8,9,6,1,15,1,2,10,9,9,9,12,8,2,7,8,9,0,4,2,8,7,9] } }
theorem leafL_186_2_valid : (leafL_186_2).reject.ValidFor (leafL_186_2).leaf := by decide

noncomputable def leafL_186_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,109,218}, reject := .fullRank { members := ![0,1,17,34,52,71,109,218], points := ![91,94,120,124,127,150], inverse := ![14,12,7,11,9,6,2,7,10,5,7,13,0,0,7,2,5,0,0,3,10,13,13,9,10,10,9,3,10,0,3,3,7,14,9,0] } }
theorem leafL_186_3_valid : (leafL_186_3).reject.ValidFor (leafL_186_3).leaf := by decide

noncomputable def leafL_186_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,109,222}, reject := .fullRank { members := ![0,1,17,34,52,71,109,222], points := ![90,92,124,131,140,144], inverse := ![15,8,14,7,12,3,0,7,9,0,14,0,0,0,0,8,9,1,4,3,8,14,6,7,6,6,0,15,11,4,7,7,0,3,11,8] } }
theorem leafL_186_4_valid : (leafL_186_4).reject.ValidFor (leafL_186_4).leaf := by decide

noncomputable def leafL_186_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,109,224}, reject := .fullRank { members := ![0,1,17,34,52,71,109,224], points := ![92,120,124,150,154,156], inverse := ![2,5,0,6,0,0,5,0,8,0,0,13,0,0,0,13,5,8,3,6,12,6,6,9,0,2,2,11,1,10,0,13,13,13,13,0] } }
theorem leafL_186_5_valid : (leafL_186_5).reject.ValidFor (leafL_186_5).leaf := by decide

noncomputable def leafL_186_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,109,229}, reject := .fullRank { members := ![0,1,17,34,52,71,109,229], points := ![90,91,120,131,140,150], inverse := ![7,14,9,15,11,5,11,7,5,7,13,3,2,4,3,7,6,4,12,5,15,10,9,5,7,2,11,4,12,6,7,0,10,14,8,11] } }
theorem leafL_186_6_valid : (leafL_186_6).reject.ValidFor (leafL_186_6).leaf := by decide

noncomputable def leafL_186_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,109,233}, reject := .fullRank { members := ![0,1,17,34,52,71,109,233], points := ![90,91,94,124,127,138], inverse := ![1,10,12,6,8,8,4,14,13,2,11,14,10,2,8,0,0,0,7,8,8,0,8,15,13,12,1,5,5,0,10,1,11,12,12,0] } }
theorem leafL_186_7_valid : (leafL_186_7).reject.ValidFor (leafL_186_7).leaf := by decide

noncomputable def leavesL_186 : List RejectedLeaf := [leafL_186_0,leafL_186_1,leafL_186_2,leafL_186_3,leafL_186_4,leafL_186_5,leafL_186_6,leafL_186_7]

theorem leavesL_186_valid : LeafListValid leavesL_186 := by
  intro x hx
  simp only [leavesL_186, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_186_0_valid
  · exact leafL_186_1_valid
  · exact leafL_186_2_valid
  · exact leafL_186_3_valid
  · exact leafL_186_4_valid
  · exact leafL_186_5_valid
  · exact leafL_186_6_valid
  · exact leafL_186_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
