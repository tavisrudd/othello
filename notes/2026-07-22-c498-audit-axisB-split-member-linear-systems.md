# C498 literature audit — Axis B: existence of a totally-split member in a net of binary quartics over F_q

**Task:** C498 (redundancy-six, audit-gated). Axis = prior art on the *existence lemma*: for
q ≥ q_1, every non-exceptional net of binary quartics with trivial gcd contains a member with 4
distinct roots all in F_q ("totally split squarefree member"). Intended proof: Lang–Weil on the
(2,2) fiber-square *surface* over the net — the redundancy-six analogue of a redundancy-five
argument that used the Aubry–Perret bound on the fiber-square *curve*.

## Opening summary

**Full-text sources read: 1** (Oyono–Ritzenthaler, arXiv:1006.0873, cached, full text). All other
sources are abstract/metadata- or review-only (searched via OpenAlex/Semantic-Scholar result pages,
Springer/mathnet landing pages, and the zbMATH Open API), recorded as such per item.

**One-line verdict:** NOVEL-BUT-STANDARD-TOOLS-EXIST — the general net-of-binary-quartics split-member
lemma is **not proved anywhere I found**, but (i) its exact special case for the net of line-sections
of a smooth plane quartic *is* proved (Oyono–Ritzenthaler, q ≥ 127, by the *curve*/Hasse–Weil route,
not Lang–Weil surface), and (ii) the counting core is essentially a corollary of the
Cesaratto–Matera–Pérez factorization-pattern theorem for *linear families* of polynomials; the
Lang–Weil/Bertini/Aubry–Perret machinery to run the surface argument is fully in the literature with
explicit constants.

---

## Dimension 1 — split / totally-reducible members of pencils and linear systems of binary forms

**Oyono, R.; Ritzenthaler, C. — "On rationality of the intersection points of a line with a plane
quartic."** WAIFI 2010, LNCS 6087, 224–237 (2010); arXiv:1006.0873v2. Zbl 1245.11077.
*Read depth: full text* (litcache key `arXiv:1006.0873`, sha256
`59876e47e38583a336d6e94841f669ef8227d3f36288532254bfcfd3c7d61225`; sections 1–4 relied on).
- **Theorem 1:** For any smooth plane quartic C/F_q with q ≥ 127, there exists a line ℓ meeting C in
  rational points only (i.e. the binary quartic ℓ∩C splits completely over F_q). **This is exactly the
  split-member statement for the specific net of binary quartics obtained by restricting a fixed smooth
  plane quartic to the lines through P² — a strong PARTIAL pre-emption of the special case.**
- **Method:** Chebotarev density theorem for covers of curves (Thm 1); for the tangent-line refinement
  (Thm 2, q ≥ 66²+1) they prove the tangential-correspondence curve X_C ⊂ C×C is geometrically
  irreducible and apply the Hasse–Weil bound for (possibly singular) irreducible curves — the
  **curve / redundancy-five style**, treating reducible characteristic-2 fibers componentwise. They do
  **not** use a Lang–Weil surface argument.
- They explicitly cite (their intro) that index-calculus complexity analysis "uses an asymptotic bound
  for the number of lines intersecting a smooth plane quartic in four distinct rational points, in the
  spirit of Theorem 1" — i.e. the totally-split-line count is already an object of study.
- YOUR-INFERENCE gap vs. C498: their net is the *complete* net of line-restrictions of one smooth
  plane curve (a very special 2-dim system, always base-point-free of the pencil-of-lines type); C498's
  claim is for a *general* net of binary quartics with trivial gcd, not necessarily of this geometric
  origin, with an "exceptional" locus classified separately. Their "smooth C" hypothesis is the
  non-exceptional analogue. So the *phenomenon and a clean explicit bound exist*, but the general lemma
  is not their theorem.

Classical pencil-of-binary-forms / (2,2)-correspondence / apolarity literature surfaced only generic
splitting-field material (Wikipedia, lecture notes) with no finite-field totally-split existence
statement. *Read depth: review only* (search-result snippets; nothing citable found).

## Dimension 2 — Lang–Weil, Bertini over finite fields, irreducible/smooth members of linear systems

- **Poonen, B. — "Bertini theorems over finite fields."** Ann. of Math. (2) 160, No. 3, 1099–1127
  (2005). Zbl 1084.14026. *Read depth: abstract/metadata only* (zbMATH API record + author's posted PDF
  located, not read in full). Density ζ_X(m+1)⁻¹ of smooth sections; the finite-field replacement for
  classical Bertini. Citable as the smooth-member existence engine.
- **Charles, F.; Poonen, B. — "Bertini irreducibility theorems over finite fields."** arXiv:1311.4960
  (J. AMS 2016). *Read depth: abstract/metadata only.* Geometric-irreducibility of members, the
  hypothesis a Lang–Weil main-term argument needs.
