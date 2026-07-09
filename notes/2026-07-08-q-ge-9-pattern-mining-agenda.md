# q>=9 pattern-mining agenda

Date: 2026-07-08.

This note is a sweep of the current projective-plane notes for regions and patterns worth mining
next.  It is deliberately selective: the goal is to identify high-yield structure for the odd
`PG(2,q)` proof program, not to restart every diagnostic that has already failed.

## Current Read

The strongest surviving picture is dynamic:

```text
on-conic S4 root
-> first-intrusion / conic-child layer
-> repair or steering reply
-> small-Z or clean empty-conic endgame
```

Static labels such as `defxor`, zone parity, zone Grundy, shallow cross-ratio features, mod-3
columns, and simple mirror availability all failed as global classifiers.  They remain useful
features to log, but the proof route should mine the existence and geometry of repairs.

The q>=9 data split is:

- `q=9`: rigid terminal-reply kernel; all on-conic S4 roots are P.
- `q=11`: first genuinely mixed on-conic layer; useful as a small regression column.
- `q=13`: all on-conic buckets P; recursive steering collapses to `Z <= 2`.
- `q=17`: adversarial mixed column; min escape is only 5; worst repair stratum has two PGL orbits.
- `q=19`: all on-conic buckets P again; first intrusions are losing, but steering ceiling grows to 16.
- `q=23`: bucket-first on-conic census found all 22 buckets P; size-3-rooted escape is too large in the old route.
- `q=25`: first prime-power stress case; one ad hoc S4 root is P, but the first full-PGL canonical bucket exceeds the 100M memo cap.

## Have We Done Ply-Depth Structure?

Only partially.

Done:

- q=9 has an exact residual-depth statement: after a legal first intruder, there is exactly one
  legal reply and it is terminal; max residual depth is 1.
- The repair/steering runs measure a recursive ceiling `Z`, child `Z`, immediate zone size, and
  selected score.  This is a depth proxy, not a full ply census.
- The winline visualization note contains sample lines with features after plies 2, 4, 6, 8, but
  those are exemplars, not a systematic distribution.
- The S4 query shell reports `STATE ply=...`, legal count, child values, and replies for selected
  states.
- `s4mine` now emits non-interactive root-child rows, optional root-reply rows, and deduplicated
  ply summaries from a raw or compact S4 dump.
- `rust/scripts/s4_ml_mine.py` parses the current S4 mining logs into feature TSVs, PCA/tree
  reports, joint geometry summaries, and a conic-depletion bound report.  It handles both `s4mine`
  rows and targeted `s4xormine` `XORTRY` rows, with a filtered `xortry-zone-features.tsv` table for
  rows that actually contain `zone_*` fields.  Its outputs are exploratory invariant-discovery aids,
  not proof certificates.

Not done:

- no cross-q run of the new `s4mine` ply summaries;
- no cross-q table of value/feature transitions at each even P-reply ply;
- no census of terminal distance, legal-count decay, live-conic count, or guard availability by
  ply;
- no q>=17 comparison of "repair depth" versus "ordinary game depth."

This is worth adding.  The next batch miner should group states by ply and emit:

```text
q, bucket/root, ply, value, known/unknown in dump,
legal count, on/ext/int legal counts,
live conic count,
defect spectrum, defxor,
zone size, zone edges, zone Grundy,
#winning moves, #P replies,
best repair score, childZ,
terminal distance if cheaply known
```

For partial q=25 dumps, the same report should include known/unknown counts so we do not mistake
memo coverage for game structure.

## New Proof Target: Two-Ply Conic Depletion

The S4 ML/joint-summary pass surfaced a simple incidence-count law that is worth proving directly.
For a normalized S4 root on the affine conic `r*c = 1`, the mined root-reply rows for
`q = 9, 11, 13, 17, 19, 23, 25` all satisfy:

```text
two off-conic moves:      live_on >= max(0, q - 19)
one off + one on-conic:   live_on >= max(0, q - 13)
two on-conic moves:       live_on =  q - 7
```

The generated check is `rust/s4-dumps/2026-07-08/ml/conic-bound-report.txt`; it currently has
54 geometry groups and zero failures.

