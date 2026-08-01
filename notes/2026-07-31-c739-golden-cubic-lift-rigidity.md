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

## 11. Placement recommendation

No manuscript file was edited.  After C735 reopens placement, the recommended
disposition is:

| result | placement |
|---|---|
| marked lift-rigidity theorem and universal even-order identity | theorem body, immediately after the operator propagation theorem |
| invariant/covariant multiplicity table | compact proof subsection or appendix |
| reconstruction table and portability criterion | main-text corollary |
| collision filtration and nonreduced Jacobian scheme | appendix theorem; one schematic summary in the body |
| canonical (S_6/F_{20}\cong X\times\mathcal T) return | main-text corollary in the (6\to10) section |
| recognition/anomaly/sextic demonstrations | instruments/examples section |
| detailed character, Singular, and finite-incidence certificates | evidence supplement |
| chamber field, lattice repair, and categorical obstruction table | compressed discussion or deferred synthesis |

## 12. Reproducibility and trust boundary

The task-owned exact evidence is:

- `notes/2026-07-31-c739-representation-audit.py` and JSON certificate;
- `notes/2026-07-31-c739-representation-audit-replay.py`, which independently
  constructs the six synthematic totals and enumerates all 720 permutations;
- `notes/2026-07-31-c739-degeneracy-audit.sing` for the Jacobian and base
  schemes; and
- `notes/2026-07-31-c739-cycle-audit.py` and JSON certificate for the two
  six-set projections.

Byte counts and SHA-256 hashes for the complete bundle are recorded in
`notes/2026-07-31-c739-golden-cubic-lift-rigidity.sha256`.

From the repository root, replay with

```text
python3 notes/2026-07-31-c739-representation-audit.py --check
python3 notes/2026-07-31-c739-representation-audit-replay.py
nix shell nixpkgs#singular --command Singular -q notes/2026-07-31-c739-degeneracy-audit.sing
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

## 13. `ej` + `tt` closeout and Mystery ledger

- **Settled by `ej`:** the middle-exterior and commutator-Pfaffian formulas
  are one universal even-order coefficient identity.  This sharply isolates
  what order six does and does not explain.
- **Settled by `ej`:** the 36 extremal cuts are not merely the same orbit as
  the outer involutions.  Their Sylow-(5) stabilizer gives a canonical
  product (X\times\mathcal T), closing the projective (36\to6) return.
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
  P8.**  P4's only open item is independent replication of its nonreduced
  scheme structure, not identification of its support or components.

**Vibe check:** strong positive.  The broad slogan survives in a precise
category, the apparently Golden-only Pfaffian mechanism becomes a clean
even-order theorem, and the previously open 36-to-six return closes
canonically.  The main caution is equally useful: the degeneracies do not
collapse to one scheme, and the Jacobian carries subtle nilpotent structure.
