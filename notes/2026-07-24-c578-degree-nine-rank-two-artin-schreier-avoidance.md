# C578 — degree-nine rank-two Artin--Schreier avoidance

**Lane:** `reed-solomon` · **Date:** 2026-07-24 · **Status:** complete

## Result

Let \(k=\mathbf F_{2^m}\), \(m\ge4\), and let
\[
 U=\langle e_2,e_3,e_6,e_7\rangle
 \simeq \det^2\otimes(E^{(4)}\otimes E).
\]
Every rational rank-two point of \(\mathbf P(U)(k)\) is shallow: its
degree-eight Hankel kernel contains a completely split squarefree member.
Thus C531's unique split-free \(q=8\), \((2)(3)\)-twisted orbit does not
persist into any admissible full-length redundancy-ten field.

The proof covers every rational \(A_5\)-twist without choosing a cocycle
representative.  For a general rational rank-two syndrome
\[
 z=(a,b,c,d)\in U(k),\qquad ad+bc\ne0,                       \tag{1}
\]
the six-root construction descends directly over \(k\).  Fixing five ordered
roots leaves an Artin--Schreier curve of genus at most one.  A nonzero
specialization certificate of degree at most \(102\) supplies a good
five-root base for every \(q>102\), hence every power of two \(q\ge128\).
On the resulting curve at most \(48\) rational points are deleted, while
\[
 q+1-2\sqrt q\ge49\qquad(q\ge64).                           \tag{2}
\]
The single remaining theorem-gap field \(q=64\) is closed by a compact
five-twist certificate.  C531 already certifies \(q=16,32\).

Consequently, for C532's characteristic-two theorem (\(q\ge64\)), the
residual set has no point in \(\mathbf P(U)\).  With
\[
 \mathcal R_q=\mathcal D_{10}(q)\setminus\mathcal P_9(q),
\]
one now has
\[
 \mathcal R_q\subseteq
 \mathbf P(\mathcal M_9)(k)\setminus\mathbf P(U)(k),\qquad
 0\le\rho_q:=|\mathcal R_q|\le q^4(q+1),                    \tag{3}
\]
and therefore
\[
 |\mathcal D_{10}(q)|
   =\frac{q(q+1)^2}{2}+\rho_q.                              \tag{4}
\]
This removes the former \(q(q^2-1)\) rank-two term from C532's upper bound.
The two-dimensional complement quotient remains untouched, as required.

## 1. Uniform descent of the six-root cover

Write a split degree-eight polynomial as
\[
 f(t)=h(t)(t^2+st+p),
\]
where
\[
 h(t)=\sum_{i=0}^6h_it^i,\qquad h_6=1
\]
has six distinct rational roots.  The two Hankel equations for (1) are
\[
\begin{aligned}
 a f_1+b f_2+c f_5+d f_6&=0,\\
 a f_2+b f_3+c f_6+d f_7&=0.
\end{aligned}                                               \tag{5}
\]
Define
\[
\begin{aligned}
 A_0&=b h_0+c h_3+d h_4,\\
 A_1&=a h_0+b h_1+c h_4+d h_5,\\
 A_2&=a h_1+b h_2+c h_5+d,\\
 A_3&=a h_2+b h_3+c.
\end{aligned}                                               \tag{6}
\]
Then (5) is exactly
\[
 A_0+sA_1+pA_2=0,\qquad A_1+sA_2+pA_3=0.                   \tag{7}
\]
Put
\[
\begin{aligned}
 \Delta&=A_1A_3+A_2^2,\\
 Q&=N_s=A_0A_3+A_1A_2,\\
 N&=N_p=A_1^2+A_0A_2.
\end{aligned}                                               \tag{8}
\]
On \(\Delta Q\ne0\),
\[
 s=\frac Q\Delta,\qquad p=\frac N\Delta,                    \tag{9}
\]
and the last pair is rational and distinct precisely on the
Artin--Schreier cover
\[
 y^2+y=\frac{N\Delta}{Q^2}.                                \tag{10}
\]

