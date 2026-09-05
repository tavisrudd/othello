# Work Summary — Week-by-Week Timeline

Companion to [`2026-07-31-work-summary.md`](2026-07-31-work-summary.md) (the timeless scope report).
Activity spans **2026-06-14 → 2026-09-04**, with quiet stretches Jun 28–30, Jul 27, and Aug 16–17.
This is the *chronological* view; the scope report is the *state* view.

## Content split between the two documents — binding rule

The two files differ in **what may be mentioned**, not only in tense:

- **The scope report is externally facing.** It must give **no indication of how the work was
  produced** — no models, agents, sessions, task IDs, lanes, handoffs, queues, delegation, review
  passes, or any other internal process. It states mathematics, evidence, and trust tier only. A
  reader must be able to take it for a research group's own state-of-play memo.
- **This timeline is internally facing.** It *may and should* record exactly that: which model or
  agent did what, how work was routed and delegated, where a review or red-team pass changed a
  result, which C items were allocated, and which process changes were adopted. Method history is
  the point of this file.

When a fact belongs to both, it is written twice, differently — the finding in the scope report, the
provenance here. Never resolve the overlap by adding process detail to the scope report.

The arc in one line: **Othello engine → Queens solver + open problem → CGT theory pivot →
projective-cap program → a publication portfolio**, with Lean formalization ramping alongside from
week 2 on, becoming the release gate in week 6, and turning at the end into a mechanically audited
trust layer that reports on the lanes rather than being maintained by them.

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

## Week 6 — Jul 12–18 · The portfolio: papers, lanes, and the Lean release gate

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
  Two governance documents also landed: an **expert-questions routing portfolio** (allocating
  C199–C204 from the named-reader profiles and the Dye/BSW audit, and explicitly declining to
  allocate for Clebsch/Baer — "do not duplicate"), and the **cross-paper incidence-pattern agenda**,
  the repo's first stated unifying programme across `arcs`/`clebsch`/`repaircodes`/`baer` — which
  still carries no C-ID or lane peg, so by the repo's own rules it is a direction, not work.

- **Jul 15 — the session-waste audit that became policy.**
  An ASG audit across 62 Codex sessions measured the dominant avoidable cost and found it is **not
  mathematical reasoning**: it is the **permission-review loop**. 1,838 review decisions, ≥1,815
  (98.7%) plain `allow`; permission-review sessions consumed **251M of 599M total model tokens
  (41.9%)** — roughly two tokens in five spent approving routine local commands, because the reviewer
  conversation accumulated transcript deltas and later approvals carried 200k–250k context each.
  Combined avoidable estimate **54–67%, central ~62%**. The `alt-orbit-repair` lane was the measured
  worst offender (480 approval rounds, 26.1%; two of the top-3 repo-wide output producers were its
  direct Lean elaborations streaming ~28k and ~16k lines of repeated unsolved goals instead of
  logging quietly). This audit is the direct source of the current `CLAUDE.md` command-output hygiene
  rules — the 1k–2k token budgets, the 10k "incorrectly shaped inspection" rule, the ban on `ps` /
  `list_agents` / `wait` as progress dashboards, and the `run-quiet` mandate. A measurement that
  became policy within a day.

- **Jul 16 — the Dye/BSW exposure closes; three lanes go deep; one process convention lands.**
  The single largest overhang cleared: **both load-bearing sources were obtained as user-supplied
  page scans and read at full text.** Dye 1991 supplies the ten-Brianchon bound, projective
  transitivity (a *ground-field* statement, removing the suspected descent issue), and the `A₅`
  stabilizer; BSW 1992 supplies the complete-exterior-set definition and Brouwer's census. Only BSW
  1991 (Giessen) stays unread, cited for adjacent context with **no manuscript claim conditional on
  it** — C153 and C161 both closed. Three movements followed: priority for the q=11 six-arc flips to
  **Korchmáros 1981**, a *third* prior name after Edge 1956 and BSW, arriving from chains of circles
  on an elliptic quadric in `PG(3,q)` and absent from the lane's record; the exact covering
  `U(A) = C(F₁₁)` **survives as ours** (both sources give only the inclusion, so it must be framed as
  a manuscript synthesis, not a Dye/BSW theorem); and BSW's census turns out to contain a **second
  q=11 configuration, a Pasch**, now used as a manuscript foil. On the gem-mining side the same audit
  cut the other way: **C192's Paley-biplane novelty was killed by Edge 1956 §32** ("we added λ and a
  modern name"), and Dye 1991 was relayed as *the same geometry, not a near-miss*.

  **`clebsch` (C211):** the fifteen Clebsch secants **are** the projectivized `H₃` icosahedral
  mirrors, via an explicit `F₁₁` projectivity (`τ = 8`, det-3 matrix) — an equality of arrangements,
  not of incidence ledgers. Paired with `A₃`, the two characteristic polynomials give complements
  `(q−5)(q−9)` and `(q−2)(q−3)`, whose conic-size equations factor to `(q−4)(q−11)` and `(q−1)(q−5)`,
  isolating q=11 and q=5. Three parallel targeted novelty searches then **materially narrowed the
  claim**: Edge/Calvo own the icosahedral geometry in substance, and **Jurrius–Pellikaan 2015 is an
  exact collision** with the general arrangement-decoder mechanism (Example 5.10 treats
  redundancy-three MDS secant arrangements). Only the paired `A₃`/`H₃` conic-filling synthesis
  survives. A fresh referee-style cold read found no blocking defect but judged the integration too
  early and duplicative; both arrangements were rebuilt into one late capstone subsection. Paper
  17 → 19 pages.

  **`relconic`:** **C201 closed negative** — the q=16 quadratic anatomy classified (2,633 leaves in
  62 cells, no equality cell), but a q=64 census was rejected by a rigorous `>10¹⁸` twelve-arc class
  bound, and the three preregistered mechanisms (Baer, torus, split-`Z₃`) all fail at **coverage**
  before any rank anatomy appears. The manuscript decision rule was held and C201 stayed out of the
  paper; C209 went dormant for lack of a stable cross-cell feature. **C210** succeeded it with a much
  higher ceiling and ran 21 gates in a day. A **correction worth recording**: the earlier "q=64
  layers lie on a monodromy-drop locus" was too strong — each frozen representative retains full
  `S₇`, so q=64 completeness is a small-field arithmetic exception, and the known points are
  **control points, not points on a drop divisor**.

  **`rp-next`:** the `repairports` lane archived and its successor opened as an explicit **depth
  lane, not a paper-freeze lane** — each round must produce a general identity, a strict operational
  separation, an explanatory compression, or a decisive negative; a name match or an unstructured q=9
  table explicitly does not pass. C226–C233 ran in one day under that discipline, and the discipline
  visibly worked: C228 and C232 are both decisive negatives, and C233 was allocated specifically to
  salvage what C232 killed. Fable rounds R4/R5 supplied the C236 and C237 test designs.

  **Process:** `notes/discovery-track-conventions.md` landed and was **applied retroactively the same
  day** — every proof/math lane now keeps one append-only companion for *incidental* observations,
  admitted by a single test ("was I looking for this?"), with logging allocating no C-ID and
  authorizing no investigation. The convention immediately reclassified the C201 and C210
  "discovery-track" files as mechanism notebooks (they had used the label for *planned* audits) and
  froze the legacy in-handoff registers. **C225** replaced the Python `--detach` path with
  systemd-managed transient services after `--detach` was found to return before its worker acquired
  the build lock, leaving no durable record for a worker that died during init; the ADR keeps three
  authorities separate (systemd owns lifecycle, the queue owns Lean semantics, the harness owns its
  callback) and rejected exactly-once notification as impossible, settling for at-least-once with a
  stable dedup ID. **Standing caveat across C162/C205/C225: no real Lean target has ever run through
  any of this tooling** — a policy consequence of the no-concurrent-Lake rule with a foreign build
  live all session, not an oversight.

- **Jul 17 — the spin-off track dissolves into paper lanes; three separate reviews overturn results.**
  `rp-next` ran C238–C259 in a single day and closed itself. The dominant outcome class is **bounded
  negative or novelty-kill with a narrow retained proposition**, not new headline theory, and that
  was the discipline working rather than failing. Proved: **C241** (truncated separator-vector
  response maps are contextually sufficient and compose exactly by min-sum convolution plus a
  least-feedback fixed point, giving an explicit FPT algorithm *from a supplied* width-`w` branch
  decomposition — 5,632 checks, with the decomposition construction explicitly outside the theorem);
  **C243** (the inert-vs-span separation holds for every `q = 3^h ≥ 9`, while the dramatic one-round
  nucleus switch is **q=9-only** — a five-set has ten triples but must expose `q−4` points);
  **C246** (exact realizability characterization of truncated separator profiles; C241's raw `χ` is
  sound but neither fully abstract nor minimal, and the incoming-convolved `Φ_X` is all three);
  **C248** (a represented full repair port is an MSP with **one row per helper, not per circuit** —
  correcting the advisory that motivated it); **C256** (rank-cutoff rigidity with reciprocal
  characteristic-sensitive gaps, stated as a lower bound only). **C244** corrected the EXIT ledger
  from `redundancy + deficit` to `code dimension + deficit`. Two reviews then did the real work:
  **C240**'s five-probe battery against two independent, deliberately blinded Fable gap reviews
  returned 1 kill / 3 reformulate / 2 GO — **ULC refuted** by an explicit rank-five binary
  counterexample, the **peeling / excluded-minor programme killed** (minor, dual and 2-sum closure
  all fail, so the WQO route never reaches its antecedent), and the width-two GO is what promoted
  C241. **C245** then retained a deliberately narrow representable-matroid LC conjecture after
  exhausting 30,638 pointed types — and **C254 killed it nine tasks later in the same lane**, with an
  infinite regular-graphic TTSP counterexample family whose smallest member has 14 helper edges (all
  185,701 profiles through 13 edges pass; exactly one 14-edge profile fails, replayed by direct
  enumeration of all `2^14` subsets). The applied/agentic cluster **C249–C253** all passed their
  engineering gates and all failed their novelty gates — shared-risk routing, Proof-Carrying Plans,
  targeted active learning and expanded-state planning already own every theorem-bearing part — with
  C251 explicitly claiming **no empirical agent advantage**, since its annotations and execution share
  one authored causal model. C258/C259 closed the lane into three execution packets and framed the
  closed-route ledger as saved effort rather than backlog.

  **The portfolio then re-cut itself into one lane per paper.** `rp-next` and `repairports` were
  archived; `complete-ports` split out of `repaircodes` (C277, moving paper-prep only and changing no
  Lean namespace), `nofil` and `continuation` opened with C265–C273, the `dihedral` paper lane took
  its release-gap chain, `crowns` opened as a research-synthesis lane owning only C294–C296, and C210
  was routed to `relconic`. C270 (public identity, metadata, DOI/OEIS) was re-pegged from `build-sys`
  to `nofil`, leaving C287 with manifests, extraction and axiom audits — a split where **neither side
  can act alone**: C287 never creates remotes or pushes, C270 never copies sources or runs builds.

  **The dihedral content set closed, and its own manuscript was the casualty.** **C281**'s exhaustive
  tame census (all 255,288 legal pairs and 246,000 legal triples for `q ≤ 23`) **refuted the paper's
  own §9 boxed formula**: when `h` is even, `PGL₂(q)` carries a second `D_{4n}` conjugacy class with
  all reflections nonsplit, which §9's normal form assumed away — 20,196 triples take a different
  value, first case `q=7` where the boxed formula predicts 0 and the true value is 1. C263's pair
  formula **survives**, and the reason is exactly why the earlier pair checks were blind to the gap.
  **C283** broke another of the paper's own laws: wild `D₁₀` is an N-position at `𝒢 = 3`, so "odd
  order ⇒ P-position" fails, though triples cannot be wild. **C284** proved `A₄` impossible as an
  involution-generated type and introduced `(σ, ρ)` as a complete `Aut(G)`-orbit invariant, splitting
  the old `A₅ (3,5,5)` signature into two 60-triple classes. **C288**'s `q ≤ 101` census found board
  Grundy value **2** occurring, first at `q=5`, in a congruence class C284's sample never touched.
  Then two computed→proved upgrades: **C289** used the Fricke identity in the binary icosahedral
  group plus a mirror lemma to turn six polyhedral entries from computed into proved — while
  **delimiting the two zeros that stay computational**, since exhaustive search over the order-120
  colour group found no free non-adjacent involution — and **C290** proved the ten closed board-value
  laws unconditionally in `q` from `PGL₂(q)` group theory, demoting C288 to independent verification.
  **C278** closed the density-½ theorem behind **exactly one** quarantined Davenport axiom, with the
  ½ falling out by cancellation of `φ(8n)` rather than computing it. Fable ruled the paper's spine
  **"adopt with changes"** (four of them, including that the density theorem stay a named headline
  with its single-axiom sentence attached, and that §8 absorb C283 as the sharpest boundary marker),
  converting C264 into the six-phase chain C306–C311.

  **C286 is where a review changed a theorem.** Three subagents were given **disjoint source ranges**
  and barred from reading the preflight audit, the ledgers, the handoffs, or each other's reviews;
  the front-half reader found that the exact transfer theorem **was not exact as stated** — it omitted
  the all-zero functional sector — and classified it a blocker. The fix assumes `|J| ≥ 2` and takes a
  minimum over the exact all-zero branch; the same three readers then re-read their ranges after the
  correction. A vacuous dual-distance sentence was deleted rather than restated. The preceding
  adversarial preflight (**C285**) had already returned **not submission-ready** with 11 source and 7
  citation corrections. Meanwhile the nine-file Fable5 advisory cluster ran its own internal
  correction: a `missed-connections` pass **overturned** the earlier draft's clutter class (the
  nucleus port is ideal but **not** Mengerian, so Lehman's theorem was the wrong anchor), downgraded
  its tract dictionary from exact to conjectural, and relabelled all its letter grades as strategic
  bets — with the corrections written back into the earlier file inline. Krob 1994 bounded one
  proposed paper to a decidable retract and Jaeger–Vertigan–Welsh closed half of another by citation;
  four mining cells died to literature outright. **One file in that cluster carries a stated
  provenance failure** — much of it may have been written by Opus rather than Fable 5 — and a sibling
  notes its own attribution is likewise uncertain, so model attribution in that cluster is not
  uniformly reliable.

  On `relconic`, the C210 Artin–Schreier series established the complete factorization theory of the
  collision cover. Two read-only Fable rounds shaped it: the first found an **alternate-slope gap** in
  the one-divisor claim, an **unowned** `b=0 ∧ a≠0` boundary, and warned that `GF(64)` is an even-tower
  trap; the second **rejected both proposed completeness routes** and prescribed the census-first
  ordering that was in fact followed. A tooling caution was recorded that outlived the task:
  `minAssGTZ` over `GF(2)` **returned a wrong minimal-prime list**, so all later decompositions use
  only exact division, resultants, gcd and Rabinowitsch.

