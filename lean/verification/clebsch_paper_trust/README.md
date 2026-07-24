# Clebsch paper trust audit

`RelativeConicArcs/Gates/ClebschPaperTrust.lean` is the import-only formal surface for the
factorization-memory paper.  It imports every paper-facing gate and issues `#print axioms` for the
terminals cited by the paper's claim ledger.

Run the audit from the shared Lean repository root:

```text
scripts/guarded-lean RelativeConicArcs/Gates/ClebschPaperTrust.lean
```

`axiom-audit.txt` is the raw standard output from a successful elaboration.  Its entries are Lean's
exact dependency report for the pinned source.  Most terminals use only `propext`,
`Classical.choice`, and `Quot.sound`, or a subset.  The exhaustive degree-twelve assignment and
no-inner-witness leaves additionally disclose their declaration-local native-decision axioms.

This audit establishes elaboration and axiom closure of the named formal statements.  It does not
identify literal finite tables with classical Coxeter groups, projective groups, association
schemes, Mathieu groups, Weil representations, theta characteristics, or quantum states.  Those
semantic bridges are separately identified in the paper's trust ledger and replay artifacts.
