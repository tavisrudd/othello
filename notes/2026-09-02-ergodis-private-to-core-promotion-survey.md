# Ergodis private-to-core promotion survey, 2026-09-02

**Lane:** `complete-ports`. Read-only survey. Nothing was built, run, or modified.

Scope: `ergodis-private/src` tier-1 modules against the public core
`papers/complete-repair-ports/ergodis/src`, the C1016 public-core enhancement ledger
(`notes/2026-08-30-c1016-ergodis-hadamard-quotient-synthesis.md`, section "Public-core
enhancement ledger"), `notes/2026-09-02-ergodis-core-perf-quick-wins.md`, the C1036 sector
map (`notes/2026-09-02-c1036-hadamard-bin-triage.md`), and
`ergodis-private/performance/kernel-registry-v1.json`.

## Two structural findings that frame everything below

1. **The reusable private modules are already core-independent.** Of the twenty-six tier-1
   modules that are not `g41`/`g53`/`g91`/`g133`/`q18`/`q29` sector logic, only
   `repr_grammar` and `prs` reference `ergodis::` at all, and both only in passing. They are
   not adapters over core; they are self-contained domain-neutral kernels sitting outside it.
   Promotion is therefore mostly a file move plus a gate, not a redesign. The corollary is
   less comfortable: `feature_synthesis` (1,321 lines) was written without using core
   `feature_dag` (2,361 lines), so those two are now parallel implementations of the same
   idea and one of them is dead weight.
2. **The kernel registry covers only core.** All seventeen registered kernels have a
   `papers/complete-repair-ports/ergodis/src/...` source; no private kernel is registered, so
   there is no counter or RSS evidence anywhere showing a private kernel beating a core
   equivalent. Every "measured advantage" column below is therefore a *capability* claim, not
   a measured one, and every acceptance gate has to produce the A/B from scratch. The one
   piece of transferable discipline is that 64 private modules already carry
   `allocation_test` zero-allocation tests, which is the core contract's hardest gate and
   materially lowers promotion risk.

Registry open dimensions, for context on what a promoted kernel must clear: `parallel_counters`
and `contention` are open on fifteen of seventeen core kernels, `layout` on four
(`applications`, `hall`, `integer_moments`, `root_execution`). Only `css-connected-support` is
fully green. A promoted kernel should not be admitted at a lower bar than `css_distance`.

## 1. Promotion candidates

Sizes are the private module's line count. "Ledger" = whether the C1016 public-core
enhancement ledger already names the capability.

| Module | Class | What it is | Core equivalent | Advantage / gap closed | Generalization needed | Size | Risk | Ledger |
|---|---|---|---|---|---|---|---|---|
| `hall_core` | KERNEL | Allocation-free repeated Hall tests over caller-supplied CSR graphs, reusable `HallWorkspace`, deficit extraction | `hall.rs` (705 lines), dense row bitmaps | Sparse CSR backend where core is dense-only; core `hall-matching` has `layout` open in the registry, so the sparse path is the natural remediation vehicle rather than a competitor | None. The API already takes caller-supplied CSR and names nothing domain-specific | 375 | Low | No |
| `binary_margin_lift` | KERNEL | Gale–Ryser liftability of a binary matrix from two transverse compressed margins, bounded and allocation-free | None — core has no Gale–Ryser | Pure capability gap; a named classical criterion with no core presence | None; already stated as "useful whenever two exact quotient projections are the row and column margins" | 377 | Low | No |
| `two_adic_autocorrelation` | DATA STRUCTURE | Allocation-free 2-adic lifting `c = a + 2^k x` for cyclic autocorrelation | None — no autocorrelation anywhere in core | Capability gap; carries a zero-allocation test already | Drop any assumption that the modulus comes from a Hadamard order; parameterize length | 369 | Low | No |
| `z2k_subgroup` | KERNEL | Bounded allocation-free subgroup membership over `Z/2^k` via minimum-valuation pivoting | None; nearest is `modular_power.rs` | Capability gap; exact and allocation-free, has a zero-allocation test | None visible | 288 | Low | No |
| `bitset_sumset` | DATA STRUCTURE | Fixed-width allocation-free sumsets on 256-element bitsets | `bitset.rs` is a 62-line container only; `bounded_subset_sum.rs` is a different problem | Capability gap. Note the quick-wins note's C1048 item: once `bounded_subset_sum::counts` becomes a bitset, these two want to merge rather than coexist | Widen past the hardcoded 256 elements to a const-generic width | 78 | Low | No |
| `repr_grammar` | DATA STRUCTURE | Typed grammar of lossless encoders with allocation-free decode and random-access probe over caller-owned buffers | None | Directly implements the "grammar" column of the quick-wins representation table (R1–R6) and its proposed rediscovery control R4. Promoting it is what makes that whole search programme runnable inside core | None functionally; needs an exact crossover policy and replay test per encoder, which core `PERFORMANCE.md` already demands | 2,245 | Medium (size) | No |
| `feature_synthesis` | EVOLVE | Domain-neutral bounded feature synthesis over paired integer observations; successful expressions become reusable terminals | `feature_dag.rs` — hash-consed typed feature terms, workspace evaluation | **Duplication, not a gap.** Two independent implementations of typed feature terms. Merge, do not move | Rebase synthesis onto core `feature_dag` nodes, then promote only the synthesis loop | 1,321 | High | Yes — "persistent typed feature DAG and contextual scopes" |
| `semantic_sets` | KERNEL | Allocation-free `MaxOverlapProfiler` over compiled incidence bitmasks | None | Capability gap; a hot-loop streaming kernel of exactly the shape the core contract wants | None; already takes compiled masks from a domain adapter | 644 | Low | No |
| `projected_orbit_min_cost` | KERNEL | Exact minimum-cost synthesis for projected orbit choices with quota families | Partly `ordered_resource.rs` / `scheduler.rs` | Adds constant-amplitude projection lanes and quota families that the scheduler does not model | Confirm it is not a special case of the weighted repair scheduler before promoting | 681 | Medium | No |
| `proof_synthesis` | PROOF LAYER | Typed extractor descriptors, exact linear closure, bounded Horn synthesis | None | The engine the ledger's "typed set-theorem templates" item is about. Its own doc says C1016 stays private "while this API is exercised on several adapters" — that condition is now met across fourteen reductions | Sealed extractor identity, canonical set semantics, independent reconstruction, fail-closed resource bounds (ledger's own four conditions) | 1,007 | High | Yes |
| `semantic_theorems` | PROOF LAYER | `ClaimStatus` proof-safety contract for composing discovered fragments | `provenance.rs` (flat provenance sidecars) | Small, and it is the type-level half of what makes `proof_synthesis` promotable. Cheapest way to start the proof-layer promotion | None; 86 lines of contract types | 86 | Low | Yes (implied) |
| `predicate_cover` | EVOLVE | Greedy cover synthesis ranking already-typed predicates against observations; explicitly creates no authority | None | Capability gap; the no-authority boundary is already stated in the module | None | 158 | Low | No |
| `mask_cycle_proof` | PROOF LAYER | Compact structural proofs for complements of sufficient feature masks | None | Capability gap; pairs with `semantic_sets` | Confirm masks are not order-2092-specific | 158 | Low | No |
| `sparse_defect_synthesis` | EVOLVE | Domain-neutral synthesis of sparse energy defects from a finite alphabet | None | Bridge from an evolved alphabet to a structural theorem candidate | Alphabet supplied by the caller rather than derived from a defect profile | 644 | Medium | Partly |
| `cyclic_residual_features` | EVOLVE | Generic mining of cyclic residual quotients and scoped sparse motifs from anonymous residual vectors | `contextual.rs`, `continuation.rs` | Adds unit-action search and orbit-quotient selection on top of the existing quotient towers | Already anonymous; needs only a core-side input type | 462 | Medium | Partly |
| `symmetric_feature_evolve` | EVOLVE | Allocation-free elementary permutation invariants, no domain labels, no target predicate | `multiset.rs` (permutation-invariant summaries) | Small overlap with `multiset`; the blind expander itself is new | Merge with `multiset` rather than duplicating it | 74 | Low | No |
| `raw_feature_evolve`, `planted_gap_corpus`, `banked_rule_evolve`, `banked_semantic_evolve` | EVOLVE (harness) | Blind/pre-residual expanders and the deterministic planted-tie admission corpus | None | The planted-tie corpus is the admission test any promoted evolve layer needs; promote it *with* whatever it gates, not before | Strip the C1016 fourteen-reduction registration; keep the generator | 383 + 310 + … | Medium | No |
| `arith`, `gf2_linalg`, `prs`, `css_codes` | GLUE / small kernels | De-duplicated integer, bit-packed GF(2), Reed–Solomon-curve, and CSS-construction helpers, each lifted from byte-identical binary copies | `field.rs`, `matrix.rs`, `linear_code.rs`, `css_distance.rs` | Overlap is real; these belong folded into the named core modules, not moved as new ones | Fold function-by-function, checking each against the existing core function | 307/110/243/109 | Low | No |
| `semantic_rank`, `semantic_plan/*` | KERNEL / GLUE | Exact semantic block cores over `GF(9)`; typed match/reduce/canonicalize recipe contracts | `matrix.rs` for the rank half | `semantic_rank` fixes `GF(9)`, which is the one hard domain tie in this group | Generalize the field via core `field.rs` traits; `semantic_plan` carries `q9`/`q11` packets that must stay private | 640 + subdir | Medium | No |

