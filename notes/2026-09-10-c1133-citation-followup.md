# C1133 — citation continuation and source distinctions

**Date:** 2026-09-10. **Lane:** `cubic-threefolds`. **Status:** bounded
citation pass complete; C1133 remains ACTIVE. **Full-text reads added: zero.**
The source register now has **88 sources (87 external, one local), eight
external full-text reads (six papers and two source scripts)**. Six new
partial primary reads and three metadata reads are recorded individually in
`2026-09-09-c1133-literature-sources.json`. A title screen is not a body read.

## Citation sets recovered

Semantic Scholar's POST batch endpoint returned all twelve pinned identities
and counts after individual GET requests had returned 429. Its exact URL,
request body, timestamp and response hash are in
`2026-09-10-c1133-cont-batch.json`. Citation GETs, including reduced-field
fallbacks, are in `2026-09-10-c1133-cont-access.json` and `-cont-leads.json`.
The complete returned memberships, identifiers, count comparisons, screening
fields and discriminator are in `2026-09-10-c1133-cont-screen.json`.

| Pinned arXiv seed | OpenAlex | Crossref | Semantic Scholar / screened memberships |
|---|---:|---:|---:|
| 2307.13555 | 0 | 404 | 16 |
| 2307.03696 | 0 | 404 | 6 |
| 2604.10028 | 0 | 404 | 3 |
| 2508.05105 | 0 | 404 | 25 |
| 2605.29143 | 0 | 404 | 0 |
| 2608.01577 | 0 | 404 | 0 |
| 2411.02266, published DOI below | 0 | 0 | 5 |
| 2606.17884 | 0 | 404 | 0 |
| 2509.15831 | 0 | 404 | 1 |
| 2607.26718 | 0 | 404 | 1 |
| 2607.22074 | 0 | 404 | 1 |
| 2510.21222 | 0 | 404 | 1 |

The table records **59 memberships, 39 distinct works**. All returned titles
and external identifiers were screened. Discriminator: promote direct
birational/rationality comparisons, blowup or framing machinery and
potentially overlapping Fano invariants; retain other titles as background
leads, not content-level exclusions. Abstract fields present in saved JSON
were not automatically considered read. Prior registered sources keep their
individually recorded scopes.

All successful listings had no next-page token and matched the batch count.
For Cai (2608.01577), the batch returned zero but its citation-list GET failed
429; this is a single-index count observation, not a cross-index absence
verdict. Crossref 404 means unavailable at the queried arXiv DOI, never zero.
The other nonpublication OpenAlex/Crossref observations are from the earlier
same-day pinned probe. Semantic Scholar is the largest *returned* set.
Missing graph coverage prevents an exhaustive multi-index negative.

The F-bundle paper's exact published DOI is **10.1112/plms.70209**. Matching
titles and identifiers in all three services distinguish this paper from
the edited-volume alias encountered for *Moduli of atoms*. Counts are
0/0/5; the five-member S2 set was retrieved through the published DOI.
Published body access returned 403; the prior partial preprint read is not
upgraded to a published-version read. The Iritani author research page
lists projective bundles as forthcoming in Geometry & Topology, blowups as
forthcoming in Kyoto Journal of Mathematics, and the Hodge notes as a
preprint. It supplied no further DOI; this is not an exhaustive publication
search. The raw page is pinned in the access manifest.

## Additional source comparisons

- **Fay, arXiv:2605.30439v1 — partial:** lines 1–155 and 563–655,
  including Theorem 5.2 and its proof. It explicitly establishes the
  finite-group-equivariant Iritani blowup decomposition after the specified
  Laurent–Novikov change. The main theorem obstructs Z/2-birationality to
  projective space with a regular involution for a very general symmetric
  Verra fourfold. Remark 1.2 expressly limits the target; this does not
  assert ordinary irrationality. Credit this written equivariance argument.
- **Benedetti–Guéré–Manivel–Perrin, arXiv:2605.30450v1 — partial:**
  lines 1–180, including Theorem 1 and comparison to Fay. Birationality to a
  Verra fourfold forces the indicated vanishing Hodge structure of a cubic
  or Gushel–Mukai fourfold to come from a projective K3 surface. Rational-Hodge
  restrictions on birational partners are a concrete predecessor, beyond
  ordinary irrationality alone. The auditor's scope distinction is that B
  concerns whole H³ under one stabilization of nine threefold families.
