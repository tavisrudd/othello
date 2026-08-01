# C739 — Golden cubic lift rigidity and transfer predictions

**Lane:** `golden`

**Date:** 2026-07-31

**Status:** research verdict complete; manuscript placement deferred to C735

## Executive verdict

The universal slogan is true after its category is stated correctly.
The fully marked Golden family is the unique primitive integral,
outer-(S_6)-equivariant synchronized Pfaffian lift of the Joubert map in
the six-cell conference target.  Its top Pfaffians are the unique cubic
covariant from the axis augmentation module to the signed outer augmentation
module, and centered squaring is the unique quadratic covariant from the
signed outer module to the untwisted outer module.  The cross-golden
determinants and adjugates are then forced by eigenspace splitting.

This is not a uniqueness theorem for every abstract Pfaffian presentation of
a cubic.  Dropping the six-cell target or full outer action admits the known
nonstandard-(S_5) Pfaffian net on the Segre target; dropping primitive
normalization admits a scalar family; dropping support orientation or the
golden embedding leaves the two already known torsors.  These are exact
hypothesis failures, not exceptions to the stated theorem.

Three further conclusions sharpen the original programme.

1. The middle-exterior/Pfaffian identity is universal in every even order:
   it is the coefficient expansion of
   (operatorname{Pf}[D_x,C]).  What is special to order six is the cubic
   degree, the exceptional outer automorphism, the signed outer multiplicity
   one, and the nontrivial (3+3) golden splitting.
2. There is no single master degeneracy scheme.  Instead there is a strict
   collision filtration.  The pair-collision divisor, Jacobian rank-drop
   scheme, and simultaneous-Pfaffian base scheme have respectively
   (15), (20), and (15) linear components of different dimensions.
   The Jacobian scheme is nonreduced, with its nilpotent defect supported at
   the ten (3+3) points.
3. The (36\to6) return is canonical.  The 36 extremal order-ten cuts are
   indexed by Sylow-(5) subgroups (H<S_6).  Each (H) lies in exactly
   one nonstandard (S_5), so it determines one Golden sister.  In fact
   [
   S_6/F_{20}\cong X\times\mathcal T
   ]
   as (S_6)-sets, with both six-to-one projections.  No extra marking is
   needed for the projective sister; the usual support-half bit is still
   necessary to orient it.

The user explicitly authorized this research before C735 and prohibited
manuscript edits.  Accordingly this report and its evidence bundle are the
only C739 deliverables installed now; `papers/golden-operator/` is unchanged.

## 1. Frozen definitions and claim ladder

Let (k) have characteristic zero.  Let (X) be the natural six-set,
(A=k^X/k\mathbf1\cong S^{(5,1)}), and let (mathcal T) be the outer
six-set.  Write

\[
 O=k[\mathcal T]_0\cong S^{(2,2,2)},\qquad
 U=\operatorname{sgn}\otimes O\cong S^{(3,3)}.
\]

A fully marked Golden presentation is the C720 datum: labelled (X), outer
six-set (mathcal T), coherent oriented conference matrices (C_T),
switching frames, and, only when needed, a choice of (sqrt5) and compatible
determinant-line orientations.

Let

\[
 \mathscr W=\bigoplus_{T\in\mathcal T}\bigwedge^2(k^X)^*
\]

with the signed monomial action frozen in C728.  A **synchronized linear
lift** is an (S_6)-map (A\to\mathscr W).  Two marked lifts are equivalent
under axis transport, coherent switching-frame isometries, and common scalar.
A primitive integral lift has relatively prime coefficients in the marked
axis and skew-coordinate lattices.  Pfaffian normalization fixes the scalar
by requiring

\[
 \operatorname{Pf}\alpha_T(x)=4Z_T(x).
\]

The proved/refuted ladder is:

| claim | verdict |
|---|---|
| the Segre equation is an ordinary invariant cubic on (U) | refuted: it is a sign-relative invariant |
| the relevant sign-relative cubic line is unique | proved |
| the Joubert map (A\to U) is the unique cubic covariant | proved |
| centered squaring (U\to O) is the unique quadratic covariant | proved |
| the synchronized six-cell tangent lift is unique | proved in the marked target |
| primitive integrality and Pfaffian normalization remove the scalar | proved |
| the cross-golden determinant and paired adjugates require no extra bit | refuted: selecting one member requires the independent golden-conjugation bit |
| every abstract Pfaffian model of a Segre cubic is Golden-equivalent | refuted as a formulation: the target and action are essential data |
| all degeneracy loci equal one master scheme | refuted by the exact scheme dictionary |
| the 36 extremal cuts have no canonical quotient to the sisters | refuted: the unique outer-(S_5) incidence supplies it |

## 2. P1 — invariant and covariant spaces

### Scalar invariants and relative invariants

Choose coordinates (z_T) on (U) with (sum_Tz_T=0).  The action is
(z\mapsto\operatorname{sgn}(g)P_{\phi(g)}z), where (phi) is the outer
automorphism.  For even degree, ordinary invariance is ordinary symmetry in
the six coordinates; for odd degree, sign-relative invariance is ordinary
symmetry.  Alternating polynomials begin with the Vandermonde in degree 15,
so the opposite parity spaces vanish through degree six.

Writing (p_r=\sum_Tz_T^r), the complete low-degree table is

| degree | ordinary invariants on (U) | sign-relative invariants on (U) |
|---:|---|---|
| 2 | (k p_2) | (0) |
| 3 | (0) | (k p_3) |
| 4 | (k p_4\oplus k p_2^2) | (0) |
| 5 | (0) | (k p_5\oplus k p_2p_3) |
| 6 | (k p_6\oplus k p_4p_2\oplus k p_3^2\oplus k p_2^3) | (0) |

Thus the signed Segre cubic is intrinsically the unique sign-relative cubic
hypersurface in (mathbf P(U)).  Its polar, after identifying (U^*) with
the untwisted outer module by the marked coordinate pairing, is

\[
 q_2(z)=\operatorname{center}(z_T^2)_T,
\]

the unique quadratic covariant (U\to O).

### Vector covariants

Put (q_r(z)=\operatorname{center}(z_T^r)_T).  The relevant multiplicities
are

| (d) | (dim\operatorname{Hom}_{S_6}(\operatorname{Sym}^dU,O)) | (dim\operatorname{Hom}_{S_6}(\operatorname{Sym}^dU,U)) |
|---:|---:|---:|
| 2 | 1 | 0 |
| 3 | 0 | 2 |
| 4 | 3 | 0 |
| 5 | 0 | 5 |
| 6 | 6 | 0 |

For example, the degree-four (O)-covariants have basis

\[
 q_4,\qquad p_2q_2,\qquad p_3q_1.
\]

These dimensions are also the low-degree coefficients of the free
reflection-covariant module with fundamental coordinate-power gradients.
The exact character calculation additionally gives

\[
 \dim\operatorname{Hom}_{S_6}(\operatorname{Sym}^dA,U)
 =(0,1,0,2,2)\quad(d=2,3,4,5,6).
\]

In particular the degree-three space is one-dimensional.  Since the Golden
top Pfaffians are nonzero, they span it: the Joubert lift is forced up to one
common scalar.  Degree five is already two-dimensional, so multiplicity-one
is itself part of the cubic resonance and does not persist merely because the
same modules remain available.

