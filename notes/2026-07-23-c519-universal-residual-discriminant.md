# C519 — universal residual discriminant: modular obstruction theorem

**Lane:** `reed-solomon` · **Date:** 2026-07-23 · **Status:** complete at the authorized
characteristic-two obstruction exit

## Result

The universal residual-quadratic calculation does produce the integral divided-power
binary-cubic discriminant.  Let
\[
 L_f(P)=(A,B,C,D_3)=(H_{-1},H_0,H_1,H_2),
 \qquad H_j(P)=\sum_i a_i p_{i+j},
\]
where \(f=(a_0,\ldots,a_n)\in\Gamma^nE\) and
\(P=\sum p_i t^i\in\operatorname{Sym}^{n-3}E^\vee\).  Put
\[
\begin{aligned}
 \Delta&=BD_3-C^2,\\
 N_s&=AD_3-BC,\\
 N_u&=AC-B^2.
\end{aligned}
\]
Then the residual equations are
\[
 H_0-sH_1+uH_2=0,\qquad H_{-1}-sH_0+uH_1=0,
\]
and, off \(\Delta=0\), their unique quadratic is
\[
 \Delta t^2-N_s t+N_u.
\]
Its integral branch covariant is
\[
\begin{aligned}
 K&=N_s^2-4\Delta N_u\\
  &=A^2D_3^2-6ABCD_3-3B^2C^2+4AC^3+4B^3D_3.       \tag{1}
\end{aligned}
\]
For the ordinary cubic
\[
 AX^3+3BX^2Y+3CXY^2+D_3Y^3
\]
the usual polynomial discriminant is exactly \(-27K\).  Equation (1), not division by
\(-27\), is the integral divided-power definition.

The first modular gate changes the proposed theorem's geometry:
\[
 K_{\mathbf F_2}=(AD_3+BC)^2.                       \tag{2}
\]
Thus the discriminant hypersurface in
\(\mathbf P(\Gamma^3E)_{\mathbf F_2}\) is the doubled smooth quadric
\[
 2Q,\qquad Q:AD_3+BC=0,
\]
and \(Q\) is the reduced tangent developable of the twisted cubic.  Consequently
\[
 K_f=(N_s\circ L_f)^2
\]
for **every** characteristic-two syndrome \(f\), regardless of the rank or image type of
\(L_f\).  The proposed hyperelliptic branch model \(y^2=K_f\) is therefore a nonreduced
double graph and is never the required geometrically integral root-compatible cover.

This phenomenon is strictly larger than the frozen persistent and Lucas-nucleus carriers.
At degrees \(n=5,6,7,8\), the certificate gives syndromes outside those carriers whose
contraction ranks are respectively \(3,4,4,4\), whose middle catalecticants have rank three,
and for which \(N_s\circ L_f\ne0\).  Hence the universal square pullback is not a reformulation
of the known carrier boundary.

This fires C519's explicit stop rule: characteristic two changes the discriminant surface
scheme and produces a universal modular component.  No arbitrary-redundancy high-field
classification follows from the proposed \(y^2=K_f\) slices.  The correct characteristic-two
successor object is the Artin--Schreier cover
\[
 z^2+z=\frac{\Delta N_u}{N_s^2},\qquad z=\frac{\Delta t}{N_s},                 \tag{3}
\]
on the open \(\Delta N_s\ne0\).  Its trivial/inseparable/root-compatible locus is a different
classification problem and is not inferred from (2).  The replacement is nevertheless
generically nontrivial: the specialization \(B=0,C=1,D_3=1\) gives
\(\Delta=1,N_s=A,N_u=A\), hence the Artin--Schreier class \(1/A\).  Its simple pole at \(A=0\)
cannot occur in \(h^2+h\), so the generic target cover is geometrically integral.  The remaining
problem is specifically its Hankel/root-compatible pullback, not a universal degeneration of the
replacement cover.

