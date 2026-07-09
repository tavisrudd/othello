# Live-Conic Best-Reply Mining

Date: 2026-07-09.

## Tooling Added

`s4mine` now has a value-aware best-reply mode:

```bash
target/gridcap-bestreply s4mine <q> <t1,t2,t3,t4> --raw <dump.raw> \
  --depth 0 --best-replies --max-best-replies 1
```

It emits:

- `BESTREPLYSUM`: reply-value coverage for each first move;
- `BESTREPLY`: known P-valued reply witnesses, sorted by smallest known `live_on`;
- live-conic occupancy fields `sel_on`, `live_on`, `dead_on`;
- live-conic residual graph fields induced by selected off-conic intruders.

The graph vertices are currently the live affine conic parameters.  Two vertices are adjacent when
one selected off-conic point lies on their chord.  Thus the graph is the conic-restricted
Node-Kayles obstruction graph visible from the current residual position.

Important caveat: these are best known replies in the dump, not globally optimal replies.  Exact
early-break dumps usually contain at least one P witness for each N child, but not all replies.
Capped partial dumps report unknowns honestly.

## Inputs

Generated logs under `rust/s4-dumps/2026-07-09/`:

- all 13 exact q=19 S4 bucket dumps from `rust/s4-dumps/2026-07-08/`;
- two exact q=23 sample dumps:
  - `1,2,3,4`;
  - `1,2,5,6`;
- two capped partial q=25 dumps:
  - `1,2,3,5`, cap 20M;
  - `1,2,3,4`, cap 5M.

## q=19 Exact Bucket Column

Across all 13 q=19 buckets:

```text
root first moves:              1929
known P best replies:          1929
first moves with no P witness: 0

root child values:
  ext/N 980
  int/N 767
  on/N  182

best witness live_on distribution:
  1:2 2:26 3:188 4:350 5:525 6:457 7:208 8:172 10:1

best witness xgeom/ygeom:
  ext->ext 854
  int->ext 766
  on ->ext 182
  ext->int 120
  ext->on  6
  int->int 1
```

Conic residual graph summary:

```text
conic_other = 0 for all 1929 witnesses
conic_off   = 1 for 188 witnesses, 2 for 1741 witnesses
conic_cycle = 1 for 10 witnesses, 0 otherwise
conic_degmax <= 2 throughout

conic_nk_xor distribution:
  0:721 1:486 2:418 3:304
conic_nk_cycle_xor = 0 throughout
observed cycle sizes:
  4, 6, 10
```

So the known q=19 witness layer is entirely path/cycle/isolate structure on the live conic.

## q=23 Exact Sample Column

Across the two exact q=23 sample roots:

```text
root first moves:              521
known P best replies:          521
first moves with no P witness: 0

root child values:
  ext/N 269
  int/N 216
  on/N   36

best witness live_on distribution:
  6:29 7:64 8:109 9:162 10:94 11:27 12:36

best witness xgeom/ygeom:
  ext->ext 251
  int->ext 214
  on ->ext 36
  ext->int 18
  int->int 2
```

Conic residual graph summary:

```text
conic_other = 0 for all 521 witnesses
conic_off   = 1 for 36 witnesses, 2 for 485 witnesses
conic_cycle = 1 for 25 witnesses, 0 otherwise
conic_degmax <= 2 throughout

conic_nk_xor distribution:
  0:191 1:121 2:96 3:113
conic_nk_cycle_xor = 0 throughout
observed cycle sizes:
  4, 6, 8
```

This is the first concrete q>=23 positive-live steering signal: every first move in both exact
sample roots has a known P reply, and those replies leave `live_on` between 6 and 12 rather than
emptying the conic.

## q=25 Partial Column

The q=25 dumps are capped and should be treated as shape-only evidence.

```text
known P best replies: 92
unknown first moves remain numerous

known best witness live_on distribution:
  9:5 10:34 11:9 12:16 13:27 14:1
```

Among known q=25 witnesses:

```text
conic_other = 0
conic_degmax <= 2
conic_nk_xor distribution:
  0:35 1:48 2:1 3:8
conic_nk_cycle_xor = 0 throughout
observed cycle sizes:
  4,4
```

