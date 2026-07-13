import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_281_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,183,237}, reject := .fullRank { members := ![0,1,17,34,52,72,183,237], points := ![83,91,107,112,122,124], inverse := ![2,13,9,1,5,3,14,7,6,8,0,7,15,15,3,3,7,7,1,9,11,4,4,3,8,8,2,2,10,10,8,8,15,15,5,5] } }
theorem leafL_281_0_valid : (leafL_281_0).reject.ValidFor (leafL_281_0).leaf := by decide

noncomputable def leafL_281_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,183,239}, reject := .fullRank { members := ![0,1,17,34,52,72,183,239], points := ![83,92,93,107,112,117], inverse := ![3,1,13,10,2,6,0,11,2,7,9,7,6,12,10,0,0,0,6,9,7,4,11,7,4,5,1,10,10,0,12,13,1,11,11,0] } }
theorem leafL_281_1_valid : (leafL_281_1).reject.ValidFor (leafL_281_1).leaf := by decide

noncomputable def leafL_281_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,183,240}, reject := .fullRank { members := ![0,1,17,34,52,72,183,240], points := ![92,117,122,124,137,138], inverse := ![7,15,7,6,12,4,7,12,4,1,15,1,0,6,2,4,0,0,7,9,11,10,6,9,0,5,9,12,6,6,0,10,15,5,1,1] } }
theorem leafL_281_2_valid : (leafL_281_2).reject.ValidFor (leafL_281_2).leaf := by decide

noncomputable def leafL_281_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,183,243}, reject := .fullRank { members := ![0,1,17,34,52,72,183,243], points := ![93,101,107,112,117,122], inverse := ![15,4,2,14,14,8,9,12,13,15,6,1,0,15,14,1,0,0,8,4,13,6,5,2,0,5,14,11,12,12,0,14,15,1,13,13] } }
theorem leafL_281_3_valid : (leafL_281_3).reject.ValidFor (leafL_281_3).leaf := by decide

noncomputable def leafL_281_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,183,270}, reject := .fullRank { members := ![0,1,17,34,52,72,183,270], points := ![83,93,101,112,117,124], inverse := ![4,11,8,0,10,12,9,0,4,10,15,8,2,2,4,4,14,14,10,2,10,5,0,7,14,14,5,5,7,7,9,9,2,2,3,3] } }
theorem leafL_281_4_valid : (leafL_281_4).reject.ValidFor (leafL_281_4).leaf := by decide

noncomputable def leafL_281_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,183,271}, reject := .fullRank { members := ![0,1,17,34,52,72,183,271], points := ![93,112,122,124,137,138], inverse := ![9,14,0,0,0,6,14,9,8,8,3,4,14,14,7,9,0,14,7,0,9,1,10,5,9,9,7,14,6,15,1,1,0,1,1,0] } }
theorem leafL_281_5_valid : (leafL_281_5).reject.ValidFor (leafL_281_5).leaf := by decide

noncomputable def leafL_281_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,185,197}, reject := .fullRank { members := ![0,1,17,34,52,72,185,197], points := ![92,94,99,103,115,125], inverse := ![3,12,9,1,12,10,4,13,6,8,2,5,5,5,5,5,13,13,5,13,10,5,9,14,11,11,2,2,10,10,13,13,7,7,9,9] } }
theorem leafL_281_6_valid : (leafL_281_6).reject.ValidFor (leafL_281_6).leaf := by decide

noncomputable def leafL_281_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,185,208}, reject := .fullRank { members := ![0,1,17,34,52,72,185,208], points := ![91,94,103,117,125,126], inverse := ![3,12,8,4,1,3,14,7,14,13,11,1,0,0,0,13,15,2,11,3,15,8,3,12,10,10,0,6,1,7,3,3,0,4,11,15] } }
theorem leafL_281_7_valid : (leafL_281_7).reject.ValidFor (leafL_281_7).leaf := by decide

noncomputable def leavesL_281 : List RejectedLeaf := [leafL_281_0,leafL_281_1,leafL_281_2,leafL_281_3,leafL_281_4,leafL_281_5,leafL_281_6,leafL_281_7]

theorem leavesL_281_valid : LeafListValid leavesL_281 := by
  intro x hx
  simp only [leavesL_281, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_281_0_valid
  · exact leafL_281_1_valid
  · exact leafL_281_2_valid
  · exact leafL_281_3_valid
  · exact leafL_281_4_valid
  · exact leafL_281_5_valid
  · exact leafL_281_6_valid
  · exact leafL_281_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
