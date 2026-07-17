# Repo Scope Summary — `othello` workspace

A cross-thread synthesis of scope, agenda, results, dead ends, frontier, and tooling.

---

## 0. What this repo is

It began as an **Othello/Reversi engine** (Python package + a high-performance Rust port with an
endgame solver). That engine still lives here and still passes its gates, but the work now is a
**combinatorial game theory (CGT) research program** on a family of impartial *placement / avoidance*
games, backed by:

- a fleet of exact solvers (Rust + Go + Python),
- a bespoke game-tablebase + query/mining toolchain,
- a `sorry`-free **Lean 4 / Mathlib** formalization layer.

The open research center of gravity is the **projective cap ("Nofil") program** and its **odd
projective-plane kernel**, with the Lean layer certifying results as they land. But the cap machinery
has spun off enough standalone finite-geometry and coding-theory mathematics — extension, rigidity,
and completion-distance theory about geometric *legality* rather than game value — that the repo now
carries a **publication track alongside the research track**: `papers/` stages seven papers in ship
order plus two OEIS entries, governed by a Lean release gate (see §3, §7, §8).
[`papers/papers-index.md`](../papers/papers-index.md) is the registry — it maps every result to its
paper and its proof location.

---

## 1. The unifying frame

Every game studied here is one object: an **impartial, normal-play building-avoidance game on an
incidence hypergraph**, where legal positions are *line-capacity independent sets*. Given points,
line families, and per-line capacities `c(L)`, a move adds a point keeping `|S ∩ L| ≤ c(L)` for
every `L`; the last player able to move wins. `P` = second-player win; `N` = first-player win.

| Instance                     | Capacity / lines                           | Reduces to                               |
|------------------------------|--------------------------------------------|------------------------------------------|
| Non-attacking **Queens**     | capacity-1, four affine directions         | Node-Kayles on the queen graph           |
| **Cap / Nofil** (aff./proj.) | capacity-2, all lines of a finite geometry | Nofil on the collinearity-triple 3-graph |
| **Sum-free** on abelian `G`  | Schur-triple hypergraph (`a+b=c`)          | Nofil on the Schur 3-graph               |
| **Cap-set** on `F₃ⁿ`         | capacity-2 (`a+b+c=0`); `STS(3ⁿ)`          | affine cap game                          |
| **Node-Kayles**              | the capacity-1 / saturated-residual limit  | itself (the substrate)                   |

**Novelty posture (deliberately conservative):** a *structured finite-incidence subfamily* of the
published Sieben / Huggan–Huntemann–Stevens (HHS) hypergraph building-avoidance genus — **not a new
class of games**. The bare "Nofil = Node-Kayles on a saturated residual" collapse is prior art; only
the *structured* collapse (residual slacks, mirror obstructions, conic localization) is claimable.
Transfer runs **queens → cap** only, and the `c=1` mirror facts are folklore — only the `c ≥ 2`
mirror/slack analysis is new.

---

## 2. The threads

| Thread                 | What it is                                        | State                                        |
|------------------------|---------------------------------------------------|----------------------------------------------|
| **Projective cap**     | `PG(n,q)` cap/Nofil outcome theorem               | **Open research frontier.** Odd-plane kernel |
| **Geometry / coding**  | The spin-off portfolio (§3) — legality, not value | **Where the deliverables are.** Seven papers |
| **Queens**             | Non-attacking queens game + A344227 nimbers       | n=18 outcome solved; G(18) nimber open       |
| **Sum-free / cap-set** | Achievement game on abelian groups / `F₃ⁿ`        | Core theorems proved + Lean; one slice open  |
| **Node-Kayles**        | Graph/Cayley substrate for all of the above       | Outcome laws proved; classic opens remain    |
| **Othello**            | Rust port of the Python engine + endgame solver   | Stable, gate-green, effectively archived     |

The first two are the split that matters: the cap thread is the *unsolved problem*, the geometry /
coding thread is the *shippable output*, and the second is now the larger body of work.

---

## 3. Proved / closed (results ledger)

### Projective cap — closed families
- **`AG(n,q)` is P** for every finite affine space, every `q`. *(Lean: `CapGame/Affine`.)*
- **`PG(n,2)` is P** for every `n ≥ 1` (binary case = Nofil on projective Steiner triple systems).
  *(Lean: `Binary`.)*
- **`PG(2m−1,q)` is P** for every odd `q` — fixed-point-free elliptic projective involution.
  *(Lean: `EllipticMirror`.)*
- **`PG(2,q)` is P for all even `q`** (char-2 residual translation mirror). *(Lean: `PlaneOutcome`.)*
- **Odd planes, per-`q`:** `q=5,7` P by a **mechanism** theorem (not enumeration); `q=11,13` P by
  **kernel-checked certificate assembly** — all four Lean-closed. `q=3,9,17,19,23` computed P (q=23
  via the 22-bucket full-`PGL(2,23)` on-conic census + the full-PGL bridge), not yet Lean-closed;
  **`q=25` full-census COMPLETE** — all 28 full-`PGL(2,25)` on-conic buckets P, so
  `min-witness(25) = q−4 = 21` (full) and q=25 is **non-depleted**; the knife edge rebounds fully at
  the first square order.  All four projective
  planes of **order 9** (PG(2,9), Hall, dual Hall, Hughes) computed P — the P-property is
  Desargues-independent at order 9.  The q=17 **(ON)** statement is now *proved from bucket
  stabilizers* (the capacity lemma: 15 pointed-pairing involutions vs N-capacity `q−4 = 13`).
- **The `L(A)` structure theorems (proved):** every frame-point/on-conic candidate
  secant, endpoints normalized to `(0,∞)`, has legal cells = the involution pencil `τ_a(t) = a/t`
  minus the pair products `P2(U)` of the other four frame points — `nlegal = q − d`,
  `d ∈ {4,5,6}`, all odd prime powers; the fifteen round-1 involutions distribute `3/1/0` per
  `d = 4/5/6` line; the `d=4` maximizers biject with the involutions of `Stab(A)` (tie counts
  `1,3,5` or `15`, exactly as observed); `fiber(B) = 30(q−1)/|Stab(B)|` for every on-conic
  bucket; any completion-automorphism capacity family has supply ≤ 838 = O(1) in q.
- **Classical-variety harvest** — new P-families from the generic fpf-involution
  mirror: hyperbolic quadric **`Q⁺(2m−1,q)`**, symplectic polar space **`W(2n−1,q)`**, and Segre
  products **`PG(a,q)×PG(2m−1,q)`**, all P for odd `q`. *(Lean: `HyperbolicQuadricMirror`,
  `PolarSegreMirror` — reusable `c=2` mirror engine + grid-rook base fully proven; higher
  instantiations statement-level.)*
- **Elliptic quadric `Q⁻` is P too** — the standard elliptic quadric in every even vector dimension
  carries an fpf mirror (hyperbolic pairs plus one anisotropic binary tail, all scaled by the same
  nonsplit block map). *(Lean: `EllipticQuadricMirror`, coordinate-exact.)* This **overturned a
  claimed negative of our own**: the conjectured `Q⁻` mirror *exclusion* was false, and the family it
  was supposed to rule out is a genuine P family.
- **Mirror-method boundary (final; all Lean).** For odd fields the method is positive on
  **both** standard even-dimensional orthogonal types, `Q⁺` and `Q⁻`; the modeled **parabolic and
  Hermitian** branches are method-negative (no fpf involution of the classified type). Method-negative
  is not an outcome: those rows leave the game's P/N value undetermined. Odd ambient dimension remains
  necessary but not sufficient.

### Queens
- **Outcome settled through n=18.** Odd `n` → first; `n∈{4,6,8}` → first; `n∈{10,12,14,16}` → second
  (reproduces Jenrich); **`n=18` → first player**, witness opening **I9 = (8,8)** + a 15-ply PV, two
  independent leaf configs agreeing byte-for-byte.
- **A344227 nimbers beyond the catalogued n=13:** **G(14)=0, G(15)=1, G(16)=0, G(17)=2** (G(17)=2
  **verified**, ~585B nodes). **G(17)=2 falsifies the `G(n)∈{0,1}` conjecture** (first value >1 since
  G(7)). n=18 first-player win only fixes `G(18)≠0`.
- **Theorems:** self-mirroring-square lemma; odd-`n ⇒ G≥1`; even-`n` first-win *requires* a
  long-diagonal move. **Lean:** the `getK` leaf evaluator's recurrence, iso/induced invariances, and
  Grundy characterization machine-checked (`no sorry`).

### Sum-free / cap-set
- **`Z_n` mod-6 law:** for `n ≥ 5`, second player wins **iff `n ≡ 0,1,5 (mod 6)`**. *(Lean.)*
- **Abelian 2-rank criterion:** with 2-rank `s₂`, `τ₃=[3∣|G|]`: **P iff `s₂ ≥ 2`, or (`s₂ ≤ 1` and
  `s₂ = τ₃`)** — proven in the `r₃ ≤ 1`/`s₂ ≥ 2` range. New phenomenon: `Z₂²×Z₉ = P` though
  `Z₉ = N`. *(Lean via the `r₃ ≤ 1` wrapper.)*
- **`F₃ⁿ = N` for all `n`** (settles `F₃⁴/F₃⁵` with no compute); **`Z₂ × F₃ᵇ = P` for all `b`.**
  *(Lean.)*
- **Cap game `AG(n,q) = P` for every `n` and `q`** — settles the cap-set achievement game in **every
  dimension including d=5**. *(Lean: `CapGame/Affine`.)*

### Node-Kayles
- **Cayley outcome law:** P-positions pairing-explained (even order); N-positions mostly not (Paley
  `p ≡ 5 mod 8` lives in the un-pairable gap).
