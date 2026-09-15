# C1170 — `admit::reference` inlined into `admit::run`

**Lane**: `ergodis`
**Date**: 2026-09-14
**Repository**: `~/src/ergodis-private` (private, no public remote), branch `main`, at `93bb343`

**Control**: `ergodis-tools` built at revision `3bd5e38` and retained as `ergodis-tools-3bd5e38`
(retain recipe: `../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools` at that revision).
Measured sha256 `41459b567965583d6d67ef489d589acca1293b690731bb5581adf22f9761d782`, rustc 1.95.0
(59807616e 2026-04-14), release profile, no features.

**Candidate**: `ergodis-tools` built at revision `93bb343` and retained as `ergodis-tools-93bb343`
by the same recipe. Measured sha256
`520e6057add1dbd8e7607d22dedcca6886471fcd4c26ed71649f51cf8d648d18`, rustc 1.95.0 (59807616e
2026-04-14), release profile, no features.

Both hashes were verified with `sha256sum` before the first measurement and are the hashes the
receipt records. Every measurement, parity replay and profile in this report ran under
`nix develop ~/src/ergodis` (rustc 1.95.0, pinned through the core flake).

## Status

Complete. **The ASCII admission stage (`admit` − `parse`) is 0.911998 [0.911993, 0.912003] of the
control in instructions, 109,600 instructions removed from 1,245,430, 31.14 per reference over
3,520 references.** The Fermi predicted 0.86 to 0.915 and 106,000 to 176,000 removed: the
measurement lands inside that band at its shallow end, which is where the cursor A/B's lesson and
the previous report's ledger item 6 said to expect it. The full `admit` stage on ASCII with the
byte scanner is 0.970798 [0.970798, 0.970799]; unicode admission is 0.924552, comment-string
0.949239. Parse is 1.000000 on every cohort and both scanner variants except comment-string's byte
scanner, which moved by twelve instructions in 1,401,958 (1.000008) — described under Method.
The A/A instruction nulls run 0.999999 to 1.000004 across the five cohorts, every interval within
twelve parts per million of unity, so the protocol held and the candidate reads.

The disassembly says why the saving landed at the shallow end, and it is not register pressure
spread evenly over the two inlined copies. The two call sites in `run` are the `Atom` arm (2,496
of the ASCII references) and the `Apply` callee (1,024). Solving the per-site saving from the ASCII
and comment-string cohorts, which have different mixes of the two, gives **about 40 instructions
per reference removed at the `Atom` site and about 9 at the `Apply` site**. The `Apply`-arm copy
gives back nearly the whole call shape in stack traffic: its address range in the candidate's `run`
carries 27 stack stores and 97 stack reloads, against 13 and 15 in the `Atom`-arm range.

Every output gate passed on all 25 measured operations (equal tokens, nodes, failure, admission
summary, occupied and retained bytes, and fingerprint), the native/WASM canonical hash is unchanged
at `5a350e1f…` over 159 cases, and peak RSS fell by 12 KiB on every operation.

Vibe check: good, with one surprise worth a successor. The change is a clean win and the Fermi
held, but half the inlining is doing almost nothing, and the reason is visible in the listing
rather than inferred.

**Commits**:

| Commit    | Contents                                      | Disposition                             |
|-----------|-----------------------------------------------|-----------------------------------------|
| `93bb343` | `#[inline(always)]` on `admit::reference`, with the doc comment recording why | **kept** (vetted: ratios re-read from the receipt, the two `is_builtin` call sites confirmed in the listing, parity hash re-checked) |

## Fermi, written before the change

From the annotate report: `reference` has two call sites, both in `run`, seven parameters of which
two are stack-passed, six callee-saved registers pushed and popped, and a `Result` written through
a pointer and re-read by the caller. The call shape costs about 50 instructions per reference —
fifteen caller-side in `run`, a 24-instruction prologue and an 11-instruction epilogue. The ASCII
cohort admits 3,520 references. Inlined, the hash, binder scan and probe run in `run`'s registers
and the marshaling, pushes, pops and result store vanish, at the cost of whatever spills `run`'s
loop then needs. Predicted saving 30 to 50 per reference, **106,000 to 176,000 instructions of the
1,245,431-instruction ASCII admission stage, ratio 0.86 to 0.915**, minus whatever spills `run`
gains.

