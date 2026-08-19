# Referee audit of the C920 Lean prose (cubic-stabilization-epilogue companion)

**Verdict: changes required before the artifact is referee-ready — 2 blockers, 11 major, 15 minor.**
No forbidden workflow vocabulary, task ID, path, status prose, novelty claim, or the banned
"honest" family appears anywhere in the audited set; the replay command works and the certificate
verifies. The defects are all of one kind: headers and docstrings that describe the *intended*
geometry as if Lean had established it, where Lean in fact proves a hypothesis-laden or purely
polynomial statement, plus one docstring that asserts the converse of its own field.

Scope audited (entire modules, not only changed lines), all under
`papers/cubic-stabilization-epilogue/`:

- `lean/TavisRuddFiniteGeom/Papers/CubicStabilizationEpilogue/Quantum/QuarticSpectralSeparation.lean`
- `lean/TavisRuddFiniteGeom/Papers/CubicStabilizationEpilogue/Quantum/MinimalRuledEulerSpectrum.lean`
- `lean/TavisRuddFiniteGeom/Papers/CubicStabilizationEpilogue/Quantum/MonomialSpecializationSeparation.lean`
- `lean/TavisRuddFiniteGeom/Papers/CubicStabilizationEpilogue/Applications/MinimalRuledSpecializedVanishing.lean`
- `lean/TavisRuddFiniteGeom/Papers/CubicStabilizationEpilogue/PaperInterface.lean` (appended terminals only)
- `lean/verification/claims.json` (five new rows, four edited)
- `verification/hirzebruch_euler_spectrum.py`

---

## Blockers

1. **BLOCKER — `Quantum/MonomialSpecializationSeparation.lean`, structure field
   `MonomialSpecializationData.leadingTerm_zero`.** The field is
   `leadingTerm_zero : leadingTerm 0 = 0`, i.e. *the zero element has vanishing leading term*.
   Its docstring says the exact converse: "Only the zero element has vanishing leading term at
   the relevant degree." A referee reading this concludes the structure supplies a separation
   property (leading term detects nonvanishing) that would make
   `ne_zero_of_leadingTerm_ne_zero` circular, and that the geometry would have to supply. The
   `claims.json` row `def:monomial-specialization` describes the field correctly, so the Lean
   docstring is the wrong one. Replace with:
   `/-- The leading term of the zero element of the coefficient ring vanishes. -/`

2. **BLOCKER — `Quantum/MonomialSpecializationSeparation.lean`, module header, sentence
   "This module proves that neither locus is met, by two arguments of different strength."**
   This is false as stated and internally inconsistent with the header's own next paragraphs.
   Every theorem in the module is conditional: the valuation route assumes `0 < shift`, and the
   leading-term route assumes a supplied `MonomialSpecializationData`, or, in the exported form,
   assumes outright that the leading term of `256 u + 27 w ^ 2` is a prescribed combination of two
   independent monomials. Worse, the two routes together do not cover the Hirzebruch surface of
   index zero: there the shift is zero *and* the relevant locus is the even one `u = w`, which is
   genuinely reachable — the tracked evidence bundle records exactly this, with
   `valuation_exclusion` index 0 marked `compatible_with_positive_length: true`. The header
   itself only claims "every index of at least two" (valuation) and "index one" (leading terms).
   Replace the opening sentence with: "This module proves two exclusion statements for those loci,
   of different strength and different scope. Neither covers the surface of index zero, where the
   shift vanishes and the even locus `u = w` is compatible with the valuation law; that case is
   settled instead by the product decomposition of the quadric surface." Then state that both
   statements are conditional and name the hypotheses.

---

## Major

3. **MAJOR — `Quantum/QuarticSpectralSeparation.lean`, module header, "so that the spectral
   decomposition of `M` consists of four blocks of rank one."** The terminal
   `finrank_maxGenEigenspace_le_one_of_quarticDiscriminant_ne_zero` proves, for each complex
   `value`, `finrank ℂ (maxGenEigenspace (toLin' operator) value) ≤ 1`. Lean nowhere counts the
   blocks, exhibits four distinct eigenvalues, or forms a decomposition. Replace with: "…forces
   every maximal generalized eigenspace of `M` to be at most one-dimensional; the count of four
   distinct eigenvalues is not formalized."