- **`C_n^k` = octal `0.[1×k][3×k]7`:** `k=1` = Dawson's chess (period 34); `k ≥ 2` aperiodic.
- **Double-encoding gap CLOSED** (`29c5349`): vertex-deletion ≡ independent-set-building.
  *(Lean: `ConflictGameEquiv`.)*

### Finite-geometry & coding spin-offs (geometric *legality*, not game value)

**Boundary caveat, load-bearing throughout:** none of the results below supplies a P-valued
cap-game child. They concern *legal* extension / reconstruction / recovery, split off from the cap
machinery as standalone finite-geometry and coding-theory units. The novelty posture is consistently
conservative — many components are classical-facing, with the claimable content in a specific *robust*
refinement (the deletion/transversal spectrum, the marked-orbit statistic, the complete-repair
hypergraph), gated on prior-art audits that have repeatedly landed against us and been conceded (§8).
This is now the larger half of the repo's proven mathematics and the whole of its publication track.

- **Arcs complete outside a conic** (the lead deliverable; `arcs`). The exact **prescribed-hole
  defect identity** and its corollaries (equality pattern, uncovered-locus bound, quantitative
  stability), the corrected capacity lower bound, and an explicit additive asymptotic
  `ρ_𝒞(q) ≥ √(2q) + 3/2 − 8/√(2q)` — restated as a concrete inequality rather than O-notation,
  which is both easier to formalize and a stronger claim. **Exact values:** `ρ_𝒞(5) = 4`,
  `ρ_𝒞(8) = ρ_𝒞(9) = ρ_𝒞(11) = 6` and **`ρ_𝒞(16) = 9`** — the last from a checked exhaustive
  projective classification proving no eight-point arc is complete outside any nonsingular conic (it
  independently reproduces the known 2633 ordinary eight-arc classes, then refines them into 2630
  full-rank and 3 forced-hit quadratic-avoidance rejections). Two structural bridges carry the
  weight: the **sharp evaluation dichotomy** (for any feature map, hence every Veronese degree, a
  form vanishing on the uncovered locus `U` and avoiding an arc `A`, `|A| ≤ q`, exists exactly when
  `span ν(U)` is proper and contains no `ν(a)`), and the **arc / codimension-three MDS syndrome
  dictionary**, under which relative completeness *is* syndrome confinement and the defect identity
  *is* a weight-two leader-collision identity. Also owns the **q=11 deep-holes = conic**
  identification: a projectively non-GRS `[6,3,4]₁₁` code of covering radius three whose
  distance-three affine syndrome rays are exactly the standard conic. All Lean, `sorry`-free.

  **The prescribed hole answers to something already asked.** Taking the hole to be a *line at
  infinity* specializes the whole framework to **complete affine arcs**: `CompleteOutside A L∞` is
  exactly maximality of `A` as an arc in the affine plane obtained by deleting that line, every
  secant meets a disjoint line once so `I_{L∞}(A) = C(k,2)`, and substitution into the general
  prescribed-hole inequality gives a complete affine bound with the general zero-defect theorem
  supplying the equality pattern at affine and ideal points alike. That instance sits inside an
  existing research line — hyperfocused arcs and their secret-sharing origin (Giulietti–Montanucci;
  Korchmáros–Szőnyi, who state explicitly that some such constructions are complete in exactly this
  sense). The boundary is kept narrow and stated as such: this shows the *line-hole instance* was
  previously asked for, **not** that the conic parameter itself was.

- **The Clebsch hexagon code** (`clebsch`) — the reading of that q=11 witness, and the sharpest
  single result in the portfolio. **Rigidity (five-way TFAE):** for a six-arc `A ⊂ PG(2,11)`, `U(A)`
  lies on *some* conic ⟺ `U(A)` is *all* `𝔽₁₁`-points of a nonsingular conic ⟺ `#U(A) ≤ 15` (in fact
  12) ⟺ `A` is `PGL(3,11)`-equivalent to the Clebsch hexagon ⟺ `Stab(A) ⊇ A₅`. The icosahedral group
  is **recovered** from a purely coding-theoretic hypothesis, not assumed. **Gap:** the phenomenon is
  rigid, not merely stable — every non-Clebsch class has PGL-invariant nearest-conic discrepancy
  `δ ≥ 12`, the Clebsch class is the unique zero, and each single-point perturbation has
  `#(U Δ 𝒞) ≥ 18`; distance jumps `0 → ≥18` with nothing between. **Why 11, classification-free:** a
  conic-filling uncovered locus forces `c = (q−6)(q−9)`, which against the universal matching bound
  `c ≤ 15` rules out every `q ≥ 12` in *all* characteristics, leaving geometric exclusions at
  `q = 4, 5, 9` (hyperoval completeness; six-cap maximality; the Sylvester graph's clique number
  five, which lands by identifying a hypothetical six-arc with a six-clique in the exact-distance-two
  graph of the 36 internal points — a distance-regular graph of intersection array `{5,4,2;1,1,4}`
  whose `eq₂` is known to be 5). Extended to **`4 ≤ k ≤ 7`**: the only conic-filling pairs are
  `(k,q) = (4,5)` — the projective frame — and `(6,11)`; at `k=7` the arithmetic leaves only q=11 and
  q=13 with forced spectra, both excluded by exhaustive search.

  **The spine is now conceptual rather than enumerative**, which is what moves the paper's central
  claim from an exact classification to an equality theorem. Two replacements did it. The **`q−5`
  line lemma** — every line carries at most `q−5` points of `U(A)` for a six-arc in odd
  characteristic — is proved by a short synthetic argument: the fifteen chords properly 5-edge-colour
  `K₆`, hence one-factorize it; three factor classes normalize to a triangular prism; and the two
  parallelism conditions force `a(b−1) = −1` and `a(b−1) = +1` simultaneously. That alone bounds
  `|U(A)| ≤ 12`, so with Dye's `c ≤ 10` it forces `c = 10` and closes the line-pair branch without a
  census. Separately, the **`A₅` orbit profile `[6, 10, 12, 15, 30, 30, 30]` is *derived*** from
  fixed-point spectra and the subgroup ledger, not assumed; a second off-arc orbit would already
  breach `c ≤ 15`, forcing `c = 10` and identifying `U` with the unique 12-orbit — the conic. The
  1,548-class census survives only as the independent size-gap clause and a regression check.

  **The family formula, replacing an instance.** For *any* Clebsch hexagon over `𝔽_q`,
  `|U(H)| = q² − 14q + 45`; for `q ≡ 3 (mod 4)` every edge is a non-secant of Dye's associated conic,
  so the off-conic excess is exactly `(q−4)(q−11)`. Within that congruence class the conic is the
  whole uncovered locus **exactly at q=11**. The q=19 count of 140 deep holes on no conic is now a
  corollary of the formula, and its checker demoted to independent verification.

  **The two reflection-arrangement exceptions.** The fifteen Clebsch secants **are** the
  projectivized `H₃` icosahedral mirrors — an equality of arrangements, not of incidence ledgers,
  exhibited by an explicit `F₁₁` projectivity at `τ = 8`. The six fivefold points of the mirror
  arrangement remain an arc in every characteristic but two (every `3×3` determinant on them is twice
  a unit of `ℤ[τ]`), and the singularity ledger `6₅ 10₃ 15₂` gives
  `χ_{H₃}(t) = (t−1)(t−5)(t−9)`, hence projective complement `(q−5)(q−9)`. Paired with the braid
  arrangement `A₃` — the six joins of a standard four-frame, `χ_{A₃}(t) = (t−1)(t−2)(t−3)`, complement
  `(q−2)(q−3)` — the two conic-size equations factor as `(q−4)(q−11)` and `(q−1)(q−5)`, isolating
  q=11 and q=5. The apparent `q=4` root is extraneous: the `H₃` model is bad in characteristic two.
  Marking the six fivefold points as parity-check columns turns the multiplicity strata into the
  established nearest-codeword ambiguity counts. **The claim here is deliberately small**: Edge
  already derives real Clebsch hexagons from the six icosahedral axes and Dye gives the golden-ratio
  coordinates, so the icosahedral identification is classical in substance; Calvo 2024 owns the
  modern reflection-arrangement ledger; and Jurrius–Pellikaan 2015 is an exact collision with the
  general arrangement-decoder mechanism, down to an example on redundancy-three MDS secant
  arrangements. What survives is the paired `A₃`/`H₃` conic-filling synthesis — an application, not a
  new arrangement theorem.

  **Low-degree rigidity, with a refutation inside it.** *Clebsch is the unique class among the
  fifteen whose uncovered set lies on any cubic* — every non-Clebsch cubic evaluation matrix has full
  column rank ten, while Clebsch has minimum degree two with a one-dimensional quadratic kernel. This
  containment theorem **replaced a false predecessor**: "Clebsch is the unique class whose uncovered
  set is the full rational point set of an irreducible curve" is wrong — three other classes have
  exact absolutely irreducible loci at their minimum vanishing degree (a smooth quartic of genus 3, a
  quintic with one nonsplit node, a smooth sextic of genus 10). The negative boundary is stated as a
  boundary: degree six was exhausted only for the one class whose kernel is small enough.

  **Decoding and chirality, at their correct levels.** The complete syndrome-distance oracle is a
  four-case rule, and the nearest-codeword multiplicity distribution is exact. The twenty support
  triples split into two complementary `A₅`-orbits of ten — but **chirality is not the coarsest
  equivariant rule**, which corrects the natural reading of that halving: the stabilizer of an affine
  syndrome vector in the order-600 monomial group has order five with four orbits of size five, so
  **list size five is the equivariant floor** and is attained by four distinct decoders. The two
  size-ten chirality decoders are the proper selections determined *solely by support*, and they form
  an unordered pair — no preferred orientation is asserted.

  Side results: the dual code is again a Clebsch hexagon code (self-dual phenomenon, not
  coordinate-for-coordinate); the two icosahedral hexads are **transverse** to `S(5,6,12)`, turning
  "is this a Golay/Mathieu thing?" into a stated negative; and a ten-arc with the same `A₅` has
  *empty* deep holes, so emptiness is the generic behavior under icosahedral symmetry and the hexagon
  is the exception, not an artifact.

