import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_322_0 : RejectedLeaf := { leaf := {0,1,17,34,52,78,167,268}, reject := .fullRank { members := ![0,1,17,34,52,78,167,268], points := ![83,90,104,109,115,120], inverse := ![12,3,14,6,0,6,11,2,12,2,9,14,2,2,13,13,14,14,6,14,1,14,8,15,7,7,1,1,8,8,5,5,5,5,0,0] } }
theorem leafL_322_0_valid : (leafL_322_0).reject.ValidFor (leafL_322_0).leaf := by decide

noncomputable def leafL_322_1 : RejectedLeaf := { leaf := {0,1,17,34,52,78,176,181}, reject := .fullRank { members := ![0,1,17,34,52,78,176,181], points := ![83,86,89,115,120,139], inverse := ![13,6,12,6,8,8,13,7,13,3,10,14,14,11,5,0,0,0,9,13,3,4,12,15,11,4,15,5,5,0,13,8,5,12,12,0] } }
theorem leafL_322_1_valid : (leafL_322_1).reject.ValidFor (leafL_322_1).leaf := by decide

noncomputable def leafL_322_2 : RejectedLeaf := { leaf := {0,1,17,34,52,78,176,263}, reject := .fullRank { members := ![0,1,17,34,52,78,176,263], points := ![86,89,92,104,108,115], inverse := ![11,4,0,1,9,6,7,14,0,3,13,7,12,13,1,0,0,0,0,2,10,1,14,7,1,8,9,14,14,0,8,9,1,10,10,0] } }
theorem leafL_322_2_valid : (leafL_322_2).reject.ValidFor (leafL_322_2).leaf := by decide

noncomputable def leafL_322_3 : RejectedLeaf := { leaf := {0,1,17,34,52,78,181,264}, reject := .fullRank { members := ![0,1,17,34,52,78,181,264], points := ![83,89,103,124,125,139], inverse := ![5,9,11,13,8,3,13,12,6,10,5,8,6,8,14,0,14,14,13,10,0,0,8,15,13,12,1,12,13,1,2,7,5,3,6,5] } }
theorem leafL_322_3_valid : (leafL_322_3).reject.ValidFor (leafL_322_3).leaf := by decide

noncomputable def leafL_322_4 : RejectedLeaf := { leaf := {0,1,17,34,52,78,203,220}, reject := .fullRank { members := ![0,1,17,34,52,78,203,220], points := ![96,103,106,121,137,141], inverse := ![5,8,10,12,14,4,12,12,7,2,8,13,1,10,11,1,10,11,6,2,3,9,0,14,6,6,0,6,15,9,12,5,9,12,14,2] } }
theorem leafL_322_4_valid : (leafL_322_4).reject.ValidFor (leafL_322_4).leaf := by decide

noncomputable def leafL_322_5 : RejectedLeaf := { leaf := {0,1,17,34,52,78,203,233}, reject := .fullRank { members := ![0,1,17,34,52,78,203,233], points := ![108,109,115,128,131,152], inverse := ![1,9,14,6,11,10,7,10,6,7,0,12,10,9,13,6,10,2,2,8,13,0,0,7,4,9,7,5,8,7,11,1,5,10,9,12] } }
theorem leafL_322_5_valid : (leafL_322_5).reject.ValidFor (leafL_322_5).leaf := by decide

noncomputable def leafL_322_6 : RejectedLeaf := { leaf := {0,1,17,34,52,78,203,259}, reject := .fullRank { members := ![0,1,17,34,52,78,203,259], points := ![92,106,108,121,128,140], inverse := ![5,11,9,15,3,10,14,0,9,0,0,7,10,0,10,2,8,10,9,4,10,10,12,1,11,1,10,3,8,11,13,7,10,4,9,13] } }
theorem leafL_322_6_valid : (leafL_322_6).reject.ValidFor (leafL_322_6).leaf := by decide

noncomputable def leafL_322_7 : RejectedLeaf := { leaf := {0,1,17,34,52,79,93,243}, reject := .fullRank { members := ![0,1,17,34,52,79,93,243], points := ![101,106,121,124,137,139], inverse := ![15,8,3,10,4,11,9,14,15,1,5,12,3,3,9,9,6,6,2,5,3,12,5,13,15,15,7,7,14,14,3,3,7,7,15,15] } }
theorem leafL_322_7_valid : (leafL_322_7).reject.ValidFor (leafL_322_7).leaf := by decide

noncomputable def leavesL_322 : List RejectedLeaf := [leafL_322_0,leafL_322_1,leafL_322_2,leafL_322_3,leafL_322_4,leafL_322_5,leafL_322_6,leafL_322_7]

theorem leavesL_322_valid : LeafListValid leavesL_322 := by
  intro x hx
  simp only [leavesL_322, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_322_0_valid
  · exact leafL_322_1_valid
  · exact leafL_322_2_valid
  · exact leafL_322_3_valid
  · exact leafL_322_4_valid
  · exact leafL_322_5_valid
  · exact leafL_322_6_valid
  · exact leafL_322_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
