# C1070 probe 10 — the uniform-cost chain question

**Lane**: `ergodis`
**Task**: C1070 probe 10 (brief: `notes/2026-09-06-c1070-ergodis-compositional-leakage-brief.md`;
synthesis: `notes/2026-09-06-c1070-closeout-synthesis.md`).
**Owns**: the open theorem left by probe 2,
`notes/2026-09-06-c1070-probe2-leakage-profile-from-quotient.md`, §4.1 and its mystery ledger:
does uniform unit cost force an optimal leaked-subspace chain?
**Scope**: uniform linear model, mask-free, flat instances, as in probe 2. No masks, no priors,
no noise, no adaptivity.

---

## 0. Verdict

**False, in both versions, and already in the pure probing model where every unit is one wire.**
With every unit at cost 1 there are instances whose cheapest one-symbol leak and cheapest
two-symbol leak are disjoint, so no chain of optimal leaked subspaces exists and no nested family
of optimal coalitions exists either.

Probe 2's 1,434,264-instance negative is a parameter artefact of two kinds. Its "uniform" families
priced a coordinate unit at 2 and a two-coordinate block at 3, which is not the uniform model at
all; and its ambient dimension never exceeded 3, while the smallest failures need ambient dimension
5 with block units and 6 with single-coordinate units.

The identification that explains everything: **with single-coordinate units at unit cost the
leakage profile is exactly the generalized Hamming weight hierarchy of the secret code, and the
chain conjecture is exactly Wei's chain condition** (§3). That condition is known not to hold for
all codes, so the conjecture was never going to be a theorem. What survives is a pair of proved
sufficient conditions that are cheap to test at run time (§4), and probe 2's `t`-factor bound
otherwise.

| question | verdict |
|---|---|
| coalition-chain version at `c ≡ 1` | **False.** `block-uniform` and `probe-mds` below, and 16,128 exhaustively enumerated binary instances. |
| subspace-chain version at `c ≡ 1` (the weaker one; §1) | **False.** The same instances; the two versions failed on the same count everywhere the ladder ran. |
| does it need multi-coordinate units? | **No.** `probe-mds` and `probe-direct-sum-binary` are pure probing instances: every unit is one coordinate at cost 1. |
| is there an exact incremental profile algorithm for uniform cost? | **Not by chaining.** The exact algorithm is probe 2's Theorem A sweep, which is not incremental in `t` in any useful sense. Chaining is exact under a checkable precondition (§4) and a `t`-approximation otherwise. |

---

## 1. The two conjectures, stated exactly

Probe 2's flat instance: ambient functional space `W = F_q^n`, one functional `w_j ∈ W` per leaf
coordinate, observation units each naming a coordinate set and carrying a cost, secret space
`S ≤ W` of dimension `k`. A coalition `H` observes `V_H = span{w_j : j ∈ coords(H)}` and leaks
`L_H = S ∩ V_H`. The labelled cost of a subspace `T ≤ S` is `Λ(T) = min{c(H) : T ≤ V_H}` and
`Γ_t = min{c(H) : dim L_H ≥ t}` (probe 2, Theorem A).

Throughout this probe **`c ≡ 1`**: every unit costs one, so `c(H) = |H|`. Units may still name
several coordinates; a block therefore delivers a whole subspace at the price of a single wire.
This is the model the question named, and it is *not* probe 2's §6.2 "uniform" families, which
priced a coordinate at 2 and a two-coordinate block at 3. Probe 2's phrase "uniform unit costs"
meant uniform within each kind of unit. The distinction is not cosmetic: probe 2's Proposition C
counterexample survives on its own cost structure and dies at `c ≡ 1` (verified, named case
`proposition-c-at-unit-cost`: the profile becomes `(1, 1, 2)` and the chain reappears), while the
counterexamples below need `c ≡ 1` and die under probe 2's prices.

**Conjecture S (subspace chain).** There are subspaces `T_1 ⊂ T_2 ⊂ … ⊂ T_k` of `S` with
`dim T_t = t` and `Λ(T_t) = Γ_t` for every `t`.

