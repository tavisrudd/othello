import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_305_0 : RejectedLeaf := { leaf := {0,1,17,34,52,74,141,181}, reject := .fullRank { members := ![0,1,17,34,52,74,141,181], points := ![83,86,89,108,110,120], inverse := ![5,11,1,0,8,6,14,6,1,1,15,7,14,11,5,0,0,0,7,7,8,4,11,7,12,3,15,15,15,0,8,13,5,7,7,0] } }
theorem leafL_305_0_valid : (leafL_305_0).reject.ValidFor (leafL_305_0).leaf := by decide

noncomputable def leafL_305_1 : RejectedLeaf := { leaf := {0,1,17,34,52,74,141,182}, reject := .fullRank { members := ![0,1,17,34,52,74,141,182], points := ![95,101,110,112,117,124], inverse := ![15,5,3,14,10,12,9,6,9,1,12,11,0,10,1,11,0,0,8,2,9,4,11,12,0,9,7,14,11,11,0,8,13,5,9,9] } }
theorem leafL_305_1_valid : (leafL_305_1).reject.ValidFor (leafL_305_1).leaf := by decide

noncomputable def leafL_305_2 : RejectedLeaf := { leaf := {0,1,17,34,52,74,141,216}, reject := .fullRank { members := ![0,1,17,34,52,74,141,216], points := ![83,86,89,101,110,117], inverse := ![2,6,11,14,6,6,2,4,15,14,0,7,14,11,5,0,0,0,7,1,14,7,8,7,11,15,4,8,8,0,13,14,3,2,2,0] } }
theorem leafL_305_2_valid : (leafL_305_2).reject.ValidFor (leafL_305_2).leaf := by decide

noncomputable def leafL_305_3 : RejectedLeaf := { leaf := {0,1,17,34,52,74,141,220}, reject := .fullRank { members := ![0,1,17,34,52,74,141,220], points := ![86,95,101,110,120,147], inverse := ![11,3,3,10,4,4,9,13,7,1,4,6,3,9,8,1,1,2,12,14,13,11,6,2,7,10,3,11,3,6,3,4,1,0,2,4] } }
theorem leafL_305_3_valid : (leafL_305_3).reject.ValidFor (leafL_305_3).leaf := by decide

noncomputable def leafL_305_4 : RejectedLeaf := { leaf := {0,1,17,34,52,74,141,239}, reject := .fullRank { members := ![0,1,17,34,52,74,141,239], points := ![86,108,112,117,151,163], inverse := ![15,7,3,2,6,14,9,0,10,10,2,11,6,3,8,10,9,14,10,1,12,7,2,2,14,1,2,10,1,6,1,0,12,10,14,9] } }
theorem leafL_305_4_valid : (leafL_305_4).reject.ValidFor (leafL_305_4).leaf := by decide

noncomputable def leafL_305_5 : RejectedLeaf := { leaf := {0,1,17,34,52,74,144,147}, reject := .fullRank { members := ![0,1,17,34,52,74,144,147], points := ![86,110,117,169,173,174], inverse := ![15,8,6,6,2,4,1,5,6,4,12,10,0,0,0,6,13,11,4,8,15,9,3,9,3,5,2,13,7,14,6,10,4,5,5,8] } }
theorem leafL_305_5_valid : (leafL_305_5).reject.ValidFor (leafL_305_5).leaf := by decide

noncomputable def leafL_305_6 : RejectedLeaf := { leaf := {0,1,17,34,52,74,144,222}, reject := .fullRank { members := ![0,1,17,34,52,74,144,222], points := ![93,95,107,108,121,147], inverse := ![4,8,14,12,1,14,3,4,15,3,3,8,14,15,1,7,12,11,6,6,2,8,13,7,0,14,10,8,4,8,8,11,2,8,7,14] } }
theorem leafL_305_6_valid : (leafL_305_6).reject.ValidFor (leafL_305_6).leaf := by decide

noncomputable def leafL_305_7 : RejectedLeaf := { leaf := {0,1,17,34,52,74,147,203}, reject := .fullRank { members := ![0,1,17,34,52,74,147,203], points := ![89,92,103,108,128,133], inverse := ![7,14,11,5,0,6,1,9,15,0,6,1,14,15,14,15,1,1,0,1,12,10,14,9,8,6,8,6,14,14,5,11,15,1,14,14] } }
theorem leafL_305_7_valid : (leafL_305_7).reject.ValidFor (leafL_305_7).leaf := by decide

noncomputable def leavesL_305 : List RejectedLeaf := [leafL_305_0,leafL_305_1,leafL_305_2,leafL_305_3,leafL_305_4,leafL_305_5,leafL_305_6,leafL_305_7]

theorem leavesL_305_valid : LeafListValid leavesL_305 := by
  intro x hx
  simp only [leavesL_305, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_305_0_valid
  · exact leafL_305_1_valid
  · exact leafL_305_2_valid
  · exact leafL_305_3_valid
  · exact leafL_305_4_valid
  · exact leafL_305_5_valid
  · exact leafL_305_6_valid
  · exact leafL_305_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
