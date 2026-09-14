# C1182 — demand-driven Datalog evaluation with derivation certificates

**Lane**: `ergodis`
**Date**: 2026-09-13
**Status**: COMPLETE. Successor to C1179 (`2026-09-13-c1179-datalog-closure-ballpark.md`).

## Why

C1179 showed the rules path is capped at domain N≈24 on transitive closure, not by time or
memory but by the grounding budget: every product of every rule is materialized before
evaluation, so work grows as N⁵ for a binary recursive rule. Soufflé runs the same inputs to
N=1024 dense in seconds. No Datalog-scale comparison is possible until derivation work is
proportional to output times degree instead of the full product space.

## What was built

Core `ergodis` `40e78d5` (three commits from `2074025`), private `ergodis-private` `958538d` (six commits from `c02eae8`).

1. **Admission without grounding** — `crates/verify/src/datalog.rs`. The same `Program` wire
   format is admitted structurally: relation names and arities resolved, constants bounded by the
   domain, variables numbered per rule by first occurrence in body order, head variables required
   to be bound. Admitted: the Boolean carrier, positive rules with one or two body atoms,
   constants, equality joins through repeated variables, facts on any relation. Rejected
   explicitly, never silently: any other carrier (`Schema`), bodies longer than two atoms,
   declared symmetries, nullary relations, unbound head variables (`Source`), non-canonical facts
   (`Encoding`), and the size bounds below (`Budget`). Negation, aggregation and stratification
   have no representation in the wire format. The source identity is the one `ground` defines
   (factored into `rule_contract::encode_source` / `identity_of`), so both paths bind certificates
   to the same source.
2. **Evaluator** — `crates/rules/src/demand.rs`, `Demand` / `DemandWorkspace`. Round-based
   semi-naive evaluation: each relation is an append-only row store with a membership bitmap over
   its tuple universe `domain^arity`; each binary body compiles to two join steps,
   `Δa ⋈ (full_b ∪ Δb)` and `full_a ⋈ Δb`, each probing a direct-addressed index on the other
   atom's bound columns (a CSR built at preparation for input relations, a head/next chain for
   relations that grow, filled only at round boundaries so a round never consumes its own output).
   Products are never stored; each new tuple records its rule and its two premise rows. The
   derivation loop performs no allocation, recursion, serialization or shared mutable state;
   every store, bitmap, witness column and index is sized when the workspace is created, and a
   full relation returns `Error::Budget` through the result path. Default capacity per derived
   relation is `min(domain^arity, 2^24)` rows; `workspace_bounded` lowers it. Zero-filled storage
   is committed lazily by the kernel, so resident memory follows the rows derived.
3. **Sparse support certificate** — `crates/verify/src/derivation.rs`,
   `DerivationCertificate` (`finite-boolean-derivation-certificate.v1`): per derived tuple its
   rule index, two premise references (`0` absent, `1..=F` program fact, `F+1+i` derivation `i`)
   and the tuple itself, in derivation order. Rank is list position. The independent checker
   re-admits the source, then makes one pass over the derivations (each premise must be a present
   fact or a strictly earlier derivation; the body unifies; the recomputed head equals the listed
   tuple; the tuple is new) and one closed-world pass (every body match of every rule over the
   final relations has its head present). Soundness from the first pass, local fixedness from the
   second; with well-founded ranks that is the C1173 support argument in list form. It returns the
   relations it establishes, so a consumer can compare them against an external engine without
   trusting the evaluator. The checker uses its own hash sets and hash-map indexes; it shares
   nothing with the evaluator but admission.
4. **Harness** — private `examples/closure_ballpark.rs` now takes `--evaluator grounded|demand`,
   `--program closure|samegen`, `--souffle-csv FILE` (exact tuple-set agreement), `--emit-only`,
   and `--process` (the whole-process boundary: read the fact file, admit, evaluate once, write
   the derived relation as CSV, exit). `analysis/datalog-comparison/compare.py` runs the matched
   comparison: per size, seven interleaved rounds of three whole processes on one pinned core
   under `perf stat` and GNU `time`, start order rotated each round; the Ergodis process, the
   Soufflé compiled binary and the Soufflé interpreter, all single-threaded. Paired per-round
   log-ratios give a geometric-mean ratio with a t-interval.

