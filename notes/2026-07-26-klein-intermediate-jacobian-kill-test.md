# The Klein cubic/intermediate-Jacobian lift: kill test and surviving program

**Status:** research note  
**Date:** 2026-07-26

## Executive conclusion

Let \(X\) be the Klein cubic threefold, \(J(X)\) its intermediate Jacobian, and
\[
G=\operatorname{Aut}(X)\cong \mathrm{PSL}_2(11).
\]
The originally proposed first test asked whether
\[
H^3(X,\mathbf Q)\cong H^1(J(X),\mathbf Q)(-1)
\]
contains a two-dimensional \(G\)- or \(A_5\)-stable arithmetic carrier that could realize the finite golden orientation structure.

The answer has two parts.

1. **There is no two-dimensional \(G\)-stable or \(A_5\)-stable rational sub-Hodge structure.** In particular, there is no equivariant elliptic abelian subvariety carrying the orientation.
2. **There is a canonical two-dimensional \(A_5\)-multiplicity Hodge structure.** It is not a subspace of \(H^1\); it is the multiplicity space in
   \[
   H^1(J(X),\mathbf Q)|_{A_5}\cong W_5\otimes U,
   \qquad \dim_{\mathbf Q}U=2,
   \]
   where \(W_5\) is the rational irreducible five-dimensional representation of \(A_5\).

Thus the naive abelian-subvariety formulation fails, but the characteristic-zero bridge survives in a more precise form. The next question is whether the **relative position of the two distinguished \(A_5\) parents** inside \(G\) recovers the golden field \(\mathbf Q(\sqrt5)\) or the orientation torsor, while the multiplicity Hodge structure itself carries CM by \(\mathbf Q(\sqrt{-11})\).

The distinction between a subobject and a multiplicity object is essential. Searching only for invariant elliptic factors would miss the surviving carrier.

## 1. Background

For a smooth cubic threefold \(X\),
\[
J(X)=H^{1,2}(X)/H^3(X,\mathbf Z)
\]
is a principally polarized abelian variety of dimension five, and
\[
H^1(J(X),\mathbf Q)\cong H^3(X,\mathbf Q)(-1).
\]
The Klein cubic may be written
\[
x_0x_1^2+x_1x_2^2+x_2x_3^2+x_3x_4^2+x_4x_0^2=0.
\]
Its full automorphism group is \(\mathrm{PSL}_2(11)\).

Roulleau computes the period lattice of \(J(X)\) explicitly. If
\[
\nu=\frac{-1+\sqrt{-11}}2,
\qquad
\mathcal O_K=\mathbf Z[\nu],
\qquad
K=\mathbf Q(\sqrt{-11}),
\]
then the lattice is a rank-five \(\mathcal O_K\)-module. In particular,
\[
J(X)\sim E^5
\]
for an elliptic curve \(E\) with CM by \(\mathcal O_K\). This is an isogeny statement; the principal polarization is not thereby identified with the product polarization. Roulleau gives both the actual lattice and the Hermitian form defining the principal polarization.

This already reveals two arithmetic scales:

- a ten-dimensional rational Hodge structure;
- a two-dimensional CM building block with field \(K=\mathbf Q(\sqrt{-11})\).

The issue is whether the latter occurs equivariantly as a subobject, or only as a multiplicity object.

## 2. The representation-theoretic kill test

### Proposition 2.1

As a complex \(G=\mathrm{PSL}_2(11)\)-representation,
\[
H^{1,0}(J(X))\cong V_5,
\]
where \(V_5\) is an irreducible five-dimensional representation, and
\[
H^1(J(X),\mathbf Q)\otimes_{\mathbf Q}\mathbf C
\cong V_5\oplus\overline{V_5}.
\]

The character field of \(V_5\) is \(\mathbf Q(\sqrt{-11})\). The two summands are Galois conjugate.

#### Justification

Griffiths residue theory identifies \(H^{2,1}(X)\) with the five-dimensional linear representation defining the cubic, up to the determinant twist. For the Klein action the determinant twist does not change the relevant irreducible type. Hartlieb records the two conjugate degree-five characters of \(\mathrm{PSL}_2(11)\); on the two order-eleven classes their values are
\[
\frac{-1+\sqrt{-11}}2,
\qquad
\frac{-1-\sqrt{-11}}2,
\]
in opposite order. Roulleau's period calculation produces the same quadratic field.

### Corollary 2.2