The statement is a characteristic-zero theorem.  The character proof also
applies in semisimple characteristic (p>5).  The coordinate proof of the
scalar table survives more broadly when (2) and (3) are invertible, but
the Golden operator has a separate degeneration at (5); no modular
multiplicity claim is made at (2,3,5).

## 3. P2 — lift rigidity

### Theorem (marked Golden lift rigidity)

For a fully marked Golden presentation over a characteristic-zero field,

\[
 \dim\operatorname{Hom}_{S_6}(A,\mathscr W)=1.
\]

Consequently every outer-equivariant synchronized linear skew lift is a
common scalar multiple of

\[
 \alpha_T(x)_{ij}=(x_i-x_j)(C_T)_{ij}=[D_x,C_T]_{ij}.
\]

Among primitive integral lifts there are only (alpha) and (-alpha).
Fixing the coherent Pfaffian orientation and
(operatorname{Pf}\alpha_T=4Z_T) selects (alpha).  After adjoining
(sqrt5), the decomposition

\[
 P_{T,\pm}=\frac12\left(I\pm C_T/\sqrt5\right)
\]

forces the cross block (B_T=P_{T,-}D_xP_{T,+}), its determinant, and its
adjugate.  Hence the determinant presentation is unique in the same marked
category, with golden conjugation exchanging the two transpose
presentations.

#### Proof

The Hom-space equality is the exact C728 character theorem.  Since the
displayed commutator map is nonzero, it spans.  Primitive integrality reduces
the scalar to (pm1); the signed Pfaffian normalization fixes the sign.
Block decomposition relative to the two (C_T)-eigenspaces then gives

\[
 [D_x,C_T]=
 \begin{pmatrix}0&-2\sqrt5 B_T^{\mathsf T}\\
 2\sqrt5 B_T&0\end{pmatrix},
\]

so determinant, adjugate, small resolutions, and paired rank-one MCM sheaves
are consequences rather than independent lift choices.  (square)

### Counterexample-first hypothesis audit

| hypothesis removed | competing object or ambiguity | verdict |
|---|---|---|
| full outer (S_6) and six-cell target | the nonstandard-(S_5) single-Pfaffian net on the Segre target | distinct presentation; not a synchronized Golden lift |
| common normalization | (lambda\alpha), (lambda\in k^\times) | scalar family |
| support/Pfaffian orientation | (alpha\leftrightarrow-\alpha) | one unavoidable bit |
| golden embedding | (B_T\leftrightarrow B_T^{\mathsf T}) | exchanges small resolutions and rank-one MCM summands |
| switching frames | many literal matrices (D C_TD) | diagonal gauge only |
| fixed target representation | arbitrary skew determinantal representations | a different classification problem; not licensed by the cubic alone |

Thus “unique outer-equivariant lift” is proved only with the target and
equivalence relation displayed above.  The cubic relation by itself cannot
reconstruct a chosen rank-one MCM summand or an arbitrary ambient Pfaffian
model.

## 4. P3 — reconstruction and minimal information

The exact reconstruction lattice is

\[
 \text{unordered support two-graph}
 \longleftrightarrow \ell_C
 \longleftrightarrow [Z_C]
 \longleftrightarrow [\det[D_x,C]]
 \longleftrightarrow \text{relative dimer word}.
\]

Here (ell_C=\{[C],[-C]\}).  The reverse arrows use triangle holonomies or,
without taking a polynomial square root, the coefficients

\[
 [x_i^2x_j^2x_kx_l]\det[D_x,C]
 =32,t_{ijk}t_{ijl}.
\]

| datum recovered | two-graph / determinant / dimer | chosen support half | golden embedding | literal switching frame |
|---|---:|---:|---:|---:|
| labelled axis and outer carriers | yes | yes | yes | yes |
| unoriented switching line | yes | yes | yes | yes |
| coherent projective six-family | yes | yes | yes | yes |
| signed odd family | no | yes | yes | yes |
| one of two golden resolutions/MCM summands | no | no | yes | yes |
| literal skew matrices | no | no | no | yes |

The support-half and golden-conjugation bits are independent.  No even shadow
can recover the first, and no rational/projective cubic shadow can select one
golden eigenspace.  The unlabelled deep-hole conic remains insufficient:
its transitive 22-parent action supplies no canonical labelled two-graph.

Pointwise centered squaring is birational away from the Igusa singular
locus.  Its ten base points are the Segre nodes; over the fifteen Igusa
singular lines its resolved fibres are the C727 conics, degenerating to six
lines at their fifteen intersection points.  This pointwise exceptional loss
does not alter the polynomial-family reconstruction above.

## 5. P4 — scheme-level degeneracy dictionary

Let (J_Z) be the (6\times5) Jacobian of the six cubic top coordinates in
the translation gauge.  The exact scheme calculation gives

\[
 \mathcal R=V(I_4(J_Z)).
\]

It has projective degree 20 and is nonreduced.  Its radical is the reduced
union of the twenty triple-collision planes

\[
 \Pi_Q=\{x_i=x_j\text{ for }i,j\in Q\},\qquad |Q|=3.
\]

The annihilator of (sqrt{I_4(J_Z)}/I_4(J_Z)) has radical supported on the
ten (3+3) points (Pi_Q\cap\Pi_{Q^c}).  Thus the top-dimensional
rank-drop components are reduced, while the Jacobian scheme has additional
lower-dimensional nilpotent structure precisely above the ten nodal images.

The complete dictionary is:

| locus | source/target scheme | relation to the others |
|---|---|---|
| pair-collision discriminant | reduced union of 15 source hyperplanes, cut by the Vandermonde | pullback of the 15 vectorlike Segre planes and polar exceptional divisor |
| Jacobian rank drop | nonreduced degree-20 scheme; radical is 20 triple-collision planes | proper sublocus of pair collision; nilpotent defect at ten (3+3) points |
| simultaneous top-Pfaffian/Majorana zero | reduced union of 15 four-collision projective lines | projective base scheme of the Joubert/spinor top map; proper sublocus of rank drop |
| Segre polar base | reduced ten-node scheme in the target | images of the closed (3+3) orbits, not the source simultaneous-zero scheme |
| inverse-polar exceptional locus | 15 Segre planes | pulls back to pair collisions and contracts to the 15 Igusa singular lines |
| individual Majorana walls | six cubic divisors (Z_T=0) | independent of the collision divisor; strict chirality excludes both |
| one-(U(1)) anomaly locus | the entire Segre cubic | ambient target, not a degeneracy scheme |
| two-(U(1)) anomaly families | Fano scheme with 15 plane components and 6 degree-five del Pezzo components | parameter space of lines, not equal to any source collision stratum |

The nesting of reduced supports is therefore

\[
 \{≥4\text{ coincident}\}
 \subset
 \{≥3\text{ coincident}\}
 \subset
 \{≥2\text{ coincident}\},
\]

but the scheme structures and target contractions differ.  This is the
negative master-discriminant theorem requested by P4.

## 6. P5 — the canonical (6\to10\to36\to6) cycle

C729 identifies the 36 extremal balanced cuts of the order-ten conference
shadow with the Sylow-(5) subgroups (H<S_6), hence with (S_6/F_{20}).
The missing quotient is forced by subgroup incidence.

### Theorem (double six-set incidence)

Every Sylow-(5) subgroup (H<S_6) lies in exactly one standard point
stabilizer (S_5) and exactly one nonstandard outer (S_5).  Therefore

\[
 H\longmapsto (x(H),T(H))
\]

