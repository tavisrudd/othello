# C1068: the sparse matcher's search on the six weighted PyMatching losses

**Lane**: `complete-ports` · **Date**: 2026-09-05 · **Code**: `~/src/ergodis-private`
**Contract**: `~/src/ergodis-contrib/PERFORMANCE.md` and the shared playbook it names
**Predecessors**: `2026-09-05-c1065-sparse-matcher-weighted-fixed-cost.md`,
`2026-09-05-c1066-sparse-matcher-queue-discipline.md`,
`2026-09-05-c1067-tiger-matcher-performance-contract-audit.md`
**Companion**: `2026-09-05-c1068-qec-decoder-risk-review.md`, the independent risk review of
the whole decoder chain that this task commissioned and then acted on
**Code commits**: ergodis-private `ef62467` (the four performance changes), `7212d6f` (the
certificate's primal and odd-set checks), `4241dcc` (the decline accounting and the
measurement-harness repairs)
**Retained binaries**: `ergodis-tools-fa21d85` (control, SHA-256 `27c45998…5646`),
`ergodis-tools-ef62467` (`a3d18e7f…c665b` — performance only),
`ergodis-tools-7212d6f` (`6b82141d…c665b`),
`ergodis-tools-4241dcc` (final, `6740004c…6973`)
**Status**: in progress

## Headline

**The certificate's pair loop, not the touch loop, was where the six losing cells were losing:
it carried 72 per cent of the kernel's last-level cache misses and, once a blossom existed,
walked two ancestor chains for every one of about 950 defect pairs. Cutting it — a `u16`
closure saturated at the point above which its constraint cannot bind, and a comparison of
outermost regions in place of the chain walks — together with an eight-byte queue record and a
packed undo list, makes the matcher 13.2 per cent cheaper at the worst cell and 3 to 9 per cent
cheaper across the losing family, with no change to the search: census parity against the C1067
control holds exactly on all 146 cell and arm combinations.** The touch loop's own repair, a
gather that would lift its redundant bounds checks, was measured and lost.

**The independent risk review this task commissioned then found something worth more than the
speed.** The published exactness story — every answer proved optimal by linear-programming
duality, so a matcher defect costs a flagged shot and never a wrong answer — was not what the
code implemented: `certify` checked a feasible dual and that its objective matched the *claimed*
primal cost, but never that the claim came from a valid matching, and it computed the blossom
odd-cardinality counts that make each dual coefficient a valid inequality and then discarded
them unread. Both halves are now checked, and neither refuses anything on the measured grid.
The review also found that the PyMatching arm's per-decode divisor did not match the decodes it
performed, crediting the competitor with being 2.34 per cent cheaper than it is in every ratio
published since the comparison began.

Against PyMatching 2.4.0 on the corrected divisor, the standing improves without reversing:
the same six of thirty-three operating cells are behind, every margin narrows, the worst falls
from 2.039 to 1.704, and the two closest to flipping are now within three per cent. Exactness
is unchanged at zero weight and zero prediction disagreements on all thirty-three cells.

## Where the six losses spend their time

The six cells where PyMatching 2.4.0 is still ahead are surface `d = 7` at `p = 0.002`,
surface `d = 9` and `d = 11` from `p = 0.001` up, and repetition `d = 25` at `p = 0.002`.
C1065 established that in all of them nearly every shot is above the routing threshold, so
the sparse matcher answers them and the entry cost it removed is already amortized. This
task profiled that search.

`perf record` over 81,920 decodes at level four, so every shot goes to the matcher, on the
control `ergodis-tools-fa21d85`. Self time by symbol on surface `d = 11` at `p = 0.002`,
the worst cell:

| symbol                              | self  |
|-------------------------------------|-------|
| `SparseMatcher::solve`              | 24.8% |
| `SparseMatcher::touch_node`         | 20.3% |
| `SparseArm::certify`                | 13.3% |
| `SparseMatcher::push_event`         | 12.2% |
| `ShotGenerator::draw_events`        | 11.8% |
| `SparseMatcher::common_chain_sum`   |  2.6% |

`draw_events` is the bench's shot generator, not the decoder, and the two-size differencing
that produces every ratio below keeps it in both arms. The one-time `KernelSpec::compile`,
another 4.5% of the profile, differences out entirely.

