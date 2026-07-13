import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_288_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,218,271}, reject := .fullRank { members := ![0,1,17,34,52,72,218,271], points := ![91,117,124,141,150,176], inverse := ![5,4,14,3,8,5,12,4,14,5,12,15,10,2,9,13,2,14,11,4,7,0,5,13,10,7,3,2,13,1,1,14,8,8,0,15] } }
theorem leafL_288_0_valid : (leafL_288_0).reject.ValidFor (leafL_288_0).leaf := by decide

noncomputable def leafL_288_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,220,237}, reject := .fullRank { members := ![0,1,17,34,52,72,220,237], points := ![90,91,94,103,112,115], inverse := ![14,8,9,7,15,6,3,12,6,7,9,7,10,2,8,0,0,0,15,9,14,10,5,7,8,10,2,8,8,0,6,9,15,2,2,0] } }
theorem leafL_288_1_valid : (leafL_288_1).reject.ValidFor (leafL_288_1).leaf := by decide

noncomputable def leafL_288_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,222,229}, reject := .fullRank { members := ![0,1,17,34,52,72,222,229], points := ![83,108,124,125,137,147], inverse := ![9,2,9,3,8,8,8,4,9,8,14,3,1,3,14,12,13,13,10,10,6,14,3,11,10,11,10,8,12,15,5,14,0,2,10,3] } }
theorem leafL_288_2_valid : (leafL_288_2).reject.ValidFor (leafL_288_2).leaf := by decide

noncomputable def leafL_288_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,222,267}, reject := .fullRank { members := ![0,1,17,34,52,72,222,267], points := ![92,99,112,115,137,144], inverse := ![5,2,0,12,12,6,6,11,10,8,4,11,9,1,8,9,0,9,15,14,6,0,10,13,14,1,15,14,15,1,11,7,12,11,3,8] } }
theorem leafL_288_3_valid : (leafL_288_3).reject.ValidFor (leafL_288_3).leaf := by decide

noncomputable def leafL_288_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,229,263}, reject := .fullRank { members := ![0,1,17,34,52,72,229,263], points := ![90,108,122,141,147,163], inverse := ![7,5,8,13,14,8,12,7,15,12,15,7,0,8,14,7,3,2,10,2,13,15,3,9,1,6,6,10,1,10,3,11,1,8,15,14] } }
theorem leafL_288_4_valid : (leafL_288_4).reject.ValidFor (leafL_288_4).leaf := by decide

noncomputable def leafL_288_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,229,267}, reject := .fullRank { members := ![0,1,17,34,52,72,229,267], points := ![94,108,122,125,128,135], inverse := ![8,15,2,1,2,7,15,8,4,1,4,6,0,0,4,8,12,0,9,14,4,11,9,1,6,6,11,6,11,6,1,1,6,9,14,1] } }
theorem leafL_288_5_valid : (leafL_288_5).reject.ValidFor (leafL_288_5).leaf := by decide

noncomputable def leafL_288_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,229,268}, reject := .fullRank { members := ![0,1,17,34,52,72,229,268], points := ![83,90,91,122,126,137], inverse := ![10,6,11,0,14,8,13,4,14,6,15,14,6,3,5,0,0,0,4,4,7,11,3,15,8,5,13,9,9,0,9,10,3,15,15,0] } }
theorem leafL_288_6_valid : (leafL_288_6).reject.ValidFor (leafL_288_6).leaf := by decide

noncomputable def leafL_288_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,233,254}, reject := .fullRank { members := ![0,1,17,34,52,72,233,254], points := ![91,93,96,101,107,128], inverse := ![9,10,12,9,1,6,13,4,0,5,11,7,4,12,8,0,0,0,6,15,1,8,7,7,8,8,0,12,12,0,1,13,12,3,3,0] } }
theorem leafL_288_7_valid : (leafL_288_7).reject.ValidFor (leafL_288_7).leaf := by decide

noncomputable def leavesL_288 : List RejectedLeaf := [leafL_288_0,leafL_288_1,leafL_288_2,leafL_288_3,leafL_288_4,leafL_288_5,leafL_288_6,leafL_288_7]

theorem leavesL_288_valid : LeafListValid leavesL_288 := by
  intro x hx
  simp only [leavesL_288, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_288_0_valid
  · exact leafL_288_1_valid
  · exact leafL_288_2_valid
  · exact leafL_288_3_valid
  · exact leafL_288_4_valid
  · exact leafL_288_5_valid
  · exact leafL_288_6_valid
  · exact leafL_288_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
