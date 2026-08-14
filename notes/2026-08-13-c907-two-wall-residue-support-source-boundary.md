# C907 — source boundary for the two-wall residue-support theorem

Date: 2026-08-13

Status: primary-source audit and exact theorem target.  The desired
aggregate residue-support statement is known for crepant toric wall
crossings and for the special weighted weak-Fano discrepant range.  It is
not proved for the non-weak-Fano two-circuit discrepant peaks left by C907.

## 1. What is proved in the crepant toric case

Borisov--Horja identify Mellin--Barnes analytic continuation for a basic
toric birational map with the induced Fourier--Mukai action on `K`-theory.
Han's better-behaved-GKZ theorem removes the rank-jumping defect and proves
the commutative Gamma-series/Fourier--Mukai diagram for both the ordinary and
compactly supported systems.

The useful structural clause is explicit.  Han's Proposition 4.1 says that
the nonessential part is unchanged, while the essential part is a complete
sum of contour residues and is exactly the Fourier--Mukai correction.  Since
the Fourier--Mukai kernel is the graph on the common torus/open set, its cone
from the identity is supported over the toric exceptional locus.  Therefore
the complete residue block has zero common-open rank.

This is precisely the pattern seen integrally in the `dP7` calculation:
individual coordinates can look ambient, but the full residue is the class
of a supported object.

The scope is crepant.  Han works with adjacent subdivisions of a Gorenstein
cone and describes the associated transformation as a flop.  This does not
cover a unit discrepant flip merely because its coefficients are `+/-1`.

## 2. What is proved for general toric discrepancy

Acosta--Shoemaker treat complete toric orbifolds related by an arbitrary GIT
wall crossing with nonzero discrepancy.  Their Theorem 1.1/Theorem 5.7 gives
a `C[z,z^{-1}]`-linear map

\[
 L:H^*_{CR}(X_+)[z,z^{-1}]
   \longrightarrow H^*_{CR}(X_-)[z,z^{-1}]                       \tag{1}
\]

such that the power-series asymptotic expansion of `L I_+` recovers `I_-`.
They emphasize the asymmetric features: the source and target ranks differ,
the target series can have zero radius of convergence, and `L` need not be
invertible.  Their construction uses a completed GKZ system and Watson's
lemma.

This is a real analytic theorem in the required noncrepant direction, but it
does **not** identify (1) with a Fourier--Mukai/window map, a Gamma-integral
lattice, or the rank row.  Thus it supplies the analytic half of the desired
statement, not the common-open support half.

## 3. Iritani and Gu--Yu--Yu

Iritani proves a formal QDM decomposition for general discrepant toric
wall crossings.  His analytic Gamma/Orlov identification is proved for
weighted blowups of weak-Fano compact toric stacks along toric centers.  The
general discrepant Riemann--Hilbert functoriality is posed conjecturally.

Gu--Yu--Yu prove the pairing-compatible full-QDM decomposition for smooth
simple VGIT walls, including every unit standard wall in the chosen AKMW
chain.  Their construction is formal over a Laurent/completed Novikov ring.
It contains no Stokes, sectorial, or Gamma-integral comparison.  C907's
one-wall theorem adds the distinguished rank row only inside that wall's
fixed-sector receiver; it does not compare two incident receivers.

The source packages are therefore complementary but do not overlap on the
load-bearing datum:

| theorem | discrepancy | analytic asymptotics | full QDM/pairing | Gamma/window rank row |
|---|---|---|---|---|
| Borisov--Horja / Han | crepant toric | yes | GKZ | yes |
| Acosta--Shoemaker | general toric | yes | via `I`/GKZ | no |
| Iritani | general toric | formal generally; analytic in special range | yes formally | special weighted weak-Fano range |
| Gu--Yu--Yu | smooth simple VGIT | formal | yes | no analytic comparison |

## 4. The exact new lemma

The missing result can now be stated without any C907-specific packet.

