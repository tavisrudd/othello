# C682 nontrivial plateau block recurrence

Date: 2026-07-29

## Outcome

The first periodic plateau families in the three remaining Kostant modules
have exact fixed-width block three-term annihilator recurrences:
\[
\begin{array}{c|c|c|c}
\rho&n&\dim M_{\rho,n-6}&\dim M_{\rho,n}\\ \hline
2&63+60q&2q+1&2q+2\\
3&72+60q&3q+3&3q+4\\
3'&70+60q&3q+3&3q+4
\end{array}
\qquad(q\ge1).
\]
For every source block and level \(j\), the equation annihilating
\(\operatorname{im}\Delta_{n-6}\) has the form
\[
K_{-}(q,j)\ell_{j-1}
+K_0(q,j)\ell_j
+K_{+}(q,j)\ell_{j+1}=0.
\]
The block sizes are \(2\) for the \(2\)-module and \(3\) for the
\(3,3'\)-modules.  Every matrix entry is an exact polynomial of total
degree at most three in \((q,j)\), as forced by the order of the third
transvectant.  The certificate records all \(8,15,18\) nonzero scalar
couplings, respectively.

This constructs the block continued-fraction/transfer object required by
the nontrivial modules.  It does not yet prove that the endpoint mixing
functional is nonzero for every \(q\).

## Free-module coordinates

Over \(R=\mathbf Q[F,h]\), with \(\deg(F,h)=(12,20)\), use the primitive
free-generator degrees
\[
\begin{array}{c|l}
\rho&\text{degrees}\\ \hline
2&1,11,19,29\\
3&2,10,12,18,20,28\\
3'&6,10,14,16,20,24.
\end{array}
\]
The \(2\)-generators are
\[
x,\quad (x,F)_1,\quad(x,h)_1,\quad(x,t)_1
\]
after primitive normalization.  For \(3'\), the degree-six seed
\(x^3y^3\) lies in \(\ker((\,\cdot\,,F)_3:\operatorname{Sym}^6\to
\operatorname{Sym}^{12})\); its transvectants with \(F,h,t\) at orders
\(4,2,5,3,6\) give the other five primitive generators.  Their Hilbert
counts agree with the McKay multiplicities.

At the displayed plateau entrances, the current and lower bases split
into parity halves:

- \(2\): current generators \(g_{11},g_{19}\), lower generators
  \(g_1,g_{29}\);
- \(3\): current \(g_{12},g_{20},g_{28}\), lower
  \(g_2,g_{10},g_{18}\);
- \(3'\): current \(g_6,g_{10},g_{14}\), lower
  \(g_{16},g_{20},g_{24}\).

Ordering each generator chain by its semigroup level \(j\) makes
\(\Delta_{n-6}\) block tridiagonal: only target levels
\(j-1,j,j+1\) occur.

## Interior transfer determinant

The backward block \(K_-(q,j)\) is independent of \(q\) at the determinant
level.  Exact elimination gives
\[
\det K_-^{(2)}
=-\frac{c_2}{2}\,
j^2(3j-1)(3j+1)^2(3j+2),
\]
where
\[
c_2=3468519014400000000.
\]
For both three-dimensional blocks,
\[
\det K_-^{(\rho)}
=c_\rho j^3(1-9j^2)^2
 \left(1-\frac94j^2\right),
\]
with
\[
\begin{aligned}
c_3&=43953072950476800000000000,\\
c_{3'}&=-15190182011684782080000000000.
\end{aligned}
\]
Hence every backward block is invertible for every integral interior level
\(j\ge1\).  Besides the genuine boundary \(j=0\), the only zeros are at
the virtual fractional levels
\[
j=\pm\frac13,\qquad j=\pm\frac23.
\]
Thus the growing annihilator problem is a well-defined fixed-width
transfer product.  No singular interior step can create or destroy the
missing line.

## Relation to the scalar Jacobi goal

The previously proposed task “reconstruct the Jacobi-matrix or
continued-fraction model behind the \(1|13|1\) spectrum” has split into two
statements.

For the scalar trivial-module theorem, a literal tridiagonal Jacobi fit is
superseded.  The canonical signed form
\(\operatorname{Bez}(N,D)\) and the positive Hermite form
\(\operatorname{Bez}(N,N')\) already explain the signed transfer and the
unsigned chamber counts without choosing continued-fraction coordinates.

For \(2,3,3'\), the continued-fraction idea is not superseded: it is the
block recurrence above.  Its remaining endpoint contraction is the exact
object whose nonvanishing must be proved.  The next step is therefore not
to retrofit a scalar Jacobi matrix, but to derive a signed block
symmetrizer or an invariant cone for this transfer product and evaluate
the return boundary functional.

## Exact low-parameter evidence

At \(q=1,2,3,4\), exact rational arithmetic finds that every incoming basis
vector has nonzero first-return mixing in all three families.  In
particular, the last-boundary witness signs are
\[
\begin{array}{c|cccc}
\rho&q=1&q=2&q=3&q=4\\ \hline
2&-&-&-&-\\
3&+&+&+&+\\
3'&-&-&-&+
\end{array}
\]
The sign change observed later in the \(3'\) family means that a global
proof cannot simply assert coefficientwise positivity.  These finite
checks are evidence and base cases, not the all-\(q\) theorem.

## Reproducibility

The atomic evidence bundle is:

- `2026-07-29-c682-nontrivial-plateau-controllability.py`;
- `2026-07-29-c682-nontrivial-plateau-controllability.json`;
- `2026-07-29-c682-nontrivial-plateau-controllability-replay.py`.

From `rust/`, run

```text
python3 ../notes/2026-07-29-c682-nontrivial-plateau-controllability.py --check
python3 ../notes/2026-07-29-c682-nontrivial-plateau-controllability-replay.py
```

The primary checker constructs the primitive rational free modules,
interpolates every block coupling within the formal degree-three bound,
verifies the formulas at \(q=1,\ldots,6\), factors the three backward
block determinants, and checks exact mixing at \(q=1,2,3,4\).

The independent replay reconstructs \(F,h,t\) and every primitive generator
using the separate dense integer/modular transvectant engine.  At both
\(\mathbf F_{1000000007}\) and \(\mathbf F_{1000000009}\), it verifies all
recorded block coefficients at the out-of-sample value \(q=7\).

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-29-c682-nontrivial-plateau-controllability.py` | 17231 | `4c8489ac6cacf6dae2d842c3d5ba45c55a1b1dc50a1b3097e3e2388c3d2e4076` |
| `2026-07-29-c682-nontrivial-plateau-controllability.json` | 14641 | `e1c25f6751126699d73bac4c9a5fbbf561e76f693bd22bc3f98304361a70555b` |
| `2026-07-29-c682-nontrivial-plateau-controllability-replay.py` | 8709 | `24ed87ef60aa5663f6f24318ff4372ad4245526e9d13aa5a2d6e4b69989a0d4e` |

The load-bearing exact and replay engines remain the previously committed
free-covariant and first-failure bundles.  No random choices or external
dependencies are used.

## `ej` + `tt` closeout

The cheap structural gain is the determinant factorization.  It proves
that the block transfer never encounters an integral interior
singularity, before any endpoint mixing scalar is evaluated.  This removes
one possible failure mechanism uniformly in \(q\).

The virtual singular levels are unexpectedly rigid.  Both rank-three
modules have exactly the same normalized determinant
\[
j^3(1-9j^2)^2(1-9j^2/4),
\]
despite using different free generators and opposite overall signs.  This
points to a module-independent radial or \(E_8\)-edge normalization, rather
than two accidental factorizations.

The `tt` correction is that a scalar root-count argument is no longer the
right next object.  The \(3'\) boundary witness changes sign between the
tested integer regimes while remaining nonzero.  What is needed is a
signed block transfer invariant—an indefinite discrete Wronskian,
symmetrizer, or cone—not positivity of one scalar coefficient sequence.

## Mystery ledger

- **Settled:** exact free bases for the \(2\) and \(3'\) modules.
- **Settled:** the three incoming annihilator equations are fixed-width
  block three-term recurrences with degree-three polynomial coefficients.
- **Settled:** their backward blocks are nonsingular at every integral
  interior level.
- **Settled by `ej`:** the only nonboundary singular levels are the virtual
  fractions \(\pm1/3,\pm2/3\).
- **Settled by `tt`:** the scalar Jacobi fit is superseded for the trivial
  theorem but survives as the block-transfer mechanism for \(2,3,3'\).
- **Open:** construct a signed symmetrizer or discrete Wronskian for the
  block transfer.
- **Open:** prove that its endpoint return contraction is nonzero for every
  integer \(q\ge1\).
- **Settled by the successor indicial analysis:** the normalized
  rank-three backward determinants coincide because both source blocks
  contain one chain in each \(h\bmod3\) residue.  Their determinant is the
  common indicial product
  \(\prod_{s=0}^2(3j+s)_3\); see
  `2026-07-30-c682-virtual-levels.md`.

No all-\(q\) nontrivial-module controllability or all-weight full-corner
theorem is claimed.