There is a sharper intrinsic formulation.  The residual quadratic
\[
N_uX^2+N_sXY+\Delta Y^2
\]
is the divided Hessian of the contracted binary cubic \(L_f(P)\): the ordinary Hessian over
\(\mathbf Z\) is \(36\) times this form.  In characteristic two,
\(\Delta N_u/N_s^2\) is exactly its Arf invariant in
\(k/\{h^2+h\}\).  Thus the successor is a **Hessian--Arf pullback classification**, not an
unstructured Artin--Schreier elimination problem.

The second-order close recovers the genus-one architecture in the correct model.  If
\(P=R\lambda\) with \(\deg R=n-4\) fixed and \([\lambda]=[v:w]\) moving, then
\(L_f(R\lambda)\) is a projective line \(\ell_{f,R}\) in binary-cubic space.  The ordered residual
root incidence
\[
\mathcal C_{f,R}=
\{([\lambda],[r:s]):
\operatorname{Hess}^{\mathrm{div}}(L_f(R\lambda))(r,s)=0\}
\subset\mathbf P^1_\lambda\times\mathbf P^1_{r:s}             \tag{3a}
\]
has bidegree \((2,2)\): the cubic depends linearly on \(\lambda\), its Hessian quadratically,
and the Hessian is quadratic in \((r,s)\).  Hence \(\mathcal C_{f,R}\) has arithmetic genus one
in every characteristic.  In characteristic two this incidence curve, not \(y^2=K_f\), is the
correct separable Artin--Schreier model.  Its geometrically reducible/nonreduced locus is now an
explicit \((2,2)\)-curve classification for the constrained lines
\(\ell_{f,R}=L_f(\mathbf P(R E^\vee))\).

## 1. Intrinsic construction and transport

The pairing
\(\Gamma^nE\otimes\operatorname{Sym}^nE^\vee\to\mathcal O\) makes
\[
 L_f:\operatorname{Sym}^{n-3}E^\vee\longrightarrow\Gamma^3E
\]
the contraction \(P\mapsto\iota_Pf\).  In a divided-power frame it has the four displayed
coordinates \(H_{-1},H_0,H_1,H_2\).  Therefore \(L_f\) commutes with arbitrary base change and
the \(GL(E)\)-action.  The quartic \(K\) is the discriminant section of weight
\((\det E)^6\); it is degree four in \(f\), degree four in \(P\), and commutes with scalar
change and coefficientwise Frobenius.  These facts give the requested transport laws without
dividing by \(2\), \(3\), or \(27\).

Expanding the two \(2\times2\) residual minors gives (1) directly:
\[
\begin{aligned}
(AD_3-BC)^2
 -4(BD_3-C^2)(AC-B^2)
=A^2D_3^2-6ABCD_3-3B^2C^2+4AC^3+4B^3D_3.
\end{aligned}
\]
Substitution in the standard integral cubic-discriminant formula gives \(-27K\).
The evidence generator verifies both coefficient identities over \(\mathbf Z\) and after
reduction modulo \(2,3,5,7\).

The same minors are the cross product of the two Hankel rows
\((A,B,C)\) and \((B,C,D_3)\).  Hence
\[
A\Delta-BN_s+CN_u=0,\qquad
B\Delta-CN_s+D_3N_u=0.                                      \tag{2a}
\]
These are exactly the residual equations in homogeneous form.  Differentiating the ordinary
cubic twice gives
\[
\operatorname{Hess}(AX^3+3BX^2Y+3CXY^2+D_3Y^3)
=36(N_uX^2+N_sXY+\Delta Y^2).
\]
The divided expression remains meaningful in characteristics two and three, where the ordinary
second-derivative Hessian loses information.

## 2. Complete characteristic-two image classification

Over a characteristic-two field, write
\[
 M=AD_3+BC.
\]
Equation (2) gives \(K\circ L=M\circ L\,^2\) for every linear map \(L:V\to\Gamma^3E\).
The pullback vanishes identically exactly when the projective image of \(L\) lies in
\(Q=V(M)\).  Since \(Q\subset\mathbf P^3\) is a smooth hyperbolic quadric, this is equivalent
to one of:

- \(L=0\);
- \(\operatorname{rank}L=1\) and its image point lies on \(Q\); or
- \(\operatorname{rank}L=2\) and its image line is a line in one of the two rulings of \(Q\).

