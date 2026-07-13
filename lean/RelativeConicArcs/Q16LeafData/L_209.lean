import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_209_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,147,181}, reject := .fullRank { members := ![0,1,17,34,52,71,147,181], points := ![91,96,120,124,140,141], inverse := ![0,7,9,7,4,12,14,9,3,10,1,15,2,2,11,11,1,1,15,8,13,5,6,9,6,6,13,13,4,4,5,5,3,3,13,13] } }
theorem leafL_209_0_valid : (leafL_209_0).reject.ValidFor (leafL_209_0).leaf := by decide

noncomputable def leafL_209_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,147,182}, reject := .fullRank { members := ![0,1,17,34,52,71,147,182], points := ![91,92,96,101,110,122], inverse := ![15,15,15,8,0,6,7,6,8,9,7,7,11,13,6,0,0,0,2,8,2,0,15,7,1,0,1,8,8,0,6,3,5,2,2,0] } }
theorem leafL_209_1_valid : (leafL_209_1).reject.ValidFor (leafL_209_1).leaf := by decide

noncomputable def leafL_209_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,147,207}, reject := .fullRank { members := ![0,1,17,34,52,71,147,207], points := ![90,91,92,101,110,120], inverse := ![0,0,15,0,8,6,14,9,14,12,2,7,7,14,9,0,0,0,7,3,12,5,10,7,6,9,15,8,8,0,13,8,5,2,2,0] } }
theorem leafL_209_2_valid : (leafL_209_2).reject.ValidFor (leafL_209_2).leaf := by decide

noncomputable def leafL_209_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,147,214}, reject := .fullRank { members := ![0,1,17,34,52,71,147,214], points := ![90,96,101,122,128,169], inverse := ![2,10,1,0,13,5,7,13,11,6,3,4,11,3,11,13,12,2,2,12,5,0,3,8,6,3,15,6,0,12,10,10,0,10,10,0] } }
theorem leafL_209_3_valid : (leafL_209_3).reject.ValidFor (leafL_209_3).leaf := by decide

noncomputable def leafL_209_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,147,232}, reject := .fullRank { members := ![0,1,17,34,52,71,147,232], points := ![92,101,106,110,126,128], inverse := ![15,6,4,10,11,13,9,0,9,7,14,9,0,8,1,9,0,0,8,4,10,1,10,13,0,9,7,14,8,8,0,3,8,11,7,7] } }
theorem leafL_209_4_valid : (leafL_209_4).reject.ValidFor (leafL_209_4).leaf := by decide

noncomputable def leafL_209_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,147,233}, reject := .fullRank { members := ![0,1,17,34,52,71,147,233], points := ![91,96,101,106,124,128], inverse := ![5,10,7,15,14,8,8,1,15,1,6,1,7,7,4,4,15,15,7,15,0,15,3,4,8,8,15,15,2,2,6,6,2,2,1,1] } }
theorem leafL_209_5_valid : (leafL_209_5).reject.ValidFor (leafL_209_5).leaf := by decide

noncomputable def leafL_209_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,147,237}, reject := .fullRank { members := ![0,1,17,34,52,71,147,237], points := ![90,91,92,106,110,122], inverse := ![3,0,12,1,9,6,9,0,0,14,0,7,7,14,9,0,0,0,12,1,5,0,15,7,1,7,6,1,1,0,8,2,10,13,13,0] } }
theorem leafL_209_6_valid : (leafL_209_6).reject.ValidFor (leafL_209_6).leaf := by decide

noncomputable def leafL_209_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,147,248}, reject := .fullRank { members := ![0,1,17,34,52,71,147,248], points := ![91,92,96,101,106,126], inverse := ![6,3,10,15,7,6,12,2,7,1,15,7,11,13,6,0,0,0,7,8,7,3,12,7,15,4,11,3,3,0,12,2,14,4,4,0] } }
theorem leafL_209_7_valid : (leafL_209_7).reject.ValidFor (leafL_209_7).leaf := by decide

noncomputable def leavesL_209 : List RejectedLeaf := [leafL_209_0,leafL_209_1,leafL_209_2,leafL_209_3,leafL_209_4,leafL_209_5,leafL_209_6,leafL_209_7]

theorem leavesL_209_valid : LeafListValid leavesL_209 := by
  intro x hx
  simp only [leavesL_209, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_209_0_valid
  · exact leafL_209_1_valid
  · exact leafL_209_2_valid
  · exact leafL_209_3_valid
  · exact leafL_209_4_valid
  · exact leafL_209_5_valid
  · exact leafL_209_6_valid
  · exact leafL_209_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