- **Frobenius-equivariant pair extension of eight-arcs** (`baer`). **Headline, Lean-built:** *every*
  Frobenius-invariant eight-arc in `PG(2,25)` admits a fresh conjugate-pair extension — proved by an
  exhaustive parity split over `f = 0,2,4,6,8`, with the `f = 0` and `f = 4` profiles
  **certificate-free** (from center incidence, exact balance, endpoint moments, and parity) and only
  the exceptional `f = 2` profile needing a finite certificate. Combined with the generic `s ≥ 7`
  criterion and the absence of an intervening prime-power order, this lifts to **every prime power
  `s ≥ 5`**. Supporting it: the assembled exact **quadratic-Frobenius criterion** (the principal
  plausibly unrecorded result), a subtraction-free linewise collision correction
  `legal(ℓ) + M = N + B_ℓ + Σ(μ_ℓ(q)−1)` separating invisible orbit mass from collision redundancy,
  and the denominator-free orbit-saturation bound `2s(s−1) ≤ (k−1)²`. The external `GF(25)` census
  size and its observed minimum are deliberately **kept outside the theorems** as data.

- **Alternate-orbit repair for invariant ten-arcs** — the erasure-repair reading of the same
  machinery: delete a selected nonfixed conjugate orbit from an invariant ten-arc and the repair must
  use a *different* legal orbit, not merely restore the erased pair. Kernel-checked for every prime
  power `s ≥ 7` with at least **eight** alternatives; the uniform `PG(2,25)` theorem carries a
  two-witness certificate. The exact general-`s` five-profile lower-bound envelope (`f = 4` at
  `s = 7`, `f = 6` at `s = 8,9`, `f = 8` for `s ≥ 10`) yields a uniform **318 alternate repairs** —
  a profile-minimized first-order lower bound, not a proved sharp minimum. At `PG(2,25)` all 1,189
  residual class representatives carry a kernel-checked lower bound of **32**, with five proposed
  minimizer classes at checked equality, and the mechanism is understood: freshness blocks three
  candidates and carrier incidence blocks 140 in *every* residual class, so only the old-secant mask
  varies and the legal-count spectrum 32–47 comes entirely from overlap. **The boundary is explicit
  and load-bearing: 32 is not yet the exact semantic minimum**, and the five classes are not yet a
  complete extremal classification — that needs the residual-cover and orbit-completeness bridge,
  which is the open frontier.

- **Completion-core rigidity** — robustness theory for maximal feasible configurations. **Now
  library-only, not a paper:** the generic completion/transversal synthesis has no family-specific
  bridge to the Baer/Q25 headline, and its components audited out as classical infrastructure
  (blocker, weighted, symmetry, reliability, defining-set, algorithmic). It remains reusable, checked
  machinery. For a facet
  `C` of a finite hereditary independence system, the completion distance `δ(C) = min_{F≠C}|C∖F|` has
  a sharp deletion theorem (any puncture of radius `< δ(C)` forces `C` as unique completion);
  `δ(C)` and minimum defining-set size `d(C)` are the min-edge size and transversal number of the same
  alternative-completion hypergraph, and `δ(C) = |C| − I(C)` is an intersection number.
  For complete caps `δ(C) = min_{x∉C} s_C(x)` = the largest `μ` making `C` a `(1,μ)`-saturating set.
  **Exact families:** conic `(q−1)/2`, hyperoval `(q+2)/2`, maximal `d`-arc `q − q/d + 1`,
  classical elliptic quadric `q(q−1)/2`, GQ ovoid `t+1`, spread `q+1`. New extremal invariant `γ(q)`
  (smallest arc with nontrivial core): `√(2q) + O(1) ≤ γ(q) < 1.835√(q ln q)`. The NRC zero-sum
  insertion orbit `δ_x(C) = q − Z_d(F_q)` is an exact bridge to additive combinatorics —
  for `q = 3^h`, `δ = 3^h − cap₃(h)`, so the Ellenberg–Gijswijt bound applies verbatim. Surviving
  new-program candidate: relative multiple saturation `t_h(q)`.

- **Continuation-graph rigidity** (three separated levels — embedded recovery, intrinsic trace
  recovery, semilinear extension). Support-degree reconstruction (`d_K(p) ≤ k`, so `K` = the
  points of support-degree `> k`) gives embedded rigidity in any partial linear space. The continuation
  graph is the line graph of a `k`-uniform linear hypergraph and an injective nonlinear length-`k` code.
  **Two headlines:** for `q ≥ 13`, the abstract four-point-frame graph has exactly its
  ambient semilinear automorphisms `Aut(G_K) = Stab_{PΓL(3,q)}(K)` (the legal set `Ω` is
  `M_{0,5}(F_q)` with one forgetful map omitted; the punctured-multiplicative-isotopy lemmas force
  Frobenius); and the full continuation *complex* `Δ_K` canonically reconstructs the ambient plane,
  secant arrangement, and arc for `q ≥ r²−r+k`. The plane-independent rook-graph
  and multiplicative obstructions show blanket semilinear extension can begin no earlier than
  `k = 4`.

- **Coding / MDS cross-field sweep.** The **characteristic-matched Roth–Lempel family**: for odd `p`,
  `q = p^h`, `h ≥ 2`, the finite degree-`p` NRC columns plus `e_{p−1}` give an optimal
  `[q+1, p+1, q−p]_q` NMDS-LRC with all-symbol locality `p`, minimum circuits = zero-sum `p`-subsets,
  and a hot coordinate whose recovery-hypergraph transversal/matching ratio `τ/ν → p` (asymptotically
  maximal). The **twisted-cubic–axis family**: for `q = 3^h ≥ 9`, the `q` finite twisted-cubic points +
  the `(q+1)`-point characteristic-three axis generate `[2q+1, 4, q−1]_q` with **`τ > ν` at every
  coordinate** (`q = 9`: exact `τ/ν = 7/4`; uniform `τ_i > ν_i` proved for all `q = 3^h ≥ 9`). The
  **bounded-repair transfer lemma** (inner dual distance `r+1`, outer `≥ r+2` ⇒ every concatenated dual
  word of weight `≤ r+1` is confined to one inner block) lifts any finite seed to a fixed-alphabet,
  positive-rate, positive-distance asymptotically good LRC family that preserves the *complete* radius-`r`
  repair hypergraph — instantiated with Garcia–Stichtenoth AG outer codes. Closed routes: the
  Cheng–Murray representation-diversity reduction (equivalent to the Zhang–Wan symmetric-hypersurface
  conjecture, not a way around it); mixed-alphabet folding (downgraded under broad Hamming equivalence).
  Computed-exact signal: twisted-cubic repair tolerance `τ` is not even monotone in representation count
  or in disjoint availability `ν` (`q = 5,7,11`).

- **Complete repair hypergraphs under concatenation** (`coding`) — the sweep above, matured into a
  manuscript with a Lean package. The twisted-cubic–axis seed `[2q+1,4,q−1]_q` has an **exact**
  all-symbol profile in characteristic three: every cubic coordinate has `(ν,τ) = ((q−1)/2, q−2)`
  (via a shifted-inverse consecutive-power rainbow matching), giving **`τ > ν` at every coordinate**
  for `q ≥ 9`. Its **projective completion** `[2q+2,4,q]_q` has dual distance three, radius four
  exhausting the full minimal inner port, and uniform rows `((q−1)/2, q−1)` and `((5q−3)/6, 2q−3)`.
  The transfer lemma lifts either seed to a fixed-alphabet asymptotically good family preserving the
  *complete* radius-`r` repair hypergraph — concretely, unbounded `GF(9)` families of exact rate
  `2/19` and `1/10`, with every fixed eventual relative-distance bound `c < 39/190` and `c < 351/1600`.
  Both transfer gates are proved **uniformly non-weakenable** by nondegenerate `GF(3)` boundary
  counterexamples. The sole deep import is Stichtenoth's self-dual TVZ theorem, quarantined and
  visible in the headline axiom report.

  **Two corrections carried into the manuscript, one of them substantive.** A standalone referee read
  found the earlier text **incorrectly equating multiblock confinement with complete
  repair-hypergraph equality** — a one-block dual word may induce a nonzero outer functional, and
  equality of support sets does not identify witnesses. The manuscript now separates multiblock
  distance from the exact **nonembedded-witness threshold** `δ_emb = min(2d(I⊥), d_λ(O))`; falling
  below `δ_emb` implies hypergraph equality, **with no converse claimed**. Coordinate-surjective
  applications survive because their singleton functional stratum is empty. That exact threshold also
  *replaces* the original transfer gate rather than refining it: a Singer-shifted `[5,4,2]_{6561}`
  single-parity-check outer code reaches `d_λ ≥ 6` on support only 5, so transfer holds **where the
  old support-distance gate fails**, and the rate-`1/10` family is revealed as merely the
  `R_outer = 1/2` point of an AG Pareto continuum that does not dominate it.

  **A second infinite family.** The `d = 4`, `p = 3` nucleus `e₂` gives `[q+2, 5, q−3]_q` for every
  `q = 3^h ≥ 9`, dual distance five, exact locality four, whose small circuits are the nucleus
  together with the **harmonic quadruples forming an `S(3,4,q+1)`** — the Steiner system is what
  makes the family tractable, and at q=9 it is a `[11,5,6]₉` with nucleus row `(2,5)`.

