# C1152 — certificate slice spike: ban store, bound law, polymorphic verifier

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: COMPLETE (spike, 2026-09-12); implementation is opt-in on a spike branch and not merged
**Predecessor**: `2026-09-12-c1151-category-theory-capability-pass.md` (merged ranking rows 2, 3, 4, 8)

Bounded spike: verify in code the assumptions the C1151 dossiers took from documentation,
design the certificate objects against what the code actually is, and prototype the smallest
measurable thing. Spike branches only; no main checkout is edited, no evidence claim is
touched, no default path changes.

Worktrees (branch `spike/c1152-certificate` in both):

- `~/.cache/ergodis/worktrees/c1152/ergodis` from `~/src/ergodis` at `927c618`
- `~/.cache/ergodis/worktrees/c1152/ergodis-private` from `~/src/ergodis-private` at `0e3a0cc`

Run data under `~/.cache/ergodis/c1152/`. Builds use the configured shared target
`~/.cache/ergodis/target/ergodis-private`. Nothing outside the two spike branches was changed;
the core repository needed no edit at all.

**One-line verdict.** The certificate objects are real and check out exactly, the generalized
admissible bound cuts 5.3% of search work on the retained workload with bit-identical verdicts,
and it costs slightly more wall time than it saves — so the slice's value turned out to be the
verification and the design, plus two cheaper successors the measurement exposed.

---

## Step 1 — code verification

All paths are in the spike worktrees; the same paths hold in the main checkouts at the
commits named above.

| # | Dossier assumption | Verdict | What the code does |
|---|---|---|---|
| a | `ordered_resource` supplies `(R, +, ≤, 0)` and Pareto fronts and "does not currently carry the subadditivity law" (part A §4.2) | **Right**, and the gap is wider than stated | The algebra exists and is exhaustively certified; there is no bound map `lb : Plan → R` anywhere, so subadditivity has nothing to attach to yet |
| b | Obstruction data on a failed admission is an open question (C1151 mystery ledger) | **Half wrong** | A *refutation* already carries a concrete distinguishing witness; a *decline* carries nothing but an error variant, and neither is stored or transported |
| c | The independent min-plus verifier is generic-ready — everything but the fold is semiring-agnostic (part B §5.3) | **Right about the structure, wrong about the type** | Written against one concrete 4×4 `u32` matrix type; the fold is the only algebra-dependent step, but the wire format, the digest and the layout assertion all hard-code its byte width |
| d | The C1143 sparse provider prunes by a bound that a subadditivity law would improve (rows 3, 4) | **Right** | Exactly one arithmetic bound cuts a subtree, and it is the uniform special case of an admissible dual bound |
| e | C1093's count readout is min-cost or all-solutions (C1151 mystery ledger) | **Both wrong** | It is neither: a closed-form saturating capacity count |

### (a) The resource algebra composes, but nothing maps plans into it

`ergodis/src/ordered_resource.rs:10` defines `FiniteOrderedMonoid` with exactly the four
operations the dossier assumed — `element_count`, `identity`, `combine`, `leq` — over compact
element identifiers `0..element_count`. `validate_finite_ordered_monoid`
(`ergodis/src/ordered_resource.rs:53`) certifies the laws by exhaustive triple enumeration:
identity, commutativity, associativity, reflexivity, antisymmetry, transitivity, order
monotonicity (`left ≤ right` implies `left + t ≤ right + t`, line 105) and extensivity
(`left ≤ left + right`, line 84). So the ordered-resource monoid `(R, +, ≤, 0)` that part A
§4.2 asks for is present and is checked rather than assumed.

What is absent is the other half of the inference rule. A search of both crates' sources for
subadditivity, the triangle inequality, and admissible heuristics returns nothing, and there is
no map from a plan, a morphism or a search prefix into the monoid. The only consumers of the
trait are `ergodis/src/frozen_shortest_path.rs`, `ergodis/src/interface.rs` and
`ergodis-private/src/leakage.rs`, and the shortest-path evaluator does not use the trait for its
own costs at all: `FrozenShortestPathPlan::solve_validated`
(`ergodis/src/frozen_shortest_path.rs:158`) is hard-coded to `u64` addition with the sentinel
`ABSENT_SHORTEST_PATH_COST = u64::MAX` (`ergodis/src/frozen_shortest_path.rs:10`).

