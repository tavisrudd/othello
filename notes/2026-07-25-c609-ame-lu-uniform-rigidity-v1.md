# C609 — uniform MDS--CSS rigidity in AME-LU version 1

**Lane:** `ame-lu`

**Date:** 2026-07-25

**Status:** complete

## Result

The AME-LU version-1 headline now holds for every prime power \(q\), every
\(m\geq2\), and every pair of existing linear
\([2m,m,m+1]_q\) MDS codes.  If a product unitary, with an allowed party
permutation, intertwines their equal-phase CSS states, then every local factor
normalizes the finite-field Weyl group and is Clifford.

The associated one-logical-qudit quantum MDS encoder has parameters
\([[2m-1,1,m]]_q\).  If a product physical unitary implements a logical
unitary on this code, then every physical factor and the logical unitary are
Clifford.  Thus the code admits no transversal non-Clifford logical unitary.

The title is now

> *Local-Unitary Rigidity of MDS--CSS AME Tensors and Logical Clifford
> Phases of Six-Qudit Codes*.

The six-party pencil classification and logical-phase theorem retain their
previous exact field and admission scopes.  The manuscript explicitly
specializes to \(m=3\) before introducing that geometry.

## Proof upgrade

Retain an arbitrary \(m+1\) parties and shorten both \(C\) and \(C^\perp\)
on the complementary \(m-1\) coordinates.  MDS shortening gives two
\([m+1,1,m+1]_q\) codes.  Their nonzero generators have full retained
support, so their product plane projects bijectively to
\(\mathbb F_q^2\) at every retained party.

The entire reduced stabilizer operator forms a diagonal
\((m+1)\)-way tensor indexed by all \(q^2\) Weyl labels, including the
identity.  Since \(m+1\geq3\), the paper's rank-one contraction lemma
recovers each local Weyl axis intrinsically.  Marginal covariance therefore
forces every local adjoint action to permute Weyl axes, and conjugation fixes
the identity axis.  A retained set through each party proves the global
theorem.

For an encoder \(V\), the normalized Choi convention gives

\[
 (I\otimes U_{\rm phys})|\Psi_C\rangle
   =(L^T\otimes I)|\Psi_C\rangle
\]

from \(U_{\rm phys}V=VL\).  Hence
\(((L^T)^{-1}\otimes U_{\rm phys})|\Psi_C\rangle=|\Psi_C\rangle\), and
the rigidity theorem makes every displayed factor Clifford.  Entrywise
conjugation and adjoint both preserve the finite-field Clifford normalizer,
so transposition does as well and \(L\) is Clifford.

## Literature and priority boundary

The supplied broader novelty audit found no exact predecessor for either the
uniform MDS--CSS theorem or its transversal corollary and identified the
qubit minimal-support work of Rains and Van den Nest--Dehaene--De Moor as the
closest ancestor.  Its conclusion is useful advisory evidence, but its depth
codes and access records do not yet satisfy the repository's literature-audit
schema and cache requirements.  The manuscript therefore stamps priority by
stating the theorem and corollary in version 1 without saying “first,” “to our
knowledge,” or that the axis mechanism itself is new.

The manuscript credits the Rains--Van den Nest mechanism and identifies the
contribution precisely as its full-\(q^2\)-axis tensor, prime-power,
\([2m,m,m+1]\) MDS/CSS realization and Choi consequence.

## Lean successor

C601, C612, and C613 are queued as three acceptance gates for the complete
version-1 headline package.  Their combined plan has eight layers:

1. a length-generic code, equal-phase-state, marginal, and local-action API on
   `Fin (2*m)`, with a proved bridge to `[2m,m,m+1]` MDS terminology and the
   existing six-party definitions;
2. the code-independent diagonal-tensor axis theorem;
3. dual MDS and one-dimensional shortening on every retained
   \((m+1)\)-set;
4. the exact shortened marginal Weyl expansion;
5. marginal covariance and the Clifford-normalizer bridge;
6. the general LU-to-LC terminal and its compatible `[6,3,4]`
   specialization;
7. the Choi/transposition terminal for transversal logical gates; and
8. the existing odd-prime-field pencil composition.

