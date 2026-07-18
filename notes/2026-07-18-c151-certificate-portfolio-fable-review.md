# Portfolio certificate-dependency assessment — critical review (Fable, 2026-07-18)

**Lane**: `alt-orbit-repair`

Scope: review of the external model's portfolio-wide certificate inventory (reproduced in the
coordinator's request). Read-only spot checks against
`lean/RelativeConicArcs/` (Lean sources, generated data directories, `TRUST.md`); no builds
run. Claims about non-Lean artifacts (Clebsch scripts, dihedral solvers, ports bundles) were
*not* independently verified and are marked as such. This review builds on the C151 review
(`notes/2026-07-18-c151-orbit-completeness-fable-review.md`), which established what actually
kernel-reduces in this codebase.

## Summary verdict

The assessment's architecture taxonomy is sound and its q=16-vs-Q25 ordering is right — I
verified the q=16 checker story at source level and it is real, not README varnish. But the
inventory is visibly doc-derived: its scale figures are stale where the repo lacks a trust
manifest and exact where one exists, several of its q=16 recommendations are *already
implemented* in `TRUST.md` without the assessment noticing, and it misses the two most
concrete near-term risks in the portfolio: (a) the newest Q25 residual layer — the very thing
rated "High" — is currently **untracked in git**, and (b) named classical imports (Kim–Vu,
NRC/GRS) that are exactly the "visible mathematical imports" it praises Clebsch for are not
mentioned in the arcs row at all. The portfolio contract it proposes is a good default but is
stated as uniformly achievable when it is not; §3 says what to do where it fails. The
"two independent solvers" standard is under-specified to the point of being gameable; §4
gives the conditions under which it means something.

## 1. Spot checks: what is verified, what is doc-derived

**Verified accurate (against artifacts):**

- q=16 covering-list lengths 4/61/454/2633 and the 2630+3 exceptional split: confirmed both
  in `TRUST.md:143,149-155` and structurally in the sources
  (`Q16CertificateLevels.lean` defines `level4`…`level8`;
  `Q16Profile.lean`/`Q16ExceptionalArithmetic.lean` exist as described;
  `Q16Result.lean:26` states `no_completeOutside_GF16_card_eight`).
- `StepBook.coverage` is a genuine generic-checker layer — see §2.
- Q25 generated-shard order of magnitude: real and if anything larger than quoted.

**Stale / doc-derived numbers:** the Q25 row repeats the earlier strategic note's figures
(1,036 transport modules, 1,071 dispatch leaves, 7,044 class links, 1,071 conclusion
leaves). Current directory counts: `Q25ResidualTransportData` 1,341 files,
`Q25ResidualClassLinkData` 1,340, `Q25ResidualConclusionData` 1,375,
`Q25ResidualDispatchData` 1,375, plus a new `Q25ResidualConclusionDispatchData` (304 files)
that postdates the note and is **untracked**. The tree has grown ~25% since the numbers were
taken. Harmless for a risk rating, but it confirms the inventory was assembled from prose,
not artifacts.

**Unverified (out of my checked scope, flag before relying on them):** Clebsch "11 Python
replays, one Singular computation, 11 Lean roots"; dihedral "38 templates, 2,160 triples,
three solvers"; ports "several script/JSON bundles". These read like handoff phrasing. In
particular, "three independent solvers" is a claim with a precise meaning (§4) and the
assessment gives no evidence anyone checked what the three solvers share. Before the
dihedral or crowns rows drive scheduling, someone should verify solver independence at
source level, not from the handoff sentence.

**A telling pattern:** the q=16 row is exact because `TRUST.md` exists; every row without a
trust manifest has drifting or unverifiable numbers. That is itself the strongest argument
for the assessment's own manifest recommendation — per-paper manifests are what make future
inventories cheap and accurate.

## 2. Risk ordering: right, but for a sharper reason than the assessment gives

I read the q=16 kernel and data at source level. The architecture claim is real:

- `Q16StepKernel.lean` is ~100 lines. `StepBook` (line 59) packages a parent, entries
  referencing per-row semantic theorems, and a `coverage` field; `StepBook.step`,
  `StepBooksValid.step`, and `ClassifiedAt.extendStep` (lines 65-102) are short handwritten
  soundness lemmas. Coverage is discharged in generated books through
  `FastRawExtensionBy` (line 28) — a reducible determinant-table evaluator with a symbolic
  bridge `fastRawExtensionBy_of_rawExtension` (line 36). This is exactly the repo's
  "reducible evaluator + symbolic bridge" convention, applied correctly.
