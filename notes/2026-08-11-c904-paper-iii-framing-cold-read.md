# C904 Paper III framing cold read

Date: 2026-08-11
Artifact read first and in full: `papers/clebsch-passages/clebsch_passages.pdf` (33 pages)
Scope: framing, theorem-package separation, quantifiers, characteristic-zero/integral boundary, standalone readability, copy edit, support, repetition, and overclaim.
Method boundary: the complete PDF was read before any manuscript source, old report, note, handoff, or history. Source was then inspected only to locate the fixes below. No old review was consulted.

## Verdict: MINOR

The current PDF works as a standalone paper. A cold reader can distinguish all three theorem packages:

1. the arithmetic quadratic incidence cover;
2. the marked operator/source-return package, whose comparison is relative to an explicitly fixed marking; and
3. the independent conference-spectrum and two-graph reconstruction theorems.

The abstract, introduction, and conclusion present those packages in the same order and with the same logical dependencies. The characteristic-zero theorem is not silently promoted to a finite-characteristic incidence theorem: the PDF consistently separates the abstract integral quadratic algebra from the unresolved integral spreading of the geometric incidence comparison. I found no major quantifier failure or unsupported headline theorem. The remaining defects are local: one undefined symbol in the introduction, internal-looking evidence pointers without a standalone locator, one malformed displayed citation, one apparently unused reference/missing citation, and repeated route-signposting.

## What succeeds on a cold read

### The three packages are visibly separate

- PDF p. 1 gives one abstract paragraph to each package. The third begins: “The same conference carrier has two independent structural consequences.” This prevents the conference-spectrum and reconstruction theorems from being read as hypotheses for the cover or harmonic theorem.
- PDF p. 2 makes the logical split unusually explicit: “The first inverse question is arithmetic”; “The second is marked”; “The third is independent of Hitchin's cover.”
- PDF p. 4 repeats the dependency boundary at the theorem level: “The next two results are standalone structural consequences. They use the conference carrier but neither assume Hitchin's cover nor supply a hypothesis to the source--shadow--return argument.”
- PDF p. 28 closes in the same order and again says of the independent results: “These results describe what the carrier remembers without supplying a hypothesis to the source--shadow--return comparison.”

This is enough separation. Indeed, the paper now over-signposts the distinction slightly; see the repetition finding below.

### The marked package states the right limitation

The strongest framing feature is that the paper does not let “sheet” silently mean “marking.”

- PDF p. 1: “The sheet alone supplies none of that marking.”
- PDF p. 3: “The normalized component alone is not asserted to determine (m).”
- PDF p. 3: “Here (Z_m) and \(\sigma_3\) are different cubics on spaces of dimensions five and four. The proposition compares their orientations relative to (m); it does not identify their polynomial domains.”
- PDF p. 12: “No global marking of the varying configurations on (B_-) is needed or asserted.”
- PDF p. 26: “It still supplies no map between the two ambient harmonic spaces.”

These qualifications are aligned, not contradictory. The phrase “a chosen sheet selects” in the abstract is safe because it is preceded by the fixed marked bridge datum, though “labels a sheet by the source or its opposite” would make the conventional part of the attachment even harder to misread.

### Quantifiers and field boundaries check out

