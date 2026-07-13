import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_235_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,191,267}, reject := .fullRank { members := ![0,1,17,34,52,71,191,267], points := ![92,94,101,106,120,121], inverse := ![0,15,9,1,4,2,0,9,1,15,12,11,5,5,15,15,15,15,2,10,10,5,5,2,1,1,11,11,8,8,6,6,7,7,3,3] } }
theorem leafL_235_0_valid : (leafL_235_0).reject.ValidFor (leafL_235_0).leaf := by decide

noncomputable def leafL_235_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,197,216}, reject := .fullRank { members := ![0,1,17,34,52,71,197,216], points := ![83,90,106,109,110,122], inverse := ![1,14,15,13,10,6,0,9,14,0,0,7,0,0,6,11,13,0,11,3,2,8,5,7,2,2,13,5,8,0,5,5,9,3,10,0] } }
theorem leafL_235_1_valid : (leafL_235_1).reject.ValidFor (leafL_235_1).leaf := by decide

noncomputable def leafL_235_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,197,233}, reject := .fullRank { members := ![0,1,17,34,52,71,197,233], points := ![93,94,99,104,106,128], inverse := ![11,4,1,9,0,6,1,8,0,6,8,7,0,0,1,14,15,0,12,4,9,9,15,7,5,5,8,5,13,0,1,1,15,6,9,0] } }
theorem leafL_235_2_valid : (leafL_235_2).reject.ValidFor (leafL_235_2).leaf := by decide

noncomputable def leafL_235_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,197,235}, reject := .fullRank { members := ![0,1,17,34,52,71,197,235], points := ![83,90,99,110,121,122], inverse := ![3,12,3,11,3,5,2,11,7,9,3,4,14,14,8,8,9,9,0,8,9,6,7,0,11,11,10,10,4,4,8,8,14,14,2,2] } }
theorem leafL_235_3_valid : (leafL_235_3).reject.ValidFor (leafL_235_3).leaf := by decide

noncomputable def leafL_235_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,197,240}, reject := .fullRank { members := ![0,1,17,34,52,71,197,240], points := ![90,99,104,109,120,122], inverse := ![15,13,2,7,11,13,9,14,14,14,0,7,0,14,1,15,0,0,8,6,15,6,9,14,0,13,14,3,5,5,0,1,0,1,1,1] } }
theorem leafL_235_4_valid : (leafL_235_4).reject.ValidFor (leafL_235_4).leaf := by decide

noncomputable def leafL_235_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,197,267}, reject := .fullRank { members := ![0,1,17,34,52,71,197,267], points := ![92,93,94,104,106,120], inverse := ![6,3,10,10,2,6,1,3,11,14,0,7,1,6,7,0,0,0,8,13,13,6,9,7,8,0,8,12,12,0,15,5,10,3,3,0] } }
theorem leafL_235_5_valid : (leafL_235_5).reject.ValidFor (leafL_235_5).leaf := by decide

noncomputable def leafL_235_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,197,269}, reject := .fullRank { members := ![0,1,17,34,52,71,197,269], points := ![83,94,104,110,120,128], inverse := ![1,14,7,15,7,1,9,0,9,7,6,1,10,10,10,10,9,9,10,2,11,4,0,7,1,1,10,10,4,4,12,12,8,8,11,11] } }
theorem leafL_235_6_valid : (leafL_235_6).reject.ValidFor (leafL_235_6).leaf := by decide

noncomputable def leafL_235_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,203,213}, reject := .fullRank { members := ![0,1,17,34,52,71,203,213], points := ![83,93,99,110,126,127], inverse := ![0,15,11,3,8,14,3,10,8,6,0,7,14,14,11,11,9,9,11,3,15,0,1,6,9,9,4,4,5,5,13,13,3,3,9,9] } }
theorem leafL_235_7_valid : (leafL_235_7).reject.ValidFor (leafL_235_7).leaf := by decide

noncomputable def leavesL_235 : List RejectedLeaf := [leafL_235_0,leafL_235_1,leafL_235_2,leafL_235_3,leafL_235_4,leafL_235_5,leafL_235_6,leafL_235_7]

theorem leavesL_235_valid : LeafListValid leavesL_235 := by
  intro x hx
  simp only [leavesL_235, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_235_0_valid
  · exact leafL_235_1_valid
  · exact leafL_235_2_valid
  · exact leafL_235_3_valid
  · exact leafL_235_4_valid
  · exact leafL_235_5_valid
  · exact leafL_235_6_valid
  · exact leafL_235_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