The same profile counted by last-level cache misses says something the cycle profile does
not: **72.0% of the kernel's misses are in `certify`**, against 5.9% in `solve`, 4.1% in
`touch_node` and 2.0% in `push_event`. The certificate's pair loop reads one closure entry
per defect pair, scattered over a table the graph sizes; at surface `d = 11` that is a
1,320-by-1,320 table and a shot with 44 mean defects reads about 950 entries from it.

The touch loop's own traffic, per answered block at that cell: 52.4 node touches, 628.2
event-time evaluations, 476.3 pushes, 115.7 popped entries of which 86.2 are stale. The
push-to-pop ratio C1066 identified is confirmed and is structural — a solve abandons
whatever is still queued when its last defect is matched.

The other five losing cells put less on the certificate and more on the search: at surface
`d = 9` and `p = 0.002` `certify` is 8.6% and `touch_node` 23.3%; at surface `d = 7` and
repetition `d = 25` the certificate is under 5% and `solve` is 30.8% and 29.9%.

## What changed

Four changes, none of which alters the search. Every one is exact in the strong sense the
census parity sweep below checks: the candidate and the control answer every cell of the
grid with the same logical error rate, the same fast-path census, the same defect and
blossom histograms, the same answered, declined and uncertified counts, and the same
decline counters by cause.

### 1. The certificate reads a saturated `u16` closure

`KernelSpec` had a narrow mirror of the metric closure, filled only when every pair distance
fitted `u16`. Under real weights it never does — a circuit-level surface graph at the shipped
quantization scale has pair distances past 65,535 — so the certificate read the wide `u32`
table, 7.0 MB at surface `d = 11`, and that is where the misses were.

The table is now saturated at `closure_bound_cap`, twice the largest boundary distance, and
is always `u16` when that cap fits. Saturation decides every pair constraint the same way
the true distance does, and the argument is the certificate's own: it rejects a defect whose
dual exceeds twice its own boundary distance before it reads any pair, and it has already
required every blossom's dual to be non-negative, so a region containing two defects
contributes a non-negative shared term. A pair's crossing dual is therefore at most twice
the sum of the two boundary distances, hence at most twice the cap, and a pair whose true
distance is at or above the cap can never be violated. A disconnected pair saturates for the
same reason rather than being clamped to a bound the graph does not hold. The table has
exactly one reader, so the saturation is confined to the place the argument covers; the
closed forms and the cluster decomposition keep reading the exact wide closure.

Measured alone at surface `d = 11` and `p = 0.002`: last-level misses per decode fall from
829 to 600 and cycles from 41,646 to 40,463, with instructions unchanged.

### 2. The pair loop compares outermost regions instead of walking two chains

The pair loop's shared term is the sum of the radii of the regions containing both defects,
computed by `common_chain_sum`, which stamps one defect's ancestor chain and walks the
other's. It ran on every pair whenever any blossom existed, which at these rates is almost
every shot: about 950 chain walks per decode.

Containment chains are nested, so a region holding both defects would be an ancestor of both
and their chains would end at it. `certify` now records each defect's outermost region in the
same pass that hoists its chain sum, and the pair loop walks the chains only when those
agree. One comparison replaces two walks for every pair not inside a common blossom.

### 3. The undo list packs the key beside its kind

C1065's undo lists record every key whose remembered time a solve wrote, so the reset
restores those and no others. The append is on the push path and wrote two arrays — a `u8`
kind and a `u32` key — which is two stores, two length loads and two bounds checks per key
first reached. It is now one `u32` array with the key in the low 29 bits and the kind above
them, with the packing bound asserted against the compiled graph at construction.

### 4. A queue entry carries no time

`Event` was sixteen bytes: a time, a free-list link, a key in two halves, and a kind. Every
queued time lies in `[clock, clock + bucket_count)`, so the bucket a lane was reached through
names the time exactly, and both pop paths already computed it that way and ignored the
stored copy. The record is now eight bytes — the link and the key packed beside its kind, the
same shape as an undo entry — which removes a store from the hottest write in the matcher
and the key's split and reassembly from the push and pop paths.

