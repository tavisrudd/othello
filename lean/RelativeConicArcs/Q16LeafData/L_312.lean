import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_312_0 : RejectedLeaf := { leaf := {0,1,17,34,52,75,104,256}, reject := .fullRank { members := ![0,1,17,34,52,75,104,256], points := ![94,95,117,126,127,138], inverse := ![11,12,9,9,14,8,2,5,1,0,8,14,0,0,11,15,4,0,8,15,2,12,6,15,1,1,14,13,3,0,7,7,0,7,7,0] } }
theorem leafL_312_0_valid : (leafL_312_0).reject.ValidFor (leafL_312_0).leaf := by decide

noncomputable def leafL_312_1 : RejectedLeaf := { leaf := {0,1,17,34,52,75,108,126}, reject := .fullRank { members := ![0,1,17,34,52,75,108,126], points := ![96,131,133,135,154,166], inverse := ![14,6,4,3,13,3,8,13,12,3,13,7,0,5,10,15,0,0,15,4,15,5,13,12,11,15,13,10,15,12,15,13,10,2,4,14] } }
theorem leafL_312_1_valid : (leafL_312_1).reject.ValidFor (leafL_312_1).leaf := by decide

noncomputable def leafL_312_2 : RejectedLeaf := { leaf := {0,1,17,34,52,75,108,173}, reject := .fullRank { members := ![0,1,17,34,52,75,108,173], points := ![86,94,96,126,131,135], inverse := ![9,4,10,14,15,7,8,9,6,9,2,12,8,14,6,0,0,0,7,10,10,8,15,0,15,0,15,0,14,14,3,8,11,0,10,10] } }
theorem leafL_312_2_valid : (leafL_312_2).reject.ValidFor (leafL_312_2).leaf := by decide

noncomputable def leafL_312_3 : RejectedLeaf := { leaf := {0,1,17,34,52,75,108,202}, reject := .fullRank { members := ![0,1,17,34,52,75,108,202], points := ![96,121,126,127,135,141], inverse := ![7,2,7,11,8,0,7,6,11,4,12,2,0,4,8,12,0,0,7,5,6,11,3,12,0,0,12,12,14,14,0,2,10,8,12,12] } }
theorem leafL_312_3_valid : (leafL_312_3).reject.ValidFor (leafL_312_3).leaf := by decide

noncomputable def leafL_312_4 : RejectedLeaf := { leaf := {0,1,17,34,52,75,117,135}, reject := .fullRank { members := ![0,1,17,34,52,75,117,135], points := ![83,104,109,173,174,182], inverse := ![9,0,0,0,10,2,7,0,13,5,13,2,5,4,13,0,10,6,6,11,7,2,10,2,2,5,14,4,0,13,14,2,6,10,5,5] } }
theorem leafL_312_4_valid : (leafL_312_4).reject.ValidFor (leafL_312_4).leaf := by decide

noncomputable def leafL_312_5 : RejectedLeaf := { leaf := {0,1,17,34,52,75,117,154}, reject := .fullRank { members := ![0,1,17,34,52,75,117,154], points := ![83,96,99,104,109,131], inverse := ![7,14,7,6,15,6,14,0,9,0,0,7,0,0,14,1,15,0,7,8,12,6,2,7,7,7,2,1,3,0,4,4,2,3,1,0] } }
theorem leafL_312_5_valid : (leafL_312_5).reject.ValidFor (leafL_312_5).leaf := by decide

noncomputable def leafL_312_6 : RejectedLeaf := { leaf := {0,1,17,34,52,75,117,173}, reject := .fullRank { members := ![0,1,17,34,52,75,117,173], points := ![83,86,104,131,135,154], inverse := ![9,4,3,10,11,14,2,4,0,10,3,15,10,1,8,2,3,2,11,10,3,0,4,6,3,13,11,8,11,6,8,3,8,8,9,2] } }
theorem leafL_312_6_valid : (leafL_312_6).reject.ValidFor (leafL_312_6).leaf := by decide

noncomputable def leafL_312_7 : RejectedLeaf := { leaf := {0,1,17,34,52,75,117,182}, reject := .fullRank { members := ![0,1,17,34,52,75,117,182], points := ![93,104,131,135,154,167], inverse := ![9,15,5,13,7,8,6,4,14,10,0,6,2,8,0,6,1,13,13,2,4,10,15,14,12,2,9,2,0,5,11,11,11,11,11,11] } }
theorem leafL_312_7_valid : (leafL_312_7).reject.ValidFor (leafL_312_7).leaf := by decide

noncomputable def leavesL_312 : List RejectedLeaf := [leafL_312_0,leafL_312_1,leafL_312_2,leafL_312_3,leafL_312_4,leafL_312_5,leafL_312_6,leafL_312_7]

theorem leavesL_312_valid : LeafListValid leavesL_312 := by
  intro x hx
  simp only [leavesL_312, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_312_0_valid
  · exact leafL_312_1_valid
  · exact leafL_312_2_valid
  · exact leafL_312_3_valid
  · exact leafL_312_4_valid
  · exact leafL_312_5_valid
  · exact leafL_312_6_valid
  · exact leafL_312_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
