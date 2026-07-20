# C422 / F3 — Lean low-degree harmonic quotient

**Lane:** `clebsch`

**Status:** queued task brief

This file is both the cold-read task specification and the required durable result report. Complete
it in place; do not substitute a chat summary or a second transient document. The finished report
must contain the result, exact theorem types and owned artifacts, validation and axiom evidence,
trust/exclusion boundary, every judgment call, independent review and dispositions, and the C320
ledger delta.

## Required outcome and trust route

Formalize the conic Laplacian and the harmonic/radial decompositions in exactly degrees `1`, `2`,
and `4` over `F_5`, `F_7`, and `F_11`, with explicit invertibility hypotheses, then connect C421's
quotient to those decompositions. These bounded symbolic exits are required full-trust Lean results.
A general Fischer decomposition is optional and receives no trust claim unless it actually lands.

## Cold-read execution brief

- Own only `lean/RelativeConicArcs/ClebschHarmonicQuotient.lean`,
  `lean/RelativeConicArcs/Gates/ClebschHarmonicQuotient.lean`, and this report. No generated data
  are expected; do not create a certificate tree to avoid the symbolic proof.
- Import the committed public API of `RelativeConicArcs.ClebschConicMatchingQuotient`; do not edit
  C421 or any `ClebschGateway*` module.
- Define the conic Laplacian `4 ∂X∂Z − ∂Y²` and prove the harmonic/radial decompositions and
  dimension formulas actually needed in degrees `1`, `2`, and `4`, separately accounting for
  characteristics `5`, `7`, and `11`. Every division or coefficient inversion appears as an
  explicit hypothesis or a proved finite-field fact.
- Prove the bridge from the C421 conic-ideal quotient to the bounded decomposition. Do not merely
  define “harmonic” so that the decomposition is tautological, freeze decomposed coefficients as
  data, or infer a projective statement from an affine polynomial identity without a bridge.
- Do not build a general Fischer-decomposition library. If the bounded theorem unexpectedly needs
  a new architecture or cannot meet the `single` profile, stop and report the exact obstruction;
  do not weaken degrees, fields, quantifiers, or the claimed trust tier.
- Exit only through `RelativeConicArcs.Gates.ClebschHarmonicQuotient`, with exact guarded
  elaboration, exact-target gate confirmation, and terminal axiom audit recorded here.

## Required judgment-call record

Before review, add a completed section here for every implementation or scope choice a later agent
could reasonably question. For each choice record: the question; admissible options; chosen option;
mathematical and measured evidence; effect on theorem statement, trust tier, imports, gate, and
paper claim; rejected alternatives; and the exact condition for reopening it. Include decisions to
omit an optional theorem, use or reject a certificate, weaken or generalize a statement, add a
hypothesis, choose a finite representation, stop after a measured failure, or classify a result as
external. “Obvious,” “standard,” “if feasible,” and an unrecorded absence of work are not
dispositions. If no judgment call occurred, state that explicitly and explain why execution was
fully forced by this brief.

## Required closing review process

The implementer first completes the checklist and a claim-by-claim ledger delta. A separate
referee-style reviewer then reads the actual theorem types, module prose, proof/trust boundary, gate,
and evidence; issues a recorded `GO` or `NO-GO`; and lists every finding. The implementer resolves
each finding or narrows the claimed exit explicitly. The task cannot close until the final
disposition and ledger delta agree with the landed artifact.

- [ ] State every claimed exit in ordinary mathematics, with exact domain, hypotheses, conclusion,
  and correspondence to the intended paper statement.
- [ ] Assign each exit exactly one final route: full-trust Lean, exact replay/certificate,
  conceptual proof with named classical inputs, or an explicitly decomposed combination.
- [ ] Read the definitions and theorem types themselves: rule out vacuous predicates, conclusions
  baked into definitions or frozen data, weakened quantifiers, hidden typeclass/characteristic or
  nondegeneracy assumptions, empty domains, and theorem names or prose stronger than the type.
- [ ] Verify that every claimed terminal is actually imported by the named gate and that validation
  is trace-current for the final source; a green dependency, stale build, report verdict, or
  authoritative-sounding filename is not evidence for an omitted theorem.
- [ ] Remove or separately classify every optional, conditional, failed, “standard,” “follows,” or
  “if feasible” clause; no such clause inherits the module or gate's strongest label.
- [ ] Record exact owned files, fully qualified terminal names, import-only gate, pinned commit,
  validation command/result, and `#print axioms` output for every terminal.
- [ ] Include the exact public theorem statements and load-bearing definitions, or a deterministic
  extraction committed with the report, for the paper's verbatim statement-adequacy appendix.
- [ ] Confirm no `sorryAx`, `native_decide`, undisclosed project axiom, opaque oracle, or unreported
  non-kernel execution occurs in the claimed dependency closure.
- [ ] For every finite/computational claim, record the checker and soundness theorem, finite domain,
  generator/schema/data/hash, independent replay, exhaustive-versus-search status, and residual
  trusted boundary; write “not applicable” only with a reason.
- [ ] Recompute byte counts and hashes only after the final source/evidence edit and compare them to
  the committed files; hashes establish identity, not mathematical correctness or regeneration.
- [ ] List every cited or axiomatized input and what remains unconditional without it.
- [ ] Review the entire touched module, names, filenames, comments, docstrings, banners, diagnostics,
  and changed verification artifacts for mathematical accuracy and referee-facing self-containment.
- [ ] Confirm internal records point to exact Lean declarations while Lean and verification
  artifacts contain no reverse references, task IDs, workflow language, or unsupported novelty or
  strength claims.
- [ ] State exclusions and negative boundaries explicitly, including what the task and gate do not
  prove.
- [ ] Complete the judgment-call record with evidence, trust impact, rejected alternatives, and
  reopening conditions; ensure the verification map and ledger use the chosen final route.
- [ ] Record the independent reviewer's identity, date, `GO`/`NO-GO`, findings, and dispositions.
- [ ] Supply C320 with one ledger row per claim and the exact verify-all entry-point delta.
