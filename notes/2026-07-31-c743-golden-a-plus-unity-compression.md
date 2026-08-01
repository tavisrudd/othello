# C743 — Golden A+ unity and compression programme

**Date:** 2026-07-31

**Lane:** `golden`

**Status:** active; theorem candidates proved and under simplicity red-team;
external review will grade them

## Executive verdict

After the simplicity red-team, the current results reduce to three mechanisms.
They replace the central collection of exterior, Pfaffian, cross-golden,
pole-descent, polar, assembled-adjugate, and degeneracy calculations.

1. **One Pfaffian/exterior law.**  For every even labelled set, the
   bracket matrix
   \[
     \alpha_C(v)_{ij}=C_{ij}[v_i,v_j]
   \]
   is the universal alternating carrier of a matching functional.  Its
   Pfaffian, its affine commutator form, the diagonal of the middle exterior
   power, and, when \(C^2=qI\), its cross-eigenspace determinant are one
   natural transformation evaluated in four presentations.  Its full pure
   spinor has compound grades
   \(1,B,\bigwedge^2B,\ldots,\det B\) in a spectral basis, so the
   synchronized-spinor coordinates and block adjugates are lower grades of
   the same law.  The bracket
   presentation is intrinsic on the six-point quotient; the eigenspace block
   requires a pole.  Thus the successful identities and the pole-descent
   obstruction are two sides of the same theorem.
2. **Quotient--conormal cofactor law.**  The right kernel of the Golden
   differential is the residual infinitesimal \(\operatorname{PGL}_2\)-orbit
   after translation and scaling, while its left kernel is the conormal of
   the Segre hypersurface.  A general primitive-kernel cofactor lemma then
   forces the assembled adjugate to be their outer product.  The ordinary
3. **Even-point quotient theorem.**  For the equal-weight quotient of
   \(2m\) points, one multiplicity threshold gives the stable locus, the
   critical \(m\)-equals locus, and the \((m+1)\)-equals matching base.  At a
   closed \(m+m\) orbit the slice is the rank-one tensor map.  Its critical
   ideal follows from spanning trees of \(K_{m-1,m-1}\).  For six points this
   gives the square-zero length-four node defect and identifies it with the
   target node cotangent space.

The first mechanism replaces three independent coefficient or covariance
arguments by one matching evaluation and one spectral specialization.  The
second replaces separate source-kernel, target-polar, and cofactor arguments
by a quotient/conormal calculation and one normalization witness.  The third
replaces the stability, rank-drop support, node thickening, and base-locus
arguments, and removes the two former Singular trust boundaries.

Two provisional saturation rounds, run before the later local-quotient work,
override, found no further unity/compression candidate.  They do not close
C743.  The moduli round showed that a single descended complex
would contradict C742's pole and first-Fitting obstructions; compactified
derived pushforward adds a new branch rather than compressing the paper.  The
balanced-return round showed that the unsigned double-\(S_5\) incidence is
the complete product \(X\times\mathcal T\), so its pull--push correspondence
is rank one and vanishes on augmentation modules.  Any nontrivial signed
replacement must reinsert the switching data and is circular.

The manuscript, verification README, and C735 ledgers were not edited.

## Entry freeze

At entry the frozen surfaces had the following SHA-256 hashes.

| surface | SHA-256 |
|---|---|
| `papers/golden-operator/golden_operator.tex` | `75e726d859e76d72fd5b9e3f7d65937843f85ff71b249ef5d75505ecdf5c8caa` |
| `papers/golden-operator/verification/README.md` | `8d2da431627d10bf79e54cc15542428ff327cfa491131d1cdbd59daa82a5f6a6` |
| tracked `papers/golden-operator/` content tree | `8030f1a352b8c477a9f74120e5a1647ce366f660427a28b6acb0b7e8d6e071e2` |

The same hashes are required at closeout.

## 1. Before graph and accounting convention

The count below concerns the principal marked propagation proof and the
adjacent marked-rigidity/pole-descent result.  It does not count applications,
imported classical geometry, or the C742 boundary theorem.

### Primitive source data

The source has four irreducible marking layers and C743 does not remove any
of them:

1. the labelled natural and outer six-sets with their exceptional pairing;
2. the coherent conference switching local system;
3. the common support/Pfaffian orientation for signed odd shadows;
4. the pole and golden embedding when a selected cross block is named.

C742 proves that these layers cannot be collapsed without either losing the
desired object or encoding the source in the target action.  C743 therefore
counts a reduction only when it removes a constructed arrow or proof
obligation, not when it renames source-equivalent data.

### Before dependency DAG

```text
fully marked conference family C_T
 |-- middle exterior K_T -----------------> Z_T
 |-- commutator [D_x,C_T] -- Pf ----------> Z_T
 |                         \-- det --------> Z_T^2 --> W_T
 |-- golden projectors -----> B_T -- det --> Z_T
 |                                  \adj --> MCM/resolution pair
 Z=(Z_T) -- d ----------------------------> dZ
 |                                          |-- right kernel q
 \-- Segre relation --> polar W ------------|-- left kernel W
                                            \-- adj(dZ)=6 W q^t
```

On the explicit accounting used here this graph has seven constructed
primitives: \(K_T,Z_T,[D_x,C_T],B_T,W,dZ,q\).  It carries eleven independent
proof obligations: exterior coefficients, outer covariance, Pfaffian
coefficients, determinant square, spectral-block scalar, block adjugate/MCM,
right differential kernel, left differential kernel, generic rank, global
cofactor scalar, and pole descent.

## 2. Round 1 — minimal generator, natural transformation, and representation

### Starting candidates

Three mathematical languages gave three candidate generators.

| language | candidate | predicted deletion |
|---|---|---|
| operator | the conference relation \(C^2=5I\) | exterior/Pfaffian and cross-block proofs |
| invariant theory | the universal matching covariant \(\mathcal J_m\) plus a coherent orbit of functionals | exterior coefficients, Pfaffian expansion, covariance, and marked lift rigidity |
| quadratic algebra | the norm of the off-diagonal eigenspace block | determinant/Pfaffian and golden-conjugation calculations |

The conference relation alone is not minimal: the exterior/Pfaffian identity
holds for every symmetric zero-diagonal matrix.  The quadratic norm alone is
not global on \(M_{0,6}\) and does not explain the matching carrier.  The
second candidate contains both as specializations without hiding the pole
boundary.

### Theorem 2.1 (one Pfaffian/exterior law)

Let \(k\) have characteristic zero, let \(X\) be an oriented set of size
\(2m\), and let \(V\) be a two-dimensional vector space with determinant
line \(\delta\).  For labelled lines \(L_i\subset V\), put
\(E=\bigoplus_iL_i\).  If \(C=(C_{ij})\) is symmetric with zero diagonal,
define

\[
 \alpha_C:E\longrightarrow E^*\otimes\delta,
 \qquad (\alpha_C)_{ij}=C_{ij}[v_i,v_j].
\]

Then:

1. \(\operatorname{Pf}\alpha_C\) is the evaluation of the universal
   degree-\(m\) matching covariant
   \(\mathcal J_m:A_{2m}\to S^{(m,m)*}\) at the matching functional
   \[
      c_C(M)=\operatorname{sgn}(M)\prod_{ij\in M}C_{ij}.
   \]
2. On the affine chart \(v_i=(x_i,1)\),
   \[
      \alpha_C=[D_x,C],
      \qquad
      \operatorname{Pf}[D_x,C]
      =\sum_{|S|=m}(*\!\bigwedge^m C)_{SS}x_S,
   \]
   with the compatible Hodge orientation.
3. If \(C^2=qI\), \(q=s^2\), and the \(\pm s\)-eigenspaces both have
   dimension \(m\), then, for
   \(B=P_-D_xP_+:V_+\to V_-\),
   \[
      \operatorname{Pf}\alpha_C
      =\epsilon_C(2s)^m\det B,
   \]
   where \(\epsilon_C\) is exactly the determinant-line orientation.
