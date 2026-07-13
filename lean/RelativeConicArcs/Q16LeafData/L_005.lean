import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_005_0 : RejectedLeaf := { leaf := {0,1,17,34,52,67,89,269}, reject := .fullRank { members := ![0,1,17,34,52,67,89,269], points := ![108,110,124,126,149,156], inverse := ![1,13,5,11,10,9,13,0,1,0,0,12,8,8,6,6,3,3,7,13,0,13,0,7,11,11,14,14,10,10,12,12,12,12,0,0] } }
theorem leafL_005_0_valid : (leafL_005_0).reject.ValidFor (leafL_005_0).leaf := by decide

noncomputable def leafL_005_1 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,108}, reject := .fullRank { members := ![0,1,17,34,52,67,91,108], points := ![122,127,137,144,159,191], inverse := ![14,4,11,13,8,5,0,13,0,0,8,5,0,8,1,6,14,1,2,11,2,2,10,3,1,12,0,6,12,7,6,6,6,6,0,0] } }
theorem leafL_005_1_valid : (leafL_005_1).reject.ValidFor (leafL_005_1).leaf := by decide

noncomputable def leafL_005_2 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,109}, reject := .fullRank { members := ![0,1,17,34,52,67,91,109], points := ![122,127,137,138,143,159], inverse := ![14,10,6,13,5,11,0,3,0,0,8,11,0,0,7,6,1,0,2,0,0,2,11,11,1,1,6,6,0,0,6,6,0,6,6,0] } }
theorem leafL_005_2_valid : (leafL_005_2).reject.ValidFor (leafL_005_2).leaf := by decide

noncomputable def leafL_005_3 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,110}, reject := .fullRank { members := ![0,1,17,34,52,67,91,110], points := ![122,127,141,143,144,151], inverse := ![1,5,12,7,5,11,15,12,8,15,15,11,0,0,7,9,14,0,13,15,6,1,14,11,1,1,0,6,6,0,6,6,1,2,3,0] } }
theorem leafL_005_3_valid : (leafL_005_3).reject.ValidFor (leafL_005_3).leaf := by decide

noncomputable def leafL_005_4 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,121}, reject := .fullRank { members := ![0,1,17,34,52,67,91,121], points := ![106,141,144,149,158,159], inverse := ![9,11,6,6,11,8,2,8,12,1,8,15,0,0,0,11,15,4,13,15,14,1,4,9,0,4,4,14,8,6,0,9,9,0,9,9] } }
theorem leafL_005_4_valid : (leafL_005_4).reject.ValidFor (leafL_005_4).leaf := by decide

noncomputable def leafL_005_5 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,122}, reject := .fullRank { members := ![0,1,17,34,52,67,91,122], points := ![108,109,110,137,143,149], inverse := ![11,12,14,7,10,5,12,15,1,12,8,6,1,6,7,0,0,0,14,15,12,13,12,12,5,7,2,4,4,0,10,0,10,10,10,0] } }
theorem leafL_005_5_valid : (leafL_005_5).reject.ValidFor (leafL_005_5).leaf := by decide

noncomputable def leafL_005_6 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,127}, reject := .fullRank { members := ![0,1,17,34,52,67,91,127], points := ![108,109,110,137,138,151], inverse := ![12,11,14,8,5,5,3,15,14,9,13,6,1,6,7,0,0,0,12,11,10,12,13,12,1,12,13,11,11,0,0,9,9,9,9,0] } }
theorem leafL_005_6_valid : (leafL_005_6).reject.ValidFor (leafL_005_6).leaf := by decide

noncomputable def leafL_005_7 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,137}, reject := .fullRank { members := ![0,1,17,34,52,67,91,137], points := ![108,109,122,127,158,168], inverse := ![15,7,3,0,1,11,0,14,7,7,4,10,2,6,14,3,2,11,7,3,4,2,0,2,2,13,6,3,14,4,2,2,2,2,0,0] } }
theorem leafL_005_7_valid : (leafL_005_7).reject.ValidFor (leafL_005_7).leaf := by decide

noncomputable def leavesL_005 : List RejectedLeaf := [leafL_005_0,leafL_005_1,leafL_005_2,leafL_005_3,leafL_005_4,leafL_005_5,leafL_005_6,leafL_005_7]

theorem leavesL_005_valid : LeafListValid leavesL_005 := by
  intro x hx
  simp only [leavesL_005, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_005_0_valid
  · exact leafL_005_1_valid
  · exact leafL_005_2_valid
  · exact leafL_005_3_valid
  · exact leafL_005_4_valid
  · exact leafL_005_5_valid
  · exact leafL_005_6_valid
  · exact leafL_005_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