### Boundaries and constants

| Bound | Value | Where |
|---|---|---|
| Domain | ≤ 65 536 | `datalog::MAX_DOMAIN` |
| Arity | 1..=4 | `datalog::MAX_ARITY` |
| Variables per rule | ≤ 8 | `datalog::MAX_VARIABLES` |
| Body atoms | 1 or 2 | `datalog::MAX_BODY` |
| Tuple universe `domain^arity` | ≤ 2^30 (bitmap 128 MB) | `datalog::MAX_UNIVERSE` |
| Rows per derived relation | ≤ 2^24 | `demand::MAX_ROWS` |
| Index key space `domain^k` | ≤ 2^24 | `demand::MAX_INDEX_KEYS` |

So arity 2 reaches N = 32 768, arity 3 reaches N = 1024, arity 4 reaches N = 181. The
grounded path's `MAX_BYTES` source cap does not apply to the demand path; its identity hashes
the canonical serialization at whatever size (13 MB for the dense N = 1024 closure input).

## Acceptance

| Gate | Result |
|---|---|
| Exact agreement with the grounded evaluator: `closure.json`, `same_generation.json`, the C1179 closure family N = 4..24 sparse and dense, 3000 generated programs (2–3 relations, arity 1–2, ≤ 3 variables, constants, 1–4 rules, 0–8 facts) | pass (`tests/demand.rs`; the proptest regression seed that caught the one bug found in development is committed) |
| Derivation certificate verified independently on every run in the tests and the harness | pass (`verified_agrees` on every measured case) |
| Negative controls: schema/identity/fact-count binding, list coverage, rule out of range, every premise reference moved, every premise pointing at itself (rank), every tuple value flipped, a duplicate derivation, an absent-fact premise, a dropped derivation | each rejected (`derivation_certificate_rejects_every_mutation_class`) |
| Zero allocations in the derivation loop | 100 repeated evaluations of `same_generation.json` under the counting allocator: 0 (`tests/allocation.rs`) |
| `cargo fmt --check`, `cargo clippy --all-targets --all-features -- -D warnings` (verify, rules), `cargo test --all-features` (verify, rules), `SHA256SUMS` regenerated | clean, 18 test binaries pass |
| Private harness clippy clean; retained executable built via `ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example --profile release --label nix` from `ergodis-private` at `77aa137` (dirty tree), `rustc 1.95.0` | SHA-256 below |

## Comparison

Host: AMD Ryzen AI 9 HX 370, 24 logical CPUs, one pinned core (`taskset -c 3`), load average
3.8 → 1.2 over the run, other sessions active. Soufflé 2.5 (32-bit word) from the nix store,
compiled binaries built with `nixpkgs#gcc`. Seven interleaved rounds per size with rotated start
order; wall is a monotonic clock around the wrapped process tree (the `perf stat`, `taskset` and
GNU `time` launch overhead of about 10 ms is included equally for every system, which is why
every small-N row sits near 13 ms); instructions and task-clock from `perf stat` (user-space
events); peak RSS from GNU `time`. "Ergodis" is the whole process: read the fact file, admit,
evaluate once, write the derived relation as CSV. "warm eval" is the median of 11 in-process
evaluations into a preallocated workspace, excluded from the ratios. Ratios are geometric means
of paired per-round ratios with 95 % t-intervals. The final run is run 2 (harness
`nix-77aa137`); run 1 (`nix-a774bda`, same evaluator, `format!`-based CSV writer) is retained in
`results-2026-09-13.json` and differs only in the write phase.