4. The pure spinor \(\exp(\alpha_C)\) has principal Pfaffians as its graded
   coordinates.  In the eigenspace basis of part 3, its bidegree-\((r,r)\)
   coordinates are, up to the same orientation convention,
   \((2s)^r\bigwedge^rB\).  In rank three these grades are
   \(1,B,\operatorname{adj}B,\det B\).
5. The bracket/Pfaffian side is \(\operatorname{GL}_2\)-natural and descends
   to the point-configuration quotient with its determinant-line twist.  The
   displayed eigenspace block is natural only after a pole reduces coordinate
   changes to the affine subgroup.  For a general projectivity the diagonal
   congruence preserves the Pfaffian line but does not preserve a fixed
   eigenspace unless the change is affine.
6. The matching carrier first occurs in degree \(m\) with multiplicity one.
   Hence \(\mathcal J_m\) is the minimal universal covariant; a structured
   matrix \(C\) selects a functional or orbit of functionals on it rather than
   creating another carrier.

#### Human proof

Expanding \(\operatorname{Pf}\alpha_C\) over perfect matchings gives the
pairing with \(c_C\).  On the affine chart, \([v_i,v_j]=x_i-x_j\), so the
matrix is \([D_x,C]\).  In the coefficient of \(x_S\), every surviving
matching pairs \(S\) bijectively with \(S^c\); its signed sum is
\(\det C_{S,S^c}\), which is the stated middle-exterior diagonal.

When \(C^2=s^2I\), the eigenspace splitting gives

\[
 [D_x,C]=
 \begin{pmatrix}
  0&-2sB^{\mathsf T}\\
  2sB&0
 \end{pmatrix}.
\]

The Pfaffian of this alternating block matrix is
\(\epsilon_C(2s)^m\det B\).  The sign is precisely the chosen orientation
of the two determinant lines.  Expanding \(\exp(\alpha_C)\) in the spectral
basis gives the compound matrices \(\bigwedge^rB\); for \(m=3\), Hodge
duality identifies \(\bigwedge^2B\) with \(\operatorname{adj}B\).  Brackets
scale by \(\det g\) under
\(g\in\operatorname{GL}_2\), proving the intrinsic determinant-line
covariance.  Under
\(x_i\mapsto (ax_i+b)/(cx_i+d)\), the commutator instead transforms by
diagonal congruence with entries \((cx_i+d)^{-1}\).  Because all off-diagonal
entries of a Golden \(C\) are nonzero, that diagonal matrix preserves the
fixed eigenspaces only when it is scalar, which for six distinct points is
the affine case.  The first-occurrence and multiplicity-one statement is the
Young-rule proof frozen in C739.

#### Independent route

The Ishikawa--Wakayama Pfaffian minor-summation formula supplies the general
Pfaffian/minor mechanism independently of the matching expansion.  The
spectral-block determinant follows independently from ordinary block
linear algebra.  Their intersection fixes the same scalar
\((2s)^m\), while the C704 exact checker and replay fix the Golden Hodge and
outer-action conventions.

### Golden specialization and proof-graph effect

For \(m=3\), \(s=\sqrt5\), and the frozen orientations,

\[
 \operatorname{Pf}[D_x,C_T]=4Z_T
   =\epsilon_T40\sqrt5\det B_T.
\]

The six functionals \(c_{C_T}\) form the regular simplex orbit in the
five-dimensional carrier \(S^{(3,3)*}\).  Thus the smallest valid generator
is

\[
 (\mathcal J_3,\{c_{C_T}\}_{T\in\mathcal T}),
\]

with the coherent switching transport retained.  Exterior, commutator, and
cross-golden formulas are evaluations, not primitive arrows.

**Concrete effect.**  The theorem applies beyond order six, explains five
current outputs, and deletes the
separate exterior/Pfaffian coefficient comparison, the separate block
determinant derivation, and a repeated pole-covariance discussion.  It does
not falsely remove the marked source.

### Round 1 cycle 1: `tt + aa + ej`

- **`tt`.**  The real question is whether the conference operator generates
  the invariant carrier or merely chooses a functional on it.  The universal
  matching theorem answers: the carrier is classical and source-independent;
  the Golden datum is the exceptional six-element simplex orbit of
  functionals.
- **`aa`.**  The direct matching expansion, the Pfaffian minor-summation
  formula, and the eigenspace norm calculation have genuinely different
  inputs.  Their agreement proves the typed theorem and fixes its scalar;
  none requires identifying unlike codomains.
- **`ej`.**  The same theorem explains the pole boundary for free.  Brackets
  are projective, while a fixed spectral splitting of \(D_x\) is affine.
  C739's successful global Pfaffian and C742's failed global cross block are
  therefore one naturality statement rather than separate facts.

### Round 1 cycle 2: `tt + aa + ej`

This cycle starts from the compressed matching--norm theorem.

- **`tt`.**  Can centered squaring and the assembled adjugate also be values
  of \(\mathcal J_3\)?  No.  They use the equation of the image hypersurface
  and the differential of the quotient map, not another evaluation of the
  matching carrier.  Absorbing them would hide a necessary change of type.
- **`aa`.**  Three next routes were tested: differentiate the matching
  covariant, take the quadratic covariant \(U\to O\), or use the conormal
  sequence of the quotient.  The first alone does not produce the target
  relation, and the second alone does not produce the source kernel.  The
  conormal route contains both and becomes Round 2.
- **`ej`.**  Order-six exceptionalism sharpens to a two-part resonance:
  \(\mathcal J_3\) is the unique nontrivial hypersurface matching quotient,
  and the Golden functionals are its unique six-vector outer-simplex frame.
  This is the exact explanatory sentence for the later principal theorem;
  it replaces, rather than supplements, the parallel formulas.

## 3. Round 2 — differential, singularity, and proof compression

### Candidate mechanisms

| language | mechanism | predicted deletion |
|---|---|---|
| moduli differential | residual \(\mathfrak{pgl}_2\)-orbit is the right kernel | special-conformal congruence calculation |
| hypersurface geometry | Segre conormal is the left kernel | separate polar-kernel calculation |
| commutative algebra | primitive kernel generators force a rank-one cofactor | entrywise assembled-adjugate proof |
| determinant calculus | \(d(\det B)=\operatorname{tr}(\operatorname{adj}B\,dB)\) | separate interpretation of the local adjugates |

These four mechanisms compose without identifying the local \(3\times3\)
blocks with the global \(5\times5\) differential.

### Lemma 3.1 (primitive-kernel cofactor)

Let \(R\) be a graded UFD and let \(M\in\operatorname{Mat}_r(R)\) have
generic rank \(r-1\).  Suppose its right and left kernels over the fraction
field are generated by homogeneous polynomial vectors \(q\) and \(w\), and
that the components of each vector have greatest common divisor one.  Then

\[
 \operatorname{adj}M=h\,q w^{\mathsf T}
\]

for a homogeneous \(h\in R\).  If
\(\deg\operatorname{adj}M=\deg q+\deg w\), then \(h\in k\).

#### Proof

Every column of \(\operatorname{adj}M\) lies in the right kernel over the
fraction field.  Primitivity of \(q\) and unique factorization make its
coefficient polynomial.  Factoring \(q\) from all columns leaves a row in
the left kernel.  Primitivity of \(w\) makes the remaining common factor
polynomial.  Homogeneity gives the last assertion.

The statement is orientation-free: transposing the matrix exchanges the two
vectors and changes only the convention for displaying the outer product.

### Theorem 3.2 (Golden quotient--conormal cofactor)

Let \(Z:A\to U\) be the marked Joubert map on the five-dimensional
translation quotient, and let \(F(z)=\sum_Tz_T^3\) on
\(\sum_Tz_T=0\).  Then:

1. the right kernel of \(dZ_x\) is the residual infinitesimal special-
   conformal orbit.  In the centered coordinate slice it is represented by
   \[
     q_i=6x_i^2-\sum_jx_j^2;
   \]
