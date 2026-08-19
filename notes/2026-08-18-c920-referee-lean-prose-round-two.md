# Referee audit, round two — C920 Lean prose (cubic-stabilization-epilogue companion)

**Verdict: both blockers are cleared and the substantive composition was really formalized, but
five defects remain — one true coverage gap against case (b) of the degeneracy dichotomy, and four
prose or naming residues, two of them created by the rename. No blockers; 5 major, 8 minor.**

Range audited: `3736b643a..2c030a8fc`, whole modules, same file set as round one with the two
renamed modules (`Quantum/HirzebruchEulerSpectrum.lean`,
`Applications/HirzebruchSpecializedVanishing.lean`). Replay reverified from
`papers/cubic-stabilization-epilogue`: `uv run --with sympy python3
verification/hirzebruch_euler_spectrum.py --check` exits 0 with "certificate and digests agree".
All twenty-two new terminals appear in `verification/expected_axioms.txt` with only `propext`,
`Classical.choice`, `Quot.sound`. No task identifier, workflow reference, local path, status prose,
novelty claim, or the banned "honest" family anywhere in the set.

---

## (a) Repairs verified

1. **OK — blocker 1 cleared.** `Quantum/MonomialSpecializationSeparation.lean`, field
   `MonomialSpecializationData.leadingTerm_zero` now reads "The leading term of the zero element of
   the coefficient ring vanishes", which is the field.

2. **OK — blocker 2 cleared.** The same module's header now states that both exclusion statements
   are conditional, that neither covers the surface of index zero "where the shift vanishes and the
   even locus `u = w` is compatible with the valuation law", and that index zero is settled by the
   product decomposition of the quadric surface. It also now defines `k` as the integer part of
   `a / 2`, which closes the old shift-versus-index ambiguity (round-one item 17).

3. **OK — the composition was genuinely formalized, not merely re-worded.**
   `Quantum/HirzebruchEulerSpectrum.lean` now proves, for each parity, that every root of the
   degenerate quartic has multiplicity at most two and that the repeated root has multiplicity
   exactly two (`hirzebruchEvenEuler_degenerate_rootMultiplicity_le_two` / `_eq_two`,
   `hirzebruchOddEuler_…` likewise), and carries both to eigenspace dimensions
   (`hirzebruchEvenEuler_degenerate_finrank_maxGenEigenspace`, `hirzebruchOddEuler_…`). The
   distinctness hypotheses are genuinely discharged — from `a ≠ 0` in the even case, and in the odd
   case through `hirzebruchOddEuler_degenerate_simple_ne`, which round one found proved but unused
   and which is now consumed. `hirzebruchOddEuler_degeneracyLocus_parametrized` proves the
   surjectivity of the odd parametrization that round one flagged as asserted-but-unproved. These
   discharge case (a) of `lem:ruled-degeneracy-dichotomy` in full, and case (b) except for the one
   clause in item 5 below.

4. **OK — the remaining applied items check out.** Round-one items 4, 5, 14, 15, 16, 20, 21, 22, 23,
   24, 25, 26, 27 are correctly applied; the unexplained `Circle` import is gone and the three
   surviving Mathlib imports are used; "is the identity" is replaced by "is unipotent, that is, its
   characteristic polynomial is the `rank`-th power of `X - 1`" in both vanishing docstrings; the
   claims file received items 28, 29, 30, 35 and gained an honest `"coverage": "absent"` row
   `lem:center-maps-monomial` for the geometric statement that centre specializations are monomial;
   the generator received items 31–34, and `trace_form_nondegenerate_generically` is now gated by
   `assert_all_checks_pass`.

---

## (b) Docstrings that still overclaim or underclaim