### 5. The certificate now checks the primal as well as the dual

The independent risk review this task commissioned found that the exactness story the kernel
publishes — every answer proved optimal by linear-programming duality, so a matcher defect
costs a flagged shot and never a wrong answer — was not what `certify` implemented. Weak
duality bounds the optimum below by a feasible dual and above by a feasible primal, and only
the dual half was checked. The pairing was taken on trust from the matcher the certificate
exists to check, and the caller prices an asymmetric pairing as though it were a matching —
each pair once, from its lower index — so a pairing that matched one defect twice and
orphaned another could carry a cost below the true optimum and meet a slack dual there. The
odd-cardinality counts that make each blossom's dual a valid inequality were computed in the
opening pass of `certify` and then discarded unread.

`certify` now requires the pairing to be an involution on the defects with the boundary as
the only other partner; requires a standing blossom to price a set the odd-cut formulation
has a variable for, odd and of at least three defects; and requires a blossom identifier
whose children are gone, which prices no set, to carry no dual at all. A test certifies an
instance, redirects one partner without redirecting the partner's, and requires the refusal.

The last of the three is the one that bit: an expanded or dissolved blossom keeps its
identifier with zero children, and requiring only "odd and at least three" refused 625 of
80,000 optimal answers in the unit-weight suite and 1,133 in the weighted one before the
zero-dual case was separated out.

### 6. A lost touch is counted as the decline it causes

`dissolve` discarded the result of the region touch it owes after stopping a shrink, the only
call site in the matcher that did. A missed event still fails closed — the certificate refuses
the dual it leaves — but the shot was declined under the wrong cause, and the decline census
is the only instrument anyone has for how often the bounded path runs. The result is now
threaded through the three augmentation paths and counted as `reason_schedule`.

## What it costs and buys

The matcher alone, candidate `ergodis-tools-4241dcc` over the control `ergodis-tools-fa21d85`,
three interleaved rounds at level four with two-size differencing, so every shot goes to the
matcher. Below one is a gain. Instructions, on the weighted circuit-level grid's operating
cells (`benchmarks/tiger-blossom/2026-09-05-c1068-4241dcc-weighted-level4-ab.log`):

| graph               | `p = 0.0005` | `p = 0.001` | `p = 0.002` |
|---------------------|--------------|-------------|-------------|
| surface `d = 3`     | 0.995        | 0.990       | 0.986       |
| surface `d = 5`     | 0.980        | 0.976       | 0.972       |
| surface `d = 7`     | 0.950        | 0.944       | 0.935       |
| surface `d = 9`     | 0.943        | 0.937       | 0.911       |
| surface `d = 11`    | 0.940        | 0.928       | 0.868       |
| repetition `d = 9`  | 0.998        | 0.986       | 0.980       |
| repetition `d = 15` | 0.982        | 0.972       | 0.967       |
| repetition `d = 25` | 0.970        | 0.965       | 0.962       |

The gain is largest exactly where the certificate's pair loop is largest, which is a dense
shot on a large graph: 13.2 per cent at surface `d = 11` and `p = 0.002`, where the mean is
44 defects and the pair loop reads about 950 closure entries per decode. Cycles move with the
instructions, 0.86 to 0.99 across the same cells.

The phenomenological grid gains too, without being the target
(`2026-09-05-c1068-4241dcc-phenomenological-level4-ab.log`): 0.999 to 1.001 at `p = 0.001`,
0.989 to 1.000 at `p = 0.01`, and 0.953 to 1.001 at `p = 0.05`. The stress rows are where the
undo list and the queue record are worked hardest, and 4.7 per cent at repetition `d = 25`
returns most of what C1065 cost that grid there.

### The PyMatching standing, restated

Same protocol as C1065 — three interleaved rounds, two-size differencing, PyMatching 2.4.0
built from the same shot files and the same quantized integer weights, the routed arm — over
the thirty-three operating cells
(`2026-09-05-c1068-4241dcc-weighted-vs-pymatching-operating.log`). Ratios are Tiger over
PyMatching, so below one means Tiger is ahead; C1065's figure follows each in parentheses.
**These use the corrected per-decode divisor**, which lowers every ratio by a uniform 2.34 per
cent relative to C1065's convention, so about that much of each movement is the harness repair
and the rest is the kernel.

