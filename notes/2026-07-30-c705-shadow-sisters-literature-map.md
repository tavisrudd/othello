# C705 situational literature map — Clebsch shadow sisters

**Lane:** `clebsch`

**Date:** 2026-07-30

**Scope:** orientation for continued mining, not a novelty or priority audit.

## Provisional vocabulary

The proved pair may be called the **Clebsch shadow sisters**: the Segre and
Igusa polar five-spaces \(q\) and \(W\), joined by the C705 mixed Jacobian
\(A\) and the exact identity
\[
  \operatorname{adj}(A)=6Wq^{\mathsf T}.
\]
“\(E_8\) shadow sisters” remains conjectural until \(q,W,A\) lift
simultaneously through the exact golden/\(E_8\) operator linkage of C682.

## What is already exceptional

### Representation theory

1. The construction uses the exceptional outer automorphism of \(S_6\),
   not merely ordinary coordinate permutation symmetry.
2. The source and target are the two outer-related five-dimensional
   carriers.  Howard--Millson--Snowden--Vakil make the outer action in the
   six-point Segre/Igusa models explicit.
3. Kraft's multiplicity computation makes the signed outer Joubert cubic
   the lowest-degree covariant of its type and unique up to scale.
4. C705 finds a second minimality: the outer-standard sextic first occurs
   in the third compound, with multiplicity one.

### Extremal and dual singular geometry

1. The Segre cubic is the maximally nodal cubic threefold, with ten nodes,
   and its projective dual is the Igusa quartic.
2. The Igusa singular locus is the union of fifteen lines; the Segre cubic
   contains fifteen distinguished planes.
3. The polar map is birational, is undefined exactly at the ten Segre
   nodes, and contracts the fifteen Segre planes to the fifteen Igusa
   singular lines.
4. Beckmann--Belmans lift the classical duality to homological projective
   duality between small resolutions of the Segre cubic and the Coble
   fourfold ramified over the quartic.  Thus the pairing survives beyond
   ordinary projective duality.

### Two complementary moduli contractions

Moon identifies the Segre cubic and Igusa quartic as the two classical
symmetric birational models of \(\overline M_{0,6}\):

- the Segre contraction collapses the \(B_3\) boundary;
- the Igusa/Veronese contraction collapses the \(B_2\) boundary.

Moon explicitly remarks that a concrete description of their projective
dual map through \(\overline M_{0,6}\) would be interesting.  C705's two
kernel lines and adjugate factorization should be tested as an operator
answer to that prompt.

Schock supplies a stronger exceptional-parent statement.  In Naruki's
\(W(E_6)\)-equivariant compactification of marked cubic-surface moduli,
each of the 36 \(A_1\) boundary divisors is an
\(\overline M_{0,6}\).  The two \(W(E_6)\)-equivariant contractions
restrict on such a divisor to the Segre and Igusa contractions,
respectively.  Therefore the sisters have a literature-backed common
\(E_6\) birational parent.

C705 now upgrades this to an operator statement.  In Yoshida's
ten-dimensional \(W(E_6)\)-equivariant Coble system, the five coordinates
surviving on an \(A_1\) boundary give the Segre cubic and the first normal
coefficients of the five coordinates divisible by the conic equation give
the Igusa polar vector:
\[
 M\nabla S=-2f,\qquad \det M=32.
\]
The raw jet has class \(L_{\rm Igu}+B_3\); simple vanishing on one generic
\(B_3\), propagated by \(S_6\), supplies the canonical common \(B_3\)
factor and closes the global lift.

### Multiple higher parents

1. Kondō realizes the Segre-to-Igusa dual map by a five-dimensional
   Borcherds linear system on a complex-ball quotient.  The real lattice
   displayed there is \(A_2\oplus A_2(-1)^3\), and the ball is a sub-ball
   of the marked-cubic-surface ball.
2. Kondō realizes an \(S_6\)-equivariant degree-16 map in the reverse
   direction from Igusa to Segre using type-IV/Kummer automorphic data.
3. Nguyen realizes Segre--Igusa duality as an exact invariant
   linear-section shadow of the dual Coble cubic and Coble sextic
   associated with a genus-two curve.  The cubic restricts to Segre, its
   polar map restricts to the Segre Gauss map, and the sextic restricts
   scheme-theoretically as \(L^2I_4\).  Thus the genus-two Coble pair is
   an elder dual parent, not merely an analogous ambient variety.
4. The common parent is therefore not unique at the level of moduli
   interpretations.  A genuine \(E_8\) claim must lift the actual
   operators, not merely embed the varieties into another exceptional
   geometry.

