import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_008_0 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,230}, reject := .fullRank { members := ![0,1,17,34,52,67,91,230], points := ![106,110,121,127,137,138], inverse := ![4,3,4,13,4,11,8,15,5,11,8,1,12,12,3,3,15,15,11,12,13,2,6,14,2,2,15,15,13,13,2,2,14,14,10,10] } }
theorem leafL_008_0_valid : (leafL_008_0).reject.ValidFor (leafL_008_0).leaf := by decide

noncomputable def leafL_008_1 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,239}, reject := .fullRank { members := ![0,1,17,34,52,67,91,239], points := ![106,108,137,141,158,168], inverse := ![4,13,6,11,5,0,9,10,10,0,1,8,14,7,12,11,10,4,6,1,8,15,15,15,15,0,5,0,11,1,12,4,8,1,13,12] } }
theorem leafL_008_1_valid : (leafL_008_1).reject.ValidFor (leafL_008_1).leaf := by decide

noncomputable def leafL_008_2 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,247}, reject := .fullRank { members := ![0,1,17,34,52,67,91,247], points := ![106,108,110,121,127,141], inverse := ![2,15,10,1,8,15,10,10,7,11,5,9,15,10,5,0,0,0,11,10,6,10,5,8,4,7,3,9,9,0,0,12,12,12,12,0] } }
theorem leafL_008_2_valid : (leafL_008_2).reject.ValidFor (leafL_008_2).leaf := by decide

noncomputable def leafL_008_3 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,248}, reject := .fullRank { members := ![0,1,17,34,52,67,91,248], points := ![109,110,121,137,138,143], inverse := ![7,0,9,6,11,2,8,15,14,8,7,6,0,0,0,7,6,1,12,11,15,13,3,6,10,10,0,12,13,1,9,9,0,9,9,0] } }
theorem leafL_008_3_valid : (leafL_008_3).reject.ValidFor (leafL_008_3).leaf := by decide

noncomputable def leafL_008_4 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,254}, reject := .fullRank { members := ![0,1,17,34,52,67,91,254], points := ![106,108,109,138,172,176], inverse := ![5,2,3,7,10,8,2,5,2,8,2,15,12,3,15,0,0,0,5,5,3,10,8,1,13,3,14,0,1,1,3,13,14,0,11,11] } }
theorem leafL_008_4_valid : (leafL_008_4).reject.ValidFor (leafL_008_4).leaf := by decide

noncomputable def leafL_008_5 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,264}, reject := .fullRank { members := ![0,1,17,34,52,67,91,264], points := ![108,110,122,127,138,143], inverse := ![8,15,1,8,13,2,14,9,13,3,2,11,7,7,12,12,10,10,14,9,15,0,0,8,6,6,3,3,4,4,0,0,6,6,6,6] } }
theorem leafL_008_5_valid : (leafL_008_5).reject.ValidFor (leafL_008_5).leaf := by decide

noncomputable def leafL_008_6 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,266}, reject := .fullRank { members := ![0,1,17,34,52,67,91,266], points := ![109,110,141,149,159,168], inverse := ![8,3,2,5,14,3,9,5,15,4,14,9,13,9,13,13,2,6,0,6,9,12,4,7,10,13,12,14,8,13,15,1,11,14,2,9] } }
theorem leafL_008_6_valid : (leafL_008_6).reject.ValidFor (leafL_008_6).leaf := by decide

noncomputable def leafL_008_7 : RejectedLeaf := { leaf := {0,1,17,34,52,67,92,107}, reject := .fullRank { members := ![0,1,17,34,52,67,92,107], points := ![121,138,151,158,173,213], inverse := ![4,6,11,3,9,2,14,12,10,13,10,15,8,1,1,8,15,15,8,15,5,15,14,3,9,5,14,12,13,3,5,5,0,5,5,0] } }
theorem leafL_008_7_valid : (leafL_008_7).reject.ValidFor (leafL_008_7).leaf := by decide

noncomputable def leavesL_008 : List RejectedLeaf := [leafL_008_0,leafL_008_1,leafL_008_2,leafL_008_3,leafL_008_4,leafL_008_5,leafL_008_6,leafL_008_7]

theorem leavesL_008_valid : LeafListValid leavesL_008 := by
  intro x hx
  simp only [leavesL_008, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_008_0_valid
  · exact leafL_008_1_valid
  · exact leafL_008_2_valid
  · exact leafL_008_3_valid
  · exact leafL_008_4_valid
  · exact leafL_008_5_valid
  · exact leafL_008_6_valid
  · exact leafL_008_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
