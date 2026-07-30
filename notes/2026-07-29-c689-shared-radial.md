# C689: shared alternating-cycle radial nonvanishing

**Lane**: `clebsch`

**Date**: 2026-07-29

## Verdict

The \(B_3\) common-secant square and the \(H_3\) second-trace scalar are
specializations of one geometric construction.  They are not essentially
different witnesses.

Each sheet is a one-factorization.  Therefore every endpoint edge \(e\)
selects a unique matching \(M_+(e)\) in the positive sheet and a unique
matching \(M_-(e)\) in the negative sheet.  In both \(B_3/\mathbb F_7\)
and \(H_3/\mathbb F_{11}\):

1. the selected matchings share exactly \(e\);
2. after removing \(e\), their union is one alternating Hamilton cycle on
   the other \(q-1\) endpoints; and
3. after moving \(e\) to \(\{0,\infty\}\), the two complementary matchings
   have the same torus normal form with parameters \(c,c^{-1}\), where
   \[
   c^2=\frac14,\qquad c^{-2}=4,\qquad
   \operatorname{ord}_{\mathbb F_q^\times}(4)=\frac{q-1}{2}.
   \]

The radial nonvanishing follows from one square-root resultant/Dickson
recurrence for this alternating-cycle exchange.  The old q=7 and q=11
scalars are consequences and independent corroboration, not premises.
This is a strictly v2 conceptual compression and does not alter or hold
Paper II v1.

## Canonical cross-sheet geometry

Let \(\mathcal F_+,\mathcal F_-\) be the two one-factorization sheets.
Their cross-incidence matrix
\[
 A_{MN}=|M\cap N|,\qquad
 M\in\mathcal F_+,\quad N\in\mathcal F_-,
\]
is a \(0/1\) symmetric-design matrix.  Its parameters are
\[
\begin{array}{c|c|c}
q&(v,k,\lambda)&AA^{\mathsf T}\\ \hline
7&(7,4,2)&2(I+J),\\
11&(11,6,3)&3(I+J).
\end{array}
\]
Thus every cross pair shares zero or one edge; every edge gives one
incident cross pair; and any two matchings in one sheet meet respectively
two or three opposite-sheet matchings in common.  This is the shared
one-factorization incidence tensor suggested in the C689 starting seam.

It is also a perfect pairing in the defining characteristic.  Since
\(J^2=qJ=0\) over \(\mathbb F_q\) and
\(\lambda=(q+1)/4=1/4\), one has
\[
 A^{-1}=4A^{\mathsf T}(I-J).                   \tag{I}
\]
Thus the canonical cross-sheet incidence tensor loses no sheet direction.
Formula (I) is a structural consequence of the common design, not another
finite scalar witness.

There is a sharper identification.  Label both sheets by the regular
translation subgroup \(C_q\).  Then \(A\) is circulant:
\[
 A_{ij}=1_D(j-i)
\]
for a difference set \(D\subset\mathbb F_q\).  After an affine relabeling,
\[
 D=\{0\}\cup Q_0.
                                                        \tag{P}
\]
Thus the cross-incidence design is precisely the complement of the Paley
difference-set design.  At q=7 this is the complement of the Fano plane;
at q=11 it is the complement of the Paley \(2\!-\!(11,5,2)\) biplane.
The design parameters and inverse (I) now follow from the quadratic-
residue difference identity.

Writing
\[
 H=2A-J
\]
gives row sum \(1\) and
\[
 HH^{\mathsf T}=(q+1)I-J.
\]
Consequently the bordered sign matrix
\[
 \widehat H=
 \begin{pmatrix}
 -1&\mathbf1^{\mathsf T}\\
 \mathbf1&H
 \end{pmatrix}
 \quad\text{satisfies}\quad
 \widehat H\widehat H^{\mathsf T}=(q+1)I.       \tag{H}
\]
Thus C689's two cross-incidence tensors canonically complete to the Paley
Hadamard matrices of orders eight and twelve.  This is the direct
incidence-level bridge to the signed Hadamard/Gale self-duality already
present in Paper II.

