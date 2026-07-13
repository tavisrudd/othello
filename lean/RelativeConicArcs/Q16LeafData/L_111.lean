import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_111_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,159,262}, reject := .fullRank { members := ![0,1,17,34,52,69,159,262], points := ![91,96,103,120,135,163], inverse := ![0,3,8,8,10,8,15,7,3,4,7,8,12,15,5,2,0,4,10,0,1,7,4,8,9,8,7,0,2,4,6,12,12,11,9,4] } }
theorem leafL_111_0_valid : (leafL_111_0).reject.ValidFor (leafL_111_0).leaf := by decide

noncomputable def leafL_111_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,159,269}, reject := .fullRank { members := ![0,1,17,34,52,69,159,269], points := ![86,89,91,103,104,120], inverse := ![6,12,5,15,7,6,9,9,9,0,14,7,6,2,4,0,0,0,11,3,0,7,8,7,2,4,6,4,4,0,10,15,5,1,1,0] } }
theorem leafL_111_1_valid : (leafL_111_1).reject.ValidFor (leafL_111_1).leaf := by decide

noncomputable def leafL_111_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,159,270}, reject := .fullRank { members := ![0,1,17,34,52,69,159,270], points := ![86,91,104,122,124,135], inverse := ![5,8,10,4,0,2,13,6,12,5,0,2,6,7,1,2,3,1,12,4,15,4,3,0,12,10,6,13,11,6,0,15,15,0,15,15] } }
theorem leafL_111_2_valid : (leafL_111_2).reject.ValidFor (leafL_111_2).leaf := by decide

noncomputable def leafL_111_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,163,183}, reject := .fullRank { members := ![0,1,17,34,52,69,163,183], points := ![86,90,91,107,110,122], inverse := ![11,6,2,11,3,6,9,2,2,8,6,7,15,6,9,0,0,0,12,6,2,0,15,7,0,3,3,11,11,0,9,5,12,6,6,0] } }
theorem leafL_111_3_valid : (leafL_111_3).reject.ValidFor (leafL_111_3).leaf := by decide

noncomputable def leafL_111_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,163,186}, reject := .fullRank { members := ![0,1,17,34,52,69,163,186], points := ![86,91,93,107,112,127], inverse := ![13,7,5,1,9,6,8,8,9,8,6,7,3,13,14,0,0,0,12,4,0,11,4,7,13,3,14,10,10,0,5,3,6,11,11,0] } }
theorem leafL_111_4_valid : (leafL_111_4).reject.ValidFor (leafL_111_4).leaf := by decide

noncomputable def leafL_111_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,163,222}, reject := .fullRank { members := ![0,1,17,34,52,69,163,222], points := ![90,93,96,107,127,137], inverse := ![11,7,13,6,8,14,3,15,1,10,3,4,4,8,12,0,0,0,2,3,0,6,14,9,12,9,9,12,12,12,0,3,0,3,3,3] } }
theorem leafL_111_5_valid : (leafL_111_5).reject.ValidFor (leafL_111_5).leaf := by decide

noncomputable def leafL_111_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,163,232}, reject := .fullRank { members := ![0,1,17,34,52,69,163,232], points := ![86,94,96,107,112,122], inverse := ![9,5,3,4,12,6,15,14,8,5,11,7,8,14,6,0,0,0,8,8,8,6,9,7,2,1,3,10,10,0,13,5,8,11,11,0] } }
theorem leafL_111_6_valid : (leafL_111_6).reject.ValidFor (leafL_111_6).leaf := by decide

noncomputable def leafL_111_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,163,246}, reject := .fullRank { members := ![0,1,17,34,52,69,163,246], points := ![91,94,110,122,127,139], inverse := ![9,2,12,2,0,4,10,4,9,13,13,7,5,15,10,7,13,10,14,1,8,9,9,7,2,1,3,10,9,3,3,3,0,3,3,0] } }
theorem leafL_111_7_valid : (leafL_111_7).reject.ValidFor (leafL_111_7).leaf := by decide

noncomputable def leavesL_111 : List RejectedLeaf := [leafL_111_0,leafL_111_1,leafL_111_2,leafL_111_3,leafL_111_4,leafL_111_5,leafL_111_6,leafL_111_7]

theorem leavesL_111_valid : LeafListValid leavesL_111 := by
  intro x hx
  simp only [leavesL_111, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_111_0_valid
  · exact leafL_111_1_valid
  · exact leafL_111_2_valid
  · exact leafL_111_3_valid
  · exact leafL_111_4_valid
  · exact leafL_111_5_valid
  · exact leafL_111_6_valid
  · exact leafL_111_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
