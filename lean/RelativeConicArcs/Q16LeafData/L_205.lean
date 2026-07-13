import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_205_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,140,235}, reject := .fullRank { members := ![0,1,17,34,52,71,140,235], points := ![96,99,122,126,150,169], inverse := ![3,13,9,8,1,15,11,4,13,3,6,7,15,10,14,13,4,2,5,12,6,10,10,15,5,2,0,12,15,4,2,2,0,0,2,2] } }
theorem leafL_205_0_valid : (leafL_205_0).reject.ValidFor (leafL_205_0).leaf := by decide

noncomputable def leafL_205_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,140,239}, reject := .fullRank { members := ![0,1,17,34,52,71,140,239], points := ![93,94,99,104,122,126], inverse := ![15,0,13,5,13,11,5,12,0,14,4,3,12,12,7,7,1,1,11,3,1,14,9,14,14,14,4,4,2,2,4,4,4,4,4,4] } }
theorem leafL_205_1_valid : (leafL_205_1).reject.ValidFor (leafL_205_1).leaf := by decide

noncomputable def leafL_205_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,140,240}, reject := .fullRank { members := ![0,1,17,34,52,71,140,240], points := ![94,99,104,106,120,122], inverse := ![15,15,7,0,2,4,9,7,8,1,2,5,0,1,14,15,0,0,8,9,2,4,15,8,0,14,13,3,5,5,0,0,1,1,1,1] } }
theorem leafL_205_2_valid : (leafL_205_2).reject.ValidFor (leafL_205_2).leaf := by decide

noncomputable def leafL_205_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,140,269}, reject := .fullRank { members := ![0,1,17,34,52,71,140,269], points := ![94,96,104,120,126,128], inverse := ![4,11,8,5,11,8,2,11,14,14,2,11,0,0,0,8,6,14,3,11,15,15,3,11,8,8,0,3,13,14,13,13,0,0,13,13] } }
theorem leafL_205_3_valid : (leafL_205_3).reject.ValidFor (leafL_205_3).leaf := by decide

noncomputable def leafL_205_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,140,271}, reject := .fullRank { members := ![0,1,17,34,52,71,140,271], points := ![93,96,109,122,147,155], inverse := ![15,6,15,8,8,7,10,7,5,2,12,6,0,13,8,3,8,14,5,15,3,12,4,1,5,3,7,14,2,13,6,15,3,6,15,3] } }
theorem leafL_205_4_valid : (leafL_205_4).reject.ValidFor (leafL_205_4).leaf := by decide

noncomputable def leafL_205_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,144,154}, reject := .fullRank { members := ![0,1,17,34,52,71,144,154], points := ![83,91,93,109,126,127], inverse := ![11,11,15,8,12,10,15,8,14,14,11,12,2,11,9,0,0,0,6,15,1,15,9,14,11,4,15,0,15,15,5,3,6,0,7,7] } }
theorem leafL_205_5_valid : (leafL_205_5).reject.ValidFor (leafL_205_5).leaf := by decide

noncomputable def leafL_205_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,144,155}, reject := .fullRank { members := ![0,1,17,34,52,71,144,155], points := ![83,90,109,110,120,168], inverse := ![9,5,4,9,4,4,4,9,7,5,14,1,14,5,6,8,3,6,0,9,6,10,8,13,1,0,9,10,15,13,3,1,8,14,13,9] } }
theorem leafL_205_6_valid : (leafL_205_6).reject.ValidFor (leafL_205_6).leaf := by decide

noncomputable def leafL_205_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,144,158}, reject := .fullRank { members := ![0,1,17,34,52,71,144,158], points := ![83,90,93,120,121,168], inverse := ![7,2,3,1,9,15,2,2,2,4,0,6,15,1,14,0,0,0,12,7,6,14,15,12,13,12,1,3,3,0,6,9,15,4,4,0] } }
theorem leafL_205_7_valid : (leafL_205_7).reject.ValidFor (leafL_205_7).leaf := by decide

noncomputable def leavesL_205 : List RejectedLeaf := [leafL_205_0,leafL_205_1,leafL_205_2,leafL_205_3,leafL_205_4,leafL_205_5,leafL_205_6,leafL_205_7]

theorem leavesL_205_valid : LeafListValid leavesL_205 := by
  intro x hx
  simp only [leavesL_205, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_205_0_valid
  · exact leafL_205_1_valid
  · exact leafL_205_2_valid
  · exact leafL_205_3_valid
  · exact leafL_205_4_valid
  · exact leafL_205_5_valid
  · exact leafL_205_6_valid
  · exact leafL_205_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
