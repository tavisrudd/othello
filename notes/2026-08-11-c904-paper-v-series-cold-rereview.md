# Paper V cold referee — packet IV/T

PDF SHA-256: `fffe903ea1fdd664173e48030aad5086df09c0e7c7bfcbaa7aee1662f2915543`

Packet: IV/T — series unity, Paper-IV bridge, trust, exposition, and significance

Permitted sources actually read:

- Paper I: `papers/clebsch-rigidity/clebsch_rigidity.pdf`, Section 8,
  Theorem 8.1, “Support cubic and golden continuation,” and Corollary 8.2,
  “Nodes, symmetry, and integral commutant”: complete statements, surrounding
  attribution paragraph, and opening proof map.
- Paper II: `papers/clebsch-factorization/clebsch_factorization.pdf`, Section 3,
  Theorem 3.9, “The 3, 6, 10 quotient ranks”: complete statement, proof mode,
  and opening proof; Section 4, Theorem 4.6, “Balanced sheets and cubic-first
  orientation”: complete statement, proof mode, and proof through the signed
  moment and self-association arguments.
- Paper III: `papers/clebsch-passages/clebsch_passages.pdf`, introduction and
  Proposition 1.2, “Relative marked orientation bridge”: definition of the
  marked bridge datum, complete proposition statement, and immediate scope
  clarification.
- Paper IV: `papers/q13-passant-code/passant_code_q13.pdf`, introduction,
  Theorem 1.1 statement and reading map, and Section 4, Proposition 4.1,
  “The operator field”: complete statement and proof through simplicity,
  Frobenius cycling, and the `F_8` commutant conclusion.

Packet-integrity disclosure: while resolving the series filenames I mistakenly
searched keyword hits in `papers/golden-quantum-statistics/golden_quantum_statistics.pdf`,
which is not Paper IV. I recognized the mismatch before using any statement from
it. No claim or judgment below depends on that file. This disclosure allows the
coordinator to reject and rerun the packet if literal source isolation is
required despite the absence of substantive contamination.

Verdict: MINOR

## Main theorem in my own words

On the fixed metric augmentation carrier of the six Sylow-5 subgroups of
`A_5`, a normalized chordal shadow recovers its singular quartic, the special
twelve-point orbit, and the six-axis quotient. The nontrivial outer permutation
then sends a selected chordal line to the oriented conference line by one
linear difference operator. This produces equivalences among the selected-line
chordal, expanded-carrier, and conference groupoids, while forgetting the line
leaves precisely a residual `C_2` quotient. The marked functors return exactly
the retained source decorations of Papers I–III, not arbitrary source-local
objects.

The recovered six-set also links the rank-five augmentation lattice and the
rank-six `D`-type lattice through their binary heart. Uniformly for symmetric
conference matrices of order `n = 2 (mod 4)`, the root-weight operator minimally
stabilizes `D_n^vee` and has the stated mod-eight coefficient algebra. At order
six the quotient is the unique nonsplit extension of a trivial line by the
natural `F_4 A_5`-module, and conference reversal becomes Frobenius on its
commutant. Paper IV supplies an independent degree-three example: its code has
a multiplicity-free Frobenius orbit of constituents and commutant `F_8`.
Paper V identifies the common descent mechanism, not a geometric map between
the two papers.

## Earliest unsupported implication

- Locator: p. 13, Section 6, proof of Corollary 6.1.
- Printed claim: “Paper I’s *Support cubic and golden continuation* and its
  six-node corollary” recover the Paper-I data, and “Paper III’s *Relative
  marked orientation datum*” supplies the Paper-III source.
- Why it follows / does not follow: The mathematical content matches the
  consulted source statements, and Paper V locally states the retained input
  and returned output. The citation handles are nevertheless not uniformly
  stable exact names. Paper I's second result is actually Corollary 8.2,
  “Nodes, symmetry, and integral commutant”; Paper III's result is Proposition
  1.2, “Relative marked orientation bridge,” not “datum.” Thus the return claim
  is checkable after a local source search, but it does not yet meet this
  packet's requirement that every import be identified by its stable named
  result.
- Smallest counterexample or missing lemma: No mathematical counterexample or
  missing lemma. The missing items are the two exact semantic citation names.
- Downstream scope: Only Corollary 6.1 and the source-return clause of Theorem
  1.2(iii) require citation rereview. The intrinsic classification, Paper-II
  placement, integral theorem, modular theorem, and Paper-IV comparison are
  unaffected.

## Controlling findings

1. [minor/source usage] [p. 13, Corollary 6.1] The Paper-I and Paper-III
   source returns agree with the consulted source statements, but two citation
   handles are descriptive or inaccurate rather than exact stable result
   names. This is a local citation-depth repair with no mathematical change.
2. [correctness/trust] [pp. 5–6, Proposition 2.1] The Paper-II placement is
   human-checkable on the repaired surface. Paper II supplies the named
   ten-dimensional quotient and cubic-first oriented generator; Paper V prints
   the normalized intertwiner, transported coefficient vector, outer
   projectivity, coefficient normalization, and the identity `U(h_M)=8H`.
   The external replay is a leaf, not a premise.
3. [correctness/source usage] [p. 18, Section 10 and Paper IV, Proposition 4.1]
   Paper IV is imported through the stable named result “The operator field.”
   Its proof explicitly establishes the simple binary module, the
   multiplicity-free three-constituent Frobenius orbit, and commutant `F_8`,
   exactly the facts Paper V restates.
4. [correctness/significance] [p. 18, Lemma 10.1 and following paragraphs]
   The Paper-IV comparison is structurally integrated. Paper V proves the
   general Frobenius-orbit commutant lemma locally, applies it separately to
   the `F_4` and `F_8` cases, and states that the groups, modules, bases, and
   geometries differ and that no map between the carriers is asserted. This
   avoids the overbridge failure mode.
5. [exposition/significance] [pp. 1–5 and 18–19] The four proof engines appear
   before the detailed notation, source return is separated from intrinsic
   classification, the uniform `D_n^vee` theorem gives the paper scope beyond
   the six-set example, and the Paper-IV payoff remains subordinate to the
   main correspondence. The paper reads as the series' structural conclusion,
   not as an index to earlier papers.

## Human-proof deletion test

Deleting Section 11's script, JSON, hash, replay, and checker discussion does
not remove a premise. In particular, the Paper-II scalar placement remains
supported by the exact matrices and polynomial identity printed in Proposition
2.1. The selected-line equivalence, groupoid fibres, uniform lattice theorem,
extension calculation, Frobenius identification, and the general commutant
lemma all retain human proofs in Paper V. The source-return assertions use
named mathematical results from Papers I–IV, not companion-repository outputs.

## Attribution and novelty boundary

At the exact depths read, Papers I–III support the retained source objects that
Corollary 6.1 says are returned, and Paper IV supports the independent `F_8`
operator-field example used in Section 10. Paper V accurately limits its new
claim to marked compatibility, normalization, information loss, and the
composition of these ingredients. It does not claim that the Paper-IV carrier
descends from the six-set construction. This scoped source read does not
certify the broader literature priority of any paper.

## Minimal repair, if verdict is not GO

On p. 13, replace “its six-node corollary” by the exact semantic title
“*Nodes, symmetry, and integral commutant*,” and replace “Paper III’s *Relative
marked orientation datum*” by “Paper III’s *Relative marked orientation
bridge*.” No theorem, proof, table entry, or conclusion needs to change.
