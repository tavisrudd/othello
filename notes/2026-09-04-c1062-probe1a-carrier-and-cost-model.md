# C1062 probe 1a: the carrier, the cost model, and the signature collapse

**Lane**: `complete-ports`
**Task**: C1062, probe 1a (pencil probe; no code)
**Plan**: `2026-09-04-c1062-exploration-log.md`
**Reviewed**: `2026-09-05-c1062-probe1a-review.md`, with the cost-constant defect established in
`2026-09-05-c1062-probe1-review.md` § 2.1. Corrections are marked **[corrected]** below and the
original reasoning is kept wherever it explains how a number was reached.
**Replay**: none — this is a pencil probe with no code. Its arithmetic was recomputed independently
in the probe 1 review; the carrier costs it predicts are measured in
`ergodis-private` `evidence/2026-09-05-causal-lowering-repaired.txt`.
**Verdict**: the flat lowering is **viable but narrow**. The wall is the exogenous alphabet and the
generator transition tables, not the pin set. Probe 7's compositional route should be promoted from
"gated" to "expected necessary for anything beyond the stated envelope".

**[corrected]** "narrow" is six to nine times less narrow than the numbers below say, because
`4(nd + 1)` is the interior-sort constant rather than the arity-bounded one; see § 3. Probe 7's
promotion survives on the canonical-exogenous argument, which fails by twelve orders of magnitude and
does not care about a factor of six. Separately, the recommendation in § 2 to use sorts rather than a
context language forecloses the contingency pruning § 5 item 1 promises, and that trade is not named
here; it is the ceiling probe 3 later hit.

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

**[corrected] the trade this recommendation makes is not named, and it costs § 5 item 1.** In a
typed presentation the generators are declared per source sort, so states in different sorts have
different outgoing generator sets and a label-respecting bisimulation can never identify them —
`CompiledObservation` carries one `SortRange` per sort. A contingency candidate's pinned support
*is* its sort, so two different contingency sets are never in the same class and the pruning item 1
promises can only act across the pinned **values** of one fixed support. Probe 3 measured the
consequence: verifier fractions flat at 66% to 73% and pruning falling to zero on the larger rows,
because the candidate count is dominated by the witness-set choice, which is exactly the axis the
congruence cannot touch. The memory argument for sorts is still right — the context-language route
materializes `|U| · (d+1)^n` against `|U| · π_k` — but the recommendation buys memory and gives up
cross-support identification, and that should have been stated here. See
`2026-09-05-c1062-probe1a-review.md` § 2 and `2026-09-05-c1062-probe3-review.md` § 2.3.

## 3. The cost model

Let `n = |V|`, uniform domain size `d`, arity bound `k`, and write

```
σ_k  =  Σ_{j ≤ k} C(n, j)            (number of sorts)
π_k  =  Σ_{j ≤ k} C(n, j) d^j        (pin configurations)
|X_k| = |U| · π_k                    (materialized states)
```

**[corrected]** These are a special case, not the general form. Sorts range over subsets of the
declared **intervenable** set, not of `V`, so the binomial is `C(m, j)` with `m = |intervenable|`;
and domains need not be uniform, so `π_k = Σ_{|S| ≤ k} ∏_{v ∈ S} d_v`. The implementation is general
in both. One shipped fixture is already outside the uniform form: `identity-predicted-loss` has
domains 2 and 3, giving `π_2 = 1 + (2 + 3) + 6 = 12` and `6 × 12 = 72` states, which no single `d`
in `1 + 2d + d²` reproduces. The `m = n` assumption is also the one probe 3's `enumerate_supports`
bug depended on.

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

**[corrected] `4(nd + 1)` is the interior constant and is wrong for the regime this envelope is
about.** The `(interior sorts)` qualifier attached to the derivation above is dropped from the
conclusion, and in the arity-bounded regime the interior sorts are a vanishing minority: a sort at
the bound carries `kd` generators, not `nd`, and `C(n,k) d^k` dominates `Σ_{j<k} C(n,j) d^j`.
Recomputed:

| n  | k | d | nominal `4(nd+1)` | realized | overstatement | `\|X\|` at 2 GB, nominal | realized |
|----|---|---|-------------------|----------|---------------|--------------------------|----------|
| 20 | 2 | 2 | 164               | 27.4     | `6.0x`        | `1.2e7`                  | `7.3e7`  |
| 20 | 3 | 2 | 164               | 39.0     | `4.2x`        | `1.2e7`                  | `5.1e7`  |
| 30 | 2 | 2 | 244               | 27.6     | `8.8x`        | `8.2e6`                  | `7.2e7`  |
| 10 | 3 | 2 | 84                | 37.7     | `2.2x`        | `2.4e7`                  | `5.3e7`  |