- Arithmetic cover, PDF p. 3: Theorem 1.1 is explicitly over \(\mathbf Q(\mathbf P(H))\), with the Clebsch chart over \(\mathbf Q(\sqrt5)\) and the complete reduced fibre over the rational point \([xyz]\). It does not claim an integral geometric model.
- Marked normalization, PDF pp. 3--4 and 11--12: Proposition 1.2 fixes a marked bridge datum (m), works on (B=\mathbf P(V_E)), distinguishes the normalization from the meeting of the unnormalized branches, and confines the literal two-configuration statement to (D(\sigma_3)).
- Operator theorem, PDF p. 16: Theorem 5.1 begins “For a marked bridge datum and its coherent outer family,” so none of the labels or determinant-line orientations is tacitly canonical.
- Exchange theorem, PDF p. 19: Theorem 5.3 quantifies over a symmetric conference matrix of order (2d). Its “if and only if (d\leq3)” is followed by the accurate realized-order qualification: “order six is the unique nontrivial realized symmetric conference order with this property.”
- Reconstruction theorem, PDF p. 21: Theorem 5.4 says every two-graph on |V| at least seven is determined up to complement; its conference consequence is separately restricted to order (n\geq10) and to switching plus global negation. The labelled/“marked family” status is visible.
- Harmonic theorem, PDF pp. 25--26: Theorem 6.1 uses the explicitly labelled real face axes and asserts an injective copy of (V) in (\mathcal H_6), not an ambient degree-three/degree-six intertwiner.
- Integral boundary, PDF p. 10: the abstract algebra is finite locally free over \(\mathbf Z\) and finite etale on (D(10J_{\mathbf Z})), while “This abstract integral algebra does not by itself give an integral incidence theorem.” The geometric comparison is only over some unspecified \(\mathbf Z[1/N]\). PDF pp. 13--14 separately preserve the explicit golden specialization and refuse to infer a global finite-field incidence theorem. PDF p. 28 states the same boundary in the conclusion.

This characteristic-zero/integral-spreading boundary is exact and unusually well protected. It is repeated more often than necessary, but it is not blurred.

### Abstract/introduction/conclusion alignment

The alignment passes:

- Abstract: arithmetic cover; marked operator/harmonic comparison; two independent combinatorial theorems; unresolved spreading boundary.
- Introduction: the same three questions, followed by the cover theorem, marked proposition, descriptions of Theorems 5.1 and 6.1, then a separate paragraph for Theorems 5.3 and 5.4.
- Conclusion: the same three blocks in the same order, followed by the same integral boundary.

There is no conclusion-only claim and no abstract headline that disappears in the body.

### Effect of removing the repeated series map

The removal improves standalone readability. The current PDF contains no Paper I/II dependency map and never asks the reader to reconstruct a series-wide route before understanding this paper. The main route is now paper-local and visible in Figure 1 and the “First-pass route” paragraph.

Only one cross-paper pointer remains, on PDF p. 2: “Paper V later compares the conference shadow with a chordal companion after an additional marking [1]; it supplies no hypothesis here.” It does not create a dependency, but it is dispensable. Removing that sentence and reference [1] would make the opening wholly paper-local; retaining it is a minor editorial choice, not a standalone defect.

## Findings to fix

### 1. Define (J_{\mathbf Z}) before its introduction use

PDF p. 4 says: “The abstract equation (z^2=5J_{\mathbf Z}) is etale on (D(10J_{\mathbf Z})), but its comparison with the geometric incidence variety is proved only after inverting an unspecified integer.” The symbol (J_{\mathbf Z}) is not defined until PDF p. 10: “Choose a full lattice ... and an integer (a\neq0) such that (J_{\mathbf Z}=a^2J_0) has integral coefficients.”

This is the clearest cold-read stumble in the introduction. Either define it parenthetically on p. 4 (“for an integral square rescaling (J_{\mathbf Z}) of (J_0)”) or state the boundary there without the new symbol. Source locator: `sections/01-introduction.tex:268`.

### 2. Replace or remove internal-looking evidence pointers

PDF p. 24 says: “Row OPER-4 of the public claim--proof--novelty ledger records the search depth and access gaps”; PDF p. 25 then says: “Row OPER-3 of the same public ledger records the bounded search scope.” The PDF supplies neither a citation nor a stable locator for this ledger. To a standalone reader these look like project-management residue, and the second reference is especially fragile because “the same public ledger” crosses a page and a topic boundary.

Appendix B has the related unsupported locator on PDF p. 30: “The verification directory distributed with the paper contains the exact programs, canonical certificates, checksums, toolchain requirements, and aggregate replay command.” If the directory is genuinely part of a submission bundle, say exactly where; if it is archival, give the stable URL/DOI and version. The same remedy can make OPER-3/4 meaningful. Otherwise delete the two body-level ledger sentences and keep only the neutral bounded-search qualification.

Source locators: `sections/05-golden-operator.tex:777`, `:786`; `sections/08-verification.tex:81`.

### 3. Fix the citation glued to a displayed equation

PDF p. 6 renders:

