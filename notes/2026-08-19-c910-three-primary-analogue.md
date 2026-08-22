# C910 — the three-primary kernel: cofactor route, minus-dot-product pairing, and the packet

**Lane:** `cubic-threefolds` · **Task:** C910 · **Date:** 2026-08-19

Fourth pass of the day on `lem:relative-six-axis`, and the three-primary mirror
of the two-primary chain built in
`2026-08-19-c910-two-primary-lattice-model.md`,
`2026-08-19-c910-two-primary-pairing.md` and
`2026-08-19-c910-two-primary-standard-coordinates.md`.

## What this pass did

Three new modules under
`papers/cubic-stabilization-m1/lean/TavisRuddFiniteGeom/Papers/CubicStabilizationM1/GraphLattices/`:

- `SixAxisThreePrimaryLatticeComparison.lean` identifies the two models of the
  three-primary discriminant. The reduction modulo three of the cofactor image
  is well defined on the discriminant group because `C F = 6`; its kernel is
  exactly the two-primary part, it lands in the kernel of the polarization
  reduced modulo three, and it is onto that kernel, so it restricts to an
  isomorphism of the three-primary part of the discriminant group with that
  kernel and hence with four copies of the rank-two three-torsion module. The
  argument is division free, exactly as at two, with one sign: an integral lift
  `w` of a kernel vector has `F w = 3 u`, and `C u = 2 w`, which is minus `w`
  modulo three, so the class carried onto `w` is the class of `-u`.
- `SixAxisThreePrimaryPairing.lean` computes the discriminant pairing across
  that identification. For three-torsion classes written as thirds
  `3 v = F y` of polarization images, vanishing of the pairing is divisibility
  of `y ⬝ F z` by nine, and the value `(y ⬝ F z)/3` reduces modulo three to
  minus the dot product on axis coordinates tensored with the reduced elliptic
  pairing. That is the manuscript's normalized three-primary form, and the
  minus sign is the reduction of `6I₅-J₅`, which modulo three is the negative
  of the all-ones matrix. The comparison sends a class to minus the reduction
  of its numerator, and the form is unchanged by negating both arguments, so
  the pairing of two three-torsion classes vanishes exactly when the normalized
  form of their comparison images does; the image of the three-primary kernel
  is therefore its own orthogonal complement inside the kernel of the reduced
  polarization.
- `SixAxisThreePrimaryHeartCoordinates.lean` carries that kernel into two
  copies of the three-primary coefficient heart, one for each elliptic homology
  coordinate, and proves the coordinate equivalence is an isometry onto the
  two-copy polarization form. The computation is again the augmentation
  normalization: a kernel slice has vanishing coordinate sum, so its fifth
  coordinate is minus the sum of the other four, which is the fifth entry of
  the normalized heart representative whose sixth entry is zero, and minus the
  five-term dot product of two slices is the heart's minus-dot-product form.
  The transported kernel is its own orthogonal complement, hence maximal
  isotropic, hence — by a general half-dimension theorem for a nondegenerate
  alternating form, proved in the same module — four-dimensional, so the
  existing classification makes it the vertical copy or one of the three scalar
  graphs as soon as it is stable under the two diagonal generators.

Unlike the two-primary side, the dimension is not an input anywhere: maximal
isotropy is proved from the pullback identity and then converted to the
dimension, so the packet membership at three needs only stability.

`Applications/RelativeSixAxis.lean` carries the per-fibre versions, and
`RelativeSixAxisConclusion` gains `threePrimaryPairingAndKernelImage` and
`threePrimaryKernelHeartCoordinates`. Two reviewer terminals were added on
`lem:relative-six-axis`, `relativeSixAxis_threePrimaryDiscriminantPairing` and
`relativeSixAxis_threePrimaryKernelHeartCoordinates`; both report
`propext, Classical.choice, Quot.sound`.

## The shared cofactor layer moved

