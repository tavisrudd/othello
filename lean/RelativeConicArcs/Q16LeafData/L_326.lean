import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_326_0 : RejectedLeaf := { leaf := {0,1,17,34,52,91,138,176}, reject := .fullRank { members := ![0,1,17,34,52,91,138,176], points := ![67,71,99,101,104,115], inverse := ![5,4,11,3,9,1,4,0,12,0,0,8,0,0,4,12,8,0,6,10,12,4,1,5,2,2,13,3,14,0,5,5,11,2,9,0] } }
theorem leafL_326_0_valid : (leafL_326_0).reject.ValidFor (leafL_326_0).leaf := by decide

noncomputable def leafL_326_1 : RejectedLeaf := { leaf := {0,1,17,34,52,91,138,185}, reject := .fullRank { members := ![0,1,17,34,52,91,138,185], points := ![67,71,72,99,103,115], inverse := ![11,7,13,12,13,1,4,0,0,12,0,8,6,13,11,0,0,0,6,10,0,3,10,5,9,3,10,15,15,0,5,5,0,5,5,0] } }
theorem leafL_326_1_valid : (leafL_326_1).reject.ValidFor (leafL_326_1).leaf := by decide

noncomputable def leafL_326_2 : RejectedLeaf := { leaf := {0,1,17,34,52,91,143,168}, reject := .fullRank { members := ![0,1,17,34,52,91,143,168], points := ![67,101,103,106,117,122], inverse := ![1,0,1,0,1,0,4,0,2,14,15,7,0,2,4,6,0,0,12,15,6,0,13,8,0,1,1,0,12,12,0,13,0,13,13,13] } }
theorem leafL_326_2_valid : (leafL_326_2).reject.ValidFor (leafL_326_2).leaf := by decide

noncomputable def leafL_326_3 : RejectedLeaf := { leaf := {0,1,17,34,52,91,143,188}, reject := .fullRank { members := ![0,1,17,34,52,91,143,188], points := ![72,73,78,103,110,115], inverse := ![4,5,0,3,2,1,13,5,12,14,2,8,10,7,13,0,0,0,5,5,12,0,9,5,7,9,14,11,11,0,1,6,7,8,8,0] } }
theorem leafL_326_3_valid : (leafL_326_3).reject.ValidFor (leafL_326_3).leaf := by decide

noncomputable def leafL_326_4 : RejectedLeaf := { leaf := {0,1,17,34,52,91,144,168}, reject := .fullRank { members := ![0,1,17,34,52,91,144,168], points := ![67,71,73,109,110,122], inverse := ![15,8,6,9,8,1,14,6,12,5,9,8,3,4,7,0,0,0,1,7,10,8,1,5,0,11,11,9,9,0,14,3,13,7,7,0] } }
theorem leafL_326_4_valid : (leafL_326_4).reject.ValidFor (leafL_326_4).leaf := by decide

noncomputable def leafL_326_5 : RejectedLeaf := { leaf := {0,1,17,34,52,91,144,185}, reject := .fullRank { members := ![0,1,17,34,52,91,144,185], points := ![67,70,72,110,117,120], inverse := ![11,6,12,1,0,1,11,14,1,12,5,13,15,3,12,0,0,0,8,13,9,9,15,10,8,9,1,0,11,11,3,2,1,0,8,8] } }
theorem leafL_326_5_valid : (leafL_326_5).reject.ValidFor (leafL_326_5).leaf := by decide

noncomputable def leafL_326_6 : RejectedLeaf := { leaf := {0,1,17,34,52,91,176,185}, reject := .fullRank { members := ![0,1,17,34,52,91,176,185], points := ![67,70,71,99,104,115], inverse := ![7,9,15,10,11,1,4,0,0,12,0,8,8,2,10,0,0,0,15,15,12,1,8,5,0,9,9,12,12,0,8,14,6,4,4,0] } }
theorem leafL_326_6_valid : (leafL_326_6).reject.ValidFor (leafL_326_6).leaf := by decide

noncomputable def leafL_326_7 : RejectedLeaf := { leaf := {0,1,17,34,52,91,185,253}, reject := .fullRank { members := ![0,1,17,34,52,91,185,253], points := ![67,72,99,103,110,115], inverse := ![15,14,1,5,5,1,4,0,12,0,0,8,0,0,2,12,14,0,4,8,12,14,11,5,7,7,4,0,4,0,4,4,11,7,12,0] } }
theorem leafL_326_7_valid : (leafL_326_7).reject.ValidFor (leafL_326_7).leaf := by decide

noncomputable def leavesL_326 : List RejectedLeaf := [leafL_326_0,leafL_326_1,leafL_326_2,leafL_326_3,leafL_326_4,leafL_326_5,leafL_326_6,leafL_326_7]

theorem leavesL_326_valid : LeafListValid leavesL_326 := by
  intro x hx
  simp only [leavesL_326, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_326_0_valid
  · exact leafL_326_1_valid
  · exact leafL_326_2_valid
  · exact leafL_326_3_valid
  · exact leafL_326_4_valid
  · exact leafL_326_5_valid
  · exact leafL_326_6_valid
  · exact leafL_326_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