## 2. Ledger items the core still lacks, with a generalized spec

The C1016 ledger has five items. None is implemented in core today.

1. **Relational evolution grammar.** Bounded typed arithmetic-expression growth over supplied
   coordinates, so evolution can *derive* field-to-field comparisons and combinators rather
   than being seeded with them. Spec: a typed expression grammar with per-node degree and
   evaluation-cost bounds, growing over core `feature_dag` nodes, admitted only on exact
   round-trip evaluation against the supplied observations. The private
   pairwise-difference, bounded subset-sum, zero-conjunction, and constant-on-positive
   proposers close the first relational layer and are the natural seed set.
2. **Counterexample-guided campaign refinement.** Spec: a provenance-bound
   presentation/version transition in core `control/` that appends the smallest obstruction
   as a *new* campaign version, never mutating a frozen presentation in place.
3. **Typed set-theorem templates.** Spec: a sealed registry of interval/residue/hole
   identities with sealed extractor identity, canonical set semantics, independent
   reconstruction of every issued claim, and fail-closed resource bounds — built on core
   `structured_integer_set.rs`, which already has the interval/residue/hole representation and
   allocation-free fixed-target sum counting. This is the closest ledger item to done.
4. **Persistent typed feature DAG with contextual scopes.** Spec: hashed, costed terminals
   with a learned scope predicate and explicit `evolved` / `human-fed` / `theorem-derived`
   provenance, plus canonical typed expression semantics, presentation-version transitions,
   held-out and direct-oracle replay, and sealed promotion rules. Core `feature_dag` supplies
   the hash-consing and cost bounds; the scope masks, serialized reuse, and provenance tags
   are the private layer's contribution.
