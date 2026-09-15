# C1170 — the dead `scopes` pool removed, and `admit::reference` / `admit::declare` annotated by address range

**Lane**: `ergodis`
**Date**: 2026-09-14
**Repository**: `~/src/ergodis-private` (private, no public remote), branch `main`, from `63d6fca`

**Control**: `ergodis-tools` built at revision `db47ee1` and retained as `ergodis-tools-db47ee1`
(retain recipe: `../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools` at that revision).
Measured sha256 `6e41d1d608ea72d9c998a5b9d4ff7788e9f303a44398ebd95b1eaae3fd7920ba`, rustc 1.95.0
(59807616e 2026-04-14), release profile, no features. `git diff --stat db47ee1 63d6fca -- src/ tests/
tasks/` is empty, so the Rust sources this task starts from are the ones the control was built from.

Every build, test, Clippy run, retain, profile and measurement in this report ran under
`nix develop ~/src/ergodis` (rustc 1.95.0, pinned through the core flake).

## Status

Complete, both halves. **The `scopes` pool is gone (`3bd5e38`, kept): `prepare` is 0.9050
[0.9032, 0.9067] of `ergodis-tools-db47ee1`, `prepare-touch` 0.9680 [0.9679, 0.9681] with the
fault count unchanged at 1,536 per iteration, and admission 0.99953 on ASCII** (580 instructions,
one `len = 0` store per definition plus one per admission). Parse is 1.000000 on every cohort and
both scanner variants, retained bytes fall by exactly 2,048, peak RSS is unchanged, and every gate
passed: 24 + 1 tests, zero allocations, strict Clippy on the library, both test targets and the
tools binary, rustfmt, and the native/WASM canonical hash unchanged at `5a350e1f…` over 159 cases.

**The annotate** (`0dc1814`, no kernel change) buckets a kernel-scoped instruction profile of the
control into named address ranges of `admit::reference` (19 regions over 462 instructions) and
`admit::declare` (10 over 221), validated on four single-class sources that each light only the
regions they can reach. Its finding is not in the shares, which are skid-shaped, but in what the
compiled paths cost when multiplied by the census: **the call shape of `reference` — fifteen
caller-side instructions in `run`, a 24-instruction prologue and an 11-instruction epilogue — is
about 50 of the 71.49 instructions the model charges per reference, 176,000 on ASCII, 14 per cent
of the stage**, and the next candidate is to remove it by inlining. `declare` holds no region above
one per cent of the stage; its cost is the eight-byte names it hashes and the inlined insert.

Vibe check: good. The pool removal did exactly what it should and nothing else; the annotate found
that the largest remaining per-reference cost is not inside `reference` at all but around it, and
that shares would have been wrong by a factor of two in both directions.

**Commits** (all on `main`, in order):

| Commit | Contents | Disposition |
|---|---|---|
| `3bd5e38` | the `scopes` field, its reservation, touch, retained-bytes term and three clears removed | **kept** |
| `0dc1814` | the `prepare` A/B receipt; `annotate-buckets.py` and `annotate-regions-db47ee1.json`; the annotate receipt; per-caller hash bytes in the census; the frontend README section; the parity receipt's library hashes | — |

The control for the next A/B is `ergodis-tools-3bd5e38` (rustc 1.95.0, measured sha256
`41459b567965583d6d67ef489d589acca1293b690731bb5581adf22f9761d782`); `0dc1814` touches no Rust
source.

## Part one — the `scopes` pool

### Fermi, written before the change

`Workspace::scopes` was reserved to `Limits::depth` (512 × 4 = 2 KiB), touched by `touch`,
counted in `retained_bytes` and cleared three times in `admit.rs` (once per admission, once per
`check_definition`, once on the bare-expression path), and nothing pushed to it: the binder-count
mark moved into `Visit::mark` when the traversal stack entries gained a mark, and the pool was
left behind (traversal-cursor report, ledger item 5).

Predicted: `prepare` (6,490 instructions per iteration in the last receipt) loses one
`try_reserve_exact` of 2 KiB, a glibc heap allocation below the mmap threshold plus its free at
drop — priced at 150 to 300 instructions, 2 to 5 per cent of the stage. `prepare-touch` loses the
512-word touch loop (about 600 instructions) and no fault, because 2 KiB is half a page on the
heap. Admission loses one store per `check_definition` (576 on ASCII) plus one, unreadable against
1,246,010 except by the A/A null. Retained bytes fall by 2,048.

