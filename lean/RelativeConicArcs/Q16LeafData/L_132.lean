import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_132_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,248}, reject := .fullRank { members := ![0,1,17,34,52,70,91,248], points := ![101,109,110,117,137,140], inverse := ![10,1,12,9,0,15,6,9,8,14,11,2,13,15,2,0,0,0,5,3,1,15,1,9,1,3,2,0,8,8,13,6,11,0,7,7] } }
theorem leafL_132_0_valid : (leafL_132_0).reject.ValidFor (leafL_132_0).leaf := by decide

noncomputable def leafL_132_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,266}, reject := .fullRank { members := ![0,1,17,34,52,70,91,266], points := ![101,103,109,117,125,140], inverse := ![0,7,0,9,0,15,0,14,9,8,6,9,14,6,8,0,0,0,9,1,15,2,13,8,4,5,1,2,2,0,5,0,5,5,5,0] } }
theorem leafL_132_1_valid : (leafL_132_1).reject.ValidFor (leafL_132_1).leaf := by decide

noncomputable def leafL_132_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,269}, reject := .fullRank { members := ![0,1,17,34,52,70,91,269], points := ![103,108,110,117,140,144], inverse := ![7,0,0,9,15,0,15,10,2,14,3,10,7,15,8,0,0,0,9,15,1,15,12,4,9,1,8,0,6,6,7,5,2,0,15,15] } }
theorem leafL_132_2_valid : (leafL_132_2).reject.ValidFor (leafL_132_2).leaf := by decide

noncomputable def leafL_132_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,270}, reject := .fullRank { members := ![0,1,17,34,52,70,91,270], points := ![101,104,108,117,127,137], inverse := ![0,8,15,10,3,15,11,8,4,11,5,9,9,6,15,0,0,0,4,5,6,3,12,8,3,0,3,7,7,0,1,10,11,4,4,0] } }
theorem leafL_132_3_valid : (leafL_132_3).reject.ValidFor (leafL_132_3).leaf := by decide

noncomputable def leafL_132_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,104}, reject := .fullRank { members := ![0,1,17,34,52,70,94,104], points := ![127,135,140,172,176,185], inverse := ![5,4,9,4,14,3,8,9,10,6,13,0,7,15,12,14,12,6,15,1,10,7,2,1,0,6,6,15,15,0,13,13,6,13,14,5] } }
theorem leafL_132_4_valid : (leafL_132_4).reject.ValidFor (leafL_132_4).leaf := by decide

noncomputable def leafL_132_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,107}, reject := .fullRank { members := ![0,1,17,34,52,70,94,107], points := ![122,124,127,137,140,151], inverse := ![15,13,6,10,4,11,8,15,4,15,7,11,3,12,15,0,0,0,10,15,7,7,14,11,6,15,9,2,2,0,10,5,15,14,14,0] } }
theorem leafL_132_5_valid : (leafL_132_5).reject.ValidFor (leafL_132_5).leaf := by decide

noncomputable def leafL_132_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,125}, reject := .fullRank { members := ![0,1,17,34,52,70,94,125], points := ![103,135,137,144,151,152], inverse := ![9,7,15,5,13,8,2,4,0,0,6,0,0,6,10,12,0,0,13,9,6,14,9,5,0,4,2,6,13,13,0,13,1,12,8,8] } }
theorem leafL_132_6_valid : (leafL_132_6).reject.ValidFor (leafL_132_6).leaf := by decide

noncomputable def leafL_132_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,133}, reject := .fullRank { members := ![0,1,17,34,52,70,94,133], points := ![103,108,124,127,151,167], inverse := ![8,5,2,2,10,6,14,0,0,0,4,10,8,0,10,3,4,5,13,8,8,0,9,4,13,8,7,4,11,13,9,13,13,0,2,11] } }
theorem leafL_132_7_valid : (leafL_132_7).reject.ValidFor (leafL_132_7).leaf := by decide

noncomputable def leavesL_132 : List RejectedLeaf := [leafL_132_0,leafL_132_1,leafL_132_2,leafL_132_3,leafL_132_4,leafL_132_5,leafL_132_6,leafL_132_7]

theorem leavesL_132_valid : LeafListValid leavesL_132 := by
  intro x hx
  simp only [leavesL_132, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_132_0_valid
  · exact leafL_132_1_valid
  · exact leafL_132_2_valid
  · exact leafL_132_3_valid
  · exact leafL_132_4_valid
  · exact leafL_132_5_valid
  · exact leafL_132_6_valid
  · exact leafL_132_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
