import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_196_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,126,208}, reject := .fullRank { members := ![0,1,17,34,52,71,126,208], points := ![90,106,138,141,147,166], inverse := ![10,6,9,7,7,4,14,9,7,0,0,0,10,1,1,9,14,13,6,10,10,5,13,14,3,10,4,3,9,7,1,4,9,10,9,15] } }
theorem leafL_196_0_valid : (leafL_196_0).reject.ValidFor (leafL_196_0).leaf := by decide

noncomputable def leafL_196_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,126,213}, reject := .fullRank { members := ![0,1,17,34,52,71,126,213], points := ![92,131,138,144,147,150], inverse := ![8,13,11,5,0,10,6,11,15,13,13,2,0,7,8,15,0,0,4,2,8,12,5,7,0,4,5,1,8,8,0,13,1,12,5,5] } }
theorem leafL_196_1_valid : (leafL_196_1).reject.ValidFor (leafL_196_1).leaf := by decide

noncomputable def leafL_196_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,126,223}, reject := .fullRank { members := ![0,1,17,34,52,71,126,223], points := ![90,96,104,106,138,140], inverse := ![2,11,12,2,7,1,14,0,0,9,7,0,9,9,14,14,4,4,7,8,5,13,4,3,8,8,12,12,0,0,3,3,10,10,6,6] } }
theorem leafL_196_2_valid : (leafL_196_2).reject.ValidFor (leafL_196_2).leaf := by decide

noncomputable def leafL_196_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,126,232}, reject := .fullRank { members := ![0,1,17,34,52,71,126,232], points := ![92,101,106,141,144,147], inverse := ![5,8,2,11,4,1,6,10,10,12,5,15,2,10,5,15,5,7,6,2,13,6,10,5,10,10,12,14,10,8,14,1,10,12,15,6] } }
theorem leafL_196_3_valid : (leafL_196_3).reject.ValidFor (leafL_196_3).leaf := by decide

noncomputable def leafL_196_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,126,233}, reject := .fullRank { members := ![0,1,17,34,52,71,126,233], points := ![96,101,104,106,138,139], inverse := ![9,0,1,15,11,13,14,10,11,8,9,14,0,13,1,12,0,0,15,13,15,10,2,5,0,2,5,7,8,8,0,7,7,0,7,7] } }
theorem leafL_196_4_valid : (leafL_196_4).reject.ValidFor (leafL_196_4).leaf := by decide

noncomputable def leafL_196_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,126,235}, reject := .fullRank { members := ![0,1,17,34,52,71,126,235], points := ![90,96,101,131,140,144], inverse := ![10,3,14,11,2,15,13,3,9,7,13,13,0,0,0,8,9,1,12,3,8,6,13,12,2,2,0,1,0,1,12,12,0,1,4,5] } }
theorem leafL_196_5_valid : (leafL_196_5).reject.ValidFor (leafL_196_5).leaf := by decide

noncomputable def leafL_196_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,126,239}, reject := .fullRank { members := ![0,1,17,34,52,71,126,239], points := ![90,92,104,139,140,150], inverse := ![11,15,4,3,9,11,1,7,0,7,14,15,4,6,15,12,6,7,13,12,3,12,8,6,13,1,4,3,10,1,3,1,15,2,8,7] } }
theorem leafL_196_6_valid : (leafL_196_6).reject.ValidFor (leafL_196_6).leaf := by decide

noncomputable def leafL_196_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,126,246}, reject := .fullRank { members := ![0,1,17,34,52,71,126,246], points := ![92,101,104,131,138,139], inverse := ![9,2,12,12,3,9,14,2,11,9,1,15,0,0,0,6,3,5,15,2,10,12,14,5,0,6,6,10,13,7,0,7,7,0,7,7] } }
theorem leafL_196_7_valid : (leafL_196_7).reject.ValidFor (leafL_196_7).leaf := by decide

noncomputable def leavesL_196 : List RejectedLeaf := [leafL_196_0,leafL_196_1,leafL_196_2,leafL_196_3,leafL_196_4,leafL_196_5,leafL_196_6,leafL_196_7]

theorem leavesL_196_valid : LeafListValid leavesL_196 := by
  intro x hx
  simp only [leavesL_196, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_196_0_valid
  · exact leafL_196_1_valid
  · exact leafL_196_2_valid
  · exact leafL_196_3_valid
  · exact leafL_196_4_valid
  · exact leafL_196_5_valid
  · exact leafL_196_6_valid
  · exact leafL_196_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
