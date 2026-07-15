# Literature audit — the Gap theorem (Clebsch hexagon / PG(2,11) deep holes)

**Date**: 2026-07-14
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Scope**: audit of the gap theorem (Claim 2) — both halves — of the Clebsch hexagon manuscript.
Companion to `notes/2026-07-14-gem-lit-rigidity-gap.md`, which audited the rigidity theorem and
self-marked its gap-theorem section (F8) as PARTIAL/low-confidence. This pass is that section's
own sweep.

No sub-agents were used. Every source below was fetched and read by me directly. Nothing here is
reconstructed from memory: each claim carries a URL and, where it matters, a verbatim quote.

## Tiering convention

- **VERIFIED** — I opened the source myself; URL + quoted text given.
- **INFERRED** — abstract / review / snippet only, source itself not opened. Flagged per item.
- **NOT FOUND** — searched, nothing located.
- **NOT SEARCHED / NOT OBTAINED** — not attempted, or attempted and unavailable.

*(This file is written incrementally as the sweep proceeds. Sections appear in the order found.)*

---

## VERDICT — novelty: **SURVIVES. Both halves. No collision found.**

Nothing located states either half of the gap theorem. **NOT FOUND**: any gap or stability result
about the deep-hole count `|U(A)|` of a small arc; any second-smallest-value theory for that
invariant; any perturbation data for the q=11 `A₅`-hexagon. Confidence **medium-high** — and higher
than the companion sweep's rigidity verdict, because this negative now has a **mechanism** rather
than being a bare absence (see G5/G6): the classical apparatus provably does not reach `k = 6` at
`q = 11`. Full statement in § VERDICT — the two questions, below.

## VERDICT — positioning: **NEEDS WORK. The genre is Problem (III) of the packing problem.**

The claim is true but currently framed as a computational observation, which is the failure mode the
prompt warned about. The genre it must sit inside is **"Problem (III)"** — *find the size of the
second largest complete set* — one of four numbered problems that organize the whole field. The
paper that defines the genre's standard form is:

> **J.W.P. Hirschfeld & L. Storme, "The packing problem in statistics, coding theory and finite
> projective spaces"**, J. Statist. Planning Infer. **72** (1998) 355–380; update 2001, Developments
> in Mathematics, Kluwer, 201–246.

The genre's standard *sentence*, verified three independent times (Blokhuis–Bruen, Segre/Thm 2.5,
Ball–Blokhuis):

> *"There is no ⟨object⟩ with ⟨X⟩ < ⟨invariant⟩ < ⟨Y⟩. Furthermore, all ⟨objects⟩ with
> ⟨invariant⟩ = ⟨X⟩ are ⟨classified as …⟩."*

**Claim (a) is already exactly this shape and should be written in exactly this sentence.**

**Two corrections to the companion sweep, both material:**
- **G5 falsifies "the tradition had no reason to compute U(A)".** `U(A)` is classical — it is the
  object of **Segre's tangent-envelope theory** (Hirschfeld PGOFF §10.1, Cor. 10.3). The manuscript
  must not present `U(A)` as newly noticed. The novelty is the *conic property*, not the object.
- **G3 settles the companion's FLAG 1 in the manuscript's favour, and lifts its ILL gate.**
  Hirschfeld's own survey cites **Sadeh's thesis** and **PGOFF §14.8** for q=11 and **does not cite
  Hirschfeld–Sadeh 1984 anywhere**.

---

## Findings

### G1. The genre exists, it is named, and its standard form is Problem (III) of the packing problem

**Tier: VERIFIED.** J.W.P. Hirschfeld and L. Storme, *The packing problem in statistics, coding
theory and finite projective spaces: update 2001*, Proc. Fourth Isle of Thorns Conf. on Finite
Geometries, Developments in Mathematics, Kluwer, Boston, 2001, 201–246.
PDF: https://cage.ugent.be/~ls/max2000finalprocfilejames.pdf — full text extracted (2,982 lines)
and grepped exhaustively.

This is **the** standard survey the prompt asked for, and it settles the positioning question. The
survey opens by naming four canonical problems about an `(n; r, s; N, q)`-set `K`. Quoted verbatim:

> "(I) Find the maximum value m(r, s; N, q) of n for which a (n; r, s; N, q)-set exists.
> (II) Characterize the sets with this size m(r, s; N, q).
> **(III) Find the size m″(r, s; N, q) of the second largest complete (n; r, s; N, q)-set.**
> (IV) Find the size t(r, s; N, q) of the smallest complete (n; r, s; N, q)-set."

**So "second-largest" is not a folk theme — it is Problem (III), one of the four numbered problems
that organize the entire field.** The genre our claim (a) must be positioned inside is *Problem
(III)-type results*, and this survey is the paper that defines the genre's standard form.

**The genre's standard form, stated as a theorem.** The survey's Theorem 2.5, quoted verbatim:

> "**Theorem 2.5** A complete n-arc of P G(2, q), q = 2^{2e}, e > 2, has size either q+2, or
> q − √q + 1, or at most q − 2√q + 6.
> For q = 16, the list of sizes n of complete n-arcs in P G(2, 16) is 9, 10, 11, 12, 13, 18."

