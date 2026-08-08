# C892 — Paper II Lean and trust-boundary review

**Lane:** `clebsch`

**Status:** active 2026-08-08; independent review has reached a **MAJOR / NO-GO**
verdict and is recorded in
`../2026-08-08-c892-paper-ii-lean-trust-boundary-review.md`.  The guarded gates
and the full Lean-independent standalone aggregate are green; the already
launched authoritative aggregate still needs its final completion envelope
observed before lifecycle closeout.  This task may write its audit records and
lifecycle docs, but it does not own repairs to Lean, manuscript, verification,
export, or standalone-release files.

## Objective

Review the complete Lean surface for *Quadratic trade rigidity and cubic
orientation in conic matching quotients* and decide whether the paper states
its formal and computational trust boundary exactly.  Reconstruct the result
from the manuscript claims, not from prior task reports, and test the current
artifact at the referee standard in `lean/AGENTS.md` and
`papers/style-guide.md`.

## Scope

1. Inventory every mathematical assertion that the manuscript or verification
   apparatus presents as Lean-checked, certificate-checked, independently
   replayed, or human/classical, including the fixed-line family and all four
   Paper II gates.
2. Resolve the exact project-owned transitive closure of the gates from the
   maintained verification entry points.  Account separately for shared
   `ProjectiveCap` dependencies and for every generated source, generator,
   schema, certificate, manifest, transcript, and fingerprint used by the
   release claim.
3. Compare every paper-facing terminal's elaborated type and axiom footprint
   with the manuscript, theorem map, trust manifest, verification README,
   statement identity, and release metadata.  Check quantifiers, field and
   characteristic hypotheses, exceptional cases, equivalence conventions,
   and the distinction between a formal theorem and a human identification.
4. Review every project-owned file in the closure for self-contained module
   and declaration documentation, stable mathematical names, generated-source
   provenance, computational-method disclosure, public-literature citations,
   and the absence of private workflow references, status prose, novelty
   claims, `sorry`, project axioms, unsafe declarations, `native_decide`, and
   compiled-evaluation axioms.
5. Test the rejecting side of the trust boundary: stale statement counts,
   altered expected axioms, omitted terminals or modules, checksum drift,
   source-policy violations, and a mismatch between claimed and actual
   closure must fail rather than remain self-consistent.
6. Replay the four guarded Lean gates, the exact axiom audit, metadata-only
   checks, and the complete authoritative release verifier through their
   documented entry points.  Treat the standalone repository as downstream
   read-only evidence and do not publish or synchronize it.
7. Produce a dated referee report with severity-ranked findings, exact source
   locations and declaration names, a claim-to-evidence matrix, an explicit
   trust-boundary verdict, and bounded remediation ownership.  Run an
   `ej`+`tt` closeout after the main gate and include a mystery ledger.

## Owned paths

- this task card;
- the C892 row in `notes/2026-07-07-codex-task-queue.md` and its lifecycle
  archive row;
- `notes/handoffs/2026-07-13-clebsch-paper.md` and its archive if lifecycle
  cleanup needs history moved out of the live map;
- `notes/2026-08-08-c892-paper-ii-lean-trust-boundary-review.md`; and
- the Clebsch discovery track only if the discriminator admits a genuinely
  incidental observation.

All Lean, manuscript, verification, export, and standalone-paper paths are
read-only under C892.  A repair needs explicit authorization and its owning
task.

## Acceptance gate

- Every manuscript/formal-coverage claim is mapped to an exact Lean terminal
  or is classified honestly as human, cited, certificate-checked, or trusted
  execution, with no unreviewed ledger row.
- The exact transitive verification closure and all non-Lean dependencies are
  accounted for, including the accepted shared-projective-cap boundary.
- Every project-owned file in that closure passes a semantic referee-prose and
  naming review; automated scans are only corroboration.
- The actual axiom transcript contains only the declared foundational
  allowlist, with no admitted, unsafe, native, or compiled-evaluation escape.
- Negative mutation tests show that the verifier rejects stale statement,
  terminal, axiom, source, checksum, and closure metadata.
- The four guarded gates and the complete authoritative Paper II release
  verifier pass from the current task-owned state, or each failure is reduced
  to an exact reproducible finding without changing the artifact.
- The dated report gives a clear `GO`, `MINOR`, or `MAJOR` verdict and assigns
  every open defect to C577 or to a separately allocated successor without
  silently broadening this review into repair work.

## Relationship to current work

C892 audits the current post-C856/C860 surface independently.  It does not
reopen those completed tasks by default and does not replace C577's ownership
of the immutable locator, downstream synchronization, or publication decision.
