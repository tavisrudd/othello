# C1061 probe 28g: one depth per node, and the far owner's rate cache rejected

**Lane**: `complete-ports` · **Date**: 2026-09-04 · **Code**: ergodis-private `ced13b7` (the depth
merge, kept), `5e70cc8` (the rate cache, reverted by `df69199`); evidence `ab3324d`; retained
binaries `ergodis-tools-ced13b7` (SHA-256 `198fa1f7…cdb1`) and `ergodis-tools-5e70cc8`
(`79776659…a373`); controls `ergodis-tools-ca31df6` (probe 28f) and `ergodis-tools-586ec26`
(probe 28d) · **Continues**: `2026-09-04-c1061-probe28f-hoist-ab-and-narrow-closure.md`.

## Headline

**The lever probe 28f named — the far owner's rate, one dependent load per incident edge — is a
measured negative, and the tree is back where it started plus a small independent win.** Caching
the owning region's rate on the node record does remove the load, and buys about one per cent of
the decode for it. But a region's dual offset shifts for every node the region covers, so every
rate change must walk that region's subtree, and `set_growth` — previously too small to appear in
any profile — becomes 10.96% of the d=25 p=0.05 profile, which on its own more than accounts for
the whole regression. The eighteen-cell A/B puts the cache at 1.096x to 1.109x of its parent at
p=0.05. It is reverted.

The enabling refactor that came with it is kept and is worth 0.8% on its own: a node's `distance`
and `wrapped` fields were only ever read as their difference, so they became one `depth`, and the
constant incident-edge count left the hot record for its own array. That measures 0.992x of probe
28f's build at every p=0.05 cell, with intervals of width 0.001.

Exactness against PyMatching holds on all 360,000 frozen shots at both stages, cell for cell
identical to probe 28f's counts.

## Stage one: one depth per node (`ced13b7`), kept

`NodeState` held `distance` (doubled distance from the owning region's source) and `wrapped` (the
frozen radii of the regions between the absorbing region and the outermost one now covering the
node). Every read in the file was of `distance - wrapped`, so the two fields become one `depth`,
and each writer folds accordingly: `absorb` adds twice the edge weight to the parent's depth,
`fold_subtree` subtracts the frozen radius where it used to add it to `wrapped`, `unfold_subtree`
adds it back, and the phantom re-cover sets `depth = -phantom_wrapped`. The constant per-node
incident-edge count moves out of the record into its own array, which keeps `NodeState` at sixteen
bytes; it is read once per touch rather than on every event-time evaluation.

Measured interleaved, eight rounds, two-size differencing, paired log-ratio 95% intervals, against
probe 28f's final build:

| d  | p     | `ca31df6` | `ced13b7` | ratio | cycles ratio |
|----|-------|-----------|-----------|-------|--------------|
| 3  | 0.05  | 610.2     | 607.1     | 0.995 | 1.024        |
| 5  | 0.05  | 2,155.2   | 2,140.0   | 0.993 | 0.997        |
| 7  | 0.05  | 4,215.9   | 4,183.4   | 0.992 | 0.985        |
| 9  | 0.05  | 6,702.0   | 6,648.5   | 0.992 | 0.981        |
| 15 | 0.05  | 14,543.8  | 14,421.7  | 0.992 | 0.994        |
| 25 | 0.05  | 27,469.1  | 27,236.5  | 0.992 | 0.989        |

Instructions per decode. Every instruction interval excludes 1.0. The p=0.01 and p=0.001 cells
move by less than 0.5%. Log: ergodis-private
`benchmarks/tiger-blossom/2026-09-04-probe28g-ced13b7-vs-ca31df6-binaries-ab.log`.

Carried onto probe 28f's derived standing against PyMatching, the three formerly losing cells move
by the same 0.992: d=9 to about 0.92x, d=15 to about 1.16x, d=25 to about 1.27x. These remain
derived from probe 28d's scaling, not a fresh direct comparison.

## Stage two: the cached owner rate (`5e70cc8`), reverted

A region's dual is `radius(t) = rate[r].offset + rate[r].growth * t`. Evaluating an incident edge
loaded the far endpoint's node record and then, at an address that record supplied, `rate[far.owner]`
— a load waiting on the load before it. The stage gave each node `term = depth - rate[owner].offset`
and a copy of its owner's `growth`, so that `edge_time_between` reads the two node records and
nothing else; `boundary_time`, `release_time` and `phantom_time` lost their rate loads too. Both
new fields fit the four bytes stage one had freed, so the record stayed sixteen bytes.

