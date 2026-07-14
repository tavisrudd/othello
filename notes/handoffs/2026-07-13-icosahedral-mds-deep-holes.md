# Icosahedral MDS / deep-holes = conic — spin-off lane

**Date**: 2026-07-13
**Status**: New lane, spun out of the papers-index #3 spin-off pick (`comp-q11-mds-deep-holes`).
Core structural theorem **confirmed computationally** by Fable against the Lean coordinates: the
q=11 non-GRS `[6,3,4]₁₁` code's 6-arc is the polar image of the six icosahedral (A₅) axes, deep
holes = the conic. Now proving the group/decoder consequences (C121) and checking novelty (C122).
**Next session**: land **C121** (A₅ / 2-transitivity / single-orbit-leaders Lean checks), then
decide on the **C123** twisted-cubic k=4 dual-variety test (see Doors).
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

- **L1 [REAL, in-repo]. Klein's icosahedral quintic resolvent.** The object's native home. Solving
  the quintic runs through the icosahedral equation + its **degree-6 resolvent** (the six 5-fold
  axes A₅ permutes 2-transitively) — our six poles are an **exact F₁₁ avatar of Klein's sextic
  resolvent**; 12 conic points = degree-12 vertex form. Reframes the whole object as a finite-field
  incarnation of the icosahedral solution of the quintic. *Klein's is analytic/over ℂ; ours is
  finite + kernel-certified.*
- **L2 [REAL chirality+Petersen; SPECULATIVE exact tetrahedra bijection; in-repo].** The 10+10
  leader split = the icosahedron's **chirality** = the two enantiomorphous **compounds of five
  tetrahedra**; the 10 complementary triple-pairs carry the **Petersen graph** (A₅ on 10, stab S₃ —
  grounded). Deep-hole leaders secretly encode Petersen + five-tetrahedra chirality.
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
- **BLOCKING CHECK before any submission:** O'Keefe–Storme, *"Arcs fixed by A₅ and A₆"* (J. Geom.
  1996) and *"Primitive arcs in PG(2,q)"* (JCTA 1995) are paywalled and are exactly where this arc
  would already be catalogued. Obtain and check before claiming the arc is new.

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