So the dossier's statement is right, and the correction is that adding a law to
`ordered_resource` would attach it to nothing. The bound law has to be introduced where a
concrete search already computes a lower bound — which is item (d).

### (b) A refuted admission carries a witness; a declined one carries nothing

`check_reduction` (`ergodis/src/admission.rs:272`) returns
`AdmissionOutcome::Admitted(Admission) | Refuted(Counterexample)`
(`ergodis/src/admission.rs:265`), and `Counterexample`
(`ergodis/src/admission.rs:258`) holds `choices: Vec<u32>` — the canonical cost-table entry
indices of a feasible tuple the candidate rejects — plus `rejected_block: u32`. That is a
genuine obstruction witness, already computed at the failure site by the independent leaf
verifier, so the data the ban store needs exists for this failure class and does not have to be
reconstructed.

Three things are missing, and they are what the design has to supply.

1. **It is discarded.** `discover_coordinate_reduction`
   (`ergodis/src/admission.rs:353`) collects `DiscoveryTrial { parameters, receipt,
   counterexample }` per trial and returns them in a `DiscoveryRun`, and the header comment
   says "Refutations are retained" — but retained means "returned to the caller for this run".
   There is no store, no key, and no transport to a later question.
2. **It carries no scope.** `Counterexample` names neither the problem nor the candidate nor
   the query, so it cannot be indexed by the `(source, query, scope)` key part A §4.1 requires;
   the binding lives only in the surrounding `DiscoveryRun`.
3. **A decline is not a refutation and records nothing at all.** The failure that actually
   matters for the C1143 frontier is `AdmissionError::Budget`
   (`ergodis/src/admission.rs:581`), raised by `check_budget`
   (`ergodis/src/admission.rs:415`) and by the aggregate pre-check at
   `ergodis/src/admission.rs:370` when the declared domain exceeds the checker budget. It is a
   bare error variant: no scope, no witness, no record of *which* limit bound. The hold-out
   cases 5–7 decline exactly here, at the proposal limit, and the run therefore keeps no
   structured statement of what was refused.

The asymmetry is the finding: the engine can say precisely why a candidate is wrong and cannot
say anything about what it declined to consider.

### (c) The min-plus verifier is concrete, not generic, and its sentinel collides with saturation

The independent verifier is `ergodis/crates/verify/src/min_plus_transition.rs`. Its algebra is
one private type, `Summary` (`ergodis/crates/verify/src/min_plus_transition.rs:31`), a
`#[repr(C, align(64))]` 4×4 `u32` matrix with a compile-time size and alignment assertion at
line 36. The semiring operations it uses are exactly four, all in `Summary`:

- `one` — `Summary::identity()` (line 40), zero on the diagonal and `ABSENT` off it;
- `zero` — the constant `ABSENT = u32::MAX` (line 23);
- `⊗` — `step.saturating_add(tail)` guarded by `ABSENT` tests (lines 72–81);
- `⊕` — `if candidate < *slot { *slot = candidate }` (line 84), that is, `min`.

There is no `Divide`, no properties mask, and no trait: `WIDTH`, `SUMMARY_BYTES` and the
layout assertion are module constants. The dossier's structural claim is confirmed — every
other step is algebra-agnostic. `verify_delta_expected`
(`ergodis/crates/verify/src/min_plus_transition.rs:226`) does magic and version checks,
artifact and root binding, sequence-staleness checks, length arithmetic, sibling summary and
digest comparison, and a deferred commit, and touches the algebra only through `replay_path`
(line 407), whose sole algebraic step is `Summary::compose`. `replay_path` correctly respects
non-commutativity, choosing `compose(sibling, summary)` or `compose(summary, sibling)` by the
leaf's bit at that level.

Two facts constrain how "polymorphic" is achievable. First, the digests hash the *encoded*
summary: `leaf_digest` (line 447) and `internal_digest` (line 456) both call `Summary::encode`
into a `[u8; SUMMARY_BYTES]` buffer, so the weight type owns the wire encoding and its byte
width, and a generic parameter has to carry an associated encoded-length constant rather than
just the four operations.

