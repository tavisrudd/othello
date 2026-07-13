import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_289_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,233,267}, reject := .fullRank { members := ![0,1,17,34,52,72,233,267], points := ![93,94,99,101,112,115], inverse := ![0,15,2,15,5,6,14,7,13,7,4,7,0,0,15,8,7,0,3,11,1,14,0,7,5,5,10,6,12,0,1,1,12,10,6,0] } }
theorem leafL_289_0_valid : (leafL_289_0).reject.ValidFor (leafL_289_0).leaf := by decide

noncomputable def leafL_289_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,233,270}, reject := .fullRank { members := ![0,1,17,34,52,72,233,270], points := ![93,96,101,117,124,128], inverse := ![5,10,8,1,3,4,4,13,14,1,7,1,0,0,0,14,2,12,3,11,15,6,15,14,1,1,0,10,0,10,7,7,0,6,8,14] } }
theorem leafL_289_1_valid : (leafL_289_1).reject.ValidFor (leafL_289_1).leaf := by decide

noncomputable def leafL_289_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,240,254}, reject := .fullRank { members := ![0,1,17,34,52,72,240,254], points := ![90,101,103,122,138,141], inverse := ![5,4,6,12,7,13,7,0,0,9,14,0,6,2,4,6,6,0,10,5,8,5,4,6,7,9,14,7,14,9,9,10,3,9,5,12] } }
theorem leafL_289_2_valid : (leafL_289_2).reject.ValidFor (leafL_289_2).leaf := by decide

noncomputable def leafL_289_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,240,270}, reject := .fullRank { members := ![0,1,17,34,52,72,240,270], points := ![101,124,137,138,141,150], inverse := ![2,7,15,14,3,6,5,13,2,13,10,13,0,0,13,11,6,0,4,4,15,11,6,2,8,12,1,5,1,1,5,14,8,4,1,6] } }
theorem leafL_289_3_valid : (leafL_289_3).reject.ValidFor (leafL_289_3).leaf := by decide

noncomputable def leafL_289_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,243,268}, reject := .fullRank { members := ![0,1,17,34,52,72,243,268], points := ![90,93,101,107,112,122], inverse := ![6,9,14,3,5,6,9,0,4,7,13,7,0,0,15,14,1,0,4,12,8,2,5,7,1,1,6,9,15,0,11,11,0,11,11,0] } }
theorem leafL_289_4_valid : (leafL_289_4).reject.ValidFor (leafL_289_4).leaf := by decide

noncomputable def leafL_289_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,251,263}, reject := .fullRank { members := ![0,1,17,34,52,72,251,263], points := ![93,94,96,101,112,122], inverse := ![15,15,15,8,0,6,3,3,9,10,4,7,14,9,7,0,0,0,8,10,10,12,3,7,0,11,11,7,7,0,7,4,3,5,5,0] } }
theorem leafL_289_5_valid : (leafL_289_5).reject.ValidFor (leafL_289_5).leaf := by decide

noncomputable def leafL_289_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,254,271}, reject := .fullRank { members := ![0,1,17,34,52,72,254,271], points := ![90,91,93,103,122,125], inverse := ![5,15,5,8,1,7,7,5,11,14,14,9,8,12,4,0,0,0,1,10,3,15,0,7,0,9,9,0,5,5,12,0,12,0,12,12] } }
theorem leafL_289_6_valid : (leafL_289_6).reject.ValidFor (leafL_289_6).leaf := by decide

noncomputable def leafL_289_7 : RejectedLeaf := { leaf := {0,1,17,34,52,73,91,101}, reject := .fullRank { members := ![0,1,17,34,52,73,91,101], points := ![125,127,141,143,147,151], inverse := ![8,12,6,8,8,3,11,8,12,4,15,4,12,12,6,6,5,5,12,14,11,2,15,4,1,1,15,15,10,10,9,9,9,9,0,0] } }
theorem leafL_289_7_valid : (leafL_289_7).reject.ValidFor (leafL_289_7).leaf := by decide

noncomputable def leavesL_289 : List RejectedLeaf := [leafL_289_0,leafL_289_1,leafL_289_2,leafL_289_3,leafL_289_4,leafL_289_5,leafL_289_6,leafL_289_7]

theorem leavesL_289_valid : LeafListValid leavesL_289 := by
  intro x hx
  simp only [leavesL_289, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_289_0_valid
  · exact leafL_289_1_valid
  · exact leafL_289_2_valid
  · exact leafL_289_3_valid
  · exact leafL_289_4_valid
  · exact leafL_289_5_valid
  · exact leafL_289_6_valid
  · exact leafL_289_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