**Conjecture H (coalition chain).** There are coalitions `H_1 ⊆ H_2 ⊆ … ⊆ H_k` with
`c(H_t) = Γ_t` and `dim L_{H_t} ≥ t` for every `t`.

**Lemma 1.** Conjecture H implies Conjecture S, for any cost function.

*Proof.* Given nested optimal coalitions, `L_{H_1} ⊆ L_{H_2} ⊆ …`, so a chain of subspaces
`T_t ≤ L_{H_t}` with `dim T_t = t` and `T_{t-1} ⊂ T_t` can be chosen one dimension at a time. Then
`Λ(T_t) ≤ c(H_t) = Γ_t`, and `Λ(T_t) ≥ Γ_t` because `T_t` is a `t`-dimensional subspace of `S`. ∎

So Conjecture S is the weaker statement, which is why probe 2 measured it, and refuting it refutes
both. Probe 2's §4.2 remark that "chaining coalitions is worse than chaining subspaces" is about the
*greedy* chain — commit to one minimizer and extend it — which is a third and still weaker
procedure; Conjecture H allows any nested family of minimizers.

**Lemma 2 (why `k ≥ 3`).** If `dim S ≤ 2`, Conjecture S holds for any costs and any units.

*Proof.* For `k = 1` there is nothing to chain. For `k = 2`, the only two-dimensional subspace of
`S` is `S` itself, so `Λ(S) = Γ_2` automatically, and any optimal line lies in it. ∎

Every counterexample below therefore has `k ≥ 3`, and the search families fix `k = 3` (or 5).

---

## 2. Counterexamples

All four are machine-verified in the certificate; each row of §6.2 names the case.

### 2.1 `block-uniform`: ambient 5, three units, `q` arbitrary

`W = F_q^5` with basis `a, b, c, d, e`; secret `S = ⟨a, b, c⟩`; five leaves
`a`, `b + d`, `c + e`, `d`, `e`; three units, each at cost 1:

| unit | coordinates | observed space |
|---|---|---|
| `A` | `{a}` | `⟨a⟩` |
| `X` | `{b + d, c + e}` | `⟨b + d, c + e⟩` |
| `Y` | `{d, e}` | `⟨d, e⟩` |

`L_A = ⟨a⟩`, `L_X = L_Y = 0`, `L_{A∪X} = L_{A∪Y} = ⟨a⟩`, and `L_{X∪Y} = ⟨b, c⟩` because
`V_X + V_Y` contains `b` and `c`. So the profile is `(1, 2, 3)`, the unique cost-1 line is `⟨a⟩`,
the unique cost-2 plane is `⟨b, c⟩`, and `a ∉ ⟨b, c⟩`: **no optimal chain, in either version.**
The instance is unchanged if every leaf is additionally offered as its own cost-1 unit (named case
`block-uniform-with-singletons`), so the failure is not an artefact of withholding cheap units.

The mechanism in one sentence: two units that individually leak nothing leak a plane together, and
that plane is cheaper than any plane through the one line that a single unit leaks.

### 2.2 `probe-mds`: the same failure with single-coordinate units, `q ≥ 3`

`W = F_q^6` with basis `h1, h2, h3, h4, m1, m2`; six leaves `h1, h2, h3, h4, m1 + m2, m1`, each its
own unit at cost 1; secret `S = ⟨c1, c2, m2⟩` with

```
c1 = h1 + h3 + h4,    c2 = h2 + h3 + α h4    (α ∉ {0, 1}),
```

so that `C := S ∩ ⟨h1..h4⟩` is a `[4, 2]` maximum-distance-separable code in the `h`-coordinates:
every nonzero element has `h`-support 3. Then `Γ_1 = 2` (only `{m1 + m2, m1}` leaks a line, namely
`⟨m2⟩`), `Γ_2 = 4` (only `{h1..h4}` leaks a plane, namely `C`), `Γ_3 = 6`. Since `m2 ∉ C`, **no
optimal chain**. Verified over `q ∈ {3, 4, 5, 7}`, including the non-prime field `GF(4)`.

