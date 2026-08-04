# C834 — kernel closure of the weight-ten pencil, join, and secant leaves

**Date:** 2026-08-03

## What changed

The three release-facing native-evaluation leaves of
`RelativeConicArcs.PassantCodeQ13.WeightTen` are replaced by kernel reduction:

- `passantPencil_card` — every internal point lies on exactly seven passant lines;
- `joining_passantLine_unique` — two distinct internal points lie on at most one common passant;
- `not_passantJoin_iff_secantJoin` — distinct internal points with no common passant have a common
  conic secant.

A fourth native call in the same module, the two-element case split on `ZMod 2`, is now `decide`.

## Method

A direct `decide +kernel` on the original subtype statements is not viable: reverting over
`InternalPoint` forces the kernel to re-reduce `Finset.univ` for the subtype — hence the
deduplicating `toFinset` of the 183 normalized triples — once per point, and the elaboration was
killed by the memory guard after two minutes.

The landed route computes the finite content once, on the displayed coordinate lists, and
transports it afterwards. `RelativeConicArcs.PassantCodeQ13.PencilIncidence` defines the passant
and secant pencils of a normalized triple as filters of the displayed line lists, collects them
into one `pencilTable` over the 78 internal points, and decides all three facts against that single
table: a length check per entry, and two checks over ordered pairs of entries using the
intersection of the two stored pencils. The table reduces once and the pairwise stages then cost
only list comparisons, so the whole module elaborates in 37 seconds and builds with 4.7 GB peak
resident memory.

`RelativeConicArcs.PassantCodeQ13.PencilJoins` transports those statements to `InternalPoint`,
`PassantLine`, and `WeightEight.SecantLine`. Its only nontrivial step is a bijection between the
filtered `Finset` of passant lines through a point and the `toFinset` of the displayed pencil,
whose cardinality is the pencil length because the displayed passant list has no repetitions.
It performs no finite computation and elaborates in three seconds.

## Verification

```sh
lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.Gates.PassantCodeQ13AxiomAudit --profile single --threads 1 --cores 20-23
```

The Paper IV gate `RelativeConicArcs.Gates.PassantCodeQ13` and its axiom audit build warning-free.
In the audit output both weight-ten terminals,
`RelativeConicArcs.PassantCodeQ13.WeightTen.not_passantJoin_iff_secantJoin` and
`RelativeConicArcs.Gates.PassantCodeQ13.arbitrary_weightTen_profile_transport`, now depend only on
`propext`, `Classical.choice`, and `Quot.sound`.

## What remains

The residual native-evaluation axioms in the Paper IV gate closure are the weight-eight
tangent-graph and clique leaves of `RelativeConicArcs.PassantCodeQ13.WeightEight` and
`RelativeConicArcs.PassantCodeQ13.passantRow_card`. The two weight-ten endpoint gaps recorded in
`notes/2026-08-02-c834-weight-ten-semantic-bridge.md` — the list-versus-finset assembly joining the
profile theorem to the two finite certificates, and the projective transport of an arbitrary
support point to the fixed base point — are unaffected by this change and still open.
