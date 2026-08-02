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
carries a **publication portfolio alongside the open game programme**. Its original seven-paper
backbone and two OEIS entries have expanded through the Clebsch and projective Reed–Solomon work and
include a quantum-information branch on MDS–CSS AME states, local-unitary rigidity, and transversal
Clifford groups (see §3, §7, §8). The Clebsch work is a **four-paper numbered series**: rigidity,
factorization, the passages paper *Golden descent and operator realizations of the Clebsch cubic*,
and the q13 passant-code paper. The first three released versions one and two share the title-page
identity *The Clebsch cubic: recovering, orienting, and realizing*; the q13 paper is the active new
build. The golden conference operator material is **not** a fifth numbered paper — it is a
source-development lane feeding future forward versions of the passages paper.
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
| **Geometry / coding**  | The spin-off portfolio (§3) — legality, not value | **Where the deliverables are.** Multiple papers |
| **Reed–Solomon**       | Deep holes, determinant invariants, reconstruction | **Major theorem programme.** Exact `r=3,5,6,7`; uniform high-field theory |
| **Quantum / AME**      | MDS–CSS states, LU rigidity, transversal gates    | **LU-to-LC for every stabilizer AME state.** Generic Lean core |
| **Queens**             | Non-attacking queens game + A344227 nimbers       | n=18 outcome solved; G(18) nimber open       |
| **Sum-free / cap-set** | Achievement game on abelian groups / `F₃ⁿ`        | Core theorems proved + Lean; one slice open  |
| **Node-Kayles**        | Graph/Cayley substrate for all of the above       | Outcome laws proved; classic opens remain    |
| **Othello**            | Rust port of the Python engine + endgame solver   | Stable, gate-green, effectively archived     |

The structural split is what matters: the cap thread is the *unsolved game problem*, while the
geometry/coding and Reed–Solomon threads are the *shippable mathematical output*. The latter now
form the larger body of work.

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
- **Mirror lemma, general form:** for any finite `G` and involution generating set `T`, an involution
  `w ∈ G∖T` with `wTw⁻¹ = T` forces Node-Kayles value 0 on `Cay(G,T)` — the second player mirrors by
  left multiplication. This is the abstract statement behind every pairing argument in the portfolio.

### Dihedral and polyhedral conic Schreier graphs

Node-Kayles on the fixed-point-deleted Schreier graph of a conic in `PG(2,q)`, indexed by the
subgroup of `PGL₂(q)` generated by the projection involutions at the selected off-conic points.

- **The two-point subgame — always dihedral.** Every legal *pair* of off-conic points generates
  `D₂ₘ` for **every `m ≥ 3` and either parity**, so odd `m` re-enters here after being absent from
  the triple classification. Pair templates are the cycle `C_{2m}` and the path `Pₘ`, not the
  ladders of the triple case; `𝒢(C_{2m}) = 0` for all `m ≥ 2`, so free orbits contribute nothing and
  the value collapses to `(1−δ)·𝒢(Pₘ)` with `𝒢(Pₘ)` the **Dawson's-chess sequence A002187**.
  Consequences: **odd-order dihedral is always a P-position**, and the density is **not** uniformly
  `1/2` — it is `1` for odd `m` and for even `m` at a Dawson zero, else `1/2`. This exhibits the
  earlier `1/2` density and `{0,1}`-only values as artifacts of the triple restriction. Verified over
  the conic for `q ∈ {5,…,23}` on all 241,344 tame legal pairs, zero mismatches.
- **Closed congruence laws (proved, no upper bound on `q`).** The split indicators and free-orbit
  parity are derived from `PGL₂(q)` group theory rather than observed: for `S₄`,
  `ε₂ₐ = [χ(−2)=1]`, `ε₄ = ε₂ᵦ = [χ(−1)=1]`, `ε₃ = [χ(−3)=1]`, with `S₄ ≤ PSL₂(q)` iff
  `q ≡ ±1 (mod 8)`; for `A₅`, perfectness forces `A₅ ≤ PSL₂(q)` and the free-orbit parity is
  `m₁ ≡ [χ(6)=−1] + [q≡1 (mod 5)] (mod 2)`. These yield **all ten closed board-value laws** for every
  admissible tame `q` — `S₄` with exact period 8, `A₅` with minimal moduli 120/24/15/4 — and hence
  that every nonconstant class is N with relative natural density exactly `1/2`. Dickson is cited for
  existence only; uniqueness up to conjugacy is used by no law. **Board Grundy value 2 occurs**
  (`v(2,3,3) = 2[χ(2)=−1]`, so value 2 iff `q ≡ 3,5 (mod 8)`, first at `q=5`); value 1 and value 2
  never co-occur on one field's board.
- **The `(σ,ρ)` invariant.** Sorted pair-product orders together with the common order of the six
  three-generator products is a **complete `Aut(G)`-orbit invariant**; `ρ` is well defined in any
  group, since for involutions `a,b,c` the six ordered products share a common order. It splits the
  old `A₅ (3,5,5)` signature into two 60-triple classes, distinguished conceptually by the trace-zero
  Fricke identity in the binary icosahedral group: `ρ=5` exactly when the two order-5 pair products
  are `A₅`-conjugate (geometrically the isoceles edge-axis configurations), `ρ=3` otherwise (the
  scalene ones). Both regular values are 0, so the old regular table stays numerically correct, but
  the nonregular templates differ — the regular *graph* remembers `ρ` (closed-walk counts first
  differ at length 8) while the regular *nimber* collapses it. `A₄` is **impossible** as an
  involution-generated type: its involutions generate only its normal `V₄`.
- **Two of the paper's own laws were corrected by exhaustive census.** (i) The `D_{4n}` normal form
  had assumed the reflection class always splits; when `h` is even, `PGL₂(q)` also contains a second
  `D_{4n}` conjugacy class with **all reflections nonsplit**, and for odd `d` with `h` even the two
  classes have `f` of opposite parity, so **exactly one of them is an N-position**. Of 246,000 legal
  tame triples over `q ≤ 23`, 27,528 lie in the affected class and 20,196 take a value different from
  the previously boxed formula — first case `q=7`, where the board is a single Möbius ladder of value
  1 against a predicted 0. The pair-value formula is unaffected, which is why pair-level checks were
  blind to it. (ii) In the **wild** case `p ∣ 2m` a cyclic subgroup of order divisible by `p` has
  order exactly `p`, forcing `m = p`, a unipotent rotation, a single fixed point, and a
  Borel-reducible group with no free orbit; the residual is always the path `P_p`. So wild `D₁₀` is
  an **N-position at `𝒢 = 3`**, breaking the "odd order ⇒ P-position" law, which now holds only in
  the tame case. Triples cannot be wild.
- **Past the polyhedral table: one explicit full-`PGL₂` P family.** For `q = p^e` with `p > 5` prime,
  `e` odd and `p ≡ 3, 7, 23, 27 (mod 40)`, an explicit four-centre off-conic configuration is a
  P-position — the first family crossing out of the finite small-subgroup regime into full `PGL₂`.
  The congruence is exactly the pair of character conditions `(−1/p) = −1` and `(5/p) = −1`; an earlier
  statement restricted to `p ≡ 3, 27` was **narrower than its own proof**, and the two extra residues
  differ only in the parameter count (`(p−3)/2` rather than `(p−5)/2`). The three-centre boundary below
  it is computed exactly at `q = 5, 7, 11`, where the `q=11` P-set is three `PGL₂(11)` conjugacy orbits
  and exactly one of them escapes the two known certificate families.
- **Density is conditional, and exactly one axiom says so.** The `1/2` value is *not* derivable in
  the pinned mathlib — it has qualitative Dirichlet but no prime equidistribution in arithmetic
  progressions — so it is closed behind a single quarantined `primes_equidistribute` axiom (PNT in
  AP, no Siegel–Walfisz error term, no uniformity in `m`); the `1/2` falls out by cancellation of
  `φ(8n)` and never computes it. Delivered unconditionally instead: the exact residue classification,
  coprimality, period-`8n` distinctness, and infinitude of both P- and N-class primes.

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
  `ρ_𝒞(8) = ρ_𝒞(9) = ρ_𝒞(11) = 6`, **`ρ_𝒞(13) = 8`, `ρ_𝒞(16) = 9`, `ρ_𝒞(17) = 9`,
  `ρ_𝒞(19) = 10`** — `ρ_𝒞(16)` from a checked exhaustive
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

  **Zero defect is rigid, not merely extremal.** The concurrence points of an arc canonically
  decompose the edges of `KG(k,2)` into matching cliques. Equality in the prescribed-hole defect
  identity forces those cliques to form a simple maximum-matching design represented by secant
  concurrence in one projective plane; the second index equation then determines the exact number
  of maximum-index centres and their incidence with every secant. At defect `Δ`, at most
  `m(m−1)Δ/2` Kneser edges lie in nonmaximum cliques. The six-point realization is classified
  projectively, and for every even `k ≥ 6`, zero relative defect forces
  `q ∈ {k−2, C(k−1,2), C(k−1,2)+1}`. Exact reconstruction of the arc from its ordinary uncovered
  locus, semilinear-stabilizer recovery, the matching-design theorem, and the stability bound all
  pass through the scoped `RelativeConicArcs` gate.

  **The even zero-defect spectrum is now complete, and the certificate has shrunk.** The maximum
  concurrence centres of an arc form a packing by maximum-matching cliques, and the prescribed-hole
  defect is at least the number of blocks by which that packing falls short of a full matching
  design; a packing cannot be exactly one block short, so abstract nonexistence of
  `MATCH(k, ⌊k/2⌋, 1)` gives the quantitative gap `Δ ≥ 2`. The sole non-hyperoval
  characteristic-two zero-defect candidate `(q,k) = (4096,92)` is **impossible**: conic polarity turns
  the 92 arc points into distinct involutions stabilizing one 91-point subset of the conic, either
  tangent pair generates a four-group fixing exactly its contact point, and the remaining 90 points
  cannot split into four-element orbits. That closes the even branch by a congruence rather than a
  search, and removes a Ramanujan–Nagell input from the equality proof. Separately, the exhaustive
  lower-bound checks at `q = 13,17,19` reduce to **one elementary conic obstruction** in every case
  but a single nine-arc at `q=19`, and 2,630 of the 2,633 `PG(2,16)` leaves share the same
  obstruction — three collinear uncovered points plus three noncollinear ones off that line impose
  independent conditions on quadratics with no matrix inversion. Exactly three leaves lack the
  pattern and keep one-dimensional quadratic kernels. The `q=19` residue is itself structured: the
  uncovered locus of the exceptional nine-arc is a pair of regular orbits of a projective Heisenberg
  group `C₃²` lying on distinct cubics of one semi-invariant pencil, with its nine nearest conics a
  single group orbit. The exhaustive `q=16` classification therefore survives as a much smaller
  object, not as an unexplained table.

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

  A universal chord-defect identity now subsumes the separate small-`k` counts. Its sharp moment
  bound shows that a conic-filling uncovered locus forces an explicit quadratic field-size barrier
  and `q < C(k,2)`; a passant count gives `q ≥ 2k−3`, while Hirschfeld's nucleus characterization
  excludes the even-order branch. The eight-point sieve leaves exactly `q ∈ {13,17,19}`, and a
  complete passant-edge-orbit search excludes all three — over each of `q = 13,17,19` the largest arc
  with all chords passant has size six, so the necessary condition already fails at seven points. The
  classification is therefore complete through eight points, and takes the closed form
  `U(A) = 𝒬(𝔽_q) ⟺ (k,q) = (4,5) or (6,11)`: a projective four-frame in the first case, a Clebsch
  hexagon in the second. These results strengthen the active rigidity manuscript without changing
  the classical-priority boundary around the Clebsch configuration itself.

  **A human cover theorem now supplies the window that the searches used to supply.** If a `k`-arc `A`
  disjoint from a conic `𝒞` has chords covering exactly `PG(2,q) ∖ 𝒞`, then every chord is passant
  and `C(k,2) ≥ 3(q−1)/2`, hence `q ≤ (k(k−1)+3)/3`. With the elementary passant-pencil bound
  `q ≥ 2k−3` this reconstructs the exact `k = 7,8` terminal window and identifies its two endpoint
  cases with minimum-weight supports of the passant/internal incidence code. It does **not** exclude
  the five terminal pairs — the `q=13` elliptic-scheme audit reaches only the integer bound eight,
  one short — so the terminal searches remain load-bearing rather than decorative. Its consequence
  for coding is the length-at-most-eight projective MDS statement.

  **The all-sizes theorem is the lane's high-upside open target, and it is not proved.** The goal
  is that a deep-hole locus is a full conic exactly twice ever — the four-frame over `F₅` and the
  Clebsch hexagon over `F₁₁` — for every arc size, not just `k ≤ 8`. What now exists is a
  reformulation, two size-uniform bounds, a dichotomy that lands on both known examples, and a
  complete classification over every odd field up to 43. `U(A) = C` splits into *(E)* every chord
  external to `C` and *(V)* the chords covering all `q²` points off `C`; (E) is hereditary, (V) is
  not, and the chord-moment system cannot see the difference. Even `q` dies outright at the nucleus.
  The covering LP bound uses the correct degree cap `⌊k/2⌋` and so holds for every `k`, where the
  published `q ≤ (k(k−1)+3)/3` rests on the accident `⌊k/2⌋ = 3`. The spare-external-line bound
  gives a dichotomy — either `C(k−1,2) ≥ q`, or every arc point is saturated, forcing
  `k = (q+1)/2` all-external or `k = (q+3)/2` all-internal — and **both known examples are exactly
  the two saturated types**. The saturated-external branch is now **closed uniformly**: a complete
  mapping of the cyclic square group kills every `q ≡ 1 (mod 4)` hence every odd square field;
  Segre's lemma of tangents forces sign coherence; Stickelberger half-carry profiles plus a
  base-`p` digit-weight lemma make every matching multiplication-Frobenius; and a genus-one
  character sum with Hasse leaves `q ∈ {3,7,11}`, of which `q=7` fails covering and `q=11` is the
  hexagon. The nonsaturated branch is reduced, not closed: the deleted-point direction discriminant
  factors as `(T^q − T)·E_P(T)` with `deg E_P = C(k−1,2) − q` and roots recording excess
  parallel-chord concurrences, slack zero is impossible over every odd field but the excluded
  `q=3`, slack one factors into `q = 5,9,27` (all removed by the finite classification), so
  `C(k−1,2) ≥ q+2` always; at slack two the first surviving boundary is `(q,k) = (53,12)`.

  **Why counting cannot finish it — with the measurement that says so.** For every odd prime power
  `q ≤ 43` and every `k`, the only conic-filling arcs are the two known ones; nine of the sixteen
  fields close by counting alone and seven need the conic-external arcs enumerated. Both the
  threshold size and the largest conic-external arc `m(q)` are `√(2q) + O(1)`, and which wins
  alternates with no trend — `C(m(q),2)/q` stays inside `[0.67, 1.55]` across the range. Every
  refinement of the covering bound adds `O(1)` to one side while the other drifts by `O(1)` too. A
  general proof needs `m(q) < √(2q) + O(1)`, a clique bound for a Paley-type graph on the `q²`
  points off the conic, and the measurements say that inequality is tight rather than generous — so
  it may simply be false for some `q`. That negative is the real output of the pass.