The strict operator test separates this parent from a new sister.
At a general conormal pair the Coble Hessians induce mutually inverse
second fundamental forms on the projective tangent spaces, so their
mixed differential has corank zero.  Its affine-tangent composition is
scalar plus rank one, \(BA=\lambda I+x\otimes d\lambda\), rather than a
corank-one matrix whose adjugate pairs the two polar lines.  The
fixed-minus section instead gives the Weddle-to-Kummer double cover.
Its Jacobian determinant is the Weddle quartic and its third compound is
rank one on ramification, but only the Kummer conormal is a polar factor;
the other is the fold direction.  This makes Weddle--Kummer an inherited
ramification shadow, not an independent sister.

### Operator properties added by C705

These are the task's findings, not claims extracted from the literature.

1. The mixed Jacobian has corank one generically and two canonical kernel
   lines: the source residual-\(\mathfrak{sl}_2\) direction \(q\) and the
   target polar vector \(W\).
2. Its full adjugate factors as the outer product of those lines with the
   exact integral scalar \(6\).
3. All one hundred entries of the third compound span a 70-dimensional
   degree-six space, but its relevant outer five-space occurs exactly
   once.
4. The pulled-back polar base locus is the reduced union of twenty
   triple-collision planes, paired over the ten Segre nodes.
5. The inverse polarity has exceptional divisor
   \(e_5=0\), the reduced union of the fifteen Segre planes.
6. The descended identity distinguishes characteristics \(2,3,5\):
   rank collapses at \(2\) and \(3\), while the polar identity remains
   nondegenerate at \(5\) although the golden eigenspace splitting
   ramifies there.

## Common-\(E_8\) verdict after the sweep

The literature and exact first-jet calculation support the chain
\[
  \text{Segre/Igusa sisters}
  \subset \overline M_{0,6}
  \subset \overline Y(E_6)
\]
at the level of birational models, contractions, and the boundary
first-normal jet.  It also supports
separate \(A_2\)-lattice, type-IV, genus-two/Coble, and homological
projective-duality lifts.

The subsequent Lie-\(E_8\) alternative-attack pass found a genuine ambient
route that this first sweep missed.  Rains--Sam use the Vinberg grading
\[
 \mathfrak e_8=\mathfrak{sl}_9\oplus\bigwedge^3 9\oplus\bigwedge^6 9
\]
and construct the genus-two Coble sextic and dual cubic from a stable
trivector.  Nguyen's fixed section then supplies Segre--Igusa.  Thus an
ambient Lie-\(E_8\) parent is literature-backed.  No consulted source
performs the stricter marked comparison from that trivector to C704's
Joubert tensor and C705's mixed Jacobian.  Exact alternative attacks:
`notes/2026-07-30-c705-lie-e8-alt-attacks.md`.

The exact task-owned affine-\(E_8\) entry point remains C682: its degree-ten
Klein return reconstructs the same six-axis conference matrix \(C\), and
hence the Clebsch orientation cubic.  That gate is now positive: the
universal potential of the returned Joubert tensor has mixed Hessian \(A\)
and null projections \(q,W\).  The stronger Lie-\(E_8\) gate is to identify
the Vinberg trivector's ordered Weierstrass marking with this frozen tensor.
A bare Weyl-group inclusion remains too weak.

## Nearest mining consequences

1. **\(E_6\) first.** Settled positively: the value and normal-jet halves
   of Yoshida's ten-dimensional system give the Segre and Igusa systems,
   and the compactification discrepancy is exactly the canonical \(B_3\)
   fixed factor.
2. **Moon's concrete-duality prompt.** Reformulate \(q\) and \(W\) as the
   tangent directions killed by the two complementary contractions of
   \(\overline M_{0,6}\).  Then interpret
   \(\operatorname{adj}(A)=6Wq^{\mathsf T}\) as the rank-one comparison
   of their differential systems.
3. **Mixed-Hessian formulation.** For
   \(F(x,y)=\sum_T y_TZ_T(x)\), test whether \(A\) is the intrinsic mixed
   Hessian after quotienting the two scalar directions.  The
   higher-polar/mixed-Hessian literature gives vocabulary, but the sweep
   found no matching Segre--Igusa factorization.
4. **Double-six bridge.** Dolgachev's determinantal discussion relates
   adjugate kernel lines, six-nodal cubic threefolds, and ordered
   double-sixes.  This is the closest literature bridge from C705 to the
   planned marked-double-six package.
5. **Derived shadow.** Ask whether the rank-one adjugate supplies a
   concrete kernel/cokernel map compatible with the known homological
   projective duality.  This is higher risk but now has a precise target.

## Sources and read depth

- Howard--Millson--Snowden--Vakil, *A description of the outer
  automorphism of \(S_6\), and the invariants of six points in projective
  space*, arXiv:0710.5916 — `full text`, revisited §§1.6, 2.1, 2.3,
  2.4; cached SHA-256
  `d2da258cd8513a9b782a8270baa82acc51bc8d552e18db104967c2a08bffebfc`.
