import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_291_0 : RejectedLeaf := { leaf := {0,1,17,34,52,73,92,147}, reject := .fullRank { members := ![0,1,17,34,52,73,92,147], points := ![101,112,126,127,141,143], inverse := ![13,10,11,2,9,6,14,9,10,4,1,8,2,2,6,6,14,14,1,6,3,12,13,5,10,10,1,1,0,0,2,2,8,8,7,7] } }
theorem leafL_291_0_valid : (leafL_291_0).reject.ValidFor (leafL_291_0).leaf := by decide

noncomputable def leafL_291_1 : RejectedLeaf := { leaf := {0,1,17,34,52,73,92,167}, reject := .fullRank { members := ![0,1,17,34,52,73,92,167], points := ![99,101,109,126,133,141], inverse := ![4,15,12,9,14,1,10,15,2,14,14,7,9,11,2,0,0,0,7,9,9,15,11,3,4,11,15,0,3,3,0,14,14,0,14,14] } }
theorem leafL_291_1_valid : (leafL_291_1).reject.ValidFor (leafL_291_1).leaf := by decide

noncomputable def leafL_291_2 : RejectedLeaf := { leaf := {0,1,17,34,52,73,92,176}, reject := .fullRank { members := ![0,1,17,34,52,73,92,176], points := ![99,107,127,133,152,154], inverse := ![12,9,10,3,14,3,9,14,14,9,1,1,11,5,9,2,15,10,1,14,3,13,4,5,8,15,13,1,7,12,0,8,12,5,15,14] } }
theorem leafL_291_2_valid : (leafL_291_2).reject.ValidFor (leafL_291_2).leaf := by decide

noncomputable def leafL_291_3 : RejectedLeaf := { leaf := {0,1,17,34,52,73,92,263}, reject := .fullRank { members := ![0,1,17,34,52,73,92,263], points := ![101,107,109,127,133,143], inverse := ![15,10,2,9,10,5,9,3,13,14,0,9,2,9,11,0,0,0,13,4,14,15,2,10,5,15,10,0,13,13,12,9,5,0,6,6] } }
theorem leafL_291_3_valid : (leafL_291_3).reject.ValidFor (leafL_291_3).leaf := by decide

noncomputable def leafL_291_4 : RejectedLeaf := { leaf := {0,1,17,34,52,73,92,264}, reject := .fullRank { members := ![0,1,17,34,52,73,92,264], points := ![101,126,127,133,143,151], inverse := ![10,9,2,7,0,7,14,15,5,3,9,14,7,10,7,6,7,11,8,7,9,6,10,10,0,12,12,14,14,0,10,11,4,15,6,12] } }
theorem leafL_291_4_valid : (leafL_291_4).reject.ValidFor (leafL_291_4).leaf := by decide

noncomputable def leafL_291_5 : RejectedLeaf := { leaf := {0,1,17,34,52,73,92,269}, reject := .fullRank { members := ![0,1,17,34,52,73,92,269], points := ![112,126,133,143,147,152], inverse := ![5,10,12,15,7,10,12,9,8,14,14,13,12,10,5,11,11,3,5,12,6,2,10,7,3,11,3,9,0,2,12,10,15,1,12,4] } }
theorem leafL_291_5_valid : (leafL_291_5).reject.ValidFor (leafL_291_5).leaf := by decide

noncomputable def leafL_291_6 : RejectedLeaf := { leaf := {0,1,17,34,52,73,103,126}, reject := .fullRank { members := ![0,1,17,34,52,73,103,126], points := ![86,133,143,147,152,154], inverse := ![8,2,1,15,1,4,6,15,6,15,14,14,0,0,0,1,14,15,4,12,10,7,3,6,0,15,15,11,12,7,0,10,10,6,9,15] } }
theorem leafL_291_6_valid : (leafL_291_6).reject.ValidFor (leafL_291_6).leaf := by decide

noncomputable def leafL_291_7 : RejectedLeaf := { leaf := {0,1,17,34,52,73,103,158}, reject := .fullRank { members := ![0,1,17,34,52,73,103,158], points := ![86,95,120,125,127,163], inverse := ![14,8,5,11,6,15,1,3,3,15,8,6,0,0,10,11,1,0,10,7,14,5,10,12,15,15,8,3,11,0,11,11,11,11,0,0] } }
theorem leafL_291_7_valid : (leafL_291_7).reject.ValidFor (leafL_291_7).leaf := by decide

noncomputable def leavesL_291 : List RejectedLeaf := [leafL_291_0,leafL_291_1,leafL_291_2,leafL_291_3,leafL_291_4,leafL_291_5,leafL_291_6,leafL_291_7]

theorem leavesL_291_valid : LeafListValid leavesL_291 := by
  intro x hx
  simp only [leavesL_291, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_291_0_valid
  · exact leafL_291_1_valid
  · exact leafL_291_2_valid
  · exact leafL_291_3_valid
  · exact leafL_291_4_valid
  · exact leafL_291_5_valid
  · exact leafL_291_6_valid
  · exact leafL_291_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
