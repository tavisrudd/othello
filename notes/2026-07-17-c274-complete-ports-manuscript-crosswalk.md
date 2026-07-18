# C274 complete-ports manuscript crosswalk

**Lane:** `complete-ports` (re-pegged from `repaircodes` by the explicit C277 lane split)

**Status:** COMPLETE — the complete-ports paper theorem spine, exclusions, evidence owners, section destinations, and
keep/replace/move/delete audit are frozen. No paper prose was edited. The user selected separate
new repositories for the papers and a new shared Lean monorepo backing every exported paper under
`papers/`, not only the complete-ports and restoration-semantics papers. The current
monorepo contains substantial nonpublication material and must never be published or exported by
history transplant; every new repository requires a deny-by-default, clean-history allowlist.

## Decision at a glance

The existing manuscript is a sound evidence-bearing base, but it is not yet the complete-ports paper. Its 18
numbered definition/theorem/proposition/corollary environments are organized around the original
cubic seed, exact concatenation transfer, and two q=9 asymptotic lifts. The complete-ports paper adds three currently
absent structural sections—reliability/bounded EXIT, the pointed-Tutte identification, and the
quartic-nucleus/harmonic flagship—and replaces the specific-lift thesis by the prescribed-port
realization theorem.

The selected route is one clean-history repository per exported paper and one shared Lean monorepo
exposing the formal theorem base needed by all of them. These are clean-room publications,
not forks of the monorepo: do not copy `.git`, publish monorepo history, or start from a broad tree
copy. Until an allowlisted export is verified, this monorepo remains the sole authoritative source.
The old cubic and projective-completion results remain as compressed flagship and strict-transfer
examples, not as the complete-ports paper's organizing narrative.

## Frozen scope

The six-part spine is:

1. complete bounded repair ports and their support, coefficient, and probability layers;
2. exact weighted-functional transfer and its pointed confinement boundary;
3. prescribed positive-density realization in asymptotically good fixed-alphabet families;
4. reliability, cheapest-radius transforms, and radius-truncated BEC EXIT;
5. the full-port pointed-Tutte/perspective identification and the exact radius-filtration boundary;
6. cubic versus quartic-nucleus/harmonic flagships.

Exclude sequential composition (C229--C234, C241, C246), general capacitated service regions
(C235), the full coefficient-optimization programme (C217/C255), log-concavity history
(C245/C254), tract/foundation exposition (C247), Capsule/product architecture, and a catalogue of
available applications. C220 enters only as a compact cubic blocker-stability strengthening. C243
enters only through the deterministic nucleus gate; it does not open a propagation-completeness or
threshold programme.

## Theorem and evidence crosswalk

