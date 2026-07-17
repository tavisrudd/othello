# Dihedral–Schreier Node-Kayles novelty/priority audit (C261)

Date: 2026-07-17. Lane: `dihedral`.

Manuscript audited: `notes/2026-07-12-dihedral-schreier-node-kayles-submission.md`
("Node Kayles on Fixed-Point-Deleted Schreier Graphs from Conic Involutions: The Dihedral Case").
House style modeled on `notes/2026-07-08-codex-projective-nofil-novelty-audit.md`.

## Verdict (up front)

The paper is safe to submit on priority grounds with **no novelty overclaim to walk back**: it
contains no "first", "novel", "to our knowledge", or "we introduce" sentence, and its two most
sensitive attributions — Brown et al. for the ladder/prism/opposite-end-pendant Grundy values, and
Tranchida for the involution↔point correspondence — are **accurate as written**. Both named
portfolio-review concerns resolve in the manuscript's favor.

Conservative public framing:

> We study the normal-play impartial capacity-two conic-avoidance game whose conic-only residual is a
> fixed-point-deleted Schreier graph of an involution-generated subgroup of `PGL(2,q)`. The reduction
> of late-stage avoidance play to Node Kayles is due to Huggan–Huntemann–Stevens; the
> point↔involution correspondence and the geometry of involution triples are classical and were
> developed for incidence geometries by Tranchida; the ladder, prism, and opposite-end-pendant-ladder
> Node-Kayles values are Brown et al.'s. The contribution is the fixed-point-deleted Schreier residual
> and, in the tame dihedral case, its complete transitive-template and Grundy-value catalogue, which
> appear to be unrecorded.

Use novelty at the level of **the packaged construction + the tame-dihedral catalogue**, never at the
level of the ingredients (Node-Kayles game, ladder/prism Grundy values, the involution correspondence,
Dickson split counts, Dirichlet density).

## The three named questions

### Q1 — Brown et al. ladder coverage: RESOLVED, attribution accurate

Cited source (Ref. 1): S. Brown, S. Daugherty, E. Fiorini, B. Maldonado, D. Manzano-Ruiz,
S. Rainville, R. Waechter, T. W. H. Wong, "Nimber Sequences of Node-Kayles Games," *J. Integer
Sequences* **23** (2020), Article 20.3.5. Open access; full text retrieved and read
(`cs.uwaterloo.ca/journals/JIS/VOL23/Wong/wong24.pdf`, cached key `JIS-20.3.5-Wong-NodeKayles`,
sha256 `a7fad24c376eabed023e0377171d2679054541737caa986e42f768f9f60034ff`).

The manuscript's §1 promises "an evaluation of those templates using Brown et al.'s exact
Node-Kayles values for ladders, prisms, and the required opposite-end-pendant ladder family." All
three are genuinely in Brown et al. and are **not** re-derivations of ours presented as cited:

| Manuscript claim | Brown et al. location | Match |
|---|---|---|
| `G(L_k)=1` (k odd), `0` (k even) — eqn (7.5) | Theorem 2: `G(L_{n×2})=1` if n odd, else `0` | exact |
| `G(C_m□K_2)=0`, m≥3 (prism) — Theorem 5.3 | Corollary 3: `G(Π_n)` constantly `0`, n≥3 | exact |
| opposite-end-pendant `G(_-L^-_{k×2})=0`, k≥1 — used in Theorem 5.2 | Theorem 2: `G(_-L^-_{n×2})=0` for all n∈N (incl. base P₄, extended to n=−1,0) | exact |