> “\(V_t\cap V_{1-t}=E\cdot xyz[2, Proposition 7].\)”

The citation is visually part of the mathematical right-hand side. Move “[2, Proposition 7]” into the preceding sentence or place it after the display as prose. Source locator: `sections/02-orientation-cover.tex`, the display immediately following “intersection theorem therefore gives” (currently the `\cite` is inside the display).

### 4. Resolve the uncited “invert 30” assertion and apparently stale reference [6]

PDF p. 10 says: “the available binary-sextic formulae justify their classical invariant presentation only after inverting 30,” but gives no citation at that sentence. Reference [6] on PDF p. 31 is Krishnamoorthy--Shaska--Völklein, *Invariants of binary forms*, and appears nowhere else in the PDF. This looks like either a dropped citation or an unused stale bibliography entry.

If [6] proves the precise integrality statement being used, cite its exact result here and make clear how it yields inversion of 30. If it does not, qualify or justify the sentence and remove [6]. This is a support/housekeeping issue, not a challenge to the conservative conclusion that the exact exceptional set is unknown. Source locator: `sections/02-orientation-cover.tex:414`; reference entry in `sections/10-references.tex`.

### 5. Compress repeated route-signposting

The package separation is already secured by the abstract, PDF p. 2's three-question paragraph, the first-pass route, and PDF p. 4's “standalone structural consequences” paragraph. Later instructions repeat the same navigation:

- PDF p. 14: “A reader following the source--shadow--return argument may then continue directly to Section 6.”
- PDF p. 19: “For the main source--shadow--return route, continue with Section 6. The next two subsections use the same conference carrier but supply no hypothesis for Theorem 6.1.”

Keep one of these, preferably the section-opening version on p. 14, and cut the p. 19 repetition. The conclusion's dependency reminder is useful because it closes the paper's three-package structure; it need not be cut.

### 6. Optional precision in the abstract's marked claim

PDF p. 1 says: “After an ordering, chart lift, outer labels, and Petersen labels are fixed as a marked bridge datum, a chosen sheet selects an order-six conference source or its opposite.” The body later says on PDF p. 12 that the source is attached to the component “by definition,” with the golden-fibre calculation proving compatibility.

There is no false claim because the marking is explicitly fixed first. Still, changing “selects” to “labels the two sheets by the source and its opposite” (or equivalent) would make the theorem/convention boundary maximally transparent. Treat this as optional polish, not a correctness repair.

## Overclaim and theorem-support assessment

No headline overclaim found.

- The arithmetic result claims an exact characteristic-zero function field and Stein algebra, not an integral geometric comparison.
- The marked bridge does not claim the sheet canonically supplies labels or identifies ambient harmonic representations.
- The two combinatorial theorems are explicitly standalone.
- The finite-field golden fibre and exchanger are not used to replace the unknown spreading set by (p\neq2,5).
- The harmonic result claims a restriction on a labelled four-space and expressly disclaims priority for the ambient icosahedral decomposition and bond-order invariant.

The only theorem-support presentation gap visible from the PDF is artifact discoverability: Appendix B describes strong exact and Lean support but does not give the standalone reader a stable path to it. The “invert 30” sentence also needs its missing exact citation or justification.

## Cheap closeout upgrades (`ej` + `tt`)

The highest-value cheap edit is not another overview. It is to consolidate the logical status in one place and remove repetitions elsewhere:

- keep the three-question paragraph on p. 2;
- keep one first-pass route;
- keep one sentence that Theorems 5.3--5.4 are independent;
- keep the p. 10 algebra-versus-geometry boundary;
- delete the duplicate p. 19 route instruction and body-level OPER pointers unless they receive stable locators.

A skeptical expert's likely question is whether “sheet selects source” is a theorem or a sign convention. The paper already answers this on pp. 11--12; the optional abstract wording change above would answer it before the question arises.

## Mystery ledger

