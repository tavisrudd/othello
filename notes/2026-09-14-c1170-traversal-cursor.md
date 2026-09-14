# C1170 — the traversal stack cursor and the hoisted scan reloads in admission

**Lane**: `ergodis`
**Date**: 2026-09-14
**Repository**: `~/src/ergodis-private` (private, no public remote), branch `main`, from `6d27015`

**Control**: `ergodis-tools` built at revision `49bbb9a` and retained as `ergodis-tools-49bbb9a`
(retain recipe: `../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools` at that revision).
Measured sha256 `06f946d59fc73657a799c4c9e8182aca0c64b82bc2186fd9e86768c739636c7a`, rustc 1.95.0,
release profile, no features. `git diff --stat 49bbb9a 6d27015 -- src/ tests/ tasks/` is empty, so
the Rust sources this task starts from are the ones the control was built from.

Every build, test, Clippy run, retain and measurement in this report runs under
`nix develop ~/src/ergodis` (rustc 1.95.0, pinned through the core flake).

## Status

Complete, two candidates built and both kept. **The ASCII admission stage is 0.9247
[0.924731, 0.924752] of the retained control `ergodis-tools-49bbb9a`** — 1,246,010 instructions
against 1,347,414, a saving of 101,404 per admission of a 43,008-byte source; unicode 0.9335 and
comment-string 0.9439. The two ratios measured one at a time are 0.9614 (the traversal stack
cursor) and 0.9619 (the hoisted scan); their product is 0.92477 against 0.92474 end to end. The
parse stage is 1.000000 in all three A/B runs, `prepare`, retained bytes and peak RSS are
unchanged, and every gate passed: 24 + 1 tests, zero allocations, strict Clippy, the native/WASM
canonical hash unchanged at `5a350e1f…`, the driver's admission-summary and fingerprint gate armed
on every operation. Since the admission work began on 2026-09-14 the stage stands at 0.7145 of
`ergodis-tools-185015e`.

Both Fermis were priced from the compiled loop rather than from the fitted model, and both landed
inside the compiled reading: the cursor at 6.26 instructions per visit against a 4-to-8 reading
(the source-level count of 66,000 was 27 per cent high, because the compiler adds register moves
to hold the new invariants), the scan hoist at 4.24 per node against a reading of four (6 per
cent under), with the branch count moving by exactly one per pool node.

Vibe check: good. Two for two, the savings compose exactly, and the traversal's share of the
stage fell from 12.5 to 7.6 per cent; the next terms are each a few per cent and the model that
ranks them is stale until the census is brought up to the kernel.

**Commits** (all on `main`, in order):

| Commit | Contents | Disposition |
|---|---|---|
| `5578357` | candidate A: the visits pool sized to `Limits::depth` and, with the node pool, moved out of the workspace for the body checks; the traversal carries its stack length by value | **kept** |
| `db47ee1` | candidate B: the pools leave the workspace before the declaring scan, which iterates the local slice; `declare` takes it | **kept** |
| `11fc4d0` | the three A/B receipts and the frontend README's section on them | — |

## Candidate A — the traversal stack cursor

### Fermi, written before the change

The decomposition report's 39.95 instructions per visited node is checked against `admit::run` as
`ergodis-tools-49bbb9a` compiles it before anything is built. The loop head (`829af0`–`829b5a`)
is the pop: it reloads `visits.len` from the workspace, tests it, stores `len − 1` back, reloads
the visits base pointer, loads the entry, tests it for a scope close, reloads `nodes.len`, bounds
checks, reloads the nodes base pointer, loads six node fields and dispatches through the jump
table — 24 instructions, of which five are workspace reloads and write-backs that a register
cursor does not execute (`visits.len` load, its write-back, the visits pointer, `nodes.len`, the
nodes pointer). The first push after a pop reuses the popped slot: the compiler proves the index
is inside capacity and emits the depth-limit reload, compare and branch, two field stores and the
length write-back, six instructions, one of which (the limit reload) is removable. A second push
in the same arm reloads the limit, compares, reloads the capacity and compares it, reloads the
base pointer, stores two fields, increments and writes the length back — ten instructions, five
removable. With the pop at 24 and the pushes at 6 and 10, a `Binary` visit is 40 instructions
and an `Atom` visit is 24 plus the call setup for `reference`; the 39.95 coefficient is credible
as a mix and is not what prices the candidate. The compiled loop is.

