# C705 — the frozen Burkhardt point and the Lie-\(E_8\) marking torsor

## Verdict

The genuine Lie-\(E_8\) comparison is possible, but the strict ordered
comparison is not defined over \(\mathbf Q\) for the frozen Burkhardt point
\[
 \alpha=(6:17:1:-7:-19).
\]
It becomes defined after pullback to the ordered-Weierstrass torsor.  For
this specialization that torsor has Galois group \(S_6\) and degree \(720\).
Thus the remaining gap is not a missing ambient \(E_8\) construction: it is
an explicit finite descent/comparison problem on an \(S_6\)-cover.

The weaker Vinberg construction needing one marked Weierstrass point is
already available over a degree-six field.  No rational Weierstrass point
exists.

## Exact specialization

Bruin--Nasserden, Proposition 2.5, gives the universal genus-two curve over
the Burkhardt quartic in the form
\[
 y^2+G_3y=\lambda_3H_3^3 .
\]
Normalize \(\alpha_0=1\), so that
\[
 (\alpha_1,\alpha_2,\alpha_3,\alpha_4)
 =\left(\frac{17}{6},\frac16,-\frac76,-\frac{19}{6}\right).
\]
For the frozen point their formulas specialize, after \(z=1\), to
\[
\begin{aligned}
H_3(x)&=\frac{323}{36}+\frac76x+\frac16x^2,\\
G_3(x)&=-\frac{228327182531}{5038848}
       +\frac{290630599}{93312}x
       -\frac{694731583}{559872}x^2
       -\frac{78226463}{93312}x^3,\\
\lambda_3&=-\frac{1543199529524471}{2176782336}.
\end{aligned}
\]
Completing the square gives the branch sextic
\[
 (2y+G_3)^2=G_3^2+4\lambda_3H_3^3.
\]
Its primitive integral polynomial, in ascending coefficient order, is
\[
\begin{split}
(&295130390826722844,\,
-62251283304984120046,\,
-5519843141820561948,\\
&1960910801972693616,\,
-445189061771697891,\,
103910980411175652,\,
39706983135965148).
\end{split}
\]

## The \(S_6\) certificate

The square-free factor-degree patterns at three good primes are
\[
\begin{array}{c|c}
p&\text{degrees}\\ \hline
7&1+5\\
17&6\\
1303&1+1+1+1+2.
\end{array}
\]
Irreducibility modulo \(17\) proves irreducibility over \(\mathbf Q\) and
supplies a six-cycle.  The other two patterns supply a five-cycle and a
transposition.  The five-cycle excludes both possible nontrivial block
systems of a transitive degree-six group (blocks of size \(2\) or \(3\)).
The group is therefore primitive; a primitive permutation group containing
a transposition is the full symmetric group.  Hence
\[
 \operatorname{Gal}(f_\alpha/\mathbf Q)=S_6.
\]

This has three precise consequences.

1. The curve has no rational Weierstrass point.
2. Choosing one Weierstrass point requires a degree-six extension.  Over
   that field, sending the chosen branch point to infinity puts the curve
   into the marked genus-two normal form used by Rains--Sam and hence gives
   the stable trivector in the Vinberg grading
   \(\mathfrak e_8=\mathfrak{sl}_9\oplus\Lambda^3 9\oplus\Lambda^6 9\).
3. C704's frozen Joubert tensor uses an ordering of all six branch points.
   That ordering lives on the \(S_6\)-torsor of degree \(6!=720\).  It
   cannot be compared as an ordered tensor over \(\mathbf Q\); only its
   \(S_6\)-descent, such as the Segre--Igusa point, is rational.

## Explicit marked Vinberg trivector