Why `q ≥ 3`: the construction needs a `[4, 2, 3]` MDS code, which does not exist over `F_2`. §3
explains why that is the real constraint and gives the binary case.

### 2.3 `probe-direct-sum-binary`: the general mechanism, over `F_2`

Leaves are the standard basis of `F_2^{11}`, every coordinate its own cost-1 unit, and the secret
is the direct sum `C = A ⊕ B` on disjoint coordinates of the `[8, 4, 4]` first-order Reed–Muller
code `A` and the `[3, 1, 3]` repetition code `B`. The measured profile is `(3, 6, 7, 8, 11)`, which
is the generalized Hamming weight hierarchy `d_t(A ⊕ B) = min_{i+j=t}(d_i(A) + d_j(B))` with
`d(A) = (4, 6, 7, 8)`. The cheapest line has support 3 and lies in `B`; the cheapest plane has
support 6 and lies in `A`; **no optimal chain.**

**Proposition 3 (direct-sum obstruction).** In the probing model let the secret be `A ⊕ B` on
disjoint coordinate sets with `dim B = 1`. If `d_1(B) < d_1(A)` and `d_2(A) < d_1(A) + d_1(B)`,
then every optimal line lies in `B`, every optimal plane lies in `A`, and Conjecture S fails.

*Proof.* A line inside `A` has support at least `d_1(A) > d_1(B)`, and a line meeting both summands
has support at least `d_1(A) + d_1(B)`, so `Γ_1 = d_1(B)` is attained only in `B`. `B` is
one-dimensional, so a plane lies in `A` or meets both summands; in the latter case its support is
at least `d_1(A) + d_1(B) > d_2(A)`. So `Γ_2 = d_2(A)`, attained only inside `A`, and no optimal
plane meets `B`. ∎

**Corollary 4 (when the mechanism is available).** Griesmer applied to the `[d_2(A), 2, d_1(A)]`
subcode gives `d_2(A) ≥ d_1(A) + ⌈d_1(A)/q⌉`, so the hypothesis of Proposition 3 forces
`⌈d_1(A)/q⌉ < d_1(B) < d_1(A)`. Over `F_2` this needs `d_1(A) ≥ 4`, which is why the smallest
binary probing counterexample found here has length 11 and why no probing failure appears anywhere
in the binary ladder of §6, whose leaf counts stop at 5. Over `F_q` with `q ≥ 3` the bound admits
`d_1(A) = 3, d_2(A) = 4, d_1(B) = 2`, which is §2.2.

### 2.4 What the ladder adds: minimality

The exhaustive ladder (§6) covers, up to isomorphism, every instance with `k = 3`, `c ≡ 1` and:
`q = 2`, ambient 3 to 5, three to five leaves, every unit shape; and `q = 3`, ambient 3 to 4, four
leaves, every unit shape. It finds failures in exactly one family — `q = 2`, ambient 5, five leaves,
unit sizes `(2, 2, 1)` — 16,128 of 872,760 chain-testable instances, about 1.8 per cent, all
isomorphic in mechanism to §2.1. Its lexicographically first witness is

```
leaves  d, a + e, b + d, e, c        units {0,1}, {2,3}, {4}      secret ⟨a, b, c⟩
profile (1, 2, 3)      greedy coalition chain (1, 3, 3)      no optimal chain
```

which is §2.1 with the roles of the leaves permuted. So, within the enumerated range: **no failure
exists with ambient dimension at most 4, and none with fewer than three units**, and the block
counterexample of §2.1 is smallest in both ambient dimension and unit count.

---

## 3. Why the conjecture was never going to hold: it is Wei's chain condition

**Proposition 5.** Let the units be single coordinates at cost 1 and let the leaf functionals be a
basis of `W`. Writing the secret in that basis as a code `C ≤ F_q^n`,