- **The q13 passant code** (`clebsch`, Paper IV) — the fourth numbered Clebsch paper, and the one
  active new build. Take the conic in `PG(2,13)`, its 78 internal points and 78 passant lines, and
  let `K` be the kernel of their incidence matrix: `K` is a binary `[78,36,12]` code whose **minimum
  words reconstruct the geometry and symmetry they came from**. Minimum distance 12 is proved with
  no support search — Segre tangent triples exclude weight eight (a cyclic 42-vertex compatibility
  graph has clique number five against a required seven-clique), the two forced weight-ten pencil
  profiles are excluded, and a dihedral weight-twelve word is constructed. All 364 minimum words
  fall into one `S₄` and three `D₂₄` projective orbits, **every** orbit spans the code, pair
  concurrence recovers passant-versus-secant join type, triple-concurrence profiles recover all six
  elliptic orbitals, the 78 all-zero-triple seven-cliques are exactly the passant incidence rows,
  and the common code/hypergraph/scheme automorphism group is exactly `PGL(2,13)`. **Priority is
  closer than earlier drafts showed:** Droms–Mellinger–Meyer introduced this same
  passant-line/internal-point parity-check code and bounded its distance, and the Ma–Liu–Tian survey
  records `(q+3)/2 ≤ d ≤ q−1`, i.e. `8 ≤ d ≤ 12` at q=13. The paper closes that interval at the top
  and adds the classification, spanning, reconstruction and symmetry results, for which no
  predecessor was located; Madison–Wu supply the dimension formula and Hollmann–Xiang the elliptic
  scheme. The proof is human-led with two green Lean surfaces beneath it — shared semantic modules
  carrying the logical spine, and a paper-owned package checking the irreducibly finite leaves in
  small auditable shards — and neither is a claim that the main theorem is machine-checked.

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

  **The syndrome locus also carries a golden orientation, and that is now a theorem rather than an
  observation.** The `10+10` split of coordinate triples is a regular two-graph, and on the frozen
  common marking its exchange is simultaneously support complementation, Gale duality and golden
  conjugation, with first surviving signed moment cubic. If `B` is either signed continuation orbital
  on the fibre-odd six-axis lattice, the triangle product `c_ijk = B_ij B_jk B_ki` **is** the
  support-orientation cubic: switching axis representatives fixes it, orbital exchange negates it,
  and the four-point two-graph identity reconstructs `B` up to switching, so the cubic line and the
  conference relation `B² = 5I` are two presentations of one integral orientation torsor. Concretely
  `det(B + diag x) = e₆ − e₄ + 5e₂ − 125 − 2C_B`, so the cubic is the sole nonsymmetric layer of the
  golden diagonal determinant pencil; pair balance is *equivalent* to `B² = 5I`, so the cubic alone
  forces the unique golden conference switching class. The cubic threefold on the augmentation
  projective four-space has exactly six singular points, all ordinary nodes forming a projective
  frame, with full projective automorphism group the outer `S₅` of order 120 — so the cubic
  reconstructs the six-axis carrier. Singular-locus completeness is structural rather than a Gröbner
  computation: the cross-golden determinant is `−C`, its trace dual is the smooth Clebsch diagonal
  cubic surface, and the Hassett–Tschinkel determinantal converse supplies exactly six ordinary
  nodes. Modulo 2 all signs coalesce and `B − I` is rank-one square-zero; the fibre-odd integral
  commutant is the conductor-two order `ℤ[√5]`, whose mod-2 fibre is a dual-number point and whose
  normalization has fibre `𝔽₄`. The twelve-point Schläfli identification fails equivariantly, but
  both objects map to the same six-axis `A₅/D₅` carrier — this construction is its twisted transitive
  two-cover, the double-six its split two-cover.

  **The terminal fields are finite proof objects rather than an unexplained table.** The q=11
  fifteen-class census is an orbit ledger — canonical representatives, stabilizers, masses summing to
  1,548, concurrence counts, chord-defect uncovered sizes, conic-intersection histograms — with
  fourteen nonsingular cubic minors replacing the non-Clebsch row reductions and the Clebsch kernels
  generated by `Q` and `QX,QY,QZ`. Over `q = 13,17,19` the passant edges split into `10/13/15`
  projective root orbits whose complete root-stabilizer extension DAGs have 604, 4,442 and 11,260
  nodes; the maximum six-arcs form `2/22/94` projective orbits with `546/50,184/395,124` labelled
  representatives, all with empty extension sets at q=17,19, and pair and triple inner distributions
  separate every orbit. This is a finite coherent compression, **not** a uniform theorem: the natural
  root-edge rational LP has optimum exactly the smaller residual pencil, hence at least `(q−3)/2`
  against a required bound of four, so that first-order dual route fails for every odd `q ≥ 13`.
  Alongside it, the associated q=13 binary tangent code has exact minimum distance `d = 12`, proved
  without a support search: Segre tangent triples exclude weight eight (after fixing one point a
  cyclic 42-vertex compatibility graph has clique number five against a required seven-clique), the
  two forced weight-ten pencil profiles are excluded, and a dihedral weight-twelve word is
  constructed. All 364 minimum words split into one `S₄` and three `D₂₄` projective orbits; pair
  concurrence recovers passant-versus-secant join type, triple-concurrence profiles recover all six
  elliptic orbitals, the 78 all-zero-triple seven-cliques are exactly the passant incidence rows, and
  the common code/hypergraph/scheme automorphism group is exactly `PGL(2,13)`.

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
  varies and the legal-count spectrum 32–47 comes entirely from overlap.

  **The extremal question is now closed over normalized rows.** Every normalized row attaining 32
  lies in the 1,600-element union of five certified minimizer orbits, so within that domain **32 is
  the exact minimum and the five orbits are the complete minimizer set**. The route is
  orbit–stabilizer without ever materializing an orbit: certified orbit sizes `200,400,400,200,400`
  against stabilizer orders `2,1,1,2,1`, pairwise disjointness, and union 1,600. The 46,056 rows
  account exactly — 39,012 contradict the payload cap, 7,020 are valid non-minimizers carrying a
  strict `≥ 33` bound, 24 are minimizers splitting `3,6,6,3,6` over the five classes in agreement
  with the orbit sizes, which are computed from an independent source. The `≥ 33` bound for the other
  1,184 classes needed no new mask generation, only a fresh threshold decide against committed masks.
  Separately the *bound* lifts semantically: `≥ 32` holds for every invariant eight-arc in `PG(2,25)`
  with exactly two fixed points, through both projective normalizations.

  **The normalization boundary has now been crossed semantically.** Every invariant eight-arc in
  `PG(2,25)` with exactly two fixed points has at least 32 alternatives, and equality holds exactly
  when some base-field collineation carries it into the certified 1,600-row union. Thus **32 is the
  exact semantic minimum and the five normalized orbits are the complete semantic extremal set, up
  to normalization**. The statement does not assert a unique normalizing collineation, enumerate or
  count the semantic arcs, or extend to other fixed-point counts, arc sizes, or fields. Mask
  cardinality remains only a lower bound away from the five equality rows.

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

  **The theory now has a general headline rather than a family headline.** For an `[n,k]` MDS code
  `C` and a target coordinate `x`, normalize every dual repair word by `y_x = 1` and let the
  radius-`r` *coefficient port* be the set of such words whose support off `x` has size at most `r`.
  It reconstructs at radius `r` when its span is `C⊥`, and the reconstruction radius is exactly
  `ρ_x(C) = k`: the span of the radius-`k` port is all of `C⊥`, and the support projection is the
  complete `k`-uniform clutter. Retaining the coefficients, not just the supports, is what makes the
  port remember the code — the Clebsch `[6,3,4]₁₁` full radius-five coefficient port reconstructs its
  inner code from a single pointed port, while its support-only clutter is the generic complete
  three-uniform hypergraph on five helpers with `(ν,τ) = (1,3)`.

  **A second infinite family.** The `d = 4`, `p = 3` nucleus `e₂` gives `[q+2, 5, q−3]_q` for every
  `q = 3^h ≥ 9`, dual distance five, exact locality four, whose small circuits are the nucleus
  together with the **harmonic quadruples forming an `S(3,4,q+1)`** — the Steiner system is what
  makes the family tractable, and at q=9 it is a `[11,5,6]₉` with nucleus row `(2,5)`.

  **A third correction, to the transfer theorem itself.** An independent read of the assembled
  manuscript found the exact transfer statement **was not exact as stated**: it omitted the all-zero
  functional sector. As repaired it assumes `|J| ≥ 2` and takes the **minimum** of the nonzero
  functional-tuple cost and the exact all-zero branch, with the threshold definition moved to precede
  the theorem that consumes it; the original proof is retained as the coarser sufficient bound. In the
  same pass a "basic invariants" dual-distance claim was found **vacuous** — under the displayed
  definition no such nonzero witness can exist, so its proof established nothing — and it was deleted
  rather than restated, and a coefficient layer described as projective tuples was corrected to
  ordinary target-normalized vectors, the ratios already being scale-invariant.

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

  **The semantics layer, and where it splits.** Truncated separator-vector response maps are
  *contextually sufficient* and compose exactly by min-sum convolution plus a least-feedback fixed
  point, which yields an explicit `f(r,w,q)·poly(n)` algorithm for radius-`r` terminal Horn closure,
  stopping core, witnesses and exact counts — **from a supplied width-`w` branch decomposition**;
  constructing the decomposition is outside the theorem, and the generic bounded-branchwidth FPT
  consequence belongs to the parse-tree literature. The raw response is sound but neither fully
  abstract nor minimal; the incoming-convolved effective response restricted to realizable inputs is
  **sound, fully abstract and minimal**, against an exact realizability characterization of truncated
  separator profiles (zero at zero, positive off zero, scale-invariant, truncated-subadditive) whose
  every instance is realized by direct-sum gadgets. The headline separation is that **exact structural
  behavior has a finite fully abstract separator control at fixed radius and width, while exact
  synchronous timing provably requires an infinite quantitative carrier.**

  **Two further exact statements, and a corrected ledger.** A represented full repair port is a
  monotone span program with **one row per helper, not one per repair circuit**; via Lehman, a
  connected `K`-representable port on `n` helpers has `mSP_K = n` and `mSP_F ≥ n+1` over any field not
  representing the matroid — an additive-one barrier, instantiated for both flagships. Rank-cutoff
  rigidity (`rank ≤ r` makes the truncated port the full port) activates that barrier, and the
  Fano/non-Fano pair gives **reciprocal** characteristic-sensitive gaps, stated as a lower bound only.
  On the quartic-nucleus family the inert-vs-span separation is exact for **every `q = 3^h ≥ 9`**
  (block-free five-set fraction `(q−7)/(q−2)`), while the dramatic one-round nucleus switch is
  **`q=9`-only** — a five-set has ten triples but must expose `q−4` points, so one-round completion is
  impossible past `q=14`; no threshold, limit law, or sharpness is claimed. Correction carried into
  the ledger: the EXIT identity is **code dimension + deficit**, not redundancy + deficit.

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

### Clebsch factorization memory and its modular sequel

The Clebsch project is no longer best described as only the rigidity of one exceptional
`[6,3,4]₁₁` code. Its selected shipping theorem now follows a single information-loss mechanism:

```
Coxeter conic phase
  → conic restriction forgets a secant pairing
  → the conic-ideal quotient remembers the symmetry-selected factorizations
  → balanced second moments recover two sheets
  → the first signed tensor memory is cubic
  → one depth profile plus its matching recovers the Clebsch parent.
```

This chain is exact. The conic-ideal ranks are `3,6,10`; all even signed moments vanish; the
weighted `1:4:6` barycentre kills degree one; and cubic survival is forced and sharp. The six depth
profiles have a conceptual `A₄ \ PGL₂(11) / A₅` double-coset derivation, and their `6 → 2` rank drop
is explained by the projective-cover quotient `P(1)^A₄ / soc(P(1))`, with Loewy layers `1|9|1`.
A separate canonical Tate two-plane exists, but the natural transfer, orbital, correlation, and
rank-flag maps do **not** identify it with the depth plane; this is a proved scope boundary.

**The ranks and the cubic are now conceptual, not computed.** One mechanism gives all three ranks:
the matching quotient is an affine connecting cocycle, its value span is `PGL₂(q)`-stable, the
Fischer summands are defining-characteristic `SL₂(q)`-modules, irreducibility forces every nonzero
top-harmonic projection to fill its summand, and in even quotient degree one apolar trace detects
the radial line. No orbit row reduction is load-bearing for `3,6,10`; the exact quotient matrices
survive as independent cross-checks. Cubic survival likewise stopped being a computation: the two
frozen configurations are reduced self-associated arithmetically Gorenstein point sets, so quadratic
recovery gives signed Gale self-duality and Cayley–Bacharach in degree two, and Hilbert symmetry
forces the cubic. A full-support hyperplane-square lemma then shortens even that, forcing the Schur
cube directly and demoting the Gorenstein route to a geometric consequence and independent check.

