# C1170 — module-scoped visibility, module parameters and member tables in admission

**Lane**: `ergodis`
**Date**: 2026-09-14
**Repository**: `~/src/ergodis-private` (private, no public remote), branch `main`, from `9c8dac3`

**Control**: `ergodis-tools` built at revision `93bb343` and retained as `ergodis-tools-93bb343`
(retain recipe: `../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools` at that revision).
Measured sha256 `520e6057add1dbd8e7607d22dedcca6886471fcd4c26ed71649f51cf8d648d18`, rustc 1.95.0
(59807616e 2026-04-14), release profile, no features. `9c8dac3` touches no Rust source.

**First candidate**: `ergodis-tools` built at revision `7b38c65` and retained as
`ergodis-tools-7b38c65` by the same recipe. Measured sha256
`350fce0c233ef6aa1dbda29951d39ea2a678c6fc1e32aed2ff804600299fe8c4`, rustc 1.95.0 (59807616e
2026-04-14), release profile, no features. It is the module feature as first written, and it is
also the control for the second A/B.

**Second candidate**: `ergodis-tools` built at revision `4b02031` and retained as
`ergodis-tools-4b02031` by the same recipe. Measured sha256
`9d1d0a4544461cc2a56f75b5eeaed2c2b7af1e103a78893f57293f42380c8876`, rustc 1.95.0 (59807616e
2026-04-14), release profile, no features. It reworks the probe loop in response to the `7b38c65`
measurement and changes no semantics.

**Third candidate**: `ergodis-tools` built at revision `9bfe19d` and retained as
`ergodis-tools-9bfe19d` by the same recipe. Measured sha256
`c6376274ac2892c1b044a1fb8ed89a1852876e14caa499100036cf9862fa5019`, rustc 1.95.0 (59807616e
2026-04-14), release profile, no features. It adds `#[inline(always)]` to `admit::insert` and
nothing else; `nm` shows no `admit::insert` symbol in it.

All four hashes were verified with `sha256sum` before the measurements that use them and are the
hashes the receipts record. Every measurement, parity replay and profile in this report ran under
`nix develop ~/src/ergodis` (rustc 1.95.0, pinned through the core flake).

## Status

Complete. **Module scoping as it now stands, at `9bfe19d` against the pre-feature control
`93bb343`, costs 1.097623 [1.097620, 1.097626] of the ASCII admission stage in instructions —
110,883 instructions added to 1,135,831, 31.50 per reference over 3,520 references.** Unicode is
1.083519 on an identical census and comment-string, which declares no module at all, is 1.146831.

The three-step path to that number is the instructive part, and by the end the cost is identified
rather than fitted. Each step was predicted, measured, and explained by a boundary the prediction
had not looked at:

| Step                    | ASCII admission ratio | interval               |  delta | Fermi              | verdict                |
|-------------------------|----------------------:|------------------------|-------:|--------------------|------------------------|
| `7b38c65` over `93bb343` |              1.081272 | [1.081268, 1.081276]   | +92,311 | 1.018 to 1.026     | missed, 3.1× too low   |
| `4b02031` over `7b38c65` |              1.037796 | [1.037792, 1.037801]   | +46,419 | 0.960 to 0.975     | missed, wrong sign     |
| `9bfe19d` over `4b02031` |              0.978153 | [0.978148, 0.978159]   | −27,844 | 0.965 to 0.980     | **held**, shallow end  |
| `9bfe19d` over `93bb343` |              1.097623 | [1.097620, 1.097626]   | +110,883 | 1.085 to 1.10      | **held**, deep end     |

The three steps sum to the composed figure to within three instructions in 110,883, which is the
consistency check the four-way design buys.

The final cost decomposes into three terms that each price against a different census count, and
the same three coefficients reproduce both the ASCII and the comment-string deltas to within a
quarter of a per cent:

| Term                                                      | per                | instructions | ASCII share |
|-----------------------------------------------------------|--------------------|-------------:|------------:|
| `enter_scope`'s module-chain build                         | body               |         21.2 |      12,200 |
| owner load, `SHADOWED` test and chain scan in the probe    | reference          |         12.6 |      44,500 |
| the shadow-flagging walk inside `insert`                   | symbol inserted    |         35.0 |      54,200 |

The largest term is the one no Fermi priced above a few thousand: flagging, at insert time, every
spelling declared by two owners costs 35 instructions per symbol, and an ASCII admission inserts
1,545 symbols. Inlining `insert` at `9bfe19d` removed 18.0 instructions per symbol on ASCII and
18.2 on comment-string — a per-symbol effect so nearly identical on two cohorts with quite different
reference-to-symbol ratios that it is measured rather than fitted — which is the call shape, and
left the walk itself, which is the remaining 35.

`prepare` is 1.211801 [1.210943, 1.212659] at `7b38c65` and unchanged by both later commits
(1.000803 and 0.999470, both inconclusive), 1,242 instructions added against the Fermi's 600 — the
Fermi priced one new pool reservation and the change adds two. `prepare-touch` is 1.070179 at
`7b38c65` and likewise unchanged after; its touched-page count rises from 1,597 to 1,614, seventeen
pages against the predicted sixteen, and the perf fault counters sit at 1,536.000 per iteration on
every arm and do not see it. Retained bytes rise once, from 6,539,264 to 6,606,852, exactly
65,536 + 4 × 513, and are identical on all three candidates — the one Fermi term that landed on the
nose. Peak RSS rises 88 to 92 KiB on the admit operations at `7b38c65` and drifts a further 16 to
44 KiB across the two later commits, which allocate nothing new.

Parse is 1.000000 on every cohort and both scanner variants in all five A/Bs, every parse interval
inside its own null, so nothing outside admission moved. The A/A instruction nulls run 0.999997 to
1.000003 across the five A/Bs, every interval within seven parts per million of unity, so the
protocol held throughout and every candidate reads.

The native/WASM parity replay changed the canonical hash once, at `7b38c65`, as declared: **166
cases, 356,228 canonical bytes, canonical SHA-256
`f3d837520b04cf5d829ecad53dc34ed0a7332b4c18ca77415244d17fa0c7c814`**, native and WASM byte-equal.
Replaying at `4b02031` and again at `9bfe19d` reproduces that hash exactly, which is the check both
semantics-preserving claims needed. The driver's output gate passed on all 27 operations of all five
A/Bs with no `--representation-change` flag needed: tokens, nodes, failure, the admission summary
and the representation fingerprint are equal on every operation, on every arm.

Vibe check: ended well after two bad turns. The feature costs 10 per cent of the admission stage
rather than the 2 per cent first predicted, and the reason it took three commits to find out is that
each prediction modelled the source change and not the inlining boundary it moved. The cost is now
priced per body, per reference and per symbol, and the open lever with the largest head is the
insert-time shadow walk, not the probe loop.

**Commits**:

| Commit    | Contents                                                                                       | Disposition                                  |
|-----------|------------------------------------------------------------------------------------------------|----------------------------------------------|
| `7b38c65` | module-scoped visibility, module parameters as binders, member lookup, `ErrorCode::UnknownMember` (REL0406), the `owners` and `scope` pools, one test, seven parity cases and the coverage manifest update | **kept** (vetted: ratios re-read from the receipts, symbol tables checked with `nm`, parity hash re-checked) |
| `4b02031` | `lookup` restored to its pre-module probe shape; spellings declared at two owner levels flagged at insert with a `SHADOWED` bit on `Owner::module`, the top-level owner moved from `NONE` to `TOP = 0x7FFF_FFFF`, and a flagged match handed to an `#[inline(never)]` `shadowed` scan | **kept** (vetted: ratios re-read from the receipts, symbol tables checked with `nm`, parity hash re-checked) |
| `9bfe19d` | `#[inline(always)]` on `admit::insert`, with the doc comment recording that the shadow-flagging walk had pushed the five-argument shape over the inliner's threshold | **kept** (vetted: ratios re-read from the receipts, symbol tables checked with `nm`, parity hash re-checked) |

## Semantics adopted

Written down before the code, because no executable Rel reference semantics is available to this
lane (it remains deferred) and the choices below are therefore this stage's stated contract, not a
claim about Rel.

1. **Ownership.** Every definition and module is owned by the innermost enclosing `module`, or by
   the top level. The parser already records that as the node's `parent`.
2. **Visibility of a bare name.** From a body owned by module `M_k` nested in `M_{k-1}` … `M_1`
   under the top level, a bare name resolves to the *innermost* owner in that chain that declares
   it: `M_k` first, then `M_{k-1}`, …, then the top level. A definition in a module that is not on
   the chain (a sibling, or a module the reference sits outside of) is not visible; the bare name
   then falls through, as today, to a builtin or an external base relation. Shadowing is by owner
   level; several clauses of one name at one level are all candidates, as today.
3. **Base relations and builtins are global.** A free name inside a module is the same external
   base relation as the same spelling anywhere else; its arity is fixed by its first application
   in source order, wherever that is.
4. **Module parameters.** `module M[p, q] … end` binds `p` and `q` in every body owned by `M` or
   by a module nested in `M`, outside the body's own parameters, so a body's own parameter of the
   same spelling shadows them. A parameter written `x in D` visits `D` as a reference.
5. **Members.** `M:x` where the leftmost base resolves to a module symbol looks `x` up among the
   symbols owned by that module's node; `M:N:x` continues through nested modules; `M[a]:x`
   instantiates and then looks up. A member that no clause of the module declares is a new
   rejection, `ErrorCode::UnknownMember` (`REL0406`), with the module's header as the related
   site. An applied member `M:x(a, b)` has its arity checked against `x`'s clauses in `M`. When
   the base is anything other than a module (a binder, a definition, a base relation, a builtin,
   or an expression), the qualification is symbol-keyed access and the member names are not
   references; the base is admitted as before.
6. **Not merged.** Two `module M` items with one spelling at one level are two module symbols;
   a member lookup goes through whichever the base lookup accepted first, so members of the
   second are not found through the first. Recorded as a limit; Rel's reopening semantics are
   not claimed.
7. **`def M:x` outside a module** still declares a clause of `M` keyed by `:x`, as before; it
   does not add a member to a module `M`.

## Representation

