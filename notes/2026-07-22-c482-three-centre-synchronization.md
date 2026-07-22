# C482 — multi-centre gauge synchronization

**Lane:** `reed-solomon`

**Date:** 2026-07-22

**Status:** complete, with the proposed rational-inverse gate disproved and replaced by the exact
generic quadratic reconstruction theorem.

## Result

Let a labelled six-arc and `r` labelled deep projection centres be considered modulo `PGL_3`, and
let `Phi_r` record the `r` coherently labelled projected sextics.  On the frame chart below, the
simultaneous compatibility problem has one explicit equation per view.  These equations prove

```text
generic relative dimension(Phi_2) = 2,
generic relative dimension(Phi_3) = 1,
generic degree(Phi_4)             = 2,                 (1)
```

on the stated separable open locus, in every characteristic.  In particular, four coherent
projected sextics are the first dimensionally possible input, but they do **not** admit a rational
inverse: generically there are two parent-centre configurations, already over `F_101` and in
characteristic two.  The ambiguity survives quotienting by one diagonal `S6`.

Thus C482's requested uniqueness and rational inverse are false.  The strongest correct inverse is
an explicit separable quadratic reconstruction.  C483 must classify its branch divisor and the
extra child-relative data that selects a sheet.

## 1. Normalization and the four gauge variables

Work over a field `F`.  On the open locus where the first four parent points form a projective
frame, normalize

```text
h_1=(1,0,0), h_2=(0,1,0), h_3=(0,0,1), h_4=(1,1,1),
h_5=(1,a,b), h_6=(1,c,d).                              (2)
```

In view `s`, use the unique quotient-line gauge sending the images of `h_1,h_2,h_3` to
`infinity,0,1`, and denote the other images by

```text
(p_s(h_4),p_s(h_5),p_s(h_6))=(A_s,B_s,C_s).            (3)
```

Every camera in this gauge has, up to a common scalar, the matrix

```text
K_s = [ 0       beta_s  1 ]
      [ alpha_s 0       1 ],

alpha_s=A_s(beta_s+1)-1.                               (4)
```

Its centre is

```text
u_s=(beta_s,alpha_s,-alpha_s beta_s).                   (5)
```

Equations (4)--(5) are valid in characteristic two without a sign convention change: minus is the
additive inverse in `F`, and no division by two occurs.  The variables `beta_s` are exactly the
residual independent `PGL_2` gauges after (3).

## 2. Exact compatibility equations

The images of `h_5,h_6` give

```text
B_s(a beta_s+b)=alpha_s+b,
C_s(c beta_s+d)=alpha_s+d.                              (6)
```

Eliminating `beta_s` gives one equation for every view:

```text
E_s := (A_s-1+(1-B_s)b)(C_s c-A_s)
       -(A_s-1+(1-C_s)d)(B_s a-A_s)=0.                 (7)
```

Conversely, on the chart `B_s a-A_s != 0`, equation (7) reconstructs

```text
beta_s = (A_s-1+(1-B_s)b)/(B_s a-A_s),                 (8)
```

and (4) reconstructs the camera.  One may replace (8) by its `C_s` analogue whenever that
denominator is nonzero.  Hence (7), together with the displayed denominator conditions, is not
merely necessary: it is the exact simultaneous-ray compatibility condition.

Introduce

```text
X=bc,  Y=ad,  z=(a,b,c,d,X,Y)^T.                       (9)
```

Then (7) is the linear equation `m_s z=0`, with

```text
m_s = (
 -B_s(A_s-1),
 -A_s(1-B_s),
  C_s(A_s-1),
  A_s(1-C_s),
  C_s(1-B_s),
 -B_s(1-C_s)
).                                                      (10)
```

Write `M_r` for the matrix with these rows.  This is the gauge-free compatibility matrix attached
to the `r` abstract projected sextics after their canonical three-point normalizations.

## 3. The residual surface and curve

On the open locus where the rows of `M_r` impose independent conditions, the exact residual family
is

```text
R_r = { (a,b,c,d) in A^4 : E_1=...=E_r=0 }             (11)
```

with the cameras recovered by (8).  Thus `R_2` is the open part of the complete-intersection
surface `E_1=E_2=0`, while `R_3` is the open part of the complete-intersection curve
`E_1=E_2=E_3=0`.  Their dimensions are exactly two and one.