Second — and this is new, not in the dossier — **the saturating multiply and the absent
sentinel are the same value**. `saturating_add` can return `u32::MAX` from two finite costs,
and that result is then indistinguishable from `ABSENT`, so a composed path whose true cost
reaches `2^32 − 1` is subsequently read as "no path". Part B row 3 located this blocker in the
summary trees and OpenFst's `Divide`; it is also present in the core verifier, where there is
no `Divide` at all. It is a declared-precondition problem, not a bug in the current corpus —
costs there are small — but a `properties()` mask cannot express it, because the defect is the
carrier's representation rather than an algebraic law.

### (d) The C1143 sparse provider prunes on exactly one arithmetic bound

The kernel is `ergodis-private/src/sparse_fault_search.rs`, entered through
`ergodis-tools css circuit-distance` (`ergodis-private/tasks/tools/src/circuit_distance.rs`).
`Plan::search_impl` (`ergodis-private/src/sparse_fault_search.rs:331`) is a single iterative
loop, const-generic over `TERMINAL`, `INDEXED` and `RESUME`, with a presized frame stack and no
allocation.

Four things cut work, and only the last is an arithmetic bound.

1. **Root minimality.** `if added as usize <= root { continue; }`
   (`ergodis-private/src/sparse_fault_search.rs:477`). Every column after the root has a
   larger identifier, licensed by the exclusion report's completeness argument that the root
   enumerates `min(S)`.
2. **Sibling exclusion.** The `forbidden` bitmap with an explicit undo stack
   (`ergodis-private/src/sparse_fault_search.rs:465`, and lines 568–571), so an earlier sibling
   is not re-entered below its successors.
3. **Exact terminal cancellation.** Under `TERMINAL`, the last column's normalized support must
   equal the odd-detector set exactly (line 493); under `INDEXED`, `complete_one`
   (line 223) looks the residual up by XOR fingerprint through
   `completion.partition_point(...)` and then re-checks the full support, so a fingerprint
   collision cannot admit anything.
4. **The bound**, and it is one line
   (`ergodis-private/src/sparse_fault_search.rs:537`):

   ```rust
   if w.odd != 0
       && weight < radius
       && w.odd <= (radius - weight) as u32 * self.max_degree
   ```

   `w.odd` is the number of currently odd detectors, maintained incrementally in `toggle`
   (line 201); `self.max_degree` is the largest detector-support size over all columns,
   computed once in `Plan::compile` (line 120). The child is entered only if the residual could
   still be cleared by the remaining `radius − weight` columns, each clearing at most
   `max_degree` odd detectors.

This is precisely the admissible-heuristic rule of part A §4.2 in the special case of a
constant heuristic, and it is subadditive for the trivial reason that the per-column capacity is
a constant. Its exact generalization is what the prototype implements: the rule "at most
`max_degree` per column" is the statement that the uniform multiplier vector `y[d] = 1/max_degree`
satisfies `Σ_{d ∈ support(c)} y[d] ≤ 1` for every column, and any other nonnegative vector with
that property gives an equally sound and possibly tighter bound.

Measured on the frozen hold-out sources, `max_degree` is 9 in every case, and the support-size
distribution is far from concentrated at the cap — on case 2 (37,395 columns) the counts by
support size are 90, 990, 6,795, 1,890, 6,165, 10,395, 4,140, 3,825 and 3,105 for sizes 1
through 9, and cases 5 and 7 have the same shape scaled up. Only about 8% of columns actually
attain the cap, so the uniform per-column capacity the engine uses is loose for most columns.

### (e) C1093's count readout is neither min-cost nor all-solutions

`BudgetQuery::repaired_count` (`ergodis-private/src/parametric_lrc_contract.rs:94`) delegates to
`LrcTransfer::repaired_at_extra` (`ergodis-private/src/parametric_lrc.rs:132`), whose whole body
is

```rust
self.threshold
    .min(self.local_capacity + self.global_capacity + u32::from(extra) as u64)
```

That is a closed-form saturating capacity count — the number of shards repairable at a budget
level — not a minimum-cost value and not an enumeration of solutions. `meets_target`
(line 99) is a threshold comparison against the same number, and the witness is a separate
readout, `reconstruct()` (line 104), which rebuilds the answer from the capacities rather than
counting anything.

The consequence for the certificate slice is concrete: C1093 is not a semiring readout at all,
so the tupled `Tropical × Generator` instantiations that part B §5.3 wants as the second and
third instances of a polymorphic verifier have no counterpart there. The only place in these
two crates with a genuine min-plus fold is the transition verifier of item (c).

