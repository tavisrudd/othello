import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_206_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,144,159}, reject := .fullRank { members := ![0,1,17,34,52,71,144,159], points := ![83,93,106,110,121,122], inverse := ![8,7,14,6,13,11,13,4,9,7,14,9,6,6,14,14,15,15,1,9,10,5,7,0,15,15,1,1,0,0,10,10,11,11,12,12] } }
theorem leafL_206_0_valid : (leafL_206_0).reject.ValidFor (leafL_206_0).leaf := by decide

noncomputable def leafL_206_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,144,168}, reject := .fullRank { members := ![0,1,17,34,52,71,144,168], points := ![90,91,93,106,109,121], inverse := ![6,3,10,0,8,6,4,8,5,6,8,7,8,12,4,0,0,0,9,8,9,11,4,7,15,9,6,10,10,0,11,0,11,11,11,0] } }
theorem leafL_206_1_valid : (leafL_206_1).reject.ValidFor (leafL_206_1).leaf := by decide

noncomputable def leafL_206_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,144,181}, reject := .fullRank { members := ![0,1,17,34,52,71,144,181], points := ![91,109,120,121,127,147], inverse := ![0,12,0,14,0,3,6,10,8,11,12,3,0,0,3,13,14,0,7,11,8,10,13,3,15,4,6,15,1,3,11,15,2,0,15,9] } }
theorem leafL_206_2_valid : (leafL_206_2).reject.ValidFor (leafL_206_2).leaf := by decide

noncomputable def leafL_206_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,144,182}, reject := .fullRank { members := ![0,1,17,34,52,71,144,182], points := ![91,93,106,110,121,122], inverse := ![5,10,1,9,0,6,8,1,2,12,11,12,7,7,7,7,14,14,6,14,0,15,0,7,4,4,13,13,11,11,9,9,3,3,15,15] } }
theorem leafL_206_3_valid : (leafL_206_3).reject.ValidFor (leafL_206_3).leaf := by decide

noncomputable def leafL_206_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,144,186}, reject := .fullRank { members := ![0,1,17,34,52,71,144,186], points := ![91,93,121,127,155,156], inverse := ![12,14,4,1,2,4,7,2,15,7,3,14,7,7,6,6,6,6,0,3,0,10,13,4,8,8,9,9,7,7,10,10,10,10,0,0] } }
theorem leafL_206_4_valid : (leafL_206_4).reject.ValidFor (leafL_206_4).leaf := by decide

noncomputable def leafL_206_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,144,188}, reject := .fullRank { members := ![0,1,17,34,52,71,144,188], points := ![83,90,110,122,159,174], inverse := ![1,5,3,6,11,11,10,13,14,12,9,12,11,3,2,6,13,1,3,2,0,5,10,14,10,8,4,2,1,5,8,4,13,14,5,10] } }
theorem leafL_206_5_valid : (leafL_206_5).reject.ValidFor (leafL_206_5).leaf := by decide

noncomputable def leafL_206_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,144,197}, reject := .fullRank { members := ![0,1,17,34,52,71,144,197], points := ![83,93,106,109,110,120], inverse := ![14,1,14,13,11,6,7,14,7,9,0,7,0,0,6,11,13,0,0,8,2,3,14,7,15,15,1,0,1,0,3,3,4,2,6,0] } }
theorem leafL_206_6_valid : (leafL_206_6).reject.ValidFor (leafL_206_6).leaf := by decide

noncomputable def leafL_206_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,144,213}, reject := .fullRank { members := ![0,1,17,34,52,71,144,213], points := ![83,91,121,126,147,155], inverse := ![4,6,9,12,10,12,8,13,3,11,5,8,3,3,10,10,10,10,11,8,7,13,8,1,1,1,15,15,10,10,12,12,0,0,12,12] } }
theorem leafL_206_7_valid : (leafL_206_7).reject.ValidFor (leafL_206_7).leaf := by decide

noncomputable def leavesL_206 : List RejectedLeaf := [leafL_206_0,leafL_206_1,leafL_206_2,leafL_206_3,leafL_206_4,leafL_206_5,leafL_206_6,leafL_206_7]

theorem leavesL_206_valid : LeafListValid leavesL_206 := by
  intro x hx
  simp only [leavesL_206, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_206_0_valid
  · exact leafL_206_1_valid
  · exact leafL_206_2_valid
  · exact leafL_206_3_valid
  · exact leafL_206_4_valid
  · exact leafL_206_5_valid
  · exact leafL_206_6_valid
  · exact leafL_206_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
