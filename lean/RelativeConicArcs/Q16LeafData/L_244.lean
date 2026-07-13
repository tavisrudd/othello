import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_244_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,239,259}, reject := .fullRank { members := ![0,1,17,34,52,71,239,259], points := ![90,92,104,126,128,139], inverse := ![15,4,12,11,9,4,13,1,11,13,15,5,15,5,10,4,14,10,7,4,4,11,7,11,5,2,7,9,14,7,13,13,0,13,13,0] } }
theorem leafL_244_0_valid : (leafL_244_0).reject.ValidFor (leafL_244_0).leaf := by decide

noncomputable def leafL_244_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,239,269}, reject := .fullRank { members := ![0,1,17,34,52,71,239,269], points := ![90,91,94,104,126,128], inverse := ![14,5,4,8,12,10,3,3,9,14,15,8,10,2,8,0,0,0,15,14,9,15,10,13,11,3,8,0,1,1,2,6,4,0,13,13] } }
theorem leafL_244_1_valid : (leafL_244_1).reject.ValidFor (leafL_244_1).leaf := by decide

noncomputable def leafL_244_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,240,249}, reject := .fullRank { members := ![0,1,17,34,52,71,240,249], points := ![94,101,104,106,120,122], inverse := ![15,7,13,2,2,4,9,5,3,8,2,5,0,13,1,12,0,0,8,15,12,12,15,8,0,10,8,2,5,5,0,0,1,1,1,1] } }
theorem leafL_244_2_valid : (leafL_244_2).reject.ValidFor (leafL_244_2).leaf := by decide

noncomputable def leafL_244_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,240,259}, reject := .fullRank { members := ![0,1,17,34,52,71,240,259], points := ![90,94,104,106,110,120], inverse := ![1,14,13,6,3,6,12,5,7,12,5,7,0,0,7,4,3,0,2,10,7,2,10,7,12,12,15,2,13,0,13,13,0,13,13,0] } }
theorem leafL_244_3_valid : (leafL_244_3).reject.ValidFor (leafL_244_3).leaf := by decide

noncomputable def leafL_244_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,240,267}, reject := .fullRank { members := ![0,1,17,34,52,71,240,267], points := ![94,99,101,104,120,122], inverse := ![15,15,0,7,2,4,9,9,10,13,2,5,0,4,12,8,0,0,8,4,14,5,15,8,0,15,13,2,5,5,0,14,10,4,1,1] } }
theorem leafL_244_4_valid : (leafL_244_4).reject.ValidFor (leafL_244_4).leaf := by decide

noncomputable def leafL_244_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,243,268}, reject := .fullRank { members := ![0,1,17,34,52,71,243,268], points := ![90,93,101,104,127,128], inverse := ![9,6,5,13,5,3,12,5,2,12,14,9,5,5,10,10,15,15,10,2,11,4,0,7,2,2,11,11,5,5,6,6,7,7,4,4] } }
theorem leafL_244_5_valid : (leafL_244_5).reject.ValidFor (leafL_244_5).leaf := by decide

noncomputable def leafL_244_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,243,269}, reject := .fullRank { members := ![0,1,17,34,52,71,243,269], points := ![90,94,104,128,133,138], inverse := ![2,14,11,5,4,7,13,15,5,12,3,8,1,12,13,13,15,2,5,6,4,12,6,13,8,14,6,6,2,4,13,8,5,5,6,3] } }
theorem leafL_244_6_valid : (leafL_244_6).reject.ValidFor (leafL_244_6).leaf := by decide

noncomputable def leafL_244_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,243,271}, reject := .fullRank { members := ![0,1,17,34,52,71,243,271], points := ![90,93,104,124,138,140], inverse := ![13,7,13,3,10,15,14,7,14,7,15,15,10,12,6,6,12,10,2,3,6,14,8,1,13,13,0,0,15,15,9,7,14,14,8,6] } }
theorem leafL_244_7_valid : (leafL_244_7).reject.ValidFor (leafL_244_7).leaf := by decide

noncomputable def leavesL_244 : List RejectedLeaf := [leafL_244_0,leafL_244_1,leafL_244_2,leafL_244_3,leafL_244_4,leafL_244_5,leafL_244_6,leafL_244_7]

theorem leavesL_244_valid : LeafListValid leavesL_244 := by
  intro x hx
  simp only [leavesL_244, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_244_0_valid
  · exact leafL_244_1_valid
  · exact leafL_244_2_valid
  · exact leafL_244_3_valid
  · exact leafL_244_4_valid
  · exact leafL_244_5_valid
  · exact leafL_244_6_valid
  · exact leafL_244_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