5. **Existential feature projection with downstream-aware scope learning.** Spec: project a
   complete reachable domain through every earlier feature to synthesize its exact attainable
   support, and retain a **Pareto frontier** over support size, evaluation cost, scope size,
   and known-downstream compatibility rather than maximizing local pruning. The q87
   `f110`/`f248` tie is the recorded reason the greedy version is wrong.

## 3. Modules that should stay private

- **All `g41*`, `g53*`, `g91*`, `g133*`, `q16`–`q29`, `q18*` modules** (roughly seventy files):
  TASK-SPECIFIC sector logic — exact tablebases, profile shards, energy boxes, fibre endgames,
  mod-`k` reductions. These are the residue the private crate should shrink *to*, and the
  C1036 sector map already routes them to `tasks/hadamard-2092` subcommands.
- **`hadamard_2092`** — GLUE, an order-2092 adapter over reusable kernels. It is the seam;
  keep it and promote what is underneath it.
- **`alignment_control`, `landed_rank_adapter`, `projective_grid`** — domain adapters that
  bind core APIs to a specific calculation. `AGENTS.md` names adapters as permanently private.
- **`semantic_plan/q9_rank_packet`, `q11_hall_packet`, `affine_census`** — campaign packets
  with task identity baked in.
- **`banked_rule_evolve`, `banked_semantic_evolve` corpora** — discovery-only ablation corpora
  over registered private mechanisms. The generator shape is promotable; the registrations are not.
