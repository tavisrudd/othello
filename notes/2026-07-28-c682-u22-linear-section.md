# C682 target-side \(U_{22}\) linear section

## Outcome

The \(22\)-point rank-four resolvent has the target-side explanation left
open by the preceding report.  It is not merely equinumerous with the
anticanonical degree of the Mukai--Umemura threefold: its kernel planes are
scheme-theoretically one canonical complementary linear section of
\(U_{22,\mathbf F_{11}}\).

Put
\[
 E=\operatorname{Sym}^6(\mathbf F_{11}^2)
\]
and let
\[
 \omega=(\,\cdot\,,\,\cdot\,)_5:
 \Lambda^2E\longrightarrow\operatorname{Sym}^2(\mathbf F_{11}^2)
\]
be the fifth transvectant.  The contraction
\[
\begin{aligned}
 c_\omega:\Lambda^3E&\longrightarrow
 E\otimes\operatorname{Sym}^2(\mathbf F_{11}^2),\\
 u\wedge v\wedge w&\longmapsto
 \omega(u,v)w-\omega(u,w)v+\omega(v,w)u
\end{aligned}
\]
has rank \(21\).  Its kernel
\[
 A=\ker c_\omega\simeq\mathbf1\oplus\operatorname{Sym}^{12}
\]
has dimension \(14\), and
\(\mathbf P(A)=\mathbf P^{13}\) is the anticanonical Plücker span of
\(U_{22}\).

Index the basis of \(E\) by
\(e_i=X^{6-i}Y^i\), and write \(p_{ijk}\) for the corresponding Plücker
coordinates.  Then the target kernel planes of the complete ten-pair
resolvent are exactly
\[
 \boxed{
 U_{22}\cap\Lambda,\qquad
 \Lambda=
 V(p_{012},\,p_{013}+p_{356},\,p_{456})
 \subset\mathbf P(A).
 }
\]
The three displayed equations are understood modulo the \(21\) contraction
relations defining \(\mathbf P(A)\).  They are independent there, so
\(\Lambda\simeq\mathbf P^{10}\).

This also explains the quadratic two-sheet structure on the target.  The
two invariant linear coordinates
\[
 u=5p_{036}+8p_{045},\qquad
 v=10p_{013}+p_{356}
\]
span \((A^\vee)^{A_5}\).  On the \(22\)-point section,
\[
 \boxed{u^2-v^2=0,\qquad s=u/v.}
\]
Thus its two length-eleven sheets are the two invariant hyperplane cuts
\[
 u-v=0\quad\text{and}\quad u+v=0.
\]
They retain the earlier orbit decompositions \(1+10\) and \(5+6\),
respectively.  The source quadratic parameter is therefore intrinsic on
the target section: it is the ratio of the two anticanonical invariant
coordinates.

## Why this is the canonical section

The \(A_5\)-module carried by the anticanonical span is
\[
 A|_{A_5}\simeq
 2\mathbf1\oplus V_3\oplus V_4\oplus V_5.
\]
The \(22\) target Plücker vectors span an eleven-dimensional submodule
\[
 L\simeq2\mathbf1\oplus V_4\oplus V_5.
\]
Consequently
\[
 A/L\simeq V_3.
\]
The three section equations are a basis of the dual \(V_3\), modulo the
contraction equations.  Since \(V_3\) occurs with multiplicity one in
\(A\), the section is the unique \(A_5\)-stable complementary
\(\mathbf P^{10}\) obtained by killing that summand; it is not a linear
space fitted to the \(22\) points after their enumeration.