\(H^1(J(X),\mathbf Q)\) has no nonzero proper \(G\)-stable rational subspace. In particular, it has no two-dimensional \(G\)-stable rational sub-Hodge structure.

#### Proof

The pair \(V_5,\overline{V_5}\) is one Galois orbit of complex irreducible representations. Its rational hull is therefore the ten-dimensional rational irreducible representation associated with that orbit. A rational \(G\)-subrepresentation would complexify to a Galois-stable sum of complex constituents. The only such sums are \(0\) and
\[
V_5\oplus\overline{V_5}.
\]
Hence the rational representation is irreducible. ∎

### Consequence for abelian subvarieties

If \(A\subset J(X)\) were a positive-dimensional \(G\)-stable abelian subvariety, then \(H^1(A,\mathbf Q)\) would be a nonzero proper \(G\)-stable rational sub-Hodge structure of \(H^1(J(X),\mathbf Q)\). Corollary 2.2 excludes this.

The decomposition \(J(X)\sim E^5\) does not contradict this. It supplies many elliptic factors after choosing an isogeny decomposition, but no such factor is preserved by the full \(G\)-action.

## 3. Restriction to \(A_5\)

Let \(H\cong A_5\) be one of the icosahedral subgroups of \(G\).

### Proposition 3.1

The restriction of \(V_5\) to \(H\) is the irreducible rational five-dimensional representation \(W_5\) of \(A_5\). Consequently,
\[
H^1(J(X),\mathbf Q)|_H\cong W_5\oplus W_5.
\]

#### Proof

The character of \(V_5|_H\), on the \(A_5\) classes of orders
\[
1,\ 2,\ 3,\ 5,\ 5,
\]
has values
\[
5,\ 1,\ -1,\ 0,\ 0.
\]
This is the irreducible character \(\chi_5\) in the \(A_5\) character table. It is rational-valued and has Schur index one, hence is realized by a rational irreducible representation \(W_5\).

Both \(V_5\) and \(\overline{V_5}\) restrict to this same representation because their character values differ only on the two order-eleven classes, which do not meet \(A_5\). Therefore the rational ten-dimensional representation restricts as two copies of \(W_5\). ∎

### Corollary 3.2

There is no two-dimensional \(A_5\)-stable rational sub-Hodge structure of \(H^1(J(X),\mathbf Q)\), and hence no \(A_5\)-stable elliptic subvariety of \(J(X)\).

Indeed, every rational \(A_5\)-subrepresentation of \(W_5\oplus W_5\) has dimension divisible by five.

## 4. The surviving two-dimensional carrier

Define
\[
U_H=\operatorname{Hom}_H\!\left(W_5,H^1(J(X),\mathbf Q)\right).
\]
By Proposition 3.1,
\[
\dim_{\mathbf Q}U_H=2
\]
and the evaluation map gives
\[
W_5\otimes U_H\xrightarrow{\sim}H^1(J(X),\mathbf Q)
\]
as rational \(H\)-representations.

Because the \(H\)-action is by Hodge automorphisms, the Hodge cocharacter commutes with \(H\). It therefore acts on the multiplicity factor \(U_H\). Equivalently, \(U_H\) inherits a weight-one rational Hodge structure after viewing \(W_5\) as a weight-zero Artin factor. Up to isogeny, this is the two-dimensional Hodge structure \(H^1(E,\mathbf Q)\) of the CM elliptic curve appearing in
\[
J(X)\sim E^5.
\]

This gives the correct replacement for the failed invariant-factor claim:

> The canonical two-dimensional arithmetic object is not an invariant plane inside \(H^1(J(X))\). It is the multiplicity Hodge structure measuring the duplication of the icosahedral representation after restriction from \(\mathrm{PSL}_2(11)\) to \(A_5\).

At the representation level,
\[
\operatorname{End}_H(H^1)\cong M_2(\mathbf Q).
\]
The Hodge endomorphisms select an imaginary quadratic subalgebra
\[
\mathbf Q(\sqrt{-11})\hookrightarrow M_2(\mathbf Q).
\]
For the full group,
\[
\operatorname{End}_G(H^1)\cong\mathbf Q(\sqrt{-11}).
\]

These identities should be understood rationally. Integral lattices and the principal polarization impose additional arithmetic structure not captured by the semisimple rational representation alone.

### Family-level interpretation