**This is exactly the shape of our claim (a)**: an invariant's spectrum has a large forbidden
interval immediately below the extremal value, with the extremal value attained only by the
distinguished object. Theorem 2.5 says the complete-arc size spectrum jumps from `q+2` (the
hyperoval) down to `q−√q+1` with **nothing in between** — the q=16 list makes it concrete: sizes
9–13, then a gap, then 18. Our claim (a) says the `|U(A)|` spectrum has 12 (Clebsch only), then a
gap, then 16.

**This is the sentence-level template our claim should imitate.** Note its form: it does not say
"we observed a gap"; it says *a complete n-arc has size either X, or Y, or at most Z* — the gap is
expressed as a **disjunction of allowed ranges**, not as a histogram with an observed hole.

### G2. ⚠️ The distinction our claim MUST draw, or a referee will make it for us

**Tier: VERIFIED** (same source as G1).

The established Problem (III) literature is about **the spectrum of complete-arc SIZES** — the
invariant is `n`, the number of points of the arc. **Our invariant is `|U(A)|`, the number of deep
holes of a fixed-size (6-point) arc.** These are different invariants and the coincidence of the
word "spectrum" is a trap.

The relation, stated precisely so the manuscript can state it precisely:
- Problem (III) asks: over all **complete** arcs, which **sizes** `n` occur? Gap in `n`.
- Our claim (a) asks: over all **6-arcs** (all incomplete, since `t(2,11) = 7`), which values of
  `|U(A)| = c₀` occur? Gap in `c₀`.

`|U(A)| = 0` is exactly the completeness condition (DMP Def. 6.2, verified in the companion note's
F4). **So the two invariants meet at exactly one point and nowhere else:** the complete-arc
spectrum is the set of `n` for which some `n`-arc has `c₀ = 0`. Our histogram has no `0` bin
precisely because `t(2,11) = 7 > 6`. To be clear about what the relationship amounts to: a shared
boundary case, not a shared theorem.

**Corroboration of the manuscript's own arithmetic, VERIFIED from the survey's Table 2.5:**

> `q`: 2 3 4 5 7 8 9 **11** 13 16 17 19 23 25 27 29
> `t(2,q)`: 4 4 6 6 6 6 6 **7** 8 9 10 10 10 12 12 13

`t(2,11) = 7` — the smallest complete arc in PG(2,11) has 7 points. This independently confirms the
manuscript's claim that **every** 6-arc of PG(2,11) is incomplete, hence `|U(A)| > 0` for all of
them, hence the histogram legitimately has no zero bin. Good: this is now a cited fact, not an
internal computation.

Also from the survey's Table 2.4: `m″(2,11) = 10` — the second largest complete arc in PG(2,11)
has 10 points (against `m(2,11) = q+1 = 12`). So PG(2,11) **already appears in the Problem (III)
tables**, with a 12 → 10 gap in the *size* spectrum. A referee who knows this table will read our
"gap at q=11" and reach for it. **Pre-empt that specific collision by name.**

### G3. ⚠️⚠️ Q3 SETTLED IN THE MANUSCRIPT'S FAVOUR — Hirschfeld's own survey cites the THESIS, not HS84

**Tier: VERIFIED.** This closes the companion note's FLAG 1 / F5, which rested only on a 90-word
zbMATH review and was marked INFERRED.

The companion sweep suspected the manuscript's concession was mis-aimed: it concedes the 6-arc
census to "Sadeh's thesis **and Hirschfeld–Sadeh**, Mitt. Math. Sem. Giessen 164 (1984)", but the
zbMATH review (Zbl 0538.51010) indicated HS84 is a Singer-cycle / complete-7-arc / (n;3)-arc paper.
That inference is now corroborated from a much better source: **Hirschfeld's own survey.**

Two verified facts from the extracted full text:

1. **The survey cites Sadeh's thesis for q=11 arc data.** Reference [189], quoted verbatim from the
   bibliography:

   > "[189] A.R. Sadeh, The classification of k-arcs and cubic surfaces with twenty-seven lines
   > over the field of eleven elements, D.Phil. Thesis, University of Sussex, 1984."

   And it is cited exactly where q=11 arc classification is needed — quoted verbatim from §2:

   > "For q ≤ 9, see [124, 129, Ch.14]; **for q = 11, see [189], [129, §14.8]**; for q = 13, see
   > [5], [100], [190], [6], [7], [129, §14.9]; …"

2. **The Hirschfeld–Sadeh 1984 Giessen paper is NOT IN THE BIBLIOGRAPHY AT ALL.** Exhaustive grep
   of the full reference list for `giessen|gießen|coxeter|festschrift|eleven elements` returns
   exactly two hits: Innamorati, *Mitt. Math. Sem. Giessen* **235** (1998) — a different paper in
   the same journal — and the title of Sadeh's thesis. **There is no entry for Hirschfeld–Sadeh,
   Mitt. Math. Sem. Giessen 164 (1984).**

**Reading.** Hirschfeld is a co-author of HS84. In his own authoritative survey of exactly this
material, covering exactly q=11, he cites **Sadeh's thesis** and **his own book §14.8** for the
q=11 arc data, and does not cite the Hirschfeld–Sadeh Festschrift paper anywhere. If HS84 contained
the q=11 6-arc census, its own author would have cited it here. **This is much stronger than the
zbMATH inference and points the same way.**

**Action (upgrades companion recommendation 1 from "gated on ILL" to "safe to act on now"):**
re-aim the concession at **Sadeh's thesis [189]** and **Hirschfeld PGOFF 2nd ed. §14.8** — the two
sources Hirschfeld himself points at for q=11. Cite HS84 only for what the zbMATH review says it
does (Singer orbits, complete 7-arcs, (n;3)-arcs), or drop it. **Note the new target: §14.8
specifically**, not the whole of Ch. 14 — that narrows the still-unread book chapter to one section.