Counts from the committed census (`performance-v1-admit-model-185015e.json`, ASCII cohort; the
kernel changes since then did not touch the traversal): 8,320 visits, 256 scope closes, 8,576
pushes, of which 576 are the body pushes in `check_definition`. Pushes inside `run` are therefore
about 8,000, split roughly evenly between first and second pushes.

Predicted saving on ASCII: pops 5 × 8,320 + 3 × 256 ≈ 42,400; pushes 4,000 × 1 + 4,000 × 5 ≈
24,000; **about 66,000 instructions, 4.9 per cent of the 1,347,415-instruction stage**, with a
plausible range of 55,000 to 75,000 (4.1 to 5.6 per cent) depending on the first/second push split.
The cost added: the stack storage is sized once per workspace (a 4 KiB pool, sized on the first
admission the way the index is), and the nodes and visits pools are moved out of and back into
the workspace once per admission, twelve instructions. Unicode has the same traversal counts, so
the same absolute saving is 4.3 per cent of 1,533,927; comment-string has 1,920 visits and 1,920
pushes, about 14,000 instructions, 3.6 per cent of 394,105.

### The shape

The risk named in advance by the previous report is that the traversal mutates `w.binders` and
`w.symbols` through `reference`, so the stack cannot be hoisted the way the scanner's token cursor
was. The shape that resolves it without `unsafe`: the visits pool is sized to exactly
`Limits::depth` entries on the first admission and then moved out of the workspace by
`std::mem::take` for the duration of the body checks (a three-word move, no allocation, the empty
`Vec` left behind allocates nothing) and moved back before the result is returned; the node pool
is moved out the same way so that `nodes: &[Node]` is a local fat pointer. The stack length is a
plain local `usize` passed by value and returned by every function that pushes (`bind_list`,
`bind_one`, `push`), so its address never escapes and the compiler keeps it in a register across
the whole loop, including across the calls to `reference`, which takes `&mut Workspace` as before.
The depth limit is the slice length, so the push's capacity test and its bounds check are one
compare. The pop uses `stack.get(len − 1)` so the loop exit and the bounds check are one compare.

### The compiled shape, `ergodis-tools-5578357`

`admit::run` is 336 instructions against the control's 425. `reference` (474) and `declare` (233)
are unchanged, so candidate A changed nothing about the name-resolution path; `check_definition`,
`check_bodies` and `push` have no symbol and are inlined, and `Workspace::admit` grows to 449
from 295 by absorbing them. The loop head is now `mov; dec; cmp <spilled stack.len>; jae; load
entry; cmp NONE; je; mov; cmp nodes.len; jbe; shl; six field loads; lea; movslq; add; jmp` —
20 instructions against 24, with the jump-table base rematerialized each pop where the control
hoisted it. The first push after a pop is two stores and a register move (three instructions
against six; the compiler proves the popped slot is in bounds, and the depth-limit reload is
gone). A second push is two moves, a compare against the spilled length, a branch, two stores,
an increment and a move — eight against ten. A `Binary` visit is therefore about 32 instructions
against 40, an `Atom` visit about 20 against 24, and the compiled reading of the saving is
**4 to 8 per visit, 33,000 to 66,000 on ASCII**, whose lower half is below the Fermi's range
because the compiler spends register moves keeping the cursor and both slice headers live.

### A/B, candidate `5578357` over control `49bbb9a`

Seven interleaved rounds, all five cohorts, both scanner variants, `--stages parse,admit`, CPU 5,
event set `instructions,cycles,branches,branch-misses,page-faults,minor-faults`, fingerprint and
admission-summary gate armed on every operation. One-minute load average 10.19 at launch (the
retain build had just finished) and 4.45 after; the box is shared, so cycle ratios are wide and
instruction ratios decide. Receipt `analysis/rel-frontend/performance-v1-admit-cursor-5578357.json`.

The A/A instruction nulls are 0.999996 to 0.999999 on all five cohorts, every interval within six
parts per million of unity. **The parse stage is 1.000000 on every cohort and both variants**, so
no ThinLTO shift of the scanner or parser, and the admission difference and the stage ratio agree.

