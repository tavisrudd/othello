import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_294_0 : RejectedLeaf := { leaf := {0,1,17,34,52,73,120,263}, reject := .fullRank { members := ![0,1,17,34,52,73,120,263], points := ![95,96,106,107,109,141], inverse := ![1,8,12,2,0,6,1,15,3,11,1,7,0,0,8,12,4,0,14,1,5,12,1,7,5,5,9,11,2,0,1,1,13,5,8,0] } }
theorem leafL_294_0_valid : (leafL_294_0).reject.ValidFor (leafL_294_0).leaf := by decide

noncomputable def leafL_294_1 : RejectedLeaf := { leaf := {0,1,17,34,52,73,120,269}, reject := .fullRank { members := ![0,1,17,34,52,73,120,269], points := ![91,96,103,112,140,143], inverse := ![2,11,6,8,0,6,7,9,11,2,14,9,13,13,7,7,15,15,6,9,11,3,15,8,1,1,8,8,0,0,8,8,0,0,8,8] } }
theorem leafL_294_1_valid : (leafL_294_1).reject.ValidFor (leafL_294_1).leaf := by decide

noncomputable def leafL_294_2 : RejectedLeaf := { leaf := {0,1,17,34,52,73,124,176}, reject := .fullRank { members := ![0,1,17,34,52,73,124,176], points := ![86,90,95,99,133,135], inverse := ![4,1,12,14,1,7,13,12,15,9,14,9,4,9,13,0,0,0,7,10,2,8,0,7,10,2,8,0,15,15,12,10,6,0,7,7] } }
theorem leafL_294_2_valid : (leafL_294_2).reject.ValidFor (leafL_294_2).leaf := by decide

noncomputable def leafL_294_3 : RejectedLeaf := { leaf := {0,1,17,34,52,73,124,186}, reject := .fullRank { members := ![0,1,17,34,52,73,124,186], points := ![95,103,112,133,135,143], inverse := ![9,3,13,8,11,5,14,1,8,11,13,1,0,0,0,6,14,8,15,13,5,15,3,11,0,7,7,12,12,0,0,1,1,3,9,10] } }
theorem leafL_294_3_valid : (leafL_294_3).reject.ValidFor (leafL_294_3).leaf := by decide

noncomputable def leafL_294_4 : RejectedLeaf := { leaf := {0,1,17,34,52,73,126,140}, reject := .fullRank { members := ![0,1,17,34,52,73,126,140], points := ![86,101,106,107,150,152], inverse := ![6,11,2,2,8,4,10,14,15,5,14,0,0,12,13,1,0,0,11,6,1,2,4,10,0,5,3,6,10,10,0,5,12,9,2,2] } }
theorem leafL_294_4_valid : (leafL_294_4).reject.ValidFor (leafL_294_4).leaf := by decide

noncomputable def leafL_294_5 : RejectedLeaf := { leaf := {0,1,17,34,52,73,126,155}, reject := .fullRank { members := ![0,1,17,34,52,73,126,155], points := ![90,95,101,112,140,144], inverse := ![8,1,4,10,13,11,4,10,14,7,15,8,3,3,7,7,14,14,7,8,4,12,4,3,11,11,9,9,15,15,1,1,7,7,4,4] } }
theorem leafL_294_5_valid : (leafL_294_5).reject.ValidFor (leafL_294_5).leaf := by decide

noncomputable def leafL_294_6 : RejectedLeaf := { leaf := {0,1,17,34,52,73,126,235}, reject := .fullRank { members := ![0,1,17,34,52,73,126,235], points := ![86,101,135,140,143,147], inverse := ![6,11,7,11,12,12,10,4,4,8,12,14,0,0,9,10,3,0,4,0,5,3,0,2,15,5,8,1,15,12,4,13,10,2,15,14] } }
theorem leafL_294_6_valid : (leafL_294_6).reject.ValidFor (leafL_294_6).leaf := by decide

noncomputable def leafL_294_7 : RejectedLeaf := { leaf := {0,1,17,34,52,73,140,163}, reject := .fullRank { members := ![0,1,17,34,52,73,140,163], points := ![86,91,101,107,109,120], inverse := ![1,14,3,9,2,6,1,8,13,3,0,7,0,0,2,9,11,0,14,6,7,10,2,7,14,14,9,0,9,0,8,8,1,10,11,0] } }
theorem leafL_294_7_valid : (leafL_294_7).reject.ValidFor (leafL_294_7).leaf := by decide

noncomputable def leavesL_294 : List RejectedLeaf := [leafL_294_0,leafL_294_1,leafL_294_2,leafL_294_3,leafL_294_4,leafL_294_5,leafL_294_6,leafL_294_7]

theorem leavesL_294_valid : LeafListValid leavesL_294 := by
  intro x hx
  simp only [leavesL_294, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_294_0_valid
  · exact leafL_294_1_valid
  · exact leafL_294_2_valid
  · exact leafL_294_3_valid
  · exact leafL_294_4_valid
  · exact leafL_294_5_valid
  · exact leafL_294_6_valid
  · exact leafL_294_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
