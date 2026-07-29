# C682 characteristic-\(23\) divided cross-Gram separator

## Outcome

The characteristic-\(23\) divided separator has an intrinsic local-algebra
meaning, but it does not define a new \(\mathbf F_{23}\)-rational incidence
sheet.

Write
\[
 \chi=\frac{A+B\sqrt5}{D},\qquad
 A=54781,\quad B=24288,\quad D=820125
\]
for either golden cross-Gram value, with the sign absorbed into \(\sqrt5\).
Over \(R=\mathbf Z[1/30]\), the scalar image is globally the order
\[
 R[\chi]=R+253R\sqrt5
 \subset O=R[\sqrt5].
\]
It has index ideal \((253)=(11\cdot23)\), conductor \(253O\), and
normalization quotient \(O/R[\chi]\cong R/(253)\) as an \(R\)-module.  Thus
the two collision primes are exactly the two local defects of one global
scalar-image order.

Over
\[
 O_{23}=\mathbf Z_{23}[\sqrt5]
\]
the scalar \(\chi\) generates exactly the nonnormal order
\[
 \boxed{\quad
 \mathbf Z_{23}[\chi]
   =\mathbf Z_{23}+23\mathbf Z_{23}\sqrt5
   \subset O_{23}.
 \quad}
\]
This order has index \(23\), conductor \(23O_{23}\), and normalization
quotient \(O_{23}/\mathbf Z_{23}[\chi]\cong\mathbf F_{23}\).

Its coarse special fibre is the doubled point
\[
 \mathbf Z_{23}[\chi]/23\mathbf Z_{23}[\chi]
 \cong \mathbf F_{23}[\epsilon]/(\epsilon^2),
\]
whereas the special fibre of its normalization is the inert étale algebra
\[
 O_{23}/23O_{23}\cong\mathbf F_{23^2}.
\]
The specialization map kills \(\epsilon\).  Thus the cross-Gram scalar image
and the normalized golden cover have genuinely different special fibres even
though the cover itself has good reduction.

The canonical trace-zero divided coordinate after clearing the fixed
denominator is
\[
 \eta_{23}=\frac{D\chi-A}{23}
           =\frac{24288}{23}\sqrt5.
\]
Modulo \(23\),
\[
 \boxed{\quad
 \eta_{23}=-2\sqrt5,\qquad
 \eta_{23}^2=-3,\qquad
 \operatorname{Tr}(\eta_{23})=0,\qquad
 \operatorname{Nm}(\eta_{23})=3.
 \quad}
\]
The polynomial \(T^2+3\) is irreducible over \(\mathbf F_{23}\), and
\(\eta_{23}^{23}=-\eta_{23}\).  Adjoining this divided coordinate to the
scalar-image order recovers its normalization.  It is therefore the missing
normalization generator, or equivalently the first divided deck-odd
coordinate at the cross-Gram collision.

## Proof

The prior exact cross-Gram calculation gives
\[
 B=24288=2^5\cdot3\cdot11\cdot23,\qquad
 D=820125=3^8\cdot5^3.
\]
Since \(2\) and \(3\) are units in \(R\), translating by \(A/D\) first gives
\[
 R[\chi]=R+B R\sqrt5=R+253R\sqrt5.
\]
The global index, conductor, and quotient follow in the basis
\(1,\sqrt5\).

Hence \(D\) is a \(23\)-adic unit and \(v_{23}(B)=1\).  Translating \(\chi\)
by \(A/D\) and multiplying by the unit \(D\) shows
\[
 \mathbf Z_{23}[\chi]
 =\mathbf Z_{23}[23u\sqrt5]
 =\mathbf Z_{23}\oplus23\mathbf Z_{23}\sqrt5,
 \qquad u=B/23D\in\mathbf Z_{23}^{\times}.
\]
In the basis \(1,\sqrt5\), multiplication by \(\sqrt5\) shows directly that
the conductor is \(23O_{23}\).  Reduction in the order's own basis
\(1,23\sqrt5\) gives a nonzero square-zero second basis vector, proving the
dual-number description.  Reduction after normalization instead gives
\(\mathbf F_{23}[s]/(s^2-5)\).

Quadratic reciprocity gives \((5/23)=-1\), so the latter algebra is the field
\(\mathbf F_{529}\).  Finally \(24288/23=1056\equiv-2\pmod {23}\), whence
\(\eta_{23}^2=4\cdot5=20=-3\).  Its conjugate is \(-\eta_{23}\), so its trace
is zero and its norm is \(3\).  In the quadratic finite field Frobenius is
the nontrivial conjugation, giving \(\eta_{23}^{23}=-\eta_{23}\).

