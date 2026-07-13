import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_231_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,182,233}, reject := .fullRank { members := ![0,1,17,34,52,71,182,233], points := ![91,94,96,99,104,126], inverse := ![12,4,7,8,0,6,9,5,5,15,1,7,15,3,12,0,0,0,7,3,12,11,4,7,7,15,8,10,10,0,11,0,11,11,11,0] } }
theorem leafL_231_0_valid : (leafL_231_0).reject.ValidFor (leafL_231_0).leaf := by decide

noncomputable def leafL_231_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,182,237}, reject := .fullRank { members := ![0,1,17,34,52,71,182,237], points := ![91,92,94,106,110,121], inverse := ![6,10,3,2,10,6,8,1,0,4,10,7,6,7,1,0,0,0,11,14,13,10,5,7,2,4,6,1,1,0,12,9,5,13,13,0] } }
theorem leafL_231_1_valid : (leafL_231_1).reject.ValidFor (leafL_231_1).leaf := by decide

noncomputable def leafL_231_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,182,239}, reject := .fullRank { members := ![0,1,17,34,52,71,182,239], points := ![91,92,93,99,104,122], inverse := ![9,2,4,9,1,6,2,1,10,9,7,7,7,6,1,0,0,0,11,5,6,13,2,7,11,9,2,10,10,0,14,10,4,11,11,0] } }
theorem leafL_231_2_valid : (leafL_231_2).reject.ValidFor (leafL_231_2).leaf := by decide

noncomputable def leafL_231_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,182,243}, reject := .fullRank { members := ![0,1,17,34,52,71,182,243], points := ![93,94,101,104,106,121], inverse := ![8,7,11,11,8,6,11,2,7,14,7,7,0,0,13,1,12,0,6,14,8,15,8,7,5,5,2,4,6,0,1,1,7,12,11,0] } }
theorem leafL_231_3_valid : (leafL_231_3).reject.ValidFor (leafL_231_3).leaf := by decide

noncomputable def leafL_231_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,182,249}, reject := .fullRank { members := ![0,1,17,34,52,71,182,249], points := ![92,93,94,101,104,122], inverse := ![4,9,2,8,0,6,12,12,9,8,6,7,1,6,7,0,0,0,0,15,7,4,11,7,9,6,15,13,13,0,2,13,15,14,14,0] } }
theorem leafL_231_4_valid : (leafL_231_4).reject.ValidFor (leafL_231_4).leaf := by decide

noncomputable def leafL_231_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,182,267}, reject := .fullRank { members := ![0,1,17,34,52,71,182,267], points := ![92,93,94,99,101,121], inverse := ![6,15,6,2,10,6,4,0,13,15,1,7,1,6,7,0,0,0,15,2,5,0,15,7,14,7,9,15,15,0,7,0,7,7,7,0] } }
theorem leafL_231_5_valid : (leafL_231_5).reject.ValidFor (leafL_231_5).leaf := by decide

noncomputable def leafL_231_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,182,268}, reject := .fullRank { members := ![0,1,17,34,52,71,182,268], points := ![91,104,110,122,126,127], inverse := ![15,1,9,14,6,14,9,15,1,12,10,1,0,0,0,8,10,2,8,3,12,9,1,15,0,11,11,3,6,5,0,4,4,13,8,5] } }
theorem leafL_231_6_valid : (leafL_231_6).reject.ValidFor (leafL_231_6).leaf := by decide

noncomputable def leafL_231_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,185,197}, reject := .fullRank { members := ![0,1,17,34,52,71,185,197], points := ![83,92,104,106,109,126], inverse := ![3,12,13,3,6,6,6,15,10,13,9,7,0,0,15,14,1,0,3,11,8,1,6,7,10,10,8,14,6,0,2,2,8,15,7,0] } }
theorem leafL_231_7_valid : (leafL_231_7).reject.ValidFor (leafL_231_7).leaf := by decide

noncomputable def leavesL_231 : List RejectedLeaf := [leafL_231_0,leafL_231_1,leafL_231_2,leafL_231_3,leafL_231_4,leafL_231_5,leafL_231_6,leafL_231_7]

theorem leavesL_231_valid : LeafListValid leavesL_231 := by
  intro x hx
  simp only [leavesL_231, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_231_0_valid
  · exact leafL_231_1_valid
  · exact leafL_231_2_valid
  · exact leafL_231_3_valid
  · exact leafL_231_4_valid
  · exact leafL_231_5_valid
  · exact leafL_231_6_valid
  · exact leafL_231_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