| Operation | candidate | control | ratio |
|---|---:|---:|---:|
| ascii/parse/byte | 2,507,813 | 2,507,813 | 1.000000 |
| ascii/parse/scalar | 3,868,230 | 3,868,231 | 1.000000 |
| ascii/admit/byte | 3,803,165 | 3,855,228 | **0.986496** |
| ascii/admit/scalar | 5,163,575 | 5,215,637 | 0.990018 |
| unicode/parse/byte | 8,733,240 | 8,733,237 | 1.000000 |
| unicode/admit/byte | 10,215,027 | 10,267,152 | 0.994923 |
| comment-string/parse/byte | 1,401,966 | 1,401,967 | 1.000000 |
| comment-string/admit/byte | 1,788,433 | 1,796,075 | 0.995745 |
| malformed-early/admit/byte | 1,098,170 | 1,098,172 | 0.999998 |
| malformed-late/admit/byte | 2,504,015 | 2,504,014 | 1.000001 |
| prepare | 6,491 | 6,490 | 1.000113 |

Admission alone, as `admit` minus `parse` on the same cohort and variant, with the interval from
the round-to-round standard deviations of the two stages:

| Cohort / variant | candidate | control | ratio | interval | saved |
|---|---:|---:|---:|---|---:|
| ascii / byte | 1,295,352 | 1,347,415 | **0.9614** | [0.961352, 0.961371] | 52,062 |
| ascii / scalar | 1,295,345 | 1,347,407 | 0.9614 | [0.961354, 0.961370] | 52,061 |
| unicode / byte | 1,481,787 | 1,533,915 | 0.9660 | [0.966000, 0.966033] | 52,128 |
| unicode / scalar | 1,481,794 | 1,533,917 | 0.9660 | [0.966004, 0.966036] | 52,123 |
| comment-string / byte | 386,466 | 394,108 | 0.9806 | [0.980544, 0.980676] | 7,642 |
| comment-string / scalar | 386,457 | 394,103 | 0.9806 | [0.980533, 0.980667] | 7,646 |
| malformed-early / malformed-late | −2 / 8 | −7 / 9 | — | — | — |

The malformed cohorts are the control on the claim that this is a real stage: their admission
difference is a handful of instructions either way, the branch that decides a failed parse never
reaches admission, and it is unchanged. Branches on the ASCII admit stage fall from 815,378 to
809,430; branch misses are in the hundreds per iteration on both arms and are the differencing
noise the playbook says not to read. `prepare` is unchanged (1.000113 [0.999156, 1.001070]),
retained bytes are unchanged at 6,541,312 because the stack is sized inside its reserved
capacity, and peak RSS on the ASCII admit operation is 5,996 KiB against 6,000.

### The Fermi was 27 per cent high, and the compiled reading was right

Predicted 66,000 (range 55,000 to 75,000) from the source-level count of removed reloads;
measured **52,062 on ASCII, 6.26 per visit over 8,320 visits**. The compiled reading taken from
the candidate's own loop before the run — 4 to 8 per visit, 33,000 to 66,000 — contains the
measurement, and the reason the source-level Fermi is high is visible in that loop: the compiler
spends one to two register moves per pop and per push (`mov %r8,%r10`, `mov %rbp,%r12`,
`mov %r12,%rbp`) to keep the cursor, the nodes header and the stack header live around the
jump-table dispatch and the calls, and it rematerializes the jump-table base each pop where the
control hoisted it. Those are new instructions the source-level count does not see, about two
per visit, and 8,320 × 2 is the 14,000 gap. Comment-string is the same per-visit story on the
other side: 7,642 over 1,920 visits is 3.98 per visit, and that cohort's visits are leaf-heavy
(1,920 pushes for 1,920 visits, 512 of them the body pushes), so most visits are the pop's
saving alone with no push saving on top of it.

**Disposition: kept**, commit `5578357`. Retained as `ergodis-tools-5578357`, measured sha256
`f2e3790615c14d8513c9a5b93d79c4b6b29e8a440603fce15f150c94493f853a`, rustc 1.95.0, and that
binary is the control for candidate B.

## Candidate B — hoist the surviving scan's reloads

### Fermi, written before the change

