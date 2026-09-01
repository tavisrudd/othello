# C1030 — ergodis audit: root-cause synthesis across five reports

**Task**: C1030 · **Lane**: `complete-ports` · **Scope**: cross-report root-cause analysis. No code changes.

## Source reports

| Pass | Scope | Report |
|------|-------|--------|
| 1 | Core `ergodis` library crate | `notes/2026-08-31-c1030-ergodis-audit-core-library.md` |
| 1 | `ergodis-private` search/enumeration engines | `notes/2026-08-31-c1030-ergodis-audit-search-engines.md` |
| 1 | Certificate, evidence, and CLI plane | `notes/2026-08-31-c1030-ergodis-audit-certificates-io.md` |
| 1 | Free choice — shared trust kernels, git visibility | `notes/2026-08-31-c1030-ergodis-audit-freehunt.md` |
| 2 | Vetting of all pass-1 findings, shape sweep, generators | `notes/2026-08-31-c1030-ergodis-audit-freehunt-pass2.md` |
| R2 | Reduction/quotient/modular-descent math | `notes/2026-08-31-c1030-round2-reduction-math.md` |
| R2 | Core-crate remainder and unaudited private modules | `notes/2026-08-31-c1030-round2-core-remainder.md` |
| R2 | Binaries, test suite, python checkers, replay commands | `notes/2026-08-31-c1030-round2-bins-tests-checkers.md` |
| R2 | Free choice — engines lane, additive-composition sweep | `notes/2026-08-31-c1030-round2-freehunt.md` |

Twenty findings were raised across the four pass-1 reports. The pass-2 vetting confirmed
thirteen sibling findings against the code, refuted one outright, corrected three severities
downward by one notch, and added two new findings. The register below lists every one with its
post-vetting severity; the sections after it ask what generates them.

## Findings register

Severity is the post-vetting value. Two pass-1 findings were raised independently by two agents
and appear once here. Locations are working-tree paths; see RC4 on why most cannot be pinned to a
commit.