The manuscript's own notation `{}_{-}L^-_{(2n-3)×2}` is Brown et al.'s "third variation" `_-L^-_{n×2}`
(pendant at opposite ends on opposite rails; their Figure 9). The §5.2 base-case care ("their k=1
base graph is P₄, value zero … the first two values arising here are included explicitly") is
well-founded: Brown tabulate n=−1,0 and prove n=1 (P₄) directly. No misattribution.

**One clarity flag (not an error):** Brown et al. do **not** compute the Möbius ladder `M_{4n}`
(they cover prisms/circular ladders, not the twisted circular ladder). The value `G(M_{4n})=1`
(Theorem 5.2, and the "Möbius ladder" template listed in the abstract) is the **manuscript's own
derivation**, obtained by showing every `M_{4n}` option is Brown's `_-L^-` of value 0. It is
correctly presented as the paper's Theorem 5.2, not cited to Brown. A referee skimming the abstract's
template list ("…a prism, or a Möbius ladder") next to "Brown et al.'s exact values" could
misread the Möbius value as cited; a half-clause fixes this (see Wording R3). The `G(M_{4n})=1`
value did not surface in any literature search and appears unrecorded as a standalone, though it is
an immediate consequence of Brown's third-variation lemma.

### Q2 — Tranchida delineation: RESOLVED, delineation accurate

Source (Ref. 4): P. Tranchida, "Triples of involutions in `PGL(2,q)` and their incidence
geometries," *Innovations in Incidence Geometry* **22** (2025) = arXiv:2411.10299. Open access;
HTML full text read (arxiv.org/html/2411.10299v1).

What Tranchida covers:
- The correspondence "involution of `PGL(2,q)` ↔ its centre, an off-conic point of the plane"
  (§2.1: map `C: I → π∖O`, injective and surjective by an involution count). Tranchida presents this
  as **established/classical background**, not a new result — consistent with the manuscript calling
  it "classical."
- "Triples of involutions … correspond bijectively to triples of points," and a full classification
  of when the rank-3 coset geometry is a **regular hypertope**: iff the point triple is a *strongly
  non self-polar triangle* (his Theorem A). This is the "geometry of triples of such involutions"
  the manuscript attributes to him.

What Tranchida does **not** contain (verified by direct read): no Schreier graphs, no Cayley graphs,
no combinatorial game, no Node-Kayles, no Grundy/nimber values, no "fixed-point-deleted" residual.

Therefore the manuscript's §1 delineation — *"Our contribution starts after that correspondence:
saturation is detected by fixed points of pair products, so the conic-only residual is a
fixed-point-deleted Schreier graph … Tranchida does not consider this residual graph or its
Node-Kayles value."* — is **exactly correct**.

Must attribute to Tranchida (and/or "classical"): the off-conic-point ↔ involution bijection; the
triple-of-involutions ↔ triple-of-points dictionary; the self-polar-triangle geometry of involution
triples (the manuscript leans on collinearity-of-reflection-centres legality and, in Thm 13.1, a
"self-polar triangle" — these live in Tranchida's geometric territory). Remains ours: the
fixed-point-deleted Schreier residual `R_T(Ω)`, the orbit-template reduction, and every Node-Kayles
/ Grundy value.

### Q3 — General sweep: no colliding prior art found

Searches run (verbatim, all recorded incl. nil results):
- `Brown Daugherty Fiorini Wong "Nimber Sequences of Node-Kayles Games" Journal Integer Sequences ladder prism`
- `Tranchida "Triples of Involutions" PGL(2,q) incidence geometries hypertopes`
- `Node-Kayles game Schreier graph OR Cayley graph group action Grundy value`
- `Schaefer complexity two-person perfect information games Node Kayles PSPACE-complete 1978`
- `impartial vertex deletion game finite geometry conic involution nimber dihedral catalogue`
- `"fixed-point-deleted" Schreier graph impartial game OR "Node-Kayles" Cayley graph dihedral`
- `Node-Kayles Grundy Möbius ladder prism circular ladder nimber sequence classification`

Findings:
- **Schaefer 1978** ("On the complexity of some two-person perfect-information games," *JCSS*
  16:185–225) — origin of Node-Kayles and its PSPACE-completeness. Standard root citation; the
  manuscript's reference list omits it (see Wording R2). No content collision.
- **Kobayashi, arXiv:2003.11775** (already Ref. 5) — structural parameterizations (vertex cover,
  modular-width) of Node-Kayles: complexity/FPT, not Grundy catalogues. No overlap with our values.
- **Huggan–Huntemann–Stevens, arXiv:2103.13501** (already Ref. 3) — Nofil on STS and the late-stage
  Node-Kayles reduction. Correct anchor for the ruleset/reduction. No dihedral-Schreier catalogue.
- **Node-Kayles on Trees, arXiv:2512.24221** (Songsuwan et al., Dec 2025) — Grundy sequences for
  regular trees and path-joined trees. Adjacent concurrent Node-Kayles catalogue work; disjoint
  graph families (no ladders/prisms/Schreier). Worth a one-line "see also," not load-bearing.
- **Ernst–Sieben, "Impartial achievement games for generating generalized dihedral groups,"
  arXiv:1608.00259** — a *different* game (players pick group elements to build a generating set),
  not vertex-deletion on a graph. It is the nearest "dihedral-group game catalogue" in the
  literature and is worth a one-line distinction to preempt a referee conflating the two.
- No source states an outcome/nimber result for Node-Kayles (or any vertex-deletion game) on a
  Schreier or Cayley graph arising from a group action, nor a "fixed-point-deleted" residual
  construction. The term and construction appear unrecorded.

## Claim-by-claim verdicts

Legend: NOVEL-AS-PACKAGED = apparently unrecorded as assembled; KIN-NA =
KNOWN-INGREDIENTS-NEW-ASSEMBLY; KNOWN = standard result/technique.

| # | Result | Verdict | Basis |
|---|---|---|---|
| 1 | Lemma 2.1 / Thm 2.2: pair-product fixed point = dead conic point; residual = Node-Kayles | KIN-NA | Nofil→Node-Kayles reduction is HHS; point↔involution classical/Tranchida; the fixed-point-of-pair-product ⇒ Schreier-residual packaging is the paper's. |
| 2 | Thm 3.1: orbit-template reduction (`G = ⊕ (m_K mod 2) t_K`) | KNOWN technique / KIN-NA | Sprague-Grundy disjoint-union additivity applied to the orbit decomposition. Manuscript itself frames it as bookkeeping; the new content is the geometric object it is applied to. |
| 3 | Thm 4.1: V₄→K₄ boundary, residual `((q+1−2s)/4)·K₄`, value `((q+1−2s)/4) mod 2` | KIN-NA | Dickson split/nonsplit parity counts classical; `G(K₄)=1` trivial; geometric identification + assembly is the paper's. Plane instances `PG(2,2)=STS(7)`/`AG(2,3)=STS(9)` overlap HHS data but are not this theorem. |
| 4 | §5,7,8 dihedral catalogue: `M_{4n}`, prisms, ladders `L_{n−1}/L_n/L_{n−2}`, closed split/nonsplit-torus formulas | NOVEL-AS-PACKAGED | Template Grundy values are Brown et al. (correctly cited); `G(M_{4n})=1` derived here; the tame-dihedral template↔`q`-congruence dictionary appears unrecorded. |
| 5 | Appendix A: exact Node-Kayles values for all regular `S₄`/`A₅` involution-triple Cayley graphs | NOVEL-AS-PACKAGED (computational) | Direct memoized Sprague-Grundy computation, cross-checked by two solvers; no prior tabulation found. State as "apparently unrecorded," not "first." |
| 6 | Prop 11.1: Burnside-group reformulation `Φ_T: A(G)→(ℕ₀,⊕)`, factors through `A(G)⊗F₂` | KIN-NA (framing) | Grothendieck-group extension of a disjoint-union-additive invariant. Manuscript already says it is "a convenient reformulation, not an additional source of computational information." |
| 7 | Thm 12.1 / Cor 9.1: `q`-periodicity and one-half P-position Dirichlet density | KIN-NA | Dickson orbit counts + PNT for arithmetic progressions / Dirichlet density (Davenport). Standard analytic technique on this family. |
| 8 | Thm 13.1: converse realization over infinitely many prime fields | KIN-NA | Dirichlet's theorem on primes in AP realizes each template. Standard. |

Overall: the manuscript **as a package** (fixed-point-deleted Schreier residual + complete
tame-dihedral catalogue with closed field formulas, density, and converse) is
**NOVEL-AS-PACKAGED / apparently unrecorded**, resting on correctly-cited prior-art ingredients.

No verdict is UNRESOLVED: every load-bearing source (Brown, Tranchida, HHS, Kobayashi, Schaefer) was
reached in full text or is a standard classical result; nothing is hardened on an abstract alone.

## Recommended wording changes (report only — do NOT edit the manuscript)

**R1 — cite HHS on the reduction sentence.** §1 currently:
> "The general reduction of late-stage Nofil positions to Node Kayles is known."

Replace with:
> "The general reduction of late-stage Nofil positions to Node Kayles is known (Huggan, Huntemann,
> and Stevens [Ref. 3])."

**R2 — add Schaefer as the Node-Kayles root citation.** §1 defines the game with no citation:
> "Node Kayles is the impartial game in which a move at a graph vertex deletes its closed
> neighbourhood."

Replace with:
> "Node Kayles is the impartial game in which a move at a graph vertex deletes its closed
> neighbourhood; it was introduced by Schaefer, who proved it PSPACE-complete [Schaefer 1978]."

Add to References: T. J. Schaefer, "On the complexity of some two-person perfect-information games,"
*J. Comput. System Sci.* **16** (1978), 185–225.

**R3 — make the Möbius-ladder value visibly ours, not Brown's.** §1 lists the ingredient plan:
> "an evaluation of those templates using Brown et al.'s exact Node-Kayles values for ladders,
> prisms, and the required opposite-end-pendant ladder family."

Append a clause so no referee reads the abstract's "Möbius ladder" template as a Brown citation:
> "…and the required opposite-end-pendant ladder family; the Möbius-ladder value is then obtained
> here (Theorem 5.2), as Brown et al. tabulate prisms but not Möbius ladders."

**R4 — optional conservative novelty sentence for the Discussion (§14).** The paper currently stakes
no explicit priority claim. If one is wanted, use the "apparently unrecorded" register, never
"first":
> "To our knowledge, the fixed-point-deleted Schreier residual and its complete tame-dihedral
> Node-Kayles catalogue have not previously been recorded; the underlying template Grundy values are
> Brown et al.'s and the involution correspondence is classical."

**R5 — one-line distinction from the dihedral achievement game (optional, §1 or §14).** Preempt
conflation with Ernst–Sieben:
> "This is unrelated to impartial *achievement* games for generating dihedral groups (Ernst–Sieben),
> where moves select group elements to build a generating set; here moves delete closed
> neighbourhoods of a fixed graph."

## Things to avoid

- Do not write "first" / "first computation" / "we introduce Node Kayles" anywhere. Keep any priority
  claim at "apparently unrecorded" / "to our knowledge."
- Do not present `G(M_{4n})=1`, the S₄/A₅ rows, or the closed torus formulas as cited from Brown —
  Brown supplies only the ladder, prism, and opposite-end-pendant values.
- Do not claim the point↔involution correspondence as new, nor as Tranchida's own — it is classical
  and Tranchida restates it as background.
- Do not claim the plane instances `PG(2,2)`/`AG(2,3)` as novel outcomes; they are HHS data points
  (both nim-value 0). The dihedral catalogue, not those instances, is the contribution.
- Do not oversell Theorem 3.1 or Proposition 11.1 as new theory; both are standard additivity
  repackaged for a new object (the manuscript already hedges Prop 11.1 correctly).

## Sources reached in full text

- Brown et al., JIS 23 (2020) 20.3.5 — cached, read (Theorem 2, Corollary 3 verified line by line).
- Tranchida, arXiv:2411.10299 / IIG 22 (2025) — HTML read (§2.1 correspondence, Theorem A hypertope
  classification; confirmed absence of games/Schreier/Grundy).
- HHS arXiv:2103.13501, Kobayashi arXiv:2003.11775, Schaefer 1978, Ernst–Sieben arXiv:1608.00259,
  Songsuwan et al. arXiv:2512.24221 — reached at abstract/search level; used only for scope
  delineation, no verdict hardened on them.