4. **MAJOR — same header, "The complementary bound is proved as well: whatever the discriminant,
   a root of a quartic that is not a fourfold root of a perfect square has multiplicity at most
   three; the statement recorded here is the sharp one needed downstream, namely that a quartic
   with exactly one repeated root has no root of multiplicity three or more."** Two defects.
   The first clause describes no declaration in the module. The second misstates the hypotheses of
   `rootMultiplicity_le_two_of_squared_linear_mul_quadratic`, which assumes only
   `first ≠ repeated` and `second ≠ repeated` — it permits `first = second`, i.e. a quartic with
   *two* double roots, so "exactly one repeated root" is not what is assumed. Replace the whole
   passage with: "The module also proves a bound valid at a degenerate quartic: if the quartic is
   `(X - r) ^ 2 (X - c) (X - d)` with `c ≠ r` and `d ≠ r` — no relation between `c` and `d` is
   assumed — then no root has multiplicity three or more, and `r` has multiplicity exactly two."

5. **MAJOR — `Quantum/QuarticSpectralSeparation.lean`,
   `rootMultiplicity_eq_two_of_squared_linear_mul_quadratic`, and the identical defect in
   `PaperInterface.lean`, `minimalRuled_degenerate_rootMultiplicity_eq_two`.** Both docstrings end
   "the degenerate specialization has one spectral block of rank two, and its remaining two blocks
   have rank one." No matrix, endomorphism, or eigenspace occurs in either statement — they are
   about `rootMultiplicity` of an explicit product of linear factors — and the "remaining two
   blocks have rank one" claim fails under the actual hypotheses when `first = second`. Replace
   both docstrings with: "The repeated factor contributes root multiplicity exactly two. Nothing
   about eigenspace dimensions is asserted here: the statement is about the polynomial, and the
   two remaining factors are not assumed distinct from each other."

6. **MAJOR — `Quantum/QuarticSpectralSeparation.lean`,
   `rootMultiplicity_le_two_of_squared_linear_mul_quadratic`, and `PaperInterface.lean`,
   `minimalRuled_degenerate_rootMultiplicity_le_two`.** The docstrings assert "Applied to a
   degenerate specialization of a minimal rational ruled surface, this excludes every spectral
   block of rank three or four" / "No spectral block of rank three or four occurs at a degenerate
   specialization". That application is never made in Lean. For the even locus it would require
   `4 a ≠ 0`, i.e. the fibre value nonzero, and no declaration supplies it; for the odd locus the
   required distinctness *is* proved as `oddRuledEuler_degenerate_simple_ne`, but that lemma is
   never used and never exported. Replace with: "A quartic of the form `(X - r) ^ 2 (X - c) (X - d)`
   with `c ≠ r` and `d ≠ r` has every root multiplicity at most two. Instantiating this at the
   degenerate Euler quartics requires the distinctness hypotheses separately; it is not carried out
   here." Alternatively, close the gap by exporting `oddRuledEuler_degenerate_simple_ne`, adding
   the even-case analogue (`4 * a ≠ 0` from a nonzero fibre value), and stating the instantiated
   corollary — which is the better fix, since the manuscript's
   `lem:ruled-degeneracy-trichotomy` case (b) asserts precisely the instantiated form.