2. the left kernel is the Segre conormal
   \[
     \widehat W_T=6Z_T^2-\sum_UZ_U^2;
   \]
3. on the generic rank-four locus the primitive-kernel lemma forces
   \[
      \operatorname{adj}(dZ)=c\,\widehat Wq^{\mathsf T};
   \]
4. one integral cofactor witness gives \(c=6\), and polynomial continuation
   proves the identity on every stratum;
5. for each \(T\), Jacobi's determinant formula identifies
   \(\operatorname{adj}B_T\) as the conormal lift of the coordinate
   \(Z_T=\epsilon_T10\sqrt5\det B_T\).  The local block adjugates and the
   global assembled adjugate are therefore the two successive cofactor maps
   in the chain
   \[
      A\xrightarrow{B_T}\operatorname{Mat}_3
      \xrightarrow{\det}k,
      \qquad
      A\xrightarrow{Z}V(F)\hookrightarrow U.
   \]

#### Human proof

The bracket presentation of Theorem 2.1 is \(\operatorname{PGL}_2\)-natural.
After quotienting translation and projective scale, the remaining Lie
algebra direction is \(x_i\mapsto x_i+t x_i^2\).  Centering gives \(q\), so
\(dZ_x(q)=0\) on the augmentation quotients.  Differentiating
\(F(Z(x))=0\) gives \(\widehat W^{\mathsf T}dZ=0\).  The known nonzero
fourth minor gives generic rank four.  The two kernel vectors are primitive,
and their degrees are two and six, while a cofactor of the quadratic
\(5\times5\) matrix \(dZ\) has degree eight.  Lemma 3.1 therefore leaves one
constant.  The frozen exact cofactor fixes it as six.

For a linear matrix \(B_T(x)\), Jacobi's formula gives
\(d(\det B_T)_x(v)=\operatorname{tr}(\operatorname{adj}B_T(x)B_T(v))\).
Together with \(B_T\operatorname{adj}B_T=(\det B_T)I\), this supplies the
local conormal and kernel-incidence interpretation.  No step identifies the
local and global matrix sizes.

#### Independent route

The manuscript's direct congruence derivative proves the right-kernel
formula without quotient language; direct differentiation of the Segre
equation proves the left kernel; and the C705 replay checks all 25 normalized
cofactor entries over 59,049 points.  These inputs are independent of the
UFD factorization proof of Lemma 3.1.

### Special-stratum and trust audit

- The cofactor identity is polynomial and remains valid at the ten nodes,
  fifteen simultaneous-zero lines, and pair-collision boundary.
- At deeper rank drop the adjugate may vanish; the theorem does not claim
  that either displayed vector generates the full scheme-theoretic kernel
  there.
- It does not identify the nonreduced Jacobian rank-drop scheme.  The
  ten-point nilpotent defect retains its one-Singular trust boundary.
- The local block remains pole-marked.  The global differential and Segre
  conormal descend without selecting a golden summand.
- The integral scalar is inherited from the frozen C705 witness.  No new
  modular claim is made at \(2,3,5\).

**Concrete effect.**  Four previously separate features become the source
orbit, target conormal, and two cofactor stages of
one quotient diagram.  It eliminates two kernel calculations as independent
ideas and turns the 25-entry adjugate identity into one general lemma plus one
normalization witness.

### Round 2 cycle 1: `tt + aa + ej`

- **`tt`.**  The map should be read as a quotient map with one residual orbit
  direction, not as an accidental cubic parametrization with a discovered
  kernel.  The Igusa coordinate is the conormal of the image relation, so the
  cofactor has only one possible tensor shape.
- **`aa`.**  The Lie-algebra, direct congruence, UFD cofactor, and finite-field
  replay routes agree while sharing no single proof bottleneck.  The
  Lie-algebra route supplies meaning; the direct route fixes conventions;
  the UFD route supplies universality; the replay checks normalization.
- **`ej`.**  The cross-block adjugate is not a second mysterious adjugation.
  It is the derivative of a coordinate determinant one stage before the
  assembled quotient cofactor.  This supports one reader-visible
  cofactor/conormal paragraph and removes duplicated adjugate motivation.

### Round 2 cycle 2: `tt + aa + ej`

This cycle starts from the quotient--conormal theorem.

- **`tt`.**  Does the conormal sequence determine the nilpotent thickening at
  the ten nodes?  It determines the reduced critical support and explains
  why the defect can live at the contracted \(3|3\) boundary, but it does not
  determine the Fitting scheme.  Promoting that inference would overrun the
  one-CAS boundary.
- **`aa`.**  Local Luna-slice coordinates, a second-CAS primary decomposition,
  and deformation-theoretic cotangent complexes were compared.  Any could
  study the nilpotent defect, but none is needed for the cofactor theorem and
  none presently removes two load-bearing proof clusters.
- **`ej`.**  The theorem gives a clean trust split: the cofactor shape and
  scalar are central human mathematics with independent replay; the
  scheme-theoretic thickening remains appendix evidence.  A later
  unification pass can shorten the central proof without promoting the
  unclosed local algebra.

## 4. Round 3 — quotient nodes and matching base

The user sharpened the gate after the unity/compression mechanisms: C743 is
not allowed to close on a more elaborate description.  The mathematics must
be clearer, more general, and more explanatory.  This round therefore attacked
the two remaining CAS boundaries as geometry of familiar universal objects.

### Lemma 4.1 (rank-one tensor critical ideal)

Let \(U\) and \(V\) have dimensions \(r,s\ge2\), write
\(\mathfrak u=(u_1,\ldots,u_r)\) and
\(\mathfrak v=(v_1,\ldots,v_s)\), and consider

\[
 \mu:U\oplus V\longrightarrow U\otimes V,
 \qquad (u,v)\longmapsto u\otimes v.
\]

The generic rank of \(d\mu\) is \(r+s-1\), and its maximal critical-minor
ideal is

\[
 \boxed{\ I_{r+s-1}(d\mu)
 =\mathfrak u^s\mathfrak v^{r-1}
  +\mathfrak u^{s-1}\mathfrak v^r.\ }
\]

#### Spanning-tree proof

Index the rows of \(d\mu\) by the edges of \(K_{r,s}\) and its columns by
the vertices.  A maximal minor chooses \(r+s-1\) edges and deletes one
vertex column.  After factoring the edge weights, its determinant is a
reduced incidence minor.  It vanishes unless the chosen edges form a
spanning tree; for a tree it is one monomial with coefficient \(\pm1\).

If the deleted root lies in \(U\), that monomial has total \(u\)-degree
\(s\) and total \(v\)-degree \(r-1\).  If it lies in \(V\), the bidegrees
are \((s-1,r)\).  Conversely every monomial of either bidegree occurs:
its exponents, after adding one at every nonroot vertex, are positive
bipartite degree sequences summing to \(r+s-1\), and such a sequence is
realized by a bipartite tree.  This proves the ideal formula.

For the balanced slice \(r=s=m-1\),

\[
 I_{2m-3}(d\mu)
 = (\mathfrak u+\mathfrak v)
   \mathfrak u^{m-2}\mathfrak v^{m-2}.
\]

Along the generic point of \(U=0\), its transverse ideal is
\(\mathfrak u^{m-2}\), and the analogous statement holds along \(V=0\).
Hence order six (\(m=3\)) is the unique
nontrivial balanced case in which both critical components are generically
reduced.  The order-six nilpotence is concentrated at their intersection;
at every higher even order the universal balanced quotient is already
thickened along the generic components.

**Concrete effect.**  This is a general critical-scheme theorem with a short
combinatorial proof.  It gives a structural order-six
exceptionalism criterion independent of the outer automorphism and
hypersurface coincidence.

### Corollary 4.2 (rank-one quotient normal form at every Segre node)

Let \(p_Q\) be one of the ten \(3+3\) closed orbits, indexed by an unordered
partition \(Q\sqcup Q^c=X\).  On completed local rings, the Golden quotient
map at \(p_Q\) is the standard \(\mathbf G_m\)-quotient

