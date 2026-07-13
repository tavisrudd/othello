import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_105_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,150,171}, reject := .fullRank { members := ![0,1,17,34,52,69,150,171], points := ![89,90,103,115,124,126], inverse := ![0,15,8,6,6,6,14,7,14,13,9,3,0,0,0,3,14,13,2,10,15,10,4,9,3,3,0,2,11,9,9,9,0,13,12,1] } }
theorem leafL_105_0_valid : (leafL_105_0).reject.ValidFor (leafL_105_0).leaf := by decide

noncomputable def leafL_105_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,150,173}, reject := .fullRank { members := ![0,1,17,34,52,69,150,173], points := ![89,94,95,103,122,124], inverse := ![10,15,10,8,2,4,5,7,11,14,11,12,4,8,12,0,0,0,6,9,7,15,3,4,4,9,13,0,1,1,2,3,1,0,13,13] } }
theorem leafL_105_1_valid : (leafL_105_1).reject.ValidFor (leafL_105_1).leaf := by decide

noncomputable def leafL_105_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,150,201}, reject := .fullRank { members := ![0,1,17,34,52,69,150,201], points := ![91,99,103,122,124,126], inverse := ![15,14,6,15,8,1,9,1,15,0,1,6,0,0,0,15,10,5,8,10,5,4,9,10,0,9,9,13,14,3,0,10,10,10,0,10] } }
theorem leafL_105_2_valid : (leafL_105_2).reject.ValidFor (leafL_105_2).leaf := by decide

noncomputable def leafL_105_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,150,240}, reject := .fullRank { members := ![0,1,17,34,52,69,150,240], points := ![90,94,99,115,122,124], inverse := ![3,12,8,2,3,7,10,3,14,8,7,8,0,0,0,10,11,1,0,8,15,12,15,4,4,4,0,15,6,9,15,15,0,13,3,14] } }
theorem leafL_105_3_valid : (leafL_105_3).reject.ValidFor (leafL_105_3).leaf := by decide

noncomputable def leafL_105_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,150,247}, reject := .fullRank { members := ![0,1,17,34,52,69,150,247], points := ![91,99,124,126,128,137], inverse := ![0,7,0,9,0,15,10,13,5,2,3,3,0,0,5,10,15,0,9,14,0,3,5,1,12,12,0,13,1,12,2,2,3,9,8,2] } }
theorem leafL_105_4_valid : (leafL_105_4).reject.ValidFor (leafL_105_4).leaf := by decide

noncomputable def leafL_105_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,150,256}, reject := .fullRank { members := ![0,1,17,34,52,69,150,256], points := ![90,94,95,99,103,115], inverse := ![9,9,15,10,2,6,6,12,3,14,0,7,8,10,2,0,0,0,3,14,5,6,9,7,10,2,8,1,1,0,13,13,0,13,13,0] } }
theorem leafL_105_5_valid : (leafL_105_5).reject.ValidFor (leafL_105_5).leaf := by decide

noncomputable def leafL_105_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,150,259}, reject := .fullRank { members := ![0,1,17,34,52,69,150,259], points := ![91,94,107,126,137,144], inverse := ![12,14,5,11,2,15,5,12,14,7,11,11,8,4,12,12,11,7,3,11,15,7,12,12,3,1,2,2,12,14,2,2,0,0,2,2] } }
theorem leafL_105_6_valid : (leafL_105_6).reject.ValidFor (leafL_105_6).leaf := by decide

noncomputable def leafL_105_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,150,268}, reject := .fullRank { members := ![0,1,17,34,52,69,150,268], points := ![89,90,91,103,115,122], inverse := ![11,12,8,8,14,8,7,9,7,14,1,6,9,14,7,0,0,0,15,13,10,15,14,9,0,1,1,0,10,10,2,10,8,0,11,11] } }
theorem leafL_105_7_valid : (leafL_105_7).reject.ValidFor (leafL_105_7).leaf := by decide

noncomputable def leavesL_105 : List RejectedLeaf := [leafL_105_0,leafL_105_1,leafL_105_2,leafL_105_3,leafL_105_4,leafL_105_5,leafL_105_6,leafL_105_7]

theorem leavesL_105_valid : LeafListValid leavesL_105 := by
  intro x hx
  simp only [leavesL_105, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_105_0_valid
  · exact leafL_105_1_valid
  · exact leafL_105_2_valid
  · exact leafL_105_3_valid
  · exact leafL_105_4_valid
  · exact leafL_105_5_valid
  · exact leafL_105_6_valid
  · exact leafL_105_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