7. **MAJOR — `Quantum/MinimalRuledEulerSpectrum.lean`, module header, final paragraph.** "In both
   cases exactly one root has multiplicity two and the other two are simple, so no spectral block
   of rank three or four occurs; … That is the complete trichotomy of block shapes for a
   specialization with `u` and `w` nonzero." Three separate overstatements. (i) "exactly one root
   has multiplicity two and the other two are simple" is not proved for either degenerate quartic:
   the splittings are proved, the generic multiplicity bounds are proved, and the two are never
   composed (see item 6). (ii) "no spectral block of rank three or four occurs" is a statement
   about a matrix; the multiplicity bounds in this closure are polynomial statements, and no
   theorem carries a `rootMultiplicity ≤ 2` bound to `finrank (maxGenEigenspace) ≤ 2`. (iii)
   "complete trichotomy" is a strength claim no declaration witnesses. Replace the paragraph with:
   "On each locus the quartic is exhibited as a squared linear factor times a quadratic. Separately,
   a quartic of that shape whose quadratic factor has both roots distinct from the repeated one is
   proved to have every root multiplicity at most two, with the repeated root of multiplicity
   exactly two, and a two-by-two complex matrix whose trace is twice and whose determinant is the
   square of one value is proved to have square-zero centred matrix. Composing these into the
   trichotomy of block shapes, and passing from root multiplicity to eigenspace dimension in the
   degenerate case, is not formalized."

8. **MAJOR — `Quantum/MinimalRuledEulerSpectrum.lean`, `evenRuledEulerCharpoly` and
   `oddRuledEulerCharpoly`.** Both docstrings open "Characteristic polynomial of Euler
   multiplication on the rank-four even cohomology of a minimal rational ruled surface of even/odd
   index, after a Novikov specialization…". These are `def`s of explicit polynomials; Lean
   constructs no surface, no quantum cohomology, and no Euler multiplication, and the identification
   is exactly what the module header disclaims. Scholarly-public docstrings must be self-contained,
   so the disclaimer has to appear here too. Replace the opening with: "The monic quartic that the
   manuscript derives as the characteristic polynomial of Euler multiplication on the rank-four even
   cohomology of a Hirzebruch surface of even/odd index, after a Novikov specialization sending the
   fibre class to `u` and the section class shifted by `⌊a/2⌋` fibres to `w`. Lean takes the
   polynomial as given and proves nothing about its geometric origin."

9. **MAJOR — `Quantum/MinimalRuledEulerSpectrum.lean`, `oddRuledEuler_degenerate_splitting`,
   final sentence "Every point of the locus with nonzero section value is of this form, since `s`
   is a sixteenth of that value."** This surjectivity of the parametrization is load-bearing (it is
   what makes the locus analysis exhaustive rather than a sample) and is asserted as fact while
   being proved nowhere. Either prove it — it is one line, `s := w / 16` — or mark it: "The
   parametrization covers the whole locus, since `s = w / 16` recovers the section value; that
   surjectivity is not formalized."

10. **MAJOR — `Applications/MinimalRuledSpecializedVanishing.lean`,
    `quadricSurface_specialized_sixthMultiplicity_eq_zero`, and the same wording in
    `PaperInterface.lean`, `minimalRuled_quadricSurface_sixthMultiplicity_eq_zero` and in the
    module header ("its framed regular monodromy is the identity; tensoring two trivial framed
    operators leaves a trivial framed operator").** The supplied hypothesis is
    `product.operator.charpoly = (X - C 1) ^ product.rank`, i.e. the framed monodromy is
    *unipotent*; it does not say the operator is the identity, and the proof only needs
    unipotence. Describing a hypothesis as stronger than it is misleads a referee about what the
    manuscript must supply. Replace every occurrence of "the framed monodromy … is the identity"
    with "the framed monodromy … is unipotent, that is, its characteristic polynomial is
    `(X - 1) ^ rank`".

11. **MAJOR — `Applications/MinimalRuledSpecializedVanishing.lean`, module header, "The second
    route is the discriminant of the rank-four Euler spectrum, and it applies to every Hirzebruch
    surface."** Both discriminant terminals require the separation hypothesis (`u ≠ w`, resp.
    `256 u + 27 w ^ 2 ≠ 0`) as well as `u ≠ 0` and `w ≠ 0`; the route does not apply on the
    degeneracy locus, which is the entire reason the first route and the separation module exist.
    Replace with: "…and it applies to every Hirzebruch surface at a specialization with both values
    nonzero that avoids the degeneracy locus of the discriminant."

