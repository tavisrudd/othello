# C1070 probe 6 — transcript state: the exact composition rule and the coarsest exact state

**Lane**: `ergodis`
**Task**: C1070 probe 6 (brief: `notes/2026-09-06-c1070-ergodis-compositional-leakage-brief.md`, §7)
**Code**: `~/src/ergodis-private` — tier-1 module `src/transcript_leakage.rs`, one `tasks/tools`
subcommand `transcript-leakage-report`; no change to the `~/src/ergodis` core.
**Inputs and certificate**: `notes/data/2026-09-06-c1070-probe6/`
**Scope**: the linear-uniform model over a prime field only. Non-uniform priors, noisy or partial
observations, adaptive observers, nonlinear operations, and computational (as opposed to
information-theoretic) privacy are out of scope and are not addressed anywhere below.

---

## 0. Verdict

| Question | Verdict |
|---|---|
| (1) exact composition rule | **Observation spaces compose, leakage spaces do not.** `L` is a function of the *sum* of row spaces; it is superadditive, `L(V₁)+L(V₂) ⊆ L(V₁+V₂)`, and no function of the pair `(L(V₁),L(V₂))` determines `L(V₁+V₂)` (Proposition 1 and the two-instance witness in §2.2). |
| (2) coarsest exact state under a rank-`ρ` future | **Plain `V`. No reduction is possible for any `ρ ≥ 1`**, beyond identifying the single absorbing class `K ⊆ V` where every secret functional has already leaked (Theorem 2). It is *not* the manuscript's finite contextual quotient. |
| (2′) when the future is a stated finite menu | The manuscript's shape returns exactly: the coarsest state is the finite response vector `A ↦ L(V + Σ_{u∈A} U_u)` over unit sets `|A| ≤ ρ`, with the mask annihilator `K = Ann(R)` in the outer role, and it is a graded congruence (Proposition 4). |
| (2″) future observations that introduce fresh masks | Lengthening `R` never invalidates the state: old rows embed by zero-extension and `L` is unchanged. The one always-available reduction is the **dead-mask contraction** `V ↦ V ∩ (S* ⊕ W)`, where `W` is the span of the mask covectors the future may still use (Theorem 5). Full sealing `W = 0` collapses the state to `L(V)` — that identity *is* proactive refresh. |
| (3) mask reuse detection | Reuse is exactly a rank drop in the mask block: `dim(π_R(V_{<i}) ∩ π_R(V_i)) > 0`. Zero coupling implies exact additivity of leakage across the step (Proposition 6), so the rank test is a **sound one-sided alarm**: it never misses a superadditive leak and may fire without one. It is probe 1's promotion rule read along the transcript axis. |
| (4) analyzer | Built, validated, and cross-checked two independent ways on all five committed transcripts; every step agrees with `ergodis::Matrix` row-space arithmetic and with exhaustive coefficient enumeration. §6. |

One sentence carries the probe: **the adversary's state is the observed row space in `(s,r)`
coordinates, and the only sound compression of it is to delete the mask directions the protocol has
provably retired.**

---

## 1. Model

Fix a prime field `F_q`. A protocol has a secret space `S = F_q^k` and a mask space `R = F_q^m`,
with `(s,r)` uniform on `S ⊕ R`; `s` is the protected data and `r` the protocol's randomness.

An **observation** is a linear functional `y ∈ (S ⊕ R)*`, written `y = (a, b)` with `a ∈ S*` and
`b ∈ R*`, so the observed value is `a(s) + b(r)`. A **transcript** is a finite sequence of
operations `op_1, …, op_n`; operation `i` emits a finite set of observations spanning
`V_i ⊆ (S ⊕ R)*` and may declare some mask coordinates **fresh** (first used at this operation).
Fresh randomness introduced later simply lengthens `R`; §4.1 shows why that is harmless.

The **state after `i` operations** is the row space

    V_{≤i} = V_1 + ⋯ + V_i  ⊆ (S ⊕ R)*.

Write `π_R : (S ⊕ R)* → R*` for restriction to the mask block, `(a,b) ↦ b`, and

    K = Ann(R) = ker π_R = S* ⊕ 0.

The **leakage space** of a state is

    L(V) = V ∩ K  ≅ { a ∈ S* : (a,0) ∈ V },

