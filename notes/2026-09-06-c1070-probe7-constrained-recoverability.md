# C1070 probe 7 — legitimate versus illegitimate recoverability

**Lane**: `ergodis`
**Task**: C1070, probe 7 of the compositional-leakage brief
(`2026-09-06-c1070-ergodis-compositional-leakage-brief.md`, section 7).
**Engines reused**: `hierarchical_leakage` (tower compilation, minimum-cost coalition search with
coefficient witnesses, the public-core recovery oracle), `leakage_structure` (the `t`-symbol
profile, both the sweep and the direct method), `vector_leakage` (Pareto antichains under per-unit
vector costs), all behind probe 8's `LeakageProblem`. No engine was refactored.

**Scope**, unchanged from the rest of C1070: the uniform linear model over a finite field. No
non-uniform priors, no noisy or adaptive observation, no nonlinear operations, no side channels, no
computational privacy.

---

## 0. Verdict

Astra's product sentence — "optimize legitimate recoverability subject to constraints on
illegitimate recoverability" — is exactly the **ε-constraint form of a two-objective Pareto
problem**, and legitimate and illegitimate recoverability are *the same labelled cost function*
evaluated at a different target and a different observation model. Nothing new has to be built to
price the adversary: the reader's minimum-cost coalition search, run against the protected
functional and the adversary's unit pool, *is* the adversary's cost. The design entry point is
therefore a loop over a candidate family that calls one existing primitive twice per candidate.

The formulation verdict, proved in section 1: the ε-constraint form never misses a Pareto-optimal
encoding, and the two forms return the same object exactly when, for every attained threshold, all
legitimate-cost minimizers of the feasible set share one adversarial cost. When they do not, the
ε-constraint form can return a *dominated* encoding — a real failure mode with a two-line
counterexample, and the reason the built tool reports the front rather than one constrained optimum.

---

## 1. Formulation

### 1.1 One cost function, two evaluations

Fix a field `F_q` and a compiled hierarchical encoding `E` (a tower). Write `W = F_q^n` for the
space of linear functionals on the message, `w_j ∈ W` for the functional computed by leaf
coordinate `j`, and let an **observation model** be a finite list of cost-bearing *units*, each
naming a set of leaf coordinates. A coalition `H` of units observes
`V_H = span{ w_j : j ∈ coords(H) }` and pays `c(H) = Σ_{u ∈ H} c(u)`.

The single primitive is

> `μ_E(T, U) = min { c(H) : H ⊆ U, T ⊆ V_H }`,

the least cost, in the unit pool `U`, of a coalition whose observed span contains the whole target
subspace `T ≤ W`, together with the coefficient witness expressing each row of `T` over the observed
coordinates. `μ_E(T, U) = ∞` when no coalition in `U` recovers `T`. This is
`LeakageAnalyzer::min_cost_coalition` from probe 5, unchanged.

* A **legitimate reader** is a pair `(T, U)` where `T` is a functional the reader must recover — a
  named target functional, a whole block's worth of symbols for a repair, or the whole message for a
  reconstruction — and `U` is the units that reader is entitled to. Its cost is `μ_E(T, U)`, and the
  requirement is `μ_E(T, U) < ∞`.
* An **adversary** is a pair `(T', U')` where `T'` is a protected secret functional and `U'` is the
  units the observation model exposes to a coalition. Its cost is `μ_E(T', U')`, and the constraint
  is `μ_E(T', U') ≥ τ`, satisfied vacuously when the value is `∞`.

The manuscript's recovery problem and the C1070 leakage problem are the same function. This is the
whole content of "legitimate versus illegitimate": the labels live in the *question*, not in the
machinery.

Two derived forms are needed for realistic requirements and are also built from `μ`:

* **Universal reader requirement.** "Any `k` shares reconstruct" is not a minimum but a maximum:
  every `k`-subset `H ⊆ U` must satisfy `T ⊆ V_H`, and the cost charged is
  `max { c(H) : |H| = k }`, the worst entitled reader's bill. Feasibility here is the MDS-style
  condition; under uniform unit costs the charge is `k`.
