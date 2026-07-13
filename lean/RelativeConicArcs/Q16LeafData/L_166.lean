import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_166_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,92,262}, reject := .fullRank { members := ![0,1,17,34,52,71,92,262], points := ![99,109,127,133,138,139], inverse := ![11,12,9,15,13,13,1,6,14,1,4,12,0,0,0,12,13,1,8,15,15,0,14,6,13,13,0,10,10,0,8,8,0,8,0,8] } }
theorem leafL_166_0_valid : (leafL_166_0).reject.ValidFor (leafL_166_0).leaf := by decide

noncomputable def leafL_166_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,92,267}, reject := .fullRank { members := ![0,1,17,34,52,71,92,267], points := ![99,101,104,122,127,141], inverse := ![3,0,4,7,14,15,0,13,10,4,10,9,4,12,8,0,0,0,2,6,3,3,12,8,9,7,14,10,10,0,1,8,9,2,2,0] } }
theorem leafL_166_1_valid : (leafL_166_1).reject.ValidFor (leafL_166_1).leaf := by decide

noncomputable def leafL_166_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,106}, reject := .fullRank { members := ![0,1,17,34,52,71,93,106], points := ![121,124,139,140,144,158], inverse := ![11,15,5,12,7,11,6,5,8,14,14,11,0,0,11,13,6,0,14,12,2,8,3,11,12,12,5,1,4,0,14,14,4,8,12,0] } }
theorem leafL_166_2_valid : (leafL_166_2).reject.ValidFor (leafL_166_2).leaf := by decide

noncomputable def leafL_166_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,110}, reject := .fullRank { members := ![0,1,17,34,52,71,93,110], points := ![128,139,159,166,168,172], inverse := ![6,12,9,10,10,2,3,8,11,8,1,9,0,0,0,8,5,13,4,15,13,15,4,13,13,13,13,10,3,4,9,9,9,0,0,9] } }
theorem leafL_166_3_valid : (leafL_166_3).reject.ValidFor (leafL_166_3).leaf := by decide

noncomputable def leafL_166_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,121}, reject := .fullRank { members := ![0,1,17,34,52,71,93,121], points := ![101,106,144,150,158,159], inverse := ![15,6,13,6,14,13,5,7,4,6,7,7,0,0,0,6,5,3,4,9,1,15,2,1,11,11,0,6,9,15,3,3,0,8,1,9] } }
theorem leafL_166_4_valid : (leafL_166_4).reject.ValidFor (leafL_166_4).leaf := by decide

noncomputable def leafL_166_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,139}, reject := .fullRank { members := ![0,1,17,34,52,71,93,139], points := ![101,106,110,120,124,150], inverse := ![0,0,12,14,0,3,6,13,6,6,7,12,8,1,9,0,0,0,6,7,11,5,8,7,1,6,7,13,13,0,4,3,7,6,6,0] } }
theorem leafL_166_5_valid : (leafL_166_5).reject.ValidFor (leafL_166_5).leaf := by decide

noncomputable def leafL_166_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,140}, reject := .fullRank { members := ![0,1,17,34,52,71,93,140], points := ![99,106,127,128,150,158], inverse := ![3,15,3,13,12,15,14,3,0,1,3,15,5,5,4,4,6,6,5,15,4,9,13,10,7,7,8,8,7,7,14,14,5,5,7,7] } }
theorem leafL_166_6_valid : (leafL_166_6).reject.ValidFor (leafL_166_6).leaf := by decide

noncomputable def leafL_166_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,144}, reject := .fullRank { members := ![0,1,17,34,52,71,93,144], points := ![106,120,121,154,158,159], inverse := ![12,3,13,11,9,1,13,8,9,5,6,15,0,0,0,8,10,2,10,14,3,7,9,9,0,7,7,9,0,9,0,11,11,13,2,15] } }
theorem leafL_166_7_valid : (leafL_166_7).reject.ValidFor (leafL_166_7).leaf := by decide

noncomputable def leavesL_166 : List RejectedLeaf := [leafL_166_0,leafL_166_1,leafL_166_2,leafL_166_3,leafL_166_4,leafL_166_5,leafL_166_6,leafL_166_7]

theorem leavesL_166_valid : LeafListValid leavesL_166 := by
  intro x hx
  simp only [leavesL_166, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_166_0_valid
  · exact leafL_166_1_valid
  · exact leafL_166_2_valid
  · exact leafL_166_3_valid
  · exact leafL_166_4_valid
  · exact leafL_166_5_valid
  · exact leafL_166_6_valid
  · exact leafL_166_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
