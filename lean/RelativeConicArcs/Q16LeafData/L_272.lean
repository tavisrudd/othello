import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_272_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,147,169}, reject := .fullRank { members := ![0,1,17,34,52,72,147,169], points := ![92,96,103,124,125,128], inverse := ![1,14,8,4,4,6,14,7,14,5,10,8,0,0,0,8,2,10,5,13,15,0,7,0,4,4,0,15,8,7,15,15,0,15,0,15] } }
theorem leafL_272_0_valid : (leafL_272_0).reject.ValidFor (leafL_272_0).leaf := by decide

noncomputable def leafL_272_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,147,172}, reject := .fullRank { members := ![0,1,17,34,52,72,147,172], points := ![91,96,103,117,122,125], inverse := ![10,5,8,0,1,7,6,15,14,9,4,10,0,0,0,9,10,3,4,12,15,10,3,14,14,14,0,11,1,10,12,12,0,0,12,12] } }
theorem leafL_272_1_valid : (leafL_272_1).reject.ValidFor (leafL_272_1).leaf := by decide

noncomputable def leafL_272_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,147,202}, reject := .fullRank { members := ![0,1,17,34,52,72,147,202], points := ![92,101,103,117,141,143], inverse := ![15,1,9,6,14,14,5,9,11,11,1,13,15,1,14,15,13,2,15,7,15,0,2,5,13,7,10,13,5,8,0,13,13,0,13,13] } }
theorem leafL_272_2_valid : (leafL_272_2).reject.ValidFor (leafL_272_2).leaf := by decide

noncomputable def leafL_272_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,147,203}, reject := .fullRank { members := ![0,1,17,34,52,72,147,203], points := ![92,96,112,122,125,143], inverse := ![6,8,9,13,10,1,12,15,4,9,4,10,4,2,6,3,5,6,11,11,7,0,15,8,15,8,7,15,8,7,13,14,3,4,7,3] } }
theorem leafL_272_3_valid : (leafL_272_3).reject.ValidFor (leafL_272_3).leaf := by decide

noncomputable def leafL_272_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,147,237}, reject := .fullRank { members := ![0,1,17,34,52,72,147,237], points := ![91,96,103,112,122,128], inverse := ![11,4,4,12,2,4,0,9,0,14,0,7,5,5,9,9,11,11,13,5,9,6,7,0,1,1,8,8,0,0,2,2,4,4,13,13] } }
theorem leafL_272_4_valid : (leafL_272_4).reject.ValidFor (leafL_272_4).leaf := by decide

noncomputable def leafL_272_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,147,254}, reject := .fullRank { members := ![0,1,17,34,52,72,147,254], points := ![91,103,122,125,128,138], inverse := ![14,9,3,10,14,1,10,13,12,5,13,3,0,0,4,8,12,0,5,2,6,4,8,13,8,8,1,9,0,8,13,13,5,2,10,13] } }
theorem leafL_272_5_valid : (leafL_272_5).reject.ValidFor (leafL_272_5).leaf := by decide

noncomputable def leafL_272_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,147,263}, reject := .fullRank { members := ![0,1,17,34,52,72,147,263], points := ![92,112,117,122,128,141], inverse := ![13,10,7,2,1,2,14,9,14,2,12,7,0,0,7,15,8,0,7,0,6,14,0,15,13,13,9,13,9,13,5,5,13,12,4,5] } }
theorem leafL_272_6_valid : (leafL_272_6).reject.ValidFor (leafL_272_6).leaf := by decide

noncomputable def leafL_272_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,147,267}, reject := .fullRank { members := ![0,1,17,34,52,72,147,267], points := ![101,112,122,125,128,137], inverse := ![2,5,5,4,8,15,13,10,10,3,7,9,0,0,4,8,12,0,6,1,0,15,0,8,10,10,0,1,1,0,3,3,2,15,13,0] } }
theorem leafL_272_7_valid : (leafL_272_7).reject.ValidFor (leafL_272_7).leaf := by decide

noncomputable def leavesL_272 : List RejectedLeaf := [leafL_272_0,leafL_272_1,leafL_272_2,leafL_272_3,leafL_272_4,leafL_272_5,leafL_272_6,leafL_272_7]

theorem leavesL_272_valid : LeafListValid leavesL_272 := by
  intro x hx
  simp only [leavesL_272, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_272_0_valid
  · exact leafL_272_1_valid
  · exact leafL_272_2_valid
  · exact leafL_272_3_valid
  · exact leafL_272_4_valid
  · exact leafL_272_5_valid
  · exact leafL_272_6_valid
  · exact leafL_272_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