Semi-formal proof note:
[`2026-07-08-s4-two-ply-conic-depletion.md`](2026-07-08-s4-two-ply-conic-depletion.md).
Follow-up large-q steering plan:
[`2026-07-09-live-conic-steering-plan.md`](2026-07-09-live-conic-steering-plan.md).
First best-reply mining pass:
[`2026-07-09-live-conic-bestreply-mining.md`](2026-07-09-live-conic-bestreply-mining.md).
That pass now includes q=23 targeted zero-xor steering: all 22 q=23 S4 bucket representatives have
a P reply with live-conic Node-Kayles xor 0 for every first move.

This is proof-shaped, not just statistical.  At the S4 root there are `q - 5` live affine-conic
cells.  A first off-conic move can kill at most six of them: its row, its column, and at most one
new conic point on each line through the four selected conic points.  A second off-conic move can
kill at most eight more: row, column, four lines through the original conic points, and at most two
conic points on the line through the first off-conic move.  An on-conic move selects one live conic
cell and, when paired with an off-conic move, can kill at most one further conic cell on that secant.

Immediate implications:

- q=17 and q=19 are exactly the boundary where two off-conic moves can empty the live affine conic.
- For q>=23, an S4 root reply cannot empty the live conic; the large-q route must use
  positive-live-conic steering rather than a clean empty-conic base case at this layer.
- The q=17/q=19 empty-conic repair strata should be treated as boundary/small-q layers, not as the
  expected bulk mechanism.

Lean/proof target:

```text
S4 two-ply conic depletion lemma:
  after a legal two-move extension of a normalized S4 root,
  live_on is bounded below by max(0, q-19), max(0, q-13), or q-7
  according to whether the two new moves are off/off, off/on, or on/on.
```

## Priority Mining Regions

### 1. q=17 score-9 repair stratum

This is the highest-value finite target.

Known facts:

- 28 score-9 transitions.
- 14 starting states collapse to 2 `PGL(2,17)` orbits, even after including the guard and the two
  worst opponent moves.
- every selected score-9 reply is intruder -> intruder;
- every selected reply empties the conic residual;
- every selected reply has `defxor = 0` and zone Grundy 0;
- the useful guard is an already-legal internal intruder that kills the last live conic parameter;
- polarity guesses all failed.

Next checks:

- write the two-orbit score-9 certificate table as a durable, directly checkable dataset;
- log the guard rule in sigma language: `u = sigma_r(s)` for an already played conic parameter
  `s`;
- check whether the two representatives have a common small-zone proof leaf after the guard;
- keep this as a finite certificate layer if no clean uniform identity appears.

Do not spend more time on the false one-sentence polarity explanation.

### 2. One-pair descent by score band at q=13,17,19

Known facts:

- `q=13`: every tested repair lands with child `Z = 0`; max steering ceiling is 2.
- `q=17`: every tested opponent move from the P reply-state regime has a winning reply whose
  grandchild has `Z <= 2`; high selected scores are immediate-zone costs.
- `q=19`: all on-conic buckets are P; every legal first intrusion from bucket representatives is
  losing; max recursive steering ceiling is 16.

Next checks:

- rerun the repair miner on q=19, not just the steering miner;
- stratify by selected score and by live-conic count before/after reply;
- separate "clean empty-conic" from "empty conic but nonzero zone Grundy";
- test whether score-7/8 repair exceptions share a small finite family like the score-9 layer.

Target statement:

```text
From the P reply-state regime, every opponent move has a repair reply whose grandchild is either
small-Z or belongs to a finite clean empty-conic certificate family.
```

### 3. q=23 bucket-level root and reply mining

q=23 is the best large-prime all-P check currently available.  The old size-3-rooted escape route
hit the 200M private-memo cap, so use bucket-first S4 roots and the dump/query tooling.

Next checks:

- for each of the 22 full-PGL S4 buckets, dump enough solved memo to classify root children;
- aggregate first moves by `on/ext/int` and known value;
- for any known P-valued child from a first intrusion, mine replies and compare with q=17 guards;
- record whether q=23 has any high-score-like repair strata or whether it behaves like q=19.

This is a better use of compute than another blind full `esc 23` campaign.

### 4. q=25 partial-dump mining and GF-specific effects

q=25 is important because it is the first larger odd prime power in the current range.

Known facts:

- ad hoc root `[1,2,3,4]` solves P at about 26.3M memo entries;
- first full-PGL canonical bucket representative `[1,2,3,5]` exceeds the 100M memo cap;
- current Python feature miners are prime-field only.

