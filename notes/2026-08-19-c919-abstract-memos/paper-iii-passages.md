# C919 abstract memo — Paper III, clebsch-passages ("Golden descent and operator realizations of the Clebsch cubic")

**Date:** 2026-08-19 · **Reviewer:** read-only sub-agent (no manuscript edits, no builds, no git writes)

**Verdict (one line):** Every mathematical claim in the proposal checks out against the paper, but the replacement is longer than the incumbent abstract and its two display equations do not belong on page 1 — reject the wholesale swap, apply three surgical precision upgrades to the current abstract instead (248-word version below), and route the adoption decision through C816, which owns the Paper III abstract-headline decision.

## 1. Word counts

Two counting conventions, same script for all three texts. "Math-as-token" replaces
each inline/display math group with one token; "crude-strip" deletes TeX commands
and counts remaining words.

| Text | math-as-token | crude-strip |
|-----------------------------------------|-----|-----|
| Current abstract (clebsch_passages.tex:33–62) | 251 | 256 |
| Proposed replacement (proposal lines 199–236) | 257 | 270 |
| Recommended abstract (Section 5 below) | 248 | 253 |

The proposal is the *longer* of the two under either convention, and it is the only
one carrying display equations (two). As a "tightening" it fails against the
incumbent on length; its value is three wording precision upgrades, extracted below.

**Displays on page 1: no.** Both displayed objects — `\Q(\mathbf P(H))(\sqrt{5J_0})`
and `-784000\sigma_3/1247103` — already sit comfortably inline in the current
abstract (clebsch_passages.tex:36 and :51). Displays in an abstract cost page-1
vertical space against a title/keywords/MSC block that currently fits, contradict
the author's standing tight-and-short preference, and buy no clarity these two
short expressions need. The proposal's own style instructions (proposal line 431)
demand a report if page-1 balance worsens; the safe answer is not to risk it.

## 2. Claim-by-claim verification of the proposed replacement

All file paths relative to `papers/clebsch-passages/`.

