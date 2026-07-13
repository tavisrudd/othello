import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_154_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,127,247}, reject := .fullRank { members := ![0,1,17,34,52,70,127,247], points := ![83,90,91,104,107,137], inverse := ![2,4,15,2,12,6,0,5,11,4,13,7,6,3,5,0,0,0,7,9,1,10,2,7,2,2,0,3,3,0,2,15,13,4,4,0] } }
theorem leafL_154_0_valid : (leafL_154_0).reject.ValidFor (leafL_154_0).leaf := by decide

noncomputable def leafL_154_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,127,267}, reject := .fullRank { members := ![0,1,17,34,52,70,127,267], points := ![89,101,104,133,137,141], inverse := ![9,6,8,10,4,8,14,11,2,5,13,15,0,0,0,12,11,7,15,3,11,7,8,8,0,6,6,2,2,0,0,7,7,1,13,12] } }
theorem leafL_154_1_valid : (leafL_154_1).reject.ValidFor (leafL_154_1).leaf := by decide

noncomputable def leafL_154_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,133,171}, reject := .fullRank { members := ![0,1,17,34,52,70,133,171], points := ![83,90,94,108,115,120], inverse := ![7,13,5,8,9,15,12,6,3,14,5,2,14,12,2,0,0,0,12,13,9,15,8,15,2,10,8,0,5,5,7,9,14,0,12,12] } }
theorem leafL_154_2_valid : (leafL_154_2).reject.ValidFor (leafL_154_2).leaf := by decide

noncomputable def leafL_154_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,133,185}, reject := .fullRank { members := ![0,1,17,34,52,70,133,185], points := ![83,94,115,120,124,151], inverse := ![1,3,6,13,14,6,8,13,13,11,14,13,0,0,5,2,7,0,2,1,15,9,12,9,11,11,11,6,13,0,4,4,14,6,8,0] } }
theorem leafL_154_3_valid : (leafL_154_3).reject.ValidFor (leafL_154_3).leaf := by decide

noncomputable def leafL_154_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,133,186}, reject := .fullRank { members := ![0,1,17,34,52,70,133,186], points := ![95,108,115,124,127,159], inverse := ![11,3,13,5,11,10,5,0,0,0,8,13,0,0,7,5,2,0,9,9,0,9,2,11,8,5,8,12,14,7,13,8,0,8,11,6] } }
theorem leafL_154_4_valid : (leafL_154_4).reject.ValidFor (leafL_154_4).leaf := by decide

noncomputable def leafL_154_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,133,195}, reject := .fullRank { members := ![0,1,17,34,52,70,133,195], points := ![94,103,108,127,151,154], inverse := ![13,8,12,13,13,8,8,9,1,11,9,2,3,11,1,7,7,9,13,0,2,14,4,5,5,5,8,9,4,5,11,4,11,13,11,2] } }
theorem leafL_154_5_valid : (leafL_154_5).reject.ValidFor (leafL_154_5).leaf := by decide

noncomputable def leafL_154_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,133,220}, reject := .fullRank { members := ![0,1,17,34,52,70,133,220], points := ![90,94,120,147,159,168], inverse := ![3,1,5,12,10,0,8,6,0,4,14,4,11,10,14,14,6,7,12,2,0,12,7,5,1,12,10,12,14,5,8,7,5,13,12,11] } }
theorem leafL_154_6_valid : (leafL_154_6).reject.ValidFor (leafL_154_6).leaf := by decide

noncomputable def leafL_154_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,133,237}, reject := .fullRank { members := ![0,1,17,34,52,70,133,237], points := ![83,94,95,103,107,115], inverse := ![11,5,1,14,6,6,4,1,12,5,11,7,15,9,6,0,0,0,6,2,12,13,2,7,12,6,10,14,14,0,10,0,10,10,10,0] } }
theorem leafL_154_7_valid : (leafL_154_7).reject.ValidFor (leafL_154_7).leaf := by decide

noncomputable def leavesL_154 : List RejectedLeaf := [leafL_154_0,leafL_154_1,leafL_154_2,leafL_154_3,leafL_154_4,leafL_154_5,leafL_154_6,leafL_154_7]

theorem leavesL_154_valid : LeafListValid leavesL_154 := by
  intro x hx
  simp only [leavesL_154, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_154_0_valid
  · exact leafL_154_1_valid
  · exact leafL_154_2_valid
  · exact leafL_154_3_valid
  · exact leafL_154_4_valid
  · exact leafL_154_5_valid
  · exact leafL_154_6_valid
  · exact leafL_154_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
