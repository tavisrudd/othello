# Frame: protocol perturbation — random-turn and Richman/bidding values of the cap game

**Date**: 2026-07-10
**Session**: 8b6d1419-df84-4895-8bec-907fb3a79c36 (Fable delegate; frame #3 of 3)
**Question**: compute the random-turn and Richman/bidding values of the cap game (full plane +
residual grid game) and test whether the protocol-smoothed value v(S) exposes the potential
function that alternating play obscures — feeding the C62 selector-library and C63 LP-potential
tasks.
**Dedupe**: the "Online / amortized potentials" row of
[spinoff-bridges §New Candidate Mappings](handoffs/2026-07-09-spinoff-bridges-duals-isomorphisms.md)
records the protocol-perturbation idea from the same conversation; this report is that row's
execution.

**Verdict up front**: the frame's core hope is **dead by theorem, not by measurement**. For any
impartial normal-play game — the cap game included — every symmetric move-selection protocol is
provably information-free: the fair random-turn value, the biased random-turn value, and the
continuous Richman value are constant across ALL positions (1/2, p, 1/2), and published prior art
(Kant–Larsson–Rai–Upasany 2024, Theorem 6) shows discrete bidding collapses to "strict budget
majority wins, exact tie = alternating P/N". There is no protocol-smoothed potential to read off:
the entire structure of the game lives in the turn-order asymmetry that the protocols erase. All
of this is machine-verified exactly on every one of the ~18.8M positions computed here. The
salvage computation — the value under uniformly random play with alternation kept (`rho`) — is
genuinely informative and produced one strong positive: a value-free move-ordering (`rho`-greedy)
that finds a winning move at **every** N-position across all seven boards (10.4M N-positions at
q=11 alone, zero exceptions) while provably not being a tautology of the game class (it fails on
~0.5–0.7% of random-board N-positions). That selector is the report's single concrete feed to
C62. Frame contribution to the open core: **weak** (decisive route-closure + one selector
candidate + a sharp annealed-signal diagnostic), detailed in §7.

## 1. Definitions (verbatim, with player-identity bookkeeping)

Positions `S` are legal sets (caps; for the residual grid game: affine caps with at most one
point per row and per column). `LEGAL(S)` = legal extensions; `dead(S)` iff `LEGAL(S) = ∅`.
All values are win probabilities for a fixed designated player, Alice; Bob is the opponent.

**D0 — random-turn, prompt convention ("the player selected to move at a dead position
loses").** Each round a fair coin picks the mover; at a dead position the coin still flips and
the selected player loses:

```text
v0(S) = 1/2                                        if dead(S)   (the coin picks the loser)
v0(S) = 1/2 · max_{x∈LEGAL(S)} v0(S+x)  +  1/2 · min_{x∈LEGAL(S)} v0(S+x)   otherwise
```

(max = Alice selected, she optimizes up; min = Bob selected, he optimizes down; the child is
entered *before* the next coin flip, so the child value needs no mover tag.)

**D1 — random-turn, last-mover-wins convention.** In alternating play "cannot move loses" and
"last mover wins" are the same statement; under random turn order they bifurcate (D0 ends with a
coin-flip lottery; D1 ends when someone moves to a dead position and that mover wins):

```text
v(S) = 1/2 · max_{x∈LEGAL(S)} u+(S+x)  +  1/2 · min_{x∈LEGAL(S)} u−(S+x)     S not dead,
u+(T) = 1 if dead(T) else v(T)        (Alice moved into T: if T is dead, Alice just won)
u−(T) = 0 if dead(T) else v(T)        (Bob moved into T: if T is dead, Alice just lost)
```

**D2 — biased random-turn.** Same as D1 with mover probabilities (p, 1−p):
`v_p(S) = p · max u+ + (1−p) · min u−`.

**D3 — continuous Richman value** (critical budget fraction for Alice; winner of each bid pays
the loser and moves; Lazarus–Loeb–Propp–Stromquist–Ullman calculus `R = (R_max + R_min)/2`):

```text
R(S) = 1/2 · [ min_{x∈LEGAL(S)} r−(S+x)  +  max_{x∈LEGAL(S)} r+(S+x) ]      S not dead,
r−(T) = 0 if dead(T) else R(T)        (Alice's own best option; moving into dead T wins)
r+(T) = 1 if dead(T) else R(T)        (Bob's best option against Alice)
```

**D4 — discrete bidding** (Develin–Payne 2010 conventions: integer chips, tie-breaking marker,
bid winner pays the loser): not recomputed here; fully characterized by prior art, §2.3.

**rho — random-play value, alternation kept** (the salvage object; a strategy perturbation, not
a protocol perturbation — stated plainly): both players move uniformly at random, turns
alternate; `rho(S)` = probability the mover at `S` makes the last move:

```text
rho(S) = 0 if dead(S);   rho(S) = (1/|LEGAL(S)|) · Σ_{x∈LEGAL(S)} (1 − rho(S+x)).
```

## 2. The transfer gap, stated plainly, and the flatness theorem

### 2.1 What PSSW actually cover

Peres–Schramm–Sheffield–Wilson, "Random-Turn Hex and Other Selection Games", Amer. Math. Monthly
114 (2007), no. 5, 373–387 (DOI 10.1080/00029890.2007.11920428) treat **selection games**: every
element eventually gets claimed by one of the players, the game has fixed length, and the winner
is a monotone function of the final partition — a **partisan** win condition (each player has her
own win-sets). Their theorem — "the expected payoff when both players play the random-turn game
optimally is the same as when both players play randomly" (verified from the paper's abstract) —
and the accompanying optimal-move characterization (both players' optimal move = a
maximal-influence element; same move for both [VERIFY exact statement in the paper body — recalled,
not re-checked verbatim]) rest on all three properties. The cap game has none of them: it is
impartial (identical move rights), variable-length, and the outcome is the *identity of the last
mover*, not a function of the final position. So none of the PSSW machinery transfers as-is. How
much survives is answered exactly by:

### 2.2 Flatness theorem (protocol perturbation carries zero information for impartial games)

**Theorem.** Let G be any finite impartial normal-play game (both players always have the same
move set; last mover wins). Then for every non-terminal position S and every p ∈ [0,1]:
`v_p(S) = p` (in particular the fair random-turn value v(S) = 1/2), `R(S) = 1/2`, and
`v0(S) = 1/2`.

*Proof (induction on the height of S in the game DAG).* If S has a dead child T, then u+(T) = 1
and u−(T) = 0, and since u+ ≤ 1, u− ≥ 0 always, `v_p(S) = p·1 + (1−p)·0 = p`. If S has no dead
child, every child is non-terminal, so by induction u+(c) = u−(c) = v_p(c) = p for all c, and
`v_p(S) = p·p + (1−p)·p = p`. The Richman recursion is the p = 1/2 case with the same dead-child
substitutions (min gets 0, max gets 1), giving 1/2 identically. For v0, terminals are 1/2 by
definition and the max/min of children all equal to 1/2 is 1/2. ∎

(Intuition: the two players are exchangeable — the position carries no turn marker, both have
identical rights and the symmetric goal "be the last mover" — so no label-symmetric protocol can
make any position favor either player by more than the protocol's own bias.)

Corollaries, each a direct hit on a sub-question of this frame:

- **(a) is vacuous**: v has no level sets; the alternating P/N boundary is invisible to v by
  theorem, at every position, for every odd q.
- **(b) is vacuous**: v = const is trivially in every feature span and carries nothing for C63.
- **(c) degenerates**: optimal random-turn play is "take a dead child (win-in-1) if one exists,
  otherwise every move is exactly indifferent (all children have value p)". The PSSW
  optimal-move coincidence survives only in this degenerate sense — both players want the same
  killing move when one exists — and provides no move ordering at all elsewhere.
- **(d) is vacuous**: no drift; v is the same constant at every q.
- The two normal-play phrasings ("cannot move loses" = D0 vs "last mover wins" = D1), equivalent
  under alternation, are *both* flat under random turn — D0 even more trivially (the terminal
  coin-flip lottery back-propagates 1/2 with full indifference at every move).

### 2.3 Discrete bidding: closed by published prior art

Kant–Larsson–Rai–Upasany, "Bidding combinatorial games", Electron. J. Combin. 31(1) (2024),
\#P1.51 (DOI 10.37236/11846; also arXiv:2207.08073) study exactly discrete Richman bidding on
normal-play combinatorial games (total integer budget TB split (p, q), winner of each bid pays
the loser and moves, tie-breaking marker with the announce rule). Their Theorem 6, quoted from
the paper text (marker notation adapted to prose): *"Consider TB ∈ N0 and an impartial game form G. If 2p = TB, then Left wins
(G, p with marker) if and only if alternating normal play G is an N-position. If 2p > TB, i.e.
Left is strictly dominating, then Left wins (G, p, either marker state), unless G = 0, in which
case the player who holds the marker loses."*

So the whole discrete-bidding ladder for an impartial game contains exactly one bit of
position-dependent information — the classical alternating P/N, visible only at the exact-tie
budget point where the marker holder is the "next player" — and is position-independent
everywhere else. There is no intermediate chip-threshold potential; the continuous Richman
flatness (Theorem above) is the TB → ∞ shadow of this. The planned discrete-bidding DP was
therefore dropped: the answer is already a theorem in the literature. (Develin–Payne, "Discrete
Bidding Games", Electron. J. Combin. 17(1) (2010), \#R85, is the underlying bidding formalism;
Lazarus–Loeb–Propp–Stromquist–Ullman, "Combinatorial games under auction play", Games Econom.
Behav. 27 (1999) 229–264, and "Richman games" (arXiv:math/9502222, Games of No Chance 1996) the
continuous theory [VERIFY: the exact random-turn↔Richman equivalence theorem numbering in LLPU —
cited from the survey layer, not re-derived].)

**Frame consequence.** Any hope that "random-turn and Richman games have exact potential-function
theories, so computing their values on the cap game reveals the hidden potential" fails at the
definitional level: those potential theories are potential theories *of partisan win conditions*.
For our game class the protocol-perturbed values are constants, and the only informative
perturbation that keeps position-dependence is one that keeps the alternation. That is what the
computation below does.

## 3. Computation

Solver: `randomturn.rs` (standalone Rust, session scratchpad
`/tmp/claude-1000/-home-tavis-src-othello-rust/8b6d1419-df84-4895-8bec-907fb3a79c36/scratchpad/randomturn/`;
build `rustc -O -C target-cpu=native randomturn.rs -o randomturn`; modes `calib`, `plane q`,
`grid q [dump.tsv]`). Exhaustive memoized full-expansion DP over `u128` bitmasks (no cutoffs —
every reachable position is solved); per position it computes alternating `pn`, `rho`, and the
four protocol values of §1, asserting the flatness theorem **exactly** (dyadic f64 arithmetic is
exact here) on every state. GF(9) = GF(3)[t]/(t²+1). No sampling anywhere in the Rust runs; the
only seeds in this report are the documented ones in the adversarial Python control (§5).

Boards solved exhaustively: full plane PG(2,q) for q = 3, 5, 7; residual grid game for
q = 5, 7, 9, 11. Residual grid q = 13 does not fit the 8 GB gate without canonicalization
(state estimate O(10⁸⁺); recorded as follow-up); plane q ≥ 9 likewise.

### Validation gates (all machine-checked, all PASS)

1. **G1 plane structure**: every point pair has exactly q−1 collinear completions (q = 3, 5, 7).
2. **G2 grid structure**: every cell excludes exactly 2(q−1) cells pairwise; every off-row/col
   pair has exactly q−2 completions (q = 5, 7, 9, 11).
3. **G3 calibration boards**: free-placement n = 1..8 is P iff n even with rho = parity
   indicator; the triangle board is P.
4. **G4 alternating calibration**: the empty position is P (second-player win) on every board —
   plane q = 3, 5, 7 and grid q = 5, 7, 9, 11 — reproducing the program's known verdicts. This is
   the same code path that produces the random-turn numbers.
5. **G5 size-3 extension count**: every legal size-3 grid state has exactly q² − 9q + 21 legal
   extensions (1 / 7 / 21 / 43 at q = 5 / 7 / 9 / 11), matching the Lean theorem
   `SizeThreeExtensionCountStatement`.
6. **G6 conic structure**: every legal size-3 grid state determines a unique conic through its
   5-arc (kernel dimension 1) with exactly q−4 legal on-conic extensions — the handoff's conic
   localization facts, re-derived independently.
7. **Independent cross-check**: `crosscheck.py` (plain Python recursion, exact `Fraction`
   arithmetic, no shared code) recomputed all 726 grid q=5 states and all 560 plane q=3 states:
   zero pn/rho mismatches, and the flatness asserts pass in exact rational arithmetic.

Compute record: all runs single-core on 2026-07-10; the largest board (grid q=11, 15,697,452
positions) solves in 24 s at 2.4 GB peak RSS; everything else is ≤ 1 s. Total well under the 4 h
/ 8 GB budget.

## 4. Results

Flatness verification: `v = 1/2`, `v_p (p=3/4) = 3/4`, `R = 1/2`, `v0 = 1/2` asserted exactly on
all 18,760,052 computed positions across the seven boards. Zero violations (as the theorem
requires; the asserts are a code-vs-theorem cross-check).

Per-board summary for the informative quantities (`rho`, alternating pn):

| board      | positions  | root  | rho(empty) | misaligned pn vs rho≷1/2 | complete-cap spectrum (size:count)     |
|------------|------------|-------|------------|--------------------------|----------------------------------------|
| plane q=3  | 560        | P     | 0.000000   | 0 (0%)                   | 4:234                                  |
| plane q=5  | 41,572     | P     | 0.000000   | 0 (0%)                   | 6:3,100                                |
| plane q=7  | 2,446,460  | P     | 0.000000   | 0 (0%)                   | 6:625,632  8:16,758                    |
| grid q=5   | 726        | P     | 0.000000   | 0 (0%)                   | 4:100                                  |
| grid q=7   | 19,160     | P     | 0.000000   | 0 (0%)                   | 4:5,880  6:294                         |
| grid q=9   | 554,122    | P     | 0.038873   | 51,840 (9.36%)           | 4:2,592  5:10,368  6:36,288  8:648     |
| grid q=11  | 15,697,452 | P     | 0.562061   | 2,933,162 (18.69%)       | 5:24,200  6:2,058,210  7:871,200  8:18,150  10:1,210 |

Readings:

- **Planes q ≤ 7 and grids q ≤ 7 are pure-parity boards**: rho ∈ {0, 1} exactly and equals the
  ply parity at every position (OLS on [ply parity] alone: R² = 1.0). Every maximal chain through
  any position has the same length parity; the smooth relaxation contains exactly the parity bit
  and nothing else. Consistent with the program's "naive parity works through q ≤ 9".
- **Grid q=9 breaks mildly**: odd complete caps exist (10,368 of size 5), rho leaves {0,1}, and
  the misalignment is a single clean stratum — 51,840 ply-4 N-states with rho = 1/7 exactly:
  win-in-1 states whose unique killing move random play finds with probability 1/7. Per-ply OLS
  is still perfect: rho is an exact function of (ply, L mod 2, kill-move count) at q=9.
- **Grid q=11 is the real signal**: rho(empty) = 0.562 > 1/2 while the position is P — the
  annealed (random-play) verdict contradicts the true verdict **at the root**, and at every
  position of size ≤ 3 (all size-1/size-3 states are N with rho ≈ 0.44; all size-2 P states have
  rho ≈ 0.56). Misalignment is 18.7% overall, plus a curious exact-1/2 stratum (508,200 ply-5
  N-states with rho = 1/2 exactly).

### (a) Does the P/N boundary align with a level set of the smoothed value?

For the protocol value v: **no, by theorem** — v is constant (§2.2). For the salvage value rho:
**only below the arc-depletion boundary**. Alignment (pn = N ⟺ rho > 1/2) is perfect at
q ≤ 7, has one misaligned killing-move stratum at q = 9, and fails wholesale at q = 11 —
including at the empty position. The exceptions are not noise: at q=9 they are exactly the
"unique-killing-move" states; at q=11 the entire opening (plies 0–3) is misaligned because the
odd complete caps (871,200 size-7 terminals) tilt random play's length parity while optimal play
still forces even termination. The alternating P is anti-annealed at q=11 in the same sense that
frame #2 found it anti-generic at q = 5, 7: the conjecture's content is precisely that optimal
play defeats the typical-play parity drift at every order.

### (b) Is the smoothed value expressible in the program's feature vocabulary?

For v: vacuously yes (constant) — content-free for C63. For rho, fits with residuals reported:

| board / stratum   | feature basis                                        | R²     | RMSE   |
|-------------------|------------------------------------------------------|--------|--------|
| grid q=9 (all)    | [1, k, k%2, L, L%2, kill]                            | 0.9554 | 0.1022 |
| grid q=9 per ply  | [1, L, L%2, kill]                                    | 1.0000 | 0.0000 |
| grid q=11 (all)   | [1, k, k%2, L, L%2, kill]                            | 0.6128 | 0.2570 |
| grid q=11 ply 4   | [1, L, L%2, kill]                                    | 0.2788 | 0.1374 |
| grid q=11 ply 5   | [1, L, L%2, kill]                                    | 0.6214 | 0.2007 |
| grid q=11 ply 4   | + conic live_on summaries [live_min, live_max, live_sum over all 3-subset conics] | 0.4292 | 0.1222 |
| grid q=11 ply 5   | + conic live_on summaries                            | 0.7749 | 0.1547 |

Negative, stated plainly: at the first order where rho carries non-parity information (q=11), it
is **not** expressible in the shallow program vocabulary — ply, move count, parities, kill count,
and conic live_on summaries leave RMSE ≈ 0.12–0.15 at the plies that matter. The live_on
summaries do carry real marginal signal (ply-4 R² 0.28 → 0.43), so "annealed value components"
are a legitimate candidate *feature direction* for C63's LP span, but no clean functional form
was found and none is claimed. (Deeper program features — defect spectra, zone summaries — are
S4-rooted and were out of scope here; the C63 lane owns that fit.)

### (c) The selector connection — the frame's one strong positive

PSSW-style move coincidence is degenerate for v (§2.2). But the **rho-greedy** ordering — from an
N-position, play the child minimizing rho(child), i.e. minimize the opponent's random-play win
probability — is empirically perfect on every geometric board computed:

| board      | N-positions with a winning child | rho-greedy argmin is a winning move | every argmin-tie is winning | random-move baseline |
|------------|----------------------------------|-------------------------------------|-----------------------------|----------------------|
| plane q=7  | 1,098,637                        | 100.0000%                           | 100.0000%                   | 1.0000               |
| grid q=9   | 347,409                          | 100.0000%                           | 100.0000%                   | 0.8437               |
| grid q=11  | 10,383,131                       | 100.0000%                           | 100.0000%                   | 0.6785               |

(q ≤ 7 boards are also 100% but trivially so — rho there is the parity bit. At q=11 the result is
NOT trivial: rho misclassifies 18.7% of positions as a value proxy, the random baseline is 0.68,
and at ply 3 the baseline is 0.32 — yet the argmin never once lands on a losing child, across all
10.38M obligations, ties included.)

**Adversarial control** (`selector_adversarial.py`, uniform random 3-uniform hypergraph boards,
exhaustive solves, seeds 910000/920000/930000/940000/950000/960000 + board index): the law FAILS
on unstructured boards — the argmin-rho set contains no winning move at 368/50,150 N-states
(n=12, m=30) and comparably (~0.5–0.7%) across all six ensembles. So "rho-greedy finds a winning
move" is **not** a theorem of the game class; its perfection on the plane/grid boards is a
structural regularity of the geometry — exactly the kind of canonical, value-free move ordering
the C62 task wants scored.

**Handoff to C62 (precise).** Add "annealed-value greedy" to the C62 selector library: for each
maintenance obligation (state, opponent move) in the q=17/q=19 steering rows, rank legal replies
by rho of the child, ascending. rho over an S4-rooted subtree costs one full-expansion traversal
of that subtree — the same visit set as the C35 `s4gdump` Grundy dumps (q=17 roots ≈ 1.9×10⁵
records < 1 s each; q=19 root ≈ 2.7×10⁶, ≈ 17 s; q=23 buckets ≈ 2.4×10⁸ total, hours) — so an
`s4rho` mode alongside `s4gdump` is a small patch to the grid-cap solver. Score: fraction of
obligations where a verified maintainable zero-xor P reply is at rank 1, and the rank
distribution of all verified witnesses. Caveat stated plainly: rho is game-tree-defined, not
incidence-defined — it can serve as a mining/ordering selector for C62, but it does NOT satisfy
the "definable from incidence data, no value oracle" requirement of the S11 geometric selector
lemma; if it scores perfectly at q=17/19, the follow-up question becomes what geometric quantity
it is secretly computing.

### (d) Cross-q drift on matched configurations

Integer-coordinate configurations legal at every computed order (grid game; prime-field residue
map at q = 5, 7, 11; at q = 9 the map m ↦ (m mod 3) + t·(m div 3) is a bookkeeping choice, not
canonical — stated plainly):

| configuration            | q=5:  pn, rho | q=7:  pn, rho | q=9:  pn, rho | q=11: pn, rho |
|--------------------------|---------------|---------------|---------------|---------------|
| S0 = {} (empty)          | P, 0.000000   | P, 0.000000   | P, 0.038873   | P, 0.562061   |
| S1 = {(0,0)}             | N, 1.000000   | N, 1.000000   | N, 0.961127   | N, 0.437939   |
| S2 = {(0,0),(1,1)}       | P, 0.000000   | P, 0.000000   | P, 0.038873   | P, 0.562061   |
| T1 = {(0,0),(1,1),(2,4)} | N, 1.000000   | N, 1.000000   | N, 0.945578   | N, 0.436292   |
| T2 = {(0,0),(1,1),(3,2)} | N, 1.000000   | N, 1.000000   | N, 0.945578   | N, 0.436292   |
| T3 = {(1,0),(2,2),(4,3)} | N, 1.000000   | N, 1.000000   | N, 0.945578   | N, 0.436292   |

The alternating values are stable across q (no flips in this small family), while rho drifts
mildly through q = 9 and then **jumps across 1/2 at q = 11** — the first arc-depleted order, the
same place the 119-configuration value flips and the naive-parity death live. For v the question
is vacuous (constant). q = 13 (to test whether rho recrosses at the next full order) needs a
canonicalized solver — follow-up, not run. [Speculation, labeled: if rho(empty) oscillates with
the arc-depletion dichotomy {11,17} vs {13,19}, the annealed parity drift and the C55/C64
dichotomy share a mechanism — the odd-complete-cap density; the C66 grid-terminal spectrum task
would measure exactly this.]

## 5. Reproduction

Code and raw outputs in the session scratchpad
(`.../8b6d1419-df84-4895-8bec-907fb3a79c36/scratchpad/randomturn/`): `randomturn.rs` (solver,
gates, analyses), `crosscheck.py` (independent exact-rational cross-check), and
`selector_adversarial.py` (random-board control; the only seeded computation, seeds documented in
§4c and in-file). The scratchpad is session-temporary; every Rust table is deterministic
(exhaustive, seedless) and exactly reproducible from the file. Commands: `randomturn calib`,
`randomturn plane 3|5|7`, `randomturn grid 5|7|9|11`.

## 6. What this adds to / subtracts from the program

- **S10 / S11 proof-shape ranking** ([census](2026-07-09-frame-proof-shape-census.md)):
  unchanged in order, sharpened in rationale. The flatness theorem is an independent argument
  that no protocol-symmetric smoothing can produce the missing potential — the potential must be
  alternation-anchored, i.e. *maintained by the winning player through the turn structure*, which
  is exactly the amortized/ledger form S11 posits and the "Online / amortized potentials" row
  records. It also retroactively certifies that the PSSW/Richman import in the sweep notes has no
  proof-side content for this game class (the import dies at the partisan-win-condition
  boundary, not at a computation).
- **C62**: gains one concrete, cheap, in-sample-perfect selector family (rho-greedy / annealed
  ordering) with a precise implementation path (`s4rho` alongside `s4gdump`) and an adversarial
  control already showing it is not class-trivial.
- **C63**: gains a measured negative (rho is not in the shallow feature span at q=11; residuals
  quantified) and a candidate feature direction (annealed-value components / live_on summaries)
  — plus the warning that any potential fit on protocol-symmetric features alone is fitting a
  constant.
- **Frame #2 cross-link** ([genericity test](2026-07-10-frame-genericity-test.md)): the annealed
  verdict inside the true board (rho at q=11) contradicts the structural verdict just as the
  generic ensemble verdict did at q = 5, 7 — two independent smoothings now point the same way:
  the conjecture's P is anti-typical, and proofs must consume geometry, not typicality.

## 7. Verdict

**Does the protocol-perturbation frame pay?** As a potential-revealing device: **no — closed by
theorem**, and the closure is cheap, final, and worth having on record (it removes random-turn /
Richman / bidding smoothing from the program's method space permanently; impartiality is the
precise reason). As a program contribution: **weak overall** — one theorem-grade negative, one
strong empirical selector candidate (the frame's genuine payment, routed to C62), one annealed
diagnostic (rho) whose q=11 sign flip is a new, sharp instance of the anti-typicality pattern.
It neither strengthens nor weakens S10/S11 as shapes; it thins the alternatives around them.

**Single next action**: patch an `s4rho` traversal into the grid-cap solver and score rho-greedy
as a C62 selector family on the existing q=17 bucket roots (obligations from the C20/steering
rows; < 1 day, single-core, well under 8 GB) — the direct test of whether the 10.4M-obligation
in-sample perfection at q ≤ 11 persists at the frontier orders.

## References

- Y. Peres, O. Schramm, S. Sheffield, D. B. Wilson, "Random-Turn Hex and Other Selection Games",
  Amer. Math. Monthly 114 (2007), no. 5, 373–387. DOI 10.1080/00029890.2007.11920428
  (arXiv:math/0508580). Citation and the optimal=random theorem verified from the
  publisher/arXiv abstract this session.
- A. J. Lazarus, D. E. Loeb, J. G. Propp, W. R. Stromquist, D. H. Ullman, "Combinatorial games
  under auction play", Games Econom. Behav. 27 (1999) 229–264; also "Richman games",
  arXiv:math/9502222 (Games of No Chance, 1996).
- M. Develin, S. Payne, "Discrete Bidding Games", Electron. J. Combin. 17(1) (2010), #R85.
- P. Kant, U. Larsson, R. K. Rai, A. V. Upasany, "Bidding combinatorial games", Electron. J.
  Combin. 31(1) (2024), #P1.51, DOI 10.37236/11846 (arXiv:2207.08073). Theorem 6 quoted from the
  paper PDF this session.