Next checks:

- use capped raw dumps for `[1,2,3,5]` and query known root children/replies;
- do not infer value from unknown children in partial dumps;
- extend the Rust miner with the same feature rows as the Python prime-field miner;
- add trace/norm/Frobenius orbit labels only after the core geometry rows are stable.

The immediate goal is not a full q=25 census.  It is to learn whether the hard prime-power bucket
resembles q=17 mixed behavior, q=19 all-P behavior, or a new extension-field regime.

### 5. q=9 and q=11 as proof/regression columns

q=9 should be used to finish a clean Lean kernel or certificate:

- only `(tau_x,tau_played) = (2,2)` intruders occur;
- every intrusion kills the conic;
- every intruded child has one terminal reply.

q=11 is useful as the smallest mixed on-conic prime:

- keep it in feature-regression tests;
- use it to check that any proposed repair or ply-depth statistic does not merely fit all-P
  columns;
- do not overfit the old q=11 small-zone snapshot laws, which already failed at q=13 and q=17.

## Patterns To Log In Every New Batch

For q>=9, the batch output should include:

- full-PGL six-set bucket representative and orbit size;
- root value and child values by geometry class `on/ext/int`;
- legal intruder tangency type and played-tangency count;
- sigma kill set on the conic and live-conic count;
- defect spectrum, defxor, zone size, zone edges, zone Grundy;
- repair move kind, selected score, immediate zone, childZ;
- whether a reply is internal and conic-emptying;
- whether the same guard answers multiple worst opponent moves;
- ply and terminal-distance proxies.

This gives one shared table for q=9,11,13,17,19,23,25 instead of separate one-off diagnostics.

## Deprioritized

Do not lead with these unless a new table gives a reason:

- pure residue-class laws;
- area/counting bounds on bad extensions;
- odd-maximal-arc embedding as a value classifier;
- empty-conic implies zone Grundy 0;
- polarity as the score-9 guard explanation;
- single fixed-involution or `MirrorStepGood` at the size-4 escape layer;
- broad q=25 full-bucket sweeps before capped dump/query evidence says which bucket family is
  worth the memory.

## Concrete Tooling Follow-Up

The existing S4 dump/query tooling is enough for interactive checks.  `s4mine` now provides a
first non-interactive batch mode over one root and emits tagged text rows for:

```text
root-child rows
reply rows for selected root moves
state rows by ply, optionally expanded with --state-rows
deduplicated ply summaries
```

Remaining feature extensions:

- defect/zone interaction with live-conic counts;
- defect spectrum / defxor / zone Grundy rows;
- best-repair rows if the full value is known;
- CSV/JSONL output once the tagged text fields settle.

Implemented 2026-07-08:

- `ROOTMOVE`, `REPLY`, and `STATE` rows include `sel_on`, `live_on`, and `dead_on` for the
  normalized conic `r*c = 1`;
- `PLY` rows aggregate those conic fields as min/max/average;
- `REPLYSUM` includes `live_on_zero`, which directly flags root replies that empty the live conic.
- large query cache documented in `2026-07-08-s4-large-dump-cache.md`: all q=19 exact bucket
  dumps, two exact q=23 roots, and two larger q=25 partial dumps.

First live-conic observation, q=17 root `[1,2,3,4]`:

- `PLY` depth 2 from the S4 root has 20 canonical states with `live_on=0`: 1 known `P`, 7 known
  `N`, and 12 unknown in the current early-break dump;
- all 20 have `sel_on=4` and `dead_on=12`, so this stratum empties the conic without selecting an
  additional conic point;
- across all 6,284 root-reply rows there are 40 conic-emptying replies, spread across 26 first
  moves;
- conic-emptying replies are never on-conic in this root: zero-reply breakdown is `P/int=2`,
  `N/ext=7`, `N/int=7`, `unknown/ext=9`, `unknown/int=15`;
- the two known `P` zero-conic replies are the internal pair
  `x=(6,11), y=(8,5)` and `x=(8,5), y=(6,11)`.

Implementation constraints:

- compute each canonical child key once per state;
- report unknowns explicitly for partial dumps;
- keep raw dumps as the exact source of truth for certificate-adjacent claims;
- use compact archives only for exploratory scanning, then confirm surprises against raw or direct
  solve.
