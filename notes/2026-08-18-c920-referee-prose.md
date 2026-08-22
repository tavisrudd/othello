# C920 referee report: exposition, style, internal consistency

**Scope**: `git diff 3736b643a..b4d416a62 -- papers/cubic-stabilization-m1/sections
papers/cubic-stabilization-m1/cubic_stabilization_m1.tex
papers/cubic-stabilization-m1/verification`. Prose, style-guide compliance, internal
consistency, cross-references, bibliography, registry prose. Mathematical correctness is
another referee's charge; where a wording problem is entangled with a mathematical claim I
say so and stop at the wording.

**Verdict**: Accept after revision. The new argument is genuinely well shaped — the two-fact
roadmap, the reduction to `a ≤ 1`, the discriminant trichotomy and the valuation argument
read cleanly and a qualified reader can follow them cold. But there is one hard production
defect (a duplicated equation tag `5.6`), one brittle cross-reference by paragraph position,
one garbled sentence at a load-bearing citation, a mismatch between the newly required
monomiality hypothesis and every scope sentence that advertises the result, and a roadmap
that names one mechanism where the proof uses two. Fix items 1–6 before circulation; 7–20
are polish.

---

1. **MAJOR — equation tag `5.6` is used twice.** `sections/05-framed-monodromy.tex:810` now
   carries

   ```
    \tag{5.6}
    \label{eq:ruled-euler-quartic}
   ```

   and line 1081 still carries

   ```
    \tag{5.6}
    \label{eq:divisor-tagging-map}
   ```

   Two distinct displays render as "(5.6)", and because the new one comes first the older
   divisor-tagging map is now also numerically out of sequence with (5.5) at line 597 and
   (5.7) at line 1163. Any reader who follows a printed "(5.6)" lands on the wrong display.
   Fix: give the new quartic `\tag{5.5a}` and the discriminant `\tag{5.5b}`, leaving
   `eq:divisor-tagging-map` at `5.6`; or renumber `eq:divisor-tagging-map` to `5.6b`. (The
   style guide's stated preference, "Do not hard-code equation numbers with `\tag`", would
   remove the whole class of collision; the manuscript has already committed to manual tags
   throughout, so I do not ask for that here, only for the collision to go.)

   Everything else in item 4 of the brief checks out: no `\label` in `sections/` or
   `cubic_stabilization_m1.tex` is defined twice, and every `\ref`/`\eqref` target in
   the paper — including the new `eq:center-novikov-specialization`,
   `eq:strict-novikov-valuation`, `eq:blowup-nu`, `lem:simple-euler-block`,
   `def:strict-novikov-admissible` and `prop:direct-specialized-lowdim`, whose part (ii) is
   indeed the `\PP^1`/`\PP^2` case — resolves to a real label. Tag `5.6a` is unique.