- **Repair ports as a theory in their own right** (`repairports` → `rp-next`) — the completed repair
  machinery turned into a deliberate search engine, run under a discipline that each round must yield
  a general identity, a strict operational separation, an explanatory compression, or a **decisive
  negative that kills a tempting route**. It produced all four, and the negatives are the load-bearing
  part.

  **What a repair port *is*.** Every bounded repair port is an exact **radius-truncated erasure-channel
  EXIT object**, with two exact partition-function transforms: the cubic failure law is the partition
  function of **restricted-sumset defect**, and the axis law factors as an explicit prefactor times
  the **independence polynomial of the zero-sum-triple hypergraph**. The operational payoff is the
  cheapest-radius law `Pr(L_x = r) = h^(≤r−1) − h^(≤r)`, whose successive differences **price the
  marginal locality budget**. Four conventions were nailed down in the process, each a live trap:
  `h^(≤r)` is *extrinsic* (homogeneous residual erasure is `p·h`, not `h`); a radius cutoff is a
  generally suboptimal bounded-query decoder, not symbol-MAP; and repair blockers are exact
  **target-specific one-shot certificates**, not Tanner stopping sets of an iterative decoder.

  **The invariant already had a name.** The full rank-jump port **is** the one-element set-pointed
  Tutte polynomial — the Las Vergnas perspective `M∖x → M/x` — so no new invariant was needed. That
  import pays immediately: pointed duality gives `R_(M,x)(s) + R_(M*,x)(1−s) = 1`, turning blockers
  into dual repairs, and two ordinary rank polynomials suffice to compress the port. It also draws its
  own boundary — the standard polynomial is *unfiltered*, so bounded-radius theory must retain circuit
  size (the full nucleus port adds exactly `72u⁵` over radius four).

  **Cooperative and sequential repair.** Full cooperative ports are just clutter conjunctions of
  restricted singleton ports — again no new invariant. The real layer beneath is bounded **sequential**
  repair, which is exactly **small-circuit Horn closure**; unbounded closure completes in *one* round,
  so iteration exists only because of the radius cutoff. Composition then works through matroid
  2-sum, which passes **exactly one scalar message** — a cheapest-certificate budget `β ∈ {0..r, ∞}` —
  with costs adding across the interface and readiness times combining by max.

  **Where it stops, and why.** Three decisive negatives bound the theory. *Naive same-radius
  deletion–contraction is dead* — deletion removes a repairable relay while contraction admits an
  over-budget lifted circuit, with two explicit binary witnesses. *There is no finite transfer
  alphabet bounded by radius and interface width* — binary triangle relays at radius two and width
  two have pairwise distinct first-finite-response times, and the proof discards the counts entirely,
  so it is strictly stronger than "the counts are unbounded." That obstruction turned out to be
  **purely a timing artifact**: forgetting arrival times restores a finite structural control algebra,
  with the exact counts surviving as additive infinite-carrier weights — all the triangle relays
  collapse to a single control. And on the cryptographic side, both `GF(9)` holonomy classes are
  ordinary multiplicative but **not strongly multiplicative for every dealer**, because the criterion
  factors through the quadratic Veronese matroid and is uniformly `U(3,4)` — blind to cross-ratio, so
  **no realization can fix it**.

  **Gauge, reliability, and stability.** Fundamental-cycle holonomies classify coefficient labelings
  up to gauge with a linear-time equivalence test, and axis four-cycles *are* projective cross-ratios;
  holonomy **strictly refines** the support port, shown by a `GF(9)` pair with identical `U(2,4)`
  support whose holonomies lie in disjoint anharmonic orbits. For any `S(3,4,n)`, survival
  `s_n = c·n^(−3/4)` puts repairability in a **Poisson window** `1 − exp(−c⁴/24)` — explicitly *not* a
  sharp threshold — while every curve-target repair contains the nucleus, giving a **series
  bottleneck** with no vanishing-probability threshold at all. A uniform inverse theorem on
  restricted-sumset defect then yields exactly `q(q+1)/2` minimum blockers for **every** `q = 3^h`,
  upgrading a q=9 census to a uniform statement.

  **One novelty claim was walked back.** The functional-cost parameter `λ_I` **is** the classical
  induced quotient / coset-leader / syndrome weight — a definition-level collision, decisive. Only the
  *pointed* constrained-coset cost survives as a candidate; the real upgrade in that neighborhood is
  prescribed-port replication at positive density. Separately, a kernel-checked rescaling theorem
  shows raw coefficient values are **arbitrary coordinate gauge**, so no minimum-access or
  minimum-bandwidth claim follows from them under subpacketization.

- **The twisted cubic as a shared object.** One object — the twisted cubic in `PG(3,q)` under
  `PGL(2,q)` — carries coding's weight distribution, completion's external-point transversal
  spectrum `ρ(x) = τ`, and arcs' `d = 2` conic defect as the on-curve / off-curve / `d=2` instances
  of a single *circuit/determinant hypergraph of small linear dependencies*. Proved: the equivariance
  backbone `⟨T_a, inv, scaling⟩ = PGL(2,q)` of order `q³−q` preserves cubic + axis, so `τ` is
  orbit-constant; the projection→plane-cubic reduction `τ(x) = (q+1) − max-no-3-collinear` of
  `π_x(C)`, with an orbit→type dictionary (axis = cuspidal, internal = nodal, tangent/regulus =
  smooth elliptic); and the **axis closed form `τ_axis = q − r₃(h)`** — a cap-set law, which reduces
  that orbit to the cap-set problem outright. Stating the shared identity once per introduction is
  what converts a salami-slicing risk into a program identity.

- **Mathieu hexads by polarity defect** (`gem-mining`). *A 6-subset of the conic in `PG(2,11)` is a
  hexad of `S(5,6,12)` iff no three of its chords are concurrent off it* — fully machine-checked
  (both systems Steiner-verified, swapped by every outer map, the `t = 60` stratum exactly their
  union, gap at 61). The proof structure is synthetic and computer-free: `t(H) = 60 + #{involutions
  stabilizing H with no fixed point in it}`, and `PGL(2,11)` has four orbits on 6-subsets of which
  the hexads are the one whose stabilizer has odd order — which also explains the gap. A stronger
  form holds with no conic or characteristic hypothesis: `t(H) + |U(H)| = q²−14q+115` for **every**
  six-arc in **every** finite projective plane, whose q=11 specialization `t + |U| = 82` says the
  hexads are exactly the on-conic six-arcs of maximal extension count. The `q = 23` octad analogue is
  **dead**, and the reduction says why: the mechanism needs `|H| = 2×3` so that a concurrent triple
  is a perfect matching. Singular and note-sized — not a Mathieu tower.

---

## 4. Explored and pruned as dead

**Projective / odd-plane** (do not restart without new premises): single fixed involution (killed by
exhaustive tests); play-closed symmetric strategy family (dead q≥11); naive parity (breaks q=11);
`bad = o(q²)` (refuted q=17, 152/157); static feature dictionary (null); size-4
mirror-certificate compression (zero hits); mixed-column mod-3 law (refuted at q=23); primary
composite mirror (PG(4,3) fails the seed obligation); **conic ⊕ zone Grundy decomposition —
empirically FALSE** (the obstruction is a *coupled* invariant, not a disjunctive sum);
reservoir → Hall/matching transfer (dead below q=38); finite type → value table for on-conic
children (119 shared configs flip value across q); static config→value mechanisms — group-side,
completion-poset, envelope/algebraic, and the dynamic Ψ-trajectory
discriminator — all refuted; q-blind finite-state reply lookup (six forced q=17/19
conflicts) and every deterministic argmin selector tested; typicality/genericity and
protocol-smoothing proofs (closed by theorem); harmonic/design identity for the on-conic value
function (spectral mass migrates to the TOP Johnson components as q grows); the reservoir
truncation as a hidden discriminator (it masks a deterministic `(q,ply)` drift,
reply-invariant by proof); PGL center-triangle invariants for the third-intruder transition
(the missing coordinate is the labelled live-cell embedding); stabilizer-specialness ⇒ P
and ALL completion-automorphism capacity families (≤ 838 supply); product-point secant
selectors; the kill-set-sorted top-k ≤ 4 reply rule (exact at the q=19 root, 11 exact failures
at q=23); and — proved impossible in the program's whole feature space — every *pointwise*
value-blind reply selector. The conic-involution **Schreier catalogue is a boundary evaluator, not a
forcing engine** — the escape crux leaves the small-subgroup regime immediately (children generic,
full PSL/PGL), so exact small-subgroup nimbers cannot drive the induction and the route survives
only as abundance-first counting. Coarsest-bisimulation quotients grow across every measured point (29 at
q=11 → 65 at q=13), leaving a bounded raw-state automaton unsupported but **not excluded**.

**Corrected rather than closed:** the conjectured elliptic `Q⁻` mirror *exclusion* was **false** — a
uniform nonsplit block mirror preserves a standard elliptic form in every even vector dimension, so
the family it would have ruled out is a genuine P family (§3). It sits here because the failure mode
is the lesson: a negative believed on a plausible reduction, overturned only by formalizing it.