```
Γ_t  =  d_t(C)  =  min{ |supp(D)| : D ≤ C, dim D = t },
```

the `t`-th generalized Hamming weight of `C`; and `Λ(T) = |supp(T)|` for `T ≤ C`. Conjecture S is
then the statement that `C` has a chain of optimal subcodes `D_1 ⊂ … ⊂ D_k` with
`|supp(D_t)| = d_t(C)`, which is **the chain condition of Wei and Yang**.

*Proof.* In the leaf basis, `V_H` is the coordinate subspace on `H`, so `S ∩ V_H` is the shortened
code `{x ∈ C : supp(x) ⊆ H}` and `dim(S ∩ V_H) ≥ t` says `H` supports a `t`-dimensional subcode.
Minimizing `|H|` is minimizing the support of a `t`-dimensional subcode. For the labelled cost,
`T ≤ V_H` says `supp(T) ⊆ H`. ∎

When the leaves are dependent, the same computation gives the relative generalized Hamming weights
of the pair (preimage of the secret, kernel of the leaf map), which is the invariant probe 2 §4 and
the synthesis already named as the right one.

Consequences, and they are the point of this section:

1. The conjecture is a known open-and-answered question in coding theory, not a new one. Codes
   satisfying the chain condition are a proper subclass; the condition is standard in the
   generalized-weight literature precisely because it does not hold in general. Probe 0's survey is
   the lane's prior-art record; this citation is from memory and has **not** been verified against
   Wei and Yang's text in this session, so it is an attribution, not evidence. The refutation above
   does not rest on it: §2 is self-contained and machine-checked.
2. Computing `Γ_1` in this model is computing the minimum distance of a code, which is NP-hard, and
   `Γ_t` is the `t`-th weight. So no polynomial exact profile algorithm should be expected at all,
   with or without chains, which retires any hope that uniform cost makes the problem easy rather
   than merely well-structured.
3. It says where to look for positive results: at classes of codes known to satisfy the chain
   condition, which for the product is a statement about the *encoding*, checkable once per design
   rather than per query.

---

## 4. What survives: two proved sufficient conditions

Both are for the probing model — single-coordinate units, `c ≡ 1` — and both are cheap to test.
Fix `t` and write `b = Γ_t`, `a = Γ_{t-1}`.

**Lemma 6.** A minimum coalition `H` at level `t` has linearly independent leaf functionals, and
`dim L_H = t` exactly. Consequently `Γ_t ≥ Γ_{t-1} + 1`: the profile is strictly increasing.

*Proof.* If some leaf of `H` lay in the span of the others, deleting it would not change `V_H`,
contradicting minimality. Removing one leaf drops `dim V_H` by one, so it drops `dim(S ∩ V_H)` by at
most one; minimality forces `dim L_{H∖u} = dim L_H − 1 < t`, hence `dim L_H = t` and
`|H| − 1 ≥ Γ_{t-1}`. ∎

This fails with block units — a single block can leak two symbols, giving `Γ_1 = Γ_2` — which is
the first structural difference between the probing model and the block model.

**Proposition 7 (unit-gap descent).** If `Γ_t = Γ_{t-1} + 1`, then for a minimum coalition `H` at
level `t` and any `u ∈ H`, the coalition `H ∖ u` is optimal at level `t − 1` and
`L_{H∖u} ⊂ L_H`. Hence if the profile has all gaps equal to one, deleting units one at a time from
a minimum coalition at level `k` produces a full optimal chain of coalitions, and by Lemma 1 of
subspaces.

*Proof.* Immediate from Lemma 6: `dim L_{H∖u} = t − 1` and `c(H ∖ u) = b − 1 = Γ_{t-1}`. ∎

**Proposition 8 (low-weight exchange).** Let `H` be a minimum coalition at level `t` and let `C`
denote `L_H` written in the (independent) leaf coordinates of `H`, a `[b, t]` code. If the
codewords of `C` of weight at most `b − a` span `C`, then every optimal `T_{t-1}` extends: there is
an optimal coalition at level `t` whose leaked space contains it. In particular this holds whenever
`Γ_{t-1} = t − 1`.