**Why exactly two configurations, with the hypothesis removed.** For an odd prime power `q`, take
any full `PGL₂(q)`-orbit of perfect matchings of `P¹(𝔽_q)` and its unital affine evaluation space in
the conic-ideal quotient. If quadratic products intrinsically recover a nontrivial factorization
bipartition — the perpendicular of the squared space is a line whose nonzero vectors have exactly two
level sets — then the only surviving orbits are `B₃/𝔽₇` and `H₃/𝔽₁₁`. The one-factorization property
is no longer assumed: a two-valued one-dimensional strength-two trade gives two special-projective
sheets, and the projective–trade bridge, a uniform Frobenius-digit first-wall obstruction, the
characteristic-three axis trade and an exhaustive q=9 endpoint close every sheet multiplicity
`λ > 1`, so the balanced `q+q` one-factorization split is derived. The Gorenstein pairing likewise
comes from the signed coordinate form directly — the quadratic identity makes the affine evaluation
space maximal isotropic and quotient duality supplies the perfect degree-one-by-degree-two Artinian
pairing — with the Paley cross-sheet matrix retained only as an explanatory carrier, since it misses
the radial/common-sum pair by one dimension. Radial nonvanishing for `B₃` and `H₃` is one proof
rather than two: an endpoint edge selects a unique cross-sheet matching pair, deleting it leaves a
single alternating cycle, and the common `c ↔ c⁻¹` torus normal form reduces both cycle lengths to
one Dickson recurrence.

The first paper closes by recovering the arithmetic gluing of the two golden sheets. They are the
two size-11 `PSL₂(11)` halves of one size-22 `PGL₂(11)` matching orbit; their `A₅` stabilizers meet
in `A₄`, generate `PSL₂(11)`, and the outer coset exchanges them. The perfect-code row extends to
the full-support/secant-shadow picture: parity unpuncturing gives the self-dual ternary
`[12,6,6]` code, twelve full-support points form an order-12 Hadamard matrix, and their secants
exhaust the projective minimum words. This is the paper's Hadamard–Mathieu capstone.

The sequel has a different, theorem-level spine. Its **Modular Gateway Theorem** runs

```
pointed matching geometry
  → cross-incidence code pair
  → perfect-code core
  → simple endotrivial Lagrangian
  → unique nonsplit self-dual carrier.
```

The binary Hamming row at `q=7` and ternary Golay row at `q=11` satisfy every gate. The binary
Golay row at `q=23` proves that the carrier mechanism extends while the exceptional degree-`q`
permutation-sheet bridge does not. The stronger universal Weil/theta interpretation is false:
the signed six-space is not a genuine Weil module, invariant theta parity does not detect the bit,
the proposed Maslov refinement dies at its first structural gate, and the literal Witt/Maslov
index of the central word is zero. The sequel therefore keeps the modular gateway, the
quaternion/descent/fusion mechanisms, and a separate even Hadamard/signed-gluing block, without
claiming a metaplectic roof.

Concretely, at q=11 the shared incidence kernel is a simple five-dimensional
`F₃ PSL₂(11)`-module `S`, the perfect-code layer is `1 ⊕ S`, and the ambient permutation carrier
has the canonical self-dual nonsplit flag

```
S ⊂ S+1 ⊂ M,               factors 5 | 1 | 5*.
```

The q=7 control has the parallel `3|1|3*` flag. Exact no-retraction ranks show that these
augmentations do not split; the core is Lagrangian, the invariant form is unique, and the relevant
extension class is unique. At q=23 the extended binary Golay code supplies the analogous
11-dimensional endotrivial core, but `PSL₂(23)` has no subgroup of index 23, so no degree-23
permutation action can realize the geometric sheet. This is the sharp distinction between the
carrier theorem and its exceptional rank-three geometric packaging.

There is also an exact cohomological explanation for why products remember more than fixed-base
quotients. In the equivariant hypersurface sequence, choosing a base produces a connecting cocycle
`δ(s)`; its class is nonzero and spans the relevant `H¹` for both the inner and full projective
groups in the `B₃/H₃` cases. It is already detected on a Sylow subgroup, where it is the unique
normalizer-invariant line. Homogeneous sheet lifts retain this nonsplit affine extension, whereas
fixed-base quotients have no equivariant origin; pairwise odd quotients recover linear covariance.
Thus the loss of covariance is an identified extension class, not a coordinate artifact.

**A third, deliberately small note survives a round of subtraction.** Two independent results on the
same Clebsch four-space, with no map claimed between them:

- Hitchin's degree-two incidence extension has rational square class `5J₀`, restricts to the
  constant golden torsor on the principal open `D(σ₃)`, and has an explicit golden fibre whose
  exchanger has nontrivial spinor class modulo 11.
- The degree-six zonal harmonics on the ten icosahedral face axes contain the Clebsch four-space as
  the Petersen `(−2)`-eigenspace, and the normalized spherical cubic restricts to
  `−784000/1247103 · σ₃`. The zonal Gram matrix is `K = (196I + 47J − 112A)/243` with normalized
  Gram `G = K/13` and spectrum `110/1053, 140/1053, 28/1053`; disjoint pair labels are exactly the
  geometric Petersen adjacencies. The factor 13 is not a fudge — `K` is the reproducing kernel and
  `G` is the normalized Gram matrix, an addition-theorem statement.

**Both of that note's open gaps have since closed, and the two results are joined.** The corrected
arithmetic statement has global square class `5J₀`, and the chart factorization is scheme-theoretic
rather than a function-field identity: the quadratic involution splits the pullback into a global
Stein algebra `O ⊕ O(−3)` with multiplication `z² = 5J₀`, the fixed Clebsch chart lives over
`ℚ(√5)`, and the displayed golden configurations are the complete reduced local fibre. On top of
that, the arithmetic and harmonic cubics are two realizations of **one oriented Clebsch coordinate
line**: a chosen sheet of Hitchin's incidence cover on the golden Clebsch chart determines the pair
`([C], [Z_C])` — the switching class of the order-six golden conference matrix and its oriented
triangle cubic, the same orientation torsor the syndrome locus produces — and also fixes the linear
lift of the projective chart, with the primitive pair-sum map `β(y)_{ij} = y_i + y_j` on `Σy = 0`
transporting the sign to the harmonic side.

The bridge is **relative, and the boundary is the interesting part**. It is stated with respect to a
marked datum — ordered golden-axis representatives, representative-lattice orientation, five
plane-triple labels, a normalized linear chart lift, and compatible Petersen two-subset labels — and
the selected sheet is explicitly *not* claimed to reconstruct any of them. The ambiguity ledger is
complete: axis switching is quotiented, axis relabelling transports the conference matrix and cubic
variables, lattice-orientation reversal changes nothing used, one-sided five-label relabelling
changes the marked datum, chart scaling is pinned by `q₁ = xyz`, golden Galois conjugation negates
the conference matrix, triangle cubic and chart lift after transport by the exchanger, and deck
exchange negates the odd generator with its attached relative source. The full geometric integral
localization remains unspecified; pullback across `σ₃ = 0` and the all-degree face-axis channels stay
open; and every functorial shadow of the conference operator belongs to the separate golden-operator
manuscript below rather than here.

The remaining headline Clebsch-facing results and censuses are:

- **Arithmetic phase and intrinsic bit.** The H₃/A₅ configuration has an all-odd-field arithmetic
  phase: at q=11 a non-GRS parent has a full-conic GRS child. The associated translation scheme is
  a primitive rank-eight Fourier-self-dual `A₅` fission with `P=Q`; its full affine automorphism
  group preserves an intrinsic unordered `10+10` chirality torsor. The two golden sheets fuse under
  `PGL₂(11)` into a rank-16 refinement with a signed Fourier sector. Integral golden descent
  separates split, inert, and ramified primes and identifies the outer phase with the discriminant
  line of norm 5: at the ramified prime the line becomes a branch-cotangent line, while at 2 only
  its sign readout collapses.

- **Code, quantum, and cubic readouts.** The Clebsch `AME(6,11)` state is separated under both LC
  and LU from every six-point GRS class, while the two golden Clebsch states become LC/LU-equivalent
  after a party permutation; the 60 transports form a noncanonical `A₅`–`A₅` bitorsor. The
  Clebsch-cubic double-six exchange agrees with the code-chirality character. Marked `E₈` root
  types recover the matching, parent, and MDS status, but no marked icosian comparison exists in
  the required equivariant category. Neither Clebsch one-factorization is perfect. These positive
  and negative readouts delimit which classical avatars retain the bit and which merely recognize
  the same object.

- **Full-conic and pencil censuses.** There are exactly four semilinear classes of non-GRS six-arcs
  with nonempty deepest-syndrome locus contained in a conic, at `q=8,9,9,11`, with child sizes
  `4,6,7,12` and projective deep-hole profiles `4`, `6`, `1+6`, `12`. A deletion-trace invariant
  recovers the parent in the six-point q=9 and twelve-point q=11 cases, but not in the other two;
  the coherent determinant atlas recovers all four with minimum centre counts `3,3,2,3`. In the
  q=9 six-point fibre, eight parents form two sheets of four perfect matchings and the shared-trace
  graph is `K₄,₄ \ 4K₂ ≅ Q₃`, with full cube automorphism group of order 48. Over q=11 the full
  equal-phase pencil contains exactly two non-GRS LC/LU classes. Across all odd fields the pencil
  exists uniformly, with explicitly classified symmetry-enhancement primes.

- **Rank-three Coxeter and arrangement package.** For `A₃/B₃/H₃`, the nonmirror maximum,
  arrangement-complement distance, and Coxeter conic phase obey one uniform theorem. The Coxeter
  square generates the full split torus in `PSL₂(q)` and its two moving blocks are the Legendre
  cosets. A weighted two-adjoint enumerator gives the Coxeter-word orbits and the all-degree
  pairing-forgetting quotient; generalized weights, circuits/Tutte data, radius-two statements,
  and minimal-word consequences follow formally. The global enumerator/Tutte package nevertheless
  forgets pointed repair data and can forget syndrome multiplicity. The exact-strength-two
  signed-moment filtration makes cubic memory sharp, with the Pasch configuration as the control.

- **Reconstruction companions and bounded negatives.** The uncoloured frame graph recovers its
  maximal-service target triple and has an exact three-level service spectrum, but the uncoloured
  q=11 graph forgets which sheet defines the projection targets. The apolar plane separates the
  tested projective Reed–Solomon deep-syndrome orbits. A full q=7 spanning-six-set search found no
  same-tower pointed collision. The twisted-cubic deep-hole pilot found no non-GRS
  twisted-cubic-locus survivor; its exact q=9 near miss is the Cayley-octad/Hermitian-quartic
  configuration. These are companion theorems and sharp controls, not extra clauses in the
  factorization-memory spine.

- **One torsor, one swap.** The design-polarity, signed-Fourier, arithmetic-gluing, affine-cocycle,
  and hexad-stabilizer readouts are functorial realizations of the same outer `C₂` torsor. Equality
  versus opposition of the two hexad-stabilizer `A₅` classes is a complete local
  inner-versus-outer criterion; complement-paired 11-orbits inside one Golay carrier are not the
  bit. The characteristic-zero `S₃` resolvent `Spec Q(√5)` supplies a non-finite realization whose
  Galois swap reduces to the outer swap at 11. Across rank three, q=5 is fused, while q=7 and q=11
  give free torsors.

- **Double-coset information lattice.** For the canonical based `B₃/H₃` pairs, the exact chain is
  `2q → 6 → 2 → 1`; its six middle strata are the `K`-orbits of the shared-edge profile, and the
  profile plus `K/C₂` decoration reconstructs the matching and parent. The conceptual input is the
  opposite-sheet Mackey matrix `[[2,1],[1,2]]`, whose constant row sum forces the six-stratum law.
  `B₃/H₃` exhaust the finite-geometry hypothesis class. At q=5 an oriented matching avatar still
  exists, but the matrix becomes `[[1,1],[1,2]]`: the canonical lattice is only
  `10 → 4 → 2 → 1`, while a pair-dependent transverse choice can recover six levels. Thus the
  avatar survives and the uniform six-rung theorem fails sharply.

- **Integral and modular degeneration law.** The cross-incidence component degrees are
  `(q−1)/2,(q+1)/2`, hence coprime, with product `|H|/2`. This forces the common `C₂` seam and makes
  every bad-prime degeneration one-sided. The bad primes are `{2,3}` for `B₃` and `{2,3,5}` for
  `H₃`; the native characteristics 7 and 11 are semisimple. At a bad prime exactly one permutation
  augmentation sequence is canonically nonsplit, with its constant line inside augmentation and
  an oriented radical arrow whose return composition is square-zero. The general proof is a
  Mackey row-sum lemma, not a case census.

- **Sharp roof negatives.** Exactly three invariant quadratic refinements exist on the q=11 hinge
  six-space and all are outer-even; the outer automorphism acts by cross-carrier dualization and
  has no invertible realization on either carrier. The literal symmetric triple index is zero, the
  signed central word is a constant Lagrangian loop of class zero, and the signed ambient
  normalizer maps trivially to the relevant outer automorphism group. These facts jointly kill the
  quadratic-refinement, Maslov-holonomy, and Witt-bridge versions of the original roof while
  preserving the carrier-level outer bit.

### The golden conference operator source programme

**Not a paper.** This material was once carved out as a fourth Clebsch-family manuscript; under the
2026-08-01 four-paper decision it is a source-development lane whose mathematics is selectively
integrated into forward versions of the passages paper. The first integration took the
source-operator-cubics-harmonic core and left the quantum, anomaly, Majorana, Coble–Burkhardt,
exceptional-lattice, doily, and higher-conference branches as inventory. Read the priority note at
the end of this section before quoting any of it.

Let `C` be a marked symmetric conference operator on six axes with `C² = 5I`, and let `C_T` run
through its coherent outer six-family. The claim is that a large family of apparently unrelated
objects are images of that one operator under exterior power, golden compression, commutator,
determinant/Pfaffian, adjugation and centered squaring — not accidental formula matches.

