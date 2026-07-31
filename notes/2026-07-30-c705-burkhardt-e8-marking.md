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

This also explains why the ambient Coble construction and its rational
\(\tau_+\) section can agree over \(\mathbf Q\) while a literal ordered
Joubert-coordinate equality does not: the latter asks for strictly more
marking data.

## What remains

The next exact gate is now finite and correctly based:

- work in the splitting algebra of the displayed sextic;
- choose an ordering \(r_1,\ldots,r_6\);
- evaluate C704's six Joubert cubics \(Z_T(r_1,\ldots,r_6)\);
- compare their centered squares with the Igusa coordinates obtained from
  the tangent/polar construction at \(\alpha\);
- verify \(S_6\)-equivariance, so the result descends independently of the
  chosen sheet.

No new Lie-theoretic ambient is needed for this gate.  A purported
\(\mathbf Q\)-valued ordered equality would be incorrectly posed.

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
curve and Rabin/Frobenius gcd tests to recover the three modular
factor-degree patterns.  The independent replay uses exhaustive trial
division through half the degree at \(p=17\), a separate trial-division
check at \(p=7\), and explicit linear divisions plus the quadratic
discriminant at \(p=1303\).

Checksums are recorded in
`notes/2026-07-30-c705-burkhardt-e8-marking.sha256`.

## Mystery ledger

- **Settled:** whether the frozen Burkhardt point admits the strict
  Lie-\(E_8\)/Joubert comparison at all.  It does, on the ordered
  Weierstrass cover.
- **Settled:** why the ordered tensor was not visible over \(\mathbf Q\).
  The branch polynomial has full \(S_6\) Galois group.
- **Open:** the explicit sheetwise equality between the Vinberg-derived
  marking and C704's Joubert tensor.  Its exact evidence gate is the
  splitting-algebra computation above.
- **Open:** whether that sheetwise calculation yields a shorter
  coordinate-free descent statement.  This remains owned by C705 after
  the finite comparison, not by a new ambient-Lie task.
