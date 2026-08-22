# Percentile referee report: *Complete Bounded Repair Ports*

**Date:** 2026-08-21  
**Artifact reviewed:** `papers/complete-repair-ports/complete_repair_ports.pdf`  
**SHA-256:** `62fdcd7f0a9875e3b8d7a17dce415cedd0c7937b8aea5b83b64155b1d5eab7be`  
**Clean-room protocol:** I read and scored the 22-page PDF before inspecting any earlier review, manuscript source, Git history, task note, verification file, or cited paper. I did not inspect those materials afterward either. The judgments below therefore assess the submitted PDF and its stated trust boundary, not the underlying repository.

## Bottom line

This is a strong, unusually integrated specialty paper. Its best contribution is not any one reliability identity, Tutte specialization, or finite-geometric calculation; it is the theorem chain that makes a represented bounded repair port into a transportable local object: exact weighted-functional confinement, eventual necessity and sufficiency of the persistent zero-functional obstruction, positive-density realization in asymptotically good families, and a matched asymptotic separation showing that full pointed rank data misses bounded stochastic behavior. That chain is conceptually original and technically credible.

My best estimate is the **90th percentile among annual specialty papers** in coding theory/local repair using finite geometry or matroids, with a plausible range of **83rd–94th**. Against annual mathematics papers generally, on dimensions that transfer across fields, I place it at the **82nd percentile**, range **73rd–89th**. The specialty score is carried by the precise transfer mechanism, the positive-density consequence, and exceptional formal/computational support. The ceiling is set by three things: the headline is not stated as one early theorem; the strongest separation does not match availability; and the geometric section contains several compressed completeness arguments that a cold referee must reconstruct.

I found **no clear fatal mathematical error** in the PDF. The exact confinement proof, its zero/nonzero functional split, the MDS reconstruction argument, and the sparse-paving separation are internally coherent. My correctness confidence stops short of very high because I did not replay the supplementary artifacts or verify the external literature, and because the densest finite-geometric counting and completeness steps are only briefly justified in prose.

## Percentile scores

Ranges express plausible percentile uncertainty, not numerical error bars. “A” is the specialty comparison class; “B” is annual mathematics papers generally. For specialty significance, the B column measures broader mathematical significance rather than field-specific importance.

| Dimension | A: range / best | Confidence | B: range / best | Confidence | Referee basis |
|---|---:|---|---:|---|---|
| Correctness | 84–96 / **91** | medium-high | 82–94 / **88** | medium-high | Main algebraic and matroid arguments check internally; no contradiction found. Residual uncertainty is concentrated in compressed geometric completeness/counting claims and unexecuted artifacts. |
| Novelty | 75–93 / **86** | medium | 65–84 / **75** | medium-low | Several ingredients are explicitly classical, but the exact pointed weighted gate, eventual obstruction, and positive-density separated realization appear to form a genuinely new package. Priority cannot be certified from the PDF alone. |
| Conceptual originality | 84–97 / **92** | medium-high | 75–91 / **84** | medium | The three-layer port and the distinction between functional support and weighted realization cost organize several subjects in a productive new way. |
| Technical depth | 82–94 / **89** | medium-high | 71–87 / **80** | medium-high | The paper combines concatenated-dual optimization, asymptotic coding, reliability, matroid perspectives, and two finite-geometric classifications. Some individual components are standard or elementary. |
| Proof completeness | 78–92 / **86** | medium | 73–89 / **82** | medium | Core transfer and separation proofs are complete at paper level. Several geometric assertions rely on phrases such as “an explicit section attains four” without displaying the witness, and artifact-to-prose correspondence is catalogued more than explained. |
| Specialty significance / broader significance | 78–94 / **88** | medium | 58–81 / **70** | medium-low | The work gives local-repair researchers a reusable invariant and an exact transfer theorem. Its impact outside coding/matroid reliability is plausible but not yet demonstrated by a broader application. |
| Breadth | 90–98 / **95** | high | 83–95 / **90** | high | The reach across coding theory, finite geometry, matroids, reliability, EXIT, asymptotics, and formal proof is exceptional for 22 pages. This is also a source of narrative competition. |
| Exposition | 76–90 / **84** | medium-high | 68–85 / **78** | medium-high | Definitions are precise, boundaries are candid, and Figure 1 helps. The introduction foregrounds the MDS reconstruction theorem rather than the central transfer/separation theorem, while Sections 6–7 demand rapid language changes. |
| Examples and formal support | 93–99 / **97** | high | 94–99 / **98** | high | Two explicit field-seven representations, exact determinant ledgers, two geometric families, named Lean terminals, hashes, and declared trust boundaries are far beyond the norm. |
| Reproducibility | 80–95 / **89** | medium | 86–98 / **95** | medium | The PDF names commits, hashes, scripts, certificates, and replay documentation. It does not itself provide a stable archival URL/DOI or the replay commands, so independent recovery still depends on the distributed source archive being available and intact. |
| Overall strength | 83–94 / **90** | medium | 73–89 / **82** | medium | A credible high-end specialty contribution with an original organizing theorem chain; not yet a field-defining result or a broadly transformative general-mathematics paper. |

