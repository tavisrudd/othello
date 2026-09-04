# C1061 probe 24: matching-signature compression

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 probe 24, route 2 of `notes/2026-09-03-c1061-qec-redirect-brief.md`.
**Verdict**: **killed, with a precise reason.** The boundary table *is* a structured matching object
— a valuated even delta-matroid, confirmed with zero violations across half a million exchange
triples — but it is **not** overparameterized. For any region worth summarizing, the 256-entry table
is *smaller* than the matching gadget it replaces, not an expansion of it. The hypothesis is
inverted by the measurement.

## What was asked

Route 2's hypothesis: the `W x W` table came from a minimum-weight matching problem, not a generic
tropical matrix, so the 256-entry object at width 16 might be an expanded form of a much smaller
matching object. The probe: convert each boundary table to a terminal-subset matching valuation,
test the delta-matroid exchange axioms, test tropicalized matchgate identities on the planar
repetition case, recover the smallest gadget, compose gadgets against dense min-plus. Kill it
quickly if the identities fail.

## The conversion, and that it is exact

A space-cut leaf is one detector column: `T` detectors joined in a path by `T - 1` time-like
(measurement) edges, with `T` space-like (data) edges crossing the left cut and `T` crossing the
right. Writing `u` for the left-crossing subset and `v` for the right-crossing subset, the detector
demands are `y = d + u + v`, the interior time-like edges realizing them on a path are forced and
exist exactly when `parity(y) = 0`, and their count is the popcount of the prefix parity of `y`.
So the leaf table, reindexed on the `2T` terminals, is the terminal-subset matching valuation

```text
f(u, v) = |u| + |prefix_parity(d + u + v)|   when parity(d + u + v) = 0, else infinity
```

`the_terminal_valuation_equals_the_space_cut_leaf_table` checks entry by entry, for every detector
column, at `T = 2, 3, 4`, that this valuation and the space-cut leaf matrix are the same object in
two layouts. The conversion is exact, so everything below is a statement about the real table.

## Identity results

Eight samples per shape, random detector columns, composed regions built by min-plus product.

| rounds | terminals | columns | even support | mean finite entries | exchange triples | support violations | valuated violations | Plücker quadruples | **Plücker violations** |
|---|---|---|---|---|---|---|---|---|---|
| 2 | 4 | 1 | 8/8 | 8 of 16 | 1,024 | **0** | **0** | 2 | 0 |
| 2 | 4 | 8 | 8/8 | 8 of 16 | 1,024 | **0** | **0** | 6 | **1** |
| 3 | 6 | 1 | 8/8 | 32 of 64 | 24,576 | **0** | **0** | 240 | **82** |
| 3 | 6 | 8 | 8/8 | 32 of 64 | 24,576 | **0** | **0** | 240 | **63** |
| 4 | 8 | 1 | 8/8 | 128 of 256 | 524,288 | **0** | **0** | 4,480 | **1,664** |
| 4 | 8 | 4 | 8/8 | 128 of 256 | 524,288 | **0** | **0** | 4,480 | **601** |
| 4 | 8 | 8 | 8/8 | 128 of 256 | 524,288 | **0** | **0** | 4,480 | **1,317** |

Three findings, in order of how much they matter.

**The support is an even family, always, and that is probe 17's parity superselection rule under its
real name.** Exactly `2^(2T-1)` of `2^(2T)` subsets are finite, and every one has the same parity.
Probe 17 measured "exactly half the entries are absent, with zero deviation at every height" and
attributed it to the terminal round's forced measurement; it is the **even delta-matroid** condition,
and it was visible in the data before any of this theory was applied.

**The symmetric exchange axiom holds, in both its support and valuated forms, with zero violations
across 524,288 triples per shape** — for single columns *and* for composed regions. So the min-plus
product of these tables stays inside the class: **the boundary table is a valuated even
delta-matroid, not a generic tropical matrix.** The brief's premise is correct.

**The tropicalized Pfaffian / matchgate relation fails.** At `T = 4` it fails on 601 to 1,664 of
4,480 quadruples, and it already fails at `T = 2` once a region is eight columns wide. The test is
the standard tropical form of the three-term Grassmann--Plücker relation: the minimum over the three
pairings of a quadruple must be attained at least twice. **Caveat**: the test quantifies over all
quadruples without imposing the planar cyclic order on the terminals, so it is a necessary condition
in the tropical form rather than the exact planar matchgate identity; a formulation that respects the
boundary cyclic order was not built. The failure is large and consistent enough across shapes that
it is unlikely to be an artifact, but that is a judgement, not a proof.

So the object is a valuated even delta-matroid and is **not** a tropical Pfaffian. Delta-matroid
membership is a strong exchange property; it does not by itself reduce the parameter count below the
`2^(2T-1)` finite entries.

## Parameter counts, which invert the hypothesis

The natural gadget of a `k`-column region over `T` rounds is its own decoding graph: `k*T` detector
vertices, `k*(T-1)` time-like edges and `(k+1)*T` space-like edges. Its parameter count is the edge
count. The dense table it replaces is `2^(2T)` entries **regardless of `k`**.