- **Fay, arXiv:2604.14850v2 — abstract/metadata only:** the author's
  [withdrawal notice](https://arxiv.org/abs/2604.14850) identifies the
  unsupported compatibility of ordinary weak factorization with the
  factor-swap symmetry. It points to 2605.30439 as the equivariant
  replacement. The PDF 404 is explained by withdrawal; it is not an
  ordinary-irrationality theorem awaiting routine access repair.
- **Gyenge–Szabó, arXiv:2210.08939v3 — partial:** lines 1–170,
  including Theorem 1.1. The surface blowup spectrum has explicit analytic
  asymptotics on a conical parameter domain. Credit this surface predecessor;
  the read theorem does not itself establish the general-center lattice
  comparison required here.
- **Iritani, arXiv:2501.18849v2 — partial:** lines 1–130. The survey
  distinguishes the proposed general Fourier/reduction picture from the
  proved projective-bundle and blowup applications. This introductory read
  supplies framing, not a new theorem-level coverage verdict.
- **Fay, arXiv:2609.06759v1 — partial:** lines 1–155, Theorem 1.1 and
  Corollary 1.2. Rationality of a Hodge-general special cubic fourfold forces
  vanishing of the specified quaternion class. The auditor distinguishes
  arithmetic of rational Hodge forms here from D's bounded-degree finiteness
  of geometric cubic-threefold partner classes. No full-paper exclusion.
- **Ovcharenko, arXiv:2604.26592v3 — partial:** lines 1–155, including
  Theorem 1.1 and Proposition 1.2. The inspected results concern tempered
  Laurent polynomials and motivic extensions of mirror families. This is
  not evidence of D or its negation; the similar arithmetic vocabulary
  alone would have been a misleading match.
- **Brooke–Marquand, arXiv:2609.10353v1 — abstract/metadata only:**
  the abstract reports birationality of a very general discriminant-44
  cubic fourfold to its Fourier–Mukai partner. It is a newly indexed
  fourfold comparison lead, not a read proof or a threefold counterexample.
- **Raugas, arXiv:2608.12191v1 — abstract/metadata only:** the abstract
  discusses a dynamical-protection conjecture and solvable/Painlevé models.
  No theorem input or content-level exclusion is taken from it.

The owning novelty ledger was updated first: B's attribution now includes
the explicit equivariant comparison and rational-Hodge partner restrictions.
No general quantum, equivariant, or Hodge-partner priority is claimed.
The exact A–D novelty and promotion gates remain as recorded there.

## Remaining gates and stopping boundary

1. Version-match the published *Interpretations of spectra* chapter to the
   author-hosted text already read; obtain the categorical-base-loci chapter
   body. The alternate Miami thesis landing page was reachable but yielded
   no downloadable chapter body; its CiteSeer mirror returned 404. Neither
   supplies a version-matched chapter. No mathematical input was imported
   from that thesis metadata.
2. Obtain the exact special-pencil companion for packet §§30–31. The
   already-pinned local sharpness theorem does not discharge the pencil's
   hypotheses. The pending author path/link question remains relevant.
3. Complete outstanding service coverage and any necessary deeper reads
   before a global novelty verdict. MathSciNet and Google Scholar remain
   NOT COVERED. This pass stops at the first layer of the twelve exact seeds;
   it does not recursively claim closure of the 39 citing papers.
4. Keep manuscript theorem hierarchy/promotion behind the C1133 gates.
   C978/C956 are unchanged; optional pencil imports remain withheld.

## EJ + TT closeout and Mystery ledger

The bounded citation-recovery gate passed; the complete C1133 gate did not.
The explicit EJ + TT pass asked whether inaccessible links concealed a
source-identity or hypothesis error rather than merely an access problem.

| Feature | Disposition and evidence gap |
|---|---|
| S2 GET failures obscured available counts | Settled for these twelve identities by POST batch and alternate citation GETs; 59 memberships match counts. Independent Crossref gaps remain. |
| Verra ordinary-irrationality lead conflicts with replacement scope | Settled at author-notice level: withdrawn for an equivariance gap. This reinforces retaining actual operation hypotheses; it is not a new proof defect claimed for our packet. |
| Arithmetic titles resemble D | Statement-level distinctions recorded; no universal negative from partial reads. |
| Specific pencil asserted without exact source | Unsettled: need the companion and its precise hypotheses, not an ambient Torelli substitution. |
| Older spectra publication and categorical chapter bodies | Unsettled access/version gates, explicitly retained above. |

No further task-owned mathematical mystery was manufactured from these
metadata differences. No incidental discovery was promoted or cross-lane
task allocated.

## Reproducibility, hygiene and repeating surfaces

Replay: `python3 notes/2026-09-10-c1133-cont-verify.py` from the repository
root. It verifies all pinned response hashes, identities, cardinalities,
source read-depth fields and new PDF hashes. This is documentary validation,
not a Lean or mathematical computation replay. Exact service requests and
manual screening scope are preserved; no secret credentials are needed.
No independent human reading replay occurred.

One command mistakenly concatenated two entire extracted papers and exceeded
the output bound. That truncated output was not used as a full-text read;
it was replaced by explicit 1–170 and 1–155 ranges. A redundant fetch of
2605.30450 matched its existing cached hash exactly; the cache was preserved.

Updated surfaces: owning claim–proof–novelty ledger, source register, this
report, the earlier closeout's current pointer, task card and lane handoff.
The manuscript, snapshot/public summaries, arithmetic audit and formal
registries received no new novelty statement and were not promoted or
rebuilt. Their earlier incomplete-coverage boundary remains. No export,
push or outreach. The documentary bundle is committed together after its
scoped validation.
