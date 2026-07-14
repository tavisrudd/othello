# Paper outline — the Clebsch hexagon code (deep holes on a conic)

Draft outline for the single-spine finite-geometry/designs paper. Scope + citations per the
[handoff](handoffs/2026-07-13-icosahedral-mds-deep-holes.md) (post-red-team converged verdict).
Status: SHALLOW PASS (skeleton) → deepen core sections.

**Working title:** *The Clebsch hexagon code: an MDS code whose deep holes are a conic.*
Alt: *A rigidity theorem for deep holes of `[6,3,4]₁₁` MDS codes.*

**Venue:** Designs, Codes and Cryptography / Finite Fields and Their Applications / J. Geometry.
NOT IEEE-TIT.

## Abstract (draft — leads with the rigidity uniqueness, the red-team survivor)
Among all 6-arcs of the projective plane PG(2,11), exactly one — up to projective equivalence — has
the property that the deep holes of its associated MDS code lie on a conic. That arc is the **Clebsch
hexagon**, the mod-11 reduction of the six axes of Klein's icosahedron (the six poles of the
icosahedral A₅ ⊂ PGL₂(11) action on a conic), and the conic-condition alone recovers its automorphism
group A₅. The arc lies on no conic, so its `[6,3,4]₁₁` code is projectively non-GRS of covering
radius 3; for this code the complete set of deep holes is not merely contained in a conic but is the
entire set of F₁₁-points of that conic — the first instance, to our knowledge, of an MDS code whose
deep holes are exactly the rational points of a positive-dimensional **named** variety. We give the
covering-radius/coset data, a canonical automorphism-invariant chirality Z/2 on the deep-hole leaders,
and a counting argument showing q=11 is the only prime at which the phenomenon occurs.

## Section skeleton (one-liner each)
1. **Introduction** — deep holes / covering radius of MDS codes; the DMP arc↔coset dictionary; what's
   new (the rigidity theorem + named-variety deep holes). Cite Cheng–Murray 2007 (deep holes of RS
   codes — verify + add to citation lock), ZWK I.4–I.7, DMP 2021 (arXiv:2101.12722 Thm 6.3).
2. **The Clebsch hexagon** — definition (poles of A₅ axes), it's a known arc (SVM 1995 Prop 11/12,
   Dye 1991), off every conic ⇒ non-GRS, incomplete at q=11.
3. **The code and its deep holes** — [6,3,4]₁₁, radius 3; deep holes = the A₅-invariant conic
   (statement + proof via the DMP dictionary, arXiv:2101.12722 Thm 6.3: extension points = the 12
   conic points).
4. **The rigidity theorem** — exhaustive over all PG(2,11) 6-arcs: deep-holes-⊆-conic ⟺ Clebsch ⟺
   |U|≤15 ⟺ Stab⊇A₅; the |U| histogram; the gap theorem (0→≥18).
5. **The chirality invariant** — the 20-leader / Petersen structure; two complementary A₅-orbits;
   Hom(A₅,ℤ/2)=0 ⇒ unmergeable; canonical Z/2 (proposition).
6. **Why q=11** — the counting bound 15(q−1)≥q²−6 ⟹ q≤14; A₅-rationality (q≡±1 mod 10) ⇒ q=11;
   the q=19 non-example (≥105 deep holes ≠ conic).
7. **The Klein reduction** (discussion *subsection*, not a one-liner — per re-hardened handoff): the
   mod-11 reduction of Klein's icosahedral forms (vertex form → conic, six diagonals → chords, syzygy
   H³+T²=f⁵); explicitly non-causal, hedged Elkies §3.3 genre + Dickson invariant.
8. **Further remarks** — the object as one cell of the 11-cell (edge-level Schreier=icosahedron
   witness); an open question (existential-curve k≥4). Everything Lean-certified.

## Deepened core (draft statements)

**§3 — main computation.** Code = row space of the 3×6 generator whose columns are the 6 arc points
(`Examples.lean:46`), conic XZ=Y². Covering radius 3 (arc incomplete, SVM 1995 Prop 13). By the DMP
dictionary (arXiv:2101.12722 Thm 6.3 — pin the exact hypotheses; confirm they hold for non-GRS at
q=11) a projective point is a deep-hole direction iff it lies on no bisecant of the arc; the
uncovered locus U = the 12 F₁₁-points of the A₅-invariant conic. Affine deep-hole count 120 = 12×10.
Coset-leader-weight distribution (1,60,1150,120); each deep-hole coset has exactly C(6,3)=20 leaders
(uniform tie = certified Bayes-error floor). *Prop:* deep holes = conic. *Cor (novel):* first MDS
code with deep holes = the full point set of a positive-dimensional variety.