> **Two-wall numerical Fourier--window theorem.**  Let `Y` be the smooth
> projective chamber incident to two semi-free unit discrepant walls in a
> rank-two master, and let `D` be the union of their unstable strata.  Group
> the ray-ordered two-variable Mellin--Barnes residues by unstable stratum.
> After Gamma normalization, every complete residue block in the transition
> between the two iterated Fourier receivers has output in `K_D(Y)`, or at
> least has zero common-open rank.

Equivalently, on the numerical quotient,

\[
 K_0^{num}(Y)/K_{0,D}^{num}(Y),                                  \tag{2}
\]

the analytic two-order transition equals the algebraic window transition,
which is the identity.

This is weaker than the conjectural full discrepant Riemann--Hilbert
functoriality.  It asks for one numerical quotient and permits arbitrary
Stokes coefficients and arbitrary mixing inside each supported block.

## 5. Why this would close Gold

Morelli pi-desingularization makes every wall of the selected fivefold AKMW
chain unit standard.  Ordinary walls, one-wall rank identities, product
compatibility, and the endpoint nonvanishing are already closed.  At a peak,
the theorem above gives

\[
 r_p(T_Y-1)=0                                                     \tag{3}
\]

because `p` lies off `D`.  Equation (3) composes intrinsically and removes
the incompatible-Novikov-chart problem.  No evaluation of a formal variable
at a nonzero point is used.

Conversely, a geometric Gold counterexample is exactly a violation of this
theorem: one complete two-wall residue block must have nonzero common-open
rank.  The incomplete-Gamma model proves that such a block is analytically
possible; the `dP7` product peak proves that coordinatewise ambient terms do
not suffice.

## 6. Bounded proof/falsifier

For each of the two fivefold discrepant wall types `(2,3; curve)` and
`(2,4; point)`:

1. construct the rank-two master and write the two continuous/discrete
   Fourier kernels in a common equivariant parameter ring;
2. take the two iterated contour orders on a common absolute-convergence
   chamber;
3. subtract them and group the multidimensional residues by pole stratum;
4. apply the common-open point lift.  A supported block restricts to zero;
5. if a block survives, its output column is the smallest genuine
   ambient-target counterexample.

The issue is not Fubini on a fixed absolutely convergent contour.  It is the
residue at infinity introduced when one passes between the two discrepant
asymptotic orders.  The theorem says that this infinity residue is still a
window/unstable-stratum class on the output side.

## EJ / TT / AA

- **EJ:** crepant `FM=AC` already proves the desired support pattern; Gold
  asks for only its rank-row shadow in the first noncrepant two-wall case.
- **TT:** Acosta--Shoemaker's map `L` is not Gamma/window calibrated.  Do not
  infer rank preservation from existence or uniqueness of the `I`-function
  asymptotic map.
- **AA:** compute the complete residue at infinity for the smallest
  `(2,3)`/`(2,4)` adjacent pair.  Its common-open rank is the binary verdict.

## Sources

- Lev Borisov and R. Paul Horja, *Mellin--Barnes Integrals as
  Fourier--Mukai Transforms*, arXiv:math/0510486.
- Zengrui Han, *Analytic Continuation of Better-Behaved GKZ Systems and
  Fourier--Mukai Transforms*, arXiv:2305.12241, especially Theorem 1.2,
  Proposition 3.5, and Proposition 4.1/Theorem 4.5.
- Pedro Acosta and Mark Shoemaker, *Gromov--Witten Theory of Toric
  Birational Transformations*, arXiv:1604.03491v2, especially Theorem 1.1/
  Theorem 5.7.
- Hiroshi Iritani, *Global Mirrors and Discrepant Transformations for Toric
  Deligne--Mumford Stacks*, arXiv:1906.00801v2.
- Hsian-Hua Gu, Yuan-Pin Yu, and Zhengyu Yu, *Quantum Cohomology of
  Variations of GIT Quotients and Flips*, arXiv:2508.15770v1.