| program | density | N | facts | output | Ergodis s | compiled s | interp s | wall ratio vs compiled [lo, hi] | vs interp | task-clock ratio | instr M e/c | RSS MB e/c/i | warm eval ms | cert MB | verify ms |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| closure | sparse | 4 | 12 | 16 | 0.0132 | 0.0146 | 0.0178 | 1.169 [0.618, 2.211] | 0.907 | 0.783 | 1/5 | 2/4/9 | 0.00 | 0.0 | 0 |
| closure | sparse | 8 | 24 | 64 | 0.0136 | 0.0141 | 0.0181 | 0.940 [0.834, 1.059] | 0.724 | 0.636 | 1/5 | 2/4/9 | 0.00 | 0.0 | 0 |
| closure | sparse | 12 | 36 | 132 | 0.0128 | 0.0135 | 0.0181 | 0.961 [0.864, 1.070] | 0.698 | 0.628 | 1/5 | 2/4/9 | 0.01 | 0.0 | 0 |
| closure | sparse | 16 | 48 | 240 | 0.0119 | 0.0133 | 0.0168 | 0.905 [0.820, 1.000] | 0.699 | 0.610 | 1/6 | 2/4/9 | 0.01 | 0.0 | 0 |
| closure | sparse | 20 | 60 | 380 | 0.0135 | 0.0145 | 0.0188 | 0.930 [0.860, 1.006] | 0.708 | 0.729 | 2/6 | 2/4/9 | 0.02 | 0.0 | 0 |
| closure | sparse | 24 | 72 | 508 | 0.0132 | 0.0139 | 0.0182 | 0.950 [0.840, 1.074] | 0.715 | 0.616 | 2/6 | 2/4/9 | 0.05 | 0.0 | 0 |
| closure | sparse | 32 | 96 | 960 | 0.0144 | 0.0149 | 0.0183 | 0.960 [0.911, 1.011] | 0.718 | 0.735 | 2/8 | 2/4/9 | 0.05 | 0.0 | 0 |
| closure | sparse | 64 | 192 | 3905 | 0.0147 | 0.0156 | 0.0205 | 0.953 [0.896, 1.015] | 0.704 | 0.531 | 5/15 | 3/4/9 | 0.18 | 0.1 | 1 |
| closure | sparse | 128 | 384 | 14852 | 0.0152 | 0.0189 | 0.0236 | 0.802 [0.774, 0.831] | 0.645 | 0.379 | 16/47 | 3/5/9 | 0.67 | 0.3 | 2 |
| closure | sparse | 256 | 768 | 62979 | 0.0179 | 0.0347 | 0.0455 | 0.516 [0.500, 0.532] | 0.400 | 0.212 | 61/195 | 5/5/9 | 1.91 | 1.2 | 7 |
| closure | sparse | 512 | 1536 | 246280 | 0.0263 | 0.0970 | 0.1203 | 0.270 [0.253, 0.289] | 0.222 | 0.152 | 230/800 | 10/9/13 | 7.54 | 4.9 | 34 |
| closure | sparse | 1024 | 3072 | 979983 | 0.0604 | 0.3831 | 0.4672 | 0.158 [0.152, 0.165] | 0.130 | 0.127 | 903/3415 | 30/22/26 | 30.69 | 20.8 | 227 |
| closure | sparse | 2048 | 6144 | 3954709 | 0.2069 | 1.6805 | 2.0161 | 0.125 [0.122, 0.128] | 0.105 | 0.117 | 3646/14670 | 111/76/80 | 125.39 | 91.5 | 1496 |
| closure | sparse | 4096 | 12288 | 15679566 | 0.7864 | 7.0971 | 8.4119 | 0.111 [0.109, 0.114] | 0.094 | 0.107 | 14463/61998 | 427/282/286 | 507.64 | 384.0 | 8321 |
| closure | dense | 4 | 4 | 8 | 0.0146 | 0.0150 | 0.0185 | 1.071 [0.771, 1.488] | 0.857 | 0.826 | 1/5 | 2/4/8 | 0.00 | 0.0 | 0 |
| closure | dense | 8 | 16 | 56 | 0.0134 | 0.0144 | 0.0186 | 0.958 [0.879, 1.045] | 0.710 | 0.672 | 1/5 | 2/4/9 | 0.00 | 0.0 | 0 |
| closure | dense | 12 | 36 | 132 | 0.0118 | 0.0133 | 0.0169 | 0.905 [0.815, 1.006] | 0.705 | 0.687 | 1/5 | 2/4/8 | 0.01 | 0.0 | 0 |
| closure | dense | 16 | 64 | 256 | 0.0133 | 0.0144 | 0.0187 | 0.905 [0.754, 1.085] | 0.603 | 0.646 | 1/6 | 2/4/9 | 0.01 | 0.0 | 0 |
| closure | dense | 20 | 100 | 400 | 0.0140 | 0.0144 | 0.0182 | 0.971 [0.914, 1.032] | 0.740 | 0.625 | 2/6 | 3/4/8 | 0.02 | 0.0 | 0 |
| closure | dense | 24 | 144 | 576 | 0.0131 | 0.0148 | 0.0181 | 0.904 [0.795, 1.027] | 0.721 | 0.576 | 2/7 | 3/4/8 | 0.04 | 0.0 | 0 |
| closure | dense | 32 | 256 | 1024 | 0.0145 | 0.0146 | 0.0193 | 0.974 [0.899, 1.057] | 0.743 | 0.734 | 4/9 | 3/4/9 | 0.08 | 0.0 | 0 |
| closure | dense | 64 | 1024 | 4096 | 0.0144 | 0.0172 | 0.0225 | 0.876 [0.795, 0.966] | 0.641 | 0.497 | 16/27 | 3/4/8 | 0.58 | 0.1 | 2 |
| closure | dense | 128 | 4096 | 16384 | 0.0207 | 0.0316 | 0.0428 | 0.661 [0.618, 0.707] | 0.499 | 0.303 | 101/145 | 4/5/9 | 2.80 | 0.3 | 9 |
| closure | dense | 256 | 16384 | 65536 | 0.0433 | 0.1322 | 0.1839 | 0.337 [0.312, 0.365] | 0.242 | 0.241 | 704/1030 | 8/6/10 | 21.43 | 1.2 | 66 |
| closure | dense | 512 | 65536 | 262144 | 0.2007 | 0.8965 | 1.2730 | 0.228 [0.221, 0.235] | 0.160 | 0.212 | 5231/7931 | 23/11/15 | 164.30 | 5.2 | 522 |
| closure | dense | 1024 | 262144 | 1048576 | 1.3999 | 7.0863 | 10.1625 | 0.198 [0.197, 0.200] | 0.138 | 0.196 | 40253/64772 | 84/31/35 | 1304.94 | 21.9 | 4409 |
| samegen | sparse | 4 | 3 | 9 | 0.0133 | 0.0138 | 0.0182 | 0.993 [0.889, 1.109] | 0.833 | 0.658 | 1/5 | 2/5/9 | 0.00 | 0.0 | 0 |
| samegen | sparse | 8 | 7 | 21 | 0.0131 | 0.0136 | 0.0186 | 0.954 [0.861, 1.058] | 0.694 | 0.635 | 1/5 | 2/4/8 | 0.00 | 0.0 | 0 |
| samegen | sparse | 12 | 11 | 37 | 0.0134 | 0.0140 | 0.0186 | 0.964 [0.861, 1.078] | 0.728 | 0.694 | 1/5 | 2/4/8 | 0.00 | 0.0 | 0 |
| samegen | sparse | 16 | 15 | 61 | 0.0137 | 0.0138 | 0.0180 | 0.951 [0.873, 1.035] | 0.726 | 0.719 | 1/5 | 2/4/8 | 0.00 | 0.0 | 0 |
| samegen | sparse | 20 | 19 | 75 | 0.0131 | 0.0142 | 0.0184 | 0.938 [0.847, 1.039] | 0.721 | 0.704 | 1/5 | 2/4/9 | 0.01 | 0.0 | 0 |
| samegen | sparse | 24 | 23 | 101 | 0.0131 | 0.0137 | 0.0182 | 0.936 [0.868, 1.011] | 0.722 | 0.629 | 1/5 | 2/4/8 | 0.01 | 0.0 | 0 |
| samegen | sparse | 32 | 31 | 213 | 0.0139 | 0.0142 | 0.0183 | 1.078 [0.859, 1.353] | 0.842 | 0.701 | 1/6 | 2/4/8 | 0.01 | 0.0 | 0 |
| samegen | sparse | 64 | 63 | 775 | 0.0135 | 0.0143 | 0.0192 | 0.961 [0.914, 1.010] | 0.718 | 0.606 | 2/7 | 3/5/9 | 0.04 | 0.0 | 0 |
| samegen | sparse | 128 | 127 | 2307 | 0.0139 | 0.0150 | 0.0194 | 0.932 [0.862, 1.006] | 0.697 | 0.569 | 4/12 | 3/5/8 | 0.07 | 0.1 | 0 |
| samegen | sparse | 256 | 255 | 8185 | 0.0141 | 0.0173 | 0.0225 | 0.836 [0.796, 0.878] | 0.644 | 0.391 | 10/30 | 3/5/9 | 0.25 | 0.3 | 1 |
| samegen | sparse | 512 | 511 | 28507 | 0.0158 | 0.0237 | 0.0301 | 0.681 [0.622, 0.746] | 0.544 | 0.266 | 32/94 | 4/5/9 | 0.87 | 1.1 | 4 |
| samegen | sparse | 1024 | 1023 | 132795 | 0.0220 | 0.0522 | 0.0672 | 0.442 [0.369, 0.530] | 0.342 | 0.218 | 139/422 | 11/8/12 | 4.08 | 5.2 | 26 |
| samegen | sparse | 2048 | 2047 | 567377 | 0.0463 | 0.1802 | 0.2339 | 0.254 [0.248, 0.260] | 0.196 | 0.193 | 584/1847 | 34/18/22 | 17.90 | 24.6 | 133 |
| samegen | sparse | 4096 | 4095 | 1930883 | 0.1215 | 0.6405 | 0.8133 | 0.193 [0.185, 0.202] | 0.152 | 0.172 | 1992/6583 | 109/50/54 | 64.84 | 90.2 | 719 |
| samegen | dense | 4 | 5 | 9 | 0.0139 | 0.0146 | 0.0186 | 1.050 [0.814, 1.355] | 0.827 | 0.716 | 1/5 | 2/4/8 | 0.00 | 0.0 | 0 |
| samegen | dense | 8 | 13 | 43 | 0.0138 | 0.0148 | 0.0184 | 0.944 [0.867, 1.027] | 0.760 | 0.721 | 1/5 | 2/4/9 | 0.00 | 0.0 | 0 |
| samegen | dense | 12 | 21 | 101 | 0.0133 | 0.0135 | 0.0183 | 1.023 [0.967, 1.083] | 0.737 | 0.785 | 1/5 | 2/4/8 | 0.00 | 0.0 | 0 |
| samegen | dense | 16 | 29 | 195 | 0.0130 | 0.0144 | 0.0186 | 0.874 [0.723, 1.056] | 0.706 | 0.595 | 1/6 | 2/4/9 | 0.02 | 0.0 | 0 |
| samegen | dense | 20 | 37 | 321 | 0.0134 | 0.0132 | 0.0181 | 1.020 [0.959, 1.085] | 0.750 | 0.681 | 2/6 | 2/4/9 | 0.02 | 0.0 | 0 |
| samegen | dense | 24 | 45 | 499 | 0.0132 | 0.0130 | 0.0177 | 0.954 [0.842, 1.081] | 0.706 | 0.727 | 2/7 | 2/4/9 | 0.02 | 0.0 | 0 |
| samegen | dense | 32 | 61 | 853 | 0.0132 | 0.0136 | 0.0186 | 0.877 [0.622, 1.235] | 0.706 | 0.577 | 2/8 | 2/4/8 | 0.05 | 0.0 | 0 |
| samegen | dense | 64 | 125 | 3661 | 0.0133 | 0.0151 | 0.0199 | 0.922 [0.850, 1.000] | 0.690 | 0.492 | 6/17 | 3/4/9 | 0.24 | 0.1 | 1 |
| samegen | dense | 128 | 253 | 15473 | 0.0145 | 0.0195 | 0.0252 | 0.761 [0.718, 0.807] | 0.573 | 0.312 | 21/59 | 3/5/9 | 1.11 | 0.5 | 4 |
| samegen | dense | 256 | 509 | 62909 | 0.0181 | 0.0393 | 0.0502 | 0.517 [0.382, 0.699] | 0.408 | 0.228 | 84/238 | 6/6/10 | 3.42 | 2.4 | 12 |
| samegen | dense | 512 | 1021 | 254215 | 0.0331 | 0.1160 | 0.1483 | 0.282 [0.278, 0.286] | 0.220 | 0.188 | 334/1002 | 17/12/16 | 13.09 | 10.2 | 58 |
| samegen | dense | 1024 | 2045 | 1033985 | 0.0880 | 0.4671 | 0.5860 | 0.196 [0.179, 0.213] | 0.155 | 0.164 | 1360/4317 | 59/37/41 | 51.76 | 44.2 | 374 |

