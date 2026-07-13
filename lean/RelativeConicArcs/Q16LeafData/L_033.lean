import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_033_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,169}, reject := .fullRank { members := ![0,1,17,34,52,69,92,169], points := ![99,107,122,127,131,139], inverse := ![8,15,9,0,5,10,2,5,15,1,6,15,9,9,5,5,8,8,2,5,13,2,10,2,8,8,14,14,15,15,14,14,0,0,14,14] } }
theorem leafL_033_0_valid : (leafL_033_0).reject.ValidFor (leafL_033_0).leaf := by decide

noncomputable def leafL_033_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,173}, reject := .fullRank { members := ![0,1,17,34,52,69,92,173], points := ![104,107,122,126,127,131], inverse := ![2,5,13,3,7,15,1,6,14,9,9,9,0,0,8,10,2,0,8,15,12,3,0,8,8,8,10,0,10,0,13,13,7,9,14,0] } }
theorem leafL_033_1_valid : (leafL_033_1).reject.ValidFor (leafL_033_1).leaf := by decide

noncomputable def leafL_033_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,174}, reject := .fullRank { members := ![0,1,17,34,52,69,92,174], points := ![99,131,135,137,152,154], inverse := ![9,12,3,2,11,14,2,14,11,1,2,4,0,3,4,7,0,0,13,6,0,7,1,13,0,1,10,11,4,4,0,0,11,11,11,11] } }
theorem leafL_033_2_valid : (leafL_033_2).reject.ValidFor (leafL_033_2).leaf := by decide

noncomputable def leafL_033_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,175}, reject := .fullRank { members := ![0,1,17,34,52,69,92,175], points := ![104,107,122,126,135,138], inverse := ![13,10,8,1,15,0,6,1,7,9,11,2,11,11,3,3,15,15,11,12,14,1,7,15,9,9,11,11,6,6,9,9,3,3,11,11] } }
theorem leafL_033_3_valid : (leafL_033_3).reject.ValidFor (leafL_033_3).leaf := by decide

noncomputable def leafL_033_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,182}, reject := .fullRank { members := ![0,1,17,34,52,69,92,182], points := ![99,104,126,131,135,138], inverse := ![7,0,9,9,11,13,14,9,14,2,13,6,0,0,0,12,2,14,13,10,15,12,6,2,2,2,0,2,9,11,12,12,0,9,14,7] } }
theorem leafL_033_4_valid : (leafL_033_4).reject.ValidFor (leafL_033_4).leaf := by decide

noncomputable def leafL_033_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,184}, reject := .fullRank { members := ![0,1,17,34,52,69,92,184], points := ![99,126,127,135,139,141], inverse := ![7,9,0,1,9,7,7,13,3,4,10,7,0,0,0,1,3,2,7,6,9,15,6,1,0,12,12,14,0,14,0,14,14,5,8,13] } }
theorem leafL_033_5_valid : (leafL_033_5).reject.ValidFor (leafL_033_5).leaf := by decide

noncomputable def leafL_033_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,189}, reject := .fullRank { members := ![0,1,17,34,52,69,92,189], points := ![104,107,122,127,131,135], inverse := ![3,4,3,10,14,1,6,1,2,12,14,7,6,6,10,10,6,6,9,14,2,13,9,1,8,8,10,10,0,0,10,10,11,11,7,7] } }
theorem leafL_033_6_valid : (leafL_033_6).reject.ValidFor (leafL_033_6).leaf := by decide

noncomputable def leafL_033_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,190}, reject := .fullRank { members := ![0,1,17,34,52,69,92,190], points := ![104,107,122,127,137,139], inverse := ![9,14,14,7,12,3,14,9,9,7,15,6,10,10,13,13,7,7,1,6,9,6,7,15,8,8,10,10,0,0,4,4,10,10,1,1] } }
theorem leafL_033_7_valid : (leafL_033_7).reject.ValidFor (leafL_033_7).leaf := by decide

noncomputable def leavesL_033 : List RejectedLeaf := [leafL_033_0,leafL_033_1,leafL_033_2,leafL_033_3,leafL_033_4,leafL_033_5,leafL_033_6,leafL_033_7]

theorem leavesL_033_valid : LeafListValid leavesL_033 := by
  intro x hx
  simp only [leavesL_033, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_033_0_valid
  · exact leafL_033_1_valid
  · exact leafL_033_2_valid
  · exact leafL_033_3_valid
  · exact leafL_033_4_valid
  · exact leafL_033_5_valid
  · exact leafL_033_6_valid
  · exact leafL_033_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