\[
 \mu:U\oplus V\longrightarrow U\otimes V,
 \qquad (u,v)\longmapsto u\otimes v,
 \qquad \dim U=\dim V=2,
\]

where \(\mathbf G_m\) has weights \(+1\) on \(U\) and \(-1\) on \(V\).
Writing \(u=(u_1,u_2)\), \(v=(v_1,v_2)\), and
\(\mathfrak m=(u_1,u_2,v_1,v_2)\), the scheme-theoretic critical ideal is

\[
 \boxed{\ I_3(d\mu)=
 \mathfrak m\,(u_1,u_2)(v_1,v_2).\ }
\]

Its radical is the transverse plane crossing

\[
 (u_1,u_2)(v_1,v_2)
 =(u_1,u_2)\cap(v_1,v_2).
\]

The nilpotent defect is the square-zero module

\[
 \frac{(u_1,u_2)(v_1,v_2)}
      {\mathfrak m(u_1,u_2)(v_1,v_2)}
 \cong k^4.
\]

Consequently the global Golden rank-drop scheme is a square-zero extension
of the reduced twenty-plane \(3\)-equals arrangement by four residue-field
directions at each of the ten nodes.  Its total embedded defect length is
\(40\).

#### Human mechanism

Move the two triple clusters to \(0\) and \(\infty\).  After quotienting the
two orbit directions that move those cluster centers, the two independent
splittings of the first triple have stabilizer weight \(+1\), and the two
independent splittings of the second have weight \(-1\).  The invariant local
coordinates are therefore the four bilinears

\[
 z_{ij}=u_i v_j,
\]

with the single relation
\(z_{11}z_{22}-z_{12}z_{21}=0\), the ordinary double-point equation.  Thus
the quotient map itself is \(\mu\).

Its Jacobian is

\[
 d\mu=
 \begin{pmatrix}
 v_1&0&u_1&0\\
 v_2&0&0&u_1\\
 0&v_1&u_2&0\\
 0&v_2&0&u_2
 \end{pmatrix}.
\]

The nonzero \(3\times3\) minors are exactly the twelve monomials generating
\(\mathfrak m(u_1,u_2)(v_1,v_2)\).  Its radical is the product/intersection
of the two transverse plane ideals.  Modding the radical by the critical
ideal leaves its four quadratic generators, killed by \(\mathfrak m\); their
products also vanish.  This proves the square-zero length-four statement
without primary decomposition.

The ten partitions form one \(S_6\)-orbit, so one local calculation proves
all ten cases.  Away from them, C739's geometric radical argument already
shows that the critical scheme is reduced along its twenty top-dimensional
components.  The local theorem therefore gives the stated global exact
extension.

#### Frozen-coordinate and independent checks

At the representative
\([x_0:\cdots:x_5]=[1:1:1:0:0:0]\), put

\[
 x_0=1,\quad x_1=1+a,\quad x_2=1+b,\quad x_3=c,\quad x_4=d,\quad x_5=0.
\]

The exact local standard-basis audit verifies directly that C739's
\(4\times4\) Jacobian-minor ideal is

\[
 (a,b,c,d)(a,b)(c,d).
\]

An independent dependency-free replay computes the minors of \(d\mu\) and
recovers the same twelve monomial generators.  The computation corroborates
the coordinate bridge; the displayed quotient proof is the mechanism.

**Concrete effect.**  This goes beyond the C739 certificate: it identifies
the complete local ideal, proves the defect is square-zero of length four at each node, computes
total length forty, and removes the sole one-CAS boundary from the collision
filtration.

### Lemma 4.3 (universal matching base is the equals arrangement)

Let \(n=2m\), let \(R=k[x_1,\ldots,x_{2m}]\) over an arbitrary field, and
let \(I_{\mathrm{match}}\) be generated by the perfect-matching products

\[
 p_M(x)=\prod_{ij\in M}(x_i-x_j).
\]

Then

\[
 \boxed{\ I_{\mathrm{match}}
 =\bigcap_{|Q|=m+1}(x_i-x_j:i,j\in Q).\ }
\]

Thus the universal matching covariant has the reduced \((m+1)\)-equals
arrangement as its scheme-theoretic base locus in every characteristic.  Its
coordinate ring is Cohen--Macaulay in characteristic zero and in
characteristic \(p\ge m\).

#### Proof and explanation

The matching products are precisely the Specht polynomials of shape
\((m,m)\).  The two-row Specht-ideal theorem identifies their ideal with the
displayed equals-arrangement ideal and proves radicality over every field; it
proves Cohen--Macaulayness in characteristic zero or characteristic at least
\(m\).

The support statement has an elementary graph proof.  Group equal
coordinates into parts.  A matching product is nonzero exactly when its
matching uses only edges between different parts.  The resulting complete
multipartite graph on \(2m\) vertices has a perfect matching exactly when no
part has size greater than \(m\).  Therefore every matching product vanishes
exactly when at least \(m+1\) coordinates coincide.  The Specht theorem says
that this visible support already has the reduced scheme structure.

For \(m=3\), the six Golden functionals form a spanning simplex in the
five-dimensional matching carrier \(S^{(3,3)}\).  Hence their six top
Pfaffians generate the full matching ideal.  Their base scheme is therefore
the reduced four-equals arrangement: the fifteen projective lines indexed by
four-subsets of \(X\).  The C728 Singular calculation is no longer
load-bearing for reducedness or minimal primes.

**Concrete effect.**  This gives an all-even-order theorem, identifies the
Golden base scheme as a classical
Specht/equals arrangement, and removes the second CAS dependency by joining
the matching carrier directly to its geometric null locus.

### Theorem 4.4 (stability--criticality--base trichotomy)

For the equal-weight quotient of \(2m\) labelled points on \(\mathbf P^1\),
the universal matching covariant separates the source by the largest point
multiplicity \(h\):

| multiplicity | GIT and differential behavior |
|---:|---|
| \(h<m\) | stable; the quotient is smooth after dividing the three-dimensional \(\operatorname{PGL}_2\)-orbit |
| \(h=m\) | strictly semistable and critical; every \(m\)-collision component contracts to the closed \(m+m\) orbit, whose slice is \((u,v)\mapsto u\otimes v\) with \(\dim u=\dim v=m-1\) |
| \(h>m\) | unstable; scheme-theoretically this is the reduced \((m+1)\)-equals base arrangement of Theorem 4.3 |

At a closed \(m+m\) orbit the critical ideal is

\[
 (\mathfrak u+\mathfrak v)
 \mathfrak u^{m-2}\mathfrak v^{m-2}.
\]

Thus the same threshold \(m\) controls stability, contraction, criticality,
and the first base multiplicity.  Order six is the first nontrivial case:
the critical support is the twenty-plane \(3\)-equals arrangement, paired
into ten closed \(3+3\) orbits; the transverse critical components are
reduced; and the base is the reduced fifteen-line \(4\)-equals arrangement.

#### Proof

The Hilbert--Mumford criterion for equal weights says semistable exactly when
no point has multiplicity greater than \(m\), and stable exactly when every
multiplicity is smaller.  Theorem 4.3 upgrades the unstable support to the
reduced matching base scheme.  If exactly \(m\) points coincide, the orbit
closure has the complementary \(m\) points collide at a second point, so the
component contracts to the closed \(m+m\) orbit.  Splitting the two clusters
gives the balanced \(\mathbf G_m\)-slice of Corollary 4.2, and Theorem 4.1
supplies its exact critical scheme.  On the stable locus the geometric
quotient is smooth after removing orbit directions, so there are no other
critical components.

**Concrete effect.**  One threshold theorem replaces the separate stability,
rank-drop-support, node, and base-locus stories and
predicts the higher-order scheme thickness explicitly.

### Corollary 4.5 (the Jacobian defect is the node cotangent sheaf)

