# Icosahedral MDS / deep-holes = conic — spin-off lane

**Date**: 2026-07-13
**Status**: CONVERGED after C121–C127 + four adversarial/Tao passes (red-team, dual-variety exam,
Thread A rigidity, Thread B loop-back). Scoped to a **modest single-spine finite-geometry paper**.
Headline = the **RIGIDITY THEOREM** (Clebsch hexagon is the unique 6-arc in PG(2,11) whose deep
holes lie on a conic, recovering A₅) + p=11 uniqueness (now with a 2-line counting proof) + the
certified chirality-Z/2 proposition. **Klein two-spine "because" struck** (false by C126); **dual-
variety conjecture / C123 DEAD** (2 independent passes, q=19 counterexample + k=4 impossibility);
11-cell/j-function decorative. Loop-back: this is the extremal instance of the **parent conic-
involution Schreier program**.
**Next session:** Dye gate CLEARED (C129, draftable now w/ footnote; citations locked). Remaining:
(1) Lean-ify the rigidity theorem + Schreier=icosahedron graph (both `decide`-grade); (2) reconcile
the two docs' P¹ labeling; (3) write the single-spine draft (headline = rigidity theorem; ZWK/DMP/
Hirschfeld–Sadeh citations in hand); optional: ILL Dye 1991 to close the footnote.
**Companion log**: append dated riffs to
[`done/2026-07-13-icosahedral-mds-deep-holes-archive.md`](done/2026-07-13-icosahedral-mds-deep-holes-archive.md)
(create on first archive).
**Related lanes**: arcs manuscript (`arcs_complete_outside_conic`, Prop `prop:q11-code`);
[twisted-cubic transversal-spectrum](2026-07-13-twisted-cubic-transversal-spectrum.md) (k=4 lift
lives there); paper #1 icosahedral-extension-complex (`comp-q11-icosahedral`) — this lane **fuses
with it** via the A₅ orbit.

## The object

The projectively **non-GRS `[6,3,4]₁₁` MDS code** of covering radius 3 (`comp-q11-mds-deep-holes`,
Lean `RelativeConicArcs/Q11Coding.lean`, `Q11Semantic*.lean`, coords `Examples.lean:46`,
conic `XZ=Y²`). Equivalently a **6-arc off every conic** in PG(2,11).

**Confirmed structure (Fable, against Lean coords):**
- Each of the 6 arc points is an **external point** of the deep-hole conic; its two tangency points
  are exactly its **missed antipodal pair** (`witness_chords_miss_antipodes`, `witnessMissingEdge`;
  all six match, e.g. witness 0 = (1,10,0), tangents {0,9} = missing edge (0,9)).
- So the **arc = poles of the six antipodal chords = poles of the six 5-fold axes of the A₅
  (icosahedral) action** on the 12 conic points (A₅ ⊂ PGL₂(11), classical at q=11).
- **Arc stabilizer in the conic stabilizer PGL₂(11) is exactly order 60 = A₅**; point-stabilizer
  order 10 = D₁₀. Single A₅-orbit.
- This answers *why* deep holes are a conic and **unifies this lane with paper #1**.

## Verified facts (cheap, Lean-able)

- Coset-leader-weight distribution **(1, 60, 1150, 120)**, sums to 11³=1331. `60=6×10`,
  **`120 = 12×10`** = (12 conic points)×(10 scalars) — "deep holes = conic" made quantitative.
- Codeword weight enumerator **(1,0,0,0,150,420,760)** (MDS-forced; verified vs formula).
- **(900,150,100)** = split of the 1150 distance-2 cosets by leader count (1/2/3), tied to the
  secant-index spectrum (90,15,10)×10 (`Q11SemanticLeaders.lean`, `Q11SemanticSpectrum.lean`). NOT
  the min-weight codewords (=150) — do not conflate (numerical coincidence only).
- **Every deep-hole coset has exactly C(6,3)=20 leaders** (uniform 20-way tie).
- Code is **not completely regular** (distance-2 leader counts non-constant) → no naive
  association scheme.

## ⚠ RED-TEAM DEFLATION (adversarial pass — OVERTURNS the fused framing below)

A hostile-referee pass (read SVM 1995 full text, DMP series, ZWK; Dye 1991 still paywalled) cut the
lane down. **What actually survives — treat this as the current framing; the "FUSED FRAMING" section
below is DEMOTED to companion history:**

- **Headline "deep holes = the conic": TRUE but corollary-grade.** It is *exactly equivalent* (via
  DMP 2021 arXiv:2101.12722 Thm 6.3, the known arc↔coset dictionary — our own C122 concedes this) to
  one finite-geometry sentence: *the extension points of the Clebsch hexagon in PG(2,11) are the 12
  points of its A₅-invariant conic.* SVM 1995 Prop. 13 already proved incompleteness-by-computer at
  q=11 but **did not print the extension points** — that one unprinted finite fact + a known
  dictionary is the real contribution. True, apparently unstated, thin.
- **Dye-1991 gate: CLEARED (C129, strong proxies) — safe to draft with a footnote.** Verdict **NO**:
  Dye does not state the 0-bisecant points = the conic. Evidence: the **zbMATH review Zbl 0698.20032
  is written by Dye himself** (detailed contents: Brianchon points, 5 triangles, the self-polar conic
  C, stabilizers, double-contact conics — *no* 0-bisecant/no-secant statement); Dye's own open 1997
  Edinburgh paper recaps 1991 page-by-page, strongest conic-incidence being only "C contains no
  vertex" (p.281); **SVM 1995 Remark 2** extracts the *only* bisecant-stratum↔C fact Dye has
  (Brianchon∈C iff q=3^(2h)) and proves q=11 incompleteness **by computer without using Dye** — which
  they'd have cited if it existed. Structural: "C misses every bisecant" is a per-q rationality fact
  (false over general K, false at q=9), with no home in Dye's synthetic general-K paper. Residual risk
  LOW (a finite-field aside in the 17-pp body); keep the ILL request open
  (`londmathsoc.onlinelibrary.wiley.com/doi/pdf/10.1112/jlms/s2-44.2.270`) but draft now.
- **Klein spine: DECORATION, and the causal "because" is FALSE by our own data.** f mod 11 is the
  PGL₂(11)-invariant Dickson form (forgot the icosahedron); and C126 shows covering-exactness *fails*
  for every sibling — so the Klein reduction produces the *objects* but does NOT cause the *theorem*.
  **Strike "because"; drop the two-spine architecture.** Keep Klein as a discussion-section remark
  (cf. Elkies §3.3); p+1=12 is a triviality, a remark not an organizing principle.