* **Threshold profile constraint.** `Γ_t(E, U) = min { c(H) : dim(S ∩ V_H) ≥ t }` for a declared
  secret subspace `S`, probe 2's sweep quantity. The constraint `Γ_t ≥ τ_t` is the amount-only form
  of the adversarial requirement and is supported alongside the labelled form.

### 1.2 The design problem

Let `F` be a **finite family** of candidate encodings — every choice of inner block generator from a
stated list, or every assignment of the free coefficients of a parameterized generator over `F_q`.
Let `R = {(T_i, U_i)}` be the legitimate requirements and `C = {(T'_j, U'_j, τ_j)}` the adversarial
constraints. Define, for `E ∈ F`,

* the **legitimate cost** `L(E) = max_i cost_i(E)` (`∞` if any requirement is infeasible), where
  `cost_i` is `μ` or the universal-reader maximum as declared; and
* the **adversarial cost vector** `A(E) = ( μ_E(T'_j, U'_j) )_j`, one component per protected
  constraint, ordered componentwise; its summary scalar is the **weakest link**
  `a(E) = min_j A_j(E)`, the cheapest attack.

Each component takes values in `ℕ ∪ {∞}` ordered as usual, `∞` greatest. With a single protected
constraint — the case of all three validations in section 3 — `A` is that scalar and the front is
the `(legitimate cost, adversarial cost)` curve the product framing asks for. The **constraint
problem** is

> `P(τ)`: minimize `L(E)` over `{ E ∈ F : μ_E(T'_j, U'_j) ≥ τ_j for every j }`,

and the **Pareto problem** is: return the non-dominated elements of `F` for
`(L → min, A → max)`, where `E'` *dominates* `E` when `L(E') ≤ L(E)` and `A(E') ≥ A(E)`
componentwise with at least one inequality strict.

Aggregating the requirements by `max` is a modelling choice and is stated as one: it makes `L` the
bill of the most expensive obligation, the conservative reading. The adversarial side is *not*
aggregated for the order — each protected functional keeps its own component, so a candidate that
hardens one secret while softening another is incomparable rather than silently averaged. The
weakest-link scalar `a` is reported as a summary only. Per-requirement and per-constraint costs are
reported individually so a different aggregation can be read off the same output without re-running
the search.

### 1.3 The coincidence theorem

Write `Feas(τ) = { E ∈ F : A_j(E) ≥ τ_j ∀j }` and, when nonempty,
`Opt(τ) = argmin { L(E) : E ∈ Feas(τ) }`. Let `Par(F)` be the set of non-dominated elements.

**Theorem (ε-constraint completeness and the exact coincidence).** Let `F` be finite.

1. *(Soundness of a tie-broken constrained solve.)* If `Feas(τ) ≠ ∅` then any `E*` maximizing `A`
   over `Opt(τ)` is Pareto-optimal.
2. *(Completeness.)* Every `E ∈ Par(F)` lies in `Opt(τ_E)` for the single-constraint threshold
   vector `τ_E` given by `τ_{E,j} = A_j(E)`. Hence the ε-constraint form reaches every point of the
   front, including points on non-convex parts of it, which weighted-sum scalarization does not.
3. *(Coincidence.)* `Opt(τ) ⊆ Par(F)` for every `τ` with `Feas(τ) ≠ ∅` **if and only if** the
   values of `A` on `Opt(τ)` form an antichain under the componentwise order, for every such `τ`.
   When `A` is scalar this says `A` is constant on `Opt(τ)`.

