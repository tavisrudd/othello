# C1135 — literature positioning and contribution audit

**Lane:** `ame-lu`. **Date:** 2026-09-10.

**Read-depth summary: 0 external sources read in full; 9 primary sources read in specified parts.** Four verification sources were read by the root and five adjacent sources by the literature reviewer; the root checked the delegated source register and its full-text count. This is a targeted, theorem-level audit with explicit coverage limits, not a closed publication-priority search. The mathematical proposal does not need an absence claim. No “first,” “best known,” or “to our knowledge” sentence is approved for publication by this audit.

## Decision and motivation

The defensible contribution is an **exact support-budget verification theorem** and its connection to the existing rigidity bounds. The paper should explain that each copy allows a test touching at most `m+1` of `2m` parties; all smaller complete tests are uninformative. In that model, the complementary marginal families attain the locality cap, and additive stabilizer geometry gives every intermediate optimum as the number of settings increases. This supplies a sharp answer at the AME information threshold, rather than a general claim to have invented efficient stabilizer verification.

The closest established ingredients are substantial. They include a minimal-test gap bound, canonical stabilizer test projectors, eigenbasis linear programs, generator-data fidelity formulas, local ground-state verification, canonical marginal-support parents, virtual-factor constructions, and MDS counting. These must be credited directly. The packet's source list is incomplete for its proposed motivation: add Kalev–Kyrillidis–Linke and Zhu–Li–Chen; for the universal appendix, also acknowledge the virtual-subsystem/support-parent literature identified below.

## Primary verification sources read by the root

All four are Poppler text extractions of genuine PDFs fetched into the shared cache after explicit cache misses. Versions below are those printed in the downloaded bytes. Results are attributed to those versions; journal metadata alone is not proof that another version was read. No OCR was used. Pinpoints refer to PDF pagination.

| ID / source | Read depth and exact passages | Cache identity |
|---|---|---|
| V1: Dangniam, Han, Zhu, *Optimal verification of stabilizer states* | **partial**; arXiv:2007.09713v1, 19 July 2020. PDF pp. 3, 8–9, 12–13, 17: Section II.A Eqs. (4)–(7), Proposition 1 statement; Section IV.A canonical-test definition and Lemma 5 with proof, Theorem 1 statement; Section V.A Lemma 12 with proof; Section V.B Eqs. (95)–(99); Section VII.A Lemma 15's displayed equivalences through item 3. The full appendices and all optimal-protocol tables were not read. | `arXiv:2007.09713`; SHA-256 `f8745c6828109da705f52dac0189ffa907e2dcc107a3c7d61f9fe5034aac3ebe`; https://arxiv.org/pdf/2007.09713 |
| V2: Pallister, Linden, Montanaro, *Optimal verification of entangled states with local measurements* | **partial**; arXiv:1709.03353v3, 23 February 2018. PDF pp. 2 and 4: Eqs. (1)–(3), locality/trust/projectivity model, stabilizer-generator versus all-stabilizer sampling discussion. Supplemental proofs were not read. | `arXiv:1709.03353`; SHA-256 `3fe2a8ea8d87495601130b8e5a56cf1430a9d44a4354105d0c97e67b59b95fab`; https://arxiv.org/pdf/1709.03353 |
| V3: Kalev, Kyrillidis, Linke, *Validating and Certifying Stabilizer States* | **partial**; arXiv:1808.10786v2, 16 September 2019. PDF pp. 1–3: introduction, model, generator feasibility/positivity argument, Proposition 1 and its complete proof, Eq. (5) giving the exact minimum fidelity from generator expectations. Statistics and experiment sections not read. | `arXiv:1808.10786`; SHA-256 `b35ecce33062abfd16d6980b9c72353e106aa54981b0a794425adea742629b21`; https://arxiv.org/pdf/1808.10786 |
| V4: Zhu, Li, Chen, *Efficient Verification of Ground States of Frustration-Free Hamiltonians* | **partial**; arXiv:2206.15292v3, 4 January 2024. PDF pp. 6–8: Section 4.1 bond verification `Q_e <= Omega_e <= I`, matching protocols; Theorems 1–2, Eq. (39), initial proof of Theorem 1 through Eq. (50). Their detectability-lemma proof and application sections were not independently audited. Publisher page also consulted for bibliographic metadata. | `arXiv:2206.15292`; SHA-256 `49fd133aee25d8dfe2d75948bf08ec8c42ffdf855c900a6f0c0a6717adf133ab`; https://arxiv.org/pdf/2206.15292 ; metadata https://quantum-journal.org/papers/q-2024-01-10-1221/ |

The cached paper records are authoritative for bytes, not evidence of reading. An initial attempted ten-page display was truncated; it does not count as reading. Only the subsequently bounded pages listed above support this report.

