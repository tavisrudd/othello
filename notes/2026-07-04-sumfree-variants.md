# Sum-free achievement game — definitional variants (exploration)

**Date:** 2026-07-04 (session --3). The [proven mod-6 theorem](2026-07-04-sumfree-game-theorem.md) is
for the *standard* sum-free game on `Z_n`. That game is one of a family — vary the group or the
"forbidden" relation and you get a different impartial game. This note maps the variants: which have
clean laws, which are new OEIS-absent sequences, and where the proof tools (mirrors, parity) do and
do not bite. Solver `2026-07-04-sumfree-variants.py` (brute memoized Grundy; control reproduces the
proven `Z_n` sequence exactly).

## The variants and their outcomes

All are impartial normal-play achievement games: build a set avoiding the given relation, last to
move wins. `G` = Grundy value of `∅`; second player wins iff `G = 0`.

| variant | relation forbidden | outcome finding |
|---------|--------------------|-----------------|
| `Z_n` weak (**proven**) | `a+b=c`, `a=b` allowed | **P iff `n≡0,1,5 (mod 6)`** — the theorem |
| `Z_n` strong | `a+b=c`, `a≠b` only (`2a=c` allowed) | irregular, **no residue law** through n=24 |
| `{1..n}` (Schur, integer) | `a+b=c`, no wrap | near-law "P iff `n≡3,4,5 mod 6`" that **BREAKS at n=17** |
| `F₂ᵏ` | `a+b=c` | **P (2nd player) for k=2,3,4** (k=1 degenerate N) |
| `F₃ᵏ` | `a+b=c` | **N (1st player) for k=1,2,3** |

### The sequences (all checked OEIS-absent — `null` from the API, Fibonacci-calibrated)

```text
Z_n strong  (n=1..24):  0 1 0 0 0 1 1 1 2 1 0 0 1 1 0 1 0 1 0 1 1 1 0 1
{1..n} Schur (n=1..24): 1 1 0 0 0 1 1 2 0 0 0 3 1 1 0 0 5 3 2 2 4 3 0 4
```

- **`Z_n` strong:** P at `n = 1,3,4,5,11,12,15,17,19,23` — no clean residue pattern. New sequence.
- **`{1..n}` Schur:** the *outcome* is `P iff n≡3,4,5 (mod 6)` through **n=16**, then fails (n=17,21,22
  are N though `≡5,3,4`). A preperiodic near-law, not a theorem — the missing wraparound breaks the
  mirror symmetry that makes `Z_n` clean. New sequence.

## The `F₂ᵏ` (P) vs `F₃ᵏ` (N) contrast — outcomes decided, but not by a clean tool

The vector-space sum-free games split cleanly by the prime: **`F₂ᵏ` is a second-player win, `F₃ᵏ` a
first-player win** (conjectured from small `k`). Neither has a clean pairing/parity proof, and the
reasons are instructive:

- **Parity of maximal sets forces only the small cases.** Since sum-free is subset-closed, every
  inclusion-maximal sum-free set is a reachable terminal, so if all maximal sets share one size
  parity the outcome is forced. Maximal-sum-free-set sizes (`2026-07-04-terminal-parity.py`):
  ```text
  F2^2: {2}      even  -> P (forced)      F3^2: {3}       odd   -> N (forced)
  F2^3: {4}      even  -> P (forced)      F3^3: {4,5,9}   MIXED -> N (NOT forced)
  F2^4: {5,8}    MIXED -> P (NOT forced)
  ```
  So `F2^4` is P and `F3^3` is N **despite mixed-parity terminals** — the winner must *steer* the
  parity of the final maximal set. Genuine game values, not a parity theorem.

- **No mirror works either.** `F₃ᵏ`: the negation mirror `x↦−x` is broken **everywhere** —
  `2(−x)=x` in `F₃`, so playing `−x` completes the sum `(−x)+(−x)=x`; no `{x,−x}` pair is even
  sum-free. (This is the "O₃ obstruction" of the `Z_n` proof hitting every element — the reason
  `F₃ᵏ` flips to N.) `F₂ᵏ` (char 2): translations `τ_v` do **not** preserve sum-freeness
  (`(A+v)+(A+v)=A+A`, unshifted), and every involution in `GL(k,2)` has a fixed point (`g²=I` ⇒
  `(g−I)²=0` ⇒ `g−I` nilpotent), so there is no fixed-point-free linear mirror. So `F₂ᵏ=P` and
  `F₃ᵏ=N` are **conjectures without a clean certificate** — unlike the cap game (`a+b+c=0`), which is
  P for all `q` by a working mirror.

**Why the cap game and the sum-free game differ on `F₃ᵏ`:** cap forbids `a+b+c=0` (the point
reflection `σ_c` is an automorphism, → P for all q); sum-free forbids `a+b=c` (negation is broken by
`2(−x)=x`, → N). Same group, different hypergraph, opposite outcome — a clean illustration that the
outcome is a property of the *relation*, not just the group.

## Status / open

- **New OEIS-absent sequences:** `Z_n` strong and `{1..n}` Schur (banked above). Extending them and
  the `F₂ᵏ`/`F₃ᵏ` families is a possible OEIS contribution *separate from* the main `Z_n` submission.
- **Conjectures (small-k / small-n evidence only):** `F₂ᵏ = P` (k≥2), `F₃ᵏ = N` (k≥1). No clean proof
  — parity forces only k≤3 (F₂) / k≤2 (F₃), and no mirror exists. Left as conjectures.
- **No clean law:** `Z_n` strong (irregular), `{1..n}` Schur (near-law breaks at n=17). Record as new
  sequences, not theorems.
- The **standard `Z_n` game remains the clean deliverable**; these variants map the surrounding
  terrain and show the mod-6 law is special to the wrapped, `a=b`-allowed, `Z_n` setting.
