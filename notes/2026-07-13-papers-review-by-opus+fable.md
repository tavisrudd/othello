# Papers portfolio review — Opus 4.8 + Fable (2026-07-13)

A two-model expert review of the `papers/` publication track: what stands out or draws a
referee, grades across six axes, missed free upgrades, and cross-paper connections. Opus 4.8
produced the first pass; a Fable second opinion sharpened, corrected, and added to it. Claims
that were load-bearing or disputed were spot-checked against source (see *Verification* at the
end). This is a review snapshot, not a live map — it does not change `papers-index.md` /
`papers-planning.md`.

## Scope — the six units

The publication track resolves to five papers (+1 conditional). `baer-equivariant-extension`
and `completion-core-rigidity` are staging views folded into unit 5.

1. **arcs** — Arcs complete outside a conic.
2. **coding** — Complete repair hypergraphs under concatenation.
3. **nofil** — Games flagship (cap/Nofil outcome classes, mirror⇒P).
4. **dihedral** — Node-Kayles on fixed-point-deleted Schreier graphs from conic involutions.
5. **equivariant-robust-completion** — Baer ⊕ completion merge.
6. **continuation** — Semilinear rigidity from cap continuation graphs (N1).

Two overarching reception facts hold across all of them: the research is human-directed but
agent-generated, so **Lean is the trust anchor** and the residual referee concern is *statement
adequacy* (does the Lean theorem say what the paper claims); and every deliverable shares the
public-repo/DOI blocker.

## Q1 — What stands out / what a referee pounces on

### arcs
**Stands out.** Most finished unit: manuscript + PDF + SHA-stamped verifier + full strict-trust
Lean (kernel `decide`, no `native_decide`), including the certified `ρ_𝒞(16)=9` classification.
Genuinely new objects: the relative parameter ρ_𝒞, the exact prescribed-hole defect identity,
the uncovered-locus-as-quadratic-obstruction.

**Referee pounces.**
- Separate the new ~10% from the classical ~90% (moment equations, √(2q)=Lunelli–Sce,
  arc↔MDS). The paper self-flags most of this.
- Is the defect identity a theorem or a rearrangement of the two standard secant-index moment
  equations over an exceptional set? The paper's own closing paragraph concedes the bound lives
  in "overlap already measured by the classical second index equation" — so the question is
  presentation, not soundness.
- **Exhaustiveness/closure** of the q=16 classification: is closure of the class lists certified,
  or delegated to the C++ enumerator? Classic soft spot in computer-assisted classifications.
- ρ_𝒞 ≤ t₂(2,q) imports a notoriously open problem, bounding the theory's reach past tiny q.
- Nearest crowded shelf is specific, not generic saturating sets:
  **Davydov–Giulietti–Marcugini–Pambianco** (saturating sets on/from conics) and
  **Korchmáros–Sonnino** (complete arcs sharing points with a conic). Name them.
- Free defensive headline: **ρ_𝒞(11)=6 < t₂(2,11)=7** is a *strict* separation — it proves ρ_𝒞
  is not the smallest-complete-arc number in disguise (while ρ_𝒞(16)=9 coincides). Leading with
  it defuses the "is it just t₂?" pounce.

### coding
**Stands out.** Assembled manuscript, full Lean modulo one quarantined visible axiom (Stichtenoth
self-dual TVZ, GF(6561)) surfaced in the axiom manifest. Exact coordinatewise (ν,τ) rows for the
twisted-cubic+axis `[2q+1,4,q−1]_q` family and an exact blockwise concatenation-transfer theorem.

**Referee pounces.**
- **The ν/τ invariant is prior art, and the paper says so.** τ (repair tolerance / minimum
  hitting-set) is Pamies-Juarez–Hollmann–Oggier 2013, Def. 3; Wang–Zhang 2014 generalized it.
  The paper's emphasis is explicitly *not* the definition but the exact coordinatewise
  computation + simultaneous transfer. So the real pounce is not "does τ measure anything new"
  (conceded) but: *is exact computation on one bespoke k=4 family + a gate theorem enough for a
  paper?*