Every one of the 52 cases: the Ergodis derived relation equals Soufflé's output file as a tuple
set, the Soufflé interpreter's output equals the compiled binary's, the derivation certificate
verifies and the checker's reconstructed relation equals the evaluator's, and for the twelve
closure cases with N ≤ 24 the grounded path agrees.

### Reading

1. **Large sizes.** Whole-process Ergodis wall is 0.11 of compiled Soufflé on closure sparse
   N = 4096 (0.79 s against 7.10 s, 15.7 M tuples), 0.20 on closure dense N = 1024 (1.40 s against
   7.09 s), 0.19 on same generation N = 4096 sparse and 0.20 on N = 1024 dense; against the
   interpreter 0.09 to 0.16. Instruction counts tell the same story at a slightly narrower gap
   (0.23 of compiled on closure sparse 4096, 0.62 on closure dense 1024), so part of the wall
   advantage on sparse closure is memory behaviour, not instruction count.
2. **Small sizes** are process-launch bound for every system: below N ≈ 128 all three sit at
   12–20 ms wall and the ratio intervals include 1. The task-clock ratio, which excludes the
   wrapper, is 0.5–0.75 there (about 1.2 ms of CPU against 2 ms).
3. **Where the time goes.** At closure sparse N = 4096 the Ergodis process spends 599 ms
   evaluating, 148 ms writing 15.7 M CSV lines, 3 ms reading and admitting. At closure dense
   N = 1024 it is 1302 ms evaluating and 50 ms admitting (hashing the 13 MB canonical source).
   The dense closure is the only case where evaluation is far from output-proportional: the rule
   order `path(x,y), edge(y,z)` makes the work Σ over path tuples of the out-degree, 268 M
   candidate bitmap tests for 1 M output tuples; Soufflé performs the same join.