- **Jul 18 — C210 closes obstructed, is succeeded, and the successor is killed the same day.**
  The **bounded two-repair-coset obstruction** closed C210: every nonconstant-height specialization
  has a reconstructible genuine collision for `q ≥ 32768`, the named branches all close at `q ≥ 512`,
  and the constant-height case is settled by an exact `GF(8)` census (150,528 configs, 7,512
  collision-free, **0 arc-legal**). The verdict is stated as **obstructed, bounded** — an exact
  mechanism obstruction, explicitly *not* a nonexistence theorem for `C`-complete `O(√q)` arcs and not
  an obstruction to other repair architectures. The succession then ran in one day. **C297** reframed
  C210 as a codimension-three slice of a dimension-13 family — a **scope correction that narrows our
  own citation**: C210 bounds the common-curvature slice, not all quadratic two-repair architectures.
  **C298** proved fiber degree ≤ 9 on every collision component, forcing `Ω(q)` deletion cost, with
  exactly two classified terminal star strata as the escape hatch. **C300** classified the twelve
  nonlinear `PG(2,64)` repairs as three `PGL(3,64)` classes but a **single** `PΓL(3,64)` class.
  **C302** proved the carrierwise secant-defect identity and separated the collision-transversal from
  the coverage-support hitting problem. **C303** refuted the terminal star-deletion route at `q=8` —
  the mandatory conic deletion already uncovers a required point, and monotonicity makes it
  irreparable. **C305 refuted one of our own claims by exact count**: the day-earlier synthesis had
  argued the `q=512` gap was "hours in Rust," and the true scope is `9.17 × 10¹⁸` specializations
  leaving `≥ 9.9 × 10¹⁴` representatives after every certified quotient. C312–C317 then classified
  the ambient family — **C313** proving the linear-`p` stratum **empty** over every odd degree by a
  one-line trace contradiction, **C315** collapsing the entire odd-degree tail into the
  nine-dimensional constant-height `E4`, and C316/C317 each correcting the previous step's geometric
  picture (rank two → rank zero; expected positive-genus fibers → zero-dimensional schemes, with an
  explicit ban on applying Hasse–Weil to them).

  Then the shape of the day inverted twice. **C327 and C329 constructed** what the programme had been
  chasing — collision-free four-layer arcs of size `4Q` for every odd-tower `Q ≥ 2^45`, via an `S₅ × S₅`
  joint monodromy argument and a genus-zero `(C₂)^6` cover — the first positive existence result on the
  fresh-coefficient side. **C330 then killed them on coverage the same day**: the finite secant
  directions form exactly seven reciprocal images, so at most `7Q−2` points are covered and
  `≥ Q²−7Q+2` required non-conic points are left uncovered, on all of `E4` and before any trace
  condition. Net: **arc legality is solvable on the survivor family; relative coverage is not, for
  this architecture.** The lane finished with no live item and no global nonexistence claim, and its
  provisional working title was retired as unsupported by its own boundary.

  On `crowns`, C294's bronze P-family was **repaired upward**: the theorem had been stated for
  `p ≡ 3, 27 (mod 40)`, but its two character conditions actually give all four residues
  `3, 7, 23, 27`, doubling the eligible primes for free — `{3,27}` only ever affected the parameter
  count. The mixed-class Cayley scar was proved obstructed (every colour-preserving automorphism is a
  right translation, so no mixed triple admits a colour-preserving nonadjacent pairing), the four-ply
  pairing certificate was refuted across all seven hard types, and the B3 slice produced a long series
  of **exact but non-compressing** results before pivoting to coloured-Cayley coordinates after an
  E0 audit found the setwise stabilizer of the initial defect trivial in all seven cases. The
  ten-million-state gate stays closed, with promotion gates fixed at 1% offline / 10% live and an
  explicit ruling that **no second ten-million run is justified**.

  **The three-model zoom-out exchange happened in git, not in chat** — three signed dated notes inside
  ninety minutes. Fable opened with a one-technology diagnosis making C294 the critical path; Codex
  answered **"the right bottleneck at the wrong scale,"** keeping every proposed experiment and killing
  the inflation: the programme has one scalable *Grundy-zero certificate*, not one technology; the four
  blockers share a **failed certificate language, not a proved cause**; `139/753 ≈ 18.5%` is not one
  half, so the arithmetic probe needs a preregistered invariant sieve with a subgroup-stratum control
  rather than a character analogy; even characteristic is a **control experiment, not the missing half**,
  since those planes are already Lean-proved P; and the proposed Clebsch check is a **recognition
  corollary**, not the crown, because the P conclusion comes from the icosahedron's own symmetry rather
  than from reconstructed geometry. Fable's reply conceded nearly all of it — including that its own gem
  inventory had **missed C298, the exact theorem its earlier round had ranked most urgent** — defended
  only the routing conclusion in the expected-information sense, and added the sharpening that
  `18.5% ≈ 3/16` is the natural density of a depth-two Boolean combination, plus the methodological
  point that **Crown II must be tested against foils, not against the jewel**, since success on the
  jewel alone is near-tautological. The lane's own status line was then calibrated down to match.

  **The coordination model was written down**: parallelize task-owned theorem work, serialize shared
  state, with four writer roles — a task worker owning only its own artifacts, a lane integrator as
  sole writer of the handoff, a queue coordinator as sole writer of the queue and archive, and one
  named writer per shared registry — and consumers reading a producer's artifact **by path and commit**
  rather than editing it for convenience. An explicit anti-drift clause states that the zoom-out notes
  allocate nothing: each proposed probe needs an owning lane and a queue row first. The commits between
  15:00 and 20:15 interleave **at least eight lanes**.

  **The trust layer stopped being maintained by hand and started auditing the lanes.** C225's ADR was
  accepted after adversarial review, keeping three authorities separate and settling for at-least-once
  delivery with a stable dedup ID; abnormal death is reader-derived from systemd evidence and never a
  forged terminal state. **Step 11 put the first real Lean target through that bridge and it failed
  twice** — first with `lake: not found`, because the transient unit inherited the user-manager
  environment and rebuilt `PATH` in a way that discarded the devshell (invisible to the legacy path),
  then, after the fix, with a genuine C151 `decide` failure. The supervision path was proven; **a green
  managed Lean compile remains unobserved**, so that gate is closed by decision rather than evidence.
  **C162**'s blast-radius analyzer mapped 10,878 modules and 30,270 import edges and found radius comes
  from **chain depth, not fan-out** — about ten modules each invalidate ~95% of the tree on 2–11 direct
  importers — while its **cost ranking was not delivered and its premise failed**: queue telemetry is
  closure-level, not per-module, and an early Spearman `ρ = −0.044` is explicitly recorded as *not* a
  finding. Writing 48 hermetic restart-guard tests exposed two real defects, both fixed: a verifier that
  accepted an empty sentinel map and printed "verified, byte-identical" while hashing nothing, and an
  `assert` that vanishes under `python3 -O`. **C326** built the trust spine, and its first pilot
  immediately found what hand-maintenance had missed — 14 handwritten modules outside all five declared
  gates, a `Gates.Baer` covering half its modules with a manifest whose validation command builds none
  of them, a tracked module no lake target builds, and a project-local axiom absent from the trust
  doc — all of them **other lanes' defects, reported and deliberately not fixed**. Its exporter resolved
  a decision gate in its own disfavour: the "33 opaque proof boundaries" were an artifact of its own
  `allowOpaque` misuse, and proof bodies are in fact available. **The standing caveat is the large
  one — no project module has been extracted, and all five gates report `facts-missing`.**

  **C151** closed the alternate-orbit exhaustion: within the normalized-row domain, 32 is the exact
  minimum and the five certified orbits are the complete minimizer set, with the 46,056 rows accounted
  for as 39,012 bad payload, 7,020 non-minimizer and 24 minimizer, and the 24 splitting `3,6,6,3,6`
  in agreement with orbit sizes derived from an independent source. The orbit sizes themselves had
  been **generator payload appearing in no proof**, read as established because they sat in a schema
  and a report table — they are now theorems. A Fable review killed the materialize-the-orbits plan on
  a cost estimate before it was attempted, and its own proposed fallback was then killed by
  measurement, leaving the orbit–stabilizer route that avoided an estimated 1,036 modules and 7,044
  class-link records. **The boundary is load-bearing: exhaustion is proved for normalized rows, not
  semantic arcs** — the lower bound lifts, exhaustion does not — so 32 must not be presented as the
  exact semantic minimum until C331 closes the gap. Two further Fable reviews cut across lanes: a
  certificate-portfolio review caught an external model's inventory as **visibly doc-derived** with
  stale counts and recommendations already implemented, and flagged that the layer it rated highest-risk
  was **untracked in git** and therefore supported no reproducibility claim at all; a trust-doc diff
  review found a queued task's premise **flatly false** (the axiom it said was documented nowhere has a
  56-line file whose whole purpose is documenting it), three README claims false, and — in its closing
  section — sketched what became the C326 design.

  **Process:** the discovery-track convention produced its most useful entries yet, and they are
  self-critical rather than opportunistic: that a schema field had been read as established fact
  without any proof consuming it, and that a per-leaf workaround for an opaque inversion appeared in no
  report or docstring, so the next hand-written module walked into the same wall.

