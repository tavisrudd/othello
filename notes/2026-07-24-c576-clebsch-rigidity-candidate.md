# C576 — focused Clebsch rigidity candidate

**Date:** 2026-07-24

**Lane:** `clebsch`

**Verdict:** complete; referee-style `GO` to the C320 verification and
independent-review pass

## Candidate

Paper I is now a 19-page manuscript titled *Deep-hole rigidity of the
Clebsch hexagon code*:

- source: `papers/clebsch-rigidity/clebsch_rigidity.tex`;
- rendered candidate: `papers/clebsch-rigidity/clebsch_rigidity.pdf`;
- source base:
  `7d258dcd6cda9f54c330d4b705d553a975749014`;
- broad fallback: unchanged in `papers/clebsch-hexagon-code/`.

The candidate preserves the focused base's abstract, introduction, proof
order, small-arc close, conclusion, synthematic--Petersen figure, and
bibliography. It imports only the C575-approved current blocks through the
Clebsch-family formula and then returns to the focused small-arc close.
There is no `H_3` theorem or contextual subsection, and no
factorization-memory, passage, holonomy, or torsor dependency.

The approved backports are present:

1. the explicit parity-check matrix;
2. the complete fifteen-class census;
3. a conceptual rigidity theorem separated from the exhaustive numerical
   gap;
4. distinct statements that `|U(A)| <= 15` characterizes the Clebsch class
   and that its exact value is `12`;
5. local proof-mode declarations;
6. invariant support-bipartition terminology, with only the historical
   checker filename retaining `chirality`;
7. the exact nineteen-row Paper I claim/evidence map;
8. an explicit statement that exhaustive enumeration is load-bearing only
   for the numerical gap and low-degree strengthening.

The monomial characterization now has a stable label. The legacy Singular
wrapper is absent from the Paper I executable table, consistently with
C575's decision that C321 is not triggered.

## Referee-style assessability review

**Recommendation:** `GO`, conditional only on the already scheduled C320
release-surface construction and fresh independent post-fix review.

### Major questions

No mathematical or architectural blocker was found.

- **Can the principal claim be found and stated without later-paper
  vocabulary?** Yes. The title and first abstract sentence state the
  symmetry-free rigidity question; the introduction states the
  characterization and proof mechanism before any census. The formal
  theorem is self-contained and has only four equivalent geometric/group
  clauses.
- **Does the proof expose its causal mechanism?** Yes. The six-arc line
  bound removes degenerate conics, the chord-defect identity converts the
  locus size to Brianchon concurrency, and Dye's equality theorem identifies
  the Clebsch class. The fifteen-class enumeration has been moved out of
  that implication and into the numerical-gap proof.
- **Can a referee identify every exhaustive boundary?** Yes. The low-degree,
  quantitative-gap, and terminal `k=7` exclusions declare their finite
  domains and acceptance tests. The nineteen-row table distinguishes human,
  cited, Lean-checked, and exact-replay evidence.
- **Is the support reconstruction intrinsic?** Yes. The decoder ambiguity
  recovers the Brianchon structure and an unordered `10+10` support
  bipartition; no sign or orientation is claimed.
- **Does Paper I depend on Paper II or III?** No. The optional `H_3`
  paragraph was omitted. The only surviving use of “factorization” is the
  ordinary factorization of a polynomial or a one-factorization of `K_6`.

### Presentation and auditability

The 19-page length is inside the C575 budget. The opening page, the
`q=11` proof page, the verification-table page, and the final bibliography
page were inspected at rendered size. The title hierarchy, theorem
typography, equations, figure, long table, and bibliography are readable
in grayscale. The final build has no unresolved reference, citation,
overfull-box, or underfull-box warning.

The main theorem appears after the object, code, and decoder have been
defined, but its exact claim and three-step proof mechanism are already
visible on page 1. In this 19-page version that delay is assessable rather
than a hierarchy defect: the intervening sections supply the notation and
the model configuration used by the theorem.

### Remaining boundary

C576 freezes the manuscript-facing claim map but does not claim that the
broad fallback's 58-row manifest or aggregate Lean gate certifies this new
source hash. C320 must create the nineteen-row Paper I manifest, statement
identity extraction, aggregate gate, release runner, hashes, and fresh
independent review. This is a release gate, not a defect in the mathematical
candidate.

## Validation

From `papers/`:

```text
~/.claude/bin/run-quiet "make -B clebsch-rigidity"
```

The build completed successfully with 19 A4 pages and no LaTeX warnings.
The final tracked artifacts are:

| artifact | bytes | SHA-256 |
|---|---:|---|
| `clebsch_rigidity.tex` | 68,279 | `b6f776fa2ed084f71a33ff1c5189041bc4c5fd698c6d872407254963836c80ba` |
| `clebsch_rigidity.pdf` | 174,977 | `ec701a29b23d26ffe723e4f821516c4074567e3a69ab7df1bb05a52dc7d6a4b9` |

There are 17 theorem-like environments, matching the focused base, and the
claim/evidence table contains exactly the C575 assignments
`2, 11--26, 29, 58`. C576 made no new computational research claim and did
not substitute an ephemeral rerun for the existing committed evidence
bundles.

## `ej` + `tt` closeout

The cheap auditability upgrade was to print the exact nineteen-row
partition rather than leave the seven grouped verification rows to imply
the partition. This made the split invariant visible in the manuscript and
brought the candidate to the intended page budget.

The demanding-referee pass also exposed two stale inheritances from the
broad source: a decoder cross-reference to the removed reflection section
and a verification-table Singular dependency. Both were removed. It also
forced the qualitative rigidity theorem and exhaustive numerical gap to
become genuinely separate statements and proofs rather than a prose-only
distinction.

## Mystery ledger

- **Settled — Paper I length.** The exact claim map brings the candidate to
  19 pages without optional `H_3` material or compressed proofs.
- **Settled — exhaustive role.** The conceptual conic-containment
  implication uses no enumeration; exhaustive replay is load-bearing only
  for the numerical gap, low-degree strengthening, and the terminal
  small-arc exclusion.
- **Settled — removed-section residue.** No undefined reflection reference
  or Paper II/III theorem dependency remains.
- **Open, C320-owned — release identity.** The new source hash still needs
  its own nineteen-row manifest, statement extraction, aggregate gate, and
  independent post-fix review.

No other genuine mathematical or editorial mystery remains in C576.
