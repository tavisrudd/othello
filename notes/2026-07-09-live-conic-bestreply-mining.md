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
-> live conic graph is a union of paths, cycles, and isolates
-> choose a reply with live-conic Node-Kayles xor 0
-> remaining proof obligation is the off-conic zone and its coupling to the conic.
```

It also warns against a finite tiny-spectrum story.  The observed component-size spectra are varied
already at q=23, so the next theorem should probably use general path/cycle Node-Kayles structure
rather than enumerate a short list of graph shapes.

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
this dense component has a low-dimensional geometric description or a robust pairing/matching
certificate once the live conic xor has been steered to zero.

## Next Checks

1. Mine invariants of the dense off-conic zone after q=23 zero-xor witnesses: degree profile,
   row/column support, line-family support, automorphism stabilizers, and whether a pairing/matching
   certificate exists.
2. Separate conic graph value from off-conic zone value without trying to compute full zone Grundy
   directly.
3. Prove the matching-union graph lemma cleanly in paper/Lean terms.
4. For q=25, build targeted witness dumps rather than broad partial roots.