## Method

Event set `instructions,cycles,branches,branch-misses,page-faults,minor-faults`, six events, no
multiplexing: a direct `perf stat -x,` on the candidate's ASCII admit stage reports 100.00 per cent
enabled on all six. Seven interleaved rounds, all five cohorts, both scanner variants,
`--stages parse,admit`, pinned to CPU 5, output gate armed on every operation. One-minute load
average 5.92 at launch and 3.58 at finish; instruction ratios decide and cycles are quoted only
with their intervals. Receipt
`analysis/rel-frontend/performance-v1-admit-inline-93bb343.json`.

The whole crate builds with ThinLTO and one codegen unit, so a change can move code the diff does
not touch. One operation moved: comment-string's byte-scanner parse stage gained 11.6 instructions
in 1,401,958, ratio 1.000008 [1.000003, 1.000014]. That is four times its own A/A null and is a
real code-layout effect rather than drift, but it is eight parts per million and it is subtracted
out of the admission-only figure for that cohort, which is the number quoted. Every other parse
operation, on both scanners and all five cohorts, is 1.000000 with an interval inside two parts per
million.

A/A instruction nulls (byte-null over byte within each arm):

| Cohort          |    ratio | interval               |
|-----------------|---------:|------------------------|
| ascii           | 0.999999 | [0.999998, 1.000001]   |
| unicode         | 1.000001 | [1.000000, 1.000001]   |
| comment-string  | 1.000000 | [0.999997, 1.000003]   |
| malformed-early | 1.000004 | [0.999996, 1.000012]   |
| malformed-late  | 1.000000 | [0.999998, 1.000001]   |

## Results

Candidate over control, instructions per iteration, byte scanner and scalar scanner.

| Operation                       |      candidate |        control |    ratio | interval               |
|---------------------------------|---------------:|---------------:|---------:|------------------------|
| ascii/parse/byte                |    2,507,813.3 |    2,507,814.0 | 1.000000 | [0.999998, 1.000002]   |
| ascii/parse/scalar              |    3,868,231.5 |    3,868,231.3 | 1.000000 | [0.999999, 1.000001]   |
| ascii/admit/byte                |    3,643,643.0 |    3,753,243.9 | 0.970798 | [0.970798, 0.970799]   |
| ascii/admit/scalar              |    5,004,051.6 |    5,113,653.9 | 0.978567 | [0.978566, 0.978567]   |
| unicode/parse/byte              |    8,733,233.1 |    8,733,235.7 | 1.000000 | [0.999999, 1.000000]   |
| unicode/parse/scalar            |    9,549,997.0 |    9,549,996.2 | 1.000000 | [1.000000, 1.000001]   |
| unicode/admit/byte              |   10,056,610.9 |   10,164,607.9 | 0.989375 | [0.989375, 0.989375]   |
| unicode/admit/scalar            |   10,873,374.0 |   10,981,367.0 | 0.990166 | [0.990165, 0.990166]   |
| comment-string/parse/byte       |    1,401,969.5 |    1,401,957.9 | 1.000008 | [1.000003, 1.000014]   |
| comment-string/parse/scalar     |    1,899,599.6 |    1,899,598.9 | 1.000000 | [1.000000, 1.000001]   |
| comment-string/admit/byte       |    1,754,605.3 |    1,773,450.9 | 0.989374 | [0.989368, 0.989379]   |
| comment-string/admit/scalar     |    2,252,246.1 |    2,271,085.9 | 0.991704 | [0.991703, 0.991705]   |
| malformed-early/parse/byte      |    1,098,163.9 |    1,098,163.3 | 1.000001 | [0.999994, 1.000007]   |
| malformed-early/parse/scalar    |    2,456,424.0 |    2,456,424.6 | 1.000000 | [0.999998, 1.000001]   |
| malformed-early/admit/byte      |    1,098,165.5 |    1,098,166.4 | 0.999999 | [0.999990, 1.000009]   |
| malformed-early/admit/scalar    |    2,456,424.8 |    2,456,423.5 | 1.000001 | [1.000000, 1.000001]   |
| malformed-late/parse/byte       |    2,504,006.9 |    2,504,007.6 | 1.000000 | [0.999998, 1.000001]   |
| malformed-late/parse/scalar     |    3,862,637.9 |    3,862,637.1 | 1.000000 | [1.000000, 1.000001]   |
| malformed-late/admit/byte       |    2,504,007.9 |    2,504,006.7 | 1.000000 | [1.000000, 1.000001]   |
| malformed-late/admit/scalar     |    3,862,639.4 |    3,862,639.0 | 1.000000 | [0.999999, 1.000001]   |
| prepare (standalone)            |        5,866.4 |        5,862.1 | 1.000741 | [1.000096, 1.001386]   |

