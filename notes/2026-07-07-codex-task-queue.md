# Codex task queue — delegated by Fable (2026-07-07)

**What this is:** the live task registry for the projective-cap / odd-plane program. It holds only
the current-state map — the priority view plus the genuinely-open tasks as one-line entries. Full
write-ups of completed tasks, the original ranking, and the Fable Nth-pass amendment trail were moved
to the companion log
[`2026-07-07-codex-task-queue-archive.md`](2026-07-07-codex-task-queue-archive.md) on 2026-07-11.

**Task-ID protocol:** one global monotonic `CNN` sequence (see CLAUDE.md). Each task names a report
file; Codex does the work, writes findings there (verbatim commands/outputs for machine checks), and
marks the entry `[REPORTED <date>]`. Never renumber or reuse an allocated ID. **Max allocated: C103.**

**Box:** compute up to ~8 GB / multi-core is fine; q ≥ 23 grid-cap campaigns and n=20 queens runs
still require an explicit user gate.

## CURRENT TOP OF QUEUE (updated 2026-07-13)

**PRIMARY LANE (2026-07-12): conic-involution Schreier graphs → abundance-first — C84.** The conic
bulk is the induced Schreier graph of `H_S = ⟨σ_x : x∈S⟩ ≤ PGL(2,q)`, so its Node-Kayles value is
set by the subgroup type of `H_S`. Exact values: two centres fully soluble (paths + uniform
`2r`-cycles); self-polar `V₄` → `K₄`-unions; `D₈` → `M₈ ⊔ K₂`; `S₄` classes — all
congruence-periodic via the orbit-template theorem; `A₄` cannot occur. Independently verified from
field geometry at q=11–19. **Gating measurement done:** the escape crux (size-3 → size-4) leaves
the small-subgroup regime immediately (children generic, full PSL/PGL) — the catalogue is a
**boundary evaluator, not a forcing engine**. **Reprioritized to abundance-first:** S₄-rooted
escaping 4th centres are conic-only-P at density `≈0.13` (min over classes, q=11–23; verified two
ways); target `#{y : 𝒢=0} ≥ c·q²`. Pairing/mirror mechanism ruled out (minority coverage) ⇒ the
bound must be Grundy-arithmetic. **Pursue first.** Notes:
[Schreier graphs](2026-07-12-conic-involution-schreier-graphs.md),
[program integration](2026-07-12-conic-involution-residual-graphs.md). Ranking: (1) prove
positive-density P (S₄ then all triple types); (2) transfer to (ON) — needs a separate exchange
lemma (abundance is off-conic); (3) sealing = complete-arc/saturating-set, not blocking-set/Baer;
(4) drain minimax fallback. Correction: order 24 ≠ S₄ (D₂₄ at `12|q²−1`, separate by profile).

The odd-plane escape kernel — "every legal size-3 residual position has a P-valued size-4 child" —
is the active mathematics; (ON), requiring that child on the conic, is the stronger A5 route. The
config→value **mechanism sweep is closed-negative** (Cluster 1). The remaining lanes: the Schreier
catalogue (C84, above); **A5 arc-depletion arithmetic**; the **C74/C77 one-intruder N-absorption
theorem**. C75/C76 close the pointwise selector/invariant spaces; C77 closes the pure geometric
bank. C79's arithmetic pass specified the bulk gap; the game-side follow-ups **C80** (drain
resource proven — `|live conic|` drops by `1+deg`; abundance/descent open), **C81** (char-5/7
subfield gate), **C82** (orbital counting, gated) remain. **C83** raw-quotient measurement is done
(coarsest bisimulation 29 at q=11 → 65 at q=13, growing; q=17 deferred, canon-bound): no finite
raw-state automaton, but this is deprioritized (not superseded) behind the structural Schreier lane
— tractability is a question of `G∪` structural width, not raw-quotient size.

1. **Cluster 2 / C74 — the open core** (one-intruder pencil N-absorption + recursive reply closure).
   PRIMARY per C65's route verdict. Every constituent probe is REPORTED (archived C61–C63, C70, C71);
   the lane itself is open. C75 explains the selector wall; C76 answered the invariant prong
   (frame-relative characters cut collisions 48→1 but leave a residual hard twin, no monotone scalar,
   and no uniform linear selector ⇒ separation not selection). C77 now proves the reservoir-free
   DROP ledger is uniformly peak-bounded, but also shows that this geometric bound has no game-value
   content by itself. Its continuation finds the exact computed target **`Ncenters≤q−8`** on every
   maximum C74 pencil through q=19 (tight q=17); since `d≤5`, this leaves at least two P off-conic
   centers and would prove odd escape directly. The mechanism candidate is the value-blind two-stage
   packet `L=min d`, then `Low4(L)=` centers through the fourth-lowest off-conic support (ties kept):
   every packet has ≥3 P centers, while 1,332/1,344 non-maximum q17 lines fail. The q=11 knife-edge
   base compresses to four exact perfect-matching reply-graph types. `Low4` is algebraic via the
   proved five-spoke formula `zone_v=q²−15q+34+Σδ_e−t`, with `δ_e∈{4,5,6}` and tangent count `t≤2`.
   A sharper balanced subtype `(d,5,5,6,6)` is P in all 760 exact occurrences and exists
   geometrically on every tested prime-field pencil for q=11 through 31. The exact `d=4` normal-form
   selector reduces existence to five rational functions of x. Extension tests correct the earlier
   unique-Baer guess: failures persist both at characteristic-5 `x=±2` and characteristic-7
   `x∈{±2,±3}`; the latter reappears in GF(49)/GF(343) from the separately closed q=7 geometry.
2. **A5 lane — arc-depletion arithmetic.** Sole surviving (ON) mechanism route. Open: prove
   `maxonN(q) ≤ q−5` for all depleted q. Min-witness bound holds through q=25; depleted set still
   `{11,17}`. Gated compute: the next-depleted-order census (q=29, ~16 GB / ~15–25 h — user gate).
