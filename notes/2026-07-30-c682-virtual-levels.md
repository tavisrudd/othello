# C682 \(E_8\) indicial explanation of the virtual transfer levels

Date: 2026-07-30

## Theorem

The universal virtual levels
\[
 0,\qquad \pm\frac13,\qquad \pm\frac23
\]
are the indicial roots of the order-three transvectant at the divisor
\(h=0\), expressed in the natural degree-\(60\) \(E_8\) level.

The binary-icosahedral invariant ring has
\[
 \deg(F,h,t)=(12,20,30),\qquad
 t^2=1728F^5-h^3.
\]
Thus a degree-\(60\) level step trades \(h^3\) against \(F^5\).  On every
fixed generator chain, write the \(h\)-exponent as
\[
 b=3j+s,\qquad s\in\{0,1,2\}.
\]
The backward symbol of the third transvectant contributes the third
falling factorial
\[
 (b)_3=b(b-1)(b-2)=(3j+s)_3.
\]
Its roots are
\[
 j=\frac{-s}{3},\qquad\frac{1-s}{3},\qquad\frac{2-s}{3}.
\]
Taking the union over the three residue classes gives exactly
\[
 \boxed{\ \left\{-\frac23,-\frac13,0,\frac13,\frac23\right\}. \ }
\]
These fractions are therefore neither accidental determinant factors nor
new bad primes.  They are the \((2,3,5)\)-\(E_8\) cubic-arm indicial
spectrum seen by an order-three operator.

## Multiplicity formula

Let \(c_s\) be the number of source generator chains with
\(h\)-exponent congruent to \(s\pmod3\).  The exact backward determinant is
\[
 \boxed{\quad
 \det K_-(j)
 =C\prod_{s=0}^2\bigl((3j+s)_3\bigr)^{c_s},
 \qquad C\ne0.
 \quad}
\]
Equivalently, the root multiplicities at
\((-2,-1,0,1,2)/3\) are
\[
 \boxed{\quad
 (c_2,\ c_2+c_1,\ c_0+c_1+c_2,\ c_0+c_1,\ c_0).
 \quad}
\]

This follows directly from the chain congruence.  For a primitive
generator of degree \(d\) in source degree \(N\),
\[
 12a+20b=N-d
\]
gives
\[
 b\equiv2\frac{N-d}{4}\pmod3.
\]
The exact determinant factorizations have degree \(3(c_0+c_1+c_2)\);
the displayed indicial roots account for that entire degree, so no
additional interior root is possible.

## The two former coincidences

The residue counts completely explain the previously unexplained
coincidences.

\[
\begin{array}{c|c|c}
\text{family}&(c_0,c_1,c_2)&
\text{multiplicities at }(-2,-1,0,1,2)/3\\ \hline
2&(0,1,1)&(1,2,2,1,0)\\
3&(1,1,1)&(1,2,3,2,1)\\
3'&(1,1,1)&(1,2,3,2,1)
\end{array}
\]

The \(3\)-source residues are \((2,1,0)\), whereas the \(3'\)-source
residues are \((0,1,2)\).  Their generators are different, but the
indicial determinant sees only the residue multiset.  This is why their
normalized backward determinants coincide.

For the exceptional monotone types, changing \(r\bmod3\) cyclically moves
the residue counts:
\[
\begin{array}{c|ccc}
\rho&s=0&s=1&s=2\\ \hline
4,4_s&(2,1,1)&(1,2,1)&(1,1,2)\\
5&(2,2,1)&(1,2,2)&(2,1,2)\\
6&(2,2,2)&(2,2,2)&(2,2,2).
\end{array}
\]
Hence \(4,4_s,5\) redistribute the same five roots across phases, while
the \(6\)-module is phase-independent because it has two chains in every
residue class.  The doubled degree-\(15\) generators are exactly what
balances its residue multiset.

## Meaning of the \(1/3\)-spaced boundary poles

The \(1/3\) separation in the later quadratic denominator pairs is the
same residue lattice reaching the endpoint Schur normalization.  It is
not a second unexplained spectrum.  The absolute offsets
\(11/12,7/12\) and \(49/60,29/60\) still depend on the chosen boundary
normalization, but their difference \(1/3\) is forced by adjacent
\(h\)-residue classes.

More generally, if a level is defined by a relation containing \(h^q\)
and an operator has indicial factor \((b)_k\), then the possible virtual
levels are
\[
 \left\{\frac{r-s}{q}:0\le r<k,\ 0\le s<q\right\}.
\]
The present \(E_8\) case has \(q=k=3\).

## Reproducibility

From `rust/`, run

```text
python3 ../notes/2026-07-30-c682-virtual-levels.py --check
python3 ../notes/2026-07-30-c682-virtual-levels-replay.py
```

The primary checker derives every \(h\bmod3\) residue directly from the
source degree and primitive generator degree.  It applies the indicial
multiplicity formula and matches:

- all three nontrivial plateau determinant polynomials coefficient by
  coefficient; and
- all twelve exceptional phase factorization profiles root by root.

The replay does not use the hard-coded generator lists.  It reconstructs
the exact free bases from the original covariant engines, reads the actual
\(h\)-exponents, and recovers every residue count and stored determinant
profile.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-30-c682-virtual-levels.py` | 7359 | `47c2a2fd8de631135a8baf30f4305ed7c9d86fdf1c3c6599483f043d681ce024` |
| `2026-07-30-c682-virtual-levels.json` | 8241 | `4b8950f070be659400498fff0438bafd1a5b5f455de01a0e439700fc28eeeb7a` |
| `2026-07-30-c682-virtual-levels-replay.py` | 2676 | `d5b5f9b7545329b766c9b91d60e8cd0b21b2773bd2a65af1ca63d8fed8cbe641` |

## `ej` + `tt` closeout

The `ej` gain is the complete multiplicity formula, not merely the root
set.  It explains the identical \(3,3'\) determinants, the phase-independent
\(6\)-profile, and every phasewise redistribution in \(4,4_s,5\).

The `tt` correction is to locate the phenomenon on the \(h^3\) arm of the
\(E_8\) relation.  The affine-\(E_8\) McKay graph determines which generator
chains occur; the fractional locations themselves come from the
order-three indicial symbol after rescaling the \(h\)-exponent by three.
Conflating those two roles had made the factors look more mysterious than
they are.

## Mystery ledger

- **Settled:** the virtual levels are the \(h=0\) indicial roots of the
  third transvectant in the degree-\(60\) \(h^3/F^5\) level.
- **Settled:** the exact multiplicity vector is
  \((c_2,c_2+c_1,c_0+c_1+c_2,c_0+c_1,c_0)\).
- **Settled:** the normalized \(3\) and \(3'\) determinants coincide
  because both have residue counts \((1,1,1)\).
- **Settled:** the \(6\)-profile is phase-independent because every phase
  has counts \((2,2,2)\).
- **Settled by `tt`:** \(E_8\) supplies the \(h^3/F^5\) level and the
  generator residues; order three supplies the falling-factorial roots.
- **Still open, non-load-bearing:** the nonzero determinant constants
  depend on primitive-generator normalization.  No coordinate-free formula
  for those scalars is claimed or needed.

C682 remains open exploration; completion remains the user's decision.
