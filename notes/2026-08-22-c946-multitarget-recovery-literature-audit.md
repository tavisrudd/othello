# C946 multi-target recovery literature audit

**Lane:** `complete-ports`

**Scope:** the sequel mathematics in
`notes/2026-08-22-c946-multitarget-recovery-confinement.md`, not the frozen
single-target manuscript

**Audit date:** 2026-08-22

**Status:** bounded audit complete; candidate novelty may be used only with
the qualifications below

## Questions audited

The audit separated six questions that must not be bundled into one novelty
claim.

1. Is simultaneous linear recovery of a target set from one helper set new?
2. Is its generator-matrix, kernel, or normalized dual-equation criterion new?
3. Is the full affine space of normalized equation systems for an arbitrary
   linear demand space \(A\leq\mathbb F_q^P\) a standard named invariant?
4. Is target-set support data already carried by a set-pointed or ported Tutte
   invariant?
5. Are generalized Hamming weights already used for cooperative locality?
6. Was an exact coefficient-aware concatenation confinement theorem, with
   finite map-valued cost and eventual threshold
   \(r<\rho_{P,A}(I)+d(I^\perp)\), located?

## Verdict

The first two questions are **prior art**.  Abdel-Ghaffar and Weber define a
cooperative repair set by the same kernel condition used in C946, prove the
equivalent generator-column span criterion, and prove the equivalent existence
of \(|P|\) dual words whose restrictions to the target set are the standard
basis.  Their Lemmas 1--2 are the precise predecessor.  Rawat--Mazumdar--
Vishwanath supply the broader cooperative-locality setting.

The support-only target-set layer is also **prior art / elementary matroid
translation**.  The condition is exactly
\(P\subseteq\operatorname{cl}_M(H)\).  Chaiken's \(P\)-ported Tutte polynomial
retains arbitrary distinguished elements through deletion--contraction, and
Chaiken explicitly identifies the set-pointed specialization with the Las
Vergnas matroid-perspective theory.  When \(P\) is recoverable from its
complement, Las Vergnas' rank-sum formula for
\(M\backslash P\to M/P\) has exponent
\(r_M(A\cup P)-r_M(A)\), after the standard rank simplification, so its
\(Z^0\) slice records the helper sets spanning all of \(P\).  C946 must not
claim invention of this carrier.

Generalized-weight bounds for simultaneous recovery are **prior art**.
Abdel-Ghaffar--Weber prove
\(r\ge d_{|P|}(C^\perp)-|P|\) under cooperative locality and develop stronger
GHW parameter bounds.  Hao--Chen and Gruica--Jany--Ravagnani further develop
GHWs in LRC bounds.  The direct-sum convolution used in C946 is an elementary
consequence of the definition of generalized Hamming weight; it is not a
standalone novelty claim.

The first proposed scalar enumerator is **already covered** by
Gruica--Jany--Ravagnani:

\[
 A_{x,j}=\frac{1}{q-1}W_{j+1}^{\{x\}}(C^\perp).
\]

Their Theorem 3.8 supplies the relevant MacWilliams-type identities, and their
Section 4 turns those identities into an LP bound.  Any sequel LP contribution
must retain genuinely joint data: target-set restrictions, equation tuples,
coefficient patterns, or intersections.  Merely renaming \(A_{x,j}\) is not
new.

The bounded search located **no predecessor** for the following combined
result, formulated at the more general linear-demand level:

- a nonzero demand space \(A\leq\mathbb F_q^P\), with the complete affine
  family of normalized equation systems realizing those demands and its
  helper-supported gauge ambiguity;
- the exact finite map-valued non-confinement cost
  \(\Theta_{P,A,j}(I,O)\) for a
  general represented inner code; and
- the sharp eventual concatenation criterion
  \(r<\rho_{P,A}(I)+d(I^\perp)\), with cooperative recovery and the
  one-target theorem recovered as specializations.

This is a `NONE-FOUND` candidate contribution, not a priority claim.  Its safe
description is: **an exact coefficient-aware transfer theorem for arbitrary
bounded linear-demand equation systems**.  Classical simultaneous/cooperative
recovery is then the full-demand corollary \(A=\mathbb F_q^P\).  Its intrinsic
criterion, cooperative-locality concept, target-set Tutte carrier, and use of
generalized weights must all be credited as prior.

## Closest-source comparison

