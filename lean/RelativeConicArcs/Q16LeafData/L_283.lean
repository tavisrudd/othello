import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_283_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,186,229}, reject := .fullRank { members := ![0,1,17,34,52,72,186,229], points := ![91,108,124,125,128,135], inverse := ![12,11,13,3,11,3,1,6,13,8,10,8,0,0,8,2,10,0,4,3,15,13,9,12,5,5,7,0,2,5,8,8,2,13,7,8] } }
theorem leafL_283_0_valid : (leafL_283_0).reject.ValidFor (leafL_283_0).leaf := by decide

noncomputable def leafL_283_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,186,237}, reject := .fullRank { members := ![0,1,17,34,52,72,186,237], points := ![91,96,103,107,112,115], inverse := ![6,9,0,2,10,6,3,10,12,13,15,7,0,0,7,2,5,0,0,8,12,14,13,7,1,1,8,0,8,0,11,11,0,11,11,0] } }
theorem leafL_283_1_valid : (leafL_283_1).reject.ValidFor (leafL_283_1).leaf := by decide

noncomputable def leafL_283_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,186,263}, reject := .fullRank { members := ![0,1,17,34,52,72,186,263], points := ![96,101,107,112,115,117], inverse := ![15,7,12,3,5,3,9,15,14,15,15,8,0,15,14,1,0,0,8,5,10,0,7,0,0,0,5,5,9,9,0,15,6,9,12,12] } }
theorem leafL_283_2_valid : (leafL_283_2).reject.ValidFor (leafL_283_2).leaf := by decide

noncomputable def leafL_283_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,188,254}, reject := .fullRank { members := ![0,1,17,34,52,72,188,254], points := ![90,91,93,103,122,125], inverse := ![5,15,5,8,1,7,7,5,11,14,14,9,8,12,4,0,0,0,1,10,3,15,0,7,0,9,9,0,5,5,12,0,12,0,12,12] } }
theorem leafL_283_3_valid : (leafL_283_3).reject.ValidFor (leafL_283_3).leaf := by decide

noncomputable def leafL_283_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,190,208}, reject := .fullRank { members := ![0,1,17,34,52,72,190,208], points := ![90,101,107,125,135,141], inverse := ![6,15,14,15,11,2,11,10,6,5,6,4,3,14,13,3,4,7,5,8,10,10,2,15,12,0,12,12,14,2,6,7,1,6,14,8] } }
theorem leafL_283_4_valid : (leafL_283_4).reject.ValidFor (leafL_283_4).leaf := by decide

noncomputable def leafL_283_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,190,213}, reject := .fullRank { members := ![0,1,17,34,52,72,190,213], points := ![83,96,99,107,122,139], inverse := ![9,10,11,15,10,12,12,14,5,0,12,11,0,9,2,11,9,9,5,3,14,15,9,14,7,2,14,11,5,5,4,15,5,14,11,11] } }
theorem leafL_283_5_valid : (leafL_283_5).reject.ValidFor (leafL_283_5).leaf := by decide

noncomputable def leafL_283_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,191,199}, reject := .fullRank { members := ![0,1,17,34,52,72,191,199], points := ![90,94,96,99,101,122], inverse := ![10,3,6,0,8,6,3,13,7,3,13,7,5,15,10,0,0,0,5,9,4,12,3,7,5,4,1,15,15,0,7,0,7,7,7,0] } }
theorem leafL_283_6_valid : (leafL_283_6).reject.ValidFor (leafL_283_6).leaf := by decide

noncomputable def leafL_283_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,191,213}, reject := .fullRank { members := ![0,1,17,34,52,72,191,213], points := ![91,92,99,103,108,126], inverse := ![8,7,9,2,3,6,3,10,6,4,12,7,0,0,9,1,8,0,8,0,9,3,5,7,5,5,2,7,5,0,1,1,6,8,14,0] } }
theorem leafL_283_7_valid : (leafL_283_7).reject.ValidFor (leafL_283_7).leaf := by decide

noncomputable def leavesL_283 : List RejectedLeaf := [leafL_283_0,leafL_283_1,leafL_283_2,leafL_283_3,leafL_283_4,leafL_283_5,leafL_283_6,leafL_283_7]

theorem leavesL_283_valid : LeafListValid leavesL_283 := by
  intro x hx
  simp only [leavesL_283, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_283_0_valid
  · exact leafL_283_1_valid
  · exact leafL_283_2_valid
  · exact leafL_283_3_valid
  · exact leafL_283_4_valid
  · exact leafL_283_5_valid
  · exact leafL_283_6_valid
  · exact leafL_283_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
