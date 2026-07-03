# Winning geometry across the even boards, and the n=20 candidate map (2026-07-03)

**Scope**: THEORY + CHEAP COMPUTATION ONLY. No solver runs, no builds; every computation here
is scratchpad Python (exhaustive brute force n ≤ 12, O(n²) arithmetic elsewhere), single-
threaded and box-safe. Companion to:
- [conjecture theory](2026-07-02-a344227-conjecture-theory.md) — Lemma 1/2, Theorem 3
- [theory implications](2026-07-02-theory-implications.md) — border battle (B1/B2a/B2b/B3), Conjecture BB
- [n=18 PV geometry](2026-07-02-n18-pv-geometry.md) — τ-pairing, live L-border, deletion schedule
- [placement-games primer](2026-07-02-placement-games-primer.md) — Copying Lemma, Mirror-Obstruction Lemma

**Status legend**: **PROVEN** (written proof), **COMPUTED** (exhaustive machine check at the
stated sizes, this session), **SUPPORTED-BY-ALL-DATA** (consistent with every solved board we
own, no counterexample, no proof), **CONJECTURE** (mechanism argument), **SPECULATION**.

Notation as in the companions: `ρ(r,c) = (n−1−r, n−1−c)`; for even n, `m = n/2 − 1`,
`c* = (m,m)` (the central main-diagonal strike; I9 at n=18), `S = [0..n−2]²` (the embedded
odd sub-board), `τ(x) = (n−2,n−2) − x` (point reflection of S about c*), `L` = live border,
`R_n` = B_n after c*, `Δ` = scar set = live S-squares whose τ-partner is dead.

---

## 0. New computed ground truth (a fourth independent implementation)

A from-scratch Python brute-forcer (bitmask memoized win/loss search + a full-mex Grundy
variant; `small_boards.py`, `grundy_small.py` in the session scratchpad) — independent of the
production solver, the heap-sum engine, and the `naive` reference — reproduces **every value
it can reach**: `G(5..10) = 3, 1, 2, 3, 1, 0` (A344227 exact), outcome verdicts n = 4..12
(even: N, N, N, P, P; odd: all N). Everything below marked COMPUTED rests on this
cross-validated base.

**Winning opening classes (mod D4), exhaustive for n = 4..12:**

| n  | verdict | winning opening classes (of total)         | max-deletion square wins? |
|----|---------|--------------------------------------------|---------------------------|
| 4  | N       | (1,1)=c*, (0,0)                (2 of 3)    | yes — c*                  |
| 5  | N       | center, (1,2)                  (2 of 6)    | yes — center              |
| 6  | N       | (2,2)=c*, (1,1), (0,0), (1,2), (0,2) (5/6) | yes — c*                  |
| 7  | N       | center, (1,3)                  (2 of 10)   | yes — center              |
| 8  | N       | **(3,3) = c* — UNIQUE**        (1 of 10)   | yes — c*, uniquely        |
| 9  | N       | center, (2,4), (1,3), (0,1)    (4 of 15)   | yes — center              |
| 10 | P       | none                           (0 of 15)   | vacuous (all lose)        |
| 11 | N       | **ALL 21 classes win**                     | yes — trivially           |
| 12 | P       | none                           (0 of 21)   | vacuous (all lose)        |

Root option-value (Grundy) histograms mod D4, n ≤ 10 (COMPUTED; executes deferred
experiment 4 of the conjecture note at n = 7/9):

| n  | root option G-histogram      | mex = G(n) | reading                                    |
|----|------------------------------|------------|--------------------------------------------|
| 5  | {0:2, 1:1, 2:1, 4:2}         | 3          | option values 4 exist (> any root value!)  |
| 6  | {0:5, 2:1}                   | 1          | the one loser (0,1) has G=2                |
| 7  | {0:2, 1:2, 3:6}              | 2          | the G=1 options are what lift n=7 to 2     |
| 8  | {0:1, 1:3, 2:6}              | 3          | c* is the only G=0 option                  |
| 9  | {0:4, **3:11**}              | 1          | NO G=1 or G=2 option — mex=1 as predicted  |
| 10 | {**1:15**}                   | 0          | perfectly uniform: every opening has G=1   |

