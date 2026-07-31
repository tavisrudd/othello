# C720 frozen operator interface for C727

**Lane:** `golden`

**Date:** 2026-07-31

**Status:** frozen dependency interface; C720 remains active

## Purpose

This note freezes the forward theorem that C727 may import.  It is stated on
a fully marked golden conference presentation.  C727 owns every question
about descent from Paper I's coarser syndrome data, including switching,
permutation, orientation, projective-scaling, and golden-conjugation
torsors.  Nothing below asserts that an unlabelled syndrome locus supplies
or canonically removes those marks.

## Marked input

Work over a characteristic-zero field (k), and put
(k_5=k(\sqrt5)).  A **fully marked golden presentation** consists of:

1. a labelled six-set (X), an orientation of (k^X), and its augmentation
   space (A_X=k^X/k\mathbf1);
2. the outer six-set \(\mathcal T\), with its coherent signed outer
   (S_6)-action;
3. the coherently oriented family of symmetric zero-diagonal sign matrices
   \((C_T)_{T\in\mathcal T}\) satisfying (C_T^2=5I);
4. a choice of (\sqrt5) and compatible orientations of the two golden
   determinant lines when a signed cross-golden determinant is required.

The orientation in item 3 is the common sign of the Joubert/Pfaffian
family, not an assertion that this sign descends from an unlabelled input.
The last item is unnecessary for the rational Pfaffian and determinant
formulas but is necessary to name one of the two golden eigenspaces, one
rank-one MCM summand, or one small resolution.

In particular, Paper I's recovery of one conference switching class is not
silently identified with item 3.  C727 must prove whether that class and its
recovered outer carrier canonically generate the coherent six-family, or
record the additional marking needed to do so.

## Frozen theorem: marked golden operator propagation

For (x\in A_X), let (D_x=\operatorname{diag}(x)), and for each
(T\in\mathcal T) put

\[
 K_T=*\!\bigwedge^3 C_T,
 \qquad
 Z_T(x)=\frac14\sum_{|S|=3}(K_T)_{SS}x_S,
 \qquad
 A_T(x)=[D_x,C_T].
\]

Then the following statements hold simultaneously and compatibly with
isomorphisms of fully marked presentations.

### 1. Exterior, cubic, and polar shadows

The six cubics form the signed outer-standard Joubert vector and satisfy

\[
 gZ_T=\operatorname{sgn}(g)Z_{gT},\qquad
 \sum_TZ_T=0,\qquad \sum_TZ_T^3=0.
\]

Thus (Z=(Z_T)_T) lands on the Segre cubic.  Its projective polar is
represented by

\[
 W_T=Z_T^2-\frac16\sum_UZ_U^2,
\]

and satisfies

\[
 \sum_TW_T=0,
 \qquad
 \left(\sum_TW_T^2\right)^2=4\sum_TW_T^4.
\]

Hence centered squaring sends the signed Segre family to the ordinary
outer-standard Igusa quartic family and forgets the common sign of (Z).

### 2. Pfaffian, determinant, and Cartan shadows

The same cubic and polar coordinates are operator invariants:

\[
 \boxed{\operatorname{Pf}A_T(x)=4Z_T(x)},\qquad
 \boxed{\det A_T(x)=16Z_T(x)^2},\qquad
 W_T=\frac1{16}\operatorname{center}_T\det A_T(x).
\]

The restriction of the Cartan (E_6) cubic to
((0,0,A_T(x))) is precisely this Pfaffian.  This is a literal linear
Pfaffian section, not an identification of the binary-polyhedral and Lie
exceptional parents.

### 3. Golden determinant, adjugate, and categorical shadows

Over (k_5), set

\[
 P_{T,\pm}=\frac12\left(I\pm\frac{C_T}{\sqrt5}\right),
 \qquad
 B_T(x)=P_{T,-}D_xP_{T,+}:V_{T,+}\longrightarrow V_{T,-}.
\]

After the determinant-line orientation in the marked input is chosen,

\[
 Z_T(x)=\epsilon_T10\sqrt5\det B_T(x),
 \qquad
 Q_T(x)=\epsilon_T10\sqrt5\operatorname{adj}B_T(x),
\]

and

\[
 B_TQ_T=Q_TB_T=Z_T I_3.
\]