| # | SEV | Finding | Location | Cause |
|---|-----|---------|----------|-------|
| 1 | 1 | `certdist verify` reports "certificate verified" with every witness unchecked: `--input` is optional, the `None` arm pushes nothing into `failures`, the bracket is "recomputed" by calling the prover's own `build_bracket`, and a toolchain mismatch is a `println!` only | `certdist.rs:1470-1478`, `:2028-2032`, `:2260-2262`, `:1299`/`:2144`, `:2176-2180` | RC3 |
| 2 | 1 | `certiis` instance fields default to a load-bearing value (`demand`/`capacity` = 1, `couplings` = `[]`) with no `deny_unknown_fields`; verify re-reads through the same deserializer and the raw-bytes digest still matches, so a misspelled container key silently causes a regime misclassification that hashes correctly | `certiis.rs:39`, `:53`, `:107-108` | RC3 |
| 3 | 2 | `Matrix::row_space_contains_field` used the presented row count as rank, so a rank-deficient matrix could accept a candidate outside its row space or reject one inside. **Resolved in `bf3d9e955`:** containment canonicalizes the source first, records the actual basis rank, and has direct redundant-row inside/outside regressions. | `matrix.rs` | own |
| 4 | 2 | The additive delta join in the g53 multi-move repairs is wrong for same-block moves: `repair_moves_compatible` returns `true` for same-block moves with disjoint orbit sets, but disjoint support kills only the shift-0 cross term. `finish_q4_repair` then returns `Err` without restoring the shell, aborting the whole q4 selection repair and discarding genuine repairs later in the enumeration | `g53_search.rs:2081-2101`, `:726-748`, `:822-834`, `:2149-2153` | own |
| 5 | 2 | The committed tree does not build: 9 of 20 modules declared at HEAD exist only as untracked files, and committed notes cite replay binaries buildable from no commit | `ergodis-private/src/`, `Cargo.toml` | RC4 |
| 6 | 2 | `solve_sorted_square_sum` sums squares in unchecked `u32`, so release-mode wraparound can forge a solution for targets above `2^32/8`; `integer_square_root(u32::MAX)` loops forever. Its sibling `solve_bounded_linear_combination` in the same file uses `checked_add`, and prover and verifier share the defective kernel. *(Found independently by two agents.)* | `proof_synthesis.rs`; `reduction_proof.rs:342`, `:511` | RC1, RC2, RC3 |
| 7 | 2 | `scout_g41_q29_seed_power` rescores one arbitrary preimage per modular state: `insert_with_value` keeps the first value per state, the right-hand scan breaks on first match, and `exact_residual`/`full_paf_hit` are then computed from that single arbitrary fibre member | `g41_q29_evolve.rs:370-387`, `:2321-2335`, `:2353-2356` | own |
| 8 | 2 | `certiis` writes wall-clock timings into the certificate (making it irreproducible byte-for-byte) and overwrites evidence in place via unconditional `fs::write` with a swallowed `create_dir_all` error | `certiis.rs:508-510`, `:718-736`, `:1699-1706` | RC1 |
| 9 | 3 | `GeneratedSpanTable::build` enumerates subspaces with no cap, stores each state twice, and fails by process abort rather than an error under `panic = "abort"`. **Resolved in `8bd0969a6` and `2e4246ebf`:** the public builder has positive default caps and typed resource errors; an arena-backed hash/collision-chain index now retains each unique projective column and canonical basis payload exactly once. Forced-collision replay and exact payload-limit tests pass. | `span.rs`, `arena.rs` | RC2 |
| 10 | 3 | Mod-16 dense pair keys are 8,200 bytes each, retained per class, against a 255-signature `u8` wall | `g133_sparse_defect.rs:224-226`, `:1499-1501` | RC2 |
| 11 | 3 | The q23 Hall evidence has no recorded hashes, no replay command, and no graph-to-certificate binding: `evidence/SHA256SUMS` has 13 rows, none matching the 7 q23 files present | `ergodis-private/evidence/` | RC4 |
| 12 | 4 | Generic `ProjectiveIndex::new` computes one block past the last it pushes, spuriously rejecting the largest representable geometry — PG(7,256) errors although its point count fits in `u64`, while the binary sibling accepts it. The grounded residue of the refuted finding below. **Resolved in `f6ac64c4f`:** multiplication now occurs only when another stored block is required; PG(7,256) constructs and PG(8,256) still rejects. | `projective.rs:44-50` | RC1 |
| 13 | 4 | `xor_sumset_256_into` claims a saturated sumset when one operand is empty; the nonempty precondition is re-established independently at each of four call sites. *(Found independently by two agents; severity settled at 4 by the call-site audit.)* | `bitset_sumset.rs` | RC1 |
| 14 | 4 | The g53 sparse-dual projection/rotation sumset kernels silently cap at 64 residue states, with the guard living in one caller; the next parameter step wraps shifts in release and corrupts exclusion certificates | `g53_sparse_dual.rs:394`, `:308-331`, `:345-376` | RC1, RC2 |
| 15 | 4 | The zero-allocation gate rests on four diverged copies of a thread-local counting allocator; two lack the panic guard, and any rayon-ified measured kernel passes the gate vacuously. **Partially resolved in `b7a05ab43`:** the public integration tests now reuse the worker-aware, panic-safe core harness; explicit measurement propagation and panic restoration have direct regressions. Private copies remain to migrate without absorbing their owners' in-flight work. | `src/lib.rs:92-98`, `tests/proof_synthesis_allocations.rs:69`, and two guarded copies | RC1, RC2 |
| 16 | 4 | `Matrix` carries no field tag, so identical bytes silently reinterpret under a different field; it derives `Serialize`/`Deserialize` with no field context, and the reduced-entry check is the only residual guard. `span.rs`'s `CanonicalTargetImage` already implements the guard `Matrix` lacks. **Resolved in `f69380676` and `aca704d3d`:** every matrix now carries an exact characteristic/degree/modulus-presentation identity in the existing 32-byte layout; matrix algebra plus span, transfer, cost-table, composition, and tower consumer boundaries reject mismatches. Static/runtime GF(4), equal-order different-basis, serialization, forged-tag, and cross-consumer controls pass. | `matrix.rs`, `field.rs`, `span.rs`, `transfer.rs`, `composition.rs` | RC1 |
| 17 | 4 | `Prime<P>` arithmetic is public and unvalidated — `validate()` was advisory, so invalid moduli or noncanonical bytes could enter raw arithmetic. Includes the former `assert!` vs `debug_assert!` split between `SmallField` and `BinarySmallField`. **Partially resolved in `38f6fa673`, `90ee59e48`, `629ba88d4`, and `ec0e50206`:** invalid prime moduli fail at arithmetic instantiation; binary raw-byte operations are checked; one-byte `BinaryElement<H>` / exact-field `FieldElement<F>` types validate once; and the dense-selector hot kernel now consumes its constructor-validated bytes through the typed path at neutral cost. Existing Prime/Gf4 raw arithmetic and other consumers still expose the canonical-byte contract, so migration or a checked boundary remains open. | `field.rs`, `selector.rs` | RC1, RC2 |
| 18 | 4 | The `LiftProfile` signature width is implicit in `lift_bits`, which `EnergyDomain` does not record; four width-divergent unpackers exist (`as u8` at three sites, `as u16` at one) | `g133_sparse_defect.rs:255-265`, `:1213`, `:1358`, `:3779`, `:3808` | RC1 |
| 19 | 5 | `Hadamard2092Error::FixedField` is an overloaded catch-all across 54 uses spanning budget exhaustion, conversion overflow, replay mismatch, and invariant violation; the q7 path reports the same budget condition as `StateBudget`. It directly worsened diagnosis of finding 4 | `g53_search.rs`, e.g. `:2111-2113`, `:1700`, `:2149-2153` | RC1 |
| — | — | **Refuted.** `BinaryProjectiveIndex::new`'s `checked_shl` guard was reported as failing open; the quoted ascending loop exists in no revision, the real constructor shifts the literal `1_u64` (exact), and the claimed trigger correctly returns `Err(DimensionOverflow)` | `projective.rs:144-165` | see RC4 |

