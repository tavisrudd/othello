# Blind quantum-information referee report: X and Y

I read X first and then Y, including the complete extracted texts, appendices, and bibliographies. I also inspected rendered pages X 3 and 17 and Y 2 and 23. Page references below are PDF page numbers. I consulted no drafting history, mapping, earlier report, or external literature. Cited-source checks and literature-priority claims were **not independently checked**. This is a conceptual referee read, not an exhaustive proof certification or formal-artifact replay.

## Summary and contribution

Both papers prove that an actual product-unitary conversion between even-party stabilizer AME states has Clifford factors, for arbitrary additive prime-power stabilizers. The distinction between “some LC conversion exists” and “every factor of the supplied conversion is Clifford” is valuable. Minimum-support stabilizers expose a complete matched Weyl basis; diagonal-tensor uniqueness then supplies the exact theorem. The encoder consequence excludes non-Clifford physical factors as well as non-Clifford logical actions.

The second central contribution is quantitative: leakage-aware cleaning and Fourier concentration find local Clifford frames; a stabilizer-overlap gap selects an exact symmetry branch below an explicit radius; a balanced-cut estimate controls the collective residual. The papers carefully distinguish this global conclusion from dimension- and party-count-independent recovery of the symplectic transition data, which leaves the character correction unresolved.

Both also give a finite transition invariant, a promised-input recognition procedure, sharp minimum-support marginal determination, stochastic-conversion rigidity, and a prime-field endomorphism classification. X additionally develops optimal complementary marginal verification, weighted and nonstabilizer refinements, and an observable sufficient condition for entering the robust theorem.

## Significance and scope

The exact theorem is appealing for stabilizer entanglement and transversal gates because a substantial uniform result follows from a very short support argument. The arbitrary-additive formulation matters: the explicit Frobenius symmetry over F9 on p. 14 of both papers makes the difference from Fq-linear Clifford conventions concrete. This example should be retained.

The robust theorem is more than a continuity statement around a known symmetry: its state defect selects the discrete branch. Its explicit constants are conservative, but the separation between entry radius and subsequent collective stability is useful. The prime-field six-party restriction is another substantive result, although it is less immediately connected to gates for a reader who does not already think in endomorphism algebras.

X's verification extension has real quantum-information value. Its optimality is for fixed-support, perfectly complete binary tests with joint operations inside the selected subset. This is a meaningful model, but it is not a claim about the number of local laboratory bases or efficient implementation of those joint tests.

## Correctness and model boundaries

I found no mathematical blocker in the arguments I followed. In particular:

- The support squeeze and axis-recovery proof close cleanly (both pp. 7–9). The requirement of at least three retained tensor factors explains the Bell-pair exclusion.
- The recognition argument properly makes AME an input promise and separates fixed labels, unknown permutations, symplectic witnesses, and phase repair (both pp. 12–13). It does not establish efficient AME recognition or a uniform polynomial algorithm in local dimension.
- The cleaning proof uses scalar compression of the localized commutator, without assuming that the commutator preserves the code (X p. 24; Y p. 22). This is an important leakage distinction. The Fourier argument's character averaging addresses small root-of-unity spacings uniformly in characteristic (X pp. 24–25; Y p. 23).
- The global proof uses the two-party second moment only after obtaining local logarithms; the residual estimate separately uses AME minimum supports. Thus the nonstabilizer two-uniform appendix is not being used to claim Clifford rigidity.
- Robust transition compatibility leaves a product-Pauli ambiguity, and logical rounding removes its chosen input-leg component by a stabilizer. Neither paper silently promotes that result to global constant-radius rounding (X pp. 29–31; Y pp. 28–30).

For X's additional claims, the complementary-family direct-sum argument and the character count give the stated gap (p. 17). The one-site error gives a particularly transparent matching upper bound over the permitted tests. Appendix C's nonstabilizer argument is more demanding but coherent: each star has its own error-coordinate eigenbasis; opposite-half low-weight error sectors are orthogonal; the argument never requires projectors from different stars to commute. That last distinction deserves explicit emphasis.

X p. 31 correctly requires a product-unitary preparation promise for Clifford conclusions, while allowing arbitrary mixed states for fidelity certification. It also distinguishes a statistical upper confidence bound from a raw observed failure frequency. Both papers disclose partial formalization rather than claiming verified principal theorems (X pp. 38–40; Y pp. 35–37). I have not independently verified the formalization disclosures.

## Exposition and organization

