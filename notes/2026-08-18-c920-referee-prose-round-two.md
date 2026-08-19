# C920 referee report, round two: exposition, style, internal consistency

**Scope**: `git diff 3736b643a..2c030a8fc -- papers/cubic-stabilization-epilogue/sections
papers/cubic-stabilization-epilogue/cubic_stabilization_epilogue.tex
papers/cubic-stabilization-epilogue/verification`, read against the committed blobs of
`2c030a8fc`, not the working tree (see item 0). Same standard as round one: exposition,
style-guide compliance, internal consistency of wording and cross-references. Mathematical
correctness remains another referee's charge.

**Verdict**: Accept after a short revision. Every round-one defect I raised is genuinely
fixed and I re-verified the mechanical ones: equation tags now run 5.4a, 5.5, 5.5a, 5.5b,
5.6, 5.7 in file order with no duplicate; no `\label` is defined twice; every `\ref` and
`\eqref` in `sections/` and the main file resolves; no reference to the retired labels
`lem:minimal-ruled-euler-spectrum`, `lem:ruled-degeneracy-trichotomy` or
`prop:minimal-ruled-specialized-vanishing` survives anywhere, including the verification
JSON and the dependency graph; the README coverage arithmetic (50→56 claims, 5→6 absent,
23→25 fragmentary, 21→24 conditional) matches the six new claim-carrying statements
exactly; and the forbidden-word check on the diff comes back clean. The two new proof passages earn
their length and sit in the right place.

What still needs doing before circulation: two sentences kept the old "minimal" wording and
now contradict the new terminology outright (items 1 and 2); the manuscript is split between
"centre" and "center", sometimes inside one paragraph (item 3), and the uncommitted fix for
that in the working tree has broken a word (item 0); the word "monomial" is used in a third
sense two paragraphs before the passage that disambiguates its first two (item 4); and four
edited lines run 104–119 columns (item 12). The rest is polish.

---

0. **MAJOR (outside the reviewed commit, but it will ship) — the working tree contains an
   uncommitted `centre`→`center` sweep that produced a misspelling.** `git diff 2c030a8fc --
   papers/cubic-stabilization-epilogue/sections` shows nineteen substitutions, one of which
   is

   > "by Cayley--Hamilton its **centerd** matrix \(M-\lambda\) squares to zero."

   The word there is "centred/centered" (past participle of "centre/center"), not an
   instance of the noun, so a blanket substitution corrupts it. Fix to "centered" and, since
   the sweep resolves item 3 in the American direction, carry it through consistently. Two
   further working-tree lines the sweep did not need to touch are fine; I reviewed the
   committed text throughout and flag this only so it is not lost.

1. **MAJOR — the paragraph that introduces the Hirzebruch surfaces still calls them minimal
   centres.** `sections/05-framed-monodromy.tex:764`:

   > "The remaining **minimal** centers are the **rational ruled** surfaces, the Hirzebruch
   > surfaces \(F_a=\PP_{\PP^1}(\OO\oplus\OO(a))\)."

   This is the exact claim the terminology repair removed: \(F_1\) is a Hirzebruch surface
   and is not minimal, and \(\PP^2\) is a minimal surface that is not in this family. The
   sentence also retains the pre-repair phrase "rational ruled surfaces" — the only
   surviving instance in `sections/`. Replace with:

   > "The remaining centres are the rational geometrically ruled surfaces, that is the
   > Hirzebruch surfaces \(F_a=\PP_{\PP^1}(\OO\oplus\OO(a))\); these are the minimal
   > surfaces not yet covered, together with \(F_1\), which is geometrically ruled without
   > being minimal."

2. **MAJOR — the closing sentence of `rem:tagging-scope` contradicts the sentence three lines
   above it.** Lines 1095–1104 first say

   > "Those cases exhaust the minimal surfaces, and also cover \(F_1\), which is
   > geometrically ruled without being minimal."

   and then close with

   > "Each blowup also raises the rank of the even cohomology by one, so the quartic of
   > Lemma~\ref{lem:hirzebruch-euler-spectrum} does not describe a **nonminimal** surface."

   \(F_1\) is nonminimal and is precisely what the quartic describes. The class the closing
   sentence means is the one the remark has just named. Fix:

   > "…so the quartic of Lemma~\ref{lem:hirzebruch-euler-spectrum} does not describe a
   > surface that is neither minimal nor geometrically ruled."

   (This is my round-one item 20 re-broken by the terminology change, not a regression in
   the arithmetic, which is now correct.)