is an (S_6)-equivariant bijection

\[
 S_6/F_{20}\stackrel{\sim}{\longrightarrow}X\times\mathcal T.
\]

Both projections have fibres of size six.  In particular
(b_H\mapsto T(H)) is the canonical unmarked (36\to6) map to the Golden
sisters.

#### Proof

There are two conjugacy classes of index-six (S_5) subgroups, the standard
and outer classes, each containing six subgroups.  Every (S_5) contains six
Sylow-(5) subgroups.  For either class, the incidence count is therefore
(6\cdot6=36).  Since (S_6) has

\[
 [S_6:N_{S_6}(H)]=720/20=36
\]

Sylow-(5) subgroups and acts transitively on them, each (H) occurs once
in each incidence class.  If an (S_5) contains (H), it contains
(N_{S_6}(H)=F_{20}).  The two containing (S_5)'s intersect in this
maximal (F_{20}<S_5), so the pair determines (H).  (square)

The local sign-kernel bordering of each extremal order-ten half therefore
lands over a canonically selected sister.  Choosing which orientation of that
sister remains exactly the support-half bit from P3; no new 36-column torsor
appears.

The direct Gram iteration still stops.  The 36 cut lines form a tight frame
of redundancy four, not two, and its canonical weighted operator satisfies

\[
 K^2=10K+75I,\qquad (K-5I)^2=100I.
\]

The return map is subgroup incidence, not another conference Gram factor.

## 7. P6 — even-order boundary theorem

### Universal identity

Let (C) be any symmetric (2m\times2m) matrix with zero diagonal over a
ring where the Pfaffian is defined, and put (D_x=\operatorname{diag}(x)).
With the compatible Hodge orientation,

\[
 \boxed{\operatorname{Pf}[D_x,C]
 =\sum_{|S|=m}(*\!\bigwedge^m C)_{SS},x_S.}
\]

Indeed, expand the Pfaffian over perfect matchings and then expand every
(C_{ij}(x_i-x_j)).  The coefficient of (x_S) receives terms exactly from
matchings pairing (S) bijectively with (S^c); their signed sum is
(det C_{S,S^c}), which is the displayed Hodge-middle-exterior diagonal.
No conference equation is needed.

If additionally (C^2=qI), (q=s^2), and the two eigenspaces have dimension
(m), the same block calculation gives

\[
 \operatorname{Pf}[D_x,C]
 =\text{(orientation scalar)}\,(2s)^m
 \det(P_-D_xP_+).
\]

Thus middle exterior, commutator Pfaffian, and cross-eigenspace determinant
are the generic even-order mechanism.

| order | verdict |
|---:|---|
| 2 | linear and split; the identity is tautological |
| 4 | no symmetric zero-diagonal sign conference matrix in characteristic not two; the Golden conference input is absent |
| 6 | degree three, nontrivial (sqrt5) splitting, outer (S_6), and unique Joubert cubic all coincide |
| 10 | degree five and a rational (5+5) splitting because (C^2=9I); no outer (S_{10}), no Segre cubic, and the next integral frame has redundancy four |

Order six is therefore not exceptional because Pfaffians or middle exterior
powers first exist there.  It is exceptional because the universal degree-
(m) identity lands at (m=3) in the unique signed outer cubic module while
the conference spectrum simultaneously splits (3+3) over
(mathbf Q(\sqrt5)).

## 8. P7 — portability criterion and bounded uses

### Portability criterion

A construction transports all projective/even Golden shadows exactly when
it functorially recovers a labelled unordered regular two-graph on a six-set.
Choosing one half transports signed odd shadows.  Choosing a golden
eigenspace transports one selected cross-golden resolution or MCM summand.
Recovering only the abstract isomorphism type of the order-six conference
matrix is insufficient for an input-relative map because it does not supply
the axes, variables, or outer carrier.

### Demonstration 1: robust recognition

The six ten-sign sister words have mutual Hamming distance six.  Full
nearest-word decoding corrects any two sign errors.  After Golden membership
is certified, a determining triple identifies the sister; three bits are
information-theoretically minimal, and 60 of 120 triples work.  Alternatively
five cut magnitudes indexed by a five-cycle certify conference membership,
and their signs identify the projective sister.  This protocol does not
recover the common orientation bit.

### Demonstration 2: rational anomaly synthesis

The C715 matching-ratio inverse gives a rational path sextuple for every
rational point of the Segre anomaly variety.  Moving one path coordinate
gives the six chiral two-(U(1)) directions through a generic point; fixed
pair collisions give the fifteen vectorlike plane families.  The line
criterion is exactly the two individual cubic, two mixed cubic, and two
linear anomaly equations.  This transports arithmetic solutions and does
not assert a gauge-theory model.

### Demonstration 3: symbolic switching recognizer

From a determinant sextic, read the ((2,2,1,1))-coefficients, normalize
their projective sign by the Johnson-triangle product condition, and recover
the four-cycle holonomies.  From a dimer presentation, take ratios of matching
terms differing by one transposition.  The two procedures give the same
holonomies and therefore the same switching line.  They are exact polynomial
and combinatorial implementations of one recognizer.

## 9. P8 — arithmetic and categorical diagnostics

| feature | forced by invariant cubic | forced by marked Golden lift | independent extra data |
|---|---:|---:|---:|
| Segre equation and polar | yes | realizes them | no |
| (mathbf Q(\sqrt5)) | no | yes, from (C^2=5I) and eigenspace splitting | no |
| paired small resolutions and rank-one MCM sheaves | no | yes | selecting one needs golden bit |
| bad primes (2,5) | no | yes, from orientation/denominators and golden ramification | no |
| chamber field (mathbf Q(\sqrt{13})) | no | no | yes, coset-incidence spectrum |
| cross-Gram primes (11,23) | no | no | yes, scalar-image conductor data |
| (E_8\)-Hamming failure and (II_{10,10}) repair | no | no | yes, integral lattice/gluing data |

There is a meaningful but bounded categorical statement.  Over
(mathbf Q(\sqrt5)), the coherent family gives an (S_6)-equivariant
action groupoid on the six pairs of transpose matrix factorizations; golden
conjugation exchanges the two rank-one objects, and restriction of scalars
gives the rational rank-two MCM object with (J^2=5I).  There is no canonical
single rank-one object over (mathbf Q), and the data do not produce a new
derived equivalence or one global Wick parent.  Passing to speculative
derived-category language adds no further theorem, so the categorical probe
stops here.

## 10. `aa` — routes to the deeper equivalence-of-presentations theorem

The failed formulation asked every shadow to be the same invariant.  The
stronger viable formulation asks them to be values of one small tensor
diagram.  Five distinct attacks were compared.

1. **Tannakian/multiplicity-one diagram.**  Use (A,U,O,\mathscr W) and the
   unique arrows (A\to\mathscr W),
   (\operatorname{Sym}^3A\to U), and
   (\operatorname{Sym}^2U\to O).  This is the highest-EV route because P1
   and P2 already prove all three uniqueness statements.
2. **Universal Pfaffian law.**  Treat the all-even-order identity of P6 as a
   natural transformation and characterize order six as its unique
   cubic/outer-automorphism fibre.
3. **Moduli and Fitting complexes.**  Descend the two golden rank-three
   eigenspaces and (P_-D_xP_+) over the six-point quotient.  Its determinant,
   adjugate, critical complex, and Fitting ideals should produce the cubic,
   two resolutions, and the collision filtration from one bundle map.
