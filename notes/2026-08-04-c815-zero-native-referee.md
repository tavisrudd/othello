# Referee report: elimination of compiled evaluation from the three Paper III Lean gates (commit b6fc9694)

**Lane:** `clebsch`
**Date:** 2026-08-04
**Task:** C815

Cold adversarial review. The specification is the commit message of b6fc9694, which claims
that every one of the twenty-seven compiled-evaluation (`native_decide`) carriers in the three
Paper III gates is gone. Everything below was recomputed from the files on disk with
independently written scripts, or reproduced by driving the shipped tools; nothing was taken
from the commit message, the notes, or the two earlier referee reports. Read-only: no
repository file other than this report was created or modified, nothing was staged or
committed, and no Lean build was run. Tamper experiments ran on a copy outside the repository.

The two earlier reports are `notes/2026-08-04-c815-repin-and-repair-referee.md` (commit
092b94c5's predecessor) and `notes/2026-08-04-c815-repair-closure-referee.md` (commit
092b94c5). Between the second of those and the commit under review there is one intervening
commit, c990213b, "Paper III: close the second referee pass on the gate audits". Findings
attributed below to c990213b rather than b6fc9694 are marked as such.

---

## 1. Is the zero-native claim true?

**Yes.** Every part of it that I could measure, I measured, and it holds.

I parsed the three committed axiom reports with my own parser, which accepts exactly two line
forms — `'<decl>' depends on axioms: [<list>]` and `'<decl>' does not depend on any axioms` —
and fails loudly on anything else. All ninety-seven lines parsed; none was malformed, and no
declaration appeared twice in any report.

| gate | audited terminals | terminals with a non-standard axiom | distinct non-standard constants | terminals on no axiom at all |
|---|---|---|---|---|
| `Gates.ClebschPassages`       | 50 | 0 | 0 | 4 |
| `Gates.ClebschGoldenReturn`   | 28 | 0 | 0 | 0 |
| `Gates.FourShadowRecognition` | 19 | 0 | 0 | 0 |

Treating `propext`, `Classical.choice` and `Quot.sound` as the standard base, the set of
non-standard constants reached by any audited terminal is **empty** in all three gates. The
previous referee measured 9 + 8 + 0 = 17 carriers over 36 distinct native constants; all of
them are gone. The counts 50 / 28 / 19 in the commit message are correct.

The four zero-axiom passages terminals are real and are the ones the commit implies:

- `RelativeConicArcs.AlignedTwoGraph.aligned_complement_iff`
- `RelativeConicArcs.AlignedTwoGraph.triangle_eq_rooted_xor`
- `RelativeConicArcs.AlignedTwoGraph.alignedAnchor_of_ramseyTriple`
- `RelativeConicArcs.AlignedTwoGraph.sixPointAnchor_testCount`

**`native_decide` occurs nowhere in any pinned closure source.** I read every source listed in
the three `*_source_closure.json` inventories (15, 17 and 7 files) directly from `lean/` and
counted the literal string: zero occurrences in all thirty-nine file-gate pairs. Every recorded
`sha256` and `bytes` field matches the file on disk.

**The reports match the tracked gate stdout logs.** Re-running the shipped
`extract_axiom_report.py` against each `verification/evidence/gate_stdout/<gate>.stdout.txt`
reproduces the committed `*_axioms.txt` **byte for byte**, exit 0, for all three gates. Each
`axiom_report_provenance.gate_stdout_sha256` matches the log on disk. The passages and
golden-return logs carry build run id `run-20260804-060023-d43735f6`; four-shadow, which this
commit did not touch, carries `run-20260804-050416-1085523f`.

**The manifests' audited declaration sets match the reports exactly** — as sets, 50 / 28 / 19,
with no extra and no missing name in any gate. Each `axiom_report_sha256` and
`source_closure_sha256` matches its file.

(continued)