the set of secret functionals the adversary knows exactly. This is probe 1's annihilation — masks
are killed, not modded out — and by the brief's §2 rank identity `dim L(V)` is the mutual
information in `q`-ary symbols. Because `π_R` restricted to `V` has kernel `L(V)`,

    dim L(V) = dim V − rank π_R(V).                                            (★)

Identity (★) is the whole of §3 and §5: leakage is the *excess* of state rank over mask rank.

---

## 2. (1) The exact composition rule

### Proposition 1 (observation spaces compose, leakage spaces do not)

Let `O₁, O₂` be sets of observations with row spaces `V₁, V₂`.

1. `span(O₁ ∪ O₂) = V₁ + V₂`, hence `L(span(O₁ ∪ O₂)) = L(V₁ + V₂)` is a function of `V₁ + V₂`
   alone.
2. `L(V₁) + L(V₂) ⊆ L(V₁ + V₂)`, and the inclusion can be strict.
3. There is no function `F` with `L(V₁ + V₂) = F(L(V₁), L(V₂))` for all `V₁, V₂` in a fixed ambient
   `(S ⊕ R)*` with `dim R ≥ 2`.

*Proof.* (1) The span of a union is the sum of the spans, and `L` is defined on subspaces, so it
factors through the sum. (2) `L(V_j) = V_j ∩ K ⊆ (V₁+V₂) ∩ K`. (3) is §2.2. □

The two-line content of (1) is the whole compositional interface: to compose exactly, carry `V`.

### 2.2 The witness that leakage spaces do not compose

Take `S = F_q²` with coordinates `s₁,s₂` and `R = F_q²` with coordinates `r₁,r₂`.

| pair | `V₁` | `V₂` | `L(V₁)` | `L(V₂)` | `L(V₁+V₂)` |
|---|---|---|---|---|---|
| coupled | `⟨s₁+r₁⟩` | `⟨s₂+r₁⟩` | `0` | `0` | `⟨s₁−s₂⟩` |
| sealed | `⟨s₁+r₁⟩` | `⟨s₂+r₂⟩` | `0` | `0` | `0` |

Both pairs have the same leakage-space arguments `(0,0)` in the same ambient space, and different
`L` of the sum. So no `F` exists; Astra's `s₁+r`, `s₂+r` example is exactly the first row. □

The unlabelled per-operation summary "this operation leaks nothing" is precisely the state `L(V_i)`,
and the table is the proof that shipping that summary is unsound under composition. This is the
same failure mode as the unlabelled composition notions of the side-channel literature
(non-interference, strong non-interference, probe-isolating non-interference): they are sufficient
conditions engineered *around* the fact that the exact state does not compress.

---

## 3. (3) Mask reuse is a rank drop, and the alarm is one-sided

