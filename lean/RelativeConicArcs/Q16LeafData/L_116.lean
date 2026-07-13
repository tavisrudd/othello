import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_116_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,173,207}, reject := .fullRank { members := ![0,1,17,34,52,69,173,207], points := ![86,89,92,103,115,122], inverse := ![10,8,13,8,14,8,8,2,3,14,1,6,12,13,1,0,0,0,4,4,8,15,14,9,0,1,1,0,10,10,5,6,3,0,11,11] } }
theorem leafL_116_0_valid : (leafL_116_0).reject.ValidFor (leafL_116_0).leaf := by decide

noncomputable def leafL_116_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,173,211}, reject := .fullRank { members := ![0,1,17,34,52,69,173,211], points := ![86,92,94,104,112,122], inverse := ![6,6,15,11,3,6,5,2,14,13,3,7,2,9,11,0,0,0,12,8,12,7,8,7,5,4,1,9,9,0,15,0,15,15,15,0] } }
theorem leafL_116_1_valid : (leafL_116_1).reject.ValidFor (leafL_116_1).leaf := by decide

noncomputable def leafL_116_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,173,214}, reject := .fullRank { members := ![0,1,17,34,52,69,173,214], points := ![89,92,94,103,106,115], inverse := ![5,14,4,1,9,6,8,0,1,12,2,7,8,12,4,0,0,0,6,12,2,8,7,7,6,13,11,6,6,0,4,1,5,8,8,0] } }
theorem leafL_116_2_valid : (leafL_116_2).reject.ValidFor (leafL_116_2).leaf := by decide

noncomputable def leafL_116_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,173,240}, reject := .fullRank { members := ![0,1,17,34,52,69,173,240], points := ![86,92,95,104,115,122], inverse := ![3,12,0,8,9,15,12,0,5,14,9,14,15,14,1,0,0,0,12,14,10,15,13,10,12,8,4,0,10,10,11,0,11,0,11,11] } }
theorem leafL_116_3_valid : (leafL_116_3).reject.ValidFor (leafL_116_3).leaf := by decide

noncomputable def leafL_116_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,173,246}, reject := .fullRank { members := ![0,1,17,34,52,69,173,246], points := ![94,95,96,104,115,122], inverse := ![15,5,5,8,9,15,4,12,1,14,9,14,7,14,9,0,0,0,6,10,4,15,13,10,1,1,0,0,10,10,8,10,2,0,11,11] } }
theorem leafL_116_4_valid : (leafL_116_4).reject.ValidFor (leafL_116_4).leaf := by decide

noncomputable def leafL_116_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,173,247}, reject := .fullRank { members := ![0,1,17,34,52,69,173,247], points := ![86,92,96,104,106,124], inverse := ![2,7,10,8,0,6,13,15,11,2,12,7,7,4,3,0,0,0,7,10,5,10,5,7,3,2,1,12,12,0,3,3,0,3,3,0] } }
theorem leafL_116_5_valid : (leafL_116_5).reject.ValidFor (leafL_116_5).leaf := by decide

noncomputable def leafL_116_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,183,240}, reject := .fullRank { members := ![0,1,17,34,52,69,183,240], points := ![86,90,95,106,110,122], inverse := ![4,9,2,1,9,6,0,9,0,14,0,7,4,9,13,0,0,0,6,15,1,0,15,7,10,1,11,1,1,0,12,14,2,13,13,0] } }
theorem leafL_116_6_valid : (leafL_116_6).reject.ValidFor (leafL_116_6).leaf := by decide

noncomputable def leafL_116_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,183,256}, reject := .fullRank { members := ![0,1,17,34,52,69,183,256], points := ![90,93,95,106,122,126], inverse := ![3,5,9,8,11,13,9,0,0,14,7,0,15,12,3,0,0,0,9,5,4,15,9,14,5,12,9,0,9,9,2,10,8,0,15,15] } }
theorem leafL_116_7_valid : (leafL_116_7).reject.ValidFor (leafL_116_7).leaf := by decide

noncomputable def leavesL_116 : List RejectedLeaf := [leafL_116_0,leafL_116_1,leafL_116_2,leafL_116_3,leafL_116_4,leafL_116_5,leafL_116_6,leafL_116_7]

theorem leavesL_116_valid : LeafListValid leavesL_116 := by
  intro x hx
  simp only [leavesL_116, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_116_0_valid
  · exact leafL_116_1_valid
  · exact leafL_116_2_valid
  · exact leafL_116_3_valid
  · exact leafL_116_4_valid
  · exact leafL_116_5_valid
  · exact leafL_116_6_valid
  · exact leafL_116_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
