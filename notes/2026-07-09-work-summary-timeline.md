# Work Summary — Week-by-Week Timeline

Companion to [`2026-07-09-work-summary.md`](2026-07-09-work-summary.md) (the timeless scope report).
Activity spans **2026-06-14 → 2026-07-15** — five working weeks, with a quiet stretch Jun 28–30.
This is the *chronological* view; the scope report is the *state* view.

The arc in one line: **Othello engine → Queens solver + open problem → CGT theory pivot →
projective-cap program → a publication portfolio**, with Lean formalization ramping alongside from
week 2 on and becoming the release gate in week 6.

---

## Week 1 — Jun 14–20 · Othello engine + Queens solver foundation

- Ported the Python Othello engine to Rust: bitboard core, disc-differential eval, depth-aware cache,
  the engine ladder (minimax / alphabeta / ordered / strong), native endgame solver, and the
  cross-engine value-equivalence test suite.
- Stood up the Queens solver's memory spine: flat lockless TT, TT dump/load, the **BuRR** succinct
  store (live implementation), the iso-key canonicalization, and an inner-loop rewrite.
- Landed **iso-flat** → **iso-window** solvers; fixed flat-TT contention; measured per-ply distinct
  counts and the n=14 throughput regression; explicit-stack frontier.
- First Node-Kayles literature/levers pass (the queens game = Node-Kayles on the queen graph).

## Week 2 — Jun 21–27 · Queens n=18 push + Lean getK verification

- Matured the **iso-dense** solver: the `W_K` hierarchy + `getK` Node-Kayles leaf evaluator (BMI2
  `pext`), the fastest lineage member; "push-past-floor" lever sweeps.
- Opened the **n=18** campaign: umbrella handoff, n18 work plan, BuRR-backed iso-dense design, the
  384-bit board branch, and a hunted-down n18 migration verdict bug.
- Evaluated and rejected a RocksDB store; wrote the reflections + human-effort-estimate notes.
- Began the **Lean 4** layer: formal verification of the `getK` leaf recurrence + Grundy semantics
  (phases 1 & 2 complete, `no sorry`).

## Week 3 — Jun 28 – Jul 4 · Theory pivot: nimbers, Node-Kayles, sum-free

- Reframed Queens as the **A344227** nimber problem; computed G(14)=0, G(15)=1, G(16)=0, G(17)=2 and
  resolved the **n=18 outcome** (first-player win, opening I9); prepared the OEIS submission package.
- Broadened into CGT theory: solver-theory targets, CGT-adjacent targets, placement-games primer,
  n=20 winning-geometry probes, connections deep-dive, external review/backlog.
- **Node-Kayles day (Jul 4):** the Cayley outcome law, pairing lemmas, `C_n^k` = octal-game family,
  the fast octal engine, analytic plan — the substrate theory the cap program later reuses.
- **Sum-free opening (Jul 4):** the sum-free and cap-set game definitions + first theorem sketches
  and variants; border-signature mining scripts for the queens geometry.

## Week 4 — Jul 5–9 · The projective-cap program

- **Sum-free theorems land (Jul 5):** the `Z_n` mod-6 law, the abelian 2-rank criterion, `F₃ⁿ = N`,
  `Z₂×F₃ᵇ = P`, the affine cap theorem — with the **socle-reduction = FALSE** counterexample
  (`Z₃²×Z₇ = P`) pruning the tempting shortcut; qeven/qodd plane theorems; parallel sum-free solvers.
- **gridcap + projective handoff (Jul 6):** wrote the standalone PG(2,q) grid-cap solver, the frame
  reduction, the size-3 escape crux, conic localization, and the qodd mirror-obstruction findings.
- **Proof infrastructure (Jul 7):** the named-expert-personas system, the kernel proof notes, the
  Nofil-connection framing, the codex task queue, and the arc-census / PGL-orbit / certificate
  scaffolding.
- **Compute campaigns (Jul 8):** the **S4 memo-dump / query / mining toolchain** + its manual;
  intrusion / mirrorgood / zone-steering censuses; the C30 route-C certificate books; C32 killing the
  composite mirror; the handoff refactored to a current-state map.
- **Harvest + kernel + framing (Jul 9):** new P-families via the fpf mirror — hyperbolic quadric
  (C48), symplectic `W(2n−1,q)` (C51), Segre products (C52), all with Lean; the full-PGL bridge (C53)
  clearing q=23; `TrapConverse` closing the escape equivalence in Lean (C41); the **conic⊕zone
  decomposition proven FALSE** (C35), redirecting the kernel to a coupled maintenance invariant;
  tablebase distillation / remoteness / type-census diagnostics (C36–C42); the Node-Kayles
  double-encoding gap **CLOSED** in Lean; and the deliverables proposal + line-capacity novelty vet.