The unbordered core contains still more structure.  In the Paley
normalization, \(-1\) is nonsquare, so exactly one of \(j-i\) and \(i-j\)
is a nonzero square.  Hence
\[
 H+H^{\mathsf T}=2I.
\]
Putting \(S=H-I\) gives the exact skew operator
\[
 S^{\mathsf T}=-S,\qquad S^2=-qI+J.            \tag{C}
\]
On the augmentation hyperplane \(J=0\), this becomes
\[
 S^2=-qI.
\]
Equivalently, the two nontrivial Fourier eigenvalues of the incidence
operator are
\[
 \frac{1+\sqrt{-q}}2,\qquad
 \frac{1-\sqrt{-q}}2.                         \tag{F}
\]
Thus the cross-sheet incidence tensor carries a canonical quadratic
orientation operator—a square root of \(-q\)—before any matching quotient
or cubic is formed.

Fix an edge \(e\).  The unique incident pair is invariant under its
construction, and its complementary alternating cycle is the geometric
object whose radial projection is being tested.  The two types first
diverge only in the cycle length: six for \(B_3\), ten for \(H_3\).

## Alternating-cycle normal form

Move \(e\) to \(\{0,\infty\}\), so its secant is \(Y\).  Put
\[
 n=\frac{q-1}{2},\qquad Q_0=\{u^2:u\in\mathbb F_q^\times\}.
\]
The two complementary matchings are
\[
 \{\{u,cu\}:u\in Q_0\},\qquad
 \{\{u,c^{-1}u\}:u\in Q_0\}.
\]
Their ratio is \(c^{-2}=4\).  Since \(4\) has order \(n\), their union is
one alternating \(2n=q-1\) cycle rather than a disjoint union of shorter
cycles.

In the Paley normalization (P), this is no coincidence: multiplication by
\(4\) preserves \(Q_0\), and for q=7 and q=11 it is transitive on the
nonzero squares.  The complementary cycle alternates between \(Q_0\) and
\(cQ_0\) while advancing by this Paley multiplier.  Hence the parameter
\(4\), the Hamilton-cycle property, and the cross-incidence design are
three faces of the same quadratic-residue geometry.

Write the complementary matching product as
\[
 A_c(X,Y,Z)=
 \prod_{u\in Q_0}
 \bigl(cu^2X-(1+c)uY+Z\bigr).
                                                        \tag{A}
\]
Both full matching products have the common factor \(Y\).  Because their
restrictions to the conic agree,
\[
 A_{c^{-1}}-A_c=(XZ-Y^2)\Psi_c.              \tag{B}
\]
The original cross-sheet quotient is therefore \(Y\Psi_c\), up to the
fixed sign convention.

## One Dickson recurrence

Let
\[
 h_j=\frac{n}{n-j}\binom{n-j}{j}.
\]
The roots of \(u^n-1\) are exactly \(Q_0\).  Factoring each quadratic in
(A) over its two roots and taking the resultant with \(u^n-1\) gives
\[
 A_c=c^nX^n+Z^n
 -\sum_{j=0}^{(n-1)/2}
 (-1)^jh_jc^j(1+c)^{n-2j}
 (XZ)^jY^{n-2j}.                              \tag{D}
\]
Here \(c\) is nonsquare, so \(c^n=-1\).  Moreover
\[
 1+c^{-1}=\frac{1+c}{c}.
\]
Subtracting the two instances of (D) yields the single closed formula
\[
 A_{c^{-1}}-A_c
 =
 2\sum_{j=0}^{(n-1)/2}
 (-1)^jh_jc^j(1+c)^{n-2j}
 (XZ)^jY^{n-2j}.                              \tag{E}
\]
No matching-specific scalar enters (E).

For \(q=7\), formula (E) has weight coefficients \((2,5)\).  Division by
\(XZ-Y^2\) gives
\[
 \Psi_c=5Y\ne0.
\]
For \(q=11\), the same formula has coefficients \((9,1,1)\), giving
\[
 \Psi_c=2Y^3+XZY,\qquad
 (4\partial_X\partial_Z-\partial_Y^2)\Psi_c=3Y\ne0.
\]
These are two specializations of the same resultant recurrence, not two
independent radial premises.

