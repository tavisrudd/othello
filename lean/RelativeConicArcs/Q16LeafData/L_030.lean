import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_030_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,246}, reject := .fullRank { members := ![0,1,17,34,52,69,91,246], points := ![104,110,115,120,138,144], inverse := ![5,2,7,14,10,5,0,7,15,1,7,14,15,15,9,9,6,6,0,7,11,4,12,4,10,10,10,10,5,5,2,2,3,3,13,13] } }
theorem leafL_030_0_valid : (leafL_030_0).reject.ValidFor (leafL_030_0).leaf := by decide

noncomputable def leafL_030_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,247}, reject := .fullRank { members := ![0,1,17,34,52,69,91,247], points := ![99,104,106,115,144,150], inverse := ![12,5,4,6,6,12,2,14,13,11,14,4,1,14,15,0,0,0,5,10,7,14,12,10,8,1,8,8,6,15,15,12,8,7,15,3] } }
theorem leafL_030_1_valid : (leafL_030_1).reject.ValidFor (leafL_030_1).leaf := by decide

noncomputable def leafL_030_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,248}, reject := .fullRank { members := ![0,1,17,34,52,69,91,248], points := ![99,110,115,135,137,138], inverse := ![10,13,9,4,15,4,7,0,14,11,15,13,0,0,0,11,3,8,15,8,15,6,2,12,15,15,0,4,2,6,4,4,0,4,0,4] } }
theorem leafL_030_2_valid : (leafL_030_2).reject.ValidFor (leafL_030_2).leaf := by decide

noncomputable def leafL_030_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,259}, reject := .fullRank { members := ![0,1,17,34,52,69,91,259], points := ![106,110,120,137,144,150], inverse := ![0,12,14,0,0,3,4,11,2,1,13,1,0,1,8,12,10,15,15,12,9,2,1,9,11,1,15,14,7,12,15,7,12,9,12,1] } }
theorem leafL_030_3_valid : (leafL_030_3).reject.ValidFor (leafL_030_3).leaf := by decide

noncomputable def leafL_030_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,262}, reject := .fullRank { members := ![0,1,17,34,52,69,91,262], points := ![99,103,106,120,135,137], inverse := ![8,12,3,9,1,14,11,14,2,14,1,8,12,2,14,0,0,0,2,11,14,15,14,6,5,7,2,0,14,14,6,5,3,0,8,8] } }
theorem leafL_030_4_valid : (leafL_030_4).reject.ValidFor (leafL_030_4).leaf := by decide

noncomputable def leafL_030_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,269}, reject := .fullRank { members := ![0,1,17,34,52,69,91,269], points := ![103,110,112,120,135,138], inverse := ![3,3,7,9,8,7,1,2,4,14,13,4,10,11,1,0,0,0,5,6,4,15,11,3,14,15,1,0,7,7,12,14,2,0,4,4] } }
theorem leafL_030_5_valid : (leafL_030_5).reject.ValidFor (leafL_030_5).leaf := by decide

noncomputable def leafL_030_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,270}, reject := .fullRank { members := ![0,1,17,34,52,69,91,270], points := ![104,112,135,137,138,151], inverse := ![9,0,6,12,7,5,15,13,15,3,8,6,0,0,11,3,8,0,8,5,5,10,14,12,12,12,10,7,13,0,14,14,6,13,11,0] } }
theorem leafL_030_6_valid : (leafL_030_6).reject.ValidFor (leafL_030_6).leaf := by decide

noncomputable def leafL_030_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,271}, reject := .fullRank { members := ![0,1,17,34,52,69,91,271], points := ![99,103,104,115,122,137], inverse := ![15,14,6,10,3,15,2,1,4,3,13,9,6,13,11,0,0,0,6,15,14,13,2,8,14,1,15,15,15,0,7,6,1,3,3,0] } }
theorem leafL_030_7_valid : (leafL_030_7).reject.ValidFor (leafL_030_7).leaf := by decide

noncomputable def leavesL_030 : List RejectedLeaf := [leafL_030_0,leafL_030_1,leafL_030_2,leafL_030_3,leafL_030_4,leafL_030_5,leafL_030_6,leafL_030_7]

theorem leavesL_030_valid : LeafListValid leavesL_030 := by
  intro x hx
  simp only [leavesL_030, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_030_0_valid
  · exact leafL_030_1_valid
  · exact leafL_030_2_valid
  · exact leafL_030_3_valid
  · exact leafL_030_4_valid
  · exact leafL_030_5_valid
  · exact leafL_030_6_valid
  · exact leafL_030_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
