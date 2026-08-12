# C909 — two-row web/Specht, osculating jets, and `sl_2` fusion audit

Date: 2026-08-12  
Status: bounded primary-source/structure audit; no manuscript, PDF, mirror,
Lean, or computational-certificate edits

## Executive verdict

There is a genuine three-way representation-theoretic neighborhood around the
C909 matrix, but no located theorem identifies all three of its features at
once:

1. Feigin–Jimbo–Kedem–Loktev–Miwa (FJKLM) identify conformal coinvariants at
   distinct insertion points with filtered tensor products of evaluation
   modules; their `sl_2` theorem identifies the associated graded filtered
   tensor product (the fusion product) and its Hilbert polynomial with the
   level-restricted Kostka polynomial.
2. Feigin–Kedem–Loktev–Miwa–Mukhin (FKLMM) give explicit level-restricted
   path/monomial bases and prove that the dimensions at distinct points and
   at the coincident (fusion) point agree.  For fundamental `sl_2` labels,
   those paths are the bounded-height Dyck paths relevant to the C909 rank
   numbers.
3. Karrila–Kytölä–Peltola (KKP) and Lafay–Peltola–Roussillon (LPR) supply
   exact web/quantum-group and two-row/two-column Specht conformal-block
   realizations, respectively.

These results justify importing the *characteristic-zero rank target* and its
Dyck-height interpretation.  They do not prove the C909 universal integral
osculating-jet theorem: no source in this focused corpus gives the equality
between the C909 coordinatewise jet/Rees filtration and the `sl_2` fusion
filtration, nor local freeness/saturation over
`Z[t_1,...,t_{2n},Delta^{-1}]`, nor the resulting Smith factors (especially
at `p=2`).  The safe verdict is therefore **rank bridge available;
integral crown still open**.

Six primary works were read at full text.  Their cache keys, versions, and
hashes are recorded below; a negative statement here is only relative to the
focused search listed in the final section, not a global priority claim.

## Exact `sl_2` fusion/conformal-block statements

### FJKLM: distinct evaluation points, filtered tensors, fusion

