import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_255_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,101,174}, reject := .fullRank { members := ![0,1,17,34,52,72,101,174], points := ![91,92,93,137,138,147], inverse := ![14,0,6,7,4,10,0,12,10,12,5,15,7,6,1,0,0,0,6,13,15,0,6,2,11,10,1,13,13,0,14,14,0,14,14,0] } }
theorem leafL_255_0_valid : (leafL_255_0).reject.ValidFor (leafL_255_0).leaf := by decide

noncomputable def leafL_255_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,101,183}, reject := .fullRank { members := ![0,1,17,34,52,72,101,183], points := ![83,91,92,124,128,137], inverse := ![14,5,12,7,9,8,3,1,5,11,2,14,13,15,2,0,0,0,9,0,14,15,7,15,6,0,6,9,9,0,6,10,12,15,15,0] } }
theorem leafL_255_1_valid : (leafL_255_1).reject.ValidFor (leafL_255_1).leaf := by decide

noncomputable def leafL_255_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,101,190}, reject := .fullRank { members := ![0,1,17,34,52,72,101,190], points := ![83,90,92,115,139,143], inverse := ![6,1,0,14,4,12,14,15,6,9,1,15,10,11,1,0,0,0,8,9,6,8,5,10,8,4,12,0,14,14,7,2,5,0,10,10] } }
theorem leafL_255_2_valid : (leafL_255_2).reject.ValidFor (leafL_255_2).leaf := by decide

noncomputable def leafL_255_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,101,207}, reject := .fullRank { members := ![0,1,17,34,52,72,101,207], points := ![83,91,115,124,126,141], inverse := ![4,3,2,13,1,8,15,8,12,7,2,14,0,0,3,14,13,0,11,12,3,2,9,15,2,2,9,2,11,0,14,14,9,6,15,0] } }
theorem leafL_255_3_valid : (leafL_255_3).reject.ValidFor (leafL_255_3).leaf := by decide

noncomputable def leafL_255_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,101,208}, reject := .fullRank { members := ![0,1,17,34,52,72,101,208], points := ![83,90,124,126,137,138], inverse := ![1,6,10,4,6,14,12,11,1,8,9,7,3,3,7,7,15,15,10,13,10,2,13,2,9,9,0,0,13,13,9,9,1,1,10,10] } }
theorem leafL_255_4_valid : (leafL_255_4).reject.ValidFor (leafL_255_4).leaf := by decide

noncomputable def leafL_255_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,101,217}, reject := .fullRank { members := ![0,1,17,34,52,72,101,217], points := ![83,91,93,124,126,138], inverse := ![11,13,1,2,12,8,13,14,4,14,7,14,2,11,9,0,0,0,14,12,5,4,12,15,12,6,10,14,14,0,0,10,10,10,10,0] } }
theorem leafL_255_5_valid : (leafL_255_5).reject.ValidFor (leafL_255_5).leaf := by decide

noncomputable def leafL_255_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,101,240}, reject := .fullRank { members := ![0,1,17,34,52,72,101,240], points := ![90,92,115,124,137,138], inverse := ![14,9,12,2,1,9,15,8,8,1,6,8,14,14,4,4,13,13,1,6,9,1,2,13,4,4,11,11,5,5,9,9,4,4,3,3] } }
theorem leafL_255_6_valid : (leafL_255_6).reject.ValidFor (leafL_255_6).leaf := by decide

noncomputable def leafL_255_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,101,254}, reject := .fullRank { members := ![0,1,17,34,52,72,101,254], points := ![83,90,91,128,138,141], inverse := ![10,5,8,14,13,5,10,12,1,9,11,5,6,3,5,0,0,0,11,6,10,8,4,11,15,10,5,0,6,6,12,13,1,0,8,8] } }
theorem leafL_255_7_valid : (leafL_255_7).reject.ValidFor (leafL_255_7).leaf := by decide

noncomputable def leavesL_255 : List RejectedLeaf := [leafL_255_0,leafL_255_1,leafL_255_2,leafL_255_3,leafL_255_4,leafL_255_5,leafL_255_6,leafL_255_7]

theorem leavesL_255_valid : LeafListValid leavesL_255 := by
  intro x hx
  simp only [leavesL_255, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_255_0_valid
  · exact leafL_255_1_valid
  · exact leafL_255_2_valid
  · exact leafL_255_3_valid
  · exact leafL_255_4_valid
  · exact leafL_255_5_valid
  · exact leafL_255_6_valid
  · exact leafL_255_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
