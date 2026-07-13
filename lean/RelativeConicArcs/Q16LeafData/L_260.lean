import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_260_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,108,125}, reject := .fullRank { members := ![0,1,17,34,52,72,108,125], points := ![91,135,137,138,151,159], inverse := ![8,0,4,7,6,12,6,1,7,15,14,1,0,11,3,8,0,0,4,14,0,8,11,9,0,8,13,5,7,7,0,10,4,14,1,1] } }
theorem leafL_260_0_valid : (leafL_260_0).reject.ValidFor (leafL_260_0).leaf := by decide

noncomputable def leafL_260_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,108,138}, reject := .fullRank { members := ![0,1,17,34,52,72,108,138], points := ![115,125,128,166,173,189], inverse := ![3,8,13,1,12,10,0,15,0,0,9,6,12,1,13,0,0,0,10,12,4,7,1,4,2,10,8,10,10,0,8,6,14,3,3,0] } }
theorem leafL_260_1_valid : (leafL_260_1).reject.ValidFor (leafL_260_1).leaf := by decide

noncomputable def leafL_260_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,108,150}, reject := .fullRank { members := ![0,1,17,34,52,72,108,150], points := ![91,93,94,115,122,135], inverse := ![9,4,10,11,5,8,3,13,9,3,10,14,1,7,6,0,0,0,7,1,1,10,2,15,6,2,4,10,10,0,5,1,4,11,11,0] } }
theorem leafL_260_2_valid : (leafL_260_2).reject.ValidFor (leafL_260_2).leaf := by decide

noncomputable def leafL_260_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,108,151}, reject := .fullRank { members := ![0,1,17,34,52,72,108,151], points := ![93,94,115,122,125,141], inverse := ![0,7,14,0,0,8,7,0,0,0,9,14,0,0,15,1,14,0,1,6,3,4,15,15,3,3,14,12,2,0,9,9,13,14,3,0] } }
theorem leafL_260_3_valid : (leafL_260_3).reject.ValidFor (leafL_260_3).leaf := by decide

noncomputable def leafL_260_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,108,169}, reject := .fullRank { members := ![0,1,17,34,52,72,108,169], points := ![94,96,115,125,141,159], inverse := ![7,0,14,0,8,0,14,8,11,11,9,15,6,4,5,4,14,13,15,6,2,13,3,5,11,10,13,4,7,15,10,6,5,3,2,8] } }
theorem leafL_260_4_valid : (leafL_260_4).reject.ValidFor (leafL_260_4).leaf := by decide

noncomputable def leafL_260_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,108,202}, reject := .fullRank { members := ![0,1,17,34,52,72,108,202], points := ![93,135,141,150,159,169], inverse := ![3,12,7,10,15,12,12,3,12,13,11,5,15,11,14,8,12,14,5,6,14,15,11,9,11,11,3,1,14,12,1,13,3,2,4,9] } }
theorem leafL_260_5_valid : (leafL_260_5).reject.ValidFor (leafL_260_5).leaf := by decide

noncomputable def leafL_260_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,108,203}, reject := .fullRank { members := ![0,1,17,34,52,72,108,203], points := ![93,96,115,122,125,141], inverse := ![11,12,11,14,11,8,7,0,0,0,9,14,0,0,15,1,14,0,5,2,11,8,11,15,1,1,10,10,0,0,7,7,2,15,13,0] } }
theorem leafL_260_6_valid : (leafL_260_6).reject.ValidFor (leafL_260_6).leaf := by decide

noncomputable def leafL_260_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,108,207}, reject := .fullRank { members := ![0,1,17,34,52,72,108,207], points := ![91,94,115,128,141,166], inverse := ![0,7,14,0,8,0,7,12,0,7,4,8,4,12,4,1,12,1,6,1,1,9,15,0,10,10,8,8,0,0,4,10,5,7,9,5] } }
theorem leafL_260_7_valid : (leafL_260_7).reject.ValidFor (leafL_260_7).leaf := by decide

noncomputable def leavesL_260 : List RejectedLeaf := [leafL_260_0,leafL_260_1,leafL_260_2,leafL_260_3,leafL_260_4,leafL_260_5,leafL_260_6,leafL_260_7]

theorem leavesL_260_valid : LeafListValid leavesL_260 := by
  intro x hx
  simp only [leavesL_260, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_260_0_valid
  · exact leafL_260_1_valid
  · exact leafL_260_2_valid
  · exact leafL_260_3_valid
  · exact leafL_260_4_valid
  · exact leafL_260_5_valid
  · exact leafL_260_6_valid
  · exact leafL_260_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
