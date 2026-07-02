# Theory implications & extensions — Non-Attacking Queens / A344227 (2026-07-02)

**Scope**: THEORY-ONLY session. No builds, no solver runs; the only computations here are
O(n²) Python arithmetic checks and exhaustive Grundy brute force on tiny boards (n ≤ 5),
run in the scratchpad. Companion to:
- [conjecture-theory note](2026-07-02-a344227-conjecture-theory.md) — Lemma 1, Lemma 2,
  Theorem 3, G(17)/G(18) predictions
- [n=18 PV geometry](2026-07-02-n18-pv-geometry.md) — I9 = embedded 17×17 center, τ-mirror,
  live L-border, the "border battle" theorem candidate
- [nimber handoff](handoffs/2026-07-01-queens-nimber-a344227.md) — heap-sum engine,
  G(14..16) = 0, 1, 0

**Status legend** (every claim carries one): **PROVEN** (proof written or one-line from a
written proof), **verified-arithmetic** (checked exhaustively by direct computation at the
stated sizes; general-n proof sketched but not fully written), **heuristic** (a mechanism
argument, no proof), **speculation** (a direction, not yet even a mechanism).

Notation as in the companion notes: `B_n` = the n×n start position; `ρ(r,c) = (n−1−r, n−1−c)`;
for even n, `c* = (m,m)` with `m = n/2 − 1` = the central main-diagonal strike (I9 at n=18);
`S = [0..n−2]²` = the embedded (n−1)×(n−1) sub-board; `τ(x) = (n−2, n−2) − x` = point
reflection of S about c*; `L` = the border row (n−1) ∪ column (n−1); "live border" = L minus
the squares c* attacks. All small-board Grundy values quoted below were brute-forced fresh
this session unless marked otherwise.

---

## 1. The border battle — toward an even-n theorem

The prize: **Conjecture BB** — for all even `n ≥ n₀` (n₀ = 18 on current evidence), the
first player wins `B_n` by playing c*, i.e. the residual `R_n = B_n after c*` is a
P-position. If true, combined with Lemma 2 (odd ⟹ G ≥ 1), **A344227 has finitely many
zeros** (§8). This section formalizes the battlefield, proves what is provable cheaply,
and locates exactly where a proof must do real work — including why it MUST fail for
n = 10..16 (those are P-boards, so R_n is an N-position there; any valid argument needs an
n-dependent hypothesis that is false at 16 and true at 18).

### 1.1 The exact structure of R_n — PROVEN / verified-arithmetic

- **The sub-board part is exactly the odd-board center residual.** c*'s attack set inside S
  is precisely the four central lines of S (center row m, center column m, main diagonal of
  S, anti-diagonal r+c = n−2). So `R_n ∩ S = (B_{n−1} after center)` — the exact Lemma-2
  P-residual, τ-symmetric, with no τ-self-mirroring square available. Verified exhaustively
  at n=18 (set equality); the general-n identity is the same one-line arithmetic as Lemma 1.
- **The live border has 2(n−2) squares** (L has 2n−1; c* kills (n−1,m), (m,n−1), and the
  corner (n−1,n−1) via its main diagonal). n=18: 32 live squares, 16 per arm. Verified.
- **Lemma B1 (border occupancy). At most TWO queens can ever stand on L.** PROVEN (trivial):
  the row-arm is a clique (shared row), the col-arm is a clique (shared column), and a
  cross-arm pair (n−1,c), (r,n−1) attacks iff r = c (shared anti-diagonal) or involves the
  corner (dead in R_n). Exhaustively confirmed at n=18 (no independent triple exists on the
  live border). **Consequence: the "border battle" is not a long game on a 1-D strip — it is
  at most ONE exchange of border moves, plus the scars those ≤2 moves inflict on S.** This
  collapses the battle to a bounded number of "events", which is what makes a proof look
  feasible at all. (The validated n=18 PV contains exactly one border move, R5 = (4,17),
  played by the winner — consistent.)

### 1.2 The two exact obstructions to a pairing repair — PROVEN

