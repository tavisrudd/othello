import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_065_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,171}, reject := .fullRank { members := ![0,1,17,34,52,69,106,171], points := ![89,94,115,120,124,141], inverse := ![0,7,14,0,0,8,4,3,12,1,4,14,0,0,5,2,7,0,11,12,4,5,9,15,14,14,7,15,8,0,12,12,12,12,0,0] } }
theorem leafL_065_0_valid : (leafL_065_0).reject.ValidFor (leafL_065_0).leaf := by decide

noncomputable def leafL_065_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,172}, reject := .fullRank { members := ![0,1,17,34,52,69,106,172], points := ![91,94,96,115,120,135], inverse := ![4,10,9,5,11,8,0,5,2,12,5,14,15,3,12,0,0,0,7,9,9,9,1,15,8,15,7,5,5,0,12,0,12,12,12,0] } }
theorem leafL_065_1_valid : (leafL_065_1).reject.ValidFor (leafL_065_1).leaf := by decide

noncomputable def leafL_065_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,173}, reject := .fullRank { members := ![0,1,17,34,52,69,106,173], points := ![89,95,96,115,124,135], inverse := ![10,3,14,12,2,8,6,11,10,13,4,14,1,7,6,0,0,0,12,11,0,2,10,15,2,13,15,4,4,0,4,6,2,1,1,0] } }
theorem leafL_065_2_valid : (leafL_065_2).reject.ValidFor (leafL_065_2).leaf := by decide

noncomputable def leafL_065_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,175}, reject := .fullRank { members := ![0,1,17,34,52,69,106,175], points := ![89,96,120,124,126,135], inverse := ![0,7,14,14,14,8,9,14,5,13,1,14,0,0,1,3,2,0,3,4,0,15,7,15,10,10,5,1,4,0,3,3,9,2,11,0] } }
theorem leafL_065_3_valid : (leafL_065_3).reject.ValidFor (leafL_065_3).leaf := by decide

noncomputable def leafL_065_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,182}, reject := .fullRank { members := ![0,1,17,34,52,69,106,182], points := ![94,95,96,115,124,135], inverse := ![3,6,2,12,2,8,1,8,14,13,4,14,7,14,9,0,0,0,2,13,8,2,10,15,14,12,2,4,4,0,15,4,11,1,1,0] } }
theorem leafL_065_4_valid : (leafL_065_4).reject.ValidFor (leafL_065_4).leaf := by decide

noncomputable def leafL_065_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,183}, reject := .fullRank { members := ![0,1,17,34,52,69,106,183], points := ![91,95,120,124,126,139], inverse := ![9,14,4,8,2,8,7,0,10,14,13,14,0,0,1,3,2,0,11,12,7,4,11,15,4,4,0,14,14,0,15,15,1,9,8,0] } }
theorem leafL_065_5_valid : (leafL_065_5).reject.ValidFor (leafL_065_5).leaf := by decide

noncomputable def leafL_065_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,195}, reject := .fullRank { members := ![0,1,17,34,52,69,106,195], points := ![89,91,94,126,139,141], inverse := ![10,1,12,14,1,9,15,7,15,9,12,2,12,3,15,0,0,0,12,10,1,8,8,7,1,3,2,0,5,5,4,3,7,0,12,12] } }
theorem leafL_065_6_valid : (leafL_065_6).reject.ValidFor (leafL_065_6).leaf := by decide

noncomputable def leafL_065_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,201}, reject := .fullRank { members := ![0,1,17,34,52,69,106,201], points := ![96,120,124,126,139,156], inverse := ![8,3,9,10,3,10,12,9,6,10,10,3,0,1,3,2,0,0,3,11,6,7,0,9,5,5,8,6,8,6,8,9,8,5,13,1] } }
theorem leafL_065_7_valid : (leafL_065_7).reject.ValidFor (leafL_065_7).leaf := by decide

noncomputable def leavesL_065 : List RejectedLeaf := [leafL_065_0,leafL_065_1,leafL_065_2,leafL_065_3,leafL_065_4,leafL_065_5,leafL_065_6,leafL_065_7]

theorem leavesL_065_valid : LeafListValid leavesL_065 := by
  intro x hx
  simp only [leavesL_065, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_065_0_valid
  · exact leafL_065_1_valid
  · exact leafL_065_2_valid
  · exact leafL_065_3_valid
  · exact leafL_065_4_valid
  · exact leafL_065_5_valid
  · exact leafL_065_6_valid
  · exact leafL_065_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