**§3b — certified structural facts (stated, not sold — vet-2 cheap upgrades).** All in-data / MDS-
forced / `decide`-grade; state each with the right attribution so none reads as over-claimed:
- **Weight enumerator (1,0,0,0,150,420,760)** — MDS-forced (verified vs formula); state as "as
  expected for `[6,3,4]`," a sanity row, not a novelty.
- **|Aut| = 60 = the exotic-S₆-hexad A₅, 2-transitive on the 6 coordinates** (C121, cycle-type
  census) — the symmetry anchor; frame as *the F₁₁/off-conic analogue of the hexacode `[6,3,4]₄`*
  (cite the hexacode precedent, don't claim unprecedented).
- **Orthogonal-array / design view: OA(1331, 6, 11, 3)** — MDS ⟺ OA of strength 3, automatic from
  the parameters; one line, delivers the "designs" framing the venue/title promise.
- **5 self-polar triangles / Sylvester pentad** — the hexad+pentad duality; **attribute to Dye 1991**
  (his geometry), state as a cited structural remark. Pose "do the 5 triangles index a code
  decomposition?" (R-C) as an open question — do NOT answer it.

**§4 — RIGIDITY THEOREM (the headline).** *Census framing (drop-in sentence, item-5 round-3):* The
projective-equivalence classes of k-arcs in PG(2,11) were classified by Sadeh [Sadeh, D.Phil. thesis,
Univ. Sussex 1984; Hirschfeld–Sadeh, Mitt. Math. Sem. Giessen 164 (1984) 245–257; Hirschfeld, PGOFF
2nd ed. §14]. Over the 6-arc classes of that census we compute, for each, the deep-hole locus U — the
points off the arc and off all fifteen secants, equivalently the points extending it to a 7-arc — and
read U as the covering-radius-3 data of the associated `[6,3,4]₁₁` code. *The classification and its
extension counts are Sadeh's;* our contribution is the geometry and coding meaning of U: that U ⊆ a
conic singles out the Clebsch hexagon and forces A₅, that the configuration is rigid, and that the
complete deep-hole set is the full F₁₁-conic (the first such identification for an MDS code).

*Theorem.* For a 6-arc A ⊂ PG(2,11), TFAE: (i) the deep-hole
locus U(A) lies on some conic (degenerate allowed); (ii) U(A) = all F₁₁-points of a nondegenerate
conic; (iii) |U(A)| ≤ 15 (in fact 12); (iv) A is PGL-equivalent to the Clebsch hexagon; (v)
Stab_PGL(A) ⊇ A₅. *Proof:* exhaustive over the 1548 PGL-normalized 6-arcs (any 4 arc points = a
frame ⇒ normalize e₁,e₂,e₃,(1,1,1), sweep the last pair); conic-containment by exact nullspace over
the quadratic-form space. |U| histogram {12:6, 16:30, 18:150, 19:300, 20:630, 21:360, 22:72}; the six
|U|=12 arcs are one PGL-orbit (mult 6 = 360/60 ⇒ |Aut|=60=A₅). Corollary: **A₅ is recovered
from the coding condition, not assumed.**

*Gap/Deficiency Theorem (name it a theorem, not a corollary — vet #1, the strongest robustness
upgrade).* The configuration is rigid, not stable: every non-Clebsch 6-arc has |U| ≥ 16 with U on no
conic, and every one of the 252 one-point perturbations of the Clebsch hexagon has |U Δ conic| ≥ 18
(≤ 7 of the 12 conic points survive; Δ-set {18,19,20,22,24}). The distance-to-phenomenon jumps
0 → ≥18 with nothing between — this quantified moat pre-empts the "so what, one arc" objection.
Formalizable `decide`-grade in Lean.
*Priority (item-5 round-3):* claim "first" only for the conic-rigidity/covering reading (TFAE +
gap theorem) — those are outside arc-classification scope. The 6-arc census and the |U| histogram
are extension-count data plausibly in Sadeh's thesis, so present the histogram as "we tabulate," not
"first tabulated," until the thesis is pulled (Sussex EThOS/ILL).

**§5 — chirality (proposition).** The 6 columns give C(6,3)=20 triples = 10 complementary pairs
{S,Sᶜ}; A₅ acts on the 10 pairs as the Petersen graph (adjacency = "share 2 of 3"), on the 20 triples
as two complementary orbits of 10. Since Hom(A₅,ℤ/2)=0 every code automorphism is even ⇒ the two orbits
never merge (the 60 orbit-swappers are exactly the odd permutations, S₅ via the exotic S₆ outer auto).
*Prop:* the deep-hole leaders carry a canonical, automorphism-invariant Z/2 (a certified
non-identifiable latent). NB drop the refuted five-tetrahedra reading (A₅-on-10 primitive).

## Remaining work before submission (outline vet — research + proof)

**Research / lit (ranked, blocking → optional):**
1. **Sadeh Sussex thesis (~1984)** [BLOCKING the |U| "first"] — gates whether the |U| histogram +
   "min |U|=12 ⇔ Clebsch" may say "first" vs "we tabulate." Close via Sussex EThOS / British Library
   ILL (or email Hirschfeld directly). Title also covers 27-lines/cubic-surfaces over F₁₁ → may touch
   R-A/E₆.
2. **Hirschfeld–Sadeh, Mitt. Math. Sem. Giessen 164 (1984) 245–257** — the public census; same gate,
   faster than the thesis via ILL/GDZ; the citable version.
3. **Independent recompute of the |U| histogram** — re-derive {12:6,16:30,18:150,19:300,20:630,
   21:360,22:72} from a second code path (Σ = 1548 ✓ checks) — it is the paper's quantitative core.
   Independent Rust/GAP enumeration, `decide`-exportable, in-repo.
4. **DMP arXiv:2101.12722 Thm 6.3 pin** — confirm it states exactly "deep-hole coset ⟺ point off
   every bisecant" for the projective [n,3] case, and that its hypotheses hold for non-GRS at q=11.
   ~30 min re-read; it is the load-bearing dictionary for all of §3.
5. **q=19 non-example count** — reconcile 111 (= 381 − 15×18) vs the "≥105" in the handoff; print the
   exact deep-hole count. Direct enumeration at q=19, trivial.
6. **O'Keefe–Storme 1996 residual** — verify SVM+Dye fully supersede it for the plane (skim Zbl
   0848.51007; no full ILL needed).