| family     | d  | `p = 0.0005`  | `p = 0.001`       | `p = 0.002`       |
|------------|----|---------------|-------------------|-------------------|
| surface    | 3  | 0.179 (0.201) | 0.136 (0.152)     | 0.179 (0.170)     |
| surface    | 5  | 0.134 (0.131) | 0.207 (0.217)     | 0.373 (0.389)     |
| surface    | 7  | 0.244 (0.250) | 0.532 (0.558)     | **1.024** (1.100) |
| surface    | 9  | 0.537 (0.571) | **1.072** (1.168) | **1.513** (1.718) |
| surface    | 11 | 0.888 (0.962) | **1.350** (1.511) | **1.704** (2.039) |
| repetition | 3  | 0.463 (0.328) | 0.231 (0.278)     | 0.216 (0.243)     |
| repetition | 5  | 0.162 (0.161) | 0.123 (0.146)     | 0.127 (0.122)     |
| repetition | 7  | 0.115 (0.126) | 0.099 (0.113)     | 0.127 (0.128)     |
| repetition | 9  | 0.102 (0.104) | 0.112 (0.118)     | 0.197 (0.200)     |
| repetition | 15 | 0.093 (0.096) | 0.224 (0.228)     | 0.542 (0.575)     |
| repetition | 25 | 0.235 (0.239) | 0.599 (0.635)     | **1.031** (1.096) |

**The verdict does not move and every margin does.** Tiger is ahead in twenty-seven of the
thirty-three cells and behind in the same six, which are the same six C1064 and C1065 named.
The two closest to flipping are now within three per cent — surface `d = 7` at `p = 0.002` at
1.024 against 1.100, and repetition `d = 25` at `p = 0.002` at 1.031 against 1.096 — and the
worst cell falls from 2.039 to 1.704.

In cycles the standing is better, as it was in C1065: only three cells lose, surface `d = 9`
at `p = 0.002` (1.051, was 1.121) and surface `d = 11` at `p = 0.001` and `p = 0.002` (1.019
and 1.116, were 1.134 and 1.284). The two that lose in instructions but win in cycles are
surface `d = 7` at `p = 0.002` and repetition `d = 25` at `p = 0.002`.

The account of why those cells lose is unchanged: at 22 to 44 mean defects nearly every shot
is above the routing threshold, the kernel is running sparse region growth on a genuinely
weighted graph, and that is the regime PyMatching 2's sparse blossom implementation was built
for.

## Rejected along the way

### Gathering a node's candidates before pushing any of them

`touch_node` pushes as it scans, so every incident slot contains a `&mut self` call and the
compiler reloads the incident, node and rate base pointers and lengths from the matcher
afterwards: about twelve instructions of redundant addressing and bounds checking per edge,
which at 628 evaluations per decode is five per cent of the whole thing at surface `d = 11`.
The obvious repair is to gather the node's tight times under a shared borrow into a fixed
inline array, so the slices resolve once, and then drain the array.

It loses. Per-chunk array: 154,196 instructions per decode against the control's 150,608
(1.024), and cycles 1.027 to 1.037. Hoisting the array out of the chunk loop and inlining the
gather made it worse still, 155,865 (1.035). The buffer's round trip — a store per candidate
and a re-read with its own bounds check — costs more than the reloads it removes, and at an
IPC of 3.5 the reloads are nearly free in cycles.

The lasting repair for the aliasing would be to split the queue into its own struct so the
scan can hold a shared borrow of the graph arrays and a mutable borrow of the queue at the
same time. That is a large mechanical refactor of every push site and is recorded as
available rather than done.

### Skipping a push when an earlier entry is already armed

The scheduling invariant the debug oracle checks is that a live event's key remembers a
queued entry *at or before* its true time, not one exactly at it: every handler revalidates
what it pops, so an entry that turns out to be early is re-armed there. `push_keyed` was
stricter than that — it skipped only an entry at exactly the same time — so a key whose
armed entry was already earlier could have skipped its second entry entirely.

