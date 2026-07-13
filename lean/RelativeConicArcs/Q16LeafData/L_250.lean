import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_250_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,92,174}, reject := .fullRank { members := ![0,1,17,34,52,72,92,174], points := ![99,101,112,122,135,137], inverse := ![10,6,11,9,5,10,2,14,11,14,8,1,15,8,7,0,0,0,0,9,14,15,15,7,12,11,7,0,14,14,3,12,15,0,8,8] } }
theorem leafL_250_0_valid : (leafL_250_0).reject.ValidFor (leafL_250_0).leaf := by decide

noncomputable def leafL_250_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,92,183}, reject := .fullRank { members := ![0,1,17,34,52,72,92,183], points := ![101,107,122,137,138,149], inverse := ![15,12,15,6,2,9,12,9,13,5,0,13,6,5,11,14,4,2,9,5,8,4,3,3,5,1,6,1,10,9,10,11,8,2,4,15] } }
theorem leafL_250_1_valid : (leafL_250_1).reject.ValidFor (leafL_250_1).leaf := by decide

noncomputable def leafL_250_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,92,190}, reject := .fullRank { members := ![0,1,17,34,52,72,92,190], points := ![99,101,107,122,141,143], inverse := ![9,11,5,9,10,5,9,4,10,14,5,12,11,9,2,0,0,0,0,12,11,15,0,8,14,5,11,0,12,12,15,11,4,0,13,13] } }
theorem leafL_250_2_valid : (leafL_250_2).reject.ValidFor (leafL_250_2).leaf := by decide

noncomputable def leafL_250_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,92,198}, reject := .fullRank { members := ![0,1,17,34,52,72,92,198], points := ![101,126,137,138,149,151], inverse := ![9,0,11,6,12,9,0,3,6,14,13,6,7,13,3,2,2,9,7,15,3,11,14,14,8,12,3,6,5,4,4,6,6,13,1,8] } }
theorem leafL_250_3_valid : (leafL_250_3).reject.ValidFor (leafL_250_3).leaf := by decide

noncomputable def leafL_250_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,92,201}, reject := .fullRank { members := ![0,1,17,34,52,72,92,201], points := ![99,101,112,122,125,143], inverse := ![14,10,3,0,9,15,1,4,2,3,13,9,15,8,7,0,0,0,5,0,2,15,0,8,12,5,9,14,14,0,3,4,7,8,8,0] } }
theorem leafL_250_4_valid : (leafL_250_4).reject.ValidFor (leafL_250_4).leaf := by decide

noncomputable def leafL_250_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,92,202}, reject := .fullRank { members := ![0,1,17,34,52,72,92,202], points := ![99,101,135,141,147,159], inverse := ![11,2,1,12,3,6,4,6,7,3,3,5,6,6,4,4,5,5,12,1,12,13,9,5,12,12,7,7,1,1,13,13,13,13,13,13] } }
theorem leafL_250_5_valid : (leafL_250_5).reject.ValidFor (leafL_250_5).leaf := by decide

noncomputable def leafL_250_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,92,249}, reject := .fullRank { members := ![0,1,17,34,52,72,92,249], points := ![107,112,122,126,135,143], inverse := ![13,10,13,4,8,7,2,5,2,12,9,0,4,4,10,10,14,14,3,4,7,8,6,14,14,14,13,13,2,2,5,5,12,12,11,11] } }
theorem leafL_250_6_valid : (leafL_250_6).reject.ValidFor (leafL_250_6).leaf := by decide

noncomputable def leafL_250_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,92,263}, reject := .fullRank { members := ![0,1,17,34,52,72,92,263], points := ![101,107,112,122,143,147], inverse := ![4,13,2,3,1,8,11,12,6,11,14,4,15,14,1,0,0,0,12,11,0,15,8,0,15,10,13,12,5,1,12,5,14,13,1,11] } }
theorem leafL_250_7_valid : (leafL_250_7).reject.ValidFor (leafL_250_7).leaf := by decide

noncomputable def leavesL_250 : List RejectedLeaf := [leafL_250_0,leafL_250_1,leafL_250_2,leafL_250_3,leafL_250_4,leafL_250_5,leafL_250_6,leafL_250_7]

theorem leavesL_250_valid : LeafListValid leavesL_250 := by
  intro x hx
  simp only [leavesL_250, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_250_0_valid
  · exact leafL_250_1_valid
  · exact leafL_250_2_valid
  · exact leafL_250_3_valid
  · exact leafL_250_4_valid
  · exact leafL_250_5_valid
  · exact leafL_250_6_valid
  · exact leafL_250_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