The exact character check uses elements of orders \(2,3,5\).  The traces
on \(A\), \(L\), and \(A/L\), respectively, are
\[
\begin{array}{c|ccc}
\text{order}&\operatorname{tr}_A&\operatorname{tr}_L&
\operatorname{tr}_{A/L}\\ \hline
2&2&3&-1\\
3&2&2&0\\
5&5&1&4
\end{array}
\qquad\text{in }\mathbf F_{11}.
\]
The quotient character is the \(V_3\) occurring in
\(\operatorname{Sym}^{12}|_{A_5}
=\mathbf1\oplus V_3\oplus V_4\oplus V_5\), rather than the conjugate
\(V_{3'}\) occurring in the degree-six source module.

## Scheme-theoretic proof

For a three-plane \(U\subset E\), the tangent space to the isotropy locus is
the kernel of
\[
 \operatorname{Hom}(U,E/U)\longrightarrow
 \Lambda^2U^\vee\otimes\operatorname{Sym}^2(\mathbf F_{11}^2),
\]
obtained by differentiating \(\omega|_U=0\).
At every one of the \(22\) kernel planes this map has rank \(9\), so the
projective tangent dimension is \(12-9=3\), as required for \(U_{22}\).
In the anticanonical Plücker space the affine tangent has rank \(4\), and
\[
 \dim(L+\widehat T_UU_{22})=14.
\]
Hence \(\mathbf P(L)\) meets \(U_{22}\) transversely at every one of the
\(22\) points.

The previous resolvent theorem supplies \(22\) distinct kernel planes, and
their Plücker vectors have rank \(11\), so they lie in and span
\(\mathbf P(L)=\Lambda\).  The anticanonical degree already predicts the
answer:
\[
 (-K_{U_{22}})^3=22.
\]

An exact target-side Hilbert calculation rules out excess directly.  Let
\(S=\mathbf F_{11}[y_0,\ldots,y_{10}]\) be the coordinate ring of
\(\Lambda\), and restrict the quadratic Plücker relations of
\(\operatorname{Gr}(3,E)\) to \(L\).  The \(516\) nonzero restricted rows
span a \(45\)-space in the \(66\)-dimensional \(S_2\), and their linear
multiples have ranks
\[
\begin{array}{c|ccc}
d&\dim S_d&\dim I_d&\dim(S/I)_d\\ \hline
2&66&45&21\\
3&286&264&22\\
4&1001&979&22.
\end{array}
\]
Multiplication by the invariant coordinate \(v\) is an isomorphism
\[
 v:(S/I)_3\xrightarrow{\sim}(S/I)_4.
\]
Its surjectivity gives \(S_4=I_4+vS_3\); multiplying and inducting yields
\[
 S_d=I_d+v^{d-3}S_3\qquad(d\ge4),
\]
so every later Hilbert value is at most \(22\).  Since the section already
contains \(22\) distinct reduced points, its Hilbert function is eventually
at least \(22\).  It is therefore identically \(22\) from degree three
onward, with no further point, embedded length, or positive-dimensional
component.

Thus
\[
 U_{22}\cap\Lambda
\]
is reduced of length \(22\).  Since the source rank-four scheme is also
reduced of length \(22\) and the kernel map is injective on it, the kernel
map identifies the source resolvent with this target linear section as
finite schemes.

## Structural meaning

The source and target representations now fit into one concise picture:
\[
\begin{array}{c}
P_{10}=\mathbf1\oplus V_4\oplus V_5
\quad\text{(extended Bockstein pencil)}
\\[2mm]
\downarrow\ \ker\widehat\Theta
\\[2mm]
U_{22}\cap
\mathbf P(2\mathbf1\oplus V_4\oplus V_5)
\subset
\mathbf P(2\mathbf1\oplus V_3\oplus V_4\oplus V_5).
\end{array}
\]
The nonlinear kernel map creates the second target invariant line.  The
ratio of the two trivial coordinates is precisely the quadratic sheet
coordinate, while removing the unique \(V_3\) produces the complementary
linear section of degree \(22\).  This simultaneously explains the total
length, the \(11+11\) split, and why every point has an isotropic kernel.

This is a theorem only in the marked characteristic-\(11\) fibre.  It does
not construct an integral or characteristic-zero lift of the section, does
not identify its invariant pencil with the global \(5J_0\) incidence
coordinate, and does not reopen Paper III.  No novelty claim is made.

## Reproducibility

From `rust/`, run

```text
python3 ../notes/2026-07-28-c682-u22-linear-section.py --check
python3 ../notes/2026-07-28-c682-u22-linear-section-replay.py
```

The primary generator recomputes the \(22\) operator kernels, their
Plücker vectors, the contraction map, the target section equations,
the \(A_5\)-character quotient, the two invariant target coordinates, and
all tangent intersections.  It then restricts the Grassmannian Plücker
quadrics to the target \(\mathbf P^{10}\), computes the degree-two through
degree-four Macaulay ranks, and checks the \(v\)-multiplication isomorphism.
It uses the previously committed rank-four operator pencil as input.

The independent replay reads the stored operator matrices but uses its own
finite-field elimination, nullspace, transvectant, Plücker, and tangent
implementations.  It independently recovers the \(14\)-space, the
\(\mathbf P^{10}\), the three section equations, all \(22\) transverse
target points, and the \(11+11\) equation \(u^2=v^2\).

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-28-c682-u22-linear-section.py` | 27151 | `15a369bc3fef5a3b8966b533c38f524d575bde5fe5fe0a3734c873cc93ac77cc` |
| `2026-07-28-c682-u22-linear-section.json` | 21991 | `63f516612e7e7f660126502d76bc36dd65dd4a8a5106c77b153ce213311a5f1b` |
| `2026-07-28-c682-u22-linear-section-replay.py` | 17417 | `071466f59a5ebb89b31f3422e2ae66a3cebe16aee557a059e17db6b203e260f0` |

The computational certificate proves the finite-field linear algebra and
transversality statements.  It takes as classical inputs the
fifth-transvectant Grassmannian model of \(U_{22}\), its anticanonical
degree \(22\), and the complementary-linear-section degree lemma.

## `ej` + `tt` closeout and mystery ledger

- **Closed:** the agreement between the resolvent length and
  \(\deg U_{22}\) is structural.  The kernel image is exactly the
  complementary anticanonical section obtained by killing \(V_3\).
- **Closed by `ej`:** the three target equations have the sparse form
  \(p_{012}=p_{456}=p_{013}+p_{356}=0\), and their classes are the unique
  dual \(V_3\).
- **Closed by the next `ej`:** the source quadratic sheet parameter has
  the target formula \(s=u/v\), where \(u,v\) span the two anticanonical
  invariant lines.  The quadratic resolvent is the reducible invariant
  quadric \(u^2-v^2=0\), with two length-eleven hyperplane halves.
- **Closed by `tt`:** the section is canonical, not merely an
\(A_5\)-stable span: multiplicity one of \(V_3\) makes it the unique
equivariant quotient of this type, while the restricted Plücker Hilbert
calculation gives scheme-theoretic exhaustiveness without an implicit
proper-intersection assumption.
- **Still open:** globalize the marked \(\mathbf F_{11}\) section and its
  invariant pencil over the corrected \(\mathbf Z_{11}\)-tower or a
  characteristic-zero family.  The exact gate is a base-change-compatible
  anticanonical map from the extended Bockstein normal construction.
- **Still open:** compare the target ratio \(u/v\) with the local
  incidence orientation coordinate.  A common \(C_2\)-action and equal
  sheet values do not yet identify it with the global \(5J_0\) torsor.
- **Still open:** give the interpolation parameter \(t\) an intrinsic
  target moduli meaning and interpret the \(6\)- and \(10\)-orbits
  incidence-theoretically.

C682 remains open; completion is the user's decision.