- Leaves (`Q16LeafData/L_000.lean`) are `RejectedLeaf` records carrying explicit witness
  data (a full-rank rejection with an explicit inverse matrix), each validated by `decide`
  against a *generic* `ValidFor` predicate. The kernel work per leaf checks witness data
  against a small predicate whose soundness is a separate handwritten theorem
  (`matrixMaps_sound`, the fullRank rejection lemmas).
- `TRUST.md` supplies the axiom audit (`[propext, Classical.choice, Quot.sound]`, no
  `native_decide`), generator provenance with hashes, and the external consistency check
  against the published class count.

So yes — q=16 is structurally healthier than Q25, and not just better documented. But two
corrections to the assessment's framing:

**(a) The file-count gap is smaller than implied.** Q16 generated data is ~1,300 files
(261 book + 727 row + 330 leaf modules) — the same order as the Q25 transport layer alone.
Both trees run thousands of per-leaf `by decide` obligations. The difference is not "one
checker vs many proofs"; it is *what each decide checks*. Q16 decides instantiate one
generic validity predicate against witness data, with the semantic content in a small
handwritten kernel. The Q25 residual leaves decide bespoke per-row statements (my C151
review: transport leaves each carry their own
`simp [residualApply, shift, scale, …] <;> decide` unfolding). Reviewers who count files
will not see the health difference; only the trusted-surface argument shows it. The paper
must make that argument explicitly — which is the assessment's own "aggregate theorem
hiding shard layout" point, and it is the right one.

**(b) Q25's "High" rating understates the immediate problem.** The residual
classification's newest layer is not merely large — it is *unfinished and uncommitted*:
`Q25ResidualMinimumOrbits.lean` does not compile (every `decide` stuck — my C151 review),
and `Q25MinimumClassification.lean`, `Q25ResidualEquality.lean`,
`Q25ResidualConclusionDispatchData/`, and both generator scripts sit untracked in the
worktree. Under this repo's own evidence rules, that layer currently supports no
reproducibility claim at all. The assessment rates reception risk on a tree it assumes
exists in git; step zero is closing and committing it. (Ditto the C294 crowns bundle:
`notes/2026-07-17-c294-b3-*` are all untracked.)

**Q16 recommendations already implemented:** independent replay independent of the Lean
format (Python verifier plus a *separately written* C++ q11 checker, `TRUST.md:83-121`),
mutation tests (one-point witness perturbation and mutated-generator rejection,
`TRUST.md:97-98`), axiom reporting, external consistency check. The genuinely new items in
its q=16 list are: a one-page level diagram, build-cost figures, and mutation tests aimed at
the *q=16 transition data specifically* (the existing mutation tests cover the q11
checkers). Those three are cheap and worth doing; the rest is done and should simply be
surfaced in the paper.

## 3. The portfolio contract: where it does not fit, and what to do instead

The six-arrow contract (claim → reduction → checker → data → aggregate → replay) is the
right default for *finite-enumeration* claims. It does not fit two other proof species in
this portfolio, and the assessment blurs the distinction:

**Symbolic elimination (C210/layered-arcs, Singular).** Split by claim polarity:

- *Positive claims* (this polynomial lies in this ideal; this product equals this
  polynomial; this identity holds) fit the contract fine: the certificate is the cofactor
  combination or the factorization itself, and the checker is exact polynomial arithmetic —
  small, and Lean-checkable in principle (`ring`-level identities) or replayable by an exact
  evaluator. Where a Singular output is load-bearing and positive, demand the cofactor
  certificate, not a rerun.
