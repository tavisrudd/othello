# C705 — adjugate realization of the Segre--Igusa polar map

**Date:** 2026-07-30

**Lane:** `clebsch`

**Status:** main gates complete; negative raw-adjugate gate, positive
compound/Jacobian adjugate theorem, exact boundary and inverse geometry;
common-\(E_6/E_8\) shadow-source mining active.

## Outcome

The raw \(2\times2\) minors of the six cross-golden blocks cannot map
linearly to the Igusa carrier.  This failure is exact and revealing: all
\(54\) minors span the same irreducible \(9\)-space \([4,2]\) as the
contracted differentials \(dZ_T\), while the ordinary and signed
outer-standard \(5\)-spaces occur with multiplicity zero.

The correct construction assembles the block adjugates before taking a
higher compound.  Let
\[
 G_x:k^{\mathcal T}\longrightarrow A_X^\vee,\qquad
 e_T\longmapsto dZ_T|_x.
\]
Each column is intrinsically an adjugate trace:
\[
 dZ_T|_x(y)
 =\kappa_T\operatorname{tr}\!\left(
   \operatorname{adj}(B_T(x))B_T(y)\right),
 \qquad
 B_T(x)=P_{T,-}D_xP_{T,+},
\]
where \(\kappa_T\) is fixed by C704's determinant-line orientation.
Because \(\sum_TZ_T=0\), \(G_x\) factors through the outer augmentation
module.  In the integral quotient bases
\[
 u_i=e_i-e_5,\qquad v_T=e_T-e_{T_5},
\]
write
\[
 A(x)_{iT}=dZ_T(u_i)-dZ_{T_5}(u_i).
\]
This is a \(5\times5\) matrix of quadratic forms.

Put
\[
 q_i(x)=6x_i^2-\sum_{j=0}^5x_j^2,\qquad
 W_T(x)=6Z_T(x)^2-\sum_UZ_U(x)^2.
\]
With \(q_5=-\sum_{i<5}q_i\) and
\(W_{T_5}=-\sum_{T\ne T_5}W_T\), the exact identity is
\[
 \boxed{\qquad
 \operatorname{adj}A(x)=6\,W(x)\,q(x)^{\mathsf T}.
 \qquad}
\]
Thus the outer Segre--Igusa polar and the ordinary centered-square
direction are the two rank-one factors of the assembled operator
adjugate.  This constructs the polar line as the unique nonconstant
relation among the six cross-block adjugate traces, without defining it
by six scalar squares.

There is an even lower-degree positive form.  The third compound
\(\bigwedge^3A(x)\) has degree six.  Its \(100\) entries span a
\(70\)-dimensional polynomial space, and the five polar sextics lie in
that span.  Representation-theoretically,
\[
 \dim\operatorname{Hom}_{S_6}\!\left(
 \bigwedge\nolimits^3 A_X\otimes
 \bigwedge\nolimits^3 O_X,\ O_X\right)=1,
\]
where \(O_X\) is the outer-standard module.  Hence the unique
outer-standard summand of the third compound is exactly the Igusa polar
carrier.  The fourth compound gives the stronger rank-one factorization
above and fixes the scalar \(6\).

## Why the source factor is canonical

The relation \(G_xq(x)=0\) is the infinitesimal
\(\operatorname{PGL}_2\)-quotient direction, not a coordinate accident.
For \(\omega_x=[D_x,C]\),
\[
 [D_{x^2},C]=D_x\omega_x+\omega_xD_x.
\]
The right side is the derivative of the congruence
\[
 \omega_x\longmapsto
 (I+tD_x)\omega_x(I+tD_x).
\]
Pfaffians transform by the determinant of the congruence matrix, whose
first derivative is \(\operatorname{tr}D_x=\sum_i x_i=0\) on \(A_X\).
Therefore
\[
 dZ_T|_x(x_0^2,\ldots,x_5^2)=0.
\]
Subtracting the mean square does not change the commutator, giving the
displayed \(q\).

Equivalently, on the centered affine chart of six ordered points on
\(\mathbf P^1\), \(q/6\) is the special-conformal vector field
\[
 \dot x_i=x_i^2-\frac16\sum_jx_j^2.
\]
Together with translation and scaling it is the residual
\(\mathfrak{sl}_2\)-action.  The Joubert cubics are its first integrals,
as required by the GIT quotient
\((\mathbf P^1)^6/\!/\operatorname{PGL}_2\).

