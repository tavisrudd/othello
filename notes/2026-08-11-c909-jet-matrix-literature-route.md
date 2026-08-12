# C909 — jet-coefficient matrix: osculating/Specht route audit

Date: 2026-08-11  
Status: bounded literature/proof audit; no manuscript, PDF, mirror, Lean, or
commit change

## Verdict

The strongest exact bridge located is Karp–Purbhoo's universal Plücker
coordinates for the Wronski map.  Their Theorem 1.3 identifies operators in
the symmetric-group algebra, acting on Specht modules, whose eigenvalues are
the Plücker coordinates of points in a Wronski fibre.  The same paper makes
the osculating rational-normal-curve model explicit.  This is the right
representation-theoretic/osculating-Grassmannian neighborhood for the C909
matrix, but it does **not** state the needed integral Smith/minor theorem.

No source was found in the bounded search that identifies the C909 filtered
matching coefficient matrix with a confluent Vandermonde or Temperley–Lieb
immanant and supplies the unit-pivot/product formula.  The all-`k` filtered
matching lemma therefore remains a proof obligation, not a citation.

## The matrix to be explained

On a squarefree `2k`-slot set `S`, choose the noncrossing matching basis `P`.
With `B_ij=X_iY_j+X_jY_i` and `δ_ij=t_j-t_i`, the product column is

```
v_P = ∏_(i,j in P) (δ_ij X_iX_j + p^a B_ij)
    = Σ_{r=0}^k p^(ar) v_(P,r).
```

`F_(k,r)` is the coefficient matrix of `v_(P,r)` in the exterior basis block
with exactly `2r` `Y`-letters.  The DVR matrix is consequently

```
[ F_(k,0) ; p^a F_(k,1) ; ... ; p^(ak) F_(k,k) ].
```

The required statement is stronger than full-rank of a Vandermonde matrix:
for every distinct-residue tuple one needs a compatible family of cumulative
unit minors, or an equivalent unitriangular elimination, whose ranks give the
Dyck-height Smith multiplicities.  The computed valuation multiplicities
(including the primitive valuation-`0` column) are

```
k=2: (0^1, 1^1)       k=3: (0^1, 1^3, 2^1)
k=4: (0^1, 1^5, 2^7, 3^1)
```

and the earlier audit computes all profiles through `k=6`; these data are
evidence for the filtration but not a proof of the all-`k` unit-minor claim.

## Exact source bridge

Karp–Purbhoo, *Universal Plücker coordinates for the Wronski map and
positivity in real Schubert calculus*, arXiv:2309.04645v2 (16 June 2026),
is the closest primary source found:

* §1.1 places the inverse Wronski problem in `Gr(d,m)`, identifies the
  commuting Bethe algebra in `C[S_n]`, and uses the Specht module `M^ν`.
* Eq. (1.2) defines `β^λ(t)` by Specht-character sums.  The paper explicitly
  observes that the character is integer-valued, hence these operators have
  integer coefficients, although the theorem is formulated over `C`.
* Theorem 1.3 gives commutativity, a translation identity, and quadratic
  Plücker relations; its part (v) says that eigenvalues on a Specht eigenspace
  are the Plücker coordinates of a Wronski-fibre point.
* §1.3.1, especially (1.8) and Proposition 1.6, identifies the moment curve,
  its rational-normal-curve closure, and osculating planes.  Proposition 2.8
  relates root multiplicities of the Wronskian to Schubert conditions for
  osculating flags.

This gives a precise conceptual bridge:

```
Specht/Bethe operators --(eigenvalues)--> Plücker coordinates
       |                                      |
       +-- noncrossing/Plücker relations --- Wronski/osculating Grassmannian
```

The bridge stops before the C909 issue.  `β^λ(t)` are group-algebra
operators/eigenvalue coordinates, not the columns `v_P` in the exterior
`X/Y` jet basis.  Karp–Purbhoo do not prove an integral lattice statement,
do not analyze the `p^a`-weighted block matrix, and do not give a product
formula for its maximal minors or Smith factors.  Their distinct-root and
Wronski-fibre results are over `C`; they cannot by themselves establish
unit minors modulo a DVR uniformizer.

The paper's use of the Vandermonde determinant is only the usual full-rank
criterion for the moment curve/total positivity discussion.  It does not
produce the C909 family of *filtered* minors.  In particular, an ordinary
confluent-Vandermonde determinant is a single determinant for prescribed
jets, whereas C909 needs all cumulative `Y`-degree ranks and their exact
integral pivots.

## What a successful proof identification would need

There are two plausible but currently unproved routes.

