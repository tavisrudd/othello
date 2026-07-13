import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_048_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,182}, reject := .fullRank { members := ![0,1,17,34,52,69,95,182], points := ![99,103,106,115,124,131], inverse := ![3,9,13,5,12,15,7,0,0,14,0,9,12,2,14,0,0,0,2,9,12,2,13,8,9,9,0,6,6,0,11,13,6,15,15,0] } }
theorem leafL_048_0_valid : (leafL_048_0).reject.ValidFor (leafL_048_0).leaf := by decide

noncomputable def leafL_048_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,183}, reject := .fullRank { members := ![0,1,17,34,52,69,95,183], points := ![106,107,120,126,131,137], inverse := ![14,9,13,4,2,13,3,4,14,0,4,13,15,15,5,5,14,14,7,0,0,15,12,4,12,12,6,6,8,8,0,0,12,12,12,12] } }
theorem leafL_048_1_valid : (leafL_048_1).reject.ValidFor (leafL_048_1).leaf := by decide

noncomputable def leafL_048_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,184}, reject := .fullRank { members := ![0,1,17,34,52,69,95,184], points := ![99,112,115,124,131,139], inverse := ![11,12,10,3,1,14,7,0,14,0,9,0,11,11,11,11,12,12,2,5,14,1,14,6,3,3,13,13,12,12,11,11,9,9,3,3] } }
theorem leafL_048_2_valid : (leafL_048_2).reject.ValidFor (leafL_048_2).leaf := by decide

noncomputable def leafL_048_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,189}, reject := .fullRank { members := ![0,1,17,34,52,69,95,189], points := ![99,106,107,120,131,138], inverse := ![5,9,11,9,5,10,15,13,5,14,8,1,6,3,5,0,0,0,1,12,10,15,15,7,11,10,1,0,1,1,11,11,0,0,11,11] } }
theorem leafL_048_3_valid : (leafL_048_3).reject.ValidFor (leafL_048_3).leaf := by decide

noncomputable def leafL_048_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,198}, reject := .fullRank { members := ![0,1,17,34,52,69,95,198], points := ![99,112,120,124,126,131], inverse := ![4,3,5,2,14,15,7,0,11,6,3,9,0,0,1,3,2,0,14,9,6,2,11,8,8,8,3,12,15,0,13,13,8,7,15,0] } }
theorem leafL_048_4_valid : (leafL_048_4).reject.ValidFor (leafL_048_4).leaf := by decide

noncomputable def leafL_048_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,203}, reject := .fullRank { members := ![0,1,17,34,52,69,95,203], points := ![99,103,112,126,131,137], inverse := ![7,0,0,9,0,15,11,3,15,14,13,4,1,9,8,0,0,0,15,12,4,15,12,4,7,13,10,0,13,13,8,5,13,0,6,6] } }
theorem leafL_048_5_valid : (leafL_048_5).reject.ValidFor (leafL_048_5).leaf := by decide

noncomputable def leafL_048_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,208}, reject := .fullRank { members := ![0,1,17,34,52,69,95,208], points := ![106,107,115,138,141,151], inverse := ![2,15,6,11,13,12,11,7,9,2,4,3,9,5,10,3,13,8,2,10,14,0,12,10,0,15,1,14,10,10,15,8,13,9,8,11] } }
theorem leafL_048_6_valid : (leafL_048_6).reject.ValidFor (leafL_048_6).leaf := by decide

noncomputable def leafL_048_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,211}, reject := .fullRank { members := ![0,1,17,34,52,69,95,211], points := ![112,120,124,137,138,139], inverse := ![7,5,12,14,10,11,7,11,5,15,2,4,0,0,0,9,14,7,7,9,6,6,10,4,0,3,3,4,11,15,0,10,10,14,11,5] } }
theorem leafL_048_7_valid : (leafL_048_7).reject.ValidFor (leafL_048_7).leaf := by decide

noncomputable def leavesL_048 : List RejectedLeaf := [leafL_048_0,leafL_048_1,leafL_048_2,leafL_048_3,leafL_048_4,leafL_048_5,leafL_048_6,leafL_048_7]

theorem leavesL_048_valid : LeafListValid leavesL_048 := by
  intro x hx
  simp only [leavesL_048, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_048_0_valid
  · exact leafL_048_1_valid
  · exact leafL_048_2_valid
  · exact leafL_048_3_valid
  · exact leafL_048_4_valid
  · exact leafL_048_5_valid
  · exact leafL_048_6_valid
  · exact leafL_048_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