The one remaining node-pool scan in `Workspace::admit`, as `ergodis-tools-5578357` compiles it,
costs thirteen instructions per node that is neither a definition nor a module: increment the
id, bump the pointer, compare with the count, branch, **reload `nodes.len`, bounds-compare,
branch, reload the nodes base pointer**, load the kind, compare with `Definition`, branch,
compare with `Module`, branch. The four in bold exist because `declare` takes `&mut Workspace`
and the compiler cannot prove it leaves the pool alone. Moving the node pool out of the workspace
before the scan rather than after it, iterating the local slice, and handing `declare` the slice
as a parameter removes those four; the iterator form also folds the id increment into the
pointer bump, so the loop body should be eight or nine instructions. With 12,288 pool nodes on
ASCII, of which 576 are definitions and 64 are modules: **11,648 × 4 ≈ 46,600 instructions,
about 3.6 per cent of the post-candidate-A stage**, plausible range three to four per node
(35,000 to 47,000). Comment-string: 3,584 nodes, 512 definitions, about 12,000 (3.2 per cent);
unicode: 12,416 nodes, about 47,000.

The previous report priced this at two per node (24,600) from an eight-instruction reading of
the removed second pass; the thirteen-instruction reading of the surviving pass is what is
compiled today and is the price used here. `declare` gains a parameter, and the lane's lesson is
that a signature change can move inlining: `declare` is 233 instructions and called from two
sites, so the receipt is read for whether it stays out of line.

### What was built, commit `db47ee1`

The node pool and the traversal stack now leave the workspace before the declaring scan rather
than after it; `check` holds the scan and the body walk, iterates the local slice with
`iter().enumerate()`, and `declare` takes `nodes: &[Node]` as a parameter. The definitions pool is
still pushed through the workspace, once per definition. Nothing about what is declared, in what
order, or what is admitted changes: the scan visits the same nodes in the same ascending order.

The compiled scan in `ergodis-tools-db47ee1`, on the path a node that is neither a definition nor
a module takes:

```text
add    $0x20,%r15          ; next node
inc    %ebp                ; id
cmp    %r15,%r13           ; end of the slice
je     <done>
movzwl 0x18(%r12,%r15,1),%eax   ; kind
cmp    $0x9,%eax
je     <definition>
cmp    $0xa,%eax
jne    <next>
```

Nine instructions against thirteen: the length reload, its bounds compare and branch, and the
base-pointer reload are gone, as the Fermi assumed. `declare` stays out of line at 232
instructions (233 before; the parameter replaced a field load), `run` is unchanged at 336, and
`Workspace::admit` shrinks from 449 to 417.

### A/B, candidate `db47ee1` over control `5578357`

Same protocol; load average 4.45 at launch and 2.76 after. Receipt
`analysis/rel-frontend/performance-v1-admit-scan-hoist-db47ee1.json`. A/A instruction nulls
0.999998 to 1.000007 on every cohort; **the parse stage is 1.000000 on every cohort and both
variants**.

| Operation | candidate | control | ratio |
|---|---:|---:|---:|
| ascii/parse/byte | 2,507,812 | 2,507,812 | 1.000000 |
| ascii/admit/byte | 3,753,822 | 3,803,164 | **0.987026** |
| ascii/admit/scalar | 5,114,231 | 5,163,575 | 0.990444 |
| unicode/parse/byte | 8,733,238 | 8,733,236 | 1.000000 |
| unicode/admit/byte | 10,165,183 | 10,215,040 | 0.995119 |
| comment-string/parse/byte | 1,401,950 | 1,401,956 | 0.999995 |
| comment-string/admit/byte | 1,773,965 | 1,788,425 | 0.991915 |
| malformed-early/admit/byte | 1,098,166 | 1,098,165 | 1.000001 |
| malformed-late/admit/byte | 2,504,014 | 2,504,014 | 1.000000 |
| prepare | 6,483 | 6,482 | 1.000290 |

Admission alone, and the Fermi beside it:

| Cohort / variant | candidate | control | ratio | interval | saved | predicted |
|---|---:|---:|---:|---|---:|---:|
| ascii / byte | 1,246,010 | 1,295,352 | **0.9619** | [0.961898, 0.961918] | 49,343 | 46,600 |
| ascii / scalar | 1,245,999 | 1,295,344 | 0.9619 | [0.961894, 0.961917] | 49,345 | — |
| unicode / byte | 1,431,946 | 1,481,803 | 0.9664 | [0.966339, 0.966368] | 49,858 | 47,000 |
| comment-string / byte | 372,015 | 386,468 | 0.9626 | [0.962508, 0.962696] | 14,453 | 12,000 |

