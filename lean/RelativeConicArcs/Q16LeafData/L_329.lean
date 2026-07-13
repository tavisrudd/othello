import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_329_0 : RejectedLeaf := { leaf := {0,1,17,34,54,121,143,206}, reject := .fullRank { members := ![0,1,17,34,54,121,143,206], points := ![67,74,75,83,84,100], inverse := ![6,14,15,13,9,2,13,8,4,0,6,7,6,3,5,0,0,0,12,7,10,10,13,6,11,4,15,10,10,0,14,5,11,6,6,0] } }
theorem leafL_329_0_valid : (leafL_329_0).reject.ValidFor (leafL_329_0).leaf := by decide

noncomputable def leavesL_329 : List RejectedLeaf := [leafL_329_0]

theorem leavesL_329_valid : LeafListValid leavesL_329 := by
  intro x hx
  simp only [leavesL_329, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl
  · exact leafL_329_0_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
