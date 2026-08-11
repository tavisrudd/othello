# C904 minimal-class divisor-product indices under elliptic-power gluing

Date: 2026-08-11

Status: exact bounded classification, spectral stabilization theorem, and
three infinite defect families; conceptual all-gluing classification remains open;
quarantined from the Paper V manuscript and Lean

## Executive verdict

The Jordan-scalar theorem is a sufficient theorem, not the beginning of a
universal positive theorem.  Primitive integral divisor-product saturation
can fail for principally polarized abelian varieties isogenous to a power of
a non-CM elliptic curve, already in dimension three.

For a principally polarized `g`-fold `(A,Theta)`, put

\[
  \gamma_A=\frac{\Theta^{g-1}}{(g-1)!},\qquad
  L_A^{g-1}=\operatorname{im}\bigl(
     \operatorname{Sym}^{g-1}\operatorname{NS}(A)
       \longrightarrow H^{2g-2}(A,\mathbf Z)\bigr).
\]

The **minimal-class divisor-product index** is the order of
`gamma_A` modulo `L_A^{g-1}` whenever the class lies in the rational span.
The exact computations prove:

1. there is a principal threefold in the `E^3` isogeny class with defect
   exactly `2`;
2. there is a principal fourfold in the `E^4` isogeny class with defect
   exactly `3`;
3. among all `135` elementary dyadic principal gluings in dimension three,
   `72` have defect one and `63` have defect two;
4. among all `2,295` elementary dyadic principal gluings in dimension four,
   `963` have defect one and `1,332` have defect two; and
5. all elementary ternary gluings in dimensions two and three are primitive
   (`40` and `1,120` cases respectively), but this stops exactly before the
   first possible ternary factorial obstruction in dimension four; and
6. spectral block stabilization propagates exact index two to every
   dimension at least three, exact index three to every dimension at least
   four, and exact index four to every dimension at least five.

The dimension-three counterexample is especially sharp as an isogeny-locus
statement.  Every principally polarized complex abelian threefold has
algebraic minimal class: the indecomposable case is a genus-three Jacobian and
the decomposable case is elementary.  The broad separation between
algebraicity and the integral divisor subring is therefore classical; the
potentially new refinement is its explicit realization inside a non-CM
elliptic-power isogeny locus.

The obstruction is not specifically dyadic.  It appears at primes dividing
`(g-1)!` and is governed by the exterior-product span of the fully lifted
integral divisor lattice.  The exact orders `2` and `3` are the first two
instances.  This turns the former “arbitrary gluing” prospect into a genuine
positive/negative classification problem.

## 1. Universal factorial ceiling

For every principal polarization,

\[
                    \Theta^{g-1}=(g-1)!\,\gamma_A.
\]

The left side is a divisor product.  Hence the cyclic obstruction generated
by `gamma_A` has exponent dividing `(g-1)!`.  In particular no prime
`p>g-1` can occur.  This explains the exact threshold in the bounded data:
`p=2` first appears in dimension three, and `p=3` first appears in dimension
four.

For a literal product `E^g` with `End(E)=Z`, the obstruction always vanishes,
for every principal polarization.  Here
`NS(E^g)=Sym_g(Z)`.  If `G` is the unimodular polarization matrix, write
`a=adj(G)`.  Primitive elliptic graph classes `C_v` are complete
intersections of `g-1` divisors, and the rank-one matrices `vv^t` span
`Sym_g(Z)`.  The identity

\[
 \gamma_A=\sum_i a_{ii}C_{e_i}
 +\sum_{i<j}a_{ij}
   (C_{e_i+e_j}-C_{e_i}-C_{e_j})
\]

therefore gives an integral divisor-product expression.  The obstruction is
created by descent through an isogeny, not by a non-product principal
polarization on the literal power.

Within the standing non-CM elliptic-power setting, this immediately gives a
useful composite-degree theorem.  Let
\(f:E^g\to A\) be any isogeny of degree \(D\) onto a principally polarized
abelian variety.  On the source, \(f^*\gamma_A\) is represented by the
integral adjugate of the polarization matrix and hence by an integral signed
sum of graph elliptic complete intersections.  At every prime not dividing
\(D\), the isogeny identifies the integral homology and divisor lattices.
Consequently the defect order divides

