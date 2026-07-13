import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_160_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,110}, reject := .fullRank { members := ![0,1,17,34,52,71,91,110], points := ![122,127,141,144,147,168], inverse := ![14,7,0,3,6,13,2,5,9,5,15,4,15,8,13,10,7,7,10,7,11,13,4,15,9,11,1,3,2,2,15,0,15,0,15,15] } }
theorem leafL_160_0_valid : (leafL_160_0).reject.ValidFor (leafL_160_0).leaf := by decide

noncomputable def leafL_160_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,120}, reject := .fullRank { members := ![0,1,17,34,52,71,91,120], points := ![99,109,138,144,158,172], inverse := ![13,7,10,6,12,11,4,11,7,9,3,2,10,6,4,0,2,10,0,9,8,4,3,6,8,14,6,4,1,5,6,3,9,10,8,14] } }
theorem leafL_160_1_valid : (leafL_160_1).reject.ValidFor (leafL_160_1).leaf := by decide

noncomputable def leafL_160_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,144}, reject := .fullRank { members := ![0,1,17,34,52,71,91,144], points := ![109,110,120,121,122,147], inverse := ![12,0,0,14,0,3,7,10,8,2,11,12,0,0,11,8,3,0,3,9,6,11,0,7,2,2,11,11,0,0,14,14,0,14,14,0] } }
theorem leafL_160_2_valid : (leafL_160_2).reject.ValidFor (leafL_160_2).leaf := by decide

noncomputable def leafL_160_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,147}, reject := .fullRank { members := ![0,1,17,34,52,71,91,147], points := ![106,110,122,141,144,168], inverse := ![15,5,12,15,15,7,1,4,0,4,12,13,5,6,9,14,6,2,1,15,5,5,0,14,11,11,0,8,8,0,11,6,5,1,14,7] } }
theorem leafL_160_3_valid : (leafL_160_3).reject.ValidFor (leafL_160_3).leaf := by decide

noncomputable def leafL_160_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,150}, reject := .fullRank { members := ![0,1,17,34,52,71,91,150], points := ![106,109,121,122,138,141], inverse := ![12,11,8,1,15,0,7,0,0,14,9,0,3,3,13,13,5,5,1,6,0,15,14,6,13,13,12,12,11,11,12,12,0,0,12,12] } }
theorem leafL_160_4_valid : (leafL_160_4).reject.ValidFor (leafL_160_4).leaf := by decide

noncomputable def leafL_160_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,154}, reject := .fullRank { members := ![0,1,17,34,52,71,91,154], points := ![99,109,127,144,172,181], inverse := ![6,0,0,0,11,12,3,15,5,9,11,11,13,3,15,10,2,9,11,1,12,14,9,1,12,11,13,8,6,4,1,12,7,8,12,14] } }
theorem leafL_160_5_valid : (leafL_160_5).reject.ValidFor (leafL_160_5).leaf := by decide

noncomputable def leafL_160_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,158}, reject := .fullRank { members := ![0,1,17,34,52,71,91,158], points := ![99,104,120,121,122,138], inverse := ![6,1,6,10,5,15,13,10,6,2,10,9,0,0,11,8,3,0,9,14,5,4,14,8,5,5,12,7,11,0,8,8,6,12,10,0] } }
theorem leafL_160_6_valid : (leafL_160_6).reject.ValidFor (leafL_160_6).leaf := by decide

noncomputable def leafL_160_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,91,172}, reject := .fullRank { members := ![0,1,17,34,52,71,91,172], points := ![104,106,110,120,121,138], inverse := ![11,3,15,8,1,15,4,13,14,9,7,9,7,4,3,0,0,0,7,6,6,12,3,8,3,7,4,11,11,0,13,12,1,9,9,0] } }
theorem leafL_160_7_valid : (leafL_160_7).reject.ValidFor (leafL_160_7).leaf := by decide

noncomputable def leavesL_160 : List RejectedLeaf := [leafL_160_0,leafL_160_1,leafL_160_2,leafL_160_3,leafL_160_4,leafL_160_5,leafL_160_6,leafL_160_7]

theorem leavesL_160_valid : LeafListValid leavesL_160 := by
  intro x hx
  simp only [leavesL_160, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_160_0_valid
  · exact leafL_160_1_valid
  · exact leafL_160_2_valid
  · exact leafL_160_3_valid
  · exact leafL_160_4_valid
  · exact leafL_160_5_valid
  · exact leafL_160_6_valid
  · exact leafL_160_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
