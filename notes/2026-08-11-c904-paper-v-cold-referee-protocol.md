# C904 Paper V cold-referee protocol

**Lane:** `clebsch`

**Date:** 2026-08-11

**Status:** sealed protocol; no referee reports launched by this document

**Manuscript:** *The Golden Companion Correspondence*

**Reviewer dossier:**
`notes/2026-08-10-clebsch-paper-v-reviewer-dossier.md` at commit
`7efd5af3`

> This protocol constructs review conditions. It does not claim that any
> named mathematician reviewed the paper. A persona means an isolated
> intellectual brief based on public subject expertise, not imitation of a
> person's voice, biography, or private judgment.

## 1. Frozen surface

- manuscript authority commit: `72497df2`;
- source:
  `papers/clebsch-round-trip/golden_companion_reconstruction.tex`;
- source SHA-256:
  `56dead3ccce1de4f0eccace367f707be76a06c500e8900fae64a8671862caccf`;
- rendered PDF:
  `papers/clebsch-round-trip/golden_companion_reconstruction.pdf`;
- PDF SHA-256:
  `c8427d8178e9a2d8534950cff5cd40422ebcb0ddb578e8181bf65137f781d3ba`;
- visible length: eighteen pages.

Every report must begin by recording the PDF hash. A report on different
bytes is outside this round. The coordinator must recheck both hashes
immediately before distributing the surface.

## 2. Review objective

The round asks whether the human proof, as printed, establishes the intrinsic
classification theorem and its three structural consequences:

1. the selected-line outer-difference equivalence and residual (uq)-deck;
2. uniform integral conference saturation on (D_n^\vee);
3. the (n=6) golden extension/Frobenius theorem and the independent Paper IV
   Frobenius-commutant comparison.

The round is not a verification of scripts, repository engineering, Lean,
task history, or unpublished discovery notes. A proof that becomes convincing
only after consulting those materials fails the human-proof review.

## 3. Isolation rules

Each reader starts in a fresh context and receives only the materials allowed
for that assignment.

Forbidden to every reader unless explicitly included in a packet:

- `AGENTS.md`, handoffs, task cards, closeouts, planning notes, and internal
  theorem audits;
- prior Paper V reviews or remediation discussions;
- reports from another reader in the same round;
- source code, checker output, matrix dumps, or certificate files;
- the full reviewer dossier when only one packet is assigned;
- proposed fixes or the coordinator's expected verdict.

Papers I--IV may be supplied only to the series reader. Other readers judge
the imports from the restatements and citations in Paper V, consulting a
named source only when their packet authorizes it.

No report may be revised after learning another report's findings. All reports
freeze before synthesis.

## 4. Two-stage design

### Stage A — genuinely blind holistic read

One reader receives only the frozen PDF and the neutral prompt in Section 7.
The reader does not receive the dossier, likely-referee names, source list, or
known failure modes.

The purpose is to test:

- whether the theorem can be stated correctly after one read;
- where the first loss of orientation occurs;
- whether the four proof engines are visible;
- whether any claim appears to depend on computation;
- whether the paper reads as a theorem rather than a series index.

The Stage-A report freezes before any Stage-B packet is distributed to that
reader. Prefer a different reader for Stage B.

### Stage B — isolated specialist reads

Specialists receive the frozen PDF plus exactly the dossier sections listed
below. They may consult only the sources named inside those sections and must
record the exact source depth used.

| assignment | intellectual brief | dossier sections | manuscript focus |
|---|---|---|---|
| O | outer (S_6), invariant theory, and marking groupoids | 3 (Snowden only), 6, 12--13 | Sections 1, 4--6 |
| G | singular cubic geometry | 3 (Marquand only), 5, 12--13 | Sections 2--3, source return |
| C/L | conference matrices and integral lattices | 3 (van Dam/Haemers only), 7--8, 12--13 | Sections 3--4, 7--9 |
| R | modular representations and extensions | 3 (Bleher/Sin only), 9, 12--13 | Section 9 |
| IV/T | series unity and editorial significance | 3 (series/generalist roles only), 10--13 | introduction, Sections 6, 10--12 |

The labels O, G, C/L, R, and IV/T identify expertise, not actual people.

## 5. Reader workflow

Every reader follows this order.

1. Verify and record the PDF hash.
2. Read the assigned manuscript surface without opening a source.
3. Write a provisional theorem statement in the reader's own words.
4. Record the first unsupported implication and all findings that occur
   earlier than it.
5. Only then open the permitted packet and named sources.
6. Distinguish among:
   - a false or unproved mathematical implication;
   - a convention or normalization ambiguity;
   - a priority/source-usage defect;
   - an exposition or significance defect.
7. Test the proof after deleting every sentence that mentions computation or
   verification.
8. Assign a categorical verdict using Section 6.
9. Return at most five controlling findings, ordered causally rather than by
   ease of repair.

A reader should not attempt to improve the theorem before deciding whether
the printed theorem is proved.

## 6. Verdict definitions

### GO

The assigned claims follow from the printed human proof. Remaining comments
are optional improvements or literal typographical corrections.

### MINOR

The theorem survives unchanged, but a local repair is required: an omitted
standard argument, a missing convention, a citation-depth correction, a
small dependency-table mismatch, or an exposition defect with no downstream
mathematical change.

### MAJOR

At least one of the following holds:

- a theorem, equivalence, fibre, or uniqueness claim is false as stated;
- a load-bearing implication is missing and is not a standard local lemma;
- scalar, marking, base-change, or projectivization data are lost;
- a finite computation substitutes for the claimed structural proof;
- the novelty boundary materially misattributes known work;
- the paper's main theorem needs a narrower hypothesis or conclusion.

