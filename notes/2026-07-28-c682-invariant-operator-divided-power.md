# C682 source-deep invariant-operator audit and mod-\(11\) divided powers

## Outcome

This pass read **two sources at `full text` depth**, retained **ten at
`partial` depth**, and retained one at `secondary only` depth.  It changes
both the literature boundary and the proposed characteristic-\(11\)
comparison.

The literature result is a subtraction, but not a pre-emption of the
combined C682 theorem.  Jacques Dixmier's 1992 paper is a direct and close
predecessor: it studies transvectants on binary-polyhedral isotypic
components and uses exactly
\[
 \Phi_{12}=XY(X^{10}+11X^5Y^5-Y^{10}).
\]
Accordingly, no paper claim may suggest that applying transvectants to
binary-icosahedral forms or using their vanishing on isotypic components is
new.  The source does **not** give the linear order-three operator
\[
 \mathcal D=(\,\cdot\,,\Phi_{12})_3/132,
\]
its finite \(6\)-by-\(6\) Weyl presentation on the complete
\(3\)-covariant module, its scalar-symbol \(E_8\) matrix factorization, or
the degree-\(22\) return-algebra defect.  No predecessor for that combined
statement was located in this source-deep pass.  The paper should still
say “to our knowledge,” because MathSciNet and a complete citation-graph
screen remain unavailable.

The arithmetic result is positive but lift-sensitive.  The reduction of
\(\mathcal D\) is a canonical divided-power operator **for the chosen
integral Klein lift modulo \(11^2\)**.  It is the first Bockstein of the
third Hasse derivatives of \(\Phi_{12}\), not the ordinary third
transvectant of \(\Phi_{12}\bmod 11\).  On \(\operatorname{Sym}^6\) it is
the nonzero scalar \(9\) times the already certified primitive
transvectant matrix.

The original Klein lift does not give the stronger proposed bridge to
C651 in the standard marking.  Its primitive image is disjoint from the
standard \(A_5\)-equivariant target four-space.  The `tt` pass, however,
finds the missing first-order correction: replacing \(F\) by \(F+11K\)
modulo \(121\), for an explicit degree-\(12\) polynomial \(K\), makes the
divided operator \(A_5\)-equivariant.  The repaired marked map is exactly
scalar \(5\) times the canonical target map.  The correction is unique
modulo the four-dimensional Frobenius-invisible kernel.

## Exact divided-power formula

Put
\[
 F=X^{11}Y+11X^6Y^6-XY^{11},\qquad
 \Delta(f)=(f,F)_3,\qquad \mathcal D=\Delta/132.
\]
Write \(\partial_X^{[a]}\partial_Y^{[b]}\) for Hasse derivatives and set,
for \(a+b=3\),
\[
 B_{a,b}(F)=
 \left(\frac{1}{11}\partial_X^{[a]}\partial_Y^{[b]}F\right)\bmod 11.
\]
Every numerator here is divisible by \(11\).  Since \(132=11\cdot12\),
the reduction of the primitive operator is
\[
\boxed{
 \overline{\mathcal D}(f)=
 \sum_{i=0}^{3}(-1)^i\frac{i!(3-i)!}{2}\,
 \partial_X^{[3-i]}\partial_Y^{[i]}f\;
 B_{i,3-i}(F).
}
\]
Equivalently,
\[
\overline{\mathcal D}(f)=
 3\partial_X^{[3]}f\,B_{0,3}
{}+10\partial_X^{[2]}\partial_Y^{[1]}f\,B_{1,2}
{}+\partial_X^{[1]}\partial_Y^{[2]}f\,B_{2,1}
{}+8\partial_Y^{[3]}f\,B_{3,0}
\quad(\bmod 11),
\]
where
\[
\begin{array}{c|l}
(a,b)&B_{a,b}(F)\\ \hline
(0,3)&9X^6Y^3+7XY^8\\
(1,2)&2X^5Y^4+6Y^9\\
(2,1)&5X^9+2X^4Y^5\\
(3,0)&4X^8Y+9X^3Y^6.
\end{array}
\]

This is not recoverable from the ordinary reduction of \(F\) alone:
\[
 \bar F=X^{11}Y-XY^{11}
\]
has all four ordinary third derivatives equal to zero in characteristic
\(11\).  The operator remembers \(F\bmod 121\).  In Bockstein language,
the class of each divided Hasse derivative records the first failure of
the characteristic-\(11\) Dickson invariant to have a constant
characteristic-zero lift.

The certificate checks the identity on every binary monomial of degree at
most \(28\), \(435\) monomials in total.  The formula is coefficientwise,
so this finite range is a regression suite rather than the reason for the
identity.