*Proof.* Let `G` witness an optimal `T_{t-1}`, `|G| = a`. Suppose some codeword `x` of weight at
most `b − a` lies outside `T_{t-1}`; its support avoids some `a`-subset `A ⊆ H`, so with
`H' = H ∖ A` we have `x ∈ S ∩ V_{H'}`. Then `K = G ∪ H'` has `|K| ≤ a + (b − a) = b` and
`L_K ⊇ T_{t-1} + ⟨x⟩` of dimension `t`, so `c(K) = b = Γ_t` and `K` is optimal; take
`T_t ≤ L_K` of dimension `t` containing `T_{t-1}`. If instead every codeword of weight at most
`b − a` lay in `T_{t-1}`, their span would too, contradicting that they span `C`, which has
dimension `t > t − 1`. For the last clause: a code of length `b` and dimension `t` always has a
generator matrix in reduced echelon form, whose rows have weight at most `b − t + 1`; and
`a = t − 1` gives `b − a = b − t + 1`. ∎

The two propositions are sharp in the sense that the counterexamples sit exactly at their boundary:
in §2.2, `a = 2`, `b = 4`, `b − a = 2`, and `C` is MDS with every nonzero weight equal to
`b − t + 1 = 3 > 2`, so no low-weight codeword exists to exchange with. **A leaked space that is
MDS relative to the units of its own minimum coalition is precisely what breaks the chain.**

---

## 5. What this means for the product

1. **Do not ship an incremental "grow the leaked subspace" profile mode as exact, even under
   uniform cost.** It is exact only under a precondition, and the failure is not exotic: 1.8 per
   cent of the chain-testable instances in the one enumerated family that can express it, and the
   binary probing case is a Reed–Muller code plus a repetition code, both textbook.
2. **The exact algorithm is unchanged and already implemented**: probe 2's Theorem A sweep, one
   best-first pass over coalitions in nondecreasing cost, yielding every `Γ_t` at once, at the cost
   of one rank computation per popped coalition. Uniform cost makes the pop order the subset-size
   order, which is a small constant-factor simplification and nothing more. There is no
   uniform-cost speedup to claim, and §3 says why: the profile is the weight hierarchy, whose
   computation is NP-hard, so the sweep's exponential behaviour is intrinsic rather than a defect
   of the engine.
3. **There is a certified-exact incremental mode, gated on a run-time check.** Compute the profile
   by the sweep; if every gap is 1 (Proposition 7), the descent from a minimum coalition at level
   `k` gives a chain, and the interface can report a nested sequence of coalitions and subspaces
   with a proof. Otherwise test Proposition 8 at each level, which is a rank computation on the
   low-weight codewords of the leaked space of one minimum coalition. Both checks cost far less
   than the sweep that precedes them, so the incremental view becomes an annotation on the exact
   answer rather than a competing algorithm.
4. **Otherwise the surviving guarantee is probe 2's Proposition D**: the greedy chain satisfies
   `Γ_t ≤ g_t ≤ Σ_{j≤t} Γ_j ≤ t·Γ_t`, and probe 2 measured the bound tight at `t = 2`. The
   worst ratio in this probe's named cases is `g_2 / Γ_2 = 3/2` in `block-uniform` (greedy chain
   `(1, 3, 3)` against the profile `(1, 2, 3)`), which attains the bound `g_2 ≤ Γ_1 + Γ_2 = 3`
   exactly, so Proposition D is tight at unit cost as well as under graded costs.
5. **Design guidance falls out of Proposition 3.** An encoding whose secret code is a direct sum
   with unbalanced summand weights has a leakage profile that no incremental audit can track, and
   the auditor is then obliged to run the full sweep. Conversely, encodings whose secret code
   satisfies the chain condition admit the incremental audit; that is a property of the design, so
   it can be established once at compile time.

---

