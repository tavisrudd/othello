import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_071_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,254}, reject := .fullRank { members := ![0,1,17,34,52,69,107,254], points := ![92,95,96,120,122,131], inverse := ![5,4,6,7,9,8,0,5,2,7,14,14,6,11,13,0,0,0,2,12,9,10,2,15,14,14,0,6,6,0,2,1,3,8,8,0] } }
theorem leafL_071_0_valid : (leafL_071_0).reject.ValidFor (leafL_071_0).leaf := by decide

noncomputable def leafL_071_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,259}, reject := .fullRank { members := ![0,1,17,34,52,69,107,259], points := ![86,92,94,124,127,137], inverse := ![2,0,5,11,5,8,15,10,2,14,7,14,2,9,11,0,0,0,3,6,2,11,3,15,0,9,9,5,5,0,3,14,13,12,12,0] } }
theorem leafL_071_1_valid : (leafL_071_1).reject.ValidFor (leafL_071_1).leaf := by decide

noncomputable def leafL_071_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,262}, reject := .fullRank { members := ![0,1,17,34,52,69,107,262], points := ![92,95,96,120,124,137], inverse := ![5,10,8,7,9,8,7,9,9,15,6,14,6,11,13,0,0,0,13,3,9,12,4,15,5,4,1,7,7,0,4,10,14,5,5,0] } }
theorem leafL_071_2_valid : (leafL_071_2).reject.ValidFor (leafL_071_2).leaf := by decide

noncomputable def leafL_071_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,265}, reject := .fullRank { members := ![0,1,17,34,52,69,107,265], points := ![92,94,95,115,120,138], inverse := ![4,7,4,2,12,8,9,10,4,4,13,14,4,12,8,0,0,0,9,0,14,10,2,15,9,9,0,5,5,0,12,0,12,12,12,0] } }
theorem leafL_071_3_valid : (leafL_071_3).reject.ValidFor (leafL_071_3).leaf := by decide

noncomputable def leafL_071_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,269}, reject := .fullRank { members := ![0,1,17,34,52,69,107,269], points := ![86,92,94,120,131,138], inverse := ![14,13,4,14,9,1,12,10,1,9,1,15,2,9,11,0,0,0,12,8,3,8,11,4,3,6,5,0,12,12,7,9,14,0,3,3] } }
theorem leafL_071_4_valid : (leafL_071_4).reject.ValidFor (leafL_071_4).leaf := by decide

noncomputable def leafL_071_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,115}, reject := .fullRank { members := ![0,1,17,34,52,69,110,115], points := ![90,91,93,135,155,156], inverse := ![7,9,6,3,9,3,6,15,15,9,7,8,8,12,4,0,0,0,12,12,4,6,0,2,15,10,5,0,14,14,11,4,15,0,10,10] } }
theorem leafL_071_5_valid : (leafL_071_5).reject.ValidFor (leafL_071_5).leaf := by decide

noncomputable def leafL_071_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,127}, reject := .fullRank { members := ![0,1,17,34,52,69,110,127], points := ![89,90,135,137,152,156], inverse := ![6,14,7,4,3,9,5,3,4,13,1,14,12,12,3,3,11,11,12,8,5,3,11,9,2,2,14,14,15,15,7,7,14,14,1,1] } }
theorem leafL_071_6_valid : (leafL_071_6).reject.ValidFor (leafL_071_6).leaf := by decide

noncomputable def leafL_071_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,128}, reject := .fullRank { members := ![0,1,17,34,52,69,110,128], points := ![86,89,93,131,137,156], inverse := ![9,14,15,7,4,10,13,10,1,10,3,15,8,1,9,0,0,0,9,11,6,11,13,2,9,13,4,3,3,0,7,1,6,4,4,0] } }
theorem leafL_071_7_valid : (leafL_071_7).reject.ValidFor (leafL_071_7).leaf := by decide

noncomputable def leavesL_071 : List RejectedLeaf := [leafL_071_0,leafL_071_1,leafL_071_2,leafL_071_3,leafL_071_4,leafL_071_5,leafL_071_6,leafL_071_7]

theorem leavesL_071_valid : LeafListValid leavesL_071 := by
  intro x hx
  simp only [leavesL_071, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_071_0_valid
  · exact leafL_071_1_valid
  · exact leafL_071_2_valid
  · exact leafL_071_3_valid
  · exact leafL_071_4_valid
  · exact leafL_071_5_valid
  · exact leafL_071_6_valid
  · exact leafL_071_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
