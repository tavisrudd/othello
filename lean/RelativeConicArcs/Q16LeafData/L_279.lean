import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_279_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,172,243}, reject := .fullRank { members := ![0,1,17,34,52,72,172,243], points := ![90,94,107,117,125,138], inverse := ![0,10,13,8,11,5,15,13,5,11,7,11,13,5,8,13,5,8,6,5,4,13,1,11,3,2,1,10,11,1,7,2,5,6,3,5] } }
theorem leafL_279_0_valid : (leafL_279_0).reject.ValidFor (leafL_279_0).leaf := by decide

noncomputable def leafL_279_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,172,251}, reject := .fullRank { members := ![0,1,17,34,52,72,172,251], points := ![83,94,96,103,122,125], inverse := ![4,11,0,8,1,7,11,12,14,14,14,9,6,4,2,0,0,0,6,14,0,15,0,7,14,13,3,0,5,5,9,3,10,0,12,12] } }
theorem leafL_279_1_valid : (leafL_279_1).reject.ValidFor (leafL_279_1).leaf := by decide

noncomputable def leafL_279_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,172,267}, reject := .fullRank { members := ![0,1,17,34,52,72,172,267], points := ![94,115,122,125,135,141], inverse := ![7,14,0,0,0,8,7,12,6,3,4,10,0,15,1,14,0,0,7,13,3,6,11,4,0,15,5,10,14,14,0,10,4,14,12,12] } }
theorem leafL_279_2_valid : (leafL_279_2).reject.ValidFor (leafL_279_2).leaf := by decide

noncomputable def leafL_279_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,172,270}, reject := .fullRank { members := ![0,1,17,34,52,72,172,270], points := ![83,96,128,135,138,139], inverse := ![6,1,14,2,15,5,0,7,9,12,4,6,0,0,0,15,9,6,7,0,8,9,3,5,5,5,0,11,0,11,13,13,0,3,7,4] } }
theorem leafL_279_3_valid : (leafL_279_3).reject.ValidFor (leafL_279_3).leaf := by decide

noncomputable def leafL_279_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,172,271}, reject := .fullRank { members := ![0,1,17,34,52,72,172,271], points := ![91,94,103,115,117,122], inverse := ![3,12,8,12,7,13,14,7,14,15,6,14,0,0,0,8,15,7,11,3,15,15,10,2,10,10,0,0,8,8,3,3,0,14,4,10] } }
theorem leafL_279_4_valid : (leafL_279_4).reject.ValidFor (leafL_279_4).leaf := by decide

noncomputable def leafL_279_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,174,186}, reject := .fullRank { members := ![0,1,17,34,52,72,174,186], points := ![91,99,101,103,117,124], inverse := ![15,2,11,1,7,1,9,5,8,3,13,10,0,5,10,15,0,0,8,12,12,15,8,15,0,13,8,5,11,11,0,4,15,11,9,9] } }
theorem leafL_279_5_valid : (leafL_279_5).reject.ValidFor (leafL_279_5).leaf := by decide

noncomputable def leafL_279_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,174,198}, reject := .fullRank { members := ![0,1,17,34,52,72,174,198], points := ![91,92,99,101,137,138], inverse := ![0,9,6,8,5,3,11,5,10,3,2,5,4,4,1,1,2,2,14,1,15,7,5,2,8,8,1,1,15,15,14,14,0,0,14,14] } }
theorem leafL_279_6_valid : (leafL_279_6).reject.ValidFor (leafL_279_6).leaf := by decide

noncomputable def leafL_279_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,174,199}, reject := .fullRank { members := ![0,1,17,34,52,72,174,199], points := ![101,112,117,122,124,137], inverse := ![2,5,6,10,5,15,13,10,4,4,14,9,0,0,6,2,4,0,6,1,6,14,7,8,10,10,10,14,4,0,3,3,1,9,8,0] } }
theorem leafL_279_7_valid : (leafL_279_7).reject.ValidFor (leafL_279_7).leaf := by decide

noncomputable def leavesL_279 : List RejectedLeaf := [leafL_279_0,leafL_279_1,leafL_279_2,leafL_279_3,leafL_279_4,leafL_279_5,leafL_279_6,leafL_279_7]

theorem leavesL_279_valid : LeafListValid leavesL_279 := by
  intro x hx
  simp only [leavesL_279, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_279_0_valid
  · exact leafL_279_1_valid
  · exact leafL_279_2_valid
  · exact leafL_279_3_valid
  · exact leafL_279_4_valid
  · exact leafL_279_5_valid
  · exact leafL_279_6_valid
  · exact leafL_279_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