`Symbol` stays 16 bytes and the index probe unchanged. A parallel pool `owners: Vec<Owner>`
(8 bytes: the owning module's node id, and for a module symbol its own node id) is read only
after a spelling match. A `scope` chain (the owning module node ids of the definition being
checked, innermost first, ending in `NONE`) is built once per body; a matched symbol's owner is
located in that chain by a linear scan, and the innermost position wins. The probe loop keeps
its early return when the winning match is at position 0 (the body's own owner, or the top
level from a top-level body), which is the common case; a body inside a module that resolves a
global name must run its probe chain to the empty slot, because an inner clause could still
follow.

At `4b02031` the probe loop is back to its pre-module shape: the first visible compatible match
returns, with one owner load and one chain scan per spelling match. That is exact whenever a
spelling is declared at one owner level only, and `insert` now records which spellings are not: the
walk to the empty slot, which `insert` already performed, compares each earlier symbol's filter and
spelling and, when one carries a different owner, sets a `SHADOWED` bit on bit 31 of
`Owner::module` on both symbols. The top-level owner became `TOP = 0x7FFF_FFFF` rather than `NONE`
so that it cannot carry that bit. A probe meeting any flagged symbol hands the whole lookup to an
`#[inline(never)]` `shadowed` function that runs the level-aware scan of `7b38c65`. `Owner` stays 8
bytes, `Symbol` stays 16, and no pool changed size.

## Fermi for the module feature, written before `7b38c65`

Against ASCII admission 1,135,830 at `93bb343`, 3,520 references, 695 probe hits, 1,600 probes,
576 bodies. The ASCII cohort's modules carry no parameters and its qualified forms are
symbol-keyed, so the new paths that run are: the owner load and chain scan on a spelling match
(about 8 instructions × 695 ≈ 5,600); the lost early return for base-relation hits inside
modules (about a third of the 695 hits sit in module bodies and continue one further slot on
average, 11 instructions each ≈ 2,500); the chain build per body (about 15 × 576 ≈ 8,600); and
the module-parameter walk per body, one header read for each module in the chain (about 10 ×
576 ≈ 5,800). Predicted **+20,000 to +30,000, ratio 1.018 to 1.026** on the ASCII admission stage.
`prepare` gains one 64 KiB reservation (about +600 by the scopes-pool report's corrected cost) and
`prepare-touch` gains 16 pages; retained bytes rise by 65,536 + 4 × (depth + 1).

## Fermi for the rework, written before `4b02031` was measured

From the lead, quoted as written. Against `7b38c65` the ASCII admission stage recovers most of the
92,311: the prologue growth and the three loop-carried values go away, leaving the owner load and
chain scan on the 695 hits (about 8 each ≈ 5,600), the lost early return for nothing (position 0
returns again for globals only from top-level bodies; inside modules a global hit still scans two
chain entries), `enter_scope` per body (about 21 × 576 ≈ 12,000 by the fit above), and the
insert-time walk with a hash compare per occupied slot (about 4 per slot walked, a few thousand).
Predicted **ASCII admission 0.960 to 0.975 of `7b38c65`, that is composed 1.035 to 1.055 of
`93bb343`**. `prepare`, `prepare-touch`, retained bytes and parse unchanged from `7b38c65`.

## Fermi for the `insert` inlining, written before `9bfe19d` was measured

From the lead, quoted as written. 1,545 inserts on ASCII (640 declares plus 905 first sights) at
53.1 per call out of line; inlined, the body is about 38 plus the walk, so 15 to 25 recovered per
insert plus the caller-side marshaling: **25,000 to 45,000 recovered, ASCII admission 0.965 to 0.980
of `4b02031`, composed 1.085 to 1.10 of `93bb343`**.

## Method

Event set `instructions,cycles,branches,branch-misses,page-faults,minor-faults`, six events, no
multiplexing: a direct `perf stat -x,` on each candidate's ASCII admit stage reports 100.00 per cent
enabled on all six. Seven interleaved rounds, all five cohorts, both scanner variants,
`--stages prepare,prepare-touch,parse,admit`, 512 definitions, pinned to CPU 5, output gate armed
on every operation, 27 operations per arm. Instruction ratios decide and cycles are quoted only with
their intervals. Host is an AMD Ryzen AI 9 HX 370, kernel 7.2.4, `perf_event_paranoid` 2 so only
user-mode events are counted.

| A/B                              | Receipt                                                        | load average at launch and finish |
|----------------------------------|----------------------------------------------------------------|-----------------------------------|
| `7b38c65` over `93bb343`         | `performance-v1-admit-modules-7b38c65.json`                     | 6.22 and 3.35                     |
| `4b02031` over `7b38c65`         | `performance-v1-admit-lean-loop-4b02031.json`                   | 3.83 and 3.94                     |
| `4b02031` over `93bb343`         | `performance-v1-admit-modules-composed-4b02031.json`            | 3.94 and 3.87                     |
| `9bfe19d` over `4b02031`         | `performance-v1-admit-insert-inline-9bfe19d.json`               | 4.92 and 2.29                     |
| `9bfe19d` over `93bb343`         | `performance-v1-admit-modules-composed-9bfe19d.json`            | 2.29 and 2.63                     |

Each candidate after the first was measured twice, against its immediate predecessor and against
`93bb343`: the step A/B says what that commit did, the composed A/B says what the feature costs at
that point. The pairs share the candidate's arm and differ only in the control.

The `--representation-change` flag was read for but not used. The driver's gate raises on any
disagreement in tokens, nodes, failure or the admission summary, and that flag relaxes only the
representation fingerprint; it relaxed nothing here because nothing disagreed. Retained bytes are
not part of the gate's equality set at all — the driver reads them only to normalize the standalone
`prepare` counters per workspace byte — so the +67,588-byte pool growth could not have tripped it.
The module-parameter binders that make the parity hash move do not appear on any bench cohort: the
ASCII and Unicode corpora declare modules without parameters and comment-string declares none.

The whole crate builds with ThinLTO and one codegen unit, so a change can move code the diff does
not touch. Nothing did: every parse operation on both scanners and all five cohorts is 1.000000
with an inconclusive interval, and the largest parse excursion is comment-string's byte scanner at
0.999999 [0.999994, 1.000005], one instruction in 1.4 million and inside its own null.

A/A instruction nulls (byte-null over byte within each arm), all five A/Bs:

| Cohort          | `7b38c65` / `93bb343`         | `4b02031` / `7b38c65`         | `4b02031` / `93bb343`         | `9bfe19d` / `4b02031`         | `9bfe19d` / `93bb343`         |
|-----------------|-------------------------------|-------------------------------|-------------------------------|-------------------------------|-------------------------------|
| ascii           | 1.000000 [0.999999, 1.000001] | 1.000000 [0.999998, 1.000002] | 1.000001 [0.999999, 1.000002] | 0.999997 [0.999996, 0.999999] | 1.000000 [0.999999, 1.000001] |
| unicode         | 1.000000 [0.999999, 1.000001] | 1.000000 [1.000000, 1.000001] | 1.000000 [0.999999, 1.000001] | 0.999999 [0.999998, 1.000000] | 1.000000 [0.999999, 1.000000] |
| comment-string  | 1.000001 [0.999998, 1.000004] | 1.000001 [0.999996, 1.000006] | 1.000002 [0.999997, 1.000007] | 1.000002 [0.999997, 1.000008] | 0.999997 [0.999994, 1.000000] |
| malformed-early | 1.000003 [0.999999, 1.000007] | 0.999999 [0.999992, 1.000007] | 1.000001 [0.999996, 1.000006] | 0.999997 [0.999989, 1.000005] | 0.999998 [0.999992, 1.000004] |
| malformed-late  | 1.000000 [0.999998, 1.000002] | 1.000000 [0.999999, 1.000002] | 1.000001 [0.999998, 1.000004] | 1.000000 [0.999999, 1.000001] | 1.000001 [0.999999, 1.000003] |

The ASCII null in the `9bfe19d` over `4b02031` A/B is the only one whose interval excludes unity,
at 0.999997 [0.999996, 0.999999] — three parts per million, two orders of magnitude below the
0.978153 that A/B reports and in the same direction, so it neither explains nor threatens the
result. It is recorded because the protocol says to read the null first.

## Results — `7b38c65` over `93bb343`, the module feature as first written

Candidate over control, instructions per iteration, byte scanner and scalar scanner.

| Operation                       |      candidate |        control |    ratio | interval               |
|---------------------------------|---------------:|---------------:|---------:|------------------------|
| prepare (standalone)            |        7,107.7 |        5,865.4 | 1.211801 | [1.210943, 1.212659]   |
| prepare-touch (standalone)      |       20,688.3 |       19,331.7 | 1.070179 | [1.070087, 1.070271]   |
| ascii/parse/byte                |    2,507,812.4 |    2,507,812.9 | 1.000000 | [0.999998, 1.000002]   |
| ascii/parse/scalar              |    3,868,231.3 |    3,868,231.8 | 1.000000 | [0.999999, 1.000001]   |
| ascii/admit/byte                |    3,735,954.6 |    3,643,643.8 | 1.025335 | [1.025334, 1.025335]   |
| ascii/admit/scalar              |    5,096,363.2 |    5,004,054.4 | 1.018447 | [1.018446, 1.018447]   |
| unicode/parse/byte              |    8,733,233.3 |    8,733,235.2 | 1.000000 | [0.999999, 1.000001]   |
| unicode/parse/scalar            |    9,549,996.0 |    9,549,994.7 | 1.000000 | [0.999999, 1.000001]   |
| unicode/admit/byte              |   10,148,847.9 |   10,056,611.2 | 1.009172 | [1.009171, 1.009172]   |
| unicode/admit/scalar            |   10,965,608.4 |   10,873,375.7 | 1.008482 | [1.008482, 1.008483]   |
| comment-string/parse/byte       |    1,401,968.4 |    1,401,969.3 | 0.999999 | [0.999994, 1.000005]   |
| comment-string/parse/scalar     |    1,899,599.2 |    1,899,598.5 | 1.000000 | [0.999999, 1.000002]   |
| comment-string/admit/byte       |    1,782,926.4 |    1,754,602.0 | 1.016143 | [1.016141, 1.016145]   |
| comment-string/admit/scalar     |    2,280,553.9 |    2,252,245.3 | 1.012569 | [1.012568, 1.012570]   |
| malformed-early/parse/byte      |    1,098,163.4 |    1,098,171.1 | 0.999993 | [0.999985, 1.000001]   |
| malformed-early/parse/scalar    |    2,456,425.5 |    2,456,425.7 | 1.000000 | [0.999999, 1.000001]   |
| malformed-early/admit/byte      |    1,098,165.5 |    1,098,163.7 | 1.000002 | [0.999995, 1.000008]   |
| malformed-early/admit/scalar    |    2,456,425.0 |    2,456,423.7 | 1.000001 | [0.999999, 1.000002]   |
| malformed-late/parse/byte       |    2,504,006.0 |    2,504,006.5 | 1.000000 | [0.999999, 1.000001]   |
| malformed-late/parse/scalar     |    3,862,639.6 |    3,862,640.3 | 1.000000 | [0.999999, 1.000001]   |
| malformed-late/admit/byte       |    2,504,007.5 |    2,504,007.6 | 1.000000 | [0.999998, 1.000002]   |
| malformed-late/admit/scalar     |    3,862,639.5 |    3,862,640.1 | 1.000000 | [0.999999, 1.000001]   |

The two malformed cohorts fail in the parser before admission runs, so their admit stage equals
their parse stage and both are inside their nulls, as they should be. The five byte-null operations
are the A/A pairs tabulated above.

Admission alone (`admit` − `parse`), instructions, with the absolute count added:

| Cohort / variant        |   candidate |     control |    ratio | interval               |  added | per reference |
|-------------------------|------------:|------------:|---------:|------------------------|-------:|--------------:|
| ascii / byte            | 1,228,142.1 | 1,135,830.9 | 1.081272 | [1.081268, 1.081276]   | 92,311 |         26.22 |
| ascii / scalar          | 1,228,131.9 | 1,135,822.6 | 1.081271 | [1.081268, 1.081274]   | 92,309 |         26.22 |
| unicode / byte          | 1,415,614.5 | 1,323,376.0 | 1.069699 | [1.069692, 1.069706]   | 92,239 |         26.20 |
| unicode / scalar        | 1,415,612.4 | 1,323,381.0 | 1.069694 | [1.069688, 1.069700]   | 92,231 |         26.20 |
| comment-string / byte   |   380,958.1 |   352,632.7 | 1.080325 | [1.080297, 1.080354]   | 28,325 |         36.88 |
| comment-string / scalar |   380,954.7 |   352,646.7 | 1.080273 | [1.080260, 1.080286]   | 28,308 |         36.86 |
| malformed-early / byte  |         2.1 |        −7.4 |        — | no admission runs      |      — |             — |
| malformed-late / byte   |         1.5 |         1.2 |        — | no admission runs      |      — |             — |

The intervals on the admission-only rows propagate the two stages' standard deviations through the
difference at seven rounds; the receipt's own intervals are on the undifferenced stages.

Cohort censuses, which the two-term decomposition below uses:

| Cohort         | definitions | modules | references | base relations | binders | symbols |
|----------------|------------:|--------:|-----------:|---------------:|--------:|--------:|
| ascii          |         576 |      64 |      3,520 |            903 |     896 |   1,545 |
| unicode        |         576 |      64 |      3,520 |            903 |     896 |   1,545 |
| comment-string |         512 |       0 |        768 |            384 |     128 |     896 |

Other events on the two ASCII byte-scanner operations:

| Operation        | Event         |    ratio | interval                           |   candidate |     control |
|------------------|---------------|---------:|------------------------------------|------------:|------------:|
| ascii/admit/byte | instructions  | 1.025335 | [1.025334, 1.025335]               | 3,735,954.6 | 3,643,643.8 |
| ascii/admit/byte | cycles        | 1.018477 | [1.006281, 1.030820]               |   628,931.7 |   617,581.8 |
| ascii/admit/byte | branches      | 1.011938 | sd 0.14 and 0.28                   |   794,735.2 |   785,359.4 |
| ascii/admit/byte | branch-misses | 1.034306 | [0.565226, 1.892674]; inconclusive |       252.2 |       296.2 |
| ascii/parse/byte | instructions  | 1.000000 | [0.999998, 1.000002]; inconclusive | 2,507,812.4 | 2,507,812.9 |
| ascii/parse/byte | cycles        | 1.009214 | [0.988112, 1.030767]; inconclusive |   408,703.7 |   404,993.5 |
| ascii/parse/byte | branches      | 1.000000 | sd 0.34 and 0.42                   |   542,562.1 |   542,562.3 |
| ascii/parse/byte | branch-misses | 2.637454 | [0.833286, 8.347871]; inconclusive |       159.2 |        25.1 |

Cycles on the admit stage track the instruction ratio within their interval, so the change bought
no extra stall and paid none beyond its instructions. Branch-miss counts are a few hundred per
iteration against three and a half million instructions and their intervals span an order of
magnitude either way; nothing is read from them. Page faults and minor faults are zero per
iteration on both arms for every cohort stage.

Admission-only branches on ASCII: 252,173.2 against 242,797.1, ratio 1.038617, 9,376 branches
added, 2.66 per reference — the scope scan's compare-and-increment and the `position`/`best`
comparison that replaced the loop's return.

`prepare` and `prepare-touch`, all recorded events per iteration:

| Stage         | Event         |   candidate |     control |    ratio | interval               |
|---------------|---------------|------------:|------------:|---------:|------------------------|
| prepare       | instructions  |     7,107.7 |     5,865.4 | 1.211801 | [1.210943, 1.212659]   |
| prepare       | cycles        |     1,476.9 |     1,178.4 | 1.253489 | [1.216029, 1.292104]   |
| prepare       | branches      |     1,404.6 |     1,163.7 | 1.206970 | sd 0.19 and 0.19       |
| prepare       | page-faults   |       0.002 |       0.002 |        — | equal                  |
| prepare       | minor-faults  |       0.002 |       0.002 |        — | equal                  |
| prepare-touch | instructions  |    20,688.3 |    19,331.7 | 1.070179 | [1.070087, 1.070271]   |
| prepare-touch | cycles        |   744,631.5 |   733,959.6 | 1.014573 | [1.005859, 1.023362]   |
| prepare-touch | branches      |     4,595.3 |     4,335.5 | 1.059942 | sd 0.24 and 0.32       |
| prepare-touch | page-faults   |   1,536.000 |   1,536.000 |        — | equal, sd 0 on both    |
| prepare-touch | minor-faults  |   1,536.000 |   1,536.000 |        — | equal, sd 0 on both    |

`prepare-touch`'s own page census, which the binary records rather than perf, moves as predicted:
**1,614 touched pages in the candidate against 1,597 in the control, +17**, which is
67,588 bytes spanning seventeen 4 KiB pages. The perf software fault counters sit at 1,536.000 per
iteration on both arms with zero standard deviation and do not resolve the change, because the
differencing subtracts a constant fault floor; the binary's `touched_pages` is the load-bearing
number for this stage, as the driver's own note says.

Retained bytes, from the receipt records, identical on every operation within an arm:

| Arm       | retained bytes | delta   | composition of the delta         |
|-----------|---------------:|--------:|----------------------------------|
| control   |      6,539,264 |       — | —                                |
| candidate |      6,606,852 | +67,588 | 65,536 for `owners` (8 × 8,192 symbols) + 2,052 for `scope` (4 × 513) |

Occupied bytes are unchanged on every cohort, so no logical record grew; only the reserved pools
did.

Peak RSS, from the binary's own high-water record:

| Operation                    | candidate | control | delta |
|------------------------------|----------:|--------:|------:|
| ascii/admit/byte and scalar  |     6,080 |   5,992 |   +88 |
| ascii/parse (all three)      |     5,960 |   5,964 |    −4 |
| unicode/admit/byte and scalar|     6,108 |   6,016 |   +92 |
| unicode/parse (all three)    |     5,988 |   5,992 |    −4 |
| comment-string/admit         |     5,652 |   5,560 |   +92 |
| comment-string/parse         |     5,544 |   5,548 |    −4 |
| malformed-late (all)         |     5,988 |   5,972 |   +16 |
| prepare                      |    14,188 |  14,180 |    +8 |
| prepare-touch                |    12,340 |  12,156 |  +184 |

KiB throughout. The admit operations pay 88 to 92 KiB, more than the 66 KiB the pools grew, and the
parse operations are 4 KiB *lower* in the candidate although its pools are larger — the parse stage
never touches the new pools, so that pair of movements is mapping layout, recorded rather than
explained.

## Results — `4b02031` over `7b38c65`, what the rework did

The rework is a regression of the same order as the thing it was meant to repair. Instructions per
iteration:

| Operation                       |      candidate |        control |    ratio | interval               |
|---------------------------------|---------------:|---------------:|---------:|------------------------|
| prepare (standalone)            |        7,110.2 |        7,104.5 | 1.000803 | [0.999101, 1.002508]   |
| prepare-touch (standalone)      |       20,691.2 |       20,689.6 | 1.000079 | [0.999903, 1.000255]   |
| ascii/parse/byte                |    2,507,813.4 |    2,507,815.3 | 0.999999 | [0.999998, 1.000001]   |
| ascii/parse/scalar              |    3,868,232.0 |    3,868,232.3 | 1.000000 | [0.999999, 1.000000]   |
| ascii/admit/byte                |    3,782,373.4 |    3,735,956.1 | 1.012424 | [1.012424, 1.012425]   |
| ascii/admit/scalar              |    5,142,782.0 |    5,096,363.9 | 1.009108 | [1.009108, 1.009108]   |
| unicode/parse/byte              |    8,733,234.6 |    8,733,237.6 | 1.000000 | [0.999999, 1.000000]   |
| unicode/parse/scalar            |    9,549,995.0 |    9,549,996.2 | 1.000000 | [0.999999, 1.000001]   |
| unicode/admit/byte              |   10,195,031.1 |   10,148,851.6 | 1.004550 | [1.004550, 1.004551]   |
| unicode/admit/scalar            |   11,011,794.8 |   10,965,611.0 | 1.004212 | [1.004211, 1.004212]   |
| comment-string/parse/byte       |    1,401,970.5 |    1,401,973.3 | 0.999998 | [0.999993, 1.000003]   |
| comment-string/parse/scalar     |    1,899,599.9 |    1,899,598.4 | 1.000001 | [0.999999, 1.000003]   |
| comment-string/admit/byte       |    1,822,736.5 |    1,782,930.6 | 1.022326 | [1.022322, 1.022330]   |
| comment-string/admit/scalar     |    2,320,359.1 |    2,280,545.8 | 1.017458 | [1.017456, 1.017459]   |
| malformed-early/parse/byte      |    1,098,170.8 |    1,098,161.5 | 1.000008 | [1.000002, 1.000015]   |
| malformed-early/parse/scalar    |    2,456,415.4 |    2,456,416.5 | 1.000000 | [0.999999, 1.000000]   |
| malformed-early/admit/byte      |    1,098,169.6 |    1,098,159.6 | 1.000009 | [1.000004, 1.000014]   |
| malformed-early/admit/scalar    |    2,456,415.6 |    2,456,417.0 | 0.999999 | [0.999998, 1.000001]   |
| malformed-late/parse/byte       |    2,504,007.1 |    2,504,007.4 | 1.000000 | [0.999998, 1.000002]   |
| malformed-late/parse/scalar     |    3,862,638.3 |    3,862,638.0 | 1.000000 | [0.999999, 1.000001]   |
| malformed-late/admit/byte       |    2,504,005.6 |    2,504,006.1 | 1.000000 | [0.999998, 1.000001]   |
| malformed-late/admit/scalar     |    3,862,639.3 |    3,862,638.9 | 1.000000 | [0.999999, 1.000001]   |

`prepare`, `prepare-touch` and parse are unchanged, as the Fermi said they would be: both standalone
ratios are inconclusive and every parse operation is inside its null. The two malformed-early rows
sit nine instructions above unity in 1.1 million, four parts per million and four times that
cohort's own null, which is the layout noise that cohort's byte scanner carries; no admission runs
there.

Admission alone (`admit` − `parse`):

| Cohort / variant        |   candidate |     control |    ratio | interval               |  added | per reference |
|-------------------------|------------:|------------:|---------:|------------------------|-------:|--------------:|
| ascii / byte            | 1,274,560.1 | 1,228,140.9 | 1.037796 | [1.037792, 1.037801]   | 46,419 |         13.19 |
| ascii / scalar          | 1,274,550.0 | 1,228,131.6 | 1.037796 | [1.037792, 1.037800]   | 46,418 |         13.19 |
| unicode / byte          | 1,461,796.4 | 1,415,614.0 | 1.032624 | [1.032619, 1.032628]   | 46,183 |         13.12 |
| unicode / scalar        | 1,461,799.8 | 1,415,614.9 | 1.032625 | [1.032618, 1.032632]   | 46,185 |         13.12 |
| comment-string / byte   |   420,766.0 |   380,957.3 | 1.104497 | [1.104472, 1.104521]   | 39,809 |         51.83 |
| comment-string / scalar |   420,759.2 |   380,947.3 | 1.104508 | [1.104495, 1.104521]   | 39,812 |         51.84 |

Comment-string, which declares no module and therefore exercises none of the scope machinery, pays
four times as much per reference as ASCII. That is the signature of a cost that scales with symbols
rather than references, and comment-string has 896 symbols against 768 references while ASCII has
1,545 against 3,520.

Solving a per-symbol term against a per-reference term on those two censuses:

```
1,545 symbols × i − 3,520 references × p = 46,419   (ascii)
  896 symbols × i −   768 references × p = 39,809   (comment-string)
```

gives **i = 53.1 instructions added per symbol inserted and p = 10.1 instructions recovered per
reference**. Substituting Unicode's census, which equals ASCII's, predicts 46,426 against 46,183
measured. The rework therefore recovered 44 per cent of the 22.8 per reference that `7b38c65` had
added — the loop really is leaner — and paid for it with a 53-instruction call shape on every one
of the 1,545 symbols an ASCII admission inserts.

Other events on `ascii/admit/byte`: cycles 1.019879 [0.998971, 1.041226], inconclusive but tracking
instructions; branches 801,615.5 against 794,735.6, ratio 1.008657; branch-misses 1.649650
[0.934160, 2.913144], inconclusive on counts of a few hundred. Page faults and minor faults are zero
per iteration on both arms.

Retained bytes are 6,606,852 on both arms and `prepare-touch` touches 1,614 pages on both, so the
rework changed no pool. Peak RSS rises a further 16 to 44 KiB on every operation, tabulated below.

## Results — `4b02031` over `93bb343`, the composed cost of the feature

This is the number that says what module scoping costs today. Instructions per iteration:

| Operation                       |      candidate |        control |    ratio | interval               |
|---------------------------------|---------------:|---------------:|---------:|------------------------|
| prepare (standalone)            |        7,107.7 |        5,865.8 | 1.211719 | [1.210479, 1.212960]   |
| prepare-touch (standalone)      |       20,690.6 |       19,333.7 | 1.070185 | [1.070026, 1.070343]   |
| ascii/parse/byte                |    2,507,811.2 |    2,507,813.5 | 0.999999 | [0.999998, 1.000000]   |
| ascii/parse/scalar              |    3,868,232.0 |    3,868,230.1 | 1.000000 | [1.000000, 1.000001]   |
| ascii/admit/byte                |    3,782,374.0 |    3,643,644.0 | 1.038075 | [1.038074, 1.038075]   |
| ascii/admit/scalar              |    5,142,784.1 |    5,004,052.2 | 1.027724 | [1.027723, 1.027725]   |
| unicode/parse/byte              |    8,733,235.1 |    8,733,233.6 | 1.000000 | [1.000000, 1.000000]   |
| unicode/parse/scalar            |    9,549,994.8 |    9,549,998.7 | 1.000000 | [0.999999, 1.000000]   |
| unicode/admit/byte              |   10,195,029.3 |   10,056,611.9 | 1.013764 | [1.013763, 1.013764]   |
| unicode/admit/scalar            |   11,011,790.8 |   10,873,374.5 | 1.012730 | [1.012729, 1.012730]   |
| comment-string/parse/byte       |    1,401,961.1 |    1,401,966.1 | 0.999996 | [0.999993, 1.000000]   |
| comment-string/parse/scalar     |    1,899,599.5 |    1,899,600.2 | 1.000000 | [0.999998, 1.000002]   |
| comment-string/admit/byte       |    1,822,733.5 |    1,754,604.1 | 1.038829 | [1.038824, 1.038833]   |
| comment-string/admit/scalar     |    2,320,358.0 |    2,252,238.1 | 1.030245 | [1.030245, 1.030246]   |
| malformed-early/parse/byte      |    1,098,168.6 |    1,098,170.1 | 0.999999 | [0.999989, 1.000008]   |
| malformed-early/parse/scalar    |    2,456,427.3 |    2,456,423.0 | 1.000002 | [0.999999, 1.000004]   |
| malformed-early/admit/byte      |    1,098,172.5 |    1,098,165.9 | 1.000006 | [0.999999, 1.000014]   |
| malformed-early/admit/scalar    |    2,456,417.3 |    2,456,416.2 | 1.000000 | [0.999999, 1.000002]   |
| malformed-late/parse/byte       |    2,504,006.5 |    2,504,005.3 | 1.000000 | [0.999998, 1.000003]   |
| malformed-late/parse/scalar     |    3,862,638.3 |    3,862,639.2 | 1.000000 | [0.999999, 1.000000]   |
| malformed-late/admit/byte       |    2,504,008.2 |    2,504,007.2 | 1.000000 | [0.999998, 1.000003]   |
| malformed-late/admit/scalar     |    3,862,640.3 |    3,862,638.9 | 1.000000 | [1.000000, 1.000001]   |

Admission alone (`admit` − `parse`):

| Cohort / variant        |   candidate |     control |    ratio | interval               |   added | per reference |
|-------------------------|------------:|------------:|---------:|------------------------|--------:|--------------:|
| ascii / byte            | 1,274,562.8 | 1,135,830.5 | 1.122142 | [1.122138, 1.122146]   | 138,732 |         39.41 |
| ascii / scalar          | 1,274,552.0 | 1,135,822.1 | 1.122141 | [1.122136, 1.122145]   | 138,730 |         39.41 |
| unicode / byte          | 1,461,794.2 | 1,323,378.3 | 1.104593 | [1.104587, 1.104599]   | 138,416 |         39.32 |
| unicode / scalar        | 1,461,796.1 | 1,323,375.8 | 1.104596 | [1.104590, 1.104602]   | 138,420 |         39.32 |
| comment-string / byte   |   420,772.4 |   352,638.0 | 1.193214 | [1.193180, 1.193247]   |  68,134 |         88.72 |
| comment-string / scalar |   420,758.5 |   352,637.9 | 1.193174 | [1.193161, 1.193188]   |  68,121 |         88.70 |

The composed ASCII delta is the sum of the two steps to within two instructions: 92,311 + 46,419 =
138,730 against 138,732 measured, which is the internal consistency check the three-way design
buys.

Other events on `ascii/admit/byte`: cycles 1.044908 [1.018941, 1.071537], above unity and tracking
the instruction ratio; branches 801,615.4 against 785,359.6, ratio 1.020699; branch-misses 0.909686,
inconclusive. `prepare` and `prepare-touch` reproduce the `7b38c65` figures (1.211719 and 1.070185
against 1.211801 and 1.070179), and `prepare-touch` touches 1,614 pages against 1,597, confirming
that the rework moved neither.

Peak RSS, candidate `4b02031` against control `93bb343`, with the `7b38c65` value for comparison:

| Operation                     | `4b02031` | `7b38c65` | `93bb343` |
|-------------------------------|----------:|----------:|----------:|
| ascii/admit/byte              |     6,108 |     6,080 |     5,992 |
| ascii/parse/byte              |     6,000 |     5,960 |     5,964 |
| unicode/admit/byte            |     6,136 |     6,108 |     6,016 |
| comment-string/admit/byte     |     5,680 |     5,652 |     5,560 |
| malformed-late/admit/byte     |     6,024 |     5,988 |     5,972 |
| prepare                       |    14,228 |    14,188 |    14,180 |
| prepare-touch                 |    12,384 |    12,340 |    12,156 |

KiB throughout. `4b02031` is 16 to 44 KiB above `7b38c65` everywhere although it allocates nothing
new; the two new out-of-line functions and the larger `run` frame are the only differences, so this
is again mapping layout at 4 KiB granularity.

## Results — `9bfe19d` over `4b02031`, inlining `insert`

The first prediction of the three to hold. Instructions per iteration:

| Operation                       |      candidate |        control |    ratio | interval               |
|---------------------------------|---------------:|---------------:|---------:|------------------------|
| prepare (standalone)            |        7,105.0 |        7,108.8 | 0.999470 | [0.998537, 1.000404]   |
| prepare-touch (standalone)      |       20,563.4 |       20,561.7 | 1.000082 | [0.999965, 1.000198]   |
| ascii/parse/byte                |    2,507,812.5 |    2,507,813.2 | 1.000000 | [0.999998, 1.000001]   |
| ascii/parse/scalar              |    3,868,221.8 |    3,868,221.9 | 1.000000 | [0.999999, 1.000001]   |
| ascii/admit/byte                |    3,754,508.8 |    3,782,354.0 | 0.992638 | [0.992637, 0.992639]   |
| ascii/admit/scalar              |    5,114,928.9 |    5,142,775.4 | 0.994585 | [0.994585, 0.994586]   |
| unicode/parse/byte              |    8,733,235.8 |    8,733,235.6 | 1.000000 | [0.999999, 1.000001]   |
| unicode/parse/scalar            |    9,549,996.9 |    9,549,995.8 | 1.000000 | [1.000000, 1.000001]   |
| unicode/admit/byte              |   10,167,130.7 |   10,195,015.2 | 0.997265 | [0.997264, 0.997266]   |
| unicode/admit/scalar            |   10,983,890.5 |   11,011,783.5 | 0.997467 | [0.997466, 0.997468]   |
| comment-string/parse/byte       |    1,401,964.5 |    1,401,970.8 | 0.999995 | [0.999990, 1.000001]   |
| comment-string/parse/scalar     |    1,899,599.6 |    1,899,599.0 | 1.000000 | [0.999999, 1.000002]   |
| comment-string/admit/byte       |    1,806,389.2 |    1,822,734.2 | 0.991033 | [0.991029, 0.991036]   |
| comment-string/admit/scalar     |    2,304,023.1 |    2,320,366.2 | 0.992957 | [0.992955, 0.992958]   |
| malformed-early/parse/byte      |    1,098,172.2 |    1,098,168.0 | 1.000004 | [0.999995, 1.000012]   |
| malformed-early/parse/scalar    |    2,456,422.8 |    2,456,424.0 | 1.000000 | [0.999999, 1.000000]   |
| malformed-early/admit/byte      |    1,098,167.5 |    1,098,167.4 | 1.000000 | [0.999994, 1.000006]   |
| malformed-early/admit/scalar    |    2,456,423.9 |    2,456,425.4 | 0.999999 | [0.999999, 1.000000]   |
| malformed-late/parse/byte       |    2,504,004.8 |    2,504,005.3 | 1.000000 | [0.999998, 1.000001]   |
| malformed-late/parse/scalar     |    3,862,638.2 |    3,862,638.5 | 1.000000 | [0.999999, 1.000001]   |
| malformed-late/admit/byte       |    2,504,007.1 |    2,504,004.8 | 1.000001 | [0.999999, 1.000003]   |
| malformed-late/admit/scalar     |    3,862,639.8 |    3,862,638.5 | 1.000000 | [1.000000, 1.000001]   |

Admission alone (`admit` − `parse`):

| Cohort / variant        |   candidate |     control |    ratio | interval               | removed | per symbol inserted |
|-------------------------|------------:|------------:|---------:|------------------------|--------:|--------------------:|
| ascii / byte            | 1,246,696.3 | 1,274,540.8 | 0.978153 | [0.978148, 0.978159]   |  27,845 |               18.02 |
| ascii / scalar          | 1,246,707.1 | 1,274,553.4 | 0.978152 | [0.978148, 0.978156]   |  27,846 |               18.02 |
| unicode / byte          | 1,433,894.9 | 1,461,779.6 | 0.980924 | [0.980918, 0.980930]   |  27,885 |               18.05 |
| unicode / scalar        | 1,433,893.6 | 1,461,787.7 | 0.980918 | [0.980913, 0.980923]   |  27,894 |               18.05 |
| comment-string / byte   |   404,424.7 |   420,763.4 | 0.961169 | [0.961149, 0.961189]   |  16,339 |               18.23 |
| comment-string / scalar |   404,423.5 |   420,767.2 | 0.961157 | [0.961147, 0.961167]   |  16,344 |               18.24 |

This is the cleanest measurement in the report. Per symbol inserted the saving is 18.02, 18.05 and
18.23 on three cohorts whose reference-to-symbol ratios run from 0.86 to 2.28, so the effect is
identified as per-symbol without any fitting: inlining `insert` removed a call shape, and nothing
else moved. It is also the reason the previous step's 53.1 per symbol splits: 18.0 of it was the
out-of-line call and 35.1 is the shadow-flagging walk that commit also added.

`prepare`, `prepare-touch` and parse are unchanged, as the Fermi said. Retained bytes are 6,606,852
on both arms and `prepare-touch` touches 1,614 pages on both.

## Results — `9bfe19d` over `93bb343`, the composed cost of the feature today

| Operation                       |      candidate |        control |    ratio | interval               |
|---------------------------------|---------------:|---------------:|---------:|------------------------|
| prepare (standalone)            |        7,106.8 |        5,865.0 | 1.211741 | [1.210938, 1.212545]   |
| prepare-touch (standalone)      |       20,689.2 |       19,332.3 | 1.070189 | [1.070025, 1.070353]   |
| ascii/parse/byte                |    2,507,812.3 |    2,507,811.5 | 1.000000 | [0.999999, 1.000002]   |
| ascii/parse/scalar              |    3,868,232.3 |    3,868,231.1 | 1.000000 | [1.000000, 1.000001]   |
| ascii/admit/byte                |    3,754,527.4 |    3,643,643.3 | 1.030432 | [1.030432, 1.030433]   |
| ascii/admit/scalar              |    5,114,936.0 |    5,004,052.1 | 1.022159 | [1.022158, 1.022160]   |
| unicode/parse/byte              |    8,733,235.4 |    8,733,236.1 | 1.000000 | [1.000000, 1.000000]   |
| unicode/parse/scalar            |    9,549,999.5 |    9,549,997.9 | 1.000000 | [1.000000, 1.000001]   |
| unicode/admit/byte              |   10,167,138.8 |   10,056,611.9 | 1.010990 | [1.010990, 1.010991]   |
| unicode/admit/scalar            |   10,983,901.7 |   10,873,378.0 | 1.010165 | [1.010164, 1.010165]   |
| comment-string/parse/byte       |    1,401,969.6 |    1,401,963.8 | 1.000004 | [1.000000, 1.000008]   |
| comment-string/parse/scalar     |    1,899,600.1 |    1,899,598.6 | 1.000001 | [0.999999, 1.000002]   |
| comment-string/admit/byte       |    1,806,386.3 |    1,754,602.3 | 1.029513 | [1.029507, 1.029519]   |
| comment-string/admit/scalar     |    2,304,022.6 |    2,252,244.0 | 1.022990 | [1.022988, 1.022991]   |
| malformed-early/parse/byte      |    1,098,172.0 |    1,098,170.6 | 1.000001 | [0.999999, 1.000004]   |
| malformed-early/parse/scalar    |    2,456,422.8 |    2,456,422.6 | 1.000000 | [0.999999, 1.000001]   |
| malformed-early/admit/byte      |    1,098,173.6 |    1,098,171.8 | 1.000002 | [0.999994, 1.000009]   |
| malformed-early/admit/scalar    |    2,456,424.8 |    2,456,424.7 | 1.000000 | [0.999999, 1.000001]   |
| malformed-late/parse/byte       |    2,504,005.5 |    2,504,006.8 | 0.999999 | [0.999998, 1.000001]   |
| malformed-late/parse/scalar     |    3,862,637.9 |    3,862,638.2 | 1.000000 | [0.999999, 1.000001]   |
| malformed-late/admit/byte       |    2,504,008.1 |    2,504,006.1 | 1.000001 | [0.999999, 1.000003]   |
| malformed-late/admit/scalar     |    3,862,640.1 |    3,862,640.6 | 1.000000 | [0.999999, 1.000001]   |

Admission alone (`admit` − `parse`):

| Cohort / variant        |   candidate |     control |    ratio | interval               |   added | per reference |
|-------------------------|------------:|------------:|---------:|------------------------|--------:|--------------:|
| ascii / byte            | 1,246,715.1 | 1,135,831.9 | 1.097623 | [1.097620, 1.097626]   | 110,883 |         31.50 |
| ascii / scalar          | 1,246,703.7 | 1,135,821.0 | 1.097623 | [1.097620, 1.097627]   | 110,883 |         31.50 |
| unicode / byte          | 1,433,903.4 | 1,323,375.8 | 1.083519 | [1.083514, 1.083525]   | 110,528 |         31.40 |
| unicode / scalar        | 1,433,902.2 | 1,323,380.2 | 1.083515 | [1.083509, 1.083521]   | 110,522 |         31.40 |
| comment-string / byte   |   404,416.7 |   352,638.5 | 1.146831 | [1.146794, 1.146867]   |  51,778 |         67.42 |
| comment-string / scalar |   404,422.5 |   352,645.5 | 1.146825 | [1.146811, 1.146838]   |  51,777 |         67.42 |

Other events on `ascii/admit/byte`: cycles 1.042494 [1.032126, 1.052966], above unity and tracking
instructions; branches 797,858.4 against 785,359.3, ratio 1.015915; branch-misses 1.049922,
inconclusive. `prepare` reproduces 1.211741 against `7b38c65`'s 1.211801 and `prepare-touch`
1.070189 against 1.070179, so neither later commit moved either.

### The three-term cost model, closed

With the per-symbol saving measured directly and the per-reference saving from the `4b02031` step,
the composed cost solves into three coefficients that hold on both independent cohorts:

| Term                                                    | per             | instructions | ascii   | comment-string |
|---------------------------------------------------------|-----------------|-------------:|--------:|---------------:|
| `enter_scope`'s module-chain build                       | body            |         21.2 |  12,205 |         10,849 |
| owner load, `SHADOWED` test, chain scan in the probe     | reference       |         12.6 |  44,493 |          9,708 |
| the shadow-flagging walk inside `insert`                 | symbol inserted |         35.1 |  54,199 |         31,444 |
| **predicted total**                                      |                 |              | **110,897** |     **52,001** |
| **measured**                                             |                 |              | **110,883** |     **51,778** |

Agreement is 0.01 per cent on ASCII and 0.4 per cent on comment-string, on two cohorts whose body,
reference and symbol counts are 576/3,520/1,545 and 512/768/896. The model is over-determined and
holds, which is what the earlier two-term fits could not claim.

Peak RSS, candidate against control, with the two earlier candidates for comparison:

| Operation                     | `9bfe19d` | `4b02031` | `7b38c65` | `93bb343` |
|-------------------------------|----------:|----------:|----------:|----------:|
| ascii/admit/byte              |     6,128 |     6,108 |     6,080 |     5,992 |
| ascii/parse/byte              |     6,016 |     6,000 |     5,960 |     5,964 |
| unicode/admit/byte            |     6,156 |     6,136 |     6,108 |     6,016 |
| comment-string/admit/byte     |     5,700 |     5,680 |     5,652 |     5,560 |
| malformed-late/admit/byte     |     6,044 |     6,024 |     5,988 |     5,972 |
| prepare                       |    14,244 |    14,228 |    14,188 |    14,180 |
| prepare-touch                 |    12,312 |    12,384 |    12,340 |    12,156 |

KiB throughout. The high-water mark creeps up by about 20 KiB at each commit after the first
although only `7b38c65` allocated anything; at 4 KiB granularity this is mapping layout tracking
text size, recorded rather than explained.

## Disassembly at `7b38c65`

`objdump -d --no-show-raw-insn -M intel` on both retained binaries, symbols extracted to
`~/.cache/ergodis/perf-c1170/run-7b38c65.s`, `qualified-7b38c65.s`, `admitfn-7b38c65.s`,
`declare-7b38c65.s`, `is_builtin-7b38c65.s`, `run-93bb343.s`, `declare-93bb343.s` and
`workspace-admit-93bb343.s`.

`nm -C --size-sort -S` on the two binaries, every symbol matching `rel_frontend::admit::`:

| Symbol                    | control size | candidate size | note                                        |
|---------------------------|-------------:|---------------:|---------------------------------------------|
| `admit::run`              |    3,659 B   |      4,730 B   | the reference walker                        |
| `admit::bind_list`        |    1,496 B   |      1,496 B   | byte-identical size                         |
| `admit::declare`          |      869 B   |        963 B   | now also writes the `owners` entry          |
| `admit::is_builtin`       |      419 B   |        419 B   | unchanged                                   |
| `admit::admit`            |            — |      2,644 B   | **new out-of-line symbol**                  |
| `admit::qualified`        |            — |      3,686 B   | **new out-of-line symbol**                  |
| `Workspace::admit`        |    1,846 B   |         14 B   | a thunk in the candidate; the body moved into `admit::admit` |

`lookup`, `reference`, `member`, `check_definition` and `enter_scope` are all inlined and carry no
symbol in either binary.

| Measure                                   | control `run` | candidate `run` | candidate `qualified` | control `Workspace::admit` | candidate `admit::admit` |
|-------------------------------------------|--------------:|----------------:|----------------------:|---------------------------:|-------------------------:|
| instructions in the symbol                |           854 |           1,067 |                   856 |                        409 |                      583 |
| instructions in the trailing cold block   |            68 |              98 |                     — |                          — |                        — |
| cold panic and bounds-check call sites    |            19 |              23 |                    24 |                          1 |                        1 |
| callee-saved `push` in the prologue       |             6 |               6 |                     6 |                          6 |                        6 |
| stack frame                               | `sub rsp,0x98`|  `sub rsp,0xd8` |        `sub rsp,0xc8` |             `sub rsp,0x98` |           `sub rsp,0xa8` |
| stack stores `mov PTR [rsp+…], reg`      |            40 |              45 |                    64 |                         16 |                       20 |
| stack reloads `mov reg, PTR [rsp+…]`     |           112 |             156 |                    78 |                         29 |                       55 |

The stack counts are over the hot region for `run`, whose panic blocks sit in one trailing tail,
and over the whole symbol for the other three, whose bounds-check blocks are interleaved and have no
single boundary to cut at.

`run` grew by 213 instructions of static text and 64 bytes of frame. The two new out-of-line
symbols are the qualified-spine walker and the body loop: the compiler kept `admit::admit` inlined
into `Workspace::admit` in the control and pushed it out of line in the candidate once
`check_definition` and `enter_scope` were inlined into it, so `Workspace::admit` is now a
fourteen-byte thunk.

Every `call` instruction inside `run`:

| Binary    | Address                          | Target                                | Kind                                                     |
|-----------|----------------------------------|---------------------------------------|----------------------------------------------------------|
| control   | `0x8691e0`                       | `admit::bind_list`                    | hot                                                      |
| control   | `0x869853`, `0x86995d`           | `admit::is_builtin`                   | hot, first-sight path                                    |
| control   | `0x8698a9`, `0x869a01`           | `alloc::raw_vec::RawVec::grow_one`    | cold, the `symbols.push` slow path behind a length test   |
| control   | `0x869c5b`                       | `core::slice::index::slice_index_fail`| cold panic path                                          |
| control   | eighteen sites from `0x869c6b`   | `core::panicking::panic_bounds_check` | cold panic paths                                         |
| candidate | `0x81c150`                       | `admit::bind_list`                    | hot                                                      |
| candidate | `0x81c4ac`                       | `admit::qualified`                    | hot in principle, **never executed on any bench cohort**  |
| candidate | `0x81c8f4`, `0x81cddb`           | `admit::is_builtin`                   | hot, first-sight path                                    |
| candidate | `0x81c93c`, `0x81ce71`           | `RawVec::grow_one` (`symbols`)        | cold, behind a length test that excludes it               |
| candidate | `0x81c99c`, `0x81cede`           | `RawVec::grow_one` (`owners`)         | cold, **new**, the second pool's push slow path           |
| candidate | `0x81d089`                       | `core::slice::index::slice_index_fail`| cold panic path                                          |
| candidate | twenty-two sites from `0x81d0d6` | `core::panicking::panic_bounds_check` | cold panic paths                                         |

**No libc symbol is called from either binary's `run`, or from the candidate's `qualified`**: no
`memcmp`, `memcpy`, `memset` or `bcmp` appears in those listings, so the per-byte name compares are
still compiled as explicit loops. `admit::admit` calls `memset` at three sites in the candidate and
the control's `Workspace::admit` calls it at the same three; that is the index clear at the start of
each admission and is not new.

### Compiled per-reference path count

Control, the probe prologue at `0x869586`–`0x8695b1`: load the index pointer, spill it, load the
first slot, test it, branch out on empty, then three loads for the symbol pool's pointer and length
and one spill — **ten instructions**. Its loop body is six instructions on the miss path plus seven
for the filter and length test, and on a compatible match it returns from inside the loop with the
symbol still in registers.

Candidate, the same prologue at `0x81ca6a`–`0x81caf1`: the same first-slot load, test and branch,
then the symbol pool pointer and length, **the `owners` pointer and length, the `scope` pointer and
length**, `best` initialized to `-1`, `admitted` to `0xffffffff`, `matched` to `0`, and six spills
to hold them across a loop that can no longer return — **twenty-one instructions**, eleven more,
paid by every reference that reaches the probe.

The loop body is seven on the miss path plus seven for the filter and length test, one more than the
control on each because the loop now carries `best` in `rbx` and shuffles it through `r9` each turn.

On a spelling match the candidate then runs, at `0x81cb5b`–`0x81cb77`, six stores that put the
matched symbol's site, arity and two flag bytes in the frame — work the control did not do, because
it returned instead. The scope scan proper is at `0x81cbee`–`0x81cc1c`: five instructions of setup
(load `owners[id].module`, zero the position, reload the scope base) and **four per chain entry**
(`cmp DWORD PTR [r11+r9*4],ecx` / `je` / `inc r9` / `cmp rbp,r9` / `jne`), then six at
`0x81cc50`–`0x81cc5e` for the `position <= best` and `position < best` comparisons. That is about
fifteen instructions for a top-level body, whose chain is one entry, and about nineteen for a body
inside one module, against the Fermi's eight. After the loop the post-loop block re-indexes
`w.symbols[admitted]` with its own bounds check and re-reads the flags the in-loop path had in
registers.

### Where the instructions went, solved from the censuses

Two cohorts differ in both bodies and references and neither contains module parameters or
qualified spines, so a two-term model is identified:

```
512 bodies + 768 references = 28,325   (comment-string, no modules at all)
576 bodies + 3,520 references = 92,311 (ascii, 64 modules)
```

giving **22.76 instructions per reference and 21.19 per body**. Substituting back reproduces ASCII
to four instructions in 92,311 and comment-string to one in 28,325. Unicode has ASCII's census
exactly, so its agreement (92,239 predicted against 92,311 for ASCII, the two cohorts' own spread)
is a repeat rather than an independent check. The per-reference figure matches the listing: eleven
in the enlarged prologue plus about twelve amortized over the match path's stores, scan and
comparisons, against the 3,520 references of which roughly half reach the probe at all.

## Disassembly at `4b02031`

`nm -C --size-sort -S`, every symbol matching `rel_frontend::admit::`, across the three binaries:

| Symbol             | `93bb343` | `7b38c65` | `4b02031` | note                                              |
|--------------------|----------:|----------:|----------:|---------------------------------------------------|
| `admit::run`       |   3,659 B |   4,730 B |   4,036 B | the reference walker                               |
| `admit::qualified` |         — |   3,686 B |   3,777 B | the qualified-spine walker                         |
| `admit::admit`     |         — |   2,644 B |   2,431 B | the body loop, out of line since `7b38c65`         |
| `admit::bind_list` |   1,496 B |   1,496 B |   1,496 B | unchanged in all three                             |
| `admit::declare`   |     869 B |     963 B |     706 B | smaller again once `insert` left it                |
| `admit::insert`    |         — |         — |     784 B | **new out-of-line symbol**                         |
| `admit::shadowed`  |         — |         — |   1,292 B | **new out-of-line symbol**, never executed on a bench cohort |
| `admit::is_builtin`|     419 B |     419 B |     419 B | unchanged in all three                             |

`lookup`, `reference`, `member`, `new_name`, `check_definition` and `enter_scope` carry no symbol in
any of the three.

| Measure                                 | `93bb343` `run` | `7b38c65` `run` | `4b02031` `run` | `4b02031` `insert` | `4b02031` `shadowed` |
|-----------------------------------------|----------------:|----------------:|----------------:|-------------------:|---------------------:|
| instructions in the symbol              |             854 |           1,067 |             903 |                188 |                  316 |
| instructions in the trailing cold block |              68 |              98 |             103 |                  — |                    — |
| stack frame                             |  `sub rsp,0x98` |  `sub rsp,0xd8` |  `sub rsp,0xf8` |     `sub rsp,0x38` |       `sub rsp,0x58` |
| stack stores, hot                       |              40 |              45 |              60 |                  7 |                   29 |
| stack reloads, hot                      |             112 |             156 |              92 |                 15 |                   31 |

The loop is leaner and the frame is not. `run`'s hot reloads fall from 156 to 92, below even the
pre-module 112, which is the 10.1 instructions per reference the cohort solve found. Its hot stores
rise from 45 to 60 and its frame from `0xd8` to `0xf8`, because the two sunk `shadowed` edges and the
two `insert` call sites must marshal arguments that used to stay in registers.

Every `call` instruction inside `4b02031`'s `run`:

| Address                          | Target                                 | Kind                                                         |
|----------------------------------|----------------------------------------|--------------------------------------------------------------|
| `0x80219b`                       | `admit::bind_list`                     | hot                                                          |
| `0x8024d1`                       | `admit::qualified`                     | hot in principle, never executed on any bench cohort          |
| `0x80286b`, `0x802be2`           | `admit::is_builtin`                    | hot, first-sight path                                        |
| `0x8028c3`, `0x802c56`           | `admit::insert`                        | **hot, new out of line**, once per symbol inserted            |
| `0x802cae`, `0x802cf4`           | `admit::shadowed`                      | **new**, on an edge sunk out of the probe loop; never taken on any bench cohort |
| `0x802e5a`                       | `core::slice::index::slice_index_fail` | cold panic path                                              |
| seventeen sites                  | `core::panicking::panic_bounds_check`  | cold panic paths                                             |

`RawVec::grow_one` no longer appears in `run` at all: it left with `insert`, and `admit::admit` now
carries four of those cold sites. **No libc symbol is called from `run`, `insert`, `shadowed` or
`qualified`** — no `memcmp`, `memcpy`, `memset` or `bcmp` — so the per-byte compares are still
explicit loops.

The `shadowed` call sites are not inside the loop body. The compiler sank both edges into a block of
their own at the end of the hot region, each rebuilding the six register arguments and three stack
arguments from the frame before the `call`. That is why the loop kept its shape; it is also why
`run`'s frame grew, since the sunk edges keep `lookup`'s arguments live.

The `insert` call sites are the expensive ones. At `0x802880`–`0x8028ee` the caller writes the six
`Symbol` fields into the frame, loads six argument registers, `lea`s the return slot and the symbol
pointer, pushes the two stack-passed `Owner` words, calls, adds back the stack, tests the result
tag, copies the sixteen-byte result with `movups`/`movaps` and tests the tag again — twenty-one
caller-side instructions. `insert` itself pushes six callee-saved registers, takes a `0x38` frame,
spills its arguments, and pops six on the way out. The 53.1 instructions per symbol the cohort solve
gives are that shape, and they match the 46 to 51 the previous report measured for the same call
shape on `admit::reference`.

## Disassembly at `9bfe19d`

`nm -C --size-sort -S` shows **no `admit::insert` symbol**, which is the whole of what the commit
was meant to do. The remaining `rel_frontend::admit::` symbols, across all four binaries:

| Symbol             | `93bb343` | `7b38c65` | `4b02031` | `9bfe19d` |
|--------------------|----------:|----------:|----------:|----------:|
| `admit::run`       |   3,659 B |   4,730 B |   4,036 B |   5,102 B |
| `admit::qualified` |         — |   3,686 B |   3,777 B |   4,268 B |
| `admit::admit`     |         — |   2,644 B |   2,431 B |   2,431 B |
| `admit::shadowed`  |         — |         — |   1,292 B |   1,993 B |
| `admit::bind_list` |   1,496 B |   1,496 B |   1,496 B |   1,496 B |
| `admit::declare`   |     869 B |     963 B |     706 B |   1,500 B |
| `admit::insert`    |         — |         — |     784 B |         — |
| `admit::is_builtin`|     419 B |     419 B |     419 B |     419 B |

`insert`'s 784 bytes went back into its three callers: `run` gains 1,066, `declare` 794 and
`shadowed` 701, which is the text price of the 18 instructions per symbol the measurement recovered.
`admit::admit` is byte-for-byte unchanged, as expected — it does not insert.

| Measure                                 | `93bb343` `run` | `7b38c65` `run` | `4b02031` `run` | `9bfe19d` `run` |
|-----------------------------------------|----------------:|----------------:|----------------:|----------------:|
| instructions in the symbol              |             854 |           1,067 |             903 |           1,142 |
| instructions in the trailing cold block |              68 |              98 |             103 |             126 |
| stack frame                             |  `sub rsp,0x98` |  `sub rsp,0xd8` |  `sub rsp,0xf8` |  `sub rsp,0xe8` |
| stack stores, hot                       |              40 |              45 |              60 |              57 |
| stack reloads, hot                      |             112 |             156 |              92 |             137 |

The frame gives back 16 bytes and the reloads rise from 92 to 137, still below `7b38c65`'s 156: the
inlined insert body needs registers the probe loop had freed, but the probe loop keeps its lean
shape. That trade is the 18 per symbol recovered against nothing given back per reference, which is
what the three-cohort per-symbol agreement already said.

Every `call` instruction inside `9bfe19d`'s `run`:

| Address                          | Target                                 | Kind                                                         |
|----------------------------------|----------------------------------------|--------------------------------------------------------------|
| `0x802143`                       | `admit::bind_list`                     | hot                                                          |
| `0x80249a`                       | `admit::qualified`                     | hot in principle, never executed on any bench cohort          |
| `0x802814`, `0x802cf2`           | `admit::is_builtin`                    | hot, first-sight path                                        |
| `0x80298b`, `0x802e78`           | `RawVec::grow_one` (`symbols`)         | cold, behind a length test that excludes it; back in `run` with the inlined `insert` |
| `0x8029e9`, `0x802ee4`           | `RawVec::grow_one` (`owners`)          | cold, likewise                                               |
| `0x802f80`, `0x802fc9`           | `admit::shadowed`                      | on an edge sunk out of the probe loop; never taken on any bench cohort |
| `0x803157`                       | `core::slice::index::slice_index_fail` | cold panic path                                              |
| twenty-eight sites               | `core::panicking::panic_bounds_check`  | cold panic paths                                             |

`admit::insert` is gone from the call list, and the two `grow_one` pairs returned to `run` with the
body they belong to. **No libc symbol is called from `run`, `declare` or `shadowed`** — no `memcmp`,
`memcpy`, `memset` or `bcmp` — so the per-byte compares are still explicit loops.

## Kernel-scoped profile at `7b38c65`

`perf record -q -e instructions:u -F 10000`, ASCII cohort, byte scanner, 512 definitions, 60,000
iterations of the admit stage, pinned to CPU 7 (the A/B held CPU 5), one-minute load average 2.44
at launch. 119,000 samples, no lost samples, 224,169,737,557 instructions.
`~/.cache/ergodis/perf-c1170/admit-7b38c65.data`. Every symbol above 0.1 per cent:

| Share   | Symbol                                            | control's share |
|--------:|---------------------------------------------------|----------------:|
| 34.18 % | `rel_frontend::parser::Parser::expression`        |         35.79 % |
| 24.91 % | `rel_frontend::Workspace::scan_variant`           |         26.30 % |
| 21.29 % | `rel_frontend::admit::run`                        |         20.18 % |
|  4.73 % | `rel_frontend::admit::declare`                    |          4.59 % |
|  4.13 % | `rel_frontend::admit::bind_list`                  |          3.07 % |
|  3.38 % | `rel_frontend::admit::admit`                      |   2.91 % as `Workspace::admit` |
|  2.99 % | `rel_frontend::lexer::keyword`                    |          2.84 % |
|  1.80 % | `rel_frontend::parser::Parser::item`              |          2.03 % |
|  1.46 % | `rel_frontend::parser::Parser::node`              |          0.74 % |
|  0.48 % | `core::str::converts::from_utf8`                  |          0.51 % |
|  0.30 % | `rel_frontend::admit::is_builtin`                 |          0.57 % |
|  0.24 % | `rel_frontend::parser::parse`                     |          0.39 % |

`admit::qualified` does not appear in the profile at any share: the ASCII corpus writes its
qualified forms as symbol-keyed tuples rather than module member spines, so the member path never
runs. Member lookup is therefore exercised only by the seven parity cases and one unit test, and
its cost is unmeasured.

Below the 0.1 per cent line the profile shows `__memset_avx512_unaligned_erms` at 0.07 per cent,
which is the per-admission index clear that both arms call, and trace entries at 0.00 per cent for
`_int_malloc`, `cfree`, `__memcmp_evex_movbe`, `core::fmt::write` and the integer `Display`
formatters, which are process start-up, cohort generation and the JSON record rather than the
measured loop. No allocator, panic or formatting symbol appears anywhere above that floor. The
shares carry the same skid this host's sampling always carries — no precise sampling is available
under `perf_event_paranoid = 2` — so they are read only for which symbols run, not for what they
cost.

## Kernel-scoped profile at `4b02031`

Same recipe, one-minute load average 2.21 at launch, 120,000 samples, no lost samples,
226,955,321,918 instructions. `~/.cache/ergodis/perf-c1170/admit-4b02031.data`. Every symbol above
0.1 per cent, with the two earlier binaries' shares alongside:

| `4b02031` | Symbol                                            | `7b38c65` | `93bb343` |
|----------:|---------------------------------------------------|----------:|----------:|
|   34.82 % | `rel_frontend::parser::Parser::expression`        |   34.18 % |   35.79 % |
|   27.64 % | `rel_frontend::Workspace::scan_variant`           |   24.91 % |   26.30 % |
|   14.54 % | `rel_frontend::admit::run`                        |   21.29 % |   20.18 % |
|    8.51 % | `rel_frontend::admit::insert`                     |         — |         — |
|    3.30 % | `rel_frontend::lexer::keyword`                    |    2.99 % |    2.84 % |
|    2.72 % | `rel_frontend::admit::declare`                    |    4.73 % |    4.59 % |
|    2.32 % | `rel_frontend::admit::admit`                      |    3.38 % |    2.91 % as `Workspace::admit` |
|    1.90 % | `rel_frontend::parser::Parser::item`              |    1.80 % |    2.03 % |
|    1.89 % | `rel_frontend::admit::bind_list`                  |    4.13 % |    3.07 % |
|    1.09 % | `rel_frontend::parser::Parser::node`              |    1.46 % |    0.74 % |
|    0.52 % | `core::str::converts::from_utf8`                  |    0.48 % |    0.51 % |
|    0.36 % | `rel_frontend::admit::is_builtin`                 |    0.30 % |    0.57 % |
|    0.29 % | `rel_frontend::parser::parse`                     |    0.24 % |    0.39 % |

`admit::insert` enters the profile at 8.51 per cent, a symbol that existed in neither earlier
binary, and `run`, `declare` and `bind_list` all fall as the work it used to hold inline moves into
it. **`admit::shadowed` does not appear at any share**, which the census predicts: every declared
spelling in the ASCII corpus carries the template's index, so `inner{i}` and `pair{i}` inside
`module scope{i}` never repeat a top-level spelling, no `SHADOWED` bit is ever set, and the
level-aware scan never runs. The same holds for Unicode, and comment-string declares no module at
all. The ASCII measurement therefore prices the flag test and the insert-time walk, not the scan
they guard.

Below the 0.1 per cent line the profile shows `__memset_avx512_unaligned_erms` at 0.06 per cent —
the per-admission index clear, present on every arm — and nothing else above 0.02 per cent. No
`memcmp`, `memcpy`, allocator, panic or formatting symbol appears.

`admit::bind_list` is byte-for-byte identical in all three binaries and its share reads 3.07, 4.13
and 1.89 per cent across them. That settles the open question the `7b38c65` profile raised: the
movement is attribution skid, not a call-count change.

## Kernel-scoped profile at `9bfe19d`

Same recipe, one-minute load average 1.90 at launch, 120,000 samples, no lost samples,
225,284,569,830 instructions. `~/.cache/ergodis/perf-c1170/admit-9bfe19d.data`. Every symbol above
0.1 per cent, with all three earlier binaries alongside:

| `9bfe19d` | Symbol                                            | `4b02031` | `7b38c65` | `93bb343` |
|----------:|---------------------------------------------------|----------:|----------:|----------:|
|   34.37 % | `rel_frontend::parser::Parser::expression`        |   34.82 % |   34.18 % |   35.79 % |
|   25.13 % | `rel_frontend::Workspace::scan_variant`           |   27.64 % |   24.91 % |   26.30 % |
|   19.46 % | `rel_frontend::admit::run`                        |   14.54 % |   21.29 % |   20.18 % |
|    5.51 % | `rel_frontend::admit::bind_list`                  |    1.89 % |    4.13 % |    3.07 % |
|    5.51 % | `rel_frontend::admit::declare`                    |    2.72 % |    4.73 % |    4.59 % |
|    3.01 % | `rel_frontend::admit::admit`                      |    2.32 % |    3.38 % |    2.91 % as `Workspace::admit` |
|    2.77 % | `rel_frontend::lexer::keyword`                    |    3.30 % |    2.99 % |    2.84 % |
|    1.62 % | `rel_frontend::parser::Parser::node`              |    1.09 % |    1.46 % |    0.74 % |
|    1.42 % | `rel_frontend::parser::Parser::item`              |    1.90 % |    1.80 % |    2.03 % |
|    0.50 % | `rel_frontend::admit::is_builtin`                 |    0.36 % |    0.30 % |    0.57 % |
|    0.46 % | `core::str::converts::from_utf8`                  |    0.52 % |    0.48 % |    0.51 % |
|    0.13 % | `rel_frontend::parser::parse`                     |    0.29 % |    0.24 % |    0.39 % |

`admit::insert` is gone from the profile, and `run` and `declare` — its two hot callers — rise by
about the amount it held. `admit::shadowed` still does not appear at any share, for the same census
reason as before: no ASCII spelling is declared at two owner levels, so the `SHADOWED` bit is never
set and the scan never runs. Below the 0.1 per cent line, `__memset_avx512_unaligned_erms` at 0.06
per cent is the per-admission index clear, and nothing else exceeds 0.02 per cent; no `memcmp`,
`memcpy`, allocator, panic or formatting symbol appears.

`admit::bind_list` now reads 5.51 per cent, a fourth value for one function that is byte-for-byte
identical in all four binaries (3.07, 4.13, 1.89, 5.51). That is skid over a factor of three and is
the clearest statement this report can make that these shares are read for which symbols run and
never for what they cost.

## Parity

`python3 analysis/rel-frontend/portability.py --output analysis/rel-frontend/portability-v1.json`
under the pinned toolchain, with the native and WASM outputs byte-equal as the script asserts:
**166 cases, 356,228 canonical bytes, canonical SHA-256
`f3d837520b04cf5d829ecad53dc34ed0a7332b4c18ca77415244d17fa0c7c814`**, against 159 cases, 345,993
bytes and `5a350e1f524b26da61186320414785045d9f39a71c4b34b40f9bd78d3516cbfa` before the change.

The hash change is declared: the case list gains seven module cases (bare-name shadowing across a
module boundary, an arity split between a top-level clause and a module clause, nested module
parameters, an unknown member, an instantiated member, a member arity mismatch, and a member spine
that continues into symbol-keyed access), and admission summaries for sources with module
parameters now count those binders. The receipt's summary fields moved as follows:

| Field                         | before | after |
|-------------------------------|-------:|------:|
| `cases`                       |    159 |   166 |
| `canonical_bytes`             | 345,993 | 356,228 |
| `admitted_cases`              |     27 |    31 |
| `semantically_rejected_cases` |      4 |     7 |
| `success_cases`               |     31 |    38 |
| `failure_cases`               |    128 |   128 |
| `admission_not_reached_cases` |    128 |   128 |
| `multi_failure_cases`         |     33 |    33 |
| `decoder_negative_controls`   |      4 |     4 |

Four of the seven new cases admit and three reject semantically, which is the split the case list
was written for: the unknown member, the member arity mismatch and the arity split each reject. No
previously admitted case became a rejection and no previously rejected case became an admission —
`failure_cases`, `admission_not_reached_cases`, `multi_failure_cases` and the two "largest" record
sizes are all unchanged. The remaining receipt movement is the two rebuilt library hashes and the
source hashes of `tests/rel_frontend.rs`, `tests/rel_frontend_portability.rs`,
`src/rel_frontend/mod.rs` and `src/rel_frontend/diagnostic.rs`.

Replaying the same command at `4b02031` reproduces **166 cases, 356,228 canonical bytes, native and
WASM byte-equal, canonical SHA-256 `f3d837520b04cf5d829ecad53dc34ed0a7332b4c18ca77415244d17fa0c7c814`
— identical**, and every `record_summary` field is unchanged (31 admitted, 7 semantically rejected,
128 admission-not-reached, 38 success, 128 failure, 33 multi-failure, 4 decoder negative controls).
Against the `7b38c65` receipt the only movements are the two rebuilt library hashes and the source
hash of `src/rel_frontend/mod.rs`, whose doc comment for the `scope` pool changed. That is the check
the rework's semantics-preserving claim needed, and it passes.

Replaying again at `9bfe19d` reproduces the same hash a third time, with the same 166 cases, the
same 356,228 canonical bytes and the same `record_summary` in every field. Because `9bfe19d` touches
only `src/rel_frontend/admit.rs`, **not one source hash in the receipt moved** — the entire diff
between that replay and the `4b02031` one is the two rebuilt library hashes.

That is the sharp form of the gap these replays exposed: the receipt's `source_sha256` map does not
list `src/rel_frontend/admit.rs`. `4b02031` rewrites the probe loop, adds two functions and changes
an owner sentinel, and the only source hash that moves is `mod.rs`'s, for a doc comment; `9bfe19d`
changes the inlining of a hot function and moves nothing at all. A future change confined to the
admission stage could move the canonical hash with no source hash to point at. It is recorded in
the mystery ledger below.

## Gates

| Gate                          | Command                                                                                                     | Outcome |
|-------------------------------|-------------------------------------------------------------------------------------------------------------|---------|
| Frontend tests                | `cargo test --release -p ergodis-private --test rel_frontend --test rel_frontend_portability -j 4`            | 25 + 1 passed, 0 failed, at `7b38c65`, `4b02031` and `9bfe19d`, each before retain, as run by the lead; not rerun here |
| Zero allocation               | inside those runs                                                                                            | unchanged: zero allocations over ten rounds, with the new retained-byte total |
| Clippy, library and both test targets | `cargo clippy --release -p ergodis-private --lib --test rel_frontend --test rel_frontend_portability -j 4 -- -D warnings` | no diagnostics at any of the three revisions, as run by the lead |
| Clippy, tools binary          | `cargo clippy --release -p ergodis-tools --bins -j 4 -- -D warnings`                                         | no diagnostics at any of the three revisions, as run by the lead |
| Formatting                    | `rustfmt --check --edition 2021`                                                                             | clean at all three revisions, as run by the lead |
| Native/WASM parity replay     | `python3 analysis/rel-frontend/portability.py --output analysis/rel-frontend/portability-v1.json`             | 166 cases, native and WASM byte-equal; hash changed as declared at `7b38c65` and reproduced exactly at `4b02031` and again at `9bfe19d` |
| Driver output gate            | armed on every operation of all five A/Bs                                                                     | equal tokens, nodes, failure, admission summary and representation fingerprint on all 27 operations of each; `--representation-change` not needed and not passed |
| Event set                     | `instructions,cycles,branches,branch-misses,page-faults,minor-faults`                                        | 100.00 per cent enabled on all six, `perf stat -x,` on each candidate's ASCII admit stage |
| Retained bytes                | from the receipt records                                                                                      | 6,539,264 at `93bb343`, 6,606,852 at all three candidates, +67,588 once; not part of the gate's equality set |

## Where the Fermis landed

### The module feature's Fermi, which missed by three times

Outside its band, by three times. Predicted +20,000 to +30,000 and 1.018 to 1.026; measured +92,311
and 1.081272 [1.081268, 1.081276]. Of the four terms the Fermi added, one does not run at all and
the other three were each priced against the wrong census or the wrong path count.

1. **The module-parameter walk (predicted 5,800) never executes.** The ASCII corpus writes
   `module scope{i}` with no parameter list, so `enter_scope`'s inner loop meets the module's name
   atom and breaks. Removing that term makes the pre-change prediction 16,700 and the miss 5.5
   times rather than 3.1.
2. **The owner load and chain scan were priced at 8 instructions on 695 probe hits; they cost
   about 15 on a top-level body and 19 inside a module, and they are not the dominant term.** The
   listing gives 5 of setup, 4 per chain entry and 6 for the position comparison.
3. **The term the Fermi did not have at all is the probe prologue.** Keeping `best`, `admitted`
   and `matched` live across a loop that can no longer return from inside costs eleven extra
   instructions before the loop starts, on every reference that reaches the probe — not on the 695
   that hit. That, with the six stores of the matched symbol's fields and the post-loop re-index
   that replaced the in-loop return, is where roughly eighty thousand of the ninety-two thousand
   instructions are.
4. **The chain build per body was priced at 15 and measures 21.2.** That term was close.

The correction the sizing method needs: when a change removes a search loop's ability to return
from inside itself, price the prologue and the loop-carried state against the count of *searches*,
not against the count of *matches*. The branch that visibly changed is the match branch; the
compiler charges for it on the entry path.

Two terms outside admission were also mispriced. `prepare` added 1,242 instructions against a
predicted 600, because the change adds two pools and the Fermi priced one — `owners` at 64 KiB and
`scope` at 2,052 bytes each cost a `try_reserve_exact`, a `fill` in the touch path and a capacity
term in the retained-byte sum, and the small pool costs as much per call as the large one.
`prepare-touch`'s page count landed: 17 measured against 16 predicted, which is 67,588 bytes over
4 KiB pages. Retained bytes landed exactly: 65,536 + 4 × 513, with the bench limits' depth of 512
confirmed from the receipt.

### The rework's Fermi, which failed the other way

Predicted 0.960 to 0.975 of `7b38c65` on ASCII admission; measured 1.037796 [1.037792, 1.037801].
The Fermi was right about the loop and blind to everything outside it. Its four terms were about the
probe, the early return, `enter_scope` and the insert-time walk; the cohort solve says the loop
recovered 10.1 instructions per reference, or 35,600 on ASCII, which is inside the spirit of what
was predicted. What it did not price is that growing `insert` — a `source` parameter, a filter
compare, an owner compare and a `same()` call per slot walked — pushed it past the inliner's
threshold. It had been inlined at all three call sites in both earlier binaries; at `4b02031` it is
an out-of-line symbol called once per symbol inserted, at 53.1 instructions per call, 82,000 on
ASCII.

The insert-time walk itself was priced at "about 4 per slot walked, a few thousand" and that part is
not refutable from these cohorts, because the index is sized from `Limits::symbols` (8,192 on the
bench, so 16,384 slots) rather than from the symbols actually present; at a load factor below 0.1
the walk is barely more than one slot and the walk's own cost is small. The whole 53.1 is call
shape, not walking.

### The `insert` inlining's Fermi, the one that held

Predicted 0.965 to 0.980 of `4b02031` on ASCII admission and 1.085 to 1.10 composed; measured
0.978153 [0.978148, 0.978159] and 1.097623 [1.097620, 1.097626], both inside the band at the end
nearer no change. It predicted 15 to 25 instructions recovered per insert and the measurement is
18.0 on ASCII, 18.1 on Unicode and 18.2 on comment-string.

It held because it was the first of the three written after someone had looked at a symbol table.
The quantity it predicted — the call shape of a named function that `nm` showed appearing — is
exactly the quantity that is legible there, and the two counts it needed, 640 declares and 905 first
sights, were already in the admission census.

What it still under-priced is the body: it allowed "about 38 plus the walk" for the inlined insert,
where the measurement says the walk alone is 35.1 per symbol and is now the largest single term in
the feature's cost. That is not a failure of this Fermi, which was about the call and not the walk,
but it is where the remaining 54,200 instructions on ASCII sit.

### The pattern across the three

One thing, not three: each prediction modelled the source change and not the inlining decision it
moved. At `7b38c65` a loop lost its in-loop early return and gained a prologue every reference pays.
At `4b02031` a function crossed the inliner's size threshold and gained a call every symbol pays. At
`9bfe19d` the prediction was about that boundary and it held. None of the first two effects is
visible in the diff and both are visible in `nm --size-sort -S` on the two binaries; diffing the
symbol set before the first measurement would have predicted both, and it is now the first thing to
do on any frontend A/B in this lane.

## Replay

`$C0` is `ergodis-tools` retained at `93bb343`, `$C1` at `7b38c65`, `$C2` at `4b02031` and `$C3` at
`9bfe19d`, each by
`../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools` with that revision checked out;
the script re-executes itself under `nix develop ~/src/ergodis`. From `~/src/ergodis-private`, with
every command prefixed `nix develop ~/src/ergodis -c`:

```sh
E=instructions,cycles,branches,branch-misses,page-faults,minor-faults
P=~/.cache/ergodis/perf-c1170

# non-multiplexing check, run once per candidate
for B in "$C1" "$C2" "$C3"; do
  perf stat -x, -e $E -- taskset -c 5 "$B" rel-frontend-bench \
      --cohort ascii --stage admit --variant byte --definitions 512 --repeat 2000
done

# the five A/Bs
python3 analysis/rel-frontend/bench.py --binary "$C1" --control "$C0" \
    --rounds 7 --cpu 5 --stages prepare,prepare-touch,parse,admit --events $E \
    --out analysis/rel-frontend/performance-v1-admit-modules-7b38c65.json
python3 analysis/rel-frontend/bench.py --binary "$C2" --control "$C1" \
    --rounds 7 --cpu 5 --stages prepare,prepare-touch,parse,admit --events $E \
    --out analysis/rel-frontend/performance-v1-admit-lean-loop-4b02031.json
python3 analysis/rel-frontend/bench.py --binary "$C2" --control "$C0" \
    --rounds 7 --cpu 5 --stages prepare,prepare-touch,parse,admit --events $E \
    --out analysis/rel-frontend/performance-v1-admit-modules-composed-4b02031.json
python3 analysis/rel-frontend/bench.py --binary "$C3" --control "$C2" \
    --rounds 7 --cpu 5 --stages prepare,prepare-touch,parse,admit --events $E \
    --out analysis/rel-frontend/performance-v1-admit-insert-inline-9bfe19d.json
python3 analysis/rel-frontend/bench.py --binary "$C3" --control "$C0" \
    --rounds 7 --cpu 5 --stages prepare,prepare-touch,parse,admit --events $E \
    --out analysis/rel-frontend/performance-v1-admit-modules-composed-9bfe19d.json

# parity, run once per candidate revision checked out
python3 analysis/rel-frontend/portability.py \
    --output analysis/rel-frontend/portability-v1.json

# kernel-scoped profile of each candidate
for R in 7b38c65 4b02031 9bfe19d; do
  perf record -q -e instructions:u -F 10000 -o $P/admit-$R.data \
      -- taskset -c 7 ~/.cache/ergodis/bin/ergodis-tools-$R rel-frontend-bench \
      --cohort ascii --stage admit --variant byte --definitions 512 --repeat 60000
  perf report --stdio --sort sym -i $P/admit-$R.data
done
```

The disassembly, ambient rather than under the flake:

```sh
for R in 7b38c65 4b02031 9bfe19d; do
  objdump -d --no-show-raw-insn -M intel ~/.cache/ergodis/bin/ergodis-tools-$R > $P/all-$R.txt
  nm -C --size-sort -S ~/.cache/ergodis/bin/ergodis-tools-$R | grep 'rel_frontend::admit::'
done
# admit::run, admit::qualified, admit::admit, admit::declare and admit::is_builtin cut out of
# all-7b38c65.txt; those plus admit::insert and admit::shadowed out of all-4b02031.txt;
# admit::run, admit::shadowed and admit::declare out of all-9bfe19d.txt;
# admit::run, admit::declare and Workspace::admit out of all-93bb343.txt
```

Console logs: `$P/modules-7b38c65.log`, `$P/lean-loop-4b02031.log`,
`$P/modules-composed-4b02031.log`, `$P/insert-inline-9bfe19d.log`,
`$P/modules-composed-9bfe19d.log`, `$P/parity-{7b38c65,4b02031,9bfe19d}.log`,
`$P/record-{7b38c65,4b02031,9bfe19d}.log`.

## Foreign tree

The repository carries the same uncommitted foreign files the previous C1170 reports name: the
campaign-console mockups and interface-review material under `analysis/`,
`packages/execution-provider/src/lib.rs`, `packages/hadamard-provider/tests/contracts.rs`,
`packages/parameterization-provider/tests/contracts.rs`, `src/hadamard_execution.rs`,
`src/partitioned_additive_join.rs`, `tests/partitioned_join_profile.rs` and
`tests/quadratic_residual_profile.rs`. Their diff hashed
`a954fbdceb3a9ea474c3406ec70e7419a7fd02b2026f400f21197fb7b6a2df28` at the start and again at the
end of this task, the hash the seven previous reports recorded, and **still equals it**. None was
touched, staged or reverted. The retained candidate carries the manifest's `dirty` flag for that
reason; both arms were built against the same foreign diff, which cancels in every ratio and makes
neither arm reproducible from its commit alone.

## Mystery ledger

1. **Settled: what module scoping costs the admission stage as it now stands.** 31.50 instructions
   per reference on ASCII, 110,883 of 1,135,831, ratio 1.097623 [1.097620, 1.097626] at `9bfe19d`
   against `93bb343`. The three steps sum to that figure to within three instructions, which is the
   consistency check the four-way design buys.
2. **Settled: at `7b38c65` the cost was on the probe entry, not on the matched branch.** The probe
   prologue in `run` grew from ten instructions to twenty-one because `best`, `admitted` and
   `matched` must live across a loop that can no longer return from inside, and the matched symbol's
   fields were stored to the frame and re-read after the loop. 22.8 per reference and 21.2 per body
   by the cohort solve.
3. **Settled: the rework made the loop leaner and the stage worse.** 10.1 instructions per reference
   recovered, 53.1 per symbol lost, solved from the ASCII and comment-string censuses and confirmed
   by the listing — `run`'s hot reloads fall from 156 to 92, below the pre-module 112, while
   `admit::insert` becomes an out-of-line symbol called 1,545 times per ASCII admission and takes
   8.51 per cent of the candidate's profile. Neither Fermi looked at an inlining boundary; both
   boundaries were visible in `nm --size-sort -S` before any measurement.
4. **Settled: inlining `insert` recovers the call shape and only the call shape.** `#[inline(always)]`
   at `9bfe19d` removes 18.02 instructions per symbol on ASCII, 18.05 on Unicode and 18.23 on
   comment-string — three cohorts whose reference-to-symbol ratios run from 0.86 to 2.28, so the
   quantity is measured per symbol rather than fitted. ASCII admission 0.978153 [0.978148,
   0.978159], 27,845 removed, inside the Fermi's 0.965 to 0.980. `run` grows 1,066 bytes of text,
   `declare` 794 and `shadowed` 701; the frame gives back 16 bytes and hot reloads rise from 92 to
   137, still below `7b38c65`'s 156.
5. **Open, and now the largest term: the shadow-flagging walk inside `insert` costs 35.1
   instructions per symbol, 54,200 on ASCII — half the feature's whole cost.** Every Fermi priced it
   at a few thousand. It runs on every insert and its work is a filter compare, an owner compare and
   a possible `same()` per occupied slot walked, but the index is sized from `Limits::symbols`
   (8,192 on the bench, so 16,384 slots) and holds 1,545 symbols, a load factor under 0.1 where the
   walk is barely more than one slot. So the 35 is nearly all fixed per-insert setup, not walking,
   and that is where a repair should aim: hoist the pool pointers and the span the walk needs, or
   flag shadowing from a cheaper signal than a spelling re-compare. The evidence gap is a path count
   of the inlined walk in `run`, which this task did not do; the upper bound if it went away
   entirely is 54,200 on ASCII, 4.8 per cent of the admission stage.
6. **Recorded: the control for the next frontend A/B is `ergodis-tools-9bfe19d` if the chain is
   kept.** It is retained, hashed and the last of the three.
7. **Open: `admit::shadowed`, `admit::qualified` and `member` are all unpriced.** None of the three
   executes on any bench cohort: `shadowed` because no ASCII, Unicode or comment-string spelling is
   declared at two owner levels, `qualified` and `member` because no cohort writes a module member
   spine. That is 1,292 + 3,777 bytes of text and the entire level-aware resolution path measured
   only by the parity cases and unit tests. The evidence gap is a corpus variant with shadowed
   spellings and member spines; it would also price the quadratic spine descent that `qualified`'s
   own doc comment warns about. Until it exists, every ratio in this report prices the guards, not
   what they guard.
8. **Open: `prepare` costs twice what a single pool should.** 1,242 instructions for two
   reservations, 621 each, where the scopes-pool report's corrected cost for one 64 KiB reservation
   was about 600. The small 2,052-byte `scope` pool therefore costs the same as the 64 KiB
   `owners` pool, which says the cost is per pool and not per byte — as expected for a
   `try_reserve_exact` plus a `fill` plus a capacity term, but it has not been confirmed from the
   listing. If the pool count keeps growing this term grows linearly with it.
9. **Settled: `admit::bind_list`'s profile share is skid.** Its symbol is byte-for-byte identical in
   all four binaries and the ASCII corpus gives `enter_scope` no parameters to bind, yet its share
   reads 3.07, 4.13, 1.89 and 5.51 per cent across `93bb343`, `7b38c65`, `4b02031` and `9bfe19d`.
   Four readings of one unchanged function, spanning a factor of three, settle what two could not.
   No instruction claim in this report rests on any profile share.
10. **Open, minor: peak RSS moves at 4 KiB granularity in directions the pools do not explain.** It
    rises 88 to 92 KiB on the admit operations at `7b38c65`, more than the 66 KiB the pools grew,
    falls 4 KiB on every parse operation there, and creeps up about 20 KiB again at each of
    `4b02031` and `9bfe19d`, neither of which allocates anything new. Consistent across rounds and
    cohorts, so not noise, and it tracks text size rather than pool size. Mapping layout, recorded
    rather than explained.
11. **Open, minor: the parity receipt's `source_sha256` map omits `src/rel_frontend/admit.rs`.** The
    map lists `mod.rs`, `lexer.rs`, `parser.rs`, `diagnostic.rs`, both test files and the two
    portability drivers. `9bfe19d` is the sharp case: it changes the inlining of a hot function in
    the admission stage and moves no source hash in the receipt at all, only the two rebuilt library
    hashes. A future change confined to that file could move the canonical hash with no source hash
    to point at. One line in `portability.py` closes it.
12. **Not a mystery: the cold calls.** At `7b38c65`, four `grow_one` sites in `run` against two in
    the control, the two new ones the `owners` pool's push slow path behind the same length test
    that already excludes the `symbols` push. At `4b02031` they leave `run` with `insert` and
    `admit::admit` carries four; at `9bfe19d` they come back to `run` with the inlined body. Between
    eighteen and twenty-nine `panic_bounds_check` and `slice_index_fail` sites sit on `run`'s cold
    tail in each binary, none sampled. The per-byte bounds checks that produce them were candidates
    2 and 3 on the lane's remaining list and are untouched here.
13. **Settled: no libc call entered the stage in any of the four binaries.** No `memcmp`, `memcpy`,
    `memset` or `bcmp` appears in `run`, `qualified`, `insert`, `shadowed` or `declare`. The three
    `memset` calls in `admit::admit` are the per-admission index clear, present identically in the
    control's `Workspace::admit`, and the profile puts that at 0.06 to 0.07 per cent. The per-byte
    compares are still explicit loops.

## Remaining next steps

Per Tavis's call at the inline-reference close, the lane continues with end-to-end features; the
one performance item this task opens is recorded, not queued: the shadow-flagging walk inside
`insert` (35 per symbol, 54,200 on ASCII, half the feature's cost) is fixed per-insert setup at a
load factor under 0.1 and is the first candidate whenever frontend micro-optimization resumes,
against `ergodis-tools-9bfe19d`. Next feature: the remaining syntax gaps by manifest family (caret
entity references, interpolation, Unicode boundary conformance), then lowering of admitted
programs into Ergodis rules end to end.

## What this task left under `~/.cache/ergodis/`

For the user's cache decision. Nothing was deleted, nothing large went to `/tmp`, and no
`~/.cache` path is cited as evidence.

| File                                  | Apparent size | Measured sha256 (first 16) | What it is |
|---------------------------------------|--------------:|----------------------------|------------|
| `bin/ergodis-tools-9bfe19d`           |         15 MB | `c6376274ac2892c1…`        | the third candidate, rustc 1.95.0; **the control for the next frontend A/B if the chain is kept** |
| `bin/ergodis-tools-4b02031`           |         15 MB | `9d1d0a4544461cc2…`        | the second candidate, and the control for the insert-inlining A/B |
| `bin/ergodis-tools-7b38c65`           |         15 MB | `350fce0c233ef6aa…`        | the first candidate, and the control for the lean-loop A/B |
| `bin/ergodis-tools-93bb343`           |         15 MB | `520e6057add1dbd8…`        | the pre-feature control, retained by the previous task |
| `perf-c1170/admit-9bfe19d.data`       |        4.8 MB | `7b8bff7f4744d370`         | the 60,000-iteration ASCII profile of the third candidate |
| `perf-c1170/admit-4b02031.data`       |        4.9 MB | `d8bfa3dd78a27fe1`         | the same profile of the second candidate |
| `perf-c1170/admit-7b38c65.data`       |        4.8 MB | `c50da7bd7193fb3c`         | the same profile of the first candidate |
| `perf-c1170/all-9bfe19d.txt`          |        121 MB | —                          | the third candidate's full disassembly; an intermediate, regenerable in one `objdump` |
| `perf-c1170/all-4b02031.txt`          |        121 MB | —                          | the second candidate's full disassembly; likewise |
| `perf-c1170/all-7b38c65.txt`          |        121 MB | —                          | the first candidate's full disassembly; likewise |
| `perf-c1170/run-9bfe19d.s`            |         57 KB | `cd076c629d47d49b`         | `admit::run` at `9bfe19d`, the source of its call list |
| `perf-c1170/shadowed-9bfe19d.s`       |         23 KB | `556087cb97773637`         | `admit::shadowed` at `9bfe19d` |
| `perf-c1170/declare-9bfe19d.s`        |         18 KB | —                          | `admit::declare` at `9bfe19d`, which absorbed one copy of `insert` |
| `perf-c1170/run-4b02031.s`            |         44 KB | `2a896ca37e9f849c`         | `admit::run` at `4b02031`, the source of its path counts |
| `perf-c1170/insert-4b02031.s`         |        9.5 KB | `df4a7cdca76c8731`         | `admit::insert`, the new out-of-line symbol this task's finding rests on |
| `perf-c1170/shadowed-4b02031.s`       |         15 KB | `c2617195509e8959`         | `admit::shadowed`, the level-aware scan that never executes on a bench cohort |
| `perf-c1170/qualified-4b02031.s`      |         43 KB | —                          | `admit::qualified` at `4b02031` |
| `perf-c1170/admitfn-4b02031.s`        |         25 KB | —                          | `admit::admit` at `4b02031` |
| `perf-c1170/declare-4b02031.s`        |        9.0 KB | —                          | `admit::declare` at `4b02031` |
| `perf-c1170/run-7b38c65.s`            |         53 KB | `994707c664095fd0`         | `admit::run` at `7b38c65` |
| `perf-c1170/qualified-7b38c65.s`      |         43 KB | `344f9182d50afbf3`         | `admit::qualified` at `7b38c65` |
| `perf-c1170/admitfn-7b38c65.s`        |         28 KB | `2d730390745db5f8`         | `admit::admit` at `7b38c65`, which holds the inlined `enter_scope` |
| `perf-c1170/declare-7b38c65.s`        |         12 KB | —                          | `admit::declare` at `7b38c65` |
| `perf-c1170/is_builtin-7b38c65.s`     |        6.5 KB | —                          | `admit::is_builtin` at `7b38c65` |
| `perf-c1170/run-93bb343.s`            |         42 KB | —                          | `admit::run` at `93bb343`, regenerated and identical to the previous task's |
| `perf-c1170/declare-93bb343.s`        |         11 KB | —                          | `admit::declare` at `93bb343` |
| `perf-c1170/workspace-admit-93bb343.s`|         19 KB | —                          | `Workspace::admit` at `93bb343`, which holds the body loop that later moved out of line |
| `perf-c1170/modules-7b38c65.log`      |         small | `765f671eb6d0e680`         | the first A/B's console log |
| `perf-c1170/lean-loop-4b02031.log`, `modules-composed-4b02031.log`, `insert-inline-9bfe19d.log`, `modules-composed-9bfe19d.log` | small | — | the other four A/Bs' console logs |
| `perf-c1170/{parity,record}-{7b38c65,4b02031,9bfe19d}.log` | small | — | the parity and profile console logs |

Receipts, which live in the repository rather than the cache and are the cited evidence:
`analysis/rel-frontend/performance-v1-admit-modules-7b38c65.json`,
`performance-v1-admit-lean-loop-4b02031.json`,
`performance-v1-admit-modules-composed-4b02031.json`,
`performance-v1-admit-insert-inline-9bfe19d.json` and
`performance-v1-admit-modules-composed-9bfe19d.json`.

The four full disassembly dumps are the only large items beyond the three profiles and are pure
intermediates. The directory now holds 951 MB of apparent size and reports 162 MB on disk, so the
filesystem is compressing them. `../ergodis-dev/scripts/cache-gc.sh` has not been run, since
deletion is the user's call.