12. **MAJOR — `lean/verification/claims.json`, row `prop:low-dimensional-vanishing`, "hypotheses"
    field.** The edit now reads "divisor tagging transfers intrinsic vanishing to each **monomial**
    strictly Novikov-admissible specialization". The registered declaration's premise is the field
    `LowDimensionalVanishingInput.specializationVanishing`, which quantifies over *every* strictly
    Novikov-admissible specialization with no monomial qualifier, and the terminal
    `lowDimensionalVanishing_of_classification_and_specialization_inputs` concludes for
    `∀ specialization, geometry.isStrictlyNovikovAdmissible object specialization → …`. The
    "hypotheses" field must describe the declaration, not the manuscript; the row's own "cautions"
    already says "The Lean statement retains divisor tagging as one typed premise … and does not
    distinguish the two cases", which contradicts the edited hypotheses line. Restore "to each
    strictly Novikov-admissible specialization" and leave the manuscript's narrowing to the
    cautions field.

13. **MAJOR — `lean/verification/claims.json`, row `lem:ruled-degeneracy-trichotomy`, "conclusion"
    and "cautions".** The conclusion asserts "that on them the quartic is a squared linear factor
    times a quadratic **with two roots distinct from the repeated one, so that** the repeated root
    has multiplicity exactly two and no root has multiplicity three or more". The distinctness is
    a *hypothesis* of `minimalRuled_degenerate_rootMultiplicity_le_two` and
    `..._eq_two`, and it is discharged for neither degenerate quartic (see item 6); the "so that"
    composition is not performed in Lean. The cautions mention only that the supplied matrix is not
    proved to be Euler multiplication, and so understate what is unformalized. Rewrite the
    conclusion to list the pieces without the composition, and add to cautions: "The two degenerate
    splittings and the multiplicity bounds are separate statements: Lean does not prove that the
    quadratic factors of the two degenerate Euler quartics have roots distinct from the repeated
    one, so the instantiated case (b) of the manuscript's trichotomy — one rank-two block and two
    rank-one blocks — is not assembled formally. Nor is any bound on `rootMultiplicity` carried to
    a bound on the dimension of a maximal generalized eigenspace in the degenerate case; the
    identification is registered only off the degeneracy locus."

---

## Minor

14. **MINOR — `Quantum/QuarticSpectralSeparation.lean`, `monicQuartic`.** "constant coefficient
    `l₀` and leading coefficients `l₁, l₂, l₃`" — a monic quartic has leading coefficient one.
    Replace with: "The monic quartic `X ^ 4 + l₃ X ^ 3 + l₂ X ^ 2 + l₁ X + l₀`, with coefficients
    listed in ascending degree."

15. **MINOR — `Quantum/QuarticSpectralSeparation.lean`,
    `monicQuartic_discriminant_eq_squared_root_differences`.** The docstring reports only the
    discriminant identity; the statement additionally produces the four linear factors and the
    equality of the root multiset with `{r₀, r₁, r₂, r₃}`, both of which downstream proofs consume.
    Add: "…and exhibits the quartic as the product of the four corresponding linear factors, with
    root multiset `{r₀, r₁, r₂, r₃}`."

16. **MINOR — `Quantum/QuarticSpectralSeparation.lean`, module header.** The namespace is
    `Quantum` and the header ends "Lean constructs no quantum connection and no Euler multiplication
    here" — good — but nothing says what the namespace collects. Add one clause to the header's
    scope sentence: "The module sits in the `Quantum` namespace, which collects the linear-algebraic
    facts the manuscript's quantum-connection arguments consume; none of them mentions a connection."

17. **MINOR — `Quantum/MinimalRuledEulerSpectrum.lean` and downstream, the word "index".** The
    header introduces the Hirzebruch surface as `F_a` and displays "even `a`" / "odd `a`", then all
    declaration docstrings say "of even index" / "of odd index" without ever saying that "index"
    means `a`. Also, `w` is described as the section class "shifted by `a / 2` fibres" here, while
    `MonomialSpecializationSeparation.lean` calls the shift `k` and the generator calls it
    `k = a // 2`; the truncation is never stated in Lean. Add to the header: "We call `a` the index
    of `F_a`, and write `k = ⌊a/2⌋` for the shift, so that `w` is the specialized value of
    `s + k f`."