## Week 7 — Jul 19–23 · Clebsch factorization memory and the Reed–Solomon programme

The apparent `crowns` expansion of this week is mostly a Clebsch publication expansion. The lane
boundary is real — `clebsch` owns Paper 1 and `crowns` owns the sequel — but mathematically the work
is one arc: identify the bit forgotten by conic restriction, prove exactly where it survives, and
then explain the modular carrier that owns it. In parallel, the projective Reed–Solomon work grew
from a collection of deep-hole companions into a theorem programme spanning redundancies three,
five, six, and seven.

- **Jul 19 — the Clebsch paper outgrows the rigidity manuscript, and Q25 closes semantically.**
  C368–C385 built the first Clebsch-facing intake: the all-odd arithmetic phase, intrinsic `10+10`
  chirality torsor, Fourier-self-dual fission, AME separation, cubic double-six compatibility,
  golden fusion, matching-decorated parent recovery, and a bounded Lean gateway. Negative controls
  were kept alongside it: the marked-icosian comparison fails in the required equivariant category,
  neither Clebsch one-factorization is perfect, and several attractive application readings were
  assigned to companion results rather than the paper. The same day, `alt-orbit-repair` closed the
  boundary left open on Jul 18: the normalized-row minimum `32` lifts to semantic arcs, and the five
  certified normalized orbits are the complete semantic extremal set. The Q25 paper is no longer
  frozen on that mathematical gate; bookkeeping and its exchange graph remain.

- **Jul 20 — factorization memory is selected as the shipping Clebsch spine.**
  C395–C412 turned the intake into one mechanism. C399 supplied the portable `A3/B3/H3` Coxeter
  conic phase; C403 proved the all-degree pairing-forgetting quotient; and C406 identified the
  missing information: conic restriction forgets a secant pairing, balanced second moments recover
  two sheets, the first signed tensor memory is cubic, and one depth profile plus its matching
  recovers the Clebsch parent. C411 replaced a six-profile census by the
  `A4 \ PGL₂(11) / A5` double-coset/bi-Hecke derivation. C412 forced cubic-first survival by
  all-degree antipodal parity, recovered the intrinsic `1:4:6` orbit weights, and explained the
  `6 → 2` rank drop as `P(1)^A4 / soc(P(1))`; it also proved that the canonical Tate two-plane is
  **not** naturally the depth plane. The existing 19-page rigidity manuscript became a protected
  emergency fallback. The selected paper is the factorization-memory manuscript.

- **Jul 21–22 — one Clebsch paper becomes two, and red teams delimit both.**
  The paper plan split cleanly. **Paper 1** proves that the bit exists, is minimal and recoverable,
  and has an exact survival/forgetting profile. Its close is the characteristic-11 arithmetic
  gluing theorem: the two golden `A5` sheets are the two halves of one `PGL₂(11)` matching orbit,
  meet through the `S4/A4` hinge, and are exchanged by the outer coset. The
  full-support/secant-shadow construction upgrades the perfect-code row to the ternary
  Golay/Hadamard–Mathieu capstone. **Paper 2**, owned by `crowns`, asks what owns the faces and the
  modular carrier.

  The C440–C471 battery earned its value as much through kills as through positives. It proved the
  split-torus law, QR/Barker and perfect-code substrate, mod-40 existence/fusion law, quaternion
  reduction, rational descent, the `5|1|5*` modular sandwich, the Hadamard-degeneration complex, and
  exact local zeta packages. It also killed the proposed small Weil-module identification, theta
  parity as a sheet detector, the literal degree-five Adler/Klein bridge, a permitted linear route
  to the cubic, and several canonical quantum identifications. The surviving scoped statement is
  that restricted Fourier blocks sit inside an ambient Weil operator; they are not standalone Weil
  modules. This prevented the sequel from inheriting a false metaplectic roof.

- **Jul 22–23 — projective Reed–Solomon deep holes become a major lane.**
  Reconstruction from deepest-syndrome data and the twisted-cubic pilot coalesced into a unified
  projective Reed–Solomon programme. The landed hierarchy is already substantial: all-field
  redundancy-three determinant-atlas reconstruction, with a unique rank-one contraction and a
  persistent two-sheeted Gale ambiguity for abstract projections; literal complete-child rigidity
  for `q ≥ 16` (and every q=13 fibre), with exact small-field exceptions; a complete
  `PΓL₂` deep-hole classification at redundancy five; and all-field existence and orbit counts at
  redundancy six. Redundancy seven first acquired an exact persistent orbit law, the odd-degree
  characteristic-two central exception, and a theorem for `q ≥ 37`; C509 then closed the remaining
  band by an orbit-reduced marked-polar census. For every `q ≥ 13` only the persistent stratum and
  the applicable central point remain, while exceptional deep orbits occur exactly at
  `q=7,8,9,11`, with fully replayed orbit profiles. The external summary was written to separate
  exact algebraic and arithmetic-geometric proofs from bounded certified classifications and to
  state explicitly that this is **not** a proof of the general Reed–Solomon deep-hole conjecture.
  The calibration also exposed a useful non-deep anomaly: q=19 has one excess size-19 affine
  pointed-bad orbit, `e₂` with net `⟨1,t³,t⁴⟩`, whose six split members all use infinity. It cannot
  synchronize into a sextic polar line, settling the count discrepancy while leaving its
  equianharmonic-looking arithmetic/monodromy cause as an explicit mystery.

- **Jul 23 — the Clebsch sequel gets a theorem-level GO, but under a new roof.**
  C511 classified the frozen Rosetta candidates: cubic minimality, the one-bit torsor, and
  Frobenius/split-prime orientation are proved; design polarity and QR perfect-code outer symmetry
  are checked on the frozen cases; theta parity is dead as a bit detector. The sequel now runs on
  the **Modular Gateway Theorem**: pointed matching geometry → cross-incidence code pair →
  perfect-code core → simple endotrivial Lagrangian → unique nonsplit self-dual carrier. The q=7
  and q=11 geometric rows pass all seven gates; q=23 carries the mechanism but provably lacks the
  exceptional degree-q permutation-sheet bridge. Thus Paper 2 is a GO around an abstract theorem,
  two geometric realizations, one carrier-only boundary, and a separate even
  Hadamard/signed-gluing block. The original universal metaplectic/theta roof is a recorded no-go,
  not a hidden casualty.

## Week 8 — Jul 24–26 · Manuscripts cross local maturity gates, then get cut back

- **Jul 24 — the arcs paper acquires its structural capstone.**
  The prescribed-hole defect identity was upgraded from a local counting tool to a global rigidity
  theorem. Zero defect now canonically decomposes the Kneser graph into secant-concurrence matching
  cliques, forces a simple maximum-matching design, determines the exact centre counts, and admits a
  quantitative bad-edge stability bound. The six-point realization is classified projectively; for
  every even `k ≥ 6`, zero relative defect forces
  `q ∈ {k−2, C(k−1,2), C(k−1,2)+1}`. The manuscript was reorganized around the
  identity–rigidity–stability progression, with `ρ_C(16)=9` retained as an application, and the
  reconstruction, stabilizer-recovery, matching-design, and stability statements were added to the
  scoped `RelativeConicArcs` Lean gate.

- **Jul 24 — Clebsch Paper I is shortened and strengthened.**
  C182 replaced four small-`k` counts by a universal chord-defect identity and sharp moment bound.
  A conic-filling uncovered locus now forces an explicit quadratic field-size barrier and
  `q < C(k,2)`; a passant count gives the complementary `q ≥ 2k−3`, and Hirschfeld's nucleus
  characterization excludes the even-order branch. The resulting eight-point sieve leaves only
  `q ∈ {13,17,19}`, and a complete passant-edge-orbit search excludes all three, completing the
  classification through eight points. A dependency and referee audit tightened the Dye input,
  restored the `A5` overgroup subtraction, removed unused censuses, and produced a warning-free
  manuscript. The increment is local: no immutable public deposit was made.

- **Jul 24 — the beyond-four PRS programme becomes a reproducible Version 1 candidate.**
  The redundancy-five classification, coherent-polar reductions at redundancies six and seven, and
  the arbitrary-redundancy persistent/modular containment theorem were assembled into a 43-page
  manuscript. The high-field theorem states that every split-free syndrome lies in the persistent
  or modular loci once
  `q ≥ 6r−15 + floor(2 sqrt(6r−17))`. A clean paper-only export rebuilt byte-for-byte and passed its
  57-artifact verifier. Public release remains a NO-GO pending two specialist signoffs, a public
  pinned Lean revision, author/account actions, an immutable archive, and a live DOI. A subsequent
  audit found that the advertised Lean aggregate still targeted the older R5–R9/Hessian/Lucas
  closure rather than the adopted R5–R7 paper. The repair replaced it by the exact 15-file R5–R7
  closure, reconciled all 35 manuscript labels with a 53-target axiom audit, and made the verifier
  check those sets fail-closed; the remaining blocks are external release gates.

- **Jul 24–25 — AME local-unitary rigidity becomes a new paper and a generic theorem family.**
  A new lane grew from the six-party Clebsch/quantum comparison into a uniform result: for every
  prime power `q`, every `m ≥ 2`, and every linear `[2m,m,m+1]_q` MDS code, a product-unitary
  intertwiner between equal-phase CSS states is local Clifford. The proof shortens the code and its
  dual to `m+1` parties, expands the marginal in the full finite-field Weyl basis, and recovers Weyl
  axes from rank-one contractions. The complete marginal-to-rigidity chain was formalized in Lean
  without restricting to the original six-party pencil. The manuscript also records the associated
  `[[2m−1,1,m]]_q` transversal-Clifford consequence, finiteness of the product-unitary automorphism
  group modulo one-site phases, and, for odd prime GRS codes of even length `2m ≤ q+1`, the exact
  projective logical group `F_q^2 ⋊ SL_2(q)`. The first beyond-six example is
  `AME(8,7) ↔ [[7,1,4]]_7`, with projective transversal group order `16464`.

  The first six-party release candidate was independently replayed from a clean export, but no
  upload, DOI, license grant, or submission occurred. The generic LU-to-LC theorem is now in the
  formal aggregate, and the projective-finiteness corollary has its own completed Lean module but
  has not yet been wired into that aggregate and axiom audit. The full Choi/encoder construction and
  exact GRS transversal-group computation still sit on the manuscript side of the trust boundary.