Let \(\mathcal R\) be the Golden Jacobian rank-drop scheme, let
\(\mathcal R_{\mathrm{red}}\) be its twenty-plane reduction, and identify
the ten closed \(3+3\) source points with the ten nodes of the Segre cubic
\(\Sigma\).  Then there is a canonical \(S_6\)-equivariant isomorphism of
skyscraper sheaves

\[
 \boxed{\quad
 \sqrt{I_{\mathcal R}}/I_{\mathcal R}
 \cong
 \bigoplus_{y\in\operatorname{Sing}\Sigma}
 \mathfrak m_y/\mathfrak m_y^2.
 \quad}
\]

Equivalently, the nilpotent defect is the pullback of the cotangent sheaf of
the Segre cubic restricted to its reduced singular scheme.  Each fibre has
dimension four, so the total length is forty.

#### Proof

In the local quotient normal form, the target node has completed local ring

\[
 k[[z_{11},z_{12},z_{21},z_{22}]]/
 (z_{11}z_{22}-z_{12}z_{21}),
\]

and the quotient map sends \(z_{ij}\) to \(u_i v_j\).  The node equation has
no linear term, so its cotangent space has basis the four classes of
\(z_{ij}\).  Corollary 4.2 identifies the source defect with

\[
 \frac{(u_1,u_2)(v_1,v_2)}
 {\mathfrak m(u_1,u_2)(v_1,v_2)},
\]

whose basis is the four classes of \(u_i v_j\).  Pullback gives the displayed
isomorphism.  It is canonical because it is induced by the quotient map on
cotangent spaces, and equivariance follows from equivariance of that map.

This is the exact surviving link among the previously unequal degeneracy
objects.  The source critical scheme, target node scheme, and polar base are
not equal; the nilpotent difference between the source scheme and its
reduction is the target cotangent sheaf.

**Concrete effect.**  It identifies the defect module, not only its support
or length, and gives the functorial bridge that
the false master-complex proposal was trying to obtain.

### The collision filtration after Theorems 4.1 and 4.2

The former \(15/20/15\) component ledger now has a short geometric reading:

| level | universal configuration meaning | Golden scheme statement |
|---|---|---|
| pair collision | \(2\)-equals discriminant | reduced fifteen-hyperplane boundary |
| quotient criticality | \(3\)-equals arrangement | reduced twenty-plane support with the universal rank-one quotient defect at the ten complementary intersections |
| matching null cone | \(4\)-equals Specht arrangement | reduced Cohen--Macaulay union of fifteen lines |

The schemes remain unequal; the gain is that every level is now a standard
configuration construction and the only nonreduced layer has a universal
four-variable local model.

### Round 3 cycle 1: `tt + aa + ej`

- **`tt`.**  The missing question was not “what did Singular decompose?” but
  “what quotient singularity is this?”  At a \(3+3\) orbit the answer is the
  smallest nontrivial balanced torus quotient, so the nilpotents are forced
  by the critical minors of the rank-one tensor map.
- **`aa`.**  Direct primary decomposition, completed-local elimination,
  stabilizer weights, and the rank-one tensor Jacobian were compared.  The
  stabilizer route supplies the normal form; the twelve-minor calculation is
  then one line; the frozen-coordinate audit only checks the marking bridge.
- **`ej`.**  The defect has an exact invariant not previously recorded: four
  square-zero directions per node, total length forty.  This closes rather
  than relabels the one-CAS trust gap.

### Round 3 cycle 2: `tt + aa + ej`

This cycle starts from the tensor-quotient normal form.

- **`tt`.**  The other CAS boundary should likewise be identified by its
  universal object.  The top Pfaffians are matching Specht polynomials, so
  their common zero scheme is the equals arrangement; elimination was proving
  a general theorem in one coordinate chart.
- **`aa`.**  Hilbert--Mumford gives only the support, a direct matching graph
  gives the same support more transparently, and the two-row Specht theorem
  supplies the missing radical scheme structure.  Together they replace both
  the set-theoretic and CAS halves of C728's argument.
- **`ej`.**  The matching--norm theorem now controls not only the propagated
  cubic but also its entire null scheme in every even order.  At order six,
  the three collision levels become the \(2\)-, \(3\)-, and \(4\)-equals
  filtration, with the node defect explained by the universal balanced
  quotient.  The weighted spanning-tree formula shows, in addition, that
  order six is the only nontrivial balanced order whose critical planes are
  generically reduced.

## 5. Simplicity red-team of the theorem candidates

This pass removes self-grading and tests whether each claimed mechanism has a
shorter form.  The questions are: what is the least datum in the statement,
which clauses share one proof, what can be demoted to a corollary, and whether
the proposed language deletes more than it adds.

### One Pfaffian/exterior law

- **Attempted simplification:** state only the top Pfaffian identity and leave
  the pure-spinor and cross-block statements separate.
- **Failure of the simplification:** in a spectral basis, the lower principal
  Pfaffians are literally the compound matrices of \(B\).  Omitting that one
  clause would force the synchronized-spinor proposition and block-adjugate
  calculation to repeat the same exterior expansion.
- **Attempted over-unification:** make \(C^2=qI\) a hypothesis of the whole
  theorem.
- **Failure of the over-unification:** the matching, affine commutator, and
  middle-exterior identities hold for arbitrary symmetric zero-diagonal
  \(C\).  The conference equation belongs only to the spectral specialization.
- **Simplest retained form:** one alternating bracket matrix \(\alpha_C\), one
  exterior exponential, and one optional spectral clause.  Pole descent is a
  naturality boundary, not a second construction.
- **Observable test:** the later manuscript proof should delete the separate
  exterior/Pfaffian coefficient comparison, block determinant derivation,
  block-adjugate minor explanation, and repeated pole covariance.  If those
  paragraphs remain, the formulation has not compressed the proof.

### Quotient--conormal cofactor law

- **Attempted simplification:** derive the assembled adjugate directly by
  differentiating Theorem 2.1.
- **Obstruction:** differentiation supplies the source map but not the Segre
  equation or its conormal.  The target hypersurface is independent input.
- **Attempted over-unification:** call \(\operatorname{adj}B_T\) and
  \(\operatorname{adj}(dZ)\) instances of one matrix theorem.
- **Correction:** they are consecutive but different operations.  Jacobi's
  formula interprets the block adjugate; the primitive-kernel lemma determines
  the cofactor of the quotient differential.  The principal statement should
  mention only the residual source orbit, the target conormal, and their outer
  product.  The block adjugate is a one-sentence corollary of Theorem 2.1.
- **Simplest retained form:** “the cofactor of the quotient differential is
  source-fibre direction times target conormal,” followed by the one scalar
  witness.  No category language is needed.

### Even-point quotient theorem

- **Attempted simplification:** present the tensor critical ideal, Golden node
  normal form, equals arrangement, stability trichotomy, and cotangent defect
  as five coequal theorems.
- **Reason to reject it:** this repeats the same multiplicity threshold and
  makes corollaries look independent.
- **Simplest retained form:** Theorem 4.4 is the principal statement.  Lemma
  4.3 identifies the unstable base scheme; Lemma 4.1 computes the strictly
  semistable slice; Corollaries 4.2 and 4.5 give the six-point local ideal and
  cotangent defect.  They should remain proof steps and consequences, not
  additional headline claims.
- **Generality test:** the \((r,s)\) tensor formula costs one displayed line
  beyond the balanced case, and its spanning-tree proof is not longer than a
  balanced-only proof.  It is
  retained because it reveals why the balanced order-six slice is the unique
  nontrivial generically reduced case.
- **Jargon test:** “Specht ideal” is needed only for scheme-theoretic
  radicality.  The support is explained first by the complete multipartite
  matching criterion.  “Luna slice” is unnecessary in the proof; the two
  cluster-splitting weights give the local quotient directly.

### Result of this red-team

The current principal list has three entries: Theorem 2.1, Theorem 3.2, and
Theorem 4.4.  Lemmas 3.1, 4.1, and 4.3 carry the general algebra; Corollaries
4.2 and 4.5 carry the exact six-point consequences.  No grade is assigned in
this report.  Review should judge the results from their hypotheses, proof
length, deleted obligations, trust changes, and counterexamples.