### A/B, candidate `3bd5e38` over control `db47ee1`

Seven interleaved rounds, all five cohorts, both scanner variants, `--stages
prepare,prepare-touch,parse,admit`, CPU 5, event set
`instructions,cycles,branches,branch-misses,page-faults,minor-faults` (100.00 per cent enabled on
every event, confirmed directly with `perf stat -x,` on the candidate's `prepare` and `admit`
stages), fingerprint and admission-summary gate armed on every operation. One-minute load average
0.47 at launch and 2.38 after; instruction ratios decide. Receipt
`analysis/rel-frontend/performance-v1-admit-scopes-3bd5e38.json`.

A/A instruction nulls 0.999999 to 1.000002 on all five cohorts, every interval within thirteen
parts per million of unity. Parse is 1.000000 on every cohort and both variants.

| Operation | candidate | control | ratio |
|---|---:|---:|---:|
| prepare | 5,867.9 | 6,484.2 | **0.904951** [0.903159, 0.906746] |
| prepare-touch | 19,331.7 | 19,970.2 | **0.968028** [0.967913, 0.968143]; 1,536 faults both arms |
| ascii/parse/byte | 2,507,813.5 | 2,507,812.7 | 1.000000 |
| ascii/admit/byte | 3,753,244.1 | 3,753,823.5 | 0.999846 |
| unicode/admit/byte | 10,164,607.2 | 10,165,183.9 | 0.999943 |
| comment-string/admit/byte | 1,773,455.2 | 1,773,960.5 | 0.999715 |
| malformed-early/admit/byte | — | — | 1.000008 |
| malformed-late/admit/byte | — | — | 1.000000 |

Admission alone (`admit` − `parse`): ASCII 1,245,430.6 against 1,246,010.8, **0.999534**, 580
instructions removed for 577 clears; unicode 577 removed; comment-string 505 removed for 385
clears (the driver's parse stage for that cohort has its own few-instruction drift, inside its
null). Retained bytes 6,539,264 against 6,541,312. Peak RSS 5,540 to 5,552 KiB in both arms for
the parse and admit stages.

### Where the Fermi was wrong

`prepare` saved 616 instructions, twice the Fermi's upper bound. The reservation and drop of a 2
KiB heap block is not one `malloc` and one `free` on the fast path: each `prepare` iteration
builds and drops a whole workspace, the large pools are mapped and unmapped, and the small block's
free lands in a tcache or bin that the next iteration's allocation retrieves through the general
path. The cost of one is 600, not 150 to 300. It is recorded so the next allocation-count Fermi
starts from the measured figure; no kernel change depends on it.

`prepare-touch` saved 638: the 512-word touch loop plus the reservation, no fault change, as
predicted.

### Gates

Run from `~/src/ergodis-private` at `3bd5e38`, under the pinned toolchain.

| Gate | Command | Outcome |
|---|---|---|
| Frontend tests | `cargo test --release -p ergodis-private --test rel_frontend --test rel_frontend_portability -j 4` | 24 + 1 passed, 0 failed |
| Zero allocation | inside that run | `admission_is_deterministic_over_the_cohorts_and_does_not_allocate` observes zero allocations and unchanged retained bytes over ten rounds |
| Clippy, library and both test targets | `cargo clippy --release -p ergodis-private --lib --test rel_frontend --test rel_frontend_portability -j 4 -- -D warnings` | no diagnostics |
| Clippy, tools binary | `cargo clippy --release -p ergodis-tools --bins -j 4 -- -D warnings` | no diagnostics |
| Formatting | `rustfmt --check --edition 2021 src/rel_frontend/admit.rs src/rel_frontend/mod.rs` | clean |
| Native/WASM parity replay | `python3 analysis/rel-frontend/portability.py --output analysis/rel-frontend/portability-v1.json` | 159 cases, 345,993 canonical bytes, canonical SHA-256 `5a350e1f524b26da61186320414785045d9f39a71c4b34b40f9bd78d3516cbfa` unchanged (only the two library hashes in the receipt moved) |
| Driver output gate | armed on every operation of the A/B | equal tokens, nodes, failure, admission summary and fingerprint on every cohort and both variants |
| Event set | `instructions,cycles,branches,branch-misses,page-faults,minor-faults` | 100.00 per cent enabled on all six, `perf stat -x,` on `prepare` and `admit` at `3bd5e38` |