- **Jul 25 — the AME lane generalizes past its own paper; relconic closes its Lean gate; arcs is
  reframed.**
  `ame-lu` ran C601–C649 in one day and the lane's own headline moved twice. C601/C602 landed the
  Lean LU-to-LC rigidity chain and its full trust audit; C609 assembled the uniform-rigidity V1;
  C612/C613 closed the general rigidity terminal and the transversal-Clifford consequence;
  C614/C615/C617/C618/C619/C622 added higher-`m` applications, projective automorphism packaging,
  the automorphism exact sequence, the nonabelian extension class, the GRS splitting obstruction and
  the diagonal-isoduality dichotomy; C623/C624/C629/C631/C633 supplied extension-field Clifford data,
  party-extension examples and their formalizations. **C642 was a referee repair that changed a
  statement:** the linear identity `N(T) = T ⋊ C₂` is false and was replaced by the exact
  odd-characteristic relation `J² = −I`, `N(T)/T ≅ C₂`. **C647**'s post-C562 novelty audit recorded
  17 individually discussed sources with read depths, cache hashes and named database gaps, credited
  Wirthmüller, Anderson–Jochym-O'Connor and Sayginel et al. at point of use, and **added no firstness
  claim**. Then **C649 generalized the paper out from under itself**: full-Weyl rigidity holds for
  every stabilizer `AME(2m,q)` state with arbitrary additive prime-power stabilizers, so CSS,
  equal-phase, classical linearity and MDS are all unnecessary hypotheses and the manuscript's
  own theorem is a special case; the `m=1` Bell boundary is sharp. Its claim-specific audit located
  the known qubit and four-qutrit subcases but no all-prime-power predecessor. Two fresh readers
  independently proposed the same next targets and **none was silently added to the version**.
  On `relconic`/`arcs`, C604 imported exact reconstruction, equivariant stabilizer recovery,
  zero-defect matching rigidity and bad-edge stability through the Relconic gate; **C625 killed the
  last non-hyperoval characteristic-two zero-defect candidate** `(q,k) = (4096,92)` by a
  polarity-stabilizer congruence (`90 ≢ 0 mod 4`), which let the even equality spectrum be
  formalized and **Ramanujan–Nagell removed from its proof**; C627 proved the packing-deficiency gap
  `Δ ≥ 2`; **C628 closed negative** — the evaluation obstruction does have an exact field-uniform
  Hilbert/separator form, but that form does not force the `q=16` conclusion; C630/C632/C634/C635/C636
  formalized the equality consequences, signed Gale duality (C635 stripping the strongest redundant
  hypothesis from C632's theorem), the square-root carrier and the quadratic hull; **C637 computed the
  three bounded open values** `ρ_𝒞(13)=8`, `ρ_𝒞(17)=9`, `ρ_𝒞(19)=10`; C641/C643 closed their trust
  and compressed the lower-bound checks to an elementary conic obstruction in every case but one;
  C644 identified the sole residue as a projective Heisenberg `C₃²` orbit pair. The arcs manuscript
  was reframed around prescribed-hole rigidity in the same window. On `clebsch`, **C605** excluded
  eight-point conic filling at `q = 13,17,19` and completed the `4 ≤ k ≤ 8` classification; C610/C611
  adopted the exterior-set framing; C616 replaced the `H₃` coordinate row reduction by an equivariant
  proof; C620/C621 added the graded evaluation algebra and the adopted Gorenstein gate. `reed-solomon`
  ran C603's Lean trust audit and C545's R5–R7 reconciliation. On `cap`, C80 ran a long falsifier
  sweep whose dominant output class is settled negatives, plus the `R_small` bounded correspondence
  and the q=23 falsifier that bounds it. A read-only **cross-paper results snapshot** was written the
  same day as an editorial bank, explicitly not a routing document.

- **Jul 26 — Paper III is cut down twice, the q=16 certificate survives three attacks, and
  complete-ports gets a new headline.**
  The day's shape is subtraction. In `clebsch`, C579's plan and synthesis cold review were followed by
  C651's exact Hitchin–Clebsch tensor bridge, C652's arithmetic-cover certificate, C653's mixed
  novelty gate, C654's Klein relative-position calculation (positive commutant, **negative**
  discriminant-five lift) and C655's harmonic bridge; a separate Klein intermediate-Jacobian kill test
  ran alongside. C668/C669/C670 then **deleted most of it**: the finite tensor section, the
  common-cubic-line section, the matching-specialization claims and the combined headline theorem all
  came out, the statement identity contracted from seven statements to four and the trust manifest
  from nine rows to four, and Paper III became a seven-page two-theorem note. A **context-free
  reviewer given only the seven rendered page images**, with no repository access and no earlier
  review context, returned `GO` with no blocking finding, and its cheap material-minor requests were
  applied afterwards. C670 also **settled the factor-13 mystery**: the earlier display was the
  reproducing kernel, not the Gram matrix, and `G = K/13`. Then a later PDF-only cold read plus an
  isolated-package audit reopened the file, and **C680 was queued at `NO-GO`**: the Clebsch inclusion
  `V ↪ H` is used but never defined, the constant-5 fibre step has no local comparison theorem, the
  release bundle only passes inside the private repository because a script reads a `notes/` JSON, and
  the word "new" is not licensed by C669's recorded audit. C670's report is preserved as the
  historical verdict with C680 made authoritative — the same review-supersedes-review pattern seen on
  the transfer theorem in week 6.
  Paper I absorbed **C662**'s human passant-cover theorem and was then **split into a fourteen-page
  human core plus a seven-page computational companion** in the same paper root, with its own build
  target, ledger, validator and five replay routes; a post-choice cold read selected the human core
  and its title, now *Reconstructing the Clebsch code from its deep-hole syndrome locus*. C662 is
  explicit that it does **not** replace the C605 terminal searches. Paper II took C661's conceptual
  rank proof — no orbit row reduction is load-bearing for `3,6,10` any more — and C665's balanced
  matching-completeness classification, whose stronger trade-only form is recorded as an open
  strengthening rather than claimed.
  On `relconic`, three independent attempts to replace the exhaustive `q=16` eight-arc certificate all
  closed negative in one day — **C663** (low-weight projective-Reed–Muller structure lives on
  polynomial representatives, not codewords), **C666** (an exact `GF(16)` example satisfies seven of
  eight fibre quotients, so no seven-fibre Rédei argument can work), and **C667** (no multi-base
  survivor in the 2,291,362 checked arc–conic pairs, but the boundary data alone admit exact
  counterexamples). A separate compression pass showed **2,630 of the 2,633 leaves share one
  elementary incidence obstruction**, leaving three exceptional leaves with one-dimensional quadratic
  kernels — the certificate is smaller but still load-bearing. C657/C658/C659 advanced the projective
  carrier geometry.
  `complete-ports` reopened as a drafting lane: **C671** froze the theorem hierarchy under a strict
  admission rule (exact statement, complete human proof, matching Lean declaration, field-by-field
  adequacy check, axiom audit, **no computational dependency**), with everything else marked
  `TO FORMALIZE` / `APPENDIX COMPUTATION` / `CUT`; **C672** then made a general MDS
  local-reconstruction theorem the page-2 headline and began building it in Lean. `reed-solomon`
  closed C545's second cold-read repairs, C656's literature delta, and C646's stable-component formal
  geometry. `ame-lu` ran two cheap kill batteries, one of which **killed a proposed reduction on its
  first in-scope extension field**. `cap` continued C80 on q=23 replacement lineage and ancestral
  charge, with the obligation-deletion sweep returning the day's other decisive negative.

## Week 9 — Jul 28–31 · The portfolio reframes, and a fourth Clebsch paper is carved out

Jul 27 is empty. The four working days that follow are the densest of the whole record, and their
shape is different from week 8's: less subtraction, more *ownership* — where the repository sits
relative to the papers, which lane owns a runaway body of results, and which claims are relative to a
marking rather than absolute.

- **Jul 28 — the repository is reframed around the portfolio, and five standalone mirrors are cut.**
  The framing commit is exactly that: the monorepo is no longer described as a game programme with a
  publication annex. Five released papers were exported to standalone repositories under
  `~/src/math-papers/` — `ame-lu`, `beyond4-prs`, `clebsch-factorization`, `clebsch-rigidity`,
  `arcs-complete-outside-conic` — under a convention written down at the same time: synchronization
  is **one-way** from the monorepo, edits land in the mirrors as **ordinary forward commits**, and
  destructive history replacement needs explicit authorization. The exports are release mirrors, not
  a second source of truth. **None has a remote**, and repository creation, pushes, releases,
  affiliation/contact metadata and DOIs are all explicitly out of scope until the user authorizes
  them — so the shared public-URL blocker is now one authorized action away rather than an
  engineering task. A `finitegeom` **concept DOI** is cited paper-side, and deliberately only as the
  version-independent identifier of the separately distributed formal companion, never as a paper
  DOI. The extraction found and fixed the class of leak the convention exists to prevent: internal
  C-task routing presented as public dependency, task markers inside evidence filenames, a private
  monorepo `--build` mode in a public bundle tool, and a release verifier that only passed because it
  reached outside the package. **C685–C687** split the Passages extraction and its certificate
  corrections; the Dye pinpoint citations were corrected across the affected papers. Underneath,
  `clebsch` C682 ran the mod-11 Bockstein bridge repair to a certified corrected form modulo `11³`
  with its Frobenius gauge identified, proved the `U₂₂` linear section and Bockstein pencil
  globalization, the rank-four resolvent and the transvectant deformation map, and opened the Klein
  `E₈` operator algebra with a **literature audit run before, not after** the result was framed.
  `clebsch` C665 closed the q=121 extension pullback, the characteristic-three intersection trade and
  the q=27 invariant-trade excess. On `cap`, **C80 falsified its own two-mechanism update** and
  exhausted the q=23 replacement orbits.

- **Jul 29 — Paper I acquires the golden orientation; C682 goes all-weight.**
  C690/C691 turned the orientation material into theorems and **C693** integrated them: the syndrome
  locus reconstructs the unordered support two-graph, either signed continuation orbital `B` gives
  the support-orientation cubic as its triangle product, pair balance is equivalent to `B² = 5I`, and
  the cubic threefold's six ordinary nodes form a projective frame that reconstructs the six-axis
  carrier. **C611** closed the q=13 binary minimum-distance gate at `d = 12` by a six-difference-set
  five-row unique-closure lemma rather than a support search, and it went into the computational
  companion. On the exploration side C682 proved **all-weight maximal rank** and global phase
  propagation, certified four further plateau rays, constructed global Kostant Weyl operators, and
  explained the Wronskian degree drops by Smith-at-infinity profiles. **C695–C697** ran the `E₆`
  minuscule branch `27 = 12 + 15` to a graded Cartan model and stopped there deliberately: with no
  cohomological or Higgs realization it is **not** a model of the Krämer–Litt–Maculan variation, and
  the drafted outreach invitation was left unsent. Four incidental leads went to the discovery track
  rather than into any task. On `cap`, C80 proved the conditional causal-label injectivity statement
  and then **extracted the q=11 one-to-many replacement witness that kills its uniformity** — the
  lane's live proof object moved from causal-local to global in one day.

- **Jul 30 — the trilogy gets an identity, Papers I and II take their v2 arcs, and the shadow
  portfolio opens.**
  **C703** gave all three split papers one title-page identity, *The Clebsch cubic: recovering,
  orienting, and realizing*, with canonical titles, logical independence and paper-owned proof
  surfaces unchanged — framing, not cross-promotion. **C182**'s v2 referee cold read was applied as a
  bounded revision (rational `A₅`-module wording, theorem hierarchy, computational/formal boundary,
  q13 and two-graph literature, opening and conclusion), and **C713** rebuilt the proof architecture
  so chord defect → line bound → rigidity → across-fields runs uninterrupted before the decoder;
  singular-locus completeness stopped being a Gröbner dependency once the cross-golden determinant
  was identified as `−C` with the Hassett–Tschinkel determinantal converse supplying six ordinary
  nodes. **C694** integrated Paper II's v2 arc and, in doing so, **removed a hypothesis from its own
  main theorem**: the two quadratic-trade fibres are no longer assumed to be one-factorizations, and
  the `q+q` split is derived. C682 closed the local-return algebra gate in a stronger form than asked
  (nearest lower and upper Gram returns suffice; the two-step upward return is redundant) and
  **explained the virtual levels `0, ±1/3, ±2/3` as order-three indicial roots**. Then **C704** —
  the functorial operator-shadow exploration — landed positive and immediately spawned a mining
  portfolio whose rules are the interesting part: each promoted package is a no-early-bail
  exploration with distinct `ej1`/`tt1`/`ej2`/`tt2` passes, and **negative outcomes are first-class
  objects requiring a structural obstruction theorem plus their nearest positive locus and adjacent
  crown**. **C705** ran the first tranche (adjugate–polar, Coble/Burkhardt, affine- and Lie-`E₈`),
  and **C706–C710** were reserved for the Clifford, ETF, doily, Majorana and `E₈`–Hamming follow-ups.

