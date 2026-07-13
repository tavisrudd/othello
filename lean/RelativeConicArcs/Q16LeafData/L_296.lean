import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_296_0 : RejectedLeaf := { leaf := {0,1,17,34,52,73,158,168}, reject := .fullRank { members := ![0,1,17,34,52,73,158,168], points := ![90,91,92,106,107,128], inverse := ![5,5,15,12,4,6,0,2,11,1,15,7,7,14,9,0,0,0,6,5,11,7,8,7,10,2,8,13,13,0,14,14,0,14,14,0] } }
theorem leafL_296_0_valid : (leafL_296_0).reject.ValidFor (leafL_296_0).leaf := by decide

noncomputable def leafL_296_1 : RejectedLeaf := { leaf := {0,1,17,34,52,73,158,188}, reject := .fullRank { members := ![0,1,17,34,52,73,158,188], points := ![95,103,107,128,141,163], inverse := ![2,8,1,9,11,8,1,5,7,0,10,9,1,14,8,7,11,11,12,6,5,14,0,1,0,4,1,8,11,6,13,2,11,2,15,9] } }
theorem leafL_296_1_valid : (leafL_296_1).reject.ValidFor (leafL_296_1).leaf := by decide

noncomputable def leafL_296_2 : RejectedLeaf := { leaf := {0,1,17,34,52,73,158,199}, reject := .fullRank { members := ![0,1,17,34,52,73,158,199], points := ![86,90,95,99,107,120], inverse := ![10,11,14,7,15,6,13,15,11,12,2,7,4,9,13,0,0,0,13,13,8,0,15,7,13,10,7,9,9,0,9,8,1,15,15,0] } }
theorem leafL_296_2_valid : (leafL_296_2).reject.ValidFor (leafL_296_2).leaf := by decide

noncomputable def leafL_296_3 : RejectedLeaf := { leaf := {0,1,17,34,52,73,158,263}, reject := .fullRank { members := ![0,1,17,34,52,73,158,263], points := ![92,95,106,120,127,128], inverse := ![14,1,8,13,4,15,2,11,14,0,1,6,0,0,0,13,2,15,0,8,15,7,1,1,14,14,0,14,11,5,12,12,0,9,13,4] } }
theorem leafL_296_3_valid : (leafL_296_3).reject.ValidFor (leafL_296_3).leaf := by decide

noncomputable def leafL_296_4 : RejectedLeaf := { leaf := {0,1,17,34,52,73,158,264}, reject := .fullRank { members := ![0,1,17,34,52,73,158,264], points := ![95,106,124,125,127,140], inverse := ![6,1,1,10,4,9,10,13,14,13,7,3,0,0,15,3,12,0,8,15,15,15,7,0,9,9,13,6,2,9,10,10,0,10,0,10] } }
theorem leafL_296_4_valid : (leafL_296_4).reject.ValidFor (leafL_296_4).leaf := by decide

noncomputable def leafL_296_5 : RejectedLeaf := { leaf := {0,1,17,34,52,73,167,188}, reject := .fullRank { members := ![0,1,17,34,52,73,167,188], points := ![91,95,107,115,125,126], inverse := ![1,14,8,7,13,12,9,0,14,4,15,12,0,0,0,11,3,8,4,12,15,1,12,10,4,4,0,8,3,11,15,15,0,9,7,14] } }
theorem leafL_296_5_valid : (leafL_296_5).reject.ValidFor (leafL_296_5).leaf := by decide

noncomputable def leafL_296_6 : RejectedLeaf := { leaf := {0,1,17,34,52,73,172,183}, reject := .fullRank { members := ![0,1,17,34,52,73,172,183], points := ![86,90,91,110,128,147], inverse := ![2,14,6,5,15,1,15,8,0,12,3,8,15,6,9,0,0,0,8,10,11,9,11,11,6,9,13,12,11,5,1,14,6,3,6,12] } }
theorem leafL_296_6_valid : (leafL_296_6).reject.ValidFor (leafL_296_6).leaf := by decide

noncomputable def leafL_296_7 : RejectedLeaf := { leaf := {0,1,17,34,52,74,92,107}, reject := .fullRank { members := ![0,1,17,34,52,74,92,107], points := ![117,121,131,133,151,175], inverse := ![13,13,15,5,15,4,15,15,1,10,8,3,15,10,11,14,5,5,5,7,6,15,11,0,5,7,0,2,2,2,6,2,5,1,4,4] } }
theorem leafL_296_7_valid : (leafL_296_7).reject.ValidFor (leafL_296_7).leaf := by decide

noncomputable def leavesL_296 : List RejectedLeaf := [leafL_296_0,leafL_296_1,leafL_296_2,leafL_296_3,leafL_296_4,leafL_296_5,leafL_296_6,leafL_296_7]

theorem leavesL_296_valid : LeafListValid leavesL_296 := by
  intro x hx
  simp only [leavesL_296, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_296_0_valid
  · exact leafL_296_1_valid
  · exact leafL_296_2_valid
  · exact leafL_296_3_valid
  · exact leafL_296_4_valid
  · exact leafL_296_5_valid
  · exact leafL_296_6_valid
  · exact leafL_296_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