Hartlieb proves that the \(A_5\)-symmetric cubic threefolds containing the Klein cubic form a one-dimensional special subvariety in the intermediate-Jacobian locus. The multiplicity description explains its dimension: the rigid five-dimensional \(A_5\)-factor \(W_5\) stays fixed while the two-dimensional weight-one factor \(U_H\) varies. In effect, the \(A_5\) family is controlled by an elliptic-type Hodge parameter, and the Klein cubic is the special CM point at which that parameter has endomorphism field \(\mathbf Q(\sqrt{-11})\).

This observation is useful beyond the isolated Klein point. It provides a natural one-parameter arena in which one can ask whether the finite orientation structure deforms, becomes monodromy, or appears as a special correspondence between two \(A_5\)-marked copies of the family.

## 5. The two-parent relative-position target

The finite golden construction supplies two distinguished subgroups
\[
H_+,H_-\cong A_5,
\qquad
H_+\cap H_-\cong A_4,
\qquad
\langle H_+,H_-\rangle=G.
\]
They yield two presentations
\[
H^1\cong W_5^+\otimes U_+,
\qquad
H^1\cong W_5^-\otimes U_-,
\]
and two commutant algebras
\[
C_\pm=\operatorname{End}_{H_\pm}(H^1)\cong M_2(\mathbf Q).
\]

Since \(H_+\) and \(H_-\) generate \(G\),
\[
C_+\cap C_-
=\operatorname{End}_{\langle H_+,H_-\rangle}(H^1)
=\operatorname{End}_G(H^1)
\cong\mathbf Q(\sqrt{-11}).
\]
This intersection identity follows formally once the representation and generation statements are fixed.

What is not yet proved is whether the relative position of \(C_+\) and \(C_-\) contains the golden orientation. The concrete calculation is:

1. realize the ten-dimensional rational representation of \(G\), its CM operator, and its polarization explicitly;
2. embed the two certified \(A_5\) parents;
3. solve the linear commutant equations for \(C_+\) and \(C_-\);
4. choose intrinsic rank-one idempotent pairs or trace-zero involutions in the two \(M_2(\mathbf Q)\) algebras;
5. compute conjugacy-invariant mixed traces, cross-ratios, and minimal polynomials;
6. test whether the resulting real quadratic invariant has discriminant \(5\);
7. test whether exchanging the two finite sheets acts by \(\sqrt5\mapsto-\sqrt5\), or equivalently \(\phi\mapsto1-\phi\).

The most informative positive outcome would be a theorem of the form:

> The CM field \(\mathbf Q(\sqrt{-11})\) governs the Hodge multiplicity object, while the real quadratic field \(\mathbf Q(\sqrt5)\) governs the relative position of the two icosahedral restrictions; the golden sheet involution is the nontrivial automorphism of the latter field.

At present this is a target, not a conclusion.

### A useful warning

The full rational commutant already contains \(\mathbf Q(\sqrt{-11})\). Consequently, a raw quadratic irrationality found in a matrix computation is not enough. A valid golden invariant must be:

- independent of basis and isogeny choices;
- compatible with the principal polarization or another canonical tensor;
- attached to the ordered or unordered pair \(H_+,H_-\);
- changed in the required way by the sheet involution;
- demonstrably not just a rewriting of the existing CM operator.

## 6. Cycle-level route through the Fano surface

Let \(S\) be the Fano surface of lines on \(X\). Roulleau proves that \(S\) contains 55 canonical smooth genus-two curves \(D_g\), indexed by the 55 involutions \(g\in G\), with intersection law
\[
D_gD_h=
\begin{cases}
-4,&g=h,\\
0,&o(gh)=2\text{ or }6,\\
2,&o(gh)=3,\\
1,&o(gh)=5.
\end{cases}
\]
Their classes span a rank-25 sublattice of \(\operatorname{NS}(S)\), of index two after adjoining the appropriate incidence class.

This gives a second, more geometric lifting route:

1. identify the \(11+11\) finite design sheets inside suitable \(G\)-orbits of combinations of the \(D_g\), incidence divisors, or their Abel–Jacobi images;
2. compare the two \(A_5\)-indexed 15-curve subconfigurations;
3. determine whether the index-two saturation or a discriminant form carries the same orientation torsor;
4. map the resulting algebraic cycles into \(J(X)\), its torsion, or a normal-function extension;
5. test whether theta data erases the sign while an Abel–Jacobi or regulator refinement retains it.

