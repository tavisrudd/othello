# C834 — cycle-profile kernel exclusion and the weight-ten closure route

**Date:** 2026-08-02

## Certified statement

Fix the normalized internal point `(1,0,2)`, whose index in the coordinate list of
`RelativeConicArcs.PassantCodeQ13.Geometry` is zero.  For every unordered pair of its thirty-five
secant neighbours and every choice of one point in each of the seven six-point passant fibres
through it, the resulting ten-point configuration has a passant carrying at least three of its
points or a point with at least three secant neighbours inside it.

The terminal declaration is
`PassantCodeQ13.WeightTen.CycleExclusion.obstructed_of_base_pair_and_fibres`
in `papers/q13-passant-code/lean-certificates/PassantCodeQ13/WeightTen/CycleExclusion/Aggregate.lean`.
Its hypothesis is membership of the pair in `secantNeighbors.sublistsLen 2` together with a
`Selection markedFibres` derivation, which records one choice from every fibre and therefore covers
the complete Cartesian domain rather than any enumeration order.

Seven independently elaborated modules `CycleExclusion.Residue0` through `CycleExclusion.Residue6`
each discharge one residue class of secant pairs, indexed by the coordinate index of the lower
endpoint modulo seven, by kernel reduction (`decide +kernel`).  A covering lemma over the residue
of `pair.headD 0` joins them; no `native_decide`, opaque oracle, or imported execution premise
occurs.  Elaboration cost per shard was 23 to 57 seconds of wall clock at 4.6 to 6.7 GB peak
resident memory under the serial `single` profile.

## Why this replaces the planned projected-state cover

The previous plan was a compact projected-state cover of the meet-in-the-middle syndrome
disjointness that the native leaf `cycleProfileCheck` computes.  That route is not viable and
should not be attempted again.  The two sides of the decomposition have 216 and 771,120 syndromes,
so the product the disjointness test must traverse is fixed at 1.67e8 pairs no matter how the ten
points are split between the sides, and `List.contains` is a linear scan.  Projecting onto a small
set of selected rows does not help: the exact-traversal transition lists retain one entry per
Cartesian choice, so their length is unchanged by projection, and the natural seven-row projection
onto the passants through the base point is exactly balanced between the two sides, both sides
projecting to the same value.

The manuscript's own argument is far cheaper and is what the Lean development now follows.  Adding
the fibre points in order and rejecting a prefix as soon as a passant carries three selected points
or a selected point acquires three secant neighbours visits 86,622 nodes over all 595 pairs, with
no group-theoretic orbit reduction.  Both rejection conditions are needed: dropping the secant
degree test raises the node count to 2.99e7 and the search no longer terminates empty, and keeping
only the degree of the newly added point raises it to 846,582.

Because the search runs over all 595 pairs, the thirty-three `D_28` orbit representatives of the
manuscript are not used and the group action is not formalized.  The certificate contains no
generated data, no hash manifest, and no generator, so nothing in it needs a reproducibility bundle
or an independent replay: the Lean source is the whole artifact.

## Route to the full weight-ten exclusion

`RelativeConicArcs.PassantCodeQ13.WeightTen.arbitrary_weightTen_word_has_pencil_profile` already
proves, for a weight-ten codeword and every point of its support, that the pencil profile at that
point is either isolated, meaning secant degree zero with one fibre of size three and six of size
one, or cyclic, meaning secant degree two with all seven fibres of size one.  Splitting on that
dichotomy closes weight ten with the two existing certificates and no further finite computation:

- If some support point has the isolated profile, the support consists of that point, three points
  of one fibre through it, and one point in each of the six other fibres.  The kernel-checked
  isolated reachability certificate excludes every such syndrome sum for each of the seven choices
  of distinguished fibre.
- Otherwise every support point has the cyclic profile.  Then every secant degree is two, and no
  passant carries three or more support points, since a passant carrying more would give a fibre of
  size at least two at each of its support points and force the isolated profile there.  The
  certificate above contradicts both conditions simultaneously.

Two consequences for the remaining formalization work.  The global moment identity
`4n_4+12n_6+... = 10-m` and the classification into the `m=6` and `m=10` shapes are not needed in
Lean; they are the manuscript's presentation of a dichotomy the local pencil profile already
supplies in formal form.  The thirty-seven stabilizer obstruction records named in the build
architecture note are likewise not needed.  A direct kernel certificate for the four-point-passant
shape was written and its mathematics verified numerically — over all seventy-eight passants and
all thirty-five four-subsets of the internal points of each, the set of internal points passantly
joined to all four has at most seven elements and contains no six-element subset with two-regular
induced secant graph — but it was discarded rather than landed, because the profile dichotomy makes
it redundant and it would add referee-facing surface with no role in any proof.

## What remains open on this endpoint

Both weight-ten certificates are anchored at the fixed internal point `(1,0,2)`, while the profile
theorem supplies its dichotomy at an arbitrary support point.  Transport from an arbitrary internal
point to the fixed one is unformalized and is the sole remaining gap in the weight-ten half of the
distance argument.  Separately, the certificates speak about coordinate indices and incidence
masks, while the profile theorem speaks about the semantic `InternalPoint` and `PassantLine` types;
the bridge between the two models exists for the incidence and rank packet and must be extended to
cover the fibre decomposition and the secant-join relation before the case split above can be
written as a single Lean theorem.

## Reproduction

From the repository root, with the paper-local Lean package as the build root:

```sh
lean/scripts/lean-build-queue.py run \
  PassantCodeQ13.WeightTen.CycleExclusion \
  PassantCodeQ13.WeightTen.CycleExclusion.Residue0 \
  PassantCodeQ13.WeightTen.CycleExclusion.Residue1 \
  PassantCodeQ13.WeightTen.CycleExclusion.Residue2 \
  PassantCodeQ13.WeightTen.CycleExclusion.Residue3 \
  PassantCodeQ13.WeightTen.CycleExclusion.Residue4 \
  PassantCodeQ13.WeightTen.CycleExclusion.Residue5 \
  PassantCodeQ13.WeightTen.CycleExclusion.Residue6 \
  PassantCodeQ13.WeightTen.CycleExclusion.Aggregate \
  --lean-root papers/q13-passant-code/lean-certificates \
  --profile single --threads 1 --cores 20-23
```