## Relation to the primitive \(\operatorname{Sym}^6\) map

Let \(P\) be the primitive integral matrix obtained by dividing the raw
map
\[
 \operatorname{Sym}^6\longrightarrow\operatorname{Sym}^{12},
 \qquad f\longmapsto(f,F)_3
\]
by its exact content \(2640\).  Since \(2640=20\cdot132\),
\[
 \mathcal D|_{\operatorname{Sym}^6}=20P
\]
over \(\mathbf Z\), and therefore
\[
 \overline{\mathcal D}=9\bar P,\qquad
 \bar P=5\overline{\mathcal D}
 \quad\text{over }\mathbf F_{11}.
\]
The common rank is \(4\).  This closes the arithmetic question left by
the raw transvectant: division before reduction is not an arbitrary
matrix-content trick, but the reduction of the Bockstein/Hasse operator
above.

It does not make \(\bar P\) equivariant for every characteristic-\(11\)
copy of \(A_5\).  The Bockstein depends on the integral lift, while the
C651 subgroup is defined intrinsically over \(\mathbf F_{11}\).  Those are
different data.

## The marked C651 test

The test uses the same order-\(60\) subgroup and natural five-point action
as the C651 certificate.  On the pair module \(P_{10}\), the relevant
four-space is the image of
\[
 E(y)_{\{i,j\}}=y_i+y_j,\qquad \sum_i y_i=0.
\]
For a projective matrix \(g\), the source and target binary-form actions
were taken to be
\[
 \det(g)^3\operatorname{Sym}^6(g^{-1}),\qquad
 \det(g)\operatorname{Sym}^{12}(g^{-1}).
\]
Both are independent of the chosen scalar representative over
\(\mathbf F_{11}\).

Exact linear algebra gives:

- \(\dim\operatorname{Hom}_{A_5}(P_{10},\operatorname{Sym}^6)=1\);
- its nonzero map has rank \(4\);
- \(\dim\operatorname{Hom}_{A_5}(P_{10},\operatorname{Sym}^{12})=3\);
- imposing the six-dimensional kernel of the source map selects a unique
  target four-map up to scalar;
- \(\bar P\) composed with the source map also has rank \(4\), but is not
  equivariant.

For all three stored generators, the equivariance defect
\[
 \rho_{12}(g)\bar P J-\bar P J\rho_{\mathrm{pair}}(g)
\]
has rank \(4\).  The first nonzero entries are respectively
\[
 (0,0;6),\qquad(0,1;4),\qquad(0,0;5).
\]
Each generator moves the primitive image so that the span of the old and
new images has rank \(8\).  Comparing the primitive image with the
uniquely selected equivariant target image also gives union rank \(8\);
hence their intersection has dimension \(0\).

This is stronger than failure of a guessed normalization.  There is no
scalar comparison to make under the standard C651 marking.  The C651
signed matching cubic still restricts to \(4\sigma_3\) on its four-chart,
but transporting that chart through \(\bar P\) does not produce the
standard target \(A_5\)-module.

The `ej`/`tt` closeout identifies the entire defect.  Lift each stored
matrix \(g\) with entries in \(\{0,\ldots,10\}\), invert it modulo \(121\),
and define
\[
 L_g=\frac{\det(g)F(g^{-1}z)-F(z)}{11}\bmod11.
\]
All three \(L_g\) are nonzero.  Exact covariance of the characteristic-zero
transvectant gives, and both replays verify,
\[
 \rho_{12}(g)\bar P-\bar P\rho_6(g)
 =
 \frac{5\det(g)^3}{12}
 \bigl(\operatorname{Sym}^6(g^{-1})(-),L_g\bigr)_3.
\]
On the ambient \(\operatorname{Sym}^6\), each right-hand operator has rank
\(7\); its restriction to the C651 four-space is precisely the recorded
rank-\(4\) defect.  The failure is therefore the first-order
mod-\(121\) failure of the chosen C651 matrices to preserve the integral
Klein lift.  It is not a basis artifact.

## `tt` repair: the compatible divided lift

The defect equation is linear in a first-order change of lift.  Solving
the full ambient equivariance equations, not merely their restriction to
the C651 four-space, gives
\[
\begin{aligned}
K={}&10X^{10}Y^2+5X^9Y^3+7X^8Y^4+8X^7Y^5+2X^6Y^6\\
   &+3X^5Y^7+7X^4Y^8+6X^3Y^9+10X^2Y^{10}
   \quad\in\mathbf F_{11}[X,Y].
\end{aligned}
\]
For the adjusted mod-\(121\) lift \(F^{\mathrm{tt}}=F+11K\), define
\[
 P^{\mathrm{tt}}
 =\bar P+\frac5{12}(\,\cdot\,,K)_3.
\]
Then
\[
 \rho_{12}(g)P^{\mathrm{tt}}
 =P^{\mathrm{tt}}\rho_6(g)
\]
for all three generators, hence for the whole \(A_5\).  The repaired map
still has rank \(4\).