| Complete-ports slot | Retained statement | Exact owner and evidence | Current manuscript locus | Frozen action and destination |
|---|---|---|---|---|
| Object | Complete radius-`r` pointed repair hypergraph/port, minimal clutter, matching, transversal, scalar recovery layer | proof-ledger D1/P1 and D1a/C203; `FiniteGeom/Repair.lean`; `RepairCodes/OperationalCoefficients.lean`; C203 report/verifier | `def:repair-hypergraph`, `prop:basic-hypergraph`, Sections 2--4 | **KEEP/EXPAND** as Section 2. Lead with the complete pointed object; separate support, coefficient, and probability layers. Retain the operational boundary: one full symbol per helper, no minimum-access/bandwidth claim. |
| Exact transfer | Exact zero/singleton/multisupport threshold; pointed nonembedded cost; weighted transfer; strict Singer/generalized-SPC example | C214/C221/C224 and proof-ledger T5w/T5x/T5e; `RepairCodes/WeightedTransfer*.lean`; C215 functional-cost API and prior-art audit | Section `sec:transfer`, `thm:weighted-transfer`, `thm:transfer`, `cor:exact-locality-transfer`, strict example | **KEEP/RESTATE** as Section 3. Present pointed confinement as the repair contribution. State that ordinary functional-fiber cost is classical quotient/coset-leader weight. Keep the strict natural example; demote generic fiber enumeration to cited background. |
| Prescribed realization | Every fixed realizable bounded port satisfying the persistent pointed-obstruction gate occurs with positive density in an asymptotically good fixed-alphabet family; random GV and square-alphabet AG regions | C216; finite cost and transfer core kernel-checked in `RepairPorts/FunctionalCost.lean` and `RepairCodes/WeightedTransferExact.lean`; trace/random/AG asymptotics are manuscript arguments | `sec:trace`, finite-lift corollaries, `thm:asymptotic`, `thm:completed-asymptotic` | **REPLACE/COMPRESS** into Section 4. State the general realization theorem first. Retain the q=9 families only as concrete corollaries or flagship examples; move trace and parameter bookkeeping out of the main line. Preserve the sole Stichtenoth import boundary where used. |
| Reliability and bounded EXIT | Deletion--contraction reliability/influence calculus; exact cubic/axis transforms; target-conditioned extrinsic failure; cheapest-radius law; blocker certificates; corrected EXIT area ledger | C219 and C226 reports, scripts, and JSON certificates; C244 for corrected dimension ledger and exact consequences | absent except informal matching/transversal motivation | **ADD** as Section 5. Distinguish bounded-query EXIT from full symbol-MAP and target blockers from global Tanner stopping sets. Use C244's corrected `dimension + total deficit` ledger. |
| Pointed Tutte | Full repair reliability is the Las Vergnas polynomial of `M\x -> M/x`; duality exchanges repair and failure; deletion/contraction rank-polynomial derivative; bounded radius is a filtered refinement not recovered by the standard polynomial | C227 report, verifier, and JSON certificate; classical pointed-perspective literature boundary | absent | **ADD** as Section 6. Phrase the identification as standard structure, not a new invariant. Make the radius-filtration loss the bridge back to complete bounded ports. |
| Cubic flagship | Exact small circuits, all-symbol rows, q=9 profiles, and optionally the first blocker-stability layer | existing proof-ledger T1--T4/T3a; current Lean chain; C220 report, script, and JSON certificate | Sections 3--5 and part of the introduction | **MOVE/COMPRESS** into the first half of Section 7. Keep exact rows and one stability theorem only when it shortens the reliability story. Remove the cubic family as the paper-wide organizing thesis. |
| Harmonic flagship | Quartic normal-rational curve plus nucleus; exact radius-four circuits and q=9 row; sparse-versus-series reliability; deterministic nucleus gate; pointed distances, master enumerator, corrected EXIT deficits, and design-exact early layers | C218/C219/C243/C244 reports and their committed `.py`/`.json` certificates | absent | **ADD** as the second half of Section 7. Use C243/C244 selectively: nucleus-gated separation, pointed-distance table, master two-target law, EXIT-deficit box, and explicit Poisson errors. Do not open a harmonic census or threshold paper. |
| Completed cubic comparison | `[2q+2,4,q]_q` completed seed, full inner port at radius four, strict weighted-transfer witness, and selected pointed-distance data | proof-ledger T4c/T4d/T5e/T7p/T8p; existing Lean chain; C244 | standalone Section 6 plus lift theorems | **MOVE/COMPRESS** into Sections 3 and 7 or an appendix. It supports the transfer sharpness and comparison story; it is no longer a standalone main section. |

## Existing-section audit