`memory binds before the id width does` still holds at the corrected ceiling. What the probe did not
anticipate is that for the audited certificate policy neither the transition table nor the id width
binds: the core repair note records `ExhaustivePairAudit` reaching 6.9 GB at 205,056 states, so the
practical cap is the certificate's memory.

**The resulting envelope.** Solving `|U| · π_k ≤ 1.2 × 10^7`:

| n  | d | k | π_k   | max \|U\| as written | max \|U\| corrected |
|----|---|---|-------|----------------------|---------------------|
| 20 | 2 | 2 | 801   | ~15,000              | ~91,000             |
| 20 | 2 | 3 | 9,921 | ~1,200               | ~5,200              |
| 30 | 2 | 2 | 1,801 | ~6,900               | ~40,000             |
| 10 | 2 | 3 | 1,161 | ~10,300              | ~46,000             |
| 10 | 2 | 10 (full) | 59,049 | ~200        | ~200                |

**[corrected]** two things in this table. The `n = 30, k = 2` row read `π_2 = 1,741`; the correct
value is `1,801`, since `1 + 30·2 + 435·4 = 1,801` and the singleton term was dropped. And the
`max |U|` column is recomputed against the realized per-state cost above; at full arity the two
constants coincide, which is why the last row does not move.

Read the other way: with a declared exogenous alphabet of about `10^5` states — **[corrected]** from
`10^4` — arity 2 to 3 on 20 to 30 endogenous variables is comfortable, and full arity is not. That
is a real envelope, and it is narrow, an order of magnitude less narrow than first written.

**The exogenous alphabet is the wall.** `|U|` is whatever the presentation declares. For an applied
model it is often modest — a failure vector over 14 components gives `|U| = 16,384`, which sits at
`1.3 × 10^7` states with `n = 20, k = 2`, right at the ceiling. For a **canonical** exogenous space,
where `U_V` ranges over response functions, `|U| = ∏_V d^(d^|pa(V)|)`; ten binary variables with two
parents each gives `16^10 ≈ 1.1 × 10^12` and is hopeless. Consequences:

- Applied fixtures (failure domains, capacity cuts, small circuits) fit, at arity 2 to 3, up to
  roughly 16 independent binary exogenous sources — **[corrected]** from 14, since `2^16 = 65,536`
  fits under the corrected `~91,000` ceiling and `2^17` does not.
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

**[corrected] the proposition is about roots only, and the generalization is not the obvious one.**
The proof and the statement are correct as written and were independently checked in
`2026-09-05-c1062-probe1a-review.md` § 1. But `(u, I)` and `(u', I'')` with non-empty pins are
equivalent iff `dom(I) = dom(I'')` **and** `O(u, I ⊕ w) = O(u', I'' ⊕ w)` for every admissible word
effect `w` — indexed by the overwrite, not by the absolute pin set, because a word cannot unpin a
coordinate and the untouched coordinates keep each state's own values. § 5 item 1 makes a claim about
exactly these states without that qualification.

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

**[corrected] scored against the finished task.** Item 4 came in as promised, by probe 8, and it is
the item that paid — promoting probe 8 out of the gated tail on the strength of this list was right.
Item 2 was delivered not by probe 1 (which decoded rather than replayed) but by probe 5, where 2,601
of 3,100 replayed separators were the null intervention; probe 1's replay gate has since been run
and passes. Item 3 was never built: probe 1's tower is computed by the direct oracle at full price
per rung. Item 1 is capped by § 2's own sort structure, above. And the thing the task's closeout
ended up naming as what compilation buys — probe 4's decidable expressibility test, which tells a
caller a counterfactual query is inexpressible instead of returning a wrong fraction — is **not on
this list at all**. "And only these" was wrong in both directions.

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

**[corrected] the criterion as written could not have fired.** `k = 1` produces a non-trivial
quotient on essentially any fixture with more than one class, and `|U| · (1 + Σ_v d_v)` states is
practical for any `|U|` worth writing down; to fire, *every* `k` with a non-trivial quotient would
have to be impractical, and the smallest such `k` never is. A version that can fire: no `k`
producing a quotient strictly coarser than the identity fits the declared budget. The substantive
verdict is nonetheless robust, and in an unexpected direction — the criterion was evaluated against
the too-pessimistic constant of § 3, which pushes toward firing, and it still did not fire.

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
