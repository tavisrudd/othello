import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_277_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,159,208}, reject := .fullRank { members := ![0,1,17,34,52,72,159,208], points := ![83,103,108,124,125,135], inverse := ![12,5,14,8,13,3,4,11,8,3,9,13,9,8,1,9,0,9,2,9,12,0,13,10,0,8,8,10,10,0,3,8,11,1,2,3] } }
theorem leafL_277_0_valid : (leafL_277_0).reject.ValidFor (leafL_277_0).leaf := by decide

noncomputable def leafL_277_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,159,229}, reject := .fullRank { members := ![0,1,17,34,52,72,159,229], points := ![83,91,108,122,124,125], inverse := ![15,0,8,14,1,9,14,7,14,3,3,7,0,0,0,12,3,15,9,1,15,15,14,6,2,2,0,9,3,10,14,14,0,4,2,6] } }
theorem leafL_277_1_valid : (leafL_277_1).reject.ValidFor (leafL_277_1).leaf := by decide

noncomputable def leafL_277_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,159,251}, reject := .fullRank { members := ![0,1,17,34,52,72,159,251], points := ![83,92,93,101,103,122], inverse := ![14,7,6,8,0,6,3,9,3,11,5,7,6,12,10,0,0,0,4,9,5,8,7,7,0,13,13,2,2,0,13,15,2,9,9,0] } }
theorem leafL_277_2_valid : (leafL_277_2).reject.ValidFor (leafL_277_2).leaf := by decide

noncomputable def leafL_277_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,163,185}, reject := .fullRank { members := ![0,1,17,34,52,72,163,185], points := ![93,96,103,126,138,139], inverse := ![13,3,9,7,10,11,1,11,13,4,8,11,4,8,12,12,9,5,14,12,5,13,12,6,8,15,7,7,2,5,11,11,0,0,11,11] } }
theorem leafL_277_3_valid : (leafL_277_3).reject.ValidFor (leafL_277_3).leaf := by decide

noncomputable def leafL_277_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,163,188}, reject := .fullRank { members := ![0,1,17,34,52,72,163,188], points := ![90,91,93,103,107,126], inverse := ![8,5,2,1,9,6,13,8,12,1,15,7,8,12,4,0,0,0,1,0,9,9,6,7,12,2,14,14,14,0,15,6,9,10,10,0] } }
theorem leafL_277_4_valid : (leafL_277_4).reject.ValidFor (leafL_277_4).leaf := by decide

noncomputable def leafL_277_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,163,198}, reject := .fullRank { members := ![0,1,17,34,52,72,163,198], points := ![91,93,96,126,137,138], inverse := ![11,4,8,14,8,0,8,0,15,9,13,3,4,12,8,0,0,0,8,6,9,8,3,12,14,5,11,0,13,13,9,3,10,0,14,14] } }
theorem leafL_277_5_valid : (leafL_277_5).reject.ValidFor (leafL_277_5).leaf := by decide

noncomputable def leafL_277_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,163,220}, reject := .fullRank { members := ![0,1,17,34,52,72,163,220], points := ![90,91,96,103,112,137], inverse := ![8,11,10,7,9,6,3,15,2,7,14,7,12,8,4,0,0,0,9,0,6,10,2,7,0,1,1,8,8,0,15,1,14,2,2,0] } }
theorem leafL_277_6_valid : (leafL_277_6).reject.ValidFor (leafL_277_6).leaf := by decide

noncomputable def leafL_277_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,163,222}, reject := .fullRank { members := ![0,1,17,34,52,72,163,222], points := ![90,96,107,112,137,138], inverse := ![1,8,12,2,7,1,6,8,6,15,11,12,7,7,7,7,9,9,3,12,11,3,10,13,11,11,9,9,5,5,14,14,2,2,8,8] } }
theorem leafL_277_7_valid : (leafL_277_7).reject.ValidFor (leafL_277_7).leaf := by decide

noncomputable def leavesL_277 : List RejectedLeaf := [leafL_277_0,leafL_277_1,leafL_277_2,leafL_277_3,leafL_277_4,leafL_277_5,leafL_277_6,leafL_277_7]

theorem leavesL_277_valid : LeafListValid leavesL_277 := by
  intro x hx
  simp only [leavesL_277, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_277_0_valid
  · exact leafL_277_1_valid
  · exact leafL_277_2_valid
  · exact leafL_277_3_valid
  · exact leafL_277_4_valid
  · exact leafL_277_5_valid
  · exact leafL_277_6_valid
  · exact leafL_277_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
