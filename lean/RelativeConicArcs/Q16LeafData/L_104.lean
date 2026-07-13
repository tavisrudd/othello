import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_104_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,141,186}, reject := .fullRank { members := ![0,1,17,34,52,69,141,186], points := ![89,96,112,156,163,166], inverse := ![14,10,9,14,3,1,4,5,15,5,9,2,9,15,6,6,5,3,7,7,14,5,10,1,6,7,1,1,2,3,11,11,0,0,11,11] } }
theorem leafL_104_0_valid : (leafL_104_0).reject.ValidFor (leafL_104_0).leaf := by decide

noncomputable def leafL_104_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,141,207}, reject := .fullRank { members := ![0,1,17,34,52,69,141,207], points := ![89,92,110,120,163,171], inverse := ![0,15,8,6,0,0,8,8,6,9,6,9,0,8,11,1,15,13,4,0,8,15,13,14,15,13,6,13,5,12,13,2,2,10,5,2] } }
theorem leafL_104_1_valid : (leafL_104_1).reject.ValidFor (leafL_104_1).leaf := by decide

noncomputable def leafL_104_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,141,214}, reject := .fullRank { members := ![0,1,17,34,52,69,141,214], points := ![89,92,96,99,112,152], inverse := ![12,7,13,6,13,12,10,3,3,11,15,14,2,10,8,0,0,0,5,2,12,2,7,14,12,5,9,3,3,0,1,8,9,4,4,0] } }
theorem leafL_104_2_valid : (leafL_104_2).reject.ValidFor (leafL_104_2).leaf := by decide

noncomputable def leafL_104_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,141,217}, reject := .fullRank { members := ![0,1,17,34,52,69,141,217], points := ![95,96,104,120,126,156], inverse := ![8,7,8,2,4,0,6,7,11,2,15,7,1,5,11,11,14,10,2,9,5,12,12,14,7,4,10,1,6,14,5,0,13,11,2,1] } }
theorem leafL_104_3_valid : (leafL_104_3).reject.ValidFor (leafL_104_3).leaf := by decide

noncomputable def leafL_104_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,141,240}, reject := .fullRank { members := ![0,1,17,34,52,69,141,240], points := ![92,95,104,106,110,150], inverse := ![6,0,0,0,11,12,5,15,7,12,15,14,0,0,7,4,3,0,13,6,1,13,9,14,1,1,7,5,2,0,11,11,7,9,14,0] } }
theorem leafL_104_4_valid : (leafL_104_4).reject.ValidFor (leafL_104_4).leaf := by decide

noncomputable def leafL_104_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,141,246}, reject := .fullRank { members := ![0,1,17,34,52,69,141,246], points := ![89,95,99,104,110,120], inverse := ![1,14,3,11,0,6,5,12,6,11,3,7,0,0,7,13,10,0,9,1,4,11,0,7,8,8,9,1,8,0,7,7,2,15,13,0] } }
theorem leafL_104_5_valid : (leafL_104_5).reject.ValidFor (leafL_104_5).leaf := by decide

noncomputable def leafL_104_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,150,163}, reject := .fullRank { members := ![0,1,17,34,52,69,150,163], points := ![90,91,94,107,126,135], inverse := ![11,1,14,3,13,11,9,10,1,5,12,11,10,2,8,0,0,0,13,13,4,3,11,12,4,5,9,8,8,8,5,14,9,2,2,2] } }
theorem leafL_104_6_valid : (leafL_104_6).reject.ValidFor (leafL_104_6).leaf := by decide

noncomputable def leafL_104_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,150,169}, reject := .fullRank { members := ![0,1,17,34,52,69,150,169], points := ![90,91,94,99,103,122], inverse := ![7,8,0,4,12,6,3,2,8,12,2,7,10,2,8,0,0,0,0,4,12,4,11,7,2,8,10,1,1,0,13,0,13,13,13,0] } }
theorem leafL_104_7_valid : (leafL_104_7).reject.ValidFor (leafL_104_7).leaf := by decide

noncomputable def leavesL_104 : List RejectedLeaf := [leafL_104_0,leafL_104_1,leafL_104_2,leafL_104_3,leafL_104_4,leafL_104_5,leafL_104_6,leafL_104_7]

theorem leavesL_104_valid : LeafListValid leavesL_104 := by
  intro x hx
  simp only [leavesL_104, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_104_0_valid
  · exact leafL_104_1_valid
  · exact leafL_104_2_valid
  · exact leafL_104_3_valid
  · exact leafL_104_4_valid
  · exact leafL_104_5_valid
  · exact leafL_104_6_valid
  · exact leafL_104_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
