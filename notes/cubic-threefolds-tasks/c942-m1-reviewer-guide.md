# C942 -- reviewer guide for the one-stabilization paper

**Lane:** cubic-threefolds

**Status:** queued behind C940's split-path and claim-inventory freeze;
paper-grade independent review required

## Goal

Add a concise reviewer-facing guide and checklist for the primary paper
*Irrationality of Cubic Threefolds after One Stabilization* under
`papers/cubic-stabilization-m1/`.  A referee should be able to identify the
unconditional theorem, reconstruct its proof spine, locate every imported or
formal dependency, replay the appropriate checks, and report a discrepancy
without first reverse-engineering the repository.

The guide is a navigation layer.  The manuscript, claim map, imported-source
registry, evidence registry, and kernel axiom audit remain authoritative for
mathematical content and trust status.

## Dependency and scope

- C940 is splitting the former integrated epilogue into one short primary
  paper and two optional companions.  Drafting may inspect the current tree,
  but final paths, labels, commands, and links must be taken only after C940
  freezes the split's theorem and provenance inventory.
- The required route covers only the unconditional primary `m=1` paper.  The
  six-axis and framed-monodromy companions receive a short boundary note and
  links, not parallel review checklists.
- `papers/cubic-stabilization-irrationality/`, the conditional all-`m`
  manuscript, is outside scope.
- Do not alter a theorem, proof, hypothesis, claim-map classification,
  verification gate, or Lean source merely to make the guide simpler.  Any
  defect discovered while writing the guide is reported against its owning
  task.
- Before writing Lean-facing commands or synchronizing a standalone mirror,
  read and follow `lean/AGENTS.md` and
  `notes/export-and-mirror-conventions.md`, respectively.

## Deliverables

1. Add `papers/cubic-stabilization-m1/REVIEWER_GUIDE.md` and link it near the
   top of the paper's `README.md`.
2. Give two explicit entry paths:
   - a short mathematical review that reaches the headline theorem and causal
     proof mechanism without opening the formal artifact; and
   - an artifact audit that checks the manuscript-to-claim correspondence,
     the primary-paper Lean facade, and the captured axiom report.
3. Key the mathematical route to stable semantic labels, beginning with
   `thm:every-cubic` and passing through the generic marker ledger, QDM
   operation providers, rank-two formal-exponent marker, cubic detection,
   low-dimensional center nullity, projective endpoint, and final weak-
   factorization contradiction.  Use no rendered theorem or page numbers.
4. Include a checkbox audit for:
   - exact theorem scope and unconditionality;
   - occurrence indexing and fold additivity;
   - imported QDM, blowup, factorization, and classification providers;
   - the residue/exponent marker and its coefficient-field boundary;
   - cubic detection, center nullity, and projective-space vanishing;
   - provenance annotations, claim-map strength, and absent/conditional Lean
     coverage;
   - computational-evidence boundaries; and
   - deterministic manuscript and formal-artifact replay.
5. Point each check to one authoritative object rather than copying volatile
   coverage totals, terminal censuses, hashes, or long command sequences.
   In particular, distinguish `PaperInterface.Main` from the aggregate facade
   that also exposes the two companions.
6. Give exact, guarded, copy-pasteable replay commands consistent with the
   repository's current Lean and build rules.  State what each command proves
   and, equally importantly, what it does not prove.
7. Add a compact discrepancy template: severity, semantic label, manuscript
   claim, dependency or artifact inspected, expected versus observed result,
   and whether the issue is mathematical, expository, provenance, or tooling.
8. Synchronize the final documentation-only change to the established
   standalone paper repository after the authority passes its checks, if the
   guide is part of that public review surface under the mirror conventions.
9. Subject the guide itself to the paper review protocol: freeze the candidate,
   obtain mutually isolated cold reads, run a hostile trust-boundary and
   usability audit, repair every adopted finding, and rerun fresh review on the
   repaired candidate.  Prior reports and author intent must not be shown to a
   cold reader before its verdict.

## Proposed guide structure

1. **Scope in one screen.** State the theorem, the unconditional/conditional
   boundary, and which companion material may be skipped.
2. **Ten-minute orientation.** Link the PDF, abstract/introduction, main
   theorem, and the one-blowup model that explains the mechanism before the
   categorical formulation.