This is compatible with the q=19/q=23 path/cycle/isolate picture, but it is not a value-coverage
result.

## Semi-Formal Graph Lemma

The path/cycle/isolate result should not need a finite certificate.

Fix an off-conic point `u`.  For a conic point `a`, the line `ua` meets the conic in `a` and at
most one other point `sigma_u(a)`.  If the line is tangent, this is a fixed/tangent case rather
than an edge between two distinct live conic vertices.  Thus `u` induces a partial matching on the
live conic parameters.

At the S4 first-reply layer there are at most two selected off-conic intruders, so the live conic
graph induced by all selected off-conic points is a union of at most two matchings.  Hence every
live conic vertex has degree at most 2, and every component is a path, a cycle, or an isolated
vertex.

This explains `conic_other = 0` and `conic_degmax <= 2` uniformly.  It does not by itself prove the
observed cycle-Grundy cancellation; that requires controlling which cycle lengths occur, or proving
they can be ignored/paired in the full residual game.

## Targeted Zero-Xor Steering

The dump-only `BESTREPLY` rows sort known P replies by smallest `live_on`, so they do not answer
whether conic xor zero can be selected.  A new `s4xormine` mode tries replies whose live-conic graph
has a requested Node-Kayles xor and solves those candidates on demand with the S4-local solver.

Command shape:

```bash
target/gridcap-bestreply s4xormine <q> <t1,t2,t3,t4> \
  --target-xor 0 --cap 50000000 --max-tries 10
```

q=23 exact sample results:

```text
root 1,2,3,4:
  first moves: 260
  zero-xor P hits: 260
  no candidates: 0
  max target-xor candidates tried before hit: 3
  memo entries: 21,645,006
  hit live_on distribution:
    4:68 5:120 6:52 7:2 10:18

bucket 1,2,5,6:
  first moves: 261
  zero-xor P hits: 261
  no candidates: 0
  max target-xor candidates tried before hit: 4
  memo entries: 22,135,889
  hit live_on distribution:
    4:38 5:132 6:68 7:5 10:18
```

This is much stronger than the first dump-only pass.  For both exact q=23 samples, every first move
has a P-valued reply whose live-conic Node-Kayles xor is already 0.  The replies are still
positive-live, with `live_on >= 4`, matching the two-ply depletion lower bound rather than
empty-conic repair.

Full q=23 bucket sweep:

```text
bucket representatives: 22
first moves tested: 5734
zero-xor P hits: 5734
no candidates: 0
no hits: 0
aborts: 0
maximum target-xor candidates tried before hit: 4

candidate solve values:
  P: 5734
  N: 703

hit live_on distribution:
  4:1049
  5:2613
  6:1637
  7:39
  10:396

hit geometry:
  ext -> int: 2188
  int -> int: 1760
  ext -> ext: 716
  int -> ext: 674
  on  -> ext: 396
```

This turns the q=23 layer into a concrete candidate theorem:

```text
For every full-PGL on-conic S4 bucket at q=23 and every legal first move,
there is a reply whose whole follower is P and whose live-conic
Node-Kayles xor is 0.
```

The striking extra regularity is that the witness always appears among the first four zero-xor
candidates when sorted by `live_on` and geometry rank.

## Import

This pass supports a sharper q>=23 proof target:

```text
positive-live S4 reply
-> at the first response layer, the live conic graph has at most two intruder
   matchings, hence paths/cycles/isolates
-> choose a first reply with live-conic Node-Kayles xor 0
-> search for a recursive Good predicate over later bounded-degree
   matching-union graphs, not over Dawson/path-cycle XOR alone.
```

This is a maintenance target, not a disjunctive-sum decomposition.  An off-conic zone move is
itself a conic intruder: it adds another partial matching to the live-conic graph and deletes conic
vertices through its chords.  Therefore there is no game split of the form
`conic_xor xor zone_value`, and `conic_xor = 0` is not an invariant unless P2 can keep re-zeroing
it after P1's coupled moves.  The observed component-size spectra are varied already at q=23, so
the next theorem should use all-move closure of a `Good` predicate over matching-union signatures
rather than enumerate a short list of graph shapes.  Path/cycle/Dawson features are valid for the
two-intruder first-response layer; after further intruders, degree three and degree four conic
graphs already occur.

