# C909 — classical engines for the filtered-web Smith crown

Date: 2026-08-12  
Status: bounded primary-source audit; no manuscript, PDF, mirror, Lean, or
code edit

## Executive verdict

No located source proves the C909 all-`ell` filtered matching Smith profile
for arbitrary pairwise-distinct roots over a DVR, especially at `p=2`.
There are, however, two real classical engines worth importing as proof
architecture:

1. Bessenrodt--Stanley give explicit upper/lower unitriangular operations over
   a multivariate polynomial ring which produce a monomial Smith form for
   partition/lattice-path matrices.
2. Cai--Mansour give an integral-looking noncrossing Temperley--Lieb basis,
   a unitriangular transition from it to a Jones--Wenzl basis, and Dyck-path
   formulas for their Gram determinant.

Neither closes C909 without a new identification.  Bessenrodt--Stanley's
matrices are partition-tail generating-function matrices, not the
`2ell`-slot Plücker/web coefficient matrix.  Cai--Mansour's basis and
determinant use Kauffman-bracket/Jones--Wenzl factors and count down-steps,
not the exact-height filtered Smith factors; their framework does not give
the required dyadic unit minors.  Ormeño Bastías--Ryom-Hansen's recent
seminormal Temperley--Lieb work is explicitly rational and, in finite
characteristic, assumes `p>2`, so it cannot be cited for the dyadic crown.

The safe state is therefore **MINOR route, not GO theorem**: cite the
classical mechanisms as motivation and formulate the missing result as a
new filtered-web Smith lemma.  Do not claim that “Specht/Jantzen/
Temperley--Lieb theory” already proves it.

## 1. Exact C909 gate

On a squarefree `2ell`-slot support, after splitting the étale packet, the
matching product columns have the form

```text
  v_M = product_(i,j in M) [delta_ij X_i X_j
                              + p^a(X_i Y_j + X_j Y_i)],
```

where every `delta_ij=t_j-t_i` is a unit.  Modulo the Plücker relations the
columns form the Catalan-rank noncrossing matching/web module `M_ell`.  The
desired assertion is a Smith statement for the cumulative `Y`-degree
blocks, with elementary-divisor multiplicities

```text
  exact Dyck-height h: H(ell,h),  exponent a(ell-h),  1 <= h < ell.
```

This asks for integral compatible minors (or a unitriangular elimination)
for every cumulative filtration step, not merely the rank of one
Vandermonde matrix and not merely the determinant of a Gram pairing.  The
`delta_ij` are arbitrary residue-field units, and the proof must survive
`p=2` without dividing by 2.  These are the points at which the analogies
below stop.

## 2. Best exact Smith template: Bessenrodt--Stanley

Christine Bessenrodt and Richard P. Stanley, *Smith Normal Form of a
Multivariate Matrix Associated with Partitions*, arXiv:1311.6123, give the
closest formal template.

Their Theorem 1 constructs upper and lower unitriangular matrices over
`Z[x_ij]` which transform a partition matrix of skew-diagram generating
polynomials to a diagonal matrix whose entries are explicit monomials.
Their Theorem 2 supplies the inclusion--exclusion recurrence, and the proof
of Theorem 1 iterates the recurrence to obtain the unitriangular Smith
operations.  They emphasize that the ring is not a PID a priori; the
explicit monomial diagonal proves existence of the Smith form.  The
construction is genuinely integral: the transforming matrices lie in
`SL` over the polynomial ring, so specialization at a DVR unit tuple
preserves the needed unit pivots whenever the specialized monomials are
units.

### What can be imported

The C909 proof should imitate this exact pattern:

1. Define the universal filtered block matrix over
   `Z[delta_ij,z_i]` after imposing the coefficient-one Plücker straightening
   relations.
2. Find a recurrence that removes one outer arc/one row of the Dyck web and
   expresses the unwanted terms by lower web blocks.
3. Prove, by induction, that the cumulative determinantal ideals have a
   chosen monomial/product generator and that all row and column operations
   are unitriangular over the universal ring.
4. Specialize the `delta_ij` to residue-field units and `z_i` to the
   exterior jet variables.  The universal unit pivots then give the DVR Smith
   factors; no generic numerical choice of roots is needed.

This is a credible route to the crown because it targets minors, not only
determinants.  It also makes clear what must be printed: a C909-specific
recurrence and a C909-specific universal matrix identification.

### What cannot be imported as a theorem

