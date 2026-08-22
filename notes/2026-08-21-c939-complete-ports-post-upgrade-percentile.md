# C939 post-upgrade percentile assessment

**Date:** 2026-08-21
**Revised PDF:** `papers/complete-repair-ports/complete_repair_ports.pdf`
**PDF SHA-256:** `1e39fe1f38b1084a27930674d48a63ae7b4c4a41b2eabe14af4630dd60b2b033`
**Revision commit supplied for identification:** `467cec4dd66bf325d3c75e063249145600eecf85`
**Method:** Fresh read of the revised 22-page PDF, followed by comparison with the original C939 scorecard. I did not inspect manuscript sources, Git contents, supplementary artifacts, or other reviews.

## Revised verdict

The revision raises the paper from an estimated **90th to 92nd specialty percentile** and from **82nd to 84th percentile among annual mathematics papers generally** on transferable dimensions. The specialty plausible range narrows from 83–94 to **87–96**; the general-mathematics range narrows from 73–89 to **77–91**.

The early Main Theorem is a material improvement, not a cosmetic one. Page 1 now states the actual theorem package: exact eventual confinement iff the persistent zero-functional cost clears the radius, exact support/coefficient-port copying, positive-density realization, and the common-outer-family separation. It also explains the obstruction immediately. The reader no longer has to infer the headline by combining Theorems 3.1, 4.1, and 6.5, and MDS reconstruction now occupies its proper role as a strong application rather than the apparent principal result.

The revised wording also improves mathematical precision. The field-seven seeds are now said to have the same **pointed rank-triple multiplicity enumerator**, equivalently the same full pointed-perspective polynomial, rather than the potentially stronger-sounding “full pointed subset profile.” Lemma 6.3 explicitly distinguishes that enumerator from the labeled subset-rank function. This makes the separation claim exact at first encounter.

The proof bridges identified in the first review are now supplied. The completed cubic matching bound expands the claim \(2c+3a\ge 6\) into the axis-only, cubic-only, and excluded mixed cases. The transversal sharpness argument exhibits a four-point hyperplane section avoiding \(A_\infty\). The Singer weighted-transfer proof now names the unit-cost class set and spells out the disjoint-translate contradiction. The formal appendix also states exactly what the paired Lean declaration does **not** cover in the human assembly of Theorem 6.5. These changes increase proof completeness and trust-boundary clarity.

I still find no clear mathematical error in the rendered paper. The remaining uncertainty is mainly external: literature priority and supplementary replay were not audited in this review.

## Revised percentile scorecard

“A” compares annual specialty papers in coding theory/local repair using finite geometry or matroids. “B” compares annual mathematics papers generally on transferable dimensions. Deltas are changes in best estimate from the original C939 review.

| Dimension | A: range / best | Delta | Confidence | B: range / best | Delta | Confidence |
|---|---:|---:|---|---:|---:|---|
| Correctness | 88–97 / **93** | +2 | high | 86–96 / **91** | +3 | medium-high |
| Novelty | 77–93 / **87** | +1 | medium | 66–85 / **76** | +1 | medium-low |
| Conceptual originality | 87–97 / **93** | +1 | high | 79–92 / **86** | +2 | medium-high |
| Technical depth | 84–95 / **90** | +1 | high | 73–88 / **81** | +1 | high |
| Proof completeness | 85–95 / **91** | +5 | medium-high | 82–93 / **88** | +6 | medium-high |
| Specialty significance / broader significance | 82–95 / **90** | +2 | medium | 61–83 / **72** | +2 | medium-low |
| Breadth | 91–98 / **95** | 0 | high | 84–95 / **90** | 0 | high |
| Exposition | 85–94 / **91** | +7 | high | 78–90 / **85** | +7 | high |
| Examples and formal support | 94–99 / **98** | +1 | high | 95–99 / **98** | 0 | high |
| Reproducibility | 82–96 / **90** | +1 | medium | 87–98 / **95** | 0 | medium |
| Overall strength | 87–96 / **92** | +2 | medium-high | 77–91 / **84** | +2 | medium |

The largest justified movements are exposition and proof completeness. Novelty and technical depth move little because the revision presents and supports the existing contribution more effectively rather than adding a new theorem of comparable scale. The overall lift is therefore two points, not the sum of the component movements.

## Remaining prioritized upgrades

Expected lifts refer to the revised **92nd specialty-percentile** best estimate and are non-additive.

| Priority | Remaining upgrade | Expected lift | Effort | Risk |
|---:|---|---:|---|---|
| 1 | **Match availability in the asymptotic separation.** Find represented seed ports with the same pointed-perspective polynomial, locality, minimum-repair count, and matching number—ideally also transversal number or minimum-blocker term—but different reliability/EXIT curves, then apply the existing common-outer transfer. This would rule out the most immediate coarse explanation for the difference between \(2s^3-s^6\) and \(2s^3-s^5\). | +3 to +5 | high | medium-high; a pair may require larger parameters or a structural obstruction may intervene |
| 2 | **Complete the sharpness picture for the three functional strata.** Add minimal examples in which the zero, singleton, and multisupport sectors separately determine the exact confinement threshold, and characterize a useful condition under which functional support distance is equivalent to weighted realization cost. | +1.5 to +3 | medium-high | medium; extra examples could broaden the paper unless presented compactly |
| 3 | **Perform a claim-by-claim novelty audit.** Compare the coefficient port and bounded support filtration explicitly with recovery structures/repair hypergraphs, access structures, local-decoding formulations, matroid ports/reliability, and propagation constructions. Record each main statement as classical input, new theorem, or new consequence. | +1 to +2, mainly confidence and range | medium | low; close precedent could reduce a claim but would improve reliability of the final positioning |
| 4 | **Freeze an independently recoverable artifact release.** Add an immutable DOI or release URL and a compact table giving the exact command, expected result, resource envelope, and trust category for each essential theorem cluster. | +0.5 to +1.5 | low-medium | low |
| 5 | **Compress the two geometric flagships into an explicit comparison view.** A one-page table or short synthesis proposition should align repair-edge shape, compulsory versus parallel helpers, \((\nu,\tau)\), transfer radius, reliability consequence, and evidence status. Remove equivalent summary prose to keep the page count stable. | +0.5 to +1.5 | low-medium | low; avoid reducing the existing proof detail |
| 6 | **Add one worked micro-example of the weighted gate.** Compute \(H_x^{(\le r)}\), one coefficient fiber, \(\lambda\), \(\mu_x\), \(z_x\), and the resulting reliability for a tiny inner/outer pair. Reuse it when introducing the three strata. | +0.5 to +1 | low | low |

The highest-EV remaining move is Priority 1. It is the only listed upgrade likely to change the paper’s theorem strength enough to move it decisively toward the top 5% of the specialty comparison class. If a bounded, principled search finds no matched-availability pair, the obstruction should be formulated: even a smallest-parameter nonexistence theorem relating the pointed-perspective enumerator, matching, and reliability could be a valuable strengthening.

**Vibe check:** the revision successfully fixes the paper’s hierarchy and the concrete proof gaps; it now reads like a top-decile specialty paper whose main remaining ceiling is theorem strength, not presentation.
