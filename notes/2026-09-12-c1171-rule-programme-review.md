# C1171 — review pass over the 2026-09-12 Ergodis work

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: COMPLETE. Cheap remediations applied and committed; the rest is
allocated to C1172–C1177 or routed to the active C1170 owner.

## Follow-up disposition — 2026-09-13

The three C1170 lexer defects below are repaired in private `a644dad`, with
richer exponent diagnostics in `6290979`. Regression tests and finite native/
WASM parity pass; entity-reference syntax remains an explicit coverage gap.
Current scope and receipts: `2026-09-12-c1170-owned-rel-frontend.md`.
Re-verified 2026-09-13 at private `9cdc124` / core `2e1bab2`: `a^b` parses as
exponentiation, radix literals (`0x1f`, `0b101`, `0o77`) are rejected with an
explicit `UnsupportedSyntax` like digit separators, and malformed exponents
(`1e`, `1e+`) report a span of caret width ≥ 2; `tests/rel_frontend.rs` covers
each (13 passed). `scripts/public-lint.sh evidence` is clean. No BUG-severity
item remains open; the R17 NITs (parser `unreachable!` on a private
continuation tag, one-byte secondary spans) and the RISK rows stay with their
allocated owners.
The historical reviewer reports below retain their original findings.

## Scope

Everything committed on 2026-09-12 in the Ergodis core (`~/src/ergodis`,
`4fb1a01`…`a3a4942`), `~/src/ergodis-private` (`8c6cff9`…`57a4eb9`, plus the
C1170 frontend committed mid-review as `cfae073`), and the monorepo Lean tree
`lean/WeightedRules/` (C1163–C1168). Three cold Opus reviewers read the code,
not the reports, and re-ran the scoped gates. Their full reports are reproduced
verbatim below the summary; my own additions are marked.

Validation run during the review:

| Gate | Result |
|---|---|
| `cargo test -p ergodis-rules -p ergodis-verify` | 28 passed (incl. 6 new properties, 512 cases each) |
| `cargo test -p ergodis-runtime` | 58 passed, 1 ignored |
| `cargo test -p ergodis-private --test sparse_fault_search --release` | 7 passed |
| `cargo test -p ergodis-private --test privacy_lowering --release` | 2 passed |
| `cargo test -p ergodis-private --test rel_frontend` at `cfae073` | 11 passed |
| `scripts/public-lint.sh evidence` before / after remediation | 3 findings / clean |
| `python3 python/generate_evidence.py --check` after remediation | clean |
| Lean | read-only; no build was run |

## Verdict

1. **No correctness defect in any committed mathematics.** Semi-naive cross term,
   the `previous ⊕ delta = values` invariant, incremental convergence to the
   *new* least fixpoint, the improvement/retraction split computed by two
   different predicates, sparse-frame tie-breaking, parallel-tile
   bit-identity, and the exhaustive fifteen-state privacy quotient all check
   out. The Lean tree has no `sorry`, `axiom`, `native_decide`, `unsafe`,
   `partial` or `opaque`, and every headline theorem states what its report
   claims.
2. **One hygiene BUG, fixed:** the C1161 frontier evidence carried three
   `/home/tavis/...` paths added after the scrubbing pass; the evidence
   repository was unpublishable. Fixed in core `2e1bab2` with placeholders and
   a regenerated manifest.
3. **Three lexer BUGs in the in-flight C1170 frontend** (`cfae073`): `a^b`
   lexes as two names so exponentiation is unreachable for identifier
   operands; `0x1f` silently splits into `Number` + `Name` while `1_000` is
   loudly rejected; `1e` yields a zero-width diagnostic span that the new
   caret renderer draws as nothing. Routed to the C1170 owner (section 5).
4. **Three RISKs that decide the next gate:** the Lean axiom audit is a
   display, not a build gate; the Lean oracle re-solves the problem inside the
   kernel, so checking cost equals solving cost and nothing in the mystery
   ledgers says so; Lean and Rust round counting agree by two independent
   conventions that nothing states or tests.
5. **Property-based tests:** six landed in core `47a8c05` and pass at 2,000
   cases; 33 more are specified across the three reports, with the six
   highest-value ones allocated in section 4.

## 1. Applied remediations (committed)

Core `~/src/ergodis`:

- `47a8c05` — `crates/rules/tests/properties.rs`: generated admitted programs
  (domain ≤ 4, ≤ 3 relations of arity ≤ 2, ≤ 6 facts, ≤ 4 range-restricted
  rules with ≤ 2 body atoms). Properties: sparse evaluation equals an
  independent naive Kleene oracle and the certificate verifies, with zero
  allocations; reported rounds equal changing rounds + 1 and never exceed the
  scalar count or `M + 1` (M = distinct rule outputs), which is the executed
  counterpart of the C1165/C1168 theorems; every single-coordinate
  perturbation of a certificate is rejected in both directions; incremental
  update after replacing, improving, worsening or removing one fact equals
  fresh evaluation, verifies against the updated source, and rebinds the
  workspace; relabelling the domain by a permutation permutes the solution
  (cross-checks `fact_slot` against the grounding layout); the adapter rule
  grammar round-trips.