The linear system has rank \(9\) in \(13\) unknowns.  Its four-dimensional
ambiguity is exactly
\[
 W_{\mathrm{Fr}}
 =\langle X^{12},X^{11}Y,XY^{11},Y^{12}\rangle.
\]
Every element of \(W_{\mathrm{Fr}}\) has zero ordinary third derivatives
modulo \(11\), so the divided transvectant cannot see this ambiguity.
After the displayed correction, each residual lift defect lies in
\(W_{\mathrm{Fr}}\).  Thus \(F^{\mathrm{tt}}\) is invariant in precisely
the operator-visible quotient, which is the correct datum for the
order-three bridge.

The `ej` pass makes the quotient intrinsic.  The complete right-slot map
\[
 \Theta:\operatorname{Sym}^{12}\longrightarrow
 \operatorname{Hom}(\operatorname{Sym}^6,\operatorname{Sym}^{12}),
 \qquad K\longmapsto(\,\cdot\,,K)_3
\]
has rank \(9\) and kernel exactly \(W_{\mathrm{Fr}}\).  Moreover,
\[
 W_{\mathrm{Fr}}=V^{(1)}\otimes V
\]
inside degree \(12\): its four displayed monomials are the products of a
degree-\(11\) Frobenius coordinate with a linear coordinate.  It is also
the raw infinitesimal \(GL_2\)-orbit of the Dickson form
\(\bar F=X^{11}Y-XY^{11}\), since
\[
 X\bar F_X,\quad Y\bar F_X,\quad X\bar F_Y,\quad Y\bar F_Y
\]
are nonzero scalar multiples of the four basis monomials.  Consequently,
the bridge determines a canonical class
\[
 [K]\in\operatorname{Sym}^{12}/(V^{(1)}\otimes V),
\]
while changing its representative is exactly first-order
coordinate/scalar gauge.  The previously unexplained four degrees of
freedom are therefore fully accounted for.

If \(J:P_{10}\to\operatorname{Sym}^6\) is the unique C651 source
intertwiner and \(T:P_{10}\to\operatorname{Sym}^{12}\) is the unique
target intertwiner with \(\ker T=\ker J\), the exact marked comparison is
\[
\boxed{P^{\mathrm{tt}}J=5T.}
\]
This restores the hoped-for multiplicity-one bridge after making the
integral lift compatible.  It does not reduce the rational Gaunt scalar,
whose denominator remains divisible by \(11\); the cross-characteristic
claim remains the common integral Clebsch cubic line.

## Source-deep literature audit

### Direct predecessor: Dixmier

Jacques Dixmier's *Transvectants des formes binaires et représentations
des groupes binaires polyédraux* is the closest source found.

The complete \(49\)-page scan was OCRed for navigation and read from
beginning to end; the load-bearing formulas and propositions were then
checked against the authoritative page images.  Section 4.2.1 writes the
same Klein dodecic used by C682.  Proposition 2.4 derives vanishing of
certain high self-transvectants of invariant forms from invariant
Poincaré series.  Proposition 2.6 derives transvectant vanishings on the
full isotypic components of the two spinorial two-dimensional
representations.  The paper's main problem is the zero locus of quadratic
self-transvectants.

This exactly pre-empts any broad claim of novelty for:

- transvectants organized by binary-polyhedral representation theory;
- the Klein dodecic as the binary-icosahedral input;
- isotypic-component transvectant vanishing deduced from Poincaré series.

It does not construct or discuss:

- the linear fixed-invariant operator \(f\mapsto(f,F)_3\);
- a finite Weyl matrix on the complete \(3\)-covariant MCM module;
- its principal symbol or an \(E_8\) matrix factorization;
- the return algebra or its first degree-\(22\) saturation defect;
- reduction at \(11\), Hasse derivatives, or a Bockstein operator.

The broad crown “binary-icosahedral transvectants” is therefore closed as
classical.  A bounded adjacent-crown extraction tested two gaps exposed by
the source: fixed-invariant linear operator matrices and bad-prime
divided-power reduction.  The first is already the surviving C682
realization theorem; the second is the formula certified here.  No new
task IDs are warranted.

### General transvectant operators