## Round 2 findings register

Round 2 restricted reporting to SEV1 and SEV2 only, across four areas round 1 under-covered:
the reduction/quotient math, the core-crate remainder, the binary/test/checker layer, and a free
pass over the engines. It returned two SEV1 and twelve SEV2. Numbering continues from the round-1
register.

| # | SEV | Finding | Location | Cause |
|---|-----|---------|----------|-------|
| 20 | 1 | The extension-field elimination benchmark's fixture is built with the identity in its first `rows` columns, so it is already in reduced row echelon form: both reducers return `rows` and modify nothing, the equivalence assertion compares two untouched copies, and the `sub`-versus-`^=` divergence the benchmark exists to exercise never executes. This empties both the "agree byte-for-byte" claim and the timing numbers cited to close the extension-field elimination gate. *(Fixture and assertion re-verified in the main session.)* | `bin/c985_extension_field_elimination_bench.rs:122-140`, `:209-213`; claim at `notes/2026-08-27-c985-ergodis-optimization-paper.md:592-599` | RC3, RC5 |
| 21 | 1 | The sharded wide CSS-distance search filters branches positionally (`branch_index % count == index`) out of a list whose contents depend on the incumbent weight bound, and that bound differs per shard after the first anchor — so the shards do not cover the branch set, while the ledger stamps the aggregate `verdict: "complete-compatible-cover"` unconditionally. Both committed inputs carry two anchors. The compact sharded path builds its list bound-independently and is a genuine partition. *(Filter and verdict stamp re-verified in the main session.)* | `css_distance.rs:2195-2298`, `:2423-2453`, filter at `:2295`; `bin/css_distance_shard_ledger.rs:239` | RC3, RC5 |
| 22 | 2 | Witness-annihilating merge: `Option<u32>` compared with a raw `<`, where `None < Some`, so the parallel fold's identity element (witness fields `None`) wins unconditionally and both engines emit `first_witness: null` on every run — including reports that count replay-verified hits in the same breath. A third copy carries the correct `is_some()` guard. Violates the documented identity contract of `reduce_roots`. *(Found independently by two agents.)* | `g41_joint_quotient_search.rs:936-939`; `g53_sparse_defect.rs:465-481`; correct copy at `g41_q29_evolve.rs:1960-1965` | RC1 |
| 23 | 2 | The sealed g41 quotient-filter source-semantics string and `REPRESENTATIVE_SHIFTS` claim a necessary-filter intersection over six shift-orbit representatives (q0, q1, q2, q3, q6, q9), but the census intersects only q2, q3, q6, q9. The 768-root exclusion stays sound — a weaker filter yields a superset — but the method the certificate describes is not the method that ran | `g41_quotient_filter_proof.rs:25-30`; `g41_defect_scout.rs:1450` | RC5 |
| 24 | 2 | The exact-q0 test in the mod-49 lift compiler is applied to one arbitrary preimage per mod-49 signature, but exact q0 is not a function of that signature (it is pinned only mod 49), so the search runs over a strict subset of candidates. False negatives only, and the failure is a loud `Err` | `g53_mod49_high_scout.rs:222-227`, `:547-556` | own |
| 25 | 2 | The control-plane cascade prune is keyed on `(false_positive, Reverse(correct))` while `best` and the expansion set are keyed on `(correct, false_positive)`, so `evolve-start` can report a plan strictly worse than one it silently discarded. Would be SEV1 if any manuscript cited an evolve-start `best`; none found | `control/evolution.rs:111`, `:127-136`, `:205-233`; gate at `vm.rs:1238-1246` | own |
| 26 | 2 | `next_support = old_support - consumed + created` is not the successor defect count, because `created` also subtracts `half_defects`; it undercounts by `\|(next_defects ∩ half_defects) \\ old_defects\|` and is then compared against a fully counted `old_support`. The same expression is serialized to committed evidence as `charged_support` | `projective_grid.rs:369-371`, `:393`; `bin/c80_hall_rematch.rs:617`, serialized at `:711` | RC1 |
| 27 | 2 | `kernel` is populated only when `rank == 5`, so any leaf with rank ≤ 4 tests against the all-zero vector and is counted `forced_hit`. Very likely unreached with the frozen 2,633-row input | `q16_quadratic.rs:330-344`, `:390-399` | own |
| 28 | 2 | `candidate_cap` truncates `admission_candidates` but is not a `Summary` field, so committed hashed evidence holds 8 records against a `failures_admission_candidates` metric of 1,984,400, with the cap recorded only in a note's prose | `bin/c80_hall_rematch.rs:816-817`; `evidence/c80-hall-rematch-q11-exhaustive.json` | RC5 |
| 29 | 2 | `certiis verify` recomputes demand and capacity but never checks `certificate.deficit`, the certificate's headline number; the one tamper test rejects on the irreducibility check instead, so the gap is invisible | `certiis.rs:1037-1055`; tamper test at `:2220-2242` | RC3 |
| 30 | 2 | The q7 repair provenance string "q0-q6 repaired and independently replayed" is a fixed literal emitted regardless of `--exact-input-prefix` / `--target-prefix`, and neither flag is a `Report` field | `g53_q7_repair.rs:40-41` | RC5 |
| 31 | 2 | `orbit13 --cap` aborts the enumeration while `OrbitCertificate` has no `cap` field, so a partial count is written as "N normalized orbit matrices survive" | `bin/c1018_plane12.rs:626-628` | RC5 |
| 32 | 2 | `workspace_payload_reduction` is matrix cells over the raw workspace's own byte total; `core_workspace_payload_bytes` is serialized but never enters the ratio | `bin/semantic_rank_census.rs:204-207` | own |
| 33 | 2 | Both byte-identity `diff`s sit on the left of `&&`, which `set -e` exempts, so the replay script exits 0 when the regenerated certificate differs from committed evidence. *(Reproduced empirically by the auditing agent.)* | `python/c1029_replay.sh:41-46` | RC3 |