18. **MINOR — `Quantum/MinimalRuledEulerSpectrum.lean`, `evenRuledEuler_splitting`.** "The four
    eigenvalues of Euler multiplication in the even case are `2 (± a ± b)`" — the statement is a
    factorization of the quartic at `u = a ^ 2`, `w = b ^ 2`, and the four values need not be
    distinct. Replace with: "At `u = a ^ 2` and `w = b ^ 2` the even quartic is the product of the
    four linear factors with roots `2 (± a ± b)`; these need not be distinct."

19. **MINOR — `Quantum/MinimalRuledEulerSpectrum.lean`, `evenRuledEuler_degenerate_splitting`, and
    `PaperInterface.lean`, `minimalRuledEven_degenerate_splitting`.** "the two simple eigenvalues
    are the square roots of `16 u`" — nothing in the statement makes `± 4 a` simple or distinct from
    the double root `0`; that needs `a ≠ 0`. Replace "the two simple eigenvalues" with "the two
    remaining roots are `± 4 a`, which differ from the double root exactly when `a ≠ 0`".

20. **MINOR — `Quantum/MinimalRuledEulerSpectrum.lean`, `rankTwo_centered_sq_eq_zero`, closing
    sentence "Together with the exclusion of blocks of rank three and four, this completes the
    trichotomy of block shapes for a degenerate specialization."** Same strength claim as item 7;
    delete the sentence, keeping the mathematical content of the docstring, which is accurate.

21. **MINOR — `Quantum/MonomialSpecializationSeparation.lean`, header, "It uses that the
    specializations produced by the blowup comparison are monomial".** "The blowup comparison" is
    named without being identified, and this module never sees it. Replace with a description of the
    property actually used: "It uses only that the specialization has a leading-term map whose image
    on every effective class lies in a fixed linearly independent family."

22. **MINOR — `Quantum/MonomialSpecializationSeparation.lean`,
    `MonomialSpecializationData.oddCombination_ne_zero`, "which holds exactly when those summands
    have equal valuation".** Equal valuation is necessary, not sufficient — the leading terms can
    cancel, in which case the additivity hypothesis fails. Replace "holds exactly when" with "can
    hold only when".

23. **MINOR — `Quantum/MonomialSpecializationSeparation.lean`, import
    `Mathlib.Analysis.SpecialFunctions.Complex.Circle`.** Nothing in the module uses circle-valued
    special functions; an unexplained heavy import in a referee-facing module invites the question of
    what it is for. Drop it, or say in the header why it is needed.

24. **MINOR — `PaperInterface.lean`, `minimalRuledOdd_eulerSpectrum_discriminant`.** The docstring
    reads "…of odd index: `- u ^ 2 w ^ 2 (256 u + 27 w ^ 2) ^ 3`" and defines neither `u` nor `w`
    nor the trust boundary, relying on the immediately preceding declaration's docstring. Repeat the
    two definitions and the "Lean does not construct quantum cohomology" clause, as the even
    declaration does.

25. **MINOR — `PaperInterface.lean`, `monomialSpecializationData`.** Two problems: "type of
    monomial-specialization **certificates**" suggests something Lean checks, whereas the structure
    is assumed data; and "in the form its consumers use" is inaccurate, since no registered terminal
    consumes this alias — `monomialSpecialization_oddCombination_ne_zero` goes through
    `oddCombination_ne_zero_of_monomialLeadingTerms` directly. Replace with: "Reviewer-facing name
    for the bundle of leading-term data a monomial specialization must supply: a leading-term map,
    a linearly independent family of monomials, and a leading term in that family for every
    effective class. Nothing here is verified by Lean; the bundle is a hypothesis."

26. **MINOR — `PaperInterface.lean`, `monomialSpecialization_oddCombination_ne_zero`, "whatever the
    shift".** The statement has no shift parameter and no curve classes at all. Replace with: "The
    argument is independent of any shift, since no curve class enters the statement."

