# C423 / F4 — Lean Clebsch factorization leaves

**Lane:** `clebsch`

**Status:** queued task brief

This file is both the cold-read task specification and the required durable result report. Complete
it in place; do not substitute a chat summary or a second transient document. The finished report
must contain the result, exact theorem types and owned artifacts, validation and axiom evidence,
trust/exclusion boundary, every judgment call, independent review and dispositions, and the C320
ledger delta.

## Required outcome and trust route

Land separate A3, B3, and H3 checker leaves proving image ranks `3,6,10`, the required lower signed
moment cancellations, and the nonzero B3/H3 cubic witnesses. Each paper claim is full-trust Lean
only when untrusted literal data are connected to it by a proved checker, the generated evidence
bundle and independent replay land atomically, and the light gate and axiom audit pass. A leaf that
cannot meet the measured profile stops for a revised sharding plan; it is not silently downgraded
inside this task.

## Cold-read execution brief

- Own only `lean/RelativeConicArcs/ClebschFactorizationData.lean`, the separate
  `ClebschFactorizationA3.lean`, `ClebschFactorizationB3.lean`, and
  `ClebschFactorizationH3.lean` leaves, `lean/RelativeConicArcs/Gates/ClebschFactorization.lean`,
  and the same-stem `.md/.py/.json/.sha256` evidence bundle in `notes/`.
- Import C422's committed harmonic-quotient API. Freeze the audited C406 quotient coordinates as
  untrusted literal input; do not freeze rank, vanishing, nonvanishing, character, or orbit
  conclusions as definitions.
- Prove image ranks `3`, `6`, and `10`. For B3 and H3 prove signed first- and second-moment
  vanishing and a nonzero cubic witness. Certify the cubic by one explicitly named linear
  functional and the scalar sum over 14 or 22 matchings, not a full symmetric-tensor equality.
- Split H3 from A3/B3 at a module boundary. The base/data module contains definitions only; each
  leaf invokes a small generic predicate and soundness theorem; the aggregator is light.
- The generator output is canonical and deterministic and records semantics, schema, hashes, byte
  counts, exact replay command, and an independent implementation or invariant check. A hash proves
  identity only; the Lean checker proves the accepted proposition.
- Benchmark one representative shard before generating a tree. If the `single` profile fails, stop
  with measured evidence and a revised sharding proposal; do not hand-edit generated leaves,
  silently move a required claim outside Lean, or touch Q25/certificate closures owned elsewhere.
- Exit only through `RelativeConicArcs.Gates.ClebschFactorization` after all three leaves are green
  and the exact terminal axiom audit is recorded here.

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

**Archival gate:** keep the task row live. After implementation, explicitly request the independent
review; do not infer that review from a build, report, or agent self-check. Any finding or `NO-GO`
blocks completion and archival. Fix every issue, update the artifact/report/checklist/ledger delta,
and request post-fix review. Only a recorded final `GO` permits the task to be marked complete and
archived under the repository completion invariant.

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