7. **Dye 1991** [footnote-only, non-blocking] — ILL already queued; close only to drop the footnote
   hedge (C129 verdict NO already stands).

**Proof work {obligation / status / Lean / difficulty}:**
- **TFAE (§4)** — exhaustive certificate over the 1548 classes; currently a prose claim. Lean: yes,
  via `native_decide`/reflected computation (raw `decide` on 1548×nullspace is heavy). Moderate.
  **⚠ GAP: (i)⇒(ii) degenerate-conic exclusion** — (i) allows a degenerate conic (line-pair); must
  prove no 6-arc with |U| ∈ {12..15} has U on a line-pair, else (i) ⇏ (ii). Verify in the enumeration
  and state as a proved link — this is the one place the TFAE could have a hole.
- **Gap/deficiency theorem (§4)** — certificate over the 252 perturbations; prose claim. Lean: yes,
  `decide`-grade, small. Easy. (Δ-set {18,19,20,22,24}; print "≥18", no spurious 21.)
- **p=11 counting bound (§6)** — the one genuine inequality argument: 15(q−1) ≥ q²−6 ⟹ q ≤ 14, then
  q ≡ ±1 mod 10 + A₅-rationality ⟹ q = 11. Inequality `decide`-able over the finite candidate range.
  **⚠ GAP: the counting premise is asserted** — write the lemma "complete-outside ⟹ 15 bisecants each
  cover ≤ (q−1) off-conic points ⟹ 15(q−1) ≥ #off-conic." Also state why q = 9 (≡ −1 mod 10, ≤ 14)
  is excluded (3² bad prime / A₅ not F₉-rational). Easy–moderate, but the only real-math step — write
  carefully.
- **Chirality Z/2 (§5)** — orbit computation certificate + Hom(A₅,ℤ/2)=0 (standard-cited or `decide`).
  Lean: yes. Easy. No gap.
- **Schreier=icosahedron (§7)** — explicit graph-iso on 12 vertices; certificate. Lean: yes,
  `decide`-grade. Easy. The "Whitney triangulation ⇒ icosahedron unique" step is cited topology —
  keep as a remark, prove only the explicit graph iso.

## Draft prose (ready to drop in — from the outline vet)