3. **MAJOR — "centre" and "center" are mixed across the manuscript and inside single
   paragraphs.** In the committed text, `sections/` has nineteen lines with "centre" and
   forty-one with "center". The worst pairs:
   - `rem:tagging-scope` opens "not needed for nef-canonical **centres**" (line 1091) and
     closes "after the external **center** specialization" (line 1101).
   - The new roadmap says "no **centre** specialization meets" (line 773) directly after
     "The remaining minimal **centers**" (line 764).
   - `lem:center-maps-monomial` is titled "**Centre** specializations are graded-monomial"
     under an American label.
   - `sections/04-atomic-one-step.tex` (untouched) uses "center" nine times; the Lean
     identifiers are `centerSpecialization_*`.

   Pick American throughout — the untouched sections, the labels and the Lean names already
   commit the paper to it — and apply it by hand, not by substitution (item 0).

4. **MAJOR — "monomial" is used in a third sense two paragraphs before the passage that
   disambiguates the first two.** The roadmap at line 771 says the deformation acts

   > "under a **monomial** substitution of Novikov variables"

   and only at lines 777–779 does the reader learn that "monomial" in
   Definition~\ref{def:strict-novikov-admissible} is about the source, that the new
   condition is about the target, and that the latter is therefore called graded-monomial.
   Introducing a third, unrelated sense first defeats the disambiguation. Replace with "under
   an explicit change of Novikov variables", which is also what the proof actually
   establishes (\(\psi(f)=f\), \(\psi(s+kf)=s_0\)).

5. **MINOR — the introduction and the section 5 opening say the graded-monomial caveat in
   incompatible words, and the introduction's version is the harder one.** Section 5 opening
   (lines 24–27) reads well:

   > "for every rational geometrically ruled surface---for \(F_1\) on specializations that
   > are graded-monomial in the sense of Definition~\ref{def:monomial-specialization}, as
   > every centre specialization is---"

   The introduction (lines 219–221) says the same thing as a noun chain with a trailing verb
   and without naming the surface:

   > "for every rational geometrically ruled surface---for **one of them** on specializations
   > of a mild graded-monomial form that every centre specialization **has**---"

   Make the introduction parallel and name the surface, keeping it definition-free since the
   definition is four sections away:

   > "for every rational geometrically ruled surface---for the Hirzebruch surface \(F_1\),
   > on specializations satisfying a mild condition that every blowup centre satisfies---"

6. **MINOR — section 6 drops the graded-monomial caveat where it still bites.** Section 6
   says Hypothesis 5.7T is removed "for nef-canonical targets, \(\PP^1\), \(\PP^2\), every
   rational geometrically ruled **surface**". Stated over surfaces rather than centres, that
   overstates `prop:hirzebruch-specialized-vanishing`, which needs graded-monomiality at
   \(F_1\). Add four words: "every rational geometrically ruled surface (for \(F_1\), on the
   specializations that arise as blowup centres)". `rem:tagging-scope` needs no such
   addition, since it speaks only of centres, where
   Lemma~\ref{lem:center-maps-monomial} discharges the condition.

7. **MINOR — "surface" is dropped from the scope phrase in two of the six places it
   occurs.** The introduction prose (line 222) and section 6 say "centres that are neither
   minimal nor geometrically ruled"; the introduction theorem, the section 5 opening,
   `prop:low-dimensional-vanishing`, `thm:nu6-birational-invariance` and the genus-eight
   theorem all say "**surface** centres that are neither minimal nor geometrically ruled".
   Since a weak-factorization centre may be a point or a curve, and points and curves are
   vacuously neither minimal nor geometrically ruled, the short form reads as a wider
   restriction than intended. Insert "surface" in both places. With that, all six statements
   agree word for word, which is the right outcome — I checked them against each other and
   found no other divergence.

8. **OK, with two wording nits — "One deformation to \(a\le1\)" is at the right level of
   detail and in the right place.** It replaces round one's hand-waved iteration with one
   explicit family (a general pair of sections of \(\OO(k)\) and \(\OO(a-k)\), the extension
   class \(\varepsilon\), the projectivized \(E_t\) over \(\A^1\)) and one explicit
   transport, and the transport formulas \(\psi(f)=f\), \(\psi(s+kf)=s_0\),
   \(S^\flat\mapsto S_0\) are exactly what the Truncation and quartic paragraphs consume
   two paragraphs later. The semipositivity and Kähler-family check earns its clause: it is
   the hypothesis a symplectic-geometry reader would test. The \(\A\) macro it introduces
   (`\A^1`) is defined at line 30 of the main file. Nits:
   (a) The heading is not idiomatic. Use "*A single deformation to \(a\le1\).*" — and, since
   doing it in one step rather than \(k\) steps is a deliberate choice that keeps \(\psi\)
   explicit, one clause saying so would pay for itself.
   (b) "…and a symplectic four-manifold is semipositive, so **that theory applies here**."
   The referent of "that theory" is loose. Write "so the genus-zero invariants of
   \cite{McDuffSalamon} are defined and deformation-invariant for this family." Also prefer
   "every symplectic four-manifold is semipositive", matching the registry entry.