In general the full radial contraction of \(Y\Psi_c\) is, up to a
nonzero factorial below the characteristic, the apolar pairing of the
common secant \(Y\) with the deepest trace of \(\Psi_c\).  A secant has
nonzero dual conic norm.  The displayed nonzero linear traces therefore
force the existing radial Fischer component in both types.

## Recovery of the old witnesses

The q=7 pair
\[
\{02,14,3\infty,56\},\qquad
\{02,15,34,6\infty\}
\]
is exactly the incident cross pair selected by the common edge \(02\).
Its complementary edges form the six-cycle above.  Returning from torus
coordinates recovers
\[
\Phi=3L_{02}^2,\qquad \Delta_Q\Phi=4.
\]

The q=11 pair
\[
\{01,25,37,49,68,10\infty\},\qquad
\{01,2\infty,38,46,59,7\,10\}
\]
is the incident pair selected by \(01\).  Its complementary edges form
the ten-cycle, and the same recurrence recovers
\[
\Delta_Q^2\Phi=10=\Delta_Q^2(Q^2).
\]

The primary replay checks all 28 q=7 and all 66 q=11 edge-selected pairs.
Within each field the full radial scalar is constant on every incident
pair: \(4\) at q=7 and \(10\) at q=11.  It also checks the old displayed
pairs verbatim.

## Common hypotheses and first divergence

The genuinely common inputs are:

- two \(\operatorname{PSL}_2(q)\)-transitive one-factorization sheets;
- the unique incident cross pair through each endpoint edge;
- a single alternating complementary cycle;
- the \(c\leftrightarrow c^{-1}\) torus normal form with \(c^{-2}=4\);
- the conic relation \(XZ-Y^2\);
- the square-root resultant (D); and
- nondegeneracy of the common secant under the apolar conic pairing.

The types first diverge at \(n=3\) versus \(n=5\).  Consequently the
cofactor has degree one versus three, the deepest trace uses zero versus
one Laplacian, the cross designs are \(2\!-\!(7,4,2)\) versus
\(2\!-\!(11,6,3)\), and the top harmonic dimensions are five versus nine.
None of these differences changes the nonvanishing mechanism.

## Reproducibility

From the repository root:

```text
python3 notes/2026-07-29-c689-shared-radial.py --check
python3 notes/2026-07-29-c689-shared-radial-independent.py --check
sha256sum -c notes/2026-07-29-c689-shared-radial.sha256
```

The primary replay reconstructs both projective groups, both matching
orbits, both one-factorization sheets, all cross-incidence data, every
edge-selected alternating cycle, the conic quotients, and their apolar
traces.  It also verifies the square-root resultant coefficients against
direct secant-product multiplication.

The independent replay does not construct a group, orbit, matching, or
ternary polynomial.  It starts from (E), divides the one-variable
weight polynomial by \(x-1\), and applies an independently implemented
weight-zero Laplacian recurrence.  It obtains the same nonzero deepest
traces and checks the symmetric-design identities.

| file | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-29-c689-shared-radial.py` | 16347 | `c24e1396d18753f846fdd6cbf5c897e370758a95887542f929ae0f2280db947d` |
| `notes/2026-07-29-c689-shared-radial-independent.py` | 3959 | `9984c8245ab076ea4504e0b24def98ddb99b05ec291542ef73ca6f70fb1a698e` |
| `notes/2026-07-29-c689-shared-radial.json` | 6354 | `be9663e34429ee4f9cea815e838be671f7de734f14168fdd074b92e81d9af494` |

Pinned load-bearing inputs:

| file | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-26-c665-balanced-matching-completeness.py` | 12821 | `30428d78291930c00a1dc9ed7146f7714eaa86b438110535dd4dbc985b782b04` |
| `notes/2026-07-20-c406-matching-module.py` | 48589 | `a1fef3680a7d12d64a1c483e7032cbaa3a1f575883b2bd8b964d58aa8ac38d51` |
| `notes/2026-07-25-c616-h3-equivariant-rank.json` | 4381 | `cd1ecd1e5f467269d2b05bd109800aa8f48c11b7a178668a5555e951c049baa0` |