Round 2 also closed two negatives with evidence rather than leaving them open. No second instance
of the round-1 additive-join shape exists: every other join composes across blocks where the target
is a block-diagonal sum, which is exact — established independently by the math agent and the free
agent. And `hall_core.rs`'s matching, König deficiency extraction, and saturation test are sound,
with the neighbourhood recomputed rather than self-reported, confirmed by two independent reads.

Cross-cutting shapes counted in the pass-2 sweep, beyond the individual findings above: the
guard-in-caller shape at seven sites, copy-and-diverge at six, verification-by-re-execution across
seven sealed-proof modules plus both certificate tools, implicit width caps at four, and
passing-value deserialization defaults at two dangerous sites (the second being
`control/mod.rs:662`, where an absent control-plane parameter selects the permissive branch).

## Two claims verified independently in the main session

Both were re-checked directly rather than taken from a report, because each bears on how much
weight the other reports can carry.

**The refutation stands.** The core-library report's `BinaryProjectiveIndex` finding quotes an
ascending loop calling `block.checked_shl(u32::from(H))` per iteration. The actual constructor at
`papers/complete-repair-ports/ergodis/src/projective.rs:144-165` shifts the literal `1_u64` once
and then descends by `block >>= H`. Shifting a literal 1 is exact — it returns `None` precisely
when the shift reaches the word width, which is the overflow condition. The claimed trigger
PG(8,256) returns `Err(DimensionOverflow)` correctly. The quoted code exists in no revision of
the file.

**The untracked-source claim stands.** `g53_search.rs`, `hadamard_2092.rs`, `proof_synthesis.rs`,
`reduction_proof.rs`, and `bitset_sumset.rs` are all unknown to git; 36 of the 46 top-level
modules under `ergodis-private/src/` are tracked. Every finding located in those files cites a
blob that no commit contains.

## Root causes

Five generators were named in the pass-2 report. Collapsing the ones that share an underlying
mechanism gives four, ordered by how much of the finding set each explains.

### RC1 — The crate is organized by campaign, not by capability

