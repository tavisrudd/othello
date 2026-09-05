# C1061 exploration log: Ergodis as a compiled dynamic decision engine

**Lane**: `complete-ports`
**Brief**: `2026-09-03-c1061-ergodis-compiled-dynamic-solver-brief.md`
**QEC redirect brief**: `2026-09-03-c1061-qec-redirect-brief.md`
**Code**: `~/src/ergodis-private` (with core changes in `~/src/ergodis`)

**Archive**: `2026-09-03-c1061-exploration-log-archive.md` holds the session close, the executed
session plan, and the per-probe state snapshots.

This is the routing document for C1061. The task asks whether Ergodis can act as a compiled dynamic
decision engine: a problem compiled once into a retained composition tree, then kept optimal under a
stream of typed events by leaf-to-root delta updates, with certificates, quotients, and — where the
congruence closes — a computed transducer that replaces the tree entirely. Each probe below has its
own dated report; this file carries only the probe index, the standing results and negatives, the
open successors, and the process rules. Reports are the authority for numbers and method.

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
| 28g   | Depth merge kept, rate cache rejected               | 0.988x kept; caching the far owner rate is 1.10x, reverted               | `2026-09-04-c1061-probe28g-depth-merge-and-the-rejected-rate-cache.md`        |
| 28h   | Margin radius grid; surface d=9 re-derived          | killed; no ball syndrome at any radius commits a correction at margin 3  | `2026-09-04-c1061-probe28h-margin-radius-and-the-surface-d9-rederivation.md`  |
| 29    | Local-commit predecoder                             | sound at every radius; does not compile past small d                     | `2026-09-03-c1061-probe29-local-commit-predecoder.md`                        |
| 30    | Margin certificate predecoder                       | certificate proved and local; not yet d=9 accuracy-identical             | `2026-09-03-c1061-probe30-margin-certificate-predecoder.md`                  |
| 31    | Sparse evaluation and per-witness margin            | paused by Tavis; per-witness margin dead as posed                        | `2026-09-03-c1061-probe31-sparse-evaluation-and-per-witness-margin.md`       |
| —     | Launches, candidates, caveats, and the QEC redirect | cross-cutting log entries belonging to no single probe                   | `2026-09-03-c1061-cross-cutting-log-notes.md`                                |


## Successor tasks, all closed

The probe series above ran to 2026-09-04. Everything after it happened under allocated successor
tasks, and their reports are the authority for the current state of the decoder:

| Task  | Result                                                                                   | Report                                                        |
|-------|------------------------------------------------------------------------------------------|---------------------------------------------------------------|
| C1063 | default arm is `LEVEL_ROUTED`, never worse across 55 cells, up to 1.97x faster            | `2026-09-04-c1063-tiger-blossom-routing-and-real-usage-grid.md` |
| C1064 | grid moved to stim-generated weighted circuit-level detector error models                 | `2026-09-04-c1064-weighted-circuit-level-dem.md`                |
| C1065 | sparse matcher's fixed per-shot cost removed; 13 to 47 per cent cheaper at every rate     | `2026-09-05-c1065-sparse-matcher-weighted-fixed-cost.md`        |
| C1066 | heap rejected on measurement; queue clearing and scanning compiled from the graph         | `2026-09-05-c1066-sparse-matcher-queue-discipline.md`           |
| C1067 | performance-contract audit; traffic counters moved behind the `tiger-traffic` feature     | `2026-09-05-c1067-tiger-matcher-performance-contract-audit.md`  |
| C1068 | certificate pair loop was the lever on the losses; certificate now checks the primal too  | `2026-09-05-c1068-touch-loop-and-certificate-closure.md`        |

## Standing results

The retained composition tree with typed deltas, the closed-form LRC leaf, the profile-level
vocabulary, the computed exact transducer plus constant-cost ingest (11.4x over the tree), the
generic `OpenProblem` core with a certificate chain over four summary shapes, the policy transducer
and worklist minimizer, the two defect-kernel collapses landed in core (15x), and the routing win
over Dijkstra re-solve.

TigerBlossom is exact, with region growth and blossom expansion as its only general solver and the
LP certificate — which now checks the primal pairing as well as the dual — inside every decode. Its
default arm routes per shot between the cluster decomposition and the sparse matcher on defect
count. On stim-generated weighted circuit-level detector error models it is ahead of PyMatching in
27 of 33 operating cells in instructions and 30 in cycles, with zero weight and zero prediction
disagreements on all 33; the same six cells are behind, the worst at 1.704. `routing_threshold` is
fitted on mean degree for weighted graphs and the unit-weight branch is kept verbatim.

## Standing negatives

Dense per-shot QEC decoding; syndrome orbit compilation; boundary-matrix compression, since the
table is already the compressed form; the probability semiring over the cost decomposition as
reliability; capped-multiplicity state keys; per-witness margin as posed; memoization on unique
fleets; the QEC time-axis chain beyond distance 6.

The certified margin predecoder is dead at every radius that compiles: the only sound margin commits
no correction, sampled in probe 28c and then exhaustively over every ball syndrome in probe 28h, and
a sixteen-thousand-fold increase in enumerated context buys nothing. The construction fails by one
unit of margin, so the only routes left are a soundness argument valid one unit lower or the
module's `BoundedSafe` tier under a declared fault bound.

Also closed by measurement: the local I1/I2 certificate as a simpler object than the LP pair
certificate; caching the far owner's rate on the node record, which costs more in region-wide
invalidation than the dependent load it removes; the touch loop's own gather repair; and a heap in
place of the bucket queue, which loses on both noise models because the queue takes about eight
pushes per pop.

## Paused, with next steps in their reports

Probe 18 (generic chain zero-allocation regression; the 9.5 dedupe needs a quiet tree), probe 21
(routing fair baseline), probe 22 (non-degenerate LRC regime, true reliability gates). The ADR at
`~/src/ergodis-private/docs/adr/0001-generic-dynamic-decision-layer.md` is a proposal awaiting
Tavis's decision on core extraction.

## Open successors

A third code family to test the mean-degree crossover rule behind `routing_threshold`; the
queue-struct borrow split, which is the only remaining lever on the touch loop; the same certificate
read applied to the predecoder path; compile-time splitting of the non-observable stabilizer
component, which halves both decoders and changes no ratio; and the latency tail beyond the
ninety-ninth percentile.

Three decisions wait on Tavis: routing the unspecialized graph path; the C1066 queue-discipline
tradeoff, where compiling the clearing and scanning discipline from the graph's largest edge weight
returns about half of what C1065 cost the published phenomenological grid and costs the weighted
grid at most 0.4 per cent; and the harness's PyMatching working-set asymmetry, which runs in Tiger's
favour in cycles.

## Standing caveats

Surface-family numbers taken before 2026-09-04 are invalid: `RotatedSurfaceCode::new` had a
distance-one defect, repaired in C1063. Repetition-family numbers are untouched. Census and traffic
runs need `--features tiger-traffic`; a build without it prints `counters off`. Every PyMatching
ratio published before C1068 credited the competitor with being 2.34 per cent cheaper than it is,
because its per-decode divisor did not match the decodes it performed.

## Process rules

Instructions are primary under load, and cycles are unusable below about a thousand instructions per
operation. Use the fixed-window harness and bound every timed loop on `--operations`; a near-zero
per-operation cost means a broken loop. Pin and hash both A/B binaries. Commit with
`git commit -m .. -- <own paths>`, since the shared index is not safe even after a staged check.