This route has two advantages. It is integral rather than merely rational, and it supplies canonical cycles rather than an arbitrary decomposition of \(E^5\). It is also harder: a precise map from the finite 22-point geometry to these 55 cycles remains to be constructed.

## 7. Theta, torsion, normal functions, and regulators

The representation-theoretic result narrows the possible locations of the orientation.

### Theta and ordinary Hodge data

The principal polarization and the underlying \(G\)-Hodge representation are highly symmetric. If the finite computations already show that theta parity erases orientation, the characteristic-zero lift should not expect the orientation to appear in an unmarked theta characteristic or in the isogeny class \(E^5\) alone.

### Torsion

Torsion remains plausible because the exact period lattice is not the product lattice \(\mathcal O_K^5\) in a canonically split basis. The quotient lattices at primes over \(11\), the principal polarization, and the index-two Néron–Severi saturation provide finite modules on which the two \(A_5\) parents can have distinguishable relative positions.

The first torsion computation should be at primes dividing the visible discriminants, especially \(2\), \(5\), and \(11\). A positive result must be checked against the already-known failure of theta parity to distinguish the sheets.

### Normal functions and regulators

If all pure Hodge and theta data forget the orientation, the natural next level is an extension class rather than a sub-Hodge structure:
\[
0\longrightarrow H^3(X)(2)
\longrightarrow \mathcal E
\longrightarrow \mathbf Q(0)
\longrightarrow0.
\]
An Abel–Jacobi normal function associated with a signed difference of the two cycle configurations could live in such an extension. A regulator or dilogarithmic invariant would then be a secondary readout of the same orientation.

This remains high-risk. It should be attempted only after the commutant and torsion calculations identify a canonical signed cycle or correspondence.

## 8. Recommended execution order

### Stage A: exact linear algebra

This is the highest-EV stage.

1. Construct an explicit rational \(10\times10\) model of the Klein representation.
2. Verify directly:
   \[
   \operatorname{End}_G(H^1)=\mathbf Q(\sqrt{-11}).
   \]
3. Insert the two explicit \(A_5\) parents and calculate:
   \[
   C_\pm\cong M_2(\mathbf Q),
   \qquad
   C_+\cap C_-=\mathbf Q(\sqrt{-11}).
   \]
4. Compute all low-degree mixed-trace invariants of \(C_+\) and \(C_-\).
5. Search for an intrinsic discriminant-five invariant.

**Stop condition:** if all relative invariants lie in \(\mathbf Q\) or are generated solely by the CM field and no canonical ordering survives, the simple period-lattice orientation lift is dead.

### Stage B: integral and polarized refinement

If Stage A finds a promising invariant:

1. place both commutants inside the explicit Roulleau period lattice;
2. retain the Riemann form and integral structure;
3. determine the induced structures on \(J[2]\), \(J[5]\), and \(J[11]\);
4. compare them with the finite \(22\)-point/design polarity and the known orientation torsor.

### Stage C: Fano-cycle realization

1. decompose the 55 genus-two curves under each \(A_5\);
2. calculate the lattices generated by the two 15-curve subsystems and their intersection;
3. search for a canonical pair of signed cycle classes;
4. evaluate their Abel–Jacobi images.

### Stage D: secondary invariants

Only after a canonical signed cycle has been isolated:

1. construct the associated normal function;
2. compute its infinitesimal invariant;
3. test a regulator or dilogarithmic specialization;
4. compare sheet exchange with sign change.

## 9. Significance assessment

| Result or target | Present status | Significance |
|---|---:|---:|
| No \(G\)-stable two-dimensional sub-Hodge structure | proved from the character decomposition | 6/10; decisive pruning |
| No \(A_5\)-stable elliptic carrier | proved | 6/10; prevents a misleading formulation |
| Canonical two-dimensional \(A_5\)-multiplicity Hodge structure | proved at the rational Hodge level | 7.5/10; genuine bridge |
| Intersection \(C_+\cap C_-=K\) | formal once the two parents generate \(G\) | 7/10 |
| Relative commutant position recovers \(\mathbf Q(\sqrt5)\) | open computational target | 8.5/10 if true |
| Relative position realizes the finite orientation torsor | open structural target | 9/10 if canonical |
| Integral 22-point/design lift through Fano cycles or torsion | open | 9/10 if exact |
| Normal function or regulator distinguishes sheets after theta forgets them | open, high risk | 9–9.5/10 if nontrivial and intrinsic |