| C946 component | closest source and locator | disposition |
|---|---|---|
| Kernel factorization / generator span for target set \(P\) and helpers \(H\) | Abdel-Ghaffar--Weber, Definition 1 and Lemma 1 | prior art |
| \(|P|\) normalized dual equations with identity restriction on \(P\) | Abdel-Ghaffar--Weber, Lemma 2 | prior art; C946's surjection and splitting notation is a basis-free repackaging |
| Quantification over every erased set of size \(e\) with one helper set of size \(r\) | Rawat--Mazumdar--Vishwanath, Definition 1; Abdel-Ghaffar--Weber, Definition 2 | prior art (cooperative locality) |
| Affine torsor of all splittings under \(\operatorname{Hom}(\mathbb F_q^P,C^\perp\cap\mathbb F_q^H)\) | no exact formulation located | elementary refinement; claim only as structural lemma, not a major novelty by itself |
| Arbitrary demand subspace \(0\neq A\leq\mathbb F_q^P\), its complete affine equation family, and exact transfer | no predecessor located in the audited recovery, GHW, or ported-matroid sources | primary `NONE-FOUND` formulation; full cooperative recovery is its classical corollary |
| \(P\subseteq\operatorname{cl}_M(H)\) | Abdel-Ghaffar--Weber, Lemma 1, translated to the column matroid | prior art / immediate translation |
| Arbitrary distinguished-set Tutte data | Chaiken, Sections 1 and 3, especially Theorem 2 and definition (3.4); Las Vergnas, Sections 2--3, especially (3.1)--(3.2) | prior art |
| \(Z^0\) full-radius recovery slice for \(M\backslash P\to M/P\) | direct specialization of Las Vergnas (3.2) | author-derived adapter from prior polynomial; not a new invariant |
| GHW obstruction for recovering \(|P|\) erasures | Abdel-Ghaffar--Weber, Theorem 1 | prior art |
| Rank-\(t\) external support cost in disjoint blocks | definition of GHW plus direct-sum support decomposition | elementary lemma; no priority claim |
| Single-coordinate refined support counts and MacWilliams/LP identities | Gruica--Jany--Ravagnani, Definition 3.2, Theorem 3.8, Corollary 3.10, Section 4 | prior art |
| Multiple concurrent requests for stored objects | Alfarano--Ravagnani--Soljanin, Definitions 2.2--2.5 | adjacent but different: service-rate allocation, not simultaneous erased-coordinate recovery |
| Sequential recovery of two erasures | Prakash--Lalitha--Kumar, abstract and model description | adjacent but different quantifiers and sequential process |
| Exact finite \(\Theta_{P,A,j}(I,O)\) and eventual \(\rho_{P,A}(I)+d(I^\perp)\) gate | no predecessor located in searched sources or screened citing sets | `NONE-FOUND` candidate contribution; cooperative recovery is the full-demand corollary |

## Source acquisition and read depth

Cache keys below name immutable local artifacts under
`/tmp/persistent/tavis/lit-search/`.  A text extractor was used only to make
search and reading reproducible; verdicts were checked against the displayed
mathematics, not metadata alone.