- **Cubic, polar and determinantal shadows.** The diagonal of the middle exterior operator
  `*Λ³C_T` is the signed Joubert cubic vector; its six outer coordinates are the Joubert coordinates
  and land on the Segre cubic; centered squaring is the Segre–Igusa polar map. The same cubics are
  Pfaffians, `Pf[D_x, C_T] = 4Z_T(x)` and `det[D_x, C_T] = 16Z_T(x)²`, and over the golden splitting
  they are determinants of the cross-eigenspace blocks. The six Pfaffian systems are the unique
  outer-equivariant synchronized product of pure-spinor Cartan big cells, with reduced Segre ideal as
  exact projected image, a reduced fifteen-line unstable base scheme and ten `3+3` nodal images. The
  cross-golden block and its adjugate give a `3×3` linear–quadratic matrix factorization whose two
  kernel incidences are the golden-conjugate small resolutions of the six-node cubic; the two
  conjugate rank-one Ulrich/MCM sheaves descend to a rational rank-two MCM object carrying `J² = 5`,
  each small resolution is a `P¹`-bundle over `P²`, and the two conjugate blowdowns give the
  determinantal double-six.
- **The Boolean layer and an order-ten lift.** On the balanced Boolean layer `C² = 5I` is equivalent
  to universal maximum-determinant `K₃,₃` frustration. The six ten-cut sign syndromes form a
  distance-six simplex; transposing the same syndrome gives an `ETF(5,10)`, and
  `S₁₀ = (RᵀR − 6I)/2` is the Petersen/Paley order-ten conference operator, so the order-ten
  boundary example is itself a Naimark–Gram shadow of the order-six system. Selected
  `(2,2,1,1)`-coefficients of the determinant sextic are exactly the four-cycle holonomies of the
  matching fingerprint, so the algebraic sextic and the dimer fingerprint are canonically equivalent
  orientation-free presentations of the same unoriented switching class. Iteration then **stops for a
  stated reason**: the 36 extremal order-ten cuts form the single `S₆/F₂₀` orbit, their halves a
  `2-(10,5,16)` design and their sign lines a biangular tight frame in dimension nine; the
  large-angle relation is the Sylvester graph, `K = −3A₁ + A₂ − A₃` satisfies `K² = 10K + 75I`, and
  recentring gives `(K − 5I)² = 100I`, a redundancy change `2 → 4`. Two by-products are general
  rather than golden-specific: universal first and second balanced-cut singular-value moments for
  every symmetric order-`2m` conference matrix, and exact Paley order-14/18 censuses whose oriented
  strata are 3-designs, separated by a degree-four cross-ratio signature.
- **Measurement, fermions and anomalies.** The two golden eigenspaces are Naimark-complementary
  `(6,3)` real ETFs and minimally informationally complete real-qutrit POVMs, but neither
  complex-IC nor SICs. The cross-golden block is a postselected transfer Kraus operator whose
  antisymmetric three-copy success probability is exactly `Z_T²/500`, with sharp bound `|Z_T| ≤ 8`
  and maximum success `16/125` on the twenty balanced `3+3` phase vertices; at every optimum the
  squared singular spectrum is `{4/5,4/5,1/5}` and the three-filter protocol is query-optimal in the
  coherent black-box model. On that optimal layer the signed cubic map is the exceptional outer
  transform, and at balanced controls also a lossless three-fermion interferometer and a signed
  `K₃,₃` Majorana family with energies `{2,4,4}` and Pfaffian `±32`. The Segre identities are the
  six-Weyl `U(1)` anomaly equations; for two Abelian factors, anomaly cancellation is exactly line
  containment on the Segre cubic, splitting into fifteen fixed-collision plane components and six
  one-moving-path del Pezzo components, with the two mixed anomalies the two mixed
  determinant–Pfaffian sums. The amplitude map is the classical `(P¹)⁶ // PGL₂` quotient with an
  explicit rational inverse in the frozen marking, `e₅(Z) = 32·Π(x_j − x_i)`, and exact optimization
  on every smooth real fibre reduces to seven pole chambers with critical equations of degree ≤ 4.
- **Majorana parity chambers.** The oriented real control sphere has exactly 860 gapped chambers
  (720 unbalanced, 24 for each of 30 sign vectors; 140 balanced, seven for each of 20), with a
  connected generic adjacency graph of diameter ten, 2,160 edges and degree distribution
  `3⁷²⁰,12¹²⁰,36²⁰` — the coset-incidence graph of a regular `S₆`-orbit. The 140 balanced indicators
  form `M^(3,3) ⊕ 2M^(3,2,1)`, their incidence Gram has rank 138 with only the two forced
  orbit-constant relations, and a standard-character projection puts eigenvalue four and both
  quadratic packets on `S^(5,1)` against `40,12,8` on `S^(3,3)`. The standard block's antipode-even
  `2×2` intersection operator has discriminant `16·13`, so **`ℚ(√13)` is an explained coset-spectral
  field, distinct from the golden coefficient field `ℚ(√5)`**. Each gapped class-D parity component
  is `SO(6)/U(3) ≅ P³(ℂ)`, so no protected monodromy or parity pump exists without added spatial,
  boundary or defect structure. Separately, the conference signing survives diagonal Majorana gauge
  as a nontrivial `ℤ/2` cycle flux on `K₆` but is **none** of the sixteen Pauli quadratic refinements
  and gives no spin structure; the canonical replacement is the chiral family `A_C(x) = [D_x, C]`,
  whose zero-mode and fermion-parity wall is exactly the Joubert cubic.
- **Symmetry, exceptional and lattice boundaries.** The full `S₆` Clifford extension is nonsplit,
  the conference `S₅` splits with two classes and the golden `A₅` with four, and six conjugate local
  `S₅` charts meet pairwise in `S₄` but do not glue. The Segre–Igusa mixed differential realizes the
  exceptional outer exchange at the level of the two classes of `S₅` in `S₆` rather than of their
  elements; its frozen `W₁₀` exchange has order eight, so the operator selects no involutory
  polarity, and the conference marking cuts the 36 inner normalizations to one twisted-conjugacy
  orbit with stabilizer `F₂₀`, making the two golden six-sets canonically `S₅/F₂₀`. Doily incidence
  ranks over `𝔽₂,𝔽₃,𝔽₅` do **not** explain the bad primes, and the sole CSS output is the standard
  binary `[[15,5,3]]₂` code. The Coble conormal scalar lifts exactly to characteristic zero (in
  determinant-valued normalization the inverse-polar scalar is the source Hessian determinant); the
  frozen Burkhardt branch sextic has Galois group exactly `S₆`, so intrinsic ordered recovery closes
  **negatively** and full level-two marking is the exact repair, computed on all 720 sheets. The
  McKay affine-Cartan quotient and Hamming Construction-A `E₈` are explicitly isometric, but no
  simultaneous Clebsch marking exists; the exact positive replacement is `L ⊕ L* ≅ II₁₀,₁₀`, whose
  self-adjointness recovers exactly the 36 involutory polarities with `(5,5)` graph eigenspaces.
- **Provenance, with a sharp negative.** Every projective or even golden shadow descends from the
  unordered support two-graph — the exact minimal quotient of the monomial Clebsch code class — and
  one support-half bit is then minimal for the signed odd shadows. The unlabelled deep-hole conic
  alone is **insufficient**: its `PGL₂(11)` action is transitive on the 22 Clebsch matching rows and
  supplies no row-to-parent bridge. The determinant sextic and dimer fingerprint close the reverse
  cycle exactly at the unoriented two-graph level and no further.
- **The six determinantal nodes are now certified and machine-checked.** For every sister the cubic
  wall `{Z_T = 0}` has exactly six singular points, the centered `5+1` collision configurations
  `[1 − 6e_i]`, all rational ordinary double points common to all six walls. Presence is elementary
  (at a `5+1` collision every matching has two pairs inside the five-block, so every
  matching-bracket cubic vanishes to second order); exact projective Jacobian elimination excludes
  any other singular support — in the centered gauge the homogeneous Jacobian ideal has projective
  dimension zero, one chart holds the whole singular scheme, and its quotient algebra is reduced of
  dimension six with six minimal primes. Lean now carries this rather than the earlier symbolic
  census: the centered lift, cubic and gradient are formal, the cubic is identified with the
  conference matrix's triangle cubic, the five quadrics are proved to be its coordinate
  derivatives, and the elimination is exact ideal-membership reproved by `linear_combination`.
- **The exchange-statistics companion — one general theorem, one universal obstruction, one
  hardware no-go.** *General:* for `K : V → W` between real Euclidean `n`-spaces, the `O(W)×O(V)`
  double orbit is fixed by the singular values; restricting to `SO×SO` splits each invertible orbit
  into two by the sign of the oriented determinant, and the two merge on the singular locus because
  a reflection is absorbed in a zero singular direction. The intrinsic object is the top exterior
  map `Λⁿ K : det V → det W`, and a degree-`n` polynomial transforming by `det(R₋)det(R₊)` is a
  scalar multiple of `det K` — classical invariant reasoning, claimed as such. The permanent does
  not descend even through the special-orthogonal double orbit. *Universal:* for any orthogonal
  `d+d` splitting of `2d` paths and any Boolean negative support `S`,
  `rank K_S ≤ min(|S|, 2d − |S|)`, so a filled `d`-fermion determinant is nonzero only at balanced
  controls — in dimension three that accounts for the **44 unbalanced zeros with no golden input**,
  and only the twenty nonzero cases are golden (equispectrality). *Permanent side:* the intrinsic
  bosonic companion is `tr(Sym³H) = h₃(H)` against the fermionic `tr(Λ³H) = det H`, with
  `spec H = {1/5, 4/5, 4/5}`, `h₃ = 313/125`, `det = 16/125`, and exact difference
  `tr(H)·tr(H²) = 297/125`; the bare permanent of `K` is *not* a golden scalar since it depends on
  the ordered orthonormal port bases, so a calibrated coherent permanent can retain the oriented
  control while no probability-only bosonic measurement can. *Hardware:* the full photonic
  experiment is a **2026 NO-GO** — the required totally antisymmetric three-qutrit state has
  linear-optical proposals but no located realization, and the best directly relevant benchmark is
  fidelity `0.910(6)` at ~1.1 fourfold events/s. A bounded precursor is a **GO**: phase-characterize
  the six-mode transfer with coherent light and run the ordinary three-boson collision-free
  controls, describable as calibrated transfer and determinant signs but *not* as a direct
  three-fermion phase measurement.
- **Priority: five clean pre-emptions, two close to verbatim.** A full literature audit of the
  frozen manuscript found that (i) the centered-square formula `W_T = Z_T² − (1/6)ΣZ_U²` is
  Howard–Millson–Snowden–Vakil's printed Segre-to-Igusa duality map, verbatim, together with the
  Igusa equation and inverse; (ii) the six sisters, the five-cycle normal form and the unordered
  support split are theirs and Seidel's — the mystic pentagons, the twelve five-cycles pairing to
  six under complementation, the six splits of the twenty triangles under exactly these conditions,
  the `S₆`-action as outer automorphism, and Bussemaker–Mathon–Seidel's uniqueness of the order-six
  conference two-graph with `Aut = A₅`; (iii) the Fano-component realization is largely
  Gripaios–Nguyen's; (iv) the order-ten shadow is classical (Fickus–Mixon's conference-matrix /
  real-ETF identification, plus Bussemaker–Mathon–Seidel's order-ten two-graph with eigenvalues
  `±3`, `Aut = Sp(4,2) ≅ S₆`, and the Petersen switching class); and (v) the rational anomaly
  inverse was already conceded. **What survives with no located predecessor is the operator layer:**
  the commutator-Pfaffian and middle-exterior presentations, the golden eigenspace compression with
  its determinantal/MCM package, the Jacobian adjugate identity, the balanced-cut
  maximum-determinant characterization of `C² = 5I`, the synchronized pure-spinor product, the
  unmarked-reconstruction boundary, and the exact anomaly-cost clauses. Four statements need
  attribution surgery, not retraction; the classical-geometry layer is thinner than the earlier
  framing suggested.

### Projective Reed–Solomon deep holes and reconstruction

A new major programme studies projective Reed–Solomon codes through their rational normal curves,
deepest syndromes, determinant invariants, and reconstruction data. Four theorem packages are now
in place.

- **Redundancy three — all fields.** Balanced four-cycle determinant monomials generate the full
  edge-torus invariant quotient and reconstruct every rank-two syndrome from support size at least
  five. The unique structural contraction is the rank-one/conic locus: all raw balanced atlases
  coincide there and the missing datum is exactly the radical point outside the support. The atlas
  is also the Plücker presentation of a projected labelled sextic, hence a point of `M₀,₆`.
  Four abstract coherent projections leave exactly a two-sheeted parent cover whose deck
  involution is Gale association; extra abstract projections cannot choose a sheet. Keeping the
  literal complete child restores much more information: it determines the unlabelled six-arc for
  every `q ≥ 16` and every q=13 fibre, with exact small-field base sizes and only the empty-child and
  q=7 two-point conic-complement failures. On a normalized chart the residual kernel cubic factors
  as `st(L₀s+L₁t)`: `L₁=0` is exactly the conic branch divisor in every characteristic, whereas
  `L₀=0` is the arc-boundary collinearity. This factorization is what identifies the involution as
  Gale association rather than merely observing a numerical double cover.

  The nontrivial small-field recovery census is exact: `(q,|L|,#parents,min centres)` is
  `(8,4,10,3)`, `(9,6,8,3)`, `(9,7,2,2)`, `(9,8,4,2)`, `(9,8,2,2)`, and
  `(11,12,22,3)`; every other nonempty residual fibre through q=13 is a singleton. The q=7
  two-point child is maximally nonrigid: all 294 literal parents have the same coherent signature
  even after both centres are used.

- **Semilinear descent — exact obstruction.** All gauges, compatibility equations, residual cubics,
  Gale transforms, branch divisors, and complete-child cuts commute with Frobenius. Off the conic
  divisor the only geometric descent obstruction is the Gale `C₂` class: a Kummer square class in
  odd characteristic and an Artin–Schreier trace bit in characteristic two. If `H` is the common
  diagonal stabilizer, an unlabelled sheet descends exactly when the Frobenius bit lies in the image
  `H → C₂`; surjectivity identifies the sheets and destroys uniqueness. Extension degree `m`
  multiplies the bit, so odd extensions preserve it and even extensions split it. The exceptional
  q=8 colour collapse is a separate lossy `C₃` quotient, not a Gale obstruction.

