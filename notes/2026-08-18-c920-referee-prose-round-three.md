# C920 referee report, round three: exposition, style, internal consistency

**Scope**: `git diff 3736b643a..a74cf275c -- papers/cubic-stabilization-m1/sections
papers/cubic-stabilization-m1/cubic_stabilization_m1.tex
papers/cubic-stabilization-m1/verification`, read against the committed blobs of
`a74cf275c` (the working tree matches the commit exactly this time). Exposition, style,
internal consistency of wording and cross-references. Mathematical correctness remains
another referee's charge.

**Verdict**: One sentence must change; after that, accept. The new passage now reads as one
coherent argument on a cold pass, and I would not ask for anything else in it. The single
blocker is a sentence added this round to `lem:ruled-degeneracy-dichotomy` which claims the
degenerate case never arises for a center specialization — it does arise, for exactly the
quadric-surface centers the roadmap two pages earlier singles out as the reason the product
formula is needed. Three round-two items were reported as applied but landed only partly
(the introduction's graded-monomial clause, "surface" in the scope phrase, one earlier
"There"). Everything else verified.

---

## Verification of the round-two items

1. **OK — item 0.** "centerd" is gone; no occurrence of "centre", "centred" or "centerd"
   anywhere in `sections/`, `verification/` or the main file. The manuscript is American
   throughout, matching the untouched Section 4 and the Lean identifiers.

2. **OK — items 1 and 2.** The introducing sentence now reads "The remaining centers are the
   rational geometrically ruled surfaces, that is the Hirzebruch surfaces \(F_a\); these are
   the minimal surfaces not yet covered, together with \(F_1\), which is geometrically ruled
   without being minimal", and `rem:tagging-scope` closes "The quartic of
   Lemma~\ref{lem:hirzebruch-euler-spectrum} was derived for the Hirzebruch surfaces and is
   not available for such a center, whose even cohomology has rank greater than four." Both
   are correct and the contradiction with \(F_1\) is gone. No instance of "minimal rational",
   "rational ruled surface", "minimal centers" or "nonminimal surface" survives in
   `sections/` or the verification JSON.

3. **OK — item 4.** "under an explicit change of Novikov variables" replaces the third sense
   of "monomial", and it is also the more accurate description of what the proof establishes.