No map of rank at least three has identically zero pullback.  This is the complete zero/image-type
classification over a field.  The square classification is more drastic: every pullback is a
square, including the rank-three and rank-four cases.

The quadric is indeed the reduced tangent developable.  At
\([s^3:s^2t:st^2:t^3]\), a tangent direction has coordinates
\([s^2u:s^2v:t^2u:t^2v]\) in characteristic two.  Both the base point and every point of its
tangent line satisfy \(AD_3+BC=0\).  These lines sweep a two-dimensional irreducible subset of
the irreducible quadric, hence all of \(Q\).  Scheme-theoretically the discriminant remains
the double \(2Q\).

More precisely, the Segre coordinates
\[
[A:B:C:D_3]=[rv:rw:uv:uw]
\]
identify the twisted cubic with the graph
\[
([r:u],[v:w])=([v^2:w^2],[v:w])
\]
of Frobenius.  Because the differential of Frobenius is zero, its tangent lines are exactly one
ruling of \(Q\); the other ruling meets the graph in one geometric point.  Thus the two ruling
types in the zero-pullback classification have an intrinsic modular meaning rather than being
an undifferentiated family of contained lines.

The same geometry identifies the universal ordered-root cover.  For distinct
\([\ell_1],[\ell_2]\in\mathbf P(E)\) and \([\alpha:\beta]\in\mathbf P^1\),
\[
([\ell_1],[\ell_2],[\alpha:\beta])
\longmapsto
[\alpha\,\ell_1^{[3]}+\beta\,\ell_2^{[3]}]
\]
is the ordered-secant resolution of binary-cubic space.  Its total space is the rational
projective bundle
\(\mathbf P(\mathcal O(-3,0)\oplus\mathcal O(0,-3))\) over
\(\mathbf P^1\times\mathbf P^1\); swapping the two factors is the generic deck involution.
The roots of the divided Hessian are precisely \(\ell_1,\ell_2\), as follows by reducing
equivariantly to the cubic \(AX^3+D_3Y^3\).  Thus (3a) is the pullback of this universal ordered
secant cover along the root-compatible line.

For the residual quadratic itself, inseparability at a particular \(P\) is \(N_s(P)=0\), not
the statement that \(K_f\) is a square polynomial.  On \(\Delta N_s\ne0\), multiplying by
\(\Delta/N_s^2\) and setting \(z=\Delta t/N_s\) gives (3).  Rational splitting is controlled
by the Artin--Schreier trace class of \(\Delta N_u/N_s^2\).
Equivalently, this is the Arf invariant of the nonsingular divided Hessian.  Its class, rather
than the displayed representative, is intrinsic under \(GL_2\).

## 3. Separation from the frozen carriers

Use the middle catalecticant
\[
 C_f^{(2)}=(a_{i+j})_{\substack{0\le i\le2\\0\le j\le n-2}}.
\]
The persistent carrier is its rank-at-most-two locus.  The frozen characteristic-two modular
carriers are \(\mathbf P\langle e_2,e_3\rangle\) at \(n=5\),
the point \(e_3\) at \(n=6\), and no lift at \(n=7,8\).  The lexicographically first certificate
witnesses are:

| \(n\) | \(f=(a_0,\ldots,a_n)\) | \(\operatorname{rank}L_f\) | \(\operatorname{rank}C_f^{(2)}\) |
|---:|---|---:|---:|
| 5 | `(1,0,1,0,0,0)` | 3 | 3 |
| 6 | `(1,0,1,0,0,0,0)` | 4 | 3 |
| 7 | `(0,0,1,0,0,0,0,0)` | 4 | 3 |
| 8 | `(0,0,1,0,0,0,0,0,0)` | 4 | 3 |

Each lies outside the stated modular carrier and has \(N_s\circ L_f\ne0\).  Nevertheless its
\(K_f\) is a square by (2).  Thus the square locus is the entire characteristic-two syndrome
space, while the frozen carrier union is proper at every calibration level.

## 4. Characteristic three

