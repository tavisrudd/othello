import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_282_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,185,220}, reject := .fullRank { members := ![0,1,17,34,52,72,185,220], points := ![91,94,99,115,117,139], inverse := ![2,7,2,4,8,10,4,8,11,8,10,5,12,6,10,13,7,10,6,11,10,15,13,5,3,7,4,2,6,4,5,0,5,5,0,5] } }
theorem leafL_282_0_valid : (leafL_282_0).reject.ValidFor (leafL_282_0).leaf := by decide

noncomputable def leafL_282_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,185,222}, reject := .fullRank { members := ![0,1,17,34,52,72,185,222], points := ![92,96,99,117,125,138], inverse := ![14,13,4,0,10,12,7,14,14,8,15,0,11,1,10,6,12,10,10,15,2,13,7,13,7,11,12,9,5,12,0,9,9,9,0,9] } }
theorem leafL_282_1_valid : (leafL_282_1).reject.ValidFor (leafL_282_1).leaf := by decide

noncomputable def leafL_282_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,185,240}, reject := .fullRank { members := ![0,1,17,34,52,72,185,240], points := ![92,94,99,103,115,125], inverse := ![3,12,9,1,12,10,4,13,6,8,2,5,5,5,5,5,13,13,5,13,10,5,9,14,11,11,2,2,10,10,13,13,7,7,9,9] } }
theorem leafL_282_2_valid : (leafL_282_2).reject.ValidFor (leafL_282_2).leaf := by decide

noncomputable def leafL_282_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,185,251}, reject := .fullRank { members := ![0,1,17,34,52,72,185,251], points := ![92,93,94,99,125,126], inverse := ![13,4,6,8,0,6,3,4,14,14,11,12,1,6,7,0,0,0,6,7,9,15,10,13,1,5,4,0,2,2,0,9,9,0,9,9] } }
theorem leafL_282_3_valid : (leafL_282_3).reject.ValidFor (leafL_282_3).leaf := by decide

noncomputable def leafL_282_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,185,268}, reject := .fullRank { members := ![0,1,17,34,52,72,185,268], points := ![91,93,103,126,139,144], inverse := ![0,5,2,12,2,8,13,4,14,7,12,12,10,7,13,13,9,4,3,14,10,2,3,6,5,12,9,9,7,14,6,11,13,13,1,12] } }
theorem leafL_282_4_valid : (leafL_282_4).reject.ValidFor (leafL_282_4).leaf := by decide

noncomputable def leafL_282_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,186,197}, reject := .fullRank { members := ![0,1,17,34,52,72,186,197], points := ![99,103,107,115,125,137], inverse := ![11,8,4,8,1,15,0,6,1,4,10,9,7,11,12,0,0,0,11,0,12,0,15,8,3,5,6,5,5,0,11,5,14,1,1,0] } }
theorem leafL_282_5_valid : (leafL_282_5).reject.ValidFor (leafL_282_5).leaf := by decide

noncomputable def leafL_282_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,186,213}, reject := .fullRank { members := ![0,1,17,34,52,72,186,213], points := ![96,99,103,107,124,125], inverse := ![15,12,5,1,5,3,9,3,15,2,3,4,0,7,11,12,0,0,8,0,13,2,14,9,0,14,2,12,10,10,0,13,1,12,2,2] } }
theorem leafL_282_6_valid : (leafL_282_6).reject.ValidFor (leafL_282_6).leaf := by decide

noncomputable def leafL_282_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,186,217}, reject := .fullRank { members := ![0,1,17,34,52,72,186,217], points := ![91,96,101,107,108,125], inverse := ![9,6,1,7,14,6,7,14,9,2,5,7,0,0,11,3,8,0,4,12,1,8,6,7,1,1,15,14,1,0,11,11,10,13,7,0] } }
theorem leafL_282_7_valid : (leafL_282_7).reject.ValidFor (leafL_282_7).leaf := by decide

noncomputable def leavesL_282 : List RejectedLeaf := [leafL_282_0,leafL_282_1,leafL_282_2,leafL_282_3,leafL_282_4,leafL_282_5,leafL_282_6,leafL_282_7]

theorem leavesL_282_valid : LeafListValid leavesL_282 := by
  intro x hx
  simp only [leavesL_282, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_282_0_valid
  · exact leafL_282_1_valid
  · exact leafL_282_2_valid
  · exact leafL_282_3_valid
  · exact leafL_282_4_valid
  · exact leafL_282_5_valid
  · exact leafL_282_6_valid
  · exact leafL_282_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