- `2e1bab2` — scrubbed the three private paths in
  `evidence/2026-09-12-rule-frontier{-ab.json,.md}` to `$ERGODIS_BIN` /
  `$ERGODIS_CACHE` placeholders (the binaries' SHA-256 hashes remain);
  regenerated `SHA256SUMS`; widened the task-id lint to catch
  `c997_source`-style identifiers (one of the two forms its own comment cites)
  and to ignore hex hashes; renamed three `c80_*` test functions in
  `src/hall.rs` that the widened rule correctly flags; corrected
  `docs/summary-transitions.md` to state the checker's actual round accounting
  (the final empty-delta check is free; the producer counts it).

Monorepo: this report, queue rows C1171–C1177, handoff line.

Not applied, by design: nothing in `ergodis-private` (another session owns the
dirty tree and C1170), nothing in `lean/` (needs the guarded build window).

## 2. Remediation still owed

| # | Sev | Where | Item | Owner |
|---|---|---|---|---|
| R1 | RISK | `lean/WeightedRules/*AxiomAudit.lean` | `#print axioms` is display-only; nothing fails the build on `sorryAx`/`ofReduceBool`. Wrap all 79 terminals in `#guard_msgs`. | C1172 |
| R2 | RISK | `lakefile.toml`, `lean/WeightedRules/` | No root module and not in `defaultTargets`; no single target builds all six audits. | C1172 |
| R3 | RISK | `ChainDistance.lean:43` | `chainDistanceBaseline` is a live external witness printed by no audit. `chainDistanceImprovedProgram` is dead. | C1172 |
| R4 | RISK | Lean ↔ Rust | Round convention (Lean round 1 = fact loading; Rust counts detection sweeps) agrees by coincidence; state it in `docs/rule-contract.md` and pin with the P1 property. | C1172 |
| R5 | RISK | `Oracle.lean:46-58` | Producer subprocess has no timeout, sandbox or path pinning; output size is checked after full capture. | C1173 (resource policy with the new certificate) |
| R6 | RISK | `python/generate_evidence.py:94-186` | `SHA256SUMS` has zero rows under `crates/`, misses `src/allocation_surface*`, `src/finite_lowering.rs`, new `tests/`, `python/benchmark_rule_replay.py`. Walk the trees. | C1175 |
| R7 | RISK | `.publicignore`, `scripts/export-public.sh` | Exported manifest advertises 122 `evidence/` rows the export removes, and `cargo test` skips the check there. | C1175 |
| R8 | RISK | `hooks/pre-push:73` | Any unnamed local remote may receive `main`. Binary files are never content-scanned. Tag check is a substring match. Export script hard-codes a stale tmpfs scratch path. | C1175 |
| R9 | RISK | `tests/evidence_manifest.rs` | Evidence lint is push-time only; run `public-lint.sh evidence` inside `cargo test`. | C1175 |
| R10 | RISK | `lib.rs:242`, `recursive.rs:92,164` | `certificate.rounds` is written three ways and read only as a budget; C1165/C1168 sharpness has no wire representation. | C1176 |
| R11 | RISK | `rule_contract.rs:281-308` | Checked symmetries are admitted and never used; add `values[i] == values[pi[i]]` to `verify`. | C1176 |
| R12 | RISK | `weight.rs:11-36` | `Stability`/`WeightProperties` are inert; both loops assume `Uniform(0)`; the checker's rule-skip relies on an undocumented annihilation law. | C1176 |
| R13 | RISK | `recursive.rs:145-190` | `replace` re-grounds, re-serializes and SHA-256s the whole program per update, so the 15× kernel speedup does not survive to the API. | C1176 |
| R14 | RISK | `examples/replay_profile.rs:29-40` | "Dense" fixture becomes sparse after two rounds; no dense negative control exists. | C1176 |
| R15 | RISK | private `tests/sparse_fault_search.rs:463` | A/B never asserts the two plans took different dispatch branches. Threshold compares sequential words to random probes. | C1177 |
| R16 | RISK | private `src/allocation_domain.rs:146,178` | `parallel_workers()` sampled at read time into retained telemetry; `unreachable!` on a C-ABI path; `ParallelTable::Count` unconstructible; no Domain-level serial/parallel test. | C1177 |
| R17 | BUG | private `src/rel_frontend/lexer.rs:210,222,251` | The three lexer bugs above; plus soft keywords lexed as distinct kinds (structural risk), one-byte secondary spans, `unreachable!` in the parser. | C1170 owner |

## 3. Extension (`ej`)

- **E1 — support-witness certificate (highest leverage).** The Lean checker
  demands pointwise equality with its own Kleene iterate, so the kernel
  re-solves the problem and the external values are redundant. A per-coordinate
  derivation rank (the round at which each coordinate last changed, which Rust
  already holds) makes acceptance one pass over the rules plus a
  well-foundedness check, O(|rules|) instead of O(n·|rules|). This is the
  property that decides whether the oracle can front a real IR workload.
  → C1173.
- **E2 — the convergence theorem is not min-plus-specific.** `Convergence.lean`
  uses only finiteness, a linear order, `add = min`, and an inflationary
  product. Abstracting it over a small ordered-inflationary-algebra structure
  lifts C1165/C1168 verbatim to bounded max-min, max-times and any ordered
  idempotent semiring. Do this before a second carrier lands, not after.
  → C1174.
- **E3 — the Boolean carrier is one parameter away from the transitive-closure
  benchmark rows.** `composition_graph` is generic; only `rule_contract`
  hard-codes `bounded-min-plus-u32`. → C1174.
- **E4 — tighten the Rust round budget to `min(n, M+1)`** and document the
  `Error::Budget` branch as provably unreachable; four-vertex worst case drops
  21 → 5, six-vertex chain 43 → 7. → C1176.
- **E5 — the sparse-frame 4–5% is a measurement ceiling, not the effect size.**
  The portable provider's 4,096-detector cap limits the control to 63 syndrome
  words against 15,625 in the native domain; frame selection is also a small
  Amdahl slice. Bench the native kernel at 10⁵–10⁶ detectors or raise the
  cap; until then the 60M → 12M external claim is unaddressable. → C1177.
- **E6 — count-axis parallelism already exists in core**; only a
  `Table::Budget` gate in the private domain blocks it. → C1177.
- **E7 — chained improvements.** `CheckedImprovement → CheckedSolution` makes
  warm proofs interchangeable with cold ones; `iteratedImprovement` already
  gives existence for every admitted improvement, so only a harness is
  missing. Folded into C1173.

## 4. Property-based tests

Landed (core `47a8c05`): six, listed in section 1.

Specified and allocated:

| Test | Generator / invariant / oracle | Owner |
|---|---|---|
| P1 round-convention identity | random admitted sources; `rust.rounds` = least Lean-fixed index, sharp (`checkCertificate P r` true, `r-1` false) by `decide +kernel` | C1172 |
| P2 grounding correspondence | Rust emits its grounding as JSON; Lean importer over `nat_table_from_json`; `P_imported = P_expected` | C1172 |
| P3 raw scalar programs, Rust vs Lean | random `Program Cost n`, n ≤ 24, cyclic and nonlinear rules; needs a raw grounded entry point on the Rust side | C1173 |
| P4 saturation boundary | costs near 2³¹ and 2³²−1; Rust `saturating_add` = Lean `costMul`; naive `u128` clamp oracle | C1176 |
| P5 incremental replay count | random improvement; smallest accepted `replay k` = Rust sweeps, `≤ min n (M+1)` | C1172 |
| P6 elaborator rejection fuzz | hundreds of one-mutation certificates all rejected via `#guard_msgs` | C1172 |
| generic carrier replay (Boolean and min-plus) vs naive | `composition_graph::verify` over both carriers on random graphs | C1174 |
| replacement sequences equal fresh verification | 1–8 improve/retract/no-op replacements through `VerifiedGraph::replace_input` | C1176 |
| rejected update preserves every held observation | one corrupted `FactReplacement` field; state tuple unchanged | C1176 |
| declared symmetry permutes the certified values | programs with a built-in automorphism; `values[i] == values[pi[i]]` | C1176 |
| `parse_rules` total and idempotent on adversarial bytes | `any::<String>()` ∪ near-Datalog; no panic; `parse(render(parse(s))) == parse(s)` | C1176 |
| provider ABI totality and write bound | random op/handle/buffer sequences; `written ≤ capacity`, `catch_unwind` never fires | C1176 |
| certificates do not transplant between sources | two programs of equal scalar count; cross-verify fails | C1176 |
| weight laws incl. `zero ⊗ x == zero` | random triples over each carrier | C1176 |
| lowering synthesis complete | random models, brute-force table oracle | C1176 |
| fork-depth = BFS; origin toggle round-trips | random `RunRecord` catalogues | C1176 |
| parallel = serial surfaces at every split, tile-boundary shapes | random `AllocationSource` straddling 8,192 cells | C1176 |
| sparse frame = full scan; min-degree-then-min-id spec | random fault supports; dispatch asserted | C1177 |
| Domain-level parallel = serial under 1/2/8 threads | random maxima and families | C1177 |
| privacy quotient is a congruence at all depths; `joint_span` is a subgroup | random event words; exhaustive over 256 sources | C1177 |
| lexer never panics; positions tile the source; byte-scan = scalar variant; token round trip | arbitrary bytes ∪ keyword corpus | C1170 owner |

`proptest` is a dev-dependency of the core root, `ergodis-rules` and
`ergodis-runtime`; `ergodis-private` needs it added.

## 5. Routing to the active C1170 owner

The frontend prototype respects the Ergodis boundary (syntax only, no
evaluator, no join, unsupported forms rejected rather than accepted), has a
bounded continuation stack instead of recursion, and gained an allocation-count
test and a caret renderer during the review. Open on `cfae073`: R17 above, plus
the coverage manifest still lacks `^` as a binary operator, non-decimal integer
literals and digit separators. The private review's section B has line-level
detail and the fix options.

## Mystery ledger

- **Checking cost equals solving cost in the Lean oracle.** Settled as a design
  fact by the review; open as a scaling boundary. Owner: C1173.
- **Lean/Rust round conventions coincide.** Explained (Lean's round 1 loads
  facts; Rust counts the detection sweep); unpinned. Owner: C1172 (P1).
- **The `rounds` field has three writers and one range-checking reader.**
  Explained as an unsettled meaning, not a bug. Owner: C1176.
- **Sparse-frame gain of 4–5%.** Explained as an admission-cap ceiling times an
  Amdahl slice; the external 60M → 12M figure remains unattributed. Owner:
  C1177.
- **Dense-path instruction rise of 0.4–0.6% after the sparse frame change.**
  Likely monomorphization over a fourth `const bool`; unconfirmed. Owner: C1177.
- **Fifteen states.** Exhaustive over the 256-source model and coherent (16 − 1
  fully-leaked joint states); whether a different generating set of eight
  observations changes the count is cheap to check and unchecked. Owner: C1177.
- **`n` = scalar count is quadratic in the domain for binary relations.**
  Settled: `min n (M+1)` is the number to quote, and it is provably sharp.

## Verbatim reviewer reports

The three reports follow unchanged.

---


## Report A — core Rust (Opus, cold)

##### Cold Rust review — Ergodis 2026-09-12 day's work

Repository: `/home/tavis/src/ergodis`, branch `main`.
Reviewed range: `6284ca7 … a3a4942` (rule-contract programme, C1160–C1163), `0922ff2`/`23e1afe`
(parallel allocation surfaces), and the C1149 release/evidence hygiene commits
`4fb1a01 … ab2cc81`.

Reviewer note on scope drift: at the time of review `HEAD` is `47a8c05`
("Add generated-program properties for the rules crate"), one commit past the stated range.
That commit adds `crates/rules/tests/properties.rs`, a six-property `proptest` suite, and it
materially changes the answer to review item 4. It is treated as in scope below and its
coverage is credited, not re-proposed.

Severity tags: **BUG** (wrong behaviour), **RISK** (sound today, brittle or a weaker guarantee
than claimed), **NIT** (cosmetic/doc), **EXT** (extra juice), **PROP-TEST** (proposed property).

Verification method: every finding below was read out of the source, not taken from the task
reports. Scoped gates were re-run locally with
`CARGO_TARGET_DIR=/home/tavis/.cache/ergodis/target` (the workspace `.cargo/config.toml`
already points there):

| Gate | Result |
|---|---|
| `cargo test -p ergodis-rules -p ergodis-verify` | 28 passed, 0 failed (incl. 6 proptest properties, 512 cases each) |
| `cargo test -p ergodis-runtime` | 58 passed, 0 failed, 1 ignored |

##### Headline

The mathematics is in good shape. I found no correctness defect in the rule contract, the
verifier, the sparse frontier, the recursive runtime, the finite lowering checker or the parallel
allocation surface — and the places where an unsound shortcut was most plausible (incremental
convergence to the *new* least fixpoint, the semi-naive cross term, the improvement/retraction
split being computed twice by two different predicates) are each correct for a reason I was able to
reconstruct from the code. The one outright defect is in release hygiene: the evidence tree fails
the repository's own public lint today, on files added the same day the scrubbing pass ran (§5.0).

The three findings I would act on first:

1. **§5.0 (BUG)** — `scripts/public-lint.sh evidence` reports three `/home/tavis/...` leaks in
   `evidence/2026-09-12-rule-frontier{-ab.json,.md}`. The evidence repository cannot be published
   until they are scrubbed or allowlisted, and the lint has no commit-time counterpart that would
   have caught them.
2. **§5.1 (RISK)** — `SHA256SUMS` contains zero rows under `crates/`, and also misses
   `src/allocation_surface*.rs`, `src/finite_lowering.rs` and the new `tests/`. `db64630` automated
   the `evidence/` half of the manifest on the same day ~3 000 lines of new mechanism landed
   outside the hand-maintained half.
3. **§5.3 (RISK)** — the task-ID lint's `\bC[0-9]{2,4}\b` does not match `c997_source`, which is
   one of the two example forms its own header comment cites as the reason the rule exists.

---

#### 1. Correctness

##### 1.1 Core fixpoint machinery is sound — what I checked and why it holds

I traced the four independent evaluators against each other rather than assuming agreement.

**Semi-naive contribution is complete, including the nonlinear cross term.**
`crates/verify/src/weight.rs:154-163` computes `Δl ⊗ r ⊕ (l ⊕ Δl) ⊗ Δr`. Expanding
`(l⊕Δl)⊗(r⊕Δr)` gives `l⊗r ⊕ Δl⊗r ⊕ l⊗Δr ⊕ Δl⊗Δr`; the function is exactly that minus the
already-accounted `l⊗r`, with factor order preserved, so it is correct for a noncommutative
product too. No contribution can be lost when both factors improve in the same wave.

**The semi-naive invariant `previous ⊕ delta = values` is maintained at every entry point.**
In `crates/verify/src/composition_graph.rs:183-222`, `previous.copy_from_slice(values)` at
line 210 runs *before* the value-commit loop at 211-214, so `previous` is the pre-round value
and `delta` the strict improvement. The invariant is established by the three callers:
`verify` (line 101-105, `previous = 0`, `delta = inputs = values`), and both branches of
`replace_input` (lines 153-165).

**The `delta[left] == zero && delta[right] == zero` skip at line 203 is correct but rests on an
unstated law.** It is valid only because `zero` annihilates `times`. Both carriers satisfy it
(`u32::MAX.saturating_add(x) == u32::MAX` for nonnegative `x`; `false && x == false`), but the
`TransitionWeight` doc comment at `weight.rs:31-36` states distributivity and the minus laws
and says nothing about annihilation. See RISK-4 and PROP-TEST 17.

**Incremental improvement converges to the *new* least fixpoint, not merely to *a* fixpoint.**
This is the one place where a plausible-looking shortcut would be unsound, so I worked it
through. In the information order (`a ⊑ b` iff `a ⊕ b = b`, i.e. *lower cost* in min-plus),
lowering an input gives `old_lfp ⊑ new_lfp`. Kleene monotonicity then gives
`F^k(⊥) ⊑ F^k(old_lfp) ⊑ F^k(new_lfp) = new_lfp`, and both outer limits are `new_lfp`, so
iterating from the held solution lands exactly on `new_lfp`. Both
`composition_graph::replace_input` (improvement branch, lines 153-159) and
`ergodis_rules::Prepared::update_into` (`crates/rules/src/lib.rs:230-237`) rely on this and
both gate it correctly. `update_into` folds the new inputs in once and never re-applies them,
which is fine because `current` only gains information afterwards.

**The two improvement/retraction predicates agree.** `composition_graph::replace_input` splits
on `expected_old.plus(new) == new` (`composition_graph.rs:153`); `Prepared::update_into` splits
on `any(|(old, new)| new > old)` (`lib.rs:221-229`). These are the same partition for
`BoundedMinPlus`, including the equal/no-op case, which both route to the improvement branch
and both then produce an empty delta. `RecursiveQuery::replace` drives both in the same call
(`crates/runtime/src/recursive.rs:162,172`), so a disagreement would have been a live
divergence between the producer and the checker. It is not one.

**The sparse frontier's `changed` de-duplication is safe.** `lib.rs:283` uses
`next[output] == u32::MAX` as the "not yet queued" sentinel. A real candidate can never be
`u32::MAX`, because line 282 requires `candidate < current[output] <= u32::MAX`. So the
sentinel is unambiguous and `changed` holds distinct outputs, which in turn is what keeps
`active`/`changed` within their preallocated capacity.

**The authenticated-tree semi-naive step (`min_plus_transition.rs`, `6284ca7`) is sound.**
Along a root path only one child changes, so the linear step
`new_parent = old_parent ⊕ compose(delta, sibling)` is exact — min-plus matrix product
distributes over elementwise min. The shortcut is correctly gated on `old.plus(new) == new`
(elementwise improvement); increases and mixed changes fall back to full recomposition. The
test oracle in `semi_naive_tests::reference` sums in `u64` and saturates explicitly, so it does
not share the production `saturating_add`, which makes it a genuine differential.

**No integer overflow in the bounds arithmetic.** Every multiplication I could reach is
pre-bounded: `rule_contract.rs:202` (`domain ≤ 32`, `arity ≤ 3` → `≤ 32768`, rejected against
`MAX_SCALARS = 4096`), `:252-254`, `:273`; `finite_lowering.rs:50-52,101,116,197`
(`source × events` and `summaries × events` both capped at `MAX_CELLS`); `frontier.rs`
(`≤ 2 × 65536` CSR entries in `u32`). `BoundedMinPlus::times` is `saturating_add`
(`weight.rs:82`). `AllocationSurface` values are `u16` but bounded by
`families.len() ≤ 4096` layers, and the choice byte is safe because a family is capped at
255 options (`allocation_surface.rs:106`), so `(o.source + 1) as u8` cannot truncate.

**No panic path found on untrusted input.** `parse_rules` (`rule_contract.rs:367-439`) slices
only at `char_indices` boundaries and at single-byte `,` `.` `:-` `(` `)` positions;
`identifier` short-circuits its `is_empty` check before `as_bytes()[0]`; oversized decimal
constants fail through `parse::<u32>` rather than wrapping. The symmetry loop
(`:281-308`) validates `permutation` is a bijection of `0..scalar_count` *before* indexing with
it. In `lineage.rs:114-119`, `index[parent_run]` cannot panic because `check_parent`
(`run_record.rs:468-470`) already requires `parent_run == parent.run_id` and `parent` is a
catalogue member.

**`advance_build_parallel` is equivalent to the serial kernel.**
`src/allocation_surface/parallel.rs:82-108` versus `src/allocation_surface.rs:292-326`: both
read from `previous`, iterate options in declaration order, and use strict `>` so the
lowest-index option wins a tie. The tile arithmetic lands in the same box because
`width = b + 1` and `cells = (a+1)*(b+1)` (`allocation_surface.rs:231-235`), so
`(stop-1)/width ≤ a` and `hi = min((x+1)*width, stop)` keeps `y ≤ b` without needing an
explicit `ymax` clamp. `previous[cell - delta]` cannot underflow because `lo ≥ x*width + b`
and `x ≥ a`. Tile merge is in index order, so the result is deterministic and replay-stable.

##### 1.2 BUG — none found in the correctness surface

I did not find a semantic bug, an unsound verification shortcut, a panic on untrusted input, an
integer overflow in the min-plus or weight arithmetic, an off-by-one that changes an accepted
answer, incorrect semi-naive frontier or retraction logic, or a non-determinism that would break
certificate replay. The findings in §1.3 onward are weaker guarantees than the surrounding language
implies, not wrong answers. (The one BUG in this review is a release-hygiene defect, §5.0.)

##### 1.3 RISK-1 — documented round accounting contradicts the code, and the producer and checker differ by one round

`docs/summary-transitions.md:91-92` states "A round scans the admitted rules; the final scan
establishing an empty delta counts toward the bound." The code does not do this.
`composition_graph::propagate` (`composition_graph.rs:192-221`) runs `for _ in 0..max_rounds`
with the delta-is-zero test at the *top* of each iteration, and then repeats that test once more
after the loop (lines 217-221). So `max_rounds = R` buys `R` rule-scanning rounds and the
fixedness determination is free.

Traced concretely: a single-variable, no-rule graph verifies with `max_rounds = 1`, where the
documented accounting would require 2.

The consequence is an asymmetry nothing currently tests. `Prepared::propagate`
(`crates/rules/src/lib.rs:265-303`) loops `for round in 1..=inputs.len()` and *does* spend a
loop iteration on the no-change scan, so the producer permits `N-1` value-changing rounds. The
checker, given `certificate.rounds = N`, permits `N`. That is the safe direction — the checker
is strictly more permissive, so no valid certificate is rejected — but it means the checker
would accept a certificate the in-repo producer can never emit, and the discrepancy is invisible
because no test pins the boundary. PROP-TEST 5 pins it.

For what it is worth, the producer's `1..=N` bound is exactly tight: an `N`-coordinate chain
needs `N-1` changing rounds plus one confirming round. The `47a8c05` property
`rounds_respect_scalar_and_output_bounds` already asserts `rounds == changing + 1` and
`rounds <= scalars`, which corroborates this.

##### 1.4 RISK-2 — `certificate.rounds` carries no verified information

`rule_contract::verify` checks only `certificate.rounds <= certificate.scalar_count`
(`rule_contract.rs:342-344`) and then uses the field as a replay budget. `docs/rule-contract.md:88`
is accurate about this ("A fixed round value can certify an earlier converged result"), but the
runtime makes the field vacuous rather than merely loose: `RecursiveQuery::new` and
`RecursiveQuery::replace` both overwrite the producer's measured count with the maximum
(`recursive.rs:92` and `:164`), and `Prepared::update_into` sets
`certified_rounds = inputs.len()` unconditionally (`lib.rs:242`). So every certificate the
runtime emits claims `rounds = N`.

Nothing is unsound — values are fully replayed — but a reader of a certificate learns nothing
about convergence speed from it, and the C1165/C1168 sharpness results have no representation
in the wire format. See EXT-1.

##### 1.5 RISK-3 — "checked symmetries" are admitted but never used for anything

`ground` verifies that each declared permutation preserves the input vector and the grounded
product multiset (`rule_contract.rs:281-308`). That check is correct: it establishes that the
permutation is an automorphism of the grounded equation system, and the source identity binds
the declarations. But nothing downstream consumes the result. The certificate does not assert
that the claimed values are permutation-invariant, and no quotienting is performed (the C1163
report says so explicitly). A declared symmetry is therefore a source-identity payload and an
admission cost with no verification value today. See EXT-2 and PROP-TEST 6.

##### 1.6 RISK-4 — the `Stability` / `WeightProperties` declaration is inert, and the algorithms silently assume `Uniform(0)`

`weight.rs:11-29` defines `Stability::{Unknown, Stable, Uniform(u32)}` and a five-field
`WeightProperties`. A repository-wide search finds no consumer: the only reads are three
assertions in `crates/verify/tests/composition_graph.rs:53-55`. Both `composition_graph::propagate`
and `Prepared::propagate` implement the plain Kleene/semi-naive step and cap rounds at the
scalar count, which is the `Uniform(0)` bound specifically. If a `Uniform(p)` carrier with
`p > 0` (or an `Unknown` one) were added behind the sealed trait — and the trait exists precisely
to be extended — both the round bound and the iteration would be wrong, and nothing in the code
would catch it. The trait is sealed, so this is a forward-looking hazard rather than a current
defect, but the declaration is the natural place to enforce it (EXT-3).

`exact_carrier: false` on `BoundedMinPlus` (`weight.rs:70`) is likewise declared and unread,
even though it is the field that would gate a claim about unbounded path costs.

##### 1.7 NIT-1 — `Prepared::fact_slot` duplicates the grounding layout

`crates/rules/src/lib.rs:155-173` recomputes the relation-offset layout that
`rule_contract::ground` computes at `rule_contract.rs:189-207`. They agree today
(declaration order, `domain.pow(arity)`, lexicographic last-coordinate-fastest), and the
`47a8c05` property `domain_relabelling_permutes_the_solution` cross-checks them. But it is two
copies of a layout rule whose divergence would silently mis-address facts.
`crates/runtime/src/lineage.rs:186` makes it three: it hard-codes `offset = runs.len()^2` to
find the `depth` relation instead of calling `fact_slot`.

##### 1.8 NIT-2 — `Prepared::with_fact` assumes product invariance without asserting it

`lib.rs:182-201` reuses `Arc::clone(&self.users)` for the updated plan. That is correct because
`ground` derives products from relations, rules and domain only, none of which `with_fact`
touches. `update_into` independently rechecks `self.graph.products() != updated.graph.products()`
(`lib.rs:216`), so the runtime path is guarded — but `with_fact` itself is public and a caller
who evaluates the result directly gets no such check. A `debug_assert_eq!` on the products would
cost nothing.

##### 1.9 NIT-3 — `LineageReadout::catalogue_id` does not bind the origin or the update budget

`lineage.rs:144-148` hashes only the sorted record-id set. Two readouts built from the same
catalogue with different `origin` or `max_updates` share a `catalogue_id`. This is not
exploitable through `set_origin_json`, which additionally checks `expected_source` against the
query's source identity via `FactReplacement` (`lineage.rs:226`, `recursive.rs:150`), and the
`Readout` itself carries the certificate's `source_id`. But a consumer that keys a cache or a
log on `catalogue_id` alone would conflate them.

##### 1.10 NIT-4 — `verify_readout` is largely a self-comparison

`lineage.rs:254-260` compares the supplied `Readout` against `self.readout()` and then replays
the embedded certificate. The equality test has no authority for a third party — it says only
"this is what I would have produced". The mathematical authority is the certificate replay on
line 258, and the doc comment is careful about this. Worth keeping the doc comment attached to
the function if it is ever exported more widely.

---

#### 2. Verification authority

##### 2.1 What the boundary actually is

The certificate replay is genuinely independent in *algorithm*: the producer is a sparse
frontier with a marks array (`crates/rules/src/lib.rs:257-304`), the checker is dense semi-naive
with comparison-minus deltas over a generic `TransitionWeight`
(`crates/verify/src/composition_graph.rs:183-222`). They share no code path. Forgery of values is
not possible: `composition_graph::verify` recomputes from `⊥` and compares every coordinate
(`:105-108`). Sibling substitution is blocked: `rule_contract::verify` re-grounds the caller's
program and requires `certificate.source_id == grounded.source_id` (`:336-341`), and the source
identity is a SHA-256 over the schema tag plus a canonical re-serialization of the decoded
`Program` (`:310-323`), which means it is stable under JSON whitespace and formatting but binds
declaration order, constants, duplicate facts and symmetry declarations.

Replay-from-zero also rejects self-supporting cyclic fixed points, which a naive
`F(claim) == claim` check would accept. This is the correct boundary and the code comment at
`composition_graph.rs:80-81` states it.

##### 2.2 GAP-1 — producer and checker share `ground`

`rule_contract::verify` calls `ground(program)` (`rule_contract.rs:335`), the same function
`Prepared::new` calls (`crates/rules/src/lib.rs:71`). A defect in grounding — a dropped product
rule, an off-by-one in the coordinate layout, a mis-resolved relation offset — is invisible to
both sides and would yield a certificate that verifies against a program it does not represent.

The C1163 report states this plainly ("Producer and checker share admission/grounding but use
independent evaluation algorithms") and the Lean `Relations.lean` transport theorem addresses the
*mathematical* correspondence under an explicit commutation hypothesis, not the Rust grounding.
So this is a known and documented gap, not a hidden one. What partially covers it today is the
Python oracle `crates/rules/tests/oracle.py`, which performs Floyd–Warshall on the *source*
relations rather than on the grounded coordinates, so it does exercise grounding differentially
for the distance family. Nothing generalizes that to arbitrary admitted programs.

##### 2.3 GAP-2 — the `evidence/` manifest does not cover any of the new code

See §5. This is the release-hygiene half of the same question: the certificates and reports
committed on 2026-09-12 are git-visible, but the files that produce them are outside
`SHA256SUMS`.

##### 2.4 What is *not* a gap

- `CheckedSquare` (`crates/verify/src/finite_lowering.rs:162-179`) is a real capability token:
  private fields, no public constructor, no `Deserialize`, mintable only by `verify`. A caller
  cannot fabricate one.
- `verify_obstruction` (`:201-217`) checks the right thing — two sources with equal lowering
  whose images under one event have unequal lowering, which is exactly the condition under which
  no summary transition table can exist.
- The provider ABI (`crates/rules/src/provider.rs`) forwards selector 2 to `plan.verify`, so a
  certificate is always replayed against the plan's own source; there is no path that accepts a
  certificate on the caller's word. Handle nonces, the workspace bit, never-reused slots and the
  `BUSY` check on plan release (`:117-138`) are all sound as written.

---

#### 3. Performance contract

Assessed against `/home/tavis/src/ergodis-contrib/PERFORMANCE.md`, whose two binding sections here
are "Non-negotiable solve invariant" (the solve hot loop is completely allocation-free, including
container growth, cloning owned data, error construction and serialization; every new solve kernel
needs an allocation-count regression that re-enters the real loop after setup and observes zero
allocations; "amortized" and "only once" fail the gate) and "Measurement and acceptance"
(correctness gates precede timing claims; release binaries with recorded compiler, flags, features,
revision and executable hashes; deterministic inputs; interleaved or rotated A/B rounds).

##### 3.1 The kernel meets its stated contract

`Prepared::evaluate_into` / `update_into` / `propagate` allocate nothing. Every buffer is sized
in `Prepared::workspace` (`lib.rs:80-98`) with a spare cache line
(`Vec::with_capacity(len + 16)`), and the push sites are all bounded: `work` holds de-duplicated
rule indices (`≤ products`), `active`/`changed` hold distinct coordinates (`≤ scalars`). This is
asserted, not assumed — `crates/rules/tests/allocation.rs` installs a counting global allocator
and requires exactly zero allocator calls across 100 evaluations and across 100
improvement/retraction round trips, and the `47a8c05` properties re-assert it on generated
programs. `Workspace::clone` preserves capacity (`lib.rs:44-48`), which is what keeps a cloned
candidate workspace passing `workspace_shape`.

No recursion anywhere in the new code. The cache-line separation test
(`lib.rs:325-359`) checks that eight independently cloned workspaces share no 64-byte line.

The parallel allocation surface is held to the same standard:
`tests/allocation_parallel_contract.rs:73,100` assert zero allocator calls across
`advance_build_parallel` at mixed budgets. So the contract's "allocation-count regression that
enters the real loop repeatedly after setup" requirement is met for both kernels that landed this
day. The A/B evidence also satisfies the recording requirements of "Measurement and acceptance":
`evidence/2026-09-12-rule-frontier-ab.json` carries `generator_sha256`, a `binaries` map with a
SHA-256 per executable, the CPU set, repeat and round counts and a schema tag, and
`python/benchmark_rule_replay.py` runs interleaved rounds.

##### 3.2 RISK-5 — the incremental *transaction* is not incremental

`RecursiveQuery::replace` (`recursive.rs:145-190`) wraps the allocation-free kernel in a per-update
cost that dominates it:

- `self.plan.with_fact(...)` clones the whole `Program`, re-runs `ground` — which re-expands every
  grounded product (up to 65 536), re-serializes the program to JSON and re-hashes it with SHA-256
  over up to 1 MiB (`rule_contract.rs:219-323`);
- `self.workspace.clone()` and `self.checked.clone()` copy six and four vectors respectively;
- `certificate.values` is cloned again in `current_certificate` (`lib.rs:138`).

So each of the up-to-1 000 000 permitted updates pays `O(products)` plus a SHA-256 of the source,
regardless of how few coordinates the frontier actually touches. The zero-allocation guarantee is
scoped to `update_into` and is not claimed for `replace`; the doc comments say "admission and
serialization are cold". The concern is that the measured 15.35×/14.62× frontier speedup is a
property of the kernel, and the transaction wrapper can absorb it entirely at the API a caller
actually uses. See EXT-4.

##### 3.3 RISK-6 — the "dense" benchmark fixture does not stay dense

`crates/rules/examples/replay_profile.rs:29-40` builds the dense variant by adding all `n²` edges,
giving non-chain edges cost 1000 while chain edges cost 1. With `domain ≤ 32` the true distances
are `0..domain`, so every cost-1000 edge is dominated almost immediately and the frontier collapses
to the chain after the first wave or two. The measured dense speedups (5.22×/4.26×) are therefore
"dense in edges, sparse in improvements", and the C1161 report correctly flags this as an open
scope limit. A fixture where non-chain edge costs are *competitive* — so that many coordinates
genuinely improve every round — is the missing negative control, and it is the case where a
contiguous full scan is expected to beat the frontier. Until that exists, there is no measurement
supporting the frontier as a default rather than as a policy choice.

##### 3.4 NIT-5 — `evaluate_into` re-seeds the active set by scanning all coordinates

`lib.rs:110-114` scans every input slot to build the initial frontier. That is `O(scalars)` per
evaluation and unavoidable for a cold evaluation, but it is also why the repeated-evaluation
benchmark's product-check count is not the whole story. Not a defect; noted because the
allocation test's `assert_eq!(checks, 2700)` is a product-check count, not a work count.

##### 3.5 NIT-6 — report/code drift on the product-check figure

The C1163 report states "100 evaluations perform 8000 product checks". The committed assertion is
now 2700 (`crates/rules/tests/allocation.rs:39`), because `1aea1e2` landed the sparse frontier
after that report was written. The report is simply pre-frontier; worth a one-line correction if
it is cited anywhere.

---

#### 4. Test coverage and proposed property-based tests

##### 4.1 What exists

`proptest = "1"` is already a dev-dependency of the root crate, `ergodis-rules` and
`ergodis-runtime`. `crates/rules/tests/properties.rs` (commit `47a8c05`) contributes six
properties at 512 cases each, all passing: evaluation-versus-naive-Kleene with a zero-allocation
assertion, the round bound against both the scalar count and the C1168 distinct-output bound,
single-coordinate certificate perturbation rejection, incremental-versus-fresh evaluation,
domain-relabelling equivariance, and rule-grammar round-tripping. That is a strong base and it
covers the highest-value invariant (semi-naive versus naive on generated programs) directly.

Deterministic coverage is also broad: all 256 two-variable Boolean rule subsets, 160 min-plus
DAG/cyclic graphs against a Python oracle, all 4 374 three-source/two-event/two-summary lowering
models, 129 Floyd–Warshall programs across native and actual WASM, and exhaustive nonlinear
fixed-point enumeration.

##### 4.2 Gaps in the existing generated coverage

1. `properties.rs` caps generated fact costs at `MAX_COST = 1000`, so the saturating branch of
   `BoundedMinPlus::times` is never generated.
2. `program()` always emits `symmetries: Vec::new()`, so symmetry admission has generated
   coverage of exactly zero cases.
3. Only `BoundedMinPlus` is exercised on generated inputs. `Boolean` is generic-tested only by the
   fixed two-variable enumeration, even though `composition_graph` is generic over the carrier.
4. `composition_graph::replace_input` is never driven as a *sequence*; only single replacements
   appear, and only through the `rule_contract` layer.
5. Nothing generates input for `provider::ergodis_invoke`, `decode_program`, `decode_certificate`
   or `parse_rules` on adversarial bytes — `rule_grammar_round_trips` only feeds the parser rules
   it generated itself.
6. `LineageReadout` and `finite_lowering::synthesize` have no generated coverage at all.
7. `advance_build_parallel` has three fixed-shape tests; nothing generates tile-boundary shapes.

##### 4.3 PROP-TEST catalogue

Each entry gives: name, generator, invariant as a one-line predicate, the function or ABI it
exercises, and the oracle.

**PROP-TEST 1 — `verifier_replay_matches_naive_over_every_admitted_algebra`**
Generator: for `W` in `{BoundedMinPlus, Boolean}`, a random input vector of length `2..=12` and
`0..=24` `ProductRule`s with indices drawn in range, allowing self-products and cycles.
Invariant: `composition_graph::verify(inputs, rules, naive_lfp(inputs, rules), limits).is_ok()`
and its `values()` equal `naive_lfp`.
Exercises: `composition_graph::verify`, `propagate`, `semi_naive_product`, generically.
Oracle: naive synchronous Kleene iteration to a fixpoint, written separately from the delta code.
Closes gap 3 — today nothing runs the Boolean carrier through the generic replay on a graph
larger than two variables.

**PROP-TEST 2 — `replacement_sequence_equals_fresh_verification`**
Generator: a graph as above, plus `1..=8` replacements, each a `(slot, new_value)` pair drawn to
hit improvement, retraction and no-op with roughly equal weight.
Invariant: after applying the sequence, `graph.values() == verify(final_inputs, rules, ...).values()`.
Exercises: `VerifiedGraph::replace_input` (both branches) and its sequence counter.
Oracle: a fresh from-zero `verify` on the final input vector.
This is the property that would catch a wrong improvement/retraction split, which is the single
most load-bearing branch in the checker.

**PROP-TEST 3 — `retract_then_reassert_is_the_identity`**
Generator: an admitted program, one fact slot, and a worsened value `v' > v`.
Invariant: `update(v → v'); update(v' → v)` leaves `values()` bit-identical to the original, and
the certificate verifies at both steps.
Exercises: `Prepared::update_into` restart branch and `VerifiedGraph::replace_input` retraction
branch, in lockstep through `RecursiveQuery::replace`.
Oracle: the pre-update value vector.

**PROP-TEST 4 — `rejected_update_preserves_every_held_observation`**
Generator: a valid `RecursiveQuery` plus a `FactReplacement` corrupted in exactly one field
(`schema`, `expected_sequence`, `expected_source`, `relation`, `tuple`, `expected_old`).
Invariant: `replace(..).is_err()` and the tuple
`(source_id(), sequence(), values().to_vec(), snapshot().certificate)` is unchanged.
Exercises: `RecursiveQuery::replace` transactionality (`recursive.rs:145-190`).
Oracle: a snapshot taken before the call. `failed_admission_preserves_source_certificate_and_sequence`
covers this for hand-picked cases only.

**PROP-TEST 5 — `round_bound_is_sharp_and_the_two_evaluators_agree`**
Generator: chain programs `dist(y) :- dist(x), edge(x,y).` with chain length `L in 1..=domain`.
Invariant: `evaluate_into(..).rounds == L + 1`, `composition_graph` replay succeeds with
`max_rounds = L` and fails with `Error::Budget` at `max_rounds = L - 1`.
Exercises: `Prepared::propagate` round accounting and `composition_graph::propagate`'s post-loop
free check.
Oracle: the analytic chain length.
This is the test that pins RISK-1 and would force `docs/summary-transitions.md:91-92` and the code
into agreement.

**PROP-TEST 6 — `declared_symmetry_permutes_the_certified_values`**
Generator: an admitted program together with a permutation of its scalar coordinates, retained
only when `ground` accepts it as a symmetry — most cheaply obtained by generating programs with a
built-in domain automorphism (e.g. a cyclic edge relation) rather than by rejection sampling.
Invariant: `values[i] == values[pi[i]]` for every declared symmetry `pi`.
Exercises: `rule_contract::ground` symmetry admission (`:281-308`).
Oracle: the least solution itself — the invariant is a theorem about automorphisms, so it needs no
second implementation.
Closes gap 2 and is the natural companion to EXT-2.

**PROP-TEST 7 — `parse_rules_is_total_and_idempotent`**
Generator: two strategies unioned — `any::<String>()` and a structured near-Datalog generator that
emits identifiers, digits, parentheses, commas, colons, hyphens, periods and occasional multi-byte
UTF-8 at random positions.
Invariant: `parse_rules(&s)` never panics, and when it returns `Ok(rules)`,
`parse_rules(&render(&rules)) == Ok(rules)`.
Exercises: `rule_contract::parse_rules` (`:367-439`).
Oracle: idempotence of `render ∘ parse`. The existing round-trip only feeds the parser its own
generated rules, so it never sees a malformed byte.

**PROP-TEST 8 — `provider_abi_is_total_and_respects_its_output_bound`**
Generator: a random operation sequence over one `Context` — `op` drawn from valid and invalid
codes, `handle` from live handles, released handles, foreign-nonce handles and random `u64`s, and
buffers of length `0..=4096` including capacities shorter than the descriptor.
Invariant: every `ergodis_invoke` returns a status code, `written <= capacity` on `OK`,
`written == 0` on every non-`OK` status, and the `catch_unwind` at `provider.rs:202` never fires.
Exercises: `provider::ergodis_invoke` and `Context::call`.
Oracle: none needed — totality plus the write bound is the property.
This is the only untrusted-pointer surface in the day's work and it currently has no generated
coverage.

**PROP-TEST 9 — `certificates_do_not_transplant_between_sources`**
Generator: two admitted programs `A` and `B` with equal scalar counts (easiest by generating one
program and perturbing a single fact cost).
Invariant: `A.verify(&cert_B).is_err()` whenever `A.source_id() != B.source_id()`, and
`A.verify(&serde_round_trip(cert_A)) == Ok(())`.
Exercises: `rule_contract::verify` binding (`:336-341`) and the JSON codec.
Oracle: source-identity inequality.

**PROP-TEST 10 — `the_rounds_field_is_a_budget_not_a_measurement`**
Generator: an admitted program and `r in 0..=scalar_count`.
Invariant: `verify` succeeds iff `r >= productive_rounds(program)`, independently of the value the
producer wrote.
Exercises: the `rounds` handling in `rule_contract::verify` and `composition_graph::propagate`.
Oracle: `productive_rounds` from the naive iteration.
Writing this property makes RISK-2 explicit in the test suite, and it becomes the regression test
if EXT-1 tightens the field.

**PROP-TEST 11 — `native_and_wasm_certificates_are_byte_identical`**
Generator: seeded random admitted programs, serialized to JSON and fed to both the native cdylib
and the `wasm32-unknown-unknown` module through the existing harnesses.
Invariant: the two certificate byte strings are equal, and both verify.
Exercises: the C ABI (`ergodis_invoke` selector 1) on both targets.
Oracle: cross-target equality.
Today `native_abi.py` and `wasm_abi.mjs` run a fixed 129-program corpus; parameterizing the
generator seed turns a fixture into a property at almost no cost.

**PROP-TEST 12 — `fork_depth_matches_breadth_first_search`**
Generator: random valid `RunRecord` catalogues — `2..=8` runs, each a `Start` or `Fork` plus
`0..=4` `Update`s with correct predecessor links — and a random origin.
Invariant: `readout().depths[i]` equals the BFS minimum fork-edge distance from the origin set,
with `None` exactly for unreachable runs.
Exercises: `LineageReadout::new` (`lineage.rs:75-154`) and the `n²` offset at `:186`.
Oracle: a plain BFS over the fork edges, written directly in the test.
Closes gap 6 for the lineage half; the existing tests use one fixed real-record fixture.

**PROP-TEST 13 — `origin_toggle_round_trips_and_consumes_exactly_two_revisions`**
Generator: a catalogue as above plus a sequence of `set_origin(run, enabled)` calls.
Invariant: toggling a non-origin run on and then off restores the previous `depths`, and
`sequence()` advances by exactly the number of accepted calls.
Exercises: `LineageReadout::set_origin` and the retraction-restart path it drives through
`RecursiveQuery::replace`.
Oracle: the readout captured before the toggle.

**PROP-TEST 14 — `parallel_and_serial_surfaces_are_identical_at_every_split`**
Generator: random `AllocationSource` — `1..=32` families, `1..=8` options each, two varying
resources, `maxima` in `1..=24` chosen so that `cells` straddles the 8192-cell tile boundary — plus
a random partition of `jobs()` into `advance_build` budgets.
Invariant: `previous`, `choices` and `transitions` are identical between
`advance_build` and `advance_build_parallel` for every split.
Exercises: `src/allocation_surface/parallel.rs:57-121` against `src/allocation_surface.rs:292-326`.
Oracle: the serial kernel.
Credit where due: `tests/allocation_parallel_contract.rs` already compares the two kernels at
mixed budgets (`0, 1, 7, 24` against a single `advance_build(32)`) with a zero-allocation
assertion, and its `maxima = [259, 271]` gives `cells = 70 720` and `width = 272`, which does
straddle the 8192-cell tile boundary mid-row. So the interesting arithmetic *is* covered for one
shape. What a generator adds is shape diversity the fixed cases cannot reach: `cells < TILE`,
`width > TILE`, `width` an exact divisor of `TILE`, and a collapsed axis (`a == 0`) combined with
a large `b`.

**PROP-TEST 15 — `lowering_synthesis_is_complete`**
Generator: random `Model` with `2..=6` sources, `1..=3` events, `1..=4` summaries, surjective
lowering.
Invariant: `synthesize(m)` returns `Square` exactly when some `H` satisfies the square, and
otherwise returns `Impossible` with an obstruction that `verify_obstruction` accepts.
Exercises: `src/finite_lowering::synthesize` (`:26-66`) and
`crates/verify/src/finite_lowering::{verify, verify_obstruction}`.
Oracle: brute-force enumeration of all `summaries^(summaries × events)` tables, feasible at these
sizes.
Generalizes the existing exhaustive 3-source/2-event/2-summary test to a wider shape space.

**PROP-TEST 16 — `the_saturating_carrier_boundary_is_consistent`**
Generator: programs whose fact costs are drawn from `u32::MAX/2 ..= u32::MAX`, so that products
saturate.
Invariant: the sparse evaluator, the naive oracle and the verifier agree coordinatewise, and any
coordinate reaching `u32::MAX` stays at `u32::MAX` under further improvements elsewhere.
Exercises: `BoundedMinPlus::times` (`weight.rs:81-83`) and the `u32::MAX`-as-absent convention
throughout.
Oracle: naive iteration in `u128` with an explicit clamp at `u32::MAX`, as
`min_plus_transition::semi_naive_tests::reference` already does for the matrix carrier.
Closes gap 1 — this is the one declared precondition of the whole contract
(`exact_carrier: false`) and it currently has no generated coverage.

**PROP-TEST 17 — `every_admitted_algebra_satisfies_the_laws_the_checker_relies_on`**
Generator: random triples over each carrier, with `zero`, `one` and near-saturation values
oversampled.
Invariant, as a conjunction: `⊕` associative/commutative/idempotent; `⊗` associative and
distributing over `⊕` on both sides; `one ⊗ x == x`; **`zero ⊗ x == zero`**;
`u ⊕ (v ⊖ u) == u ⊕ v`; `(v ⊖ u) == zero ⟺ u ⊕ v == u`;
`decode(encode(x)) == Some(x)`; `decode` returns `None` for every wrong length and every
noncanonical byte pattern.
Exercises: `weight::TransitionWeight` implementations.
Oracle: the laws themselves.
The annihilation clause is the point: `composition_graph.rs:203` skips a rule when both deltas are
`zero`, which is sound only under `zero ⊗ x == zero`, and that law appears nowhere in the trait
documentation or in the existing `admitted_weight_laws_and_canonical_codecs` fixed-value test.

---

#### 5. Release and evidence hygiene

##### 5.0 BUG — the evidence tree does not pass its own public lint; the C1161 files leak `/home/tavis/` paths

This one is demonstrated, not inferred. Running the repository's own guard against the evidence
tree fails today:

```
$ scripts/public-lint.sh evidence
2026-09-12-rule-frontier-ab.json:4: private-path:   "path": "/home/tavis/.cache/ergodis/bin/rule-replay-isolated-b4d6e9f",
2026-09-12-rule-frontier-ab.json:8: private-path:   "path": "/home/tavis/.cache/ergodis/bin/rule-replay-naive-b4d6e9f",
2026-09-12-rule-frontier.md:39:     private-path: ... --before /home/tavis/.cache/ergodis/bin/rule-replay-naive-b4d6e9f --after /home/tavis/.cache/ergodis/bin/rule-replay-isolated-b4d6e9f --output /home/tavis/.cache/ergodis/rule-runtime/replay-ab.json ...
public-lint: 3 finding(s); refusing
```

These are the only three private-path hits in the whole `evidence/` tree — and both files were
added the same day, by `9cd2980` (C1161), *after* `4fb1a01` ("Publish-ready evidence: anonymous
host id, scrubbed paths and identifiers") had scrubbed every pre-existing file. So the scrubbing
pass worked and the next commit reintroduced exactly the class it removed, because nothing ran the
lint against the evidence tree on the way in.

`7d3ed46` put the evidence repository on the same main/staging/public workflow, and
`hooks/pre-push` does run the lint on the pushed tip, so this would be caught at publication rather
than escaping. But it means the evidence repository is currently unpublishable without a
scrub-or-allowlist decision, and the failure is in the *new* material, not in the backlog. The fix
is to rewrite the two binary paths to their basenames (the manifest already carries the SHA-256 of
each binary, which is the part that matters for replay) and to express the replay command against
a `$ERGODIS_BIN` placeholder.

The structural cause is worth separating from the instance: the evidence lint is a push-time gate
with no commit-time counterpart. `hooks/pre-commit` runs the lint only when the `public` branch is
checked out, which is never true while evidence is being written on `main`. Running
`scripts/public-lint.sh evidence` from `tests/evidence_manifest.rs`, next to the manifest check that
`db64630` already wired into `cargo test`, would move this from "caught at publication" to "caught
at commit" for a few lines.

##### 5.1 RISK-7 — `SHA256SUMS` covers none of the 2026-09-12 code

`python/generate_evidence.py` builds the manifest from a hand-maintained `HASHED_PATHS` tuple
(`:94-182`) plus two fully-walked trees, `HASHED_TREES = ("evidence", "proptest-regressions")`
(`:186`). The commit `db64630` titled "Hash every evidence file, and make cargo test verify the
manifest" delivers exactly that scope — every evidence byte — and `tests/evidence_manifest.rs`
now runs `--check` inside `cargo test`, which is a real improvement.

But the hand-maintained half never grew. Measured against the current manifest:

| Path | In `SHA256SUMS`? |
|---|---|
| any path under `crates/` | no — zero rows |
| `src/allocation_surface.rs` (and `parallel.rs`, `count_axis.rs`) | no |
| `src/finite_lowering.rs` | no |
| `tests/finite_lowering.rs` | no |
| `tests/allocation_parallel.rs`, `tests/allocation_parallel_contract.rs` | no |
| `python/benchmark_rule_replay.py` | no |
| `wasm/src/lib.rs` | no |
| `evidence/2026-09-12-*` (4 files) | yes |

So the day's evidence artifacts are hashed, but the generator that produced them
(`python/benchmark_rule_replay.py`), the mechanism they measure (`crates/rules`,
`crates/runtime`), and the verifier that certifies them (`crates/verify`) are all outside the
manifest.

One mitigation is real and worth crediting: `evidence/2026-09-12-rule-frontier-ab.json` embeds
`generator_sha256` and a `binaries` map with a SHA-256 per A/B executable, and I verified that the
recorded generator hash
(`623e16450748902483571d00c4117c88a98f8bfb35efff9d05517bed0edc3855`) matches the committed
`python/benchmark_rule_replay.py` byte for byte. Since that JSON file *is* in `SHA256SUMS`, the
hash chain for this particular bundle closes through the evidence file rather than through the
manifest. That does not extend to the Rust mechanism, and it depends on each future evidence
producer remembering to self-hash.

The reproducibility convention wants report, generator and certificate committed as one
git-visible bundle with SHA-256 hashes; the first two conditions hold (everything is committed),
the third holds only for the bundles that self-hash. The C1163 report works around this by pasting a six-row SHA-256 table for
`crates/rules/tests/` into the othello notes by hand — which is precisely the manual step the
manifest exists to remove, and it will go stale the same way the manifest did before `db64630`.

Recommended fix: extend `HASHED_TREES` to walk `crates/*/src`, `crates/*/tests`, `src/`, `tests/`
and `wasm/src`, or at minimum add the missing paths to `HASHED_PATHS`. The walk form is preferable
here for the same reason the commit message gives for `evidence/`: adding a file should not
silently leave it uncovered.

##### 5.2 RISK-8 — the published `SHA256SUMS` advertises 122 files that the export removes

`.publicignore` drops `evidence/` from every export, and `SHA256SUMS` is not in `.publicignore`,
so it ships. 122 of its 209 rows name `evidence/...` paths. The evidence-link rewrite in
`scripts/export-public.sh:154-159` is confined to `*.md`, so those rows ship verbatim, pointing at
a directory that is not in the tree. `tests/evidence_manifest.rs:18-24` then detects the missing
directory and *skips*, printing a note, so `cargo test` on the public tier passes without checking
anything.

The skip is deliberate and documented in the test's own module comment. The problem is the
combination: a public consumer sees a 209-row manifest, cannot verify 122 of them, and gets a green
test run. Either filter the evidence rows out of the exported manifest, or rewrite them to the
companion repository's URL the way prose links are rewritten, or add the manifest itself to
`.publicignore` and ship a manifest generated for the public tree.

##### 5.3 RISK-9 — the task-ID lint misses the identifier form its own documentation cites

`scripts/public-lint.sh:190-191` matches `\bC[0-9]{2,4}\b`, case-insensitively. The header comment
at `:14-18` justifies the case-insensitivity by naming two real forms that carry task identifiers
into evidence: `"ergodis-c997-gurobi-v2"` and `"c997_source"`. Tested directly:

```
input                    matched
ergodis-c997-gurobi-v2   c997      (flagged)
c997_source              -         (NOT flagged)
C1160_note               -         (NOT flagged)
see C1160.               C1160     (flagged)
```

`_` is a word character, so `\b` does not match between `7` and `_`. The rule therefore misses
every `snake_case` field name carrying a task ID — one of the two forms the comment says the rule
exists to catch. A JSON key such as `"c1160_source"` or a Rust identifier such as `c1163_fixture`
passes the lint. Fix: extend the boundary to treat `_` as a separator, e.g. match
`(^|[^A-Za-z0-9])[Cc][0-9]{2,4}([^0-9]|$)` and exclude a preceding alphanumeric, or simply drop the
trailing `\b` in favour of `[^0-9]`.

Related, smaller: the pattern caps at four digits, so a future five-digit ID would evade it.

##### 5.4 RISK-10 — the content lint never reads binary files

`scripts/public-lint.sh:220` gates `scan_text` on `grep -Iqs . "$file"`, and the rewrite passes in
`scripts/export-public.sh:144,156` do the same. Binary artifacts are therefore covered only by the
`oversize` rule. A compiled artifact, a `.json` containing a NUL, a font or an image with embedded
metadata could carry `/home/tavis/...` or a task ID into the public tier unflagged. The current
tree has no such file, so this is prophylactic — but the export filter is the only thing standing
between the private paths and GitHub, and "we happen not to ship binaries today" is the whole of
the current protection.

##### 5.5 RISK-11 — `pre-push` does not guard pushes to unnamed local remotes

`hooks/pre-push:68-71` computes `publication_remote` from the remote *name* (`public` or
`staging`) and then, at `:73-75`, `continue`s without any check when it is zero. The URL-level
refusals above it (`:57-62`) block the known public URL and every non-local URL. What remains
permitted is `git push /any/other/local/path main` — a second local clone, which may itself have a
GitHub remote. The `staging/pre-receive` guard that refuses `refs/heads/main` exists only in the
staging checkout that `scripts/configure-remotes.sh` configured.

The threat model is explicitly "the private repository pushes only to a local staging checkout",
so this is a deliberate boundary rather than an oversight. But the hook's own comment says a
staging checkout is "one `git push` away from GitHub", and that argument applies to any local
clone. Tightening the `publication_remote == 0` branch to refuse `refs/heads/main` to *any* remote
would cost one line and close it.

##### 5.6 NIT-7 — the recorded-tag check is a substring match

`hooks/pre-push:85-86` uses `grep -Fq "<TAB>$tag"` against `EXPORTS.md`. Because it is a substring
test, an unrecorded tag `v0.1.0` matches the recorded row for `v0.1.0-preview1`. The lint still runs
on the pushed tip afterwards, so this is not a full bypass, only a weaker guard than the message
"tag $tag is not recorded in EXPORTS.md" implies. Anchor it with `grep -Fxq` against a
reconstructed row, or match `<TAB>$tag$`.

##### 5.7 NIT-8 — `export-public.sh` hard-codes a foreign session scratch path

`scripts/export-public.sh:118` defaults `scratch_base` to
`/tmp/claude-1000/-home-tavis-src-othello-rust/785e0ee5-.../scratchpad`, a specific past session's
scratchpad UUID, and `mkdir -p`s it. Two issues: it is a stale path baked into a committed script,
and `/tmp` is tmpfs on this host, so a full `git archive` extraction of the tree goes into RAM.
`${TMPDIR:-/tmp}` or a `.cache` path would be the conventional choice.

##### 5.8 NIT-9 — two lists of process documents must be kept in sync by hand

`.publicignore` and `is_process_doc` in `scripts/public-lint.sh:161-173` enumerate overlapping but
not identical sets. They agree today. Drift in either direction is silent: a file added to
`is_process_doc` but not `.publicignore` makes every export fail the lint, and the reverse leaves a
process document unflagged if the ignore entry is ever removed. Deriving the lint's list from
`.publicignore` would remove the class.

##### 5.9 What the hygiene work got right

- `staging/pre-receive` enforces the one-branch invariant at the destination rather than only at
  the sender, which is the correct place for it.
- `staging/publish.sh` parks `remote.origin.pushurl` at `no-push://parked` and installs the real
  URL only for the duration of the push, restored by an `EXIT` trap.
- `export-public.sh` lints the *filtered* tree and the commit message, after the rewrites, not
  before — so the lint sees exactly what would be published.
- `hooks/pre-commit` runs only on the `public` branch and lints staged blob contents rather than
  the working tree, which is what `927c618` fixed.
- `tests/evidence_manifest.rs` putting `--check` inside `cargo test` is the right mechanism; the
  problem in §5.1 is the scope of the list it checks, not the mechanism.

---

#### 6. Extension opportunities

**EXT-1 — make `certificate.rounds` a verified measurement instead of a budget.**
The replay already knows the productive round count. Requiring
`certificate.rounds == replayed_productive_rounds` (or storing both a claimed bound and the
measured count) turns a currently vacuous field into the wire representation of the C1165 sharpness
and C1168 distinct-output results, which otherwise exist only in Lean and in the property suite.
Cost: a return value from `composition_graph::propagate` and one equality check. Requires deciding
what the runtime's `rounds = scalar_count` overwrite (`recursive.rs:92,164`) becomes; the comment
there gives a real reason for the current behaviour, so this needs the budget and the measurement
to become separate fields rather than one.

**EXT-2 — spend the symmetry declarations.**
`ground` already proves each declared permutation is an automorphism of the grounded system. It is
a theorem that the least fixpoint is then invariant under it. Adding
`for pi in symmetries { assert claim[i] == claim[pi[i]] }` to `rule_contract::verify` is a few
lines, costs `O(symmetries × scalars)`, and converts a declaration that currently does nothing into
an independent consistency check on the claim. It also gives the Lean `symmetry invariance`
statement in `Contract.lean` an executable counterpart. Pairs with PROP-TEST 6.

**EXT-3 — let `WeightProperties` gate the algorithms that depend on it.**
`Stability::Uniform(0)` is asserted nowhere outside a test, yet both propagation loops assume it.
A `const _: () = assert!(matches!(W::PROPERTIES.stability, Stability::Uniform(0)))` at the
`composition_graph` entry — or, better, deriving the round bound from `p` — would make the sealed
trait's extension point safe to use. This is the cheapest of the three and it is the one that
matters when the Boolean and counting-semiring benchmark rows land.

**EXT-4 — give the incremental path an incremental source identity.**
`Prepared::with_fact` re-grounds and re-hashes the entire program per update (RISK-5). Since only
one input coordinate changes, a `with_fact_in_place` that mutates `inputs[slot]`, keeps `products`
and `users` untouched, and updates a *tree-structured* or incrementally-composable source digest
would make `RecursiveQuery::replace` cost proportional to the frontier rather than to the program.
This is the change that would let the measured 15× kernel speedup survive to the API surface, and
the 1 000 000-update budget in `recursive.rs:14` is the setting where it matters.

**EXT-5 — the Boolean carrier is one generic parameter away from unlocking the transitive-closure
benchmark row.** `composition_graph` is already generic over `TransitionWeight` and `Boolean` is
already implemented and law-tested. `rule_contract` is the only thing that hard-codes
`"bounded-min-plus-u32"` (`rule_contract.rs:172`) and `BoundedMinPlus` (`:331,345`). Parameterizing
`Program.semiring` over the two implemented carriers would deliver the TC and SG (Boolean) rows of
the step-5 benchmark suite with no new mathematics, and it is the natural demonstration that the
contract is carrier-agnostic rather than a min-plus special case. The Lean `Contract.lean` is
already stated over an abstract idempotent semiring, so the formal side already covers it.

**EXT-6 — the missing negative control on the frontier.** Per RISK-6, no committed fixture produces
a persistently dense frontier. Adding one — non-chain edge costs drawn so that many coordinates
improve each round — would either confirm the frontier as a safe default or produce the
"retain a negative-control policy" outcome the C1161 scope statement anticipated. It is a
ten-line change to `replay_profile.rs` and it is the measurement that the current evidence bundle
is missing.

##### Surprising or unexplained observations

1. **The `rounds` field is written three different ways.** The cold path writes the measured count
   (`lib.rs:117`), the incremental path writes `N` (`lib.rs:242`), and the runtime overwrites both
   with `N` (`recursive.rs:92,164`). Three writers, one reader that only range-checks it. This is
   the clearest sign that the field has not settled on a meaning, and EXT-1 is the resolution.

2. **`exact_carrier: false` is the contract's single declared precondition and has no consumer and
   no generated test.** Every claim about unbounded path costs depends on it, the C1160 and C1163
   mystery ledgers both list saturation as an open scope limit, and the property suite caps
   generated costs at 1000 — three orders of magnitude below where the behaviour changes. PROP-TEST
   16 is the cheapest way to find out whether the boundary behaves as assumed.

3. **`Prepared::propagate`'s `1..=N` bound is exactly tight while the checker's is one looser,** and
   the looseness is invisible because the producer never emits a certificate that would exercise it.
   Tightness here is not a coincidence — it is the `N`-coordinate chain argument — but the fact that
   two modules implementing the same bound disagree by one, with documentation matching neither,
   suggests the bound was derived twice rather than once.

4. **The dense benchmark's 5.22× is not a dense measurement** (RISK-6). The number is real but it
   measures a workload that becomes sparse after two rounds. Any citation of it as evidence about
   dense recursion would be wrong, and the C1161 report is right to flag it as an open scope limit
   rather than a result.

5. **The evidence manifest grew a full-tree walk for `evidence/` on the same day that ~3 000 lines
   of new mechanism landed outside it.** The commit message for `db64630` diagnoses the exact
   failure mode — "it had gone stale unnoticed because nothing ran the check" — and the fix covers
   the half of the manifest that was already automatic while leaving the hand-maintained half to go
   stale again immediately. This is the highest-leverage single fix on the list.

---

## Report B — Lean WeightedRules (Opus, cold)

##### Cold review — WeightedRules Lean work, 2026-09-12 (C1163–C1168)

Cold read, strictly read-only. No build, no elaboration, no git state change.
Repo `/home/tavis/src/othello`, branch `main`, HEAD `08a822053`.
Rust definitions consulted at `/home/tavis/src/ergodis/crates/rules/src/` and
`/home/tavis/src/ergodis/crates/verify/src/rule_contract.rs`.

Severity tags: **BUG** (wrong), **RISK** (right today, fragile or overstated),
**NIT** (hygiene), **EXT** (free or cheap extension), **PROP-TEST** (test to add).

#### Commits in scope

`git -C /home/tavis/src/othello log --since='2026-09-12 00:00' --format='%h %s' -- lean`

| sha | subject | task |
|---|---|---|
| `1bc04c132` | Define finite weighted rule and least-fixpoint contracts | C1163 |
| `cb25d7eba` | Prove bounded min-plus laws and cyclic distance certificate | C1163 |
| `07e4f6f55` | Audit weighted-rule and bounded min-plus proof axioms | C1163 |
| `a6cfbf668` | Prove relational transport of weighted-rule certificates | C1163 |
| `eff2a2c70` | Audit relation transport theorem axioms | C1163 |
| `3ea2b8dae` | Prove soundness of finite min-plus certificate reflection | C1164 |
| `6bbc954bc` | Add external C ABI witness elaborator with kernel replay | C1164 |
| `39e64b37d` | Check a live external distance witness in the Lean kernel | C1164 |
| `0a89581b9` | Reject adversarial certificates at the Lean oracle entry point | C1164 |
| `c8a427a70` | Check finite replay coverage and unsupported fixed-point rejection | C1164 |
| `e4a60e6e3` | Audit external witness proof axioms and document replay boundary | C1164 |
| `ab23522d5` | Prove agreement of external and internal distance certificates | C1164 |
| `912f34c8f` | Reject oracle witnesses for a different formal caller program | C1164 |
| `602274a52` | Audit agreement proof and document wrong-program rejection | C1164 |
| `fc55214ab` | Close C1162 with checked lowering squares and Lean trace laws | C1162 |
| `e6ddc6e57` | Prove sharp scalar-round convergence and certificate completeness | C1165 |
| `0d89fce56` | Close C1165 with universal convergence and sharpness evidence | C1165 |
| `f144c82aa` | Add checked finite table lowering and readout cardinality proofs | C1166 |
| `aa8b2a362` | Prove and check incremental min-plus replay from prior certificates | C1167 |
| `7798d342d` | Check external incremental witnesses and chained distance updates | C1167 |
| `0f516d64b` | Close C1167 with incremental oracle proofs and measured checking gains | C1167 |
| `0fcf576af` | Prove sharp rule-output convergence and checked conversions | C1168 |

#### Verdict up front

The mathematics is real and the reports do not oversell the theorems. There is no
`sorry`, no `axiom` declaration, no `native_decide`, no `ofReduceBool`, and no
`unsafe` / `partial` / `opaque` / `implemented_by` anywhere under
`lean/WeightedRules/` — the only occurrences of those words are docstrings saying
they are not used (`OracleExample.lean:11`, `Reflection.lean:11`). The universal
theorems are genuinely universal: quantified over `P : Program Cost n` for every
`n`, with no acyclicity, positivity, distinctness or size hypothesis. Every
`decide` / `decide +kernel` in the tree discharges an explicitly finite control
statement, and none of those controls is presented as a general result — the
general results are separate, symbolically proved theorems standing beside them.

No BUG-severity finding. The substantive findings are three: the axiom audit is a
log a human reads rather than a build gate; the "oracle" delegates no computation,
so checking cost equals solving cost and the reports never state that as the
governing constraint; and the Lean/Rust round-counting conventions agree by a
conspiracy of two different definitions that nothing pins down.

#### 1. Statement fidelity

##### Universal convergence — holds as claimed

`Convergence.lean:178` `boundedMinPlus_iterate_fixed (P : Program Cost n) :
step boundedMinPlus P (iterate boundedMinPlus P n) = iterate boundedMinPlus P n`.
Universally quantified over `n : Nat` and over all `P`; no side conditions, and
`n = 0` is included. Non-vacuous: the proof does real work. `improvement_coordinates`
(`Convergence.lean:139`) constructs a `Finset (Fin n)` of cardinality `k+1` witnessing
that a round-`k+1` improvement forces `k+1` distinct coordinates, and
`boundedMinPlus_improvement_round_le` (`Convergence.lean:168`) closes it against
`Finset.card_le_univ`. Nothing here is a fixture.

RISK (framing, minor): "`N` rounds" means `N` = the number of *scalar* coordinates,
which for the grounded encoding is `Σ_r domain^arity_r + 1` — exponential in arity,
quadratic in domain for a binary relation. The four-vertex example needs `N = 21`
for four real unknowns. C1163's report does spell the arithmetic out, but the phrase
"scalar N-round bound" reads tighter than it is when it recurs in later reports. The
C1168 `min n (M+1)` bound is the right correction and should be the number quoted.

##### Sharpness — holds as claimed, and is symbolic

`ConvergenceSharpness.lean:74` `zeroChain_requires_scalar_rounds (n) (hn : 0 < n)`.
Proved through `zeroChain_iterate` (`ConvergenceSharpness.lean:60`), a closed-form
characterization of every iterate by induction — not a `decide` sweep over a finite
family, so there is no enumerated size cutoff. `OutputConvergenceSharpness.lean:84`
`outputChain_requires_extra_round (m)` does the same for every output count `m`,
including `m = 0`. The claim is sharpness of a *uniform* bound, which is exactly what
the docstrings say (`ConvergenceSharpness.lean:72-73`). Not oversold.

##### Certificate completeness — holds, and is stronger than the reports say

`ConvergenceReflection.lean:27` `checkCertificate_complete` gives acceptance of the
exact `n`-iterate; `ConvergenceReflection.lean:43` `CheckedSolution.eq_iterate` gives
the converse — *every* accepted certificate, at any accepted round count, denotes the
`n`-iterate. Together these make acceptance an exact characterization: the accepted
value vector is a singleton.

NIT (framing): because of `eq_iterate`, `oracleDistance_agrees` (`OracleExample.lean:33`)
is a corollary, not an independent cross-check. Two solvers *cannot* return different
certified values once both certificates are accepted, since acceptance pins the values
to the caller's own iterate. C1164's mystery ledger lists "Two solvers could return
different certified values — Settled for the example by `oracleDistance_agrees`", which
undersells it in one direction (it is settled for all programs, not the example) and
oversells it in another (it was never a possible failure mode given the checker design).

##### Fifteen-state minimality — generic half verified, the number is out of scope

`ReadoutMinimality.lean:19` `separated_readouts_card_le` is a clean Myhill–Nerode
injection: given a lowering square, a readout-preserving summary, and pairwise
trace-distinguished representatives, `Fintype.card Q ≤ Fintype.card Y`. No surjectivity,
no minimality, and no assumption that the candidate summary shares the certificate's
representation — the report's claim on that point is accurate.

RISK (review scope): the number fifteen, the fifteen representatives and their
separating traces live in `~/src/ergodis-private/lean/PrivacyLowering.lean`, outside
this repository. I could not verify them. The C1166 report's account is coherent —
`joint_summary_collapse` identifies exactly the two already-fully-leaked joint states,
so 16 − 1 = 15 — and if `BinaryPrivacy.semanticPrivacyReadout` really is defined solely
by physical-world agreement with no imported table, the argument is not circular. It is
nonetheless the only headline number in this batch whose derivation is invisible from
the monorepo, and it should get an independent read by someone with private access.

##### Incremental replay soundness — holds, and the trap is explicitly tested

`IncrementalReflection.lean:60` `checkImprovementCertificate_sound` takes
`old : CheckedSolution P` as a typed hypothesis and checks against `old.values`.
The raw Boolean `checkImprovementCertificate` is deliberately *not* sound on its own,
and `IncrementalChecks.lean:73` `unchecked_seed_boundary` proves exactly that: a seed
`[0]` for `selfProduct infinity` passes local replay and fixedness but fails the
from-zero checker. The typed structure `CheckedImprovement` (`IncrementalReflection.lean:68`)
carries `old` as a structure parameter, so the elaborator cannot detach it and the
oracle syntax must be handed a real prior proof. This is the right design and the
control is the right control.

`CheckedImprovement.toCheckedSolution` (`IncrementalReflection.lean:86`) discharges its
`accepted` field by proof (`decide_eq_true` applied to a constructed Prop term), not by
re-running `decide` over `n` rounds — so conversion is genuinely free, as claimed.

##### Chained distance agreement — holds

`IncrementalExample.lean:39-42` chains a second external witness onto
`oracleImprovedDistance.toCheckedSolution`, and `oracleTwiceImprovedDistance_least`
(`IncrementalExample.lean:64`) states leastness for the twice-improved program. The
readouts `[0,1,2,4]` and `[0,1,0,4]` are checked by `decide +kernel`.

##### Wrong-program rejection — holds, with a good positive control

`OracleRejections.lean:57-62`: a certificate valid for `selfLoop` is replayed against
`differentProgram` and rejected at the elaborator with `#guard_msgs`. Crucially
`OracleRejections.lean:17-20` keeps a *positive* control (`acceptedLoop`), so a failure
to invoke the fixture at all cannot masquerade as successful rejection. Eight further
`#guard_msgs` cases cover schema, dimensions, round bound, cost range, source identity
encoding, process exit and an unsupported zero-cost self-loop.
`IncrementalOracleRejections.lean` adds four more at the incremental entry point,
including a retraction presented as an improvement.

##### Trivialization scan — clean

No hypothesis in any headline theorem trivializes it. The `Fintype`/`Finset`
constraints are intrinsic to `Fin n`, not added assumptions. `decide +kernel` is used
in preference to plain `decide` in the larger controls, which is the *stronger* route
(straight kernel reduction, bypassing elaborator whnf) and adds no trust.
`set_option maxRecDepth` appears where finite reduction needs it
(`BoundedMinPlus.lean:121`, `OracleExample.lean:16`, `IncrementalExample.lean:21`,
`ChainDistance.lean:19`) — a resource knob, not a soundness one.

#### 2. Axiom audit accuracy

Six audit modules print 79 terminals between them: `AxiomAudit.lean` (13),
`OracleAxiomAudit.lean` (8), `LoweringSquareAxiomAudit.lean` (8),
`ConvergenceAxiomAudit.lean` (12), `IncrementalAxiomAudit.lean` (20),
`OutputConvergenceAxiomAudit.lean` (18), plus five inline prints at
`FiniteLoweringChecks.lean:66-70`. Every headline theorem named in the reports appears
in one of these lists. No `ofReduceBool` is possible because `native_decide` is never
used. `Classical.choice` enters only through Mathlib's `Finset`/`Fintype` counting
lemmas used by the convergence arguments (`Finset.card_le_univ`,
`Finset.card_insert_of_notMem`), exactly as the reports describe.

**RISK (medium) — the audit is not a gate.** `#print axioms` is a display command.
It cannot fail elaboration, and nothing in the repository turns its output into an
assertion: there is no `#guard_msgs in #print axioms ...` anywhere, and no script greps
the saved stdout for `sorryAx` or `ofReduceBool`. The reports' evidence is of the form
"Final axiom output: `~/.cache/othello-lean-build/guarded-lean/.../stdout.log`" and
"exact eighteen-terminal audit coverage was checked against the retained stdout" — a
human read a log. If a `sorry` or a `native_decide` were introduced into a dependency
tomorrow, every audit target would still build green and only a reader would notice.

This is cheap to close and it is the highest value-per-effort item in the review:
wrapping each print as `#guard_msgs in #print axioms Foo` turns the whole audit layer
from documentation into a build-failing assertion, at the cost of pasting the expected
axiom line into each `/-- info: ... -/` comment. (Verify the exact message format
against the pinned `leanprover/lean4:v4.32.0-rc1` before converting all 79.)

**RISK (low) — a live external witness is unaudited.** `chainDistanceBaseline`
(`ChainDistance.lean:43`) and `chainDistanceBaseline_values` (`ChainDistance.lean:47`)
are a second live ABI witness on exactly the same trust route as `oracleDistance`. They
*are* elaborated during the audit build — `ChainDistance` is imported by
`OutputConvergenceChecks.lean:3`, which `OutputConvergenceAxiomAudit` imports — but
neither name appears in any `#print axioms` list. The claim "every external witness is
audited" therefore has a hole. Add both to `OutputConvergenceAxiomAudit.lean`.

**NIT — unprinted constructions.** `boundedMinPlusCertificate` (`Convergence.lean:203`),
`iteratedCheckedSolution` (`ConvergenceReflection.lean:36`), `ruleOutputCertificate`
(`OutputConvergence.lean:96`) and `EventLowering.CheckedLowering.square`
(`FiniteLoweringReflection.lean:55`) are not printed. All are definitionally downstream
of printed terminals, so the omission is cosmetic, but the audit files are the
advertised inventory and an inventory with gaps invites the wrong inference.

**RISK (low) — no aggregate target.** `lakefile.toml:2` lists twelve `defaultTargets`
and `WeightedRules` is not among them; `lakefile.toml:61-62` declares the library with
no `roots`, and there is no `lean/WeightedRules.lean` root module. So `lake build` never
touches this library, and no single target builds all six audits — the C1168 closing
aggregate (`run-20260913-044758-8bff0465`) named four of them, leaving `AxiomAudit`,
`LoweringSquareAxiomAudit` and `FiniteLoweringChecks` out of that run. Adding
`lean/WeightedRules.lean` importing every audit module, and `"WeightedRules"` to
`defaultTargets`, makes one target cover the library and costs nothing.

#### 3. Oracle / reflection boundary and the trusted computing base

##### What is trusted

For `oracleDistance_least` (`OracleExample.lean:22`) the trusted base is:

1. the Lean kernel, plus `propext`, `Quot.sound`, `Classical.choice`;
2. the caller's hand-written `distanceProgram` (`BoundedMinPlus.lean:100-119`) — this
   is the actual specification, and nothing checks that it is the grounding of
   `fixtures/distance.json`;
3. nothing else.

Not trusted, and correctly so: the Python adapter (`oracle.py`), the Rust ABI, the JSON
codec, the source hash. `decodeCertificate` (`Oracle.lean:31-44`) range-checks the
32-byte `source_id` and then *discards* it — right, because it carries no proof weight.
`costLiterals` (`Oracle.lean:60`) inserts only numerals; process output is never parsed
as Lean code; `elaborateCertificate` (`Oracle.lean:65-73`) runs `withoutErrToSorry` and
rejects any term with `hasSorry`.

##### Can a malformed or sibling certificate slip through? No — and here is why that matters

`checkCertificate` (`Reflection.lean:21-25`) demands
`∀ i, iterate boundedMinPlus P rounds i = listState values i` — full pointwise equality
with Lean's *own* Kleene iterate, on top of exact length, `rounds ≤ n` and fixedness.
The accepted value vector is therefore the unique one Lean computes itself. A sibling
certificate cannot pass; `OracleRejections.lean:59-62` confirms this operationally.

**RISK (medium, framing) — the oracle delegates no computation.** The same property
means the kernel re-solves the problem from scratch: `rounds` full synchronous rounds
over all `n` coordinates and all rules. The external values are entirely redundant.
`ergodis_solution` is a value-reification and round-count-hint mechanism, not a
certificate checker in the reflection sense where checking is asymptotically cheaper
than solving. The C1167 measurement is exactly what that predicts: two-step incremental
replay beats six-step from-zero replay by 1.56× because it runs fewer kernel rounds,
not because it checks rather than solves.

`2026-09-12-lean-automation-integration.md:47` and `...-c1164-lean-oracle.md:183` each
note in passing that full kernel replay may dominate larger queries, but neither the
C1164 nor the C1168 mystery ledger lists "checking cost equals solving cost" as an open
boundary — and it is the property that decides whether this can ever front a real IR
workload. It belongs in the ledger as the governing constraint on the next gate.

**EXT — what a genuinely cheap certificate looks like.** To get checking cost below
solving cost you need a *support witness*: for each coordinate, either "this is an
input" or "rule `r` derives it from `j, k` with `rank j < rank i` and `rank k < rank i`".
Acceptance is then one pass over the rules (local fixedness: each coordinate equals the
min of its inputs and its incoming products) plus a well-foundedness check on the ranks —
O(|rules|) rather than O(n · |rules|). Fixedness alone is unsound, and
`unsupported_cycle_controls` (`ConvergenceChecks.lean:26`) is precisely the
counterexample; the rank function is exactly what rules out unsupported cycles. This is
the standard supported-versus-founded-model distinction, it is a clean self-contained
theorem, and the Rust side already holds the data to emit it — the round at which each
coordinate last changed is a valid rank. This is the single highest-leverage extension
in the batch and it is what unblocks any scaling claim.

##### Attack surface

RISK (low, documented but worth restating): `requestCertificate` (`Oracle.lean:46-58`)
shells out to `$ERGODIS_RULE_ORACLE`, defaulting to `WeightedRules/oracle`, with no
timeout, no sandbox and no path pinning. Elaborating this library executes whatever that
variable names. Worse for robustness than for soundness: `IO.Process.output` reads
stdout to EOF, so the 1 MiB limit at `Oracle.lean:32` is applied to a string that is
already fully in memory — a producer emitting unbounded output exhausts memory before
the check runs, and a hung producer stalls the build rather than being rejected.
A soundness failure is impossible (the kernel check is downstream of all of it); a
denial-of-service or a supply-chain substitution is not.

NIT: `elaborateCertificate` catches *all* exceptions (`catch _ =>`) and rethrows one
generic message. That is what makes the `#guard_msgs` rejection tests stable, but it
also swallows interrupts, out-of-memory and genuine elaboration bugs into
"Ergodis certificate failed kernel replay", which will be painful the first time a real
failure hides behind it.

By contrast `nat_table_from_json` (`FiniteTableImport.lean:21-44`) is well-behaved: it
bounds the *read* itself at 1 MiB plus one rejection byte (line 27-28), caps entries at
65,536 and values below 2^32, inserts only numerals, and its docstring states plainly
that the operation establishes no mathematical property. `tableValue`
(`FiniteLoweringReflection.lean:22`) makes decoding total via `% m` and a fallback, but
`checkLoweringCertificate` (line 33) separately enforces `values.length = m * k` and
`∀ v ∈ values, v < m`, so the modular repair can never be load-bearing for an accepted
table. `lowering_rejection_controls` (`FiniteLoweringChecks.lean:33`) tests exactly that
wrapped-out-of-range case. Clean.

#### 4. Lean / Rust correspondence

Compared `lean/WeightedRules/{Contract,BoundedMinPlus,Convergence,Incremental}.lean`
against `ergodis/crates/rules/src/lib.rs` and
`ergodis/crates/verify/src/rule_contract.rs`.

**Agreements:**

- *Carrier and infinity.* Lean `Cost = Fin 4294967296` with
  `infinity = 4294967295` (`BoundedMinPlus.lean:23,26`); Rust `u32` with `u32::MAX`.
  Match.
- *Alternative.* Lean `costAdd = min` (`BoundedMinPlus.lean:29`); Rust keeps the
  smaller candidate (`lib.rs`, `propagate`). Match.
- *Composition and saturation.* Lean `costMul a b = min 4294967295 (a.val + b.val)`
  (`BoundedMinPlus.lean:32`); Rust `saturating_add` on `u32`, saturating at the same
  value. Match, including `∞ ⊗ x = ∞`. Both therefore identify an absent path with a
  path of cost ≥ 2^32−1 — declared semantics on both sides, stated in both docstrings.
- *Coordinate layout.* Rust grounds relations in declared order, row-major
  lexicographic with the last argument fastest, unit last
  (`rule_contract.rs:105,188-210`). Lean hard-codes exactly that: edge at `4x+y`,
  dist at `16+y`, unit at 20 (`BoundedMinPlus.lean:100-119`); the six-vertex chain does
  the same at `6x+y`, `36+y`, 42 (`ChainDistance.lean:23-35`). Match — by hand, unproved.
- *The unit scalar.* Rust sets `inputs[unit] = 0` and uses it as the right factor of
  one-atom rules (`rule_contract.rs:207-210, 265-268`), which is min-plus `mul_one`.
  Lean's coordinate 20 has input 0 and is never a rule factor, because all sixteen
  distance rules are two-atom. Consistent for these programs; the Lean model simply has
  no notion "this coordinate is the unit".
- *Negative weights.* Impossible on both sides (`u32` / `Fin`). Worth noting *where*
  the Lean proof needs this: `mul_left_cost` and `mul_right_cost`
  (`Convergence.lean:47-55`) supply `a ≤ a ⊗ b` for both factors, and that inequality is
  the whole engine of the counting argument. If the carrier is ever widened to signed
  costs, negative cycles break it and the entire C1165/C1168 layer must be re-derived
  from scratch. That deserves a comment on the Rust carrier type.

**RISK (medium) — round counting agrees by conspiracy, not by definition.**

Lean's `iterate P 0 = const ∞` and `iterate P 1 = inputs` (`Contract.lean:159-161`):
the fact-loading step *is* a round. Rust's `propagate` begins with `current = inputs`
already loaded, sweeps `1..=n`, and returns `rounds = round` at the first sweep where
`changed.is_empty()`. So Rust sweep `r` computes Lean's `iterate (r+1)`, and Rust's
returned count equals (improving sweeps) + 1, which happens to equal the least Lean
index at which the iterate is fixed.

I traced the retained four-vertex fixture by hand to confirm. Lean:
`iterate 1 = [0,∞,∞,∞]`, `iterate 2 = [0,7,2,∞]`, `iterate 3 = [0,3,2,10]`,
`iterate 4 = [0,3,2,6]`, fixed at 4. Rust: three improving sweeps, detection on the
fourth, returns 4. `fixtures/distance.certificate.json` carries `"rounds":4` and
`oracleDistance_rounds` (`OracleExample.lean:26`) proves 4 by `rfl`. They agree.

Two boundary cases also line up: all-infinity inputs give Rust `rounds = 0` with an
`active` list that is empty, and Lean accepts `checkCertificate loopProgram 0 [infinity]`
(`ReflectionChecks.lean:18`); inputs present with no rules give Rust 1 and Lean
`iterate 1 = inputs` (`ReflectionChecks.lean:26`).

But nothing states or proves the identity of the two conventions. Lean re-derives
`iterate P rounds` and would simply reject a drifted count, so a drift can only ever
produce a build failure, never a false theorem — this is safe. It is also brittle and
invisible: the failure mode is a fixture that mysteriously stops elaborating, with the
cause one round-counting line away in a different repository. Two cheap mitigations:
state the identity in `docs/rule-contract.md` ("the producer returns the least index at
which the Lean iterate is fixed; Lean round 1 is the fact-loading round"), and add the
property test P1 below, which is what would actually catch a drift.

Also worth noting: Rust's semi-naive frontier (`frontier.rs` incidence plus the
`marks`/`changed` machinery in `propagate`) reads correctly as *synchronous* — within a
round it reads only `current` and commits to `next`, publishing at the round boundary —
so it is Jacobi iteration with dead-rule suppression, which is exactly Lean's `step`.
No tie-breaking divergence is possible because `min` is commutative and idempotent and
the accepted value vector is unique.

**EXT — the Budget branch is now provably dead.** `propagate` loops `1..=n` and returns
`Err(Error::Budget)` on exhaustion. C1165 proves fixedness at Lean round `n`, i.e. after
at most `n−1` improving sweeps, so Rust's `n` sweeps always suffice with one to spare;
C1168 sharpens that to `min n (M+1)` where `M = (ruleOutputs P).card`. Two cheap
follow-ups: document the branch as unreachable for admitted min-plus sources, citing
`boundedMinPlus_rule_output_fixed` (`OutputConvergence.lean:84`); and lower the loop
bound to `min(n, M+1)`. The second matters more than it looks, because `n` is quadratic
in the domain for a binary relation — for the four-vertex program the worst-case budget
drops from 21 to 5, and for the six-vertex chain from 43 to 7
(`distance_rule_output_bounds`, `OutputConvergenceChecks.lean:56`).

**Documented asymmetry, no bug — retraction.** Rust `update_into` (`lib.rs:207`) falls
back to a full `updated.evaluate_into` restart when any new input is *worse* than the
old. Lean's `checkImprovementCertificate` (`IncrementalReflection.lean:29`) rejects any
worsening outright, so the Lean incremental route models only the improving branch;
`retraction_rejected` (`IncrementalChecks.lean:51`) is the right test for that. There is
no Lean theorem covering Rust's restart path, so certifying a retraction later needs a
new obligation rather than a reuse. Both reports say this.

**RISK (low) — `certified_rounds` after an incremental update.** `update_into` sets
`workspace.certified_rounds = updated.graph.inputs().len()`, i.e. `n`, rather than the
actual sweep count (`lib.rs:242` with an explanatory comment). A certificate serialized
after an incremental update therefore claims `rounds = n`. Today nobody pays: Lean's
`ergodis_improvement` discards the returned count entirely (`Oracle.lean:96`,
`let (_, values) ←`) and uses the caller's `replay k`. But any future caller that feeds a
post-update certificate into `ergodis_solution` gets the worst-case checking path —
21 kernel rounds for the four-vertex program, 43 for the chain — silently. Recording the
real sweep count on the Rust side removes the trap.

#### 5. Property tests worth adding on the Lean/Rust boundary

Each as generator / invariant / oracle. All should be committed as a generator plus a
generated fixture family with hashes, per `notes/research-reproducibility-conventions.md`.

**PROP-TEST P1 — round-convention identity.** *Generator:* random admitted sources,
domain 2–6, one binary input relation plus one unary derived relation, edge costs drawn
from `{0..20} ∪ {∞}` with roughly 30% absent, one `dist` seed. *Invariant:*
`rust_certificate.rounds` equals the least `k` at which Lean's iterate is fixed.
*Oracle:* emit each case as Lean asserting
`checkCertificate P r values = true ∧ checkCertificate P (r-1) values = false` by
`decide +kernel`. The second conjunct is the sharp half and is what actually pins the
convention — this is the test that catches the off-by-one conspiracy in section 4.
Around 50 cases is enough.

**PROP-TEST P2 — grounding correspondence.** This closes the largest unproved link in
the chain. Today `distanceProgram` and `chainDistanceProgram` are transcribed by hand,
and their agreement with the Rust grounding is confirmed only incidentally, by the fact
that a certificate elaborates at all. *Generator:* for a random admitted source, have
Rust emit its grounded program — the inputs vector and the product triples — as JSON.
*Invariant:* the emitted grounding equals the Lean `Program Cost n` built by a small
Lean-side importer over `nat_table_from_json`. *Oracle:* `decide +kernel` on
`P_imported = P_expected` for the two retained programs, and certificate acceptance
against `P_imported` for random ones. This turns "the grounding matches" from an
incidental consequence into a stated, checked claim.

**PROP-TEST P3 — Rust fixpoint equals Lean fixpoint on random scalar programs.**
*Generator:* random `Program Cost n` directly in the scalar syntax — `n ≤ 24`, up to 40
product rules, outputs and both factors uniform over `Fin n`, inputs from
`{0..1000} ∪ {∞}`. This reaches cyclic rules, nonlinear rules with `left = right`, and
rules whose output is also a factor, none of which the relational generator in P1
produces. *Invariant:* `rust_evaluate(P).values = List.ofFn (iterate boundedMinPlus P n)`.
*Oracle:* Lean `checkCertificate P n values = true` by `decide +kernel`. Note this needs
a raw grounded-program entry point on the Rust side that does not exist yet — worth
adding, since it is also the natural fuzzing surface for the evaluator.

**PROP-TEST P4 — saturation boundary.** *Generator:* costs drawn adversarially near
`2^31` and `2^32−1` so that `a + b` straddles `u32::MAX`, including chains that saturate
after two and three compositions, and the exact cases `a + b = 2^32 − 1` and
`a + b = 2^32`. *Invariant:* Rust `saturating_add` and Lean `costMul` agree on every
evaluated product, and the fixpoints are identical. *Oracle:* as P3.
`saturation_controls` (`ConvergenceChecks.lean:49`) is the hand-written seed of this
family; a single control misses both exact boundary values.

**PROP-TEST P5 — incremental replay count.** *Generator:* a random base program plus a
random pointwise improvement lowering a random subset of input costs. *Invariant:* the
smallest `k` for which `ergodis_improvement ... replay k` elaborates equals the number of
Rust sweeps in `update_into`, and `k ≤ min n (M+1)`. *Oracle:*
`checkImprovementCertificate P Q old k values = true ∧ ... (k-1) ... = false` by
`decide +kernel`. This pins the incremental convention the way P1 pins the from-zero one,
and it turns the C1168 bound into an executed claim rather than only a theorem.

**PROP-TEST P6 — rejection fuzzing at the elaborator.** *Generator:* take a valid
certificate and apply one random mutation — perturb a value by ±1, swap two values,
drop or duplicate an entry, decrement `rounds`, or re-target at a sibling program with
one input changed. *Invariant:* every mutation is rejected. *Oracle:* `#guard_msgs`
expecting "Ergodis certificate failed kernel replay". `OracleRejections.lean` has eight
hand-picked cases; a generated family of a few hundred would confirm operationally what
`CheckedSolution.eq_iterate` proves abstractly — that acceptance is exactly a singleton.

**PROP-TEST P7 — Budget-branch unreachability.** *Generator:* programs that maximize the
improving-sweep count for their size. `zeroChainProgram` is the extremal family, so:
random programs plus that chain at `n = 2..40`. *Invariant:* `propagate` never returns
`Err(Error::Budget)`, and the observed sweep count is at most `min(n, M+1)`. *Oracle:*
the Rust assertion, cross-checked against Lean `ruleOutputBound P` by `decide`. This is
the operational counterpart of C1168 and justifies tightening the Rust loop bound.

#### 6. Extensions, mysteries, suspicious constants

##### Cheap to close now

1. **EXT — make the axiom audit a gate.** `#guard_msgs in #print axioms ...` for all 79
   terminals. Converts the audit layer from a log into a build failure. Highest
   value-per-effort item here.
2. **EXT — add `lean/WeightedRules.lean`** importing every audit module and put
   `"WeightedRules"` in `defaultTargets` (`lakefile.toml:2`). One target then covers the
   library; today no single target builds all six audits.
3. **EXT — audit `chainDistanceBaseline`** and `chainDistanceBaseline_values` in
   `OutputConvergenceAxiomAudit.lean`. A live external witness currently unprinted.
4. **NIT — resolve `chainDistanceImprovedProgram`** (`ChainDistance.lean:38`). It is
   defined, described in the module docstring as the improved chain, and referenced
   nowhere in the tree. Either it is a leftover from the C1167 private paired
   measurement, in which case remove it and say so, or the warm-replay example belongs
   in this module.
5. **EXT — tighten the Rust budget** to `min(n, M+1)` and document the `Error::Budget`
   branch as provably unreachable, citing `boundedMinPlus_rule_output_fixed`.
6. **EXT — state the round-convention identity** in `docs/rule-contract.md`.

##### Generalizes for free

**EXT — the convergence theorem does not need min-plus.** Reading `Convergence.lean`,
the only properties the argument uses are: the carrier is finite and linearly ordered;
`add = min`; and multiplication is *inflationary*, `a ≤ a ⊗ b` for both factors
(`mul_left_cost` / `mul_right_cost`, lines 47-55). Nothing else about arithmetic enters.
So the same `n`-round theorem, the same `min n (M+1)` sharpening, and both sharpness
families carry over verbatim to any totally ordered idempotent semiring with an
inflationary product: bounded max-min (bottleneck / widest-path), bounded max-times with
factors in the unit interval, bounded min-plus over any linearly ordered monoid with
nonnegative elements. Abstracting `Convergence.lean` over a small
`LinearOrderedInflationaryAlgebra` structure is maybe an afternoon's work and makes the
whole C1165/C1168 layer reusable the moment a second carrier is admitted. I would queue
this ahead of implementing any second carrier, because doing it afterwards means
redoing the proof.

`separated_readouts_card_le` (`ReadoutMinimality.lean:19`) is already fully general — it
is Myhill–Nerode for a lowering square and knows nothing about privacy, weights or
min-plus. It will serve any future minimality claim unchanged.
`certificate_least`, `certificates_agree`, `relational_certificate_least`,
`lowering_iterate` and `symmetry_iterate` are already stated over an arbitrary
`ScalarAlgebra W`. Only the convergence layer is min-plus-specific.

##### Suspicious constants

- **Fifteen.** Not assessable from this repository; see section 1. The generic lower
  bound is sound and assumption-light, and the report's 16 − 1 explanation is coherent.
  Needs an independent read with private access.
- **`min n (M+1)`, and specifically the `+1`.** Fully settled, and settled well.
  `outputChain_requires_extra_round` (`OutputConvergenceSharpness.lean:84`) proves for
  *every* `M`, including `M = 0`, that the fact-loading round cannot be dropped. No
  residual mystery.
- **`n` = scalar count.** This is the constant that deserved more attention than it got.
  It is `Σ_r domain^arity_r + 1`; sixteen of the four-vertex example's twenty-one
  coordinates are immutable edge facts. C1168's `M`-bound is the right response, and the
  plain statement of the bound is "one more than the number of derived ground atoms
  appearing as a rule head", which is what `ruleOutputBound` computes. The residual
  looseness is that `M` counts derived atoms rather than the longest derivation chain:
  the six-vertex chain has `M+1 = 7` against a true stopping round of 6. I would *not*
  chase that. The uniform bound is provably sharp, and a per-program structural bound
  (longest path in the rule dependency graph) buys the checker nothing, since the
  producer already tells it the round count. C1165's ledger places this outside the
  allocated statement, correctly.
- **1 MiB, 4096 scalars, 65,536 table entries, 32-byte identity.** All pure admission
  limits; none is load-bearing for any theorem. Fine.

##### One mystery the ledgers should have

The design deliberately re-solves the problem inside the kernel. That is precisely why
the trusted base is as small as it is, and it is simultaneously a hard ceiling on scale:
checking cost equals solving cost, up to a constant. Neither the C1164 nor the C1168
mystery ledger lists this as an open boundary, though the integration note mentions it
twice in passing. It is the property that will decide whether this can front a real IR
workload, so it belongs in the ledger as the governing constraint on the next gate —
with the support-witness certificate of section 3 as the named escape route.

---

## Report C — ergodis-private and C1170 frontend (Opus, cold)

##### Cold review — `ergodis-private` @ 2026-09-12

Reviewer: senior Rust reviewer, read-only pass. Repo `/home/tavis/src/ergodis-private`,
branch `main`, HEAD `57a4eb9` at start and `cfae073` at finish. Core dependency
`/home/tavis/src/ergodis` inspected where the private code calls into it.

Working tree was DIRTY throughout and **changed substantially during the review**. Between my
first and second pass, `src/rel_frontend/` roughly doubled (`lexer.rs` 140 → 328 lines,
`parser.rs` 260 → 476, `diagnostic.rs` 86 → 237, `mod.rs` 184 → 325), `tests/rel_frontend.rs`
went from 8 tests to 11, and the whole C1170 frontend was then **committed as `cfae073`** while
the review was still running. Section B records both what the first pass found and what the
author fixed in between, because the fixed items say something about the shape of the remaining
ones. All section B citations are against `cfae073`, re-verified against that blob.

The other eight modified files (`analysis/campaign-console/mockups/*.mjs`,
`analysis/interface-review/*`) remain uncommitted and are summarized, not reviewed, in B.7.

Severity tags: **BUG** (wrong behaviour), **RISK** (correct today, fragile or unguarded),
**NIT** (style/clarity), **EXT** (extension opportunity), **PROP-TEST** (proposed property test).

Validation actually run during this review (target dir
`~/.cache/ergodis/target/ergodis-private` per `.cargo/config.toml`):

| Command | Result |
|---|---|
| `cargo test -p ergodis-private --test sparse_fault_search --release` | 7 passed |
| `cargo test -p ergodis-private --test privacy_lowering --release` | 2 passed |
| `cargo test -p ergodis-private --test rel_frontend` (first pass) | **7 passed, 1 FAILED** |
| `cargo test -p ergodis-private --test rel_frontend` (second pass, after author's edits) | 11 passed |
| `cargo clippy -p ergodis-private --lib --tests` | clean (4 pre-existing dead-code warnings in `tests/williamson_parallel_profile.rs`) |

---

#### 1. Headline findings

1. **BUG (C1170, committed in `cfae073`, still open)** — `a^b` does not lex as exponentiation. The
   `^`-prefix entity-reference rule swallows the operator, producing `Name("a"), Name("^b")`,
   and the whole definition is then rejected. `Kind::Power` is unreachable whenever the right
   operand starts with a letter or `_`. Re-confirmed on the current tree.
2. **BUG (C1170, committed in `cfae073`, still open)** — `0x1f` silently lexes as `Number("0") Name("x1f")`.
   This is inconsistent with the file's own discipline: `1_000` is now rejected with an explicit
   `UnsupportedSyntax`, but hex/binary/octal forms mis-tokenize silently instead.
3. **BUG (C1170, committed in `cfae073`, still open)** — `1e` produces a **zero-width** diagnostic span
   (`bytes 10..10`), which no caret-based renderer can highlight — and the file now *has* a
   caret renderer.
4. **RISK (committed, C1143)** — the sparse-vs-full A/B unit test infers which branch each
   `Plan` takes from an internal dispatch threshold that it never asserts. A threshold change
   silently degenerates the test to sparse-vs-sparse and it still passes.
5. **EXT (committed, C1143)** — the ~4–5% measured gain is capped *by construction*: the
   portable provider's 4,096-detector admission ceiling limits the syndrome bitmap to 63 words,
   which is ~250× smaller than the 1M-detector native domain the optimization actually targets.

Fixed by the author mid-review (first pass found them; second pass confirms they are gone):
the `value`-as-binder failure, `1_` and `1.0_0` acceptance, the missing allocation-count test,
and the missing caret column in diagnostics. Details in B.1 and B.6.

Everything else below is supporting detail.

---

#### A. Committed today

##### A.1 Sparse fault-frame selection — `5beb077` (C1143)

Files: `src/sparse_fault_search.rs:268-310` (new `frame::<SPARSE>`),
`src/sparse_fault_search.rs:350-378` (dispatch + `search_frames`),
`tests/sparse_fault_search.rs:446-527` (new test),
`analysis/external-benchmarks/2026-09-12-sparse-frame-selection.md`.

#### Ordering/result equivalence: verified correct

The mathematical claim holds. `syndrome = XOR` of the selected columns, so every set
syndrome bit lies in at least one column of the support; enumerating
`w.support[..weight]` → `self.detectors[c.ds..c.de]` and filtering on the live syndrome
bit therefore covers exactly the set the bitmap scan enumerates, with harmless duplicates.

Tie-breaking is genuinely equivalent, not approximately:

- Old path (`src/sparse_fault_search.rs:288-300`) scans `d` ascending and keeps `n < degree`,
  i.e. the **lowest** detector ID among minimum-degree detectors.
- New path (`src/sparse_fault_search.rs:281`) uses `n < degree || (n == degree && d < row)`,
  which is the same selection under an arbitrary enumeration order.

The support-prefix invariant that the new path depends on also holds at both call sites:

- `src/sparse_fault_search.rs:490` passes `weight = 1` immediately after
  `w.support[0] = root` (line 437) and the root toggle (line 438).
- `src/sparse_fault_search.rs:607` passes `weight = depth + 2`, and `w.support[weight-1] = added`
  is written at line 559 *after* `toggle` at line 558. Backtracking (lines 497–511) pops the
  frame without clearing `support`, but stale entries live only at indices `>= weight`, which the
  new loop never reads.

Degenerate case: an all-zero syndrome would leave both paths at `row = 0, degree = u32::MAX`,
so even that agrees — and it is unreachable anyway, guarded by `w.odd == 0` at lines 439 and 574.

Dispatch determinism across shards is fine: `search_impl` (line 360) branches only on
`w.syndrome.len()` and `w.frames.len()`, both shard-independent, so every worker
monomorphizes the same path and certificate replay is unaffected.

#### RISK — the A/B test does not assert which path each plan took

`tests/sparse_fault_search.rs:463-466` builds the "dense" plan with `detector_count = 13`
(1 syndrome word) and the "sparse" plan with `detector_count = 16_384` (256 words), relying on
`src/sparse_fault_search.rs:360` to route them differently. Nothing asserts that routing. If
`max_degree`, the factor `2`, or the radius bound changes, the two plans can land on the same
branch and the test still passes while proving nothing. This is the *only* in-repo A/B; the
committed benchmark A/B (`fault-continuation-bench.py --before <retained.so> --after <candidate.so>`)
does compare against a retained pre-change shared object, which is a genuine old-path oracle,
but it is not run by `cargo test`.

Fix: add a `pub(crate)`/`#[cfg(test)]` accessor returning the dispatch decision, and assert
`!dense.uses_sparse_frames(radius) && sparse.uses_sparse_frames(radius)` inside the loop.

#### RISK — dispatch threshold compares incommensurable units

`src/sparse_fault_search.rs:360`:

```rust
if w.syndrome.len() > 2 * w.frames.len() * self.max_degree as usize
```

The left side counts **sequential 64-bit word loads**; the right side bounds **random**
incidences, each costing one random `w.syndrome[d/64]` load plus two random `self.offsets`
loads. A sequential word load is far cheaper than a random one, so the crossover is optimistic
and the sparse path can be selected below its true break-even. This is consistent with the
report's own admission that ordinary-path instructions rise 0.4–0.6%. It is a tuning issue,
not a correctness issue; calibrate it with a measured constant rather than the literal `2`.

Secondary: the bound uses `w.frames.len()` (the declared radius), not the current `weight`.
At shallow depth the sparse scan is much cheaper than the bound assumes, so the estimate is
conservative in the right direction.

#### NIT — no allocation assertion on the control side

`tests/sparse_fault_search.rs` wraps only the *sparse* plan's calls in the
`COUNT`/`ACTIVE` allocation counter. The dense control runs unguarded. Cheap to symmetrize.

#### Evidence quality

`analysis/external-benchmarks/2026-09-12-sparse-frame-selection.md` is careful and
self-limiting: it states the 60M→12M external figure is not reproduced, reports the
252-detector wall times as noise (t = 0.95, −0.28), and declines the small-domain win.
The 4,032-detector paired ratios (0.9563, t = −4.09; 0.9575, t = −10.43) are properly paired
and interleaved. No overclaiming found.

---

##### A.2 Scheduling table parallelism — `8c6cff9` (C1130)

Files: `src/allocation_domain.rs:49-51, 110-131, 146-152, 169-181`,
`packages/scheduling-provider/Cargo.toml`,
`packages/execution-provider/src/lib.rs:854`.
Core kernel: `/home/tavis/src/ergodis/src/allocation_surface/parallel.rs`.

#### Data races and determinism: verified clean

`advance_build_parallel` (`/home/tavis/src/ergodis/src/allocation_surface/parallel.rs:82-115`)
gives each rayon task its own `Tile`, reads only the immutable `previous` layer, and merges
tiles back **serially in tile index order** (lines 110–115) before swapping layers. Tiles are
`#[repr(C, align(64))]` with a compile-time size assertion (lines 11–14), so no false sharing.

I checked the parallel kernel against the serial `advance_build`
(`/home/tavis/src/ergodis/src/allocation_surface.rs:292-326`) cell-for-cell:

- Both use strict `value > current` so the **first** option wins a tie; option order is
  preserved in both.
- The parallel `y` range is `b ..= width-1`, and `width = b + 1` is set at
  `/home/tavis/src/ergodis/src/allocation_surface.rs:232`, so it equals the serial `b ..= self.b`.
- `transitions` is accumulated in a serial pre-pass under the same `a <= self.a && b <= self.b`
  admission guard, so the counter matches exactly.
- Index safety: `cell - delta >= (x - a) * width >= 0` for every reachable cell; empty
  `lo..hi` ranges are well-defined.

So parallel results are bit-identical to serial, and certificate replay is unaffected.
Core carries the equality test (`/home/tavis/src/ergodis/tests/allocation_parallel_contract.rs`).

#### RISK — `parallel_workers()` reports the pool size at *read* time, not at build time

`src/allocation_domain.rs:146-152` returns `rayon::current_num_threads()` whenever
`self.parallel.is_some()`. The decision to go parallel is frozen in `new`
(`src/allocation_domain.rs:116-117`), but the reported count is sampled later, and this value
is serialized into the provider's telemetry envelope as `"parallel_workers"`
(`packages/execution-provider/src/lib.rs:854`). If the ambient pool differs between
construction, build, and readout — realistic under `wasm-bindgen-rayon`, where the pool is
initialized asynchronously — the retained evidence field can disagree with the work that was
actually done. Record the count observed at construction in the `Domain` instead.

#### RISK — `unreachable!` on a provider path

`src/allocation_domain.rs:178` has `_ => unreachable!("parallel scratch shape")`. It is
genuinely unreachable today (`surface` is never replaced after construction), but it sits
inside code reachable from the C-ABI provider entry point, where an unwind is at best an
abort. `assert!`-free `return Err(...)` is cheaper than reasoning about it.

Related: `/home/tavis/src/ergodis/src/allocation_surface/parallel.rs:63` has a bare
`assert_eq!(scratch.cells, cells)` on the same path.

#### NIT — dead constructor arm

`src/allocation_domain.rs:116` gates on `matches!(&surface, Table::Budget(_))`, so the
`Table::Count(s) => Some(ParallelTable::Count(...))` arm at line 123 can never run, and the
whole `ParallelTable::Count` variant is unconstructible. Either drop the variant or lift the
`Budget`-only gate and let the count axis parallelize too (the core already implements
`advance_build_parallel` for it at
`/home/tavis/src/ergodis/src/allocation_surface/count_axis.rs:215`).

#### RISK — no private-side serial/parallel equality test

`parallel-tables` is a non-default feature and nothing in `ergodis-private/tests/` exercises
`Domain::advance_build` under it. The equality guarantee rests entirely on the core crate's
test. A `#[cfg(feature = "parallel-tables")]` Domain-level differential test is cheap.

#### Memory accounting

`shape.workspace_bytes += scratch_bytes` (line 129) happens *after* the
`<= 64 * 1024 * 1024` check (line 119), which is correct because the check already adds
`scratch_bytes`. Scratch is sized per *cell count*, not per worker
(`parallel_workspace_bytes` = `cells.div_ceil(8192) * 24576`, ≈3 bytes/cell), so there is no
unbounded worker-count memory growth. Good.

---

##### A.3 Privacy lowering and fifteen-state minimality — `cc42f1b`, `5446efb` (C1162/C1166)

Files: `src/privacy_lowering.rs`, `tests/privacy_lowering.rs`,
`tests/privacy_lowering_oracle.py`, `lean/PrivacyLowering.lean`,
`evidence/2026-09-12-privacy-lowering.{json,md,sha256}`,
`evidence/2026-09-12-privacy-lean.{json,md}`.

#### Is "fifteen states" exhaustive or sampled? — **Exhaustive.**

The enumeration domain is fully closed and small:

- **Sources**: all 256 subsets of the 8 linear observations on `(s, t, r) ∈ F₂³`
  (`src/privacy_lowering.rs:128`, `(0u16..256)`). Bit `i` of the source selects the functional
  whose coefficient vector is the 3-bit expansion of `i`.
- **Events**: all 8 appends (`src/privacy_lowering.rs:73`).
- **Cells**: all 256 × 8 = 2,048 transitions, asserted as `checked_cells == 2048`
  (`tests/privacy_lowering.rs:31`) and re-derived independently in the oracle
  (`tests/privacy_lowering_oracle.py:46-58`).

The 15 comes from a Moore quotient computed at depth 1 and then *checked* to be a fixed point:
`readout_quotient` (`src/privacy_lowering.rs:82-124`) builds a 9-tuple signature per source
(its own leakage plus the leakage after each of the 8 events), quotients by signature equality,
and requires `synthesize` to return `Outcome::Square` — bailing otherwise
(`src/privacy_lowering.rs:107`). That is sound: the depth-1 partition refines the readout
partition, and if it is transition-closed it *is* the coarsest readout-preserving congruence.
No sampling anywhere.

The lower bound is likewise exhaustive, not representative: all `15 × 14 / 2 = 105` class
pairs get an explicit separating trace of length ≤ 1 (`src/privacy_lowering.rs:112-120`), and
the oracle asserts every pair is present and actually separating
(`tests/privacy_lowering_oracle.py:82-93`, `assert len(seen) == count * (count - 1) // 2`).
The Lean side (`BinaryPrivacy.privacy_summary_card_lower_bound`) turns those 15 pairwise-
distinguished representatives into an injection, so ≥15 holds for *any* deterministic summary
commuting with append, and the checked certificate attains it. The claim is correctly scoped —
it is about this finite 256-source model, not about unbounded observation families, and the
C1166 report says so.

#### Independence of the oracle: strong on semantics, weaker on encoding

`tests/privacy_lowering_oracle.py:13-24` recomputes each span by **physical assignment
fibers** — for each of the 8 assignments to `(s,t,r)`, which targets are constant on every
observation fiber — with no row reduction and no coefficient-span enumeration. That is a
genuinely different algorithm from the Rust `Matrix::canonical_row_basis` route
(`src/privacy_lowering.rs:23`). It also re-derives the certificate IDs from the raw tables
(lines 26–28, 58, 73).

**NIT**: the oracle re-derives `lowering` with `[summaries.index(v) for v in values]`, which is
the same "sorted-set index" convention as `src/privacy_lowering.rs:68-71`. The *semantics* are
independently checked; the *state-numbering convention* is shared. Not a defect, but the
evidence note should say so rather than implying full independence.

#### NIT — `& 0x0f` is doing real semantic work unannounced

`src/privacy_lowering.rs:131`, `leakages = spans.map(|span| span & 0x0f)`, intersects the
determined subgroup with `{0,1,2,3}` — exactly the functionals with zero `r` coefficient, i.e.
the leaked secret functionals. That is correct but reads as a bit-twiddle; one comment naming
"functionals independent of the mask `r`" would make the file self-checking.

#### Note — the source family includes the trivial observation

Row `0` is the zero functional, so sources `2k` and `2k+1` have identical spans and the
256-state model is really 128 distinct spans with a redundant generator. Harmless, and it
makes the domain literally "all subsets", but worth one line in the evidence note since a
reader counting states will notice.

No correctness defect found in this commit. `evidence()` runs `analyze(...)` 2,048 times with
per-call JSON construction, which is fine — the module header correctly labels this as cold
family admission, not a hot path.

---

##### A.4 Incremental replay evidence — `57a4eb9` (C1167)

Files: `lean/ChainColdReplay.lean`, `lean/ChainWarmReplay.lean`,
`scripts/benchmark_incremental_lean.py`,
`evidence/2026-09-12-incremental-lean-profile.{md,json,sha256}`.

#### Does the paired check compare against an independent oracle? — **Yes, in the proof sense.**

The two modules prove *the same two statements* about the same program by two independent
routes:

- `lean/ChainColdReplay.lean:20-32` constructs `CheckedSolution chainDistanceImprovedProgram`
  from the provider's from-zero replay (the pre-existing checker) and proves
  `IsLeastFixed chainDistanceImprovedProgram (listState solution.values)`.
- `lean/ChainWarmReplay.lean:20-32` constructs `CheckedImprovement chainDistanceBaseline
  chainDistanceImprovedProgram` with `replay 2` from the already-checked baseline and proves
  the same `IsLeastFixed` statement.

The oracle is the Lean kernel: `least` is the real gate, and the `decide +kernel` readout
`[0, 1, 2, 3, 4, 4]` is a redundant cross-check. Per the C1167 report the ABI adapter suite
additionally checks five distance fixtures against Floyd–Warshall, which is a third,
algorithmically independent oracle. This is well-constructed.

#### RISK — the harness rejects a *failed* case rather than recording it

`scripts/benchmark_incremental_lean.py:36-37` raises `RuntimeError` when either elaboration
fails, and lines 43–50 raise on any `error:`/`sorryAx` in stdout or an incomplete axiom audit.
That is the right acceptance behaviour, but it means a run that fails late produces no
retained evidence of the failure. Writing the partial JSON before raising would make the
negative reproducible.

#### NIT — sample size and the meaning of the 1.56×

Three interleaved pairs, reported as medians (4.68 s vs 7.30 s wall). The C1167 report is
explicit that this is proof-checking elaboration on a six-vertex chain and not a solver
speedup, and that the warm case reuses an already-compiled baseline — so the number is an
incremental-replay cost, not an end-to-end one. That framing is correct; just note that n = 3
supports "about 1.5×", not a tighter figure.

---

#### B. Uncommitted — C1170 Rel-rich frontend prototype

**Uncommitted when the review started; committed as `cfae073` ("Prototype bounded owned Rel
syntax pools and error-only diagnostics") before it finished.** That commit contains
`src/rel_frontend/{mod,lexer,parser,diagnostic}.rs`, `tests/rel_frontend.rs`, the one-line
`src/lib.rs` registration, and two new files this review had not seen in the working tree:
`analysis/rel-frontend/README.md` and `analysis/rel-frontend/coverage-v1.json` (the versioned
coverage manifest C1170 asks for — **not reviewed**, it appeared only at commit time).

All line citations below are against `cfae073`, and I re-verified the three open lexer bugs
against that blob directly. Every "fixed during review" item below was fixed *before* the
commit, so none of them is a defect in committed code.

##### B.0 Architecture verdict: the Ergodis boundary is respected

The prototype is syntax-only. `mod.rs:1` states "Parsing confers no execution authority";
there is no evaluator, no join, no rule lowering, and no semantic admission anywhere in
`src/rel_frontend/`. Constructs that would require backend semantics are *rejected* rather
than silently accepted: the parser returns `UnsupportedSyntax` for the
`bound/declare/value/entity/ic/with/from` declaration heads, and rejects `InterpolatedString`
with an explicit comment that nested interpolation "needs its own admitted production, not
opaque success". That is exactly the required discipline — backend and rules handling stay in
Ergodis.

Dependency surface is clean: the module pulls in nothing beyond `std`. Clippy is clean.

##### B.1 RESOLVED mid-review — contextual keywords in binder position

First pass: `tests/rel_frontend.rs` failed with
`Failure { start: 191, end: 196, code: ExpectedExpression, expected: Name }`. Bytes 191..196
were `value`, inside the Rel binder `sum[key, value: T(prefix...,key,value)]`. `"value"` lexed
unconditionally to `Kind::Value` and the parser then treated it as an unsupported declaration
keyword, so it could not appear as a name. The suite itself carried the workaround comment
*"`value` is a language keyword; use a legal name for the delimiter control"*
(now `tests/rel_frontend.rs:173`).

Second pass: fixed. `src/rel_frontend/parser.rs:454-455` now admits `Kind::Value`,
`Kind::Entity` and the rest of the soft-keyword set in primary-expression position, and the
test passes.

**Residual RISK**: the fix admits soft keywords *as atoms* while they are still lexed as
distinct `Kind`s (`lexer.rs:26`). Every new place that matches on token kind — argument lists,
qualified-name right-hand sides, module headers, future record fields — has to remember to
re-admit the whole set, and forgetting one reproduces this bug in a new position. The
structural fix is to lex them as `Kind::Name` and carry a `keyword_id` in the already-unused
`Token.flags`/`Token.reserved` fields, promoting to a keyword only in declaration-head
position. `Token` is `#[repr(C)]` with a `size_of == 16` assertion and both fields spare, so
this costs no representation change.

##### B.2 BUG (still open) — `a^b` never lexes as exponentiation

`src/rel_frontend/lexer.rs:210`:

```rust
if start(c) || (c == '^' && s[p + 1..].chars().next().is_some_and(start)) {
```

`^` followed by a letter or `_` is unconditionally absorbed into an identifier (the
entity-reference reading), with no whitespace sensitivity and no operator alternative.
Re-confirmed on the second-pass tree by running the parser:

```
def r = a^b  -> tokens [Def, Name(4..5), Equal, Name(8..9), Name(9..11), Eof]
             -> Err(ExpectedDeclaration @ 9..11)
def r = 2^3  -> tokens [..., Number, Power, Number, Eof]   (accepted)
```

So `Kind::Power` (precedence 19, right-associative, in the parser's `binary` table) is
reachable only when the right operand starts with a digit or `(`. The precedence test
`tests/rel_frontend.rs:31` (`def result = -2^3^4`) passes precisely because it uses digits, so
the suite does not catch this. Fix options, cheapest first: make `^` an entity prefix only
where no operand precedes it (expression-start position), or require that `^name` not be
preceded by a completed atom, or demand no whitespace before `^` and some after.

##### B.3 BUG (partly open) — number lexing

Re-verified on the second-pass tree:

| Input | Current behaviour | Status |
|---|---|---|
| `0x1f` | `Number("0")`, `Name("x1f")`, then `ExpectedDeclaration @ 9..12` | **open** — silent mis-tokenization |
| `1e` | error, span `10..10` | **open** — zero-width primary span |
| `a..b` | `Dot`, `Dot` | open — no range operator |
| `a == b` | `Equal`, `Equal` | open — `==` missing from the compound table |
| `1_` | `UnsupportedSyntax @ 8..10` | fixed during review |
| `1.0_0` | `UnsupportedSyntax @ 8..12` | fixed during review |
| `.5e4` | accepted | added during review |

Two things to say about the open items.

**The `0x1f` split is now an inconsistency, not just a gap.** `lexer.rs:238-240` deliberately
*rejects* `1_000` with an explicit `UnsupportedSyntax`, which is the right discipline: an
unimplemented literal form should be named, not silently reinterpreted. Hex, binary and octal
literals get no such treatment and instead decompose into a `Number` and a `Name`, so the
failure surfaces later and somewhere else. One `bytes.get(p)` check for `x`/`X`/`b`/`o` after
a leading `0`, returning `UnsupportedSyntax` over the whole run, makes the two cases agree.
(Rejecting `1_000` outright is itself a coverage regression worth tracking in the manifest —
digit separators are ordinary in Rel sources — but "reject loudly" is the correct interim state.)

**The zero-width span now matters more than it did.** `lexer.rs:251` reports
`bad(ErrorCode::UnexpectedCharacter, digits, p)` where `p == digits` by construction, so the
primary label is empty. The diagnostic layer gained a real caret renderer during the review
(`diagnostic.rs:29-30`, `caret_column`/`caret_width`), and a zero-width span renders a
zero-width caret. Report `(a, p)` — the whole malformed numeric — instead.

On "number overflow silently wrapping": **not present**. `Kind::Number` records only a byte
span; no value is parsed, so nothing can wrap in the lexer. The overflow risk moves to whichever
later stage converts the span, and that stage does not exist yet — worth pinning in the coverage
manifest before it is written, since that is exactly where a silent wrap would appear.

Missing compound operators beyond the table above: `->`, `<-`, `|>`, `&&`, `||`, `**`, and
nested block comments. The compound table is also an eight-entry linear `starts_with` scan run
for every punctuation token; a first-byte dispatch table is free to write and removes it from
the scan loop.

##### B.4 Panic / unbounded-recursion audit: clean, but invariant-only

- **Malformed UTF-8 cannot reach the lexer.** `Workspace::parse_variant` takes `&[u8]`,
  enforces `source_bytes` and `< u32::MAX` (so the `u32` token offsets cannot truncate), then
  `std::str::from_utf8` with a proper `ErrorCode::InvalidUtf8` diagnostic carrying
  `valid_up_to()` and `error_len()`. The lexer only ever sees valid UTF-8. Right design, and
  tested (`tests/rel_frontend.rs:167`).
- **`character::<BYTE_SCAN>` would panic on a non-boundary index** via `s[p..]`. I traced every
  mutation of `p` in `scan`: each advance is either `+= c.len_utf8()` from a boundary, or
  `+= 1` past a known ASCII byte (`\\`, quote, digit, `/`, `*`). The invariant holds, but it is
  maintained by inspection only — there is no `debug_assert!(s.is_char_boundary(p))` anywhere
  in `lexer.rs`. One `debug_assert` at the top of the scan loop makes it self-checking, and the
  no-panic property test in section 4 then actually exercises it.
- **Deep nesting does not recurse.** The parser replaces recursive descent with an explicit
  bounded continuation stack (`Frame`, `#[repr(C)]`, `size_of == 32` asserted); `Parser::push`
  returns `DepthCapacity` instead of growing, and `Workspace::new` pre-reserves every buffer
  with `try_reserve_exact`. Tested at `tests/rel_frontend.rs:158`. This is the strongest part of
  the prototype and the thing most worth keeping as the frontend grows.
- **`Parser::token()` (`src/rel_frontend/parser.rs:78`) indexes without bounds checking.** I
  audited every `self.pos +=` site (currently `parser.rs:132, 147, 187, 200, 226, 233, 251, 275`);
  each either guards on a non-`Eof` kind or checks `tokens.get(pos+1)` first, and
  `parser.rs:147` deliberately does not advance past `Eof`. So `pos` never passes the
  terminating `Eof` token. Correct-by-invariant with no assertion — again exactly what the
  no-panic property test should pin down, since this invariant now has eight sites to preserve
  and the file is growing fast.
- **`unreachable!("private continuation tag")` (`src/rel_frontend/parser.rs:363`)** is
  unreachable but is a panic in library code; prefer returning a `Failure`.

##### B.5 Diagnostics vs. the C1170 quality bar

C1170 asks for "Rust/iidy-hs-quality context, primary/secondary spans, IDs and useful fixes".
Delivered: stable `REL####` IDs, primary + secondary spans, targeted help strings, line/byte-column
notes, a separate `render()` a UI can replace, and — added during this review — a real caret
row with `caret_column`/`caret_width` (`diagnostic.rs:29-30`), control-character escaping, and
an explicit `…` marker on truncated excerpts (`diagnostic.rs:49, 81`). That closes most of
what the first pass flagged. Remaining gaps:

- **Secondary span is one byte wide.** `diagnostic.rs:154-155` sets
  `end: failure.related.saturating_add(1)`, which truncates any multi-byte opener and, more
  usefully, throws away the opening *token's* extent. `Failure.related` currently carries only
  a start offset; widening it to the opener's token span would let the caret renderer underline
  `(` … `[` correctly in the secondary label too.
- **A zero-width primary span still reaches the caret renderer** — see B.3, the `1e` case.
  Now that a caret exists, this renders as a caret of width zero.
- **No applicable fixes**, only prose help. Acceptable for a prototype; note it in the manifest
  so it is a decision rather than an omission.

Coverage contract status against `notes/2026-09-12-c1170-owned-rel-frontend.md`: Unicode
operators, qualified names, partial application, varargs/spread, nested modules, raw and
triple-quoted strings, `@`-annotations, character literals, escape sequences and leading-dot
floats are all exercised. Interpolation is explicitly *rejected*, which the scope permits as a
labelled omission. Operator precedence is exercised but, per B.2, the `^` row is untested
exactly where it breaks. The contract's real outstanding misses are `^` as a binary operator,
non-decimal integer literals, and digit separators.

##### B.6 Performance contract — `/home/tavis/src/ergodis-contrib/PERFORMANCE.md`

The relevant rule is PERFORMANCE.md:29-31: every new hot-path kernel needs an
**allocation-count test**, and "only once"/"amortized" do not qualify.

- **RESOLVED mid-review — the allocation-count test now exists.** First pass found none, which
  was the clearest PERFORMANCE.md gap in the new code. Second pass has
  `repeated_success_and_compact_failure_do_not_allocate` (`tests/rel_frontend.rs`), which runs
  100 iterations of one successful parse plus two failing parses inside a tracked allocator and
  asserts `allocations == 0` *and* `retained_bytes()` unchanged. That is the right shape —
  it covers the failure path too, which is where a diagnostic `String` would otherwise leak
  into the compact path.
- The design holds up: `try_reserve_exact` up front, explicit capacity checks instead of growth
  in `emit`/`push`/`node`, byte-range tokens that borrow rather than copy, and
  `const _: () = assert!(size_of::<Token>() == 16 ...)` stride assertions on `Token`, `Node`,
  `Failure` and `Frame`, matching PERFORMANCE.md:92-101.
- Owned `String`s appear only on the `enrich` diagnostic path, which `mod.rs:4` documents as
  intended and the allocation test now pins.
- **RISK — default workspace is ~20 MiB.** `Limits::default()` is `tokens: 1<<18`,
  `nodes: 1<<19`, i.e. 4 MiB + 16 MiB reserved eagerly regardless of input size. Fine for a
  long-lived reused workspace — and the allocation test proves reuse is the intended mode — but
  expensive for a one-shot parse. Either document reuse as mandatory or scale the defaults from
  `source_bytes`.
- **NIT** — `enrich` counts newlines over the whole prefix on every diagnostic (O(n));
  acceptable on the error path only, and it is on the error path only.

##### B.7 Other uncommitted files (summary only, as requested)

Three lines, no deep review:

1. `analysis/interface-review/adr-shared-memory-execution-and-telemetry.md` gains a "Layered
   dynamic programs" section recording the C1130 decisions as architecture: parallelize tiles
   within a layer, keep layers sequential, presized aligned tiles, deterministic post-join
   copy, scratch counted against workspace limits, and keep the scalar path for small problems.
2. The five `analysis/campaign-console/mockups/*.mjs` files plus
   `analysis/interface-review/thread-runtime.test.mjs` are small edits to the browser
   shared-memory thread-runtime mockups (broker, module worker, evolve runner/view), mostly
   pool lifecycle and telemetry plumbing matching that ADR text.
3. `analysis/interface-review/package-css-thread-runtime.py` is a one-line packaging change.

---

#### 4. Property-based tests to add

**`proptest` is NOT a dependency of `ergodis-private`.** Its `[dev-dependencies]` are only
`rayon` and `ergodis-runtime`. It *is* already a dev-dependency of the core crate
(`/home/tavis/src/ergodis/Cargo.toml:47`, `proptest = "1"`) and of
`/home/tavis/src/ergodis/crates/runtime/Cargo.toml:25`, with existing users at
`/home/tavis/src/ergodis/tests/observable_properties.rs` and
`/home/tavis/src/ergodis/crates/rules/tests/properties.rs`. So the convention exists; adding
`proptest = "1"` to `ergodis-private`'s `[dev-dependencies]` introduces no new
third-party surface, and `Cargo.toml:20` of the core already excludes `proptest-regressions/`
from packaging — mirror that.

Ordered by value.

##### PROP-TEST 1 — `sparse_frame_selection_matches_full_scan` (highest value)

- **Generator**: `detector_count in 1..64usize`, `logical_count in 1..4`,
  `faults: vec(vec(0..detector_count as u32, 0..6), 1..24)`, plus
  `radius in 1..=6` and `shards in 1..=4`. Build the same `Source` twice, once with the
  generated `detector_count` and once with `detector_count = 16_384` to force the sparse path.
- **Invariant**: `dense.search_x(shard) == sparse.search_x(shard)` on
  `(status, candidates, roots)` **and** `a.witness() == b.witness()`, for
  `search`, `search_terminal`, and `search_indexed`.
- **Function exercised**: `Plan::frame::<SPARSE>` via `Plan::search_impl`
  (`src/sparse_fault_search.rs:268`, `:360`).
- **Oracle**: the unmodified bitmap branch (`src/sparse_fault_search.rs:288-300`), reached by
  the small-domain plan.
- **Note**: pair it with a dispatch assertion (see the RISK in A.1), otherwise the property can
  silently compare a path against itself.

##### PROP-TEST 2 — `frame_selection_picks_min_degree_then_min_id`

- **Generator**: same plan generator, plus an arbitrary reachable support prefix.
- **Invariant**: for the frame's chosen `row`,
  `(offsets[row+1]-offsets[row], row) == min over { d : syndrome bit d set }` of
  `(offsets[d+1]-offsets[d], d)`.
- **Function exercised**: `Plan::frame::<true>` and `Plan::frame::<false>`.
- **Oracle**: a naive `(0..detector_count).filter(bit set).min_by_key(...)` written in the test.
- **Why**: this pins the *specification* rather than one implementation against another, so it
  survives a future rewrite of both branches.

##### PROP-TEST 3 — `lexer_never_panics_on_arbitrary_bytes`

- **Generator**: `proptest::collection::vec(any::<u8>(), 0..4096)`, biased with a second
  strategy that concatenates random slices of a Rel keyword/operator/quote corpus
  (`"raw\"", "\"\"\"", "/*", "//", "\\", "%", "^", "…", "⊗", "1e", "0x"`), since pure random
  bytes almost never reach the interesting branches.
- **Invariant**: `Workspace::parse(&bytes)` returns `Ok` or `Err`, never panics, and on `Err`
  satisfies `failure.start <= failure.end <= bytes.len()`.
- **Function exercised**: `Workspace::parse` → `lexer::scan` → `parser::parse`.
- **Oracle**: absence of panic plus the span well-formedness predicate. Strengthen the predicate
  to `failure.start < failure.end || failure.start == bytes.len()` and it catches the
  zero-width `1e` span (B.3) directly. It also pins the `p`-is-a-char-boundary and
  `pos <= eof_index` invariants of B.4, which currently have no assertion anywhere.
- **Why now**: `tests/rel_frontend.rs` already contains a hand-rolled degenerate version —
  `every_truncation_is_bounded_and_reusable` parses every prefix of one fixture. Generalizing
  that from one string to a generator is the smallest possible step to a real fuzz.

##### PROP-TEST 4 — `lexer_position_monotonicity_and_tiling`

- **Generator**: any UTF-8 `String` (`proptest::string::string_regex(".{0,2000}")` plus the
  keyword corpus above), parsed until first success or lexer error.
- **Invariant**: for consecutive tokens, `t[i].start <= t[i].end <= t[i+1].start`, every
  `start`/`end` is a `char_boundary` of the source, the final token is `Eof` with
  `start == end == source.len()`, and the concatenation of token spans plus the inter-token
  gaps (whitespace and comments only) reconstructs the source exactly.
- **Function exercised**: `lexer::scan::<true>` and `::<false>`.
- **Oracle**: the source string itself — the gaps must contain nothing but whitespace, `//…`,
  and `/*…*/`.
- **Why**: this is the real "no token is silently dropped" check, and it would catch the
  `0x1f` split (B.3) as an anomalous `Number`/`Name` adjacency with a zero-width gap.

##### PROP-TEST 5 — `lexer_round_trip_through_rendered_text`

- **Generator**: build a random *token sequence* from the `Kind` alphabet (not random text),
  render each token to canonical text joined by a single space.
- **Invariant**: `kinds(scan(render(ts))) == ts ++ [Eof]`.
- **Function exercised**: `lexer::scan` plus a new `Kind::spelling()` renderer.
- **Oracle**: the generated token sequence.
- **Why**: this is the direct probe for B.2 — `[Name("a"), Power, Name("b")]` renders as
  `a ^ b`, which re-lexes as `[Name, Name]` and fails. Space-joined rendering will *hide* the
  bug (`a ^ b` lexes fine since `^` is followed by a space); run a second variant with no
  separator wherever the pair is unambiguous, which is where the defect surfaces.

##### PROP-TEST 6 — `byte_scan_and_scalar_variants_agree`

- **Generator**: arbitrary bytes and arbitrary UTF-8 strings, as above.
- **Invariant**: `parse_variant::<true>(b) == parse_variant::<false>(b)` on the `Result`, the
  full `tokens()` slice, and `fingerprint()`.
- **Function exercised**: `Workspace::parse_variant` (`mod.rs:147`).
- **Oracle**: each variant is the other's oracle.
- **Why**: `exact_variant_agreement_including_failures` already does this over a fixed list of
  hand-written cases, and `every_truncation_is_bounded_and_reusable` over prefixes of one
  string. Promoting both to a property is a two-line change and covers the module's own claim
  ("Both variants emit exactly the same token/node representation and errors") for real. The
  `BYTE_SCAN` fast path diverges from the scalar path exactly on non-ASCII input, which is where
  a fixed case list is weakest.

##### PROP-TEST 7 — `privacy_lowering_quotient_is_the_coarsest_congruence`

- **Generator**: `source_mask in any::<u8>()`, `event in 0u8..8`, and arbitrary event *words*
  `vec(0u8..8, 0..6)`.
- **Invariant**: `lowering[a] == lowering[b]` implies
  `lowering[apply(a, w)] == lowering[apply(b, w)]` **and**
  `spans[apply(a,w)] & 15 == spans[apply(b,w)] & 15`, for every generated word `w` — i.e. the
  depth-1 quotient really is a congruence at all depths, not just depth 1.
- **Function exercised**: `privacy_lowering::joint_span` and `readout_quotient`'s `lowering`
  (`src/privacy_lowering.rs:17`, `:82`).
- **Oracle**: the Python physical-assignment `determined()` reimplemented in Rust for the test,
  or the committed `evidence/2026-09-12-privacy-lowering.json` tables.
- **Why**: `synthesize` currently checks one-step closure; this checks the multi-step
  consequence directly and would catch a regression in `Outcome::Square` detection.

##### PROP-TEST 8 — `joint_span_is_a_subgroup`

- **Generator**: `source in any::<u8>()`.
- **Invariant**: `let s = joint_span(source); s & 1 != 0` (contains 0) and for all `x, y` in
  the mask, `x ^ y` is in the mask; additionally `s.count_ones().is_power_of_two()`.
- **Function exercised**: `privacy_lowering::joint_span` (`src/privacy_lowering.rs:17`).
- **Oracle**: the closure axioms themselves.
- **Why**: `src/privacy_lowering.rs:179` already relies on `count_ones().ilog2()` being the
  rank, which is only meaningful if the mask is a subgroup. Cheap, and it makes an implicit
  assumption explicit. (This one is exhaustive over 256 inputs — worth writing as a plain
  loop rather than as proptest.)

##### PROP-TEST 9 — `parallel_table_build_equals_serial` (private-side)

- **Generator**: random `maxima` (2 dimensions, each `2..64`), random families
  (`1..16` families × `1..8` options with `a`, `b` inside the maxima), and
  `jobs_per_advance in 1..8`.
- **Invariant**: for the same source, `Domain` built with `parallel: Some(..)` and with
  `parallel: None` produce identical `maxima()`, `table_layout()`, `transitions()`,
  `completed_jobs()`, and identical `query()` results over every capacity vector.
- **Function exercised**: `allocation_domain::Domain::advance_build`
  (`src/allocation_domain.rs:169`) under `--features parallel-tables`.
- **Oracle**: the serial `Table::advance_build` path.
- **Why**: closes the gap in A.2 — the equality is currently only tested at the core
  `AllocationSurface` level, never at the `Domain` level that the provider actually calls, and
  never with the `rayon::current_num_threads() > 1` and `cells > 8_192` gates in play.
  Run it under `RAYON_NUM_THREADS` set to 1, 2, and 8 to also pin worker-count invariance.

---

#### 5. Extensions, mysteries, and open doors

##### 5.1 Why is the sparse-frame gain only ~4–5%? — answered, and it is a measurement ceiling

The report (`analysis/external-benchmarks/2026-09-12-sparse-frame-selection.md:96-100`) leaves
this open. The arithmetic closes most of it:

The optimization replaces a scan of `syndrome.len()` **sequential** 64-bit words with at most
`weight × max_degree` **random** incidence probes. Its advantage is therefore roughly linear in
detector count. The measured control tops out at 4,032 detectors = **63 syndrome words**; the
native kernel admits **1,000,000** detectors = **15,625 words**, ~250× more. The control was
chosen at 4,032 because the *portable* provider caps admission at 4,096 coordinates
(`:45-48` of that report — a 64× spacing probe was correctly rejected), not because 4,032 is
where the optimization matters.

Second factor: `frame()` is called once per *descent*, while the measured workload is
4,761,457 candidates over 2,232 roots. Most instructions are in the `incident[f.next]`
candidate loop and `toggle`, not in frame selection. So even a large per-frame saving is
diluted by Amdahl.

Both effects point the same way, and the measurement agrees: instructions fell 3.4%/3.1% while
branch misses fell 18%/16% — a large relative improvement in a small slice of the work.

**Consequence for what to do next**: the 4–5% number should not be used to size the
optimization. Either (a) run the bench directly against the native kernel at 10⁵–10⁶ detectors,
bypassing the portable provider, which the report already notes "exercises the kernel directly";
or (b) raise the portable admission ceiling as its own task. Without one of these, the
60M→12M external claim stays unaddressable. This is the single highest-value follow-up in the
committed scope.

##### 5.2 Cheap upgrades now in reach

1. **Dispatch assertion + calibrated threshold** (A.1). A `#[cfg(test)]` accessor makes the
   existing A/B test meaningful and enables PROP-TEST 1. Replacing the literal `2` in
   `src/sparse_fault_search.rs:360` with a measured constant is a one-line change once (5.1a)
   gives real large-domain data.
2. **Use `weight`, not `radius`, in the dispatch estimate.** The bound is currently computed
   once per `search` call from the declared radius. A per-frame decision is too expensive, but
   a per-*root* one is not, and the average weight is far below the radius.
3. **Parallelize the count axis** (A.2 NIT). `advance_build_parallel` already exists for `u64`
   in `/home/tavis/src/ergodis/src/allocation_surface/count_axis.rs:215`; only the
   `matches!(&surface, Table::Budget(_))` gate blocks it. This is a measured-A/B-sized task,
   not a design task.
4. **Contextual keywords via `Token.flags`** (B.1). `Token` already carries unused `flags: u16`
   and `reserved: u32` fields and a `size_of == 16` assertion with room to spare. Lexing soft
   keywords as `Kind::Name` with a `keyword_id` in `flags` removes a whole class of "forgot to
   re-admit the keyword set in this position" bugs, of which the `value`-as-binder failure was
   the first instance.
5. **Reject unimplemented literal forms loudly** (B.3). `1_000` already returns
   `UnsupportedSyntax`; extending the same treatment to `0x`/`0b`/`0o` is a three-line change
   and converts a silent mis-parse into a named diagnostic.

##### 5.3 Mysteries still open

- **The 60M→12M external decline is still unattributed.** The bounded control demonstrates a
  4–5% gain and cannot reach the regime where the claim lives (5.1). Owning task: C1143, gated
  on either a direct native-kernel bench or a raised portable admission limit.
- **Why does the ordinary (dense) path cost 0.4–0.6% more instructions after the change?**
  The report flags it and declines a zero-overhead claim, which is right. The likely cause is
  monomorphization pressure: `search_frames` is now instantiated over four `const bool`
  parameters instead of three, doubling code size and I-cache footprint for a function that
  already has three specializations. Worth confirming with a `--emit asm` size comparison
  before adding a fifth const parameter to that function.
- **Is the fifteen-state bound tight for *any* source encoding, or only for this one?** The
  Lean lower bound is representation-independent given the readout, and the C1166 report says
  so explicitly. What remains unmeasured is whether a *different* choice of the 8 generating
  observations (the current family includes the trivial functional, so 256 sources collapse to
  128 distinct spans) changes the count. Cheap to check exhaustively; would either strengthen
  the claim to "for every generating set" or expose an interesting dependence.

##### 5.4 Doors this opens

- The `frame::<SPARSE>` pattern — *derive the active index from already-valid state rather
  than maintaining a separate index* — applies unchanged to any bitmap-scan-then-select loop
  in the search kernels. The report already frames it as "a general kernel optimization
  available before Evolve", which is the right framing: it is a representation win, not a
  discovered reduction, and should not be credited as one.
- The tile-parallel layered DP in
  `/home/tavis/src/ergodis/src/allocation_surface/parallel.rs` is bit-exact with its serial
  form, which means it is safe to use *inside* certificate-producing runs, not only in
  telemetry-only builds. That is a stronger property than the ADR text currently claims and is
  worth stating explicitly, because it is what lets parallel scheduling appear in a replayable
  certificate at all.
- The `CheckedImprovement` → `CheckedSolution` conversion (C1167) gives a warm-replay proof
  that is interchangeable with a cold one at the type level. Combined with the ~1.5×
  elaboration measurement, the obvious next door is a *chain* of improvements where each step
  seeds the next — the report's `iteratedImprovement` already establishes existence for every
  admitted improvement, so only the harness is missing.

---

#### Summary table of actionable items

Open as of the second pass:

| # | Sev | Location | Item |
|---:|---|---|---|
| 1 | BUG | `src/rel_frontend/lexer.rs:210` | `a^b` lexes as `Name Name`; `Kind::Power` unreachable for identifier operands |
| 2 | BUG | `src/rel_frontend/lexer.rs:222` | `0x1f` silently splits into `Number` + `Name` while `1_000` is loudly rejected |
| 3 | BUG | `src/rel_frontend/lexer.rs:251` | `1e` reports a zero-width span; the new caret renderer draws a zero-width caret |
| 4 | RISK | `tests/sparse_fault_search.rs:463` | A/B test never asserts the two plans took different dispatch branches |
| 5 | RISK | `src/sparse_fault_search.rs:360` | Dispatch threshold compares sequential words to random probes |
| 6 | RISK | `src/allocation_domain.rs:146` | `parallel_workers()` samples the pool at read time; value goes into retained telemetry |
| 7 | RISK | `src/allocation_domain.rs:178` | `unreachable!` on a path reachable from the C-ABI provider entry |
| 8 | RISK | `ergodis-private` tests | No `Domain`-level serial/parallel equality test under `parallel-tables` |
| 9 | RISK | `src/rel_frontend/lexer.rs`, `parser.rs:78` | Char-boundary and `pos <= eof` invariants held by inspection, with no assertion |
| 10 | NIT | `src/allocation_domain.rs:116-123` | `ParallelTable::Count` variant is unconstructible |
| 11 | NIT | `src/rel_frontend/diagnostic.rs:154-155` | Secondary label is one byte wide; `Failure.related` carries no token extent |
| 12 | NIT | `src/rel_frontend/parser.rs:363` | `unreachable!` in library code; prefer a `Failure` |
| 13 | NIT | `src/lib.rs` | `pub mod rel_frontend;` inserted out of alphabetical order |
| 14 | EXT | C1143 | Re-run the bench against the native kernel at 10⁵–10⁶ detectors, or raise portable admission |

Closed by the author during the review: `value`-as-binder rejection, `1_`/`1.0_0` acceptance,
the missing allocation-count test, the missing caret row, and silent excerpt truncation.
