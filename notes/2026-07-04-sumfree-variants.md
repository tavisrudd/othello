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

**`F₂ᵏ` sum-free = the PROJECTIVE cap game `PG(k−1, 2)`.** Over `F₂`, `a+b=c ⟺ a+b+c=0`, and the
nonzero vectors of `F₂ᵏ` are exactly the points of `PG(k−1, 2)` (one vector per projective point),
with projective lines `{a, b, a+b}` (3 points). So "no `a+b=c`" = "no 3 collinear projectively" — the
`F₂ᵏ` sum-free game **is** the cap game on `PG(k−1, 2)`. Hence `F₂ᵏ = P` (k=2,3,4) is the statement
`PG(1/2/3, 2)` cap game `= P`, tying this conjecture to the projective cap game (the flagged
`PG(n,q)` follow-on). Note `|PG(m,2)| = 2^{m+1}−1` is **odd**, so — like the odd-`q` affine case —
no whole-board involution exists; a projective "always P" would need a move-then-mirror with a
self-blocking center, which does not drop out as cleanly as the affine `σ_c` (open).

## Zero-sum triples on Z_n (`a+b+c=0`) — no clean law

(The *geometric* cyclic cap analog is the **3-AP-free game** `a+c=2b`, which is mostly-P with sporadic
exceptions — see [ap-free-game](2026-07-04-ap-free-game.md). This section is the **different** relation
`a+b+c=0`, which over `Z_n` is NOT the same as AP-free — they coincide only in char 3.)

Forbidding `a+b+c=0` (three *distinct*) on `Z_n`. Grundy(∅), n=1..21 (`2026-07-04-zerosum-zn.py`,
OEIS-absent):

```text
n:  1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
G:  1 0 0 1 1 0 0 0 0  1  1  1  0  2  0  1  1  1  1  2  0
```

P at `n = 2,3,6,7,8,9,13,15,21` — **irregular, no residue law** (P spans residues 0,1,2,3 mod 6).
Unlike the `F₃ᵈ` cap game (**always P**), the cyclic version is a genuine mix of P and N. **Why the
cap theorem does not transfer to `Z_n`:** its self-blocking reflection center needs `3c=0` — in
`F₃ᵈ` (char 3) that holds for *every* `c` (so the midpoint always self-blocks), but in `Z_n` only
`c ∈ {0, n/3, 2n/3}` satisfy it, so the clean move-then-mirror is unavailable at a general opening.
The cap game's uniform "always P" is thus special to the characteristic-`p` vector-space structure,
not a feature of the `a+b+c=0` relation per se.

## ★ The mod-6 law GENERALIZES to all finite abelian groups (clean criterion, conjectured)

The proven `Z_n` law reads "P iff `n ≡ 0,1,5 (mod 6)`", i.e. P iff the presence of 2-torsion matches
the presence of 3-torsion. On a general abelian `G` this generalizes cleanly once one extra rule is
added — the **2-rank** (number of `Z₂` factors) can override. Let `s₂ = ` 2-rank of `G` and
`τ₃ = [3 ∣ |G|] ∈ {0,1}` (3-torsion present or not).

> **Conjecture (sum-free game on finite abelian `G`).** Second player wins (`G(∅)=0`) **iff**
> `s₂ ≥ 2`, **or** (`s₂ ≤ 1` and `s₂ = τ₃`). Equivalently: P iff `s₂ ≥ 2`, or (`s₂=1` and 3-torsion
> present), or (`s₂=0` and 3-torsion absent).

Reproduces the `Z_n` mod-6 law exactly (cyclic ⇒ `s₂ = [2∣n] ∈ {0,1}`, so P iff `s₂ = τ₃` iff
`n ≡ 0,1,5`). **Verified with zero mismatches on ~25 abelian groups** (`2026-07-04-sumfree-abelian.py`),
outcomes by `(s₂, τ₃)`:

```text
(s2, tor3):  (0,0)P     (1,0)N    (2+,0)P            (0,1)N    (1,1)P            (2+,1)P
examples:    Z5,Z7,Z11  Z8,Z10    Z2xZ2,Z4xZ4,Z2^3   Z9,Z3^2   Z6,Z12,Z2xZ9     Z2xZ6,Z2^2xZ9
```

The mechanism: a **lone** 2-torsion (`s₂=1`) is a negation-mirror obstruction; but `s₂ ≥ 2` gives the
2-torsion subgroup `(Z₂)^r` a fixed-point-free involution that **self-neutralizes** it — and this
even overrides a 3-torsion obstruction (`Z2×Z2×Z9 = P` while `Z9 = N`). 3-torsion has odd order and
never self-neutralizes. **This is a genuine clean generalization of the mod-6 theorem** — now
**PARTIALLY PROVEN** ([2026-07-05 abelian-theorem](2026-07-05-sumfree-abelian-theorem.md)): a
theorem for all `G` with 3-rank `≤ 1` or 2-rank `≥ 2` (the `s₂≥2 ⟹ P` self-pairing is a clean
translation-mirror proof); open only for 2-rank `≤ 1` and 3-rank `≥ 2` (multiple order-3 pairs),
which is solver-confirmed and reduced to one lemma. A candidate companion result to the `Z_n` theorem.

- **New OEIS-absent sequences:** `Z_n` strong and `{1..n}` Schur (banked above). Extending them and
  the `F₂ᵏ`/`F₃ᵏ` families is a possible OEIS contribution *separate from* the main `Z_n` submission.
- **Conjectures (small-k / small-n evidence only):** `F₂ᵏ = P` (k≥2), `F₃ᵏ = N` (k≥1). No clean proof
  — parity forces only k≤3 (F₂) / k≤2 (F₃), and no mirror exists. Left as conjectures.
- **No clean law:** `Z_n` strong (irregular), `{1..n}` Schur (near-law breaks at n=17). Record as new
  sequences, not theorems.
- The **standard `Z_n` game remains the clean deliverable**; these variants map the surrounding
  terrain and show the mod-6 law is special to the wrapped, `a=b`-allowed, `Z_n` setting.