| source | cache key / SHA-256 | opening/full-text count | read depth |
|---|---|---:|---|
| K. A. S. Abdel-Ghaffar and J. H. Weber, *Bounds for Cooperative Locality Using Generalized Hamming Weights*, DOI `10.1109/ISIT.2017.8006618` | `pdf/10.1109_ISIT.2017.8006618.pdf`, `eea87275ca706409a947ae8e84b6b67a4715b198fea6b54bfc9a196827ce845c` | one cached full text; three reading passes; 6 pages, 6,018 extracted words | theorem-level near-full read; decisive locators and proofs read: Definition 1, Lemmas 1--2, Definition 2, Theorems 1--4 |
| A. S. Rawat, A. Mazumdar, and S. Vishwanath, *Cooperative Local Repair in Distributed Storage*, arXiv:1409.3900v2 | `pdf/arXiv_1409.3900.pdf`, `8e71095933dff7b4c083b47fa52f5ae8bafb85b8fd4e649121dc84ee26975037` | opened once; 14 pages, 14,073 words | partial: abstract, Introduction, Definition 1, remarks comparing cooperative and \((r,\delta)\)-locality, main-bound statements |
| S. Chaiken, *The Tutte Polynomial of a Ported Matroid*, DOI `10.1016/0095-8956(89)90010-5` | publisher DOI plus author-uploaded browser full text; no immutable PDF obtained | browser full text opened in five relevant ranges; 22 journal pages | partial: abstract, Sections 1 and 3, Theorem 2, definition (3.4), Section 4 Example 3 and the displayed perspective relation; sufficient for the carrier boundary, not a full-paper certification |
| S. Chaiken, *Ported Tutte Functions of Extensors and Oriented Matroids*, arXiv:math/0605707v2 | `pdf/arXiv_math_0605707.pdf`, `e8e38ba5a1480f8588e0b29aad2c8aef9c8a29693cc14da1fdc3cc4288d5edbb` | opened once; 48 pages, 22,107 words | partial: abstract, Introduction, Definition 1.1, Sections 1.2--1.3, relevant headings and cross-references; corroborates terminology and richer boundary-valued invariant |
| M. Las Vergnas, *The Tutte Polynomial of a Morphism of Matroids I. Set-Pointed Matroids and Matroid Perspectives*, DOI `10.5802/aif.1702` | `pdf/10.5802_aif.1702.pdf`, `645aeb2c003aecefc4f7ccec9e771bb287a9bbf5d79182fda2e848b8b235d19d` | opened once; 26 pages, 13,805 words | partial: Introduction, Sections 2--3, formulas (3.1)--(3.2), Theorems 3.2 and 3.7; exact rank-sum comparison checked |
| A. Gruica, B. Jany, and A. Ravagnani, *LRCs: Duality, LP Bounds, and Field Size*, DOI `10.1007/s10623-026-01829-7` | `pdf/10.1007_s10623-026-01829-7.pdf`, `555c0586dd3017cf5317ef6c73818f3764c1a5d6b8b1ea4b82c1c75d10ec6863` | opened once; 25 pages, 12,807 words | partial: abstract, Introduction, Definitions 2.9 and 3.2, Proposition 3.5, Theorem 3.8, Corollary 3.10, Section 4 LP setup |
| G. N. Alfarano, A. Ravagnani, and E. Soljanin, *Dual-Code Bounds on Multiple Concurrent (Local) Data Recovery*, arXiv:2201.07503v2 | `pdf/arXiv_2201.07503.pdf`, `75dfdc9b233c2f091e987790b6cff029551b59d0289d85f0b9b3d8b30a712bbc` | opened once; 5,092 words | partial: abstract, Introduction, Definitions 2.2--2.5, minimal-recovery-set discussion |
| N. Prakash, V. Lalitha, and P. V. Kumar, *Codes with Locality for Two Erasures*, arXiv:1401.2422 | `pdf/arXiv_1401.2422.pdf`, `8596f44adaa5891b774835700717cf8873701e53c15194b70d14724ddeac6d0d` | cached; 9,070 extracted words | abstract/model-level read only; used to classify sequential two-erasure work as adjacent, not for a theorem import |
| J. Hao and B. Chen, *On the Generalized Hamming Weights of \((r,\delta)\)-Locally Repairable Codes*, DOI `10.1109/ACCESS.2020.3016572` | DOI/OpenAlex/Crossref/ResearchGate metadata; publisher PDF returned HTTP 418 and attempted local files were empty | abstract opened once; no valid cached PDF | metadata/abstract only; no theorem-level conclusion depends on this source |

The 1989 Chaiken article was readable through the author's uploaded
browser-extracted full text, but direct publisher and ResearchGate PDF fetches
did not yield an immutable local file.  This is an **access limitation**, not
a claim that the source says nothing beyond the inspected sections.  The Hao--
Chen publisher denial is recorded separately for the same reason.

## Search log and screened sets

The queries were intentionally split among coding terminology, generalized
weights, and matroid terminology.  Broad queries were used for recall and
were not treated as absence evidence.

| provider | verbatim query | returned/screened | discriminator and result |
|---|---|---:|---|
| Crossref | `"simultaneous recovery linear codes dual subspace"` | 1,705,942 total; first 12 metadata records screened | too broad; no absence inference |
| Crossref | `"cooperative locality generalized Hamming weights"` | 453,258 total; first 12 screened | recovered Abdel-Ghaffar--Weber and Wei-adjacent work |
| Crossref | `"ported matroid Tutte recovery reliability"` | response did not yield a usable result set | provider/query failure, not zero results |
| Crossref | `"concatenated codes local recovery dual"` | 1,696,686 total; first 12 screened | mostly false positives; no absence inference |
| OpenAlex | `simultaneous recovery linear codes` | 232,812 total; first 15 screened | mostly unrelated; maximally-recoverable-code hits distinguished from fixed-target recovery |
| OpenAlex | `cooperative locality generalized Hamming weights` | 533 total; first 15 screened | recovered Rawat, Abdel-Ghaffar--Weber, Hao--Chen, two-erasure locality, and weight-hierarchy work |
| OpenAlex | `ported matroid` | 867 total; first 15 screened | recovered Chaiken 1989/2006 and Las Vergnas 1999 |
| OpenAlex | `locally repairable concatenated codes` | 3,080 total; first 15 screened | construction/parameter literature, no exact equation-transfer theorem located |
| Semantic Scholar | `cooperative locality generalized Hamming weights` | 15 total; 12 returned and screened | same cooperative/GHW cluster |
| Semantic Scholar | `ported matroid Tutte polynomial`; `simultaneous recovery linear codes`; `locally repairable concatenated codes` | service returned HTTP 429 | access failure, not empty result |
| arXiv API | `all:"cooperative locality" AND cat:cs.IT` | 18 total; all titles screened | one exact cooperative-repair seed; many “cooperative localization” false positives |
| arXiv API | `all:"generalized Hamming weights" AND all:"locality" AND cat:cs.IT` | 5 total; all screened | two-erasure, LRC weight-hierarchy, and adjacent sources |
| arXiv API | `all:"multiple erasures" AND all:"locally recoverable" AND cat:cs.IT` | 5 total; all screened | sequential-recovery and construction papers |
| arXiv API | `all:"simultaneous recovery" AND cat:cs.IT` | 2 total; both screened | phrase search did not retrieve the cooperative-locality vocabulary |
| arXiv API | `all:"ported matroid"` | 1 total; screened | Chaiken 2006 |
| arXiv API | `all:"recovery structure" AND cat:cs.IT` | 4 total; all screened | Márquez-Corbella--Martínez-Moro--Munuera and hierarchical-recovery work |
| zbMATH Open | `ti:"Tutte polynomial of a ported matroid"` | 1 total; screened | exact Chaiken record `Zbl 3993603` |
| zbMATH Open | `ti:"Bounds for cooperative locality"` | 0 | title syntax returned none although DOI/full text was independently verified; indexing miss, not absence evidence |
| zbMATH Open | `ti:"Generalized Hamming Weights" & ti:"Locally Repairable Codes"` | 0 | indexing/query miss; not absence evidence |