Olver--Sanders was promoted from `partial` to `full text`.  It treats
transvectants through Cayley's omega process and develops their
star-product, Moyal, Rankin--Cohen, Hirota, projective Pochhammer, and
Heisenberg interpretations.  This firmly makes the invariant
bidifferential-operator viewpoint classical.

It never specializes to the Klein dodecic or the binary-icosahedral
three-covariant MCM module.  It contains no finite \(E_8\) operator
matrix, bad-prime content calculation, or divided-\(11\) comparison.

### Invariant differential operators and covariants

Schwarz gives a general theory of lifting differential operators from
orbit spaces and includes differential operators on modules of
covariants.  Bøgvad--Källström study the decomposition of a polynomial
ring under invariant differential operators through lowest-weight
spaces; their binary examples are cyclic and dihedral.  These sources
supply the correct surrounding framework, but the inspected statements
do not compute the binary-icosahedral order-three operator or its symbol.

Broer--Chuai treats modules of covariants in arbitrary characteristic and
distinguishes modular from non-modular invariant theory.  Since
\(11\nmid120\), the C682 reduction is in the non-modular finite-group
regime, but their freeness and Jacobian criteria do not provide the
divided Hasse formula above.

Donkin--Martin uses divided-power operators for rational
\(\mathrm{SL}_2\)-modules in positive characteristic and solves a
Clebsch--Gordan decomposition problem.  This licenses standard
divided-power language, not the specific Bockstein transvectant or the
C651 marking.

## Claim disposition after the deep pass

| Claim | Disposition |
|---|---|
| Binary-icosahedral transvectants and isotypic vanishing | pre-empted by Dixmier |
| Omega-process/invariant-bidifferential interpretation | classical; Olver--Sanders |
| Six Kostant degrees and MCM structure | classical, as in the quick audit |
| Primitive \(103\)-term order-three Weyl matrix | surviving new candidate |
| Scalar principal cubic realizing the \(E_8\) three-node factorization | strongest surviving realization claim |
| Degree-\(22\) first return-algebra defect and Koszul dark line | surviving new candidate |
| Content \(132\) and mod-\(11\) survival | now explained by the Bockstein/Hasse formula |
| \(A_5\)-equivariant bridge from C651 through the original \(\bar P\) | false; its image is disjoint from the target four-space |
| Corrected divided-power bridge from \(F+11K\) | true; unique modulo \(W_{\mathrm{Fr}}\), with marked scalar \(5\) |

Recommended paper wording:

> To our knowledge, the primitive third transvectant by Klein's
> dodecic gives the first explicit finite Weyl realization of the
> three-dimensional \(E_8\) McKay matrix factorization whose return
> algebra has the stated degree-\(22\) Koszul defect.

The manuscript should cite Dixmier immediately when introducing the
binary-polyhedral transvectant setting, and Olver--Sanders when identifying
the omega-process operator.

## Source record

- Jacques Dixmier, *Transvectants des formes binaires et représentations
  des groupes binaires polyédraux*, Portugaliae Mathematica 49 (1992),
  349--396.  Read depth: `full text`, all \(49\) scan pages; OCR was a
  navigation aid and the load-bearing pages were checked visually.
  EUDML record `115795`; cached authoritative PDF SHA-256
  `d8785cd84d2ce66087f2497a3bc2654f60f1ed67dd3b8add3e94a080130ab7fc`.
- Peter J. Olver and Jan A. Sanders, *Transvectants, Modular Forms, and
  the Heisenberg Algebra*.  Read depth: `full text`, all \(28\) pages.
  Cache key `10.1006/aama.2000.0697`; PDF SHA-256
  `ce4193bab21fd0e617083c53478def71c7323d64210d48b4db70a5bc76e86dde`.
- Gerald W. Schwarz, *Lifting differential operators from orbit spaces*.
  Read depth: `partial`, abstract, Introduction, Theorem 0.14, and the
  inspected covariant-bundle/lifting statements.  Cache key
  `10.24033/asens.1714`; PDF SHA-256
  `fbf73b391ab442ce82377150422e361fae358f96383e9c0f6f439368631872eb`.
- Rikard Bøgvad and Rolf Källström, *Decomposition of modules over
  invariant differential operators*.  Read depth: `partial`, abstract,
  Introduction, setup, and the cyclic/dihedral section.  Cache key
  `arxiv:1506.06229`; PDF SHA-256
  `8bd982b06ae35130a5ad173545b66e329f2d81975a8d9a1dd49b2de3628d9595`.
