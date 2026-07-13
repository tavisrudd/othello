import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_226_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,173,246}, reject := .fullRank { members := ![0,1,17,34,52,71,173,246], points := ![83,92,94,101,104,122], inverse := ![13,8,10,8,0,6,6,1,14,8,6,7,3,14,13,0,0,0,14,3,5,4,11,7,3,6,5,13,13,0,15,4,11,14,14,0] } }
theorem leafL_226_0_valid : (leafL_226_0).reject.ValidFor (leafL_226_0).leaf := by decide

noncomputable def leafL_226_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,173,262}, reject := .fullRank { members := ![0,1,17,34,52,71,173,262], points := ![83,92,96,106,124,126], inverse := ![0,3,12,8,3,5,7,8,6,14,11,12,8,9,1,0,0,0,9,5,4,15,14,9,0,4,4,0,14,14,8,6,14,0,10,10] } }
theorem leafL_226_1_valid : (leafL_226_1).reject.ValidFor (leafL_226_1).leaf := by decide

noncomputable def leafL_226_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,174,181}, reject := .fullRank { members := ![0,1,17,34,52,71,174,181], points := ![91,109,120,121,124,138], inverse := ![3,4,2,12,4,12,5,2,8,6,5,12,0,0,15,9,6,0,4,3,15,11,15,12,12,12,3,1,14,12,2,2,7,6,3,2] } }
theorem leafL_226_2_valid : (leafL_226_2).reject.ValidFor (leafL_226_2).leaf := by decide

noncomputable def leafL_226_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,174,191}, reject := .fullRank { members := ![0,1,17,34,52,71,174,191], points := ![91,92,99,101,106,120], inverse := ![0,15,11,9,10,6,6,15,5,14,5,7,0,0,8,15,7,0,13,5,5,12,6,7,5,5,6,10,12,0,1,1,10,12,6,0] } }
theorem leafL_226_3_valid : (leafL_226_3).reject.ValidFor (leafL_226_3).leaf := by decide

noncomputable def leafL_226_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,174,203}, reject := .fullRank { members := ![0,1,17,34,52,71,174,203], points := ![93,99,106,122,127,131], inverse := ![0,0,7,0,9,15,6,13,12,13,5,15,14,1,15,14,0,14,5,14,12,4,14,13,4,6,2,14,10,4,13,7,10,15,2,13] } }
theorem leafL_226_4_valid : (leafL_226_4).reject.ValidFor (leafL_226_4).leaf := by decide

noncomputable def leafL_226_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,174,213}, reject := .fullRank { members := ![0,1,17,34,52,71,174,213], points := ![91,92,93,121,124,131], inverse := ![2,7,2,1,15,8,5,6,4,10,3,14,7,6,1,0,0,0,2,6,3,3,11,15,11,14,5,15,15,0,14,15,1,7,7,0] } }
theorem leafL_226_5_valid : (leafL_226_5).reject.ValidFor (leafL_226_5).leaf := by decide

noncomputable def leafL_226_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,174,217}, reject := .fullRank { members := ![0,1,17,34,52,71,174,217], points := ![91,99,101,109,120,122], inverse := ![15,10,9,11,9,15,9,0,13,3,8,15,0,9,11,2,0,0,8,11,12,8,2,5,0,1,8,9,5,5,0,1,0,1,1,1] } }
theorem leafL_226_6_valid : (leafL_226_6).reject.ValidFor (leafL_226_6).leaf := by decide

noncomputable def leafL_226_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,174,218}, reject := .fullRank { members := ![0,1,17,34,52,71,174,218], points := ![91,101,120,121,124,155], inverse := ![8,9,1,3,6,4,5,0,2,1,11,13,0,0,15,9,6,0,0,10,15,1,3,7,1,6,15,12,15,11,7,1,5,3,4,4] } }
theorem leafL_226_7_valid : (leafL_226_7).reject.ValidFor (leafL_226_7).leaf := by decide

noncomputable def leavesL_226 : List RejectedLeaf := [leafL_226_0,leafL_226_1,leafL_226_2,leafL_226_3,leafL_226_4,leafL_226_5,leafL_226_6,leafL_226_7]

theorem leavesL_226_valid : LeafListValid leavesL_226 := by
  intro x hx
  simp only [leavesL_226, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_226_0_valid
  · exact leafL_226_1_valid
  · exact leafL_226_2_valid
  · exact leafL_226_3_valid
  · exact leafL_226_4_valid
  · exact leafL_226_5_valid
  · exact leafL_226_6_valid
  · exact leafL_226_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
