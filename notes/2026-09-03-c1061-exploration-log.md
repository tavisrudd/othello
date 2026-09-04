# C1061 exploration log: Ergodis as a compiled dynamic decision engine

**Lane**: `complete-ports`
**Brief**: `2026-09-03-c1061-ergodis-compiled-dynamic-solver-brief.md`
**QEC redirect brief**: `2026-09-03-c1061-qec-redirect-brief.md`
**Code**: `~/src/ergodis-private` (with core changes in `~/src/ergodis`)

This is the routing document for C1061. The task asks whether Ergodis can act as a compiled dynamic
decision engine: a problem compiled once into a retained composition tree, then kept optimal under a
stream of typed events by leaf-to-root delta updates, with certificates, quotients, and — where the
congruence closes — a computed transducer that replaces the tree entirely. Each probe below has its
own dated report; this file carries only the probe index, the standing results, the process rules,
and the next-session plan. Reports are the authority for numbers and method.

## Probe index

| Probe | Name                                                | Verdict                                                                  | Report                                                                     |
|-------|-----------------------------------------------------|--------------------------------------------------------------------------|----------------------------------------------------------------------------|
| 1     | Composition survey and delta prototype              | promote; delta 614 ns vs 4.93 ms fresh at 16,384 leaves                   | `2026-09-03-c1061-probe1-composition-survey-and-delta-prototype.md`          |
| 2     | Real kernel binding, witness deltas                 | promote; break-even 1.13 updates; 2 to 4 normalized classes               | `2026-09-03-c1061-probe2-real-kernel-witness-deltas.md`                      |
| 3     | Incremental certificates                            | promote; O(depth) verify; default now `sha256-packed`                     | `2026-09-03-c1061-probe3-incremental-certificates.md`                        |
| 4     | Evolve sufficient statistics                        | promote; closure plus exactness both needed                              | `2026-09-03-c1061-probe4-evolve-sufficient-statistics.md`                    |
| 5     | Snapshot-bind acceleration                          | promote, layout-conditional; canonicalization defect fixed                | `2026-09-03-c1061-probe5-snapshot-bind-acceleration.md`                      |
| 6     | Summary-keyed cache and witness serving             | promote; key on the summary, not the class                               | `2026-09-03-c1061-probe6-summary-keyed-cache-and-witness-serving.md`         |
| 7     | Other domains and shapes (QEC, policy, routing)     | semiring layer promote; QEC conditional; policy promote; routing conditional | `2026-09-03-c1061-probe7-other-domains-and-shapes.md`                     |
| 8     | Monoidal collapse inside kernels                    | promote; two kernels collapsed, one structural rule                      | `2026-09-03-c1061-probe8-monoidal-collapse-inside-kernels.md`                |
| 9     | Closed-form review and local witness                | closed form proved for `repaired_count` only; kernel stays                | `2026-09-03-c1061-probe9-closed-form-review-and-local-witness.md`            |
| 10    | QEC space axis and split-only minimizer             | space cut promote (distance-independent); transducer promote             | `2026-09-03-c1061-probe10-qec-space-axis-and-split-only-minimizer.md`        |
| 11    | Defect-kernel collapses landed in core              | landed; 14.85x / 15.45x fewer instructions, gate green                   | probe 8 report, log addendum                                                 |
| 12    | Family test and compiled transducer                 | closed form generalizes; table is an accelerator, not an optimizer       | `2026-09-03-c1061-probe12-family-test-and-compiled-transducer.md`            |
| 13    | QEC window exactness and external baseline          | QEC decoding drop from product list; worklist minimizer promote          | `2026-09-03-c1061-probe13-qec-window-exactness-and-external-baseline.md`     |
| 14    | ADR for the generic dynamic decision layer          | proposed, for Tavis; no migration decided                                | `2026-09-03-c1061-probe14-generic-decision-layer-adr.md`                     |
| 15    | Incremental top-k and tie-closed state              | top-k promote (11.4x); no exact compressive key; probe 12 reversed       | `2026-09-03-c1061-probe15-incremental-topk-and-tie-closed-state.md`          |
| 16    | ADR question 1, one trait for four summaries        | trait holds as four-method core plus three capability traits             | `2026-09-03-c1061-probe16-adr-question1-trait-check.md`                      |
| 17    | Sparsity-aware composition and routing              | QEC closed; routing promote, no longer conditional                       | `2026-09-03-c1061-probe17-sparsity-aware-composition-and-routing.md`         |
| 18    | Generic certificate chain                           | promote; one chain serves four shapes; table certificates work           | probe 3 report, log addendum                                                 |
| 19    | Profile-level vocabulary                            | promote; exact computed transducer plus constant-cost ingest             | `2026-09-03-c1061-probe19-profile-level-vocabulary.md`                       |
| 20    | Sealed obligations and second semirings             | obligations sealed; probability semiring is not reliability              | `2026-09-03-c1061-probe20-sealed-obligations-and-second-semiring.md`         |
| 21    | Fair dynamic routing baseline                       | stopped as documentation; continues in a fresh session                   | `2026-09-03-c1061-probe21-fair-dynamic-routing-baseline.md`                  |
| 22    | Non-degenerate regime and true reliability          | stopped as documentation; parts B and C unverified                       | `2026-09-03-c1061-probe22-nondegenerate-regime-and-true-reliability.md`      |
| 23    | Context-certified predecoder                        | promote; the QEC opportunity is real in this form                        | `2026-09-03-c1061-probe23-context-certified-predecoder.md`                   |
| 24    | Matching-signature compression                      | killed; hypothesis inverted, the table is the compressed form            | `2026-09-03-c1061-probe24-matching-signature-compression.md`                 |
| 25    | Soft-output gap                                     | exact, loses on cost                                                     | `2026-09-03-c1061-probe25-soft-output-gap.md`                                |
| 26    | TigerBlossom kernel                                 | promote; exact; wins at low error, loses through the dense fallback      | `2026-09-03-c1061-probe26-tiger-blossom-kernel.md`                           |
| 27    | Locality and surface-code predecoder                | locality argument false; certificate transfers, compilation does not     | `2026-09-03-c1061-probe27-locality-and-surface-code-predecoder.md`           |
| 28    | TigerBlossom sparse fallback, every cell            | 15 of 18 cells won; three p=0.05 cells lose with a measured cause        | probe 26 report, probe-28 section and log addendum                           |
| 28b   | TigerBlossom dual drift                             | drift fixed; declines to zero; worst cell 16% better                     | `2026-09-04-c1061-probe28b-tiger-blossom-dual-drift.md`                      |
| 28c   | Blossom expansion; Tiger behind the predecoder      | dense matcher gone, all 18 cells faster; sound margin commits nothing    | `2026-09-04-c1061-probe28c-blossom-expansion-and-tiger-behind-the-predecoder.md` |
| 28d   | Sparse core scheduling cost                         | 5% off every high-error cell; re-arm waste gone; design note for a safer core | `2026-09-04-c1061-probe28d-sparse-core-scheduling-cost.md`                    |
| 28e   | Validate-on-pop sparse core, taken                  | stamps gone, oracle in; packed layout 0.926x at the losing cells; d=9 at parity | `2026-09-04-c1061-probe28e-validate-on-pop-sparse-core.md`                    |
| 28f   | Hoist measured, narrow closure                      | hoist 0.93x at p=0.05; u16 closure a wash; d=9 ahead of PyMatching, d=15/25 at 1.17x/1.28x | `2026-09-04-c1061-probe28f-hoist-ab-and-narrow-closure.md`                  |
| 28g   | Depth merge kept, rate cache rejected               | depth merge 0.992x; caching the far owner's rate is 1.10x, reverted      | `2026-09-04-c1061-probe28g-depth-merge-and-the-rejected-rate-cache.md`        |
| 29    | Local-commit predecoder                             | sound at every radius; does not compile past small d                     | `2026-09-03-c1061-probe29-local-commit-predecoder.md`                        |
| 30    | Margin certificate predecoder                       | certificate proved and local; not yet d=9 accuracy-identical             | `2026-09-03-c1061-probe30-margin-certificate-predecoder.md`                  |
| 31    | Sparse evaluation and per-witness margin            | paused by Tavis; per-witness margin dead as posed                        | `2026-09-03-c1061-probe31-sparse-evaluation-and-per-witness-margin.md`       |
| —     | Launches, candidates, caveats, and the QEC redirect | cross-cutting log entries belonging to no single probe                   | `2026-09-03-c1061-cross-cutting-log-notes.md`                                |