- **Jul 31 — a fourth paper and a new lane; three "relative, not absolute" rulings; two adjacent
  problems opened.**
  The day's governing decision is a **paper-ownership ruling**: the whole C704–C710 post-700
  development, plus C715–C719 and C727–C729, is assigned to a new **`golden` lane** and a standalone
  fourth manuscript, *The golden conference operator and its shadow sisters*, with review-facing
  Paper III ending before all of it. The lane may cite Paper III but may **not** edit, extract from,
  or reorganize it; a future post-review relocation of overlapping exposition is explicitly deferred
  to a later decision. C720 froze the charter and installed the manuscript root; C735 is queued for
  consolidation, with C718/C719 deferred unless it identifies a theorem-level need.

  Three results were **weakened to what is actually proved, and are stronger documents for it**.
  **C733**: a fresh referee found the Paper III draft had promoted a quadratic *function-field*
  equation to an equation of the unnormalized pullback; the repair proves the global Stein algebra
  `O ⊕ O(−3)` with `z² = 5J₀`, and the orientation bridge is restated as explicitly relative to a
  marked datum with a complete ambiguity ledger — the sheet alone is not claimed to recover it.
  **C727**: the cross-paper recovery theorem descends every projective/even golden shadow from the
  unordered support two-graph, and states the matching negative — the bare unlabelled deep-hole conic
  is transitive on the 22 Clebsch matching rows and therefore insufficient. **C581**: quantitative
  ambient-Clifford rigidity is positive with explicit constants, while exact q=9 nonsemilinear and
  q=25 GRS symplectic elements kill every uniform semilinear or spread upgrade **even at zero
  error**; no manuscript wording was adopted.

  The rest of the day closed gates. **C714** finished Paper I's companion structuralization by
  integrating **C721–C726** — the q11 orbit ledger, q9/q13 clique audits, q13 weight-ten XOR
  certificates, the q13/17/19 root-edge DAG — under a thirteen-claim, five-mode ledger (human
  structural proof, published theorem, Lean theorem, finite certificate, trusted execution), with
  both authoritative and standalone roots passing all twenty-six checks and the q11 formal package
  pinned by commit. **C711/C712** removed certificate dependence from Paper III's sub-700 inputs and
  formalized the resulting interfaces in Lean. On `ame-lu`, **C731/C732** red-teamed and adopted the
  Clebsch extremal-`X`-syndrome bridge and **C734** generalized it into a formal coset/syndrome
  dictionary, reducing the paper's Clebsch result to a two-paragraph structural lemma composed with
  two named theorems. Finally `gem-mining` opened two **adjacent problem attacks**: C736 reproduced
  the published proof-carrying 21/30 multiplier baseline for Hadamard order 668 and extended it to
  23/30 by an exact mod-8 argument, with C738/C740/C741 opened on the residual cases and C737 queued
  on `M(18) ∈ {57,58,59}`. C738 and C740 then closed inside the same day by a second, unrelated
  mechanism — a shift-111 orbit lock — taking the census to 25/30, closing every order-six subgroup,
  and **exhausting that criterion on the five survivors** rather than leaving it untried; C741 is
  live on the paired residual cases. Both closures kept C736's feasible nine-compression witnesses as
  **positive controls**, so the screens are known not to be vacuous.

---

## Week 10 — Aug 1–5 · Four papers in parallel, an imported axiom retired, and a track killed by its own audit

- **Aug 1 — the fourth paper is stood up and the group is graded.** `clebsch` C761 set up Paper IV
  at `papers/q13-passant-code`, froze its theorem and human proof, installed a paper-owned evidence
  gate and migrated the q13 evidence out of Paper I. C762 sharpened Paper I's forward exposition,
  C763 consolidated Paper III's selective golden core and C764 added the determinant-versus-permanent
  boundary; C680 was retired behind them. On `golden`, the six cubic node Hessians, the projective
  frame carrier and the chart Hessian were formalized and the node trust gate closed (C758/C759).
  The day's governing document is the group review
  (`notes/2026-08-01-clebsch-golden-paper-review.md`): **no repackaging of existing results clears
  the A−/A band**, because every headline concerns one exceptional object over one or two small
  fields — which is what makes C756's all-`k` theorem the lane's only identified top-tier route.

- **Aug 2 — Paper II's human proof closes; Paper IV takes its structural version.** `clebsch` C749
  closed the reopened human-proof gate after an adversarial cold **MAJOR** → localized repairs →
  **MINOR** → context-free **GO**; C797 killed trade-only carrier reconstruction at q=7 and **C798
  turned that failure into the sharp positive boundary theorem** (`q−2` nonmatching exact-trade
  orbits, unique matching Chow point, no orbit table in the spine), with C801 formalizing the
  table-free version and C856 closing the standards audit over the fifty-six-file project-owned
  closure. C831/C832 completed Paper IV's structural version and its partial-formal boundary, and
  C817 finished the structural mathematics upgrade with all six subitems positive and **no manuscript
  change made**.

- **Aug 3 — releases, mirrors, and a pre-release.** C860 removed the cap-game modules from the paper
  closures and documented the five residual geometry modules, clearing the last shared-closure debt
  gating Paper II; an independent review verified every C856 claim. C855 landed the six-node
  Hassett–Tschinkel closure end to end — base library, resealed q11 package, rebuilt PDFs, standalone
  mirror reproducing the authority's release identity — and closed the q13 scheme gaps. C863 made
  genre-appropriate significance explicit in Papers I, II and IV and routed the Paper III candidate
  language into C862 rather than editing that manuscript. On `ame-lu`, the two-paper split reached
  published state with both mirrors synchronized, the MDS–CSS transversal-groups paper registered its
  formal contract and semantic gate, and paper summaries and Zenodo metadata were aligned across the
  portfolio. **Paper IV was deposited as a manuscript-only pre-release** at DOI
  `10.5281/zenodo.21783971`, Lean companion excluded and due as a forward version.

- **Aug 4 — the imported Dye axioms die, and Paper III's formal surface hardens.** C855 ran the
  elimination chain to the end in one day: the chord-pairing bijection (triple-concurrence points =
  concurrent chord matchings, over an arbitrary finite projective plane), the one-factorization at
  ten points, the hexagonal-order lemma, the golden normal form over any field where 2 is invertible,
  and the order-eleven witness identification with `φ = 4, 8` and explicit determinant-three
  projectivities. **Both permitted-axiom entries were deleted**, so `relconic.toml` now permits no
  axiom; the manuscript-relative Lean names were replaced in the same pass and the spine's trust fact
  re-extracted. C815 closed the four-shadow half of gap class C by a switching reduction, formalized
  aligned-design faithfulness at the manuscript's own quantifier range with the `3n² − 23n + 45`
  query family, and hardened three gates to **no compiled-evaluation axiom at any terminal**, with a
  cold referee accepting on prose fixes only. C834 rewrote Paper IV's association-transport and
  equivariance layers for kernel reduction, blocked on another lane holding the build-owner lock.
  C682 delivered the Paper IV correspondence bundle — octahedral toric correspondence, frame
  metacode, higher shell, project-up optimality, column-extension obstruction, `F₆₄` exclusion,
  Tanner/channel/quantum/algorithmic/compact-representation documents — and documented the first
  `E₆`–`E₈` code ladder.

- **Aug 5 — the exceptional ladder is built, audited, and closed on the same day.** C682/C865 pushed
  the ladder up to the affine `E₉` level and unified it from `E₁₀`; C867 closed two record-matching
  routes with proofs (no `O₈⁺(2)`-invariant dimension-ten containment; no Plotkin improvement at
  `[240,10]`), and C868 closed the Eisenstein/`F₄` route by identifying **additivity** as the reason
  every unsigned lift stalls at CSS distance four. Then the audits ran the other way. C866 found the
  level codes to be Calderbank–Kantor two-weight codes; C869 found the Paper IV incidence graph to be
  `X.182.1` in Conder–Potočnik's semisymmetric census and **C871 retracted** the lane's claimed
  counterexample to a published Crnković–Rukavina–Šimac equivalence — the row originally matched
  belongs to a different graph. C870's fold-tower judo was **withdrawn by C872** as an indexing
  fault: the fold is type-general, not plus-type only. C873 triangulated Brouwer–Shult without
  obtaining the 1990 paper, establishing that the theorem is about arbitrary graphs under a
  coclique-parity condition, is a biconditional (so no converse fallback exists), and that
  Brouwer–Van Maldeghem's "Tower and clique sizes" already names the 120–56–28–27 chain as
  Gosset-over-Schläfli — **reversing C870's recommendation to lead with the general-rank tower**.
  C874 then closed the track as a paper vehicle by proving the code-level fold is a formal property
  of any matched Taylor double, certified against quadric links, Paley two-graphs, the pentagon and
  random graphs, with no quadratic form involved; C875 scored the levels by type and retired the
  folding lead, leaving the parabolic deficit as the only unexplained pattern. C876 opened a
  two-graph literature audit of Paper III and the golden programme and immediately found an
  attribution defect (the descendant correspondence used under a private name) plus a **wrong
  benchmark**: the closest prior result is Dammak–Lopez–Pouzet–Si Kaddour's four-local reconstruction
  up to complementation from seven points, not the five-threshold hypergraph result — the same two
  numbers as our theorem, with the reduction between them unsettled and now owed before the next
  revision.

## Week 11 — Aug 6–8 · PRS R5–R10 release closure, AME referee repairs, and a banked theorem harvest

- **Aug 6 — the Clebsch formal surface is tightened.** The Paper III gate was held to the series
  Lean standard with no carve-out: balanced exchange-rigidity and exchange-spectrum modules
  closed, while the remaining spectral work was scoped as explicit characteristic-polynomial
  algebra. Paper IV's association algebra, support decoding, transporter rows, and row-uniqueness
  leaves were reduced to kernel-checked representative decisions; transport/classification
  dependencies were separated from the manuscript's finite evidence boundary.

- **Aug 7 — PRS review repairs and Clebsch framing review.** The full PRS reread found no new
  mathematical contradiction after the terminal-coordinate repair. It corrected the residual
  quartic parametrization, narrowed the prior-work claim, removed an unsupported arc sentence,
  reconciled the statement labels and trust terminals, and closed the R5–R10 trust/replay
  surfaces. The adaptive aligned-design work was framed as query/design rigidity rather than an
  algorithm, with the exact six-point threshold and seven-point minimum retained. The Clebsch
  harmonic-route referee repairs closed the OPER-1/OPER-2 rows and the remaining Paper IV
  row-uniqueness structural decisions without widening the manuscripts' claims.

- **Aug 8 — the PRS candidate and AME pair are both audited to a clean local boundary.** The PRS
  layered-exposition pass made R9 and R10 closing gates explicit, repaired the good-base degree-22
  selector argument and equation labels, and left a warning-clean 45-page submission render;
  the standalone replay, guarded export, Lean boundary export, and release identity agree. The
  first AME review repaired the genuine (m=2) proof-scope omission without weakening the
  headline, restored qubit and AME–QMDS attribution boundaries, and added the logical rounding
  corollary. A second review repaired the phase convention, related-work scope, and theorem
  numbering across both AME papers. The latent-structure audit then proved the inter-code LU
  criterion, the high-distance multiplier line, and the five prime-field holonomy centralizers,
  but banked them rather than opening a new paper; extension-field and affine upgrades were
  closed by structural counterexamples.

## Week 11 continues — Aug 9–10 · Five-paper Clebsch closure and certificate separation

- **Aug 9 — Papers I--IV receive a coordinated human-proof audit and repair wave.** C898's five-way
  Paper I read found a false characteristic-five `A₅` stabilizer clause and missing human-readable
  six-node/chart certificates; the theorem survived, the clause became `S₅`, the certificates were
  exposed, and the final remediation read closed minor. C895 removed Paper II's false universal
  socle theorem, replaced it with the exact detector package and Faber tame-subgroup exhaustion,
  and earned a fresh full-paper PASS; C577 then closed the 46-page manuscript, referee, and local
  export surface. C897 supplied Paper III's missing rational branch-divisor and complete-fibre
  proofs, took four sealed PASS regrades, and layered the exposition. C902 added only the three
  survivors of its eight-item cheap-upgrade audit: triangle--Pfaffian recognition, the corrected
  signed norm identity, and the marked/unmarked deck-exchange sentence. C901 repaired Paper IV's
  orbital tables, scheme products, `F₈` descent/commutant proof, and orbit-Gram transports; focused
  rereview is green, while the standing programme remains author-close only.

