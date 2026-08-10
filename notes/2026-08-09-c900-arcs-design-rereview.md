# Frozen design-theory re-review: Arcs complete outside a conic

Date: 2026-08-09  
Role: context-clean design-theory/generalist JCTA referee  
Manuscript: `papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex` (current working copy)

## Verdict

**MINOR.** I found no false statement or human-proof gap in the requested scope. The universal prescribed-hole theorem is correctly placed before the conic application, and the exact remainder really does extract equality and stability from the two classical moments. Two citation repairs remain actionable, so this does not meet the stipulated defect-free threshold for GO.

## Findings

1. **MISSING CITATION** — In the proof of the explicit additive lower bound, the sentence calling
   \[
   q^2-k\le \binom{k}{2}(q-1)
   \]
   “the classical baseline in this setting” cites Ball, Theorem 3.1. Ball's theorem is instead the blocking-set lower bound for an *ordinary complete* arc, stated as a lower bound of order \(\sqrt{2q}\); it neither states the displayed first-moment inequality nor applies directly to an arc that is only complete outside a conic. The manuscript's deduction from the displayed inequality is correct and self-contained, so this is not a proof gap. Replace that pinpoint by a source for the elementary secant-coverage count, cite the manuscript's own earlier first-moment/corollary derivation, or recast Ball's theorem explicitly as a comparison rather than support.

2. **MISSING CITATION** — The ten-point bridge explicitly treats Mathon's two-class completeness as an external input, which is logically correct, but cites only Alspach--Heinrich and Reichard--Woldar as reports. Since the text calls this Mathon's published result and the classification is load-bearing for the two-case realization test, cite the original source directly: R. Mathon, “The partial geometries \(\operatorname{pg}(5,7,3)\),” *Congressus Numerantium* 31 (1981), 129--139. The present secondary citations can remain for the translation to matching-design language and the later models.

## Checks passed

- **Hierarchy and framing.** The abstract and introduction lead with the arbitrary-prescribed-hole identity valid in every finite projective plane, then identify the conic problem as the principal application. Theorem `thm:main` precedes `thm:main-conic`; the appendicial equality classifications are clearly marked secondary and unnecessary for the universal identity, scalar conic bound, and order-16 exclusion.
- **Ranges and code convention.** The moment identity uses \(q\ge3\), \(k\ge3\), and \(m=\lfloor k/2\rfloor\); matching rigidity begins at \(k\ge4\), while quantitative point-count stability assumes \(m\ge3\). For \(k\ge4\), projective representatives of a planar arc have rank three, every three columns are independent, and their kernel is indeed a \([k,k-3,4]_q\) MDS code. With a nonempty uncovered locus, projective syndromes have exactly the stated coset weights one, two, and three. The additive theorem's explicit \(q=2\) disposal correctly overrides the section's standing \(q\ge3\) range.
- **Moments, identity, and novelty wording.** The counts
  \(\sum r=\binom{k}{2}(q-1)\) and
  \(\sum\binom r2=3\binom k4\) are correct. Splitting them over the required locus and the hole set yields the displayed defect identity term by term. The paper accurately says this is a factored local remainder extracted from the classical two moments, not a third incidence equation. Its zero set gives indices \(\{1,m\}\) off the holes and \(\{0,m\}\) on them, while its total gives the stated point, edge, and deletion bounds.
- **MATCH simplicity, block counts, and one-block-short argument.** Concurrence cliques partition the edges of \(KG(k,2)\). At zero defect they are maximum matchings, and repetition would repeat a pair of independent edges, contradicting \(\lambda=1\). The number of blocks is
  \(3\binom{k}{4}/\binom m2\), equal to \((k-1)(k-3)\) for even \(k\) and \(k(k-2)\) for odd \(k\); a secant has replication \(\binom{k-2}{2}/(m-1)\), giving \(k-3\) and \(k-2\), respectively. In the one-block-short packing, the leave has \(\binom m2\) edges and every positive degree is divisible by \(m-1\). Its degree sum forces at most \(m\) nonisolated vertices, while that edge count forces at least \(m\); hence it is \(K_m\), supported on pairwise disjoint edges of \(K_k\), and the missing maximum matching completes the design.
- **Six/seven points.** The six-point normalization correctly forces characteristic two and \(t^2+t+1=0\), hence an embedded \(\mathbb F_4\), and the displayed sixth point follows. For seven points, zero defect would give a \(\operatorname{MATCH}(7,3,1)\) design; the cited nonexistence plus the proved two-unit leave gap gives \(\Delta_{\mathcal H}(A)\ge2\).
- **Regular hyperoval and the ten-point bridge.** “Regular-hyperoval design” is operationally defined as the abstract class of the 63 concurrence matchings of the regular hyperoval in \(\mathrm{PG}(2,8)\), and the later conic-plus-nucleus model removes any geometric ambiguity. A \(\operatorname{MATCH}(10,5,1)\) design has 45 points in its associated incidence structure and 63 blocks: each point lies on \(28/4=7\) blocks. For an antiflag \((e,M)\), exactly three edges of the perfect matching \(M\) are disjoint from \(e\), and \(\lambda=1\) gives three distinct joining blocks. Thus the manuscript correctly obtains \(\operatorname{pg}(5,7,3)\) in Reichard--Woldar's (line size, point degree, \(\alpha\)) convention, equivalently \(\operatorname{pg}(4,6,3)\) in the standard \((s,t,\alpha)\) convention.
- **Trust separation.** The manuscript cleanly separates (i) the external theorem that there are exactly two abstract ten-point matching-design/partial-geometry classes, (ii) the paper-local reconstruction of representatives, which is expressly not claimed to prove completeness, and (iii) the separate projective-realization elimination over fields. No classifier output is silently promoted to the external two-class theorem.
- **Additive bound and conclusion.** The parity-free estimate uses \(m\le k/2\) in the correct direction, and the reduction to \(P_s(a)\ge0\) is sound. The coefficient bounds in the polynomial lemma imply \(a\ge3/2-8/s\). The conclusion preserves the universal-identity-first hierarchy and does not blur the analytic theorem with the finite classifications.

## Earliest unsupported implication

There is no unsupported mathematical implication in the reviewed proof chain. The earliest actionable support defect in that chain is the Ball Theorem 3.1 pinpoint in the additive-bound proof described in Finding 1; it is bibliographic rather than logical.

This report is frozen and was prepared without consulting prior C900 reviews, dossiers, syntheses, audits, handoffs, diffs/history, trust manifests, or review notes, and without running Lean or classifiers.
