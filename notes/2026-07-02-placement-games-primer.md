# Mirrors, parity, and one lemma: how placement games collapse — or where they refuse to

*A standalone primer on the Mirror-Obstruction Lemma and the closure mechanisms it feeds,
written for a reader with first-year mathematics (vectors, parity, induction). Everything
here is rigorous; proof status is marked throughout. Companion research notes:
[conjecture theory](2026-07-02-a344227-conjecture-theory.md),
[implications & extensions](2026-07-02-theory-implications.md) (which call this lemma the
"Master Lemma").*

The Non-Attacking Queens Game was studied by Noon and Van Brummelen, later by Jenrich, and
its Grundy values appear as OEIS A344227. This note does not introduce the game; it
isolates a general mirror-obstruction lemma and applies it uniformly to several chess-piece
placement games.

**What is known vs new here.** Known/classical: the impartial-game recursion, the rooks
solution, torus transitivity, and the odd-queens first-player win. New — or at least not
found in the checked literature: the unified Mirror-Obstruction Lemma, the even-queens
long-diagonal necessary condition, and the kings central-square reduction. (Literature
checks for the knight and bishop solutions are still queued; they are marked "presumably
folklore" below.)

---

## 1. The game

Fix a chess piece and an n×n board. Two players alternate placing a piece of that kind on
an empty square, subject to one rule: **no two placed pieces may attack each other**.
Captures never happen; pieces never move; both players place the *same* kind of piece.
If it is your turn and no legal square exists, **you lose** (this is called *normal play*:
the last player able to move wins).

Squares are written `(r, c)`, row and column indices starting at 0. Here is a full game of
4×4 **queens** (move numbers show who played: odd = player 1, even = player 2):

```
        c0  c1  c2  c3
      +----------------+
   r0 |  .   1   .   . |     Move 1: (0,1) by player 1
   r1 |  .   .   .   3 |     Move 2: (3,2) by player 2
   r2 |  4   .   .   . |     Move 3: (1,3) by player 1
   r3 |  .   .   2   . |     Move 4: (2,0) by player 2
      +----------------+
```

After move 4, check for yourself: every one of the twelve empty squares is attacked by some
queen. Player 1 has no move and **loses this game**. (Whether player 1 *had to* lose the
4×4 queens game is a different question — see §5.)

**P-positions and N-positions.** A position is a *P-position* if the Player who just moved
wins with best play (equivalently: the player *to move* loses), and an *N-position* if the
player to move (the *N*ext player) wins. The empty board being a P-position means the
second player wins the whole game. Working out which positions are which is what "solving"
the game means.

---

## 2. The mirror strategy — and exactly when it breaks

Rotate the board 180°. The square `s = (r, c)` lands on

```
    ρ(s) = (n−1−r, n−1−c).
```

The oldest trick in combinatorial game theory is **copying**: whenever your opponent plays
`s`, you reply `ρ(s)`. If you can always do this, you always have a move — so your opponent
runs out of squares first and loses. The question is whether the copy is always *legal*.
Exactly two things can go wrong:

1. **The fixed square.** If `ρ(s) = s` (only possible for odd n, at the center), there is
   no square to copy to.
2. **Self-mirroring squares.** If the piece on `s` *attacks* `ρ(s)`, then the opponent's
   move at `s` deleted your intended reply.

And that is the complete list — this deserves a proof, because it is the engine of
everything that follows.

**Copying Lemma (proven).** *Suppose the current position is ρ-symmetric (the set of placed
pieces is mapped to itself by ρ), it is the opponent's turn, and the opponent plays a legal
square `s` with (i) `ρ(s) ≠ s` and (ii) `s` does not attack `ρ(s)`. Then `ρ(s)` is a legal
reply, and after it the position is ρ-symmetric again.*

*Proof.* Could some earlier piece `q` attack `ρ(s)`? By symmetry the piece `ρ(q)` is also
on the board, and `ρ(q)` attacks `ρ(ρ(s)) = s` if and only if `q` attacks `ρ(s)` (rotating
the whole board preserves attacks). But nothing attacks `s` — the opponent just legally
played there. So no earlier piece attacks `ρ(s)`; by (ii) the new piece at `s` does not
attack it either, and by (i) it is not occupied. The reply is legal, and placing it
restores the symmetry of the placed set. ∎

So a mirror strategy is a *complete* winning strategy for the second player precisely when
the board has **no fixed square and no self-mirroring squares** — and where it is not
complete, its failure points are a short list of specific squares. That list is what the
Mirror-Obstruction Lemma computes.

---

## 3. The Mirror-Obstruction Lemma

Describe a piece by its **move-vector set** V: the piece on square `s` attacks square `t`
if and only if `t − s ∈ V` (as vectors). V is symmetric (`v ∈ V ⟺ −v ∈ V`). For example:

```
    knight:  V = { (±1,±2), (±2,±1) }                          (8 vectors)
    king:    V = { (±1,0), (0,±1), (±1,±1) }                   (8 vectors)
    rook:    V = { t·(1,0), t·(0,1)         : t ∈ ℤ, t≠0 }     (rays)
    bishop:  V = { t·(1,1), t·(1,−1)        : t ∈ ℤ, t≠0 }     (rays)
    queen:   V = rook ∪ bishop                                  (rays)
```

Let `p = ((n−1)/2, (n−1)/2)` be the board's center *point* (a square only when n is odd),
and note `ρ(s) = 2p − s`.

> **Mirror-Obstruction Lemma (proven).** The square `s` attacks its own mirror image if and only if
>
> `ρ(s) − s = 2(p − s) ∈ V.`

*Proof.* `ρ(s) − s = (2p − s) − s = 2(p − s)`; apply the definition of V. ∎

One line — but now compute the vector `2(p − s) = (n−1−2r, n−1−2c)` and look at its
**parity**:

- **n even** ⟹ `n−1` is odd and `2r` is even ⟹ **both coordinates are odd**.
- **n odd**  ⟹ **both coordinates are even** (and `s = p` itself is the fixed square).

So for each piece, the self-mirroring squares are found by asking: *which vectors in V have
both coordinates odd (even boards) or both even (odd boards)?* Every result in §4 is this
one parity check plus the Copying Lemma.

---

## 4. The case studies

### 4.1 Knights: parity annihilates everything — a complete solution

Every knight vector has **one odd and one even coordinate** — look at the list: `(1,2)`,
`(2,1)`, and their sign changes. A both-odd vector is never a knight move, and neither is a
both-even one. Conclusion, straight from the Mirror-Obstruction Lemma:

> **On every board, no square attacks its own mirror image with knights.**

**Even n.** No fixed square either — the mirror strategy never breaks:
**the second player wins every even knights board** (its Grundy value is 0; see the aside
in §4.2). Here is the strategy playing out on 4×4 (verify each copy: move 2k is the 180°
rotation of move 2k−1):

```
        c0  c1  c2  c3
      +----------------+
   r0 |  3   1   5   7 |    1.(0,1)  2.(3,2)=ρ(0,1)     Player 2 copies,
   r1 |  .   .   .   . |    3.(0,0)  4.(3,3)=ρ(0,0)     every reply legal
   r2 |  .   .   .   . |    5.(0,2)  6.(3,1)=ρ(0,2)     by the Copying
   r3 |  8   6   2   4 |    7.(0,3)  8.(3,0)=ρ(0,3)     Lemma.
      +----------------+
```

After move 8 the whole middle is knight-attacked and player 1 is stuck. (This line is
verified square-by-square; try to break the pattern — you cannot, that is the theorem.)

**Odd n.** The only obstruction is the fixed center square. So the FIRST player steals it:
the center's knight-neighborhood is itself ρ-symmetric, and after removing it *nothing
self-mirroring remains* (there was nothing to begin with). Player 1 then plays the copying
strategy as the responder and wins. On 5×5:

```
        c0  c1  c2  c3  c4
      +--------------------+
   r0 |  2   x   .   x   . |    1.(2,2) center steal ('x' = its knight
   r1 |  x   .   .   .   x |      attacks — note the x-pattern is
   r2 |  .   .   1   .   . |      180°-symmetric).
   r3 |  x   .   .   .   x |    2.(0,0) by player 2 — then
   r4 |  .   x   .   x   3 |    3.(4,4) = ρ(0,0): player 1 copies forever.
      +--------------------+
```

**Verdict: knights are completely solved for outcome — second player wins even boards,
first player wins odd boards** (computed values: G = 1,0,1,0,1 for n = 1..5). Status:
proven here; presumably folklore (literature check queued before any submission).

### 4.2 Bishops: the board falls apart — a different weapon entirely

Mirroring is *not* the trick for bishops. Something better happens: a bishop on a light
square attacks only light squares. The board splits into **two independent games** — the
light-square game and the dark-square game — and a move in one component never affects the
other.

> **Aside (Sprague–Grundy, used as a black box).** Every position of such a game has a
> *Grundy value* G, a non-negative integer, with two facts we need: a position is a
> P-position iff G = 0, and the value of a *disjoint union* of two independent games is the
> bitwise XOR: `G(A ⊔ B) = G(A) ⊕ G(B)`. Both facts are classical (Sprague 1935, Grundy
> 1939) — and both are machine-checked in this project's Lean development. Consequence:
> **two isomorphic independent components cancel**, because `g ⊕ g = 0`.

Now the punchline: for **even n**, reflect the board left-to-right, `φ(r,c) = (r, n−1−c)`.
Since `n−1` is odd, φ flips square color — it maps the light component onto the dark
component. And φ preserves bishop attacks (it sends diagonals to anti-diagonals). So the
two components are **isomorphic games**, and

```
    G(bishops, even n) = g ⊕ g = 0    —  the second player wins. (Proven.)
```

The explicit strategy is copying *across the reflection*: answer a bishop on `s` with a
bishop on `φ(s)` — always in the *other* component, so it can never be blocked by
same-component interactions. One exchange on 4×4 (`*` marks what move 1 attacks, `+` what
move 2 attacks — each starred square reflects to a plussed square):

```
        c0  c1  c2  c3
      +----------------+
   r0 |  *   +   *   + |    1.(1,1) by player 1 (a light-square bishop)
   r1 |  .   1   2   . |    2.(1,2) = φ(1,1) by player 2 (dark square)
   r2 |  *   +   *   + |
   r3 |  +   .   .   * |    φ maps the *-set exactly onto the +-set.
      +----------------+
```

A delicious detail: `(1,1)` and `(1,2)` share a **row** — for queens this copy would be an
illegal suicide, but bishops do not attack along rows. Each piece dies to its own weapon.

For **odd n** the center-steal works again: the center bishop's *closed* attack set — its
two diagonals plus the occupied center square itself (ordinary attack excludes the square a
piece sits on) — is exactly the two long diagonals, which is exactly the self-mirroring set
(Mirror-Obstruction Lemma: both-even vectors in bishop's V are the diagonal ones), so
player 1 steals the center and mirrors:
G ≥ 1. Computed small values: G(2..5) = 0, 2, 0, 1 — note G(3) = 2: odd bishop values are
not all 1. Status: proven here (even-n complete); folklore check queued.

### 4.3 Rooks: every game has the same length — the third weapon

A rook placement kills its entire row and column. So after each move, the number of usable
rows *and* columns each drop by exactly one, and a legal move exists as long as both are
positive. Therefore **every** maximal game on an m×n board — however both players play —
lasts exactly `min(m, n)` moves. The game is *fixed-length*, and the winner is read off the
parity: last move = move number `min(m,n)`.

```
    3×3: every game is 3 moves    ⟹  player 1 always moves last: FIRST wins.
    4×4: every game is 4 moves    ⟹  SECOND wins.
    2×3: every game is 2 moves    ⟹  SECOND wins.

        c0  c1  c2         c0  c1  c2
      +------------+     +------------+
   r0 |  1   .   . |  r0 |  .   .   1 |     Two very different 3×3 games.
   r1 |  .   2   . |  r1 |  2   .   . |     Both last exactly 3 moves.
   r2 |  .   .   3 |  r2 |  .   3   . |     (G = min(m,n) mod 2.)
      +------------+     +------------+
```

(The Grundy value follows by a one-line induction: every option of every position has the
same value, `(remaining length − 1) mod 2`, so the mex is `remaining length mod 2`.)
Status: proven; this one is classical folklore — we use it as the sanity anchor for the
method.

### 4.4 Kings: four dangerous squares

King vectors with both coordinates odd: only `(±1, ±1)`. Solve `(n−1−2r, n−1−2c) = (±1,±1)`
for even n: `r ∈ {n/2−1, n/2}` and `c ∈ {n/2−1, n/2}` — **the four central squares**, and
nothing else:

```
        c0  c1  c2  c3
      +----------------+
   r0 |  .   .   .   . |     4×4 kings: the self-mirroring set is the
   r1 |  .   #   #   . |     central 2×2 block (#). Everywhere else,
   r2 |  .   #   #   . |     the mirror reply is always legal.
   r3 |  .   .   .   . |
      +----------------+
```

So by the Copying Lemma: **a first-player win on an even kings board must, at some point,
use a central square** — against a diagonal-free… rather, center-free line, the second
player just mirrors and wins. That is a *reduction* (proven), not yet a full solution: one
must still analyze what happens after a central intrusion. Because the intrusion's damage
is O(1) (a king reaches only 8 squares), this analysis is finite-case-shaped and is queued
as the most promising family to close completely. Computed: G(4) = 0 (the second player
survives the central intrusions at n = 4). Odd kings: center steal ⟹ G ≥ 1, as always.

### 4.5 Queens: the hard one — a reduction, not a solution

Queens are the union of rook rays and bishop rays, and the Mirror-Obstruction Lemma (both-odd
coordinates, even n) keeps exactly the bishop-type solutions: `2(p−s) ∥ (1,1)` gives
`r = c`, and `2(p−s) ∥ (1,−1)` gives `r + c = n−1`. The rook rays contribute nothing
(`n−1−2c = 0` has no integer solution for even n). So:

> **For even n, the self-mirroring squares are exactly the two long diagonals**, 2n
> squares out of n² (the diagonals are disjoint when n is even), and — Theorem 3 —
> **any first-player win must play a long-diagonal square at some point**. Against any
> diagonal-free line, the second player mirrors and wins. (Proven.)

Watch the mirror punish a diagonal-free line on 4×4 (`*` = the two long diagonals):

```
        c0  c1  c2  c3
      +----------------+
   r0 |  *   1   .   * |    1.(0,1)  — not on a diagonal
   r1 |  .   *   *   3 |    2.(3,2) = ρ(0,1): copy.
   r2 |  4   *   *   . |       Now only (1,3) and (2,0) remain — mirror
   r3 |  *   .   2   * |       images of each other, neither diagonal.
      +----------------+    3.(1,3)   4.(2,0) = ρ(1,3): copy. Player 1 loses.
```

But — unlike knights — the reduction is **not** a solution, because the diagonal squares
are really there and really matter. In fact the 4×4 queens game is a FIRST-player win
(A344227: G(4) = 1), so somewhere in the diagonal moves hides a winning line the mirror
cannot refute. The known values of the queens sequence (OEIS A344227, extended by this
project through n = 16) show the resulting struggle:

```
    n     : 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16
    G(n)  : 0  1  1  2  1  3  1  2  3  1  0  1  0  1  0  1  0
```

From n = 10 to 16 the pattern locked into second-player wins on even boards — every
diagonal deviation refutable — and then broke: **this project proved the 18×18 board is a
first-player win**, and the winning opening I9 = (8,8) is a main-diagonal square, exactly
where Theorem 3 says the only threats can live. Explaining *why* the break happens at 18
(and not 16 or 20) is the open problem; the current state of that hunt — the "border
battle" — is in the [implications note](2026-07-02-theory-implications.md) §1.

### 4.6 Torus queens: a fourth trick for free

Wrap the board into a torus (rows and columns cyclic, diagonals wrap too). Mirror
strategies now fail badly — wrapped diagonals create Θ(n) self-mirroring squares for every
choice of center. But a different symmetry saves the day: **translations** act on the
torus, and they can move any square to any other square. So all opening moves lead to
isomorphic positions with a common Grundy value g, and the empty board's value is
`mex{g}` — which is 1 if g = 0, and 0 if g ≥ 1. Either way:

```
    G(torus queens) ∈ {0, 1}   for every n.        (Proven; also already noted
                                                    in A344227's OEIS comments.)
```

Computed: G = 1,1,1,0,1 for n = 1..5. This is the only *proven boundedness* statement in
the whole family so far — and it comes from transitivity, not mirrors.

---

## 5. The three weapons, and why flat queens resists all of them

| weapon                    | what it needs                        | who dies to it            |
|---------------------------|--------------------------------------|---------------------------|
| fixed game length         | every play exhausts at equal speed   | rooks                     |
| perfect mirror            | empty self-mirroring set (even n)    | knights                   |
| isomorphic components     | board decomposes into twin halves    | bishops (even n)          |
| (bonus) transitivity      | all first moves equivalent           | torus queens (G ∈ {0,1})  |

The flat queens game is hard because it fails all four hypotheses at once: game length
varies with play, the diagonal self-mirroring set is nonempty, the board is connected (rook
rays glue the colors), and translations are not symmetries of a bordered board. Every
sibling piece is killed by the specific weapon its own geometry hands you; queens hand you
only the *reduction* of Theorem 3, and after that it is (today) a matter of search — which
is what the rest of this project is about.

---

## 6. Proof status at a glance

| claim                                                | status                          |
|------------------------------------------------------|---------------------------------|
| Copying Lemma; Mirror-Obstruction Lemma; parity corollary        | proven (elementary, above)      |
| knights: even ⟹ 2nd wins; odd ⟹ 1st wins            | proven here; folklore check due |
| bishops: even ⟹ G = 0; odd ⟹ G ≥ 1                  | proven here; folklore check due |
| rooks: G = min(m,n) mod 2                            | proven; classical               |
| kings: even-n wins must use a central square         | proven (reduction only)         |
| queens: even-n wins must use a long diagonal (Thm 3) | proven (reduction only)         |
| torus queens: G ∈ {0,1} all n                        | proven; already in OEIS A344227 |
| queens values n ≤ 16 + n=18 outcome                  | computed, multi-config validated|
| small-board values quoted (knights/bishops/torus)    | computed this session (n ≤ 5)   |

All game lines shown in the diagrams were verified move-by-move by hand against the attack
rules; the small-board Grundy values come from the session's exhaustive brute-force checks
recorded in the implications note.