- Hanspeter Kraft, *A Result of Hermite and Equations of Degree 5 and 6*,
  arXiv:math/0403323 — `partial`, Theorem B and §§2, 5; cached SHA-256
  `969440e0bedbc70fa9c2d97720407c9d7da821179aa5141b75b050a3c79afbec`.
- Shigeyuki Kondō, *The Segre cubic and Borcherds products*,
  arXiv:1110.1126 — `partial`, introduction and targeted §§2, 3, 6;
  cached SHA-256
  `0595df2ed7631ba366b1603aca9a924ef08cb93cdc84b906f2877b68c777e9be`.
- Shigeyuki Kondō, *Igusa quartic and Borcherds products*,
  arXiv:1406.2394 — `targeted web full text`, introduction and
  Theorems 8.9--8.10.
- Han-Bom Moon, *Mori's program for \(\overline M_{0,6}\) with symmetric
  divisors*, arXiv:1403.7224 — `targeted web full text`, introduction,
  Theorem 5.2, Remarks 5.3--5.5.
- Nolan Schock, *The \(W(E_6)\)-invariant birational geometry of the
  moduli space of marked cubic surfaces*, arXiv:2309.15264v2 —
  `targeted PDF full text`, introduction, Theorem 3.6 and Remark 3.7;
  cached SHA-256
  `67c1f52c6df71abfb0a537aa55111929d05f812180070e891121d37440c896e5`.
- Masaaki Yoshida, *A \(W(E_6)\)-equivariant projective embedding of the
  moduli space of cubic surfaces*, arXiv:math/0002102 — `targeted full
  text`, §§2.2, 2.5, 3; cached SHA-256
  `1989e8d6349338045851d9d8428394ba7638689f903a1ebe1deffc78ab5485c5`.
- Igor Dolgachev, *Corrado Segre and nodal cubic threefolds*,
  arXiv:1501.06432 — `targeted web full text`, §§2--4.
- Quang Minh Nguyen, *Vector bundles, dualities, and classical geometry
  on a curve of genus two*, arXiv:math/0702724 — `abstract/metadata`.
- Thorsten Beckmann and Pieter Belmans, *Homological projective duality
  for the Segre cubic*, arXiv:2202.08601 — `targeted web full text`,
  introduction and main theorem.
- Alexandru Dimca, Rodrigo Gondim, Giovanna Ilardi, *Higher order
  Jacobians, Hessians and Milnor algebras*, arXiv:1902.09146 —
  `abstract/metadata`.
- Rainelly Cunha, Zaqueu Ramos, Aron Simis, *Degenerations of the generic
  square matrix. Polar map and determinantal structure*,
  arXiv:1610.07681 — `abstract/metadata`.
- Eric M. Rains and Steven V. Sam, *Vector bundles on genus 2 curves and
  trivectors*, arXiv:1605.04459 — `targeted full text`, introduction,
  Theorem 5.4, and Remarks 5.5--5.8 for the stable-trivector Coble
  construction and the explicit Lie-\(E_8\) Vinberg grading.
- Eric M. Rains and Steven V. Sam, *Invariant theory of
  \(\bigwedge^3(9)\) and genus 2 curves*, arXiv:1702.04840 —
  `abstract/metadata` for the arithmetic trivector reconstruction.
- Laurent Gruson, Steven V. Sam, and Jerzy Weyman, *Moduli of Abelian
  varieties, Vinberg theta-groups, and free resolutions*,
  arXiv:1203.2575 — `abstract/metadata` for the Vinberg representation
  source.
- Vladimiro Benedetti, Laurent Manivel, and Fabio Tanturri, *The geometry
  of the Coble cubic and orbital degeneracy loci*, arXiv:1904.10848 —
  `introduction/metadata` for the Lie-theoretic Coble placement.
- Yairon Cid-Ruiz et al. and related Jacobian-dual/Rees-algebra papers
  surfaced only at `abstract/metadata`; none was used for a mathematical
  claim here.

## Bounded searches run

Search families included the following exact themes:

- `"Segre cubic" Jacobian adjugate Igusa quartic`
- `Joubert covariant Jacobian minors Igusa quartic`
- `"Segre cubic" "third compound" polar map`
- `Segre cubic Igusa quartic duality M0,6 GIT boundary divisors`
- `binary sextic Joubert covariant Segre cubic Igusa quartic`
- `mixed Hessian adjugate factorization polar maps`
- `E8 Clebsch invariant Segre cubic Igusa quartic`
- `marked cubic surfaces E6 root lattice Segre cubic six points`
- `Del Pezzo moduli via root systems E8 M0,6 boundary`
- `E8 Coble cubic Coble sextic genus two`

The formula-level queries found no direct match for the C705 third-compound
or adjugate identity.  Because this pass did not inspect all results at
formula level or close citations, that observation is only a search lead.