**Spin-off portfolio.** No second instance of *deep holes = the rational points of a named variety*
— closed structurally, not by exhaustion; the dual-variety conjecture is a no-go (q=19
counterexample + `k=4` impossibility, and the published stratification subsumes it); the `q=23`
octad analogue of the hexad theorem is dead by the mechanism's own reduction (it needs `|H| = 2×3`);
the internal-conic route yields passant-join clique numbers 4 and 3, so no six-set exists. The
deep-holes family runs through the **k-tower, not through p**. A bounded literature audit closes the
**Reed–Muller residual**: no source identifies an RM / generalized-RM / projective-RM deep-hole locus
with a named variety's rational points — the closest genuine predecessor is `RM(1,m)` deep holes =
bent functions for even `m`, an exact description by a named combinatorial class, not a variety
equality. The audit is a bounded negative, not a priority certificate; a bare "first connection
between deep holes and geometry" would still be **false**.

**The even-field rank program (`ρ_𝒞` beyond q=16) — closed negative, and the failure mode is the
finding.** The q=16 anatomy is fully classified (2,633 leaves in 62 cells; no equality cell; minimum
scaled defect 224 at rank five; full rank starting only at 256; no cell mixing ranks five and six —
a finite separation, *not* a field-uniform criterion). At q=64 a full census is rejected by a
rigorous `>10¹⁸` twelve-arc class lower bound, and all three preregistered symmetry mechanisms fail:
Baer (`|U| = 860..949`), the order-13 nonsplit torus (`|U| = 1041`, and the conic **nucleus** is
uncovered in every one of the 310 arcs, so it fails before any rank argument), and split-`Z₃`
(best-checked `|U| = 805`, one- and two-orbit locally optimal). All miss the required `|U| ≤ 65` by
hundreds. **Their primary failure is not an avoiding quadratic or a new rank type — it is that their
secants leave hundreds of points uncovered.** Only the preregistered bounded mechanisms are closed;
no infinite even-field theorem is claimed either way, and the split-`Z₃` record is heuristic, not a
family exclusion. The dependent polarity/rank-stability inverse theorem is consequently **dormant on
an unmet gate** — no stable cross-cell feature exists to invert.

**Repair ports.** Naive same-radius deletion–contraction (two explicit binary witnesses; 5,103
exhaustive cases); any finite radius/width-bounded transfer alphabet (unbounded binary triangle
relays at radius two, width two — and the disproof discards the counts, so it is not a
count-unboundedness argument); strong multiplicativity for the `GF(9)` holonomy classes (the
criterion factors through the quadratic Veronese matroid and is uniformly `U(3,4)`, so **no**
realization can fix it — closed for every dealer). Downgraded rather than killed: the
functional-cost parameter `λ_I` is definitionally the classical coset-leader / syndrome weight;
coefficient values are arbitrary gauge under a kernel-checked rescaling theorem, so no
minimum-access or minimum-bandwidth claim follows from them.

**Clebsch, self-inflicted.** "The Clebsch class is the unique one whose uncovered set is an
irreducible curve's rational point set" — **false**, three counterexample classes (quartic, quintic,
sextic); replaced by the sharper and cheaper *unique class whose uncovered set lies on any cubic*.
"Chirality is the coarsest equivariant selection rule" — **false**; list size five is the equivariant
floor and is attained. The Paley-biplane structure on the two hexagon systems is **Edge 1956 §32**,
pointing at Klein 1879 — the computation stands, but only λ and a modern name were added.

**Queens:** SG component decomposition for n=16 (tail 97–100% single-component); modular/twin
reduction (0% at pc≥13); DFS tail parallelization (transposition-saturated); K=17 dense (negative;
W_K node-cut lever exhausted at K=16, u128 ceiling); ply-windowed BuRR retrograde (forfeits α-β);
SMT scheduling / PGO past +2.6% / getK vectorization / warm-restart / degree-sort (wash-to-negative).
**"Hard floor" claims are wrong** — the default n=16 solve runs **13.43s**, well under prior floor
estimates, which were measurement artifacts of a memory-degraded box.

**Sum-free:** **socle reduction `G(G)=G(G[6])` — FALSE** (`Z₃²×Z₇ = P` while `G[6]=Z₃²=N`, two
independent solvers; the coprime factor's *size* flips the outcome); socle reduction is not a mirror;
twisted-`ρ` mirror, combined B+negation, bounded-defect, automorphism pairing, static F₃-color
monovariant — all fail off pure `F₃ʳ`.

**Node-Kayles:** trees bounded-state DP (unbounded context classes); nimber-transfer-matrix
periodicity (infinite state); budget conjecture `d=1 ⇒ G≤1` (refuted at n=10, G=3); capacity-`c`
mirror lift for `c ≥ 3` (genuine counterexample in `PG(2,q)`).

---

## 5. The frontier

**Primary open problem — the odd projective-plane kernel:** prove `PG(2,q)` is P for every **odd
`q`**. Evidence says this is **not** another static mirror. The live route is a reduction chain,
Lean-anchored at both ends:

```
frame reduction  (PG(2,q)=P ⟺ a single 4-cap frame is P; Lean)
  → residual q×q grid game  (affine caps + one point per burned row/column)
  → size-3 escape crux  (each size-3 residual has exactly q²−9q+21 legal size-4 children; Lean)
  → conic localization  (size-3 + burned dirs = a 5-arc ⇒ unique conic)
  → intrusion / Node-Kayles / zone-steering
```

- Equivalence **`PG(2,q)=P ⟺ OddEscapeStatement`** proved **both directions** in Lean
  (`TrapConverse`) — a found residual trap is now a Lean-certifiable projective counterexample.
- **(ON)** — every size-3 residual has a P-valued **on-conic** size-4 child — verified through
  q=23, and now through **q=25 (full on-conic census complete):** all 28 full-`PGL(2,25)` buckets
  are P, so `min-witness(25) = q−4 = 21` (full, not partial) and q=25 joins the non-depleted set
  `{5,7,9,13,19,23,25}`.  The `2 → 1` knife-edge slide across the two depleted orders `{11,17}`
  **rebounds fully** rather than sliding toward 0.  The depleted set is still exactly `{11,17}` and
  **no residue of `q` predicts it** (mod 3 and mod 6 both fail); q=17's instance is proved (the
  capacity lemma). The open arithmetic question — which orders beyond `{11,17}` deplete at all — is
  decidable only at the next genuinely depleted order, whose first direct test is a **q=29 census**
  (~42 on-conic buckets, ~16 GB / ~15–25 h single-core; a real, gated campaign with no cheap
  shortcut, since no arithmetic invariant fits `{11,17}`).
