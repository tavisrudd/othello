# C1061 exploration log archive: Ergodis as a compiled dynamic decision engine

**Lane**: `complete-ports`

This is the append-only historical companion to
[`2026-09-03-c1061-exploration-log.md`](2026-09-03-c1061-exploration-log.md). The probes' dated
reports are the authority for numbers and method; this file keeps the session close, the executed
session plan, and the successive state snapshots that no longer belong in the router.

## Archived 2026-09-05

The snapshots below were written one per probe as the matcher work advanced, each superseded by the
next and all of them by the C1063 through C1068 task reports. They are kept for the reasoning trail:
why the far owner's rate cache was reverted, why the certified margin predecoder is dead, and how
the standing against PyMatching was arrived at.

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
predecoder at every radius that compiles — the only sound margin commits nothing, sampled in probe
28c and then exhaustively over every ball syndrome in probe 28h; the local
I1/I2 certificate as a simpler object than the LP pair certificate (probe 28c);
caching the far owner's rate on the node record (probe 28g).

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
became one `depth`, worth 0.992x at every p=0.05 cell, and the closeout put the constant
incident-edge count back into the room that merge freed for a further 0.4%. The standing against
PyMatching is then measured directly rather than scaled for the first time since probe 28: sixteen
of eighteen cells are ahead by 2.5x to 11.5x, and only d=15 and d=25 at 5% error are behind, at
1.151x and 1.272x, with the LP certificate included in every Tiger decode and absent from
PyMatching's. Later probes should measure this rather than extend the scaling chain. `solve` at 27.5% is now the
largest symbol and has never been attacked directly. The next work is the predecoder items from
probe 28c: a radius-3 or observation-conditioned margin audited by the kernel, and the surface d=9
rows re-derived on the repaired graph.

## State after probe 28h, 2026-09-04

Both of probe 28c's predecoder items are closed. The certified margin predecoder is dead at every
radius that compiles, and exhaustively rather than by sampling: the compiled policy at the smallest
sound margin has two distinct decisions where the unsound margin has three, so no ball syndrome
anywhere in a twenty-bit ball commits a correction. A sixteen-thousand-fold increase in enumerated
context buys nothing, so the obstruction is the margin threshold and not the amount of local
information, and the observation-conditioned variant is not worth building. The construction fails
by one unit of margin; the only route left is a soundness argument valid one unit lower, or the
module's `BoundedSafe` tier used under a declared fault bound. The surface distance-9 rows probe
28c invalidated are re-derived, and exactly one published number moves: probe 29's region-shape row
at radius 2, whose repaired value restores the ball-width saturation probe 29's own text asserts.
Everything at radius 1 is bit-for-bit unchanged, because a ten-detector ball never reaches the
aliased checks. Both standing levers of this probe family — the predecoder and the matcher's
`touch_node` — are now closed; `solve` at 27.5% of the matcher profile has never been attacked.

## State after the stack ladder, 2026-09-04

The standing against PyMatching was measured directly for the first time since probe 28 (sixteen of
eighteen cells ahead, 2.5x to 11.5x; d=15 and d=25 at 5% error behind at 1.151x and 1.272x), and the
layers above the matcher were measured against the shipped arm. Two findings. Graph specialization
is the dominant optimization in the package, worth up to 18.8x at d=25 p=0.001 and almost nothing at
d=25 p=0.05, and at 0.1% error the sparse matcher runs on 0.005% to 0.15% of shots, so the large
low-error wins are the compiled closure and the closed-form fast paths rather than the matching
engine. Against that, the shipped `LEVEL_SPARSE` arm is not the fastest configuration in 13 of 18
cells — level 3 wins eleven of them, by up to 2.334x — so every benchmark including the PyMatching
comparison is reported on something slower than the kernel can already do. Tavis has directed that
the default and every state-of-the-art comparison use the best arm per point; that is C1063, for a
later session, specified in `2026-09-04-c1063-tiger-blossom-solver-routing-brief.md`. Evidence:
ergodis-private `benchmarks/tiger-blossom/2026-09-04-probe28g-ce0658b-{stack-ab,vs-pymatching-external-ab}.log`.