The other relation is the differentiated Segre equation:
\[
 \sum_TW_T\,dZ_T
 =6\sum_TZ_T^2\,dZ_T
 =2\,d\!\left(\sum_TZ_T^3\right)=0.
\]
An exact witness gives \(\operatorname{rank}G_x=4\), so generically these
two relations span the full kernel.  The coordinate-free form is the
rank-one fourth compound of
\[
 \bar G_x:O_X\longrightarrow A_X^\vee;
\]
the displayed adjugate is its expression after fixing the frozen
augmentation and determinant-line orientations.

## The two Mori contractions are the sisters

Moon's symmetric Mori program gives a global interpretation of the two
factors.  The common resolution \(\overline M_{0,6}\) has two distinguished
symmetric contractions
\[
 \rho:\overline M_{0,6}\longrightarrow \mathsf S_3,\qquad
 \phi:\overline M_{0,6}\longrightarrow \mathsf I_4.
\]
The first contracts the \(B_3\) boundary to the ten Segre nodes; the second
contracts the \(B_2\) boundary to the fifteen Igusa singular lines.  On the
open six-point moduli space, HMSV's centered-square formula identifies
\(\phi\) with the Segre Gauss map composed with \(\rho\):
\[
 \phi=\nabla\mathsf S_3\circ\rho.
\]

In the centered six-point slice, \(A\) is the Jacobian of \(\rho\).  Its
right kernel \(q\) is the residual special-conformal
\(\operatorname{PGL}_2\) direction before quotienting, while its left
kernel \(W\) is the conormal of the Segre hypersurface and hence the
coordinate vector of the dual contraction.  Thus
\[
 \operatorname{adj}(A)=6Wq^{\mathsf T}
\]
is the local differential certificate for the global pair of Mori
contractions.  It supplies a concrete operator form of the projective-dual
map that Moon singled out as desirable to describe through
\(\overline M_{0,6}\).

The C705 boundary calculation is compatible with this resolution picture:
the twenty labeled triple-collision planes pair by complementary triples
over the ten \(B_3\) contractions, and the fifteen Segre planes map to the
fifteen \(B_2\)-type singular lines on the Igusa side.

Schock places both sisters inside one exceptional parent.  Each \(A_1\)
boundary divisor in Naruki's \(W(E_6)\)-equivariant compactification of
marked cubic-surface moduli is an \(\overline M_{0,6}\), and two
\(W(E_6)\)-equivariant contractions restrict to \(\rho\) and \(\phi\).
Hence a common \(E_6\) parent is now established at the level of birational
models.  Whether the actual first-jet tensor \(A\) lifts to the ambient
\(E_6\) contractions, and then through C682's specific golden/\(E_8\)
operator descent, remains the active shadow-source gate.

## The raw obstruction and the successful repair

The first falsifier is negative:
\[
 \operatorname{span}\{
 2\times2\text{ minors of }B_T:T\in\mathcal T\}
 \cong[4,2],\qquad \dim=9.
\]
The same \(9\)-space is spanned by all coefficients of \(dZ_T\).  Since
\[
 \operatorname{Sym}^2[5,1]=[6]\oplus[5,1]\oplus[4,2],
\]
and the outer-standard carrier is the distinct irreducible
\([2,2,2]\), both exact Hom spaces vanish:
\[
 \operatorname{Hom}_{S_6}([4,2],[2,2,2])=0,\qquad
 \operatorname{Hom}_{S_6}([4,2],[3,3])=0.
\]

This also settles the two adjacent raw variants.  Exterior squaring a
\(3\times3\) cross block is the adjugate with determinant-line twists, so
it has the same carrier.  A trace-free projection cannot change that
carrier and, before choosing an unowned identification
\(V_{T,-}\simeq V_{T,+}\), there is no intrinsic trace at all.

The successful repair is minimal in polynomial degree:

- the raw minors and first assembled matrix have degree two and no outer
  \(5\);
- the second compound has degree four and cannot equal the sextic polar;
- the third compound has degree six, contains the polar carrier, and has
  a unique outer-standard source summand; and
- the fourth compound has degree eight and factors as the degree-six
  polar times the degree-two projective-motion vector.

Thus the negative linear-Hom calculation identifies exactly why one must
assemble first and take a higher compound.

## Boundary and collision geometry