## Step 2 — design

The C1151 design collapses four merged-ranking rows into one object: a store of bans, each
carrying the reason that justifies it, transported backwards along composition, enriched in
`Bool` for refusals and in an ordered semiring for bounds. Against the code, that object splits
cleanly into three pieces with different readiness, and the spike implements the one the code
makes cheapest.

### The ban store

```rust
/// Key. The nategory result says a ban indexed independently of what it
/// constrains does not compose, so the index is the hom-set: the same triple
/// `Admission` already keys on.
struct BanKey { source: ContentId, query: ContentId, scope: ScopeId }

/// A ban is upward closed in the cost preorder: `floor` is the threshold, and
/// everything at or above it is excluded.
struct Ban<Cost> { key: BanKey, floor: Cost, reason: BanReason<Cost> }

enum BanReason<Cost> {
    /// Exactly the data `check_reduction` already produces and discards.
    Refuted { choices: Box<[u32]>, rejected_block: u32 },
    /// The failure class that records nothing today: which limit, at what
    /// value, against what demand.
    Declined { limit: DeclinedLimit, allowed: u64, demanded: u64 },
    /// An exactly checked multiplier vector plus the value it certifies.
    DualCertificate { multipliers: DualBound, value: Cost },
    /// Derived by transport; the checker re-derives rather than trusts.
    Transported { from: BanId, along: MorphismId, direction: Dir },
}
```

`Cost = bool` gives refusals, `Cost = R` for an ordered resource gives bounds, and the store is
one structure either way. The concrete typing decision the code forces: `Cost` is not
`FiniteOrderedMonoid`'s compact `u32` element identifier, because a bound over a search prefix
is not drawn from a finite validated carrier. The bound half of the store should be typed over
an ordered commutative monoid with truncated subtraction (`monus`), with `FiniteOrderedMonoid`
kept as the validated finite instance and the search's own `u64` capacity counter as the other.

Backward transport has the side condition part A §4.1 states, and the code gives it teeth: a
transported floor is only valid when the morphism's cost map is monotone non-decreasing, so
`transport_pre` and `transport_post` return `Option` and emit nothing rather than an unsound
ban. That is the same discipline as `DualBound::checked` returning a refusal rather than a
clamped vector.

**What is cheap here and what is not.** `Refuted` is nearly free: the witness exists at the
failure site and needs a key and a home. `Declined` is the one that changes what the engine can
say, because the C1143 hold-out frontier consists entirely of declines, and today
`AdmissionError::Budget` is the whole record. `Transported` is the expensive part: it needs a
morphism-level cost map that does not exist yet, which is the same gap as item (a).

### The subadditive bound law as a checked inference rule

The rule part A §4.2 wants is

```text
require   lb(p ; q) <= lb(p) + lb(q)          subadditivity
          p <= q implies lb(p) <= lb(q)       monotonicity
prune     lb(prefix) + admissible_h(suffix) >= incumbent
```

In the sparse fault search the "incumbent" is the declared radius, `lb(prefix)` is the weight
already committed, and `admissible_h(suffix)` is a lower bound on how many further columns can
clear the odd-detector residual. The engine's own version of `admissible_h` is
`ceil(odd / max_degree)`, written multiplicatively to avoid the division.

The generalization that keeps this exact and makes it a *certificate* rather than a constant is
a nonnegative integer multiplier vector `y` over detectors with denominator `scale`, subject to

```text
for every column c:   sum over d in support(c) of y[d]  <=  scale
```

This is dual feasibility for the fractional set cover of the odd-detector residual, and it is
checked, never assumed. The bound is then `lb_y(O) = sum over d in O of y[d]`, and the prune is

```text
if  sum over d in O of y[d]  >  k * scale   then no k columns clear O
```

which is sound because `O` is contained in the union of any covering columns' supports and `y`
is nonnegative. Subadditivity and monotonicity are immediate for `lb_y`: it is a nonnegative
additive set function, so `lb_y(A ∪ B) <= lb_y(A) + lb_y(B)`, and `A ⊆ B` implies
`lb_y(A) <= lb_y(B)`. The two laws the dossier asks to be *proved per family* are therefore
discharged once for the whole construction, and what is checked per instance is only dual
feasibility.