## Adjacent primary sources

These five sources all have **partial** read depth. The delegated companion `2026-09-10-c1135-ame-lu-two-star-verification-audit-literature-adjacent.md` is the full register of access, versions, pinpoints, hashes and inferences; its opening count is correctly zero full-text reads. The following compact register makes every named source explicit here as well.

| ID / source | Version and passages | Cache key / SHA-256 |
|---|---|---|
| A1: Wu, Yang, Wang, Wen, Qin, Gao, *Determination of stabilizer states* | arXiv v1; pp. 1–2, Theorem 2 p. 4, corollary/example p. 6; not its full long proof | `arXiv:1503.05421` / `7c1c992227de0b0a44c50c950263e81eeceac4353f4a32928eeebeefef850e25` |
| A2: Tóth, Gühne, *Entanglement detection in the stabilizer formalism* | arXiv v2; Sections III.B–C pp. 7–8, Theorem 7, Eqs. (46)–(48) | `arXiv:quant-ph/0501020` / `f0f379dd6859b56d1aa75fbe2e668f9ca2d75cf4be1f086d47c737d6a2b570fa` |
| A3: Huber, Grassl, *Quantum Codes of Maximal Distance and Highly Entangled Subspaces* | arXiv v2; Section 8 pp. 6–7, Theorems 8–9 and proofs, Eqs. (29)–(37) | `arXiv:1907.07733` / `c4e5dfba9f8ccbb3f496c956c96cc83cc9bb2c117f23e0a05be639153d444e94` |
| A4: Johnson, Ticozzi, Viola, *Exact stabilization of entangled states in finite time by dissipative quantum circuits* | arXiv v1; Sections II pp. 3–4, IV pp. 8–9, V.A p. 10; Theorem II.5, Example IV.2, Proposition IV.3, Eq. (17) | `arXiv:1703.06183` / `b7f4382cda7d5b0faa517f786eb7c8989ca59da2d52cf7c93a27dbf7f7375c9a` |
| A5: Karuvade, Johnson, Ticozzi, Viola, *Generic pure quantum states as steady states of quasi-local dissipative dynamics* | arXiv v1; Section 2 pp. 6–7, Theorem 2.1/Corollary 2.2/canonical parent; Sections 5.1–5.2 pp. 27–30, Theorem 5.1 and Proposition 5.2 with proofs | `arXiv:1711.11142` / `360a007dc0157e8f48b82f7b0818627f06a9167cd377c46d7414ff59b3b79027` |

Access for A1–A5: `https://arxiv.org/pdf/<identifier without arXiv:>`, cached PDFs and their text extractions; the delegate independently recomputed their PDF hashes. No claim is made about unread editions or references cited within those papers.

## Prior-work versus proposed contribution matrix

| Proposed item | Established comparison | Decision / attributable increment |
|---|---|---|
| Marginals determine a stabilizer state among mixed competitors | A1 Theorem 2; already C1089/current proposition | Already present; retain existing credit. |
| Support projectors define canonical frustration-free parents | A5 Section 2 and Theorem 5.1 (itself crediting earlier work) | Standard framework; no general parent/determination novelty claim. |
| One-star commutativity beyond stabilizers | A4 virtual-subsystem factorization | Useful elementary instance: conjugate Bell-pair projectors by the unitary identifying the opposite half; auditor's inference, not a theorem quoted from A4. |
| Constant-gap stabilizer verification | V2 stabilizer discussion; V1 separable/Pauli protocols | Established. Do not advertise merely a constant gap or efficient verification as the contribution. |
| Minimal `s` tests give gap at most `1/s` | V1 Proposition 1 | Exact prior theorem. The proposed `s=m` upper bound is a specialization, not a separate conceptual advance. |
| Canonical subgroup tests and character/eigenbasis LP | V1 Lemma 5, Theorem 1, Section V.B | Established mechanism. New calculation is the doubled-star failure geometry yielding a closed-form weighted optimum. |
| Weighted sum of smallest `m+1` weights; arbitrary-effect setting curve | V1's model uses locally commuting Pauli subgroups and all-party product measurements | The supplied proof establishes the statement in a different fixed-support model. No identical statement was located in the nine consulted sources' specified passages; no literature-wide priority conclusion. |
| Universal full AME gap | V4 relates local bond verification to Hamiltonian gap, e.g. Theorem 2 | Existing framework; the AME error-space argument supplies the exact gap and the matching support-local upper bound. V4 alone does not compute this AME geometry. |
| Universal any-half sufficiency and weighted lower bound | A4/A5 clarify qualitative structure; independent audit strengthens packet | Proved in C1135 by shifted error filtrations. Proposed as mathematical content with no priority assertion. |
| Fidelity from measured rejection / stabilizer data | V1 Eq. (5), V3 Proposition 1, A2 Section III.C, V4 Theorem 2 | Standard certificate methodology. AME normalization is exact; novel-to-manuscript use is as an input condition for existing product-unitary rounding. |
| Sample complexity | V1 Eq. (7), V2 Eq. (3) | Established inverse-infidelity/log-confidence law. `O(max(q,n)log(1/alpha))` merely substitutes the current rigidity radius. |
| MDS spectrum | A3 Theorems 8–9 and classical MDS counting discussed there | Standard inclusion–exclusion. The test-indexed syndrome code needs its own bridge; do not identify its weights with physical Pauli weights without proof. |
| General verifier LP / cost optimization | V1 Eq. (99); elementary order statistics | Specialized small LP, not a new general verification algorithm. Defer from main paper. |

