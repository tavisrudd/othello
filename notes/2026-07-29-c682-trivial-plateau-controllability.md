# C682 trivial-module plateau controllability

Date: 2026-07-29

## Theorem

At every nontrivial trivial-module plateau entrance
\[
n=64+60q,\qquad q\geq1,
\]
the first upward return
\[
U_n=\Delta_n^\dagger\Delta_n
\]
mixes the incoming hyperplane
\[
L_n=\operatorname{im}\Delta_{n-6}\subset M_{\mathbf1,n}
\]
with its missing direction.  Consequently the recurring
\(1\to2^6\to3\) pattern is no longer an unanchored plateau: once the
multiplicity-\(q\) corner on the left is full, the entrance corner of
dimension \(q+1\) is full, and the square edges transport fullness across
the plateau.

This closes the first exact obstruction found by the multiplicity-induction
audit.  It does not yet treat the \(2,3,3'\) plateau families or prove
all-weight maximal rank away from this family.

## Invariant-ring coordinates

Write
\[
R=\mathbf Q[F,h],\qquad t^2=1728F^5-h^3,
\qquad \deg(F,h,t)=(12,20,30).
\]
At \(n=64+60q\), the trivial isotypic multiplicity space has basis
\[
v_j=F^{2+5j}h^{2+3(q-j)},\qquad 0\leq j\leq q.
\]
The preceding multiplicity space has basis
\[
w_j=tF^{4+5j}h^{3(q-j)-1},\qquad 0\leq j<q.
\]
The third transvectant \(D=(\,\cdot\,,F)_3\) sends the \(w_j\) to a
rank-\(q\) banded family in the \(v_j\).  Thus
\[
L_q=\langle Dw_0,\ldots,Dw_{q-1}\rangle
\]
is a hyperplane in the \((q+1)\)-space \(M_q\).

Let \(\ell_q\) be the unique coordinate covector annihilating \(L_q\),
normalized by \(\ell_q(v_q)=1\).  It is enough to find one \(a\in L_q\)
with \(\ell_q(U_na)\ne0\).

## Fixed-width boundary witness

With the Fischer pairing, monomial duality gives the degree-independent
identity
\[
\boxed{\qquad
\Delta_n^\dagger=-\frac1{60480}(\,\cdot\,,F)_9.
\qquad}
\]
For example, comparing the \(x^{n-2}y^8\to x^n\) entry fixes the scalar;
the general identity follows entrywise from the transvectant formula.
Take the last incoming vector \(a_q=Dw_{q-1}\) and define
\[
W(q)=
\ell_q\!\left(((w_{q-1},F)_3,F)_3,F)_9\right).
\]
Equivalently, the inner third transvectant forms \(a_q\), and the outer
third-then-ninth pair is the first upward return.

Only the last four \(v_j\)-coordinates enter this expression.  The
coefficients of \(Dw_j\) have degree at most \(3\) in \(q\), while the four
boundary-return coefficients have degree at most \(15\): three from the
incoming vector and twelve from the two return transvectants.  Exact
evaluation at \(q=6,\ldots,21\) therefore determines the return
coefficients uniquely, and the three-term boundary recurrence for
\(\ell_q\) gives an exact rational function
\[
W(q)=\frac{N(q)}{D(q)}.
\]

The raw recurrence expression has numerator degree \(33\) and denominator
degree \(21\), but they share an exact degree-\(18\) factor.  After
cancellation, \(N\) has degree \(15\) and \(D\) degree \(3\).  The
certificate records all reduced coefficients.

After writing \(q=r+6\), \(N(r+6)\) has \(16\) strictly negative
coefficients and \(D(r+6)\) has \(4\) strictly positive coefficients.
Both absolute coefficient sequences are strictly ultra-log-concave.
More strongly, exact Sturm arithmetic proves that the reduced numerator
has \(15\) distinct negative real roots and the denominator has \(3\);
none lies in \((-5,0)\).  Thus every zero and pole occurs at \(q<1\), and
\[
W(q)\ne0
\qquad\text{for every real }q\ge1.
\]
The five direct exact checks at \(q=1,\ldots,5\) remain independent
low-parameter witnesses but are no longer needed to bridge the proof.

The exact chamber counts make the real threshold sharp.  The numerator
roots in the \(q\)-coordinate are distributed as
\[
\begin{array}{c|ccc}
\text{interval}&(-3,-2)&(-2,-1)&(0,1)\\ \hline
\#\text{ numerator roots}&1&13&1,
\end{array}
\]
while the denominator has \(2,1,0\) roots in the same intervals.  In
particular, the analytic continuation has one zero in \(0<q<1\)
(numerically \(q\approx0.3911251864\)).  Hence the root-free ray
\(q\ge1\) cannot be enlarged to \(q\ge0\).

