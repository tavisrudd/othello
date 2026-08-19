# Referee audit, round three (final) — C920 Lean prose (cubic-stabilization-epilogue companion)

**Verdict: the coverage gap is genuinely closed and every round-two item was applied except one —
the `prop:low-dimensional-vanishing` cautions field still carries the old, and mis-scoped, "nonminimal
surface centers / minimal rational ruled targets" wording. Beyond that, one exported docstring
claims more than its statement, and eleven small prose nits remain. No blockers; 2 major, 11 minor.**

Range audited: `3736b643a..a74cf275c`. Whole modules re-read: `Quantum/QuarticSpectralSeparation.lean`,
`Quantum/HirzebruchEulerSpectrum.lean`, `Quantum/MonomialSpecializationSeparation.lean`,
`Applications/HirzebruchSpecializedVanishing.lean`, the appended `PaperInterface.lean` block,
`lean/verification/claims.json`, and `verification/hirzebruch_euler_spectrum.py`. Replay reverified
from `papers/cubic-stabilization-epilogue`: `--check` exits 0 with "certificate and digests agree".
The twenty-three new terminals, including `hirzebruch_degenerate_rootMultiplicity_eq_one`, are in
`verification/expected_axioms.txt` with only `propext`, `Classical.choice`, `Quot.sound`. No task
identifier, workflow reference, local path, status prose, novelty claim, or the banned "honest"
family appears anywhere in the set.

---

## (a) Verification of the round-two repairs

1. **OK — item 5, the coverage gap, is really closed, and the proofs do what the prose says.**
   `rootMultiplicity_eq_one_of_squared_linear_mul_quadratic` takes `repeated ≠ first` and
   `second ≠ first` and returns multiplicity one at `first`; both hypotheses are genuinely
   discharged at each locus. In the even case `hirzebruchEvenEuler_degenerate_rootMultiplicity_eq_one`
   derives `0 ≠ 4·fibreRoot` and `-(4·fibreRoot) ≠ 4·fibreRoot` from `fibreRoot ≠ 0`, and handles
   the second root by a `mul_comm` rewrite of the quadratic factor. In the odd case
   `hirzebruchOddEuler_degenerate_rootMultiplicity_eq_one` derives `e ≠ 0` from
   `e ^ 2 = -(2 s ^ 2)` with `s ≠ 0`, hence `10s - 16e ≠ 10s + 16e`, and reuses
   `hirzebruchOddEuler_degenerate_simple_ne` for distinctness from the repeated root. Both
   `..._degenerate_finrank_maxGenEigenspace` statements now carry four conjuncts — `≤ 2` at every
   value, `= 2` at the repeated root, `= 1` at each remaining root — each discharged through
   `LinearMap.finrank_maxGenEigenspace_eq`. The three eigenvalues are pairwise distinct as a
   by-product (the statement is self-consistent only if they are). So case (b) of
   `lem:ruled-degeneracy-dichotomy` — "exactly one double root and two simple roots, so one spectral
   block of rank two and two blocks of rank one" — is now covered, with the one residual inference
   noted at item 10 below.

2. **OK — items 6, 7, 8, 9, 10, 16 applied and correct.** The odd splitting docstring drops the word
   "simple", drops the prose surjectivity claim, and names both supporting theorems
   (`hirzebruchOddEuler_degenerate_simple_ne`, `hirzebruchOddEuler_degeneracyLocus_parametrized`);
   `finrank_maxGenEigenspace_le_one_of_quarticDiscriminant_ne_zero` now ends "The number of distinct
   eigenvalues is not part of the statement"; the phantom "with the section value nonzero" is gone
   from the parametrization docstring; `HirzebruchSpecializedVanishing` says "makes the framed regular
   monodromy unipotent" and names
   `TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.HirzebruchEulerSpectrum` by its
   module path; `MonomialSpecializationData.oddCombination_ne_zero` opens "Under the displayed
   premises" and identifies `sectionClass` as twice the shifted section class; and every splitting
   and degenerate binder is now `fibreRoot` / `sectionRoot` / `sectionScale` / `squareRoot`, with the
   docstrings using those words and an explicit "The letter `a` is reserved for the index of the
   surface".

