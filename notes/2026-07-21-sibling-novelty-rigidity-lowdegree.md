# Sibling / general-q novelty audit — Clebsch hexagon rigidity (R1) and low-degree rigidity (R2)

**Date:** 2026-07-21
**Task:** literature novelty search — do the two Clebsch-hexagon rigidity headlines (R1 conic-containment
rigidity recovering A5; R2 unique arc on a curve of degree ≤ 3) already have a proven predecessor for a
sibling in the A3/B3/H3 conic-phase family (q = 5 frame, q = 7, q = 19) or a general-q arc theorem that
already subsumes q = 11?
**Method:** two independent angles per headline — keyword search AND citation/neighborhood of a named
source. All load-bearing sources are cached primary texts, not search summaries.

## Sources (re-findable ids)

| Tag | Source | id / provenance | How found |
|---|---|---|---|
| Dye91 | R.H. Dye, "Hexagons, Conics, A₅ and PSL₂(K)", J. London Math. Soc. (2) **44** (1991) 270–286 | DOI 10.1112/jlms/s2-44.2.270 · https://londmathsoc.onlinelibrary.wiley.com/doi/pdf/10.1112/jlms/s2-44.2.270 · cached OCR+page-images `/tmp/persistent/tavis/lit-search/dye-1991/` | keyword ("hexagon conic A5") AND cited as [5] by SVM95 |
| SVM95 | L. Storme, H. Van Maldeghem, "Primitive arcs in PG(2,q)", J. Combin. Theory Ser. A **72** (1995) | DOI 10.1016/0097-3165(95)90051-9 · cache key same · sha256 770f27f1e22b… | cache list; forward-cites Dye91 |
| Edge56 | W.L. Edge, "Conics and orthogonal projectivities in a finite plane", Canad. J. Math. **8** (1956) 362–382 | DOI 10.4153/CJM-1956-041-6 · cache key same · sha256 07149c0f96… | cache list; = Dye91 ref [6], q=11 primary source |
| DyeA6 | R.H. Dye, "The Plane Sextic Curve Fixed by A₆", Abh. Math. Sem. Univ. Hamburg | DOI 10.1007/BF02942548 · https://link.springer.com/article/10.1007/BF02942548 | announced sequel in Dye91 §1.1; keyword search |
| A6arc12 | "Transitive A₆-invariant k-arcs in PG(2,q)" | DOI 10.1007/s10623-012-9619-0 | forward citation of the SVM95/Dye91 family |
| Cub81 | "Completeness of cubic curves in PG(2,q), q ≤ 81" | arXiv:1510.08375 | keyword ("arc on cubic curve completeness") |

---

## R1 — conic-containment rigidity that recovers A5

**Verdict: substantially PRE-EMPTED at the geometric level for general q (all K, char ≠ 2, with 5 a
square — this subsumes q = 5, 11, 19). The surviving novelty is only the coding-theoretic recoding
("full maximum-distance syndrome locus of the extended GRS/arc code"), not the underlying rigidity.**

Dye91 is a general-field treatment of exactly this family, and it already contains the conic-recovers-A₅
mechanism:

- **Dye91 Theorem 2 (§1.4):** for a Clebsch hexagon H (six points, exactly 10 Brianchon points) there is
  a *unique* orthogonal polarity — hence a unique conic 𝒞 — for which the five triangles of H are
  self-polar. H is called "a Clebsch hexagon *of* a conic 𝒞." This is a naturally-associated point/line
  set pinned to a conic, the same shape as R1's "naturally-associated locus lies on a conic."
- **Dye91 Theorem 5 (§1.4):** the stabilizer of such H in both PGL₂(K) and the conic's orthogonal group
  is A₅ (Σ₅ in characteristic 5). "The stabilizers of the Clebsch hexagons of a conic provide the A₅ …
  Nothing better can be hoped for." That is the conic *recovering* A₅ — R1's headline recovery.
- **Dye91 Theorem 6 (§1.5):** the vertices (resp. Brianchon points) lie on a conic **iff** char = 5
  (resp. 3), when that conic is 𝒞 itself. This is an explicit conic-*containment* criterion on the
  associated point set that distinguishes the special cases — the q = 5 frame is exactly the "vertices
  on a conic" case (there H = 𝒞, the sub-conic of PG(2,5)).
- **q = 11 is a named instance inside Dye91**, not a new case: Dye91 p.271 line 94–96 — "If K is GF(11)
  then Edge [6, p.380] … 10 internal points at which three edges concur; its stabilizer in PΩ₃(11) is
  A₅." So Edge56 is the q = 11 primary source and Dye91 generalizes it to all admissible K.

**Independent second angle (citation neighborhood).** SVM95, which cites Dye91 as [5], independently
proves the *projective uniqueness* of the A₅-fixed 6-arc for **all** q ≡ ±1 (mod 10) (Prop 12), and lists
it (Prop 13(4)) as "the unique 6-/10-arc in PG(2,11) or PG(2,19) fixed by A₅." So a general-q sibling
uniqueness theorem covering q = 11 **and q = 19** already exists in print, together with SVM95 Remark 2
reproducing Dye's conic geometry (five self-polar triangles, unique conic C, Brianchon points on a conic
iff char 3/5).

