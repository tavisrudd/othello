# C901 Paper IV: Wu-persona cold read

## Frozen materials and scope

- Manuscript PDF: `papers/q13-passant-code/passant_code_q13.pdf`, SHA-256
  `715fdb6500c34386f92f61ba6fd328da8fd95a60e657c644e9e5a097e0b73fce`.
- Textual authority used because `pdftotext` was unavailable:
  `papers/q13-passant-code/passant_code_q13.tex`, SHA-256
  `12e19dd0c2f4a83e25f2a023ebd23b35bdb8415649cbac993853a0488a2ec033`.
- Madison--Wu, `arXiv:1104.0324`, SHA-256
  `f3edf20a2b63286164b3aced06a04a9039d7bbba2eb955a6461b7f7e793f6343`:
  Introduction, Section 2.1, Theorem 6.1(i), and Corollary 6.3.
- Droms--Mellinger--Meyer, `10.1007/s10623-006-0022-6`, SHA-256
  `26ee7b8336eb6e26d5a38c97ca0735d562484e5dc59c70df634d46487fb47337`:
  Section 4.3 and Theorem 4.9.

I reviewed only the manuscript abstract, introduction, operator-field
proposition, and spanning argument, stopping before ambient-plane recovery.
Consequently this report does not independently assess the distance-twelve
exclusion, the census and classification of the 364 minimum words, or the
ambient-plane reconstruction.

## Verdict

**MAJOR.** The operator calculation contains a sound and useful \(\F_8\)
subfield, but two stronger field/descent assertions are not established, and
the exact four pair-count identities on which the spanning clause of Theorem
1.1 depends are asserted without an auditable count or local-to-global
argument. The first two issues can be repaired largely by weakening language;
the spanning issue needs the missing finite proof or certificate in the paper.

## Strongest theorem supported by the reviewed argument

For the binary passant null space \(K\) of dimension \(36\), the displayed
scheme identities and the stated full-rank calculation for \(A_9+I\) imply
that the subalgebra \(\F_2[A_9]\) acts on \(K\) as \(\F_8\), so
\(K\cong\F_8^{12}\). Conditional on the four displayed identities
\[
 N_i^{\mathsf T}N_i\in\{A_9,A_{10},A_{12}\},
\]
each of the four minimum-word orbits spans \(K\). This is weaker than the
proposition's assertion about the image of the entire binary Bose--Mesner
algebra and weaker than the introduction's assertion that \(\F_8\) is the
full endomorphism field.

## Causal proof spine

1. The conventions agree with the assigned prior sources: rows are passant
   lines, columns are internal points, and the code is the binary column null
   space. Conic polarity permits the square symmetric ordering used in the
   manuscript. Madison--Wu supplies \(\dim_{\F_2}K=36\) and, over
   \(\overline{\F_2}\), a sum of three pairwise non-isomorphic simple
   twelve-dimensional \(\operatorname{PSL}(2,13)\)-modules.
2. With \(A_0=M\) and \(B=A_9\), the relation \(A_0B=0\) gives
   \(\operatorname{im}B\subseteq K\). If \(x\in K\) and \(Bx=0\), then
   \(A_0^2=I+B+B^2+B^4\) gives \(x=0\). Thus \(B|_K\) is injective; dimension
   then gives \(\operatorname{im}B=K\).
3. On \(K\), \(1+B+B^2+B^4=0\). The stated calculation
   \(\operatorname{rank}(B+I)=78\), together with
   \(1+t+t^2+t^4=(t+1)(t^3+t^2+1)\), yields
   \(B^3+B^2+I=0\). The cubic is irreducible over \(\F_2\), hence
   \(\F_2[B]\cong\F_8\), with \(B,B^2,B^4\) giving the three displayed
   conjugate scalar operators.
4. For each minimum-word orbit, the manuscript asserts that its binary support
   matrix has Gram matrix \(B\), \(B^2\), or \(B^4\). Any such Gram operator
   has image \(K\); that image lies in the row space of the support matrix,
   while all support rows lie in \(K\). Equality of the row space with \(K\)
   follows.

## Earliest unsupported implication

The earliest unsupported implication occurs in the introduction: Madison--Wu's
three algebraically closed constituents are said to form one Frobenius orbit,
and the manuscript immediately concludes that the binary form is irreducible
with endomorphism field \(\F_8\). The assigned Madison--Wu text proves neither
the stated Frobenius orbit nor the full commutant identification, and the
manuscript supplies no descent argument there. A transitive Frobenius orbit
would justify binary irreducibility after a short descent argument; identifying
the full endomorphism ring requires the additional commutant calculation.

## Ranked findings

1. **Proof gap / unexplained computation (direct effect on Theorem 1.1).**
   The spanning proof depends on the four exact identities for
   \(N_i^{\mathsf T}N_i\), but “direct pair counting in one intrinsic
   representative” does not specify the counted cases, the relation-orbit
   representatives, the actual concurrence counts before reduction modulo
   two, or why those local counts cover every matrix entry. The domain
   (four 91-word orbits on 78 coordinates) and acceptance criterion (equality
   with a named adjacency matrix) are visible, but the symmetry quotient and
   local-to-global transport are not; rejection and deduplication are not
   discussed. Supply a compact six-relation count table and the transitivity
   argument, or point to a certificate with an exact replay statement.

2. **Proof gap / overstatement (operator-field proposition).** The proof shows
   that the image of the subalgebra generated by \(A_9\) is \(\F_8\). It does
   not show that the image of the entire binary Bose--Mesner algebra is
   \(\F_8\): the actions of \(A_1\) and \(A_3\) are not determined by the
   displayed relations. Either add the omitted relations proving that every
   adjacency operator restricts to \(\F_2[A_9]\), or change the proposition to
   the precise and sufficient statement about \(\F_2[A_9]\).

3. **Missing proof/citation (descent and commutant).** The introduction's
   Frobenius-orbit assertion is not imported from Madison--Wu, and an
   irreducible cubic satisfied by \(A_9\) establishes an embedded scalar field,
   not by itself the full endomorphism field. Prove the Frobenius permutation
   of the three constituents and compute the commutant, or replace
   “endomorphism field” by “operator field” and avoid claiming binary
   irreducibility from the prior theorem. This does not obstruct the displayed
   spanning argument once Finding 1 is repaired.

4. **Unexplained computation (limited, but load-bearing for the operator
   construction).** The global binary domain and acceptance criterion for
   \(\operatorname{rank}(A_9+I)=78\) are clear, and no symmetry quotient,
   deduplication, or local-to-global step is needed. Nevertheless “exact
   elimination” gives no hand-checkable reduction or reproducible certificate.
   Because this one rank is what removes the factor \(t+1\), record an exact
   certificate or a concise reproducible elimination statement.

No matrix-orientation, polarity, field-of-definition, or exceptional-case
mismatch was found in the reviewed scope: \(q=13\equiv1\pmod4\), the
Madison--Wu group is initially \(\operatorname{PSL}(2,13)\), and its theorem
does give exactly three twelve-dimensional constituents and binary nullity
36.

## Novelty relative to the packet

Relative to Madison--Wu and Droms--Mellinger--Meyer, the genuine new point in
this scope is the marking of a conjugate scalar by the relation \(A_9\), its
recovery from minimum-word pair data, and the use of the resulting \(\F_8\)
operators to make each minimum-word family span.
