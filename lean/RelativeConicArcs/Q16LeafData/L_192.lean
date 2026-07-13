import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_192_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,120,253}, reject := .fullRank { members := ![0,1,17,34,52,71,120,253], points := ![131,138,144,155,172,174], inverse := ![14,7,3,15,3,7,3,8,0,8,10,9,7,8,15,0,0,0,5,0,14,9,9,11,1,8,9,0,10,10,0,9,9,0,9,9] } }
theorem leafL_192_0_valid : (leafL_192_0).reject.ValidFor (leafL_192_0).leaf := by decide

noncomputable def leafL_192_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,120,269}, reject := .fullRank { members := ![0,1,17,34,52,71,120,269], points := ![91,96,133,138,140,147], inverse := ![12,4,0,9,10,10,7,1,9,8,8,15,0,0,6,2,4,0,8,12,8,15,1,2,13,13,0,15,15,0,8,8,14,12,2,0] } }
theorem leafL_192_1_valid : (leafL_192_1).reject.ValidFor (leafL_192_1).leaf := by decide

noncomputable def leafL_192_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,121,131}, reject := .fullRank { members := ![0,1,17,34,52,71,121,131], points := ![90,94,101,150,156,168], inverse := ![6,13,6,11,10,13,8,6,0,3,9,4,8,0,8,11,3,8,9,2,5,14,0,0,4,7,3,4,7,3,7,11,12,10,6,12] } }
theorem leafL_192_2_valid : (leafL_192_2).reject.ValidFor (leafL_192_2).leaf := by decide

noncomputable def leafL_192_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,121,144}, reject := .fullRank { members := ![0,1,17,34,52,71,121,144], points := ![83,90,91,106,156,158], inverse := ![1,4,3,11,14,2,3,2,11,4,5,11,6,3,5,0,0,0,15,6,2,5,13,3,0,5,5,0,12,12,11,10,1,0,3,3] } }
theorem leafL_192_3_valid : (leafL_192_3).reject.ValidFor (leafL_192_3).leaf := by decide

noncomputable def leafL_192_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,121,150}, reject := .fullRank { members := ![0,1,17,34,52,71,121,150], points := ![83,90,91,106,131,138], inverse := ![11,7,5,14,6,0,0,14,0,9,0,7,6,3,5,0,0,0,8,7,0,8,8,15,6,7,1,0,12,12,3,3,0,0,3,3] } }
theorem leafL_192_4_valid : (leafL_192_4).reject.ValidFor (leafL_192_4).leaf := by decide

noncomputable def leafL_192_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,121,156}, reject := .fullRank { members := ![0,1,17,34,52,71,121,156], points := ![94,96,101,106,131,133], inverse := ![7,14,15,1,4,2,11,5,1,8,11,12,7,7,2,2,6,6,13,2,9,1,6,1,15,15,6,6,15,15,2,2,9,9,4,4] } }
theorem leafL_192_5_valid : (leafL_192_5).reject.ValidFor (leafL_192_5).leaf := by decide

noncomputable def leafL_192_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,121,166}, reject := .fullRank { members := ![0,1,17,34,52,71,121,166], points := ![83,90,94,106,133,141], inverse := ![7,7,9,14,13,11,15,5,4,9,1,6,14,12,2,0,0,0,0,10,5,8,10,13,12,1,13,0,7,7,13,15,2,0,5,5] } }
theorem leafL_192_6_valid : (leafL_192_6).reject.ValidFor (leafL_192_6).leaf := by decide

noncomputable def leafL_192_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,121,172}, reject := .fullRank { members := ![0,1,17,34,52,71,121,172], points := ![83,90,91,104,106,131], inverse := ![11,7,5,0,14,6,13,8,11,7,14,7,6,3,5,0,0,0,9,12,10,15,7,7,12,5,9,12,12,0,8,10,2,3,3,0] } }
theorem leafL_192_7_valid : (leafL_192_7).reject.ValidFor (leafL_192_7).leaf := by decide

noncomputable def leavesL_192 : List RejectedLeaf := [leafL_192_0,leafL_192_1,leafL_192_2,leafL_192_3,leafL_192_4,leafL_192_5,leafL_192_6,leafL_192_7]

theorem leavesL_192_valid : LeafListValid leavesL_192 := by
  intro x hx
  simp only [leavesL_192, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_192_0_valid
  · exact leafL_192_1_valid
  · exact leafL_192_2_valid
  · exact leafL_192_3_valid
  · exact leafL_192_4_valid
  · exact leafL_192_5_valid
  · exact leafL_192_6_valid
  · exact leafL_192_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
