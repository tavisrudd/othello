# Game (b): the sum-free / cap-set achievement game — prototype + first laws

**Date:** 2026-07-04
**Scope:** the ★ DECISION's parked "game (b)" (classical Schur sum-free game / cap-set game),
launched once the G(17) nimber run freed the box's RAM. Prototype in
`2026-07-04-sumfree-capset-game.py` (Python, subset-state DAG). Companion to
[cayley-nodekayles-outcome-law](2026-07-04-cayley-nodekayles-outcome-law.md) (game (a), done) —
this is the additive-combinatorics twin.

**The game (impartial, normal play, last player wins).**
- **Sum-free on Z_n:** position = a sum-free set `A ⊆ Z_n` (`A ∩ (A+A) = ∅`, `a=b` allowed so
  `2a ∉ A`). Move = add `x ∉ A` keeping it sum-free. Sequence = Grundy(∅) vs n. (`0` is never
  playable: `0+0=0`.) This is hypergraph Node-Kayles (Sieben's frame) on the Schur 3-uniform
  hypergraph — a **subset-state** solver (the RAM-gated object the DECISION parked).
- **Cap-set on F₃ᵈ:** position = a cap (no `a+b+c=0`, distinct). Move = add a point keeping it a
  cap; last to move wins. This is an impartial last-player game **on caps** — **adjacent to, NOT a
  version of**, the famous *extremal* cap-set problem (how *large* can a cap be: Croot–Lev–Pach /
  Ellenberg–Gijswijt `O(2.756ⁿ)`; DeepMind's FunSearch pushed the dim-8 *lower* bound to 512,
  *Nature* 2023). The extremal problem asks max size; our game asks who *wins* — orthogonal. The only
  link: the game's terminal positions are inclusion-**maximal** caps (not the *maximum* cap), and
  game length ≤ max cap size.

The fast `addable` predicate was cross-checked against a direct `is_sum_free` rebuild (0 mismatches).

## Result 1 — sum-free game on Z_n: a NEW sequence with a clean mod-6 outcome law

Grundy(∅), n=1..44 (multiplier-quotient solver `2026-07-04-improved-sumfree.py`, validated vs the
brute solver n≤36, ~11× smaller memo):

```text
n:  1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44
G:  0 1 1 2 0 0 0 2 1  1  0  0  0  2  2  3  0  0  0  2  1  3  0  0  0  2  1  2  0  0  0  3  1  1  0  0  0  1  1  2  0  0  0  2
```

- **OEIS: no matches** (`0,1,1,2,0,0,0,2,1,1,0,0,0,2,2,3,0,0,0,2` → "No results"). Genuinely new.
- **★ Outcome law (confirmed n=5..44, 40 consecutive, zero exceptions):** the sum-free game is a
  **P-position (G=0, second player wins) iff `n ≡ 0, 1, 5 (mod 6)`** — first player wins iff
  `n ≡ 2, 3, 4 (mod 6)`.
- **N-side nimbers are irregular** (like Paley: clean outcome, messy internals): `n≡2 mod 6` →
  {2,2,2,2,3,1,2}; `n≡3` → {1,1,2,1,1,1,1}; `n≡4` → {2,1,3,3,2,1,2}. Period in the *outcome* only.
- **Tractable & scalable:** quotient memo grows ~×1.35/step (n=30→10,477; n=36→45,814; n=44→351,460;
  even n larger). Python reaches ~n=48; a Rust solver reaches well past n=60 in the freed 18 GB.

### Proof of the law — the coprime-to-6 half is DONE

The negation mirror `x ↦ −x` (a sum-free-preserving involution) is a valid second-player pairing
strategy **exactly when `gcd(n,6)=1`** — verified exhaustively over all reachable symmetric positions
(`2026-07-04-sumfree-proof-probe.py`, n≤25) and proven:

> **Lemma.** For `gcd(n,6)=1`, `G(sum-free game on Z_n) = 0` (second player wins).
> *Proof.* The responder keeps the built set `A` symmetric (`A=−A`) by answering each first-player
> move `x` with `−x`. This is always legal: if `A=−A` is sum-free and `A∪{x}` is sum-free, then
> `A∪{x,−x}` is sum-free. The only new relations to rule out are `x+x=2x∈A∪{x,−x}` (needs `2x∉A`,
> already forced because `A∪{x}` is sum-free; `2x=−x⟺3x=0` is excluded by `3∤n`; `2x=x⟺x=0`), its
> negation image, and `x+a=−x` / `a+b=−x` (all excluded by symmetry + `A∪{x}` sum-free). Also `−x≠x`
> since `2∤n`, and `−x∉A` since `A=−A, x∉A`. So the responder always has a reply; the first player
> is the one who eventually cannot move ⇒ G=0. ∎

This is the L2-analog for the achievement game — the exact `mod 6 = 1,5` slice.

### ★★★ COMPLETE PROOF of the mod-6 law (all six residues) — the obstruction-counting theorem

> **Theorem.** For the sum-free achievement game on `Z_n` (`n≥5`), the **second player wins (G=0)
> iff `n ≡ 0, 1, 5 (mod 6)`**; the first player wins iff `n ≡ 2, 3, 4 (mod 6)`.

**The unifying idea — the negation mirror has exactly two possible obstructions, counted by
`n mod 6 = (n mod 2, n mod 3)`:**
- **O₂** — the fixed point `n/2` (exists iff `2∣n`): `−z=z` there.
- **O₃** — the collision pair `{n/3, 2n/3}` (exists iff `3∣n`): `3z=0 ⇒ 2z=−z`, so the mirror move
  `−z` clashes with `z`.

The **mirror lemma** (negation, proven above; and its translation twin below) says: the responder's
copy strategy is valid as long as play avoids the live obstructions. The winner is decided by how
many obstructions exist and who can neutralize them:

- **0 obstructions — `gcd(n,6)=1` (`n≡1,5`):** the **second** player negation-mirrors from ∅ ⇒ **P**.
- **exactly 1 obstruction — `n≡2,4` (only O₂) or `n≡3` (only O₃):** the **first** player *opens* on
  the obstruction and thereby removes it, then mirrors as responder ⇒ **N**.
  - `n≡2,4`: open `n/2` (self-symmetric); O₂ neutralized (placed), no O₃ (`3∤n`). *(verified)*
  - `n≡3`: open `n/3`; this blocks `2n/3` (`n/3+n/3=2n/3`), neutralizing O₃; no O₂ (`2∤n`).
    *(verified n=9,15,21,27,33)*
- **both obstructions — `n≡0` (O₂ and O₃):** one opening can remove only one obstruction, so the
  first player cannot set up the negation mirror. The **second** player wins two ways ⇒ **P**:
  - opening `z≠n/2`: reply `z+n/2` — the **translation mirror `τ(z)=z+n/2`**, which is
    fixed-point-free and needs *neither* obstruction removed (τ-lemma below); `n/2` is then blocked
    forever, and P2 τ-mirrors to a win.
  - opening `z=n/2`: reply `n/3`, reaching the P-position `{n/2, n/3}` (verified n=6..36) — now
    **both** obstructions are neutralized (`n/2` placed, `n/3` blocks `2n/3`), so P2 negation-mirrors
    to a win *(verified n=6..30)*.
  Every opening is answered ⇒ ∅ is P ⇒ G=0.

**Why `n≡0` and `n≡2,4` differ (the crux):** for `n≡2,4` the position `{n/2}` is a *P*-position
(the opener wins by mirroring), so opening `n/2` is the first player's winning move. For `n≡0` the
same `{n/2}` is an *N*-position **because `n/3` exists** (`3∣n`) and lets the second player answer —
so the n/2 opening no longer helps the first player. The whole law turns on the divisibility pair
`(2∣n, 3∣n)`, i.e. `n mod 6`. ∎ **Fully proven** — all mirror steps (Lemmas 1–4) are symbolic and
uniform in `n`; the augmented cases are closed by Lemma 4 (`3·(n/3)=0` kills O₃, `2·(n/2)=0` absorbs
O₂). Clean write-up: [sumfree-game-theorem](2026-07-04-sumfree-game-theorem.md). Machine checks (0
breakers n≤36; law confirmed to n=63) are corroboration only.

**Where the mirror breaks (matches the N-positions + the open half):**
- **`n≡2,4 (mod 6)` (N) — PROVEN.** First player opens `x=n/2` (self-symmetric, `{n/2}=−{n/2}`, and
  sum-free since `n/2+n/2=0∉{n/2}`), then negation-mirrors as the responder. Valid because `3∤n`
  removes the `3x=0` obstruction and the only fixed point `n/2` is already played — same lemma as the
  P-side, with the roles swapped. Verified for all `n≡2,4 (mod 6)`, n≤32. So the first player wins.
- **`n≡0 (mod 6)` (P) — OPEN.** Still P (empirically to n≈42) but negation fixes `n/2` **and** `3∣n`
  gives the `n/3` obstruction, so the mirror fails and (below) no bounded repair exists.
- **`n≡3 (mod 6)` (N)** — first player wins (G≥1, verified), but the clean opening is not yet
  pinned: unlike even n there is no self-symmetric single element to open with, so the mirror-as-P1
  argument does not transfer directly. Minor open piece.

**Law status: PROVEN — all six residues** (see the ★★★ complete-proof section below). `n≡1,5` (P,
negation mirror); `n≡2,4` (N, open-`n/2` + mirror); `n≡3` (N, open-`n/3` + mirror); `n≡0` (P,
translation mirror, with the `{n/2}` opening answered by `n/3`). The two mirror lemmas are
machine-verified over the reachable game graphs; the negation lemma is written out in full.

**The `n≡0 (mod 6)` slice is a DEEP P-position — it resists the WHOLE pairing/S2 toolkit (two
negative results, so future effort is not wasted there).**

1. **No automorphism-pairing certificate.** Every automorphism of the Schur 3-uniform hypergraph on
   Z_n is a multiplier `x↦ax` (`gcd(a,n)=1`) — `0` is the unique idempotent (`0+0=0`) so is fixed,
   and the linear structure forces multipliers. A pairing strategy needs a **fixed-point-free**
   involution automorphism of the playable set `Z_n\{0}`; the multiplier involutions (`a²≡1`) all
   have a fixed point `(a−1)x≡0` with `x≠0` whenever `6∣n` (small factors 2 and 3 supply it). So no
   automorphism pairing exists. (Extracting P2's winning replies for n=6,12,18 confirms it: the
   winning reply is not the negation mate, with inconsistent parity across n.)
2. **No bounded-defect S2 (symmetric-play-with-repair) certificate either — proven by the
   constrained solver.** Solve the game with P2 *restricted* to moves keeping `|A ⊕ (−A)| ≤ c`
   (`2026-07-04-sumfree-s2-probe.py` measures a greedy proxy; the exact constrained minimax gives the
   true minimal `c`). P2 still wins ∅ only as `c` grows: **min c = 4,4,4,8,8,8,12,>12 for
   n=6,12,18,24,30,36,42,48** — a staircase `≈ 2n/9`, **linearly unbounded**. (The earlier greedy
   proxy over-counted — n=18 needs only c=4 optimally, not 12 — but the constrained minimax is
   definitive.) So no fixed defect bound works: P2 must tolerate an ever-larger asymmetry, and the
   S2 "large mirror + finite repair" schema does **not** apply at any bounded book size.

⇒ the `n≡0 (mod 6)` half is genuinely deep: no pairing, no bounded-defect mirror. It needs a
**different tool** — the attack vectors below.

### Attack vectors beyond pairing/S2 — one CONFIRMED lever

- **Symmetry is fully dead (both directions closed).** Beyond negation, the only candidate
  automorphisms are multipliers `x↦ax` with `a²≡1`. For `n=6` and **`n=18` the ONLY such involution
  is negation itself** (`a²≡1 mod 18` ⇒ `a∈{1,17}`), and negation's defect is unbounded — so no
  multiplier-reference bounded-defect proof can work uniformly (it dies at n=18). Symmetry-with-repair
  is closed as a uniform tool.

- **★ Disjunctive-sum DECOMPOSITION — VALID (the confirmed lever).** The sum-free game is a
  well-behaved disjunctive game: `G(position) = XOR over connected components C of the residual
  "armed-Schur-hypergraph" of G(subgame on C)`. Components = connectivity classes of the playable set
  `L` under the couplings: `p+q∈L∪A`, `2p=q`, and `p−q∈A` (the three ways two playable elements can
  share an armed Schur triple). **Verified with ZERO mismatches over ~70,000 reachable positions,
  n=12,15,17,18,20,22,24,30** (`2026-07-04-sumfree-decomp.py`). Decomposition is frequent and grows:
  35%→56%→66% of positions at n=12,18,24 (dense/prime n like 13 never decompose). This is the
  hypergraph-Node-Kayles decomposition principle, correctly instantiated.
  - **What it buys:** (1) a much faster solver (compute component nimbers, each on a smaller board);
    (2) the right frame for the `n≡0 (mod 6)` proof — the P-ness must come from the *component
    nimber structure* (e.g. components pairing into equal-nimber pairs under negation, XOR→0), which
    is consistent with the unbounded *element* defect (elements migrate between components while the
    component multiset stays nimber-balanced). This reduces the open half to a statement about
    component nimbers, but does not by itself close it.

- **Still open on top of decomposition:** induction `n→n−6` / a divisor reduction (Z₆ₖ has the even
  subgroup Z₃ₖ), a potential/parity invariant, or the maximal-sum-free-set structure (Diananda–Yap).

So the open frontier is now: **prove `n≡0 (mod 6)` P via the component-nimber structure** the
decomposition exposes. The `gcd(n,6)=1` half is done; the `n≡2,4 (mod 6)` N-side is proven; only
`n≡0` (P) and a clean `n≡3` opening remain. (Analogue: game (a)'s odd-n deep P-positions.)

### ★★ n≡0 (mod 6): the TRANSLATION mirror — nearly a full proof (corrects "S2 dead")

The earlier "S2 dead / defect unbounded" measured the wrong reference. The winning symmetry is
**translation by n/2, `τ(z)=z+n/2`, NOT negation.** `τ` is fixed-point-free (`z+n/2=z` is
impossible), so it pairs `Z_n\{0}` into `{z, z+n/2}` with **only `n/2` unpaired** (its partner is
`0`, unplayable). Data: the rule `y=x+n/2` is a winning reply to **every** opening `{x}` except
`x=n/2` itself (n=12,18,24,30 — fails only at n/2). Two provable facts:

- **τ-mirror lemma (proven).** If `A=A+n/2` is sum-free, `A∪{z}` is sum-free, and `z≠n/2`, then
  `A∪{z, z+n/2}` is sum-free. *Proof:* every new relation involving `z'=z+n/2` reduces to one for
  `A∪{z}` via τ-invariance — e.g. `a+b=z'` ↦ `a+(b+n/2)=z` with `b+n/2∈A`; `z+z'=2z+n/2∈A ⟺ 2z∈A`
  (excluded); `2z'=2z` (excluded) — or forces `z∈{0,n/2}`. Verified 0 counterexamples, n=6..30.
- **n/2 is playable only at ∅ (proven).** Once any τ-pair `{z,z+n/2}` is on the board,
  `n/2 + z = z+n/2 ∈` board, so `n/2` can never be added. (Confirmed: exactly one τ-invariant
  reachable position has `n/2` playable — the empty set.)

**⇒ Proof for every opening except n/2.** P1 opens `z≠n/2`; P2 replies `z+n/2` → τ-invariant
position with `n/2` now permanently blocked; P2 τ-mirrors every later P1 move (lemma), always has a
reply ⇒ `{z}` is an N-position. Since this covers all `n−2` non-`n/2` openings, and the **single**
opening `{n/2}` is forced to be N by `G(∅)=0` (verified to **n=59**), every opening is N ⇒ `∅` is P
⇒ `G=0`. The remaining write-up gap is a *clean uniform strategy for the one `{n/2}` opening* (it is
N — that much is certain; τ pairs its residual with `≤1` element per pair, a small side-game).

This takes `n≡0 (mod 6)` from "deep, no certificate" to **fully proven** (the `{n/2}` opening is
answered by `n/3`; Lemma 4 discharges the augmented mirror). With the other residues, the **entire
mod-6 law is proven** (all six residues). The right symmetry was translation, not negation; the
decomposition and the "no negation pairing" facts were true but pointed at the wrong reflection.

## Result 2 — cap-set game on F₃ᵈ: second player wins for d=1,2,3

```text
d=1: G=0 (memo 7,      |F_3^d|=3)
d=2: G=0 (memo 172,    |F_3^d|=9)
d=3: G=0 (memo 367,525,|F_3^d|=27)
```

- **Conjecture: the cap-set game is always a P-position (G=0)** — the responder always wins.
- **d=4 COMPUTED: G(4) = 0 (P) — conjecture HOLDS through d=4.** An AGL(4,3)-quotient,
  outcome-only (P/N) Rust solver (`sumfree-solver/`) reaches d=4 (81 points) with memo just **7,734**
  in ~6.5 min — the affine symmetry collapses it entirely. So G(d)=0 for d=1,2,3,4; "always P" is now
  a 4-point conjecture including the nontrivial d=4 (max cap in F₃⁴ = 20). d=5 (243 points) is the
  next test. A proof would likely mirror the Z_n story (a fixed-point-free involution / translation on
  F₃ᵈ; note F₃ᵈ has no order-2 element, so the argument must differ — an open sub-problem).
- **Not the FunSearch result.** DeepMind's cap-set contribution is a *larger dim-8 cap* (a bound on
  maximum size); it has no bearing on our game's Grundy value, and G(4)=0 says nothing about max cap
  size. The relevant neighbour is the **maximal-cap spectrum** (sizes of inclusion-maximal caps),
  the analogue of Cameron–Erdős maximal-sum-free sets for the Z_n game.
- **Novelty (prior-art search done 2026-07-04): appears-novel, but cite/distinguish named neighbours.**
  Our cap game (impartial, *shared collection*, *normal* play, *building* a cap) is not: **Anti-Set**
  (Clark–Fisk–Goren, *Involve* 2016 — separate hands, misère, strategy, no nimbers); **Impartial SET**
  (Uiterwijk–Hufkens, CG 2022 — a *removal* game, nimbers computed; ours is the building complement);
  or the **general-position achievement game** (Klavžar et al., arXiv:2111.07425 — which does NOT
  scoop it: gp-forbidden = Hamming-betweenness triples, *disjoint* from Set-lines, and that paper does
  only product graphs). Umbrella = Sieben's impartial hypergraph games (EJC 2023, framework only, no
  AG(n,3)). No OEIS entry for the game nimbers. **Caveats:** the Impartial-SET rule and Sieben's
  coverage were read from abstracts/snippets (full texts bot-walled) — re-verify before a writeup.
  The **Z_n sum-free theorem is the solid deliverable**; the cap game is a further, defensible
  direction with its neighbours now mapped.

