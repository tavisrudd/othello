# C682 minimal integral base and actual bad primes

## Outcome

The minimal natural base for the **combined normalized operator, apolar-polar,
and golden-incidence package** is
\[
 \boxed{R=\mathbf Z[1/30].}
\]
Its actual structural bad primes are exactly
\[
 \boxed{\{2,3,5\}.}
\]

This statement deliberately uses the normalized/saturated incidence graph and
the correct integral dodecic lattice. It does not require the raw
ordinary-derivative inverse equations or the cross-Gram scalar by itself to
commute with reduction.

There are two useful finer boundaries:

| surface | minimal base | excluded or exceptional primes |
|---|---|---|
| Mukai--Umemura threefold alone | \(\mathbf Z[1/10]\) | structural \(2,5\) |
| normalized operator + apolar polarity + mate incidence | \(\mathbf Z[1/30]\) | structural \(2,3,5\) |
| cross-Gram ratio required to separate the two sheets literally | \(\mathbf Z[1/7590]\) | also invert collision primes \(11,23\) |

The primes \(11\) and \(23\) are **not** bad primes of the normalized golden
cover. They are the two primes, outside \(2,3,5\), at which its cross-Gram
image ceases to separate the sheets. Prime \(11\) has the already certified
Bockstein interpretation. Prime \(23\) is a second, previously unrecorded
first-order collision. Prime \(7\) is not bad: it is only a failure of naive
base change for the unsaturated annihilator equations at the two boundary
orbits.

## The correct integral operator lattice

Let \(e_j=X^{12-j}Y^j\). Replace the ordinary monomial dodecic lattice by the
\(11\)-elementary neighbor
\[
 \mathcal L_{12}^{(11)}
 =
 \langle e_0,e_1,11e_2,\ldots,11e_{10},e_{11},e_{12}\rangle .
\]
This is an \(SL_2\)-stable lattice. Stability under both integral unipotent
root groups follows from the divisibilities
\[
 s_j\binom{12-j}{k-j}\in s_k\mathbf Z,\qquad
 s_j\binom{j}{k}\in s_k\mathbf Z,
\]
where \(s_0=s_1=s_{11}=s_{12}=1\) and \(s_2=\cdots=s_{10}=11\).

In this lattice the Klein dodecic is primitive:
\[
 X^{11}Y+11X^6Y^6-XY^{11}
 \quad\longleftrightarrow\quad
 e_1+(11e_6)-e_{11}.
\]
Thus its middle coefficient remains visible in characteristic \(11\).
The raw third-transvectant tensor on
\(\operatorname{Sym}^6\otimes\mathcal L_{12}^{(11)}\) has exact content
\[
 2640=2^4\cdot3\cdot5\cdot11.
\]
After primitive division, the gcds of the rank-four minors at the open,
divisor-boundary, and closed-boundary representatives are respectively
\[
 25,\qquad 5400=2^3 3^3 5^2,\qquad
 64800=2^5 3^4 5^2.
\]
Every rank-five minor vanishes integrally. Consequently all three operator
matrices have rank exactly four in every characteristic outside
\(\{2,3,5\}\), including \(7,11,23\).

This lattice packages the earlier characteristic-\(11\) correction
conceptually. Modulo \(11\), its image in the ordinary monomial lattice is
the four-dimensional Frobenius-invisible space
\[
 \langle X^{12},X^{11}Y,XY^{11},Y^{12}\rangle ,
\]
while the nine scaled middle basis vectors retain the first divided digit.
The prior Bockstein direction is therefore not an ad hoc division of one
matrix: it is the special fibre of this elementary lattice.

## Why \(7\) is not bad

With the corrected lattice, the forward operator has rank four at all three
orbit types modulo \(7\). The raw reverse annihilator system still has ranks
\[
 12,\ 11,\ 11
\]
on the open, divisor, and closed orbits. At the boundary it acquires one
extra reduced solution: \(e_8\) for the divisor orbit and \(e_7\) for the
closed orbit.

These are torsion specializations, not additional characteristic-zero
annihilator lines. The integral kernels are the primitive lines
\(\langle e_1\rangle\) and \(\langle e_0\rangle\); taking their flat closure
and then reducing retains those lines. Taking the kernel of the already
reduced matrix is the noncommuting operation that creates the extra
direction. Thus the normalized operator graph is good at \(7\), while the
unsaturated inverse-by-linear-equations presentation is not.

At \(11\), the elementary lattice makes the forward rank four directly, and
the existing independent certificate proves flat rank through modulus
\(121\) and the compatible full \(\mathbf Z_{11}\)-tower. Hence neither
\(7\) nor \(11\) belongs to the structural bad-prime set.

## Why \(3\) is genuinely bad for the combined package

Ito--Kanemitsu--Takamatsu--Tanaka construct the split Mukai--Umemura scheme
over \(\mathbf Z[1/10]\), so the threefold itself has a characteristic-three
fibre. The obstruction at \(3\) enters only when the Schläfli
apolar-polar operation is required.