4. **Double-(S_5) Hecke incidence.**  Use
   (S_6/F_{20}\cong X\times\mathcal T) to place the ten nodes, 36 cuts,
   Sylvester relation, and return map in the correspondence algebra of the
   two index-six subgroup classes.
5. **Clifford/MCM descent.**  Package (C^2=5I), the transpose matrix
   factorizations, and golden conjugation as a quadratic-algebra norm object.
   This explains the categorical and (2,5)-arithmetic layer but cannot by
   itself explain the chamber field or lattice repair.

The recommended synthesis combines routes 1 and 3.  Its representation-level
part is already a theorem here:

> **Golden tensor-diagram theorem.**  In polynomial degree at most three,
> after fixing the fully marked source and the six-cell target, the normalized
> synchronized tangent map, Joubert/Pfaffian cubic, and Segre polar are the
> unique nonzero arrows of their required source, target, degree, and twist.
> The exterior, commutator, cross-golden determinant, and centered-square
> presentations are evaluations of this one normalized diagram.

The proof is exactly the three multiplicity-one results plus one scalar
evaluation in each square.  This achieves the algebraic core of the original
vision without falsely identifying its different targets.

The deeper geometric upgrade has one sharp remaining gate: construct the
rank-three golden eigenbundles and cross block on the quotient stack with the
correct determinant-line linearization, then prove that the three collision
levels are successive Fitting/critical strata of its derived degeneracy
complex.  Success would turn P4's unequal schemes from an obstruction into
the geometric reason the presentations differ.  Failure of bundle descent
would identify the precise golden/orientation gerbe obstructing a global
unification.  Either outcome is theorem-shaped and does not require a broad
new census.

### Post-closeout `ej2`: pole-marked moduli unification

The proposed gate can be resolved more sharply.  Let

\[
 \mathcal C_6=(\mathbf P^1)^6
\]

with tautological lines (L_i\subset V\otimes\mathcal O),
(dim V=2), and put

\[
 E=\bigoplus_iL_i,\qquad \delta=\det V.
\]

For every Golden sister define a skew bundle map

\[
 \boldsymbol\alpha_T:E\longrightarrow E^*\otimes\delta,
 \qquad (\boldsymbol\alpha_T)_{ij}=C_{T,ij}[ij].
\]

This is well-defined because
([ij]\in L_i^{-1}L_j^{-1}\delta).  Its Pfaffian is a section of

\[
 (\det E)^{-1}\delta^3
 \cong\mathcal O(1,1,1,1,1,1)\otimes\delta^3.
\]

On the affine chart (v_i=(x_i,1)), it becomes exactly

\[
 \boldsymbol\alpha_T=(C_{T,ij}(x_i-x_j))=[D_x,C_T].
\]

Thus the Pfaffian/Joubert and weighted pure-spinor presentations globalize
canonically on the six-point quotient stack; their projectivized top system
is the Segre GIT quotient.  No choice of affine pole is required at this
level.

The cross-golden determinant lives naturally one level higher.  Add a
seventh labelled point (p_\infty) disjoint from the six paths.  On

\[
 M_{0,7}\longrightarrow M_{0,6}
\]

it selects an affine chart on (mathbf P^1\setminus\{p_\infty\}), unique up
to (y=ax+b).  Under such a change,

\[
 [D_y,C_T]=a[D_x,C_T],\qquad
 P_-D_yP_+=aP_-D_xP_+,
\]

because (P_-P_+=0).  Hence the projective cross block, determinant,
adjugate, matrix factorization, and its two small resolutions descend over
the pole-marked moduli space.  The forgotten seventh point is exactly the
one-parameter pole in C715's inverse fibre.

This structure does not descend by the same formula to (M_{0,6}).  For a
general projectivity

\[
 y_i=\frac{ax_i+b}{cx_i+d}
\]

one has

\[
 [D_y,C_T]
 =(ad-bc)\Lambda[D_x,C_T]\Lambda,
 \qquad
 \Lambda=\operatorname{diag}\bigl((cx_i+d)^{-1}\bigr).
\]

The Pfaffian changes only by the correct determinant-line scalar and therefore
descends.  But (Lambda) preserves the fixed golden eigenspaces only if it
commutes with (C_T).  Since every off-diagonal entry of (C_T) is nonzero,
([\Lambda,C_T]=0) forces all diagonal entries of (Lambda) to be equal.
For six distinct points this is exactly the affine case (c=0).  Therefore:

> **Pole-descent theorem.**  The Pfaffian/Joubert presentation is intrinsic on
> the six-point quotient, while the displayed cross-golden determinant and
> selected matrix factorization are intrinsic on the universal pole-marked
> cover.  Forgetting the pole preserves their determinant cubic but not their
> fixed (3+3) golden splitting.

This is the exact geometric reason that charge ratios are fixed on a C715
inverse fibre while the common Slater success scale varies with its pole.  It
also separates three independent choices: the continuous pole lift, the
support-orientation bit, and the golden-conjugation bit.

The degeneracy schemes acquire a common compactified parent as well.  The
boundary of (overline M_{0,6}) has exactly

\[
 15\ \Delta_{2|4}+10\ \Delta_{3|3}
\]

irreducible divisors.  Under the equal-weight GIT contraction to the Segre
cubic, the fifteen (2|4) divisors give the pair-collision/vectorlike-plane
boundary, while the ten (3|3) divisors contract to the ten nodes.  The
twenty prequotient triple-collision planes occur in complementary pairs above
those ten (3|3) partitions, and the Jacobian's lower-dimensional nilpotent
defect is supported at their contracted images.  Consequently the best
master object is not one discriminant subscheme: it is the normal-crossing
boundary of (overline M_{0,6}) together with its GIT contraction and
critical Fitting scheme.

This resolves the highest-EV part of the moduli/Fitting attack.  A remaining
upgrade would identify the exact sheaf-theoretic pushforward of the two
pole-marked MCM summands.  The correct setting is first to extend the
projective cross block, with its boundary or logarithmic twist, over the
proper universal stable curve

\[
 \overline M_{0,7}\longrightarrow\overline M_{0,6},
\]

and only then compute its derived pushforward.  On the open forgetful map the
fibres are punctured curves and a bare pushforward need not even be coherent;
on either map the relative dimension rules out a finite-norm shortcut.  Thus
the next theorem must specify the compactified sheaf and its boundary
filtration before writing \(R\pi_*\).

### Post-closeout `ej3`: the universal Temperley--Lieb carrier

The pole-marked theorem is the (m=3) member of a general construction.
Let (n=2m), let

\[
 A_n=k^n/k\mathbf1,
\]

and let (mathcal I_m) be the multilinear (operatorname{SL}_2)-invariant
space of (2m) labelled vectors.  Schur--Weyl duality and the first
fundamental theorem identify

\[
 \mathcal I_m\cong S^{(m,m)},\qquad
 \dim\mathcal I_m=\operatorname{Cat}_m
 =\frac1{m+1}\binom{2m}{m}.
\]

It is generated by the perfect-matching brackets

\[
 [i_1j_1]\cdots[i_mj_m]
\]

modulo the Plücker, equivalently Temperley--Lieb, relations.  On the affine
chart (v_i=(x_i,1)), these are the degree-(m) translation-invariant
matching products (prod_r(x_{i_r}-x_{j_r})).  They assemble into a
canonical (S_{2m})-covariant