3. **Proof-spine review.** Present a compact ordered table with semantic label,
   mathematical job, external input, and failure mode to test.
4. **Trust map.** Separate prose proofs, cited imports, kernel-checked
   deductions, trusted symbolic runs, and deliberately absent formalizations.
5. **Artifact replay.** Give the root manuscript check, source correspondence
   check, guarded Lean build/audit route, expected outputs, and realistic
   resource notes.
6. **Reviewer checklist.** Provide independent mathematics, citation,
   formalization, reproducibility, and presentation checkboxes.
7. **Reporting findings.** Supply the discrepancy template and the stable
   identifiers reviewers should cite.

## Implementation sequence

1. After C940 freezes the split, inventory the primary manuscript's section
   headings, semantic labels, imports, evidence entries, claim-map rows, public
   Lean facade, and existing replay entry points.
2. Draft the guide from the proof spine outward.  Keep the primary route
   complete while relegating consequences and companions to optional branches.
3. Red-team every checklist item against the manuscript and registries: no
   check may imply stronger formal coverage, stronger source verification, or
   broader theorem scope than the underlying artifact records.
4. Freeze a review candidate.  Obtain at least two mutually isolated cold
   reads: one primary-audience mathematical referee following only the fast
   path, and one formal/reproducibility referee following only the artifact
   path.  Each report must give a verdict, confidence, required findings,
   optional findings, strongest passage, and first point of friction.
5. Run a separate hostile review against theorem scope, conditionality,
   semantic-label accuracy, source provenance, formal coverage, command safety,
   clean-checkout usability, and the possibility that the guide overstates
   what a passing check establishes.  Record every finding in a dated review
   report rather than only in chat.
6. Repair every adopted finding, then give the repaired candidate to fresh
   isolated readers who have not seen the earlier reports.  Do not accept the
   guide on the strength of the authoring pass or the first repair audit.
7. Run the scoped documentation/link checks and the paper's existing `make
   check`; run the guarded formal audit when the guide claims that replay path
   is current.  Inspect the narrow diff for accidental manuscript or registry
   changes.
8. Compare the frozen and repaired guide line by line and verify every linked
   path and command from the directory the guide states.  Record the final
   review synthesis and disposition of all findings.
9. Commit the authority, then synchronize and verify the public standalone
   copy when required by the mirror conventions.

## Acceptance gate

- A reviewer can state the theorem, its proof mechanism, and its trust boundary
  after following only the guide's fast path.
- Every required proof step and imported provider is reachable by a stable
  semantic label or authoritative registry entry; no page-number navigation or
  duplicated volatile census is used.
- The guide clearly separates the unconditional primary theorem from the
  conditional framed companion and the unrelated all-`m` manuscript.
- Every command is current, guarded where required, copy-pasteable from its
  stated directory, and paired with an honest statement of what passing it
  establishes.
- The primary-paper facade, claim map, expected-axiom audit, evidence registry,
  and imported-source registry are all findable without exposing the reviewer
  to the companions' machinery unless they opt in.
- Both isolated review paths complete without undocumented local knowledge.
- The frozen candidate, isolated referee reports, hostile audit, repair
  disposition, fresh post-repair cold reads, and final synthesis are preserved
  in dated lane-owned review records, matching the evidentiary standard used
  for manuscript review.
- Final acceptance requires fresh post-repair verdicts of accept from both the
  mathematical and formal/reproducibility paths, with no fatal or major finding
  open.  The guide's authoring pass does not count as a cold read.
- Existing manuscript and verification gates pass; no theorem, hypothesis,
  coverage status, or validation policy changes under C942.

## Starting points

- `papers/cubic-stabilization-m1/README.md`
- `papers/cubic-stabilization-m1/cubic_stabilization_m1.tex`
- `papers/cubic-stabilization-m1/sections/`
- `papers/cubic-stabilization-m1/verification/README.md`
- `papers/cubic-stabilization-m1/verification/imported-sources.json`
- `papers/cubic-stabilization-m1/verification/evidence.json`
- `papers/cubic-stabilization-m1/lean/README.md`
- `papers/cubic-stabilization-m1/lean/verification/claims.json`
- `papers/cubic-stabilization-m1/lean/verification/expected_axioms.txt`
- `notes/cubic-threefolds-tasks/c940-epilogue-three-way-split.md`
- `papers/style-guide.md`
