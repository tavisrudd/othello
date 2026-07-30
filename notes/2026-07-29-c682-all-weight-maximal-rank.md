# C682 all-weight maximal rank and the off-peak frontier

Date: 2026-07-29

## Theorem

For every degree \(n\) and every irreducible binary-icosahedral module
\(\rho\), the McKay block
\[
 D_{\rho,n}:M_{\rho,n}\longrightarrow M_{\rho,n+6}
\]
of
\[
 \Delta_n=(\,\cdot\,,\Phi_{12})_3
\]
has maximal rank:
\[
\boxed{\quad
\operatorname{rank}D_{\rho,n}
=\min(m_\rho(n),m_\rho(n+6)).
\quad}
\]

Equivalently, the complete one-sided kernel series is
\[
\boxed{\qquad
\sum_{n\ge0}\dim\ker\Delta_n\,t^n
=
\frac{
1+2t+3t^2+3t^6+3t^{10}+2t^{11}+t^{12}
}{1-t^{20}}.
\qquad}
\]

This removes the maximal-rank hypothesis from the C682 corner-propagation
program.  Combined with the twenty-four certified plateau entrances and
the twenty-one closed strict peaks, it closes every off-peak full graded
path corner in the \(1,2,3,3'\) modules.  Five monotone modules still need
their own plateau-entry mixing anchors; those exact phases are listed
below.

## Order-three reduction

Dehomogenize with
\[
 F=X^{12}f(z),\qquad
 f(z)=z+11z^6-z^{11}.
\]
The equation \((P,F)_3=0\) is a third-order linear differential equation
for the dehomogenized polynomial \(p(z)\).  Its leading coefficient is
\[
 -1320f(z),
\]
which is not zero.  Therefore
\[
 \dim\ker\Delta_n\le3
\]
in every degree.

The exact McKay numerators give the forced kernel series displayed above.
The semigroup coefficient
\[
 c(k)=\#\{(a,b)\in\mathbf Z_{\ge0}^2:12a+20b=k\}
\]
satisfies \(c(k+60)=c(k)+1\) whenever \(k\ge0\) is divisible by \(4\).
The degree-compatible generator classes are balanced across the shift by
\(6\), so the forced-defect calculation is periodic with period \(20\).
The checker derives one full period from all nine Kostant numerators and
checks every low degree \(0\le n\le52\) by exact integer rank.

## The \(C_5\)-weight sieve

The three transvectant terms send a source coefficient \(v_j\) to target
indices
\[
 j-2,\qquad j+3,\qquad j+8.
\]
They therefore preserve one of five coefficient chains \(j\bmod5\).  The
source chain \(j\equiv r\pmod5\) has \(C_5\)-weight
\[
 w\equiv n-2r\pmod5.
\]

Central parity and the order-three bound leave only
\[
\begin{array}{c|c}
n\text{ even}&1,3,3'\\
n\text{ odd}&2,2'
\end{array}
\]
as possible unexpected kernel representations.  Every even candidate has
a weight-zero vector.  The two odd candidates have weights
\(\{\pm1\}\) and \(\{\pm2\}\), respectively.  Thus it is enough to prove
injectivity on one chosen weight-zero chain at each unforced even residue,
and on one chain from each absolute odd weight class.

## Triangular maximal minors

No growing continuant determinant is needed.  The selected chain minors
are triangular.

For chain residues \(r\ge2\), take the first \(|J|\) target rows.  The
diagonal is
\[
 d_1(n,j)=330(j)_2(n-4j+6).
\]
For \(r=0,1\), shift the target window by one row.  The diagonal is
\[
 d_{11}(n,j)
=-330(n-j)_2(3n-4j-6).
\]

The checker records the selected chain for every relevant residue modulo
\(20\).  Boundary factors are nonzero on the selected ranges.  Writing
\(n=n_0+20q\) and \(j=r+5k\), the remaining linear factors are
\[
\begin{aligned}
n-4j+6&=(n_0-4r+6)+20(q-k),\\
3n-4j-6&=(3n_0-4r-6)+20(3q-k).
\end{aligned}
\]
For every selected chain, the displayed constant is nonzero modulo \(20\).
Hence every diagonal entry, and therefore every selected maximal minor, is
nonzero for the whole ray.

At the forced one-dimensional residues \(n\equiv0,12\pmod{20}\), the same
shifted minor after deleting the last source column proves that the
weight-zero chain has nullity at most one.  The known forced trivial vector
therefore exhausts it.  At forced dimension two, odd central parity makes
any additional irreducible at least two-dimensional; at forced dimension
three, the ODE bound is already saturated.  This proves the theorem.

## Consequence and exact remaining frontier

Maximal-rank square edges now transport full corners without hypothesis.
The certified modulo-\(60\) entrances in \(1,2,3,3'\) anchor every
plateau in those modules, and the already proved peak theorem closes their
strict maxima.  Their full graded path corners are therefore controlled in
all weights, apart from the known degree-\(22\) failure.

The remaining modules have no eventual strict peaks; they are monotone
plateau chains.  They require exactly sixty-three entrance-mixing phases:
\[
\begin{array}{c|l}
2'&7,17,27,37,47,57\\
4&6,8,16,18,26,28,36,38,46,48,56,58\\
4_s&1,3,11,13,21,23,31,33,41,43,51,53\\
5&0,4,8,12,16,20,24,28,32,36,40,44,48,52,56\\
6&5,7,9,15,17,19,25,27,29,35,37,39,45,47,49,55,57,59.
\end{array}
\]
Modulo \(20\), these collapse to \(2+4+4+5+6=21\) entrance types.
Degree-\(20\) multiplication still does not intertwine the transvectant,
so the sixty-three modulo-\(60\) phases remain the exact next gate.

## Reproducibility

From `rust/`, run

```text
python3 ../notes/2026-07-29-c682-all-weight-maximal-rank.py --check
python3 ../notes/2026-07-29-c682-all-weight-maximal-rank-replay.py
```

The primary checker reconstructs the five chain matrices, verifies the
triangular support and diagonal formulas, audits every boundary and
modulo-\(20\) nonvanishing condition, derives the forced series from all
nine Kostant numerators, and checks the exact low-degree ranks.

The independent replay reconstructs the transvectant matrices directly
over two large primes.  It checks every degree through \(120\), verifies
the selected diagonal minors at \(q=13\) and \(q=1000\), and independently
recovers the dehomogenized leading coefficient.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-29-c682-all-weight-maximal-rank.py` | 16704 | `2410e47070abb7b6ba20af76afad5bb1c0e2ec82dd6957320a9864e109e926af` |
| `2026-07-29-c682-all-weight-maximal-rank.json` | 13710 | `9c752f107fdbd205841f51c596acc8aba218b10604a9d271524d327ca96a2d76` |
| `2026-07-29-c682-all-weight-maximal-rank-replay.py` | 5946 | `3c6d3397b50abc7cef2c74e6cd8e768442e01f8538cc33f60940c9fa8a0b6abe` |

The theorem concerns ranks and full graded path-corner transport.  It does
not by itself provide the missing plateau-entry matrix unit in
\(2',4,4_s,5,6\), and it does not identify a full path corner with the
algebra of the three local returns.

## `ej` + `tt` closeout

The cheap strengthening is global: no finite free-covariant construction
is needed for maximal rank.  The order-three bound reduces the entire
kernel problem to the five smallest irreducibles, and \(C_5\)-weights then
reduce it further to triangular minors using only the two outer
transvectant coefficients \(d_1,d_{11}\).  The middle coefficient \(d_6\)
plays no role in the rank proof.

The `tt` correction is to separate three layers that had been conflated:

1. maximal rank of the edges — now a theorem;
2. one matrix unit at each multiplicity-increase entrance — sixty-three
   phases remain;
3. reduction from the full path corner to the three local returns — still
   separate.

This makes the next computation smaller and logically clean: evaluate
only the entrance-mixing quotients for the five monotone modules.

## Mystery ledger

- **Settled:** every McKay block of \(\Delta_n\) has maximal rank in every
  weight.
- **Settled by `ej`:** the full kernel theorem uses only the order-three
  ODE bound, parity, \(C_5\)-weights, and triangular \(d_1/d_{11}\) minors.
- **Settled:** all off-peak full graded path corners in
  \(1,2,3,3'\) propagate once the existing entrances and peaks are used.
- **Settled by `tt`:** the remaining off-peak obstruction is not rank; it
  is exactly sixty-three entrance-mixing phases in the five monotone
  modules.
- **Open structural question:** why the middle chain coefficient \(d_6\)
  is unnecessary for one-sided maximal rank although it is essential in
  the two-sided unique-continuation theorem.
- **Open, next gate:** construct the global Weyl modules for
  \(2',4,4_s,5,6\) and evaluate their sixty-three entrance quotients.
- **Open, separate:** identify the full path corner with the algebra of
  the three local returns.

No all-weight full-corner theorem is claimed.