`ergodis-private/src/` is a flat list of campaign modules: `g41_*`, `g53_*`, `g133_*`,
`hadamard_*`, `q16_*`, `q19_*`, `q25_*`. There is no capability layer — no home for "a bitset
sumset", "a certificate writer", "an allocation-counting harness", "a projective index". So a
utility gets written inside whichever campaign needed it first, and the next campaign copies it.

This single fact generates two of the pass-2 shapes at once, which is why it belongs at the top:

- **Copy-and-diverge (six instances).** The allocation-counting allocator exists in four copies,
  two of which lack the panic guard the other two have. `solve_sorted_square_sum` sums squares in
  unchecked `u32` while `solve_bounded_linear_combination`, in the same file, uses `checked_add`.
  `certiis::write_json` overwrites unconditionally where `hall_certify` in the same directory uses
  `create_new(true)`. `SmallField::table_index` uses a real `assert!` where `BinarySmallField::mul`
  uses `debug_assert!` for the identical misuse. The generic and binary projective constructors
  disagree at the representable boundary in both directions.
- **The guard lives in one caller, not in the kernel (seven instances).** A kernel with no home
  has no place to put its own precondition, so the check lands at whichever call site existed
  first and does not travel to new callers. This is the `xor_sumset_256_into` nonempty
  precondition, the 64-residue-state cap in the sparse-dual kernels, `add_states_power`'s
  `bits <= 4` requirement, `BinarySmallField::inverse_nonzero`'s non-zero input, the `lift_bits`
  decode width, and the `Matrix` field identity.

The pass-2 report identifies the cheap counterexample already present in the codebase: the 13-bit
`q1`/`q2` packing in `g133_sparse_defect.rs:763-787` rejects out-of-range values immediately before
the shift-or, so the boundary check travels with the representation. That is the pattern to
generalize.

`Hadamard2092Error::FixedField` is the same cause seen from the error side — one variant absorbing
budget exhaustion, conversion overflow, replay mismatch, and invariant violation across 54 sites,
because no layer owns the distinction.

### RC2 — Performance discipline was adopted without a compensating correctness mechanism

The zero-allocation and fixed-record conventions, `panic = "abort"`, `debug_assert!` rather than
`assert!`, and release builds with overflow checks off are all deliberate and mutually consistent
choices in service of campaign throughput. What is missing is anything that recovers the
guarantees those choices give up.

The consequence is that the structural bounds holding the code together are load-bearing and
asserted nowhere. Per-residue counts are capped at 29 by the carrier layout; three-square targets
are pinned to 18; signature counts are capped at 255 by a `u8`; residue states are capped at 64 by
a word width. Each of these is true today by construction and enforced by nothing, in exactly the
builds the campaigns run. `solve_sorted_square_sum` is the live instance where the bound is already
absent and release-mode wraparound can forge a solution; the pass-2 sweep found no second live
instance, but catalogued three more hot kernels using the same widen-after-multiply idiom one
constant change away from repeating it. In `reduction_proof.rs`, the equality check that pins the
target runs *after* the map it protects — a guard-after-use ordering that is correct only by
accident of the current constants.

The same cause explains why `GeneratedSpanTable::build` fails by process abort rather than an
error, and why the zero-allocation gate is vacuous for any rayon-ified kernel measured through the
two allocator copies that lack the panic guard.

### RC3 — "Verified" was defined as re-execution, so the verify layer cannot catch prover-side defects

This is the systemic finding, and it is a design decision rather than an oversight. Across
`certdist`, `certiis`, and all seven sealed-proof modules (`g53_sparse_q4_proof`,
`g133_exact_q2_proof`, `quotient_paf_proof`, `g41_quotient_filter_proof`, `g53_reduction_proof`,
`subgroup_energy_proof`, `g53_defect_profile_proof`), verification means re-running the prover's own
computation and comparing, plus replaying a Horn transcript that encodes only the ordering of rule
applications, not the computation those rules performed. `certdist verify` recomputes its bracket by
calling the same `build_bracket` the prover called. `certiis` verify re-reads through the same
permissive deserializer, and because the digest is taken over the raw bytes, a misspelled container
key that silently yields an empty coupling set still hashes correctly. Prover and verifier share
`solve_sorted_square_sum` at the bottom of both `reduction_proof` paths.

Any defect upstream of the point where a computation splits into two kernels passes prover and
verifier identically. The claimed dual-kernel independence lives *inside* the shared function, not
between the two sides.