3. **OK — items 11, 12, 13, 14 applied.** The `lem:ruled-degeneracy-dichotomy` row now lists the
   separation hypothesis and the parametrized form of the values, and its conclusion states all four
   dimension facts; `lem:hirzebruch-euler-spectrum` uses "the integer part of half the index"; the
   generator's CHECKS entry now discloses that the trace-form flag "certifies that the determinant
   does not simplify to zero, not that it is nonzero at every specialization"; and the generator is
   retitled "Euler spectrum of a specialized Hirzebruch surface" with the correct definition — "the
   general rational geometrically ruled surface; these are the minimal ones apart from `F_1`". The
   rewritten deformation paragraph (one smooth projective family joining `F_a` to `F_{a-2k}`, with
   parallel transport fixing `f` and sending `s + k f` to the negative section) is consistent with
   the `u`, `w` conventions used downstream.

4. **MAJOR — item 15 was not applied.** `lean/verification/claims.json`, row
   `prop:low-dimensional-vanishing`, cautions still reads "The manuscript now uses divisor tagging
   only for **nonminimal** surface centers; **minimal rational ruled** targets are covered by the
   direct specialized argument". The three sibling rows edited alongside it now say "the
   divisor-tagging hypothesis only for surface centers that are neither minimal nor geometrically
   ruled", so the file contradicts itself, and the contradiction falls exactly on `F_1`, which is
   nonminimal but geometrically ruled and *is* covered by the direct argument. This is also the last
   place in the artifact where the class is called "minimal rational ruled", the term the rename
   removed everywhere else. Replace with: "The manuscript now uses divisor tagging only for surface
   centers that are neither minimal nor geometrically ruled; Hirzebruch surface targets are covered
   by the direct specialized argument, whose formal content is recorded under
   prop:hirzebruch-specialized-vanishing."

5. **MINOR — item 17 applied to three of the four places.**
   `Quantum.oddCombination_ne_zero_of_monomialLeadingTerms` still says "a **monomial**
   specialization" and "a specialization with **monomial** associated graded image", where the
   structure and the two interface docstrings now say "graded-monomial". The same declaration also
   escaped the item-10 rewording: it still opens "The odd degeneracy locus is not met by a monomial
   specialization, whatever the shift", the unconditional phrasing that was fixed in its sibling.
   Give it the sibling's opening — "Under the displayed premise the odd degeneracy locus is not met
   by a graded-monomial specialization; the statement mentions no shift and no curve class" — and
   the same adjective.

---

## (b) Adversarial read: docstrings against elaborated statements

6. **MAJOR — `PaperInterface.lean`, `hirzebruch_degenerate_rootMultiplicity_eq_one`, claims more than
   the statement.** The docstring reads "The two remaining roots on each degeneracy locus are simple.
   This is the statement that composes with the multiplicity of the repeated root to give the whole
   multiplicity pattern two, one, one." The statement is the generic polynomial lemma: for arbitrary
   `repeated`, `first`, `second` with `repeated ≠ first` and `second ≠ first`, the multiplicity of
   `(X - repeated) ^ 2 (X - first) (X - second)` at `first` is one. It mentions no degeneracy locus,
   no Euler quartic and no matrix, and it treats one root, not two — the instantiations at the two
   loci are `hirzebruchEvenEuler_degenerate_rootMultiplicity_eq_one` and its odd twin, which are not
   exported through the interface. Its two sibling exports, `hirzebruch_degenerate_rootMultiplicity_le_two`
   and `_eq_two`, are carefully worded in exactly the way this one is not. Replace with: "A root of
   `(X - r) ^ 2 (X - c) (X - d)` that differs from `r` and from the other unrepeated root is simple:
   the multiplicity at `c` is one when `r ≠ c` and `d ≠ c`. No matrix occurs; the statement is about
   the polynomial. Applying it to both remaining roots of a degenerate Euler quartic is done in
   `Quantum.HirzebruchEulerSpectrum`."