The degree-six statement is constructive, not just existential.  Put
\[
 K=\mathbf Q[r]/(f_\alpha(r)),\qquad D=f_\alpha'(r).
\]
The change of variables
\[
 t=-\frac{D}{x-r},\qquad X=\frac{y\,t^3}{D}
\]
sends the chosen branch point \(r\) to infinity without adjoining a square
root.  Direct expansion in \(K[t]\) gives
\[
 X^2+t^5+c_6t^4+c_{12}t^3+c_{18}t^2+c_{24}t+c_{30}=0,
\]
where
\[
\begin{aligned}
c_6&=-\frac12f_\alpha''(r),&
c_{12}&=\frac16D f_\alpha'''(r),\\
c_{18}&=-\frac1{24}D^2f_\alpha^{(4)}(r),&
c_{24}&=\frac1{120}D^3f_\alpha^{(5)}(r),\\
c_{30}&=-\frac1{720}D^4f_\alpha^{(6)}(r).
\end{aligned}
\]
These are exactly the coefficients in Rains--Sam's characteristic-zero
normal form.  Consequently the frozen curve has the explicit stable
trivector over \(K\)
\[
\begin{split}
\gamma_r={}&[267]+[258]+[348]+[169]+[357]+[249]+[178]+[456]\\
&-c_6[247]-c_{12}[147]+c_{18}[145]+c_{24}[134]+c_{30}[123].
\end{split}
\]
The certificate records each \(c_i\) in the power basis
\(1,r,\ldots,r^5\) and verifies the root-to-infinity identity
coefficientwise in \(K[t]\).  Rains--Sam Proposition 2.13 makes
\(\gamma_r\) stable because the branch sextic is square-free.

This also explains why the ambient Coble construction and its rational
\(\tau_+\) section can agree over \(\mathbf Q\) while a literal ordered
Joubert-coordinate equality does not: the latter asks for strictly more
marking data.

## Intrinsic obstruction and positive repair

The stable trivector does not itself supply the full ordering.  The
forgetful map
\[
 \{\text{ordered six Weierstrass points}\}\longrightarrow
 \{\text{one marked Weierstrass point}\}
\]
is an \(S_5\)-torsor.  Since the frozen sextic has Galois group \(S_6\),
the normal closure over \(K=\mathbf Q(r)\) has Galois group
\(\operatorname{Stab}_{S_6}(r)=S_5\).  Thus the remaining five points
cannot be ordered over \(K\), and no functorial rule using the rational
Burkhardt level-\(3\) data can produce C704's ordered Joubert marking.
Indeed, that level-\(3\) data is already rational while the level-\(2\)
ordering has the certified full \(S_6\) monodromy.

This is the minimal obstruction.  The exact positive repair is to add full
level-\(2\) structure, equivalently to pass from \(K\) to the residual
degree-\(120\) ordered splitting torsor.  On a chosen sheet one may:

- work in the splitting algebra of the displayed sextic;
- choose an ordering \(r_1,\ldots,r_6\);
- evaluate C704's six Joubert cubics \(Z_T(r_1,\ldots,r_6)\);
- compare their centered squares with the Igusa coordinates obtained from
  the tangent/polar construction at \(\alpha\);
- verify \(S_6\)-equivariance, so the unordered polar diagram descends
  independently of the chosen sheet.

That computation can compare chosen coordinates, but it cannot upgrade
them to an intrinsic ordered parent: changing the sheet acts by the full
residual \(S_5\).  No new Lie-theoretic ambient is needed, and a purported
\(\mathbf Q\)-valued ordered equality would be incorrectly posed.

The chosen-sheet repair and the Lie-\(E_8\)-to-frozen-Coble orbit mechanism
have subsequently been completed in
`notes/2026-07-30-c705-lie-e8-completion.md`.  This does not alter the
intrinsic obstruction: it verifies every sheet and proves the common
projective orbit while retaining the necessary level-\(2\) choice.

## `ej` + `tt` closeout

The cheap extra-juice gain is that the marked Vinberg representative needs
no accidental quadratic extension: scaling the root-to-infinity
coordinate by \(-f_\alpha'(r)\) makes the quintic leading coefficient
exactly \(-1\).  Thus degree \(6\), rather than a loose degree-\(12\)
bound, is sharp for the one-point normal form.

The structural closeout separates two moduli problems that coordinates can
blur.  Burkhardt supplies level-\(3\) data; ordered Weierstrass points are
full level-\(2\) data.  The certified \(S_6\) monodromy proves that the
former does not secretly trivialize the latter.  After one point is
chosen, the exact defect is the stabilizer \(S_5\), not an unexplained
normalization scalar or a missing \(E_8\) representation.  This settles
the intrinsic claim and identifies its minimal positive locus.

## Literature boundary

- Nils Bruin and Brett Nasserden, *Arithmetic aspects of the Burkhardt
  quartic threefold*, arXiv:1705.09006, especially Proposition 2.5 and
  §§7.4--7.5.  Cached PDF SHA-256:
  `e4d84263b04294adea81aecce0232e359c4a0ed03855c00e57315c5a4224bc3a`.
- Eric Rains and Steven Sam, *Invariant theory of \(\bigwedge^3(9)\) and
  genus 2 curves*, arXiv:1702.04840, especially Proposition 2.1 and the
  \(E_8\) order-three grading.  Cached PDF SHA-256:
  `4c46b1edef9252cae1917d9d4fbc91607ae792aafa895ccfae47d5b39dc56296`.

The result here is an exact specialization and group certificate, not a
novelty or priority claim.

## Reproducibility

Primary exact replay:

```sh
cd /home/tavis/src/othello
python3 notes/2026-07-30-c705-burkhardt-e8-marking.py --check
```

Independent factorization replay:

```sh
cd /home/tavis/src/othello
python3 notes/2026-07-30-c705-burkhardt-e8-marking-replay.py
```

The first script uses exact rational arithmetic to specialize the universal
curve, Rabin/Frobenius gcd tests to recover the three modular factor-degree
patterns, and arithmetic in \(\mathbf Q[r]/(f_\alpha)\) to construct and
verify the marked Vinberg normal form.  The independent replay uses
exhaustive trial division through half the degree at \(p=17\), a separate
trial-division check at \(p=7\), explicit linear divisions plus the
quadratic discriminant at \(p=1303\), and a separately coded normal-form
identity in \(\mathbf F_{17}[r]/(f_\alpha)\).

Checksums are recorded in
`notes/2026-07-30-c705-burkhardt-e8-marking.sha256`.

## Mystery ledger

- **Settled:** whether the frozen Burkhardt point admits the strict
  Lie-\(E_8\)/Joubert comparison at all.  It does, on the ordered
  Weierstrass cover.
- **Settled:** why the ordered tensor was not visible over \(\mathbf Q\).
  The branch polynomial has full \(S_6\) Galois group.
- **Settled:** whether the degree-six field merely proves existence.  No:
  the displayed derivative formulas give the stable trivector explicitly.
- **Settled negatively:** a Vinberg one-point marking cannot intrinsically
  recover C704's ordered tensor; the residual torsor has full group
  \(S_5\).
- **Settled:** the nearest positive locus is full level-\(2\) marking, a
  residual degree-\(120\) base change.  Any sheetwise coordinate equality
  there is a chosen trivialization, not missing intrinsic C705 structure.