## Measurement models and physical significance

V1 permits single-party Pauli measurements, often simultaneously on every qubit, with classical acceptance conditions; its canonical local subgroups are locally commuting. The doubled-star minimum-support subgroup has a full Weyl plane at each supported party, so its whole support projector is not thereby one product-Pauli basis test. Conversely, an all-party Pauli setting exceeds the present party-touch budget. Hence neither model contains the other, and numerical gaps cannot be compared as a laboratory superiority claim. V1's qubit separable bound `2/3` is not an upper bound for entangled subset effects; the qutrit `3/4` example is not a violation or improvement of that bound.

V4's general matchings allow disjoint bond tests on many sites in one round. Here every `m+1`-party support overlaps every other, so the elementary support-constrained protocol samples one such test per copy. Its contribution is exact AME conditioning with a sharp permitted-support cap, not a general acceleration of frustration-free verification. It also does not establish efficient implementation of an arbitrary nonstabilizer marginal projector.

The best practical motivation is a trusted verification primitive at the first informative support size, with predictable resilience to unavailable settings. A proposed marginal reconstruction bound can be read directly from projector acceptance probabilities; full marginal tomography is unnecessary if the tests are implementable. Product-unitary information is an additional promise needed to convert state verification into Clifford conclusions.

## Search record, stopping rule, and limitations

Root search discovery used the web search service on 2026-09-10. The durable `search-records.json` records exact queries and title/URL inventories for three batches, containing respectively **18, 16 and 20 returned entries** (54 entries, not deduplicated papers). Screened fields: returned titles and snippets. Mechanical promotion discriminator: “primary sources addressing subset-local marginal tests, verification gap, setting count, or AME error-space structure.” Four verification papers were read at the depth above. Search-engine dates were not used as authoritative publication dates.

Initial orientation queries, before preserving those batches: `"absolutely maximally entangled" "verification" spectral gap`; `"perfect tensors" "verification" marginal`; `"quantum state verification" "marginal" optimal`. These were discovery only and supply no absence finding. The adjacent delegate records eight further exact discovery queries and five promoted primary-source reads in its companion report.

The query including the exact V1 title and AME was a targeted search for related/citing discussions, not an enumeration of its forward citation graph. V1 led through its text to V3, and targeted ground-state-verification searches led to V4. Search snippets and secondary pages were used only to locate primary papers, never to substantiate a theorem attribution. Irrelevant results are covered as screened-set members, not independently read works.

Stopping rule: compare the two proposed exact verification mechanisms and observable bridge against the two principal verification seeds, the direct fidelity and frustration-free extensions they motivate, and the five adjacent support/virtual-factor/MDS sources. All nine selected primary PDFs were reachable. The exact theorem remains independently proved; the search does not close all possible synonyms, publications or citations. **OpenAlex, Crossref, Semantic Scholar citation-graph enumeration, MathSciNet, zbMATH and Google Scholar are NOT COVERED.** No verdict rests on a citing-set count or exhaustive citation screen, so there is no three-graph absence claim. These gaps preclude unqualified priority language; they do not prevent attribution-supported presentation of the theorem and proof.

## Surfaces and adoption gate

No current manuscript novelty verdict changes: these theorems have not been adopted. Manuscript, existing claim/novelty ledger, public snapshot/README, and public portfolio summary remain unchanged. The proposal contains mathematical content descriptions, not an absence-based novelty assertion. If a later integration wants a priority sentence, first create/update the owning paper's claim–proof–novelty ledger row with this evidence depth and any further search; only then propagate its wording to manuscript and public surfaces. No automatic export or push is appropriate at this proposal stage.

Recommended additional references can be cited by arXiv identifier where journal metadata has not been independently checked. V4's consulted publisher metadata gives *Quantum* **8**, 1221 (2024), DOI `10.22331/q-2024-01-10-1221`. V3's discovered DOI is `10.1103/PhysRevA.99.042337`; proof attribution is to the read arXiv v2. Avoid silently filling missing bibliographic details from memory.