Characteristic three also requires its own scheme statement, although it does not cause the
same square collapse:
\[
 K=A^2D_3^2+AC^3+B^3D_3.                                    \tag{4}
\]
As a primitive quadratic in \(A\), (4) has discriminant
\[
 (C^2-BD_3)^3.
\]
The irreducible factor \(C^2-BD_3\) has odd valuation, so this discriminant is not a square in
\(\overline{k}(B,C,D_3)\).  Gauss' lemma proves that (4) is geometrically irreducible.

Its singular scheme is
\[
 C^3-AD_3^2=0,\qquad B^3-A^2D_3=0.                           \tag{5}
\]
Set-theoretically over an algebraic closure, (5) is the twisted cubic
\([s^3:s^2t:st^2:t^3]\), but (5) is a Frobenius-thickened complete intersection rather than
the reduced twisted-cubic ideal.  Thus characteristic three preserves an irreducible quartic
while changing its singular scheme.  Also, the ordinary cubic discriminant \(-27K\) vanishes
identically there, which is why the divided-power formula (1) must be retained.

## 5. Divisors and rational lifting table

The obstruction is recorded before any Hasse--Weil estimate.  Every future replacement must
retain:

| locus | equation | semantics |
|---|---|---|
| residual determinant | \(\Delta=0\) | the two-by-two solve ceases to be unique |
| odd-characteristic branch | \(K=0\) | residual roots coincide when \(2\) is invertible |
| characteristic-two inseparability | \(N_s=0\) | derivative of the residual quadratic vanishes |
| fixed repeated root | \(\operatorname{Disc}(P)=0\) | fixed factor is not squarefree |
| fixed/residual collision | \(\operatorname{Res}(P,\Delta t^2-N_st+N_u)=0\) | \(P\) and \(Q\) share a root |
| ordering torsor | ordered roots of \(P\) | a rational coefficient point need not be a rational split factor |

Off these loci, odd-characteristic residual splitting is the Kummer square class of \(K\);
characteristic-two splitting is the Artin--Schreier trace class in (3).  A rational point on
either quotient cover still has to lift through the ordered-root torsor.

## 6. Exact boundary and successor gate

C519 proves the integral intrinsicization and the complete modular obstruction theorem, then
stops exactly where its task card requires.  It does **not** claim:

- an odd-characteristic classification of all Hankel pullbacks for arbitrary \(n\);
- that a square \(K_f\) in characteristic two makes the residual quadratic split;
- a root-compatible geometrically integral slice for the Artin--Schreier cover; or
- an arbitrary-redundancy PRS high-field theorem.

The next theorem gate is two-part:

1. classify when \(\Delta N_u/N_s^2\) is Artin--Schreier-trivial or inseparable on every
   root-compatible pencil in characteristic two, and compare that locus with the persistent/Lucas
   carriers; intrinsically this is the Hessian--Arf pullback problem, and the ambient class is
   already known to be nontrivial by the \(1/A\) specialization.  Equivalently, classify the
   reducible and nonreduced members of the constrained \((2,2)\) family (3a); and
2. continue the odd-characteristic zero/square pullback and root-compatible-line classification,
   retaining the characteristic-three thickened singular scheme.

That work is unallocated.  C518's modular-TRS residual system is not used.

## Evidence and replay

The atomic compact bundle is:

- `notes/2026-07-23-c519-universal-residual-discriminant.py`;
- `notes/2026-07-23-c519-universal-residual-discriminant.json`;
- `notes/2026-07-23-c519-universal-residual-discriminant-replay.py`; and
- `notes/2026-07-23-c519-universal-residual-discriminant.sha256`.

From the repository root:

```text
python3 notes/2026-07-23-c519-universal-residual-discriminant.py \
  --output notes/2026-07-23-c519-universal-residual-discriminant.json --check
python3 notes/2026-07-23-c519-universal-residual-discriminant-replay.py
(cd notes && sha256sum -c 2026-07-23-c519-universal-residual-discriminant.sha256)
```

