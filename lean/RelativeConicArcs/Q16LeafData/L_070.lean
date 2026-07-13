import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_070_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,208}, reject := .fullRank { members := ![0,1,17,34,52,69,107,208], points := ![95,115,138,151,152,156], inverse := ![14,3,2,9,2,5,4,1,7,14,8,4,0,0,0,4,10,14,3,10,0,5,9,5,13,15,5,9,9,7,7,10,6,8,13,14] } }
theorem leafL_070_0_valid : (leafL_070_0).reject.ValidFor (leafL_070_0).leaf := by decide

noncomputable def leafL_070_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,214}, reject := .fullRank { members := ![0,1,17,34,52,69,107,214], points := ![92,94,96,115,120,137], inverse := ![6,3,2,15,1,8,1,1,7,8,1,14,5,10,15,0,0,0,14,14,7,1,9,15,9,9,0,5,5,0,4,5,1,12,12,0] } }
theorem leafL_070_1_valid : (leafL_070_1).reject.ValidFor (leafL_070_1).leaf := by decide

noncomputable def leafL_070_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,222}, reject := .fullRank { members := ![0,1,17,34,52,69,107,222], points := ![95,96,115,127,131,137], inverse := ![13,10,10,4,0,8,12,11,6,15,2,12,1,1,13,13,11,11,0,7,3,11,5,10,11,11,5,5,7,7,6,6,2,2,3,3] } }
theorem leafL_070_2_valid : (leafL_070_2).reject.ValidFor (leafL_070_2).leaf := by decide

noncomputable def leafL_070_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,223}, reject := .fullRank { members := ![0,1,17,34,52,69,107,223], points := ![86,94,122,137,144,151], inverse := ![14,14,4,6,8,11,10,8,2,11,13,6,0,9,13,2,8,14,1,12,13,4,8,12,8,6,7,5,9,5,5,14,12,8,12,3] } }
theorem leafL_070_3_valid : (leafL_070_3).reject.ValidFor (leafL_070_3).leaf := by decide

noncomputable def leafL_070_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,230}, reject := .fullRank { members := ![0,1,17,34,52,69,107,230], points := ![92,115,122,127,131,138], inverse := ![7,10,7,3,9,1,7,10,9,10,6,8,0,4,13,9,0,0,7,1,3,10,13,2,0,2,14,12,13,13,0,5,5,0,5,5] } }
theorem leafL_070_4_valid : (leafL_070_4).reject.ValidFor (leafL_070_4).leaf := by decide

noncomputable def leafL_070_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,232}, reject := .fullRank { members := ![0,1,17,34,52,69,107,232], points := ![86,92,95,115,122,137], inverse := ![4,0,3,12,2,8,4,9,10,11,2,14,15,14,1,0,0,0,15,15,7,9,1,15,12,8,4,10,10,0,11,0,11,11,11,0] } }
theorem leafL_070_5_valid : (leafL_070_5).reject.ValidFor (leafL_070_5).leaf := by decide

noncomputable def leafL_070_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,247}, reject := .fullRank { members := ![0,1,17,34,52,69,107,247], points := ![86,92,96,120,124,137], inverse := ![15,13,5,7,9,8,4,2,1,15,6,14,7,4,3,0,0,0,11,0,12,12,4,15,6,11,13,7,7,0,15,12,3,5,5,0] } }
theorem leafL_070_6_valid : (leafL_070_6).reject.ValidFor (leafL_070_6).leaf := by decide

noncomputable def leafL_070_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,249}, reject := .fullRank { members := ![0,1,17,34,52,69,107,249], points := ![86,92,94,115,122,131], inverse := ![10,14,3,9,7,8,11,2,14,9,0,14,2,9,11,0,0,0,2,10,15,13,5,15,13,7,10,10,10,0,13,4,9,11,11,0] } }
theorem leafL_070_7_valid : (leafL_070_7).reject.ValidFor (leafL_070_7).leaf := by decide

noncomputable def leavesL_070 : List RejectedLeaf := [leafL_070_0,leafL_070_1,leafL_070_2,leafL_070_3,leafL_070_4,leafL_070_5,leafL_070_6,leafL_070_7]

theorem leavesL_070_valid : LeafListValid leavesL_070 := by
  intro x hx
  simp only [leavesL_070, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_070_0_valid
  · exact leafL_070_1_valid
  · exact leafL_070_2_valid
  · exact leafL_070_3_valid
  · exact leafL_070_4_valid
  · exact leafL_070_5_valid
  · exact leafL_070_6_valid
  · exact leafL_070_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
