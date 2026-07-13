import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_103_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,139,247}, reject := .fullRank { members := ![0,1,17,34,52,69,139,247], points := ![86,92,93,104,106,115], inverse := ![8,15,8,2,10,6,11,15,13,11,5,7,6,10,12,0,0,0,10,2,0,3,12,7,13,9,4,12,12,0,3,3,0,3,3,0] } }
theorem leafL_103_0_valid : (leafL_103_0).reject.ValidFor (leafL_103_0).leaf := by decide

noncomputable def leafL_103_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,139,259}, reject := .fullRank { members := ![0,1,17,34,52,69,139,259], points := ![86,92,96,106,120,126], inverse := ![7,7,15,8,1,7,9,8,8,14,8,15,7,4,3,0,0,0,8,5,5,15,11,12,4,14,10,0,11,11,6,0,6,0,6,6] } }
theorem leafL_103_1_valid : (leafL_103_1).reject.ValidFor (leafL_103_1).leaf := by decide

noncomputable def leafL_103_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,139,268}, reject := .fullRank { members := ![0,1,17,34,52,69,139,268], points := ![86,90,93,103,106,115], inverse := ![11,14,10,1,9,6,14,0,7,12,2,7,7,2,5,0,0,0,6,7,9,8,7,7,4,4,0,6,6,0,3,12,15,8,8,0] } }
theorem leafL_103_2_valid : (leafL_103_2).reject.ValidFor (leafL_103_2).leaf := by decide

noncomputable def leafL_103_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,139,270}, reject := .fullRank { members := ![0,1,17,34,52,69,139,270], points := ![86,95,96,104,122,124], inverse := ![1,2,12,8,0,6,15,8,14,14,1,6,9,5,12,0,0,0,2,1,11,15,4,3,10,11,1,0,1,1,4,7,3,0,13,13] } }
theorem leafL_103_3_valid : (leafL_103_3).reject.ValidFor (leafL_103_3).leaf := by decide

noncomputable def leafL_103_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,141,150}, reject := .fullRank { members := ![0,1,17,34,52,69,141,150], points := ![89,95,99,124,126,163], inverse := ![7,4,15,7,9,3,10,15,9,3,12,3,9,4,4,4,3,14,6,15,12,0,8,13,10,2,11,5,4,2,10,10,0,10,10,0] } }
theorem leafL_103_4_valid : (leafL_103_4).reject.ValidFor (leafL_103_4).leaf := by decide

noncomputable def leafL_103_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,141,152}, reject := .fullRank { members := ![0,1,17,34,52,69,141,152], points := ![92,106,110,112,126,166], inverse := ![9,4,15,9,2,8,5,15,8,14,15,3,0,5,15,10,0,0,14,11,12,2,3,8,7,0,14,7,11,5,4,2,2,12,9,1] } }
theorem leafL_103_5_valid : (leafL_103_5).reject.ValidFor (leafL_103_5).leaf := by decide

noncomputable def leafL_103_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,141,166}, reject := .fullRank { members := ![0,1,17,34,52,69,141,166], points := ![89,96,99,104,106,120], inverse := ![3,12,1,4,13,6,11,2,9,9,14,7,0,0,1,14,15,0,15,7,2,9,4,7,13,13,5,15,10,0,6,6,9,4,13,0] } }
theorem leafL_103_6_valid : (leafL_103_6).reject.ValidFor (leafL_103_6).leaf := by decide

noncomputable def leafL_103_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,141,171}, reject := .fullRank { members := ![0,1,17,34,52,69,141,171], points := ![86,89,99,106,120,124], inverse := ![9,6,5,13,14,8,14,7,10,4,12,11,5,5,14,14,14,14,14,6,4,11,9,14,10,10,5,5,2,2,9,9,7,7,2,2] } }
theorem leafL_103_7_valid : (leafL_103_7).reject.ValidFor (leafL_103_7).leaf := by decide

noncomputable def leavesL_103 : List RejectedLeaf := [leafL_103_0,leafL_103_1,leafL_103_2,leafL_103_3,leafL_103_4,leafL_103_5,leafL_103_6,leafL_103_7]

theorem leavesL_103_valid : LeafListValid leavesL_103 := by
  intro x hx
  simp only [leavesL_103, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_103_0_valid
  · exact leafL_103_1_valid
  · exact leafL_103_2_valid
  · exact leafL_103_3_valid
  · exact leafL_103_4_valid
  · exact leafL_103_5_valid
  · exact leafL_103_6_valid
  · exact leafL_103_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