\[
 \mathcal J_m:A_n\longrightarrow\mathcal I_m^*
\]

of degree (m).

### Theorem (universal matching covariant)

Over characteristic zero,

\[
 \dim\operatorname{Hom}_{S_{2m}}
 \left(\operatorname{Sym}^mA_n,S^{(m,m)}\right)=1,
\]

and (S^{(m,m)}) does not occur in
(operatorname{Sym}^dA_n) for (d<m).  Hence (mathcal J_m) is the unique
minimal-degree covariant to the matching-invariant carrier.

#### Proof

In degree (m), the squarefree monomials form the permutation module
(M^{(m,m)}).  Young's rule contains (S^{(m,m)}) there with multiplicity
one.  Every nonsquarefree monomial uses (r<m) variables, so its orbit
module has an unused block of size (2m-r>m); the dominance criterion in
Young's rule excludes (S^{(m,m)}).  The same exclusion holds in every
degree below (m).  Since

\[
 k^n=k\mathbf1\oplus A_n,
\]

the first occurrence inside (operatorname{Sym}^m(k^n)) must occur in the
(operatorname{Sym}^mA_n) summand, with the same multiplicity one.
(square)

For any symmetric zero-diagonal matrix (C), its bracket-Pfaffian is the
pairing of this universal covariant with one matching-weight functional:

\[
 \operatorname{Pf}\bigl(C_{ij}[ij]\bigr)
 =\left\langle c_C,\mathcal J_m(x)\right\rangle,
 \qquad
 c_C(M)=\operatorname{sgn}(M)\prod_{ij\in M}C_{ij}.
\]

The middle-exterior identity in P6 is the same equality in the affine chart.
If this functional is nonzero, its full (S_{2m})-orbit spans
(S^{(m,m)*}) by irreducibility.  Thus conference matrices do not create the
universal carrier; they select unusually structured frames of linear
functionals on it.

Schur averaging strengthens this observation.  For every nonzero
(c\in S^{(m,m)*}), its distinct group orbit is a tight frame: the sum of
the rank-one projectors onto the orbit commutes with (S_{2m}), hence is
scalar.  If the orbit has (N) elements in dimension
(d=\operatorname{Cat}_m), its frame constant is
(N\lVert c\rVert^2/d).  In the Golden case (N=6) and (d=5); the orbit
has zero centroid and its outer action is two-transitive, so the one possible
off-diagonal inner product is forced and the frame is the regular simplex.
The Joubert cubic forms, ten-sign syndrome rows, and real
(operatorname{ETF}(5,6)) presentation are therefore three models of the
same minimal-redundancy group frame.  In higher order the full orbit remains
tight, but multiple stabilizer double cosets generally produce several
angles, so tightness alone does not continue the conference/simplex tower.

The equal-weight quotient of (2m) points has dimension (2m-3) and is
embedded by (mathcal I_m) in
(mathbf P^{\operatorname{Cat}_m-1}).  Its codimension is

\[
 \operatorname{Cat}_m-2m+2.
\]

For (m=2) this is zero.  For (m=3) it is one, while for (m=4,5) it is
respectively (8,34) and then grows strictly.  Therefore order six is the
unique nontrivial even order in which the universal matching quotient is a
hypersurface.  At precisely that order,

\[
 S^{(3,3)}\cong
 \operatorname{sgn}\otimes k[\mathcal T]_0
\]

through the exceptional outer automorphism, and the hypersurface is the
Segre cubic.  The six Golden sisters are consequently a six-vector simplex
frame on the five-dimensional universal invariant carrier.

### `tt` correction: hypersurface-unique does not mean geometry-unique

The preceding conclusion is deliberately narrower than "order six is the
only exceptional order."  HMSV prove that for every even \(n\ne6\) the
equal-weight ideal is generated, up to symmetry, by a simple quadratic
relation inherited from the eight-point case; they also isolate a skew cubic
at eight points whose singular locus recovers the quotient.  Thus \(n=8\)
has a second exceptional invariant-theory geometry even though its quotient
has codimension eight and is not a hypersurface.

The clean separation is therefore:

- \(n=6\) is uniquely the nontrivial *hypersurface* case and uniquely admits
  the outer-\(S_6\), six-vector simplex resonance;
- \(n=8\) is the first source of the stable quadratic relations and carries
  its own skew-cubic singular-locus construction;
- the conference-weighted Pfaffian functional exists on the matching carrier
  in every even order, but neither the HMSV relations nor tightness of a group
  orbit by themselves produce a Golden-style eigenspace splitting.

This correction improves the proposed generalization: the next comparison is
not a forced Golden iteration at order ten, but an order-eight comparison
between the matching-relation geometry and functionals selected by whatever
structured symmetric zero-diagonal matrices exist there.  A concrete test is
to restrict the HMSV quadratic relation module to the orbit frame of
\(c_C\), and ask whether its Gram association scheme detects extra design
strength.  That is a well-posed follow-on; no such theorem is asserted here.

### Post-closeout `ej4`: the Pfaffian--Hafnian parity twin

There is a sharper bridge between the six- and eight-point exceptions.  Let
\(Q\) be a zero-diagonal sign matrix and put

\[
 B_Q(v)_{ij}=Q_{ij}[ij].
\]

Because both matrix transposition and the bracket reverse the indices,

\[
 Q^T=\varepsilon Q\quad\Longrightarrow\quad
 B_Q^T=-\varepsilon B_Q.
\]

Thus two adjacent conference orders land in different matching statistics:

\[
 \begin{array}{c|c|c}
 Q^T=Q & B_Q^T=-B_Q & \operatorname{Pf}(B_Q),\\
 Q^T=-Q & B_Q^T=B_Q & \operatorname{Hf}(B_Q).
 \end{array}
\]

Here the Hafnian is the unsigned perfect-matching sum.  Both outputs pair
the same bracket covariant \(\mathcal J_m\) with a coefficient functional;
the difference is whether the crossing sign comes from the Pfaffian or is
cancelled by the skew edge orientation.

The familiar congruence obstruction now has structural meaning.  A symmetric
conference sign matrix of order \(n>2\) can exist only for
\(n\equiv2\pmod4\).  Indeed, switch signs so that its first row is all ones
and delete that row and column.  Every row of the remaining symmetric
\((n-1)\)-vertex sign graph has \((n-2)/2\) positive edges.  The handshake
lemma makes

\[
 (n-1)(n-2)/2
\]

even; since \(n\) is even and \(n-1\) is odd, \((n-2)/2\) is even.  Hence
the order-six Golden Pfaffian cannot have a symmetric-conference continuation
at order eight.  The Paley matrix at order eight instead satisfies

\[
 K^T=-K,\qquad KK^T=7I,
\]

and supplies the parity-twin quartic

\[
 H_K(v)=\operatorname{Hf}\bigl(K_{ij}[ij]\bigr)
       \in \mathcal I_4^*.
\]

The Paley construction labels the vertices by
\(\mathbf P^1(\mathbf F_7)\), takes \(K_{\infty,a}=1\), and takes
\(K_{a,b}=\chi(b-a)\).  The standard quadratic-character sum proves
\(KK^T=7I\).  On an affine chart, exact expansion gives

\[
 H_K(x)=\sum_{|S|=4}a_Sx_S,
 \qquad a_S\in\{0,\pm8\},
\]