2. **MAJOR — a load-bearing claim is cited by paragraph position, not by label.** The proof
   of `thm:nu6-birational-invariance` now says

   > "and the paragraph after Definition~\ref{def:monomial-specialization} shows that it is
   > monomial."

   The claim that every center specialization is monomial is a premise of the birational
   invariance theorem, and it is reachable only by counting paragraphs. This is exactly the
   brittleness the style guide warns about ("Give every theorem-like statement a stable
   semantic identifier … Rendered numbers are presentation output"). Fix: promote the
   paragraph beginning "The center maps \eqref{eq:center-novikov-specialization} are
   monomial." into a labelled lemma, e.g.

   ```latex
   \begin{lemma}[Center specializations are monomial]
   \label{lem:center-maps-monomial}
   The specializations \eqref{eq:center-novikov-specialization} are monomial in the sense of
   Definition~\ref{def:monomial-specialization}.
   \end{lemma}
   ```

   with the present two sentences as its proof, and change the theorem proof to "and
   Lemma~\ref{lem:center-maps-monomial} shows that it is monomial."

3. **MAJOR — the monomiality hypothesis is invisible in every scope sentence that advertises
   the result.** `prop:low-dimensional-vanishing` now reads "For every **monomial** strictly
   Novikov-admissible specialization \(\chi\)", but none of the four places that state the
   scope of the result mentions monomiality: the section 5 opening ("We prove specialized
   low-dimensional vanishing directly, without Hypothesis~5.7T, for nef-canonical targets,
   for \(\PP^1\) and \(\PP^2\), for every minimal rational ruled surface"), the introduction
   roadmap, the introduction's conditional-invariance sentence, and section 6. A reader who
   compares the section opening with the proposition finds a hypothesis appearing from
   nowhere. Fix: add one clause at the section 5 opening and one in the introduction, e.g.
   after "for every minimal rational ruled surface" insert

   > "(for the odd surface \(F_1\), on specializations that are monomial in the sense of
   > Definition~\ref{def:monomial-specialization}, as every center specialization is)"

   and mirror it once in the introduction. Do not repeat it in section 6.

4. **MAJOR — related: the blanket monomiality hypothesis over-restricts
   `prop:low-dimensional-vanishing`.** The proof itself says "monomiality of \(\chi\) is
   used only there, and only when the surface is \(F_1\)", yet the statement imposes it on
   points, curves, `\PP^2` and every nef-canonical surface as well, silently weakening
   claims the paper previously made unconditionally. Fix: state (5.7) for every strictly
   Novikov-admissible \(\chi\), adding "monomial if \(T\) is a minimal rational ruled
   surface of odd index" as the localized condition; the proof text already justifies that
   placement verbatim.

5. **MAJOR — garbled sentence at the Batyrev/Givental citation.** Line 866:

   > "For \(F_1\), which is Fano, the toric quantum Stanley--Reisner presentation
   > \cite[Section~5]{Batyrev}, **a theorem by the mirror theorem for Fano toric manifolds**
   > \cite[Theorem~0.1]{Givental}, gives"

   "a theorem by the mirror theorem" does not parse, and it also obscures the division of
   credit that `imported-sources.json` records (Batyrev presents, Givental proves).
   Replace with:

   > "For \(F_1\), which is Fano, the toric quantum Stanley--Reisner presentation of
   > \cite[Section~5]{Batyrev} — established for Fano toric manifolds by the mirror theorem
   > \cite[Theorem~0.1]{Givental} — gives"

6. **MAJOR — the roadmap names one mechanism where the proof uses two, and the reason for
   the split is buried.** The orientation paragraph promises exactly one route:

   > "Two facts carry the computation: the small quantum cohomology of a Hirzebruch surface
   > depends on its index only through the parity, and the resulting rank-four Euler quartic
   > is separable away from one explicit locus that no center specialization meets."

   But `prop:minimal-ruled-specialized-vanishing` splits: `F_0` goes through the product
   formula, `a ≥ 1` through the discriminant. The reason appears only at the end of the
   `F_0` paragraph, in a compressed aside — "No relation between the two specialized values
   is used, which matters: the two rulings may well have the same image." — and the reader
   is left to reconstruct that `u = w` is exactly the even degeneracy locus of
   \eqref{eq:ruled-euler-discriminant}, so the discriminant route is unavailable for `F_0`.
   Fix: name both routes in the roadmap and give the reason there, e.g.

   > "The quadric surface \(F_0=\PP^1\times\PP^1\) is handled separately by the
   > Gromov--Witten product formula, because \(\chi\) may send the two ruling classes to the
   > same value and the quartic below then degenerates. For \(a\ge1\) two facts carry the
   > computation: …"

   and in the proof replace the aside with "The argument uses no relation between the two
   specialized values, which is what the product route buys: \(\chi\) may identify the two
   ruling classes, and the discriminant of Lemma~\ref{lem:minimal-ruled-euler-spectrum} then
   vanishes."

7. **MAJOR — the lemma title says "trichotomy" for a two-case statement.** Line 899:
   `\begin{lemma}[Degeneracy trichotomy of the ruled Euler spectrum]`, with
   `\label{lem:ruled-degeneracy-trichotomy}`, followed by an enumerate with exactly items
   (a) and (b). Replace title and label with "Degeneracy dichotomy of the ruled Euler
   spectrum" / `lem:ruled-degeneracy-dichotomy`, updating the two `\ref` sites at lines 1013
   and in `prop:minimal-ruled-specialized-vanishing`.

8. **MINOR — the definition of "monomial" arrives before any reason to want it.**
   `def:monomial-specialization` is dropped in immediately after the positive-genus ruled
   proof, ahead of the paragraph "The remaining minimal centers are the rational ruled
   surfaces" that first says what problem is being attacked; its actual job — excluding
   `256u + 27w² = 0` for `F_1` when `p = 2r` — surfaces two lemmas later. The style guide
   asks that definitions be introduced "where they become useful". Fix: move the roadmap
   paragraph ("The remaining minimal centers…") above the definition, and add one clause to
   the definition's lead-in, e.g. "One case below needs a mild extra condition on \(\chi\),
   used only to rule out a single algebraic coincidence in the associated graded ring:".

9. **MINOR — the lemma title "Center specializations avoid the degeneracy locus" understates
   the statement.** `lem:center-specialization-nondegenerate` hypothesizes an arbitrary
   strictly Novikov-admissible (and, at `a=1`, monomial) \(\chi\), not a center
   specialization. Retitle "Strictly admissible specializations avoid the degeneracy locus",
   keeping the stable label, or add "in particular the center specializations
   \eqref{eq:center-novikov-specialization}" as a closing clause.

10. **MINOR — "targets" and "centers" are used for the same restriction in adjacent
    sentences.** The section 5 opening has "for nef-canonical **targets** … Hypothesis~5.7T
    is used only for nonminimal surface **centers**", and `prop:low-dimensional-vanishing`
    says "Hypothesis~5.7T for nonminimal surface **targets** only" while
    `thm:nu6-birational-invariance`, the introduction theorem, section 6 and the genus-eight
    theorem all say "**centers**". Since the restriction is on which blowup centers the
    hypothesis is invoked for, standardize on "centers"; if the proposition genuinely needs
    "targets" because its `T` is not yet a center, say so once: "Hypothesis~5.7T for
    nonminimal surface targets only (these are the centers to which it is applied below)."

11. **MINOR — the introduction and section 6 disagree in register on the same restriction.**
    Section 5 opening and section 6 both say "that restricted form of Hypothesis~5.7T",
    while the introduction and the three theorem statements spell it out as "Hypothesis~5.7T
    for nonminimal surface centers only". "That restricted form" reads as though the
    hypothesis itself has been weakened, when what is restricted is the range of centers it
    is applied to. Prefer, in both places, "on Hypothesis~5.7T for nonminimal surface
    centers". Otherwise the four scope statements are compatible: I found no substantive
    disagreement among introduction, section 5 opening, `prop:low-dimensional-vanishing`,
    `thm:nu6-birational-invariance`, `rem:tagging-scope`, the genus-eight theorem and
    section 6.

12. **MINOR — "These two relations are also immediate from …" is followed by seven lines of
    argument.** Lines 870–880. Either the derivation is immediate, in which case compress
    it, or it is a real second proof, in which case do not call it immediate. Also, if the
    direct derivation stands on its own, the Batyrev and Givental imports become
    corroborating rather than load-bearing and the registry should say so. Suggested
    opening: "The same two relations can be read off directly from the genus-zero invariants
    of the del Pezzo surface \(F_1\), which is how we use them; the toric presentation is
    recorded as a check."

13. **MINOR — the new proof restates a fact the paper already asserts elsewhere, in
    different words and without a cross-reference.** New text (line 1006): "The formal
    decomposition of a tensor product is the tensor product of the decompositions."
    Pre-existing text in `prop:projective-product-nu` (line 1305): "The Levelt--Turrittin
    formal decomposition is compatible with tensor products of differential modules." Use
    one formulation and cross-refer: "…, and, as in the proof of
    Proposition~\ref{prop:projective-product-nu}, the Levelt--Turrittin formal decomposition
    is compatible with tensor products of differential modules, so …". A one-clause note
    that the `F_0` case is the \(\chi\)-specialized analogue of
    `prop:projective-product-nu` would also orient the reader immediately.

14. **MINOR — undefined term "ruling rays".** "the tensor product of the modules specialized
    along the two restrictions of \(\chi\) to the **ruling rays**" — the term appears once,
    unglossed. Write "to the two ruling classes \(f_1, f_2\)", which matches the
    \(\chi(Q^{f_i})\) in the very next sentence.

15. **MINOR — "Hirzebruch surface" and its "index" are used before they are defined, and the
    same surface has three names.** The roadmap paragraph says "the small quantum cohomology
    of a Hirzebruch surface depends on its **index** only through the parity" before
    `lem:minimal-ruled-euler-spectrum` introduces \(T=F_a=\PP_{\PP^1}(\OO\oplus\OO(a))\).
    Meanwhile `F_1` is "the Hirzebruch surface of index one" in `imported-sources.json`
    under Batyrev, "the del Pezzo surface of degree eight" under Givental, and "the del
    Pezzo surface \(F_1\)" in the manuscript. Fix: gloss at first use — "a Hirzebruch
    surface \(F_a=\PP_{\PP^1}(\OO\oplus\OO(a))\) depends on \(a\) only through its parity" —
    and pick one name for `F_1` in the registry, mentioning the del Pezzo description only
    where the Fano hypothesis is being checked.

16. **MINOR — the proof re-introduces `F` and `S` without tying them to the statement's `f`
    and `s`.** The lemma declares "let \(f\) and \(s\) be the fibre class and the
    negative-section class in \(N_1(T)\)"; the proof opens "Write \(F\) for the class of a
    fibre and \(S\) for the class of the section of self-intersection \(-a\)". Add four
    words: "…, the divisor classes corresponding to \(f\) and \(s\)".

17. **MINOR — two compressed sentences that cost the reader a re-read.**
    (a) "A block of rank two over an algebraically closed field has trace twice and
    determinant the square of its eigenvalue, so Cayley--Hamilton in rank two makes its
    centred matrix square to zero." Replace: "A rank-two block has a single eigenvalue
    \(\lambda\), hence trace \(2\lambda\) and determinant \(\lambda^2\); by
    Cayley--Hamilton \((M-\lambda)^2=0\)."
    (b) "…are members of the basis \(B\) of Definition~\ref{def:monomial-specialization}."
    Add why: "…, since \(f\) and \(2s\) are effective." Also, in the definition itself,
    "the leading term \(\operatorname{gr}\chi(Q^d)\) of every effective monomial" should
    read "of \(\chi(Q^d)\) for every effective class \(d\)".

18. **MINOR — bibliography.** All four `\cite` keys used in the new text (`Batyrev`,
    `Givental`, `McDuffSalamon`, `BehrendProduct`) exist in `thebibliography`; no dangling
    keys. Two small defects:
    (a) `McDuffSalamon` writes `\emph{$J$-holomorphic Curves and Symplectic Topology}` in
    dollar math, while the whole file uses `\(...\)` (compare `\(A_5\)`, `\(V_{14}\)`,
    `\(CH_0\)` in neighbouring entries). Change to `\(J\)-holomorphic`.
    (b) `McDuffSalamon` gives a place of publication ("American Mathematical Society,
    Providence, RI, 2012") where the two existing book entries do not (`PutSinger`:
    "Grundlehren … 328, Springer, 2003"; `SabbahStokes`: "Lecture Notes in Mathematics 2060,
    Springer, 2013"). Drop ", Providence, RI" for consistency.
    (c) Insertion points are one slot late relative to the list's otherwise alphabetical
    order: `Batyrev` sits after `BdGF` (Beckmann) and `Givental` after
    `GonzalezAguileraLiendo`. `McDuffSalamon` is correctly placed. The existing list already
    has exceptions (`CT` after `DavidHertling`, `AtlasBrauer` after `Hartlieb`), so this is
    cosmetic.

19. **MINOR — three prose lines exceed the file's wrap width, and one hunk has a stray double
    blank line.** In `sections/01-introduction.tex`: "low-dimensional proof it remains only
    for nonminimal surfaces.  A rank-two formal-germ theorem proves the" (106 chars) and
    "through dimension four.  That invariance reproves the one-step conclusion from the
    finer" (89). In `sections/06-synthesis.tex`: "birationally invariant through dimension
    four.  Neither hypothesis is a condition on any separation" (100). And
    `sections/05-framed-monodromy.tex` has two consecutive blank lines before
    `\begin{proposition}[Direct specialized vanishing for minimal rational ruled centers]`.
    Rewrap to the surrounding ~78 columns and drop the extra blank line.

20. **MINOR — `rem:tagging-scope`'s new closing sentence states a rank formula that holds only
    for one minimal model, and "also" is doing no work.**

    > "The even cohomology of a nonminimal surface also has rank four plus the number of
    > blowups, so the quartic discriminant of Lemma~\ref{lem:minimal-ruled-euler-spectrum}
    > does not apply to it."

    A surface blown up \(n\) times from `\PP^2` has even cohomology of rank \(3+n\), not
    \(4+n\); only the ruled minimal models give \(4+n\). Suggested wording that avoids the
    arithmetic and makes the same point: "Each blowup raises the rank of the even cohomology
    by one, so the quartic of Lemma~\ref{lem:minimal-ruled-euler-spectrum} does not describe
    a nonminimal surface." Flagging the count itself to the correctness referee.

21. **OK — registry prose, `imported-sources.json`.** All four new entries read as scholarly
    documentation: `pinpoint` is at section/theorem/chapter level, `used` names the exact
    statement imported, and each `conventions` aspect names a condition whose violation
    would in fact invalidate the use — Batyrev's Fano hypothesis (the primitive-relation
    ring can have the wrong rank otherwise) and its Novikov-variable normalization;
    Givental's nef-plus-trivial-degree-two condition under which no mirror map intervenes,
    and the Novikov coefficients; McDuff–Salamon's transported-lattice framing and the
    connected-family domain; Behrend's tensor-decomposition of Novikov rings. Two wording
    repairs below.

22. **MINOR — self-contradictory clause in the Batyrev "hypothesis" match.**

    > "It is applied only to the Hirzebruch surface of index one, which is a del Pezzo
    > surface, **and to the quadric surface, for which the product formula is used
    > instead.**"

    If the product formula is used instead, Batyrev is not applied there. Replace the clause
    with a separate sentence: "The quadric surface is not covered by this import; it is
    handled by the Gromov--Witten product formula."

23. **MINOR — Behrend "framing" records a gap rather than a match.** The requirement is that
    "the passage to formal decompositions of the associated connections is a separate step";
    the match answers "That passage is stated as the premise consumed by the formal
    statement". That documents where the step is assumed, not that the convention is
    honoured. Say so plainly: "matched": "The manuscript uses the product formula only for
    the quantum products; the compatibility of the Levelt--Turrittin decomposition with
    tensor products is invoked separately, as in the proof of
    Proposition~\ref{prop:projective-product-nu}." (This pairs with item 13.)

24. **MINOR — `evidence.json`'s `role` is one 90-word chain of "against … against …".** The
    sentence "Cross-checks the presentation against the classical cohomology ring at the
    origin, against the Novikov grading, against an independent elimination …, against an
    independent splitting or resultant computation …, against self-adjointness …, and
    against the relations obtained directly from the genus-zero invariants of the surface of
    index two" is exactly the stacked-coordination shape the style guide asks to be
    rewritten. Break it: "It runs six independent cross-checks on the presentation: the
    classical cohomology ring at the origin; the Novikov grading; an elimination of the two
    divisor generators; a resultant computation of the discriminant; self-adjointness of
    Euler multiplication for the trace form; and the relations computed directly from the
    genus-zero invariants of \(F_2\)." (The `F_2` reference is accurate — the script's
    `gromov_witten` check is for `F_2`.) Also, the note's opening "The proof spine of this
    manuscript is structural.  One statement rests on a symbolic computation" undercuts
    itself in two sentences; merge: "The proof spine of this manuscript is structural apart
    from one symbolic computation:".