- **Exact spreading integer (N): open by design.** The paper identifies the missing integral model, flatness, normality, Stein-base-change, and chart-section steps on PDF p. 10. No defect: this is an explicit open boundary, not an unexplained omission.
- **Why inversion of 30 is justified: evidence gap in the PDF.** Owner: the p. 10 integral-boundary paragraph. Close by an exact citation/derivation, plausibly involving current reference [6], or weaken/delete the claim.
- **Where the public ledger and verification directory live: evidence gap in the PDF.** Owner: Appendix B/artifact release metadata. Close with a stable archived locator and version or remove the internal row references.
- **No other genuine framing mystery remains.** The source of the factor 5, the role of the marking, the independence of Theorems 5.3--5.4, and the characteristic-zero/integral boundary are all explicitly explained.

## Acceptance summary

**MINOR.** Fix items 1--4 before release; item 5 is a worthwhile compression; item 6 is optional. None requires changing a theorem statement or proof architecture.

---

## Semi-blind A/B addendum

Date: 2026-08-11
A: the 33-page PDF used for the cold read above.
B: the rebuilt 33-page `papers/clebsch-passages/clebsch_passages.pdf` inspected after the scoped manuscript diff.
Inspection boundary: only the scoped diff under `papers/clebsch-passages/` and PDF B were inspected. No old report beyond A, handoff, history, or unrelated source was consulted. No manuscript edit was made.

### B verdict: MINOR

B resolves the mathematical/framing issues without strengthening either the integral-spreading claim or the marked-source theorem. The one remaining defect is evidence navigation: two body sentences claim that Section B summarizes novelty-audit scope and access gaps, but Section B does not contain that summary. The artifact locator is better but still relative to an unspecified “distributed source archive.” Thus B is materially better than A and mathematically safe, but not yet a clean PASS under a hostile-referee standard.

### Fix-by-fix verification

1. **(J_{\mathbf Z}) definition: PASS.** PDF B p. 4 now says: “For an integral square rescaling (J_{\mathbf Z}) of (J_0), the abstract equation (z^2=5J_{\mathbf Z}) is etale on (D(10J_{\mathbf Z})).” This gives the symbol an operational definition before use. PDF B p. 10 retains the exact construction (J_{\mathbf Z}=a^2J_0). The new p. 4 wording does not claim a canonical lattice, canonical rescaling, or a geometric integral incidence model.

2. **Displayed citation: PASS.** PDF B p. 6 now displays only “(V_t\cap V_{1-t}=E\cdot xyz.)” and follows it with the prose sentence “This is Hitchin's intersection theorem [2, Proposition 7].” The citation no longer appears as a factor in the equation. There is slight verbal repetition (“intersection theorem ... This is ... intersection theorem”), but no remaining copy-edit ambiguity.

3. **Binary-form citation: PASS with a pinpoint-citation caveat.** PDF B p. 10 replaces the stronger uncited formulation with: “standard integral presentations of the binary-sextic invariants used in the comparison introduce the primes (2,3,5) [6].” Reference [6] is now used, and the sentence no longer claims that the source proves the entire comparison “only after inverting 30.” The next sentence still says only that one may enlarge the unknown (N) so that (2,3,5\mid N); it does not assert that these are the exact bad primes. Under the permitted A/B scope I did not inspect [6] externally, so source-level verification of the precise primes remains outside this addendum. A section/page pinpoint in [6] would make the support referee-proof.

4. **Route compression: PASS.** PDF B p. 14 keeps the useful first-pass direction: “A reader following the source--shadow--return argument may then continue directly to Section 6.” PDF B p. 19 has deleted the second “continue with Section 6” instruction and retains only the dependency boundary: “The next two subsections use the same conference carrier but supply no hypothesis for Theorem 6.1.” The retained sentence is logically useful because it separates the two standalone theorem packages; it is no longer duplicate navigation.

5. **Abstract sheet/source wording: PASS.** PDF B p. 1 now says: “After an ordering, chart lift, outer labels, and Petersen labels are fixed as a marked bridge datum, the two sheets are labelled by an order-six conference source and its opposite.” “Are labelled” accurately presents the theorem/convention boundary and is weaker and clearer than A's “a chosen sheet selects.” It remains immediately qualified by “The sheet alone supplies none of that marking.” PDF B p. 4 still states the actual proposition as “Relative to (m), equip (B_+) with the source ... and equip (B_-) with its deck-opposite,” so the abstract does not promote the attachment into a canonical source recovered from an unmarked sheet.