After dividing the factorial apolar form on \(\operatorname{Sym}^6\) by its
content \(12\), its primitive antidiagonal weights are
\[
 (60,-10,4,-3,4,-10,60).
\]
Its determinant is
\[
 17280000=2^{10}3^3 5^4.
\]
The form therefore becomes perfect exactly after inverting \(2,3,5\). Its
ranks in characteristics \(2,3,5\) are \(1,4,3\), respectively. In
characteristic \(3\), for example, the orthogonal of
\[
 (XY)^2\operatorname{Sym}^2
\]
has dimension \(5\), not \(4\), because the middle apolar equation vanishes.
The polar companion \(E_i'\) is no longer a line cut by a polarity.

This is intrinsic, not a removable scalar normalization. The Weyl module of
highest weight \(6\) is not self-dual through a perfect invariant form in
characteristic \(3\); the canonical Weyl-to-costandard map has a radical.
Thus \(3\) must be inverted for the combined operator-polar package even
though the underlying Mukai--Umemura variety has good reduction there.

The other two structural primes are forced geometrically:
Ito--Kanemitsu--Takamatsu--Tanaka prove that the \(PGL_2\)-type
Mukai--Umemura \(V_{22}\) exists uniquely away from \(2,5\) and does not
exist in characteristics \(2\) or \(5\). Their explicit split model is
defined over \(\mathbf Z[1/10]\). This proves minimality of
\(\mathbf Z[1/30]\) for the simultaneous package.

## Cross-Gram collision primes

The two characteristic-zero values are
\[
 \lambda_\pm=
 \frac{54781\pm24288\sqrt5}{820125},
\]
with
\[
 820125=3^8 5^3,\qquad
 24288=2^5\cdot3\cdot11\cdot23.
\]
Over \(\mathbf Z[1/30]\) the quadratic golden algebra itself is finite
etale: its discriminant is \(20\), a unit. The cross-Gram polynomial,
however, has discriminant
\[
 20\cdot820125^2\cdot24288^2.
\]
Its two projective scalar values therefore collide precisely at \(11\) and
\(23\) after \(2,3,5\) have been inverted.

This separates two notions that had previously been conflated:

- the normalized golden incidence cover remains good at \(11,23\);
- the morphism from that cover to the cross-Gram scalar line is not
  fibrewise injective there.

At \(11\), dividing the centered collision gives the known deck-odd
Bockstein values. At \(23\), the same valuation-one arithmetic predicts a
second divided separator, but no geometric or representation-theoretic
meaning is presently known. The primes \(71,101\), where one scalar value
becomes zero because
\[
 54781^2-5\cdot24288^2=71^2 101^2,
\]
are not discriminant primes and do not merge the two sheets.

## Proof boundary

The exact certificate proves:

- \(SL_2\)-stability of \(\mathcal L_{12}^{(11)}\);
- integrality and exact content of the primitive operator tensor;
- all rank-four minor gcds and vanishing of every rank-five minor at the
  three orbit representatives;
- the modular ranks of the raw reverse annihilator equations;
- the determinant and modular radicals of the apolar form; and
- the exact cross-Gram collision and zero-value prime factorizations.

The passage from the three orbit representatives to the whole operator
graph uses the established three-orbit Mukai--Umemura structure and
equivariance. At characteristic \(7\), “good” refers to the flat
closure/normalization of the graph, not to the kernel of the reduced reverse
matrix. At \(11\), the prior corrected-bridge certificate independently
checks the flat local tower.

The geometric existence and nonexistence input is
Ito--Kanemitsu--Takamatsu--Tanaka,
*Fano threefolds of genus 12 with large automorphism group in positive and
mixed characteristic*, arXiv:2601.10106, Theorem 5.2 and Lemma 5.4. The
cached PDF has SHA-256
`0e2caea7c0eaf78f2105fc796a8d302443b1af337e9f7dbda24b4572f43af788`.
No novelty or priority claim is made, and Paper III remains closed.

## Reproducibility

From `rust/`, run

```text
python3 ../notes/2026-07-29-c682-minimal-integral-base.py --check
python3 ../notes/2026-07-29-c682-minimal-integral-base-replay.py
```

The replay independently reconstructs the elementary lattice, primitive
tensor, modular orbit ranks, apolar radicals, and cross-Gram arithmetic.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-29-c682-minimal-integral-base.py` | 15126 | `27f39d0afab7101812f37690079aaec5903ef1a00e163e5b971f301af9babf7a` |
| `2026-07-29-c682-minimal-integral-base-replay.py` | 3807 | `8f901e66ec181ad0487ce4f440026814837a926dc76d8e37fbba7d3e1726710e` |
| `2026-07-29-c682-minimal-integral-base.json` | 5105 | `f8272799962092041e630bd303bfeca1de6c184aa7d4468bbdf67ad83fe06cdd` |

## `ej` + `tt` closeout and mystery ledger

- **Closed:** the minimal base of the combined normalized package is
  \(\mathbf Z[1/30]\), with structural bad primes exactly \(2,3,5\).
- **Closed by `ej`:** the mod-\(11\) Bockstein is the ordinary special
  fibre of the canonical \(11\)-elementary dodecic lattice; it is not a
  one-point matrix-content trick.
- **Closed by `ej`:** prime \(7\) is a kernel/base-change artifact of the
  raw reverse equations. The forward operator and flat graph are good.
- **Settled by `tt`:** one must distinguish the normalized incidence cover
  from its cross-Gram scalar image. Only the latter has extra collision
  primes.
- **New exact feature:** \(23\) is the second cross-Gram collision prime.
  It is not structurally bad, but a divided first-order separator exists
  arithmetically just as at \(11\).
- **Still open:** find an intrinsic meaning for the characteristic-\(23\)
  divided separator, or prove that it is only normalization arithmetic.
  This is an incidental arithmetic mystery, not a prerequisite for the
  integral model.
- **No other bad-prime mystery remains:** \(71,101\) are zero-value rather
  than collision primes, and \(29,1889\) only annul the centered numerator.

C682 remains open; completion is the user's decision.