- *Negative/completeness claims* (the elimination ideal is exactly this; these strata
  exhaust the variety; no further component exists) are where the contract breaks. The
  natural certificate is a Gröbner basis plus a verified Buchberger-criterion check —
  possible but expensive, and nobody should pretend a "small generic checker" exists today.
  Here "reproduce in a second CAS" is a legitimate stopgap, **but the assessment oversells
  it**: two CAS runs on the same input file are independent implementations of the same
  algorithm family sharing the same *specification*. Algorithmic errors (S-polynomial
  bookkeeping) essentially never correlate across Singular/Macaulay2/msolve; specification
  errors — wrong ideal, missing saturation, a characteristic assumption, a mistranscribed
  equation — are copied verbatim and correlate perfectly. The dominant failure mode of CAS
  proofs is the second kind. The mitigation is not a third CAS but an independent
  *re-derivation of the input system from the geometry* plus semantic spot checks (random
  points on claimed components, dimension/degree invariants computed a second way). A
  second CAS run without an independently derived input is near-zero marginal evidence.

**Classical imports (Kim–Vu, NRC/GRS dictionary, Dye, Stichtenoth/TVZ).** These fit no arrow
of the contract; the correct handling is exactly what `TRUST.md:180-187` already does for
Kim–Vu — a named hypothesis in theorem signatures, never a global axiom, with an explicit
statement of which results avoid it. The assessment praises this pattern for Clebsch's Dye
assumptions but omits Kim–Vu and NRC/GRS from the arcs row entirely, which means its
inventory of trust boundaries is incomplete for the paper it rates most carefully. A
portfolio contract should have a *seventh* row category: named classical inputs, with the
statement used, where it enters, and what is unconditional without it.

When a claim fits neither the contract nor a named import — the likely fate of a full q=512
closure — the assessment's own fallback is right and worth adopting verbatim: demote to a
bounded computational experiment with exact search domain and stop condition, per this
repo's existing negative-results rule.

## 4. "Two independent solvers": conditions under which it is evidence

Solver agreement is evidence against *implementation* error and no evidence at all against
*modeling* error. Concretely, for game-value claims (C294, dihedral), agreement is real
evidence only when the solvers share none of:

1. **Move generator / rules encoding.** This is where correlated bugs live. If both solvers
   call the same move enumeration, or both were written from the same intermediate spec
   (rather than the paper's definitions), agreement validates nothing about the rules. The
   two implementations should be written from the *mathematical* definition, ideally by
   different sessions/authors, and disagree in representation (bitmask vs explicit sets,
   different symmetry reductions or none).
2. **Algorithm.** Memoized minimax vs Sprague–Grundy canonical-form computation vs
   retrograde analysis. Same algorithm twice in two languages is a port, not a replay.
3. **State canonicalization.** A shared symmetry-reduction bug silently prunes the same
   subtree in both. At least one solver should run symmetry-free on the sizes where that is
   feasible.

The repo already has the gold standard in-house: the q11 Python/C++ pair with mutation
tests and perturbation sensitivity (`TRUST.md:96-99`). Apply that template, including the
mutation tests — a solver pair that has never been shown to *reject* a wrong value proves
little about its power to detect one.

But the assessment's better idea is the one it mentions in passing: **strategy
certificates change what is proved; solver agreement only changes confidence.** A winning
strategy (or a P-position pairing/kernel) is checkable by a verifier much smaller than any
solver, is independent of both solvers, and is the artifact a referee can actually inspect.
Where feasible for C294's small bases, prioritize strategy certificates over a second
solver; where the state space makes explicit strategies infeasible, fall back to the
independent-solver-pair-plus-mutation-tests standard above.

## 5. Materially missing from the inventory

1. **Uncommitted evidence (most urgent).** The Q25 residual conclusion/equality/orbit layer
   and its generators, and the C294 crowns bundle, are untracked. The assessment rates
   reception risk of trees whose newest layers are not yet in git. Under the repo's own
   rules these currently support no claim.
2. **Named classical inputs in the arcs paper** (Kim–Vu, NRC/GRS) — see §3. Also the
   Al-Seraji–Al-Ogali class count, correctly quarantined in `TRUST.md:144-146` as a
   consistency check only; the paper must keep saying so.
3. **Generator-freshness / regeneration risk.** Several frozen artifacts have not been
   re-derived since generation (frozen 2026-07-13 hashes for the q11 outputs; the
   `search_rhoc16` report). Hashes prove identity, not that the generator still reproduces
   the artifact on the current toolchain. One clean regeneration pass per paper, on a
   pinned toolchain, is cheap insurance and is the assessment's "deterministic
   regeneration" bullet made concrete — it has apparently not been run recently for the
   older artifacts.
4. **The shared-build-tree/gate discipline as a trust component.** "One aggregate target per
   paper" already exists in this repo as the `RelativeConicArcs.Gates` convention plus axiom
   audits. The assessment reinvents it without noticing; the work item is to *document* the
   existing gate per paper in each manifest, not to design a new mechanism.
5. **Kernel-cost feasibility as a gating criterion.** The assessment gates C305 on
   "compact certificate architecture exists" but never states the concrete lesson from this
   codebase (established in the C151 review): `Finset`/`Multiset` dedup and set-level
   `decide`s are quadratic in kernel units and fail *silently late*, after generation.
   Any C305 gate should include a measured single-shard kernel benchmark before any
   generator is written — "benchmark a deterministic shard" is in its list but should be
   first, not third.

## 6. Prioritized work order

Split by whether the work changes what is proved (P) or how it is presented/evidenced (E).
The assessment blurs this throughout; scheduling should not.

**Now, cheap:**

1. (P/blocker) Commit or explicitly close the untracked Q25 residual layer and C294 crowns
   bundle. Nothing else about Q25 risk is meaningful while its newest layer is outside git.
2. (P) C151 orbit/classification theorems per my prior review (Step 0 fast evaluator, then
   the factored group route with the keyed fallback). This is the "semantic bridge" the
   strategic advice keeps asking for, and it is already in flight.
3. (E) Per-paper trust manifest cloned from `TRUST.md` — Clebsch first (its risk is
   fragmentation, and a manifest is precisely the cure), then dihedral, ports, crowns. This
   also fixes the inventory-drift problem of §1 permanently.

**Next, moderate cost:**

4. (E→P boundary) One clean regeneration pass of frozen artifacts on the pinned toolchain
   (§5.3). Cheap per artifact; do it opportunistically inside existing build windows.
5. (P) Strategy certificates for C294 small bases; independent-solver audit for dihedral
   (verify at source what the "three solvers" actually share) with mutation tests on the
   q11 template. If the audit finds a shared move generator, writing the genuinely
   independent second solver is the real work item.
6. (P) For layered-arcs: extract cofactor/factorization certificates for the load-bearing
   *positive* Singular claims and check them by exact arithmetic (Lean `ring` or a small
   exact evaluator). For completeness-type claims, an independently re-derived input system
   plus invariant spot checks (§3) — not a second CAS run on the same file.
7. (E) The three genuinely new q=16 items: level diagram, build-cost figures, mutation
   tests against the q=16 transition data. Surface the already-existing replay/mutation/
   axiom evidence in the paper; it is currently visible only to someone who opens TRUST.md.

**Later, expensive — decide deliberately:**

8. (P, large) The full Q25 "verified canonicalizer replacing 7,044 class links". Do not
   schedule this until the C151 five-orbit version (a strictly smaller instance of the same
   idea) has landed and its cost is measured. If the five-row canonicalization already
   strains the kernel budget, the full version should be declined and Q25 demoted to
   "Lean-checked reduction + reproducible computation" per the mixed-verification policy —
   the strategic note itself endorses that boundary.

**Decline (agreeing with the assessment, with reasons):**

- Translating the Clebsch finite census into Lean: the mixed boundary with named Dye
  imports is more credible than a new generated tree, and the census is not where a referee
  will attack.
- Full literal formalization of the dihedral tables: prove template completeness plus a
  generic evaluator if formalization is pursued at all; thousands of literal Lean facts add
  kernel cost without trust.
- Any C305 certificate forest before a measured single-shard kernel benchmark and a compact
  architecture on paper. Given what §5.5 says about dedup costs, the naive version is not
  merely risky but predictably infeasible.

One overall correction of emphasis: the assessment's closing principle — "the referee
should understand why the computation proves the theorem without running it" — is right,
but in this portfolio the binding constraint is more often *kernel feasibility* than
referee psychology. Several of its recommendations (aggregate theorems, canonicalizers,
internalized tables) quietly assume the kernel can afford the set-level statements. It
often cannot, and the design that survives is the one that keeps decided statements
pointwise and pushes set-level facts into handwritten lemmas — the Q16 kernel is the
in-repo proof that this shape works at scale.