- **`subgroup_energy_proof`, `quotient_paf_proof`, `reduction_proof`, `tactical_completion`,
  `order6_*`, `cyclic_quotient_defects`** — private structural proofs and spikes. `AGENTS.md`
  keeps these private until the authority boundaries in ledger item 3 exist; `reduction_proof`
  says outright it has "no public-Ergodis authority."

## 4. Ranked top five to promote first

Ordered by capability gained per unit of risk. The first four are all "move plus gate."

1. **`hall_core` — sparse CSR Hall backend.** Highest value because it is the only candidate
   that also remediates an open registry dimension (`hall-matching` has `layout` open), and
   core `hall.rs` is dense-only, so this is a backend, not a replacement.
   *Gate:* exact `Saturated`/`Deficient` and deficit-set parity against the private version and
   against dense core `hall.rs` on a shared fixture corpus; zero-allocation test around the
   repeated-test loop; interleaved A/B with hardware counters, single-thread and parallel,
   sparse against dense, with a stated density crossover; a new registry entry that is not
   admitted below the `css-connected-support` bar.
2. **`binary_margin_lift` — Gale–Ryser.** Named classical criterion, entirely absent from
   core, self-contained, and immediately useful wherever two exact quotient projections give
   row and column margins.
   *Gate:* exhaustive parity against a brute-force lift on all small margin pairs plus
   differential agreement with the Python oracle; zero-allocation test; single-thread counters.
   Contention does not apply, so do not open that dimension.
3. **`two_adic_autocorrelation` + `z2k_subgroup` + `bitset_sumset` as one arithmetic
   promotion.** Three small allocation-free kernels, all with zero-allocation tests already,
   none with any core equivalent. Doing them together buys one review and one registry pass.
   *Gate:* exact parity per kernel against the private version and the Python oracle;
   re-run the existing zero-allocation tests unchanged in core; const-generic width for
   `bitset_sumset` with parity at 256 against the current fixed width; A/B counters on the
   autocorrelation lift, which is the only one of the three inside a hot loop. Coordinate the
   `bitset_sumset` move with C1048 so the sumset bitset and the `bounded_subset_sum`
   reachability bitmap land merged rather than as two structures.
4. **`semantic_theorems` + `predicate_cover` + `mask_cycle_proof` — the small proof layer.**
   Roughly 400 lines total, each explicitly authority-free, and together they are the
   type-level scaffolding that later makes `proof_synthesis` promotable under ledger item 3.
   *Gate:* provenance tests binding every emitted claim to a `ClaimStatus` and a core
   `provenance.rs` sidecar; independent reconstruction of each mask-complement proof;
   a negative test that a discovered predicate cannot reach `Proved` without an independent
   check. No counter A/B needed — these are cold.
5. **`repr_grammar` — the typed encoder grammar.** Largest and the only one whose value is
   strategic rather than local: it is the missing executable half of the quick-wins
   representation table, and promoting it turns R1–R6 into a searchable space instead of a
   list of hand-written suggestions.
   *Gate:* round-trip identity for every encoder in the grammar and every composition tested;
   an exact crossover policy per encoder as core `PERFORMANCE.md` requires; zero-allocation
   decode and random-access probe over caller-owned presized buffers; and the R4 rediscovery
   control — seed from the pre-bitmap `Vec<u64>` form of `bounded_subset_sum::reachability`
   and require the search to recover `window-clip . bitpack`. If it cannot, the grammar or the
   scorer is wrong, and that is a result worth having before anything depends on it.

Deferred deliberately: `feature_synthesis` and `proof_synthesis`. Both are large, both are
already ledgered, and `feature_synthesis` is a duplicate of core `feature_dag` rather than a
gap — promoting it before the merge would install the duplication permanently in core.