1. **Integral Bethe/Specht route.**  Construct an integral Specht/web lattice
   in which the coefficient blocks `F_(k,r)` are the graded pieces of a
   `β`- or Gaudin-type operator, then prove that its standard matching basis is
   unitriangular with respect to the jet/Dyck filtration.  The missing theorem
   is the integral filtered statement; the complex eigenvalue theorem is not
   enough.

2. **Direct osculating/confluent route.**  Exhibit, for each cumulative block,
   a square minor equal to

   ```
   ± ∏_(i<j) (t_j-t_i)^(m_ij)
   ```

   times a coefficient `±1` (or a unit independent of the tuple), with the
   exponents `m_ij` compatible across `r`.  This would immediately prove the
   required unit pivots whenever the differences are residue-field units.
   The `k=2` minor already has this shape: after the leading cancellation it
   is `p^a δ_13 δ_34 δ_14`.  No all-`k` factorization or source asserting it
   was found.

The first route might explain why the Dyck filtration is canonical; the
second would be the shortest proof.  At present neither route is supplied by
the located literature.

## Negative checks

The bounded search found only analogies, not a load-bearing formula:

* DCEP's integral Hodge-algebra theorem gives the unweighted Grassmannian
  standard-monomial basis and coefficient-`±1` Plücker straightening.  It
  controls the Catalan matching skeleton, but not the graph shear/rescaling,
  the jet filtration, or its Smith factors.
* The Wronski/osculating source gives Specht/Plücker operators and root-to-
  osculating-flag geometry, but no integral DVR saturation statement.
* Searches for `Temperley–Lieb immanant`, `noncrossing matching determinant`,
  `confluent Vandermonde`, `osculating Grassmannian`, and `Specht polynomial`
  produced standard matching/web/positivity constructions, not a theorem
  about this weighted coefficient matrix.  No citation-graph closure was
  attempted.

Thus the safe priority wording is: the C909 matrix is a **weighted filtered
Plücker/Specht (or web/Temperley–Lieb) evaluation suggested by the Wronski
and osculating picture**, while the all-`k` unit-minor/product formula is an
unproved local theorem here.  Do not claim that Karp–Purbhoo, DCEP, or
Temperley–Lieb immanant theory proves the Smith profile.

## Search/audit record

Opening full-text count: **two sources at full text** (DCEP, reused from the
earlier C909 audit, and Karp–Purbhoo, read here); no partial or
metadata-only source is used for the verdict below.  Citation-graph closure
was not attempted.

Load-bearing queries, verbatim:

* `osculating Grassmannian Wronskian Plucker coordinates Vandermonde standard monomial basis`
* `Temperley Lieb immanants Specht module determinant Vandermonde noncrossing matchings`
* `confluent Vandermonde osculating Grassmannian unit minor standard monomial matching matrix`
* `Temperley Lieb immanant noncrossing matchings determinant Plucker Specht module primary paper`

MathSciNet, Google Scholar, systematic zbMATH, and OpenAlex/Crossref/
Semantic-Scholar citation-graph closure were not covered.  No exhaustive
search of integral Bethe algebras, standard-web lattices, or immanant
monographs was attempted.

## Source records

### Karp–Purbhoo

* Read depth: **full text** — arXiv PDF, all 74 pages; load-bearing §§1.1,
  1.2, 1.3.1, 2.2, 2.3.1, and the statements/proofs around Theorem 1.3 and
  Proposition 2.8.
* Version/access: `arXiv:2309.04645v2`, 16 June 2026; cached PDF and extracted
  text.
* Cache key: `arXiv:2309.04645`.
* SHA-256: `bfc9e79ef082f341ec7615f1298cd64c1fa4a83a83b03efb71da42252ead7b24`.
* DOI link: <https://doi.org/10.48550/arXiv.2309.04645>.

### De Concini–Eisenbud–Procesi

* Read depth: **full text** — cached Numdam PDF, all 88 pages; §§1 and 11,
  especially Theorem 11.1, were used for the integral unweighted
  Grassmannian/Hodge-algebra comparison.
* Version/access: *Hodge algebras*, Astérisque 91 (1982), Numdam scan.
* Cache key: `AST_1982__91__1_0`.
* SHA-256: `fa857ea1c610f15d008f49e2b99966454ba4892b0a4d9bf34903e27731b8425f`.

## Bottom line for C909/C907

The osculating/Wronski/Specht connection is real and precise enough to guide
the proof architecture, but it is not the missing proof.  The next bounded
mathematical target is an explicit filtered-web/jet lemma or a direct family
of Vandermonde-product unit minors.  Until one is written and checked, the
Dyck-height Smith profile should remain conditional beyond the computed
small-`k` ranks.
