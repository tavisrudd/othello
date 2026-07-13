import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_275_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,151,233}, reject := .fullRank { members := ![0,1,17,34,52,72,151,233], points := ![91,94,99,112,115,117], inverse := ![13,2,5,13,15,9,10,3,1,15,4,3,3,3,13,13,6,6,8,0,0,15,3,4,5,5,12,12,3,3,11,11,15,15,9,9] } }
theorem leafL_275_0_valid : (leafL_275_0).reject.ValidFor (leafL_275_0).leaf := by decide

noncomputable def leafL_275_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,151,243}, reject := .fullRank { members := ![0,1,17,34,52,72,151,243], points := ![90,93,94,101,112,117], inverse := ![10,7,2,7,15,6,12,8,13,14,0,7,6,11,13,0,0,0,5,7,10,8,7,7,4,6,2,7,7,0,9,3,10,5,5,0] } }
theorem leafL_275_1_valid : (leafL_275_1).reject.ValidFor (leafL_275_1).leaf := by decide

noncomputable def leafL_275_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,151,262}, reject := .fullRank { members := ![0,1,17,34,52,72,151,262], points := ![90,91,92,99,108,117], inverse := ![2,9,4,4,12,6,1,12,4,10,4,7,7,14,9,0,0,0,7,11,4,15,0,7,6,9,15,8,8,0,13,8,5,2,2,0] } }
theorem leafL_275_2_valid : (leafL_275_2).reject.ValidFor (leafL_275_2).leaf := by decide

noncomputable def leafL_275_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,156,174}, reject := .fullRank { members := ![0,1,17,34,52,72,156,174], points := ![99,103,117,135,137,143], inverse := ![0,7,9,7,4,12,10,13,14,5,4,8,0,0,0,2,9,11,3,4,15,15,2,5,11,11,0,2,13,15,15,15,0,2,3,1] } }
theorem leafL_275_3_valid : (leafL_275_3).reject.ValidFor (leafL_275_3).leaf := by decide

noncomputable def leafL_275_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,156,183}, reject := .fullRank { members := ![0,1,17,34,52,72,156,183], points := ![83,107,117,122,128,137], inverse := ![4,3,9,10,14,11,1,6,11,15,11,8,0,0,7,15,8,0,9,14,7,11,10,1,6,6,15,1,8,6,1,1,12,14,3,1] } }
theorem leafL_275_4_valid : (leafL_275_4).reject.ValidFor (leafL_275_4).leaf := by decide

noncomputable def leafL_275_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,156,191}, reject := .fullRank { members := ![0,1,17,34,52,72,156,191], points := ![96,99,103,117,122,128], inverse := ![15,15,7,1,10,13,9,5,11,8,6,9,0,0,0,7,15,8,8,6,9,0,8,15,0,9,9,14,4,10,0,10,10,11,6,13] } }
theorem leafL_275_5_valid : (leafL_275_5).reject.ValidFor (leafL_275_5).leaf := by decide

noncomputable def leafL_275_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,156,202}, reject := .fullRank { members := ![0,1,17,34,52,72,156,202], points := ![99,103,117,135,139,141], inverse := ![0,7,9,11,10,14,10,13,14,15,13,11,0,0,0,1,3,2,3,4,15,2,10,0,11,11,0,1,7,6,15,15,0,1,9,8] } }
theorem leafL_275_6_valid : (leafL_275_6).reject.ValidFor (leafL_275_6).leaf := by decide

noncomputable def leafL_275_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,156,203}, reject := .fullRank { members := ![0,1,17,34,52,72,156,203], points := ![83,99,115,122,141,174], inverse := ![11,9,5,15,15,6,9,14,7,0,0,0,2,4,11,8,1,4,9,7,9,5,12,14,6,1,13,13,12,11,9,4,7,11,6,7] } }
theorem leafL_275_7_valid : (leafL_275_7).reject.ValidFor (leafL_275_7).leaf := by decide

noncomputable def leavesL_275 : List RejectedLeaf := [leafL_275_0,leafL_275_1,leafL_275_2,leafL_275_3,leafL_275_4,leafL_275_5,leafL_275_6,leafL_275_7]

theorem leavesL_275_valid : LeafListValid leavesL_275 := by
  intro x hx
  simp only [leavesL_275, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_275_0_valid
  · exact leafL_275_1_valid
  · exact leafL_275_2_valid
  · exact leafL_275_3_valid
  · exact leafL_275_4_valid
  · exact leafL_275_5_valid
  · exact leafL_275_6_valid
  · exact leafL_275_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
