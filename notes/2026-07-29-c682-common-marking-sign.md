# C682 common-marking sign for the golden incidence fibres

## Outcome

The sign is fixed. In the frozen common \(A_5\)-marking below, the stored
mod-\(11\) \(6\)-by-\(10\) kernel-intersection matrix is exactly the
\(\lambda_+\) golden fibre:
\[
 \boxed{\quad M_{11}=M_{\lambda_+},\qquad
 \Theta=+\sqrt5,\qquad \sqrt5\equiv4\pmod {11}.\quad}
\]
The \(\lambda_-\) fibre is its entrywise complement.

This is a relative marking statement, as it must be. Applying the outer
automorphism that exchanges the two order-five classes sends
\(\sqrt5\mapsto-\sqrt5\) and swaps the two fibres.

## Frozen marking

On the characteristic-zero side put
\[
 a=\begin{pmatrix}\zeta_5^2&0\\0&1\end{pmatrix},\qquad
 b=\begin{pmatrix}v&u\\u&-v\end{pmatrix},
\]
where \(u=\zeta_5-\zeta_5^4\) and
\(v=\zeta_5^2-\zeta_5^3\). Then
\[
 |a|=5,\qquad |b|=2,\qquad |ab|=3.
\]
The golden square root is the one already used by the characteristic-zero
certificate,
\[
 \sqrt5=2(\zeta_{30}^2+\zeta_{30}^3-\zeta_{30}^7)-1.
\]

On the stored finite side, let \(a_{11}\) be the lexicographically least
order-five element of the stored parent permutation group, and let \(b_{11}\)
be the least involution for which \(a_{11}b_{11}\) has order three. Their
projective matrices are
\[
 a_{11}=\begin{pmatrix}1&8\\0&9\end{pmatrix},\qquad
 b_{11}=\begin{pmatrix}1&3\\4&10\end{pmatrix}.
\]
The common marking is the unique right-word isomorphism
\[
 a\longmapsto a_{11},\qquad b\longmapsto b_{11}.
\]

## Exact comparison

Transporting the six \(D_5\) and ten \(S_3\) stabilizers through this
isomorphism identifies the characteristic-zero certificate indices with
the stored rank-four point indices as follows:
\[
\begin{aligned}
 D_5:\ &(0,1,2,3,4,5)\longmapsto(20,1,6,16,4,8),\\
 S_3:\ &(0,1,2,3,4,5,6,7,8,9)\\
       &\hspace{2.8em}\longmapsto(13,19,3,15,11,17,5,0,7,9).
\end{aligned}
\]
Each image is forced: among the stored points of the corresponding orbit,
there is exactly one with the transported stabilizer.

After reordering the \(\lambda_+\) matrix into the stored point order, both
matrices are
\[
\begin{pmatrix}
1&0&1&0&0&0&1&1&1&0\\
0&1&1&0&1&0&0&0&1&1\\
1&0&1&1&0&1&0&0&0&1\\
1&1&0&1&1&0&1&0&0&0\\
0&0&0&1&1&1&0&1&1&0\\
0&1&0&0&0&1&1&1&0&1
\end{pmatrix}.
\]
Thus the comparison is literal, not merely up to independent row and column
permutations.

The projective trace invariant of \(a_{11}\) gives
\[
 r+r^{-1}=\frac{\operatorname{tr}(a_{11})^2}
                 {\det(a_{11})}-2=3.
\]
Because \(r=\zeta_5^2\) in the frozen characteristic-zero marking,
\(\sqrt5=-2(r+r^{-1})-1\), hence \(\sqrt5=4\) modulo \(11\). This independently
fixes the golden embedding selected by the generator transport.

There is one sign distinction worth retaining. The stored fibre has
\(\Theta=+\sqrt5\), but the divided centered first digit of
\(\lambda_+\) is
\[
 \frac{2208}{820125}\sqrt5\equiv6\equiv-5\pmod {11}.
\]
The complementary \(\lambda_-\) fibre has divided digit \(5\).

## Convention-sensitivity audit

There are five compatible choices of \(b_{11}\) with
\(|b_{11}|=2\) and \(|a_{11}b_{11}|=3\). All five give
\(M_{11}=M_{\lambda_+}\). Replacing \(a_{11}\) by \(a_{11}^2\), which
crosses to the other order-five class, gives \(M_{11}=M_{\lambda_-}\) for
all five compatible involutions. Therefore the sign depends exactly on the
golden/outer marking, not on the auxiliary involution.

## Reproducibility

From `rust/`, run

```text
python3 ../notes/2026-07-29-c682-common-marking-sign.py --check
python3 ../notes/2026-07-29-c682-common-marking-sign-replay.py
```

The primary checker reconstructs both marked \(A_5\)'s, builds the
sixty-element word isomorphism, transports every \(D_5\) and \(S_3\)
stabilizer, identifies the unique stored kernel point with that stabilizer,
and performs the exact matrix and convention-sensitivity comparisons.

The compact independent replay uses only the committed certificate and its
hashed inputs. It separately checks the projective \((5,2,3)\) presentation,
the group order, the trace-derived root \(\sqrt5=4\), the matrix reordering,
the design degrees, and the two divided digits.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-29-c682-common-marking-sign.py` | 14183 | `19f4a1dcb284cf7414b1440a7e0c8fbe45d11b239a1662da6215b70f3fb96860` |
| `2026-07-29-c682-common-marking-sign-replay.py` | 4154 | `caa6045df985fa686f0ee7bc678499a4c8cd2c002dbd475f09ba60eca9177bcb` |
| `2026-07-29-c682-common-marking-sign.json` | 5378 | `158d9b06b393fee605c7acaf7e8153a3e980d235eeb0af1d5a151ba825e20bfb` |

The computation fixes the sign relative to the stated common marking. It
does not produce an absolute sign invariant under the outer automorphism,
and it does not globalize the row swap over the Mukai--Umemura boundary.

## `ej` + `tt` closeout and mystery ledger

- **Closed:** the stored mod-\(11\) matrix is the \(\lambda_+\) fibre in the
  frozen common marking.
- **Closed by `ej`:** the same marking selects \(\sqrt5=4\), hence fixes the
  apparently opposite-looking divided digit \(6=-5\).
- **Closed by `ej`:** the result is independent of all five compatible
  involutions \(b_{11}\).
- **Settled by `tt`:** replacing \(a_{11}\) by \(a_{11}^2\) swaps the answer
  for every compatible involution. Thus no marking-free absolute
  plus/minus label exists; the order-five class is precisely the needed
  datum.
- **Still open:** extend the cross-Gram separator over the
  Mukai--Umemura boundary and decide whether the local complementary-fibre
  swap globalizes.
- **Still open:** determine the minimal integral base and actual bad primes
  of the combined operator/incidence package.

C682 remains open; completion is the user's decision.