9. **OK, with one correction — "Truncation" earns its length and its position.** It is the
   step that licenses the finite presentation and the substitution \(Q^f\mapsto u\),
   \(Q^{s+kf}\mapsto w\); without it "the specialized small quantum cohomology of \(F_a\) is
   \(A[S^\flat,F]\) modulo …" would be unjustified, which was a real gap in round one. It
   belongs after the base cases and before the quartic, where it is. One error and one gap:
   (a) The topic sentence says "only **three** Novikov monomials survive", but the paragraph
   itself concludes that two survive for \(a\) even (\(f\) and \(s+kf\)) and three for \(a\)
   odd. Write "only two or three Novikov monomials survive", or "only finitely many".
   (b) "A three-point invariant of \(F_a\) with two divisor insertions vanishes unless
   \(1\le c_1(T)\cdot\beta\le2\)" is asserted bare. Add "(by the virtual dimension count)" —
   this is the kind of omitted bridge the style guide asks not to leave implicit.

10. **MINOR — the statement of `prop:low-dimensional-vanishing` puts the new condition in a
    dangling appositive.** Lines 1230–1233:

    > "For every strictly Novikov-admissible specialization \(\chi\),
    > graded-monomial if \(T\cong F_1\),
    > \[ \nu_6(T;\chi)=0. \]"

    The second comma-clause floats between the quantifier and the display. Rewrite:

    > "Let \(\chi\) be a strictly Novikov-admissible specialization, graded-monomial when
    > \(T\cong F_1\).  Then \[ \nu_6(T;\chi)=0. \]"

    The localization itself is the right fix to my round-one item 4 and reads correctly.

11. **MINOR — "the identity specialization" is used without being introduced.** The proof of
    `prop:low-dimensional-vanishing` now argues intrinsic vanishing by "apply the direct
    cases just listed to the identity specialization, which is strictly Novikov-admissible
    and graded-monomial". The paper distinguishes \(\nu_6(T)\) from \(\nu_6(T;\chi)\)
    carefully, so the reader needs to be told what \(\chi=\mathrm{id}_{\Lambda_T}\) is and
    why it satisfies Definition~\ref{def:strict-novikov-admissible}. Add a half-clause: "the
    identity map of \(\Lambda_T\), which is strictly Novikov-admissible with \(\ell\) the
    valuation of the Novikov ring itself, and graded-monomial because its associated graded
    has the Novikov monomials as a basis." In the same paragraph, "a minimal smooth
    projective surface has nef canonical class, or is \(\PP^2\), or is geometrically ruled
    over a curve" is the Enriques--Kodaira minimal-model dichotomy and should carry the
    citation the paper gives classical inputs elsewhere.

