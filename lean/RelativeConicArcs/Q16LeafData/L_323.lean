import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_323_0 : RejectedLeaf := { leaf := {0,1,17,34,52,79,107,216}, reject := .fullRank { members := ![0,1,17,34,52,79,107,216], points := ![96,117,124,131,137,154], inverse := ![2,13,8,10,10,6,5,13,5,6,6,13,14,12,11,10,6,5,2,12,15,9,14,6,15,6,8,9,2,10,3,1,9,8,1,2] } }
theorem leafL_323_0_valid : (leafL_323_0).reject.ValidFor (leafL_323_0).leaf := by decide

noncomputable def leafL_323_1 : RejectedLeaf := { leaf := {0,1,17,34,52,79,125,139}, reject := .fullRank { members := ![0,1,17,34,52,79,125,139], points := ![86,101,106,110,154,156], inverse := ![6,13,12,10,6,10,10,11,11,4,12,2,0,8,1,9,0,0,11,12,7,14,6,8,0,14,13,3,10,10,0,7,10,13,2,2] } }
theorem leafL_323_1_valid : (leafL_323_1).reject.ValidFor (leafL_323_1).leaf := by decide

noncomputable def leafL_323_2 : RejectedLeaf := { leaf := {0,1,17,34,52,79,125,208}, reject := .fullRank { members := ![0,1,17,34,52,79,125,208], points := ![90,94,101,106,135,137], inverse := ![4,13,1,15,5,3,8,6,15,6,14,9,13,13,6,6,8,8,8,7,5,13,12,11,4,4,4,4,5,5,2,2,7,7,4,4] } }
theorem leafL_323_2_valid : (leafL_323_2).reject.ValidFor (leafL_323_2).leaf := by decide

noncomputable def leafL_323_3 : RejectedLeaf := { leaf := {0,1,17,34,52,79,168,243}, reject := .fullRank { members := ![0,1,17,34,52,79,168,243], points := ![86,89,93,107,112,117], inverse := ![11,11,15,10,2,6,10,13,14,7,9,7,8,1,9,0,0,0,15,8,15,4,11,7,0,12,12,10,10,0,8,12,4,11,11,0] } }
theorem leafL_323_3_valid : (leafL_323_3).reject.ValidFor (leafL_323_3).leaf := by decide

noncomputable def leafL_323_4 : RejectedLeaf := { leaf := {0,1,17,34,52,80,91,188}, reject := .fullRank { members := ![0,1,17,34,52,80,91,188], points := ![103,110,115,117,122,141], inverse := ![9,14,13,14,10,15,8,15,12,13,15,9,0,0,8,15,7,0,15,8,2,15,2,8,10,10,8,3,11,0,3,3,3,0,3,0] } }
theorem leafL_323_4_valid : (leafL_323_4).reject.ValidFor (leafL_323_4).leaf := by decide

noncomputable def leafL_323_5 : RejectedLeaf := { leaf := {0,1,17,34,52,80,91,191}, reject := .fullRank { members := ![0,1,17,34,52,80,91,191], points := ![101,106,108,115,117,138], inverse := ![3,15,11,6,15,15,12,3,8,3,13,9,6,2,4,0,0,0,15,8,0,0,15,8,2,14,12,9,9,0,8,14,6,12,12,0] } }
theorem leafL_323_5_valid : (leafL_323_5).reject.ValidFor (leafL_323_5).leaf := by decide

noncomputable def leafL_323_6 : RejectedLeaf := { leaf := {0,1,17,34,52,80,91,248}, reject := .fullRank { members := ![0,1,17,34,52,80,91,248], points := ![101,109,110,117,121,135], inverse := ![11,4,8,11,2,15,6,7,6,2,12,9,13,15,2,0,0,0,14,1,8,3,12,8,12,4,8,13,13,0,11,2,9,6,6,0] } }
theorem leafL_323_6_valid : (leafL_323_6).reject.ValidFor (leafL_323_6).leaf := by decide

noncomputable def leafL_323_7 : RejectedLeaf := { leaf := {0,1,17,34,52,80,107,154}, reject := .fullRank { members := ![0,1,17,34,52,80,107,154], points := ![92,117,124,127,131,133], inverse := ![7,13,13,14,12,4,7,2,13,6,8,6,0,10,7,13,0,0,7,2,5,15,7,8,0,12,15,3,1,1,0,13,2,15,7,7] } }
theorem leafL_323_7_valid : (leafL_323_7).reject.ValidFor (leafL_323_7).leaf := by decide

noncomputable def leavesL_323 : List RejectedLeaf := [leafL_323_0,leafL_323_1,leafL_323_2,leafL_323_3,leafL_323_4,leafL_323_5,leafL_323_6,leafL_323_7]

theorem leavesL_323_valid : LeafListValid leavesL_323 := by
  intro x hx
  simp only [leavesL_323, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_323_0_valid
  · exact leafL_323_1_valid
  · exact leafL_323_2_valid
  · exact leafL_323_3_valid
  · exact leafL_323_4_valid
  · exact leafL_323_5_valid
  · exact leafL_323_6_valid
  · exact leafL_323_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