6. **Evidence navigation: MINOR remains.** PDF B p. 24 says: “The scope and access gaps of that audit are summarized in Section B.” PDF B p. 25 similarly says: “The bounded search scope is recorded with the distributed source archive and summarized in Section B.” But PDF B pp. 29--31, Section B, describe exact-arithmetic bundles, Lean coverage, trust boundaries, and the top-level `verification/` directory; they do not state the OPER-3/OPER-4 search scope or access gaps. The new cross-references are therefore inaccurate. Either add the promised concise novelty-audit summary to Section B or delete “and summarized in Section B” in both places.

7. **Artifact locator: improved, residual MINOR.** PDF B p. 30 now says: “The top-level `verification/` directory in the distributed source archive contains the exact programs, canonical certificates, checksums, toolchain requirements, and aggregate replay command.” This is a usable relative path if the source archive is guaranteed to accompany the PDF, and it is much better than A's unlocated “verification directory distributed with the paper.” For a durable standalone PDF, however, “the distributed source archive” still has no stable URL, DOI, release tag, or bibliographic locator. A single archival locator would close both artifact discoverability and the novelty-ledger reference.

### Hostile-referee checks

- **Three-package independence: PASS.** PDF B p. 1 calls the spectrum and two-graph results “two independent structural consequences”; p. 2 calls the third inverse question “independent of Hitchin's cover”; p. 4 says the results “neither assume Hitchin's cover nor supply a hypothesis to the source--shadow--return argument”; and p. 19 repeats only the local no-hypothesis boundary. The repetition is now proportionate.
- **Exact square-class theorem: PASS.** PDF B pp. 1 and 3 still assert exactly \(\mathbf Q(\mathbf P(H))(\sqrt{5J_0})\), with \(\iota_t^*J_0=16\sigma_3^2\), complete reduced fibre \(\mathbf Q(\sqrt5)\), and Stein algebra \(\mathcal O\oplus\mathcal O(-3)\), \(z^2=5J_0\). None of the edited prose replaces the fibre argument, changes the normalization, or promotes the equation to a geometric integral theorem.
- **Integral-spreading boundary: PASS.** PDF B p. 1 says the exact finite set of spreading primes is unresolved; p. 4 says comparison with the geometric incidence variety requires inversion of an unspecified integer; p. 10 says “This abstract integral algebra does not by itself give an integral incidence theorem” and retains an unspecified \(\mathbf Z[1/N]\); p. 14 says the explicit good reduction at 11 does not replace the finite exceptional set by (p\ne2,5). The binary-form edit does not narrow the unknown exceptional set.
- **Theorem versus convention: PASS.** The abstract's “are labelled,” Proposition 1.2's “Relative to (m), equip,” and Appendix A's “negated by definition” agree. The golden-fibre calculation remains the compatibility theorem; no global unmarked conference labelling is asserted.
- **Novelty audit phrasing: MINOR.** “We have not located ... in the bounded audit” is appropriately modest and avoids an unsupported novelty claim, but the promised Section B summary is absent. This is navigation/support residue, not an overclaim about priority.
- **Artifact locator: MINOR for standalone durability.** The relative directory is clear; the archive itself is not persistently identified in the PDF.

### A/B conclusion

B is better than A on every targeted edit. The theorem statements and logical boundaries remain intact, the marked sign is now unmistakably a relative labelling convention, and the route is shorter. Promote B to **PASS** after correcting the two false “summarized in Section B” claims and, ideally, adding one stable source/archive locator. The binary-form citation would also benefit from an exact section or proposition, but its present wording does not strengthen the theorem.

**Final targeted closure — PASS (2026-08-11).** PDF p. 30 now states that top-level `literature-boundaries.md` records the bounded priority audits and that OPER-3/4 give the “search domains, read depths, and access gaps” for the exchange-spectrum and two-graph claims, making the Section B cross-references on pp. 24--25 exact. PDF p. 10 now claims only that the cited positive-characteristic binary-sextic comparison “is proved only in characteristic greater than five”; it does not identify the exact spreading set or strengthen the integral incidence theorem. No residual in the targeted closure scope.
