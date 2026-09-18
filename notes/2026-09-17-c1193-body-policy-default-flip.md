# C1193 — the Rel lowering's default body policy flipped to `Nary`

**Lane**: `ergodis`

Tavis's decision, 2026-09-17, on C1193's measurements: the lowering's default
body policy is now `BodyPolicy::Nary`. `BodyPolicy::Binarize` stays in the tree
as the measured control for the same source. This note is the receipt for the
mechanical change and the two digests it moves; the measurements that motivate
it are in `notes/2026-09-17-c1193-nary-bodies-report.md`.

Commits: `ergodis-private` `3c8499d` (from `26d2468`), core `ergodis` untouched
at `09a5c2b`.

## What changed

| Path (in `~/src/ergodis-private`) | Change |
| --- | --- |
| `src/rel_frontend/lower.rs` | `#[default]` moved from `BodyPolicy::Binarize` to `BodyPolicy::Nary`; the enum and both variant doc comments now say `Nary` is the default since 2026-09-17 by Tavis's decision and `Binarize` is the measured control. |
| `tasks/tools/src/rel_lower.rs` | `--body-policy` default value `binarize` → `nary`; help text says the default is `nary` since 2026-09-17 and that a receipt taken before that date replays under `binarize`. |
| `tasks/tools/src/rel_frontend_bench.rs` | The same default and the same help text, so the driver and the operator tool agree. |
| `tests/rel_lowering.rs` | The milestone (a) suite pinned to `BodyPolicy::Binarize`. |
| `analysis/rel-frontend/portability-v1.json` | Regenerated. |

No other file in either repository was touched, and the passes themselves are
unchanged: `plan_bodies` already took the policy as an argument.

## The tests pinned to `Binarize`

All of them are in `tests/rel_lowering.rs`, which is the milestone (a) fixture
suite. Its assertions name auxiliary counts, binarized-rule counts and the
chaining pass's own diagnostics, so under the n-ary default they would stop
exercising the chain rather than fail. Each site is pinned with
`lower_with(..., BodyPolicy::Binarize)` and a comment; no assertion was
rewritten.

1. The `lower` helper and the `lowered` helper it wraps, which every fixture in
   the suite goes through.
2. `decide`, the per-equation driver behind
   `every_figure_three_and_four_equation_has_the_recorded_outcome`. The recorded
   outcome of each of the thirty-five equations is milestone (a)'s coverage, and
   the n-ary policy can only accept more programs than the binarized one, so an
   unpinned run could silently turn a recorded rejection into a lowering.
3. Both `lower` call sites inside `the_lowering_stage_does_not_allocate` — the
   warm-up loop and the measured loop. Its exit paths include the chaining pass
   over a negative literal and over both aggregate arms, which the n-ary default
   would stop driving.

One call site in that file is deliberately left on the default: the
empty-program rejection in
`a_source_that_declares_no_relation_is_rejected_by_the_lowering`, which decides
before body planning and is policy-independent.

Nothing else needed pinning. `tests/rel_reference_eval.rs` already runs both
policies explicitly where shape matters, and its three default-policy call sites
check that the lowering is a function of its input alone — a property of either
policy. `tests/rel_frontend_portability.rs` compares native against WASM on the
same default and is the manifest's own generator, so the flip moves its digest
rather than its verdict.

## The native/WebAssembly parity manifest

Regenerated with

```
choom -n 1000 -- nix develop ~/src/ergodis --command \
  python3 analysis/rel-frontend/portability.py \
  --output analysis/rel-frontend/portability-v1.json
```

| | cases | canonical bytes | canonical SHA-256 | native/WASM |
| --- | ---: | ---: | --- | --- |
| before (`Binarize` default) | 243 | 530,505 | `349333d4a4cc34a8ef8b64b5f68cdd127b967ff24d538de426eba28793f652ab` | byte-equal |
| after (`Nary` default) | 243 | 529,122 | `5f9600ef35db554dc0360624f87e2b69653193842c959c2f6d0c27daacba0cc4` | byte-equal |

The case count is unchanged at 243 and so is the lowered-case count at 42: the
flip changes the shape of the lowered programs, not which sources lower. The
1,383 canonical bytes the manifest loses are the auxiliary relations and their
rules, and the summed canonical relational-IR bytes fall from 15,621 to 14,238.
The script reports native and WASM exactly equal, which is the property the
manifest exists to assert.

## The `datalog` lowering fingerprint

`cargo run --release -p ergodis-tools -- rel-lower --cohort datalog
--definitions 512 --max-tuples 0`, with no flag and then with the control named.
Both runs verify: `verified`, `ranked_verified`, `checkers_agree` and
`complement_records_verified` are all true under each policy, and both close the
same five relations to the same tuple counts.

| invocation | `body_policy` | relations | auxiliaries | rules | binarized | literals | fingerprint |
| --- | --- | ---: | ---: | ---: | ---: | ---: | --- |
| no flag (the new default) | `nary` | 6 | 0 | 88 | 0 | 256 | `06aa82af43b2b958` |
| `--body-policy binarize` | `binarize` | 14 | 8 | 96 | 8 | 272 | `16adff1ed85f7e04` |

Both rows reproduce the report's table exactly. The n-ary run also derives
131,838 tuples against the control's 135,926 and peaks at 26,808 KiB resident
against 36,204 KiB.

## Gates

| Gate | Result |
| --- | --- |
| `cargo test -p ergodis-private -p ergodis-tools -j 8` | Clean, exit 0: 1,215 passed, 0 failed, across 42 test binaries. |
| `cargo clippy -p ergodis-private -p ergodis-tools --lib --bins --tests --examples -- -D warnings` | Clean, exit 0, no warning emitted. |
| `cargo fmt -p ergodis-private -p ergodis-tools -- --check` | Clean, exit 0. |

Every command ran under `choom -n 1000 -- nix develop ~/src/ergodis --command`.

## What this does to the earlier reports' replay commands

The replay commands in the C1190, C1192, C1198 and C1193 reports that carry no
`--body-policy` flag now measure the `nary` shape; add `--body-policy binarize`
to reproduce the receipts those reports record.
