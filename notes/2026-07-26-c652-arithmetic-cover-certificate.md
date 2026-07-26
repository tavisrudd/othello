# C652 arithmetic Hitchin--Clebsch specialization

**Lane:** `clebsch`

**Date:** 2026-07-26

## Result

C652 proves the arithmetic specialization in human-readable form and leaves
only explicit carrier arithmetic to the certificate.

For \(t^2-t-1=0\), the six axes
\[
\begin{aligned}
 I_t=\{&
 [0:t:1],[0:t:-1],[1:0:t],[-1:0:t],\\
 & [t:-1:0],[-t:-1:0]\}
\end{aligned}
\]
are the two golden icosahedra on \(xyz=0\).  Their Galois exchanger is
\[
 R=\begin{pmatrix}1&0&0\\0&0&-1\\0&1&0\end{pmatrix},
 \qquad R(I_t)=I_{1-t}.
\]
The cubics through \(I_t\cup I_{1-t}\) form the line spanned by \(xyz\).
This gives the common tetrahedral hinge
\[
 \operatorname{Stab}_{\operatorname{SO}_3}(I_t)
 \cap
 \operatorname{Stab}_{\operatorname{SO}_3}(I_{1-t})
 \cong A_4.
\]

Modulo \(11\), the roots are \(4,8\).  The manuscript's displayed matrices
satisfy
\[
 M_4I_4=A,\qquad M_8I_8=A,\qquad
 M_8^{-1}M_4=3R,
\]
with determinants \(1,9\).  The reflection factorization
\[
 R=s_{e_2}s_{e_2-e_3}
\]
gives spinor class \(2\), a nonsquare modulo \(11\).  Under
\[
 \operatorname{SO}_3(11)/\Omega_3(11)
 \simeq
 \operatorname{PGL}_2(11)/\operatorname{PSL}_2(11),
\]
the reduced exchanger is therefore the nontrivial element of \(T_{11}\).

The exact C470 Hadamard carrier supplies two \(M_{11}\) parents of order
\(7920\), their frozen \(\operatorname{PSL}_2(11)\) intersection of order
\(660\), and their \(M_{12}\) join of order \(95040\).  Its row--column
outer automorphism exchanges the two parent classes.  After the explicit
marking
\[
 I_4\longleftrightarrow H_{\rm row},
\]
equivariance forces \(I_8\longleftrightarrow H_{\rm col}\).  This is a
marked \(C_2\)-torsor theorem.  There are exactly two unmarked equivariant
bijections and no canonical unmarked identification is claimed.

## Human proof and certificate boundary

Section 4 of Paper III now proves:

- the golden-axis identities, common norm, \(1/5\) angle, and six-arc
  property;
- the one-dimensional cubic space through both golden configurations;
- the \(A_4\) intersection by the standard degree-five action of \(A_5\);
- the exchanger and reflection-factor spinor calculation;
- the passage from spinor class to \(T_{11}\); and
- the marked-torsor compatibility lemma.

The compact primary certificate checks only:

- the six projective substitutions for each comparison matrix;
- \(M_8^{-1}M_4=3R\), the order of \(R\), and its exact reflection
  factorization;
- the orders, intersection, and join of the explicit twelve-point
  permutation carriers; and
- the recorded Hadamard outer images and conjugators that exchange the two
  \(M_{11}\) parent classes.

Thus no finite enumeration is used to infer the golden field, the \(A_4\)
hinge, the spinor formula, or the marked-torsor lemma.

## Independent replay

The replay imports no code from the primary checker.  It independently
implements projective normalization and matrix multiplication, reconstructs
the two six-axis sets, and enumerates the four relevant permutation groups
from the frozen C470 carrier generators.  It obtains
\[
 (|H_{\rm row}|,|H_{\rm col}|,
   |H_{\rm row}\cap H_{\rm col}|,
   |\langle H_{\rm row},H_{\rm col}\rangle|)
 =(7920,7920,660,95040)
\]
and separately checks the two carrier conjugators.