## Week 5 — Jul 10 · Rounds 1–2: the L(A) route emerges

- **Codex program assessment adopted (morning):** the (ON)-vs-conjecture bifurcation
  pre-registered into C44; C70–C72 queued; the C61 successor reframed *existential*
  (admissible-reply set over incidence data, no more deterministic argmin rules).
- **Four parallel Opus sub-tasks:** the C44 off-conic rider (worst-class fallback margin `8 → 4`,
  co-depletes with the on-conic layer at q=17); **C70** (exact collision charge
  `M = E + delta0col` proved — the Ψ truncation hides a deterministic `(q,ply)` drift, not a
  reply discriminator); **C71** (the 2→3-intruder transition is NOT center-geometric; the missing
  coordinate is the labelled live-cell embedding; `dΨ = [6·dC−4] + [dReservoir−2·dXor0]` exactly;
  `D(z)=∅ ⇒ dC ≤ 0` proved); **C72** (no harmonic identity for `f_q`; exact gift
  `f_q ⊥ V₁⊕V₂⊕V₃`).  Synthesis: the only reply-varying quantities in `dΨ` are **kill-set
  incidences** — three independent tasks converged on the same coordinate.
- **Codex round 1 (verified before adoption):** the involutive-completion lemma (15 constructions
  per five-frame); `fiber(B) = 30(q−1)/|Stab(B)|`; the **q=17 (ON) statement PROVED from bucket
  stabilizers** (capacity 15 > q−4 = 13) — the first structural explanation of the knife edge;
  stabilizer-specialness ⇒ P refuted; the q=17 **secant packet** found (all five P escapes of
  each knife-edge class on one line through the on-conic witness).
- **C73 (Opus):** the packet made value-blind — `L(A)` = the max-legal-incidence secant carries a
  P escape **68/68** across q=11–19 (q=17 null base 49% → 100%); witness-anchoring refuted;
  label-blind q=25 test pre-registered.
- **Codex round 2 (verified):** the `L(A)` algebra completely solved — the involution pencil
  `τ_a(t) = a/t` minus the pair products `P2(U)`, `nlegal = q − d`, with the tie theorem via
  `Stab(A)` involutions retro-explaining every observed tie; the stabilizer-capacity route closed
  by the ≤ 838 counting bound; the kill-set top-k ≤ 4 rule refuted at q=23 (11 exact failures in
  7 rigid classes → **generic discharge + explicit exceptions** becomes the selector program's
  form); the tied-line **concurrence point** P 10/10; the label-blind q=25 fan matrix forcing
  **`min-witness(25) = 0 or ≥ 3`** (pivot bucket 14; Veronese point `(1:15:9)` frozen as
  predicted P).  Route **(L_forall)** named; the sharpest open lemma is now the **one-intruder
  pencil N-absorption statement**.
- **q=25 census** (8 GB arena, ~6.7 h) ran through Jul 10 and **completed all 28 on-conic buckets P**:
  `min-witness(25) = 21` (full), q=25 **non-depleted**, so the knife-edge across the two depleted
  orders `{11,17}` rebounds fully. Prize recalibrated ~35–45% eventual, upper half riding on this
  now-resolved q=25 unblind.

## Week 5 continues — Jul 10–11 · The geometric/coding spin-off portfolio

Two strands run in parallel: the odd-plane kernel's selector program converges on the amortized
ledger, and the cap machinery starts generating standalone finite-geometry and coding-theory
deliverables (all about geometric *legality*, none proving game value — each carries an explicit
game-boundary caveat).