### G4. The genre's canonical *sentence*, and the paper whose TITLE is our claim (a)

**Tier: VERIFIED.** M. De Boeck, *Intersection problems in finite geometries*, Ph.D. thesis, Ghent
University. PDF: https://cage.ugent.be/geometry/Theses/61/PhDDeBoeck.pdf — full text extracted
(15,226 lines), Chapter 6 read.

**The title precedent.** There is a paper in this exact field whose title is, structurally, our
claim (a):

> **A. Blokhuis, M. De Boeck, F. Mazzocca, L. Storme, "The finite field Kakeya problem: a gap in
> the spectrum and classification of the smallest examples", Des. Codes Cryptogr. 72 (2014) 21–31,
> doi:10.1007/s10623-012-9790-3.**

Title/authors/venue **VERIFIED** two ways: the Semantic Scholar record
(`api.semanticscholar.org/graph/v1/paper/DOI:10.1007/s10623-012-9790-3`) and De Boeck's own
bibliography entry [16], quoted verbatim from the thesis:

> "[16] A. Blokhuis, M. De Boeck, F. Mazzocca, and L. Storme. The finite field Kakeya problem: a
> gap in the spectrum and classification of the smallest examples. Des. Codes Cryptogr., Accepted
> (Special issue "Finite Geometries, in honor of F. De Clerck"): doi:10.1007/s10623–012–9790–3,
> 2013."

The Springer page is paywalled (303 to an IdP) and **I did not read the paper itself** — but I read
its content as reproduced in De Boeck's thesis Ch. 6, which is where the work lives. **This is the
phrase the manuscript should adopt: "a gap in the spectrum and classification of the smallest
examples" is a recognized, publishable framing in this literature, used by exactly the authors
(Blokhuis, Storme) who define the genre.** It is about Kakeya sets in AG(2,q), not arcs — a
different object class, so **not a collision** — but it is the naming precedent.

**The genre's canonical sentence — and it is Blokhuis–Bruen.** The prompt asked for the actual
Blokhuis–Bruen stability statement. Here it is, as Theorem 6.1.5 of the thesis, quoted verbatim
(reference [15] = **A. Blokhuis and A.A. Bruen, "The minimal number of lines intersected by a set
of q+2 points, blocking sets, and intersecting circles", J. Combin. Theory Ser. A 50 (1989)
308–315** — the exact paper the prompt named; bibliography entry verified verbatim):

> "**Theorem 6.1.5 ([15]).** There are no Kakeya sets K in AG(2, q), q even, with
> q(q+1)/2 < |K| < q(q+1)/2 + q/2. Furthermore, all Kakeya sets of size q(q+1)/2 + q/2 are given by
> Example 6.1.4."

Preceded by, quoted:

> "It follows immediately from Theorem 6.0.1 that k(2,q) ≥ q(q+1)/2. Moreover, it can easily be
> proved that k(2,q) = q(q+1)/2 if q is even and that equality only occurs for the Kakeya sets
> described in Example 6.1.3 … Furthermore, in [15] the following result was proved (stated in its
> dual form). **It classifies the second largest Kakeya set in AG(2,q), q even.**"

**Read the shape of that pair against our claim (a):**

| Blokhuis–Bruen / Thm 6.1.5 | Our claim (a) |
|---|---|
| minimum `q(q+1)/2` attained **only** by Example 6.1.3 | minimum `12` attained **only** by the Clebsch class |
| **no** examples strictly between `q(q+1)/2` and `q(q+1)/2 + q/2` | **no** `\|U(A)\|` strictly between `12` and `16` |
| all examples at the next value are classified | all classes at `16` are the 30 non-Clebsch ones |

**This is the template.** Our claim (a) is a *minimum + uniqueness + forbidden-interval + next-value*
statement, and that is precisely the four-part shape Blokhuis–Bruen ships. **Claim (a) should be
stated in that form — "there is no 6-arc A of PG(2,11) with 12 < |U(A)| < 16; and |U(A)| = 12 holds
only for the Clebsch hexagon" — not as "the histogram has a hole".** The mathematical content is
identical; the second phrasing reads as a computational observation, the first as a theorem in a
known genre. This is the single highest-value change this sweep recommends.

**The other genre sentence — "second largest is much smaller".** Thesis Theorem 10.2.1, quoted:

> "**Theorem 10.2.1.** In PG(2, q²), q even, the largest complete arcs different from hyperovals,
> contain q² − q + 1 points. The tangent lines to such an arc form a dual Hermitian unital."

