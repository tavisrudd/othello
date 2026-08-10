# C900 layered opening gate

## Verdict

**NO-GO.** Two opening-layer defects remain actionable for an adjacent
combinatorics/coding reader.

## Actionable defects

1. The abstract first uses “rank-three projective realization” without an
   operational gloss.  The introduction later supplies the needed meaning
   (“the chords indexed by every matching block are concurrent”), but layered
   exposition requires that meaning at first use.  Add that short clause in the
   abstract, or defer the term to the introduction.

2. The theorem labelled `thm:main-conic` does not state its ambient hypothesis.
   Its phrase “every \(k\)-arc complete outside a prescribed set of \(q+1\)
   points” omits that the arc lies in a projective plane of order \(q\), and it
   does not explicitly state that the prescribed set is disjoint from the arc.
   Those assumptions can be reconstructed from the surrounding definitions and
   `thm:main`, but the displayed headline theorem is not self-contained.  Put
   both hypotheses in the theorem statement.

## Checks that pass

- `MATCH(k,\lfloor k/2\rfloor,1)` receives an operational meaning at first use:
  maximum-matching blocks, with every pair of independent edges occurring once.
- Kneser adjacency is defined explicitly as disjointness of endpoint pairs.
- The dual star--matching form is translated immediately into star lines for
  incident edges and matching lines for disjoint edges.
- The opening cleanly separates ordinary analytic proofs, the kernel-checked
  order-16 exclusion, trusted classifier executions at orders 13, 17, and 19,
  and independently checked attaining witnesses.
- The proof map gives the causal route and identifies the difficult
  characteristic-two step.  The first-pass reading map distinguishes the proof
  spine from optional appendices.
- The coding paragraph is genuinely optional, fixes the projective
  parity-check convention, translates uncovered points into weight-three
  syndrome directions, and says that the dictionary is not a proof input.
- Literature boundaries are specific and nonrepetitive: classical secant
  equations versus the new local remainder; prior subgeometry localization
  versus arbitrary prescribed holes; and established matching designs versus
  their secant-concurrency realization.