with fourteen coefficients \(+8\), fourteen coefficients \(-8\), and
forty-two zeros.  The coefficientwise translation derivative vanishes.
The projective Paley group \(PGL_2(7)\) stabilizes the line \([H_K]\): a
fractional linear change transforms the quadratic character on every edge by
one global character and one switching factor at each endpoint, and the
endpoint factors multiply to a matching-independent scalar.  Its order is
336.  Exact enumeration shows that this is the full projective stabilizer,
with a sign-preserving subgroup of order 168.  Consequently

\[
 S_8/PGL_2(7)
\]

is a 120-line orbit in the fourteen-dimensional carrier \(S^{(4,4)}\);
the signed orbit has 240 vectors and exact rank fourteen.  Schur averaging
again makes it tight, but the redundancy \(120/14\) precludes the Golden
simplex mechanism.

This is the deeper adjacent-order unification:

| order | conference parity | matching statistic | carrier geometry |
|---:|---|---|---|
| 6 | symmetric, \(C^2=5I\) | Pfaffian cubic | Segre cubic hypersurface; six-line simplex |
| 8 | skew, \(K^2=-7I\) | Hafnian quartic | 14-coordinate quotient; 120-line Paley orbit |

The last column must not be conflated.  \(H_K\) is one linear coordinate
functional on the fourteen-dimensional Joubert/Kempe embedding, whereas the
HMSV skew cubic is cubic in those fourteen coordinates and has the
eight-point quotient as its singular locus.  Testing the 120 Paley
hyperplanes against that skew cubic is now the highest-EV order-eight
question.

The Hafnian here is a mathematical matching functional, not yet the
three-boson permanent of C718.  It should be handed to C718 as a possible
parity-organizing invariant; no physical bosonic amplitude claim is made in
C739.

### Post-closeout `ej5`: the 120 self-polar Steiner pairs

The open order-eight incidence question has an exact answer.  Use the
coefficient inner product on squarefree degree-four polynomials to identify
\(S^{(4,4)}\) with its dual.  If \(\Gamma_M\) is the bracket polynomial of
a perfect matching and \(\epsilon(M)\) its Pfaffian crossing sign, normalize
HMSV's unique skew cubic as

\[
 F(y)=\sum_M\epsilon(M)\langle y,\Gamma_M\rangle^3.
\]

This differs from the literal antisymmetrization of one matching cube only by
the common stabilizer factor \(2^4 4!=384\).  It is therefore the same
projective cubic with a convenient integral scale.

Let \(h\) be the Paley--Hafnian coefficient vector from `ej4`.  Exact
evaluation gives

\[
 F(h)=2,408,448,
 \qquad
 \nabla F(h)=4032h.
\]

Thus \([h]\) is **not** on the skew cubic and certainly not on its singular
locus \(M_8\).  Instead, under the invariant self-duality it is a fixed point
of the projective polar map defined by the fourteen HMSV quadrics.  Equivalently,
the hyperplane \(h=0\) is the polar hyperplane of the point \([h]\).  By
projective \(S_8\)-equivariance, every line in the 120-element Paley orbit is
self-polar in the same sense.

The coefficients reveal the finite geometry behind that orbit.  Define

\[
 \mathcal B_+=\{S:a_S=8\},\qquad
 \mathcal B_-=\{S:a_S=-8\}.
\]

Each set has fourteen four-subsets; every three-subset lies in exactly one
member of each.  Hence \(\mathcal B_+\) and \(\mathcal B_-\) are disjoint
Steiner quadruple systems \(S(3,4,8)\).  There are thirty labelled
\(SQS(8)\)'s.  Their disjointness graph is regular of degree eight and has

\[
 30\cdot8/2=120
\]

edges.  Exact orbit comparison identifies

\[
 S_8/PGL_2(7)
 \cong
 \{\text{unordered disjoint pairs of labelled }SQS(8)\}.
\]

The signed 240-vector orbit consists of the two orientations of each edge:
\(h/8\) is the difference of the two Steiner incidence vectors.  The second
one-dimensional line fixed by the pair stabilizer is the centered support
vector

\[
 h'_S=
 \begin{cases}
  -3,&S\in\mathcal B_+\cup\mathcal B_-,\\
   2,&S\notin\mathcal B_+\cup\mathcal B_-.
 \end{cases}
\]

