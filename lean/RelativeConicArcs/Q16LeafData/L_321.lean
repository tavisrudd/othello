import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_321_0 : RejectedLeaf := { leaf := {0,1,17,34,52,78,144,233}, reject := .fullRank { members := ![0,1,17,34,52,78,144,233], points := ![86,91,99,109,117,149], inverse := ![13,13,8,4,14,3,2,6,15,9,4,6,7,9,5,7,4,8,6,6,14,4,13,7,10,2,13,8,10,7,15,1,6,4,4,8] } }
theorem leafL_321_0_valid : (leafL_321_0).reject.ValidFor (leafL_321_0).leaf := by decide

noncomputable def leafL_321_1 : RejectedLeaf := { leaf := {0,1,17,34,52,78,151,249}, reject := .fullRank { members := ![0,1,17,34,52,78,151,249], points := ![86,117,120,125,140,141], inverse := ![7,15,3,2,3,11,7,2,3,8,1,15,0,5,3,6,0,0,7,4,8,4,15,0,0,2,7,5,7,7,0,9,2,11,6,6] } }
theorem leafL_321_1_valid : (leafL_321_1).reject.ValidFor (leafL_321_1).leaf := by decide

noncomputable def leafL_321_2 : RejectedLeaf := { leaf := {0,1,17,34,52,78,152,256}, reject := .fullRank { members := ![0,1,17,34,52,78,152,256], points := ![90,92,99,109,115,121], inverse := ![3,12,7,15,14,8,12,5,2,12,12,11,9,9,2,2,4,4,10,2,11,4,3,4,1,1,2,2,15,15,15,15,8,8,5,5] } }
theorem leafL_321_2_valid : (leafL_321_2).reject.ValidFor (leafL_321_2).leaf := by decide

noncomputable def leafL_321_3 : RejectedLeaf := { leaf := {0,1,17,34,52,78,152,259}, reject := .fullRank { members := ![0,1,17,34,52,78,152,259], points := ![86,90,92,121,124,139], inverse := ![10,6,11,7,9,8,2,4,1,7,14,14,13,5,8,0,0,0,7,7,7,10,2,15,0,8,8,15,15,0,15,6,9,7,7,0] } }
theorem leafL_321_3_valid : (leafL_321_3).reject.ValidFor (leafL_321_3).leaf := by decide

noncomputable def leafL_321_4 : RejectedLeaf := { leaf := {0,1,17,34,52,78,154,198}, reject := .fullRank { members := ![0,1,17,34,52,78,154,198], points := ![83,96,99,104,124,128], inverse := ![7,8,4,12,13,11,10,3,2,12,2,5,15,15,9,9,3,3,1,9,14,1,7,0,4,4,6,6,14,14,5,5,15,15,11,11] } }
theorem leafL_321_4_valid : (leafL_321_4).reject.ValidFor (leafL_321_4).leaf := by decide

noncomputable def leafL_321_5 : RejectedLeaf := { leaf := {0,1,17,34,52,78,154,224}, reject := .fullRank { members := ![0,1,17,34,52,78,154,224], points := ![89,91,99,103,124,133], inverse := ![6,14,4,11,1,7,8,9,6,0,15,8,7,1,1,7,6,6,4,14,13,0,5,2,1,2,8,11,3,3,8,15,11,12,7,7] } }
theorem leafL_321_5_valid : (leafL_321_5).reject.ValidFor (leafL_321_5).leaf := by decide

noncomputable def leafL_321_6 : RejectedLeaf := { leaf := {0,1,17,34,52,78,155,168}, reject := .fullRank { members := ![0,1,17,34,52,78,155,168], points := ![89,92,96,109,117,124], inverse := ![10,8,13,8,15,9,3,13,7,14,5,2,2,10,8,0,0,0,15,8,15,15,0,7,2,14,12,0,3,3,11,14,5,0,4,4] } }
theorem leafL_321_6_valid : (leafL_321_6).reject.ValidFor (leafL_321_6).leaf := by decide

noncomputable def leafL_321_7 : RejectedLeaf := { leaf := {0,1,17,34,52,78,155,199}, reject := .fullRank { members := ![0,1,17,34,52,78,155,199], points := ![83,89,90,117,124,133], inverse := ![10,11,6,2,12,8,13,3,9,9,0,14,9,12,5,0,0,0,3,9,13,11,3,15,7,7,0,3,3,0,10,11,1,4,4,0] } }
theorem leafL_321_7_valid : (leafL_321_7).reject.ValidFor (leafL_321_7).leaf := by decide

noncomputable def leavesL_321 : List RejectedLeaf := [leafL_321_0,leafL_321_1,leafL_321_2,leafL_321_3,leafL_321_4,leafL_321_5,leafL_321_6,leafL_321_7]

theorem leavesL_321_valid : LeafListValid leavesL_321 := by
  intro x hx
  simp only [leavesL_321, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_321_0_valid
  · exact leafL_321_1_valid
  · exact leafL_321_2_valid
  · exact leafL_321_3_valid
  · exact leafL_321_4_valid
  · exact leafL_321_5_valid
  · exact leafL_321_6_valid
  · exact leafL_321_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
