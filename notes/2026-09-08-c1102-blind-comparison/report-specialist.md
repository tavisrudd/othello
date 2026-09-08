# 1. Blind choice

**Version A.** Its advantage is precision at the points where a quantum-information specialist needs it: the abstract states the noise and ideal-operation assumptions behind the resource advantage; the introduction separates ten-qudit Clifford-product exclusion from six-qudit preparation savings; the synthesis model is defined explicitly; and the chordal discussion distinguishes actual phase polynomials from projective representatives. The common analytic arguments are convincing, while the finite censuses remain computational inputs whose reported verification boundaries deserve to remain visible. A positions the construction sensibly relative to Campbell–Anwar–Browne, Haah, and Krishna–Tillich, identifies Campbell–Howard synthillation as the operational precedent, and uses the Leone–Oliviero–Hamma entropy normalization without claiming that entropy alone proves a preparation-cost advantage. Both versions would benefit from an explicit sentence connecting the signed cubic cancellation to Bravyi–Haah triorthogonality. A communicates the specialist contribution more directly and makes the operational normalization of the shadow substantially more reviewable.

# 2. Specialist confidence scores

- **A: 8/10.** The analytic proofs and restricted resource comparison withstand a paper reading; the principal remaining uncertainty is the unexamined finite evidence, especially the large census over F₁₁ and the supplied shadow identification.
- **B: 7/10.** The shared analytic results are comparably credible, but the shadow equivalence lacks an explicit representative convention, and several definitions and evidence connections are left to external records.

These scores concern acceptance of the claims at their stated strength, not an independent certification of the computations. I read both text extractions completely before forming this report. Direct PDF extraction/rendering was unavailable in this environment, so I could not visually verify the PDFs. I consulted no other manuscript, note, review, or literature source and ran no mathematical computation; descriptions of external checks below are the manuscripts’ reports, not checks I performed.

# 3. Per-version strong passages and points of friction

## Version A: strong passages

1. **Abstract and §1, p. 1:** The distinction between the two examples is immediately useful: full Clifford-product exclusion belongs to the ten-qudit state, whereas the six-qudit result concerns a specified preparation menu. The distance-two interpretation is also correct and explicit.
2. **Theorem 1.1 and Proposition 1.2, pp. 2–3:** The signed pairing proves the CSS dimension and distance economically. The translation family then prevents the conic construction’s parameters and cubic-weight rigidity from being mistaken for its distinctive contribution.
3. **Theorem 2.1 through Corollary 2.4, pp. 4–5:** The treatment of the radical and the use of Euler’s identity establish the unshifted Hessian-image support condition. The product ceiling applies to arbitrary pure factors, which supports the stated exclusion even after an entangling Clifford.
4. **§3 and Theorem 3.2, pp. 6–8:** Independence, uniform nonzero error labels, ideal operations, retained successes, and excluded architectures are specified. The convolution argument handles cancellations in the lower bound; the feasible upper constructions are kept distinct from menu optima.
5. **Proposition 4.1 and its proof, p. 9:** The actual-versus-projective normalization, the factor in the involution identity, and the correcting scalar coordinate change are precisely the details needed to turn a geometric exchange into a quantum-state equivalence.

## Version A: points of friction

1. **§1, p. 2; references:** Add a short explicit comparison with Bravyi–Haah. The important distinction is allowing mixed logical triple products and hence a coupled logical cubic, rather than merely reproducing independent logical cubic gates.
2. **Proposition 1.3 and Appendix A.1, pp. 3–4, 10:** The appendix gives substitutions and selected coefficient conventions, but the evaluation matrices and signs themselves reside in the cited bundle. The sentence promising that the appendix “specifies the matrices” is stronger than its actual contents.
3. **Lemma 3.1, pp. 7–8:** Explain why the coefficient vectors span: otherwise a nonzero common annihilator would have zero Hessian, contradicting the census entry N₀ = 1. This is a small but useful link in the central lower-bound proof.
4. **§3.1, pp. 6–7:** A brief explanation that the reported cost counts raw states only would help prevent the numerical advantage from being read as a total implementation-overhead advantage. The ideal-operation assumptions already delimit the theorem correctly.
5. **§4, pp. 8–9:** The conference matrix and the embedding are described but not displayed. A precise supplement entry for these small objects would make the shadow result much easier to assess without exploring an entire evidence registry.
6. **Proposition 2.2 and Appendix A.3, pp. 5, 11:** The lack of a second full p = 11 census is disclosed appropriately. Nevertheless, that census supports the strongest product-exclusion claim; a referee needs the actual archived input and execution record before unconditional acceptance.

## Version B: strong passages

1. **Theorem 1.1 and Proposition 1.2, pp. 1–3:** The trade-to-code proof and elementary translation family supply a clean mathematical foundation and an effective calibration of what the conic geometry contributes.
2. **Theorem 2.1, p. 4:** The quadratic Gauss-sum proof correctly accounts for the radical, admissible Pauli labels, and multiplicities in the entropy formula.
3. **Lemma 2.3 and Corollary 2.4, pp. 4–5:** The product obstruction is strong enough to address arbitrary bipartitions, and the text expressly declines to draw the same conclusion for the Clebsch six-qudit state.
4. **§3.1 and Theorem 3.2, pp. 5–7:** The restricted comparison is mathematically meaningful: the lower bound allows error cancellations and nonuniform choices of concatenation depth, and feasible constructions meet the same target.
5. **Appendices A.2–A.4, pp. 9–10:** Samples, exhaustive searches, independent checks, title screens, and unavailable literature coverage are distinguished. That separation is valuable even though the administrative presentation could be shortened.