**The Fermi closes to 6 per cent on ASCII and unicode and to 20 per cent on comment-string**,
all on the high side: 49,343 over the 11,648 non-declaring ASCII nodes is 4.24 per node against
the four counted off the loop, and comment-string's 14,453 over 3,072 is 4.70. The extra
fraction of an instruction per node is the definition path: the old loop's `w.definitions.push`
sat between two reloads it now no longer shares, and `declare`'s call setup lost the field load,
so the 576 (512) declaring nodes each save more than four. `prepare`, retained bytes
(6,541,312) and peak RSS are unchanged; branches on the ASCII admit stage fall from 809,430 to
797,142, a difference of 12,288, which is exactly one per pool node: the removed bounds-check
branch.

**Disposition: kept**, commit `db47ee1`. Retained as `ergodis-tools-db47ee1`, measured sha256
`6e41d1d608ea72d9c998a5b9d4ff7788e9f303a44398ebd95b1eaae3fd7920ba`, rustc 1.95.0.

## The composed saving, `db47ee1` against the original control `49bbb9a`

A third A/B of the final revision against the control this task started from, same protocol,
load average 2.71 at launch and 5.80 after. Receipt
`analysis/rel-frontend/performance-v1-admit-composed-db47ee1.json`. A/A nulls at unity; parse
0.999999 to 1.000000 on every cohort and both variants.

| Operation | candidate | control | ratio |
|---|---:|---:|---:|
| ascii/parse/byte | 2,507,811 | 2,507,813 | 0.999999 |
| ascii/admit/byte | 3,753,822 | 3,855,228 | **0.973696** |
| ascii/admit/scalar | 5,114,234 | 5,215,639 | 0.980557 |
| unicode/admit/byte | 10,165,186 | 10,267,165 | 0.990067 |
| comment-string/admit/byte | 1,773,956 | 1,796,071 | 0.987687 |
| malformed-early/admit/byte | 1,098,174 | 1,098,170 | 1.000004 |
| malformed-late/admit/byte | 2,504,014 | 2,504,013 | 1.000000 |
| prepare | 6,484 | 6,487 | 0.999445 |

Admission alone:

| Cohort | candidate | control | ratio | interval | saved |
|---|---:|---:|---:|---|---:|
| ascii | 1,246,010 | 1,347,414 | **0.9247** | [0.924731, 0.924752] | 101,404 |
| unicode | 1,431,947 | 1,533,927 | 0.9335 | [0.933503, 0.933531] | 101,980 |
| comment-string | 371,998 | 394,112 | 0.9439 | [0.943748, 0.944035] | 22,113 |

**The two candidates' savings multiply exactly**: 0.9614 × 0.9619 = 0.92477 against the 0.92474
measured end to end, so each A/B isolated its own change. Against the control this task started
from the ASCII admission stage is 101,404 instructions cheaper per admission of a 43,008-byte
source: **28.97 instructions per source byte against 31.33**, 80.4 per token against 87.0, and
354 per resolved name reference against 383. Against the control the admission work began from
on 2026-09-14 (`185015e`, 1,743,837), the stage now stands at **0.7145**.

## Kernel-scoped profile at `db47ee1`, and every out-of-line call in the stage

`perf record -q -e instructions:u -F 4000`, ASCII cohort, byte scanner, 512 definitions, 20,000
iterations of the `admit` stage, pinned to CPU 7, under the pinned toolchain.
`~/.cache/ergodis/perf-c1170/admit-db47ee1.data`, 676,072 bytes.

| Symbol | Share of the parse + admit stage |
|---|---:|
| `parser::Parser::expression` | 33.76 % |
| `Workspace::scan_variant` | 25.86 % |
| `admit::reference` | 13.67 % |
| `admit::run` | 7.57 % |
| `admit::declare` | 4.62 % |
| `admit::bind_list` | 4.43 % |
| `lexer::keyword` | 2.96 % |
| `Workspace::admit` | 2.69 % |
| `parser::Parser::item` | 1.84 % |
| `parser::Parser::node` | 1.80 % |
| `core::str::converts::from_utf8` | 0.45 % |
| `parser::parse` | 0.25 % |
| libc `__memset_avx512_unaligned_erms` | **0.07 %** |

