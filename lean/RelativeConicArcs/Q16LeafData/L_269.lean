import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_269_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,138,174}, reject := .fullRank { members := ![0,1,17,34,52,72,138,174], points := ![91,92,101,103,147,151], inverse := ![3,5,3,8,6,10,12,6,4,0,7,9,15,15,3,3,15,15,9,2,15,10,9,7,2,2,6,6,7,7,3,3,12,12,2,2] } }
theorem leafL_269_0_valid : (leafL_269_0).reject.ValidFor (leafL_269_0).leaf := by decide

noncomputable def leafL_269_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,138,183}, reject := .fullRank { members := ![0,1,17,34,52,72,138,183], points := ![83,91,92,101,107,128], inverse := ![2,14,3,9,1,6,1,11,3,5,11,7,13,15,2,0,0,0,2,8,2,8,7,7,2,4,6,12,12,0,7,11,12,3,3,0] } }
theorem leafL_269_1_valid : (leafL_269_1).reject.ValidFor (leafL_269_1).leaf := by decide

noncomputable def leafL_269_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,138,188}, reject := .fullRank { members := ![0,1,17,34,52,72,138,188], points := ![91,103,115,125,126,151], inverse := ![8,9,5,0,1,4,0,13,5,13,9,12,0,0,11,3,8,0,13,2,9,5,2,1,13,8,14,9,4,6,5,13,8,4,5,1] } }
theorem leafL_269_2_valid : (leafL_269_2).reject.ValidFor (leafL_269_2).leaf := by decide

noncomputable def leafL_269_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,138,208}, reject := .fullRank { members := ![0,1,17,34,52,72,138,208], points := ![83,91,101,103,107,125], inverse := ![7,8,7,1,14,6,2,11,5,10,1,7,0,0,8,5,13,0,14,6,12,1,2,7,6,6,7,15,8,0,15,15,6,13,11,0] } }
theorem leafL_269_3_valid : (leafL_269_3).reject.ValidFor (leafL_269_3).leaf := by decide

noncomputable def leafL_269_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,138,217}, reject := .fullRank { members := ![0,1,17,34,52,72,138,217], points := ![83,91,99,101,107,126], inverse := ![11,4,15,4,3,6,12,5,2,2,14,7,0,0,11,9,2,0,0,8,14,2,3,7,6,6,14,4,10,0,15,15,15,0,15,0] } }
theorem leafL_269_4_valid : (leafL_269_4).reject.ValidFor (leafL_269_4).leaf := by decide

noncomputable def leafL_269_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,138,222}, reject := .fullRank { members := ![0,1,17,34,52,72,138,222], points := ![83,92,99,107,108,115], inverse := ![8,7,7,6,9,6,9,0,14,0,0,7,0,0,13,15,2,0,12,4,11,0,4,7,10,10,7,14,9,0,2,2,2,0,2,0] } }
theorem leafL_269_5_valid : (leafL_269_5).reject.ValidFor (leafL_269_5).leaf := by decide

noncomputable def leafL_269_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,139,151}, reject := .fullRank { members := ![0,1,17,34,52,72,139,151], points := ![90,93,101,112,115,122], inverse := ![5,10,12,4,2,4,14,7,15,1,11,12,14,14,10,10,5,5,6,14,5,10,13,10,8,8,8,8,14,14,0,0,3,3,3,3] } }
theorem leafL_269_6_valid : (leafL_269_6).reject.ValidFor (leafL_269_6).leaf := by decide

noncomputable def leafL_269_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,139,163}, reject := .fullRank { members := ![0,1,17,34,52,72,139,163], points := ![90,93,96,103,122,126], inverse := ![12,6,5,8,4,2,8,9,8,14,1,6,4,8,12,0,0,0,13,5,0,15,5,2,1,3,2,0,9,9,14,8,6,0,15,15] } }
theorem leafL_269_7_valid : (leafL_269_7).reject.ValidFor (leafL_269_7).leaf := by decide

noncomputable def leavesL_269 : List RejectedLeaf := [leafL_269_0,leafL_269_1,leafL_269_2,leafL_269_3,leafL_269_4,leafL_269_5,leafL_269_6,leafL_269_7]

theorem leavesL_269_valid : LeafListValid leavesL_269 := by
  intro x hx
  simp only [leavesL_269, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_269_0_valid
  · exact leafL_269_1_valid
  · exact leafL_269_2_valid
  · exact leafL_269_3_valid
  · exact leafL_269_4_valid
  · exact leafL_269_5_valid
  · exact leafL_269_6_valid
  · exact leafL_269_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