- **Selector program → ledger (C74–C77, Jul 10–11):** C74/C75 proved every *pointwise* value-blind
  reply selector impossible in the program's feature space (the feature-completeness wall); C76's
  frame-relative characters split all twin classes (collisions 48→1) but yielded no monotone selector;
  C77 then proved the conic ledger `6·defect − 4·intruders − 2·[xor]` root-peak-bounded at all depths
  for every odd `q` (the apparent "debt growth" was a reservoir artifact) and isolated the open
  `Low4` packet/absorption theorem as the sharpest target. Alongside, the A5 anchor established the
  value-blind smallest-`Stab`-orbit child as a no-exception (ON) witness (mechanism "P ⟺ point-stab
  involution" refuted), and a q=29 census was sized as the gated next depleted-order test.
- **Three extension/rigidity "upgrade" theorem reports (Jul 10):** Baer-equivariant arc extension
  (the mixed-cover dictionary, the quantitative conjugate-pair extension theorem, and the `√2·s`
  orbit-saturation bound); completion-core rigidity (the sharp deletion theorem, exact completion
  distance `δ` for conics / hyperovals / maximal `d`-arcs / elliptic quadrics / GQ ovoids / spreads,
  and the NRC zero-sum ↔ cap-set bridge); continuation-graph rigidity (four-frame semilinear rigidity
  for `q ≥ 13` via the `M_{0,5}` reduct, plus full continuation-complex reconstruction of the plane).
- **Coding/MDS cross-field sweep (Jul 11):** the characteristic-matched Roth–Lempel NMDS-LRC family,
  the twisted-cubic–axis `τ > ν` all-symbol repair family (uniform over `q = 3^h ≥ 9`), and the
  bounded-repair concatenation transfer lemma with Garcia–Stichtenoth outer codes; the Cheng–Murray
  and mixed-alphabet routes closed. Every result tagged PROVED / COMPUTED-EXACT / LITERATURE-IMPORTED /
  REFUTED, with replay scripts + sha256 hashes moved into a tracked location for rerun discipline.
- **Portfolio key-card deck + applied-synthesis fanout (Jul 11):** twenty neutral key cards (K1–K20)
  abstracting the proved/computed objects into a shared input deck; a root-authored pre-fanout
  application synthesis ranking ~20 cross-domain directions (dependency-resilience analyzer, robust
  experimental design, repair-code compiler, canonical-reconstruction engine, proof-carrying
  finite-search platform); then a three-agent key-card fanout kept separate so the independent views
  stay comparable.

## Week 6 — Jul 12–15 · The portfolio: papers, lanes, and the Lean release gate

The centre of gravity moves from *prove the odd-plane kernel* to *ship what is already proved*. The
spin-off theory of week 5 becomes an actual publication track (`papers/`), the single cap program
fractures into lanes that run concurrently, and the Lean gate hardens from aspiration into release
policy. The odd-plane kernel keeps running underneath as one lane among several.

- **Jul 12 — the mirror boundary closes, the arcs library lands, `papers/` opens.**
  The mirror-boundary formalization (C85–C88) closed under the strict-trust gate, and in closing it
  **overturned one of our own negatives**: the conjectured elliptic `Q⁻` exclusion is FALSE. A
  uniform nonsplit block mirror preserves a standard elliptic form in every even vector dimension, so
  `Q⁻` joins `Q⁺` as a Lean-proved P family. The final boundary is that the mirror method is positive
  on **both** standard even-dimensional orthogonal types, and method-negative only on the modeled
  parabolic and Hermitian branches. Alongside it, the arcs-complete-outside-a-conic library
  (C89–C96) went Lean-proved end to end — defect, conic, asymptotic, averaging, nucleus, certified
  examples — closing the "one finished manuscript with zero Lean" gap. On the kernel itself, C84's
  conic-involution Schreier catalogue identified the conic bulk as the induced Schreier graph of
  `H_S = ⟨σ_x : x ∈ S⟩ ≤ PGL(2,q)` with exact nimbers by subgroup type, but its gating measurement
  demoted it: the escape crux leaves the small-subgroup regime immediately (children are generic,
  full PSL/PGL), so the catalogue is a **boundary evaluator, not a forcing engine**, and the lane
  reprioritized abundance-first. C83 measured the coarsest bisimulation growing (29 at q=11 → 65 at
  q=13); C80's drain lemma was proven. The dihedral Schreier submission was drafted. Finally,
  **`papers/` staging was created** and the Fable packaging review resolved the decomposition into
  six papers (+1 conditional) + two OEIS, with rulings D1–D6 — fold the projective mirror outcomes
  into the games flagship, focus Baer on Q25, continuation N1-only, no standalone sum-free paper,
  hold the Lean gate.

- **Jul 13 — spin-offs become lanes; the Clebsch hexagon surfaces.**
  `ρ_𝒞(16) = 9` settled exactly (C101), and the relative-conic game localization with its q=9
  terminal and q=11 icosahedral P witnesses went Lean-proved (C100). RepairCodes closed C102–C105
  (trace bridge, asymptotic GF(9) family, exact cubic matching, transfer-boundary theorem). Three
  independent lanes opened — relconic strengthening (C106–C110), repaircodes projective completion
  (C111–C114), and the twisted-cubic cross-lane (C115–C120), where C115 proved the
  projection→plane-cubic reduction and the **axis closed form `τ_axis = q − r₃(h)`**, reducing that
  orbit to the cap-set problem. Then the **icosahedral MDS / deep-holes lane opened (C121–C132)** and
  converged within the day: the `[6,3,4]₁₁` MDS code whose deep holes are exactly a conic, with `A₅`
  *recovered* from a purely coding-theoretic hypothesis, the **rigidity theorem** (the Clebsch
  hexagon is the unique 6-arc in `PG(2,11)` with deep holes on a conic), and the gap theorem.
  Red-team passes ran against it the same day and killed the dual-variety conjecture (C123) and
  closed C132 negative: there is **no second instance** of deep-holes = a named variety — structural,
  not exhaustion. The family runs through the k-tower, not through p.

- **Jul 14 — the biggest day: four new lanes, two seam rulings, an adversarial takeover.**
  The routing model was rebuilt: concurrent lanes with spoken aliases, ask-on-bare-`go`, and every C
  item lane-pegged; the single-primary-lane model is retired. In **`clebsch`** (the renamed
  icosahedral lane) the manuscript and its Git-indexed Python checkers landed, and the
  Schreier=icosahedron witness was certified in Lean by pure `decide` — but an adversarial takeover
  audit found the paper conflating received-word deep holes, syndromes, leaders, and supports, and
  C163–C173 repaired the mathematics, terminology, prior art, and scope end to end. **C170** replaced
  the conditional `A₅` route with an exact four-frame census over every prime power `q ≤ 14`, giving
  **unconditional** q=11 uniqueness; **C171** replaced a false global gloss with the PGL-invariant
  nearest-conic discrepancy, where the Clebsch class is the unique zero and every other class has
  sharp gap `δ ≥ 12`. Two **seam rulings** landed in `papers-planning.md`, both the same anti-salami
  pattern of one computation with two readings: *Clebsch after Arcs* (`arcs` ships first and owns the
  deep-holes=conic identification; `clebsch` claims only the reading) and *Arcs vs Nofil* (`nofil`
  owns the game reading, `arcs` the arc/extension reading, neither co-claims). **`baer`** finished —
  C134–C141 reported, focused Q25 manuscript and clean PDF, and the uniform theorem (every
  Frobenius-invariant eight-arc in `PG(2,25)` has a fresh conjugate-pair extension) Lean-built across
  all parity profiles and lifted to **every prime power `s ≥ 5`**. Three lanes opened:
  **`alt-orbit-repair`** (C142, kernel-checked alternate-orbit repair for invariant ten-arcs over
  every `s ≥ 7`, at least eight alternatives), **`gem-mining`** (C147's hexad polarity
  characterization — *a 6-subset of the conic in `PG(2,11)` is a hexad of `S(5,6,12)` iff no three of
  its chords are concurrent off it* — fully machine-checked, with C174 generalizing to
  `t(H) + |U(H)| = q²−14q+115` for every six-arc in every finite projective plane), and
  **`build-sys`** (C162, after generated-certificate builds started OOMing the 26 GiB box: measured
  concurrency caps replace guesses). Literature sweeps ran all day and several landed **against** us
  — the hexad four-orbit classification is published (Cameron–Omidi–Tayfeh-Rezaie 2006), so our
  converse closes by citation; Edge 1956 is prior art for the arcs lineage; the q=23 octad analogue
  is dead. A Fable vet then caught a parity error and two overdrawn framings in the same day's
  gap-theorem docs, and those were corrected in place.

- **Jul 15 — repair theorems land; Clebsch trades computation for proof.**
  **C143**'s two-witness `f=2` certificate and uniform Q25 alternate-orbit repair theorem passed a
  10,604-job kernel build, trace-only replay, source-trust audit, verified recovery backup, and the
  manuscript/PDF gate; **C148** followed with the exact general-`s` five-profile lower-bound envelope
  and a uniform **318-alternative** corollary. In `clebsch`, two tasks replaced censuses with
  arguments: **C180** derives the exact chord identity `|U(A)| = 22 − c` and closes the
  degenerate-line-pair branch via Dye's `c ≤ 10` Brianchon extremality, and **C181** makes "why
  q=11" classification-free — `c = (q−6)(q−9)` against the universal matching bound `c ≤ 15` rules
  out every `q ≥ 12` in all characteristics, leaving geometric exclusions at q=4,5,9. The censuses
  stay as verification, not as the explanatory spine. C176 completed the Brianchon/Petersen
  dictionary; C184 and C187 opened the low-degree-locus and `k ≤ 7` classification ladders. The
  portfolio's sharpest remaining exposure is now a **single unread pair of papers**: C153 must obtain
  the two Blokhuis–Seress–Wilbrink originals, since every "ours" verdict on the covering fact is
  conditioned on them and one is titled *Characterization of complete exterior sets of conics*.

---

*Snapshot; the live task frontier is the codex task queue, the per-lane handoffs, and
[`papers/papers-index.md`](../papers/papers-index.md).*
