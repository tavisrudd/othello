import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_088_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,183}, reject := .fullRank { members := ![0,1,17,34,52,69,126,183], points := ![86,89,93,106,131,138], inverse := ![9,0,0,14,6,0,11,7,2,9,0,7,8,1,9,0,0,0,2,0,13,8,8,15,11,0,11,0,12,12,14,15,1,0,3,3] } }
theorem leafL_088_0_valid : (leafL_088_0).reject.ValidFor (leafL_088_0).leaf := by decide

noncomputable def leafL_088_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,195}, reject := .fullRank { members := ![0,1,17,34,52,69,126,195], points := ![86,89,103,104,106,135], inverse := ![14,7,2,5,9,6,10,4,0,1,8,7,0,0,8,3,11,0,12,3,6,5,11,7,7,7,8,15,7,0,4,4,11,6,13,0] } }
theorem leafL_088_1_valid : (leafL_088_1).reject.ValidFor (leafL_088_1).leaf := by decide

noncomputable def leafL_088_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,198}, reject := .fullRank { members := ![0,1,17,34,52,69,126,198], points := ![90,92,93,106,112,131], inverse := ![1,5,13,14,0,6,8,13,11,11,2,7,12,3,15,0,0,0,15,6,6,0,8,7,7,8,15,15,15,0,12,5,9,7,7,0] } }
theorem leafL_088_2_valid : (leafL_088_2).reject.ValidFor (leafL_088_2).leaf := by decide

noncomputable def leafL_088_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,201}, reject := .fullRank { members := ![0,1,17,34,52,69,126,201], points := ![86,92,96,103,104,138], inverse := ![0,2,11,9,7,6,11,0,5,7,14,7,7,4,3,0,0,0,5,15,5,0,8,7,9,0,9,4,4,0,8,10,2,1,1,0] } }
theorem leafL_088_3_valid : (leafL_088_3).reject.ValidFor (leafL_088_3).leaf := by decide

noncomputable def leafL_088_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,203}, reject := .fullRank { members := ![0,1,17,34,52,69,126,203], points := ![89,90,92,103,141,152], inverse := ![6,15,12,10,15,1,3,11,1,5,15,3,14,9,7,0,0,0,5,6,0,12,14,1,3,9,9,1,15,13,3,13,10,13,7,14] } }
theorem leafL_088_4_valid : (leafL_088_4).reject.ValidFor (leafL_088_4).leaf := by decide

noncomputable def leafL_088_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,208}, reject := .fullRank { members := ![0,1,17,34,52,69,126,208], points := ![86,89,90,106,135,138], inverse := ![14,2,5,14,1,7,0,0,14,9,0,7,14,4,10,0,0,0,4,2,9,8,13,10,8,6,14,0,2,2,8,4,12,0,9,9] } }
theorem leafL_088_5_valid : (leafL_088_5).reject.ValidFor (leafL_088_5).leaf := by decide

noncomputable def leafL_088_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,211}, reject := .fullRank { members := ![0,1,17,34,52,69,126,211], points := ![86,92,104,112,138,139], inverse := ![5,12,9,7,12,10,8,6,4,13,6,1,7,7,12,12,2,2,5,10,15,7,1,6,7,7,0,0,10,10,2,2,1,1,12,12] } }
theorem leafL_088_6_valid : (leafL_088_6).reject.ValidFor (leafL_088_6).leaf := by decide

noncomputable def leafL_088_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,126,217}, reject := .fullRank { members := ![0,1,17,34,52,69,126,217], points := ![86,95,96,104,131,135], inverse := ![6,15,0,14,4,2,11,11,14,9,5,2,9,5,12,0,0,0,4,3,8,8,6,1,15,0,15,0,14,14,8,1,9,0,10,10] } }
theorem leafL_088_7_valid : (leafL_088_7).reject.ValidFor (leafL_088_7).leaf := by decide

noncomputable def leavesL_088 : List RejectedLeaf := [leafL_088_0,leafL_088_1,leafL_088_2,leafL_088_3,leafL_088_4,leafL_088_5,leafL_088_6,leafL_088_7]

theorem leavesL_088_valid : LeafListValid leavesL_088 := by
  intro x hx
  simp only [leavesL_088, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_088_0_valid
  · exact leafL_088_1_valid
  · exact leafL_088_2_valid
  · exact leafL_088_3_valid
  · exact leafL_088_4_valid
  · exact leafL_088_5_valid
  · exact leafL_088_6_valid
  · exact leafL_088_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
