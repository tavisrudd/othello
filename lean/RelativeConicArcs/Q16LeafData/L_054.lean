import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_054_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,205}, reject := .fullRank { members := ![0,1,17,34,52,69,96,205], points := ![106,107,120,122,126,131], inverse := ![7,0,5,3,15,15,10,13,6,3,11,9,0,0,7,4,3,0,15,8,11,5,1,8,15,15,3,10,9,0,11,11,2,15,13,0] } }
theorem leafL_054_0_valid : (leafL_054_0).reject.ValidFor (leafL_054_0).leaf := by decide

noncomputable def leafL_054_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,214}, reject := .fullRank { members := ![0,1,17,34,52,69,96,214], points := ![99,103,106,120,122,139], inverse := ![3,0,4,15,6,15,13,1,11,3,13,9,12,2,14,0,0,0,6,0,1,12,3,8,15,8,7,5,5,0,4,6,2,1,1,0] } }
theorem leafL_054_1_valid : (leafL_054_1).reject.ValidFor (leafL_054_1).leaf := by decide

noncomputable def leafL_054_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,217}, reject := .fullRank { members := ![0,1,17,34,52,69,96,217], points := ![99,107,120,122,126,131], inverse := ![14,9,7,6,8,15,7,0,7,8,1,9,0,0,7,4,3,0,13,10,3,2,14,8,13,13,11,13,6,0,5,5,15,9,6,0] } }
theorem leafL_054_2_valid : (leafL_054_2).reject.ValidFor (leafL_054_2).leaf := by decide

noncomputable def leafL_054_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,220}, reject := .fullRank { members := ![0,1,17,34,52,69,96,220], points := ![106,120,137,139,141,155], inverse := ![9,0,10,15,8,5,1,11,0,6,8,4,0,0,15,10,5,0,4,4,13,0,15,2,5,14,13,5,5,6,13,2,3,15,4,7] } }
theorem leafL_054_3_valid : (leafL_054_3).reject.ValidFor (leafL_054_3).leaf := by decide

noncomputable def leafL_054_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,222}, reject := .fullRank { members := ![0,1,17,34,52,69,96,222], points := ![106,107,127,131,137,139], inverse := ![7,0,9,15,0,0,5,2,14,13,0,4,0,0,0,8,6,14,9,14,15,7,6,9,6,6,0,12,9,5,7,7,0,4,14,10] } }
theorem leafL_054_4_valid : (leafL_054_4).reject.ValidFor (leafL_054_4).leaf := by decide

noncomputable def leafL_054_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,232}, reject := .fullRank { members := ![0,1,17,34,52,69,96,232], points := ![107,126,127,137,141,151], inverse := ![8,6,14,2,9,10,3,15,7,10,8,9,13,3,1,11,3,7,3,4,13,9,10,9,9,10,14,13,14,14,5,7,9,9,4,6] } }
theorem leafL_054_5_valid : (leafL_054_5).reject.ValidFor (leafL_054_5).leaf := by decide

noncomputable def leafL_054_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,235}, reject := .fullRank { members := ![0,1,17,34,52,69,96,235], points := ![103,120,122,126,137,151], inverse := ![6,2,14,13,9,15,13,9,10,2,0,12,0,7,4,3,0,0,9,9,3,12,10,5,3,9,6,4,10,2,9,1,13,8,3,14] } }
theorem leafL_054_6_valid : (leafL_054_6).reject.ValidFor (leafL_054_6).leaf := by decide

noncomputable def leafL_054_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,96,246}, reject := .fullRank { members := ![0,1,17,34,52,69,96,246], points := ![99,120,122,127,131,139], inverse := ![7,8,14,15,7,8,7,9,3,4,9,0,0,6,10,12,0,0,7,9,1,7,5,13,0,10,12,6,4,4,0,4,10,14,15,15] } }
theorem leafL_054_7_valid : (leafL_054_7).reject.ValidFor (leafL_054_7).leaf := by decide

noncomputable def leavesL_054 : List RejectedLeaf := [leafL_054_0,leafL_054_1,leafL_054_2,leafL_054_3,leafL_054_4,leafL_054_5,leafL_054_6,leafL_054_7]

theorem leavesL_054_valid : LeafListValid leavesL_054 := by
  intro x hx
  simp only [leavesL_054, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_054_0_valid
  · exact leafL_054_1_valid
  · exact leafL_054_2_valid
  · exact leafL_054_3_valid
  · exact leafL_054_4_valid
  · exact leafL_054_5_valid
  · exact leafL_054_6_valid
  · exact leafL_054_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
