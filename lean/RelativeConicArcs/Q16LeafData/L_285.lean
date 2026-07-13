import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_285_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,199,229}, reject := .fullRank { members := ![0,1,17,34,52,72,199,229], points := ![83,90,94,108,122,124], inverse := ![2,5,8,8,11,13,2,10,1,14,0,7,14,12,2,0,0,0,13,10,15,15,6,1,9,14,7,0,1,1,1,8,9,0,13,13] } }
theorem leafL_285_0_valid : (leafL_285_0).reject.ValidFor (leafL_285_0).leaf := by decide

noncomputable def leafL_285_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,199,233}, reject := .fullRank { members := ![0,1,17,34,52,72,199,233], points := ![94,96,101,107,112,115], inverse := ![15,0,6,1,15,6,14,7,6,1,9,7,0,0,15,14,1,0,0,8,5,10,0,7,11,11,7,0,7,0,9,9,11,7,12,0] } }
theorem leafL_285_1_valid : (leafL_285_1).reject.ValidFor (leafL_285_1).leaf := by decide

noncomputable def leafL_285_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,199,268}, reject := .fullRank { members := ![0,1,17,34,52,72,199,268], points := ![83,90,101,107,112,122], inverse := ![1,14,15,10,13,6,0,9,4,7,13,7,0,0,15,14,1,0,11,3,3,14,2,7,2,2,4,8,12,0,5,5,5,0,5,0] } }
theorem leafL_285_2_valid : (leafL_285_2).reject.ValidFor (leafL_285_2).leaf := by decide

noncomputable def leafL_285_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,201,222}, reject := .fullRank { members := ![0,1,17,34,52,72,201,222], points := ![83,90,92,112,124,125], inverse := ![9,3,5,8,1,7,6,9,6,14,3,4,10,11,1,0,0,0,9,11,10,15,1,6,15,15,0,0,12,12,2,4,6,0,3,3] } }
theorem leafL_285_3_valid : (leafL_285_3).reject.ValidFor (leafL_285_3).leaf := by decide

noncomputable def leafL_285_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,201,229}, reject := .fullRank { members := ![0,1,17,34,52,72,201,229], points := ![83,90,91,122,124,143], inverse := ![1,2,4,6,8,8,4,7,4,12,5,14,6,3,5,0,0,0,0,9,14,13,5,15,6,2,4,1,1,0,3,15,12,13,13,0] } }
theorem leafL_285_4_valid : (leafL_285_4).reject.ValidFor (leafL_285_4).leaf := by decide

noncomputable def leafL_285_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,201,237}, reject := .fullRank { members := ![0,1,17,34,52,72,201,237], points := ![90,91,96,103,112,122], inverse := ![2,14,3,14,6,6,10,2,1,4,10,7,12,8,4,0,0,0,0,13,5,9,6,7,0,1,1,8,8,0,15,1,14,2,2,0] } }
theorem leafL_285_5_valid : (leafL_285_5).reject.ValidFor (leafL_285_5).leaf := by decide

noncomputable def leafL_285_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,201,254}, reject := .fullRank { members := ![0,1,17,34,52,72,201,254], points := ![83,90,91,101,122,125], inverse := ![9,10,12,8,6,0,15,2,4,14,6,1,6,3,5,0,0,0,8,12,12,15,3,4,4,3,7,0,5,5,10,2,8,0,12,12] } }
theorem leafL_285_6_valid : (leafL_285_6).reject.ValidFor (leafL_285_6).leaf := by decide

noncomputable def leafL_285_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,201,269}, reject := .fullRank { members := ![0,1,17,34,52,72,201,269], points := ![83,91,92,112,124,128], inverse := ![9,6,0,8,14,8,11,14,12,14,0,7,13,15,2,0,0,0,10,13,15,15,10,13,6,0,6,0,9,9,6,10,12,0,15,15] } }
theorem leafL_285_7_valid : (leafL_285_7).reject.ValidFor (leafL_285_7).leaf := by decide

noncomputable def leavesL_285 : List RejectedLeaf := [leafL_285_0,leafL_285_1,leafL_285_2,leafL_285_3,leafL_285_4,leafL_285_5,leafL_285_6,leafL_285_7]

theorem leavesL_285_valid : LeafListValid leavesL_285 := by
  intro x hx
  simp only [leavesL_285, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_285_0_valid
  · exact leafL_285_1_valid
  · exact leafL_285_2_valid
  · exact leafL_285_3_valid
  · exact leafL_285_4_valid
  · exact leafL_285_5_valid
  · exact leafL_285_6_valid
  · exact leafL_285_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