4. **Peak memory.** Ergodis 427 MB against Soufflé's 282 MB at closure sparse 4096, 84 against
   31 MB at closure dense 1024; the row store, four witness columns, the chained index and the
   1 MB CSV buffer are all touched proportionally to the derived rows. Below 1 M tuples the two
   are within a factor of 2.
5. **Certificates.** The JSON derivation certificate is 5–25 × the output relation in bytes
   (384 MB for 15.7 M closure tuples, 90 MB for 1.9 M same-generation tuples); emission is a cold
   pass, and the independent checker takes 0.35–0.55 µs per derivation plus the closed-world
   join (8.3 s at 15.7 M tuples, 4.4 s for dense closure where the closed-world pass repeats the
   268 M-candidate join). The checker is hash-set based and unoptimized by design.
6. **Compared with C1179.** Where the grounded path stopped (N = 24, 2.6 ms preparation), the
   demand path prepares in 60 µs and evaluates in 20–30 µs, and it reaches N = 4096 with the
   same evaluator and certificate schema.

### What Soufflé has that this path does not

Bodies of more than two atoms (Soufflé plans n-ary joins; here `sg` needed the two-atom rewrite
through `up`, and the same rewrite was given to Soufflé so the rule sets match), negation and
stratification, aggregates and arithmetic, records and ADTs, typed symbols and strings, multiple
outputs per program, parallel evaluation, an interpreter and compiler for a full language, and
profile-guided join ordering. The measured claim is confined to positive two-atom Boolean rules
with equality joins and constants on the four generated families above; no engine claim beyond
that rule class is made. Ergodis additionally produces a checked certificate, which Soufflé
does not.

