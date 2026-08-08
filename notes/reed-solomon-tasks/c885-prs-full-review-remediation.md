# C885 — PRS full-review remediation

**Lane:** `reed-solomon`

**Status:** active 2026-08-07.

**Controlling audit:** `notes/2026-08-07-c883-full-review.md`.

## Objective

Repair every actionable manuscript, citation, formal-documentation, and trust finding from the
complete Version 2 reread, then produce a fresh internally consistent candidate.  This task absorbs
C854 under the paper's current scope: the balanced quantum consequence is withdrawn and is not a
paper theorem dependency, while the R5--R7 aggregate and the paper-used R8--R10 companion gates
must have an exact registered trust boundary.

## Owned paths

- `papers/beyond4_prs/` and its generated paper-local metadata;
- the paper-facing PRS modules and gates under `lean/RelativeConicArcs/`;
- PRS rows/facts/export configuration under `lean/trust/`;
- the Reed--Solomon queue, handoff, task cards, and dated C885 report;
- the C883 covariant report and its generator/certificate only for the normalization correction.

Foreign dirty state outside these paths remains untouched.  Shared Lean/trust edits require the
guarded queue and reverse-closure validation prescribed by `lean/AGENTS.md`.

## Frozen remediation checklist

### Manuscript and literature

- [ ] Replace the false sentence that none of the cited twisted-cubic literature treats PRS
      syndromes, covering radius, or deep holes with the precise BPS boundary: codimension four
      generalized RS syndromes and coset-leader enumeration are prior art; the redundancy-five
      syndrome-as-pencil classification and all-field radius promotion are the present distinction.
- [ ] Delete the unnecessary uncited assertion that the largest arc in `PG(4,8)` has nine points,
      or support it by an exact primary theorem.
- [ ] Add “in the stated field ranges” at the abstract's first “through redundancy ten” claim if
      the sentence otherwise admits an all-field reading.
- [ ] Remove unused `Stichtenoth2009` and `RaissiGogolinRieraAcin2018`, and remove the misleading
      “Absolutely maximally entangled states” index entry unless a current paper claim needs it.
- [ ] Add the stable DOI/arXiv locators listed in the controlling audit for Ceria--Pavese, the three
      DMP papers, and Ferraguti--Micheli.
- [ ] Record the complete Dür 1994 primary read under cache key
      `10.1016/0012-365X(94)90256-9`, SHA-256
      `b28e0b84b00255aadf38d6f6b8d2204a76228f5acc0eacb73066cd40401ed9b1`.

### Covariant support record

- [ ] Replace the erroneous fixed `3/2` normalization in the C883 covariant note and symbolic flag.
      On the patch `Delta = a0*a2-a1^2`, direct use of Kaipa--Pradhan equations (8) and (20) must
      check `D_L = disc(h_x)/(36 Delta^2) = D_f/(9 Delta^2)` and therefore
      `D_f = (3 Delta)^2 D_L`.
- [ ] Regenerate the compact JSON certificate, update both hashes, and replay the independent
      square-class calculation without weakening the manuscript's no-twist conclusion.

### Lean and trust

- [ ] Correct the Seroussi--Roth source pinpoint in `PRSRedundancyFive.lean` from Corollary 2 to
      Corollary 1, and replace the wrong Aubry--Perret Theorem 4 pinpoint by the p. 468
      arithmetic-genus bound actually used.
- [ ] Rewrite the `ExactSplitWitnessCount` documentation so the count relation is
      characteristic-free and the sharper characteristic-two branch budget is separate.
- [ ] Reconcile the stale theorem-map count `71` with the verifier's exact current count `75`.
- [ ] Replace trust-export prose saying the manuscript treats only redundancies five through seven
      by the exact R5--R7 aggregate role inside the manuscript through redundancy ten.
- [ ] Audit and register every paper-used PRS gate/terminal and axiom fact required by the current
      manuscript.  Do not reintroduce the withdrawn balanced-quantum bridge into the paper closure.
- [ ] Replace any development-only direct Lake reproduction instruction by the supported public or
      guarded route appropriate to its distribution context.
- [ ] Run the guarded aggregate and companion gates, exact target checks, axiom audits, and the
      scoped trust export/audit; distinguish global foreign warnings from remaining PRS defects.

### Candidate verification

- [ ] Regenerate affected paper-local evidence metadata and release hashes through their supported
      scripts.
- [ ] Run TeX lint, both manuscript builds, the complete `supplement/verify.py --replay`, q=49 Rust
      comparison, and both Singular stable-component checks.
- [ ] Cold-read the complete resulting diff for hypotheses, citation scope, theorem counts, and
      trust wording; run the required `ej` plus Tao closeout and maintain a mystery ledger.

## Acceptance boundary

C885 closes only when every checklist item is either repaired and green or explicitly rejected
with a source-backed reason in the dated report; C854 is archived in the same lifecycle commit once
its still-applicable formal/trust requirements are discharged.  No standalone mirror, release,
remote, tag, or push is authorized by this task.