27. **MINOR — `PaperInterface.lean`, `centerSpecialization_fibre_ne_shiftedSection` and
    `centerSpecialization_oddCombination_ne_zero`.** The `centerSpecialization` prefix is not
    explained in either docstring; a referee cannot tell that "center" means a blowup center of the
    weak-factorization chain. Add a first clause: "For a specialization attached to a blowup center,
    …" — or rename to `strictNovikov_…` if the declarations are in fact about any strictly
    Novikov-admissible specialization, which is what their types say.

28. **MINOR — `lean/verification/claims.json`, row `lem:minimal-ruled-euler-spectrum`, cautions.**
    "The symbolic derivation of the quartics from the presented ring, together with its
    cross-checks, is the registered evidence bundle." Name it exactly, as the enduring-artifact rule
    requires: "…is the registered evidence bundle `hirzebruch-euler-spectrum`, generated by
    `verification/hirzebruch_euler_spectrum.py` and recorded in
    `verification/hirzebruch-euler-spectrum.json`."

29. **MINOR — `lean/verification/claims.json`, row `lem:center-specialization-nondegenerate`,
    conclusion.** "For a vanishing shift it proves instead that a combination of two members of a
    linearly independent family … cannot vanish" — the third registered declaration carries no
    shift, and the proof needs both that the first coefficient is nonzero and that the two
    coefficients sum to a nonzero number. Replace with: "Independently of any shift, it proves that
    a combination of two members of a linearly independent family with coefficients two hundred
    fifty-six and twenty-seven cannot vanish, since for distinct members independence forces the
    first coefficient to vanish and for a common member the nonzero coefficient sum does."

30. **MINOR — `lean/verification/claims.json`, row `prop:minimal-ruled-specialized-vanishing`,
    hypotheses, "the surface of positive index has nondegenerate discriminant".** No registered
    declaration has an index parameter, and the even statement covers index zero as well as any
    other even index. Replace with: "the even or odd separation hypothesis holds — the two values
    differ, respectively the quadratic `256 u + 27 w ^ 2` is nonzero".

31. **MINOR — `verification/hirzebruch_euler_spectrum.py`, `check_frobenius`.** `euler_selfadjoint`
    is very close to vacuous: as the function's own comment says, "a multiplication operator is
    always self-adjoint for it", so the recorded flag is true for any commutative presentation
    whatsoever and tests only that `multiplication_matrix` and the local `operator` helper agree.
    Separately, `trace_form_nondegenerate_generically` is recorded but never gated by
    `assert_all_checks_pass`. Relabel the CHECKS entry as what it is — "a self-consistency check of
    the multiplication matrix; self-adjointness for the trace form holds for any commutative
    presentation" — and either gate the nondegeneracy flag or drop it from the certificate.

32. **MINOR — `verification/hirzebruch_euler_spectrum.py`, `check_homogeneity`.** It is called once
    per index over `INDICES = range(0, 13)`, but `characteristic_polynomial(parity)` depends only on
    the parity, so thirteen rows record two distinct computations. A referee counting rows will
    overestimate the evidence. Either iterate over parities and say so, or add a note to the CHECKS
    entry: "recorded per index for uniformity, though the quartic depends on `a` only through its
    parity."

33. **MINOR — `verification/hirzebruch_euler_spectrum.py`, CHECKS entry `degeneracy`.** It reads
    "for u, w nonzero the quartic has either four simple roots or exactly one double root, and at a
    double root the matrix of Euler multiplication is semisimple", but `check_degeneracy` evaluates
    only at the generic point of the locus (`w := u`, respectively `u := -27 w ^ 2 / 256`); the
    four-simple-roots alternative off the locus is established by the discriminant, not by this
    check. Reword to: "on the degeneracy locus the quartic has root multiplicities `1, 1, 2` and the
    matrix of Euler multiplication is semisimple at the double root; the simplicity of the spectrum
    off the locus follows from the recorded discriminant."