7. **MINOR — `Quantum/QuarticSpectralSeparation.lean`, module header, underclaim.** The third
   paragraph still lists only the two degenerate facts that existed before this round — "no root has
   multiplicity three or more, and `r` has multiplicity exactly two" — and does not mention the new
   simplicity lemma, which is the module's contribution to the multiplicity pattern. Append: "and
   each of `c`, `d` is a simple root of that quartic when it differs from the other."

8. **MINOR — `PaperInterface.lean`, even-versus-odd asymmetry in the block-shape mirrors.**
   `hirzebruchEven_degenerate_blockShape` ends "The degenerate spectrum is one block of rank two and
   two blocks of rank one"; `hirzebruchOdd_degenerate_blockShape` stops at the dimension facts. Both
   Quantum-level originals carry the sentence. Add it to the odd mirror, or drop it from the even
   one; a referee comparing the pair will otherwise ask what is different about the odd locus.

9. **MINOR — `lean/verification/claims.json`, row `lem:ruled-degeneracy-dichotomy`, conclusion:
   spelling slip.** "It also proves that the **centerd** matrix of a rank-two block squares to zero"
   — a botched British-to-American substitution. Read "centered". It is the only occurrence in the
   audited set.

10. **MINOR — the block-count sentence rests on one standard step nothing in the closure records.**
    "The degenerate spectrum is therefore one block of rank two and two blocks of rank one" follows
    from the four proved facts only with the completeness of the generalized eigenspace decomposition
    of a complex endomorphism: dimensions `2 + 1 + 1` exhaust the rank-four space, so there are no
    further blocks. That decomposition is standard and available in Mathlib, but no statement in
    these modules invokes it, and the header's "On them the spectrum is described completely" leans
    on the same step. Add one clause, in the header and in the two block-shape docstrings: "the three
    eigenvalues account for all four dimensions, so these are all the blocks; the completeness of the
    generalized eigenspace decomposition is standard and is not restated here."

11. **MINOR — "exactly when" asserts an equivalence where one direction is formalized.**
    `hirzebruchEvenEuler_degenerate_splitting`: "the two remaining roots are `± 4 fibreRoot`, which
    differ from the repeated one, and from each other, exactly when `fibreRoot` is nonzero"; and the
    module header: "those differ from `-18 s` exactly when `s` does". Both converses are true and
    immediate, but only the forward direction is proved, and in the even case no theorem is named at
    all, unlike the odd case which points at `hirzebruchOddEuler_degenerate_simple_ne`. Say
    "differ … whenever `fibreRoot` is nonzero, which is discharged inside
    `hirzebruchEvenEuler_degenerate_rootMultiplicity_eq_one`" and leave the converse unstated.

12. **MINOR — `Quantum/HirzebruchEulerSpectrum.lean`, `hirzebruchEvenEuler_discriminant` and
    `hirzebruchOddEuler_discriminant`, not self-contained.** "Discriminant of the even quartic." is
    the whole docstring, on statements that are phrased on raw coefficient tuples rather than on
    `hirzebruchEvenEulerCharpoly`, and both are exported through interface mirrors. State the value:
    "The discriminant of the even quartic, on the coefficients of `hirzebruchEvenEulerCharpoly`:
    `2 ^ 24 u ^ 2 w ^ 2 (u - w) ^ 2`."

13. **MINOR — `Quantum/HirzebruchEulerSpectrum.lean`, the two
    `..._finrank_maxGenEigenspace_le_one` docstrings say only "every spectral block … has rank one",
    where the statement bounds each maximal generalized eigenspace by dimension one.** The reading is
    fair, since a block exists only at an eigenvalue, but the interface mirrors give both halves —
    "is at most one-dimensional: every spectral block has rank one". Align the Quantum-level pair
    with the mirrors.

