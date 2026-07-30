# C682 signed block Wronskian and endpoint mixing

Date: 2026-07-29

## Outcome

The first periodic plateau families in the \(2,3,3'\) Kostant modules are
controllable for every integer \(q\geq1\).  More precisely, fixed tuples of
right-boundary returns span the complete local boundary quotient modulo the
incoming image at every \(q\), including the short initial chains.  Therefore
the global cokernel functional cannot annihilate all endpoint returns, so at
least one endpoint return mixes the incoming hyperplane with its missing
line.

This closes the all-\(q\) endpoint-mixing gate left open by the block
three-term recurrence report.  It does not yet prove the off-peak propagation
needed for the all-weight full-corner theorem.

## Signed block Wronskian

Write the incoming cokernel recurrence as
\[
 (Lx)_j=A_jx_{j-1}+B_jx_j+C_jx_{j+1}.
\]
For a solution \(x\) of the primal recurrence and a solution \(y\) of the
formal adjoint recurrence, define
\[
 W_j(y,x)
 =y_j^{\mathsf T}C_jx_{j+1}
  -y_{j+1}^{\mathsf T}A_{j+1}x_j.
\]
Direct block algebra gives the signed Green identity
\[
 W_j-W_{j-1}
 =y_j^{\mathsf T}(Lx)_j-(L^\ast y)_j^{\mathsf T}x_j.
\]
Thus \(W_j\) is constant on a primal--adjoint solution pair.  The minus sign
is essential: the recurrence is not a positive scalar Jacobi recurrence, and
the previously observed \(3'\) scalar sign change is genuine.

The checker verifies this identity with the exact interpolated blocks.  The
interior backward determinants from the preceding report remain the
propagation gate; their nonvanishing at every integral \(j\geq1\) makes the
Wronskian transport well-defined.

## Boundary quotient

For \(q\geq10\), retain the last ten levels in each current-generator chain
and quotient by the incoming columns supported entirely in that window.  The
resulting dimensions are
\[
\begin{array}{c|c|c}
\rho&\dim T_\rho&\dim(T_\rho/H_\rho)\\ \hline
2&20&3\\
3&30&4\\
3'&30&4.
\end{array}
\]
The quotient dimension is \(b+1\), not the naive block size \(b\).  This is
why a single normalized endpoint scalar does not have a useful fixed-degree
formula.

For \(\rho=2,3\), take the first \(b+1\) candidates among the last two levels
of every lower-generator chain.  For \(3'\), use the last three levels.  Apply
the incoming edge, the next upward edge, and the ninth-transvectant return to
these endpoint vectors.  Adjoining their restrictions to a basis of
\(H_\rho\) produces square boundary matrices of sizes \(20,30,30\).  Their
determinants \(\Omega_\rho(q)\) are the signed block Wronskians of the
boundary connection problem.

If \(\Omega_\rho(q)\ne0\), the selected returns map onto
\(T_\rho/H_\rho\).  The restriction of the nonzero global cokernel functional
to this quotient therefore cannot kill every selected return.  This proves
endpoint mixing without singling out an arbitrary scalar coordinate.

## All-\(q\) nonvanishing

Every incoming and outgoing third-transvectant coefficient has total degree
at most \(3\) in \((q,j)\); every ninth-transvectant coefficient has degree at
most \(9\).  Hence the three fixed boundary determinants have formal degree
bounds \(96,138,138\).  Exact Newton interpolation at \(q=10\) gives the
smaller exact degrees
\[
83,\qquad121,\qquad120.
\]

The drops from the formal bounds are not accidental determinant
cancellations.  Normalize each incoming column by its formal degree \(3\),
each returned column by its formal degree \(15\), and put \(t=q^{-1}\).
Exact valuation-pivot elimination over \(\mathbf Q[[t]]\) gives the
Smith-at-infinity profiles
\[
\begin{array}{c|l|c}
\rho&\text{valuations}&\text{sum}\\ \hline
2&0^{17},3,4,6&13\\
3&0^{26},3,4,4,6&17\\
3'&0^{26},3,3,4,8&18.
\end{array}
\]
These sums are exactly \(96-83,138-121,138-120\).  Thus the degree
drops are forced by the filtered boundary symbol at infinity.  The principal
symbol has ranks \(17,26,26\); the positive valuations measure the successive
orders at which the \(3,4,4\) quotient directions appear.

These profiles belong to the selected fixed endpoint tuples, not to the
quotient alone.  A bounded exact endpoint-choice audit found alternative
profiles \((3,4,4,8)\) for \(3\) and \((3,3,6,8)\) for \(3'\), lowering
the corresponding determinant degrees to \(119,118\).  They are worse
all-\(q\) witnesses: on the audited range \(10\leq q\leq40\), the first
changes sign after \(q=36\), while the second changes sign across
\(17/18\) and \(23/24\).  The stored tuples are retained because their
determinants have one sign on the complete certified ray, not because they
maximize symbol vanishing.  No claim is made about the alternative tuples
outside the stated audit range; this endpoint-choice comparison is
exploratory and is not part of the certificate.

Put \(x=q-10\).  Exact division removes only linear roots below the stable
ray:

\[
\begin{array}{c|l}
\rho&\text{roots of the extracted linear factors in }x\\ \hline
2&-9,\;-8^2,\;-7^2,\;-6^2,\;-5^2,\;-4^2,\;-3^2,\;-2^2\\
3&-10,\;-9^3,\;-8^3,\;-7^3,\;-6^3,\;-5^3,\;-4^3,\;-3^3,\;-2^2\\
3'&-9,\;-8^3,\;-7^3,\;-6^3,\;-5^3,\;-4^3,\;-3^3,\;-2^2.
\end{array}
\]

These are roots of the stable \(q\geq10\) boundary matrix continued
polynomially to shorter, different-dimensional chains; they are not zeros of
the exact low-\(q\) boundary problem.  All these factors are strictly positive
for \(x\geq0\).  After shifting the residual polynomials, every nonzero
coefficient has one sign at
\[
q\geq21,\qquad q\geq31,\qquad q\geq27
\]
for \(2,3,3'\), respectively.  Exact evaluation gives one constant nonzero
sign on the intervening integer ranges starting at \(q=10\).

For \(q=1,\ldots,9\), the checker reconstructs the actual shorter chains and
their boundary quotients.  Their dimensions are
\[
\begin{array}{c|c}
\rho&\dim(T_\rho/H_\rho)\text{ for }q=1,\ldots,9\\ \hline
2&1,1,1,1,1,1,1,1,1\\
3&1,1,1,1,1,1,1,1,4\\
3'&1,1,1,1,1,1,1,1,4.
\end{array}
\]
Every corresponding exact boundary determinant is nonzero.  Thus the fixed
endpoint tuples surject onto the complete local quotient for all low \(q\)
as well; the separately stored endpoint scalar is now only a redundant
cross-check.  Consequently
\[
\Omega_\rho(q)\ne0
\qquad(\rho=2,3,3',\ q\geq10),
\]
and full boundary-quotient surjectivity holds for all integer \(q\geq1\).

## Reproducibility

From `rust/`, run

```text
python3 ../notes/2026-07-29-c682-signed-block-wronskian.py --check
python3 ../notes/2026-07-29-c682-signed-block-wronskian-replay.py
```

The primary checker reconstructs the exact degree-\(3,3,9\) operator
coefficients, checks the signed Green identity, regenerates the three stable
boundary determinant polynomials within their formal degree bounds, factors
their below-ray linear roots, proves the shifted residual sign certificates,
computes the exact Smith-at-infinity profiles, and directly reconstructs
every shorter boundary quotient at \(q=1,\ldots,9\).  It uses only Python's
standard library and the previously committed exact covariant engine.

The independent replay uses the separate dense modular transvectant engine.
At \(q=13\) and the two primes \(1000000007,1000000009\), it reconstructs all
three operators out of sample, compares every coefficient with the stored
universal formulas, independently obtains nonzero boundary determinants, and
recomputes all three Smith-at-infinity profiles by separate modular series
elimination.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-29-c682-signed-block-wronskian.py` | 32086 | `68e6957372b94b42816748d8acdb0bb93409bcac5255e1d6248047e6792ceb3f` |
| `2026-07-29-c682-signed-block-wronskian-operators.json` | 200893 | `0c58a67eca5186263d14a3a24741590c9a664078b74308c8cf05cffe2b30447b` |
| `2026-07-29-c682-signed-block-wronskian-boundary.json` | 177584 | `ff4103a66166bd37f2772e3737ef98c8572c9418e1e09a0d14da8d19870320d5` |
| `2026-07-29-c682-signed-block-wronskian.json` | 7403 | `54b5f4b6c02a8c9f8bcf539eba86c3e96221ed48df616b16a0aca082ae53f9a4` |
| `2026-07-29-c682-signed-block-wronskian-replay.py` | 16573 | `edc68289e993d8802509a5517d02fee607a7524dbc93e60e723946e733fff777` |

The hashes above are refreshed after the final validation pass.

## `ej` + `tt` closeout

The first cheap strengthening was surjectivity onto the entire stable local
boundary quotient, not merely one nonzero return contraction.  The follow-up
`ej` pass removes the remaining asymmetry: direct exact low-\(q\) boundary
determinants are nonzero too.  Full boundary-quotient surjectivity, rather
than just scalar endpoint mixing, now holds for every integer \(q\geq1\).
A second follow-up `ej` pass resolves the apparent degree-loss mystery:
Smith-at-infinity valuations account exactly for all \(13,17,18\) missing
degrees.

The useful successor object is consequently smaller than the displayed
\(20\times20\) and \(30\times30\) determinants.  Eliminating the
\(17,26,26\) zero-valuation incoming pivots leaves \(3\times3\),
\(4\times4\), and \(4\times4\) \(t\)-adic Schur complements carrying all
boundary mixing.  That is the natural compressed input for propagation to
the remaining periodic peak families.

The `tt` correction is structural.  A scalar hypergeometric fit is not merely
unnecessary; exact data rule out that proof shape at low order.  The invariant
object is the \(b+1\)-dimensional boundary connection determinant furnished by
the signed Green identity.  Passing to that quotient removes the growing
plateau before any root argument is attempted.

## Mystery ledger

- **Settled:** the exact signed block Wronskian and its Green identity.
- **Settled:** the right boundary quotients have dimensions \(3,4,4\).
- **Settled:** fixed endpoint-return tuples surject onto the stable quotients
  for every \(q\geq10\).
- **Settled by follow-up `ej`:** direct low-\(q\) determinants prove
  surjectivity onto the actual shorter-chain quotients at \(q=1,\ldots,9\).
  Hence full boundary-quotient surjectivity holds for every integer
  \(q\geq1\), not only endpoint mixing.
- **Settled by `ej`:** the theorem is full boundary-quotient surjectivity,
  stronger than one chosen scalar witness.
- **Settled by `tt`:** the scalar continued-fraction fit is replaced by the
  signed block connection determinant.
- **Settled by second follow-up `ej`:** the exact degree drops
  \(96\to83\), \(138\to121\), and \(138\to120\) are precisely the sums of
  the Smith-at-infinity valuations
  \((3,4,6)\), \((3,4,4,6)\), and \((3,3,4,8)\).
- **Exploratory endpoint-choice audit:** those valuation profiles are
  tuple-dependent.  More vanishing can lower the determinant degree but
  destroys the observed one-sign certificate, so the stored tuple is the
  proof-efficient choice among the compared tuples.  The alternative sign
  audit is exact only on \(10\leq q\leq40\) and remains unpromoted.
- **Settled operationally:** the repeated below-ray roots belong to the
  polynomial continuation of the stable boundary matrix across changes in
  quotient dimension.  Throughout the bulk truncated range, their
  multiplicities equal the number of stable quotient directions still
  absent from the short chain.  They are not low-\(q\) mixing failures.
- **Open:** the representation-theoretic explanation of the positive
  Smith valuations and the exceptional chain-edge root multiplicities at
  \(q=1,8\) (plus the virtual \(q=0\) factor for \(3\)).
- **Open:** propagate the boundary theorem through every eventual peak family
  and close the remaining off-peak full-corner gate.

No unexplained endpoint-mixing gap remains in the first \(2,3,3'\) plateau
families.
