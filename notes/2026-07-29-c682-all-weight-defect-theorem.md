# C682 all-weight two-sided Klein defect theorem

Date: 2026-07-29

## Theorem

Let

\[
\Delta_n=(\,\cdot\,,\Phi_{12})_3:
\operatorname{Sym}^n\longrightarrow\operatorname{Sym}^{n+6}
\]

and define the two-sided defect

\[
K_n=\ker(\Delta_n,\Delta_{n-6}^{\dagger}).
\]

Then

\[
\boxed{\quad K_n=0\quad\text{for every }n>52.\quad}
\]

Combining this theorem with the exact bounded calculation gives the complete
all-weight spectrum

\[
\begin{array}{c|rrrrrrrrrrrrr}
n&0&1&2&6&10&11&12&20&21&22&32&40&52\\ \hline
\dim K_n&1&2&3&3&3&2&1&1&2&3&1&1&1.
\end{array}
\]

In particular, degree \(22\) is the unique two-sided defect in all weights
whose dimension can occupy a repeated isotypic summand. It is the standard
\(\mathbf3\) dark line in the doubled degree-\(22\) multiplicity space.

This is an all-weight defect theorem. It is not yet the all-weight
full-corner theorem.

## Five coefficient chains

Write

\[
P=\sum_{j=0}^n v_jX^{n-j}Y^j,\qquad
F=X^{11}Y+11X^6Y^6-XY^{11}.
\]

With \((a)_r\) denoting a falling factorial, the three contributions of
\(\Delta_nP\) are

\[
\begin{aligned}
d_1(n,j)
 &=330(j)_2(n-4j+6),\\
d_{11}(n,j)
 &=-330(n-j)_2(3n-4j-6),\\
d_6(n,j)
 &=1320\left(
 (n-j)_3-\frac92(n-j)_2j
 +\frac92(n-j)(j)_2-(j)_3
 \right).
\end{aligned}
\]

They send source index \(j\) to \(j-2,j+3,j+8\), respectively. Since these
three targets are congruent modulo \(5\), the stacked map

\[
Q_n=(\Delta_n,\Delta_{n-6}^\dagger)
\]

splits into five independent source chains \(j\bmod5\).

For a center \(j\), the upper equation on
\((v_{j-5},v_j,v_{j+5})\) is

\[
d_{11}(n,j-5)v_{j-5}
+d_6(n,j)v_j
+d_1(n,j+5)v_{j+5}=0.
\]

The Fischer norm of \(X^{n-j}Y^j\) is
\((n-j)!j!\). Applying that weight ratio to the transpose of
\(\Delta_{n-6}\) gives a second equation on the same triple. Its
coefficients are

\[
\begin{aligned}
\ell_-(n,j)
 &=330(n-4j+12)\prod_{a=-2}^{5}(n-j+a),\\
\ell_0(n,j)
 &=d_6(n-6,j-3)(n-j)_3(j)_3,\\
\ell_+(n,j)
 &=-330(3n-4j-12)\prod_{a=-2}^{5}(j+a).
\end{aligned}
\]

Thus every chain is governed by two aligned tridiagonal recurrences.

## The local four-by-four determinant

Take the upper and lower equations at centers \(j\) and \(j+5\). They form
a \(4\)-by-\(4\) matrix \(M_j(n)\) on

\[
(v_{j-5},v_j,v_{j+5},v_{j+10}).
\]

For the five chains, take \(j=5,6,7,8,9\). Exact polynomial arithmetic
gives

\[
\det M_j(n)
=c_j\prod_{a\in S_j}(n-a)\,P_j(n),
\]

where repeated entries in \(S_j\) retain their multiplicity.

\[
\begin{array}{c|c|c|c|c}
j&\deg\det M_j&\max S_j&\deg P_j&
\text{prime with no root of }P_j\\ \hline
5&20&40&7&19\\
6&20&52&7&37\\
7&20&24&11&31\\
8&20&26&11&37\\
9&20&28&12&29
\end{array}
\]

The exact constants, linear-root multisets, and coefficients of every
\(P_j\) are stored in the JSON certificate. The checker reconstructs
\(\det M_j(n)\) from the transvectant coefficients using only integer
polynomial arithmetic and verifies each factorization identically.

