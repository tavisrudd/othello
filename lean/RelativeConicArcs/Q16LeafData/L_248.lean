import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_248_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,91,172}, reject := .fullRank { members := ![0,1,17,34,52,72,91,172], points := ![103,117,125,138,141,151], inverse := ![4,4,6,14,11,2,1,13,6,15,1,4,14,6,15,4,6,5,0,15,13,14,7,11,0,11,11,15,15,0,10,7,8,10,3,12] } }
theorem leafL_248_0_valid : (leafL_248_0).reject.ValidFor (leafL_248_0).leaf := by decide

noncomputable def leafL_248_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,91,181}, reject := .fullRank { members := ![0,1,17,34,52,72,91,181], points := ![103,112,115,125,135,143], inverse := ![12,11,2,11,15,0,0,7,3,13,14,7,8,8,11,11,8,8,4,3,8,7,15,7,4,4,5,5,0,0,5,5,12,12,10,10] } }
theorem leafL_248_1_valid : (leafL_248_1).reject.ValidFor (leafL_248_1).leaf := by decide

noncomputable def leafL_248_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,91,207}, reject := .fullRank { members := ![0,1,17,34,52,72,91,207], points := ![101,103,108,115,135,141], inverse := ![5,10,8,9,0,15,4,12,15,14,2,11,4,2,6,0,0,0,10,15,2,15,10,2,2,15,13,0,13,13,14,5,11,0,6,6] } }
theorem leafL_248_2_valid : (leafL_248_2).reject.ValidFor (leafL_248_2).leaf := by decide

noncomputable def leafL_248_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,91,217}, reject := .fullRank { members := ![0,1,17,34,52,72,91,217], points := ![101,108,125,135,138,141], inverse := ![13,10,9,5,12,6,5,2,14,4,8,5,0,0,0,10,7,13,0,7,15,1,13,4,15,15,0,11,12,7,4,4,0,4,4,0] } }
theorem leafL_248_3_valid : (leafL_248_3).reject.ValidFor (leafL_248_3).leaf := by decide

noncomputable def leafL_248_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,91,220}, reject := .fullRank { members := ![0,1,17,34,52,72,91,220], points := ![101,103,112,115,117,135], inverse := ![13,0,10,4,13,15,12,14,5,11,5,9,11,1,10,0,0,0,13,15,5,11,4,8,9,15,6,9,9,0,1,10,11,12,12,0] } }
theorem leafL_248_4_valid : (leafL_248_4).reject.ValidFor (leafL_248_4).leaf := by decide

noncomputable def leafL_248_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,91,233}, reject := .fullRank { members := ![0,1,17,34,52,72,91,233], points := ![101,112,117,138,143,149], inverse := ![3,3,4,14,0,11,13,0,1,0,0,12,8,0,12,11,14,1,7,10,0,5,4,12,1,4,14,0,13,6,14,11,14,12,1,6] } }
theorem leafL_248_5_valid : (leafL_248_5).reject.ValidFor (leafL_248_5).leaf := by decide

noncomputable def leafL_248_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,91,254}, reject := .fullRank { members := ![0,1,17,34,52,72,91,254], points := ![101,103,108,125,135,138], inverse := ![7,5,5,9,7,8,10,14,3,14,7,14,4,2,6,0,0,0,12,6,13,15,12,4,6,13,11,0,7,7,4,0,4,0,4,4] } }
theorem leafL_248_6_valid : (leafL_248_6).reject.ValidFor (leafL_248_6).leaf := by decide

noncomputable def leafL_248_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,91,262}, reject := .fullRank { members := ![0,1,17,34,52,72,91,262], points := ![108,112,117,125,135,138], inverse := ![6,1,4,13,9,6,10,13,5,11,3,10,6,6,6,6,9,9,13,10,10,5,4,12,3,3,8,8,8,8,1,1,14,14,2,2] } }
theorem leafL_248_7_valid : (leafL_248_7).reject.ValidFor (leafL_248_7).leaf := by decide

noncomputable def leavesL_248 : List RejectedLeaf := [leafL_248_0,leafL_248_1,leafL_248_2,leafL_248_3,leafL_248_4,leafL_248_5,leafL_248_6,leafL_248_7]

theorem leavesL_248_valid : LeafListValid leavesL_248 := by
  intro x hx
  simp only [leavesL_248, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_248_0_valid
  · exact leafL_248_1_valid
  · exact leafL_248_2_valid
  · exact leafL_248_3_valid
  · exact leafL_248_4_valid
  · exact leafL_248_5_valid
  · exact leafL_248_6_valid
  · exact leafL_248_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