Why is there no clean secondary pairing for the border (the geometry note's open question)?
Two independent one-line facts close every candidate:

- **Lemma B2a (phantom row).** The τ-partner of any border square is off the board by
  exactly one row/column: `τ(n−1, c) = (−1, n−2−c)`. The exact pairing repair square exists
  only on the extended board. (Equivalently: the responder queen that would re-symmetrize a
  border intrusion's S-scar — matching its column-scar, main-diag-scar, AND anti-diag-scar —
  solves to row −1 in all three constraints simultaneously. Verified by solving the three
  line equations; all three give r₀ = −1.) This is also the crisp statement of why the
  TORUS has no such obstruction — see §3.
- **Lemma B2b (transpose partner is self-attacked).** The σ-transpose partner of a border
  square shares its anti-diagonal: (n−1,c) attacks (c,n−1). So the one involution that maps
  the row-arm to the col-arm (and column-scars to row-scars) is exactly unavailable: playing
  a border square deletes its own σ-partner. Verified for all c at n=18.

So ρ maps L off itself, τ maps L off the board, and σ is self-blocking. **Any proof of
Conjecture BB must handle border intrusions by INEXACT repair plus counting** — it cannot
be pure pairing. That is structurally consistent with a threshold theorem (true only for
n ≥ n₀), which is what the data demands.

### 1.3 What the responder (first player, after c*) can actually do

Case analysis for the τ-strategy in R_n, with the danger localized — status per branch:

1. **Opponent plays only S-squares.** Mirror τ(s). As long as no border queen exists, the
   S-available-set stays exactly τ-symmetric (queens in S arrive in τ-pairs; their S-attack
   sets are τ-images). **This branch is fully handled — PROVEN** (same induction as Lemma 2).
   Note border squares die asymmetrically throughout, but the responder does not need border
   symmetry, only (2) and (3) below.
2. **Opponent plays a border square b.** By B1 this can happen at most twice per game, and
   the second border move closes L forever. The natural parity-restoring reply is the other
   arm (any live cross-arm square, which auto-avoids r=c since b killed its σ-partner). By
   B2a/B2b the S-scars of {b, reply} cannot be made τ-symmetric: b scars a COLUMN of S (plus
   two diagonals), the cross-arm reply scars a ROW (plus two diagonals), and τ preserves
   line type. Result: a scar set Δ = {live S-squares whose τ-partner is dead} of size O(n).
   **Status: the exchange itself is forced-ish and cheap; Δ is the whole problem.**
3. **Post-exchange: opponent plays into Δ.** τ(s) is dead; the responder must improvise. An
   improvised reply creates secondary scars; the scar algebra does not close (each repair
   level spawns new asymmetry). **This is the precise point where the proof does not yet
   exist.** Everything else above is closed.

**Lemma B3 (arms-balance) — verified-arithmetic (n=18 exhaustive; general-n sketch).**
Every τ-pair {s, τ(s)} of S-squares attacks equally many live row-arm and live col-arm
squares: the row/column hits contribute one to each arm; the main-diagonal hit lands on the
arm of sign(c−r), which τ flips; the anti-diagonal hits both arms or neither, in each of
s, τ(s) (and r=c pairs send both main-diagonal hits to the dead corner). Checked for every
τ-pair at n=18. **Consequence (heuristic once overlaps are considered): under pure mirror
play the two arms erode at equal rates, so when an intrusion comes, a cross-arm reply
exists** — the parity half of branch (2) is generically safe; only the Δ-battle is open.

### 1.4 Shape of a future proof, and why it must fail at n ≤ 16

- **Required shape**: pairing (branch 1) + one bounded exchange (branch 2, B1/B3) + a
  quantitative argument that the responder survives the Δ-battle for n ≥ n₀. The natural
  tool is a potential/budget argument in the Erdős–Selfridge style: |Δ| = O(n) unpaired
  squares against Θ(n²) paired territory; each Δ-move by the intruder must be answered from
  a "safe improvisation set" whose size grows with n; a pigeonhole/counting bound shows the
  set is nonempty for n ≥ n₀ and can fail for small n. **Status: speculation** (no candidate
  potential function yet survives the secondary-scar cascade).
- **Why failure at n=10..16 is structurally necessary**: those boards are P, so R_n is N —
  the intruder has a genuine winning attack. Any correct BB proof must therefore consume an
  n-dependent resource. The counting shape above is the only style seen so far that does.
- **The n=8 warning — heuristic, important.** G(8)=3: the first player also wins n=8. If
  the n=8 win uses a central-diagonal opening, the battle "tips" twice (win at 8, lose
  10–16, win 18+), and **no monotone counting argument can be the whole story** — n=8 would
  have to be quarantined as small-board tactics outside the asymptotic regime. Cheap
  deferred experiment (§6): enumerate n=8's winning openings (seconds of compute) before
  investing in a monotone proof shape.
- **Invariant candidates on the border** (all speculation): (a) arms-balance as a maintained
  invariant, not just a per-pair fact (needs overlap accounting); (b) parity of |Δ| — each
  border event changes the unpaired-square parity by a computable amount; if a Δ-involution
  can be chosen per event, the battle reduces to "who runs out of Δ-moves", a 1-D Kayles-like
  game of size O(n); (c) treating Δ as a virtual Nim-heap and asking when G(R_n) computes as
  a bounded perturbation of 0 — see §2.

### 1.5 The best cheap discriminator (deferred, needs box)

For n = 10, 12, 14, 16: solve R_n's winning ATTACK (the intruder's side) and extract its PV
geometry the way pv18.py did — specifically (i) does the attack use a border move, and at
what ply; (ii) does it play into Δ after a border exchange; (iii) diag-distance profile.
If the small-n refutations all route through the border/Δ mechanism, Conjecture BB's shape
is confirmed and the counting target is identified; if they win purely inside S, the
τ-symmetric branch-1 analysis above is missing something and BB is in trouble.
One sub-position solve per n, far below production scale. **Highest information-per-cost
experiment this note proposes.**