- **Redundancy five — complete all-field classification.** For every prime power `q ≥ 7`,
  `ρ(PRS(q−4)) = 4`. A syndrome is deep exactly when its Hankel-kernel pencil contains no totally
  split squarefree cubic. The full projective-semilinear classification consists of tangent,
  conjugate-secant, tame osculating-pair, and characteristic-three nucleus/wild
  Artin–Schreier families. Their point counts are respectively `q(q+1)`,
  `q(q+1)(q−1)/2`, `q(q+1)/2` when `q ≡ 2 (mod 3)`, and `q(q−1)/2` when
  `q ≡ 1 (mod 3)`; in characteristic three there is also the common nucleus and one wild orbit of
  size `(q²−1)/2` with stabilizer `2q`. The tame criterion is Frobenius twisting of the cyclic
  cubic deck transformation; the wild criterion is irrational kernel for `z ↦ z³+az`. For the
  geometrically `S₃` case, the off-diagonal fibre square is an absolutely irreducible `(2,2)` curve
  of arithmetic genus one. Aubry–Perret gives at least `q−2√q` rational points, and after removing
  the diagonal and branch budget no sporadic orbit survives above `q=19`.

  The complete sporadic census, grouped by branch divisor, is:

  - fully split equianharmonic tetrads (`j=0`, stabilizer `A₄`):
    q=7/13/19 orbit sizes `28,182,570`;
  - fully split non-equianharmonic tetrads (stabilizer `V₄`):
    q=9/11/13/17 orbit sizes `180,330,546,1224`;
  - branch type `1+1+2` (stabilizer `C₂`):
    q=7 has two size-168 orbits, q=8 three size-252 orbits, q=9 two size-360 orbits, and q=11 one
    size-660 orbit;
  - cuspidal type `2+1+1` (stabilizer `C₂`): one size-168 orbit at q=7;
  - type `1+3` (stabilizer `C₃`): one size-112 orbit at q=7.

  The three q=8 size-252 orbits form a free `Gal(F₈/F₂)` torsor and fuse semilinearly. The
  `A₄` cases are exactly the binary-quartic `I=0` locus. These configurations persist
  geometrically over larger fields but cease to be deep when split fibres appear.

- **Redundancy six — all-field existence and orbit counts.** For every `q ≥ 7`,
  `ρ(PRS(q−5)) = 5`. Deepness is equivalent to a Hankel-kernel net of quartics containing no
  totally split squarefree quartic. The persistent tangent/conjugate-secant stratum has exactly
  `q(q+1)²/2` points and an explicit norm-one-torus orbit law. The remaining trivial-gcd exceptions
  occur only at `q=7,8,9,11,13`, together with one characteristic-two nucleus orbit over
  `F_{2^m}` for odd `m ≥ 5`; all are exhaustively certified, though some small exceptional orbits
  still lack final conceptual normal forms. On an irreducible-quadratic fibre the stabilizer acts
  on the norm-one torus by `z ↦ z⁵` and inversion: there is one orbit if `5 ∤ q+1`, and three,
  with stabilizers `10,5,5`, if `5 | q+1`. The large-field proof contracts along the first-polar
  line to the redundancy-five cubic-pencil theorem and bounds the secant, tame-cyclic, and
  ramification losses separately by `3`, `4`, and `6`.

  The exact trivial-gcd orbit counts at `q=7,8,9,11,13` are respectively `18,11,4,2,1`, and there
  are no others. At q=11 one exceptional net is the collision-line configuration whose six lines
  exhaust the twelve rational points of the relevant conic; the other has normal form
  `⟨u,tu,u²+5⟩`, `u=t²−2`, with all fifteen split-quadratic factor candidates sharing a root.

- **Redundancy seven — complete all-field classification.** The first-polar contraction reduces the problem to
  redundancy six. The persistent stratum again has `q(q+1)²/2` points, with an exact
  `T/T⁶`-mod-inversion-and-Frobenius orbit law. For every prime power `q ≥ 13`, these are all deep
  syndrome directions except for the single central characteristic-two point when `q=2^m` with
  odd `m`; the resulting count is `q(q+1)²/2`, plus one in that case. More
  explicitly, with `d=gcd(6,q+1)`, inversion-fixed torus classes have
  `(|O|,|Stab|)=(q(q²−1)/(2d),2d)` and paired classes have
  `(q(q²−1)/d,d)`; Frobenius acts by multiplication by the defining prime on `C_d`. The high-field
  stop is quantitative: pointed genus-one splitting plus a bidegree union bound and an
  at-most-eight ramification locus leave an exceptional budget `3+8+1=12<q+1`.

  The exact marked-polar calibration closes every field below 37 without scanning all of
  `P⁶(F_q)`. Exceptional deep orbits occur **exactly** at `q=7,8,9,11`; their `PGL₂` orbit-size
  profiles are:

  - q=7: `56¹, 84⁵, 112², 168⁴⁵, 336¹⁴¹`;
  - q=8: `63¹, 72¹, 84³, 168⁴, 252²⁴, 504⁸⁶`;
  - q=9: `180³, 240⁶, 360¹⁸, 720²⁷`;
  - q=11: `264², 440¹, 660²`.

  A structurally independent replay tests every representative directly against all five-point
  spans of the sextic normal rational curve, rebuilds its full orbit and stabilizer, and reconstructs
  the semilinear cycles. What remains open is conceptual compression of those four small-field
  profiles, not classification.

  One transient locus is important to the induction mechanism even though it contributes no deep
  sextic. At q=19 the pointed-bad contraction locus has one excess affine orbit of size 19,
  represented by `e₂=(0,0,1,0,0,0)` with quartic net
  `W=⟨1,t³,t⁴⟩`. It has exactly six split squarefree members, all cubics completed by infinity, and
  no member with four finite roots. Hence it is pointed-bad but not redundancy-six deep, and no
  coherently parameterized sextic polar line can remain inside it. This is the sharp falsifier for
  any induction that classifies bad fibres separately rather than bad polar flags. The numerical
  discrepancy is settled; the arithmetic/monodromy reason it occurs specifically at q=19, and its
  possible relation to the equianharmonic q=19 cubic-pencil orbit, remain open.

- **Arbitrary redundancy — coherent polar containment.** Iterated contractions must retain every
  removed root as a forbidden marker; classifying bad fibres independently loses exactly the
  information needed to lift squarefree witnesses. With those coherent polar flags in place, a
  catalecticant-rowspace reduction and an integral Grassmannian calculation show that every
  recursively pointed contained component is persistent or modular. Consequently every split-free
  syndrome at redundancy `r` lies in those loci once
  `q ≥ 6r−15 + floor(2 sqrt(6r−17))`. This is a uniform high-field containment theorem, not a
  general solution of the Reed–Solomon deep-hole conjecture.

These results combine exact invariant theory, Plücker inversion, Gale duality, catalecticants and
apolarity, finite-group descent, low-genus point bounds, and independently replayed bounded
classifications. They do **not** prove the general Reed–Solomon deep-hole conjecture.

### MDS–CSS AME local-unitary rigidity

Let `C` be a linear `[2m,m,m+1]_q` MDS code and
`|Ψ_C⟩ = q^(−m/2) Σ_{c∈C}|c⟩` its equal-phase CSS state. For every prime power `q` and every
`m ≥ 2`, every product-unitary intertwiner between two such states is local Clifford. The proof is
uniform in length: shorten `C` and `C⊥` to `m+1` retained coordinates, expand the reduced density
matrix in the full finite-field Weyl basis, and recover the Weyl axes from the pure rank-one
contractions of the resulting diagonal tensor. The marginal expansion, covariance, tensor-rigidity,
party-permutation transport, and LU-to-LC terminal are formalized in Lean.

**The hypotheses then turned out to be unnecessary.** For every stabilizer `AME(2m,q)` state with
`m ≥ 2`, the stabilizer labels supported on any `m+1` parties form a `q²`-element subgroup and
project bijectively onto the full local Pauli-label group at every retained party. The reduced
stabilizer projector is therefore full-Weyl diagonal up to arbitrary nonzero phase coefficients, and
the axis theorem forces every factor of an LU intertwiner to be Clifford. This holds for arbitrary
additive prime-power stabilizers: **CSS, equal-phase, classical linearity, and MDS are all
unnecessary for rigidity**, and the MDS–CSS theorem above is a special case. The `m = 1` Bell-pair
boundary is sharp. The dimension squeeze, minimum-support generation, and the abstract
holonomy-centralizer theorem are kernel-checked; the end-to-end additive stabilizer-projector /
reduced-density composition is not yet closed formally.

Three consequences give the MDS–CSS theorem operational content:

- any product physical unitary converting the associated `[[2m−1,1,m]]_q` encoders is Clifford
  factor by factor, and so is its logical intertwiner;
- the product-unitary automorphism group of an equal-phase MDS–CSS state is finite modulo one-site
  scalar phases, with those phases forming the full identity component;
- for odd prime `q`, generalized or extended generalized Reed–Solomon codes of even length
  `2m ≤ q+1` attain exactly the projective one-qudit Clifford group
  `F_q² ⋊ SL₂(q)`. The first case beyond six parties is
  `AME(8,7) ↔ [[7,1,4]]₇`, whose projective transversal group has order `16464`.

One correction is carried inside the theory: the linear identity `N(T) = T ⋊ C₂` is **false**, and
the exact odd-characteristic relation is `J² = −I` with `N(T)/T ≅ C₂`; the separate projective party
extensions in the checked examples still split. A second boundary is drawn by counterexample rather
than proof — over the first in-scope extension field `𝔽₉`, exact enumeration of `Sp₄(𝔽₃)` finds 96
identity-party symplectic gauges compatible with every minimum-support transition, of which only 16
normalize the standard scalar field, so **full local Clifford blocks do not all reduce to standard
semilinear `ΓSL₂(q)` blocks**.

**Rigidity is also stable, and that closes the last optional gate.** For two product-unitarily
related equal-phase `[6,3,4]_q` MDS–CSS states with phase-optimized global vector error `ε`, every
local factor lies within normalized Hilbert–Schmidt distance `2√2·q²ε` of an additive Clifford below
an explicit prime-field commutator threshold; the four-party marginal form is `√2·q²η`. Weyl
products, commutators and character averaging close the gap from approximate axes to an implementing
Clifford. The bound is uniform across the enlarged extension-field kernels **only** for the full
prime-field Clifford target: exact q=9 nonsemilinear and q=25 GRS symplectic elements rule out every
uniform semilinear, split-torus or Desarguesian-spread upgrade *even at zero error*, so that is a
structural obstruction rather than a loss of precision. No manuscript wording was adopted from it.

**A generic coset/syndrome dictionary underlies the finite examples.** Translated equal-phase states
are classified by code cosets, distinct cosets are orthogonal, dual-code phase stabilizers read the
translation character, every syndrome has exactly one representative on each three-party support, and
minimum weight three forces full support. Applied to the Clebsch `[6,3,4]₁₁` state, the twelve conic
rays, 120 syndromes and transitive `C₁₀ × A₅` orbit combine with that uniqueness to show either side
of every balanced `3|3` cut can create the same extremal translate. The defining arc is nonconic, so
the fixed-party logical image is the split torus `T`, not `SL₂(11)` — a distinct statement from the
computed `S₅` party image, and one that supports no Hamiltonian or golden-operator claim.

At `m=3`, the general theorem is paired with a more specific six-point-pencil classification: a
degree-eight quotient separates projective, monomial-code, local-Clifford, and local-unitary
equivalence, the conic/GRS locus has logical symplectic group `SL₂(q)`, and the generic off-conic
locus has only the split torus. Fixed-copy scalar contractions are generically constant; exact
marginal and four-copy witnesses detect only special strata.

**Trust boundary:** the arbitrary-`m` marginal-to-rigidity theorem and the generic coset/syndrome
dictionary are in the formal aggregate, the latter isolating the Clebsch statement as a
two-paragraph structural lemma composed with a conic/count/orbit theorem and a nonconic
logical-phase theorem. The
projective-finiteness corollary has a completed Lean module but is not yet imported by that aggregate
or its axiom audit. The full Choi/encoder construction and the exact GRS transversal-group
computation remain manuscript proofs rather than completed Lean terminals. The paper has a clean,
reproducible local release candidate, but no public deposit, DOI, license grant, or submission has
occurred.

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

**The two-repair-coset construction for `C`-complete `O(√q)` arcs — obstructed, then succeeded, then
closed on the other gate.** The trace-one two-repair-coset ansatz over the odd tower reduces arc
legality to rational points on a seed–cross-repair collision cover, and that cover's factorization
theory is now complete: a single Artin–Schreier divisor with exactly three residue branches, all
exhaustively classified and all collision-forcing. Every nonconstant-height specialization has a
reconstructible genuine collision for `q ≥ 32768`; each named branch closes at `q ≥ 512`; and the
constant-height case dies on an exact `GF(8)` census — 150,528 configurations, 7,512 collision-free
for both seed colours, **0 arc-legal**. This is an exact **mechanism obstruction, bounded**: it is
*not* a nonexistence theorem for `C`-complete `O(√q)` arcs, and it bounds only the
common-curvature / common-linear-direction slice — a codimension-three slice of the natural
constant-`p` family — not all quadratic two-repair architectures. Its succession then closed the
architecture from the other side. The ambient family was classified: the linear-`p` stratum is
**empty over every odd scalar degree** (the two required trace-one classes sum to a contradiction, so
it fails before the seed gate), and all eight legality packets collapse the odd-degree tail into a
single nine-dimensional constant-height stratum. On fixed coefficients every seed-legal configuration
collides at relative degree ≤ 5. On *fresh* per-field coefficients collision-free four-layer arcs of
size `4Q` **do exist** for every odd-tower `Q ≥ 2^45` — and then **coverage kills them**: their finite
secant directions form exactly seven reciprocal images, so at most `7Q−2` points are covered and
`≥ Q²−7Q+2` required non-conic points are left uncovered, on the whole stratum and before any trace
condition. **Arc legality is solvable on the survivor family; relative completeness is not, for this
architecture.** Also closed here: the terminal star-deletion route (at `q=8` the mandatory conic
deletion already uncovers a required point, and monotonicity makes it irreparable), and the proposed
`q=512` exhaustive sweep, refuted **by our own exact count** — `9.17 × 10¹⁸` specializations leaving
`≥ 9.9 × 10¹⁴` representatives after every certified quotient, against an earlier in-house estimate
of "hours."

