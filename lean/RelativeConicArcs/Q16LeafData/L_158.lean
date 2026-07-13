import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_158_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,90,144}, reject := .fullRank { members := ![0,1,17,34,52,71,90,144], points := ![109,121,127,155,158,188], inverse := ![13,11,0,0,0,7,15,4,15,5,15,14,14,3,0,4,5,12,7,0,1,3,0,5,4,3,4,12,0,15,1,12,9,6,5,7] } }
theorem leafL_158_0_valid : (leafL_158_0).reject.ValidFor (leafL_158_0).leaf := by decide

noncomputable def leafL_158_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,90,147}, reject := .fullRank { members := ![0,1,17,34,52,71,90,147], points := ![101,124,133,168,171,172], inverse := ![11,11,9,9,0,1,5,0,8,4,2,11,0,0,0,14,4,10,14,5,5,14,7,7,7,6,10,10,7,6,14,12,7,8,4,9] } }
theorem leafL_158_1_valid : (leafL_158_1).reject.ValidFor (leafL_158_1).leaf := by decide

noncomputable def leafL_158_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,90,155}, reject := .fullRank { members := ![0,1,17,34,52,71,90,155], points := ![104,109,124,144,166,172], inverse := ![7,0,9,15,0,0,4,3,14,9,1,1,10,0,3,5,10,6,11,8,0,10,1,8,3,2,7,9,13,2,10,4,12,7,3,6] } }
theorem leafL_158_2_valid : (leafL_158_2).reject.ValidFor (leafL_158_2).leaf := by decide

noncomputable def leafL_158_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,90,166}, reject := .fullRank { members := ![0,1,17,34,52,71,90,166], points := ![99,121,126,133,139,155], inverse := ![15,12,9,13,7,1,9,8,15,7,12,5,9,4,0,7,4,14,15,11,8,8,5,1,5,10,4,9,4,6,12,1,11,7,9,8] } }
theorem leafL_158_3_valid : (leafL_158_3).reject.ValidFor (leafL_158_3).leaf := by decide

noncomputable def leafL_158_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,90,168}, reject := .fullRank { members := ![0,1,17,34,52,71,90,168], points := ![109,121,124,126,131,133], inverse := ![7,14,13,10,11,4,7,8,0,6,15,6,0,8,12,4,0,0,7,1,1,15,0,8,0,5,8,13,1,1,0,0,7,7,7,7] } }
theorem leafL_158_4_valid : (leafL_158_4).reject.ValidFor (leafL_158_4).leaf := by decide

noncomputable def leafL_158_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,90,171}, reject := .fullRank { members := ![0,1,17,34,52,71,90,171], points := ![101,109,124,126,127,133], inverse := ![6,1,12,0,5,15,7,0,12,5,7,9,0,0,4,12,8,0,0,7,0,14,1,8,13,13,11,15,4,0,5,5,6,1,7,0] } }
theorem leafL_158_5_valid : (leafL_158_5).reject.ValidFor (leafL_158_5).leaf := by decide

noncomputable def leafL_158_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,90,188}, reject := .fullRank { members := ![0,1,17,34,52,71,90,188], points := ![104,131,144,150,158,166], inverse := ![10,11,7,10,6,11,14,1,1,9,13,10,1,8,6,3,4,8,13,7,6,8,4,0,1,13,3,4,3,8,14,15,4,0,12,9] } }
theorem leafL_158_6_valid : (leafL_158_6).reject.ValidFor (leafL_158_6).leaf := by decide

noncomputable def leafL_158_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,90,191}, reject := .fullRank { members := ![0,1,17,34,52,71,90,191], points := ![99,101,126,131,133,150], inverse := ![5,12,0,2,15,5,13,6,4,14,9,8,3,10,4,1,2,14,7,11,8,1,6,3,9,10,11,2,8,2,10,10,0,10,10,0] } }
theorem leafL_158_7_valid : (leafL_158_7).reject.ValidFor (leafL_158_7).leaf := by decide

noncomputable def leavesL_158 : List RejectedLeaf := [leafL_158_0,leafL_158_1,leafL_158_2,leafL_158_3,leafL_158_4,leafL_158_5,leafL_158_6,leafL_158_7]

theorem leavesL_158_valid : LeafListValid leavesL_158 := by
  intro x hx
  simp only [leavesL_158, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_158_0_valid
  · exact leafL_158_1_valid
  · exact leafL_158_2_valid
  · exact leafL_158_3_valid
  · exact leafL_158_4_valid
  · exact leafL_158_5_valid
  · exact leafL_158_6_valid
  · exact leafL_158_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