4. **OK — item 8.** The heading is "*A single deformation to \(a\le1\).*", the justification
   clause is present, the semipositivity sentence now names what it licenses ("so the
   genus-zero invariants of \cite{McDuffSalamon} are defined and deformation-invariant for
   this family"), and "every symplectic four-manifold" matches the registry. The passage
   additionally gained the pullback description and the \(E_t\cong E_1\) argument, which
   closes a gap I had not raised.

5. **OK — item 9.** "only finitely many Novikov monomials survive"; "By the virtual dimension
   count, and by the fundamental-class axiom at the lower end". The paragraph also gained the
   closing rank-four surjection-is-an-isomorphism sentence, which was a real gap: without it
   the transported relations would only give a quotient, not the presentation used next.

6. **OK — items 10 and 11.** `prop:low-dimensional-vanishing` now reads "…and let \(\chi\) be
   a strictly Novikov-admissible specialization, graded-monomial when \(T\cong F_1\).  Then";
   the identity specialization is named and justified ("the identity map of \(\Lambda_T\),
   which is strictly Novikov-admissible with \(\ell=H\cdot(-)\) for an ample \(H\), and
   graded-monomial because its associated graded is the monoid algebra of the effective
   monoid"); the minimal-surface dichotomy is attributed to the Enriques--Kodaira
   classification. Naming the classification rather than adding a bibliography entry is the
   right weight for a classical input of this kind.

7. **OK — item 12.** All four lines over 100 columns are rewrapped; the longest added prose
   line is now 86, in line with the file's existing variance.

8. **OK — items 13, 14, 15, 16 (registries and lemma proof).** `evidence.json` says "a
   Hirzebruch surface" in both the note and the role. McDuffSalamon's `used` names \(F_a\)
   and \(F_{a\bmod2}\) directly, and the `domain` match now ends "its zero fibre is F_a, and
   every nonzero fibre is F_{a mod 2}". Givental's `used` carries the corroboration clause
   that Batyrev's already had. `lem:center-maps-monomial`'s proof says "the target ring
   \(A\) of \eqref{eq:center-novikov-specialization}". The README snapshot went 241→264
   reviewer terminals, consistent with the one Lean name added this round, and the claim
   counts still reconcile with the six new claim-carrying statements.

9. **OK — mechanical rechecks.** No duplicate `\label`; every `\ref`/`\eqref` in `sections/`
   and the main file resolves; equation tags in Section 5 run 5.0, 5.0a–c, 5.2, 5.3, 5.4,
   5.4a, 5.5, 5.5a, 5.5b, 5.6, 5.7, 5.8, 5.9, 5.9f–n, 5.11 with no duplicate and in file
   order; `dependency-graph.dot` carries all five new statements plus the four import nodes
   and the evidence node, with no stale label anywhere; the forbidden-word check and the
   chatbot-vocabulary check on the diff both come back clean. The new nodes have no
   solid-edge entries in the dependency graph, which matches how `prop:direct-specialized-lowdim`
   is already recorded, so nothing is out of line there.

## Findings

10. **MAJOR — the sentence added to `lem:ruled-degeneracy-dichotomy` this round is false for
    quadric-surface centers.** The lemma now closes:

    > "No other block shape occurs.  Case~(b) is recorded so that a degenerate specialization
    > is described rather than assumed away; by
    > Lemma~\ref{lem:center-specialization-nondegenerate} **it does not arise for any center
    > specialization**."

    `lem:center-specialization-nondegenerate` is stated for \(T=F_a\) with \(a\ge1\). At
    \(a=0\) the discriminant is \(2^{24}u^2w^2(u-w)^2\), which vanishes precisely when
    \(u=w\) — and the roadmap two pages earlier says in as many words that this happens:
    "\(\chi\) may send its two ruling classes to the same value and the quartic below then
    degenerates". A blowup center in a fourfold may be a quadric surface, so case (b) does
    arise for a center specialization, and the sentence contradicts both the roadmap and the
    first paragraph of `prop:hirzebruch-specialized-vanishing`. It also carries the
    review-dialogue framing the style guide asks to be cut ("is recorded so that … rather
    than assumed away"), which states an editorial choice instead of the mathematics.
    Replace the two clauses with the fact alone, scoped correctly:

    > "No other block shape occurs.  By
    > Lemma~\ref{lem:center-specialization-nondegenerate} and
    > Lemma~\ref{lem:center-maps-monomial}, case~(b) does not arise for a center
    > specialization when \(a\ge1\); for \(F_0\) it can, which is why that surface is
    > treated by the product formula in
    > Proposition~\ref{prop:hirzebruch-specialized-vanishing}."

    While making that change, add the range to the title of the lemma it cites —
    "Strictly admissible specializations avoid the degeneracy locus for \(a\ge1\)" — since
    the unqualified title is what invites the overstatement.

11. **MINOR — round-two item 5 was not applied.** The introduction still reads

    > "for every rational geometrically ruled surface---for **one of them** on
    > specializations of a mild graded-monomial form that every center specialization
    > **has**---"

    while the Section 5 opening says it cleanly ("for \(F_1\) on specializations that are
    graded-monomial in the sense of Definition~\ref{def:monomial-specialization}, as every
    center specialization is"). \(F_1\) appears nowhere in the introduction. Replace with:

    > "for every rational geometrically ruled surface---for the Hirzebruch surface \(F_1\),
    > on specializations satisfying a mild condition that every blowup center satisfies---"

12. **MINOR — round-two item 7 was applied in Section 6 but not in the introduction, and one
    place in Section 5 was missed.** Six statements carry the scope phrase; three now say
    "surface centers that are neither minimal nor geometrically ruled" and three still say
    "centers that are neither minimal nor geometrically ruled":
    `sections/01-introduction.tex:222`, `sections/01-introduction.tex:230`, and
    `sections/05-framed-monodromy.tex:1119` inside `rem:tagging-scope`. Since a
    weak-factorization center may be a point or a curve, and those are vacuously neither
    minimal nor geometrically ruled, the short form reads as a wider restriction than
    intended. Insert "surface" in all three.

13. **MINOR — round-two item 17 is still open.** In "The two base cases":

    > "The same two relations can be read off directly from the genus-zero invariants of
    > \(F_1\), which is how we use them; the toric presentation is recorded as a check.
    > **There** \(c_1\cdot(mf+ns_0)=2m+n\), so…"

    "There" reaches back across the intervening clause about the toric presentation. Write
    "On \(F_1\), \(c_1\cdot(mf+ns_0)=2m+n\), so…".

14. **MINOR — the roadmap's two routes read as though they collide at \(F_0\).** Within four
    lines the reader is told that \(F_0\) "is handled separately by the Gromov--Witten
    product formula" and then that "one deformation carries the genus-zero theory of \(F_a\)
    to that of **\(F_0\) or \(F_1\)**". Both are true — \(F_0\) is a base case for the
    presentation and a separate case for the vanishing statement — but the second mention
    looks like a contradiction of the first on a cold read. Four words fix it: "…to that of
    \(F_0\) or \(F_1\), whose quantum relations serve as the base cases, under an explicit
    change of Novikov variables".

15. **MINOR — one sentence in the deformation passage runs two independent claims through a
    semicolon-and.**

    > "These form a vector bundle on \(\PP^1\times\A^1\), and scaling a nonzero extension
    > class by a unit leaves the middle term unchanged, so \(E_t\cong E_1\) for every
    > \(t\ne0\); and its projectivization is a smooth projective family with…"

    By the time "its projectivization" arrives, the subject has been displaced twice. Split:
    "These form a vector bundle on \(\PP^1\times\A^1\).  Scaling a nonzero extension class by
    a unit leaves the middle term unchanged, so \(E_t\cong E_1\) for every \(t\ne0\).  The
    projectivization of the family is smooth and projective, with…"

16. **MINOR — "negative section" is a misnomer at \(a=0\), where the proof uses it.** The
    transport paragraph writes "\(s_0\) the negative-section class of \(F_{a-2k}\)" and the
    base-case paragraph uses \(s_0\) on \(F_0\), where every section has self-intersection
    zero and \(s_0\) is simply the other ruling class. The lemma statement anticipates the
    ambiguity ("For \(a=0\) either ruling may be taken as the fibre"), but the proof does not
    close it. Add a parenthesis at first use: "\(s_0\) the negative-section class of
    \(F_{a-2k}\) (for \(F_0\), the other ruling class)".

17. **MINOR — one orientation sentence sits mid-chain.** In
    `prop:hirzebruch-specialized-vanishing`, "This case is the \(\chi\)-specialized analogue
    of that proposition." falls between the tensor-decomposition step and the sentence
    explaining what the product route buys, interrupting the causal chain. It orients better
    at the head of the paragraph: "Let \(a=0\), so \(T=\PP^1\times\PP^1\); this case is the
    \(\chi\)-specialized analogue of Proposition~\ref{prop:projective-product-nu} below."

18. **MINOR, residual — `lem:center-maps-monomial` remains the one new statement with
    `\coverage{absent}`, and it is a premise of `thm:nu6-birational-invariance`.** Round two
    offered two ways to settle this; neither was taken, and the count in the verification
    README moved from 5 to 6 absent without comment. This is recorded correctly rather than
    hidden, so it is not a defect, but a referee reading the trust boundary will want to know
    that the graded-monomiality of the center maps is argued in the text only. One sentence
    in the verification README, or the corresponding Lean instance, closes it.

## Cold read of the passage

19. Read as a referee seeing it for the first time, from "The remaining centers are the
    rational geometrically ruled surfaces" through the end of the proof of
    `prop:low-dimensional-vanishing`, the passage holds together. The governing mechanism is
    visible before any technical load: the reader is told which surfaces are left, why the
    projective-bundle route is unavailable for them, that \(F_0\) needs its own argument and
    why, and which two facts carry the rest. The extra condition on \(\chi\) is motivated one
    paragraph before it is defined, its name is explained against the existing use of
    "monomial", and it is discharged for the specializations that actually occur immediately
    afterwards, so the reader never carries an unexplained hypothesis. The spectrum proof's
    four labelled steps are a genuine sequence rather than a list — divisor classes, one
    deformation with an explicit transport, two base presentations, a truncation that makes
    the presentation finite and identifies it with the specialized ring, and only then the
    matrices — and each step's output is consumed by the next. The dichotomy, the
    nondegeneracy lemma and the proposition then close the argument in three short moves, and
    `rem:tagging-scope` and `prop:low-dimensional-vanishing` state the resulting scope in the
    same words used in the Section 5 opening. Apart from item 10, which is a factual
    overstatement rather than a gap in the argument, and the small frictions in items 11–17,
    I found nothing worth changing.