**Replacing the exhaustive `q=16` eight-arc certificate — four independent attempts, all closed.**
The quadratic-evaluation obstruction does have an exact field-uniform Hilbert/separator form, but
that form does **not** force the `q=16` conclusion, so recasting it intrinsically is not an
amplification gate. A low-weight projective Reed–Muller route fails on a type error that is worth
recording: complete linear factorization and sevenfold arc-point vanishing are properties of a
*polynomial representative*, not of its codeword — the relevant evaluation fibre has dimension 168 —
and conic support is abundant in the degree-28 code anyway. A Rédei-quotient projection from an
uncovered conic point exposes a sharp local identity whose last branch is genuine rather than
spurious: an exact `GF(16)` arc satisfies the required divisibility on seven of eight labelled
fibres simultaneously, so no one-fibre and no seven-fibre argument can force the second conic point
to stay uncovered. Coupling the eight centre involutions across every uncovered conic point makes
the condition much stronger — no multi-base survivor exists among 2,291,362 checked arc–conic pairs
— but the pure involution-boundary data admit exact counterexamples, so the exclusion still has no
proof independent of the classified list. What these attempts did produce is compression: the
surviving certificate is three exceptional leaves rather than 2,633 (§3), and a sharp new finite
target — every non-relative pair with at least six ordinary holes has at least six off-conic holes
visible on its fibres, with equality realized by two collinear triples on a split quadratic meeting
the arc once on each component. A classification-free proof of that six-hole stability statement is
the remaining route.

**Conic continuation (the Schreier route into the odd-plane kernel).** The blocking object is the
mixed-class regular `PGL₂` Cayley scar, and the standard certificate provably cannot reach it: every
colour-preserving automorphism of `Cay(H,S)` is a right translation, so a mixed-class triple admits
**no** colour-preserving nonadjacent pairing, and the centralizer-coset defect cannot be patched
locally. Deeper certificates fail too — for each involution class there is adversarial mirror play
reaching a state with no fixed-point-free involutory automorphism at all (abstract automorphisms
permitted, not merely colour-preserving), so the missing state is necessarily **asymmetric**; and no
four-ply pairing certificate exists for any of the seven hard types, across ≈1.69M distinct
type-labelled masks. The compression routes are equally bounded: the first contextual candidate
summarizing a rooted attachment by nimber tuples is **false** (3,412 nimber conflicts among 10,695
mergers), the minimized linked-port quotient gives 950 classes for 963 states — descriptively
complete, no compression — and a long series of exact separator, isomorphism and dictionary quotients
each returned genuine but negligible mergers without ever returning a value. Replacement positive:
the exact one-port summary is a finite recursively interned transition DAG, and DAG equality is a
congruence for gluing to every finite one-port context.

**Repair ports.** Naive same-radius deletion–contraction (two explicit binary witnesses; 5,103
exhaustive cases); any finite radius/width-bounded transfer alphabet (unbounded binary triangle
relays at radius two, width two — and the disproof discards the counts, so it is not a
count-unboundedness argument); strong multiplicativity for the `GF(9)` holonomy classes (the
criterion factors through the quadratic Veronese matroid and is uniformly `U(3,4)`, so **no**
realization can fix it — closed for every dealer). Downgraded rather than killed: the
functional-cost parameter `λ_I` is definitionally the classical coset-leader / syndrome weight;
coefficient values are arbitrary gauge under a kernel-checked rescaling theorem, so no
minimum-access or minimum-bandwidth claim follows from them.

Four further closures, one of them self-inflicted. **Universal log-concavity of the pointed profile is
refuted** by an explicit simple rank-five binary seven-column counterexample. The
**peeling / excluded-minor classification programme is dead**: minor, dual and 2-sum closure of the
radius-truncated port class all fail at radii two and three with named witnesses, so the
well-quasi-ordering route never reaches its own antecedent. **Ordinary log-concavity was conjectured
and then killed inside the same lane** — it survives 30,638 exhaustively enumerated pointed types
across three complete represented ranges, which is exactly why the narrow representable-matroid form
was retained, and parallel composition then breaks it with an **infinite regular-graphic TTSP
counterexample family**; the smallest member has 14 helper edges, and all 185,701 distinct profiles
through 13 edges pass. Series composition survives as the positive island. Finally, the whole
applied/agentic branch — failure-domain transversals, proof-carrying remediation certificates,
decision-focused fault discovery, and the irreversibility/exposure separation — **passes its
engineering gates and fails its novelty gates**: shared-risk and `d`-failure-resilient routing,
hitting-set interdiction, Proof-Carrying Plans and verified planning validators, targeted active
learning, and expanded-state strong-cyclic planning already own every theorem-bearing part. The
synthetic selection advantage is real *within an authored fixture* and no empirical agent advantage
is claimed, since annotations and execution there share a single causal model. Also closed on
positioning: the tract / hyperfield push-forward dictionary is immediate functoriality with trivial
finite-field valuations, and truncated-profile realizations are coordinate projections of an existing
Pareto Hamming-embedding frontier.

**Clebsch, by subtraction — and one half of it since restored.** The proposed three-way
arithmetic–finite–harmonic bridge on the Clebsch four-space was **not available**: the finite
intertwiner in hand is noncanonical, its irreducible scalings are independent, and no common
primitive lattice is defined. The *finite* leg of that verdict stands unchanged. What has since been
supplied is the arithmetic–harmonic leg: a chosen sheet of the incidence cover determines the golden
conference switching class and its oriented triangle cubic, and transports the sign to the harmonic
side — but only **relative to a marked datum** the sheet does not itself reconstruct (§3). So the
correct current statement is a relative bridge with a complete ambiguity ledger, not the canonical
specialization that was ruled out. Adjacent negatives: the Klein cubic's intermediate Jacobian carries no two-dimensional
`G`- or `A₅`-stable arithmetic carrier of the required kind, and the discriminant-five lift of the
exact relative-commutant calculation fails even though the commutant calculation itself is positive.

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
- **The full conic-continuation classification — the sharpest open target, and calibrated.** The goal
  is a uniform algebraic determination of the Node-Kayles value of the fixed-point-deleted conic
  Schreier graph, valid across the `PSL₂/PGL₂` escape boundary rather than extending the finite
  small-subgroup table. One explicit full-`PGL₂` P family exists (§3) and the three-centre boundary is
  exact at small `q`; what blocks the general statement is the **mixed-class regular Cayley scar**,
  where every known certificate is now proved unavailable and the missing state is provably asymmetric
  (§4). Seven root values remain unknown, and the compression routes that would have supplied them are
  bounded negatives — descriptively complete quotients with no compression. **The calibration matters
  more than the target:** this is a cheap, high-information candidate for a new Grundy-zero
  certificate, **not** a proved common reduction of the other open problems. The odd-plane density
  question, the mirror-method boundary, and this scar share a *failed certificate language*, not a
  demonstrated common cause — no theorem reduces any one of them to another, and treating them as one
  grand blocker would be an inference the evidence does not support.
- For **q ≥ 23** the live conic cannot be emptied at the two-ply layer (depletion ladder
  `live_on ≥ q − (t²+5t+5)`); one bucket (`1,3,4,9`) verified xor-zero-maintainable through one
  further coupled move (28,646/28,646 obligations). Termination not proved.
- **Even-dimensional odd-`q` (`PG(2m,q)`, m≥2) now has its first direct outcome:** **`PG(4,3) = P`**
  exactly solved in 3.7 s / 25,258 orbit-canon memo states, with independent
  move-order/canonicalization cross-checks. The uniform family remains open, and no second board
  in it has been solved.
- **The reply-strategy machinery now has a proof-object interface, and the search is inside it.** The
  boundary law is settled: under `capOK` the residual game is Node-Kayles on the full legal conflict
  graph, so P is equivalent to Grundy zero. Total capacity-two overload `Ω` is the exact well-founded
  absorption coordinate, and the maximal value-independent survivor defined from that boundary is P
  by well-founded induction. A secant size barrier (`s`-caps with `capOK` force `q ≤ C(s,2)`) proves
  no fixed-size route can be uniform. What is missing is one statement: *for every opponent, choose a
  sound lower-rank reply*. Successive candidate survivors get closer and each dies on a located edge
  — a bounded small-shell incidence correspondence is sound and projective but has zero coverage on
  the first `q=23` control; a rank-zero defect correspondence matches the recursive survivor exactly
  on ten canonical controls before failing on the eleventh; strict obligation deletion agrees on
  11,075 edges before failing at control index 20, where the unique sound reply necessarily creates
  one new defect while dropping rank `27 → 2`. That failure is the current lead rather than a dead
  end: the created defect is traceable, inheriting the old label of the causal half-move, and two
  distinct marked projective replacement types (opponent-created endpoint degradation, reply-created
  certificate deletion) each close by a bounded local mechanism with no branching or ancestry
  collision. **The causal-local version of that target is now refuted, and the refutation relocates
  the proof object.** Uniform per-causal-move certificate-exchange nonpacking fails already over
  `𝔽₁₁`: for `A = {(1,3),(5,2),(9,6),(10,1)}`, `o = (4,4)`, `h = (7,10)`, both `o` and `h` are
  defects of `A`, while `Def(A+o) = ∅` and `Def(A+o+h) = {(0,5),(6,5)}` — the causal reply `h` was
  itself a shared old certificate for both new fibres, so selecting it consumes both copies and one
  causal label necessarily branches (primary bitmask and independent affine-determinant replay
  agree). The conditional causal-label theorem stays correct; what dies is the uniformity of its
  hypothesis. The same witness has **global cardinality surplus** — seven old defect labels disappear
  and only two genuinely new defects appear — so the live object is a global Hall-type rematching
  assigning every new defect a distinct consumed ancestral label, with strict total support descent,
  described by bounded projective incidence data and hereditarily compatible with the overload
  coordinate and its boundary. Ruled out along the way: any fixed
  finite exact residual signature (sealed conic subsets already give unboundedly many P-valued
  heights), every scalar extremal selector tested, and unrestricted coordinate encodings, which are
  vacuous because a natural number can encode the whole residual.
- Prize: eventual uniform proof ~35–45%. **This is a subjective prior, not a measurement, and it
  should carry no weight in a resourcing decision** — it is a considered guess about an open problem,
  written in the same register as the exact results above it, which is exactly the confusion to
  avoid. The q=25 unblind the upper half was contingent on is **resolved all-P**, leaving the proof resting on the amortized-ledger / packet-absorption lever, the
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
- **The twelve `s=8` repair layers, classified.** They form three `PGL(3,64)` / monomial-code classes
  but a **single** `PΓL(3,64)` semilinear class, giving a `[24,3,22]₆₄` MDS code with an intrinsic
  `10+10+4` conic signature. The classification excludes hyperfocused arcs, translation arcs, affinely
  regular polygons, and the nearest catalogued construction. A caution attaches to the analogy that
  motivated it: those nineteen uncovered points *lie on* the line at infinity but are not its full
  rational point set, and the completed 26-arc carries no residual deep-hole locus — line-confinement,
  not exact conic equality.
- **The field-varying coefficient route was then run to its end, and it closed on coverage.** Fresh
  per-field coefficients do produce collision-free four-layer arcs of size `4Q` for every odd-tower
  `Q ≥ 2^45` — so the legality gate, which was the expected obstruction, is genuinely passable at that
  scale — but those arcs cover at most `7Q−2` points and leave `≥ Q²−7Q+2` required non-conic points
  uncovered (§4). Combined with the empty linear stratum and the degree-≤5 collision law on fixed
  coefficients, the entire constant-height four-carrier architecture is closed for **both** gates at
  once: legality by construction, completeness by refutation.
- **Still open:** nonquadratic repair graphs, other Baer-transversal designs, and architectures with
  more than four carriers or non-constant height. What is closed is a specific, precisely delimited
  family of mechanisms — **no global nonexistence statement about `𝒞`-complete `O(√q)` arcs is claimed
  anywhere**, and the uniform characteristic-two three-layer construction that would solve the problem
  on an infinite square-order sequence remains proved only at `s = 8`.

**Reed–Solomon:** compress the exceptional redundancy-six webs and the four small-field
redundancy-seven profiles into intrinsic normal forms, and continue the redundancy-eight/nine pilot
only through theorem-producing orbit mechanisms. The `r=3,5,6,7` hierarchy is now classified at
its stated scopes; the next boundary is conceptual explanation and higher redundancy, not an
unfinished low-field census and not the general Reed–Solomon deep-hole conjecture.

**Clebsch — the all-sizes conic-filling theorem is the lane's one identified route to a top-tier
paper.** A full review of the group found that no repackaging of the existing results clears the
A−/A band: every headline concerns one exceptional object over one or two small fields, with no
infinite family, no asymptotic statement, and no transferable technique — and exceptional-object
papers reach the top tier only when the exceptional object closes a general question. The general
question here is open at `k = 9`. The theorem would be a **new** headline paper (rigidity + all-k
classification + golden operator), not a retrofit. Current state: proved for every `k` over every
odd `q ≤ 43`, saturated branch uniformly closed, nonsaturated branch reduced to slack `≥ 2` with
`(q,k) = (53,12)` the first surviving boundary. The exact remaining obstruction is a clique bound
`m(q) < √(2q) + O(1)` for a Paley-type graph on the points off the conic, measured to be tight
rather than generous — so it may be false for some `q`, and that possibility is itself the finding.

**Clebsch publication:** the three released papers have cleared their mathematical gates and what
remains is external. The rigidity paper carries the golden orientation as well as the
reconstruction, and its companion carries a five-mode claim ledger; the trade-rigidity paper derives
the one-factorization split rather than assuming it; the passages paper has closed both of its former
proof gaps, states its orientation bridge relative to an explicit marked datum, and its forward
version has absorbed a bounded golden-operator core. Each still owes an immutable artifact locator,
and the passages paper also owes author affiliation/contact metadata. The q13 passant-code paper is
the active build: human proof, paper-owned evidence, semantic modules and sharded Lean gates are
green, with four concrete transports and release outstanding. The golden operator lane keeps its
proved source mathematics but is no longer chasing a manuscript of its own; its live obligation is
absorbing the five literature pre-emptions into whatever forward version consumes it. Keep the
modular sequel separate: its proved centre is the
Modular Gateway Theorem and its `q=7,11,23` realizations/boundary, not the refuted universal
metaplectic/theta roof.

