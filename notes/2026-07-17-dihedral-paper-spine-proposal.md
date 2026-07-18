# Proposal: rebuild the dihedral paper around one reduction and three applications

**Date:** 2026-07-17  
**Lane:** `dihedral`  
**Purpose:** editorial decision memo for Fable before C264 rewrites the manuscript.

## Executive recommendation

Do not integrate C284 by appending another catalogue section to the current manuscript. Rebuild
the paper around one universal theorem—the fixed-point-deleted Schreier reduction—and three
applications of increasing complexity:

1. two-point dihedral configurations;
2. three-point dihedral configurations; and
3. the finite `S4/A5` polyhedral boundary.

The current mathematics supports this stronger architecture. The present manuscript instead
reflects discovery order: the richer three-point theory occupies Sections 4–13, the simpler and
more general two-point family arrives in Section 14, and polyhedral information is confined to an
appendix. Appending C284 to that order would make a coherent classification read like accumulated
results.

The proposed rewrite should be structural, not cosmetic. C289 supplies the conceptual explanation
of the new `A5 (3,5,5; rho=3/5)` split, C290 consolidates the arithmetic consequences into a master
theorem, and C264 then performs the LaTeX/review cycle against the new spine. C281 and C288 should
run as validation appendices rather than determine the narrative.

## Proposed central claim

A safe paper-level theorem should have approximately this scope:

> Let `S` be a legal tame off-conic configuration whose induced involution group belongs to the
> classified dihedral or polyhedral families. The conic-only continuation is Node Kayles on a
> fixed-point-deleted Schreier graph. Every transitive component belongs to an explicit catalogue,
> and the exact Grundy value is an explicit arithmetic function of the field and configuration
> class.

This is stronger and clearer than a paper advertised merely as a dihedral calculation, but safer
than “all finite subgroups of `PGL2(q)`.” The latter can be read as including full and subfield
`PSL2/PGL2` groups and other Dickson-list cases outside the proved theorem. The abstract, title,
and introduction must name the tame, conic-only, and classified-family boundaries.

## Natural audience and exposition level

The primary audience is **algebraic combinatorics at the intersection of finite group actions,
Schreier graphs, and impartial combinatorial games**. The ideal reader may enter from any one of
three adjacent specialties:

- combinatorial game theory, especially structured Node-Kayles positions;
- finite geometry or finite permutation groups, especially conics and `PGL2(q)` actions; or
- algebraic graph theory, especially Cayley/Schreier graphs and orbit decompositions.

Pitch the paper primarily as algebraic/structural combinatorics. The conic geometry supplies the
positions, but the reusable result is the orbit-template reduction and the payoff is an exact
Grundy classification. Conversely, do not assume a mainstream CGT reader already knows tame
point-stabilizer structure or split/nonsplit tori, and do not assume a finite geometer already knows
Sprague-Grundy decomposition or Dawson’s chess. Each side needs one compact bridge, not a survey.

This audience choice favors the proposed spine: teach the universal graph/game reduction first,
introduce group-action structure only when it controls templates, and move computational evidence
out of the narrative. It also favors “dihedral and polyhedral” in the title over an internal Nofil
label or an overbroad Dickson-list claim.

## Proposed section spine

### 1. Introduction and main theorem

Lead with the phenomenon, not the machinery: a geometric continuation game collapses to a small
catalogue of graph games, and orbit multiplicities matter only modulo two. State the unified
classification theorem and its three applications. State immediately that off-conic continuation,
wild characteristic, and growing full/subfield linear groups are outside the result.

### 2. From conic saturation to Node Kayles

Keep the present coordinate model, pair-product fixed-point lemma, and exact residual reduction.
This is already concise and persuasive. End by defining `R_T(Omega)` in a way that flows directly
into the abstract group-action theorem.

### 3. Orbit templates and mod-two cancellation

Present the fixed-point-deleted Schreier construction and orbit-template theorem. Fold the current
Burnside-group reformulation into this section as a corollary or conceptual remark: it explains why
generic free orbits contribute only a parity bit, but it is not a separate computational chapter.

Conclude with a short “classification problem” paragraph: for each possible `(G,T)`, determine
the projective-line stabilizers, identify `R(G,K,T)`, and evaluate its nimber.

### 4. Two selected points: every dihedral order

Move the current Section 14 here. It is the cleanest first application:

- `G=D_{2m}` for every `m>=3`;
- templates are `C_{2m}`, `P_m`, and the empty graph;
- free cycles are neutral;
- reflection parity gives the whole value; and
- Dawson’s chess explains the larger nimbers and period 34.

This section teaches the method with elementary graphs before the reader encounters the richer
three-generator ladder taxonomy. Its P/N law and realization theorem should be stated here, while
the cross-family arithmetic synthesis is deferred to Section 7.

### 5. Three selected points: the dihedral ladder family

