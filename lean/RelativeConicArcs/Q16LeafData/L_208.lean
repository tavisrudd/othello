import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_208_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,144,246}, reject := .fullRank { members := ![0,1,17,34,52,71,144,246], points := ![83,91,109,110,120,122], inverse := ![14,1,4,12,0,6,12,5,0,14,2,5,12,12,12,12,10,10,5,13,8,7,12,11,7,7,5,5,8,8,9,9,7,7,5,5] } }
theorem leafL_208_0_valid : (leafL_208_0).reject.ValidFor (leafL_208_0).leaf := by decide

noncomputable def leafL_208_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,144,248}, reject := .fullRank { members := ![0,1,17,34,52,71,144,248], points := ![93,109,121,126,147,154], inverse := ![0,12,14,0,3,0,15,9,12,5,13,2,5,13,12,5,2,3,7,11,7,8,14,13,15,4,14,6,2,1,5,13,2,11,13,12] } }
theorem leafL_208_1_valid : (leafL_208_1).reject.ValidFor (leafL_208_1).leaf := by decide

noncomputable def leafL_208_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,144,253}, reject := .fullRank { members := ![0,1,17,34,52,71,144,253], points := ![83,90,110,120,121,126], inverse := ![12,3,8,10,11,7,10,3,14,11,5,9,0,0,0,10,7,13,11,3,15,10,4,9,15,15,0,14,10,4,11,11,0,3,10,9] } }
theorem leafL_208_2_valid : (leafL_208_2).reject.ValidFor (leafL_208_2).leaf := by decide

noncomputable def leafL_208_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,144,268}, reject := .fullRank { members := ![0,1,17,34,52,71,144,268], points := ![90,91,93,109,110,122], inverse := ![13,7,5,4,12,6,3,15,5,13,3,7,8,12,4,0,0,0,0,6,14,0,15,7,4,14,10,4,4,0,13,5,8,1,1,0] } }
theorem leafL_208_3_valid : (leafL_208_3).reject.ValidFor (leafL_208_3).leaf := by decide

noncomputable def leafL_208_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,147,168}, reject := .fullRank { members := ![0,1,17,34,52,71,147,168], points := ![90,91,96,101,106,122], inverse := ![6,7,14,8,0,6,9,0,0,0,14,7,12,8,4,0,0,0,13,10,15,2,13,7,7,10,13,3,3,0,10,7,13,4,4,0] } }
theorem leafL_208_4_valid : (leafL_208_4).reject.ValidFor (leafL_208_4).leaf := by decide

noncomputable def leafL_208_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,147,169}, reject := .fullRank { members := ![0,1,17,34,52,71,147,169], points := ![91,92,96,122,124,133], inverse := ![0,2,5,15,1,8,14,5,12,7,14,14,11,13,6,0,0,0,7,10,10,8,0,15,7,6,1,1,1,0,14,11,5,13,13,0] } }
theorem leafL_208_5_valid : (leafL_208_5).reject.ValidFor (leafL_208_5).leaf := by decide

noncomputable def leafL_208_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,147,173}, reject := .fullRank { members := ![0,1,17,34,52,71,147,173], points := ![92,96,101,106,110,124], inverse := ![2,13,4,14,2,6,9,0,6,13,5,7,0,0,8,1,9,0,14,6,12,15,12,7,12,12,6,5,3,0,13,13,0,13,13,0] } }
theorem leafL_208_6_valid : (leafL_208_6).reject.ValidFor (leafL_208_6).leaf := by decide

noncomputable def leafL_208_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,147,174}, reject := .fullRank { members := ![0,1,17,34,52,71,147,174], points := ![92,101,106,122,124,140], inverse := ![9,14,0,7,7,6,7,0,0,0,9,14,4,6,2,0,4,4,3,0,4,4,8,11,9,12,5,8,1,9,7,0,7,7,0,7] } }
theorem leafL_208_7_valid : (leafL_208_7).reject.ValidFor (leafL_208_7).leaf := by decide

noncomputable def leavesL_208 : List RejectedLeaf := [leafL_208_0,leafL_208_1,leafL_208_2,leafL_208_3,leafL_208_4,leafL_208_5,leafL_208_6,leafL_208_7]

theorem leavesL_208_valid : LeafListValid leavesL_208 := by
  intro x hx
  simp only [leavesL_208, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_208_0_valid
  · exact leafL_208_1_valid
  · exact leafL_208_2_valid
  · exact leafL_208_3_valid
  · exact leafL_208_4_valid
  · exact leafL_208_5_valid
  · exact leafL_208_6_valid
  · exact leafL_208_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