Uncertainty is not automatically MAJOR. The report must identify the exact
unresolved implication and explain why the printed proof does not close it.

## 7. Neutral Stage-A prompt

Copy the following prompt verbatim, followed only by the frozen PDF path and
hash.

> Read this paper as an independent journal referee. You have no access to
> author notes, computational certificates, prior reviews, or intended
> repairs. First state the main theorem in your own words. Then identify the
> earliest implication that is false, unsupported, ambiguous, or dependent
> on material outside the paper. Continue only far enough to determine its
> downstream scope. Separate mathematical correctness, attribution,
> exposition, and significance. Return GO, MINOR, or MAJOR and no more than
> five controlling findings, each with a page, section, theorem, or displayed
> formula locator. Do not assign a numerical score and do not assume a claim
> is correct because a computation is mentioned.

## 8. Specialist Stage-B prompt

Copy the following prompt verbatim, adding the packet label and permitted
sources.

> Act as an independent specialist referee for packet [LABEL]. Read the
> frozen manuscript before the packet. Judge only claims within the packet's
> scope, but trace every finding through the main theorem. Treat the packet as
> a list of questions, not as evidence that the expected answer is true.
> Consult only the named sources and record exactly which sections or theorem
> statements you read. Find the earliest unsupported implication; give the
> smallest counterexample, normalization conflict, or missing lemma when
> possible. Test whether the proof remains complete after deleting scripts
> and computational outputs. Return GO, MINOR, or MAJOR with at most five
> controlling findings and precise manuscript locators. Do not read another
> referee's report and do not propose a repair until after stating the defect.

## 9. Mandatory report schema

Each report uses this form.

```markdown
# Paper V cold referee — packet [LABEL]

PDF SHA-256: ...
Packet: ...
Permitted sources actually read: ...
Verdict: GO | MINOR | MAJOR

## Main theorem in my own words

...

## Earliest unsupported implication

- Locator:
- Printed claim:
- Why it follows / does not follow:
- Smallest counterexample or missing lemma:
- Downstream scope:

## Controlling findings

1. [severity] [locator] ...
2. ...

## Human-proof deletion test

What remains valid after all computational references are ignored?

## Attribution and novelty boundary

...

## Minimal repair, if verdict is not GO

State only after the defect has been diagnosed.
```

The report must not include a numerical grade, venue prediction, simulated
quotation, or claim that the named persona personally endorsed the result.

## 10. Source-use rules

The literature audit follows `notes/literature-audit-conventions.md`.

- A source is evidence only at the exact depth read.
- Metadata or abstract inspection cannot certify a theorem-level claim.
- Record full-text, partial-text, abstract-only, or metadata-only depth.
- Do not infer novelty from failure to find a predecessor.
- Do not use citation counts as a correctness proxy.
- Quote minimally; compare mathematical statements in the reader's own words.
- Closest-source authorship is a reason for a priority check, not proof that
  Paper V's bridge is preempted.

## 11. Freeze and synthesis

All Stage-B reports are committed in one freeze only after every assigned
reader has returned. Before that freeze:

- no reader sees another report;
- no finding is repaired;
- no report is harmonized to a majority verdict;
- the manuscript remains unchanged.

The synthesis begins with the earliest unsupported implications, not with a
vote count. It records:

1. exact agreement or disagreement among readers;
2. whether two reports identify the same causal defect under different
   terminology;
3. the narrowest theorem surface affected;
4. the minimal repair plan;
5. every packet requiring re-review.

A majority GO cannot override one precise MAJOR counterexample.

## 12. Remediation rules

Repairs occur only after synthesis authorization.

- Fix the earliest causal defect, not its downstream symptoms.
- Do not weaken a theorem silently; record changed hypotheses or conclusions.
- Preserve human proofs. A new certificate may check a leaf but cannot replace
  the missing argument.
- Rebuild the PDF and record new source/PDF hashes after any manuscript edit.
- Create a new review surface; never overwrite the round's frozen manifest.
- Give re-reviewers the repaired full causal chain, not merely a diff hunk.

### Causal re-review map

| repaired area | mandatory re-review packets |
|---|---|
| metric/scalar rigidification | O, G, IV/T |
| singular quartic or axis recovery | G, O, C/L |
| conference orientation or selected-line bridge | C/L, O |
| groupoid fibres or source return | O, IV/T |
| (D_n^\vee) saturation or mod-eight split | C/L, R |
| (n=6) binary heart or extension | R, C/L, IV/T |
| golden/outer Frobenius identification | R, O, IV/T |
| Paper IV comparison | IV/T only, unless a new functor is claimed |
| novelty or source-depth wording | affected specialist plus IV/T |

## 13. Stop conditions

Stop the round and return it to the coordinator if:

- the frozen hashes do not match;
- the packet requires a forbidden internal note to make sense;
- a permitted source is unavailable at the claimed read depth;
- the manuscript changes while reports are in flight;
- a reader learns another current report before freezing their own;
- a claimed human proof is found only in a script or unpublished certificate.

## 14. Completion criterion

The cold-referee round closes only when:

1. Stage A and all assigned Stage-B reports match the frozen hash;
2. every MAJOR and MINOR has a causal disposition in the synthesis;
3. all authorized repairs have a new frozen surface;
4. every packet in the causal re-review map has returned on that surface;
5. the final specialist verdicts are GO and the blind holistic read is at most
   MINOR on exposition;
6. the trust reader confirms that deleting all computational artifacts leaves
   the printed proofs complete.

The protocol does not require unanimity on venue, taste, or presentation. It
requires unanimity that the theorem actually printed is proved by the paper
actually frozen.
