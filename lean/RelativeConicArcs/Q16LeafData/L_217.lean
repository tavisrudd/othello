import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_217_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,158,166}, reject := .fullRank { members := ![0,1,17,34,52,71,158,166], points := ![83,90,93,99,106,120], inverse := ![15,8,8,13,5,6,6,8,7,1,15,7,15,1,14,0,0,0,13,2,7,10,5,7,1,9,8,7,7,0,5,5,0,5,5,0] } }
theorem leafL_217_0_valid : (leafL_217_0).reject.ValidFor (leafL_217_0).leaf := by decide

noncomputable def leafL_217_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,158,168}, reject := .fullRank { members := ![0,1,17,34,52,71,158,168], points := ![90,91,92,101,106,121], inverse := ![15,1,1,13,5,6,6,4,11,13,3,7,7,14,9,0,0,0,6,15,1,15,0,7,15,8,7,3,3,0,2,5,7,4,4,0] } }
theorem leafL_217_1_valid : (leafL_217_1).reject.ValidFor (leafL_217_1).leaf := by decide

noncomputable def leafL_217_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,158,172}, reject := .fullRank { members := ![0,1,17,34,52,71,158,172], points := ![83,90,91,104,106,120], inverse := ![11,9,13,10,2,6,13,10,14,14,0,7,6,3,5,0,0,0,9,14,15,6,9,7,12,5,9,12,12,0,8,10,2,3,3,0] } }
theorem leafL_217_2_valid : (leafL_217_2).reject.ValidFor (leafL_217_2).leaf := by decide

noncomputable def leafL_217_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,158,191}, reject := .fullRank { members := ![0,1,17,34,52,71,158,191], points := ![90,91,92,99,101,120], inverse := ![10,7,2,15,7,6,5,12,0,7,9,7,7,14,9,0,0,0,6,1,15,8,7,7,12,14,2,15,15,0,6,13,11,7,7,0] } }
theorem leafL_217_3_valid : (leafL_217_3).reject.ValidFor (leafL_217_3).leaf := by decide

noncomputable def leafL_217_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,158,208}, reject := .fullRank { members := ![0,1,17,34,52,71,158,208], points := ![83,90,106,124,138,141], inverse := ![12,2,9,7,3,2,0,14,9,0,7,0,13,8,5,5,8,13,11,13,1,9,9,7,4,1,5,5,14,11,5,4,1,1,15,14] } }
theorem leafL_217_4_valid : (leafL_217_4).reject.ValidFor (leafL_217_4).leaf := by decide

noncomputable def leafL_217_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,158,217}, reject := .fullRank { members := ![0,1,17,34,52,71,158,217], points := ![91,99,101,104,120,124], inverse := ![15,7,10,5,2,4,9,12,1,3,3,4,0,4,12,8,0,0,8,1,13,3,10,13,0,4,3,7,13,13,0,7,2,5,6,6] } }
theorem leafL_217_5_valid : (leafL_217_5).reject.ValidFor (leafL_217_5).leaf := by decide

noncomputable def leafL_217_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,158,249}, reject := .fullRank { members := ![0,1,17,34,52,71,158,249], points := ![83,90,92,101,104,120], inverse := ![6,8,1,5,13,6,7,6,8,0,14,7,10,11,1,0,0,0,10,4,6,12,3,7,9,4,13,13,13,0,10,2,8,14,14,0] } }
theorem leafL_217_6_valid : (leafL_217_6).reject.ValidFor (leafL_217_6).leaf := by decide

noncomputable def leafL_217_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,158,269}, reject := .fullRank { members := ![0,1,17,34,52,71,158,269], points := ![83,90,91,104,120,124], inverse := ![7,1,9,8,0,6,13,10,14,14,7,0,6,3,5,0,0,0,10,12,14,15,15,8,2,0,2,0,7,7,2,6,4,0,5,5] } }
theorem leafL_217_7_valid : (leafL_217_7).reject.ValidFor (leafL_217_7).leaf := by decide

noncomputable def leavesL_217 : List RejectedLeaf := [leafL_217_0,leafL_217_1,leafL_217_2,leafL_217_3,leafL_217_4,leafL_217_5,leafL_217_6,leafL_217_7]

theorem leavesL_217_valid : LeafListValid leavesL_217 := by
  intro x hx
  simp only [leavesL_217, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_217_0_valid
  · exact leafL_217_1_valid
  · exact leafL_217_2_valid
  · exact leafL_217_3_valid
  · exact leafL_217_4_valid
  · exact leafL_217_5_valid
  · exact leafL_217_6_valid
  · exact leafL_217_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
