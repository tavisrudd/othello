import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_107_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,152,186}, reject := .fullRank { members := ![0,1,17,34,52,69,152,186], points := ![93,103,107,112,127,131], inverse := ![0,9,13,3,9,15,11,7,7,12,5,2,0,7,2,5,0,0,1,1,9,14,14,9,10,15,14,11,10,10,2,4,3,5,2,2] } }
theorem leafL_107_0_valid : (leafL_107_0).reject.ValidFor (leafL_107_0).leaf := by decide

noncomputable def leafL_107_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,152,195}, reject := .fullRank { members := ![0,1,17,34,52,69,152,195], points := ![86,93,94,103,106,126], inverse := ![9,8,14,13,5,6,8,12,13,2,12,7,13,2,15,0,0,0,8,1,1,6,9,7,3,14,13,6,6,0,10,14,4,8,8,0] } }
theorem leafL_107_1_valid : (leafL_107_1).reject.ValidFor (leafL_107_1).leaf := by decide

noncomputable def leafL_107_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,152,207}, reject := .fullRank { members := ![0,1,17,34,52,69,152,207], points := ![90,92,94,103,110,122], inverse := ![13,9,11,7,15,6,2,3,8,12,2,7,15,10,5,0,0,0,7,0,15,0,15,7,11,11,0,7,7,0,7,12,11,5,5,0] } }
theorem leafL_107_2_valid : (leafL_107_2).reject.ValidFor (leafL_107_2).leaf := by decide

noncomputable def leafL_107_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,152,214}, reject := .fullRank { members := ![0,1,17,34,52,69,152,214], points := ![92,93,94,99,103,122], inverse := ![14,0,1,4,12,6,11,13,15,12,2,7,1,6,7,0,0,0,4,4,8,4,11,7,6,2,4,1,1,0,5,12,9,13,13,0] } }
theorem leafL_107_3_valid : (leafL_107_3).reject.ValidFor (leafL_107_3).leaf := by decide

noncomputable def leafL_107_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,152,217}, reject := .fullRank { members := ![0,1,17,34,52,69,152,217], points := ![93,94,107,122,126,131], inverse := ![4,4,7,12,5,15,11,12,0,10,3,14,14,5,11,15,4,11,8,0,15,4,3,0,11,2,9,10,3,9,1,8,9,12,5,9] } }
theorem leafL_107_4_valid : (leafL_107_4).reject.ValidFor (leafL_107_4).leaf := by decide

noncomputable def leafL_107_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,152,246}, reject := .fullRank { members := ![0,1,17,34,52,69,152,246], points := ![94,99,122,124,126,138], inverse := ![11,12,9,15,4,4,2,5,9,12,9,11,0,0,15,10,5,0,8,15,6,7,6,0,1,1,0,3,2,1,7,7,15,5,13,7] } }
theorem leafL_107_5_valid : (leafL_107_5).reject.ValidFor (leafL_107_5).leaf := by decide

noncomputable def leafL_107_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,152,247}, reject := .fullRank { members := ![0,1,17,34,52,69,152,247], points := ![92,93,106,107,110,126], inverse := ![10,5,12,11,15,6,3,10,13,6,5,7,0,0,10,2,8,0,13,5,4,2,9,7,13,13,3,5,6,0,6,6,0,6,6,0] } }
theorem leafL_107_6_valid : (leafL_107_6).reject.ValidFor (leafL_107_6).leaf := by decide

noncomputable def leafL_107_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,154,163}, reject := .fullRank { members := ![0,1,17,34,52,69,154,163], points := ![91,93,96,127,137,182], inverse := ![15,2,4,8,15,15,15,13,4,3,7,2,4,12,8,0,0,0,6,15,0,14,8,15,4,10,1,12,14,13,2,4,1,3,10,14] } }
theorem leafL_107_7_valid : (leafL_107_7).reject.ValidFor (leafL_107_7).leaf := by decide

noncomputable def leavesL_107 : List RejectedLeaf := [leafL_107_0,leafL_107_1,leafL_107_2,leafL_107_3,leafL_107_4,leafL_107_5,leafL_107_6,leafL_107_7]

theorem leavesL_107_valid : LeafListValid leavesL_107 := by
  intro x hx
  simp only [leavesL_107, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_107_0_valid
  · exact leafL_107_1_valid
  · exact leafL_107_2_valid
  · exact leafL_107_3_valid
  · exact leafL_107_4_valid
  · exact leafL_107_5_valid
  · exact leafL_107_6_valid
  · exact leafL_107_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