The base loci are completely explicit over characteristic zero.

### Joubert map

The five-dimensional Joubert cubic span equals the span of the fifteen
matching brackets
\[
 (x_b-x_a)(x_d-x_c)(x_f-x_e).
\]
Its base scheme is reduced and equals the union of the fifteen lines on
which four specified coordinates coincide.  These are exactly the
unstable six-point configurations.

### Pulled-back Segre polar

The sextics \(W_T\) have reduced base scheme
\[
 \bigcup_{\lvert Q\rvert=3}
 \{x_i=x_j=x_k\text{ for }i,j,k\in Q\},
\]
the union of twenty projective planes of total degree \(20\).  For the
representative \(x_0=x_1=x_2=a\),
\[
 (Z_T)_T
 =(a-x_3)(a-x_4)(a-x_5)\,
 (-1,1,1,-1,-1,1).
\]
Thus every triple-collision plane maps constantly to one Segre node away
from the four-equal base lines.  Complementary triples give the same
projective node, so the twenty planes occur in ten pairs.  The two planes
in a pair meet at the corresponding \(3+3\) point.

The ten centered-square base points
\[
 [x_i]=[(1,1,1,-1,-1,-1)]
\]
map bijectively, under the outer automorphism, to the ten Segre nodes.
At a general point the assembled matrix has rank \(4\); on a general
triple-collision plane it has rank \(3\); and at a \(3+3\) point it has
rank \(1\).

### Fifteen planes and Igusa lines

For every matching
\(\{\{a,b\},\{c,d\},\{e,f\}\}\), the Segre plane
\[
 z_a+z_b=z_c+z_d=z_e+z_f=0
\]
is sent by the polar factor extracted from \(\operatorname{adj}A\) to
\[
 w_a=w_b,\qquad w_c=w_d,\qquad w_e=w_f,\qquad \sum_Tw_T=0.
\]
These are exactly the fifteen reduced singular lines of the Igusa
quartic.  The exact singular ideal and all fifteen linear prime
components were checked independently.

## Inverse operator polarity

Let
\[
 w_i=z_i^2-\frac16\sum_jz_j^2
\]
on the Segre cubic, and put
\[
 y_i=\operatorname{center}_i\!\left(
 w_i\sum_jw_j^2-4w_i^3\right).
\]
Newton reduction using \(e_1=e_3=0\) and
\[
 t^6+e_2t^4+e_4t^2-e_5t+e_6=0
\]
at \(t=z_i\) gives
\[
 \boxed{\qquad y_i=-4e_5(z)z_i.\qquad}
\]
Thus the Igusa-to-Segre polar map recovers the six cross-block
determinants on \(e_5\ne0\).  Scheme-theoretically,
\[
 \{e_5=0\}\cap\operatorname{Segre}
\]
is the reduced union of the fifteen Segre planes, of total degree \(15\).
This is exactly the exceptional divisor contracted to the fifteen
singular Igusa lines.

For the integral convention
\(\widetilde w_i=6z_i^2-\sum_jz_j^2\), the checked factor is
\(-5184e_5(z)z_i\).

## Arithmetic boundary

The factorization is an integral polynomial identity, but its rank content
changes at the primes dividing the scalar \(6\).

| characteristic | generic rank of \(G\) | generic rank of \(A\) | meaning |
|---|---:|---:|---|
| \(2\) | \(1\) | \(0\) | all signs and all six outer shadows coalesce |
| \(3\) | \(3\) | \(3\) | every fourth minor vanishes; the polar cannot be extracted by the fourth compound |
| \(5\) | \(4\) | \(4\) | the descended identity remains nondegenerate although the golden splitting ramifies |
| \(7\) | \(4\) | \(4\) | ordinary good witness |

The rank upper bounds at \(2,3\) follow from the exact identities; the
listed points provide matching lower-bound witnesses.  Thus the adjugate
assembly introduces a genuine characteristic-\(3\) boundary not visible
in C704's cross-block determinant scalar, while characteristic \(5\) is
bad only for splitting the golden eigenspaces, not for the descended
polar identity.

## Double `ej` + double `tt` closeout

### `ej1`

The first extra-juice pass extracted the generic two-relation theorem,
the exact scalar-\(6\) adjugate factorization, the ten-node bijection, the
fifteen plane-to-line contractions, and the explicit inverse polar
formula.  It also promoted the base-locus question from a set-theoretic
guess to exact reduced scheme decompositions.

