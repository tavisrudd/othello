import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_031_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,99}, reject := .fullRank { members := ![0,1,17,34,52,69,92,99], points := ![122,135,138,141,151,152], inverse := ![4,6,13,5,7,12,3,10,15,13,8,3,0,10,7,13,0,0,2,7,13,3,12,7,0,14,2,12,13,13,0,9,6,15,8,8] } }
theorem leafL_031_0_valid : (leafL_031_0).reject.ValidFor (leafL_031_0).leaf := by decide

noncomputable def leafL_031_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,104}, reject := .fullRank { members := ![0,1,17,34,52,69,92,104], points := ![126,127,137,138,139,154], inverse := ![3,7,6,11,3,11,7,4,1,7,14,11,0,0,9,14,7,0,12,14,15,4,2,11,12,12,8,3,11,0,14,14,0,14,14,0] } }
theorem leafL_031_1_valid : (leafL_031_1).reject.ValidFor (leafL_031_1).leaf := by decide

noncomputable def leafL_031_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,107}, reject := .fullRank { members := ![0,1,17,34,52,69,92,107], points := ![127,131,138,151,169,173], inverse := ![11,7,6,4,8,7,7,5,9,15,11,15,6,3,5,6,8,14,14,12,9,7,4,8,13,1,12,13,1,12,12,9,5,12,7,11] } }
theorem leafL_031_2_valid : (leafL_031_2).reject.ValidFor (leafL_031_2).leaf := by decide

noncomputable def leafL_031_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,122}, reject := .fullRank { members := ![0,1,17,34,52,69,92,122], points := ![99,135,139,151,169,173], inverse := ![15,3,12,4,1,4,11,14,13,12,5,1,13,9,3,5,13,15,4,11,13,6,10,14,2,11,4,14,13,14,6,1,3,1,2,7] } }
theorem leafL_031_3_valid : (leafL_031_3).reject.ValidFor (leafL_031_3).leaf := by decide

noncomputable def leafL_031_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,126}, reject := .fullRank { members := ![0,1,17,34,52,69,92,126], points := ![104,131,135,138,152,155], inverse := ![9,3,5,11,2,7,2,3,11,12,6,0,0,12,2,14,0,0,13,2,5,6,13,1,0,14,6,8,1,1,0,7,10,13,6,6] } }
theorem leafL_031_4_valid : (leafL_031_4).reject.ValidFor (leafL_031_4).leaf := by decide

noncomputable def leafL_031_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,127}, reject := .fullRank { members := ![0,1,17,34,52,69,92,127], points := ![104,107,135,137,138,152], inverse := ![5,12,2,3,12,5,2,0,4,4,4,6,0,0,11,3,8,0,3,14,10,8,3,12,14,14,0,11,11,0,2,2,15,3,12,0] } }
theorem leafL_031_5_valid : (leafL_031_5).reject.ValidFor (leafL_031_5).leaf := by decide

noncomputable def leafL_031_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,131}, reject := .fullRank { members := ![0,1,17,34,52,69,92,131], points := ![107,126,151,152,169,173], inverse := ![0,10,11,14,3,13,12,15,15,10,7,1,8,9,13,9,6,3,11,3,14,0,11,13,1,14,14,7,6,0,14,11,13,10,0,2] } }
theorem leafL_031_6_valid : (leafL_031_6).reject.ValidFor (leafL_031_6).leaf := by decide

noncomputable def leafL_031_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,135}, reject := .fullRank { members := ![0,1,17,34,52,69,92,135], points := ![99,122,126,127,152,173], inverse := ![0,13,5,2,5,14,9,3,10,5,14,11,0,8,10,2,0,0,3,4,8,6,10,3,15,4,7,6,14,4,11,11,15,12,12,15] } }
theorem leafL_031_7_valid : (leafL_031_7).reject.ValidFor (leafL_031_7).leaf := by decide

noncomputable def leavesL_031 : List RejectedLeaf := [leafL_031_0,leafL_031_1,leafL_031_2,leafL_031_3,leafL_031_4,leafL_031_5,leafL_031_6,leafL_031_7]

theorem leavesL_031_valid : LeafListValid leavesL_031 := by
  intro x hx
  simp only [leavesL_031, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_031_0_valid
  · exact leafL_031_1_valid
  · exact leafL_031_2_valid
  · exact leafL_031_3_valid
  · exact leafL_031_4_valid
  · exact leafL_031_5_valid
  · exact leafL_031_6_valid
  · exact leafL_031_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
