# C654 Klein multiplicity relative position

**Lane:** `clebsch`

**Date:** 2026-07-26

## Verdict

The exact relative-commutant calculation is positive, but the
discriminant-five lift is negative.

Let \(G=\operatorname{PSL}_2(11)\), and let \(V\) be the ten-dimensional
rational Klein representation.  There is an exact model
\[
 V=\ker(A+3I)\subset \mathbf Q^{55},
\]
where \(G\) acts by conjugation on its 55 involutions and \(A\) joins two
distinct involutions precisely when they commute.  The certificate gives an
integral basis of \(V\), exact \(10\)-by-\(10\) matrices for two generators
of \(G\), and the invariant Gram matrix \(B\).
Its conjugacy-class fingerprint, recorded as
\((\text{order},\text{class size},\text{trace})\), is
\[
 (1,1,10),\ (2,55,2),\ (3,110,-2),\
 (5,132,0)^2,\ (6,110,2),\ (11,60,-1)^2.
\]
This is the rational sum of Hartlieb's two conjugate degree-five
characters, so the exact carrier is identified with the Klein
intermediate-Jacobian representation rather than only matched by dimension.

For representatives \(H_+\) and \(H_-\) of the two conjugacy classes of
icosahedral subgroups,
\[
 C_\pm=\operatorname{End}_{H_\pm}(V)
       \simeq M_2(\mathbf Q).
\]
Both commutants have dimension four and contain an explicit rational
rank-five idempotent, which rules out a quaternion division algebra and
certifies the split matrix algebra.  The two subgroups intersect in order
ten and generate all of \(G\).  Their commutants therefore meet in the
two-dimensional \(G\)-commutant.  The certificate supplies its generator
\(K\), with
\[
 K^2=-11I,\qquad K^{\mathsf T}B+BK=0.
\]
Consequently
\[
 C_+\cap C_-=\mathbf Q[K]\simeq\mathbf Q(\sqrt{-11}),
 \qquad \Omega=BK
\]
is a nondegenerate \(G\)-invariant rational alternating polarization form.
This identifies the CM field and the polarization line; it does not claim
that the displayed integral basis is symplectic or that \(\Omega\) is the
principal integral form of the intermediate Jacobian.

## Canonical mixed invariant

For a subgroup \(H\), define the basis-free Reynolds projector
\[
 P_H(T)=\frac1{|H|}\sum_{h\in H}hTh^{-1}
 \quad\text{on }\operatorname{End}_{\mathbf Q}(V).
\]
It is the orthogonal projection onto
\(\operatorname{End}_H(V)\) for the Rosati trace form induced by any
\(G\)-invariant polarization.  Thus the conjugacy class of
\[
 T_{+-}=P_+P_-P_+\bigm|_{C_+}
\]
is a canonical invariant of the ordered pair of embedded commutants with
polarization; no choice of rank-one idempotents is involved.

The exact characteristic polynomial is
\[
 \chi_{T_{+-}}(x)
  =(x-1)^2\left(x-\frac1{12}\right)^2.
\]
The \(1\)-eigenspace is exactly
\(C_+\cap C_-=\mathbf Q(\sqrt{-11})\).  On its trace-orthogonal
two-dimensional complement, the mixed operator is the scalar \(1/12\).
Hence the nontrivial factor has discriminant zero, not five.  There is no
\(\mathbf Q(\sqrt5)\) splitting field in this canonical first-order
relative-position invariant.

The value \(1/12\) also has a short structural derivation.  Since
\(K=C_+\cap C_-\) lies in both commutants, both Reynolds projectors and
their composite are \(K\)-bimodule maps.  The decomposition
\[
 M_2(\mathbf Q)=K\oplus K^\perp
\]
has two simple two-dimensional \(K\)-bimodule summands.  On the second
summand a bimodule endomorphism lies in \(K\); self-adjointness for the
positive Rosati trace form forces it into the fixed field \(\mathbf Q\).
Thus the residual operator is scalar before any matrix diagonalization.

The exact product-order histogram for
\((h_+,h_-)\in H_+\times H_-\) is
\[
\begin{array}{c|rrrrrr}
o(h_+h_-)&1&2&3&5&6&11\\ \hline
\#&10&350&650&1440&550&600.
\end{array}
\]
For the rational character \(\chi\) above,
\[
 \operatorname{tr}(P_+P_-)
 =\frac1{60^2}\sum_{h_+,h_-}\chi(h_+h_-)^2
 =\frac{13}{6}.
\]
The common field contributes trace \(2\), leaving \(1/6\) on a
two-dimensional scalar summand.  Its eigenvalue is therefore \(1/12\).

