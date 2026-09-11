# C1135 adjacent literature audit: marginal supports, virtual factors, and spectra

**Lane:** `ame-lu`
**Date:** 2026-09-10
**Scope:** delegated audit of Modules 1–2 of the supplied revision packet; no manuscript adoption or novelty-ledger update.

Opening count: **0 sources read at full text; 5 sources read partially from cached primary PDFs.** Exact locations and byte identities are below. This is a bounded comparison, not a closed priority search. Its positive conclusion is that support-based determination, commuting-projector fidelity bounds, virtual-factor constructions, and MDS weight counting have clear antecedents. The specific complementary-star geometry and sharp AME gap should be distinguished from these methods. The passages read do not establish pre-emption of the universal `(m+1)/(2m)` two-star theorem; this statement is restricted to those passages and is not a literature-wide negative.

## Source register

All five texts were accessed as Poppler extractions of the listed PDFs through the shared disk cache. No OCR is involved. SHA-256 was independently recomputed on each cached PDF in this audit. Page numbers below refer to PDF/printed pagination, which agree at the locations used. Versions are the arXiv versions visibly stamped in the fetched bytes; no assertion about a different published version is made.

1. **Wu, Yang, Wang, Wen, Qin, Gao, _Determination of stabilizer states_.** Read depth: **partial**. Version: arXiv:1503.05421v1, 18 March 2015. Read: abstract/introduction and opening preliminaries, pp. 1–2; Theorem 2 statement, Sec. IV, p. 4; corollary and four-qubit example, p. 6. The intervening long componentwise proof was not read in full. URL: https://arxiv.org/pdf/1503.05421 . Cache key: `arXiv:1503.05421`; SHA-256: `7c1c992227de0b0a44c50c950263e81eeceac4353f4a32928eeebeefef850e25`.
2. **Tóth and Gühne, _Entanglement detection in the stabilizer formalism_.** Read depth: **partial**. Version: arXiv:quant-ph/0501020v2, 12 July 2005. Read: Sec. III.B, “Witnesses for graph states,” p. 7, including Theorem 7 and the measurement-coloring discussion; Sec. III.C, “Obtaining the fidelity of the prepared state,” p. 8, Eqs. (46)–(48) and surrounding fidelity explanation. URL: https://arxiv.org/pdf/quant-ph/0501020 . Cache key: `arXiv:quant-ph/0501020`; SHA-256: `f0f379dd6859b56d1aa75fbe2e668f9ca2d75cf4be1f086d47c737d6a2b570fa`.
3. **Huber and Grassl, _Quantum Codes of Maximal Distance and Highly Entangled Subspaces_.** Read depth: **partial**. Version: cached arXiv:1907.07733v2, 17 June 2020, bearing the Quantum acceptance footer. Read: Sec. 8, “The weights of quantum MDS codes,” pp. 6–7, Theorems 8–9 and their proofs, Eqs. (29)–(37), through the end of Sec. 8. URL: https://arxiv.org/pdf/1907.07733 . Cache key: `arXiv:1907.07733`; SHA-256: `c4e5dfba9f8ccbb3f496c956c96cc83cc9bb2c117f23e0a05be639153d444e94`.
4. **Johnson, Ticozzi, Viola, _Exact stabilization of entangled states in finite time by dissipative quantum circuits_.** Read depth: **partial**. Version: arXiv:1703.06183v1, 17 March 2017. Read: Sec. II neighborhood-stabilization definitions and Theorem II.5, pp. 3–4; Sec. IV opening product-state construction, Example IV.2 and Proposition IV.3, pp. 8–9; opening Sec. V.A virtual-subsystem sufficient conditions and Eq. (17), p. 10. URL: https://arxiv.org/pdf/1703.06183 . Cache key: `arXiv:1703.06183`; SHA-256: `b7f4382cda7d5b0faa517f786eb7c8989ca59da2d52cf7c93a27dbf7f7375c9a`.
5. **Karuvade, Johnson, Ticozzi, Viola, _Generic pure quantum states as steady states of quasi-local dissipative dynamics_.** Read depth: **partial**. Version: arXiv:1711.11142v1, 29 November 2017. Read: Sec. 2 definitions, Theorem 2.1, Corollary 2.2 and canonical-parent formula, pp. 6–7; Sec. 5.1 Theorem 5.1 and its proof and the DQLS/UDA distinction, pp. 27–28; Sec. 5.2 including Proposition 5.2 and proof, pp. 28–30. URL: https://arxiv.org/pdf/1711.11142 . Cache key: `arXiv:1711.11142`; SHA-256: `360a007dc0157e8f48b82f7b0818627f06a9167cd377c46d7414ff59b3b79027`.

