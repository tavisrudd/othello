import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_145_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,110,147}, reject := .fullRank { members := ![0,1,17,34,52,70,110,147], points := ![90,91,117,125,127,137], inverse := ![3,4,3,6,11,8,11,12,3,7,13,14,0,0,8,14,6,0,6,1,2,3,9,15,1,1,8,15,7,0,7,7,4,10,14,0] } }
theorem leafL_145_0_valid : (leafL_145_0).reject.ValidFor (leafL_145_0).leaf := by decide

noncomputable def leafL_145_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,110,152}, reject := .fullRank { members := ![0,1,17,34,52,70,110,152], points := ![83,90,115,127,135,137], inverse := ![3,4,3,13,12,4,9,14,11,2,15,1,3,3,10,10,2,2,4,3,5,13,3,12,0,0,3,3,10,10,6,6,13,13,7,7] } }
theorem leafL_145_1_valid : (leafL_145_1).reject.ValidFor (leafL_145_1).leaf := by decide

noncomputable def leafL_145_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,110,159}, reject := .fullRank { members := ![0,1,17,34,52,70,110,159], points := ![89,91,115,125,131,144], inverse := ![14,9,5,11,14,6,0,7,5,12,12,2,6,6,9,9,10,10,7,0,1,9,12,3,11,11,11,11,5,5,10,10,11,11,9,9] } }
theorem leafL_145_2_valid : (leafL_145_2).reject.ValidFor (leafL_145_2).leaf := by decide

noncomputable def leafL_145_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,110,168}, reject := .fullRank { members := ![0,1,17,34,52,70,110,168], points := ![89,90,91,131,135,147], inverse := ![11,15,12,12,15,10,9,13,2,9,0,15,9,14,7,0,0,0,2,10,12,1,7,2,3,6,5,14,14,0,6,15,9,10,10,0] } }
theorem leafL_145_3_valid : (leafL_145_3).reject.ValidFor (leafL_145_3).leaf := by decide

noncomputable def leafL_145_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,110,172}, reject := .fullRank { members := ![0,1,17,34,52,70,110,172], points := ![83,90,117,125,131,139], inverse := ![12,11,7,9,15,7,4,3,4,13,4,10,3,3,15,15,10,10,2,5,1,9,15,0,11,11,10,10,11,11,0,0,15,15,15,15] } }
theorem leafL_145_4_valid : (leafL_145_4).reject.ValidFor (leafL_145_4).leaf := by decide

noncomputable def leafL_145_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,110,184}, reject := .fullRank { members := ![0,1,17,34,52,70,110,184], points := ![90,127,131,139,141,147], inverse := ![3,12,8,1,14,9,11,15,12,7,7,8,0,0,2,11,9,0,14,5,11,3,13,14,11,12,14,7,13,3,15,14,12,4,3,10] } }
theorem leafL_145_5_valid : (leafL_145_5).reject.ValidFor (leafL_145_5).leaf := by decide

noncomputable def leafL_145_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,110,185}, reject := .fullRank { members := ![0,1,17,34,52,70,110,185], points := ![83,91,115,117,135,139], inverse := ![4,3,14,0,4,12,14,9,11,2,10,4,13,13,1,1,14,14,3,4,5,13,12,3,7,7,9,9,12,12,11,11,13,13,12,12] } }
theorem leafL_145_6_valid : (leafL_145_6).reject.ValidFor (leafL_145_6).leaf := by decide

noncomputable def leafL_145_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,110,188}, reject := .fullRank { members := ![0,1,17,34,52,70,110,188], points := ![83,90,91,117,125,131], inverse := ![6,11,10,10,4,8,1,3,5,11,2,14,6,3,5,0,0,0,2,5,0,1,9,15,7,11,12,13,13,0,14,0,14,14,14,0] } }
theorem leafL_145_7_valid : (leafL_145_7).reject.ValidFor (leafL_145_7).leaf := by decide

noncomputable def leavesL_145 : List RejectedLeaf := [leafL_145_0,leafL_145_1,leafL_145_2,leafL_145_3,leafL_145_4,leafL_145_5,leafL_145_6,leafL_145_7]

theorem leavesL_145_valid : LeafListValid leavesL_145 := by
  intro x hx
  simp only [leavesL_145, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_145_0_valid
  · exact leafL_145_1_valid
  · exact leafL_145_2_valid
  · exact leafL_145_3_valid
  · exact leafL_145_4_valid
  · exact leafL_145_5_valid
  · exact leafL_145_6_valid
  · exact leafL_145_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