---

## 2. Even↔odd induction: the exact relation and the exact obstruction

**The relation is EXACT at the position level — PROVEN**:

> `R_n = (B_{n−1} after center)  ∪  live-L  ∪  (cross-attack edges between them)`,
> and the first factor is a P-position (Lemma 2).

So the even-n game after the central strike literally CONTAINS the solved odd-(n−1) game;
only the border and its entanglement stand between the two. What obstructs turning this
into `G(B_n) = f(G(B_{n−1}), border)`:

1. **It is not a disjunctive sum.** Border squares attack O(n) S-squares (a column/row of S
   plus two diagonals each), and every S-queen kills 2–4 border squares. Sprague-Grundy XOR
   does not apply across cross-edges, and there is no general theory bounding Grundy change
   under adding edges between summands.
2. **The disjoint-sum fiction gets the wrong (and n-independent) answer — instructive.**
   Pretend the cross-edges are absent: `G(fiction) = G(P-residual) ⊕ G(live-L in isolation)
   = 0 ⊕ G(L)`. The isolated live border (two cliques joined by the r=c matching, corner
   dead) has all moves leading to a nonempty clique remnant (G=1) while both arms are large,
   so `G(L) = mex{1} = 0` — verified by hand-case-analysis (verified-arithmetic caveat: the
   value drifts as the arms erode and near-empty cases give other values). The fiction thus
   predicts `R_n` is P — i.e. **the central strike wins for ALL even n** — contradicted by
   n = 10..16. Since the fiction is essentially n-independent, **the entire n-dependence of
   the even-n outcome lives in the entanglement** (the scars). That is the sharpest
   available statement of "why the border battle is the right frame."
3. **Bounded-perturbation is the plausible salvage — speculation.** By B1 the entanglement
   "fires" at most twice per game in the border→S direction. A theory of "sums with ≤k
   interaction events" (the intruder may cash at most k cross-component moves, each with a
   bounded scar) does not exist in CGT to my knowledge; queen boards would be its motivating
   example. Even a k=2 special theory would convert §1 into a theorem schema.
4. **Scope caveat — PROVEN but easy to forget**: BB/§2 machinery decides only the OUTCOME
   direction "c* wins ⟹ G(B_n) ≠ 0". Proving `G(B_n) = 0` (the n ≤ 16 verdicts) needs ALL
   diagonal strikes refuted (Theorem 3 reduces to those), and non-central diagonal strikes
   (d,d), d ≠ m do NOT reproduce the odd-center structure — each embeds an off-center point
   reflection with a larger unpairable region. The induction, even perfected, pins the
   nonzero side, not the zero side.

---

## 3. Other boards and pieces — the Lemma-1 rework, unified

### 3.1 Master Lemma (central collinearity) — PROVEN

Model a piece by its symmetric move-vector set V (s attacks t iff t−s ∈ V; queens-style
"ray pieces" have V = {t·u : t ∈ ℤ\0, u ∈ D} for a direction set D; kings/knights are
"step pieces" with finite V). Let p be the board center (a lattice square iff all sides
odd) and ρ_p the point reflection about p. Then:

