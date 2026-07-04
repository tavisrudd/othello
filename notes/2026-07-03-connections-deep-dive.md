# Connections deep dive — verification, scooping analysis, transfer design (2026-07-03)

**Status: FINAL (session-complete; §1.6/§3 compressed under session budget — gaps marked).**

**Role**: the deep-analysis stage following the
[non-CGT connections scout](2026-07-03-nonCGT-connections-scout.md). Inputs: the scout's
ranked connections, the [external review + backlog](2026-07-03-external-review-and-backlog.md),
the theory notes ([conjecture theory](2026-07-02-a344227-conjecture-theory.md),
[winning geometry / n=20](2026-07-03-winning-geometry-n20.md),
[CGT laws](2026-07-03-cgt-laws-and-tricks.md)), and the
[certified-nimbers stage-1 proposal](proposal-2026-07-02-certified-nimbers-stage1.md).
No builds, no solver runs; verification = arXiv/web fetches this session. Every paper marked
**[V]** below had its abstract/landing page read this session.

---

## 2. Scooping / priority analysis (the time-sensitive section — deliberately first)

### 2.1 Dai–Kelly (reflecting n-queens) — risk LOW; the scout's "near-twin" framing is WRONG

**Verified [V]**: Dai & Kelly, "On the existence of reflecting n-queens configurations,"
arXiv:2407.12742, **published in Forum of Mathematics, Sigma** (cite the journal version, not
just arXiv). Their object: n non-attacking queens on an n×n board **augmented with a 1×n
reflecting strip** whose effect is that diagonal attack rays bounce off that edge. Equivalent
(Klarner 1967) to Slater's problem: pair 1..n with n+1..2n so all n sums and n differences are
distinct. Result: existence for all sufficiently large n; **the finite small-n gap is open**.
Technique: probabilistic combinatorics (absorption/completion machinery).

**Where their formalism and ours actually meet and diverge.** The scout called this "a
rigorous form of our mirror-obstruction theory." On re-derivation that is overstated:

- **Their object is static and on a different board.** A reflecting configuration is a
  *placement existence* statement on a modified attack geometry. Our Mirror-Obstruction Lemma
  is a *strategy* statement (a pairing strategy for the responder in an alternating game) on
  the standard board. No reduction runs in either direction.
- **The real shared substrate** is (i) the Slater "distinct sums and differences" structure —
  sums/differences index anti-diagonals/diagonals, exactly the two line pencils our Lemma 1
  isolates; and (ii) the **classical no-reflective-symmetry lemma** for ordinary n-queens
  solutions, which is the *static shadow* of our §3.2 argument: a solution fixed by the
  main-diagonal reflection would need its queen set closed under (r,c)↦(c,r), and any such
  pair shares the anti-diagonal r+c — mutual attack; a solution fixed by a row-axis reflection
  needs pairs sharing a column. That lemma is elementary and classical (symmetry classes of
  n-queens solutions: trivial, C2, C4 — never a reflection); it is NOT a Dai–Kelly novelty,
  and our strategic version (reflections have a full line of self-mirroring squares; only
  ρ=180° gives a usable pairing) is the game-theoretic upgrade of a known static fact.

**Scooping verdict**: Dai–Kelly cannot scoop the mirror-obstruction theory — they are not
working on games, and nothing in their program produces strategy statements. What they hold
that we should import: (a) the **citation pair** (Dai–Kelly + Klarner/Slater) for the related
work — it shows the "diagonal constraints are the obstruction locus" phenomenon has an
independent life in extremal combinatorics; (b) their **absorption/completion technique** is
the only known tool for "complete a partial non-attacking structure," which is the shape of
any future proof that border scars are repairable — a long-shot import, flagged not planned.
What we hold that they don't: the entire game/nimber layer; the exact even-n refutation data
(which reflection-symmetric openings fail and where); the n=18 witness; Theorem 3.

**Action**: related-work sentences (§5.1); the small-n gap closure as a micro-note +
contact vehicle for Kelly (§3.3). No urgency.

