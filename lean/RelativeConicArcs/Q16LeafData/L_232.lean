import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_232_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,185,213}, reject := .fullRank { members := ![0,1,17,34,52,71,185,213], points := ![83,91,92,104,110,124], inverse := ![15,15,15,8,0,6,6,3,12,11,5,7,13,15,2,0,0,0,3,3,8,8,7,7,6,6,0,5,5,0,6,2,4,12,12,0] } }
theorem leafL_232_0_valid : (leafL_232_0).reject.ValidFor (leafL_232_0).leaf := by decide

noncomputable def leafL_232_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,185,222}, reject := .fullRank { members := ![0,1,17,34,52,71,185,222], points := ![83,92,93,109,124,131], inverse := ![5,6,1,5,11,13,10,13,4,4,13,10,6,12,10,0,0,0,0,7,15,15,7,0,7,2,3,6,6,6,8,8,8,8,8,8] } }
theorem leafL_232_1_valid : (leafL_232_1).reject.ValidFor (leafL_232_1).leaf := by decide

noncomputable def leafL_232_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,185,232}, reject := .fullRank { members := ![0,1,17,34,52,71,185,232], points := ![83,92,93,106,110,127], inverse := ![15,15,15,8,0,6,12,13,8,13,3,7,6,12,10,0,0,0,0,8,0,3,12,7,15,0,15,1,1,0,10,1,11,13,13,0] } }
theorem leafL_232_2_valid : (leafL_232_2).reject.ValidFor (leafL_232_2).leaf := by decide

noncomputable def leafL_232_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,186,217}, reject := .fullRank { members := ![0,1,17,34,52,71,186,217], points := ![91,96,101,104,131,144], inverse := ![1,8,8,6,6,0,2,12,8,1,7,0,11,11,9,9,2,2,15,0,12,4,1,6,9,9,10,10,15,15,4,4,13,13,12,12] } }
theorem leafL_232_3_valid : (leafL_232_3).reject.ValidFor (leafL_232_3).leaf := by decide

noncomputable def leafL_232_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,186,232}, reject := .fullRank { members := ![0,1,17,34,52,71,186,232], points := ![93,127,128,133,141,144], inverse := ![7,3,13,2,0,10,7,8,1,10,1,5,0,0,0,6,5,3,7,7,15,2,8,5,0,7,7,8,14,6,0,1,1,12,4,8] } }
theorem leafL_232_4_valid : (leafL_232_4).reject.ValidFor (leafL_232_4).leaf := by decide

noncomputable def leafL_232_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,186,239}, reject := .fullRank { members := ![0,1,17,34,52,71,186,239], points := ![91,93,99,104,128,131], inverse := ![3,8,0,12,2,4,7,8,4,12,1,6,10,12,8,14,6,6,9,3,1,12,5,2,0,9,5,12,9,9,10,0,0,10,10,10] } }
theorem leafL_232_5_valid : (leafL_232_5).reject.ValidFor (leafL_232_5).leaf := by decide

noncomputable def leafL_232_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,186,268}, reject := .fullRank { members := ![0,1,17,34,52,71,186,268], points := ![93,101,104,127,128,131], inverse := ![3,4,0,3,9,12,4,9,10,1,11,13,1,0,1,6,7,1,10,12,1,1,4,2,5,15,10,14,11,5,15,11,4,10,5,15] } }
theorem leafL_232_6_valid : (leafL_232_6).reject.ValidFor (leafL_232_6).leaf := by decide

noncomputable def leafL_232_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,186,269}, reject := .fullRank { members := ![0,1,17,34,52,71,186,269], points := ![91,96,104,124,128,131], inverse := ![2,2,7,7,14,15,1,6,0,7,14,14,12,11,7,13,10,7,14,5,12,14,10,3,12,10,6,12,10,6,10,0,10,0,10,10] } }
theorem leafL_232_7_valid : (leafL_232_7).reject.ValidFor (leafL_232_7).leaf := by decide

noncomputable def leavesL_232 : List RejectedLeaf := [leafL_232_0,leafL_232_1,leafL_232_2,leafL_232_3,leafL_232_4,leafL_232_5,leafL_232_6,leafL_232_7]

theorem leavesL_232_valid : LeafListValid leavesL_232 := by
  intro x hx
  simp only [leavesL_232, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_232_0_valid
  · exact leafL_232_1_valid
  · exact leafL_232_2_valid
  · exact leafL_232_3_valid
  · exact leafL_232_4_valid
  · exact leafL_232_5_valid
  · exact leafL_232_6_valid
  · exact leafL_232_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
