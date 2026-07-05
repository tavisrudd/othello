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

Grundy(∅), n=1..36:

```text
n:  1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36
G:  0 1 1 2 0 0 0 2 1  1  0  0  0  2  2  3  0  0  0  2  1  3  0  0  0  2  1  2  0  0  0  3  1  1  0  0
```

- **OEIS: no matches** (`0,1,1,2,0,0,0,2,1,1,0,0,0,2,2,3,0,0,0,2` → "No results"). Genuinely new.
- **★ Outcome law (conjectured, confirmed n=5..36):** the sum-free game is a **P-position (G=0,
  second player wins) iff `n ≡ 0, 1, 5 (mod 6)`** — equivalently the first player wins iff
  `n ≡ 2, 3, 4 (mod 6)`. Eighteen consecutive confirmations, no exception.
- **N-side nimbers are irregular** (like Paley: clean outcome, messy internals): `n≡2 mod 6` →
  {2,2,2,2,3}; `n≡3` → {1,1,2,1,1,1}; `n≡4` → {2,1,3,3,2,1}. No simple period in the *values*, only
  in the *outcome*.
- **Tractable & scalable:** memo (distinct reachable positions) is small and grows only ~×1.4/step
  (n=20→2,728; n=30→79,672; n=36→528,417). Python reaches ~n=42–44; a Rust solver with an
  affine-symmetry quotient (`x↦ux`, `x↦−x`) reaches far past n=60 — well within the freed 18 GB.

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

## Next steps (the scale-up the free box unlocks)

1. **Rust subset-state solver + affine-symmetry quotient** → sum-free Z_n to n≈60–80: full nimber
   sequence for **OEIS submission** + firm/extend the mod-6 outcome law.
2. **Cap-set d=4** (the RAM computation) → test "always P"; then d=5 if d=4 confirms and memory allows.
3. **Prove the two laws.** mod-6 for Z_n: find the fixed-point-free involution / structural pairing
   certifying `n≡0,1,5 mod 6` (this session's `whole_graph_paired`/`residual_paired` idea, adapted
   to the hypergraph). Cap-set "always P": the pairing on F₃ᵈ.
4. **Definitional variants to log** (each a distinct sequence): strong sum-free (`a≠b`, so `2a∈A`
   allowed); sum-free in `{1..n}` (integers, not cyclic) vs `Z_n`; the `(I+I)∩S` S-sum-free family
   that connects back to game (a).