## Session close, 2026-09-03

Thirty-one probes in one day; all reports and code committed (monorepo `notes/`, ergodis-private
through `880ffa6`, ergodis core through `9a02921`). All three trees clean.

**Standing results.** The retained composition tree with typed deltas, the closed-form LRC leaf,
the profile-level vocabulary, the computed exact transducer plus constant-cost ingest (11.4x over
the tree), the generic `OpenProblem` core with a certificate chain over four summary shapes, the
policy transducer and worklist minimizer, the two defect-kernel collapses landed in core (15x), the
routing win over Dijkstra re-solve, the proved predecoder safety certificates (per-context,
local-commit, margin), and TigerBlossom (exact on 360,000 shots, region growth with blossom
expansion as its only general solver, 15 of 18 cells ahead of PyMatching).

**Standing negatives.** Dense per-shot QEC decoding; syndrome orbit compilation; boundary-matrix
compression (the table is already the compressed form); probability semiring over the cost
decomposition as reliability; capped-multiplicity state keys; per-witness margin as posed;
memoization on unique fleets; QEC time-axis chain beyond distance 6; the certified margin
predecoder at radius 1 or 2 (the only sound margin commits nothing; probe 28c); the local
I1/I2 certificate as a simpler object than the LP pair certificate (probe 28c).