*Proof.* (1) Suppose `E'` dominates `E*`: `L(E') ≤ L(E*)`, `A(E') ≥ A(E*)`, one strict. Since
`A_j(E') ≥ A_j(E*) ≥ τ_j` for every `j` — here the componentwise reading of the constraint is what
is used — `E' ∈ Feas(τ)`, so `L(E') ≥ min L = L(E*)`, whence `L(E') = L(E*)` and `E' ∈ Opt(τ)`. By
the choice of `E*` as an `A`-maximizer of `Opt(τ)`, `A(E') ≤ A(E*)`, so `A(E') = A(E*)`. Both
inequalities are equalities, contradicting strictness. □

(2) Take `E ∈ Par(F)` and `τ_E` as stated. Then `E ∈ Feas(τ_E)`. If some `E' ∈ Feas(τ_E)` had
`L(E') < L(E)`, then `A_j(E') ≥ τ_{E,j} = A_j(E)` for every `j` and `L(E') < L(E)`, so `E'`
dominates `E`, contradicting Pareto-optimality. Hence `E ∈ Opt(τ_E)`. □

(3) (⇐) If the `A`-values on `Opt(τ)` form an antichain, then every `E ∈ Opt(τ)` is an `A`-maximal
element of `Opt(τ)` and the argument of part (1) applies to it verbatim (part (1) used only that no
element of `Opt(τ)` has a strictly larger `A`-value). (⇒) Suppose two elements of `Opt(τ)` are
comparable with a strict difference: `E₁, E₂ ∈ Opt(τ)` with `A(E₁) ≤ A(E₂)` componentwise and
`A(E₁) ≠ A(E₂)`. Then `L(E₂) = L(E₁)` and `E₂` dominates `E₁`, so `E₁ ∈ Opt(τ) \ Par(F)`. □

(Coordinator's correction on review: the original statement read "`A` is constant on `Opt(τ)`",
which is the right condition only for scalar `A`; for vector `A` two incomparable values on
`Opt(τ)` do not produce a dominated element, so the antichain condition is the exact one.)

**Read this as a product statement.** Part (2) says a customer who states thresholds loses nothing:
sweeping `τ` over the attained adversarial values enumerates the whole front. Part (3) says a
customer who states thresholds *and takes whatever the solver returns* can be handed a strictly
worse encoding than one available at the same legitimate cost, whenever the constrained optimum has
ties in `L` that differ in `A`. Ties in `L` are the normal case, not a corner case: section 3's
second validation has sixteen feasible candidates all at legitimate cost 2. So the entry point
computes and returns the front, and reports the constrained optimum as a query against it.

**A vector-cost remark.** Nothing above uses the totality of the order on `L` and `A`; parts (1),
(2) and (3) hold verbatim with `L` and `A` valued in any partially ordered set, reading `argmin` as
"minimal elements" and `A`-maximizing as "choosing an `A`-maximal element of `Opt(τ)`". What the
scalar case adds is that the front is a curve rather than an antichain of antichains, which is why
the built entry point puts the vector costs of probe 3 *inside* each front element rather than
making the front itself vector-valued; see section 2.4.

---

## 2. What was built

`~/src/ergodis-private/src/leakage_design.rs`, a tier-1 module beside `leakage.rs`, and the tier-2
subcommand `ergodis-tools leakage-design-report`
(`tasks/tools/src/leakage_design_report.rs`). No engine was refactored; the only additions outside
the new files are one `pub mod` line in `src/lib.rs` and the three command-tree lines in
`tasks/tools/src/main.rs`.

### 2.1 The schema

```json
{
  "schema": "c1070-leakage-design-v1",
  "name": "...",
  "base":   { ...a probe 8 LeakageProblem... },
  "family": { "slots": [ { "level": 0, "block": 0,
                           "choices":  [ {"name":"...", "generator": {...}} ],
                           "template": {"rows":2,"cols":3,"data":[1,0,255,0,1,255]},
                           "hole": 255, "hole_values": [] } ] },
  "legitimate":  [ { "name":"...", "target": {...}, "observation": {...}, "all_subsets": 2 } ],
  "adversarial": [ { "name":"...", "target": {...}, "profile_t": 2,
                     "observation": {...}, "threshold": 2 } ],
  "cross_check": true
}
```