It satisfies \(\langle h,h'\rangle=0\).  The exact Hessian calculation is

\[
 \operatorname{Hess}_h(F)h=8064h,
 \qquad
 \operatorname{Hess}_h(F)h'=5760h',
\]

and on the remaining twelve dimensions its minimal factor is

\[
 t^2+2304t-4,644,864,
\]

so the two eigenvalues are

\[
 -1152\pm1728\sqrt2,
\]

each with multiplicity six.  The radial eigenvalue \(8064=2\cdot4032\) is
Euler's identity for a cubic.  On the tangent space to the invariant sphere,
the constrained Hessian subtracts the multiplier 4032.  It therefore has one
positive eigenvalue \(1728\) and twelve negative eigenvalues
\(-5184\pm1728\sqrt2\).  Every Paley line is a nondegenerate projective
critical point of Morse signature \((1,12)\), up to reversing the sign
convention for the objective.

This supplies the missing relation to HMSV without collapsing the objects:

\[
 \boxed{\text{disjoint Steiner pair}}
 \longleftrightarrow
 \boxed{\text{Paley--Hafnian line}}
 \longleftrightarrow
 \boxed{\text{self-polar critical line of the skew cubic}}.
\]

It also explains why the order-eight orbit is large rather than simplex-like:
it is the edge set of a thirty-vertex design graph.  The next geometric
question is whether its 120 polar hyperplanes cut a distinguished divisor or
arrangement on \(M_8\), not whether their pole points lie on \(M_8\); the
latter is now ruled out.

This gives the deeper general-versus-exceptional split:

| mechanism | every (2m) | only the Golden (m=3) resonance |
|---|---:|---:|
| matching-bracket carrier (S^{(m,m)}) | yes | no |
| unique first degree-(m) covariant | yes | no |
| commutator Pfaffian equals a carrier functional | yes | no |
| pole-marked cross-eigenspace determinant when (C^2=qI) | yes | no |
| quotient is a nontrivial hypersurface | no | yes |
| carrier is a signed outer augmentation module | no | yes |
| six coherent functionals form a simplex frame | no | yes |
| one cubic equation supplies polarity and anomaly arithmetic | no | yes |

For order ten, the natural carrier has dimension
(operatorname{Cat}_5=42).  The 36 Sylow-(5) extremal cuts therefore
cannot be the complete next matching-coordinate frame: they are an
(S_6)-restricted shadow, not the full (S_{10}) invariant carrier.  This
representation-dimension mismatch independently explains the failure of a
direct (10\to36) Joubert/Gram iteration, complementing C729's redundancy-
four obstruction.

## 11. Formula-level literature sweep

### Search and coverage

On 2026-07-31 the sweep queried the local persistent arXiv cache first, then
searched the web and zbMATH Open with these families:

- `S^(m,m) invariants points projective line perfect matchings Specht module`;
- `symmetric power standard representation Specht (m,m) multiplicity one`;
- `Pfaffian weighted Plucker bracket matrix points P1` and the exact
  combinations `[D_x,C] Pfaffian conference matrix` and
  `C_ij [ij] Pfaffian invariant`;
- `Mbar 0 6 GIT Segre cubic boundary divisors 3+3 contracted nodes`;
- the HMSV title family for equations and relations of points on a line; and
- zbMATH-restricted versions of the invariant, conference-Pfaffian, Segre,
  and symmetric-power queries; and
- post-`ej5` exact combinations of `skew cubic`, `PGL(2,7)`, `120 points`,
  and `disjoint Steiner quadruple systems order 8`.

The web interface did not expose stable total-result counts, so this audit
does not turn the displayed result pages into an enumerated negative set.
The mechanical promotion rule was: retain a result if its displayed fields
joined at least two of matching brackets, the \(S^{(m,m)}\) carrier,
symmetric powers of the standard representation, conference-weighted
Pfaffians, the Segre quotient, or the \(\overline M_{0,6}\) GIT contraction.
The exact-formula searches returned generic conference, commutator, and
Pfaffian literature but no displayed record for the combined construction.
MathSciNet and Google Scholar are **NOT COVERED**, and no forward-citation
closure was attempted.  Consequently this is a formula-level positioning
audit, not a priority proof.

### Sources and read depth

1. Benjamin Howard, John Millson, Andrew Snowden, and Ravi Vakil,
   *The relations among invariants of points on the projective line*,
   arXiv:0906.2437v1 --- **full text**, all six pages.  Cache key
   `arXiv:0906.2437`, SHA-256
   `dfbdb89c3061b5987f59602a55d5eb40c7c29eab18f9203c0e43c6f765d37508`.
   This is the decisive predecessor for the degree-one irreducible
   \(S^{(m,m)}\) carrier, matching/noncrossing bracket bases, Catalan
   dimension, and the unique Segre cubic relation at six points.  It also
   warns that eight points have a skew-cubic singular-locus construction.
2. Ben Howard, John Millson, Andrew Snowden, and Ravi Vakil,
   *The ideal of relations for the ring of invariants of n points on the
   line*, arXiv:0909.3230v1 --- **partial**, abstract, Introduction, and
   Sections 1.2--1.5.  Cache key `arXiv:0909.3230`, SHA-256
   `b9f4cf848b1f2add30cae35fc626cfea1581bb5ad76c608d76317905362f03a0`.
   Used for Kempe generation, the graphical matching formalism, the
   \(S^{(m,m)}\) description of degree one, and the theorem that the
   non-six-point ideals are generated by simple quadrics inherited from
   eight points.
3. Valery Alexeev and David Swinarski, *Nef divisors on
   \(\overline M_{0,n}\) from GIT*, arXiv:0812.0778v2 --- **partial**,
   Introduction and Section 2 through the setup of Lemma 2.2.  Cache key
   `arXiv:0812.0778`, SHA-256
   `4cd66727a1d98c8361c40d977aa45bc14b17a224554f56eafe34a92c4b205f29`.
   Used only for the general morphism from \(\overline M_{0,n}\) to point-
   configuration GIT quotients and its contraction framework.  The exact
   identification of C739's nonreduced Jacobian defect with the ten
   contracted \(3|3\) images is not supplied there.
4. Pavel Turek and Jialin Wang, *Symmetric powers of
   \(S^{(n-1,1)}\) and \(D^{(n-1,1)}\)*, arXiv:2507.15505v1 ---
   **partial**, abstract and Introduction through Theorem 1.3.  Cache key
   `arXiv:2507.15505`, SHA-256
   `7db1e118adb9b86f6823e9638cb204485a67f9af648e8ea24d4d153e51c9c456`.
   This concerns modular symmetric powers and supplies a useful
   characteristic-\(p\) caution, but it is not a predecessor for the exact
   characteristic-zero first-occurrence corollary proved above.
5. Ben Howard, John Millson, Andrew Snowden, and Ravi Vakil,
   *A description of the outer automorphism of \(S_6\), and the invariants
   of six points in projective space*, arXiv:0710.5916v1 --- **full text in
   the inherited C715 audit**, especially Sections 1 and 2.1--2.4.  Cache key
   `arXiv:0710.5916`, SHA-256
   `d2da258cd8513a9b782a8270baa82acc51bc8d552e18db104967c2a08bffebfc`.
   Used here only for the classical outer action and Joubert matching
   coordinates already frozen by C715.
6. Rudolf Mathon and Anne Penfold Street, *Partitions of sets of designs on
   seven, eight and nine points*, DOI
   `10.1016/S0378-3758(96)00066-3` --- **metadata and publisher abstract
   only**.  The abstract confirms that labelled \(SQS(8)\)'s, their
   partitions, and associated design graphs are classical subjects.  It was
   not used to prove the `ej5` orbit or polar calculation, and the full text
   was not accessible in this sweep.

### Verdict

The general matching carrier is classical, not a C739 novelty: Kempe/HMSV
already give bracket generators, the \(S^{(m,m)}\) degree-one module, its
Catalan dimension, and the exceptional Segre cubic at six points.  The
codimension calculation and the general Pfaffian expansion are elementary
repackagings of that skeleton.  Schur averaging of a finite group orbit is
also standard frame theory.

The exact multiplicity-one statement
\(\operatorname{Hom}_{S_{2m}}(\operatorname{Sym}^m A,S^{(m,m)})=k\) is a
short Young-rule corollary in the task's affine formulation; this bounded
sweep did not locate it stated verbatim, but no priority claim is licensed.
Likewise, no consulted source combines the matching carrier with the Golden
conference functional, identifies its six-sister orbit with the Joubert/
syndrome/ETF simplex, proves the Möbius diagonal-congruence pole-descent
obstruction, connects the nonreduced Jacobian scheme to the two boundary
types, or places the order-eight Paley Hafnian orbit beside the HMSV skew
cubic as its 120 self-polar critical lines.  Those are the defensible
task-owned *syntheses*.  The design sweep does show that disjoint
\(SQS(8)\)'s themselves are classical.  Manuscript-safe wording should say
“in the marked Golden construction” and “the bounded search did not locate,”
never “new” or “first.”

## 12. Placement recommendation

No manuscript file was edited.  After C735 reopens placement, the recommended
disposition is:

| result | placement |
|---|---|
| marked lift-rigidity theorem and universal even-order identity | theorem body, immediately after the operator propagation theorem |
| universal (S^{(m,m)}) matching-covariant theorem and order-six hypersurface criterion | conceptual theorem body or a short standalone appendix; this is the deepest general explanation |
| Pfaffian--Hafnian parity twin and 120-line order-eight Paley orbit | research sequel or C718 interface; do not place as a physical bosonic claim |
| disjoint-SQS interpretation and skew-cubic self-polar theorem | order-eight research sequel; it closes the `ej4` incidence question |
| invariant/covariant multiplicity table | compact proof subsection or appendix |
| pole-descent theorem and \(\overline M_{0,6}\) boundary unification | theorem body after the six-point quotient; it explains the C715 inverse fibre |
| reconstruction table and portability criterion | main-text corollary |
| collision filtration and nonreduced Jacobian scheme | appendix theorem; one schematic summary in the body |
| canonical (S_6/F_{20}\cong X\times\mathcal T) return | main-text corollary in the (6\to10) section |
| recognition/anomaly/sextic demonstrations | instruments/examples section |
| detailed character, Singular, and finite-incidence certificates | evidence supplement |
| chamber field, lattice repair, and categorical obstruction table | compressed discussion or deferred synthesis |

## 13. Reproducibility and trust boundary

The task-owned exact evidence is:

- `notes/2026-07-31-c739-representation-audit.py` and JSON certificate;
- `notes/2026-07-31-c739-representation-audit-replay.py`, which independently
  constructs the six synthematic totals and enumerates all 720 permutations;
- `notes/2026-07-31-c739-degeneracy-audit.sing` for the Jacobian and base
  schemes;
- `notes/2026-07-31-c739-order8-hafnian-audit.py` for the Paley matrix,
  Hafnian quartic, stabilizer, orbit, and carrier-rank calculation;
- `notes/2026-07-31-c739-order8-skew-cubic-audit.py` for the two Steiner
  systems, their 120-edge disjointness orbit, the normalized HMSV cubic,
  polar fixed-point identity, and exact Hessian spectrum; and
- `notes/2026-07-31-c739-cycle-audit.py` and JSON certificate for the two
  six-set projections.

Byte counts and SHA-256 hashes for the complete bundle are recorded in
`notes/2026-07-31-c739-golden-cubic-lift-rigidity.sha256`.

From the repository root, replay with

```text
python3 notes/2026-07-31-c739-representation-audit.py --check
python3 notes/2026-07-31-c739-representation-audit-replay.py
nix shell nixpkgs#singular --command Singular -q notes/2026-07-31-c739-degeneracy-audit.sing
python3 notes/2026-07-31-c739-order8-hafnian-audit.py
python3 notes/2026-07-31-c739-order8-skew-cubic-audit.py
python3 notes/2026-07-31-c739-cycle-audit.py --check
```

The character and incidence claims have independent human proofs in this
report; the representation multiplicities additionally have a genuinely
different synthematic-total replay.  The scheme structure uses Singular
4.4.1.  Its reduced-support identification has the independent GIT collision
argument above and the inherited C728 base-scheme replay; no second
computer-algebra system was available for the lower-dimensional nilpotent
structure, so that refinement has one CAS implementation plus the exact
tracked input.

The inherited C704, C715, C716, C720, C727, C728, and C729 reports remain the
proof sources for their frozen identities.  This task makes no new priority
claim and does not enlarge their literature audits.

## 14. `ej` + `tt` closeout and Mystery ledger

- **Settled by `ej`:** the middle-exterior and commutator-Pfaffian formulas
  are one universal even-order coefficient identity.  This sharply isolates
  what order six does and does not explain.
- **Settled by `ej`:** the 36 extremal cuts are not merely the same orbit as
  the outer involutions.  Their Sylow-(5) stabilizer gives a canonical
  product (X\times\mathcal T), closing the projective (36\to6) return.
- **Settled by post-closeout `ej2`:** the Pfaffian/Joubert skew bundle
  globalizes on the six-point quotient, whereas the fixed cross-golden
  (3+3) block globalizes on the universal pole-marked
  (M_{0,7}\to M_{0,6}).  The non-affine diagonal-congruence formula gives
  the exact descent obstruction and identifies C715's free pole as structural
  moduli data.
- **Settled by post-closeout `ej2`:** the common parent of the unequal
  degeneracy schemes is the 25-divisor boundary of
  (overline M_{0,6}), split as (15\Delta_{2|4}+10\Delta_{3|3}), together
  with its GIT contraction and critical Fitting structure.
- **Settled by post-closeout `ej3`:** for every (2m), the unique first
  degree-(m) covariant lands in the Temperley--Lieb/Schur--Weyl carrier
  (S^{(m,m)}), and every commutator Pfaffian is a linear functional on this
  universal matching covariant.  Order six is the unique nontrivial
  hypersurface case and the unique case where the carrier becomes the signed
  outer augmentation module.
- **Settled by post-closeout `ej3`:** the order-ten universal carrier has
  dimension 42, so the 36 extremal cuts cannot constitute a full next
  matching-coordinate frame.  This gives a representation-theoretic
  iteration obstruction independent of the redundancy-four calculation.
- **Settled by the `tt` refinement of `ej3`:** every nonzero matching
  functional has a tight full (S_{2m})-orbit.  The Golden orbit is a regular
  simplex because it has the minimal size (d+1=6) in dimension five and is
  two-transitive; higher-order orbit frames generally have multiple angles.
- **Corrected by `tt` plus the literature sweep:** order six is uniquely the
  nontrivial hypersurface and outer-simplex case, not the only exceptional
  invariant-theory order.  HMSV's order-eight skew cubic and stable quadratic
  relations are the proper next general comparison.
- **Positioned by the literature sweep:** the matching/Specht/Catalan
  skeleton is classical.  The conference-functional synchronization,
  pole-descent obstruction, and boundary/Fitting identification are bounded
  task syntheses with no priority claim.
- **Settled by post-closeout `ej4`:** conference parity exchanges the
  matching statistic.  The symmetric order-six conference matrix produces
  the Pfaffian cubic, while the skew Paley matrix of order eight produces a
  Hafnian quartic whose projective \(S_8\)-orbit is
  \(S_8/PGL_2(7)\), with 120 lines spanning \(S^{(4,4)}\).
- **Bounded by `ej4`:** the order-eight Hafnian is a coordinate functional,
  not HMSV's skew cubic and not yet C718's physical three-boson permanent.
  Their incidence is the next research question, not a proved identification.
- **Settled by post-closeout `ej5`:** each of the 120 Paley lines is the
  difference, up to sign, of one of the 120 unordered disjoint pairs among
  the thirty labelled \(SQS(8)\)'s; the 240 signed vectors orient those
  pairs.  Under invariant self-duality the lines are self-polar fixed points
  of HMSV's cubic polar map, lie outside the cubic, and are nondegenerate
  critical points with tangent signature \((1,12)\).
- **Refined by `ej5`:** the remaining order-eight problem is the arrangement
  cut by the 120 polar hyperplanes on \(M_8\), not incidence of their pole
  points with the singular locus; that incidence is exactly false.
- **Settled by `tt`:** the uniqueness statement must name its target
  representation and equivalence relation.  In that category it is a
  multiplicity-one theorem; without them it is false or undefined.
- **Settled by `tt`:** the “master discriminant” is a filtration, not an
  equality.  The unexpected feature is the nonreduced Jacobian scheme, whose
  defect is concentrated exactly at the ten (3+3) points.
- **Settled:** (mathbf Q(\sqrt5)) and the paired MCM objects come from the
  lift, while (mathbf Q(\sqrt{13})), (11/23), and the hyperbolic lattice
  repair require independent data.
- **Residual evidence boundary:** the nilpotent Jacobian refinement has one
  exact Singular computation but no independent second-CAS replay.  A second
  implementation would improve trust, but the bounded result and stop
  condition are explicit.
- **No genuine mathematical mystery remains in P1, P2, P3, P5, P6, P7, or
  P8.**  P4's only evidence gap is independent replication of its nonreduced
  scheme structure.  The geometric frontier is to extend the pole-marked MCM
  pair over the proper universal stable curve with the correct boundary
  twist and only then compute \(R\pi_*\); no finite-norm shortcut exists.

**Vibe check:** strong positive.  The broad slogan survives in a precise
category, the apparently Golden-only matching mechanism becomes a clean
Pfaffian--Hafnian parity pair, and the previously open 36-to-six return closes
canonically.  The main caution is equally useful: the degeneracies do not
collapse to one scheme, the Jacobian carries subtle nilpotent structure, and
the arrangement induced by the 120 order-eight polar hyperplanes remains a
genuine next problem.
