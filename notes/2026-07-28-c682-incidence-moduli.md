# C682 classical incidence moduli of the \(D_5/S_3\) kernel branches

## Outcome

The two unexplained kernel branches are classical moduli objects, not merely
orbits with familiar stabilizer orders.

Fix the marked icosahedron \(I\), let \(U_I\subset H_3\) be its isotropic
three-plane, and let
\[
 V_I=U_I^\perp
   =\langle q_1,\ldots,q_5\rangle,\qquad
 q_1+\cdots+q_5=0
\]
be its Clebsch four-space. For a point \(z\) of the Bockstein
\(22\)-section, write \(U_z\) for its kernel and \(V_z=U_z^\perp\).

The residual branches have the following interpretation.

| branch | classical marking | common-incidence trace |
|---|---|---|
| \(A_5/D_5\), size \(6\) | one of the six fivefold axes \([a_i]\) of \(I\) | the projective pencil \(\mathbf P(V_I\cap V_z)=E_i\), one member of the exceptional Schläfli six on the Clebsch cubic surface |
| \(A_5/S_3\), size \(10\) | one of the ten pairs of opposite faces, equivalently an unordered pair \(\{\alpha,\beta\}\) of the five plane triples | the single cubic \(\mathbf P(V_I\cap V_z)=[q_\alpha+q_\beta]\), the centered edge point of the Sylvester pentahedron |

Thus the \(D_5\) point is the Bockstein-selected common-axis mate of \(I\),
while the \(S_3\) point is the residual icosahedral parent of the
pair-sum cubic \(q_\alpha+q_\beta\). The latter is **not** the Eckardt
point \(q_\alpha-q_\beta\).

Together with the already understood \(A_5\)-fixed point and five
\(A_4\)-parents, the complete decomposition
\[
 1+5+6+10
\]
is the maximal-subgroup incidence star of a marked icosahedron:
self, tetrahedral markings, fivefold vertex axes, and threefold face
axes.

## Why the branches are honest icosahedra

Hitchin's Grassmannian model has open orbit
\[
 \operatorname{PGL}_2/A_5
\]
parametrizing icosahedra and two boundary orbits. A point of the
two-dimensional boundary orbit has torus stabilizer, and a point of the
closed boundary orbit has Borel stabilizer. In characteristic zero every
finite subgroup of either stabilizer is cyclic. The generic lifts of the
\(D_5\)- and \(S_3\)-branches retain their tame noncyclic stabilizers.
They therefore cannot lie on either boundary orbit. Both branches are
genuine icosahedra in the open moduli orbit.

This matters especially for the \(S_3\) branch: its interpretation is a
second parent, not a degenerate isotropic plane inferred from an orbit
count.

## The \(D_5\) branch: common-axis pencils

A subgroup \(D_5=N_{A_5}(C_5)\) fixes one fivefold rotation axis of \(I\),
that is, one antipodal vertex pair \(\{\pm a_i\}\). An icosahedron fixed
by the same \(D_5\) has that same vertex axis. Hitchin's common-axis
theorem then gives
\[
 V_I\cap V_z
 =
 \left\{
 h_{u,a_i}(x)
 =(u,x)\left((a_i,x)^2-\frac15(a_i,a_i)(x,x)\right):
 (u,a_i)=0
 \right\}.
\]
This is two-dimensional as a vector space. Its projectivization is the
exceptional line \(E_i\) obtained by blowing up the \(i\)-th icosahedral
axis in the plane model of the Clebsch cubic surface.

The six branch points therefore recover the six mutually skew exceptional
lines
\[
 E_1,\ldots,E_6.
\]
Equivalently, they recover one row of the classical Schläfli double-six.
The finite \(22\)-section selects, for each common-axis curve of
icosahedra through \(I\), its unique nonradial \(D_5\)-fixed member.