* **`base`** is a probe 8 `LeakageProblem` verbatim, so every committed probe 3 and probe 5 encoding
  is a legal base. Its `observation` is the default unit pool for both sides, its `secret` is the
  subspace a `profile_t` constraint refers to, and its `cost_model`, when present, attaches probe 3's
  Pareto antichains to every reported side value.
* **A slot** names one `(level, block)` whose generator varies. It is either explicit `choices`, or
  a `template` whose entries equal to the `hole` marker (255 by default, outside every supported
  field) range independently over `hole_values` — all field elements unless stated. The family is the
  Cartesian product of the slots, enumerated by a canonical odometer with the first slot varying
  fastest, so candidate indices and labels are stable across runs.
* **A target** is named three ways: explicit `functionals` over the message coordinates, a list of
  leaf `coordinates` (their functionals — this is how a block repair is stated), or
  `whole_message`. Rows are zero-extended over any mask coordinates, which is probe 1's pinning.
* **A legitimate requirement** is existential by default — the minimum-cost coalition in its pool —
  or universal when `all_subsets: k` is given, in which case every `k`-subset of the pool must
  recover the target and the charge is the most expensive succeeding subset.
* **An adversarial constraint** is either labelled (a `target`) or amount-only (`profile_t`), and
  carries a `threshold` the adversary's cost must reach.

### 2.2 The engines behind each evaluation

| Question | Call | Probe |
|---|---|---|
| Minimum-cost coalition for a target, with the coefficient witness | `LeakageAnalyzer::min_cost_coalition` | 5 |
| Does a named subset recover the target | `LeakageAnalyzer::express_target` | 5 |
| `Γ_t` for the declared secret | `FlatInstance::profile_sweep` | 2 |
| Pareto antichain of a side's cost vectors | `VectorAnalyzer::pareto_antichain` | 3 |
| Mask pinning inside the compiler | `CompiledTower::compile` | 1, 8 |

Each candidate is compiled once and each side gets an analyzer over its own unit pool. The search is
exhaustive over the family; the report states the slot sizes, the family size, the number of engine
evaluations, and the best-first nodes popped inside them.

### 2.3 What a front element carries

`legitimate_cost` and the `adversarial_cost` vector, the representative candidate's label and its
generators, and for every requirement and constraint the `SideValue`: the cost, an `unrecoverable`
flag, the witnessing `Recovery` (unit indices, unit names, observed coordinates, and the
coefficient matrix expressing the target over those coordinates), the subsets checked and failed for
a universal requirement, and probe 3's antichain when a cost model is present. The adversary's
witness is the attack, written out in the same shape as the reader's recipe; that symmetry is the
point of the module.

`attained_by` lists every candidate at that cost point, because a front *point* is usually reached
by many encodings and the designer needs to see the whole equivalence class before choosing on a
criterion the model does not carry.

### 2.4 Vector costs

The front itself is over the scalar `L` and the componentwise `A`, and the vector costs of probe 3
live *inside* each side value rather than replacing them. The reason is stated rather than assumed:
with vector-valued `L` and `A` the front becomes an antichain of antichains, and the theorem of
section 1.3 still holds but the object returned is no longer the curve the product framing asks
for. `tower-inner-32-f5-vector` in section 3 shows both together — the same front, with the
`[leaves, nodes]` antichain on every side value.

### 2.5 The cross-check

`cross_check: true` (the default) recomputes **every** candidate's every cost by an independent
path, and the subcommand exits nonzero on any disagreement.

* Existential requirements and labelled constraints: a full sweep over all `2^u` coalitions whose
  recovery test is `LeakageAnalyzer::core_recovers`, which is
  `ergodis::Matrix::canonical_row_basis_with` rank arithmetic in the public core, not this crate's
  elimination; the minimum is a plain scan, not a best-first search.