## Design decisions taken

- Round-based semi-naive with deferred index insertion rather than a tuple-at-a-time worklist:
  same work, no per-pair stamp comparison, and the delta of every relation is a contiguous row
  range.
- Direct-addressed indexes (`domain^k` heads) and universe bitmaps rather than hashing: exact
  crossover unmeasured; the admitted bounds are the documented boundary and a hashed variant is
  a separate change.
- Static CSR indexes for relations no rule derives, chained head/next indexes for the rest.
- The certificate lists the derived tuple explicitly although it is recomputable from the
  premises, so it is inspectable and comparable without a checker pass.
- Not done: ABI provider selectors for the demand path (the provider's 1 MB byte cap makes the
  large certificates unusable there), a binary certificate encoding, n-ary bodies, incremental
  updates (`with_fact`/`update_into` exist only on the grounded path).

## Mystery ledger (`ej` + `tt` closeout)

- **Instruction ratio versus wall ratio diverge on sparse closure** (0.23 instructions, 0.11
  wall at N = 4096). Settled as far as this task goes: the Ergodis inner loop is one bitmap test
  per candidate over a 2 MB bitmap and a CSR scan, against B-tree insertion in Soufflé; the
  remaining gap is cache behaviour. Exact attribution needs a counter run with cache events,
  which the driver does not collect (perf `-e` list is task-clock, instructions, cycles). Owner:
  a successor if the number matters.