## Version B: points of friction

1. **Abstract, p. 1:** The numerical factory comparison omits the input-error interval and noise/ideal-operation assumptions. They appear later, but materially condition the headline result.
2. **§1, p. 2:** Calling the coupled-cubic statement a “specialization” of signed qudit orthogonality obscures the relevant comparison: the present criterion retains stabilizer cancellation while permitting logical cross terms. A gives the more informative explanation.
3. **Lemma 3.1, p. 6:** Weighted linear-form cubic rank is not explicitly defined, including the field and the allowed nonzero coefficients. The full-span inference from N₀ = 1 is also omitted.
4. **Proposition 4.1, p. 8:** The involution’s action is asserted without specifying actual representatives of the two chordal cubics. A projective exchange is insufficient by itself to identify the phase-state Clifford.
5. **§4, pp. 7–8:** The conference cubic and invariant pencil receive too little local definition. Reusing z₀,…,z₄ for the shadow coordinates also invites confusion with the previously defined octavic coordinates.
6. **Questions suggested by the construction, p. 8:** “Stopping … beyond p = 13” suggests a broader phenomenon than the two subsequent primes tested. Appendix A.2 contains the necessary finite qualification.
7. **Appendix A.3, p. 10:** The manuscript expressly leaves an archival package and immutable public locator unfinished. Those are consequential outstanding items for results resting on finite computations.
8. **Literature pointers throughout; Appendix A.4 and references:** Ledger labels, task identifiers, and coverage-process details interrupt the mathematical positioning. The bibliography lacks author information, and neither it nor the discussion explicitly acknowledges Bravyi–Haah. These make specialist orientation harder than it needs to be.

# 4. Specialist-only checks

**I found no demonstrably false main analytic theorem in either version.** In particular, the Hessian support formula, the pure-product entropy ceiling, and the same-target comparison are consistent with their stated hypotheses. This finding does not independently verify either version’s finite census or reconstruction claims. The following statements need qualification or clarification.

1. **B, Proposition 4.1 proof, p. 8:** “The recorded involution exchanges the two chordal polynomials, giving the stated frame change.”

   The actual representatives are missing. Exchanging projective cubic classes permits a scalar multiplier, and |F⟩ generally depends on that scalar. The issue is visible in A’s explicit account: h ∘ q = 2ĥ₂, whereas exact exchange holds after choosing h₂ = h ∘ q; a different scalar coordinate change handles the normalized representative. B’s assertion can be made correct, but it needs this convention or an equivalent identity. I do not regard an unspecified projective normalization as a proof of the asserted phase-state map.

2. **B, Questions suggested by the construction, p. 8:** “It remains to explain the observed stopping of the conic translation-class source beyond p = 13, rather than merely extend a matching enumeration.”

   The recorded evidence is absence of hits at p = 17, 19 in one specified source. It establishes neither permanent stopping nor a general prime threshold. State those two tested primes and ask whether the pattern continues, as A does. This is an overbroad description of evidence, not a counterexample to a numbered theorem.

3. **Both, Proposition 1.3 finite verification, A p. 4 / B p. 3:** “Appendix A specifies the matrices and substitutions.”

   The substitutions are present, but the full matrices are delegated to the evidence index and reconstruction bundle. Replace this with an accurate pointer to the supplement’s matrices. For a computationally established proposition, distinguishing displayed input from externally supplied input matters.

4. **B, abstract, p. 1:** “For the six-qudit example over F7, a native fourteen-input factory costs fewer than 16.116 raw resources per accepted block, compared with lower bounds of 54 and 36 for two explicitly specified separate-distillation menus at the same target block infidelity.”

   As an isolated claim this lacks material hypotheses: independent uniform Z noise, ideal Clifford operations and other allowed operations, and 0 < δ ≤ 0.01. Theorem 3.2 supplies them, so the repair belongs in the abstract rather than in the theorem.

The error-detection claim is not single-error correction; a restriction of the cubic is not automatically a subcode; and a larger stabilizer Rényi entropy is not by itself a raw-input lower bound for arbitrary protocols. Both versions respect these distinctions in their substantive arguments. A additionally makes clear that sheet reversal is Clifford conjugation by coordinate negation, so gate inversion should not be interpreted as a new Clifford-inequivalent resource.

# 5. What the preferred version still lacks

I would request a focused revision and evidence inspection before accepting A.

1. **Reviewable finite evidence.** Supply a stable, precise supplement locator for the conic matrices, census inputs and outputs, shadow embedding, conference matrix, and relevant verification procedures. The reported independent small-case reconstruction is reassuring; it does not independently certify the large p = 11 execution. A second full exhaustive run is not automatically necessary, but the published claim must be supported by an inspectable computational proof record.
2. **Two short mathematical clarifications.** Add the N₀ = 1 ⇒ full-span step in Lemma 3.1, and correct the appendix’s promise about where the matrices are supplied. Keep the exact phase-representative conventions in Proposition 4.1.
3. **One concise literature clarification.** Explicitly connect Bravyi–Haah triorthogonality with the signed prime-qudit condition, then identify the coupled logical phase and its particular spectral and bounded factory consequences as the contribution. The Campbell–Howard attribution and the separation of entropy from operational cost should remain.

I would not require an unrestricted distillation lower bound, full-gate lift classification, or a new distance-three construction: those would change the scope of this companion note.