Taking `y[d] = scale / max_degree` everywhere recovers the engine's existing rule exactly, so
the uniform vector is a null control: enabling the generalized bound with it must leave every
work count unchanged. That is the test that says the generalization is faithful rather than
merely similar.

### Where a graphics-processor, floating-point or gradient bound enters

Precisely one place, and it is outside the trust boundary: the *construction* of `y`. The
prototype's proposer solves

```text
maximize  sum_d y[d]   subject to  A y <= 1,  0 <= y <= 1
```

in floating point with HiGHS, rounds down onto the grid of denominator `scale`, clamps
nonnegative, and repairs by uniform downscaling until every column constraint holds in
integers. Any other origin is equally admissible — a subgradient walk, a learned predictor of
good multipliers, a workgroup of graphics-processor lanes screening candidate vectors — because
nothing downstream trusts the origin. The checked rational vector is the interface, and
`DualBound::checked` is the gate: it re-derives every column's support from the source model and
refuses the certificate naming the first column that fails.

This is the part A §2.2 pattern with the pieces named:

| Pattern step | Type in this design | Where it runs |
|---|---|---|
| inexact guess at a certificate | `DualBoundProposal` (untrusted, serializable) | offline proposer, any method |
| round and repair to exact rationals | integer multipliers with denominator `scale` | offline proposer |
| exact feasibility check | `DualBound::checked` → `DualBound` | engine, cold, before compilation |
| independent re-check | `recheck_dual_bound` | engine, cold, second implementation |
| exact evaluation | `sum over odd d of y[d]` against `k * scale` | search, integers only |

### The verifier, made semiring-polymorphic without moving a hot byte

Item (c) says the transition verifier is one concrete 4×4 `u32` matrix type and that only the
fold depends on the algebra. The change that follows the code rather than fighting it is a
trait with an associated encoded width and a properties mask, instantiated by a
`#[repr(C, align(64))]` type per algebra:

```rust
trait TransitionWeight: Copy + Eq {
    const ENCODED_BYTES: usize;          // the digest hashes the encoding
    const PROPERTIES: WeightProperties;  // left/right semiring, commutative,
                                         // idempotent, path, exact-carrier
    fn one() -> Self;
    fn compose(left: Self, right: Self) -> Self;   // the only algebraic step
    fn decode(bytes: &[u8]) -> Self;
    fn encode(self, out: &mut [u8]);
}
```

Everything else in `verify_delta_expected` — magic, version, artifact and root binding, sequence
staleness, length arithmetic, sibling comparison, deferred commit — stays byte-identical and
becomes generic in name only. The layout rules are preserved because each instantiation is its
own `#[repr(C, align(64))]` type with its own `const _: () = assert!(size_of… )`, so no shared
generic struct has to be laid out. Dispatch is static: the wire header already carries a
`BACKEND_ID`, so the reader selects the monomorphization once, outside any loop, exactly as the
playbook requires of a run-constant.

One property in the mask is not in OpenFst's and is forced by item (c)'s sentinel finding: the
carrier must declare whether its multiply is *exact* or *saturating*, because a saturating
`u32` multiply whose saturation value equals the absent sentinel silently turns a very expensive
path into no path. An algorithm that depends on distinguishing them refuses on the mask instead
of discovering it.

### Against the two C1091 rejection fixtures this slice has to survive

Fixture 9 — *a feasible witness with unverified exclusion of cheaper candidates is an upper
bound, not a certified optimum* — is the reason the bound's one-sidedness is a construction
rather than a test. Every refusal the prototype makes is justified by an inequality over a
multiplier vector whose feasibility was discharged against the source model before search began,
so an exclusion produced with the bound enabled rests on the same footing as one produced
without it. The engineering consequence is the `search_indexed_dual` entry point refusing to run
when no checked vector is installed, instead of quietly falling back to the constant rule: a
silent fallback would make the two runs indistinguishable in the evidence record.