- **Gabber / Ballico / semiample Bertini (arXiv:1209.5266)** — located, *review only*; not load-bearing.
- These give the "non-exceptional ⇒ geometrically irreducible incidence surface" input that Lang–Weil
  then converts to an F_q-point. **The tools exist; none states the quartic-net split lemma.**

## Dimension 3 — Aubry–Perret (the r=5 curve tool) and its surface (Lang–Weil) generalization

- **Aubry, Y.; Perret, M. — "Coverings of singular curves over finite fields" / "A Weil theorem for
  singular curves."** Manuscr. Math. 88, No. 4, 467–478 (1995). Zbl 0862.11042. *Read depth:
  abstract/metadata only* (zbMATH API + Springer landing). This is the exact r=5 tool: a Weil-type
  |#X(F_q) − (q+1)| ≤ 2g_X̄ √q bound for singular irreducible curves (via the normalization/genus of
  the desingularization). Cite this for the fiber-square *curve* argument.
- Surface / higher-dim explicit Lang–Weil (the r=6 replacement):
  - **Cafure, A.; Matera, G. — "Improved explicit estimates on the number of solutions of equations
    over a finite field."** Finite Fields Appl. 12, No. 2, 155–185 (2006). Zbl 1163.11329. *Read depth:
    abstract/metadata only.* Explicit |#V(F_q) − q^{dim}| ≤ (…)q^{dim−1/2} for absolutely irreducible
    affine V, with an effective first-Bertini theorem; **the natural explicit-constant surface version
    the C498 proof wants.** They also have the companion "An effective Bertini theorem and the number
    of rational points of a normal complete intersection over a finite field."
  - **Ghorpade, S.; Lachaud, G. — "Étale cohomology, Lefschetz theorems and number of points of
    singular varieties over finite fields."** Mosc. Math. J. 2, No. 3, 589–631 (2002); corr./add. ibid.
    9, No. 2, 431–438 (2009). Zbl 1101.14017. *Read depth: abstract/metadata only.* General
    point-count inequality for arbitrary complete intersections (singular allowed) — the direct
    higher-dimensional analogue of Aubry–Perret; the natural citation for a singular fiber-square
    surface. **This is the surface generalization the axis asked whether exists — it does.**

## Dimension 4 — squarefree / factorization-pattern densities on linear families

