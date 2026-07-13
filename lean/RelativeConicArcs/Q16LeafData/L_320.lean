import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_320_0 : RejectedLeaf := { leaf := {0,1,17,34,52,78,133,199}, reject := .fullRank { members := ![0,1,17,34,52,78,133,199], points := ![83,86,90,99,108,120], inverse := ![3,13,1,10,2,6,15,14,8,8,6,7,13,9,4,0,0,0,5,12,1,13,2,7,6,8,14,8,8,0,12,1,13,2,2,0] } }
theorem leafL_320_0_valid : (leafL_320_0).reject.ValidFor (leafL_320_0).leaf := by decide

noncomputable def leafL_320_1 : RejectedLeaf := { leaf := {0,1,17,34,52,78,133,256}, reject := .fullRank { members := ![0,1,17,34,52,78,133,256], points := ![83,90,99,103,108,115], inverse := ![11,4,10,2,0,6,9,0,14,0,0,7,0,0,9,1,8,0,2,10,9,4,2,7,2,2,0,3,3,0,5,5,3,2,1,0] } }
theorem leafL_320_1_valid : (leafL_320_1).reject.ValidFor (leafL_320_1).leaf := by decide

noncomputable def leafL_320_2 : RejectedLeaf := { leaf := {0,1,17,34,52,78,137,230}, reject := .fullRank { members := ![0,1,17,34,52,78,137,230], points := ![91,92,103,104,120,128], inverse := ![10,5,3,11,2,4,3,10,6,8,5,2,6,6,4,4,13,13,2,10,13,2,1,6,3,3,0,0,13,13,1,1,1,1,0,0] } }
theorem leafL_320_2_valid : (leafL_320_2).reject.ValidFor (leafL_320_2).leaf := by decide

noncomputable def leafL_320_3 : RejectedLeaf := { leaf := {0,1,17,34,52,78,137,256}, reject := .fullRank { members := ![0,1,17,34,52,78,137,256], points := ![83,92,103,108,109,152], inverse := ![12,10,9,10,8,12,2,8,7,3,0,14,0,0,5,11,14,0,7,12,9,10,6,14,10,10,7,1,6,0,2,2,3,14,13,0] } }
theorem leafL_320_3_valid : (leafL_320_3).reject.ValidFor (leafL_320_3).leaf := by decide

noncomputable def leafL_320_4 : RejectedLeaf := { leaf := {0,1,17,34,52,78,139,214}, reject := .fullRank { members := ![0,1,17,34,52,78,139,214], points := ![89,90,92,106,109,115], inverse := ![7,15,7,11,3,6,5,1,13,9,7,7,14,9,7,0,0,0,3,8,3,4,11,7,10,4,14,10,10,0,12,3,15,11,11,0] } }
theorem leafL_320_4_valid : (leafL_320_4).reject.ValidFor (leafL_320_4).leaf := by decide

noncomputable def leafL_320_5 : RejectedLeaf := { leaf := {0,1,17,34,52,78,139,259}, reject := .fullRank { members := ![0,1,17,34,52,78,139,259], points := ![92,104,106,120,121,125], inverse := ![15,10,2,1,1,6,9,2,12,15,12,4,0,0,0,14,2,12,8,15,0,2,6,3,0,6,6,1,2,3,0,1,1,2,6,4] } }
theorem leafL_320_5_valid : (leafL_320_5).reject.ValidFor (leafL_320_5).leaf := by decide

noncomputable def leafL_320_6 : RejectedLeaf := { leaf := {0,1,17,34,52,78,144,168}, reject := .fullRank { members := ![0,1,17,34,52,78,144,168], points := ![86,90,106,109,149,155], inverse := ![6,0,11,0,0,12,8,2,14,10,2,12,6,6,14,14,4,4,5,14,9,12,3,13,6,6,1,1,13,13,9,9,12,12,2,2] } }
theorem leafL_320_6_valid : (leafL_320_6).reject.ValidFor (leafL_320_6).leaf := by decide

noncomputable def leafL_320_7 : RejectedLeaf := { leaf := {0,1,17,34,52,78,144,230}, reject := .fullRank { members := ![0,1,17,34,52,78,144,230], points := ![91,106,120,121,154,155], inverse := ![9,15,4,12,15,0,7,12,4,7,9,1,9,3,7,1,15,3,0,10,14,3,14,9,7,1,11,9,3,7,10,9,13,12,10,8] } }
theorem leafL_320_7_valid : (leafL_320_7).reject.ValidFor (leafL_320_7).leaf := by decide

noncomputable def leavesL_320 : List RejectedLeaf := [leafL_320_0,leafL_320_1,leafL_320_2,leafL_320_3,leafL_320_4,leafL_320_5,leafL_320_6,leafL_320_7]

theorem leavesL_320_valid : LeafListValid leavesL_320 := by
  intro x hx
  simp only [leavesL_320, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_320_0_valid
  · exact leafL_320_1_valid
  · exact leafL_320_2_valid
  · exact leafL_320_3_valid
  · exact leafL_320_4_valid
  · exact leafL_320_5_valid
  · exact leafL_320_6_valid
  · exact leafL_320_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