- **Dense closure is join-bound, not output-bound.** Both engines pay Σ out-degree over path.
  A bit-parallel kernel (path rows as bitsets, `path[x] |= path[y]` per edge) would make the work
  N²·N/64 words and is the door this result opens for dense inputs; not attempted.
- **Certificate size.** JSON with three parallel `u32` arrays; a delta-coded binary form would
  be roughly 6 bytes per derivation. No mystery, a queued upgrade.
- **Same-generation rounds** (31 at N = 4096 sparse, 13 at N = 1024 dense) are the tree depth
  plus one; nothing unexplained.
- **The `:u` perf event modifier** dropped every counter in run 1's first summary; recovered from
  the retained `.perf` files by the driver's `--resummarize` mode. Tooling note, no mystery.

No discovery-track entry: nothing incidental was found outside what the task was looking for.

## Reproducibility bundle

| File | SHA-256 |
|---|---|
| `ergodis/crates/verify/src/datalog.rs` | `3ce08e4d28c67cc2bd40b3f4cbc1dcd61e7206e8745c24c895eeac481def3f5e` |
| `ergodis/crates/verify/src/derivation.rs` | `fc19099678908b67a3a33f663be5e1c29a147330181e003c68e3199f8c2fecc5` |
| `ergodis/crates/rules/src/demand.rs` | `bb35d97789e0682469c1ce51fe0a993cea8f8ede055a83d1458524d3cc4bc32f` |
| `ergodis/crates/rules/tests/demand.rs` | `b629955d9b05b942e65b2cca7f0e234f2da10d4456e57a3f458908f4593eb06a` |
| `ergodis-private/examples/closure_ballpark.rs` | `9d94067e526c506a87005ce7a70f873e930183ff30f532a7ae3f9fac7f13be55` |
| `ergodis-private/analysis/datalog-comparison/compare.py` | `c146dcd24aad7f5ec1de8cf8f50396fa09a5b624542b1f377f6aa598d73e91a5` |
| `ergodis-private/analysis/datalog-comparison/results-2026-09-13-run2.json` (472 792 bytes, raw samples) | `0649cc73c3a66e9dd254197c9979251ce87604d7caf03a10904987cc007d8b69` |
| `ergodis-private/analysis/datalog-comparison/results-2026-09-13-run2.md` | `8c002f3021c323e2cba60f8c663b9b40ccdf0188e0b6631671a49988a49d2e21` |
| `ergodis-private/analysis/datalog-comparison/tc.dl` | `22ba6233859d3a335151ddc3489137b21a68fc737dd46f5b2c07ade29bb83693` |
| `ergodis-private/analysis/datalog-comparison/sg.dl` | `a990fbb36287e706e08a407ba2c9b5ec9b089134dcd7114904c92a4d238b60e2` |
| retained harness, `ergodis-private` at `77aa137` (dirty tree) | `7e6d8c7e25748fe467d16b085558fb355c068cff1e323d8eea1b5d13f9b1e9db` |

Replay:

```
cd ~/src/ergodis-private
nix shell nixpkgs#cargo nixpkgs#rustc -c ../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example --profile release --label nix
cd analysis/datalog-comparison
nix shell nixpkgs#souffle nixpkgs#gcc nixpkgs#gnumake nixpkgs#time -c python3 compare.py \
  --bin "$RETAINED_BIN" --work "$(mktemp -d)" \
  --out results-<date>.json --rounds 7 --cpu 3
```

Inputs are deterministic: xorshift64 seeded by the domain size (closure: `0x9E3779B97F4A7C15 ^ N`;
same generation: `0x2545F4914F6CDD1D ^ N`), no other randomness. The independent replay of every
derived relation is the derivation checker plus exact tuple-set comparison with Soufflé's output
file; the Soufflé interpreter and compiled binary are also compared with each other.
