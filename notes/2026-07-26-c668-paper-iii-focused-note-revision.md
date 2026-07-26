# C668 Paper III focused-note revision

**Lane:** `clebsch`

**Date:** 2026-07-26

## Result

Paper III is now the focused note
_Arithmetic and harmonic realizations of the Clebsch cubic_. Its theorem
has two legs:

1. Hitchin's ordered-icosahedron incidence cover has rational square class
   \(5J_0\); on the nonbranch Clebsch chart it is the constant golden
   torsor, whose displayed fibre and exchanger specialize at \(11\) to the
   finite sheet bit and signed cubic line.
2. The same Clebsch cubic line is the exact restriction of the degree-six
   Gaunt cubic on the ten icosahedral face axes.

The revision removes the tetrahedral-hinge proposition, the marked
Hitchin--Mathieu corollary and carrier discussion, the proposed physical
descriptor, the empirical claim row, and the research-inventory paragraph.
Those statements remain preserved in their completed task reports and
evidence bundles; none is needed by the paper's main theorem.

The title page names Tavis Rudd. The bibliography has eight references,
including the Mukai--Umemura source, the two Hitchin papers, Dye,
binary-sextic invariant theory, both Steinhardt sources, and DLMF for the
Gaunt/\(3j\) identity.

## Global square class

The central arithmetic step is no longer compressed into one inference.
The proof now separates three stages.

First, if \(K=\mathbf Q(\mathbf P(H))\), Hitchin's integral incidence
variety gives a quadratic extension \(K(\sqrt d)\). Its only branch divisor
is the irreducible sextic \(J_0=0\). Hence
\[
 \operatorname{div}(d/J_0)=2D.
\]
Because \(\operatorname{Pic}(\mathbf P(H))=\mathbf Z\) has no
two-torsion, \(D\) is principal, so
\[
 d=cJ_0g^2,\qquad
 c\in\mathbf Q^\times/\mathbf Q^{\times2}.
\]

Second, Hitchin's fibre over \(xyz\) consists of the two ordered
icosahedra defined by \(t^2-t-1=0\), while
\(J_0|_V=16\sigma_3^2\). Since \(J_0(xyz)\) is a nonzero rational square,
that fibre identifies \(\mathbf Q(\sqrt c)\) with
\(\mathbf Q(\sqrt5)\). Thus \(c=5\).

Third, on \(D(\sigma_3)\), dividing the odd generator by
\(4\sigma_3\) gives an element whose square is \(5\), explicitly
trivializing the restricted cover as the constant golden torsor.

This is a rational function-field proof. The manuscript continues to
distinguish it from the abstract integral algebra and from the geometric
incidence comparison over an unspecified localization.

## Self-contained finite interface

The finite tensor bridge no longer starts with unexplained Paper II
notation. It now defines:

- the standard conic \(Q=XZ-Y^2\);
- the normalized secant \(L_{ab}\);
- the matching product \(P_M\);
- the matching-independent restriction
  \(P_M(\nu(s:t))=\prod_a[a,(s:t)]\);
- the quartic quotient \(q_M=(P_M-P_{M_0})/Q\);
- the 22-element matching orbit and its two
  \(\operatorname{PSL}_2(11)\)-orbits; and
- the signed tensor \(\sum_M\epsilon(M)q_M^{\otimes3}\).

The theorem can therefore be read without importing the factorization
paper's notation or narrative. Its geometric origin remains in Paper II,
but its hypotheses and conclusion are now local to Paper III.

## Editorial disposition

The C669 audit showed that the marked Mathieu corollary becomes formal once
two free transitive \(C_2\)-sets and one marking are chosen. C668 therefore
removes it rather than trying to motivate it with more sporadic-group
context. The accompanying \(A_4\) intersection result is also correct but
does not enter the square class, specialization, tensor bridge, or harmonic
restriction, so it is removed from the note.

The degree-six theorem retains its exact equality with the standard
Steinhardt \(W_6\) normalization. It no longer proposes a normalized
four-channel physical descriptor or lists possible materials uses. The
harmonic calculation now functions as an exact invariant-theoretic
realization, not an application pitch.

