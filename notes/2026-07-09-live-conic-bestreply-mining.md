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
```

This is compatible with the q=19/q=23 path/cycle/isolate picture, but it is not a value-coverage
result.

## Import

This pass supports a sharper q>=23 proof target:

```text
positive-live S4 reply
-> live conic graph is a union of paths, cycles, and isolates
-> even-cycle bulk cancels
-> remaining path/isolate/zone skeleton is steerable or certificate-small.
```

It also warns against a finite tiny-spectrum story.  The observed component-size spectra are varied
already at q=23, so the next theorem should probably use general path/cycle Node-Kayles structure
rather than enumerate a short list of graph shapes.

## Next Checks

1. Add path/cycle Grundy summaries for the live conic graph.
2. Separate conic graph value from off-conic zone value.
3. For q=23, run more exact bucket representatives only if the two current samples fail a proposed
   graph/zone law.
4. For q=25, build targeted witness dumps rather than broad partial roots.
5. Try to prove directly that two off-conic intruders always induce a degree-2 conic graph, hence
   a disjoint union of paths and cycles.  This should be a short geometric lemma.