- **Aug 9 — the arcs paper's first cold-review loop and layered exposition close green.** C900
  routed independent geometry, matching, design, conic, and generalist reads through a frozen
  dossier, repaired the main theorem's lost quantifiers and notation plus the finite-evidence
  boundaries, and obtained clean-close GO. The standing review/fix/re-review programme remains
  open; the result is a green round, not an author-declared final close.

- **Aug 9–10 — C756 moves the nonsaturated all-`k` frontier through three exact layers.** The full
  `k=12` and `k=13` classifications are negative over every finite field. At `k=14`, q=61 closes
  after none of 96 mixed stars extends; q=67 closes after a 946,250,059-state mixed search and all
  92 all-passant stars fail; and q=71's all-passant branch closes after 22,579,655 states over 36
  normalized seeds. The mixed q=71 branch, both q=73 branches, and the saturated-internal global
  coherent-star theorem remain live.

- **Aug 9–10 — C879/C864 enforce independent certificate kernels and cheap paper bridges.** Q11 and
  Q16 are frozen Mathlib-only packages under branded namespaces; registered bridge roots alone may
  import both finitegeom and a certificate, hash its sealed aggregate, and prove transport without
  rebuilding it. The verifier now rejects unregistered bridges, reverse imports, local-model escape,
  and facts credited to dependencies. Bridge verification was placed under the host-wide guarded
  Lean owner and serialized through the runtime; cache restore, adoption, axiom-audit roots, export
  pins, and Paper I's sealed-Q11 pin were refreshed. The mapping snapshot now fixes the final Q11,
  Q13, Q16, Q25, and projective-cap namespaces; the remaining projective package migrations are
  mapped but not executed.

- **Aug 10 — C904 lands the fifth numbered paper, *The Golden Companion Correspondence*.** The
  eleven-page Paper V proves the marked chordal/conference pencil correspondence, recovers the
  six-axis carrier from the chordal singular quartic, and gives the exact image-restricted oriented
  return. Its vendored finite evidence, literature ledger, standalone replay, three sealed GO reads,
  and all five deterministic paper-only builds are green. The EJ/TT pass also proved the tame
  icosahedral `(2,3,5)` inertia stratification, finite-field split-type formula, and zeta function;
  those stay outside Paper V pending literature and certificate closure.

- **Aug 10 — C905 and C906 extract the series theorem and stop at the classical tower boundary.**
  C905 typed the five paperwise reconstruction profiles, proved the missing Hamming/Fano and
  11-cell inverses, identified the `n=4` cap fibre as `D₄` triality, and isolated the Segre--Igusa
  inverse on `D₊(e₅)`. C906 conceded the unmarked exceptional fold and graph chain to
  Brouwer--Shult/Brouwer--Van Maldeghem and the classical root-pair/Gosset/Schläfli chain, then kept
  only the marked judo theorem: a sparse Clebsch entry into a residue-flagged reversible tower, with
  exact bottom fibres 432/864/1728. Both are research reports; neither was promoted to a manuscript
  or Lean source.

## Week 12 — Aug 10–11 · A post-freeze Annals push, a cubic-threefold separation, and three finite layers closed

- **Aug 10 onward — C904 opens a quarantined Annals-ceiling programme behind the frozen Paper V.**
  With the eleven-page manuscript sealed, the task kept running as a long chain of dated gate
  passes, each with its own report, exact Sage generator, and an independent SymPy, Fraction, or
  Macaulay2 replay; none of it was imported into the manuscript, and no Lean source moved. The
  positive spine: the six-`D₅`-axis polarization matrix `6I−J` and the twenty-dimensional
  cubic–Winger correspondence carrier; the twin-simplex theorem pairing Winger's `3(5I−J)` against
  the cubic's `6I−J` and forcing the generic three-primary gluing; the exotic-`F₄` gluing result,
  where the three `F₂` gluings preserve `S₆` while each exotic gluing has stabilizer exactly `A₅`,
  so strong Torelli puts the cubic family on the exotic pair; the `X₀(6)`/`Γ₀(6)` integral rigidity
  theorem for the quartic period; and the six-axis minimal-class saturation, which put `Θ⁴/4!` in
  the fourfold-divisor-intersection lattice and so proved every smooth `A₅` cubic in Roulleau's
  pencil universally `CH₀`-trivial with the integral Hodge conjecture for one-cycles. Theta
  rigidification on the marked base then closed the smooth-family Picard gate positively.