Combine the present Klein-four boundary and `D_{4n}` development:

- legality forces the central involution plus two reflections;
- the generating triples have the odd/even `d` classification;
- stabilizers are `1`, the rotation torus, and two reflection classes;
- templates are `K4`, Möbius ladders, prisms, ordinary ladders, and the empty graph; and
- Brown et al.’s values produce the orbit formula.

Retain the double-cover-of-a-tree lemma: it is the clean structural proof behind the ladder
recognition. Compress repeated split/nonsplit arithmetic here and move the complete congruence
tables to Section 7.

### 6. Polyhedral triples: the finite boundary

Promote the C284 material from an appendix to the main text.

- Explain first why `A4` cannot be generated by its involutions beyond `V4`.
- Classify the four `S4` and six refined `A5` generating-triple classes.
- Use `sigma(T)` for pair-product orders and `rho(T)` for the common three-generator-product
  order.
- Make the split of `A5 (3,5,5)` into `rho=3` and `rho=5` the conceptual centre of the section,
  not a footnote to a computation.
- State the cyclic stabilizer/orbit classification and the nonregular template table.
- Put full edge lists, replay counts, and machine certificates in the evidence appendix; the body
  should show only the table columns needed to understand the theorem.

C289 should determine how strongly the paper can explain `rho`: Nielsen class, orientation,
icosahedral chirality, or a more elementary group-theoretic invariant. The prose must not attach a
geometric interpretation unless it is proved.

### 7. Arithmetic synthesis

C290 should replace the presently scattered family-by-family arithmetic with one master section.
For each family, state:

- exceptional-orbit indicators;
- the regular-orbit count and its parity;
- the closed Grundy formula;
- explicit P/N congruences and a period;
- prime-field density when justified; and
- the exact tame/existence hypotheses.

The worked `D12` example may remain as the first illustration, but a compact contrasting `A5`
example would better justify the expanded scope. Avoid repeating the same split/nonsplit derivation
in multiple sections.

### 8. Realization, boundaries, and outlook

Collect the converse realization theorems. Then distinguish three boundaries sharply:

1. **completed here:** the stated tame dihedral and polyhedral configuration families;
2. **post-release C292:** wild polyhedral characteristic; and
3. **C84 `[cap]`:** the growing full/subfield `PSL2/PGL2` escape residual.

The Discussion should explain what the catalogue teaches—geometry chooses orbit multiplicities,
while the abstract pair `(G,T)` chooses a finite game table—rather than recap every theorem.

## Current-to-proposed migration map

| Current material | Proposed home | Editorial action |
|---|---|---|
| Abstract + §1 | §1 | Rewrite around the unified theorem and three applications. |
| §2 | §2 | Preserve with minor compression. |
| §3 + §11 | §3 | Fold Burnside cancellation into the orbit-template principle. |
| §4.3 + §14 | §4 | Move the two-point family before the triple family. |
| §4.1–4.2 + §§5–8 | §5 | Preserve the structural proofs; consolidate taxonomy and table. |
| §§9–10, §12, arithmetic parts of §14 | §7 | Merge into one arithmetic synthesis. |
| §13 + converse part of §14 | §8 | Merge realization statements. |
| C284 + current Appendix A | §6 + evidence appendix | Promote theorem/table content; keep certificates out of the narrative. |
| §15 | §8 | Rewrite after the new boundaries and title are fixed. |

## Title directions

Preferred safe options:

1. **Node Kayles on Conic Schreier Graphs: Dihedral and Polyhedral Templates**
2. **Fixed-Point-Deleted Schreier Graphs from Dihedral and Polyhedral Subgroups of `PGL2(q)`**
3. **Tame Conic Continuations for Dihedral and Polyhedral Subgroups of `PGL2(q)`**

Avoid an unqualified “finite subgroups of `PGL2(q)`” title unless the final theorem and Dickson-list
audit justify every natural reading of that phrase. “Dihedral and polyhedral” advertises exactly
the proved content and still reflects the expansion beyond the original manuscript.

## Recommended execution order

1. Review and atomically commit C284.
2. Run C281 and C288 as independent validation/evidence work; do not wait for their prose to set
   the paper architecture.
3. Complete C289, because the structural meaning of the `A5` split determines the strength of §6.
4. Complete C290, producing the unified arithmetic theorem for §7.
5. Execute C264 as a structural rewrite followed by LaTeX, adversarial review, and cold-prose
   passes—not as a format conversion of the current section order.
6. Treat C291 as the first post-C264 mathematical upgrade unless short direct strategies emerge
   early enough to insert without delaying the rewrite. Leave C292/C293 post-release.

## What should remain out of the main narrative

- exhaustive per-`q` census tables;
- raw template edge lists and solver-state counts;
- Lean adequacy details beyond a precise trust-boundary statement;
- the OEIS byproduct package;
- correction history and computational transcripts; and
- speculative interpretations of `rho` not established by C289.

