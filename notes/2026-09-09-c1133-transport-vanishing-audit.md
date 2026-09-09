# C1133 — transport, parity and surface vanishing

**Date:** 2026-09-09. **Disposition:** written proofs of the local and operation
gates below, relative to the cited QDM constructions and the exact reduced rings
in `2026-09-09-c1133-fixed-base-proof.md`. This is not a completed literature or
manuscript acceptance verdict.

## Projective-bundle equivariance: the missing argument

Let V be an algebraic bundle of rank r on a smooth projective B. Use one common
quotient G of the universal Hodge group, in the Tate-periodized convention, for
H*(B) and H*(P(V)). Leray–Hirsch identifies the latter with the direct sum of
r Tate shifts of H*(B). The class p=c1(O(1)) and all Chern classes of V are
G-fixed. Novikov, z and ramification scalars are fixed as well.
The source assumes V-dual globally generated. As its Remark 1.2 states,
replace V by a sufficiently negative line-bundle twist to arrange this;
P(V) is unchanged. The twist is algebraic and preserves G-equivariance.
Remark 5.2 makes the comparison's vertical-anticanonical splitting intrinsic
to P(V), independently of that choice.

Iritani–Koto v4, Section 5.8, gives the initial coordinate shifts and comparison
maps explicitly in equations (5.11) and (5.12). Its Fourier operators in Section
5.3 use scalar formal operations and multiplication by characteristic classes
of V. Thus they commute with G. Applying such an operator to the unit, taking
its cup-product logarithm, and extracting its z^(-1) coefficient preserves
G-invariance. Consequently every initial shift is fixed, and the initial
comparison Φ° intertwines the full G-representations. These operations also
preserve super parity; assigning odd numerical degree to a ramified scalar
does not make that scalar odd.

Here is why these initial properties persist, rather than merely holding on
the small locus. In the independent occurrence coordinates s_j, Section 5.8
forms a block-diagonal fundamental solution M from the QDMs of B at their fixed
initial shifts. Iritani's Hodge Lemma 7 implies that this fundamental solution
is equivariant with the simultaneous action on its parameter and fiber:

    M(g s) = g M(s) g^(-1).

The specified Birkhoff factorization of (Φ°)^(-1) M has a unique negative
factor normalized by identity and a regular positive factor with its prescribed
initial value. Applying g preserves the coefficient rings, powers of z and
both normalizations. Uniqueness therefore gives equivariance of both factors,
including Φ and its inverse. Finally, the inverse coordinate map is the
z^(-1) coefficient of M'1. Since the unit is fixed, that coordinate map is
equivariant too. Its inverse is consequently equivariant.

This proves full-fiber projective-bundle equivariance directly from the
published construction. KKPY Section 5.2.5 records the corresponding local
G-atom correspondence, consistently with this proof. The argument uses neither
an analogy with blowups nor a claim about invariant vectors alone.

Restrict the equivariant coordinate map and its inverse to fixed loci. They
remain inverse there; in particular each occurrence retains independent unit
and algebraic-divisor coordinates. The direct reduced-ring injection proof in
the fixed-base note now applies. Theorem 5.1 and Remark 5.3 of Iritani–Koto give
regular maps and inverse on the original z-lattices in the homogeneous
completion. Iritani's Theorem 5.18 and Hodge Proposition 8 provide the analogous
blowup input. Thus P1 and the projective-bundle portion of H1 are supplied at
the written-proof level with these coefficient conventions.

## Local cyclic persistence and rank-two transport

Work over a characteristic-zero formal power-series germ over a field, and
separate a cluster from its complement. Center its leading operator by its
mean trace. A cyclic vector at the initial point remains cyclic: its cyclic
determinant is a unit. The commutant is therefore precisely the polynomials
in N of degree less than its rank r, over the same local ring.

For equations z∂z y=(N/z+A0+...)y and ∂t y=(C/z+B0+...)y, flatness gives

    [N,C]=0,   ∂t N=−C+[C,A0]+[B0,N].

Since tr N=0, also tr C=0. Writing C in the centered polynomial basis of the
commutant yields, for p_k=tr(N^k), exactly equation (12.2) of the packet.
Newton identities and Cayley–Hamilton show that each ∂t p_k belongs to the
ideal (p_2,...,p_r). If any p_k had positive lowest total bulk degree m,
a suitable coordinate derivative would have nonzero degree m−1, contradicting
this ideal membership. Hence all p_k vanish, N^r=0, and the cyclic determinant
keeps the Jordan block intact. This proof takes place in the coefficient field's
formal bulk germ; it does not assert persistence under an unrelated singular
specialization. Cai's quartic argument and regular F-manifold theory are prior
context for persistence, not claims newly discovered here.

In rank two, N is self-adjoint for the leading even pairing. Its image L is
an isotropic line and L=L-perp. The next pairing equation evaluated on L twice
implies A0(L)⊂L. Thus the intrinsic elementary modification

    E-sharp = {s in E : s mod z lies in L}

has a logarithmic z-connection. In an adapted frame its residue is
R=((a,ν),(c,d−1)), where c=(A1)21; the derivative correction −1 and the first
connection coefficient c are both essential.