## What is strongest

1. **The exact transfer theorem has the right invariant.** The use of block-functional costs \(\lambda\) and pointed costs \(\mu_x\), with the zero-functional sector separated from nonzero functional tuples, is the paper’s clearest conceptual advance. The singleton stratum is correctly retained, preventing a false support-distance simplification.

2. **Necessity is not sacrificed for asymptotics.** Theorem 4.1 identifies \(r+1<z_x(I)\) as the exact eventual confinement boundary in the stated fixed-inner, \(L\)-linear setting. This converts a sufficient transfer trick into a structural result.

3. **The asymptotic separation is meaningful.** The field-seven pair moves “pointed Tutte data do not determine bounded reliability” beyond a finite curiosity: one common outer family preserves matched global formulas while the distinct ports occur at density \(1/7\).

4. **The trust boundary is unusually honest.** The PDF distinguishes text proofs, classical inputs, Lean coverage, and evidence-only finite calculations, and it states what is not claimed (bandwidth optimality, full-MAP behavior at finite radius, cascade thresholds).

5. **The examples are structurally varied.** MDS, Clebsch, cubic–axis, quartic–nucleus, and sparse-paving examples show that the framework is not tuned to one construction.

## What limits the score

### 1. The paper hides its principal theorem package

The abstract says what the paper does, but page 1 elevates MDS coefficient-port reconstruction as Theorem 1.1. That is elegant, yet it is not the result by which the paper should be remembered. The actual headline is distributed across Theorems 3.1, 4.1, Proposition 6.4, and Theorem 6.5. A referee or editor must assemble the principal claim.

### 2. The separation leaves a conspicuous invariant unmatched

The two seeds match full pointed subset profile, locality, and number of minimum repairs, but their matching numbers—and hence disjoint availability—are 2 and 1. The text is candid about this. Still, availability is a standard coarse local invariant, so a skeptic can attribute the reliability difference to an already-visible statistic rather than to a genuinely subtler overlap pattern. Matching availability and preferably transversal number or the leading failure term would sharply strengthen the non-determination theorem.

### 3. The geometric flagships compete with the central theorem chain

Section 7 is mathematically rich, but it introduces a second center of gravity after the transfer/separation story is already complete. The cubic and quartic families demonstrate breadth, yet their exact rows do not drive the central asymptotic separation. The paper needs a clearer statement of which geometric result is essential evidence for the port framework and which is an independent application.

### 4. Several geometric completeness steps are too compressed

Examples include the asserted attaining four-point hyperplane section in the completed cubic argument, the inequality \(2c+3a\ge 6\) used in the matching bound, and the assertion that the listed determinant analyses exhaust all relevant circuits. These may be correct, and some are formally or computationally supported, but the prose should expose the decisive lemma or witness. Formalization does not replace the mathematical bridge between the paper statement and the checked declaration.

### 5. Novelty positioning is too narrow to support a top-decile certainty

The introduction cites representative locality, propagation, reliability, EXIT, and pointed-Tutte sources, but it does not compare the port to adjacent notions such as recovery structures, repair groups/hypergraphs, access structures, local decoding polynomials, or matroid port/reliability invariants in a way that isolates the exact novelty claim. The statement “we did not locate” is appropriately cautious but not enough for a confident top-5% novelty judgment.

### 6. Reproducibility is excellent in metadata but incomplete as a PDF-level route

The appendix supplies exact commit and certificate hashes and names the gate and scripts. It refers the reader to a companion README for guarded commands and does not give a stable public archive identifier. A frozen DOI/release URL plus one minimal replay table would make the artifact independently recoverable.

## Prioritized upgrades