The two malformed cohorts fail in the parser before admission runs, so their admit stage equals
their parse stage and both are inside their nulls, as they should be. `prepare` moved by four
instructions upward; it is a standalone stage the change does not touch, and four instructions in
5,862 is the layout noise this receipt's `prepare` measurement carries.

Admission alone (`admit` − `parse`), instructions, with the absolute count removed:

| Cohort / variant        |   candidate |     control |    ratio | interval               | removed | per reference |
|-------------------------|------------:|------------:|---------:|------------------------|--------:|--------------:|
| ascii / byte            | 1,135,829.7 | 1,245,429.9 | 0.911998 | [0.911993, 0.912003]   | 109,600 |         31.14 |
| ascii / scalar          | 1,135,820.1 | 1,245,422.5 | 0.911996 | [0.911993, 0.911999]   | 109,602 |         31.14 |
| unicode / byte          | 1,323,377.8 | 1,431,372.3 | 0.924552 | [0.924549, 0.924555]   | 107,995 |         30.68 |
| unicode / scalar        | 1,323,377.0 | 1,431,370.8 | 0.924552 | [0.924547, 0.924558]   | 107,994 |         30.68 |
| comment-string / byte   |   352,635.8 |   371,493.0 | 0.949239 | [0.949210, 0.949268]   |  18,857 |         24.55 |
| comment-string / scalar |   352,646.5 |   371,487.0 | 0.949283 | [0.949273, 0.949294]   |  18,841 |         24.53 |
| malformed-early / byte  |         1.6 |         3.2 |        — | no admission runs      |       — |             — |
| malformed-late / byte   |         1.0 |        −0.8 |        — | no admission runs      |       — |             — |

The intervals on the admission-only rows propagate the two stages' standard deviations through the
difference at seven rounds; the receipt's own intervals are on the undifferenced stages.

Other events on the two ASCII byte-scanner operations:

| Operation        | Event         |    ratio | interval               | candidate | control |
|------------------|---------------|---------:|------------------------|----------:|--------:|
| ascii/admit/byte | instructions  | 0.970798 | [0.970798, 0.970799]   | 3,643,643.0 | 3,753,243.9 |
| ascii/admit/byte | cycles        | 0.966774 | [0.944263, 0.989822]   |   615,897.3 |   637,057.9 |
| ascii/admit/byte | branches      | 0.985218 | sd 0.22 and 0.43       |   785,359.3 |   797,142.4 |
| ascii/admit/byte | branch-misses | 0.965807 | [0.222154, 4.198808]; inconclusive | 240.1 | 280.2 |
| ascii/parse/byte | instructions  | 1.000000 | [0.999998, 1.000002]; inconclusive | 2,507,813.3 | 2,507,814.0 |
| ascii/parse/byte | cycles        | 1.003067 | [0.988981, 1.017353]; inconclusive |   407,645.3 |   406,397.6 |
| ascii/parse/byte | branches      | 1.000000 | sd 0.46 and 0.49       |   542,562.2 |   542,562.3 |
| ascii/parse/byte | branch-misses | 0.427123 | [0.052774, 3.456874]; inconclusive |  88.4 |   137.5 |

Cycles on the admit stage track the instruction ratio within their interval, so the change bought
no extra stall and paid none. Branch-miss counts are two hundred per iteration against three and a
half million instructions and their intervals span an order of magnitude either way; nothing is
read from them. Page faults and minor faults are zero per iteration on both arms for both stages.

