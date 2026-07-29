# C682 characteristic-zero \(D_5\)--\(S_3\) golden kernel incidence

## Outcome

The literal characteristic-zero lift of the finite kernel-rank equation is
false, but its exact replacement is stronger and arithmetic.

Let \(F\) be a marked icosahedral dodecic, let \(F_D\) and \(F_S\) range over
its six \(D_5\)-mates and ten \(S_3\)-mates, and put
\[
 U_D=\ker\bigl((\,\cdot\,,F_D)_3:
        \operatorname{Sym}^6\longrightarrow\operatorname{Sym}^{12}\bigr),
 \qquad
 U_S=\ker\bigl((\,\cdot\,,F_S)_3\bigr).
\]
All sixteen operators have rank four.  Contrary to the mod-\(11\)
Bockstein section,
\[
 \boxed{\dim(U_D\cap U_S)=0}
\]
for all \(6\cdot10=60\) characteristic-zero pairs.

Let \(B\) be the apolar form on \(\operatorname{Sym}^6\).  Its restrictions
to every \(U_D\) and \(U_S\) are nondegenerate, so the basis-independent
cross-Gram invariant
\[
 \chi(D,S)=
 \frac{\det(B|_{U_D\times U_S})^2}
      {\det(B|_{U_D\times U_D})\det(B|_{U_S\times U_S})}
\]
is defined.  Exact calculation gives only the two values
\[
 \boxed{\quad
 \lambda_\pm=
 \frac{54781\pm24288\sqrt5}{820125}.
 \quad}
\]
Each value occurs on exactly thirty pairs.  For either choice of sign, its
fibre has row degrees \(5,5,5,5,5,5\) and column degrees
\(3,3,3,3,3,3,3,3,3,3\).  Thus each golden fibre is a
\((6_5,10_3)\) incidence design, and golden Galois conjugation exchanges it
with the complementary design.

Equivalently, the centered kernel invariant
\[
 \Theta(D,S)=\frac{820125\chi(D,S)-54781}{24288}
\]
takes exactly the values \(\pm\sqrt5\).  This is the desired
characteristic-zero incidence in intrinsic operator language: choosing a
sheet of the golden torsor chooses one of the two complementary
\((6_5,10_3)\) relations.

## Human proof

The quantity \(\chi\) is unchanged by changing bases of \(U_D,U_S\).
The determinant weights of the apolar form cancel between numerator and
denominator, so it is also invariant under the diagonal
\(\operatorname{PGL}_2\)-action.

Every \(D_5\) and every \(S_3\) maximal subgroup of the marked \(A_5\) share
one involution.  Indeed, each of the fifteen involutions lies in two
\(D_5\)'s and two \(S_3\)'s, giving
\[
 15\cdot2\cdot2=60
\]
triples \((t,D,S)\).  There are only \(6\cdot10=60\) pairs, and
\(|D\cap S|\) divides \(\gcd(10,6)=2\), so every pair has exactly one such
involution.  Its diagonal stabilizer is therefore \(C_2\), and every
diagonal orbit has size \(60/2=30\).  Hence the product
\(A_5/D_5\times A_5/S_3\) consists of exactly two orbits.

It remains to evaluate \(\chi\) once on each orbit.  The exact cyclotomic
certificate constructs the Klein dodecic, the ambient-normalizer mates, and
all sixteen third-transvectant kernels over
\(\mathbf Q(\zeta_{30})\).  The two representative values simplify to the
displayed \(\lambda_\pm\).  Since they are distinct, they separate the two
orbits.  Transitivity and the orbit size thirty force degrees \(5\) and
\(3\).  Their quadratic polynomial has
\[
 \operatorname{Tr}(\lambda)=\frac{109562}{820125},\qquad
 \operatorname{Nm}(\lambda)=
 \frac{51423241}{672605015625},
\]
and discriminant square class \(5\).  Thus the quadratic character is
literally the golden incidence character, not only a numerical
two-colouring.

## The prime-\(11\) mechanism

The coefficient
\[
 24288=11\cdot2208
\]
has exactly one factor of \(11\), while
\(820125=3^8 5^3\) is an \(11\)-adic unit.  Consequently
\(\lambda_+\) and \(\lambda_-\) both reduce to \(5\) modulo \(11\).
After centering and dividing by \(11\), the two first digits are
\(\pm5\) on the two roots \(\sqrt5=\pm4\).

