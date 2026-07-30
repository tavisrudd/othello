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

With the Fischer pairing, \(\Delta_n^\dagger\) is a nonzero
degree-dependent scalar multiple of the ninth transvectant
\((\,\cdot\,,F)_9\).  The scalar is irrelevant to mixing.  Take the last
incoming vector \(a_q=Dw_{q-1}\) and define
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

The certificate records all coefficients.  After writing \(q=r+6\),
\[
N(r+6)
\]
has \(34\) strictly negative coefficients and
\[
D(r+6)
\]
has \(22\) strictly positive coefficients.  Hence \(W(q)\ne0\) for every
integer \(q\ge6\).  Direct exact calculations give \(W(q)\ne0\) for
\(q=1,\ldots,5\).  This proves the theorem for every \(q\ge1\).

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
coefficient signs.

The replay independently reconstructs \(F,h,t\) from dense modular
transvectants.  At both \(\mathbf F_{1000000007}\) and
\(\mathbf F_{1000000009}\), it checks the five low-\(q\) witnesses and
verifies the recorded rational function at the out-of-sample values
\(q=22,23\).

The load-bearing exact engines are
`2026-07-28-c682-klein-e8-free-covariant.py` and
`2026-07-28-c682-klein-e8-first-failure-replay.py`.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-29-c682-plateau-controllability.py` | 20812 | `3f0c7cf4995dc520adda789d73073fb757ef6d0f9d49ebe7aa357a17cb826958` |
| `2026-07-29-c682-plateau-controllability.json` | 8790 | `20cbf5b2cc1dcaf5d55e3f58832ab40226f5cdb6e2ab5914860e50631dc19777` |
| `2026-07-29-c682-plateau-controllability-replay.py` | 7786 | `5a958f068af7eff40a272c41e9d0e258ff2b968490860da4bcdbcaa9e3a5a5b5` |
| `2026-07-28-c682-klein-e8-free-covariant.py` | 26315 | `df6d46f2969270814fe9e552da2238bd6de9ff36ebaddb3081c0143014ec8103` |
| `2026-07-28-c682-klein-e8-first-failure-replay.py` | 15046 | `67e08902c944aeaca6eef458107bd6022eb7e3b2cfcaffc1381e5884d516669c` |

## `ej` + `tt` closeout

The cheap strengthening is that the first upward return alone supplies the
missing matrix unit; the second upward return and the full collection of
twenty-one peak minors are unnecessary for this family.

The structural object is a fixed-width boundary control problem on the
Kostant free module.  Although the plateau dimension grows with \(q\), the
mixing witness sees only four boundary coordinates, and differential order
turns the infinite family into one degree-\(33\) sign certificate.  This is
the template to test on the \(2,3,3'\) free modules.

## Mystery ledger

- **Settled:** the recurring trivial-module plateau has a noncircular
  entrance anchor for every \(q\ge1\).
- **Settled by `ej`:** \(U_n\) alone mixes the incoming hyperplane.
- **Settled by `tt`:** the growing matrix problem collapses to a
  fixed-width boundary covector and one rational function.
- **Still open:** construct the corresponding boundary witnesses for the
  \(2,3,3'\) Kostant modules.
- **Still open:** prove all-weight maximal rank away from the explicitly
  controlled plateau entrances, or replace that requirement.

No all-weight full-corner theorem or novelty claim is made.
