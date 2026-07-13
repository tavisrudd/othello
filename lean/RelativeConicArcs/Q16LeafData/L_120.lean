import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_120_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,240,247}, reject := .fullRank { members := ![0,1,17,34,52,69,240,247], points := ![92,104,106,110,115,127], inverse := ![15,11,9,10,13,11,9,0,9,7,15,8,0,7,4,3,0,0,8,0,3,12,0,7,0,11,0,11,13,13,0,10,8,2,6,6] } }
theorem leafL_120_0_valid : (leafL_120_0).reject.ValidFor (leafL_120_0).leaf := by decide

noncomputable def leafL_120_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,246,271}, reject := .fullRank { members := ![0,1,17,34,52,69,246,271], points := ![89,91,94,99,104,122], inverse := ![2,5,8,9,1,6,8,14,15,9,7,7,12,3,15,0,0,0,1,9,0,13,2,7,8,15,7,10,10,0,11,0,11,11,11,0] } }
theorem leafL_120_1_valid : (leafL_120_1).reject.ValidFor (leafL_120_1).leaf := by decide

noncomputable def leafL_120_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,103}, reject := .fullRank { members := ![0,1,17,34,52,70,89,103], points := ![126,131,139,149,159,168], inverse := ![3,13,4,12,0,7,3,7,15,4,15,0,3,3,0,1,2,3,0,3,8,0,9,2,3,11,8,2,1,3,5,4,1,9,12,5] } }
theorem leafL_120_2_valid : (leafL_120_2).reject.ValidFor (leafL_120_2).leaf := by decide

noncomputable def leafL_120_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,104}, reject := .fullRank { members := ![0,1,17,34,52,70,89,104], points := ![115,117,126,135,140,149], inverse := ![13,7,14,13,3,11,9,12,6,4,12,11,13,14,3,0,0,0,3,14,15,14,7,11,9,1,8,11,11,0,1,15,14,4,4,0] } }
theorem leafL_120_3_valid : (leafL_120_3).reject.ValidFor (leafL_120_3).leaf := by decide

noncomputable def leafL_120_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,110}, reject := .fullRank { members := ![0,1,17,34,52,70,89,110], points := ![117,127,131,135,139,151], inverse := ![2,6,9,3,4,11,13,14,8,9,9,11,0,0,7,11,12,0,9,11,7,11,5,11,2,2,5,15,10,0,12,12,1,5,4,0] } }
theorem leafL_120_4_valid : (leafL_120_4).reject.ValidFor (leafL_120_4).leaf := by decide

noncomputable def leafL_120_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,117}, reject := .fullRank { members := ![0,1,17,34,52,70,89,117], points := ![104,110,135,139,141,154], inverse := ![2,11,15,2,0,5,10,8,0,6,2,6,0,0,1,3,2,0,15,2,2,11,8,12,1,1,7,13,10,0,6,6,6,0,6,0] } }
theorem leafL_120_5_valid : (leafL_120_5).reject.ValidFor (leafL_120_5).leaf := by decide

noncomputable def leafL_120_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,120}, reject := .fullRank { members := ![0,1,17,34,52,70,89,120], points := ![108,139,140,141,151,159], inverse := ![9,0,5,8,9,12,2,12,6,14,7,1,0,7,6,1,0,0,13,15,11,5,5,9,0,0,14,14,7,7,0,7,3,4,1,1] } }
theorem leafL_120_6_valid : (leafL_120_6).reject.ValidFor (leafL_120_6).leaf := by decide

noncomputable def leafL_120_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,126}, reject := .fullRank { members := ![0,1,17,34,52,70,89,126], points := ![103,104,108,131,140,149], inverse := ![8,7,6,9,4,5,15,8,5,1,5,6,4,10,14,0,0,0,15,7,5,9,8,12,1,3,2,5,5,0,10,7,13,1,1,0] } }
theorem leafL_120_7_valid : (leafL_120_7).reject.ValidFor (leafL_120_7).leaf := by decide

noncomputable def leavesL_120 : List RejectedLeaf := [leafL_120_0,leafL_120_1,leafL_120_2,leafL_120_3,leafL_120_4,leafL_120_5,leafL_120_6,leafL_120_7]

theorem leavesL_120_valid : LeafListValid leavesL_120 := by
  intro x hx
  simp only [leavesL_120, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_120_0_valid
  · exact leafL_120_1_valid
  · exact leafL_120_2_valid
  · exact leafL_120_3_valid
  · exact leafL_120_4_valid
  · exact leafL_120_5_valid
  · exact leafL_120_6_valid
  · exact leafL_120_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