Admission-only branches: ASCII 242,797.1 against 254,580.1, ratio 0.953716, 11,783 branches removed,
3.35 per reference — the `call` and the `ret` of each reference plus the dispatch and result tests
the inlining folded away. Unicode removes 11,772, comment-string 1,921.

Peak RSS, from the binary's own high-water record in the receipt: 5,992 KiB candidate against 6,004
KiB control on `ascii/admit/byte` and `ascii/admit/scalar`, 5,964 against 5,976 on the ASCII parse
operations, and 12 KiB lower in the candidate on every one of the 25 operations. The candidate's
file is 624 bytes larger than the control's, so the lower high-water mark is a mapping-layout
effect and not a smaller program; it is recorded, not explained.

## Disassembly

`objdump -d --no-show-raw-insn -M intel` on both retained binaries, symbols extracted to
`~/.cache/ergodis/perf-c1170/run-3bd5e38.s`, `reference-3bd5e38.s` and `run-93bb343.s`.

| Measure                                    | control `run` | control `reference` | control pair | candidate `run` |
|--------------------------------------------|--------------:|--------------------:|-------------:|----------------:|
| instructions in the symbol                 |           336 |                 474 |          810 |             854 |
| of which on the cold panic tail            |            41 |                 110 |          151 |              68 |
| callee-saved `push` in the prologue         |             6 |                   6 |           12 |               6 |
| matching `pop` in the epilogue              |             6 |                   6 |           12 |               6 |
| stack frame                                | `sub rsp,0x48` |      `sub rsp,0x68` |            — |  `sub rsp,0x98` |
| stack stores `mov PTR [rsp+…], reg`, hot    |             6 |                  24 |           30 |              40 |
| stack reloads `mov reg, PTR [rsp+…]`, hot   |            24 |                  31 |           55 |             112 |
| `rbp`-relative accesses                     |             1 |                   0 |            1 |               1 |

`admit::reference` is gone from the candidate as a symbol. The candidate's `run` is 854
instructions against the control pair's 810, so the two inlined copies cost 44 instructions of
static text net of the prologue, epilogue and one copy of the body that disappeared. Both functions
push and pop the same six callee-saved registers (`rbp`, `r15`, `r14`, `r13`, `r12`, `rbx`); the
candidate pays that set once per `run` call instead of once per `run` call plus once per reference.

Every `call` instruction inside `run`:

| Binary  | Address    | Target                                | Kind                                    |
|---------|------------|---------------------------------------|-----------------------------------------|
| control | `0x868f41` | `admit::reference`                    | hot, the `Atom` arm                     |
| control | `0x868f8c` | `admit::bind_list`                    | hot                                     |
| control | `0x869196` | `admit::reference`                    | hot, the `Apply` callee                 |
| control | `0x8692f6` | `core::slice::index::slice_index_fail` | cold panic path                        |
| control | seven sites from `0x869306` | `core::panicking::panic_bounds_check` | cold panic paths        |
| candidate | `0x8691e0` | `admit::bind_list`                  | hot                                     |
| candidate | `0x869853`, `0x86995d` | `admit::is_builtin`     | hot, first-sight path, **new out of line** |
| candidate | `0x8698a9`, `0x869a01` | `alloc::raw_vec::RawVec::grow_one` | cold, the `symbols.push` slow path behind a length test that excludes it |
| candidate | `0x869c5b` | `core::slice::index::slice_index_fail` | cold panic path                       |
| candidate | eighteen sites from `0x869c6b` | `core::panicking::panic_bounds_check` | cold panic paths   |

The control's `reference` calls `grow_one` once at `0x86a2d7` and `panic_bounds_check` at twelve
sites, all cold. **No libc symbol is called from either binary's `run` or from the control's
`reference`**: no `memcmp`, `memcpy`, `memset` or `bcmp` appears in any of the three listings, so
the per-byte name compares are still compiled as explicit loops, as the previous report required.

One regression the listing shows: `admit::is_builtin` was inlined inside `reference` in the control
and is an out-of-line call at two sites in the candidate. It sits on the first-sight path (905
first sights on ASCII) and the profile below puts it at 0.57 per cent. That call shape is now the
kind of item the previous report's rule-2 record was written for.

### Compiled per-reference path count

