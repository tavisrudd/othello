import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_234_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,188,240}, reject := .fullRank { members := ![0,1,17,34,52,71,188,240], points := ![90,94,104,106,110,122], inverse := ![9,6,11,8,11,6,9,0,0,14,0,7,0,0,7,4,3,0,7,15,0,0,15,7,12,12,15,2,13,0,13,13,0,13,13,0] } }
theorem leafL_234_0_valid : (leafL_234_0).reject.ValidFor (leafL_234_0).leaf := by decide

noncomputable def leafL_234_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,188,243}, reject := .fullRank { members := ![0,1,17,34,52,71,188,243], points := ![90,94,104,106,128,138], inverse := ![6,9,7,15,6,0,14,0,0,9,0,7,14,10,15,11,4,4,3,11,14,1,7,0,10,4,0,14,14,14,11,5,15,1,14,14] } }
theorem leafL_234_1_valid : (leafL_234_1).reject.ValidFor (leafL_234_1).leaf := by decide

noncomputable def leafL_234_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,188,267}, reject := .fullRank { members := ![0,1,17,34,52,71,188,267], points := ![94,104,106,122,128,141], inverse := ![10,14,3,15,12,5,13,5,15,11,8,4,15,7,8,6,9,15,3,3,7,14,2,11,6,14,8,4,2,6,14,11,5,15,1,14] } }
theorem leafL_234_2_valid : (leafL_234_2).reject.ValidFor (leafL_234_2).leaf := by decide

noncomputable def leafL_234_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,191,197}, reject := .fullRank { members := ![0,1,17,34,52,71,191,197], points := ![90,92,94,106,110,120], inverse := ![0,15,0,0,8,6,3,10,0,8,6,7,15,10,5,0,0,0,13,10,15,6,9,7,5,14,11,1,1,0,13,0,13,13,13,0] } }
theorem leafL_234_3_valid : (leafL_234_3).reject.ValidFor (leafL_234_3).leaf := by decide

noncomputable def leafL_234_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,191,208}, reject := .fullRank { members := ![0,1,17,34,52,71,191,208], points := ![90,94,106,121,126,133], inverse := ![4,1,2,14,2,10,1,5,3,4,14,13,12,14,2,13,15,2,13,1,11,12,15,4,10,6,12,13,1,12,9,8,1,3,2,1] } }
theorem leafL_234_4_valid : (leafL_234_4).reject.ValidFor (leafL_234_4).leaf := by decide

noncomputable def leafL_234_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,191,216}, reject := .fullRank { members := ![0,1,17,34,52,71,191,216], points := ![90,91,101,106,110,126], inverse := ![12,3,13,10,15,6,6,15,9,14,9,7,0,0,8,1,9,0,0,8,6,10,3,7,3,3,10,13,7,0,14,14,13,10,7,0] } }
theorem leafL_234_5_valid : (leafL_234_5).reject.ValidFor (leafL_234_5).leaf := by decide

noncomputable def leafL_234_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,191,217}, reject := .fullRank { members := ![0,1,17,34,52,71,191,217], points := ![91,94,99,101,110,120], inverse := ![11,4,1,13,4,6,13,4,8,14,8,7,0,0,13,14,3,0,5,13,3,1,13,7,13,13,11,14,5,0,6,6,10,9,3,0] } }
theorem leafL_234_6_valid : (leafL_234_6).reject.ValidFor (leafL_234_6).leaf := by decide

noncomputable def leafL_234_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,191,259}, reject := .fullRank { members := ![0,1,17,34,52,71,191,259], points := ![90,92,94,110,120,121], inverse := ![0,15,0,8,6,0,10,12,15,14,12,11,15,10,5,0,0,0,15,1,6,15,13,10,11,10,1,0,3,3,7,1,6,0,4,4] } }
theorem leafL_234_7_valid : (leafL_234_7).reject.ValidFor (leafL_234_7).leaf := by decide

noncomputable def leavesL_234 : List RejectedLeaf := [leafL_234_0,leafL_234_1,leafL_234_2,leafL_234_3,leafL_234_4,leafL_234_5,leafL_234_6,leafL_234_7]

theorem leavesL_234_valid : LeafListValid leavesL_234 := by
  intro x hx
  simp only [leavesL_234, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_234_0_valid
  · exact leafL_234_1_valid
  · exact leafL_234_2_valid
  · exact leafL_234_3_valid
  · exact leafL_234_4_valid
  · exact leafL_234_5_valid
  · exact leafL_234_6_valid
  · exact leafL_234_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