5. **MAJOR — the "two blocks of rank one" clause of case (b) is still not formalized, and three
   places assert it.** `lem:ruled-degeneracy-dichotomy` case (b) reads "`P_a` has exactly one double
   root and two simple roots, so Euler multiplication has one spectral block of rank two, whose
   nilpotent part squares to zero, and two blocks of rank one". What Lean now proves is: every
   eigenspace has dimension at most two, and the one at the repeated root has dimension exactly two.
   Nothing states that either remaining root is *simple* — there is no `rootMultiplicity … = 1`
   declaration anywhere in the closure — so "two blocks of rank one" and "exactly one double root
   and two simple roots" remain outside the formal artifact. Three texts assert it anyway:
   - `Quantum/HirzebruchEulerSpectrum.lean` header: "gives, on each locus, root multiplicities two,
     one and one, and hence … one spectral block of rank two and two of rank one";
   - `Quantum/HirzebruchEulerSpectrum.lean`, `hirzebruchEvenEuler_degenerate_finrank_maxGenEigenspace`:
     "the degenerate spectrum is one block of rank two and two blocks of rank one";
   - `PaperInterface.lean`, `hirzebruchEven_degenerate_blockShape`: the same closing sentence.

   The odd twins of both declarations correctly stop at "no maximal generalized eigenspace has
   dimension more than two and the one at the double root has dimension exactly two", and the
   `claims.json` conclusion field also stops there — so the even docstrings and the header are the
   outliers, not the standard. The fix is cheap and closes the gap rather than weakening the prose:
   add, in `Quantum/HirzebruchEulerSpectrum.lean`,

       theorem hirzebruchEvenEuler_degenerate_rootMultiplicity_eq_one
         (a : ℂ) (nonzero : a ≠ 0) :
         (hirzebruchEvenEulerCharpoly (a ^ 2) (a ^ 2)).rootMultiplicity (4 * a) = 1

   with its `-(4 * a)` companion (the two differ because `8 * a ≠ 0`), and the odd analogues at
   `10 s ± 16 e` (which differ because `e ≠ 0` follows from `e ^ 2 = -(2 s ^ 2)` and `s ≠ 0`), then
   extend the two `blockShape` statements with the two `= 1` conjuncts. Failing that, delete the
   block-count clause from the header and from both even docstrings so they match their odd twins.