The C470 JSON is a hash-pinned primary input, not a conclusion copied as a
boolean.  Both C652 implementations rebuild the groups from its explicit
permutations.

## Reproduction

Run from `/home/tavis/src/othello`:

```text
python3 papers/clebsch-passages/verification/evidence/arithmetic_cover.py --check
python3 papers/clebsch-passages/verification/evidence/arithmetic_cover_replay.py
sha256sum -c papers/clebsch-passages/verification/evidence/arithmetic_cover.sha256
python3 papers/clebsch-passages/verification/verify_scaffold.py
cd papers && make -B clebsch-passages
```

Expected certificate output:

```text
C652 arithmetic-cover certificate: PASS
C652 independent arithmetic-cover replay: PASS
```

Artifacts:

| File | Bytes | SHA-256 |
|---|---:|---|
| `papers/clebsch-passages/verification/evidence/arithmetic_cover.py` | 8231 | `f018ddfb229cfcf713c033de3d2e4c8142dcc4dd99d88188dff6e6d79112f5f8` |
| `papers/clebsch-passages/verification/evidence/arithmetic_cover_replay.py` | 4829 | `702c5f3b3a5fe3a53ae86f18b7c25427cc505744da13108e8e4af6f95a03bd7a` |
| `papers/clebsch-passages/verification/evidence/arithmetic_cover.json` | 1746 | `a818554c3aa030b8f3851374d60c335b21eadf20d43d6065cc72cf211bc3d9a2` |

Primary input:

| File | Bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-22-c470-golay-hadamard-automorphisms.json` | 17878 | `694ddb709dce8b4b513b33fa899d23fe538528d76a0d82ec6b8779305e6f9a07` |

The scaffold now records HC-2, HC-4, and HC-5 as certified.  Paper III
remains non-release-ready because the C653 integral/novelty gate and the
C654 Klein gate remain open.

## Trust boundary

The arithmetic calculations use exact integers and finite-field reduction.
The Mathieu naming boundary remains C470's literal GAP comparison with the
standard Mathieu groups and its independent pure-Python replay.  C652
rechecks the explicit carriers and their relations; it does not repeat the
classification of the named sporadic groups.

Completeness of the two golden points in the geometric Hitchin fibre uses
Hitchin's classical ordered-icosahedron result.  C652 proves the explicit
specialization once that geometric cover is fixed.  C653 still owns the
integral model, exact exceptional-prime boundary, invariant-theory source
audit, and novelty disposition.

## Extra-juice and Tao closeout

The closeout pass moved two load-bearing ideas out of computation.  First,
the twelve golden axes impose nine independent linear conditions on ternary
cubics, leaving exactly the line \(\langle xyz\rangle\); this makes the
\(A_4\) converse visible.  Second, compatibility with the Mathieu carrier
is a marked free-\(C_2\)-torsor lemma.  No large carrier map or canonical
unmarked identification is needed or justified.

The remaining high-value question is not another finite certificate.  It is
C653's scheme-theoretic determination of the largest integral base on which
the Hitchin incidence cover and the explicit \(5\)-twist agree.

## Mystery ledger

- **Settled:** why the common golden stabilizer is \(A_4\): the union
  determines the cubic line \(xyz\), whose stabilizer in either icosahedral
  \(A_5\) is the degree-five point stabilizer.
- **Settled:** why the order-four matrix gives the finite sheet bit: its
  reflection factorization has nonsquare spinor class \(2\) modulo \(11\).
- **Settled:** what “Hitchin--Mathieu compatibility” means: it is unique
  after one marking and has exactly two choices without a marking.
- **No genuine C652 mystery remains.**
- **Owned by C653:** the integral normalization, bad-prime set, and
  primary-source/novelty boundary for the \(5\)-twist.