The five admission symbols sum to 32.98 per cent; the stage difference puts admission at
1,246,010 of 3,753,822, which is 33.19 per cent. The two methods agree to 0.21 of a point.
`run` has fallen from 12.52 to 7.57 per cent of the stage and `reference` is now the largest
admission symbol.

Every out-of-line call in the stage, read from the disassembly of `ergodis-tools-db47ee1`:

| Call | Where | On the common path |
|---|---|---|
| `admit::reference` | two sites inside the traversal loop in `run` | yes, once per name reference |
| `admit::bind_list` | one site in `run` (the relational-abstraction arm); the `check_definition` site is inlined into `Workspace::admit` | yes |
| `admit::run` | two sites in `Workspace::admit`, outside every loop | once per definition body and once for a bare expression |
| `admit::declare` | two sites in the node-pool scan in `Workspace::admit` | once per definition or module; outside the traversal |
| libc `memset` | three sites in `Workspace::admit`: the index clear, the index resize path, and the new visits-pool sizing path | the index clear once per admission, outside the node loop, 0.07 per cent; the two sizing paths once per workspace |
| `__rust_dealloc` | four sites in `Workspace::admit`, each behind a `test %rsi,%rsi; je` on the capacity | no — they drop the empty vectors `take` leaves behind, whose capacity is zero, so the branch is never taken |
| `_Unwind_Resume` | two landing pads in `Workspace::admit` | no — unwind only |
| `core::panicking::panic_bounds_check` | 7 sites in `run`, 8 in `bind_list`, 12 in `reference`, 6 in `declare` | no — cold slow paths |
| `slice_index_fail` | one site in `run`, the binder range of a scope close | no — cold |
| `RawVec::grow_one` | 3 sites in `bind_list`, 1 in `reference`, 1 in `declare`; **none in `run`** | no — every pool is bounded before the push, and the zero-allocation regression observes none executing; the traversal stack is a slice and has no grow path at all |
| `RawVecInner::reserve::do_reserve_and_handle` | two sites in `Workspace::admit`, the index's and the visits pool's first sizing | once per workspace, inside reserved capacity |

**No libc call is inside a loop.** The stage's one libc symbol is the index clear's `memset`,
unchanged by this task.

## Gates

Run from `~/src/ergodis-private`, every one under `nix develop ~/src/ergodis` (rustc 1.95.0),
at both candidates.

| Gate | Command | Outcome |
|---|---|---|
| Frontend tests | `cargo test --release -p ergodis-private --test rel_frontend --test rel_frontend_portability -j 4` | 24 + 1 passed at `5578357` and `db47ee1`, 0 failed |
| Zero allocation | inside that test run | `admission_is_deterministic_over_the_cohorts_and_does_not_allocate` observes zero allocations and unchanged retained bytes over ten rounds of all five cohorts plus a semantic failure; the visits pool is sized inside its reserved capacity on the first admission |
| Clippy, library and both test targets | `cargo clippy --release -p ergodis-private --lib --test rel_frontend --test rel_frontend_portability -j 4 -- -D warnings` | no diagnostics |
| Clippy, tools binary | `cargo clippy --release -p ergodis-tools --bins -j 4 -- -D warnings` | no diagnostics |
| Formatting | `rustfmt --check --edition 2021 src/rel_frontend/admit.rs` | clean |
| Native/WASM parity replay | `python3 analysis/rel-frontend/portability.py --output analysis/rel-frontend/portability-v1.json` | 159 cases, 345,993 canonical bytes, byte-equal; canonical SHA-256 `5a350e1f524b26da61186320414785045d9f39a71c4b34b40f9bd78d3516cbfa` unchanged at both candidates (only the library hashes in the receipt moved) |
| Driver output gate | armed on every operation of all three A/B runs | equal tokens, nodes, failure, admission summary and representation fingerprint against the control on every cohort and both variants |
| Event set | `instructions,cycles,branches,branch-misses,page-faults,minor-faults` | 100.00 per cent enabled on all six, measured directly with `perf stat -x,` on the admit stage at `db47ee1` |
| Parse-stage parity | inside each A/B | 0.999995 to 1.000002 on every cohort and both variants in all three runs; no ThinLTO shift of the scanner or parser |
| A/A null | inside each A/B | 0.999996 to 1.000007 per cohort, every interval within thirteen parts per million of unity |

