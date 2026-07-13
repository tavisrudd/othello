import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_261_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,108,217}, reject := .fullRank { members := ![0,1,17,34,52,72,108,217], points := ![91,93,96,122,125,135], inverse := ![9,8,6,2,12,8,13,2,8,1,8,14,4,12,8,0,0,0,6,13,12,13,5,15,9,9,0,5,5,0,12,0,12,12,12,0] } }
theorem leafL_261_0_valid : (leafL_261_0).reject.ValidFor (leafL_261_0).leaf := by decide

noncomputable def leafL_261_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,108,249}, reject := .fullRank { members := ![0,1,17,34,52,72,108,249], points := ![93,115,141,150,151,159], inverse := ![0,4,14,8,2,1,6,0,9,14,6,7,0,0,0,3,5,6,5,9,1,12,2,3,15,14,11,12,0,6,10,5,3,11,15,8] } }
theorem leafL_261_1_valid : (leafL_261_1).reject.ValidFor (leafL_261_1).leaf := by decide

noncomputable def leafL_261_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,108,254}, reject := .fullRank { members := ![0,1,17,34,52,72,108,254], points := ![91,93,96,122,125,135], inverse := ![9,8,6,2,12,8,13,2,8,1,8,14,4,12,8,0,0,0,6,13,12,13,5,15,9,9,0,5,5,0,12,0,12,12,12,0] } }
theorem leafL_261_2_valid : (leafL_261_2).reject.ValidFor (leafL_261_2).leaf := by decide

noncomputable def leafL_261_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,108,263}, reject := .fullRank { members := ![0,1,17,34,52,72,108,263], points := ![93,94,96,115,122,141], inverse := ![0,7,0,14,0,8,14,4,13,1,8,14,14,9,7,0,0,0,14,7,14,14,6,15,1,0,1,10,10,0,10,2,8,11,11,0] } }
theorem leafL_261_3_valid : (leafL_261_3).reject.ValidFor (leafL_261_3).leaf := by decide

noncomputable def leafL_261_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,115,138}, reject := .fullRank { members := ![0,1,17,34,52,72,115,138], points := ![91,101,107,108,151,172], inverse := ![13,9,13,4,7,11,2,2,7,9,6,8,0,11,3,8,0,0,12,7,8,13,9,7,14,0,5,11,14,14,8,9,4,5,8,8] } }
theorem leafL_261_4_valid : (leafL_261_4).reject.ValidFor (leafL_261_4).leaf := by decide

noncomputable def leafL_261_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,115,143}, reject := .fullRank { members := ![0,1,17,34,52,72,115,143], points := ![91,96,101,150,156,169], inverse := ![7,5,15,4,12,4,4,7,13,12,11,9,12,10,6,7,1,6,5,7,12,13,10,9,0,8,8,4,12,8,9,5,12,3,15,12] } }
theorem leafL_261_5_valid : (leafL_261_5).reject.ValidFor (leafL_261_5).leaf := by decide

noncomputable def leafL_261_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,115,156}, reject := .fullRank { members := ![0,1,17,34,52,72,115,156], points := ![96,107,135,143,176,181], inverse := ![0,3,10,14,7,1,5,7,5,15,1,9,3,14,7,2,9,1,15,8,14,9,0,0,14,7,11,6,11,15,13,2,3,9,4,1] } }
theorem leafL_261_6_valid : (leafL_261_6).reject.ValidFor (leafL_261_6).leaf := by decide

noncomputable def leafL_261_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,115,188}, reject := .fullRank { members := ![0,1,17,34,52,72,115,188], points := ![90,91,93,107,138,143], inverse := ![6,11,4,14,0,6,3,5,8,9,4,3,8,12,4,0,0,0,6,11,2,8,3,4,7,15,8,0,8,8,9,8,1,0,2,2] } }
theorem leafL_261_7_valid : (leafL_261_7).reject.ValidFor (leafL_261_7).leaf := by decide

noncomputable def leavesL_261 : List RejectedLeaf := [leafL_261_0,leafL_261_1,leafL_261_2,leafL_261_3,leafL_261_4,leafL_261_5,leafL_261_6,leafL_261_7]

theorem leavesL_261_valid : LeafListValid leavesL_261 := by
  intro x hx
  simp only [leavesL_261, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_261_0_valid
  · exact leafL_261_1_valid
  · exact leafL_261_2_valid
  · exact leafL_261_3_valid
  · exact leafL_261_4_valid
  · exact leafL_261_5_valid
  · exact leafL_261_6_valid
  · exact leafL_261_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