After the modification a centered bulk equation can have only a pole
T/z with T=k E21. Flatness at this pole gives T+[R,T]=0. The diagonal entries
are νk and −νk, so k=0. Thus the bulk equations are regular, and the residue
obeys a Lax equation. Its characteristic polynomial, including the resonant
discriminant, is constant on this germ. No nonresonance premise is used.

A regular comparison with regular inverse carries L to L and therefore
E-sharp isomorphically to E-sharp. Its reduction in modified frames conjugates
the residues. This reduction may involve the original comparison's linear
coefficient in z. The counterexample to the external rank-three triangularity
proposition does not interfere with any step of this rank-two argument.

## Whole primary factors and odd allocation

The spectral idempotents of multiplication by the even Euler element are
elements of the even algebra. Their ideals split the full superalgebra
orthogonally for the Frobenius pairing. The odd pairing is alternating and
nondegenerate on each factor, so each odd dimension is even. Any identity
satisfied by the Euler element on the even algebra holds in the entire algebra:
apply the identity to the unit, then multiply by an arbitrary element.

An even-rank-one factor has even part K e. For odd a,b, write ab=c e.
Supercommutativity gives (ab)^2=0 and hence c=0. The odd pairing vanishes and
nondegeneracy forces the odd part to be zero. Therefore all odd cohomology
belongs to the repeated factor at a 2+1+1 or 3+1 Fano endpoint. This needs
the full superalgebra; it is not inferred from an even matrix alone.

## Surface vanishing without a circular birational argument

For a minimal surface with nef K, first remove the unit Euler shift. With
an Euler insertion of complex degree e≥1, an input of degree p and nonunit
even bulk insertions of degrees d_i≥1, virtual dimension gives output degree

    p+e+sum_i(d_i−1)−c1(S)·β > p.

The inequality follows from nefness. Divisor terms in the Euler bulk part
have zero coefficient, so they introduce no exception. Unit insertions are
removed by the string equation. This reasoning applies to the full fiber and
to either allowed bulk base. The centered operator is strictly degree-raising,
hence has only the eigenvalue zero; its whole even rank is b2+2≥3.

Guéré, arXiv:2603.04518v1, Example 15, already writes the full-fiber
nilpotent matrix on the Hodge-fixed base; this nilpotence is prior work.
The calculation above also covers the full even bulk body.

Rank two cannot occur. Rank three requires b2=1. A nonzero holomorphic one-form
α would then give a nonzero real class [iα∧conjugate(α)] of square zero: its
pairing with a Kähler class is positive, while its square vanishes pointwise.
But H2(S,R) is one-dimensional and generated by a class of positive square.
This contradiction gives q=0; H1 and H3 vanish. Thus the rank-three odd and
Hodge selectors vanish too.

For a curve of genus at least two, quantum multiplication is classical.
In the adapted frame (point class,unit), A0 has diagonal (−1/2,1/2);
the modified residue has both diagonal entries −1/2 and discriminant zero.
For genus one the centered Euler operator is zero. P1 has simple generic
even spectrum. Points and curves therefore contribute no selector.

Ruled surfaces are projective-line bundles over curves, so the already proved
operation comparison gives zero. Rational surfaces have no odd part, and their
rank-two lattice count vanishes by comparison with P2 using point blowups only.
Every remaining projective surface is a point blowup of a minimal nef-K or
ruled surface. This uses the classical minimal-model classification of smooth
projective surfaces; it is an imported geometric input. No fourfold birational
invariance is assumed in proving surface vanishing.

## Consequences and remaining boundary

Independent occurrence-unit shifts give a nonzero resultant for spectra from
different occurrences. Together with faithful occurrence maps and regular
comparisons this proves the packet's additive blowup and projective-bundle
formulas on the stated rings. Surface vanishing then makes these selectors
birationally invariant in dimensions three and four by projective weak
factorization. Equivariant spectral idempotents preserve their representation
classes as in the fixed-base note. The unlabelled safe Hodge sum is invariant
under permutation of algebraic splitting branches; the conservation deduction
does not require an individually labelled factor to descend to Q.

The numerical and Hodge proof routes are now written through this operation
gate. The remaining task is source-level exhaustion and audit of the imported
geometric inputs, the arithmetic and optional branches, and the complete
claim-by-claim literature verdict before author hierarchy review. This report
is not an independent referee reading of the combined manuscript.

## EJ+TT and Mystery ledger

The closeout asks whether any apparent assumption can be weakened for free.
The projective-bundle equivariance proof comes from uniqueness, so it works
for any compatible group action fixing the characteristic classes and the
GW tensors; a new comparison theorem is unnecessary. The unlabelled Hodge
sum also avoids an unnecessary descent claim for each scalar label.

- **Settled here:** projective-bundle full-fiber equivariance; parity distinct
  from ramification degree; noncircular surface vanishing; rank-two Lax transport.
- **Settled scope:** no arbitrary-Novikov-specialization rule, higher-rank
  logarithmic-lattice shortcut, or full-even/fixed-base equality is used.
- **Open:** complete imported-source and priority coverage, optional branches,
  and author review of the accepted theorem hierarchy. These remain C1133.