## Replay

`$C0`, `$C1` and `$C2` are `ergodis-tools` retained by
`../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools` at `49bbb9a`, `5578357` and
`db47ee1` respectively, each with that revision checked out. The script re-executes itself under
`nix develop ~/src/ergodis`, so all three arms share the pinned rustc 1.95.0.

```sh
E=instructions,cycles,branches,branch-misses,page-faults,minor-faults
python3 analysis/rel-frontend/bench.py --binary "$C1" --control "$C0" \
    --rounds 7 --cpu 5 --stages parse,admit --events $E \
    --out analysis/rel-frontend/performance-v1-admit-cursor-5578357.json
python3 analysis/rel-frontend/bench.py --binary "$C2" --control "$C1" \
    --rounds 7 --cpu 5 --stages parse,admit --events $E \
    --out analysis/rel-frontend/performance-v1-admit-scan-hoist-db47ee1.json
python3 analysis/rel-frontend/bench.py --binary "$C2" --control "$C0" \
    --rounds 7 --cpu 5 --stages parse,admit --events $E \
    --out analysis/rel-frontend/performance-v1-admit-composed-db47ee1.json
perf record -q -e instructions:u -F 4000 -o ~/.cache/ergodis/perf-c1170/admit-db47ee1.data \
    -- taskset -c 7 "$C2" rel-frontend-bench --cohort ascii --stage admit --variant byte \
    --definitions 512 --repeat 20000
perf report -i ~/.cache/ergodis/perf-c1170/admit-db47ee1.data --stdio -g none --percent-limit 0.05
```

## Foreign tree

The repository carries the same uncommitted foreign files the previous C1170 reports name: the
campaign-console mockups and interface-review material under `analysis/`,
`packages/execution-provider/src/lib.rs`, `packages/hadamard-provider/tests/contracts.rs`,
`packages/parameterization-provider/tests/contracts.rs`, `src/hadamard_execution.rs`,
`src/partitioned_additive_join.rs`, `tests/partitioned_join_profile.rs` and
`tests/quadratic_residual_profile.rs`. Their diff hashed
`a954fbdceb3a9ea474c3406ec70e7419a7fd02b2026f400f21197fb7b6a2df28` at the start of this task and
again at the end, unchanged, the same hash the three previous reports recorded. None was touched,
staged or reverted; every commit here was made with an explicit whole-file pathspec. All three
binaries were built from a tree carrying them, so none is reproducible from its commit alone;
both arms of every comparison saw the same foreign tree, so it cancels in every ratio.

## Mystery ledger

1. **Settled: the 39.95-per-visit coefficient was right as a mix, and it was not what priced the
   candidate.** The control's loop reads 24 for the pop and dispatch, 6 and 10 for a first and
   second push, so a `Binary` visit is 40 and an `Atom` visit 24 plus call setup. The
   coefficient is a credible average of that mix. The candidate was priced from the compiled
   loop, as ledger item 3 of the previous report instructed.
2. **Settled: why the cursor saved 21 per cent less than the source-level Fermi.** Predicted
   66,000 from the removed reloads; measured 52,062, 6.26 per visit. The candidate's own loop,
   read before the run, priced it at 4 to 8 per visit and contains the measurement. The gap is
   the register moves the compiler adds to keep the cursor and two slice headers live around the
   jump-table dispatch and the calls, and the jump-table base it now rematerializes each pop —
   about two instructions per visit that a source-level count does not see. The lesson is the
   same one as candidate 1 of the previous report from the other side: a Fermi that counts
   removed instructions must also count what the compiler adds to hold the new invariants, and
   only the candidate's disassembly shows that.
3. **Settled: the scan-hoist Fermi closes to 6 per cent from a thirteen-instruction reading of
   the surviving loop**, where the previous report's two-per-node price (24,600) came from an
   eight-instruction reading of the *removed* second pass. The branch count moved by exactly one
   per pool node (12,288), the removed bounds check, which is the cleanest single confirmation
   in this report of where a saving went.
4. **Settled: the two changes do not interact.** 0.9614 × 0.9619 = 0.92477 against 0.92474
   measured end to end.
