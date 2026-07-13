import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_188_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,110,156}, reject := .fullRank { members := ![0,1,17,34,52,71,110,156], points := ![83,122,127,131,133,139], inverse := ![7,9,7,7,4,11,7,7,14,13,14,13,0,0,0,11,9,2,7,5,13,1,14,0,0,1,1,10,8,2,0,6,6,12,14,2] } }
theorem leafL_188_0_valid : (leafL_188_0).reject.ValidFor (leafL_188_0).leaf := by decide

noncomputable def leafL_188_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,110,159}, reject := .fullRank { members := ![0,1,17,34,52,71,110,159], points := ![83,93,122,131,133,139], inverse := ![1,6,14,9,0,1,11,12,9,2,6,10,0,0,0,11,9,2,2,5,8,8,8,15,7,7,0,8,3,11,1,1,0,0,1,1] } }
theorem leafL_188_1_valid : (leafL_188_1).reject.ValidFor (leafL_188_1).leaf := by decide

noncomputable def leafL_188_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,110,166}, reject := .fullRank { members := ![0,1,17,34,52,71,110,166], points := ![93,133,139,141,156,159], inverse := ![8,4,10,13,10,0,6,10,11,8,6,9,0,2,9,11,0,0,4,4,2,0,8,10,0,4,3,7,6,6,0,5,1,4,7,7] } }
theorem leafL_188_2_valid : (leafL_188_2).reject.ValidFor (leafL_188_2).leaf := by decide

noncomputable def leafL_188_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,110,168}, reject := .fullRank { members := ![0,1,17,34,52,71,110,168], points := ![91,93,122,131,133,144], inverse := ![12,11,14,5,13,0,13,10,9,13,9,10,0,0,0,15,8,7,11,12,8,10,14,11,2,2,0,1,0,1,12,12,0,12,12,0] } }
theorem leafL_188_3_valid : (leafL_188_3).reject.ValidFor (leafL_188_3).leaf := by decide

noncomputable def leafL_188_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,110,172}, reject := .fullRank { members := ![0,1,17,34,52,71,110,172], points := ![83,91,93,128,131,133], inverse := ![0,7,0,14,0,8,1,6,0,9,13,3,2,11,9,0,0,0,13,1,11,8,1,14,12,13,1,0,5,5,0,12,12,0,12,12] } }
theorem leafL_188_4_valid : (leafL_188_4).reject.ValidFor (leafL_188_4).leaf := by decide

noncomputable def leafL_188_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,110,176}, reject := .fullRank { members := ![0,1,17,34,52,71,110,176], points := ![83,93,127,131,133,139], inverse := ![13,10,14,6,8,6,1,6,9,3,10,7,0,0,0,11,9,2,15,8,8,11,15,11,7,7,0,8,3,11,1,1,0,0,1,1] } }
theorem leafL_188_5_valid : (leafL_188_5).reject.ValidFor (leafL_188_5).leaf := by decide

noncomputable def leafL_188_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,110,182}, reject := .fullRank { members := ![0,1,17,34,52,71,110,182], points := ![91,93,122,127,128,131], inverse := ![3,4,12,0,2,8,2,5,2,3,8,14,0,0,1,6,7,0,5,2,6,4,10,15,9,9,8,7,15,0,10,10,10,0,10,0] } }
theorem leafL_188_6_valid : (leafL_188_6).reject.ValidFor (leafL_188_6).leaf := by decide

noncomputable def leafL_188_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,110,188}, reject := .fullRank { members := ![0,1,17,34,52,71,110,188], points := ![83,91,122,128,131,141], inverse := ![7,0,15,1,15,7,15,8,13,4,0,14,9,9,2,2,11,11,4,3,12,4,6,9,8,8,0,0,4,4,4,4,4,4,4,4] } }
theorem leafL_188_7_valid : (leafL_188_7).reject.ValidFor (leafL_188_7).leaf := by decide

noncomputable def leavesL_188 : List RejectedLeaf := [leafL_188_0,leafL_188_1,leafL_188_2,leafL_188_3,leafL_188_4,leafL_188_5,leafL_188_6,leafL_188_7]

theorem leavesL_188_valid : LeafListValid leavesL_188 := by
  intro x hx
  simp only [leavesL_188, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_188_0_valid
  · exact leafL_188_1_valid
  · exact leafL_188_2_valid
  · exact leafL_188_3_valid
  · exact leafL_188_4_valid
  · exact leafL_188_5_valid
  · exact leafL_188_6_valid
  · exact leafL_188_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