3. **Independent lanes** — C30 (q17/q19 Lean cert assembly, long-running, gated) pulls in parallel.
4. **Mirror-boundary formalization — C85–C88 [REPORTED 2026-07-12].** Strict-trust lane closed:
   parabolic and Hermitian modeled branches are method-negative; the proposed elliptic `Q⁻`
   exclusion was false and its standard coordinate family is P by an fpf mirror. Final map:
   [mirror-boundary handoff](handoffs/done/2026-07-12-mirror-boundary-formalization.md).
5. **Arcs complete outside a conic formalization — C89–C96 [REPORTED 2026-07-12].** Independent
   spinoff lane closed: the defect, conic, asymptotic, averaging, nucleus, and certified-example
   packages are Lean-proved under the strict trust gate. Final map:
   [relative-conic-arcs handoff](handoffs/done/2026-07-12-arcs-complete-outside-conic-formalization.md).
6. **Applications second-order revisit — C99 [UNBLOCKED 2026-07-12].** The Baer/completion
   formalization and first adversarial review are complete; the post-formalization question has
   been re-asked in the appendix. Next: targeted novelty checks on its best two candidates.
   Appendix/report:
   [paper appendix](2026-07-12-riffing-on-applications/paper-baer-equivariant-robust-completion.md#appendix-a--second-order-corollaries-extensions-and-application-queue).
7. **Relative-conic game localization review — C100.** The persistent cap-game confinement bridge
   and q=11 icosahedral antipodal P residual are Lean-proved. Review the `q=9` terminal witness,
   corpus descent/reachability, and defect-to-C80 potential transfer. Report:
   [C100 relative-conic game bridge](2026-07-12-c100-relative-conic-game-bridge.md).
8. **Exact relative-conic value at q=16 — C101.** Decide the manuscript's sole finite gap by a
   checked eight-point witness or a checked exhaustive nonexistence certificate, then synchronize
   the exact Lean theorem and paper. Track in the
   [rho_C(16) handoff](handoffs/2026-07-12-rhoc16-exact-value.md).
9. **RepairCodes outer trace bridge — C102 [REPORTED 2026-07-13].** The finite-separable trace
   pairing now proves ordinary extension-field dual distance implies the restricted functional-dual
   gate with exact support. Review:
   [asymptotic adversarial review](2026-07-13-repaircodes-asymptotic-adversarial-review.md).
10. **RepairCodes asymptotic outer family — C103 [REPORTED 2026-07-13].** Stichtenoth's self-dual
    TVZ theorem is the sole quarantined import; Lean derives the concrete unbounded q9 family with
    rate `2/19`, eventual distance `≥8/57`, and exact repair rows. Same review and handoff.

## Open tasks

**Proof lanes (open; constituent probes archived as REPORTED):**

- **C101 [ACTIVE 2026-07-12] — decide `rho_C(16)`.** Search first for an eight-point relative arc;
  if none exists, certify exhaustive nonexistence modulo proved conic-stabilizer symmetries. The
  accepted endpoint is an exact strict-trust Lean theorem plus synchronized manuscript/PDF,
  verifier provenance, trust manifest, and papers index. Track in the
  [rho_C(16) handoff](handoffs/2026-07-12-rhoc16-exact-value.md).

- **C102 [REPORTED 2026-07-13] — extension-field trace bridge for RepairCodes.** Kernel-proved in
  `RepairCodes/TraceDual.lean`, including exact support preservation. Track in the
  [Lean formalization handoff](handoffs/2026-07-11-lean-formalization-plan.md).

- **C103 [REPORTED 2026-07-13] — asymptotically good RepairCodes outer family.** The concrete
  family theorem is Lean-checked from exactly one cited import, Stichtenoth Theorem 1.6(ii).
  Track in the [Lean formalization handoff](handoffs/2026-07-11-lean-formalization-plan.md).

- **C99 [OPEN — UNBLOCKED 2026-07-12] — post-formalization second-order application revisit.** The
  completed declaration graph and adversarial review produced equality-in-charge, linewise
  collision profiles, and higher-orbit semantic forbiddenness as fresh candidates. Select two and
  perform targeted novelty checks. Report to the
  [paper appendix](2026-07-12-riffing-on-applications/paper-baer-equivariant-robust-completion.md#appendix-a--second-order-corollaries-extensions-and-application-queue).

- **C100 [ACTIVE 2026-07-12 — localization bridge proved; odd-plane consumers under review].**
  Every projective cap continuation of a `CompleteOutside A H` seed stays in `A∪H`, so every later
  legal move lies in `H`. The exact q=11 determinant residual is now Lean-identified as the
  icosahedral graph and proved P by antipodal mirror. Review/formalize the `q=9` terminal seed,
  exact-corpus descent, and defect/drain-potential link; this is not yet an (ON) theorem. Report:
  [C100 relative-conic game bridge](2026-07-12-c100-relative-conic-game-bridge.md).

- **C89 [REPORTED 2026-07-12] — relative-conic-arcs foundation.** The isolated
  `RelativeConicArcs` target now reuses Mathlib's `Configuration.ProjectivePlane`; arc/secant/hole
  vocabulary, maximal relative completion, attained `rho`, coordinate order `q`, and the exact
  `Arc ↔ ProjectiveCap.Projective.Cap` bridge are Lean-proved. Build is warning-free; headline
  axioms are `[propext, Classical.choice, Quot.sound]`. Track in the
  [relative-conic-arcs handoff](handoffs/done/2026-07-12-arcs-complete-outside-conic-formalization.md).

- **C90 [REPORTED 2026-07-12] — classical secant moments.** Literal unordered endpoint pairs,
  canonical pair lines, and pairwise-disjoint endpoint fibers prove `r_A(x)≤⌊|A|/2⌋`; finite
  double counts prove `Σr=C(k,2)(q−1)` and `ΣC(r,2)=3C(k,4)`. The warning-free target builds and
  headline axioms are `[propext, Classical.choice, Quot.sound]`. Track in the
  [relative-conic-arcs handoff](handoffs/done/2026-07-12-arcs-complete-outside-conic-formalization.md).

- **C91 [REPORTED 2026-07-12] — prescribed-hole defect identity.** The split moments give the exact
  integer-normalized defect identity. Maximum-index bounds prove nonnegativity, coverage/uncovered
  inequalities, the equality criterion, and quantitative stability. The warning-free target builds;
  headline axioms are `[propext, Classical.choice, Quot.sound]`. Track in the
  [relative-conic-arcs handoff](handoffs/done/2026-07-12-arcs-complete-outside-conic-formalization.md).

- **C92 [REPORTED 2026-07-12] — conic specialization and finite lower bounds.** The Veronese conic
  is exactly `XZ=Y²` with `q+1` points; nonsingular conics are explicit projective images and have
  invariant `rhoC`. Abstract `q+1`-hole specialization, parity capacities, and
  `L1(q) ≤ L2(q) ≤ rhoC(q)` are Lean-proved. The warning-free target builds; headline axioms are
  `[propext, Classical.choice, Quot.sound]`. Track in the
  [relative-conic-arcs handoff](handoffs/done/2026-07-12-arcs-complete-outside-conic-formalization.md).

- **C93 [REPORTED 2026-07-12] — additive `3/2` asymptotic.** The parity-free cubic inequality gives
  the explicit bound `rhoC(q)≥sqrt(2q)+3/2−8/sqrt(2q)`. The shortfall is
  `O(1/sqrt(2q))`; operational and literal liminf statements are formalized over indexed families
  of actual finite fields. The warning-free target builds; headline axioms are
  `[propext, Classical.choice, Quot.sound]`. Track in the
  [relative-conic-arcs handoff](handoffs/done/2026-07-12-arcs-complete-outside-conic-formalization.md).

- **C94 [REPORTED 2026-07-12] — projective averaging transfer.** Finite transitive-action averaging
  gives a disjoint projective image for every ordinary complete arc of size at most `q`, proving
  `rhoC(q)≤t2(2,q)` when `t2(2,q)≤q`. The Kim–Vu input is an explicit named hypothesis, not an
  axiom; the warning-free target and axiom audit pass. Track in
  the [relative-conic-arcs handoff](handoffs/done/2026-07-12-arcs-complete-outside-conic-formalization.md).

- **C95 [REPORTED 2026-07-12] — even-characteristic nucleus constraints.** The standard conic plus
  `[0:1:0]` is a hyperoval in characteristic two, giving the exact tangent classification and both
  nucleus-in/nucleus-out count, parity, incidence, and corrected-bound packages. The warning-free
  build and strict axiom audit pass. Track in the
  [relative-conic-arcs handoff](handoffs/done/2026-07-12-arcs-complete-outside-conic-formalization.md).

- **C96 [REPORTED 2026-07-12] — certified small examples and trust audit.** A generic rules-only
  checker reduces coverage to `q²+q+1` canonical representatives and proves accepted raw data
  semantically complete outside the conic. Frozen kernel checks prove `rhoC=6` at `q=8,9,11` and
  `8≤rhoC≤9` at `q=16`; the warning-free build, provenance, isolation, forbidden-token, and axiom
  audits pass. Track in the
  [relative-conic-arcs handoff](handoffs/done/2026-07-12-arcs-complete-outside-conic-formalization.md).

- **C97 [REPORTED 2026-07-13] — full coding/LRC paper assembled and internally audited.**
  `papers/coding-repair-hypergraphs/` contains the 12-page manuscript/PDF, proof ledger, and
  adversarial novelty report. The Lean aggregate, strict token/axiom scan, bibliography, and PDF
  build pass. The audit explicitly returns repair tolerance to prior art and narrows the surviving
  candidate novelty to exact all-symbol `(ν,τ)` separation and complete-hypergraph transfer.
  External specialist citation-chain review remains a submission preflight gate, not a
  formalization or manuscript blocker. Track in the
  [Lean formalization handoff](handoffs/2026-07-11-lean-formalization-plan.md).

- **C98 [REPORTED 2026-07-12] — theorem-mining and novelty review.** The completed proof graph
  yielded the sharp `r+1<2d(I⊥)` transfer gate, a coordinate-free symbol-module extension, exact
  row-distribution transfer, and a square-root-of-minus-one rainbow certificate beyond q9.
  Literature novelty remains unaudited. See the classified results in the
  [Lean formalization handoff](handoffs/2026-07-11-lean-formalization-plan.md).

- **C85 [REPORTED 2026-07-12] — quadratic split-route obstruction.** Chevalley–Warning now proves
  every finite odd-field quadratic form of dimension at least three isotropic; the `±1`
  eigenspace decomposition and scalar-square normalization close the split linear parabolic
  branch. `ProjectiveCap` builds; strict axiom profile is
  `[propext, Classical.choice, Quot.sound]`. Track in the
  [mirror-boundary handoff](handoffs/done/2026-07-12-mirror-boundary-formalization.md).

- **C86 [REPORTED 2026-07-12] — Hermitian linear obstruction.** Relative Frobenius, quadratic norm
  surjectivity/square reflection, and two-vector orthogonalization prove finite Hermitian isotropy;
  scalar-square eigenspaces exclude the split route, while `Norm(c)=μ²` excludes a nonsquare
  similitude scalar. `ProjectiveCap` builds; strict axiom profile is
  `[propext, Classical.choice, Quot.sound]`. Track in the
  [mirror-boundary handoff](handoffs/done/2026-07-12-mirror-boundary-formalization.md).

- **C87 [REPORTED 2026-07-12] — Baer-semilinear obstruction.** Constructive projective conjugacy,
  scalar Hilbert 90, fixed-value quadratic descent, semilinear pullback untwisting, and a
  coordinate-free null-cone rigidity theorem close the modeled square-scalar Baer branches for
  both Hermitian and parabolic boards. The parabolic theorem accepts projective board preservation
  directly. The imported stabilizer axiom was deleted; focused and aggregate builds pass, and every
  load-bearing theorem has axiom profile `[propext, Classical.choice, Quot.sound]`. Track in the
  [mirror-boundary handoff](handoffs/done/2026-07-12-mirror-boundary-formalization.md).

- **C88 [REPORTED 2026-07-12] — elliptic `Q⁻` boundary classification.** The proposed exclusion is
  false. Chevalley–Warning supplies a nonsquare-discriminant anisotropic tail compatible with the
  nonsplit block map, giving a fixed-point-free mirror and P theorem for the standard elliptic
  coordinate form in every even vector dimension. P/N transport through a supplied projective
  linear equivalence is formal. Focused and aggregate builds pass; strict axiom profile is
  `[propext, Classical.choice, Quot.sound]`. Track in the
  [mirror-boundary handoff](handoffs/done/2026-07-12-mirror-boundary-formalization.md).

- **C84 [ACTIVE 2026-07-12 — PRIMARY, abundance-first] — conic-involution Schreier catalogue.**
  Bulk = induced Schreier graph of `H_S ≤ PGL(2,q)`; value set by subgroup type. Proven+verified:
  two-centre full decomposition; `V₄`→`K₄`s (Cor 3.2 mod-8); `D₈`→`M₈⊔K₂` (Thm 4.2 mod-8); `S₄`
  classes; orbit-template theorem; `A₄` excluded. Independent field-geometry verification at
  q=11–19. **Gating measurement done:** escape crux (size-3 → size-4) leaves the small-subgroup
  regime immediately — children generic (full PSL/PGL), so the catalogue is a boundary evaluator,
  not a forcing engine. **Open (reprioritized):** (1) **prove positive-density P** — S₄-rooted
  escaping 4th centres are conic-only-P at density `≈0.13` (min over classes, q=11–23, verified two
  ways; q=7 lone dip; no dip at depleted {11,17}); target `#{y : 𝒢=0} ≥ c·q²`; pairing/mirror
  mechanism ruled out (fpf-involution residual auto covers only a minority) ⇒ the bound must be
  Grundy-arithmetic (decomposition + Weil/character-sum equidistribution the live candidate); then
  uniform over all triple types; (2) **transfer to (ON)** — abundance is off-conic conic-only-P, so
  an exchange/transfer lemma is required to get an on-conic P child; (3) **sealing** =
  complete-arc/saturating-set, **not** blocking-set/Baer ({11,17} nonsquare); (4) minimax potential
  tracking live vertices + live coloured edges (§5 drain bound → C80(b)). Correction: order 24 ≠ S₄
  (D₂₄ occurs at `12|q²−1`, separate by element-order profile). **Frontier sharpened (Fable,
  2026-07-12):** density ≡ `{𝒢=0}` is a dim-2 CvdDM-definable set (equal strength); the open lemma
  is one-sided — **one dim-2 constructible value-0 certificate** — as every known certificate is a
  homography fixed locus = dim 1 = Θ(q); the Fricke coordinate determines value only vacuously
  (near-injective). Near-term lever = existence not density. **Novelty:** conic↔Schreier
  correspondence + value catalogue = the defensible new theorem; orbit-template periodicity =
  known+known bookkeeping. The revised submission includes the `V₄≅D₄` boundary and the full tame
  `D₄ₙ` classification; exact `S₄/A₅` computation now completes the free-orbit `t₁` row across
  all realizable tame small-subgroup types. Its reduction layer builds as the standalone Lean
  `DihedralSchreier` library — [submission](2026-07-12-dihedral-schreier-node-kayles-submission.md),
  [polyhedral regular-template nimbers](2026-07-12-polyhedral-nk-templates.md),
  [novelty audit](2026-07-08-codex-projective-nofil-novelty-audit.md).
  Notes: [Schreier graphs](2026-07-12-conic-involution-schreier-graphs.md),
  [program integration](2026-07-12-conic-involution-residual-graphs.md); scripts
  `c80_schreier_verify.py` (field), `s4_escape_probe.py`, `s4_abundance_check.py`,
  `pairing_witness.py`, `exact_fricke.py`, `refined_signature.py`, `three_centre_probe.py`,
  `schreier_templates.py`.

- **C79 [REPORTED 2026-07-12 — arithmetic coordinates + bulk-gap spec delivered; continuation →
  C80/C81/C82]** — number-theoretic forcing architecture for the full odd-q
  ProjectiveCap proof: test common-torus/dihedral reduction of conic involutions, character-sum or
  polynomial-count existence of repair packets, and Frobenius/subfield descent for the
  characteristic-5/7 exceptions. **First gates:** common-torus recursion is closed (all applicable
  q11/q17 hard triples noncommuting); a five-ray quadratic-character core is locally exact but has
  no extremal selector; maximum-pencil moment/character quotients either collide or become a fully
  marked fingerprint. The positive structural model is the q17 score-9 packet: four primitive
  split/nonsplit candidates, with the unique maximum-zone-edge candidate clean/P in all 28
  transitions. Its zone is one 9-vertex graph; `ProjectiveCap.PrimitiveZoneBase` now Lean-checks its
  Grundy-zero value. Full conic-stabilizer orbital vectors expose a generic score-9 fiber: 24/28
  clean repairs are the unique `(q+1,q+1,q+1)` primitive triple intersections, with four explicit
  exceptional fibers. Hollmann--Xiang intersection numbers are therefore the next reply-counting
  algebra (with odd-q formulas still to derive). Fused quadratic-character relations give an
  abundant two-variable packet only against boundedly many guards. Literal retirement of old
  intruders is impossible while more than half the conic is live: distinct involutions share at
  most one full-conic edge, any such shared edge is dead once both centers are selected, and each
  retains at least `(q-1)/2-d` live edges after `d` deleted vertices. The decisive
  prerequisite is a bulk quotient absorbing many genuinely active matchings. The exact relation polynomial
  `D_x(y)=(2-rv-cu)^2-4(rc-1)(uv-1)` simultaneously gives line-conic and split/nonsplit type and is
  exhaustively convention-checked through q19. For the bulk operator `B=sum P_sigma`, the full
  orbital pair distribution is exactly `tr(B^2)` — a permanent redundancy audit for any proposed
  classifier. On the 24 generic score-9 rows minimum `tr(B^2)` only ties the clean repair with one
  decoy (74 vs 74, others 78); `tr(B^3)` breaks that tie (60 vs 84), and no coordinatewise moment
  rule through `tr(B^4)` covers the four exceptional rows. **Moment lane capped:** moments are
  bulk-audit/bounding language; further moment-selector search re-enters the closed
  static-signature lane. The rule fails below score 9, so continue with packet existence plus a new
  generic descent, not arithmetic P/N classification. Report:
  [`2026-07-11-c79-number-theoretic-forcing.md`](2026-07-11-c79-number-theoretic-forcing.md).

- **C80 [ACTIVE 2026-07-12 — (c) drain proven+verified; (a) abundance / (b) descent open]** —
  game-side bulk-mechanism probe: exhaustion, abundance, descent measure. Report:
  [`2026-07-12-c80-bulk-exhaustion-probe.md`](2026-07-12-c80-bulk-exhaustion-probe.md). Attack C79's spec ("compress many genuinely active, edge-disjoint matchings behind a
  bounded interface") from the game side, where the program is asset-poor — not with more
  arithmetic. Closed mechanism families (do not re-enter): static signatures, global torus/mirror
  pairing (the torus-gate closure also closes classical mirror strategies for the bulk), literal
  retirement, moment selectors. **Design rule:** tune the generic mechanism on **nondepleted**
  orders (q=13/19, plus q=23/25 corpora where usable) and treat depleted q=11/17 as certificate
  territory — leaf obligations and unique-clean-candidate packets track exactly the depleted A5
  census (at q13 every full-cyclic candidate is clean and P; q19 minimum winning degrees are
  43–55), so selection difficulty is plausibly a depleted-order artifact. Three sub-probes on the
  exact balanced-root corpus:
  **(a) Abundance profile.** Per (root R, opponent move x) at nondepleted q, compute the full
  winning-reply fraction and test whether the winning set contains an entire bounded-condition
  packet (e.g. all D-generic on-conic replies minus an explicit bad-fiber list). Target theorem
  shape: at nondepleted q **every** packet member wins — existence by counting, no selector needed.
  **(b) Descent / class preservation.** Test which lexicographic residual measures some winning
  reply always strictly decreases — candidates from (conic defect type, |live conic|, live-edge
  budget `k((q-1)/2-d)`, zone complexity) — and whether some winning reply re-enters the
  balanced/normal-form class or a bounded defect list. Record the conic-killing shape: |live conic|
  along optimal lines (all four score-9 base candidates kill the conic — is "drive the conic dead,
  then play the zone base" the generic strategy?).
  **(c) Drain-rate lemma (provable now).** For a live conic point t, the nonfixed partner points
  `sigma_i(t)` over the k active intruders are pairwise distinct (a shared value is a shared edge,
  whose endpoints die once both centers are selected — the C79 overlap lemma). So each conic
  exchange deletes the full live partner fiber; derive the exact exchange inequality for the
  live-edge budget and compare with corpus play lengths. This is the well-founded resource for the
  two-ply lemma that never evaluates the bulk.
  **Discipline:** any bulk compression proposed from (a)–(c) must pass the outcome-compatible
  quotient gate (P/N collision check on q13/q17/q19) before theorem work. Also record per-state
  winning-degree distributions as input to the Ψ/ledger lane — the fallback mechanism family if no
  measure in (b) validates. **Gate out:** an empirically valid (packet, measure, class) triple
  through q19 becomes C82's counting target. Report target:
  `notes/2026-07-12-c80-bulk-exhaustion-probe.md`.

- **C81 [OPEN — run early, independent of C80]** — characteristic-5/7 subfield gate (C79 note
  probe #4, untested; step-6 de-risk). For the char-5 `x=±2` and char-7 `x∈{±2,±3}` configurations
  over GF(25/49/125/343): classify legal moves as Frobenius-fixed vs nonfixed; test whether every
  nonfixed move has a reply exiting the prime-subfield obstruction class; test even-degree
  involution pairing as one branch and identify the odd-degree mechanism (odd-degree extensions
  supply no Frobenius involution, so orbit pairing alone cannot close it). Bounded and load-bearing
  for the final generic+certificates assembly: if subfield descent fails structurally the
  architecture loses its exception handler — an odds-moving result either way. Report target:
  `notes/2026-07-12-c81-subfield-descent-gate.md`.

- **C82 [GATED on C80 — do not start first]** — orbital / Hollmann–Xiang counting for the C80
  packet. Derive the odd-q two-relation intersection counts for the conic-stabilizer orbital
  algebra (or directly as `chi(D)` character sums) only in service of the specific packet C80
  outputs: main term, square-product degeneracy audit, explicit bad-fiber list, and a concrete
  threshold `q0` with the below-threshold orders enumerated for the certificate layer. Deriving
  H–X odd-q parameters with no consumer is a week-scale detour — hence the gate. Report target:
  `notes/2026-07-12-c82-orbital-counting.md`.

- **C83 [MEASURED 2026-07-12 — deprioritized behind C84, not superseded]** — coarsest
  bisimulation of the residual game grows (29 at q=11 → 65 at q=13; q=17 deferred, canon-bound):
  no finite raw-state automaton. Tractability is a `G∪` structural-width question (→ C84), not
  raw-quotient size. Report:
  [`2026-07-12-c83-bisimulation-quotient.md`](2026-07-12-c83-bisimulation-quotient.md). Original
  bulk-quotient spec: union-graph compression + coarsest value-respecting congruence. Two corollaries of the C79 edge-disjointness
  lemma sharpen the bulk spec. **(1) Union-graph reframing.** On the live conic the k matchings
  union to a **simple** graph `G∪`, and (since no three conic points are collinear) any conic-only
  continuation is exactly Node-Kayles on `G∪` — per-intruder identity (edge colors) provably drops
  out of that layer; k re-enters only through intruder-move interleaving (off-conic supply,
  fixed-point kills, the ≤2-per-line cap). The bulk problem restates as **Node-Kayles under
  algebraic matching-augmentation** on one evolving graph. First candidate for the
  outcome-compatible quotient gate: state ↦ (uncolored `G∪` up to iso, off-conic supply parity,
  bounded bookkeeping) — P/N collision check on q13 first; collisions localize exactly which
  geometric residue a true quotient must retain. **(2) Watched-set re-basing of packet
  conditions.** Per-prior orbital relations impose k conditions (density `2^-k` — the C79
  obstruction); a condition prescribing `σ_y` on a bounded watched subset `W` of `G∪` is
  bounded-codimension in y's two coordinates **independent of k**. If the strategy needs only a
  bounded watched region (exactly C80(a)'s abundance hypothesis), packet density survives every k.
  Caveat recorded: the score-9 relations-to-all-priors shape arose with one live conic point left —
  a low-live-conic artifact, not the generic template. **(3) Decisive measurement.** The canonical
  object behind C79-note goal 2 ("quotient into component types preserving P/N") is computable
  exactly on small q: run partition refinement (Grundy-labelled bisimulation) on the exact residual
  DAG at q11/q13 (q17 descendant-only if it fits); report minimal-quotient class counts vs q and
  reverse-engineered class invariants. Small/stable ⇒ the bulk quotient exists and the theorem
  takes the octal-periodicity shape (automaton with arithmetic transition guards; C82 counts its
  reply guards). Blow-up ⇒ close the quotient lane and concentrate C80 on abundance/descent. An
  odds-moving dichotomy either way. Report target:
  `notes/2026-07-12-c83-bisimulation-quotient.md`.

- **C76 [REPORTED 2026-07-11 — invariant prong answered]** —
  frame-relative characters (polar-at-frame, frame-chord, frame×tangent cross-ratio profiles) — the
  frame-awareness the (x,z)-local selector space omitted — cut the C75 collisions **48→1**: they split
  47/48 enumerated twins (polar+chord) and separate the winner/loser classes almost everywhere. **But
  the augmented space is NOT orbit-injective** (1 residual hard twin, q=17 axis points P `11,0`/N
  `16,0`), **no scalar reduction is monotone** (39/48 and 38/48 separators are direction-MIXED), and
  **no uniform linear selector exists** (C77-selector-test LP infeasible over d=37). So it buys
  separation, not selection — routing the escape proof to a **game-semantic reply closure**. Report:
  [`2026-07-11-c76-frame-aware-invariant-orbit-injectivity.md`](2026-07-11-c76-frame-aware-invariant-orbit-injectivity.md);
  scripts `rust/scripts/c76_invariant_hunt.py`, `c76_directional_search.py`, `c77_augmented_selector.py`.
- **C77 [REPORTED 2026-07-11 — DROP peak theorem proved; game-semantic certificate residue OPEN]** —
  C63's growing Ψ debt is entirely the loose `reservoir_slack` term. After deleting it, the pure
  conic ledger `DROP = 6·defect − 4·intruders − 2·[xor=0]` satisfies the **all-depth theorem**
  `DROP(S) ≤ DROP(root)=6(q−5)−2` for every odd q: an intruder pays `−4`; without intruders a proper
  descendant has at most `q−6` live conic vertices; the root's `q−5` isolates have xor zero. The q23
  solve is no longer needed for bank capacity or full-depth DROP debt. The `q−5` cross-lane check is
  **negative**: A5's `maxonN` is a class-extremal P/N count, while `defect_components` is a
  value-blind graph count fixed at `q−5` at the root; identifying them assumes the desired P witness.
  **Continuation:** the game-semantic residue is exactly C74's maximum-pencil absorption problem.
  Exact data gives `Ncenters≤q−8` at q=11/13/17/19 (tight q=17), while simple character/order
  selectors fail across q. The two-stage value-blind `Low4` packet contains ≥3 P centers on every
  maximum pencil; maximum-line selection is load-bearing by the non-maximum controls. All 32 distinct
  P centers in the q=11 knife-edge pencils have perfect winning-reply matchings in only four graph
  isomorphism types. The exact five-spoke formula makes `Low4` the fourth-order packet of
  `K=Σδ_e−t`; identical `(K,t)` types can be both P and N, so the missing lemma must compare packet
  games rather than classify one center. The balanced subtype `(d,5,5,6,6)` is P in all 760 exact
  q=11/13/17/19 occurrences and exists geometrically for tested prime q=11 through 31. Unconditional
  existence is false. The exact `d=4` normal form `A={0,±1,±x}` gives four rational candidate
  parameters whose singleton values are exactly the balanced centers. Tests through prime q=101 and
  GF(9/25/27/49/121/125/343) isolate two inherited small-subfield failures: characteristic 5 at
  `x=±2` and characteristic 7 at `x∈{±2,±3}`. The rational equality split is now proved: these are
  exactly the empty-selector cases over every odd field. **Open:** prove the weaker sufficient
  balanced-packet theorem (some balanced center is P), and handle the two subfield configurations
  separately. Universal P-purity is deprioritized: individual forced states do not compress, while
  q17 maximum-pencil packets have only four forms. The
  `d=5` branch is reduced to a twelve-certificate ledger: balanced centers are exactly legal
  degree-two parameters. Four exact paired-label identities prove `n1≤4`, and a three-orbit pole
  argument proves `T≥10`, and three factored representative identities prove legal degree `≤2`.
  The forbidden-target audit is now complete: five excluded label/target orbits factor to primary
  contradictions; five singleton-pair orbits give four contradictions/templates and one genuine
  characteristic-3 weight-two family with no paired target. Thus `F≤3` and the full d5 geometric
  theorem are proved: every maximum d5 pencil has at least two balanced centers. Hence the generic
  balanced-center existence geometry is closed for both d4 and d5.
  **P-purity probe:** simple affine mirroring is closed-negative—none of the 32 distinct balanced
  q11 roots has even a root-safe affine involution. Full-grid canonicalization gives 8/12/24/85
  balanced orbits and 2/3/6/18 coarse residual types at q11/13/17/19; every capacity-1 graph is
  connected and retains capacity-2 lines, closing finite-template and component-decomposition
  routes. The q11 base itself compresses exactly: two winning-reply graphs, while all 32 roots share
  one 33-edge losing-pair graph `3·(K2 join 2K2)`. Continue with adaptive algebraic reply closure,
  not a fixed pairing. Exact solve-once q17 profiles show five of six coarse types have degree-one
  opponent moves (48 forced directions spanning 24 S6 grid-orbits), so the missing lemma must
  explain forced replies; density/Hall and small response-template routes are not viable. Their 39
  S5 orbits have no cross-root collisions—the nine repeats are exactly order-two root-stabilizer
  pairs—so there is no common forced-state orbit family either. Exact marked conic-involution
  coordinates now separate every degree-one reply on all balanced q11/q17 root orbits and are
  globally P-pure over the full controls (`24/24` over 888 q11 pairs; `192/192` over 145,560 q17
  pairs), once the on-conic boundary records the balanced-center action. This is separation, not
  selection: the q-independent equality-pattern quotient falls to `160/192` at q17 and no natural
  overlap scalar uniquely selects more than `28/192`. Use these as coordinates for an algebraic
  reply proof; do not continue static-signature mining. The two remaining exact relational
  candidates are also closed-negative at q17: canonical aligned `K5` component incidence reaches
  only `172/192` global purity, and projective order/commutator-Fricke type only `24/192`.
  **Reopened mixed-feature hit:** full Rédei directions plus residual `(live, conflict-edge count)`
  is `192/192` with 90 forced types. In proof-relative form only the five new reply directions
  `D_y` and `ΔE` are needed; `(D_y,ΔE mod 3)` is locally exact `192/192` once S5 context is fixed.
  No linear mod-3 formula in simple collision counts fits. The decomposition `ΔE=-R_y+A_y`
  yields a field-label-free replacement: reply-pencil load residues plus labelled old-secant
  incidence select `191/192`, and the Boolean `Q3(y)` that some direction quotient occurs three
  times closes the sole twin. With the implicit S5 parallel/quotient spectrum prepended, this is locally unique and
  globally P-pure `192/192` (q11 `24/24`). It remains a contextual separation certificate with 182
  forced types, so the proof target is an algebraic incidence case split, not a static dictionary.
  The exact leaf scope is now closed through q19: every q13 balanced-root orbit has minimum winning
  degree 2, while all 85 q19 orbits have minimum 43–55; only depleted q11/q17 contain degree-one
  obligations. A P root always gives minimum degree at least 1, so forced obligations are precisely
  equality cases (leaves) in this automatic reply-existence bound. All minimum-degree q11/q13/q17
  S5 states have trivial grid stabilizer, and q13 degrees can be odd, excluding symmetry and parity
  as explanations for the nondepleted degree-two upgrade.
  Alternatively prove
  the uniform `Low4`
  packet theorem/N-absorption bound; do not spend more compute on the DROP envelope. Reports:
  [`2026-07-11-c77-ledger-bank-probe.md`](2026-07-11-c77-ledger-bank-probe.md),
  [`2026-07-11-c77-ledger-spike-structure.md`](2026-07-11-c77-ledger-spike-structure.md) (§6–9); modes
  `s4ledger`/`s4spike` in `notes/2026-07-06-grid-cap-solver.rs`;
  [`2026-07-11-c77-game-semantic-reply-graphs.md`](2026-07-11-c77-game-semantic-reply-graphs.md),
  scripts `rust/scripts/c77_pencil_value_probe.py`, `c77_intruder_reply_graph.py`,
  `c77_balanced_center_geometry.py`.
- **A5 arithmetic proof** (open lane, no single ID) — `maxonN(q) ≤ q−5` for all arc-depleted q, plus
  the q=29 next-depleted-order census (gated compute). Anchor context:
  [`2026-07-09-codex-depletion-fraction.md`](2026-07-09-codex-depletion-fraction.md),
  [`2026-07-10-codex-a5-nbucket-density.md`](2026-07-10-codex-a5-nbucket-density.md),
  [`2026-07-10-a5-symmetric-completion-anchor.md`](2026-07-10-a5-symmetric-completion-anchor.md).
- **C74 residue (now the C77 game-semantic continuation)** — prove the two-stage packet theorem:
  on a maximum (`min d`) one-intruder pencil, the fourth-order-statistic low-`zone_v` packet contains
  a P center (observed ≥3), implying `Ncenters≤q−8`. Geometrically this is the fourth-order packet
  of the five-spoke collision score `K=Σδ_e−t`. Sharper route: prove P-purity/existence of balanced
  `(d,5,5,6,6)` centers in the generic branch and handle the characteristic-5/7 subfield
  configurations separately. The d5 geometric branch is closed: the certificate ledger proves at
  least two balanced parameters on every maximum d5 pencil. Remaining geometry is the d4 generic
  equality split and its characteristic-5/7 exceptional configurations.

**Independent / engineering:**

- **C30 [REPORTED 2026-07-10 — certcheck PASS; open engineering tail]** — generated-checker refactor →
  q17/q19 Lean assembly. The v5 full q17 canonical build projects above 21.5 h sequential, tripping the
  task's ~10 h user-launch gate; do not launch implicitly. Next = an explicit launch decision or a
  build-shape reduction, then q19 sizing.
- **C13 [OPEN]** — q=9 intrusion-structure probe (the next odd-plane Lean target; the q=9 Lean
  kernel/certificate is still open per the handoff Status Table). Report target
  `notes/2026-07-07-codex-q9-intrusion-probe.md`.
- **C16 [OPEN — dormant]** — sum-free Tactic 2, induction on `r` (`Z3^r × Z_p` is N iff r=1); a
  separate work stream, dormant unless resumed. Report target
  `notes/2026-07-07-codex-sumfree-induction-r.md`.
- **C56 [CLOSED-GATED — do not start]** — group-indexed cross-q type alignment; gated on a C55
  positive, and C55 is NEGATIVE, so it stays closed.

**Reported this pass:**

- **C78 [REPORTED 2026-07-11]** — Lean-checked the universal pair/secant-cover bound and the
  `PG(4,5)` numerical consequence `t₂(4,5) ≥ 21`; the exact wide-bitset `PGL(5,5)` census has orbit
  curve `[1,1,1,1,2,4,10]` through size 6, while a wall-safe size-7 run cuts off at 120.023 s.
  Representation is solved for the probe; exact canonicalization is the measured next lever.
  Report: [`2026-07-11-c78-pg45-complete-cap-quick-deliverable.md`](2026-07-11-c78-pg45-complete-cap-quick-deliverable.md).
- **C76 [REPORTED 2026-07-11]** — frame-relative characters cut the C75 collisions 48→1 but leave a
  residual hard twin and no uniform selector (linear LP infeasible); invariant prong answered, ledger
  is the surviving lever. Report:
  [`2026-07-11-c76-frame-aware-invariant-orbit-injectivity.md`](2026-07-11-c76-frame-aware-invariant-orbit-injectivity.md);
  scripts `rust/scripts/c76_invariant_hunt.py`, `rust/scripts/c76_directional_search.py`.
- **C75 [REPORTED 2026-07-11]** — value-blind reply-selector impossibility. 19 of 108 hard obligations
  hold a P and an N reply that are byte-identical on all 17 program features → the wall is
  feature-completeness, not coordinate choice, and the deficit grows with q (6% → 7% → 39%). Names the
  C76 invariant hunt and re-weights (ON) toward the amortized/ledger potential. Report:
  [`2026-07-11-c75-value-blind-selector-impossibility.md`](2026-07-11-c75-value-blind-selector-impossibility.md);
  script `rust/scripts/c75_linear_selector_lp.py`; solver `gridcap-c75`.

**Opportunistic / diagnostics (no priority; pull as diagnostics — full specs in the archive):**
C23 / C40 (winline viz lanes), C49 (piece nimber tables), C57 (zone quasi-randomness), C60
(Singer-model probe), C66 (grid-terminal spectrum), C67 (coupling-defect spectroscopy).

## Settled lanes (one-line pointers; full task bodies in the archive)

- **Cluster 1 — config→value mechanism sweep: CLOSED, no static dictionary found (de-prioritized in
  favor of A5, not proven impossible).** C55 group-side
  [`2026-07-09-codex-d-lattice-side-switch.md`](2026-07-09-codex-d-lattice-side-switch.md), C64
  extremal poset [`2026-07-09-codex-completion-poset.md`](2026-07-09-codex-completion-poset.md), C69
  algebraic envelope [`2026-07-10-codex-envelope-invariants.md`](2026-07-10-codex-envelope-invariants.md),
  and the Ψ dynamic probe [`2026-07-10-psi-dynamic-flip-probe.md`](2026-07-10-psi-dynamic-flip-probe.md)
  all NEGATIVE. Re-entry conditions in the archived Cluster-1 status note.
- **A5 depletion evidence — all REPORTED; q=25 non-depleted (28/28 P), depleted set still {11,17}.**
  C68 `D(q)` + C68b ν(q) (links above), C72 f_q decomposition
  [`2026-07-10-codex-c72-fq-decomposition.md`](2026-07-10-codex-c72-fq-decomposition.md), C73 secant
  packet [`2026-07-10-codex-c73-secant-packet.md`](2026-07-10-codex-c73-secant-packet.md), q=25 census
  C43/C44 [`2026-07-09-codex-q25-baer-census.md`](2026-07-09-codex-q25-baer-census.md), order-9 planes
  C58 [`2026-07-09-codex-order9-planes.md`](2026-07-09-codex-order9-planes.md), arc-stability C59
  [`2026-07-10-codex-arc-stability-import.md`](2026-07-10-codex-arc-stability-import.md), round-1/round-2
  theorem frontier
  [`2026-07-10-codex-odd-plane-round1-report.md`](2026-07-10-codex-odd-plane-round1-report.md),
  [`2026-07-10-codex-odd-plane-round2-report.md`](2026-07-10-codex-odd-plane-round2-report.md).
- **Selector / potential probes — all REPORTED; the wall is explained by C75.** C61 reply automaton,
  C62 selector scoring, C63 potential LP/dual, C70 collision charge
  [`2026-07-10-codex-c70-collision-charge.md`](2026-07-10-codex-c70-collision-charge.md), C71
  third-intruder transition
  [`2026-07-10-codex-c71-third-intruder.md`](2026-07-10-codex-c71-third-intruder.md).
- **C50 [REPORTED 2026-07-10 — tiny PASS / literal-scale NO-GO]** — reflected Grundy-book cert format
  in Lean; replace linear literal lookup before a C35 adapter.
  [`2026-07-09-codex-grundy-cert-format.md`](2026-07-09-codex-grundy-cert-format.md).

---

The remaining history — the verbose priority-ordering snapshots, the original ranking + Fable
Nth-pass amendment trail, and every REPORTED / NEGATIVE / NO-GO / DONE task body (C1–C74, plus the
untagged bodies C14/C15/C22 subsumed by later work) — was moved verbatim on 2026-07-11 to
[`2026-07-07-codex-task-queue-archive.md`](2026-07-07-codex-task-queue-archive.md).