> s is self-mirroring under ρ_p  ⟺  ρ_p(s) − s = 2(p − s) ∈ V.

For **ray pieces with p on the board**: 2(p−s) ∈ V ⟺ p−s is parallel to some u ∈ D ⟺ **p
attacks s**. So the self-mirroring set is exactly N[p], and the center-steal-then-mirror
argument (Lemma 2) works verbatim: **odd boards of any ray piece, any dimension, are
first-player wins (G ≥ 1)**. For **even boards**, 2(p−s) has all-odd coordinates, and the
self-mirroring set is whatever slice of V survives that parity constraint — the piece-by-
piece content below. For **step pieces**, 2(p−s) ∈ V has few or no solutions (V is finite
and scaling-closed only trivially), giving empty or O(1) exceptional sets.

This one lemma generates every row of the table. All brute-force values below were computed
fresh this session (exhaustive Grundy, n ≤ 5, plus bishops 2..5 and kings 1..4).

### 3.2 The table

| piece / board             | self-mirroring set (even side)         | result                                                                 | status |
|---------------------------|----------------------------------------|------------------------------------------------------------------------|--------|
| rooks m×n                 | ∅ when min side even? — actually ∅ iff both parities block; moot: | **complete solution G = min(m,n) mod 2** via game-length invariance (every maximal play has length exactly min(m,n); single-option-value induction gives G = parity). Mirror argument independently gives the even case. Brute-forced 2×2..4×4 ✓ | PROVEN (known/folklore) |
| knights n×n               | **∅** (knight vectors have one odd, one even component; 2(p−s) has both-odd (even n) / both-even (odd n) components) | **even n ⟹ G = 0 (mirror is complete)**; odd n: center-steal ⟹ G ≥ 1 (center's knight-neighborhood is ρ-symmetric, residual has no self-mirroring squares). Brute force n ≤ 5: G = 1,0,1,0,1 ✓ | PROVEN here; presumably folklore — pre-submission lit check |
| bishops n×n               | both long diagonals (same as queens' diagonal part) | **complete outcome solution**: even n ⟹ **G = 0** — not via ρ at all, but because the game is the disjoint sum of the two color components, which the vertical reflection makes ISOMORPHIC for even n ⟹ G = g ⊕ g = 0. Odd n ⟹ G ≥ 1 (center bishop deletes exactly both long diagonals = all self-mirroring squares). Brute force: G(2..5) = 0, 2, 0, 1 ✓ | PROVEN here (verified-arithmetic at n ≤ 5); folklore check needed |
| kings n×n                 | the 4 central squares (even n); center only (odd n) | odd ⟹ G ≥ 1 (center steal). Even: **Theorem-3 analog with an O(1) exceptional set** — a first-player win must use one of 4 squares. Likely closable to a complete even-n solution by pairing + finite scar analysis (the scar after a central strike is O(1)). G(4) = 0 ✓ consistent | reduction PROVEN; closure speculation |
| queens m×n rectangles     | m,n both even: the two OFFSET diagonals r−c = (m−n)/2, r+c = (m+n−2)/2. m even × n odd: **the center column only** (diagonal conditions need m ≡ n mod 2). m,n both odd: four central lines through the ρ-fixed point | odd×odd ⟹ G ≥ 1 (the fixed-point queen's attack set is exactly the self-mirroring set — Master Lemma). Even×even and even×odd: Theorem 3 transfers verbatim — a win must strike the exceptional set (O(min(m,n)) or one column). No steal for mixed parity (a center-column queen's residual is not ρ-symmetric: its row-scar breaks it) | PROVEN (reductions); values open |
| torus queens n×n          | every point-reflection has Θ(n) self-mirroring squares (4 wrapped diagonals' worth: 2(r−c) ≡ const has two solutions mod even n, likewise anti); every involutive translation is fully self-mirroring (shares a row, column, or wrapped diagonal with its image) | mirrors are NEVER complete — the phantom-row escape (B2a) does not exist because there is no border, but the wrapped diagonals more than compensate. Instead, **vertex-transitivity solves the value range: G(torus) ∈ {0,1} for ALL n** — all root options are isomorphic (translations act transitively), so the option-value set is a singleton {g} and G = mex{g} ∈ {0,1}. Also collapses the root to ONE residual solve. Brute force n ≤ 5: G = 1,1,1,0,1 ✓ | PROVEN here (transitivity argument is general: Node-Kayles on any vertex-transitive graph has G ∈ {0,1}; likely known — check) |
| d-dim queens n^d          | even n: the "diagonal skeleton" {x : |n−1−2x_i| equal ∀i} — Θ(n·2^d) points, measure-zero in n^d | odd n ⟹ G ≥ 1 in every dimension (Master Lemma, verbatim). Even n: Theorem 3 transfers — a win must strike the skeleton | PROVEN (reductions) |

**Which yield SOLVED families vs queen-like reductions**: solved outcome families = rooks,
knights, bishops (all three by complete symmetry arguments — respectively length-invariance,
empty exceptional set, isomorphic-summands); {0,1}-bounded family = torus queens (by
transitivity, outcome per n still open); thin-exceptional-set reductions (queen-like, open) =
flat queens, rectangle queens, d-dim queens, kings-even (the most promising to CLOSE, with
its O(1) set).

Two meta-observations worth keeping: (1) the three complete solutions each use a DIFFERENT
mechanism — the field of "placement games under symmetry" has at least three distinct
closure tools, and queens is hard precisely because all three fail (no length invariance,
nonempty exceptional set, connected board). (2) The torus row shows boundedness can come
from transitivity rather than from mirrors — a genuinely different route to §1c-style
boundedness statements, and the only PROVEN G-boundedness in this family of games so far.

---

## 4. Misère play: what precisely breaks

Short version: **essentially everything transfers nothing**; only Lemma 1 (pure geometry,
convention-free) survives as a statement.

1. **The mirror delivers the LAST move — a loss under misère.** Theorem 3's responder
   strategy and Lemma 2's center-steal both prove "the strategist moves last", which is
   exactly the losing condition. They do not flip into first-player-win statements either:
   the mirror is a second-player device (the first player cannot pair after moving), and
   under misère the second player simply declines to mirror. **No misère analog of Theorem 3
   is derivable from these methods — the diagonal reduction does NOT survive.** PROVEN
   (that the strategies fail), and no repair is visible.
2. **The "deviate once at the end" folk repair does not obviously apply.** It works in games
   where the paired region ends in interchangeable unit moves (misère Nim-style). In
   Node-Kayles a deviation changes deletions, not just parity. Conditional salvage
   (speculation): if the τ/ρ-strategist can maintain symmetry until the live set is
   edgeless (all isolated vertices — queen endgames often reach this, cf. the PV's final
   −2,−2,−1 deletions), the remainder is she-loves-me-not and the strategist can count
   parity and deviate one move early. Making "can force an edgeless symmetric endgame" a
   lemma is real work; no proof shape yet.
3. **The heap-sum ENGINE trick dies.** `G⁻(board) via board + heap` is unavailable: misère
   play has no Sprague-Grundy additivity; sums require genus theory / misère quotients
   (Plambeck–Siegel), which are game-specific and often infinite ("wild") — and misère
   Node-Kayles on general graphs is presumably wild [R, unverified]. So computing misère
   values of queen boards needs a different engine (whole-DAG misère analysis), which is
   the pre-heap-sum cost regime — n ≈ 13 tops. A misère companion sequence to A344227 is
   thus a real (and separate) computational project, not a flag flip.
4. **What does survive**: Lemma 1 / Master Lemma (statements about the graph); B1 (at most
   two border queens — a rules-level fact); vertex-transitivity's option-isomorphism (the
   torus root still has one residual up to isomorphism, so misère torus outcome is also a
   single sub-position question).

---

## 5. Certificate compression for P-verdicts (n ≤ 16, future n = 20?)

**The idea**: Theorem 3 makes "second player wins B_n (even)" certifiable far below a full
strategy DAG, because the certificate can be RULE + EXCEPTIONS:

- **Rule (O(1) bytes)**: from any ρ-symmetric position, answer a non-diagonal move m with
  ρ(m). Soundness is Lemma 1 arithmetic, checkable by a one-page verifier with no game
  search at all.
- **Exceptions**: entries only where the opponent strikes a long-diagonal square from a
  reachable symmetric position. Each entry = (symmetric position class, strike d) → reply +
  continuation reference.

**Checker obligations**: (1) verify the rule's validity once (pure arithmetic: Lemma 1 +
"mirror reply is available", which follows from symmetry — no search); (2) for each
exception entry, verify the reply is legal and the resulting position re-enters a certified
class (either back to symmetric-with-rule, or into a finite endgame table); (3) verify
coverage: every diagonal strike from every reachable symmetric class has an entry. (3) is
the crux.

**Where it can collapse — the uniformity question (open, cheap to probe)**: the reachable
symmetric positions are exponentially many (any set of mirror pairs), so naive coverage is
hopeless. The certificate is small iff refutations are (near-)UNIFORM: a fixed reply
function f(d) (or a small position-feature-indexed family) refutes the strike d across all
symmetric contexts where the relevant squares are live. Whether that holds is an empirical
question the existing engine can answer at n = 10, 12 in minutes-scale runs: for each
diagonal strike, is the engine's refuting reply constant across sampled symmetric contexts?
If yes, the whole n ≤ 16 P-verdict chain compresses to: mirror rule + a per-n table of
O(n) strike→reply entries + recursion into smaller certified classes — plausibly a
few-kilobyte artifact per n, independently checkable without trusting either solver. If no,
the certificate degrades gracefully: strike-rooted proof DAGs only (the mirror rule still
deletes the non-diagonal branching, which is the overwhelming majority of the root fan-out).
**Status: format PROVEN-sound as stated; size = open empirical question.**

**Contrast**: a full strategy-DAG certificate at n=16 scale is on the order of the search's
explored-position set — a multi-GB object whose verification is itself a big computation.
The rule+exceptions form is the difference between "trust our two engines" and "check this
file over lunch". Same applies to a hypothetical n=20 P-verdict (if BB is wrong), and — via
τ + border exception book — an N-certificate for n=18's I9 line is the analogous (harder)
target: the geometry note shows pure τ-mirror is not the engine's played strategy, but a
certificate need not match engine play, only be valid.

---

## 6. Search applications beyond the queued three

Queued already (nimber handoff): diagonal-first root scheduling, ρ(m) mirror-reply ordering
hint, symmetric-diagonal-free instant leaf at h=0. New, in rough value order:

1. **Extend the symmetric leaf to ALL heap values — sound and strictly more general.**
   Theorem 3 gives `avail = ρ(avail) ∧ avail ∩ diagonals = ∅ ⟹ G(avail) = 0` (P ⟺ G=0).
   In the heap-sum engine that decides every (avail, h): mover wins iff h ≠ 0. Same ~10
   bit-ops as the queued h=0 test, but it fires in the k ≥ 1 rounds too. PROVEN-sound.
2. **Center-root instant refutation in odd-n k ≥ 1 rounds.** The center opening's residual
   is symmetric and diagonal-free BY CONSTRUCTION (Lemma 2) at full board size — lever 1
   evaluates it for free, deleting what is plausibly the largest root subtree of every
   odd-n k ≥ 1 round (relevant to G(17) k=1 and G(19)/G(21) later). The k=0 rounds
   dually get "search the center root first" for the WIN proof. PROVEN-sound; wall impact
   unmeasured (the deep tail is asymmetric, but this fires at the ROOT, not the tail —
   unlike the queued leaf test, a wash argument does not apply).
3. **Theorem-3 regression gate (free correctness test)**: every non-diagonal even-n opening
   must have G ≥ 1 (theory note §5.2). Cheap at n = 10, 12; catches engine bugs AND theory
   gaps simultaneously.
4. **Symmetric-lattice search decomposition — speculation.** Theorem 3's proof implies an
   alternative even-n root algorithm: search only over (symmetric position, diagonal strike)
   pairs — non-diagonal moves are absorbed by the mirror rule, so the "upper" search tree is
   indexed by opponent pair-choices only (a half-dimensional lattice), with a general
   sub-search spawned per strike. The post-strike subtrees are the same giant tails the
   current engine fights, so the win is bounded; but as a PROOF-ORIENTED mode (it emits
   exactly the §5 certificate) it may be worth building once, at n = 10..12 scale.
5. **Border/Δ-aware reply ordering at even-n roots — heuristic.** After a diagonal strike,
   the theory says the refutation (if any) lives in border moves and scar-set (Δ) moves;
   order those first when REFUTING diagonal roots. Complements the PV observation that
   losing replies hug the diagonals (diag-dist ≤ 1) — a "diagonal-distance" ordering
   feature, one-sample evidence, cheap A/B.
6. **Near-symmetry (symmetric-modulo-j) equivalences — DEAD as a sound lever.** There is no
   Lipschitz bound relating G(X) and G(X ∖ {v}) in Node-Kayles (vertex deletion can move
   the value arbitrarily), so "j squares off symmetric" licenses nothing exact. Only viable
   as an ordering/prior feature, not a pruning/TT rule. Recorded to prevent re-derivation.
7. **Mirror-pair transposition folding**: exact ρ-image merging is already inside D4 canon;
   a dedicated half-key for symmetric positions would save memory only on a class that is
   thin in the deep tail — expected wash, noted for completeness.

---

## 7. Publication and community angle

**Is it a coherent note? Yes — one clean arc**: definitions + Lemma 1 + Lemma 2 (folklore,
formalized) + Theorem 3 (new, and the paper's heart) + new values G(14..16) = 0,1,0 (+
G(17) imminent) + the n=18 first-player win breaking the conjectured even→0 pattern, with
the I9-on-the-main-diagonal corroboration + the two-engine/differential-oracle validation
story. Optional lift: §3's Master Lemma + solved families (bishops/knights/torus) as a
short "the technique elsewhere" section — referee-pleasing breadth at near-zero cost,
IF the folklore check clears (below).

**Venues, in recommended order**:
- **arXiv note first** (math.CO, cross-list cs.DM/math.CO game theory) — immediate,
  citable, and the OEIS reference target. This is the Dekking–Shallit–Sloane community's
  normal pipeline.
- **INTEGERS** (has a combinatorial games section; publishes exactly this genre:
  computation-plus-structure notes on impartial games) — the natural journal home.
- **ELJC** — higher bar; plausible with the §3 breadth section and a tightened BB story.
- **Games of No Chance** (MSRI volumes) — right audience, slow/irregular cycle; treat as a
  later expanded-version target, not the first submission.

**What referees will demand** (preempt all four):
1. **Novelty check on Lemma 2 / the mirror observations.** Center-steal on odd boards is
   folklore-adjacent; Noon & Van Brummelen (2006) likely prove odd-n first-player win —
   the primary text was NOT read this session ([V-sum] only). REQUIRED pre-submission:
   read it, plus the Brown et al. nimber-sequences paper, and check knight/bishop mirror
   folklore. Theorem 3's diagonal reduction and the n ≥ 14 values are safe novelty; the
   framing must cite precedents correctly or a referee will do it for us.
2. **Reproducibility of the computations.** Describe both engines (heap-sum nimber engine;
   production outcome solver), the validation chain (full-mex agreement n ≤ 8, OEIS match
   n ≤ 13, cross-config reproduction, the n=18 dual-config + independent-oracle story,
   Jenrich n ≤ 16 reproduction), and publish the code ref. This project's existing
   validation discipline is unusually strong — say so plainly in the paper's terms (state
   the checks; let them speak).