The denominator has the exact factorization
\[
D(q)=\frac12(10q+17)(10q+22)(10q+27).
\]
Thus its poles form the arithmetic progression
\[
-\frac{27}{10},\quad-\frac{11}{5},\quad-\frac{17}{10}.
\]
Euclidean division writes the witness as a degree-\(12\) polynomial bulk
term plus a proper degree-\(2\)-over-degree-\(3\) boundary correction.
The exact residues at the three ordered poles have signs
\[
-,+,-.
\]
Consequently this is not a positive Stieltjes or diagonal Weyl function.
It has instead the sign pattern expected of an off-diagonal Green
function or a signed symmetrizable transfer pencil.

The algebra step is elementary.  The full supported algebra
\(\operatorname{End}(L_q)\), together with a self-adjoint operator having a
nonzero \(L_q\)-to-\(L_q^\perp\) block, generates
\(\operatorname{End}(M_q)\): the off-diagonal block and its adjoint give
matrix units between \(L_q\) and its missing line, while
\(\operatorname{End}(L_q)\) supplies the remaining units.

## Reproducibility

The atomic evidence bundle is:

- `2026-07-29-c682-plateau-controllability.py`;
- `2026-07-29-c682-plateau-controllability.json`;
- `2026-07-29-c682-plateau-controllability-replay.py`.

From `rust/`, run

```text
python3 ../notes/2026-07-29-c682-plateau-controllability.py --check
python3 ../notes/2026-07-29-c682-plateau-controllability-replay.py
```

The primary checker uses exact integer and rational transvectants.  It
constructs the invariant bases, verifies the five low-\(q\) witnesses,
interpolates within the proved degree bounds, and checks the shifted
coefficient signs, exact gcd cancellation, strict ultra-log-concavity, and
Sturm root counts.  It also checks the exact Fischer-adjoint identity at
degrees \(64\) and \(124\).

The replay independently reconstructs \(F,h,t\) from dense modular
transvectants.  At both \(\mathbf F_{1000000007}\) and
\(\mathbf F_{1000000009}\), it checks the five low-\(q\) witnesses and
verifies the recorded rational function at the out-of-sample values
\(q=22,23\).  It separately reconstructs and checks
\(\Delta_n^\dagger=-(\,\cdot\,,F)_9/60480\) at degrees \(64,124\).

