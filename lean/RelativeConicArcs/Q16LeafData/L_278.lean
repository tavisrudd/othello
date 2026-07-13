import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_278_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,163,233}, reject := .fullRank { members := ![0,1,17,34,52,72,163,233], points := ![91,93,96,107,135,138], inverse := ![11,8,10,14,8,14,5,14,5,9,4,3,4,12,8,0,0,0,9,8,14,8,1,6,0,4,4,0,2,2,3,14,13,0,9,9] } }
theorem leafL_278_0_valid : (leafL_278_0).reject.ValidFor (leafL_278_0).leaf := by decide

noncomputable def leafL_278_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,163,263}, reject := .fullRank { members := ![0,1,17,34,52,72,163,263], points := ![90,93,96,112,122,139], inverse := ![0,5,6,4,10,12,7,15,14,1,8,15,4,8,12,0,0,0,7,10,15,5,13,10,12,8,9,13,13,13,0,14,0,14,14,14] } }
theorem leafL_278_1_valid : (leafL_278_1).reject.ValidFor (leafL_278_1).leaf := by decide

noncomputable def leafL_278_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,163,270}, reject := .fullRank { members := ![0,1,17,34,52,72,163,270], points := ![93,96,135,137,138,149], inverse := ![15,7,1,10,8,10,5,3,12,7,2,15,0,0,11,3,8,0,12,8,13,2,9,2,4,4,2,0,2,0,11,11,3,12,15,0] } }
theorem leafL_278_2_valid : (leafL_278_2).reject.ValidFor (leafL_278_2).leaf := by decide

noncomputable def leafL_278_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,169,183}, reject := .fullRank { members := ![0,1,17,34,52,72,169,183], points := ![92,107,117,128,139,149], inverse := ![5,3,12,8,12,15,6,5,10,4,4,9,6,2,5,5,13,9,6,3,14,4,2,13,9,5,3,0,7,8,1,0,6,15,7,15] } }
theorem leafL_278_3_valid : (leafL_278_3).reject.ValidFor (leafL_278_3).leaf := by decide

noncomputable def leafL_278_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,169,269}, reject := .fullRank { members := ![0,1,17,34,52,72,169,269], points := ![92,94,103,107,117,124], inverse := ![2,13,1,9,13,11,6,15,3,13,2,5,8,8,9,9,11,11,2,10,5,10,1,6,4,4,10,10,7,7,8,8,15,15,2,2] } }
theorem leafL_278_4_valid : (leafL_278_4).reject.ValidFor (leafL_278_4).leaf := by decide

noncomputable def leafL_278_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,172,183}, reject := .fullRank { members := ![0,1,17,34,52,72,172,183], points := ![83,91,117,122,128,138], inverse := ![15,8,4,10,0,8,14,9,2,1,10,14,0,0,7,15,8,0,9,14,1,9,0,15,2,2,6,5,3,0,14,14,6,1,7,0] } }
theorem leafL_278_5_valid : (leafL_278_5).reject.ValidFor (leafL_278_5).leaf := by decide

noncomputable def leafL_278_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,172,185}, reject := .fullRank { members := ![0,1,17,34,52,72,172,185], points := ![91,94,96,103,115,125], inverse := ![5,3,9,8,15,9,12,2,7,14,5,2,15,3,12,0,0,0,15,9,14,15,0,7,14,0,14,0,6,6,4,7,3,0,8,8] } }
theorem leafL_278_6_valid : (leafL_278_6).reject.ValidFor (leafL_278_6).leaf := by decide

noncomputable def leafL_278_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,172,208}, reject := .fullRank { members := ![0,1,17,34,52,72,172,208], points := ![90,91,94,103,107,117], inverse := ![15,0,0,8,0,6,12,5,0,2,12,7,10,2,8,0,0,0,11,9,10,10,5,7,11,4,15,14,14,0,2,3,1,10,10,0] } }
theorem leafL_278_7_valid : (leafL_278_7).reject.ValidFor (leafL_278_7).leaf := by decide

noncomputable def leavesL_278 : List RejectedLeaf := [leafL_278_0,leafL_278_1,leafL_278_2,leafL_278_3,leafL_278_4,leafL_278_5,leafL_278_6,leafL_278_7]

theorem leavesL_278_valid : LeafListValid leavesL_278 := by
  intro x hx
  simp only [leavesL_278, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_278_0_valid
  · exact leafL_278_1_valid
  · exact leafL_278_2_valid
  · exact leafL_278_3_valid
  · exact leafL_278_4_valid
  · exact leafL_278_5_valid
  · exact leafL_278_6_valid
  · exact leafL_278_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