It is exact and it barely fires: 2.9% fewer pushes (9,751,532 to 9,469,273 over 20,474
blocks at surface `d = 11` and `p = 0.002`) and 1.8% fewer popped entries, worth under 0.3%
in instructions. The reason is worth keeping: region growth makes a collision *earlier*, not
later, so the case the skip covers is the rare direction.

It was rejected because it is the only one of the five candidate changes that alters the
search, and it does alter it: with the skip in, thirteen weighted surface cells moved their
`reason_expand` decline counts in both directions and the logical error rate moved by up to
5e-5 at the stress rates. Trading exact census parity for 0.3% is a bad trade; the four
changes kept are search-invariant and the parity sweep proves it.

## The measurement harness, repaired

The risk review found two defects in the harness that produces every published comparison,
and both are fixed here.

**The PyMatching arm's per-decode divisor did not match the decodes it performed.** That arm
decodes whole shot files: `operations // window * window`, with 20,000 shots per file. The
driver asked it for 81,920 and 819,200 operations, so it performed 80,000 and 800,000
decodes, and then the two-size difference was divided by 737,280 rather than by 720,000. The
arm was credited with being 2.34 per cent cheaper per decode than it is, in every ratio
published since the comparison began. The direction runs against Tiger, so every earlier loss
margin was that much pessimistic and every win that much understated. The sizes are now whole
files, and the baseline script refuses a count that is not one.

**Two ladder headers still called level four the production arm.** C1063 made the routed arm,
level five, the default. The `stack` and `ladder` modes baseline every ratio on level four,
which is right for comparability with earlier probes, but printed it as "production": at
surface `d = 11` and `p = 0.0005` level four costs 1.97 times the arm the header named. The
headers now say which arm they are.

One further asymmetry is recorded and **not** changed, because changing it would move the
standing rather than correct it. The two arms replay different working sets: Tiger replays a
fixed window of 4,096 shots as packed bit words, comfortably resident, while PyMatching cycles
all 20,000 as a dense byte array — 14.4 MB at surface `d = 11` under the circuit-level model.
That runs in Tiger's favour and it is a property of the harness, not of the decoders. Sizing
PyMatching's window at 4,096 would cut its resident set fivefold. The instruction ratios the
reports lead with are insensitive to it; the cycle ratios are not. Owner: Tavis's call, since
it restates the grid.

## Gates

The debug random suite with the no-late-entry oracle and the `I1`/`I2` feasibility assertion
after every event, including the weighted case C1065 added; the release kernel tests including
the zero-allocation `decode_batch` gate; library clippy `-D warnings` over all targets and
`rustfmt`; and PyMatching 2.4.0 weight and prediction agreement on all thirty-three operating
cells at 20,000 freshly emitted shots each — zero weight disagreements and zero prediction
disagreements
(`benchmarks/tiger-blossom/2026-09-05-c1068-4241dcc-weighted-pymatching-exactness.txt`).

Two new tests are permanent ratchets. One certifies an instance, redirects a single partner
without redirecting the partner's, and requires the certificate to refuse — the check that
finding one of the risk review says was missing. The other runs both closure readers over the
same solves, the saturated table against a specification whose saturated table has been
emptied, and requires the verdicts to agree on a correct primal and on a wrong one.

**The exactness statement for the performance changes is census parity.** A new script,
`scripts/tiger_blossom_census_parity.py`, runs a candidate and a retained control over the
whole measured grid — eighteen phenomenological cells and fifty-five weighted ones, each at the
sparse arm and at the routed arm, 146 combinations — and compares the logical error rate, the
mean defect count, the overflowed-shot count, the fast-path census, the defect and blossom
histograms, the sparse answered, needs-blossom, exhausted and uncertified counts, and every
decline counter by cause. Every build in this task matched the control on every one. Traffic
counters are reported but deliberately not required to match, so that a change which alters
which entries the queue arms is not mistaken for one that does not.

Provenance: the retained binaries were built from a clean working tree at the commits they
name. The corrected-divisor PyMatching run that this report does *not* cite
(`2026-09-05-c1068-7212d6f-weighted-vs-pymatching-operating-corrected.log`) was taken while
builds and tests were running on the same host; its Tiger cycle counts carry an 18 to 21 per
cent round-to-round spread against 1 per cent in the clean runs, and it is retained as the
contended measurement it is rather than used.

