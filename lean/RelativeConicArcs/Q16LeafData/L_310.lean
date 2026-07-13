import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_310_0 : RejectedLeaf := { leaf := {0,1,17,34,52,74,220,235}, reject := .fullRank { members := ![0,1,17,34,52,74,220,235], points := ![86,95,103,110,112,117], inverse := ![1,14,3,6,13,6,2,11,10,15,11,7,0,0,10,11,1,0,1,9,4,11,0,7,2,2,5,14,11,0,5,5,5,5,0,0] } }
theorem leafL_310_0_valid : (leafL_310_0).reject.ValidFor (leafL_310_0).leaf := by decide

noncomputable def leafL_310_1 : RejectedLeaf := { leaf := {0,1,17,34,52,74,222,232}, reject := .fullRank { members := ![0,1,17,34,52,74,222,232], points := ![92,93,107,108,109,115], inverse := ![4,11,2,8,2,6,1,8,1,8,7,7,0,0,7,6,1,0,15,7,1,6,8,7,13,13,6,10,12,0,6,6,0,6,6,0] } }
theorem leafL_310_1_valid : (leafL_310_1).reject.ValidFor (leafL_310_1).leaf := by decide

noncomputable def leafL_310_2 : RejectedLeaf := { leaf := {0,1,17,34,52,74,224,232}, reject := .fullRank { members := ![0,1,17,34,52,74,224,232], points := ![89,92,93,107,109,115], inverse := ![11,13,9,7,15,6,11,8,10,4,10,7,10,2,8,0,0,0,10,13,15,6,9,7,13,11,6,15,15,0,10,4,14,7,7,0] } }
theorem leafL_310_2_valid : (leafL_310_2).reject.ValidFor (leafL_310_2).leaf := by decide

noncomputable def leafL_310_3 : RejectedLeaf := { leaf := {0,1,17,34,52,74,224,259}, reject := .fullRank { members := ![0,1,17,34,52,74,224,259], points := ![92,95,104,108,110,121], inverse := ![2,13,5,2,15,6,14,7,0,9,7,7,0,0,1,3,2,0,6,14,14,13,12,7,1,1,9,7,14,0,11,11,3,2,1,0] } }
theorem leafL_310_3_valid : (leafL_310_3).reject.ValidFor (leafL_310_3).leaf := by decide

noncomputable def leafL_310_4 : RejectedLeaf := { leaf := {0,1,17,34,52,74,231,256}, reject := .fullRank { members := ![0,1,17,34,52,74,231,256], points := ![83,92,104,109,117,137], inverse := ![0,1,4,2,8,14,5,0,5,7,11,12,1,14,4,11,15,15,7,8,3,11,0,7,11,4,3,12,15,15,0,13,13,0,13,13] } }
theorem leafL_310_4_valid : (leafL_310_4).reject.ValidFor (leafL_310_4).leaf := by decide

noncomputable def leafL_310_5 : RejectedLeaf := { leaf := {0,1,17,34,52,74,232,247}, reject := .fullRank { members := ![0,1,17,34,52,74,232,247], points := ![83,86,92,108,110,137], inverse := ![2,9,2,8,6,6,7,14,7,4,13,7,12,10,6,0,0,0,5,3,9,1,9,7,10,0,10,15,15,0,10,12,6,7,7,0] } }
theorem leafL_310_5_valid : (leafL_310_5).reject.ValidFor (leafL_310_5).leaf := by decide

noncomputable def leafL_310_6 : RejectedLeaf := { leaf := {0,1,17,34,52,74,232,259}, reject := .fullRank { members := ![0,1,17,34,52,74,232,259], points := ![86,94,101,107,108,128], inverse := ![3,12,0,15,7,6,15,6,15,7,6,7,0,0,11,3,8,0,8,0,7,13,5,7,6,6,2,9,11,0,15,15,12,9,5,0] } }
theorem leafL_310_6_valid : (leafL_310_6).reject.ValidFor (leafL_310_6).leaf := by decide

noncomputable def leafL_310_7 : RejectedLeaf := { leaf := {0,1,17,34,52,74,233,247}, reject := .fullRank { members := ![0,1,17,34,52,74,233,247], points := ![86,93,104,108,124,128], inverse := ![13,2,1,9,2,4,6,15,6,8,2,5,7,7,1,1,8,8,8,0,9,6,0,7,6,6,0,0,9,9,10,10,15,15,14,14] } }
theorem leafL_310_7_valid : (leafL_310_7).reject.ValidFor (leafL_310_7).leaf := by decide

noncomputable def leavesL_310 : List RejectedLeaf := [leafL_310_0,leafL_310_1,leafL_310_2,leafL_310_3,leafL_310_4,leafL_310_5,leafL_310_6,leafL_310_7]

theorem leavesL_310_valid : LeafListValid leavesL_310 := by
  intro x hx
  simp only [leavesL_310, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_310_0_valid
  · exact leafL_310_1_valid
  · exact leafL_310_2_valid
  · exact leafL_310_3_valid
  · exact leafL_310_4_valid
  · exact leafL_310_5_valid
  · exact leafL_310_6_valid
  · exact leafL_310_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