The exact characteristic-\(11\) check does not infer this from the
stabilizer. For all six kernels it computes
\[
 \dim(V_I\cap V_z)=2,
\]
expresses the resulting line in the \(q_\alpha\)-coordinates, verifies
that the Clebsch cubic vanishes identically on it, and verifies that the
six lines are pairwise skew.

## The \(S_3\) branch: opposite-face pair sums

The stabilizer of an unordered pair \(\{\alpha,\beta\}\) of the five
plane triples is
\[
 (S_2\times S_3)\cap A_5\simeq S_3.
\]
Hitchin identifies the same ten-element \(A_5\)-set with the ten pairs of
opposite faces of the icosahedron. Its invariant axis
\(v_{\alpha\beta}\) joins the two face centers.

On the Clebsch four-space the \(S_3\)-stable pair-sum line is
\[
 m_{\alpha\beta}=q_\alpha+q_\beta.
\]
In the canonical hyperplane coordinates \(\sum y_i=0\), this point has
\[
 y_\alpha=y_\beta=\frac35,\qquad
 y_\gamma=-\frac25\quad
 (\gamma\notin\{\alpha,\beta\}).
\]
Consequently
\[
 \sigma_3(y)=\frac{2}{25},\qquad
 J_0(m_{\alpha\beta})=
 16\sigma_3(y)^2=\frac{64}{625}\ne0.
\]
The incidence cover is therefore etale at this point. One parent is the
fixed icosahedron \(I\); the other is exactly the \(S_3\) kernel branch.
This gives the promised moduli interpretation: it is the face-axis mate
of \(I\) over the centered edge point of the Sylvester pentahedron.

There is an important nearby classical object which is not the answer.
The sign line
\[
 e_{\alpha\beta}=q_\alpha-q_\beta
\]
is one of the ten Eckardt points on the Clebsch cubic surface. It lies on
\(\sigma_3=0\), whereas the pair sum lies off that surface. The exact
certificate distinguishes the two sets projectively and recovers all ten
pair sums, with no difference line among them.

## The maximal-subgroup incidence star

The three conjugacy classes of maximal proper subgroups of \(A_5\) are
\[
 A_4,\qquad D_5,\qquad S_3
\]
of indices \(5,6,10\). For a fixed representative \(H\), the finite
section has exactly two \(H\)-fixed points:
\[
 \mathscr Z^H=\{U_I,U_H\}.
\]
Indeed, \(U_I\) is fixed by all of \(A_5\), the orbit \(A_5/H\) contributes
one point because \(H\) is self-normalizing, and maximality excludes fixed
points in either of the other two coset orbits.

This turns the four-orbit quotient into a genuine incidence moduli
construction:

```text
marked icosahedron I
  ├─ 5 tetrahedral/A4 mates
  ├─ 6 common-vertex-axis/D5 mates
  └─ 10 opposite-face-axis/S3 mates.
```

On the five Clebsch labels, the six \(D_5\)'s are the six unoriented
pentagonal cyclic orders and the ten \(S_3\)'s are the ten edges
\(\{\alpha,\beta\}\). Their ordinary vertex--face incidence is the
\((6_5,10_3)\) configuration: a pentagon has five sides, and each edge
occurs in three of the six pentagons. This is the classical combinatorial
shadow of the same Petersen ten-pair carrier. The present theorem does
not claim that this \(6\)-by-\(10\) incidence is itself cut out by a new
bilinear equation on the kernel section.

## Exact evidence

The primary checker reconstructs every rank-four operator from the
committed ten-pair pencil, recomputes its kernel and apolar annihilator,
and then checks:

- common-annihilator dimensions \(2\) on all six \(D_5\) points and \(1\)
  on all ten \(S_3\) points;
- the Clebsch cubic restriction is identically zero on every \(D_5\)
  projective line;
- the six \(D_5\) lines are pairwise skew;
- the ten \(S_3\) lines are exactly
  \(\{[q_\alpha+q_\beta]:\alpha<\beta\}\);
