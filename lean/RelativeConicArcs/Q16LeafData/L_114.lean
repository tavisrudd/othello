import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_114_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,171,217}, reject := .fullRank { members := ![0,1,17,34,52,69,171,217], points := ![86,94,99,115,120,124], inverse := ![8,7,8,14,0,8,5,12,14,14,11,2,0,0,0,5,2,7,0,8,15,8,12,3,2,2,0,0,7,7,14,14,0,10,1,11] } }
theorem leafL_114_0_valid : (leafL_114_0).reject.ValidFor (leafL_114_0).leaf := by decide

noncomputable def leafL_114_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,171,240}, reject := .fullRank { members := ![0,1,17,34,52,69,171,240], points := ![86,94,99,106,124,127], inverse := ![15,0,0,8,0,6,14,7,15,1,8,15,10,10,4,4,1,1,2,10,5,10,5,2,8,8,4,4,4,4,2,2,9,9,3,3] } }
theorem leafL_114_1_valid : (leafL_114_1).reject.ValidFor (leafL_114_1).leaf := by decide

noncomputable def leafL_114_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,171,247}, reject := .fullRank { members := ![0,1,17,34,52,69,171,247], points := ![86,99,106,115,120,124], inverse := ![15,0,8,6,6,6,9,7,9,7,9,9,0,0,0,5,2,7,8,1,14,6,1,0,0,10,10,10,9,3,0,3,3,9,13,4] } }
theorem leafL_114_2_valid : (leafL_114_2).reject.ValidFor (leafL_114_2).leaf := by decide

noncomputable def leafL_114_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,171,249}, reject := .fullRank { members := ![0,1,17,34,52,69,171,249], points := ![86,94,103,120,126,141], inverse := ![15,11,3,6,11,11,9,11,5,4,8,11,14,6,8,14,6,8,1,14,8,10,10,7,6,12,10,15,5,10,0,8,8,8,0,8] } }
theorem leafL_114_3_valid : (leafL_114_3).reject.ValidFor (leafL_114_3).leaf := by decide

noncomputable def leafL_114_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,171,256}, reject := .fullRank { members := ![0,1,17,34,52,69,171,256], points := ![90,94,99,103,115,127], inverse := ![7,8,1,9,2,4,14,7,7,9,13,10,9,9,14,14,12,12,8,0,14,1,10,13,14,14,12,12,5,5,13,13,13,13,0,0] } }
theorem leafL_114_4_valid : (leafL_114_4).reject.ValidFor (leafL_114_4).leaf := by decide

noncomputable def leafL_114_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,171,259}, reject := .fullRank { members := ![0,1,17,34,52,69,171,259], points := ![86,90,94,120,124,137], inverse := ![14,11,2,7,9,8,6,14,15,15,6,14,12,11,7,0,0,0,3,5,1,12,4,15,2,0,2,7,7,0,5,5,0,5,5,0] } }
theorem leafL_114_5_valid : (leafL_114_5).reject.ValidFor (leafL_114_5).leaf := by decide

noncomputable def leafL_114_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,171,270}, reject := .fullRank { members := ![0,1,17,34,52,69,171,270], points := ![86,99,124,128,138,151], inverse := ![11,9,9,5,9,6,1,8,11,13,10,5,12,2,13,8,14,5,4,14,12,5,4,7,4,11,3,6,0,10,7,9,11,5,5,5] } }
theorem leafL_114_6_valid : (leafL_114_6).reject.ValidFor (leafL_114_6).leaf := by decide

noncomputable def leafL_114_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,171,271}, reject := .fullRank { members := ![0,1,17,34,52,69,171,271], points := ![89,103,115,124,126,137], inverse := ![2,5,3,13,5,13,7,0,1,15,7,14,0,0,3,14,13,0,15,8,12,7,11,7,6,6,3,2,7,6,1,1,10,6,13,1] } }
theorem leafL_114_7_valid : (leafL_114_7).reject.ValidFor (leafL_114_7).leaf := by decide

noncomputable def leavesL_114 : List RejectedLeaf := [leafL_114_0,leafL_114_1,leafL_114_2,leafL_114_3,leafL_114_4,leafL_114_5,leafL_114_6,leafL_114_7]

theorem leavesL_114_valid : LeafListValid leavesL_114 := by
  intro x hx
  simp only [leavesL_114, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_114_0_valid
  · exact leafL_114_1_valid
  · exact leafL_114_2_valid
  · exact leafL_114_3_valid
  · exact leafL_114_4_valid
  · exact leafL_114_5_valid
  · exact leafL_114_6_valid
  · exact leafL_114_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
