# Referee dossier: exact transfer and relative weights

This internal dossier records the questions an independent reader should test.
It contains no score, venue recommendation, or overall quality judgment.

## Principal claim

For the associated nested pair `K_P <= D_P`, the `t`th relative generalized
Hamming weight is the minimum helper-union cost for recovering a
`t`-dimensional target message subspace. For a target block with nonzero outer
projection and at least two outer blocks, minimizing prescribed-coset support costs over linear maps into
the complete outer functional dual gives the exact finite first nonconfined
cost. For a fixed outer code with at least two blocks and
`d(O^perp)>r+1`, this criterion reduces to

```text
r < M_t(D_P,K_P) + d(I^perp).
```

Below the gate, restriction and zero-extension are inverse on normalized
recovery systems and preserve exact helper supports. Outer dual-distance
growth makes the finite outer gate automatic at fixed radius.

## Questions for the main proof

1. Does the definition distinguish target coefficient dimension from recovered
   message dimension?
2. Does the complement argument prove equality with the standard RGHW rather
   than a restricted variant?
3. Do the prescribed-coset costs minimize union support of a whole linear
   image, rather than separate supports of chosen basis vectors?
4. Is the target normalization minimized jointly with the target helper map?
5. Does the block-functional proof retain every nonzero outer-functional map
   until the explicit finite outer gate removes it?
6. Is the target-block projection hypothesis used to identify nonzero
   functional sectors with nonconfinement?
7. Does necessity construct a nonconfined system at the exact additive cost?
8. Is the finite gate stated before the RGHW equivalence, with the eventual family
   form only as its consequence?
9. Does the singleton reduction account for the target coordinate?

## Questions for consequences

1. Is the best-target formula proved in both directions by a dual subcode and
   its information set, and does its escape argument handle dependent target
   columns by separating `im G_P` from target-kernel equations?
2. Is the MDS relative-weight formula derived from uniformity with
   `u=min(k,|P|)`, `b=min(k,|J|)`, `ell=u+b-k`, and `M_t=k-u+t`, and is
   `|J| >= k` used only for `ell=u` and equality in the global ceiling?
3. Does equality at rank one force each inequality in the ceiling chain?
4. Are positive outer rate and primal distance separate hypotheses from outer
   dual-distance growth?
5. Does the manuscript prove existence of outer families meeting the three
   asymptotic requirements?
6. Does service-rate transfer use minimal-support domination instead of
   equating the global upward-closed set families literally, and does it state
   the finite gate `d(O^perp)>r+1` or the corresponding eventual qualifier?

## Questions for separations

1. Can the two reliability polynomials be recovered from the displayed table
   by inclusion--exclusion?
2. Does the generic line-and-lift construction prove representability without
   using a searched matrix?
3. Does the direct-sum proof use forced supports and the exact combined radius?
4. Does every nested pair used in the padding construction have an explicit
   inner-code realization?
5. Does the coefficient example distinguish an identical nested helper pair
   from a relabeling of target demands?

## Questions for the projective family

1. Is the associated pair really `0 <= S_m`, as opposed to only having the
   same numerical weights?
2. Does the RGHW count use common zero coordinates of a whole subcode?
3. Does the failed-set event retain at least `t` equations exactly when
   `rank(F) <= m-t`?
4. Does the Möbius inversion include the Bernoulli weights of all failed sets?
5. Are the two endpoint coefficients counted without ordered/unordered or
   projective/vector overcounting?
6. Does the equality case exclude zero columns before solving the projective
   multiplicity system?

## Evidence questions

- The paper-owned Lean companion proves the exact sequence only. Verify that the
  manuscript never promotes this to formal verification of the RGHW or
  confinement theorem.
- The reviewer terminals should report only `Classical.choice`, `Quot.sound`,
  and `propext`.
- The printed reliability table is finite arithmetic, not a search premise.
- No theorem should depend on the stale shared Lean axiom registry or on a
  private repository path.

## Current internal audit findings

The following statement defects were found and repaired before independent
review:

- the nonzero-inner-dual hypothesis was implicit;
- outer-family existence was asserted in the abstract but only conditional in
  the body;
- the `r+1` block bound was not written at the point of use;
- the generic lift and nested-pair realization were compressed past their
  load-bearing steps;
- the projective associated-pair identification was stated without its
  one-line proof;
- several TeX spacing commands had lost their backslashes while still
  compiling; and
- one conference page range in the bibliography was incorrect.

These findings are closed in the current sources. Independent review should
begin from the questions above without being shown any prior qualitative
assessment.
