import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_223_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,171,223}, reject := .fullRank { members := ![0,1,17,34,52,71,171,223], points := ![83,90,101,106,126,138], inverse := ![13,15,7,2,11,13,0,14,0,9,0,7,5,15,9,3,10,10,4,6,10,15,13,10,2,2,3,3,0,0,8,1,7,14,9,9] } }
theorem leafL_223_0_valid : (leafL_223_0).reject.ValidFor (leafL_223_0).leaf := by decide

noncomputable def leafL_223_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,171,232}, reject := .fullRank { members := ![0,1,17,34,52,71,171,232], points := ![83,92,101,106,126,127], inverse := ![1,14,6,14,13,11,2,11,0,14,2,5,3,3,4,4,7,7,14,6,13,2,4,3,7,7,13,13,3,3,14,14,7,7,15,15] } }
theorem leafL_223_1_valid : (leafL_223_1).reject.ValidFor (leafL_223_1).leaf := by decide

noncomputable def leafL_223_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,171,233}, reject := .fullRank { members := ![0,1,17,34,52,71,171,233], points := ![90,101,106,124,126,127], inverse := ![15,4,12,9,15,0,9,0,14,10,15,2,0,0,0,4,12,8,8,15,0,15,12,4,0,8,8,5,14,11,0,13,13,10,6,12] } }
theorem leafL_223_2_valid : (leafL_223_2).reject.ValidFor (leafL_223_2).leaf := by decide

noncomputable def leafL_223_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,171,239}, reject := .fullRank { members := ![0,1,17,34,52,71,171,239], points := ![90,92,126,128,182,213], inverse := ![9,5,9,14,8,2,13,5,2,7,13,0,3,0,6,14,15,4,8,5,13,4,1,5,14,8,13,14,13,8,13,13,13,13,0,0] } }
theorem leafL_223_3_valid : (leafL_223_3).reject.ValidFor (leafL_223_3).leaf := by decide

noncomputable def leafL_223_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,171,243}, reject := .fullRank { members := ![0,1,17,34,52,71,171,243], points := ![90,101,106,124,127,128], inverse := ![15,4,12,2,7,3,9,0,14,1,5,3,0,0,0,6,11,13,8,15,0,13,7,13,0,8,8,9,1,8,0,13,13,11,4,15] } }
theorem leafL_223_4_valid : (leafL_223_4).reject.ValidFor (leafL_223_4).leaf := by decide

noncomputable def leafL_223_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,171,249}, reject := .fullRank { members := ![0,1,17,34,52,71,171,249], points := ![83,92,101,106,109,120], inverse := ![0,15,3,14,5,6,12,5,2,9,5,7,0,0,9,10,3,0,9,1,10,9,12,7,10,10,6,11,13,0,2,2,6,10,12,0] } }
theorem leafL_223_5_valid : (leafL_223_5).reject.ValidFor (leafL_223_5).leaf := by decide

noncomputable def leafL_223_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,171,259}, reject := .fullRank { members := ![0,1,17,34,52,71,171,259], points := ![90,92,120,124,127,186], inverse := ![0,4,3,0,0,6,8,0,9,1,13,13,0,0,7,2,5,0,5,15,15,2,14,9,8,8,2,14,12,0,13,13,3,11,8,0] } }
theorem leafL_223_6_valid : (leafL_223_6).reject.ValidFor (leafL_223_6).leaf := by decide

noncomputable def leafL_223_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,171,269}, reject := .fullRank { members := ![0,1,17,34,52,71,171,269], points := ![83,90,120,124,126,138], inverse := ![14,9,5,13,6,8,0,7,4,2,15,14,0,0,1,3,2,0,12,11,2,2,8,15,15,15,2,8,10,0,11,11,15,8,7,0] } }
theorem leafL_223_7_valid : (leafL_223_7).reject.ValidFor (leafL_223_7).leaf := by decide

noncomputable def leavesL_223 : List RejectedLeaf := [leafL_223_0,leafL_223_1,leafL_223_2,leafL_223_3,leafL_223_4,leafL_223_5,leafL_223_6,leafL_223_7]

theorem leavesL_223_valid : LeafListValid leavesL_223 := by
  intro x hx
  simp only [leavesL_223, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_223_0_valid
  · exact leafL_223_1_valid
  · exact leafL_223_2_valid
  · exact leafL_223_3_valid
  · exact leafL_223_4_valid
  · exact leafL_223_5_valid
  · exact leafL_223_6_valid
  · exact leafL_223_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