Percentile lifts are expected changes to the **overall specialty best estimate** from the current 90th percentile. They are non-additive: completing several upgrades has diminishing returns.

| Priority | Upgrade that both unifies and strengthens | Expected lift | Effort | Risk |
|---:|---|---:|---|---|
| 1 | **State a single Main Theorem on pages 1–2** combining: exact weighted-functional confinement; the eventual iff obstruction; positive-density realization in asymptotically good families; and the matched asymptotic non-determination consequence. Follow it with one paragraph explaining the zero-functional obstruction and one diagram showing where the finite seed enters. Recast MDS reconstruction as the first application. | +2 to +4 points | medium | low |
| 2 | **Strengthen the field-seven separation so availability is matched.** Search for represented seeds with the same full pointed subset profile, locality, number of minimum repairs, matching number, and ideally transversal number/leading failure exponent, but different reliability polynomial or bounded-EXIT curve. Transfer them with the same outer family. This would show that the radius filtration contains information beyond the standard coarse invariants, not merely beyond pointed Tutte data. | +3 to +6 points | high | medium-high; such a small represented pair may not exist at current parameters |
| 3 | **Turn the transfer boundary into a sharp three-stratum theorem suite.** Give minimal examples witnessing failure from each of the zero, singleton, and multisupport functional sectors, and state precisely when ordinary functional support distance is equivalent to weighted cost. This would make the exact formula feel inevitable and reusable rather than bespoke. | +2 to +4 points | medium-high | medium |
| 4 | **Reorganize the geometric material around one comparison theorem.** Put the cubic–axis and quartic–nucleus ports in one table: repair edges, compulsory/parallel structure, \((\nu,\tau)\), reliability consequence, transfer radius, and formal/computational status. Keep one proof in the main flow and move evidence-only field-nine data and secondary closure discussion to the appendix or a companion note. | +1 to +3 points | medium | low-medium; overcompression could hide genuine geometry |
| 5 | **Expand the three load-bearing geometric completeness bridges.** Display the promised attaining hyperplane witness, prove the \(2c+3a\ge6\) inequality as a short lemma, and explicitly connect each circuit-exhaustion statement to its determinant or rank argument. Add one sentence mapping each formal terminal to the exact paper theorem. | +1 to +2 points | low-medium | low |
| 6 | **Do a targeted novelty audit and rewrite the related-work paragraph as a claim map.** Compare complete coefficient ports and bounded support filtrations against recovery structures, multiple repair alternatives, matroid ports/reliability, propagation constructions, and EXIT/local decoding. For each contribution, say “known input / new statement / new consequence.” | +1 to +3 points, mostly confidence | medium | low; may narrow a novelty claim if closer precedent is found |
| 7 | **Freeze a one-command archival artifact.** Give a DOI or immutable release URL, environment/toolchain lock, exact replay commands, expected summaries, and a compact theorem-to-artifact table. Keep hashes, but make them actionable. | +0.5 to +1.5 points | low-medium | low |
| 8 | **Add one small worked port before the general transfer theorem.** For a tiny inner code, compute \(H_x^{(\le r)}\), a coefficient fiber, \(\lambda\), \(\mu_x\), \(z_x\), and the resulting reliability. Use it again to illustrate the confinement proof. | +0.5 to +1.5 points | low | low |

The highest-value path is **1 → 2 → 3**. Upgrade 1 makes the current contribution legible; Upgrade 2 materially raises the theorem’s strength; Upgrade 3 turns the mechanism into a durable tool. If the matched-availability search in Upgrade 2 fails after a principled bounded search, that failure could itself identify the smallest parameter obstruction and motivate a structural theorem relating pointed profiles, matching, and reliability.

## Publication-level assessment

For a specialist coding-theory, finite-geometry, or algebraic-combinatorics venue, I would recommend **acceptance after moderate revision**, assuming the cited classical inputs and supplementary artifacts check. The revisions I would require are the early unified main theorem, explicit repair of the compressed geometric bridges, and a stable artifact route. The matched-availability separation is not required for correctness or publishability, but it is the clearest route from a strong paper to an outstanding one.

For a broad general-mathematics venue, the current manuscript is less competitive because its wider significance is demonstrated mainly through internal breadth rather than a theorem with consequences outside the specialty. A sharpened invariant-matched separation and a cleaner main-theorem architecture would improve that case substantially.

**Vibe check:** mathematically strong and unusually well supported; the main opportunity is not more material, but making one central theorem unmistakable and strengthening the separation past availability.