| Current section | Decision | Rewrite bill |
|---|---|---|
| Introduction / contributions / scope | **REPLACE** | State the complete-port object and six-part spine. Remove the three-row seed/transfer/lift hierarchy and application-catalogue pressure. |
| Complete bounded repair hypergraphs | **KEEP/EXPAND** | Rename around complete bounded repair ports and expose support/coefficient/probability layers. Preserve exact definitions and basic invariants. |
| Twisted-cubic--axis code; matching/transversal invariants | **MOVE/COMPRESS** | Retain the exact family theorem pack inside the flagship section. The current multi-section derivation becomes proof compression or appendix material. |
| Projectively completed seed | **MOVE/COMPRESS** | Split its uses between the strict transfer example and flagship comparison; avoid a third geometric thesis. |
| Exact repair transfer under concatenation | **KEEP/RESTATE** | Move earlier, sharpen the pointed-cost novelty boundary, and retain support-distance and mixed-locality corollaries as secondary statements. |
| Trace bridge and field-nine lift | **MOVE/COMPRESS** | Preserve only machinery needed for a selected concrete corollary; do not let trace bookkeeping interrupt the general realization theorem. |
| Fixed-alphabet asymptotic family | **REPLACE** | Lead with C216's prescribed-port realization. Keep one compact q=9 corollary and its exact trust boundary if it materially strengthens the flagship. |
| Relation to prior work | **REPLACE** | Organize by quotient/coset-leader weights, pointed matroid perspectives, reliability/EXIT, LRC realization, and Steiner/harmonic geometry. |
| Formal verification and provenance | **KEEP/UPDATE** | Add report/script/JSON evidence owners and distinguish kernel, cited input, manuscript proof, and finite refutation gates. |
| Conclusion | **REPLACE** | Reprise one mathematical object and two contrasting flagships; do not advertise Capsule, sequential semantics, or an omnibus programme. |

## Environment-level rewrite bill

Of the current 18 numbered environments:

- keep the object definition/basic proposition and the exact weighted-transfer theorem family;
- move and compress the seven seed/completed-seed parameter, circuit, row, and separation results
  into the flagship section;
- retain support-distance, exact-locality, and uniform-boundary statements only as compact
  corollaries/remarks to the exact transfer result;
- move the trace bridge and two finite-lift corollaries out of the main narrative; and
- replace the two specific asymptotic headline theorems by C216's general prescribed-port
  realization theorem, with at most one selected q=9 corollary.

New numbered statements are needed for the reliability recurrence/EXIT conventions, the standard
pointed-Tutte identification plus filtered boundary, and the harmonic flagship pack. Their final
count is deliberately not frozen until the in-place architecture is approved; the narrative gate
is fewer, stronger statements rather than preserving the old count.

## Validation and trusted boundary

This work unit is a documentation audit. It did not rerun Lean or computational certificates and
does not upgrade any evidence status. Paper-facing computational claims must replay the exact
committed C218, C219, C220 (if retained), C226, C227, C243, and C244 script/JSON pairs before prose
assembly closes. C216's asymptotic realization remains partly manuscript-level: its finite pointed
cost/transfer core is kernel-checked, while the trace pairing, random first-moment construction, AG
family, and parameter calculation require mathematical review in the paper lane.

The rewrite must preserve these claim ceilings:

- quotient/coset-leader weight, reliability calculus, pointed Tutte, Greene/MacWilliams, and
  generic probability tools are classical;
- bounded repair is not full MAP decoding, and target blockers are not generic Tanner stopping
  sets;
- q=9 finite checks do not imply all-field statements;
- harmonic consequences do not imply a threshold theorem; and
- no storage-performance, service-region, or product claim enters the complete-ports paper without new evidence.

## Next gate

The architecture is selected; the publication boundary is now the gate. C275 must produce the complete-ports paper
clean-room export manifest before any repository is initialized or any file is copied. It must list
every permitted paper source, bibliography entry set, evidence artifact, license/attribution file,
and shared-Lean API dependency, plus explicit exclusions. It must also prescribe fresh Git history,
secret/private-path scanning, generated-artifact policy, hash verification, and a source-to-export
provenance manifest. Every other paper repository and the all-papers shared Lean monorepo require
separate lane-owned manifests; C275 must not silently widen to them. The Lean export manifest must
be derived from the union of paper-facing target closures, not from a broad copy of `lean/`.