The invariant is that the pair is current for every covered node. Its writers are the node's own
(`absorb`, the phantom re-cover, `on_release`, `expand`'s release of its own nodes, `fold_subtree`,
`unfold_subtree`, `solve`'s initialization, `reset`) and, because an offset shift moves every node
a region covers, `set_growth`, which walks the region's subtree exactly as `touch_region` does. A
debug oracle compares both cached fields against the rate table after every handler; it has to run
before the no-late-entry oracle, because a stale cache would otherwise make the scheduled time and
the validation that pops it wrong in the same way and neither would see it.

An adversarial review of the invariant
(`2026-09-04-c1061-probe28g-fable-review.md`) found no defect in either stage: the writer list is
complete, the refresh walk reaches exactly the nodes a rate change affects, and every rewritten
formula is equivalent. Its findings were all cost, and the measurement agreed with them.

Measured the same way against stage one and against probe 28d's control:

| d  | p     | `ced13b7` | `5e70cc8` | ratio     | vs `586ec26` |
|----|-------|-----------|-----------|-----------|--------------|
| 9  | 0.01  | 385.7     | 409.4     | 1.061     | 0.991        |
| 9  | 0.05  | 6,648.6   | 7,370.5   | **1.109** | 0.948        |
| 15 | 0.01  | 1,005.2   | 1,084.9   | 1.079     | 0.995        |
| 15 | 0.05  | 14,421.7  | 15,951.4  | **1.106** | 0.943        |
| 25 | 0.01  | 2,696.2   | 2,945.0   | 1.092     | 1.011        |
| 25 | 0.05  | 27,236.5  | 29,952.6  | **1.100** | 0.947        |

Every p=0.05 and p=0.01 cell is worse; the last column shows the cache giving back most of what
probes 28d to 28f won. Logs: ergodis-private
`benchmarks/tiger-blossom/2026-09-04-probe28g-5e70cc8-{vs-ced13b7,vs-586ec26}-binaries-ab.log`.

### Where it went

`perf record` over 163,840 decodes at d=25 p=0.05, self time by symbol
(`benchmarks/tiger-blossom/2026-09-04-probe28g-profile-5e70cc8-d25-p0.05.txt`): `solve` 27.5%,
`touch_node` 25.1%, **`set_growth` 11.0%**, `certify` 8.6%, `push_event` 7.5%, `descend` 3.3%,
`common_chain_sum` 2.8%, `touch_region` 1.9%, `dissolve` 1.8%, `on_collision` 1.7%. `set_growth`'s
body is the refresh walk; before this stage the function was six instructions and appeared in no
profile.

The two numbers close against each other. That cell runs at 8,211.9 cycles per decode in the
paired A/B, so `set_growth`'s 11.0% is about 903 cycles of new work per decode, while the whole
measured regression is 8,211.9 less 7,382.7, or 829 cycles. The refresh walk therefore costs more
than the entire loss, and what the removed load gives back is the difference — roughly 74 cycles,
about one per cent of the decode. (Share comparisons against probe 28f's profile understate this:
`touch_node` reads 25.1% here against 28.6% there, but eleven points of new work sit in the
denominator.)

### Why no rearrangement rescues it

Three of the walks are removable and one is not.

- `contract` freezes each cycle member and then immediately folds it into the blossom, so the
  freeze's walk is overwritten by the fold's; it is dead work.
- `expand` unfolds every member and then calls `set_growth` on the path members, walking them
  twice; writing each member's final rate before the unfold would leave one walk.
- `dissolve` and `on_collision` walk to refresh and then walk again to re-arm; a fused walk would
  halve those.
- What cannot be removed is the reason the design fails. A region whose rate *falls* previously
  needed no per-node work at all — the module's scheduling contract is that a rate decrease only
  makes existing entries early, which is safe — and `dissolve` and `on_collision` do exactly that
  on every augmentation and every tree extension. With a per-node mirror of the rate, those become
  full subtree walks.

The arithmetic does not close: the read side is worth about one point and the maintenance side
costs about eleven, of which at best half is duplication. The underlying reason is that the rate
table is a few kilobytes and stays in L1, so the load being removed is cheap, while the mirror
being kept is charged at every rate change. Any future attempt to remove that load needs to leave
the rate in one place.

## Gates

Debug kernel suite at both stages (the random suite at four distances, 20,000 instances each, with
the `I1`/`I2` and boundary assertions, the no-late-entry oracle, and for stage two the new
cache oracle, all after every event): pass. Release kernel suite including the zero-allocation
`decode_batch` gate: pass. `cargo clippy --all-targets --all-features -- -D warnings` clean in
debug and release; `cargo fmt --check` clean. PyMatching 2.4.0 `verify` on `--mode emit
--operations 20000` per cell: zero weight disagreements on all eighteen cells for both stages, and
the prediction-mismatch counts identical cell for cell to probe 28f's
(`benchmarks/tiger-blossom/2026-09-04-probe28g-{ced13b7,5e70cc8}-pymatching-exactness.txt`, the two
files byte-identical to each other). The revert `df69199` restores `ced13b7`'s file exactly, so
stage one's measurements stand for the current tree without a further run.

## Mystery ledger

- **The three p=0.05 cells against PyMatching.** d=9 is ahead on the derived standing; d=15 and
  d=25 sit at about 1.16x and 1.27x. Settled today: the far owner's rate is not the lever, and the
  reason is structural rather than an implementation detail, so this closes the profile's
  `touch_node` line as a target. Open: `solve` at 27.5% with its inlined handlers is now the
  largest single symbol and has never been attacked directly.
- **`descend` doing real work with no blossoms in most shots.** Unchanged and still open from
  probe 28e. It reads 3.3% here against 6.4% in probe 28f, but that profile is of the rejected
  build, whose extra eleven points inflate the denominator; nothing was measured about `descend`
  itself.
- **The p=0.001 cells are immovable.** Every stage since 28d moves them by less than 0.5%. Those
  cells are dominated by setup the matcher never enters, which is consistent but has never been
  confirmed by a profile of a p=0.001 cell.
- **Newtype indices.** Still open as hygiene.

## Vibe check

Clean negative, cheaply bought. The lever the last probe pointed at is dead for a structural
reason worth knowing, one small independent win came out of the refactor that enabled it, and the
matcher is committed, gated and exact throughout.

## Next

1. The predecoder items from probe 28c, unchanged: a radius-3 or observation-conditioned margin
   audited by the kernel, and the surface d=9 rows re-derived on the repaired graph.
2. If the matcher is picked up again, `solve` and its inlined handlers, not `touch_node`.