**Adjacent problems, opened deliberately and bounded.** For Hadamard order 668, 25 of the 30
mod-3-compatible fixed common multiplier subgroups are impossible — a published 21-subgroup
proof-carrying baseline reproduced, then extended by a nine-compression congruence and a shift-111
orbit lock whose exact six-case census also proves the lock is exhausted on the five survivors. Every
order-six subgroup is closed and the paired residual cases are the live target. No Legendre pair and
no matrix of order 668 is constructed, and unrestricted order 668 remains open. A companion attack on
`M(18) ∈ {57,58,59}` by Seidel-spectrum census is queued and has produced nothing yet.

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
top-k replay. **The binary count overstates this**: these are entry points over one shared solver
core and one canonical-key implementation, not independent programs, and the list is long because
the mining surface is wide rather than because the engineering is.

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
alternate-orbit certificate is sharded into transport modules, dispatch leaves, and canonical class
links — thousands of each — **because a combined elaboration exceeded the safe memory envelope**.
That single certificate is why the tracked module count says nothing about how much mathematics is
formalized.

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
was rejected rather than approximated.

**The caveat has moved, but not lifted.** The first real Lean target has now been put through the
managed bridge, and it failed twice before returning a canonical verdict. The first submission died
at the staleness probe with `lake: not found` — the transient unit inherits the user manager's
environment and then rebuilt `PATH` in a way that discarded the devshell, a failure mode structurally
invisible to the legacy path, which had the environment already exported. With the baseline pinned on
the unit and an acceptance handshake that refuses units lacking it, the rerun elaborated and returned
a canonical failure naming genuine `decide` errors — a proof matter, not a supervision defect. So the
supervision path is proven and the notification contract is exercised, but **a green managed Lean
compile remains unobserved**: that success path is closed by decision rather than by evidence. Every
other path is pinned by hermetic tests with stubbed `nix`/`lake`/`choom`/`pgrep`, real Lake exit
codes, trace semantics and interrupted-build residue are still unestablished, and a quiet `pgrep` is
not proof of an idle tree.

**Two analysis tools measure what was previously guessed.** An import-graph analyzer over every
tracked module and project-local import edge shows the dependency tree is **depth-driven, not
fan-out-driven**: about ten hub modules each invalidate ~95% of the tree while carrying only 2–11
direct importers. **The module count is not a measure of the development's size and must not be read
as one.** The overwhelming majority of tracked Lean files are generated certificate rows — the `Q16`
and `Q25` data trees alone account for well over nine tenths of them — and the handwritten library is
smaller than that total by more than an order of magnitude. Anyone sizing this development by
counting modules will overstate it enormously; the sharding exists because a combined elaboration
exceeded the memory envelope, not because there is that much mathematics. The companion cost ranking is **not delivered, and its premise failed** — the
available build telemetry is closure-level and cache-state dependent rather than per-module, so
summing it over a reverse closure double-counts (two trees differ by more than 2× in implied
per-module rate). An early rank correlation between olean size and measured seconds is explicitly
recorded as *not a finding*, since it compares a closure time against one module's output size; the
tool reports zero per-module measurements available rather than a proxy. Writing hermetic tests for
the restart guard exposed two real defects in it: a verifier that accepted an empty sentinel map and
reported "verified, byte-identical" while hashing nothing, and a validation `assert` that disappears
under `python3 -O`. Both are fixed, and the suite is discriminating — run against the pre-fix
revision it fails exactly the three regression tests.

---

## 7. Lean formalization ledger

**Legacy per-gate trust posture:** the recorded terminal `#print axioms` reports are exactly
`[propext, Classical.choice, Quot.sound]` — **no `sorry`, no `native_decide`; kernel-complete** —
with the sole exceptions being a small, named, deliberately quarantined set of **imported literature
statements**:
two consequences of Dye's theorem, Stichtenoth's self-dual TVZ theorem, and prime equidistribution in
arithmetic progressions. Each is isolated in its own module, each stays visible in the axiom report of
every result depending on it, and no result silently inherits one. Certificate cap-legality is checked
by the **Lean kernel** (`decide` / `checkCap_sound`), not `native_decide` and not trusted.

Those clean reports and the newer repository-wide extraction audit are different evidence layers.
Scoped current-project aggregates now elaborate and audit successfully: the relconic reconstruction
and matching-design closure, the exact 17-file R5–R7 PRS paper closure with its 74-target audit, and
the generic AME marginal-to-rigidity chain all have current gate evidence. The repository-wide
extractor is still a separate attempt to rederive dependency and terminal-axiom facts across the
whole tracked development. Its state must not be conflated with those scoped gates or described as a
completed repository-wide trust audit.

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
  coding/deep-hole/extension-complex package, exact uncovered-locus reconstruction and stabilizer
  recovery, zero-defect matching-design rigidity and bad-edge stability, the whole `Q25` profile
  ladder up to the uniform pair-extension theorem, the exact R5–R7 projective-Reed–Solomon paper
  aggregate, and the arbitrary-length MDS–CSS marginal/covariance/tensor-rigidity chain culminating
  in the generic LU-to-LC theorem. Newer layers: the equality consequences (the discrete
  zero-or-gap alternative for scaled defect, the complete-affine equality orders, the odd zero-defect
  order spectrum and its characteristic-two collapse), signed Gale duality reduced to a minimal
  hypothesis set, the quadratic-hull/evaluation-avoidance core, the stabilizer-AME support squeeze
  with minimum-support generation and the holonomy-centralizer theorem, and the two symbolic
  orientation mechanisms — localized involutive splitting and the pair-sum/Petersen eigenspace
  statement — behind their own import gate.
- **RepairCodes** — the concatenation-transfer lemma, the trace-dual bridge, exact cubic/axis repair
  invariants, both projective and affine seed lifts, and the two asymptotic families.
- **DihedralSchreier** — the dihedral reduction, the `V₄ → K₄` core, the template invariant `Φ_T`,
  the finite half-density core, and a conditional density layer sitting behind **exactly one**
  quarantined `primes_equidistribute` axiom (PNT in arithmetic progressions). No `sorry`, no
  `native_decide`. Deliberately *not* formalized: the template nimbers, the template isomorphism
  theorem, the imported ladder values, the orbit counts, and the pair-family theorems — all of which
  the manuscript carries as computed or cited rather than machine-checked.

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

**The trust claim is now checked mechanically, and the first audit found gaps.** Rather than
hand-maintaining trust tables, a read-only spine derives facts from tracked bytes and a Lean
environment export, and **fails when the declared trust boundary and the actual tree diverge**;
reviewer declarations are never promoted into evidence. Its first pilot found what hand-maintenance
had missed: fourteen handwritten modules in the largest library sit **outside every declared gate**,
at least three of them carrying theorems the trust document names by hand; one gate covers half the
modules it claims, with a validation command that builds none of them; one tracked module is built by
**no** lake target, so nothing kernel-checks it; one project-local axiom was absent from the trust
document entirely; and every generated data tree is `legacy-unverified` — identity hashes are not
regeneration claims. A related decision gate resolved *against* an earlier working assumption: the
theorem graph is **not** partial, because proof bodies are available — the reported opaque boundaries
were an artifact of the extractor's own configuration, and only genuinely `opaque` declarations are
boundaries.

**The standing caveat here is the large one: no project module has yet been extracted.** The whole
extraction path is validated against core Lean only, so every declared terminal-axiom set remains
mechanically unverified and all gates report missing facts. The driver deliberately refuses to run
while the tree carries foreign changes, and terminal names are left absent rather than guessed,
because a guessed name would produce a green check for a declaration that does not exist.

**The Clebsch replacement spine has a bounded formalization map, not yet a full release gate.**
Finite foundations for the q=11 transform, matching recovery, two sheets, and Fourier block have
been kernel-checked, and the arithmetic-gluing calculation has a bounded formal proof. The selected
factorization-memory manuscript spine still awaits its planned end-to-end Lean integration; the
protected baseline remains the currently complete fallback.

**Two newer formal layers, and one deliberate absence.** The passages note's paper-oriented
interfaces — conference, triangle, two-graph, augmentation, middle-exterior, support-recovery and
golden-descent — are formalized behind a serialized gate with an exact per-declaration axiom report
and a file-level hash manifest, while abstract classification, atom recovery, exterior-cube
faithfulness, binary transvectants and the optional quaternion-order refinements stay **explicit
human-proof boundaries** rather than being quietly absorbed. On the quantum side, the generic
coset/syndrome dictionary is formalized, which is what let the Clebsch statement reduce to a
two-paragraph structural lemma. The rigidity paper's q=11 formal package is pinned by commit with a
tracked exact axiom audit, and its companion labels every claim by one of five modes — human
structural proof, published theorem, Lean theorem, finite certificate, trusted execution — so no
finite classification or orientation theorem is presented as machine-checked when it is not. The
absence is the golden-operator manuscript: it has **no formal layer at all**, by design at this
stage, and nothing in it should be read as carrying one.

**One standing adequacy caveat:** mathlib `v4.32` dropped `SetTheory/Game/`, so the game-outcome
semantics (`win`/`grundy`) are self-contained and not yet anchored to a cited `Impartial`/
`grundyValue`. Adequacy for the game papers rests on the standard-recurrence argument, literature
values, and differential tests until `CombinatorialGames` bumps. The kernel is kept deliberately tiny
so it stays inspectable — a better answer than waiting.

---

## 8. The publication track

The deliverable is no longer "the odd-plane prize, de-risked into stepping stones." An initial
packaging review resolved the then-existing body of work into **seven papers in ship order + two
OEIS entries**, staged under `papers/` with per-paper status maps. That fixed count is now
historical: the Clebsch work has resolved into a four-paper numbered series with a separate source
lane behind it, while the projective Reed–Solomon theorem programme has become a major paper-scale
track of its own. The table below remains the original release-order backbone, not a current count
of every candidate manuscript.

The manuscript inventory below is generated from the manuscript sources themselves — titles from
each `\title{}`, page counts from the compiled PDF, statement counts and label counts from the TeX.
Do not edit it by hand; run `lean/scripts/paper-facts.py generate`. Its counts are what the sources
contain, not a judgement about what is ready: the ship-order table after it carries that, and stays
hand-written.

**Read the row count with three corrections, or it misdescribes the portfolio.**
`beyond4_prs` and `beyond4_prs_submission` are one manuscript in two typesettings, not two results;
`clebsch_hexagon_code` is the superseded integrated manuscript, preserved only as a fallback for
material the rigidity paper, its companion, and the trade-rigidity paper now carry; and two rows are
not papers — `golden_operator` is a source-lane draft feeding forward versions of the passages
paper, and `golden_quantum_statistics` is the lane-local exchange-statistics companion written as a
design-limit and theory note. So the rows describe **fourteen live manuscripts**, of which twelve
are papers or paper companions. The newest two rows are early builds and their statement counts say
so: `passant_code_q13` is the fourth numbered Clebsch paper with its human proof landed but its
manuscript still being written out, and `golden_quantum_statistics` is a short note. The statement and label columns need the same
care: labels count anything labelled, and corollary-heavy papers inflate against theorem-heavy ones —
the arcs manuscript alone carries 21 corollaries against 8 theorems, so its 77 labels are not 77
independent results. Neither column measures depth, and none of them should be summed across rows.

<!-- trust-spine:begin area=papers section=manuscripts version=1 -->
| Manuscript                      | Title                                                                                                                         | Lane             | Pages | Thm | Lem | Prop | Cor | Labels |
|---------------------------------|-------------------------------------------------------------------------------------------------------------------------------|------------------|-------|-----|-----|------|-----|--------|
| `ame_lu`                        | Local-Unitary Rigidity of Stabilizer AME States and Transversal Clifford Groups of MDS--CSS Codes                             | `ame-lu`         | 31    | 7   | 5   | 8    | 6   | 47     |
| `arcs_complete_outside_conic`   | Arcs complete outside a conic: a prescribed-hole defect identity and matching-design rigidity                                 | `relconic`       | 24    | 8   | 4   | 5    | 21  | 77     |
| `beyond4_prs`                   | Deep holes of projective Reed--Solomon codes beyond redundancy four: exact classifications at redundancies five through seven | `reed-solomon`   | 30    | 6   | 10  | 18   | 3   | 60     |
| `beyond4_prs_submission`        | Deep Holes of Projective Reed--Solomon Codes Beyond Redundancy Four: Exact Classifications at Redundancies Five Through Seven | `reed-solomon`   | 30    | 6   | 10  | 18   | 3   | 60     |
| `clebsch_factorization`         | Quadratic trade rigidity and cubic orientation in conic matching quotients                                                    | `clebsch`        | 39    | 6   | 7   | 5    | 10  | 44     |
| `clebsch_hexagon_code`          | Deep-hole rigidity and factorization memory in the Clebsch hexagon code                                                       | `clebsch`        | 37    | 9   | 4   | 13   | 3   | 59     |
| `clebsch_passages`              | Golden descent and operator realizations of the Clebsch cubic                                                                 | `clebsch`        | 20    | 3   | 0   | 3    | 0   | 14     |
| `clebsch_rigidity`              | Reconstructing the Clebsch code and its golden orientation from its deep-hole syndrome locus                                  | `clebsch`        | 22    | 4   | 1   | 7    | 3   | 28     |
| `clebsch_rigidity_companion`    | Computational strengthenings of Clebsch syndrome rigidity                                                                     | `clebsch`        | 22    | 7   | 1   | 1    | 1   | 17     |
| `complete_repair_ports`         | Complete Bounded Repair Ports: Transfer, Reliability, and Geometric Structure                                                 | `complete-ports` | 16    | 6   | 0   | 4    | 3   | 17     |
| `continuation_graph_rigidity`   | Semilinear rigidity of four-point-frame continuation graphs                                                                   | `continuation`   | —     | 5   | 3   | 3    | 0   | 18     |
| `dihedral_schreier_node_kayles` | Node Kayles on Conic Schreier Graphs: Dihedral and Polyhedral Templates                                                       | `dihedral`       | 19    | 15  | 4   | 4    | 5   | 90     |
| `equivariant_robust_completion` | Frobenius-equivariant pair extension and robust repair of eight-arcs                                                          | `paper-frob-eq`  | 14    | 4   | 2   | 3    | 7   | 33     |
| `golden_operator`               | The golden conference operator and its shadow sisters                                                                         | `golden`         | —     | 7   | 1   | 3    | 2   | 14     |
| `golden_quantum_statistics`     | Orientation and exchange statistics in a Golden six-mode transfer                                                             | `golden`         | 10    | 2   | 0   | 2    | 1   | 5      |
| `passant_code_q13`              | A binary $[78,36,12]$ code from the passant lines of a conic over $\F_{13}$                                                   | `clebsch`        | 7     | 1   | 0   | 0    | 0   | 2      |
<!-- trust-spine:end area=papers section=manuscripts -->

