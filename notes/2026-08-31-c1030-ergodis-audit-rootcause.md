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
| 3 | 2 | `Matrix::row_space_contains_field` uses the row count as the rank, so a rank-deficient matrix returns `true` for a candidate outside its row space (and a redundant-row matrix returns `false` for one inside). Both public variants affected; every existing caller canonicalizes first, including one in `c1028_chain_ring.rs:889-892` that pass 1 missed | `matrix.rs:216`, `:205-206`, `:221` | own |
| 4 | 2 | The additive delta join in the g53 multi-move repairs is wrong for same-block moves: `repair_moves_compatible` returns `true` for same-block moves with disjoint orbit sets, but disjoint support kills only the shift-0 cross term. `finish_q4_repair` then returns `Err` without restoring the shell, aborting the whole q4 selection repair and discarding genuine repairs later in the enumeration | `g53_search.rs:2081-2101`, `:726-748`, `:822-834`, `:2149-2153` | own |
| 5 | 2 | The committed tree does not build: 9 of 20 modules declared at HEAD exist only as untracked files, and committed notes cite replay binaries buildable from no commit | `ergodis-private/src/`, `Cargo.toml` | RC4 |
| 6 | 2 | `solve_sorted_square_sum` sums squares in unchecked `u32`, so release-mode wraparound can forge a solution for targets above `2^32/8`; `integer_square_root(u32::MAX)` loops forever. Its sibling `solve_bounded_linear_combination` in the same file uses `checked_add`, and prover and verifier share the defective kernel. *(Found independently by two agents.)* | `proof_synthesis.rs`; `reduction_proof.rs:342`, `:511` | RC1, RC2, RC3 |
| 7 | 2 | `scout_g41_q29_seed_power` rescores one arbitrary preimage per modular state: `insert_with_value` keeps the first value per state, the right-hand scan breaks on first match, and `exact_residual`/`full_paf_hit` are then computed from that single arbitrary fibre member | `g41_q29_evolve.rs:370-387`, `:2321-2335`, `:2353-2356` | own |
| 8 | 2 | `certiis` writes wall-clock timings into the certificate (making it irreproducible byte-for-byte) and overwrites evidence in place via unconditional `fs::write` with a swallowed `create_dir_all` error | `certiis.rs:508-510`, `:718-736`, `:1699-1706` | RC1 |
| 9 | 3 | `GeneratedSpanTable::build` enumerates subspaces with no cap, stores each state twice, and fails by process abort rather than an error under `panic = "abort"` | `span.rs:88-119`, `arena.rs:37-39` | RC2 |
| 10 | 3 | Mod-16 dense pair keys are 8,200 bytes each, retained per class, against a 255-signature `u8` wall | `g133_sparse_defect.rs:224-226`, `:1499-1501` | RC2 |
| 11 | 3 | The q23 Hall evidence has no recorded hashes, no replay command, and no graph-to-certificate binding: `evidence/SHA256SUMS` has 13 rows, none matching the 7 q23 files present | `ergodis-private/evidence/` | RC4 |
| 12 | 4 | Generic `ProjectiveIndex::new` computes one block past the last it pushes, spuriously rejecting the largest representable geometry — PG(7,256) errors although its point count fits in `u64`, while the binary sibling accepts it. The grounded residue of the refuted finding below | `projective.rs:44-50` | RC1 |
| 13 | 4 | `xor_sumset_256_into` claims a saturated sumset when one operand is empty; the nonempty precondition is re-established independently at each of four call sites. *(Found independently by two agents; severity settled at 4 by the call-site audit.)* | `bitset_sumset.rs` | RC1 |
| 14 | 4 | The g53 sparse-dual projection/rotation sumset kernels silently cap at 64 residue states, with the guard living in one caller; the next parameter step wraps shifts in release and corrupts exclusion certificates | `g53_sparse_dual.rs:394`, `:308-331`, `:345-376` | RC1, RC2 |
| 15 | 4 | The zero-allocation gate rests on four diverged copies of a thread-local counting allocator; two lack the panic guard, and any rayon-ified measured kernel passes the gate vacuously | `src/lib.rs:92-98`, `tests/proof_synthesis_allocations.rs:69`, and two guarded copies | RC1, RC2 |
| 16 | 4 | `Matrix` carries no field tag, so identical bytes silently reinterpret under a different field; it derives `Serialize`/`Deserialize` with no field context, and the reduced-entry check is the only residual guard. `span.rs`'s `CanonicalTargetImage` already implements the guard `Matrix` lacks | `matrix.rs:18-62` | RC1 |
| 17 | 4 | `Prime<P>` arithmetic is public and unvalidated — `validate()` is advisory, so `Prime::<9>::inverse(3)` returns `Ok(0)` and `Prime::<0>::add` divides by zero. Includes the `assert!` vs `debug_assert!` split between `SmallField` and `BinarySmallField` for the identical misuse | `field.rs:50-93` | RC1, RC2 |
| 18 | 4 | The `LiftProfile` signature width is implicit in `lift_bits`, which `EnergyDomain` does not record; four width-divergent unpackers exist (`as u8` at three sites, `as u16` at one) | `g133_sparse_defect.rs:255-265`, `:1213`, `:1358`, `:3779`, `:3808` | RC1 |
| 19 | 5 | `Hadamard2092Error::FixedField` is an overloaded catch-all across 54 uses spanning budget exhaustion, conversion overflow, replay mismatch, and invariant violation; the q7 path reports the same budget condition as `StateBudget`. It directly worsened diagnosis of finding 4 | `g53_search.rs`, e.g. `:2111-2113`, `:1700`, `:2149-2153` | RC1 |
| — | — | **Refuted.** `BinaryProjectiveIndex::new`'s `checked_shl` guard was reported as failing open; the quoted ascending loop exists in no revision, the real constructor shifts the literal `1_u64` (exact), and the claimed trigger correctly returns `Err(DimensionOverflow)` | `projective.rs:144-165` | see RC4 |

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