Control, the `Atom` call site at `0x868f2a`: `lea rdi,[rsp+0x20]` for the `Result` slot, three
register arguments, `xor r9d,r9d`, two `push 0x0` for the stack-passed pair, the `call`, `add
rsp,0x10`, and `cmp WORD PTR [rsp+0x2c],0x17` re-reading the result tag from the stack — eleven
instructions, plus the reloads the joined path takes afterward. The `Apply` call site at
`0x869174` runs sixteen: two `movzx`, an `and`, the `lea`, three register arguments, two `push`,
the `call`, the `add rsp`, the tag test, and three register reloads (`mov rbp,r12`,
`mov r10,[rsp+0x38]`, `mov r9,[rsp+0x30]`).

Control `reference`, `0x869ce0` to `0x869d2f`: exactly 24 instructions before the hash loop at
`0x869d30` — six pushes, `sub rsp,0x68`, three argument spills, the `inc DWORD PTR [rdx+0x20]`
reference counter, the two source-slice loads, the FNV offset basis, the length subtract and its
`jbe`, a reload, and the alignment `nop`. Its main return path at `0x86a38a` is nine: the result
store through `rcx`, `add rsp,0x68`, six pops and `ret`.

Candidate, the `Atom`-arm copy: the same dispatch test `cmp cx,0x1 / jne` at `0x869085`, then ten
instructions to the hash loop at `0x8690b0` — `mov rax,[rsp+0x60]`, the same
`inc DWORD PTR [rax+0x20]`, the two source-slice loads into `rdi` and `rsi`, the FNV offset basis
into `r14d`, the length subtract and `jbe`, the index into `rax`, and the padding `nop`. The hash
loop is the same eight instructions. After it, two new stack stores (`mov [rsp+0x48],edx` and
`mov [rsp+0x10],r8`) before the binder test. The `Apply`-arm copy is ten to the hash loop at
`0x8693e0` and three stack stores after it.

So the control's fixed call shape per `Atom`-arm reference is 11 caller-side + 24 prologue + 11
epilogue ≈ 46; the candidate replaces it with 10 + 2 = 12, predicting about 34 removed against the
Fermi's 50. For the `Apply` arm the control's shape is 16 + 24 + 11 ≈ 51 against the candidate's
10 + 3 = 13, predicting about 38.

The measurement does not split that way. Solving the two-site decomposition from the ASCII cohort
(2,496 `Atom`-arm references, 1,024 `Apply`-arm, 109,600 removed) together with comment-string (384
and 384, 18,857 removed) gives **40.3 removed per `Atom`-arm reference and 8.8 per `Apply`-arm
reference**; substituting unicode for ascii gives 39.2 and 9.9. The `Atom`-arm copy beat its path
count slightly, since the joined path also drops reloads the caller used to need. The `Apply`-arm
copy came in about thirty instructions per reference below its path count, and the listing shows
where: the address range `0x8693aa`–`0x869c5b` that holds that copy carries 27 stack stores and 97
stack reloads, against 13 and 15 in the `Atom`-arm range `0x868f50`–`0x8693aa`. The `Apply` path
enters the inlined body with the application node, its argument count and both slice headers live,
and the compiler spills them across a body four times the size of the loop it joined.

## Kernel-scoped profile of the candidate

`perf record -q -e instructions:u -F 10000`, ASCII cohort, byte scanner, 512 definitions, 60,000
iterations of the admit stage, pinned to CPU 7 (the A/B held CPU 5), one-minute load average 1.18
at launch. 120,000 samples, no lost samples, 218,630,828,942 instructions.
`~/.cache/ergodis/perf-c1170/admit-93bb343.data`. Every symbol above 0.1 per cent:

| Share   | Symbol                                            |
|--------:|---------------------------------------------------|
| 35.79 % | `rel_frontend::parser::Parser::expression`        |
| 26.30 % | `rel_frontend::Workspace::scan_variant`           |
| 20.18 % | `rel_frontend::admit::run`                        |
|  4.59 % | `rel_frontend::admit::declare`                    |
|  3.07 % | `rel_frontend::admit::bind_list`                  |
|  2.91 % | `rel_frontend::Workspace::admit`                  |
|  2.84 % | `rel_frontend::lexer::keyword`                    |
|  2.03 % | `rel_frontend::parser::Parser::item`              |
|  0.74 % | `rel_frontend::parser::Parser::node`              |
|  0.57 % | `rel_frontend::admit::is_builtin`                 |
|  0.51 % | `core::str::converts::from_utf8`                  |
|  0.39 % | `rel_frontend::parser::parse`                     |