## Off-Conic Zone Probe

I added `zone_*` fields to `s4xormine` `XORTRY` rows.  The zone is the legal off-conic move set
after a candidate reply; two zone vertices are adjacent when playing one immediately kills the
other.  Exact `zone_nk_xor` is emitted only when the component structure is small enough to certify
locally; otherwise `zone_nk_known=0`.

First q=23 root sample:

```text
target/gridcap-bestreply s4xormine 23 1,2,3,4 \
  --target-xor 0 --max-tries 1 --cap 50000000
```

Result:

```text
XORTRY rows: 260
values: P=242, N=18
zone_comp: always 1
zone_other: always 1
zone_v range: 100..117
zone_e common range: about 2,200..2,850
zone_degmax range: 47..57
zone_nk_known: always 0
```

So the off-conic zone after zero-xor candidates is already one large dense component at q=23.  A
direct exact Node-Kayles-zone lemma is not the next easy layer.  The useful next question is whether
this dense component has a low-dimensional geometric description that supports re-zeroing the live
conic after future off-conic intrusions.  A raw zone pairing/matching target is the wrong object:
the zone does not decouple from the conic, and a static pairing strategy is the kind of mirror
certificate C28 already failed to find one layer up.

I also extended `rust/scripts/s4_ml_mine.py` to parse `XORTRY` rows and to keep a filtered
`xortry-zone-features.tsv` table for rows with real `zone_*` fields.  On the same q=23 root
`max-tries=1` sample:

```text
xortry_zone_rows: 260
zone-only PCA: PC1 is almost entirely zone size/edge density; PC2 is zone_odd; PC3 is zone_degmax
zone-only forest for N/P: strongest fields are zone_e, zone_v/zone_max, zone_degmax, zone_odd
zone_odd=0: 144 P, 4 N
zone_odd=1: 98 P, 14 N
```

This is signal, but not a theorem candidate by itself.  It suggests a parity/density residue inside
the dense off-conic zone, while confirming that coarse zone statistics do not explain the P-valued
zero-xor witness selection cleanly.

I then added row/column support and degree-density fields (`zone_rows`, `zone_cols`,
`zone_density_milli`, row/column min/max/odd counts, `zone_degmin`, `zone_degavg_milli`) and reran
the same q=23 root sample.  The main structural fact:

```text
zone_rows = zone_cols = 17 for all 260 candidates
```

This is exactly the number of unused rows/columns after the six selected grid cells.  So in this
sample, the line constraints carve a dense conflict graph but do not remove any entire unused row or
column from the off-conic zone.  This points to a move-availability use of the reservoir: after
zero-xor steering, prove that the off-conic legal zone still projects onto all unused rows and
columns, so P2 has fresh intruder material for re-steering.  It does not by itself point to a Hall
or matching certificate.  The counting lower bound below gives per-row degree `q - 22`, while a
balanced bipartite perfect-matching lever would need `q - 22 >= (q - 6)/2`, i.e. `q >= 38`, so it
does not cover q=23/25/29/31/37.

The q=23 first-candidate value signal remains shallow:

```text
zone_density_milli range: 412..426
N average density: 423.3
P average density: 421.0
zone_density_milli >= 424 is N-heavy in this sample, but not decisive
```

Rerunning the q=23 root with `--max-tries 10` and the expanded zone fields gives the selected
zero-xor witnesses rather than just the first zero-xor candidate:

```text
XORTRY rows: 281
candidate values: P=260, N=21
hits: 260 / 260
tries before hit: 1:242, 2:15, 3:3

selected P witnesses:
  zone_rows = zone_cols = 17 always
  zone_v range: 100..117
  zone_density_milli range: 412..424
  zone_odd: 153 even-size zones, 107 odd-size zones

pre-hit N candidates:
  all are off-conic first moves, almost all have internal replies
  zone_density_milli range: 420..426
  zone_density_milli 425/426 occurs only among N candidates in this run
  zone_odd=1 for 17/21 N candidates
```

