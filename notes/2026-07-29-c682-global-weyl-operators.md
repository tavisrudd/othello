# C682 global Weyl operators on the nontrivial Kostant modules

Date: 2026-07-29

## Outcome

The third- and ninth-transvectants are now constructed as finite Weyl
operators on the complete \(2,3,3'\) Kostant free modules over
\(\mathbf Q[F,h]\).  Their coefficients are expressed in the actual
invariant exponents
\[
F^a h^b g_i,
\]
not in a ray-specific parameter \(q\).  Consequently one operator package
applies simultaneously to every modulo-\(60\) phase of every periodic
plateau and peak family in these modules.

This closes the operator-construction part of the propagation gate.  It
does not by itself prove that every phase boundary determinant is nonzero.

## Weyl presentation

For transvectant order \(r\in\{3,9\}\), every term has the form
\[
c\,
F^\alpha h^\beta
\partial_F^u\partial_h^v E_{ji},
\qquad u+v\le r,
\]
acting in the falling-factorial basis:
\[
F^\alpha h^\beta
\partial_F^u\partial_h^v(F^ah^bg_i)
=
(a)_u(b)_v
F^{a-u+\alpha}h^{b-v+\beta}g_j.
\]
The degree shifts are \(+6\) for \(r=3\) and \(-6\) for \(r=9\).

The exact sizes are
\[
\begin{array}{c|rr|rr}
\rho&
\#(r=3)\text{ terms}&\#(r=3)\text{ generator pairs}&
\#(r=9)\text{ terms}&\#(r=9)\text{ generator pairs}\\ \hline
2&50&8&708&8\\
3&103&18&1485&18\\
3'&107&18&1498&18.
\end{array}
\]

For each order \(r\), the generator fits the coefficients on the square
grid \(0\le a,b\le r+1\) in the Weyl basis of total derivative order at
most \(r\).  It then reconstructs direct exact transvectants on the
strictly larger square \(0\le a,b\le r+2\).  This is a polynomial identity
check, not a finite extrapolation along selected \(q\)-rays.

## Why the phase parameter was insufficient

The previously certified boundary families used polynomial coefficients in
a ray parameter \(q\) and a local chain level.  Shifting a plateau entrance
by \(20\) preserves its Hilbert-series type, but the third transvectant is
not \(h\)-linear.  Direct exact comparison rules out obtaining the shifted
operator by the naive affine substitution \(q\mapsto q+1/3\).

The \((a,b)\)-Weyl presentation is the invariant replacement: it records
the product-rule corrections that the one-dimensional ray parameter loses.
It therefore supplies the common input needed to form the compressed
\(3\times3\), \(4\times4\), and \(4\times4\) boundary Schur complements in
all remaining phases.

## Reproducibility

From `rust/`, run

```text
python3 ../notes/2026-07-29-c682-global-weyl-operators.py --check
python3 ../notes/2026-07-29-c682-global-weyl-operators-replay.py
```

The primary checker uses exact rational transvectants and exact linear
algebra.  The replay independently reconstructs the module generators and
transvectants over
\(\mathbf F_{1000000007}\) and \(\mathbf F_{1000000009}\), then checks
additional exponent pairs beyond the primary verification grids.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-29-c682-global-weyl-operators.py` | 9221 | `06568fa1543fd154b39b8b045da1634ba3aaf488e3f919c95b3c73d720bde2ec` |
| `2026-07-29-c682-global-weyl-operators.json` | 986894 | `41605b911180716539888c85a78b48746008335d386787489e54fdad6e8f2b3e` |
| `2026-07-29-c682-global-weyl-operators-replay.py` | 4354 | `f25efb5922d2f0c4260be97455d4ec466d52347df54ed644587aee70308be14b` |

The load-bearing exact module generators and coordinate solver are imported
from `2026-07-29-c682-nontrivial-plateau-controllability.py`.  The replay
uses its separate modular companion.

## `ej` + `tt` closeout

The failed \(h\)-linearity shortcut is productive: it identifies the
correct global coordinates.  The finite Weyl operator is substantially
stronger than another list of phase-specific \(q\)-interpolants and turns
the remaining propagation problem into evaluation of one fixed operator on
sixteen boundary lattices.

The `tt` object is the associated-graded boundary Schur complement.  The
large tail determinant is presentation data; after eliminating the incoming
Weyl pivots, only the \(3,4,4\)-dimensional quotient connection carries
mixing.

## Mystery ledger

- **Settled:** finite global order-\(3\) and order-\(9\) Weyl operators
  exist on all three nontrivial Kostant modules.
- **Settled:** a ray parameter plus local level is not a global coordinate
  across degree-\(20\) phase shifts.
- **Settled by `ej`:** the invariant exponent pair \((a,b)\) removes all
  modulo-\(60\) operator duplication.
- **Open:** evaluate and certify the compressed quotient determinants on
  the sixteen plateau phases not covered by the eight existing ray
  certificates.
- **Open:** use those anchors to close the twenty-one peak families and
  prove the off-peak three-return step.
- **Open:** the all-weight one-sided maximal-rank theorem remains logically
  separate; the global Weyl package supplies its finite-module input but
  does not prove it automatically.

No all-weight full-corner claim is made.
