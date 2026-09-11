# C1133 — integrate the audit without obscuring the theorem

**Lane:** `cubic-threefolds`. **Date:** 2026-09-10.
**Status:** concrete editorial proposal, not an enacted manuscript reorganization.
The author asks how to retain the unconditional current headline while
integrating the new proof material accessibly.

## The headline stays exactly as it is

> For every smooth complex cubic threefold X, the fourfold X×P¹ is irrational.

There are no additional quantum, genericity, transport, conjectural or
arithmetic hypotheses on X. “Generic” in the construction concerns auxiliary
quantum parameters; it does not mean a general cubic in moduli. Say this
once, early. Smoothness and the complex ground field are the theorem's
stated geometric scope; “hypothesis-free” should not erase that scope.

An unconditional theorem may use established external theorems. What must
not happen is to assume an abstract comparison contract and leave its
geometric instantiation unproved. The ring, independence and lattice
obligations belong to proved internal lemmas with the actual source maps.
Moving their proofs to an appendix changes their location, not their
logical status. The final proof must cite those lemmas explicitly.

## Recommended reader path

1. **Introduction:** the unchanged theorem, why surface centers obstruct the
   classical intermediate-Jacobian argument, and the four displayed values
   or properties below. Keep the distinction between auxiliary generic
   parameters and all-member geometric scope here.
2. **The obstruction and its transport:** define the selected rank-two block
   and its canonical residue concretely. State and prove the blowup formula
   by invoking a precise regular-transport lemma whose full coefficient
   proof is in Appendix A. Explain the retained lattice in one paragraph.
3. **Vanishing and the cubic calculation:** point/curve/surface vanishing,
   the cubic's two exponents, and the P¹ doubling lemma. Include the short
   ruled-product calculation p′²=Q, U=(2−2g)h+2p′. Appendix B proves its GW
   potential and the full mixed-bulk continuation. Finish the contradiction.
4. **Numerical Fano extension:** replace the existing scattered index-two
   and genus-eight consequences with one short section for A. A separate
   even-rank-three odd-dimension selector handles four additional families.
   This uses parity and dimensions, not a universal Hodge group. Supply the
   parity/Frobenius and b₂=1 surface arguments in Appendix C, and a compact
   nine-row endpoint table with precise every-member provenance.
5. **Hodge companion:** put B, C and D together in a separate mathematical
   companion, with B as its principal theorem. That is the natural home
   for Hodge-fixed bases, full-fiber equivariance, rational descent, generic
   Torelli and arithmetic intermediate Jacobians. The numerical paper can
   mention the companion's conclusions in one closing paragraph once that
   companion has complete proofs. They are not premises of its headline.

This preserves the stronger numerical classification in the paper while
letting a reader finish the cubic theorem before encountering it. B–D form
one coherent second story and do not force arithmetic or Tannakian theory
into the numerical proof. The author can still choose a single document;
in that case B–D should be a separate Part II with its own introduction,
not interleaved into the cubic proof.

## Draft introductory proof paragraph

> We construct a nonnegative integer I(Y) from the even quantum connection
> of a smooth projective variety. We prove that it vanishes on varieties of
> dimension at most two and obeys the blowup formula. For a smooth cubic
> threefold X, a direct calculation gives I(X)=1 and I(X×P¹)=2, whereas
> I(P⁴)=0. Projective weak factorization then rules out rationality of
> X×P¹. The construction uses generic auxiliary quantum parameters, but
> the calculation applies to every smooth cubic threefold. The comparison
> of coefficient rings and canonical lattices is proved in Appendix A.

The properties displayed next to this paragraph should be just

    I(Bl_Z Y)=I(Y)+(codim(Z,Y)−1)I(Z),
    I(Z)=0 for dim Z≤2,
    I(X×P¹)=2,             I(P⁴)=0.

Do not advertise the unnecessary arbitrary-projective-bundle formula in
this proof summary. The specialized P¹ result is sufficient and now has a
replacement proof in `2026-09-10-c1133-transport-input-reduction.md`.
There is also no need to introduce both exponent and lattice counts in the
opening: use the exponent count for the cubic and explain the slightly
stronger residue count when the degree-two Fano application first needs it.

## What the appendices must actually prove

**Appendix A — geometric transport.** Print the reduced ring with its
finite-total-grading and polynomial-unit conventions; prove faithfulness
for the actual occurrence maps; establish independent occurrence separation;
match the z-connection and regular inverse to Iritani's theorem; prove
functoriality of the canonical modified lattice. The main text gives the
idea and the precise lemma, so a skeptical reader has a short route to the
full proof. An assumption box named “comparison contract” is not a substitute.

**Appendix B — local computation and P¹.** Give the finite off-diagonal
gauge calculation producing the cubic residue, cyclic persistence in every
even bulk direction, rank-two residue transport, small tensor-lattice
matching, and the ruled-product potential, including its elliptic case and
unused horizontal Novikov variables. Keep the explicit four-dimensional
potential calculation in the text if it shortens the surface proof.

**Appendix C — A's additional finite inputs.** Give the parity extension,
the rank-three odd selector and its surface vanishing, and precise links
between the nine matrices and all smooth members of their families. The
eight rational controls need their geometric rationality citations, not
another eight quantum computations. Exact Hodge numbers and residue labels
can remain in the evidence table for readers interested in finer signatures;
A–D need less than that table contains.

These are proofs in the paper, not outsourced audit notes. The dated source
ledger, hostile reports, search transcripts, seventeen-family validation
checks and formal-coverage accounting remain in the verification companion.
The manuscript retains exact theorem citations and evidence references.
Conditional special-pencil material must stay outside the headline proof.

## Integration acceptance checks

- The headline has exactly its current geometric hypotheses and no
  “assuming the comparison contract” clause.
- Every technical proposition invoked in its proof is proved in the same
  paper or is a matched, established imported theorem.
- The main proof uses neither B–D nor an optional pencil statement.
- The broader projective-bundle formula is either removed from the revised
  numerical theorem list or retains its genuine IK dependency elsewhere.
- “Unconditional mathematical theorem” is not confused with “complete Lean
  coverage.” Existing formal annotations must continue to describe the
  actual formalization, even where that coverage is a conditional deduction.
- After author selection of this structure, update owning claim/proof
  records and annotations together, then run the required manuscript and
  formal-artifact gates before mirror synchronization. No such promotion
  or synchronization has occurred in this outline.

## EJ + TT and Mystery ledger

The useful economy is mathematical, not merely editorial: the P¹ replacement
removes a general reconstruction theorem, A removes the need for eight
control matrices, and B–D reuse one Hodge result. These reductions produce
the shorter reader path above. No new mathematical mystery arises from
the outline. The remaining choice is document architecture, owned by the
author; the remaining proof-integration gate is a consolidated manuscript
whose actual dependencies match these written proofs.
