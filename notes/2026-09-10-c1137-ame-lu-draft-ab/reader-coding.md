# Blind A/B referee report — coding-theory reader

**Preference: X, narrowly. Editorial recommendation: minor revision for either version; X is the better submission base.** No fatal mathematical defect emerged from this read. My perspective is finite-field/MDS/stabilizer algebra, with less prior familiarity with verification protocols and quantitative operator estimates.

## Summary and contribution

Both versions prove that every individual factor of an LU conversion between even-party stabilizer AME states is Clifford, for arbitrary additive prime-power stabilizers. The support-count argument is short and convincing: minimum-support label groups project bijectively onto every participating Weyl plane, and the resulting diagonal correlation tensor recovers its axes. The finite recognition algorithm, phase repair, encoder conversion result, and prime-field endomorphism algebra turn this into concrete coding-theoretic information. The separate robust theorem rounds an approximate symmetry to an exact Clifford branch at an explicit radius, then controls the collective residual.

X additionally develops complementary marginal verification, its optimal gap under a specified support restriction, weighted/limited-test variants, a nonstabilizer AME extension, and a measured-probability sufficient condition for rounding. These additions connect an abstract state-vector defect to observable constraints without changing the main rigidity claims.

## Significance and scope

The arbitrary-additive qualification is substantive. The F9 Frobenius symmetry in both versions, p. 14, is an excellent demonstration of what restricting to SL2(Fq) would miss. I particularly value the small recognition witness, the distinction between labels and character, and the algebra-to-code dictionary. The nonscalar endomorphism theorem for four and six parties is an attractive independent consequence (X pp. 21–22; Y pp. 20–21).

The quantitative contribution also appears meaningful, although its novelty relative to the cited literature is outside this review. Both versions carefully distinguish exact-code approximate implementation from approximate error correction, and a certified radius from an optimal radius. Fixed-label polynomial complexity has the necessary fixed-q and AME-promise qualifications. The account does not quietly charge character repair or unknown permutations to the same complexity claim.

X's added verification results fit the support-geometry theme. They are not necessary for exact classification, but the passage from character syndromes to a fidelity bound is short enough to earn its place. The universal AME extension is mathematically interesting yet less central; its appendix placement is appropriate.

## Correctness and red-team assessment

I checked the exact support and axis arguments, systematic block criterion and complementary-block argument, propagation around fundamental cycles, phase repair, five algebra types, module interpretations, low-party theorem, and the quantitative chain. I also examined every added verification proof in X. I found no counterexample or unresolved proof gap that blocks publication.

Specific checks:

- **Low-party algebra (X p. 22; Y pp. 20–21):** the non-symplectic normalization does require transported weights. Those weights are retained, and the inverse identity supplies the reciprocal domain weights in row orthogonality. The first row and column relations indeed put B, C, D in span{I,A}; passing to inverse holonomies preserves commutativity. The q≥5 qualification on noncentral symmetries is justified.
- **Module table (X pp. 21, 32–33; Y pp. 19, 31):** the split, field, and dual-number descriptions follow from faithful local modules and half-set bijectivity. The Hermitian argument uses isotropy after multiplication by every extension-field scalar, which is the necessary strengthening beyond trace orthogonality. Characteristic two is covered. “Five types” means an exhaustive list of possibilities, not demonstrated occurrence of all rows.
- **Robust rounding (X pp. 23–30; Y pp. 22–29):** scalar compression in cleaning does not assume the localized commutator preserves the code. The Fourier concentration bound really yields distance η, since the maximal Weyl amplitude is at least 1−η²/2. Additivity plus averaging over prime-field multiples avoids a characteristic-dependent root-separation bound. I checked the residual proof's separate m=2 estimate and the branch-selection inequalities. The unresolved character correction is explicitly retained, rather than being silently promoted to an exact nearby symmetry.
- **Complementary tests (X pp. 16–17):** any m selected label groups are independent; a nontrivial character therefore fails at least m+1 of the 2m tests. Characters annihilating prescribed m−1 groups give sharpness. The upper bound for arbitrary permitted effects follows from a traceless one-site unitary error and average support incidence, not an assumption that all permitted tests are stabilizer projectors.
- **Weighted and universal variants (X pp. 37–38):** the heaviest-test annihilator argument proves the finite-test upper bound in the stabilizer case. For the nonstabilizer result, the two stars need not commute with each other. The proof instead makes their low-rejection spectral spaces orthogonal using disjoint-half errors of total support at most m. Summing the resulting projection inequalities proves the bound without the invalid cross-star commutativity assumption. This is the most delicate added argument, and it survived my check.
- **Measurement hypotheses (X pp. 16–17, 31, 37):** each test has one fixed support of at most m+1 parties on one copy; joint operations within that support are allowed. A binary test is not a laboratory measurement setting. The rounding corollary assumes an exact product-unitary image and a valid upper bound on rejection probability. It makes neither a device-independent claim nor a Clifford conclusion for arbitrary mixed preparations. The conversion from fidelity to phase-optimized defect and its strict threshold are correct.

