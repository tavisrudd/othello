import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_214_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,155,169}, reject := .fullRank { members := ![0,1,17,34,52,71,155,169], points := ![92,94,96,104,124,128], inverse := ![11,1,5,8,6,0,12,9,12,14,14,9,5,10,15,0,0,0,1,1,8,15,5,2,3,14,13,0,9,9,15,0,15,0,15,15] } }
theorem leafL_214_0_valid : (leafL_214_0).reject.ValidFor (leafL_214_0).leaf := by decide

noncomputable def leafL_214_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,155,181}, reject := .fullRank { members := ![0,1,17,34,52,71,155,181], points := ![83,94,96,109,120,124], inverse := ![13,12,14,8,8,14,1,11,3,14,9,14,6,4,2,0,0,0,7,4,11,15,0,7,8,9,1,0,7,7,1,2,3,0,5,5] } }
theorem leafL_214_1_valid : (leafL_214_1).reject.ValidFor (leafL_214_1).leaf := by decide

noncomputable def leafL_214_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,155,186}, reject := .fullRank { members := ![0,1,17,34,52,71,155,186], points := ![96,101,104,124,128,144], inverse := ![0,0,7,9,0,15,7,0,0,0,9,14,6,3,5,0,6,6,2,8,13,12,1,10,9,2,11,4,13,9,14,12,2,10,4,14] } }
theorem leafL_214_2_valid : (leafL_214_2).reject.ValidFor (leafL_214_2).leaf := by decide

noncomputable def leafL_214_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,155,191}, reject := .fullRank { members := ![0,1,17,34,52,71,155,191], points := ![90,92,94,101,110,120], inverse := ![0,15,0,0,8,6,2,5,14,12,2,7,15,10,5,0,0,0,9,3,2,5,10,7,10,4,14,8,8,0,10,11,1,2,2,0] } }
theorem leafL_214_3_valid : (leafL_214_3).reject.ValidFor (leafL_214_3).leaf := by decide

noncomputable def leafL_214_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,155,197}, reject := .fullRank { members := ![0,1,17,34,52,71,155,197], points := ![83,90,92,104,110,120], inverse := ![0,0,15,0,8,6,7,6,8,14,0,7,10,11,1,0,0,0,2,6,12,13,2,7,14,1,15,5,5,0,15,14,1,12,12,0] } }
theorem leafL_214_4_valid : (leafL_214_4).reject.ValidFor (leafL_214_4).leaf := by decide

noncomputable def leafL_214_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,155,223}, reject := .fullRank { members := ![0,1,17,34,52,71,155,223], points := ![83,90,94,101,138,140], inverse := ![7,4,10,14,11,13,1,2,13,9,12,11,14,12,2,0,0,0,13,1,3,8,3,4,4,12,8,0,15,15,15,1,14,0,7,7] } }
theorem leafL_214_5_valid : (leafL_214_5).reject.ValidFor (leafL_214_5).leaf := by decide

noncomputable def leafL_214_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,155,237}, reject := .fullRank { members := ![0,1,17,34,52,71,155,237], points := ![90,92,94,104,124,138], inverse := ![5,14,4,8,6,0,6,14,4,11,2,5,15,10,5,0,0,0,6,4,13,8,0,7,7,0,2,5,5,5,4,10,2,12,12,12] } }
theorem leafL_214_6_valid : (leafL_214_6).reject.ValidFor (leafL_214_6).leaf := by decide

noncomputable def leafL_214_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,155,243}, reject := .fullRank { members := ![0,1,17,34,52,71,155,243], points := ![94,104,124,128,138,140], inverse := ![6,1,7,8,3,10,8,15,5,3,9,8,2,2,11,9,11,9,5,2,1,11,6,11,6,6,11,13,13,11,12,12,2,14,6,10] } }
theorem leafL_214_7_valid : (leafL_214_7).reject.ValidFor (leafL_214_7).leaf := by decide

noncomputable def leavesL_214 : List RejectedLeaf := [leafL_214_0,leafL_214_1,leafL_214_2,leafL_214_3,leafL_214_4,leafL_214_5,leafL_214_6,leafL_214_7]

theorem leavesL_214_valid : LeafListValid leavesL_214 := by
  intro x hx
  simp only [leavesL_214, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_214_0_valid
  · exact leafL_214_1_valid
  · exact leafL_214_2_valid
  · exact leafL_214_3_valid
  · exact leafL_214_4_valid
  · exact leafL_214_5_valid
  · exact leafL_214_6_valid
  · exact leafL_214_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
