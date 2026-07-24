# C320 paper-feedback repair queue

**Date:** 2026-07-24  
**Lane:** `clebsch`  
**Task:** C320  
**Purpose:** Convert the user-supplied referee report and the independent C320 cold read into an
expected-value-ordered repair queue.

The ranking weighs editorial impact, release-blocker removal, effort, and risk. The first batch is
deliberately composed of low-risk changes that remain useful whether the manuscript is ultimately
split or retained as one paper.

## Expected-value order

| Rank | Task | Effort | Reason |
|---:|---|---:|---|
| 1 | Recenter the abstract, introduction, and headline theorem on deep-hole rigidity. | Small | This exposes the strongest result immediately. Reduce the abstract to about 150--200 words and state the non-GRS MDS characterization plainly. |
| 2 | Fix the unambiguous editorial defects. | Small | Correct shifted equation numbering, rewrite the awkward numerical clause of Theorem 5.3, update stale section references, shorten verification identifiers, and repair local terminology before deeper edits create conflicts. |
| 3 | Downgrade geometric-parent recovery to the result actually established. | Small | This removes a correctness and trust blocker immediately. Say “recovery of the displayed matching row” unless an explicit row-to-geometric-parent bridge is supplied. Update theorem statements, conclusion, trust manifest, and statement extraction together. |
| 4 | Rename “statement adequacy” as “statement extraction and identity.” | Small | The current artifact proves textual extraction and identity, not semantic adequacy. Accurate naming closes an independent-review blocker without new mathematics. |
| 5 | Put the parity-check matrix and one complete syndrome example near the start. | Small--medium | Follow one syndrome through projectivization, uncovered-point status, coset distance, and nearest leaders. This gives coding readers a concrete entry point. |
| 6 | Label proof modes clause by clause. | Small--medium | Mark the conceptual, cited, certificate-checked, Lean-checked, and trusted-enumeration clauses of the principal rigidity, gap, and field-classification theorems. |
| 7 | Add a compact, human-readable census specification. | Medium | State the complete search space, normalization coverage, canonical projective-equivalence key, exact arithmetic, independent replay, runtime, software versions, and the resulting 15 classes. |
| 8 | Replace accumulated coined vocabulary with standard language. | Medium | Remove or neutralize terms such as “golden sheets,” “silver roots,” “torsor Rosetta,” “survival and erasure ledger,” and “Matthieu hinge.” Retain at most one central term, defined operationally. Cut the Hofstadter analogy. |
| 9 | Add one explicit factorization/profile reconstruction example. | Medium | Display one `B_3` or `H_3` configuration, its two sheets, the six profile vectors, and the exact row-recovery map. Separate the conceptual implication from the finite hypotheses. |
| 10 | Supply one locatable uniform `A_3/B_3/H_3` theorem-and-proof path. | Medium--large | Include `B_3` explicitly and derive length, distance, conic phase, nonmirror maximum, and torus-orbit claims under one visible set of hypotheses. |
| 11 | Narrow or fully expose the torsor dictionary. | Medium--large | Preferred repair: make the generic two-point transport lemma the theorem, then give a table naming every retained carrier, action, semantic bridge, and evidence source. Delete rows without visible bridges. |
| 12 | Remove four-sheet holonomy from Paper I. | Small if cut; large if retained | It currently has no necessary role in the rigidity or reconstruction argument. Cutting it has higher expected value than adding the missing pencil setup and motivation. Preserve it for companion work. |
| 13 | Move Witt--Hadamard, theta, Fourier, quantum, and Mathieu material out of Paper I. | Medium | This resolves focus, citation, and organization problems together. Retain at most one restrained consequence sentence if it follows directly from the surviving spine. |
| 14 | Make the novelty boundary theorem-specific. | Medium | Add a compact provenance table separating the contributions of Dye, Edge, Sadeh, Storme--Van Maldeghem, the coding literature, and the unpublished companion from each new theorem. Assert priority for a deep-hole-variety characterization of a non-GRS MDS code only if the literature audit supports it. |
| 15 | Split the manuscript into rigidity and reconstruction papers. | Large; high strategic value | Paper I should contain the deep-hole rigidity, quantitative gaps, `q=11` uniqueness, small-arc classification, and relevant verification. Paper II should contain conic-ideal quotients, balanced sheets, cubic orientation, and reconstruction. Do this after the low-risk repairs so both descendants inherit the cleaner source. |
| 16 | Freeze and archive the release candidate. | Medium; final gate | Commit the exact public tree, regenerate hashes and statement extraction, rebuild the PDF, run all 18 checks from clean source, record versions, runtimes, licenses, and identifiers, pin the Lean commit, and archive a permanent release. |
| 17 | Obtain a fresh independent post-fix review. | External gate | The reviewer must begin from the single frozen commit and specifically resample parent recovery, the profile map, the uniform rank-three proof, and every retained torsor bridge. |

## Execution batches

### Batch 1: easy repairs

Execute items 1--8 and cut the unintegrated four-sheet holonomy material in item 12. These changes
are useful under either eventual manuscript architecture and remove several correctness,
presentation, and trust-language objections.

### Batch 2: mathematical exposition

Execute items 9--11. This batch must expose the mechanism rather than merely add artifact
references: a reader should be able to reconstruct the finite objects, maps, hypotheses, and
logical implication from the paper.

### Batch 3: scope decision

Decide items 13 and 15 together. The default recommendation is to make deep-hole rigidity the
entire editorial centre of Paper I, move the reconstruction mechanism to Paper II, and reserve the
Witt--Hadamard, theta, Fourier, quantum, Mathieu, and holonomy material for later or supplementary
work.

### Batch 4: novelty and release

Execute items 14, 16, and 17 only after the mathematical and editorial scope is frozen. The
post-fix reviewer must assess the same committed state certified by the clean release replay.

## Immediate recommendation

The highest-value next sequence is:

1. sharpen the opening;
2. correct the parent-recovery and statement-adequacy overclaims;
3. add the matrix and syndrome example;
4. expose the census protocol;
5. normalize terminology; and
6. cut four-sheet holonomy from Paper I.

The rigidity paper is mathematically strong. Its principal submission risk comes from later
machinery carrying more semantic and editorial weight than the prose and formal terminals
currently support.