F. Feigin, M. Jimbo, R. Kedem, S. Loktev, and T. Miwa,
[*Spaces of coinvariants and fusion product I. From equivalence theorem to Kostka polynomials*](https://arxiv.org/abs/math/0205324),
arXiv:math/0205324v3; Duke Math. J. 125 (2004), 549–588.

The load-bearing statements are:

* **Theorem 3.6 (`cnt`)** gives a canonical isomorphism of filtered vector
  spaces between a highest-weight affine coinvariant quotient and the
  filtered tensor product of the finite-dimensional cyclic modules
  `pi^(k)(X_i)` evaluated at the distinct parameters `Z=(z_1,...,z_N)`.
  Thus the point-dependent evaluation tensor product is not merely an
  analogy: it is the filtered object whose quotient is the conformal
  coinvariant space.
* In §4.2 the fusion product is defined by
  `V_1 * ... * V_N(Z) = gr F_Z(V_1,...,V_N)`, where `F_Z` is the filtered
  evaluation tensor product.  For `g=sl_2`, irreducible modules with their
  highest-weight vectors as cyclic vectors, the paper states the known
  independence of this fusion product from `Z` and proves the relevant
  character theorem.
* **Theorem 4.1** identifies the character of the level-`k` coinvariant of
  the fusion product of irreducibles with the level-restricted Kostka
  polynomial `K^{(k)}_{l,m}(q)`.  Its value at `q=1` is the corresponding
  Verlinde multiplicity.  The theorem is over complex current-algebra
  modules; it is not a statement about an integral lattice or Smith form.
* **Appendix Theorem A.3 (`Thm:jmp`)** factors the degeneration map through
  the fusion product.  Its first map is an isomorphism when the annihilating
  ideals contain the level ideal.  This is useful for identifying which
  quotient of a fusion product is being compared, but it still concerns
  complex vector spaces and an associated graded limit.

The source uses distinct complex points for the evaluation tensor product,
then a degree filtration whose associated graded models the collision of all
points at zero.  It does not say that a coordinatewise Hasse-jet filtration
`J_S` at a fixed distinct configuration is the same Rees filtration.

### FKLMM: Verlinde paths, no jump, and monomial bases

B. Feigin, R. Kedem, S. Loktev, T. Miwa, and E. Mukhin,
[*Combinatorics of the `\hat{sl_2}` spaces of coinvariants II*](https://arxiv.org/abs/math/0009198),
arXiv:math/0009198v2.

The paper's `L_k,l^(M,N)(z;z')` spaces allow the marked points to be
distinct or coincident.

* **Theorem 2.1.2** (quoted from their first paper) states that at distinct
  points the dimension is the Verlinde number `d^(M+N)_{k,l}`.
* **Theorem 5.4.4** proves the same dimension formula for all `M,N`,
  including the coincident configuration used for fusion.  Thus the
  dimension does not jump under this degeneration.
* **Corollary 5.4.6** identifies the resulting space with the relevant
  associated graded space (`Gr^E`) and says the displayed map is an
  isomorphism.  This is the cleanest source statement that a filtered
  degeneration preserves the `sl_2` coinvariant rank.
* **Corollary 5.4.10** gives an explicit monomial basis for all point
  configurations `z in C^N`, indexed by their combinatorial paths
  `C^(N)_{k,l}`.  The preceding §3 identifies the same counts with
  Verlinde paths.

The paths are the usual level-`k` affine `sl_2` fusion paths: successive
labels form admissible triples and stay in `0,...,k`.  Specializing to
`2n` fundamental insertions and output label `0`, the elementary bijection
with walks gives

```
 d_k(n) = number of walks 0 -> 0 of length 2n,
          steps +/-1, with 0 <= height <= k.
```

Equivalently, if `H(n,h)` denotes the number of Dyck paths of semilength
`n` whose maximum height is exactly `h`, then

```
 d_k(n) = sum_{h <= k} H(n,h),       d_k(n)-d_{k-1}(n) = H(n,k).
```

This last display is an inference from the source's path definition and the
standard walk/Dyck identification, not a theorem about the C909 matrix.
It shows that the bounded-height numbers occurring in C909 are exactly the
finite-level rank differences one obtains from `sl_2` fusion.  To turn it
into the C909 filtration statement one must still identify the C909 layer
`r` with the level/path layer `h=n-r` and prove integral saturation.

## Exact web and Specht conformal-block statements

### KKP: Dyck-labelled web/quantum-group blocks

A. Karrila, K. Kytölä, and E. Peltola,
[*Conformal blocks, q-combinatorics, and quantum group symmetry*](https://arxiv.org/abs/1709.00249),
arXiv:1709.00249; Ann. Inst. H. Poincaré D 6 (2019), 449–487,
DOI [10.4171/AIHPD/88](https://doi.org/10.4171/AIHPD/88).

The paper works at generic irrational `kappa` (hence generic `q`), not in
the finite-level WZW integral form.  Its exact relevant statements are:

* The Dyck-path-indexed highest-weight subspace of the tensor power of the
  two-dimensional `U_q(sl_2)` module has Catalan dimension.
* **Proposition “SCCG correspondence map”** constructs an explicit linear
  isomorphism from that highest-weight/web space to the conformal-block
  solution space.  The projection maps for adjacent points send a Dyck
  vector to zero, or to the shorter path obtained by removing an up/down
  wedge, with the stated `q`-number coefficient.
* **Theorem “change of basis theorem”** makes the conformal-block/pure-web
  change of basis an invertible weighted incidence matrix of the parenthesis
  reversal relation.  Its entries are products of
  `qnum(h)/qnum(h+1)` over nested Dyck tiles; the inverse is a sum over
  cover-inclusive Dyck tilings.

This is an exact web/Dyck/conformal-block bridge and explains why Dyck
indices and recursive wedge removal are natural.  It is not the same as the
FJKLM affine `sl_2` finite-level theorem: the parameter is generic and the
blocks are analytic CFT solutions.  More importantly for C909, the displayed
`q`-number coefficients are rational/complex normalizations, not units in a
universal integral DVR.  No osculating-jet Smith statement is made.

### LPR: fused Specht polynomials and two-row blocks

A. Lafay, E. Peltola, and J. Roussillon,
[*Fused Specht Polynomials and `c=1` Degenerate Conformal Blocks*](https://arxiv.org/abs/2410.09798),
arXiv:2410.09798v3 (2025).

This is the closest direct source for “two-row Specht/web plus conformal
blocks,” with an essential qualification: the CFT is `c=1` and the algebra
is a fused Hecke algebra at `q=-1`, not the affine `sl_2` WZW coinvariant
construction of FJKLM.

* **Theorem A (`thm:theoremA`)**: for a Young diagram with two columns, the
  fused Specht polynomials indexed by row-strict tableaux form a module
  isomorphic to the corresponding fused-Hecke module.  Transposing the
  tableaux gives the two-row shape `(N,N)` used for Dyck/link-pattern
  indexing.
* **Proposition `proplinearindepfusedspecht`** proves linear independence of
  these fused Specht polynomials for the two-column shape.
* In §3, `prop:basisformathcalC` and the following lemmas express the fused
  `c=1` conformal-block basis in terms of those polynomials, indexed by
  column-strict tableaux of shape `(N,N)` with prescribed valences.  For
  unit valences this is the Catalan/Dyck indexing.
* Fusion here is literally a collision/evaluation operation: antisymmetrize
  in each block, divide by the within-block Vandermonde, and set all
  variables in a block equal.  The one-column formula is a product of
  cross-block differences.

The source is therefore excellent evidence for a complex two-row
Specht-to-fused-block realization, but it does not identify the C909
distinct-point Hasse-jet filtration.  It also visibly uses non-integral
normalizations: the combinatorial formula contains factors `1/s_k!`, and
the worked example has a factor `1/2`.  Thus this source cannot be cited as
integral local freeness at `p=2` without a new renormalization and a proof
that the renormalized lattice is the C909 lattice.

### Karp–Purbhoo: Specht/Bethe operators and osculating Wronski geometry

P. Karp and K. Purbhoo,
[*Universal Plücker coordinates for the Wronski map and positivity in real
Schubert calculus*](https://arxiv.org/abs/2309.04645), arXiv:2309.04645v2.

**Theorem 1.3** identifies commuting symmetric-group/Specht operators whose
eigenvalues are Plücker coordinates of Wronski-fibre points; §1.3.1 and
**Proposition 2.8** identify the rational-normal-curve osculating flags and
the corresponding Schubert conditions.  This is the correct osculating
Grassmannian/Specht neighborhood for C909.  It does not identify the
coordinate coefficient matrix with the Bethe operators, and it contains no
integral DVR, Hasse-jet, cumulative-minor, or Smith-factor theorem.

## Integral/mixed-characteristic near miss

R. A. Spencer,
[*Modular Valenced Temperley–Lieb Algebras*](https://arxiv.org/abs/2108.10011),
arXiv:2108.10011.

Spencer works over mixed characteristic and constructs cellular/diagram bases
for valenced Temperley–Lieb cell modules; in the two-row/two-bucket cases the
dimensions are counted by constrained walks.  This is useful evidence that
some web lattices can be free over a coefficient ring.  It has no moving
spectral points, no discriminant localization, no coordinatewise osculating
jets, and no theorem that its cellular filtration equals C909's Rees
filtration.  It therefore does not supply the missing local-freeness gate.

## Precise mismatch with the C909 crown

The C909 object has a universal lattice over a distinct-root configuration
ring, with a graph shear such as `u_i=t_i-p^a z_i`, Hasse jets in each
coordinate, and a `p^a`-weighted cumulative block matrix.  The sources above
split into two kinds:

* FJKLM/FKLMM use current-algebra degree filtrations and fusion products.  A
  point-dependent filtered evaluation tensor product is present, but the
  associated graded is taken in the current variable and models a collision
  limit.  No equality with the C909 coordinatewise Hasse-jet Rees module is
  asserted.
* KKP/LPR use complex web/Specht/CFT bases and explicit collision/fusion
  formulas.  They prove rank/basis statements after choosing complex or
  generic `q` normalizations.  They do not prove a `Z[Delta^{-1}]`-free
  filtered lattice, let alone unit Fitting ideals for every cumulative jet
  map.

Consequently, the strongest safe import is the following conditional
statement:

> If the C909 integral jet/Rees module is proved to be the integral form of
> the level-`k` `sl_2` fusion filtration, then FKLMM's path theorem supplies
> the characteristic-zero cumulative ranks, and the finite-level difference
> `d_k(n)-d_{k-1}(n)` supplies the exact-height Dyck multiplicities.

The antecedent is the crown theorem and remains unproved.  In particular,
complex isomorphism after tensoring with `Q` or `C` is insufficient: a
non-unimodular basis change can alter every `p`-primary Smith factor.  The
factorials in LPR and q-numbers in KKP make this warning concrete at `p=2`
and at roots of unity.

## Smallest useful proof/import target

The minimal bridge worth proving in C909 is not a citation to “fusion” in
the abstract, but an integral Rees comparison with four explicit clauses:

1. construct the C909 Specht/web lattice over
   `R=Z[t_1,...,t_{2n},Delta^{-1}]` and a filtration whose generic fibre is
   the FJKLM `sl_2` fusion filtration;
2. identify the web/Specht basis with the level-`k` path basis after the
   `sl_2` quotient, including the height bound;
3. prove the Rees module and every cumulative graded quotient are locally
   free over `R` (or prove the unit Fitting-ideal statement directly);
4. only then specialize `u_i=t_i-p^a z_i` and read off the Smith factors.

Without clause 3, FJKLM/FKLMM establish only the rank profile over a field.
Without clause 1, “fusion product” is a suggestive label rather than an
identification of the C909 filtration.  This is the exact point at which
the current literature bridge stops.

## Focused search and coverage

Load-bearing queries, recorded verbatim:

* `primary paper sl2 conformal blocks Dyck paths fusion product integral lattice distinct points`
* `sl2 conformal blocks osculating flags Wronski Specht polynomials theorem`
* `fusion product sl2 current algebra flat family distinct points`
* `Specht module sl2 conformal blocks Temperley Lieb basis theorem`
* `fusion product integral form sl2 lattice`

The six sources above were opened/read at full text from their arXiv versions;
the source texts and PDFs are in the shared literature cache.  MathSciNet,
Google Scholar, zbMATH citation closure, OpenAlex/Crossref/Semantic Scholar
forward graphs, and an exhaustive search of integral Bethe-algebra or
osculating-jet literature were **NOT COVERED**.  Hence the report makes no
global “no predecessor” claim; it records only that no exact all-degree
integral jet/fusion identification was found in this focused corpus.

## Source ledger

| source | read depth/version | cache SHA-256 |
|---|---|---|
| FJKLM, arXiv:math/0205324 | full text, v3; 33-page arXiv PDF and extracted text | `e41f25768dbc347557a2c19dbe47f82a43ab5c023b4ef0e41fe5b80f682f774e` |
| FKLMM, arXiv:math/0009198 | full text, v2; 44-page arXiv PDF and extracted text | `cac871a85b3bf3316cb4a2b33465e157cca46b525fbb561dec67c28479b8762f` |
| LPR, arXiv:2410.09798 | full text, v3; 50-page arXiv PDF and source text | `05f237aaed00d72ae7fd0cebe49a95e4bd3d685fd7a0dfb095965a1c1d5a6ade` |
| KKP, arXiv:1709.00249 | full text, arXiv version; 24-page PDF and extracted text | `e3257414a6b385fe169481a2ee7a5d0a8f07016557a85b309c1cdc7018d8a361` |
| Karp–Purbhoo, arXiv:2309.04645 | full text, v2; reused from the prior C909 audit | `bfc9e79ef082f341ec7615f1298cd64c1fa4a83a83b03efb71da42252ead7b24` |
| Spencer, arXiv:2108.10011 | full text, arXiv version; 45-page PDF and extracted text | `6cf9b3e77d1c9bd23b73ddfddd2de0c7f979d1f207391153548286ee857a6fd0` |