No libc symbol, no allocator symbol, no panic or formatting symbol appears anywhere in the profile.
`core::str::converts::from_utf8` is the frontend's own source validation and was present before
this change. `admit::is_builtin` is the new out-of-line symbol the disassembly names; it did not
appear in the control's profile because it was inlined into `reference` there. `admit::run` at
20.18 per cent now holds what `admit::reference` (13.5 per cent) and part of `run` held in the
control's profile, as expected. The shares carry the same skid this host's sampling always
carries — no precise sampling is available under `perf_event_paranoid = 2` — so they are read only
for which symbols run, not for what they cost.

## Parity

`python3 analysis/rel-frontend/portability.py --output analysis/rel-frontend/portability-v1.json`
under the pinned toolchain: **159 cases, 345,993 canonical bytes, native and WASM byte-equal, canonical
SHA-256 `5a350e1f524b26da61186320414785045d9f39a71c4b34b40f9bd78d3516cbfa`**, unchanged. The receipt
diff is two lines: `native_library_sha256` moved from `173bc6e9…` to `8bb3f080…` and
`wasm_library_sha256` from `aba9d87a…` to `c277b1c1…`, which is the rebuilt library for the two
targets and nothing else. No case, no canonical byte and no source hash in the receipt moved.

## Gates

| Gate                          | Command                                                                                                     | Outcome |
|-------------------------------|-------------------------------------------------------------------------------------------------------------|---------|
| Frontend tests                | `cargo test --release -p ergodis-private --test rel_frontend --test rel_frontend_portability -j 4`            | 24 + 1 passed, 0 failed, at `93bb343` before retain, as run by the lead |
| Zero allocation               | inside that run                                                                                              | unchanged: zero allocations and unchanged retained bytes over ten rounds |
| Clippy, library and both test targets | `cargo clippy --release -p ergodis-private --lib --test rel_frontend --test rel_frontend_portability -j 4 -- -D warnings` | no diagnostics, as run by the lead |
| Clippy, tools binary          | `cargo clippy --release -p ergodis-tools --bins -j 4 -- -D warnings`                                         | no diagnostics, as run by the lead |
| Formatting                    | `rustfmt --check --edition 2021 src/rel_frontend/admit.rs`                                                   | clean, as run by the lead |
| Native/WASM parity replay     | `python3 analysis/rel-frontend/portability.py --output analysis/rel-frontend/portability-v1.json`             | 159 cases, canonical SHA-256 unchanged; only the two library hashes moved |
| Driver output gate            | armed on every operation of the A/B                                                                           | equal tokens, nodes, failure, admission summary, occupied bytes, retained bytes and fingerprint on all 25 operations |
| Event set                     | `instructions,cycles,branches,branch-misses,page-faults,minor-faults`                                        | 100.00 per cent enabled on all six, `perf stat -x,` on the candidate's ASCII admit stage |
| Retained bytes                | from the receipt records                                                                                      | 6,539,264 on both arms |

## Where the Fermi was right, and where the shape surprised

The Fermi's band held: 0.911998 measured against 0.86 to 0.915 predicted, 109,600 removed against
106,000 to 176,000 predicted, 31.14 per reference against 30 to 50. The previous report's ledger
item 6 said to expect the lower half of that range because of the spills `run` would gain, and that
is what happened.

What the band hid is that the outcome is not one number repeated at two sites. The `Atom`-arm copy
removed 40.3 per reference, at the top of the Fermi's range and slightly above its own compiled
path count; the `Apply`-arm copy removed 8.8, about thirty below its path count. Had the ASCII
cohort's reference mix been the comment-string cohort's even split, the stage ratio would have
been about 0.980 instead of 0.912 and the change would have read as barely worth keeping. The
sizing method that survives is still the path count times the census, but the census term has to be
per call site once a body is inlined at more than one, because register pressure is a property of
the site and not of the body.

## Replay

