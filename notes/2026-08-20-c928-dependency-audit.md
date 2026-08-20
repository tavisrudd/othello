# C928: theorem dependency audit and paper trust boundary

**Date:** 2026-08-20

**Verdict:** the headline lattice and glue no longer depend on finite
certificates; one optional transfer-surjectivity strengthening, four imported
topological source loci, the intersection-cohomology corollary, and two
inherited prose/Ext debts remain

## Frozen headline

For the blow-up `b:M=Bl_0 Theta -> Theta` of the theta divisor of a smooth
cubic-threefold intermediate Jacobian at its unique triple point, the paper
will prove:

1. the exact sequence
   `0 -> wedge^3 Lambda -> H^3(M,Z) -> H^3(X,Z) -> 0` and torsion-freeness;
2. the structural equality
   `b_*H^3(M,Z)=L_3 wedge^3 Lambda + Theta^[2] wedge Lambda = Sat`;
3. the fibre-product description of `H^3(M,Z)` through the canonical
   mod-two isomorphism `rho`;
4. the corrected degree-five dual statement and free rank-ten escape
   lattice, with exceptional image equal to its doubled sublattice.

The statement that `q_*mu^*` is integrally onto all of `H^3(M,Z)` is a
strengthening, not a dependency of items 1--4.  It will not appear in the
headline unless its kernel generation receives a structural proof.

## Dependency table

| node | inherited status | C928 status | remaining action |
|---|---|---|---|
| local topology of the ordinary triple point | human argument, citation imprecise in the first pass | proof route accepted through the blow-up tubular neighbourhood | cite the precise local theorem or include the short bundle calculation |
| exact sequence for `H^3(M)` | human-proved | retained | source singular weak Lefschetz and the link calculation precisely |
| clean base change through `q` | human-proved, with minor audit repairs | retained | state `psi^{-1}(0)=Delta`, multiplicity one, and Thom normalization explicitly |
| integral cylinder adjoint | correct, attribution locus incomplete | retained as the sole load-bearing classical input | verify Clemens--Griffiths pages and the torsion-free Fano-surface pairing from primary text |
| saturation and Smith factors | HNF/SNF certificate | replaced structurally | complete: pair-occupancy and complete-graph incidence proof |
| closed formula and onto half of `rho` | 940-generator certificate | replaced structurally | complete: Pontryagin endpoint identity plus integral cylinder map |
| `b_*H^3(M)=Sat` | certificate sandwich | replaced structurally | complete: exact sequence plus endpoint transfer lifts |
| full surjectivity of `q_*mu^*` | certificate CHECK 7 | optional and still certificate-backed | prove primitive kernel generation or omit from headline |
| free escape lattice and doubled exceptional image | human duality after the corrected `H^3` theorem | retained | rewrite from the structural headline, with no superseded `(Z/2)^10` claim |
| `IH^*(Theta)` | not written | open | compute from the blow-up/decomposition theorem with coefficient caveats |
| relative-Ext twist invariance | rests on a false rank-three branch | open but not a headline dependency | repair directly or quarantine the entire application |
| span-model non-descent sentence | false | open prose debt, not a theorem dependency | correct the source note and record the strengthened negative conclusion |
| priority boundary | bounded audit says NOT FOUND, with full-text gaps | incomplete for publication | read Beauville 1982, Kramer, Artebani--Kloosterman--Pacini, and predecessors of the general lattice lemma |

## Certificate boundary after the two structural passes

The HNF assertion for

\[
\operatorname{Sat}=L_3\bigwedge^3\Lambda+
\Theta^{[2]}\wedge\Lambda
\]

is obsolete as proof.  The 940-generator comparison for `rho` is likewise
obsolete as proof.  Both remain useful regression artifacts, but the paper
will not ask the reader to trust them.

The old CHECK 7 remains the only theorem-level computation not yet replaced:
it says the transfer image contains the entire kernel as well as the ten
quotient lifts.  The structural paper can omit this strengthening without
weakening the exact lattice, glue, or escape group.

## Logical corrections to preserve

1. The abstract exact sequence splits as a sequence of free abelian groups,
   but the pair `(b_*,e_X^*)` records nontrivial mod-two gluing.  The paper
   must not call the abelian-group extension nonsplit without this qualifier.
2. The escape group is free of rank ten.  Only its quotient by the doubled
   exceptional image is `(Z/2)^10`.
3. The involution `-1` acts trivially on every mod-two shadow in the glue.
   Equivariance therefore supplies no label-selection theorem.
4. The stronger Fano-transfer surjectivity is logically independent of the
   saturation equality and must not be inferred from it.

## Paper architecture forced by the audit

1. State the geometric exact sequence and the corrected lattice theorem.
2. Explain the pair-occupancy decomposition before any matrix language.
3. Prove the complete-graph Smith lemma and identify the divided-power
   generators.
4. Use the Fano endpoint and Pontryagin identity to identify `rho`.
5. Dualize once to obtain the escape lattice.
6. Derive intersection cohomology in a separate section.
7. Put transfer surjectivity, if structurally completed, in a corollary.
8. Keep certificates in a verification appendix as independent regression
   evidence only.

## Acceptance impact

The theorem audit is complete.  Structural proof work is complete for the
two headline certificate dependencies named when C928 was queued.  The next
mathematical gate is the optional transfer kernel; the next mandatory paper
gate is `IH^*(Theta)` and the primary-source closure.