## What the audit says about auditing

One finding in twenty quoted code that does not exist, and three more were one severity notch
high. The single-pass reports were confidently wrong at a rate that matters, and the cross-check
pass is what corrected them. Two findings — the unchecked `u32` square sum and the
`xor_sumset_256_into` empty-operand saturation — were reached independently by two agents, which is
the signal that held up best. Treat an unvetted single-agent finding as a lead, not a result.

## Ordered recommendation

1. **Commit the untracked `ergodis-private` sources.** Cheapest item, and it is the precondition
   for every other item becoming citable evidence. Addresses RC4.
2. **Fix `certdist verify` to fail when witnesses are unchecked**, and add `deny_unknown_fields`
   plus required (rather than defaulted) `demand`/`capacity`/`couplings` to `certiis`. These are
   small, local, and they are the two places where a wrong result passes the advertised verifier
   today. Addresses the RC3 instances that do not need an architecture decision.
3. **Decide the verification-independence question.** Which claims need a verifier that does not
   re-run the prover? This is a design call, not a defect fix, and it governs how much the word
   "verified" is allowed to carry in the manuscripts. Addresses RC3.
4. **Fix the g53 same-block additive delta join**, or rename the repair to match the predicate it
   actually implements (cross-block-additive combinations, not exact four-move repair). The q7
   negative is already hedged in its emitted provenance and the q4 failure is loud, so nothing
   published is wrong — but the name overclaims and the q4 path discards genuine repairs found later
   in the enumeration.
5. **Give the shared kernels a home** — one allocation-counting harness, one certificate writer, one
   sumset kernel — with each precondition asserted adjacent to the representation it protects.
   Addresses RC1 and, where the assertion survives release, RC2.
6. **Assert the structural bounds that are currently load-bearing and invisible**, or run the
   campaign kernels on small parameters under a debug/overflow-checked build in CI. Addresses RC2.

Items 1 and 2 are mechanical. Item 3 needs a decision before anything is written. Items 4 through 6
are real work whose scope depends on that decision.

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