## Part two — `admit::reference` and `admit::declare` annotated by address range

### Method

`perf record -q -e instructions:u -F 10000`, ASCII cohort, byte scanner, 512 definitions, 60,000
iterations of the `admit` stage on `ergodis-tools-db47ee1`, pinned to CPU 7 (the A/B held CPU 5):
`~/.cache/ergodis/perf-c1170/admit-db47ee1-annot.data`, 118,000 samples, of which 15,889 in
`reference` (13.5 per cent of the parse + admit profile) and 5,506 in `declare` (4.7). Four
single-class sources from the decomposition set were profiled the same way at 15,000 iterations
each (`ref-binder-1`, `ref-distinct-6`, `ref-definition-4`, `definition-6`) to validate the region
map.

Precise sampling is not available on this host: `instructions:upp` fails to open, and AMD IBS
(`ibs_op`) needs kernel-mode access that `perf_event_paranoid = 2` refuses. Every sample therefore
carries skid — it lands on the instruction after the one that overflowed the counter, and at call
and return boundaries it lands in the other function — and the shares below are read with that in
mind.

`analysis/rel-frontend/annotate-buckets.py` runs `perf script -F ip,sym,symoff` (the executable is
position independent, so the sampled address is rebased through the symbol offset), keeps the
samples inside the requested symbols, buckets them into regions given as sorted start addresses in
`annotate-regions-db47ee1.json` (each region runs to the next start; the last to the symbol's end),
refuses a sample outside every region, and counts each region's static instructions from `objdump`.
Region boundaries were read off `ergodis-tools-db47ee1` by hand from its disassembly and are
specific to that binary; the receipt records its sha256. Receipt
`analysis/rel-frontend/performance-v1-admit-annotate-db47ee1.json`.

### `admit::reference` — 462 instructions, 0x869d10–0x86a4c0

Samples per region and share of the symbol; the ASCII column is the cohort, the other four are the
validation classes. The last column is the instruction count each region executes on the ASCII
cohort, read from the disassembly path and multiplied by the census counts at `db47ee1` (3,520
references; 1,920 binder hits; 1,600 probes; 695 probe hits; 905 first sights; 4,928 binder
entries examined; 1,920 one-byte binder compares; 789 occupied slots read; 695 symbol compares
over 3,197 bytes; 12,261 name bytes hashed in `reference`; 836 gate rejects, 69 range walks, 181
entries examined, 75 builtin bytes; 102 insert collisions).

| Region | instr | ascii | ref-binder-1 | ref-distinct-6 | ref-definition-4 | executed on ASCII |
|---|---:|---:|---:|---:|---:|---:|
| prologue-setup | 24 | 5,944 (37.4 %) | 51.0 % | 5.4 % | 16.0 % | 24 × 3,520 = 84,480 |
| hash-loop | 8 | 2,498 (15.7 %) | 10.0 % | 24.8 % | 17.4 % | 8 × 12,261 = 98,088 |
| binder-setup | 11 | 832 (5.2 %) | 7.6 % | 0.3 % | 1.6 % | 10 × 3,520 = 35,200 |
| binder-scan | 13 | 886 (5.6 %) | 8.3 % | 0 | 0 | 7 per entry, 6 per filter match ≈ 39,000 |
| binder-same | 19 | 212 (1.3 %) | 7.6 % | 0 | 0 | 16 per one-byte compare = 30,720 |
| empty-name | 25 | 0 | 0 | 0 | 0 | 0 |
| unbound-error | 10 | 108 (0.7 %) | 0 | 0 | 0 | 2 × 1,600 = 3,200 (the fall-through test) |
| probe-setup | 27 | 1,561 (9.8 %) | 0 | 10.3 % | 11.9 % | 21 × 1,600 + 4 per occupied first slot ≈ 37,000 |
| probe-loop | 23 | 987 (6.2 %) | 0 | 1.8 % | 15.4 % | 11 per occupied slot, 6 per hit ≈ 12,900 |
| symbol-same | 26 | 637 (4.0 %) | 0 | 0 | 26.8 % | 12 per call + 13 per byte ≈ 49,900 |
| compatible | 43 | 122 (0.8 %) | 0 | 0 | 3.3 % | 7 to 15 per hit ≈ 7,000 |
| arity-error | 15 | 13 (0.1 %) | 0 | 0.2 % | 0 | 0 on a source that admits |
| builtin-gate | 24 | 209 (1.3 %) | 0 | 5.5 % | 0 | 12 per first sight ≈ 11,300 |
| arity-fix | 12 | 0 | 0 | 0 | 0 | 0 (no base relation is applied twice on this cohort) |
| builtin-walk | 59 | 55 (0.3 %) | 0 | 25.2 % | 0 | ≈ 2,100 |
| new-name-flags | 14 | 145 (0.9 %) | 0 | 4.2 % | 0 | 11 × 905 ≈ 9,955 |
| insert | 44 | 829 (5.2 %) | 0 | 17.2 % | 0 | 34 × 905 + 4 per collision ≈ 31,200 |
| epilogue | 18 | 851 (5.4 %) | 15.6 % | 5.2 % | 7.5 % | 11 × 3,520 = 38,720 |
| panics | 47 | 0 | 0 | 0 | 0 | 0 |
| **total** | 462 | 15,889 | 2,721 | 7,926 | 3,986 | **≈ 491,000** |

The validation holds: `ref-binder-1` lights only the hash, binder and boundary regions (nothing at
or after the probe); `ref-distinct-6` lights the first-sight path (gate, walk, flags, insert) and
no binder or probe compare; `ref-definition-4` lights the probe, the symbol compare and
`compatible` and no builtin region; `definition-6` puts no sample in `reference` at all. The 22
`binder-setup` samples of `ref-distinct-6` and the 13 `arity-error` samples on ASCII are skid
from the adjacent region.

The executed-instruction column sums to about 491,000 inside the symbol, 39 per cent of the
1,246,011-instruction stage, and closes against the model: the model's fixed part of a reference is
71.49, and the path count for what every reference pays regardless of outcome — 24 prologue, 10
binder setup, 11 epilogue, the 2-instruction fall-through for the 1,600 non-hits, the 21-instruction
probe setup for those 1,600, and the 15 caller-side instructions in `run` (argument marshaling
with two stack-passed arguments, the call, the stack restore, the result-tag test and the two
register reloads after it) — is 24 + 10 + 11 + 0.9 + 9.5 + 15 = 70.4. The model's per-reference
coefficient was measuring the call shape.

**The shares are not costs.** With 15,889 samples over about 491,000 instructions, one sample is
31 instructions. The prologue's 5,944 samples read as 184,000 against 84,480 executed (2.2×): the
skid from `run`'s call instruction lands on `reference`'s first instructions. The one-byte binder
compare reads as 6,500 against 30,720 (0.2×): its samples land in the epilogue and back in `run`.
Symbol-same reads at 0.4×, probe-loop at 2.3×. The playbook's warning is quantified: on this
kernel a region's share can be off by a factor of two to five either way, and the sizing method
that survives is the disassembly path times the census count, with the profile used only to say
which regions run at all.

### `admit::declare` — 221 instructions, 0x8693c0–0x869730

| Region | instr | ascii | definition-6 | executed on ASCII |
|---|---:|---:|---:|---:|
| prologue | 22 | 374 (6.8 %) | 1.4 % | 22 × 640 ≈ 14,000 |
| header-chain | 13 | 450 (8.2 %) | 7.2 % | ≈ 10 per chain node × 1,088 ≈ 11,000 |
| count-arguments | 38 | 617 (11.2 %) | 0 | ≈ 18,000 (576 calls; `definition-6` has no parameter list) |
| name-flags, name-flags-b | 18, 29 | 380 (6.9 %) | 3.6 % | ≈ 14 × 640 ≈ 9,000 |
| error-exit | 6 | 0 | 0 | 0 |
| epilogue | 8 | 143 (2.6 %) | 31.5 % | 8 × 640 = 5,120 |
| hash-loop | 12 | 2,136 (38.8 %) | 16.4 % | 8 × 5,176 = 41,408 |
| insert | 47 | 1,406 (25.5 %) | 39.8 % | ≈ 40 × 640 ≈ 25,600 |
| errors-panics | 28 | 0 | 0 | 0 |
| **total** | 221 | 5,506 | 3,605 | **≈ 124,000** |

Against the model's 194.23 × 576 + 103.02 × 64 = 118,471 (the census had said the
`check_definition` header chain is charged to this coefficient too; the path count says the
declare-side chain alone is about 11,000 and the rest of the coefficient is the hash, the insert
and the fixed entry). The `definition-6` epilogue at 31.5 per cent is the same skid as
`reference`'s prologue, from the other side: samples from the inlined insert's index probe and the
return land there. Nothing in `declare` is above one per cent of the stage on its own; the hash
loop is 3.3 per cent of the stage and is the same loop as `reference`'s, so it is priced once
below.