Equations (5)--(10) have coefficients in \(k\) for every rational syndrome
\((a,b,c,d)\).  They are therefore the required descent of C531's equation,
not an equation written only at \(e_3+e_6\) and then informally assigned a
finite twist label.  Over \(\bar k\), every point satisfying (1) is
\(PGL_2\)-conjugate to C531's alternating representative.  The induced
change of root coordinates is birational.  Moreover, passing from the
squarefree six-root coefficient space to ordered roots is finite étale.
C531's nonsquare leading coefficient along \(Q=0\) cannot become a square
under a separable extension in characteristic two: adjoining its square root
would be purely inseparable.  Thus ordering the roots does not split the
cover, and C531's geometrically nontrivial Artin--Schreier class applies to
every rank-two syndrome on the ordered configuration space used below.

## 2. A genus-at-most-one rational slice

Choose five ordered roots \(r_1,\ldots,r_5\) and write
\[
 g(t)=\prod_{i=1}^5(t+r_i)=\sum_{i=0}^5g_it^i,\qquad g_5=1.
\]
Let \(x\) be the sixth root, so
\[
 h_i=g_{i-1}+xg_i.
\]
For compactness set
\[
\begin{aligned}
 u_0&=c g_2+d g_3,\\
 v_0&=b g_0+c g_3+d g_4,\\
 v_1&=a g_0+b g_1+c g_4+d,\\
 v_2&=a g_1+b g_2+c,\\
 v_3&=a g_2+b g_3.
\end{aligned}                                               \tag{11}
\]
Then (6) becomes the overlapping sequence
\[
 A_0=u_0+xv_0,\quad A_1=v_0+xv_1,\quad
 A_2=v_1+xv_2,\quad A_3=v_2+xv_3.                           \tag{12}
\]
In particular \(Q\) has degree at most two in \(x\), \(N\Delta\) has degree
at most four, and
\[
 Q'(x)=q_1=u_0v_3+v_1^2.                                  \tag{13}
\]
The right side of (13) is not the zero polynomial in the five-root
coefficients.  If \(a\ne0\), its coefficient of \(g_0^2\) is \(a^2\);
if \(a=0\), rank two forces \(b\ne0\), and its coefficient of \(g_1^2\)
is \(b^2\).  Thus a specialization with \(q_1\ne0\) makes every finite pole
of (10) separable.