- **Rigidity theorem, one line:** *For a 6-arc A in PG(2,11), the following are equivalent: the
  deep-hole locus of A lies on a conic; it is the full set of F₁₁-points of a nondegenerate conic; it
  has at most fifteen points; A is the Clebsch hexagon; and the projective stabilizer of A contains
  A₅.*
- **§4 gap lead:** *The phenomenon is rigid rather than stable: no 6-arc lies near the Clebsch
  configuration in this respect. Every other arc has at least sixteen deep holes lying on no conic,
  and every single-point perturbation of the Clebsch hexagon destroys the incidence completely — at
  most seven of the twelve conic points survive. The distance from "deep holes on a conic" to the
  nearest other arc jumps from zero to at least eighteen, with nothing in between.*
- **§6 "why 11" lead:** *Three coincidences meet at 11 and nowhere else: it is the only prime with
  p+1 = 12, so the twelve vertices of the icosahedron exhaust the projective line; it is prime to 60,
  so the icosahedral group survives reduction faithfully; and it is small enough that the fifteen
  secants of a 6-arc have just enough room to cover every point off the conic — the counting
  inequality 15(q−1) ≥ q²−6 forces q ≤ 14, and rationality of A₅ closes the door to everything but
  11.*
- **§5 chirality lead:** *The twenty weight-three coset leaders split into two orbits of ten under the
  automorphism group, and no automorphism ever exchanges them. The obstruction is intrinsic: A₅ has
  no nontrivial homomorphism to Z/2, so the reflection that would merge the two handednesses is
  exactly the symmetry the code does not possess. The split is a canonical, automorphism-invariant
  bit — the icosahedron's chirality, made into a coding invariant.*
- **§7 Klein lead:** *These objects are not analogues of Klein's icosahedral forms; they are their
  reductions. The vertex form, the six diagonals, and the syzygy H³ + T² = f⁵ (the relation
  E₄³ − E₆² = 1728Δ with 1728 ≡ 1) all descend mod 11 to the arc, its missing chords, and the conic —
  though f alone, having gained the full Dickson invariance of PGL₂(11), no longer remembers the
  icosahedron, so the group must be carried alongside it.*

## Free/cheap upgrades (outline vet 2) — status

**Folded in already** (zero new proof, zero priority risk): gap/deficiency **theorem** naming (§4);
the §3b structural facts (weight enumerator, |Aut|=60 exotic-S₆, OA(1331,6,11,3) design view, Dye
pentad); the |U| histogram as a standalone tabulated deliverable (§4, keep the "we tabulate" hedge).

**Do the small run FIRST, then include as a free companion** (result direction publishable either
way, but don't commit to include before running):
- **Dual `[6,3]` code deep-hole geometry** — primal↔dual companion (`decide`-grade, un-run).
- **Two icosahedral hexads vs the 132 Mathieu hexads of S(5,6,12)** (F3) — transversality yes/no;
  turns the "is this a Golay/Mathieu thing?" referee question into a stated negative.
- **10-arc SVM sibling** (radius 2, empty deep holes) — a free foil: its sibling has NO deep holes,
  sharpening why the 6-arc is special. Confirm radius-2/empty with a small run.

**Once the independent recompute (research item 3) is done:** add the one sentence that the histogram
+ orbit multiplicities were verified by two independent code paths — kills the "single unverified
computer run" objection.

**Tone guard:** the Bayes-floor / insufficient-statistic ML asides are citable but read as padding in
a designs/finite-geometry venue — at most ONE labeled sentence in a remarks paragraph, never near the
abstract.

## What NOT to include (killed / demoted — see handoff)
- Dual-variety conjecture (dead: ill-posed + q=19 counterexample + k=4 impossible + ZWK subsumes).
- Klein two-spine "because" (false by C126); j-function (re-labeling); "family of codes" (singular).
- IEEE-TIT-scale "first non-GRS deep holes" (ETGRS literature owns it).

## Citations locked (C129)
SVM 1995 (arc, incompleteness) · Dye 1991 (Clebsch hexagon geometry; footnote the 0-bisecant
non-preemption) · DMP arXiv:2101.12722 (dictionary) · ZWK arXiv:1901.05445 Thms I.4–I.7 · DMP
arXiv:1909.00207 (k=4, for the open-question remark) · **Hirschfeld–Sadeh 1984 + Sadeh Sussex thesis
1984 + Hirschfeld PGOFF Ch.14** (PG(2,11) arc census — cite before any "first"; thesis is the blocking
ILL for the |U| numbers) · Elkies (Klein-reduction genre) · Dickson 1911 (invariant).