The central mechanisms are well explained. The local Weyl-axis picture, the four-qutrit character example, and the logical-leg viewpoint speak directly to my specialty. Both introductions are nevertheless long: the elementary proof begins only after roughly six pages of setup, contribution positioning, and consequences.

Y p. 2 gives the better immediate gate-oriented narrative: exact rigidity is followed directly by factorwise transversal rigidity. X makes the robust theorem the second displayed headline and puts the encoder corollary afterward (p. 3). That better reflects the title, but slightly weakens the immediate operational payoff.

X's “Reading the paper” paragraph (p. 6) is a genuine improvement over Y's section inventory (pp. 5–6). It tells me what to skip and why. That guidance is especially necessary because Section 6 starts on X p. 22 versus Y p. 21, with its first cleaning lemma on p. 23 versus p. 22.

The new X p. 17 is dense, but it earns its space: the qutrit example returns to show exactly which tests detect the phase change that the transition maps miss. This connects verification to the paper's recurring distinction between labels and characters. Appendix C then contains the longer neighboring-subject argument, rather than inserting it into the main proof route.

## Major comments

1. **Keep a visible hierarchy of results.** Exact factorwise rigidity and robust branch recovery are the real headlines in both. Classification is their structural companion; marginal verification is an application. X largely maintains this through its reading route, but should resist further expansion of the introduction and conclusion. A short operational sentence explaining why a gate reader should care about the five-type table would help more than another list of deductions.
2. **Make X's verification-to-rigidity cost tangible.** The observable criterion is useful, but its allowed rejection probability is of order R² and is small with the stated constants. Add one numerical four-qutrit threshold, clearly identified as a conservative certified threshold, and one sentence about how a valid statistical upper bound would enter. This would distinguish a usable mathematical criterion from an implied near-term experimental protocol without undertaking a new measurement-design project.
3. **Explain the nonstabilizer extension's key distinction.** At X Appendix C, explicitly say that the two stars need not commute with each other. The error-sector orthogonality replaces a common stabilizer eigenbasis. A gate/stabilizer specialist otherwise has to infer the central reason the proof survives removal of stabilizers.

## Minor comments

- X has duplicate equation identifiers: the support count on p. 9 and verification operator on p. 17 are both (4.1); the transition equation on p. 11 and fidelity bound on p. 17 are both (4.2). The reference in Corollary 6.11 is therefore ambiguous. Fix before circulation.
- X's introduction points stochastic conversion to Section 4.2 (pp. 4–5), whereas its statement is now Section 4.4, p. 18. Y's shared Section 4.2 reference is accurate.
- Both say “replaces the former list of unrelated group orders” in Section 5 (X p. 20; Y p. 19). “Former” has no clear referent for a cold reader; explain the mathematical comparison directly.
- The repeated radius caveats are substantively correct but can be consolidated. Keep the distinction between certified radius, collective constant, and existence of asymptotic families explicit once near the theorem and once in the conclusion.

## Editorial recommendation and blind comparison

**Recommendation: publishable after minor revision, assuming the cited-source claims survive ordinary editorial verification.** The mathematical core is substantial, self-contained enough for specialist assessment, and honestly bounded. The principal remaining issues I found are presentation and cross-reference repair, not missing headline arguments.

**Overall preference: X, moderately.** Y is tighter and reaches the robust machinery slightly sooner. It loses no principal rigidity, classification, or encoder theorem relative to X. However, X's added verification theorem and observable bridge give the same support geometry another recognizable quantum-information use, and the p. 17 return to the character example improves engagement. The additional weighted/nonstabilizer results are appropriately optional. Together with the explicit reading route, that gain outweighs X's three extra total PDF pages (43 versus 40) for me.

| Criterion (1–5; higher is better) | X | Y |
|---|---:|---:|
| Specialist confidence | 4 | 4 |
| Accessibility from stabilizers/gates | 4 | 4 |
| Focus / avoidance of overload | 3 | 4 |
| Enjoyment / engagement | 4 | 3 |

Headline preservation is a tie mathematically; X slightly improves visual priority for robust rigidity, Y for transversal gates. X better serves my broader quantum-information interests; Y wins if the sole purpose is the shortest route to the rigidity proofs. The extra verification content changes my choice; it is not merely additional theorem count.

**Three highest-value edits:** (1) repair X's equation numbering and stale section references; (2) preserve its reading route while shortening repeated contribution/radius prose; (3) add one compact four-qutrit illustration of the observable threshold, with the measurement and preparation promises attached.