**Bounded negative / what survives.** SVM95 and Dye91 characterize the arc by its *automorphism group*
(A₅ / 2-transitivity) and derive the associated conic; R1 as literally worded runs the other direction
(a conic-containment hypothesis on a *code's* maximum-distance syndrome locus pins the class and *recovers*
A₅). The object "maximum-distance syndrome locus of the extended GRS / arc code" is a coding-theoretic
construct; no predecessor phrasing this rigidity in code/syndrome terms was found in Dye91, SVM95, Edge56,
or the forward-citation neighborhood. Net: R1's geometry is a known general-q fact (Dye91/SVM95, subsuming
q = 5, 11, 19); only its coding-theoretic packaging and the "syndrome-locus ⇒ conic" direction are
candidate-novel, and the manuscript must credit Dye91 Thm 2/5/6 and SVM95 Prop 12–13 for the underlying
rigidity. (Consistent with the handoff already crediting Edge/Dye for the exceptional conic geometry and
maintaining the `dye-bsw-primary-source-audit` boundary.)

---

## R2 — low-degree rigidity: unique 6-arc on a curve of degree ≤ 3

**Verdict: NO sibling / general-q predecessor found for the "unique on a curve of degree ≤ 3"
characterization. Candidate-novel as stated, with one caveat on the exact locus.**

The naturally-associated curves in the classical/general-q literature for this family are of degree 2 or
degree 6, never a degree-≤3 uniqueness characterization:

- **Degree 2 (conic):** Dye91 Thm 2/6 — the self-polar conic 𝒞; vertices on it only in char 5 (the q = 5
  frame). This is the *only* low-degree-curve statement in Dye91/SVM95, and it is a conic, not a cubic.
- **Degree 6 (sextic):** Dye91 §5 (p.915–919) ties the Clebsch hexagon to the plane model of a genus-4
  **sextic** with double points at the six vertices, carrying A₅ — the origin being Clebsch's diagonal
  **cubic surface** (a surface in P³, not a plane cubic through the arc). The A₆ sequel DyeA6
  (DOI 10.1007/BF02942548) fixes a plane **sextic**. So the invariant plane curve of this configuration
  is degree 6, and the "cubic" in the classical story is the Clebsch cubic *surface*, not a plane cubic
  containing the 6-arc.
- **General arc-on-cubic literature** (Segre–Lombardo-Radice constructions; Cub81 = arXiv:1510.08375 on
  completeness of cubic curves in PG(2,q)) studies arcs *cut from* cubics but states no "this specific
  arc is the unique 6-arc on a degree-≤3 curve" characterization; and Segre's own low-degree theorem is
  the degree-2 result ((q+1)-arc ⇒ conic), which does not reach a cubic-uniqueness ladder.

**Independent second angle (citation neighborhood).** The forward neighborhood of SVM95/Dye91 (A6arc12
and the A₅/A₆ invariant-curve line) continues into higher-degree invariant curves (sextics, the A₆
sextic) and group-theoretic uniqueness, never a minimal-exact-degree cubic ladder for the arc. No node in
that neighborhood states R2.

**Bounded negative / caveat.** Search domain: cache primary texts (Dye91, SVM95, Edge56) plus keyword +
citation-neighborhood web search on "arc unique on curve of least/minimal degree," "arcs on cubic
curves," "Segre low-degree characterization." Stop condition: no source characterizes any arc of this
family as the unique one on a degree-≤3 curve. Caveat that bounds the strength of R2's novelty (not a
predecessor, a soundness note): six general points always lie on many plane cubics, so the load-bearing
content of R2 is *which* canonical point set and *which* uniqueness notion is used; the manuscript must
state that precisely so the claim is not vacuous. Under any reasonable reading the "minimal-exact-degree
ladder with a single quartic companion" formulation has no located predecessor.

---

## Bottom line for the manuscript

- R1: keep the coding/syndrome-locus formulation and the q = 11 specifics as the novel contribution;
  do **not** claim the conic-recovers-A₅ rigidity itself as new — Dye91 (Thm 2/5/6, general K) and SVM95
  (Prop 12–13, all q ≡ ±1 mod 10, explicitly q = 11 and q = 19) own it, with Edge56 the q = 11 primary.
  The q = 5 frame is precisely Dye91's char-5 "vertices-on-a-conic" case (H = the sub-conic 𝒞₅).
- R2: no sibling/general-q predecessor located; safe to present as novel **provided** the exact
  associated locus and uniqueness notion are pinned (avoid the vacuous "6 points lie on a cubic" reading).
  Classical adjacency is degree 2 (Dye conic) and degree 6 (Dye/A₆ sextic; Clebsch cubic *surface*), with
  no degree-≤3 plane-curve uniqueness in between.
</content>
</invoke>