Genuine independence exists in exactly two places, and both are worth naming as the model to copy:
the `landed_rank_adapter` GF(9) arithmetic, which is a separate implementation of the same algebra;
and the python checkers (`verify_hall_certificate.py`, `c1029_check.py`,
`check_hadamard_quotient_pilot.py`), which recompute from scratch rather than trusting a JSON
self-report.

This needs a decision rather than a patch: what independence do the paper-facing claims actually
require, and which certificates must be checkable by an argument structurally different from and
cheaper than the search that produced them?

**Round 2 broadens this cause.** Re-execution turns out to be one instance of a wider pattern:
checks that are structurally incapable of failing. Four more forms appeared, and none of them
involves re-execution at all. The extension-field elimination benchmark's fixture is already in
reduced row echelon form, so the assertion comparing the two reducers compares two untouched
copies and the divergence it exists to catch cannot execute (finding 20). The sharded CSS-distance
ledger stamps `verdict: "complete-compatible-cover"` unconditionally, with nothing computing
whether the shards actually cover (finding 21). `certiis verify` omits the certificate's headline
number from what it checks, and the single tamper test happens to reject on a different check, so
the omission is invisible (finding 29). The C1029 replay script places both byte-identity `diff`s
to the left of `&&`, where `set -e` does not apply, so it exits 0 on a mismatch (finding 33).

The unifying property is that each of these passes with probability 1 regardless of the state of
the world it purports to check. That is a stronger and more testable statement than "verification
re-runs the prover", and it suggests a concrete audit any check can be put through: construct the
input that should make it fail, and confirm that it does.

### RC4 — The evidence chain is not in git, which makes the audit itself unpinnable

The modules holding the most consequential findings are untracked. Committed notes cite replay
binaries that no commit can build. Every `path:line` citation in these five reports points at a
working-tree blob rather than a commit.

This cause has a demonstration inside the audit itself: a report quoted a `checked_shl` loop that
exists in no revision of the file, and the only thing that caught it was a second agent re-reading
the working tree. With the sources committed, that claim could have been checked against a blob
hash in seconds.

Committing the tree is the precondition for any of this work becoming durable evidence, and it is
the cheapest item on the list.

### RC5 — The emitted artifact records the request, not the run

This cause is new in round 2, and it produced more findings than any other single cause in that
round. A binary accepts a parameter that constrains what the computation actually covers — a cap,
a prefix, a shard index, a filter set — and the record it writes describes the intended
computation rather than the constrained one. The parameter is not a field of the emitted
structure, so nothing downstream can tell the difference.

The instances are strikingly uniform. `candidate_cap` truncates the admission candidates but is
not a `Summary` field, so committed hashed evidence holds 8 records against a metric reporting
1,984,400 (finding 28). `orbit13 --cap` aborts the enumeration, but `OrbitCertificate` has no
`cap` field, so a partial count is written with the language of a complete one (finding 31). The
q7 repair emits a fixed provenance literal claiming independent replay regardless of the prefix
flags actually passed, neither of which is a `Report` field (finding 30). The sealed g41
quotient-filter semantics string names six shift-orbit representatives where the census intersects
four (finding 23) — the same defect with the divergence frozen into a sealed constant rather than
arising at run time.

Findings 20 and 21 sit at the intersection of this cause and RC3: a verdict or a timing number is
recorded for a computation that did not happen as described. The distinction from RC3 is worth
keeping, though, because the fix differs. RC3 asks what a check must do to be capable of failing.
RC5 asks a narrower and more mechanical question: does every parameter that can change what a run
covers appear in the record that run emits? That question can be answered by inspection, one
binary at a time, and it is the cheapest systematic sweep available from this audit.

## What the audit says about auditing

One finding in twenty quoted code that does not exist, and three more were one severity notch
high. The single-pass reports were confidently wrong at a rate that matters, and the cross-check
pass is what corrected them. Three findings were reached independently by two agents each — the
unchecked `u32` square sum, the `xor_sumset_256_into` empty-operand saturation, and the
`Option`-ordering witness merge — and independent agreement is the signal that has held up best.
Treat an unvetted single-agent finding as a lead, not a result.

Round 2 changed two things about the method and both are worth keeping. Reporting was restricted
to SEV1 and SEV2 with **no target count**, and agents were told that finding nothing at that
severity was an acceptable result. Round 1 asked for five findings per agent and got padding at
the bottom of the range plus one fabrication; round 2 removed the quota and returned two SEV1 and
twelve SEV2 with no fabrications, along with two negatives closed on evidence (no second
additive-join instance; `hall_core` sound). A quota buys coverage at the cost of precision, and
precision is what an audit is for. Second, every brief carried an explicit evidence standard —
re-read and confirm each quoted snippet immediately before writing it up — which is the direct
countermeasure to the round-1 fabrication.

