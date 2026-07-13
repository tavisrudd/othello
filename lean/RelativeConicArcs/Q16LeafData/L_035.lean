import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_035_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,249}, reject := .fullRank { members := ![0,1,17,34,52,69,92,249], points := ![104,107,122,126,135,141], inverse := ![13,10,8,1,15,0,0,7,3,13,7,14,9,9,14,14,11,11,9,14,3,12,3,11,3,3,7,7,1,1,7,7,6,6,4,4] } }
theorem leafL_035_0_valid : (leafL_035_0).reject.ValidFor (leafL_035_0).leaf := by decide

noncomputable def leafL_035_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,254}, reject := .fullRank { members := ![0,1,17,34,52,69,92,254], points := ![107,122,131,135,138,154], inverse := ![3,15,1,13,8,9,0,3,0,0,8,11,0,0,12,2,14,0,10,13,7,4,3,7,6,5,4,8,11,4,7,13,14,8,7,11] } }
theorem leafL_035_1_valid : (leafL_035_1).reject.ValidFor (leafL_035_1).leaf := by decide

noncomputable def leafL_035_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,256}, reject := .fullRank { members := ![0,1,17,34,52,69,92,256], points := ![99,104,122,126,127,137], inverse := ![7,0,0,9,0,15,9,14,12,0,2,9,0,0,8,10,2,0,5,2,5,3,9,8,5,5,1,13,12,0,8,8,3,12,15,0] } }
theorem leafL_035_2_valid : (leafL_035_2).reject.ValidFor (leafL_035_2).leaf := by decide

noncomputable def leafL_035_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,259}, reject := .fullRank { members := ![0,1,17,34,52,69,92,259], points := ![107,126,137,139,152,154], inverse := ![6,1,12,5,12,3,12,9,11,13,13,14,3,11,1,11,0,2,9,6,3,9,11,14,3,11,7,13,4,6,13,2,14,6,11,12] } }
theorem leafL_035_3_valid : (leafL_035_3).reject.ValidFor (leafL_035_3).leaf := by decide

noncomputable def leafL_035_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,262}, reject := .fullRank { members := ![0,1,17,34,52,69,92,262], points := ![99,107,127,135,137,138], inverse := ![14,9,9,11,0,4,10,13,14,11,9,11,0,0,0,11,3,8,1,6,15,2,7,13,12,12,0,10,7,13,14,14,0,6,13,11] } }
theorem leafL_035_4_valid : (leafL_035_4).reject.ValidFor (leafL_035_4).leaf := by decide

noncomputable def leafL_035_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,265}, reject := .fullRank { members := ![0,1,17,34,52,69,92,265], points := ![107,122,135,139,141,151], inverse := ![10,11,5,9,11,7,11,4,1,5,3,8,0,0,1,3,2,0,13,0,12,13,0,12,2,3,9,2,7,13,12,10,4,4,14,8] } }
theorem leafL_035_5_valid : (leafL_035_5).reject.ValidFor (leafL_035_5).leaf := by decide

noncomputable def leafL_035_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,267}, reject := .fullRank { members := ![0,1,17,34,52,69,92,267], points := ![99,104,127,131,135,137], inverse := ![13,10,9,11,1,5,2,5,14,13,11,15,0,0,0,3,4,7,6,1,15,14,12,10,2,2,0,7,11,12,12,12,0,7,13,10] } }
theorem leafL_035_6_valid : (leafL_035_6).reject.ValidFor (leafL_035_6).leaf := by decide

noncomputable def leafL_035_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,92,269}, reject := .fullRank { members := ![0,1,17,34,52,69,92,269], points := ![104,107,126,131,135,138], inverse := ![1,6,9,6,0,9,11,12,14,15,8,14,0,0,0,12,2,14,2,5,15,13,1,4,14,14,0,10,4,14,2,2,0,12,6,10] } }
theorem leafL_035_7_valid : (leafL_035_7).reject.ValidFor (leafL_035_7).leaf := by decide

noncomputable def leavesL_035 : List RejectedLeaf := [leafL_035_0,leafL_035_1,leafL_035_2,leafL_035_3,leafL_035_4,leafL_035_5,leafL_035_6,leafL_035_7]

theorem leavesL_035_valid : LeafListValid leavesL_035 := by
  intro x hx
  simp only [leavesL_035, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_035_0_valid
  · exact leafL_035_1_valid
  · exact leafL_035_2_valid
  · exact leafL_035_3_valid
  · exact leafL_035_4_valid
  · exact leafL_035_5_valid
  · exact leafL_035_6_valid
  · exact leafL_035_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