\[
  \prod_{p\mid D}p^{v_p((g-1)!)}.                         \tag{1.1}
\]

In particular it vanishes whenever \(D\) is coprime to \((g-1)!\).  Thus
small-prime isogeny descent is the only possible source of a defect, for an
arbitrary composite isogeny as well as for the prime gluings below.

For a quotient of the source polarization `pI_g` by an arbitrary maximal
isotropic subgroup, one can say more.  The quotient isogeny has `p`-power
degree, so after localization at every `q != p` it identifies both homology
and Néron--Severi lattices with those of the literal power.  Therefore the
defect has no prime-to-`p` part, and

\[
  \operatorname{ord}(\gamma_A\bmod L_A^{g-1})
       \mid p^{v_p((g-1)!)}.                              \tag{1.2}
\]

In particular every prime-`p` gluing is primitive in the safe range `p>=g`.
At the first wall `p<=g-1<2p`, put `P=L_A^{g-1}` and let `S` be its saturation
inside the integral Hodge lattice.  The exact obstruction is the
coordinate-free Tor boundary, which we call the internal divided-power
Bockstein,

\[
 \beta_{p,K}=p\gamma_A\pmod {pP_p}
   \in\ker(P_p/pP_p\longrightarrow S_p/pS_p).
\]

It vanishes exactly when the primitive minimal class belongs to the local
divisor-product lattice.  This is secondary integral information internal to
the Lefschetz subring; it is not an ordinary ambient Steenrod square or an Arf
invariant.

The localization statement for Néron--Severi lattices uses Lefschetz
\((1,1)\): the isogeny preserves the rational Hodge subspace, and at a prime
away from its degree it identifies the integral degree-two lattices inside
that subspace.  Cup products then identify the localized divisor-product
lattices.  Membership in the saturated lattice is local at every prime, so
these local statements globalize without an extra descent factor.

## 2. Graph gluings and the exact local congruence

Let `E` be a complex elliptic curve without complex multiplication.  Start
with `E^g` carrying `p` times the product polarization.  Choose the standard
Lagrangian decomposition

\[
                      E[p]^g=U\oplus U^*,
                      \qquad U\cong\mathbf F_p^g.
\]

For a symmetric matrix `T in Sym_g(F_p)`, its graph is a maximal isotropic
subgroup.  The quotient by this graph inherits a principal polarization.
On homology its principal graph basis is

\[
 B_T=\begin{pmatrix}p^{-1}I&p^{-1}T\\0&I\end{pmatrix}.
\]

An integral symmetric coefficient matrix `C` defines a divisor on the
quotient exactly when

\[
                  C=pD,\qquad DT=TD\pmod p.                 \tag{2.1}
\]

Indeed, pairing a graph half-vector with each standard cycle forces
`C=0 mod p`; pairing two graph half-vectors then gives the commutator
condition.  Conversely those two congruences make the alternating form
integral on the graph basis.  Thus the leading additive Néron--Severi space is
the symmetric centralizer

\[
 R_T=\{D\in\operatorname{Sym}_g(\mathbf F_p):DT=TD\}.
\]

The reduced centralizer is not the whole product invariant.  For an integral
lift \(\widetilde D\), the transformed divisor form retains the carry term

\[
 (\widetilde D\widetilde T-\widetilde T\widetilde D)/p\pmod p.
\]

The exact criterion is membership of the minimal class in the exterior-
product span of these fully lifted integral divisor forms.  At `p=2` the
square of every reduced alternating form vanishes, so this lifted span
contains secondary information invisible to the additive centralizer.  At
general small primes it records the failure of ordinary powers to realize the
corresponding divided class integrally.  An intrinsic cofactor, spinor, or
matroid formula for the carry-sensitive span remains open.

“Non-scalar” is not the right invariant: the exotic `F_4` cubic gluing is
non-scalar and primitive, whereas the examples below are non-scalar and
defective.

## 3. Smallest exact counterexamples

### Dyadic dimension three

Take

\[
 T_2=\begin{pmatrix}
 0&0&1\\0&0&1\\1&1&0
 \end{pmatrix}\in\operatorname{Sym}_3(\mathbf F_2).
\]

