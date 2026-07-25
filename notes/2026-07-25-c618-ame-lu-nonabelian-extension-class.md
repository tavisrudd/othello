# C618: nonabelian realized party-permutation extension invariant

**Lane:** `ame-lu`

**Status:** complete

## Result

`RelativeConicArcs.AMELU.NonabelianExtensionInvariant` now packages the
section-free invariant of the realized projective party-permutation
extension
\[
  1\longrightarrow\Gamma\longrightarrow\widetilde\Gamma
    \longrightarrow\Pi_{\mathrm{real}}\longrightarrow1
\]
without assuming that the fixed-party projective group \(\Gamma\) is
abelian.

- Conjugation in \(\widetilde\Gamma\) descends canonically to
  \(\Pi_{\mathrm{real}}\to\operatorname{Out}(\Gamma)\).  The construction
  factors through the quotient map itself and does not choose lifts.
- Every set-theoretic section is normalized by a uniform right correction.
  A normalized section \(s\) has factor set
  \(f_s(\pi,\rho)\) defined by
  \(s(\pi)s(\rho)=f_s(\pi,\rho)s(\pi\rho)\).
- Lean proves normalization, the action defect
  \(\alpha_\pi\alpha_\rho=\operatorname{Inn}(f_s(\pi,\rho))
  \alpha_{\pi\rho}\), and the ordered nonabelian identity
  \[
    f_s(\pi,\rho)f_s(\pi\rho,\upsilon)
      =\alpha_\pi(f_s(\rho,\upsilon))f_s(\pi,\rho\upsilon).
  \]
- If \(s'(\pi)=b(\pi)s(\pi)\), then Lean proves
  \[
    f_{s'}(\pi,\rho)
      =b(\pi)\alpha_\pi(b(\rho))f_s(\pi,\rho)b(\pi\rho)^{-1}.
  \]
  No factor is commuted past another.
- The factor set is trivializable precisely when a normalized change of
  section makes it identically one.  This is equivalent to existence of a
  homomorphic section, hence to splitting.  Trivializability is proved
  independent of the initial normalized section.

The manuscript now states this invariant and proof mechanism in
Corollary `cor:discrete-lu-symmetry`.  It does not call the factor-set
classes an abelian cohomology group and does not infer a split from
generator-by-generator GRS lifts.

## Formal terminals

The abstract short-exact-sequence package supplies
`GroupExtension.outerAction_eq_sectionClass`,
`GroupExtension.sectionAction_mul`,
`GroupExtension.factorSet_associativity`,
`GroupExtension.factorSet_change`,
`GroupExtension.factorSet_trivializable_iff_splitting`, and
`GroupExtension.factorSet_trivializable_iff`.

The realized specialization supplies
`genericPartyPermutationOuterAction`,
`genericPartyPermutationFactorSet`,
`genericPartyPermutationFactorSet_associativity`,
`genericPartyPermutationFactorSet_change`, and
`genericPartyPermutationFactorSet_trivializable_iff_splits`.

## Validation

- Warning-free guarded elaboration of
  `RelativeConicArcs.AMELU.NonabelianExtensionInvariant`.
- Measured single-thread builds of that module,
  `RelativeConicArcs.Gates.AMELUAggregate`, and
  `RelativeConicArcs.Gates.AMELUAggregateAxioms`, followed by the exact
  trace-only aggregate gate.  The terminal run is
  `/home/tavis/.cache/othello-lean-build/run-20260725-235008-a4747832`.
- The audited extension terminals depend only on `propext`,
  `Classical.choice`, and `Quot.sound`.
- Warning-free 19-page manuscript build, complete seven-bundle evidence
  replay, and 35-public/73-formal release-manifest verification.
- PDF: 181,763 bytes; SHA-256
  `a01a9366b1f02a65b4b5f952668f21f405e3f6447fc8dff98e90d81b5150bea5`.
  Pages 6 and 7 passed visual inspection.

## `ej` and Tao closeout

The closeout tested whether the construction had accidentally made the
normalized section part of the invariant.  The outer action was already
defined by descent and hence section-free.  The factor set changes by the
explicit normalized nonabelian coboundary formula, and the added theorem
`GroupExtension.factorSet_trivializable_iff` proves that its splitting
obstruction is independent of the chosen normalized section.

The other tempting strengthening was to turn these gauge classes into an
ordinary second cohomology group.  That would require an abelian kernel and
would erase the inner-action defect recorded by `sectionAction_mul`.
The formal package therefore retains the correct nonabelian factor-set
language.

## Mystery ledger

| Feature | Closeout status | Evidence gap or owner |
|---|---|---|
| Does the outer action depend on chosen product-unitary lifts? | **Settled:** it descends directly along the surjective extension projection, modulo inner automorphisms. | none |
| Is the factor-set obstruction independent of the normalized section? | **Settled:** the ordered change law and `factorSet_trivializable_iff` prove choice independence. | none |
| Can the factor-set classes be treated as an abelian \(H^2\) group? | **Settled negatively at this generality:** \(\Gamma\) is not assumed abelian, and the action itself changes by inner automorphisms. | none |
| Does the GRS/extended-GRS extension split? | **Open:** C613 supplies generator representatives but no normalized cochain trivializing this factor set. | C619 relation audit |

**Vibe check:** the extension story now has the right invariant rather than
only a tautological right-inverse criterion.  The remaining GRS question is
concrete: test the available lifts against the relations, or identify the
metaplectic/Schur-multiplier obstruction.
