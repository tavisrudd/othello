import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_210_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,147,262}, reject := .fullRank { members := ![0,1,17,34,52,71,147,262], points := ![90,91,92,106,110,120], inverse := ![0,0,15,0,8,6,3,0,10,8,6,7,7,14,9,0,0,0,6,1,15,6,9,7,1,7,6,1,1,0,8,2,10,13,13,0] } }
theorem leafL_210_0_valid : (leafL_210_0).reject.ValidFor (leafL_210_0).leaf := by decide

noncomputable def leafL_210_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,147,267}, reject := .fullRank { members := ![0,1,17,34,52,71,147,267], points := ![101,106,120,122,128,141], inverse := ![12,11,7,14,0,15,6,1,1,10,5,9,0,0,2,9,11,0,5,2,11,7,3,8,8,8,6,1,7,0,13,13,3,8,11,0] } }
theorem leafL_210_1_valid : (leafL_210_1).reject.ValidFor (leafL_210_1).leaf := by decide

noncomputable def leafL_210_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,147,269}, reject := .fullRank { members := ![0,1,17,34,52,71,147,269], points := ![91,96,110,120,124,128], inverse := ![12,3,8,0,12,10,11,2,14,9,11,5,0,0,0,12,11,7,13,5,15,5,7,5,14,14,0,2,13,15,12,12,0,6,3,5] } }
theorem leafL_210_2_valid : (leafL_210_2).reject.ValidFor (leafL_210_2).leaf := by decide

noncomputable def leafL_210_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,150,169}, reject := .fullRank { members := ![0,1,17,34,52,71,150,169], points := ![91,106,122,124,139,140], inverse := ![2,5,11,0,6,11,11,12,12,9,11,9,8,8,15,7,6,14,2,5,5,8,2,8,12,12,11,7,3,15,11,11,11,0,11,0] } }
theorem leafL_210_3_valid : (leafL_210_3).reject.ValidFor (leafL_210_3).leaf := by decide

noncomputable def leafL_210_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,150,173}, reject := .fullRank { members := ![0,1,17,34,52,71,150,173], points := ![83,101,106,122,124,126], inverse := ![15,12,4,15,4,13,9,6,8,14,1,8,0,0,0,15,10,5,8,5,10,6,11,10,0,8,8,2,4,6,0,13,13,1,3,2] } }
theorem leafL_210_4_valid : (leafL_210_4).reject.ValidFor (leafL_210_4).leaf := by decide

noncomputable def leafL_210_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,150,176}, reject := .fullRank { members := ![0,1,17,34,52,71,150,176], points := ![83,90,91,101,126,131], inverse := ![9,13,9,10,4,2,2,2,1,6,15,8,6,3,5,0,0,0,9,9,7,0,8,15,8,6,9,7,7,7,9,14,2,5,5,5] } }
theorem leafL_210_5_valid : (leafL_210_5).reject.ValidFor (leafL_210_5).leaf := by decide

noncomputable def leafL_210_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,150,188}, reject := .fullRank { members := ![0,1,17,34,52,71,150,188], points := ![83,90,91,106,128,131], inverse := ![11,7,5,14,0,6,4,14,2,15,6,1,6,3,5,0,0,0,11,7,8,3,11,12,11,7,14,2,2,2,13,3,7,9,9,9] } }
theorem leafL_210_6_valid : (leafL_210_6).reject.ValidFor (leafL_210_6).leaf := by decide

noncomputable def leafL_210_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,150,213}, reject := .fullRank { members := ![0,1,17,34,52,71,150,213], points := ![83,91,93,121,124,138], inverse := ![13,3,9,11,5,8,7,15,15,14,7,14,2,11,9,0,0,0,8,2,13,11,3,15,11,4,15,15,15,0,5,3,6,7,7,0] } }
theorem leafL_210_7_valid : (leafL_210_7).reject.ValidFor (leafL_210_7).leaf := by decide

noncomputable def leavesL_210 : List RejectedLeaf := [leafL_210_0,leafL_210_1,leafL_210_2,leafL_210_3,leafL_210_4,leafL_210_5,leafL_210_6,leafL_210_7]

theorem leavesL_210_valid : LeafListValid leavesL_210 := by
  intro x hx
  simp only [leavesL_210, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_210_0_valid
  · exact leafL_210_1_valid
  · exact leafL_210_2_valid
  · exact leafL_210_3_valid
  · exact leafL_210_4_valid
  · exact leafL_210_5_valid
  · exact leafL_210_6_valid
  · exact leafL_210_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
