import WeightedRules.RelationalSupportChecks

/-!
# Axiom audit for finite relational support

These declarations audit the symbolic proof that a closed, ranked-supported
finite ground-atom set is the least fixed point, and the separate exactness
lemma for a column-restricted complement. No executable parser, grounding
procedure, or certificate byte decoder is imported by these theorems.
-/

/-- info: 'WeightedRules.RelationalSupport.rankedSupport_derivable' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.RelationalSupport.rankedSupport_derivable
/-- info: 'WeightedRules.RelationalSupport.closed_rankedSupport_iff_derivable' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.RelationalSupport.closed_rankedSupport_iff_derivable
/-- info: 'WeightedRules.RelationalSupport.closed_rankedSupport_leastFixed' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.RelationalSupport.closed_rankedSupport_leastFixed
/-- info: 'WeightedRules.RelationalSupport.groundAtoms_leastFixed' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.RelationalSupport.groundAtoms_leastFixed
/-- info: 'WeightedRules.RelationalSupport.chain_derivable_all' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.RelationalSupport.chain_derivable_all
/-- info: 'WeightedRules.RelationalSupport.cycle_closed_but_not_rankedSupported' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.RelationalSupport.cycle_closed_but_not_rankedSupported
/-- info: 'WeightedRules.RelationalSupport.restrictedComplement_exact' does not depend on any axioms -/
#guard_msgs in
#print axioms WeightedRules.RelationalSupport.restrictedComplement_exact
/-- info: 'WeightedRules.RelationalSupport.empty_column_excludes_positive' does not depend on any axioms -/
#guard_msgs in
#print axioms WeightedRules.RelationalSupport.empty_column_excludes_positive