## Findings and attribution

### Support-projector determination is an established framework

Wu et al. Theorem 2 explicitly determines an n-qubit graph state among arbitrary, possibly mixed, states from marginals on supports of an arbitrary independent stabilizer generating set. Their introduction explains extension to stabilizer states. Their p. 6 corollary removes redundant contained supports. Thus a statement that stabilizer states are determined by appropriate local reductions is not a new contribution. The AME claim may contribute the highly structured family, sharp locality/count, and quantitative spectrum; those require their own proof.

Karuvade et al. give the broader language directly: the intersection of extended marginal supports is one-dimensional exactly when the pure state is dissipatively quasi-locally stabilizable, equivalently the unique ground state of a frustration-free parent Hamiltonian with the same neighborhoods. They explicitly write the canonical parent as the sum of complementary marginal-support projectors. Their Theorem 5.1 proves that support-intersection uniqueness implies UDA. They themselves attribute the earlier structural equivalences and Theorem 5.1 to earlier references: this audit does not promote their restatement into an originality claim for that paper, and does not independently characterize those earlier references.

Their Proposition 5.2 obtains support-only reconstruction for generic multipartite states from two neighborhoods of about half the parties. **Auditor inference:** genericity is decisive: an AME target lies on a special maximally mixed locus, so that generic theorem neither supplies nor contradicts the packet's every-AME statement or its m-test star. Do not motivate the packet by saying support-only reconstruction beyond stabilizers was unavailable.

### The one-star lemma is an especially elementary virtual-factor instance

Johnson et al. explicitly use a virtual tensor-product decomposition in which the target factorizes and each virtual-factor algebra is contained in an allowed physical neighborhood. Cooling those factors gives commuting local channels and robust finite-time stabilization. This goes beyond stabilizer states in their examples.

**Auditor inference, not a claim stated in that paper:** for the packet's maximally entangled B|C state, write `psi=(I_B tensor U_C) tensor_i Phi_(B_i,C_i)` after choosing q-dimensional virtual factors in C. Conjugating each Bell projector by `I_B tensor U_C` yields precisely the support projector on `C union {i}`; each acts on its Bell pair before conjugation. The commuting one-star parent and binomial spectrum follow at once. This is an alternative explanation of the packet's error-basis proof, and places it within existing virtual-subsystem reasoning. It is a useful lemma, but should not carry a strong standalone novelty claim.

The two stars use distinct physical/virtual descriptions. The universal two-star lower bound requires the AME low-error-space orthogonality pairing; the virtual-factor result alone does not give that bound. A separate proof/attribution gate remains appropriate for this quantitative step.

### Fidelity witnesses and “settings” need careful separation

Tóth–Gühne Sec. III.C explicitly gives an operator lower bound on the target projector, hence a fidelity lower bound, from a small collection of stabilizer products. Their Sec. III.B counts local product-basis measurement settings using graph colorability.

**Auditor inference:** this is close methodological precedent for the packet's energy-to-infidelity certificate. It is not the same measurement model. The packet permits an arbitrary joint binary measurement on a selected `(m+1)`-party subset, and caps the total number of touched parties per copy. A product-Pauli setting may touch every party. The revision must retain that distinction wherever it uses “optimal,” “setting,” or compares numerical gaps. A constant number of joint support-projector tests does not establish a constant number of single-party Pauli measurement settings or an efficient joint implementation.

### MDS weight counting is imported structure; syndrome coordinates are the contribution