Bessenrodt--Stanley's matrix `M(i,j)` is indexed by squares of a partition
and contains generating functions for subpartitions of a southeast tail.
Its size is governed by the Durfee rank, and its diagonal monomials are the
leading products `A_ii` of those tails.  C909's `M_ell` has Catalan rank,
generators indexed by pair matchings, and a filtration by exterior `Y`-slot
count.  For example, the rectangular partition `(ell,ell)` has Durfee rank
two, while the C909 matching module has rank `Catalan(ell)`; these cannot be
the same matrix.  No source in the bounded search identifies the C909 block
matrix with a Bessenrodt--Stanley matrix, a direct summand of one, or a
Schur-complement of one.  Such an identification would itself be a new
lemma, not a citation.

Richard P. Stanley, *The Smith Normal Form of a Specialized Jacobi--Trudi
Matrix*, arXiv:1508.04746, is a related exact theorem.  It computes the SNF
of specialized Jacobi--Trudi matrices using diagonal-hook content factors
and gcds of minors, with a `q`-specialization as well.  This is useful for a
possible Schur/alternant reformulation, but the specialization is one
parameter (`1^n` or geometric `q`-weights), whereas C909 permits arbitrary
pairwise-distinct residue roots and a `p^a` exterior shear.  It supplies a
methodological model, not the required theorem.

## 3. Dyck/Temperley--Lieb template: Cai--Mansour

Xuanting Cai and Toufik Mansour, *Bilinear Forms on Skein Modules and Steps
in Dyck Paths*, arXiv:1011.0941 (J. Math. Phys. 52 (2011), 073509), construct
relative Kauffman-bracket skein modules with noncrossing diagram bases.  In
their §3, the `D`-basis is orthogonal for the skein bilinear form, the
natural noncrossing `B`-basis is related by a unitriangular transition
(their Proposition 3.15), and the basis is indexed by generalized Dyck
paths.  Their Theorem 2.11 reduces the Gram determinant to products of
quantum integers; §§5.1--5.2 count the relevant height down-steps.

This explains why Dyck paths and unitriangular elimination are plausible in
C909, and it can supply a clean combinatorial lemma for counting paths once
the correct filtration is identified.

It does not prove the C909 statement for three independent reasons:

* The C909 filtration is the exterior `Y`-letter filtration after a graph
  shear.  Cai--Mansour filter a skein bilinear form by Jones--Wenzl fusion
  data.  Their determinant statistic counts down-steps at specified heights;
  C909 needs exact maximum-height multiplicities `H(ell,h)` in a Smith form.
  These statistics are not interchangeable (already at semilength three).
* Their skein setup works over a Kauffman-bracket localization and uses
  Jones--Wenzl/quantum-integer factors.  Such factors need not be units at
  the dyadic prime.  A determinant calculation over that localization does
  not establish integral `2`-adic pivots.
* No arbitrary-root parameters `delta_ij` occur.  Pairwise-distinct
  residue roots in C909 are a whole unit parameter family, not one global
  quantum parameter.

Thus Cai--Mansour are a **combinatorial/template citation**, not a proof of
filtered-web saturation.

## 4. Specht/Jantzen/seminormal check

The noncrossing matching quotient is naturally close to a two-row Specht/
Temperley--Lieb web module after tensoring with `Q`.  Standard monomial
straightening gives an integral noncrossing basis.  That identification
alone does not identify the graph-shear filtration with a Jantzen
filtration.

Katherine Ormeño Bastías and Steen Ryom-Hansen, *Seminormal forms for the
Temperley--Lieb algebra*, arXiv:2303.10682, construct rational seminormal
idempotents and relate them to Jones--Wenzl idempotents.  Their modular
statement is over `F_p` with the explicit hypothesis `p>2`; it gives
Jucys--Murphy eigenvectors and a KLR interpretation of `p`-Jones--Wenzl
idempotents.  Therefore it is not an integral dyadic result and does not
compute the arbitrary-`delta` Smith factors.  “Use Jantzen filtration” is a
research direction, not an imported proof.

The likely correct representation-theoretic reformulation is narrower:
construct a **deformation/Jantzen filtration of the two-row web lattice
along the graph-shear family**, then prove that its associated-graded ranks
are exact-height Dyck numbers and that each graded quotient is primitive.
The primitivity/unit-minor clause is exactly what ordinary characteristic-
zero Specht theory does not provide.

## 5. Kasteleyn and Vandermonde boundary