- none is an Eckardt difference \([q_\alpha-q_\beta]\); and
- every pair-sum cubic has nonzero Clebsch cubic value.

The independent replay does not import the operator or matrix-module code.
It starts from the stored kernel RREFs, reimplements finite-field
elimination and the sixth apolar form, and recovers the same six lines and
ten points.

From `rust/`, run

```text
python3 ../notes/2026-07-28-c682-incidence-moduli.py --check
python3 ../notes/2026-07-28-c682-incidence-moduli-replay.py
```

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-28-c682-incidence-moduli.py` | 8851 | `439013e602e674c7d41259642e091d528f6997fa0f7791e4a7b41f4520f05454` |
| `2026-07-28-c682-incidence-moduli-replay.py` | 5496 | `8568839358741f1d70b78a9def3eaae807246a86b5ae9b4b9e87354a63ed2b56` |
| `2026-07-28-c682-incidence-moduli.json` | 11719 | `9585e3d47fcbed1eea91c8259cb22c5e5928390f6f4a97b67490d682e572b15c` |

The characteristic-zero interpretation uses Hitchin's human theorems; the
finite certificate does not formalize them.

## Source depth and claim boundary

The classical inputs were checked against:

- Nigel Hitchin, *Spherical harmonics and the icosahedron*,
  arXiv:0706.0088, cached SHA-256
  `33cb8b2e5b7102c0adaeb1c00af1e8d1702f5fd086fa1abfddb739c149d05eeb`:
  Sections 4--5 for the exceptional lines and opposite-face/Eckardt
  geometry, Proposition 7 for the common-axis pencil, and Section 11 for
  the \(S_3\) opposite-face axis;
- Nigel Hitchin, *Vector bundles and the icosahedron*,
  arXiv:0906.4208, cached SHA-256
  `7da4fb227846551a788821d2a6f8082aa4e75088d34633934ba34c4e7f59b722`:
  Sections 5--6 for the open icosahedron orbit and the two boundary
  stabilizer types, and the common-vertex curves through the basepoint.

No novelty claim is made. The contribution of this task is the exact
identification of C682's two residual kernel orbits with those classical
incidence objects, including the non-obvious sum-versus-difference
distinction on the \(S_3\) branch. This does not reopen Paper III.

## `ej` + `tt` closeout and mystery ledger

- **Closed:** the six \(D_5\) points are common-fivefold-axis mates, and
  their traces are the exceptional Schläfli six \(E_1,\ldots,E_6\).
- **Closed:** the ten \(S_3\) points are opposite-face-axis mates over the
  pair-sum cubics \(q_\alpha+q_\beta\).
- **Settled by `ej`:** the tempting Eckardt interpretation is adjacent but
  wrong. Eckardt points are the sign lines \(q_\alpha-q_\beta\); the
  kernel branches select the trivial pair-sum lines off the branch cubic.
- **Settled by `tt`:** stabilizer labels become moduli only after the
  boundary-orbit exclusion and the common-annihilator calculation. Both
  steps are necessary.
- **Closed by the portfolio pass:** the complete \(1+5+6+10\) section is
  the maximal-subgroup incidence star of a marked icosahedron, with the
  \(D_5/S_3\) indices carrying the classical
  \((6_5,10_3)\) pentagon--edge incidence.
- **Still open:** construct a single characteristic-zero correspondence
  whose three residual components produce the \(A_4,D_5,S_3\) mates
  without referring to the characteristic-\(11\) Bockstein section.
- **Still open:** decide whether the complementary Schläfli six
  \(E_i'\) is produced by a natural conjugate/operator branch or only by
  the classical outer automorphism of the Clebsch surface.
- **Still open:** find an intrinsic equation on the kernel section that
  realizes the \((6_5,10_3)\) incidence rather than importing it from the
  subgroup/pentagon model.

C682 remains open; completion is the user's decision.
