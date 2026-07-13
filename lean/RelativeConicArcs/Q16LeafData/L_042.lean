import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_042_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,131}, reject := .fullRank { members := ![0,1,17,34,52,69,94,131], points := ![103,107,112,128,150,151], inverse := ![2,1,15,14,1,2,10,1,6,1,2,14,7,2,5,0,0,0,4,9,7,13,1,6,15,7,8,0,12,12,4,15,11,0,13,13] } }
theorem leafL_042_0_valid : (leafL_042_0).reject.ValidFor (leafL_042_0).leaf := by decide

noncomputable def leafL_042_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,135}, reject := .fullRank { members := ![0,1,17,34,52,69,94,135], points := ![99,106,112,122,150,156], inverse := ![11,4,3,14,7,4,5,15,7,1,14,2,7,8,15,0,0,0,6,9,5,13,7,0,4,6,2,0,9,9,1,10,11,0,12,12] } }
theorem leafL_042_1_valid : (leafL_042_1).reject.ValidFor (leafL_042_1).leaf := by decide

noncomputable def leafL_042_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,150}, reject := .fullRank { members := ![0,1,17,34,52,69,94,150], points := ![103,107,122,128,131,135], inverse := ![3,4,1,8,2,13,0,7,9,7,8,1,8,8,6,6,14,14,3,4,14,1,15,7,15,15,15,15,14,14,3,3,11,11,2,2] } }
theorem leafL_042_2_valid : (leafL_042_2).reject.ValidFor (leafL_042_2).leaf := by decide

noncomputable def leafL_042_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,151}, reject := .fullRank { members := ![0,1,17,34,52,69,94,151], points := ![99,107,120,127,128,131], inverse := ![14,9,3,2,8,15,7,0,13,8,11,9,0,0,13,2,15,0,13,10,3,3,15,8,13,13,0,3,3,0,5,5,5,0,5,0] } }
theorem leafL_042_3_valid : (leafL_042_3).reject.ValidFor (leafL_042_3).leaf := by decide

noncomputable def leafL_042_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,152}, reject := .fullRank { members := ![0,1,17,34,52,69,94,152], points := ![99,103,106,122,131,166], inverse := ![9,13,14,12,0,7,3,12,3,10,5,3,12,2,14,0,0,0,7,10,13,9,2,11,15,14,4,8,11,6,4,9,12,7,9,15] } }
theorem leafL_042_4_valid : (leafL_042_4).reject.ValidFor (leafL_042_4).leaf := by decide

noncomputable def leafL_042_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,156}, reject := .fullRank { members := ![0,1,17,34,52,69,94,156], points := ![99,103,104,127,128,131], inverse := ![5,14,12,9,0,15,1,13,11,10,4,9,6,13,11,0,0,0,11,6,10,8,7,8,6,15,9,3,3,0,0,14,14,14,14,0] } }
theorem leafL_042_5_valid : (leafL_042_5).reject.ValidFor (leafL_042_5).leaf := by decide

noncomputable def leafL_042_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,163}, reject := .fullRank { members := ![0,1,17,34,52,69,94,163], points := ![107,112,122,127,135,150], inverse := ![14,13,11,4,4,9,1,10,11,15,7,8,11,1,12,3,9,12,5,10,11,8,13,1,11,6,13,15,8,7,11,7,10,0,14,8] } }
theorem leafL_042_6_valid : (leafL_042_6).reject.ValidFor (leafL_042_6).leaf := by decide

noncomputable def leafL_042_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,94,166}, reject := .fullRank { members := ![0,1,17,34,52,69,94,166], points := ![99,104,106,120,127,135], inverse := ![9,14,0,15,6,15,2,1,4,1,15,9,1,14,15,0,0,0,4,5,6,6,9,8,7,10,13,6,6,0,12,5,9,15,15,0] } }
theorem leafL_042_7_valid : (leafL_042_7).reject.ValidFor (leafL_042_7).leaf := by decide

noncomputable def leavesL_042 : List RejectedLeaf := [leafL_042_0,leafL_042_1,leafL_042_2,leafL_042_3,leafL_042_4,leafL_042_5,leafL_042_6,leafL_042_7]

theorem leavesL_042_valid : LeafListValid leavesL_042 := by
  intro x hx
  simp only [leavesL_042, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_042_0_valid
  · exact leafL_042_1_valid
  · exact leafL_042_2_valid
  · exact leafL_042_3_valid
  · exact leafL_042_4_valid
  · exact leafL_042_5_valid
  · exact leafL_042_6_valid
  · exact leafL_042_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