### 2.2 Liu–Liao–Wang (lattice-gas, May 2026) — risk MODERATE and the only clock that ticks

**Verified [V]**: Liu, Liao & Lei Wang, "Statistical mechanics of the N-queens problem,"
arXiv:2605.10326. Monte Carlo to N=1024 + a **rank-9 transfer-matrix tensor network** +
thermodynamic integration; recovers the Simkin constant (γ_MC = 1.946 ± 0.003 vs α ≈ 1.944);
headline: **no thermodynamic phase transition** (non-divergent specific-heat peak,
C_v^max/N ≈ 1.63 at T* ≈ 0.235 J).

**Assessment.** This is literally our object minus the game/nimber/torus-vs-board layers —
the scout is right. Two consequences:

- **Their result HELPS our paper**: "no bulk transition" is independent physics-side evidence
  for our central structural claim — the hardness is **not** bulk criticality; the torus
  collapses (G(torus) ∈ {0,1}, parity-law data to n=10) and everything n-dependent lives at
  the border. Cite them for exactly this and the framing writes itself.
- **The scooping surface is the border story, not the game.** A stat-mech group with a working
  transfer-matrix tensor network is one contraction away from "open board vs torus free-energy
  difference = an O(n) boundary term + corner corrections" — the quantitative shadow of our
  border-defect theory. They have no visible motive to look at games or nimbers, but boundary
  free energy is a natural second paper for them. **Mitigation: get our preprint (with the
  border-defect/torus-collapse claims and the torus nimber data) on arXiv before initiating
  any contact with this group.** The game-layer results (n=18, G(14..16), Theorem 3, the
  mirror-obstruction mechanism) are not reachable from their toolchain at all.

**What to import**: their tensor network is a ready independent cross-check of our exact
enumeration (independence-polynomial coefficients / counts), and thermodynamic integration is
the right tool if we ever quantify "excess border entropy." Import AFTER our preprint.

### 2.3 The certificate lane (Pavlov CQD; Takizawa) — venue race is real, differentiators hold

**Verified [V]**: Pavlov, "Capture-Quiet Decomposition" (arXiv:2604.07907, Apr 2026):
a verification theorem for chess WDL tablebases (terminal/capture/quiet trichotomy; capture
nodes anchor to separately-verified smaller sub-models; quiet nodes get a local retrograde
check); validated empirically across three- to six-piece endgames (~6.5 B positions).
**NOT mechanised in a proof assistant** — the scout's "future work: Lean 4/Coq" quote did not
appear in the abstract; treat the mechanisation gap as open, which is *better* for us.
**Verified [V]**: Takizawa, "Semi-Strongly Solved" (arXiv:2411.01029, revised Mar 2026):
certificate-exporting game solving (6×6 Othello, 7×6 Connect Four), third-party-checkable
certificates but **no formal verification**.