It is regular nilpotent: its characteristic and minimal polynomials are both
`x^3`.  For the principal graph quotient, the complete integral
Néron--Severi lattice has rank six, its 21 quadratic divisor monomials span
the full rational six-dimensional Hodge space, and `gamma_A` has exact order
two modulo their integral lattice.

### Ternary dimension four

Take

\[
 T_3=\begin{pmatrix}
 1&1&0&0\\
 1&1&2&2\\
 0&2&1&0\\
 0&2&0&1
 \end{pmatrix}\in\operatorname{Sym}_4(\mathbf F_3).
\]

Its characteristic polynomial is `(x-1)^4` and its minimal polynomial is
`(x-1)^3`.  For the principal graph quotient, the complete integral
Néron--Severi lattice has rank ten, its 220 cubic divisor monomials span the
full rational ten-dimensional Hodge space, and `gamma_A` has exact order
three modulo their integral lattice.

The independent replay constructs the preimage of `R_T` in
`Sym_g(Z)` directly from (2.1), pulls the divisor forms to the principal
graph basis, and computes the exact product lattice.  It does not import the
all-Lagrangian census or its lattice-construction routine.

## 4. Exhaustive small-rank census

For coefficient Gram `pI_g`, the primary certificate enumerates every
Lagrangian in the `2g`-dimensional discriminant symplectic space for

\[
             (p,g)=(2,2),(2,3),(3,2),(3,3).
\]

The expected count

\[
                       \prod_{i=1}^g(p^i+1)
\]

is checked in every case.  For each Lagrangian the program constructs the
principal integral homology lattice, the complete integral Néron--Severi
lattice, all `(g-1)`-fold divisor products, and the exact order of the
minimal class in their rational span.

In the dyadic dimension-four case, the 2,295 Lagrangians split into 57
orbits under the integral cohomological source symmetries
`S_4 x GL_2(F_2)`.  The certificate performs the expensive divisor-product
calculation on one representative of every orbit, checks that the orbits
cover the full Lagrangian set, and weights the results by their exact sizes.
There are 24 primitive orbits and 33 defective orbits, with weighted counts
963 and 1,332.

Here `S_4` permutes coefficient axes, while `GL_2(F_2)` is the reduction of
the diagonal `SL_2(Z)` action on the two homology directions.  It preserves
the alternating form and fixes the coefficient Hodge tensors, so it carries
both the divisor-product lattice and the minimal class isomorphically.  It
need not be an automorphism group of one fixed complex elliptic curve; the
cohomological formulation is the precise one needed for orbit weighting.

The census also shows that Smith type, reduced Néron--Severi image, elementary
relative position, and scalar/non-scalar status do not separately classify
the obstruction.  In dyadic dimension three there are 11 source-symmetry
orbits: seven primitive and four defective.  A complete criterion must retain
the lifted integral forms and their carry terms, not only the additive
lattice.

## 5. Mathematical significance and venue ceiling

The result separates three statements that had been easy to conflate:

1. the minimal class is algebraic;
2. the rational Hodge ring is generated by divisors; and
3. the primitive integral minimal class lies in the ordinary integral
   divisor-product subring.

The first two may hold while the third fails.  In dimension three this gives
an explicit non-CM elliptic-isogeny-locus realization of the classical
algebraic/product-subring separation, with exact divisor-product index two.
The ternary fourfold result is presently a cohomological divisor-product
index; algebraicity of its primitive minimal class is not asserted.  On the
exotic `A5` fivefold the primitive class is divisor-generated,
but the separate non-axis audit shows it is not generated by elliptic curves.
Together these results show that both isogeny descent and support dimension
carry independent integral information invisible to rational decomposition.

As it stands, the exact counterexamples plus the bounded classification are a
strong component, not an Annals or Inventiones theorem by themselves.  The
Annals-shaped successor is:

> Classify, prime by prime, the minimal-class divisor-product index of every
> principal Lagrangian gluing in an elliptic-power isogeny class, in terms of
> an intrinsic invariant of its carry-sensitive lifted exterior-product
> lattice.

The Jordan-scalar theorem is then the uniform positive stratum; the matrices
above are the first negative strata; and the exotic `F_4` gluing is a
non-scalar positive stratum.  A proof for arbitrary prime powers, together
with an intrinsic finite-geometric invariant and realization of every allowed
defect, would be genuinely Annals-adjacent and plausibly Annals-scale.