- Presentational risk: leading with ν/τ *appears* to rename a known invariant. Cite PHO up front
  and frame around "exact repair tolerance" — appearing to rename is worse than the narrow
  novelty itself.
- Sharpness is "gates not uniformly weakenable," not necessity; parameters are modest (rate 2/19).

### nofil
**Stands out.** Two clean infinite-family determinations: sum-free ℤₙ is P iff n ≡ 0,1,5 (mod 6),
and the cap game on AG(n,q) is P for all n, all q (settles the cap-set achievement game in every
dimension, incl. d=5, with no computation). Core P-theorems Lean-clean.

**Referee pounces.**
- The method is an elementary pairing/mirror, so the *boundary dichotomy* must carry the paper —
  but the boundary is a *method*-negative ("no fpf involution exists"), not a game theorem, and
  the **elliptic Q⁻ negative has a genuine gap** (needs a Scharlau/Witt-transfer lemma).
- Pairing-soundness parity subtleties in a last-player-wins achievement game.
- Prior-art delineation from HHS (STS(7)=PG(2,2), STS(9)=AG(2,3) already computed) and
  Clark–Mancini–Van Hook (verify before any "first" language).
- The written draft still calls the projective case open though the Lean proofs exist.
- A CGT referee will want the **misère** convention addressed and will police
  **achievement/avoidance/building-game terminology** against HHS.
- Venue tension: the Lean covers the *easy* half (P-theorems); the *delicate* half (boundary
  negatives, elliptic) is paper-only. A CGT venue won't credit the Lean; a formal-methods venue
  won't accept the gap.

### dihedral
**Stands out.** A complete, self-contained tame catalogue: orbit-template reduction, template
classification (empty/K₄/ladder/prism/Möbius ladder), split/nonsplit-torus formulas,
q-periodicity, ½ P-density, converse realization.

**Referee pounces.**
- "Complete" is **tame-only** (p ∤ |G|); the wild case and full PGL₂ escape are deferred (§14).
- Headline template nimbers are **solver-only**, not Lean-certified.
- Leans on cited Node-Kayles values (incl. an "opposite-end-pendant ladder family" — cited or
  new?); delineation from Tranchida (off-conic↔involution is classical).
- The xor-reduction may read as Sprague–Grundy additivity + a symmetry reduction; content is in
  identifying templates.
- Don't lead with ½-density (reads as number theory bolted on). Do lead with: Node-Kayles is
  PSPACE-complete (Schaefer), so a group-action family with closed-form nimbers is a
  polynomial-time island.

### equivariant-robust-completion (Baer ⊕ completion)
**Stands out.** Ambitious merge with a strong Lean spine; end-to-end theorem constructs a
conjugate-pair arc extension; the exceptional PG(2,25) f=2 case is kernel-checked.

**Referee pounces.**
- Nearly all machinery is self-admitted classical (δ(C)=τ hitting-set duality, √2·s =
  Lunelli–Sce, Hilbert-90/Baer/incidence infrastructure, weighted/multi-insertion). The entire
  defensible novelty reduces to the "plausibly unrecorded" quadratic-Frobenius criterion
  (Thm 3.1) — highest priority risk of the set.
- Worked instantiation is 1/3 done: f=2 formalized; f=0,4 Lean-open; census / "minimum 32" are
  external evidence only.
- Nearest shelf for Thm 3.1: arcs/conics fixed by a **Baer involution** (Korchmáros–Sonnino).
- Must **state or exclude even s / char 2** (Baer involutions and unitals behave differently);
  silence is a pounce.
- Cohesion: two loosely-joined halves.

### continuation (N1)
**Stands out.** One sharp headline (Aut of the four-point-frame continuation graph = ambient
semilinear group, q ≥ 13); N2 correctly demoted after the embedding-genre collision.

