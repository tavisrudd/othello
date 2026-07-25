# C603 — beyond-four PRS Lean trust audit

**Lane:** `reed-solomon` · **Status:** queued; required before C545 public release

## Objective

Audit the Lean artifact claimed by `papers/beyond4_prs/` against the paper's
adopted theorem set and trust ledger, `papers/style-guide.md`, and
`lean/AGENTS.md`.  Produce a dated, evidence-backed report that itemizes every
file, declaration, claim boundary, trust mechanism, and dependency reviewed;
records every gap without silently repairing or waiving it; and states whether
the artifact is referee-facing and release-ready at the audited commit.

This is an audit task, not a new formalization claim.  Do not strengthen a
paper statement, fill a mathematical hypothesis, edit generated Lean, or widen
the paper-facing gate while conducting the review.  Any repair requiring source
changes must be named and scoped for separate execution after the audit.

## Governing sources

Read and apply the current versions of:

- `papers/beyond4_prs/main.tex` and the actual adopted theorem set;
- `papers/beyond4_prs/claim-proof-novelty-ledger.md`;
- `papers/beyond4_prs/formalization-ledger.md`;
- `papers/beyond4_prs/supplement/LEAN-STATEMENTS.md`;
- the paper theorem map, verification map, release manifest, supplement
  reproduction instructions, toolchain pins, and fresh-export allowlist;
- `papers/style-guide.md`;
- `lean/AGENTS.md`.

The live manuscript controls scope.  Ledger rows for claims cut to companion
work must not be treated as adopted paper claims, and retained claims must not
disappear merely because a ledger is stale.

## Audit work

1. Freeze the audited source commit, dirty-path inventory, Lean toolchain,
   mathlib/`finitegeom` pins, paper-facing aggregate gate, and exact adopted
   manuscript theorem labels.
2. Compute the transitive project-owned verification closure of
   `RelativeConicArcs.Gates.PRSBeyondRedundancyFour` and its axiom-audit target.
   Review every tracked Lean file in that closure and every generator, schema,
   template, certificate, data file, banner, diagnostic, and enduring
   non-Lean artifact required by it.  Record files individually or in explicit
   mechanically defined groups with complete member lists and counts.
3. Reconcile each adopted paper theorem, proposition, corollary, and
   Lean-backed sentence with exact fully qualified declarations.  For each,
   record what the kernel proves, every hypothesis or structure field supplied
   externally, the manuscript bridge from formal definitions to paper
   definitions, and whether the ledger wording matches the elaborated type.
4. Independently check the trust route: aggregate imports, `#print axioms`,
   `sorry`, declared axioms, unsafe/native execution, opaque or external
   oracles, generated sources, imported certificates, and certificate coverage
   semantics.  Do not inherit an earlier audit verdict without reproducing or
   source-checking it.  Use only the guarded Lean entry points and the documented
   paper-facing gate; respect shared-tree ownership and staleness rules.
5. Apply the referee-facing prose and naming standards in `lean/AGENTS.md` to
   the full closure, not only changed files: module headers, public declaration
   docstrings, mathematical scope and strength, names, generated banners,
   comments, citations, diagnostics, workflow/private references, status
   language, local paths, and reverse references to internal records.
6. Apply `papers/style-guide.md` at every paper/formal interface.  Check that
   the manuscript explains the mathematics and definition correspondence,
   distinguishes kernel proof from conditional synthesis and external
   computation, names declarations and toolchains accurately, and does not use
   “verified in Lean” or stronger language beyond the audited boundary.
7. Audit dependencies in two separate tables:
   - **repository-paper mathematical dependencies:** every theorem or
     definition imported from another paper development in this repository,
     with source paper/module, exact declaration, statement used, and whether
     the dependency is necessary or merely shared infrastructure;
   - **external-paper mathematical dependencies:** every cited theorem used as
     a formal hypothesis or manuscript-to-Lean bridge, with authors, title,
     year, stable identifier/version, pinpoint theorem/page, exact statement
     consumed, and where the paper discloses it.
   State explicitly when either table is empty.  Do not count ordinary mathlib
   library facts or shared algebraic infrastructure as dependencies on another
   project paper.
8. Compare the development closure with the proposed paper-only export:
   allowlist, repository-relative paths, source and toolchain pins, exact target
   list, reproducible commands, public artifact references, and absence of
   machine-local or private workflow state.

## Required report

Create `notes/2026-07-25-c603-beyond-four-prs-lean-trust-audit.md`.  It must
contain:

- audit date, commit, scope decision, commands, toolchain and pin inventory;
- an itemized source/artifact review inventory with complete counts;
- a claim-to-declaration and paper-to-formal-boundary table;
- axiom, `sorry`, unsafe/native, generated-data, certificate, and external-oracle
  findings;
- a Lean prose/naming/style compliance table;
- the two mathematical-dependency tables described above;
- a numbered gap ledger giving severity, affected claim and exact files or
  declarations, evidence, required repair, owner, and whether it blocks the
  aggregate trust claim, referee-facing artifact, clean export, or C545 release;
- explicit reconciliation of every stale or contradictory ledger statement;
- a final verdict that separately answers kernel correctness, statement
  adequacy, trust-ledger accuracy, referee-facing style, dependency disclosure,
  reproducibility, and release readiness.

The report must distinguish a missing formal proof, a conditional theorem
boundary, a manuscript proof dependency, a certificate-semantics dependency,
an editorial defect, and a packaging defect.  Conditional coverage is not a
gap when it is stated accurately and the corresponding manuscript proof or
citation is present.

## Acceptance gate

- Every adopted paper claim and every project-owned file in its transitive
  verification closure is accounted for.
- The exact aggregate gate is current and green, or the report gives the first
  bounded failure and does not claim readiness.
- Axiom and non-kernel mechanisms are reproduced from current evidence rather
  than copied from prior prose.
- All Lean/paper boundary descriptions agree with elaborated declarations and
  the adopted manuscript.
- Both dependency tables are complete and distinguish other repository papers
  from external literature and shared infrastructure.
- Every gap has an exact repair target and release consequence; no gap is
  silently fixed, grandfathered, or waived.
- The dated report is sufficient for a cold specialist to reproduce the audit
  without task history, agent context, or machine-local knowledge.

## Owned paths

- `notes/2026-07-25-c603-beyond-four-prs-lean-trust-audit.md`
- this task card
- the `reed-solomon` handoff and task-lifecycle rows

Lean sources and `papers/beyond4_prs/` are read-only audit inputs for C603.
Any repair task must receive its own authorized ownership and validation gate.
