import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_006_0 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,138}, reject := .fullRank { members := ![0,1,17,34,52,67,91,138], points := ![109,127,176,182,185,191], inverse := ![6,0,11,13,11,10,11,4,2,10,8,15,0,0,0,7,15,8,12,14,10,10,9,11,13,13,13,7,7,13,3,3,3,14,5,8] } }
theorem leafL_006_0_valid : (leafL_006_0).reject.ValidFor (leafL_006_0).leaf := by decide

noncomputable def leafL_006_1 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,143}, reject := .fullRank { members := ![0,1,17,34,52,67,91,143], points := ![106,109,110,122,149,151], inverse := ![12,3,3,14,4,7,1,5,9,1,4,8,6,11,13,0,0,0,10,2,2,13,13,10,5,1,4,0,10,10,14,9,7,0,2,2] } }
theorem leafL_006_1_valid : (leafL_006_1).reject.ValidFor (leafL_006_1).leaf := by decide

noncomputable def leafL_006_2 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,144}, reject := .fullRank { members := ![0,1,17,34,52,67,91,144], points := ![108,109,110,121,122,149], inverse := ![3,4,11,6,8,3,2,3,12,13,12,12,1,6,7,0,0,0,10,1,1,3,14,7,1,4,5,3,3,0,0,14,14,14,14,0] } }
theorem leafL_006_2_valid : (leafL_006_2).reject.ValidFor (leafL_006_2).leaf := by decide

noncomputable def leafL_006_3 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,151}, reject := .fullRank { members := ![0,1,17,34,52,67,91,151], points := ![110,122,127,141,143,172], inverse := ![12,1,12,9,10,3,10,0,11,11,13,7,11,9,13,12,0,3,4,10,12,11,11,2,2,4,10,2,3,13,1,13,10,0,9,15] } }
theorem leafL_006_3_valid : (leafL_006_3).reject.ValidFor (leafL_006_3).leaf := by decide

noncomputable def leafL_006_4 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,159}, reject := .fullRank { members := ![0,1,17,34,52,67,91,159], points := ![106,108,109,121,144,176], inverse := ![0,0,10,12,0,7,6,12,15,0,8,13,12,3,15,0,0,0,3,11,3,13,14,8,12,10,15,10,13,14,8,1,5,2,6,8] } }
theorem leafL_006_4_valid : (leafL_006_4).reject.ValidFor (leafL_006_4).leaf := by decide

noncomputable def leafL_006_5 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,168}, reject := .fullRank { members := ![0,1,17,34,52,67,91,168], points := ![106,109,110,137,143,149], inverse := ![15,10,12,7,10,5,14,12,0,12,8,6,6,11,13,0,0,0,2,5,10,13,12,12,13,11,6,4,4,0,9,11,2,10,10,0] } }
theorem leafL_006_5_valid : (leafL_006_5).reject.ValidFor (leafL_006_5).leaf := by decide

noncomputable def leafL_006_6 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,172}, reject := .fullRank { members := ![0,1,17,34,52,67,91,172], points := ![106,109,110,121,122,141], inverse := ![3,0,4,12,5,15,14,10,3,3,13,9,6,11,13,0,0,0,15,10,2,2,13,8,6,9,15,3,3,0,0,14,14,14,14,0] } }
theorem leafL_006_6_valid : (leafL_006_6).reject.ValidFor (leafL_006_6).leaf := by decide

noncomputable def leafL_006_7 : RejectedLeaf := { leaf := {0,1,17,34,52,67,91,176}, reject := .fullRank { members := ![0,1,17,34,52,67,91,176], points := ![108,127,138,149,158,159], inverse := ![14,13,12,7,4,13,12,9,6,4,2,5,0,0,0,11,15,4,15,3,13,0,1,0,9,4,3,8,4,2,14,9,2,4,1,0] } }
theorem leafL_006_7_valid : (leafL_006_7).reject.ValidFor (leafL_006_7).leaf := by decide

noncomputable def leavesL_006 : List RejectedLeaf := [leafL_006_0,leafL_006_1,leafL_006_2,leafL_006_3,leafL_006_4,leafL_006_5,leafL_006_6,leafL_006_7]

theorem leavesL_006_valid : LeafListValid leavesL_006 := by
  intro x hx
  simp only [leavesL_006, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_006_0_valid
  · exact leafL_006_1_valid
  · exact leafL_006_2_valid
  · exact leafL_006_3_valid
  · exact leafL_006_4_valid
  · exact leafL_006_5_valid
  · exact leafL_006_6_valid
  · exact leafL_006_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
