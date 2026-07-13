import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_203_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,139,223}, reject := .fullRank { members := ![0,1,17,34,52,71,139,223], points := ![90,93,104,106,121,154], inverse := ![3,8,12,15,3,10,10,0,0,4,0,14,4,14,6,15,1,2,2,8,6,5,12,5,8,4,8,6,15,13,1,3,12,0,11,5] } }
theorem leafL_203_0_valid : (leafL_203_0).reject.ValidFor (leafL_203_0).leaf := by decide

noncomputable def leafL_203_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,139,224}, reject := .fullRank { members := ![0,1,17,34,52,71,139,224], points := ![92,101,104,120,124,126], inverse := ![15,5,13,8,1,15,9,13,3,9,15,1,0,0,0,1,3,2,8,0,15,15,8,0,0,15,15,12,14,2,0,11,11,3,9,10] } }
theorem leafL_203_1_valid : (leafL_203_1).reject.ValidFor (leafL_203_1).leaf := by decide

noncomputable def leafL_203_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,139,246}, reject := .fullRank { members := ![0,1,17,34,52,71,139,246], points := ![92,101,104,110,121,124], inverse := ![15,6,7,9,11,13,9,3,1,12,0,7,0,15,4,11,0,0,8,15,11,11,9,14,0,13,3,14,1,1,0,11,11,0,11,11] } }
theorem leafL_203_2_valid : (leafL_203_2).reject.ValidFor (leafL_203_2).leaf := by decide

noncomputable def leafL_203_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,139,259}, reject := .fullRank { members := ![0,1,17,34,52,71,139,259], points := ![92,104,106,110,120,121], inverse := ![15,0,0,8,6,0,9,14,1,1,4,3,0,7,4,3,0,0,8,10,1,4,8,15,0,3,7,4,11,11,0,13,12,1,9,9] } }
theorem leafL_203_3_valid : (leafL_203_3).reject.ValidFor (leafL_203_3).leaf := by decide

noncomputable def leafL_203_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,140,169}, reject := .fullRank { members := ![0,1,17,34,52,71,140,169], points := ![94,96,99,104,106,122], inverse := ![14,1,4,11,7,6,8,1,12,4,6,7,0,0,1,14,15,0,6,14,1,6,8,7,11,11,7,0,7,0,9,9,12,7,11,0] } }
theorem leafL_203_4_valid : (leafL_203_4).reject.ValidFor (leafL_203_4).leaf := by decide

noncomputable def leafL_203_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,140,173}, reject := .fullRank { members := ![0,1,17,34,52,71,140,173], points := ![94,96,104,106,122,126], inverse := ![5,10,12,4,2,4,6,15,13,3,11,12,6,6,11,11,1,1,0,8,3,12,6,1,10,10,8,8,7,7,7,7,14,14,12,12] } }
theorem leafL_203_5_valid : (leafL_203_5).reject.ValidFor (leafL_203_5).leaf := by decide

noncomputable def leafL_203_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,140,181}, reject := .fullRank { members := ![0,1,17,34,52,71,140,181], points := ![94,96,109,120,127,147], inverse := ![5,8,4,3,14,5,4,13,14,15,8,0,7,6,6,15,3,11,13,9,1,11,3,13,14,9,1,15,13,4,15,3,14,9,6,13] } }
theorem leafL_203_6_valid : (leafL_203_6).reject.ValidFor (leafL_203_6).leaf := by decide

noncomputable def leafL_203_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,140,182}, reject := .fullRank { members := ![0,1,17,34,52,71,140,182], points := ![93,94,104,106,122,126], inverse := ![6,9,14,6,8,14,5,12,14,0,4,3,2,2,4,4,7,7,9,1,4,11,14,9,6,6,10,10,13,13,12,12,10,10,11,11] } }
theorem leafL_203_7_valid : (leafL_203_7).reject.ValidFor (leafL_203_7).leaf := by decide

noncomputable def leavesL_203 : List RejectedLeaf := [leafL_203_0,leafL_203_1,leafL_203_2,leafL_203_3,leafL_203_4,leafL_203_5,leafL_203_6,leafL_203_7]

theorem leavesL_203_valid : LeafListValid leavesL_203 := by
  intro x hx
  simp only [leavesL_203, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_203_0_valid
  · exact leafL_203_1_valid
  · exact leafL_203_2_valid
  · exact leafL_203_3_valid
  · exact leafL_203_4_valid
  · exact leafL_203_5_valid
  · exact leafL_203_6_valid
  · exact leafL_203_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