**Referee pounces.**
- Least mature: no manuscript, Lean not built. Little to review yet.
- The q ≥ 13 threshold needs an explicit small-q exceptions list.
- Any N2 leakage re-opens the paywalled-Metsch collision.

## Q2 — Grades

Specialist curve (the whole portfolio tops out near B+/A−; none are field-movers). Axes:

- **Significance** — would the target community treat the answer as an advance worth citing.
- **Novelty** — probability the core claim is genuinely unrecorded.
- **Surprise** — how unexpected the result/method is to an expert (elementary-but-true scores low).
- **Audience** — how many communities care.
- **Readiness** — distance to submission (manuscript + formalization + audits; the shared
  public-URL blocker is factored out).
- **Rigour** — how airtight/complete the proof-state is, graded **against the field** (the
  internal release gate is stricter; see notes).

| Paper                            | Signif. | Novelty | Surprise | Audience | Readiness | Rigour |
|----------------------------------|:-------:|:-------:|:--------:|:--------:|:---------:|:------:|
| Arcs complete outside a conic    | B       | B+      | B−       | B−       | A−        | A−     |
| Complete repair hypergraphs      | B−      | B−      | C+       | B+       | B+        | A−     |
| Nofil games flagship             | B+      | B+      | B        | B+       | C+        | B−     |
| Dihedral Schreier Node-Kayles    | B−      | B       | C        | C+       | B−        | B      |
| Equivariant robust completion    | C+      | C+      | C        | C+       | C         | B−     |
| Continuation-graph rigidity (N1) | B       | B+      | B−       | C+       | C−        | C−     |

Adjustments from the first pass, after the Fable review + source checks:

- **coding Signif/Novelty → B−.** The headline invariant (τ) is cited prior art (PHO 2013); the
  family is bespoke k=4; parameters are weak. What remains is the exact all-symbol (ν,τ)
  separation + the complete-hypergraph transfer gate — real, but narrow.