### Every out-of-line call in the two symbols

`reference`: `RawVec::grow_one` at 0x86a307 (the `symbols.push` slow path, unreachable because
`insert` tests `symbols.len() < limits.symbols` first and the pool is reserved to that limit;
the compiler cannot prove it) and two `panic_bounds_check` sites at 0x86a3da/0x86a3ed (the
per-byte source indexing in `same()`). `declare`: `grow_one` at 0x869608 (the same push) and six
`panic_bounds_check` sites. None was sampled; all sit off the loop paths. The `grow_one` call is
a rule-2 item on the record: a `try_push`-shaped insert (push into a pre-checked slot) would
remove the cold call and its register save, worth a few instructions per insert at most, and is
not proposed on its own.

## Candidates, priced from the compiled paths

Against the ASCII admission stage of 1,245,431 instructions at `3bd5e38`.

1. **Remove the call shape of `reference` (about 50 per reference, 176,000, 14 per cent).**
   `reference` has two call sites, both in `run` (the `Atom` arm and the `Apply` callee), seven
   parameters of which two are stack-passed, six callee-saved registers pushed and popped, and a
   `Result` written through a pointer and re-read by the caller. `#[inline(always)]` on
   `reference` is the first shape (the compiler declined at 462 instructions and two sites);
   inlined, the hash, binder scan and probe run in `run`'s registers and the marshaling, pushes,
   pops and result store vanish, at the cost of whatever spills `run`'s loop then needs to keep
   its cursor and slice headers live around a much larger body. Fermi from the compiled shape:
   30 to 50 per reference, **106,000 to 176,000, 8.5 to 14 per cent**, and above the model's
   five-per-cent line. The fallback shape if register pressure eats the saving: an
   `#[inline(always)]` prefix (hash and binder scan, which returns for 1,920 of the 3,520
   references) and an out-of-line tail taking the hash for the 1,600 probes; that saves the
   whole call shape on the hits alone, about 96,000, 7.7 per cent.