14. **MINOR — `Quantum/HirzebruchEulerSpectrum.lean`, `hirzebruchEvenEuler_splitting`: "these are the
    eigenvalues of Euler multiplication in the even case".** The statement is a factorization of a
    polynomial; Euler multiplication is never constructed. The two `…EulerCharpoly` definitions each
    carry the disclaimer "Lean takes the polynomial as given and proves nothing about its geometric
    origin", and this docstring should not assert the identification without it: "these are the roots
    of the quartic the manuscript identifies with the eigenvalues of Euler multiplication".

15. **MINOR — `Quantum/MonomialSpecializationSeparation.lean`,
    `StrictNovikovAdmissible.fibre_ne_shiftedSection` and `StrictNovikovAdmissible.oddCombination_ne_zero`:
    two hypotheses go unmentioned.** Both docstrings condition only on the shift being positive; both
    statements also require the fibre class and the section class to be nonzero, which is what makes
    the lengths positive. Add "for nonzero fibre and section classes" to each.

16. **MINOR — "graded-monomial" is a term no name uses.** The structure is
    `MonomialSpecializationData`, the interface alias is `monomialSpecializationData`, the exported
    theorem is `monomialSpecialization_oddCombination_ne_zero`, and the manuscript label is
    `def:monomial-specialization`, while three docstrings now say "graded-monomial". Tie them
    together once, in the structure docstring: "the manuscript calls such a specialization monomial;
    'graded-monomial' records that the condition is imposed on the associated graded."

---

## (c) What is correct, stated plainly

17. **OK — the trust boundary is stated correctly everywhere it matters.** Each of the four module
    headers carries an explicit non-construction paragraph, and the boundaries are mutually
    consistent: `QuarticSpectralSeparation` ("`M` is an arbitrary complex matrix and its
    characteristic polynomial is a hypothesis"), `HirzebruchEulerSpectrum` ("takes those two quartics
    as given — the mathematical derivation from the presented quantum cohomology of the surface is
    not formalized", plus the explicit "Whether such a block is in fact semisimple is not proved
    here"), `MonomialSpecializationSeparation` ("Lean constructs no completed monoid ring, no
    associated graded ring, and no Novikov specialization", with both exclusion statements marked
    conditional and index zero explicitly excluded), and `HirzebruchSpecializedVanishing` ("Lean
    constructs no target variety, product, quantum connection, Novikov specialization, or
    Levelt--Turrittin decomposition"). The `claims.json` cautions agree with these, and the generator
    keeps its "What the certificate establishes / What it does not establish" pair. Items 6 and 14
    above are the only two places where a docstring reaches past its own statement, and both are
    local wording fixes rather than boundary errors.

18. **OK — names.** `hirzebruchEven*` / `hirzebruchOdd*` / `hirzebruch*` are descriptive and stable;
    no task, lane, agent, date, attempt, or status vocabulary; "index" is defined where first used;
    `a` is now reserved for the index throughout, with square roots bound as `fibreRoot` and
    `sectionRoot`. Every strength-bearing word is witnessed: `…_eulerBlocks_simple` by `finrank ≤ 1`,
    `…_degenerate_blockShape` by the four dimension conjuncts, `…_rankTwoBlock_nilpotent_sq_eq_zero`
    by the squared-centered-matrix equation, and the header declines the semisimplicity the
    certificate computes rather than claiming it.

19. **OK — everything else I looked for and did not find.** No docstring in the four modules or the
    appended interface block now understates a hypothesis or overstates a conclusion beyond items 6
    and 7; the valuation-core lemmas, the linear-independence lemma, the structure fields, the
    quadric-surface route, and the three vanishing terminals all say exactly what they prove,
    including the correct description of the supplied unipotence premise as a hypothesis rather than
    a result.
