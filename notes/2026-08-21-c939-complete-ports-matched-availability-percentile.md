# C939 matched-availability percentile assessment

**Date:** 2026-08-21
**Immutable commit:** `f50c583cc`
**Tracked PDF:** `papers/complete-repair-ports/complete_repair_ports.pdf`
**PDF SHA-256:** `2cbb5bd84f65c00d93a4b9e19a711f452468da8d849c918b7f571e03e9203a49`
**Artifact check:** The working 23-page PDF is byte-identical to the PDF tracked at the stated commit.
**Method:** Read the complete tracked PDF. I did not inspect manuscript sources, supplementary artifacts, prior reviews other than the preceding C939 score baseline, or the commit diff.

## Verdict

The matched-availability theorem **fully closes prior Priority 1 and goes beyond it**. Theorem 6.5 now matches not only the pointed-perspective polynomial, locality, minimum-repair count, and availability, but also transversal number, number of minimum blockers, and the helper-degree multiset. The two radius-three reliability polynomials still differ, and exact transfer places the distinction on density-\(1/10\) target classes in asymptotically good families with matched global parameter formulas and distance bounds.

This is a genuine strengthening of the mathematics. The earlier field-seven pair allowed the reliability difference to be attributed to the visible availability mismatch. The new pair removes that explanation and several natural refinements of it. Reliability is now shown to detect higher-order intersection data after the usual coarse local, blocker, degree, and pointed-Tutte statistics have all been equalized.

The proof is structurally satisfying. It first gives two explicit five-edge linear clutters, verifies their matched invariants and distinct union-size distributions, and then represents both via quotient-plane line arrangements and a generic lift. Avoiding finitely many proper conditions over the rationals and reducing modulo one common good prime is a valid existence argument for representations over one finite field. Sparse paving supplies the matched pointed enumerator and code parameters; the already-proved transfer theorem supplies the asymptotic conclusion. I found no clear mathematical error in this chain.

My revised overall estimate is the **95th percentile among annual specialty papers** in coding theory/local repair using finite geometry or matroids, plausible range **92nd–98th**, and the **88th percentile among annual mathematics papers generally** on transferable dimensions, range **82nd–93rd**. These rise from the post-upgrade estimates of 92 and 84. The specialty paper is now outstanding rather than merely top-decile: it combines a reusable exact transfer theorem with a separation that survives a serious invariant-matching challenge.

The principal visible defect in the immutable PDF is editorial: the conclusion still calls the older field-seven, density-\(1/7\) pair the central synthesis. That result remains true as Proposition 6.4, but the conclusion should instead culminate in the new [10,4,6], density-\(1/10\), availability-and-blocker-matched theorem.

## Revised percentile scorecard

“A” is the annual specialty comparison class. “B” is annual mathematics papers generally on transferable dimensions. Deltas are from the preceding post-upgrade C939 best estimates.

| Dimension | A: range / best | Delta | Confidence | B: range / best | Delta | Confidence |
|---|---:|---:|---|---:|---:|---|
| Correctness | 90–98 / **95** | +2 | high | 88–97 / **93** | +2 | medium-high |
| Novelty | 84–97 / **93** | +6 | medium | 74–91 / **84** | +8 | medium-low |
| Conceptual originality | 91–99 / **97** | +4 | high | 85–96 / **92** | +6 | medium-high |
| Technical depth | 88–97 / **94** | +4 | high | 79–92 / **87** | +6 | high |
| Proof completeness | 88–97 / **94** | +3 | medium-high | 85–95 / **91** | +3 | medium-high |
| Specialty significance / broader significance | 88–98 / **95** | +5 | medium | 69–89 / **81** | +9 | medium-low |
| Breadth | 92–99 / **96** | +1 | high | 86–96 / **92** | +2 | high |
| Exposition | 85–95 / **91** | 0 | high | 78–91 / **85** | 0 | high |
| Examples and formal support | 94–99 / **98** | 0 | high | 95–99 / **98** | 0 | high |
| Reproducibility | 82–96 / **90** | 0 | medium | 87–98 / **95** | 0 | medium |
| Overall strength | 92–98 / **95** | +3 | medium-high | 82–93 / **88** | +4 | medium |

The largest movement is in novelty, originality, technical depth, and significance. Exposition does not rise because the conclusion was not synchronized with the new headline. Reproducibility does not rise because the structural existence proof does not identify an explicit common prime or give concrete matrices/certificates for the new seeds.

## Remaining prioritized upgrades

Expected lifts refer to the revised **95th specialty-percentile** best estimate and are non-additive.

| Priority | Remaining upgrade | Expected lift | Effort | Risk |
|---:|---|---:|---|---|
| 1 | **Synchronize the conclusion with Theorem 6.5.** Replace the field-seven/density-\(1/7\) closing paragraph by the [10,4,6], density-\(1/10\), availability-, blocker-, and degree-matched separation. Retain the field-seven pair only as the smaller illustrative precursor. | +0.5 to +1 | very low | very low |
| 2 | **Give one explicit common-field realization of the new seeds.** Name a prime \(q\), display or archive the two \(4\times10\) matrices, and provide an exact certificate checking rank, circuit-hyperplanes, code parameters, matched clutter invariants, and reliability polynomials. The structural proof should remain primary; the instance would make the new headline independently replayable. | +1 to +2 | medium | low-medium; avoid making the theorem appear computational rather than structural |
| 3 | **Complete the exact transfer sharpness picture across all three functional strata.** Add compact examples in which the zero, singleton, and multisupport sectors separately set the threshold, together with a useful criterion for when support distance and weighted realization cost coincide. | +1 to +2 | medium-high | medium; could distract from the now-strong main separation if not concise |
| 4 | **Run a claim-by-claim novelty audit.** Compare complete coefficient ports and bounded support filtrations explicitly with recovery structures/repair hypergraphs, access structures, local decoding formulations, matroid ports/reliability, and propagation constructions. Classify each main statement as classical input, new theorem, or new consequence. | +0.5 to +1.5, mainly confidence | medium | low; close precedent could narrow wording while improving reliability |
| 5 | **Freeze an independently recoverable artifact release.** Add an immutable DOI or release URL and a compact theorem-to-command table with expected results, resource envelopes, and trust categories. | +0.5 to +1 | low-medium | low |
| 6 | **Align the geometric flagships in one comparison view.** Summarize repair-edge shape, compulsory/parallel helpers, \((\nu,\tau)\), transfer radius, reliability consequence, and evidence status, removing duplicate prose to keep the paper tight. | +0.5 | low-medium | low |

Priority 1 is an immediate correctness-of-emphasis cleanup. Priority 2 is the highest-value substantive presentation/reproducibility upgrade. The former top-priority search for an availability-matched separation should be marked complete, not carried forward.

**Vibe check:** the paper has crossed from strong top-decile work into a credible top-5% specialty paper; the remaining work is chiefly synchronization, explicit instantiation, and external novelty confidence.
