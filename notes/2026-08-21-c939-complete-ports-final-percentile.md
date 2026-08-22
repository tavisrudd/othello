# C939 final percentile rereview

**Date:** 2026-08-21
**Frozen commit:** `8bbb0f787`
**Tracked PDF:** `papers/complete-repair-ports/complete_repair_ports.pdf`
**PDF SHA-256:** `211e6cdf896270aa7758fc79476ae2fe75f08db483cef8d2fadf732910d1f09a`
**Artifact check:** The working 23-page PDF is byte-identical to the PDF tracked at the frozen commit.
**Review basis:** Complete read of the frozen PDF. I did not inspect paper sources, the handoff, supplementary file contents, or other reviews beyond the preceding C939 percentile baseline.

## Final verdict

The frozen paper is now a credible **96th-percentile annual specialty paper** in coding theory/local repair using finite geometry or matroids, with plausible range **93rd–98th**. On transferable dimensions against annual mathematics papers generally, my estimate is the **90th percentile**, range **84th–94th**.

The two final changes remove the remaining concrete deductions from the previous rereview:

1. The conclusion now culminates in the structural [10,4,6] matched-availability theorem at density \(1/10\), accurately naming the matched pointed-perspective, repair-count, locality, matching, transversal, minimum-blocker, and degree statistics. The smaller field-seven pair is correctly demoted to an explicit precursor.

2. Appendix A.2 now supplies an independent, exact \(\mathbf F_{29}\) cross-check of the structural existence proof. The supplementary certificate checks rank, every four-column dependence by two routes, circuit-hyperplane lists, code parameters and dual distance, pointed rank-triple histograms, all matched clutter statistics, and both reliability polynomials. The paper explicitly preserves the logical boundary: the generic line-and-lift argument proves the theorem, while the concrete instance checks it.

The result is unusually complete. The paper introduces a coherent three-layer local object; proves an exact weighted-functional transfer theorem with the correct persistent obstruction; turns it into an iff positive-density realization theorem; shows that pointed-Tutte data and several standard local/blocker statistics still fail to determine bounded reliability; and supports the theorem chain with structural proofs, explicit examples, formal declarations, and replayable certificates. I found no clear mathematical error in the frozen PDF.

The remaining uncertainty is external rather than internal: I did not conduct a fresh literature audit or replay the supplementary bundle. That limits confidence in priority and artifact execution, not in the rendered arguments.

## Final percentile scorecard

“A” compares annual specialty papers in coding theory/local repair using finite geometry or matroids. “B” compares annual mathematics papers generally on transferable dimensions. Deltas are from the matched-availability rereview at commit `f50c583cc`.

| Dimension | A: range / best | Delta | Confidence | B: range / best | Delta | Confidence |
|---|---:|---:|---|---:|---:|---|
| Correctness | 92–99 / **96** | +1 | high | 90–98 / **94** | +1 | medium-high |
| Novelty | 84–97 / **93** | 0 | medium | 74–91 / **84** | 0 | medium-low |
| Conceptual originality | 92–99 / **97** | 0 | high | 86–96 / **92** | 0 | medium-high |
| Technical depth | 89–97 / **94** | 0 | high | 80–92 / **87** | 0 | high |
| Proof completeness | 91–98 / **96** | +2 | high | 88–96 / **93** | +2 | high |
| Specialty significance / broader significance | 89–98 / **95** | 0 | medium | 70–89 / **81** | 0 | medium-low |
| Breadth | 93–99 / **96** | 0 | high | 87–96 / **92** | 0 | high |
| Exposition | 89–97 / **94** | +3 | high | 83–93 / **89** | +4 | high |
| Examples and formal support | 97–99 / **99** | +1 | high | 97–99 / **99** | +1 | high |
| Reproducibility | 91–98 / **96** | +6 | medium-high | 94–99 / **98** | +3 | medium-high |
| Overall strength | 93–98 / **96** | +1 | high | 84–94 / **90** | +2 | medium-high |

Novelty, conceptual originality, and theorem depth do not move because the frozen changes validate and present the existing strengthened theorem rather than extend it. Exposition and reproducibility rise materially. Overall specialty strength rises one point because the paper was already near the top of the scale after the matched-availability result.

## Remaining high-EV upgrades only

At this stage there is no high-EV internal repair left in the frozen manuscript. The following are the only upgrades likely to matter enough to justify reopening or extending the project. Expected lifts refer to the 96th-percentile specialty estimate and are non-additive.

| Priority | High-EV upgrade | Expected lift | Effort | Risk |
|---:|---|---:|---|---|
| 1 | **Complete and publish a claim-by-claim novelty audit.** Compare coefficient ports and bounded support filtrations directly with recovery structures/repair hypergraphs, access structures, local decoding, matroid ports/reliability, and propagation constructions. Mark every headline statement as classical input, new theorem, or new consequence, with theorem-level citations. | chiefly narrows the 84–97 novelty range; up to +1 overall | medium | low; a close predecessor could narrow wording but would improve reliability |
| 2 | **Close the exact transfer picture across all three functional strata.** In a follow-up or a compact addition, give sharp examples where the zero, singleton, and multisupport sectors separately attain the confinement threshold, and characterize useful hypotheses under which functional support distance equals weighted realization cost. | +1 to +2 if it yields a clean characterization | medium-high | medium-high; extra cases could dilute the present paper’s strong central line |
| 3 | **Deposit the complete artifact as an immutable archival release.** Attach a DOI or equivalent long-lived identifier to the exact source, Lean closure, scripts, JSON certificates, environment locks, expected outputs, and resource envelopes. | up to +0.5 overall; increases reproducibility confidence | low-medium | low |

Priority 1 is the highest expected-value action before submission because novelty is now the widest and least independently checked score dimension. Priority 2 belongs in the current paper only if it produces a short characterization theorem; otherwise it is better as follow-up work. Priority 3 is operationally cheap and should accompany public release.

**Vibe check:** finished, coherent, and unusually audit-ready—a top-5% specialty paper with no remaining manuscript-level weakness large enough to justify another revision cycle.
