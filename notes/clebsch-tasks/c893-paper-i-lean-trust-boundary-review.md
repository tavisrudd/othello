# C893 — Paper I Lean and trust-boundary review

**Lane:** `clebsch`

**Status:** complete 2026-08-08; independent review verdict **MAJOR**.  Full
report: `notes/2026-08-08-c893-paper-i-lean-trust-boundary-review.md`.  No Lean,
manuscript, verification, export, package, or standalone-release file was
edited; all remediation remains owned by C855.

## Objective

Review the complete Lean surface for *Reconstructing the Clebsch code and its
golden orientation from its deep-hole syndrome locus*, together with its
computational companion, and decide whether the papers state their formal and
computational trust boundary exactly.  Reconstruct the result from the
manuscript claims, not from prior task reports, and test the current artifact at
the referee standard in `lean/AGENTS.md` and `papers/style-guide.md`.

## Scope

1. Inventory every mathematical assertion that either paper or the verification
   apparatus presents as Lean-checked, certificate-checked, independently
   replayed, cited, human, or trusted execution, including every row of the
   combined Paper I/companion evidence surface.
2. Resolve the exact transitive closure of every Paper I gate from the maintained
   verification entry points.  Account separately for the authoritative Lean
   base, the extracted q11 certificate package, shared dependencies, and every
   generated source, generator, schema, certificate, manifest, transcript,
   fingerprint, and release-identity input used by the claim.
3. Compare every paper-facing terminal's elaborated type and axiom footprint with
   the manuscripts, theorem map, trust manifest, verification README, formal
   companion metadata, statement identity, and release metadata.  Check
   quantifiers, field and characteristic hypotheses, exceptional orders,
   projective and equivalence conventions, and the distinction between a formal
   theorem and a human or computational identification.
4. Review every project-owned file in the closure for self-contained module and
   declaration documentation, stable mathematical names, generated-source
   provenance, computational-method disclosure, public-literature citations,
   and the absence of private workflow references, status prose, novelty
   claims, `sorry`, project axioms, unsafe declarations, `native_decide`, and
   compiled-evaluation axioms.
5. Test the rejecting side of the trust boundary: stale statement counts,
   altered expected axioms, omitted terminals or modules, package/base pin or
   checksum drift, generated-source drift, source-policy violations, and a
   mismatch between claimed and actual closure must fail rather than remain
   self-consistent.
6. Replay the guarded Paper I Lean gates, the exact axiom audits, package and
   metadata checks, and the complete authoritative release verifier through
   their documented entry points.  Treat the standalone paper repository as
   downstream read-only evidence and do not publish or synchronize it.
7. Produce a dated referee report with severity-ranked findings, exact source
   locations and declaration names, a claim-to-evidence matrix, an explicit
   trust-boundary verdict, and bounded remediation ownership.  Run an `ej`+`tt`
   closeout after the main gate and include a mystery ledger.

## Owned paths

- this task card;
- the C893 row in `notes/2026-07-07-codex-task-queue.md` and its lifecycle
  archive row;
- `notes/handoffs/2026-07-13-clebsch-paper.md` and its archive if lifecycle
  cleanup needs history moved out of the live map;
- `notes/2026-08-08-c893-paper-i-lean-trust-boundary-review.md`; and
- the Clebsch discovery track only if the discriminator admits a genuinely
  incidental observation.

All Lean, manuscript, verification, export, certificate-package, and
standalone-paper paths are read-only under C893.  A repair needs explicit
authorization and its owning task.

## Acceptance gate

- Every manuscript/formal-coverage claim is mapped to an exact Lean terminal or
  is classified honestly as human, cited, certificate-checked, or trusted
  execution, with no unreviewed evidence row.
- The exact transitive verification closure and all non-Lean dependencies are
  accounted for across the authoritative base and q11 package.
- Every project-owned file in that closure passes a semantic referee-prose and
  naming review; automated scans are only corroboration.
- The actual axiom transcripts contain only the declared foundational
  allowlist, with no admitted, unsafe, native, or compiled-evaluation escape.
- Negative mutation tests show that the verifier rejects stale statement,
  terminal, axiom, source, checksum, package-pin, generated-source, and closure
  metadata.
- The guarded gates and complete authoritative Paper I release verifier pass
  from the current artifact, or each failure is reduced to an exact reproducible
  finding without changing it.
- The dated report gives a clear `GO`, `MINOR`, or `MAJOR` verdict and assigns
  every open defect to C855 or to a separately allocated successor without
  silently broadening this review into repair work.

## Relationship to current work

C893 audits the current in-progress C855 surface independently.  It neither
replaces C855's remediation ownership nor changes the immutable public v1/v2
releases.  Findings already covered by C855 remain evidence about its open
acceptance gate; genuinely new repair scope requires an owning task rather than
an incidental edit here.