25. **OK — forbidden word.** No occurrence of "honest", "honestly" or "honesty" anywhere in
    the diff.

26. **OK — chatbot register.** No occurrence of "delve", "intricate", "meticulous",
    "pivotal", "underscore", "comprehensive", "crucial", "enhance", "insight", "nuanced",
    "showcase", "realm", "seamless", "unveil", "utilize", "it is worth noting", "for
    completeness", or "we emphasize" in the added lines. The one "moreover" is pre-existing
    text in the genus-eight theorem, untouched by this diff. No architectural metaphors for
    logical dependence; the scope sentences name the hypothesis and the case directly. Only
    two chatty residues, both covered above: "which matters" (item 6) and "may well" in the
    same sentence.

27. **OK — topic sentences and paragraph jobs in the new prose.** "The remaining minimal
    centers are the rational ruled surfaces.", "The center maps … are monomial.", "By
    \eqref{eq:ruled-euler-discriminant} and \(u,w\ne0\), the discriminant vanishes exactly
    on the stated locus.", "On the locus the quartic factors.", "Let \(a=0\), so
    \(T=\PP^1\times\PP^1\)." — each opens its paragraph with its own claim, and each
    paragraph has one job. The italic run-in headings inside the spectrum proof
    (*Reduction to \(a\le1\)*, *The two base cases*, *The quartic*) do real navigational
    work and match the style guide's call to separate conceptual reduction from
    computation visibly. The valuation proof of
    `lem:center-specialization-nondegenerate` is correctly expanded at the one place where
    understanding is won (the `a=1`, `p=2r` coincidence) and compressed elsewhere. No
    ceremonial commentary on routine steps.