Greg Kuperberg, *Kasteleyn cokernels*, arXiv:math/0108150 (EJC 9 (2002),
R29), correctly frames planar matching matrices over a PID as Smith/cokernel
objects and relates Kasteleyn--Percus and Gessel--Viennot matrices.  But his
paper presents several `q`-Jacobi--Trudi Smith forms as conjectural; it does
not furnish a general matching-web filtered Smith theorem.  Stanley's later
Jacobi--Trudi result resolves a specialized case, not C909's arbitrary-root
jet family.

Likewise, an ordinary confluent-Vandermonde determinant only proves one
full-rank determinant for prescribed jets.  C909 needs all cumulative
`Y`-degree determinantal ideals and compatibility among them.  The extra
minor data are the crown, not a routine consequence of Vandermonde.

## 6. Import plan and expected payoff

The shortest defensible proof project is now:

```text
universal Plücker/web lattice
  -> outer-arc recurrence (Bessenrodt--Stanley style)
  -> unitriangular cumulative minors
  -> exact-height Dyck filtration
  -> specialization delta_ij in R^×, p^a-shear
  -> Smith profile and faithful-flat descent.
```

The recurrence must be proved for the C909 coefficient blocks.  It is not
enough to cite “standard monomial theory,” “the Temperley--Lieb basis,” or
“the Jantzen filtration.”  Once the universal unitriangular statement is
proved, the dyadic issue is handled at the source: all pivots are `±` products
of `delta_ij`, and no division by 2 appears.  The known degree-two witness
then becomes the first case of the same theorem rather than a separate
exception.

If this recurrence cannot be found, the honest crown is the proved
low-corank range (`ell<=3`, hence all degrees for `g<=7`) plus a conditional
all-`ell` formula.  The classical sources do not justify promoting it to a
full theorem.

## 7. Modular-cubic fallback

The bounded source pass did not find a second cubic modular family shared by
the C909 graph-saturation presentation and an independent cubic atom.  The
known `A_5/D_5` data remain a marked normalization component: the VGY source
gives the order-five étale Prym diagram and an isogeny-only comparison, while
the exotic `r^2=T` cover is a finite marking/resolvent cover.  No source found
in this pass identifies the filtered-web Smith lattice with a new modular
cubic curve or supplies a second family carrying the same integral packet.

This is only a bounded absence statement.  The search did not cover
MathSciNet, zbMATH Open, Google Scholar, OpenAlex/Crossref, Semantic Scholar,
or a systematic citation graph.  It is safe to say “no such shared family
was located in the focused corpus,” not “none exists.”

## Source and search ledger

Opening summary: **one previously cached full-text source was reused** for the
osculating/Specht boundary (Karp--Purbhoo, arXiv:2309.04645v2).  The new
candidate sources below were checked at theorem/abstract/full-text landing
depth; this pass is not a line-by-line PDF audit of each new source.  Their
exact source clauses are given so a later full-text pass can verify the
specialization details.

Queries used:

```text
Smith normal form Temperley Lieb matching module Dyck paths
Smith normal form bracket algebra Plucker relations matching basis Dyck paths
integral Specht module Jantzen filtration Dyck tableaux Temperley Lieb Smith normal form
confluent Vandermonde Smith normal form Schur functions integral theorem
standard monomial theory Grassmannian Plucker relations basis over integers
Smith normal form Vandermonde matrix Schur
Smith normal form confluent Vandermonde matrix
Kasteleyn cokernels Smith normal form matchings
```

Primary records:

* Bessenrodt--Stanley, arXiv:1311.6123,
  <https://arxiv.org/abs/1311.6123>, Theorems 1--3.
* Stanley, arXiv:1508.04746,
  <https://arxiv.org/abs/1508.04746>, Theorem 1.1 and §3.
* Cai--Mansour, arXiv:1011.0941,
  <https://arxiv.org/abs/1011.0941>, Proposition 3.15 and Theorems 2.11,
  5.1, 5.6.
* Ormeño Bastías--Ryom-Hansen, arXiv:2303.10682,
  <https://arxiv.org/abs/2303.10682>, abstract and modular `p>2` scope.
* Kuperberg, arXiv:math/0108150,
  <https://arxiv.org/abs/math/0108150>, abstract and Jacobi--Trudi
  conjectural boundary.
* Karp--Purbhoo, arXiv:2309.04645v2, previously cached full text; its
  universal Plücker/Specht/Wronski statements still stop before the integral
  filtered Smith gate.

No exact predecessor was located for the C909 conjunction “arbitrary
distinct DVR roots + Plücker matching web + cumulative jet filtration +
exact Dyck-height Smith factors, including `p=2`.”  This is a bounded
focused-corpus statement only, not a novelty or firstness claim.