34. **MINOR — `verification/hirzebruch_euler_spectrum.py`, replay block.** The two commands use the
    relative path `verification/hirzebruch_euler_spectrum.py` without saying from which directory.
    Prefix with the working directory: "From the paper directory
    `papers/cubic-stabilization-epilogue`:". (Verified working: `--check` exits 0 with "certificate
    and digests agree" in about one second and leaves the tree unchanged.)

35. **MINOR — cross-artifact, worth one sentence somewhere.** The certificate records the stronger
    fact that the rank-two block at the degeneracy locus is *semisimple*
    (`semisimple_at_double_root`, `nilpotent_part_vanishes`), while the Lean side and the manuscript
    record only that its nilpotent part squares to zero. That is not an inconsistency, but the
    `lem:ruled-degeneracy-trichotomy` cautions field should say which of the two the formal artifact
    supports, so a referee does not read the computed semisimplicity back into the Lean statement.

---

## Confirmed clean

36. **OK — forbidden content.** No `honest`/`honestly`/`honesty`, no `C<id>` task identifier or
    spelling variant, no lane, agent, model, session, handoff, queue, note, or report reference, no
    local filesystem path or private URL, no `TODO`/`FIXME`, no "future work", "for now",
    "remaining seam", "pending", "temporary", or other status prose, and no novelty or priority
    claim, in any of the four new modules, the appended `PaperInterface` block, `claims.json`, or
    the generator. Checked by reading plus a targeted grep over the exact file set.

37. **OK — names.** No declaration, namespace, or filename encodes a task, date, lane, attempt, or
    status. `minimalRuled…` is used for "minimal rational ruled surface", and three of the four
    module headers open by defining the term as a Hirzebruch surface `P(O + O(a))` over the
    projective line, so the standard-terminology reading is available to a cold reader.
    (`MonomialSpecializationSeparation.lean` uses the term in its title and first line without the
    gloss; adding the one-clause definition there, as item 17 already requires for the index, closes
    the last gap.) `…_eulerBlocks_simple` and `…_le_one` are witnessed by their types;
    `rankTwo_centered_sq_eq_zero` says exactly what it proves.

38. **OK — trust boundary, where it is stated.** Each of the four module headers carries an explicit
    "Lean constructs no …" paragraph naming the geometric objects that are not built (quantum
    connection, Euler multiplication, completed monoid ring, associated graded ring, Novikov
    specialization, target variety, product, Levelt–Turrittin decomposition). The generator's
    docstring has a matching "What the certificate establishes / What it does not establish" pair
    that correctly places the deformation reduction and the toric presentation outside the
    computation. The defects above are that individual docstrings do not inherit these disclaimers,
    not that the disclaimers are missing.

39. **OK — evidence generator, non-vacuity of the substantive checks.** `presentation` genuinely
    constrains the ring (it recovers `S.S = -a` and the anticanonical class from the deformed
    relations at `u = w = 0`), `elimination` recomputes the quartic by a lex Gröbner elimination
    independent of the multiplication matrix, `discriminant` recomputes it by an explicit splitting
    in the even case and by a resultant with the parametrizing quartic `t^4 + w t^3 - u w^2` in the
    odd case, `gromov_witten` reconstructs the `F_2` relations from the point invariants
    `⟨pt⟩_f = ⟨pt⟩_{f+s} = 1`, and `valuation_exclusion` records a condition that is genuinely
    satisfiable at indices zero and one and genuinely unsatisfiable from index two upward — which is
    what makes the index-zero coverage gap of item 2 visible. `assert_all_checks_pass` fails loudly
    on each of these. Only `frobenius` (item 31) is near-vacuous.

40. **OK — manuscript labels.** All five new `manuscript_label` values resolve to real `\label`s:
    `def:monomial-specialization` (line 763), `lem:minimal-ruled-euler-spectrum` (786),
    `lem:ruled-degeneracy-trichotomy` (900), `lem:center-specialization-nondegenerate` (945), and
    `prop:minimal-ruled-specialized-vanishing` (980), all in `sections/05-framed-monodromy.tex`.
    All nineteen newly registered declarations appear in `verification/expected_axioms.txt` with the
    ordinary `propext, Classical.choice, Quot.sound` closure and no additional axiom.
