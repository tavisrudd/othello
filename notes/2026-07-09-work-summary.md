# Repo Scope Summary — `othello` workspace

A cross-thread synthesis of scope, agenda, results, dead ends, frontier, and tooling.
(Companion week-by-week activity log: [`2026-07-09-work-summary-timeline.md`](2026-07-09-work-summary-timeline.md).)

---

## 0. What this repo is

It began as an **Othello/Reversi engine** (Python package + a high-performance Rust port with an
endgame solver). That engine still lives here and still passes its gates, but the work now is a
**combinatorial game theory (CGT) research program** on a family of impartial *placement / avoidance*
games, backed by:

- a fleet of exact solvers (Rust + Go + Python),
- a bespoke game-tablebase + query/mining toolchain,
- a `sorry`-free **Lean 4 / Mathlib** formalization layer.

The center of gravity is the **projective cap ("Nofil") program** and its **odd projective-plane
kernel**, with the Lean layer certifying results as they land. The cap machinery has also begun
**spinning off standalone finite-geometry and coding-theory deliverables** — extension, rigidity,
and completion-distance theory about geometric *legality* rather than game value (see §3, §8).

---

## 1. The unifying frame

Every game studied here is one object: an **impartial, normal-play building-avoidance game on an
incidence hypergraph**, where legal positions are *line-capacity independent sets*. Given points,
line families, and per-line capacities `c(L)`, a move adds a point keeping `|S ∩ L| ≤ c(L)` for
every `L`; the last player able to move wins. `P` = second-player win; `N` = first-player win.

| Instance                      | Capacity / lines                           | Reduces to                               |
|-------------------------------|--------------------------------------------|------------------------------------------|
| Non-attacking **Queens**      | capacity-1, four affine directions         | Node-Kayles on the queen graph           |
| **Cap / Nofil** (aff./proj.)  | capacity-2, all lines of a finite geometry | Nofil on the collinearity-triple 3-graph |
| **Sum-free** on abelian `G`   | Schur-triple hypergraph (`a+b=c`)          | Nofil on the Schur 3-graph               |
| **Cap-set** on `F₃ⁿ`          | capacity-2 (`a+b+c=0`); `STS(3ⁿ)`          | affine cap game                          |
| **Node-Kayles**               | the capacity-1 / saturated-residual limit  | itself (the substrate)                   |

**Novelty posture (deliberately conservative):** a *structured finite-incidence subfamily* of the
published Sieben / Huggan–Huntemann–Stevens (HHS) hypergraph building-avoidance genus — **not a new
class of games**. The bare "Nofil = Node-Kayles on a saturated residual" collapse is prior art; only
the *structured* collapse (residual slacks, mirror obstructions, conic localization) is claimable.
Transfer runs **queens → cap** only, and the `c=1` mirror facts are folklore — only the `c ≥ 2`
mirror/slack analysis is new.

---

## 2. The five threads

| Thread                  | What it is                                        | State                                      |
|-------------------------|---------------------------------------------------|--------------------------------------------|
| **Projective cap**      | `PG(n,q)` cap/Nofil outcome theorem               | **Active frontier.** Odd-plane kernel open |
| **Queens**              | Non-attacking queens game + A344227 nimbers       | n=18 outcome solved; G(18) nimber open     |
| **Sum-free / cap-set**  | Achievement game on abelian groups / `F₃ⁿ`        | Core theorems proved + Lean; one slice open|
| **Node-Kayles**         | Graph/Cayley substrate for all of the above       | Outcome laws proved; classic opens remain  |
| **Othello**             | Rust port of the Python engine + endgame solver   | Stable, gate-green, effectively archived   |

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
  instantiations statement-level.)* **Boundary theorem:** odd ambient dimension is necessary but not
  sufficient — the isometry group must contain an fpf involution (elliptic/parabolic/Hermitian are
  *mirror* negatives; outcome may still be P by other means).

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
hypergraph), gated on a specialist prior-art audit. Four connected theory families landed:

- **Baer-equivariant arc extension.** Over `L = F_{s²}` with Frobenius `τ`, the fixed blocked set of
  a `τ`-invariant `k`-arc is an exact *mixed cover* of the Baer subplane `PG(2,s)` — invariant secants
  (fixed-fixed chords + conjugate-pair mate lines) plus isolated conjugate-secant intersections.
  The corrected `(k,f)` fixed-point bound `B_{k,f}(s)` has asymptotically sharp leading
  term `(C(f,2)+e)s` (`s ≥ 23` uniform for eight-arcs). **Headline:** the quantitative
  conjugate-pair extension theorem — exactly `E = s²+s+1 − (f(s+1)−C(f,2)+e)` empty `F_s`-lines and
  `≥ E·((s²−s)/2 − M)_+` legal conjugate-pair extensions. Hence **every Frobenius-invariant
  eight-arc pair-extends for every prime power `s ≥ 7`**, and an equivariantly complete invariant arc
  with `k < s²+1` has size `≥ 1 + ⌈√(2s(s−1))⌉` — the `√2·s` orbit-saturation bound, the
  strongest extremal corollary (sharpness open). Quadratic extensions are exceptional: for prime
  Galois degree `≥ 3` no nonfixed orbit yields an invariant secant. The Galois-rank section
  formula identifies `ρ(S)` with **rank weight** over `L/F` (the mixed cover is its rank-3 quadratic
  case) and recasts MDS fixed-lengthening counts via a forbidden-normal rank enumerator. Prospective
  paper: *Equivariant extensions of Galois-invariant arcs over finite fields*.

