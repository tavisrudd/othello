import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_068_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,127}, reject := .fullRank { members := ![0,1,17,34,52,69,107,127], points := ![92,94,96,137,138,151], inverse := ![2,1,11,10,9,10,2,12,8,14,7,15,5,10,15,0,0,0,3,6,1,6,0,2,13,15,2,13,13,0,5,13,8,14,14,0] } }
theorem leafL_068_0_valid : (leafL_068_0).reject.ValidFor (leafL_068_0).leaf := by decide

noncomputable def leafL_068_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,131}, reject := .fullRank { members := ![0,1,17,34,52,69,107,131], points := ![92,94,96,120,150,151], inverse := ![2,0,0,5,6,0,6,11,8,8,10,7,5,10,15,0,0,0,0,4,7,10,6,15,9,15,6,0,11,11,4,13,9,0,6,6] } }
theorem leafL_068_1_valid : (leafL_068_1).reject.ValidFor (leafL_068_1).leaf := by decide

noncomputable def leafL_068_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,137}, reject := .fullRank { members := ![0,1,17,34,52,69,107,137], points := ![95,96,120,127,150,156], inverse := ![7,5,0,5,10,12,12,9,7,15,2,15,2,2,15,15,7,7,12,15,7,13,1,8,7,7,9,9,14,14,1,1,8,8,15,15] } }
theorem leafL_068_2_valid : (leafL_068_2).reject.ValidFor (leafL_068_2).leaf := by decide

noncomputable def leafL_068_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,138}, reject := .fullRank { members := ![0,1,17,34,52,69,107,138], points := ![86,92,95,115,127,150], inverse := ![15,12,1,2,7,6,1,2,6,3,11,13,15,14,1,0,0,0,14,6,11,5,15,9,9,3,10,7,7,0,7,6,1,5,5,0] } }
theorem leafL_068_3_valid : (leafL_068_3).reject.ValidFor (leafL_068_3).leaf := by decide

noncomputable def leafL_068_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,150}, reject := .fullRank { members := ![0,1,17,34,52,69,107,150], points := ![94,95,122,124,131,137], inverse := ![6,1,1,15,0,8,11,12,5,12,3,13,7,7,4,4,12,12,0,7,0,8,1,14,6,6,5,5,12,12,13,13,15,15,6,6] } }
theorem leafL_068_4_valid : (leafL_068_4).reject.ValidFor (leafL_068_4).leaf := by decide

noncomputable def leafL_068_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,151}, reject := .fullRank { members := ![0,1,17,34,52,69,107,151], points := ![86,92,94,115,120,131], inverse := ![3,1,5,4,10,8,11,2,14,9,0,14,2,9,11,0,0,0,13,13,7,3,11,15,0,9,9,5,5,0,3,14,13,12,12,0] } }
theorem leafL_068_5_valid : (leafL_068_5).reject.ValidFor (leafL_068_5).leaf := by decide

noncomputable def leafL_068_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,152}, reject := .fullRank { members := ![0,1,17,34,52,69,107,152], points := ![86,94,124,127,131,138], inverse := ![7,0,0,14,8,0,15,8,9,0,6,8,14,14,7,7,5,5,8,15,11,3,6,9,12,12,2,2,5,5,11,11,7,7,6,6] } }
theorem leafL_068_6_valid : (leafL_068_6).reject.ValidFor (leafL_068_6).leaf := by decide

noncomputable def leafL_068_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,107,163}, reject := .fullRank { members := ![0,1,17,34,52,69,107,163], points := ![94,96,122,127,137,150], inverse := ![7,3,1,7,1,2,7,8,0,13,3,1,12,7,13,1,4,3,9,13,1,1,6,2,2,5,14,4,6,11,0,9,5,8,10,14] } }
theorem leafL_068_7_valid : (leafL_068_7).reject.ValidFor (leafL_068_7).leaf := by decide

noncomputable def leavesL_068 : List RejectedLeaf := [leafL_068_0,leafL_068_1,leafL_068_2,leafL_068_3,leafL_068_4,leafL_068_5,leafL_068_6,leafL_068_7]

theorem leavesL_068_valid : LeafListValid leavesL_068 := by
  intro x hx
  simp only [leavesL_068, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_068_0_valid
  · exact leafL_068_1_valid
  · exact leafL_068_2_valid
  · exact leafL_068_3_valid
  · exact leafL_068_4_valid
  · exact leafL_068_5_valid
  · exact leafL_068_6_valid
  · exact leafL_068_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
