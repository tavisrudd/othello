# Stepping-stone deliverables: publishable results on the way to the odd-plane theorem

Date: 2026-07-09. Author: Fable. Status: proposal (for the user's go/no-go on sequencing).

## Thesis

The uniform odd-plane theorem (`PG(2,q)` is P for every odd `q`) is the prize, but my calibration
puts *this program landing it* at ~20–25% on any near horizon. The rest of the value should not be
hostage to that. Almost everything already proven, and several results one clean step away, are
independently publishable — and in the ~75% of worlds where the uniform theorem stays open, these
are exactly the first sections of the eventual big paper anyway. This note lists the bankable
sub-goals, their odds, the publishable claim in each, and — the point of writing it down — the
framing hook and research connections that make each one *land* with a reader instead of reading as
a niche puzzle.

Companion critique of the current frontier: [`2026-07-09-fable-line-capacity-review.md`](2026-07-09-fable-line-capacity-review.md).
Program map: [`handoffs/2026-07-06-projective-cap-game-handoff.md`](handoffs/2026-07-06-projective-cap-game-handoff.md).

## Why the cluster is interesting (the umbrella framing)

Two meta-hooks worth stating once, up front, and reusing in every abstract:

1. **This is the game-theoretic cousin of the cap-set problem.** Caps — point sets with no three
   collinear — are the objects of one of the most celebrated recent lines in combinatorics: the
   Croot–Lev–Pach / Ellenberg–Gijswijt polynomial-method collapse of the max cap size in
   `AG(n,3)` (2016). We study a *different question about the same objects*: not "how large can a
   cap be" but "who wins the impartial game of building one." Almost no one has computed **exact
   outcome classes for infinite geometric families** — the Nofil/Node-Kayles literature is mostly
   single small instances plus PSPACE-completeness (Schaefer 1978). Getting a full outcome
   classification for infinite families, driven by *algebraic* involutions, is the unusual thing,
   and it is the selling point.

2. **One umbrella unifies non-attacking queens and cap games: line-capacity avoidance.** Points +
   distinguished line families + capacities `|S ∩ L| ≤ c(L)`. Queens is the capacity-1,
   four-direction affine-grid case (= Node-Kayles on the queen graph); affine/projective cap is
   the capacity-2, all-line case (= Nofil on the collinearity-triple hypergraph). This is a
   *structured finite-incidence subfamily* of Sieben-style hypergraph building-avoidance — not a
   new game class (see the novelty guard below) — but it is the right lens: reservoir/slack
   counting, mirror-chord obstructions, and the capacity-1 conflict-graph collapse all transfer
   across the family. The one clean new abstract mechanism (per the C27 correction) is the
   capacity-independent slack-1 mirror obstruction.

Positioned this way the work sits at an unusual four-way crossroads — **combinatorial game theory
× finite geometry × additive combinatorics × formal verification** — and each deliverable below
can be pitched to whichever of those audiences it most naturally serves.

## Deliverables

| ID | Deliverable                                             | Odds | Standalone? | On critical path? |
|----|---------------------------------------------------------|------|-------------|-------------------|
| D1 | Outcome classes of Nofil/cap on finite geometries       | ~80% | yes (flag)  | umbrella          |
| D2 | Corrected pairing/mirror principle (capacity ≥ 2)       | ~85% | note/section| yes (infra)       |
| D3 | Conic-localization reduction theorem                    | ~65% | yes         | yes (scaffold)    |
| D4 | Machine-verified per-`q` ladder + Lean formalization    | ~75% | yes         | evidence/backbone |
| D5 | Sum-free achievement game on abelian groups             | ~65% | yes (sibling)| feeds D1 (q=2)   |
| D6 | Extended non-attacking-queens nimber sequence           | ~70% | yes (sibling)| orthogonal        |

### D1 — Outcome classes of the Nofil / cap achievement game on finite geometries (~80%)

**Claim (all proven).** `AG(n,q)` is P for all finite affine spaces; `PG(n,2)` is P for all
`n ≥ 1`; `PG(2m−1,q)` is P for all odd `q`; `PG(2,q)` is P for all even `q`. The odd-plane case is
a conjecture backed by the computed ladder (P through `q = 23`).

**Caveats (2026-07-09 second pass).** (i) The open set is larger than the odd-plane row:
`PG(2m,q)`, `m ≥ 2`, odd `q` is open with *no direct outcome evidence at all* — C32 was a policy
probe, not a solve; C43 sizes PG(4,3). D1 must state that hole plainly, not silently scope to
planes. (ii) The "conjecture false ⟺ trapped size-3" framing is one-directional until C41
certifies the converse — cite it as queued, not proven.

**Publishable unit.** One coherent outcome-classification paper. The C26 audit already fixed the
novelty wording: HHS own the Nofil ruleset and STS prior art; the *new* content is the
projective-family outcome theorems in the impartial shared game, via standard involution/pairing
ingredients. Venue: INTEGERS (the CGT home), or *Electronic J. Combin.* / *Discrete Math.*

**Framing hook & connections.**
- **Conic uniqueness, not Segre, is the localization step.** The whole odd-plane reduction leans
  on the elementary finite-geometry fact that a five-arc determines a unique conic.  Segre's oval
  theorem is adjacent background for odd-order planes, but it is not what performs this
  localization step.  Do not sell the proof mechanism as "powered by Segre" unless a later
  argument truly uses the oval-is-conic theorem.
- **Legal complexes / strong placement games are the right CGT frame.** The legal positions form
  an impartial strong placement game legal complex; residual positions should be described using
  the link language from Faridi--Huntemann--Nowakowski, *Simplicial Complexes are Game Complexes*
  (EJC 2019), and Huntemann, *Game Values of Strong Placement Games* (arXiv:1908.10182). This is
  more precise than treating the game only as generic hypergraph avoidance.
- **Cap-set cousin** (meta-hook 1): position `AG(n,3)` P as "the game whose board is the cap-set
  problem's board." That single sentence buys the additive-combinatorics reader.
- **The even/odd split mirrors a genuine geometric dichotomy.** `PG(2,q)` even is P by a
  characteristic-2 translation mirror; the odd case resists precisely because odd planes have no
  fixed-point-free collineation involution on an odd number of points — the same parity wall that
  makes odd-order projective planes structurally different (hyperovals exist only in even
  characteristic, etc.). The outcome-class boundary is not arbitrary; it tracks a real
  characteristic-2-vs-odd divide. Worth stating as the paper's organizing tension.
- **Harary/Beck positioning:** name it against the achievement-game tradition (Harary; Beck,
  *Tic-Tac-Toe Theory*) but flag the difference — those are partizan Maker-Breaker; ours is
  impartial normal-play building-avoidance, so Sprague–Grundy, not Beck's potential method,
  governs it.

### D2 — The corrected pairing/mirror principle for capacity-≥2 avoidance games (~85%)

**Claim (proven, Lean-checked).** The naïve symmetry-strategy principle — "legal ⇒ σ-image legal,
σ fixed-point-free ⇒ P" — is *false* for cap/Nofil: the mirror chord `x·σx` can hit selected
structure. The correct condition is the two-move pair-extension `S ∪ {x, σx}` valid, and the
obstruction is capacity-independent: among legal `x`, the joint reply fails *exactly* on
mirror-chord lines of residual slack 1.

**Publishable unit.** Highest odds of the set; lower standalone weight. Best as a methods section
of D1 or a short companion note ("A cautionary lemma on symmetry strategies in incidence-avoidance
games").

**Framing hook & connections.**
- **Symmetry/pairing strategies are foundational and this is a clean trap in them.** Mirror
  strategies (Cram, Domineering, the classical "imitate across the center") and Hales–Jewett
  pairing are textbook. The community will recognize the shape "symmetry strategy" and be
  interested that it acquires a *side condition* once moves have to preserve an incidence
  constraint. The slack-1 characterization is the reusable takeaway.
- **Directly reusable in formalization** (ties to D4): anyone mechanizing a pairing argument for a
  building-avoidance game needs exactly this correction, so it has value beyond our game.

### D3 — The conic-localization reduction theorem (~65%)

**Claim.** After frame reduction the odd-plane game becomes a residual `q×q` grid game; localizing
to the unique conic through the residual 5-arc, each off-conic intruder contributes one Möbius
involution matching on the live conic, and conic-restricted play is Node-Kayles on the resulting
union graph.  At the first S4 response layer there are at most two such intruders, so that layer is
a disjoint union of paths, cycles, and isolated vertices.  Deeper maintenance layers have `k`
intruders and maximum degree `k`; the path/cycle description is not the recursive invariant.
Supporting exact fact: every size-3 residual position has exactly `q² − 9q + 21` legal size-4
extensions.

**Publishable unit.** A structural-reduction paper, *independent of the final outcome*. This is the
highest-value "on the way" unit because it is the scaffold the uniform proof would stand on, and it
reframes the conjecture from mystery to *tractable*.

**Framing hook & connections.**
- **The first response layer contains Dawson's chess.** Node-Kayles on a path is exactly Dawson's
  chess (octal game `0.137`), whose nim-sequence is the classical eventually-periodic A002187
  (Guy). Thus the two-intruder layer of the odd-plane cap game, localized to the conic, is a
  disjoint sum of Dawson paths and Node-Kayles cycles.  That is a useful structural foothold and
  explains the current zero-XOR data, but once a third intruder is present the graph can have
  degree three and Dawson/path-cycle XOR no longer describes the recursive state.
- **The involutions are Möbius involutions of `P¹(F_q)`.** Each off-conic intruder induces an
  order-2 element of `PGL(2,q)` acting on the conic parameter line. This ties the game's dynamics
  to the sharply-3-transitive action of `PGL(2,q)` and cross-ratio invariants — the
  order-of-`σσ'` census (C29's `3 | q±1` split-vs-elliptic dichotomy) is literally the
  representation-theoretic content surfacing in the game values. Good hook for the group-theory /
  finite-geometry reader.  Hollmann--Xiang's conic-stabilizer association schemes are relevant
  published machinery to test for the orbital/cross-ratio relations and intersection numbers.
- **"Localization" is a familiar move** in finite geometry (reduce a plane problem to a
  conic/quadric); framing our reduction as a *game-theoretic* localization makes it feel native to
  that field.
- **Node-Kayles is PSPACE-complete in general** (Schaefer 1978) — so exhibiting a natural family
  whose first response layer collapses to tractable, classically-solved graph classes
  (paths/cycles), while deeper layers become bounded-degree unions of Möbius matchings, is the
  interesting tension: the geometry buys structure, but not a permanent path/cycle reduction.

### D4 — Machine-verified per-`q` ladder + Lean formalization (~75%)

**Claim.** `PG(2,q)` is P for `q ≤ 19` (or 23), with the small cases (`q = 5,7,11,13`) closed by
Lean theorems with clean axiom profiles (`propext, Classical.choice, Quot.sound`), and the larger
`q` via reflected certificate checkers.

**Publishable unit.** A "computer-verified results + formalization method" paper, and the strongest
*evidence* artifact under D1's conjecture. Venue: a formal-methods track (ITP/CPP-flavored) or a
formalization section of D1.

**Framing hook & connections.**
- **CGT formalization is a live Mathlib frontier.** Mathlib already has Conway/`PGame`, surreal
  numbers, `Nim`, and the Sprague–Grundy theorem. Formalizing *concrete impartial games on
  geometric hypergraphs* and their exact outcomes is a natural, currently-unoccupied extension —
  the paper can be pitched as "bringing finite geometry into Mathlib's game library."
- **Proof-by-reflection lineage.** The reflected-Bool-checker + soundness + `by decide` route
  (deliberately no `native_decide`, keeping the kernel-trusted axiom profile) is the same
  discipline behind the big computer-assisted proofs — the cap-set bounds, Keller's conjecture and
  Schur number 5 (SAT), the Erdős discrepancy problem. Positioning our certificates in that
  tradition — "a fully kernel-checked game-value certificate format" — makes the verification
  contribution legible and raises its trust bar above the typical unverified game solver.

### D5 — The sum-free achievement game on abelian groups (~65%)

**Claim.** Outcome results for the impartial game of building a sum-free set in a finite abelian
group: the `Z_n` mirror analysis (with the corrected Lemma 4), and the monotone-resource law
`Z_3^r × Z_p` is N iff `r = 1`, plus the group families that fall out.

**Publishable unit.** A self-contained additive-combinatorics-flavored CGT paper, and literally the
`q = 2` column of D1 (binary projective caps ↔ sum-free sets over `(Z_2)^n`). Conditional on the C1
correction being fully validated and enough of the `r`-induction closing; partial results
(the `r = 1` characterization, specific families) are publishable now.

**Framing hook & connections.**
- **Sum-free sets are a marquee additive-combinatorics object.** The counting question (Cameron–
  Erdős conjecture, proven by Green and by Sapozhenko) and the structure question (Green–Ruzsa
  classification in abelian groups) are canonical. The *game* on sum-free sets is an untouched
  achievement-game cousin — the same "extremal object, now play a game on it" framing as the
  cap-set hook in D1, which makes D1 and D5 read as one program.
- **Schur / Rado lineage.** Sum-free = avoiding the monochromatic Schur equation `x + y = z`;
  Schur number 5 was settled by SAT (Heule 2017). Pitching the sum-free *game* alongside the
  Schur-number computations gives the reader a familiar anchor and reinforces the
  computer-verification thread of D4.
- **Unifying value:** because `PG(n,2)` reduces to sum-free over `(Z_2)^n`, D5 is not a side quest —
  it is the mechanism behind one whole column of D1, and saying so ties the two papers together.

### D6 — Extended non-attacking-queens nimber sequence (~70%)

**Claim.** Exact nimbers (not just P/N outcomes) for the non-attacking-queens Node-Kayles game
past the current published horizon (OEIS A344227 gives nimbers to `n = 13`).

**Publishable unit.** A short data/OEIS contribution, independent of the cap program — the kind of
result that ships regardless of the odd-plane theorem. Uses the fast queens solver (currently the
dormant lane).

**Framing hook & connections.**
- **The capacity-1 anchor of the umbrella.** D6 makes the line-capacity framing concrete: it is the
  same theory as the cap game with `c = 1`, so publishing extended queens nimbers gives the
  umbrella an independent empirical leg and a citation back to D1's framework section.
- **Adjacent to a famous problem.** The *counting* of n-queens configurations was a headline result
  recently (Simkin 2021, `~(0.143 n)^n`); the *game* on the same board is a natural companion
  question that shares none of the counting machinery — a clean "same board, different question"
  pitch.
- **Tests octal-style periodicity.** Extending exact nimbers is exactly how one probes eventual
  periodicity (Guy's conjecture that all finite octal games are eventually periodic). Even a
  negative — nimbers that stubbornly refuse a period — is a reportable datum about a family whose
  Grundy theory is unknown.

## Stepping-stone dependency graph

```text
                 D2 (mirror infra) ─────────────┐
                                                 ▼
D5 (sum-free, q=2) ──► D1 (outcome classes) ◄── D3 (conic reduction) ──► [uniform odd-plane theorem]
                          ▲                                                     ▲
D4 (verified ladder) ─────┘  (evidence + verification backbone)  ───────────────┘

D6 (queens nimbers) ──► line-capacity umbrella section of D1  (capacity-1 anchor)
```

- **D1 is the umbrella** every other piece cites. Ship it first to plant the flag and fix the
  vocabulary.
- **D3 is the scaffold** for the eventual theorem; publishing it banks the reduction and turns the
  conjecture into a tractable one — the second thing to drive.
- **D4** underwrites D1's conjecture and is the verification story for both D1 and D5.
- **D2** is proof infrastructure for D1 and the uniform proof; cheapest to land.
- **D5** is the `q=2` sibling and can proceed in parallel (it is already a live lane).
- **D6** is orthogonal and can run whenever the queens box is free.

## Recommended commit order

1. **D1** — assemble the outcome-classes manuscript skeleton from the existing Lean theorems and
   notes (highest banked value, lowest new risk; plants the flag).
2. **D3** — write the conic-localization reduction as a standalone result (highest "on the way"
   value; reframes the conjecture).
3. **D4** — package the verified ladder as D1's evidence/verification backbone (rides along).
4. **D2, D5, D6** — opportunistic: D2 folds into D1 as a section; D5 advances on its own lane; D6
   whenever the queens box is idle.

## Novelty guards (carry into every abstract)

- Do **not** claim a new general class of impartial games. Claim a structured finite-incidence
  subfamily of known hypergraph building-avoidance / legal-complex frameworks.
- Nofil, impartial strong placement games and legal complexes, Node-Kayles, pairing strategies,
  Möbius/elliptic involutions, Segre's theorem, and the cap-set objects are all prior art — the
  new content is the *outcome theorems* for these infinite geometric families and the slack-1
  mirror obstruction that ties the capacity-1 (queens) and capacity-2 (cap) mechanisms together.
- Colored finite-geometry tic-tac-toe / avoidance (Clark–Mancini–Van Hook) is adjacent but a
  different (partizan) game — cite as adjacent, never as covering our impartial results.
- These are **normal-play** results. The misère versions (misère quotients, Plambeck–Siegel) are a
  separate and much harder question — flag this so no reader assumes it is claimed.

## Pointers

- Novelty audit: [`2026-07-08-codex-projective-nofil-novelty-audit.md`](2026-07-08-codex-projective-nofil-novelty-audit.md)
- Nofil connection: [`2026-07-07-nofil-connection.md`](2026-07-07-nofil-connection.md)
- Frontier critique + redirect: [`2026-07-09-fable-line-capacity-review.md`](2026-07-09-fable-line-capacity-review.md)
- Program map + Lean theorem names: [`handoffs/2026-07-06-projective-cap-game-handoff.md`](handoffs/2026-07-06-projective-cap-game-handoff.md)

— Fable