The computation corroborates the human resultant proof.  It is not a
finite search standing in for (D)--(E).  This report makes no literature
absence or priority claim.

## Evidence boundary

The prior balanced-orbit theorem supplies the classification and the
one-factorization sheets.  C689 proves a shared mechanism only for those
two classified configurations; it does not assert that every pair of
one-factorizations has the \(c^{-2}=4\) normal form.  The normal-form
identification comes from their common edge construction and is checked
for every edge by equivariance and exact replay.

The nonvanishing proof is formula (E), division by the conic relation, and
the apolar trace-product identity.  The historical scalars \(4,10\) are
not used to establish it.

## Extra juice and Tao closeout

The stronger residue is the cross-incidence design.  The two sheets are
not merely parallel one-factorizations: their incidence tensors are the
symmetric designs \(2\!-\!(7,4,2)\) and \(2\!-\!(11,6,3)\).  This makes
the common-edge construction canonical and explains why it has exactly
one complementary cycle orbit in each type.  Its explicit inverse (I)
also gives a reusable perfect sheet-to-sheet pairing for any later
Gorenstein formulation.

The further free identification is Paley: translation coordinates turn
the tensor into the circulant complement of the quadratic-residue
difference set.  This removes the last unexplained appearance of \(4\):
it is the square multiplier generating the nonzero Paley orbit in both
fields.  The bordered completion (H) additionally identifies the exact
Hadamard carrier behind the signed sheet geometry; no coordinate quotient
calculation is needed for that consequence.

At second order, the skew core (C) shows that the same carrier already
contains an orientation operator on the augmentation module.  This is a
precise possible bridge to Paper II's cubic-first orientation: the
quadratic sheet incidence supplies the conjugate eigenspaces (F), while
the cubic may choose their ordering.  C689 does not claim that this alone
derives the orientation cubic; establishing that identification would
require comparing \(S\)'s eigenspace choice with the paper's signed cubic
tensor.

The Tao boundary is the parameter relation \(c^{-2}=4\).  It is a property
of the two classified exceptional configurations, not a consequence of
abstract one-factorization axioms.  Formula (E) is uniform after that
geometric input.  Promoting (E) to arbitrary factorization pairs would
require a separate classification of their torus parameters and is not a
C689 claim.  Likewise, perfectness of (I) does not by itself imply radial
nonvanishing; the resultant identity (E) is still the map connecting the
incidence geometry to the Fischer projection.

## Mystery ledger

| feature | status | exact remaining gate |
|---|---|---|
| q=7 common-secant square | settled as the six-cycle instance of (E) | none |
| q=11 second trace | settled as the ten-cycle instance of (E) | none |
| shared geometric object | settled: unique cross-sheet pair through an edge and its complementary Hamilton cycle | none |
| shared nonvanishing mechanism | settled by the square-root resultant and deepest apolar trace | none |
| old scalars \(4,10\) | recovered as coordinate specializations | none |
| cross-sheet incidence | settled as the two symmetric designs with explicit perfect pairing (I) | none |
| Paley structure | settled: the translation-circulant support is affinely \(\{0\}\cup Q_0\) | none |
| signed Hadamard carrier | settled by the bordered Paley matrix (H), of orders eight and twelve | none |
| quadratic orientation operator | settled by the skew core \(S^2=-qI\) on augmentation | comparison with the cubic orientation is a possible later v2 bridge, not a C689 obligation |
| parameter \(4\) | settled as the generator of the nonzero Paley orbit in both classified configurations; not abstractly universal | no C689 gap |

No genuine C689 mystery remains.  Extending the alternating-cycle
recurrence beyond the two classified balanced orbits would be a different
theorem and is not needed for Paper II v2.

Vibe check: the two residual scalars were shadows of one canonical
alternating-cycle exchange; the v2 theorem now ends in geometry rather
than a pair of unrelated calculations.