- **Cesaratto, E.; Matera, G.; Pérez, M. — "The distribution of factorization patterns on linear
  families of polynomials over a finite field."** Combinatorica 37, No. 5, 805–836 (2017);
  arXiv:1408.7014. Zbl 1413.11129. *Read depth: partial* (arXiv abstract + zbMATH API record; main
  theorem statement and hypotheses relied on, proofs not read).
  - For a linear family 𝒜 of monic degree-n polynomials of codimension m, the number of members with
    factorization pattern λ is **|𝒜_λ| = 𝒯(λ)·q^{n−m} + O(q^{n−m−1/2})**, 𝒯(λ) = the proportion of
    S_n with cycle type λ (Cohen's constant). Requires char > 2 and a non-degeneracy condition on the
    family.
  - **For the totally-split pattern λ = 1ⁿ (n distinct rational roots) the main term 𝒯(1ⁿ)·q^{n−m} is
    strictly positive, so for q past an explicit bound a totally-split member EXISTS.** For n = 4 this
    is precisely the counting core of the C498 lemma restricted to a *linear* (net-shaped) family.
    YOUR-INFERENCE: the "non-degeneracy" hypothesis here is the same object as C498's "non-exceptional
    incidence surface"; the proof route (their §on the associated variety) *is* a Lang–Weil/Bertini
    argument on a fiber-product variety — i.e. the same machine C498 proposes. This is the closest thing
    to a pre-emption of the counting step, though it is stated for polynomials/linear families, not
    packaged as "net of binary quartics with the exceptional nets classified."
  - Companion: **Cohen, S. D. — "The distribution of polynomials over finite fields"** (Acta Arith.
    17 (1970)) is the classical origin of 𝒯(λ). *Read depth: secondary only* (cited by the above).
  - Also **"Factorization patterns on nonlinear families of univariate polynomials over a finite field"**
    (Matera et al., J. Algebr. Comb. 2018; arXiv:1807.08052) extends to nonlinear families. *Review only.*

## Dimension 5 — coding-theory / NRC papers already needing a split member of a net of quartics

- **Zhang, J.; Wan, D.; Kaipa, K. — "Deep holes of projective Reed–Solomon codes."** arXiv:1901.05445
  (IEEE-IT 2020). *Read depth: abstract/metadata only* (litcache key `arXiv:1901.05445`). Completes the
  deep-hole classification for PRS codes of **redundancy four**; earlier work reached redundancy ≤ 3.
  **No redundancy-five/six treatment and no net-of-quartics split-member lemma appears** — the r=5/r=6
  program (C500/C498) is the extension, not covered here.
- MDS-extension / deep-hole neighbours (arXiv:1612.05447, 1711.02292, 1705.07823, 2312.05534, the
  even-characteristic PRS paper, aimspress 2019) — *review only*; classifications, not existence of a
  totally-split member of a degree-4 linear system.
- No paper found that extends ZWK to degree-5 NRCs / redundancy six or that states the split-net lemma.

## Citable tools (for the C498 proof, with verified references)

| Role in C498 proof | Cite | Verified detail | Read depth |
|---|---|---|---|
| Split-member phenomenon + explicit bound, special net | Oyono–Ritzenthaler | LNCS 6087, 224–237 (2010); Zbl 1245.11077; q ≥ 127 | full text |
| r=5 curve bound (fiber-square curve) | Aubry–Perret | Manuscr. Math. 88(4), 467–478 (1995); Zbl 0862.11042 | abstract/meta |
| r=6 surface bound, explicit constants | Cafure–Matera | Finite Fields Appl. 12(2), 155–185 (2006); Zbl 1163.11329 | abstract/meta |
| Singular surface / complete-intersection point count | Ghorpade–Lachaud | Mosc. Math. J. 2(3), 589–631 (2002), corr. 9(2) 2009; Zbl 1101.14017 | abstract/meta |
| Geometric-irreducibility of the incidence member | Charles–Poonen | arXiv:1311.4960 (J. AMS 2016) | abstract/meta |
| Smooth member density | Poonen | Ann. of Math. 160(3), 1099–1127 (2005); Zbl 1084.14026 | abstract/meta |
| Totally-split count on a *linear* family (counting core) | Cesaratto–Matera–Pérez | Combinatorica 37(5), 805–836 (2017); Zbl 1413.11129 | partial |

YOUR-INFERENCE (marked as mine, not asserted by any source): the combination
Cesaratto–Matera–Pérez (counting main term for λ=1⁴) + Ghorpade–Lachaud / Cafure–Matera (explicit
singular-surface error term) + Charles–Poonen (non-exceptional ⇒ geometrically irreducible) suffices
to prove the C498 lemma with an explicit q_1; I found no source that assembles them for this claim.

## Coverage statement

- **Searched and found nothing** pre-empting the *general* net-of-binary-quartics split lemma in:
  OpenAlex/Semantic-Scholar/arXiv result pages (dimensions 1–5 query sets), Springer & mathnet.ru
  landing pages, and the **zbMATH Open API (api.zbmath.org — reachable and used**; bibliographic
  volume/page/year for Oyono–Ritzenthaler, Aubry–Perret, Cafure–Matera, Ghorpade–Lachaud, Poonen,
  Cesaratto–Matera–Pérez were taken from it, not from recall).
- **zbMATH web UI** (`zbmath.org/?q=`) returned HTTP 403 to WebFetch/curl; the **JSON API** at
  `api.zbmath.org/v1/document/_search` worked and is the source of the Zbl numbers above.
- **MathSciNet: NOT COVERED** (no institutional access from this environment).
- Only one source (Oyono–Ritzenthaler) read at full text; all "tool" references verified for
  bibliographic detail via zbMATH but not read in full — statements attributed to them come from
  abstracts/records and standard knowledge, flagged accordingly.

## VERDICT

**NOVEL-BUT-STANDARD-TOOLS-EXIST (not pre-empted as stated; genuinely open as a *packaged* lemma).**

- The **general** lemma — "for q ≥ q_1 every non-exceptional net of binary quartics with trivial gcd
  contains a totally-split squarefree member, exceptional nets classified separately" — **is proved
  nowhere I located.** It is NOT pre-empted.
- It is **not genuinely open in the hard sense**: (i) its most important special case (line-sections of
  a smooth plane quartic) is a *theorem* with an explicit bound q ≥ 127 (Oyono–Ritzenthaler), and (ii)
  the totally-split counting core for linear families is a direct corollary of Cesaratto–Matera–Pérez;
  the Lang–Weil surface / Aubry–Perret curve / Bertini-irreducibility machinery is fully available with
  explicit constants (Cafure–Matera, Ghorpade–Lachaud, Charles–Poonen).
- **Distinction the deliverable asked for:** *the lemma is not proved*; *the tools to prove it are
  standard and published.* C498's novelty rests on (a) the net-of-binary-quartics / redundancy-six
  packaging and the explicit classification of the exceptional nets, and (b) carrying the argument on
  the fiber-square *surface* rather than the curve — neither of which appears in the located literature.
  The one item a referee would demand C498 engage directly is Oyono–Ritzenthaler (same split-member
  phenomenon, curve method) and Cesaratto–Matera–Pérez (same counting core, linear-family method).