Three cofactor identities and the cokernel scalar rule, all prime-free, moved
from `SixAxisTwoPrimaryLatticeComparison.lean` into
`SixAxisPrimaryDiscriminantSplitting.lean`, and with them the four
prime-free lemmas of `SixAxisTwoPrimaryPairing.lean`: the coefficient and
polarization forms on integral vectors, the adjugate of the source polarization
as `6⁷` times the cofactor, and the criterion that the discriminant pairing of
two classes vanishes exactly when six divides the cofactor form of two
representatives. Nothing was restated or duplicated at three; both primary
chains now sit on that one layer.

## The orders of the primary parts, from the closeout pass

The two lattice comparisons make the orders immediate, so this pass also closed
what the previous one recorded as open: the two-primary part of the
discriminant group has order `2⁸` and the three-primary part `3⁸`, which
factors the order `6⁸` of the whole group into its prime powers. The terminal
is `relativeSixAxis_primaryDiscriminantOrders`, and it has no geometric
premise. The orders `2⁴` and `3⁴` of the primary parts of the kernel are still
not stated, although the transported three-primary kernel is now proved
four-dimensional over `F₃`.

## Validation

From `papers/cubic-stabilization-m1/`:

```text
lean/scripts/lean-build-queue.py build CubicStabilizationM1 \
  TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Verification.AxiomAudit \
  --lean-root <repository>/papers/cubic-stabilization-m1/lean --cores 20-23
make lint formal-static
make formal-audit AXIOM_LOG=<run directory>/logs/<audit target>.quiet/<run>/<invocation>/stdout.log
```

Both the source-only and the axiom-log check pass over 152 sources and 302
reviewer terminals, with 62 claims, 48 machinery rows, and unchanged coverage
counts (5 absent, 27 fragmentary, 29 conditional, 1 complete). The claim-map
row for `lem:relative-six-axis` was extended across objects, conclusion, and
cautions — the caution denying any order of a primary part is now the narrower
statement about the kernel orders — and its terminal digest was refreshed after
that review. The manuscript PDF was not rebuilt: the only manuscript change is
the `\lean` list of that lemma, whose macros are typographically empty.

## Mystery ledger

- **Settled: whether the three-primary route needs anything the two-primary one
  did not.** It does not. The same cofactor identity, the same Bezout
  cancellation, the same augmentation normalization. The only difference is a
  sign, and it is forced by `2 ≡ -1` modulo three; it appears twice, in the
  surjectivity of the comparison and in the value of the comparison on a third
  of a polarization image, and it cancels in the pairing statement because the
  form is quadratic in the pair.
- **Settled: the orders of the primary parts of the discriminant group.** They
  were listed as open and gated on stability last pass. They are neither: both
  follow from the lattice comparisons alone.
- **Settled: why the packet criterion differs between the two primes.** At two
  the classification is stated through maximal isotropy, at three through
  dimension four. The bridge is the general theorem that a maximal isotropic
  subspace of a nondegenerate alternating form has half the ambient dimension,
  which this pass proves; that is why the three-primary kernel reaches its
  packet with no dimension input.
- **Open: stability, that is `A₅`-equivariance, at both primes.** Still the one
  remaining input for packet membership on either side. It needs an integral
  action on the source lattice commuting with the polarization and an
  equivariance hypothesis on the comparison matrix; the homology realization
  has neither.
- **Open: the orders of the primary parts of the kernel.** `2⁴` and `3⁴`. At
  three the transported kernel is four-dimensional over `F₃`, so only the
  transport of that count back to the kernel subgroup itself is missing; at two
  the count would follow from the splitting once the three-primary count is
  transported.
- **Open, unchanged: the geometric commutator pairing and the dictionary
  proposition.** No elliptic torsion group scheme, Weil pairing, or geometric
  discriminant is constructed at either prime.
- **Open: the two chains are one chain at a general prime.** Everything above
  holds for a prime `p` dividing the annihilator six with the cofactor `C` and
  the normalized form `(6/p)` times the dot product tensored with the reduced
  elliptic pairing — at two that factor is three, which is one modulo two, and
  at three it is two, which is minus one. A development parameterized by `p`
  would replace both chains. Nothing in the present statements depends on the
  duplication, so this is a compression, not a correction.