| # | Paper                                                | Lead                                                            | State                                                |
|---|------------------------------------------------------|-----------------------------------------------------------------|------------------------------------------------------|
| 1 | Games flagship — cap/Nofil outcome classes           | the classification **with its exact method boundary**           | core P-theorems Lean; projective section unwritten   |
| 2 | Node Kayles on Conic Schreier Graphs: Dihedral and Polyhedral Templates | exact nimbers for an explicit infinite family | rebuilt as LaTeX on a spine; owes a value fix |
| 3 | Arcs complete outside a conic: a prescribed-hole defect identity and matching-design rigidity | defect identity → rigidity → stability | local candidate + scoped Lean; archive gate |
| 4 | Reconstructing the Clebsch code and its golden orientation from its deep-hole syndrome locus | conic-filling rigidity, gaps, decoding, universal chord defect, golden orientation | human core + computational companion, synchronized release gates green |
| 5 | Complete Bounded Repair Ports: Transfer, Reliability, and Geometric Structure | general MDS local reconstruction + exact bounded transfer | spine refrozen under a no-computation admission rule |
| 6 | Frobenius-equivariant pair extension and robust repair of eight-arcs | every invariant eight-arc in `PG(2,25)` pair-extends | extremal gate cleared; bookkeeping + graph remain |
| 7 | Semilinear rigidity of four-point-frame continuation graphs | `Aut(frame graph)` = ambient semilinear group, `q ≥ 13` | manuscript complete; Lean planned; audit gated |
| — | Deep holes of projective Reed–Solomon codes beyond redundancy four: exact classifications at redundancies five through seven | exact R5–R7 + coherent-polar high-field containment | 30-page reproducible V1; external release gates |
| — | Local-Unitary Rigidity of Stabilizer AME States and Transversal Clifford Groups of MDS–CSS Codes | LU-to-LC for every stabilizer AME state | 18-page local candidate; generic Lean core |
| — | Golden descent and operator realizations of the Clebsch cubic (Clebsch III) | one oriented coordinate line behind both realizations, relative to a marked datum, plus a bounded operator core | v1/v2 released under the earlier title; forward version consolidated |
| — | Quadratic trade rigidity and cubic orientation in conic matching quotients (Clebsch II) | the conic-ideal factorization quotient and its `B₃/H₃` completeness, with one-factorization derived | v1/v2 released; forward human/Lean strengthening active |
| — | A binary [78,36,12] code from the passant lines of a conic over F13 (Clebsch IV) | minimum words reconstruct the passant geometry and `PGL(2,13)` | human proof + semantic Lean spine + sharded leaves green; four transports and release remain |
| — | *(not a paper)* golden conference operator source programme | one operator, and the cubic/polar/determinantal/fermionic/anomaly/lattice shadows it generates | source lane for Clebsch III forward versions; five literature pre-emptions to absorb |

The arcs manuscript was retitled when it acquired the zero-defect matching-design capstone that
earlier work identified as the missing structural complement: `ρ_𝒞(16) = 9` is now an application
rather than a headline.

**The Clebsch assignment changed on 2026-08-01 and supersedes every earlier description of it.**
The public series has exactly **four numbered papers**: rigidity, factorization, the passages paper
(now titled *Golden descent and operator realizations of the Clebsch cubic* in its forward version,
with released versions one and two immutable under the earlier title *Arithmetic and harmonic
realizations of the Clebsch cubic*), and the q13 passant-code paper. The first three have GitHub and
DOI releases at versions one and two; further strengthening is by forward version only. The q13
paper is the active new build. **The golden conference operator is no longer a manuscript** — it is
a source-development lane feeding forward versions of the passages paper, and its first integration
took only the source-operator-cubics-harmonic core plus the determinant-versus-permanent boundary.
Its exchange-statistics material sits in a separate lane-local companion, written as a design-limit
and theory note rather than an experimental proposal. The Paper-I computational companion stays
unnumbered and becomes a forward-pointing evidence companion once the q13 paper is public. The
37-page integrated manuscript *Deep-hole rigidity and factorization memory in the Clebsch hexagon
code* is preserved only as a fallback. The rigidity paper has itself split — a human
core carrying the theorems and a separate companion, *Computational strengthenings of Clebsch
syndrome rigidity*, carrying the fifteen-class, low-degree, cross-field and through-eight-points
classifications, each with its own build target, bibliography, machine-readable claim ledger and
replay routes. The split was chosen over a single
longer manuscript on a cold read, and its cost is stated plainly: the companion's relative replay
paths need a stable artifact locator before either half can ship. The repair-ports venue is stated as
DCC / FFA, explicitly **not** IEEE-TIT. A `lean-proof-engineering-at-scale` methods paper remains
outside the mathematical ship order; any novelty claim there needs its own literature audit.

**Nothing has shipped.** The arcs, Clebsch-rigidity, beyond-four PRS, and AME–LU papers all have
warning-free local candidates, but local reproducibility is not publication. The beyond-four PRS
candidate now has an exact 17-module R5–R7 Lean export, 74-target axiom audit, and a manuscript
ledger reconciling all 42 adopted labels against a 47-artifact evidence pack; the older R5–R9
aggregate is explicitly outside that evidence set. Its public
release still requires two specialist signoffs, a public flake-pinned Lean revision, authenticated
repository/archive publication, identifiers, and author/account confirmation. The AME–LU candidate
has the uniform LU-to-LC core in its aggregate and a separate formal proof of projective finiteness;
the latter still needs aggregate/audit integration, while the Choi encoder and exact GRS
transversal-group consequences remain outside the completed formal boundary. Arcs and Clebsch
likewise still need their explicit external archive/release actions.

**One release verdict has already been reversed by a stricter replay.** The Clebsch passages note
was cut to two independent theorems, cleared its reading gate with no blocking finding, and was
called `GO` — then failed when its verification bundle was replayed from a tree containing only the
declared release files, because a release-critical script reads a file outside the package. Alongside that, two mathematical gates reopened (§3) and one novelty adjective
turned out not to be licensed by the recorded literature audit. The verdict is now `NO-GO for
submission`, and equal counts of statements and trust rows are explicitly not accepted as
statement-to-ledger correspondence. The lesson generalizes past this note: passing inside the private
repository is not passing.

**Maturity boundary:** no paper has been published or externally refereed. Scoped Lean aggregates
and axiom audits are green where stated, but the repository-wide extraction audit is a different
and unfinished evidence layer, and the managed-service success path is not established by those
local gates. The mathematics has also changed materially under checking: the dihedral paper still
carries a known value-affecting case split, the repair-hypergraph transfer theorem required an
all-zero branch and an additional hypothesis, the first PRS paper aggregate failed its manuscript
closure boundary before being narrowed to the exact R5–R7 target, and several proposed Clebsch identifications were replaced by sharp
negative theorems. These are reasons to take the current statements and their boundaries seriously,
not reasons to assign them the status of externally validated results.

**Several papers moved backwards or changed shape on their own evidence, which is the gate
working.** The Frobenius pair-extension paper's former mathematical freeze has cleared: the exact `PG(2,25)` minimum is
semantically `32`, and the five normalized extremal orbits lift to the complete semantic extremal
set; bookkeeping and the exchange graph remain. The dihedral paper was rebuilt as LaTeX on a fixed eight-section
spine, and carries a **known value-affecting correction** as its first release-blocking hazard: an
exhaustive census refuted its own boxed formula, so the affected statements need a case split applied
to the body before any polishing, and the density theorem must stay explicitly conditional on its one
named axiom rather than reading as an axiom-free formal proof. The repair-ports transfer theorem was
likewise found **not exact as stated** and repaired (§3). The continuation paper now claims only the
four-frame rigidity theorem, but its
library is planned rather than built — the hardest formalization in the portfolio, with an external
collaborator recorded as the fallback if it stalls rather than as a first move.

**The one dependency, downgraded.** arcs → Clebsch rigidity was recorded as a *hard* dependency; it is now a
**publication-allocation ruling, not a mathematical one** — `clebsch` reproves the identification, cites
`arcs` for provenance, and depends on no unpublished companion. The games flagship and arcs form a
seam, not an ordering constraint — both cite backwards, neither waits.

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

**Extraction & DOI — the spine now exists locally.** The research repo stays private; publication is
by *extracting* clean self-contained repos — a shared `FiniteGeom` public repo pinned by commit
(never copied per-paper subsets, which drift and silently invalidate the cross-paper adequacy story),
then per-paper repos pinning that tag. Zenodo ↔ GitHub-release mints versioned DOIs. Five released
papers have been extracted to standalone local repositories under a stated convention:
synchronization is **one-way** from the monorepo, changes land as ordinary forward commits, and
destructive history replacement needs explicit authorization. A `finitegeom` **concept DOI** is cited
paper-side, and deliberately only as the version-independent identifier of the separately distributed
formal companion, never as a paper DOI. The extraction is also what surfaced the leaks the convention
exists to prevent — internal task routing presented as a public dependency, task markers inside
evidence filenames, a private-monorepo build mode in a public bundle tool, and a release verifier
that only passed because it reached outside its own package.

**Cross-domain applications** — a shared-dependency resilience analyzer, robust experimental design, a
repair-code compiler, canonical-reconstruction and minimal-conflict engines, a proof-carrying
finite-search platform — are **parked as connections remarks** in their parent papers. Reception risk
is maximal in distant fields, so each is staked publicly at zero audit cost rather than developed. The
recurring, testable nonclaim: path-counts / entropy / disjoint-availability systematically overstate
resilience when the alternatives share hidden dependencies.

**OEIS:** **A344227** (queens nimbers) sits at rev #54 (`n ≤ 13`); a ready package extends it with
`a(14)=0, a(15)=1, a(16)=0, a(17)=2`; its lead is the **refutation** — `G(17)=2` kills the published
eventual-alternation conjecture — and it should be framed exactly that way. A sum-free `Z_n` OEIS
draft + b-file is prepared and verified absent, not submitted. The dihedral family's byproducts were
assessed and mostly **declined on their merits**: one genuine new-submission draft survives —
Node-Kayles on the cycle, `𝒢(C_n)`, which is the indicator `[A002187(n−3) = 0]` and was checked absent
— while the even-cycle slice (trivially all-zero), the template nimbers (constant or plain parity), the
`S₄`/`A₅` regular Cayley values (a finite nine-cell table, not extendable), the value histograms
(sampling artifacts) and the P/N classification over `q` (characteristic functions of arithmetic
progressions) were each rejected with a stated reason. The path sequence is confirmed to *be* Dawson's
chess and is a cross-reference, not a submission. Remaining candidates: torus-queens nimbers, the
sum-free outcome indicator, the Paley-game sequence, and the A316632 extension.

**Shared blocker.** Several deliverables want a **public code/preprint URL that does not exist**. The
A344227 `%H` link and n=18 comment, both sequences' program links, and any arXiv posting are all
waiting on it. The blocker is no longer an engineering task: the extracted repositories exist, pass
their own gates, and are deliberately left **without remotes**, because repository creation, pushes,
releases, identifiers and author/affiliation metadata are all reserved for an explicit authorization
that has not been given. One authorized publication unblocks them together.

---

## 9. Validation gates & reproducibility

The validation policy requires independent checks for promoted computational results. The bullets
below distinguish checks already recorded from the newer repository-wide trust checks that remain
unrun.

- **Queens:** `solver_lineage_agrees` (naive / iso-flat / iso-window / iso-dense return identical
  values) + exact distinct counts (n=12 = **1,060,823**, n=14 ≈ 29.2M) + Jenrich n≤16 reproduction.
- **Othello:** cross-engine value-equivalence (minimax / alphabeta / ordered / strong compute
  identical black-centred values) + the independent grid move/flip reference + exact endgame solves
  **6 / −40 / 4**.
- **Lean:** legacy gate reports record terminal `#print axioms` as `[propext, Classical.choice,
  Quot.sound]`, subject to the named quarantined literature axioms; certificate cap-legality is
  kernel-checked (`decide` / `checkCap_sound`), never `native_decide`. The new extractor has not yet
  reproduced those reports on a project module, and no real project target has completed a green
  managed build.
- **Solver / census cross-checks:** exact solves are confirmed by independent move-order and
  canonicalization variants; the S4 raw memo dumps are rules-checked by an independent early-break
  proof-DAG validator (e.g. q=23: all `241,627,613` records, zero game-equation failures).
- **Spin-off computations:** every computed-exact coding/geometry result ships a replay script
  committed with its sha256; any result promoted to a paper must rerun from the tracked copy.
- **Manifest discipline:** a computation counts as evidence only when `git ls-files --error-unmatch`
  proves its script is tracked and a manifest records path, blob/SHA-256, exact command, and expected
  output. Untracked or ad-hoc artifacts are **not** evidence — adopted after audits found cited
  computations with no durable source.
- **Declared-vs-actual trust check:** the trust boundary is derived from tracked bytes and a Lean
  environment export rather than hand-maintained, and the check **fails when the declaration and the
  tree diverge**. Reviewer declarations are inputs to be verified, never promoted into evidence. Its
  first run found real gaps in the declarations, not in the mathematics (§7) — and the check itself is
  not yet satisfied, since no project module has been extracted.
- **Release gate (§8):** full Lean trust standard — `sorry`-free, axiom-clean, statement adequate to
  the claim, trust-chain note — before any paper publishes. This gate is policy, not aspiration: it
  was tested by the one finished manuscript that had zero Lean, and the ruling was to hold the gate
  and formalize rather than ship first.

**The posture that makes the rest work:** results are stated with their trust tier attached —
PROVED / COMPUTED-EXACT / LITERATURE-IMPORTED / REFUTED — and a claim never outruns its tier. Several
headline claims here have been demoted, scoped, or conceded outright on audit (§8); one claimed
*negative* was overturned by formalizing it (§4). Imported literature theorems are quarantined in
assumption modules and stay visible in the dependent results' axiom reports.