6. **MAJOR — `Quantum/HirzebruchEulerSpectrum.lean`, `hirzebruchOddEuler_degenerate_splitting`, stale
   docstring.** It still says "the double eigenvalue is then `-18 s` and the two **simple**
   eigenvalues are `10 s ± 16 e`" and still asserts, in prose, "Every point of the locus with nonzero
   section value is of this form, since `s` is a sixteenth of that value." Both defects were repaired
   in the even twin (`hirzebruchEvenEuler_degenerate_splitting`, "the two remaining roots are `± 4 a`,
   which differ from the repeated one exactly when `a` is nonzero") and in the interface mirror
   `PaperInterface.hirzebruchOdd_degenerate_splitting`, so this docstring now contradicts both. The
   statement has no nonzero hypothesis, so "simple" is not witnessed, and the surjectivity claim is
   now a theorem that should be named rather than asserted. Replace with: "On the odd degeneracy
   locus, parametrized by writing the section value as `16 s` so that the fibre value is
   `-27 s ^ 2`, the quartic is a squared linear factor times a quadratic: the repeated root is
   `-18 s` and the two remaining roots are `10 s ± 16 e` for a square root `e` of `-2 s ^ 2`. They
   differ from the repeated root exactly when `s` is nonzero, which is
   `hirzebruchOddEuler_degenerate_simple_ne`; that the parametrization covers the whole locus is
   `hirzebruchOddEuler_degeneracyLocus_parametrized`."

7. **MAJOR — `Quantum/QuarticSpectralSeparation.lean`,
   `finrank_maxGenEigenspace_le_one_of_quarticDiscriminant_ne_zero`: round-one item 3 was fixed in
   the module header only.** The header now correctly says "at most one-dimensional. The count of
   four distinct eigenvalues is not formalized", but the declaration's own docstring still ends "…has
   dimension at most one: the spectral decomposition consists of four blocks of rank one", which is
   the sentence the header repair removed. Replace the colon clause with: "…has dimension at most
   one. The number of distinct eigenvalues is not part of the statement."

8. **MINOR — `Quantum/HirzebruchEulerSpectrum.lean`,
   `hirzebruchOddEuler_degeneracyLocus_parametrized`, underclaim.** The docstring says "a pair of
   specialized values on that locus, **with the section value nonzero**, is `(-(27 s ^ 2), 16 s)`",
   but the statement assumes only `256 u + 27 w ^ 2 = 0`; nonvanishing is not needed and not
   present. The interface mirror already drops the phrase. Delete "with the section value nonzero"
   here too.

9. **MINOR — `Applications/HirzebruchSpecializedVanishing.lean`, header, second route.** One
   occurrence of the old language survives the item-10 repair: "the multiplicity-one Euler block
   lemma **trivializes** the framed regular monodromy and the count vanishes". Replace "trivializes"
   with "makes the framed regular monodromy unipotent", matching the two declaration docstrings in
   the same file. While there, name the module being pointed at — "the module on the Euler spectrum
   of a Hirzebruch surface" is `Quantum.HirzebruchEulerSpectrum`.

10. **MINOR — `Quantum/MonomialSpecializationSeparation.lean`,
    `MonomialSpecializationData.oddCombination_ne_zero`.** The opening sentence "The odd degeneracy
    locus is not met by a monomial specialization" still reads unconditionally, though the following
    sentence names the premise; and `sectionClass` is never identified — for the premise
    `leadingTerm (sectionValue ^ 2) = leadingTerm (monomialImage sectionClass)` to be the intended
    one, `sectionClass` must be the class whose monomial image matches the square of the
    shifted-section value, i.e. twice the shifted section class. Open with "Under the displayed
    premises the odd degeneracy locus is not met…" and add one clause identifying `sectionClass`.

11. **MINOR — `lean/verification/claims.json`, row `lem:ruled-degeneracy-dichotomy`.** The conclusion
    field is accurate, but the cautions do not record that the "exactly one double root and two
    simple roots … and two blocks of rank one" clause of the manuscript's case (b) has no formal
    counterpart (item 5). Add: "The simplicity of the two remaining roots, and hence the count of
    two rank-one blocks in case (b), is not formalized; Lean bounds every eigenspace by dimension two
    and pins the one at the repeated root at exactly two." Separately, the hypotheses field omits
    the separation hypothesis consumed by the two `eulerBlocks_simple` declarations and does not say
    that the degenerate declarations assume the values in parametrized form (`u = a ^ 2`,
    `w = a ^ 2`; `u = -27 s ^ 2`, `w = 16 s`).

12. **MINOR — `lean/verification/claims.json`, row `lem:hirzebruch-euler-spectrum`, objects.** "the
    section class shifted by half the index in fibres" is exact only for even index; the row covers
    both quartics, and the Lean docstrings correctly say "the integer part of half the index" in the
    odd case. Use the integer-part wording for the row.

13. **MINOR — `verification/hirzebruch_euler_spectrum.py`, `check_frobenius`.** Now that
    `trace_form_nondegenerate_generically` is gated, its semantics matter:
    `sp.simplify(form.det()) != 0` is a structural comparison against the integer zero, so it fails
    only if `simplify` collapses the determinant to a literal `0`. Either say so in the CHECKS entry
    or use an explicit `sp.simplify(form.det()).is_zero is False`.

---

## (c) Defects introduced or left behind by the rename

14. **MAJOR — the rename did not reach the evidence generator, which still asserts the
    identification the rename rejected.** `verification/hirzebruch_euler_spectrum.py` opens
    "Euler spectrum of a specialized **minimal rational ruled surface**" and its first paragraph
    reads "A minimal rational ruled surface is the Hirzebruch surface `F_a = P(O + O(a))` over the
    projective line, `a >= 0`" — an explicit statement that every `F_a` with `a ≥ 0` is minimal,
    which is false at `a = 1` and is precisely the error the mathematics referee's item 4 forced the
    Lean rename to fix. The generator is part of the referee-facing artifact and is cited by name in
    the `lem:hirzebruch-euler-spectrum` cautions, so the wrong definition now stands in the one place
    a referee will check the derivation. Replace the title with "Euler spectrum of a specialized
    Hirzebruch surface" and the definition with: "The Hirzebruch surface `F_a = P(O + O(a))` over the
    projective line, `a >= 0`, is the general rational geometrically ruled surface; these are the
    minimal ones apart from `F_1`, which is the projective plane blown up at a point." That sentence
    already exists, correct, in `Quantum/HirzebruchEulerSpectrum.lean` and can be reused verbatim.

15. **MAJOR — `lean/verification/claims.json`, row `prop:low-dimensional-vanishing`, cautions:
    stale terminology and an inconsistent scope statement.** It reads "The manuscript now uses
    divisor tagging only for **nonminimal** surface centers; **minimal rational ruled** targets are
    covered by the direct specialized argument". The three sibling rows edited in the same pass
    (`thm:` framed-monodromy route, the weak-factorization telescope, and the genus-eight row) all
    now say "the divisor-tagging hypothesis only for surface centres that are neither minimal nor
    geometrically ruled". The two phrasings disagree exactly on `F_1`, which is nonminimal but
    geometrically ruled — the whole point of the rename — and "minimal rational ruled targets"
    understates the direct argument, which covers every Hirzebruch surface including `F_1`. Rewrite
    to: "The manuscript now uses divisor tagging only for surface centres that are neither minimal
    nor geometrically ruled; Hirzebruch surface targets are covered by the direct specialized
    argument, whose formal content is recorded under prop:hirzebruch-specialized-vanishing."

16. **MAJOR — symbol collision created by the header's new definition of `a`.**
    `Quantum/HirzebruchEulerSpectrum.lean` now opens "A Hirzebruch surface `F_a` … `a` is called its
    index", and then the splitting section binds `a` and `b` to square roots of the *specialized
    values*: `hirzebruchEvenEuler_splitting (a b : ℂ)`, and
    `hirzebruchEvenEuler_degenerate_splitting (a : ℂ)` whose docstring reads "the two remaining roots
    are `± 4 a`, which differ from the repeated one exactly when `a` is nonzero". A referee who has
    just read the header will read `± 4 a` as four times the index. The degenerate multiplicity and
    `finrank` declarations inherit the same `(a : ℂ)` binder. `PaperInterface.lean` already uses
    `fibreRoot` / `sectionRoot` for exactly these arguments — but its docstrings still spell the
    symbols `a`, `b` ("At `u = a ^ 2` and `w = b ^ 2` …", "the two remaining roots are `± 4 a`, where
    `a` is a square root of the common specialized value"), so the binder names and the prose names
    disagree there too. Rename the `Quantum` binders to `fibreRoot` / `sectionRoot` and update both
    sets of docstrings to use those words, keeping `a` reserved for the index throughout the closure.

17. **MINOR — terminology drift between the structure and its interface alias.**
    `Quantum.MonomialSpecializationData` and the claims label `def:monomial-specialization` say
    "monomial specialization"; `PaperInterface.monomialSpecializationData` and
    `monomialSpecialization_oddCombination_ne_zero` now say "graded-monomial specialization". Pick
    one term — "monomial specialization" matches the manuscript label and the structure name — and
    use it in all four places.

18. **OK — the new names themselves.** `hirzebruchEven*` / `hirzebruchOdd*` / `hirzebruch*` are
    descriptive, stable, free of task, lane, date, or status vocabulary, and carry no strength word
    the types do not witness: `…_eulerBlocks_simple` is backed by `finrank ≤ 1`,
    `…_degenerate_blockShape` by the pair of dimension statements (subject to item 5),
    `…_rankTwoBlock_nilpotent_sq_eq_zero` by the squared-centred-matrix equation, and the header now
    explicitly declines the semisimplicity that the certificate computes. The class statement
    "these are exactly the rational geometrically ruled surfaces, and they are the minimal ones apart
    from `F_1`, which is the projective plane blown up at a point" is correct, and the word "index"
    is now defined where it is first used. `lem:ruled-degeneracy-dichotomy` keeps "ruled" in the
    manuscript label while the declarations moved to "hirzebruch"; that is a permissible mismatch
    since the label is a stable identifier, but the row's own wording should not reintroduce
    "minimal rational ruled" (item 15).