### `tt1`

The first structural challenge identified \(q\) as the residual
\(\mathfrak{sl}_2\) vector field and derived its kernel relation from
Pfaffian congruence.  It separated the formal rank-one adjugate lemma from
the operator input: the formal lemma is general, while the task-owned
content is that the cross-golden block adjugates supply \(dZ_T\) and that
their other kernel is the projective-motion direction.  It also exposed
the distinct characteristic-\(2\), \(3\), and \(5\) boundaries.

### `ej2`

After incorporating those repairs, the second extra-juice pass found the
minimal degree-six construction: the unique outer-standard component of
the third compound.  It then identified the twenty triple-collision
planes, their complementary pairing over the ten nodes, the common
boundary factor on each plane, and the exceptional equation
\(e_5=0\) as the union of the fifteen Segre planes.

### `tt2`

The final structural pass tested minimality, converse content, and
novelty level.

- Lower compounds cannot carry the sextic polar; the third compound is
  the first possible degree and its relevant Hom space is
  one-dimensional.
- Kraft's multiplicity-one signed outer cubic covariant means the input
  Joubert system is itself unique up to scale; the compound theorem does
  not hide a family of alternative outer cubics.
- The factorization is formally forced once both kernel lines are known.
  Its conceptual value is therefore an operator/GIT identification, not
  a claim to have discovered Segre--Igusa duality.
- No ADE-uniform conclusion follows: the proof uses the six-point
  \(\operatorname{PGL}_2\) quotient and the outer automorphism of \(S_6\)
  essentially.

All cheap in-scope leads from the four passes were either proved above or
placed in the mystery ledger below.

## Mystery ledger

| feature | status | exact remaining gate or owner |
|---|---|---|
| Why raw block adjugates fail | settled: their complete carrier is \([4,2]\), with zero outer-\(5\) Hom | none |
| Why the assembled adjugate factors | settled: its right and left kernels are the Segre polar and residual \(\mathfrak{sl}_2\) direction | none |
| Why the first successful compound is the third | settled by degree and the unique outer-standard summand | none |
| Meaning of the twenty pulled-back base planes | settled: triple-collision GIT boundary, paired over ten nodes | none |
| Meaning of the factor \(6\) | settled integrally; it is the normalization coupling the two centered-square maps and causes the \(2,3\) rank collapse | a refined integral moduli model belongs to future WP5 |
| Whether the third-compound presentation is already classical | open: no formula match was found in the proportional audit, but originals and a formula-level modern sweep remain incomplete | WP11 before any priority claim |
| Whether the sister diagram has a common exceptional parent | settled at the birational-model level: both contractions are restrictions of \(W(E_6)\)-equivariant contractions to an \(A_1\cong\overline M_{0,6}\) divisor | lift their first-jet pairing and identify its restriction with \(A\) |
| Whether \(q,W,A\) are shadows of one \(E_8\)-level tensor | open: the common outer-\(S_6\) descent and rank-one adjugate are strong internal evidence, while the checked Segre/Igusa automorphic models use \(A_2\)- and type-IV lattices rather than an explicit common \(E_8\) lift | C705 common-\(E_8\) shadow-source mining subtask; require a simultaneous branching and parent contraction, or record the first obstruction and nearest \(E_6/A_2/S_6\) repair |
| Marked equality with C695's double-six | untouched by design | future WP2 |
| Uniform sister analogue | not implied by this proof | WP7--WP9 only after allocation |

## Literature boundary

The proportional audit uses three modern sources: one previously read at
`full text` and revisited here, and two at `partial` depth.  It makes no
novelty or priority claim.

- Howard--Millson--Snowden--Vakil, *A description of the outer
  automorphism of \(S_6\), and the invariants of six points in projective
  space*, arXiv:0710.5916v1 — `full text`, cached PDF
  `arXiv:0710.5916`, SHA-256
  `d2da258cd8513a9b782a8270baa82acc51bc8d552e18db104967c2a08bffebfc`;
  all eight pages were read in C704 and §§1.6, 2.1, 2.3, 2.4 were
  revisited.  It supplies the outer modules, six-point GIT quotient,
  matching invariants, Segre equations, and centered-square duality.