- **Value-blind (ON) selector — the smallest-orbit anchor.** On-conic child values are
  `Stab(frame)`-invariant, so the `q−4` children split into stabilizer orbits, and **the smallest
  orbit is P in every tested class** (q=11/13/17/19: 8/8, 12/12, 21/21, 27/27; no frame-fixed
  on-conic point is ever N). At the depleted orders the smallest orbit is unique, so this is a single
  uniform value-blind existence witness with **no separate exception layer** — the most symmetric
  completion (largest point-stabilizer) is the forced P child. It strictly generalizes the earlier
  max-incidence secant `L(A)` selector. The obvious mechanism ("P ⟺ the point-stabilizer carries a
  mirror involution") is **refuted** — it inverts across `{11,17}` — so the anchor is a *selector*
  that tells the reply-strategy machinery which child to certify, not a symmetry proof of P; the
  winning P-certificate is adaptive, never a pairing.
- **Amortized ledger — the surviving lever.** Every *pointwise* value-blind reply selector is now
  proved impossible in the program's feature space (a feature-completeness wall), which re-weights
  the whole program onto an amortized potential. The conic ledger
  `6·defect_components − 4·intruders − 2·[conic_xor=0]` is now **proved root-peak-bounded at all
  depths for every odd `q`** — the apparent "debt growth" was a reservoir-bookkeeping artifact, and
  the conic ledger itself carries zero debt. The sharpest **open** lemma is a value-blind two-stage
  packet/absorption theorem: choose the maximum (`min d`) pencil line, then all centers through the
  fourth-lowest off-conic support — every such packet has `≥3` P centers, while non-maximum controls
  at q=17 fail 1332/1344; maximum pencils satisfy computed `Ncenters ≤ q−8` through q=19 (tight at
  q=17), and the q=11 knife-edge P centers realize exactly four perfect-matching reply-graph types.
- **Abundance, not selection — the newest structural route.** The conic bulk *is* the induced
  Schreier graph of `H_S = ⟨σ_x : x ∈ S⟩ ≤ PGL(2,q)`, so its Node-Kayles value is set by the subgroup
  type of `H_S`, and the exact value catalogue is proved and independently verified from field
  geometry (two centres fully soluble; self-polar `V₄ → K₄`-unions; `D₈ → M₈ ⊔ K₂`; the `S₄` classes;
  `A₄` cannot occur). That catalogue turned out to be a **boundary evaluator, not a forcing engine**
  (§4), which redirected the route to abundance: `S₄`-rooted escaping fourth centres are conic-only-P
  at density `≈0.13` (min over classes, verified two ways), and the target is a counting theorem
  `#{y : 𝒢 = 0} ≥ c·q²`. The pairing/mirror mechanism is ruled out here — an fpf-involution residual
  covers only a minority — so the bound **must be Grundy-arithmetic**, with decomposition plus
  Weil/character-sum equidistribution the live candidate. Two gaps remain even given the density:
  transferring an off-conic abundance result to an on-conic (ON) child needs a separate exchange
  lemma, and the open sub-lemma is one-sided — a **single** dim-2 constructible value-0 certificate
  would do, where every certificate known is a homography fixed locus, i.e. dim 1 = Θ(q).
- For **q ≥ 23** the live conic cannot be emptied at the two-ply layer (depletion ladder
  `live_on ≥ q − (t²+5t+5)`); one bucket (`1,3,4,9`) verified xor-zero-maintainable through one
  further coupled move (28,646/28,646 obligations). Termination not proved.
- **Even-dimensional odd-`q` (`PG(2m,q)`, m≥2) now has its first direct outcome:** **`PG(4,3) = P`**
  exactly solved in 3.7 s / 25,258 orbit-canon memo states, with independent
  move-order/canonicalization cross-checks. The uniform family remains open, and no second board
  in it has been solved.
- Prize: eventual uniform proof ~35–45%. The q=25 unblind the upper half was contingent on is now
  **resolved all-P**, leaving the proof resting on the amortized-ledger / packet-absorption lever, the
  abundance route, and the value-blind smallest-orbit anchor; the next empirical dial is the gated
  q=29 census. The prize is no longer the portfolio's load-bearing bet — the publication track (§8)
  is independent of it, and the kernel would land there as the flagship's open-frontier section
  either way.

**Arcs — the `O(√q)` construction problem.** The portfolio's other genuinely open program, and the
one with the highest ceiling: construct `𝒞`-complete arcs of size `O(√q)`, or prove an
infinite-family obstruction. It is not a release gate for any manuscript; it is the next theorem.
The shape of the difficulty is now sharp, and it is **not the one expected**:

- **Arc legality is solved at linear size.** Two parallel subfield parabolas form a uniform
  conic-disjoint `2s`-arc, and adding a repair layer yields a conic-disjoint arc of size
  `11s/840 − O(√s)` along every `s = 8^m` with `m` odd — proved via `S₅ × C₂ × C₂` monodromy,
  Chebotarev, and a greedy bound on a collision graph of maximum degree six. This is the program's
  first infinite-family positive-density result.
- **Coverage is what fails, and this inverts the original working assumption.** The lesson stated
  plainly: **saturation is the prerequisite bottleneck and quadratic evaluation rank is downstream.**
- **What is closed.** Arcs inside a single Baer subplane are never conic-complete for `s ≥ 3` (an
  infinite-family mechanism obstruction: they leave `(s²−s)²/2` points uncovered against an ambient
  conic of at most `s²+1` points). A Kloosterman/Weil bound kills every full-domain `GF(8)`-coefficient
  scalar extension for all `s ≥ 16` — `GF(8)` is the unique escape. Partial domains then die too:
  singleton forcing sends `105 | m`, and on that subtower the residue hypergraph is empty (68 of 72
  hyperedges). And **generic quadratic repair coefficients are closed** — the joint monodromy group
  is a full wreath product, leaving a density `≈ 0.0382` missed by *every* chord class, so even the
  complete repair layer is not affine-complete and thinning cannot help.
- **The live signal.** Twelve genuinely nonlinear repair layers at `s = 8` give `3s = 24` arcs whose
  nineteen uncovered points all lie on the line at infinity — hence **complete affine arcs**,
  extending to complete 26-arcs disjoint from the conic. A uniform characteristic-two version with
  the same three-layer coverage would give `3s+2` and **solve the problem on an infinite square-order
  sequence**. Proved only at `s = 8`.
- **Still open:** coefficient families that vary with the field order, nonquadratic repair graphs,
  and other Baer-transversal designs. What is closed is the observed fixed-coefficient mechanism, not
  the problem.

**Queens:** exact **G(18)** (the nimber; outcome already settled). ~300–500B nodes, ~1.5–2 days per
ascending-`k` round, **no checkpoint/resume**; policy is `k=1` first (~55% one-shot). Further out:
n=20 outcome (conjectured first, witness (9,9)); nimbers past n=17.

**Sum-free:** the abelian slice **`s₂ ≤ 1 ∧ r₃ ≥ 2`** (never occurs in `Z_n`); conjecture
`Z₃²×Z_p = N` iff `p=5` (verified `p=5→N`, `p=7→P`; `p ≥ 11` compute-infeasible).

**Node-Kayles:** Paley `p ≡ 5 mod 8 ⇒ G=1` (needs Weil/character-sum, not a mirror); 3×N-strip
periodicity (A316632, extended to n=22); Node-Kayles on trees (decades-open).

---

## 6. Tools built

**Rust crate `othello`** (Makefile, znver5 + mold):
- **`othello`** — engine ladder minimax → alphabeta → ordered → **strong** (native PVS + iterative
  deepening + hash-move TT + exact endgame solver) → **strong+** (stronger eval, changes value) →
  **strong++** (adds Multi-ProbCut forward pruning). Bitboard core (Kogge-Stone fills), black-centred
  values (sound TT over the whole game DAG).
- **`queens`** — solver lineage **naive → iso-flat → iso-window → iso-dense** (the `W_K`/`getK`
  Node-Kayles leaf evaluator resolves pc≤K positions directly from complete tables W0..W8 via a
  BMI2-`pext` sweep — no TT probe; n=16 in **13.43s / 178.5M nodes**), plus a heap-sum **nimber
  engine**, a proof-number solver, and HyperLogLog distinct-count sizing. Lockless flat
  `Box<[AtomicU64]>` TT (55-bit fingerprint, huge-pages / `MADV_COLLAPSE`) + a **BuRR** (Bumped
  Ribbon Retrieval) succinct value store (~1.1 bit/key, validated exact on 2B+ keys).
- Micro-benches: `canon_bench`, `iso_key_bench`, `dense_*_bench`, `w9_purity_bench`, etc.

**`gridcap`** (standalone `rustc` solver) — the PG(2,q)
grid-cap engine and host of the **S4 memo-dump / query / mining toolchain**: `s4dump`/`s4gdump`
(P/N and exact `u8` **Grundy** raw dumps, 128-bit **PGL(2,q)-quotiented canonical key**), `s4freeze`
(**BuRR used *lossily*** as a value store — accepted false positives, since the consumer is a
conjecture-miner, not a player; a genuinely fresh CGT move), `s4query` (line-protocol shell:
`state`/`moves`/`play`/`pop`/`replies`), `s4mine`/`s4xormine` (feature + targeted Node-Kayles-xor
reply miners), `s4gcheck`/`s4gmeasure`/`s4gdistill`/`s4gremote` (Grundy validation, strategy-freedom,
remoteness), `s4bucketlist`, **`s4arena`** (16-byte-arena bucket labeling — the q=25 census
engine), `s4potential`/`s4potentialprobe` (Ψ obligation extraction/replay), `s4triple`
(2→3-intruder transition miner). Plus `escape`/`esc`/`feat`/`cert`/`certcheck`/`mir`/`resym`.
A companion analysis-script layer covers the Ψ LP fit, reply-automaton quotients, `f_q`
spectral decomposition, line-pencil/fan-orbit/concurrence verifiers, off-conic margins, and kill-set
top-k replay.

**Sum-free solvers:** Rust (`sumfree.rs` cyclic Grundy; `capset2/5.rs` u128/256-bit AGL-canonical),
Go (`sumfree.go` full-`Aut(G)` negamax; `sumfree_par.go` sharded-parallel + pairing verifier;
`grundy.go` disjunctive-sum **nimber engine** that solved `Z₃²×Z₇=∗0`), Python cross-checks.
Node-Kayles: Cayley sweep/cert solvers + a fast octal-game engine (`octal.c`).

**Lean 4 layer** — see §7. **Harnesses & analysis:** a canonical interleaved A/B benchmark harness
(`cyc/node` metric, OOM-safe TT), a PCA/decision-tree miner over the S4 logs (source of the
conic-depletion bounds), a raw-dump soundness-intersection checker, border-signature mining passes,
geometry probes (mirror harvest, polar-space and Segre-product Nofil builders), and the coding/MDS
spin-off replay scripts (PGL-orbit LRC seed, twisted-cubic transversal gate, Frobenius-marked
arrangement) — each committed with a sha256 for rerun-from-tracked-copy discipline. A pre-commit hook
auto-rustfmts and gates on `make clippy -D warnings`. Committed artifacts: the per-`q` P-certificates
(q=5..19), reproducibility datasets, and a sum-free/cap paper skeleton.

**Paper checkers** — every manuscript ships standalone verifiers that are independent of Lean *and*
of the manuscript's own computation. The `clebsch` deck covers rigidity, both gap censuses,
small-field uniqueness, code automorphisms/chirality, decoding, the dual/Mathieu/ten-arc/q=19 side
results, the low-degree-locus census, and the `k ≤ 7` finite leaves, plus a tracked Singular replay
for the companion-curve geometry; `arcs` ships an exhaustive `PG(2,16)` eight-arc classifier.
**Manifest discipline:** a computation is evidence only if `git ls-files --error-unmatch` proves its
script is tracked and the manifest records path, blob/SHA-256, exact command, and expected output.
Untracked or ad-hoc artifacts are not evidence — a rule adopted after audits found cited
computations that existed nowhere durable.

**Lean build hygiene** is itself engineered, and has grown into a tool layer rather than a set of
rules. Generated certificate builds fan out heavyweight workers that will OOM the box; the cap is
chosen by *measuring* the heaviest representative leaf's peak RSS, not from core count, and a shared
checker in the closure must be built serially first because the budget is
`checker_peak + (N−1) × heaviest_sibling`, not an average. Staleness is probed by content traces
(`lake build --no-build`), never mtimes; restarts are gated by a trace-validated sentinel guard,
since an existing olean may belong to an older import closure. The forcing case is real: one
alternate-orbit certificate is sharded into 1,036 transport modules, 1,071 dispatch leaves, and 7,044
canonical class links **because a combined elaboration exceeded the safe memory envelope**.

What exists now: a guarded single-file elaborator; an **unattended build queue** over explicit
targets with a `flock`-based ownership lock acquired *before* the quiet check (the seed script
checked for a quiet tree and then launched, holding nothing in between, so two runners could both see
quiet and both start — the double-booked-RAM case the sizing rule cannot survive); liveness decided
from the lock rather than a PID, so a run killed by the OOM reaper reports `abandoned` rather than a
stale `running`, and the check survives a sandbox whose PID namespace hides host processes; atomic
temp-`fsync`-rename state writes so a reader never sees a torn status; versioned **measured**
resource profiles; and a guarded `lake pack`. Resumption needs no bookkeeping — `--no-build` skips
whatever is trace-current. A newer path replaces process detachment with **systemd-managed transient
services**, on the principle that three authorities stay separate and none impersonates another:
systemd knows whether the process was created, is alive, and how it exited; the queue knows
lock/quiet/build/aggregate phase; abnormal death is *external evidence*, never a forged canonical
state. Notification is at-least-once with a stable dedup ID derived from immutable input — global
exactly-once was assessed as impossible without a durable outbox and consumer acknowledgement, and
was rejected rather than approximated. **The standing caveat is load-bearing: no real Lean target has
yet run through this tooling.** Every path is pinned by hermetic tests with stubbed `nix`/`lake`/
`choom`/`pgrep`, but real integration is unproven, and a quiet `pgrep` is not proof of an idle tree.

---

## 7. Lean formalization ledger

**Trust posture:** every terminal theorem's `#print axioms` is exactly `[propext,
Classical.choice, Quot.sound]` — **no `sorry`, no `native_decide`, no custom axioms;
kernel-complete.** Certificate cap-legality is checked by the **Lean kernel** (`decide` /
`checkCap_sound`), not `native_decide` and not trusted.

Namespaces: **CapGame** (finite build-game kernel + affine cap theorem + reusable mirror
lemmas), **ProjectiveCap** (the flagship — Binary / Elliptic / Hyperbolic / PolarSegre mirrors, the
rank-3 grid model, the `TrapConverse` escape reduction, per-`q` certificate assemblies
`CertData/Q5,Q7,Q11,Q13`), **Sumfree** (mod-6, abelian rank-count criterion, `F₃ⁿ`, `Z₂×V`),
**NodeKayles** (`getK` recurrence + Grundy + double-encoding closure, `no sorry` throughout),
**Queens** (queen board ↦ `NodeKayles.Graph` + n=18/n=20 certificate wrappers, sound *given* a
certificate).

Four further namespaces formalize the §3 spin-off portfolio, and it is now the **larger half of the
development**:

- **FiniteGeom** — the shared base: Singleton bound and MDS predicate, Reed–Solomon codes MDS,
  dual/parity-check characterization, moment-curve/NRC general position and hyperplane-section
  distance, the hypergraph matching/transversal layer (`ν ≤ τ`, `τ ≤ p·ν`), the completion-distance
  identity `δ_x = τ` with its weighted/multi-insertion/clutter/persistence variants, and the
  `BaerCompletion/` pair-extension spine.
- **RelativeConicArcs** — the largest library: the defect identity and corollaries, conic
  normalization, the asymptotic additive bound, averaging transfer, the char-2 nucleus constraints,
  certificate soundness, the evaluation obstruction/dichotomy, the arc–MDS syndrome dictionary, the
  exhaustive `PG(2,16)` eight-arc quadratic-avoidance theorem with `ρ_𝒞(16) = 9`, the q=11
  coding/deep-hole/extension-complex package, and the whole `Q25` profile ladder up to the uniform
  pair-extension theorem.
- **RepairCodes** — the concatenation-transfer lemma, the trace-dual bridge, exact cubic/axis repair
  invariants, both projective and affine seed lifts, and the two asymptotic families.
- **DihedralSchreier** — the dihedral reduction and `V₄ → K₄` core.

**Certificate legality is kernel-checked** (`decide` / `checkCap_sound`), never `native_decide`; the
one historical `native_decide` exception (`KleinFourBridge.explicit_pairProducts`) is closed. Finite
enumerations (queens, `S₄`/`A₅` nimbers, `ρ_𝒞` values) follow the `getK` pattern — a Lean-proved
recurrence plus a differential-tested reproducible solver — rather than entering the trust base
directly.

**The formalization backlog is the critical path**, because the release gate below makes it so.

**Lean-open:** odd planes `q=3,9,17,19,23` (q=9 conditional on `IntruderTerminalReplyStatement`); the
**uniform** odd-plane `OddEscapeStatement` (only proved per-`q` via certificates — the intrusion
reductions carry explicit WARNINGs that their no-intrusion hypotheses are *false* for `q ≥ 11`); the
q=17/q=19 generated-cert path (blocked on a `maxRecDepth` refactor); and `ContinuationRigidity`
(planned, not built).

**The `clebsch` Lean layer resolved into a clean split: the geometry is closed, the group actions are
not, and neither blocks release.** Closed and kernel-checked with standard axioms only: the chord
defect algebra and family formula, the Brianchon/Petersen ledger, the small-field and why-11 leaves
(including the q=9 Sylvester clique bound via a proper six-colouring rather than a graph-library
answer), the `q−5` line lemma with its one-factorization and prism arguments, the projective
`A₅` point orbits, the decoding synthesis, and the `|U(A)| + |Brianchon(A)| = 22` bridge. Still
missing: the projective `A₅` *support* action, the full monomial coefficient equivariance and its
chirality decoders, and the affine stabilizer/orbit infrastructure — with an explicit
guard that this work must not be disguised as a final `decide` after the group action has been
assumed. **Two axioms, deliberately**: Dye's ten-Brianchon bound and its equality classification, in
a single named module with an audited dependency split (the `u + c = 22` bridge depends on neither).
No exact formalization of Dye exists in the pinned mathlib tree or in any public Lean/Rocq/Isabelle
archive — the Rocq geometry archive has incidence planes, duality, Desargues, matroids, but no
conic/Brianchon/Clebsch layer — so the choice was between importing two precisely named statements
and starting a separate substantial formal-geometry project. The `A₃`/`H₃` synthesis is being closed
under a hard **compactness gate**: reusable definitions and short counting only, and if a subclaim
needs a large generated case-split tree, stop, record the obstruction and its estimated size, and
leave the manuscript's computer-assisted label intact.

**One standing adequacy caveat:** mathlib `v4.32` dropped `SetTheory/Game/`, so the game-outcome
semantics (`win`/`grundy`) are self-contained and not yet anchored to a cited `Impartial`/
`grundyValue`. Adequacy for the game papers rests on the standard-recurrence argument, literature
values, and differential tests until `CombinatorialGames` bumps. The kernel is kept deliberately tiny
so it stays inspectable — a better answer than waiting.

---

## 8. The publication track

The deliverable is no longer "the odd-plane prize, de-risked into stepping stones." A packaging review
resolved the whole body of work into **seven papers in ship order + two OEIS entries**, staged under
`papers/` with per-paper status maps. Ship order is set by *formalization-to-full-trust distance*,
adjusted for two dependencies — not by which manuscript is most finished.

| # | Paper                                                | Lead                                                            | State                                                |
|---|------------------------------------------------------|-----------------------------------------------------------------|------------------------------------------------------|
| 1 | Games flagship — cap/Nofil outcome classes           | the classification **with its exact method boundary**           | core P-theorems Lean; projective section unwritten   |
| 2 | Dihedral Schreier Node-Kayles                        | exact nimbers for an explicit infinite family                   | draft near-complete; owes `Φ_T`, ½-density, `D₂ₘ`    |
| 3 | Arcs complete outside a conic                        | the defect identity + additive-3/2 refinement + verified values | **no mathematical gate left**; archive identity only |
| 4 | The Clebsch hexagon code                             | the rigidity TFAE                                               | manuscript + PDF + Lean; artifact release only       |
| 5 | Complete repair hypergraphs (twisted-cubic–axis LRC) | the certified `[19,4,8]₉` seed + exact row transfer             | manuscript + Lean complete; specialist audit left    |
| 6 | Frobenius-equivariant pair extension of eight-arcs   | every invariant eight-arc in `PG(2,25)` pair-extends            | focused source + clean PDF + Lean; closeout done     |
| 7 | Continuation-graph rigidity (N1 only)                | `Aut(frame graph)` = ambient semilinear group, `q ≥ 13`         | theorem-package plan; hardest formalization          |

Papers 3 and 4 now carry their final titles — *Arcs complete outside a prescribed conic: an exact
defect identity and `ρ_𝒞(16) = 9`* and *The Clebsch hexagon code: rigidity from a conic deep-hole
locus* — each leading with the theorem rather than the topic. Paper 5's venue is stated as DCC / FFA,
explicitly **not** IEEE-TIT. A `lean-proof-engineering-at-scale`
methods paper is registered as an idea and deliberately kept **outside** the mathematical ship order;
its evidence base is the measured build failures and the tooling above, and any novelty claim there
needs its own literature audit.

**Papers 3, 4, 5, and 6 are all past their mathematical gates. Nothing has shipped.** What remains for
each is artifact-release plumbing — a citable archive identifier, an immutable release, an external
citation-chain review — which means the shared blocker below is now the binding constraint on the whole
front half of the portfolio, not a packaging chore.

**The one dependency, downgraded.** `3 → 4` was recorded as a *hard* dependency; it is now a
**publication-allocation ruling, not a mathematical one** — `clebsch` reproves the identification, cites
`arcs` for provenance, and depends on no unpublished companion. `1 ↔ 3` is a seam, not an ordering
constraint — both cite backwards, neither waits.

**Where the next theorem is not.** `arcs` is assessed a mature **strong-A** specialist paper, and the
route to A+ was specific: a second theorem *mathematically inseparable* from the defect identity, which
would have completed the chain `defect bound → bounded candidate cells → uncovered-locus geometry →
quadratic-rank obstruction → even-field conclusion` and answered the most serious significance
criticism. The even-field program was that route, and it **closed negative** (§4). The chain does not
exist, the identified A+ route is spent, and the decision rule was held rather than bent — the negative
stayed in the discovery record instead of being written up as manuscript weight. Isolated further
values of `ρ_𝒞(q)` are explicitly not a substitute, and neither is migrating the Clebsch classification
across the seam.

**The seam rulings are the interesting governance.** Twice the same pattern appeared — one
computation, two readings, two papers, no ruling on who owns it, which is exactly the salami-slicing
a referee flags. Both were resolved by **splitting the reading, not the object**: `arcs` ships first
and owns the q=11 identification while `clebsch` claims only the reading (rigidity, gap, chirality,
why-11); `nofil` owns the *game* reading of the shared q=9/q=11 witnesses while `arcs` owns the
*arc/extension* reading. Neither pair co-claims; each cites the other for the gloss. A Lean directory
name is not paper ownership.

**The release gate.** Every lemma and proof is Lean-formalized to the full trust standard before its
paper is published — `sorry`-free, `#print axioms` clean (no `sorryAx`, no `native_decide`), the
formal statement *adequate* to the published claim, with a per-result trust-chain note. Each paper
prints an **adequacy appendix**: the Lean statements of its headline theorems and the definitions they
bottom out in, verbatim, so statement-adequacy becomes a refereeable object an expert clears in two
pages without touching the development. Computational enumerations are excluded from the trust base
and handled by the `getK` pattern instead.