**Assessment**: two active groups are converging on "game solving with checkable
certificates"; neither has (a) a proof-assistant-verified checker, (b) impartial games /
nimbers, (c) a new mathematical result as payload. Our stage-1 differentiators —
kernel-complete Lean SG theory (`win_iso`/`win_emb`/`grundy_sum` already proven), a DAG
domain with **no repetition/GHI** (the thing that makes chess checkers hard), and the
G(14..17) payload — all survive verification. The "first verified impartial-game nimber
table" claim appears to be genuinely open and ours to take. **The risk is venue timing, not
content**: both adjacent papers are 2026-active, so stage-1 Phases A–C should move promptly
once the box frees (unchanged from the proposal's own mitigation note).

### 2.4 The core nimber extension — risk LOW, insurance is cheap

Searches this session for queen-graph Node-Kayles / A344227 activity in 2025–26 surfaced
nothing beyond the known corpus (Wong et al. JIS 2020 [V, no queen graph]; Songsuwan trees
[V]; Burke–Ferland–Teng [V]). oeis.org still 403s WebFetch (both the page and the fmt=text
endpoint), so the entry could not be re-inspected, but no search surface shows an extension
past n=13. **The OEIS submission of G(14..16) (+17 when it lands) is the cheapest possible
priority stamp — hours of work — and should not wait for the paper** (§3.1).

---

## 1. Bridge verification (per-connection verdicts)

### 1.1 Scout #1 — A344227 = Node-Kayles nimbers of {Q_n}; periodicity — CONFIRMED, top rank agreed

The bridge is an identity, not an analogy (the game *is* Node-Kayles on Q_n). Verified:
Songsuwan, "Node-Kayles on Trees" (arXiv:2512.24221) **[V]** — eventual periodicity of Grundy
sequences for n-regular trees and two-trees-joined-by-a-path (note: **single author**, not
"et al."). Wong et al., "Nimber Sequences of Node-Kayles Games," JIS 23 (2020) **[V]** —
paths/lattices/prisms/chained-linked cliques/hypercubes/generalized Petersen; **queen graph
absent**. The queen family as the dense, module-free stress case for the graph analogue of
Guy's periodicity question stands. One precision fix: Burke–Ferland–Teng **[V]** prove
**Generalized Geography is SG-complete** for polynomially-short impartial rulesets; the
abstract does not confirm the scout's "Node-Kayles is SG-hard" — verify against the paper
body (or the TCS version) before citing that specific claim; cite the GG result and the
"not all PSPACE-complete rulesets are SG-complete" separation, which are confirmed.
Useful extra: our game is itself **polynomially short** (game length ≤ α(Q_n) = n), so it
sits inside their completeness class — the framing fits exactly.

### 1.2 Scout #2 — Reflecting queens — DEMOTED from "near-twin" to "cousin"; see §2.1

Survives as: related-work citation pair + a small-n-closure micro-note + the Kelly contact.
Does NOT survive as: "the single closest external match to our theory." The static
no-reflective-symmetry lemma is classical; the Slater sums/differences structure is the real
(and real enough) bridge.

### 1.3 Scout #3 — Toroidal queens = strong complete mappings — CONFIRMED, and we already hold new data

The map is exact: a toroidal n-queens layer = a permutation ψ with i↦ψ(i)±i both bijective =
a strong complete mapping of Z_n; Pólya's gcd(n,6)=1 existence criterion is the toroidal
collapse condition the theory notes already use. Verified: Bastide, Bishnoi, Groenland,
Gijswijt, Joshi (arXiv:2510.18529) **[V]** — circular sorting ↔ strong complete mappings,
with an exhaustive computation anchored at n=25 and non-affine constructions; the scout's
"compute-bound at n≈23–31" reading is consistent with the abstract. **Under-appreciated by
the scout**: the game-side deliverable is already half in hand — `G(torus_n)` for n=1..10
(cgt-laws §2.4) with the parity-law Conjecture T1 — a genuinely new sequence no one has
computed, OEIS-ready, and the cleanest quantitative isolation of the border (torus parity
law intact vs plane even→0 broken at 18).

### 1.4 Scout #4 — Machine-checkable certificates — CONFIRMED with one correction; see §2.3

The CQD structural map re-derived and it holds: terminal ↔ empty move set; capture-anchor ↔
dense W-table base cases; quiet local retrograde check ↔ one-ply mex law. Correction: CQD is
empirical, not mechanised, and our checker design (recompute leaves) removes even the
sub-table trust step CQD needs. The QBF strategy-validation lane (Shaik et al., SAT 2023) is
real but a *different artifact* — keep out of stage-1 scope (§3.1).

### 1.5 Scout #5 — Lattice gas — CONFIRMED; see §2.2

All load-bearing claims of the scout verified against the abstract (MC to N=1024, rank-9
tensor, γ = 1.946 ± 0.003, no transition). The "queens = first interacting layer above
free-fermion rooks (dimers on K_{n,n})" dividing line is sound and citable as framing.

### 1.6 Under-ranked connections (disagreements with the scout's ranking)

- **Scout #9 (SG-completeness / nimber-vs-outcome gap) is under-ranked.** It is the cheapest
  high-value import on the board: one confirmed citation (Burke–Ferland–Teng **[V]**) gives
  the main paper its complexity-theoretic frame — *the nimber is harder in kind than the
  outcome* — which is the first-principles explanation of our own result shape (n=18 outcome
  solved while G(18) is still computing). Merge into the paper NOW; the misère-quotient half
  stays parked.
- **Scout #7 (queen graph defeats every known Node-Kayles FPT parameter) is under-ranked.**
  Verified: Hanaka–Ono–Yoshiwatari, "Colored Node Kayles" **[V]** (PSPACE-complete on planar
  max-deg-3; **W[1]-hard in the number of turns**; FPT by vertex cover / neighborhood
  diversity / twin cover); Kobayashi's structural-parameterization line **[V-search]**. Q_n
  simultaneously blows up treewidth (n-clique rows), vertex cover (n²−n), and modular width
  (our own `module_profile` measured the tail module-free) — a one-paragraph
  theory-matches-experiment story that upgrades a measured solver negative into a citable
  positive. Costs a paragraph; feeds the "why is this hard / why transposition+ordering"
  section directly.
- Scout #11 (defect line) is **over-ranked as "highest-value framing import"**: with the
  bulk transition verified absent, no named surface universality class applies; keep one
  paragraph of vocabulary ("non-critical boundary term"), run no fits before G(18)/torus data
  extend.

---

## 3. Two-way transfer designs (top 3, end-to-end)

### 3.1 T1 — OEIS + certified nimbers (merges scout #1, #4, #9) — DO FIRST

- **Inputs in hand**: G(14)=0, G(15)=1, G(16)=0 (multi-config validated); the heap-sum
  engine + repo; G(17) in flight; the Lean `NodeKayles` layer.
- **Step 1 (hours, no box)**: submit the A344227 extension (terms + b-file + program link +
  a comment that the even→0 conjecture fails at n=18 at the *outcome* level, G(18) ≠ 0 —
  legitimate as a comment even with the value pending). This is the priority stamp for the
  entire program and independent of the paper's timeline. If G(17) lands first, include it.
- **Step 2 (stage-1 absorption)**: the "first verified impartial-game nimber table" framing
  **does not change stage-1's scope** — Phases A–E stand as proposed. It sharpens the pitch
  and the venue stays ITP/CPP: the differentiators vs Pavlov/Takizawa (verified checker,
  iso-sharing via `win_iso`/`win_emb`, no-repetition domain, new-math payload) are exactly
  stage-1's existing design. Two additions: (a) cite CQD as the chess-side precedent for the
  local-check decomposition and state our leaf-recompute design as strictly less trusting;
  (b) plan the OEIS annotation upgrade ("terms machine-verified") as the Phase-E closer —
  an OEIS entry whose terms carry a kernel-checked certificate would itself be a first.
  **Keep QBF/DRAT out of stage 1** (different artifact, scope creep); note as stage-2 option.
- **Justifies follow-up if**: Phase-B proof-DAG sizing comes back ≤ ~10⁷ records at n=14
  (compiled-checker comfort zone) — then the ITP/CPP paper is low-risk.

### 3.2 T2 — Torus nimbers + strong complete mappings (scout #3)

- **Inputs in hand**: exact G(torus_n) n=1..10; Conjecture T1 (G = n mod 2 for n ≥ 4); the
  plane-in-torus embedding lemma (m ≥ 2n−1, PROVEN); the production canonicaliser.
- **Computation**: extend torus nimbers to n≈12–14 (vertex-transitivity quotients the root;
  heap-sum engine reuse; small relative to plane solves — needs engine plumbing for wrapped
  adjacency). Submit the sequence to OEIS (new entry; it does not exist per the targets
  survey). Optionally: count strong complete mappings at n=25 and diff against Bastide et
  al.'s exhaustive n=25 anchor as a correctness oracle before touching n=29,31.
- **Expected outcome**: T1 holding through n≈14 while the plane breaks at 18 = the paper's
  cleanest "the border is the whole story" exhibit, stated as two concrete sequences whose
  difference is the border. A T1 counterexample would be equally publishable (and would
  reshape the border theory).
- **Effort**: engine plumbing days + runs; the enumeration side only if the oracle diff is
  cheap. Follow-up justified if T1 survives n=12 (then push and write the companion note).

### 3.3 T3 — Reflecting-queens small-n closure (scout #2, demoted but still the best contact vehicle)

- **Inputs in hand**: none needed from the solver — Slater pairings are a tiny standalone
  search (pair 1..n with n+1..2n, all sums and differences distinct; CP/SAT or bitmask
  backtracking reaches well past the verified frontier in seconds-to-minutes per n).
- **Computation**: determine existence for every n in the published open gap (verify the
  exact frontier from the journal version first — the scout's "verified to n≈27" is
  unconfirmed **[R]**), and report first counts. Separately (data in hand): tabulate which
  ρ/reflection-symmetric openings our solver refutes at even n ≤ 16 and check refutation
  squares against the diagonal locus — the static-vs-strategic comparison table.
- **Expected outcome**: a short arXiv note that *closes a Forum Math Sigma paper's stated
  finite gap* — the right artifact to open a conversation with Kelly. Effort: days.
- **Justifies follow-up if**: the strategic obstruction data visibly aligns (or clashes)
  with the static locus — either way a section of the note.

---

## 4. Demoted bridges (scout entries that do not survive scrutiny)

| scout # | connection                          | verdict + reason                                                                 |
|---------|-------------------------------------|----------------------------------------------------------------------------------|
| #2      | reflecting queens as "near-twin"    | DEMOTED to cousin (kept as T3): static ≠ strategic; the reflection lemma is classical (§2.1) |
| #6      | Grundy-as-ML-target / NAR benchmark | PARK post-publication: real gap, but a dataset-paper program orthogonal to ours; zero feed into the paper |
| #11     | defect-line / surface criticality   | DEMOTED to vocabulary-only: no bulk transition ⇒ no named class; one framing paragraph, no fits yet |
| #13     | RL curricula with exact oracle      | PARK with #6 — same program, same reason                                          |
| #14     | Costas / DDC codes                  | DROP as bridge: the only fresh item is an *unstudied* Maker-Breaker Costas game — a proposal, not a connection; DDC import speculative |
| #17     | LOCAL MIS round complexity          | DROP as work item: scout's own caveat (construction ≠ game value) is fatal; keep as a question to pose if a LOCAL theorist ever asks |
| #18     | online IS / independent kissing no. | DROP: objective mismatch (max cardinality vs win parity); ζ(Q_n) is a curiosity   |
| #19     | Burnside divisibility               | DROP (scout already low): full-board counts, not game values                      |

Kept-but-parked (not demoted, not top-3): #7 and #9 fold into the paper as related-work
paragraphs (§1.6); #8 (backbone/completion — cite Glock et al. + Nielsen's June 2026 upper
bound when discussing the tail); #10 (independence-polynomial roots — cheap companion compute
once an i_k emitter exists); #12 (proof-number floor — needs theory, revisit when someone
asks "how small can the certificate get"); #15/#16 (spectra, domination game — opportunistic).