Because \(B/23\) is a unit, \(\mathbf Z_{23}[\eta_{23}]=O_{23}\).  This proves
the normalization claim without any new kernel-rank or orbit computation.

## Relation to the prime-\(11\) shadow

Both collision primes have the same order-theoretic mechanism:
\[
 \mathbf Z_p[\chi]=\mathbf Z_p+p\mathbf Z_p\sqrt5,
 \qquad p\in\{11,23\}.
\]
At \(11\), however, \(5\) is a square.  The normalized special fibre is
\(\mathbf F_{11}\times\mathbf F_{11}\), so the divided coordinate separates
two rational sheets and can agree with the stored Bockstein incidence
matrix after the common marking is fixed.

At \(23\), \(5\) is a nonsquare.  The normalized special fibre is connected,
and Frobenius exchanges the two geometric sheets.  Over \(\mathbf F_{529}\)
the same two complementary \((6_5,10_3)\) relations reappear, but neither is
defined individually over \(\mathbf F_{23}\).  Thus there is no
characteristic-\(23\) analogue of the rational mod-\(11\) incidence section.
The new structure is the conductor defect of the scalar image and its
normalization, not a degeneration of the normalized golden cover.

## Reproducibility

From `rust/`, run

```text
python3 ../notes/2026-07-29-c682-characteristic-23-divided-separator.py --check
python3 ../notes/2026-07-29-c682-characteristic-23-divided-separator-replay.py
```

The primary checker verifies the exact factorizations, both collision-prime
local-order invariants, the prime-\(23\) collision value, the divided
minimal polynomial, norm, and Frobenius action.  Its compact JSON certificate
records the resulting order and special-fibre descriptions.

The independent replay uses the presentation
\(\mathbf F_{23}[w]/(w^2+3)\), rather than the primary checker's
\(\sqrt5\)-basis.  It exhausts all \(529\) elements, verifies that every
nonzero element is invertible, checks \(w^{23}=-w\), and separately verifies
the unit and nilpotent counts in the \(529\)-element dual-number algebra.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-29-c682-characteristic-23-divided-separator.py` | 6067 | `ea0b56e746660f70f2be5cece0a6fa75b49e790884911128c3d3f963e96afd93` |
| `2026-07-29-c682-characteristic-23-divided-separator-replay.py` | 2081 | `4a74a8bffdbe0c6f6258cc5a26fac4524f8657ec65eaba72aadcb6861711e6f5` |
| `2026-07-29-c682-characteristic-23-divided-separator.json` | 2770 | `d4b22f4d2774dadda418abfcb01e7d2ba3b43f10a44889d65a50c4ef68177592` |

The computation certifies the finite and integral arithmetic stated above.
The identification of this order with the cross-Gram scalar image uses the
previously certified exact formula for \(\chi\).  No new claim about
Mukai--Umemura geometry, operator ranks, novelty, or priority is made.

## `ej` + `tt` closeout and mystery ledger

- **Closed:** the characteristic-\(23\) divided separator is the missing
  generator in the normalization of the index-\(23\) cross-Gram scalar
  order.
- **Closed by `ej`:** the coarse scalar image has a dual-number special
  fibre, even though the normalized golden cover is finite étale.  This
  makes the failure of scalar separation scheme-theoretic rather than merely
  a congruence of two displayed numbers.
- **Closed by `ej`:** the primes \(11\) and \(23\) are one conductor
  phenomenon with different splitting types: globally the scalar image is
  the conductor-\(253\) order \(R+253R\sqrt5\).  The mod-\(11\) Bockstein
  section is rational because \(11\) splits; the prime-\(23\) divided
  coordinate is Frobenius-odd because \(23\) is inert.
- **Settled by `tt`:** no new \(\mathbf F_{23}\)-rational thirty-edge
  incidence relation should be sought.  Such a relation exists only after
  passing to \(\mathbf F_{529}\), where its conjugate is the complementary
  relation.
- **No genuine characteristic-\(23\) mystery remains:** the divided
  separator has an exact normalization/conductor interpretation.  A more
  elaborate geometric interpretation would need new evidence beyond the
  scalar-image order and is not forced by this prime.

C682 remains open; completion is the user's decision.
