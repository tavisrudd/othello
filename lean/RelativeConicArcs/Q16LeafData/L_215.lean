import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_215_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,155,253}, reject := .fullRank { members := ![0,1,17,34,52,71,155,253], points := ![83,90,110,120,124,138], inverse := ![7,2,2,6,10,10,12,14,5,10,6,11,7,8,15,0,15,15,3,13,9,6,7,6,7,1,6,7,1,6,8,4,12,5,9,12] } }
theorem leafL_215_0_valid : (leafL_215_0).reject.ValidFor (leafL_215_0).leaf := by decide

noncomputable def leafL_215_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,155,262}, reject := .fullRank { members := ![0,1,17,34,52,71,155,262], points := ![83,90,92,109,110,124], inverse := ![5,5,15,15,7,6,6,8,7,2,12,7,10,11,1,0,0,0,10,7,5,15,0,7,6,3,5,4,4,0,13,7,10,1,1,0] } }
theorem leafL_215_1_valid : (leafL_215_1).reject.ValidFor (leafL_215_1).leaf := by decide

noncomputable def leafL_215_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,155,269}, reject := .fullRank { members := ![0,1,17,34,52,71,155,269], points := ![83,90,94,104,110,120], inverse := ![9,11,13,0,8,6,1,11,3,14,0,7,14,12,2,0,0,0,7,4,11,13,2,7,7,10,13,5,5,0,11,9,2,12,12,0] } }
theorem leafL_215_2_valid : (leafL_215_2).reject.ValidFor (leafL_215_2).leaf := by decide

noncomputable def leafL_215_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,156,171}, reject := .fullRank { members := ![0,1,17,34,52,71,156,171], points := ![83,101,106,109,127,141], inverse := ![12,14,9,12,5,3,13,8,0,2,3,4,0,9,10,3,0,0,1,8,6,8,14,9,6,1,4,3,6,6,15,2,9,4,15,15] } }
theorem leafL_215_3_valid : (leafL_215_3).reject.ValidFor (leafL_215_3).leaf := by decide

noncomputable def leafL_215_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,156,174}, reject := .fullRank { members := ![0,1,17,34,52,71,156,174], points := ![99,101,106,121,127,131], inverse := ![0,0,7,0,9,15,14,5,12,15,1,9,8,15,7,0,0,0,13,1,11,6,9,8,11,10,1,9,9,0,12,12,0,12,12,0] } }
theorem leafL_215_4_valid : (leafL_215_4).reject.ValidFor (leafL_215_4).leaf := by decide

noncomputable def leafL_215_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,156,181}, reject := .fullRank { members := ![0,1,17,34,52,71,156,181], points := ![83,94,109,121,127,139], inverse := ![13,12,6,4,12,14,0,4,3,4,14,13,5,6,3,10,9,3,1,0,6,14,0,9,8,9,1,8,9,1,8,12,4,1,5,4] } }
theorem leafL_215_5_valid : (leafL_215_5).reject.ValidFor (leafL_215_5).leaf := by decide

noncomputable def leafL_215_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,156,191}, reject := .fullRank { members := ![0,1,17,34,52,71,156,191], points := ![94,99,101,106,121,131], inverse := ![11,14,12,14,2,4,5,1,14,13,11,12,0,8,15,7,0,0,11,3,13,2,4,3,11,5,6,8,11,11,9,4,1,12,9,9] } }
theorem leafL_215_6_valid : (leafL_215_6).reject.ValidFor (leafL_215_6).leaf := by decide

noncomputable def leafL_215_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,156,203}, reject := .fullRank { members := ![0,1,17,34,52,71,156,203], points := ![83,99,106,109,122,127], inverse := ![15,4,0,12,5,3,9,8,5,3,12,11,0,15,1,14,0,0,8,14,11,10,8,15,0,2,6,4,10,10,0,10,7,13,2,2] } }
theorem leafL_215_7_valid : (leafL_215_7).reject.ValidFor (leafL_215_7).leaf := by decide

noncomputable def leavesL_215 : List RejectedLeaf := [leafL_215_0,leafL_215_1,leafL_215_2,leafL_215_3,leafL_215_4,leafL_215_5,leafL_215_6,leafL_215_7]

theorem leavesL_215_valid : LeafListValid leavesL_215 := by
  intro x hx
  simp only [leavesL_215, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_215_0_valid
  · exact leafL_215_1_valid
  · exact leafL_215_2_valid
  · exact leafL_215_3_valid
  · exact leafL_215_4_valid
  · exact leafL_215_5_valid
  · exact leafL_215_6_valid
  · exact leafL_215_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
