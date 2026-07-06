# Proof tactics for the sum-free game on `Z3^r × Z_p` — a literature scout

**Date:** 2026-07-06. A focused web literature search for *proof techniques* (not just related
games) that could settle the open kernel of the sum-free achievement game:

> **Open kernel.** `G = Z3^r × Z_p`, `r ≥ 2`, `p` an odd prime `> 3` (so 2-rank `s₂=0`, 3-rank
> `r₃=r≥2`). Conjecture/data: `Z3²×Z_p = P` for `p≥7`, `= N` at `p=5`. The winning strategy is
> adaptive; every fixed global involution/pairing is closed; the game is a single connected component
> (no disjunctive-sum split); nimbers are non-periodic in `p`. The team's reduction: `𝒢(root) =
> mex{n_socle, n_coprime, n_mixed}`, so `P ⟺` each of 3 openings is an N-position `⟺` each opening
> has *some* P-reply (an **existential** 2-element P-lemma target — Lemmas A/B in the nimber-engine note).

This report catalogues techniques, cites primary sources, and assesses each against the five
established difficulties (D1 no fixed involution / O₃ coupling; D2 no disjunctive-sum split; D3 no
static monovariant + strategy-stealing invalid; D4 genuinely adaptive / non-periodic nimbers; D5 the
existential-P-reply reduction, where "uniform" replies keep being small-prime coincidences).

Bottom line up front: the search did **not** surface a ready-made theorem that closes the kernel.
It did surface one under-exploited *reframing* (the strictly-matched-involution relaxation, applied to
the **post-opening residual** rather than the whole board), a clean structural **analogy + induction
template** (Brandenburg's "square ⇒ 2nd player wins" on quotient games), and a concrete **certificate/
decision-procedure** direction for the adaptive route (Walnut/Büchi automatic proofs; invariant-game
closure). These are the three things worth actually trying.

---

## TOP TACTICS TO TRY (ranked)

### 1. Strictly-matched involution, applied to the RESIDUAL after the opening seeds (not to `∅`)

**Core idea.** Andres–Huggan–Mc Inerney–Nowakowski relax the fixed-point-**free** requirement of a
mirror strategy: a **strictly matched involution** `σ` of a graph is an order-2 automorphism whose
fixed set `F₁` *induces a clique* and whose every non-fixed `v` satisfies `vσ(v) ∈ E`
([TCS 2019](https://doi.org/10.1016/j.tcs.2019.07.014); characterization in
[Algorithmica 2022 / PMC10060359](https://pmc.ncbi.nlm.nih.gov/articles/PMC10060359/)). Under it the
second player mirrors on the matched pairs and the clique of fixed points is *self-limiting* (at most
one clique vertex ever matters), forcing a draw. The transferable content: **you do not need a
fixed-point-free involution — you need one whose fixed set is a self-blocking "core" that the strategy
can absorb.**

**How we'd apply it to `Z3²×Z_p`.** Every global-involution route the team closed attacked `∅`. But the
reduction only requires each **opening** `{s}` to be an N-position — i.e. a winning responder strategy
on the *residual after one (or two) seeds*. Re-run the mirror search on that residual, in the *enlarged*
class the strictly-matched theorem licenses: **drop fixed-point-freeness; instead demand the fixed/defect
set be a self-blocking clique** (in the Schur hypergraph, a set no two of whose elements can coexist in a
sum-free set — so at most one is ever played, and the seed already spent it). Concretely: after the socle
seed `s=(0,1,0)` (order 3, which kills the O₃ pair `{s,2s}`) and the mixed seed `t`, look for an affine
reflection `σ(x)=c−x` whose *only* non-mirrorable points are an O₃-clique already neutralized by `{s,t}`.
This is exactly the `F₃ⁿ` move-then-mirror (`σ(y)=−o−y`) and the `Z₂×F₃ᵇ` `k=m+p` mirror the team
already proved — **generalized to a residual with a small handled core** instead of a globally clean
mirror.

**Biggest risk.** The reflection `σ_c(x)=c−x` is only sum-clean on pure `F₃ᵏ` (char-3 kills the `2y=w`
sub-case); off the socle line, in the `Z_p` direction, it breaks — the exact wall that killed `σ_c` and
the `ρ` partial mirror (partial mirrors lose the `A=−A` link, per the abelian note). So the real
danger is that "residual + clique-core" collapses back to the same char-3 barrier **unless** the fixed
set really is confinable to the (now-neutralized) O₃ core and the `Z_p` part is handled by genuine
negation (fpf on the coprime part). The team has tested affine fpf involutions *fixing the seeds* (found
none — seeds generate `G`); the **untested relaxation** is affine involutions *with* a self-blocking
fixed clique. That gap is the concrete new experiment.

**Verdict vs difficulties.** Directly targets D1 (the fixed-involution wall) by weakening what "pairing"
means; lives on the residual so it sidesteps the D1-for-`∅` closure; compatible with D5 (existential
per-opening). Does not by itself beat D4 (may still need adaptivity where the core is not a clean clique).

---

### 2. Induction on the 3-rank `r` via the uniform orbit reduction ("socle-opening canary")

**Core idea.** The nimber-engine note proves the reduction is **uniform in `r`**: for every `r≥1`,
`Aut(Z3^r×Z_p)=GL(r,3)×Z_p^*` has exactly 3 orbits (socle/coprime/mixed), so
`𝒢(Z3^r×Z_p)=mex{n_soc,n_cop,n_mix}`, and the whole outcome question is *"is the socle opening `∗0`?"*.
Data: at `r=1` the socle opening is `∗0` for every `p` (⇒ always N); at `r=2,p≥7` it jumps to `∗2` (⇒
root flips to P). This is the shape of an induction: **adding an `F₃` factor gives the responder one more
independent O₃ pair to exploit, pushing the socle opening off `∗0`.** The template for "game outcome via
induction on a group filtration" is standard in the algebraic-game literature — Brandenburg's quotient
game (Tactic 4) and the Frattini-quotient reduction of the Anderson–Harary generating games
([Benesh–Ernst–Sieben, arXiv:1407.0784](https://arxiv.org/abs/1407.0784)) both reduce a group game to a
smaller group by an inductive/quotient step.

**How we'd apply it.** Prove `n_socle(Z3^r×Z_p) ≠ 0` for `r ≥ 2` by induction on `r`, base `r=2`. The
inductive engine would be a responder strategy on the residual-after-socle-seed that "uses the extra
`F₃` coordinate" — e.g. embed `Z3^{r-1}×Z_p` as a subgroup/quotient and lift its (known-N) socle-opening
strategy, spending the new coordinate's O₃ pair to repair the one obstruction the lift creates. The prize
is that you never need the full `p`-uniform 2-element P-lemma directly — only the *monotone* statement
"more 3-rank keeps the socle opening N."

**Biggest risk.** D1's coupling barrier, verbatim: the abelian note's induction attempt (peel a factor)
"re-localizes to the same core rather than bypassing it" — lifting a strategy by a coordinate mirror hits
the identical `a+z=ρz` interference between obstruction-handling moves and the mirror. So the induction
*step* is where all the difficulty concentrates; it needs Tactic 1's residual-involution idea as its
engine, and may inherit its char-3 risk. Also the socle reduction across coprime factors is **false**
(`Z3²×Z7=P` vs socle `Z3²=N`), so the induction must be *within* the `Z3^r×Z_p` family, not across the
socle — keep `Z_p` fixed and vary `r` only.

---

### 3. Adaptive "safe class" as a closure-certified invariant (formalize Codex's route; back it with a decision procedure)

**Core idea.** When no pairing exists, the classical way to prove a family of P-positions is to **guess a
set `𝒮` of positions and prove it is closed under the strategy**: from every `A∈𝒮`, every opponent move
leaves a position from which the responder can return to `𝒮` (Wythoff-style invariant proofs). This is
exactly the "safe class `Safe(d,c)`" Codex is converging on in the colored-fiber model `Z_{3p}≅F_p×F_3`,
with recursion variable `(defect-count, pair-count)`. Two literature supports: **invariant games**
(Duchêne–Rigo framework; Larsson et al., "Invariant and dual subtraction games,"
[arXiv:1005.4162](https://arxiv.org/abs/1005.4162)) give the template "the P-positions are the set closed
under a described reply"; and **automatic proofs in CGT** (Mignoty–Renard–Rigo–Whiteland, IJGT 54 (2025)
#35, [doi:10.1007/s00182-025-00953-3](https://doi.org/10.1007/s00182-025-00953-3)), which turns a
first-order description of P-positions into a Büchi/Walnut automaton and *verifies it mechanically* for a
whole parameterized family, and even confirms "moves that don't change the P-positions" conjectures.

**How we'd apply it.** (a) State the safe class in the colored-fiber coordinates as a first-order /
recursive predicate on `(F_p → F_3)` partial colorings with the `(defect,pair)` invariant; prove the
closure lemma symbolically (each Alice move → a safe reply), which is a finite case analysis in the
*fiber colors* (`F_3`) even though `p` is unbounded. (b) Discharge the base layer and the finite
exception residue (Codex's 201-entry book) with a **certificate checker** — this is the one place the
automatic-proof machinery is a real fit: a machine-verified finite book + a hand-proved closure lemma is
a complete proof.

**Biggest risk.** The parameter is a **prime** `p` and the board size `9p` grows with it, so Walnut's
fixed-automaton-over-a-numeration-system does **not** directly encode the family (primality and the
`F_p^*` multiplier action are not automaton-uniform). So the *closure lemma itself* must be proved by hand
in the fiber model — precisely the open core — and the tool only certifies base cases and the book. Also
D3/Finding-3: no *static* signature separates `∗1`, so the invariant must be a genuine mex/recursion
witness, and Codex's data shows `(defect,pair)` is necessary but "not the whole state descriptor" — the
safe predicate likely needs one more coordinate before closure holds.

---

### 4. (Lower-confidence, worth a napkin) The "square ⇒ second player wins" structural analogy

**Core idea.** Brandenburg's impartial game on abelian groups (pick nonzero `a`, pass to `A/⟨a⟩`) has a
clean theorem: **the second player wins iff `A ≅ B × B` is a square**, via a diagonal mirror across the
two `B` factors (IJGT 47(2):417–450, 2018; [arXiv:1205.2884](https://arxiv.org/abs/1205.2884)). Our own
proven `s₂≥2 ⟹ P` is a "square in the 2-part" phenomenon, and `Z3²=F₃×F₃` is a *square in the 3-part*.

**How we'd apply it.** Test whether the **coordinate-swap diagonal** `(x,y)↦(y,x)` on `F₃²` (an
involution whose fixed set is the diagonal `x=y`), combined with an adaptive `Z_p` handler, gives a
responder strategy after an opening — i.e. treat `F₃²` as `B×B` and mirror across factors instead of
negating. The diagonal fixed set is a candidate "self-blocking core" for Tactic 1.

**Biggest risk.** The swap is inside `GL(2,3)`, so it is very likely already inside the team's "all affine
`GL(2,3)×Aut(Z_p)` involutions" sweep (which failed / had defects) — check the logs before investing. And
Brandenburg's game is the **quotient game**, a different move structure; the square-mirror there relies on
quotient moves, not on sum-free legality, so the analogy may not transport. Treat as a 30-minute sanity
check that either revives the diagonal or is quickly closed.

---

## BODY — technique-by-technique catalogue

### A. Pairing-strategy generalizations (no fixed-point-free involution)

**A1. Strictly matched involution (Andres–Huggan–Mc Inerney–Nowakowski).** Def + mechanism as in Tactic 1.
Fixed set induces a clique; each non-fixed `v` has the matching edge `vσ(v)`; the structural
characterization (Algorithmica 2022) partitions `V` into a clique and a matching with local constraints
(`2K₂/C₄/K₄`, `K₁∪K₂/K₃`). Primary:
[TCS 795 (2019) 312–325](https://doi.org/10.1016/j.tcs.2019.07.014);
[Algorithmica open-access PMC10060359](https://pmc.ncbi.nlm.nih.gov/articles/PMC10060359/).
*Applicability:* the single most on-point relaxation for D1 — it is the precise abstract genus of "mirror
with a handled core." **Caveats that must be engaged:** (i) stated for the **scoring** orthogonal-colouring
game on a *pair* of isomorphic graphs, **not** normal-play last-move-wins Node-Kayles — the drawing
argument uses score parity, so the theorem does not transfer verbatim; we would be *porting the involution
condition*, re-proving the last-move-wins version ourselves (plausible: a self-blocking clique of fixed
vertices behaves like a single Nim-heap-of-1 the responder can time). (ii) it is a *graph* (2-uniform)
notion; our hyperedges are Schur triples (size 3) plus doubling pairs, so "matching edge `vσ(v)`" must be
reinterpreted as "`{v,σv}` co-blocked by a live third element." (iii) recognizing such an involution is
NP-complete in general — fine for a bespoke family, but no free existence guarantee. D1 is exactly the
failure mode: negation's fixed set is the socle `O₂∪O₃`, which is **not** a clique (several order-3
elements coexist in a sum-free set), so negation is not strictly-matched. The open bet is that a
*different* involution on the *post-seed residual* is.

**A2. Complete/partial pairings for positional (Maker–Breaker) hypergraph games.** A complete pairing =
pairwise-disjoint vertex pairs such that every edge contains a pair ⇒ Breaker (blocker) wins; for
almost-disjoint hypergraphs the pairing existence criterion `|∪G| ≥ 2|G|` is decidable in P (Kutz;
Krivelevich survey [ICM 2014 PDF](http://www.math.tau.ac.il/~krivelev/ICM14.pdf); Győrffy et al. pairing
work). *Applicability:* the "every hyperedge contains a matched pair" condition is exactly the mirror
condition, and "partial pairing + explicit core" is the Tactic-1 shape. But this is a **Breaker/blocker**
tool (prevent completion), whereas our normal-play game is last-to-move-wins on a *shared* set — the win
condition differs, so the theorems (thresholds, column condition) don't apply; only the *pairing
bookkeeping* transfers. D2/D5 compatible; not a decision tool for us.

**A3. Snort-style automorphism pairing.** [arXiv:2506.20669](https://arxiv.org/abs/2506.20669): fpf
involutive automorphism ⇒ second-player mirror; explicitly notes "involutions **with** fixed points create
asymmetries" needing defensive handling (parity of fixed points, sequencing). *Applicability:* corroborates
that fixed points are the whole problem and that they can sometimes be absorbed by move-sequencing — a
qualitative license for Tactic 1, but Snort is partizan (red/blue) and the results are game-specific; no
transportable theorem.

**A4. Beck, *Combinatorial Games: Tic-Tac-Toe Theory* (CUP 2008).** The canonical reference for pairing
strategies and the Erdős–Selfridge potential (Part B). *Applicability:* the pairing chapters are the
general theory behind A1–A2; the potential method is assessed in section B below. Cite as the umbrella;
not a specific lever.

### B. Potential functions / weight arguments / Erdős–Selfridge lineage

**B1. Erdős–Selfridge theorem and descendants.** Gives Breaker a *potential-driven* blocking strategy when
`∑ 2^{−|A|} < 1/2`; the engine of Beck's Part B. *Applicability:* **structurally the wrong win condition.**
Erdős–Selfridge is Maker–Breaker (one player wants a winning set, the other blocks); our game is
normal-play Node-Kayles where *both* build a common sum-free set and the last mover wins. The potential
bounds "can Breaker avoid a monochromatic solution," not "who makes the last move." No bridge. **However**,
the *idea* of a nonnegative potential the responder maintains (so a reply always exists) does have a
concrete analogue: Codex's `(defect-count, pair-count)` is exactly such a monovariant — see B2.

**B2. Invariant / monovariant P-position proofs.** The standard non-pairing method: prove `𝒮` is closed
under the reply (Tactic 3). Duchêne–Rigo invariant games and the Larsson et al. resolution
([arXiv:1005.4162](https://arxiv.org/abs/1005.4162)); the general "deciding game invariance"
([arXiv:1408.5274](https://arxiv.org/abs/1408.5274)). *Applicability:* this is the live route for D4 (the
adaptive strategy IS a closure argument). D3 caveat: the invariant cannot be a *static board signature*
(Finding 3 rules those out); it must be a recursion/mex witness. This is where the proof will actually
live if a pairing can't be found.

### C. Induction on group order / subgroup / quotient

**C1. Brandenburg, "Algebraic games."** Square ⇒ 2nd-player win via factor-diagonal mirror; nimbers of
2-generated groups; induction on the quotient tower. IJGT 47(2) 2018;
[arXiv:1205.2884](https://arxiv.org/abs/1205.2884). *Applicability:* Tactic 4 analogy + Tactic 2 induction
template. Different game (quotient moves, not sum-free legality); the value is the *pattern* "a square
factor yields a mirror," which matches both our proven `s₂≥2⟹P` and the `F₃²` structure — worth a
dedicated napkin.

**C2. Generating (Anderson–Harary) achievement/avoidance games — Frattini-quotient reduction.**
Benesh–Ernst–Sieben compute nim-numbers by reducing the game on `G` to the game on `G/Φ(G)` (the
Frattini quotient collapses the structure) and via "structure diagrams."
[arXiv:1407.0784](https://arxiv.org/abs/1407.0784),
[arXiv:1506.07105](https://arxiv.org/abs/1506.07105),
[symmetric/alternating: arXiv:1508.03419](https://arxiv.org/abs/1508.03419). *Applicability:* the archetype
of "reduce a group game to a canonical smaller group." **But the analogous socle reduction for our game is
FALSE** (`Z3²×Z7=P` vs socle `Z3²=N`), so a clean quotient morphism does not exist here (Codex verified the
projection `G→G/6G` is not a game morphism — it maps sum-free sets to non-sum-free ones). So cite as the
template *and* as the reason the naive version is dead; the surviving inductive route is Tactic 2 (within
`Z3^r×Z_p`, not across the socle).

**C3. Lal–Muskan–Kakkar, "Impartial games on two finite groups"
([arXiv:2605.24984](https://arxiv.org/abs/2605.24984)).** Uses induction on order + quotients + symmetry
for group games. *Applicability:* method-family relative; thin transportable content (different game), but
a current example of the induction-on-order style for algebraic games.

### D. Nimber/Grundy structure across families without periodicity

**D1. Octal-game aperiodicity, sparse-space, automatic sequences.** Guy's periodicity conjecture is open;
aperiodic Nim-sequences exist (i-Mark, [arXiv:1509.04199](https://arxiv.org/abs/1509.04199); aperiodic
subtraction games [arXiv:1407.2823](https://arxiv.org/abs/1407.2823)); the sparse-space phenomenon
(Nivasch). *Applicability:* reassurance that "non-periodic nimbers in `p`" (D4) is not fatal — **we only
need the outcome**, and the reduction (D5) turns that into finitely many existential P-lemmas, not the
whole nimber sequence. No direct tool.

**D2. Automatic proofs in CGT (Walnut/Büchi).** Mignoty–Renard–Rigo–Whiteland, IJGT 54 (2025) #35,
[doi:10.1007/s00182-025-00953-3](https://doi.org/10.1007/s00182-025-00953-3). Turns first-order
P-position statements into automata, verifies whole families, and can check "P-position-preserving moves."
*Applicability:* the certificate half of Tactic 3. **Caveat:** needs an automaton-recognizable numeration
system for the parameter; a growing board indexed by a *prime* `p` is not in scope, so it certifies base
cases + finite books, not the `p`-uniform closure lemma. Still the best "machine-checkable proof" hook.

**D3. Wong, "Nimber Sequences of Node-Kayles Games," J. Integer Seq. 23 (2024)
([PDF](https://cs.uwaterloo.ca/journals/JIS/VOL23/Wong/wong24.pdf)); "Node-Kayles on Trees"
[arXiv:2512.24221](https://arxiv.org/abs/2512.24221).** Compute Node-Kayles nimber sequences for graph
families; trees give *eventually periodic* sequences via recursive/transfer relations. *Applicability:*
framework kin (our game is Node-Kayles on the Schur hypergraph), and evidence that structured families
admit closed-form nimbers — but their tools (path/tree recursion, transfer relations) exploit a
*decomposable* graph structure our single-component Schur hypergraph (D2) lacks. Method doesn't transfer;
cite for framing + the non-periodicity contrast.

### E. Achievement/avoidance on hypergraphs & groups; algebraic-relation hyperedges

**E1. Sieben, "Impartial Hypergraph Games," EJC 30(2) (2023) #P2.13
([landing](https://www.combinatorics.org/ojs/index.php/eljc/article/view/v30i2p13)).** The exact
framework: our sum-free game is the **building/achievement game** on the Schur 3-uniform hypergraph
(building game ends once the selected set contains an edge; avoidance = ours, last legal move wins). Sieben
computes Grundy numbers via structure diagrams and disjunctive compounds but **does not instantiate the
Schur/sum-free hypergraph** — confirming novelty. *Applicability:* the definitional home + the disjunctive-
compound machinery (which we already use for the nimber engine), but no closed-form P-criterion.

**E2. Maker–Breaker Rado games.** Gaiser–Horn, "Rado games for equations with radicals," INTEGERS 24 (2024)
/ [arXiv:2309.09145](https://arxiv.org/abs/2309.09145); Bednarska-Bzdęga et al., Rado game on random
integers ([SIDMA](https://doi.org/10.1137/18M117488X)). Maker wins Rado games above a threshold when the
system meets Rado's column condition. *Applicability:* **cite-and-distinguish neighbor.** Sum-free = the
Schur equation `x+y=z`, so these are the closest "equation games" — but they are **Maker–Breaker** (biased,
threshold, achiever-vs-blocker), a different game from our impartial normal-play achievement game. The
column condition is a *structural* criterion for the equation, not a strategy for last-move-wins. No lever;
important for the prior-art section of any writeup.

**E3. Cap-set / SET games.** SET/anti-set/impartial-SET are *removal* games on `AG(n,3)` lines; the team's
own cap game (build a cap) is proven `P` for all `q` by the parity-mirror. *Applicability:* the cap game is
the sibling with the *same* char-3 move-then-mirror that works there and breaks off char-3 here — a useful
contrast that pinpoints why `Z_p` is the obstruction.

### F. Twisted / moving-center symmetry

**F1. Tweedledum–Tweedledee + played-center mirror.** Classic symmetry strategy; the "take the center
first, then mirror" pattern is used cleanly in Games on Triangulations (Aichholzer–Bremner–Demaine et al.,
[PDF](https://erikdemaine.org/papers/TriangulationGames_TCS/paper.pdf)). *Applicability:* this is precisely
the team's proven `F₃ⁿ` first-player strategy (open a center `o`, reply `σ(y)=−o−y`) and the `Z₂×F₃ᵇ`
`k=m+p` mirror. The open kernel needs the **responder** version on a residual (Tactic 1). Well-trodden by
the team; the new content is the strictly-matched relaxation of the fixed set, not the moving center per se.

### G. Misère / canonical-theory tools

**G1. Misère quotients / reduced canonical form.** Plambeck–Siegel
([arXiv:math/0609825](https://arxiv.org/abs/math/0609825)); misère structure
([arXiv:2012.08554](https://arxiv.org/abs/2012.08554)). *Applicability:* **dead end for us.** Our game is
**normal** play, where the canonical form of an impartial game is just its nimber (Sprague–Grundy) — there
is no further "reduced canonical form" simplification to extract, and misère quotients answer a question we
are not asking. Listed only to close it.

---

## PROBABLY-DEAD-END LIST (do not re-walk)

- **Erdős–Selfridge / Maker–Breaker potential functions (B1).** Wrong win condition (blocker-vs-achiever,
  not last-move-wins on a shared set). No bridge to normal-play Node-Kayles outcome.
- **Disjunctive-sum / Grundy decomposition at the child level (D2, and nimber-engine Finding 1).** The
  positions of interest are single connected armed-Schur components (`{p,e}` children are one component for
  `p≥11`); no XOR structure to exploit — measured, not assumed.
- **Naive socle / `G→G/6G` quotient morphism (C2).** The socle reduction is FALSE (`Z3²×Z7=P` ≠ socle
  `Z3²=N`); the projection is not a game morphism (sends sum-free sets to non-sum-free). Frattini-style
  quotient reduction of the generating games does not port.
- **Global fixed involutions / affine reflections fixing the seeds (D1).** Closed with witnesses: negation
  breaks at every O₃ pair; `σ_c` is char-3-only; the `ρ` partial mirror loses `A=−A`; no `Aut(G)`
  involution fixes a 2-element seed set (seeds generate `G` ⇒ stabilizer trivial). The *only* untested
  relaxation is dropping fpf in favor of a self-blocking clique core **on the residual** (Tactic 1) — that
  is the live crack, the fixed-global versions are dead.
- **Static board-signature monovariants, incl. `F₃`-color signatures (D3, Findings 3–4).** `∗1` is ~40% of
  positions and spans every static signature; the `F₃`-monochromatic idea is a small-`p` artifact. Any
  invariant must be a mex/recursion witness, not a board feature.
- **Strategy-stealing (D3).** Provably invalid here — monotonicity fails (adding a vertex *removes* future
  moves), and it would contradict the proven `Z_n` P-positions
  ([strategy-stealing is non-constructive, arXiv:1911.06907](https://arxiv.org/abs/1911.06907)). No
  first-player shortcut; bespoke strategies only.
- **Misère quotients / reduced canonical form (G1).** Normal play ⇒ nimber is already the canonical form.
- **Uniform closed-form P-reply formulas (D5).** Repeatedly verified-then-fails (AP-child `6−p`: `∗0` to
  `p=23`, `∗4` at `p=29`; the zero-sum-triple route: all-children-P at `p=7`, not at `p=11`). The reply is
  adaptive; do not chase a formula table — stress-test any candidate lemma past `p=7` (and past `p=23`)
  before writing it as a proof.
- **Walnut/Büchi automatic proof of the full family (D2/Tactic 3 caveat).** Board size `9p` grows with a
  *prime* `p`; not automaton-uniform. Use it for base cases + finite-book certification only, not the
  `p`-uniform closure lemma.

---

## KEY REFERENCES

- S. D. Andres, M. Huggan, F. Mc Inerney, R. J. Nowakowski, **"The orthogonal colouring game,"** *Theoret.
  Comput. Sci.* 795 (2019) 312–325. [doi:10.1016/j.tcs.2019.07.014](https://doi.org/10.1016/j.tcs.2019.07.014).
  (Strictly matched involution ⇒ 2nd player draws.)
- S. D. Andres, F. Dross, M. Huggan, F. Mc Inerney, R. J. Nowakowski, **"The Complexity of Two Colouring
  Games,"** *Algorithmica* (2022). [Springer](https://link.springer.com/article/10.1007/s00453-022-01069-w)
  / [open access PMC10060359](https://pmc.ncbi.nlm.nih.gov/articles/PMC10060359/). (Structural
  characterization of strictly matched involutions; NP-completeness of recognition.)
- N. Sieben, **"Impartial Hypergraph Games,"** *Electron. J. Combin.* 30(2) (2023) #P2.13.
  [combinatorics.org](https://www.combinatorics.org/ojs/index.php/eljc/article/view/v30i2p13). (Building/
  achievement/avoidance games on hypergraphs — the framework for the sum-free game.)
- M. Brandenburg, **"Algebraic games — playing with groups and rings,"** *Int. J. Game Theory* 47(2)
  (2018) 417–450. [arXiv:1205.2884](https://arxiv.org/abs/1205.2884). (2nd player wins iff the group is a
  square `B×B`; factor-diagonal mirror; nimbers via quotient induction.)
- B. J. Benesh, D. C. Ernst, N. Sieben, **"Impartial avoidance and achievement games for generating finite
  groups,"** [arXiv:1407.0784](https://arxiv.org/abs/1407.0784);
  **"Impartial avoidance games for generating finite groups,"**
  [arXiv:1506.07105](https://arxiv.org/abs/1506.07105). (Frattini-quotient reduction; structure diagrams.)
- R. Lal, Muskan, V. Kakkar, **"Impartial games on two finite groups,"**
  [arXiv:2605.24984](https://arxiv.org/abs/2605.24984). (Induction on order for group games.)
- J. Beck, **"Combinatorial Games: Tic-Tac-Toe Theory,"** Cambridge Univ. Press (2008). (Pairing strategies
  + Erdős–Selfridge potential method.)
- C. Gaiser, P. Horn, **"Maker–Breaker Rado games for equations with radicals,"** *INTEGERS* 24 (2024).
  [arXiv:2309.09145](https://arxiv.org/abs/2309.09145). (Equation games; Rado column condition — neighbor
  to distinguish.)
- B. Mignoty, A. Renard, M. Rigo, M. Whiteland, **"Automatic proofs in combinatorial game theory,"** *Int.
  J. Game Theory* 54 (2025) #35. [doi:10.1007/s00182-025-00953-3](https://doi.org/10.1007/s00182-025-00953-3).
  (Walnut/Büchi automata verify P-position characterizations for parameterized families.)
- U. Larsson, P. Hegarty, A. S. Fraenkel, **"Invariant and dual subtraction games resolving the
  Duchêne–Rigo conjecture,"** *Theoret. Comput. Sci.* (2011). [arXiv:1005.4162](https://arxiv.org/abs/1005.4162).
  (Invariant-game / closure framework for P-positions.)
- M. C. Wong, **"Nimber Sequences of Node-Kayles Games,"** *J. Integer Seq.* 23 (2024).
  [PDF](https://cs.uwaterloo.ca/journals/JIS/VOL23/Wong/wong24.pdf); **"Node-Kayles on Trees,"**
  [arXiv:2512.24221](https://arxiv.org/abs/2512.24221). (Node-Kayles nimber sequences on graph families.)
- **"On graph automorphisms related to Snort,"** [arXiv:2506.20669](https://arxiv.org/abs/2506.20669).
  (Automorphism mirror strategies; fixed-point handling.)
- O. Aichholzer, D. Bremner, E. D. Demaine, et al., **"Games on Triangulations,"** *Theoret. Comput. Sci.*
  [PDF](https://erikdemaine.org/papers/TriangulationGames_TCS/paper.pdf). (Played-center + mirror pattern.)
- T. Plambeck, A. N. Siegel, **"Misère quotients for impartial games,"**
  [arXiv:math/0609825](https://arxiv.org/abs/math/0609825). (Assessed: not applicable to normal play.)
- **"Strategy-stealing is non-constructive,"** [arXiv:1911.06907](https://arxiv.org/abs/1911.06907).
  (Corroborates: no first-player shortcut for achievement games.)

---

*Method note: the two most on-point PDFs (Andres et al. TCS 2019 on HAL; Sieben EJC) were access-blocked /
returned as binary; their definitions and theorem statements were reconstructed from the open-access
Algorithmica companion, the EJC landing page, and cross-checked secondary summaries. The strictly-matched-
involution definition and the Brandenburg square theorem were confirmed against the primary abstracts.*