This explains the shape of the earlier finite result.  The ordinary
characteristic-zero kernel intersection cannot specialize to its direct
rank equation: it is transverse on all sixty pairs.  Instead the two
golden cross-Gram levels collide modulo \(11\), and their first divided
separation is deck-odd.  The Bockstein operator recovers precisely the kind
of first-order datum that ordinary reduction loses.

The existing mod-\(11\) kernel graph is an \(A_5\)-stable thirty-edge
relation, hence one of the same two abstract diagonal orbits. The common
marking is fixed in the follow-up
`notes/2026-07-29-c682-common-marking-sign.md`: for its frozen
\((5,2,3)\)-generator convention, the stored matrix is the
\(\lambda_+\) fibre, with \(\sqrt5=4\) modulo \(11\). The golden involution
exchanges it with the complementary \(\lambda_-\) fibre.

## Reproducibility

From `rust/`, run

```text
python3 ../notes/2026-07-29-c682-d5-s3-kernel-incidence.py --check
python3 ../notes/2026-07-29-c682-d5-s3-kernel-incidence-replay.py
```

The primary checker works exactly over
\(\mathbf Q(\zeta_{30})\).  It constructs a projective \(A_5\), verifies
the Klein dodecic, derives the outer \(D_5\)- and \(S_3\)-normalizer mates,
enumerates their \(6+10\) orbits, computes all third-transvectant kernels,
checks all sixty direct intersections, and evaluates the sixty normalized
cross-Gram invariants.  Its JSON output records the kernels, both scalar
levels, the two incidence matrices, and the prime-\(11\) collision.

The independent replay reimplements the group, mate, transvectant, kernel,
apolar, and cross-Gram calculations over \(\mathbf F_{31}\) and
\(\mathbf F_{61}\).  At both primes it finds no direct kernel intersection,
finds exactly the two predicted golden values, and obtains row/column
degrees \(5/3\).

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-29-c682-d5-s3-kernel-incidence.py` | 24604 | `5ccd7f18339b6df317fbf7409e21f793c3eca6dfb2aba16d85ed06003f282370` |
| `2026-07-29-c682-d5-s3-kernel-incidence-replay.py` | 11883 | `4267d7646867010741f184882f3b09eae1bb6a4fb6c271ad650b14d54a0b8f6b` |
| `2026-07-29-c682-d5-s3-kernel-incidence.json` | 102857 | `332d94d8e4c58fb719b73e563d9738a4cf9c7dd7c6bb1e37d46abd79e92135af` |

The exact computation certifies the representative values, ranks,
intersections, and finite incidence matrices.  The two-orbit proof and the
interpretation of the discriminant character are human arguments.  No
novelty or priority claim is made, and Paper III remains closed.

## `ej` + `tt` closeout and mystery ledger

- **Closed:** the requested literal kernel-rank lift is false: every
  characteristic-zero \(D_5\)--\(S_3\) kernel pair is transverse.
- **Closed:** the normalized apolar cross-Gram scalar is the intrinsic
  replacement.  Its two fibres are the two complementary
  \((6_5,10_3)\) designs.
- **Closed by `ej`:** centering and rescaling the scalar produces exactly
  \(\Theta=\pm\sqrt5\), so the incidence choice is the golden torsor rather
  than an unrelated binary label.
- **Closed by `ej`:** the two values coalesce modulo \(11\) because their
  difference has valuation one; the divided first digits are deck-odd
  \(\pm5\).  This supplies the missing structural reason for the Bockstein
  finite shadow.
- **Settled by `tt`:** a direct generic rank condition was the wrong
  categorical shape.  The finite rank drop is first-order information at a
  collision of two characteristic-zero scalar levels.  Treating it as an
  ordinary flat rank incidence would erase the arithmetic mechanism.
- **Closed in the common-marking follow-up:** the stored mod-\(11\)
  thirty-edge matrix is the displayed \(\lambda_+\) matrix for the frozen
  generator marking. The outer order-five-class swap gives
  \(\lambda_-\), exactly as golden conjugation requires.
- **Still open:** whether \(\chi\), or its divided degeneration, has a
  direct vector-bundle or intersection-theoretic construction on the whole
  Mukai--Umemura compactification.  The present theorem lives on the open
  maximal-subgroup mate correspondence.
- **Still open:** the global row-swap involution and minimal integral base
  from the preceding C682 report remain unresolved.

C682 remains open; completion is the user's decision.