## Exposition and organization

Both introductions keep the headline results visible. X gives the quantitative theorem priority as Theorem 1.2 before the encoder corollary (pp. 2–3); Y inserts the encoder consequence between exact and quantitative rigidity (pp. 2–3). As a coding reader I enjoy Y's immediate encoder payoff, but X's ordering better matches the title and promised two-theorem story.

X's explicit reading route on p. 6 is a real improvement over Y's section inventory on pp. 5–6. It tells me how to read the two proofs without traversing every application. The four-qutrit example, present in both, then supports X's character-detecting tests on p. 17. Consequently the verification addition did not feel like unrelated material I had to learn before understanding rigidity.

There is still a cost: the robust section begins on X p. 22 versus Y p. 21, and the main text ends on X p. 32 versus Y p. 31. Both remain long for the elementary exact theorem, and both introductions spend substantial space cataloguing neighboring work. X earns its modest extra main-text length; the optional appendix carries the more specialized extension.

## Major comments / three most valuable improvements

1. **Preserve X's main-result ordering and reading route, but make the route executable.** At the end of the exact proof (p. 9), add a direct pointer to Section 6 for readers pursuing robustness. The current intervening classification/application sections remain tempting to treat as prerequisites despite the introduction's instructions.
2. **Explain the added universal proof with one short bridge.** On X p. 38 explicitly say that the opposite stars generally do not commute, and that orthogonality of their low-rejection subspaces replaces simultaneous diagonalization. This would save a coding specialist from trying to extend the character-eigenbasis proof mechanically.
3. **Repair numbering and cross-references before submission.** X p. 17 reuses equation numbers (4.1) and (4.2), already assigned to the support formula on p. 9 and transition equation on p. 11. “Equation (4.2)” in Corollary 6.11 (p. 31) is therefore ambiguous. X pp. 4–5 also still direct stochastic conversion to Section 4.2 although its section is 4.4. These are concrete editorial errors, not theorem failures.

## Minor comments

Define the unnormalized Frobenius norm explicitly when it first appears in the headline bound, distinguishing it from normalized Hilbert–Schmidt distance. A coding reader can infer the convention, but the factor sqrt(q) makes inference unnecessary risk. In both versions, “former list” in the paragraph after Theorem 5.1 refers to revision history unavailable to the reader; replace it with an intrinsic description. In X, “optimal number of tests” should continue to travel with its support/effect model whenever summarized; the existing explicit distinction from measurement settings is worth retaining.

## Scores and recommendation

Scores are 1–5, with 5 best; confidence means confidence earned by this reading, not a formal correctness certificate.

| Criterion | X | Y |
|---|---:|---:|
| Specialist confidence | 4 | 4 |
| Cross-specialty accessibility | 4 | 3 |
| Focus | 4 | 4 |
| Enjoyment | 4 | 4 |

I prefer **X** because its stronger navigation and operational bridge compensate for its extra material. Y remains a credible, slightly leaner paper; the preference is not based on a correctness defect in Y. I recommend acceptance after minor revision, particularly X's numbering repairs.

**Reading disclosure:** I read X first, then Y, each complete extracted text including appendices and references. I visually inspected X pp. 3, 17, 22, 24, 31, 37, 38 and Y pp. 3, 20, 23. Proof checking was deepest in finite-field algebra and the changed verification statements; the analytic chain was checked on paper, not mechanized. Citations and novelty claims were not independently audited, and no formal artifact was replayed. I did not consult manuscript history, other reviews, or an A/B mapping. A file listing incidentally exposed timestamps; I did not use them to assign chronology or preference.

**Closeout (ej + tt):** the useful extra insight is the common “half-set coordinates” mechanism behind recognition, phase repair, and testing. X makes that unity more visible. No new task-owned theorem is proposed. The remaining mathematical mystery is the stated character/branch-selection obstruction; this review neither resolves it nor finds evidence that it is misstated.
