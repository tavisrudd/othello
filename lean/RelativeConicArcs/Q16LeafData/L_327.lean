import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_327_0 : RejectedLeaf := { leaf := {0,1,17,34,52,91,185,270}, reject := .fullRank { members := ![0,1,17,34,52,91,185,270], points := ![67,70,106,112,127,135], inverse := ![14,7,14,10,13,1,7,14,9,13,10,7,11,1,8,1,15,12,7,15,6,4,3,9,13,11,3,4,5,4,5,6,11,1,11,2] } }
theorem leafL_327_0_valid : (leafL_327_0).reject.ValidFor (leafL_327_0).leaf := by decide

noncomputable def leafL_327_1 : RejectedLeaf := { leaf := {0,1,17,34,52,91,220,253}, reject := .fullRank { members := ![0,1,17,34,52,91,220,253], points := ![67,69,78,99,103,115], inverse := ![3,15,13,12,13,1,4,0,0,12,0,8,13,14,3,0,0,0,7,9,2,3,10,5,8,1,9,15,15,0,12,13,1,5,5,0] } }
theorem leafL_327_1_valid : (leafL_327_1).reject.ValidFor (leafL_327_1).leaf := by decide

noncomputable def leafL_327_2 : RejectedLeaf := { leaf := {0,1,17,34,52,91,230,270}, reject := .fullRank { members := ![0,1,17,34,52,91,230,270], points := ![67,69,101,106,112,121], inverse := ![0,1,11,3,9,1,8,12,1,10,7,8,0,0,7,15,8,0,14,2,1,2,10,5,13,13,1,14,15,0,6,6,0,6,6,0] } }
theorem leafL_327_2_valid : (leafL_327_2).reject.ValidFor (leafL_327_2).leaf := by decide

noncomputable def leafL_327_3 : RejectedLeaf := { leaf := {0,1,17,34,52,92,109,190}, reject := .fullRank { members := ![0,1,17,34,52,92,109,190], points := ![67,80,122,127,137,139], inverse := ![14,8,3,15,9,2,15,9,11,0,2,15,9,9,3,3,3,3,11,13,2,8,12,0,5,5,12,12,14,14,11,11,9,9,6,6] } }
theorem leafL_327_3_valid : (leafL_327_3).reject.ValidFor (leafL_327_3).leaf := by decide

noncomputable def leafL_327_4 : RejectedLeaf := { leaf := {0,1,17,34,52,92,135,168}, reject := .fullRank { members := ![0,1,17,34,52,92,135,168], points := ![80,109,112,117,121,122], inverse := ![1,10,11,10,15,4,4,0,12,9,10,11,0,0,0,14,10,4,12,3,10,5,4,4,0,15,15,3,7,4,0,11,11,5,2,7] } }
theorem leafL_327_4_valid : (leafL_327_4).reject.ValidFor (leafL_327_4).leaf := by decide

noncomputable def leafL_327_5 : RejectedLeaf := { leaf := {0,1,17,34,52,92,171,190}, reject := .fullRank { members := ![0,1,17,34,52,92,171,190], points := ![67,80,99,101,109,127], inverse := ![6,7,1,3,3,1,3,7,10,7,1,8,0,0,9,11,2,0,0,12,6,10,5,5,6,6,3,1,2,0,15,15,4,12,8,0] } }
theorem leafL_327_5_valid : (leafL_327_5).reject.ValidFor (leafL_327_5).leaf := by decide

noncomputable def leafL_327_6 : RejectedLeaf := { leaf := {0,1,17,34,52,92,203,264}, reject := .fullRank { members := ![0,1,17,34,52,92,203,264], points := ![74,78,80,122,125,131], inverse := ![0,11,13,9,5,11,13,0,11,7,12,13,5,15,10,0,0,0,13,11,0,14,4,12,3,11,8,8,8,0,7,5,2,9,9,0] } }
theorem leafL_327_6_valid : (leafL_327_6).reject.ValidFor (leafL_327_6).leaf := by decide

noncomputable def leafL_327_7 : RejectedLeaf := { leaf := {0,1,17,34,52,94,156,205}, reject := .fullRank { members := ![0,1,17,34,52,94,156,205], points := ![67,69,75,99,104,122], inverse := ![0,9,8,14,15,1,12,10,2,10,6,8,11,9,2,0,0,0,14,12,14,6,15,5,5,10,15,12,12,0,10,11,1,4,4,0] } }
theorem leafL_327_7_valid : (leafL_327_7).reject.ValidFor (leafL_327_7).leaf := by decide

noncomputable def leavesL_327 : List RejectedLeaf := [leafL_327_0,leafL_327_1,leafL_327_2,leafL_327_3,leafL_327_4,leafL_327_5,leafL_327_6,leafL_327_7]

theorem leavesL_327_valid : LeafListValid leavesL_327 := by
  intro x hx
  simp only [leavesL_327, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_327_0_valid
  · exact leafL_327_1_valid
  · exact leafL_327_2_valid
  · exact leafL_327_3_valid
  · exact leafL_327_4_valid
  · exact leafL_327_5_valid
  · exact leafL_327_6_valid
  · exact leafL_327_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
