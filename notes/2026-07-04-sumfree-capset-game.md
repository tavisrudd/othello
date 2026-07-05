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
  cap. The impartial-game version of the **cap-set problem** (Croot–Lev–Pach / Ellenberg–Gijswijt).

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

**Where the mirror breaks (matches the N-positions + the open half):**
- **`n` even** → fixed point `x=n/2` (the order-2 element) has no mate. For `n≡2,4 (mod 6)` this is
  an N-position and the first player exploits `n/2`; for **`n≡0 (mod 6)` the position is still P**
  (empirically to n=42) but by a *different* strategy. **This is the open half of the law.**
- **`n≡3 (mod 6)`** (odd, `3∣n`) → break at `x=n/3`: `3x=0 ⇒ x+x=2x=−x`, so the mirror move `−x`
  collides with `x`. N-position; the first player's opening is `n/3`.

**The `n≡0 (mod 6)` slice is a DEEP P-position — no pairing (negative result).** Extracting P2's
winning replies to each P1 opening for n=6,12,18 (`2026-07-04-sumfree-strat-probe.py`) shows the
winning reply is **not** the negation mate — negation loses as a reply for many openings, with
*inconsistent* parity structure (n=12: neg wins only for odd openings; n=18: only for even; n=6:
never). So `n≡0 (mod 6)` is P **without any negation-mirror certificate** — analogous to the deep
odd-n P-positions of game (a) that resist all pairing. ⇒ a full proof of the mod-6 law needs a
**non-pairing (inductive / strength) argument** for this slice; it is a real open sub-problem, not a
quick lemma. (Do not hunt for a pairing here — verified there isn't a negation one.)

## Result 2 — cap-set game on F₃ᵈ: second player wins for d=1,2,3

```text
d=1: G=0 (memo 7,      |F_3^d|=3)
d=2: G=0 (memo 172,    |F_3^d|=9)
d=3: G=0 (memo 367,525,|F_3^d|=27)
```

- **Conjecture: the cap-set game is always a P-position (G=0)** — the responder always wins. If
  true it likely has a pairing/strategy proof (candidate: the `x↦−x` structure, though it fixes 0;
  needs the residual-pairing treatment from the game-(a) work).
- **d=4 (81 points) is THE RAM-gated computation** — memo will be large (d=3 already 367k; caps in
  F₃⁴ number in the millions). This is the direct next run the freed box unlocks, and it tests the
  "always P" conjecture on the first dimension where max-caps get interesting (max cap in F₃⁴ = 20).

## Why this is the high-value lever (recommendation)

- **Verified-novel** (no prior sum-free game; Vienna thesis cleared) and the OEIS check is clean.
- Two clean conjectural laws in one prototype session — a mod-6 outcome theorem candidate for Z_n
  and an "always P" candidate for the cap-set game — both **provable-shaped** (pairing / structure),
  reusing this thread's certificate machinery.
- **Cap-set hook**: the F₃ᵈ version is the impartial-game face of a marquee combinatorics problem —
  the paper hook the arithmetic-Cayley cluster wanted.
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
