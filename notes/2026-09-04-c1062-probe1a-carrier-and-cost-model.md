# C1062 probe 1a: the carrier, the cost model, and the signature collapse

**Lane**: `complete-ports`
**Task**: C1062, probe 1a (pencil probe; no code)
**Plan**: `2026-09-04-c1062-exploration-log.md`
**Verdict**: the flat lowering is **viable but narrow**. The wall is the exogenous alphabet and the
generator transition tables, not the pin set. Probe 7's compositional route should be promoted from
"gated" to "expected necessary for anything beyond the stated envelope".

## 1. Why `state = u` fails, stated exactly

`ergodis/src/observational.rs` declares a generator as

```rust
pub struct GeneratorSpec {
    pub source_sort: u32,
    pub target_sort: u32,
    /// Global target-state IDs, one for each source state in source-sort order.
    pub transitions: Box<[u32]>,
}
```

so a generator is a **total function from one source sort into one target sort**, given as an
explicit table with one entry per source state. States are global `u32` ids partitioned into
contiguous `SortRange`s, and `observations` carries one `u32` per state.

Let `M = (U, V, F)` be an acyclic finite SCM: exogenous variables `U`, endogenous `V` with domains
`D_V` and mechanisms `f_V : Val(pa(V)) -> D_V`, `pa(V) ⊆ U ∪ V`. Acyclicity gives a unique solution
`M(u) ∈ Val(V)` for each `u ∈ Val(U)`.

If the state set is `Val(U)`, the generator for `do(V := a)` must be a function
`Val(U) -> Val(U)`. But `do(V := a)` does not act on `u` at all — it replaces `f_V` by a constant
and produces a solution of a **different model**. The only function on `Val(U)` it induces is the
identity, and a presentation whose every generator is the identity has the quotient "group `u` by
`O(M(u))`" — plain observational equivalence with no interventions at all. So the first plan's
lowering does not merely lose precision; it computes the wrong relation, and it computes it while
appearing to typecheck.

**The exception, stated tightly.** `state = u` remains closed exactly when every intervenable `V`
is exogenous in disguise: `pa(V) = {U_V}` for a dedicated exogenous parent and `f_V` a bijection
`D_{U_V} -> D_V`. Then `do(V := a)` is realized by `u[U_V := f_V^{-1}(a)]`, which is an element of
`Val(U)`. Interventions on any variable with an endogenous parent, or with a non-injective
mechanism, break closure. All four fixtures named in the plan (chain, fork, collider, diamond)
intervene on non-roots and therefore need the pair carrier.

## 2. The closed carrier

Take

```
X  =  Val(U)  ×  { partial assignments I : S -> Val(S),  S ⊆ V }
O(u, I)  =  π_Q( M_I(u) )                         Q ⊆ V the declared query-relevant set
g_{V:=a}(u, I)  =  (u, I[V ↦ a])                  total, deterministic
```

where `M_I` is `M` with `f_V` replaced by the constant `I(V)` for each `V ∈ dom(I)`. Every generator
is total and deterministic because acyclic re-solve is a function, so the presentation is well-formed
in the compiler's sense.

**Sort structure.** One sort per pinned *support set*: `Sort_S = Val(U) × Val(S)`, for each
`S ⊆ V` with `|S| ≤ k`. The generator `g_{V:=a}` out of `Sort_S` has

```
target_sort = Sort_S            if V ∈ S      (overwrite in place)
target_sort = Sort_{S ∪ {V}}    if V ∉ S      (requires |S| < k)
```

Both are single-target and total, which is exactly what `GeneratorSpec` requires. At the boundary
`|S| = k` the arity bound is enforced by simply **omitting** the generators that would add a new
variable; a typed presentation declares generators per source sort, so omission is legal and needs
no padding or sink state. This is cleaner than the alternative of encoding the bound as a
`FiniteContextLanguage` over generator words, which would restrict admissible words but still demand
generators total on the full unbounded carrier. Recommendation: **sorts, not a context language**,
for the arity bound.

## 3. The cost model

Let `n = |V|`, uniform domain size `d`, arity bound `k`, and write

```
σ_k  =  Σ_{j ≤ k} C(n, j)            (number of sorts)
π_k  =  Σ_{j ≤ k} C(n, j) d^j        (pin configurations)
|X_k| = |U| · π_k                    (materialized states)
```