This linear--quadratic matrix factorization gives the two kernel-incidence
small resolutions, the conjugate rank-one Ulrich/MCM sheaves, and their
rational rank-two descent with an endomorphism squaring to (5I).  Golden
conjugation exchanges (V_+) and (V_-), transposes (B_T), and exchanges
the two resolutions and rank-one sheaves.

The assembled differential adjugate is part of the same frozen interface.
Let (G_x(e_T)=dZ_T|_x), pass to the two augmentation quotients, and write
the resulting (5\times5) quadratic matrix as (\mathsf A(x)).  With

\[
 \widehat W_T=6Z_T^2-\sum_UZ_U^2,
 \qquad
 q_i=6x_i^2-\sum_jx_j^2,
\]

in the frozen quotient bases of C705,

\[
 \boxed{\operatorname{adj}\mathsf A(x)=6\widehat W(x)q(x)^{\mathsf T}}.
\]

Thus the Igusa polar line is also the left rank-one factor of the assembled
cross-golden adjugate construction.

### 4. Slater, Majorana, pure-spinor, and anomaly shadows

For orthonormal golden frames (Q_{T,\pm}), the postselected transfer block

\[
 \mathcal K_T(x)=Q_{T,-}^{\mathsf T}D_xQ_{T,+}
\]

satisfies

\[
 \det(\mathcal K_T(x)^{\mathsf T}\mathcal K_T(x))
 =\frac{Z_T(x)^2}{500}.
\]

It is the three-fermion Slater success probability.  Meanwhile (A_T(x))
is the coefficient matrix of the canonical six-Majorana family,

\[
 \widehat H_T(x)=\frac{i}{4}\sum_{i,j}A_T(x)_{ij}\gamma_i\gamma_j,
 \qquad \{C_T,A_T(x)\}=0.
\]

Its gap-closing and parity wall is (Z_T=0); after a Majorana-frame
orientation is chosen, its class-D parity is \(\operatorname{sgn}Z_T\).
The principal Pfaffians of each (A_T(x)) give one pure-spinor big cell.
The six cells form a synchronized five-parameter product with top
coordinates (4Z_T).  The Segre equations come from golden
synchronization, not from Wick identities alone.

The same vector (Z(x)) obeys the six-charge (U(1)) anomaly equations

\[
 \sum_TZ_T=\sum_TZ_T^3=0.
\]

This is an exact arithmetic realization of the anomaly variety, not a
construction of a gauge theory and not an identification of interferometer
modes with Weyl fields.

### 5. Order-six rigidity and the six-sister syndrome

For any symmetric zero-diagonal (6\times6) sign matrix (B), the following
are equivalent:

1. every (3|3) cut has determinant-matching signs split (5{:}1);
2. every (3\times3) cross determinant has absolute value (4);
3. (B^2=5I);
4. after switching (B_{0i}=1), the negative internal edges form a
   five-cycle.

The twelve oriented normalized solutions pair under global negation into
six projective frustration fingerprints, canonically
(\operatorname{Syl}_5(A_5)\cong A_5/D_5).  Their ten-cut sign words
(r_T\in\{\pm1\}^{10}) satisfy

\[
 \langle r_T,r_U\rangle=
 \begin{cases}10&T=U,\\-2&T\ne U,\end{cases}
 \qquad RR^{\mathsf T}=12I_6-2J_6.
\]

Thus they form a distance-six regular simplex code.  The relative matching
signs recover the conference switching class only up to global negation;
they do not recover the Pfaffian orientation.  Universal cut extremality is
an order-six theorem, not a general conference-matrix law.

## Covariance facts C727 may use

These are formula-level covariance facts, not descent verdicts.

| change of marked presentation | frozen effect |
|---|---|
| axis permutation | transports all matrices and variables; the (Z)-family carries the signed outer action |
| diagonal vertex switching | conjugates (A_T(x)); its Pfaffian changes by the frame-orientation character and its determinant is fixed |
| common orientation reversal (C_T\mapsto-C_T) | negates (Z) and every Pfaffian, fixes (Z^2), (W), determinants, and probabilities |
| (x\mapsto x+c\mathbf1) | fixes every commutator and all downstream operator shadows |
| (x\mapsto\lambda x) | scales (Z) by (\lambda^3) and (W) and determinant shadows by (\lambda^6) |
| golden conjugation | exchanges (P_+\leftrightarrow P_-), transposes the cross block, and exchanges the paired resolutions/MCM summands |