* Universal requirements: the same core rank test on every `k`-subset.
* `Γ_t` constraints: probe 2's `profile_direct`, the minimum over every `t`-dimensional subspace of
  the secret, against the sweep — the equality probe 2's Theorem A licenses.

So the two sides of every reported number come from different recovery arithmetic, except the
`Γ_t` pair, where they come from the same arithmetic under two different quantifier orders.

---

## 3. Validation

All four runs agree with their independent sweep, on every candidate, not only on the front.

### 3.1 `mds-pair-f5` — the brief's pair

Two shares' worth of family: `(x, y, x+y)` against `(x, y, x+2y)` over `F_5`, message dimension 2,
one leaf unit per share at cost 1. Legitimate requirement: **any two shares reconstruct the whole
message** (`all_subsets: 2`). Adversarial constraint: the secret `x+y`, threshold 1 so that both
candidates are feasible and the *dominance*, not the threshold, decides.

```text
family 2 = [2], feasible 2, engine evaluations 4, nodes popped 15
Pareto front (legitimate cost minimized, adversarial cost maximized):
  L=2 A=[2]  code=x+2y  (1 candidate(s))
    legitimate reconstruct-from-any-two-shares: cost 2 via ["leaf0", "leaf1"]
    adversary   protect-x-plus-y: cost 2 via ["leaf0", "leaf1"]
cross-check: 2 candidates, 22 core recovery tests, agrees true
```

Both candidates satisfy the reader's requirement at cost 2; the plain code hands `x+y` to a single
share at cost 1, the twisted code charges 2. The front is the twisted code alone, as the brief
predicted. This input is also the concrete witness for part 3 of the theorem: at threshold 1 both
candidates minimize `L`, so a solver that returns *any* constrained optimum may return the plain
code, which is dominated. The unit test
`the_constrained_optimum_can_be_dominated` asserts exactly that.

### 3.2 `tower-inner-32-f5` — a parameterized `[3,2]` two-level tower

Level 0 is a `[3,2]` generator `[[1,0,a],[0,1,b]]` over `F_5` with both free coefficients ranging
over the field — **25 candidates**, the whole coefficient family. Level 1 stores each of the three
resulting symbols on a two-replica node, so the tower has six leaves in three blocks. The declared
secret subspace is the whole message.

Legitimate requirements: **repair node 2's two leaves from the leaves of nodes 0 and 1** (a
`coordinates` target, a four-leaf helper pool), and **any two nodes reconstruct the message**
(`all_subsets: 2` over the level-1 whole-block units). Adversarial constraints: the labelled `x+y`
at threshold 2 against leaf units, and the amount-only `Γ_2` at threshold 2.

```text
family 25 = [25], feasible 12, engine evaluations 100, nodes popped 2025
Pareto front (legitimate cost minimized, adversarial cost maximized):
  L=2 A=[2, 2]  inner=(2,1)  (12 candidate(s))
    legitimate repair-node2-from-nodes-0-and-1: cost 2 via ["n0a", "n1a"]
    legitimate reconstruct-from-any-two-nodes: cost 2 via ["L1B0", "L1B1"]
    adversary   protect-x-plus-y: cost 2 via ["leaf0", "leaf2"]
    adversary   gamma-2: cost 2
cross-check: 25 candidates, 3670 core recovery tests, agrees true
```

The arithmetic behind the counts, which the sweep confirms candidate by candidate: any two of the
three nodes reconstruct exactly when `a ≠ 0` and `b ≠ 0`, which leaves 16 of the 25; of those, the
four with `a = b` put a nonzero multiple of `x+y` on a single leaf and so fail the threshold, leaving
**12 feasible**. All twelve sit at the same cost point, so the front is one element attained by
twelve encodings.

That single-point front is itself the finding, and it is structural rather than accidental: under
uniform unit costs, a reconstruction-style legitimate requirement pins `L` at the code dimension for
every feasible candidate, so the design problem collapses to "maximize the adversarial cost" and the
Pareto machinery has nothing to trade. A genuine trade-off needs a legitimate requirement that is
*local* — a repair whose helper count varies with the coefficients — or heterogeneous unit costs.
That is what section 3.3 supplies.

