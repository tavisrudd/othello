# C682 corrected bridge modulo \(11^3\)

## Outcome

The corrected bridge passes the next arithmetic gate.

There is a normalized lift of the marked binary-icosahedral representation
to \(\operatorname{SL}_2(\mathbf Z/11^3)\) and a degree-twelve invariant
\(I\) satisfying
\[
 I\equiv F+11K\pmod{11^2}
\]
in the previously certified quotient by
\[
 W_{\mathrm{Fr}}
 =\langle X^{12},X^{11}Y,XY^{11},Y^{12}\rangle.
\]
More precisely, with
\[
 F=X^{11}Y+11X^6Y^6-XY^{11},
\]
the normalization \([X^{11}Y]I=1\) gives
\[
 I=F+11K'+121L\pmod{1331},
\]
where
\[
\begin{aligned}
K'={}&10X^{10}Y^2+5X^9Y^3+7X^8Y^4+8X^7Y^5+2X^6Y^6\\
&+3X^5Y^7+7X^4Y^8+6X^3Y^9+10X^2Y^{10}
  +4XY^{11}
\end{aligned}
\]
and
\[
\begin{aligned}
L={}&6X^{12}+2X^{10}Y^2+3X^9Y^3+X^8Y^4+5X^7Y^5\\
&+7X^5Y^7+3X^4Y^8+8X^3Y^9+3X^2Y^{10}
  +5XY^{11}+7Y^{12}.
\end{aligned}
\]
Thus \(K'-K=4XY^{11}\in W_{\mathrm{Fr}}\): the new computation recovers
exactly the corrected first-order class, not merely another rank-four map.

Because the primitive operator divides one factor of \(11\), a dodecic
test modulo \(11^3\) produces the next operator digit modulo \(11^2\).
The operator
\[
 P_{121}
 =P_F+240^{-1}(\,\cdot\,,K'+11L)_3\pmod{121}
\]
is equivariant for the lifted \(A_5\).  On the independently normalized
marked four-charts,
\[
 P_{121}J_{121}=115\,T_{121}\pmod{121}.
\]
The scalar is \(115\equiv5\pmod{11}\).  It is normalization-dependent:
replacing \(T_{121}\) by \(23T_{121}\), with \(23\equiv1\pmod{11}\),
restores the exact scalar \(5\).

## Lift convention and exact test

The certificate chooses the lexicographically first marked presentation
pair \((S,T)\) with projective orders \(2,3\) and \(ST\) of order \(5\).
After determinant-one normalization, Hensel lifting gives
\[
 S=\begin{pmatrix}1321&1032\\628&10\end{pmatrix},\qquad
 T=\begin{pmatrix}1322&1094\\6&10\end{pmatrix}\pmod{1331},
\]
and
\[
 S^2=T^3=-I,\qquad (ST)^5=I.
\]
The trace of \(ST\) is \(1294\), the lift of the root \(7\) of
\(u^2+u-1\) modulo \(11\).

The primary certificate checks:

- both presentation Hensel steps, whose five-equation Jacobians have rank
  five;
- both invariant-vector Hensel steps, with rank thirteen after fixing
  \([X^{11}Y]I=1\);
- coefficientwise invariance of \(I\) modulo \(1331\);
- equality of the first correction with the old \(K\)-class modulo
  \(W_{\mathrm{Fr}}\);
- the complete \(13\)-by-\(7\) operator equivariance equations modulo
  \(121\);
- unique normalized lifts of the marked source and target four-charts;
  and
- the full marked comparison with scalar \(115\).

The independent replay reimplements matrix powers, symmetric powers,
ordinary derivatives, the third transvectant, the operator, all
equivariance equations, chart reductions, and the marked scalar.  It does
not import the primary generator.

## `ej` upgrade: no hidden \(11\)-torsion channel

The rank-four reduction could in principle have concealed additional
operator channels whose invariant factors were divisible by \(11\).
The cheap Bockstein test rules this out at the next digit.  For
\(\bar P:\mathbf F_{11}^7\to\mathbf F_{11}^{13}\), form
\[
 \beta:\ker\bar P\longrightarrow\operatorname{coker}\bar P,\qquad
 x\longmapsto P_{121}\widetilde x/11\bmod11.
\]
Here
\[
 \dim\ker\bar P=3,\qquad \dim\operatorname{coker}\bar P=9,
\]
and the complete \(9\)-by-\(3\) Bockstein matrix is zero.  The certificate
then constructs three independent kernel vectors modulo \(121\), reducing
to a basis of \(\ker\bar P\).  Thus the corrected operator has flat rank
four through this gate: no fifth, sixth, or seventh channel is present
only at order \(11\).

This fits the characteristic-zero picture rather than merely agreeing
numerically with it.  The lifted \(A_5\)-invariant dodecic lies on the
classical Klein orbit after characteristic-zero base change, so its third
transvectant retains the \(V_4\) image and \(V_{3'}\) kernel.  The local
calculation verifies that this splitting is integral through modulus
\(121\).

There is also an intrinsic interpretation of the former “repair
polynomial.”  The special-fibre Dickson form
\(\bar F=X^{11}Y-XY^{11}\) has the enlarged
\(\operatorname{PGL}_2(\mathbf F_{11})\) symmetry, and
\[
 W_{\mathrm{Fr}}=V^{(1)}\otimes V
\]
is its complete infinitesimal coordinate-and-scalar orbit.  Therefore
\[
 [K]\in\operatorname{Sym}^{12}/W_{\mathrm{Fr}}
\]
is the normal, or Kodaira--Spencer, direction in which the
characteristic-zero \(A_5\)-invariant line leaves the maximally symmetric
Dickson special fibre.  The positive tower integrates this normal class.
This makes \(K\) an intrinsic first-order degeneration datum, not an ad
hoc equivariance patch.

## `ej` + `tt` closeout: the whole \(11\)-adic tower

The finite test exposes a general consequence rather than a new
obstruction.  The presentation scheme is smooth at the selected point:
the five defining constraints have rank-five Jacobian modulo \(11\), and
the root \(u=7\) is simple.  Hence the marked
\(\operatorname{SL}_2\)-representation continues through every
\(11\)-adic order, with the three free tangent directions accounting for
coordinate conjugacy.

Moreover, \(11\nmid120=|2.A_5|\).  Reynolds averaging is therefore exact
over \(\mathbf Z_{11}\).  It lifts the invariant dodecic line and the two
marked Hom lines; the unit normalization minors found modulo \(11\) make
each normalized lift unique.  Transvectant covariance then lifts the
operator bridge, and its scalar remains a unit congruent to \(5\).  A unit
rescaling of the target line can keep that scalar equal to \(5\) at every
order.

Consequently the positive modulo-\(11^3\) test is the first explicit
second-order coefficient row of a compatible \(11\)-adic tower, while
smoothness and prime-to-\(120\) averaging prove existence of the full
tower.  The individual higher digits remain coordinate/scalar
normalization data; the invariant line and marked bridge are the intrinsic
objects.

## Scope and trust boundary

This result concerns the local marked representation and divided
transvectant over \(\mathbf Z_{11}\).  It does not:

- reduce the rational Gaunt scalar, whose denominator is still divisible
  by \(11\);
- identify the tower with good reduction of the global Hitchin incidence
  comparison;
- choose a coordinate-free representative of every higher correction
  digit; or
- reopen the pre-release-green Paper III manuscript.

The all-order statement uses the displayed smoothness calculation,
Cayley--Hamilton for the binary \((2,3,5)\) presentation, exact Reynolds
averaging because \(11\nmid120\), and standard transvectant covariance.
The certificate supplies the selected branch and its first two nontrivial
digits.

## Reproducibility

From the repository root:

```text
python3 notes/2026-07-28-c682-corrected-bridge-mod-1331.py --check
python3 notes/2026-07-28-c682-corrected-bridge-mod-1331-replay.py --check
```

The deterministic evidence bundle is:

| file | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-28-c682-corrected-bridge-mod-1331.py` | 22534 | `794dfe03e11c6a2b41468a8330e2b4dd5ef3e880439677cf70ad9da55f5512d2` |
| `notes/2026-07-28-c682-corrected-bridge-mod-1331.json` | 9751 | `a07132da65a45f82b36f76baa32a276edfe0bfffd586f8547f776b92371ecb1a` |
| `notes/2026-07-28-c682-corrected-bridge-mod-1331-replay.py` | 12761 | `b59b9f8329d52f4e4fb4135bbada7ca9becd1b330aac6efcd31e5ef659864e6c` |

The JSON records byte counts and hashes for every imported load-bearing
input.  Its output is canonical and has no timestamps, random seeds, or
host-specific paths.

## Mystery ledger

- **Closed:** the corrected class extends through the
  modulo-\(11^3\) gate.
- **Closed:** the explicit second correction digit is the displayed
  \(L\) in the stated normalization.
- **Explained:** the difference from the previous \(K\) representative is
  exactly \(4XY^{11}\), one Frobenius/coordinate-gauge direction.
- **Explained:** the scalar \(115\) is caused by independent chart
  normalizations; the congruent-to-one rescaling \(T_{121}\mapsto23T_{121}\)
  restores scalar \(5\).
- **Closed by `ej`:** the kernel-to-cokernel Bockstein is zero and three
  independent kernel vectors lift modulo \(121\), so no hidden
  \(11\)-torsion operator channel appears.
- **Explained by `ej`:** \([K]\) is the normal/Kodaira--Spencer direction
  of the \(A_5\)-invariant lift away from the maximally symmetric Dickson
  fibre, modulo the complete coordinate-and-scalar tangent space.
- **Closed by `ej` + `tt`:** smoothness and Reynolds averaging upgrade the
  one-step success to existence of the entire compatible
  \(\mathbf Z_{11}\)-tower.
- **Open outside this local gate:** find an intrinsic geometric
  interpretation of the tower inside the Hitchin incidence cover or the
  global golden-fibre integral model.  No genuine mystery remains in the
  local lift equation itself.

C682 remains open; completion is the user's decision.
