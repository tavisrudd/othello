# C1136 source access and read-depth register

**Full-text reads: 0. Partial primary reads: 17 (nine carried forward from C1135, eight newly inspected here).** Cache presence never implies reading. PDF reads used genuine cached PDFs and Poppler extractions, not OCR. Attribution is to the specified arXiv version, not an unread journal revision.

V1–V4 and A1–A5 retain exactly the unconditional **partial** depths, versions, pinpoint passages and hashes in `../2026-09-10-c1135-ame-lu-two-star-verification-audit-literature.md`, Sections “Primary verification sources” and “Adjacent primary sources”; that register is incorporated without upgrading any depth. `source-cache-manifest.json` duplicates their byte identities for this audit.

| ID and source | Read depth / version / passages | Cache key and SHA-256 |
|---|---|---|
| N1: Minimum number of experimental settings required to verify bipartite pure states and unitaries | **partial**; arXiv:2112.13638v1; pp. 1–4, Sections I–III, Theorem 1 and complete proof; gate sections not audited | `arXiv:2112.13638`; `18ad223688157d3d40b37d7c73fcff6ce314fec03a38f0095ebe549c4623f6d3`; https://arxiv.org/pdf/2112.13638 |
| N2: Certifying a stabilizer state with few observables but many shots | **partial**; arXiv:2412.16690v2; pp. 1–2, introduction and model; downloaded version calls itself an extended abstract; linked full paper not read | `arXiv:2412.16690`; `1b6f03ea7ee0583108e596afd7905a74c74c38e13ba817b0c4a87cd1f861d243`; https://arxiv.org/pdf/2412.16690 |
| N3: Duality of extremal quantum states in verification and data hiding | **partial**; arXiv:2509.01281v1; pp. 1–2, introduction and contribution/model; later proofs not read | `arXiv:2509.01281`; `0caa4e1dcd855e9da595440c87555307d97da7ff9f8738ac168d5d783ce22fb7`; https://arxiv.org/pdf/2509.01281 |
| N4: Universal and Efficient Quantum State Verification via Schmidt Decomposition and Mutually Unbiased Bases | **partial**; arXiv:2506.19809v3; pp. 1–2, contents, introduction and verification model; protocol proofs not read | `arXiv:2506.19809`; `456367af56e6494fff1c841594061c63885275b4406c789f7bbbe8d70feb3656`; https://arxiv.org/pdf/2506.19809 |
| N5: Quantum subspace verification for error correction codes | **partial**; arXiv:2410.12551v1; pp. 1–2, Sections I–II through Theorem 1 opening; later proofs and published revision not read | `arXiv:2410.12551`; `90f82c076ba17d0b15ae3bc38555535cb1ea7362ca9c951c8567672c2f77226e`; https://arxiv.org/pdf/2410.12551 |
| N6: Disjoint Bell measurements enable near-projective GHZ certification | **partial**; arXiv:2606.09947v3; pp. 1–4, abstract, introduction, explicit measurement model and Figure 1; claimed optimality proofs not read | `arXiv:2606.09947`; `3f53c9635d075c7ed7e1a02455ca23258d21a8ada857b108d22e98af63b22ea4`; https://arxiv.org/pdf/2606.09947 |
| N7: Absolutely maximally entangled pure states of multipartite quantum systems | **partial**; arXiv:2508.04777v3; p. 18, pure-state marginal problem and Section IX.A Bell-pair representation; whole-document keyword locator used, not a full read | `arXiv:2508.04777`; `bc8ee8fc5648b574dc8e994eb7d27b7ef213e1873a2204e4060cc3613e15760b`; https://arxiv.org/pdf/2508.04777 |
| N8: Entanglement witnesses for stabilizer states and subspaces beyond qubits | **partial**; arXiv:2508.13734v2; pp. 1–2 and 4–5, prime-dimensional model, local-measurement settings, Theorems 1–2 with proofs and Theorem 3 statement; Theorem 3 proof not read | `arXiv:2508.13734`; `0c4b5ae184c80a52483f64dab7eff308e34a69aef67880abd926736589d38531`; https://arxiv.org/pdf/2508.13734 |

## Promoted metadata-only comparisons

Each item below has read depth **abstract/metadata only**, and supports only a scope comparison, not a theorem-level exclusion. API abstracts live in `citation-screen.json`, with the listed screen ID; primary arXiv abstract access is also preserved in `web-discovery.json`.

| Source | Access/version and reason for examination |
|---|---|
| Coladangelo–Li–Slote–Wu, *The Power of Two Bases*, arXiv:2602.11616v1 | Primary arXiv abstract and screen 545; almost-all-state guarantee and measurements on remaining qubits distinguish it from the AME total-support model. No claim about its unexamined conditional-fidelity proof. |
| Goldberg, *Stabilizers may be poor bounds for fidelities*, arXiv:2512.14811 | Primary arXiv abstract from search; oscillator/GKP target, not finite-dimensional AME. Published DOI metadata alone was insufficient to classify screen 541. |
| *Rank and Range Criteria for Mixed-State Determination from Local Marginals*, arXiv:2608.24061 | Screen 534 abstract, unspecified API version; mixed-state range criteria and three-qubit cases. Full-text AME exclusion not established. |
| Bevins–Bidav, *Symmetry-guided constructions … in five open cases*, arXiv:2608.05781v2 | Primary arXiv abstract; Scholar's older title said “exact certification,” but v2 describes exact algebraic certification of constructions. This is not an experimental fidelity certificate on the abstract evidence. |
| Lim–Lo, *Encrypted Cloning, Absolute Maximal Entanglement and Quantum Secret Sharing*, arXiv:2605.26866v2 | Primary arXiv abstract; encryption/QSS construction, no verification-gap claim in the abstract. |

Other titles in the 602-record citation corpus, 61-result zbMATH inventory, ten-result Scholar page, and web discovery inventories remain screened-set members, not individually characterized sources. The title/abstract discriminator and exact inspection depths are in the main report.
