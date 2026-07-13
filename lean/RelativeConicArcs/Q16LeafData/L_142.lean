import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_142_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,96,270}, reject := .fullRank { members := ![0,1,17,34,52,70,96,270], points := ![101,108,109,117,122,137], inverse := ![7,6,6,8,1,15,6,9,8,13,3,9,1,5,4,0,0,0,15,1,9,11,4,8,10,8,2,12,12,0,6,15,9,13,13,0] } }
theorem leafL_142_0_valid : (leafL_142_0).reject.ValidFor (leafL_142_0).leaf := by decide

noncomputable def leafL_142_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,107,120}, reject := .fullRank { members := ![0,1,17,34,52,70,107,120], points := ![83,95,96,133,137,151], inverse := ![12,9,13,5,6,10,3,7,2,3,10,15,14,10,4,0,0,0,11,6,9,0,6,2,5,0,5,11,11,0,6,6,0,6,6,0] } }
theorem leafL_142_1_valid : (leafL_142_1).reject.ValidFor (leafL_142_1).leaf := by decide

noncomputable def leafL_142_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,107,127}, reject := .fullRank { members := ![0,1,17,34,52,70,107,127], points := ![83,94,133,137,140,151], inverse := ![4,12,3,11,11,10,1,7,8,11,10,15,0,0,15,6,9,0,12,8,8,8,6,2,10,10,8,4,12,0,9,9,9,0,9,0] } }
theorem leafL_142_2_valid : (leafL_142_2).reject.ValidFor (leafL_142_2).leaf := by decide

noncomputable def leafL_142_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,107,137}, reject := .fullRank { members := ![0,1,17,34,52,70,107,137], points := ![83,94,95,120,124,154], inverse := ![15,11,6,2,7,6,11,3,13,13,5,13,15,9,6,0,0,0,14,0,13,8,2,9,5,6,3,7,7,0,5,0,5,5,5,0] } }
theorem leafL_142_3_valid : (leafL_142_3).reject.ValidFor (leafL_142_3).leaf := by decide

noncomputable def leafL_142_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,107,140}, reject := .fullRank { members := ![0,1,17,34,52,70,107,140], points := ![94,96,120,122,126,149], inverse := ![13,15,9,8,4,6,9,12,13,7,2,13,0,0,7,4,3,0,6,5,6,10,6,9,8,8,12,4,8,0,13,13,9,3,10,0] } }
theorem leafL_142_4_valid : (leafL_142_4).reject.ValidFor (leafL_142_4).leaf := by decide

noncomputable def leafL_142_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,107,149}, reject := .fullRank { members := ![0,1,17,34,52,70,107,149], points := ![95,122,126,140,172,176], inverse := ![1,4,13,13,14,10,4,1,2,5,13,15,5,3,14,14,14,8,13,11,10,0,12,0,7,13,12,13,1,10,0,2,2,0,2,2] } }
theorem leafL_142_5_valid : (leafL_142_5).reject.ValidFor (leafL_142_5).leaf := by decide

noncomputable def leafL_142_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,107,152}, reject := .fullRank { members := ![0,1,17,34,52,70,107,152], points := ![83,94,96,115,124,131], inverse := ![14,13,4,6,8,8,7,0,0,9,0,14,6,4,2,0,0,0,8,3,12,10,2,15,1,7,6,4,4,0,14,8,6,1,1,0] } }
theorem leafL_142_6_valid : (leafL_142_6).reject.ValidFor (leafL_142_6).leaf := by decide

noncomputable def leafL_142_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,107,172}, reject := .fullRank { members := ![0,1,17,34,52,70,107,172], points := ![83,94,95,122,131,133], inverse := ![7,15,15,14,5,13,14,15,6,9,3,13,15,9,6,0,0,0,11,4,8,8,0,15,10,10,0,0,5,5,2,3,1,0,12,12] } }
theorem leafL_142_7_valid : (leafL_142_7).reject.ValidFor (leafL_142_7).leaf := by decide

noncomputable def leavesL_142 : List RejectedLeaf := [leafL_142_0,leafL_142_1,leafL_142_2,leafL_142_3,leafL_142_4,leafL_142_5,leafL_142_6,leafL_142_7]

theorem leavesL_142_valid : LeafListValid leavesL_142 := by
  intro x hx
  simp only [leavesL_142, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_142_0_valid
  · exact leafL_142_1_valid
  · exact leafL_142_2_valid
  · exact leafL_142_3_valid
  · exact leafL_142_4_valid
  · exact leafL_142_5_valid
  · exact leafL_142_6_valid
  · exact leafL_142_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
