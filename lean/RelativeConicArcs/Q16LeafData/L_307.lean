import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_307_0 : RejectedLeaf := { leaf := {0,1,17,34,52,74,159,176}, reject := .fullRank { members := ![0,1,17,34,52,74,159,176], points := ![89,92,93,101,104,115], inverse := ![4,14,5,2,10,6,0,1,8,1,15,7,10,2,8,0,0,0,7,11,4,13,2,7,14,5,11,13,13,0,14,14,0,14,14,0] } }
theorem leafL_307_0_valid : (leafL_307_0).reject.ValidFor (leafL_307_0).leaf := by decide

noncomputable def leafL_307_1 : RejectedLeaf := { leaf := {0,1,17,34,52,74,159,182}, reject := .fullRank { members := ![0,1,17,34,52,74,159,182], points := ![92,93,101,104,112,115], inverse := ![4,11,13,8,13,6,1,8,1,15,0,7,0,0,3,5,6,0,15,7,11,8,12,7,13,13,1,10,11,0,6,6,2,9,11,0] } }
theorem leafL_307_1_valid : (leafL_307_1).reject.ValidFor (leafL_307_1).leaf := by decide

noncomputable def leafL_307_2 : RejectedLeaf := { leaf := {0,1,17,34,52,74,159,205}, reject := .fullRank { members := ![0,1,17,34,52,74,159,205], points := ![86,101,104,112,163,169], inverse := ![10,4,3,0,5,9,4,0,1,11,1,15,0,3,5,6,0,0,5,2,2,11,4,10,0,0,6,6,5,5,0,9,4,13,1,1] } }
theorem leafL_307_2_valid : (leafL_307_2).reject.ValidFor (leafL_307_2).leaf := by decide

noncomputable def leafL_307_3 : RejectedLeaf := { leaf := {0,1,17,34,52,74,159,259}, reject := .fullRank { members := ![0,1,17,34,52,74,159,259], points := ![86,92,104,108,110,121], inverse := ![7,8,8,6,6,6,11,2,7,0,9,7,0,0,1,3,2,0,5,13,0,12,3,7,15,15,8,4,12,0,3,3,8,12,4,0] } }
theorem leafL_307_3_valid : (leafL_307_3).reject.ValidFor (leafL_307_3).leaf := by decide

noncomputable def leafL_307_4 : RejectedLeaf := { leaf := {0,1,17,34,52,74,172,232}, reject := .fullRank { members := ![0,1,17,34,52,74,172,232], points := ![83,86,93,107,110,115], inverse := ![1,2,12,3,11,6,15,4,2,13,3,7,10,12,6,0,0,0,8,4,4,5,10,7,14,15,1,11,11,0,6,6,0,6,6,0] } }
theorem leafL_307_4_valid : (leafL_307_4).reject.ValidFor (leafL_307_4).leaf := by decide

noncomputable def leafL_307_5 : RejectedLeaf := { leaf := {0,1,17,34,52,74,173,220}, reject := .fullRank { members := ![0,1,17,34,52,74,173,220], points := ![86,95,101,103,110,117], inverse := ![1,14,13,14,11,6,2,11,11,1,4,7,0,0,1,11,10,0,1,9,0,4,11,7,2,2,11,14,5,0,5,5,0,5,5,0] } }
theorem leafL_307_5_valid : (leafL_307_5).reject.ValidFor (leafL_307_5).leaf := by decide

noncomputable def leafL_307_6 : RejectedLeaf := { leaf := {0,1,17,34,52,74,176,182}, reject := .fullRank { members := ![0,1,17,34,52,74,176,182], points := ![92,93,95,101,104,115], inverse := ![2,4,9,2,10,6,1,8,0,1,15,7,15,3,12,0,0,0,2,1,11,13,2,7,4,1,5,13,13,0,15,10,5,14,14,0] } }
theorem leafL_307_6_valid : (leafL_307_6).reject.ValidFor (leafL_307_6).leaf := by decide

noncomputable def leafL_307_7 : RejectedLeaf := { leaf := {0,1,17,34,52,74,176,247}, reject := .fullRank { members := ![0,1,17,34,52,74,176,247], points := ![83,93,104,110,120,124], inverse := ![8,7,3,11,10,12,10,3,1,15,14,9,9,9,13,13,1,1,10,2,8,7,0,7,0,0,11,11,13,13,1,1,13,13,4,4] } }
theorem leafL_307_7_valid : (leafL_307_7).reject.ValidFor (leafL_307_7).leaf := by decide

noncomputable def leavesL_307 : List RejectedLeaf := [leafL_307_0,leafL_307_1,leafL_307_2,leafL_307_3,leafL_307_4,leafL_307_5,leafL_307_6,leafL_307_7]

theorem leavesL_307_valid : LeafListValid leavesL_307 := by
  intro x hx
  simp only [leavesL_307, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_307_0_valid
  · exact leafL_307_1_valid
  · exact leafL_307_2_valid
  · exact leafL_307_3_valid
  · exact leafL_307_4_valid
  · exact leafL_307_5_valid
  · exact leafL_307_6_valid
  · exact leafL_307_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
