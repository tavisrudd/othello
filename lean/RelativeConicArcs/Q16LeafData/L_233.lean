import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_233_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,188,205}, reject := .fullRank { members := ![0,1,17,34,52,71,188,205], points := ![90,91,94,104,106,131], inverse := ![5,10,6,0,14,6,3,3,14,7,14,7,10,2,8,0,0,0,9,9,15,15,7,7,4,7,3,12,12,0,5,7,2,3,3,0] } }
theorem leafL_233_0_valid : (leafL_233_0).reject.ValidFor (leafL_233_0).leaf := by decide

noncomputable def leafL_233_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,188,213}, reject := .fullRank { members := ![0,1,17,34,52,71,188,213], points := ![83,91,104,110,128,131], inverse := ![7,3,9,10,13,11,15,14,1,7,15,8,14,11,3,6,5,5,12,6,4,9,5,2,6,6,5,5,0,0,0,10,10,0,10,10] } }
theorem leafL_233_1_valid : (leafL_233_1).reject.ValidFor (leafL_233_1).leaf := by decide

noncomputable def leafL_233_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,188,214}, reject := .fullRank { members := ![0,1,17,34,52,71,188,214], points := ![90,94,122,128,131,138], inverse := ![6,1,15,1,1,9,7,0,9,0,0,14,12,12,11,11,4,4,15,8,1,9,2,13,4,4,14,14,0,0,3,3,1,1,4,4] } }
theorem leafL_233_2_valid : (leafL_233_2).reject.ValidFor (leafL_233_2).leaf := by decide

noncomputable def leafL_233_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,188,216}, reject := .fullRank { members := ![0,1,17,34,52,71,188,216], points := ![83,90,91,106,110,122], inverse := ![15,9,9,1,9,6,0,9,0,14,0,7,6,3,5,0,0,0,9,2,3,0,15,7,14,4,10,1,1,0,1,7,6,13,13,0] } }
theorem leafL_233_3_valid : (leafL_233_3).reject.ValidFor (leafL_233_3).leaf := by decide

noncomputable def leafL_233_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,188,218}, reject := .fullRank { members := ![0,1,17,34,52,71,188,218], points := ![83,91,94,104,110,141], inverse := ![10,14,13,13,3,6,14,15,15,6,15,7,1,4,5,0,0,0,0,10,5,5,13,7,6,6,0,5,5,0,13,7,10,12,12,0] } }
theorem leafL_233_4_valid : (leafL_233_4).reject.ValidFor (leafL_233_4).leaf := by decide

noncomputable def leafL_233_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,188,223}, reject := .fullRank { members := ![0,1,17,34,52,71,188,223], points := ![90,94,96,104,106,122], inverse := ![7,7,15,6,14,6,9,0,0,0,14,7,5,15,10,0,0,0,5,9,4,8,7,7,8,0,8,12,12,0,9,1,8,3,3,0] } }
theorem leafL_233_5_valid : (leafL_233_5).reject.ValidFor (leafL_233_5).leaf := by decide

noncomputable def leafL_233_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,188,232}, reject := .fullRank { members := ![0,1,17,34,52,71,188,232], points := ![83,94,106,110,138,141], inverse := ![8,1,4,10,12,10,9,7,15,6,0,7,4,4,1,1,6,6,0,15,7,15,7,0,9,9,4,4,13,13,2,2,6,6,15,15] } }
theorem leafL_233_6_valid : (leafL_233_6).reject.ValidFor (leafL_233_6).leaf := by decide

noncomputable def leafL_233_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,188,233}, reject := .fullRank { members := ![0,1,17,34,52,71,188,233], points := ![90,91,96,106,128,138], inverse := ![7,9,0,9,7,1,14,0,0,9,0,7,12,8,4,0,0,0,15,0,5,13,5,2,9,5,2,14,14,14,0,0,10,10,10,10] } }
theorem leafL_233_7_valid : (leafL_233_7).reject.ValidFor (leafL_233_7).leaf := by decide

noncomputable def leavesL_233 : List RejectedLeaf := [leafL_233_0,leafL_233_1,leafL_233_2,leafL_233_3,leafL_233_4,leafL_233_5,leafL_233_6,leafL_233_7]

theorem leavesL_233_valid : LeafListValid leavesL_233 := by
  intro x hx
  simp only [leavesL_233, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_233_0_valid
  · exact leafL_233_1_valid
  · exact leafL_233_2_valid
  · exact leafL_233_3_valid
  · exact leafL_233_4_valid
  · exact leafL_233_5_valid
  · exact leafL_233_6_valid
  · exact leafL_233_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
