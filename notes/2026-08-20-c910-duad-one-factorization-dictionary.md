# C910 — the duad/one-factorization dictionary and what centralizing `W` really is

**Lane:** `cubic-threefolds` · **Date:** 2026-08-20

The combinatorial explanation that the previous pass recorded as a surprise is
now formalized, and formalizing it corrected it. The fifteen nonzero vectors of
the six-point coefficient heart are the fifteen pairs of labels, the five orbits
of multiplication by the quadratic root `W` are the five matchings of the
one-factorization already displayed in the alternating-action module, and the
label permutations preserving that one-factorization are exactly the
packet-preserving group of order one hundred twenty — not the centralizer of `W`,
which is its index-two even part.

## What is now proved

`GraphLattices/SixPointDuadFactorization.lean` is a new module.

*The dictionary.* The characteristic-two indicator vector of a pair of distinct
labels lies in the augmentation hyperplane, its class in the four-dimensional
heart is nonzero, and every nonzero heart vector arises from exactly one such
pair. The heart matrix of a label permutation carries the heart vector of a pair
to the heart vector of the permuted pair, so the fifteen-point correspondence is
equivariant for the whole symmetric group on the labels.

*The one-factorization is the orbit decomposition.* Attach to a nonzero heart
vector the index of the matching containing its pair. Two nonzero heart vectors
carry the same index exactly when the second is the first, the first multiplied
by `W`, or the first multiplied by `W+1`. So the five matchings displayed in the
alternating-action module are exactly the five orbits of multiplication by `W`,
each of size three, and the index function is a complete invariant of those
orbits.

*The group statement, corrected.* A permutation of the six labels carries every
matching to a matching exactly when conjugation by its heart matrix carries `W`
to `W` or to `W+1`; that is, preserving the one-factorization and preserving the
packet of diagonally stable halves are the same condition, and the group is the
one of order one hundred twenty. Centralizing `W` is strictly stronger: a label
permutation centralizes `W` exactly when it preserves the one-factorization and
is an even permutation of the six labels. The two conditions differ by the
index-two subgroup, so the sentence in the previous report that centralizing `W`
"is the same as preserving that one-factorization" was off by exactly that
index; scaling by the non-square scalar preserves the one-factorization and
conjugates `W` to `W+1`.

*The proof is structural, not an enumeration.* The forward direction transports
orbits through the heart matrix. The reverse direction — preservation of the
one-factorization forces the conjugate of `W` into the pair `W`, `W+1` — does not
enumerate the seven hundred twenty permutations. Preservation makes the
conjugate carry each orbit to itself, so at every nonzero vector the conjugate
agrees with multiplication by `W` or with multiplication by `W+1`; and then the
difference between the conjugate and multiplication by `W` is a linear map that
either annihilates or fixes each vector individually, which forces one choice at
every vector at once, because a vector of each kind would evaluate the map at
their sum in two incompatible ways. The finite inputs are closed equalities over
the field with two elements and over the six labels, checked by kernel
reduction, the largest being the two-variable orbit criterion over the sixteen
heart vectors.

Reviewer terminal
`principalGluing_stableHalfPacket_labelOneFactorizationDictionary`, on
`prop:principal-gluing-packet`.

## What the statement is, and what it is not

Everything here is about the fifteen pairs of six abstract labels and an
explicit four-dimensional characteristic-two module. No relative isogeny,
torsion group scheme, Weil pairing, or geometric Galois action is constructed,
and the six labels are still not identified with the manuscript's six
geometrically named dihedral normalizers. The marking of the actual geometric
kernel therefore remains supplied, exactly as before.

## Validation

From `papers/cubic-stabilization-m1/`:

```text
lean/scripts/lean-build-queue.py build \
  TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Verification.AxiomAudit \
  --lean-root <repository>/papers/cubic-stabilization-m1/lean --cores 20-23
make lint formal-static
make formal-audit AXIOM_LOG=<run directory>/logs/<audit target>.quiet/<run>/<invocation>/stdout.log
```

Both the source-only and the axiom-log check pass over 161 sources and 311
reviewer terminals, with 62 claims, 48 machinery rows, and unchanged coverage
counts (5 absent, 27 fragmentary, 29 conditional, 1 complete). The new terminal
depends only on `propext`, `Classical.choice`, and `Quot.sound`. The
`prop:principal-gluing-packet` row was re-examined across objects, hypotheses,
conclusion, and cautions before its digests were refreshed: the conclusion now
records the pair-to-heart-vector dictionary, the identification of the displayed
matchings with the orbits of `W`, and the exact difference between preserving
the one-factorization and centralizing `W`; the cautions record that the
dictionary supplies no geometric marking. The manuscript PDF was not rebuilt:
the only manuscript change is one entry in a `\lean` list, whose macro is
typographically empty.

## Mystery ledger

- **Settled: the combinatorial explanation of the order-sixty centralizer, and
  its correction.** The centralizer is the alternating image because the
  one-factorization stabilizer is the packet-preserving group of order one
  hundred twenty and the centralizer is its even half. The twelve-element
  conjugation orbit used by the earlier proof and the five matchings used here
  are two routes to the same two group orders; the matching route is the one
  that explains why the larger group is a symmetric group on five letters acting
  on the five matchings.
- **Settled: which datum can select inside the packet.** The parity that
  distinguishes centralizing `W` from merely preserving the one-factorization is
  the sign of the label permutation, equivalently the parity of its induced
  permutation of the five matchings. This sharpens the previous pass's remark
  that any geometric marking must have a two-valued shadow on the six axes: the
  shadow is exactly this sign, so a geometric input marking the kernel must
  determine the parity of the Galois action on the six axes, and nothing weaker
  will do.
- **Reframing worth recording: this is Sylvester's duads-and-synthemes
  duality.** Six labels carrying a distinguished one-factorization is the
  classical presentation of the outer automorphism of the symmetric group on six
  letters, and the module gives it a linear model: the fifteen duads are the
  nonzero vectors of the heart, a syntheme is an orbit of `W`, and the
  one-factorization is the four-element-field structure on the heart. The
  package proves the linear model; the combinatorial duality itself is classical
  and is not claimed as new anywhere in the artifact. What this buys is a sharp
  form of the geometric question: the six dihedral axes are the six Sylow-five
  subgroups of one alternating group on five letters, a one-factorization of
  them amounts to a second such structure exchanged with the first by the outer
  automorphism, and marking the kernel asks whether the geometric Galois action
  distinguishes those two classes. That is the same two-valued datum as the
  parity above.
- **Cheap upgrade left on the table.** The packet-preserving group acts
  faithfully on the five matchings, and that action is the symmetric group on
  five letters, with the centralizer of `W` its alternating subgroup; the
  alternating half is already formalized through the factor words of the
  alternating-action module, so only the induced factor permutation of the
  scaling permutation is missing. Adding it would state the classical
  five-letter picture directly rather than through the sign character.
- **Open, unchanged: the geometric side.** No relative isogeny, torsion group
  scheme, Weil pairing, geometric Galois action, or identification of the six
  labels with the manuscript's dihedral axes is constructed, so the marking of
  the actual kernel and the geometric commutator pairing remain supplied.