C727 must turn this table into an action-and-stabilizer proof on the exact
Paper I recovery classes.  In particular, this note does not decide whether
the determinant square, cubic line, or centered-square polar globally
recovers the source switching class.

## Frozen output inventory for C727

| output family | object supplied on marked input | source package | C727 question |
|---|---|---|---|
| middle exterior/Joubert | signed six-vector of cubic forms (Z) and its projective cubic line | C704 | orientation cover and reverse recovery |
| Segre--Igusa | Segre point and centered-square polar (W) | C704/C705 | precise information loss, especially (W=0) |
| commutator | Pfaffian cubic and determinant sextic | C704/C709 | oriented line versus unmarked square; reverse faithfulness |
| cross-golden | determinant, adjugate factorization, paired resolutions and MCM objects | C704/C705 | golden-conjugate pair versus selected summand |
| Cartan | literal Pfaffian linear section | C704 | descent of the section, not of an ambient exceptional marking |
| Slater | oriented amplitude and squared success probability | C707 | phase/gauge class versus probability invariant |
| Majorana | labelled Hamiltonian family and parity wall | C709 | Majorana gauge and frame orientation |
| synchronized spinors | six-cell synchronized product | C720 | descent of synchronization data; no single-spinor parent claim |
| anomaly | projective six-charge solution (Z) | C707 | permutation, scale, and overall-sign quotient |
| dimer/syndrome | unoriented switching line and six distance-six fingerprints | C720 | whether this supplies a split recovery map from Paper I data |

The C705 exceptional parents, C706 Clifford lift, C708 doily/bad-prime
refinements, and C710 lattice obstruction and hyperbolic repair remain in
the Golden paper inventory but are not arrows of this central theorem.
C727 may admit one only after exhibiting an explicit functor from the
recovered equivalence class.  Contextual kinship is insufficient.

## Novelty and trust boundary

Classical inputs are the Joubert covariant, Segre cubic, centered-square
Segre--Igusa polarity, standard determinantal cubic geometry, and the
standard Pfaffian, Slater, Majorana-parity, and anomaly equations.  The
paper-owned synthesis is the common marked operator source, its exterior
and cross-golden lifts, the literal commutator and Cartan identities, the
assembled adjugate factorization, the synchronized physical realizations,
and the order-six frustration characterization.  The existing audits do
not license a priority claim for the entire synthesis.

The conceptual arrows have human proofs in the C704--C710 companions and
the C720 discriminator report.  Exact computation checks normalizations,
finite orbit statements, and the order-six classification; it is not the
proof of functorial propagation.  C727 may cite this theorem as a frozen
input and must record any correction as an explicit erratum rather than
silently changing the source object during its descent audit.

## Gate verdict

The operator dependency required by C727 is **frozen and passed**.  C720 is
not complete: its remaining acceptance work is the full C704--C710 result
placement, section architecture, novelty matrix, proof/trust plan, and
paper-root go/no-go decision.  Paper III remains unchanged and outside the
Golden write surface.

## `ej` + `tt` closeout and mystery ledger

- **Settled by `ej`:** the determinant square is not merely an
  orientation-free byproduct; over a characteristic-zero polynomial ring it
  is the cheapest candidate for a reverse-faithful shadow because its square
  root recovers the cubic line up to scalar and sign.  C727 owns the exact
  cubic-to-two-graph descent proof.
- **Settled by `tt`:** the source of the forward theorem must be the coherent
  outer six-family, not an ambiguously named single matrix.  The gap between
  Paper I's recovered conference class and this family is now an explicit
  first gate of C727 rather than a suppressed identification.
- **Settled by `tt`:** exceptional-parent, Clifford/doily, and lattice
  relatives are excluded from the central theorem unless C727 supplies an
  actual functor from the recovered class.
- **Open, owned by C727:** determine whether the coherent outer family
  descends from Paper I's coarsest sufficient input and identify the exact
  residual orientation and golden torsors.
- **Open, owned by C727:** prove reverse faithfulness of the cubic line or
  determinant square, and locate the first exact loss of information for the
  centered-square map, with the balanced (W=0) layer as the first test.
- **No genuine mystery remains in the fully marked forward formulas.**  The
  remaining uncertainty is quotient descent and reverse recovery, exactly
  the successor's scope, plus C720's still-open editorial architecture.