The vector variant `tower-inner-32-f5-vector` adds probe 3's `[leaves, nodes]` cost model and an
extra existential reconstruction requirement over the node units. The front is unchanged, and each
side value now carries its antichain: the repair is `[[2, 0]]`, two leaves and no nodes; the
cheapest reconstruction is `[[0, 2]]`, no leaves and two nodes; the attack on `x+y` is `[[2, 0]]`.
The two resources separate exactly as probe 3's model intends
(`family 25 = [25], feasible 12, engine evaluations 125, nodes popped 2150`, cross-check 3870 tests,
agrees).

### 3.3 `locality-against-parity-f3` — the genuine trade-off

Message `(m0, m1, m2)` over `F_3`, five leaves: the three systematic symbols, a parameterized parity
`p = m0 + a·m1 + b·m2` with both coefficients free (**9 candidates**), and a fixed global parity
`q = m0 + m1 + m2`.

Legitimate requirement: **repair `m0` from the local group** `{m1, m2, p}` at unit cost 1 per leaf.
Adversarial constraint: **`m0` must be expensive for a coalition that sees only the two parity
leaves** `{p, q}`, threshold 1 so all nine candidates are feasible.

```text
family 9 = [9], feasible 9, engine evaluations 18, nodes popped 96
Pareto front (legitimate cost minimized, adversarial cost maximized):
  L=1 A=[1]  p=(0,0)  (1 candidate(s))
    legitimate repair-m0-from-the-local-group: cost 1 via ["p"]
    adversary   protect-m0-from-a-parity-only-coalition: cost 1 via ["p"]
  L=2 A=[unrecoverable]  p=(1,0)  (4 candidate(s))
    legitimate repair-m0-from-the-local-group: cost 2 via ["m1", "p"]
    adversary   protect-m0-from-a-parity-only-coalition: unrecoverable
cross-check: 9 candidates, 108 core recovery tests, agrees true
```

**Two front elements, and the trade-off is legible.** At `(a,b) = (0,0)` the parity *is* `m0`, so the
local repair costs one read — and so does the attack, because the same leaf is in the adversary's
pool. Paying one more read for the repair, at any `(a,b)` with exactly one coefficient zero, buys
`m0` complete unrecoverability from a parity-only coalition: `m0` is outside `span{p, q}` whenever
`a ≠ b`, and the four candidates `(1,0), (2,0), (0,1), (0,2)` are exactly the repair-cost-2 ones with
`a ≠ b`. The remaining four candidates pay repair cost 3 and buy nothing more, so they are dominated
and off the front.

Reading the ε-constraint form off the same output: at threshold 1 the constrained optimum is repair
cost 1; at threshold 2 the `(0,0)` candidate becomes infeasible and the constrained optimum is repair
cost 2. Sweeping the threshold over the attained adversarial values enumerates both front points,
which is part 2 of the theorem in one line of output.

### 3.4 Tests

Five tests in `src/leakage_design.rs`, all passing inside the full private library suite
(`cargo test -p ergodis-private --release --lib`, 954 tests, 0 failures):

* the brief's pair has the twisted code as its whole front, with both sides' witnesses present;
* the constrained optimum can be dominated (part 3 of the theorem, witnessed on that pair);
* the parameterized tower family is 25 wide with 12 feasible and a one-point front;
* the locality input has a two-point front with four candidates at the second point; and
* unrecoverable is the greatest adversarial value under the dominance order, with equal points not
  dominating each other and opposed components incomparable.

Each of the first four asserts through the same helper, which fails the test if the independent
sweep disagrees with any reported cost.

---

## 4. Replay, inputs and hashes

Working directory `/home/tavis/src/othello/notes/data/2026-09-06-c1070-probe7`. Build from
`/home/tavis/src/ergodis-private` with `cargo build -p ergodis-tools --release`, then for each of
the four stems:

```text
~/.cache/ergodis/target/ergodis-private/release/ergodis-tools leakage-design-report \
  --input <stem>.design.json \
  --json-out <stem>.report.json \
  --summary-out <stem>.summary.txt
```

Stems: `mds-pair-f5`, `tower-inner-32-f5`, `tower-inner-32-f5-vector`,
`locality-against-parity-f3`. Adding `--check` verifies the tracked outputs against a fresh run
without writing; all four match. The subcommand exits nonzero when the independent coalition sweep
disagrees with any reported cost, so a green run is itself the cross-check. Verify the artifacts with
`sha256sum -c SHA256SUMS` in that directory. Tests:
`cargo test -p ergodis-private --release --lib leakage_design`.

Generator sources in `ergodis-private`, at the commit that carries them:

| file | bytes | SHA-256 |
|---|---|---|
| `src/leakage_design.rs`                    | 53587 | `ab7b4768807838ebcd90d61a74a3313ff1e70f9bfdc691457fc2a419b8fc0315` |
| `tasks/tools/src/leakage_design_report.rs` |  3064 | `4a6d0c947ad61577bc1076344ea37e5e5215806dd255cc36e6024e9d27dbc111` |
| `src/hierarchical_leakage.rs`              | 65834 | `e682a0d2d9930d73db3f2d08b243ed3e04e1467d2b009d7b0fdaa1c5b7fad314` |
| `src/vector_leakage.rs`                    | 38192 | `023337e807335cc9072d1997848453f620fe0e4fe7cda4c14f7a270b3c2b68ef` |
| `src/leakage_structure.rs` (at `HEAD`)     | 13271 | `b55d9ab4248f1902b71644731d19318d360c9a7c8b836083cce5efd49372cf2c` |

Inputs, reports and summaries with their byte counts and hashes:
`notes/data/2026-09-06-c1070-probe7/SHA256SUMS`.

**One provenance note on `leakage_structure.rs`.** The outputs were generated while a concurrent
session held an uncommitted, purely additive edit to that file — 82 inserted lines, no deletions,
adding `minimum_coalitions` and an optimal-coalition chain predicate for C1070 probe 10. Nothing this
probe calls (`profile_sweep`, `profile_direct`, `contains`, `cost`, `leak_dim`) is touched by it, so
the hash recorded above is the committed `HEAD` version and the outputs regenerate against it. The
`--check` run above was made in the same working tree; a regeneration on a clean checkout is the
remaining confirmation.

**What this certifies and does not.** Each reported cost is the exact minimum, or exact maximum for
a universal requirement, over the enumerated coalition lattice of the stated observation model,
under the stated per-unit costs, on the stated candidate family, in the uniform linear model. Each
front is exact for those costs and that family. Nothing here says anything about an adversary with a
different unit vocabulary, about non-additive costs, about families larger than the ones enumerated,
or about any non-uniform, noisy, adaptive, nonlinear or computational setting. The candidate
families are exhaustive by construction — every product of the declared slot choices — so the
negative statements ("12 of 25 feasible", "the other four are dominated") are exhaustive over that
family and over nothing else.

---

## 5. What this means for the product

1. **The adversary costs nothing extra to price.** Astra's constrained-optimization product is not a
   second engine; it is the shipped recovery engine called with the protected functional as its
   target and the exposed units as its pool. Anything the leakage surface can answer about an
   attacker, it can already answer about a reader, and the reverse. That collapses the roadmap item
   to a loop and a dominance filter.
2. **Return the front, not the constrained optimum.** Section 1.3 part 3 is not a technicality:
   `tower-inner-32-f5` has sixteen candidates tied at legitimate cost 2, and the tie is where the
   adversarial cost lives. A tool that answers "minimize cost subject to `Γ_t ≥ τ`" with one encoding
   can hand back a strictly worse design than one available for the same price. The front, plus
   `attained_by`, is the answer that cannot mislead.