## Mystery ledger

**Settled: where the six losing cells spend their time.** Not the entry cost, which C1065
removed, and not primarily the touch loop, which the profile ranks second: the certificate's
pair loop carried 72 per cent of the kernel's last-level cache misses and, with a blossom in
play, two ancestor-chain walks per defect pair. The lever named at the end of C1065, C1066 and
C1067 was half right — the closure reads were the larger half, and the touch loop resisted the
obvious repair.

**Settled: whether the certificate proves what it says.** It did not, and now it does. The
missing half was primal feasibility; the risk review named it, and the check costs `O(count)`
against a pair loop that is `O(count²)`.

**Settled: whether the blossom odd-cardinality condition matters in practice.** `contract`
refuses an even cycle before allocating, so blossoms are odd by construction and the unchecked
condition was defence in depth rather than a live miscompute. Adding the check found something
adjacent instead: an expanded or dissolved blossom keeps its identifier with no children, and
requiring every blossom identifier to price an odd set of at least three defects refused 625
of 80,000 optimal answers before that case was separated out and required to carry no dual.

**Open: the touch loop's redundant addressing.** About twelve instructions per incident edge
are re-derived after every push, because the push takes the matcher mutably and the scan reads
the graph arrays through the same borrow. That is five per cent of the decode at surface
`d = 11`. Gathering into a buffer loses; the repair that would work is splitting the queue into
its own struct so the scan can hold both borrows at once, which touches every push site.
Evidence gap: none — the mechanism is measured and the fix is understood, it is the size of the
refactor that is unpaid.

**Open: the harness's working-set asymmetry.** Tiger replays 4,096 shots as packed bit words
and PyMatching cycles 20,000 as a dense byte array, 14.4 MB at surface `d = 11`. The
instruction ratios are insensitive; the cycle ratios are not, and the asymmetry runs in Tiger's
favour. Sizing PyMatching's window at 4,096 would settle it and would restate the cycle column
of the grid. Owner: Tavis, because it is a boundary decision rather than a defect.

**Open, unchanged from C1064 and C1065: the third code family** for the mean-degree crossover
rule. Nothing here touches it; the routing thresholds are the C1065 constants.

**Open: the certified path is a minority of decodes.** The risk review's eighth finding: at the
phenomenological operating point about 99 per cent of decodes are answered by the closed forms
or the subset dynamic program and never reach the certificate at all, and the certificate
cannot check the compiled closure it shares with the caller. PyMatching agreement on a million
shots is the backstop and it is in place, but it is an empirical sample against a claim that
reads as a guarantee. Owner: a successor that either widens the certificate or narrows the
wording.

## Vibe check

Good, and the useful part is that the task found its own premise half wrong. Three predecessors
in a row ended by naming the touch loop and the certificate's closure reads as the lever; the
closure reads were real and the touch loop resisted, and the profile said so in ten minutes
where three reports had said it from inference. The larger result is not the 13 per cent: it is
that commissioning a hostile read of two days of work turned up a certificate that was checking
half of what it claimed and a benchmark divisor that was wrong in every published ratio, and
both were an hour's work to close once named.

## Next

1. The queue-struct borrow split, which is the only remaining lever on the touch loop and the
   one this task could not buy cheaply.
2. The same certificate read for the predecoder path, which the risk review explicitly did not
   cover and which has the same shape of claim.
3. Re-running probe 28h's margin-radius grid on the repaired rotated-surface builder. Its
   surface rows are now marked superseded at their own site, but nobody has replaced them.
4. The third code family for the mean-degree crossover rule, unchanged from C1064 and C1065.

## Also repaired

The evidence manifest `benchmarks/tiger-blossom/SHA256SUMS` had no entry for fifteen of the
files in its directory — all ten from C1064, three probe-28b logs, and two from C1065 — so
every load-bearing number in the whole weighted circuit-level task lacked the compact
certificate the reproducibility conventions require. C1067's repair had normalized the paths of
the entries that existed without checking that every evidence file had one. All eighty-two now
verify from the evidence directory.

Probe 28h's surface rows carry a dated superseded-by note pointing at C1063's builder repair.
They were the one place a cold reader could still take an invalidated surface number as
current.