Thus one concrete steering heuristic for q=23 root is:

```text
among zero-xor candidates, avoid the over-dense off-conic zones;
the first P witness appears within three candidates.
```

This does not yet explain why the P witness is P, but it gives a sharper next mining question:
which geometric features of the full-row/full-column reservoir make a re-zeroing move available
after the next coupled off-conic intrusion.

Full q=23 bucket sweep with the expanded zone fields:

```text
bucket representatives: 22
first moves tested: 5734
selected P witnesses: 5734
candidate tries: 6437 = 5734 P + 703 N
tries before hit: 1:5146, 2:490, 3:81, 4:17

selected P witnesses:
  zone_rows = zone_cols = 17 always
  zone_comp = zone_other = 1 always
  zone_nk_known = 0 always
  zone_v range: 100..120, avg 111.06
  zone_density_milli range: 412..429, avg 421.17
  zone_degmin range: 30..44
  zone_degmax range: 47..61
  zone_odd: 3025 even-size zones, 2709 odd-size zones
```

So the robust all-bucket fact is the reservoir support, not the root-only density cutoff.  The root
sample had no selected P witness above density 424, but other buckets do.  The all-bucket ML/tree
summaries put most coarse zone signal in `zone_e`, `zone_degavg_milli`, `zone_density_milli`, and
the zone size fields, with only modest predictive power.  The proof-relevant takeaway remains:

```text
after zero-xor steering, the off-conic zone is one large dense component
that still projects onto every unused row and every unused column.
```

This is a better theorem target than direct full-zone Grundy computation or a fixed density
threshold, but it is still only a base-layer availability statement.  It should not be read as
evidence for a zone matching theorem.

There is a plausible sharper route beyond this coarse reservoir layer.  The conic stabilizer acts
as `PGL(2,q)`, and Hollmann--Xiang's association schemes for the action fixing a nonsingular conic
describe the relevant orbitals by cross-ratio.  The test is whether candidate replies can be
classified by conic-stabilizer orbital relation so that intersection numbers count how many replies
land back in the candidate `Good` relation.

The best first test set is not a generic row sample but the q=23 failed closure data below: the
2,455 failed zero-xor P followers and the 8,098 no-hit maintenance obligations are exactly the
counterexamples a useful response-relation count should explain.  If the association-scheme counts
separate the accepted followers from these failures, they may become a proof candidate; if not, the
generic `q - 22` reservoir bound remains only a weak base-layer availability lemma.

There is also a simple incidence proof of the row/column reservoir fact, independent of the mined
zero-xor witness choice.  In general, let `S` be any legal `k`-cell grid position in the normalized
residual model, and let `R` be an unused row.  A candidate off-conic cell in `R` can be killed only
by:

- one of the `k` selected columns;
- one of the `binom(k,2)` affine lines through pairs of selected cells, each meeting `R` in at
  most one point because no pair lies in row `R`;
- the one root-conic cell in `R`, if it exists, because the zone excludes on-conic cells.

Thus every unused row contains at least

```text
q - k - binom(k,2) - 1
```

legal off-conic cells.  The same argument applies to unused columns.  For the six-cell S4-reply
layer this becomes `q - 6 - 15 - 1 = q - 22`, so for every `q >= 23` and every legal six-cell
position, the off-conic zone projects onto every unused row and every unused column.

The `-1` conic term uses the normalized Möbius/hyperbola form of the root conic: it is the graph
of a bijection in the residual grid, so it has at most one cell in each row and column.  A general
projective conic can meet a line twice; the graph hypothesis is part of this row/column instance.

The incidence-matrix form is the reusable lemma: legal cells in a target line `T` are at least
`|T|` minus the number of capacity-saturated lines that cross `T` at would-be legal cells, minus
any explicitly excluded structured cells such as the root conic.  The row and column bounds are
instances of that line-load count.