Fixture 3 — *overlapping repairs at independent survival one half give exact availability 3/8,
not 1/2* — is the arithmetic warning that applies directly to the bound's soundness argument.
The odd-detector residual is covered by columns whose supports overlap, and the step
`sum over d in O of y[d] <= sum over chosen c of sum over d in support(c) of y[d]` is a union
bound, valid in exactly one direction because the multipliers are nonnegative. Reading it as an
equality — treating the covering columns as disjoint — would give a larger apparent bound and an
unsound refusal. The implementation keeps the inequality's direction explicit in both the module
documentation and the check, and the null control is what would catch a sign error in practice.

### The omission certificate

Merged row 8 (VeriPB-style `red` with a witness substitution) is designed but not prototyped
here, and the reason is item (e): the catalog contract it would certify is not exercised by the
C1143 workload at all, so a prototype would have no measurement to stand on. The design point
worth recording is the discharge structure part B §5.4 identifies — a cheap syntactic
implication test first, an explicit subproof only for the goals that survive it — which is the
same shape as `DualBound::checked` refusing at the first failing column rather than collecting
a report. Its natural owner is the catalog work, not this slice.

## Step 3 — prototype and measurement

Implemented on the spike branch as `ergodis-private/src/sparse_dual_bound.rs` plus an opt-in
kernel instantiation in `ergodis-private/src/sparse_fault_search.rs` and a
`sparse-indexed-dual` kernel choice on `ergodis-tools css circuit-distance`. Commits
`40407d1` (implementation) and `a52cfbb` (proposer, harness, certificates, measurements).
Full private measurement record:
`ergodis-private/analysis/external-benchmarks/2026-09-12-dual-bound-spike.md`.

The ban store was the other candidate; the bound was cheaper because the search already
computes a lower bound at a single line, so the generalization has an exact null control and an
existing measurement baseline, while the ban store has no consumer that would show a number
inside a spike.

### How the exactness is separated

| Stage | Artifact | Trusted? |
|---|---|---|
| propose | `infer_dual_bound.py`, HiGHS linear program in floating point | no |
| round, clamp, repair | integer multipliers with denominator 2,520 | no |
| admit | `DualBound::checked`, every column constraint in integers, refuses naming the first failing column and its sum | yes, and it is the gate |
| re-check | `recheck_dual_bound`, a second independent implementation; the tool refuses if the two disagree | yes |
| evaluate | `sum over odd d of y[d]` against `k * scale`, integers only | yes |

On the reduced development model the check reports 252 multipliers emitted and 2,232 column
constraints discharged, worst column sum 2,520 of 2,520, admission 0.4 ms, independent re-check
0.4 ms. Every emitted bound fact is checked; none is sampled.

The hot loop is unchanged for the production path. The dual instantiation carries the
multipliers in the top twelve bits of the detector identifiers the toggle loop already streams,
so the accumulator costs a shift and no extra memory traffic, and `Workspace` keeps its asserted
256-byte size by trading two words of padding for one `u64`. A zero-allocation regression enters
the dual loop twice per workspace and observes no allocation.

### Measurement, reduced development model, radius five

Retained executable `c1152-dual-v2-0e3a0cc`, SHA-256 `16502b07…8f227e`, rustc 1.93.1, release.
Input `~/.cache/ergodis/c1143/native-projected.json`, SHA-256 `3a680e4a…fb0fd6e8`. Eleven
interleaved rounds with alternating order, `choom -n 1000`, `taskset -c 0,1,2`, three workers.
Control and candidate are the same executable and the same input; only the monomorphized kernel
differs, which is a stronger control than two binaries.

| Quantity | `sparse-indexed` | `sparse-indexed-dual` | Change |
|---|---:|---:|---|
| verdict | excluded through radius | excluded through radius | identical |
| candidates examined | 4,761,457 | 4,509,874 | −5.28% |
| roots completed | 2,232 | 2,232 | identical |
| search wall median | 65.9 ms | 69.1 ms | ratio 1.043 |
| instructions | 2,835,572,565 | 3,100,900,699 | +9.4% |
| cycles | 756,395,195 | 787,029,598 | +4.1% |
| branches | 544,741,117 | 489,619,910 | −10.1% |
| branch misses | 4,296,976 | 5,175,046 | +20.4% |
| cache references | 7,876,348 | 6,190,439 | −21.4% |
| cache misses | 71,168 | 76,362 | +7.3% |