1. **"rational seven-space of harmonic cubics" / "generically a degree-two cover of P(H)"** — supported. `sections/01-introduction.tex:3–8` (definition of H), `:17–18` ("Their incidence variety is generically a degree-two cover of \(\mathbf P(H)\)").
2. **Normalization ι_t\*J₀ = 16σ₃²** — supported verbatim. Displayed at `sections/01-introduction.tex:92` and inside Theorem 1 (Arithmetic incidence cover) at `:129–131`; also `sections/09-conclusion.tex:4`.
3. **Function field Q(P(H))(√(5J₀))** — supported verbatim. Theorem statement `sections/01-introduction.tex:117–120`. The intro also defines the K(√(cJ₀)) shorthand rigorously (`:106–113`), so the abstract's usage is well-founded.
4. **Finite Stein algebra O ⊕ O(−3) with z² = 5J₀** — supported. Theorem statement `sections/01-introduction.tex:121–124`; `sections/09-conclusion.tex:7–9`. One nuance: the theorem inserts "after normalizing the anti-invariant summand" before naming the algebra. Both the current abstract and the proposal drop that clause. Acceptable in an abstract (the normalization is a convention, not a hypothesis), but recorded here as a deliberate omission, not an oversight.
5. **Complete reduced fibre over [xyz] with residue algebra Q(√5), determining the twist** — supported. Theorem statement `sections/01-introduction.tex:132–135` ("a complete reduced fibre with residue algebra \(\Q(\sqrt5)\)"); "determines the twist" from `:146–148` ("its residue algebra determines the global quadratic twist in the proof of Theorem~\ref{thm:arithmetic-main}") and `sections/09-conclusion.tex:5–7`.
6. **"We determine its arithmetic square class exactly"** (proposal's headline framing) — supported: `sections/01-introduction.tex:18–19` ("We determine its rational square class"). The current abstract's "We prove that its function field is …" is equally supported and two words shorter.
7. **Marked bridge datum caveat** — stated as the paper states it. The datum's components (ordering of the six golden axes, labelled plane triples/outer labels, normalized chart lift, Petersen labels = ten face axes as two-subsets) are at `sections/01-introduction.tex:152–160`, summarized in the figure as "chart lift, outer and Petersen labels" (`:47–48`). The caveat itself: Proposition (Relative marked orientation bridge) ends "The normalized component alone is not asserted to determine \(\mathfrak m\)" (`:221`), and the conclusion says "The sheet alone supplies neither the axis ordering and outer labels nor the chart lift and Petersen labels" (`sections/09-conclusion.tex:13–15`). The proposal's "a chosen sheet selects an order-six conference source or its opposite; the sheet alone supplies none of this marking" matches the conclusion's phrasing ("the chosen sheet selects the oriented conference source or its opposite", `:12–13`) and honors the red-team instruction not to shorten it. The current abstract's "the two sheets are labelled by … The sheet alone supplies none of that marking" is equivalent and equally faithful.
8. **Four exact descriptions: triangle holonomy, middle-exterior diagonal, commutator Pfaffian, oriented cross-golden determinant** — supported. Named as a foursome at `sections/01-introduction.tex:229–231` ("simultaneously triangle cubics, middle-exterior diagonals, commutator Pfaffians, and cross-golden determinants") and `sections/09-conclusion.tex:15–17`; the theorem itself is Golden operator and classical cubic shadows, `sections/05-golden-operator.tex:186–252` (triangle products item 1, `*\wedge^3` diagonal within item 1/2 apparatus, commutator Pfaffian `:199–204`, oriented determinant `:211–218` with explicit determinant-line orientation — so "oriented" is earned).
9. **Signed Joubert–Segre–Igusa–Clebsch chain** — supported. Signed Joubert coordinates onto the Segre cubic with diagonal Clebsch sections: `sections/05-golden-operator.tex:225–236`; Segre–Igusa polar map: `sections/01-introduction.tex:231–234`; chain restated `sections/09-conclusion.tex:17–19`.
10. **Harmonic coefficient −784000/1247103 · σ₃, exact** — supported verbatim. Theorem (Degree-six harmonic restriction), `sections/05-harmonic-realization.tex:59–74`, display `:70–73`; factorization and provenance of the prime 11 at `sections/01-introduction.tex:283–294`.
11. **"Under the marked Petersen pair-sum comparison"** (proposal) vs **"On the Petersen four-space"** (current) — both supported. The marked primitive pair-sum map β is in the bridge proposition, `sections/01-introduction.tex:214–219`; the theorem restricts to the pair-sum coefficient copy of V, `sections/05-harmonic-realization.tex:64–68`; conclusion `:19–21` ("The Petersen pair-sum construction carries the relative orientation…"). The proposal's phrase is the more precise of the two — it names the marking. This is upgrade (a) below.
12. **"Relative sign comparison between cubics on different spaces, not an identification of their ambient harmonic representations"** — supported nearly verbatim. `sections/01-introduction.tex:224–226`, `sections/09-conclusion.tex:22–24`, and the appendix's no-intertwiner fact (`sections/07-marking-ambiguities.tex:42–47`: degrees three and six are nonisomorphic irreducible rotation modules) which makes the caveat mathematically forced, not decorative.
13. **Cut-independence of the balanced exchange spectrum singles out order six** — supported. Theorem (Balanced exchange rigidity), `sections/05-golden-operator.tex:391–422`: spectrum cut-independent iff d ≤ 3, "Thus order six is the unique nontrivial realized symmetric conference order with this property" (`:401–402`).
14. **Every two-graph on at least seven vertices, up to complement, seven sharp** — supported. Theorem (Aligned-design faithfulness), `sections/05-golden-operator.tex:523–526`: "If \(|V|\geq7\), then \(\mathcal A(\tau)\) determines \(\tau\) up to complement, and seven is the least bound with this property." The quantifier is universal over two-graphs, so the proposal's "every" is correct; the current abstract already has "every" here too.
15. **Conference order n ≥ 10, up to switching and global negation; determinant-(−3) four-blocks** — supported with two shading notes. Theorem `sections/05-golden-operator.tex:528–531`: "For a symmetric conference matrix of order \(n\geq10\), its marked family of principal four-subsets with determinant \(-3\) … determines its signing up to diagonal switching and global negation." (i) Both abstracts write "switching" for the theorem's "diagonal switching" — standard shorthand for conference matrices, acceptable. (ii) The proposal's "four-blocks" is closer to the theorem's "principal four-subsets" than the current abstract's bare "blocks", and the proposal's "every symmetric conference signing" matches the theorem's universal quantifier where the current abstract's "symmetric conference signings" is weaker. These are upgrades (b) and (c) below.
16. **Two consequences independent of Hitchin's cover** — supported. `sections/01-introduction.tex:249–251` ("neither assume Hitchin's cover nor supply a hypothesis to the source–shadow–return argument"), `sections/09-conclusion.tex:26–32`. Both abstracts say "independent structural consequences" of the conference carrier, which is exactly the paper's positioning.
17. **Spreading-out caveat** — supported. `sections/01-introduction.tex:271–277` (comparison with the geometric incidence variety proved only after inverting an unspecified integer) and `sections/09-conclusion.tex:34–38` ("Determining the exact finite set of primes that must be inverted … remains … ; it does not affect the characteristic-zero quadratic algebra above."). Both abstracts carry it in the same words.

**No unsupported claim found in the proposed replacement.** Cross-paper red-team
check item 3 (proposal lines 403–408) is satisfied by both the current abstract and
the proposal on all five bullets: characteristic-zero scope, unresolved spread-out
primes, sheet-does-not-supply-marking, relative/different-spaces comparison, and
independence of the two structural theorems from Hitchin's cover.

## 3. Macro check

Macros defined in the preamble (`clebsch_passages.tex:21–24`): `\Q`, `\F`, `\Spec`,
`\PSL`. No custom style file; amsmath/amssymb/amsthm loaded (`:7`).

Proposal's LaTeX uses: `\Q` (defined), `\mathbf`, `\mathcal`, `\iota`, `\sigma`,
`\sqrt`, `\frac`, `\oplus`, `\(...\)`, `\[...\]` — all defined or standard.
**No undefined macros.** (The style instruction's mention of `\PG`, `\PGL`, `\PP`
does not apply here: none of those is defined in this paper, and the proposal's
block does not use them. Note `\PGL` in particular is *not* defined in this
preamble — only `\PSL` — so any future abstract edit importing `\PGL` from the
other papers' conventions would fail to compile.)

## 4. Judgement of the proposal's red-team notes (proposal lines 240–249)

All eight notes are correct:

1. Factor 5 from the complete reduced [xyz]-fibre, not merely inferred from the branch equation — right; that is exactly the proof route stated at `sections/01-introduction.tex:238–241` and `:146–148`.
2. Sheet-selects-source conditioned on the marked bridge datum, never shortened — right, and the paper's own conclusion (`sections/09-conclusion.tex:12–15`) uses the same conditional shape.
3. Four operator descriptions are of the same marked cubic family after marking — right (`sections/05-golden-operator.tex:186–188`: "For a marked bridge datum and its coherent outer family").
4. Harmonic coefficient exact + different-spaces warning — right, verbatim support cited in Section 2 items 10 and 12.
5. "Every two-graph … seven sharp" genuinely uniform — right (`sections/05-golden-operator.tex:525–526`).
6. Conference n ≥ 10, signing up to switching and global negation — right, with the minor shading that the theorem says "diagonal switching"; the note itself says "diagonal switching", so the note is more precise than the abstract text it defends.
7. Do not call the two-graph/exchange results consequences of Hitchin's cover — right, and both abstract versions comply.
8. Keep the spreading-out caveat — right; without it the arithmetic theorem reads as an all-primes statement the paper explicitly does not prove (`sections/01-introduction.tex:271–277`).

What the red-team notes miss is the meta-point: the proposal violates its own
brief for this paper. It is the longest of the five replacements, the only one
with display equations, and it is *longer than the abstract it replaces* — while
the current abstract already implements the proposal's entire "clean spine"
(square class → marked transport → four realizations + harmonic return → two
independent consequences) in the same order. The proposal reads as if drafted
against an older abstract; against the committed one its only real content is
three wording refinements.

## 5. Recommended abstract (paste-ready)

248 words (math-as-token convention), no display equations, shorter than both the
proposal (257) and the current abstract (251).

```latex
\begin{abstract}
Let \(H\) be the rational seven-space of harmonic cubics.  Hitchin's
icosahedral incidence variety is generically a degree-two cover of
\(\mathbf P(H)\).  We prove that its function field is
\(\Q(\mathbf P(H))(\sqrt{5J_0})\), where \(J_0\) is the rational equation
of the reduced branch sextic normalized by \(\iota_t^*J_0=16\sigma_3^2\)
on the Clebsch chart.  The complete reduced fibre over \([xyz]\) has
residue algebra \(\Q(\sqrt5)\) and determines the twist; the finite Stein
algebra is \(\mathcal O\oplus\mathcal O(-3)\) with \(z^2=5J_0\).

After an ordering, chart lift, outer labels, and Petersen labels are fixed
as a marked bridge datum, the two sheets are labelled by an order-six
conference source and its opposite; the sheet alone supplies none of that
marking.  The source cubic and its six outer translates have four exact
descriptions---triangle holonomy, middle-exterior diagonal, commutator
Pfaffian, and oriented cross-golden determinant---giving the signed
Joubert--Segre--Igusa--Clebsch chain.  Under the marked Petersen pair-sum
comparison, the degree-six zonal-harmonic cubic restricts exactly to
\(-784000\sigma_3/1247103\): a relative sign comparison between cubics on
different spaces, not an identification of their ambient harmonic
representations.

The same conference carrier has two independent structural consequences.
Cut-independence of the balanced exchange spectrum singles out order six.
Aligned four-sets reconstruct every two-graph on at least seven vertices
up to complement, with seven sharp; hence the determinant-\((-3)\)
four-blocks recover every symmetric conference signing of order at least
ten up to switching and global negation.  The characteristic-zero
incidence theorem is independent of the unresolved problem of determining
the exact finite set of primes over which the geometric incidence
comparison spreads out.
\end{abstract}
```

This is the current abstract with the proposal's three genuine upgrades and three
merges:

**Adopted from the proposal:**
- (a) "Under the marked Petersen pair-sum comparison" replaces "On the Petersen four-space" — names the marking the comparison depends on, matching the bridge proposition's β-map language.
- (b) "four-blocks" replaces "blocks" — closer to the theorem's "principal four-subsets with determinant −3".
- (c) "every symmetric conference signing" replaces "symmetric conference signings" — the theorem is universally quantified; the abstract should say so.

**Cut from the proposal, and why:**
- Both display equations — inlined; they fit, the incumbent proves it, and displays cost page-1 space for no clarity gain.
- "We determine its arithmetic square class exactly: if J₀ is … then the function field is …" — replaced by the current abstract's shorter direct statement; the square-class framing survives in "\(\sqrt{5J_0}\)" itself.
- Standalone sentences "These give the signed Joubert–Segre–Igusa–Clebsch chain." and "This is a relative sign comparison…" — merged into their neighbors (em-dash apposition and colon), saving words with no content loss. Em-dash apposition matches house usage (e.g. `sections/01-introduction.tex:279–281`).
- "with multiplication z²=5J₀" → "with z²=5J₀" — "multiplication" is inferable.

**Refused to cut:**
- The marked-bridge-datum sentence and "the sheet alone supplies none of that marking" — the paper's central caveat; red-team note 2 forbids shortening it and the paper states it three times.
- "relative sign comparison between cubics on different spaces, not an identification of their ambient harmonic representations" — forced by the no-intertwiner fact; dropping either half invites the misreading the appendix exists to block.
- The spreading-out caveat, in full — the only sentence keeping the arithmetic theorem scoped to characteristic zero.
- "seven sharp", "order at least ten", "up to complement", "up to switching and global negation" — each is a quantitative edge of a theorem.
- The exact coefficient, the exact normalization ι_t\*J₀ = 16σ₃², the Stein algebra, and the residue algebra — the paper's headline exact objects.

## 6. Separate manuscript issues (noted, not fixed) and C816 interaction

1. **C816 owns the Paper III abstract-headline decision.** The live queue row (notes/2026-07-07-codex-task-queue.md:113) lists "the abstract-headline decision" among C816's remaining deliverables, alongside the unlanded Theorem D rigidity statement and the hard-coded `\tag` cleanup. Adopting any replacement abstract now — the proposal's or this memo's — would pre-empt that decision. **This proposal conflicts with C816's scope on that one item**; the recommended abstract above should be handed to C816 as input, not applied by this task. Notably, C816's queue row also plans a "shorter balanced-exchange-rigidity proof that drops the switching normalization and R(3,3)=6" — a proof change would not alter the theorem statement the abstract cites, so the recommended abstract is stable against C816's other planned work.
2. **Stein-algebra qualifier.** The theorem's "after normalizing the anti-invariant summand" (`sections/01-introduction.tex:121–123`) is dropped by every abstract variant, current, proposed, and recommended. Deliberate; flagged so C816 can overrule.
3. **"switching" vs "diagonal switching".** The theorem says "diagonal switching" (`sections/05-golden-operator.tex:531`); all abstract variants say "switching". Standard shorthand; one word would restore verbatim fidelity if C816 prefers.
4. **Section file naming.** `sections/` contains two files with prefix 05 (05-golden-operator, 05-harmonic-realization), no 06, and two with prefix 09 (09-conclusion, 09-programme-coda); input order in `clebsch_passages.tex:73–84` is correct, so this is cosmetic residue of the C919 de-numbering, not a build issue.
5. **Preamble macro asymmetry.** This paper defines `\PSL` but not `\PGL`/`\PG`/`\PP` (`clebsch_passages.tex:21–24`), while the proposal's blanket style instruction assumes those exist "in each repository". Harmless here (unused in the Paper III block), but a cross-paper copy-paste hazard.
