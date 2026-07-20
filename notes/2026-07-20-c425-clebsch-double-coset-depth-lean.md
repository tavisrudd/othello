# C425 / F6 — Lean double-coset depth–Fourier–parent bridge

**Lane:** `clebsch`

**Status:** queued task brief

This file is both the cold-read task specification and the required durable result report. Complete
it in place; do not substitute a chat summary or a second transient document. The finished report
must contain the result, exact theorem types and owned artifacts, validation and axiom evidence,
trust/exclusion boundary, every judgment call, independent review and dispositions, and the C320
ledger delta.

## Required outcome and trust route

The finite leaves freeze representatives, relation cells, and action generators—not the six output
profiles as asserted facts. Lean must derive the partition, scalar closure, K-invariance, recounting,
antipodal sign law, fibre sizes, plane equations, rank/kernel facts, and decorated-parent recovery
through checker theorems. The all-degree parity and primitive `1:4:6` strengthening remain optional
and receive no trust claim unless their theorems actually land.

## Cold-read execution brief

- Own only `lean/RelativeConicArcs/ClebschDoubleCosetDepthData.lean`,
  `ClebschDoubleCosetDepthBase.lean`, `ClebschDoubleCosetDepthPositive.lean`,
  `ClebschDoubleCosetDepthNegative.lean`, `ClebschDoubleCosetDepth.lean`,
  `lean/RelativeConicArcs/Gates/ClebschDoubleCosetDepth.lean`, and the same-stem
  `.md/.py/.json/.sha256` evidence bundle.
- Import the committed C420 and C424 APIs plus
  `RelativeConicArcs.ClebschGatewayQ11Fusion` and
  `RelativeConicArcs.ClebschGatewayQ11Matching`; do not edit those dependencies.
- Build a definitions-only concrete `G=PGL_2(11)`, `H=A5`, `K=A4` action base. Freeze exactly six
  representative secant unions, sixteen relation cells, and K/J generators as untrusted data.
  Do not freeze the six signed output profiles or equivariance assertions.
- Split positive and negative representative checks across module boundaries. Prove the cells
  partition the relevant projective sets, are scalar-closed and K-invariant, and recount to
  `±v1, ±v2, ±v3` with fibre sizes `1,4,6 / 1,4,6`, both plane equations, and
  `v1+4v2+6v3=0`.
- Prove J carries each representative secant union to its mate and derive `D(JM)=-D(M)` from that
  geometry. Prove the six-dimensional domain, rank-two image, four-dimensional kernel, and
  set-theoretic separation; do not substitute a definition or generated assertion for equivariance.
- Compose with the existing odd-Fourier and matching terminals and prove that a singleton profile
  recovers the unordered golden matching pair, then invoke the exact decorated-parent theorem for a
  chosen singleton matching.
- General modular Hecke theory, all-degree parity, and primitive integral dependence are not
  required. The latter two remain separate optional claims and receive no label unless their exact
  theorems land without delaying the mandatory bridge.
- Exit only through `RelativeConicArcs.Gates.ClebschDoubleCosetDepth` with a light aggregator,
  canonical evidence bundle, independent replay, and terminal axiom audit.

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