2. **The hash loop's per-byte bounds check (2 of 8 per byte, 36,700, 2.9 per cent).** `hash_of`
   indexes `source[i]` under `while i < end`, and the compiler keeps the `cmp %rax,%r11; jae
   panic` pair per byte in all three inlined copies (`reference`, `declare`, `bind_list`).
   Slicing `source[start..end]` once and iterating the slice removes the pair: 6 per byte over
   18,333 bytes. Below the five-per-cent line, so its own A/B.
3. **`same()`'s two per-byte bounds checks (4 of 12–13 per byte, 20,500, 1.6 per cent).** Both
   compare loops test each index against the source length twice per byte. Two slices of equal
   length compared element by element (an explicit loop over a `zip`, never a slice `==`, which
   lowers to `bcmp`) drop both pairs: 8 to 9 per byte over 5,117 bytes.
4. **The pop's field loads** (traversal-cursor report, ledger item 7): 17,000 to 33,000, 1.3 to
   2.7 per cent, with the dependent-load cycle risk; unchanged by this task.
5. **Not worth doing, priced so it is not proposed.** `declare`'s header chain (11,000, 0.9 per
   cent, and merging it with `check_definition`'s descent is a structural change to the
   definitions pool for that gain); `count_arguments` in `declare` (18,000, but its loop is
   already seven instructions per node); the `grow_one` cold call (a few per insert); the
   `BUILTINS` walk (2,100); the index clear (1,798).