- **Completion-core rigidity** (robustness theory for maximal feasible configurations). For a facet
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
value-blind reply selector.

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
- For **q ≥ 23** the live conic cannot be emptied at the two-ply layer (depletion ladder
  `live_on ≥ q − (t²+5t+5)`); one bucket (`1,3,4,9`) verified xor-zero-maintainable through one
  further coupled move (28,646/28,646 obligations). Termination not proved.
- **Even-dimensional odd-`q` (`PG(2m,q)`, m≥2) now has its first direct outcome:** **`PG(4,3) = P`**
  exactly solved in 3.7 s / 25,258 orbit-canon memo states, with independent
  move-order/canonicalization cross-checks. The uniform family remains open, and no second board
  in it has been solved.
- Prize: eventual uniform proof ~35–45%, de-risked into the D-items (§8). The q=25 unblind the upper
  half was contingent on is now **resolved all-P**, leaving the proof resting on the amortized-ledger /
  packet-absorption lever plus the value-blind smallest-orbit anchor; the next empirical dial is the
  gated q=29 census.

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

Two further namespaces formalize the §3 spin-off portfolio: **FiniteGeom** (the Singleton bound and
MDS predicate, Reed–Solomon codes MDS, dual/parity-check characterization, the moment-curve/NRC
general-position and hyperplane-section distance bounds, the hypergraph matching/transversal layer
`ν ≤ τ` and `τ ≤ p·ν`, the completion-distance identity `δ_x = τ`, and the strict `τ > ν` witness)
and **RepairCodes** (the bounded-repair concatenation-transfer lemma over the FiniteGeom code layer).
The finite-geometry & coding results of §3 are thus **now mostly machine-checked** rather than
pen-and-paper — the completion-distance / coding-recovery core is kernel-verified, and the
Baer-equivariant and continuation-rigidity lanes (with their external prior-art audits closed) are
being formalized against the same layer. This converts the portfolio's central claims from
audit-surviving arguments into kernel-checked theorems.

**Lean-open:** odd planes `q=3,9,17,19,23` (q=9 conditional on `IntruderTerminalReplyStatement`); the
**uniform** odd-plane `OddEscapeStatement` (only proved per-`q` via certificates — the intrusion
reductions carry explicit WARNINGs that their no-intrusion hypotheses are *false* for `q ≥ 11`); the
q=17/q=19 generated-cert path (blocked on a `maxRecDepth` refactor).

---

## 8. Publishable deliverables & OEIS

The ~35–45% prize (uniform odd-plane theorem) is de-risked into six independently shippable units:

| ID | Deliverable                                                           | Confidence |
|----|----------------------------------------------------------------------|------------|
| D1 | Outcome-classes paper (all proven families; odd-plane as conjecture) | ~80%       |
| D2 | Corrected capacity-≥2 mirror/pairing principle, Lean-checked          | ~85%       |
| D3 | Conic-localization reduction (first layer = Dawson's chess)          | ~65%       |
| D4 | Machine-verified per-q ladder + kernel-clean Lean formalization       | ~75%       |
| D5 | Sum-free achievement game on abelian groups (the `q=2` sibling)      | ~65%       |
| D6 | Extended non-attacking-queens nimbers past the OEIS horizon           | ~70%       |

Plus a **tooling methods note** (the tablebase-meets-CGT story; BuRR-as-lossy-store + the
PGL-quotiented key are the two fresh wrinkles, the rest competent adoption of strong-solving
technique). Paper in progress: a Nofil-genus skeleton (the `Z_n` mod-6 law + the affine cap theorem).

**Geometric & coding spin-off portfolio.** Independent of the odd-plane prize, the cap machinery has
produced a family of standalone finite-geometry / coding units (see §3). The common gate is a specialist
prior-art audit — several components are classical-facing, and the claimable content is the specific
robust refinement:

| ID | Deliverable                                                                     | Gate to a standalone claim                                  |
|----|---------------------------------------------------------------------------------|-------------------------------------------------------------|
| S1 | Equivariant extensions of Galois-invariant arcs (conjugate-pair + `√2·s` bound) | a sharpness / stability theorem for the `√2` constant       |
| S2 | Robust completion / deletion-distance theory (sharp deletion + exact `δ` families)| an exact `t_h(q)` bound or an NRC external-orbit spectrum    |
| S3 | Continuation-graph rigidity (four-frame semilinear rigidity + full-complex recon)| prior-art check; tighten the loose `O(k³)` thresholds       |
| S4 | Twisted-cubic–axis / Roth–Lempel LRC families (all-symbol `τ>ν` + transfer lemma)| citation-chain audit of the complete-repair-hypergraph claim |

The same objects also carry candidate **cross-domain applications** — a shared-dependency resilience
analyzer, robust experimental design, a repair-code compiler, canonical-reconstruction and
minimal-conflict engines, a proof-carrying finite-search platform. All are exploratory pending a
domain benchmark; the recurring, testable nonclaim is that path-counts / entropy / disjoint-availability
systematically overstate resilience when the alternatives share hidden dependencies.

**OEIS:** **A344227** (queens nimbers) sits at rev #54 (`n ≤ 13`); a ready package extends it with
`a(14)=0, a(15)=1, a(16)=0, a(17)=2`. **Submission is a pending user action, blocked on a public
code/preprint artifact — the repo has no public git remote.** A sum-free `Z_n` OEIS draft + b-file
(65 terms) is prepared, verified absent, not submitted. Candidates: torus-queens nimbers, sum-free
outcome indicator, Paley-game sequence, A316632 extension.

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