Unbounded (`k = n`) this is `|X| = |U| · (d + 1)^n`, which is the `∏_V (|D_V| + 1)` factor the
revised plan reports. **The first plan's "forty generators, not 3^20" is true of the vocabulary and
false of the compile**: the exponential moved into the state count.

**Memory is dominated by the transition tables, not the states.** Each generator carries one `u32`
per source state, so

```
transitions  =  4 · Σ_S (#generators out of Sort_S) · |Sort_S|   bytes
             ≈  4 · n · d · |X_k|                                 bytes   (interior sorts)
observations =  4 · |X_k|                                         bytes
```

So the per-state cost is roughly `4(nd + 1)` bytes, not 4. For `n = 20, d = 2` that is 164 bytes per
state. A 2 GB working budget therefore caps the carrier at

```
|X_k|  ≲  1.2 × 10^7        (n = 20, d = 2)
```

well below the `u32` state-id ceiling of `2^32`, so **memory binds before the id width does**. This
is the number that matters and it did not appear anywhere in the first plan.

**The resulting envelope.** Solving `|U| · π_k ≤ 1.2 × 10^7`:

| n  | d | k | π_k   | max \|U\| |
|----|---|---|-------|-----------|
| 20 | 2 | 2 | 801   | ~15,000   |
| 20 | 2 | 3 | 9,921 | ~1,200    |
| 30 | 2 | 2 | 1,741 | ~6,900    |
| 10 | 2 | 3 | 1,161 | ~10,300   |
| 10 | 2 | 10 (full) | 59,049 | ~200 |

Read the other way: with a declared exogenous alphabet of about `10^4` states, arity 2 to 3 on 20 to
30 endogenous variables is comfortable, and full arity is not. That is a real envelope, and it is
narrow.

**The exogenous alphabet is the wall.** `|U|` is whatever the presentation declares. For an applied
model it is often modest — a failure vector over 14 components gives `|U| = 16,384`, which sits at
`1.3 × 10^7` states with `n = 20, k = 2`, right at the ceiling. For a **canonical** exogenous space,
where `U_V` ranges over response functions, `|U| = ∏_V d^(d^|pa(V)|)`; ten binary variables with two
parents each gives `16^10 ≈ 1.1 × 10^12` and is hopeless. Consequences:

- Applied fixtures (failure domains, capacity cuts, small circuits) fit, at arity 2 to 3, up to
  roughly 14 independent binary exogenous sources.
- **The Balke–Pearl response-function fixture is only checkable on tiny models.** With `d = 2` and
  at most two parents per variable, `n = 3` gives `|X| = 4096 × 27 ≈ 1.1 × 10^5` and `n = 4` gives
  `65,536 × 81 ≈ 5.3 × 10^6`; `n = 5` is already `2.5 × 10^8` and out. **Plan the fixture at
  `n ≤ 4`.** This is a correctness gate, not a scaling demonstration, so that is sufficient — but
  it must be stated so nobody later reads the small fixture as a scaling failure.
- Relevance pruning is not optional bookkeeping, it is part of the cost model: exogenous variables
  that are not ancestors of `Q` factor out of `Val(U)` entirely and should be removed before the
  carrier is built.

## 4. The signature collapse

**Proposition.** Fix the hard-intervention vocabulary (each generator overwrites one variable with a
constant). For `u, u' ∈ Val(U)` let `x = (u, ∅)` and `x' = (u', ∅)`. Then `x ~ x'` in the compiled
presentation if and only if `O(u, I) = O(u', I)` for every admissible partial assignment `I`.

*Proof.* Reachability: from `(u, ∅)`, the word `g_{V_1:=a_1} … g_{V_r:=a_r}` lands in `(u, I)` where
`I` is the final overwrite of that sequence, so the reachable set is exactly `{(u, I) : |dom I| ≤ k}`
and every admissible `I` is reached (by any word listing its assignments). The exogenous coordinate
is never touched, so no word leaves the `u`-fibre.

Observations: the observation sequence produced by reading a word `w` from `(u, ∅)` is
`(O(u, I_1), …, O(u, I_r))` where `I_1, …, I_r` are the prefix overwrites of `w`, and those depend
only on `w`. Hence the full observation behaviour of `x` is determined by, and determines, the
function `I ↦ O(u, I)`. Two root states are indistinguishable exactly when these functions agree. ∎

