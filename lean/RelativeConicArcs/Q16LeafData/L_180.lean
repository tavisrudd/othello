import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_180_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,205}, reject := .fullRank { members := ![0,1,17,34,52,71,104,205], points := ![91,94,126,155,159,169], inverse := ![8,5,0,2,5,11,8,15,7,7,9,14,12,15,1,5,14,9,8,14,9,11,12,8,10,0,6,7,8,3,10,14,13,7,1,15] } }
theorem leafL_180_0_valid : (leafL_180_0).reject.ValidFor (leafL_180_0).leaf := by decide

noncomputable def leafL_180_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,213}, reject := .fullRank { members := ![0,1,17,34,52,71,104,213], points := ![83,91,92,121,128,155], inverse := ![5,4,3,13,8,6,7,15,13,2,10,13,13,15,2,0,0,0,12,0,15,6,12,9,14,4,10,12,12,0,4,11,15,3,3,0] } }
theorem leafL_180_1_valid : (leafL_180_1).reject.ValidFor (leafL_180_1).leaf := by decide

noncomputable def leafL_180_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,218}, reject := .fullRank { members := ![0,1,17,34,52,71,104,218], points := ![83,91,94,121,128,140], inverse := ![8,2,13,5,11,8,7,9,9,12,5,14,1,4,5,0,0,0,11,2,14,9,1,15,7,5,2,12,12,0,0,3,3,3,3,0] } }
theorem leafL_180_2_valid : (leafL_180_2).reject.ValidFor (leafL_180_2).leaf := by decide

noncomputable def leafL_180_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,224}, reject := .fullRank { members := ![0,1,17,34,52,71,104,224], points := ![91,92,121,126,139,141], inverse := ![9,14,8,6,9,1,13,10,4,13,8,6,9,9,7,7,7,7,5,2,11,3,3,12,14,14,15,15,10,10,8,8,2,2,14,14] } }
theorem leafL_180_3_valid : (leafL_180_3).reject.ValidFor (leafL_180_3).leaf := by decide

noncomputable def leafL_180_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,229}, reject := .fullRank { members := ![0,1,17,34,52,71,104,229], points := ![83,90,91,121,126,140], inverse := ![12,1,10,4,10,8,15,2,10,14,7,14,6,3,5,0,0,0,4,10,9,12,4,15,4,3,7,5,5,0,10,2,8,12,12,0] } }
theorem leafL_180_4_valid : (leafL_180_4).reject.ValidFor (leafL_180_4).leaf := by decide

noncomputable def leafL_180_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,233}, reject := .fullRank { members := ![0,1,17,34,52,71,104,233], points := ![90,91,126,128,139,154], inverse := ![4,0,15,9,1,2,12,2,9,13,4,14,3,12,12,2,11,10,11,2,10,5,3,5,2,13,13,3,11,10,15,1,11,12,12,5] } }
theorem leafL_180_5_valid : (leafL_180_5).reject.ValidFor (leafL_180_5).leaf := by decide

noncomputable def leafL_180_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,239}, reject := .fullRank { members := ![0,1,17,34,52,71,104,239], points := ![91,92,94,126,128,139], inverse := ![6,3,2,2,12,8,12,15,4,12,5,14,6,7,1,0,0,0,8,12,3,12,4,15,2,5,7,1,1,0,12,4,8,13,13,0] } }
theorem leafL_180_6_valid : (leafL_180_6).reject.ValidFor (leafL_180_6).leaf := by decide

noncomputable def leafL_180_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,104,243}, reject := .fullRank { members := ![0,1,17,34,52,71,104,243], points := ![90,94,121,128,140,141], inverse := ![15,8,12,2,6,14,3,4,7,14,13,3,10,10,6,6,4,4,2,5,13,5,6,9,3,3,0,0,8,8,0,0,6,6,6,6] } }
theorem leafL_180_7_valid : (leafL_180_7).reject.ValidFor (leafL_180_7).leaf := by decide

noncomputable def leavesL_180 : List RejectedLeaf := [leafL_180_0,leafL_180_1,leafL_180_2,leafL_180_3,leafL_180_4,leafL_180_5,leafL_180_6,leafL_180_7]

theorem leavesL_180_valid : LeafListValid leavesL_180 := by
  intro x hx
  simp only [leavesL_180, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_180_0_valid
  · exact leafL_180_1_valid
  · exact leafL_180_2_valid
  · exact leafL_180_3_valid
  · exact leafL_180_4_valid
  · exact leafL_180_5_valid
  · exact leafL_180_6_valid
  · exact leafL_180_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