Huber–Grassl Sec. 8 proves parameter-determined unitary and Shor–Laflamme weight distributions for general QMDS codes and derives the latter using Möbius inversion. The section also explicitly recognizes parameter-determined classical MDS weights as prior knowledge. It is appropriate precedent for the method and surrounding quantum-MDS interpretation.

**Auditor inference:** the packet's multiplicities count failure supports in its *test-indexed additive syndrome code*, not directly the physical-support Shor–Laflamme weights. The required bridge is the proof that every m test blocks give a bijection, so the syndrome image is an additive MDS code over an alphabet of size `q^2`; then elementary inclusion–exclusion gives the spectrum. Cite the established counting structure without saying Huber–Grassl directly states the packet's verification spectrum. Likewise, do not silently upgrade additive prime-field linearity to `F_(q^2)`-linearity.

## Bounded searches and coverage

Search date: 2026-09-10. Service: web search exposed by `web.run`. Exact queries:

- `arxiv 1503.05421 Wu reduced density matrices`
- `arxiv quant-ph/0501020 Toth Guhne`
- `absolutely maximally entangled states verification support projectors spectral gap`
- `"maximally entangled" "virtual" "dissipative" stabilization neighborhood`
- `"absolutely maximally entangled" "verification" "gap"`
- `"AME" "two-star" quantum verification`
- `site.arxiv.org "stabilization" "virtual subsystems" Viola`
- `site.arxiv.org "quasi-local" "support" "pure states" Ticozzi Viola`

This was targeted discovery, not an exhaustive screen of every returned hit. Promotion discriminator: primary papers addressing stabilizer marginal determination, support-only reconstruction, virtual factorization under neighborhood constraints, or verification fidelity/spectral methods. The individually consulted set comprises the five registered sources above: three assigned seeds and two adjacent sources promoted from primary arXiv abstract results. Screening fields for promotion were title and abstract/search snippet; only the specified primary-paper passages support the findings. Broad query results contained irrelevant physical-dynamics hits and were not treated as evidence of absence. No claim rests on an exhaustive screen or citation count.

All five intended primary PDFs were reachable; four newly fetched PDFs were ingested after a cache miss and one was reused. No forward-citation closure was attempted: OpenAlex, Crossref and Semantic Scholar are NOT COVERED. MathSciNet, zbMATH and Google Scholar are NOT COVERED. This audit licenses no manuscript-wide “first,” “only,” or literature-closed “to our knowledge” claim. The exact universal gap and weighted tradeoff still require the root audit's verification-specific comparison; broad searches here do not close those questions.

## Recommended motivation and closeout

Suggested framing: “Marginal support projectors already provide canonical frustration-free tests for pure-state determination. For AME states, we identify a complementary pair of marginal stars whose uniform test has a sharp, dimension-independent gap under a fixed per-copy party budget. In the additive stabilizer case, the test syndromes form an MDS code, yielding the exact weighted gap and setting tradeoff.” This is a description of the proposed result's content, conditional on the independent proof gate, not a priority claim.

Explicit `ej` + `tt` pass: the cheap conceptual upgrade is the virtual Bell-pair derivation of the one-star lemma, which explains why its commutativity and binomial spectrum need no stabilizer hypothesis. The critical stress test is the measurement model: the sharp party-budget claim must not become an unqualified local-measurement optimum.

**Mystery ledger:** the virtual-factor origin of one-star commutativity is settled by the elementary conjugation above; no mystery remains there. Whether a prior paper states the exact universal complementary-star gap is an evidence gap, not a mathematical mystery; owner is the root C1135 literature/adoption gate. No incidental research discovery is promoted by this subaudit.

Surface accounting: no existing novelty verdict was changed here. Manuscript, owning novelty ledger, snapshot, public summary and handoff were not edited; root must check and update those surfaces if it adopts an altered claim. This report is intentionally uncommitted for root integration; its sole owned path is this file. No Lean, manuscript, mirror or remote action occurred.

Execution note: an initial combined documentation read exceeded the command-output contract and was truncated; bounded source reads replaced it. No literature verdict relies on truncated material.
