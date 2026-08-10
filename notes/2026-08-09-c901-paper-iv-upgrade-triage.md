# C901 Paper IV upgrade triage

**Date:** 2026-08-09  
**Lane:** `clebsch`  
**Status:** author-approved triage; no upgrade claim promoted to the manuscript

This note records the agreed disposition of possible Paper IV upgrades after
the round-one referee repairs.  It applies the layered-exposition standard in
`papers/style-guide.md` and the pre-draft safeguard model of C894.  Any new
mathematics requires a claim-specific literature audit, a complete human
proof, paper-owned reproducibility evidence where computation is load-bearing,
and isolated re-review before manuscript promotion.

## 1. Cheap, worthwhile, and safe now

These change exposition without adding mathematics.

- Add a two-sentence proof roadmap after the main theorem: minimum-distance
  exclusion, minimum-word classification, pair reconstruction, hidden field,
  and group/plane recovery.
- Add brief language-change signposts at the main interfaces: conic geometry
  to matching model, support hypergraph to association scheme, scheme to
  module, and group to projective plane.
- Tell first-pass readers what they may initially skip: the PSD matrix entries,
  exact intersection tables, anchor enumeration, and verification details,
  while retaining their conclusions.
- Use the fixed-point representative `P=(1:0:2)` as the recurring model example
  and explicitly call back to it.
- Lead each exact table with the conclusion it proves rather than requiring the
  reader to infer its purpose.
- Separate the conceptual statement that every orbit spans from the four
  Gram-count tables that certify it.
- Keep the five-clique classification visibly optional.
- Tighten the proof-and-verification section so each artifact category is
  explained once.
- Audit the recent referee repairs for repeated transport/transitivity
  explanations and remove duplication.
- Give specialized terms a one-clause gloss at first use: passant, elliptic
  relation, punctured pencil conic, operator field, and marked presentation.
- Strengthen section openings so the theorem statements and openings alone
  give the complete causal story.
- Revise the conclusion around the proved reconstruction loop without
  importing the proposed frame correspondence.
- Preserve the current main-theorem and abstract hierarchy; neither needs
  another census of secondary consequences.

## 2. Cheap mathematics that must be vetted first

These are short to state but introduce new claims or interpretations.

- The arithmetic remark explaining why an icosahedral `A_5` marking is absent
  at `q=13`.
- The claim that the octahedral family is therefore the only relevant
  exceptional non-dihedral Platonic marking.
- The weight-spectrum comparison: Paper I reconstructs from deep holes while
  Paper IV reconstructs from minimum words.
- The balanced-threshold calculation
  `|PGL_2(q)/S_4| / |PGL_2(q)/D_{2(q-1)}|=(q-1)/12` and the claim that `q=13`
  is uniquely square/balanced.
- The “three toric Frobenius classes plus one octahedral lift over `A_9`”
  organization.
- The assertion that the duplicated `A_9` Gram is explained by the
  octahedral--toric correspondence.
- Calling that correspondence a Hecke transform, Radon transform, coset
  geometry, or frame transform.
- Canonicity of the selected `r=5` toric family and of the cross-family
  incidence relation.
- Choice independence of the stabilizer-intersection construction.
- Any connection to Papers I--III, even when described only as a shared
  operator-algebra type.
- Any “to our knowledge,” “first,” or “new” wording.

Each candidate requires a C894-style row recording its exact statement, human
proof, closest literature, attribution posture, and remaining gate.

## 3. More costly mathematics worth considering

- Prove the cubic coset correspondence
  `S_4 <- D_8 -> D_24` conceptually from double cosets.
- Give human proofs of `C N_5=N_O` and `C^T N_O=N_5` rather than promoting
  them from exact enumeration alone.
- Prove equivariantly that the correspondence explains
  `N_O^T N_O=N_5^T N_5=A_9`.
- Determine whether the transition is intrinsically recoverable from the
  unlabeled minimum-support hypergraph.
- Promote the frame code with check matrix `[[I,C],[C^T,I]]`, parameters
  `[182,37,28]_2`, and its 78-word minimum-shell recovery of both support
  frames.
- Replace or substantially reduce the `2^37` distance enumeration with a
  structural, representation-theoretic, or local-combinatorial proof.
- Audit whether the 182-vertex cubic graph or its associated code is known.
- Develop an intrinsic trace or cross-ratio description of
  `ker C=[91,14,28]_2`.
- Investigate an all-`q` family theorem explaining why the balanced
  bidirectional transform is special to `q=13`.
- Migrate promoted computations into the paper-owned verification package
  with compact certificates and independent replay.
- Coordinate any enlarged theorem surface with the formal-closure and release
  tasks.
- Run new isolated cold reads by finite-geometry and coding/module specialists.
- Consider a separate companion paper if the frame correspondence develops
  into an independent theorem package.

## 4. Material that should not enter Paper IV

- The full C682 research note.
- The `E_8 -> E_7 -> E_6` exceptional-code ladder.
- Higher-shell `[1092,37,204]_2` constructions.
- Quantum-code, CSS, hypergraph-product, or quantum-walk material.
- Decoder, local-soundness, compression, storage, or benchmarking discussions.
- The parity-complement code and its constrained optimality unless they become
  a separate paper.
- The projective-column completion obstruction.
- Application scores or speculative physical interpretations.
- A claim that Paper IV reconstructs the Clebsch cubic or its oriented torsor.
- A claim that the cubic degree of the frame graph connects it to the Clebsch
  cubic.
- Any identification of the six elliptic relations with the program's six
  axes.
- Any assertion that the `F_8` operator field is a golden or `F_169` structure.
- The dual-number comparison with Papers I and III unless it receives its own
  proof and literature programme.
- A fifth numbered Clebsch-paper implication.
- New theorem clauses supported only by scripts under `notes/`.
- Novelty language before the claim-specific literature audit.
- More audit tables in the abstract or main theorem.
- A large new section that makes the existing 78-coordinate reconstruction
  look like preliminary setup.

## Agreed next move

Perform the safe layered-exposition pass while separately building a
C894-style pre-draft matrix for only the four core frame-correspondence claims.
The matrix does not authorize manuscript promotion; its literature, proof,
reproducibility, and specialist-review gates must pass first.