**Paused, with next steps in their reports.** Probe 18 (generic chain zero-allocation regression,
9.5 dedupe needs a quiet tree), probe 21 (routing fair baseline), probe 22 (non-degenerate LRC
regime, true reliability gates), probe 28c (sparse core's per-event scheduling cost at the three
losing p=0.05 cells; surface d=9 predecoder rows to re-derive on the repaired graph). The
ADR at `~/src/ergodis-private/docs/adr/0001-generic-dynamic-decision-layer.md` is a proposal
awaiting Tavis's decision on core extraction.

**Process rules learned today.** Instructions primary under load, cycles unusable below about a
thousand instructions per op; fixed-window harness, every timed loop bound on `--operations`;
near-zero per-op cost means a broken loop; pin and hash both A/B binaries; commit with
`git commit -m .. -- <own paths>` since the shared index is not safe even after a staged check.

## Next session plan, set 2026-09-04 by Tavis

1. **Matcher first** (probe 28c): the three simplifications in
   `2026-09-04-c1061-probe28b-tiger-blossom-dual-drift.md`, in order: blossom expansion and
   deletion of the dense matcher (`tiger_blossom_match.rs`, pair matrix, cluster plumbing); the
   local I1/I2 certificate in place of the LP pair loop; one queue entry per edge. Gates: the
   debug I1/I2 assertion suite, full-coverage ratchet, 360,000-shot PyMatching exactness, the
   18-cell A/B against retained `ergodis-tools-dfd4ee0`, zero allocation.
2. **Then the broader pipeline**: the certified predecoder (probes 23, 27, 29, 30, 31) has no
   in-process strong decoder for deferred shots; PyMatching is only an out-of-process baseline.
   Wire TigerBlossom as the strong decoder behind the defer path (same compiled detector graph),
   then bench and optimize the end-to-end predecoder-plus-Tiger pipeline against PyMatching alone
   on the shot grid, instructions and per-shot latency (the unrun `latency` mode). Probe 31's
   sparse-margin cost across p and the d=5 oracle audit fold into this.