- Stephen Donkin and Samuel Martin, *A Clebsch--Gordan decomposition in
  positive characteristic*.  Read depth: `partial`, Introduction and the
  divided-power setup in Section 2.  Cache key `arxiv:1904.02521`; PDF
  SHA-256
  `a91e59ae2db2699b6fd59ad9695b21ec40e9d2724baaabd255ddf1167ab745a4`.
- Abraham Broer and Jianjun Chuai, *Modules of covariants in modular
  invariant theory*.  Read depth: `partial`, abstract, Introduction, and
  the stated freeness/Jacobian criteria.  Cache key `arxiv:0709.0703`;
  PDF SHA-256
  `e8b7e4504c1acfe005fc2087259c93de95e987d8a6d24bd7dc78eff82309ac7e`.
- Ruedi Suter; Bertram Kostant; Carina Curto and David R. Morrison; Harun
  Omer; Jeffrey M. Barnes, Georgia Benkart, and Tom Halverson; and Peter
  Kramer.  Read depth: `partial`, with exact sections, identifiers, and
  PDF hashes recorded in
  `notes/2026-07-28-c682-klein-e8-literature-audit.md`.
- G. Gonzalez-Sprinberg and J.-L. Verdier, *Construction géométrique de
  la correspondance de McKay*.  Read depth: `secondary only`, through
  Curto--Morrison, as recorded in the quick audit.

## Search coverage and boundary

The source-deep pass screened exact combinations of:

```text
"binary icosahedral" transvectant
"groupes binaires polyédraux" transvectants
"Klein dodecic" differential operator
binary polyhedral invariant differential operators covariants
Kleinian singularity invariant differential operators module covariants
positive characteristic transvectant divided powers SL2
modular invariant theory modules of covariants binary icosahedral
```

Coverage included EUDML/Euclid-style bibliographic records, Numdam,
arXiv, Crossref-style title/abstract discovery, direct-source reference
lists, and general web discovery followed by cached-PDF inspection.
Dixmier and Olver--Sanders were the two core full-text reads.  No
citation-graph negative is claimed.

Remaining limits:

- MathSciNet was unavailable;
- Google Scholar automated access was unavailable;
- the complete forward-citation graph of Dixmier was not screened;
- Schwarz, Bøgvad--Källström, Broer--Chuai, and Donkin--Martin were read
  only to the stated partial depths;
- this is not a priority opinion from a subject-matter referee.

These limits support a qualified “to our knowledge,” not an unqualified
firstness claim.

## Reproducibility

The primary script
`notes/2026-07-28-c682-invariant-operator-divided-power.py` rebuilds the
Bockstein terms, primitive matrix, standard \(A_5\) actions, Hom spaces,
equivariance defects, and source hashes.  Its JSON certificate is
`notes/2026-07-28-c682-invariant-operator-divided-power.json`.

The independent replay
`notes/2026-07-28-c682-invariant-operator-divided-power-replay.py`
reimplements polynomial differentiation, Hasse differentiation,
transvectants, finite-field row reduction, symmetric-power actions, and
the obstruction checks without importing the primary script.

## Mystery ledger

- **Closed:** why the raw third transvectant vanishes modulo \(11\) while
  its primitive integral matrix survives.  The survivor is the
  \(11\)-Bockstein/Hasse operator.
- **Closed negatively:** whether the primitive map supplies the standard
  \(A_5\)-equivariant C651-to-target four-space bridge.  It does not; the
  two target images are disjoint.
- **Closed:** what causes the equivariance failure.  The three defects are
  exactly transvectants with the nonzero mod-\(121\) lift cocycles \(L_g\);
  the ambient correction operators all have rank \(7\).
- **Closed by `tt`:** whether a compatible divided lift repairs the
  bridge.  The displayed \(K\) makes the full ambient operator equivariant,
  and \(P^{\mathrm{tt}}J=5T\).
- **Explained:** the four remaining degrees of freedom are exactly the
  Frobenius-invisible space \(W_{\mathrm{Fr}}=V^{(1)}\otimes V\), the
  kernel of the right-slot third transvectant and the raw infinitesimal
  \(GL_2\)-orbit of \(\bar F\), not an uncontrolled normalization.
- **Open:** whether the canonical first-order class
  \([K]\in\operatorname{Sym}^{12}/(V^{(1)}\otimes V)\) extends to a
  compatible \(11\)-adic tower.  The next exact gate is the mod-\(11^3\)
  lift equation modulo coordinate/scalar gauge.
- **Open:** an intrinsic geometric interpretation of the scalar
  principal cubic \(p\).
- **Open:** source-deep forward-citation closure strong enough to remove
  “to our knowledge.”

C682 remains open; completion is the user's decision.