At q=23, `k=6` is the last nonvacuous layer of this loose bound: at `k=7`, `23 - 7 - 21 - 1 < 0`.
So the six-cell reservoir is a base-layer availability fact, not a recursion engine.  The phrase
"sharp boundary" should not be used for the game: it is only the vacuity threshold of this loose
bound, not evidence that support fails below q=23.

## One-Pair Maintenance Probe: q=23 Bucket 0

The follow-up probe extends `s4xormine` by one coupled off-conic move/reply pair.  It uses exact
whole-position P/N solves for candidate replies and exact Node-Kayles xor for the live-conic graph.
It does not identify that graph xor with the true game nimber.  After this extra move/reply pair,
the live-conic graph may have three or four intruder matchings, so any graph xor here is for the
general bounded-degree conic graph, not Dawson/path-cycle XOR.

The naive selection rule fails immediately.  For bucket representative `1,3,4,9` and first move
`x=(0,0)`, the first zero-xor P follower is `y=(7,21)`.  Three of its 108 legal off-conic moves
have no P-valued zero-xor reply after every such reply is solved:

```text
z=(11,16): 20 candidates, 0 P
z=(15,16): 22 candidates, 0 P
z=(16,11): 29 candidates, 0 P
```

Thus `P-valued + conic xor 0` does not automatically imply `Good` closure.  Closure under all
legal next moves must be part of P2's witness selection.

The strategy-level search continues past such followers.  For the same `x`, the fourth P-valued
zero-xor follower tested, `y=(17,10)`, has a P-valued zero-xor reply for all 102 legal off-conic
moves.  A complete chunked census over all 259 first moves of this bucket then gives:

```text
chunks=26 root_moves=259 summary_moves=259 summary_hits=259 accepted=259 missing_indices=0 duplicate_indices=0 bad_chunks=0
candidate_followers=2714 failed_followers=2455 all_maint_moves=296933 all_maint_hits=288835 all_maint_no_hit=8098 no_candidates=0 try_limited=0 xor_unknown=0 aborted=0 max_memo=22575285
selected_zone_moves=28646 selected_zone_hits=28646 selected_no_hit=0 selected_unknown=0 selected_zone_range=101..116
```

Every first move in this bucket therefore has at least one zero-xor P follower with complete
one-pair maintenance coverage.  This is existential and selective: 2,455 other zero-xor P
followers failed at least one maintenance obligation before the 259 accepted followers were
found.  The accepted first replies required up to 61 sorted candidates.

The selected six-cell followers have positive live conic:

```text
live_on 4:9 5:12 6:106 7:42 8:54 9:12 10:24
```

After the next off-conic move and selected maintenance reply, the residual is much smaller:

```text
live_on 0:14205 2:12928 3:1314 4:181 5:6 6:12
```

So 27,133 of 28,646 accepted maintenance replies (94.718%) land at `live_on <= 2`; the remaining
1,513 obligations retain 3--6 live conic cells.  This is strong one-pair descent evidence, but not
a termination proof and not yet an all-bucket q=23 result.

The exact logs are under `rust/s4-dumps/2026-07-09/q23-maint-bucket00-summary/`, with the first
chunk at `rust/s4-dumps/2026-07-09/xormine-q23-maint-required-summary-idx00-rootmoves000-009.txt`.

## Next Checks

1. Mine all-move `Good` closure: after a q=23 zero-xor witness and one further legal off-conic
   move, test whether the bucket-0 existential selector extends to other PGL buckets; do not use
   the refuted first-P-witness rule, and do not assume Dawson/path-cycle XOR remains a recursive
   invariant.
2. Add an association-scheme response-count probe on the failed q=23 closure cases: classify
   `(S, x, y)` by conic-stabilizer orbitals/cross-ratio relations and compare observed legal
   `Good` replies with Hollmann--Xiang intersection numbers before investing in more generic
   `q - 22` reservoir bounds.
3. Track zone geometry as move availability for re-steering: row/column support, line-family
   support, and stabilizers, without treating it as a decoupled zone game.
4. Prove the conic matching-union graph lemma cleanly in paper/Lean terms, with the
   path/cycle/isolate corollary explicitly restricted to at most two intruders.
5. For q=25, build targeted witness dumps rather than broad partial roots.