There is also a characteristic-free differential proof.  The four-view theorem below gives a
dominant separable map on its open locus.  Forgetting the last two or last one target factors is a
smooth projection from a 12-dimensional target to dimensions six or nine.  Therefore `Phi_2` and
`Phi_3` are dominant and generically separable with differential ranks six and nine.  Since their
source dimensions are eight and ten, (1)'s first two dimensions follow.  This upgrades the C482
preflight's characteristic-zero/101/2 witnesses to the structural all-characteristic statement on
the explicit separable locus.

## 4. Four views give a quadratic, not rational, inverse

Assume `rank(M_4)=4`.  Its kernel is a projective line in `P^5`.  The vector

```text
e=(1,1,1,1,1,1)^T                                     (12)
```

lies in that kernel identically: the six entries of every row (10) sum to zero.  It represents the
universal collision `h_5=h_6=h_4`, and hence must be removed from the six-arc locus.

Choose, rationally by Cramer's rule on any stated nonzero `4 x 4` minor of `M_4`, a second kernel
vector `k`.  Parameterize the kernel line by

```text
z(s,t)=s e+t k.                                         (13)
```

An affine scaling `rho z` satisfies the two product conditions in (9) precisely when

```text
rho = z_X/(z_b z_c),
Q_k(s,t):=z_X z_a z_d-z_Y z_b z_c=0.                   (14)
```

The cubic `Q_k` has the universal factor `t`, because `Q_k(1,0)=0` at the collision (12).  Therefore

```text
q_k(s,t):=Q_k(s,t)/t                                   (15)
```

is a homogeneous quadratic.  On the open locus where it has degree two, is separable, and its two
roots avoid the factors in Section 6, each root gives

```text
(a,b,c,d,X,Y)=rho z(s,t),                               (16)
```

then (8), (4), and (5) recover the four centres.  Conversely every compatible deep six-arc on this
chart gives one of these roots.  Equations (13)--(16) are the promised explicit reconstruction
algorithm; they require solving one quadratic and nothing of higher degree.

Changing `k` or the chosen Cramer chart only changes the coordinate on the kernel `P^1`, so the
unordered two-sheet fibre is intrinsic.  In odd characteristic separability is the nonvanishing of
the usual quadratic discriminant.  In characteristic two it is the nonvanishing of the middle
coefficient, equivalently `gcd(q_k,partial q_k)=1`.  This formulation is uniform and never divides
by two.

The degree is exactly two, rather than merely at most two.  The exact certificate supplies points
of this open locus over `F_101` and `F_256`, each with two distinct deep six-arc reconstructions.
The characteristic-two pair proves that (15) is not generically inseparable in characteristic two;
in odd characteristic a separable degree-two polynomial is automatic away from its discriminant.
The construction and the unit-coefficient identity (12)--(15) introduce no exceptional prime.

## 5. Failure of the proposed uniqueness statement

For the `F_101` input

```text
(A_s,B_s,C_s) =
  (54,99,4), (73,24,8), (87,26,13), (76,87,37),        (17)
```

the two normalized parents are

```text
(a,b,c,d)=(37,98,73,26),
(a,b,c,d)=(66,40,49,74).                               (18)
```

Both are six-arcs, all four reconstructed centres are deep, and direct camera evaluation gives
exactly (17).  The common diagonal permutation stabilizer of the four sextics is trivial, so the
two configurations remain distinct after the one allowed diagonal `S6` quotient.

The same phenomenon occurs over `F_256`, represented in the polynomial basis modulo
`x^8+x^4+x^3+x+1`:

```text
(A_s,B_s,C_s) =
  (88,47,216), (222,99,168), (24,209,150), (247,95,235),

(a,b,c,d)=(134,235,130,227),
(a,b,c,d)=(153,213,62,128).                            (19)
```

Again both parents and all eight centre-parent incidences pass the arc/deep tests, and the common
diagonal stabilizer is trivial.  Thus neither characteristic two nor diagonal unlabelling repairs
the rational-inverse claim.

## 6. Exact open locus and factors handed to C483

The quadratic theorem uses the following open conditions.  Their complement is the reconstruction
divisor C483 must factor intrinsically.

1. **Frame and quotient normalization.**  The first four parent points form a projective frame.
   In every view the six points are distinct and the normalization (3) is defined; on this affine
   chart this includes

   ```text
   A_s B_s C_s(A_s-1)(B_s-1)(C_s-1)
   (A_s-B_s)(A_s-C_s)(B_s-C_s) != 0.
   ```