| rounds | terminals | table entries | columns | gadget vertices | gadget edges | table / gadget |
|---|---|---|---|---|---|---|
| 4 | 8 | 256 | 1 | 4 | 11 | **23.3x** |
| 4 | 8 | 256 | 2 | 8 | 18 | 14.2x |
| 4 | 8 | 256 | 4 | 16 | 32 | 8.0x |
| 4 | 8 | 256 | 8 | 32 | 60 | 4.3x |
| 4 | 8 | 256 | 16 | 64 | 116 | 2.2x |
| 4 | 8 | 256 | 64 | 256 | 452 | **0.6x** |
| 4 | 8 | 256 | 1,024 | 4,096 | 7,172 | **0.04x** |
| 3 | 6 | 64 | 16 | 48 | 83 | 0.8x |
| 2 | 4 | 16 | 8 | 16 | 26 | 0.6x |

**The crossover is at about 16 columns at `T = 4`, 8 at `T = 3` and 4 at `T = 2`.** Below it the
gadget is the compact form; above it the *table* is. At a distance-9 code the region is 8 columns and
the two are within a factor of 4; at any larger code the table wins outright, and at 1,024 columns
the gadget needs 7,172 parameters to say what 256 numbers already say.

**That is the answer to route 2 and it is the opposite of the hypothesis.** The dense boundary table
is not an expanded form of a smaller matching object; for regions of any interesting size it is a
*fixed-size sufficient statistic* for an object that grows linearly. Its 256 entries are, if
anything, an impressive compression of the region — which is exactly what a good boundary summary
should be.

## Why the table still loses, restated

Probes 13 and 17 measured the table losing to sparse blossom by 15x to 82x. This probe shows the
loss is not representational overparameterization. The gap is that the table is dense in the
*boundary alphabet* while a real syndrome is sparse in *defects*: blossom's advantage comes from
touching only the neighbourhood of the handful of defects present in a shot, not from holding a
smaller description of the region. A 256-entry sufficient statistic is a good description and a bad
thing to recompute in full when three of its entries matter.

Composing gadgets rather than tables would mean keeping the sparse decoding graph and solving a
matching on it — which is sparse blossom. The brief anticipated exactly this: route 2 was the only
path by which the framework stays an exact online global decoder *without* reproducing sparse
blossom, and it does not exist.

## Gates

Seven tests, all passing, in `/home/tavis/src/ergodis-private/src/matching_signature.rs`:

| Gate | What it establishes |
|---|---|
| `the_terminal_valuation_equals_the_space_cut_leaf_table` | the conversion is exact at `T = 2, 3, 4`, entry by entry, for every detector column |
| `the_support_is_an_even_family` | exactly `2^(2T-1)` finite entries, all of one parity, at every `T` and every column |
| `single_columns_satisfy_the_symmetric_exchange_axioms` | support and valuated exchange, exhaustively |
| `composed_regions_satisfy_the_symmetric_exchange_axioms` | the same after min-plus composition of up to four columns |
| `the_min_plus_product_preserves_the_even_support` | the class is closed under the framework's own composition |
| `the_gadget_is_linear_where_the_table_is_exponential` | the parameter-count comparison |

## Files and commands

```
cd /home/tavis/src/ergodis-private
cargo test --release -p ergodis-private --lib -- matching_signature      # 7 passed
ergodis-tools matching-signature-bench --mode identities --samples 8
ergodis-tools matching-signature-bench --mode parameters
```

- `/home/tavis/src/ergodis-private/src/matching_signature.rs`
- `/home/tavis/src/ergodis-private/tasks/tools/src/matching_signature_bench.rs`

## Mystery ledger

- **The tropical Plücker test ignores the planar cyclic order.** If the correct planar-ordered
  matchgate identity were imposed, the violation count could differ. The delta-matroid results do not
  depend on it, and the parameter-count result — which is what kills the route — does not depend on
  either identity. Open, and cheap to settle, but it cannot change the verdict.
- **The valuated exchange axiom holds with zero violations everywhere tested, including after
  composition.** That is a genuinely nice structural fact about the framework's boundary summaries
  and it is unused. If any future route needs to prove something about composed summaries, this is
  the property to lean on.
- **The crossover column count scales roughly as `2^(2T)/(2T)`**, so it grows with the window height
  while the code distance sets the region width. A very tall, very narrow region would favour the
  gadget; no QEC instance has that shape.

## Vibe check

A clean kill, and more informative than expected. The brief's premise was right — the table really is
a valuated even delta-matroid, confirmed with zero exchange violations across half a million triples
and with the even-support condition turning out to be probe 17's parity superselection rule under its
proper name. But the conclusion drawn from that premise was backwards: counting parameters shows the
dense table is the *compressed* form for any region larger than about sixteen columns, and the
matching gadget is the expansion. There is no smaller exact object to recover, the matchgate
identities fail anyway, and composing gadgets is just doing matching. Route 2 is closed on a
measurement rather than an opinion.
