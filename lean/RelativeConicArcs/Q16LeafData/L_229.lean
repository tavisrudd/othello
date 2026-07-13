import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_229_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,176,253}, reject := .fullRank { members := ![0,1,17,34,52,71,176,253], points := ![83,90,99,104,110,120], inverse := ![12,3,11,7,4,6,8,1,13,12,15,7,0,0,7,13,10,0,3,11,2,14,3,7,2,2,11,2,9,0,5,5,7,1,6,0] } }
theorem leafL_229_0_valid : (leafL_229_0).reject.ValidFor (leafL_229_0).leaf := by decide

noncomputable def leafL_229_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,176,262}, reject := .fullRank { members := ![0,1,17,34,52,71,176,262], points := ![83,90,91,99,110,120], inverse := ![8,1,6,0,8,6,5,14,2,5,11,7,6,3,5,0,0,0,11,15,12,7,8,7,7,9,14,6,6,0,14,9,7,8,8,0] } }
theorem leafL_229_1_valid : (leafL_229_1).reject.ValidFor (leafL_229_1).leaf := by decide

noncomputable def leafL_229_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,176,268}, reject := .fullRank { members := ![0,1,17,34,52,71,176,268], points := ![90,91,93,101,110,126], inverse := ![3,2,14,2,10,6,15,11,13,0,14,7,8,12,4,0,0,0,15,9,14,9,6,7,1,0,1,8,8,0,1,15,14,2,2,0] } }
theorem leafL_229_2_valid : (leafL_229_2).reject.ValidFor (leafL_229_2).leaf := by decide

noncomputable def leafL_229_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,181,203}, reject := .fullRank { members := ![0,1,17,34,52,71,181,203], points := ![83,109,127,140,141,150], inverse := ![15,15,11,0,1,11,10,3,13,11,10,5,8,12,14,15,12,9,11,7,3,7,11,3,10,9,1,11,11,2,1,15,8,7,4,5] } }
theorem leafL_229_3_valid : (leafL_229_3).reject.ValidFor (leafL_229_3).leaf := by decide

noncomputable def leafL_229_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,181,205}, reject := .fullRank { members := ![0,1,17,34,52,71,181,205], points := ![91,96,120,124,138,150], inverse := ![0,12,14,12,12,3,13,6,14,1,12,8,11,14,3,8,8,6,11,0,2,12,13,8,4,3,11,1,6,11,10,6,1,7,2,8] } }
theorem leafL_229_4_valid : (leafL_229_4).reject.ValidFor (leafL_229_4).leaf := by decide

noncomputable def leafL_229_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,181,216}, reject := .fullRank { members := ![0,1,17,34,52,71,181,216], points := ![83,91,96,109,124,127], inverse := ![4,10,1,8,4,2,13,15,11,14,8,15,9,3,10,0,0,0,8,3,3,15,7,0,11,1,10,0,5,5,0,12,12,0,12,12] } }
theorem leafL_229_5_valid : (leafL_229_5).reject.ValidFor (leafL_229_5).leaf := by decide

noncomputable def leafL_229_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,181,223}, reject := .fullRank { members := ![0,1,17,34,52,71,181,223], points := ![83,94,96,121,138,139], inverse := ![10,10,7,14,14,6,12,11,0,9,5,11,6,4,2,0,0,0,3,12,8,8,13,2,4,15,11,0,10,10,2,10,8,0,11,11] } }
theorem leafL_229_6_valid : (leafL_229_6).reject.ValidFor (leafL_229_6).leaf := by decide

noncomputable def leafL_229_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,181,232}, reject := .fullRank { members := ![0,1,17,34,52,71,181,232], points := ![94,127,138,141,147,150], inverse := ![6,7,11,4,15,0,2,2,1,7,0,6,3,8,1,8,11,9,0,2,7,14,0,11,7,10,1,7,5,14,5,11,4,12,11,13] } }
theorem leafL_229_7_valid : (leafL_229_7).reject.ValidFor (leafL_229_7).leaf := by decide

noncomputable def leavesL_229 : List RejectedLeaf := [leafL_229_0,leafL_229_1,leafL_229_2,leafL_229_3,leafL_229_4,leafL_229_5,leafL_229_6,leafL_229_7]

theorem leavesL_229_valid : LeafListValid leavesL_229 := by
  intro x hx
  simp only [leavesL_229, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_229_0_valid
  · exact leafL_229_1_valid
  · exact leafL_229_2_valid
  · exact leafL_229_3_valid
  · exact leafL_229_4_valid
  · exact leafL_229_5_valid
  · exact leafL_229_6_valid
  · exact leafL_229_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