## 6. Computational check

### 6.1 What is checked, and what is trusted

Everything is deterministic; no randomness is used, so there are no seeds.

**Named cases.** The four constructions of §2, each over every field it supports, are built
explicitly and their profile, greedy chain, and both chain predicates recomputed. The `[8,4,4]`
Reed–Muller case doubles as a check of a claim taken from memory — that its weight hierarchy is
`(4, 6, 7, 8)` — since the measured profile `(3, 6, 7, 8, 11)` is exactly the direct-sum formula
applied to it.

**Exhaustive ladder.** For each field, ambient dimension `n`, leaf count and unit shape, every
assignment of leaf functionals is enumerated, with two exact reductions: the secret space is fixed
to `⟨e_1, …, e_k⟩`, and the first leaf ranges over one representative per orbit of the stabiliser of
the secret space (the zero vector, `e_1`, and `e_{k+1}`). Both are legitimate because the whole
predicate is invariant under a linear automorphism of `W` fixing `S`, and that group is transitive
on nonzero secret vectors and on vectors outside `S`. Unit shapes are the integer partitions of the
leaf count, since relabelling leaves is a symmetry of the enumerated family. So each family is
exhaustive up to isomorphism, and a family with zero failures is a genuine negative over its range.

**Trusted boundary.** Gaussian elimination over the core's `SmallField` (so `GF(4)` is covered) and
probe 5's `subspaces_of_dimension`, both already load-bearing in probe 2 and validated there. The
new predicate `optimal_coalition_chain_exists` is layered reachability over minimizing coalitions
and shares no code with `optimal_chain_exists`, which works on subspaces; Lemma 1 says the
coalition version implies the subspace version, and the measurements respect that everywhere.

**Scope.** `c ≡ 1`, mask-free, flat, `k ∈ {3, 5}`, the parameter ranges tabulated below. Nothing
here bounds behaviour at larger ambient dimensions or leaf counts, and the ladder's negatives are
negatives for their range only — §2.3 exhibits a binary probing failure at length 11, far outside
that range.

### 6.2 Results

| claim | measured |
|---|---|
| `block-uniform`, `q ∈ {2, 3, 4, 5, 7}` | profile `(1, 2, 3)`; both chain predicates **false**; greedy chain `(1, 3, 3)` |
| `block-uniform-with-singletons`, same fields | identical, so extra cheap units do not repair it |
| `probe-mds`, `q ∈ {3, 4, 5, 7}` | profile `(2, 4, 6)`; both chain predicates **false** |
| `probe-direct-sum-binary`, `q = 2` | profile `(3, 6, 7, 8, 11)`; both chain predicates **false** |
| `proposition-c-at-unit-cost`, `q ∈ {2, 3, 4, 5, 7}` | profile `(1, 1, 2)`; both chain predicates **true** — probe 2's counterexample needs its cost gradient |
| ladder instances enumerated | 32,192,125 across 55 families |
| ladder subspace-chain failures | 16,128, all in `q = 2`, ambient 5, five leaves, unit sizes `(2, 2, 1)` |
| ladder coalition-chain failures | 16,128, the same count in the same family |
| smallest failing ambient dimension / unit count in the ladder | 5 / 3 |
| families with zero failures | all 54 others, including every probing-model family in range |

### 6.3 Replay, inputs, and hashes

Working directory `~/src/ergodis-private`; toolchain `rustc 1.93.1 (01f6ddf75 2026-02-11)`; core
checkout `~/src/ergodis` at `6cc9668`; private checkout at `a6790b7`. Runtime about 100 seconds on
16 threads. Regenerate:

```
cd ~/src/ergodis-private
cargo build --release -p ergodis-tools
~/.cache/ergodis/target/ergodis-private/release/ergodis-tools leakage-chain-search \
  --out ~/src/othello/notes/2026-09-06-c1070-probe10-uniform-cost-chain.json
```

