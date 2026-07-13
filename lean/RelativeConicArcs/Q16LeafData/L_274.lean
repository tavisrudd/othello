import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_274_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,149,270}, reject := .fullRank { members := ![0,1,17,34,52,72,149,270], points := ![128,141,163,176,183,185], inverse := ![14,15,12,11,11,12,8,3,3,8,3,3,14,6,6,2,0,12,12,6,1,3,13,5,13,11,0,3,9,12,14,6,11,15,1,13] } }
theorem leafL_274_0_valid : (leafL_274_0).reject.ValidFor (leafL_274_0).leaf := by decide

noncomputable def leafL_274_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,150,163}, reject := .fullRank { members := ![0,1,17,34,52,72,150,163], points := ![90,91,93,103,107,126], inverse := ![8,5,2,1,9,6,13,8,12,1,15,7,8,12,4,0,0,0,1,0,9,9,6,7,12,2,14,14,14,0,15,6,9,10,10,0] } }
theorem leafL_274_1_valid : (leafL_274_1).reject.ValidFor (leafL_274_1).leaf := by decide

noncomputable def leafL_274_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,150,169}, reject := .fullRank { members := ![0,1,17,34,52,72,150,169], points := ![90,94,103,107,115,117], inverse := ![15,0,8,0,0,6,4,13,6,8,4,3,4,4,7,7,7,7,1,9,15,0,5,2,4,4,0,0,14,14,11,11,7,7,13,13] } }
theorem leafL_274_2_valid : (leafL_274_2).reject.ValidFor (leafL_274_2).leaf := by decide

noncomputable def leafL_274_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,150,271}, reject := .fullRank { members := ![0,1,17,34,52,72,150,271], points := ![90,91,93,103,115,117], inverse := ![15,0,0,8,0,6,6,13,2,14,12,11,8,12,4,0,0,0,14,11,13,15,5,2,5,7,2,0,14,14,0,10,10,0,10,10] } }
theorem leafL_274_3_valid : (leafL_274_3).reject.ValidFor (leafL_274_3).leaf := by decide

noncomputable def leafL_274_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,151,185}, reject := .fullRank { members := ![0,1,17,34,52,72,151,185], points := ![91,92,93,99,115,117], inverse := ![8,7,0,8,9,15,3,8,2,14,7,0,7,6,1,0,0,0,2,11,1,15,0,7,8,7,15,0,14,14,10,0,10,0,10,10] } }
theorem leafL_274_4_valid : (leafL_274_4).reject.ValidFor (leafL_274_4).leaf := by decide

noncomputable def leafL_274_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,151,198}, reject := .fullRank { members := ![0,1,17,34,52,72,151,198], points := ![90,92,93,99,101,115], inverse := ![6,12,5,5,13,6,1,12,4,14,0,7,12,3,15,0,0,0,8,13,13,1,14,7,7,8,15,15,15,0,12,5,9,7,7,0] } }
theorem leafL_274_5_valid : (leafL_274_5).reject.ValidFor (leafL_274_5).leaf := by decide

noncomputable def leafL_274_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,151,201}, reject := .fullRank { members := ![0,1,17,34,52,72,151,201], points := ![90,91,99,101,112,122], inverse := ![7,8,12,7,3,6,9,0,14,14,14,7,0,0,15,8,7,0,15,7,6,2,11,7,3,3,6,9,15,0,14,14,1,9,8,0] } }
theorem leafL_274_6_valid : (leafL_274_6).reject.ValidFor (leafL_274_6).leaf := by decide

noncomputable def leafL_274_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,151,208}, reject := .fullRank { members := ![0,1,17,34,52,72,151,208], points := ![90,91,94,101,108,117], inverse := ![1,8,6,3,11,6,8,15,14,14,0,7,10,2,8,0,0,0,2,5,15,9,6,7,10,15,5,6,6,0,15,5,10,8,8,0] } }
theorem leafL_274_7_valid : (leafL_274_7).reject.ValidFor (leafL_274_7).leaf := by decide

noncomputable def leavesL_274 : List RejectedLeaf := [leafL_274_0,leafL_274_1,leafL_274_2,leafL_274_3,leafL_274_4,leafL_274_5,leafL_274_6,leafL_274_7]

theorem leavesL_274_valid : LeafListValid leavesL_274 := by
  intro x hx
  simp only [leavesL_274, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_274_0_valid
  · exact leafL_274_1_valid
  · exact leafL_274_2_valid
  · exact leafL_274_3_valid
  · exact leafL_274_4_valid
  · exact leafL_274_5_valid
  · exact leafL_274_6_valid
  · exact leafL_274_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