- **n=9 verifies the §1a clause of the conjecture note**: the root has G=0 options and no
  G=1 option, so `mex = 1` — and the nonzero options are all *exactly 3* (sparse spectrum).
- **n=11 explains its own G=1**: every option is a P-position, so the option set is {0}
  and `mex = 1`. (Boolean run; consistent with A344227's G(11)=1.)
- **G(R_n) so far** (residual of the central strike): `G(R_6)=0, G(R_8)=0, G(R_10)=1,
  G(R_12)=1` (COMPUTED), `G(R_18)=0` (the production n=18 result), `R_14`/`R_16` open —
  exactly experiment 1 of the conjecture note §5.

---

## 1. Invariants mined from the winning/losing structure

### 1.1 The max-deletion (most-forcing-root) law — SUPPORTED-BY-ALL-DATA

> **Candidate law (Forcing-Root Conjecture).** On every N-board, the maximum-deletion
> square (the unique-mod-D4 most-forcing square: the center for odd n, the central-diagonal
> class c* for even n) is a winning opening. Equivalently: **a board is an N-position ⟺
> its most-forcing square wins.**

Evidence, all of it: odd n — the center is the max-deletion square and wins (Lemma 2,
PROVEN, all odd n). Even n — COMPUTED at 4, 6, 8 (c* wins; at 8 uniquely); vacuously
consistent at 10, 12 (COMPUTED all-lose) and at 14, 16 (production P-verdicts); **n=18: the
witness I9 IS c***, the board max at 68 deletions. No solved board contradicts it. Not a
theorem: nothing prevents a hypothetical even N-board whose c* is refuted while an outer
diagonal (or non-diagonal) root wins — but it has never happened.

- The law is **vacuous on P-boards** (there are no winning openings to constrain), so the
  n ≤ 16 refutations cannot falsify it; they are consistent with it.
- **Uniqueness fails small**: n = 4, 5, 6, 7, 9, 11 all have additional winning openings
  (n=9 even has the edge square (0,1)). n=8 is the only board where c* is the unique winner.
  The law is about *membership*, not uniqueness.
- **Search consequence if promoted to a theorem**: the even-n outcome question collapses to
  ONE root solve (c* refuted ⟹ P; c* wins ⟹ N). Even unproven it is the strongest known
  root-ordering prior (and is what the degree ordering already does).

### 1.2 Is the witness's diagonality forced by Theorem 3? — NO (PROVEN by counterexample)

Theorem 3 (PROVEN) forces every winning *line* to contain a long-diagonal move; it does
**not** force the winning *root* to be diagonal. This is now not just a logical gap but a
computed fact: **at n=6 the non-diagonal openings (1,2) and (0,2) win** (their winning lines
strike a diagonal later). So I9's position *on* the main diagonal is not logically forced by
the theorem — what the theorem plus the data support is the *mechanism* reading: the
embedded-odd-center structure (below) is only available at c*, and every solved even N-board
has c* among its winners. Whether any non-diagonal n=18 root also wins is UNKNOWN (the run
was existential: 1 of 45 root classes searched).

### 1.3 The mirror-gap invariant, and the parity corollary stated exactly

The Mirror-Obstruction Lemma's parity corollary (primer §3) is about the **displacement
vector, not the square's coordinates**: for even n, `2(p−s) = (n−1−2r, n−1−2c)` has **both
coordinates odd** for every square. (I9 = (8,8) has both coordinates *even* — the version of
the corollary that assigns odd coordinates to self-mirroring squares is a mis-remembering;
Lemma 1's actual content is that the self-mirroring squares are the two long diagonals.)

For a main-diagonal square `(d,d)` the vector is `(n−1−2d)·(1,1)`: define the **mirror gap**
`gap(d) = n−1−2d` (always odd). The central class has `gap = 1` — the winning strike is the
diagonal square *closest to its own ρ-image*. Ranking diagonal roots by gap = ranking by
centrality = ranking by deletion count (all equivalent on the diagonal; PROVEN arithmetic).
gap(I9) = 1; the n=20 analog with gap 1 is (9,9).

### 1.4 The τ-scar structure of the n=18 PV — COMPUTED (one line; loser moves are ordering artifacts)

Per-ply scar trajectory (`scar_trajectory.py`; W = winner/first player, L = loser):

| ply | move | who | region | in Δ before? | τ-partner live? | Δ after | border (colR,row18) |
|-----|------|-----|--------|--------------|-----------------|---------|---------------------|
|  1  | I9   | W   | S      | —            | —               |  0      | (16,16)             |
|  2  | K8   | L   | S      | no           | yes             | 41      | (13,14)             |
|  3  | G10  | W   | S      | yes          | no              |  0      | (12,12)             |
|  4  | J11  | L   | S      | no           | yes             | 35      | (10, 9)             |
|  5  | H3   | W   | S      | yes          | no              | 27      | ( 9, 8)             |
|  6  | M7   | L   | S      | yes          | no              | 23      | ( 6, 6)             |
|  7  | N16  | W   | S      | no           | yes             | 26      | ( 5, 3)             |
|  8  | E4   | L   | S      | yes          | no              | 17      | ( 3, 2)             |
|  9  | P6   | W   | S      | no           | yes             | 18      | ( 2, 1)             |
| 10  | D12  | L   | S      | yes          | no              |  9      | ( 2, 1)             |
| 11  | O13  | W   | S      | yes          | no              |  4      | ( 2, 1)             |
| 12  | F2   | L   | S      | yes          | no              |  4      | ( 1, 0)             |
| 13  | R5   | W   | border | no           | —               |  3      | ( 0, 0)             |
| 14  | L17  | L   | S      | yes          | no              |  1      | ( 0, 0)             |
| 15  | A14  | W   | S      | yes          | no              |  0      | ( 0, 0)             |

The readable structure:

1. **Exactly one mirrored exchange** — G10 = τ(K8) restores perfect S-symmetry (Δ back to 0
   at ply 3), then the winner *abandons* τ at ply 5 even though τ(J11) was live. Pure
   τ-mirroring is not the winning strategy; it is the opening posture.
2. **From ply 6 to the end, every loser move lands inside Δ** — the loser is confined to
   scar squares, and each such move *consumes* scar (playing a Δ-square removes it). |Δ|
   measured after the winner's successive replies runs 0, 27, 26, 18, 4, 3, 0 — monotone
   down after the ply-4 spike (the winner twice breaks a live τ-pair himself, plies 7 and 9,
   each time compensated within the exchange) — and the winner makes the last move.
3. **One border move in the whole game — the winner takes the LAST live border square**
   (R5 at ply 13, when the live border had shrunk to a single square). Border tempo denied
   to the loser. (B1's "at most two border queens" bound: satisfied with one.)
4. The border arms erode in near-balance throughout (max imbalance 2) — the B3
   arms-balance mechanism visible in play.

So the answer to "does the defense track a recognizable pairing strategy with a bounded
exception set" is: **the WINNER'S strategy does** — τ-mirror posture, a bounded number of
border events (here one), and a Δ-consumption endgame in which the *opponent* is the one
forced into the unpaired squares. Caveat: loser moves in a won PV are ordering artifacts;
this is one line, not a strategy extraction. Status: COMPUTED trajectory, CONJECTURE that
the Δ-confinement shape is the general winning mechanism.

### 1.5 Border tempo is THE refutation resource — COMPUTED (n = 8, 10, 12), the P7 upgrade

Three modified-game experiments on `R_n` (`border_ablation.py`), all exhaustive:

| n  | win(R)      | win(R ∩ S), border deleted | intruder border-banned       | responder border-banned  |
|----|-------------|----------------------------|------------------------------|--------------------------|
| 8  | P (c* wins) | P (must be, Lemma 2)       | P — intruder still loses     | **N — c* win COLLAPSES** |
| 10 | N (refuted) | P                          | **P — refutation COLLAPSES** | N                        |
| 12 | N (refuted) | P                          | **P — refutation COLLAPSES** | N                        |

- `win(R ∩ S) = P` machine-verifies the embedded-odd-center identity (the sub-board part of
  R_n literally *is* B_{n−1} after the center; Lemma 2 applies verbatim).
- **At n = 10 and 12, an intruder forbidden from ever playing a border square cannot refute
  c***: every refutation *requires* intruder border tempo. This upgrades prediction P7 from
  "the refuting PV tends to route through the border" (~60 % prior) to **necessity, proven
  by exhaustion at 10 and 12**. The Δ-scar mechanism alone (inducing responder self-scars
  from inside S) is NOT sufficient to refute the strike at these sizes.
- **Dually, at n = 8 the responder needs the border too**: banned from it, the c* win flips
  to a loss (and the extracted n=8 winning line indeed contains a responder border move).
  The border battle is genuinely two-sided; the whole even-n question is who profits from
  the ≤ 2 border events (B1).
- In all three extracted optimal lines (n=8 win, n=10 refutation, n=12 refutation) **the
  side that wins R_n makes the last border move**. Border-tempo parity as the decision
  mechanism: CONJECTURE (three lines, ordering-artifact caveat), but it is the single most
  actionable new pattern — and it matches the n=18 PV (winner takes the final border square).

### 1.6 The refutation-margin puzzle — COMPUTED, pre-registered as open

Fraction of replies in R_n that refute c* (depth-1 margin): n=8 **0/36** (c* wins), n=10
**8/64**, n=12 **100/100** (every reply wins for the intruder!), n=18 **0/256** (R is P).
The margin is violently non-monotone inside the P-band even though `G(R_10) = G(R_12) = 1`.
At n=10 the strike nearly survives; at n=12 it fails against literally any reply; at n=18 it
wins. **No smooth "the strike gradually strengthens with n" story fits this.** Deferred (one
cheap engine run each): the margins at n=14, 16 — a decreasing tail 100% → … → 0% into n=18
would at least restore an interval structure; another hump would demand a modular reading.

Also COMPUTED at n=10: the four S-square refuters {(2,3),(3,2),(5,6),(6,5)} are all
**knight-neighbors of c*** — the nearest squares a queen does not attack. All eight
knight-neighbors are live in R_10; the refuting four are exactly those at diag-distance 1
from c*'s *main* diagonal (the strike's own line), while the four straddling the
anti-diagonal direction (e.g. (2,5), (6,3)) do not refute. The strongest intrusions hug the
strike point at knight range, on the strike's diagonal side (see §2d). The four border
refuters are {(1,9),(3,9),(9,1),(9,3)} — σ-pairs at odd offsets; the odd-offset pattern is
unexplained (SPECULATION-grade numerology at one n).

### 1.7 Why 18 and not 14/16 — sharpened negatively: no monotone scalar can decide it

A trivial but organizing observation (PROVEN): the even-n verdict sequence
`N, N, N, P, P, P, P, N` (n = 4..18) is non-monotone, so **no invariant monotone in n can
decide the even-board outcome**. Every scalar in our geometric family is monotone in n —
deletion count `|N[c*]| = 4n−4`, residual `(n−2)²`, live border `2(n−2)`, sub-board live
`(n−2)(n−4)`, border/area ratio `2/(n−4)` (decreasing) — so **all of them are individually
disqualified as deciding invariants**. Any true threshold criterion must be non-monotone
(modular, spectral, or genuinely game-tree-deep). The border-battle frame survives this
filter only in its two-regime form: at n ≤ 8 the border is comparable to the paired area
(ratio 0.50 at n=8) and the game is short-range tactics; the perturbation regime (border ≪
area) starts at n ≈ 10, and *within that regime* the only wholly-inside-it data are
P, P, P, P, N (10..18) — monotone so far, and the intruder's border resource shrinks
relative to the τ-paired territory as n grows. Status of the regime story:
SUPPORTED-BY-ALL-DATA within n ≥ 10, but §1.6's margin hump says the approach to the flip
is not smooth. The mechanism is localized (border tempo, §1.5); the threshold is not.

### 1.8 Root-spectrum sparsity — COMPUTED small, CONJECTURE beyond

The root option-value spectra are startlingly thin: {1} at n=10, {0} at n=11, {0,3} at n=9.
**Conjecture S**: for even P-boards n ≥ 10, every opening has G = 1 (checkable for n=12,
14, 16 with the heap-sum engine one ply down — experiment 1 of the conjecture note §5
already covers the diagonal openings; this extends it to all classes). If true, the even-P
structure is "every child is *"; combined with n=11's all-children-P it suggests the
odd/even alternation near the root is a two-level `0 ↔ 1` resonance — which would make
G(17)=1 and G(19)=1 near-mechanical and G(18)'s exact value the real outlier probe. This is
the cleanest new theory target this session produced.

---

## 2. Missed-structure inventory

For each item: the structure, the lever it could yield, and the cheapest falsifier.

**a. The τ-quotient inside the c* subtree — the best unexploited symmetry.**
Any position with live set ⊆ S is literally a position of the (n−1)×(n−1) board game, and τ
(= that board's ρ) is a graph automorphism there — but τ is NOT a D4 symmetry of the n-board,
so the production `d4_bits` canon never folds it. Two sound levers: (i) **instant leaf**:
after c*, the four central lines of S are dead forever, so a reachable τ-symmetric live set
⊆ S has no live self-mirroring square ⟹ **P by the Copying Lemma** — a ~10-bit-op test, the
sub-board twin of implications §6.1; (ii) **TT fold**: canonicalize live-⊆-S positions under
τ (up to 2× merge on that class). Falsifier/sizing (box, minutes): instrument an n=14 c*
subtree for the fraction of nodes with live ⊆ S and the τ-symmetric fraction — if the live
set leaves the border occupied-or-dead early (the PV suggests border squares die fast), the
class is fat and (i) fires often. PROVEN-sound; size unknown.

**b. Border-tempo accounting as ordering/pruning.**
§1.5's necessity result says refutation searches (the P-side of every even root, and every
prove-a-loss node under a diagonal strike) should try **border moves and Δ-strikes first**
— the intruder's win must cash a border move, so lines that exhaust the border early
resolve fastest. Complements the existing diagonal-first root ordering, which the notes
already queue; this is the *within-subtree* analog. Falsifier: n=12/14 A/B on refuting c*
with border-first child ordering (cheap; the harness exists). Related endgame heuristic:
"last live border square is gold" — a leaf-adjacent tiebreak. All CONJECTURE until A/B'd.

**c. Anti-diagonal classes are a phantom distinction — PROVEN, worth recording.**
All four central cells of an even board form ONE D4 orbit ((m,m) ↔ (m,m+1) under the
vertical reflection), and each main-diagonal class (d,d) already contains its anti-diagonal
partners. There is no separate anti-diagonal candidate list; nothing was missed, but the
paper should say "the central class", singular, to kill the recurring "two main + two anti"
miscount (the diagonal classes mod D4 are exactly (d,d), d = 0..m).

**d. Knight-distance strata — a real mechanism after all, but only at radius 1.**
A queen's nearest NON-attacked squares are precisely its knight-neighbors — so "knight
shell of the strike" is the natural "closest intrusion" stratum, and at n=10 the S-refuters
are exactly the main-diagonal-hugging half of that shell (§1.6). Lever: move-ordering
feature for refutation search (knight-neighbors of the last placed queen first), stackable
with (b); possibly a killer-table index. Falsifier: does the n=14 c*-refutation reply set intersect the knight shell of c*?
(One engine query.) Deeper strata (knight-distance ≥ 2) have no mechanism — the attack
geometry is line-based, and n=12's all-squares-refute wipes any radial signal; treat as
noise. Status: observation COMPUTED at one n; the ordering lever is CONJECTURE.

**e. The live border as a 1-D subgame — bounded, so make it a certificate object.**
B1 (≤ 2 border queens, PROVEN) + §1.5 (border tempo decides) means the border's *entire*
game-theoretic content is: which side banks the ≤ 2 border tempi, at what S-scar price. A
border state is (row-arm bitmask, col-arm bitmask) with attack cross-links only at r = c
(B2b) — small enough to tabulate exactly per (arm sizes, parity-to-move) and stitch into
the §5-style certificate: mirror rule + strike book + **border-tempo table**. Lever: this
is the missing piece that would turn Conjecture BB's branch-2/3 case analysis into a finite
check per n. Falsifier: build the toy table (pure Python, the arms are cliques + a
matching) and test its prediction of who wins R_n's border race against the n = 8/10/12
exhaustive answers. SPECULATION → cheap to promote.

**f. Δ as a budget/potential — now with an empirical curve.**
§1.4's |Δ| trajectory (41 → 0 → 35 → 27 → … → 0, winner last) is the first measured scar
budget. The Erdős–Selfridge-style proof shape the implications note wants needs a potential
that (i) the responder can always decrease, (ii) the intruder can raise only via border
events (bounded by B1), (iii) reaches 0 with the responder to move last. Candidate: |Δ|
plus a border-tempo term weighted by parity. Falsifier: compute the same trajectory for the
n=10/12 *refutations* (scripts exist) — if the intruder wins there while |Δ|+tempo says
otherwise, the potential is wrong. SPECULATION; the data pipeline is now trivially cheap.

**g. Certificate uniformity — the n=10 refuter list is the first book page.**
The strike-refutation book of implications §5 needs, per diagonal strike, a reply valid
across symmetric contexts. At n=10 ANY of 8 replies refutes c*; a canonical choice (say the
σ-least knight-shell square) is a book entry candidate. Falsifier at n=10/12: is that same
reply refuting after each *pair* of mirrored non-diagonal moves (sampled symmetric
contexts)? Pure Python at n=10 (the memo fits); engine-scale at 12+.

**h. Quotient by the first move's stabilizer — mostly already banked.**
The stabilizer of c* in D4 is {id, transpose-about-the-main-diagonal}, and the position-
level D4 canon already folds σ-images of *positions*, so nothing further at the root. The
genuinely un-folded symmetry is τ (item a). The one residual idea: cross-root, the 10
diagonal classes at n=20 have pairwise-isomorphic *deep* subposition sets reachable from
different roots — already exploited implicitly by the shared TT, and measured weak
(cross-root duplication ≈ 1.1×, umbrella session --9). Dead unless the τ-fold revives it.

**i. Game-length / elimination parity — still the cheapest untouched dial.**
Every optimal line we own ends with total length odd ⟺ first wins (n=18: 15; R_10
refutation: 8 total; R_12: 10 total — even, intruder = mover #2 in the full game, wins).
The deferred experiment (geometry note): do P-boards force even length under optimal play
*everywhere* or only at the root? The heap-sum engine emits lengths for free. If maximal-
play parity is board-forced in some band, that is a rank-1 invariant; the rooks solution
(primer §4.3) is the degenerate case. SPECULATION, one engine flag away.

---

## 3. The n=20 prediction

### 3.1 What Theorem 3 does and does not license at the root

Precise statement (PROVEN): a first-player win must *play a long-diagonal square at some
point*; every diagonal-free line loses to the ρ-mirror. It does **not** restrict the
winning root (§1.2, n=6 counterexample). Therefore:

- For the **N-hunt** (find one winning root): theory backs the diagonal roots — they are
  the only roots with a known win *mechanism* (embedded-odd-center for c*; a diagonal move
  is mandatory eventually anyway) — and §1.1's law backs c* specifically. Non-diagonal
  roots are possible witnesses in principle but have no mechanism story and no precedent
  as *first* winners (at every computed even N-board, c* wins too).
- For a **P-proof** (all roots refuted): Theorem 3 already collapses the *strategy*
  certificate (mirror rule + diagonal-strike book, implications §5) but the search must
  still refute all 55 root classes. A proven Forcing-Root law (§1.1) would collapse the
  N-question to one root; nothing currently licenses skipping roots in a P-proof.

### 3.2 The candidate set, enumerated (n = 20, mod D4)

Root classes: **55** total (n(n+2)/8), of which **10 diagonal**: (d,d), d = 0..9 (each
class contains its anti-diagonal partners; §2c). Full rankings (`n20_candidates.py`):

| d | square | deletions | mirror gap 19−2d | τ_d window (2d+1)² | live outside window |
|---|--------|-----------|------------------|--------------------|---------------------|
| 9 | (9,9)  | **76**    | **1**            | **361 = 19×19**    | **36**              |
| 8 | (8,8)  | 74        | 3                | 289 = 17×17        | 102                 |
| 7 | (7,7)  | 72        | 5                | 225 = 15×15        | 160                 |
| 6 | (6,6)  | 70        | 7                | 169 = 13×13        | 210                 |
| 5 | (5,5)  | 68        | 9                | 121 = 11×11        | 252                 |
| 4 | (4,4)  | 66        | 11               |  81 =  9×9         | 286                 |
| 3 | (3,3)  | 64        | 13               |  49 =  7×7         | 312                 |
| 2 | (2,2)  | 62        | 15               |  25 =  5×5         | 330                 |
| 1 | (1,1)  | 60        | 17               |   9 =  3×3         | 340                 |
| 0 | (0,0)  | 58        | 19               |   1 =  1×1         | 342                 |

**(9,9) dominates every invariant simultaneously**: board-max deletion (76 of 400 —
uniquely, as the central class), mirror gap 1, and the exact embedded-odd-center structure:
(9,9) is the center of the 19×19 sub-board [0..18]², its deletion set inside S is precisely
the four central lines of S (the Lemma-2 structure of B_19), residual (n−2)² = 324, live
L-border 2(n−2) = **36** (18 per arm), live sub-board 288, border/area ratio 0.125 — the
most striker-favorable ratio yet (n=18 was 0.143). Yes: **(9,9) embeds a 19×19-with-center
exactly the way I9 embedded 17×17 in 18×18** — the identity is general arithmetic
(implications §1.1), not an n=18 accident.

Non-diagonal head of the deletion order (for the tail of the root queue): (8,9) del 74,
then (7,8)/(7,9) del 72, (6,7)/(6,8)/(6,9) del 70, … — the near-central off-diagonal band.

### 3.3 Ranked shortlist and prediction

Root schedule for an n=20 N-hunt (deletion-descending, diagonal-first tie-break — which for
the head of the queue is also mirror-gap-ascending):

1. **(9,9)** — the c* class. All §1 invariants point here; if the board is N, every
   precedent says this is a witness (§1.1).
2. **(8,8)** — gap-3 diagonal; the first fallback if (9,9) is refuted (it never has been a
   *sole* winner in the data, but at n=6 outer diagonals win alongside c*).
3. **(8,9)** — the deletion-74 non-diagonal central neighbor; the strongest
   non-diagonal candidate (n=6 precedent: near-central non-diagonal openings can win).
4. **(7,7)**, then the remaining diagonals descending, interleaved with the
   deletion-ordered non-diagonal band per the table above.

**Prediction: n = 20 is a FIRST-player win, witness (9,9) (= J10 in letter-number
coordinates), confidence ~65 %.** Mechanism: the border-battle frame — the intruder's only
refutation resource is border tempo (COMPUTED necessity at 10/12, §1.5), that resource
shrinks relative to the τ-paired territory monotonically (0.143 → 0.125), n=18 is the first
size where the striker banks the border race in the perturbation regime, and nothing about
n=20 moves in the intruder's favor. Value prediction, conditional on N: G(20) = G(18)
(same mechanism ⟹ same value; the in-flight G(18) round will pin it — P4 of the
implications note, ~75 % conditional).

Why not higher than ~65 %: (i) the §1.6 margin puzzle proves the strike's fortunes are not
smooth in n even inside the P-band — a re-entry to P at 20 (the implications note's P9-iii)
cannot be ruled out by any invariant we tested, and would be the single most informative
outcome on the board; (ii) the two-regime story quarantining n=8 is itself only
SUPPORTED-BY-ALL-DATA; (iii) this confidence is deliberately a few points below the
implications note's P3 (~70 %) because the new non-monotonicity data cuts against every
smooth mechanism story, including ours. All of §3.3 is CONJECTURE + explicit speculation;
the *rankings* in §3.2 are arithmetic facts.

### 3.4 Search-guidance implications (for whenever an n=20 campaign is sized)

- **Root order**: (9,9) first, then as §3.3. An existential N-proof plausibly terminates
  inside the first root, as at n=18. Do NOT interpret Theorem 3 as licensing skipping
  non-diagonal roots in a P-proof (§3.1); a proven Forcing-Root law would license
  one-root *N-decision*, which is the cheap direction to formalize first.
- **In-subtree levers, new this note**: the τ-instant-leaf + τ-fold for live ⊆ S (§2a);
  border-first + knight-shell-first child ordering at refutation nodes (§2b/d); border-
  tempo endgame tiebreak (§2e).
- **Skip/capacity**: the n=18 recipe (band-skip + max flat TT) transfers; n=20's proving
  subtree is orders of magnitude beyond n=18's — size with HLL first, per standing
  discipline; nothing in this note argues for firing a run.
- **Cheap discriminators BEFORE any big run** (all engine-scale, minutes-to-hours, queued
  in priority order): (1) refutation margins + G(R_n) at n = 14, 16 (closes §1.6's hump
  question and extends §0's G(R) table); (2) Conjecture S check at n = 12 (all root options
  G = 1?); (3) the τ-fold sizing probe (§2a); (4) the border-first ordering A/B (§2b).
  Each reshapes the n=20 prior materially; (1) and (2) also feed the paper's structure
  section directly.

---

## 4. Summary of claim statuses

| claim                                                              | status                          |
|--------------------------------------------------------------------|---------------------------------|
| brute-forcer reproduces A344227 G(5..10) + verdicts n ≤ 12          | COMPUTED (validation)           |
| n=8: c* is the unique winning opening                               | COMPUTED                        |
| n=6: non-diagonal winning openings exist (Theorem 3 root-form fails)| COMPUTED / PROVEN counterexample|
| n=9 options {0,3} (mex-1 mechanism); n=10 options all 1; n=11 all 0 | COMPUTED                        |
| win(R ∩ S) = P (embedded-odd-center identity), n = 8, 10, 12        | COMPUTED (PROVEN in general)    |
| refuting c* REQUIRES intruder border tempo (n = 10, 12)             | COMPUTED (exhaustive)           |
| c*'s n=8 win requires responder border access                       | COMPUTED (exhaustive)           |
| max-deletion square wins every known N-board (Forcing-Root law)     | SUPPORTED-BY-ALL-DATA           |
| winner of R_n makes the last border move                            | CONJECTURE (3 lines + n=18 PV)  |
| Δ-confinement is the general winning endgame shape                  | CONJECTURE (one PV)             |
| no monotone-in-n scalar decides the even verdicts                   | PROVEN (trivial, organizing)    |
| refutation-margin hump (12.5 % → 100 % → 0 %)                       | COMPUTED, unexplained           |
| Conjecture S (even-P boards: all openings G = 1)                    | CONJECTURE (n=10 datum)         |
| n=20: first player wins via (9,9)                                   | CONJECTURE, ~65 %               |
| (9,9) tops all four geometric rankings at n=20                      | COMPUTED (arithmetic)           |

**Method note.** Scripts in the session scratchpad: `small_boards.py` (outcome + winning-
opening enumeration, n ≤ 12), `grundy_small.py` (full mex, n ≤ 10), `refutation_geometry.py`
(R_n refuter sets + PVs), `border_ablation.py` (border-deletion + ban games),
`scar_trajectory.py` (n=18 PV Δ/border trajectory), `n20_candidates.py` (n=20 tables),
plus the pre-existing `pv18.py`. All single-threaded, seconds-to-minutes, ≤ ~0.4 GB peak;
run while the G(17) computation owned the box, per the no-compile/no-solver constraint.
