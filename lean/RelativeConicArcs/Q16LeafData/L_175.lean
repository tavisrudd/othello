import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_175_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,147}, reject := .fullRank { members := ![0,1,17,34,52,71,101,147], points := ![90,92,124,126,128,141], inverse := ![9,14,14,10,10,8,3,4,2,0,11,14,0,0,5,10,15,0,0,7,13,6,3,15,8,8,10,6,12,0,13,13,0,13,13,0] } }
theorem leafL_175_0_valid : (leafL_175_0).reject.ValidFor (leafL_175_0).leaf := by decide

noncomputable def leafL_175_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,150}, reject := .fullRank { members := ![0,1,17,34,52,71,101,150], points := ![83,90,93,124,126,131], inverse := ![9,6,8,7,9,8,12,7,12,12,5,14,15,1,14,0,0,0,11,1,13,0,8,15,2,13,15,14,14,0,1,4,5,10,10,0] } }
theorem leafL_175_1_valid : (leafL_175_1).reject.ValidFor (leafL_175_1).leaf := by decide

noncomputable def leafL_175_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,155}, reject := .fullRank { members := ![0,1,17,34,52,71,101,155], points := ![83,92,94,124,128,138], inverse := ![15,5,13,4,10,8,14,3,10,4,13,14,3,14,13,0,0,0,1,5,3,2,10,15,6,6,0,9,9,0,3,4,7,15,15,0] } }
theorem leafL_175_2_valid : (leafL_175_2).reject.ValidFor (leafL_175_2).leaf := by decide

noncomputable def leafL_175_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,156}, reject := .fullRank { members := ![0,1,17,34,52,71,101,156], points := ![83,96,121,127,131,139], inverse := ![5,2,14,0,15,7,14,9,15,6,9,7,1,1,15,15,14,14,0,7,6,14,14,1,4,4,15,15,9,9,14,14,2,2,4,4] } }
theorem leafL_175_3_valid : (leafL_175_3).reject.ValidFor (leafL_175_3).leaf := by decide

noncomputable def leafL_175_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,171}, reject := .fullRank { members := ![0,1,17,34,52,71,101,171], points := ![90,92,124,126,128,138], inverse := ![3,4,7,6,15,8,7,0,9,9,9,14,0,0,5,10,15,0,8,15,8,7,7,15,8,8,10,6,12,0,13,13,0,13,13,0] } }
theorem leafL_175_4_valid : (leafL_175_4).reject.ValidFor (leafL_175_4).leaf := by decide

noncomputable def leafL_175_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,173}, reject := .fullRank { members := ![0,1,17,34,52,71,101,173], points := ![83,94,96,124,126,139], inverse := ![6,15,14,4,10,8,1,11,13,3,10,14,6,4,2,0,0,0,1,0,6,13,5,15,9,6,15,14,14,0,12,5,9,10,10,0] } }
theorem leafL_175_5_valid : (leafL_175_5).reject.ValidFor (leafL_175_5).leaf := by decide

noncomputable def leafL_175_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,174}, reject := .fullRank { members := ![0,1,17,34,52,71,101,174], points := ![92,93,121,127,131,138], inverse := ![2,5,2,12,6,14,7,0,4,13,6,8,4,4,14,14,12,12,1,6,1,9,7,8,13,13,13,13,9,9,1,1,13,13,6,6] } }
theorem leafL_175_6_valid : (leafL_175_6).reject.ValidFor (leafL_175_6).leaf := by decide

noncomputable def leafL_175_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,101,176}, reject := .fullRank { members := ![0,1,17,34,52,71,101,176], points := ![83,90,92,126,127,131], inverse := ![12,5,14,0,14,8,9,10,4,2,11,14,10,11,1,0,0,0,12,15,4,8,0,15,0,8,8,15,15,0,5,1,4,7,7,0] } }
theorem leafL_175_7_valid : (leafL_175_7).reject.ValidFor (leafL_175_7).leaf := by decide

noncomputable def leavesL_175 : List RejectedLeaf := [leafL_175_0,leafL_175_1,leafL_175_2,leafL_175_3,leafL_175_4,leafL_175_5,leafL_175_6,leafL_175_7]

theorem leavesL_175_valid : LeafListValid leavesL_175 := by
  intro x hx
  simp only [leavesL_175, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_175_0_valid
  · exact leafL_175_1_valid
  · exact leafL_175_2_valid
  · exact leafL_175_3_valid
  · exact leafL_175_4_valid
  · exact leafL_175_5_valid
  · exact leafL_175_6_valid
  · exact leafL_175_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