**Writing guardrails.** The general moves here — mirror/pairing, orbit-xor, completions-as-hypergraph,
Node-Kayles = neighbourhood deletion, saturating-set = covering-code — are each *elementary*, so every
abstract must lead with the nontrivial object rather than the mechanism (the table's Lead column). Two
standing rules: **negatives that bound a published method are theorems** (the boundary negatives and
capacity-2 sharpness belong in the flagship; the wider rejected-conjecture list is logbook, not
content); and an application without at least one worked nontrivial instantiation is a **remark, never
an abstract-level contribution**.

**Prior-art posture.** Audits have repeatedly landed against us and been conceded rather than
argued around: the hexad four-orbit classification is published, so that converse closes by citation;
the `|U|` spectrum's priority was granted outright to the arc-classification school; the deep-holes =
named-variety "first" was retired from the seam; the arrangement-decoder mechanism is
Jurrius–Pellikaan's; the icosahedral geometry is Edge's and Calvo's in substance; the Paley-biplane
structure is Edge's; and the functional-cost parameter is definitionally the classical coset-leader
weight.

**The largest standing exposure is now closed, and it cost three concessions.** Both load-bearing
primary sources were obtained as page scans and read at full text. Dye 1991 supplies the
ten-Brianchon bound, the `A₅` stabilizer, and — importantly — projective **transitivity as a
ground-field statement**, which removes a suspected descent issue rather than creating one. BSW 1992
supplies the complete-exterior-set definition and Brouwer's census. Only the adjacent Giessen 1991
note stays unread, and **no claim is conditional on it**. The three concessions: priority for the
q=11 six-arc goes to **Korchmáros 1981** — a *third* prior name after Edge and BSW, reached from
chains of circles on an elliptic quadric in `PG(3,q)`, and absent from our record until the audit;
the `q < 131` verification is **Brouwer's, inside BSW 1992**, three years before the source we had
been crediting; and the same audit killed a gem-mining novelty claim outright. What **survives as
ours** is the exact covering `U(A) = C(𝔽₁₁)`: each source gives only the classical inclusion, and
neither states that every off-conic point is covered — so it ships as a manuscript synthesis, with no
separate priority claim about the finite configuration. The census also handed the manuscript a gift:
it contains a **second q=11 configuration, a Pasch** (six points on four three-point lines, hence not
an arc), which becomes a clean foil — complete exteriority plus the arc/MDS hypothesis gives the
Clebsch branch, complete exteriority alone also gives the Pasch branch. In the same field, at the
same cardinality, the classical condition does not imply the hypothesis. BSW's own conjecture that
nothing exists beyond q=31 is stated, in their words, as: *"How to prove this we have no idea."*

**The shared question underneath four of the papers.** `arcs`, `clebsch`, `repaircodes`, and `baer` are
now framed as complementary test cases of one question: *when an algebraic code invariant records a
complete incidence pattern rather than only its cardinality, what hypotheses force that pattern to be
rigid locally and transportable globally?* Prescribed-hole coverage, the Clebsch deep-hole locus,
complete repair hypergraphs, and Frobenius-pair extension are four instances. The recurring structural
shape is a defect identity of the form *ambient capacity − legal locus = visible collisions + invisible
obstructions*; the recurring method question is which computer-assisted classifications admit
invariant-theoretic replacements, with the `A₅` orbit proof as the model — retain the finite
certificate, move the explanatory burden onto character and subgroup data. The highest-value next
theorem it names is an **orbit-valued transfer statement**: hypotheses under which a bounded inner
code's complete legal-extension or repair hypergraph, *together with its automorphism-orbit labels*,
embeds faithfully into every block of a concatenated family — which would connect the local rigidity of
`arcs`/`clebsch` to the global persistence mechanism of `repaircodes`. Two brakes are stated with it:
the point is **not** to merge the manuscripts, and the agenda does not by itself license a refactor.
It is a stated direction, not active work — nothing in it is allocated.

**Extraction & DOI.** The research repo stays private; publication is by *extracting* clean
self-contained repos — a shared `FiniteGeom` public repo pinned by commit (never copied per-paper
subsets, which drift and silently invalidate the cross-paper adequacy story), then per-paper repos
pinning that tag. Zenodo ↔ GitHub-release mints versioned DOIs. **Highest-leverage first move:** stand
up that public-artifact spine, which clears the shared blocker below in one step.

**Cross-domain applications** — a shared-dependency resilience analyzer, robust experimental design, a
repair-code compiler, canonical-reconstruction and minimal-conflict engines, a proof-carrying
finite-search platform — are **parked as connections remarks** in their parent papers. Reception risk
is maximal in distant fields, so each is staked publicly at zero audit cost rather than developed. The
recurring, testable nonclaim: path-counts / entropy / disjoint-availability systematically overstate
resilience when the alternatives share hidden dependencies.

**OEIS:** **A344227** (queens nimbers) sits at rev #54 (`n ≤ 13`); a ready package extends it with
`a(14)=0, a(15)=1, a(16)=0, a(17)=2`; its lead is the **refutation** — `G(17)=2` kills the published
eventual-alternation conjecture — and it should be framed exactly that way. A sum-free `Z_n` OEIS
draft + b-file is prepared and verified absent, not submitted. Further candidates: torus-queens
nimbers, sum-free outcome indicator, Paley-game sequence, A316632 extension, and the
Möbius-ladder/dihedral-Cayley nimber sequence that falls out of the `D₂ₘ` family.

**Shared blocker.** Several deliverables want a **public code/preprint URL that does not exist** — the
repo has no public remote. The A344227 `%H` link and n=18 comment, both sequences' program links, and
any arXiv posting are all waiting on it. One public mirror or preprint unblocks them together, which
is why the extraction spine is the first move rather than a packaging chore.

---

## 9. Validation gates & reproducibility

Every result carries an independent check; nothing is trusted on a single computation.

- **Queens:** `solver_lineage_agrees` (naive / iso-flat / iso-window / iso-dense return identical
  values) + exact distinct counts (n=12 = **1,060,823**, n=14 ≈ 29.2M) + Jenrich n≤16 reproduction.
- **Othello:** cross-engine value-equivalence (minimax / alphabeta / ordered / strong compute
  identical black-centred values) + the independent grid move/flip reference + exact endgame solves
  **6 / −40 / 4**.
- **Lean:** every terminal theorem's `#print axioms` is exactly `[propext, Classical.choice,
  Quot.sound]`; certificate cap-legality is kernel-checked (`decide` / `checkCap_sound`), never
  `native_decide`.
- **Solver / census cross-checks:** exact solves are confirmed by independent move-order and
  canonicalization variants; the S4 raw memo dumps are rules-checked by an independent early-break
  proof-DAG validator (e.g. q=23: all `241,627,613` records, zero game-equation failures).
- **Spin-off computations:** every computed-exact coding/geometry result ships a replay script
  committed with its sha256; any result promoted to a paper must rerun from the tracked copy.
- **Manifest discipline:** a computation counts as evidence only when `git ls-files --error-unmatch`
  proves its script is tracked and a manifest records path, blob/SHA-256, exact command, and expected
  output. Untracked or ad-hoc artifacts are **not** evidence — adopted after audits found cited
  computations with no durable source.
- **Release gate (§8):** full Lean trust standard — `sorry`-free, axiom-clean, statement adequate to
  the claim, trust-chain note — before any paper publishes. This gate is policy, not aspiration: it
  was tested by the one finished manuscript that had zero Lean, and the ruling was to hold the gate
  and formalize rather than ship first.

**The posture that makes the rest work:** results are stated with their trust tier attached —
PROVED / COMPUTED-EXACT / LITERATURE-IMPORTED / REFUTED — and a claim never outruns its tier. Several
headline claims here have been demoted, scoped, or conceded outright on audit (§8); one claimed
*negative* was overturned by formalizing it (§4). Imported literature theorems are quarantined in
assumption modules and stay visible in the dependent results' axiom reports.