Put \(P=N\Delta\).  At a root \(\alpha\) of \(Q\), write a local parameter
\(\xi=x-\alpha\).  The double-pole coefficient of \(P/Q^2\) is
\(P(\alpha)/q_1^2\).  Removing its square by an Artin--Schreier translation
leaves a simple pole exactly when
\[
 R(\alpha)\ne0,\qquad
 R=(P')^2+q_1^2P.                                          \tag{14}
\]
There are at most two such finite poles.  When \(Q\) is quadratic there is
no pole at infinity.  When \(Q\) is linear, the polynomial part at infinity
reduces to at most one simple pole.  Hence every geometrically integral
specialized curve has at most two reduced simple poles and
\[
 g\le1.                                                     \tag{15}
\]

## 3. Effective selection of the five-root base

The root coefficients have degrees
\[
\deg(v_0),\deg(v_1),\deg(v_2),\deg(v_3)\le5,5,4,3.
\]
Consequently the coefficients of \(Q\) have degree at most \(10\), its
quadratic coefficient has degree at most \(9\), the coefficients of \(R\)
have degree at most \(42\), and (13) has degree at most \(10\).

Over the function field of the five roots, geometric nontriviality from
§1 says that \(Q\) does not divide \(R\).  If the quadratic coefficient of
\(Q\) is nonzero, a cleared pseudo-remainder of a quartic by a quadratic has
coefficient degree at most
\[
 3\cdot10+42=72.                                           \tag{16}
\]
At least one of its two coefficients is a nonzero polynomial.  Avoiding that
coefficient, the quadratic coefficient, \(q_1\), and the five-root
Vandermonde costs total degree at most
\[
 72+9+10+10=101.                                           \tag{17}
\]
If the quadratic coefficient vanishes identically, \(Q=q_1x+q_0\).
Clearing the denominator in \(R(q_0/q_1)\) costs degree at most
\[
 4\cdot10+42=82,
\]
so the corresponding total bad degree is at most
\[
 82+10+10=102.                                             \tag{18}
\]
These are alternatives for a fixed syndrome; no product over twist classes
is taken.

The elementary finite-field zero bound now gives at most
\(102q^4<q^5\) bad ordered five-tuples whenever \(q>102\).  Thus every
rank-two syndrome over every \(q=2^m\ge128\) has a five-root base for which
the curve (10) is geometrically integral, has genus at most one, and begins
with five distinct rational roots.

## 4. Exact deletion and rational avoidance

For a good five-root base, invalid \(x\)-coordinates have the following
degrees:

| deleted condition | degree in \(x\) |
|---|---:|
| \(x=r_i\) for one of the five old roots | \(5\) |
| \(Q=0\) | \(2\) |
| \(\Delta=0\) | \(2\) |
| a final root equals one of the five old roots | \(5\cdot2=10\) |
| a final root equals \(x\) | \(4\) |
| **total** | **\(23\)** |

Indeed, collision with a root \(r\) is
\[
 r^2\Delta+rQ+N=0,                                        \tag{19}
\]
of degree at most two for a fixed old root and at most four for \(r=x\).
The condition \(Q\ne0\) also makes the final pair distinct.  The
Artin--Schreier equation itself makes that pair rational.

The double cover has at most two rational points above each deleted
\(x\)-coordinate, and at most two points above infinity.  Hence at most
\[
 2\cdot23+2=48                                             \tag{20}
\]
rational points are deleted from its smooth projective model.  By (15),
the model has at least \(q+1-2\sqrt q\) rational points.  Inequality (2)
therefore supplies a valid split squarefree degree-eight member whenever a
good base exists and \(q\ge64\).  Combined with §3, this proves the theorem
for every \(q\ge128\).

## 5. The bounded fields and twist transport

C531's frozen certificate gives a split member on every rational
\(\mathbf P(U)\)-orbit at \(q=16,32\).  The new certificate treats \(q=64\),
where even-degree Frobenius gives the five rational twist classes
\[
 1A,\quad2A,\quad3A,\quad5A,\quad5B
\]
with centralizer orders \(60,4,3,5,5\).  Its independent replay enumerates
all \(262080\) projective matrices, checks those five stabilizer orders and
the complete orbit-mass identity, verifies Frobenius fixes the first three
classes and exchanges \(5A,5B\), and rebuilds and checks one split
squarefree divisor for every class.

Projective transport carries each certified representative witness across
its complete \(PGL_2(k)\)-orbit.  The theorem of §§1--4 is formulated for an
arbitrary rational rank-two point, so it covers all five even-degree classes
and all three odd-degree classes directly for \(q\ge128\).  This closes every
admissible binary field and every rational \(A_5\)-twist.

The exact semilinear effect is simple:

- the C531 five-/three-class rank-two orbit law still describes the shallow
  rank-two carrier itself;
- none of those classes contributes to \(\mathcal R_q\);
- C532's persistent \(T/T^9\) inversion/Frobenius law is unchanged; and
- the only unclassified residual semilinear action is on the explicitly
  excluded two-dimensional complement quotient.

## Evidence and replay

The atomic evidence bundle is:

- `notes/2026-07-24-c578-degree-nine-rank-two-artin-schreier-avoidance.py`;
- `notes/2026-07-24-c578-degree-nine-rank-two-artin-schreier-avoidance.json`;
- `notes/2026-07-24-c578-degree-nine-rank-two-artin-schreier-avoidance-replay.py`;
  and
- `notes/2026-07-24-c578-degree-nine-rank-two-artin-schreier-avoidance.sha256`.

From the repository root:

```text
python3 notes/2026-07-24-c578-degree-nine-rank-two-artin-schreier-avoidance.py --check
python3 notes/2026-07-24-c578-degree-nine-rank-two-artin-schreier-avoidance-replay.py
(cd notes && sha256sum -c 2026-07-24-c578-degree-nine-rank-two-artin-schreier-avoidance.sha256)
```

The generator imports the frozen C531 finite-field implementation, whose
SHA-256 is recorded in the JSON, and independently closes its five
\(PGL_2(\mathbf F_{64})\)-orbits under explicit generators.  The replay
shares no finite-field or orbit code: it enumerates all projective matrices,
recomputes stabilizers and Frobenius transport, rebuilds every root
polynomial, and checks the two Hankel equations.

The computation certifies only the complete \(q=64\) twist quotient and the
displayed witnesses.  It does not certify the all-field theorem, whose
load-bearing inputs are the direct equations, geometric integrality
transport, degree bound, genus calculation, and Hasse--Weil argument above.
The \(q=16,32\) claims remain backed by C531's frozen atomic bundle rather
than being regenerated here.

## Extra-juice and Tao closeout

The closeout exposed and settled three useful pressure points.

- **Twist descent is cheaper than cocycle-by-cocycle normalization.**  The
  overlapping sequence (12) writes the cover over the rational syndrome
  itself.  The finite \(A_5\) labels are needed only for the one bounded
  certificate, not for the theorem.
- **The apparent double poles still give genus at most one.**  Formula (14)
  is the exact reduced-pole test; a nontrivial cover has at most two simple
  poles after Artin--Schreier reduction.
- **The arithmetic threshold and specialization threshold separate.**
  Hasse--Weil already wins at \(q=64\) by the sharp margin \(49>48\).
  Only the degree-\(102\) five-root selection bound postpones the uniform
  argument to \(q=128\), so one compact \(q=64\) quotient certificate closes
  the entire gap.

The resulting gain in C532 is exact rather than qualitative: its residual
upper bound drops by \(q(q^2-1)\), and every finite rank-two twist disappears
from the deep set.  The highest-EV next move returns to the lane's existing
order: C535 tests the reusable Hessian--Arf functoriality boundary.  C578
does not authorize opening the two-dimensional carrier complement.

## Mystery ledger

Settled:

- **Does the \(q=8\) \((2)(3)\)-twisted obstruction persist?**  No.  Every
  rank-two twist is shallow for every admissible \(q=2^m\), \(m\ge4\).
- **How does the cover descend across twists?**  Equations (5)--(10) are
  defined over the arbitrary rational syndrome, with no unresolved descent
  torsor.
- **What controls the normalization?**  The reduced-pole polynomial (14);
  it gives genus at most one.
- **What are the exact effective constants?**  Five-root bad degree \(102\),
  first theorem field \(128\), deletion \(23\) in the base and \(48\) on the
  double cover, and Hasse lower bound \(49\) at \(q=64\).
- **What bounded computation remains?**  Exactly the five \(q=64\) twist
  classes; the atomic certificate closes all five.
- **What is the effect on redundancy ten?**  Equations (3)--(4), removing
  the complete rank-two term.

No genuine mystery remains inside C578's rank-two scope.  The
two-dimensional complement is the separately frozen C532 residue and was
not opened.

## Literature boundary

C578 makes no priority or manuscript claim.  It imports C531's frozen
geometric integrality and \(q=16,32\) certificates and C532's coding
dictionary, then proves the rational-slice avoidance theorem directly.
No literature search, ambient syndrome census, or positive-moduli
classification is used.
