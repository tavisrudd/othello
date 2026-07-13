import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_128_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,248}, reject := .fullRank { members := ![0,1,17,34,52,70,90,248], points := ![101,109,115,125,126,131], inverse := ![1,6,11,11,9,15,8,15,6,1,9,9,0,0,11,3,8,0,2,5,15,15,15,8,13,13,0,3,3,0,5,5,4,7,3,0] } }
theorem leafL_128_0_valid : (leafL_128_0).reject.ValidFor (leafL_128_0).leaf := by decide

noncomputable def leafL_128_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,249}, reject := .fullRank { members := ![0,1,17,34,52,70,90,249], points := ![101,108,109,125,126,131], inverse := ![0,5,2,8,1,15,5,12,14,5,11,9,1,5,4,0,0,0,4,13,14,5,10,8,13,0,13,3,3,0,2,8,10,14,14,0] } }
theorem leafL_128_1_valid : (leafL_128_1).reject.ValidFor (leafL_128_1).leaf := by decide

noncomputable def leafL_128_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,269}, reject := .fullRank { members := ![0,1,17,34,52,70,90,269], points := ![110,115,124,133,135,152], inverse := ![10,3,8,15,8,7,14,9,3,0,10,14,11,12,11,13,2,3,6,8,15,9,7,15,15,0,1,11,15,10,9,15,11,15,12,14] } }
theorem leafL_128_2_valid : (leafL_128_2).reject.ValidFor (leafL_128_2).leaf := by decide

noncomputable def leafL_128_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,103}, reject := .fullRank { members := ![0,1,17,34,52,70,91,103], points := ![120,125,137,147,149,158], inverse := ![7,3,14,2,6,15,9,10,8,1,15,5,0,0,0,13,14,3,15,13,9,2,14,7,1,1,0,3,3,0,15,15,0,8,4,12] } }
theorem leafL_128_3_valid : (leafL_128_3).reject.ValidFor (leafL_128_3).leaf := by decide

noncomputable def leafL_128_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,104}, reject := .fullRank { members := ![0,1,17,34,52,70,91,104], points := ![117,127,140,141,147,149], inverse := ![0,4,15,1,13,6,1,2,7,15,5,14,13,13,14,14,6,6,5,7,9,0,5,14,11,11,8,8,12,12,2,2,12,12,8,8] } }
theorem leafL_128_4_valid : (leafL_128_4).reject.ValidFor (leafL_128_4).leaf := by decide

noncomputable def leafL_128_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,110}, reject := .fullRank { members := ![0,1,17,34,52,70,91,110], points := ![125,127,137,141,144,147], inverse := ![12,8,4,7,13,11,10,9,11,2,1,11,0,0,8,10,2,0,13,15,1,6,14,11,10,10,6,12,10,0,9,9,8,4,12,0] } }
theorem leafL_128_5_valid : (leafL_128_5).reject.ValidFor (leafL_128_5).leaf := by decide

noncomputable def leafL_128_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,117}, reject := .fullRank { members := ![0,1,17,34,52,70,91,117], points := ![104,109,137,141,147,151], inverse := ![12,5,8,5,4,1,12,14,15,11,14,8,14,14,4,4,6,6,11,6,6,7,4,8,13,13,0,0,5,5,0,0,2,2,2,2] } }
theorem leafL_128_6_valid : (leafL_128_6).reject.ValidFor (leafL_128_6).leaf := by decide

noncomputable def leafL_128_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,120}, reject := .fullRank { members := ![0,1,17,34,52,70,91,120], points := ![103,108,109,140,141,151], inverse := ![9,3,3,11,6,5,6,2,6,2,6,6,5,11,14,0,0,0,12,3,2,3,2,12,8,13,5,15,15,0,0,3,3,3,3,0] } }
theorem leafL_128_7_valid : (leafL_128_7).reject.ValidFor (leafL_128_7).leaf := by decide

noncomputable def leavesL_128 : List RejectedLeaf := [leafL_128_0,leafL_128_1,leafL_128_2,leafL_128_3,leafL_128_4,leafL_128_5,leafL_128_6,leafL_128_7]

theorem leavesL_128_valid : LeafListValid leavesL_128 := by
  intro x hx
  simp only [leavesL_128, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_128_0_valid
  · exact leafL_128_1_valid
  · exact leafL_128_2_valid
  · exact leafL_128_3_valid
  · exact leafL_128_4_valid
  · exact leafL_128_5_valid
  · exact leafL_128_6_valid
  · exact leafL_128_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
