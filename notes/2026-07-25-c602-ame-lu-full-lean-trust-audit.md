# C602 plan: full AME-LU Lean and trust audit

**Lane:** `ame-lu`

## Goal

After C601, audit the complete referee-facing Lean companion against the
paper's trust ledger, statement-adequacy map, verification prose, paper style
guide, and `lean/AGENTS.md`. Repair task-owned defects, rerun the full AME-LU
formal gates, and leave an exact declaration-by-declaration account of what is
unconditional, conditional, computational, native, or unformalized.

## Scope

The review covers:

- every manuscript result for which Section 8 or either formal ledger claims
  Lean coverage;
- every module imported by `RelativeConicArcs.Gates.AMELUAggregate`;
- every AME-LU gate and axiom-audit module;
- every project-owned generator, schema, template, certificate, data file,
  generated banner, and diagnostic in those terminals' transitive verification
  closure;
- the corresponding formal ledgers, manuscript verification section, and
  release/export manifests.

Read-only shared dependencies remain in audit scope. A defect outside the
`ame-lu` ownership boundary is recorded with its exact path, declaration,
downstream claim, and required owning successor rather than repaired
opportunistically.

## Review matrix

For every paper-facing declaration, record:

1. exact manuscript label and mathematical correspondence;
2. unconditional theorem versus conditional structure fields;
3. complete `#print axioms` output and native, generated, certificate, or
   external trust;
4. whether every manuscript premise is constructed in Lean;
5. the full transitive project-owned verification closure;
6. module header, public docstring, name strength, convention, degeneracy, and
   field-scope adequacy;
7. absence of `sorry`, hidden axioms, opaque oracles, workflow identifiers,
   reverse references, status prose, private paths, and unsupported novelty or
   priority language;
8. agreement among theorem type, comments, paper prose, ledgers, evidence
   manifest, and release artifact.

The audit distinguishes the three native graph-cardinality checks from
ordinary kernel proofs and re-evaluates every conditional input after C601;
historical ledger text is not evidence.

## Validation and acceptance

- Repair every defect in task-owned AME-LU modules, gates, scholarly support
  artifacts, and paper trust prose.
- Run guarded elaboration for touched modules, then the documented AME-LU
  import gates, axiom audits, exact-target `--no-build` checks, and final
  trace-only aggregate gate.
- Inspect the whole content of every touched module and every changed
  generator/template/generated closure, not merely the diff.
- Produce a compact final audit table with no unresolved task-owned mismatch.
- Record foreign-closure defects as explicit blockers or allocated successors;
  do not waive them while calling the artifact referee-ready.
- Rebuild and inspect the paper if trust prose changes, and verify that public
  and formal export manifests still describe the exact source identities.
- End with an `ej` plus Tao-style adversarial pass: ask what a skeptical
  formalizer and referee could still infer too strongly, repair cheap defects,
  and state every remaining trust boundary without rhetoric.

## Principal adversarial questions

- Does the headline theorem prove that each displayed intertwiner is Clifford,
  rather than merely equality of LU and LC orbit partitions?
- Are prime-power and odd-prime-field scopes separated everywhere, including
  names and docstrings?
- Do conditional structures expose every substantive manuscript input, or
  does a convenient field hide a theorem-sized assertion?
- Does any exact finite result rely on a trusted generator without a proved
  checker and coverage theorem?
- Can a reader understand every theorem and trust route without the task
  queue, handoff, reports, local paths, or manuscript section numbers?
- Does any name advertise classification, completeness, canonicity,
  minimality, or sharpness beyond its formal type?
- Are the three native checks the only nonstandard audit outputs, and does the
  paper describe them at the right evidentiary level?