The paired log-ratio t over eleven pairs is 1.13, so the wall-time difference is not resolved;
the direction is a small loss. Counters are whole-process at 83% event multiplexing. The control
candidate count reproduces the retained C1143 figure of 4,761,457 exactly, and single-worker
runs give the same counts on both sides, so the reduction is not a parallelism artifact.

**Bounds emitted and checked**: 252 multipliers and 2,232 column constraints for this model,
all checked twice by independent implementations, zero refusals.

**Null control**: the uniform multiplier vector gives 4,761,457 candidates, bit-identical to the
control, so the generalized rule reduces to the engine's own rule exactly rather than
approximating it.

**Reading**: the bound removes real work — a tenth fewer branches, a fifth fewer cache
references — and pays for it in instructions and branch misses, because the accumulator is
charged on every detector toggle while the refusal fires on roughly one candidate in twenty.

### Measurement, frozen hold-out cases 2 to 4, radius three

Seven interleaved rounds each, unreduced sources, same protocol.

| Case | Verdict, both arms | Candidates, both arms | Control median | Dual median | Ratio |
|---|---|---:|---:|---:|---:|
| 2 | excluded through radius | 2,254,574 | 55.7 ms | 62.9 ms | 1.126 |
| 3 | excluded through radius | 2,660,030 | 67.7 ms | 77.1 ms | 1.131 |
| 4 | excluded through radius | 4,011,290 | 113.7 ms | 125.1 ms | 1.121 |

The identical candidate counts are structural, not a measurement failure, and the reason is
worth carrying because it applies to the engine's existing rule as well. After `w` columns the
residual's dual weight is at most `w · scale`, so the refusal `sum > (radius − w) · scale` can
only fire once more than half the radius is spent; and a refusal removes *counted* candidates
only when the refused step is a descent rather than an indexed completion, which first happens
at radius five. **Any bound of this family is inert on a shallow probe.** The frozen hold-out
policy's radius three is therefore the wrong depth to evaluate a bound at all.

### Cases 5, 6 and 7

Not measured with the bound, and the blocker is the proposer, not the engine. The linear program
takes 8.5 s on case 2 (34,965 distinct supports, 900 detectors), 19.3 s on case 3 (41,958 /
1,080) and 215 s on case 4 (67,752 / 1,728); case 5 (about 200,000 / 5,184) was abandoned after
thirteen minutes. Growth is strongly super-linear in this formulation.

Their baselines were measured, and they reframe the C1143 frontier. At radius three with an
unbounded candidate budget the unreduced hold-out sources exhaust at 11,044,230 candidates in
0.92 s (case 5), 17,418,377 in 1.57 s (case 6) and 50,027,057 in 2.34 s (case 7), three workers.
The frozen probe's declines on those three cases are the retraction proposer's 200,000-fault
limit together with the one-million-candidate per worker budget — not an intractable search.

### Why the multiplier vector cannot currently be stronger

Two negatives worth keeping so they are not retried blindly.

- **Coordinate ascent from the uniform vector is nearly useless on this family.** Raising each
  detector's multiplier by its tightest column's remaining slack, in round-robin, terminates
  after one pass having raised 45 of 900 detectors on case 2 and 144 of 5,184 on case 5, and
  reduces the held-out weight-two pass rate by 0.13% and 0.05%. The gain that the linear program
  finds comes from *lowering* some multipliers far below uniform and raising others well above,
  which an ascent from uniform can never reach.
- **Fitting the linear-program objective to observed residuals overfits.** With the objective
  weighted by observed detector frequencies the held-out reduction in weight-two passes is 8.6%,
  against 11.6% for the unweighted objective that uses no search data at all. The unfitted
  objective is both simpler and better.

The measured headroom is large and the linear-program family is not reaching it: on case 2, 57%
of weight-two candidates pass the engine's rule and only 6.6% of those admit an exact
completion. A perfect refusal would therefore remove 93% of the surviving candidates, against
the 11.6% the multipliers remove — about eight times as much.

### Validation

`cargo test -p ergodis-private --release --test sparse_dual_bound --test sparse_fault_search
--test fault_exclusion` passes. New gates: verdict and witness parity against the indexed kernel
over 240 generated sources at radii one to six with candidate counts never above the control;
the uniform vector reproducing control counts exactly over 120 sources; zero allocations on
repeated entry; sharded and whole-run agreement; refusal of infeasible vectors, out-of-range
scales and an uninstalled vector. `rustfmt --check` clean on the changed files; `cargo clippy
--release` clean on the library, the two sparse test targets and the tools binary. Pre-existing
dead-code clippy failures in `williamson_parallel_profile` and `additive_pair_join` are untouched
foreign work and were reported, not fixed.