The generator uses only the Python standard library.  It performs exact sparse-polynomial
coefficient arithmetic, checks the integral and modular identities, and exhausts the nonzero
binary syndrome vectors only until it finds the first carrier-separating witness at each of
\(n=5,6,7,8\).  The JSON records the exact matrices and ranks.  The independent replay uses
dense evaluation over all \(2^4+3^4+5^4+7^4=3123\) four-tuples and a separate bit-row reduction.
The load-bearing byte counts are `11125` for the generator, `7794` for the JSON certificate, and
`3468` for the replay.
It does not prove the geometric quadric or characteristic-three irreducibility arguments; those
are the displayed hand proofs.

## Extra-juice closeout

The free closeout upgrade is stronger than merely noticing a bad reduction:

- the characteristic-two discriminant scheme is exactly a doubled smooth quadric;
- its reduced quadric is exactly the tangent developable;
- the zero pullbacks have a complete rank/ruling classification;
- the square pullback locus is the whole characteristic-two syndrome space;
- four explicit full-rank calibration witnesses prove that this is larger than every frozen
  carrier boundary; and
- the correct replacement cover and its rational lifting class are explicit in (3);
- the two quadric rulings are separated by the Frobenius-graph model of the twisted cubic; and
- the specialization \(1/A\) proves that the generic Artin--Schreier replacement is geometrically
  integral; and
- the residual factor is identified as the divided Hessian, making the Artin--Schreier class its
  intrinsic Arf invariant; and
- root-compatible pullback is recast as an explicit \((2,2)\) divided-Hessian incidence curve,
  restoring the exact genus-at-most-one slice architecture in characteristic two.

This makes the obstruction constructive: the next task does not need to rediscover the residual
coordinate or the deletion semantics.

## Mystery ledger

Settled:

- **Is the integral quartic really the divided-power binary-cubic discriminant?** Yes; (1) and
  the identity \(\operatorname{Disc}(AX^3+3BX^2Y+3CXY^2+D_3Y^3)=-27K\) hold over \(\mathbf Z\).
- **What happens in characteristic two?** The quartic is the double quadric
  \((AD_3+BC)^2\), so every pullback is a square.
- **Is that square locus just the known modular carrier?** No; the rank-three/four calibration
  witnesses lie outside all frozen persistent and characteristic-two nucleus carriers.
- **Does characteristic three also factor?** No; its quartic is geometrically irreducible, but
  its singular scheme is Frobenius-thickened.
- **Is the characteristic-two replacement generically vacuous?** No.  The specialization
  \(B=0,C=1,D_3=1\) has Artin--Schreier class \(1/A\), whose simple pole proves nontriviality.
- **What classical covariant owns the replacement?** The residual quadratic is the divided
  Hessian, and its characteristic-two splitting class is the Arf invariant.
- **Does the genus-one method survive the doubled-discriminant collapse?** Yes, but only after
  replacing \(y^2=K_f\) by the ordered divided-Hessian incidence (3a), a \((2,2)\) curve of
  arithmetic genus one.

Open, with exact gate:

- **Characteristic-two root-compatible integrality.** Evidence gap: no classification of the
  Artin--Schreier class \(\Delta N_u/N_s^2\) on the ordered split-root parameter space.  Gate:
  classify the divided-Hessian Arf invariant on the image of the root-compatible Hankel map,
  including poles, collisions, and carrier containment.  The generic target class itself is
  already nontrivial.  Equivalently, classify reducible and nonreduced members of (3a); arbitrary
  lines remain insufficient unless they are proved to equal \(L_f(\mathbf P(R E^\vee))\).
- **Odd-characteristic pullback base locus.** Evidence gap: the square/zero classification for
  Hankel image subspaces and the proof that some root-compatible pencil has integral reduced
  branch.  Gate: a scheme-theoretic image-subspace classification followed by the ordered-root
  line lemma.

No mystery remains about why the proposed characteristic-free hyperelliptic slice cannot prove
the requested arbitrary-redundancy theorem.

## Literature boundary

The adjacent delta audit
`notes/2026-07-23-c519-universal-residual-discriminant-literature-audit.md` makes no priority claim
for the classical cubic discriminant, twisted-cubic tangent developable, modular invariant theory,
Artin--Schreier splitting, or the frozen PRS carrier results.  C519's durable contribution is the
exact obstruction and task-boundary diagnosis above.