MathSciNet and Google Scholar were **not covered** in this run.  The former had
no configured access path; the latter was not used as a stable, reproducible
API.  “Not covered” is distinct from “searched and found nothing.”

## Forward-citation audit

Counts are provider-specific snapshots and are not expected to agree.  They
are reported separately, as required, rather than merged.

| seed | OpenAlex | Crossref `is-referenced-by-count` | Semantic Scholar | screened set |
|---|---:|---:|---:|---|
| Chaiken 1989 | 18 | 7 | 12 | all 18 OpenAlex titles/metadata screened; mathematical descendants concern set-pointed/relative/ported Tutte theory, not coding recovery transfer |
| Rawat--Mazumdar--Vishwanath 2015 | 64 | 42 | 15 | all 64 OpenAlex titles/metadata screened (largest set); 2015--2026 work clusters around bounds, constructions, sequential/parallel/cooperative repair, availability, and service models; no exact represented-inner equation-transfer theorem located |
| Abdel-Ghaffar--Weber 2017 | 4 | 0 | 5 | all 4 OpenAlex titles/metadata screened; GHW/locality bounds only |
| Hao--Chen 2020 | 4 | 5 | 5 | all 4 OpenAlex titles/metadata screened; weight hierarchies, refined distributions, and LP bounds |
| Chaiken 2006 | 9 | not separately queried | not separately queried | all 9 OpenAlex titles/metadata screened; mostly electrical-circuit applications |
| Gruica--Jany--Ravagnani 2026 | not used for a negative citation-set claim | 0 | 2 | very recent source; citation counts are too immature for absence evidence |

The citation-graph conclusion is deliberately narrow: none of the screened
titles/metadata advertises the C946 coefficient-aware concatenation theorem.
This does not substitute for reading a paper whose title/abstract later proves
closer, and it does not justify categorical priority language.

## Required wording and citation placement for a sequel

1. Introduce target-set recovery as cooperative repair, citing Rawat--
   Mazumdar--Vishwanath and Abdel-Ghaffar--Weber.
2. State that the kernel, generator-span, and normalized dual-row existence
   criteria are established; cite Abdel-Ghaffar--Weber Definition 1 and
   Lemmas 1--2 at the proposition itself.
3. State the theorem first for an arbitrary nonzero linear demand space
   \(A\leq\mathbb F_q^P\), including its complete affine equation family.
   Present simultaneous recovery as the full-demand corollary.  Do not claim
   that simultaneous recovery itself is new.
4. Cite Chaiken and Las Vergnas wherever the full-radius target-set Tutte
   carrier is introduced.  Reserve “ported” for their established matroid
   terminology.
5. Cite Abdel-Ghaffar--Weber before using generalized weights in the
   cooperative setting.  Explain that rank one controls the yes/no
   confinement gate; higher weights stratify stronger external-rank demands.
6. Cite Gruica--Jany--Ravagnani before proposing any MacWilliams/LP extension,
   and explicitly say why the proposed joint enumerator is not their
   \(W_i^S\).
7. Phrase novelty as `we prove an exact ...` and retain a bounded literature
   sentence.  Do not write “first,” “new theory of simultaneous recovery,” or
   “ported Tutte invariants do not capture recovery.”

## Audit boundary

This report certifies a bounded comparison through the listed databases,
source sections, and citation sets as of 2026-08-22.  It does not certify all
of coding theory, unpublished manuscripts, MathSciNet, or inaccessible
full texts.  It also does not certify the C946 proof; mathematical cold reads
remain a separate acceptance gate.
