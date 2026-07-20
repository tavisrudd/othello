# C222 — compact Lean closure of the `A3/H3` synthesis

**Lane:** `clebsch`

**Status:** ACTIVE; compact-proof gate. The coordinate and finite-arrangement leaf is kernel-checked
without generated certificates. The downstream decoder corollary
`lean/RelativeConicArcs/ReflectionArrangementDecoding.lean` is the sole uncommitted task path; it
must receive its focused build after the foreign Q25 owner releases the shared Lean lock.

## Objective

Kernel-check the mathematical layer introduced by C211 without replacing its short conceptual
proofs by large generated certificate trees. Reuse the existing Clebsch decoder and finite-geometry
formalization wherever possible.

The desired boundary is:

1. formalize the quadratic parameter relation used for the projectivized `H3` coordinates and its
   specialization to `F_11`;
2. verify the 15 mirrors, six fivefold points, and the `10` triple plus `15` double intersection
   ledger, together with the displayed projectivity to the Clebsch columns and dual secants;
3. verify the `A3` frame arrangement and its intersection ledger over `F_5`;
4. derive the arrangement complement counts and connect the resulting strata to the existing
   `Q11DecodingSynthesis` statements used by the manuscript; and
5. run focused axiom checks and update the manuscript's verification table only after the relevant
   declarations are kernel-backed.

## Compactness gate

Proceed only if the proof can be expressed through reusable definitions, small finite extensional
checks, matrix/projective identities, and short counting arguments. Do **not** generate or commit a
large case-split certificate tree merely to eliminate the Python checker.

If a subclaim requires such a tree, stop that subclaim, record the exact obstruction and estimated
certificate size, and leave the manuscript's current computer-assisted label intact. A compact
formalization of a strict subset may land only when the verification table names that subset
precisely.

## Out of scope

- the unrelated exhaustive `q=11`/`q=13` small-arc exclusions;
- a general Coxeter-arrangement library or the C212 reconstruction program;
- replacement of already honest Python-backed claims when no compact kernel proof is available;
- the two existing Dye consequences already isolated as axioms.

## Success criterion

C222 is complete when every new C211 claim named in the objective is either supported by focused,
axiom-audited Lean declarations or explicitly retained as computer-assisted with a documented
compactness obstruction. No large generated certificate tree is an acceptable deliverable.

## Required durable report and fixed trust standard

This file is both the cold-read task specification and the required final report. Complete it in
place with the exact mathematical statement of every C211 subclaim, its final trust route, fully
qualified Lean theorem and gate where applicable, exact validation and `#print axioms` evidence,
compactness measurements for any stopped subclaim, and the proposed C320 ledger rows. Do not leave
“compact if possible,” “standard,” or “follows” as a final classification.

For each subclaim choose exactly one completed route: full-trust Lean; exact replay/certificate;
conceptual proof with named classical inputs; or an explicitly decomposed combination. A subclaim
retained as computer-assisted must not be imported, described, or inherited as Lean-formalized by an
aggregate gate. Lean source and referee-facing artifacts contain no task IDs, agents, sessions,
private-note references, workflow chronology, unsupported novelty language, or comments stronger
than the theorem type. Internal reports point forward to exact Lean declarations, never conversely.

## Required judgment-call record

Record every choice to formalize, rescope, stop, add a hypothesis, use a coordinate representation,
retain external evidence, or reject a certificate tree. For each give the alternatives, mathematical
and measured evidence, exact theorem/paper/trust impact, rejected alternatives, and reopening
condition. A compactness stop requires the attempted theorem, first obstruction, representative
measurement, projected artifact shape/size, and the precise weaker exit retained.

## Required closing review and archival checklist

Keep C222 live. After implementation and completion of this report/checklist, explicitly request an
independent referee-style review of the actual Lean types, definitions, module prose, gate, trust
boundary, and evidence. Any finding or `NO-GO` blocks completion and archival. Fix every issue or
narrow the claimed exit, update the report and C320 delta, and request post-fix review. Only a
recorded final `GO` permits C222 to be marked complete and archived.

- [ ] State every objective subclaim in ordinary mathematics with exact field, coordinates,
  quantifiers, nondegeneracy assumptions, conventions, hypotheses, and conclusion.
- [ ] Assign every subclaim one final trust route and separate conditional/external clauses; no
  result inherits a Lean label from sharing a module or gate.
- [ ] Read definitions and theorem types to exclude vacuity, conclusions baked into definitions,
  weakened quantifiers, hidden assumptions, empty domains, and prose/names stronger than types.
- [ ] Record exact owned files, permitted imports, fully qualified terminals, import-only gate,
  pinned commit, guarded/gate validation, and `#print axioms` for every claimed Lean terminal.
- [ ] Confirm no `sorryAx`, `native_decide`, undisclosed project axiom, opaque oracle, large generated
  case tree, or unreported non-kernel execution occurs in a full-trust closure.
- [ ] For any finite computation, record checker and soundness theorem, domain/coverage,
  generator/schema/data/hash, independent replay, and residual trusted boundary.
- [ ] Recompute hashes/byte counts after final edits and distinguish identity/reproducibility from
  mathematical correctness.
- [ ] Review the entire touched Lean artifact for self-contained comments/names, exact trust prose,
  one-way internal references, factual citations, and no novelty/strength overclaim.
- [ ] Include the exact public theorem statements and load-bearing definitions, or a deterministic
  extraction, for the paper adequacy appendix.
- [ ] State every exclusion and compactness stop precisely and confirm the manuscript verification
  map retains the correct computer-assisted label.
- [ ] Complete the judgment-call record and proposed C320 row for every objective subclaim.
- [ ] Record independent review findings, fixes, post-fix review, and final `GO`.
- [ ] Only after final `GO`, archive the live task row with this completed report and evidence.