3. Standing external framing (ChatGPT, 2026-09-03, retained for context): of its five routes,
   the context-certified tiered predecoder is built (probes 23 to 31), the boundary-matrix
   compression was killed (probe 24), soft output was measured (probe 25); open are FPGA
   synthesis of small tiers and moving to qLDPC/bivariate-bicycle codes where no dominant sparse
   matcher exists. Neither is scheduled before items 1 and 2.

## State after probe 28d, 2026-09-04

Probe 28c's item 1 is done except the local certificate, which is closed with a reason; item 2 is
done and its answer is negative at the radii built (margins 1 and 2 unsound, margin 3 commits
nothing; the surface d=9 graph used by probes 27 to 31 was aliased, fixed). Probe 28d took the
scheduling target: single-edge re-arm and a shift for the rate division give 0.95x at the three
losing p=0.05 cells, and the traffic counters show the remaining evaluations are the initial
scheduling of the defects, so no further scheduling win exists. Its report carries a design note,
requested by Tavis, for a simpler and safer sparse core (validate on pop, re-push on touch, one
"no late entry" debug oracle, packed per-node and per-region state).

## State after probe 28e, 2026-09-04

Tavis delegated the decision and the redesign was taken in stages (probe 28e). The scheduling
layer now validates every pop against a pure time function, re-arms by touching what changed,
keeps a one-directional newest-entry cache instead of stamps, and asserts the whole queue
contract after every handler in debug builds; the packed layout then takes the three losing
p=0.05 cells to 0.926x of probe 28d with exactness intact (d=9 at derived parity with
PyMatching, d=15 and d=25 at about 1.26x and 1.37x). The last commit, `22d8e98` (hoisting a
node's record out of its incident-edge loop), passes every gate but has no A/B yet. Next, in
order: that A/B; a `u16` closure mirror for the certificate's reads; then the predecoder only
under a radius-3 or observation-conditioned margin audited by the kernel.

## State after probe 28f, 2026-09-04

The hoist measured at 0.93x of the layout build at every p=0.05 cell and 0.86x of probe 28d's
control, so d=9 is now ahead of PyMatching on the derived standing and d=15/d=25 sit at about
1.17x and 1.28x. The certificate's `u16` closure mirror is exact and gated but a wash: flat
instructions, about 1% of cycles at d=25 p=0.05, and it is kept only because it is never worse
at a losing cell (probe 28f). The profile now puts `touch_node` and `solve` at 28.6% and 29.9%
with the certificate at 7.6%; the next lever is the far owner's rate load inside `touch_node`,
then the predecoder items from probe 28c.

## State after probe 28g, 2026-09-04

The far owner's rate is closed as a lever and the reason is structural, not an implementation
detail. Caching a region's rate on the node record removes the dependent load and buys about one
per cent of the decode, but a region's offset shifts for every node it covers, so every rate change
walks that region's subtree; `set_growth` becomes 11% of the d=25 p=0.05 profile and the cache
measures 1.10x at every p=0.05 cell. It is reverted, and rate falls — which the scheduling contract
lets cost nothing today — are why no rearrangement of the walks closes the gap. The refactor that
enabled it is kept: a node's `distance` and `wrapped` were only ever read as their difference and
became one `depth`, worth 0.992x at every p=0.05 cell, which carries the derived standing against
PyMatching to about 0.92x at d=9, 1.16x at d=15 and 1.27x at d=25. `solve` at 27.5% is now the
largest symbol and has never been attacked directly. The next work is the predecoder items from
probe 28c: a radius-3 or observation-conditioned margin audited by the kernel, and the surface d=9
rows re-derived on the repaired graph.
