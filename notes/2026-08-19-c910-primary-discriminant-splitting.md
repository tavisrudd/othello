# C910 — the primary splitting of the source discriminant and the relative maximal isotropy of each `𝒦_p`

**Lane:** `cubic-threefolds` · **Task:** C910 · **Date:** 2026-08-19

## What this pass did

`lem:relative-six-axis` asserts that the `p`-primary part `𝒦_p` of `ker f` is
an `A_5`-stable relative maximal isotropic subgroup of the `p`-primary
discriminant `𝒟_p`, for `p = 2, 3`. The previous pass built the discriminant
group of the source polarization and proved maximal isotropy of the whole
kernel inside the whole group, leaving the primary refinement as the supplied
field `kernelMaximalIsotropic`. This pass proves the primary refinement and
removes that field.

New module
`papers/cubic-stabilization-m1/lean/TavisRuddFiniteGeom/Papers/CubicStabilizationM1/GraphLattices/PrimaryDiscriminantSplitting.lean`
develops the splitting for an arbitrary integral alternating form `F` of
nonzero determinant and an arbitrary factorization of an annihilator of its
discriminant group into two coprime integers `a`, `b`:

- `exists_coprime_torsion_decomposition` splits an element as the sum of two of
  its own integer multiples, killed by `a` and by `b` respectively. Because the
  components are multiples of the element, `eq_sup_inf_torsionBy_of_isCoprime`
  splits *every* subgroup, not just the whole group, which is what the kernel
  needs; `inf_torsionBy_eq_bot_of_isCoprime` gives trivial intersection and
  `sup_torsionBy_eq_top_of_isCoprime` the whole-group form.
- `mem_torsionBy_iff_exists_pow_smul_eq_zero` shows the `a`-torsion part is
  exactly the set of elements killed by *some power* of `a`. This is what
  licenses calling these subgroups primary parts rather than torsion parts.
- `bilinear_eq_zero_of_isCoprime_torsion` kills any bilinear map on a pair drawn
  from the two different parts, so distinct primary parts are orthogonal, and
  `eq_zero_of_forall_torsionBy` shows the discriminant pairing stays
  nondegenerate on each part.
- `discriminantPerpWithin` and `IsRelativeMaximalIsotropicSubgroup` are the
  relative vocabulary: orthogonal complement taken inside an ambient subgroup,
  and maximality among the isotropic subgroups of that ambient subgroup.
- `inf_torsionBy_eq_perpWithin` is the transport. If `𝒦` equals its own
  orthogonal complement in the whole group, then `𝒦 ⊓ D_a` equals its own
  orthogonal complement inside `D_a`, hence
  `isRelativeMaximalIsotropic_inf_torsionBy`. The proof is that a class of
  `D_a` orthogonal to `𝒦 ⊓ D_a` is orthogonal to all of `𝒦`: split an
  arbitrary `k ∈ 𝒦` as `k_a + k_b` with both components still in `𝒦`, pair
  against `k_a` by hypothesis and against `k_b` by cross-primary
  orthogonality.

`GraphLattices/SixAxisPrimaryDiscriminantSplitting.lean` supplies the
annihilator. `6I₅-J₅` times `I₅+J₅` is `6I₅`, and the rank-two elliptic
homology pairing is its own inverse up to sign, so the Kronecker product of
`I₅+J₅` with the negative of that pairing carries the source polarization to
six times the identity. Hence six annihilates the discriminant group, and with
`IsCoprime 2 3` the general layer specializes: the group is the direct sum of
`𝒟_2` and `𝒟_3`, those parts are orthogonal and each carries a nondegenerate
pairing, the kernel splits as `𝒦_2 ⊕ 𝒦_3`, and each `𝒦_p` is a relative
maximal isotropic subgroup of `𝒟_p`.

`Applications/RelativeSixAxis.lean` carries the per-fibre versions
(`relativeSixAxisPrimaryKernelSubgroup` and the three theorems) and
`RelativeSixAxisConclusion` gains the field
`primaryDiscriminantSplittingAndKernel` recording all of them, discharged from
the homology realization alone. The supplied field `kernelMaximalIsotropic` is
gone.

One reviewer terminal was added,
`relativeSixAxis_primaryDiscriminantSplitting_maximalIsotropicKernels`,
registered on `lem:relative-six-axis`. It reports
`propext, Classical.choice, Quot.sound`.