5. **Open, cheap: the `scopes` pool is dead.** `Workspace::scopes` is reserved to
   `Limits::depth`, touched by `touch`, counted in `retained_bytes` and cleared three times per
   admission, and nothing ever pushes to it: the scope mark moved into `Visit::mark` when the
   stack entries gained a mark, and the pool was left behind. Removing it saves one
   `try_reserve_exact` in `prepare`, 2 KiB of reserved bytes under the bench limits and three
   clears, and changes `retained_bytes`, which the allocation regression compares before and
   after rather than to a constant. Not done here because it is a pool-shape change outside
   both candidates' A/Bs; it is one commit with its own `prepare` A/B.
6. **Open, from the previous report and now larger by share: `declare` costs about 198
   instructions per definition, 4.62 per cent of the stage.** Untouched by this task except for
   the parameter. The evidence gap is unchanged: a `perf annotate` of `admit::declare` bucketed
   into named address ranges.
7. **Open: what the remaining 20 instructions of a pop are.** Six field loads of a 32-byte node
   for every visit, when most arms use two or three fields; the jump-table dispatch; the
   register moves of item 2. A visit-kind-specialized load (read `kind` first, then only the
   fields that arm needs) is the next shape, priced at two to four per visit from the loop, but
   its cost is the second dependent load before the dispatch, which the playbook says to
   measure in cycles as well as instructions. Not built; stated so it is priced before it is
   proposed.
8. **Not a mystery, recorded so it is not read as one.** `bind_list` rose from 2.83 to 4.43 per
   cent of the profile while its code is 350 instructions against 332 and its inputs are
   unchanged; its instruction count in the receipt did not move in isolation (the stage moved by
   the amounts the two candidates predicted, with nothing left over). The share is sample skid
   at the call and return sites it shares with `run`, whose loop shrank around it — the same
   effect the playbook warns about, on a symbol this task did not target.

## Remaining next steps

Priced against the **new** ASCII admission stage of 1,246,010 instructions.

1. **Remove the dead `scopes` pool** (ledger item 5): one commit, its own `prepare` A/B, no
   admission-stage effect expected.
2. **Update the census and re-run the decomposition at `db47ee1`.** Every coefficient in
   `performance-v1-admit-model-185015e.json` is now stale for five units (hash, first sight, the
   scan, the traversal and the push), and the census still replays the old kernel (hashes inside
   `insert`, walks all 32 `BUILTINS`, scans the pool twice). The census counts are unchanged by
   this task — visits, pushes and scanned nodes are the same — so only the coefficients need
   re-fitting once the census matches the kernel.
3. **`declare`** (ledger item 6): annotate first, then price.
4. **The pop's field loads** (ledger item 7): 17,000 to 33,000 instructions, 1.3 to 2.7 per
   cent, with a cycle risk; measure only after the re-decomposition says nothing larger remains.
5. **Not worth doing, priced so it is not proposed.** The index clear (1,795 instructions,
   0.14 per cent); the wider `BUILTINS` gate (0.1 per cent); the `take`/restore of the two pools
   (twelve instructions per admission).

Then, per the handoff: module-scoped visibility, module parameters and member tables in
admission; then the remaining syntax gaps by manifest family.

## What this task left under `~/.cache/ergodis/`

For the user's cache decision. Nothing was deleted, nothing large went to `/tmp`, and no
`~/.cache` path is cited as evidence.

| File | Size | Measured sha256 | rustc |
|---|---:|---|---|
| `bin/ergodis-tools-5578357` | 15,121,288 | `f2e37906…493f853a` | 1.95.0 |
| `bin/ergodis-tools-db47ee1` | 15,121,176 | `6e41d1d6…3fd7920ba` | 1.95.0 |
| `perf-c1170/admit-db47ee1.data` | 676,072 | — | the profile this report cites |
| `perf-c1170/dis-{49bbb9a,5578357,db47ee1}.txt` | 18 MiB each | — | full `objdump -d` of the three arms, from which the loop readings above were taken; regenerable from the retained binaries |
| `perf-c1170/run-*.s`, `wsadmit-*.s` | small | — | the extracted `admit::run` and `Workspace::admit` listings |

Each retained executable has a `MANIFEST.tsv` row and a `.sha256` sidecar. The three `dis-*.txt`
files are the first thing to delete; `../ergodis-dev/scripts/cache-gc.sh` has not been run, since
deletion is the user's call.