- Hanspeter Kraft, *A Result of Hermite and Equations of Degree 5 and 6*,
  arXiv:math/0403323v2 — `partial`, cached PDF
  `arXiv:math/0403323`, SHA-256
  `969440e0bedbc70fa9c2d97720407c9d7da821179aa5141b75b050a3c79afbec`;
  Theorem B and §§2, 5 were read.  It proves that the signed outer cubic
  covariant is the lowest-degree one and identifies its
  representation-theoretic multiplicity.
- Shigeyuki Kondō, *The Segre cubic and Borcherds products*,
  arXiv:1110.1126v1 — `partial`, cached PDF
  `arXiv:1110.1126`, SHA-256
  `0595df2ed7631ba366b1603aca9a924ef08cb93cdc84b906f2877b68c777e9be`;
  §§2, 3.10, and 6.8 were read.  It records the ten nodes, fifteen planes,
  birational dual map, and automorphic realization.
- Han-Bom Moon, *Mori's program for \(\overline M_{0,6}\) with symmetric
  divisors*, arXiv:1403.7224 — `targeted full text`, introduction,
  Theorem 5.2, and Remarks 5.3--5.5.  It identifies the Segre and Igusa
  varieties as the two symmetric Mori models, specifies their complementary
  contracted boundaries, and asks for a concrete description of the dual
  map through \(\overline M_{0,6}\).
- Nolan Schock, *The \(W(E_6)\)-invariant birational geometry of the
  moduli space of marked cubic surfaces*, arXiv:2309.15264v2 —
  `targeted full text`, introduction, Theorem 3.6, and Remark 3.7; cached
  PDF SHA-256
  `67c1f52c6df71abfb0a537aa55111929d05f812180070e891121d37440c896e5`.
  It realizes both contractions as restrictions of two
  \(W(E_6)\)-equivariant contractions to an
  \(A_1\cong\overline M_{0,6}\) boundary divisor.

The wider situational sweep, including the Coble,
homological-projective-duality, Jacobian-dual, and \(E_8\) search
branches, is recorded in
`notes/2026-07-30-c705-shadow-sisters-literature-map.md`.

Four exact web searches screened titles and snippets for
`"Segre cubic" Jacobian adjugate Igusa quartic`,
`Joubert covariant Jacobian minors Igusa quartic`,
`"Segre cubic" "third compound" polar map`, and
`"Igusa quartic" adjugate matrix Segre`.  They returned classical duality,
automorphic, modular, and birational-geometry treatments but no visible
match to the compound identity.  This was a metadata screen, not a
full-text absence audit.  Joubert's and Coble's originals, MathSciNet,
zbMATH, and a citation-graph closure were not covered.  Consequently the
only licensed statement is that the operator/compound formula was not
located in this bounded audit.

The disposition remains a paper-independent research theorem.  It does
not reopen Papers I--III.  Publication would trigger WP11's formula-level
audit.

## Reproducibility

Primary exact generator:

```sh
cd /home/tavis/src/othello
python3 notes/2026-07-30-c705-adjugate-segre-igusa-polar.py --check
```

Scheme certificate:

```sh
cd /home/tavis/src/othello
python3 notes/2026-07-30-c705-adjugate-segre-igusa-base-locus.py --check
```

Independent finite-field replay:

```sh
cd /home/tavis/src/othello
python3 notes/2026-07-30-c705-adjugate-segre-igusa-polar-replay.py
```

The primary generator performs exact arithmetic over
\(\mathbf Q(\sqrt5)\) for the six cross blocks and coefficientwise
integer/rational polynomial checks after descent.  It checks all \(54\)
block cofactors, all \(25\) entries of the adjugate factorization, the
third-compound and character multiplicities, node/plane formulas, inverse
polarity, and characteristic witnesses.  Its frozen input is C704's
conference matrix and outer-six marking.

The scheme wrapper runs Singular 4.4.1 through `nixpkgs#singular` and
checks exact ideal equality, radicals, primary decompositions, dimensions,
and degrees.  The replay hard-codes the independently extracted six cubic
coefficient rows and checks
\(\operatorname{adj}A=6Wq^{\mathsf T}\) over \(\mathbf F_{101}\) on the
full \(9^5=59049\) grid.  Since every difference has degree at most eight
in each variable, this is a complete polynomial-identity check modulo
\(101\), not random sampling.

Checksums are recorded in
`notes/2026-07-30-c705-adjugate-segre-igusa-polar.sha256`.