Items 1 to 3 together are 163,000 to 233,000, 13 to 19 per cent of the stage, and do not
interact: 2 and 3 change loops that 1 moves into `run` unchanged.

## Replay

`$C0` and `$C1` are `ergodis-tools` retained by `../ergodis-dev/scripts/retain-bin.sh tasks/tools
ergodis-tools` at `db47ee1` and `3bd5e38` respectively, each with that revision checked out; the
script re-executes itself under `nix develop ~/src/ergodis`. From `~/src/ergodis-private`:

```sh
E=instructions,cycles,branches,branch-misses,page-faults,minor-faults
python3 analysis/rel-frontend/bench.py --binary "$C1" --control "$C0" \
    --rounds 7 --cpu 5 --stages prepare,prepare-touch,parse,admit --events $E \
    --out analysis/rel-frontend/performance-v1-admit-scopes-3bd5e38.json
P=~/.cache/ergodis/perf-c1170
perf record -q -e instructions:u -F 10000 -o $P/admit-db47ee1-annot.data \
    -- taskset -c 7 "$C0" rel-frontend-bench --cohort ascii --stage admit --variant byte \
    --definitions 512 --repeat 60000
for s in ref-binder-1 ref-distinct-6 ref-definition-4 definition-6; do
  perf record -q -e instructions:u -F 10000 -o $P/annot-$s.data \
      -- taskset -c 7 "$C0" rel-frontend-bench --source-file $P/sources/$s.rel \
      --stage admit --variant byte --repeat 15000
done
python3 analysis/rel-frontend/annotate-buckets.py --binary "$C0" \
    --regions analysis/rel-frontend/annotate-regions-db47ee1.json \
    --profile ascii=$P/admit-db47ee1-annot.data --profile ref-binder-1=$P/annot-ref-binder-1.data \
    --profile ref-distinct-6=$P/annot-ref-distinct-6.data \
    --profile ref-definition-4=$P/annot-ref-definition-4.data \
    --profile definition-6=$P/annot-definition-6.data \
    --out analysis/rel-frontend/performance-v1-admit-annotate-db47ee1.json
python3 analysis/rel-frontend/admit-census.py $P/census/cohort-ascii.txt $P/census/cohort-ascii.nodes \
    --symbols 8192 --json $P/census-ascii-hash-bytes.json
```

The synthetic sources are regenerated by `admit-decompose.py` and the cohort dumps by
`admit-model.py`, as the census report records.

## Foreign tree

The repository carries the same uncommitted foreign files the previous C1170 reports name: the
campaign-console mockups and interface-review material under `analysis/`,
`packages/execution-provider/src/lib.rs`, `packages/hadamard-provider/tests/contracts.rs`,
`packages/parameterization-provider/tests/contracts.rs`, `src/hadamard_execution.rs`,
`src/partitioned_additive_join.rs`, `tests/partitioned_join_profile.rs` and
`tests/quadratic_residual_profile.rs`. Their diff hashed
`a954fbdceb3a9ea474c3406ec70e7419a7fd02b2026f400f21197fb7b6a2df28` at the start and at the end of
this task, the hash the five previous reports recorded. None was touched, staged or reverted; both
commits were made with explicit whole-file pathspecs. The retained candidate carries the manifest's
`dirty` flag for that reason; the two arms were built against the same foreign diff, which cancels
in every ratio and makes neither arm reproducible from its commit alone.

## Mystery ledger

1. **Settled: the `scopes` pool was dead and its removal is exactly the three clears.** Admission
   moved by 580 on ASCII for 577 clears, 577 on unicode, and parse by nothing; the fault count of
   `prepare-touch` did not move because the block was on the heap, not a mapping.
2. **Settled, with a corrected cost of one: a 2 KiB heap reservation and drop costs about 600
   instructions in `prepare`, not 150 to 300.** The Fermi priced a tcache fast path; the drop of
   a whole workspace each iteration takes the general path. Recorded for the next
   allocation-shaped Fermi.
