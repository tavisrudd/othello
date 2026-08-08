# C883 item 5 — literature audit of the covariant identity disc(h_x) = I·H − J·f

**Lane:** `reed-solomon` · **Date:** 2026-08-07 · **Card:**
`notes/reed-solomon-tasks/c883-r5-followups.md`
**Audited mathematics:** `notes/2026-08-07-c883-hankel-plucker-covariant.md`
**Predecessor audit reused for pinned identifiers:**
`notes/2026-08-07-c881-r5-cubic-pencil-literature-audit.md`

## Opening summary

Fourteen sources are named below. **Four were read at full text at the load-bearing
statements** — Salmon (Arts. 207–209), Grace & Young (§§83–94), Burnside & Panton
(Art. 180), and Duke (§5). Three more were read at **partial** depth (Elliott;
Kaipa–Patanker–Pradhan `arXiv:2312.07118`; Kaipa–Pradhan `arXiv:2509.15332`). One is
**review only** (Edge 1973, via zbMATH). Two are **secondary only** (Atiyah 1952 through
Kaipa–Patanker–Pradhan; Cayley's Fifth Memoir through Duke). Four are
**abstract/metadata only** and are named only to place them or to mark them as unexamined.

**The three verdicts in one line each.**

- **Q1 — mixed, and the mixture is the finding.** The two-dimensional space spanned by
  `I·H` and `J·F` does contain one element that the classical literature repeatedly
  distinguishes, and modern work names: it is `2 I·H − 3 J·F`, called `K_F` by Duke and
  written `3TU − 2SH` by Salmon and `iH − jf` by Grace & Young. **That is not the audited
  covariant.** No source located gives a name, a standard normalization, or a recurring
  role to `I·H − J·F`, and I found an intrinsic reason why: `2 I·H − 3 J·F` is the unique
  element of the space whose Hessian is proportional to `H`, which is exactly the property
  the classical reduction tables and Duke's Lemma 1 exploit. The audited covariant has no
  such property.
- **Q2 — negative, with the searched domain recorded.** No source states that the
  discriminant of the residual quadratic of the apolar pencil, taken at the member through
  a variable point, is a covariant of the quartic. Kaipa, Patanker and Pradhan define
  their quartic by a projection of the Klein quadric from a point, and characterise its
  roots as the contact parameters of the tangent lines of the twisted cubic that the line
  meets; they never call it a covariant of an apolar quartic and never form a residual
  quadratic. This audit also records a correction to the audited note's framing: the two
  quartics are different quartics, not two descriptions of one.
- **Q3 — split.** That the perfect-square binary quartics form a projected Veronese
  surface is in the literature twice over: Atiyah 1952 as reported by Kaipa, Patanker and
  Pradhan, and Salmon's proportionality conditions for two square factors. That this locus
  arises as the *residual component of an elimination beside a catalecticant cubic* is not
  in any source located; that part is a recorded negative.

## Fixed normalization used throughout

Every printed coefficient below is converted into one normalization before being compared,
because the classical authors scale `I`, `J` and `H` differently and their printed
coefficients are therefore not comparable as printed. Failing to do this conversion is the
specific way a reader would wrongly conclude that Grace & Young's `iH − jf` is our
covariant. The normalization is the audited note's, and it coincides with Duke's:

- `F = a x^4 + 4b x^3 y + 6c x^2 y^2 + 4d x y^3 + e y^4`  (binomial coordinates)
- `I = ae − 4bd + 3c^2`  (degree 2)
- `J = ace + 2bcd − b^2 e − a d^2 − c^3`  (degree 3; the 3×3 catalecticant determinant)
- `H = (ac−b^2)x^4 + 2(ad−bc)x^3y + (ae+2bd−3c^2)x^2y^2 + 2(be−cd)xy^3 + (ce−d^2)y^4`
- `Δ = I^3 − 27 J^2`; `T` = the sextic covariant, the Jacobian of `F` and `H`

The covariants of degree 4 in the coefficients and order 4 in the variable form the
two-dimensional space spanned by `I·H` and `J·F`. Write a member as `C_λ = I·H + λ J·F`.
The number `λ` names the element up to scale and is independent of how any author scales
`I`, `J` and `H`, so it is the right thing to compare.

| element | λ | where it occurs |
|---|---|---|
| `I·H − J·F` — **the audited covariant** | **−1** | the audited note; no source located |
| `2 I·H − 3 J·F` | −3/2 | Salmon p. 199; Grace & Young §94; Duke (5.6) as `K_F`; equals `(F,T)_3` and `(T,H)_1/F` up to scale |
| `I·H − 3 J·F` | −3 | the second transvectant `(H,H)_2`, i.e. the Hessian of the Hessian |

## Q1 verdict — does `I·H − J·F` carry a classical name?

**Located predecessor for the neighbouring element, recorded negative for ours.**

### What is named, with pinpoints

1. **Salmon**, *Lessons Introductory to the Modern Higher Algebra*, 4th ed. (1885),
   Art. 207 "Conditions for two pairs of equal roots", p. 199 (running head "COMPLETE
   SYSTEM OF THE QUARTIC"). Salmon writes the
   conditions for a quartic to have two square factors as the proportionality chain
   `(ac−b^2)/a = (ad−bc)/2b = (ae+2bd−3c^2)/6c = (be−cd)/2d = (ce−d^2)/e`, then says of the
   root-form covariant `Σ (α−β)^2 (β−γ)^2 (γ−α)^2 (x−δ)^4`: *"But this, it will be found,
   is the same as 3TU − 2SH"*, and *"we can easily verify that this covariant vanishes when
   the quartic has two square factors"*. In Salmon's letters `S = I`, `T = J`, `U = F`, and
   his `H` is the Hessian in the same normalization as ours, so `3TU − 2SH` is λ = −3/2.
   I verified the root formula independently (see § "Auditor's own computations", item 3):
   the sum evaluates to `−192 (2 I·H − 3 J·F)` exactly. Salmon's Art. 208 then proves that
   the complete irreducible system of the quartic is `U, H, J(sextic), S, T`, so no
   degree-4 order-4 covariant is irreducible — which is why none of them acquires a *name*
   in his book, only a role.
2. **Grace & Young**, *The Algebra of Invariants* (Cambridge, 1903), Chapter V §94, p. 99,
   in the reduction table for the transvectants of `f, H, t` taken two at a time. Two of
   the displayed reductions carry the same bracket: `(t,f)^3 = ½(iH − jf)`, in the quartic
   discussion at §89, p. 93, and `(t,H) = ½ f (iH − jf)` at §94, p. 99. Their `i`, `j`,
   `H` are the transvectant-normalized invariants and Hessian; converting, `i = 2I`,
   `j = 6J` and their `H` is twice ours, so their `iH − jf` is `4 I·H − 6 J·F`, again
   λ = −3/2. I confirmed this without relying on their normalization at all, by computing
   the intrinsic covariants: `(F,T)_3 = −8 I·H + 12 J·F` and `(T,H)_1 = 32 F (2I·H − 3J·F)`.
3. **Duke**, *On Elliptic Curves and Binary Quartic Forms*, IMRN, §5, equation (5.6):
   *"A special quartic covariant we will need is `K_F(x,y) = 2IH(x,y) − 3JF(x,y)`"*, with
   the two identities (5.7) `Δ K_F = J^2 Δ^3` and `H_{3K_F} = −3Δ H`. Duke's `I`, `J`, `H`
   and `Δ = I^3 − 27J^2` are exactly ours, so `K_F` is λ = −3/2 verbatim. Duke gives the
   object a symbol but attributes it to nobody; his neighbouring Lemma 1 is credited to
   Cayley [5, §134], Burnside & Panton [3, §180] and Salmon [29, p. 201]. Salmon's p. 201
   in the 5th edition is p. 199 in the 4th edition I read, i.e. the passage quoted above.
   **So `K_F`'s chain of custody runs back to Salmon, and this audit closes it.**
4. **Burnside & Panton**, *The Theory of Equations*, Art. 180, "The Invariants and
   Covariants of `κU − λH_x`". This is the classical frame that makes the whole family
   visible at once: they compute the invariants, the Hessian and the discriminant of the
   *entire pencil* `κU − λH`, obtaining `I(κ,λ)^3 − 27 J(κ,λ)^2 = Q^2 (I^3 − 27J^2)` where
   `Q` is the resolvent ("reducing") cubic homogenized in `κ, λ`, and noting *"as M. Hermite
   has remarked"* that the Hessian of `κU − λH_x` is the Jacobian of `κU − λH_x` and `Q` in
   the variables `κ, λ`. Duke's Lemma 1 is this pair of statements in his coordinates. No
   individual member of the pencil is named here.

### Why that element and not ours — an intrinsic reason (my inference)

I computed the Hessian of the general member `C_λ = I·H + λ J·F` and expressed it in the
three-dimensional space of degree-8 order-4 covariants spanned by `I^3 H`, `J^2 H`,
`I^2 J F`. The coefficient of `I^2 J F` is exactly `λ/6 + 1/4`, which vanishes if and only
if **λ = −3/2**. So `2I·H − 3J·F` is the unique element of the pencil whose Hessian is a
multiple of `H` itself — Duke's `H_{3K_F} = −3Δ H`. That is a self-reproducing property,
it is what makes the reduction tables close, and it is a sufficient explanation for why
the classical writers keep landing on that element and never on λ = −1. This explanation
is mine; no source states it in this form.

**Recorded negative.** For `I·H − J·F` (λ = −1) specifically:

- **Searched domain:** the full OCR text of six classical treatises (Salmon 4th ed. 1885;
  Grace & Young 1903, two independent scans; Elliott 2nd ed. 1913; Burnside & Panton 1892),
  mechanically grepped for every spelling of the combination and for all
  coefficient-pattern variants; the quartic chapters of each read at the sections listed in
  the source table; Duke's IMRN paper §5 in full; zbMATH Open; three web searches on the
  explicit coefficient strings.
- **Stop condition:** the only occurrences of any element of the space in any of these
  texts are the four listed above, and all four are λ = −3/2 or λ = −3. The mechanical grep
  over the six OCR texts returned exactly four hits, all quoted above, and no hit anywhere
  for λ = −1.
- **Not covered:** Clebsch's *Theorie der binären algebraischen Formen*, Gordan's
  *Vorlesungen über Invariantentheorie*, Sylvester's collected papers, Olver's *Classical
  Invariant Theory*, Dixmier, Kung & Rota, and Dolgachev were **not** obtained — see the
  coverage statement. The negative above is therefore a negative over the treatises I read,
  not over the whole classical corpus, and the "to our knowledge" qualification stays.

## Q2 verdict — is the identity itself known?

**Recorded negative, in both directions searched.**

### The classical / apolarity direction

No source located states, in any normalization, that the discriminant of the residual
quadratic `h_x = g_x/(t−x)` of the apolar pencil of a binary quartic, taken at the pencil
member through a variable point `x`, equals a covariant of the quartic. Searched: the six
classical treatises above (Elliott's apolarity section §207, Grace & Young's Chapter V and
the Contents entries for Chapters XI and XIV, Salmon's apolarity index entries); zbMATH
Open with three query forms; four web searches. The classical texts treat the *pencil of
apolar cubics* of a quartic — Elliott §207 states the apolarity criterion by vanishing
transvectant and the canonizant relation, and Grace & Young devote Chapters XI and XIV to
apolarity — but the construction "take the member vanishing at a variable point, divide out
that root, and discriminate the residual quadratic" does not appear in what I read, and
returns nothing on zbMATH.

**Stop condition:** the zbMATH query `apolarity binary quartic pencil of apolar cubics`
returns "No Documents Found" (HTTP 200 with that literal page title, which is how an empty
result is distinguished from an error on that service); the query
`binary quartic covariant apolar pencil` returns exactly one document, Edge 1973, which is
about apolarity of pairs of quadrics and not about this construction.

### The finite-geometry direction, and a correction to the audited note's framing

Kaipa, Patanker and Pradhan attach their quartic to a line by an explicitly geometric
route, and never by a discriminant. From their §1.2, read at full text: the Klein quadric
`Q` in `PG(5,q)` is projected from the point `P_0` onto the hyperplane `H` spanned by the
rational normal quartic `C_4` of tangent lines; `H` is identified `G`-equivariantly with the
space of binary quartics `f = z_0Y^4 − 4z_1Y^3X + 6z_2Y^2X^2 − 4z_3YX^3 + z_4X^4`; and the
defining property of the quartic is stated as *"A line L of PG(3,q) lying over a quartic
form f(X,Y) intersects the tangent line to C at (s^3, s^2t, st^2, t^3) if and only if
f(s,t) = 0"*. The projection is two-sheeted, the sheets being the two square roots of the
apolar invariant, which is their `z_5^2 = I(φ)`. In `arXiv:2509.15332` §1.1 the same
`I(φ)` and `J(φ)` are introduced as the apolar and catalecticant invariants and
`Δ(φ) = I^3 − J^2` as the discriminant of the *form* `φ`; nothing there is a discriminant
of a residual quadratic either. They never use the word "covariant" of `φ` — the mechanical
grep over both full texts finds no occurrence of "covariant", "Hessian" or "transvectant" at
all.

**A finding, marked as my inference.** The audited note says "the discriminant quartic that
Kaipa and Pradhan attach to a line of `PG(3,q)` is a classical covariant of the syndrome
quartic". Reading their construction against the audited identity, that sentence conflates
two different quartics, and the report should not carry it forward as written:

- Their quartic `φ_L` has coefficients **linear** in the line's coordinates, and its roots
  are the **contact** parameters `u` of the tangent lines that `L` meets. Under the audited
  note's own dictionary this is the *syndrome quartic* `f_a` itself, not a covariant of it —
  the syndrome-to-line map `a ↦ W_a` has Plücker coordinates quadratic in `a`, which is
  precisely the square root Kaipa–Pradhan take, and it is the same square root.
- The audited covariant `I·H − J·F` is degree 4 in `a`, hence **quadratic** in the line's
  coordinates, and its roots are the **residual** parameters `v`: the point of the tangent
  line, other than the point of contact, that lies on the line. Equivalently — and this is
  my derivation from the audited identity plus the apolarity dictionary, not any source's —
  its four roots are the four linear forms `l_v` for which `F = α l_v^4 + m^3 n` is
  solvable, i.e. the four ways to write the quartic as a fourth power plus a cube times a
  linear form.

So the correct statement of what C883 item 5 established is: *the residual-parameter quartic
of the apolar pencil is the covariant `I·H − J·F` of the contact-parameter quartic, which is
the quartic Kaipa–Pradhan attach to the line.* That is a relation **between** their quartic
and a second quartic, not an identification of theirs. I found no source stating it in
either form. This correction is mine and is offered to the lane; I have not edited the
audited note.

## Q3 verdict — the perfect-square locus as a projected Veronese and as a residual component

**Located predecessor for the Veronese half; recorded negative for the elimination half.**

### Located: the perfect-square locus is a projected Veronese, twice

1. **Atiyah**, *A note on the tangents of a twisted cubic*, Proc. Cambridge Philos. Soc.
   **48** (1952), 204–205. Reported by Kaipa, Patanker and Pradhan §3.1, item (3), which I
   read at full text: *"It is observed that the chords of C_3 are represented by a Veronese
   surface V contained in Q, and that the projection from P_0 to H carries the Veronese
   surface V to the locus U of points of intersection of osculating planes of C_4."* Their
   own bracketed restatement identifies the image: *"So the quartic form f(X,Y) = π(L)
   associated with L has exactly two roots of multiplicity 2 each."* A binary quartic with
   exactly two double roots is the square of a squarefree quadratic. So the statement
   "**the perfect-square binary quartics are the projection of a Veronese surface**" is in
   the literature, and it is Atiyah's, transmitted through a source I read at full text. My
   read of Atiyah himself is **secondary only** — Cambridge Core would not serve the paper.
2. **Salmon**, Art. 207, p. 198–199, gives the same locus by equations rather than by a
   parametrization: a quartic has two square factors exactly when
   `(ac−b^2)/a = (ad−bc)/2b = (ae+2bd−3c^2)/6c = (be−cd)/2d = (ce−d^2)/e`, *"a system
   equivalent to two conditions"*, and *"the common value of the fractions"* is `3T/2S`.
   Read structurally, this says `H = (3J/2I) F` on the locus, which is the vanishing of the
   covariant `2I·H − 3J·F` — Salmon says exactly that in the next sentence. So the classical
   description of the perfect-square locus is: the codimension-two locus in `P^4` where the
   Hessian is proportional to the form, cut by the named covariant of Q1. **This is a
   citation the manuscript could use and currently does not have.**

The audited note's supporting relation `27J^2 = I^3` on this locus is consistent with both
but is strictly weaker than either, since the quartic discriminant hypersurface also
contains quartics with a single double root that are not squares. The coordinator's review
had already reached the same conclusion internally; this audit adds that the *classical*
description of the locus is sharper still, being two conditions rather than one.

### Recorded negative: the residual-component role

No source located presents the perfect-square locus as the residual component of an
elimination, or as a projected Veronese appearing beside a catalecticant cubic.

- **Searched domain:** zbMATH Open, query
  `perfect square binary quartic Veronese surface projected quartics two double roots`
  (No Documents Found) and `Veronese surface chords twisted cubic Klein quadric tangents`
  (No Documents Found); Salmon Arts. 207–209; Grace & Young Chapter V; the two
  Kaipa–Pradhan papers grepped for "Veronese" and read at every hit; two web searches.
- **Stop condition:** the only occurrences of a Veronese surface in the twisted-cubic
  literature reached are Atiyah's chord surface and Kaipa–Patanker–Pradhan's restatement of
  it, and neither arises from an elimination or sits beside a catalecticant cubic. The
  catalecticant cubic `J = 0` appears in Kaipa–Patanker–Pradhan only as the invariant whose
  vanishing characterises forms of Waring rank at most two, cited by them to
  [12, Prop. 9.7]; it is never paired with the square locus in a primary decomposition.
- Consequently the *elimination* statement in the terminal-carrier proposition is not
  pre-empted. What is pre-empted, and must now be cited rather than asserted, is the
  identification of that residual component with the perfect-square locus **as a variety**:
  its Veronese parametrization is Atiyah's and its ideal-theoretic description is Salmon's.

## Auditor's own computations

These are mine, not any source's. They are recorded because they are what made the
comparison across normalizations decidable, and because two of them are load-bearing for
the Q1 verdict. All were verified symbolically with `sympy` over `Q[a,b,c,d,e]` — exact
polynomial identities, not numerical fits. Scripts live in the session scratchpad and are
not committed; each result below can be rebuilt in a few lines from the definitions in
§ "Fixed normalization".

1. `(F,T)_3 = −8 I·H + 12 J·F` and `(T,H)_1 = 32 F·(2 I·H − 3 J·F)`, both λ = −3/2.
2. `(H,H)_2 = −(1/6) I·H + (1/2) J·F`, λ = −3. Items 1 and 2 reproduce the ratios recorded
   in the audited note under its own scaling, which is an independent check on that note.
3. Salmon's root-form covariant `Σ_δ (α−β)^2(β−γ)^2(γ−α)^2 (x−δ)^4`, summed over the four
   roots with `{α,β,γ}` the complementary triple, equals `−384 I·H + 576 J·F
   = −192 (2 I·H − 3 J·F)`. This verifies Salmon's printed `3TU − 2SH` in the fixed
   normalization and is what licenses the claim that his element is λ = −3/2, not λ = −1.
4. `Hess(I·H + λ J·F) = α I^3 H + β J^2 H + γ I^2 J F` with `γ = λ/6 + 1/4`. Hence λ = −3/2
   is the **unique** member of the pencil whose Hessian is proportional to `H`. This is the
   intrinsic reason the classical element is the one it is.
5. Invariants of the audited covariant: `I(C_{−1}) = I^4/12 − 2 I J^2`,
   `J(C_{−1}) = −I^6/216 + I^3 J^2/6 − J^4`, hence `Δ(C_{−1}) = J^6 · Δ`. The audited
   covariant therefore has its own clean discriminant identity, parallel to but different
   from Duke's `Δ K_F = J^2 Δ^3`, which I also checked in the same normalization and which
   agrees with his printed statement.
6. Root interpretation of the audited covariant (inference, from the audited identity plus
   the standard apolarity dictionary): the four roots `v` of `I·H − J·F` are the four linear
   forms `l_v` admitting `F = α l_v^4 + m^3 n`; equivalently the residual simple roots of
   the four members of the apolar pencil carrying a repeated root; equivalently the residual
   parameters of the four points where the line `W_a` meets the tangent developable of the
   twisted cubic. Used in the Q2 verdict.

## Source table with read depths

Read depth is recorded for every source named anywhere in this report, including sources
named only to dismiss them and sources that could not be obtained.

| Source | Read depth | Access, version, sections |
|---|---|---|
| Salmon, *Lessons Introductory to the Modern Higher Algebra*, 4th ed., Hodges Figgis / Longmans (1885) | **full text at the load-bearing statements** | Internet Archive item `lessonsintroduc01salmgoog`, `_djvu.txt` OCR, downloaded 2026-08-07, 753,090 bytes. Arts. 207–209, pp. 198–201, read in full; whole OCR mechanically grepped. Version read is the 4th edition; Duke cites the 5th edition p. 201, which is the same passage repaginated. Not added to the shared cache: the artifact is an OCR text file, not a PDF, and the cache's ingest sniff rejects non-PDF bytes by design. |
| Grace & Young, *The Algebra of Invariants*, Cambridge University Press (1903) | **full text at the load-bearing statements** | Internet Archive items `algebraofinvaria00graciala` (667,535 bytes) and `algebrainvarian02gracgoog` (564,041 bytes), two independent scans, both `_djvu.txt`, downloaded 2026-08-07. Contents page; Chapter V §§83–94, pp. 85–100, read in full; the two `iH − jf` reductions cross-checked in both scans. Chapters XI and XIV (apolarity) read at the Contents level only. Not cached, same reason as Salmon. |
| Burnside & Panton, *The Theory of Equations: with an introduction to the theory of binary algebraic forms*, Dublin University Press Series | **full text at the load-bearing statements** | Internet Archive item `theoryofequation00burnuoft`, catalogued there as 1892, `_djvu.txt`, downloaded 2026-08-07, 974,873 bytes. Art. 180 (pp. 403–405) and the opening of Art. 181 read in full; whole OCR grepped. This is the source Duke cites as `[3, §180]`. The scanned volume's title page carries no volume number, so none is asserted here; Duke cites the Dover two-volume reissue, which was not consulted. Not cached, same reason. |
| Duke, *On Elliptic Curves and Binary Quartic Forms*, IMRN, DOI `10.1093/imrn/rnab249` | **full text at the load-bearing statements** | Cache key `10.1093/imrn/rnab249`, SHA-256 `beeabac0d615d28a5189bfeed6759d08fe154a91d8836a41cd7288a8942f569b`, fetched 2026-08-07 from `math.ucla.edu/~wdduke/preprints/elliptic.pdf`. §5 pp. 6–8 read in full including (5.1)–(5.8) and Proposition 1 and Lemmas 1–2; the invariant definitions on p. 4; the reference list. Version read is the author's posted preprint, **not** the published IMRN version; the DOI is used only as the identifier. §8 was grepped, not read. |
| Elliott, *An Introduction to the Algebra of Quantics*, 2nd ed. (1913) | **partial** | Internet Archive item `introductiontoal00elliiala`, `_djvu.txt`, downloaded 2026-08-07, 938,639 bytes. §207 (apolarity, pp. 266–267) and §223 (geometry of the concomitants of a quartic, pp. 282–283) read; §§80, 81, 142, 170, 216 located and skimmed at their opening statements only; whole OCR mechanically grepped for every coefficient pattern. Not cached, same reason. |
| Kaipa, Patanker, Pradhan, *On the PGL_2(q)-orbits of lines of PG(3,q) and binary quartic forms*, `arXiv:2312.07118` | **partial** | Cache key `arXiv:2312.07118`, SHA-256 `2ea8efc04bbf42be0919288e5e3777a4010ae30940bf8fec3a5c32feef789752`, fetched 2026-07-19. Read this session: §1.2 (the projection construction, the quartic, the apolar and catalecticant invariants, the two-sheeted covering), §1.3 opening, the Figure 1 diagram of the sequence of maps, and §3.1 items (3)–(5) restating Atiyah. Whole text grepped for `covariant`, `apolar`, `catalecticant`, `Hessian`, `transvectant`, `Veronese` and every hit inspected. The published version was not consulted. This is my own read at the depth the Q2 and Q3 verdicts require, recorded as mine and independent of the earlier reviewer's partial read of the same key. |
| Kaipa, Pradhan, *Incidence of lines, points and planes in PG(3,q) with respect to the twisted cubic*, `arXiv:2509.15332` | **partial** | Cache key `arXiv:2509.15332`, SHA-256 `f11b17aeebe9c4fca18c1486853664cb1fd075e24ceb2e0156023e1d529ee726`, fetched 2026-08-07. Read this session: the invariant-definition block around equations (15)–(18), the apolar/catalecticant naming, the discriminant and j-invariant definitions, and the Klein-coordinate discussion including `Q : (z_0z_4 − 4z_1z_3 + 3z_2^2)/3 = z_5^2`. Now also published as Des. Codes Cryptogr., DOI `10.1007/s10623-026-01920-z` (bibliographic detail from Crossref, a consulted source); the published version was **not** read. |
| Cremona, *Reduction of binary cubic and quartic forms* | **abstract/metadata only** | Surfaced twice as a free PDF at `johncremona.github.io/papers/r34jcm.pdf` in web-search result listings, together with the accompanying *On the equivalence of binary quartics*. **Not fetched and not read.** Named only to record that the modern reduction-theory literature on binary quartics — the place a reader would next look for a name for an element of the `I·H`, `J·F` space — was identified and left unexamined. Carried forward as an open gap, not as a searched negative. No bibliographic detail is asserted, because none was taken from a consulted source. |
| Atiyah, *A note on the tangents of a twisted cubic*, Proc. Cambridge Philos. Soc. **48** (1952), 204–205 | **secondary only** | Could not be obtained: Cambridge Core returned HTTP 500 and the article is behind a paywall; no repository copy located. Its content is used here **only** through Kaipa, Patanker and Pradhan §3.1, which I read at full text, and the bibliographic detail comes from a web-search result listing plus their reference to it. The Veronese-surface claim in the Q3 verdict is therefore attributed to Atiyah at secondary depth and is **unverified against Atiyah's own text**. |
| Cayley, *A fifth memoir upon quantics*, Phil. Trans. R. Soc. **148** (1858), 429–460, §134 | **secondary only** | Could not be obtained: `royalsocietypublishing.org` returned HTTP 403. Named only because Duke cites it as a source for the identities adjacent to `K_F`. Bibliographic detail is taken verbatim from Duke's reference list, a source read at full text; the content attribution is Duke's and is unverified against Cayley. |
| Edge, *Binary forms and pencils of quadrics*, Proc. Cambridge Philos. Soc. **73** (1973), 417–429 | **review only** | zbMATH Open, Zbl 0254.50008: record and review text read. The only document zbMATH returns for `binary quartic covariant apolar pencil`. Screened out: its apolarity is the in/outpolarity of pairs of quadrics, not the apolar pencil of cubics of a binary quartic. |
| Kaipa, *Deep Holes and MDS Extensions of Reed–Solomon Codes*, IEEE Trans. Inform. Theory, DOI `10.1109/TIT.2017.2706677` | **abstract/metadata only** | Used only as the coding-theory forward-citation seed. Metadata (DOI, OpenAlex `W2563545890`, three citation counts) retrieved from the three graphs this session. The paper itself was not opened for this audit. |
| Kaipa, Pradhan, *…binary quartic forms in characteristic three*, Finite Fields Appl., DOI `10.1016/j.ffa.2025.102763` | **abstract/metadata only** | Bibliographic detail from Crossref this session; named only to record that Semantic Scholar mis-resolves `arXiv:2312.07118` onto this record (see § "Screened sets"). Not read. |
| Abdesselam & Chipalkatti (attributed from a search-result listing), *Apolarity and covariant forms*, Illinois J. Math. **51** (2007), no. 1 | **abstract/metadata only** | Surfaced twice in web search as the nearest modern treatment of "which covariants are apolar to a form". Retrieved as a Project Euclid result listing only; **not** fetched, not read, and the author attribution is from the listing rather than from the paper. Named because it is the most plausible unexamined home for a modern name for our combination, and is therefore carried forward as an open gap rather than as a searched negative. |

## Screened sets

The verdicts above do not rest on any citing set — they rest on direct reads of the
classical treatises and of Duke. The citing sets were screened to discharge the
forward-citation requirement, and both came back empty under the discriminator.

**Discriminator, applied verbatim to both sets, over title and (where the title was
ambiguous) abstract:** *does the citing work state a covariant identity for a binary
quartic, name an element of the space spanned by `I·H` and `J·F`, or identify the quartic
attached to a line of `PG(3,q)` as a covariant of an apolar quartic?*

### Set 1 — coding-theory seed

**Seed, pinned:** Kaipa, *Deep Holes and MDS Extensions of Reed–Solomon Codes*, DOI
`10.1109/TIT.2017.2706677`, OpenAlex `W2563545890`, Semantic Scholar
`72dd1f6925426b6983d72235c8bb44001a771fa2`.

| graph | count | note |
|---|---|---|
| OpenAlex | 20 | filter `cites:W2563545890` |
| Crossref | 16 | `is-referenced-by-count` on the DOI |
| Semantic Scholar | 28 | `citationCount` on the DOI |

The three disagree by twelve, which is the disagreement the convention anticipates and is
recorded as a finding rather than reconciled. **The largest set (Semantic Scholar, 28) was
screened**, over title and year, with all 28 titles retrieved and inspected. Result: none.
The set is entirely deep-hole, covering-radius, extended-code and coset-weight-distribution
coding theory, plus one geometry-side member, Davydov, Marcugini and Pambianco, *On planes
through points off the twisted cubic in PG(3,q) and multiple covering codes* — which is an
incidence and covering-code paper, not a covariant paper. No member states a covariant
identity.

### Set 2 — invariant-theory / elliptic-curve seed

**Seed, pinned:** Duke, DOI `10.1093/imrn/rnab249`, OpenAlex `W3199000661`, Semantic
Scholar `50ccf9e00bf2af2313af0eea4943fa5f8245bd98`.

| graph | count | note |
|---|---|---|
| OpenAlex | 2 | filter `cites:W3199000661`; one of the two is `10.2140/ent.2022.1-1`, typed by OpenAlex as `paratext` with a null title — journal front matter, not a citing work |
| Crossref | 1 | `is-referenced-by-count` on the DOI |
| Semantic Scholar | 0 | the DOI resolves to a record titled "OUP accepted manuscript" with `citationCount` 0 |

Screening the largest set (OpenAlex, 2) leaves one real citing work: *A Diophantine problem
about Kummer surfaces*, Essential Number Theory (2022), DOI `10.2140/ent.2022.1.51`,
screened on title and journal. It does not meet the discriminator.

**Two indexing defects, reported as findings.** Semantic Scholar's record for Duke's DOI
carries the placeholder title "OUP accepted manuscript" and a zero citation count; a
title-based search on that service does not surface the paper at all. Separately, Semantic
Scholar resolves `arXiv:2312.07118` onto the record for the *characteristic-three* companion
paper (paperId `ed5167475d3020e74f41e730cff0c2b1021a910a`, citationCount 3) rather than onto
the paper that arXiv identifier actually names. Both are exactly the kind of silent
mis-resolution the pinned-identifier rule exists to catch, and both argue against ever using
Semantic Scholar alone for this lane.

### Set 3 — finite-geometry seed

**Seed, pinned:** Kaipa, Patanker, Pradhan, `arXiv:2312.07118`, OpenAlex `W4389714229`.
OpenAlex reports 0 citing works; Crossref has no record under the arXiv DOI; the published
Finite Fields Appl. version of the *companion* paper (DOI `10.1016/j.ffa.2025.102763`) shows
0 in Crossref. The forward tree here is empty, which is why the geometry side of Q2 was
discharged by direct reading rather than by screening. The larger geometry citing set
seeded on Blokhuis–Pellikaan–Szőnyi (OpenAlex 13 / Crossref 10 / Semantic Scholar 21) was
already screened under a different discriminator in the C881 audit and was not re-screened
here.

## Coverage statement

**Searched and found nothing — licenses the negatives above.**

- The six classical treatises listed in the source table, mechanically grepped in full and
  read at their quartic and apolarity sections: no occurrence of `I·H − J·F`.
- zbMATH Open, four queries (recorded verbatim below). Three returned the literal page
  "No Documents Found — zbMATH Open" at HTTP 200, which is how that service distinguishes an
  empty result from an error; the fourth returned exactly one document. zbMATH Open is
  freely reachable and was reached.
- The two citing sets above, screened under the stated discriminator.

**Could not access — licenses nothing, carried forward as open gaps.**

- **MathSciNet: NOT COVERED.** Institutional authentication, not reachable from this
  session. Every "to our knowledge" that it would have gated stays in force.
- **Google Scholar: NOT COVERED.** Blocks automated access.
- **Atiyah 1952.** Cambridge Core returned HTTP 500; paywalled; no repository copy located.
  The Q3 Veronese attribution rests on Kaipa–Patanker–Pradhan's report of it.
- **Cayley, Fifth Memoir upon Quantics, §134.** `royalsocietypublishing.org` returned
  HTTP 403. Duke's attribution of the adjacent identities to Cayley is unverified.
- **Clebsch, Gordan, Sylvester, Olver, Dixmier, Kung & Rota, Dolgachev — NOT OBTAINED.**
  The task named these and none was fetched. Clebsch's *Theorie der binären algebraischen
  Formen* and Gordan's *Vorlesungen* were searched for on the Internet Archive under their
  German titles and returned zero matches for the queries used; Olver's *Classical Invariant
  Theory* and Dixmier are not free; Kung & Rota's *The invariant theory of binary forms* was
  surfaced as a free Project Euclid PDF but not fetched; Dolgachev's lecture notes were not
  fetched. **This is the largest single gap in the audit.** Kung & Rota and Dolgachev are the
  two most likely to carry a modern name for an element of the space and should be the first
  reads if this verdict is ever challenged. The Q1 negative is therefore a negative over
  Salmon, Grace & Young, Elliott, Burnside & Panton and Duke, and must be stated
  with that boundary named rather than as a negative over "the classical literature".
- **Abdesselam & Chipalkatti, *Apolarity and covariant forms*, and Cremona's two papers on
  the reduction and equivalence of binary quartics.** All three surfaced as free PDFs in
  web-search listings, none was fetched, none was read. Carried as open gaps for Q1 and Q2:
  they are the modern literature closest to the question and the most likely place for a
  name that Salmon's tradition does not supply.
- The published journal versions of Duke (IMRN) and of both Kaipa–Pradhan papers were not
  obtained; preprints or author copies were read instead, and this is recorded in the source
  table.

**Not added to the shared cache.** The six classical treatises were retrieved as Internet
Archive `_djvu.txt` OCR files, not PDFs. The cache's `add` refuses non-PDF bytes by design —
that refusal is the integrity check the cache exists for — so these were not ingested. Their
provenance is instead pinned by Internet Archive item identifier and byte count in the source
table, which is reproducible: `https://archive.org/download/<id>/<id>_djvu.txt`. Duke's paper
was already ingested by the earlier reviewer under key `10.1093/imrn/rnab249`; I re-read those
same bytes and the SHA-256 in the source table is the one the cache reports.

## Verbatim queries

Internet Archive (metadata search, `advancedsearch.php`, `output=json`):

```
q=title:(algebra of invariants) AND creator:(Grace)
q=title:(modern higher algebra) AND creator:(Salmon)
q=title:(algebra of quantics) AND creator:(Elliott)
q=title:(binaeren algebraischen Formen) AND creator:(Clebsch)          -> numFound 0
q=title:(Vorlesungen ueber Invariantentheorie)                          -> numFound 0
q=title:(theory of equations) AND creator:(Burnside)
```

Full texts downloaded, each `https://archive.org/download/<id>/<id>_djvu.txt`:
`algebraofinvaria00graciala`, `algebrainvarian02gracgoog`, `lessonsintroduc01salmgoog`,
`introductiontoal00elliiala`, `theoryofequation00burnuoft`, `cu31924001568959`.

Mechanical grep over all six OCR texts (ripgrep, case-insensitive), the load-bearing
negative for Q1:

```
rg -n -i 'iH ?- ?jf|jf ?- ?iH|SH ?- ?TU|TU ?- ?SH|2SH|3TU|2iH|3jf|2IH|3JF'
```

Four hits, all quoted in the Q1 verdict; no hit for any spelling of λ = −1.

zbMATH Open (`https://zbmath.org/?q=…`; empty result identified by the literal page title
"No Documents Found - zbMATH Open" returned at HTTP 200):

```
binary quartic covariant apolar pencil                                  -> 1 document, Zbl 0254.50008
"twisted cubic" "binary quartic" covariant                              -> No Documents Found
apolarity binary quartic pencil of apolar cubics                        -> No Documents Found
perfect square binary quartic Veronese surface projected quartics two double roots -> No Documents Found
lines PG(3,q) twisted cubic binary quartic invariant apolar             -> 1 document, arXiv:2312.07118
binary quartic "two square factors" covariant Salmon                    -> No Documents Found
Veronese surface chords twisted cubic Klein quadric tangents            -> No Documents Found
```

Citation graphs (each service queried separately; an empty or missing record is
distinguished from an error by the HTTP status plus the presence of a well-formed JSON
envelope — OpenAlex returns `meta.count`, Crossref returns `message.is-referenced-by-count`,
Semantic Scholar returns an explicit `citationCount` field or a 429 rate-limit body, which
was retried rather than read as zero):

```
https://api.openalex.org/works/doi:10.1093/imrn/rnab249
https://api.openalex.org/works?filter=cites:W3199000661&per-page=50
https://api.openalex.org/works?filter=cites:W2563545890&per-page=50
https://api.crossref.org/works/10.1093/imrn/rnab249
https://api.crossref.org/works/10.1109/TIT.2017.2706677
https://api.crossref.org/works?query.bibliographic=Kaipa Patanker Pradhan orbits of lines PG(3,q) binary quartic forms
https://api.semanticscholar.org/graph/v1/paper/DOI:10.1093/imrn/rnab249?fields=paperId,title,citationCount
https://api.semanticscholar.org/graph/v1/paper/DOI:10.1109/TIT.2017.2706677/citations?fields=title,year,externalIds&limit=50
https://api.semanticscholar.org/graph/v1/paper/arXiv:2312.07118?fields=paperId,title,citationCount
```

Web searches (four, all load-bearing for a negative):

```
binary quartic covariant "2IH - 3JF" OR "3TU - 2SH" OR "iH - jf" degree four order four
"apolar" pencil of cubics binary quartic "residual quadratic" discriminant covariant
"binary quartic" covariant roots "l^4" plus "cube" times linear four ways decomposition apolar pencil repeated root
"apolar" binary quartic pencil cubic "double root" residual root covariant quartic four linear forms "l^4 + " decomposition classical
Atiyah "note on the tangents of a twisted cubic" 1952 Veronese surface chords Klein quadric
```

The first returned Duke's preprint as the sole match for the coefficient string, which is
the strongest single piece of evidence that λ = −3/2 is named and λ = −1 is not.

## Proposed claim–proof–novelty ledger row (draft only — NOT applied)

Drafted in the wording style of the existing rows in
`papers/beyond4_prs/claim-proof-novelty-ledger.md`. **I have not edited that ledger or any
manuscript file.** Two rows are proposed rather than one, because the covariant identity and
the perfect-square-locus identification have different statuses and the ledger's rule is one
home per novelty claim.

```
| R5-COV | the discriminant of the residual quadratic of the apolar pencil is the covariant IH − JF of the syndrome quartic | MANUSCRIPT / NONE-FOUND | an identity of integer polynomials in the divided-power syndrome and the dual variable, so valid in every characteristic including two and three. The two-dimensional space of degree-four order-four covariants of a binary quartic is classical, and one of its elements is named: 2IH − 3JF is Salmon's 3TU − 2SH (Lessons Introductory to the Modern Higher Algebra, 4th ed., Art. 207, p. 199, where it is given as the root sum Sum (a−b)^2(b−c)^2(c−a)^2(x−d)^4 and shown to vanish identically exactly when the quartic has two square factors), Grace and Young's iH − jf (Algebra of Invariants, Sec. 94, p. 99), and Duke's K_F (IMRN, eq. 5.6). Ours is a different element: 2IH − 3JF is the unique member of the space whose Hessian is proportional to H, which is why it is the one the classical reduction tables name, and IH − JF has no such property. No source in the recorded search states the residual-quadratic discriminant as a covariant, in either the classical apolarity literature or the twisted-cubic line literature; Kaipa, Patanker and Pradhan define their quartic by projection of the Klein quadric and characterise its roots as the contact parameters of tangent lines met, never as a discriminant and never as a covariant. Search boundary, read depths, three separate citation-graph counts, and the named unread sources are in notes/2026-08-07-c883-covariant-literature-audit.md |
| R5-SQ | the residual component of the reduced terminal carrier is the locus of syndrome quartics that are perfect squares | MANUSCRIPT / PRIOR-ART-VARIETY | the elimination equality is ours; the variety is not. That the perfect-square binary quartics are the projection of a Veronese surface is Atiyah's (A note on the tangents of a twisted cubic, Proc. Cambridge Philos. Soc. 48 (1952), 204--205), reported by Kaipa, Patanker and Pradhan Sec. 3.1(3) as the image of the chord surface of the twisted cubic; and the same locus is Salmon's system of two conditions H proportional to F with ratio 3J/2I, Art. 207, p. 198--199, equivalently the vanishing of the covariant 2IH − 3JF. The relation 27J^2 = I^3 is supporting evidence only, since the quartic discriminant hypersurface also contains nonsquare quartics. No source presents this locus as the residual component of an elimination or beside a catalecticant cubic |
```

Consistency note for whoever applies these: if `R5-COV` is adopted, the sentence in
`notes/2026-08-07-c883-hankel-plucker-covariant.md` § Result reading "The discriminant
quartic that Kaipa and Pradhan attach to a line of `PG(3,q)` is a classical covariant of the
syndrome quartic" contradicts it and must be rewritten first — see the Q2 verdict. Surfaces
that would then repeat the claim and must be checked: the manuscript's redundancy-five and
recursive-carrier sections, this ledger, `papers/beyond4_prs/literature-audit.md`, the lane
handoff, and the audited note itself.

## Cross-lane implications (observations, not deliverables)

Judged from the sources I read for the primary questions, plus two short orientation reads
named below. These are routing observations for the owning lanes, not audit verdicts, and I
have edited nothing outside this report.

Orientation sources, with read depths:

| Source | Read depth | What was read |
|---|---|---|
| `papers/summary/README.md` | **partial** | the numbered one-paragraph statements for the arcs paper and for the four Clebsch papers, and nothing else |
| `papers/papers-index.md` | **partial** | the theorem-registry rows matching `secant`, `defect`, and `outside a conic`, and the header line for `arcs_complete_outside_conic`; the Clebsch rows were read only where they appeared in the same grep output |
| `notes/2026-08-07-c815-harmonic-moment-and-apolarity.md` | **partial** | the header, the module description for `SphericalMomentFunctional`, and the theorem-name table; read strictly read-only and treated as mid-edit, not as settled |

### 1. Arcs Complete Outside a Conic — a clean negative, with the reason

**No contact. Do not spend effort here on my account.** The paper's "secant moments" are, per
the registry row `thm-secant-moments`, the two counting identities
`Σ r = C(k,2)(q−1)` and `Σ C(r,2) = 3 C(k,4)` over the point-index function of a finite arc.
These are double-counting identities for a finite point set in `PG(2,q)`. The classical
"moments" that appear in the apolarity material I read are something else entirely: the
pairing of a form with powers of linear forms, whose vanishing is apolarity and whose matrix
is the catalecticant. The two share only the English word. Nothing in Salmon, Grace & Young,
Elliott, Burnside & Panton or Duke pairs a form against a counting function on a finite
point set, and the transvectant calculus operates on coefficient vectors of a single form, not
on incidence counts. **This is my inference, and it is a negative one:** I see no route by
which the secant-defect identity or its remainder is a transvectant or apolarity statement in
disguise, and therefore no classical sharpening of the equality criterion and no higher-moment
continuation to import. Ranking: **would not change a proof, would not sharpen a bound, would
not supply a citation.** The only thing I would flag to that lane is terminological: if the
manuscript ever says "moment condition" near the word "apolar", a reader from the invariant
theory side will expect the classical pairing, so the two senses should be separated in
prose. That is an editorial note, not a mathematical one.

The same conclusion applies to `notes/2026-08-07-c815-harmonic-moment-and-apolarity.md`, whose
`gaussianMoment` is a Gaussian integration functional on `MvPolynomial (Fin 3) ℝ` with weights
given by double factorials. That is the probabilistic sense of moment, a third distinct sense.
I found no bearing of the binary-form apolarity material on it. **My inference.**

### 2. The Clebsch group — one real contact point, one honest "I did not read the right thing"

Everything I read at depth is about **binary** forms. The Clebsch objects are ternary — a
six-arc in `PG(2,11)`, conics, cubic surfaces, the Clebsch hexagon — and the classical
apolarity that governs them is the ternary theory: Sylvester's pentahedron, the Aronhold
invariants `S` and `T` of a ternary cubic, apolar conics. **I did not read any of that**, so
on the substantive questions asked — whether the recurring factor of five, the `√(5 J₀)` twist,
or the operator identity `B² = 5I` have a classical explanation — my answer is that **I have
no evidence either way, and I decline to guess.** That is a coverage statement, not a negative.

Two concrete pointers, each with its read depth stated, offered so the owning lane does not
have to rediscover where to look:

1. **Salmon, Art. 209, p. 200 — read at full text.** Salmon records "Mr. Burnside's remark on
   the identity of the theory of the quartic with that of a pair of conics", carried out by
   the substitution `x, y, z` for `x², 2xy, y²`: the binary quartic
   `(a,b,c,d,e)` becomes the conic `ax² + cy² + ez² + 2dyz + 2czx + 2bxy = 0` constrained by
   `xz − y² = 0`, and *"the invariants of the system of two conics are also invariants of the
   quartic"*, with the resolvent cubic appearing as the discriminant of the pencil
   `4λ³ − Sλ + 2T = 0`. This is a genuine, classical, explicit bridge from the binary
   invariant theory I read into the geometry of pairs of conics, and it is the natural place
   to look for a classical name for a conic-side operator built from a binary quartic.
   **Whether it bears on `B² = 5I` I cannot say — that is an inference I am not in a position
   to make.** Ranking: **alternative viewpoint, possibly a citation.**
2. **Grace & Young, Chapters XII–XIV — Contents read only, chapters not read.** Their
   Chapter XII "Ternary Forms" (p. 246), Chapter XIII "Ternary Forms (continued)" (p. 274)
   and Chapter XIV "Apolarity (continued)" (p. 299) are the ternary counterpart of exactly the
   material that settled Q1 here, and their index carries an entry "Quartics which possess an
   apolar conic". Their Chapter X is titled "Geometry". If the Clebsch lane wants a classical
   predecessor for an apolarity or operator statement about conics and cubics, this is the
   book to open, and the method that worked in this audit — convert every author's
   normalization into one fixed normalization and compare the intrinsic ratio, never the
   printed coefficients — is the part worth reusing. Ranking: **method transfer plus a likely
   citation source; nothing here changes a proof today.**

One further remark, marked as my inference. The single most transferable finding of this
audit is procedural rather than mathematical: a two-dimensional space of covariants contains
infinitely many elements, exactly one of which the classical literature names, and the named
one is picked out by a self-reproduction property (its Hessian returns the Hessian) rather
than by anything a reader would guess. Any Clebsch-side claim of the form "this operator /
this cubic is the classical one" should be checked the same way — identify the space, find
the intrinsic property that pins the classical choice, and only then compare coefficients.
