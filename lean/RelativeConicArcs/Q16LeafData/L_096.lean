import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_096_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,131,217}, reject := .fullRank { members := ![0,1,17,34,52,69,131,217], points := ![94,96,120,126,152,154], inverse := ![7,5,9,12,8,14,6,3,12,4,10,7,7,7,15,15,6,6,12,15,12,6,1,8,15,15,4,4,6,6,2,2,15,15,11,11] } }
theorem leafL_096_0_valid : (leafL_096_0).reject.ValidFor (leafL_096_0).leaf := by decide

noncomputable def leafL_096_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,131,218}, reject := .fullRank { members := ![0,1,17,34,52,69,131,218], points := ![89,94,95,110,112,120], inverse := ![15,15,15,8,0,6,13,3,7,13,3,7,4,8,12,0,0,0,12,10,14,3,12,7,15,14,1,2,2,0,4,6,2,9,9,0] } }
theorem leafL_096_1_valid : (leafL_096_1).reject.ValidFor (leafL_096_1).leaf := by decide

noncomputable def leafL_096_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,131,222}, reject := .fullRank { members := ![0,1,17,34,52,69,131,222], points := ![95,96,107,150,156,175], inverse := ![0,3,14,14,7,5,1,9,6,14,2,2,8,6,14,11,5,14,9,2,5,10,4,0,9,4,13,11,6,13,0,4,4,0,4,4] } }
theorem leafL_096_2_valid : (leafL_096_2).reject.ValidFor (leafL_096_2).leaf := by decide

noncomputable def leafL_096_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,131,236}, reject := .fullRank { members := ![0,1,17,34,52,69,131,236], points := ![103,107,110,120,126,152], inverse := ![8,5,1,8,6,3,11,12,10,1,0,12,4,9,13,0,0,0,4,2,12,2,15,7,12,4,8,7,7,0,14,7,9,4,4,0] } }
theorem leafL_096_3_valid : (leafL_096_3).reject.ValidFor (leafL_096_3).leaf := by decide

noncomputable def leafL_096_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,131,240}, reject := .fullRank { members := ![0,1,17,34,52,69,131,240], points := ![92,94,95,110,150,151], inverse := ![6,0,0,11,12,0,5,5,10,4,9,7,4,12,8,0,0,0,5,12,2,5,1,15,12,2,14,0,11,11,0,6,6,0,6,6] } }
theorem leafL_096_4_valid : (leafL_096_4).reject.ValidFor (leafL_096_4).leaf := by decide

noncomputable def leafL_096_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,131,246}, reject := .fullRank { members := ![0,1,17,34,52,69,131,246], points := ![89,94,95,120,126,154], inverse := ![1,0,3,14,11,6,3,15,9,14,6,13,4,8,12,0,0,0,11,8,0,7,13,9,8,2,10,11,11,0,1,5,4,6,6,0] } }
theorem leafL_096_5_valid : (leafL_096_5).reject.ValidFor (leafL_096_5).leaf := by decide

noncomputable def leafL_096_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,131,249}, reject := .fullRank { members := ![0,1,17,34,52,69,131,249], points := ![94,95,103,107,112,120], inverse := ![2,13,12,1,5,6,10,3,15,4,5,7,0,0,7,2,5,0,1,9,14,11,10,7,3,3,13,9,4,0,14,14,1,7,6,0] } }
theorem leafL_096_6_valid : (leafL_096_6).reject.ValidFor (leafL_096_6).leaf := by decide

noncomputable def leafL_096_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,131,254}, reject := .fullRank { members := ![0,1,17,34,52,69,131,254], points := ![89,92,95,103,107,120], inverse := ![14,10,11,11,3,6,6,2,13,8,6,7,12,8,4,0,0,0,10,2,0,0,15,7,2,12,14,14,14,0,6,15,9,10,10,0] } }
theorem leafL_096_7_valid : (leafL_096_7).reject.ValidFor (leafL_096_7).leaf := by decide

noncomputable def leavesL_096 : List RejectedLeaf := [leafL_096_0,leafL_096_1,leafL_096_2,leafL_096_3,leafL_096_4,leafL_096_5,leafL_096_6,leafL_096_7]

theorem leavesL_096_valid : LeafListValid leavesL_096 := by
  intro x hx
  simp only [leavesL_096, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_096_0_valid
  · exact leafL_096_1_valid
  · exact leafL_096_2_valid
  · exact leafL_096_3_valid
  · exact leafL_096_4_valid
  · exact leafL_096_5_valid
  · exact leafL_096_6_valid
  · exact leafL_096_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