This closes the simple Klein period-lattice lift negatively.  It does not
exclude a genuinely higher-order invariant or a cycle-level invariant of
Roulleau's 55 curves; neither is part of C654.

## Exact evidence

The primary calculation exhaustively constructs all 660 group elements,
all 55 involutions, and all 22 \(A_5\) subgroups.  It finds the two
subgroup classes by their degree-eleven orbit types \(1+10\) and \(5+6\),
checks their order-ten intersection and order-660 join, computes both
commutants and their intersection over \(\mathbf Q\), and evaluates both
Reynolds projections exactly.  It also certifies the full rational
character fingerprint and the \(H_+H_-\) product-order histogram used in
the structural trace proof.

From the repository root, replay with:

```text
python3 papers/clebsch-passages/verification/evidence/klein_relative_position.py --check
python3 papers/clebsch-passages/verification/evidence/klein_relative_position_replay.py --check
```

The second checker is an independent modular reconstruction at primes
1009 and 1013.  Starting from the certified generator matrices, it rebuilds
the 660 paired group elements, independently recomputes the carrier
nullity, subgroup orders, joins, commutant dimensions, split idempotents,
polarization identities, Reynolds projectors, and the two mixed
eigenspaces.  It also independently reconstructs the conjugacy-class traces,
the product-order histogram, and the \(13/6\) projection trace.  Agreement
at these primes is a cross-check of the rational
calculation, not a substitute for it.

The deterministic evidence bundle is:

| file | bytes | SHA-256 |
|---|---:|---|
| `klein_relative_position.py` | 21438 | `d0781ba1bbdc1ed53b911ecd68aa025b3bc53333b190936ed7955104348b4f6c` |
| `klein_relative_position_replay.py` | 13181 | `c5efff66d5f72a6cc302cc70ed10884dbc2e0ae496cb1fbc4034177fa2d030bf` |
| `klein_relative_position.json` | 15928 | `2c896a12a584c86d1ed7b38b61539b2689f17cf48322a4ce8850e2e21ddf0631` |

The adjacent `klein_relative_position.sha256` is the checksum manifest.
The computation is deterministic and uses only the Python 3 standard
library.  No random seed or external algebra package is involved.

## Trust boundary

The certificate proves the finite-group, rational-linear-algebra, and
mixed-spectrum assertions above.  The identification of this rational
representation with the Klein intermediate-Jacobian carrier continues to
use Hartlieb's character calculation and Roulleau's CM description, audited
in `notes/2026-07-26-klein-cubic-multiplicity-hodge-carrier.md`.  The
certificate does not reconstruct a period matrix, identify the integral
principal polarization lattice, or calculate the 55-curve Néron--Severi
saturation.

## `ej` + `tt` closeout

The cheap upgrade is stronger than a bare negative: after removing the
common CM field, the two split commutants are equi-isoclinic with squared
cosine \(1/12\).  The \(K\)-bimodule and character-trace argument now
derives that value without diagonalizing the mixed matrix.  This explains
why every attempted quadratic
discriminant collapses—the remaining two directions are not separated at
all by the first-order angle operator.  Explicit rank-five idempotents were
also added to the certificate so that \(C_\pm\simeq M_2(\mathbf Q)\) is
proved rather than inferred from dimension.

The high-value consequence is editorial: Paper III must not use the Klein
period lattice as a source of its golden quadratic field.  The established
\(\mathbf Q(\sqrt5)\) orientation torsor remains the arithmetic-cover
phenomenon proved in C652--C653, while the Klein carrier contributes the
distinct CM field \(\mathbf Q(\sqrt{-11})\).

## Mystery ledger

- **Settled:** why the mixed invariant fails to reveal a quadratic field.
  Its noncommon spectrum is the repeated rational value \(1/12\), so the
  discriminant is zero.
- **Settled:** whether the two four-dimensional commutants might be
  quaternionic.  Each has a certified rational rank-five idempotent and is
  \(M_2(\mathbf Q)\).
- **Open, outside C654:** whether the equi-isoclinic constant \(1/12\) has a
  direct geometric interpretation in the 55-curve configuration.  The
  exact evidence gap is a cycle-class comparison, not another
  representation calculation.
- **Open, outside C654:** whether the index-two saturation of Roulleau's
  55-curve lattice sees the finite orientation torsor.  This requires an
  integral Néron--Severi calculation and is not licensed by the rational
  commutant result.
