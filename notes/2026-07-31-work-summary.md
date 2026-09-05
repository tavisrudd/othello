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
- a `sorry`-free **Lean 4 / Mathlib** formalization layer,
- and, newest, an exact compositional optimization compiler (`ergodis`) that turns the recovery
  theory's quotient theorems into a general tool, has since been extracted into its own repository
  behind a tested publication guard, and is being prepared for release under a dual licence.

The open research center of gravity is the **projective cap ("Nofil") program** and its **odd
projective-plane kernel**, with the Lean layer certifying results as they land. But the cap machinery
has spun off enough standalone finite-geometry and coding-theory mathematics — extension, rigidity,
and completion-distance theory about geometric *legality* rather than game value — that the repo now
carries a **publication portfolio alongside the open game programme**. Its original seven-paper
backbone and two OEIS entries have expanded through the Clebsch and projective Reed–Solomon work and
include a quantum-information branch on MDS–CSS AME states, local-unitary rigidity, and transversal
Clifford groups (see §3, §7, §8). The Clebsch work has a **five-paper numbered series**, *Clebsch:
Rigidity from Sparse Shadows*: rigidity, factorization, the passages paper *Golden descent and
operator realizations of the Clebsch cubic*, the q13 passant-code paper, and *The Golden Companion
Correspondence*. The separately titled *Diagonal Isoduality and Transversal Clifford Groups of
MDS--CSS Codes* is an unnumbered companion. The first three released versions one and two share the
earlier title-page identity *The Clebsch cubic: recovering, orienting, and realizing*; Papers IV and
V now have clean standalone manuscript packages. The golden conference operator material is **not**
a sixth numbered paper — it is a source-development body feeding future forward versions of the
passages paper. Downstream of Paper V sits the **cubic-threefold stabilization** programme on
`A₅`-invariant cubic threefolds (§3), which now has two manuscripts of its own: *Irrationality of
Cubic Threefolds after One Stabilization*, an unnumbered epilogue to the series rather than a sixth
number, and *Sharpness of Irrationality after One Stabilization for Cubic Threefolds*, which determines the
level exactly for two explicit smooth cubic threefolds. A short standalone correction note, *Standard Flips of
Discrepancy One*, came out of the same work and is published with a DOI.
[`papers/papers-index.md`](../papers/papers-index.md) is the registry — it maps every result to its
paper and its proof location.

The second cubic-stabilization manuscript now uses quartic-del-Pezzo torsors
and rational torus quotients rather than the retired all-stabilization route.
It proves the exact transition from irrationality after \(\mathbf P^1\) to
rationality after \(\mathbf P^2\) for the two displayed examples.

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

