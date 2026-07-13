import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_290_0 : RejectedLeaf := { leaf := {0,1,17,34,52,73,91,120}, reject := .fullRank { members := ![0,1,17,34,52,73,91,120], points := ![106,109,112,140,141,158], inverse := ![6,10,5,15,2,5,9,12,7,11,15,6,4,8,12,0,0,0,11,7,1,2,3,12,2,2,0,15,15,0,8,4,12,3,3,0] } }
theorem leafL_290_0_valid : (leafL_290_0).reject.ValidFor (leafL_290_0).leaf := by decide

noncomputable def leafL_290_1 : RejectedLeaf := { leaf := {0,1,17,34,52,73,91,140}, reject := .fullRank { members := ![0,1,17,34,52,73,91,140], points := ![99,106,109,115,120,151], inverse := ![1,14,3,10,4,3,11,14,8,11,10,12,15,1,14,0,0,0,0,2,8,3,14,7,6,0,6,14,14,0,0,8,8,8,8,0] } }
theorem leafL_290_1_valid : (leafL_290_1).reject.ValidFor (leafL_290_1).leaf := by decide

noncomputable def leafL_290_2 : RejectedLeaf := { leaf := {0,1,17,34,52,73,91,144}, reject := .fullRank { members := ![0,1,17,34,52,73,91,144], points := ![99,109,110,120,127,147], inverse := ![6,8,2,4,10,3,1,8,4,11,10,12,11,3,8,0,0,0,2,14,6,11,6,7,2,15,13,6,6,0,12,6,10,15,15,0] } }
theorem leafL_290_2_valid : (leafL_290_2).reject.ValidFor (leafL_290_2).leaf := by decide

noncomputable def leafL_290_3 : RejectedLeaf := { leaf := {0,1,17,34,52,73,91,151}, reject := .fullRank { members := ![0,1,17,34,52,73,91,151], points := ![101,110,112,115,125,140], inverse := ![5,12,14,12,5,15,7,12,12,7,9,9,10,1,11,0,0,0,7,8,8,5,10,8,4,4,0,5,5,0,14,3,13,1,1,0] } }
theorem leafL_290_3_valid : (leafL_290_3).reject.ValidFor (leafL_290_3).leaf := by decide

noncomputable def leafL_290_4 : RejectedLeaf := { leaf := {0,1,17,34,52,73,91,158}, reject := .fullRank { members := ![0,1,17,34,52,73,91,158], points := ![99,112,120,127,140,141], inverse := ![4,3,0,9,13,2,12,11,3,13,8,1,10,10,10,10,2,2,6,1,6,9,4,12,2,2,12,12,2,2,6,6,4,4,9,9] } }
theorem leafL_290_4_valid : (leafL_290_4).reject.ValidFor (leafL_290_4).leaf := by decide

noncomputable def leafL_290_5 : RejectedLeaf := { leaf := {0,1,17,34,52,73,91,168}, reject := .fullRank { members := ![0,1,17,34,52,73,91,168], points := ![101,106,109,135,144,147], inverse := ![7,6,8,5,8,5,10,0,8,2,6,6,9,10,3,0,0,0,14,5,6,11,10,12,4,13,9,5,5,0,3,5,6,1,1,0] } }
theorem leafL_290_5_valid : (leafL_290_5).reject.ValidFor (leafL_290_5).leaf := by decide

noncomputable def leafL_290_6 : RejectedLeaf := { leaf := {0,1,17,34,52,73,91,269}, reject := .fullRank { members := ![0,1,17,34,52,73,91,269], points := ![110,112,115,120,135,140], inverse := ![13,10,8,1,7,8,3,4,1,15,6,15,5,5,4,4,1,1,6,1,1,14,13,5,0,0,4,4,11,11,14,14,13,13,12,12] } }
theorem leafL_290_6_valid : (leafL_290_6).reject.ValidFor (leafL_290_6).leaf := by decide

noncomputable def leafL_290_7 : RejectedLeaf := { leaf := {0,1,17,34,52,73,92,126}, reject := .fullRank { members := ![0,1,17,34,52,73,92,126], points := ![101,107,112,133,147,152], inverse := ![9,9,9,13,0,5,12,7,9,4,2,4,15,14,1,0,0,0,2,0,15,1,10,6,6,12,10,0,4,4,0,10,10,0,10,10] } }
theorem leafL_290_7_valid : (leafL_290_7).reject.ValidFor (leafL_290_7).leaf := by decide

noncomputable def leavesL_290 : List RejectedLeaf := [leafL_290_0,leafL_290_1,leafL_290_2,leafL_290_3,leafL_290_4,leafL_290_5,leafL_290_6,leafL_290_7]

theorem leavesL_290_valid : LeafListValid leavesL_290 := by
  intro x hx
  simp only [leavesL_290, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_290_0_valid
  · exact leafL_290_1_valid
  · exact leafL_290_2_valid
  · exact leafL_290_3_valid
  · exact leafL_290_4_valid
  · exact leafL_290_5_valid
  · exact leafL_290_6_valid
  · exact leafL_290_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
