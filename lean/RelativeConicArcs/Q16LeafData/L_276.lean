import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_276_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,156,254}, reject := .fullRank { members := ![0,1,17,34,52,72,156,254], points := ![83,96,107,122,128,135], inverse := ![3,9,13,2,1,5,11,8,4,15,2,10,10,2,8,7,15,8,7,4,4,12,0,11,3,15,12,3,15,12,3,9,10,8,2,10] } }
theorem leafL_276_0_valid : (leafL_276_0).reject.ValidFor (leafL_276_0).leaf := by decide

noncomputable def leafL_276_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,156,263}, reject := .fullRank { members := ![0,1,17,34,52,72,156,263], points := ![96,107,117,122,128,141], inverse := ![11,12,11,9,0,4,13,10,8,11,0,4,0,0,7,15,8,0,12,11,3,9,9,4,9,9,1,10,2,9,10,10,0,10,0,10] } }
theorem leafL_276_1_valid : (leafL_276_1).reject.ValidFor (leafL_276_1).leaf := by decide

noncomputable def leafL_276_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,156,267}, reject := .fullRank { members := ![0,1,17,34,52,72,156,267], points := ![99,115,128,135,137,141], inverse := ![7,4,13,11,6,2,7,14,0,9,9,9,0,0,0,7,4,3,7,7,8,15,5,2,0,15,15,12,5,9,0,4,4,10,15,5] } }
theorem leafL_276_2_valid : (leafL_276_2).reject.ValidFor (leafL_276_2).leaf := by decide

noncomputable def leafL_276_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,159,163}, reject := .fullRank { members := ![0,1,17,34,52,72,159,163], points := ![91,93,96,103,112,122], inverse := ![12,2,1,14,6,6,8,10,11,4,10,7,4,12,8,0,0,0,13,0,5,9,6,7,1,0,1,8,8,0,14,15,1,2,2,0] } }
theorem leafL_276_3_valid : (leafL_276_3).reject.ValidFor (leafL_276_3).leaf := by decide

noncomputable def leafL_276_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,159,186}, reject := .fullRank { members := ![0,1,17,34,52,72,159,186], points := ![91,101,103,108,115,124], inverse := ![15,1,0,9,5,3,9,2,12,0,14,9,0,4,2,6,0,0,8,13,13,15,2,5,0,4,10,14,6,6,0,1,4,5,15,15] } }
theorem leafL_276_4_valid : (leafL_276_4).reject.ValidFor (leafL_276_4).leaf := by decide

noncomputable def leafL_276_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,159,198}, reject := .fullRank { members := ![0,1,17,34,52,72,159,198], points := ![91,92,93,101,108,115], inverse := ![1,3,13,10,2,6,4,14,3,13,3,7,7,6,1,0,0,0,2,1,11,10,5,7,7,11,12,6,6,0,13,3,14,8,8,0] } }
theorem leafL_276_5_valid : (leafL_276_5).reject.ValidFor (leafL_276_5).leaf := by decide

noncomputable def leafL_276_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,159,201}, reject := .fullRank { members := ![0,1,17,34,52,72,159,201], points := ![83,91,92,101,103,122], inverse := ![6,5,12,8,0,6,7,11,5,11,5,7,13,15,2,0,0,0,8,14,14,8,7,7,14,2,12,2,2,0,4,3,7,9,9,0] } }
theorem leafL_276_6_valid : (leafL_276_6).reject.ValidFor (leafL_276_6).leaf := by decide

noncomputable def leafL_276_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,159,202}, reject := .fullRank { members := ![0,1,17,34,52,72,159,202], points := ![92,93,101,103,108,124], inverse := ![9,6,7,4,11,6,9,0,0,0,14,7,0,0,4,2,6,0,7,15,8,14,9,7,13,13,2,2,0,0,6,6,14,3,13,0] } }
theorem leafL_276_7_valid : (leafL_276_7).reject.ValidFor (leafL_276_7).leaf := by decide

noncomputable def leavesL_276 : List RejectedLeaf := [leafL_276_0,leafL_276_1,leafL_276_2,leafL_276_3,leafL_276_4,leafL_276_5,leafL_276_6,leafL_276_7]

theorem leavesL_276_valid : LeafListValid leavesL_276 := by
  intro x hx
  simp only [leavesL_276, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_276_0_valid
  · exact leafL_276_1_valid
  · exact leafL_276_2_valid
  · exact leafL_276_3_valid
  · exact leafL_276_4_valid
  · exact leafL_276_5_valid
  · exact leafL_276_6_valid
  · exact leafL_276_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