For the final column of the table, the checker evaluates \(P_j\) at every
residue modulo the displayed prime and finds no zero. An integer root of
\(P_j\) would reduce to a root modulo that prime, so \(P_j\) has no integer
root. Every linear root is at most \(52\). Therefore

\[
\det M_j(n)\ne0
\qquad(n>52,\ j=5,\ldots,9).
\]

## Propagation to the whole chain

For source residue \(r\in\{0,1,2,3,4\}\), use \(j=r+5\). The nonsingular
local block forces

\[
v_r=v_{r+5}=v_{r+10}=v_{r+15}=0.
\]

Suppose two consecutive chain coefficients are zero and the next
coefficient is still inside \(0\le j\le n\). In the upper recurrence its
coefficient contains

\[
n-4c-14,
\]

while in the lower recurrence it contains

\[
3n-4c-12.
\]

The remaining falling-factorial factors are nonzero in the rightward
interior. The two displayed linear factors cannot vanish simultaneously,
because

\[
3(n-4c-14)-(3n-4c-12)=-8c-30\ne0
\qquad(c\ge5).
\]

Hence at least one recurrence forces the next coefficient to vanish.
Induction reaches the right boundary of each of the five chains. Thus every
coefficient of a vector in \(K_n\) is zero for \(n>52\), proving the
theorem.

## Evidence and replay

The primary certificate uses only the Python standard library:

- `2026-07-29-c682-all-weight-defect-theorem.py`;
- `2026-07-29-c682-all-weight-defect-theorem.json`.

The independent replay reconstructs the local matrices directly from the
four-term transvectant definition and Fischer factorial weights, rather
than importing the primary polynomial engine:

- `2026-07-29-c682-all-weight-defect-theorem-replay.py`.

From `rust/`:

```text
python3 ../notes/2026-07-29-c682-all-weight-defect-theorem.py --check
python3 ../notes/2026-07-29-c682-all-weight-defect-theorem-replay.py
python3 ../notes/2026-07-29-c682-two-sided-defect-spectrum.py --check
python3 ../notes/2026-07-29-c682-two-sided-defect-spectrum-replay.py
```

The last two commands certify the exact bounded spectrum that is combined
with the new \(n>52\) theorem.

## Consequence for the corner problem

At every multiplicity peak above degree \(52\), the lower and upper images
span the multiplicity space. This eliminates the orthogonal dark-line
failure seen at degree \(22\) in all later weights.

It does not alone prove full corner generation. At the
\(\mathbf3\)-families with \(n\equiv2\pmod{20}\), for example, the lower
image has codimension two and the upper image is a hyperplane. The next
gate is to prove that the compressed upward returns \(U_1,U_2\) generate
the full algebra supported on that hyperplane, and then apply the
two-subspace propagation lemma. Off-peak corners must also be placed in a
well-founded propagation order.

## `ej` + `tt` closeout

The decisive `ej` move is local rather than module-theoretic: overlap the
two upper/lower recurrences on four consecutive chain coefficients. The
resulting determinants have a fixed degree \(20\), independent of \(n\),
and five small modular root exclusions replace an unbounded Hilbert-series
argument.

The `tt` interpretation is a discrete unique-continuation theorem. The
two-sided Klein operator is a five-channel Jacobi system; after degree
\(52\), four vanishing coefficients on each channel are forced locally and
then propagate to the boundary. Degree \(22\) is the last
repeated-isotypic failure of unique continuation.

## Mystery ledger

- **Settled:** \(K_n=0\) for every \(n>52\).
- **Settled:** the complete all-weight two-sided defect spectrum.
- **Settled:** degree \(22\) is the unique repeated-isotypic two-sided
  defect in all weights.
- **Settled:** the former “absence above degree \(300\)” finite evidence is
  replaced by an exact theorem.
- **Open:** prove upper-support mixing from \(U_1,U_2\) at codimension-two
  peaks.
- **Open:** prove the remaining one-step/two-step maximal-rank conditions
  needed by the corner propagation lemma.
- **Open:** dispose of all off-peak corners and conclude that degree \(22\)
  is the unique full-corner failure.

No novelty claim is made.