## Step 4 — what is not claimed, and the next allocation

### Not claimed

- No performance win. The bound is a measured work reduction and a measured, unresolved
  wall-time loss on the one workload where it acts.
- No change to any evidence claim, certificate authority, default path or published result. The
  kernel is opt-in, separately monomorphized, and refuses to run without a checked vector.
- No C1143 conclusion is revised. The exclusion certification, the retraction theorem and the
  frozen hold-out record stand exactly as they are; the radius-three baselines measured here are
  new runs with a different budget, not a reinterpretation of the frozen probe.
- The ban store and the semiring-polymorphic verifier are designed against the code and not
  implemented. The omission certificate is not designed beyond its discharge structure.
- The linear-programming proposer is not claimed to scale. It was abandoned on case 5.
- The `frame` scan finding is a measurement of throughput against detector count, not a profile
  attributing cycles; it names a hypothesis for C1143 to test, not a result.

### Mystery ledger

| Item | Settled by this spike? | Gap, gate or owner |
|---|---|---|
| Does `ordered_resource` carry a bound law | Yes — it carries the monoid and its laws, and no plan-to-resource map exists for a law to attach to | The law was instead attached where a search already computes a bound |
| What a failed admission records | Yes — a refutation carries a distinguishing witness, a decline carries only an error variant | The decline path is the one that needs a reason field; owner is the ban-store slice |
| Is the min-plus verifier trait-based | Yes — one concrete 4×4 `u32` type, only the fold is algebraic | Genericization needs an associated encoded width because the digest hashes the encoding |
| C1093 count readout | Yes — neither min-cost nor all-solutions, a closed-form saturating capacity count | Removes C1093 as a second instantiation for a polymorphic verifier |
| Saturating multiply against the absent sentinel | New, and open | `saturating_add` can manufacture `u32::MAX`, which the verifier reads as no path; a properties mask cannot express it, so it needs a declared carrier-exactness flag. Owner: C1155, which already owns the sentinel |
| Why the bound is inert at radius three | Yes — a residual after `w` columns has dual weight at most `w · scale`, so any bound of this family only acts once more than half the radius is spent | Shallow probes cannot evaluate a bound; gate depth accordingly |
| Whether a stronger multiplier vector exists | Open | About eight times more headroom is measured than the linear program captures; ascent from uniform and frequency-fitted objectives are both closed negatives |
| Whether the accumulator can leave the toggle path | Open | It is the whole cost: +9.4% instructions for a 5.28% work saving |
| `frame`'s full-bitmap scan | Open, adjacent | Throughput falls from about 60 to about 12 million candidates per second as detector count grows; C1143 provider work, not this slice |

### Recommended next allocation

**Do not carry the dual multipliers forward as they stand.** They are correct, checked and a net
wall-time loss. Two cheaper things are now in front of them, both revealed by this spike.

1. **The decline reason, not the bound.** The C1143 frontier is entirely declines, and
   `AdmissionError::Budget` records nothing — not which limit, not the value, not the demand.
   Adding a structured decline with that data is small, changes no hot path, needs no
   measurement gate, and is the half of the ban store with an actual consumer. The refutation
   witness already exists and only needs a key and a home.
2. **The one-sided screen before the completion lookup.** The measured shape favours it where
   the bound does not: 57% of weight-two candidates pass the engine's rule, only 6.6% of those
   admit a completion, and each survivor pays a binary search over the whole completion index —
   about twenty scattered probes on the largest hold-out source. A one-probe filter on the
   residual fingerprint is the same object as the dual-bound prune by the C1151 screen rule, and
   the cost inequality `c_s < c_x · (1 − p) · (1 − α_s)` predicts it pays by a wide margin with
   `p ≈ 0.066`. Its gate is the identical-admitted-set check, which catches a screen that is not
   one-sided immediately.

Both are certificate-slice work and neither needs a linear program. The polymorphic verifier
should follow them, because its design is settled and its cost is a refactor rather than a
measurement risk; the omission certificate should wait for a catalog workload that can measure
it.
