import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_257_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,103,174}, reject := .fullRank { members := ![0,1,17,34,52,72,103,174], points := ![91,93,124,138,143,147], inverse := ![2,0,5,9,9,6,1,6,9,10,4,0,12,6,5,11,8,12,7,7,2,7,14,11,15,13,1,1,15,13,8,14,3,10,11,4] } }
theorem leafL_257_0_valid : (leafL_257_0).reject.ValidFor (leafL_257_0).leaf := by decide

noncomputable def leafL_257_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,103,181}, reject := .fullRank { members := ![0,1,17,34,52,72,103,181], points := ![83,91,94,124,125,138], inverse := ![3,13,9,12,2,8,7,11,11,15,6,14,1,4,5,0,0,0,13,13,7,10,2,15,7,5,2,12,12,0,0,3,3,3,3,0] } }
theorem leafL_257_1_valid : (leafL_257_1).reject.ValidFor (leafL_257_1).leaf := by decide

noncomputable def leafL_257_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,103,185}, reject := .fullRank { members := ![0,1,17,34,52,72,103,185], points := ![91,93,94,125,126,138], inverse := ![14,11,2,12,2,8,12,13,6,2,11,14,1,7,6,0,0,0,11,6,10,11,3,15,1,4,5,2,2,0,0,9,9,9,9,0] } }
theorem leafL_257_2_valid : (leafL_257_2).reject.ValidFor (leafL_257_2).leaf := by decide

noncomputable def leafL_257_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,103,191}, reject := .fullRank { members := ![0,1,17,34,52,72,103,191], points := ![94,96,126,138,139,149], inverse := ![3,15,2,6,10,3,9,1,7,5,0,10,8,11,8,11,2,2,2,5,8,14,1,0,7,5,1,9,7,13,14,15,9,3,4,15] } }
theorem leafL_257_3_valid : (leafL_257_3).reject.ValidFor (leafL_257_3).leaf := by decide

noncomputable def leafL_257_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,103,197}, reject := .fullRank { members := ![0,1,17,34,52,72,103,197], points := ![83,93,94,138,143,156], inverse := ![0,8,0,3,0,10,14,2,10,15,6,15,11,3,8,0,0,0,7,8,11,13,11,2,12,4,8,8,8,0,5,8,13,2,2,0] } }
theorem leafL_257_4_valid : (leafL_257_4).reject.ValidFor (leafL_257_4).leaf := by decide

noncomputable def leafL_257_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,103,202}, reject := .fullRank { members := ![0,1,17,34,52,72,103,202], points := ![93,94,124,126,139,143], inverse := ![14,9,15,1,3,11,12,11,6,15,11,5,14,14,7,7,7,7,12,11,3,11,1,14,6,6,5,5,11,11,15,15,9,9,3,3] } }
theorem leafL_257_5_valid : (leafL_257_5).reject.ValidFor (leafL_257_5).leaf := by decide

noncomputable def leafL_257_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,103,208}, reject := .fullRank { members := ![0,1,17,34,52,72,103,208], points := ![83,91,94,124,125,138], inverse := ![3,13,9,12,2,8,7,11,11,15,6,14,1,4,5,0,0,0,13,13,7,10,2,15,7,5,2,12,12,0,0,3,3,3,3,0] } }
theorem leafL_257_6_valid : (leafL_257_6).reject.ValidFor (leafL_257_6).leaf := by decide

noncomputable def leafL_257_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,103,220}, reject := .fullRank { members := ![0,1,17,34,52,72,103,220], points := ![91,94,139,147,149,159], inverse := ![6,14,3,11,9,8,6,0,9,9,8,14,0,0,0,3,2,1,1,5,6,14,5,9,4,4,0,4,13,9,9,9,0,14,4,10] } }
theorem leafL_257_7_valid : (leafL_257_7).reject.ValidFor (leafL_257_7).leaf := by decide

noncomputable def leavesL_257 : List RejectedLeaf := [leafL_257_0,leafL_257_1,leafL_257_2,leafL_257_3,leafL_257_4,leafL_257_5,leafL_257_6,leafL_257_7]

theorem leavesL_257_valid : LeafListValid leavesL_257 := by
  intro x hx
  simp only [leavesL_257, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_257_0_valid
  · exact leafL_257_1_valid
  · exact leafL_257_2_valid
  · exact leafL_257_3_valid
  · exact leafL_257_4_valid
  · exact leafL_257_5_valid
  · exact leafL_257_6_valid
  · exact leafL_257_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