---

## 5. The integrated program

### 5.1 Feeds the main paper NOW (related-work additions, concrete)

1. **Complexity frame** (cite Schaefer 1978; Burke–Ferland–Teng arXiv:2109.05622 / TCS):
   "Deciding Node-Kayles outcomes is PSPACE-complete in general, and computing nimbers is
   harder in kind: nimber-preserving reductions strictly refine winnability-preserving ones,
   and Generalized Geography is complete for polynomially-short impartial rulesets under
   them. Our results instantiate the gap: the n=18 *outcome* fell before the n=18 *nimber*."
2. **Periodicity context** (cite Wong et al. JIS 2020; Songsuwan arXiv:2512.24221; Guy's
   conjecture): "Grundy sequences of Node-Kayles families are known to be eventually periodic
   on sparse structured families; the queen family is a dense, module-free test case where
   the analogous question is open, and our extension supplies the terms the question needs."
3. **Parameter-map paragraph** (cite Kobayashi arXiv:2003.11775; Hanaka–Ono–Yoshiwatari):
   Q_n simultaneously defeats treewidth, vertex cover, and modular-width/neighborhood
   diversity — matching our measured module statistics — so the solver's reliance on
   transposition + ordering rather than structural decomposition is forced, and W[1]-hardness
   in turns says depth-parameterization cannot rescue it.