The bounded literature audit in
`2026-08-11-c904-elliptic-isogeny-divisor-saturation-audit.md` finds no
predecessor for an in-isogeny-locus integral divisor-product defect.  Existing
results give rational Lefschetz generation, algebraicity/IHC, or statements
after inverting factorial and polarization degrees.  This remains a bounded
negative: MathSciNet and full forward-citation closure are not complete.

The separate stabilization theorem
`2026-08-11-c904-spectral-stabilization-defect-towers.md` upgrades the two
isolated defects to infinite families and realizes a genuine second
two-primary layer.  Its order-four regular-nilpotent fivefold has both curve
and top divided classes of exact index four; adjoining a spectrally disjoint
scalar graph block preserves the exact index by integral fibre retraction.
The same argument gives the order-two and order-three towers.  This makes the
factorial ceiling provably nonsquarefree and leaves arbitrary height,
indecomposable realization, and an intrinsic carry-sensitive classification
as the three high-value gates.

## 6. Reproducibility

From `/home/tavis/src/othello`:

```bash
diff -u notes/2026-08-11-c904-arbitrary-lagrangian-minimal-class.out \
  <(nix shell nixpkgs#sage -c sage -c \
    'exec(preparse(open("notes/2026-08-11-c904-arbitrary-lagrangian-minimal-class.sage").read()))')

diff -u notes/2026-08-11-c904-arbitrary-lagrangian-minimal-class-replay.out \
  <(nix shell nixpkgs#sage -c sage -c \
    'exec(preparse(open("notes/2026-08-11-c904-arbitrary-lagrangian-minimal-class-replay.sage").read()))')
```

The primary certificate is a complete deterministic enumeration on the
printed domain.  The independent replay verifies the two counterexamples by
the graph-centralizer route.  Neither finite computation proves the proposed
all-prime classification.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `2026-08-11-c904-arbitrary-lagrangian-minimal-class.sage` | 15,716 | `e39a9349ce4749d2bc9142de737dde443cc109e0fb08c53a90c9b993a329ff5a` |
| `2026-08-11-c904-arbitrary-lagrangian-minimal-class.out` | 1,670 | `864ae6a21488141a61998d957ec2e0b8e172790f752d463dc8949764d104e7d1` |
| `2026-08-11-c904-arbitrary-lagrangian-minimal-class-replay.sage` | 5,573 | `3e6bc2112b179a1712e9e0e8573da9ab6a71d3baa3985935f61cbff3038351a5` |
| `2026-08-11-c904-arbitrary-lagrangian-minimal-class-replay.out` | 178 | `377278495b429bbef3667b082981f8699a49ee3a755ef7f34a89e6ed069762a4` |

## Mystery ledger

- **Exact intrinsic obstruction:** open.  The lifted exterior-product
  criterion is exact but still coordinate-algebraic.  The target is a
  characteristic class retaining the integral carry data, perhaps in
  spinor/Maslov coordinates; no Lagrangian-matroid formula is yet proved.
- **Counts `72/63` and `963/1332`:** unexplained.  They are not determined by
  the elementary intersection dimensions, Néron--Severi Smith type, or its
  mod-two image.
- **Prime-power defects:** open.  The first defects have orders `2` and `3`;
  it is not known here whether higher `p`-power defects occur.
- **Uniform defective family:** open.  The displayed regular-nilpotent
  representatives give the dyadic defect in dimensions three and four; the
  script counts all such slopes but has not proved their orbit equivalence or
  defect uniformity.  The exact all-dimension and all-prime construction
  remains to be proved.
- **Geometric realization in dimension three:** algebraicity is automatic,
  but an explicit genus-three curve/model for the displayed isogeny gluing has
  not been identified.
- **Exotic positive stratum:** the `F_4` cubic gluing is primitive despite
  being non-scalar.  Which finite-geometric feature kills its divided-power
  obstruction remains unexplained.

The `ej`/`tt` closeout converted the failed universal conjecture into this
classification problem, found the first in-locus counterexamples, and exposed
the small-prime divided-power mechanism.  No additional divisor saturation,
elliptic averaging, or Brauer/cusp computation can replace the remaining
classification theorem.
