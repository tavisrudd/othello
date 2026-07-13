import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_185_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,109,140}, reject := .fullRank { members := ![0,1,17,34,52,71,109,140], points := ![94,120,127,128,150,155], inverse := ![2,10,3,12,15,9,5,6,6,8,14,3,0,13,2,15,0,0,3,6,6,10,9,0,0,5,5,0,15,15,0,13,1,12,11,11] } }
theorem leafL_185_0_valid : (leafL_185_0).reject.ValidFor (leafL_185_0).leaf := by decide

noncomputable def leafL_185_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,109,150}, reject := .fullRank { members := ![0,1,17,34,52,71,109,150], points := ![90,91,124,128,131,138], inverse := ![5,2,9,7,6,14,12,11,9,0,6,8,4,4,5,5,1,1,4,3,4,12,15,0,0,0,5,5,13,13,9,9,11,11,10,10] } }
theorem leafL_185_1_valid : (leafL_185_1).reject.ValidFor (leafL_185_1).leaf := by decide

noncomputable def leafL_185_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,109,155}, reject := .fullRank { members := ![0,1,17,34,52,71,109,155], points := ![90,92,94,120,124,140], inverse := ![13,12,6,4,10,8,0,7,0,0,9,14,15,10,5,0,0,0,15,15,7,1,9,15,15,3,12,7,7,0,6,14,8,5,5,0] } }
theorem leafL_185_2_valid : (leafL_185_2).reject.ValidFor (leafL_185_2).leaf := by decide

noncomputable def leafL_185_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,109,156}, reject := .fullRank { members := ![0,1,17,34,52,71,109,156], points := ![94,131,144,166,171,174], inverse := ![11,11,9,5,6,11,13,8,9,13,12,13,0,0,0,1,5,4,10,1,12,0,11,12,0,6,6,8,13,5,0,12,12,13,6,11] } }
theorem leafL_185_3_valid : (leafL_185_3).reject.ValidFor (leafL_185_3).leaf := by decide

noncomputable def leafL_185_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,109,159}, reject := .fullRank { members := ![0,1,17,34,52,71,109,159], points := ![92,124,131,166,168,171], inverse := ![3,5,14,11,11,9,2,4,0,13,4,15,0,0,0,4,2,6,7,8,15,1,4,5,2,12,3,6,0,11,4,11,6,14,9,14] } }
theorem leafL_185_4_valid : (leafL_185_4).reject.ValidFor (leafL_185_4).leaf := by decide

noncomputable def leafL_185_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,109,168}, reject := .fullRank { members := ![0,1,17,34,52,71,109,168], points := ![90,91,92,124,131,138], inverse := ![9,12,2,14,2,10,12,11,0,9,6,8,7,14,9,0,0,0,0,8,15,8,2,13,3,10,9,0,12,12,1,12,13,0,3,3] } }
theorem leafL_185_5_valid : (leafL_185_5).reject.ValidFor (leafL_185_5).leaf := by decide

noncomputable def leafL_185_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,109,174}, reject := .fullRank { members := ![0,1,17,34,52,71,109,174], points := ![91,92,120,124,127,131], inverse := ![12,11,13,3,0,8,10,13,2,4,15,14,0,0,7,2,5,0,11,12,12,6,2,15,3,3,10,4,14,0,9,9,14,8,6,0] } }
theorem leafL_185_6_valid : (leafL_185_6).reject.ValidFor (leafL_185_6).leaf := by decide

noncomputable def leafL_185_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,109,181}, reject := .fullRank { members := ![0,1,17,34,52,71,109,181], points := ![91,94,120,127,138,140], inverse := ![6,1,14,0,14,6,5,2,6,15,9,7,13,13,13,13,5,5,5,2,9,1,5,10,8,8,6,6,14,14,6,6,4,4,8,8] } }
theorem leafL_185_7_valid : (leafL_185_7).reject.ValidFor (leafL_185_7).leaf := by decide

noncomputable def leavesL_185 : List RejectedLeaf := [leafL_185_0,leafL_185_1,leafL_185_2,leafL_185_3,leafL_185_4,leafL_185_5,leafL_185_6,leafL_185_7]

theorem leavesL_185_valid : LeafListValid leavesL_185 := by
  intro x hx
  simp only [leavesL_185, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_185_0_valid
  · exact leafL_185_1_valid
  · exact leafL_185_2_valid
  · exact leafL_185_3_valid
  · exact leafL_185_4_valid
  · exact leafL_185_5_valid
  · exact leafL_185_6_valid
  · exact leafL_185_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