4. **Physics adjacency** (cite Liu–Liao–Wang arXiv:2605.10326; Simkin): "The same object
   viewed as a long-range hard-core lattice gas shows no bulk thermodynamic transition; this
   is consistent with, and complementary to, our finding that the torus game collapses to a
   parity law while all n-dependent difficulty concentrates at the border." Optional garnish:
   rooks = dimers on K_{n,n} (free-fermion) vs queens as the first interacting layer.
5. **Symmetric-solutions adjacency** (cite Klarner; Dai–Kelly, Forum Math Sigma): "The static
   analogue of our obstruction — no n-queens solution is fixed by any reflection — is
   classical; recent work on reflecting configurations (Slater pairings) shows the diagonal
   sum/difference structure remains an active existence frontier. Our Mirror-Obstruction
   Lemma is the strategic counterpart: the obstruction moves from configurations to pairing
   strategies, and localizes on the two long diagonals."
6. **Certificate pointer** (cite Pavlov arXiv:2604.07907; Takizawa arXiv:2411.01029; Shaik
   et al. SAT 2023): one future-work sentence pointing at the stage-1 companion.

### 5.2 Companion papers (with venue)

| artifact                                             | venue                       | gate                       |
|------------------------------------------------------|-----------------------------|-----------------------------|
| Certified nimbers (stage 1)                          | ITP or CPP                  | Phase-B sizing probe        |
| Torus nimbers + parity law + OEIS sequence           | JIS or INTEGERS             | T1 survives n=12 (T2)       |
| Reflecting-queens small-n closure + counts           | short arXiv note → Discrete Math letter | frontier check (T3) |
| Backbone / completion / jamming map                  | later, with #8's probe      | post-G(18), engine time     |