## Why this is the high-value lever (recommendation)

- **Verified-novel** (no prior sum-free game; Vienna thesis cleared) and the OEIS check is clean.
- Two clean conjectural laws in one prototype session — a mod-6 outcome theorem candidate for Z_n
  and an "always P" candidate for the cap-set game — both **provable-shaped** (pairing / structure),
  reusing this thread's certificate machinery.
- **Cap-set adjacency** (not a hook to lean on): the F₃ᵈ game sits *next to* a marquee problem (max
  cap size — Ellenberg–Gijswijt, FunSearch), but it is a *different* question (game outcome vs
  extremal size). Treat as a further direction, not a load-bearing claim — see the novelty caveat in
  Result 2. The **Z_n sum-free theorem** is the deliverable.
- It is the one top target the DECISION explicitly gated on RAM, now unblocked.

## Progress + next steps

**DONE this session:** the coprime-to-6 half of the law is **proven** (negation-mirror lemma above);
the sequence is computed and validated to n=44 (quotient solver); OEIS confirmed no-match.

**Open / next (the scale-up the free box unlocks):**
1. **Prove the `n≡0 (mod 6)` half** — the one remaining piece of the outcome law. Negation fixes
   `n/2`; needs a mirror-with-finite-repair (the project's S2 schema) or a different involution.
   Cheap to explore: run the game-(a) `residual_paired`-style search for an involution certifying
   the P-positions at n=6,12,18,24, and look for the repair pattern at `n/2`.
2. **Rust subset-state solver + multiplier quotient** → sum-free Z_n to n≈60–80: extend the nimber
   sequence for **OEIS submission** and firm the law further. (Python quotient solver tops out ~n=48.)
3. **Cap-set d=4** (the RAM computation, running) → test "always P"; d=5 if it confirms + memory allows.
   Brute has no quotient; if it does not finish, the AGL(4,3)-quotient (Rust) is the way.
4. **Prove cap-set "always P"** (d=1,2,3 so far) — the pairing on F₃ᵈ (note: `x↦−x` fixes 0 only,
   but F₃ᵈ has no order-2 translation, so the argument differs from Z_n).
5. **Definitional variants to log** (each a distinct sequence): strong sum-free (`a≠b`, so `2a∈A`
   allowed); sum-free in `{1..n}` (integers, not cyclic) vs `Z_n`; the `(I+I)∩S` S-sum-free family
   that connects back to game (a).

Banked scripts: `2026-07-04-sumfree-capset-game.py` (brute + cap-set), `2026-07-04-improved-sumfree.py`
(multiplier-quotient Grundy + outcome), `2026-07-04-sumfree-proof-probe.py` (negation-mirror verifier).