The load-bearing exact engines are
`2026-07-28-c682-klein-e8-free-covariant.py` and
`2026-07-28-c682-klein-e8-first-failure-replay.py`.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-29-c682-plateau-controllability.py` | 29720 | `704b95bc4fa2ceb490d8b51ec7b4bef80d15a0b63712256922e2fb5289b8ba50` |
| `2026-07-29-c682-plateau-controllability.json` | 5327 | `59c395f29b20ede03b389f99e85b6933dafe4da923eaa091f4a0f81c0188e540` |
| `2026-07-29-c682-plateau-controllability-replay.py` | 8754 | `a2270c3e27eb9054829dcfc9de0e8b70b2943a229dd3b48f00cfe087288c0bf0` |
| `2026-07-28-c682-klein-e8-free-covariant.py` | 26315 | `df6d46f2969270814fe9e552da2238bd6de9ff36ebaddb3081c0143014ec8103` |
| `2026-07-28-c682-klein-e8-first-failure-replay.py` | 15046 | `67e08902c944aeaca6eef458107bd6022eb7e3b2cfcaffc1381e5884d516669c` |

## `ej` + `tt` closeout

The cheap strengthening is that the first upward return alone supplies the
missing matrix unit; the second upward return and the full collection of
twenty-one peak minors are unnecessary for this family.

The normalization ambiguity also disappears for free:
\(\Delta_n^\dagger=-(\,\cdot\,,F)_9/60480\) with one scalar in every
degree.  Thus the boundary rational function is an exact normalization of
the actual Fischer return, not merely a nonzero surrogate.
Moreover
\[
60480=2^6\,3^3\,5\,7.
\]
The extra prime \(7\) enters only when the integral ninth transvectant is
converted to the Fischer adjoint.  This gives a concrete normalization
source for the previously apparent prime-\(7\) operator issue; it does not
add \(7\) to the structural bad-prime set of the normalized integral
package.

The structural object is a fixed-width boundary control problem on the
Kostant free module.  Although the plateau dimension grows with \(q\), the
mixing witness sees only four boundary coordinates, and differential order
turns the infinite family into one reduced degree-\(15\)-over-degree-\(3\)
certificate.  This is the template to test on the \(2,3,3'\) free modules.

There is also a useful consistency check.  Before cancellation the degree
gap is \(33-21=12\); after cancellation it is \(15-3=12\), exactly the
total differential order of the third-then-ninth return.

The stronger second-order pattern is now certified rather than guessed:
the reduced shifted numerator and denominator are real-rooted with all
roots strictly left of \(r=-5\), and their coefficient sequences are
strictly ultra-log-concave.  A conceptual Pólya-frequency,
total-positivity, or hypergeometric explanation could make the extension
to the other Kostant modules much shorter than repeating interpolation.

The third-order clue is the highly constrained \(1|13|1\) numerator-root
distribution across the three virtual-multiplicity chambers.  Together
with the \(2|1|0\) pole distribution, this resembles the spectrum of a
finite Jacobi matrix more than a generic real-rooted polynomial.  An
orthogonal-polynomial or continued-fraction realization would explain the
root wall, ultra-log-concavity, and rational transfer denominator at once.

The `tt` correction is to avoid fitting a named orthogonal polynomial from
root plots.  The annihilator already satisfies a three-term recurrence, so
the proof-design target is its symmetrizable matrix pencil.  The
degree-\(12\) quotient is the bulk differential contribution; the three
equally spaced poles are the boundary state; and the alternating residues
show that the mixing witness is an off-diagonal, not positive diagonal,
matrix element.  A discrete Sturm oscillation or inertia calculation on
that pencil should explain the \(1|13|1\) chambers.  For \(2,3,3'\), the
corresponding object should be a block Jacobi pencil rather than three
unrelated scalar interpolations.

A naïve floating-point sign scan of the degree-\(15\) polynomial in the
monomial basis was numerically unstable and produced spurious crossings.
It is explicitly non-evidence.  All root and chamber statements above use
exact rational Sturm arithmetic.

## Mystery ledger

- **Settled:** the recurring trivial-module plateau has a noncircular
  entrance anchor for every \(q\ge1\).
- **Settled by `ej`:** \(U_n\) alone mixes the incoming hyperplane.
- **Settled by `ej`:** the ninth-transvectant model of the Fischer adjoint
  has the exact degree-independent scalar \(-1/60480\).
- **Settled by `ej`:** the prime \(7\) in that scalar is a
  Fischer-normalization denominator, consistent with its earlier removal
  from the structural bad-prime set.
- **Settled by `tt`:** the growing matrix problem collapses to a
  fixed-width boundary covector and one rational function.
- **Settled by `ej`:** the degree gap \(33-21=12\) matches the return
  operator's differential order and survives the degree-\(18\)
  cancellation as \(15-3=12\).
- **Settled by `ej2`:** the apparent high degrees contained a common
  degree-\(18\) recurrence factor.
- **Settled by `ej2`:** the reduced numerator and denominator have,
  respectively, \(15\) and \(3\) distinct real roots, all at \(q<1\).
  Hence the witness is nonzero on the full real ray \(q\ge1\).
- **Settled by `ej3`:** the wall \(q\ge1\) is sharp for the real
  continuation: there is exactly one numerator root in \((0,1)\).
- **Settled by `ej3`:** the remaining roots have exact chamber counts
  \(1|13|1\) for the numerator and \(2|1|0\) for the denominator.
- **Settled by `tt`:** the cubic boundary denominator is exactly
  \((10q+17)(10q+22)(10q+27)/2\), and the witness splits into an
  order-\(12\) polynomial bulk plus a three-pole boundary correction.
- **Rejected by `tt`:** a positive Stieltjes/diagonal-Weyl interpretation.
  The exact residue signs are \(-,+,-\).
- **Open structural explanation:** why the reduced polynomials form strict
  ultra-log-concave, negative-real-rooted coefficient sequences.  The
  present proof is exact Sturm arithmetic; a signed symmetrizable Jacobi
  pencil and its block versions belong to the \(2,3,3'\) extension.
- **Still open:** construct the corresponding boundary witnesses for the
  \(2,3,3'\) Kostant modules.
- **Still open:** prove all-weight maximal rank away from the explicitly
  controlled plateau entrances, or replace that requirement.

No all-weight full-corner theorem or novelty claim is made.
