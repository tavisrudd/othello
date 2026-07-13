import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_318_0 : RejectedLeaf := { leaf := {0,1,17,34,52,75,229,266}, reject := .fullRank { members := ![0,1,17,34,52,75,229,266], points := ![83,86,95,121,125,131], inverse := ![2,6,3,7,9,8,15,4,12,5,12,14,9,13,4,0,0,0,2,14,11,2,10,15,3,7,4,9,9,0,7,1,6,15,15,0] } }
theorem leafL_318_0_valid : (leafL_318_0).reject.ValidFor (leafL_318_0).leaf := by decide

noncomputable def leafL_318_1 : RejectedLeaf := { leaf := {0,1,17,34,52,75,256,264}, reject := .fullRank { members := ![0,1,17,34,52,75,256,264], points := ![83,94,99,103,117,122], inverse := ![12,3,7,15,11,13,10,3,0,14,10,13,15,15,3,3,11,11,14,6,7,8,11,12,8,8,14,14,1,1,11,11,3,3,9,9] } }
theorem leafL_318_1_valid : (leafL_318_1).reject.ValidFor (leafL_318_1).leaf := by decide

noncomputable def leafL_318_2 : RejectedLeaf := { leaf := {0,1,17,34,52,78,91,109}, reject := .fullRank { members := ![0,1,17,34,52,78,91,109], points := ![115,117,120,137,140,159], inverse := ![15,9,2,14,0,11,1,10,8,11,3,11,4,12,8,0,0,0,7,12,9,3,10,11,12,11,7,2,2,0,0,14,14,14,14,0] } }
theorem leafL_318_2_valid : (leafL_318_2).reject.ValidFor (leafL_318_2).leaf := by decide

noncomputable def leafL_318_3 : RejectedLeaf := { leaf := {0,1,17,34,52,78,91,144}, reject := .fullRank { members := ![0,1,17,34,52,78,91,144], points := ![99,109,117,120,149,154], inverse := ![1,13,9,7,1,2,15,2,4,5,10,6,5,5,4,4,9,9,2,8,9,4,2,5,2,2,15,15,5,5,5,5,5,5,5,5] } }
theorem leafL_318_3_valid : (leafL_318_3).reject.ValidFor (leafL_318_3).leaf := by decide

noncomputable def leafL_318_4 : RejectedLeaf := { leaf := {0,1,17,34,52,78,91,268}, reject := .fullRank { members := ![0,1,17,34,52,78,91,268], points := ![103,104,106,115,120,137], inverse := ![8,15,0,1,8,15,1,11,13,1,15,9,8,3,11,0,0,0,1,3,5,14,1,8,0,6,6,14,14,0,12,10,6,8,8,0] } }
theorem leafL_318_4_valid : (leafL_318_4).reject.ValidFor (leafL_318_4).leaf := by decide

noncomputable def leafL_318_5 : RejectedLeaf := { leaf := {0,1,17,34,52,78,103,120}, reject := .fullRank { members := ![0,1,17,34,52,78,103,120], points := ![91,96,131,133,137,149], inverse := ![5,13,2,10,11,10,3,5,10,6,5,15,0,0,2,3,1,0,4,0,1,5,2,2,13,13,7,6,1,0,8,8,14,15,1,0] } }
theorem leafL_318_5_valid : (leafL_318_5).reject.ValidFor (leafL_318_5).leaf := by decide

noncomputable def leafL_318_6 : RejectedLeaf := { leaf := {0,1,17,34,52,78,103,256}, reject := .fullRank { members := ![0,1,17,34,52,78,103,256], points := ![133,137,138,149,156,168], inverse := ![10,15,15,2,13,4,4,9,6,15,7,3,14,10,4,0,0,0,14,15,10,7,14,2,8,14,6,2,2,0,7,13,10,12,12,0] } }
theorem leafL_318_6_valid : (leafL_318_6).reject.ValidFor (leafL_318_6).leaf := by decide

noncomputable def leafL_318_7 : RejectedLeaf := { leaf := {0,1,17,34,52,78,109,152}, reject := .fullRank { members := ![0,1,17,34,52,78,109,152], points := ![86,90,96,115,124,137], inverse := ![7,12,12,4,10,8,9,9,7,3,10,14,1,3,2,0,0,0,13,10,0,13,5,15,11,7,12,4,4,0,14,11,5,1,1,0] } }
theorem leafL_318_7_valid : (leafL_318_7).reject.ValidFor (leafL_318_7).leaf := by decide

noncomputable def leavesL_318 : List RejectedLeaf := [leafL_318_0,leafL_318_1,leafL_318_2,leafL_318_3,leafL_318_4,leafL_318_5,leafL_318_6,leafL_318_7]

theorem leavesL_318_valid : LeafListValid leavesL_318 := by
  intro x hx
  simp only [leavesL_318, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_318_0_valid
  · exact leafL_318_1_valid
  · exact leafL_318_2_valid
  · exact leafL_318_3_valid
  · exact leafL_318_4_valid
  · exact leafL_318_5_valid
  · exact leafL_318_6_valid
  · exact leafL_318_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