3. **Settled: what the fixed part of a reference is.** 70.4 of the model's 71.49 is the path
   count of prologue, binder setup, epilogue, the probe setup for non-hits and the caller-side
   marshaling in `run`; 50 of those are the call shape. The coefficient was never "entry, the
   counter, the hash setup" in the loose sense the census report used; it was the calling
   convention.
4. **Settled: how far a share can be from a cost on this kernel without precise sampling.** 2.2×
   on the callee's entry region, 0.2× on a one-byte loop that ends in a return, 2.3× on the probe
   loop, 0.4× on the symbol compare. The validation classes light the right regions, so the map
   is right and the shares are skid; sizing is by path count.
5. **Settled: `declare` has no single candidate.** Its 124,000 is the 8-per-byte hash of 5,176
   name bytes (a third), the inlined insert (a fifth), argument counting, the header chain and
   the fixed entry; the hash-loop fix is shared with `reference`, and the rest is below one per
   cent each.
6. **Open: how much of the call shape inlining recovers.** The compiled shape prices 50 per
   reference; the compiler will spend register moves and spills to hold `run`'s cursor, both
   slice headers and `walk` across a body four times the size of the loop it joins. The lesson of
   the cursor A/B (21 per cent under the source-level Fermi) says to expect the lower half of the
   30-to-50 range, and only the candidate's disassembly and A/B will say. The evidence gap is the
   A/B of candidate 1, with the split-prefix shape held as the fallback.
7. **Open, measurement: no precise sampling on this host.** `instructions:upp` and `ibs_op` both
   fail to open under `perf_event_paranoid = 2`. If the user ever lowers it for a session, one
   IBS profile of the admit stage would put the shares and the path counts side by side and
   retire item 4's factor as a host fact rather than a per-region estimate. Not requested.
8. **Not a mystery: the `grow_one` call in both symbols.** It is the `Vec::push` slow path behind
   a length test that already excludes it; it is never taken and never sampled, and it sits on the
   record as an out-of-line call inside the stage per rule 2.

## Remaining next steps

Priced against the ASCII admission stage of 1,245,431 at `3bd5e38`; each is its own A/B against
`ergodis-tools-3bd5e38`.

1. **Inline `reference` into `run`** (candidate 1): 106,000 to 176,000, 8.5 to 14 per cent;
   `#[inline(always)]` first, the split prefix as the fallback. Read the candidate's `run`
   listing before the A/B and count the spills it added.
2. **The hash loop without its per-byte bounds check** (candidate 2): 36,700, 2.9 per cent, in
   all three callers at once.
3. **`same()` without its two per-byte bounds checks** (candidate 3): 20,500, 1.6 per cent;
   explicit loop, no slice `==`.
4. **The pop's field loads** (candidate 4): 17,000 to 33,000, with the cycle check.

Then, per the handoff: module-scoped visibility, module parameters and member tables in
admission; then the remaining syntax gaps by manifest family.

## What this task left under `~/.cache/ergodis/`

For the user's cache decision. Nothing was deleted, nothing large went to `/tmp`, and no
`~/.cache` path is cited as evidence.

| File | Size | Measured sha256 | What it is |
|---|---:|---|---|
| `bin/ergodis-tools-3bd5e38` | 15 MB | `41459b56…9761d782` | the kept candidate, rustc 1.95.0; the control for the next A/B |
| `perf-c1170/admit-db47ee1-annot.data` | 4.8 MB | — | the 60,000-iteration ASCII profile the annotate reads |
| `perf-c1170/annot-{ref-binder-1,ref-distinct-6,ref-definition-4,definition-6}.data` | 0.9–1.3 MB each | — | the four validation-class profiles |
| `perf-c1170/{reference,declare,run}-db47ee1.s` | small | — | the three symbol listings the region map and path counts were read from; regenerable from the retained binary |
| `perf-c1170/ip-hist-db47ee1.txt`, `annot-ascii-only.json`, `census-ascii-hash-bytes.{json,log}`, `annot-*.log`, `scopes-3bd5e38.log` | small | — | run logs and intermediate histograms |

The retained executable has a `MANIFEST.tsv` row and a `.sha256` sidecar.
`../ergodis-dev/scripts/cache-gc.sh` has not been run, since deletion is the user's call.