## 6. Round 4 — moduli, descent, groupoid, and differential saturation

This was the first saturation round.  Its portfolio differs from Round 4.

### Candidates and central tests

| candidate | central test | verdict |
|---|---|---|
| one stack carrying all four torsors | do the support, switching, pole, and golden fibres have one common descent action? | no: they act in different categories and have discrete, gauge, one-dimensional, and quadratic fibres |
| one cross-block derived complex on \(M_{0,6}\) | does the selected block descend and have collision as first Fitting support? | no by C742: descent fails and the first support is \(Z_T=0\) |
| derived pushforward from \(\overline M_{0,7}\) | would it replace current proofs on \(M_{0,6}\)? | no present compression: a boundary-twisted compactification must first be chosen and the result cannot replace the intrinsic Pfaffian bundle |
| one master degeneracy scheme | do collision, Jacobian, and simultaneous Pfaffian loci have compatible dimensions and components? | no: their reduced components are \(15/20/15\) of different dimensions |
| human local normal form at the ten nodes | would it subsume two central results? | no: it would close one appendix trust gap, an important B-level improvement under the C743 rubric |

The compactified pushforward remains mathematically legitimate, but it is a
new geometric branch with new boundary choices and proof obligations.  It
does not satisfy C743's anti-bloat condition and is not a surviving
proof-compression candidate.

### Round 4 cycle 1: `tt + aa + ej`

- **`tt`.**  A hostile algebraic geometer would ask for the base stack and
  determinant-line twists before accepting a global MCM slogan.  Once stated,
  the Pfaffian and cross-block objects live on different bases; that
  difference is theorem content, not missing notation.
- **`aa`.**  Product groupoids, gerbes, logarithmic boundary complexes, and
  compactified derived pushforward were compared.  The first merely lists
  independent torsors; the second cannot absorb the continuous pole; the
  third organizes unequal schemes but does not identify them; the fourth
  starts a new paper-sized calculation.
- **`ej`.**  Theorem 2.1 already gives the maximal cheap moduli unification:
  one bracket object on \(M_{0,6}\), with a spectral refinement on the
  universal pole-marked curve.  State this as a boundary inside the principal
  theorem and do not create a speculative global complex.

### Round 4 cycle 2: `tt + aa + ej`

This cycle starts from the exact two-base obstruction.

- **`tt`.**  Could restriction of scalars over \(\mathbb Q(\sqrt5)\) repair
  pole descent?  It pairs the two golden summands but does not make a
  non-affine diagonal congruence preserve their rank-three splitting.  The
  pole and golden torsors remain independent.
- **`aa`.**  Norm, trace, direct image, and forgetting the selected summand
  were tested.  Norm is unavailable on a one-dimensional fibre; trace needs
  a coherent proper pushforward; direct image needs the missing boundary
  extension; forgetting the summand returns only the intrinsic rational
  Pfaffian already covered by Theorem 2.1.
- **`ej`.**  The correct later diagram has a shared intrinsic Pfaffian node
  and a pole-marked spectral refinement, with the collision/Jacobian/Koszul
  complexes adjacent rather than nested.  No further current theorem or
  proof obligation is deleted.

**Provisional Round 4 verdict:** no additional theorem candidate survived under the
pre-Theorem-4.1 graph; this round must be rerun before final saturation.

## 7. Round 5 — balanced return, exposition, and hostile-referee saturation

This was the second consecutive saturation round and used a different
portfolio.

### Hecke/unit--counit test

C739 proves an equivariant bijection

\[
 S_6/F_{20}\cong X\times\mathcal T.
\]

For the unsigned correspondence, pullback along one projection followed by
pushforward along the other sends a function on \(X\) to its total sum,
independent of \(T\).  It is rank one on permutation modules and zero on the
augmentation module.  Therefore the canonical \(36\to6\) set quotient is
not the counit of the nontrivial linear Golden propagation diagram.

A signed correspondence can be nonzero only after choosing the coherent
switching/support local system.  That is exactly the source datum whose
reconstruction C742 forbids from a source-free product target.  Such a
signed unit/counit would re-encode the input and is circular.

The direct Gram iteration also cannot supply the missing linear map: the
36-cut frame has redundancy four and its weighted operator satisfies
\((K-5I)^2=100I\), not a conference square.  The return is an exceptional
subgroup-incidence quotient, not another norm evaluation.

### Exposition and hostile-referee tests

| referee | strongest challenge | disposition |
|---|---|---|
| invariant theorist | multiplicity one may be hiding the scalar and lattice | Theorem 2.1 separates the universal carrier, primitive functional, determinant-line sign, and bad primes |
| algebraic geometer | the cross block is being presented as intrinsic on \(M_{0,6}\) | the theorem states the exact pole-marked refinement and non-affine obstruction |
| operator theorist | \(C^2=5I\) is being credited for the universal Pfaffian identity | the theorem explicitly separates the arbitrary-\(C\) matching law from the spectral norm specialization |
| representation theorist | the \(36\to6\) return is being conflated with a linear intertwiner | the unsigned pull--push vanishes on augmentation; a signed replacement is source-dependent |
| hostile general referee | the new language lengthens rather than shortens the proof | the placement specification deletes three calculations and one standalone rigidity result; no categorical terminology is needed beyond brackets, eigenspaces, and conormals |

### Round 5 cycle 1: `tt + aa + ej`

- **`tt`.**  The complete product \(X\times\mathcal T\) is too uniform to
  carry a nontrivial augmentation correspondence.  The genuinely interesting
  data are the signs, but those are precisely the marked conference local
  system.  This is the representation-theoretic reason the set return cannot
  become the master linear arrow.
- **`aa`.**  Unsigned Hecke pull--push, signed local systems, Naimark
  complement, and weighted Sylvester operators were tested.  They yield,
  respectively, zero on augmentation, circular source data, the successful
  \(6\to10\) consequence already in the paper, and a reflection rather than
  a conference iteration.
- **`ej`.**  The negative calculation is a useful one-sentence boundary:
  the return closes the projective set-level cycle but not the tensor diagram.
  It prevents a later unification edit from overstating the word “canonical.”

### Round 5 cycle 2: `tt + aa + ej`

This cycle starts from the set/linear separation.

- **`tt`.**  Could aggressive exposition cuts create a theorem-level result without
  more mathematics?  Only the two proved mechanisms support deletions.
  Removing the recovery, spinor, or anomaly statements would change the
  paper's validated scope rather than its proof graph; C735 already keeps
  them subordinate.
- **`aa`.**  One principal theorem, a theorem plus two structural
  corollaries, and a categorical master diagram were compared.  The second
  is shortest while preserving trust boundaries: matching--norm as the
  principal mechanism, quotient--conormal as its differential corollary, and
  C742 as the boundary theorem.
- **`ej`.**  The saved pages should reduce the final target rather than admit
  a new shadow.  The recommended cap becomes 57--58 total pages, with the
  same four-page exceptional/boundary ceiling and C717/C729 sequel boundary.

**Provisional Round 5 verdict:** no additional theorem candidate survived under the
pre-Theorem-4.1 graph; this round must be rerun before final saturation.

## 8. Candidate ledger