2. **Compatibility rank.**  The chosen `4 x 4` Cramer minor `Delta_M` of `M_4` is nonzero.  For
   two or three views, use the corresponding full-row-rank minor.
3. **Kernel/product chart.**  For each retained root, `t z_b z_c z_X != 0`; `t != 0` removes the
   universal collision and the other factors make (14)--(16) defined.  Other product charts cover
   the symmetric cases.
4. **Quadratic degree and separability.**  The leading coefficient of `q_k` and
   `Res(q_k,partial q_k)` are nonzero.  In odd characteristic the latter is the discriminant up to
   a unit; in characteristic two it retains the linear-coefficient test.
5. **Camera recovery.**  On the displayed chart, every `B_s a-A_s` is nonzero.  More generally at
   least one of `B_s a-A_s` and `C_s c-A_s` must be nonzero and the two formulas for `beta_s` must
   agree.  Also require

   ```text
   alpha_s beta_s(beta_s+1)(a beta_s+b)(c beta_s+d) != 0.
   ```

6. **Geometric domain.**  All twenty parent triple determinants and all sixty centre-secant
   determinants are nonzero.  For uniqueness statements after unlabelling, also remove the finite
   common-diagonal-stabilizer locus.

These are coordinate factors, not yet an intrinsic irreducible factorization.  Identifying their
geometric components and the quadratic branch involution is deliberately left to C483.

## 7. Evidence and replay

The atomic evidence bundle is

```text
notes/2026-07-22-c482-three-centre-synchronization.py
notes/2026-07-22-c482-three-centre-synchronization.json
notes/2026-07-22-c482-three-centre-synchronization.sha256
```

The script is `14,941` bytes with SHA-256
`228d1a12a44fbde167f32e7a017fea8d8a099690e5410bf175265796d98d7f5b`; the canonical JSON is
`2,470` bytes with SHA-256
`c2bd6fc8fd6ad42ed0cde239635f76bffb9021ec053c9879f61f8b740e63d0dd`.

Replay from the repository root:

```bash
python3 notes/2026-07-22-c482-three-centre-synchronization.py --check
```

The checker independently performs two operations: it exhausts the kernel `P^1` using (10),
(14), and (16), and then validates every surviving candidate directly from the camera matrices by
all parent-triple determinants, all centre-secant determinants, and the twelve projected
coordinates.  It also enumerates all `720` diagonal permutations to check that the common
stabilizer is trivial.  No random search is part of replay.

The certificate proves the two exact finite witnesses and validates the formula implementation.
The generic theorem itself is the algebraic argument in Sections 2--4; finite witnesses are used
only to show that the degree-two and characteristic-two separable opens are nonempty.  This is not
a classification of the excluded divisor or of every finite-field fibre.

## Extra-juice closeout

The closeout pass extracted three free upgrades from the failed birational gate:

- the apparently nonlinear gauge problem linearizes as the matrix (10) after adjoining `bc,ad`;
- the unwanted cubic root is not mysterious numerical debris but the universal collision
  `h_5=h_6=h_4`, leaving the exact quadratic (15); and
- exact `F_101` and `F_256` pairs with trivial common diagonal stabilizer show that the second sheet
  is geometric, separable in characteristic two, and not removed by unlabelling.

These upgrades turn a failed requested inverse into the correct next theorem object: an intrinsic
quadratic-cover discriminant.

## Mystery ledger

| Feature | Closeout status | Exact remaining gap / owner |
|---|---|---|
| Why a cubic appeared in raw elimination | settled | Its universal linear factor is the collision (12); (15) is quadratic. |
| Geometric meaning of the second reconstruction | open | Identify the intrinsic sheet involution in C483. |
| Branch and rank-drop divisor | open | Factor the Section 6 coordinate product intrinsically in C483. |
| Why fixed-child data selected one sheet in C478 | open | Derive the child-relative sheet-selection equations in C483. |
| Characteristic-two separability | settled on the generic open | The `F_256` witness proves the middle coefficient is not identically zero; C483 still owns its branch specialization. |

## Vibe check

The original four-view uniqueness target fails, but the failure is clean and productive: the map
is not uncontrolled or high-degree, but an explicit separable double cover with a visible
collision factor and a sharply defined next discriminant problem.