### 5.3 Waits for G(18) / n=20

Lattice-gas boundary-term quantification (torus-vs-board free energy); defect-line fits;
C1 (G ∈ {0,1}) resolution; the n=20 campaign per the winning-geometry note. Nothing in this
note argues for firing a run.

### 5.4 Drops

ML/NAR + RL curricula (parked post-publication), LOCAL, online-IS, Costas game, Burnside
(§4).

### 5.5 Contact / announcement timing (trade-offs framed; the user decides)

- **OEIS (now)**: cheapest, highest-value priority stamp; independent of paper timing;
  submitting *before* the paper risks nothing (the entry cites our computation) and
  establishes date-stamped priority on the exact object a competitor would touch first.
- **Kelly (after T3's note is drafted)**: contact with an artifact ("we closed your finite
  gap; here are counts + the strategic-obstruction comparison") converts a cold email into a
  collaboration seed. Contacting before the note exists spends the novelty without the
  artifact. No scooping pressure forces earlier contact.
- **Wang/Liu group (only after our preprint is public)**: they are the one contact with the
  toolchain to independently develop the border-free-energy story; the preprint should carry
  our border-defect claims first (§2.2). After that, they are the natural physics-side
  collaborators/amplifiers.
- **Pavlov / Heule / Seidl (after stage-1 Phase C exists)**: the verified-checker crowd
  responds to running artifacts; Phase A–C is box-light and can proceed during G(18) rounds.
- **General principle that falls out of §2**: nothing external threatens the game-layer
  results; the two clocks are (i) the certificate venue race (content safe, "first" claim
  at stake) and (ii) the stat-mech border story (framing at stake). Both are fully hedged by
  "OEIS now, arXiv preprint next, contacts after."
