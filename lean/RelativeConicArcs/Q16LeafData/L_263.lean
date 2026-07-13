import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_263_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,122,156}, reject := .fullRank { members := ![0,1,17,34,52,72,122,156], points := ![83,96,107,135,137,139], inverse := ![14,7,14,5,1,2,12,2,9,6,7,6,0,0,0,13,8,5,0,15,8,13,11,1,5,5,0,11,0,11,13,13,0,12,9,5] } }
theorem leafL_263_0_valid : (leafL_263_0).reject.ValidFor (leafL_263_0).leaf := by decide

noncomputable def leafL_263_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,122,159}, reject := .fullRank { members := ![0,1,17,34,52,72,122,159], points := ![83,92,96,108,112,135], inverse := ![13,10,14,3,13,6,7,9,0,14,7,7,8,9,1,0,0,0,7,14,6,9,1,7,6,14,8,1,1,0,0,13,13,13,13,0] } }
theorem leafL_263_1_valid : (leafL_263_1).reject.ValidFor (leafL_263_1).leaf := by decide

noncomputable def leafL_263_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,122,183}, reject := .fullRank { members := ![0,1,17,34,52,72,122,183], points := ![92,107,112,137,139,149], inverse := ![6,11,0,4,4,12,0,1,3,15,11,6,3,7,6,2,13,13,11,7,2,5,5,14,3,5,4,14,1,13,13,15,5,10,6,11] } }
theorem leafL_263_2_valid : (leafL_263_2).reject.ValidFor (leafL_263_2).leaf := by decide

noncomputable def leafL_263_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,122,190}, reject := .fullRank { members := ![0,1,17,34,52,72,122,190], points := ![83,92,96,107,135,139], inverse := ![15,14,8,14,2,4,11,12,9,9,0,7,8,9,1,0,0,0,11,8,12,8,9,14,5,0,5,0,11,11,4,7,3,0,6,6] } }
theorem leafL_263_3_valid : (leafL_263_3).reject.ValidFor (leafL_263_3).leaf := by decide

noncomputable def leafL_263_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,122,199}, reject := .fullRank { members := ![0,1,17,34,52,72,122,199], points := ![83,94,96,107,108,137], inverse := ![10,14,13,7,9,6,9,8,15,8,1,7,6,4,2,0,0,0,4,1,10,3,11,7,2,6,4,4,4,0,10,5,15,1,1,0] } }
theorem leafL_263_4_valid : (leafL_263_4).reject.ValidFor (leafL_263_4).leaf := by decide

noncomputable def leafL_263_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,122,201}, reject := .fullRank { members := ![0,1,17,34,52,72,122,201], points := ![83,92,96,112,139,143], inverse := ![9,5,5,14,13,11,12,4,6,9,5,2,8,9,1,0,0,0,12,8,11,8,9,14,6,1,7,0,14,14,0,10,10,0,10,10] } }
theorem leafL_263_5_valid : (leafL_263_5).reject.ValidFor (leafL_263_5).leaf := by decide

noncomputable def leafL_263_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,122,203}, reject := .fullRank { members := ![0,1,17,34,52,72,122,203], points := ![92,96,108,112,143,147], inverse := ![8,0,13,13,3,10,4,1,3,2,6,2,5,6,8,9,15,13,3,7,4,4,6,2,11,7,7,3,9,1,13,13,13,13,0,0] } }
theorem leafL_263_6_valid : (leafL_263_6).reject.ValidFor (leafL_263_6).leaf := by decide

noncomputable def leafL_263_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,122,207}, reject := .fullRank { members := ![0,1,17,34,52,72,122,207], points := ![83,94,107,144,147,149], inverse := ![9,2,1,12,8,15,2,14,6,13,11,12,5,12,7,11,12,9,8,8,13,1,0,12,15,11,13,7,6,8,13,6,8,1,10,8] } }
theorem leafL_263_7_valid : (leafL_263_7).reject.ValidFor (leafL_263_7).leaf := by decide

noncomputable def leavesL_263 : List RejectedLeaf := [leafL_263_0,leafL_263_1,leafL_263_2,leafL_263_3,leafL_263_4,leafL_263_5,leafL_263_6,leafL_263_7]

theorem leavesL_263_valid : LeafListValid leavesL_263 := by
  intro x hx
  simp only [leavesL_263, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_263_0_valid
  · exact leafL_263_1_valid
  · exact leafL_263_2_valid
  · exact leafL_263_3_valid
  · exact leafL_263_4_valid
  · exact leafL_263_5_valid
  · exact leafL_263_6_valid
  · exact leafL_263_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
