import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_243_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,232,253}, reject := .fullRank { members := ![0,1,17,34,52,71,232,253], points := ![83,110,126,127,133,144], inverse := ![11,12,2,0,13,9,11,12,6,3,10,8,5,5,3,6,13,8,4,3,8,3,8,4,13,13,6,11,5,8,14,14,5,11,7,9] } }
theorem leafL_243_0_valid : (leafL_243_0).reject.ValidFor (leafL_243_0).leaf := by decide

noncomputable def leafL_243_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,232,262}, reject := .fullRank { members := ![0,1,17,34,52,71,232,262], points := ![83,92,106,110,126,127], inverse := ![9,6,5,13,7,1,2,11,14,0,2,5,2,2,7,7,11,11,0,8,3,12,0,7,9,9,12,12,7,7,11,11,8,8,6,6] } }
theorem leafL_243_1_valid : (leafL_243_1).reject.ValidFor (leafL_243_1).leaf := by decide

noncomputable def leafL_243_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,232,269}, reject := .fullRank { members := ![0,1,17,34,52,71,232,269], points := ![83,94,126,128,133,144], inverse := ![3,4,6,8,6,14,5,2,12,5,15,1,15,15,15,15,8,8,0,7,7,15,0,15,15,15,5,5,5,5,14,14,7,7,1,1] } }
theorem leafL_243_2_valid : (leafL_243_2).reject.ValidFor (leafL_243_2).leaf := by decide

noncomputable def leafL_243_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,233,253}, reject := .fullRank { members := ![0,1,17,34,52,71,233,253], points := ![90,99,104,124,126,133], inverse := ![8,4,11,3,2,7,14,10,3,1,1,7,5,4,1,11,14,5,10,2,15,12,9,2,0,5,5,9,9,0,5,12,9,7,2,5] } }
theorem leafL_243_3_valid : (leafL_243_3).reject.ValidFor (leafL_243_3).leaf := by decide

noncomputable def leafL_243_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,233,262}, reject := .fullRank { members := ![0,1,17,34,52,71,233,262], points := ![90,91,96,99,109,126], inverse := ![3,9,5,8,0,6,11,8,10,1,15,7,12,8,4,0,0,0,9,6,7,6,9,7,8,0,8,12,12,0,13,12,1,3,3,0] } }
theorem leafL_243_4_valid : (leafL_243_4).reject.ValidFor (leafL_243_4).leaf := by decide

noncomputable def leafL_243_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,235,269}, reject := .fullRank { members := ![0,1,17,34,52,71,235,269], points := ![90,96,110,120,124,126], inverse := ![10,5,8,7,3,2,7,14,14,4,12,15,0,0,0,1,3,2,2,10,15,12,12,7,9,9,0,6,4,2,10,10,0,0,10,10] } }
theorem leafL_243_5_valid : (leafL_243_5).reject.ValidFor (leafL_243_5).leaf := by decide

noncomputable def leafL_243_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,237,246}, reject := .fullRank { members := ![0,1,17,34,52,71,237,246], points := ![83,91,92,104,110,122], inverse := ![5,13,7,5,13,6,15,15,9,3,13,7,13,15,2,0,0,0,10,15,13,0,15,7,6,6,0,5,5,0,6,2,4,12,12,0] } }
theorem leafL_243_6_valid : (leafL_243_6).reject.ValidFor (leafL_243_6).leaf := by decide

noncomputable def leafL_243_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,237,259}, reject := .fullRank { members := ![0,1,17,34,52,71,237,259], points := ![90,92,94,104,106,124], inverse := ![5,14,4,8,0,6,1,6,14,2,12,7,15,10,5,0,0,0,9,2,3,10,5,7,0,8,8,12,12,0,1,8,9,3,3,0] } }
theorem leafL_243_7_valid : (leafL_243_7).reject.ValidFor (leafL_243_7).leaf := by decide

noncomputable def leavesL_243 : List RejectedLeaf := [leafL_243_0,leafL_243_1,leafL_243_2,leafL_243_3,leafL_243_4,leafL_243_5,leafL_243_6,leafL_243_7]

theorem leavesL_243_valid : LeafListValid leavesL_243 := by
  intro x hx
  simp only [leavesL_243, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_243_0_valid
  · exact leafL_243_1_valid
  · exact leafL_243_2_valid
  · exact leafL_243_3_valid
  · exact leafL_243_4_valid
  · exact leafL_243_5_valid
  · exact leafL_243_6_valid
  · exact leafL_243_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
