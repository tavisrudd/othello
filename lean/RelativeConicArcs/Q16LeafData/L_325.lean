import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_325_0 : RejectedLeaf := { leaf := {0,1,17,34,52,91,109,154}, reject := .fullRank { members := ![0,1,17,34,52,91,109,154], points := ![70,71,73,117,127,137], inverse := ![4,0,2,2,14,11,2,8,12,8,3,13,13,1,12,0,0,0,15,0,9,4,14,12,4,1,5,4,4,0,11,4,15,13,13,0] } }
theorem leafL_325_0_valid : (leafL_325_0).reject.ValidFor (leafL_325_0).leaf := by decide

noncomputable def leafL_325_1 : RejectedLeaf := { leaf := {0,1,17,34,52,91,110,168}, reject := .fullRank { members := ![0,1,17,34,52,91,110,168], points := ![67,70,71,122,135,137], inverse := ![15,2,11,12,8,3,3,9,12,11,4,9,8,2,10,0,0,0,15,15,6,10,5,9,3,7,4,0,12,12,9,5,12,0,4,4] } }
theorem leafL_325_1_valid : (leafL_325_1).reject.ValidFor (leafL_325_1).leaf := by decide

noncomputable def leafL_325_2 : RejectedLeaf := { leaf := {0,1,17,34,52,91,110,185}, reject := .fullRank { members := ![0,1,17,34,52,91,110,185], points := ![67,70,71,115,127,135], inverse := ![9,2,13,15,3,11,1,13,10,3,8,13,8,2,10,0,0,0,11,3,14,0,10,12,5,9,12,6,6,0,11,14,5,2,2,0] } }
theorem leafL_325_2_valid : (leafL_325_2).reject.ValidFor (leafL_325_2).leaf := by decide

noncomputable def leafL_325_3 : RejectedLeaf := { leaf := {0,1,17,34,52,91,110,220}, reject := .fullRank { members := ![0,1,17,34,52,91,110,220], points := ![67,69,70,115,127,141], inverse := ![1,12,11,12,0,11,8,14,0,4,15,13,1,7,6,0,0,0,9,4,11,8,2,12,11,11,0,6,6,0,6,10,12,2,2,0] } }
theorem leafL_325_3_valid : (leafL_325_3).reject.ValidFor (leafL_325_3).leaf := by decide

noncomputable def leafL_325_4 : RejectedLeaf := { leaf := {0,1,17,34,52,91,110,253}, reject := .fullRank { members := ![0,1,17,34,52,91,110,253], points := ![67,69,73,122,127,137], inverse := ![8,6,8,1,13,11,13,2,9,4,15,13,2,3,1,0,0,0,9,7,8,2,8,12,8,0,8,2,2,0,1,10,11,15,15,0] } }
theorem leafL_325_4_valid : (leafL_325_4).reject.ValidFor (leafL_325_4).leaf := by decide

noncomputable def leafL_325_5 : RejectedLeaf := { leaf := {0,1,17,34,52,91,127,138}, reject := .fullRank { members := ![0,1,17,34,52,91,127,138], points := ![67,80,101,103,109,158], inverse := ![12,5,6,6,3,11,12,4,14,14,15,7,0,0,14,6,8,0,4,6,5,10,12,1,6,6,12,7,11,0,15,15,2,5,7,0] } }
theorem leafL_325_5_valid : (leafL_325_5).reject.ValidFor (leafL_325_5).leaf := by decide

noncomputable def leafL_325_6 : RejectedLeaf := { leaf := {0,1,17,34,52,91,127,176}, reject := .fullRank { members := ![0,1,17,34,52,91,127,176], points := ![67,70,71,101,104,138], inverse := ![12,13,15,11,14,10,5,14,14,2,8,15,8,2,10,0,0,0,4,3,13,14,0,4,11,15,4,7,7,0,0,12,12,12,12,0] } }
theorem leafL_325_6_valid : (leafL_325_6).reject.ValidFor (leafL_325_6).leaf := by decide

noncomputable def leafL_325_7 : RejectedLeaf := { leaf := {0,1,17,34,52,91,127,185}, reject := .fullRank { members := ![0,1,17,34,52,91,127,185], points := ![67,71,80,104,110,135], inverse := ![0,4,10,11,14,10,2,4,3,11,1,15,1,9,8,0,0,0,11,4,5,6,8,4,1,10,11,6,6,0,9,3,10,2,2,0] } }
theorem leafL_325_7_valid : (leafL_325_7).reject.ValidFor (leafL_325_7).leaf := by decide

noncomputable def leavesL_325 : List RejectedLeaf := [leafL_325_0,leafL_325_1,leafL_325_2,leafL_325_3,leafL_325_4,leafL_325_5,leafL_325_6,leafL_325_7]

theorem leavesL_325_valid : LeafListValid leavesL_325 := by
  intro x hx
  simp only [leavesL_325, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_325_0_valid
  · exact leafL_325_1_valid
  · exact leafL_325_2_valid
  · exact leafL_325_3_valid
  · exact leafL_325_4_valid
  · exact leafL_325_5_valid
  · exact leafL_325_6_valid
  · exact leafL_325_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