These scores are specialist significance, not automatically Annals-level significance. An Annals-level result would require a broader theorem—for example, a general mechanism by which finite orientation torsors are recovered as relative positions of subgroup multiplicity motives, with the Klein/Clebsch case as the first exceptional example.

## 10. What is established and what is not

### Established

- \(J(X)\) is a five-dimensional principally polarized abelian variety with explicit period lattice.
- \(J(X)\sim E^5\) for a CM elliptic curve with CM field \(\mathbf Q(\sqrt{-11})\).
- \(H^1(J,\mathbf Q)\) is the rational ten-dimensional representation arising from the conjugate pair of five-dimensional Klein representations.
- It has no two-dimensional \(G\)-stable subrepresentation.
- Its restriction to an icosahedral \(A_5\) is \(W_5\oplus W_5\).
- The associated multiplicity space is two-dimensional and inherits the Hodge structure.
- Each \(A_5\)-commutant is \(M_2(\mathbf Q)\).
- For two \(A_5\) parents generating \(G\), the intersection of their commutants is the full \(G\)-commutant.
- The Fano surface has a canonical 55-curve genus-two configuration spanning its Néron–Severi group up to index two.

### Not established

- that the relative position of the two \(A_5\) commutants produces \(\sqrt5\);
- that it recovers the finite golden sheet involution;
- that the 22-point biplane/design embeds canonically in torsion or theta data;
- that a signed algebraic cycle representing the orientation exists;
- that a normal function or regulator distinguishes the sheets;
- that any such construction persists in a family rather than only at the Klein CM point.

## 11. Bibliography

The primary sources used for the kill test were Roulleau for the period lattice and Fano-surface cycle configuration, and Hartlieb for the relevant character tables, the Hodge representation, and the \(A_5\)-special family through the Klein cubic.

```bibtex
@article{Roulleau2009Klein,
  author  = {Roulleau, Xavier},
  title   = {The Fano surface of the Klein cubic threefold},
  journal = {Journal of Mathematics of Kyoto University},
  volume  = {49},
  number  = {1},
  pages   = {113--129},
  year    = {2009},
  doi     = {10.1215/kjm/1248983032}
}

@article{Roulleau2011Genus2,
  author  = {Roulleau, Xavier},
  title   = {Genus 2 curve configurations on Fano surfaces},
  journal = {Communications in Mathematics, University of St. Pauli},
  volume  = {59},
  number  = {1},
  pages   = {51--64},
  year    = {2010},
  eprint  = {1002.4467},
  archivePrefix = {arXiv}
}

@article{Hartlieb2025Special,
  author  = {Hartlieb, Moritz},
  title   = {Special subvarieties in the locus of intermediate Jacobians of cubic threefolds},
  journal = {Mathematische Zeitschrift},
  volume  = {310},
  number  = {3},
  year    = {2025},
  eprint  = {2304.03214},
  archivePrefix = {arXiv},
  doi     = {10.1007/s00209-025-03745-3}
}

@article{ClemensGriffiths1972,
  author  = {Clemens, C. Herbert and Griffiths, Phillip A.},
  title   = {The intermediate Jacobian of the cubic threefold},
  journal = {Annals of Mathematics},
  volume  = {95},
  number  = {2},
  pages   = {281--356},
  year    = {1972},
  doi     = {10.2307/1970801}
}

@article{Adler1981Klein,
  author  = {Adler, Allan},
  title   = {On the automorphism group of a certain cubic threefold},
  journal = {American Journal of Mathematics},
  volume  = {100},
  number  = {6},
  pages   = {1275--1280},
  year    = {1978},
  doi     = {10.2307/2373973}
}
```

## Bottom line

The first proposed carrier was in the wrong categorical location. There is no equivariant elliptic factor inside the Klein intermediate Jacobian. There is, however, a canonical two-dimensional CM multiplicity Hodge structure attached to every icosahedral \(A_5\) restriction. The two golden \(A_5\) parents provide two such presentations of the same ten-dimensional Hodge structure.

The next serious theorem is therefore not “find the elliptic factor.” It is:

\[
\boxed{\text{Compute the intrinsic relative position of the two }A_5
\text{ multiplicity structures.}}
\]

If that relative position has discriminant \(5\) and sheet exchange induces its nontrivial Galois automorphism, the finite golden orientation has a precise characteristic-zero realization in the period geometry of the Klein cubic.