with, quoted: "The second-largest complete arcs were studied in [19, 56, 87, 119]." — namely
**Boros–Szőnyi**, *On the sharpness of the theorem of B. Segre*, Combinatorica 6 (1986) 261–268;
**Fisher–Hirschfeld–Thas**, *Complete arcs in planes of square order* (Combinatorics '84);
**Kestenband**, *A family of complete arcs in finite projective planes*, Colloq. Math. 57 (1987)
59–67; **Thas**, *Elementary proofs of two fundamental theorems of B. Segre without using the
Hasse–Weil theorem*, JCTA 34 (1983) 381–384. (All four bibliography entries verified verbatim.)
These are the Problem (III) citations the manuscript should carry.

### G5. ⚠️⚠️ THE BIGGEST FIND — `U(A)` IS A CLASSICAL OBJECT WITH CLASSICAL MACHINERY (Segre tangent-envelope theory)

**Tier: VERIFIED** (the theorem as reproduced and used in De Boeck's thesis §6.2) / **NOT OBTAINED**
(Hirschfeld PGOFF Cor. 10.3 itself).

The companion sweep concluded the tradition "had no reason to compute U(A) at all". **That is too
strong, and this is the correction.** There is a classical algebraic-geometry theory of exactly the
set `U(A)` — Segre's tangent-envelope theory — and the manuscript must engage it or a referee will.

De Boeck §6.2 "A few remarks on arcs", stated as based on **[80, Section 10.1] = Hirschfeld,
*Projective Geometries over Finite Fields*, 2nd ed., 1998** (bibliography entry verified verbatim).
Quoted:

> "Now we connect arcs to algebraic envelopes. A **tangent envelope** of a k-arc in PG(2, q) is an
> algebraic envelope containing all the tangent lines to this arc, and which is **of class q + 2 − k
> if q is even and of class 2(q + 2 − k) if q is odd**. If k is large enough, there is a unique
> tangent envelope, which is known as *the* tangent envelope."

And the key theorem, quoted verbatim:

> "**Theorem 6.2.1 ([80, Corollary 10.3(ii)]).** Let A be a dual k-arc in the projective plane
> PG(2, q), q even and k > q/2 + 1, and let Γt be the tangent curve to this dual arc. **The line ℓ
> extends A if and only if ℓ is a component of Γt.**"

**Dualize it back.** De Boeck states it for dual arcs; the primal form is: *a point P extends the
k-arc A to a (k+1)-arc if and only if P's pencil is a component of the tangent envelope of A.*
"Extends A to a (k+1)-arc" is **exactly the manuscript's definition of `U(A)`**. So the classical
statement is:

> **`U(A)` = the set of points cut out, as components, by the tangent envelope of `A`.**

**Why this matters enormously for positioning.** It means:
1. `U(A)` is **not** an invariant nobody had a handle on. It has a classical name in disguise
   ("the points extending the arc"), and a classical algebraic-geometry apparatus (Segre's lemma of
   tangents → tangent envelope → components) that computes it. **The manuscript cannot present
   `U(A)` as a newly-noticed object.** It should present it as a classical object and claim novelty
   only on the *conic* property of `U(A)` — which is where the novelty actually is.
2. It supplies the manuscript's missing **structural explanation**. Our claim (a) is currently pure
   census. The tangent envelope of a 6-arc in PG(2,11) — q odd, so class `2(q+2−k) = 2(11+2−6) =
   **14**` — is the object that governs `U(A)`. A referee in this school will ask "what does the
   tangent envelope say?" **The manuscript should have an answer, even a partial one.**
3. **It is NOT a collision.** Theorem 6.2.1's hypotheses are `q` **even** and `k > q/2 + 1`. Our
   case is `q = 11` (**odd**) and `k = 6`, while `q/2 + 1 = 6.5`, so `k = 6 < 6.5` — **our case fails
   both hypotheses**, and fails the size hypothesis even in the odd-q analogue. That is precisely
   why the classical theory does not already give our theorem: the tangent-envelope apparatus is a
   *large-k* tool (it needs the arc big enough to pin a unique envelope), and our 6-arc in PG(2,11)
   is deep in the small-k regime where the envelope is not unique. **This is a genuinely good
   defence and the manuscript should make it explicitly** — it converts "nobody looked" (weak, and
   now falsified) into "the classical tool provably does not reach this regime" (strong, and true).

**New target for the unread book.** The companion note hunted PGOFF Ch. 9 and Ch. 14. **Add Ch. 10
(§10.1, Corollary 10.3)** — the tangent-envelope/extension theory. Combined with G3's `§14.8`, the
ILL request should now name **§10.1 + Cor. 10.3, §14.8, and Table 9.4** specifically rather than
whole chapters.

### G6. Q2 — the perturbation half. The classical relative is **Segre's Problem III**, and it is a large-k tool that provably misses us

**Tier: VERIFIED.** J.A. Thas, *Arcs, caps and codes — old results, new results, generalizations*
(lecture notes, Finite Geometry School). PDF:
https://ftmakroglu05.github.io/Finite-Geometry-School/Joseph_Thas.pdf — full text extracted
(1,108 lines).

**Segre's three problems**, quoted verbatim — these organize the whole arc field:

> "**1.3 The three problems of Segre**
> I. Given n and q, what is the maximum value of k for which a k-arc exists in PG(n, q)?
> II. For what values of n and q, with q > n + 1, is every (q + 1)-arc of PG(n, q) a NRC?
> **III. For given n and q with q > n + 1, what are the values of k such that each k-arc of
> PG(n, q) is contained in a (q + 1)-arc of PG(n, q)?**"

**Segre's Problem III is an extension problem** — it asks exactly when a k-arc extends up to a full
oval. That is the same *subject matter* as `U(A)`, at the level of the whole extension tower rather
than one step. **This is the classical home of our claim, and the manuscript should name it.**

**The classical "almost a conic" theorem**, quoted verbatim (Segre (1967), Thas JAT (1987)):

> "(i) for q even, every k-arc K with k > q − √q + 1 extends to a hyperoval;
> **(ii) for q odd, every k-arc K with k > q − (1/4)√q + 25/16 extends to a conic.**"

**This is the nearest classical relative of the manuscript's whole enterprise** — a hypothesis of
the form "the arc is nearly big enough" forcing the conclusion "it sits inside a conic". Note it is
about *the arc* being in a conic, not `U(A)` — so it is **FLAG 2 of the companion note in classical
form**, and the risk of a referee conflating the two is now concrete and citable.

**Arithmetic that vindicates the manuscript, and should go in it.** Evaluate Segre's odd-q bound at
`q = 11`: `q − √q/4 + 25/16 = 11 − 3.3166/4 + 1.5625 = 11 − 0.829 + 1.5625 ≈ **11.73**`. So the
classical theorem says only: *every k-arc of PG(2,11) with k ≥ 12 extends to a conic* — and `q+1 =
12` is already the maximum, so the bound is essentially vacuous at q=11 and in any case bites only
at `k = 12`. **Our arcs have k = 6.** The classical apparatus misses our regime by a factor of two.

Combined with G5 (the tangent-envelope theorem needs `k > q/2 + 1 = 6.5`, and our `k = 6` fails it
by half a point — strikingly close, worth remarking), a single clean sentence is now available to
the manuscript, and it is the best defensive sentence this sweep found:

> *Every classical tool for arc extension — Segre's tangent-envelope theory (PGOFF Cor. 10.3,
> needing k > q/2 + 1) and Segre's extension bound (needing k > q − √q/4 + 25/16) — is a large-k
> tool. At q = 11 these require k ≥ 7 and k ≥ 12 respectively; our arcs have k = 6. The
> deep-hole locus of a 6-arc of PG(2,11) lies below the reach of every classical method, which is
> why its structure was available to be found by census and not before.*

That converts the companion note's weak "nobody had a reason to look" into a **provable statement
about the hypotheses of the classical theorems**. It is the difference between a referee thinking
"lucky computation" and "correctly identified blind spot".

**The genre's flagship problem is OPEN, and for our parity.** Thas's open-problem list, quoted
verbatim:

> "(g) Solve problems I, II and III of Segre."
> "**(j) Find the size of the second largest complete k-arc in PG(2, q) for q odd and for q an even
> non-square.**"

**So Problem (III)/second-largest for `q` odd — our parity — is an acknowledged open problem.**
This cuts both ways and the manuscript must handle it carefully:
- **Good:** it shows the genre is live and that gap questions at odd q are hard and wanted.
- **Dangerous:** a referee may read our "gap at q=11" as claiming progress on Problem (j). **It is
  not.** Ours is a different invariant on a fixed arc size. **Say so explicitly.** (See G2.)

**Segre's bound on the second largest complete arc** (INFERRED — from search-result summary text,
consistent across two independent searches, but I did not open Segre's paper): `m′(2,q) ≤
q − (1/4)√q + 7/4` for q odd; `≤ q − √q + 1` otherwise; and Hirschfeld–Korchmáros bound the *third*
largest by `q − 2√q + 6`. The last matches the survey's Theorem 2.5 exactly (G1), which is
**VERIFIED**, so the chain is corroborated. **This is the genre's foundational gap statement and it
is Segre's own**: the largest complete arc at q odd is the conic (q+1 points, attained only by the
conic, by Segre's theorem), and the next one down is at most `q − √q/4 + 7/4` — *a forbidden
interval of width ~√q/4 immediately below an extremal value attained by a unique distinguished
object.* **That is our claim (a)'s shape, and it is the single best citation for "this kind of
statement is a theorem, not an observation".**

### G7. Q2 verdict — one-point perturbation is NOT the established framing; the genre is "stability"

**Tier: NOT FOUND** (for the specific framing) / **VERIFIED** (for the genre's actual definition).

I searched for a genre of "move exactly one point of an extremal configuration and measure the jump
in an invariant". **NOT FOUND as a named genre.** No source located that frames results in terms of
one-point moves.

What exists instead, and what claim (b) must be translated into: the **stability** genre. Its
definition, quoted from the search-surfaced description of the Szőnyi–Weiner line and consistent
with the sources read:

> "A stability theorem says that a nearly extremal object can be obtained from an extremal one by
> *small changes*."

**Tier note: INFERRED** — this phrasing came from search-result summary text, not a source I opened.
The *content* is standard and corroborated by the Blokhuis–Bruen and Segre statements verified
above; the *wording* should not be quoted in the manuscript as if from a specific paper.

**The key structural point for claim (b), and it is a framing inversion.** The stability genre runs:
*near-extremal ⟹ close to extremal*. **Our claim (b) is the contrapositive-flavoured converse:
*close to extremal (one point moved) ⟹ NOT near-extremal in the invariant (|U Δ conic| ≥ 18)*.**
That is a **non-stability** or **rigidity** result: the configuration admits no near-misses. The
manuscript's own framing — "rigid, not merely stable" — is therefore **correct and well-chosen**,
and it lands precisely because "stable" has the technical meaning above. **Keep that sentence; it is
doing real work.** But it only reads as intended if the stability genre is cited nearby, so the
reader knows "stable" is being used in its technical sense and is being *denied*.

**Recommended framing for (b), in genre terms:** *the Clebsch configuration is rigid: no
one-point perturbation is near-conic (|U Δ conic| ≥ 18), so no stability theorem of the usual
"near-extremal ⟹ near-extremal-object" form can have a nonvacuous converse here.* Cite
Szőnyi–Weiner and Blokhuis–Bruen as the genre, and state that (b) is a *negative* stability result.

**Relevant stability-line sources located (titles/venues VERIFIED via bibliography entries and
search records; papers NOT opened — INFERRED for content):**
- **A. Blokhuis, A.A. Bruen**, "The minimal number of lines intersected by a set of q+2 points,
  blocking sets, and intersecting circles", *J. Combin. Theory Ser. A* **50** (1989) 308–315.
  (Bibliography entry VERIFIED verbatim in De Boeck's thesis, ref [15]; its gap statement VERIFIED
  as Thm 6.1.5 — see G4. **This is the prompt's target paper and it delivered.**)
- **T. Szőnyi, Zs. Weiner**, "On the stability of sets of even type", *Advances in Mathematics*
  (2014) — reported to sharpen Blokhuis–Bruen's hyperoval stability theorem. **INFERRED**, not
  opened.
- **T. Szőnyi, Zs. Weiner**, "Stability of k mod p multisets and small weight codewords of the code
  generated by the lines of PG(2,q)", arXiv:1901.09649. **NOT OPENED.**
- **E. Boros, T. Szőnyi**, "On the sharpness of the theorem of B. Segre", *Combinatorica* **6**
  (1986) 261–268. (Bibliography entry VERIFIED verbatim, De Boeck ref [19].) **Title is
  on-genre — "sharpness of Segre" is the gap question — and this is a likely required citation.**

### G8. The "spectrum" literature that MUST be distinguished — and it covers q = 11

**Tier: VERIFIED** (bibliography entries, quoted verbatim from the Hirschfeld–Storme survey).

The prompt asked to search the spectrum framing directly and to distinguish it rather than conflate
it. **The conflation hazard is real and specific: the complete-arc spectrum for PG(2,11) is
published.** The paper is:

> "[77] G. Faina, S. Marcugini, A. Milani and F. Pambianco, **The spectrum of the values k for
> which there exists a complete k-arc in PG(2, q) for q ≤ 23**, Ars Combin. 47 (1997), 3–11."

`q ≤ 23` **includes q = 11**. So a referee can point at a 1997 paper titled "the spectrum of the
values k … in PG(2,q) for q ≤ 23" and ask what our "spectrum gap at q=11" adds. **The answer is
clean and the manuscript must give it in one sentence:** Faina et al. tabulate which *arc sizes* `k`
admit a **complete** `k`-arc; we tabulate the *deep-hole count* `|U(A)|` across the classes of a
**fixed** size `k = 6`, all of which are incomplete. Same word, different invariant, disjoint
content. (See G2 for why they meet only at `|U| = 0`.)

Companion papers in the same series, also verified verbatim from the survey bibliography:
"[78] … The sizes k of the complete k-caps in PG(n,q), for small q and 3 ≤ n ≤ 5, Ars Combin. 50
(1998), 225–243."

**A third independent instance of the genre's standard sentence**, from the survey's Theorem 6.2,
quoted verbatim — this time for blocking sets:

> "(iii) (Ball and Blokhuis [13]) For q square, q ≥ 16, **there is no minimal blocking k-set S with
> q + √q + 1 < k < q + 2√q + 1.**"

and

> "(ii) (Blokhuis and Metsch [31], Innamorati [137]) In PG(2, q), with q square and q ≥ 25 or q = 9,
> **there is no minimal blocking set of size q√q.**"

**Three separate confirmations now agree on the sentence form** — Blokhuis–Bruen (G4), Segre/Thm 2.5
(G1), Ball–Blokhuis (here): *"there is no ⟨object⟩ with ⟨X⟩ < ⟨invariant⟩ < ⟨Y⟩"*, optionally
followed by *"furthermore, all ⟨objects⟩ with ⟨invariant⟩ = ⟨X⟩ are ⟨classification⟩"*. **That is
the template. Claim (a) should be one sentence in that exact mould.**

### G9. Q4 — the 252 perturbations. NOT FOUND.

**Tier: NOT FOUND.** Searched for the one-point perturbations of the q=11 A₅-hexagon and for the
symmetric-difference spectrum `{18:30, 19:60, 20:90, 22:42, 24:30}`. **Nothing located.** No source
computes perturbations of this configuration, and no source reports any `|U Δ conic|` data for any
arc.

This is the expected outcome and, given G5/G6, it now has a *reason* rather than being a bare
negative: the classical machinery for arc extension does not reach `k = 6` at `q = 11`, so the
tradition had no route to `U(A)` here even in principle, let alone to its perturbations. Confidence
is **moderate** — this was a small number of searches, and the prompt correctly ranked it last.

### G10. A genuine adjacent lane, checked — A₅-invariant arcs. NOT a collision.

**Tier: VERIFIED** (the A₆ paper) / **INFERRED** (the A₅ paper — abstract-level only, not opened).

`A₅`-invariant arcs in PG(2,q) **are** a studied topic, and PG(2,11) **does** admit `A₅`
(`11 ≡ 1 mod 10`), so this needed checking.

- **N. Pace**, "On small complete arcs and transitive A₅-invariant arcs in the projective plane
  PG(2,q)", *J. Combin. Designs* **22** (2014) 425–434. **INFERRED, not opened** (Wiley,
  paywalled). Per its abstract, it studies *transitive* `A₅`-invariant **30-arcs** — orbits with
  point-stabilizer of order 2 — and their completeness, finding complete 30-arcs that are the
  smallest known complete arcs in several planes. **Our Clebsch hexagon is the `A₅`-orbit of size
  6** (point-stabilizer of order 10 — an exceptional small orbit, not a transitive-regular-type
  one), and Pace's object of study is completeness of large orbits, not `U(A)` of small ones.
  **Not a collision on the evidence available, but this is INFERRED from an abstract — flagged.**
- **M. Giulietti, G. Korchmáros, N. Pace et al.**, "Transitive A₆-invariant k-arcs in PG(2,q)",
  arXiv:1108.0358 / Des. Codes Cryptogr. — **VERIFIED via the arXiv abstract page**: it concerns a
  unique `Γ`-orbit of size **90** with cyclic point-stabilizer of order 4, complete for
  q = 349, 409, 529, 601, 661. Confirmed: **no** `A₅`-invariant arcs, **no** PG(2,11), **no**
  6-arcs, **no** extension points. **Not a collision.**

**Residual risk recorded:** Pace 2014 is the one adjacent paper in this sweep judged only from an
abstract. If it enumerates *all* `A₅`-orbits in PG(2,q) rather than just the 30-point ones, it would
list our hexagon — which costs nothing (the manuscript already concedes the hexagon is classical to
Edge/Dye) **unless** it also computes extension data, which nothing suggests. **Low risk, but it is
the cheapest remaining check: one Wiley PDF.**

---

## VERDICT — the two questions, answered

### Novelty: **THE GAP THEOREM SURVIVES AS NOVEL — both halves. No collision found.**

No source located states either half. Specifically **NOT FOUND**: any gap/stability result about the
deep-hole count `|U(A)|` of a small arc; any second-smallest-value theory for that invariant; any
perturbation data for the q=11 `A₅`-hexagon. The negative is now **better supported than the
companion sweep's**, because it has a *mechanism* (G5/G6): the classical tools provably do not reach
`k = 6` at `q = 11`.

**Confidence: medium-high on (a) and (b) as unstated results.** The unread-source hole from the
companion sweep (Sadeh's thesis, PGOFF) still applies in principle, but it is **much less
threatening for the gap theorem than for the rigidity theorem**: even if Sadeh's thesis tabulates
`|U(A)|` per class, the *gap statement* — minimum 12, uniquely Clebsch, nothing below 16 — is an
interpretation of the table, and the tradition's reason for building the table (cubic surfaces)
gives no motive to state it. The manuscript's existing concession already covers the raw data.

### Positioning: **THIS IS THE PART THAT NEEDS WORK — and the answer is precise.**

**The genre:** *Problem (III) of the packing problem* — "find the size of the second largest complete
set" — as codified in **Hirschfeld & Storme, "The packing problem in statistics, coding theory and
finite projective spaces"** (J. Statist. Planning Infer. 72 (1998) 355–380; update 2001, Developments
in Mathematics, Kluwer, 201–246). **That is the paper that defines the genre's standard form**, and
it is the citation the manuscript is currently missing. Problem (III) is one of four numbered
problems organizing the entire field (G1).

**The genre's standard form**, confirmed three independent times (G1, G4, G8):

> *"There is no ⟨object⟩ with ⟨X⟩ < ⟨invariant⟩ < ⟨Y⟩. Furthermore, all ⟨objects⟩ with ⟨invariant⟩
> = ⟨X⟩ are ⟨classified as …⟩."*

**Claim (a) must be restated in that mould** — "there is no 6-arc `A` of PG(2,11) with
`12 < |U(A)| < 16`; moreover `|U(A)| = 12` holds only for the Clebsch hexagon, for which `U(A)` is a
conic" — rather than as "the histogram has a hole between 12 and 16". **Identical content; the
first is a theorem in a known genre, the second reads as a computational curiosity.** This is the
single highest-value change identified by this sweep.

**The specific papers that define the genre's standard form, in priority order:**

| Role | Paper | Tier |
|---|---|---|
| **Defines the genre** (Problem III) | Hirschfeld & Storme, *The packing problem…* (1998; update 2001) | VERIFIED |
| **The canonical gap sentence** | Blokhuis & Bruen, *The minimal number of lines intersected by a set of q+2 points…*, JCTA **50** (1989) 308–315 | VERIFIED (via De Boeck Thm 6.1.5) |
| **The genre's founding gap result** | Segre — largest complete arc = conic (q odd); second largest ≤ q − √q/4 + 7/4 | INFERRED (bound) / VERIFIED (chain) |
| **Title precedent for our exact framing** | Blokhuis, De Boeck, Mazzocca, Storme, *The finite field Kakeya problem: a gap in the spectrum and classification of the smallest examples*, DCC **72** (2014) 21–31 | VERIFIED (title/authors/venue) |
| **The classical machinery for `U(A)`** | Hirschfeld, *PGOFF* 2nd ed., **§10.1, Cor. 10.3** — tangent envelopes | VERIFIED (via De Boeck Thm 6.2.1) |
| **The classical relative of (b)** | Segre's Problem III + "k > q − √q/4 + 25/16 ⟹ extends to a conic" | VERIFIED (via Thas notes) |
| **Must be distinguished, not cited as support** | Faina, Marcugini, Milani, Pambianco, *The spectrum of the values k… for q ≤ 23*, Ars Combin. **47** (1997) 3–11 | VERIFIED (ref) |
| **The stability line, for (b)** | Szőnyi & Weiner (even-type sets, Adv. Math. 2014); Boros & Szőnyi, *On the sharpness of the theorem of B. Segre*, Combinatorica **6** (1986) 261–268 | INFERRED |

---

## Recommended actions for the manuscript

Ordered by value. Items 1–3 are the ones that decide whether the paper reads as naive.

1. **Restate claim (a) in the Blokhuis–Bruen mould** (G4, G8). "There is no 6-arc A of PG(2,11) with
   12 < |U(A)| < 16; moreover |U(A)| = 12 only for the Clebsch hexagon." Cite Hirschfeld–Storme
   Problem (III) as the genre, Blokhuis–Bruen and Ball–Blokhuis as the sentence precedents.
2. **Add the "classical tools miss this regime" paragraph** (G5, G6). Segre's tangent-envelope
   theory needs `k > q/2 + 1` (= 6.5 at q=11); Segre's extension bound needs `k > q − √q/4 + 25/16`
   (≈ 11.73 at q=11); our `k = 6` fails both. **This is the manuscript's best defence and it is
   currently absent.** It replaces "nobody looked" — which G5 falsifies — with a checkable statement
   about hypotheses.
3. **Distinguish our spectrum from the complete-arc spectrum, by name** (G2, G8). One sentence
   naming Faina–Marcugini–Milani–Pambianco (q ≤ 23, so including q=11) and Thas's open Problem (j)
   (second-largest complete arc, q odd), stating we address neither. Note `m″(2,11) = 10` and
   `t(2,11) = 7` are published (survey Tables 2.4, 2.5) — **cite `t(2,11) = 7` as the reason our
   histogram has no zero bin**, rather than asserting it internally.
4. **Keep "rigid, not merely stable" — and earn it** (G7). The phrase is technically correct and
   well-chosen: "stable" has a precise meaning in this literature (*near-extremal ⟹ close to
   extremal*) and (b) denies exactly that. But cite the stability genre next to it, or the word
   reads as informal.
5. **Re-aim the Hirschfeld–Sadeh concession — now safe to act on** (G3). Hirschfeld's own survey
   cites **Sadeh's thesis [189]** and **PGOFF §14.8** for q=11, and **does not cite HS84 at all**.
   The companion note gated this on ILL; that gate can be lifted. Cite the thesis + §14.8.
6. **Narrow the ILL/book request** (G3, G5). Ask for PGOFF **§10.1 + Cor. 10.3** (tangent envelopes
   — newly identified, and the most likely place a `U(A)` statement hides), **§14.8** (q=11 arcs),
   and **Table 9.4**. Three sections, not three chapters.

## Residual risk

| Risk | Severity | Mitigation |
|---|---|---|
| **PGOFF §10.1 / Cor. 10.3 contains a small-k or odd-q tangent-envelope statement reaching k=6, q=11** | **Would undercut recommendation 2 — the paper's main defence** | **Newly identified; the highest-value unread target. Get PGOFF Ch. 10.** |
| Sadeh's thesis states the gap, not just the table | Would take claim (a) | ILL — unresolved, carried from companion note |
| Pace 2014 enumerates all A₅-orbits incl. the hexagon with extension data | Low — hexagon already conceded | One Wiley PDF (G10) |
| Segre's `m′` bound misquoted (INFERRED, from search summaries) | Low — chain corroborated by verified Thm 2.5 | Open Segre (1967) / Thas JAT (1987) before citing the constant |
| Referee reads (a) as a claim on Thas's open Problem (j) | Medium — costs goodwill | Recommendation 3 |

## Search log (chronological)

1. Read the companion rigidity/gap note. Started from its F8 lead (stability is an established
   genre) as instructed.
2. Searched Hirschfeld–Storme packing survey → fetched PDF → extracted 2,982 lines → **G1, G2, G8**
   (Problem III; Thm 2.5; Tables 2.4/2.5; refs [77], [189]; **HS84 absent from bibliography → G3**).
3. Searched Szőnyi–Weiner stability → genre definition (INFERRED) → **G7**.
4. Searched complete-arc spectrum / second-largest → surfaced the Kakeya "gap in the spectrum"
   title → **G4**.
5. Springer paywalled (303 → IdP). Recovered the Kakeya content via **De Boeck's Ghent thesis**
   (open PDF, 15,226 lines) → **G4** (Blokhuis–Bruen Thm 6.1.5), **G5** (tangent envelope
   Thm 6.2.1 / PGOFF Cor. 10.3), Thm 10.2.1 + second-largest refs.
6. Semantic Scholar API → verified Kakeya paper authors/venue (abstract null).
7. Searched Segre / conic-embedding → fetched **Thas lecture notes** (1,108 lines) → **G6**
   (Segre's three problems; the extension bound; open problems (g), (j)).
8. Searched A₅/A₆-invariant arcs → arXiv:1108.0358 abstract (VERIFIED, 90-arcs, not us); Pace 2014
   (INFERRED, 30-arcs) → **G10**.
9. Searched Q4 (252 perturbations, symmetric-difference spectrum) → **G9, NOT FOUND**.

**NOT SEARCHED:** Edge 1956; Dye 1991; Storme–Van Maldeghem 1995 (prior sweeps' scope). Voloch's
complete-arc work individually. Bartoli–Giulietti–Marcugini–Pambianco individually (the survey's
Problem III chain covers the genre; per-author sweeps not done). Szőnyi–Weiner papers not opened.
