import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_216_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,156,217}, reject := .fullRank { members := ![0,1,17,34,52,71,156,217], points := ![83,94,96,99,101,122], inverse := ![12,6,5,0,8,6,2,5,14,3,13,7,6,4,2,0,0,0,6,2,12,12,3,7,6,15,9,15,15,0,11,10,1,7,7,0] } }
theorem leafL_216_0_valid : (leafL_216_0).reject.ValidFor (leafL_216_0).leaf := by decide

noncomputable def leafL_216_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,156,222}, reject := .fullRank { members := ![0,1,17,34,52,71,156,222], points := ![83,96,99,109,121,131], inverse := ![7,0,12,12,14,8,14,0,9,0,0,7,0,12,10,6,12,12,7,6,7,1,14,9,7,11,6,10,12,12,4,3,14,9,7,7] } }
theorem leafL_216_1_valid : (leafL_216_1).reject.ValidFor (leafL_216_1).leaf := by decide

noncomputable def leafL_216_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,156,237}, reject := .fullRank { members := ![0,1,17,34,52,71,156,237], points := ![83,94,96,104,106,121], inverse := ![6,15,6,1,9,6,6,1,14,1,15,7,6,4,2,0,0,0,14,14,8,9,6,7,1,4,5,12,12,0,14,12,2,3,3,0] } }
theorem leafL_216_2_valid : (leafL_216_2).reject.ValidFor (leafL_216_2).leaf := by decide

noncomputable def leafL_216_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,156,253}, reject := .fullRank { members := ![0,1,17,34,52,71,156,253], points := ![83,99,104,110,121,127], inverse := ![15,12,3,7,13,11,9,8,5,3,14,9,0,7,13,10,0,0,8,4,15,4,5,2,0,5,5,0,9,9,0,15,5,10,12,12] } }
theorem leafL_216_3_valid : (leafL_216_3).reject.ValidFor (leafL_216_3).leaf := by decide

noncomputable def leafL_216_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,156,262}, reject := .fullRank { members := ![0,1,17,34,52,71,156,262], points := ![83,96,106,109,110,121], inverse := ![7,8,4,11,7,6,14,7,11,9,12,7,0,0,6,11,13,0,7,15,9,12,10,7,7,7,5,3,6,0,4,4,14,12,2,0] } }
theorem leafL_216_4_valid : (leafL_216_4).reject.ValidFor (leafL_216_4).leaf := by decide

noncomputable def leafL_216_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,156,267}, reject := .fullRank { members := ![0,1,17,34,52,71,156,267], points := ![94,99,101,104,121,127], inverse := ![15,15,0,7,12,10,9,6,8,0,10,13,0,4,12,8,0,0,8,2,4,9,9,14,0,5,0,5,9,9,0,12,12,0,12,12] } }
theorem leafL_216_5_valid : (leafL_216_5).reject.ValidFor (leafL_216_5).leaf := by decide

noncomputable def leafL_216_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,156,269}, reject := .fullRank { members := ![0,1,17,34,52,71,156,269], points := ![83,94,96,104,110,131], inverse := ![11,8,10,3,13,6,4,12,6,4,13,7,6,4,2,0,0,0,8,10,13,7,15,7,11,8,3,5,5,0,5,15,10,12,12,0] } }
theorem leafL_216_6_valid : (leafL_216_6).reject.ValidFor (leafL_216_6).leaf := by decide

noncomputable def leafL_216_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,156,271}, reject := .fullRank { members := ![0,1,17,34,52,71,156,271], points := ![96,104,109,110,121,122], inverse := ![15,3,3,8,5,3,9,11,13,8,1,6,0,9,5,12,0,0,8,8,7,0,4,3,0,9,7,14,3,3,0,0,14,14,14,14] } }
theorem leafL_216_7_valid : (leafL_216_7).reject.ValidFor (leafL_216_7).leaf := by decide

noncomputable def leavesL_216 : List RejectedLeaf := [leafL_216_0,leafL_216_1,leafL_216_2,leafL_216_3,leafL_216_4,leafL_216_5,leafL_216_6,leafL_216_7]

theorem leavesL_216_valid : LeafListValid leavesL_216 := by
  intro x hx
  simp only [leavesL_216, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_216_0_valid
  · exact leafL_216_1_valid
  · exact leafL_216_2_valid
  · exact leafL_216_3_valid
  · exact leafL_216_4_valid
  · exact leafL_216_5_valid
  · exact leafL_216_6_valid
  · exact leafL_216_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
