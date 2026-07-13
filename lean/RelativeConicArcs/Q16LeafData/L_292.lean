import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_292_0 : RejectedLeaf := { leaf := {0,1,17,34,52,73,103,173}, reject := .fullRank { members := ![0,1,17,34,52,73,103,173], points := ![86,96,124,127,147,158], inverse := ![1,3,1,4,4,2,1,4,9,1,0,13,2,2,15,15,8,8,8,11,14,4,13,4,9,9,14,14,13,13,9,9,9,9,9,9] } }
theorem leafL_292_0_valid : (leafL_292_0).reject.ValidFor (leafL_292_0).leaf := by decide

noncomputable def leafL_292_1 : RejectedLeaf := { leaf := {0,1,17,34,52,73,103,186}, reject := .fullRank { members := ![0,1,17,34,52,73,103,186], points := ![86,95,96,124,125,143], inverse := ![10,14,3,0,14,8,11,5,9,6,15,14,9,5,12,0,0,0,7,3,3,11,3,15,15,15,0,12,12,0,8,6,14,3,3,0] } }
theorem leafL_292_1_valid : (leafL_292_1).reject.ValidFor (leafL_292_1).leaf := by decide

noncomputable def leafL_292_2 : RejectedLeaf := { leaf := {0,1,17,34,52,73,103,190}, reject := .fullRank { members := ![0,1,17,34,52,73,103,190], points := ![86,96,120,127,133,143], inverse := ![8,15,14,0,12,4,3,4,9,0,2,12,13,13,15,15,9,9,14,9,9,1,15,0,4,4,12,12,6,6,4,4,0,0,4,4] } }
theorem leafL_292_2_valid : (leafL_292_2).reject.ValidFor (leafL_292_2).leaf := by decide

noncomputable def leafL_292_3 : RejectedLeaf := { leaf := {0,1,17,34,52,73,103,214}, reject := .fullRank { members := ![0,1,17,34,52,73,103,214], points := ![96,120,127,128,133,143], inverse := ![7,2,8,4,15,7,7,2,3,8,4,10,0,13,2,15,0,0,7,0,15,7,0,15,0,10,8,2,14,14,0,6,4,2,12,12] } }
theorem leafL_292_3_valid : (leafL_292_3).reject.ValidFor (leafL_292_3).leaf := by decide

noncomputable def leafL_292_4 : RejectedLeaf := { leaf := {0,1,17,34,52,73,103,235}, reject := .fullRank { members := ![0,1,17,34,52,73,103,235], points := ![86,96,120,124,125,143], inverse := ![14,9,6,4,12,8,2,5,4,15,2,14,0,0,4,9,13,0,0,7,13,12,9,15,7,7,12,4,8,0,6,6,9,13,4,0] } }
theorem leafL_292_4_valid : (leafL_292_4).reject.ValidFor (leafL_292_4).leaf := by decide

noncomputable def leafL_292_5 : RejectedLeaf := { leaf := {0,1,17,34,52,73,103,243}, reject := .fullRank { members := ![0,1,17,34,52,73,103,243], points := ![86,95,96,125,127,133], inverse := ![10,0,13,7,9,8,0,4,3,11,2,14,9,5,12,0,0,0,13,13,7,15,7,15,10,11,1,1,1,0,4,7,3,13,13,0] } }
theorem leafL_292_5_valid : (leafL_292_5).reject.ValidFor (leafL_292_5).leaf := by decide

noncomputable def leafL_292_6 : RejectedLeaf := { leaf := {0,1,17,34,52,73,110,144}, reject := .fullRank { members := ![0,1,17,34,52,73,110,144], points := ![90,91,125,147,155,156], inverse := ![13,15,5,7,15,14,10,15,8,13,10,10,0,0,0,13,15,2,8,11,10,7,1,15,5,5,0,3,6,5,6,6,0,5,1,4] } }
theorem leafL_292_6_valid : (leafL_292_6).reject.ValidFor (leafL_292_6).leaf := by decide

noncomputable def leafL_292_7 : RejectedLeaf := { leaf := {0,1,17,34,52,73,110,155}, reject := .fullRank { members := ![0,1,17,34,52,73,110,155], points := ![90,115,133,144,163,172], inverse := ![4,4,11,8,8,10,14,10,12,6,1,15,3,10,1,10,4,6,2,5,9,8,14,8,13,8,4,6,15,8,10,9,9,6,13,1] } }
theorem leafL_292_7_valid : (leafL_292_7).reject.ValidFor (leafL_292_7).leaf := by decide

noncomputable def leavesL_292 : List RejectedLeaf := [leafL_292_0,leafL_292_1,leafL_292_2,leafL_292_3,leafL_292_4,leafL_292_5,leafL_292_6,leafL_292_7]

theorem leavesL_292_valid : LeafListValid leavesL_292 := by
  intro x hx
  simp only [leavesL_292, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_292_0_valid
  · exact leafL_292_1_valid
  · exact leafL_292_2_valid
  · exact leafL_292_3_valid
  · exact leafL_292_4_valid
  · exact leafL_292_5_valid
  · exact leafL_292_6_valid
  · exact leafL_292_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