3. **Airtight proof writing**: Theorem 3's induction needs the availability argument
   ("ρ(s) survives X's move") and the finite-termination framing spelled out; Lemma 1 as
   pure arithmetic; scope statements (outcome vs value) explicit.
4. **Pending values**: G(17) should be IN the paper (it lands within days). G(18)'s exact
   value is the difference between a good note and a strong one; with the k=1-first plan it
   is ~55% a one-search wait. Recommendation: draft now, hold submission for G(17) (near-
   mandatory) and for one G(18) round if the box schedule allows; if G(18)=1 lands, the C1
   conjecture (`G ∈ {0,1} for n ≥ 9`) becomes the paper's closing conjecture with real
   support.

**OEIS etiquette (A344227)**: b-file extension must be consecutive — a(14), a(15), a(16)
now, a(17) when it lands; a(18) CANNOT enter the b-file until the exact value is computed
(outcome ≠ term). The n=18 result goes in as a COMMENT ("first player wins the n=18 game,
so a(18) ≠ 0, refuting the conjectured even→0 pattern; see [arXiv link]") — which requires
the arXiv note to exist first for the reference. Also propose updating/annotating the
existing conjecture comment rather than deleting it (OEIS norms favor documented
refutation). Author-name and wording decisions are the user's.

---

## 8. Falsifiable predictions

| # | prediction | confidence | falsifier / note |
|---|------------|-----------|-------------------|
| P1 | G(17) = 1 | ~88% | in flight today; k ≥ 2 LOSS round refutes (theory-note prior, unchanged) |
| P2 | G(18) ∈ {1,2,3}, mode 1 | 55/30/12 | theory-note prior, unchanged; run k=1 first |
| P3 | **G(20) ≠ 0** | ~70% | the border-battle reading: the battle tips at 18 with 32 live border squares vs a 17×17 paired region; at 20 the ratio (36 vs 19×19) is strictly more favorable to the striker, and no counter-mechanism is visible. Falsified by a G(20)=0 verdict — which would kill every monotone version of BB and force a modular/regime reading (cf. the n=8 warning, §1.4) |
| P4 | G(20) = 1 given G(18) = 1 | ~75% | same mechanism ⟹ same value; a 18→20 value drift would locate a second parameter |
| P5 | odd persistence: G(19) = G(21) = 1 | ~90% each | any odd k ≥ 2 LOSS round refutes; G ≥ 1 is PROVEN so the risk is only upward |
| P6 | the winning even-n openings are CENTRAL diagonal squares (the (n/2−1, n/2−1) class), not outer diagonal squares | ~75% | checkable at n=18 (root table exists) and n=20; embedded-odd-center mechanism predicts centrality, Theorem 3 alone only predicts diagonality |
| P7 | at n = 10..16 the refutation of the central-diagonal opening routes through the border/Δ mechanism (a border move or a scar-set strike appears in the refuting PV) | ~60% | the §1.5 experiment decides it; a pure-inside-S refutation would falsify and send BB back to the drawing board |
| P8 | every diagonal opening at even n ≤ 16 has G ≥ 1, every non-diagonal opening at even n has G ≥ 1, odd-n center residuals have G = 0 | ~99% (these are theorems + engine-correctness checks) | failures indicate engine bugs or a Lemma 1/Theorem 3 gap — this is the §6.3 gate |
| P9 | where the next surprise lives, ranked: (i) G(18) ∈ {2,3} (45% combined); (ii) an odd-n value > 1 at some n ≥ 19 (the odd analog of the 18-breakage; nothing protects "exactly 1"); (iii) G(20) = 0 (regime re-entry — would be the most theoretically informative outcome on the board) | — | listed so the surprises are pre-registered, not post-hoc |

---

## 9. Ranked "what to do next"

Expected-value ranking across theory sessions, cheap experiments, and paper steps:

1. **[paper, ~free]** When G(17) lands: record it, then fire the G(18) k=1 round per the
   existing plan (mirror-reply ordering A/B first, per the nimber handoff). Everything
   downstream (paper strength, C1, P2/P4) hangs on these two numbers.
2. **[experiment, cheap, box-gated]** §1.5 refutation-geometry study at n = 10..16 (one
   sub-position solve + PV extraction per n) + enumerate n=8's winning openings. Decides
   P7, calibrates the BB proof shape, and defuses/confirms the n=8 monotonicity warning
   before any proof effort is sunk.
3. **[engine, hours]** §6.1 + §6.2: generalize the symmetric-diagonal-free leaf to h ≥ 1
   and add the center-root fast path for odd k ≥ 1 rounds — sound, tiny, and aimed exactly
   at the G(17)/G(19) round profile. Plus the §6.3 correctness gate at n = 10, 12.
4. **[paper, days]** Pre-submission lit check (read Noon–Van Brummelen; folklore check on
   knight/bishop/transitivity results), then draft the arXiv note (Lemma 1 + Lemma 2 +
   Theorem 3 + values + n=18 + validation appendix). Hold for G(17).
5. **[theory session]** Border-battle formalization push: write up B1/B2a/B2b/B3 as
   standalone lemmas (they are done — this note), then attack the Δ-battle with the
   Erdős–Selfridge-style budget frame, INFORMED by item 2's data. Do not start the counting
   argument before item 2 reports — the n=8 warning says the proof shape is not yet known.
6. **[experiment, cheap]** §5 certificate-uniformity probe at n = 10, 12 (is the refuting
   reply to each diagonal strike context-uniform?). If yes, build the rule+exceptions
   certifier — an independently checkable artifact for every even-n P-verdict, and a
   second-source validation of the whole n ≤ 16 chain.
7. **[theory, low]** §3 follow-ups: close kings-even via finite scar analysis (the O(1)
   exceptional set makes it the easiest open family); write the torus/transitivity
   observation up properly (G ∈ {0,1} on vertex-transitive graphs) after a literature
   check — it may be a known folk theorem.
8. **[park]** Misère queens: real project, no shortcut engine, weak transfer (§4). Revisit
   only if a misère-quotient expert collaboration materializes or the community asks.
