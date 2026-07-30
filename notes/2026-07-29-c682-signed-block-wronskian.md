# C682 signed block Wronskian and endpoint mixing

Date: 2026-07-29

## Outcome

The first periodic plateau families in the \(2,3,3'\) Kostant modules are
controllable for every integer \(q\geq1\).  More precisely, a fixed tuple of
right-boundary returns spans the complete local boundary quotient modulo the
incoming image.  Therefore the global cokernel functional cannot annihilate
all endpoint returns, so at least one endpoint return mixes the incoming
hyperplane with its missing line.

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

All these factors are strictly positive for \(x\geq0\).  After shifting the
residual polynomials, every nonzero coefficient has one sign at
\[
q\geq21,\qquad q\geq31,\qquad q\geq27
\]
for \(2,3,3'\), respectively.  Exact evaluation gives one constant nonzero
sign on the intervening integer ranges starting at \(q=10\).  Finally, the
stored endpoint scalar is exactly nonzero for \(q=1,\ldots,9\).  Consequently
\[
\Omega_\rho(q)\ne0
\qquad(\rho=2,3,3',\ q\geq10),
\]
and endpoint mixing holds for all integer \(q\geq1\).

## Reproducibility

From `rust/`, run

```text
python3 ../notes/2026-07-29-c682-signed-block-wronskian.py --check
python3 ../notes/2026-07-29-c682-signed-block-wronskian-replay.py
```

The primary checker reconstructs the exact degree-\(3,3,9\) operator
coefficients, checks the signed Green identity, regenerates the three fixed
boundary determinant polynomials within their formal degree bounds, factors
their below-ray linear roots, and proves the shifted residual sign
certificates.  It uses only Python's standard library and the previously
committed exact covariant engine.

The independent replay uses the separate dense modular transvectant engine.
At \(q=13\) and the two primes \(1000000007,1000000009\), it reconstructs all
three operators out of sample, compares every coefficient with the stored
universal formulas, and independently obtains nonzero boundary determinants.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-29-c682-signed-block-wronskian.py` | 26917 | `293ce530fef57ff6c4ccc3551984b618e2830a051270da1ec0511a70ca1dc8ac` |
| `2026-07-29-c682-signed-block-wronskian-operators.json` | 200893 | `0c58a67eca5186263d14a3a24741590c9a664078b74308c8cf05cffe2b30447b` |
| `2026-07-29-c682-signed-block-wronskian-boundary.json` | 177584 | `ff4103a66166bd37f2772e3737ef98c8572c9418e1e09a0d14da8d19870320d5` |
| `2026-07-29-c682-signed-block-wronskian.json` | 5503 | `afc4476153f433fea1f9884a1cd37b220adac899c4dce58dda09446e4a065dad` |
| `2026-07-29-c682-signed-block-wronskian-replay.py` | 7534 | `a6513d1de8d303bc5434646f0980f37bef5fb67d9e1a92cd5df31d20a2bdc51f` |

The hashes above are refreshed after the final validation pass.

## `ej` + `tt` closeout

The cheap strengthening is that the computation proves surjectivity onto the
entire local boundary quotient, not merely one nonzero return contraction.
This makes the result independent of which scalar endpoint coordinate happens
to change sign.

The `tt` correction is structural.  A scalar hypergeometric fit is not merely
unnecessary; exact data rule out that proof shape at low order.  The invariant
object is the \(b+1\)-dimensional boundary connection determinant furnished by
the signed Green identity.  Passing to that quotient removes the growing
plateau before any root argument is attempted.

## Mystery ledger

- **Settled:** the exact signed block Wronskian and its Green identity.
- **Settled:** the right boundary quotients have dimensions \(3,4,4\).
- **Settled:** fixed endpoint-return tuples surject onto those quotients for
  every \(q\geq10\).
- **Settled:** exact endpoint mixing for every integer \(q\geq1\) in all
  three nontrivial plateau families.
- **Settled by `ej`:** the theorem is full boundary-quotient surjectivity,
  stronger than one chosen scalar witness.
- **Settled by `tt`:** the scalar continued-fraction fit is replaced by the
  signed block connection determinant.
- **Open:** the exact degree drops \(96\to83\), \(138\to121\), and
  \(138\to120\) suggest a principal-symbol or Darboux cancellation not yet
  identified.
- **Open:** the repeated below-ray roots have a rigid module-dependent
  multiplicity pattern; their representation-theoretic meaning is not yet
  explained.
- **Open:** propagate the boundary theorem through every eventual peak family
  and close the remaining off-peak full-corner gate.

No unexplained endpoint-mixing gap remains in the first \(2,3,3'\) plateau
families.