**Corollary (arity tower).** `x ~_{≤k} x'` iff `O(u, I) = O(u', I)` for all `|dom I| ≤ k`, and
`~_{≤1} ⊇ ~_{≤2} ⊇ …` refines monotonically. The tower need not stabilize below `k = n`: a
threshold-`t` outcome keeps refining until arity near `t`, so stabilization is a reported object, not
a stopping rule.

**Why this matters, and what it costs.** The root-state quotient is a **one-pass signature
partition**: compute the vector `(O(u, I))_I` per `u`, hash it, bucket. That costs `|U| · π_k`
solves — the same `|X_k|` evaluations the compiler performs — and `|U|` hashes of memory, which is
*less* than the compiler's `|X_k|` class ids. So partition refinement is neither a time nor a memory
win for the relation on root states. The revised plan says this; probe 1's report must repeat it,
because a probe 1 that reports only "the partitions agree" will have measured nothing.

## 5. What the compiler adds, enumerated

Four things, and only these. Each is the justification for a specific downstream probe, so this list
is the contract probe 1 must deliver against.

1. **The congruence on intervened states.** The signature partition says nothing about pairs
   `(u, I)`, `(u', I')` with non-empty pins. The compiler gives class equality for all of them,
   which means two contingency sets in the same class have identical futures under every subsequent
   edit. **This, not the quotient on `Val(U)`, is what prunes probe 3's contingency search**, and it
   is the mechanism behind the compact exhaustion certificate ("these `m` classes cover every
   smaller `W`, and each fails").
2. **Uniform replayable separator certificates**, in the compact split-transcript form the core
   already uses rather than exhaustive pair evidence.
3. **The arity tower for free.** `plan_layered_greedy_schedule` and the layered compile path give
   `~_{≤1} ⊇ ~_{≤2} ⊇ …` incrementally; the signature route recomputes from scratch at each `k`.
4. **Non-vacuity under a non-idempotent edit vocabulary.** The collapse in section 4 depends on
   overwrite composition being idempotent and commutative on distinct variables. It fails, and word
   structure becomes real, for: relative or shift edits on ordered domains (`V += 1`); mechanism
   edits that compose with the current mechanism rather than replacing it; and temporal unrolling
   where a policy edit's effect at one step changes what the same edit does at the next. **This is
   the only regime where "an SCM is just another context language" has content**, which is precisely
   why probe 8 (unrolled sequential window) was promoted out of the gated tail.

## 6. Kill criterion: not fired, but narrowed

The plan's criterion was "if the arity-bounded state count is impractical at every `k` producing a
non-trivial quotient, the flat lowering is dead and the spike jumps to probe 7". It does not fire:
arity 2 to 3 on `|U| ≲ 10^4` is practical and produces non-trivial quotients on exactly the applied
families probe 2 targets. But the envelope is narrow enough to change the plan's shape.

**Recommended changes.**

1. **Promote probe 7 (compositional lowering) from gated to expected.** Anything with a canonical
   exogenous space, or more than roughly 14 independent binary exogenous sources, is out of reach
   flat. The flat lowering is the correctness substrate and the small-model oracle; the
   compositional route is the only one that scales. This answers the open question left at the end
   of the plan revision: do not wait for probes 1 and 2 to gate it.
2. **Probe 1 must report `|X_k|`, the transition-table bytes, and the per-state constant
   `4(nd + 1)`** alongside the class count. Reporting `|U|` as "raw states" would understate the
   compile by two orders of magnitude.
3. **Fix the Balke–Pearl fixture at `n ≤ 4`** and say in the report that this is a correctness gate,
   not a scaling result.
4. **Add relevance pruning to the lowering itself**, not to the measurement: drop exogenous
   variables that are not ancestors of `Q` before building the carrier.
5. **Probe 1's deliverable is the cost model plus the four-item contract in section 5**, and its
   kill criterion is failure of the response-function fixture — not "the partitions agree".

## 7. Open, for probe 0

Nothing in this probe depends on the literature audit. Two of its answers change what is built on
top: whether the response-function partition identification is prior art that constrains the claim,
and whether an existing actual-causality engine reframes probe 3. Neither affects the carrier or the
cost model established here.
</content>