- **Dual-variety conjecture: DEAD — CONFIRMED by a second independent pass with proofs. C123 = NO-GO.**
  The dual-variety examination (read ZWK full text) kills it five ways: (i) ill-posed (non-GRS columns
  aren't on any RNC — only an *existential-curve* repair parses); (ii) **tautology at k=3** — in
  P(Sym²) the RNC, its dual, and the discriminant conic all coincide (self-dual), so q=11 gives zero
  evidence distinguishing "dual variety" from "RNC" from "quadric"; (iii) **FALSE as a k=3 law by our
  own arc family** — the Clebsch hexagon at **q=19** has ≥105 deep holes (counting: 381 pts − 15
  bisecants×18) vs 20 for a conic; same arc, next prime, dead; (iv) **impossible at k=4** in both
  radius regimes (every plane meets the ruled developable in ~q rational pts → not deep holes; and
  bisecant capacity gives Ω(q³) deep holes vs ~q² on the developable); (v) **ZWK 2020 already
  subsumes+refutes the GRS shadow** — for PRS redundancy-4, deep holes = tangent-developable ∪
  quadratic-extension family, the dual-variety part a ~2/q *sliver*, not an equality. **Do NOT run
  C123** (would test an impossible equality against an empty uncovered locus in the degenerate char-3
  fields). Replace the "forward half" with the **ZWK stratification/excision framing** (below).
- **Replacement forward framing (survives):** *the Clebsch hexagon's bisecants excise the non-split
  (quadratic-extension) strata exactly, leaving the disc=0 stratum — a covering coincidence provably
  unique within its own arc family* (fails at q=19 by counting). Two citable impossibility lemmas
  (plane-meets-ruled-surface; bisecant capacity q³/2) + the q=19 counterexample close R3/D2 cleanly,
  no compute. Only surviving forward *question* (pose, don't conjecture): does any radius-4 non-GRS
  MDS code have deep-hole locus = F_q-points of a *twisted cubic* (the curve, not its developable)?
  — no candidate arc/mechanism.
- **Chirality Z/2: survives as a PROPOSITION** (canonical automorphism-invariant Z/2 on deep-hole
  leaders, Lean-certified) — but the group theory is exercise-grade (PSL(2,5) not 3-homogeneous;
  Hom(A₅,ℤ/2)=0). Not a headline.
- **11-cell (F1) and j-function (F2): STRIKE / demote to one remark.** F1 uses the degree-11 PSL₂(11)
  action — the very numerology the mirage list bans conflating with our degree-12 object (internal
  contradiction). F2 is a re-labeling of the N2 syzygy. No independent content.

**Surviving paper (modest, single-spine, finite-geometry/designs venue — NOT IEEE TIT):** *"The
Clebsch hexagon code: the deep holes of a `[6,3,4]₁₁` MDS code are the points of the A₅-invariant
conic."* Known hexagon (SVM 1995, Dye 1991) × known dictionary (DMP 2021) → first MDS code whose
complete deep-hole set is the full F_q-point set of a positive-dimensional named variety, with
group-theoretic cause. + chirality-Z/2 proposition + the p=11 uniqueness theorem (C126, as the
result not a defect). Klein/dual-variety demoted to discussion + one open question.

**Citations locked (C129) — draftable now:**
- **Dye gate cleared** (above) — footnote the residual, keep ILL open.
- **ZWK** arXiv:1901.05445 **Thms I.4–I.7** (I.5 = tangent lines to the NRC; I.6 = quadratic-extension
  family; I.7 = completeness, count q(q+1)²/2) — cite as the true precursor of any dual-variety talk.
- **DMP k=4** = arXiv:**1909.00207** Thm 3.1 + Tables 1–2, Def 7.1(M2), Thms 7.2/7.3 (codim-4 GDRS
  quasi-perfect R=3; distance-3 cosets = points off every real chord) — the k=4 "uncovered locus"
  citation; companions 2104.12254/2103.11248/2112.14803.
- **O'Keefe–Storme 1996** (Zbl 0848.51007) — cite-for-completeness; SVM 1995 supersedes for the plane.
- **PG(2,11) arc classification** — **Hirschfeld–Sadeh, Mitt. Math. Sem. Giessen 164 (1984) 245–257**
  + Sadeh (Sussex) thesis + Hirschfeld PGOFF 2nd ed. Ch.14 — cite before writing "first".

**Pending corroboration:** the dual-variety-examination and minimal-hypothesis (Thread A) agents were
still running when this landed — their independent reads may soften or harden the above.

## ✅ LOOP-BACK to parent program (Thread B, computed vs Lean coords) — EXACT, not analogical

The icosahedral deep-hole lane is the **extremal instance of the parent program's conic-involution
Schreier machinery** (`notes/2026-07-12-conic-involution-schreier-graphs.md`):

- **"Deep holes = whole conic" ⟺ D(S) = ∅** — the parent's saturation set (conic points on arc
  secants) is empty. Verified: all 15 products σ_xσ_y are **elliptic/nonsplit** (tr²−4det a nonsquare).
  So healthiness = **15 quadratic-residue conditions on the §6.3 trace-classifier invariant**, and via
  tr(A_xA_y)=−B(x,y) it's a statement about the polarity form restricted to the arc.
- **The Schreier graph of the six σ_x on the 12 conic points IS the icosahedron graph** (30 edges =
  6 matchings of 5, 5-regular, neighborhoods C₅, Whitney triangulation of S² ⇒ icosahedron uniquely).
  The 6 missing "diameters" = the axis chords. A clean `decide`-grade **edge-level** witness for F1
  (previously only a face-lattice match) — new and headline-adjacent. (√5 *is* in this graph's
  spectrum — vindicates the Hoffman–Singleton kill.)
- **The six σ_x generate full PGL₂(11)** (order 1320); all have nonsquare det ⇒ outside PSL₂(11) —
  the "missing reflections" made external. Clebsch hexagon = extremal §6-A₅ instance: empty saturation
  + full-PGL₂ generation + icosahedral residual.
- **Correction:** governed by the fixed-point/saturation *calculus*, **NOT the spectrum** (bounded
  data at fixed q; "spectral gap" is a category error here). σ_x do NOT act on the 6 arc pts / 10
  Petersen pairs (σ_x ∉ A₅) — arc-side Schreier graphs need A₅-internal generators.
- **NEW counting bound (upgrades p=11 uniqueness to a ~2-line proof of the forward direction):**
  complete-outside needs 15(q−1) ≥ q²−6 ⟹ **q ≤ 14**; with A₅-rationality (q≡±1 mod 10) the only
  candidate is **q=11** (150 secant-slots vs 115 off-conic pts, realized with zero slack by the
  spectrum 90·1+15·2+10·3). Predicts the p≥19 degeneration *before* any group theory. Belongs in the
  "why 11" section alongside p+1=12 and 11∤60.
- **Markoff/BGS-expansion: MIRAGE, kill hardened.** Expansion is *robust* (almost all p); ours is
  *anti-robust* (exactly one prime) — bounded 12-orbit vs growing ~p²-orbit. Opposite signatures.
  Residue: both reduce to "trace split/nonsplit" (Fricke *language*, not structure) — claim nothing.
- **⚠ Bookkeeping:** handoff says witness (1,10,0) tangents {0,9}; parent note's ([t²:t:1],∞)
  labeling gives {5,∞}. Same invariant content, different P¹ labels — reconcile before Lean-ifying
  across both docs.

## ✅ RIGIDITY THEOREM (Thread A/B, exhaustive) — the real content; rebuts "corollary-grade"

Exhaustive classification of **all 1548 frame-normalized 6-arcs in PG(2,11)** up to PGL(3,11)
(deep-hole locus U = points off arc and off all 15 secants; conic-containment by exact nullspace):

- **Every 6-arc has U≠∅** (covering radius 3 universal; smallest complete arc is 7) → "non-GRS radius
  3" distinguishes nothing; all content is *where* the deep holes sit.
- **|U| histogram {12:6, 16:30, 18:150, 19:300, 20:630, 21:360, 22:72}.** Minimum |U|=12 hit by
  exactly 6 arcs, all PGL-equivalent to the Clebsch witness (mult 6 = 360/60 ⇒ |Aut|=60=A₅). **Gap
  12→16.**
- **U ⊆ a conic (degenerate allowed) for the Clebsch class ONLY**, and there U = the *full* 12-point
  conic. Zero other arcs (incl. all 252 on-conic arcs — which give |U|=18–22 junk) qualify.

**RIGIDITY THEOREM (exhaustive at q=11, `decide`-grade Lean-able):** for a 6-arc A in PG(2,11), TFAE
— (i) deep-hole locus ⊆ some conic; (ii) = all F₁₁-points of a nondegenerate conic; (iii) |U(A)|≤15
(=12); (iv) A is the Clebsch hexagon, i.e. Stab(A)⊇A₅. **So condition (b) alone — deep holes ⊆ a
conic — FORCES A₅**; the three-part "healthy" characterization collapses to one, and **A₅ is
RECOVERED from the coding condition, not assumed.**

**Thread B — RIGID not stable, as a GAP theorem:** all 252 one-point perturbations keep radius 3
(deep holes never vanish) but shatter the conic instantly — |U Δ conic| ∈ {18,19,20,22,24}, min 18;
≤7 of 12 conic points survive; zero perturbations land U on any conic. So the correct quantitative
statement is a **deficiency/gap theorem** (distance-to-phenomenon jumps 0→≥18, nothing between),
replacing the impossible stability theorem. The 5-arc's U has 43 pts ⊇ conic; the Clebsch 6th point
uniquely prunes it to exactly the conic.

**Why this matters (rebuts red-team #1):** the DMP dictionary makes "deep holes = no-bisecant points"
routine, but *"uniquely the Clebsch hexagon among all 6-arcs has its no-bisecant points on a conic,
and that condition recovers A₅"* is a genuine **extremal/rigidity theorem** with a proof — not a
one-arc computation. This is the headline content the surviving paper should lead with. (Caveat:
exhaustive at q=11 only, consistent with the q=19 failure — the rigidity is itself a p=11 fact.)

---

## FUSED FRAMING [DEMOTED by red-team above — kept as exploration history]

**Lead thesis (superseded — see red-team):** *The `[6,3,4]₁₁` icosahedral code is the unique prime at which Klein's
solution of the quintic closes over a finite field — the six columns are the mod-11 reduction of his
resolvent sextic (the six diagonals), the deep holes are his degree-12 vertex form (which at p=11
alone fills the whole projective line), and the reflection-free chirality of its deep-hole leaders is
the icosahedron's own handedness — with the deep-holes = dual-variety conjecture carrying the
phenomenon to every rational normal curve.*

Two-spined paper: **Klein spine explains q=11** (deep holes are a conic *because* they're the
reduction of Klein's vertex form; C125 REAL); **dual-variety spine (D2/C123) generalizes it** (the
forward-looking half, predicts k=4). Neither alone survives: coding-only loses to ETGRS literature
(C122); Klein-only is a coincidence without a theorem. The chirality even/odd result (C124) is the
most self-contained headline *result*, subordinate to the Klein *framing*.

### The mod-p Platonic family — C126 RESULT: q=11 is SINGULAR, the "family" is a foil

C126 built the axis-pole arc for every Family-A case (vertex-count=p+1) and tested it. **Two
properties we hoped were family-wide are UNIQUE to the icosahedron/p=11:**

| Solid | Grp | p | arc | complete-outside-conic? | chirality |
|---|---|---|---|---|---|
| Tetrahedron | A₄ | 3 | — | construction **doesn't instantiate** (order-3 stab parabolic at p=3) | N/A |
| Octahedron | S₄ | 5 | 3 | **no** (arc too small) | vacuous |
| Cube | S₄ | 7 | 4 | **no** (conic uncovered but 12 extra pts too) | **not chiral** (single orbit, G odd-inclusive) |
| **Icosahedron** | **A₅** | **11** | **6** | **YES, exact** | **chiral — clean S vs Sᶜ Z/2** |
| Dodecahedron | A₅ | 19 | 10 | **no** (over-covers, 0 uncovered) | all-even but 5 orbits, not clean 2-way |

- **"Deep holes = whole conic" is special to p=11** — every other Family-A reduction degenerates
  (arc too small, or over-covers). So the earlier "family with deep holes = whole conic" narrative
  is **refuted**; q=11 is the singular clean case. This *strengthens* the uniqueness thesis.
- **Chirality-iff-reflection-free holds as a THEOREM:** `Hom(A₄,ℤ/2)=Hom(A₅,ℤ/2)=0` forces every
  perm rep of A₄/A₅ all-even (unmergeable); S₄'s sign character makes odd images generic (cube's G
  *is* odd-inclusive → not chiral). Confirmed computationally.
- **BUT the clean single-Z/2 (S vs Sᶜ) packaging is specific to arc size 6** (a 3-subset of a
  6-set has a natural same-size complement). Dodecahedron (arc 10, A₅) is still unmergeable — in
  fact *no* permutation merges its two size-24 orbits — but splits 5 ways, a messier phenomenon.
  So "clean icosahedral chirality Z/2" = icosahedron/p=11 only.
- **Syzygy H³+T²=f⁵ mod 11** (1728≡1): cheap kernel-checkable identity anchoring "real reduction."
- Family B (√5-primes A₅⊂PSL₂(p)) and the N1 one-scheme/Frobenius framing survive as the
  *arithmetic* backdrop; but the *clean coding phenomenon* (complete-outside + Z/2) does not spread
  across it — it is the exceptional fiber at 11.

### Number-theory spine (outward dig)

- **N1 [REAL — unifying statement]. One ℤ[1/30]-scheme, reductions = the family.** Klein's
  icosahedral configuration (group + forms f,H,T + arc + conic) is a scheme **𝒳 over ℤ[1/30]** (bad
  primes exactly 2,3,5). Our F₁₁ object = 𝒳 mod 11. **Family B = the split primes of ℚ(√5)**
  (p≡±1 mod 5): Frobenius at p splits ⇔ A₅ is F_p-rational ⇔ 12-orbit F_p-rational. The whole
  √5-family is "reduce one ℤ[1/30]-scheme, watch Frobenius in ℚ(√5)." Family A (p=5,7,11,19,29) =
  the sub-locus where the orbit *fills* the line.
- **N2 [REAL, needs-literature — the striking bridge]. The icosahedral syzygy IS the modular
  discriminant relation.** H³+T²=1728f⁵ is the invariant-theoretic avatar of
  **E₄³−E₆²=1728Δ** (same 1728; f↔Δ, H↔E₄, T↔E₆; j=H³/1728f⁵). Mod 11 both collapse (1728≡1): our
  certified **H³+T²=f⁵** is the mod-11 reduction of the modular discriminant syzygy → the deep-hole
  conic (=f) is a **mod-11 avatar of Δ**. Calibrate novelty (the certified mod-11 coding incarnation
  likely is new).
- **N3 [REAL, computed — corrects earlier speculation]. Chirality is UNIVERSAL, not arithmetic.**
  N_{PGL₂(p)}(A₅)=60 at every √5-prime tested (11,19,29,31): the icosahedral reflection is *never*
  F_p-realized (needs F_{p²} / a correlation). Chirality is a group-fact of A₅, uniform across the
  family — NOT a per-prime splitting phenomenon (kills the "arithmetic handedness" reach). The
  uniformity is itself clean; the S₄ octa/cube members should *merge* (the C126 separator).
- **Mirage:** class-number / Ramanujan-τ-mod-11 (11 not a τ-congruence prime); McKay 2·A₅↔E₈ (we use
  A₅⊂PGL₂, not binary 2·A₅); inverse Galois / X(11) rational pts (Klein already realizes A₅ over ℚ;
  degree-11 PSL₂(11) action is a different object). Note kinship, claim nothing.

### Second-order functor: "reduce a famous invariant-theoretic object at its best prime → certified finite code"

Canonical exactly when a distinguished orbit has size = |Pⁿ(F_p)| (P¹: p+1) — one best prime per
object, the way 11 is singled out here. Candidate lanes (surprising × real × own-lane):
icosahedron/p=11 (template); **octa/cube S₄ p=5,7 + tetra A₄ p=3** (C126 control — S₄ non-chiral
isolates chirality to A₄/A₅); Hesse config (9 inflections, order 216) over F_p⊇ζ₃ → certified
[n,k]₃ code (good small 2nd instance); Klein quartic / PSL₂(7) / Hurwitz curves (own lane); 27 lines
W(E₆) / 28 bitangents W(E₇) — the theta-characteristic parity would be the higher analog of our
chirality Z/2 (speculative). Leech/Golay: mirage for this functor (already codes).

### Phone-call-worthy for a number theorist

1. "One ℤ[1/30]-scheme; Frobenius in ℚ(√5) tells you the code (deep holes and all) at each prime" (N1).
2. "The deep-hole conic is a mod-11 avatar of the modular discriminant Δ; the code's syzygy is
   E₄³−E₆²=1728Δ reduced" (N2, pending novelty).
3. "p=11 is the unique prime where an exceptional simple group's natural form fills the projective
   line — completely certifiable."
4. Question our exact data settles that they can't cheaply verify: for which exceptional-orbit/prime
   pairs does the orbit fill Pⁿ AND the arc stay complete-outside (deep holes = whole variety)?

### Third-order reaches (Clebsch/E₆/modular tower) — from the classical names

- **R-A [REAL structure; SPECULATIVE it moves coding; needs-lit]. Clebsch cubic → 27 lines / 10
  Eckardt points / E₆.** The char-0 avatar is the **Clebsch diagonal cubic surface** (the S₅-symmetric
  cubic carrying the 27 lines W(E₆)⊃S₅, the Sylvester pentahedron, and **10 Eckardt points**). Dye's
  **10 Brianchon points** are the plane-conic shadow of those 10 Eckardt points. Chain:
  *deep-hole leaders (Petersen) = 10 Brianchon = 10 Eckardt of the Clebsch cubic = a W(E₆)/S₅
  config* — drags **E₆ / 27 lines into the deep-hole side** for the first time. Explore: does the
  code's weight/coset structure see the 27 lines? (Rank #1 to chase.)
- **R-B [REAL, in-repo]. Chirality Z/2 = the S₅-non-descent obstruction.** The Clebsch surface
  carries full S₅ (reflections included); the conic/line only sees A₅ — the odd elements act on the
  surface but do **not** descend to PGL₂(11) (the N=60 fact). So the chirality bit is precisely *the
  obstruction to lifting the surface's S₅ down to the conic* — a clean previously-unstated meaning,
  and why the phenomenon is icosahedron-only (only A₄/A₅ lack a sign character).
- **R-C [REAL, in-repo]. 5 self-polar triangles = A₅-on-5 / Sylvester pentahedron.** The code has
  both a **hexad** (6 columns) and a **pentad** (5 self-polar triangles) structure. Check: do the 5
  triangles index a code decomposition (cosets / weight classes)?
- **R-D [REAL, side-note]. Dickson invariant → modular invariant theory** (Dickson algebra,
  Steenrod). Flag, don't build.
- **Modular-tower conjecture [SPECULATIVE, highest-reach — extends D2].** If deep-hole conic = mod-11
  Δ (weight/degree 12 = vertex form), the dual-variety conjecture becomes: *the deep-hole variety of
  the degree-(k−1) RNC is a mod-p avatar of the **discriminant of the associated binary form***.
  k=3 → Δ; **k=4 (binary cubic) → the binary-cubic discriminant = the tangent-developable quartic**.
  The tower k=2,3,4… shadows the graded ring of forms, with E₄³−E₆²=1728Δ its k=3 shadow. Reframes
  covering radius as a modular-discriminant phenomenon. Testable seed via the twisted-cubic module.

### Higher-dim "next 11" candidates (C126 killed dim-1 siblings → go up a dimension)

1. **27 lines / GQ(2,4) over F₄ / E₆ [best].** 27 lines ↔ 27 points of GQ(2,4), W(E₆)-symmetric,
   natively over **F₄** — where the **hexacode** already lives (our precedent). "27 fills a GQ at F₄"
   = the plane/space analog of "12 fills P¹ at F₁₁"; loops back to R-A. Own lane.
2. **Valentiner A₆ ⊂ PGL₃ over P² [real group, harder].** Ternary icosahedral sibling; needs the
   prime where a Valentiner orbit fills P²(F_p)=p²+p+1. Hom(A₆,ℤ/2)=0 → chiral analog.
3. **Hesse config / order-216 group over P² [real, small].** 9 inflections, F_p⊇ζ₃; doesn't fill a
   standard space cleanly (weaker "next 11"), but cheap 2nd data point for the reduction functor.

### Unfound faces (face-hunt) — ranked surprising × real

- **F1 [REAL, in-repo — top find]. The object is the CELL OF THE 11-CELL.** The **hemi-icosahedron**
  (icosahedron/antipodal) has exactly 6 vertices, 15 edges, 10 triangular faces, symmetry A₅ in the
  exotic 6-point action — *literally* our structure: 6 arc points = its vertices, 15 duads = edges,
  10 triple-pairs (Petersen/Brianchon) = faces. We have the antipodal map in-repo. **Eleven
  hemi-icosahedra glue into the 11-cell** (Grünbaum–Coxeter abstract 4-polytope), symmetry group
  **PSL₂(11)** = our ambient — so the "11" of the 11-cell is the "11" of F₁₁; the 57-cell (PSL₂(19))
  is the p=19 sibling. A genuine structural identity that reorganizes all the small numbers.
  Check: match (hexad, duads, Petersen) to the hemi-icosahedron face lattice.
- **F2 [REAL, needs-lit]. Our forms compute the j-function.** Klein's **j = H³/(1728 f⁵)** means the
  code's three invariants (f = arc/vertex form, H, T) are a mod-11 incarnation of the j-line
  uniformization — the deep-hole conic (=f) is not just a weight-12 form, it's **the denominator of
  j**. Sharpens N2; the k-tower becomes "shadows of the j-line covariant tower."
- **F3 [REAL substrate, code-link MIRAGE, one open check]. Shared 12-point Mathieu geometry.**
  **S(5,6,12) is standardly built on P¹(F₁₁) = our conic**; PSL₂(11)⊂M₁₂ acts 3-transitively on the
  12 points. Same point set + common subgroup — but NOT a Golay/Mathieu *code* link (ternary Golay
  is [11,6,5]₃, ours [6,3,4]₁₁). Open cheap check: are the two icosahedral hexads (arc-poles / axes)
  among the 132 Mathieu hexads or transverse to them? (Expect transverse.)
- **F4 [REAL, done — sharp negative]. No quantum/self-dual face.** Computed: not Euclidean
  self-dual, and no weighted/monomial diagonal makes it self-dual (nullspace dim 0) — consistent
  with non-GRS/no-quadratic-vanishing. Unlike the hexacode, the F₁₁ analogue is exactly where the
  self-duality/stabilizer-code structure **fails** (odd char, non-GRS). Publish the contrast; kill
  the quantum hope.
- **F5 [speculative]. Bring curve** (genus 4, S₅) — same quintic/S₅ ecosystem as the Clebsch cubic;
  no distinct code handle shown. Note, don't build.
- **F6 [speculative]. Icosian/600-cell/E₈** — via *binary* 2·A₅ on ℂ², not our A₅⊂PGL₂(11); no map
  to the icosian lattice. Only live thread: chirality Z/2 = center of 2·A₅→A₅ (spin cover), but
  unrealized in the code. Stays speculative.

**"11" is one thing seen three ways (the true home):** p+1=12 (icosahedron fills P¹) · the 11-cell
built from 11 hemi-icosahedra · PSL₂(11)⊂M₁₂ as the 12-point stabilizer complement. NOT the biplane
/ M₁₁-on-11.

**Mirages killed with reason (do NOT claim):** Hoffman–Singleton (√5 not in its spectrum 7,2,−3;
Petersen-containment generic); Paley/Peisert/biplane on 11 (wrong 11-point action); **Δ mod 11 as
Galois rep** (ρ_{Δ,11} has big image SL₂(F₁₁) — 11 non-exceptional Serre prime — a *different*
"mod 11 of Δ" than our invariant-theory reduction; do not conflate); Markoff-mod-11 / LPS Ramanujan
(generic PSL₂(11), no icosahedral tie); Clebsch graph SRG(16,5,0,2) (name-share only; our code is
three-weight).

### Family tree (siblings/cousins) — computed; p=11 PROVEN-unique, family runs through k not p

Sibling search across √5-primes × all small A₅ plane-orbits (arc? complete-outside? deep-hole set?):

| p | 6-orbit (axis-poles) | 10-orbit | 15-orbit |
|---|---|---|---|
| **11** | **arc, complete-outside, deep = FULL conic ✓ HEALTHY** | complete-outside, deep = ∅ | not an arc |
| 19 | arc, **not** complete-outside (over-covers) | complete-outside, deep = ∅ | not an arc |
| 29 | arc, not complete-outside | not complete-outside | not an arc |

- **Only (p=11, 6-orbit) is healthy** — every other (p,orbit) either isn't a complete-outside arc or
  has empty deep holes (radius 2). Kills the "√5-family of codes" hope but converts it into a clean
  **uniqueness theorem**. Varying the orbit does NOT rescue higher primes.
- **Characterization of "healthy" (publishable, explains the singularity):** all three of
  **(a)** orbit is an arc; **(b)** pole-arc is complete-outside (deep holes ⊆ conic, needs arc size =
  ρ_𝒞(p)); **(c)** deep holes = the WHOLE conic (vertex orbit fills the line, p+1=12). All three
  coincide only at icosahedron/p=11. Failures diagnostic: octa/cube fail (a)/(b) + non-chiral (S₄
  sign); dodeca/p=19 fails (b); tetra parabolic.
- **Polytope siblings real, code-siblings degenerate.** 57-cell (PSL₂(19), hemi-dodecahedron) is the
  true {3,5,3} abstract-polytope sibling of the 11-cell — but the code/deep-hole structure dies where
  the p=19 arc fails complete-outside. F1 (11-cell) stands as *structure*, not a code family.
- **Cousins by group (faithfulness to arc + deep-var + chirality + modular), ranked:** W(E₆)/27-lines
  /GQ(2,4) over F₄ [best, own lane] > A₆/Valentiner⊂PGL₃ (Hom(A₆,ℤ/2)=0→chiral) > PSL₂(7)/Klein
  quartic (curve not plane-arc) > M₁₂-S(5,6,12)/Hessian (share substrate only).
- **Cousins by modular object [open]:** if f = j-denominator, ours is the **level-1/icosahedral** case;
  natural cousins = other **genus-0 Hauptmodul / McKay–Thompson (Γ₀(N)+) moonshine levels**. Richest
  conjectural family framing; entirely open, no in-repo handle — a question for a modular-forms person.
- **THE relative that turns "singular" into "family" is not a sibling — it is the k-TOWER (dual
  variety).** Prime-siblings are proven dead, so the family must come from varying **k**: if deep
  holes of a non-GRS [n,4] MDS code = tangent-developable quartic, q=11/k=3 is rung 1 of a real tower.
  Highest-value relative, partially testable in-repo now (C123). The paper's path from singular→family
  runs through k, not p.

### ML/stats micro-implications (certified unit-tests, not a lane)

Value = exact *certified* micro-examples for someone else's methods paper; none stands alone, none
needs the multi-q program.
- **real** — deep holes = certified closed-form *hard distribution* (worst-case decoding inputs on a
  named variety); the uniform 20-way tie = certified **Bayes-optimal error floor** (no decoder beats
  it).
- **real** — chirality Z/2 = a **certified non-identifiable latent**: invariant under all 60
  symmetries ⇒ no equivariant learner recovers the handedness bit from the task — minimal
  symmetry-protected-unlearnable example (sharpens "invariant but not blind"). Also a proven
  *insufficient-statistic* pair.
- **real** — non-GRS/no-quadratic-vanishing = certified **kernel-inadequacy witness** (no degree-≤2
  Veronese kernel separates arc from conic).
- **real** — anti-robustness at p=11 = certified example of task structure as a **sharp isolated
  point**, not a robust basin (proof-backed extrapolation-trap for ML-for-math).
- **speculative** — A₅ learnable but chirality not (symmetry-discovery test case); Petersen leader
  graph as a fixed adversarial confusion graph; A₅-augmentation ceiling.
- **mirage** — self-dual/contrastive pairing (refuted); "recover group from orbit samples" (needs
  multi-q).

### Further mining (broad brainstorm, across sub-fields) — real/spec/mirage

**A. Feeds the PARENT program — CLOSED NEGATIVE (C130).** *Both levers = shared-machinery-but-no-new-
content; the spin-off does NOT pay rent to the odd-plane program.* Lever 1 (counting bound) is an
*upper* bound on q forcing a sporadic extremal — wrong quantifier direction for C84's `≥c·q²` lower
bound, and it's dim-1 (Θ(q)) coverage, on the known-insufficient side of the parent's own dim-2 wall;
its only landing (sealing lane) reproduces the classical √(2q) saturating-set bound (arXiv:1505.01426),
nothing new. Lever 2 (D(S)=∅ ⟺ all-elliptic) is a two-line corollary of the parent's Thm 2.1 + §6.3
classifier already covered by Cor 2.2; escape children are generic (nonempty varied D(S)), so it adds
no escape-kernel lemma. Clebsch hexagon = one PGL-orbit at one prime (dim 0 uniform-in-q) → cannot be
a density test point. Only use: a one-line boundary-evaluator sanity corner (6 centres, D(S)=∅,
|live|=12, H_S=full PGL₂(11)). **Do not route C84 through the icosahedral results.**

**B. Standalone small spin-offs (cheap, un-run):**
- [real] **the 10-arc companion** (SVM's other A₅-arc at q=11; radius 2, empty deep holes) — free sibling result.
- [real] **dual [6,3] code** deep-hole geometry vs primal — un-examined, cheap.
- [real] **Mathieu-hexad check (F3)** — are our 2 hexads among the 132 hexads of S(5,6,12) or transverse? genuine design-theory yes/no.
- [real] **Schreier=icosahedron graph** as a standalone algebraic-graph-theory note.
- [minor] publish the exhaustive **|U| histogram {12,16,18,19,20,21,22}** for PG(2,11) 6-arcs as a table.

**C. "Reduce-at-best-prime" functor as a program** [speculative, multi-paper]: census of exceptional
config × best prime → certified code. Seeds: **27-lines/GQ(2,4)/F₄** (best, loops to hexacode/W(E₆)),
Hesse/F_p⊇ζ₃, Valentiner A₆⊂PGL₃. Only route to a *family* (primes + dual-variety dead).

**D. Expository / aesthetic** [real, low-risk high-appeal]: a "one object seen ten ways" gem
(Monthly/Intelligencer/Notices — largely written in this handoff); an interactive visual artifact
(icosahedron drawn on the conic by σ_x, arc-as-poles, Petersen leaders, chirality flip); a teaching example.

**E. Formalization** [real]: machine-certified gallery piece (rigidity + Schreier=icosa + syzygy, all
`decide`-grade) — ITP short / strict-trust showcase.

**F. Methodological meta** [real]: this investigation (generative→adversarial red-team→exhaustive→
gate→loop-back) as a reusable AI-assisted math-triage case study.

**G. Applied [mostly thin]:** specific A₅-symmetric non-GRS (3,6) secret-sharing w/ certified fairness
[speculative]; rigidity-enables-recovery instance for OBS_1 resilience-vs-reconstructability
[speculative]; LRC/storage [mirage — length 6 too small]; icosahedral-chirality physics
(quasicrystals/capsids) [speculative→mirage, no load-bearing bridge].

**Worth pursuing:** A (parent feed, strategic) · C (functor census, the family route) · D (gem+artifact,
low-risk). Rest = free footnotes or thin.

### Ranked open checks (surprising × real × deliverable)

1. **C126 [in-repo, HIGH]** — Family A at p=5,7,19: build octa/cube/dodeca axis-pole arcs, test
   complete-outside + chirality present/absent. Isolates chirality to A₄/A₅. Highest surprise/effort.
2. **C123 [in-repo partial, HIGH]** — D2 dual-variety k=4 twisted cubic = tangent-developable
   quartic vs `ProjectiveTwistedCubicTransversalSpectrum.lean`. The theory-bearing thread.
3. **C127 [literature] — DONE** (see "Novelty audit round 2" below): arc = Clebsch hexagon (SVM
   1995 + Dye 1991); Klein reduction partially known (hedge with Elkies §3.3, Dickson invariant);
   coding bridge novel; "Adler icosahedron/PSL₂(11)" paper does not exist. Remaining: read Dye 1991.
   ~~novelty of the Klein-reduction claim itself (Adler "The~~
   icosahedron and PSL₂(11)," Kondō, X(11), Martin–Singerman, Elkies) + settle O'Keefe–Storme on the
   arc. Calibrates whether the reduction is new or only its coding/deep-hole reading.
4. **C128 [in-repo, cheap]** — kernel-check H³+T²=f⁵ mod 11.

## Open frontiers (ranked surprising × plausible)

| ID | Claim | Status |
|----|-------|--------|
| R1 | Aut(code) = A₅ as the **exotic S₆-hexad** action; permutation aut group is **2-transitive** on the 6 coords (generic MDS: trivial) | **C121 CONFIRMED** — order 60, cycle-type census (1+15+20+24) = A₅ exotic action; pair-orbit size 30 |
| R2 | A₅ **symmetry-reduced decoder**: weight enum forced by 2-transitivity; deep-hole leaders reduce to orbit reps | **C121 REVISED** — the 20 wt-3 leaders split into **TWO complementary orbits of size 10** (S and Sᶜ always differ), NOT one. Decoder stores **2 reps not 20** (still a real 10× reduction); "single orbit" was wrong |
| R3 | **Conjecture:** deep holes of a non-GRS `[n,k]` MDS code = F_q-points of the **dual variety** of the RNC. k=3: dual of conic = conic ✓. **k=4: tangent developable = quartic surface** | C123 conjecture; partly testable vs `ProjectiveTwistedCubicTransversalSpectrum.lean` |
| R4 | **Construction principle:** poles of a group orbit → code with prescribed deep-hole variety; family exists where `ρ_𝒞(q) < t₂(2,q)` meets an A₅/A₄ orbit (q=8,9 six-arcs are ordinarily complete → radius 2, empty deep holes) | conjecture |
| R5 | Non-RS 3-of-6 secret sharing: positionally fair (A₅-transitive, uniform 20-tie) but **not pseudorandom** (deep holes enumerable as 12 conic points; roles leak via 2-transitivity) | reasoning |

## Directions to pursue — re-ranked after C121/C122 (novel × plausible × deliverable)

- **D1 (NEW, top deliverable). Chirality invariant from the two-orbit split.** The 20 wt-3 leaders
  split into two A₅-orbits of 10, complementation-reversing (S, Sᶜ never share an orbit), and A₅ has
  **no odd permutation** — so the split is the icosahedron's **chirality**; the absent reflection is
  what would merge them. Deliverable: define the Z/2 sign on leaders, prove it A₅-invariant and
  complementation-reversing — all `decide`-grade, in-repo, safely novel. This is R2 inverted into
  its correct form.
- **D2 (survivor R3, top thesis). Dual-variety conjecture.** deep holes = F_q-points of the dual
  variety of the RNC (k=3 conic ✓; k=4 = tangent-developable quartic). C122-certified novel; test
  uncovered-locus = tangent-developable vs `RepairCodes/ProjectiveTwistedCubicTransversalSpectrum.lean`
  (= open task **C123**).
- **D3 (NEW, blocking/defensive). Settle O'Keefe–Storme catalogue** before writing — determines
  whether we claim "new arc" or "new coding-theoretic reading of a known arc." Our contribution
  survives either way (nobody connects the arc to a deep-hole/covering-radius statement).
- **D4 (survivor R1, downgraded to framing).** Position as the **F₁₁ off-conic analogue of the
  hexacode `[6,3,4]₄`**; precedent + sanity anchor, not a headline. The delta over the hexacode is
  exactly D1+D2.

**Lead thesis (one sentence):** *the deep holes of a projective non-GRS MDS code are the F_q-points
of the dual variety of its underlying rational normal curve, exhibited for the `[6,3,4]₁₁` code
whose columns are the poles of the six icosahedral axes — an A₅-symmetric, chiral off-conic analogue
of the hexacode.* (If O'Keefe–Storme already has the arc: drop "new arc," keep the dual-variety
identification + chirality invariant.)

**What the two-orbit fact unlocks (that a single orbit would not):** a canonical Z/2 chirality
function on every deep-hole coset; a combinatorial witness that the stabilizer is A₅ not S₅; the
S₆-outer-automorphism made functional (S↦Sᶜ swaps the two D₁₀ classes); a decoder that stores 2 reps
(10× reduction) whose representative choice *carries the chirality bit*; and a likely k=4 bridge
("leaders ≅ symmetry orbits on the dual variety") to conjecture alongside D2.

## Cross-field lenses (beyond coding theory) — ranked surprising × real

- **L1 [C125: REAL — genuine reduction mod 11 of Klein's actual polynomials/group, NOT an
  analogy].** Klein's icosahedral group Γ ⊂ PSL(2,ℚ(ζ₅)) reduces mod a prime 𝔭|11 (11 splits
  completely) injectively to a PGL(2,11)-conjugate of our arc-stabilizer A₅ (explicit conjugator
  z↦1/(z+5)). The vertex form **f = z₁z₂(z₁¹⁰+11z₁⁵z₂⁵−z₂¹⁰)** reduces to the 12 F₁₁ conic points;
  the six diagonals (roots of **Klein's sextic resolvent**, *Lectures* I.4 §15) reduce to the six
  `witnessMissingEdge` chords; the six arc points are their poles. Syzygy H³+T²=1728f⁵ reduces to
  H³+T²=f⁵ (1728≡1 mod 11).
  - **11 is uniquely optimal:** 11∤60 (faithful, forms squarefree — bad primes are 2,3,5); 11≡1
    mod 5 (group + all 12 vertices F₁₁-rational); and **p=11 is the only prime with p+1=12**, so
    Klein's coefficient 11 dies mod 11 and the icosahedron's 12 vertices exhaust P¹(F₁₁).
  - **Caveats to bake into wording:** (A) claim "reduction of Klein's six *diagonals*" (the objects
    the resolvent's roots enumerate), not "F₁₁-roots of the resolvent polynomial" (its coeffs depend
    on the icosahedral parameter); (B) f mod 11 gains full PGL(2,11)-invariance, so always pair the
    vertex-form clause with the group/diagonal clause — f alone no longer remembers A₅. All finite
    clauses `decide`-grade Lean-able. Sources: Klein (archive.org); Nash arXiv:1308.0955; Kostant
    Notices 1995.
- **L2 [C124: Petersen CONFIRMED, chirality Z/2 CONFIRMED, five-tetrahedra REFUTED].** The 10
  complementary triple-pairs carry the **Petersen graph** — A₅-on-10, stab S₃, adjacency = "share
  exactly 2 of 3 columns" (10v/15e/3-reg/girth-5). The 10+10 leader split is a genuine chirality
  Z/2: all 60 arc-stabilizer perms are even (orbitA-preserving), all 60 orbit-swappers are **odd**
  (form S₅ via the exotic S₆ outer-auto embedding) — no code automorphism merges them ("the
  rotation group has no reflection"). **But** the A₅-on-10 action is **primitive** (no invariant
  5+5 block system) → the "each orbit = 5 chiral tetrahedra pairs" reading is **computationally
  refuted**; only the 10=2×5 / Petersen / chirality level holds, not an exact five-tetrahedra
  bijection. Claim Petersen + chirality, drop the tetrahedra pairing.
- **L3 [REAL group, SPECULATIVE vehicle]. Buckyball / PSL₂(11) / Arnold trinity.** Our A₅ ⊂
  PGL₂(11) is the same subgroup at the center of Martin–Singerman "Biplanes → Klein Quartic →
  Buckyball" and Arnold's trinity. One paragraph, not a new-bridge claim.
- **L4 [REAL, in-repo]. S₆ outer automorphism = conic polarity over F₁₁.** The two D₁₀ classes /
  arc↔axes hexad duality / pole-chord polarity ARE the S₆ outer automorphism made geometric; the 6
  arc points + 6 axes are the two synthematic hexads, complementation = the outer automorphism
  acting.
- **L5–L7 [SPECULATIVE].** Chirality Z/2 as a spinor sign via binary icosahedral 2·A₅ → **McKay
  E₈** (L5); theta-characteristic parity / 28 bitangents / 27 lines shared-S₆ Z/2 (L6);
  Valentiner/Wiman A₅⊂PGL₃ ternary-icosahedral sibling (L7). Appealing, no concrete map — do not
  claim.
- **Mirage (re-judged at this aperture):** (11,5,2) biplane / M₁₁ use PSL₂(11) in its **degree-11**
  action; ours is **degree-12** icosahedral A₅ — same group, different action, cousins in the trinity
  ambient only. Never equate. Markov-A₅ / lattices: omit.

**Who cares & what:** invariant theorists / classical alg-geom (exact certified F₁₁ avatar of
Klein's sextic resolvent + five-tetrahedra chirality); finite geometers (S₆ outer auto as PG(2,11)
polarity; A₅-primitive complete-outside arc — the O'Keefe–Storme lineage/risk); moonshine-trinity
crowd (fresh certified inhabitant of the buckyball ambient, candidate E₈-spinor chirality);
combinatorialists / design theorists (Petersen + synthemes from deep-hole leaders); physicists of
icosahedral symmetry (an intrinsic, unmergeable chirality — clean finite model of icosahedral
handedness).

**Sit-up sentence for a non-coding-theorist:** *the deep-hole combinatorics of this little F₁₁ code
is an exact, machine-certified copy of Klein's icosahedral quintic-resolvent, and its two-way
ambiguity split is literally the chirality of the compound of five tetrahedra* (L1/L2/L4 checkable
in-repo now).

## Closed / mirage (do NOT claim)

- **M₁₁ / PSL(2,11)-on-11-points / (11,5,2) biplane** — MIRAGE. Those live on 11 points, PSL(2,11)
  order 660; our object is on the **12 conic points**, A₅ order 60. Lead with the icosahedron, drop
  Mathieu.
- **Sphere-packing / lattices** — no credible bridge; natural home is designs / OA(1331,6,11,3).

## Novelty audit (C122 — `notes/2026-07-13-c122-deep-hole-novelty-audit.md`)

- **DROP "first non-GRS deep-hole determination"** — contradicted by 2025–26 ETGRS/TRS literature
  (Wu–Ding–Chen, IEEE TIT 71(5) 2025; TRS ISIT 2024 arXiv:2403.11436; Ma–Kai–Zhu FFA 2026).
- **The (1,60,1150,120) distribution, `120=(q−1)c₀`, and the uniform 20-way tie are KNOWN
  machinery**, not novelties: Davydov–Marcugini–Pambianco (arXiv:2101.12722, 2021) derive coset
  distributions from the secant spectrum and force `B₃=C(n,3)` for every such code. Keep them as
  worked facts, not headline claims.
- **2-transitive A₅ on 6 coords has a precedent:** the **hexacode `[6,3,4]₄`** (hyperoval in
  PG(2,4)) has PAut=A₅ 2-transitive. So frame R1 as *the F₁₁ / off-conic analogue of the hexacode
  phenomenon*, not as unprecedented. Our exact q=11 code has no prior appearance found.
- **Genuinely NEW (safe to headline):** *the code's complete deep-hole set = the F_q-points of a
  named variety (a conic)*, with a **group-theoretic cause** (poles of the six icosahedral axes) —
  first such identification; plus the **dual-variety conjecture** (R3) as its generalization (no
  prior art states deep holes = F_q-points of the dual variety / tangent developable).
## Novelty audit round 2 (C127 — `notes/2026-07-13-c127-klein-reduction-novelty.md`)

- **The arc is KNOWN — it is the CLEBSCH HEXAGON. Settled decisively.** Storme–Van Maldeghem,
  *"Primitive arcs in PG(2,q)"* (JCTA 1995, open PDF at Ghent): Prop. 11 gives our 6-arc with
  explicit coords for all q≡±1 mod 10, Prop. 12 proves projective uniqueness, computer check shows
  incomplete at q=11. Studied as the Clebsch hexagon in **Dye, "Hexagons, conics, A₅ and PSL₂(K)"
  (JLMS 1991)** — already has the A₅-invariant conic (5 self-polar triangles) + the 10 Brianchon
  points (= the geometry under our 100-coset / triple-pair split). Char-0 six-axes-off-every-conic
  = the classical Clebsch diagonal cubic (Hitchin 2007). **Do NOT claim a new arc — name it the
  Clebsch hexagon and cite SVM 1995 + Dye 1991.** (O'Keefe–Storme no longer blocking; SVM+Dye
  answer it. Still paywalled; get for citation only.)
- **Klein form-level reduction — PARTIALLY KNOWN, two mandatory hedges.** A₅⊂PSL(2,11) is classical
  (Galois 1832, Klein, Dickson, Kostant, Martin–Singerman). The *form-level* facts (vertex form
  collapsing mod 11 to the all-points Dickson form; diagonals→chords; H³+T²=f⁵ via 1728≡1; the
  p+1=12 uniqueness) were **not found anywhere** — BUT cite **Elkies, *Klein Quartic in Number
  Theory* §3.3** as the model (same genre for PSL(2,7) at p=2,3,7), and note **f mod 11 = the
  classical Dickson–Euler invariant** (Dickson 1911).
- **FIX BAD REFERENCE:** the paper *"Adler, The icosahedron and PSL₂(11)"* **does not exist** —
  Adler's PSL(2,11) work is X(11)/cubic-threefold/M₁₁. Remove it wherever cited (see L1).
- **Coding/deep-hole bridge — NOVEL** (C122 stands after fresh 2025–26 sweep): nothing links any A₅
  object to covering radius / deep holes.
- **mod-p Platonic family — skeleton PARTIALLY KNOWN, assembly NOVEL:** Platonic-solids-over-F_p =
  Grothendieck *Esquisse* §4 (+ Caleb Ji arXiv:2304.03345); Dickson gives the √5-prime criterion;
  Klein did the p=5 member. The "vertex count=p+1 fills line ⇒ axis-pole arc, deep holes=conic"
  assembly appears nowhere (and per C126 it degenerates except at p=11 anyway).
- **Remaining must-read before final wording:** **Dye 1991** (paywalled) — could already state "the
  0-bisecant points are the conic" geometrically; the covering-radius/deep-hole *reading* stays
  ours, but read it before locking the wording.

**Safest new headline (C127):** *the complete deep-hole set of the `[6,3,4]₁₁` code on the **Clebsch
hexagon** is the full point set of the A₅-invariant conic — first identification of an MDS code's
deep holes with the rational points of a named variety — arising as the mod-11 shadow of Klein's
icosahedron at the unique prime with p+1=12* (+ dual-variety conjecture as the forward half).

## Paper framing

Lead with: *complete deep-hole set of an MDS code identified with the rational points of a named
variety (a conic), caused by a 2-transitive A₅ acting as poles of the icosahedral axes* — plus the
dual-variety conjecture. (NOT "first non-GRS deep-hole determination.") One-liners by audience:
- coding theorist — *an MDS code with a 2-transitive aut group whose covering radius is realized on
  a conic*;
- finite-geometer — *the six poles of the icosahedral axes form a complete-outside-the-conic arc,
  stabilizer the exotic-hexad A₅*;
- group theorist — *the S₆ outer automorphism realized as conic polarity over F₁₁*.

Guardrail: respect the papers-planning salami-slicing check before splitting from the arcs
manuscript.
