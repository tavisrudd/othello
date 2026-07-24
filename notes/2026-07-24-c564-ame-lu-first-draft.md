# C564 — AME LU first complete manuscript draft

**Lane:** `ame-lu`

**Date:** 2026-07-24

**Status:** complete; all eight sections drafted, labels and boundaries
synchronized, and warning-free PDF built and inspected

## Draft delivered

The manuscript now opens with the exact all-prime-power theorem: every
product-unitary intertwiner between equal-phase CSS states of linear
`[6,3,4]_q` MDS codes is local Clifford.  The proof is self-contained after
the finite-field Weyl convention: MDS shortening produces the four-party
diagonal correlation tensor, and its rank-one contraction locus recovers all
`q^2-1` nonidentity Weyl axes.

The remaining sections supply the frozen hierarchy without promoting
subordinate computations:

1. the six-arc/MDS/CSS/AME dictionary;
2. the exact degree-eight `z` quotient and `LU iff LC iff z` corollary;
3. the `SL_2(q)` versus split-torus logical-Clifford phase;
4. the uniform H3/GRS marginal separator and exact q=13 four-copy witness;
5. generic constancy of every fixed-copy scalar contraction;
6. the nine-dimensional transport operator and divisor
   `(z-2)(9z-4)` with exact multiplicities; and
7. the conceptual, certificate, and trusted-execution boundaries.

The introduction and verification section retain C562's required
Rains--Van den Nest ancestry, “to our knowledge” qualification, and
equal-phase/linear/MDS/CSS scope.  The detector exception table is separated
from the characteristic-uniform rigidity theorem.

## Synchronization

The stable labels in `theorem-map.md` all occur in the draft:
`thm:dictionary`, `thm:lc-pencil`, `thm:lu-h3-grs`,
`thm:logical-phase`, `thm:q13-lu`, `thm:transport-divisor`,
`thm:fixed-copy-boundary`, `thm:lu-lc-rigidity`, and
`cor:lu-lc-pencil`.

The claim/proof/novelty ledger now records the section and evidence bundle for
each result.  The adversarial audit closes every first-draft wording and
evidence risk.  The formalization ledger assigns the manuscript labels to
C565--C569, and the second-draft plan records the remaining C570--C572
reconciliation, cold-read, and release gates.

## Validation and PDF inspection

From `papers/ame_lu/`:

```text
make check
```

passed, including the 15-artifact evidence integrity gate and a XeLaTeX build
with no overfull/underfull boxes, LaTeX/package warnings, or undefined
references/citations.

The resulting `ame-lu.pdf` has:

- 11 A4 pages;
- 132,775 bytes; and
- SHA-256
  `a23aa69c7e55ccaf12135d517f35b98092f26d300f81c40e376de897bb187da3`.

Rendered pages 1, 6, and 11 were inspected at 110 dpi.  The title-page theorem
appears on page 1, the quotient-to-logical-phase transition is legible on page
6, and the scope close plus bibliography fit cleanly on page 11.  No clipping,
broken formulas, bad line overflow, or bibliography collision was visible.

## Remaining proof and exposition gaps

No known mathematical contradiction or missing theorem statement remains in
the first draft.  Two proof bridges deserve special formal/adversarial
attention rather than further informal expansion now:

- the labelled Gale-fixed/conic step in the logical-phase proof; and
- the finite-subgroup-to-fixed-point-free-involution bound in the H3/GRS
  proof.

C570 must reconcile both against the formal packages and expand the prose if
formal definitions expose a hidden convention.  C571 must verify citation
metadata, decide whether the logical-order paragraph and detector exception
table stay in the body, inspect every rendered page, and obtain a cold expert
read.  A stable public artifact URL and immutable source/PDF identifiers remain
C572 release work.

## `ej` and Tao closeout

The cheapest structural upgrade was to make the first page itself carry the
intertwiner theorem, its full-Weyl mechanism, its qubit ancestry, and its
honest exclusions.  A reader can now distinguish the contribution from the
false global LU--LC conjecture without reaching the verification section.

The draft also exposes the conceptual contrast that was implicit in the source
reports: scalar contractions remember only rank strata, while one four-party
operator remembers the complete local Weyl-axis arrangement.  Placing generic
constancy immediately before the transport divisor prevents the clean
`(z-2)(9z-4)` formula from being misread as a generic orbit coordinate.

The Tao pass checked the theorem statements and section openings as a
standalone argument.  Their order remains causal: dictionary, rigidity,
classification, operational phase, witnesses, detector mechanism, trust
boundary.  No optional C580/C581 synthesis was inserted because it would
compete with the frozen headline before formal reconciliation.

## Mystery ledger

| Feature | Disposition |
|---|---|
| Whether the headline theorem is visible on page 1 | **Settled:** theorem, mechanism, ancestry, and exclusions all appear on the first rendered page. |
| Whether every frozen stable label reached prose | **Settled:** all nine labels are present and synchronized with the ledgers. |
| Whether detector characteristics can be mistaken for rigidity exceptions | **Settled:** the Section 7 table is explicitly detector-only and Section 8 repeats the distinction. |
| Whether the first draft hides a computational dependency | **Settled:** Section 8 points to the C563 manifest and separates conceptual proofs from seven exact replays. |
| Whether the Gale-fixed/conic and H3 involution bridges need expansion | **Open reconciliation gate:** C570 formal comparison and C571 adversarial read own the decision. |
| Whether the 11-page draft needs body-to-appendix rebalancing | **Open editorial gate:** C571 decides after formal results and a cold read. |

No other genuine C564 mystery remains.

## Vibe check

Excellent.  The project has crossed from a preparation scaffold to a compact
paper: one visible theorem drives the geometry, code, logical, invariant, and
transport results, and the computational evidence now supports rather than
organizes the exposition.