## Ordered recommendation

1. **Re-examine the two claims resting on findings 20 and 21**, ahead of everything else, because
   these are the only items where something already recorded may be wrong rather than merely
   unguarded. The extension-field elimination gate was closed on a benchmark whose fixture makes
   the compared paths identical and untouched, so the byte-for-byte agreement and the timings need
   a fixture with a genuine non-identity prefix before either can be cited. The sharded
   CSS-distance runs need their cover property established or the `complete-compatible-cover`
   verdict withdrawn from the affected inputs; note that the compact sharded path is a genuine
   partition, so the fix may be to use it or to make the wide path's branch list bound-independent
   in the same way.
2. **Commit the untracked `ergodis-private` sources.** Cheapest item, and it is the precondition
   for every other item becoming citable evidence. Addresses RC4.
3. **Fix the checks that cannot fail.** `certdist verify` should fail when witnesses are unchecked;
   `certiis` needs `deny_unknown_fields`, required rather than defaulted `demand`/`capacity`/
   `couplings`, and a check of `deficit`; the C1029 replay script needs its `diff`s moved out of
   the `&&` left position. All are small and local, and each closes a path by which a wrong result
   passes an advertised check today. Addresses the RC3 instances needing no architecture decision.
4. **Sweep every evidence-emitting binary for RC5**: does each parameter that can change what a run
   covers appear in the record that run emits? This is answerable by inspection, one binary at a
   time, and four known findings (23, 28, 30, 31) are instances. Fixing the emitters matters more
   than fixing the four, since committed artifacts inherit the property.
5. **Decide the verification-independence question.** Which claims need a verifier that does not
   re-run the prover? A design call, not a defect fix, and it governs how much the word "verified"
   is allowed to carry in the manuscripts. Addresses RC3.
6. **Fix the `Option`-ordering witness merge** (finding 22). Small, and the correct implementation
   already exists in a sibling copy — the `is_some()` guard in `g41_q29_evolve` — so this is a
   mechanical alignment rather than a design question. Every affected run has been emitting a null
   witness.
7. **Fix the g53 same-block additive delta join**, or rename the repair to match the predicate it
   actually implements (cross-block-additive combinations, not exact four-move repair). The q7
   negative is already hedged in its emitted provenance and the q4 failure is loud, so nothing
   published is wrong — but the name overclaims and the q4 path discards genuine repairs found later
   in the enumeration.
8. **Give the shared kernels a home** — one allocation-counting harness, one certificate writer, one
   sumset kernel, one witness-merge — with each precondition asserted adjacent to the representation
   it protects. Addresses RC1 and, where the assertion survives release, RC2.
9. **Assert the structural bounds that are currently load-bearing and invisible**, or run the
   campaign kernels on small parameters under a debug/overflow-checked build in CI. Addresses RC2.

Items 1 through 4 and 6 are mechanical or near-mechanical. Item 5 needs a decision before anything
is written. Items 7 through 9 are real work whose scope depends on that decision.

### Disposition of recommendation 1

Both claims were re-examined after repair, rather than merely re-running their
old controls.

- **Finding 20 reverses the isolated performance claim.** Commits `8b7dc358f`
  and `2b2b3e39d` replace the vacuous `[I|R]` input with a seeded, guaranteed
  full-rank non-RREF fixture and assert that both implementations mutate it.
  The corrected equivalence gate passes 256 matrices at each extension degree
  3 through 8. Seven seed rotations show that the specialized binary reducer
  is faster, not slower: table/binary is 1.009912x cycles (`t=7.47`) at `4 x
  5` and 1.054166x (`t=23.44`) at `8 x 9`, with corresponding instruction
  ratios 1.081415x and 1.133774x. The old isolated result is withdrawn. The
  application decision remains a rejection for a different, independently
  measured reason: elimination received no sample at the 0.01% threshold in
  the full PRS profile, so specializing it cannot materially accelerate that
  workload. A fresh source-current replay after the audit retains the direction
  but not the old point estimates. Seven seed-rotated pairs with ten million
  reductions per arm give table/binary `1.007614x` cycles (`t=6.86`) at
  `4 x 5` and `1.028575x` (`t=19.10`) at `8 x 9`; wall time is unresolved at
  `4 x 5` (`1.001148x`, `t=0.83`) and favors binary at `8 x 9`
  (`1.021086x`, `t=12.64`). Instructions remain exact-shape wins of
  `1.072487x` and `1.142832x`; binary pays more, but still tiny, branch-miss
  counts. The tracked raw pairs are
  `ergodis-private/evidence/c1030-extension-field-elimination-rerun.tsv`, run
  on CPU 2 with `perf 7.0.11`, Rust `1.93.1`, source `b7a05ab43`, and binary
  SHA-256 `a8c12f3b7fc47cd68c6299c99ad0b67069a1b9002c0bf975adc884354a49512c`.
  Therefore the robust claim is qualitative and bounded: the binary reducer
  saves instructions and is faster on the larger isolated fixture, but the
  earlier exact ratios are superseded and no PRS application speedup follows.