C601 owns layers 1--3, C612 owns layers 4--6 and 8, and C613 owns layer 7,
including the one-leg encoder's quantum-MDS parameters.  No diagonal-axis,
shortening, marginal, covariance, Choi, transpose, distance, or
erasure-correction step may remain as an input structure.  C602 remains
queued after C613 for the complete aggregate, axiom, trust-ledger, prose, and
release audit.

## Related leads kept out of version 1

The user-supplied cross-paper synthesis exposed three high-value but
non-ready directions, recorded in the lane discovery track:

- marked cubic surfaces may organize the six-party non-GRS moduli and place
  the logical-phase jump on the conic weak-del-Pezzo boundary;
- the degree-eight pencil quotient may be the restriction of a classical
  cubic-surface invariant, but current evidence is only a degree
  coincidence; and
- a Clebsch deep-hole LU fingerprint requires an additional global
  LC-to-projective implication not supplied by LU-to-LC rigidity alone.

These do not alter C609's theorem or release gate.

## Validation

- `make check`: warning-free, 17-page XeLaTeX build; PDF SHA-256
  `3c7e23baabf69899ec710f2cf49b9bc09eb6cf0399424bf33db77485ab3e80a7`.
- The new title, abstract, opening two pages, generalized proof, Choi proof,
  and final bibliography page were visually inspected.
- The theorem map, claim/proof/novelty ledger, verification map,
  formalization ledger, statement-adequacy map, README, section map, live
  handoff, C601 plan, and queue row use the same scope.
- `make release-check`: all seven existing computational evidence bundles
  replayed; 35 public artifacts and 12 formal-companion artifacts verified.
  The revised public-tree SHA-256 is
  `567692bb11ee691952a20a2d664a872e47e56c5a4c8375aff3cb62b2953fe35a`;
  the unchanged formal tree is
  `91c8ba3c885a65e71adb0cf5cf3491086c3f810cec11673435112852983399de`.

## `ej` and Tao closeout

The free strengthening was to retain the paper's direct rank-one contraction
proof rather than importing a general Kruskal theorem: it proves the
arbitrary-\(m\) result with fewer hypotheses and keeps the mechanism visible.
The second free upgrade was the exact Choi orientation
\((L^T)^{-1}\otimes U_{\rm phys}\), followed by an explicit proof that
transpose preserves the finite-field Clifford normalizer.

The Tao-style stress test asked whether the theorem was merely a six-party
proof with symbols changed.  It is not: the only length-dependent input is
the exact MDS shortening
\([2m,m,m+1]\to[m+1,1,m+1]\) for both the code and its dual, and the tensor
argument needs only \(m+1\geq3\).  It also separated the general theorem from
the genuinely six-party structures: the \(z\)-quotient and logical
\(\mathrm{SL}_2\)-versus-torus phase remain special applications.

## Mystery ledger

| Feature | Closeout status | Remaining gap or owner |
|---|---|---|
| Whether the six-party rigidity proof extends to all even-length half-dimensional MDS codes | **Settled positively** by the generalized shortening and diagonal-axis proof | C601 owns unconditional Lean formalization |
| Whether the result constrains logical gates operationally | **Settled:** every product physical implementation has Clifford physical and logical factors | C601 owns the Choi/transposition formalization |
| Whether the supplied novelty audit licenses an explicit absence claim | **Settled negatively for this release:** its conclusion is advisory but its records do not meet the repository audit schema | A future repository-compliant audit may upgrade wording; version 1 makes no absence claim |
| Whether the six-party \(z\) and logical-phase results generalize with \(m\) | **Not implied and not claimed** | No successor allocated |
| Whether marked cubic surfaces give the right global six-party framing | Open lead | Discovery track; requires a separate proof and literature gate |
| Whether the Clebsch deep-hole conic is a complete LU fingerprint | Open: LU-to-LC alone does not supply global LC-to-projective equivalence | Discovery track; compare the Clebsch rigidity and holonomy domains |

**Vibe check:** this changes the manuscript from a specialized six-qudit
classification paper into a general MDS--CSS rigidity and fault-tolerance
theorem with a deep six-party application, while adding only one proof page.
