import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_284_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,191,222}, reject := .fullRank { members := ![0,1,17,34,52,72,191,222], points := ![92,96,99,108,112,117], inverse := ![1,14,4,12,0,6,3,10,4,15,5,7,0,0,8,9,1,0,4,12,4,8,3,7,12,12,6,3,5,0,13,13,0,13,13,0] } }
theorem leafL_284_0_valid : (leafL_284_0).reject.ValidFor (leafL_284_0).leaf := by decide

noncomputable def leafL_284_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,191,267}, reject := .fullRank { members := ![0,1,17,34,52,72,191,267], points := ![92,94,101,108,112,122], inverse := ![14,1,14,7,1,6,14,7,0,9,7,7,0,0,14,2,12,0,11,3,3,4,8,7,8,8,11,14,5,0,7,7,15,9,6,0] } }
theorem leafL_284_1_valid : (leafL_284_1).reject.ValidFor (leafL_284_1).leaf := by decide

noncomputable def leafL_284_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,197,220}, reject := .fullRank { members := ![0,1,17,34,52,72,197,220], points := ![99,103,115,128,137,139], inverse := ![15,8,1,8,10,5,3,4,5,11,9,0,12,12,14,14,14,14,8,15,3,12,3,11,6,6,8,8,4,4,8,8,1,1,12,12] } }
theorem leafL_284_2_valid : (leafL_284_2).reject.ValidFor (leafL_284_2).leaf := by decide

noncomputable def leafL_284_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,197,222}, reject := .fullRank { members := ![0,1,17,34,52,72,197,222], points := ![83,92,99,107,115,125], inverse := ![15,0,1,9,12,10,9,0,14,0,7,0,15,15,6,6,14,14,1,9,14,1,8,15,13,13,1,1,10,10,13,13,9,9,14,14] } }
theorem leafL_284_3_valid : (leafL_284_3).reject.ValidFor (leafL_284_3).leaf := by decide

noncomputable def leafL_284_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,197,237}, reject := .fullRank { members := ![0,1,17,34,52,72,197,237], points := ![83,94,103,107,115,122], inverse := ![2,13,13,5,2,4,2,11,2,12,2,5,12,12,10,10,11,11,0,8,10,5,2,5,9,9,3,3,14,14,15,15,7,7,14,14] } }
theorem leafL_284_4_valid : (leafL_284_4).reject.ValidFor (leafL_284_4).leaf := by decide

noncomputable def leafL_284_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,198,218}, reject := .fullRank { members := ![0,1,17,34,52,72,198,218], points := ![91,96,108,117,151,169], inverse := ![4,7,4,6,12,12,1,7,14,2,1,11,13,2,10,3,4,2,5,5,1,5,11,15,12,6,4,11,13,8,6,5,0,1,11,9] } }
theorem leafL_284_5_valid : (leafL_284_5).reject.ValidFor (leafL_284_5).leaf := by decide

noncomputable def leafL_284_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,198,237}, reject := .fullRank { members := ![0,1,17,34,52,72,198,237], points := ![91,96,115,128,138,144], inverse := ![3,4,2,12,10,2,0,7,0,9,0,14,10,10,5,5,13,13,13,10,6,14,15,0,7,7,5,5,8,8,2,2,5,5,1,1] } }
theorem leafL_284_6_valid : (leafL_284_6).reject.ValidFor (leafL_284_6).leaf := by decide

noncomputable def leafL_284_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,199,213}, reject := .fullRank { members := ![0,1,17,34,52,72,199,213], points := ![83,96,107,108,112,122], inverse := ![9,6,14,1,7,6,12,5,2,2,14,7,0,0,11,13,6,0,5,13,10,15,10,7,7,7,3,6,5,0,4,4,12,2,14,0] } }
theorem leafL_284_7_valid : (leafL_284_7).reject.ValidFor (leafL_284_7).leaf := by decide

noncomputable def leavesL_284 : List RejectedLeaf := [leafL_284_0,leafL_284_1,leafL_284_2,leafL_284_3,leafL_284_4,leafL_284_5,leafL_284_6,leafL_284_7]

theorem leavesL_284_valid : LeafListValid leavesL_284 := by
  intro x hx
  simp only [leavesL_284, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_284_0_valid
  · exact leafL_284_1_valid
  · exact leafL_284_2_valid
  · exact leafL_284_3_valid
  · exact leafL_284_4_valid
  · exact leafL_284_5_valid
  · exact leafL_284_6_valid
  · exact leafL_284_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
