import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_198_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,128,150}, reject := .fullRank { members := ![0,1,17,34,52,71,128,150], points := ![83,93,101,109,138,139], inverse := ![4,13,2,12,3,5,8,6,9,0,4,3,7,7,12,12,2,2,3,12,5,13,11,12,7,7,0,0,10,10,2,2,1,1,12,12] } }
theorem leafL_198_0_valid : (leafL_198_0).reject.ValidFor (leafL_198_0).leaf := by decide

noncomputable def leafL_198_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,128,154}, reject := .fullRank { members := ![0,1,17,34,52,71,128,154], points := ![83,93,104,109,131,139], inverse := ![1,8,14,0,7,1,4,10,10,3,5,2,12,12,13,13,13,13,5,10,12,4,10,13,9,9,8,8,15,15,10,10,9,9,12,12] } }
theorem leafL_198_1_valid : (leafL_198_1).reject.ValidFor (leafL_198_1).leaf := by decide

noncomputable def leafL_198_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,128,155}, reject := .fullRank { members := ![0,1,17,34,52,71,128,155], points := ![94,101,104,109,138,140], inverse := ![9,10,4,0,9,15,14,5,8,4,9,14,0,5,3,6,0,0,15,2,7,13,7,0,0,8,13,5,12,12,0,12,15,3,13,13] } }
theorem leafL_198_2_valid : (leafL_198_2).reject.ValidFor (leafL_198_2).leaf := by decide

noncomputable def leafL_198_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,128,158}, reject := .fullRank { members := ![0,1,17,34,52,71,128,158], points := ![83,93,99,101,104,139], inverse := ![9,0,2,11,7,6,6,8,11,11,9,7,0,0,4,12,8,0,1,14,8,2,2,7,15,15,9,5,12,0,3,3,1,13,12,0] } }
theorem leafL_198_3_valid : (leafL_198_3).reject.ValidFor (leafL_198_3).leaf := by decide

noncomputable def leafL_198_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,128,166}, reject := .fullRank { members := ![0,1,17,34,52,71,128,166], points := ![93,94,99,109,139,140], inverse := ![3,10,1,15,9,15,9,7,4,13,12,11,1,1,11,11,9,9,12,3,4,12,8,15,13,13,11,11,4,4,14,14,0,0,14,14] } }
theorem leafL_198_4_valid : (leafL_198_4).reject.ValidFor (leafL_198_4).leaf := by decide

noncomputable def leafL_198_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,128,171}, reject := .fullRank { members := ![0,1,17,34,52,71,128,171], points := ![83,101,109,138,147,182], inverse := ![9,11,12,15,9,9,12,12,13,10,0,7,4,3,5,12,5,11,1,4,8,11,9,15,12,13,8,8,0,1,2,12,12,5,8,15] } }
theorem leafL_198_5_valid : (leafL_198_5).reject.ValidFor (leafL_198_5).leaf := by decide

noncomputable def leafL_198_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,128,172}, reject := .fullRank { members := ![0,1,17,34,52,71,128,172], points := ![83,93,94,104,110,131], inverse := ![7,15,1,3,13,6,0,5,11,4,13,7,11,3,8,0,0,0,15,2,2,7,15,7,9,11,2,5,5,0,9,15,6,12,12,0] } }
theorem leafL_198_6_valid : (leafL_198_6).reject.ValidFor (leafL_198_6).leaf := by decide

noncomputable def leafL_198_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,128,186}, reject := .fullRank { members := ![0,1,17,34,52,71,128,186], points := ![93,99,101,131,140,155], inverse := ![15,3,15,5,14,9,8,1,10,2,8,9,5,9,10,9,11,4,5,2,12,1,2,8,2,8,7,14,4,7,3,13,12,6,9,13] } }
theorem leafL_198_7_valid : (leafL_198_7).reject.ValidFor (leafL_198_7).leaf := by decide

noncomputable def leavesL_198 : List RejectedLeaf := [leafL_198_0,leafL_198_1,leafL_198_2,leafL_198_3,leafL_198_4,leafL_198_5,leafL_198_6,leafL_198_7]

theorem leavesL_198_valid : LeafListValid leavesL_198 := by
  intro x hx
  simp only [leavesL_198, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_198_0_valid
  · exact leafL_198_1_valid
  · exact leafL_198_2_valid
  · exact leafL_198_3_valid
  · exact leafL_198_4_valid
  · exact leafL_198_5_valid
  · exact leafL_198_6_valid
  · exact leafL_198_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