These belong in appendices, companion reports, or the evidence bundle. The main paper should make
the classification feel inevitable rather than make the reader relive its discovery.

## Questions for Fable

1. Is the universal-reduction/three-applications spine stronger than retaining a predominantly
   dihedral paper with a polyhedral appendix?
2. Should the two-point family precede the three-point family, despite being discovered later?
3. Does the Burnside formulation deserve a named subsection in §3, or only a corollary and remark?
4. How much of the C284 table belongs in the body before the paper starts to feel computational?
5. Is the `A5 (3,5,5;rho=3/5)` split strong enough to lead the polyhedral section if C289 supplies
   only an elementary finite-group proof rather than a geometric interpretation?
6. Should the paper include one polyhedral worked example alongside `D12`, or replace `D12` with a
   comparative example?
7. Which proposed title best balances reach, precision, and discoverability?
8. Are C289 and C290 genuine pre-submission gates? The recommendation here is yes. Is C291 safely
   post-C264? The recommendation here is also yes unless quick human proofs appear.
9. Does any current theorem become less visible or less convincing under this reordering?
10. What is the strongest defensible one-sentence main theorem after C284, without implying coverage
    of wild or full/subfield linear-group cases?

## Decision requested

Fable should return one of:

- **Adopt:** use this spine as C264’s architecture;
- **Adopt with changes:** list concrete section-order or scope changes; or
- **Retain current spine:** explain which mathematical dependency or audience expectation outweighs
  the narrative gains above.

The response should also choose a title direction and rule on whether C289/C290 are pre-submission
gates.

---

## Fable decision (2026-07-17)

**Adopt with changes.** The universal-reduction/three-applications spine is stronger than the
current discovery-order manuscript plus a polyhedral appendix, and the two-point family belongs
first: it teaches the whole method on cycles, paths, and Dawson's chess before the reader meets the
ladder taxonomy. Discovery order is not a reader-facing constraint. Required changes:

1. **The density theorem must not be flattened.** The migration map sends §12 into the §7
   arithmetic synthesis as one bullet among six. Theorem 12.1 (density ½, kernel-certified behind
   the single `primes_equidistribute` axiom) is one of the paper's two Lean-anchored headline
   results; §7 must state it as a named theorem with the C278 single-axiom boundary sentence
   attached, not as a row in a synthesis list.
2. **§5 compression is arithmetic-only.** The double-cover-of-a-tree lemma and the structural
   ladder-recognition proofs are preserved intact; only the repeated split/nonsplit derivations
   move to §7. If a §§4–13 proof would be cut rather than moved, it stays.
3. **§8's boundary taxonomy must absorb C283.** The wild case is no longer merely "outside the
   result": `p | 2m` forces `D_{2p}` with a unipotent rotor, residual `P_p`, value `A002187(p)`,
   and it breaks the tame odd-order P law. State it as the paper's sharpest boundary marker.
   Whether to promote the short wild-pair lemma from remark to theorem (C283 judged it a short
   lemma) is a user scope call; the default is the remark as landed.
4. **§6 leads with completeness, presents the split as the load-bearing refinement.** The `A₅
   (3,5,5; ρ=3/5)` split leads the section even if C289 yields only an elementary finite-group
   proof — an exact invariant refinement invisible to the classical signature is the finding — but
   the prose claims no geometric meaning C289 does not prove.

Answers to the numbered questions: (1) yes, adopt the spine; (2) yes, two-point first; (3)
corollary + remark only, but the corollary keeps its Lean anchor citation; (4) the ten-row
`(σ, ρ, class size, t₁…t₅)` table belongs in the body, edge lists and replay counts in the
evidence appendix; (5) yes, with the calibration in change 4; (6) keep `D₁₂` and add one
contrasting `A₅` example rather than replacing; (7) title direction 1, "Node Kayles on Conic
Schreier Graphs: Dihedral and Polyhedral Templates" — it leads with the searchable terms for the
stated audience and advertises exactly the proved content (final wording is a user call at C264);
(8) C290 is a hard pre-submission gate (§7 does not exist without it) and C289 is a gate at
elementary-proof scope only — a proved `Aut`-orbit/Nielsen-class account of `ρ`, with any
geometric interpretation optional; C291 is post-C264; (9) the two visibility risks are the density
theorem (change 1) and the ladder structural proofs (change 2), both addressed; (10) the proposed
central claim as worded, with "classified dihedral or polyhedral families" kept and the three
exclusions (off-conic, wild, growing full/subfield groups) named in the same breath.

Execution consequence: C284's manuscript integration transfers to C264 §6 under this spine — no
appended section to the current manuscript. The C284 queue row closes on its committed, replayed
evidence bundle with integration explicitly owed by C264.