`$C0` is `ergodis-tools` retained at `3bd5e38` and `$C1` at `93bb343`, each by
`../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools` with that revision checked out;
the script re-executes itself under `nix develop ~/src/ergodis`. From `~/src/ergodis-private`, with
every command prefixed `nix develop ~/src/ergodis -c`:

```sh
E=instructions,cycles,branches,branch-misses,page-faults,minor-faults
P=~/.cache/ergodis/perf-c1170

# non-multiplexing check on the candidate's admit stage
perf stat -x, -e $E -- taskset -c 5 "$C1" rel-frontend-bench \
    --cohort ascii --stage admit --variant byte --definitions 512 --repeat 2000

# the A/B
python3 analysis/rel-frontend/bench.py --binary "$C1" --control "$C0" \
    --rounds 7 --cpu 5 --stages parse,admit --events $E \
    --out analysis/rel-frontend/performance-v1-admit-inline-93bb343.json

# parity
python3 analysis/rel-frontend/portability.py \
    --output analysis/rel-frontend/portability-v1.json

# kernel-scoped profile of the candidate
perf record -q -e instructions:u -F 10000 -o $P/admit-93bb343.data \
    -- taskset -c 7 "$C1" rel-frontend-bench --cohort ascii --stage admit \
    --variant byte --definitions 512 --repeat 60000
perf report --stdio --sort sym -i $P/admit-93bb343.data
```

The disassembly, ambient rather than under the flake:

```sh
for r in 3bd5e38 93bb343; do
  objdump -d --no-show-raw-insn -M intel ~/.cache/ergodis/bin/ergodis-tools-$r > $P/all-$r.txt
done
# admit::run extracted from each, admit::reference from the control only
```

Console logs: `$P/inline-93bb343.log`, `$P/parity-93bb343.log`, `$P/record-93bb343.log`.

## Foreign tree

The repository carries the same uncommitted foreign files the previous C1170 reports name: the
campaign-console mockups and interface-review material under `analysis/`,
`packages/execution-provider/src/lib.rs`, `packages/hadamard-provider/tests/contracts.rs`,
`packages/parameterization-provider/tests/contracts.rs`, `src/hadamard_execution.rs`,
`src/partitioned_additive_join.rs`, `tests/partitioned_join_profile.rs` and
`tests/quadratic_residual_profile.rs`. Their diff hashed
`a954fbdceb3a9ea474c3406ec70e7419a7fd02b2026f400f21197fb7b6a2df28` at the start and again at the
end of this task, the hash the six previous reports recorded, and **still equals it**. None was touched, staged or
reverted. The retained candidate carries the manifest's `dirty` flag for that reason; both arms
were built against the same foreign diff, which cancels in every ratio and makes neither arm
reproducible from its commit alone.

## Mystery ledger

1. **Settled: how much of the call shape inlining recovers.** 31.14 instructions per reference on
   ASCII, 109,600 of 1,245,430, ratio 0.911998 [0.911993, 0.912003]. This closes the previous
   report's open item 6. The answer is the lower half of the Fermi's 30-to-50 range, as that item
   predicted, and the mechanism is the spills the enlarged `run` gained.
2. **Settled, and the surprise of this task: the two call sites do not pay the same.** The
   `Atom`-arm copy removes about 40 per reference and the `Apply`-arm copy about 9, solved from the
   ASCII and comment-string mixes and cross-checked against unicode. The listing confirms it: 27
   stack stores and 97 reloads in the `Apply`-arm range against 13 and 15 in the `Atom`-arm range.
   Per-site pricing is now required for any future inline of a body with more than one caller.
3. **Open: whether the `Apply`-arm copy's stack traffic can be reduced.** The copy gives back about
   thirty of its thirty-eight predicted instructions per reference. Reducing the live set across
   that site — hoisting the argument-count and slice-header reads, or narrowing the inlined body at
   that site to the prefix shape the previous report held as the fallback — is worth one A/B against
   `ergodis-tools-93bb343`. Upper bound if it recovered fully: 1,024 × 30 ≈ 31,000 on ASCII, 2.5 per
   cent of the stage. The evidence gap is a path count of that copy, which this task did not do.