- **Aug 10–11 — the same chain closed every cheap route to the remaining parity crown.** Successive
  passes killed the charge-two universal-sheaf gerbe (Druel Luna slice, cyclic algebra with nonzero
  residue, generic index two), both type-`(5,1)` divisor carriers, the twisted-cubic shortcut (680
  degree-three divisor products spanning a saturated rank-50 lattice with `Θ²` pairing ideal `2Z`),
  the universal-sheaf `c₃` escape (mod-2 invariant census through Wu's formula), and — by reading
  the primary sources rather than the computation — the Shen function-field descent shortcut, whose
  halving obstruction turned out to live in a higher-Chow kernel and to be a torsor under `CH₁`
  two-torsion, not `J[2]`. A degree-fifteen factorable-quadric packet made the charge-three and
  unordered-theta fibres 2-equivalent without producing a zero-cycle. Two uniform theorems were
  extracted en route — the Jordan-scalar minimal-class theorem and the prime-by-prime gluing-defect
  boundary with its spectral stabilization towers — each with its own bounded priority audit, which
  placed the likely new crown in primitive integral divisor-product saturation rather than in the
  consequences. The surviving crown is a single 1-vs-2 index question, and the task now carries an
  explicit dead-path ledger so the closed routes are not revived.

- **Aug 10 — C907 allocated as a separate exploratory task, and it produced the other half.** The
  quantum-monodromy stabilization test reconstructed Cai's `±1/6` cubic block from source formulas
  and proved that `X × P¹` is irrational for every smooth cubic threefold, using the nef-canonical
  surface-block exponent restriction against the dimension-at-most-two centres of fourfold weak
  factorization. Source-level audits then demoted two attractive ideas: the prime-power
  spectral-cycle idea, and globalizing the rank-two block as a proper subobject — the ambient
  module is the irreducible hypergeometric `H(0,0,0,0;1/3,2/3)`, whose local sectorial Stokes lift
  has ordered ranks `1,2,1`. Full stable irrationality stays open from `m = 2`. The C904/C907
  bridge went GO only after one invariant correction: a Boolean exponent flag was replaced by the
  additive multiplicity `ν₆` of primitive sixth-root formal-monodromy eigenvalues.

- **Aug 11 — C756 closes the `k=14` layer and converts the saturated-internal branch.** The mixed
  `q=71` branch fell (all 39 mixed stars fail `E₈ = 0`) and neither `q=73` branch has a geometric
  star, so `k=12`, `k=13` and `k=14` are all impossible over every finite field and no `k=15`
  census is planned. More consequentially, the saturated-internal branch acquired a standard
  incidence model — a dual 3-net of order `(q+3)/2` — and with it Blokhuis–Korchmáros–Mazzocca's
  classification closes **every prime field**, retiring the clique-bound route from the frontier.
  The extension-field remainder untwisted into one stacked Cartier–Toeplitz matrix whose kernel is
  forced by row count only at `q = 25, 27, 81`. The live card was retitled around those structural
  gates.

- **Aug 11 — C904 proves the golden-orientation/exotic-sheet calibration and re-plans the series
  architecture.** The maximal-order bridge on `D₆^∨` identifies the golden orientation torsor with
  the exotic `F₄`-gluing torsor through the unique nonsplit `F₄A₅`-extension; a follow-up Ext
  computation showed that extension is one-dimensional over `F₄`, and the theorem was assigned as
  Paper V's closing structural result rather than left as adjacent research. Four red-team rounds
  on the epilogue plan settled the publication architecture: five numbered papers, then one
  unnumbered geometric epilogue, with Paper IV entering the diagram through its hidden `F₈`
  commutant as the degree-three model of the same residual cyclic-marking principle — not through
  a fabricated cubic or `A₅` arrow.

- **Aug 10–11 — build-sys carries the serialized Q13 certificate build and the separated Paper I
  boundary.** Projective-cap Q13 advanced through Classes 0–99 with Class100 current, one class per
  target under the one-worker, cache-required `q13-serialized` profile; its admission reserve was
  raised to 12 GiB to stop retries in low-headroom conditions, and a restart checkpoint seals the
  latest sentinels. Paper I moved onto the separated three-repository boundary, with its
  regeneration split from verification, its release certificate recorded, and the sealed Q11 bridge
  pin refreshed.

- **Aug 12 — C909 tightens the cubic quantum boundary before any epilogue integration.** A direct
  small-quantum calculation shows that the odd `H³` summand has formal monodromy one, so together
  with Cai's even blocks the cubic sixth-root multiplicity is exactly `ν₆ = 2` at that point. Its
  continuation requires a parity-equivariant formal-isomonodromy theorem on the connected reduced
  unramified spectral component; it is not licensed by small-slice vanishing alone. The hostile
  editorial audit therefore retained the proposed dimension-`≤4` birational-invariance and trivial
  `P¹`-stabilization route only with its KKPYY and low-dimensional-centre hypotheses explicit, and
  demoted the proposed `V₁₄` equality to conditional nonvanishing pending comparison-locus,
  atom-transport, and full-atom upper-bound closure. No manuscript, Lean, mirror, or export edit was
  made.

## Week 13 — Aug 13–16 · A note published, a second manuscript drafted, and the cubic work gets its own lane

- **Aug 13 — C911 turns the Shen–Shoemaker repair into a published standalone note.** The
  discrepancy-one flip correction left the epilogue's research body and became its own ten-page
  manuscript at `papers/discrepancy-one-flips/`, with DOI `10.5281/zenodo.21924799`, Zenodo
  metadata, and the standard AI disclosure. It passed an independent cold read after explicit
  nonsplit-descent and formal-endpoint repairs, and the clean paper and portfolio-summary
  repositories were synchronized without pushing. This is the first externally released item to come
  out of the stabilization programme.

- **Aug 13 — C907 runs its longest negative chain.** Dozens of dated gate passes on the tropical,
  Rees, carrier, and Stokes routes to `m = 2`, most of them closing a route rather than opening one:
  the marked ratio fan obstruction, the nodal Clifford carrier, the del Pezzo primitive-monodromy
  obstruction, the Picard–Lefschetz stationary-Rees countermodel, the punctual Fourier corner no-go.
  Two `ej`+`tt` closeout passes and a hostile audit ran inside the same day. The task's own cold-read
  cluster on the Gamma point row — four independent reads plus a synthesis, a reviewer dossier, and
  a theorem-package red team — fed straight into the next item.

- **Aug 13–14 — the all-`m` manuscript is drafted from that package.** The Gamma rank-functional
  draft was revised after cold review, sharpened into a point-row theorem package, and became
  `papers/cubic-stabilization-irrationality/`, retitled *Gamma Point Rows under Quantum Wall
  Crossing and a Criterion for Stable Irrationality*. C913 was allocated to referee-revise it, and
  the work ran through Claude Fable referee reports with a recorded disposition, four independent
  cold reads (birational-quantum, counting-failure, cubic-endpoint, derived-gauged), and source
  extractions from Włodarczyk and Woodward that were read at the source rather than quoted from the
  draft. C914 opened alongside it on where Roulleau's pencil sits relative to the known loci,
  starting from an explicit Fermat-membership computation.

- **Aug 15 — the `cubic-threefolds` lane splits off from `clebsch`.** C907, C908, C909, C910, C911
  and C914 were re-pegged to the new lane, and C912 and C913 were pegged there by author
  instruction, taking both stabilization manuscripts with them. The `clebsch` lane kept the five
  numbered papers. The same day carried the heaviest single audit chain of the week, on C912's
  Hypothesis 4.7H: a red team with per-item provenance, an evidence ledger, a source-exactness audit
  of every imported claim, a normalization statement reducing the hypothesis to two named
  obligations, then a hostile referee pass that **withdrew** the base-change transport argument and
  logged the roof and gauge-uniqueness defects. The frame-transport memo was split, superseded routes
  archived, and the unconditional `X × P¹` computation promoted to its own section. An independent
  verification of the rank-two atomic residue proof found the mechanism correct but the parity ranks
  resting on an unproved splitting assertion in the source; horizontality of the Poincaré pairing
  over the Novikov ring was then proved directly, discharging the one imported-but-unavailable step.

- **Aug 16 — the atomic restructure, and an erratum sent upstream.** The cubic zero-atom splitting
  objection turned out to be repairable: the discriminant of the Euler characteristic polynomial
  satisfies `X_s(disc) = c_s·disc` on any regular F-manifold, re-run formally over the Novikov base
  rather than imported, with base integrality by Conrad's identity principle. A source re-read of the
  KKPY erratum items withdrew one scope objection, confirmed the matrix error is derivable from their
  own Givental equation, and produced a machine-checked scalar-ODE follow-up validated against their
  own worked quadric example. After this the epilogue's Section 4 gives an unconditional Hodge-atom
  route to the one-stabilization theorem, and only two hypotheses remain, carrying the Section 5
  framed refinement. Elsewhere the same day: the `ame-lu` lane applied a user-supplied external
  referee edit packet in full — all twelve anchors matched verbatim against the exact PDF rendering
  the reviewer read — and the `reed-solomon` lane was routed to C915 while its referee package
  finishes independent dependency, hostile, and primary-source audits.

## Week 13 continues — Aug 17–20 · Five closures, a prior-art catch, and the node count proved structurally

- **Aug 17 — C916 lands the Paper III referee corrections.** The author's frozen correction
  specification was applied to `papers/clebsch-passages/`: Hitchin's degenerate divisor and
  degree-ten invariant introduced without a normalization, the reduced-branch-cycle and `xyz`-fibre
  arguments rebuilt on the compact trichotomy instead of a count of real regular configurations, the
  height-one normality lemma added, and the two-regular locus restated as a principal open set. Every
  imported Hitchin statement was verified against the cached source; exactly one statement-identity
  hash moved; the standalone export was synchronized without pushing. Two items were excluded by
  author instruction.

- **Aug 18 — C912 closes and three tasks land on top of it.** All twelve C912 work packages passed,
  with independent quantum, geometry, and general cold reads plus copy-edit and detritus audits all
  GO. C917 then landed the author's positioning specification in the introduction — why the direct
  Clemens–Griffiths mechanism gives no contradiction after one stabilization, and where the result
  sits relative to Guéré and Benedetti–Fay–Guéré–Manivel–Perrin, whose criterion assumes `b₃ = 0` and
  so does not reach `X × P¹` — with both sources verified in the shared literature cache. C920 proved
  specialized primitive-sixth vanishing for every Hirzebruch surface, narrowing the divisor-tagging
  hypothesis to surface centres that are neither minimal nor geometrically ruled, behind four Lean
  modules, an evidence bundle with six independent cross-checks, and three rounds of referee cold
  reads. C918 repaired Paper V's links in the published summary index and traced the series epigraph's
  disappearance to a single deliberate anti-over-branding commit. C910's Lean companion advanced
  through the atom-route anchor, the small even block reduction, the six-point hearts, and the
  rank-two residue rigidity algebra.

- **Aug 19 — an audit catches uncited prior art, and two computations are replaced by proofs.**
  C922 re-derived every quantum presentation, Euler matrix, quartic, and discriminant behind C920's
  manuscript edits independently and found the mathematics correct — then found that the two
  Hirzebruch presentations and the deformation route producing them are published as Cotti,
  Mem. Eur. Math. Soc. 2 (2022), Chapter 9, uncited because no literature search had been run, and
  that one round-three referee blocker reported as applied never was. All seven findings were
  repaired, and the self-re-review corrected two of its own overstatements before commit. C923
  replaced the Gröbner elimination behind the pencil's Eckardt proposition with a proof from complex
  reflection groups, leaving the manuscript with exactly one premise-level computation. C924 read the
  epilogue, the direct-QDM packet, and every load-bearing primary source, and found one real defect:
  a claimed embedding of the full fibre-variable completion into the opposite Laurent completion does
  not exist, and the comparison must run through Iritani–Koto's common faithful ring. C919 de-branded
  all five Clebsch paper fronts and moved the series apparatus into post-conclusion codas, recording
  the convention in the style guide. C880 narrowed the nonadaptive query-complexity bracket by a
  factor of `8/3` and then measured which end is loose. C921 closed the genus-four branch of the
  residual Voisin gate negatively and corrected C914's description of the four-dimensional factor.

- **Aug 20 — the conference node count is proved twice, and the second proof wins.** C926 certified
  over `F₁₁` that the singular scheme of the `A₅`-invariant conference triangle cubic is exactly six
  reduced ordinary nodes, by a Gröbner dimension-and-degree computation closed against six distinct
  rational singular points with rank-four Hessians, with the chordal sheet cubic as a control. C927
  then proved the same count without a computer, determinantally and in every characteristic outside
  `{2,3,5}` in which five is a square, superseding C926's Gröbner step as the authority while keeping
  it as an independent replay. Both left the manuscript unedited by user instruction. The same day,
  C816 ran its first review gate — a theorem-level red team of Paper III's operator section that
  confirmed every mathematical assertion and returned two proof-level repairs — C910 formalized the
  odd-label Frobenius marking that selects the exotic member, and C925 continued the modular
  direct-QDM proof packet, whose `m = 2` ambiguity is now localized to consecutive discrepant
  receiver overlaps.

## Week 14 — Aug 21–25 · Three manuscript spines are rebuilt and exact level two emerges

- **Aug 21 — the elliptic resolvent becomes its own paper, while two other manuscripts clear cold
  review.** C935 identified the exotic gluing torsor with the discriminant orientation of the actual
  elliptic two-division cover. C936 then built the eleven-page modular-resolvent companion: `T=81t²`,
  `r=9t`, base `X₀(6)`, cyclic `A₃` monodromy, exact cusp and boundary data, the factor-five Prym
  comparison, and the chordal twelve-point icosahedral certificate; hostile re-review accepted the
  repaired paper and a closeout pass added the eta-quotient formula for `t`. C937 rebuilt the
  Frobenius-equivariant completion paper in layers and C938's bounded conceptual scout confirmed
  that its residual `PG(2,25)` certificate still has no genuine global replacement. C939 proved the
  matched-availability seed pair and its positive-density asymptotically good lift for the recovery
  paper. C942 finished the public reviewer guide for the one-stabilization epilogue after formal,
  mathematical, and hostile cold reads.

- **Aug 22 — higher-arc integer envelopes and rank-stratified recovery land.** C943 replaced coined
  conference/recovery vocabulary across the paper portfolio with conventional terminology, leaving
  only Paper I's pre-existing trust dependency before full export. C944 applied the same discipline
  inside the recovery manuscript. C945 produced the separate *Integral Secant Distributions* paper:
  exact integer degree envelopes, factor-pair resonance families, modular-lift surcharges, human
  proofs, evidence, partial Lean coverage, and a bounded priority ledger. C946 derived exact
  multi-target confinement; C947 identified finite-field minimum joint row support, proved neither
  submodularity nor supermodularity and NP-completeness already for one binary demand, and bounded the
  arithmetic sequel; C948 then proved that relative generalized Hamming weights of the associated
  nested pair are exactly the rank-stratified helper costs, with the dual ambiguity hierarchy and
  best-target, MDS, service-rate, and reliability consequences.

- **Aug 23 — the speculative all-stabilizations route is stress-tested to failure boundaries.** A
  dense C925 sequence enumerated the `b₃=0` Fano tail, closed toric and blow-up-chain carriers,
  reduced the non-Fano residue through conic bundles and del Pezzo fibrations, and built a
  Stokes-decorated ledger. The same run corrected a false empty-class assertion and withdrew a
  candidate birational-invariance theorem after a splitting counterexample exposed circularity.
  The surviving value was a sharply delimited cancellation/rationality route, not a proof of the
  conditional all-`m` headline.

- **Aug 24 — the recovery paper is rebuilt, exact level two replaces the failed cubic headline, and
  the sharp higher-arc construction gate opens.** C950–C952 rebuilt the recovery manuscript around
  the shortening–puncturing pair and exact relative-weight hierarchy; C954 added dual failure
  thresholds; C957 restored the exact finite weighted rank-one formula; C959 removed generator-basis
  dependence; C960 proved ungated arbitrary-rank transfer through joint prescribed-coset costs; and
  C961 proved associative min-plus composition with sharp envelopes, producing a verified
  twenty-four-page standalone candidate. In the cubic lane, the bounded C925 chain was distilled
  into C956's ten-page paper: a quartic-del-Pezzo two-variable rationality theorem and exact
  stabilization level two for two explicit smooth cubic threefolds. C958 began extracting explicit
  maps. In the relative-conic lane, C949 proved `t₇(2,9)=39` structurally, isolated the five-character
  blocking core, excluded three natural `q=27` symmetry models, and reduced the Frobenius case to two
  canonical branches.

- **Aug 25 — explicit formulas and signed incidence take over the frontiers.** C958 identified and
  parametrized the residual norm-one torus, constructed the full rational Cox coboundary, coupled it
  to the norm chart, and reduced the type-`I₁` tangent quotient to one four-parameter inverse; type
  `I₃` remains. C949 descended the centered incidence vector to a signed secant codeword of support
  `4q−6`, with no tangents and opposite signs on every support 2-secant, sharpening the remaining
  `q=27` construction gate without completing it. C962 was allocated for paper-owned recovery
  algorithms and bounds, explicitly excluding manuscript and formalization work until the mathematics
  is ready.

## Week 15 — Aug 26–29 · A compiler leaves the paper, beats published tooling, and reaches quantum codes

This is the week the recovery programme stopped being only a manuscript. The algorithms C962 was
allocated for turned into **ergodis**, a standalone Rust library and CLI living under
`papers/complete-repair-ports/ergodis`, and by Aug 28 it was being benchmarked against published
state-of-the-art tools rather than against itself. In parallel the `ame-lu` lane ran a seven-task
referee-and-compression chain to a verified export, `reed-solomon` closed its characteristic
hypothesis, and the new `quantum-codes` lane reported its first result.

- **Aug 26 — the recovery algorithms close and the compiler's mathematical object is identified.**
  C962 `[complete-ports]` closed exact prescribed-coset, composition, confinement, reliability,
  service-region, and contextual-state algorithms with independent Python/Rust cross-checks and
  bounded benchmarks. C972 then characterized the *universal minimal compositional state*: rank-one
  outer contexts observe exactly the zero-sector cost and the zero-truncated projective line-probe
  profile, so their equality is the coarsest numerical contextual congruence — the theorem that
  licenses quotienting before search. In `reed-solomon`, C974 implemented arbitrary-redundancy
  simultaneous and pointed locators and C975 rebuilt *High-Weight Cosets of Generalized and Extended
  Reed–Solomon Codes* around the arbitrary-redundancy point-deleted top-two-shell theorem. C949
  `[relconic]` excluded the proposed `4/3` linear coefficient, raised the structural lower
  coefficient to `5/3`, showed the exact `5/3` endpoint is also absent, and froze its accumulated
  proof ledger into a routing snapshot so future sessions start from the shorter card. C815
  `[clebsch]` closed four algebraic and finite-linear-algebra pieces of Paper III's Lean surface
  without claiming the geometric identifications they are built to receive.

- **Aug 27 — C983 is the largest single research run of the week.** It reframed ergodis as a *finite
  analysis compiler*, grounded it in max-plus control theory, red-teamed the framing against
  optimization diagrams and against exact mergeable summaries, pre-registered an outcome ladder and
  a terrain ledger before measuring anything, and only then built the certified observational
  compiler spike with recovery/replay sidecars and hierarchical composition control. Its theorem is
  that the finite many-sorted Moore contextual quotient is the coarsest typed congruence, with
  classical DFA minimization falling out as the one-sort corollary — which is what made a comparison
  against automata tooling legitimate rather than opportunistic. Alongside it, C971 stabilized the
  paper-owned library and CLI with Python differential parity, public documentation, and fair
  competitor benchmarks; C980 and C984 proved and then integrated the higher-rank small-model package
  (pointed column-type response theorem, radius-`r` separating contexts of length at most
  `max(2,r+1)`, exact dual-shortening identity); C976 replaced an aborted packet-by-packet review
  with an introduction-only cold read followed by section-level and global rereads. In `ame-lu`,
  C981 and C982 identified the manuscript's multiplier space as the standard code conductor and
  Schur-square defect and proved sharp dimension and support bounds for conductors between
  unequal-dimension MDS codes. C977 `[reed-solomon]` completed a 263-paragraph cold read; C973 drove
  `GF(27)` through Borel-boundary compression, three-line cover, and torus endpoint closure. C978
  `[cubic-threefolds]` repaired the sharpness manuscript's exposition to a full cold-read accept.

- **Aug 28 — external benchmarks, a licence change, and the first `quantum-codes` result.** C983
  closed with pinned MATA/Boa evidence (1.61–3.30x direct wins over MATA's C++ Hopcroft/Valmari
  implementation on shared controls, 13–38x lower cold peak RSS, and the recorded 2.48x Boa
  crossover on the four-generator random family, published rather than suppressed). C985 then ran the
  external-validity benchmark that matters: all 169 instances of MATA's published TACAS'24 explicit
  Presburger-complement input list, both systems minimizing the same derived trimmed DFA, giving a
  **2.699x geometric-mean speedup** with paired-log `t = 26.20`, 158 wins and 11 losses, every loss
  on an automaton of 2–12 states and every instance of at least 13 states won. C987 measured
  application crossover and found no tiny or sequential-query win, retaining the control as
  conditional rather than claiming one.
  The repository and ergodis were relicensed to AGPL-3.0 with MIT retained for the paper, and the
  README and `Cargo.toml` were pointed at a standalone ergodis repository. C997 `[quantum-codes]` —
  the first task of that lane to report — passed its symmetry-reduction gate. C988
  `[reed-solomon]` integrated the all-characteristic classification and C973 closed. The `ame-lu`
  lane ran C989 → C995 as one chain: the intrinsic block-diagonal endomorphism algebra and
  common-holonomy-centralizer theorem replaced a five-order tail, referee clarifications became an
  exact four-factor telescoping inequality, Appendix B was compressed to its structural core, and two
  independent context-clean cold reads returned `GO` before C991 verified the Paper I export.

- **Aug 29 — commercialization design and the next compiler frontier.** C998 `[complete-ports]`
  designed (and deliberately did not execute) a five-tier public/private split of ergodis for AGPL
  plus commercial dual licensing, with zero public→private module edges and the observational
  compiler shipping public so the MATA/Boa claim stays verifiable. Its per-vertical patent landscape
  found the quantum vertical patent-empty, the storage vertical the only one warranting paid
  freedom-to-operate work, and §101 the dominant risk. A separate prior-art assessment against
  VeriPB-style pseudo-Boolean proof logging *and* the certified-automata-minimization literature
  reversed the initial read and returned **do not file** on the certified compiler alone: the
  pipeline is unoccupied, but every individual component is anticipated. On the engineering side C985
  opened the certified semantic-symmetry frontend (`semantic_symmetry.rs`, compiling a
  `FinitePermutationAction` into a `NonemptySupportOrbitCover`), wrote the Gurobi boundary memo that
  fixes the product line — ergodis compiles and lifts, generic search is delegated — and added a
  native exact CSS distance backend with parallel and persisted anchor search. C925
  `[cubic-threefolds]` added rank-seven lattice probes (sign-permutation, sign-type exhaust, torus
  splitting, root-stable level) to the modular direct-QDM packet.

## Week 16 — Aug 30 – Sep 4 · The compiler becomes its own repository, a headline loss is converted into a win, and a decoder line opens

This is the week the compiler stopped being a subdirectory of a manuscript. Ergodis was audited for
correctness, given a measured negative-control tier that says where it loses, moved out of the
monorepo into its own repositories behind a publication guard, and then pointed at two new problem
classes — real-time quantum-error-correction decoding and structural causal models. On the
mathematics side an eight-hour overnight hunting campaign produced the strongest single night of
results in the gem-mining lane, and a full-text reading of a 1991 paper pre-empted the figure that
campaign's sibling task had just rediscovered.

- **Aug 30 — an overnight hunting campaign, a Hall attack on the cap game, and a whole-core audit.**
  C1018 `[gem-mining]` launched an eight-hour Ergodis hunting campaign at 23:15 against the bounded
  targets in `notes/open-problems/plausible-bridges/`, with sub-agents per lane; one twenty-minute
  session-limit interruption at about 03:00 was survived because the sub-agents resumed with their
  context intact. C80 `[cap]`, user-directed into the same campaign, built the global Hall
  rematching driver. On the engineering side, C985 wrote three read-only portfolio studies — a
  method inventory that reads every successful C task as one loop (enumerate structured partial
  objects, quotient, retain one obstruction per class, extract a lemma from the exceptional classes,
  replay independently), a cross-domain gem scan, and an evolve state-of-the-art literature audit —
  and C1017 wrote the performance-contract remediation report against the C985 whole-core audit,
  which had graded solve-loop zero allocation, search recursion, and the public/private partition
  at D. C1016 `[complete-ports]` synthesized the Hadamard quotient work into one document.

- **Aug 31 — the campaign closes with six result lanes, and the correctness audit lands.** C1018
  closed with wins on projective Reed–Solomon deep holes (Conjecture B falsified at redundancy nine
  by an exhaustive census of all 883,708,281 points of the projective eight-space over the field of
  thirteen elements), on quantum low-density parity-check distances (all six previously open
  Liu–Marquardt lifted-product codes closed exactly, and a new exact rate–distance record), on a
  finite transversal-gate no-go census, and on a narrowing of the bivariate-bicycle
  `[[756,16,d]]` band; mixed results on projective planes of order 12 and on the cap game.
  C1019 turned two of those capabilities into commercial prototypes, `certdist` and `certiis`.
  C1020 reconstructed Brouwer's complete exceptional exterior-set census and refuted C193's declared
  null; **C1022 then audited it against Dye 1991 read at full text from user-supplied page scans and
  found the figure itself pre-empted**, leaving only the census bridge — the novelty-extraction
  procedure working exactly as designed, on the same day. C1023 and C1024 closed the two proposed
  routes to making the deep-hole threshold rigorous; C1025 found its own premise false and the
  conjecture surviving on a domain an order of magnitude larger; C1026 collapsed the conjecture's
  two hypotheses into one inequality. C1027 surveyed fifteen importable solver techniques and
  implemented none. C1028 and C1029 ran the two instrument tests (finite chain rings; the
  repository's first parametric certificate). C1030 ran the whole-core correctness audit — four
  parallel pass-1 audits, a vetting pass that refuted one finding outright and corrected three
  severities downward, then four round-2 audits — and produced the correctness-safeguards decision
  record. C1031 explored a campaign console.

- **Sep 1 — adapters, oracles, and two new quantum distances.** C1031's console was red-teamed and
  left as a prototype with no production build allocated. C1033 began the DuckDB/Jupyter/Sage
  analysis integration. The C985 line landed the optional CSS automorphism-discovery adapter (nauty
  as an untrusted proposer with no proof authority, every generator re-checked against both row
  spaces), check-presentation autotuning, and the proposal/admission architecture that generalizes
  that pattern for Ergodis Evolve. Two quantum results: `LP_714_100_?` certified at exact distance
  16 in under three seconds of search where the published QDistSAT table records that none of its
  46 configurations finished under a 7,200-second limit; and `LP_1768_224_?` bracketed at
  `22 ≤ d ≤ 24` against a published `8 ≤ d ≤ 230`.

- **Sep 2 — the heaviest engineering day of the programme: consolidation, a benchmark tier, five
  promotions, the repository split, and the L2 reversal.** C1034–C1036 turned `ergodis-private` into
  a Cargo workspace and reduced its auto-discovered binaries to three task binaries, deleting the
  dead and banked ones with history preserved; C1037 moved every build tree out of the source trees
  and found roughly 31 GiB of unreferenced cache reclaimable. C1038 replaced the assertion "ergodis
  is not a general constraint-programming replacement" with a **measured** frontier: a shape
  classifier and a six-row prediction table were SHA-256 hashed before any measurement, and five of
  six rows landed on the predicted side. C1039 measured the admission boundary on a planted
  theorem-gap corpus: 1,120 candidates screened, exactly one admitted, 620 rejected as unsound each
  with a replayable counterexample. C1049 then attacked the tier's worst row and C1060 finished it,
  converting L2 from a 13,689x loss into an 11x win with a 128-byte certificate. C1051 ran the
  evolve representation-search spike and, unprompted, found a correction to its own control.
  C1053–C1057 promoted five kernels into the core under parity, zero-allocation and
  hardware-counter gates. C1058 executed the repository split — 378 commits replayed onto the
  C1059 tip, four repositories, fresh-clone validation, and a monorepo commit removing the trees —
  and C1059 built the publication guard it landed on, with 44 of 44 fixture refusals passing.
  **Nothing was pushed anywhere.**

- **Sep 3 — thirty-one probes in one day on a compiled dynamic decision engine.** C1061
  `[complete-ports]` ran an open-ended exploration of Ergodis as a compiled *dynamic* engine:
  compile the fixed structure once, then answer a stream of typed events by a leaf-to-root
  recomputation. Probes 1–9 and 11 established the core engine on coded-repair fleets; probes 7, 10,
  12, 15, 17, 19 and 20 tested generality and found network routing a win, the probability semiring
  a wrong answer (a union-bound surrogate over-counting by a factor of twenty), and the exact
  transducer real but *computed* rather than tabulated. Probe 13 delivered a decisive loss for the
  dense approach against PyMatching's sparse blossom, which is what caused the line to build
  TigerBlossom from scratch in probe 26. Two probes were stopped by user instruction with their
  consequences recorded rather than papered over — probe 21's absence means the routing ratios stand
  only against a static comparator. In parallel C1016 ran the unrestricted order-2092 campaign and
  the multiplier shard-window sweep, and a Fable review of the reduction argument.

- **Sep 4 — TigerBlossom overtakes PyMatching, a causal-model spike lands, and a surface-code bug
  invalidates one probe family.** The probe-28 sub-series (28b–28h) drove the sparse matcher to
  sixteen of eighteen cells ahead of PyMatching by 2.5x to 11.5x, with the margin growing with code
  distance and largest exactly where superconducting hardware operates. Probe 28h killed the
  certified margin predecoder exhaustively and, in doing so, exposed a distance-one bug in the
  repository's own rotated-surface-code builder that predates the task; **every surface-family
  number taken before this day is invalidated, while every repetition-code number — which is the
  whole PyMatching comparison — is untouched.** C1062 ran the structural-causal-model spike: its
  adversarial plan review killed the first lowering before any code was written, the repaired
  lowering is exact and compresses states by up to 84x, and its headline economic claim failed for a
  structural reason (with hard interventions the intervention set *is* the state set). C1063 was
  allocated to route TigerBlossom to its best solver per shot; the user's same-day scope refinement
  reordered it — fix the benchmark grid toward realistic error rates first, then fit the routing
  threshold on it.

  **Process notes for the week.** Two load-bearing premises in three tasks were false and both were
  asserted from the shape of the situation without one cheap probe; both were caught by a
  coordinator gate placed before the build, and the reports say so. The C1030 audit's fifth root
  cause — the evidence chain not being in git — made every replay command in the affected committed
  reports dead against any commit, which is what the C1058 split and the C1036 consolidation were
  partly for. Fable was used for two adversarial reviews (the C1016 reduction argument, probe 28g).

---

*Snapshot; the live task frontier is the codex task queue, the per-lane handoffs, and
[`papers/papers-index.md`](../papers/papers-index.md).*
