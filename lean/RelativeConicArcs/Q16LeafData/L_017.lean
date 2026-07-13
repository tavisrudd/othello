import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_017_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,159}, reject := .fullRank { members := ![0,1,17,34,52,69,89,159], points := ![104,106,110,115,124,131], inverse := ![5,6,4,5,12,15,10,4,9,14,0,9,7,4,3,0,0,0,12,12,7,2,13,8,0,9,9,6,6,0,3,4,7,15,15,0] } }
theorem leafL_017_0_valid : (leafL_017_0).reject.ValidFor (leafL_017_0).leaf := by decide

noncomputable def leafL_017_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,166}, reject := .fullRank { members := ![0,1,17,34,52,69,89,166], points := ![99,104,110,127,128,135], inverse := ![3,1,5,7,14,15,10,10,7,7,9,9,7,13,10,0,0,0,13,12,6,12,3,8,15,10,5,3,3,0,13,6,11,14,14,0] } }
theorem leafL_017_1_valid : (leafL_017_1).reject.ValidFor (leafL_017_1).leaf := by decide

noncomputable def leafL_017_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,171}, reject := .fullRank { members := ![0,1,17,34,52,69,89,171], points := ![99,106,115,126,127,141], inverse := ![15,8,11,8,10,15,14,9,4,6,12,9,0,0,15,9,6,0,9,14,13,6,4,8,10,10,0,1,1,0,3,3,14,6,8,0] } }
theorem leafL_017_2_valid : (leafL_017_2).reject.ValidFor (leafL_017_2).leaf := by decide

noncomputable def leafL_017_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,173}, reject := .fullRank { members := ![0,1,17,34,52,69,89,173], points := ![104,106,112,115,122,131], inverse := ![2,14,11,4,13,15,2,1,4,14,0,9,2,9,11,0,0,0,12,0,11,9,6,8,4,15,11,15,15,0,7,9,14,3,3,0] } }
theorem leafL_017_3_valid : (leafL_017_3).reject.ValidFor (leafL_017_3).leaf := by decide

noncomputable def leafL_017_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,174}, reject := .fullRank { members := ![0,1,17,34,52,69,89,174], points := ![99,106,115,124,127,131], inverse := ![0,7,0,0,9,15,7,0,14,0,0,9,0,0,7,5,2,0,1,6,7,1,9,8,10,10,3,10,9,0,3,3,4,9,13,0] } }
theorem leafL_017_4_valid : (leafL_017_4).reject.ValidFor (leafL_017_4).leaf := by decide

noncomputable def leafL_017_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,175}, reject := .fullRank { members := ![0,1,17,34,52,69,89,175], points := ![104,106,110,122,124,131], inverse := ![15,4,12,12,5,15,5,7,5,10,4,9,7,4,3,0,0,0,8,6,9,9,6,8,12,4,8,8,8,0,14,2,12,7,7,0] } }
theorem leafL_017_5_valid : (leafL_017_5).reject.ValidFor (leafL_017_5).leaf := by decide

noncomputable def leafL_017_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,183}, reject := .fullRank { members := ![0,1,17,34,52,69,89,183], points := ![110,122,124,126,131,139], inverse := ![7,8,9,8,2,13,7,8,1,7,12,5,0,15,10,5,0,0,7,7,14,6,0,8,0,9,8,1,4,4,0,5,1,4,15,15] } }
theorem leafL_017_6_valid : (leafL_017_6).reject.ValidFor (leafL_017_6).leaf := by decide

noncomputable def leafL_017_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,186}, reject := .fullRank { members := ![0,1,17,34,52,69,89,186], points := ![99,112,115,124,131,141], inverse := ![14,9,15,6,14,1,7,0,14,0,9,0,3,3,3,3,7,7,6,1,10,5,2,10,11,11,5,5,7,7,9,9,11,11,5,5] } }
theorem leafL_017_7_valid : (leafL_017_7).reject.ValidFor (leafL_017_7).leaf := by decide

noncomputable def leavesL_017 : List RejectedLeaf := [leafL_017_0,leafL_017_1,leafL_017_2,leafL_017_3,leafL_017_4,leafL_017_5,leafL_017_6,leafL_017_7]

theorem leavesL_017_valid : LeafListValid leavesL_017 := by
  intro x hx
  simp only [leavesL_017, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_017_0_valid
  · exact leafL_017_1_valid
  · exact leafL_017_2_valid
  · exact leafL_017_3_valid
  · exact leafL_017_4_valid
  · exact leafL_017_5_valid
  · exact leafL_017_6_valid
  · exact leafL_017_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
