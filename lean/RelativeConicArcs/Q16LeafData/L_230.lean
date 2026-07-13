import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_230_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,181,233}, reject := .fullRank { members := ![0,1,17,34,52,71,181,233], points := ![91,94,109,124,127,138], inverse := ![10,8,5,10,1,13,14,14,7,7,9,9,2,6,4,1,5,4,8,7,8,2,2,7,12,0,12,6,10,12,1,5,4,13,9,4] } }
theorem leafL_230_0_valid : (leafL_230_0).reject.ValidFor (leafL_230_0).leaf := by decide

noncomputable def leafL_230_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,181,240}, reject := .fullRank { members := ![0,1,17,34,52,71,181,240], points := ![94,109,120,124,127,138], inverse := ![5,2,8,5,1,10,15,8,6,14,9,6,0,0,7,2,5,0,12,11,15,14,2,4,7,7,1,12,10,7,6,6,10,5,9,6] } }
theorem leafL_230_1_valid : (leafL_230_1).reject.ValidFor (leafL_230_1).leaf := by decide

noncomputable def leafL_230_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,181,249}, reject := .fullRank { members := ![0,1,17,34,52,71,181,249], points := ![83,94,109,120,140,141], inverse := ![10,4,9,7,9,8,6,15,14,7,3,3,6,14,8,8,15,7,13,9,3,11,9,5,2,0,2,2,15,13,10,14,4,4,12,8] } }
theorem leafL_230_2_valid : (leafL_230_2).reject.ValidFor (leafL_230_2).leaf := by decide

noncomputable def leafL_230_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,182,197}, reject := .fullRank { members := ![0,1,17,34,52,71,182,197], points := ![93,94,99,104,106,121], inverse := ![8,7,10,7,5,6,11,2,15,4,5,7,0,0,1,14,15,0,6,14,6,11,2,7,5,5,8,5,13,0,1,1,15,6,9,0] } }
theorem leafL_230_3_valid : (leafL_230_3).reject.ValidFor (leafL_230_3).leaf := by decide

noncomputable def leafL_230_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,182,207}, reject := .fullRank { members := ![0,1,17,34,52,71,182,207], points := ![91,92,99,101,110,122], inverse := ![6,9,6,0,14,6,1,8,14,3,3,7,0,0,13,14,3,0,10,2,10,11,14,7,5,5,5,4,1,0,1,1,2,11,9,0] } }
theorem leafL_230_4_valid : (leafL_230_4).reject.ValidFor (leafL_230_4).leaf := by decide

noncomputable def leafL_230_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,182,208}, reject := .fullRank { members := ![0,1,17,34,52,71,182,208], points := ![94,121,126,138,141,155], inverse := ![2,2,7,15,15,6,4,1,0,13,10,2,12,4,2,7,5,8,1,4,15,15,1,4,9,3,14,7,13,14,0,11,11,11,11,0] } }
theorem leafL_230_5_valid : (leafL_230_5).reject.ValidFor (leafL_230_5).leaf := by decide

noncomputable def leafL_230_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,182,216}, reject := .fullRank { members := ![0,1,17,34,52,71,182,216], points := ![91,96,99,101,106,122], inverse := ![3,12,4,6,10,6,14,7,14,6,6,7,0,0,8,15,7,0,13,5,7,1,9,7,1,1,11,1,10,0,11,11,12,5,9,0] } }
theorem leafL_230_6_valid : (leafL_230_6).reject.ValidFor (leafL_230_6).leaf := by decide

noncomputable def leafL_230_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,182,218}, reject := .fullRank { members := ![0,1,17,34,52,71,182,218], points := ![94,96,101,104,110,121], inverse := ![11,4,5,7,10,6,5,12,4,12,6,7,0,0,15,4,11,0,11,3,9,7,1,7,11,11,9,6,15,0,9,9,1,10,11,0] } }
theorem leafL_230_7_valid : (leafL_230_7).reject.ValidFor (leafL_230_7).leaf := by decide

noncomputable def leavesL_230 : List RejectedLeaf := [leafL_230_0,leafL_230_1,leafL_230_2,leafL_230_3,leafL_230_4,leafL_230_5,leafL_230_6,leafL_230_7]

theorem leavesL_230_valid : LeafListValid leavesL_230 := by
  intro x hx
  simp only [leavesL_230, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_230_0_valid
  · exact leafL_230_1_valid
  · exact leafL_230_2_valid
  · exact leafL_230_3_valid
  · exact leafL_230_4_valid
  · exact leafL_230_5_valid
  · exact leafL_230_6_valid
  · exact leafL_230_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