## What remains supplied

The row stays a fragment, and three things in the same manuscript sentence are
still not represented.

`A_5`-stability of `𝒦_p` is untouched. No group action on the lattice
discriminant group is constructed, and the homology realization carries no
equivariance hypothesis on the comparison matrix, so `kernelA5Stable` remains a
supplied proposition.

The orders are not formalized. What is proved is the order `6⁸` of the whole
discriminant group and `6⁴` of the whole kernel; the manuscript's fibrewise
orders `p⁸` and `p⁴` of the primary parts would need the cardinality of a
finite abelian group killed by a prime to be a power of that prime, which is
not in this package's current layer.

The geometry is supplied as before, through
`homologyRealizesRelativeGeometry`: `𝒟_p` here is the `p`-torsion part of the
cokernel of an explicit integral matrix, not a geometric torsion local system,
and the commutator pairing of a polarized abelian scheme is still absent, so
the identification of the lattice pairing with `e_{λ_A}` and of the lattice
kernel with `ker f` remains supplied.

## Validation

All gates green; the manuscript PDF was not rebuilt, since the only manuscript
change is the `\lean` list of `lem:relative-six-axis`, whose macros are
typographically empty.

From `papers/cubic-stabilization-m1/`:

```text
make lint formal-static
lean/scripts/lean-build-queue.py build \
  TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Verification.AxiomAudit \
  --lean-root <repository>/papers/cubic-stabilization-m1/lean --cores 20-23
make formal-audit AXIOM_LOG=<run directory>/logs/<audit target>.quiet/<run>/<invocation>/stdout.log
```

Source-only and axiom-log checks both pass over 146 sources and 296 reviewer
terminals, with 62 claims, 48 machinery rows, and unchanged coverage counts
(5 absent, 27 fragmentary, 29 conditional, 1 complete). The claim-map row for
`lem:relative-six-axis` was rewritten across objects, hypotheses, conclusion,
and cautions, and its terminal digest refreshed after that review; the statement
digest is unchanged, since annotations are excluded from it.

## Mystery ledger

- **Settled: primality is not what makes the splitting work.** Only coprimality
  of the two factors is used, together with an annihilator that is their
  product. Primality enters exactly once, in the reading of the two parts as
  primary parts, and even there through the power characterization rather than
  through any prime-specific argument.
- **Settled: the annihilator is six, not `6⁸`.** The determinant always
  annihilates a discriminant group, which would have given the splitting along
  `2⁸` and `3⁸` just as well. The sharper annihilator comes from the explicit
  cofactor `I₅+J₅`, and it makes each primary part elementary abelian, matching
  the manuscript's `H_p ⊗ 𝒱_p` description. Exactness of the exponent is not
  claimed and is not needed.
- **Settled: no cardinality is used anywhere in this pass.** Both the whole
  kernel's self-duality (previous pass) and its transport to the primary parts
  (this pass) are matrix algebra and Bezout's identity.
- **Open: the orders of the primary parts.** Stated above with the missing
  ingredient. Nothing else blocks them.
- **Open: `A_5`-stability of `𝒦_p`.** The other half of the same manuscript
  sentence. It needs an integral action on the source lattice commuting with
  the polarization, plus an equivariance hypothesis on the comparison matrix;
  neither is in the realization structure.
- **Open: the bridge to the rank-eight coordinate model.** The five-member
  `P¹(F₄)` packet classification is proved for the explicit rank-eight
  `F₂`-model, and relative maximal isotropy is now proved for `𝒦_2` inside the
  lattice `𝒟_2`, but the two `𝒟_2`s are different objects in the package: the
  torsion part of a cokernel, and the kernel of the polarization reduced modulo
  two. Identifying them would join two fragments into one chain and is the
  highest-value successor for this row.
- **Open, unchanged: the commutator pairing and the dictionary proposition.**
  As in the previous pass, no route to giving `homologyRealizesRelativeGeometry`
  semantics exists in this package.

## Next

Identify the lattice two-primary discriminant — the two-torsion part of the
cokernel of the source polarization — with the kernel of the polarization
reduced modulo two, which is where the packet classification lives. That single
isomorphism would carry the five-member `P¹(F₄)` classification onto the
lattice model of the isogeny kernel and make the two-primary half of the lemma
a single chain rather than two fragments.