3. **Both witnesses, always.** A front element that shows only the reader's recipe is an assertion;
   one that also shows the adversary's cheapest coalition and the exact coefficients reconstructing
   the secret is an audit. This is the labelled-composition claim of the C1070 synthesis applied to
   design rather than analysis, and it is what the surveyed masking-verification and
   secure-regenerating-code tools do not produce, because they compute amounts or unlabelled
   sufficient conditions.
4. **Where the trade-off actually lives.** Under uniform unit costs, a full-reconstruction
   requirement pins the legitimate cost at the code dimension and the design problem degenerates to
   maximizing adversarial cost. Real fronts appear when the legitimate requirement is *local* — a
   repair whose helper count depends on the coefficients — or when the resources are separated into a
   vector cost. Locality against privacy, section 3.3, is the shape of the tension, and it is the
   demo to lead with: the cheapest repair of `m0` is also the cheapest attack on `m0`, and one extra
   read buys unrecoverability.
5. **Scale, stated.** The family is swept exhaustively and every candidate's cost is verified by a
   `2^u` sweep, so the tool is exact at demo scale and exponential in the wrong places at
   customer scale. The engine bound from probe 9 applies unchanged — exact search closes at roughly
   80 wires — and the family multiplies it. A production version drops the per-candidate sweep to
   the front, prunes candidates on a cheap necessary condition before compiling, and reuses one
   analyzer across candidates that share a level.

---

## 6. Mystery ledger

The closeout `ej` + `tt` pass ran after section 3 was green. It produced two task-owned upgrades,
both applied and validated before this report was committed: the vector-cost variant of the tower
input, which was the cheap way to exercise probe 3's machinery through the design surface and which
showed the `[leaves, nodes]` components genuinely separating; and the second, existential
reconstruction requirement on that variant, without which the vector path had nothing to say about
the node units.

| Observation | Status |
|---|---|
| A full-reconstruction legitimate requirement under uniform unit costs pins `L` at the code dimension, so the front degenerates to a single point on the whole `[3,2]` family. | **Settled** by the `ej` pass and stated in section 3.2 and section 5 item 4: it is Singleton-style rigidity of the reader's cost, not a defect of the search. The design problem is only interesting when the legitimate side is local or the costs are heterogeneous. |
| At `(a,b) = (0,0)` in the locality family the repair cost and the attack cost are the same number attained by the same leaf. | **Settled**: reader and adversary pools intersect in that leaf, so the two `μ` evaluations are literally the same minimum. The general statement — `μ(T, U) ≥ μ(T, U')` whenever `U ⊆ U'`, so a shared unit bounds both sides at once — is why locality and privacy trade at all. |
| The twelve feasible tower candidates are indistinguishable to the model, yet an engineer would prefer some of them. | **Open, by design.** `attained_by` exposes the whole class rather than picking; the missing criterion (field size of the coefficients, symmetry, implementation cost) is not a recoverability quantity and does not belong in this objective. A successor that wants a tie-break must declare a third objective, not a hidden rule. |
| Whether the ε-constraint sweep can be run *incrementally* — reusing the search across thresholds instead of re-solving — is untouched. | **Open**, low value at this scale; it becomes real only when the family stops being exhaustively enumerable, which is the same wall as probe 9's wire count. |
| Whether the theorem's part 3 hypothesis (the `A`-values on `Opt(τ)` form an antichain; for scalar `A`, constant) is ever satisfiable in a non-degenerate design family. | **Settled negative in practice**: both non-trivial validations violate it — the brief's pair violates it at threshold 1, the tower family violates it across sixteen tied candidates. The condition is not a mild regularity assumption; it fails on the first two realistic instances, which is the whole justification for returning the front. |

No genuine mystery remains in the formulation. The theorem is proved, the three validations landed
on their predicted fronts, and every reported number is confirmed by an independent path. What is
open is engineering — scale, incrementality, and a tie-break criterion that lives outside
recoverability.
