import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_319_0 : RejectedLeaf := { leaf := {0,1,17,34,52,78,109,168}, reject := .fullRank { members := ![0,1,17,34,52,78,109,168], points := ![86,90,96,117,124,143], inverse := ![12,6,13,10,4,8,4,10,9,7,14,14,1,3,2,0,0,0,10,13,0,4,12,15,7,0,7,3,3,0,13,14,3,4,4,0] } }
theorem leafL_319_0_valid : (leafL_319_0).reject.ValidFor (leafL_319_0).leaf := by decide

noncomputable def leafL_319_1 : RejectedLeaf := { leaf := {0,1,17,34,52,78,120,133}, reject := .fullRank { members := ![0,1,17,34,52,78,120,133], points := ![83,103,108,155,163,167], inverse := ![12,15,14,6,5,15,2,8,4,6,5,13,7,4,3,7,15,8,14,3,3,11,1,4,11,14,5,11,11,0,8,9,1,8,13,5] } }
theorem leafL_319_1_valid : (leafL_319_1).reject.ValidFor (leafL_319_1).leaf := by decide

noncomputable def leafL_319_2 : RejectedLeaf := { leaf := {0,1,17,34,52,78,120,137}, reject := .fullRank { members := ![0,1,17,34,52,78,120,137], points := ![83,103,108,109,155,163], inverse := ![15,5,1,6,5,9,4,15,9,12,0,14,0,5,11,14,0,0,4,10,7,7,1,15,11,14,5,0,11,11,9,15,4,2,9,9] } }
theorem leafL_319_2_valid : (leafL_319_2).reject.ValidFor (leafL_319_2).leaf := by decide

noncomputable def leafL_319_3 : RejectedLeaf := { leaf := {0,1,17,34,52,78,120,144}, reject := .fullRank { members := ![0,1,17,34,52,78,120,144], points := ![83,91,99,106,108,149], inverse := ![6,0,0,0,11,12,4,14,15,10,1,14,0,0,10,11,1,0,8,3,13,15,7,14,6,6,9,13,4,0,15,15,8,11,3,0] } }
theorem leafL_319_3_valid : (leafL_319_3).reject.ValidFor (leafL_319_3).leaf := by decide

noncomputable def leafL_319_4 : RejectedLeaf := { leaf := {0,1,17,34,52,78,120,167}, reject := .fullRank { members := ![0,1,17,34,52,78,120,167], points := ![83,91,99,133,137,139], inverse := ![10,3,14,8,11,5,14,0,9,6,14,15,0,0,0,13,5,8,5,10,8,5,9,11,8,8,0,4,0,4,5,5,0,8,10,2] } }
theorem leafL_319_4_valid : (leafL_319_4).reject.ValidFor (leafL_319_4).leaf := by decide

noncomputable def leafL_319_5 : RejectedLeaf := { leaf := {0,1,17,34,52,78,121,203}, reject := .fullRank { members := ![0,1,17,34,52,78,121,203], points := ![83,96,103,106,131,133], inverse := ![2,11,15,1,7,1,3,13,14,7,1,6,6,6,10,10,15,15,8,7,12,4,4,3,10,10,2,2,6,6,8,8,15,15,13,13] } }
theorem leafL_319_5_valid : (leafL_319_5).reject.ValidFor (leafL_319_5).leaf := by decide

noncomputable def leafL_319_6 : RejectedLeaf := { leaf := {0,1,17,34,52,78,121,263}, reject := .fullRank { members := ![0,1,17,34,52,78,121,263], points := ![90,92,96,104,106,133], inverse := ![15,7,1,8,6,6,13,0,3,2,11,7,10,15,5,0,0,0,8,9,14,10,2,7,8,0,8,12,12,0,8,1,9,3,3,0] } }
theorem leafL_319_6_valid : (leafL_319_6).reject.ValidFor (leafL_319_6).leaf := by decide

noncomputable def leafL_319_7 : RejectedLeaf := { leaf := {0,1,17,34,52,78,133,167}, reject := .fullRank { members := ![0,1,17,34,52,78,133,167], points := ![83,90,92,99,120,121], inverse := ![7,1,9,8,2,4,5,3,15,14,11,12,10,11,1,0,0,0,15,12,11,15,3,4,2,1,3,0,3,3,12,14,2,0,4,4] } }
theorem leafL_319_7_valid : (leafL_319_7).reject.ValidFor (leafL_319_7).leaf := by decide

noncomputable def leavesL_319 : List RejectedLeaf := [leafL_319_0,leafL_319_1,leafL_319_2,leafL_319_3,leafL_319_4,leafL_319_5,leafL_319_6,leafL_319_7]

theorem leavesL_319_valid : LeafListValid leavesL_319 := by
  intro x hx
  simp only [leavesL_319, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_319_0_valid
  · exact leafL_319_1_valid
  · exact leafL_319_2_valid
  · exact leafL_319_3_valid
  · exact leafL_319_4_valid
  · exact leafL_319_5_valid
  · exact leafL_319_6_valid
  · exact leafL_319_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