- **dihedral Rigour → B.** Triple-cross-checked solver nimbers are field-standard practice in CGT;
  the Lean plumbing already exceeds journal norms. (It undercuts the *portfolio's internal* trust
  story, not the paper's — those are different bars.)
- **continuation Rigour → C−.** No manuscript, no Lean, only an audit; nothing at proof grade.

**Two-bar caveat on Rigour.** The table grades against journal norms. Against the project's own
release gate (`#print axioms` clean, no `native_decide`, statement-adequate, trust-chain note),
several papers regress: dihedral template nimbers, the nofil boundary negatives + elliptic gap,
Baer's f=0/4, and all of continuation are short of it. On readiness/maturity the order inverts
against the content axes — arcs and coding are shippable; nofil and continuation are strongest in
principle but least ready.

## Q3 — What's missed / free upgrades + the single (non-polish) leveler

### arcs
- **Free.** Higher dimension — caps complete outside a quadric in PG(n,q); the evaluation-
  obstruction lemma is already dimension-agnostic (arbitrary feature maps ⇒ every Veronese
  degree), so only the classical moment identities are missing. A polynomial-method / slice-rank
  framing remark (the dichotomy *is* the Croot–Lev–Pach linear-algebra core) pulls the additive-
  combinatorics crowd cheaply. Reverse saturating-set lower bounds from the exact defect identity.
  Hunt one more sporadic gem (q=11 gave the icosahedron/Clebsch). State the ρ_𝒞(11) < t₂(2,11)
  separation explicitly.
- **Leveler.** An **unconditional Θ(√q)** determination — a construction achieving O(√q)
  complete-outside-a-conic decoupled from t₂(2,q). (This is the paper's own Problem 2 — a
  legitimate leveler, but confirmation, not new discovery.)

### coding
- **Free.** Compute (ν,τ) for a **famous LRC family** (Tamo–Barg, availability codes, RM/simplex)
  — reframed post-correction as "the exact-computation method generalizes beyond the bespoke
  family," not as validating the (cited) invariant. Iterate the transfer into a **tower** over
  many alphabets. General structural ν ≤ τ inequalities. Byzantine/PIR robustness remark.
  Retitle/abstract around "exact repair tolerance," citing PHO up front.
- **Leveler.** Exhibit **two codes with equal locality + availability but different (ν,τ)** tied
  to a concrete repair guarantee — converts "an exact instance" into "a distinction that matters."

### nofil
- **Free.** **Surface the abstract mirror theorem already proven in Lean** —
  `FiniteBuildGame.isP_of_invariant_mirror` is parametrized by an arbitrary valid-set/good-class,
  so "any forbidden-configuration hypergraph with a fixed-point-free involutory automorphism ⇒ P"
  is already in the kernel; state it and harvest STS/design corollaries. **Sum-free over all
  finite abelian groups** (the proof uses only the negation mirror x↦−x; the mod-6 law is exactly
  2-torsion G[2] + 3-torsion G[3]). Other additive equations (Sidon/Bₕ, Schur). Cheap
  misère/avoidance companion remarks. Import arcs' certified q=11 icosahedron as a worked example.
- **Leveler.** Determine an outcome on **one board where the mirror method provably fails**
  (parabolic/Hermitian, or capacity ≥ 3), by a different argument — turns a trick + range-map into
  a theory of the game (and subsumes the elliptic gap).

### dihedral
- **Free.** Fold the solver S₄/A₅ rows in as corollaries of the general reduction. Ship the
  byproduct OEIS (Möbius-ladder / dihedral-Cayley nimbers). Apply the construction to other
  transitive actions. Mirror-certify the 𝒢=0 rows (see Q4).
- **Leveler.** **Escape "tame"** — one wild sub-case or the PGL₂(q) escape residual.

### equivariant-robust-completion
- **Free.** State the criterion for a **general finite-order collineation** (not just Frobenius),
  if the orbit-counting only uses orbit structure. Instantiate on a **named family** (Hermitian /
  Buekenhout–Metz unital / invariant conic). Cheap higher-dim instantiation on the NRC to satisfy
  the "worked instance" bright line. State/exclude even s.
- **Leveler.** Prove **one family-specific phenomenon the criterion uniquely explains** — cleanest
  target is turning the PG(2,25) f=0,4 profiles into a theorem-with-mechanism (spectrum/gap/
  inverse), i.e. a non-classical fact a finite geometer recognizes as new.

### continuation
- **Free.** Machine-resolve small q (4 ≤ q < 13) → an exceptions list. Generalize the reduct
  rigidity to k-point frames / higher dimension. Algorithmic (canonical-form / arc-equivalence)
  corollary from rigidity.
- **Leveler.** **Generalize N1 to an infinite family** (rigidity theory, not one graph).

## Q4 — Cross-paper connections

Genuine links beyond the ones already tracked (√(2q) arcs/Baer; nofil/dihedral split-by-technique;
Package 2 parentage; arcs↔nofil game bridge).

1. **Arc-extension conflict/continuation structures (same genre, not one graph).** arcs counts
   independent sets of the conflict graph (q=11 icosahedron polynomial), continuation studies its
   automorphisms/reconstruction, dihedral+nofil play Node-Kayles/pairing on it. *Correction from
   the first pass:* arcs' icosahedron is a point-level conflict graph on the 12 conic points,
   continuation's is a four-point-frame graph — **same genre, not the identical object**, so the
   "rigidity ⇒ game value transports for free" consequence does not hold as stated. Keep the theme;
   drop the literal identification until checked.

2. **δ=τ links three "τ" invariants — but there is no double-claim.** completion's δ_x, coding's
   repair-transversal τ_x, and arcs' arc-insertion distance are one abstract invariant.
   *Correction from the first pass:* completion §6.5 asks for τ at **off-cubic external points**
   (coplanar triples B with x ∈ ⟨B⟩); coding computes τ at **on-configuration code coordinates**
   (dual-support helper sets). Same functional form, **disjoint statements** — coding neither
   closes nor collides with §6.5. The real relationship: they are the **on-curve and off-curve
   halves of one determinant-hypergraph family**, so coding's coloring argument + Lean hypergraph
   plumbing are the natural attack on §6.5. Cross-cite as complementary, not overlapping.

3. **The q=11 icosahedron is an instance of dihedral's deferred §14 A₅-on-P¹(q) template.** Arcs
   already Lean-certifies that position as P — a certified data point waiting for dihedral's
   polyhedral program. Shared antipodal/Möbius structure. Cross-cite both ways.

4. **Off-conic point ↔ involution σ_x** ties the two "split-by-technique" tracks at the object
   level: arcs' secant-index r_A(x) and dihedral's σ_x live on the same off-conic points.

5. **Reusable-lemma links.** arcs' transitive-action averaging lemma is the existence tool Baer
   needs to move an invariant arc off a hole. arcs' evaluation-avoidance dichotomy ≈ coding's
   functional-dual-distance gate (both "avoidance ⇔ span/rank"). coding's trace-duality bridge and
   Baer's Frobenius-orbit bookkeeping are both **Galois-descent** — a shared Lean descent-lemma
   library would serve both.

6. **The nofil mirror engine plausibly certifies dihedral's P rows (new).** Prisms, Möbius ladders,
   and even ladders carry fixed-point-free adjacency-preserving involutions (pair non-adjacent
   vertices) — exactly the copycat hypothesis of `isP_of_invariant_mirror`. So Node-Kayles P-ness
   (𝒢=0) follows *without a solver* wherever such an involution exists, converting part of
   dihedral's solver-only headline table to kernel-checked at near-zero cost. Caveat: only 𝒢=0 rows
   admitting such an involution; nonzero nimbers stay solver-only.

**Umbrella framing.** The portfolio is a few deep objects viewed many ways; the sharpest single
name is **"circuit/determinant hypergraphs of small linear dependencies"** — arcs' secant
hypergraph, coding's repair hypergraph, completion's syndrome hypergraph, and the game papers'
conflict graphs are all instances. Stating this once in each introduction converts the
salami-slicing/double-claim reception risk into a coherent program identity. The √(2q)
coordination already in the planning doc is the first instance of this discipline; the
determinant-hypergraph framing and the icosahedron/A₅ cross-citation are the next two a specialist
would otherwise spot as apparent overlap.

## Corrections folded in

Two first-pass claims were overturned by the review and source checks; recorded to prevent
re-introduction:

- coding's ν/τ is **not** a new invariant — τ is cited prior art (PHO 2013, Def. 3). Novelty is the
  exact computation + transfer gate, and the grade dropped accordingly.
- There is **no** δ=τ double-claim between coding and completion §6.5 — the two are on-curve vs
  off-curve instances of one family, complementary rather than overlapping.

## Verification

Spot-checked against source: `complete_repair_hypergraphs.tex` L95–115 + novelty posture L155–169
(confirmed the PHO 2013 attribution and the narrowed novelty claim);
`completion-core-rigidity-upgrades.md` §6.5 L746–760 (confirmed the off-cubic external-point
definition, disjoint from coding's on-configuration τ); `arcs_complete_outside_conic.tex` abstract
+ asymptotic/Further-questions sections (confirmed higher-dimension is absent and the asymptotic
constant is already open); `ProjectiveCap/Mirror.lean` ~L240 (confirmed `isP_of_invariant_mirror`
is the abstract engine with geometry theorems as wrappers); `kernels/sumfree-zn.tex` (confirmed the
proof is the negation mirror with the mod-6 law from 2- and 3-torsion);
`dihedral-schreier-node-kayles-submission.md` App. A ~L1057 (A₅ template nimbers). Method: Opus 4.8
first pass, Fable independent second opinion (agentId ad329838a05096288), disagreements resolved by
reading source.