*(Presented before §4 because §4's contraction theorem uses it.)*

### Proposition 6 (fresh masks make leakage additive)

If `π_R(V₁) ∩ π_R(V₂) = 0` then `L(V₁ + V₂) = L(V₁) + L(V₂)`.

*Proof.* Take `u₁ + u₂ ∈ L(V₁+V₂)` with `u_j ∈ V_j`. Then `π_R(u₁) = −π_R(u₂)` lies in
`π_R(V₁) ∩ π_R(V₂) = 0`, so each `u_j ∈ V_j ∩ K = L(V_j)`. The reverse inclusion is Proposition 1(2).
□

### Definition (the coupling and the alarm)

For step `i` of a transcript, the **mask coupling**

    κ_i = dim( π_R(V_{<i}) ∩ π_R(V_i) )
        = rank π_R(V_{<i}) + rank π_R(V_i) − rank π_R(V_{≤i})

is the rank drop of the mask block at that step. The **reuse alarm** fires when `κ_i > 0`, and the
reused directions are a basis of that intersection, read in `R*`.

### Corollary 7 (soundness and one-sidedness)

`κ_i = 0` implies no new leakage beyond `L(V_{<i}) + L(V_i)`; so every superadditive leak is
preceded by `κ_i > 0` and the alarm never misses one. The converse fails: `V_{<i} = V_i = ⟨r₁⟩` has
`κ_i = 1` and no leakage at all. The alarm is therefore conservative in the safe direction, matching
probe 1's Lemma 5, whose fresh-mask formula also errs only towards claiming *more* privacy than is
real — note the two errors point the same way only because probe 1's object is a cost and this one
is an alarm on the coupling that creates the cost gap.

Two derived quantities the analyzer reports, both from (★):

* the **total mask deficiency** `Σ_i rank π_R(V_i) − rank π_R(V_{≤n})`, the transcript's aggregate
  reuse; and
* the **new-leak delta** `dim L(V_{≤i}) − dim L(V_{<i})`, with a witness `u` (a combination of named
  observations) for each newly leaked functional.

### 3.1 Reuse as probe 1's promotion rule

Probe 1 §4 fixes a tower whose blocks share a mask by *promoting the shared mask to a message
coordinate of the lowest level at which it is common, pinned to zero in the request*. A transcript is
a tower whose levels are operations, so the two rules are the same rule: a mask direction with
`κ_i > 0` is common to two operations and must be carried in the state as an explicit coordinate —
it cannot be summarised away into a per-operation leakage verdict, and it cannot be contracted by
Theorem 5 because it is still live. The transcript form is strictly more convenient: promotion is
automatic, because the state already *is* a row space in the full `(s,r)` coordinates, and the price
probe 1 quantified (a factor `q^{t·dim R_sh}` in the compiled state) is here just the mask columns
one declines to delete.

---

## 4. (2) The coarsest exact state

Fix the ambient `(S ⊕ R)*` and a bound `ρ ≥ 0`. Call states `V, W` **`ρ`-equivalent** when
`L(V + V') = L(W + V')` for every `V'` of dimension at most `ρ`. The coarsest exact state is the
quotient by `ρ`-equivalence: it is the Myhill–Nerode quotient of the response function, so it is
coarsest by construction and the only question is what it *is*.

### Theorem 2 (no reduction under a rank bound alone)

For every `ρ ≥ 1`, states `V` and `W` are `ρ`-equivalent if and only if either `V = W`, or both
contain `K = Ann(R)`.

*Proof.* Sufficiency: if `K ⊆ V` then `K ⊇ L(V+V') ⊇ L(V) = K` for every `V'`, so the response is
constantly `K`; and `V = W` is trivial. Necessity: it is enough to use the rank-1 tests
`V' = ⟨v⟩`, available because `1 ≤ ρ`. Since `L(V+⟨v⟩) = (V+⟨v⟩) ∩ K`, three cases:

* `v ∈ V`: the response is `L(V)`;
* `v ∈ (V+K) \ V`: write `v = w + c` with `w ∈ V`, `c ∈ K \ V`; then
  `(V+⟨v⟩) ∩ K = L(V) + ⟨c⟩ ⊋ L(V)`;
* `v ∉ V + K`: any `x = u + αv ∈ K` with `u ∈ V` forces `αv ∈ V + K`, hence `α = 0`, so the response
  is `L(V)`.

So the *set* `D(V) = { v : L(V+⟨v⟩) ⊋ L(V) }` equals `(V+K) \ V`, and it is read off the responses
(`L(V) = L(V + 0)` is the `ρ = 0` response). If `K ⊄ V` then `V ⊊ V + K`, `D(V)` is the complement
of a proper subspace inside `V+K` and therefore spans `V+K`; and `V = (V+K) \ D(V)`. Hence the
responses determine `V`. If two states have `D(V) = D(W) = ∅` then `K ⊆ V` and `K ⊆ W`. □

Theorem 2 is a hard negative and the useful kind: **there is no compression of the transcript state
that is exact against an unrestricted next observation.** Every mask column matters, including
observations that are pure randomness (`V = ⟨r₁⟩` is distinguishable from `0`, because a later
`s₁+r₁` then leaks `s₁`), and including directions that will never be used again — the rank bound
does not know that.

### 4.1 Why this differs from the manuscript's contextual quotient

The manuscript's finite contextual quotient is exact because a cost-bounded context probes the state
through boundedly many *coordinates of a fixed menu* and returns a *number*. Here the response is a
subspace and the probe direction is unrestricted: a rank-1 future observation may be any functional
on `S ⊕ R` whatever, and Theorem 2's proof turns that freedom into a separating family. So the answer
to the brief's question "is it the manuscript's quotient with the mask subspace in the outer role?"
is **no, under a rank bound**; the quotient shape returns as soon as the observation model is
restricted, which is what a real protocol supplies.

### Proposition 4 (menu model: the contextual-quotient shape returns)

Let the future be drawn from a fixed finite menu `U = {U_1,…,U_N}` of observation units
(`U_j ⊆ (S ⊕ R)*` a subspace, for instance the coordinates one node holds), at most `ρ` of which are
still to come. Then the coarsest exact state is the finite **response vector**

    R_ρ(V) = ( L( V + Σ_{j ∈ A} U_j ) )_{A ⊆ {1..N}, |A| ≤ ρ},

it is computable in `Σ_{i≤ρ} C(N,i)` rank computations, and it is a graded congruence: for any single
further unit `U_j`, `R_{ρ-1}(V + U_j)` is a coordinate projection of `R_ρ(V)`.

*Proof.* Coarsest and exact are the definition of the Nerode quotient of the response function; the
response function is by hypothesis indexed by the listed finite set. The congruence statement is the
identity `R_{ρ-1}(V+U_j)_A = R_ρ(V)_{A ∪ {j}}`. □

This is the manuscript's bounded response vector with the helper radius replaced by the residual
operation budget and the outer role played by `K = Ann(R)`. What Theorem 2 adds is that the
finiteness comes entirely from the menu, not from the algebra: **the quotient is a property of the
observation model, not of the leakage functional.** For the product that is the design rule — an
interface that promises compressed state must publish the menu it compressed against.

### Theorem 5 (dead-mask contraction, and fresh randomness)

Let `W ⊆ R*` be a subspace containing `π_R(V')` for every admissible future observation space `V'`
(the **live mask covectors**), and let `R_dead = W^⊥ ⊆ R` be the mask directions no future
observation can touch. Then for every admissible `V'`,

    L(V + V') = L( (V ∩ (S* ⊕ W)) + V' ).

In particular `W = 0` gives `L(V + V') = L(V) + L(V')`, and the state collapses to `L(V)`.

*Proof.* `⊇` is monotonicity. For `⊆`: let `u + u' ∈ L(V+V')` with `u ∈ V`, `u' ∈ V'`. Then
`π_R(u) = −π_R(u') ∈ W`, so `u ∈ V ∩ (S* ⊕ W)`. □

**Fresh randomness lengthens `R` harmlessly.** If a later operation introduces a new mask space
`R_new`, the old state embeds by zero-extension into `(S ⊕ R ⊕ R_new)*`, and `L` of the embedded
state is unchanged, because a covector annihilating `R` still annihilates `R ⊕ R_new`. So *what the
state must carry so a later refresh does not invalidate it* is simply the full row space in
coordinates that **name** the mask directions, so a later observation can be recognised as touching
an old mask or not. Nothing is recomputed at a refresh; the only change is that Theorem 5 may now
permit a contraction.

### 4.2 Proactive refresh is exactly the `W = 0` case of Theorem 5

Herzberg–Jarecki–Krawczyk–Yung refresh re-randomizes a sharing by adding a fresh sharing of zero.
Take threshold-2 Shamir over `F_q`: shares `y_i = s + a·i` with mask `a`; the refresh draws fresh `b`
and replaces them with `y_i' = s + (a+b)·i`. An eavesdropper holding the single old share `y_1` has
`V = ⟨s + a⟩` and `L(V) = 0`. Every post-refresh share observation is a functional of `s` and
`a + b`, so the live mask covectors are `W = ⟨(1,1)⟩ ⊆ R*` in the basis dual to `(a,b)`, and
`R_dead = W^⊥ = ⟨a − b⟩`. The old row `s + a` has mask covector `(1,0)`, which does not annihilate
`a − b`, so

    V ∩ (S* ⊕ W) = 0 = L(V),

and by Theorem 5 the old share contributes nothing to any future leakage. That is proactive security,
obtained as a two-line contraction rather than a simulation argument. The contraction is available
only because the refresh randomness is genuinely fresh: if the adversary also sees the refresh update
messages, or the refresh reuses `a`, then `W` is larger, the contraction does not fire, and §6.3's
last two transcripts show the leakage growing.

### 4.3 Summary of the state hierarchy

| Assumption about the future | Coarsest exact state | Size |
|---|---|---|
| nothing beyond a rank bound `ρ ≥ 1` | `V` itself; one absorbing class `K ⊆ V` | `dim V` rows |
| mask directions `R_dead` retired | `V ∩ (S* ⊕ W)` | `≤ dim V` rows, monotone under further retirement |
| all masks retired (clean refresh) | `L(V)` | `dim L(V)` rows |
| finite unit menu, `≤ ρ` units to come | response vector `R_ρ(V)` | `Σ_{i≤ρ} C(N,i)` subspaces |

Only the last row is a genuine *quotient* of the algebra; the middle two are exact *contractions* of
the representation, which is what an implementation wants because they keep witnesses.

---

## 5. (4) The analyzer

Tier-1 module `~/src/ergodis-private/src/transcript_leakage.rs`, driven by the `tasks/tools`
subcommand `transcript-leakage-report`. Library-only, no new binary; builds into the shared
out-of-tree target `~/.cache/ergodis/target/ergodis-private`.

### 5.1 Input schema

A transcript is one JSON object. Coordinates are **named**, and observations are sparse maps from
coordinate name to an integer coefficient reduced modulo the characteristic, so a transcript reads
like the protocol it models.

```json
{
  "name": "astra-shared-mask",
  "note": "free text, copied into the certificate",
  "characteristic": 5,
  "secrets": ["s1", "s2"],
  "masks": ["r"],
  "operations": [
    { "name": "mask-s1",
      "fresh_masks": ["r"],
      "observations": [ { "name": "y1", "secret": {"s1": 1}, "mask": {"r": 1} } ] }
  ],
  "expect": { "leak_dims": [0, 1], "reuse_steps": [2] }
}
```

* `masks` declares the full ambient `R` up front, and `fresh_masks` records at which operation each
  direction is first used. Declaring a mask fresh that an earlier observation already used is a
  **schema error**, not a warning: it is a transcript claiming freshness it does not have, and it is
  exactly the assumption whose failure probe 1's Lemma 5 shows is silent and unsound. Fresh
  randomness introduced mid-transcript is the zero-extension of §4's Theorem 5 discussion, made
  explicit rather than implicit.
* An operation with no observations is legal and meaningful: it is a protocol step the adversary
  cannot see, such as an unobserved refresh, and it still retires mask directions.
* `expect` is the transcript's own assertion about its analysis; the run fails if it is not met.

### 5.2 Output, per step

`dim V`, `rank π_R(V)`, `dim L(V)`, the canonical basis of `L(V)` rendered in secret coordinate names
with a coefficient witness naming the observations combined, the **new-leak delta** against the
previous step with the same witnesses, and the **reuse alarm** `κ_i` with a basis of the shared mask
covectors and the mask names involved. A transcript-level `total_mask_deficiency`
`Σ_i rank π_R(V_i) − rank π_R(V)` records aggregate reuse.

For each prefix the report also gives the Theorem 5 contraction: the live mask covector dimension
`dim W`, the state dimension, the contracted dimension `dim(V ∩ (S* ⊕ W))`, and a check that the
final leakage space is unchanged when the prefix is replaced by its contraction. The difference
`state_dim − contracted_dim` is the **stale-state measure**: how much of what the adversary observed
the protocol has already made worthless.

### 5.3 Two independent cross-checks per step

1. **`ergodis::Matrix` row-space arithmetic.** `dim V − rank π_R(V)` from
   `Matrix::canonical_row_basis_with`, and the leakage space itself from `Matrix::null_space_with`
   applied to the transposed mask block, then mapped through the secret block. This shares no code
   with the module's own elimination and witness tracking.
2. **Exhaustive replay.** Every coefficient vector `u ∈ F_q^n` over the observed rows, keeping those
   with `u·B = 0` and spanning the resulting secret functionals. Run whenever `q^n ≤ 200000`; all
   thirteen steps of the committed corpus qualify, so the exhaustive replay covers the corpus
   completely.

The trusted boundary: both cross-checks and the module assume the transcript's stated observation
model is the adversary's real view, and all three work in the uniform linear model. Nothing here
certifies that a deployed protocol emits the observations its transcript claims.

---

## 6. Validation

### 6.1 Replay

Working directory `~/src/ergodis-private`:

```
cargo run -p ergodis-tools --release -- transcript-leakage-report \
  --out ../othello/notes/data/2026-09-06-c1070-probe6/transcript-leakage.report.json
cargo run -p ergodis-tools --release -- transcript-leakage-report --check \
  --out ../othello/notes/data/2026-09-06-c1070-probe6/transcript-leakage.report.json
cargo test --lib transcript_leakage
cargo fmt --check && cargo clippy --all-targets -- -D warnings
```

The `--check` form regenerates and compares byte for byte without touching the worktree. The run is
deterministic and canonical: no randomness, no timestamps, no host paths, inputs read in sorted
filename order, and all enumerations in odometer order.

### 6.2 Inputs and hashes

| File | Bytes | SHA-256 |
|---|---|---|
| `notes/data/2026-09-06-c1070-probe6/01-astra-shared-mask.transcript.json` | 701 | `5043bf1f51f79f0c5356cb0019e49ee90830dfc9b7cff42aefe6e69689eb4ead` |
| `notes/data/2026-09-06-c1070-probe6/02-astra-fresh-mask.transcript.json` | 790 | `af6819fe5d457641e90e3bcb79084d5bc09e85f218ffd77917fdd9f9693828fa` |
| `notes/data/2026-09-06-c1070-probe6/03-shamir-share-then-repair.transcript.json` | 1095 | `8f53711167a2f13f1feafad9be0fb4ad0de13db8e5c4500fdabc88fcccac6033` |
| `notes/data/2026-09-06-c1070-probe6/04-proactive-refresh-sealed.transcript.json` | 1037 | `94426f2a3a4863c0e71ead1391a8d86497a9fffc36a1b6d83b67a11ba50e9463` |
| `notes/data/2026-09-06-c1070-probe6/05-proactive-refresh-updates-observed.transcript.json` | 1071 | `e763907b9ce8332ba246ced211a94e701804c7d1f14d7e689a281e8117766d84` |
| `notes/data/2026-09-06-c1070-probe6/transcript-leakage.report.json` | 20392 | `17a3d9435feb057c93780e2f519baa206d729df19c10a931195d2c35983aff28` |
| `~/src/ergodis-private/src/transcript_leakage.rs` | 44262 | `fec97658d122040ca3727730253585a5f4539b0b0bf3eaeb855ad64a83a7a37c` |
| `~/src/ergodis-private/tasks/tools/src/transcript_leakage_report.rs` | 6757 | `576279c514e0792e483dbdb1014ad47d2544bceca4ef15f630a527da82517993` |

Certificate schema `c1070-probe6-transcript-leakage-v1`. The generator is committed in
`~/src/ergodis-private` at `de53b6c`.

### 6.3 The five transcripts

`leak` is `dim L(V)` after each operation, `κ` the coupling at each step, `deficiency` the aggregate
mask rank drop, and `contract` the per-prefix pair (state dimension, contracted dimension).

| Transcript | `q` | leak | `κ` | deficiency | contract |
|---|---|---|---|---|---|
| `astra-shared-mask` | 5 | 0, 1 | 0, 1 | 1 | (1,1), (2,1) |
| `astra-fresh-mask` | 5 | 0, 0 | 0, 0 | 0 | (1,0), (2,0) |
| `shamir-share-then-repair` | 7 | 0, 0, 1 | 0, 0, 1 | 1 | (1,1), (2,1), (3,1) |
| `proactive-refresh-sealed` | 7 | 0, 0, 0 | 0, 0, 0 | 0 | (1,0), (1,0), (2,0) |
| `proactive-refresh-updates-observed` | 7 | 0, 0, 1 | 0, 0, 1 | 1 | (1,1), (2,1), (3,1) |

Every step's leakage space agreed with both cross-checks; all thirteen steps were exhaustively
replayed; and the Theorem 5 contraction preserved the final leakage space at every prefix of every
transcript. The witnesses the analyzer produced for the newly leaked functionals:

| Transcript | step | leaked functional | witness |
|---|---|---|---|
| `astra-shared-mask` | 2 | `s1 + 4·s2` (that is `s1 − s2` over `F_5`) | `y1 − y2` |
| `shamir-share-then-repair` | 3 | `s` | `2·share1 + 5·helper3 + helper4` |
| `proactive-refresh-updates-observed` | 3 | `s` | `2·old-share1 + update2 − new-share2` |

Three readings worth stating.

* **The two Astra transcripts are the composition proof as data.** Identical per-operation leakage
  verdicts (`0` then `0`), identical ambient, different composed leakage. Any interface that
  summarises an operation by its own leakage space would return the same answer for both.
* **The Shamir repair alarms only at the step where it matters.** The coupling at step 2 is zero
  even though both observations use the same polynomial randomness `a₁, a₂`: their mask covectors
  `(1,1)` and `(3,2)` are independent, so by Proposition 6 leakage really is additive there. The
  alarm tests *covector* coupling, which is the exact condition, not naive coordinate sharing. At
  step 3 the mask block is already full rank, the third helper transcript must couple, and the
  secret leaks.
* **The two refresh transcripts differ only in whether the update messages are observed**, and that
  is the whole difference between zero leakage forever and full recovery of `s` at the next share.
  In the sealed one the old share's contraction is `(1,0)` at every prefix: the adversary's entire
  view is stale, which is the proactive-security statement in the analyzer's own output.

### 6.4 Exhaustive structure sweeps

Theorem 2's separation, checked by computing for each subspace `V` of `(S ⊕ R)*` the full rank-one
response map `v ↦ L(V + ⟨v⟩)` together with `L(V)`, then grouping subspaces by that signature.

| `q` | `k` | `m` | subspaces | response classes | absorbing (`K ⊆ V`) | unexpected collisions |
|---|---|---|---|---|---|---|
| 2 | 1 | 1 | 5 | 4 | 2 | 0 |
| 2 | 2 | 1 | 16 | 15 | 2 | 0 |
| 2 | 1 | 2 | 16 | 12 | 5 | 0 |
| 2 | 2 | 2 | 67 | 63 | 5 | 0 |
| 3 | 2 | 1 | 28 | 27 | 2 | 0 |
| 3 | 1 | 2 | 28 | 23 | 6 | 0 |
| 3 | 2 | 2 | 212 | 207 | 6 | 0 |
| 5 | 1 | 1 | 8 | 7 | 2 | 0 |
| 5 | 2 | 1 | 64 | 63 | 2 | 0 |

In every row `classes = subspaces − absorbing + 1` exactly: the absorbing subspaces collapse to one
class and nothing else collapses at all, which is Theorem 2 stated as a count. 444 subspaces were
classified across the nine ambient spaces, with zero unexpected collisions.

Proposition 6 and Corollary 7, checked over all unordered pairs of subspaces:

| `q` | `k` | `m` | pairs | decoupled | decoupled failures | coupled and superadditive | coupled and additive |
|---|---|---|---|---|---|---|---|
| 2 | 2 | 1 | 136 | 70 | 0 | 21 | 45 |
| 2 | 1 | 2 | 136 | 58 | 0 | 21 | 57 |
| 2 | 2 | 2 | 2278 | 688 | 0 | 741 | 849 |
| 3 | 2 | 1 | 406 | 153 | 0 | 120 | 133 |
| 3 | 1 | 2 | 406 | 151 | 0 | 120 | 135 |
| 5 | 1 | 1 | 36 | 15 | 0 | 10 | 11 |

3398 pairs, no decoupled failure anywhere — Proposition 6 has no exceptions in the searched domain —
and 1230 coupled pairs whose leakage is nevertheless additive, which is Corollary 7's one-sidedness
made quantitative: of the 2263 coupled pairs only 1033 actually leak more than the sum, so **the
alarm fires about twice as often as superadditive leakage occurs.** That is the correct behaviour for
a soundness alarm, and it is why the analyzer reports the coupling and the new-leak delta side by
side rather than the alarm alone.

**What these sweeps do not certify.** They are exhaustive over the listed ambient spaces only
(`k + m ≤ 4`, `q ∈ {2,3,5}`); they are evidence for theorems proved in §2 to §4, not a substitute
for them, and they say nothing about ambient spaces outside that domain. The stop condition was the
enumerated list, not a search that terminated on its own.

---

## 7. What this means for the product interface

1. **Ship the row space, not a verdict.** The exported state of an audited protocol must be the
   observed row space in `(s,r)` coordinates with named coordinates. Theorem 2 says every proposal
   to ship less — a leaked-symbol count, a leakage space, a pass/fail per operation — is unsound
   under composition, and the two Astra transcripts are the counterexample to hand a sceptic.
2. **Compression is a contract about the future, not a property of the state.** The two available
   compressions are the dead-mask contraction (Theorem 5), which needs a declaration that certain
   randomness is retired, and the menu response vector (Proposition 4), which needs the finite list
   of future observation units. An interface offering compressed state must publish which of the two
   assumptions it is trading on. This is the transcript-axis analogue of probe 1's freshness
   hypothesis (F), and it fails the same way if unverified.
3. **Freshness is a checkable declaration.** `fresh_masks` turns the assumption whose silent failure
   probe 1's Lemma 5 identified as the unsound direction into a schema error at load time. A protocol
   description that cannot say which randomness is fresh at which step cannot be audited exactly, and
   the tool should refuse rather than guess.
4. **Two numbers belong in every step of the report.** The coupling `κ_i` (a sound, conservative
   alarm) and the new-leak delta (the exact answer). Reporting only the first over-warns by about
   half; reporting only the second hides that a future single observation can close a coupling that
   has not yet leaked.
5. **The stale-state measure is a shipping feature.** `state_dim − contracted_dim` tells an operator
   how much of an adversary's accumulated view a refresh has already invalidated, and in the sealed
   refresh transcript it is the whole view. That is a proactive-security dashboard number computed by
   the same machinery, with no new theory.
6. **Repair transcripts are the natural demo.** The secure-regenerating-code literature
   (Pawar–El Rouayheb–Ramchandran; Shah–Rashmi–Kumar; Rawat–Koyluoglu–Silberstein–Vishwanath) models
   an eavesdropper on repair traffic with exactly this rank arithmetic but reports amounts; this
   analyzer reports the identified functional and the coefficient witness. Same for the masking
   verification tools (maskVerif, IronMask, SILVER, VRAPS), whose composition notions are the
   unlabelled summaries §2.2 shows cannot be exact. Neither comparison is a novelty claim; probe 0
   owns that question.

---

## 8. Mystery ledger

| Item | Status after the `ej` + `tt` closeout |
|---|---|
| Response classes equal `subspaces − absorbing + 1` in all nine sweeps | **Settled**: it is Theorem 2 counted. Not a mystery, and it is the sharpest available confirmation that the theorem's single exception is the only one. |
| The coupled-but-additive fraction is pinned at `0.52`–`0.53` in the four larger sweeps (`849/1590`, `133/253`, `135/255`, `11/21`) across two fields and three shapes, while the two smallest `F_2` ambients sit well above it (`45/66 = 0.68`, `57/78 = 0.73`) | **Open, and genuinely unexplained.** A false-alarm rate that stable once the ambient is not tiny suggests a limiting proportion of coupled subspace pairs whose leakage is additive, with the small `F_2` rows as boundary effects. Evidence gap: only `k+m ≤ 4` and `q ∈ {2,3,5}` were enumerated, so "pinned" is six data points. It is a counting question about pairs of subspaces with prescribed mask-block intersection, not a privacy question, so it is a discovery-track lead rather than a probe deliverable; no successor is allocated. |
| Is some non-subspace summary of the state (a matroid, a dimension pair, an equivalence on secrets) exact where the subspace is not? | **Settled, negatively.** Theorem 2 is a statement about the equivalence relation induced by the response, so it rules out *every* summary, including the dual "space of secrets still consistent with the view" `L(V)^⊥`, which carries strictly less than `V`. |
| Does the absorbing class matter in practice? | **Settled as trivial**: it is the state in which every secret functional has already leaked. It is the only quotient the algebra permits, and it is useless, which is itself the content of the negative. |
| Does the menu quotient of Proposition 4 actually collapse anything on real protocols? | **Open, measured nowhere.** Proposition 4 proves finiteness and the congruence, not a collapse ratio. Measuring the class count for a Shamir or regenerating-code menu is cheap with the machinery now committed and is the obvious successor experiment. Gate: needs a menu-based analyzer mode, which this probe did not build. |
| Non-uniform priors and noisy observations | **Out of scope by declaration**, not by evidence. Every statement above uses uniformity of `(s,r)` and exactness of the observations; the rank identity is false without them. |

---

## 9. Prior art noticed while working

Recorded for probe 0 to place, not adjudicated here. The dead-mask contraction of Theorem 5 is the
linear-algebraic core of the proactive secret-sharing security argument
(Herzberg–Jarecki–Krawczyk–Yung 1995), which is normally given as a simulation over epochs; the
contraction form is short enough to be folklore, and probe 0 should check whether it is stated
anywhere as a statement about the adversary's *state* rather than about the scheme. The rank-drop
reuse test is the linear-algebra shadow of two-time-pad detection and, in the side-channel setting,
of the probe-coupling conditions the maskVerif family checks; there the object is a gadget, here it
is a transcript.

