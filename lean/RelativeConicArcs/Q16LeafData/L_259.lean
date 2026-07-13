import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_259_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,107,188}, reject := .fullRank { members := ![0,1,17,34,52,72,107,188], points := ![94,115,117,122,137,144], inverse := ![7,1,12,3,15,7,7,13,3,7,4,10,0,8,15,7,0,0,7,6,3,13,0,15,0,6,6,0,7,7,0,15,8,7,6,6] } }
theorem leafL_259_0_valid : (leafL_259_0).reject.ValidFor (leafL_259_0).leaf := by decide

noncomputable def leafL_259_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,107,197}, reject := .fullRank { members := ![0,1,17,34,52,72,107,197], points := ![83,94,115,138,156,163], inverse := ![6,0,9,1,1,14,2,0,4,0,0,6,7,8,1,4,5,15,2,5,3,4,11,11,14,3,11,1,3,4,14,11,1,2,12,10] } }
theorem leafL_259_1_valid : (leafL_259_1).reject.ValidFor (leafL_259_1).leaf := by decide

noncomputable def leafL_259_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,107,237}, reject := .fullRank { members := ![0,1,17,34,52,72,107,237], points := ![83,94,115,122,124,138], inverse := ![13,10,11,1,4,8,1,6,13,7,3,14,0,0,10,11,1,0,3,4,11,1,2,15,11,11,9,14,7,0,4,4,12,14,2,0] } }
theorem leafL_259_2_valid : (leafL_259_2).reject.ValidFor (leafL_259_2).leaf := by decide

noncomputable def leafL_259_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,107,254}, reject := .fullRank { members := ![0,1,17,34,52,72,107,254], points := ![122,150,156,166,169,172], inverse := ![10,9,12,9,4,3,11,10,9,3,15,4,0,0,0,12,13,1,11,4,6,13,15,11,0,8,8,15,10,5,0,3,3,3,0,3] } }
theorem leafL_259_3_valid : (leafL_259_3).reject.ValidFor (leafL_259_3).leaf := by decide

noncomputable def leafL_259_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,107,262}, reject := .fullRank { members := ![0,1,17,34,52,72,107,262], points := ![92,117,124,126,149,156], inverse := ![2,9,10,6,3,5,5,0,8,0,0,13,0,3,13,14,0,0,3,9,3,0,9,0,0,5,0,5,15,15,0,11,11,0,11,11] } }
theorem leafL_259_4_valid : (leafL_259_4).reject.ValidFor (leafL_259_4).leaf := by decide

noncomputable def leafL_259_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,107,263}, reject := .fullRank { members := ![0,1,17,34,52,72,107,263], points := ![92,94,115,117,122,144], inverse := ![2,5,0,9,7,8,12,11,11,14,12,14,0,0,8,15,7,0,0,7,6,3,13,15,9,9,11,10,1,0,10,10,10,10,0,0] } }
theorem leafL_259_5_valid : (leafL_259_5).reject.ValidFor (leafL_259_5).leaf := by decide

noncomputable def leafL_259_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,107,269}, reject := .fullRank { members := ![0,1,17,34,52,72,107,269], points := ![83,92,94,115,117,138], inverse := ![3,8,12,4,10,8,1,0,6,11,2,14,3,14,13,0,0,0,11,7,11,11,3,15,10,11,1,14,14,0,0,10,10,10,10,0] } }
theorem leafL_259_6_valid : (leafL_259_6).reject.ValidFor (leafL_259_6).leaf := by decide

noncomputable def leafL_259_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,108,115}, reject := .fullRank { members := ![0,1,17,34,52,72,108,115], points := ![91,96,135,138,150,151], inverse := ![2,10,15,12,0,10,5,3,6,15,8,7,15,15,4,4,5,5,8,12,0,6,9,11,8,8,15,15,3,3,12,12,2,2,13,13] } }
theorem leafL_259_7_valid : (leafL_259_7).reject.ValidFor (leafL_259_7).leaf := by decide

noncomputable def leavesL_259 : List RejectedLeaf := [leafL_259_0,leafL_259_1,leafL_259_2,leafL_259_3,leafL_259_4,leafL_259_5,leafL_259_6,leafL_259_7]

theorem leavesL_259_valid : LeafListValid leavesL_259 := by
  intro x hx
  simp only [leavesL_259, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_259_0_valid
  · exact leafL_259_1_valid
  · exact leafL_259_2_valid
  · exact leafL_259_3_valid
  · exact leafL_259_4_valid
  · exact leafL_259_5_valid
  · exact leafL_259_6_valid
  · exact leafL_259_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