Append `--check` to the same command to verify the tracked certificate without writing to the
worktree. The command takes no inputs: every instance is generated internally, so the certificate
depends only on the two source files below.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `ergodis-private/src/leakage_structure.rs` | 16379 | `2c99af66fdc1da0be652dd857f6daac58ec1e592cc393f8e3a83169b43341725` |
| `ergodis-private/tasks/tools/src/leakage_chain_search.rs` | 22156 | `2bb586a619e57074f6e0a3084b113998197cd0e98fd1ccc62c233a410552dd4d` |
| `notes/2026-09-06-c1070-probe10-uniform-cost-chain.json` | 46778 | `61c9e5bc59a52d3bbae0b24f95e79e77d8fe12f56518d2cee733254231dd92f8` |

**Independent cross-check.** Three of them. The two chain predicates are separate implementations
over different objects (subspaces of the secret space against bit masks of coalitions) and agree on
every instance, in the direction Lemma 1 requires. The hand constructions of §2.1 and §2.2 were
derived on paper with their profiles predicted in advance — `(1, 2, 3)` and `(2, 4, 6)` — and the
code reproduced both without adjustment; §2.3's profile was predicted from the direct-sum weight
formula and likewise reproduced. Probe 2's certificate still regenerates byte-identically under the
extended module (`leakage-structure-report --check` passes), so the additions changed no existing
behaviour.

**Negatives, with their domain.** No chain failure was found in any family of §6.2 other than the
one named, and the domain is exactly the enumerated ladder: `q = 2` with ambient 3 to 5 and three
to five leaves, `q = 3` with ambient 3 to 4 and four leaves, `k = 3`, every unit shape, stop
condition exhaustion. In particular no probing-model failure occurs in that range, which
Corollary 4 explains rather than contradicts.

---

## 7. Mystery ledger

Written after an explicit extra-juice and Tao-style closeout pass.

| observation | status |
|---|---|
| Probe 2 measured 1,434,264 uniform-cost instances without a single failure, and the property is false. | **Settled, and it is this probe's warning.** Two causes: probe 2's "uniform" families were not `c ≡ 1` (coordinates cost 2, blocks 3), and their ambient dimension stopped at 3 while the smallest failure needs 5. A negative measured over a family that cannot express the mechanism is not evidence about the mechanism. |
| The block counterexample needs ambient 5 and the probing counterexample needs ambient 6 over `F_3` and length 11 over `F_2`. | **Settled by Corollary 4.** The Griesmer bound on the `[d_2, 2, d_1]` subcode forces `⌈d_1(A)/q⌉ < d_1(B) < d_1(A)`, which is empty over `F_2` until `d_1(A) ≥ 4`. The parameter gap between the fields is a coding-theoretic fact, not an artefact of the search. |
| The two chain versions failed on exactly the same 16,128 ladder instances, although Lemma 1 only gives one implication. | **Open, and cheap to settle if it matters.** The converse is false in general for heterogeneous costs (probe 2 §4.2 measures coalition-greedy at 133 per cent where subspace chains exist), but no separating instance appeared at `c ≡ 1`. Whether `c ≡ 1` makes the two equivalent is a well-posed question; nothing in the product depends on it, since the exact answer comes from the sweep either way. Evidence gap: the ladder's range; owner: none allocated. |
| The failure rate in the one expressive family is 1.8 per cent, not vanishing and not generic. | **Settled as expected.** The mechanism needs two disjoint cheap structures at particular relative weights, so it is neither rare nor typical; the rate carries no further information. |
| The uniform-cost model turned out to be the classical weight-hierarchy model, which the lane has been circling since probe 2 named the relative generalized Hamming weight. | **Settled and acted on.** Proposition 5 makes the identification exact, which converts an open engineering conjecture into a known coding-theoretic property with a literature and, more usefully for the product, into a compile-time property of the encoding. The citation itself is unverified against the source text and is marked as such in §3; the mathematics does not depend on it. |

No other genuine mystery remains. The one open item is the equivalence of the two chain versions at
unit cost, stated above with its evidence gap.