12. **MINOR — four edited lines run well past the file's ~78-column wrap, and one leaves an
    orphan.** Measured on the added lines: 119 columns in the section 5 opening ("for surface
    centres that are neither minimal nor geometrically ruled.  Consequently the resulting
    birational invariance"), 113 in `prop:low-dimensional-vanishing` ("neither minimal nor
    geometrically ruled.  Let \(T\) be a point, a smooth projective curve, or a smooth
    projective"), 111 in the statement of `lem:hirzebruch-euler-spectrum` ("taken as the
    fibre; the quartic below is symmetric in \(u\) and \(w\).  Let \(\chi:\Lambda_T\to A\) be
    strictly"), and 104 in the introduction ("is birationally invariant through dimension
    four.  That invariance reproves the one-step conclusion from"). The introduction also
    now ends a line with a lone "A" before "rank-two formal-germ theorem". Rewrap the four
    paragraphs. The stray double blank line before
    `prop:hirzebruch-specialized-vanishing` from round one is gone.

13. **MINOR — `evidence.json`'s note still uses the retired term.** The note reads

    > "…Euler multiplication on the rank-four even cohomology of a **minimal rational ruled
    > surface**…"

    while the `role` field in the same object correctly says "a Hirzebruch surface". This is
    the last instance of "minimal rational" anywhere in the paper directory. Change the note
    to "of a Hirzebruch surface". The rest of the note now reads well: merging the
    self-undercutting opening into "structural apart from one symbolic computation" was the
    right repair, and breaking the cross-check pile into a six-item list fixed the stacked
    coordination.

14. **MINOR — `imported-sources.json`, McDuffSalamon: one paraphrase and one sentence do not
    parse on a first read.**
    (a) `used`: "the Hirzebruch surface obtained from it by subtracting twice the integer
    part of half its index" spends eleven words encoding \(F_{a\bmod2}\). The registry
    elsewhere names objects directly; write "the genus-zero Gromov--Witten invariants of the
    Hirzebruch surfaces F_a and F_{a mod 2} agree under…".
    (b) `domain`/`matched` ends "…and its zero fibre and every nonzero fibre are the two
    surfaces", which reads as a plural predicated of a pair. Write "its zero fibre is F_a and
    every nonzero fibre is F_{a mod 2}".
    The new third convention on that entry — semipositivity plus a symplectic rather than
    merely algebraic family — is a genuine hypothesis whose violation would invalidate the
    import, and it is the right addition; it matches the clause added to the proof.

15. **MINOR — the Batyrev entry now records that the import corroborates rather than carries,
    but the Givental entry does not.** Batyrev's `matched` says "the import corroborates a
    computation rather than carrying it", matching the manuscript's "which is how we use
    them; the toric presentation is recorded as a check". Givental's `used` still reads flatly
    "That the quantum Stanley--Reisner presentation of a smooth Fano toric manifold is a
    theorem rather than a conjecture", with no such note, though it stands or falls with
    Batyrev. Add the same clause. Both remain in the `\imports{}` list of
    `lem:hirzebruch-euler-spectrum` alongside the two load-bearing imports, which is
    defensible now that the registry distinguishes them.

16. **MINOR — `lem:center-maps-monomial` is the one new statement with no Lean coverage, and
    it is a premise of the headline conditional theorem.** It carries `\coverage{absent}`
    and no `\lean{}`, while `def:monomial-specialization` next to it carries
    `\lean{monomialSpecializationData}`, and
    `thm:nu6-birational-invariance` invokes it directly ("Lemma~\ref{lem:center-maps-monomial}
    shows that it is graded-monomial"). Promoting the paragraph to a labelled lemma was the
    right call — the round-one cross-reference by paragraph position is gone — but the
    promotion has made an uncovered premise visible without comment. Either give it the
    centre-map instance on the Lean side, or say once in the verification README that this
    premise is argued only in the text. Its proof also refers to "the **center coefficient
    ring**", a term used nowhere else; write "the target ring \(A\) of
    \eqref{eq:center-novikov-specialization}".

17. **MINOR — "There" lost its antecedent when the corroboration sentence moved.** The base-
    case paragraph now reads

    > "The same two relations can be read off directly from the genus-zero invariants of
    > \(F_1\), which is how we use them; the toric presentation is recorded as a check.
    > **There** \(c_1\cdot(mf+ns_0)=2m+n\), so…"

    "There" now reaches back across an intervening clause about the toric presentation.
    Write "On \(F_1\), \(c_1\cdot(mf+ns_0)=2m+n\), so…".

18. **OK — bibliography.** `\(J\)-holomorphic` and the dropped place of publication both
    landed; all four `\cite` keys resolve; no key is defined twice. The two entries remain
    one slot out of alphabetical order (`Batyrev` after `BdGF`, `Givental` after
    `GonzalezAguileraLiendo`), which I flagged as cosmetic in round one and still regard as
    optional given the list's existing exceptions.

19. **OK — chatbot register and style-guide sentence discipline in the new prose.** No
    occurrence of the flagged excess vocabulary in the added lines; the one "moreover" is
    pre-existing text. The round-one chatty residues are gone: "which matters" and "may well"
    have been replaced by "which is what the product route buys: \(\chi\) may identify the
    two ruling classes", which states the mathematical reason directly. Topic sentences lead
    the new paragraphs, the four italic run-in headings in the spectrum proof do real
    navigational work, and the two routes are now named in the roadmap with the reason for
    the split ("because \(\chi\) may send its two ruling classes to the same value and the
    quartic below then degenerates"), which was my round-one item 6 and is the single
    biggest improvement in this revision. No architectural metaphors for logical dependence.