- **Integral secant distributions for complete higher arcs** (`relconic`). A separate eighteen-page
  manuscript lifts the prescribed-hole method to selected block families in symmetric designs. Its
  exact integer degree envelopes have classical variance/expander mixing as their real relaxation,
  while ordered factorizations `λ = uv` index unbounded resonance families with a strictly stronger
  linear coefficient. A modular-lift dichotomy supplies a further surcharge unless the dual
  maximal-secant family is already an exact `λ mod p` multiset; the ordinary characteristic-three
  and relevant even-degree branches exclude that core and give unconditional improvements. The same
  theorem applies to projective point–hyperplane systems and robust nonextendibility of projective
  codes. Human proof, evidence, partial Lean coverage, hostile review, and standalone export pass;
  the bounded literature audit licenses no global firstness sentence.

  The sharp-asymptotics successor is open and deliberately separate. It proves the exact base value
  `t₇(2,9) = 39` by a Hermitian-unital plus five-orbit switch and identifies the nineteen maximal
  secants as a five-character dual blocking core. At `q=27`, the candidate target is a 55-point core
  with spectrum `1^461 2^17 3^78 4^194 5^7`; weak inverse realization would produce a complete
  `(279,19)`-arc from that 55-point core. Three natural symmetry models are excluded;
  Frobenius reduction leaves two canonical branches. The centered incidence descent gives a signed
  word of weight `4q−6`, with no tangents and opposite signs on every support 2-secant. This is a
  structural construction gate, not a completed asymptotic theorem.

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

  **The finite boundary is now closed three layers deep.** No conic-filling arc of size `k=12`,
  `13`, or `14` exists over any finite field. At `k=14`, `q=61` has 96 exact twelve-line mixed
  stars and no extension; `q=67` has no mixed survivor after 946,250,059 recursion states and none
  of its 92 all-passant stars passes the first necessary identity; `q=71` closes both ways, its
  all-passant branch after 22,579,655 states and all 39 mixed stars failing `E₈ = 0`; and at
  `q=73` neither branch has a geometric star. No `k=15` census is planned: these finite closures
  do not substitute for the missing uniform masked Rédei theorem, and the leverage has moved to
  the structural gates below.

  **The saturated-internal branch is now a pure clique bound, and half of it is closed.** Dropping
  the arc condition and keeping only chord externality makes such an arc a clique of size `(q+3)/2`
  in the graph `Γ_q` on the `q(q−1)/2` internal points of the conic, adjacent when their join is an
  external line. Exhaustively for every odd prime power `q ≤ 49`, `ω(Γ_q) = (q+3)/2` for
  `q ≡ 3 (mod 4)` but `(q+1)/2` for `q ≡ 1 (mod 4)`, `q > 5`. So the invariant half **alone** empties
  the branch for `q ≡ 1 (mod 4)` — no arc condition, no Paley eigenfunctions, no
  Baker–Ebert–Hemmeter–Woldar conjecture — and proving `ω(Γ_q) ≤ (q+1)/2` in general closes that
  residue class unconditionally for all fields. It **provably cannot** decide `q ≡ 3 (mod 4)`: there
  `C_ℓ ∪ {ℓ^⊥}` (an external line's internal points plus its pole) is a genuine extremal clique, the
  pole being the unique candidate extension exactly in that class. Separately, Baer-subline
  containment is settled unconditionally for every odd prime power by an exact coboundary identity
  `χ(c−c′) = δλ(c)λ(c′)` on the norm-one circle, which confines the system to one `λ`-coset of size
  `(q+1)/2 < (q+3)/2`; with the affine-line case, containment in any Baer subline forces `q = 5`.
  Coverage by exhaustion is `q ≤ 43` in general and `q ≤ 151` within `q ≡ 3 (mod 4)`.

  **Every prime field is now closed outright, by a different and stronger route.** Coherence of a
  saturated-internal support has a standard incidence model: the support, its Frobenius conjugate,
  and the character-opposite directions together with the trace-zero direction form a **dual 3-net
  of order `(q+3)/2`**. For prime `q`, Blokhuis–Korchmáros–Mazzocca's net classification forces the
  two affine components onto a conic, and the two-line subgroup classification then leaves only
  `q = 5`. No clique bound, no Paley eigenfunction, no conjecture — those earlier statements survive
  as independent checks rather than as the frontier. Only proper prime powers remain, where the net
  order exceeds the characteristic.

  **The extension-field gate is algebraic, and its search space is now three fields wide.** Over
  every odd prime power the two affine components have the complementary-factor form `(x, ±S(x))`
  on the nonroots of `S`, where `RS = X^q − X`, `deg R = (q+3)/2`, `deg S = (q−3)/2`; with `H₂` the
  remainder of `S²` mod `R`, conic containment is exactly `deg H₂ ≤ 2`, equivalently the vanishing
  of one coefficient band of `S³`. The Frobenius-semilinear digit tower untwists in canonical
  ghost-tail coordinates into one ordinary stacked **Cartier–Toeplitz matrix `𝕄_R`** with
  denominator-free entries in the coefficients of `R`, so a surviving ghost is an exact
  determinantal condition. Row counting forces a nonzero kernel only at `q = 25, 27, 81`; elsewhere
  it is a rank-drop stratum whose properness is the thing to prove. The first non-shadow equation
  descends to a pure homogeneous quadratic map on `ker 𝕄_R` for `p ≥ 7`, and stays genuinely mixed
  quadratic/cubic only in characteristics three and five — precisely the three forced fields. A
  top-rung no-wrap bound gives the uniform gap `deg H₂ ≤ 2` or `deg H₂ ≥ (p+1)/2`. Equivalently the
  whole hierarchy is the division-free syndrome law `Σᵢ wᵢ^(2j+1) xᵢ^m = 0` on the roots of `R` with
  `wᵢ = 1/R′(xᵢ)`, where the conic conclusion says exactly that `(wᵢ²)` is a quadratic evaluation.

  Closed, do not retry: density and spectral-stability arguments (Paley sits at edge density exactly
  `1/2`, interlacing is already tight), valuation-versus-Parseval counting, and the coupled
  cross-ratio invariant `g_ij`, whose pigeonhole runs one short in the unhelpful direction.

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
  fall into one `S₄` and three `D₂₄` projective orbits — one octahedral family and three
  chord-indexed punctured-conic families — and **every** orbit spans the code. The reconstruction now
  runs on pair data alone: weighted pair concurrences among minimum words rebuild the passant
  incidence matrix, the code, and the six-class elliptic association scheme, and the resulting group
  action then rebuilds all points and lines of `PG(2,13)`, the conic, and its polarity, with no
  coordinates and **no triple concurrence**; equivalently the weighted 2-section of the
  minimum-support hypergraph is a complete invariant of this marked conic-plane presentation. The
  spanning has a structural reason: the code is 12-dimensional over a canonical operator field `F₈`,
  and that hidden scalar action forces every family to span. Exact positive-semidefinite and
  line-moment certificates now carry the weight-eight and weight-ten exclusions, replacing the
  subset and syndrome searches. The common code/hypergraph/scheme automorphism group is exactly
  `PGL(2,13)`. The paper is retitled **Minimum-word reconstruction of `PG(2,13)` from a binary conic
  code**, and a manuscript-only pre-release was deposited 2026-08-03 at DOI
  `10.5281/zenodo.21783971`, with the Lean companion held back for a forward version. **Priority is
  closer than earlier drafts showed:** Droms–Mellinger–Meyer introduced this same
  passant-line/internal-point parity-check code and bounded its distance, and the Ma–Liu–Tian survey
  records `(q+3)/2 ≤ d ≤ q−1`, i.e. `8 ≤ d ≤ 12` at q=13. The paper closes that interval at the top
  and adds the classification, spanning, reconstruction and symmetry results, for which no
  predecessor was located; Madison–Wu supply the dimension formula and Hollmann–Xiang the elliptic
  scheme. A later audit added one pre-emption and withdrew one claimed contradiction: the underlying
  passant-line/internal-point incidence graph is `X.182.1` in Conder–Potočnik's census of
  **semisymmetric** graphs (edge- but not vertex-transitive; two distinct cubic bipartite girth-12
  graphs exist at order 182 and this is the non-symmetric one), which our own side kernels
  `[91,14,28]` and `[91,14,26]` prove independently, since a part-swapping automorphism would force
  them equivalent; and an earlier reading that this asymmetry contradicts a published equivalence
  claim of Crnković–Rukavina–Šimac is **retracted** — their symmetric-graph paper uses the
  equivalence correctly and their semisymmetric follow-up tabulates both sides with differing
  distances. The proof is human-led with two green Lean surfaces beneath it — shared semantic modules
  carrying the logical spine, and a paper-owned package checking the irreducibly finite leaves in
  small auditable shards — and neither is a claim that the main theorem is machine-checked.

  **The spine is now conceptual rather than enumerative**, which is what moves the paper's central
  claim from an exact classification to an equality theorem. Two replacements did it. The **`q−5`
  line lemma** — every line carries at most `q−5` points of `U(A)` for a six-arc in odd
  characteristic — is proved by a short synthetic argument: the fifteen chords properly 5-edge-colour
  `K₆`, hence one-factorize it; three factor classes normalize to a triangular prism; and the two
  parallelism conditions force `a(b−1) = −1` and `a(b−1) = +1` simultaneously. That alone bounds
  `|U(A)| ≤ 12`, so with the ten-Brianchon bound `c ≤ 10` it forces `c = 10` and closes the
  line-pair branch without a census — and that bound is no longer imported (see below). Separately, the **`A₅` orbit profile `[6, 10, 12, 15, 30, 30, 30]` is *derived*** from
  fixed-point spectra and the subgroup ledger, not assumed; a second off-arc orbit would already
  breach `c ≤ 15`, forcing `c = 10` and identifying `U` with the unique 12-orbit — the conic. The
  1,548-class census survives only as the independent size-gap clause and a regression check.

  **The family formula, replacing an instance.** For *any* Clebsch hexagon over `𝔽_q`,
  `|U(H)| = q² − 14q + 45`; for `q ≡ 3 (mod 4)` every edge is a non-secant of Dye's associated conic,
  so the off-conic excess is exactly `(q−4)(q−11)`. Within that congruence class the conic is the
  whole uncovered locus **exactly at q=11**. The q=19 count of 140 deep holes on no conic is now a
  corollary of the formula, and its checker demoted to independent verification.

  **Both Dye inputs are now proved rather than imported, and machine-checked.** Counting
  triple-concurrence points of a six-arc is counting its concurrent chord matchings, by a bijection
  proved over an arbitrary finite projective plane, and the ten-point bound holds over any field in
  which 2 is invertible. Equality is rigid: at ten triple-concurrence points every chord lies in
  exactly one non-concurrent matching, there are five of them and they share no chord, so they
  one-factorize the fifteen chords; two matchings of a six-set with no common chord close a hexagon;
  and the resulting labelling puts the arc in the golden normal form
  `(1:0:0), (φ:1:1), (0:1:0), (1:φ:1), (0:0:1), (1:1:2−φ)` with `φ² = φ + 1`, over any finite field
  in which 2 is invertible — so attaining the bound **forces a golden root into the ground field**.
  At `q = 11` the roots are `φ = 4, 8`, each with an explicit determinant-three projectivity onto the
  displayed witness. The prism-uniqueness step and the perspectivity theorem (two triangles in double
  perspective are in triple perspective, itself proved over an arbitrary field) are off the critical
  path and unused. Consequently `lean/trust/areas/relconic.toml` now permits **no** axiom.

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
  constructed. All 364 minimum words split into one `S₄` and three `D₂₄` projective orbits, and the
  common code/hypergraph/scheme automorphism group is exactly `PGL(2,13)`. That code is now the
  fourth numbered paper, where the reconstruction runs on weighted pair concurrences alone; see its
  own bullet above.

- **The exceptional code ladder** (`clebsch`, research track) — **proved, and pre-empted; not a
  publication route.** One binary code per exceptional level: restrict the affine linear functions to
  the nonsingular vectors of a mod-2 quadratic space. One repeated operation links the levels — take
  the link of a root, fold antipodal pairs, shorten — giving
  `[496,11,240]_{E₁₀} → [240,10,112] → [120,9,56]_{E₈} → [28,7,12]_{E₇} → [27,6,12]_{E₆}`. The
  240-point member is the root link of an `E₁₀` root and coincides with the affine `E₉` code from the
  affine root lattice; the complementary 256-point root hyperplane is `(E₈ ⊕ A₁)/2`, giving
  `[256,10,120]` against an exact record of 124. **Optimality is not an E-series property:** scoring
  the family by type, every tabulated even-rank level of both types is optimal, minus type included,
  while the parabolic levels are the sole shortfall with a growing deficit — optimal at rank five, one
  below at rank seven, four below at rank nine. That growth is the one unexplained numerical pattern
  left. **Three barriers closed by proof rather than failed search:** no `O₈⁺(2)`-invariant
  dimension-ten code contains the `E₈` code, so the record `[120,10,56]` dimension is incompatible
  with full root-pair symmetry; no Plotkin `|u|u+v|` code at `[240,10]` with length-120 halves beats
  distance 112; and every unsigned quantum lift stalls at CSS distance four, one below the exact
  `[[28,14,5]]` and `[[120,102,5]]` records — the canonical repair alphabet `E₈/2E₈ ≅ F₄⁴` over the
  Eisenstein integers (`ω` acting freely on the 120 coordinates in 40 orbits) does not fix it, since
  the natural nine-dimensional `F₄` code is Hermitian self-orthogonal at exactly the record dimension
  yet still has dual distance four, because conjugation and every `F₄`-linear functional are additive
  and so inherit all 32,130 tetrads as weight-four dual words. **Additivity, not the alphabet, is the
  obstruction**, and it explains the distance-four stall at every level at once. **Why it is closed:**
  the level codes are Calderbank–Kantor two-weight codes (the `E₆` code reaches the same family by a
  second route through its own Cartan-cubic monomial support, landing on the minus-type
  elliptic-quadric two-weight code, so all three are one family read at three ranks); the fold is
  Brouwer–Shult 1990, available as Proposition 3.6.1 of Brouwer–Van Maldeghem's *Strongly Regular
  Graphs* — in the graph on the nonsingular points of a quadratic form over `F₂`, the vertices at
  distance two from a fixed vertex form the Taylor extension of the graph two ranks down, an
  antipodal double cover whose classes are our fold — and that theorem is about arbitrary finite
  graphs under a coclique-parity condition, stated as a **biconditional**, so it subsumes any binary
  converse we could prove; the same book's "Tower and clique sizes" names our bottom three levels
  outright (the 120 root pairs from `E₈`, local graph the **Gosset** graph, itself the Taylor
  extension of the **Schläfli** graph, labelled the `E₆` graph). Finally the code-level fold is a
  formal property of **any** matched Taylor double — every row has fibre-difference all-ones, so the
  fibre-constant subcode is codimension one and folds onto the base graph's code — certified against
  the quadric links, the Paley two-graphs, the pentagon and random graphs, with no quadratic form
  anywhere. An earlier claim that the fold works only at plus type, and so carried content beyond the
  graph statement, was **withdrawn as an indexing error**. What survives in the unmarked code track
  is the weight-enumerator statement and the affine-root-lattice carrier, too thin to carry a paper.
  A later, logically distinct result composes a marked Clebsch entry with the classical tower and
  computes the forgotten marking fibres; it remains research-only pending novelty closure. Two
  narrow frontiers remain: the parabolic deficit, and whether 120 points of `PG(8,4)` can sit in
  four-general position invariantly under a large proper subgroup of `O₈⁺(2)` (not expected to work).
  Audit limits that travel with the material: Chakravarti's 1990 IMA chapter is held at metadata only
  and must be read at full text before any design claim, MathSciNet was not covered so every negative
  keeps a "to our knowledge", and an adjacent code-CFT literature builds stabilizer codes from `E₈`
  root lattices, so no blanket absence claim is available on the quantum side. One caution for the
  Paper IV side: the cross-orbital optimality certificate's Hamming exclusion at dimension forty
  survives by 1.6% on exact volumes — sound as stated, but not transferable to nearby parameters
  without recomputation.

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

- **Exact transfer of bounded linear recovery and relative weight hierarchies** (`complete-ports`) —
  the sweep above matured into a theorem-led manuscript with a paper-local Lean package. Its current
  organizing object is the associated nested pair `K_P ⊆ D_P`, identified canonically as the
  shortening–puncturing pair of the inner dual. The relative generalized Hamming weights of that pair
  are exactly the minimum helper-union costs for recoverable target subspaces of each dimension; the
  dual hierarchy gives the exact failure thresholds leaving each dimension of target ambiguity.
  This yields sharp rank-stratified confinement, the best-target GHW identity, cooperative-locality
  min–max bounds, MDS rigidity, and service-rate and reliability consequences.

  The main transfer theorem is now ungated and exact. It optimizes target-normalized joint
  prescribed-coset support over all maps into the full outer functional dual; the resulting
  `Γ_{j,T}` is precisely the first nonconfined helper cost for target subspace `T`. Below it,
  restriction and zero extension are inverse bijections preserving coefficients and exact supports.
  The earlier RGHW and pointed weighted formulas are specializations. Under repeated concatenation,
  ordinary prescribed-coset costs compose associatively by exact min-plus substitution; normalized
  numerical costs additionally retain intermediate target contributions, while coefficient-level
  composition retains the lift relation. A scalar threshold alone does not compose because it has
  forgotten the functional labels constrained at the next level. The twenty-four-page authority and
  verified standalone export pass; publication remains gated. The human proofs carry these stronger
  results, while the paper-local Lean package verifies four terminals and records the new theorems as
  absent rather than overstating coverage.

  The twisted-cubic–axis seed `[2q+1,4,q−1]_q` has an **exact**
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

- **The coarsest observational quotient, and the compiler that computes it** (`complete-ports`) — the
  transfer and composition theorems above say that a large finite search state is redundant in an
  exactly describable way. That statement was isolated as a theorem in its own right: **the finite
  many-sorted Moore contextual quotient is the coarsest typed congruence**, with classical
  deterministic-automaton minimization as its one-sort corollary. Its minimality half is sharp —
  rank-one outer contexts observe exactly the zero-sector cost and the zero-truncated projective
  line-probe profile, so equality of those two readings is the coarsest numerical contextual
  congruence, and nothing coarser preserves the admitted observations. A companion higher-rank
  small-model package supplies the pointed column-type response theorem, separating contexts of
  length at most `max(2, r+1)` at radius `r`, functional-dual dimension at most `min(t, r)`, and an
  exact dual-shortening identity.

  **`ergodis`** is the executable form of that theorem: a compiler and exact solver for finite
  algebraic optimization problems whose raw combinatorial state admits a much smaller mathematically
  derived quotient. It compiles functional labels, conserved gradings, generated spans, symmetries
  and reconstructible coefficient blocks *before* optimization, delegates generic search to an exact
  backend, and independently lifts and re-checks the returned witness rather than trusting it. The
  same code path has been exercised across linear-code recovery, weighted-tree, resource-allocation
  and hierarchical min-plus control problems against independent oracles. It deliberately does not
  reimplement a generic mixed-integer optimizer: a reduction is in scope only when it needs
  information absent from the emitted coefficient matrix or constraint graph.

  **The automaton corollary is what makes it externally testable.** On the complete published
  explicit Presburger-complement input list of the MATA automata library (TACAS'24) — both systems
  minimizing the same derived, trimmed deterministic automaton, with determinization, trimming and
  parsing outside the timed region — `ergodis` is **2.699x faster in geometric mean** than MATA's C++
  `minimize_hopcroft`, with an instance-level paired-log statistic of `26.20`. It wins every instance
  of at least thirteen states; all losses are on automata of two to twelve. On the development
  controls it is 1.61–3.30x faster than the same implementation with 13–38x lower cold peak resident
  memory, while additionally emitting a compact split transcript and verifying it before returning.
  A native-functor competitor, Boa, remains 2.48x faster on the four-generator random family; that
  crossover is recorded, and no universally-fastest claim is made. **Trust tier:** the quotient
  theorems are human proofs; the benchmark figures are reproducible measurements against pinned
  upstream revisions and a published input list, specific to one machine and to the isolated
  minimization subproblem, and are not an end-to-end claim on the comparison tool's own benchmark.
  Application-level crossover was measured separately and found absent on small and sequential-query
  workloads, so that control is retained as conditional rather than advertised.

  **Where it loses is now measured, not asserted.** The scope disclaimer "not a general replacement
  for a mixed-integer or constraint-programming solver" has been replaced by a frontier: a one-page
  classifier of the instance shapes the compiler can exploit, and a six-row prediction table naming
  three expected losses and three expected wins, were written and cryptographically hashed *before*
  any timing run. Five of six rows landed on the predicted side, with wins of 30.1x, 82.5x and
  1,368.8x against a single-worker constraint-programming control, one predicted loss that instead won
  by 3.75x, and one clean loss in which the compiler declines to answer because the instance exceeds a
  declared width bound. That refusal is worth stating precisely: across a ladder of eight instances
  varying only in weight magnitude there is **no performance crossover** — the margin is flat within
  noise over a sixteen-fold width increase — and then a vertical cliff at the declared cap. The
  frontier there is a constant in the source, not algorithmic degradation. On every row the compiler
  emits a certificate of between eight and 3,600 bytes, replayed in microseconds; the control emits
  none.

  **The one large loss was converted into a win.** The six-resource generic-load scheduling row lost
  by a factor of 13,689 — 163 seconds against 4.6 milliseconds. Certified dominance pruning cut it to
  9.4 seconds with every one of its 632,666 pruning deletions certified and the optimum, witness and
  transition count bit-identical to the unpruned binary. The row was then won outright by replacing
  the layered frontier with iterative branch and bound under a **Lagrangian dual bound whose
  multipliers are derived from the inner maximum**, so dual feasibility holds by construction and the
  checker need only verify nonnegativity; multipliers are integer numerators over a fixed denominator,
  so no floating-point value enters the certificate. The result is **0.41 milliseconds against 4.6, an
  eleven-fold win with a 128-byte certificate replayed in 0.8 microseconds**, against a control that
  emits no proof at all. An independently computed linear-programming relaxation explains why the row
  was winnable — it is bound-closed and conflict-free, so the contest is entirely about the bound —
  and symmetry quotienting was rejected outright because no group exists there to exploit. The two
  routes are complementary, not nested: the bound is weakest where many demands each contribute a
  little, and on two such rows the certified route does not finish while the dynamic program answers
  in milliseconds. **No automatic rule yet chooses between them from the instance alone.**

  **One measured loss stands and is published.** The repair-scheduling row in the headline application
  table uses unit capacities, so the instance never enters the subset descent where the kernel's cost
  lives. A contended companion instance was added to measure that descent, and on solve work alone the
  constraint-programming control is about 4.7x faster there. The compiler still wins end to end by
  4.4x cold, but that margin is the control's interpreter and library import, and the record says so.

  **The verification layer was itself audited.** A whole-code correctness audit — parallel first-pass
  audits of the core library, the search engines and the certificate plane, a vetting pass that
  refuted one finding outright and corrected three severities downward, then a second round restricted
  to the two highest severities — found **no committed result wrong**, and two structural weaknesses:
  checks that could not fail (a verification mode that reported success with every witness unchecked;
  an instance loader whose load-bearing fields silently defaulted, so a misspelled key caused a
  misclassification whose digest still matched), and a working definition of "verified" as
  re-execution, which cannot catch a defect on the prover's side. The adopted remedy is a rule rather
  than a refactor: **every advertised check ships with a failing control** — a test constructing the
  smallest mutation that should make that named check fail, per load-bearing field in isolation — and
  evidence records must describe observed scope through typed fields rather than free-form strings.
  Two claims were flagged as possibly wrong rather than merely unguarded and are owed re-examination.

  **The compiler has been pointed at two new problem classes, with one win and one instructive
  failure.** Asking what happens when the structure is fixed but the data changes continuously gives
  an *optimization congruence* — a quotient through which the optimal value and witness factor, to
  which composition descends, and which every declared event respects. That is the Myhill–Nerode
  condition generalized from language acceptance to optimal behaviour, and where the quotient is
  finite the optimizer collapses to a finite weighted transducer. On coded-repair fleets an event is
  answered in about 1.9 microseconds, flat in fleet size, against a 4.93-millisecond fresh solve at
  16,384 leaves, breaking even after roughly one update. Against a specialized quantum-decoding
  baseline the *dense* form of this idea lost decisively, by 64x to 82x in instructions, for
  structural reasons; that loss produced a from-scratch allocation-free sparse matching decoder which
  now stands **ahead of PyMatching in sixteen of eighteen tested cells by 2.5x to 11.5x**, with the
  margin growing with code distance and largest exactly where superconducting hardware operates. Two
  cells lose, both at a physical error rate fifty times hardware rates. What makes that comparison
  unusually strong is that there are zero minimum-weight disagreements across all 360,000 shots and
  every answer carries a linear-programming optimality certificate the baseline does not produce;
  what limits it is that the family is the repetition code under unit-weight phenomenological noise,
  and the metric is instructions rather than per-round latency. Both limits are stated in the record.
  A **certified predecoder** built alongside it is a sound, general, and *negative* result: it does not
  reach distance nine on the rotated surface code by any of five routes tried, and an exhaustive sweep
  shows the construction **fails by exactly one unit of margin** — a sharper statement than "it did not
  work", and the thing a successor must attack. One correction belongs with this: a distance-one defect
  in the repository's own rotated-surface-code construction left two corner data qubits in no check at
  any distance, one of them on the logical column, so **every surface-code number taken before its
  repair is withdrawn**; every repetition-code number, which is the entire decoder comparison, is
  unaffected.

  The second class is causal: take the admissible contexts to be future *interventions* on a finite
  structural causal model, which reads exact causal abstraction as a quotient to be *computed* rather
  than as a validity check on a proposed abstraction. The spike is technically clean — an adversarial
  review killed the first encoding before any code was written, because pinning a variable produces a
  solution of a *different* model, so the obvious encoding computes plain observational equivalence
  while appearing to typecheck; the repaired encoding agrees with an enumeration oracle on every query
  across six model families and compresses states by up to 84x. Its economic claim nonetheless failed,
  for a reason worth keeping: **hard interventions are idempotent and commutative**, so the number of
  states materialized equals the number of solves a plain memo would perform, measured at a ratio of
  1.00, and the compiled arm never crosses the memoized re-solve. Quotienting the graph is not what
  failed — on the identical search over concrete states the quotient wins by 220x — *materializing*
  the graph is. The two surviving directions follow directly: a compositional lowering that never
  materializes the carrier, and a non-idempotent edit vocabulary, which is the only setting where
  shortest path earns its keep.

  **The same principle transfers to exact quantum-code distance.** Computing the minimum distance of
  a CSS code exactly is an integer program over its coordinates, and two distinct effects were
  separated and measured on the bivariate-bicycle gross code `[[144,12,12]]`. The conventional
  per-logical-class encoding destroys the code's own symmetry, leaving only an order-two matrix
  symmetry out of a source translation group of order 72; a class-independent global re-encoding
  restores the `Z₁₂ × Z₆` action as a genuine symmetry of the model, worth 3.1x by itself.
  Automorphism-orbit symmetry-breaking constraints on top of that give a further 4.2x, for a
  branch-and-bound tree cut from 13,228,127 to 1,010,491 nodes — **13.1x**. The binary passant code
  `[78,36,12]₂` gives 6.5x on top of a solver that already recovers `PGL(2,13)` unaided. Every
  program closed at gap zero, so the distances are certified: `d_Z = 12` for the gross code, matching
  the published value, and `d = 12` for the passant code, matching the independent committed
  computation. **Trust boundary:** the distances rest on the solver's own optimality proof plus
  explicit `GF(2)` invariance checks, and nothing is machine-checked beyond that; the node counts are
  a property of one solver's search — deterministic and exactly replayable from committed logs, but
  reproducible rather than verifiable — and every ratio is specific to that solver and instance.
  Whether the reduction survives on solvers with built-in orbital branching is the open gate on any
  external claim. This result is not assigned to a manuscript.

  **The same front end has since closed distances that published sources left as upper bounds.** The
  entire published lifted-product list of Liu and Marquardt now has exact distances — six codes of
  length 1428 to 1500 whose printed values were randomized upper bounds from `10⁵` trials, every one
  of which turned out tight, so the contribution is the certification rather than a corrected number.
  One of them, `[[1428,186,18]]`, sets a new exact rate–distance record `kd²/n = 42.20`, beating the
  previous exactly known best by 1.245x, found in about 51 seconds of search through a verified
  right-translation anchor reduction worth a factor of 42 to 60. Two codes from a satisfiability-based
  distance solver's own published benchmark set were then settled where that solver records that
  **none of its 46 configurations finished within a 7,200-second limit**: `[[714,100,16]]` exactly, in
  under three seconds of search on each check side, and `[[1768,224,d]]` bracketed at `22 ≤ d ≤ 24`
  against a published `8 ≤ d ≤ 230` — with an independently verified 1,768-coordinate bijection
  proving `d_X = d_Z`, so only one direction needs the remaining exhaustion. The bivariate-bicycle
  `[[756,16,d]]` case is narrowed to `28 ≤ d ≤ 34` with `d` even, by an exhaustion of `5.59 × 10¹¹`
  candidates plus the observation that the all-ones vector lies in the check row space; it remains the
  one unfinished exact distance in the portfolio. **Trust boundary:** each is an exhaustive finite
  enumeration with the attained witness replayed by a second implementation, and nothing is
  machine-checked beyond that. One measured fact constrains what such a certificate may promise: the
  parallel search is deterministic in its conclusion but not in its counters whenever a bound is
  published, giving a five percent spread in candidate counts at eight threads and exact
  reproducibility at one.

  **A certified finite no-go for transversal gates came out of the same machinery.** Over every binary
  CSS code of length at most eight — an exhaustive enumeration of 8,044,851 flags at length eight — an
  X-check weight of at most seven admits no diagonal transversal gate at level three or above of the
  Clifford hierarchy. Hence **eight qubits is the minimum length for a diagonal transversal
  non-Clifford gate**, and at length eight level three occurs only at full check weight, uniquely for
  `[[8,3,2]]`. The proof gap is named rather than absorbed: that code's `±1`-phase gate evades the
  textbook uniform-phase divisibility argument and yet lands exactly on the threshold, so the
  threshold is not explained by that argument. Alongside it, complete diagonal transversal groups were
  computed for several small codes by Smith normal form over all real phases, giving exact
  classifications for `[[16,4,2]]`, `[[32,5,2]]` and `[[31,1,3]]` and exact negatives for the Steane,
  `[[15,7,3]]` and Shor codes.

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
`ℚ(√5)`, and the displayed golden configurations are the complete reduced local fibre. A referee
correction pass has since hardened both halves of that: the reduced-branch-cycle and `xyz`-fibre
arguments now run on Hitchin's compact incidence trichotomy instead of a count of real regular
configurations, Hitchin's degenerate divisor and degree-ten invariant enter without a normalization,
a height-one normality lemma fixes `d = 3` in the Stein algebra, and the two-regular locus is stated
as the principal open set `D(σ₃Δ_t)`. On top of
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

**Two recognition theorems are proved and machine-checked but not yet in the manuscript.**
*Four-shadow recognition*, now at full generality rather
than on a normalized family: for an arbitrary symmetric zero-diagonal `±1` matrix, nonzero
proportionality between the triangle cubic and the commutator-Pfaffian cubic characterizes the
golden conference switching class, and the two orientations are projectively isolated. The mechanism
is a switching reduction — diagonal switching multiplies the commutator-Pfaffian cubic by the product
of the six switching signs and leaves the triangle cubic unchanged, so switching by the root row
carries any such matrix into the normalized family with its proportionality constant and conference
square intact — and one relabelling plus one fixed diagonal switching then carry every such matrix
with square `5·1` onto the displayed conference matrix, which is uniqueness of the conference
switching class. *Aligned-design faithfulness*, at the manuscript's own quantifier range: for every
two-graph on a finite point set with `|V| ≥ 7`, the aligned four-sets determine the triangle values
on distinct triples up to one global complement bit; rooting at a point of an aligned four-set with
triangle bit zero kills the anchor's six edges and replaces the two switching normalizations, so
general transport, seven-point distinctness and the finite-set extension all fall out of one proof;
the decoder's query family is explicit with cardinality `3n² − 23n + 45`. Around them sit three exact
certificate facts: aligned certificates at seven points have distance exactly two and correction
radius zero (whole spectrum even, by edge-toggle parity); the scalar third cut moment separates all
four order-26 classes, so the full histogram is unnecessary; and conference contraction forces the
two-pivot plane, with coherent pentads and spanning aligned hexads reducing to intercalates in the
Latin classes and Pasch configurations in the Steiner classes.

**A two-graph literature audit has found two defects in that material, and one of them is
mathematical rather than bibliographic.** *Attribution:* the faithfulness theorem's defining hypothesis — the four
triangle values on every 4-set sum to zero — **is** the definition of a two-graph verbatim, and its
proof opens with the descendant correspondence (fix `r`, form `G_r` on `V∖{r}` with `ij` an edge when
`τ(rij)=1`), i.e. the standard two-graph/switching-class machinery under a private name and without
citation. The same applies to the rigidity paper's use of the four-point identity. Fix in both:
cite Brouwer–Van Maldeghem §1.1.12 (with Higman/Taylor for regular two-graphs and Seidel for the
Seidel matrix and switching) and call the identity the descendant relation. *Benchmark, and the
exposed part:* the manuscript names the closest general benchmark as eventual reconstruction from
local size **five** for arbitrary 3-uniform hypergraphs, but the paper's own literature ledger is
right and the sentence is wrong — the closest benchmark is Dammak–Lopez–Pouzet–Si Kaddour's
**four**-local reconstruction up to complementation for ordinary graphs, valid for `4 ≤ k ≤ v−3` and
hence at `k=4` from `v ≥ 7`. Four and seven, the same two numbers. That coincidence is unexplained:
two-graphs on four points are switching classes (8 of them) rather than graphs (64), so two-graph
4-hypomorphy up to complementation is a *weaker* hypothesis with a correspondingly weaker conclusion,
and neither theorem immediately implies the other. **Whether the two-graph statement is a corollary
of the graph statement or genuinely independent must be settled before the next revision** — it is
cheaper than another literature round. No two-graph reconstruction theorem was located anywhere at
full search strength; Seidel's 1976 and Seidel–Taylor's 1981 surveys could not be obtained and are
carried as access gaps rather than negatives.

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

### Human-proof closure across Papers I--IV

- **Paper I.** The order-eleven inverse theorem is unchanged. The genuine correction is adjacent:
  the characteristic-five projective stabilizer is `S₅`, not `A₅`, because
  the golden roots coalesce. The manuscript now exposes the full six-node exhaustion and five
  chartwise reduced Gröbner certificates and limits its concurrence-spectrum priority sentence to
  the proved seven-value form.
- **Paper II.** A false universal finite-group socle theorem has been removed. The all-field
  completeness proof now uses only its actual detector channels — Steinberg absence, normalized
  linear and prime-field Fischer detectors, the complete opposite-parity root-defect seam, affine
  contraction, Faber's tame subgroup theorem, and an explicit `q=9` endpoint — while preserving the
  theorem and making the endpoint lift intrinsic.
- **Paper III.** The rational degree-two incidence field is proved paper-locally to branch exactly
  over the reduced sextic `J₀=0`, with `ι_t^*J₀=16σ₃²`; the two conjugate configurations are the
  complete reduced fibre with residue algebra `Q(√5)`. The integrated upgrade also proves the
  order-six triangle--Pfaffian recognition theorem, corrects the signed norm identity, and states
  precisely that deck exchange preserves the unmarked algebra while reversing the marked generator.
- **Paper IV.** The human proof now prints the orbital representatives and transport, integral
  scheme-product rows, parity products, `F₈` Frobenius descent and commutant argument, and orbit-Gram
  concurrence rows that had previously been implicit. No false field case, sign, polarity,
  reconstruction, or headline theorem remains; full Lean closure and public release remain.

### The fifth Clebsch paper and the common reconstruction profile

- **The marked companion round trip.** *The Golden Companion Correspondence* is the eleven-page
  fifth numbered paper. Paper II's five-dimensional residue is the chordal member of the same
  `A₅`-invariant cubic pencil as the conference member in Papers I and III. Its rational-normal-
  quartic singular locus recovers the original six-axis carrier, and the normalized outer
  difference gives the oriented inverse on the actual image. The chordal line is necessary marking;
  forgetting it destroys canonical reversibility. The theorem records this image and base-change
  boundary instead of claiming that an arbitrary cubic in the pencil comes from the construction.

- **The normalization–residue theorem, now the paper's closing structural result.** Adjoining the
  half-sum to `Z⁶` gives the `D₆` weight lattice `D₆^∨`, the minimal over-lattice preserved by
  `φ = (I+B)/2`; since `φ² − φ − 1 = 0` it carries the **maximal** golden order `Z[φ]`, while the
  equivariant endomorphism ring of `Z⁶` itself is the index-two order `Z[√5]`. Reducing mod 2 gives
  a 3-dimensional `F₄`-space whose commutator submodule is its unique nonzero proper submodule,
  the quotient is the trivial line, the extension is nonsplit and unique (the Ext group is a single
  `F₄`-line), and that submodule is canonically the six-point heart `Aug(F₂⁶)/⟨1⟩` on which `φ̄`
  acts as one of the two primitive endomorphisms `ω, ω²`. Reversing the golden orientation swaps
  them, exactly as the outer coset of `N_{S₆}(A₅)/A₅` does. **So the golden orientation torsor the
  series reconstructs is canonically the exotic `F₄`-gluing torsor** — the bridge the stabilization
  programme below is built on.

- **The conference cubic's six nodes, determinantally and in every characteristic.** The conference
  triangle cubic is the determinant of the three-by-three matrix of linear forms assembled from the
  coordinate functionals on the two eigenspaces of the conference matrix. Its singular locus is
  exactly the rank-at-most-one locus of that matrix, and that locus is exactly the six coordinate
  tensors, so the cubic has **exactly six ordinary nodes in every characteristic outside `{2,3,5}`
  in which five is a square**. This is a computer-free proof; it supersedes an earlier Gröbner
  certification over `F₁₁` (projective dimension zero, degree six, six distinct rational singular
  points with rank-four Hessians, against the chordal sheet cubic as a control returning Hilbert
  polynomial `4d+1`), which survives as an independent replay. It also recasts the paper's geometric
  contrast as Segre against Veronese.

- **A common theorem, with typed fibres.** The five papers do not share one shadow functor on one
  category. They do share a reconstruction-profile calculus: each sparse shadow recovers its
  carrier up to a stated projective orbit, orientation involution, homogeneous fibre, or marking
  torsor, and every minimality claim carries its own collision or lower-bound witness. A calibrated
  odd datum kills the recurring orientation `C₂`; Paper V adds the chordal marking necessary and
  sufficient for exact oriented return. The strongest series sentence available is: sparse shadows
  recover carriers, and their exact fibres measure what was forgotten.

- **Classical tower, nonclassical marked entry.** The unmarked quadratic
  `E₆ → E₇ → E₈ → E₉ → E₁₀` fold and its root-pair/Gosset/Schläfli bottom are classical. The
  surviving finite-carrier result is their exact composition with a sparse marked Clebsch entry:
  an oriented golden double-six selects the `E₆` carrier, the tritangent-support kernel recovers its
  bare line geometry, and a residue flag makes every higher fold reversible. Forgetting the flag
  leaves explicit fibres; already at `E₆` one bare carrier supports 432 golden, 864 ordered
  operator/apolar, or 1,728 full Paper-V gateway markings. This composition is research-only until
  its novelty boundary is closed.

- **A proved arithmetic upgrade held outside Paper V.** The extension-field census is the inertia
  stratification of the tame icosahedral quotient with branch signature `(2,3,5)`: disjoint degree
  12, 20, and 30 strata, a free complement, a uniform finite-field split-type formula, and a zeta
  function. The stronger relative theorem over a localization of `Z[√5]` remains open at integral
  good reduction and unit control, and the proved census stays outside the manuscript until its
  classical attribution and larger certificate close.

### The cubic-threefold stabilization programme: the exotic cubic realization

**Two manuscripts, both complete drafts and neither submitted.** *Irrationality of Cubic Threefolds
after One Stabilization* is the unnumbered epilogue to the numbered series — deliberately not a
sixth number — and proves its headline unconditionally. *Sharpness of
Irrationality after One Stabilization for Cubic Threefolds* proves that the first
rational stabilization of two displayed smooth cubic threefolds occurs at
level two. Priority closure is open for most of the research material around
them.

- **The carrier, and why the exotic sheet is forced.** Roulleau's pencil of `A₅`-invariant cubic
  threefolds. Its six `D₅` axes have Gram `6I − J` and Winger's five `A₄` quotient axes have Gram
  `3(5I − J)`; the two discriminants meet exactly in the unique `(Z/3)⁴` heart, forcing the generic
  three-primary gluing. The five marked principal halves of `(E⁵, 6I−J)` form one Hecke packet with
  discriminant geometry `P¹(F₄)` — three classical `S₆` sheets, two exotic `A₅` sheets, every edge a
  primitive multiplier-four neighbour with Smith kernel `(Z/2)² ⊕ (Z/4)⁴`. The `F₂` gluings preserve
  `S₆` while each `F₄` gluing has stabilizer exactly `A₅`, so **strong Torelli puts the cubic family
  on the exotic pair** — the same two-element torsor Paper V's golden orientation supplies. On the
  quartic side, unimodular standard-type `S₆` lattice rigidity forces the `A₅` root–weight lattice
  with stabilizer `Γ₀(6)`, so the quartic period closes up on `X₀(6)` with cusp widths `1,2,3,6`.
- **Exact level two for two explicit cubics.** If a smooth quartic del Pezzo surface `S` over a
  characteristic-zero field has a rational point and stably permutation geometric Picard lattice,
  then `S × A²` is rational. A descended unimodular tangent section for the projectively linear torus
  action gives the rational Rosenlicht quotient. Applied to both Tschinkel–Zhang cubic families, it
  proves `X_{j,r} × P²` rational for every member; combined with one-step irrationality, the two
  displayed smooth cubic threefolds satisfy **`ℓ_Q(X) = ℓ_C(X_C) = 2`**. Equivalently,
  `Y = X × P¹` is nonrational over `Q` and `C` but `Y × A¹` is rational over `Q`. Exact Cox-weight,
  saturation, tangent, inverse-graph and Bézout replays support the human proof; no Lean coverage is
  claimed. The synchronized ten-page release candidate remains behind fresh hostile-referee rounds,
  with no push or replacement deposit.
- **The elliptic modular resolvent is explicit.** A separate eleven-page companion identifies the
  signed nonstandard `A₅` cubic parameter with the sign/discriminant resolvent of the relative
  norm-axis elliptic two-division cover: `T = 81t²`, `r = 9t`, base `X₀(6)`, exact `A₃` monodromy,
  cusp widths and modular-interior boundary values. At the chordal value, an orbit-and-ideal
  certificate gives the reduced twelve-point icosahedral divisor subject to the stated secant-cubic
  identification. Golden orientation selects the cyclic cubic splitting cover and gives
  `t = 3(η(3τ)/η(τ))⁶`. Independent algebra and subgroup enumeration replay under the paper gate.
- **Proved fibrewise.** For all twenty `A₅`-stable principal gluings of `(E⁵, 6I−J)`, the rank-15
  fourfold-divisor-intersection lattice is saturated in its rational span; on the exotic gluing a
  15-term identity plus coprime Smith types `(1¹⁴,7)`, `(1¹⁴,17)` force `Θ⁴/4!` into it. Hence
  **every smooth `A₅` cubic in the pencil is universally `CH₀`-trivial** (Voisin) and **its
  intermediate Jacobian satisfies the integral Hodge conjecture for one-cycles**
  (Beckmann–de Gaay Fortman). On the smooth family the Picard gate also closes: the exotic marking
  cuts mod-2 elliptic monodromy `S₃ → C₃`, the order-three generator satisfies `M²+M+I ≡ 0 (mod 2)`
  and fixes no vector of `J[2]`, so every symmetric-line-bundle torsor has a unique invariant
  quadratic refinement and the primitive relative class exists with no extra cover (cusp widths
  become `2,2,6,6`).
- **One crown left, and every cheap route to it closed.** The open question is whether the relative
  rationally connected Abel–Jacobi lift has odd index — an exact 1-vs-2 dichotomy, since a Hecke
  conic already gives a degree-two closed point on a proper compactified generic fibre. Closed
  negatively by exact calculation: the charge-two universal-sheaf gerbe has period and generic index
  two (cyclic algebra with nonzero residue on Druel's Luna slice, surviving the marked base change),
  both type-`(5,1)` carriers reduce to it, the twisted-cubic route dies because all 680 degree-three
  divisor products span a saturated rank-50 lattice — the full rational codimension-three Hodge
  space by skew Howe duality — with `Θ²` pairing ideal exactly `2Z`, and the universal-sheaf `c₃`
  escape dies on a mod-2 invariant census through Wu's formula. A degree-15 factorable-quadric
  packet (prime over `Q`, two independent CAS replays) makes the generic charge-three and
  unordered-theta fibres 2-equivalent but is an odd multisection, not a zero-cycle. Shen's centered
  cycle is existential rather than canonical, and its halving obstruction is a higher-Chow class
  whose geometric halves form a torsor under `CH₁` 2-torsion of the theta sum divisor, **not** under
  `J[2]`; the exact positive residue is an odd-degree descent theorem.
- **Two uniform theorems extracted.** (i) *Jordan-scalar minimal class:* for every principally
  polarized elliptic-power quotient whose self-dual gluing is scalar on each local Jordan block,
  `Θ^(g−1)/(g−1)!` lies in the integral divisor-product lattice — mixed-adjugate proof, primitive at
  `p=2`, covering every scalar type-`A` gluing `G_N = NI − J`, `N ≥ 3`; the exotic cubic gluing is
  non-scalar and a genuine exception. A bounded priority audit puts the likely new crown in the
  primitive integral divisor-product saturation, since Weyl ppavs, `X₀(N)`, elliptic-product
  decomposition, IHC and minimal-class algebraicity are prior art. (ii) *The defect boundary:* a
  literal power `E^g` is always primitive; a quotient of `pI_g` by any maximal isotropic subgroup has
  defect dividing `p^{v_p((g−1)!)}`, so primitive for `p ≥ g`; an arbitrary degree-`D` isogeny has
  defect only at primes dividing both `D` and `(g−1)!`. Defects genuinely occur — exact index 2 in
  every `g ≥ 3`, 3 in every `g ≥ 4`, 4 in every `g ≥ 5`, by a spectral stabilization theorem — so
  "all gluings are primitive" is dead and the obstruction is a Tor boundary, not an Arf invariant or
  Steenrod square. Squarefree symmetric slope ⇒ primitive at every prime; the converse is false at
  odd primes, so the live classification is by `p`-typical nilpotent height.
- **The irrationality half (one-step stabilization), unconditional.** "Quantum" means quantum
  cohomology; the computations are classical and exact. Inside the ordinary, non-enhanced Hodge-atom
  package of Katzarkov–Kontsevich–Pantev–Yu, isolate the atom carried by the double zero packet of
  the cubic small quantum connection and attach to it a rank-two atomic residue discriminant `δ♯`,
  defined by a canonical elementary modification of the even rank-two block. The cubic atom has
  `δ♯ = 4/9`; the only curve whose atom could carry the same Hodge representation has genus five and
  there `δ♯ = 0`; surface representatives die on parity ranks plus the classification of minimal
  surfaces. The ordinary Hodge-atom non-rationality criterion then gives: **`X × P¹` is irrational
  for every smooth complex cubic threefold.** Kuznetsov's birational correspondence carries the same
  conclusion to every smooth prime Fano threefold of genus eight.
- **The second, conditional proof, and what it costs.** The finer invariant `ν₆` — the number of
  primitive-sixth framed formal-monodromy eigenvalues of the numerical small even quantum connection
  — satisfies `ν₆(X) = 2` and `ν₆(X × P¹) = 4`. The product formula is unconditional; the blow-up and
  projective-bundle formulas each rest on one stated hypothesis, on the reconstruction tail and on
  divisor-tagging specialization. Under both, `ν₆` is birationally invariant through dimension four.
  The tagging hypothesis has since been narrowed to surface centres that are neither minimal nor
  geometrically ruled: specialized primitive-sixth vanishing is proved for every Hirzebruch surface
  by one deformation to index at most one, an explicit rank-four Euler quartic and its discriminant,
  and a non-collision argument for the centre specializations, with the quadric surface handled by
  the Gromov–Witten product formula instead. Full stable irrationality is **not** proved by this
  paper, and the `ν₆` argument first fails at `m = 2`, where cubic self-carrier centres enter.
  Source-level audit fixed the ambient object: the reduced cubic quantum module is the irreducible
  hypergeometric `H(0,0,0,0;1/3,2/3)` with local formal ranks `1,1,2`, killing the old plan of
  globalizing the rank-two block as a proper subobject, while the local sectorial Stokes lift has
  ordered ranks `1,2,1` and isolates the zero-exponential atom canonically.
- **The separation, and why the known criteria do not reach it.** For every smooth member: `X`
  universally `CH₀`-trivial while `X × P¹` is irrational. That is a strong separation between
  universal `CH₀`-triviality and one-step stable rationality, and explicitly **not** a claim of
  stable irrationality. Every moduli point of the pencil but the Fermat point lies outside
  Colliot-Thélène's separated-variable locus — a single named exception now, not "all but finitely
  many". All but finitely many members lie outside the Yang–Yu–Zhu coprime-degree locus, because
  every member of their normal form carries an Eckardt point while the generic pencil member carries
  none. That Eckardt statement is proved from complex reflection groups, not by elimination: an
  Eckardt point is the centre of a reflection fixing the defining form, those reflections generate an
  irreducible rank-five complex reflection group when the automorphism group acts irreducibly, and
  three is an invariant degree of only `W(A₅)` (the singular Segre cubic threefold) and `G(3,p,5)`
  (the Fermat cubic threefold) — so exactly two pencil members carry Eckardt points, interchanged by
  the normalizer of `A₅`, thirty each, both Fermat. Voisin's criterion is unreachable by any
  elliptic-product route: with the exotic two-primary gluing kernel the only odd-degree product
  factorization of the intermediate Jacobian is `1 + 4`, realized at odd index 25. The residual
  question — whether the four-dimensional odd-degree factor is a Jacobian — is closed negatively in
  genus four for all but finitely many members, leaving a genus-five route through an isogeny of
  degree greater than one.
- **The all-`m` manuscript, conditional.** The Gamma integral structure turns the class of a point
  into a flat covector that reads ordinary rank; the question of when its vanishing on a
  formal-monodromy packet is a birational invariant reduces to one marked continuation problem at
  each threshold of a single equivariant cobordism. Granting that continuation — a gauged-admissible
  marked Włodarczyk completion plus two stated marked threshold-compatibility hypotheses, at every
  finite Artin truncation — **`X × Pᵐ` is irrational for every smooth complex cubic threefold and
  every `m ≥ 0`.** The endpoint contrast is unconditional and the transport is proved under the
  gauged-admissibility conditions; what is not proved is the threshold comparison, an isomorphism of
  the two adjacent cyclic Rees `z`-modules intertwining formal monodromy and carrying the marked row.
  A marked Gamma/window continuation conjecture, new to that paper, would supply them.
- **A verified alternative route.** An independent audit of a *direct* route through the ordinary
  quantum `D`-module confirms it proves the one-stabilization theorem after one local repair: the
  intrinsic and asymptotic projective-bundle modules must be compared inside Iritani–Koto's common
  faithful ring, not through a nonexistent embedding of one completion into the other. That route
  compresses the needed input to even rank two, nonzero nilpotent, and nonzero modified-residue
  discriminant.
- **Formal verification.** The epilogue carries a bundled Lean companion at the numbered series'
  standard — no `sorry`, no compiled-evaluation axiom at any terminal, no project axiom standing in
  for a proof. The headline is anchored to the atomic route; kernel-checked underneath it are the
  rank-two residue rigidity algebra, the normalized Sylvester gauge shared by the cubic block
  reduction and the spectral-factor gluing, block diagonality of a pairing on separated spectral
  factors, the order comparison selecting the exotic gluing, invariance of the residue discriminant,
  the all-degree graph saturation theorem fed by the six-axis local chart, and the unconditional half
  of the genus-eight corollary. The discriminant group of the source polarization is built with its
  `Q/Z`-valued pairing and splits at two and three, and selection of the exotic member is formalized
  as Frobenius marking: scaling by a non-square scalar is an odd label permutation whose action on
  the discriminant heart is exactly the transported Frobenius involution, so no group-invariance
  hypothesis can replace the marking. Still supplied rather than proved: identifying that
  matrix-level equivariance with the equivariance of an actual relative isogeny, and marking the
  actual geometric kernel.
- **A published spin-off correction.** *Standard Flips of Discrepancy One: Extremal
  `J`-Normalization* supplies the two steps Shen and Shoemaker's proof chain omits at `r = s+1`,
  `s ≥ 1` — the case containing every codimension-two blow-up. The degree-`d` summand of their series
  has `z`-order at most `1 − s − (r−s)d`, hence at most `−1` for every `d ≥ 1` there, so the series is
  already `J`-normalized with no mirror-map correction and uniqueness of the `J`-slice of Givental's
  cone identifies it with the extremal `J`-function; the cone membership is proved rather than
  quoted, from Brown's toric-fibration theorem with Coates–Givental twisted theory for projective
  bundles and a flag-bundle pullback with a deformation to the associated graded in general, neither
  restricting `r − s`. The only remaining formal failure is the degenerate endpoint `(r,s) = (1,0)`,
  whose point fibres contain no extremal line. Second, at discrepancy one the printed Barnes sector
  is unavailable — their own aperture theorem gives the wider opening only above discrepancy one —
  and the correct half-width sector still meets the neighbouring one in an open sector of opening
  `2π` containing both the nonzero-eigenvalue ray and the tame ray. Their conclusions then extend to
  every standard flip of discrepancy one, with nothing else in their argument altered.

### The golden conference operator source programme

**Not a paper.** This material was once carved out as a Clebsch-family manuscript; under the
2026-08-01 portfolio decision it is a source-development lane whose mathematics is selectively
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

- **A second audit, at full parameter strength, adds three verdicts and one free upgrade.** The
  `2-(10,5,16)` design of the 36 extremal order-ten cut halves sits in a **parameter family that is
  not merely known but exhaustively enumerated** — Morales–Velarde count 27,121,734 resolvable
  `2-(10,5,16)` designs, of which 2,006,690 are simple — so no novelty attaches to the parameters and
  the contribution is identifying *which* member the conference structure produces. The free upgrade
  is attached to the same source: every resolvable `2-(10,5,16)` is automatically a `3-(10,5,6)`, and
  the programme's 72 blocks arise as the two halves of 36 cuts, which is a natural resolvability
  candidate — **if it is resolvable it is a 3-design at no cost**, connecting it to the programme's
  other 3-design results. That is a small computational check and worth taking. "Biangular tight
  frame in dimension nine" is a **named published concept** with its own literature and must be cited
  rather than used as if generic. Against that, the three Paley 3-designs `3-(14,7,35)`,
  `3-(18,9,63)` and `3-(18,9,84)` have **no predecessor located at full search strength** — exactly
  the discriminating parameter queries that earlier hygiene constraints forbade — and the Sylvester
  cut-frame identities `K² = 10K + 75I` and `(K−5I)² = 100I` were not located either, though the
  setting (Sylvester graph, Bose–Mesner decomposition) is classical machinery rather than a new
  object.

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

- **All characteristics, and the maximal-carrier discriminator.** The main classification theorem's
  characteristic restriction `p > r−1` is replaced by "`p` odd, or `p = 2` and `r ≥ 8`", proved via a
  level-uniform polar rank lemma together with a trapped-row-space proposition read branchwise off
  the recursive component table, and the containment itself is strengthened to split-free subset
  persistence. The imported radius and weight theorems the argument consumes were re-verified to
  carry no characteristic hypothesis of their own, so the strengthening is genuine rather than
  inherited; `GF(64)` is now closed by theorem rather than by computation. Separately, the
  maximal-carrier discriminator resolves at every level: each maximal Lucas carrier is the
  penultimate nucleus of the next rational normal curve, with a prime-power Frobenius-quadric
  quotient. `GF(27)` is closed in pointed form by an authorized large two-point-switch certificate
  rather than structurally, and the `GF(16)`/`GF(32)` certificates were rebuilt under the correct
  degree-ten action after the originals were found to use the wrong group.

- **Redundancies eight through ten — field-ranged closure.** The fixed-level package now proves
  exact deep-hole classifications at redundancy eight for `q ≥ 43`, redundancy nine for `q ≥ 53`,
  and redundancy ten for `q ≥ 59`. At each level only the persistent tangent and conjugate-secant
  families remain, of size `q(q+1)²/2`, with orbit law `T/T^r` modulo inversion and Frobenius
  (`r = 7, 8, 9`). The revised 56-page candidate makes the R5–R10 layers, radius gates, and
  characteristic boundaries explicit; its replay, Lean boundary export, standalone mirror, and
  release checks are green. This remains a field-ranged result, not the general deep-hole
  conjecture.

These results combine exact invariant theory, Plücker inversion, Gale duality, catalecticants and
apolarity, finite-group descent, low-genus point bounds, and independently replayed bounded
classifications. They do **not** prove the general Reed–Solomon deep-hole conjecture.

- **The exceptional behaviour is now reduced to one conjectural inequality, and two routes to
  proving it are closed.** Writing `X(r)` for the set of field orders at which the deep holes exceed
  the persistent locus together with the modular carrier's deep part, the standing conjecture is that
  for every redundancy `r ≥ 6` and every prime power `q ≥ max(16, r+3)` the deep holes are exactly
  that union — equivalently, `X(r) ∩ {q ≥ r+3} ⊆ {7,8,9,11,13}`. The **constant threshold sixteen is
  far below the proved threshold**, which is 29 at redundancy six and 59 at redundancy ten. Its
  support is exhaustive censuses at redundancies three through ten, complete non-regular
  classifications over *all* prime powers at redundancies eight and nine, and certificate-backed
  stratum sweeps reaching redundancy 39 and field order 127 in which none of the 171 in-scope cells
  fires. The two hypotheses beyond `r ≥ 6` turned out to be the two branches of that single
  inequality, crossing at redundancy thirteen, each independently necessary with an explicit witness;
  the linear branch is already slack, so the true boundary is a curve, located above two known cells
  and below a third, and deciding whether it flattens needs two cells out of budget by one factor of
  `q²`. Three predecessor conjectures were **falsified by exhaustive computation** on the way — the
  persistent-locus-only form, killed by an exhaustive census of all 883,708,281 points of the
  projective eight-space over the field of thirteen elements which found one extra orbit; the
  monotonicity of the exceptional band; and two successive guesses about which carrier shapes recur —
  while one underlying fixed-locus lemma is **proved**. Both proposed routes to rigour are closed by
  located obstructions rather than by exhaustion of effort. The Lang–Weil route fails for every
  carrier: its error constant is about `6.5 × 10¹⁴` at redundancy nine and still around `10⁶` with
  Betti-number bounds, against an observed switch-off at sixteen; the residual does not decay; and its
  irreducibility hypothesis fails exactly on the persistent points. The multiplicative-subgroup
  incidence route fails on both gate questions, since the relevant subgroups grow like `q` where the
  machinery needs `q^{2/3}`, and every stratum-local statement is vacuous on the regular orbits — which
  are the entire residual at redundancies eight and nine. **What no stratum-local tool of any kind can
  reach is the class of orbits with trivial stabilizer**, and the named handle for it is the Borel
  normal form.

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

The referee-repaired quantitative bridge closes the printed `m = 2` proof scope without losing the
headline radius or constant. A dimension-only `8ε` rounding corollary is now adopted in Paper I:
the physical Pauli correction remains globally uncontrolled, but stabilizer cancellation removes it
on one chosen logical input leg. A second external review repaired the phase convention, restored
the exact qubit and AME–QMDS literature boundary, added the missing related-work scope, and
renamed the encoder consequence as factorwise transversal rigidity. The corrected Paper I and its
companion pass their local release surfaces; mirrors remain synchronized and unpushed. A third
external referee edit packet has since been applied in full: a phase-sign correction and the missing
empty-complement corner in the quadratic-growth corollary, the `c = 0` branch of the rounding lemma,
explicit traceless local logarithms in the main rounding theorem, a direct binary-MDS argument
replacing an appeal to the general case, and five attribution and bibliography corrections.

A stronger fixed-party inter-code theorem is proved but not yet promoted into the manuscript: for
odd-prime `[2m,m,m+1]` MDS codes, equal-phase CSS states are LU-equivalent exactly when the target
code is diagonally equivalent to the source or its dual. Its code/dual criterion matches all
twelve earlier party-image rows. The high-distance multiplier line and the five prime-field
holonomy-centralizer types are likewise settled and banked; the proposed extension-field and
affine programmes remain negative or structurally blocked.

**The quantitative tail has been replaced by intrinsic structure.** In place of a five-order case
list, the paper now carries the intrinsic block-diagonal endomorphism algebra together with a
common-holonomy-centralizer theorem, with its five prime-field algebra types and determinant-one
unit-group types classified, forced nonscalar endomorphisms through six parties, and the induced CSS,
Hermitian, dual-number and multiplicity-code module structures identified; a four-entry constructive
classifier makes it usable rather than only descriptive. The multiplier space of the companion
manuscript was identified as the standard code conductor and Schur-square defect, which supplied the
exact general CSS conductor block equations and sharp dimension and support bounds for conductors
between unequal-dimension MDS codes — the manuscript's own lemma is their equal-dimension
product-Singleton endpoint. Three superseded quantitative routes were deleted rather than
weakened, the secondary quantitative appendix was compressed to its stabilizer-independent structural
core (the two-uniform local-generator isometry, projective discreteness, the local quadratic
stability estimate, and the Fisher interpretation), and every surviving statement kept its hypotheses
and its exact-to-robust spine. Two independent readings of the complete paper reconstructed the exact
and quantitative theorem chains end to end with no scope, constant, characteristic, or
field-linearity failure.

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
  **That rematching has since been attacked directly, and the target is now sharper and smaller.**
  Two edge relations were compared. The sparse one, joining a new defect to a consumed label when the
  line through them carries a point of the residual, is false as a universal invariant — nearly a
  fifth of the exhaustively enumerated exchanges over `𝔽₁₁` are Hall-deficient under it. The complete
  relation needs no incidence data at all and its Hall condition collapses to the single inequality
  `|consumed| ≥ |created|`; with the charge accounting proved, strict support descent is exactly
  strict inequality there. **So the live proof object is a counting statement, not a matching
  statement, and the matching engine is a verifier rather than the algorithm.** Over `𝔽₁₁` the
  inequality is verified exhaustively across all 1,560,900 legal size-four states and all 10,890,000
  complete exchanges, with zero failures, while strict support descent *alone* is false there —
  363,000 exchanges leave the support flat, and in every one the overload coordinate drops to zero, so
  the correct well-founded coordinate at that field is the lexicographic pair. The decisive fact is
  that `𝔽₁₁` is game-semantically empty: every defect-creating exchange has a zero-overload successor
  and every such successor is a first-player win, hence lies outside every sound survivor set. **No
  complete old-labelled exchange creating a new defect can be part of any sound survivor strategy
  there**, which upgrades an earlier sampled observation to an exhaustive theorem, certifies away
  every previously reported Hall failure at that field as sitting on a dead position, and means no
  amount of searching at `q = 11` can produce the counterexample the acceptance gate asks for. The
  degeneracy is a legal-density coincidence of the small field: a size-six residual there has about
  1.2 legal moves and no positive overload, against 5.4 moves and three percent positive overload at
  `q = 13`. The search therefore moves to `q = 13`, the smallest field with content, where a
  deterministic 20.7-million-exchange sample gives strict surplus every time with no equality cases
  and no failures under either relation. That is a large sample, not an exhaustion, and there is no
  proof.
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
odd `q ≤ 43`; saturated-external branch uniformly closed; **saturated-internal branch now empty over
every prime field**, via the dual 3-net model and a classical net classification, with only proper
extension fields left; nonsaturated branch reduced to slack `≥ 2`, and the complete `k=12`, `k=13`
and `k=14` layers impossible over every finite field, so no `k=15` census is planned. The exact
remaining obstruction is a clique bound
`m(q) < √(2q) + O(1)` for a Paley-type graph on the points off the conic, measured to be tight
rather than generous — so it may be false for some `q`, and that possibility is itself the finding.
The two live gates are now structural rather than combinatorial: prove that the stacked
Cartier–Toeplitz kernel locus `ker 𝕄_R` is a proper rank-drop stratum outside the three
row-count-forced fields `q = 25, 27, 81`, and rule out disjoint zeros of the first non-shadow
map on it — a pure quadratic for `p ≥ 7`, mixed quadratic/cubic only in characteristics three and
five. The older clique bound `ω(Γ_q) ≤ (q+1)/2` and Baer-subline stability remain valid targets but
are no longer the frontier.

**Clebsch publication:** the three released papers have cleared their mathematical gates and what
remains is external. The rigidity paper carries the golden orientation as well as the
reconstruction, and its companion carries a five-mode claim ledger; the trade-rigidity paper derives
the one-factorization split rather than assuming it; the passages paper has closed both of its former
proof gaps, states its orientation bridge relative to an explicit marked datum, and its forward
version has absorbed a bounded golden-operator core. Each still owes an immutable artifact locator,
and the passages paper also owes author affiliation/contact metadata. The rigidity paper no longer
imports either Dye statement, so its permitted-axiom list is empty; what blocks calling it
theorem-complete is the companion export route, not the mathematics. The passages paper owes two
things from the two-graph audit before its next revision: the descendant-correspondence citations,
and a decision on whether its faithfulness theorem is a corollary of four-local graph reconstruction
up to complementation. The q13 passant-code paper is retitled, has a manuscript-only pre-release
deposited, and remains an active build: its expanded human proof and paper-owned evidence are green,
while full Lean closure and public release remain. The golden operator programme keeps its
proved source mathematics but is no longer chasing a manuscript of its own; its live obligation is
absorbing the five literature pre-emptions into whatever forward version consumes it. Keep the
modular sequel separate: its proved centre is the
Modular Gateway Theorem and its `q=7,11,23` realizations/boundary, not the refuted universal
metaplectic/theta roof.

**The stabilization epilogue now has its headline, and the open target has moved to the cycle
side.** Paper V is frozen at eleven warning-free pages with three independent cold reads green, and
its closing normalization–residue theorem identifies the golden orientation torsor with the exotic
`F₄`-gluing torsor. Downstream of that, every smooth `A₅` cubic in Roulleau's pencil is proved
universally `CH₀`-trivial with the integral Hodge conjecture for one-cycles, and `X × P¹` is proved
irrational for every smooth complex cubic threefold — unconditionally, through the Hodge-atom route,
and extended to genus-eight prime Fano threefolds by Kuznetsov's correspondence. What remains open
is the relative Chow question the epilogue does not need: the odd index of the relative rationally
connected Abel–Jacobi lift, an exact 1-vs-2 dichotomy, plus relative rigidification, deck descent,
boundary control, and a full priority audit. The `ν₆` route survives as a second, conditional proof,
and its genus-eight corollary is unconditional on the birational half. Nothing from the surrounding
research programme may enter the frozen numbered manuscripts before those gates close.

**The optimization compiler's next gates.** `ergodis` has cleared its automata-minimization gate
against published state-of-the-art tooling and its first quantum gate, and both frontiers are now
about *external* validity rather than about the mathematics. Several things are open. The
symmetry-reduction factors on exact quantum-code distance were measured on one solver's
branch-and-bound tree; solvers with built-in orbital branching may already recover part of the
reduction, and rerunning there is the gate on any claim outside this programme. The certified
semantic-symmetry frontend currently discharges only the generic orbit-cover obligation — it does not
yet check that a supplied feasible family or objective is genuinely invariant under the given action,
so a domain adapter that verifies those obligations and rejects corrupted invariance evidence has to
land before any external solver emitter is admitted, keeping soundness assumptions out of the
backends. And application-level crossover on hierarchical labelled-recovery workloads is measured
absent on small and sequential-query problems, so the workload class where compilation pays is
bounded from below but not yet characterized. A prior-art assessment against pseudo-Boolean proof
logging and the certified-automata-minimization literature found that the two literatures together
anticipate every individual component of the compiler's certificate bundle; what is unoccupied is the
pipeline, not any piece of it, which shapes how the work can be positioned.

Three newer gates sit on top of those. **The two winning scheduling routes have no automatic
selector**: the certified dual bound wins the row the dynamic program lost by four orders of
magnitude, and the dynamic program wins two rows the bound cannot finish, so choosing between them
from the instance alone is the immediate successor and belongs in the shape classifier. **The decoder
benchmark is not yet a real-usage benchmark**: it is the repetition code under unit-weight
phenomenological noise, with a fixed four-round window at every distance and instructions per decode
as the metric, where an operational decoder is governed by per-round latency and its tail under
circuit-level weighted noise. Rebuilding the grid — weighting it toward realistic error rates,
following the distance with the window, and reporting latency alongside instructions — comes before
any further tuning, and a directly measured stack ladder already shows the shipped configuration is
not the fastest one in thirteen of eighteen cells, so the standing comparison rests on something
slower than the kernel can do. **The causal line is blocked on a novelty argument** rather than on
engineering: the compositional lowering that would avoid materializing the carrier has to be written
against a published variable-partition coarsening line first, and that argument is the highest-value
unwritten piece there.

**Where the compiler is pointed next, and where it deliberately is not.** Three ranked target slates
were written and all are explicitly provisional. The first-ranked target is the exact quantum-distance
line as a sustained programme — finish the one open band, then sweep every published code under about
1,500 qubits whose printed distance is a heuristic upper bound — ranked first because nobody else in
the field runs the exact computation, and because there is no miss: an exact value equal to the
published bound is still the first certificate for it. Explicitly **not** pointed at the compiler: the
cap game on odd projective planes, where the missing piece is a proof object rather than a bigger
search; well-trodden classical geometry, where three same-day pre-emptions occurred during one
campaign; and continuous or structure-free search spaces. One methodological lesson is recorded
across all three slates and is worth more than the rankings: **proved reductions beat hardware** — a
single-level lemma plus one fast path took one cell from a 600-second timeout to 0.14 seconds and
turned an out-of-budget region into a 190-cell sweep, which is more reach than ten waves of raw
search would have bought.

**Adjacent problems, opened deliberately and bounded.** For Hadamard order 668, 25 of the 30
mod-3-compatible fixed common multiplier subgroups are impossible — a published 21-subgroup
proof-carrying baseline reproduced, then extended by a nine-compression congruence and a shift-111
orbit lock whose exact six-case census also proves the lock is exhausted on the five survivors. Every
order-six subgroup is closed and the paired residual cases are the live target. No Legendre pair and
no matrix of order 668 is constructed here. Existence at order 668 was settled externally on
2026-08-12 (an Anthropic team's announcement covering all twelve previously open orders below
2000, method undisclosed), so the residual census now bears only on the Legendre-pair question at
length 333. A companion attack on
`M(18) ∈ {57,58,59}` by Seidel-spectrum census is queued and has produced nothing yet.

With a separately posted order-2060 matrix also checked and classified, **the smallest open admissible
order is now 2092 = 4·523**, and the work there is deliberately reframed from a construction race into
**class exclusion** — certified statements that no matrix of a named structural shape and multiplier
symmetry exists. On the bordered route four multiplier shards are closed by proof or exhaustion, one
of them by exhausting all 2,496 admissible roots over more than five billion probes with an
independent enumeration oracle confirming, and a uniform level test empties 148 of the 167 nontrivial
multiplier units outright. On the plain route the admissible parameter sets are exactly the 33
representations of 2092 as a sum of four positive odd squares, and an exact size congruence proves
that no supplementary difference set on the cyclic group of order 523 is invariant under any
multiplier subgroup of order at least eighteen, which closes the cheap cyclotomic tier by theorem
rather than by search. Two negatives are labelled as searches rather than theorems: an unrestricted
campaign of 288 billion mutations never beat a fixed residual, and — more usefully — a four-norm
argument **proves that no congruence of any modulus can ever exclude the surviving patterns**, so
only a lattice or counting argument could, which tells a successor where not to look. One incidental
construction fell out of the improved local search: a certified Hadamard matrix of order 388,
obtained through an exact per-swap delta identity that is proved and transfers to the bordered
sectors.

**Two further adjacent problems were opened and reported with their negatives.** Brouwer's complete
census of exceptional complete exterior sets of a conic was reconstructed and this programme's
invariants run over it, producing a bridge between two literatures that no located work cites
together: the exceptional configuration at field order 31 *is* the Clebsch hexagon with its ten
Brianchon points, so that census's entries at field orders 11 and 31 are one projective figure at two
completion levels, and the two equations `6 = (q+1)/2` and `6+10 = (q+1)/2` each have one solution —
which is why the icosahedral group appears exactly twice in the census. A previously declared null
was refuted with it: the ten-vertex, fifteen-edge match is *not* forced by an arbitrary six-arc, since
the Brianchon count over the 453 six-arcs of that configuration ranges over `0,2,3,4,6,10` and at
three other field orders the best six-subset never reaches ten. **The figure itself, however, is
pre-empted**: a full-text reading of Dye's 1991 paper, checked against page images rather than an
optical reconstruction, shows he already proves the figure, its chord structure, its stabilizer, and
the exact congruence deciding whether the Brianchon points are external. The contribution is
therefore stated as the census bridge, with Dye cited for the figure. For projective planes of order
twelve, two classical eliminations are certified — no point-regular collineation group, by a
multiplier-orbit certificate plus an exhaustion of `1.18 × 10¹¹` nodes, hence every prime-order
collineation fixes a point and a line — while the target case is not: the order-thirteen-invariant
hyperoval survives, and the exhaustion shows that **assuming the hyperoval makes the problem strictly
harder**, shrinking the exploitable symmetry and raising the survivor count. What is kept is an exact
reformulation, a lossless reduction from eleven-factorial to 139 classes, and a new bridge to
one-factorizations and starters; the successor route there is algebraic rather than combinatorial.

**How much an aligned reconstruction costs.** The passages paper proves aligned four-sets determine
a two-graph; the quantitative version asks how many alignment tests that takes, where a 4-set is
aligned when its four triples carry equal `τ` and a two-graph on `n` points carries `C(n−1,2)` bits.
Adaptively the answer is exact: an explicit decoder finishes in `C(n,2) + n − 4` tests on every
instance against a counting lower bound of `C(n,2) − n`, so the constant is `1/2` and the coherence
restriction is free to leading order. Nonadaptively the constant is bracketed,
`0.616n² ≤ minimum(n) ≤ (9/8)n² + O(n)`, the upper end replacing an earlier `3n² − 23n + 45`. That
upper bound is a proved construction rather than a search: nonadaptivity constrains the queries, not
the decoding, so a family can be a base on seven points plus one attachment layer per further point,
each layer assembled from blocks of four points at nine tests apiece, with correctness resting on
exhaustively computed attachment constants `g(5) = 9` and `g(6) = 12` from three independent solvers,
`g(7) = 15` exact and `g(8)` bracketed 15 to 17. A star-flip argument gives
`minimum(n) ≥ ⌈n·g(n−1)/4⌉`, which beats the entropy floor wherever `g` is known but caps out
there, and both natural lower-bound routes — the polynomial method and a covering argument — are
closed. Every exactly measured family costs 2.25 to 3 tests per recovered bit against a floor
licensing 1.2326, so the floor rather than the construction is the loose end, and the one mechanism
left worth trying is the distance distribution of the alignment code. None of this is in a manuscript.

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

**`ergodis`** (Rust library + CLI, with a Python differential-parity harness) — the exact
compositional optimization compiler described in §3, and the first tool here built to be used by
people outside this programme rather than only inside it. It compiles a finite algebraic optimization
problem's functional labels, conserved gradings, generated spans, symmetries and reconstructible
coefficient blocks into a smaller certified model, delegates generic search to an exact backend, and
independently lifts and re-checks the returned witness. Kernels cover linear-code recovery,
hierarchical composition, capacitated scheduling, and finite algebraic search; a certified
semantic-symmetry frontend compiles a finite permutation action into an orbit cover with one anchored
subproblem per coordinate orbit and no allocation during iteration, and a native exact CSS-distance
backend with parallel and persisted anchor search sits alongside the external solver adapters.
Unlike the mining toolchain above, it ships an optimization-reader entry document that assumes no
coding-theory background, fair pinned competitor benchmarks, and public-surface hygiene, and it is
being prepared for release under a dual licence with the observational compiler — and therefore the
published speed claim — in the freely available part. Its engineering discipline is the same as the
rest of the repo's: every run emits a compact certificate that is independently replayed and verified
before a result is returned, so a wrong quotient is detected rather than trusted.

It has since **left this repository**. The core crate now lives in its own repository, separated from
the research workspace that drives it, with the reproducibility evidence and manifest kept on the
private side and a filtered public snapshot produced by a guarded export; the manuscript that
introduced it now cites the external repository. Two supporting changes came with the move. The
research workspace became a proper multi-crate workspace whose task drivers are subcommands of a few
binaries rather than a hundred auto-discovered ones, with dead and banked drivers deleted and history
preserved; and every build tree moved out of the source trees, which found roughly 31 GiB of
unreferenced build cache. Two capabilities were prototyped on top of the core and gated: a certified
exact minimum-distance service with a live bracket, durable resume across machines, an up-front
feasibility estimate, and a verification mode; and a **certified infeasibility explainer**, which
answers an over-constrained roster with the minimal sets of tasks whose eligible resources are too
few rather than with the word "infeasible". On 78 generated instances that explainer matches the
planted ground truth exactly on all sixty infeasible cases and returns a median explanation in 0.40
milliseconds against 61.2 for an unsatisfiable-core extraction — but the commercially interesting
result is not the speed: on rosters with several independent shortages the solver's core is *smaller*
and deleting the tasks it names leaves the roster still infeasible, every time, while the decomposed
certificates restore feasibility every time. A core answers "is there a conflict"; a planner needs
"what are all the shortages, and who is short".

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
and matching-design closure, the exact PRS R5–R10 paper closure with its current scoped audit, and
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
  ladder up to the uniform pair-extension theorem, the exact R5–R10 projective-Reed–Solomon paper
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
assumed. **The two deliberate axioms are now retired.** Dye's ten-Brianchon bound and its equality
classification were carried as axioms in a single named module with an audited dependency split (the
`u + c = 22` bridge depended on neither), because no exact formalization of Dye existed in the pinned
mathlib tree or in any public Lean/Rocq/Isabelle archive — the Rocq geometry archive has incidence
planes, duality, Desargues, matroids, but no conic/Brianchon/Clebsch layer — so the choice was
between importing two precisely named statements and starting a separate formal-geometry project.
Both are now proved outright (bound over any field where 2 is invertible; equality classification at
order eleven, via the chord-matching bijection, the one-factorization, the hexagonal order lemma and
the golden normal form), the permitted-axiom entries are deleted, and the rigidity gate carries no
project axiom at any of its 201 axiom reports. The module keeps its `Q11DyeAxioms` name and
`ClebschDye` namespace pending a rename coordinated with the certificate package. One packaging gap
remains: sixteen modules of the order-eleven six-arc development are reached by no declared gate, so
the companion export cannot yet carry the new theorems downstream until an import-only gate is
declared over that development. The `A₃`/`H₃` synthesis is being closed
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

**Certificate packages now have a strict one-way boundary.** The heavyweight q11 and q16 finite
closures live in independently frozen, Mathlib-only packages under final branded namespaces. They
do not import the shared `finitegeom` library, and the monorepo does not import them. Registered
paper-local bridge roots alone may import both a human API and a frozen certificate, hash the sealed
aggregate artifact, and prove the transport theorem without rebuilding the certificate. Boundary
checks reject undeclared bridges, reverse dependencies, local-model escape, and a certificate fact
claiming a theorem proved only by its dependency. Paper I is pinned to the sealed q11 bridge. The
same architecture and final namespace map are fixed for the remaining projective q11, q13, and q25
families, but those migrations are not yet complete.

---

## 8. The publication track

The deliverable is no longer "the odd-plane prize, de-risked into stepping stones." An initial
packaging review resolved the then-existing body of work into **seven papers in ship order + two
OEIS entries**, staged under `papers/` with per-paper status maps. That fixed count is now
historical: the Clebsch work has resolved into five numbered series papers plus the unnumbered
MDS--CSS companion, with a separate source-development body behind it, while the projective Reed–Solomon theorem programme has become a major paper-scale
track of its own. The table below remains the original release-order backbone, not a current count
of every candidate manuscript.

The manuscript inventory below is generated from the manuscript sources themselves — titles from
each `\title{}`, page counts from the compiled PDF, statement counts and label counts from the TeX.
Do not edit it by hand; run `lean/scripts/paper-facts.py generate`. Its counts are what the sources
contain, not a judgement about what is ready: the ship-order table after it carries that, and stays
hand-written.

**Read the row count with three corrections, or it misdescribes the portfolio.**
`high_weight_grs_cosets` and `high_weight_grs_cosets_submission` are one manuscript in two typesettings, not two results;
`clebsch_hexagon_code` is the superseded integrated manuscript, preserved only as a fallback for
material the rigidity paper, its companion, and the trade-rigidity paper now carry; and two rows are
not papers — `golden_operator` is a source-lane draft feeding forward versions of the passages
paper, and `conference_cut_spectra` is the lane-local exchange-statistics companion written as a
design-limit and theory note. The generated rows now include Paper V and the registered
cubic-threefold manuscripts, but they are still not a complete portfolio count: the separate
*Integral Secant Distributions and Line-Code Obstructions for Complete \((k,n)\)-Arcs* manuscript is not yet
represented in that block, and the withdrawn conditional all-stabilization draft is not a current
paper. `passant_code_q13` is the fourth numbered Clebsch paper, and
`conference_cut_spectra` is a short note. The statement and label columns need the same
care: labels count anything labelled, and corollary-heavy papers inflate against theorem-heavy ones —
the arcs manuscript alone carries many corollaries alongside its theorems, so its label count is not
a count of independent results. Neither column measures depth, and none of them should be summed
across rows.

The finite-geometry portfolio also contains *Integral Secant Distributions and
Line-Code Obstructions for Complete \((k,n)\)-Arcs* under the alias
`integral_secant_arcs`.

<!-- trust-spine:begin area=papers section=manuscripts version=1 -->
| Manuscript                          | Title                                                                                                                                    | Lane               | Pages | Thm | Lem | Prop | Cor | Labels |
|-------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------|--------------------|-------|-----|-----|------|-----|--------|
| `ame_lu`                            | Local-Unitary Rigidity and Quantitative Rounding for Stabilizer AME States                                                               | `ame-lu`           | 37    | 10  | 14  | 9    | 11  | 62     |
| `arcs_complete_outside_conic`       | Arcs complete outside a conic: a prescribed-hole defect identity and matching-design rigidity                                            | `relconic`         | 27    | 9   | 4   | 5    | 22  | 79     |
| `high_weight_grs_cosets`                       | High-Weight Cosets of Generalized and Extended Reed--Solomon Codes | `reed-solomon`     | 42    | 11  | 13  | 24   | 7   | 94     |
| `high_weight_grs_cosets_submission`            | High-Weight Cosets of Generalized and Extended Reed--Solomon Codes | `reed-solomon`     | 31    | 11  | 13  | 24   | 7   | 94     |
| `blown_up_theta_lattice`            | Integral Cohomology and Modular Decomposition for the Theta Divisor of a Cubic Threefold                                                 | `cubic-threefolds` | 11    | 4   | 3   | 2    | 2   | 45     |
| `chordal_conference_reconstruction` | Chordal and Conference Cubics: Reconstruction and a Residual \(C_2\)-Torsor                                                              | `clebsch`          | 23    | 4   | 5   | 8    | 3   | 36     |
| `clebsch_factorization`             | Quadratic Trade Rigidity and Cubic Orientation in Conic Matching Quotients                                                               | `clebsch`          | 47    | 7   | 9   | 5    | 10  | 53     |
| `clebsch_passages`                  | The Clebsch Cubic: Hitchin's Icosahedral Double Cover and Conference-Matrix Rigidity                                                     | `clebsch`          | 39    | 7   | 0   | 4    | 0   | 38     |
| `clebsch_rigidity`                  | Reconstructing the Clebsch Code from Its Deep-Hole Syndrome Locus                                                                        | `clebsch`          | 29    | 4   | 1   | 9    | 4   | 34     |
| `clebsch_rigidity_companion`        | Computational strengthenings of Clebsch syndrome rigidity                                                                                | `clebsch`          | 29    | 7   | 2   | 2    | 1   | 22     |
| `complete_repair_ports`             | Exact Transfer of Bounded Linear Recovery and Relative Weight Hierarchies                                                                | `complete-ports`   | 24    | 12  | 0   | 9    | 2   | 69     |
| `conference_cut_spectra`            | Balanced Cuts of Conference Matrices: Squared-Spectrum Rigidity and Hermitian Holonomy                                                   | `golden`           | 16    | 6   | 0   | 2    | 1   | 19     |
| `continuation_graph_rigidity`       | Semilinear rigidity of four-point-frame continuation graphs                                                                              | `continuation`     | —     | 5   | 3   | 3    | 0   | 18     |
| `cubic_gluing_resolvent`            | The Discriminant Resolvent of the \(A_5\)-Cubic Pencil                                                                                   | `cubic-threefolds` | 11    | 1   | 1   | 3    | 3   | 22     |
| `cubic_stabilization_irrationality` | Sharpness of Irrationality after One Stabilization for Cubic Threefolds                                                                  | `cubic-threefolds` | 10    | 3   | 0   | 1    | 3   | 27     |
| `cubic_stabilization_m1`            | Irrationality of Cubic Threefolds after One Stabilization                                                                                | `cubic-threefolds` | 21    | 2   | 2   | 6    | 5   | 40     |
| `dihedral_schreier_node_kayles`     | Node Kayles on Conic Schreier Graphs: Dihedral and Polyhedral Templates                                                                  | `dihedral`         | 19    | 15  | 4   | 4    | 5   | 90     |
| `discrepancy_one_flips`             | Standard Flips of Discrepancy One: Extremal \(J\)-Normalization and the Meijer Aperture at \(\nu=1\)                                     | `clebsch`          | 12    | 3   | 6   | 2    | 3   | 34     |
| `equivariant_robust_completion`     | Frobenius-equivariant pair extension and robust repair of eight-arcs                                                                     | `paper-frob-eq`    | 17    | 5   | 2   | 3    | 7   | 37     |
| `golden_operator`                   | The golden conference operator and its shadow sisters                                                                                    | `golden`           | —     | 7   | 1   | 3    | 2   | 14     |
| `hodge_atom_marker_ledger`          | Hodge Atoms as Occurrence-Indexed Marker Ledgers                                                                                         | `cubic-threefolds` | 6     | 3   | 0   | 0    | 1   | 26     |
| `integral_secant_arcs`              | Integral Secant Distributions and Line-Code Obstructions for Complete \((k,n)\)-Arcs                                                    | `relconic`         | 21    | 5   | 9   | 5    | 4   | 103    |
| `mds_css_transversal_groups`        | Diagonal Isoduality and Transversal Clifford Groups of MDS--CSS Codes                                                                    | `ame-lu`           | 23    | 7   | 4   | 5    | 3   | 42     |
| `passant_code_q13`                  | Reconstructing $\PG(2,13)$, its conic, and polarity from the minimum words of a binary conic code                                        | `clebsch`          | 16    | 1   | 0   | 1    | 0   | 12     |
<!-- trust-spine:end area=papers section=manuscripts -->

| # | Paper                                                | Lead                                                            | State                                                |
|---|------------------------------------------------------|-----------------------------------------------------------------|------------------------------------------------------|
| 1 | Games flagship — cap/Nofil outcome classes           | the classification **with its exact method boundary**           | core P-theorems Lean; projective section unwritten   |
| 2 | Node Kayles on Conic Schreier Graphs: Dihedral and Polyhedral Templates | exact nimbers for an explicit infinite family | rebuilt as LaTeX on a spine; owes a value fix |
| 3 | Arcs complete outside a conic: a prescribed-hole defect identity and matching-design rigidity | defect identity → rigidity → stability | local candidate + scoped Lean; archive gate |
| 4 | Reconstructing the Clebsch code and its golden orientation from its deep-hole syndrome locus | conic-filling rigidity, gaps, decoding, universal chord defect, golden orientation | human core + computational companion, synchronized release gates green |
| 5 | Exact Transfer of Bounded Linear Recovery and Relative Weight Hierarchies | associated shortening–puncturing pair, exact rank-stratified helper costs, ungated transfer, and associative composition | 24-page verified standalone candidate; algorithm/bound development active; publication gated |
| 6 | Frobenius-equivariant pair extension and robust repair of eight-arcs | every invariant eight-arc in `PG(2,25)` pair-extends | extremal gate cleared; bookkeeping + graph remain |
| 7 | Semilinear rigidity of four-point-frame continuation graphs | `Aut(frame graph)` = ambient semilinear group, `q ≥ 13` | manuscript complete; Lean planned; audit gated |
| — | High-Weight Cosets of Generalized and Extended Reed–Solomon Codes | arbitrary-redundancy top-two-shell classification + sharp R5–R7 refinements | 42-page archival and 31-page TIT builds; local release gates green, public revision unset |
| — | Local-Unitary Rigidity and Quantitative Rounding for Stabilizer AME States | LU-to-LC for every stabilizer AME state, plus cleaning-based rounding and logical (8\varepsilon) rounding | corrected local release candidate; generic Lean core, mirrors synchronized and unpushed |
| — | Diagonal Isoduality and Transversal Clifford Groups of MDS–CSS Codes | multiplier nullity selects the exact fixed-party transversal logical group | 23-page deposited candidate; own semantic Lean gate, axiom audit, and claim manifest |
| — | Golden descent and operator realizations of the Clebsch cubic (Clebsch III) | one oriented coordinate line behind both realizations, rational branch closure, triangle--Pfaffian recognition, and a bounded operator core | v1/v2 released under the earlier title; forward human proof and standalone manuscript green |
| — | Quadratic trade rigidity and cubic orientation in conic matching quotients (Clebsch II) | the conic-ideal factorization quotient and its `B₃/H₃` completeness, with one-factorization derived | v1/v2 released; repaired all-field human proof and local export green; formal strengthening active |
| — | Minimum-word reconstruction of `PG(2,13)` from a binary conic code (Clebsch IV) | weighted pair concurrences among minimum words reconstruct the marked plane and `PGL(2,13)` | 15-page standalone manuscript; human proof green; full Lean closure and public release remain |
| — | The Golden Companion Correspondence (Clebsch V) | the chordal and conference cubics share one invariant pencil, and a marked chordal line gives the exact oriented return | 11-page warning-free standalone; self-contained finite evidence and human proof green; Lean deferred |
| — | *(not a paper)* golden conference operator source programme | one operator, and the cubic/polar/determinantal/fermionic/anomaly/lattice shadows it generates | source lane for Clebsch III forward versions; five literature pre-emptions to absorb |

The arcs manuscript was retitled when it acquired the zero-defect matching-design capstone that
earlier work identified as the missing structural complement: `ρ_𝒞(16) = 9` is now an application
rather than a headline.

**The Clebsch assignment changed on 2026-08-10 and supersedes every earlier description of it.**
The public series has exactly **five numbered papers**: rigidity, factorization, the passages paper
(now titled *Golden descent and operator realizations of the Clebsch cubic* in its forward version,
with released versions one and two immutable under the earlier title *Arithmetic and harmonic
realizations of the Clebsch cubic*), the q13 passant-code paper, and *The Golden Companion
Correspondence*. The first three have GitHub and DOI releases at versions one and two; further
strengthening is by forward version only. Papers IV and V have clean standalone manuscript packages.
The separately titled MDS--CSS transversal-groups paper is an unnumbered companion whose Clebsch
code is a worked application. **The golden conference operator is no longer a manuscript** — it is
a source-development body feeding forward versions of the passages paper, and its first integration
took only the source-operator-cubics-harmonic core plus the determinant-versus-permanent boundary.
Its exchange-statistics material sits in a separate lane-local companion, written as a design-limit
and theory note rather than an experimental proposal. **The stabilization epilogue is a manuscript
but not a numbered paper** — one unnumbered, independently readable companion downstream of Paper V,
whose headline is proved and whose remaining relative, descent, boundary, and priority gates belong
to the surrounding research programme rather than to it. The second
stabilization manuscript, *Sharpness of Irrationality after One Stabilization
for Cubic Threefolds*, is also unnumbered and replaces the withdrawn conditional
all-stabilization draft. The Paper-I computational companion stays
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

**A software deliverable now sits alongside the manuscripts.** `ergodis` is not a paper artifact in
the sense the rest of this section uses — it is a general tool whose primary audience is optimization
and verification practitioners, and its speed claim is checkable by anyone with the published
comparison inputs. It is licensed AGPL-3.0 (the surrounding manuscript stays MIT) and is being
prepared for release under a dual licence, split so that the observational compiler — the part the
published benchmark exercises — is in the freely available half and depends on nothing withheld, with
no dependency edge from the public part into the reserved one.

**That split has now been executed, and the guard around it is enforced by tooling rather than by
care.** The core crate was extracted into its own repository with its history replayed rather than
squashed, the research workspace kept separately with its full history, and the evidence tree kept on
the private side because moving it would have broken the manuscript's canonical replay and its
checksum manifest. A public snapshot is produced only by a filtered export; a lint rule set, an
export script, a staging clone whose push destination is deliberately parked, and independent
pre-commit and pre-push hooks stand between that snapshot and any publication. The guard is tested
the way a solver is tested: a fixture suite in which every refusal — task identifiers, process
documents, private path fragments, oversize files, a dirty tree, an unrecorded tag, a broken replay
command, a push to the public destination from a fresh clone — is exercised and passes, all 44 of
them. Fresh-clone validation across the resulting repositories passed thirteen checks outright and
repaired three, one of which revealed that the manuscript's canonical evidence replay had **already
been broken in this repository** by an earlier file move. The public export tree carries one
remaining lint finding, recorded rather than suppressed. **Nothing has been pushed, released, or
given a remote**; branch protection and one credentialed verification remain, and both are reserved
for an explicit authorization. Two pieces of homework were done before the split was designed. A per-vertical intellectual-property review found the quantum
application area free of relevant patents, the storage area the only one warranting paid
freedom-to-operate work, and patent-eligibility the dominant risk overall. A prior-art assessment
against pseudo-Boolean proof logging and the certified-automata-minimization literature then found
that between them those two literatures anticipate every individual component of the compiler's
certificate bundle; only the assembled pipeline is unoccupied, which is a positioning constraint
rather than a defect.

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