| candidate | observable change to the proof graph | current status or exact obstruction |
|---|---|---|
| universal matching--norm transformation | replaces the exterior/Pfaffian coefficient comparison, block determinant derivation, and repeated pole covariance | proved; undergoing merger with the exterior-exponential form |
| quotient--conormal cofactor theorem | replaces two kernel arguments and 25 cofactor identities by one kernel lemma and one scalar witness | proved; kept separate because it uses the quotient differential rather than the matching carrier |
| rank-one tensor critical ideal | gives the critical ideal in every pair of dimensions by a spanning-tree proof | proved |
| Golden ten-node normal form | identifies the exact local ideal and square-zero length-four defect at all ten nodes | proved as a corollary of the tensor theorem |
| matching base equals the \((m+1)\)-equals arrangement | replaces base-locus elimination by the two-row Specht ideal theorem | proved/imported at its classical boundary |
| stability--criticality--base trichotomy | combines stability, contraction, criticality, and the base scheme at one multiplicity threshold | proved from the preceding results; simplicity review will decide whether it is the principal statement or only a summary theorem |
| node cotangent identification | identifies the defect module with the cotangent spaces of the target nodes | proved as a functorial corollary, not counted as a separate principal mechanism |
| conference relation as sole generator | would remove the matching carrier | rejected: matching/Pfaffian law holds without \(C^2=5I\) |
| one quadratic-algebra norm for every shadow | would merge matching, polar, and spectral outputs | rejected: it does not produce the matching carrier, polar relation, or quotient differential |
| one stack/groupoid for four torsors | would replace four marking layers by one descent object | rejected: incompatible discrete, gauge, one-dimensional, and quadratic fibres remain independent |
| cross-block master Fitting complex | would merge collision, Jacobian, and Pfaffian schemes | refuted: no descent to \(M_{0,6}\), and first support is \(Z_T=0\) |
| compactified derived pushforward | could organize pole-marked MCM data | deferred branch: it needs a new boundary-twisted object and replaces no current proof |
| unsigned Hecke unit/counit for \(36\to6\) | would linearize the return cycle | refuted: complete-product pull--push is rank one and zero on augmentation |
| signed Hecke unit/counit | would repair that linearization | circular: nonzero signs reinsert the coherent switching/support source |
| direct Gram continuation | would make the return another conference step | refuted: redundancy four and the reflection identity replace the conference square |
| merge physical or exceptional branches into the principal theorem | would reduce the number of section-level branches | rejected: it changes scope and hierarchy without deleting a proof obligation |

## 9. After graph and quantitative delta

### After dependency DAG

```text
fully marked conference local system
             |
             v
universal matching covariant J_3 + simplex orbit {c_T}
 |-- bracket evaluation -------------------> Pfaffian/Joubert Z
 |-- affine chart --------------------------> commutator [D_x,C_T]
 |-- coefficient functor -------------------> middle exterior diagonal
 \-- spectral norm (pole-marked) -----------> det B_T and local adj B_T
                                               |
                         Segre relation -------+-- dZ
                         PGL2 quotient --------+   |
                                                   v
                                    quotient--conormal cofactor
                                    adj(dZ)=6 W q^t

separate boundary nodes:
  C742 source-free obstruction; strict collision filtration;
  set-level 6 -> 10 -> 36 -> 6 return
```

### Counts

| measure | before | after | delta |
|---|---:|---:|---:|
| irreducible source marking layers | 4 | 4 | 0; sharp by C742 |
| constructed primitives in the central propagation proof | 7 | 3: \(\mathcal J_3\), functional orbit, quotient differential | -4 |
| independent proof obligations in the scoped spine | 11 | 7 | -4 |
| numbered results in C735 theorem ledger | 11 | 10 projected | -1; marked rigidity becomes part of the principal theorem |
| planned main-argument pages | 46 | 43--44 | -2 to -3 |
| planned total pages | 60 | 57--58 | -2 to -3 |

The seven after-obligations are: construction/first occurrence of
\(\mathcal J_3\), the Golden simplex functional orbit and normalization,
bracket naturality, spectral norm and pole boundary, classical Segre relation,
generic differential rank plus one cofactor witness, and the C742 boundary
theorem.  Existing application proofs are unchanged.

## 10. Literature and attribution audit

This focused attribution audit names four sources, two read at full text.
The report makes no novelty or priority claim, and its validity does not
depend on absence of prior work.  The combined Golden specialization is
paper-owned synthesis; its ingredients are attributed generously.

1. Howard--Millson--Snowden--Vakil, *The relations among invariants of
   points on the projective line*, arXiv:0906.2437v1 — **full text**, all six
   pages, reused from the C739 audit.  Cache key `arXiv:0906.2437`, SHA-256
   `dfbdb89c3061b5987f59602a55d5eb40c7c29eab18f9203c0e43c6f765d37508`.
   It supplies the classical matching-invariant carrier and relations.
2. Howard--Millson--Snowden--Vakil, *A description of the outer
   automorphism of S6, and the invariants of six points in projective
   space*, arXiv:0710.5916v1 — **full text**, all eight pages, reused from
   the C739 audit.  Cache key `arXiv:0710.5916`, SHA-256
   `d2da258cd8513a9b782a8270baa82acc51bc8d552e18db104967c2a08bffebfc`.
   It supplies the exceptional paired action and six-point Joubert quotient.
3. Ishikawa--Wakayama, *Applications of Minor-Summation Formula III,
   Pluecker Relations, Lattice Paths and Pfaffian Identities*,
   arXiv:math/0312358 — **partial**, Introduction and Section 3 through
   Theorem 3.2 and Corollary 3.3.  Cache key `arXiv:math/0312358`, SHA-256
   `de40310f2e78069f91866615a5464794440ae2ca58a0cf6874ef3b80c3d7a04a`.
   It supplies a general Pfaffian minor-summation mechanism, not the Golden
   commutator, spectral, outer-six, or pole-descent synthesis.
4. McDaniel--Watanabe, *Principal Radical Systems, Lefschetz Properties,
   and Perfection of Specht Ideals of Two-Rowed Partitions*,
   arXiv:2103.00759v2 — **partial**, Introduction through Theorems 1.2,
   1.6, and 1.7, including the equals-arrangement identity (1).  Cache key
   `arXiv:2103.00759`, SHA-256
   `4545853783cb75ce5e006b9d091e5df09d8592139039bbdd7d0d184f37ff35a0`.
   It supplies the all-characteristic radical Specht/equals identity and the
   stated Cohen--Macaulay characteristic range, not the Golden spanning-frame
   specialization or the rank-one critical normal form.

The first-occurrence Young-rule argument, Jacobi determinant formula,
primitive-kernel cofactor lemma, and infinitesimal quotient calculation are
proved directly here or in C739.  No “new,” “first,” or “unique in the
literature” wording is authorized.  MathSciNet, Google Scholar, and
forward-citation closure were not needed and were not covered.

## 11. Validation and trust

No new computation is load-bearing.  The upgrades are human theorems whose
exact Golden scalars, ranks, and coordinate bridges are checked by frozen or
C743-owned evidence bundles.

The new node-normal-form bundle passes from the repository root:

```text
python3 notes/2026-07-31-c743-node-normal-form-audit.py --check
python3 notes/2026-07-31-c743-node-normal-form-replay.py
```

| artifact | bytes | SHA-256 |
|---|---:|---|
| `2026-07-31-c743-node-normal-form-audit.sing` | 2335 | `15175ccaab6c0fb0340987ff6e3099b91be9b7787d172137f27dfdad91ee3eb7` |
| `2026-07-31-c743-node-normal-form-audit.py` | 2993 | `2f02553385a1f9ebcb79e5ff7674b120d8d49bd0b7ae8ea59b121a336a08f516` |
| `2026-07-31-c743-node-normal-form-audit.json` | 539 | `219faef38dacbacaf47c9b34591a84e871a765275a49e99c3b6ded615c198e25` |
| `2026-07-31-c743-node-normal-form-replay.py` | 3290 | `bee542baff85001b783cb5373e288196a8830d8f6e037bbe58062046d5c7d397` |

The Singular audit checks the equality between the frozen Golden local
Jacobian ideal and
\((a,b,c,d)(a,b)(c,d)\).  The dependency-free replay instead constructs
the universal tensor Jacobian and verifies the spanning-tree formula in
dimensions \((2,2),(2,3),(3,2),(3,3)\).  The human stabilizer-slice and
weighted-tree proofs are independent of both executions.

From the repository root, the following batch passed with exit code zero:

```text
python3 notes/2026-07-30-c704-segre-igusa-operator-shadow.py --check
python3 notes/2026-07-30-c704-segre-igusa-operator-shadow-replay.py
python3 notes/2026-07-30-c705-adjugate-segre-igusa-polar.py --check
python3 notes/2026-07-30-c705-adjugate-segre-igusa-base-locus.py --check
python3 notes/2026-07-30-c705-adjugate-segre-igusa-polar-replay.py
```

The C704 replay checked all six shadows on a \(7^5\) grid over
\(\mathbf F_{101}\).  The C705 replay checked all 25 entries of
\(\operatorname{adj}(dZ)=6\widehat Wq^{\mathsf T}\) on 59,049 points.  The
tracked certificate hashes remained
`644c1f7a51f9d46897a466347c6e11c5bbc2835d8550932dbaeeb41405dcc2f3`,
`bb40b5877b487c904f330dc7f91827900433d20b9c610f286b37e210b6bf2d36`,
and `690f884c8d4081ac1dd235fa54311004fe32c0a268027f85509bdd08316eef3c`.

The following independent representation, return, and unmarked-boundary
batch also passed with exit code zero:

```text
python3 notes/2026-07-31-c739-representation-audit.py --check
python3 notes/2026-07-31-c739-representation-audit-replay.py
python3 notes/2026-07-31-c739-cycle-audit.py --check
python3 notes/2026-07-31-c742-unmarked-target-audit.py --check
python3 notes/2026-07-31-c742-unmarked-target-audit-replay.py
```

The synchronized-spinor/base bundle also passed:

```text
python3 notes/2026-07-31-c728-synchronized-pure-spinor-geometry.py --check
python3 notes/2026-07-31-c728-synchronized-pure-spinor-replay.py
```

These checks certify existing exact normalizations, multiplicities, and
finite incidence data.  They do not replace the human theorems.  Theorems
4.1--4.4 close the former one-Singular nilpotent and base-reducedness
boundaries; Singular now corroborates the marked coordinate bridge rather
than supplying the mathematical mechanism.

## 12. Post-search unification specification

This section specifies a later, separately authorized manuscript task.  It
does not apply the edits.

### Theorem replacements

1. Replace `thm:propagation` by **Golden matching--norm propagation**, whose
   first clause states Theorem 2.1 at \(m=3\), then states the six-functional
   simplex/Joubert specialization, the spectral norm, and the exact pole
   boundary.
2. Turn `cor:marked-lift-rigidity` into the minimality clause of that theorem:
   multiplicity one identifies the unique normalized marked evaluation, while
   C742 states why “marked” cannot be deleted.
3. Replace the assembled-adjugate portion of the propagation proof by the
   **quotient--conormal cofactor corollary**, with Lemma 3.1 proved once.
4. Keep `prop:synchronized-spinors`, `thm:frustration`, `cor:naimark`, and
   `thm:unmarked-boundary` as separate results.  Their codomains and trust
   boundaries are genuinely independent.

### Exact manuscript locations

- In `The marked propagation theorem`, insert the universal bracket object
  immediately after the definition of a fully marked presentation.
- Replace the current middle-exterior and Pfaffian coefficient paragraphs by
  the matching-functional evaluation proof.
- Move the cross-golden block calculation into the spectral-norm clause of
  the same proof; state the pole/no-pole naturality split there, before the
  determinantal consequences.
- After the Segre relation, insert Lemma 3.1 and the quotient--conormal proof;
  retain one sentence naming the C705 scalar witness.
- In `The synchronized Cartan cells`, delete the standalone marked-rigidity
  result and cite the minimality clause of the principal theorem.
- In `Recovery and minimal marking`, retain C742's boundary theorem but
  shorten repeated product-target and pole explanations to backward
  references.
- At the end of the balanced-return subsection, add one boundary sentence:
  the \(36\to6\) quotient is set-level; unsigned pull--push vanishes on
  augmentation, and a signed version would restore the source local system.

### Deletions and proof-obligation changes

Delete or absorb:

- the separate middle-exterior coefficient calculation;
- the repeated matching expansion used only to identify the same Pfaffian;
- the separate determinant-square-to-cross-block scalar derivation;
- the repeated general-projectivity/pole explanation outside the principal
  mechanism;
- the standalone marked-rigidity corollary and its repeated scalar audit;
- the presentation of the right and left differential kernels as unrelated
  discoveries.

Retain:

- one matching expansion or the minor-summation citation as the human proof;
- one exact Golden normalization witness;
- one generic rank-four witness;
- the one-CAS boundary for the nilpotent defect;
- every C742 counterexample and all four torsors;
- separate application and recovery proofs.

### Page and trust delta

The projected saving is two to three main-text pages and four independent
proof obligations.  Set the new target at 43--44 main-argument pages and
57--58 total pages.  Do not spend the saving on C717, higher C729 censuses,
the order-eight branch, derived pushforward, or a new physical shadow.

Trust improves modestly: the central scalar checks remain exact and
independently replayed, while more of the equality graph is now proved by
one human naturality argument.  No CAS claim is promoted, and no existing
verification command or certificate needs to change unless theorem labels
in the README are synchronized.

### Recommendation for the implementation task

Allocate one bounded Golden manuscript task to apply only this specification,
refresh C735's theorem/proof/page ledgers and the verification README, run all
central replays, build warning-free, and compare the rendered before/after
page count.  Do not reopen C743 research or add a shadow branch during that
task.

## 13. Current task-level `ej` + `tt` and Mystery ledger

### `ej`

- The universal matching theorem supplies a clean explanation of both success
  and failure: projective brackets descend; a selected spectral factor needs
  a pole.  The same statement supplies both the identity and its descent
  boundary.
- The quotient--conormal theorem identifies the special-conformal vector as
  geometry of the source quotient and the Igusa vector as geometry of the
  target hypersurface.  The assembled adjugate becomes the cofactor joining
  those two normal lines.
- The complete-product calculation gives a cheap but sharp warning for the
  return section: canonical set recovery is not a linear unit/counit.
- The page saving should lower the paper cap.  No deferred branch earns the
  released space.

### `tt`

- The paper's memorable theorem should say that the Golden operator selects
  an exceptional simplex of functionals on a universal matching covariant,
  then that the quotient map's cofactor joins the residual source orbit to
  the Segre conormal.  This is a stricter and more accurate unity claim than
  “all shadows are the same invariant.”
- The four torsors and the unequal degeneracy schemes are not blemishes to be
  categorized away.  They mark the exact limits of the two universal
  mechanisms.
- A referee can now test every claimed compression locally: remove the
  matching carrier and the three algebraic presentations separate; remove
  the conormal lemma and the two kernel lines separate; remove the C742
  boundary and the statement becomes circular.

### Mystery ledger

| feature | status | exact gap, gate, or owner |
|---|---|---|
| why exterior, commutator Pfaffian, and cross determinant agree | settled by Theorem 2.1 | one universal matching evaluation plus spectral norm |
| why Pfaffian descends but a selected cross block needs a pole | settled by Theorem 2.1 | projective bracket naturality versus fixed-eigenspace obstruction |
| why the assembled adjugate factors as polar times special-conformal direction | settled by Theorem 3.2 | target conormal times residual source orbit, with one scalar witness |
| whether the ten-point nilpotent defect has a human local normal form | settled by the rank-one tensor quotient | local ideal \(\mathfrak m(u)(v)\), square-zero length four per node, with independent replay |
| whether a boundary-twisted pole-marked MCM pair has a useful derived pushforward | genuine open branch, not current compression | requires a separately allocated compactification task before any \(R\pi_*\) claim |
| whether the \(36\to6\) return is a linear adjunction | settled negatively | unsigned pull--push vanishes on augmentation; signed repair is circular |
| whether another current compression survives the simplicity review | open while C743 remains active | rerun the moduli and balanced-return rounds from the new quotient theorem before closing |

The former nilpotent trust gap is closed.  The compactified-moduli branch and
the rerun simplicity/saturation review remain open, so this is not a task
closeout.