- **Finding 21 narrows but does not overturn the recorded BB288 result.** Commit
  `8d71c3b51` makes each anchor's positional frontier independent of
  shard-local incumbents, which are now applied only after assignment. A
  post-fix three-way radius-2 replay visits exactly 10 candidates per shard and
  reproduces the 30-candidate no-witness aggregate. Inspection of the old run
  establishes that it was also witness-free, hence its incumbent never changed
  and its actual frontier did not diverge. Its numeric result survives; the old
  generic `complete-compatible-cover` rationale does not. Seven interleaved
  parent/candidate counter pairs show no significant operational regression:
  instructions are 0.9999997x at 1T (`t=-1.08`) and 0.9999599x at 12T
  (`t=-1.40`), while 12T cycles are 1.002252x (`t=1.57`). Commit `2c2bfc293`
  closes the remaining ledger gap: v6 evidence commits each anchor's common
  deterministic prefix frontier and its selected shard bucket, while the v3
  ledger reconstructs the full partition digest from all buckets. The prefix
  builder is shared with search rather than copied, and mutations of a bucket,
  partition digest, or anchor fail closed. The manifest therefore establishes
  the named prefix cover rather than relying only on executable identity. The
  preceding v2 manifest separately bound requested and
  effective maxima, admits only the one-step odd-to-even normalization, and
  mutation-tests both invalid and cross-shard-inconsistent effective maxima;
  this closes the adjacent parity-normalization false-rejection foot-gun.

The source-current focused gates were rerun after the shared allocation-harness
repair: the non-RREF elimination fixture/equivalence tests, compact and wide
frontier reconstruction, and the shard-ledger mutation suite all pass. Thus
finding 20 changes an isolated microbenchmark conclusion but not the PRS
application choice, while finding 21 changes the generic coverage rationale
but not the old witness-free BB288 numeric result.

A general test worth adopting alongside these, since it would have caught findings 20, 21, 29, and
33 as a class: for every check, assertion, and verdict in the evidence path, construct the input
that should make it fail and confirm that it does.

## Mystery ledger

- **Why the fabricated quote was plausible.** The refuted finding described a defect that would be
  real in a constructor written the obvious ascending way; the actual code avoids it by descending.
  Settled: the working-tree read. Open: nothing, but it is the concrete argument for RC4.
- **Whether the sealed-proof family's dual-kernel independence was ever intended to be
  prover-independent.** The design reads as deliberate ("verification rebuilds…"), but no document
  found in this pass states what independence property was being claimed. Owning successor: the
  decision in recommendation 3.
- **Why `reduction_proof.rs` pins its three-square target after building the map rather than
  before.** Currently harmless because the constant is 18. Not investigated further; it is a
  one-line reordering whose absence suggests the ordering was never considered.
- No genuine mystery remains in the core library findings: all five were traced to explicit code
  and every reachable caller was accounted for.
- **Why the elimination benchmark's fixture was written with an identity prefix.** The generator
  deliberately emits `1` on the diagonal and `0` below the row count, which reads as intentional
  structure rather than an accident — but that structure is exactly what makes the benchmark
  vacuous. Whether a non-identity prefix was tried and rejected for some reason is not recorded.
  Settled by neither round; owning successor is recommendation 1.
- **Whether any sharded CSS-distance run in committed evidence used a single anchor.** The cover
  defect requires two or more anchors, and both committed inputs carry two. Whether a single-anchor
  run exists elsewhere, which would be unaffected, was not enumerated. Gate: recommendation 1.
- **How long the null witness has been emitted.** Finding 22 makes every affected run emit
  `first_witness: null`, including runs whose reports count replay-verified hits in the same
  breath. No pass established when the divergence from the correct sibling copy occurred, and the
  untracked sources (RC4) make that history unrecoverable for the files that are not in git.
- Resolved from the round-1 ledger: the additive-join shape has no second instance, established
  independently by two round-2 agents.
