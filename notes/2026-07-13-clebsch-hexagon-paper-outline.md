# Paper outline — the Clebsch hexagon code (deep holes on a conic)

Draft outline for the single-spine finite-geometry/designs paper. Scope + citations per the
[handoff](handoffs/2026-07-13-icosahedral-mds-deep-holes.md) (post-red-team converged verdict).
Status: SHALLOW PASS (skeleton) → deepen core sections.

**Working title:** *The Clebsch hexagon code: an MDS code whose deep holes are a conic.*
Alt: *A rigidity theorem for deep holes of `[6,3,4]₁₁` MDS codes.*

**Venue:** Designs, Codes and Cryptography / Finite Fields and Their Applications / J. Geometry.
NOT IEEE-TIT.

## Abstract (draft)
The Clebsch hexagon — the six poles of the icosahedral A₅ ⊂ PSL₂(11) axes on a conic in PG(2,11) —
is a 6-arc lying on no conic, hence a projectively non-GRS `[6,3,4]₁₁` MDS code of covering radius 3.
We show its complete deep-hole set is exactly the F₁₁-points of the A₅-invariant conic — the first
MDS code whose deep holes are the full point set of a positive-dimensional variety. This is not
incidental: an exhaustive classification of all 6-arcs in PG(2,11) shows the Clebsch hexagon is the
**unique** arc (up to PGL) whose deep holes lie on a conic, and the condition recovers the group A₅.
We give the covering-radius/coset data, a canonical automorphism-invariant "chirality" Z/2 on the
deep-hole leaders, and a counting argument showing q=11 is the only prime where the phenomenon occurs.

## Section skeleton (one-liner each)
1. **Introduction** — deep holes / covering radius of MDS codes; the DMP arc↔coset dictionary; what's
   new (the rigidity theorem + named-variety deep holes). Cite Cheng–Murray, ZWK I.4–I.7, DMP 2021.
2. **The Clebsch hexagon** — definition (poles of A₅ axes), it's a known arc (SVM 1995 Prop 11/12,
   Dye 1991), off every conic ⇒ non-GRS, incomplete at q=11.
3. **The code and its deep holes** — [6,3,4]₁₁, radius 3; deep holes = the A₅-invariant conic
   (statement + proof via the DMP dictionary: extension points = the 12 conic points).
4. **The rigidity theorem** — exhaustive over all PG(2,11) 6-arcs: deep-holes-⊆-conic ⟺ Clebsch ⟺
   |U|≤15 ⟺ Stab⊇A₅; the |U| histogram; the gap theorem (0→≥18).
5. **The chirality invariant** — the 20-leader / Petersen structure; two complementary A₅-orbits;
   Hom(A₅,ℤ/2)=0 ⇒ unmergeable; canonical Z/2 (proposition).
6. **Why q=11** — the counting bound 15(q−1)≥q²−6 ⟹ q≤14; A₅-rationality (q≡±1 mod 10) ⇒ q=11;
   the q=19 non-example (≥105 deep holes ≠ conic).
7. **Remarks** — mod-11 reduction of Klein's icosahedral forms (Elkies §3.3 genre; Dickson invariant);
   the object as one cell of the 11-cell (edge-level Schreier=icosahedron); an open question
   (existential-curve k≥4). Everything Lean-certified.

## Deepened core (draft statements)

**§3 — main computation.** Code = row space of the 3×6 generator whose columns are the 6 arc points
(`Examples.lean:46`), conic XZ=Y². Covering radius 3 (arc incomplete, SVM 1995 Prop 13). By the DMP
dictionary a projective point is a deep-hole direction iff it lies on no bisecant of the arc; the
uncovered locus U = the 12 F₁₁-points of the A₅-invariant conic. Affine deep-hole count 120 = 12×10.
Coset-leader-weight distribution (1,60,1150,120); each deep-hole coset has exactly C(6,3)=20 leaders
(uniform tie = certified Bayes-error floor). *Prop:* deep holes = conic. *Cor (novel):* first MDS
code with deep holes = the full point set of a positive-dimensional variety.

**§4 — RIGIDITY THEOREM (the headline).** *Theorem.* For a 6-arc A ⊂ PG(2,11), TFAE: (i) the deep-hole
locus U(A) lies on some conic (degenerate allowed); (ii) U(A) = all F₁₁-points of a nondegenerate
conic; (iii) |U(A)| ≤ 15 (in fact 12); (iv) A is PGL-equivalent to the Clebsch hexagon; (v)
Stab_PGL(A) ⊇ A₅. *Proof:* exhaustive over the 1548 PGL-normalized 6-arcs (any 4 arc points = a
frame ⇒ normalize e₁,e₂,e₃,(1,1,1), sweep the last pair); conic-containment by exact nullspace over
the quadratic-form space. |U| histogram {12:6, 16:30, 18:150, 19:300, 20:630, 21:360, 22:72}; the six
|U|=12 arcs are one PGL-orbit (mult 6 = 360/60 ⇒ |Aut|=60=A₅). Corollaries: (a) **A₅ is recovered
from the coding condition, not assumed**; (b) **gap theorem** — every non-Clebsch 6-arc has |U|≥16 and
U on no conic, and the 252 one-point perturbations of Clebsch have |U Δ conic| ≥ 18 (≤7 of 12 conic
points survive) — distance-to-phenomenon jumps 0→≥18. Formalizable `decide`-grade in Lean.

**§5 — chirality (proposition).** The 6 columns give C(6,3)=20 triples = 10 complementary pairs
{S,Sᶜ}; A₅ acts on the 10 pairs as the Petersen graph (adjacency = "share 2 of 3"), on the 20 triples
as two complementary orbits of 10. Since Hom(A₅,ℤ/2)=0 every code automorphism is even ⇒ the two orbits
never merge (the 60 orbit-swappers are exactly the odd permutations, S₅ via the exotic S₆ outer auto).
*Prop:* the deep-hole leaders carry a canonical, automorphism-invariant Z/2 (a certified
non-identifiable latent). NB drop the refuted five-tetrahedra reading (A₅-on-10 primitive).

## What NOT to include (killed / demoted — see handoff)
- Dual-variety conjecture (dead: ill-posed + q=19 counterexample + k=4 impossible + ZWK subsumes).
- Klein two-spine "because" (false by C126); j-function (re-labeling); "family of codes" (singular).
- IEEE-TIT-scale "first non-GRS deep holes" (ETGRS literature owns it).

## Citations locked (C129)
SVM 1995 (arc, incompleteness) · Dye 1991 (Clebsch hexagon geometry; footnote the 0-bisecant
non-preemption) · DMP arXiv:2101.12722 (dictionary) · ZWK arXiv:1901.05445 Thms I.4–I.7 · DMP
arXiv:1909.00207 (k=4, for the open-question remark) · Hirschfeld–Sadeh 1984 + Hirschfeld PGOFF Ch.14
(PG(2,11) arc classification) · Elkies (Klein-reduction genre) · Dickson 1911 (invariant).