The final common-line section states the two honest noncomparisons:

- the rational Gaunt scalar has denominator divisible by \(11\), so the
  characteristic-zero and finite scalars do not reduce into one another;
  and
- good reduction of the displayed fibre and exchanger does not supply a
  global integral incidence model at \(11\).

## Verification

The statement surface contracts from nine theorem-like statements and
twelve claim rows to seven theorem-like statements and nine load-bearing
claim rows. The extractor's expected label set, trust manifest, verification
guide, and work plan were synchronized with the revised source.

The aggregate runner passes all thirteen checks:

```text
Paper III release: PASS [statement identity]
Paper III release: PASS [trust manifest]
Paper III release: PASS [finite tensor primary]
Paper III release: PASS [finite tensor independent replay]
Paper III release: PASS [arithmetic cover primary]
Paper III release: PASS [arithmetic cover independent replay]
Paper III release: PASS [harmonic bridge primary]
Paper III release: PASS [harmonic bridge independent replay]
Paper III release: PASS [manuscript build]
Paper III release: PASS [warning-free manuscript build]
Paper III release: ALL CHECKS PASS
```

The evidence programs still audit the archived finite Mathieu carriers,
but the trust manifest and manuscript make clear that those outputs are not
used by the focused note.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `papers/clebsch-passages/clebsch_passages.pdf` | 111,957 | `d8adb94def8d5fbde74557873dbd47dae0a164d4b54f860d942ddd69993cad3d` |
| `papers/clebsch-passages/verification/statement_identity.json` | 8,379 | `3ec63d886b776fcad1de24f1b8f5bab0168edb96251443afc63746b1ec15e486` |
| `papers/clebsch-passages/verification/trust_manifest.json` | 6,880 | `56fc3b841c42ed7ea915e05fa5af8bf96114bd19425aee9f81326beb9d8478d7` |

## C670 boundary

C668 establishes a green revised candidate, not the final publication
verdict. C670 must review the regenerated PDF without the earlier review
or task history and test:

- whether the two theorem legs now read as one focused note;
- whether the branch-divisor-to-golden-fibre argument is complete at the
  level expected by an arithmetic geometer;
- whether the finite matching interface is genuinely self-contained;
- whether any residual Paper II dependency is rhetorical rather than
  logical;
- whether the harmonic leg earns equal headline weight; and
- whether the title page visibly carries the author name.

## Extra-juice and Tao closeout

The closeout found one additional detachable result beyond the explicit
review: the tetrahedral \(A_4\) hinge. It is a genuine geometric fact, but
it contributes neither to determination of the square class nor to either
cubic realization. Removing it eliminates a second group-theoretic
excursion and makes the arithmetic-specialization section causal from
start to finish.

The same pass promoted the finite bridge's quotient construction from
borrowed notation to a three-line local derivation. This is a cheap but
important independence upgrade: Paper III still uses Paper II's exact orbit
as input, but no longer asks its reader to reconstruct what \(q_M\) means.

## Mystery ledger

- **Settled:** the missing step from the branch sextic to a rational square
  class is the divisor-parity argument plus the absence of two-torsion in
  \(\operatorname{Pic}(\mathbf P(H))\).
- **Settled:** the golden \(xyz\) fibre determines the residual constant
  square class \(c=5\).
- **Settled:** the finite tensor theorem now states its matching-secant
  quotient input self-containedly.
- **Settled:** the Mathieu carrier, tetrahedral hinge, speculative
  descriptor, and research inventory are not needed by the focused note.
- **Open for C670:** whether a cold arithmetic-geometry reader accepts the
  local fibre evaluation and the two-leg hierarchy without reconstructing
  omitted context.
- **Open but outside C668:** the minimal integral bad-prime set and a common
  integral normalization of the Gaunt and finite scalars require new
  arithmetic input.
- **No other C668 mystery remains.**

## Vibe check

Good. The revision is shorter, more self-contained, and more credible: the
paper now spends its space proving the arithmetic normalization and exact
harmonic bridge rather than defending attractive side correspondences.