4. **Open: `admit::is_builtin` became an out-of-line call at two sites.** It was inlined inside
   `reference` in the control and is 0.57 per cent of the candidate's profile, on the 905-first-sight
   path. It is a new call shape inside the stage, of the exact kind this lane's rule 2 records; its
   cost has not been priced and it did not stop the change from winning.
5. **Open, minor: peak RSS fell by 12 KiB on every operation while the binary grew by 624 bytes.**
   The high-water mark is lower in the candidate on all 25 operations, consistently, which rules out
   noise, and the direction is opposite to the text-size change. It is a mapping-layout effect that
   costs nothing and is recorded rather than explained.
6. **Open, minor: comment-string's byte-scanner parse stage moved by 11.6 instructions in
   1,401,958** (1.000008 [1.000003, 1.000014], four times its own null), while every other parse
   operation is 1.000000. ThinLTO with one codegen unit makes that possible from a change in a
   different module, and the admission-only figure for that cohort subtracts it. No kernel claim
   depends on it.
7. **Not a mystery: the cold calls.** `grow_one` at two sites in the candidate is the `Vec::push`
   slow path behind a length test that already excludes it, as in the control; nineteen
   `panic_bounds_check` and `slice_index_fail` sites sit on the cold tail, none sampled. The
   per-byte bounds checks that produce them are candidates 2 and 3 on the lane's remaining list and
   are untouched here.
8. **Settled: no libc call entered the stage.** No `memcmp`, `memcpy`, `memset` or `bcmp` appears in
   either binary's `run` or the control's `reference`, and no libc, allocator, panic or formatting
   symbol appears in the candidate's profile. The per-byte compares are still explicit loops.

## Remaining next steps

Tavis's call at this task's close (2026-09-14): the frontend micro-optimization sequence stops here
and the lane moves on to end-to-end features. The priced candidates below are recorded for a later
resumption, each an A/B against `ergodis-tools-93bb343`; none is queued.

1. The `Apply`-arm copy's stack traffic (ledger item 3): up to about 31,000 on ASCII, 2.5 per cent.
2. The hash loop without its per-byte bounds check: 36,700, 2.9 per cent, three callers.
3. `same()` without its two per-byte bounds checks: 20,500, 1.6 per cent; explicit loop, no slice `==`.
4. The pop's field loads: 17,000 to 33,000, with the cycle check.
5. Pricing the new out-of-line `is_builtin` call (ledger item 4).

## What this task left under `~/.cache/ergodis/`

For the user's cache decision. Nothing was deleted, nothing large went to `/tmp`, and no
`~/.cache` path is cited as evidence.

| File                                        | Apparent size | Measured sha256      | What it is |
|---------------------------------------------|--------------:|----------------------|------------|
| `bin/ergodis-tools-93bb343`                  |         15 MB | `520e6057…d8648d18`  | the candidate, rustc 1.95.0; the control for the next A/B if the change is kept |
| `bin/ergodis-tools-3bd5e38`                  |         15 MB | `41459b56…9761d782`  | the control for this A/B, retained by the previous task |
| `perf-c1170/admit-93bb343.data`              |        4.7 MB | —                    | the 60,000-iteration ASCII profile of the candidate |
| `perf-c1170/all-3bd5e38.txt`                 |        116 MB | —                    | the control's full disassembly; an intermediate, regenerable from the retained binary in one `objdump` |
| `perf-c1170/all-93bb343.txt`                 |        116 MB | —                    | the candidate's full disassembly; likewise regenerable |
| `perf-c1170/run-93bb343.s`                   |         42 KB | —                    | the candidate's `admit::run` listing, the source of every disassembly count above |
| `perf-c1170/run-3bd5e38.s`                   |         17 KB | —                    | the control's `admit::run` listing |
| `perf-c1170/reference-3bd5e38.s`             |         24 KB | —                    | the control's `admit::reference` listing |
| `perf-c1170/{inline,parity,record}-93bb343.log` |         small | —                 | the three console logs |

The two full disassembly dumps are 232 MB of apparent size between them and are the only large
items this task added beyond the profile; they are pure intermediates. The directory reports 103 MB
on disk, so the filesystem is compressing them. `../ergodis-dev/scripts/cache-gc.sh` has not been
run, since deletion is the user's call.
